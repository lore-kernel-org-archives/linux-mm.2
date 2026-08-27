Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20449C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F94A6B0099; Thu, 27 Aug 2026 07:40:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D1396B009B; Thu, 27 Aug 2026 07:40:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF5A6B009D; Thu, 27 Aug 2026 07:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 110D66B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:40:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7853FC03D8
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:40:19 +0000 (UTC)
X-FDA: 85146856158.23.1BE5F4C
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id A62FF40003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:40:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KcuAK99l;
	spf=pass (imf01.hostedemail.com: domain of sef1548@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787830817;
	b=qG4yl9ZGuI019yvu17LvvibAcgHlX7ngGIMPosNOBhymN7yHEelpkNWMYLIBXs77GZAOiC
	mOwUQR5F6Ch8DIyXA8yNDYsxz69KS0kkr1YYQCXN00omSDZ9u+Kmio0/klHNCo1w8rlEQL
	DUIuY/AYCWA6a0xqv2mpALDrJfS2r1A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KcuAK99l;
	spf=pass (imf01.hostedemail.com: domain of sef1548@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787830817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1JOPQJp+51uCszh+hJ8mwVKxXA1ndqmwYZcjdWNa5s=;
	b=xbA7PmDxSX6s0zp+qkeW2kJSGMjGlnssMjo4i2wUjD4xDnzqGI6uaYbIRep0dSpxhW1JVu
	NEXlKkYC4+i8N12YP2KkIAwzrvG0WSOqBjGsRiLtx610khY97Ql9z/hOzn5QrMLv7CwyPM
	016/V3+8+SbQfmK2BQlbNS2gGadTi7U=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-396b3d0df94so465815a91.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787830816; x=1788435616; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t1JOPQJp+51uCszh+hJ8mwVKxXA1ndqmwYZcjdWNa5s=;
        b=KcuAK99lo/iS4VR4QqvmZ1U1NHWTqn3jP/m+2phcAJ6QXlf44CUIPQ68N3Hf6pI7O+
         cBwyxuA0RcCYUG+BQa5eWa3ZNLeloA0VV6vxg+Jka6KTKl14WMuCwC7rBRC8Pia9z9JU
         vBTmSFHVSpiHEgiAk3Cz0OVZSwyjytF7xq0N+5SHCQUQT3kVR2R3Q5YB19WIKlfkBkO2
         DLfS/NQyPM8ug1B93GQpIT3nUSn74o/rUD0U/D0Oo460/wRcqlYgbvVaWH5sgeIefCl9
         xXIfkU8v4W4JJhx+W2SzVTtCuo0JWnPfGLGxrQ2zaMrs35qT5eB0qJnjntROsG8PqKig
         uD1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787830816; x=1788435616;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t1JOPQJp+51uCszh+hJ8mwVKxXA1ndqmwYZcjdWNa5s=;
        b=JpA9H5x6rOxFKtmplrc4Gh1UxUbqlA/YCeLd/RHvV66JiEhzXuXmf1q94TwthQbP9g
         HO5xKjpLDFZlwf3pIksldTaAt3lmP8tz7AXKiH5hlrLnhrmjInn0l+sb7muPhNbWJx1E
         kMxpA4Eeoit8dSR0oeQ3FsUe3adnI0dr1fGsDNnYXQADzOuq3ExqBv0Ta6XmrhVjuszh
         GRViJRQPL7t7DOXuhldxUJoonKKihNxJpICKVE2UlMNDTpLoPJnVHC+TCRUeQ44on+sx
         yQ/ZNDrNS+Wr38uExx4+y6OP+dgvOnmCZ6zd8UhR+i4LF+acjJTxAXV+Pu/a7MycERlM
         B9WQ==
X-Forwarded-Encrypted: i=1; AHgh+RrnwM1X6AInq52j+W5QwURIIm44T6dSFpbRDK4FepC4GOcvC+G6h8lmOtfO4Hapf5q7cX+3ZYMyjg==@kvack.org
X-Gm-Message-State: AFuF++n/LtPMWR9vw/wgqCqH/xnKvKxLZ4XSDHi7rWzgEVpR0KJtHiBR
	5uk4yuokLZy7IDPDY8a3xN9fdM9OoGOTxzAWFySisaQuFOSMEcj7xxzXWkXu07xQ
X-Gm-Gg: AR+sD13BWqJ8dPdPsKqcL4B7YuwybAzRJyqkqD+kBqNwr+4fTu4f1bczx1DHmjP0y4u
	Q5nnxUZAsju8wzvRfid7O2BJ8wDpEUJy/sAWOL+b43dbt6KfCIynLeW8VlGQBY5pqcqkTpKsebl
	M477SBt7LVecXeXkUB17RC8CNmoI7BpRYCQK/5SkAtgLr94+owJwW7uytYEqmUvDUqKYoteG5Kz
	CRlDABVA/7OfqE+YwqdIUkNh/80Q7ZJe1Ir2wKAlKAcEcqOSSP7X+EjQ28HnCJMAXGq8/E395xR
	618qc7qxgjKNrXyEwMpxnUrZVXZat9QeeHVf8E/F4Fe7PpSWTq3j+Bfa+LXMsyqCTD2Us0MzDee
	KXdnWChpiPfAiH8qh5FsMZ2pHw+EtvsR/X4cosRS/ebVbUFYhinAi0tuEpeZ2nloswoch6+dfTw
	MwUgmxDPSHtnhUFlPWCwcnQjgg2ATG8xOkIH7aCI1kHVXbhpAu3FI9DHM6oKoKB1LGrNwi/CztF
	+zSO2BOQz3ImkS2CFKfMdJlhsX5lLiThEaIrG6t6G9sTMqTHiBsulQU8j9ZW/5weJJnhp9yV/Qv
	EOieObany0E=
X-Received: by 2002:a17:90b:54cb:b0:37d:f206:a2ac with SMTP id 98e67ed59e1d1-3966d5b7c62mr30914853a91.7.1787830816480;
        Thu, 27 Aug 2026 04:40:16 -0700 (PDT)
Received: from nickhuang (2001-b400-e2da-56f3-9c0c-c5a1-7839-5c55.emome-ip6.hinet.net. [2001:b400:e2da:56f3:9c0c:c5a1:7839:5c55])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0d3d7fbsm2475627a91.3.2026.08.27.04.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 04:40:15 -0700 (PDT)
Date: Thu, 27 Aug 2026 11:40:11 +0000
From: Nick Huang <sef1548@gmail.com>
To: Yue Haibing <yuehaibing@huawei.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	baohua@kernel.org, youngjun.park@lge.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mm/swap: Remove unused declaration
 swapcache_clear()
Message-ID: <apAiG61Phh7ANjzT@nickhuang>
References: <20260827082722.1809702-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827082722.1809702-1-yuehaibing@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A62FF40003
X-Stat-Signature: ky9fcmmrr1yk9rsbnxx8xj1egtkgxsey
X-HE-Tag: 1787830817-958134
X-HE-Meta: U2FsdGVkX18SZ009qy6C5TaopW/qM5COyM/oQnbb4m96m5qCdGg02sNSuUgHTFIete3kjZ5WYVwD0N6MqozklYmNkb6fVW04DGVgWMvV4ruATQxOeUwpRRlH8BLRDUncSrXi+7oEFPqMMQssT++Xn+CC3acKV7uIhVD4Mt3ougt3owAS7C5BNfmYTZsIE/ZljHJx4uft9Yn1kdQdEoHBPgDBYAECypPx4uAOCgjGBwtZR4gLRf/mmPFwZGBJ2CilTPlwggd6ZH3ZUNyjSTdzb4mkr/zHmgRGvSWFgZgBWiovS/AUEGMODwBnghUvpSu+Ed0yAdbhh/KuLA/ORR2fvCCzuH+Km5gmASL4IGsLHPIiLOSAjgTxRnoEf6XfafJwjH23kS3fFl6kD6mMej91mK+3Jx6+fBbg+NhRTk1+p1JULgjDQyoqegKDxaeQz+xsXV3YiTXpwSRgT6gs6z+4Vd7sjAqSJHX4mp0689Mjx/CBmq8PCHH5EZ8I6xug1MaHz5XDpnG6g+P1flNeHht2DWQr6XT2Z5XRsVysZjBhvD3/7RF3SWlno28a8YCFeI83eMkGQxIr1v5ObyvY7Zgl4hh54AjEK0glqb34iPLjFI6MMNuUXxHsgOynUeqVn20kjiSuTs3oKxr4BmNxCbispbFE4n93uOy2uoKAkWLDVImCNm8CZrxaMFmY0iyRHhRYv2nyPKZ8Xcj0e33TU8VhWWyFXO0nWLbof15ODqPOSCDCyHX5QxO0E/MTjQf9BLJBwUV7Ic8gGpI+agTmL6Nx5bGL8H9manhs+iYkP/7un+X2qbBQIK6/4Q5ZeiGTQKyTAQ8iHRFfNiwgJetOPAcvzo3ym5l3CMSIsuxDsxUtwjyZb/Xsyzo8VAk4PveAVkLWqD3ao1Z6lcIWTrSz9mbjjznRReb4Rx+eKbYm1DNd4U8KU69VSwUG6nEzQ1KE5sAMcWm1dTgQ8WgaS9d6VtD
 L0RCeJME
 ZLzDFtOrzXisSJEJFWk6EPJfY11tv2BM+YleSVBjS1Ecagbk1ePQfpJ+J1g9eMrXf+QBAROFxn3CCPVdAJtbNS5Hhabj15bMBpknHrHJ7qVp+q6FAdHYyJ2RYoWRuTd/CuxbkMb91KnhO9QHvXKcytyFKyfyAh7zAVbqQeaik7sE5+Qw+OJI/xBWk0Jtpu3bWVLiZRQRLhGxsFybq4LjHIYYujivXEhNreqkZmLdZTB6K2yHEKuVfsDppGiTdiNP3EhnJ/n2JFDEF3JTCZUwGjHNzp16+4iip5NtfhEU/1bZwBlqvnDBEMOeUR/rGQhJkTYZrchzCuFTWxQrC9QhrqGOaoXpYw2lXpOt5cCT+HI9BSzgLELcl5a0wJgCMlgwN9SyHCP6PpYrlz0MNnYOW6lV+C01UTuPAArifhIw4jnbf5qUKMk6ejTaLPg4syvVn6y7Imx0eoYcI88hX8cdamRJxgHC+osrOT7kN9siwv/teuQ/6XVw2hw+7rfGIh2H0fauSWi8A5MpY/VVM3U6D0uzzVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 04:27:22PM +0800, Yue Haibing wrote:
> Commit c246d236b18b ("mm/shmem: never bypass the swap cache for
> SWP_SYNCHRONOUS_IO") removed the implementations but leave this.
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> ---
>  mm/swap.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/swap.h b/mm/swap.h
> index d077e5893a42..29060a305443 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -344,7 +344,6 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
>  				struct folio *old, struct folio *new);
>  
>  void show_swap_cache_info(void);
> -void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
>  struct folio *read_swap_cache_async(struct swap_io_ctx *ctx, swp_entry_t entry,
>  		gfp_t gfp_mask, struct vm_area_struct *vma, unsigned long addr);
>  struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
> -- 
> 2.34.1
>
I checked the current tree and only the declaration remains:

$ git grep -n 'swapcache_clear'
mm/swap.h:317:void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);

Acked-by: Nick Huang <sef1548@gmail.com>

