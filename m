Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE44D3B7DD
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 09:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4EE6B0007; Mon,  8 Dec 2025 04:27:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78C2C6B0008; Mon,  8 Dec 2025 04:27:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3346B000A; Mon,  8 Dec 2025 04:27:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 585756B0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:27:01 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06C04C0A4E
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:27:01 +0000 (UTC)
X-FDA: 84195774642.13.54649D0
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 19966180007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:26:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jpozLZCD;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765186019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFLfpZ5l4wRVBkAGkPslmSuVObNJ4meI7Eg1f2GcF6M=;
	b=CLPwdvZwt3QVSjfKxlpb1TkqVrHBGwTEjKSarjIR5c0h+iA37fD5pFsRR7rghzaNHa65bM
	NWsYmApRlCOFNiBK4PuqLaMInNVsa7Fn1f8MO2Wv7Vx/Z8jNUoAkSOvK6lRImf3E0rbrLz
	bsOpD1USXSljCrHSkubJvIdMqpBLZ04=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jpozLZCD;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765186019; a=rsa-sha256;
	cv=none;
	b=KhjCVycfPE6w2Go9oxIyaY1m3q3N80O50ZJk6olgyXjR0MVuhNskVZB4RX3fgs3V/VyMMW
	XKPiW0yE1ihi+XgK26qMcXqWjBPW1SyORyYjTcOBBV7PWKlSSXdNqQvWR+SWAWuNM9imRf
	uACw2Xo0rXutF0CV718b5zRq8dp2IBw=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47775fb6cb4so35010265e9.0
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 01:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765186017; x=1765790817; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NFLfpZ5l4wRVBkAGkPslmSuVObNJ4meI7Eg1f2GcF6M=;
        b=jpozLZCDmSd/CXsCpSRz5bY5R+VMEQBXix/YvNTqQDaRdp9draogIQfLjrQpGF+bJ3
         ruA9r0ppSIa8GIE8NoIELLZn508mDTe2fOdd1l+2hNMzZueztj5MSwcMAEyxX5mOhujj
         F/esQ2h1FTZWyfSwF4B0DhM5ZTZg8nnwfa8ONbZY/C0bT1Bjkhtp+v81l1Aml9TMQR1K
         dfbE1YEu024gChlaBNn1yWDrvBm8iHPRSzEeEx7SNGP9FLHbl60RHcZgoXvlrVoW0O38
         yoPcZFwX5Oropx8BOuB3Ow2xzRfRiAW0O64JEQcDyYKjPCkYNsY2oj7w2gygWb6Vk7yl
         +Kuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765186017; x=1765790817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NFLfpZ5l4wRVBkAGkPslmSuVObNJ4meI7Eg1f2GcF6M=;
        b=TnPtXa9UvRu3PQLjg62ycuP7QFmPsV0A5ig0DHItthq1GVfigoweqRBBhc/hTLkdwL
         47P7viZiazUu3CKa+Zk5S9z7rPNfKslpkTnd00q88HSxmVq04aFCybDxacToQDCmWYlK
         cd018uMKBHuCtJ6q4EOp6BbVaJo4wTO6K8bmBvi6H0k3OqjWUNtLZhxt9+Kaq5IXj83i
         OSpQkDdyC3qoXlg6GG9SOOrS/osxUIME9BC1/tlzdD9O8TA8loTMQC4DlpES0+bdPU67
         Csd6DAs3eYo11wk8wtCUTk9IpgcJaKKUvJzY0Cw7wJGypwtYSPSRx0s5qn9B2+UBMWqQ
         gxgw==
X-Forwarded-Encrypted: i=1; AJvYcCVzKH+I4EXC+kmjEpEtuvxqr0WnUuJPlBZCHiU800Xr2p8fVz3FzcuCMj311/mlAiozipGTwTNp+Q==@kvack.org
X-Gm-Message-State: AOJu0YwPOLDEPgGUVz8nhK7YUurG0Qm1zmkrB5pLDvgp9oJrEfSlpLDk
	By/v1uH9Roh1CkRMaiPkHusC6Q8bI2fxRPWWtoEwYBJw4gRsr2W7RDoy
