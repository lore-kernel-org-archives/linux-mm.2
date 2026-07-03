Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92AB0C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 16:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F106B00B6; Fri,  3 Jul 2026 12:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4780C6B00B7; Fri,  3 Jul 2026 12:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3796B00B8; Fri,  3 Jul 2026 12:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06B346B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:20:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C2F61C1516
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:20:16 +0000 (UTC)
X-FDA: 84947977632.01.0280F5C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id A7D0EC0006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:20:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Og2wnZ21;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783095614;
	b=vpP5VuxxCe6TBtDMZRtlsG8sfBCVhSOntFWLEgRMept3CiwLfe7OO57hRlytrlCLWVDCkR
	G6OQ7d2fc+xQmoD6w66ahuNdueFDmD2kugNmRqD7WLdlMrO8riNysFPmbvxPRhCdrrDQGh
	whw+Z92ViuvjrtzBcqRXWzV2JBiavnM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783095614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oOBLhxm3kAjTeflZACa4rcGCxUXzgYmnLvdg8EZf+9Q=;
	b=uom3lYSHB8FBONZta/ka3jTltGR85E6sqoR6mKphmDSBkMkl2fJ7s4BcWwoh1gjh0L5q2y
	tutP0WFTmeOVK1XJ9/D3yiaMJohqrdhtNndR5ZePv86ABxWVWcTIUUuZ/fifyYuQZ9x3RN
	Mma/McgFQLaJwfxjA0yS09W0h+B/Bdw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Og2wnZ21;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=oOBLhxm3kAjTeflZACa4rcGCxUXzgYmnLvdg8EZf+9Q=; b=Og2wnZ21fqFUhrLnbeoPe/FgQU
	ZVjkCKeKYg7MLqZBzv1tvDZ+xQtu+cXc+vkBzMRCqKJ0ILw4eBC7YHP0jSdiOwLu7dxPgGm1zLZTQ
	YVhuRV6637lm05DOjDkozMp+8jCNrNXKzJioQ4Wt6Up5EsabJDE1Vp1CvUwfi+MNtHxyK40DINXqp
	pije8I/YKtOz3qD3N/7glNVsXnOZyXNc+KagR8cZYpqq88Zu3wT0wHQ/2eKiiYhWCqGM3cpVGaebX
	/XBC/RfZllNqDkI42l97pGltMF7kpTOq1FDygjGI4M9YNedCv9Mcg+fIk62kFWt4ZbwV2rJ+5+0hT
	ROiil/Pg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wfgcd-009WZ2-0P;
	Fri, 03 Jul 2026 16:20:11 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 03 Jul 2026 09:17:24 -0700
Subject: [PATCH] mm/kmemleak: fix checksum computation for per-cpu objects
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260703-kmemleak_checksum-v1-1-5e0ab7d6966f@debian.org>
X-B4-Tracking: v=1; b=H4sIAJPgR2oC/x3M4QrCIBQG0Fe5fL8nmIKRrxIR5r61i7lC2QjG3
 j3oPMDZ0dmUHVF2NG7a9b0gymkQ5DktTxodEQXOumDP1ptSWV9M5Z5n5tLXahguwbqHD8mPGAS
 fxkm///N6O44fDt2D12MAAAA=
X-Change-ID: 20260703-kmemleak_checksum-e69602b36a3d
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 stable@vger.kernel.org, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2627; i=leitao@debian.org;
 h=from:subject:message-id; bh=w3VSZDCuOXAjVdXDlxvTjX0QnAa4kgg0zmai2tKL4a8=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqR+E40XrNANZmWGTTEflSoKmO+SPJv3DPgL0Q9
 TJ4ssqH1ZmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCakfhOAAKCRA1o5Of/Hh3
 bfghEACFWQgEmpXIdb2pkGgrBs/mke1GfJxg2ovDvsveqL+NbLezvyMnc9TrJURGMoEbP/+HJTU
 4l7WScNmGFgEce6L9Td6rSvOEj/rp8hRKYVJfX3f5Uo3xJl03jPIrvvrxXvE735qz+6VMjRW1Rw
 bgjouTgNr29bLKRAvD5805cATAQAfMwccGvwEMBDc36/Fcl5pMxfU9U2+1YXuT7oRLCntEaTwIg
 pii1/Dhtnv9xjtSpE6EgDoGNQyPzNGRMwaiS5doMygHj7+Gk4HytGKBPnhlRub9Z1lCOwk0lCdg
 Lss4oXFNYNpaR+0q24hap6T/8mMK0Ru64DvcRTSTTJ8LaCJJPCYdPZmpnBH1YWMK75fLUH61H1r
 W7R7bbdNbDc0tsiTF6ePpY9+xSlwZ1Ts6qtsavyq1+WuhgnoStbK9LLI+4KO2KjHJXSlDxWikv+
 p6RAvgVza/9U1Tzjx0eqhOxxwbod6g33AsaA8RYZa/2V9W2zN6UiWq4Ql4MhvJe3Tt9PaaE+Lsy
 vIBHReJySbx4vNv7RYZO7oBZ7fsx+ArndecgJejNI7aPy62StZfQIkfawnS97a8uKjvooCHa5f3
 wro4pcL84vVlpi2ZotvpcZ4Vz0Zr40DSjn0hUghTiXD2Mh6mPuBSj1LJjcooZQS+d8sTZc1liGW
 6Bu0ZGufij5v/HQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A7D0EC0006
