Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A30ED65C7C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 16:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6F3F6B0005; Wed, 17 Dec 2025 11:50:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F2676B0089; Wed, 17 Dec 2025 11:50:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D3B16B008A; Wed, 17 Dec 2025 11:50:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF1E6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:50:36 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1970A160BD8
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:50:36 +0000 (UTC)
X-FDA: 84229551672.30.5DC6724
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2D4E01A0018
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:50:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HTPWG1p2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765990234; a=rsa-sha256;
	cv=none;
	b=QxBriU2KqTwN2/8BaTxnR3O5LN9g91zpGF3aEY11DJ/17ApXVTGWIBcjohcZUM25sow89j
	gBMDvp8frOjnIvLjTD2UrIrikEovH3YwgR4H7qo5fsKzF2msCBbCLwyxyMlnjJUtv4rpEi
	3/0nxVhLuAZpAHuk/2mwhPo8uHt2aCM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HTPWG1p2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765990234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PAsD2vPOWvukoB2byMq+XQ93o9WOXXcOD9dnTih7p44=;
	b=2ggXnTOglEBUflCBm+WUeE5qZgiyYfv7gGoQLELTNV2iA0PJ3+CQn44KDHoe7Ao4khUpbx
	Rjwms3uR9eSXASB98imJzwDUKM04unaqLOYAi0pkIoDNbStMM8P33Jx9J2Oe5T+z67ONu1
	uSyaVNPmluqsKOjT46pku6tQg6Ii+KQ=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a0c09bb78cso6061765ad.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765990233; x=1766595033; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PAsD2vPOWvukoB2byMq+XQ93o9WOXXcOD9dnTih7p44=;
        b=HTPWG1p2hqto4gGPoyl1gZp3vCyf5xLublQve85ZBK92M0ayWg7ttfFR0ERX5SzEUU
         Daaky1ragugXol9z+YA0UAeo0eQitmt+NW3LbLRkvAcPKr91QaE4ooejpR7wFfEgDn8W
         7H7V4+9GsmK1JMYyEdjJ12lWQofYCKx74sS1U8YL/J9BeXja3PpThlaiOlEnS0cEhWQi
         q4Ezjdhuo5PeFIBt6jhlHOACRQ7n+uPuYvRnJ2deY9ylWmh9RDJU6aOD+W44CpTd5BIF
         88/1/g0lylE2VZmyRnBmgtiMOnQrpAD0mVVCIEUMAbUjU3dNye5ZImNKJ0Zuz7sC59+x
         oGkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765990233; x=1766595033;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PAsD2vPOWvukoB2byMq+XQ93o9WOXXcOD9dnTih7p44=;
        b=FWlHfgZ/GTXWeCtIib9sbSRBQgeRbJU6iqbxxU9p9Zgkdfv/0oM+shvYFReyZipqSQ
         M51TXGvuaRYXQdNTMlPKBpgLF0qFIT5uqhCPsSqWoofBDw/e0HLhtFUEODRIzSH7zWUB
         UsfH/8qBgbnYwOslhSNUUxpmmSeTlY00gMZ1fUy/BXIcWahiEjHg0uLH5bRsdUgMWyJM
         oYRncgu8QO5+1RMsXoxlrj1dRWO4SUl3Y0efPLdu0ofgKEQ9kAFGWLjX6SJiWPUt8hEB
         vYW1dlB9ehAkaJQvmuqD8dm6Xcb7u0ecg3vQTmjFjATqr9167UusGbmoyBB1EuwniNig
         jJcg==
X-Forwarded-Encrypted: i=1; AJvYcCWXv9TI10g7e2c5AlfeDqFKCM4IGQNp8qWnKERXNQVwZ3cE9JzGYoaIMlPd3jKRpEERp38kQ0EWcQ==@kvack.org
X-Gm-Message-State: AOJu0YxtdHYAPJIjX3vcr2lcQ8fe+D0zl1649ABa4mvceJBsMcjnMNFP
	ltFUmWl+uKt4iL2iG5DS9S8qOtlY+7fICw4Kj2AqtSdB4gduiThJutgF
