Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F70CCA471
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 05:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0B78E001A; Thu,  9 Oct 2025 01:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981058E0002; Thu,  9 Oct 2025 01:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 870148E001A; Thu,  9 Oct 2025 01:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 754BE8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:54:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6B9D88635
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 05:54:09 +0000 (UTC)
X-FDA: 83977510218.10.F123CF5
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id E141B1C0006
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 05:54:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S5zIahMK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759989248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQwWvvs0ghZq8zc4r9h5lIan/PtlkEVYSWj9AFivA18=;
	b=kBZ4fnaFA/BzBzm6xdj8rfJI8/HJ6eveamNFafuqHAPviiUKLUC/bd5hQIwaXRFHn0m+T9
	KsDPzBF035Nmem6ybLKM3FTDJkjGzIdHIGkaA890tWTBJ3jaXiO0wa5C/r4g0VAwwgLHft
	Y+P5SI8AhTvHCf/RU9TWehiwUeiWzzY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759989248; a=rsa-sha256;
	cv=none;
	b=kxczUj1X/6Y0YBe7a80d44nF0vGjpPTSMpdcTceQpuhwyER12+/rvH4kSHni5TkXe5/eTT
	e+CEcmlrWeeJnGR7VBkgxC9mvvYDAXuQgt7t3zHksWp4ikZ6FkvxtEIbUiLtsdHzdERdAL
	BRE34pwJ/rjWVDeppzhJCZdpAMXSAas=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S5zIahMK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46e34bd8eb2so5490545e9.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 22:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759989246; x=1760594046; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SQwWvvs0ghZq8zc4r9h5lIan/PtlkEVYSWj9AFivA18=;
        b=S5zIahMKZ03ksz1pcnOlcYuqH8y+aJs1/x8F0a5fCCstkUYfeAqP2Dr0qC/TJk0Qo3
         fXa8nVC0x3V9XeO/mVMIzn3YLspivrBomX7oPW2tXh4+WJG6NCMjeAYpMclhCXtcyv1I
         5bmvHTHxAYiP4f3BWsLbNNUeKBFYPTKrp4uc7RlStTke5qUSon03eFi2TemTwBbqNNBx
         ScHWLnYERAgCOxMIbHbBtMKCq0kPMYsUW2jaRuSmePzJFUUxxx588ytpXOkrVqy6N7mj
         zuVdh+WSaNiTUs5swxq+QKfT2sMb/tSlqDKDxSmL7lHpsYZsf/L8sCDw/5lbxE/+TYlo
         3DLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759989246; x=1760594046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SQwWvvs0ghZq8zc4r9h5lIan/PtlkEVYSWj9AFivA18=;
        b=tWt0aXzdVAN2iEminxBm0rSiIV/wF/fPU4cNVSdDxZLFGM6vXEOiTl/NdCDL86dJ+6
         V/OAY0qRFitiXNMZGwscSwMk1IWOvC3AZyj3gLD0cuvB0vZ59BmuZMQdxrFD8T62hDRJ
         qnBdbBsN2a/3ol6GpUUUfy9ZP4Efon44gSEng5UMjez1E9Wt2ekmy+4+ylf4+QhQt0DM
         MxWowGgpd9LU6yyhS3SRka6J/xLbQZcUX+DDNPlgSAw1QKt3WD8cNXOlQmyAG770iaC3
         lL9GO9SozzZVgiLRwIE8es6/ZJrk4a5wJW8iJkNpm030lBj5zVsKuN9sm8NXrMmgzIct
         TsDA==
X-Forwarded-Encrypted: i=1; AJvYcCXGZxp0C5kZyXOF8vtks7X+hBf+HXQxT8fBKKkt2M8oJ/McQ06VVQcf01p9j/sd8boXoKQcDUhYrg==@kvack.org
X-Gm-Message-State: AOJu0Yx6ea2Aa+EgDZjdY61Q8l+mYhyeuPLRiSiSaEPIfDbsBgq/P177
	bAWC6WdY8skiSEms8g/HveNw+BcC0YNAZpcK/sIU7QbDYcCrXB/XS0+G
