Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51F67CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 14:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB6B8E0005; Wed, 17 Sep 2025 10:10:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983928E0003; Wed, 17 Sep 2025 10:10:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899938E0005; Wed, 17 Sep 2025 10:10:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 77EE88E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:10:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 113EC1A059F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:10:13 +0000 (UTC)
X-FDA: 83898926706.25.865A7A9
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf06.hostedemail.com (Postfix) with ESMTP id 605CA18000E
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:10:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ZKpSI+WP;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=TbymsR0+;
	spf=pass (imf06.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758118211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75mN+9VZdw4CLEq0UoX/nuXZgFL03Q5pomSFYWw9c2o=;
	b=SK0bqrlbjc0R8LcCaKHzSrx6IEI+RIjq8Oe/L5E/LYBDvMA3m9G0oG1m2C6cW2Gdb9DkvJ
	cwyv07aaSY9SDl/LpeM3pCu2prin0gHaKBTNh4EsGNXw5pkRGpxZw9zmk78YWGEF0XONUp
	F98QcVAelAZ6iuhI3ctbVdRFOF4C8WY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ZKpSI+WP;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=TbymsR0+;
	spf=pass (imf06.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758118211; a=rsa-sha256;
	cv=none;
	b=frWbuMgyjvu9/OSzDd5DtR1F3sm+js1HJJuQtJ+gWkyMtdsax5S/ys5Azk1agIAVPzJYOk
	QV+dl8QHfnzFOa2PTBzhklVnzAa8xHST2QKnJ8yszYG9+2Tfq6Ohye5BpDHpsS6kKdEWua
	mrYDshdkSM3YUb+OtEUbPpR9ECMbSdY=
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1758118208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=75mN+9VZdw4CLEq0UoX/nuXZgFL03Q5pomSFYWw9c2o=;
	b=ZKpSI+WPydnrumYQ7gxnajAs+lz48YaqiNN3+WhYNwWXlUic0xCBsG6f6GfE8taQbHcIgJ
	h7Kh1tpSx++CpIjdk2mOz5C8qrezCvij4Bk8iMJhmpa16eSQBcomARzZeXmkJinMK6glwU
	/UoCFWaheNWZeinES9gkwAgNZHQGwrhZjReOwblCiBhi00hbE5NYnMlrnONnM1S91JYtLJ
	5CckReOcFW3rJ1+heNZD7lLCRl+2mHJx7WPMA6JZ7bGl0gGxnrhAb0Qs6EzKVgYT+Ot1sw
	h1UyJfZDjAyn+2j60JTop8cvG2RTrlkVsVVpCCok6p2oOoIhbLO/tvfT4Jfbiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1758118208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=75mN+9VZdw4CLEq0UoX/nuXZgFL03Q5pomSFYWw9c2o=;
	b=TbymsR0+lk/yBTMUwla0JPYo6VaReyftRSNu6ml7UoTThH0F5HVkZGBsfwFUiwKRK5kBjM
	+sfN3Y9Q7FzbGVAw==
To: David Hildenbrand <david@redhat.com>, Eugen Hristev
 <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
In-Reply-To: <2bd45749-e483-45ea-9c55-74c5ba15b012@redhat.com>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-10-eugen.hristev@linaro.org> <87cy7q9k8y.ffs@tglx>
 <87a52u9jyl.ffs@tglx> <8df2cf28-c15e-4692-a127-6a5c966a965e@linaro.org>
 <2bd45749-e483-45ea-9c55-74c5ba15b012@redhat.com>
Date: Wed, 17 Sep 2025 16:10:07 +0200
Message-ID: <87v7lh891c.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 605CA18000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: nmyo5bwftcu9esrmtkmu6smgodb49wzs
X-HE-Tag: 1758118211-324772
X-HE-Meta: U2FsdGVkX18VzhMa6s7SJyFTVrR0SWSPSlL7RbB8Rqe4F9dhrwiMv6a7MnL+H03Lt3BmQv2qwWaaDmooMGPwC8BYdWZ1jFGGybOnqBbMMFMV0NNZjGfyUTwsoOPgyVorUVg65yhptu5HQ6TUqIEIjXbwx7xWAwJLY5/wg1GLCam8Q8kToZmwcwg/60B2R65148capG6qNegDyd3h64ihb/JyR9P/e2T85LrAnJEGr8TcIvq8MKdCxSnUvUMl7UxfDHFwpOMEoeLKPEjCwa8cVPglyWlJOjpGK5t8lJagqMCRN7Vpbruror54+0QZpilXw5Cxp89pGVYsKRdcG/HDHI6o46Ho9QOaNx8bolUCMkkEAzt72GzYSUO+oy9kXXrczxg2XIyLIafec4y0DGM2tHk3rGmPJ0LfFWmyH5MxxSPCA/mmSJr4m5hllOteNjNZxUAs5m3guK6okjkip0GgCEyOCK5Pzky3XDTDC3TcsfQpvpYzwinhEXycQrFGbwJ/B1Hfzvl+5ICNyXVbdyjmWjYCYyleRaWLuekilp2Kjezh9p++kmwPf1qFsjrD+nMfhPuefD40F6KZCiY9/yB/6q3eRGlgDs0FAiOFdS+vplk6TKzVCHlONBq/fawvTGsXWqIQozg4+7wh/JxotdXAkSXND+gmUCtrq0hQCZH8DjBcIVl0SU58HCF1lQDa4TOvrTOsqst/4OMEpDl1cmgQ5zvMou3M/1sU+8C+4E/Aga2RBPlqIGYSuhmGYHg7sOLTQBolvQTAt+8jOlloBbZYW3KfUL3XSxsxpWqOQAC03IHjnscIdh+e8mZz8Jq+rpBjlipP975XfQm4mmZTi7Xp+D/vuxz1c9YyYzF65l5VXzpzjOlK2ieZtGZHi5JmZiRWdKaNitBvBmrUIUJ3M05cpt3USd2yOW+meRNtJmm11SfUneaOtnTUAnioimYfFBfTbHgW6GSNgzajWBCBpEF
 HFC9i9A8
 Ogqp8T9z1QMrqbeQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17 2025 at 09:16, David Hildenbrand wrote:
> On 17.09.25 07:43, Eugen Hristev wrote:
>> On 9/17/25 00:16, Thomas Gleixner wrote:
>>> I pointed you to a solution for that and just because David does not
>>> like it means that it's acceptable to fiddle in subsystems and expose
>>> their carefully localized variables.
>
> It would have been great if we could have had that discussion in the 
> previous thread.

Sorry. I was busy with other stuff and did not pay attention to that
discussion.

> Some other subsystem wants to have access to this information. I agree 
> that exposing these variables as r/w globally is not ideal.

It's a nono in this case. We had bugs (long ago) where people fiddled
with this stuff (I assume accidentally for my mental sanity sake) and
caused really nasty to debug issues. C is a horrible language to
encapsulate stuff properly as we all know.

> I raised the alternative of exposing areas or other information through 
> simple helper functions that kmemdump can just use to compose whatever 
> it needs to compose.
>
> Do we really need that .section thingy?

The section thing is simple and straight forward as it just puts the
annotated stuff into the section along with size and id and I definitely
find that more palatable, than sprinkling random functions all over the
place to register stuff.

Sure, you can achieve the same thing with an accessor function. In case
of nr_irqs there is already one: irq_get_nr_irqs(), but for places which
do not expose the information already for real functional reasons adding
such helpers just for this coredump muck is really worse than having a
clearly descriptive and obvious annotation which results in the section
build.

The charm of sections is that they don't neither extra code nor stubs or
ifdeffery when a certain subsystem is disabled and therefore no
information available.

I'm not insisting on sections, but having a table of 2k instead of
hundred functions, stubs and whatever is definitely a win to me.

Thanks,

        tglx

