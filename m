Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC7E606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Vt32Rsyw
Received: by kanga.kvack.org (Postfix)
	id 5D1266B05BC; Wed, 28 Oct 2026 17:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581A96B05BE; Wed, 28 Oct 2026 17:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390046B05BC; Wed, 28 Oct 2026 17:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA7236B05BC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:19:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66475160184
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:45 +0000 (UTC)
X-FDA: 85373301930.13.CC1D218
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id A512740005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Vt32Rsyw;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793222383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zcBSq0z/f2PFtUtjLoqIazx5vf/WTcNJyMg91Vl4fF4=;
	b=YiAvDQDygdpgJgDCu/kh47iazGiCItPDQvWh889nxFSJNjINAj5G6G8Z5xHb3mIdcO/M9E
	GDCPtUh8/v9kbJjia1HsZmzrsR/+6mUcSRfD4Wj4/7V5B57IG4rpC1nzUIAELGWXI6EtGA
	/lW1p9alOo0GYsPAGzDuni0bwH8yGoo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Vt32Rsyw;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793222383;
	b=YK3clRm4ZZjPP9pBpQBp6KCGXqquq7uIvyVTQ9vQJfRBQezBytBU9sSBYdXbwfHx+DLRIa
	bjwAcCDuSnpOnGL3mIangQH+otSIjl0qvu9UFVaddUvNy5HGTGWnDN5m8dF5n3A0s1IM0M
	+Z2qhIT6M+YLy8PkY4OFwutmExrlCic=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91bb5795792so16608416d6.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793222383; x=1793827183; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zcBSq0z/f2PFtUtjLoqIazx5vf/WTcNJyMg91Vl4fF4=;
        b=Vt32RsywUukpJANch35rME/UxdnFbJNa8vLKll5rtZ9gFUv3oHM9rJCFNOfScZC2rI
         m4gYYDsj8/NK/FKmlrYQjgqeGcGJQD6cy+Bp7ur4rscaF2ArUoSsO7egjZcSffCARQrN
         4ECzkhLf1+fRppVju+dfxb5CsGHwTtHWc4TicHs7y5g/3kq6R7CbEiKXr/AgoiO6YfpP
         hfwrwmn/Wag2sCtCYqi/Ldfm6gy7U9XCZ8tCK78HScxe3jhwISxHJFoJ4Y11X+I1qIdn
         SLbd0T6GgqPB0/iI4Af96+uB3MCvuFwlsfc1qyjQkgM9B+RSQPVXXJaeU6b3076RyC3w
         PmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222383; x=1793827183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zcBSq0z/f2PFtUtjLoqIazx5vf/WTcNJyMg91Vl4fF4=;
        b=AcVof9jckFg5EuGe0SErXgBGMwNEXpEBDXxUJtFgOAO8VU55zSFkrP5MQP+ZXqU0EP
         gSyewaXv/VUdGnipNS3mjl4vlQKT8aCJ4p/Dpa9t62zQfC6WZQjLKKZQqpJ2RiIQFh+p
         0zKYeT0ryhatio9r/L4oH6A/wB+Gb+KqISeYV/GGCafTp8nIsUF/189COoKjCNB3wXnB
         2sz9iW6rqKGWN1oQaNzt+O81nBJaKC50VD7WogIAezm62uhC3NQR/mcJuVo9uVkIJ4ca
         bmrENcXFvGgXW4saE6D1thQAHGQ6rG1Am7qsCk9gWSWR74iyXI2mybQXYYc4DxvWujZd
         eIBA==
X-Gm-Message-State: AFq9FYJODSo4uZaFcsG5IGRgFfKhKFbBCesVtuF4agw0DtxYkwES2U/J
	vecRxxChu67qUxraGGxlIYQEeAbvkC+iwB4eTQH6kXrRKjRONl0uRBiO/sVuk1szDlnaIOrZj00
	mDfvZFr0=