X-Gm-Gg: ASbGncsSJXvZhnQb3XS4P7rXXmpCijadTfb+S5xYcpWjp+cZ0alMZ5qNixgTr3OJIF2
	cYnfdmJLZyJWzvFsfFVFOMIdBMPwceDFy136gTrPStRQX8tAaNgbkkEP2rAR8uo5WJYjQQRSRUz
	8Z38GVnPmoPivdolgNeqtDi4HmXZMjL4h0y1o+qH4yNoAkqDs43f17lFEvUX23EMg1mSVqSQT2J
	XE5agQo6PegIKCYkMChPW4n7c/38WQ5OWkQBTbVdbx8bd6JhBmF29LPD0C7OTLK1exrXr2h6FJO
	iBOE9bLKeZLMDSyLVmFwArEaU6OQk5bpw4ij8V9Ps0atbO9gfGbL5Tv1rJJsH4WCbZFE4u1QasG
	EBfUiCu727EgD8SWfyOc40M/sOS3dFDKNsp9BM4Tp+uI1C7Fuhp9scRspUd7KSiwnYPLtmlWGzl
	IC/ehTjLOlHfaWkGHaU6C4RRBoauECRGc4bTzFF3xysHa3Rl4jUFNM
X-Google-Smtp-Source: AGHT+IHojEX23VDsygt3ALVaB6koy85KM2XZe3lsMntBbpBgGnMPUb++LOsJBnCIkyeM2dwfndjplA==
X-Received: by 2002:a05:600c:a087:b0:477:7925:f7f3 with SMTP id 5b1f17b1804b1-47939df563amr90509565e9.14.1765186017202;
        Mon, 08 Dec 2025 01:26:57 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b04e1c1sm118716705e9.5.2025.12.08.01.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 01:26:56 -0800 (PST)
Date: Mon, 8 Dec 2025 09:26:54 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: <linux@armlinux.org.uk>, <viro@zeniv.linux.org.uk>,
 <akpm@linux-foundation.org>, <brauner@kernel.org>,
 <catalin.marinas@arm.com>, <hch@lst.de>, <jack@suse.com>,
 <linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <pangliyuan1@huawei.com>, <torvalds@linux-foundation.org>,
 <wangkefeng.wang@huawei.com>, <will@kernel.org>, <wozizhi@huaweicloud.com>,
 <yangerkun@huawei.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <20251208092655.6d88af9f@pumpkin>
In-Reply-To: <20251208023206.44238-1-xieyuanbin1@huawei.com>
References: <aTLLLuup7TeAqFVL@shell.armlinux.org.uk>
	<20251208023206.44238-1-xieyuanbin1@huawei.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i79c4mu7bmjboqhw5icfeh9k44hou5yz
X-Rspamd-Queue-Id: 19966180007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765186018-65004
X-HE-Meta: U2FsdGVkX19avSggXqOBmeQ1o3Std2tqM3CkPo6OzjPYT3G2LtsV4dTWKY26Rle2V0YyMsWANKAXMbfphN8ur9pQSUxw63njL0eTJogXZwjDOXdfOXSN10wrm1v40ptCHORaYfiv5Y+MvH8zrk+Dp4F93Q5zA2g9ZDzw1SgkzuRWMBjveL/KNMA6KXicsr3r1M6MpSfrSIYCpetNgBFdBmtQmhyFpdvMmBrxmJmjJfbMoBfYosXhIq+9T37jwAz2Mv8YCl3kX9sgdW+AhspWtLCDbg4QqfPdhdHb1aTPU3JTebWzjz4a848sLlow3B8QfZ+WQYkxINOnVr2q1YCOA1+SlZllJ0VzuAvlEAOHj9iqToxE6dwmWbkE79ItZMDEckHVDFTD7M0Pi5vDPRuFqLuJYZQ4d52fwj53ab1cKyL9FO7OXNq4RM4pKPasw6e/cxQVJoMVZpGcm3uJUErVtecaS/QcuWhpeCN8Q09T8GlLB+cyRNyWLAI7pOBTDG8e7EJwXwzsyf4aFOvduThYy49EUqumWmUC/8Y6CYqeeoUgv+Y4//TRwTvyHBZoHFZf2HiDOn5YCz9AfH+08OVVAOSCv/pq3Dw4JoHKAGGBW9B6Ek8dHBiEvGzOM5nAVVfSihwQvspM3W0MretA2R/wR59rkZEvIB6haKPut04+pcv6i9m2ND2mLbuQhkLKJRTYixCuS2hI+qX18UhpXxkNA+Vq8UkIALkIaGPnHTy6eNkd8wuhkFD8bwdjJKIaOyenzfBk2brHrRBkfxIAy1ILsmQL5RvCyX5vtlrM2UpVLmBTW19PHjwIOHOHZe3sFOXmg6YLgtzh6N1m//Fof/CettBGl3jBkR0py2K5NDj6lWl5/8Hqrsiw5Gih7EDQoIKvkbjaZlsSSBXGTxB6l0Yf7sGdUlZsEx9R8kO6iDHu7ZwH14LHwT9i/onxNhNhRVrPHAIfSya1j9snEbEq2Re
 DWy9aqYb
 e1VrC+F1JeaNCN6aYZY2jUFcXQ0VRiikSNwpb1dDUqepPawjsoIqIPAusd0kbEiXh36Oc0BHSHQR/HwSFnJuSGzILSVE6fZ3keq1KIjbJEI6tU7zqpsnXXlzI4D6+Yd5LkIymcNMw4M7RU/qWqyETwf4V0thvIglLPdw32UdP5k20JOH9xIM47Jwv32XXgS9LKfmiWJGVUBl5YdQVcXXm0WOV8KHgRgfzsiMmDz2yUjZJno3k/GLbOzdoGa1AYcBuIDGrh/mfMEOl4yJJzNKwibEEKvLw+85Y0AhcUCbdv1ztfld4sqsYugqYlehd+SvT4ARGphLulY+21x1BJ0HQVhouhxd9VbRbkLuB+Sup3KmjbZFLvO6fZMWmJtUXnwTPyFpEkzFCDNP1hst0iiu0+fAr8ONjsyhDjucumyavnIUrhJFvVVdnl6TNVaxgd6P5pcWJm30sA1bodCBoExs6wEx8YVK6z1F8poYfvW2rLg8NXi/Iv7iRPTC5lzsA5jRp+snSYOHgPqxcC7ipf844ZKyDtBufKrPX0X4+e8NoG87W9RA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Dec 2025 10:32:06 +0800
