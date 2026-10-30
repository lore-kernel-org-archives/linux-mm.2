Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30CD3606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=R+pDqDvv
Received: by kanga.kvack.org (Postfix)
	id 3A6F06B05B9; Fri, 30 Oct 2026 10:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3582B6B05BA; Fri, 30 Oct 2026 10:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E456B05BB; Fri, 30 Oct 2026 10:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F1E366B05B9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:43:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3FA00A068C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:22 +0000 (UTC)
X-FDA: 85379560644.28.1E2C915
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 48507C0005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=R+pDqDvv;
	spf=pass (imf10.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371400;
	b=gJ5ZzjDzqn9NAQRTQNucyqj54HTiAwkiovi2zeyhApnVoDgNqH3PpXZkCUrOlLMfwSkgdZ
	CZ9vkPO7xU8l69GrZacexnGiLzQZmkzbkwow8D8d0qx/7fgV0v6XDYp1oNJa9FhIsvO8oS
	NmUf2NxXIjDhOZHDfGuor2znKQCZ9bU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=R+pDqDvv;
	spf=pass (imf10.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZasR3muJYazSAWk5mMGHJbcwvrcAzT39vwrRu6K3+fc=;
	b=AFFoq4A+FKsCq4jHdU6NupIumx5MLllX9k51dvZ+k7jx5jhUyVannFBInFj7ynhjhZ9FDg
	acUIcetZIfwQQ28dKASQN0drR7k0xy+qdpNaz3vb6t25ArRWNuqS1CgL2JG7gUgJdlDOLw
	ihZW19zexG8zc3eQ4uszcQ/3Yg/xsZI=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a214af2076so5796915e9.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793371399; x=1793976199; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZasR3muJYazSAWk5mMGHJbcwvrcAzT39vwrRu6K3+fc=;
        b=R+pDqDvv9FDGY/V5wVcXezua9ExuD9/XLgBWtVbf0C4v52vt8ZMyiMmpFVdIoJecHi
         KJX2c2/PoAWtIQyXK07ljY0gLc57bwYB6gUtFheD2x0C8eVGKs58ljp0qloAVxdib3+T
         8ZXgbtzBxIsLoDQe3PMk9DRTYdsVd5uG0DXbC/cLurwCViBfUGg7Pttp7P//xskbku4a
         VlLssOHM9G2zCOztfgm8UskbM6ogT/s542M3p74mWtws37oPFhPZsb924WjKTlKHrlt/
         NK8C1o2VsHj+04A/2ezH0vgl0RlFUUa+xoegz9m2DjKb1Yp/2OPsd9CRs2T6+oWF0WQa
         0o/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793371399; x=1793976199;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZasR3muJYazSAWk5mMGHJbcwvrcAzT39vwrRu6K3+fc=;
        b=W4cuwUErU4ZTHM+1U5kKFTeXXhJIbReKMSSJkaj64rEWfNGG8aHVBkGZHZbHqR9xT8
         +Sur6MFT504jMxdg+BykTqMhefv42NP4AmvdqTrKH6uzIk8vG+sOl+6dnQiO/iz/GLES
         eG9GH788ZnwfMQONsNg1PkgxSHFjMWukkPky6S3LllxXZNe6iR7brG7V+wjmgttZPfQU
         UPxYRHhImZ96Vi8UNXIw/Qtx6N3dPsgu5Kq/KE5tKYiEA298e5VyMEgyyPe5Dgm4Vw0n
         xh+CteRWm6VRoS1TxPMaWorAwkyt75SSWj/nKTiqa2EWkp+7dr9wlRsqsT7cQgsVopmb
         cR7w==
X-Forwarded-Encrypted: i=1; AKwUvByf4iUFpz8TIxnFgH2Jot5LohmvkCbXN8IJ7+x0qROfCX0qPgU2oPRgcC+l7HwK1gXHPOC+39JByQ==@kvack.org
X-Gm-Message-State: AFq9FYIeG25T0cEQCto59ZGBg+o52tx68TGeWK4Ot1rzj7OcLbIo30rH
	oFDllwEJzbMWHgAVJu/peQJfeoAlNif1yPJX/KjBzDj6os+xMrgjxKvJmHNVmAtvLnGGMwbo4Ls
	7UYN5m4E=
X-Gm-Gg: AYBFou1fnuFWb8M2t4F05um5PonKLMBDG5eX0Quk83wtb0CvbxMbrxUQNfq6+RFVdzk
	s6VNQTVUXXei08ty03RW2dzLo07pTLyhvdn0dR/S3hymD6gqZbMdppJAgBQUAFJcFSBj24HlMKy
	nsCoLXHdRzRLy+Cb2yJXYl2gYN4zdasYwf/5IsvZAMjRw3ibOR6UYa0XXMUAlwYHi4WpV73d+yw
	T/oGXaTdSncsR4Kv6BndzAclqnY4G63/34XrQfx/hbGHpKk2uTjLmY6VadGBnGjV+nMzE4/LeKd
	0rFv+7orI0m+4NAR06knIhtwXsU58eqpG6oi897eg1tBY9QP5tfKQMUwKhSSaTSzBBH+Ci3JeBh
	jplyNCOqwfZHyUFRJZku8yEmoIgIk4jEULvIm2Gv0B7Vswitv8xAlXYSjadzskDRRxP5yLMKu+m
	u//UkVTAvkAqRbZTuLi0trqTq+7tNzElyfZK1GlrwmoqiWxLVy5h/HJcSnRc34rd6jHUe5GkAtT
	/NMfrmy8IQlCRi09/eJ/i9OpHnrmqOhvWbK+i8iixzmpgfwphCiXzvMQ/a/HnIOkvNmPcBHjYMF
	mOAnCy6Do3uh9fkyIHTsBzXYseyar25e7SF5WCacxq93R/jmvwqUJV9d219tRmAPQ7ab
X-Received: by 2002:a05:600c:c4a7:b0:4a1:efba:511 with SMTP id 5b1f17b1804b1-4ac18f52aafmr53516645e9.35.1793371398931;
        Fri, 30 Oct 2026 07:43:18 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf67aab10sm63518115e9.9.2026.10.30.07.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:43:17 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 30 Oct 2026 14:42:48 +0000
Subject: [PATCH 3/6] mm/mremap: reaccount on unmap failure only if
 accounted
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-b4-mremap-pre-split-v1-3-c1829811aed0@toxicpanda.com>
References: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
In-Reply-To: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793371378; l=1213;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=M5P1FA6sBnxYFM0rnVEtYfZSQ7xIw0BxmRdEEJ/JFKM=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QIpvlr3EuC8mCegm55MbHASHLtsVEPMQODDrr77dZkHtmsbaJc/R84cQEg3jFmS3LJZa8x3ygyG
 uiEyW3xkCvgw=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Stat-Signature: 7bbt3ce3gojaxx56s39679dks3bopp9g
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48507C0005
X-Rspam-User: 
X-HE-Tag: 1793371400-381047
X-HE-Meta: U2FsdGVkX18czOY3kjIqyqFbCv2qDz+/DCld9PsL/sU9aiYZoiH8AF6A2tRNA+AKN8roH7PQgpjXH+8LQZxBK7ofPUgA0YJzibRTcAHTFTn8hytjJOzXfyXouoDhXJtaRDxWBiEybFdt2OYwCPb24/7a1xXoDXIIqhKYTiopspuVzeC8c9b/PdcUEE+TJC7q0yDX2cdqf0Wge8Tga181F21Z52R6zvhtM4WcuWD5exk5AsqJ1RpiYUpSow9Qtbv4MgXdhNC4cVEmqWgo80wQtto27XQr6qfVH9xahalmsnTdWXY5Jl7mrNxPQLmq+IR0w811OneNQo5FcCtxM4v8xp+6KYzMgqD3204xjwEJrjWP1DqoNiB3t4U8G8zIYAdQCLvRjHwpvJkJmTBNOFtit1UgWu9ceMdV+Wc0G4wcYAsN9sUjawPvf7PPHdS6EG6W09HVMNTa5627iQ2B+hG/RpQ29Xqrm0em+7RjpxhbNtFFA01bBIPK8UJZUrbWsy9n25Dyt7reXmZeWHL4D3vBZswO82I5d6edvH7PsiwvqcammVaCmRsc/Rx0MP+rAgzJK/zcrNh/rYBWw2xjHyGnHpKClJNOCRH+gf2N7EppwHFC7nfFj7OWlH66ZajAnLpqbPIS/gkaQzaNQgbkfE7tPSYKNOLNGZTz1MTE4BbCqBJk8xguIqO67ymIuset4Wy+iQccu9ebgbvV+YVvYVNzF7WIud3uDbEQajshBAMSgsD8Kza4uUg+Eo9+LbsCSdYNQgz+pk+m7A4ohFZ+DL6Qu5ii19NeG2Ce+Q4h1+U+kokbB86Niv2f1aFqWx30K2yUR+8fYOQgZqYaNnuw/+4aAyP7tv1/v1R8cdFyWp6UFsiQUvf2lmosW5nZODeeUba9qhg5/rBcwzwIu058qPc3WNuvQDuXe7+vaLdIMuIPH1UEZTlCV/Bqi+DIGe+hIrL086u+KKG28GAu3s1oSrT
 TTLbXvFh
 fCMsklfqT4oJPlaJMIEfP9Gj7dXNQnHfdzCAjxkaYFEuby9IJRld87r0xCcvylGLa1fe1muwd2TCgETg339/9xXLPaWlCQEOPXb2lhBKe68D3y/eyV2yBgnQYc2vhCcjdFpinZt8J8IR8XzOD8u/uEYfj9QMAePjS5Cdns3y+1lX/+AkC5d0FNyW02rT5MbwdtnhfJSergTyDx+RCIYRcEY/wgdA8LXLTto0H8EuuiH+HGeLSvnhQqv+L1cetJSIw0Y6rikdNGlABHaQNCKQQVSu/fJnSD1HDuZGrHP2Ej3VAHKWH5sdNMhRbTW+cXOggDKcvvVkI8/cX6jM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When the unmap of the source range fails at the end of an mremap() move,
the length of the range is charged to vm_committed_as even if the VMA was
never accounted, for example a MAP_SHARED or MAP_NORESERVE mapping. Nothing
ever uncharges these pages, so each such failure permanently inflates the
committed memory count.

This was reproduced with fault injection: each failure on a shmem mapping
left Committed_AS higher by the size of the moved range after everything
was unmapped.

Fix by charging the range again only when accountable_move is set.

Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/mremap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index cf746bafdee4..6f941aeb1b5f 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1247,7 +1247,8 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 	vrm->vmi_needs_invalidate = true;
 	if (err) {
 		/* OOM: unable to split vma, just get accounts right */
-		vm_acct_memory(len >> PAGE_SHIFT);
+		if (accountable_move)
+			vm_acct_memory(len >> PAGE_SHIFT);
 		return;
 	}
 

-- 
2.55.0


