Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0F9606C15C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oFTd4a9V
Received: by kanga.kvack.org (Postfix)
	id D40F86B05CC; Wed, 11 Nov 2026 13:16:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2D36B05CE; Wed, 11 Nov 2026 13:16:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE10C6B05CF; Wed, 11 Nov 2026 13:16:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 973316B05CC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:16:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A3BAA03B6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:16:07 +0000 (UTC)
X-FDA: 85423642374.04.E2FC73D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 67704A000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:16:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFTd4a9V;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420965;
	b=LHdEuji+2fTm6PaqdywG6s1N88ULIP+YMmb+RYK7ZQ+NmaGUjHpSbYPaAMIZlHicwmhjfn
	4tY+tI9Y8Znf9+y70k/R28ubK+9sOgb+J9mWGXU4kGv8lm14Pqzk46Uh0Xe5GWjatlgJzk
	p6QGsB9DVQC9PZq11urbT0e1+82MBN0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFTd4a9V;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHQXVCC9s15eyiaLxte2ARwnnlUvLG9Bk/OUsLlsEak=;
	b=cRHh4Hw93P0dkvrdh8YXjxil8M1ZctJACUIFl7kfsRqf8gkExKEudzY4VCHaVFK8q4dJBs
	6poPqfm60zOPsQwZj8EYzSjS33wmah8uvRJFWauXxoFg0HGMKmJ+mKOKPgtJriGJFmk5zI
	5fsomHKosmIfpCqtakUIPIdL7YqdXkM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 010C962ED5;
	Wed, 11 Nov 2026 18:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A861F00A05;
	Wed, 11 Nov 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420964;
	bh=gHQXVCC9s15eyiaLxte2ARwnnlUvLG9Bk/OUsLlsEak=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oFTd4a9VLa/XwtT0kQxj7lvpK4i/1fxXPbecoEMAvVIDgYsMPTiVKKBucxg2HEYFp
	 wUyl6A/5anWyc6q5NthqrAV2XVkBI2tS+r++2MosPsBrOU0VXDkao2WN4QHTgYerij
	 uXQnryga9lfBQn3+lg59uiJIDMRijhwACUOOz9XE17Hf6BYwM/3a1zN9MTvIvuWJzA
	 40rswyF/GfrH8DmaYzkUvpMfNbw6Hi2WONuq2sI/BC9FnhJe3L+PhzZsNO49s8u9Qa
	 Taa5ZzcPou3juDjdpjarC5yG6d9a//zA8fZtrkM1emoNDeCmrm2uenAAkzvtLa3fAq
	 Qj54gU8+Gb1VQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 11 Nov 2026 18:13:26 +0000
Subject: [PATCH 12/13] percpu: search the whole reserved chunk
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-mason-migrate-et-al-fixes-v1-12-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2037; i=ljs@kernel.org;
 h=from:subject:message-id; bh=NPnEzGMSeLqUdofRcE8Jqf5+1JnDIvID6zGRo42zLpI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+bMgRf6apwd2T+DEpp6PsRke1ZUEeB9uMRV8+iW348
 tC58bp8RykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACaivpSR4Ub0pGmOiwQvnmKq
 FSlb03lbp2vFp+nlxZFMl4M3Bck33Gdk2KB7gfv2mpsyWQ5XhX8Wx0bl2PRcKXl76HTAZdVJ3Jt
 suAE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 3tz7xz1oc1ew87nuj9bcjmrbudo4md7r
