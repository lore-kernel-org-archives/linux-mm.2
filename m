Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF81DC44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 20:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926746B00D1; Mon, 20 Jul 2026 16:05:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD7C6B00D4; Mon, 20 Jul 2026 16:05:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816896B00D7; Mon, 20 Jul 2026 16:05:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 481106B00D1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:05:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B91E11C030C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:05:20 +0000 (UTC)
X-FDA: 85010234400.16.66CCBEB
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id EF49D1C000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:05:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=osandov-com.20251104.gappssmtp.com header.s=20251104 header.b=JVEgdiC3
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784577919;
	b=2Xsj/6fQVa/l5dTpORx5vAgCDB/6lr50UyYrj6eRm4l3AycpyKT/XB/Uw7XiYKkbXKQ+6R
	gFm3+w0Ts2ep5sKmtjsGG6WJ6GuVce5MdWHEAWSYiDO7/iFNn2k766VtwKED8rNuQEqGZH
	Tj1BJd8IUSC+DU4U6sy0n9SYscyDr0M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=osandov-com.20251104.gappssmtp.com header.s=20251104 header.b=JVEgdiC3;
	spf=none (imf21.hostedemail.com: domain of osandov@osandov.com has no SPF policy when checking 209.85.216.49) smtp.mailfrom=osandov@osandov.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784577919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYywQuRzpuUyQQKl8IkB8b6aSBOL9lUxtR3YJXQirrU=;
	b=dzrkYNu9zznT4UMyk5QdYFZSNBaIi71poiNAr1KxAFaNUspEElbrhksGiab5p7a0YBtL9Q
	AiBNuwwy0jlc4HzO3DCFstmu29pZSPzPOzF6XuPPbMa9kSAWFIxBoSqtUHKI4gBz8mmIq9
	A+6MYrIEFLSFMBhmVARtbZLE1bKoS4U=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-381f03d7be0so1554502a91.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20251104.gappssmtp.com; s=20251104; t=1784577918; x=1785182718; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KYywQuRzpuUyQQKl8IkB8b6aSBOL9lUxtR3YJXQirrU=;
        b=JVEgdiC3U8QjvxnCREmdVHDNs9gORVIitDup/nndyMRjvgGNA2xuApbiPtTJN04zVf
         FtJEnQDWbFdg04b6rUWQFtptC98SZGv2Fwvprotx+p1P9aCKVI596RbOBMhJemfcgrQe
         EQPnLqhvbp/mTYblS6KIp4oc4o3D6NtR/GxYX35Pi2/7/iY0tppU3O/KRlTON+SCypts
         7P66vwBzEtXi1ZCalf/Jqk74kfb6YiHVEhhTCt+u55YaSkzNji+IF9WF23XZ/pB1JvtZ
         6aqbV/vDMvZgHI9osFnslSEBMJbgRjd3gVzwoN2ewZf6AQqp41iqgEP0VhOuG5uZfXUm
         7glw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784577918; x=1785182718;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KYywQuRzpuUyQQKl8IkB8b6aSBOL9lUxtR3YJXQirrU=;
        b=Y5Za2pRDg4tIQiuzaLeKVq/Nwm51ea9eLgZYUUcmVri6SUgFh0rS5um5N12W1IQChf
         LKd1r5FOO62sGfWv9Kxg3NDkhOGx2Z4ZcgOOUp9eXIIc+054iVKZ0GaEScZO6ycJhlU6
         Ms5JSRzedxywWfekATPLLqYUoVLig6UzGUsPZMkUGQgt9BLWEaPEoak1Bxyqbb8Ebyli
         rdZjPshzzh0SQcKa2tfxSOmwfIkyFcDHbV/yOxsVjkMzF31MYseZ6xN8zgOgxC6GnO0n
         V1/PdC/L7qzi7+DcgRD7zSoeVYaOJk+lFb+QWYvHwdWdaEhPOacBZqAHxAitPluWPF7s
         6A/Q==
