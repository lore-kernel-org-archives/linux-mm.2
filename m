Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C70F7C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB726B00AD; Fri, 17 Jul 2026 12:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4506B00AF; Fri, 17 Jul 2026 12:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901946B00BB; Fri, 17 Jul 2026 12:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 502366B00AD
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:29:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71780160179
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:03:36 +0000 (UTC)
X-FDA: 84998436432.04.9308574
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8DFF9C001A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:03:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jA2jDJdD;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784297014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=t+JK6YXp0UMipFPe2YB9TujwLOUTMqDZAmncSyxaQVE=;
	b=o7A0ihqvUmA0TCkMZjaG5Tbpg91RvfBOHE6X3eILYjgXu8ICgX4xYAE3S4aDRuPO9pnvaj
	dYmfrF8YRr1OTT0Mz6g8fnqVZ+Ro7nK4XMzT9w86h3/ANBf0J0z2xVUsnxxwN34dZofjBb
	WuZqA5KG5mjkBs0T76NUUQ2vYES6L1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784297014;
	b=wKAAXnQCCbcobPMZUQPl0LVdo+bEjA1D8hTEDJh2KHEZSw1JIxwU2K2pXoigy+Ig5vvhBg
	lMZ/PHdf7sRn8DDvopE+sMOPg4DbELwSTuBO/S1PniFdbJP9AoDkliMBMO0aAJ1WWzoiiO
	TGERkVLc1mLg/nL/qMDixd3idxiaoMY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jA2jDJdD;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=t+JK6YXp0UMipFPe2YB9TujwLOUTMqDZAmncSyxaQVE=; b=jA2jDJdDP5c5Jo5AgHdG3VfDFs
	JoaMhrqz/zugeJQqgtQHsKJuZyGzrfbRTrrWuXwt9BGD6/Nm+E3o+9evOkadB4r/Z+kQUZHDZl9nr
	d6DViDDIJKSQ3lJw+q3EyBWcQxRzMfb/bVvyZMUM1Dv0J6lBmoAJQB2TA3lVSlqdanwygx0U2EXTE
	/OoBoF2UwcdlJLfN9bE2Dlfja0WQBW1ph2J+DeGVYj7D9rlFV+Dvox6VLfLjiVuLk3IG+qHUcXaLD
	i9ZFfwhLwSK1Erqj6dSIaXs3oK6cpdwRx8SPVCJ+l7hclZFBAqsU0u5qDMrH4vWKMWDj9nR3jCoqr
	tPRkwCcA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wkj9s-004eBv-0y;
	Fri, 17 Jul 2026 14:03:20 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH RFC 0/3] efi: mm/memory-failure: keep hardware-poisoned
 pages out of the next kexec
Date: Fri, 17 Jul 2026 07:03:02 -0700
Message-Id: <20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABY2WmoC/6tWKk4tykwtVrJSqFYqSi3LLM7Mz1OyUjDUUVBKz
 kjMS0/VzUxRslJQMjIwMjMwMzLSzSgvyM8szs/Tzc7I101LtkxJMkpMSbRISlTSUVAqKEpNy6w
 AGxetFOTmrBRbWwsAIf78fmMAAAA=