X-Rspamd-Queue-Id: 67704A000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794420965-728231
X-HE-Meta: U2FsdGVkX1+Jy/8/bmnITx+toNAz7ZUcOuYWeCqp4iVqDJsvvwFWV6jJH8bXj98w8ArrF1YSsNf1i8ysQR/P6hm9bgSl0D52aEggX2PLiBix6SJMNMyPA7JLczz6QYXtamDSKFz0ddUCUNr0POiyRXGPY4bgqyfkylM3CKVVsuI7GudSCgC1xDkzcMhikqvANQoWRLUiJPmAXHhrakGAvToKvSpoJhr6h7Ch+mJHu+KHN8//U31TXL/RYWQdK572LWThHl0VLJ6NfwNCG3BJK74kjLS7aApgf4iqbvGa+Ewkofn7vSCNrwhWev9HTq39DJYUuBNhN/3DnDto1KvM+i1LK2bSKX7s3ppukuC5iX4O19PpPOGFyvNFUb5CxHPggB8VobJm9okQRd7HNw9A4XPrfYrobap1hTuCxEbuT9CxjKwk+k7mnhwKS4NGMc8hDW5svkxCCgXpt1eKFaFdTYIWQGA03g/1ZyxIRY2rUd08fNLfUN4RQrJy4y7OXgF3Js0rid3eCQBsK+12Y1ZoA7Z1TOc2EeFcuaviQSLL3jiR1Xa3f127WNJwJXxVG8W4VhFp/564yOMC9sBNxTVWO2LG6lqJ1onZ7msfvF0OYwq7WAmeB9kaU5xE9IOISaEw3utrrOT5/ApuJgRRLV+VL7O3O+wt64SteL9AmwqnX0hwDLon/AVzxtrHqNpHCa+OYfiNrZJ3JGyShQovjs6qKtnpi/qlzt8DvubqJ+sTppWzDxn344tBdvboGivrCE1VlW2eJq1GxL7DoNBUnzIDd4KocwyQaNmjup+4VARIpE8uuhqQ2Ct8bH1Cf8RC7SVPS3VOLhRQ67dCN4whE7zbewhB3RV4drUGLt+h/XGvu0pBG1873pRA+Y6RkTZyJepRQY7FWZVIOuCUYwzUmyygny9ZiOoMQd2S1E6sDKKod8bgLIzhgfEhAqKA0Zn0WcCUteTTmgkT4Dnz3DVimQV
 6D1e2w00
 1K5RMWwNMp60NcM5+ZXEZ6ISatx4ibsdrnSawLH6wGy67dgnXko6Hc9pU9V8GB2lqoP3tvA2Q6y9hlxS4Uh/LlFDy8C3Lc03S00WS/wEYspiT3s77d3YQtze+SV/mILMIrMdaLFw6gc6fnU2IXg7gzX+iAnx/Mcqxl4ft9QTsWw9w/Ux4b5pCj/qcr0SlY8VGZLd4LHDvAuiKqPEtbNURlYnn2a/sUf8738AmQsGJpw3QMVUq9XsRLkkfiiySezhzQKAzbEdK+Whv9vazX1B1lvVd7fRLnzP0h4Stbk1h3nB07iRfHk2cQqNQdPGqDDC/Rhd+Ht7+64D8M1hjSsTfID83lJ6kko6S0S4+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Loading a module with static percpu data can fail with -ENOMEM even
though the reserved chunk has a free area that fits the data.

pcpu_find_block_fit() does not scan the allocation bitmap, rather it
tests the request against hints, starting with the contig_hint of the
chunk, which describes its largest free area. If that area is too small
once aligned, the search gives up even if a smaller free area fits.

Consider:

    request:      256 bytes, aligned to 256 bytes
    contig_hint:  260 bytes, starts 4 bytes after a 256-byte boundary,
                  so 8 bytes remain after alignment
    also free:    256 bytes, starts on a 256-byte boundary

Ordinarily this is fine as the allocator moves on to the next chunk or
creates a new one, but the static percpu data of modules can only come
from the reserved chunk.

Fix this by searching the allocation bitmap of the reserved chunk
directly rather than using hints.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 13f966373f92 ("percpu: skip chunks if the alloc does not fit in the contig hint")
Fixes: b4c2116cfae6 ("percpu: update pcpu_find_block_fit to use an iterator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/percpu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index dfd3ff0a1ac0..f87813e6ad73 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1771,8 +1771,11 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	if (reserved && pcpu_reserved_chunk) {
 		chunk = pcpu_reserved_chunk;
 
-		off = pcpu_find_block_fit(chunk, bits, bit_align, is_atomic);
-		if (off < 0) {
+		/* No other chunk to fall back on, so don't rely on hints. */
+		off = bitmap_find_next_zero_area(chunk->alloc_map,
+						 pcpu_chunk_map_bits(chunk), 0,
+						 bits, bit_align - 1);
+		if (off >= pcpu_chunk_map_bits(chunk)) {
 			err = "alloc from reserved chunk failed";
 			goto fail_unlock;
 		}

-- 
2.56.0


