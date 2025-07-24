Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49DE8C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 19:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65028E00B5; Thu, 24 Jul 2025 15:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16158E007C; Thu, 24 Jul 2025 15:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2CA28E00B5; Thu, 24 Jul 2025 15:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A436E8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:14:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 405B2133AE4
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:14:00 +0000 (UTC)
X-FDA: 83700108240.29.4AB3996
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4218C20009
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:13:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l1is3Gis;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753384438; a=rsa-sha256;
	cv=none;
	b=abQvF6yARkWxVB34wLrrOZmbiyqOB7KMV4zW4IiHDMhPc7wxrL3IjDe4NiT2MgeIJpOnir
	n+y/hZApdBM6DQEl5Cq4QupVqyRI9Gzhs0XEAFc7ZleRKPMR49NhZKbnY1MzKO3ZTnltGu
	7waLy1Lp0c9N89K/ncYNaSmoVZgQWAk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l1is3Gis;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753384438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wvqjKgmAxHvS61kQHKCMppQbPZSjiiJdgG3hMaDeD04=;
	b=g8C3s2Bm/8vYvNqKXF1TtfWb51H/8hQrKhawXIQag2pQc2kqYbpR+b5I0h2efgXLU2mgGf
	k0PSi/cu8tAjlUMjzIhUYqtPjqDZJMRtNoChhFfLZcaEckZrsKDCvJfM9ZNhQZXtX4SwWq
	NW7oOfofMBjyyUogBwdF+dU+nP0H6GU=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-455b63bfa52so9445e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753384437; x=1753989237; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wvqjKgmAxHvS61kQHKCMppQbPZSjiiJdgG3hMaDeD04=;
        b=l1is3GisTQyIzE7UG8Jgm+7TKtlURx9ljttYNOTl6FNOmcYY1A1qhbxZ+QUoFOhR0n
         Dx6ArrZjQRBiLw1WTD4rCNt0kFAaauUVdN9/v0vDyxHhz5YqWwnws3x0r7EL4TA6K5Vy
         2BlMumjcSxJB0eb0d5Ac0WW1o7lFzG4L2Im8QFcDY5ZQJL0qkKShV9EITTrM2kXCn4+G
         jiN86YGPvUjEMZhPauwXNLFlTdwNWhCbvTWUj7jOjQr8ZXRRlSi3uSKHncX4x+8Y+ngK
         E+HUaUoV3C6KSoyGWimPXYXJ/lU4rX2Hsm0XZExdG1z6m4Ep0XZe2/xZAJcf2Ynsl+hz
         IChA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753384437; x=1753989237;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wvqjKgmAxHvS61kQHKCMppQbPZSjiiJdgG3hMaDeD04=;
        b=uvHohNOItvIy09Zib7O5M9axcg4rmeUPPxZtBg2LwGD/SKSNG4lGGohCAKAcVipQ4h
         xMmh6U3a6tkNClQVtvcJ505tA15XwvnLZbUXiualfbLCUOcYSMJPubRaZONe737BLtMU
         we1VPQ5fT1jmRD2pTWmWNwWT8+4v96YIfeHP8OzC0NXeX4DzcaIX5XasWN940CJ6aRAD
         dVDWAEaToGyUy0pE39kF1fQAzi5BqwjIV8pOmpait+s1s+dwv80ahCTcf8XbUSPWGJwS
         uwbrzA4D1HNIPaF/6ebcXTo8WHxDsITNpYj9pEltiAoOpOHmowCIY/SgQhTNlLCJ7dTH
         /F9A==
X-Gm-Message-State: AOJu0YyZneC7NzHhV8AyYepXv/YqRYGW41kX70oqMGTvgAfCpajyEk9T
	bpkzbjhAVHqL6xQ9YAddQNF1wB1b8GbyVtbGI5dyQGkch8gyuNH+cwXFDk7LaNlnj7M61iOu7NB
	ihfo3y+MX
