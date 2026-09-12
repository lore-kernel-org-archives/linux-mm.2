Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABEABC88E59
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 11:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813FB6B0088; Sat, 12 Sep 2026 07:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD6C6B008C; Sat, 12 Sep 2026 07:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B4C6B0092; Sat, 12 Sep 2026 07:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 436166B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 07:05:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7EA2A4ECE
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 11:05:52 +0000 (UTC)
X-FDA: 85204830144.21.2AFC9A6
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id D919A180007
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 11:05:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="P/v3nVHs";
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789211150;
	b=0jtztH5PcWP5NicICIhsYqzCHKZyb2Pr6/AbErhh9//me87EPOa4HOaCcMPeag1Dsujh8B
	ZgiI7FR+VjwHAIS3VqWEZa8YJzWr5wNa9Dd+XaPsQId3m014y5AvefDKz6FcQUPMQ6Owch
	NTsukOjPESFe9cxH6WSsdzrIaf1CFOk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="P/v3nVHs";
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789211150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ea2NflktZJdbiCBZKoJ2b9G1DxTKGyvVgfDXxJDHwxs=;
	b=P5zOBgwTFTdRPyeLIWT1QQPHyokFp83W9+f1cBmIgltE6bG/mMjWLt4DwUm58Vka3gFt64
	k5EyO37pc0TgipqMUlBJi8mZg6B0MnfpSA8UkblhozUuaAub1crbAW1oXZR+avPEjcpU8b
	rITfvy1DTuzRFVFx7L1kYCb8oFk2OkE=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-90e92b99ab9so13572866d6.2
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789211150; x=1789815950; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ea2NflktZJdbiCBZKoJ2b9G1DxTKGyvVgfDXxJDHwxs=;
        b=P/v3nVHsYhOVqDB3DgbtvTi4ZPqfQEzSvB5v7m1HetdJJB3NzweuBQySHAspAu6Vgc
         +5j3f0pnvVZKAsg4Lke7NUOqXkH/o5Wb7enco5SIxW/8+lywYDZ3w0z2CVWmCpEcUdCs
         zeyX07RZUjKDQ+29991sopKNfGc3DddPYMdpWXYhZ92SAYkBZ3S0D6VwuhzEgHy6ueDG
         HGpPMcaGmhZCZbIiB5zJBX8enW2HYf2MM/SD+XqkSJvJhVlMzsqUWfFD1rFBy1Pen3at
         2AiH0WDIcm6sVEBEG/A84xMpzf/qE7fEGeeu9CzFigzbIZAWA4o89oYta52iLzcwjf5b
         SayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789211150; x=1789815950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ea2NflktZJdbiCBZKoJ2b9G1DxTKGyvVgfDXxJDHwxs=;
        b=tOGZZzZG3tb4aeR7JASgHF/BtlqCJlFYgXKVVR88vB1OA1MznkV3TcI+neef4QoIMR
         50s/9+F945mA9WS01+wqoIPDOGr0JA5kYl4NbNOaV/2CSRTOstHAbhweKwepIQWwJk5e
         mGY4qTUxryN6v3vlq094H1Bc5EjpyE4XycSheVvrb2a0uTt68vg4oyU6borgr70hK6ad
         6LPPWiyxfd8iZFXLhxdsD+pFSmkG+yEl9+yo3eVBnJHFwyRVV8vijctZRQDWpnfO3DnH
         umXxPPUw8E0YosDz7LT45Nck9EjDS3oZXOyR0aQcTo7+Hq3OTBjEtlA0oxmcEKFqiUtw
         hsJQ==
X-Gm-Message-State: AFuF++lZ2jndBRwjPaGon8Om89nRp2uJ/IPdVSsiCNJSUQbXtLB+si7K
	CXMSpjXpkU1u9fQsAE57cKb+bOIBPH2mytuVu6NnngnvwKKA2LF9xqNbzBQNzSkA+IexxYlJvjW
	2WoxM
X-Gm-Gg: AYBFou01I8MV7AQawMg2p5eLSadIdhEiuHYS4HDZMUZ5AyMEKhtjJq19S8ZIbtIPTrv
	FkvlzZZS7/D4msRymgDhL9h+JdTcYN+RfSZJ6MEfE/H14Sig5D/NoaCXpMhVPA7O4xiusKdzxgr
	IRYzy1Ts46e52X1yTm+JmV/vPFtGIZDqYwz4N1Pu2OgCDu7Ajb93oc/MBEZbYbShfYDHFIWwSr8
	lyY5l2kT+xFE4YTy9nBwl3SG/JapfyN84GpNSUn34MwHpiP5iEqPxQk4EplM0RCphmlYKLw9657
	14pDOsLL4gWIvtpL8gIqPMMCFYMVwd2Wrp8cifuw0jfw/czPznyQxkbeZzs/aA/FLFNNevk2B6s
	yK0gLdL0+nKilt/s/uUgkYkaZ5sE+n5VaevwPWdhaXV+HR+XUvMcItIO6ZXKncb7EVv2SvYRkGA
	e9zD7CoWZdV5vr4lM1Vm97sfAkkIiI8fsY+RcD2hsaIZmrRavTUp7kmE8EUhl3oKp2xFDzVf2qQ
	o2rYI490bpVK++jbph7ifrYMrr9TYYdlNzCvipqkUhbv9O8mXI0ZcDd/PfE
X-Received: by 2002:ad4:5d62:0:b0:910:3455:53bd with SMTP id 6a1803df08f44-9121210328emr111288646d6.35.1789211149924;
        Sat, 12 Sep 2026 04:05:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120ef650a6sm44575746d6.0.2026.09.12.04.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 04:05:49 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	sashiko-bot <sashiko-bot@kernel.org>,
	stable@vger.kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [RESEND PATCH] mm/madvise: use folio_trylock() in the cold/pageout PMD split
