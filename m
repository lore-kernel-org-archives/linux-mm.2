Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE4EDD116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 17:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106F36B0010; Fri, 28 Nov 2025 12:13:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DEF96B0062; Fri, 28 Nov 2025 12:13:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F35716B007B; Fri, 28 Nov 2025 12:13:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E27826B0010
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:13:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88B63BA53F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:13:55 +0000 (UTC)
X-FDA: 84160663230.17.D6A9D9F
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 423DC2001E
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:13:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=hBvUqapc;
	spf=pass (imf13.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.175 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764350033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHxMvjmHeLuvFpkAzdRAX3YAUaEt7mxZ79bySuiEqcc=;
	b=Y8EH3T0tKs/ZNqop9ZNnl8XR3qUb22u2UPPeSa2C2dAvavf5tjuNddD5nKtVl6chiFsRck
	x3pJQeqBZ1cbP7HYbVJS10IfqDGdkVTO+p56GfhJftrvWI3HQvtSTE0f9EjYu2ye+YQN1U
	0meGuXO/GRie3Hilk028Cud6vBruWt4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764350033; a=rsa-sha256;
	cv=none;
	b=e6FObUl65tu69WmC3p75VrsbjAgJ5IFcqLTNMaozs8EuuyGwDLWWh1iXqwyUbqJ001yLiw
	Nh4Yv7iU11H93GeS2SzPQQxSb1+cAUwSscVrgiuCN2oExxJFpL86L7lni5FlM6muN03QZB
	tbUcDR8s0ZdhTjGLkgjASGIxmd5q2lw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=hBvUqapc;
	spf=pass (imf13.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.175 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-37b99da107cso21680451fa.1
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764350031; x=1764954831; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dHxMvjmHeLuvFpkAzdRAX3YAUaEt7mxZ79bySuiEqcc=;
        b=hBvUqapc/UfxC0Hqrtr2eCuv6ndycy0NoSq1EamR9xSEMoGavo63PUO30RlmiLvJk7
         5WRHu9pu4FRWxqn+tA4iGtqr4yHHpR++aOkms5KiEj5Hgu5z2PKY8AVxp+MISFeK17dq
         6IFeWiESCBYa0niBaJJqXN0V5PRJll0AXnZ7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764350031; x=1764954831;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dHxMvjmHeLuvFpkAzdRAX3YAUaEt7mxZ79bySuiEqcc=;
        b=TJcWVYk5NtUrucRVRxr7GVLP8wGJC0zlAsOPbM8umBmJi4d/Em+sHuptjH6zFnmsh+
         cm02ID8NUqk4VWwJDvDT8oBeEToyOLCHLusNU2P89AgBppR4CksRcUsn7XDGk7CqGzrS
         qyMaoWRbw/2+3/ZsPi/qkGXoy12/9ZMD77CaBiMx2jUHYhBT7oLQd3A8a7pA3K+pS7gG
         R14uVpzzYl+Qsyu/g7B+0+38Yfx1f2Mxh+SHcaZVgScbsDmIfanyornoSfrgysjd2jzy
         Se3MfwZAUkoRryvr6LRbd0qfAlHPVvEWCXfnr5JnGqSeHawHFQK48QHr+qXeInZ/WFtz
         KW9g==
X-Forwarded-Encrypted: i=1; AJvYcCU9AXa4OOCElgnPDFVNSQTSM6gzQqPkWz4c1/0QzpwH/ciE4GSG2Zg9AN7y7kCcgq5ZUQb/GsJMfw==@kvack.org
X-Gm-Message-State: AOJu0YzkMQ0EeEtn8Omp0my2vxRe07P9MVvxQ5vVbA+vcwEG0M3LOf3d
	O3SXgwFnsLPJeyDbANK2fBUhPrvF49modI0BVDuYn4zZwrC1+mXpC1hglfvRi7BmTsFOii29jlx
	GYDGjeNbfrw==
X-Gm-Gg: ASbGnctqcjvI3gQtaHfNNxSO+q3QivpjUa8ad00xGWV5iXd/973gyL1BR8LFE+vDhOa
	fvqK6c7BynSCA7kk96ZFCLgBVadIFEa14i7Q7M3bQUpb5mmxGQMprujJVvkAm087GB317HOefk2
	jAMLom+i1RrziGEmvyg9KOijQOlrLrAqCKFGptrJt0s6pLG34+tQDU/JuYNGf47VMqII7c682pG
	vpDa2cpsPs15t0uZKYsueuB+faYP70lb3W+JqyrUphtGAyLMUihJQf+zPhXDoy0dq17NGQQlGvu
	4W3QBzHZL1bSmWo4mZJ+6dYgewxVixV2keRPFQY7Mh2+dKY44xb2+FzB4/WlZ1Sx8TOBH/vRWJo
	3lZD4gIgSFyW9HZWIWsJTNIVp3gXRarYDl5Ji6FBlRTeLHPXD21dDherquQX+tJH7ELzaCGOrrE
	mJmyFCX0eIiVnaphyhmpusfwhrT+lbW+mEkg3GJ2EIXdyntdNt++d40n0yapkxMT65
X-Google-Smtp-Source: AGHT+IGqkewAnQSj1qB7jF9sHerqFEwF4gZCPT4a9m7QVp0Tr9YxGg7duQhJmGsTvX4C5jJIZH8zZw==
X-Received: by 2002:a05:651c:215c:b0:37a:2b3d:12cc with SMTP id 38308e7fff4ca-37cd92c9e0emr58503141fa.44.1764350030941;
        Fri, 28 Nov 2025 09:13:50 -0800 (PST)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37d2369051csm11073671fa.2.2025.11.28.09.13.50
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Nov 2025 09:13:50 -0800 (PST)
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-37b97e59520so13861041fa.2
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:13:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW4iVuuW5DeRrYxyX0shsc39NAQyUTGh4wwxH7ZosR+HWn+exkcPwEb2k8G7hH3o00ychT7nwgepw==@kvack.org
X-Received: by 2002:a05:6402:2708:b0:63b:f0b3:76cf with SMTP id
 4fb4d7f45d1cf-64555b85bb5mr26149888a12.2.1764349626340; Fri, 28 Nov 2025
 09:07:06 -0800 (PST)
MIME-Version: 1.0
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <33ab4aef-020e-49e7-8539-31bf78dac61a@huaweicloud.com> <CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com>
 <aSgut4QcBsbXDEo9@shell.armlinux.org.uk>
In-Reply-To: <aSgut4QcBsbXDEo9@shell.armlinux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Nov 2025 09:06:50 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com>
X-Gm-Features: AWmQ_bmE-6XAFAPa0-eSPLJJDbgRImzhoDMUlnAscfmarz6vBK22IDNiLQ8b6yM
Message-ID: <CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Zizhi Wo <wozizhi@huaweicloud.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, jack@suse.com, brauner@kernel.org, hch@lst.de, 
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, yangerkun@huawei.com, 
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com, xieyuanbin1@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 423DC2001E
X-Stat-Signature: g9jzpn84qfyfgyjs14s1w3fuo67oqcpz
X-HE-Tag: 1764350033-121870
X-HE-Meta: U2FsdGVkX1/EukxW0JZlQ/dgxR5Gyf2aPoQStH4M6KvxdJwLfswPJPbOgKWszIuVV2QIQlWFPBz3xCkr4jKCqMjhpQ58VvFBoUpeH/+M6teoK7iHPtkcNCPzG3RDFOP4co/mz5kF2/YR4kqXo0PCA3wpqmgRw81KumP0+nAvjrnd+OdBVJ21w0wD6lHOQkKPgoWSxlmm3MbQesSdqLikcBribjo214WHFsrSu74fY8mYWGYiq4jZE1ju7tdy96UVeovYYLNzdxau+h9NHUdFMmnMcEbzKY02HoW2sNyK9mYFR94BLRbJkYdCwNWpR1xMUIJJm10Z4DIj6iYTxBCDDs5x9yCsF7SC6nZ3g2pEMHi1rhVMOfHX+kWCN5iRPQeEHzJXXblOeae1assrfIVt3INNusKIv2H9GjcBr3DOKodAZ9RoynbMR8S5fQo4uVKNRY2SrYMYd21ZNEBqOogn2A0mMftW7JHwOxrZJypKPG/gDgR2Oieb00Dfxnh3HeLX2FLTPd68ImYaNiEl9W/CuzWxWlVF6jXXjZSdQ4coWDID0PCqQCoVr2sXx4EpKlF6Ij4NLzoy7udNiivgrNMsAsFUaJ0n1Qp1oOILElCrTBWSVKLDDe3XTS2jUSuGw7RvNHPcyfU2XdVGTPimK/mQuJ+0pR7tMO0Yb1E2vY43YS+nCaidWL6Zp15s1GJ3pDLvefuPsqG7VYf7MsRJpjKerBRobguhkNAmLIt80PjsRYtME0X4y8WCsClx7pVzrcBE8gkqNXDdyNf//9ELk2IYznbQnMOeYBSykNQFhWE/IE4JRAqPCHlN2Fb4iovROcv6SWB2dUeH4mY30vgPqUCUjliR1fFO/3PF5ycU0oOS4fpgzn0nyhfLfu5jnFMRgsCNf99FdPHUSEpCwwSDG7lkICftRl+3KKacByDIdK8EFk3vIuwn4sGo0yQ2XCTGRztCVWBo6Qc4SCGZ/Xqh6J2
 lcUxJgil
 D/Zf1mGhfhFCZRtJu+SCr47eXegcnAiPMApxu4fAO9HeySns5DYvXQ3HR1GeOvRBzl/5VBqc+XLFvB8Te7UEYfUydC9NQ1cJsFFrPGVxISDQv49gMnZ4XJyo6aUhWv6MvZKrK3nHsm8UP3Gh3sn3m+hxxPe8L4ENiLfZBX1vP7G17u5VALjNRuL96L12ckMFg5fgfTNYSxlC1bcKgD7pWBMbhRus0EpRKMukLwBmHD5STz96sxMHd00D4PaC2GsSOsSy7RI8b5nYnWaIVFPgzU2pK2oU9QgB4Vt2AtWvCbQj4zn80bLGbZlYYyR3df+uhQs6lPR3FeuElQM086CI5/tb/k4arNdUCiE2u+FKLummakHmHQHH634R74e49lp4iiaE902Qy87Doc5Bcml6bneOqB9Koo+/HAp7wO94iNfR+MLKv+zqVysFoLFLeW6V8nb/Li0fVA8k5/BC3vcse4ZZQMGNaEFkZ33baBJdA5cZTa7ecsur8zJgHbwA8Lv+xI0oZ+yEyosf7QJc4HNhs4ZduKer425j5KLVORk58QboBulDWjkugBd6z5kQUkTXyQiWAaqqiEhwJ3KljwUkmjt1Y4lPAUZY4eGqtAHsEwMbmufs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Nov 2025 at 02:58, Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> Ha!
>
> As said elsewhere, it looks like 32-bit ARM has been missing updates to
> the fault handler since pre-git history - this was modelled in the dim
> and distant i386 handling, and it just hasn't kept up.

I actually have this dim memory of having seen something along these
lines before, and I just had never realized how it could happen,
because that call to do_page_fault() in do_translation_fault()
visually *looks* like the only call-site, and so that

        if (addr < TASK_SIZE)
                return do_page_fault(addr, fsr, regs);

looks like it does everything correctly. That "do_page_fault()"
function is static to the arch/arm/mm/fault.c file, and that's the
only place that appears to call it.

The operative word being "appears".

Becuse I had never before realized that that fault.c then also does that

  #include "fsr-2level.c"

and then that do_page_fault() function is exposed through those
fsr_info[] operation arrays.

Anyway, I don't think that the ARM fault handling is all *that* bad.
Sure, it might be worth double-checking, but it *has* been converted
to the generic accounting helpers a few years ago and to the stack
growing fixes.

I think the fix here may be as simple as this trivial patch:

  diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
  index 2bc828a1940c..27024ec2d46d 100644
  --- a/arch/arm/mm/fault.c
  +++ b/arch/arm/mm/fault.c
  @@ -277,6 +277,10 @@ do_page_fault(unsigned long addr, ...
        if (interrupts_enabled(regs))
                local_irq_enable();

  +     /* non-user address faults never have context */
  +     if (addr >= TASK_SIZE)
  +             goto no_context;
  +
        /*
         * If we're in an interrupt or have no user
         * context, we must not take the fault..

but I really haven't thought much about it.

> I'm debating whether an entire rewrite would be appropriate

I don't think it's necessarily all that big of a deal. Yeah, this is
old code, and yeah, it could probably be cleaned up a bit, but at the
same time, "old and crusty" also means "fairly well tested". This
whole fault on a kernel address is a fairly unusual case, and as
mentioned, I *think* the above fix is sufficient.

Zizhi Wo - can you confirm that that patch (whitespace-damaged, but
simple enough to just do manually) fixes things for your test-case?

           Linus

