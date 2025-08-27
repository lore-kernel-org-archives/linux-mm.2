Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18A7ACA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 14:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62A738E0007; Wed, 27 Aug 2025 10:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601EE8E0001; Wed, 27 Aug 2025 10:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F378E0007; Wed, 27 Aug 2025 10:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 432378E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:43:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFFC71DE69A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:43:09 +0000 (UTC)
X-FDA: 83822804898.26.6FE57FC
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id E781C80003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:43:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C79zpCxZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756305788; a=rsa-sha256;
	cv=none;
	b=AjJssfYWnSAwrirH82M24n2TGEEjg26YBmS4YJ/cxB+0oItFwDgB1vWDk1YmOKOM4V3JPC
	Z1/5S2yzeqePRiWSN2VpgziEbLgWsX9kR/brAHa8QdXoq4wEn3LBmiI3ROSTybMnrbjaOl
	jF65FHuOQmXXhWL2MLfxmCqAbk0Y54g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C79zpCxZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756305788;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7IZRDRVBKlmRBjlak6RScREmXVoipJRAnzz5R2AIjQ=;
	b=Go6Qe2uji/xvk8GFVFWa4GgE52SsxKHihLLpOtdQCvhjrp7zje7WbMyzrNrk/cv4FpBP/t
	6PeBkJPdoOIv0BnM5K9nz4iMFI46GJUZmFr662Dy8O+35btoYU2aC2UyZR8iUZd+1H3+ud
	vXxd8nlyBUZshNhBeF+GmUJbdWIOtnU=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb73394b4so987165466b.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756305786; x=1756910586; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7IZRDRVBKlmRBjlak6RScREmXVoipJRAnzz5R2AIjQ=;
        b=C79zpCxZ/+/MfYhzAsi4exHD7wdtj5tbVpx/RzRovux68XIAbu1W3Eq2u6Hbyo5jhI
         d/cPlnMkbC/7qydHS1J8utptYgkxxsTc4LNZ76L96UqAqFlrTZFoH/u3uYqx5jSjlqgN
         LxwdAirQDIe9zpldIfhRaYLV7v6LDA4bCl3eJz9nyMmiMvzMcHeDB0MLGH9sjVgyDFy7
         +G8WWcvQwNpHmZdmyl6+xP0pDZ6ZasxapYr+GMw/rUadzbyFIrVfHSz9SrBaISwy0Vmf
         5pf6Fpcxo/sX8u+hbWrPE+7DHSFtmn4VtSuU3whnAF56yXU0DY8Zb81uNe76l1tfyy+E
         m4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756305786; x=1756910586;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h7IZRDRVBKlmRBjlak6RScREmXVoipJRAnzz5R2AIjQ=;
        b=gAgXVApJ70m7A8T0LnQ5DjczP3oBlbtNDUSmAKBuptpDFeq0HeAvKXpSVdpLMgFxvo
         /igLKxxvDGkjmBnTalGmo3nnKLCptrCkuJXGpFiEvN0zHqWzl/u4ekm/sTdux/6v1rzQ
         6zN0KtcrtPqS0OpOUtcnN0wRKDpLOrL/pcwQCI4UnXi977aRM7a7Adg6zRwtf8QXRQdk
         GT2E49ZaTK0uS7n1326YkygRMd6ht5pq6w5p5v0ZEeTvjAOYsdnpfspqP0RrJqf7RJFi
         BMmxlQeNnweY5vGlygJUTws/1iphzbu2BWX3NVOaZzYrxj6dfz7HeXFUcBe47fuWhFq1
         uFIw==
X-Forwarded-Encrypted: i=1; AJvYcCV23cNi7inBBFIPv2TG/ZQ4aemhb2EDCKbQtlPagDfwV4F1mZA/Y6skCiBrwzyf7fXfsv6+/H/moA==@kvack.org
X-Gm-Message-State: AOJu0Yx6v3sVIrEB40/n7xrWtsKN+CKE3pSgU6JBQcqDao7ApU0hqQao
	xFT6ULIGiruxggUhSAHqwA+Czm7vVdizN3ptJ4p3H1iNEHEdJbLREhbJ
X-Gm-Gg: ASbGncvJwcLpbPnhAMZ6ZfrNJurfVdoD/aUpOo+0G24GmRHeKiPfP6O/zDjZESSD7Lb
	X6vF8QFk50cpusnC+iqUvQ9WEWt0P/FSyQAQfL8vEth1Kn66VIeqmHMxsHhCNSI4S13LXMXrj4M
	ijUUZj8NHr10gNV7TaHtxJFvIoGR7QdisK8rL3dkXkFrd2dSBLcPvuubL22wyaUl2VNoAW87RUk
	yHExoZymuSu2K7RmsEPAJH1thqmvZoVMah4+TktKNDI/2k4OVn7aKSl7IrYTtS1hhyaLyzq9gUp
	6Wwn0R5gIPGdsLFav0iQNCbEBbg6UKhRbvWtKrglD7IbFaQs+CNd5LHGwhR2j6B5+Q25xLZuehc
	MRsBoCf++ynxKMKJcU+1f3oOIyQ==
X-Google-Smtp-Source: AGHT+IHF4tvA56wSqinjDHbP9DHVeUfxBR/Yo9eC0OQJ9ac9gpPoPbPgaeKveEpnCMnZsoBulPK9bQ==
X-Received: by 2002:a17:907:94cc:b0:afe:a7f0:80e6 with SMTP id a640c23a62f3a-afea7f08490mr664160266b.33.1756305786378;
        Wed, 27 Aug 2025 07:43:06 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afeb167670esm328732766b.112.2025.08.27.07.43.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Aug 2025 07:43:06 -0700 (PDT)