X-Gm-Gg: ASbGncurJ4wWDtshRlgQgVF2Txo/fo3qem9DgIJNgjPnbkddyUnneGDzMLPxP2/7beR
	M50PbyRBukLy4dEQtXcd43GQbBAAuEQA4lBVTvEH11lAJuqC1+RWDtR1AjG8x/upqZ1ZiAh7p1W
	6rEgHnidHSm++eL3QogR673ecxrRxgUcAYjXNUGyQ/JYdswUvOWu3vU9nRAld3kwR9yG03OzF0y
	wgJmXhgzIM8lT2dSwfpGugL4T8tbZ0bVdsiRhUu4++OpBy2TIY6W2A5jq4VV3kQohtSh9H5c3bI
	iNG2//fVERpRTnf7QaAR6SWS0GhOmLry2QBweWKAfDmSK90Xp2xltZ45oilFoq9Rv9zX4LlJFin
	cNAaTYjsUEVG2VRd3iPSWKIn8GJAkUkdCmUYcIehh6irgBA==
X-Google-Smtp-Source: AGHT+IFD0icIVhoTNWR3ZSoy0958G+47lHMZ4if/obpZ13INzMYnCQpoDVT+IeNh0q0RioLY0f7rhg==
X-Received: by 2002:a05:600c:6212:b0:46e:27f7:80ce with SMTP id 5b1f17b1804b1-46fa9af8f39mr41575065e9.23.1759989246026;
        Wed, 08 Oct 2025 22:54:06 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::3086])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9d629casm66416825e9.16.2025.10.08.22.54.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Oct 2025 22:54:05 -0700 (PDT)
From: Lance Yang <ioworker0@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	urezki@gmail.com,
	yadong.qi@linux.alibaba.com,
	ying.huang@linux.alibaba.com