Xie Yuanbin <xieyuanbin1@huawei.com> wrote:

> On Fri, 5 Dec 2025 12:08:14 +0000, Russell King wrote:
> > On Wed, Dec 03, 2025 at 09:48:00AM +0800, Xie Yuanbin wrote:  
> >> On Tue, 2 Dec 2025 14:07:25 -0800, Linus Torvalds wrote:  
> >> > On Tue, 2 Dec 2025 at 04:43, Russell King (Oracle)
> >> > <linux@armlinux.org.uk> wrote:  
> >> >>
> >> >> What I'm thinking is to address both of these by handling kernel space
> >> >> page faults (which will be permission or PTE-not-present) separately
> >> >> (not even build tested):  
> >> >
> >> > That patch looks sane to me.
> >> >
> >> > But I also didn't build test it, just scanned it visually ;)  
> >>
> >> That patch removes harden_branch_predictor() from __do_user_fault(), and
> >> moves it to do_page_fault()->do_kernel_address_page_fault().
> >> This resolves previously mentioned kernel warning issue. However,
> >> __do_user_fault() is not only called by do_page_fault(), it is
> >> alse called by do_bad_area(), do_sect_fault() and do_translation_fault().
> >>
> >> So I think that some harden_branch_predictor() is missing on other paths.
> >> According to my tests, when CONFIG_ARM_LPAE=n, harden_branch_predictor()
> >> will never be called anymore, even if a user program trys to access the
> >> kernel address.
> >>
> >> Or perhaps I've misunderstood something, could you please point it out?
> >> Thank you very much.  
> >
> > Right, let's split these issues into separate patches. Please test this
> > patch, which should address only the hash_name() fault issue, and
> > provides the basis for fixing the branch predictor issue.  
> 
> I conducted a simple test, and it seems that both the hash_name()
> might sleep issue and the branch predictor issue have been fixed.
> 
> BTW, even with this patch, test cases may still fail. There is another
> bug in hash_name() will also be triggered by the testcase, which will be
> fixed in this patch:
> Link: https://lore.kernel.org/20251127025848.363992-1-pangliyuan1@huawei.com
> 
> Test case is from:
> Link: https://lore.kernel.org/20251127140109.191657-1-xieyuanbin1@huawei.com
> 
> Test in commit 6987d58a9cbc5bd57c98 ("Add linux-next specific files for
> 20251205") from linux-next branch.
> 
> I still have a question about this patch: Is 
> ```patch
> +		if (interrupts_enabled(regs))
> +			local_irq_enable();
> ```
> necessary? Although this implementation is closer to the original code,
> which can reduce side effects, do_bad_area(), do_sect_fault(),
> and do_translation_fault() all call __do_kernel_fault() with interrupts
> disabled.

It has to be safer to leave them disabled.
But you don't want to do that over long code paths.
But I'd have thought the 'act on an exception table entry or panic'
path wouldn't be long compared to an actual ISR (or other code that
disables interrupts) so there is no real point enabling them here.
But that is just my 2c.

	David

> 
> Thanks very much!
> 