X-Change-ID: 20260622-hwpoison-kho-fc9db2ada8ba
To: kas@kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, rneu@meta.com, riel@surriel.com, caggio@meta.com, 
 anilagrawal@meta.com, rmikey@meta.com, linux-mm@kvack.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=3334; i=leitao@debian.org;
 h=from:subject:message-id; bh=XSYaytETWUdAdf6C/jUyr/nUG+SgDUBzJpLAb/bKjnk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqWjYj/ZImjUuBxzZ5Tbo8rqgjgA+6KHsOLgMCm
 fhVmBp2eHmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCalo2IwAKCRA1o5Of/Hh3
 bYa2D/9KnqtaoYgK3CwxF9r5fp/EPaSxnA0CteU+zY96Dx9AMq5/y28TItCWs+yHYR+YfprELfF
 tQzVtWly31TwLgYYOq2keOtVbh1aLShGMXsJQkFXEgcjXuh5wJffeQqmfN710UKbXu4afI8lnyX
 BPTZoNQCJTWKTdFetEmrTnYfHS9IfG3Q0m76rYBtupdoo6zXT87c/UeBhE5SK2ARbjO1WQy8jmB
 bT13Zr+VFwptXT40idq6grx5imSPxAwKfbcDbttE5jH2eaFN0EFJPG+bNf75GPIgqPUbi5+TZwR
 bxmB0WPfVavd6A/8cU4MSdSCDrw4bipNazDI9iku3pSaGcPukXQSbXrU8qehSkf2a9a4HEMLYcG
 sQtHt1xG/4gqq+gQ/zw7mR0M9wBJHZe+2dV6pwnaq6gB27dv2BXlVaMuLe7XC38yxSvQhGG9Mbd
 Yxu40Zyq4rs3mzsMdlhUXQmcRaVpgzO+nbpTPo09XJ6AwtwiwYA7j3/R+cS05GG2alwtpGrC0RH
 gV5KpvMBkzCBvUVKiSAqPfRSKXfMV0oGk86KI8o6A2uDBCHffQPV8WA/dh/lrDtIxwVwZOd9vZH
 UoMKWESkiSzDxhCZc4cab+d0q0slGkFTo+K3x134d8gHbYFncet5PQinMT4P+k5k6eG5b7FC4jb
 Eu1AlYRmThGrc7A==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8DFF9C001A
X-Stat-Signature: xxbab5w1ze3z8xo9i3zubxxebkrdfgjg
X-HE-Tag: 1784297014-258272
X-HE-Meta: U2FsdGVkX18TGZBcxVnu9KuYm9bxiz+JTabKKxwGjnwIlSzQh3rD0T8EetyUvzpp/Tx1eFzHu1ExOeYLlZQiUs5/zH1H105mtQxXtpDrQ/TK/7qxYiEPSGHv66aL2EEJN61MZ/ZiBUKFErv7MuoQEvYMwtJVm4VXpRhKZ3E+JwEhn9c+5RRoZ8hvpRoi2y5xs5dwDUUUT+5IsZcsXPEcd7RQek64cW1tWeougTloPikimXHAfnhHX44yvo9AxefDO4sbES/66DIhGNJTb3NJH3eRw9MMjrMN2M1qztk8pemkVw9yg6PvHsodFeTQGQaVkjwejtB/GCo0xEIbsPBxbavUhIhG/d92OgX6czLgAIY9B73SuHGBYlzjCANfepHTEIY7lzCGQ7zQ3HbDqzNkKqSQBG57+Vmo471c/SIeM+KYDleZjimP09u/5pCQmB4UHVHr7zZL2kR2x58g4AIh9TP8/F2x5IcB7STN8k0KNnNvngjT/BYN23nE1rAzfjn8Rzq96sYhc9pwjit6hjN3WT4g+lf2OILghcqidwJFhlzSK7WLPkB/kA/rEY5R+RZCMZJp3055T0AACXvbvGuJeeKwOSiZA8dR7DWaCPIfur6Wqm2rWA1bsKyt4YKFKHtIrV0zdiiwuEP3WlNV018FUhf7m3gIEeOmGNlZK1bJZbjWqLfV2+RzLjzUJVAnK1VsLSnFDuT4PfDZOEg2fz5icRrQHAZAas3hcdbECE4nDkVscb3qOiET9ecmbQgSCH2VwLfU6upqih+usk6nDMPN3cNE9Go/GQ0sbj4KCA9Lhs8Vc98PGZ37kDwpxdxnzaGE7qMLBSzHNcIxSXg6Gy5LyGn2qda2RT+zPvvxCYmUzEwGKNAUJmG3R1OnP1pW1sMTFnxjI8ehmyBioFHALd+7+odu5oidXLAVTZzv3Ar354jwx8sZ6u7qGREU/WpMIwxmIedCnqeXaoAg8Ly46Ue
 y44eJE5O
 o5q21Cvh71XD8YKpakES38rSDZ0R4LgTBGef67YEFFeKCfg208WSX0YP1Y55muI6lLUqdhpzD9C/MyaZOPITPWzzEIgWJH+26lP8yFBEp5XoutB1T3mzBKHqJPJwfSyup/5C9U/MOijTCn9Kto4MasLUfKzjvkucF6djCTIcCtJB7livU3emtiQObqESjB9doPgzkXOjcc36nxxD0g0QV7UGzG+9Pzp7XIUkPeE5LqhQUE1MoB3A2FB+MQ5gieiUrnePoKhdyPq1cWgZdSn3hyEj2G6kKzbBVjvFtVfTP+Xw+8qUcKWMH5BqE7PrDsWibIqBYWKrNFZ1J9/BZ18C2U+Tx2J6VZB/pGBb9Dm9oP5nU24oaQCcVxe8OmXp84frinOug2033Ve0bgFgLiemrA80jYlsDR26EAvKS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem:
