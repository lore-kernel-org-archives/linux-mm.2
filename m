Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72A7AEA3F38
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 10:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29376B0005; Tue, 10 Feb 2026 05:12:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD70E6B0088; Tue, 10 Feb 2026 05:12:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7C16B0089; Tue, 10 Feb 2026 05:12:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B26F6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:12:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F4B31C32E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:12:18 +0000 (UTC)
X-FDA: 84428131956.28.7E5C197
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 451011C000E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:12:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Cy+jNMkx;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770718336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DChLKwejGrj8F7YR3fLpzUKMEZiLdAYDQQYlci7vdtg=;
	b=8ZGgRS3UV2E7urWbnua2ZrHoSSc4JHfUSLDF1hAJNFUrolga7MMBtbzM3iczPWwb0oEHCl
	PDrCn+lOIQwd2KfRkHwd1WyvPqWt3WUqlbLm2OivlGOhsWrxx2+lEFS6FXw55biKRrZ+Up
	pqitDq+k9bPrJy2l41AHPCfs8b0v7NI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Cy+jNMkx;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770718336; a=rsa-sha256;
	cv=none;
	b=Tu1UspSQELbh154lhheDMh/gsJS13hNu7kj6WsEOWcIFgsWo6DSg8GVRLKqZm3QLqina44
	YISotl7hRUTBECZp8tVeiRXkqG5DPbRSfpeUjCfpjp7Ny+pKV8zyxQ0XrgPgZmjUDY9Mqc
	/fXqeVAl1+16JzSuw2VrsSRQdIwSEjg=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8230f2140beso3325637b3a.1
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770718335; x=1771323135; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DChLKwejGrj8F7YR3fLpzUKMEZiLdAYDQQYlci7vdtg=;
        b=Cy+jNMkxKSnLJAcBAO6sZz+AFI4alnx9SbIVgnLVoaYrrwFGzDB7+8RcxbyAnObS3W
         z1Cp0rn9rvqHkmmL8jSEfbNQPKXz8+23lH0EqDaVR3tXNPYR5oeHwP6xE2JJIQKPUob8
         ygq9htXIV8KsKzXRZhOF+Nbpenbe+2usezq9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770718335; x=1771323135;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DChLKwejGrj8F7YR3fLpzUKMEZiLdAYDQQYlci7vdtg=;
        b=iCdkC6aunzOkTqaF0ufrKFIppP3hoGyIr2ECQzP6jCgvw0oqGP5g8lcjnV/VvSJijk
         QZ3XExQ6qpjyf/4uDwqfjxhmKj8JrUcE/uDr+QldIrqDskbRiUJtx/FjH53c5/+MPGyv
         KuYxJ9rnvc7Mt5xgMK8TyPoUlkcEpOkqhFloHdKlM2yCkTTQ3YLSlSTBL8D8u5uvjjZH
         s9o7rhxwVwOjDIRrVsmB7SUB43s6JreyFq2r5ZxIZ1K0JE2IVJSJtNw1pPmEhimli9k5
         mevmSxY2NORUmhRphgf0Ccrz3uwD2VjT3KEOqkAUFsCikUhUw83DOg2IQqD1q+81IWi7
         Jv1g==
X-Forwarded-Encrypted: i=1; AJvYcCWd0hL2ijFGwEUeO+bCkIFKi82xnqUilVQ3fiyHf7Ixv5P52x5naVdzBOPjMelCJ/HPBuOZpj/zRw==@kvack.org
X-Gm-Message-State: AOJu0YybYGICinePQSlT6NiEutTKzMs+OtJUYl/tlocDdpbWxi63NXQS
	CNjasBDv2WmxMlFkIFUZSwTcuuEMsUvMuKKHdxrNEiSCDaeoiCw6rT8Vfb6lhALbYA==
