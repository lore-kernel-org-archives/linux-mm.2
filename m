Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5C13CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 21:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345186B0093; Fri, 22 May 2026 17:45:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C866B0095; Fri, 22 May 2026 17:45:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232346B0096; Fri, 22 May 2026 17:45:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1323A6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9231EA08F5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:45:56 +0000 (UTC)
X-FDA: 84796388712.04.0648BB0
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7C3F0A0004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:45:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vf6qlp6C;
	spf=pass (imf25.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779486354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HF/NjXSXWmsZ2MTdon58/xGzT4WCBzILiqAAQFlOD1k=;
	b=3wqB/1YlQGIF8vc79EjC6XjTDyeNFri/v/i20nZ8a5TR3vyz5T2momG6FXRwpJ+WVdBpZc
	86Bgc+rABeWSpWwueVF+b6ViLQ9M2sMWhquUAydJQgXO2AlMKtzgfOZH1CxjT4Cl1s3qCu
	8gpD9SExvWAOnv5Z6Ve/o77oDrYxi00=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vf6qlp6C;
	spf=pass (imf25.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779486354; a=rsa-sha256;
	cv=pass;
	b=diW0xp8LdaKoBUzkXALGf9sWdMIxwJdkx3I70LZjZu+AQHyyNS1R2rsTLAMhw9EwMOlEx4
	LczXyMdiPGi9p6ta4wni+cHMAmidd52wYJiAAz63ohse3zxeZvPYlAmm8rmeMGKdTafypM
	Q7hsIDdyn78OD3GFDsQVxBomNRHlWRQ=
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-632a055fa9fso2915892137.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 14:45:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779486353; cv=none;
        d=google.com; s=arc-20240605;
        b=QioOriuFfvTxpT+5Tb+ORp8BxjNFAV47m8pdqdOlwAFfJ1OcrAbyPWeby3etmF1FOU
         jmtANiSlz75dSDwqtZIUvfWF23lASgX4B8vAsDu+iQm72i5v8NKGThqewK40+tKU8gFx
         5SZqZrLM9px6GK3HsrGfGA0qdipLQeCNDVf9rInT5jpBKwEi129gDvuWvMvLO1L/UiDm
         KGxLJQxTfOV3RrEfKa3U6tKy05NVXO4xXMu86ptrx78aFg/T+9kXsT3N/NrCWc9T92OU
         MxzqTn1dSQXTkX32dmRMIPgYPed9oc4tr89lhLsDqRlVUp39deB9vxipGM8tPOuTgutw
         PIpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=HF/NjXSXWmsZ2MTdon58/xGzT4WCBzILiqAAQFlOD1k=;
        fh=LOciLCR23UiCVS1uB0cTASW4kCi1rjt1n2/N00RXZCk=;
        b=CJ2nNeSvlKuwzSYF7ysg/PmY1wogOMl9tw7nYuSABLYiGTJyPmYw9geCll2/32H9yp
         klIja6WEpz6P9ucnUrBGgLLt0ac8mUz9Q1N2BvDUh5z2uN3n8J10gm/tXN/Fy3xyTB09
         ysThv0gVHj4dpV3yERzelSo/yWNFp7LFV/lftr9XM3dA4kmZrUGFygbIlOQ45eczO6pk
         UPzHskGknvveILyrNnCd2pSZyxq8YXKGT+XzC76OgSRBtIbecgD1QybXxx3mkVjRXMwW
         ksdc1QRc4viMaomgjq4qwmTWXpuRPOgLWnH5L6L5RUjze+puKyTxydn3rXNhH21R+91V
         Ak8g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779486353; x=1780091153; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=HF/NjXSXWmsZ2MTdon58/xGzT4WCBzILiqAAQFlOD1k=;
        b=Vf6qlp6CLxClwGTyFKxRFyB1xB1bXstEwfjTL2qagD4VlmzD+1OXwSLDRaPGSk2ND0
         5f3RK4hDl6c4f7QMEB8RSkNV0gllSwZgZhPEsSNy7bmGVTMmwHURVuODECQfZuc8JMAy
         lbosd0lWCYfiaZvGEvIbeyDTUGzwRbkgvyyqW4h9E1RA2fDqm1Pn4AqQ/G4KiAbyEM7U
         XZQu5qg/+bUbO1jYK53qv0pAKgzwk8ibCc4SNk1iONGZghlSuahB/52aDEhJmgyTIQ0i
         YPkKMU3F2F/gwoZqOoB5LTjLoSJRm9aV71KQ7LG5M7xxt/OKmLOuuXEnLcQoXPmHNB/t
         u8Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779486353; x=1780091153;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HF/NjXSXWmsZ2MTdon58/xGzT4WCBzILiqAAQFlOD1k=;
        b=bmcU9BNPp+fkWzy3kEoLSch+ds614yf/L96Z81M+YVv4K4+694/GufK++bWYbJuDrU
         2ZiiXqJXTNiHvEd6y0RW9KBGgstD1Fr9Yn3sj+9BQLrTCdD6d4dd8jcCCs58w95J/QQO
         Fq6r4e+kqY3rI3/L0az5o4qEtVprIox9u4km0pwQP/pnA8iSdcSh0I5jPDp3TtcHghiU
         E+4m1iJXdO61pxbkRaVxYVVMyh+qdQLhghmb3fdTSZxXt4N5tluYHn8SYQKyyfEF4T2i
         /gA8fNy3SlGFBbcmfwv7AwnAlfYYeBEbqVOwFcBSh4HlcB687Y+O2R729VM6Kgj03BUg
         DgkA==
X-Forwarded-Encrypted: i=1; AFNElJ85SuwNJLBdoXUDcBNDMOg6xGiBn5M2r3hE7shZuXu/DsQpd5+0FsF98BdWa+n/StWNwQ6p0o6u4A==@kvack.org
X-Gm-Message-State: AOJu0YxTnBO5tCFXiL6M/Ug2iehD6HTzSndGsGtDxgrnJz9L9jWfaKXD
	txZbZZRcp6N9x+2ZP03l2/RHy7opwqNGSxznjcHo+3cjlR8O/n2JonPnBxNtxZLRCw9Xg23QeS+
	GYlrFaDMwic26RP5MHxPWBuzhsmP0t1kohH0eY/8X
X-Gm-Gg: Acq92OH4gCIZy4YUjzlDtj5sDQjNSObd1yDBywi2kOxHTFPijcSdexDMD4TKiKMBpAC
	6IAOITD4CkTssOTbfsfqW7RAbzLj1JNA+t8KmhZ8ZGqOUzhfMWP8KQtFWoYLIZ+apgPRyAP7/hk
	aGW09l+/0FwAJtts0KXe3lwIPn9MoJCUVTRDQ2Yn3aI2dOo3UobmBuyy4l2pcHXzFpXZb+Y2tbp
	O8F9MiCcE2I5q77T8lzKFzQdhXlSr4aCZVDkD4Qm0pgbnUyFjTnL07jwuP1n/8sMmRz3axh4RKu
	YhwKGj+q/40VLL0dbA2rzbjyLlkxrbrhI934RF7X4vqw1ud5zby2sXzeSTvoc71/SsAt/sYhdfy
	OSOVk
X-Received: by 2002:a05:6102:3e28:b0:62d:b0b2:88b1 with SMTP id
 ada2fe7eead31-67c7405ef67mr3506832137.4.1779486353069; Fri, 22 May 2026
 14:45:53 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 22 May 2026 14:45:52 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 22 May 2026 14:45:52 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-1-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-1-91ab5a8b19a4@google.com>
MIME-Version: 1.0
Date: Fri, 22 May 2026 14:45:52 -0700
X-Gm-Features: AVHnY4JHUcmHMeS0I0OECBQE9WDOiwFNaDvy5ucV_o_GqQwFVlnoZJcBRTb3Ibk
Message-ID: <CAEvNRgEjogBVDRNs2KmA--u9vHY1Jex-ERUuvK5idUrfoUBmmQ@mail.gmail.com>
Subject: Re: [PATCH v6 01/43] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, ira.weiny@intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: sc746tew8qcf8e8o48x14rmy3ujpj4yc
X-Rspamd-Queue-Id: 7C3F0A0004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779486354-355878
X-HE-Meta: U2FsdGVkX1+xO7uCYpxZiLzI+acu3tULp+UTWhf0Cw3IMSHFJ8jwoMWvCIfEZDHnlYYXUiogxW+kzvapsdc1idfnBi54YJKwS2l2HgqCgw813IIkNJMD7ntC2maXhC3QRsDyRsci1dYG4MbVLjVbzf/t2GnIhM4xTFuER9RHPRsktC5Lbv80jhUje4Y5bMB7mfDJtLPgUuPFupT9yefDyV5EPgP7DRV7AUAO/Fqg+CeMG4dpSn6XzTc8w9A7HMKRVrTlluuODlCYf90nNbbN7blxiZ7ffAknKUIFsfsPG7l7vDoOeR8JsDH7oEOVXk4i0+gIH184/5katx+7mAWndv7KJzlhG+bnNsgxqsobSm4ezv15zCdwp8XYmz6idK0sfQMBjF9KKo9wvx1/mK/2VZUBWqXlyXFJlMYJKb2nFo34lyRK4+nOT20cDBa/VajoXntpzFaQ+Uu021dQAkn4LxYQsgjsrkUbaqw+FFGKt7MLWu6rHc7JmusBLSmA/zLivd/UrVui/eOzSXfKouHCxMUq13/b2bgNiJ5t7mvJ8b77zt+9OWRyv9W+l+LWIcfc8mqh/MEylljMp3u6KoDONq7JK3sP9OfLAEAi1iqOAC2ubWDGA+dngXTtrXyF8AtTb7Bu+s7YyrclpPuKeSFceufW+/fHBQJqbRh9ByqzrpsAXchMjnI1D7H67WRR41wXyPXmmF6EYVtJODMMnlPfe48Mg7kDLYOVjHe0azdCXdxMjTsdWt9PqdVTZ1ddQnc9ZGTNf87GRMw05lNaCzfyv8iCrbqv0aIgDwUjijHJ2MUZYsthphR1I0jk5bxP0LXc7zxv4XOCo0MRltD15Ove8gZQgssQt7Bs1uDMlavF0upEeBel5ah5b0j/vA4brc9w1KNGGMzQHXhIeAul0joEOroOnqzsDH9i8BocZ0Tbc5cpiKNXM6sN39WGtIYroaouK1zFyOt5nU7hTL8Tm7l
 2murPJe3
 KVZ0id/lUXD+Lrnjcze4590YiNso65YMXgvSaf41Jgv+U4Sa2Nb5LBhBNQXhbNsq0T2yXUE823Y99DgSrB8NKTCmvzgTVI/Xg+N7cssKdBOuOAzOw2ncIQEaSYGgOpAL2kNKuqSgWOQQamoBsksITv2uTvExKI49TotbWh/5t/aeS/7ODxLK68a74Vzyv7+eNFQEfBM2nXd6lSkxVenu7Uz3PiMD91mbjHjF0DbjxUupu1wgGmgAOMZYE46HC+g9IM4v34SnZRPjVbcDxDiujmj4F/fI/egHjnK6IkWWhGzoSznXiejOEM9K6bNH+ojCkygAcBqjrd6BhfYXm7p0BrxWm7Xy48btqKeB4kCK/E/vWE0TOSTC0law0OC0UI3ADWfR0jjniIzcoyvw0P9/ba4L8pl9WOiyCSjZhp+mSh8Erd4GcuqV10IcFpufJIZ7HcarwnJ0GcInnh05MOJRTdo8jCREiZnloplYanQqkuZBwRTsC2OLROHuA537DkVbrzn5EZBFExfGvT9IGP+1hPVSyuWwtmu0PxlbLbir7swSuIogjMHmjYtMHAnfefEjYJnrfZDpLpYLIRo1q3bq0ekgvUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

>
> [...snip...]
>
> +static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
> +{
>
> [...snip...]
>
> +	filemap_invalidate_lock(inode->i_mapping);
> +	r = mas_store_gfp(&mas, xa_mk_value(attrs), GFP_KERNEL);

Sashiko says using GFP_KERNEL with this attributes maple_tree could
allow a process creating a very fragmented maple tree to consume lots of
memory not charged to some memcg and proposed using GFP_KERNEL_ACCOUNT.

The problem with using GFP_KERNEL_ACCOUNT is that the maple tree nodes
are allocated from a shared kmem_cache maple_node_cache. Allocating the
maple tree nodes using GFP_KERNEL_ACCOUNT would mean that the node could
be reused by other maple trees unrelated to this process, and so the
nodes might long outlive the process using this guest_memfd, keeping the
memcg alive far longer than the VM.

For now I think it's okay to stick with GFP_KERNEL? Does anyone else
have suggestions on how to solve this?

> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	return r;
> +}
>
> [...snip...]
>

