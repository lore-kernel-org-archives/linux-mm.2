Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D84A5CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 17:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5E28E0006; Wed, 22 Oct 2025 13:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE728E0003; Wed, 22 Oct 2025 13:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3CE48E0006; Wed, 22 Oct 2025 13:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3CDC8E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:13:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B6581408A1
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:13:27 +0000 (UTC)
X-FDA: 84026396454.01.A9794E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BC81B180011
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:13:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=fM26tfZs;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761153205; a=rsa-sha256;
	cv=none;
	b=EUMCvBnLdH/4kttPqooQoKEDwb+/c40iiW8g07XnJv7sj+mgCX0qnGAm/7jzkUXpTd6fbh
	xH4Qt00ahLqpdM3+ZM/NL652w1YqM3UvCc5nKCPTscP6MQmvhGgVLr7oQ98pYduv+Voj41
	fX8jkIi40VOMjR4QWtCUAajMysuynJ0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=fM26tfZs;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761153205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUO+eclc0lznNKUH1RT4OMIbI0woMdjn+ZOXEPO2Om4=;
	b=lCfYsJwgU6oDIVnZSXP27DLFutjIqYhKAZdmZXmV3ln/8cP5tZrd56dswL71nyi01b1C+6
	E+E7lEN8aCTAbN6NLdNLPKOrgkItnvbF4ixZG1jjlbOmVxUEEiCezNNoILiHUHk7iVIHKE
	jLliPpHbMvQTq1eYB55lhe7WeHXirwE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 234BE62165;
	Wed, 22 Oct 2025 17:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FAAC4CEE7;
	Wed, 22 Oct 2025 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761153204;
	bh=Oc5cL4PM3GS59XiGaVYHm7x2QglMaN7Tq26+NOil5DE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fM26tfZs84ldeAddOmNXArn5RbP7iEp+oNUSPg92OafLdEp2A2CltfwxTYDTDbSBt
	 yhtDIrkROBstCq84hJRIv0uvNE852TNVAVBfnIvhjfb5K+f+sBF1WJ88PbKKep8MPs
	 rsTBFdIzM2FKvPUMhlYOGddUPz2hWCETV98K98SI=
Date: Wed, 22 Oct 2025 19:13:19 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Gabriele Paoloni <gpaoloni@redhat.com>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	safety-architecture@lists.elisa.tech, acarmina@redhat.com,
	kstewart@linuxfoundation.org, chuckwolber@gmail.com
Subject: Re: [RFC PATCH v2 0/3] Add testable code specifications
Message-ID: <2025102211-wolverine-cradling-b4ec@gregkh>
References: <20250910170000.6475-1-gpaoloni@redhat.com>
 <2025102111-facility-dismay-322e@gregkh>
 <CA+wEVJZEho_9kvaGYstc=5f6iHGi69x=_0zT+jrC2EqSFUQMWQ@mail.gmail.com>
 <2025102124-punctuate-kilogram-da50@gregkh>
 <CA+wEVJajSGzb85YTiv98yAY3bcJFS0Qp_xjLc++wnU8t=wDAOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+wEVJajSGzb85YTiv98yAY3bcJFS0Qp_xjLc++wnU8t=wDAOg@mail.gmail.com>
