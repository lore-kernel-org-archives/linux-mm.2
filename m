Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EADB1CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 16:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5BA8E0056; Mon, 25 Aug 2025 12:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F488E0038; Mon, 25 Aug 2025 12:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E238E0056; Mon, 25 Aug 2025 12:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B910D8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:57:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70A33C042D
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:57:03 +0000 (UTC)
X-FDA: 83815884726.15.64A803D
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 956D24000F
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:57:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aaxX9KoA;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756141021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NAPZqISVKAEwgxkMeXQwIHHj6CxIXWWQHoJY30zQfUw=;
	b=Hu5GEh61b8XYq6G2o2o7gjQN64YkrOaN6DsBhMo/5orIjyj+v4/q5/zQjDKMGW9QZIOuYf
	7BCwxfVjZdtK44kLqnmB70qSxzJTczr/lsPlCMhpGKYqG5rNf31/TwlAzI37BbhGK2n2N5
	fvSFmhKFfO67QkkqaE0pPMvNCsO7j7U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aaxX9KoA;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756141021; a=rsa-sha256;
	cv=none;
	b=szlmJZMME3pZpDU8B1y83f5JBooixfdu4eC5oPXIp2Fv+AmBIuXdsg6YpjNdmg4uCOa7p7
	pb/PMW8J4hCz1cB3rbC9BieWErkt5iAfVrYRdXBaXQfuGsvM1yExH0ZSF+txF8N982LDz8
	3L47mgo34XmyhZVkGJ4Jmg5NtunNth0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756141019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NAPZqISVKAEwgxkMeXQwIHHj6CxIXWWQHoJY30zQfUw=;
	b=aaxX9KoAIRU7hcngB3MtEt3ChqHOEscLudD75M3s/FotORLWw0z+bT8E63I3g9xcvYi1hC
	kgZyTAHgJvVA9hIGN3LpAa/tnkfmm1xMAfH4tjAX3wkJx7ZBrzt2gHYLfwy941zbce25af
	HTyYBnyzuYVGc/CCcOGEwiEhB5kVriY=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>,  linux-mm@kvack.org,
  bpf@vger.kernel.org,  Suren Baghdasaryan <surenb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David
 Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>,  Alexei Starovoitov <ast@kernel.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 13/14] sched: psi: implement bpf_psi_create_trigger()
 kfunc
In-Reply-To: <c1b71664-91c0-439c-9cae-7407fa5b0358@linux.dev> (Martin KaFai
	Lau's message of "Fri, 22 Aug 2025 12:57:20 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-14-roman.gushchin@linux.dev>
	<CAEf4BzaSLWB1xpCjX35oxg2ySvvgRvEmQ01PtXv+xEz-Zkz07w@mail.gmail.com>
	<87ect5lde2.fsf@linux.dev>
	<c1b71664-91c0-439c-9cae-7407fa5b0358@linux.dev>
Date: Mon, 25 Aug 2025 09:56:52 -0700
Message-ID: <87h5xvxru3.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 956D24000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fibanupnfmyyfduhbxxxnnk6dbbag1p6
X-HE-Tag: 1756141021-989472
X-HE-Meta: U2FsdGVkX1+8df5TKY6eBN4yg/mLNgyHIUiJ/Vm8U1dmoqvGrAvdKYmldGTywgvI+Ymj3EFT0lKqp/Iiyq2SHa9dUjW543UUKTYW2fGYy+8gvOwK34SszPCkClYSsHt6PP3RWei8dIqcvaJpE4S7iIs3WO9jH2i68WmWJGwEcGDZ/8/OlnKOKsbW4jlZilZwBNyMa95dKDH21kEHaTaDIZXL9VFaEhM5yfVaao1FL21co4kb8RFmaYV/7CGZ5pXjJUfWwJLl+vLNt1JP3UdwVgfAQMc0NZGAVW9/O7YJQfG4C71vQL9Q7mHrNMFEW1UgH8F/DBQuEqouasqpQejODRGfMsbOIU9SqQ4/3EtVuXTZpJns+8sdbrIu76FmR4X8QWVbpjy7fwSA+QKiEZoW6g0dOTkebjuaRSaQ8jN1MJ290NnyAeoLxk6s2r8zjRGqkIjQaiSSf4tB2d8Xyoeasyqr1vFYzJiDtQbhBL7voWdnMgR/XX3dWBnfwEbHdj6BvJb+9FCvvl+FZk1N5MTCjq4U4csrM2ipSd9YBRnSzgW8Nu9nTtEoqj6jqLhq7CSg0VW3kxLsync5SJ2PNUPW6xCK/lPEl2WhJuueMeb4mRSMRob484W8+s2mGQ+bY6JccudbXSG087J0ARIMxIi/I6W8WO63zCTl2moyVkMF6wf+dynljjS0i5K0sACgk3oz8mkFxG6OSWSc8ApuO1CqYIbVMXhAGnkcXRJt9tsKb7rSvfPOpRMVlmSTtYyIeBPmdQ/kzRfSSUIgl/AZf1IiHgUInwbqEM0+jquNZ80wAzewkEMAxqoBqsEzo5k/0Qkeyuojl+MpopFiL7p4ufhcNlHOri8rXdj8Lqc6fWF8Jmncd7z4XPyL8l05HczQXajLxGFpdmZOJWyVKacY/+wnz9hurU2wSS2jgT750Cm37qGLWskrs/OwmVd8RB13eaL457p/f86klbOF2gMb2lf
 bOKCkfkW
 +HVs3hxKUnTaYmj6uGBRfpnjCLyd5YKb/V13NsuS59G0IDuG7i+aBcvHet4CEx4WrTstYTnsNJgsNEfQCLbNgrZDczeQFdxJRmDjCjpoHOn2yzWQ80eTTVYVgo0Xjv8/2BdnjWecFmEyFyZD5W262f/5fMoJahO8n7w/MdVArxbVNr1m6Y39AlN4ArNiif4831nwO1gHXcvYYy2amTTLSCYiDiSXpRlfU+69BeQjWwcT7Nq44uWhPfWdHgBQcuZp/nMzZeDh6bAKJ+DByPNasurBlQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Martin KaFai Lau <martin.lau@linux.dev> writes:

> On 8/20/25 5:36 PM, Roman Gushchin wrote:
>> It will. Idk how big of a problem it is, given that the caller needs
>> a trusted reference to bpf_psi. Also, is there a simple way to constrain
>> it? Wdyt?
>
> The bpf qdisc has the kfunc filtering. Take a look at the
> bpf_qdisc_kfunc_filter in bpf_qdisc.c.

Thanks! I'll take a look.

