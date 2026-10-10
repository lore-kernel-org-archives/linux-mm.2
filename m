Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BDA4CA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 14:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 164196B0088; Sat, 10 Oct 2026 10:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE286B008A; Sat, 10 Oct 2026 10:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6976B008C; Sat, 10 Oct 2026 10:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C97A46B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:26:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CF0D1A08E0
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 14:26:38 +0000 (UTC)
X-FDA: 85306942476.14.8DC32D9
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 68EC8140003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 14:26:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pIXuXE5N;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791642396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sud4Kk2KOGUwm2j68I0efec0mWQp36Kh5Z34rJLtTPs=;
	b=lz39v3pla7o1xviz0pvM4V//LgBrwnynBgjgCa4Qfu5omiB85Qv8n9iHjrD2FaLRNyxw+q
	YaToycJQScvxiSfnPIIGdoVRhCp7ZR90sGTAbsB/pXnPOR2kNZzGD8paiq77x0XquyyUCh
	vr7Xx5/AGOgKhP7x/4E7ogvx9on2pYk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791642396;
	b=u0551E1oKfXapYmCBEHm6ONp9ZiHaFYEWDm9paqKBAvynSsqtuKGFgml13R3fQbpfz4Gv8
	f7mtIrT6xgJmLBgcojagmcx/k6Yt7G9CFIvsIkeJeiCsqO7YOwS9vzW+/Wx4sccLxjxlDq
	XHTu9UCRf6gphVxzmJS4AHYWdPOSrjo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pIXuXE5N;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5337fb43c16so7039111cf.3
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791642395; x=1792247195; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Sud4Kk2KOGUwm2j68I0efec0mWQp36Kh5Z34rJLtTPs=;
        b=pIXuXE5NaNheLwnrzoJ+nFIK65XJmh0fHp5hJFxchdWtUlUy6EXPhff4yp3YqTLj5r
         GTLwbGUmpIz+Ut1kCsRCxHGG81mJNqCCcyBVUOBNT6XdzBlR+FR4RLgv1M51PmAI2wOG
         k87xlnO3AD72MWmdbJNPzQ7bl/qEOqLMNEbGtjqYdlSIkkqW+tsUKL78LKK44K4KR53g
         vR+HS7n9pC79Vzpa58lriiI+Dk2Ywu5ML+fzywEqEN3ZCxZVEFBPbR3PCJj0Gw7Xc+W3
         4BLw+6vHci7yCYddxTAtdGEsorOCi3RWoImVdPhCfvN6cCw6ccY33EcKWjtzpXShN73C
         NI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791642395; x=1792247195;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sud4Kk2KOGUwm2j68I0efec0mWQp36Kh5Z34rJLtTPs=;
        b=vfwuAzgL0JVK326Ubh4q6C1AeAufGGhSCeuoCDWYBooK+F4eZgtbXIFHaawZ0sFYZf
         5FQmxhWWwDSeCayNavknTWtuo69E96SxBWJcZqXR6N/mQlUJJ02kAUx7fF6EovaNITp3
         F7QrPqhC79vLPXEMMTzByPnZhkBJWfCiiCpkzL2h2H9g4mKiXpWGQCZ5ITtFrVa6CI5x
         JOCj0TpXtqGudpGHMm1ClxvCdlaSz3xWX6TOolvNb0BESe7kP3JdipxlZQrfOU17yKgi
         Qz4sqEsG/wxWHtoZn2k0qsUrXmQvCnWfM0Z04YQlcBq4UAblV9vquDSYaCGXmTiBtODU
         n2bw==
X-Forwarded-Encrypted: i=1; AKwUvBwqJ/qnUttRCJwAobntT26lsDxOxnYLgfeVrmPOZ1R4mAfoeDoTWP2xDbqh/op4FxwnNQiU1/Sz7Q==@kvack.org
X-Gm-Message-State: AFq9FYL/6WHbOI965ZuzDml9NvWJyuvocbNwIx+SvfNS4f5XulNkI4JL
	JKBoafN5u89pVXhJEJA+hokdgfrcfgmerlYXSYIUHcwBt5LnmE8OWceqIaTdBq0twOs=
