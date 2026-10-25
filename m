Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7049606A31B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 22:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PBUro/bR
Received: by kanga.kvack.org (Postfix)
	id 2D0856B05B0; Sun, 25 Oct 2026 18:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A84E6B05B1; Sun, 25 Oct 2026 18:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4D66B05B2; Sun, 25 Oct 2026 18:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 968F16B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:32:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6CAA1405D8
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:32:57 +0000 (UTC)
X-FDA: 85362599994.05.DEE2EF9
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	by imf02.hostedemail.com (Postfix) with ESMTP id 30B5180002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:32:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PBUro/bR";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792967576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=f0CD2JTVPSKVQ8ahg/uzbIr8a3vhy8fPw66NRM5eXd8=;
	b=d9qQfQqdvT/6q6httx52g/ziiTkmqFWqRZWVFn1R4TfD89vg62USK6ynEVR5WZQvVd6Lo9
	dHo6rn9LWyEpNKpWA4C6MpeoVVRB2pbvAUe3I7bFtb/dcHVUD2shOhUjcwdIAbzryaY4CP
	wd+hRHxZBdRGVgDZVV8S3qoSpX+fAms=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PBUro/bR";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792967576;
	b=NXlLkUZkr3aMveSrQhlgprALgVWcDtZQoKlyyysJbsfw337Shn+p/nmZhk1PL3y4suYgio
	TSYOVW/WVkckmNKvQcGKG5QA1BXwZNdY8ELvx0pprs4UycY1t+M7EyX52xSoRFfg5+g02x
	CiKbLQC1ejp54qZXlkbzXOB2goyAdIM=
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-35cd538de29so1251673eec.1
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 15:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792967575; x=1793572375; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f0CD2JTVPSKVQ8ahg/uzbIr8a3vhy8fPw66NRM5eXd8=;
        b=PBUro/bRHTLzDDFlNid7MeijK8iruz8bQS55JyqSMgNCl1C8LHQMGDtWREwd4XVTPm
         u+GTURE767j7asvc0B/nB+3DYPjDAOxRcarDWVHwH602Ja1eSvMTS4bZRVwB5mhIgsw+
         idSpcZ8L5qxC3PgO6/7OfdxByc/Y/QNpjETd8xMOKKzG5XFHkeSfvCXjqqfMLqEz29Bc
         EHKS1p0r2cDxNH7TCgdOa5nA8Abn8UvoiLY6rM4wEraIwX40nCp8zdxs47W8gwvvkMny
         VoWE2okS2PaZYSaPRnARLPGVpKgaUGUos8E9+qPsJjCk/xSoekBuHNz8VH622y6YY9Oz
         u/+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792967575; x=1793572375;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f0CD2JTVPSKVQ8ahg/uzbIr8a3vhy8fPw66NRM5eXd8=;
        b=z3SrWB01Moli77xtf9evYjGJVLTX4m/v68d/POzbYKDK8UNgJIymplKqj4VEp9bUPk
         Q5FlTDoRoj3OfKrxpMGe2OkTzJZNf3b4mw4C80NfLpXV6Gwm4Zf5QhI9JZ15SoA+C/Wu
         BcRc7h4A3qnpb2TQvWF22ucVBuBiyAc6alhIX5ArP+VhhFl4DlwueVCqTvA5p1VEzBvy
         qZNzRfy7H+NXPe+yvubrvJiw+oWvBcZshzn80TfbY/q575rKlvgr0pAebpgKBv0gLwMS
         REUaKfygdPdefv5FBKIfZoVoDtP/noDvATwb0+fgVYquV0GVqm+KymHjQbjKE5DQa2Ra
         dj9g==
X-Forwarded-Encrypted: i=1; AKwUvBzdIxJ6KmksFMmobE0AtsV7thDlOv4LIPuwuQSXi6hllEPkG4xM3Iy8P0izXReU1nmly2YHrYW1TQ==@kvack.org
X-Gm-Message-State: AFq9FYK11vrKhpURyJ0Lg2KOgBNaapNEf0YmAtNaK02i24BuK2TiukFC
	yOVm4hxAJtn5tntNifYIInvEXx3mtcAuK6h7AdymnC6XVf8U9CigkPOV
X-Gm-Gg: AYBFou3ueg+aS8+6+c6/Rm3vFog6oqtfcp/1v19xsqmxBACU/ICVrZ1oU/0mdu+18C9
	TO8qnCBUQnFmJ/NwN7z/GEdGQXKW8sx4rt3dOdRSPAOjKlMi8wsVFqHqojlT70jQ3cYkF2lqE8Q
	WU3VQWKJtRQMMFYBovM9wOpJhZ1MSyhmM3gOX+rYAejE2UAj8ruIIdpPbEA7dKeDDRfy7+JzNaV
	d98KOD3Wm6aOwLiOUxpCrdhTd8JcQ54d2oovqLcarymjMPlPG8eY61rGsxnivioY8gpXxS1VrUA
	ps48e2qa15TFoTvRTJCrQ2zC6Pk9XgAIpJSi9dMHuvKm47Tn0AXpkDr06mb9t3FA4llz/THDd20
	1tiWLYH5oVVC6ZaFnZsRMKuVCb410hsf58r3pDBYdYSpReQbHD83OVlEOtzTmVver1eLFEh324p
	TocgF2NHp6xGLiTyrL7qrF56EIv9r29MmM/eFh1So63ayypQqh9r5a/n/sK62As4p3kUOGob+Ro
	CODl3CG4t4tLYAPAs5bhUliF7rM+b9RXvHtdgiM2jeEPdxh3wtzry/rnYrMRH+s9aWP4oLobQ0z
	yD/3x1U=
