Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD005606A325
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 21:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TWfiP9ba
Received: by kanga.kvack.org (Postfix)
	id E55596B0266; Wed, 21 Oct 2026 17:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05D26B026B; Wed, 21 Oct 2026 17:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8266B026C; Wed, 21 Oct 2026 17:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99F956B0266
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:11:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00DA41206C8
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:11:08 +0000 (UTC)
X-FDA: 85347878658.14.3E0F3A3
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3F5BD4000D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:11:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TWfiP9ba;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792617067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tJhC0Ffmn6Au+X55U+ymWoJQmHp6YtJ+SrtYAdk8xK4=;
	b=JyVaThzJDYocqpLM3uCZzFbbH5jGDZXB8PB1gKxTJtatwcRMjhDztMzQBpLoNtUI0a3RA1
	cTY0qdobyIle4ZTc0kqGcdlvQ1xvlGx+ZCvMr4e0H1cGLrqYqyNwY62I38Okv4InE/kGrD
	BZ3zNnX+2dUdeCXcs5z1FW3Az70fKaY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792617067;
	b=AXH6A2DoLLkcz5UwAGTr11qdwcWJWD65LDALtmRI59ZU8uZjSZSSOqkuAEZWn5FuwOqVNT
	hAn6atQrZ0kPrue1lDgLXaFmg4sW8j/oCTOk6GKvRIwNS5m3/Mg8/V4pjQbNPOanDNM9he
	O9iarFVZHmcDaI+sFTHWLWL7gLO7UH4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TWfiP9ba;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4956869750eso8517785e9.2
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792617066; x=1793221866; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tJhC0Ffmn6Au+X55U+ymWoJQmHp6YtJ+SrtYAdk8xK4=;
        b=TWfiP9baX1FbM9lWxEAjZMTirL3LksNGSZGzXHRSmCyGD6bK2G2xazwedlMFL6q+oC
         bXS64MCw3wq7x1gFSHKsAz7EUc7+XLvtguigAuc22p44C7Z3m7euFQb2f+8DaYfT2EQb
         i7Y0ZkYMTsECP9Hi1maEYzqm3CkZl9RNhqlNmotkYmNTqsSieSEDYPT6pF/465o1YLzM
         pK14XJk4M0xMwdzC/WxqsqmE68mjjWfxe0yrTPyn46zDoDNxgen5dHuVjVFVfqxm+byo
         B01rDINHeNKiQjAxJzjXMkrHzCQc0fkESHZ0OSw/Juei0i4C+a4y+I8CDg5A8N8opLvA
         +zzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792617066; x=1793221866;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tJhC0Ffmn6Au+X55U+ymWoJQmHp6YtJ+SrtYAdk8xK4=;
        b=b+vVD+T7CV+OPPPREteY37uI7HNDleXMyBMdOfZ15YT/QhsOFmzj7Vq4lQTmlFjdW+
         o0y2w6CiQkasLwUusI4rVWi+Q27kF6gCHsj2u0FOBSCmzcybTD1xTGajJi+uRBPjUTQm
         k28EgdbRE561pjYgjwOfFMLxNzOCKk88JBAadKn/b/5v7hDV8iPX7RWplIIjggfcT0O8
         /HsBb090t8F5cYxA3OKIV48R6gNh7AcuAT3JLWkaDmkklqi45vcrghgKt73gAl5irqyd
         r2QNHp4DPl9ssvXCYH5JHm86tQLjpBdKEvOwHV3AtPuOXW77Rtmdv5JfFfvDW2aYqEgL
         6gMw==
X-Forwarded-Encrypted: i=1; AKwUvBxVW/eMuvi2C2UZzFeYMdimJpbR0TrZJIqfVbO7A+pq1cBGrAun/N9tYwMl+F7mePmZbC6y4Nr9wA==@kvack.org
X-Gm-Message-State: AFq9FYImkIMYqxxKupg9LEENA1TfbpErz3uPxckffVeI7RLcP5NwV1Q8
	ZG3G+p/rGKVcrq8NWmLqlxgv/GrkkvMTWffffzWsa+Nr40IrRl/kjk2K
X-Gm-Gg: AYBFou3jTG6QgzQ9S7128cs7H8KLITiQCubN5zyBhgwdSBGu9Dd5AUSopSVftuI7KAG
	upoM7koFiriK0hzGbDN0aNECITpaiEmp6tCKBHmTAZeUk6i3EEVBkO6EgKMU/h07NzMmL4EdiWy
	9ioeYuzwEzvplRBtD8yiRS+IhKjIxwf2iSEN3XS0BpPFap6yscdHIniguz5pfUv3v2pxobFwcio
	mxXQUdlm8gENEAS8A8+ggodeNeo9z2ugxkkp7ubvPTbCErcF7mSHSZ3QIQuafFoGmyERWo54QQb
	tvfU2h0QWAhoKWQ9bwm+IU6RAFcRNCVeaBb0vCJEk6j5o/GQh6DGPCiZo6e8qTONpubccXUUghr
	n3gcqf0+ysU+z/uZUNXWttwu6gu+W2kx3hdb4hDtJDeECXYnRRUDWyCERaXuKrckxEd44iwObA/
	M3Adao9MtUo/dLZMBrYqxiQv08ikvdPgHf6io52O4a9TTRNHHgRxYVPJvMICXJaAAzqiptLPz1F
	LSXgcZHAIOpNAkg55EFNrLhgA6zkt6XQdRX0I1g