X-Stat-Signature: yzkrwyyrerdouw1q1gthimr5h3c6ie4x
X-HE-Tag: 1783095614-872812
X-HE-Meta: U2FsdGVkX18FKqfRxxtbA27n6YNbaRxaWl9L7g7T5f5CKHIS9AzdGLLdVmHjSVigVGtcxrSlE8XtrZ9d8BDHdcvbebq+LPt/CjSutL2bUF66h7V1Pp7M4UYkMvkw+LKJbwksUy8bSI+Q1WQ2qWXP0yjbrBx93sBGe2yHKgxs8t59gFUCIzi0wKd6iS2CcUSL6kDZ0oU6JjIgrr0O47UzT4y5kjdIKjsETRRAjVsTxLTUWnPA+4zby557UYJigRxclBaVx6pnlCUJuyW8TVBN2hGot1R0Tw/KIxagH+zOmN4X82hH/bOBo8r+e5R4GobfF02rcaL72rbFRaPq5gbduojariaEDh3nN7cBffYZ1Wyyz+4kaNJO5TvPcXlJU1H6t7VY/di6BY9nt/vJW/3LE2rhU7vaAvDKh0N9cAAJBKr8uRctEPwWGODRy7F93afODPuXoPQwtSRZd2Co2BvfZdAw8ZzCHCVTP+hchU2Hpfis7GafKNsdHq/E/YZkEKtlXRVlw+LV2CBok7PgRdeYxJHYvrCpm0391DXpR/sxwQx0oTHXA5aWr8jeT/yMm0wu7tn8AG3UI+jH0V/+YauC9L/7gpsUeYI5HmBImzq08Yp1sapThUEA353KjX2WV9J/ZwkTW3LxF8JIjft7GVJzp0Bqm6YMoLpmLgn7LR/nKwNQ44eovZ5azgdZAeRdzhmR6lhTp+KBZt2QfEyPVil4N1U2+m1a8fGLMwxTq0cV4di86XKtJxfcS03HjlAZwNhmfAYkVJ9YOXZXkhDggRofAh0xUSguG1OrSio1Yl53nT8ewTODALgyAdSAUqbqh8oOfdrMbTNJt7YUlQmX9bdTNcL0tO9j4otldqf1ERzfZZX9trlLWooXkQEoOcnCYStWGodLNwOtp2gCzXYIQyl8Na40opL2fwELeEmFOE/F5E5yyfOEmlBCTxWwQODqVI8CtU1HhtIsjB33EiphnRH
 X/5/NNuy
 AKbqwmpNba957Amd4ECYttGlp1DokCrJyVHVYcZiWJOBuydru2gQXHdSm5q2DasSe+Kp+qh1tVGapL4QcN1TvOUKwQqFW4l/waTn0Xph1NIiZSjwMwKihh18x034KD1tHQXJObPFdyCmqCMUwa2tSGMmJbMdVjk5XsUhpVeWHUPYlqQdDnmRaABaTGEKy3Hb/s90dso7SnZIvi1hJATs6uNdBgG0NrQJphplbYO0WNWQAWQxOc91U5Qk6tH1+xfiBFqCgovImbGnJO06x2KZPEllbPccJUOfnQrhGUS//DTehOFH/xkAb0TPzmDiNDHNDyOX/ffCO3P2GmsqxGtKYAwC+qCFJ09P8rwMimJFt3nVsZm1PA3vHrTcHJVrDB5DgwRWvriKBoWaiouY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The per-cpu object checksum folds each CPU's CRC together with XOR and
seeds every CRC with 0. Both choices make update_checksum() miss content
changes:

  - XOR is self-cancelling, so equal contents on two CPUs cancel out and
    simultaneous identical changes leave the checksum unchanged.
  - crc32(0, ...) over all-zero content is 0, so a freshly allocated,
    zeroed per-cpu area checksums to 0, matching the initial value, and
    the object is never seen to change.

See discussions at [0].

When update_checksum() wrongly reports an actively modified object as
unchanged, kmemleak stops greying it for an extra scan and can report a
live per-cpu object as a leak.

Fold the per-cpu CRC as a single rolling checksum across all CPUs and
initialise the object checksum to ~0 so the first computed value always
registers as a change, even for content that hashes to 0.
reset_checksum() is seeded the same way.

Link: https://lore.kernel.org/all/akfYImSNDh3OjIfR@gmail.com [0]
Co-developed-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 6c99d4eb7c5e ("kmemleak: enable tracking for percpu pointers")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kmemleak.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 68a0e30eea1e3..e96e9efd19b0d 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -687,7 +687,7 @@ static struct kmemleak_object *__alloc_object(gfp_t gfp)
 	atomic_set(&object->use_count, 1);
 	object->excess_ref = 0;
 	object->count = 0;			/* white color initially */
-	object->checksum = 0;
+	object->checksum = ~0;
 	object->del_state = 0;
 
 	/* task information */
@@ -981,7 +981,7 @@ static void reset_checksum(unsigned long ptr)
 	}
 
 	raw_spin_lock_irqsave(&object->lock, flags);
-	object->checksum = 0;
+	object->checksum = ~0;
 	raw_spin_unlock_irqrestore(&object->lock, flags);
 	put_object(object);
 }
@@ -1410,7 +1410,8 @@ static bool update_checksum(struct kmemleak_object *object)
 		for_each_possible_cpu(cpu) {
 			void *ptr = per_cpu_ptr((void __percpu *)object->pointer, cpu);
 
-			object->checksum ^= crc32(0, kasan_reset_tag((void *)ptr), object->size);
+			object->checksum = crc32(object->checksum,
+						 kasan_reset_tag((void *)ptr), object->size);
 		}
 	} else {
 		object->checksum = crc32(0, kasan_reset_tag((void *)object->pointer), object->size);

---
base-commit: 6eb8711ece2ce27e52e327a5b7a628ed39b97f45
change-id: 20260703-kmemleak_checksum-e69602b36a3d

Best regards,
--  
Breno Leitao <leitao@debian.org>