X-Stat-Signature: ecw3m6wytawy4cshkmy33gdhsanw3qaq
X-Rspamd-Queue-Id: BC81B180011
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761153205-961130
X-HE-Meta: U2FsdGVkX1/jJ/06KWfcsAroeRD8LnRnCzidDIr5iRtTDLEkULNK+aIR5GhJx85uFWos+I2qH4i2Ti3DEn2XL0M+wccrn6fUQ5GI6eRZ83sCaHy3xiy8UK3qiamhLRs5+1CJrcrme3l05NLHdyxNvbUeB8fAtzAaB6qdAqbHe/grLw6uggNFjqjfsjFVbCgWE0rqV2ecsZFTXzCEFDGwhfwmPtNi6oX2wYdbWEDOcmGNgXG7A3XflBWvEue5sm7ir2CBKXFWhpJh3Q4q5ykcqVddD71pB9p9XcAWqf4ywL2CG9Q+MRDpcPEF8uv72CHf5q8t9zhi72B6IZgQEGVQgYgFEoqyKMaPXVmQ0YA1DikVa/poRWCP8jCzcdbcFmHx4YguGHM5qsNzEuGak72u7adGcTJG6TPon78l2kT8F4X0oAnlmr1px68UH5r2jHY9NaldTeNxoM0ctMtC7mYd7JBVky8fEzj5X4vY/OmhFVQ904GEnVaZRenj7Y4ZZdDozYITEUhWgGkb+tDjZwSngVcrbtQtetr6B9QQPUWt4VAzl47Flrs5TTQMIpej0S2Dg4zOLd+hXtVwmbsh9s58voaVWHpGKEYXGYXlj4MrYeabVmKw5faxk0qg/VHmqJJBzgF4LN/Yk7SR3hIPg5mdTPYQvpsNniHtXskslYK4oniWv6RkxCy7UACMJelmGHud6SuObFsIyMji8kslr+314aVksGEG1T1UJCrxhBMR02Ub4EgEjGwGpwXk7ocHFcRSyrHfy9f1dJIv+rcKK9zkIr6ZgJs/mcAiqVUwikcCKcIiVBQsUmAKvv5ND2oS7lZRWKfRy/iJSGEe+Rozmu1+WCDXdWZtqTvDux4opKNidX6YPAYcbWmEO3us2Pvx0+uzGlWLe7k9TTd1o7evfMSKojYi7YgSsDeJpZjH6gET2f3CV0DeZQZ4lwN7cmIAcuQew0F/yiaHWiO63pstXnA
 PwJWjJh6
 xzFwgaSASBc5zWgodmNeBe5xLeaTVfMHikjBLumzdzC/6fllMUEzb1a4sS/YOpQk1fOm8RxnaNFPuKw0Ci1UdTLMS258gExWMdqw2txtYDrk/hjRLZbYn06sxXx2NzSvKPGoVcElmYkdAB8fX8Y7QirIkkqZACaGBGlj0j7Lh/XLsak3yG/fabHy2usNZPm4XSNmFL4hYdaVJS3oXedZtmXZ81gM6MnXwRkClvreY3o7G86H9dZTIMDihk2s5Cz4JdDsxumvFxilZKfWuIkkgtRKI305uOSTETGRlfETohR3RKDagPYG55u0sEnDYAIQOLTG6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 04:06:10PM +0200, Gabriele Paoloni wrote:
> > Every in-kernel api documented in a "formal" way like this?  Or a
> > subset?  If a subset, which ones specifically?  How many?  And who is
> > going to do that?  And who is going to maintain it?  And most
> > importantly, why is it needed at all?
> >
> > For some reason Linux has succeeded in pretty much every place an
> > operating system is needed for cpus that it can run on (zephyr for those
> > others that it can not.)  So why are we suddenly now, after many
> > decades, requiring basic user/kernel stuff to be formally documented
> > like this?
> 
> Let me try to answer starting from the "why".

Let's ignore the "why" for now, and get to the "how" and "what" which
you skipped from my questions above.

_Exactly_ how many in-kernel functions are you claiming is needed to be
documented in this type of way before Linux would become "acceptable" to
these regulatory agencies, and which ones _specifically_ are they?

Without knowing that, we could argue about the format all day long, and
yet have nothing to show for it.

And then, I have to ask, exactly "who" is going to do that work.

I'll point at another "you must do this for reasons" type of request we
have had in the past, SPDX.  Sadly that task was never actually finished
as it looks like no one really cared to do the real work involved.  We
got other benefits out of that effort, but the "goal" that people
started that effort with was never met.  Part of that is me not pushing
back hard enough on the "who is going to do the work" part of that
question, which is important in stuff like this.

If you never complete the effort, your end goal of passing Linux off to
those customers will never happen.

So, try to answer that, with lots and lots of specifics, and then, if we
agree that it is a sane thing to attempt (i.e. you are going to do all
the work and it actually would be possible to complete), then we can
argue about the format of the text :)

thanks,

greg k-h