X-Gm-Gg: AY/fxX50QD55oishrgmnseaOZb/AXvT3uAA/cczXKzcl4k3PgWqaRp2t8tffPVJ3djj
	VQCLv0dWVb7wD/VWkpxoBIYHyqdI8XdSDAkWxx8BaypimfH3Dg7Qp6CCMsFAc5NnCI3M8pxMOpf
	NqctxWLDOUiBdTMNAub9BzXLKRC3kxMVBJXLAxT/VaaR18cRwxsA67GABD2LefpoQ30UNgHXK49
	GHI5xhcwiaABWex6vw/EMjd2nSg7dQRoJ/LUFU7lJLKKLmosbYUESHAAcvYTusaERd8UdP1e0Ex
	OLEjsJB6lrUpaSxAZQC6geHxeIGjMFzCq9tFWMTHEOpv7znzzQLBMo3IgdMvcWEf5suk6hbvyC0
	MhQf3FuWeZCDvqoC1McWtqPoqrctRSXXI4bilm7+x62SnxC3rEYRntr/mkZ1DIwm3ht6/9O6pwE
	3BfABxAA==
X-Google-Smtp-Source: AGHT+IEVED3e+KdGXZXVcYIldELMqcKzBvn3EudeqgTtF1rVnKCzdaDs50jLdVQ3ZTdPF69nS2yCCg==
X-Received: by 2002:a17:902:d542:b0:2a0:b467:a7d0 with SMTP id d9443c01a7336-2a2cab16184mr316675ad.16.1765990232877;
        Wed, 17 Dec 2025 08:50:32 -0800 (PST)
Received: from dw-tp ([171.76.225.126])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29f177ff327sm172094595ad.101.2025.12.17.08.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 08:50:32 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, Kevin Brodsky <kevin.brodsky@arm.com>
Subject: Re: [PATCH] powerpc/mm: export symbols for lazy_mmu_mode KUnit tests
In-Reply-To: <20251217163812.2633648-1-kevin.brodsky@arm.com>
Date: Wed, 17 Dec 2025 22:15:16 +0530
Message-ID: <878qf1kqg3.ritesh.list@gmail.com>
References: <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org> <20251217163812.2633648-1-kevin.brodsky@arm.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2D4E01A0018
X-Stat-Signature: ffuyz6y9jhh8rg34d9ysgf7idxzdhe3o
X-Rspam-User: 
X-HE-Tag: 1765990233-691579
X-HE-Meta: U2FsdGVkX19drM2oV+ueLDWqa2kqcCD1IRjSF1dgedW7rI9TIi0hkTuEwuBgfdIKk3MahFzYXg4JcjAEcirbsdEUDSoghcMyUaVzv6omOTHtKw4OP6moH3RkSP3+BaCZUsY/YTqH5QagqJsAiUtsqIQ4pwMKJCSog0CtOBYnPhdt0UgMCVtqDRGTd68fUPgLmmP8B+Iqfv2mEdYnaNW2PLUMuvQ6431KFkWLgYw2VAtuT3cA2EwYpA3zHpVMiFH94V5Hwo5rsRoynkiG7++iaitmct1llVz8qArzq3UyiE/uUaFvO1LwFmciixVQnhRb4nu5Ff+1nlvZs6Ft2iwmAKlzgm7gqwtR+n/HUHjznt2jbiAdBJKBphLt3xxe3NdauxdeBGqB1C3FzKtZX00CakwlpKTyHf2ageOA7VPpnKZwFtPfeEhI5DxwWW6S/wD4rv8c6N/5ZIYELjZTVNSbqhPMMZoIpPwsPaKNXGNRsYWshH7/xoC3FKnbeSFrbsZRASgs8pjlWJ4uS+IvugiyHG4FJgPxhWBG5quPJkjb7MVeCvnw6sDugW5E1S2wiM+cSoIIjZVK77LLfqYlPLxf4EKxhOT15CA2LeTVarDyi8DLVMtgO54LW0mXY87pn7qeOzlA1nZc8g+edlS3WXr4s6aNhGei65EzdL4BUtT44teADQVlNTbV83I1jFRx/8B9Q6V7uYD6b8DNHUGVSVqM7Quhp4fwxjH8OAxlBtQ7MXS/bpaYcpIadawTuXmLi289BJ2W1O6/H4T/8npRZyM/AyoiiJTtZ8I1Y7twp1/HkczF8au8WChFlvQajONzk2+GB/OBxM2caTFzx5iHvn+TjMvzScjrKPHHsv5/1dy573g1Bq6NTs/dZl2CGn1U7BfiTmFx8gVTzLuDiGozPu2PicBng/UaWIw6gGjR3pJS9jB0Qs3dGYXZ/b/+Om282dx+3IJ4gSiDthIjlusVcpm
 ptTS01QF
 vTgn9SMMxXJxmmNPlz6o/B38Grby/0A4xyn52sDKrwQeCkWywRTgjlZKicInfnasaSrvmhyKaQiw/Bn2OInNXjUPBMcw8ro8K3s9rIIW1wzYjpYtXeQw3xzmL1Iew8sSMT4dZTKuqJoLPw5g4YxgezFTNm6QgYGApRh3Ljr3g8sBhG06TvfN9kP2IofSzGKkRQSDFk1jmAuTpcetvFReH4ZnrVNPmzd89Zd1BOXPKh2+9RtfdKGcgKa7M+Yz1WR5MlPtllKW87CbzycPZS0N/ITF2OwulfCI7t/Et3qQuwm04MjMnHo0l1Hrc+qjOYeUZ/yHwjf78SOvm7PFS5EwyW2/msqx4b/9Am5GTrD7TuL1FbdFxVFM4MBA8hoAUY2nzEyhjhMKXKwP83W1SdVwP3Qh7iVjPbyjsLM02hk4Qe4RfGyml9Ss+UjGQ4Pr98AddMJDsg6ViDkbvvLyCFgILO1wqGAmOT1Sy3QEU5bjEdsEt7913VvJ3unzOpSXoCJW91M57/yE2lDUzIo3xGH8qmtF63YQXDyCT2E8NgOLmtngKXWXazKNfn0SvfhuZJEJuDlRpT8VtPSQa4reS7TMeUqYMtyjwGMa/0zMZ9xkvA58y6MMqF4D7W6/yjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin Brodsky <kevin.brodsky@arm.com> writes:

