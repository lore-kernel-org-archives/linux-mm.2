Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87F7ACA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFCCE8E0006; Wed,  3 Sep 2025 14:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD828E0001; Wed,  3 Sep 2025 14:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2BE8E0006; Wed,  3 Sep 2025 14:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BAAEE8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:59:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 549931A0837
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:37 +0000 (UTC)
X-FDA: 83848852794.22.FF60028
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 952BC18000D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xkhg45AZ;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756925975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qZy30c40uMQ+C5mAmU5IprjDTVrN2KgzxusGEfWx0IE=;
	b=sz7UyrbkMzqMImQKODt1QTIY4ZldYmplP3P1n3sjstqNKaa33tDjFS4VhXtPs7GwuzHbiP
	2go/ihmg4EBSPHOT/nmx4rSZtCYLvkE2Vr9FtKzZhZz265aT+wmnBxCf4P/b6ieY3hC2KT
	lN/UJ7+T0bruY+2X/vqWeqXlJvLDbUk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xkhg45AZ;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756925975; a=rsa-sha256;
	cv=none;
	b=Neh7dTsi5BPlYQnC3bFLoD1+I26hkGA6fU0xrdg+LIiZ4+M1mEIbbIlQoo7Kl0oNT1h23v
	+bZGcfsaRZ9gwn7y11fGSYy//xcmkss6rWAhHAn5/ZkkAGQh8pG4rnTlISuHAEI+2U8gZd
	NHRnJz25gnzpDFXip+WaY0UDCQt9sUI=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24456ce0b96so2498375ad.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 11:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756925974; x=1757530774; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qZy30c40uMQ+C5mAmU5IprjDTVrN2KgzxusGEfWx0IE=;
        b=Xkhg45AZOxpLhXQ+Apw42v6MJkqBEuUvO+qSW1I84QOhgTwSd1mI4tNJeO+fiQ41PI
         pmURlUQSb4INdaq+GPbSZYgCbwcvfuOTdvDX20lPxuijgPeZkWGpp8m7elnisk3nApGR
         0QIO0o7OKQSgahKbr+46J9Fo+IBTJ6r50ZQrTRGFad1TXgIyHyKABUCucYtYCQzpgBlb
         JsOhwaKHxrTUWhQEkyGaf6ktqMtc8Wow4ioWvfjGeH5WwAy/4UmgcWtW1NbOhJekHqH8
         onR8gHqNedr4nOYGSTdkIroz5+5NXZKm91a8Ju9hPKmMjg4I2/9soWPFs/LtsQHGwECB
         jGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756925974; x=1757530774;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qZy30c40uMQ+C5mAmU5IprjDTVrN2KgzxusGEfWx0IE=;
        b=n1YDBgxlwm/jGVQ6PdLwMP3wCTp+yY9AE857l3gVtJT1d6zDyqEEdJRHIuQY+ryDQg
         zWHknUzdlxeeu1QhwX6WsF+dvt2RAiMPmhWyqaPkHpMdcd50TWqxgRW7sZ/P0O+aNbWU
         xk56fSDSjcc0UDh68OLf/XwZBae1bO8B3K3XzcFHL7e5xrJ/ye+OaEyzdRJxaqs4T5pe
         Y8ze009+2dVrXbnflaS9AACUYPpxLRIgl/ge9xCRPJqWG7gcHkcIICGvuP/fnNWleWc6
         fhtCzZJSY27uuqQh923ypUZsA3HEHoKfOSx6B3temZAbr58DGT22VQ1GO+Th1X4B7R/a
         fhWw==
X-Gm-Message-State: AOJu0YyGm4nuSMXgB2OjshpmQF5s3LElSB91X9N91VnvcwYlrEQg8WJ4
	lUIMZIfBxOfN1lORDPnO5JIuCKVLBllKM+2bx2TAsy5apGFX0r8IluStUF8xMALE
X-Gm-Gg: ASbGncs3sJLXz0paY8xh2B0DnHgv4zE+sOMtV79Dkd3w2rMHJ9PVyp4xI+vcO1ETO5h
	PC2PQsvif0PYwfX+t01fOUtGsgixPG7JKKiWqQLHL35tvg0pdEcLX4G0W+9uN/wAW3tIech4C9z
	/l31p+Yp4zBORqHvaCZ0YN9zZEV6uTxoKfWljTK1Ts/6O7rOuBG+Fv59ogN2fBpYkVY/lW8G6W5
	VZQzGpBDc3k6jkncKXB4DNFtUT4iDmu4QGGSUBDnmOYeYr7GHtPDcgMer8rj0rB6CtW1yNLHnWh
	N3HnzEmU5W+g4i0pE4ivqEub0KoDJ2ox3gQPWwVZkxvBP2Q2WS12uf8Q+3NQNUIx3tAU/3GOfIK
	/idNAyE8GD9gWf5A3OLqpiOJJN5vh848ioQqoyRLoalpZ4YJLkxxh4Q==
X-Google-Smtp-Source: AGHT+IGc1hOCFlrmhtuYXy2RF4eOcL1ED3xkJpQYquvPOenW1RGNO8PJflQF3KtC2IpnrJ0auNPnsg==
X-Received: by 2002:a17:902:f642:b0:234:986c:66cf with SMTP id d9443c01a7336-24944ac387bmr203183595ad.16.1756925973872;
        Wed, 03 Sep 2025 11:59:33 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-249065ab343sm169403475ad.126.2025.09.03.11.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 11:59:33 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org,
	virtualization@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Justin Sanders <justin@coraid.com>,
	Jens Axboe <axboe@kernel.dk>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v3 0/7] Cleanup free_pages() misuse