X-Gm-Gg: AYBFou3u6GWIj2nrWoU6LxNE1B5wLPtbDaqZs7pGs26ffRuSmmX9ETRXJsNzdb6e3E2
	z/yqeH5m12V2Bd0ugxZ1eLJQpDpaoF83Jn4B3ILwDVwhtKTuB1P+inw3Y2r2fwZKJr2LDTreYkj
	oFGHsEyJiRabqHU0DhCbN4I4+PvRN5YFbw5pwvppCeCCRF8u87K4poa6WMFbSVkndEuvwHHqFzl
	L07UDcv5qOMMEq0pVW5tKOE3dekOI34+/Ii8J+2UnXScJkX0N+v+DxzJtZnhQ/AV++TGClGXdEe
	foLzQ7yGk4sS+QPZkeOrzhYfT2AeEhe1tVwbXZUpt4zbkj0Ts6pScYWi5Sb2UBWPsNhu2l+/XMK
	JeJCX1umkKKOTUvAPDON0IZas9ZWGtPoxWmzLvzc0tiuy1ICvnX1M/WK2rwyTaFZZHYdzysjV1u
	ZpJmmzCZhTMpQVQFl+Y9ZXh99lGyiluzniz71pnaLnIuriJ9DGEP3lMSSddThHUmDUlyd5KQx2V
	JqZ7NiKIjY7/fQ0cR2qjyk7qQGW/AfOOQ5EeFDxxCE+qG8NjW27fGJ5siISqHtzjopdhaj4+oKm
	Yqu5/7yVXApDNc8Ct21JystCI+Lu1qLyNdoCH3co+mN2demEB+ZzWfROCis61i7u5PXu6Awqprl
	0N1ukazXTI8m5uajzO+41E12Fj+VxOjo5hgqA
X-Received: by 2002:a05:6214:21e9:b0:912:517b:844 with SMTP id 6a1803df08f44-91c7d1e7b9amr58841976d6.40.1793222382629;
        Wed, 28 Oct 2026 14:19:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6d598sm139778966d6.3.2026.10.28.14.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:19:42 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v4 7/8] mm/page_alloc: retry alloc_contig_pages() when the zonelist is rebuilt
Date: Wed, 28 Oct 2026 17:19:29 -0400
Message-ID: <20261028211930.3504634-8-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028211930.3504634-1-gourry@gourry.net>
References: <20261028211930.3504634-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A512740005
X-Stat-Signature: q1cnymujh6ehhb16jtfcgw7dnrc4ridm
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793222383-544111
X-HE-Meta: U2FsdGVkX1/GWP+9RzGfC2YpgUPUnutzUHnHOpPdBkPasJPlsti8zT1O1tW2gjX9s5cQExGTqgCZEow6V2GhoSbmoKKOlKFYizDD1kiivr2gzHYX4ZA19Jzv1zh7CEwLlqfgeEq26CZpAyvmnN8dtifCEmqak5h9sVq2I2Jkq9hz7TjUuyYrSfaHTfhCjm4nfr5OCNhcV2rWOsVGy7ekkvuHNfwUi8/LZ0k4bdur6BaGDvpnnYlpHNpOTuZZX/D+lKNFDwFfdt8nXJ5jROsDMAa6FUaqw7oUxcsjCs5YmcsurayFMW7h5+SXIFj0Ty3+lVZ9jjb4iLoYreqnTLI0oWusOJ8JSChwOoRHXYBtPufQjPRAoWICu0zuJ9SVORGN220jC9lOAPqV1QozHUCSIsuDg117ElOU3P0YpfYrSa8oS3KMaq1X/RB2iGCkVqBt9MCk1Z05/ofBuQOd4zxwIJ3BFhvjldWAWnbpEjwqy/W4evNbsrM8DesZBs0nZ+YAxwPsv2WSKD1E+U2JfnSzK+lMfilkISRdd5kI601wroCWQEr+i3b0lyZ3IJjWBxaL4UXPWHvm/exua2a1XuJtR4ztkEk4NG1mCAzyB6YVAqfAJW+7Q+xC4U8Va6zq/WwdTiHgC6C7I/0K5U0PILF0iUuNMAHlJsRAqQr41CgHvdz7TVHpHYY3DmiSVQPS6LKlhaZRPn0GJxViUwHcOWVArwEO8H71p11Vl8LZUJk5Cv2JixLc2sPuO4ruTUJtdhje4hV3KHyj9C3yEP3iYYbSr7gyWV+LHNmCNWhDm8oCk3ErZDPNCaHeIlDlgzofwECCq4LgUrbFYVO46dq243cMoTcvDTFXeB3qgpcgfrxaiHhfE3ee27RinRh5r1yUAAjP3PlFC09y1vi13byXOgfksB/dCu/eqrIlu/Oq3x5DHWgxFmL5/a6tkDazhKJFenCCCrOrXNoW8EeAAosVpQk
 A7XS37oB
 Kss98vI9k5sxFx+oQ97ZzeeNgOi51ov4+QrWB9HeWSnSsprL3EJk0rUrrpV7pAYH6NKdEJvhxu7TC14mnaCt+86/UbvVKM+5Xq/ehXxAJG/vHpZWPIn3LIxb2NJeJF4L1r1YuOV2TD2RAs76KAkELk0XwsBHPpQ3XZfIMtDMEpko/9Nd6XfSiY3BufjMdvhkokUWWJVbmDa4acto8BKDzW2/QAdx9pH4bz5EOgfK2q8Ud7ayMuJH7eOMnNp474gr1j6yO4E5Kki0lpXMsHxzm+DRPccjx5fcERfx9pqvPzjy/DW6azoNDZspoCAjizyLEmpnhHvWoCltiG4vbTstJZS+Dj351b0BzecxoalXs4m7LaKsDn8DSvBGhF3/jlHY6gxpKkR4+/7IkajUGzVLJtQ4qD3Xs63Ff+TiSdnAMUMMlUSEZ8VoX7llaJTRqBQDER8FC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Onlining the first block of a zone rebuilds every zonelist in place,