X-Gm-Gg: AZuq6aJbGYNs34V2PsOBBSS2PXuAVB5XvUDJhmpHglJUFHC2q1gP7mrNFvaE0XZDwuV
	lwDry31ms+d8Ul/auEuJgDk1Zu5k00os1pUp4XeeokidykwjgT5g98uWz3r/jf5PqPbDNjru2qn
	OEZ8K+Pr0If2wSWASLGGxnC0jRcrHZcbydEHNWwYpXYKYdWknxXvB1Dvw5Iubp8AQ4dmOO9kqgz
	DEwEb61z3eCfIMFVlQOZhKjkMUUgsUxXprX8MTSt2u4Pc01pSYOGWYFA9S4IOyHbRGtj0Q5zfE+
	F9mLo3iOYcUl+93eM4U+SPnYFweqacy538VZ30dMwLFg/BvZ9vk4T8LqXwjrNZeKhfK+fd0bYur
	5YL3u+iZsME/V0CCTHHldnvnjmh4ZdWZvTXatSNv75FNKl1o3m2K8hoWEN6YFH5hrARtQPKXTHR
	Ey4Fv0QCZWb76TapAJiaX51y1Yn1JGDImWBa0eO7BrHIbncu5QOHMysY17LfmSbQ==
X-Received: by 2002:a05:6a20:3d86:b0:366:14b0:4b16 with SMTP id adf61e73a8af0-39415cf51f1mr1876930637.33.1770718335039;
        Tue, 10 Feb 2026 02:12:15 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ec5:3497:e96b:e7be])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6dcb4fb952sm13195737a12.2.2026.02.10.02.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 02:12:14 -0800 (PST)
Date: Tue, 10 Feb 2026 19:12:10 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [stable-6.6.y] mm: khugepaged refuses to freeze
Message-ID: <zlqncghw2xfhi73fwgotiz7ziaxrhrnnk5wv2tpdqkuksk2bol@jovasy65p4s5>
References: <gp3foqukne5ukrssvx64svhcpogmrskyyzjatofstfrl3vplrk@onxbnxdjrswu>
 <3d0f189b-faab-4452-b9cc-8f4e7a15025f@linux.alibaba.com>
 <jujsgu5ed3srhetch2pbpdrt4tnf2alodrk4nfo7idxmhsq772@lirvj7ftvxgv>
 <h3bbxn4omwe2jv32vyjou34me73x5nwg6ai57goqo2qlntq73y@ra75spa3tlzr>
 <1179320d-6bab-40a4-a7ac-dbcfbab24623@linux.alibaba.com>
 <c225864f-192c-4cf0-a5fb-411de8c22eec@kernel.org>
 <70ed2de7-3e66-4a23-85bb-e0a4c5b61088@linux.alibaba.com>
 <af21afa0-2a30-478e-ac9f-6bd431af6502@kernel.org>
 <gogfqtdrd2lfoiwfetql4v2pjehof6q42oewn2tphddobzawf4@efiyrhjyzm7o>
 <a6e73466-030f-4b9d-a0b8-502916c139f8@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a6e73466-030f-4b9d-a0b8-502916c139f8@linux.alibaba.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: uxtybrgnh3igiocxfjjiy9iykgoewcyi