X-Gm-Message-State: AOJu0YxL79mfvnOrkBAwAzjEaLDbswUQJUfyC4wZdQURL9yjzh7wC2jt
	WID13K5+slSf0ztr2bTLPEnVjtJa5P16KK+W6nM/ZMPzzFDiFrc3FGYGXY55JkZGr/c=
X-Gm-Gg: AR+sD10VsPvFEYj533yHse+pa8d+pwQLOdRm7PkqjHMOp+7ZMRP0fgB27WwLqx0b4PL
	HjyHH8lkQjLr1kWr0MbYsN4bMatYsfPUOXHOIWpwBJKJ20DlOfpN0bg25qugsV6ZC1qNIlxuyPj
	/L8fp+uA4RIEcoSIAruePPYjBtCD6y1gnL6NTgePBCdkyUIvA7jOiQKgX8swRred3DR+0l+fX8m
	V1E8zUqT46xI8h4TFKO4Ye+qlz7VxzxCYHnkKpWTj5mRqB4Y5s+gPrEmYfLF1Dt1vuBVVf2yVIg
	2Lpjr+q5nialsFN1votRe20b+OyYWxqea37vNjTb6S3aAUvv3DoA5/gGy5uFFuTZrUhykPozUmH
	0ObpewaCwPFco+LAW1oHC4/avD2sf6WXqafQUEK+HiIdc+M/NVCKXse4M3J3dfKrxMoaQN7OrVP
	eo/iHQJBdMTXfjbl2g
X-Received: by 2002:a17:90b:58c5:b0:37f:eda5:516f with SMTP id 98e67ed59e1d1-38e9283cd0bmr318608a91.0.1784577917883;
        Mon, 20 Jul 2026 13:05:17 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:500::5ee8])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce29e13a8sm33372118c88.4.2026.07.20.13.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 13:05:17 -0700 (PDT)
Date: Mon, 20 Jul 2026 13:05:11 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com,
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com,
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, jannh@google.com, pfalcato@suse.de,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org,
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com,
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
	usama.arif@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
	cgroups@vger.kernel.org, damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 21/36] proc/kcore: include private-node RAM in the
 kcore RAM map
