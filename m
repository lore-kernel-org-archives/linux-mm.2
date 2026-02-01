Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9262E7C71B
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 12:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB276B008C; Sun,  1 Feb 2026 07:26:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C096B0092; Sun,  1 Feb 2026 07:26:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4299B6B0093; Sun,  1 Feb 2026 07:26:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3307C6B008C
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 07:26:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E39D68C8E3
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 12:26:54 +0000 (UTC)
X-FDA: 84395811948.26.D8A6FC7
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 09D80140003
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 12:26:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="WpVI/XVD";
	spf=pass (imf26.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769948813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZwZ8lWYZ1YuosjYTvabOBDHoXCdZD0VZNoRi/PLmWs=;
	b=6iQA1R+VmPTKISqvnoLJp9yvwW7fkiuL6WuIP4EHAiBYd0NFu5x/p9kS25zTp3endh8kBk
	RS/eDboIbx+ikZAQeIfG8wktVU5eBnB6kYkaYWPa66R5b9nUxpt30rjfEFQ7H1NidTTNYb
	Jp2ILYqoXbGI0khhXCDzRoJ9L/hFmic=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="WpVI/XVD";
	spf=pass (imf26.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769948813; a=rsa-sha256;
	cv=none;
	b=A4KKT6w/MWlCLTFdgZzsr/GAMaQBXnlsnQEPN2bZTn2WDl168Xs7i7G8kMm/cXgxh933GL
	W+Cybag/5cYY53ml3PTH5HysKw3rvRXCJWsIQi9ZGnt/6Fr2PBQBIIyJteiuU7XjxC0HFc
	ZgXXWBF6PS3HXOQYW5NQYuMuiBVrkGc=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-81f4c0e2b42so1952661b3a.1
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 04:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769948812; x=1770553612; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZwZ8lWYZ1YuosjYTvabOBDHoXCdZD0VZNoRi/PLmWs=;
        b=WpVI/XVD4ZnSpOgwqB/jDVLPu5MXfyA0K2DHA/WeWTgD7wuM6YRrXPhV135ONbD+KB
         KWup+hrMgK+iVYPm8ASUeLXonUTb+012RAQ+Zndr2At0TTCtRZGc6FZXBb0RvmxmYqeC
         MWNY5SVCjco+k0DxwyyUXgeaFN0Z59NW/aRpCHEw1Q/7cHi5t2nC2VSbVvsxps1JM/gk
         xGCGKP81DbNjBQdKNJHn0p0eT5rn+0tsuNNzpWNKI2tbxoECZL8/rjjn8woXiVmR7igg
         4b8dLt37J+UZFs5WDG12dTD33Dk9TIvjzJQD2L0POWhPibUlKG/+eOdBCGOGTEcqh+s5
         muyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769948812; x=1770553612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sZwZ8lWYZ1YuosjYTvabOBDHoXCdZD0VZNoRi/PLmWs=;
        b=YGtcXrkTlZ0HbrcNOQQvpKh1E6T8PZr8ISth0VJrDjvlfYaPkx+yqr4ba0tq8Oaf8E
         izgbnuI1+Wf2bvU9wajGnaulAmFmVpenpsgbGAQSJJ2wk6s/kKxD8l8vqBi176H0q/cu
         KTSJg8vVV/iAtnW/sVvEOXvlqq6FHWHy0g7nUcJWwD7cfCSa/zhNaCTCiAx291jN2U0I
         66wVpU7Q1PtXmfptfa+MGGJGj72HGzIZipZ55AwkwBi1vt9cUWYG4SgEL2Ehsn3uKMaw
         ZD5QMuMHTYjFdVtNa9iwHN9xuNxCBNoGprQYAE9X9Mbv0ZYH5UZY6DyP/JOJRWjOPZ9o
         y+Iw==
X-Forwarded-Encrypted: i=1; AJvYcCWc3m88rpzlS0JHTIbG1nCJuJm7FSsq0TeDOjuPagZkow25T4a8PHfC01nB7eaTkFstaG62beybkw==@kvack.org
X-Gm-Message-State: AOJu0YxSX8ghE1KfaLrXCaLleqbmaBRi3Znt7ISipKvjMfICHkvpiDnx
	vVB5KCSx3P6V7tFh6Opihax45clXbCGpNkGDEFdEhGv3VcRucRW5fHmg
X-Gm-Gg: AZuq6aLgOXi8713LArnR1S/XtKywEinIE+4vXBtwDlPReS2wONON0AaleprtZ9Nfmcf
	hQjiAPOJf0qJNmo45STPqn2uxGi0u0uQpfQf3RSth03Wq0XWoTRsW/5Ahu9neZsAFVde/Fu6SYv
	qrWTzBk+31hcEnXbROP4uptSTjgM6Zj6CVWMIT1RzD49M9+BPsSOGWEv8iXxI/+13TT77sfXHlR
	5caxBCBiYn8k1Lgpog9bv11A0ltsxi4hLY+Q6PRueCiZjtQKxKBJ/hEXTX+RvtjCjW5pDj0ftyM
	UMXJJGwP2t3u3r0Rwrlu2qF+nqpQRg1B74HCS2CNcfBpwcLPxTub9ooPtHLLOYI6Ct+TKPfh/VG
	Y+x/T+ItRFrct2FepXQUKJk8czL/kOaBOYfvE9SIRU3M6V8sA470uvmeO85aiRoIY7egNIBbgjv
	WByAuf9QV4siRMmSF070lw9Rvt
X-Received: by 2002:a05:6a20:7f98:b0:38e:8842:6683 with SMTP id adf61e73a8af0-392dffda013mr9289237637.5.1769948811817;
        Sun, 01 Feb 2026 04:26:51 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b6e5ac4sm116941185ad.86.2026.02.01.04.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 04:26:51 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v6 3/5] mm: add folio_test_lazyfree helper
Date: Sun,  1 Feb 2026 20:25:52 +0800
Message-ID: <20260201122554.1470071-4-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260201122554.1470071-1-vernon2gm@gmail.com>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 09D80140003
X-Stat-Signature: fib8d6tqs6ppne1nf5kx6hsp4744tzhu
X-Rspam-User: 
X-HE-Tag: 1769948812-519679
X-HE-Meta: U2FsdGVkX19nnlXe3hc7gPhPph36NbXpcOqpf+/esA3OTIBrMv9RXrsIfHcIQQu152dRFTFuIrgMh4JnVjYOEDVzuMznzBNwwN3sP1zRh7erx1uWawYGtkmdyzX6Wf1a6AU4q9cM7wkg+/8m5CRI5uW7MOdPCGpWd1scXwdXEzw2bQERKDzIa2/zGCzf1gPNnz/LV2z09klHO9nT38QnjFKeQ9xO/APkx86RAQatOz4aQ0PKm/fQFJ+LUHY6BYo1Ju2CxNunVKEkyMSRT6rZW8IeBAjjEYilDnwuNLaqdwSdhsckIL7MQLb1q/FN4S2OwqKkbSD4VZj3AgAbxh76EB5E9+5mLPpRYVtxC12cvHjqhxjxBwBc4pKgfHw1vVJ9yV3MWP0onZjws+VAyx5rVQmuaYwPfO+xunkfMxDSusfWTb2aOXbsvO12jz5yDf4UaoyY5mkJfq5Lo5L2OpsjbGGEaeNGClo+JQxNvSJaNTuIZqlkE0SR4g+FPeqJmaYRK+wUD+CDdQRtCGxyXO7zssEPFnyaPwZoCm7JiJqxxZG9MhyrhQtlTmSzXR7sU95rKc/c2TUQNgtt61eIln2YS9zffsN94vV2/hUx8ihj06hUSYO0nkwPMluOMrphFCRvOvIdNa8nAINhLOo1EXMNEaHnrm5TKug4qGt2gJBiWaxdqqpRW7qqjodwyw4bNsnousCV9o39uQd+fxrNjWT6TDPZfZ1IS3E+QxYvx1h1637BJvOGIVHQinkFKib/TTdFaD9u+aNp48QBNqyY2KQP4na7nAX3Jha44pomqdPKSi6nkK/iYXZfMZfna9TkirTidzJ6fpZEoWmqWAf0lC/iNIh2icY7MzvkBqWlT//853DB044IZcyZtHANbpuBQSmNb5SAPOmVNh+nTpNj4BGvj8A3a1z+6v0rDluqYKo2bp2QXUj4SIyWsXjv1LXWscF2S3xdT0vHaMhKE8qtqsy
 wW3yz6R+
 v1ky5pOZhAMfdcd1CvF8vvmvMvKMq2sdrlU1c0SPxai3wmwLdYo+zsZ9+h3J9vBnAclmbPTbJON6DKH91FIAvrMMGh6Se28SCUJB82vIn4fmOi+X0vHZCMVlW04MUS+h3oVHtLCxOOM6Zxm7vLT/vGAWb6q1/+oU9aKlWZhJDE8RkJ+v9d+hvzlNilRuc2krQYwWFRSRZ1yvh9gPYQadRxINw9BH06/ERs9nSonwvRZDHbDOyD/TJmtn3hEZ4rV54FeyH5SJEUnH6WScu0UwE2FASF+6oa74KJfv4vMJXjVh2huzTPTM8tgFqOuZc1HsgE+A0yVLe9SaPWIzILXdeuc2nRm/NQrUxQyNpH74AB/1tO2xQ8S3/5QHBKu0SBrKcVTQ9lY9EgYZnLZC2szZysCbj06vEWJrMSKsY3Cmoakl439tVfg9CNd5Wg0w/6QnpJV7ia0k16j4SecXkpzRcra9Re8/Ds/gJSV8BeAB/6Q4ZRuE0yykUzdrzmNwnDdKKpk50v7rIrle6JFfPnaY901lCUhG7jq8QjOeezyRaLEWj6bvr76I2gT/KOSKcctjKE2DfH9n32PTpNYD0ZF327f3Rybc5EgMu7opvzINxVciLEZaLEUlACxetYBrbjHX8Y1aPz5lpdkWLOiIquuRwmFhiDUpqTUG72tEG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

Add folio_test_lazyfree() function to identify lazy-free folios to improve
code readability.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 include/linux/page-flags.h | 5 +++++
 mm/rmap.c                  | 2 +-
 mm/vmscan.c                | 5 ++---
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c73..415e9f2ef616 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -724,6 +724,11 @@ static __always_inline bool folio_test_anon(const struct folio *folio)
 	return ((unsigned long)folio->mapping & FOLIO_MAPPING_ANON) != 0;
 }
 
+static __always_inline bool folio_test_lazyfree(const struct folio *folio)
+{
+	return folio_test_anon(folio) && !folio_test_swapbacked(folio);
+}
+
 static __always_inline bool PageAnonNotKsm(const struct page *page)
 {
 	unsigned long flags = (unsigned long)page_folio(page)->mapping;
diff --git a/mm/rmap.c b/mm/rmap.c
index 618df3385c8b..ea55e12b3e87 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2049,7 +2049,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		if (!pvmw.pte) {
-			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+			if (folio_test_lazyfree(folio)) {
 				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
 					goto walk_done;
 				/*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 01d3364fe506..17d039bdbb53 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -963,8 +963,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
 	 * They could be mistakenly treated as file lru. So further anon
 	 * test is needed.
 	 */
-	if (!folio_is_file_lru(folio) ||
-	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
+	if (!folio_is_file_lru(folio) || folio_test_lazyfree(folio)) {
 		*dirty = false;
 		*writeback = false;
 		return;
@@ -1508,7 +1507,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			}
 		}
 
-		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
+		if (folio_test_lazyfree(folio)) {
 			/* follow __remove_mapping for reference */
 			if (!folio_ref_freeze(folio, 1))
 				goto keep_locked;
-- 
2.51.0