X-Gm-Gg: ASbGncvHjn+5m/ovSFt+U4+WP2DeqOGBxbv3I98i6epTu7rCSVdKQTByKcob7kkWao7
	5uu1tCqiodQ8FJur4iNcfMQAyNgdSLo8ppD+Xj7FjmzR6Zr2JPF7vrOobjc1bZrTxOhSNPdRguN
	3hTw0l/c60wi5vbCbfE8GiPru5ldAfcqIA3lBpHXUorEIoByM52L9FUyvoJPCIxKSzSEbOuxo9B
	4Wv3thpZbjuVXJ0ZJLoT5oADM+LvxqTwNYwgZPX0WMToRqiLf5EB1fCFLQAOMCFzdOeQoZnFHr6
	1oKiC8ajFDxEo+a69tEq+tWLsHP9EpQvj31Hnz009c4jnmuWH6uEbQ/vlVfaD+yqPNM2uPH2Wrs
	QQ3bRVrDOJ3BZPJjPptsP
X-Google-Smtp-Source: AGHT+IG6HqoTeM/LvEaoDun56uV6GbzB2LcdJNB2rWhSL7A+EL6K8+TGgrzGYXW7vR/+FcFvXmR4cA==
X-Received: by 2002:a05:600c:3ba9:b0:439:8f59:2c56 with SMTP id 5b1f17b1804b1-458730842b5mr158385e9.2.1753384436268;
        Thu, 24 Jul 2025 12:13:56 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:5757:f399:9323:7f5])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4587054f338sm28555995e9.13.2025.07.24.12.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 12:13:55 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Thu, 24 Jul 2025 21:13:50 +0200
Subject: [PATCH] mm/rmap: Add anon_vma lifetime debug check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
X-B4-Tracking: v=1; b=H4sIAO6FgmgC/x3MQQqAIBBA0avErBswKaSuEi3GnGwWaShFIN09a
 fkW/xfInIQzTE2BxLdkiaGiaxtYdwqeUVw1aKUHZXSPFGK4D8KLNnRsL480OqvY9p0xFmp3Jt7
 k+Z/z8r4fpYaNUmMAAAA=