X-Received: by 2002:a05:7300:fb01:b0:351:4a80:d94c with SMTP id 5a478bee46e88-369e862a0d5mr7633319eec.21.1792967574632;
        Sun, 25 Oct 2026 15:32:54 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a026e04a0sm1943471eec.1.2026.10.25.15.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 15:32:54 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	andreyknvl@gmail.com,
	catalin.marinas@arm.com,
	vincenzo.frascino@arm.com,
	khalid.aziz@oracle.com,
	odys.yuan@gmail.com,
	sashiko-bot@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH] mm/migrate: untag addresses when querying page nodes
Date: Sun, 25 Oct 2026 22:32:26 +0000
Message-ID: <20261025223226.33740-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 30B5180002
X-Stat-Signature: ti8x8w14zpxzjrzy6qemrndz635jzqen
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792967576-366855
X-HE-Meta: U2FsdGVkX1/2mw2I4wvq0/QBDYzoMmO3RW3ddKttooA479iVXSDHhu35ubzMJAORPR055rg0Nh595rqLjXXxf9ylDNQsIU3sh3ZZWY0IElsOcN5m/pCxkL2OBN/MICRHjw9UZcBgSVvnRlGV6b96UrZBNWrn34rppPNXz/N224Ni/LdNxQCgvmCRAU84gJVRTj32jiraCkvyLfrBqXz5X2viQ1VI7VKz0qfjlOnjowDklLJ/9aib2vb6GMv+aXDZCzrtihsmfvKmDyL9J+kRiKtC0W6PhYs0Vt8wz3cBvFSFS2L0wyWDSPVhivEojV4S98Q0gRT5s/B7AWpIZri3L/9n4r69eY4MvNBF6Jd+/KM1uRPW0OuhzxWw91+uW5vOIYqrrcYc/tspvr/+JXZPKL7IHtzaN6BXugbbL8bcrEMGyUDU6Z9SXmZK4XTKFbkZ+e/SEiHj+gAP+1RkrfSPlcIKBwPSodEWpqkPInUdHHupOtu3QW6C3A+WQF98ebsAY1cdwifTUmLflHA8pJ8hIiWAApRczWOIpbvSM4to0Hrc50S+RpZtqkySqEsu07Fl+E/JgiyMtTfKaaKI2D3/3e2Ro5si+DOLdxniA6AMnQCtOPcBjKoCoQy6bg6xXiuGT06Elhq57xcaLoBGrI6kl5Bcf7UyyQck4C+JCCEkqDIPP+/2WwzHY9bcIDdGwX9NPvnrVfDhEvmY1e77afmuR9B7bkMKRUc4Mr3CUYmWC+2ijb792AVn3uNM/m+GxuyNmh/0eAETrHnXqGf10z2QyNLxfQWPx1wHojUw9GYtyarcmxg/nVpfzku/rzfUI3HLRp/q0WRgf9zims7WBHlpyysg4o+r67plz+SWNL6lzYQtYi6ceQr3wciXIcu75VhPcdTDFRME3FUoIMa7S9RIgr1fINNSfY81hkTZhyJG2weDjC0qTwPLpL4tcs4uPPs8P6foLmSUX8bGMd6GhZD
 KWNJYFr7
 cf+MRfUHWPAs3fmVbTq/A23bcZ4ruX7RBAITF1ooMjDa7x2cySrjJEIffyFIbKpn3N9pEaVMdxNv3UOKUHAVWd/3QlEOIvZ5lVA0BgG6UbuGhX1QMxERTqk3bc7IH0CPBDymjiif5zzeteu6sSS72SAN9QYnf7nguTYL77U5YTPmQ5ZqEPsySfo/dcymDvHNIsFfO4bhpniwBMkxL7WpTDwdwUk6qtqJN62sCXqqxWIf5ovIFYsHyr2fsqeMacYMvUSBCCWEfk5bg/uMLPtcEWRA3pKjiGoAyiTO8+qfj5/lrGx+PxuJpWfSaP73BXdOBQk38VEk8nT9e6TugGO2FXLVkIyfHgj/eHfyB+igA28w0zIKSYWd8KMy9gkG/AfnnjCWRUJCJqYxPP4INr9M7IDG8TcEh12ucBDrROyrQCRv4PzKoceBKdYlNKuovudk3c4vMhs43dCoFKM459ISIBamT/hxlO1rmf807dIdoG8AZ/D/Yytuvia/etadHH6TT/DvG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When move_pages() is used with nodes == NULL, do_pages_stat_array()
passes each page address directly to vma_lookup(). A valid tagged address
therefore fails the VMA lookup and gets -EFAULT in its status entry,
instead of the node reported for the corresponding untagged address.

The tagged address ABI permits these pointers, and the migration path
already removes their tags. Apply the target mm's untagging rules to
the query path as well, while holding its mmap read lock.

Fixes: 057d3389108e ("mm: untag user pointers passed to memory syscalls")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/20260721183257.706661F000E9@smtp.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 7e3a81f06974..994c78782a54 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2461,7 +2461,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 	mmap_read_lock(mm);
 
 	for (i = 0; i < nr_pages; i++) {
-		unsigned long addr = (unsigned long)(*pages);
+		unsigned long addr = (unsigned long)untagged_addr_remote(mm, *pages);
 		struct vm_area_struct *vma;
 		struct folio_walk fw;
 		struct folio *folio;
-- 
2.43.0


