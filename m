Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73765CD3427
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 07:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7986B0088; Sun, 10 May 2026 03:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BFE96B008A; Sun, 10 May 2026 03:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FBE66B008C; Sun, 10 May 2026 03:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC436B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 03:21:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6635140391
	for <linux-mm@kvack.org>; Sun, 10 May 2026 07:21:58 +0000 (UTC)
X-FDA: 84750665916.23.AB4A5B8
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf02.hostedemail.com (Postfix) with ESMTP id 18C0380003
	for <linux-mm@kvack.org>; Sun, 10 May 2026 07:21:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dK96UgTV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3EzIAagsKCM43887G874u7008805y.w86527EH-664Fuw4.8B0@flex--joonwonkang.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3EzIAagsKCM43887G874u7008805y.w86527EH-664Fuw4.8B0@flex--joonwonkang.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778397717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YaP+quwBLhPvtJZMfRsNtJ+XJuXs1GsFB2cwxZcRVVs=;
	b=r9GigKupHXyQkhyyp+YfuWTbsmHagpCfMfv/hjPVqpS6cLL+/ABAxya+VQFkvdsrlZhSNh
	T2maeK6Tr384o8ykFkoyBWILt2MeDDEjgkqXzThM6INfie1lgdXblmu+HV0K/D50ICacL4
	bLW8axpTkv7gq0E2Tqxm2aBQf9vlxbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778397717; a=rsa-sha256;
	cv=none;
	b=lgMVsIqNbXngS/qw60uuEBtSYY0R28cngxIj1xrrcirhxHyc18sddXpmzXw99Aa8DlEC9N
	mI3qAQYDTUwasnFkHZK/3shKmgJp2GcEempd8PBM9YpCP2C2JF1/ERdPAwjjBhMr01xTYH
	TcYvwZmbQ9vyThJw4ZvPKs2z/JHoQaI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dK96UgTV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3EzIAagsKCM43887G874u7008805y.w86527EH-664Fuw4.8B0@flex--joonwonkang.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3EzIAagsKCM43887G874u7008805y.w86527EH-664Fuw4.8B0@flex--joonwonkang.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-366122e01fcso3599846a91.2
        for <linux-mm@kvack.org>; Sun, 10 May 2026 00:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778397716; x=1779002516; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YaP+quwBLhPvtJZMfRsNtJ+XJuXs1GsFB2cwxZcRVVs=;
        b=dK96UgTVF5TkVqDPzSv32e2/YIYL1+OJCMytUEhCwI+npDI9wOiVYPyBnPfRfjEfsw
         U8LpVyA2h7ahxdzYzZdJ6X44/dJwpz4XjBjFkhOqVBQgfnD73v7Ru8N6XmWZReedqbWd
         LflSBQscI5joGfiLUlQwML7fGZf3rR05QM+f0CGkTBTbUmMOjId5hkHtssxr3SfKrvl/
         FGz0qylJSVC+c+OXMyrS0Z1FbSrC4aQOQl2uuO4354IZfx8+AaDKGKK2zk6B6TK6dOlN
         k/HNb+wqfTYiwhmwDC+O3xxpBsE8cJxV9kEHxGkdZzSAx4jRxYUaEh70k6xZQ4PHdIMS
         dbiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778397716; x=1779002516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YaP+quwBLhPvtJZMfRsNtJ+XJuXs1GsFB2cwxZcRVVs=;
        b=cF9JmXOQZFa9KnULxhfrCUnvGEJgHPUIDbXq8bLhaG4x0Y0i6oG/2Ba5Easy9p2ZVF
         1Nt2j3I88MSSDocd2BmMjZukZIzNrxsWlwBChFUqkGt+i0Sp+Ln3GojOUxkBUVdnOpXr
         3aLhm0+9GjmhMxObdT0ugtDbT3hdQQRvHZSJJsaUtNz5vN5VspP7b1JYLidS6YTDssSe
         HRuZDIuL7zMouLDs0yPN8Ud1eKI+k3xR3CwXSNxOjYMwXeh/DWH1GmXv19Rx72gKymnE
         2tBg9FPKQRL7T2A3A5IvcDlSRUyL7+JThxHa+/+Ryf3WzLnySJ/pcYSEVPDjarWLWkc5
         PRQg==
