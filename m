Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EDE6E63F0B
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 19:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B296B009E; Sun, 15 Feb 2026 14:10:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403866B009F; Sun, 15 Feb 2026 14:10:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8A66B00A0; Sun, 15 Feb 2026 14:10:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 019176B009E
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 14:10:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2427D140329
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:00:49 +0000 (UTC)
X-FDA: 84447607818.23.6CBCA48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3462C1A0015
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:00:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yy5R6kes;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771182047;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xY7G8R7+P+8unP3fUZq69jb8WWTsjZw+fymYMyJMCPA=;
	b=XVXPlb3lqiNAEIfks8nGeFpDqafK/TwUPLA+HlldUJ8/C0xQVVFOqSTfvolx5H10DHdz6l
	w/jEX7N+t6kSjQnQCswuK/C6fJ5KCIvIdlJQ3tplS3Y44PV+vOaygyipfc3AS6Bqgo3dBs
	UXTC4y327bWDH3CD+O1DryAdLTDKHZ4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yy5R6kes;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771182047; a=rsa-sha256;
	cv=none;
	b=Rx36JbqJX/WEVcWejzR8aCig7GTr75qeZe/TNGlmNywBMuAbuJ4v8Ua6HALadWhMLeA6bH
	DFwD1cmBEVTTAMvQokDZujNDFgcgYiUy5yfOzOGMKNuwnPABHG2n1FUaTOZEx9dB7AE27Z
	lK9pbAGdzEwUVH3jbZvNdUqrhI9yGiM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 786C960140;
	Sun, 15 Feb 2026 19:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1CC65C2BC9E;
	Sun, 15 Feb 2026 19:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771182046;
	bh=wTK7vBuck4Wc7Ro9R5Mj7NtxqG8AwnxBtxe5boxsbpg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Yy5R6kesqXoXrKVqGCGp5zq3jrg/VndrjGUBKAr8JT4PCjKGWdbKMERn2zxgL2idJ
	 yP1B81Yw5ciDuiv+2g/So47K/CKdDRWqf0ZGGFmXUEHXcrf+OzSb2gvAAt4TQeC4NP
	 I/WbY9lXtMfGrnEYlVhcYoqECKhBxBh3IE6SDkk+BXvl2iCXIb4FawMc8kalGsddXD
	 ClY3vsvesSt5C2yOpuhsxXlr8D55ngbl0X95ENihFBBDSHoBD9wJAqPE+W5sU0g3AE
	 5l5LF3zTmR75OezDvm6ghrqACFv6PbduaalVm1nY+oGuOTVjmb2yQiq2AqxoBeUDFv
	 RbnpOGQAryVqw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CCC9E63F0D;
	Sun, 15 Feb 2026 19:00:46 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 16 Feb 2026 03:00:26 +0800
Subject: [PATCH v3 2/3] mm, swap: reduce indention for hibernate allocation
 helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-hibernate-perf-v3-2-74e025091145@tencent.com>
