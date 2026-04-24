Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C589EFED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6526B0095; Fri, 24 Apr 2026 14:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FA56B0096; Fri, 24 Apr 2026 14:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2201C6B0098; Fri, 24 Apr 2026 14:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 124726B0095
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:36:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B36011202AD
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:36:45 +0000 (UTC)
X-FDA: 84694305570.04.D141416
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id E49784000E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:36:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p6eHzE10;
	spf=pass (imf12.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777055804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RtzXRmgTfVan0ice2PdMuqIMZoTm/AmJVZu03BcMZ80=;
	b=qgnG4gHTsjr8dzIYuvWWItZsYw2Bz2Bsy+yegjv0KSISt8ZghBmgjWIN2u8bnQQFrm/iaT
	DrZdbmyreh7lxb+oTjrVpZkx7bEaA68nCX/0ahVsMUF36BC1lOBI/xH7K+X+jw1KBmzwwB
	NGd/8fnbxe2hMDGkuk1tPhdSnaxXTro=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p6eHzE10;
	spf=pass (imf12.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777055804; a=rsa-sha256;
	cv=none;
	b=CYq3+SBOMgz+CzTWHahe1MwJuXeVbicvBrD3h+kP0vfLTpO+MRE1YvoiZvYTNoRV54ICpf
	5blVmeysPKWaQbX4AF131Lo76p2UJzYDqmP923aRLBNZ2NUJjBneCZdtv4AUPBunXY21tS
	uqQT8i/NlnPeclGX2n9tzbwyEx9X3k8=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48a3e9862f0so41541565e9.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777055802; x=1777660602; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RtzXRmgTfVan0ice2PdMuqIMZoTm/AmJVZu03BcMZ80=;
        b=p6eHzE10uSAFTqevLuRPasN6E2Np4d+yDlMFTiwSKE06qTPFtyqtnpdWU6xrIiRjlb
         qVKPwsKOCHO5WnY1yBr2W5sYkGxDdJusK50TMiBwcK7oMEyaDp4uOrN8Lpi9AyLFlMyL
         bPMwwRVHlEBP0K4DMt9K1bHvDCyLq+Smny0wG9Cvyd7deLdOlP4o2NvtiPdA8CAXLPDJ
         EB0vJ5lK1uAEmojSri3cIyvZ15FL4Vx8ONtzhU3QnQOTpSbcpGG+041ALxlKyMbRktm5
         u/tLXhCzB610snIdowV5uFBGoI5bzsprm7lJfCtXcFsNRGhwiPCy8XlGAa0pJ7iAnFjS
         HEGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777055802; x=1777660602;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RtzXRmgTfVan0ice2PdMuqIMZoTm/AmJVZu03BcMZ80=;
        b=Eg2OC1OrFc3mV/hAJzoVqf3mjmCCP6bqW0osTOWgI84FlNKn9LlpBjxpZRu/hnDKLU
         RGcVajkCDE3dBWKS5+zsC1RmvdiLHuEVDt9HW1Y1nKDd2mTDUmaj9x+8rbQNCLd62kAk
         BRjkF7nNxBW3BT/1G2IzYGEjQdodK6Ptt//sFxL0qXPSJ6HczTzjKYsSnMOSTcLoiJ3O
         pfTtHviCQWSWFWAvEgRjyoCh6NOXDHIZo/Zr922ab6Kqyexe7FaIs3dCoykvcwhi0Yvv
         au+j7QGP7sWUvEClsQYCMt5nC81iszbjek++bx63CqxLW2C8Lvuig4p1IbNS5CS+hL5r
         WfRA==
X-Forwarded-Encrypted: i=1; AFNElJ95cjC1tv7kVN8Vfu2Krk70WSuYmIrXiZrBlbkq+u+7eVPoxfr0JB2vtQCPwiiIW8g2nKUnjVIjpA==@kvack.org
X-Gm-Message-State: AOJu0Yx4c31L9t8X1rR0WShwj7gXyH2XESNKIfX2JsFHc1IPrdSgIfZ7
	dyWaZ3FjNgOlUE6rrhcLeA8JOYK+SU3GRSuPhFMMLG8GgG9PUVNZLlD6
X-Gm-Gg: AeBDiesYuG/GbjOsW8YW62basoALDxbcAmt5U9IGf8Ri6bqymlAxQIqwvxQSd78zTA9
	tb7Xra4tlde/W7I9xYpnfIgo39HeLAw+twQF4ETbMvV5M4sWGRBbPYt38o9FzKjjq5eTT0tMnY4
	23XjJl7nUfXL48UCbDQnGoGwrXpawwPJEvrOhoI0BgrH0WuDRblKj9d+4Xk8bxGNvsSK5O7X1DP
	1JlZzY7nrcpYIqe8zMwhJ1YFtxcEvfa1fATXiTYqchJrxO0kEUfaiCsfC5Ne4Zb/6ZLuTN0YlxB
	puArOz9TVMUd26JXtnwyZN5ulvvvcP0MpDAbW4GYHjA42EEx8WJuDOmmvLmtMKFdPDheS+cf6H3
	yCNAPRiHsV1ujMDtM9w1rMK4dZZwHnBIPaj14lHRaXWomK4m65I1oUcivNTi8WeBVibCX82t4qj
	CJPjeFERSPNNhMzciHix+XxidWI6r4il6arcjaQGZlonzYA76UaDafagwCDprCKefkgMnSvbjTC
	5FyU3c74UYegVRDiANn4A==
X-Received: by 2002:a05:600c:3055:b0:489:32b:ac0b with SMTP id 5b1f17b1804b1-489032bae49mr231940445e9.6.1777055802011;
        Fri, 24 Apr 2026 11:36:42 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb7b2716sm191182075e9.30.2026.04.24.11.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 11:36:41 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com
Cc: Liam.Howlett@oracle.com,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v7] mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()
Date: Fri, 24 Apr 2026 19:36:38 +0100
Message-ID: <20260424183638.196227-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9643mhayszjy8xiqky5xnzhiiwurro8u
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E49784000E
X-Rspam-User: 
X-HE-Tag: 1777055803-784097
X-HE-Meta: U2FsdGVkX1+9P00vod0aECX8mvnTg6webGCd9JN3szaSVtArP1JXIWFdYMTbO6uYUXr1TamqBeKXAt+gkh0jHYTJ4TApJhCwAaQSzGpSvWRldDfuypkRCOPiFuMyZN0dW3vSL5sXA+70fEEObF09/exn3nonb6Ykv9bhqE6NrTdHpIwNDdNgUpYP1eH0poc7MCcomFAX1uhPn8lqy1j9g2vovVBJH3lEcnsAkzGowm022wEarzaU744Fyj/1KvIISHOe38wjjXnhuCijzQCeTm2vX7cfqvHtvDjAV68BRrzS6jmkbU1DY0i4BHlPQ98KXGnk45PuNVS5iRGvyNzPl6fvUJa3LXSbz+B+fZNGZUqMvJw9dJRyfTaogaktMDwR3gGK0kjsocbhdI3C/Wr6+8b6rbBngbkDebemo9onWcVyxuIDQVFagWT4teBe7zNOA7AiOBzmOosBW0ZJpfgbUbJyDpQzhovrnJ6fgYUJT9NgyyTMhtD2yyXEWYpttrH35+RlRWx2n9ucyLiEjDftPTluVbdXv+ec0WSr3dQLAlhjqvUbcIS1tdR3rWwZPny6vsIAnE6cJgi1PbhgxWn3FEMCvLAcn3qH9p2xD68EwAyPQ6BPX430CnU0qbrXCz4y72YIMY9/6sjS/u2q5URqZ651+q46S6/8WImaWZ4Tj/4DrCJRUCgeVrPESh/7M/ZulLFW3JIiGDviBB9mu2TaWwY3qh39g7hvvawxm95B9njujZkF+rbUCtSP2+XPvqKhD4V6YpJ+V1P6NUQaQtYWynbpJD3bKFWdYTDdQtBd8r4gXoepoTIwZWS4DeZbbUFk7kncDIZ/OQBsaU2dk1Ez8nezYSWOkmKndFjppelmPeNlF8At/ZLRcZ+sRl1/29bf8Dqex4zL9PPoJHgoAGFMyj2R3YVvyVfA/6ZwlcG7CbNvMvfBrhqF4JoR8R4Ged7aH7MWzsHbkeKoLpMG7PP
 OPigfptO
 FZezAmzp/BWm44+dwzml0lXXOm7I1RWIb8Zmm9hYwgtjO7X/pIQyvqZPtLNvRxHkW01sPYB/0sd6HS2RKq6aYdkPiUgYuyEtd3VAnYaFBXV+kBt+nVt9PfBnu9s1Z3hW60hqZHmSDOOJ6EqMTtyY1s6DFmbqdfzhMGdHr47JkoOGjN5nEZT9RLIobh/plo0St9D1Qyq1uatc3QxkBXLcJdtnWCOE7rM0IozNrMDY6YgUdcNCupoucZM9q11ySIUX0gYR36JfQquNQdhjmTFMDh1vHd3rx+ZPQ75b+ww7bk3BIHmqID147VmjQGlyv0qrB4Ibe0jT8jqRsGk36wt4mabr1up80jpkbGTCF60KqWAFAT05DvlX41+A3N9FzNbsFcNNH2pk9oE0gZuSzGK2ghVin32K5q8ygCphH2TT/iArAu6iuTKKvPykTt80m99ivpiNNdInM3zhgwVfYeo7iwIsq726iGVc6RvQEqsMeMITpJT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mfill_copy_folio_retry() drops mmap_lock for the copy_from_user() call.
During this window, the VMA can be replaced with a different type (e.g.
hugetlb), making the caller's ops pointer stale.  Subsequent use of the
stale ops would dispatch into the wrong per-vma handlers.

Capture the VMA's ops via vma_uffd_ops() before dropping the lock and
compare against the current vma_uffd_ops() after re-acquiring it.
Return -EAGAIN if they differ so the operation can be retried.  This
avoids comparing against the caller's ops which may have been
overridden to anon_uffd_ops for MAP_PRIVATE file-backed mappings.

Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
Reported-by: Usama Arif <usama.arif@linux.dev>
Closes: https://lore.kernel.org/all/20260410114809.3592720-1-usama.arif@linux.dev/
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Carlier <devnexen@gmail.com>
---
v7: (akpm review)
 - update Fixes: to the current mm-unstable hash
 - add Closes: link to Usama's report
 - drop "kernel crash" wording; no observed reproducer
 - align Reported-by address to usama.arif@linux.dev
 - carry Mike's Ack from v5

v6: capture ops via vma_uffd_ops() before dropping the lock so
    MAP_PRIVATE shmem (which overrides to anon_uffd_ops) no longer
    triggers spurious -EAGAIN (Usama).
    Drop unused ops parameter from mfill_copy_folio_retry().

v5: initial ops-compare approach.

Tested under virtme-ng (DEBUG_VM, LOCKDEP, PROVE_LOCKING):
  uffd-unit-tests: 67 pass, 0 skip, 0 fail
  uffd-stress {anon,shmem,shmem-private}: 4 bounces each, clean

 mm/userfaultfd.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 885da1e56466..180bad42fc79 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -443,8 +443,10 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
-static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
+static int mfill_copy_folio_retry(struct mfill_state *state,
+				  struct folio *folio)
 {
+	const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
 	unsigned long src_addr = state->src_addr;
 	void *kaddr;
 	int err;
@@ -465,6 +467,14 @@ static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio
 	if (err)
 		return err;
 
+	/*
+	 * The VMA type may have changed while the lock was dropped
+	 * (e.g. replaced with a hugetlb mapping), making the caller's
+	 * ops pointer stale.
+	 */
+	if (vma_uffd_ops(state->vma) != orig_ops)
+		return -EAGAIN;
+
 	err = mfill_establish_pmd(state);
 	if (err)
 		return err;
-- 
2.53.0