========

When a page is hard-offlined due to an uncorrectable memory error (multi
bit ECC), memory_failure() sets PG_hwpoison, unmaps it, removes it from
the buddy allocator. This information is not carried to the next kernel
that is kexeced. The new kernel kexecs and trip over that bad memory
bank _again_.

Why now:
========

Several industry trends make this increasingly important:

    1) DRAM is getting more expensive
    2) soldered / on-package memory (LPDDR, HBM) is becoming more common, so a
       failing part can no longer simply be swapped;
    3) memory is kept in service far longer (at Meta, DRAM lifetime is being
       drastically extended).
    4) It is more and more common to kexec instead of full reboot
    5) Increase of memory per system with CXL

Proposed Solution:
==================

Carry the poisoned frames to the next kernel in a new EFI configuration
table, LINUX_EFI_POISONED_MEMORY, modeled on the existing
LINUX_EFI_MEMRESERVE table.

EFI configuration tables already survive kexec: firmware hands the EFI
system table to every kernel in the chain, so a table installed once is
seen by all successors without a new handover channel.

The mechanism is architecture independent, so x86 and arm64 use the same
code.

The EFI stub installs an empty table while EFI boot service is up. A
configuration table can only be created there; the running kernel can only
append to it.

Each hard-offlined frame is appended; an unpoison "removes" its entry
so a frame that is good again is not carried forward.

The next kernel walks the inherited table early in
efi_config_parse_tables(), before memblock and the buddy allocator are
up, and memblock_reserve()s every recorded frame. The bad RAM is never
handed out.

The series is three patches:

    1) add the LINUX_EFI_POISONED_MEMORY table and install it from the stub
    2) record poisoned frames into the table from the memory_failure() path
    3) reserve the inherited frames before the allocator comes up

This was initially discussed at
https://lore.kernel.org/all/ajut_LDQGYCShApx@gmail.com/

A special thanks to Kiryl Shutsemau, for feedbacks and suggestions.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Breno Leitao (3):
      efi: add the LINUX_EFI_POISONED_MEMORY configuration table
      efi: record hardware-poisoned frames into the poisoned-memory table
      efi: reserve inherited poisoned frames before the allocator comes up

 drivers/firmware/efi/Kconfig                   |  10 ++
 drivers/firmware/efi/Makefile                  |   1 +
 drivers/firmware/efi/efi.c                     |   5 +
 drivers/firmware/efi/libstub/efi-stub-helper.c |  30 +++++
 drivers/firmware/efi/libstub/efi-stub.c        |   1 +
 drivers/firmware/efi/libstub/efistub.h         |   6 +
 drivers/firmware/efi/libstub/x86-stub.c        |   2 +
 drivers/firmware/efi/poison.c                  | 180 +++++++++++++++++++++++++
 include/linux/efi.h                            |  31 +++++
 mm/memory-failure.c                            |   6 +-
 10 files changed, 271 insertions(+), 1 deletion(-)
---
base-commit: b8809969e1d7a591e0f49dd464a5d04b3cf02ab1
change-id: 20260622-hwpoison-kho-fc9db2ada8ba

Best regards,
--  
Breno Leitao <leitao@debian.org>