References: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com>
In-Reply-To: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Carsten Grohmann <mail@carstengrohmann.de>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, 
 "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
 Carsten Grohmann <carstengrohmann@gmx.de>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771182044; l=2326;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Er50BTm1CADsw8Sf6/HAwSuhm/4o2yVx7I3U3KWBPIc=;
 b=6R485nSU2o2bmlUPNO4K/iY50QRPl1rzZbPFloZdqJyaeo0dg917Z8y+N6oHRTJOmKCc6S34d
 Ve2gyLpXehHAoSL7/gdAVeYQ3DnjFmOPgzF2YvNccJWX9JFH6/o6w4w
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 4ye8yi66wbaasbkfz4s8eis839qbg4zj
X-Rspamd-Queue-Id: 3462C1A0015
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771182047-616122
X-HE-Meta: U2FsdGVkX1/RNPQHwYoCpM2XCxDxJajQBIB4ePs4Tnkt1crP7i48mCcxmH2638nfkEaaHrxKZO+9OGIyS7FJvJWjYGCOJR00emINtNcomeYKIb1mfEzCjIKlmwS32MhaXWgnjgVSe63FK0LEDm1XntWv6k2g6GX3ungde2Djj+ryHnqia1fJwbDf2HBMefqLRo7SP39ePkExIJFDFa8QpawwiA7JWFVbVWEolUF22wJLdBDUgQ8tRP3Dts8LCPeFyCV6xkEdjZazu87mxGtlx4NXs7mkwEW/lSeagqReRdd9d54xvZan/est9lnoQP3wmykkAMwBIkMUZ1xDbDHRlnfoTtd7Auy6GSTux31CWbGUtx4TraTpt4cGD7qu4ie9q2WMHaWuEUb5E6/hU2jz9ViOdbJfl5WcL4LJRr7NBlOaLcM5YgKNQ3WS+ztdXW9wQyXNNF5gekwJ3aJ03XSNlgKhsjuutjut0A32rSzmCTTOOR7GAyvIHZoATYVSnBepiEMVirtcRoyn44yWLjnG8g6BuGlWrbqaTuM00YWbGe9/0IPvd9pqTpubqz+0d6fY7GhJQ6FGhlHaLE5bI60ttWMqLBkHNd3v3bIMKGD539/c8GrgRVOfHUkKMalXG2BNv5aUceCdc8ItOCogvjpErUshI2V76H+plu2POaq06JP7PYDCr73QNbssVN9I/5lPeGUTr5ZX+TJ7wbfj584FbZWguwR5GyE7WjoH1aQopaS52jt8tQAQhSCuNGcUrdDCGW/CmX51GoiAkncQgqhDEzkquk0uwwz/s65fmsPqhePtPYNn0FuPuE//SZYQK4Qsr0jVf7oAA+EsffEoWR0gXjLkkuIICcCU/Gg0tq/Avi2msn3jtzjmgBmUuubYHLRrBVZoFBC4gEU6r1tjBbPUmn1b93zI8WbEscm6HfT2SiMU984qzMZdKZaQH+frJVa163b5hW2OQakiJnCbSvS
 fIAD4His
 PaNLi9VUzpF28HsR583XaReCcqlVgVvN9f8LRPpLQ0y+qfky4gyBEg4XuXCJGQXFby9GoxgYEVi8kB2HPbBuAcgpchHlg2ArvCNRlyp/y1jVHaNjm9hzuLJrGpEd3H0HmCYaNUDtPLTf6asGUkbkkHe5oIUPlxWOzlf7uEZHSObLJnkPaspGVjc42RR5vff2htVGTtmV+Es2fKMIeUhfaAmMXwkVTfDdfjfGILHpI7WaRqzSP/cUhP5N4bJ7/ZlVPvbZHHble47oQQn/DIVpY0X4PJTDKecUJN4KPbxiatX+yxtT6zWrs0QbC/J+2waXXlSyiZg1DH6Oco9Ut30j0VzaswzDr28R1cJ8olIIsnV8QpHvccIMluQqKkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

It doesn't have to check the device flag, as the allocator will also
check the device flag and refuse to allocate if the device is not
writable. This might cause a trivial waste of CPU cycles of hibernate
allocation raced with swapoff, but that is very unlikely to happen.
Removing the check on the common path should be more helpful.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 32e0e7545ab8..0d1b17c99221 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1936,27 +1936,25 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 
 	/* This is called for allocating swap entry, not cache */
 	if (get_swap_device_info(si)) {
-		if (si->flags & SWP_WRITEOK) {
-			/*
-			 * Try the local cluster first if it matches the device. If
-			 * not, try grab a new cluster and override local cluster.
-			 */
-			local_lock(&percpu_swap_cluster.lock);
-			pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
-			pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
-			if (pcp_si == si && pcp_offset) {
-				ci = swap_cluster_lock(si, pcp_offset);
-				if (cluster_is_usable(ci, 0))
-					offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
-				else
-					swap_cluster_unlock(ci);
-			}
-			if (!offset)
-				offset = cluster_alloc_swap_entry(si, NULL);
-			local_unlock(&percpu_swap_cluster.lock);
-			if (offset)
-				entry = swp_entry(si->type, offset);
+		/*
+		 * Try the local cluster first if it matches the device. If
+		 * not, try grab a new cluster and override local cluster.
+		 */
+		local_lock(&percpu_swap_cluster.lock);
+		pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
+		pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+		if (pcp_si == si && pcp_offset) {
+			ci = swap_cluster_lock(si, pcp_offset);
+			if (cluster_is_usable(ci, 0))
+				offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+			else
+				swap_cluster_unlock(ci);
 		}
+		if (!offset)
+			offset = cluster_alloc_swap_entry(si, NULL);
+		local_unlock(&percpu_swap_cluster.lock);
+		if (offset)
+			entry = swp_entry(si->type, offset);
 		put_swap_device(si);
 	}
 fail:

-- 
2.52.0