Subject: Re: [PATCH] mm: vmalloc: BUG_ON if mapping size is not PAGE_SIZE aligned
Date: Thu,  9 Oct 2025 13:54:01 +0800
Message-ID: <20251009055401.94174-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251008211714.5a8b9fbb57dbe454cd4a9c6d@linux-foundation.org>
References: <20251008211714.5a8b9fbb57dbe454cd4a9c6d@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E141B1C0006
X-Rspamd-Server: rspam02
X-Stat-Signature: xky98cjysgohtu6sotjcxp1dxz39mqo6
X-HE-Tag: 1759989247-323599
X-HE-Meta: U2FsdGVkX1+vV1tV8iPjFarOFa0EeBzBOYKsCmaBxqu3aY8qD1Pk1/Z3G0UX61H4X/KuE870yFvQguLKL322ezX6fwFIwVpBRkmj1+06rTzPJIm2JoCX1zKpQFwt0mQulXzo/0NYRnZbMK5J5YNxsm+P6XlFbX1nappi82lxkqnI7PRvOH1z6ZZT1S/idNeP9UXcRQQO109nLdZUVz249qYJhnO1CzV9dJ0D/pK9aj9z0x2eTHUMAT/h+a9Np4+046YhV2RlD+qjBRZyqtxZByP+WeiPNk2dUPRhEoy7ekzi3lzUOk1KZfPf2fCkdRhpcuzXR+W5dzWv8UhD5goujVi49FxCySxz5e/K31iUJzFuVzUbe/qa2Yr9SjXZOLG4RxLBGjPntRZqx71XMBC4tPYQ60Waqy4S2Idm2KNpwxXkE75PotG+lu57hgiILecLrXHn48uCI54XD3hjxjvOboGdx8Fxtf89hixgCnXYmYCdX/zdIj6xgidWwQxilYx2PjX7ORCcAAvnSV65p7ZG8J2DJtC+ZpMieVNAf8FRe9qiNBWy8qlwIS6Syr2uGEQVN4dpi2fkSws9Cjgv5iUUaX5BwOVCzPhh9ZyA225LQNePw16M0Xs2KH5ZWsEsTWH8e9bUJ3DDqPXUr1IR1uHXd45mZWa8pXOBaU+NcRg21z/PzGfNFPvLzO3BkS3Y5vnG3wgtPwZNaqMvAbXoCPNEmM3qhy+H6MHfDn29NMuoplOk4uBJt3ClPDLqPkpsOHchWoUXYKRsAd/Nt9Ah/fxuc4bnLl92g6kTZYCg0fJP6TsEklmBgJTCQp4gOTEz2+My/V11DUkyp3YSfkJJqRjUwjAtgH5FK0kzfGED32+945VSLRNZ4L7sSqmOuUMzO4jYhIBhV23D2U9IUKKEUUd9UOPyjUb2dfSGS/80NJmU1o/pf6qvcAp0MWEgdEClNU5+qU7Lj5uvelSSBvY0Uc6
 oISAiwFs
 DViRp+guogu5xllURV9IQJgsoz8saa5kddPYSiBYI47HWjENJ0MamLMcoosecxWOeusbLGgZELbiinPGo0vaLHcOI68ZVGGNnwUZMAbiWllpSryuhWIJ8x1ge1mgxpizN4x8G9sjy0hAwhABjb8+/CaeLi11d9YnSvmlR7LeK9p0OaDKKwyy/7/FLzWVe9R3w0zdNak3Is9zKqimun6L7KIl30w2dDtGexu5DFEsEZjfY+hTc/turmnvCWyfBHFt9XGvb23ICyZyPvrqFvVL38xR4H7kkZVRbMQo9S7i6OJ21OaWtVONHaT5BOzakG/f/rBQGo4kM2CYllMR1ib3TgC7tLBt6wcRbflI8UGHJvX3ZWUhC/E5vjqd/mBvZKtPnx5UT2r13Ki0EL6v6ySE/C1EX+FA5UvfVmoTTLpwYoQeePc4sQc+IlkSzJYRXZ83JjNEK9moCJ02Kwb6JEeFVlq5FnZmy38jrm5dl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> In mm/vmalloc.c, the function vmap_pte_range() assumes that the
>> mapping size is aligned to PAGE_SIZE. If this assumption is
>> violated, the loop will become infinite because the termination
>> condition (`addr != end`) will never be met. This can lead to
>> overwriting other VA ranges and/or random pages physically follow
>> the page table.
>> 
>> It's the caller's responsibility to ensure that the mapping size
>> is aligned to PAGE_SIZE. However, the memory corruption is hard
>> to root cause. To identify the programming error in the caller
>> easier, check whether the mapping size is PAGE_SIZE aligned with
>> BUG_ON().
>> 
>> ..
>>
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -100,6 +100,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>  	struct page *page;
>>  	unsigned long size = PAGE_SIZE;
>>  
>> +	BUG_ON(!PAGE_ALIGNED(end - addr));
>> +
>>  	pfn = phys_addr >> PAGE_SHIFT;
>>  	pte = pte_alloc_kernel_track(pmd, addr, mask);
>>  	if (!pte)
>
>We try to avoid adding BUG()s - deliberately crashing the kernel is
>pretty cruel to the user.  It's far better to WARN and to continue in
>some fashion so the user can at least gather logs, etc.
>
>How about
>
>	if (WARN_ON(!PAGE_ALIGNED(end - addr)))
>		return -ENOMEM;
>
>?
>
>(Or VM_WARN_ON)

I agree with Andrew. Using WARN_ON/VM_WARN_ON and returning an error is
the way to go.

AFAIK, we are moving away from BUG_ON() in MM whenever an error can be
handled gracefully.

Cheers,
Lance

