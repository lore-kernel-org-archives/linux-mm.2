Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8609CCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 15:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DACA8E0090; Thu,  9 Oct 2025 11:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C948E0008; Thu,  9 Oct 2025 11:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A6A8E0090; Thu,  9 Oct 2025 11:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9B478E0008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 11:54:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B87A01A011C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:54:18 +0000 (UTC)
X-FDA: 83979022596.07.CE776EF
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id C3C1E140007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:54:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N1mX6cqv;
	spf=pass (imf09.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760025256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Px/XhEZW45988TSsx9E9crCKXRf5VJBRglVwYyG7AFY=;
	b=Yfxf8dYxsP67DfUVbHuFY5Q3NhyRt9aGUyYQiK4xtK1pHkLMtNnT+6qtYnhMWM9lUTAmWf
	49ZIxRawa1RmxKc85uU97Gc9KgaLXRaJuLSTkm5ZykI+G7elVsv8Mp9tmuslxluJaf9Qhh
	z4lyjF9p3fU3T4bB1SDL9n07c6APa9M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N1mX6cqv;
	spf=pass (imf09.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760025256; a=rsa-sha256;
	cv=none;
	b=LvXdIDSJbY36cy1rVCmlkK1P1CBo6Fn30vNIrJzwKQhOlRrT6DHoExiP/2iaWrn75VcgSs
	M2wspWTbpEZ5IJ/4nMA2OM4RJn42D7sqGGCfF7M0dXJEklShZXiZk/KN7tp49mAT7OcEIQ
	buPB3TZB/sK2S7kpDR3gVxlitma3HjU=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-375eff817a3so11882871fa.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 08:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760025255; x=1760630055; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Px/XhEZW45988TSsx9E9crCKXRf5VJBRglVwYyG7AFY=;
        b=N1mX6cqve2k8zctdzI4v6CAvL+YaB7jyaN2Z7oO7bNkV537bh5K3XwlOecIq4PamMF
         Fa25iAvR31rMKiwWk9hjdDSc6uqhiYiTjkn+kEO6wg4KIBLjyZTFqz9lI9mJAE5N5DvB
         6t1GnTLJvM2Aib/7Tcxpx8NRKasPsuJyo3rvV4VHCEXQL7V5/S7WIvL1d1f9aP59MFMB
         DP5/tTpay3nafacL61Kn6bd0OLhDZLHjkNJPmLwN7M3SGwf82m6QLrUbiN4jviE1HhTI
         ZnjptlBJVN8qhCX9f127KQkho2mlnSngGj4YtHMG8a46EPqEt5Nzc3w1m2n7safM76ts
         Tzzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760025255; x=1760630055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Px/XhEZW45988TSsx9E9crCKXRf5VJBRglVwYyG7AFY=;
        b=EJb22FQaWOyJKuIwumEqp4Ip8nFMAtvJyw+KTfRG0WAm6E0zmJreSa0oYDZXxbRqBE
         iCREPMBMocyzPOh/JiAIYQuPpXwPIgOZZpx9dpqfeXG/fWGJooSIw7PMmefky16SObYN
         9UmkBF6AMwsZDXkWuWjkWdiRmFnusC+KkEbUuzKrqouGGImRdjwTPG9tVzYcL4MvkX/L
         uMp8y9WLrLPobHAruM4mrr+wLU53YMgIZeKIiLICRbea5z/jIjbEjxn6oQYVMK2ajvxu
         uRdCFWvKrMvlOCqok5qg6nv0TXcVjzNdOhF+ChUmUdSFHCo3w0Eih8jlvyoEQTzFdV7l
         wIJw==
X-Forwarded-Encrypted: i=1; AJvYcCWKOVrbOYwg0UEXxadW9zkI0j+MhvIePO+2U4GFxD3w5DTNhFmyvFwsYLMJ+4NsxfcH/mqKxLOnoQ==@kvack.org
X-Gm-Message-State: AOJu0Yzfm1a9Ftfe4c1tB8YOQjDQHpDJ65hHQQTns3T81Gbf1rldYCn1
	wFWXIFoR0pE1FC5mcpXhKQcK/tYxTYiDDnkXXvAMaR0kA7O13zJ0HtL+
X-Gm-Gg: ASbGnct5NS9YfnoUVkTm7p5en8ac42Mo+HYzhyQN4w8p1vE0VIQ4UPs7CEwxfItaXDc
	2WqR9npC9aFSnyTw+/Dh98NwObBvk0WMVPbdgUXl5rApBzk8fVyzhOYoIMeQ5e1uh19Tv7yEZqa
	+6O50WQhANr5SbED38h89D9KJNxFqaNZumqH79qDCAUk4SsMiOAXswehFaX60ZVK6GomILstnYJ
	KBbmVv5KiNpVTNSDqRCKlHNPAtAZYIod/NKoG1Cq7OL1PgytCt6MnOVOPrTPKxhH8Ew25I33wFn
	9IwtNxHXqrAjGV66UHH9d6KU8WltYwci3i25HUt0iGorW0+oJ6wkOAQ4I4A04Or017zxTpxnC15
	4LaLspyvvWNvc3hAWZrv7WRX4yla8EunqZJD7sGCpTse5tPhlMwj8ds/yacB8bYf0TlnN0KViPp
	hS3jK3iPDc
X-Google-Smtp-Source: AGHT+IHO/2jNu7B57uhcC5zlDJ+BqbuVqtg+u9NOxlnpU81ZaP1WebzhTXnQH2tcRcUqD/JALd/SOw==
X-Received: by 2002:a2e:9a12:0:b0:336:7c7c:5ba5 with SMTP id 38308e7fff4ca-37609e10855mr24041711fa.23.1760025254597;
        Thu, 09 Oct 2025 08:54:14 -0700 (PDT)
Received: from fedora (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.googlemail.com with ESMTPSA id 38308e7fff4ca-375f3bcd2a8sm29499831fa.55.2025.10.09.08.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 08:54:13 -0700 (PDT)
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To: andreyknvl@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	bhe@redhat.com
Cc: christophe.leroy@csgroup.eu,
	ritesh.list@gmail.com,
	snovitoll@gmail.com,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] kasan: cleanups for kasan_enabled() checks
Date: Thu,  9 Oct 2025 20:54:01 +0500
Message-ID: <20251009155403.1379150-1-snovitoll@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a9ghy6jbd5hr6cdswshy87yqye9fsnhm
X-Rspamd-Queue-Id: C3C1E140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760025256-251347
X-HE-Meta: U2FsdGVkX193dzrwJB5ZZ7wU+ESfAokbAlk7GUpXQcsHWEeKS6gwHKCPYfvY1y4r7pffU504vFAaX9ofYxH759h/xUdlnw+jl10d1X7VDG5YJj6FIUK+MqdjJOzbYmKHZmlnfozTAvjm+voT0cFRFPkSBCht0X8REY5+iLBZuzQsxG0O/A37OhNwjMndEeB/GjOBenq5nU9yLiXuT0/e9IWKFNG/VgYPmvywT38dzfZC+t/+3q4W9TuQ337VcO3pzbL0DKPagAJptVZZjF4cLCl4sxf87JVQJPrEQEBIpMyq+pr2A1x3v6pFm4IbmhnGlsCfQTpT9ctgZXwVdXc6kWA1INcvWW4CmJRnqRxGm+GEnQJpkZadxxcAMGFITtU+KQz6NC0SFCHNGmsNKW8n4wfUElHjnKeK/W0lUvsdvKQVgqgjNPoBv7m3d352oBfzhZ36fQq1sQDziibEg9LGS5u8kTfqZkCBAMCzyWXb5fJdRlfYgwYEnGKiUZSt7GLEEglh7ofUvj22MsvTBARjDhUDrt0G9KoFJAODX45OFeHnUHD8ZKT8ZrHzaw/B9lSBrpkHpBaoCdYfdC/W+wBXffF0rK6eEUdWfPM51WmJkW6iCA55sPDxufFi4ujmWrQi8KR+vwstvrMCDRs8L4kXuCrIfWQrmFbjccr/3aTgT9W97HjWcaUi6VykvvNJ0JcQaV6btmg82EFQ0ckcY6UzSqwxJrchUGSMVzyN/4hG2ba8nuJS8N81YZ70KOcyhJOpBsrowl4/bdVDgNzUpK2LGJakKE9e+K+k/PY9QMW77qcDm4IhDyRBUce0HPkf1sMTjnWFmNkCFnlIpv0qYVLP3y+5DmxFe/k4BeTqjd9+hxuojognH7s3jVby3IkQQg/X+jyTVnds/gkB4HQVbc3SkKGkv4iYlV3io7NPaEibYOfpQnmIanjCVaUup06yYcaTWrvmyGr6TYzO20YLjag
 MLeqmY1E
 pqLeETkQSp0C0pB5KXm2rNatQkznC1CdBpkDh1O8PXsv7Cw0PAmIVkxRg3IaxgaQiDVQDgWe3Qpe3uxeNT1hwMpylMnK6LYgsjLjQe7H0plZYUx+0ZpM7y9kq8xOBxJJzLANfeasdYGcu8DK9VxPCmN4G0uqGruFphWpSTPbd2IvikpbRNEhAd7LcWBeZN9esBCbTHe0eRulnkMti0S5EM8E3QPIxgQucEmhLKIWb7PhBNyiF/5Z3BdQbPBAmKRSwA+fbE2/U85X0iefZHLm5vGbZNH9o1tj0KinlbVZTBkmc+w/sYU3p/G0M+6GC6OZ8QVGYDHsnBDORMkTiYE0diVAv6ECEUy1ObS7+8MWw9H9pbqGahHkIUllNwwqNwbtjvcNmtbn3acCDqj5OhcfBGoqx75O4aV037N3T8H7RxALmZKEJ+i+fLRIC9Q7gnWFYcq4y5VPgYklhP3D/rPd6HpgOcFda0FT2KfVRH2vubQuaMHY1nvsWcXLR+4esYmxNoGejY1UL10W2p/80INKYE8u+Bk4XqiH9tLpSbhf57AGrGecgxrS1Ob31ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series is the continuation of [1] the previous discussion
related to the KASAN internal refactoring.

Here we remove kasan_enabled() checks which are duplicated by higher callers.
These checks deduplication are also related to the separate patch series [2].

[1] https://lore.kernel.org/all/CA+fCnZce3AR+pUesbDkKMtMJ+iR8eDrcjFTbVpAcwjBoZ=gJnQ@mail.gmail.com/
[2] https://lore.kernel.org/all/aNTfPjS2buXMI46D@MiWiFi-R3L-srv/

* Altered functions:

check_page_allocation
	Delete the check because callers have it already in __wrappers in
	include/linux/kasan.h:
		__kasan_kfree_large
		__kasan_mempool_poison_pages
		__kasan_mempool_poison_object

kasan_populate_vmalloc, kasan_release_vmalloc
	Add __wrappers in include/linux/kasan.h.
	They are called externally in mm/vmalloc.c.

__kasan_unpoison_vmalloc, __kasan_poison_vmalloc
	Delete checks because there're already kasan_enabled() checks
	in respective __wrappers in include/linux/kasan.h.

release_free_meta -- Delete the check because the higher caller path
	has it already. See the stack trace:

	__kasan_slab_free -- has the check already
	__kasan_mempool_poison_object -- has the check already
		poison_slab_object
			kasan_save_free_info
				release_free_meta
					kasan_enabled() -- Delete here

* Other mm/kasan/* functions with kasan_enabled()
	where callers are defined in internal mm/kasan/kasan.h:

mm/kasan/generic.c:
	kasan_check_range
		check_region_inline
	kasan_byte_accessible

mm/kasan/shadow.c:
	kasan_poison
	kasan_poison_last_granule

mm/kasan/kasan_test_c.c:
	kasan_suite_init

== Tests:

* ARCH=um defconfig (-e KASAN, selects ARCH_DEFER_KASAN)
	Compiled and run ./linux with no issue

* ARCH=powerpc ppc64le_defconfig (-e KASAN, selects ARCH_DEFER_KASAN)
	Compiled and run qemu-system-ppc64 with no issue

* ARCH=arm64 defconfig (-e KASAN_GENERIC) and KUnit tests:

[    4.065375] # kasan: pass:61 fail:1 skip:14 total:76
[    4.065529] # Totals: pass:61 fail:1 skip:14 total:76
[    4.065682] not ok 1 kasan

1 test is failing:

[    3.772739]     # kasan_strings: EXPECTATION FAILED at mm/kasan/kasan_test_c.c:1700
[    3.772739]     KASAN failure expected in "strscpy(ptr, src + KASAN_GRANULE_SIZE, KASAN_GRANULE_SIZE)", but none occurred

which is also reproducable in the main tree.

Sabyrzhan Tasbolatov (2):
  kasan: remove __kasan_save_free_info wrapper
  kasan: cleanup of kasan_enabled() checks

 include/linux/kasan.h | 20 ++++++++++++++++++--
 mm/kasan/common.c     |  3 ---
 mm/kasan/generic.c    |  5 +----
 mm/kasan/kasan.h      |  7 +------
 mm/kasan/shadow.c     | 20 ++++----------------
 mm/kasan/tags.c       |  2 +-
 6 files changed, 25 insertions(+), 32 deletions(-)

-- 
2.34.1


