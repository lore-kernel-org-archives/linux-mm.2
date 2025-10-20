Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15146CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1038E0012; Mon, 20 Oct 2025 05:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150DE8E0002; Mon, 20 Oct 2025 05:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017F68E0012; Mon, 20 Oct 2025 05:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E24F08E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:52:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 976B5BB31D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:52:43 +0000 (UTC)
X-FDA: 84018028206.26.BE69AB3
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 836482000B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:52:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VlGqijbs;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760953961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGpju+Gd9/THNpuuTg8cSbZecPHS5eNNv2MOF/fBRs8=;
	b=PT2zMb1e2xOvKek5G4doKb9FXIZsqf5bboR95Y/Jbxq2yNdsGW11JulT2DhdoSXNNzAnKt
	VkkoDgcnXbMWneYOBqe189FwHKKqpwK2fxtrxCmShhj19xNMl/k06N5ySiTDrwzPsKnHhA
	7+Q7C1HIibbu8R9nrFWXfE83OYAuVSE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VlGqijbs;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760953961; a=rsa-sha256;
	cv=none;
	b=KjWFyQVFbQo9IfNQl7oBMA9S2TvEAPHDNI6dfrju9OmpyK17RQipNh1De4vmBuNtsrepnt
	iq9fOautzf5ipzMmc1T9W4t50n+DVo6/DpX9+6ovqF8onaCMaOdcpnDBhX7UnWVFRGgP61
	OK0Ehdvo1V7X60gTw/23spuVPY5rwMI=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-57d5ccd73dfso3927781e87.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760953960; x=1761558760; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sGpju+Gd9/THNpuuTg8cSbZecPHS5eNNv2MOF/fBRs8=;
        b=VlGqijbs4WhYA03Sn1b8785w5LHGjhNRZAjMg4bsXgjXx2Fdk6hlqlLCxnvMvnA4Ft
         JulAUD5sIMTRbxB2u/5xZlIYdWHGQITvRiBPseOyaor573YJDO0soh5a2uVnBGv/ww4q
         Xwkd/gt8X8AcrpJzjmoxTKvQWC1NF25UfxL8xGDZAKTEIUSJI/EfU20K+VrYsNWBO53s
         dfrVusjNh9NX5JnlvDHaqYEzZIBPf5KJvokcWMo8h2YDhISlMrAlWi+e/5Mo/d4laYXL
         cisU+zOCzPGYRtMUXNygEhlXjkXUh09LhzBHvOUpC+KiUsgEGnVnnO/pUeQ9xubx7BVJ
         glzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760953960; x=1761558760;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGpju+Gd9/THNpuuTg8cSbZecPHS5eNNv2MOF/fBRs8=;
        b=vPea1Nbjcot44rEjnRxAVfQJvaCfvgX8rv2c8GXnTGN1gYCa2o4wJ1trF0HwyxJlr1
         +KsIo4m2Rw/BN4xF0GE7itTlHuUDLuEQv7XmhlchGmh+XYjQGZPwztsOdRBrvCBlJc/B
         3KOSSoAjfQyyLqfPgksP537+E506aocH1WZ2W4gqFPPWlL67He1Lteb9Of89qV1j4A6p
         D/kxu45H7+/xT8ZxG5bpSfigVLTJT4cNBVjXYLH5EszOrQiaYazQsO9SmVbppwOih2Iq
         u9YNBALRNjKtheoYZBzg/4V+XsmsQKpouMHsA+6E91FglCFn/Jih5ZWwIyrRrw3bwhK7
         D8FQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgdsIDhQ40A0UtUVOSo+ymUmSbFvsUkevzNs9zBft7R1wJpk/xZZEaVgZmGXIzBvhMbYxjdvNubQ==@kvack.org
X-Gm-Message-State: AOJu0YwA1gHS82TkS9FP7Z8C7pCeg/rKXcnyhRqmHGoFuIYW8K139Ewd
	Kck/mCK9cqrAE0f4lVHbpp36LWJqPMDCpQrS79bu5/O6811zmbpI5yQN
X-Gm-Gg: ASbGnctxxAOCf7P6V9nroZFJElApzaxOhD6TrBl0CFGwbpkx8n9sGuk2CMvLSMLLo00
	G8Cjy/JD7xQhutOAJQLhjBEY+eG6sGWhzskmzJ8bO9lSKHA7/kzR5TT5wJgMDlCtLd7dklJTZWA
	0OkSwuteZVuIUVoXo0zcIe8NfSVvxOLQ07nA/n5OwUq6sx5pLzEPVLAZ3FyXKhitZipLtfvkB/F
	BQ4I8YfJqZTxZs4Fr1RuiVAdSSybKVd8L+3iRyg5awHHNBHQRUsIE9fFOTQTctCJvG6PPnC3moX
	6IfP4jnQv38GgL2WKYjeHPdXZdn5Dhm80pjAs9B+V/E/7Ppbq9thTvsvAleBQUttG4tnmaM1n1N
	8rNvOX03uZcFzoaITiIThzgpoxcQ/VwCmI1phf+9IoUcQitybprOGCA==
X-Google-Smtp-Source: AGHT+IExS7iD+QnDCXSMCbonZCGW2Axznoc42QyUybY5f3lmldOmND0AMnsbCjH+0+hoQeg8aUWzhg==
X-Received: by 2002:a05:6512:3e03:b0:58b:75:8fae with SMTP id 2adb3069b0e04-591d85575dcmr3843407e87.26.1760953958936;
        Mon, 20 Oct 2025 02:52:38 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-591def16900sm2374908e87.56.2025.10.20.02.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 02:52:38 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 20 Oct 2025 11:52:36 +0200
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Baoquan He <bhe@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH mm-unstable] vmalloc: Separate gfp_mask adjunctive
 parentheses in __vmalloc_node_noprof() kernel-doc comment