X-Received: by 2002:a05:600c:4fd4:b0:4a1:dda8:eb73 with SMTP id 5b1f17b1804b1-4a1fdd53c8cmr68455165e9.27.1792617065604;
        Wed, 21 Oct 2026 14:11:05 -0700 (PDT)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a203a25fb5sm22891525e9.6.2026.10.21.14.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 14:11:05 -0700 (PDT)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>
Cc: Tony Luck <tony.luck@intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [RFC PATCH 0/2] memblock: keep reserve_mem regions out of KHO bootmem
Date: Wed, 21 Oct 2026 23:10:44 +0200
Message-ID: <20261021211058.83483-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3F5BD4000D
X-Stat-Signature: 6c849motb5s6yz9izygzrinsysp4sq7r
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792617067-169275
X-HE-Meta: U2FsdGVkX19jRsAk2B4VwoRBWnzlzYmoqgc/taRucJa8HPI5iNpmOvuHxOgGQsGC08Vi4J4aZWLFLI6QAQK2eziyA/8agtAVJcF6U4itZWxOZnV8xdPf7weRBAuZxpFMhNtVs673zux48gXe7ti8aGATxajCuSUmUNLrbaInBX9ZOmmTdqQX/uWi7LMvM4XJWpe5HqvjtYi9I5LKXyDFsJ3CX5ByXgO3QEqAbX/998crIE3sRYDqu6PRNvhLvHbnUDajfAjp6WN9WSQ9VA2rnN/CWmSHRfF3GtHqIHYjWWmsG2JTi8gRq/AglYDegaZdH9J/zYl+RSUcJZ7ne0iCHSVCkqkPaaQmsLaKNeVMBfyhCvoO8/0da/dDQhMhzEDOmPY0hhUlQfNBnX/5b+ct2xjMj5B72mJkH3NY77V9EspOF9szwztDGLCygJNlMb5y9vWSIWmUVqH2NM3zf1ZWaybhlIw+TRMqA+MFXIJACk2bO1QMe4fv5uoJRW0smOWG/dWd+H2LBh0Q7nXLUKRNdKttfsG20iXPUTIACPwZ6ix5xUT4h9BYzxNaS6uM+qIX7eKvcuvVUozQ8WNnumFMhr3PQN4PJBQueIFOt6/5lUzLgyz3qVd5MbjAXFBO8pMNxaZMe6a3TAEnfeJYRnUupsdaJ1dTIERaulj4hCGW5BmSoFfyUUVhKOPSE9RmpKtqUFgR7aKx6gQbx2N0p1k+CTnVdH9D/+5H87qlRMLrk64/QPp5xcPndU8DEMlvrFGMFoX3dPUKICuEdJkc6CbySrHKtaox2UtQfKzXwL89dkIYoLAPH3P1u9CwcNPMMWVcsNtwj5fpCgePxQzq0bvSYL1nkZ0r0En1wxp0rVWxJJzgI00YBQ+12FyQAoEwrgkPCB6g9b2ZQW3wF8QsWTGjAs7IbT0YjXLS8SsxzqB/77HWFtWgy0ZZvoLuJ7oPTjiR9hnZZ5Fkt3QjlX7ko3U
 NbygRV5h
 bckwvIO1I7Rgnx9tqDkKHJPNj3WB0xGPp+kpiwFPjLxQ3pjWzaC8cStgNNKFETVRu0CpEVNBzUfky9Mp7xLVsAXgMuBXP4wB7q2yJ9sPfaLoKVyubi/vybgMIB8JvDwFOjvHgqpPsO5k/uXigE+XJoqZzFNdypbG0lw3RejyeijJwNj9Wg81DmncXS0jk8yL5DzkEFPIBRZsjqJX8o6J5sywkbfYigokmUqsz3ms6rTgAfkuyWXoOwL4SqpDezMkw1n+Y/RL6X9jPfyLpj1g1neBoljO6bbW25uUCkfmavVLht68nGTsCpHTX0WgHV6yr3JFXQPwUrCgEy4kUbWeJvenoXCtUtDVO648taZdropjHctrykn8mLprvFlCatHc2PgDdLKv5Jrp4h04pIzokbU6JH3DXfn2JNDgGm0pHFD2VwZbZFZUD4kygkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On a KHO boot, a reserve_mem= region that can't be revived (new name,
size or alignment) can be allocated from KHO bootmem, which the next
kernel boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG preserving it
fails; without it, the next kernel's memmap ends up on top of it.

Patch 1 factors the bootmem check out of memblock_alloc_hugetlb(), and
patch 2 uses it for reserve_mem. That also drops the TODO in
reserve_mem(), which asks for the allocation to be outside KHO_NOPRSRV,
though it's bootmem it has to stay out of.

Questions:

- If kho_discover_noprsrv() fails, only bootmem is NOPRSRV, and
  reserve_mem() now fails with -ENOMEM instead of using it. Is that the
  right thing to do?

- Should reserve_mem skip mirrored memory like HugeTLB does, rather
  than keep the fallback?

No Cc: stable, since patch 2 relies on 14773e2aa4c5 ("kho: extend
scratch") for room outside bootmem.

Based on next-20261021, as it needs the KHO bootmem rename from
liveupdate-7.4 and touches code changed in memblock for-next.

Tested on x86_64 in QEMU.

Jose A. Perez de Azpillaga (2):
  memblock: factor out the KHO bootmem check from
    memblock_alloc_hugetlb()
  memblock: don't allocate reserve_mem regions from KHO bootmem

 mm/memblock.c | 100 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 64 insertions(+), 36 deletions(-)


base-commit: 9a482184d910775cf648863148944945b74e2815
--
2.55.0