X-Gm-Gg: AYBFou0gU3gC/LUpaRUrZ8quyqKjgjRdVPE4sysMEoOIxdDKlSbpiVtfHcs7lhRuu39
	TtPD5DHQ/btscYL3ePLRWaPjlXEen0FeDupi/u68HfeyTrJBQVSi/9uXK82CKe7M7Eyj20G8FKE
	VxKjAFaXqjhP27L0t+a2zSsAZoaLKAHRuHbUmE/FfNqz9KwEcv3Tq2zlJy2/JyR0v8TZYSRrTR5
	uZOwt24GqzbdVrPOFnodh96nwjttD8NqBnpafRPBRo+XD4npMBIkozoGiL2TSnbwpPmdA9avilH
	XeTOPqmUcfxlhnq7KN+1FZcTXZZY5Xx69QTcSof3g/Fkv0agc1rEG9vvjRbJ75C93XPlYyVOyxX
	AFiixiydjx9w5AH8C8cNLmzS9C9xuk8toJbwHg3jD+FWtvkbI0/YB5uR2RzkfcRVYI7oZf6O5SB
	sZqwhRnZcf6bA+cPZ3e51ZX6m2g6Q6mzz3Az+h0x1hTsgdFfcZO8tvGtKDaQ6EzQPY8WdYTlk1L
	biyiGP5XLBz+7Zq24fDDdyzHVARzBmRi21emEbvtxthmn6wvcDVGDM=
X-Received: by 2002:a05:622a:4d93:b0:534:b7d1:cd1c with SMTP id d75a77b69052e-5359f498f75mr87118251cf.8.1791642395448;
        Sat, 10 Oct 2026 07:26:35 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b79a186sm41486481cf.20.2026.10.10.07.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 07:26:35 -0700 (PDT)
Date: Sat, 10 Oct 2026 10:26:33 -0400
From: Gregory Price <gourry@gourry.net>
To: albin_yang@163.com
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	david@kernel.org, vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, albinwyang@tencent.com
Subject: Re: [PATCH] mm/madvise: add cond_resched() in THP branch of
 madvise_cold_or_pageout_pte_range()