Date: Wed, 27 Aug 2025 14:43:05 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: syzbot ci <syzbot+ci5d256d8b5e60a751@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, richard.weiyang@gmail.com,
	vbabka@suse.cz, ziy@nvidia.com, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: mm/pageblock: improve readability of some
 pageblock handling
Message-ID: <20250827144305.pecww62n7sjz2cbr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827021121.13645-1-richard.weiyang@gmail.com>
 <68aebc03.a70a0220.3cafd4.0012.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68aebc03.a70a0220.3cafd4.0012.GAE@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: E781C80003
X-Stat-Signature: 8f9gyipikccs5eifmjbos7ybhk3jy7e9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756305787-991893
X-HE-Meta: U2FsdGVkX193ozznK7iZI06qvBaypV8FjxJaNqL4Mc0UJpb+3tPhpbRoMozh/M/3c1GAg9U937Jnc9LHiDj+ZY72cUMeqgCuheoW+BoObGYjM3JEciy19d+9c1xW27GI5cMbcEwv1KUCy1LlZCJ4opUuH943azEwW66u8mPX1GcRzE6uODXXWXtis4ib86tGFUbvX609fETZq8ghHsn00V4hNR83R/9aAzSNSPy1aPmNt0ZsqjtejEEReV9NxAQ6fNkxvO0M6EM2MbdAePPzF4h+k5FSJJVoLYffgP+zVrMD1kENoq/L1fKUQ9qEqPLeHCJp3R15uEinyEHQO5fWvwgIIi7JKdCD5NI+wu0O13zyp1RrNoOmhKqDuFIWxybS72WVFNJOjYVB0cgFudMu2CmRFxD2bzFbFbq3QstACbN5tPoI65ee5T7OoX1x5G6vGQtGn2gx/DZazD4FwNp7oA9Za+2grRPg2c+MxwX1jJ/n/g4RMnw9sq9UeWWnXqs2jr5ooGt5HmWFGZgroaKCZPH6336eg13ivL1FEAG/4lTvHLLv2bEhwQNUV/2bLF13qVrnubEoUyR9UaEKXdgMQvg8j1o4yQTd4c33ggjX0KGqnXdIy/QVqzQvJ+N5v7IONJckO87HoCu7vxzucULH6xBk845nnBFC6r62MfWY5hTqa0+QKrtieJtPK/1RnbNkumUb0QDBuR7aYevDp2+qvjcCjDEL4P+q2v53Kklc3+iaD7y4BGhjev/GNx/HgLw12nyVAhEAlLRxNE+UtahLt/wm3gr5iLXqArQ9TxOuD+Ab++va5JuRxeWTVYMMbJPXNZ3z9zl0ylapfMBYvTw9NJJlOQvn1HVnkGjHj7IUzK0OejHSsm5tMQPfi+Ds8fsLbJ15KCngi9Zt8MrF8wx2PAV6rO2rv7UJGUrdqJ2D/82AoeVkSy+blFqw1YCf0GJI2qWQ9ZhrKNBNxYmyVMY
 3tRyrASr
 SAud8Z/AIvM2SKNVj1+JsblyHUvvfPy5LkjBRdrrTdC70LSOEwFbrzmJxc7jUhUYj6yk9DVsl7Ny7XIQIaRBNHSSgubEx5W2LzciP2MmPkSEZzKXKlPC6lgVQCIYD3mW2QFgtcE3wlUXkCcGjofNbzlSv6hZodqoRNaXaFuFAVAR66qRZ+eYGw5KObz0mG1oYTJRmSYiFqSC7ZUYrfwcTJh+MLXsuNX+GlaSrt7kjM0zeP+fTO2k5tXC2jI7TrFXTyVR2m/pI/ark5ckZ/szkCrhHXvCIJam8WZdH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 01:04:19AM -0700, syzbot ci wrote:
>syzbot ci has tested the following series
>
>[v2] mm/pageblock: improve readability of some pageblock handling
>https://lore.kernel.org/all/20250827021121.13645-1-richard.weiyang@gmail.com
>* [Patch v2 1/2] mm/page_alloc: use xxx_pageblock_isolate() for better reading
>* [Patch v2 2/2] mm/pageblock-flags: remove PB_migratetype_bits/PB_migrate_end
>
>and found the following issue:
>kernel build error
>
>Full report is available here:
>https://ci.syzbot.org/series/51db4b94-ae73-4ea0-8cf3-4ea5b7715cf1
>
>***
>
>kernel build error
>
>tree:      torvalds
>URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
>base:      fab1beda7597fac1cecc01707d55eadb6bbe773c
>arch:      amd64
>compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
>config:    https://ci.syzbot.org/builds/49ee15fe-3add-4064-a3a9-1461fbba8c85/config
>
>mm/page_alloc.c:373:2: error: call to '__compiletime_assert_1636' declared with 'error' attribute: BUILD_BUG_ON failed: __MIGRATE_TYPE_END > MIGRATETYPE_MASK
>

Thanks, this is noticed by Zi Yan.

>***
>
>If these findings have caused you to resend the series or submit a
>separate fix, please add the following tag to your commit message:
>  Tested-by: syzbot@syzkaller.appspotmail.com
>
>---
>This report is generated by a bot. It may contain errors.
>syzbot ci engineers can be reached at syzkaller@googlegroups.com.

-- 
Wei Yang
Help you, Help me