Date: Wed,  3 Sep 2025 11:59:14 -0700
Message-ID: <20250903185921.1785167-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 952BC18000D
X-Stat-Signature: ps486gz6dahyp4td1cu9xi4kic7ogpew
X-Rspam-User: 
X-HE-Tag: 1756925975-727354
X-HE-Meta: U2FsdGVkX1+ClsqfCWdAaOoZd7gisCNdKp4V6N9dJQ7S2CuqPVlzQAs27PoFJB/UCghiwOo4wC8kfxzjYWPnr06bSF33iJawuov99ZSnrRBq5Wb4KIJ20YlBHaYOtQpnOe+J1VxhQog+mkunUNvZqEgz7bcGGya/W5BN0PPvwAtYXsB3JpPCya3MpoY8TMNvNLqAmAXEF96HouQ051WE6E57xEewGQ44h0mGIVOB8Z8Dvyf9WB3K28GTO/HH+CSvIfnuvaDqilGvB6cxXmhZYv8gudzX/0QOT9Meh2nfp8Jwpdod0FS3iHuONeWKPiLqMRB1YMijjlbgg8Q+T42x2ukzAyuqjrIg+HjXZJBYWmixxZUssX5G2Zx6nbsmqOjjye6KfHsPBjDKA6qKixDYxtf6sBvmeJeks7d+x2I3Tk5hCenTEKV7Kl3iU1i9SwWiPlJchDp5G8+C36DMPfOPss1b0j+F3wy1P8ZDzYQKSluJJeoGUDq2VEcIBlOaMwpp4PQQV198ezE8KMzA6dhShDnYuyPnyzPyy6a7FXLrIrUJ1ywOicTySatkRVGKfzRMquSAYbwjkxO+/yC1EIFhWujZ027i9qIHDsFnFLJsLYaxLJW1eyv1AMxvh2r5gZzHiZ62MReufQvyVUKqqL4FMpES02rCetUxTumGcjCg1744jjSrXpMX40C+dbJgQ4FXZEI6QR3oxbsh1GAfHl9riCDsKP4NhimoQ0VLIosGYFUrg4jCHm0iCHB2PgXXIqPl2VIJP0hhHkcQUmC/mC5lD1gFsXR6H+gT9KPK7ScCl/QzV/3HDX4CD+vUZnRill3+XAeBSiJH8e9jLWNWQYuyAK6n4VPcoZabgmA1HnjtobhheFV8acwxeeoaa85+rKR3/McW+B2eant+KqrJ/twc+1PtkXTdsnvKCvWOyzeccKae78csCV2xRDJ+zjSD0zNQR1MLdmaA1UZ55sIE3cl
 OippmZ9K
 V5y6cOrfY5rkIWherLoLUpMkLLTdn9rUPOeiUbP6mN4i6EFhrDH2qxAKy7doD3eUe/SDRD8d1/71nebgtO3PnKSqe7wK9x0OwDenZScUJPS8paPMWazOk5PZurqWutk73Sys9rN+U3Qhw+XUZTgK0JhPY3a+V6KXIc8jDPF3ZbNjYZ9wPznjl4bsqTp2DL4sHyFgjldcBkIo9mIUo2sSDJnMqUEvca4t4FBpLEa2uwAgE9yxGowNkz8JNAI/6jEhuz75lZ14cpw/PCxm/33c3whuv5qKQ2ILEk89jJd6HjMKHyVJmIno7T3VxwNK8VIsJTvr9OWWjgBZfpHqO1rlgywZLqak6K9wJJ9zIuwsMb8BH6jn/AKHTBtqBpqpUFJ7iJnSY7ikDSsuA5IdTBFQUcgG50lCTK4CSlQ8XAtxF4wqEfTSMqLSxaZquPlk4nTAwfZPevyrAFOFzCP/n/AmjEzvPRg0krz/aOucwLTMqBN9ZVTvOM7TYZQIMduGsro9oVBk5at4/tYa8z+7W4C2q1jWGIl/Ju0h/UKWv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pages() is supposed to be called when we only have a virtual address.
__free_pages() is supposed to be called when we have a page.

There are a number of callers that use page_address() to get a page's
virtual address then call free_pages() on it when they should just call
__free_pages() directly.

Add kernel-docs for free_pages() to help callers better understand which
function they should be calling, and replace the obvious cases of
misuse.

-----------------
Based on mm-new, I intend to have all of these taken through the mm tree.

I've split the patches into separate subsystems to make it easier to
resolve conflicts, but there aren't any functional changes.

v3:
  - Collect some Reviewed-by Tags
  - Replace remaining free_page() calls in patch 7 (all other patches
    are unchanged from v2)
  - Add all appropriate mailing lists that were missing from v2

v2:
  - Reference __get_free_pages() instead of alloc_pages() in the
  free_pages() kernel-doc
  - Get some Reviewed-by tags
  - cc the subsystem maintainers related to specific patches

Vishal Moola (Oracle) (7):
  mm/page_alloc: Add kernel-docs for free_pages()
  aoe: Stop calling page_address() in free_page()
  x86: Stop calling page_address() in free_pages()
  riscv: Stop calling page_address() in free_pages()
  powerpc: Stop calling page_address() in free_pages()
  arm64: Stop calling page_address() in free_pages()
  virtio_balloon: Stop calling page_address() in free_pages()

 arch/arm64/mm/mmu.c                      | 2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c | 2 +-
 arch/riscv/mm/init.c                     | 4 ++--
 arch/x86/mm/init_64.c                    | 2 +-
 arch/x86/platform/efi/memmap.c           | 2 +-
 drivers/block/aoe/aoecmd.c               | 2 +-
 drivers/virtio/virtio_balloon.c          | 8 +++-----
 mm/page_alloc.c                          | 9 +++++++++
 8 files changed, 19 insertions(+), 12 deletions(-)

-- 
2.51.0