Message-ID: <al5_d2XCbaRBhqdJ@telecaster>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-22-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720193431.3841992-22-gourry@gourry.net>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF49D1C000C
X-Stat-Signature: e4netcxx3upjdmbtyhc6zge4yxqajc6f
X-Rspam-User: 
X-HE-Tag: 1784577918-9892
X-HE-Meta: U2FsdGVkX1+qDVHg9ibHGo2VW8j6X+QvkxDkiG3G3TALh81Nm9jNZkPdmSBxBg4gYdxd7zAAZPvDmAwAQp5MSx7zfLquIC8N/Qr9kwlPhjrGj4LI6BjKVFyS3ii5DJURxkCeZMApAuFevxNsCqo5cPzxgJd0vaUR8UPNvoY4I7yJwDo8Fef+qxEEs6q9+ojQ+PB2juDs43viXiCqYkvqnFyNSZwGdkGC78wfyob7rMhyBe0Ol/PMZpeUyeRrkZjCShjIzPpa8PKagXWbyPjvQ3N6Sz29x4kCVQ4uEx7ZPQlvP3DqSbkPIf5JBUZIH892UzDCtKvGn+DnJPYutljhTjhumc+W9lYmF1AtJfAQwqkBpITvPV3zdWcFsO46ajHZ+WduxsZqfVXLaqCxwLl2hWeggXtxW52mjq67eOIWvrYvl4xLVAeVUmHYIQdWnCTuFlqY6Q66lnf/qpVJjPZaVLenj0CkZRa7cwX+FC+MevvZot5gdMG02qO7oQWdQw+HfSi+4Cok9FrT3KDv1GW3FNEl8r050Di7sAvxxkARwBhvH+OCK/sbA7UuFC7Wlo4e6RtyjZwBc0ess6F1sMpG3dUFtSN3I5OEBLjVpXMBZks58gOBdExo8EE5PsoaGcx1Jc8t3Tju67WamV7xt0IfYcFYSFrYgmJGHRDuDImVKQgNwMaKcjQLiERdmDGtz0QMeqa3jErvxpr79x+6cpFIQZUp+bPxrJNFqBMkntu8epgNGpFZVe/cnzZQvVPahhTvTgvC7upf0+w7kM6DQdFGjmAV/OC6XhxZqK4gljiHuNQrN22fX1QAqi/roddpC2nDsRtuXPUrDCVRxHExf5FCPm9RE+SbjVICW/4JdAVLO4/SKfE8FrWnP7TjgOmPiOThjI+4Mhw2shogFBCK6W+GorLCCM1RtDPr4EzUh7LAb3YJdKBCjqLjZetQlWZJXv4PK6h1I8DX3GCaLg2hq4Y
 AJrZBihM
 52uNXCNQjCGlTAFbm0hq7KUNx/sK09EWkXbe4H3i5VMcn/2Ay0AMT1W6f/16a2+fiQOAPGy2n++C9uBpGDblta89hWC8jJDB6kpOjPCIRw94e0Or4ieBI48oSfXJkWYGr67yHFGQsq612iBszl6Zx79uDk+z89IZMU1zO7VQ9YvVqcdmnmIlqXQdY0CGa8+i2EVo5+dL76ke1rqGA2hdRC3Xelc6xiKhLfc9nrTPQvrDjbMyLmiijHpZmeetONnJ+eaRjFfW3b4fQYR3rz4T/lk5CSsFsWcFoG+0RwWvSDnvlVm9M4P39P+r/rS+8qldtO7VBSUBq18Hq8tjKka39qIb2UBqtD6tp7BN+AwXsVHIpb3XqYmXoGyI0Ydhg/yiji1uy//OrJ5IFg1F4B2iuR4jMSOX0dC5L9UOjjWFbKVFkaq5OT519E5GVj75dV/vGISfHfpHuLeDKwzSa0d2GxcDZ6lgMhf5fh61qlorz4TmzEfBfpFOYzhC/9JkUV11McUjnf9tQrPFquo51CeNZ4fW/RMOR8b99SlKQOrgb4AOvgaPateDfpMo8dQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 03:34:15PM -0400, Gregory Price wrote:
> The kcore_ram_list bounds its scan at the highest pfn in N_MEMORY.
> 
> As a result, private nodes placed above the last N_MEMORY node, which is
> the common case for device/CXL memory - is truncated out of /proc/kcore.
> 
> Include N_MEMORY_PRIVATE nodes in the scan boundary.  /proc/kcore is
> root-only (CAP_SYS_RAWIO), so this exposes nothing new - it just lets
> a debugger read private-node memory like any other RAM.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  fs/proc/kcore.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
> index 390547b992acd..f67194dc2a9b8 100644
> --- a/fs/proc/kcore.c
> +++ b/fs/proc/kcore.c
> @@ -251,11 +251,14 @@ static int kcore_ram_list(struct list_head *list)
>  {
>  	int nid, ret;
>  	unsigned long end_pfn;
> +	nodemask_t mem;
>  
>  	/* Not initialized....update now */
>  	/* find out "max pfn" */
>  	end_pfn = 0;
> -	for_each_node_state(nid, N_MEMORY) {
> +	/* Include private node memory in the scan */
> +	nodes_or(mem, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
> +	for_each_node_mask(nid, mem) {
>  		unsigned long node_end;
>  		node_end = node_end_pfn(nid);
>  		if (end_pfn < node_end)
> -- 
> 2.53.0-Meta
> 

I'm sure this is the least of your concern with this series, but FWIW:

Acked-by: Omar Sandoval <osandov@osandov.com>

If everything goes well, kcore.c is quiet enough that this can probably
just be merged through whatever tree takes the rest of this work.