shifting the slots after the new zone.
alloc_contig_frozen_pages_noprof() approves a slot by the caller's gfp
and nodemask, then loads the zone from it:

  CPU 0                             CPU 1
  alloc_contig_frozen_pages_noprof(GFP_HIGHUSER | __GFP_THISNODE)
    slot 0 (NORMAL1) approved
                                    online_pages()
                                      build_all_zonelists()
                                        [NORMAL1]
                                        -> [MOVABLE1, NORMAL1]
    zone = zonelist_zone(slot 0)    /* MOVABLE1 */
    alloc_contig_frozen_range(MOVABLE1 pfns)

A gigantic hugetlb page can then land in ZONE_MOVABLE, and a nodemask
caller can get a range from another node.  Gigantic pages are kept out
of ZONE_MOVABLE since commit 79b63f12abcb ("mm, hugetlb: do not allocate
non-migrateable gigantic pages from movable zones").

Check zonelist_update_seq before using each zone, and restart the walk
if it changed, as the hugetlb pool walk does.  Check again before
escalating to the pass that may migrate hugetlb pages, so a pass a
rebuild cut short is redone rather than escalated.

With kprobes holding the walk across the online, the base kernel put the
1G page in ZONE_MOVABLE in 3 of 3 runs, and this change put it in
ZONE_NORMAL in 3 of 3.  Direct GFP_KERNEL calls with nodemask {1} and
{2} got a ZONE_MOVABLE range and a node 1 range on base, 3 of 3 each,
and neither with this change.

Fixes: 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 70830689048a..7d06c6c4011a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7593,6 +7593,7 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
 {
 	unsigned long ret, pfn, flags;
+	unsigned int zonelist_cookie;
 	struct zonelist *zonelist;
 	struct zone *zone;
 	struct zoneref *z;
@@ -7601,8 +7602,13 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 
 retry:
 	zonelist = node_zonelist(nid, gfp_mask);
+	zonelist_cookie = zonelist_iter_begin();
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(gfp_mask), nodemask) {
+		/* A rebuild may have shifted an ineligible zone into this slot. */
+		if (unlikely(check_retry_zonelist(zonelist_cookie)))
+			goto retry;
+
 		spin_lock_irqsave(&zone->lock, flags);
 
 		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
@@ -7637,6 +7643,9 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 	 * second pass, we will try moving HugeTLB pages when those pages are
 	 * smaller than the requested contiguous region size.
 	 */
+	/* Redo a pass that a rebuild cut short before escalating. */
+	if (unlikely(check_retry_zonelist(zonelist_cookie)))
+		goto retry;
 	if (skip_hugetlb && skipped_hugetlb) {
 		skip_hugetlb = false;
 		goto retry;
-- 
2.56.0