Message-ID: <aspKmWIrOzNjiP-t@gourry-fedora-PF4VCD3F>
References: <20261010024042.4070048-1-albin_yang@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010024042.4070048-1-albin_yang@163.com>
X-Rspamd-Queue-Id: 68EC8140003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: d9u4zedo6u645ernxet55ahqs8s6m1cz
X-HE-Tag: 1791642396-548188
X-HE-Meta: U2FsdGVkX1+d7XD82vZpf2JbiKL39UAS1I5Rz5Wk+k203e0dy2h19R/G4vZ0TYaBXOFP3cVdCh7Nsw7EEVXFlMv/+lsHcXZB9Ylixze6vfsZ/7XcOdcB32b/lcT2ACUxJgrvzAR7H7RbNeNYhUqDPgF29cHA4YhtBncHrXK7JzeYYozz3oqApIrMqraLR5g3AmNtPgXuqUOArYMb4gKONquYSObEbd2C7qJ+noRW22/SGZ2HbiTjAFYR6OCdM2G8adCZKq5q1G/mIl7IcHMh3WmXbHyXzVgansvYms1vShFNt1enyeirVqDDMexrpifbMpQS0NVTYFxKeiJCWxAafMzpMPi26za/s0vzhPCgnAK6OtUGxenGEe2iyecAGHKaj67JrIva+nBrb2HLP9g1qCZM2noRXM34Sl8kT5iOCWosjzCCLdC2IZx24whN2BJPoXNxz2Jaji9Exg3P+3iP1JUOyRVNG4aEp9wOH43cu8ZOjTbfnjhbztLUhXn7RZ086d4YysnlSz5WIQ4XKJtLUHy4ccscLUc9Oug/0gzg6CdmU2ycmQkg+u1c+xp7VupmKf9IhiENDjZOINKKzV3qSUqygiPgpWFQCl7wQ7IGqkMMb4rhY92KLqZhdgWYT3amiYhBxO0ussTi7eZ23ICGLj/uGtWRzL/pWaou2O1JXaw6w3Iv9suYKnlwBgSRm16tb/e5v4cIZa9IdaJUfqeJdFjdxohR6tsPG8KrfaoNd2npjVDshix/IIdTQE6BqAQKXE4Fbjd0mHrkE2fhP/PzYrpthq3XjO5QvwC+sECH8ZUePeWHtwYtunZSzvrS0zhHy1tOreN7LY/+3T2YdYoRDuQJflD8qm6JfP0xtHfJjMlrv3bAtfiE8pkHZjRiOKk8lEjFqQOLyzsd5/SzX2Tlxf6+zOMFWS0cicnC0Hceb1976tFbvytZRPSBClO5PUWxkXKsq1SXXs/3U/QhWTF
 7dLq+7KG
 QpGzmxi2eZcxi5JrJ6YDMusUebTBXLw4Rui6uVxBD6Te123G1Gt/UP3HayEv2FhNLJAbSZzCK5Kr28zGfzPNAqf9rdrpGX+gOz+0cVbLDbrQPPd654NCk8y7GZH4nh4UD4ErkPb4WuFZULCHP7ThTIzAcQ+AVG763DEeKT8eYdwRQfsXQwnKdBCf1oFDmZkngZsF3XkQiCVzqFtMoTOxZ2p/hA1cLmeAwfHSwccwa5Td9ZNVw8Woagz4MiaKHou2QvgPm7hNN/tksl8n3FQT4lqHy5rNZPD8/iKlanAheIIZopUaJao3+V4nQqIlQLdiPEnjdGxF6NkkAAZXcnulGXxI5c4246aJgJEUUW2CEq2HOZYPCT8CAYf+Hl1IOWxQ/hj++2scgcEph2idIwfNIcLoab55DwTE1gdzcwT5f7bhs8YrSQrLX8gqIQEKhynf3sXApKNTIf12xM261OiPHqpqoOS9BxBlQ8F73jyx+JDanx/XqHEu8UmEKSwblzpxzc4fl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 10:40:42AM +0800, albin_yang@163.com wrote:
> From: Wei Yang <albinwyang@tencent.com>
> 
> Crash log:
>   watchdog: BUG: soft lockup - CPU#63 stuck for 23s! [stress-ng-vm:1665914]
>   ...
>   Call trace:
>   pmdp_invalidate+0x48/0x68
>   madvise_cold_or_pageout_pte_range+0x84c/0xb00
>   walk_pmd_range.isra.0+0x1ac/0x3b0
>   walk_pud_range+0x120/0x190
>   walk_pgd_range+0x170/0x1b8
>   __walk_page_range+0x184/0x198
>   walk_page_range_vma+0x94/0x128
>   madvise_cold+0xd8/0x198
>   madvise_vma_behavior+0x234/0x638
>   madvise_walk_vmas.constprop.0+0xdc/0x210
>   madvise_do_behavior+0xa8/0x328
>   do_madvise+0xd8/0x140
>   __arm64_sys_madvise+0x2c/0xe0
> 
> Signed-off-by: Wei Yang <albinwyang@tencent.com>
> ---
>  mm/madvise.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index eeee82cf2b3f..0755e6d99757 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -450,6 +450,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>  		spin_unlock(ptl);
>  		if (pageout)
>  			reclaim_pages(&folio_list);
> +		cond_resched();
>  		return 0;
>  	}
> 

This same improvement came naturally from refactoring the entire
function into a proper pagewalk structure:

https://lore.kernel.org/linux-mm/20260922235830.2350770-10-gourry@gourry.net/

this function is really nasty.

~Gregory