X-Forwarded-Encrypted: i=1; AFNElJ/0zI8r7SGW5Qd3i7D1YUBP+Y2iuluulPzGSu3x7WktGhURWMPUe90Qb//ecH+lgXlGhUcEyCCO3w==@kvack.org
X-Gm-Message-State: AOJu0Yy2RUFOcNn+zXm5UZOOJsYtsMXPOn+8Faouzi3GnDIAR5xCnzlP
	mHeHJ4fxQpfzZNdge5KRv63bsdC1ndPtUaVSmuxMtJuJCnKQrBz+bfmwcz8NNedVQdFtgrKPCt5
	zzJvC+Z3OqLgudomL8ZpM1ku9dg==
X-Received: from pgjx18.prod.google.com ([2002:a63:fe52:0:b0:c7f:cb0a:3b6b])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:338f:b0:395:7fb:9362 with SMTP id adf61e73a8af0-3aa5a90db5cmr21705561637.19.1778397715646;
 Sun, 10 May 2026 00:21:55 -0700 (PDT)
Date: Sun, 10 May 2026 07:21:47 +0000
In-Reply-To: <20260510072149.1279887-1-joonwonkang@google.com>
Mime-Version: 1.0
References: <20260510072149.1279887-1-joonwonkang@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260510072149.1279887-2-joonwonkang@google.com>
Subject: [PATCH v5 2/4] percpu: Do not trust hint starts when they are not set
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, joonwonkang@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 18C0380003
X-Rspamd-Server: rspam04
X-Stat-Signature: yo5mgp4q39smikx7edbnpbon7gr61kze
X-HE-Tag: 1778397716-993683
X-HE-Meta: U2FsdGVkX188OV+j64J5viRAIVP6wIT63sndpLEDnOcvay2o3C0wN6VgA+ghjKPU53aYGQhr/EpuM0BeFK3dmG1f+Bs/VCz/DY4gUm4NtwwCIouPyDXsANJLbQhtAGIZfqWQmGtDYhPG2CgjAV7thjhV9KX7QkbWG7XddJKc08+xkhK8mzl+XLYl+8ZhsFgKSRRBRTCsoDJCaKwVs7V5DVrRmMidSZroVNSDVlM9lrIa7MWChpVz2fnkQ+YEFYbcWnTx0bJJHe+jMMRTHXZUS9sAzyufY9uUuKlV9+PzD9WxCKHmcKqcSRROX4YYYt5w20+cc5WfquG4PVcsFICYi+guH9sxKKBqKAc4fKMeO1i1ZjZhEZ8waxRKup2huREUFNkQCw4eSoXD1H+FwgkW4JbWvvRXfIDCklpDSSQKplc1gKor+DhzMsc7RhPOoofKd0b9EYgdqaekRv6ll5NtLKRnrSSmXdcvl332lwZNtS1JhoQ043NorfIrYBRZjZdb9qOxHEPvuulAXyIMF0z0AQrLa4nOitvAkZMKfn948EzYDFJJaY/WSQWaB15WfCJ7KBtHQbabHoX+F78hoFLwjMuOpqaCn8ENW5Tk3afLNNbsLfUggFF0N8NIsef2+3a5Bm2t6AFKe6Mt4x+quD0i5SNMNObJasoueas60A1Rt9Qmz30br+a2QpVKAXiSkXECH28xoGHLs6SpqvGM5r2SMKf20jmTs5THQ+db9A06yeg3fPHjfXiavsBrE2mIaYbwYJU47bKjFrgXAWlKMqRhORPp+bjmO9oYJK2qulTvqGd+dpBGRsGk2g80OSNPT58ynPz6k5msdmLtmMxvWjLAQiGjsqf3ZZNL8tKg7goBEFo6wleHVLLliGgrD+NQs17ox4nFdSlRjFb/ulZ/VayhWCbyAOzjZV8MF7Ou6aLgH70er01OImII94SyA3YhT8S8zqyaiWVSPH019a2J5K1
 5oyZu2iC
 2+UzGsxltUteQFyc4mqdMNg0qVZCdD0thWIVfQa4OENLKThDPac5vo/UnahlSN/l6bl4MnJTjRquh2k1uudNoEqp0YdM3LJ3+MKM7o9Yb8L+yxwpAFWA/iYuDpOVgwU0rpqY0/hg7NhFnIuD0Xf1OZluo0AqNaYtCvA0DvlxGLdlRP483oI9P+xN8TLPivdN6I4VATFkcdaX5iaQ9wUS16pUxdEF6WnMBdNc664RY09ggk8vHMm/KCZqKvEi4MKKDHgpdLOt4ZlJCCmwx7FGTT9a+nWBgc8aPoh6c0azzXLsaZSWwq1952Ze3r9Ah0MhU+Z36rH930F3D4NJsAOu1I6J0mXDEEXdxDFeImcjWrB/ECn+gylwLnGwo12HaRK8YYOMOQoU6+6P447QuY6lMz6xtEv1pd/67SKz5++sqxCzu2ugBllsJMFtHfM3xTbJiGR/4P8CLqYoIO+YnA8YbOxnzmY1YXybQeUcB//kIqvDGUzCilDx464qyGM+FWw+yTTo4LsJOUQEql89U5SUyafPMp7EKK2fSGRBdtywd5O++XJcXUh+8c/DTqSe7+EPbfHjYjpKkyjxJD2PHg2spLBylu0ETVm/jof/cPh5CVFN/4XtatZQvA2mtO9O+qoJK44WM6E5g7FPz35aKjthhJi6X3/oX8p+dXmxsLRYGMeD/d8SlZRnfiVsV/h0RaNT+M8v5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