X-Rspamd-Queue-Id: 451011C000E
X-Rspam-User: 
X-HE-Tag: 1770718336-806494
X-HE-Meta: U2FsdGVkX19pYqNSEJSy7dG4b2MG40NOF/BdYupRQrhW6tfDauG4CUYCmMkZ8vFJ88Ie8vf0eD79RWMu0SMPzNsf8j9uWOitmcCutMbwM5kyx+PajHvmpPWCbZgRzIlLp/+71ObpqZX/9m4uen1dMmMHNIe9l3Lf2D61t45y4ePPLRNsoFxWCV9XO/MjRiu2uCrXnV/hQskp8QepjButsuXwK2HUK3Xb6qp4nI1pyVubhpCtkRp4jpGjl65fucpbLx8q36zHLF51t9u+spIRK1UtraCIsIapbGDQP4rZRxvF5TsVLX/SNI+aGv9GFp/9Hcx4GktNQlNXtsm0kpcNPA/xMPhyuUqQhHiNw48BvxDx2LMIk+zFtcAWQV2S9hJsI3XpwK3V0fbb+CdJoKsKWGLmuazp6LYNoYDa9ZSkcDhE/Lar4djt836OhkFXsS5egLh34lcGPRvtu+tOs3dFI2xUMnzzdn5ei/3a4uStDw3E9tay21YNB2wG8KaRhyxwrcdYzNDdUuwyUkzjwrAiLkruJLHb6BZR0ORqJxlSEWxfV9SR4JF7ZCgIucaW9oIyuOUwhobU1TladmWjVTfjDYrMwG8YoBthOx1tnIcoEJd5wxW4oenOgyExeRirp1iOI3Oon8U30Q/2BdEhejvTc2TJgJlLVUV8EbY7PJp1zarY0oZJdb07qsDgyVlWINY6KIm8+hcihEKfztMpWr0XosP0QEUqGSRxjowYUqLI4G9mAPDeHRPsJVwPRuv9FsWyNcRo3qYO/OaIUMhvzC7yhV1Q9La/xSkrp3s+VHiwehG3gjSP65IZB7ycwrgIQBOBr9aBQiem8xDUN9xrVDmsgcO2jRVxqnWlg1lNpTvSFyANjUq5wEKE9Pl+ybnRc7Y4uyjQ9G+wQwcUYeiHMMRSGB2+fAcOuXXcPMHt/Ucf5u3Jw5UxrAE8udWSuT9+uJxPPu016qg8Zrb1M0Y1M61
 95G9NT1S
 YgEuK0EwVTNc7GdXM6mJEwBFIDLDoBhyS42386Gzl6zGxA9QHHvMIVfY7NpWLkEOoxdod1UfU1wcg4geYOlzJj5NjXTRWeYW+xhkrIflkFgqTQ3tUuKG1OMygGDQgeQaOvqcQ2aI/704V40M7LNHjK/4BkCs7PuaY5IVI/208e1HBQ5coVyG4bJ2fA2qigHxeuSVr//0X3v7HNR2FzjkNdvP6J9aJ2iWbhMKXrL41l8s9PjQEv0noq0Ea5h5Xv5cK83loppl1dPxQJHsHEvOw2X5+YKWEKGSsn258/isFK5ofW8hnTpaKlkyaiVQyn1GN6yf8etGIqaOqQrFaKgd6KgYgRjLmuw58r60hF3ypOlO/be90SzzAK81yuqQz+J/Y1r3vLgMwfcSlY4rkVaC37w28WwRaztZlxr3rDRMqCJqvEJM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/10 18:07), Baolin Wang wrote:
> > > > Do you mean “struct dev_pm_ops”, which is used to register PM callbacks
> > > > for devices? However, I don’t know how to use it with a kernel thread.
> > > > 
> > > > Also look at how kswapd does it, kswapd also uses
> > > > kthread_freezable_should_stop() to check the freeze state.
> > > 
> > > Right, mimicking what kswapd does sound reasonable!
> > 
> > I may be missing something, as I'm not seeing dev_pm_ops in vmscan code.
> > Would something like this work?
> > 
> > ---
> > 
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index fa6a018b20a8..c5d89ec223d3 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -394,8 +394,12 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
> >   static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
> >   {
> > +	bool was_frozen;
> > +	int ret = kthread_freezable_should_stop(&was_frozen);
> > +
> >   	return hpage_collapse_test_exit(mm) ||
> > -		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
> > +		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) ||
> > +		was_frozen || ret;
> >   }
> 
> Since the hpage_collapse_test_exit_or_disable() can be called by
> madvise_callapse(), which is not a kernel thread. So I think using the
> try_to_freeze() is enough?

I guess try_to_freeze() should work.

> or pass the cc->is_khugepaged to check if current thread is khugepaged.

Or I guess I can check `current->flags & PF_KTHREAD` in
hpage_collapse_test_exit_or_disable().