> Upcoming KUnit tests will call lazy_mmu_mode_{enable,disable}.
> These tests may be built as a module, and because of inlining this
> means that symbols referenced by arch_{enter,leave}_lazy_mmu_mode
> need to be exported.
>
> Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
> Suggested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---


Hi Kevin, 

I guess, this can give following errors:

../arch/powerpc/mm/book3s64/hash_tlb.c:33:1: error: data definition has no type or storage class [-Werror]
   33 | EXPORT_SYMBOL_IF_KUNIT(ppc64_tlb_batch); /* For lazy_mmu_mode KUnit tests */
      | ^~~~~~~~~~~~~~~~~~~~~~
../arch/powerpc/mm/book3s64/hash_tlb.c:33:1: error: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL_IF_KUNIT’ [-Werror=implicit-int]
../arch/powerpc/mm/book3s64/hash_tlb.c:33:1: error: parameter names (without types) in function declaration [-Werror]
../arch/powerpc/mm/book3s64/hash_tlb.c:158:1: error: data definition has no type or storage class [-Werror]
  158 | EXPORT_SYMBOL_IF_KUNIT(__flush_tlb_pending); /* For lazy_mmu_mode KUnit tests */
      | ^~~~~~~~~~~~~~~~~~~~~~
../arch/powerpc/mm/book3s64/hash_tlb.c:158:1: error: type defaults to ‘int’ in declaration of ‘EXPORT_SYMBOL_IF_KUNIT’ [-Werror=implicit-int]
../arch/powerpc/mm/book3s64/hash_tlb.c:158:1: error: parameter names (without types) in function declaration [-Werror]
  AR      init/built-in.a
cc1: all warnings being treated as errors
make[6]: *** [../scripts/Makefile.build:287: arch/powerpc/mm/book3s64/hash_tlb.o] Error 1
make[5]: *** [../scripts/Makefile.build:556: arch/powerpc/mm/book3s64] Error 2


IMO, we will need the following header in hash_tlb.c

+#include <kunit/visibility.h>

-ritesh

>
> Andrew, please add this patch just before the last patch in the series
> ("mm: Add basic tests for lazy_mmu"). Thanks!
> ---
>  arch/powerpc/mm/book3s64/hash_tlb.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/powerpc/mm/book3s64/hash_tlb.c b/arch/powerpc/mm/book3s64/hash_tlb.c
> index fbdeb8981ae7..9e622519a423 100644
> --- a/arch/powerpc/mm/book3s64/hash_tlb.c
> +++ b/arch/powerpc/mm/book3s64/hash_tlb.c
> @@ -30,6 +30,7 @@
>  #include <trace/events/thp.h>
>  
>  DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
> +EXPORT_SYMBOL_IF_KUNIT(ppc64_tlb_batch); /* For lazy_mmu_mode KUnit tests */
>  
>  /*
>   * A linux PTE was changed and the corresponding hash table entry
> @@ -154,6 +155,7 @@ void __flush_tlb_pending(struct ppc64_tlb_batch *batch)
>  		flush_hash_range(i, local);
>  	batch->index = 0;
>  }
> +EXPORT_SYMBOL_IF_KUNIT(__flush_tlb_pending); /* For lazy_mmu_mode KUnit tests */
>  
>  void hash__tlb_flush(struct mmu_gather *tlb)
>  {
>
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
> -- 
> 2.51.2