contig_hint_start can be trusted outside the hint update function since
it will be updated everytime contig_hint is broken. On the other hand,
scan_hint_start might still be invalid anywhere in the code due to the
broken scan_hint not being updated promptly. If those starts are trusted
when they are not set, it could lead to false invalidation or update of
the hints.

Signed-off-by: Joonwon Kang <joonwonkang@google.com>
---
v5: No change.
v4: Remove the separate contig_hint == 0 case and handle the case in the
    following code. Add more checks for scan_hint.
v3: Initial version.

 mm/percpu.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 3ecd86096641..0f6dd5260f56 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -640,12 +640,13 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 
 	if (contig > block->contig_hint) {
 		/* promote the old contig_hint to be the new scan_hint */
-		if (start > block->contig_hint_start) {
+		if (block->contig_hint && start > block->contig_hint_start) {
 			if (block->contig_hint > block->scan_hint) {
 				block->scan_hint_start =
 					block->contig_hint_start;
 				block->scan_hint = block->contig_hint;
-			} else if (start < block->scan_hint_start) {
+			} else if (block->scan_hint &&
+				   start < block->scan_hint_start) {
 				/*
 				 * The old contig_hint == scan_hint.  But, the
 				 * new contig is larger so hold the invariant
@@ -664,10 +665,12 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 		     __ffs(start) > __ffs(block->contig_hint_start))) {
 			/* start has a better alignment so use it */
 			block->contig_hint_start = start;
-			if (start < block->scan_hint_start &&
+			if (block->scan_hint &&
+			    start < block->scan_hint_start &&
 			    block->contig_hint > block->scan_hint)
 				block->scan_hint = 0;
-		} else if (start > block->scan_hint_start ||
+		} else if ((block->scan_hint &&
+			    start > block->scan_hint_start) ||
 			   block->contig_hint > block->scan_hint) {
 			/*
 			 * Knowing contig == contig_hint, update the scan_hint
@@ -845,7 +848,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 					PCPU_BITMAP_BLOCK_BITS,
 					s_off + bits);
 
-	if (pcpu_region_overlap(s_block->scan_hint_start,
+	if (s_block->scan_hint &&
+	    pcpu_region_overlap(s_block->scan_hint_start,
 				s_block->scan_hint_start + s_block->scan_hint,
 				s_off,
 				s_off + bits))
@@ -889,7 +893,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 			/* reset the block */
 			e_block++;
 		} else {
-			if (e_off > e_block->scan_hint_start)
+			if (e_block->scan_hint &&
+			    e_off > e_block->scan_hint_start)
 				e_block->scan_hint = 0;
 
 			e_block->left_free = 0;
@@ -922,7 +927,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 	if (nr_empty_pages)
 		pcpu_update_empty_pages(chunk, -nr_empty_pages);
 
-	if (pcpu_region_overlap(chunk_md->scan_hint_start,
+	if (chunk_md->scan_hint &&
+	    pcpu_region_overlap(chunk_md->scan_hint_start,
 				chunk_md->scan_hint_start +
 				chunk_md->scan_hint,
 				bit_off,
-- 
2.54.0.563.g4f69b47b94-goog