Message-ID: <aPYGZBYTBoAEYjAK@milan>
References: <20251020044933.15222-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020044933.15222-1-bagasdotme@gmail.com>
X-Stat-Signature: ei5yif56ss8rcinx8bhakcjegqdjsqiw
X-Rspamd-Queue-Id: 836482000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760953961-841094
X-HE-Meta: U2FsdGVkX1/+J2JulRAGTUuS94TALPQEtqjkEINV1kM/zadQqiXzMaZ4K0Xae+Iz2SmsXrYb6jOxD2FxDXXG/hVPuHYrEN5hNCvPUR4kzpCqRhiSe67XLhXq170J/rB09nzog17R1LWK3i3V2Bt0nOKVuIATkEedXcSSB7uIo4l9Nf0Je4LlANS9pMTkEmFYOetsg8tTeeeEJs+qiN43QNHutVTtTMZfZgDfxJA37XY24C/OxRioIoBrOhvm457rUO1w2Zk59pufJHKqyOGFIvihpPUoZWhjJ8H5tTLQsZXSFE3IvKEWspPaL4CIf8zHhZU4/rOVRjQ5ZhO71rW34dRLS/wUdUfhtBuolkQ154/0/zLZO3DmBs8FHzrCdHj7Vz5dMwa/1hKhEFbzhC/YvhAJ5T2UE70X9Qfslr9QQPRx9jUcbcRRhSgk9Ri7eAkXzIXYB6kHrxgIyKWo1lxK57H/JQEYqKv2c0aNcPFlE/U9jlNDuQiSthoeW8UlFDQKo/mWPui/ZFp1GB/X/LGrl1YC7CvFM6tpT0jADQlHOzt6Q5sQ+rRBvqZs6bJN0sbQaV4tsozMidEHt4kZr6jquoh9QhgjaKsiNlzFTPaSKOF88LTWKx6QPjcUudbyotsechYniGPqjwvnqI1FjZD6vig26Y0wdkIYaymAO/mKtKN/85HKa240bRlyR7iMCE45Un7N4NZ7IIbXFN1m+M3Qi/0Wl/Blqb7sUh8swt4ZxR85jplQVBHn1ybJlk/rovzrsBUaBG+ARPS0Q/Go9zAH09PcTN2NpKe+IGT789lm7HQEtKmQr9Bwq3zek/ENd4NmjjXjMneciWEAu9r3eCPMdSItlceSlrc17DYlYuIsKUDJGkT9hViX2siqRQKN/7RmCFs/LKAZPW7wH+oJFGVvXeJi90sfOgM59h+m5Xd/Kp3GRuy0VLzrk1y7XhwcUFPLvrNl/vcABwmU8qFuCvU
 scqTwrU0
 O3qDQ2X87AtCLLPPxowGJeG1hSJ5XeW/BDyhwnPkOQ4qYc98u4HeG0NkH2ALbO3wrSN+L3yNKBCuKo1F/3e6OQPPMk+Ilw+haDSlihP0LUZiIBhZVFONlCg6DCpEOYWkUC2NPwTAk2nCkIGsrpCCCzk+KjUG3Wr93+LItq1drTabFuL+S4J32/dnt9ASdon8AV0coLs5EaAvfUePAUMCEl+2dYeZJkgS/zyKjGCdnIJo14ylcSoqZAWy3aU6HRzvV9YLNoZVCpugVmaW432Tpz5gXYR/1Q/VKdY7hxfT34ZQx5yaoHASJRzszGLPLh8Cl6oIMpW1aqIuju0gGwmyNMFTWd5gaczfeZnMgOZSosglLZUn1d40XQGtM9qzfbWFfgh/7MnLpBZZNDa6DMHfUWBXkiCIEa2VABG6T411rdXZz3HO+QSDCyt6DjXgoUQmSKw+LzijoKlsQtr4AzJzrryjbO9PKO3Dz3jptw98J7LGO/WTh7qlr2tRWmxnI58ZjqxN3VKFRAOz6n97/hd8SwJkGgkAUPKdP+GExMoLdlbde+iyISUoZmtD6nMYjIa6QXGatoaLqeIFQ9IuC+uZrYmLjapVJYO/KJXAjOnJ3uwfALiBhvGp69CaooA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 11:49:33AM +0700, Bagas Sanjaya wrote:
> Sphinx reports htmldocs warning on __vmalloc_node() comment:
> 
> Documentation/core-api/mm-api:52: ./mm/vmalloc.c:4036: WARNING: Inline strong start-string without end-string. [docutils]
> 
> Fix it by separating adjunctive parentheses from preceding gfp_mask
> formatting markup.
> 
> Fixes: 32904ba6f5ef ("vmalloc: update __vmalloc_node_noprof() documentation")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Closes: https://lore.kernel.org/linux-next/20251020134902.3a11107e@canb.auug.org.au/
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index e207ca64a688ee..091a07f6d92524 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4034,7 +4034,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>   * Allocate enough pages to cover @size from the page level allocator with
>   * @gfp_mask flags.  Map them into contiguous kernel virtual space.
>   *
> - * Semantics of @gfp_mask(including reclaim/retry modifiers such as
> + * Semantics of @gfp_mask (including reclaim/retry modifiers such as
>   * __GFP_NOFAIL) are the same as in __vmalloc_node_range_noprof().
>   *
>   * Return: pointer to the allocated memory or %NULL on error
> -- 
> An old man doll... just what I always wanted! - Clara
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Thank you!

--
Uladzislau Rezki