Date: Sat, 12 Sep 2026 07:05:40 -0400
Message-ID: <20260912110540.3203010-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D919A180007
X-Stat-Signature: w1rmzyutp7ai6p1ekidfarhp5in1x3op
X-Rspam-User: 
X-HE-Tag: 1789211150-463672
X-HE-Meta: U2FsdGVkX1/51ID1+wID1rYA7XY9I/9leQKqOeOOYsAYKDKX8LRaa5hEkuFTx0FrWDkkRptsKv5cnrFtin2K5RMcs9PQvg0dR7czA/hRaCMqUszMmXQuNKOO+vkcYhIIGxoeKQENHVxMxqSjVpN1VBqIc7bY5Yijm3b66uicJyzG/V9Fs5Kf/NjIbauPe8bGJGWFIfjXK9N1eOjWrFawSaHQQenx0AeYxq/Rsuz3YqtUvmGcnAAgLg8jOkV4NeLzsaUGnh8a/uPAIDK3DvVTYZWoEyuQf9UlE58SBeoqDv47Z6Uk9PPB6I40bKvMlK2Ak1VtyblhXTnv+cFZIpno0QhHJ9BWm5RgAgRhhbykoBXV9ck+Myuj37Gh4U9ZQc8nDSO00IaVEhVw5KhUvGm6oFWQ6M3NDOvkVzJmt55PeP5xCqc0IAkEPpeYYKl/b8vodwflBvQFt3e1h2nfqnXuRR6sLjEqaJq9s7R7e01tOt7mGTmRpg1bbFrlljcIt1oPXCE9zDWaB3szCInNf4P0lKW//gJGCzMISuKFPJuf0b3WxCtrMZvDeT8J/DdstfntAZhh2C4jEQ7oFOosjHMFke/pP1G7zRlFWo3sKqWzbACvDXMd+xBCBWmXP9CJ81GqSRXaj8tUTXrASwjfRdUTZQVLL3aRS5UfzHPGjXt3oFuIzP43WMgj8nCswwoR0LSMUFoYdc+AKMgXK+xrn9hzhpGYrcix7CMHn8PvGXmRWxfUtedmA0OxOxx8pqMJh5ve0XXwsrGAnZvoHK3CN9GUP1ToIFF8SVi84XjkK2fW73Nj7/vP9lHN1XHIxs0QBMsZeN3aSk/XTnv9GXO/ABXBlx6aopgfDXsphGgKcSJ1EdXELlCuh+WA93myseRWHlfkKEsiXXHDH56evyKjDfLaMZkUrzY31lGG50b/VUpAH/NLe3MpDNIOQi+e8aofdFirDH872HfohgWSLPz6OuX
 qF3j2rRq
 BA/r7lX1S51Q+czCZdHbNGggve2eAb+ysUWs/AM9EYWAHgA2mA80LG+09uu0mahyip36mgp9mjbYBhCYHxp+qZ59F4ciWTwWy8O7d3pES0SG6ovSNTxi0OSwJ74Z2TZRGLnVF6YIHmWR9Q6NpV0iX/hIWu4qfoyG6dGIHnWH0noruuVJB8F10cWKmeJkZ4jjfw7TNz+s5fm0qpP335yr1+6ID5EbWzxL0pWcHX67c9BrLuFXtwijZ+kMDuZbGWbCNCdO9h1PAU3ChBtggxypKG0TYXzU9/rwxNonFKqqVUBw9VRXYy3sL/E/c0vfs28szQT3K8N43g9W/QvdEtXAkdcQc9yICzcdYA6t4N8r5KZ1rHWW4nkx450OfoldMpI+cM8z8iixWYzX5wqWcbrvpy6l2VTwzLXR/sW3uakf3bCmP2nWT1L37kTgd/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MADV_COLD or MADV_PAGEOUT over part of a PMD splits the THP in
madvise_cold_or_pageout_pte_range().  Two threads doing that to
the same THP create spurious failures.

  CPU0                          CPU1
  ----                          ----
  folio_get()
  spin_unlock(ptl)
  folio_lock()
                                folio_get()
                                spin_unlock(ptl)
                                folio_lock()  <- blocks, keeps its ref
  split_folio()
    folio_expected_ref_count(folio) != folio_ref_count(folio) - 1
    -EAGAIN

CPU1 cannot drop its reference until it gets the lock CPU0 holds, so CPU0's
split always fails.  folio_trylock() makes CPU1 leave without ever taking a
reference.  The PTE branch of this same function already does this, as do
madvise_free_pte_range() and madvise_free_huge_pmd().

Reproducer: 400 rounds of eight threads calling MADV_COLD on half of each
of eight THPs, re-formed with MADV_COLLAPSE between rounds.  From
/proc/vmstat:

                     thp_split_page   thp_split_page_failed
    before                     3186                     860
    after                      3200                       0

The short before count is rounds where every thread failed and the
advice was dropped for that THP entirely.

On failure the walker returns 0 and nothing retries.  The PMD path becomes
best effort when the folio lock is held elsewhere - same as the PTE path.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Assisted-by: LLM
Cc: <stable@vger.kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index f75a9d139980..ae3d7127d87c 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -419,9 +419,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		if (next - addr != HPAGE_PMD_SIZE) {
 			int err;
 
+			if (!folio_trylock(folio))
+				goto huge_unlock;
 			folio_get(folio);
 			spin_unlock(ptl);
-			folio_lock(folio);
 			err = split_folio(folio);
 			folio_unlock(folio);
 			folio_put(folio);
-- 
2.55.0