X-Change-ID: 20250724-anonvma-uaf-debug-a9db0eb4177b
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1753384432; l=2125;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=SKCMXsnSeRtRSHspFusROaZkjfL2iP9BROPQgWT4iv8=;
 b=CmyTLcNCTvv132ht3agMAqhsH0w3t2N0h4jtV81qEiHKf4I9vTMHkGg5eUxTETvXZtqOUenLw
 vMLIuok4ECtDxn4DH/9iAKnXiTygPuCPBxz3AtOVG5JcraxI3tYwM5K
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4218C20009
X-Stat-Signature: yiih3w6yntm986j4d6ahfwhribt6qhgw
X-HE-Tag: 1753384438-637140
X-HE-Meta: U2FsdGVkX18KiD2TLIUFssd4bZgtc6Wlch0JrD/A/j7lZyNlxRnMdPMHhjp8TbXaWvpEbTamDf433B9U7KlsBR22kQYhkG5/LWTb5wohkFKOoqERVFcd14IHWeoWzZqBu4dTSid8wLFBeGXlYTb0OJtcA5VnMH7XjuNYEuGpSDDP8sRWL/c64oUxAOpUAaFzXt3XjiOWjTaknpnMlDAdZ0+iWeHcF1+fBAlW//pFWsxmZuCM3HgdSkNC4Vha7IubNFUUyHuGz8qvDEHXFwQEhjhpS696LRjDJMIBDh4ppKOrOBvMjBwUHJxeccCkdEphaUPJD0oq/XDzqX068+rL7RhGVbLILrlTcb0tRHPsnq9HxScx5dNV3eVtr0dvrUuiqfElAjnvObKE4+8daTa73Tmhna9E9xm1pGl/HfGZbuJmUxy/XzOYoFwf6QsTVgM9Kr4yGWnlwHUxUedpEeZpIDp2aOKbwUKKBVu+JjVXk9eEvTxalnVEn7dAnMYrIqD6B5h4cXT49lEzJk+mczaQ0+evXOZU+Ou1xehx/irX40SLxedmL/8pfHSigK0NAaMlD6hZVzuGcNLaCQqpW9/I5xMM+tYfbV/4qPE3A0QR11fKcEklD/H0ZCzvhxs+LkpWjRhHEgIxIZv712fgHIFDrgDIsbzAlg1DB2lzcBXNH5MQgFC46dy/LCbMa1OSuzltgF5o3u6EFBxxRYuEjQyCRDUyve3brem9RZil9FOJTZl8uACqAommYRyrSS/vqZ4CuerH4a1Fa5/V8pEhxsZtOOLE526Bp24oqTaOynx5NkCHpMPbWe4UNU+QFhIccqjmXVM9BB+aPuB0fPZNN12tBZjSAD1EUav9xpnAyzT7etL/4wkPtpdFhgn3it8ScPicOX+E1wuhEnIHQq7wb22zSCQs2EASkDYOYoozjYjzTFiOgf7WP8GDsJetNhBOUO4bHDL3CFC23tk4Zv2Fdj5
 +xHona63
 Rwr+hFtWdagxS9zSRhPeyItjwO2ct0pLUoJ2p0KqelS2tQBdJv1i/ZJAr7pyMbVS9EURuUqhGfbBW3yRm3gEU8qeI7qmKSqee6iOina5YDbOc0RuGNgZTexX2xYHKyV3ssQU5vs8EPDcXvhWbaJsoDMyWxRgUb3P1zO1oGZWhr//UbOAy+2bWEaEYrRjwuc+NO/wMPRlqKuT2JrrDGeTIG8+3Gx8zzC2auIRk2grHJkmosTYIPk7o9GdlkScJSDmcVsp9Gh/YDv2SIojDPfSE6y0CV4wNVD2VspiN3prxBAxnMBh+5LlU2Fk1VgnZVAcz19d9Bbm+fLEaDMv/DAn1JOcBpknubZcdIkOXdTX+3+GR55ImjH0m2wv9mA+FKFk9x+Ak7DRayp9Ni3mOj3Xx/yHTyH3tFvI77iuX83iXh/XAYFHULmNutoWWFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If an anon page is mapped into userspace, its anon_vma must be alive,
otherwise rmap walks can hit UAF.

There have been syzkaller reports a few months ago[1][2] of UAF in rmap
walks that seems to indicate that there can be pages with elevated mapcount
whose anon_vma has already been freed, but I think we never figured out
what the cause is; and syzkaller only hit these UAFs when memory pressure
randomly caused reclaim to rmap-walk the affected pages, so it of course
didn't manage to create a reproducer.

Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous pages to
hopefully catch such issues more reliably.

Implementation note: I'm checking IS_ENABLED(CONFIG_DEBUG_VM) because,
unlike the checks above, this one would otherwise be hard to write such
that it completely compiles away in non-debug builds by itself, without
looking extremely ugly.

[1] https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.com
[2] https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.com

Signed-off-by: Jann Horn <jannh@google.com>
---
 include/linux/rmap.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index c4f4903b1088..ba694c436f59 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -449,6 +449,19 @@ static inline void __folio_rmap_sanity_checks(const struct folio *folio,
 	default:
 		VM_WARN_ON_ONCE(true);
 	}
+
+	/*
+	 * Anon folios must have an associated live anon_vma as long as they're
+	 * mapped into userspace.
+	 * Part of the purpose of the atomic_read() is to make KASAN check that
+	 * the anon_vma is still alive.
+	 */
+	if (IS_ENABLED(CONFIG_DEBUG_VM) && PageAnonNotKsm(page)) {
+		unsigned long mapping = (unsigned long)folio->mapping;
+		struct anon_vma *anon_vma = (void *)(mapping - PAGE_MAPPING_ANON);
+
+		VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
+	}
 }
 
 /*

---
base-commit: 01a412d06bc5786eb4e44a6c8f0f4659bd4c9864
change-id: 20250724-anonvma-uaf-debug-a9db0eb4177b

-- 
Jann Horn <jannh@google.com>


