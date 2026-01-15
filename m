Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3860D4661B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:17:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B21C6B0005; Thu, 15 Jan 2026 14:17:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65ED16B0088; Thu, 15 Jan 2026 14:17:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58BCA6B008A; Thu, 15 Jan 2026 14:17:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3186B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:17:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0108F140426
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:17:22 +0000 (UTC)
X-FDA: 84335156766.13.46DA3E5
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6C7F6100003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:17:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PMT73b2H;
	spf=pass (imf14.hostedemail.com: domain of 3QD1paQYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3QD1paQYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768504641; a=rsa-sha256;
	cv=none;
	b=nx2QKlx01ipSQ5aeX8UEYGNjqWLzR7ZchvHXC8jWwi19aDrLl1Fw59N7F5vEoWQCSRSHDD
	Lx0NlRlihO6feqnlXsv9utYyuTsj9GJIlEKf7sJsyUycldCgk3yi5zRiOatQ4Hw+QGBUfA
	BQkuryqmAfow7pDCi7KUUA7Js+9Mzx0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PMT73b2H;
	spf=pass (imf14.hostedemail.com: domain of 3QD1paQYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3QD1paQYKCLEjVReaTXffXcV.TfdcZelo-ddbmRTb.fiX@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768504641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTgcZS4Su6Azzs6FTl7APd5b9i+AMlUEP5Ldeqc7RbI=;
	b=pzs6/XP9tj3EfIEmTXX+LmcyDvTONUOHf4BzEOGDX+f1jJT43LyUT4yofTlo744dOltlt8
	TLsCEAEnXNsHIAdYhzjydmPrXrUijWpJYPexOhEDKw0/Dmq3DjgwyP310Rqdqir5xN6GsM
	isp8ENgPoyPTRJ42LItDvs8sblHJKZM=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81f42368322so1054733b3a.3
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768504640; x=1769109440; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xTgcZS4Su6Azzs6FTl7APd5b9i+AMlUEP5Ldeqc7RbI=;
        b=PMT73b2HVs7s6E8R+wHPKL4QupaMWeZl+O/5XJ9HBgFnWigkJ3jj+FXIBam2Lk4DqD
         CA1uKMMy8jNO9OG9o/QWuWY/B7lvOMSdREmNxiDRqxCtgOmphvs+aMN4HlYTlsveTWS4
         L23e/Nky0GEMVPVnmnWre6Nn1s/cBUyUtoRe0PrthsDAmJa4i5YZ0oLO9o05LE4e7mNh
         yS5DeLHZva3T/UpwHlhFe6E4MhMcCEGkI1MrXNmHfCXmViiBR9gsOy7n0EDLKRZDiJQb
         vsuMJRnR22pCmJv+iHX9jv8HSHmu+P59Jgnt8kx5wcpTLQKkSCgMXyz+E+heBrZBjgsV
         UNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768504640; x=1769109440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xTgcZS4Su6Azzs6FTl7APd5b9i+AMlUEP5Ldeqc7RbI=;
        b=U05PDSO//trxNi+2u79LZb1SzuWZJrFImXe++5zGDas9LoIhGNm1kuqnikEWXqdudZ
         ml6BkTRCLLAM5t6qPQChxRZv33Kkdra1RQuMcZTp/JtWT5DdH1eB4J/FVsyqkTHbcpX+
         yo+5nlJjWn9ukgOD3kXUJH/9avUyInz4YmKzqqEzQsNW+SAtau7UprOxqEO1yTr58FUX
         GYwfDALZNxzRhEdIwhL5GKI4atKwozktHqgIfUrAGgAPRC36hN3W8C81pKzMEESH2Mqr
         NcecyIRxVCLIKiny+rxFrKzQVAPGZjlvRWzA8r4ptcK9ANC6ecv3vfuYt+Oq1QpI6NjU
         5+BQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFIsqvUxss16kTCDnH720zJKd2KKKYO1p2UGuR/5BLVHcid0hjBj22HZ6l5SHcj/3h9McxZdGSUA==@kvack.org
X-Gm-Message-State: AOJu0YyKRTiz4y6J6q/2maeppuEhI33UIUr5vl9X++N6CyMUBgR/EObE
	4HtkMKfX15pZ2MgkP1bb8vBodaIY1E7QiLXMh9Z8PUH2bQWI8C4rKRbPEIRWPVXqYsNqBkTtUNQ
	mDad3FQ==
X-Received: from pfbbj16.prod.google.com ([2002:a05:6a00:3190:b0:7b8:922c:725d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2ea0:b0:81f:3d13:e070
 with SMTP id d2e1a72fcca58-81fa17729e5mr189167b3a.12.1768504640018; Thu, 15
 Jan 2026 11:17:20 -0800 (PST)
Date: Thu, 15 Jan 2026 11:17:18 -0800
In-Reply-To: <20260108214622.1084057-3-michael.roth@amd.com>
Mime-Version: 1.0
References: <20260108214622.1084057-1-michael.roth@amd.com> <20260108214622.1084057-3-michael.roth@amd.com>
Message-ID: <aWk9PusYNW0iADuD@google.com>
Subject: Re: [PATCH v3 2/6] KVM: guest_memfd: Remove partial hugepage handling
 from kvm_gmem_populate()
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	vbabka@suse.cz, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	david@redhat.com, vannapurve@google.com, ackerleytng@google.com, aik@amd.com, 
	ira.weiny@intel.com, yan.y.zhao@intel.com, pankaj.gupta@amd.com, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6C7F6100003
X-Stat-Signature: sn9hsf7nicffrq7m97uyxxgu9jminrrc
X-Rspam-User: 
X-HE-Tag: 1768504641-827995
X-HE-Meta: U2FsdGVkX1+sxx2ARru+jcuBaDGcRp/zqaRN8Zc45Sf1TKU9DSO6i6HWXq85rtwbi1XLGplr2CGyLF2g1ogZCnw03DZFHz2x8n2CgolNhse998VTvxJfm/00Yw3Y20O5rr+jllcRRRn02O393y7V8st0U8U5uA48p4GD7qKKsgUZ+NZdFKKKIEveznGmvwP8K+DkkHRNjYIYzTEhyeK6kU+OCw4r7rbgStoajaT8Puqs/fW7PS0mqglctsLkdj4Rp7bkurbXIVrSSwC6FY+sObdGr+4uCSu1V6ScPVWpEUlowS8wP9snS3WC4c5yA7u6MUxcs4B0zr8lfOJn4yLqR4qpi9qFUAQy7aUOZOsaHHESREEg38soOGxZ2mf/jfKvf4eCurwavlpOW5N/onGQMH+XjML1/g6uuSN8lj91WTnwOr5WGuXsXAiwITeH0NRudP7Unhip1dxtzRlDfpALU+UJTm4l2czC6h2wmuySpaHooJNXN+QCHCeh+KtyZQyTyAZBt8kkf0Y3Y7tjfP3QrW1T0L837Ois32diu28W2+fjBxkziDr6gJSkhz1EuoYsRrXce9XFWwRm8BOfdSj0i8gSgJKJnoUCb+pw8IYO+1fpHgE9blPd3PEpmJyAfHx+bnEr6WBO9SiCULBJo1IU9SoRWC7M6cj11ZLMyCMGK72loMXoCV6BizSETNbtDQufY0m+Ece85rrgyCuGad5GUEIEZcOj/fYHvqTA/thpgDrqkCWT5SRezrmuonk5QRMfrhwv1s+G7N61MxZPL/I/7hYht5/XzaradObuuvUdUhTPphR8mx1vQqf8qNhwDUg2wDRglweoHzjheM8zoWKd0MPDEmKF4wVteS0qUOMGGk41h2X0WQbwaDphbllWNXzY/C6M2SSTBE43oZFCb8fse41fqo9nM+DJqnHDUcIyXHCJEcFQMKiUf4hmaCm77pwzzNQ15ZleUaENpSWP/yh
 3UjgyBLT
 fy9mKbZx/3aHAOoQdD/qY1CxZ6PKI2J7kclVdWb61jzck2pPYHkFFJNxYKn7s/0TZBpHUiWguwlbmtH1+79fRWVlW7+Osej+UvqYxHP1psr7WUpX9ToBI59Uy3FwzhNkIyjSqfmPYOdxeVk8NL8HoGesR63jAKWVnojoEwkrIrbGs8l1DnWEKZDRUtoVA24GuEHDM3ZilTIEKCuoEYY2AhtFimWe8nPqMOFE6Kyp0N985op8RUTAJR5p6NsPMJixhAbTFGoRg9aoIZTmV3i7U+vB0IemSi6Yuz+V/VwdohHhRYg5yFZyIqG6te2IsSrzbkGlUKTuF79lGrolY21b9Uerl6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026, Michael Roth wrote:
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fdaea3422c30..9dafa44838fe 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -151,6 +151,15 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  					 mapping_gfp_mask(inode->i_mapping), policy);
>  	mpol_cond_put(policy);
>  
> +	/*
> +	 * External interfaces like kvm_gmem_get_pfn() support dealing
> +	 * with hugepages to a degree, but internally, guest_memfd currently
> +	 * assumes that all folios are order-0 and handling would need
> +	 * to be updated for anything otherwise (e.g. page-clearing
> +	 * operations).
> +	 */
> +	WARN_ON_ONCE(folio_order(folio));

Gah, this is buggy.  __filemap_get_folio_mpol() can return an ERR_PTR().  If that
happens, this WARN will dereference garbage and explode.

And of course I find it _just_ after sending thank yous, *sigh*.

I'll squash to this (after testing):

	WARN_ON_ONCE(!IS_ERR(folio) && folio_order(folio));

avoiding a few emails isn't worth having a lurking bug.

