Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49CA606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=coK6FDBj
Received: by kanga.kvack.org (Postfix)
	id E327E6B00EF; Mon, 16 Nov 2026 07:57:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3216B05B0; Mon, 16 Nov 2026 07:57:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD2426B05CD; Mon, 16 Nov 2026 07:57:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A44256B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:57:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D48D160661
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:57:57 +0000 (UTC)
X-FDA: 85440984594.17.248E2F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 45031100006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:57:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=coK6FDBj;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TsTyimfgSelk39crerZNvaF9T4v2I7XDePVLGlngt5g=;
	b=lRnJ+GmjLVaB8pyBhfuLrixwuPDtf5YUIeR6Pz0j1JDaXCg3g9/GWZcMb5reVheI/C0fDT
	uy+/cL3j40XrxgONifYXzy/PJwroDPkOdugKj58a4hQA6D6eVu5hVF6PX7USLBlCU8wjjC
	JsDQnFnpDuvpozS1G3quWYDh23A7d6M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833875;
	b=SWYoYphQaOihW8Lbbz5a0+85t82pR597hxJhGMp+LR9uaFdv0Hs6CtmCAl45d+XFL71mmd
	CEZHiuJnRZjV2wS93O0eTta15v0haQLVfK/GUsFNAt1n7vU6R0E6vI6SxZCegC1dr00Sd/
	KMPndm+hoOBjzHfbcOL4wuOOCPzjUp0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=coK6FDBj;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B1D340AC3;
	Mon, 16 Nov 2026 12:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927181F000C4;
	Mon, 16 Nov 2026 12:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833874;
	bh=TsTyimfgSelk39crerZNvaF9T4v2I7XDePVLGlngt5g=;
	h=From:To:Cc:Subject:Date;
	b=coK6FDBjSQCexsufKWa+V/+QvqGizRobkNju4/BIVo7zCXD9wskVZgYR7cN441tr9
	 qLG9xMnmLcNBqnEMBLW0ND8gAIjbFLFF3rWZ92rMgxHbyBCAdv9NVrMWF3eWTneukG
	 Ps4oFVIl2W1007SA32gpMyAcVEsn5XL0K0oYzaSPUAaydS2UvM34ghTvQq7aru8p3z
	 6iU/RjXau1DS7wFbjJv/s2o02MzEIOOzbRMoKe93fiEfETYwJ5IFfmZGWDDTFRaMRG
	 3heHXdqKLa1peWDnfn4EUnCt9n4uzKpXsVXF5CIxKlga6+2Lcv0rT2tEI6rwKzvyvO
	 Iil+nl87vvhXg==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.ams.internal (Postfix) with ESMTP id EAF451980052;
	Mon, 16 Nov 2026 07:57:50 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Mon, 16 Nov 2026 07:57:52 -0500
X-ME-Sender: <xms:zv36amM3gxpSsAWlJWbHuTzdT8oEiqIOhgSGmPo_m7Bud-e-yhOkpw>
    <xme:zv36aop6q7Qg2aRrEO9Ug5P5TPYUs56mIiq8s4K1y6RfOVg2VdORtbQZeB55WqR-6
    REQrg6iVpHY7saWDy6bo6CMSebRMjzaDUiA0TF7EsV9HIwp_pKs-CPN>
X-ME-Received: <xmr:zv36al52ymfp09CI53Jno0AXyVG5zawQrpX4i0eL01UXXyHganDPxu_N74g>
X-ME-Proxy-Cause: dmFkZTFkPa8woIDg/X6mZIuxiJNygpeOlX0xHBonwxlWn2dHiWS7GTQb73NJEmZCvOEauV
    y9UXL8D8o+EGdIeCqdLvB2MWcS/z0ptvWxocqauR+x8cK7qpd/IkoPzSQJVwCwfviuE1vM
    tGwysxRFG5mg25AQnzozv2olC3W7wkbTK8L2XQmvBdDGsYW8DgrDV0m4Xt9NJQaLjuEFem
    V0zIBT3OUC5OQoRGiQ8/oAXMtsNbzgSo4XZA+sXwzFC8jlfLuLfsfVtAC2dSg3x0HWVa7G
    t3hyak3PfNiaJZPUohnKhuju5/58WFjO109ixBJLnMykluVXoQCssPFXiQdzqFTIF0kiqM
    LqnR4tTmbm0GfiAuHnHBrG4gOp3PNqcfZS05DQkBxBINUUj8nir8FE5M8ZE5cevoBoMyu9
    HsQrUkUunJSj/aFvgAkH/wPptQ74K1echw7UaANuVfXuiE5PH0tsEWE+X/OgIAbKPu7clJ
    guRpHSoS8Z0PZDFjUgW179otp9aNv60AJoAlulsQyR+9SyZ1N2cQbH859Zx6z+7z0fkiJA
    fuWHpFjjoqAFZfoXCzi/GBBrkCuS3/eohMoJs7jBtrL+gMGc/2+je5m5MOI5lR9kFs4xCf
    dbhrMT3DElNmanAGPhWg3jQIEO5nbj6D5+AntpRmEPVIal2GXDNRuGruUfcg
X-ME-Proxy: <xmx:zv36aoEhterZ2mOfS6SxgVCKHNjSoN2XvWukChqmOB6h6gSpJyrAgw>
    <xmx:zv36av2xj4tiLyCoxMM0SI6xacgR_GROqlMRy76H3YkdTjzwouvsTw>
    <xmx:zv36atpVcp-nEieFurpcvI9TdXahifzEICzHiLOPLBfVPBA5watyHA>
    <xmx:zv36akP9Q7D9LBZf_LhZUariZNWLE05mxsISposr0XKVNMJmBOrV1Q>
    <xmx:zv36anWHIfc17rLCcSeG8zc17voFZ8MsjQG3JaW5ui6ZA14uJMFpOLwf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 07:57:49 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/compaction: do not skip the free scanner's periodic lock drop
Date: Mon, 16 Nov 2026 12:57:45 +0000
Message-ID: <20261116125746.2897395-1-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 45031100006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7nzupxuhk15kpxa7fqjadhkny7yptcgj
X-Rspam-User: 
X-HE-Tag: 1794833875-57744
X-HE-Meta: U2FsdGVkX1+RXnG5ZvC85dgWVVlJ1F57DAvpuyGPViJ6FhecYkT9mCdg8sufYwe/ynKVgy7vcHlruH4iVUoYv6h5nnf7NUxE+ciYCbDw0OBTKmKX/6NYyPMaGp/aUeTWnGZsw+3GBKOKhhleIqxO4MYnaQmcshmNLmdVKJWtTCPh5d2w/cWQwTi4OWH7ieH4dNRBLTU9lRZyYyvWM4SzgeLhKF7NoOk5V2XEn+XgHzhvDV6+hoE7RkM9BZJ+CvOUqfmP09M8hSM1CxQ45HFsSCoqkpKmAJnXRJC9xl9mLIqA5hggbDg8aAnkH1VX4gyS0vp8G6fISX4/UxvGyzA8OXEyomXSCaZ9S1wUdogxwK8NyvCi8slG/BPEY1C++S/2B7XFuzXjxzx+lQR4bPUzkdL9PBZmD4v09Vtrs9wLOMt/xa+hkQHuFFHghB0ViAbx/W35jeJxfiR4HFrf1GND/7Yxoqi8L4yiSScB90aHdSzjC6xH9FoAjxQxJKyAdso/VuWd43c8sypfDQ7ek+ib2lnjvqqsiSOEuxZMxPf4niXOH4sGhKVvHo67rfTLjfQYNZjYgWVhZJ9fxiyp1dQ1s4X7vtUmgOC9s5LtxPaOxxYqw/a5VnPcwE0LwdauV3etx3dOC/yalWilBiryiazUhSNexaussVI1L8Ax8WOX5SuKfrsce6bisu+6xcwN3n13Kb6RIUza0o2OkcFmCSKYmSirrlWBayNjy+4LXZXKx9V3ckzrRQEBJkyfvfDiUP21+SuvHqO/H2lpNlJl0kuOWws57sz4ZTzsAi0WRljpU6+aHBoEDJTxwzRT5lXcc5+ahIS0USRrjpUvH7aDqAUpRHX5YBPRc34DaKoVj0CG3PABbpHowO08yGAcxKgmiaDgWautgDqTD+6BMJU0BtVGnT3mgpvH0kdXAXSjuU9kMqn8q3g3ENA7Prk8TYCGCGSbuNwIY+oOm5lUrPrXyrg
 g8ZkVnW7
 jmfJIv3IOiWgclTwNVrjvc8cruaRpUoSygfF3KGAr6e9+HpXYyatwxroERuWG2edDqBvoe+atzhQArsFtBm2IhQXARej3onfIHK8nPDU0LjB4soGKf0MFI3iZESLQj1/T1gUDoNo3IvDlXPgsIl4xQWFs17U5oGgNEqjo9u+UgFLqDts1+ANPJN9XuqksYTLFCG/3Zl1VClQK0lWsRqtIFF95bt7g5Fr7ZkbNsvefi6a+U1obBUf1LktTq5eYp6u9ysFw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

isolate_freepages_block() drops zone->lock, checks for a fatal signal
and calls cond_resched() at every pfn that is a multiple of
COMPACT_CLUSTER_MAX.

With a stride above one, the scan steps over a compound page, or over a
high-order free page it has just isolated, to a pfn that is not a
multiple of the stride.  From there it never reaches a multiple of
COMPACT_CLUSTER_MAX, so the rest of the pageblock is scanned without the
check, possibly with zone->lock held and interrupts off.

Count probes instead, and check every COMPACT_CLUSTER_MAX of them.

Fixes: 4fca9730c51d ("mm, compaction: sample pageblocks for free pages")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/compaction.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index f1b2060eb201..4465c1551406 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -579,7 +579,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 				unsigned int stride,
 				bool strict)
 {
-	int nr_scanned = 0, total_isolated = 0;
+	int nr_scanned = 0, nr_probes = 0, total_isolated = 0;
 	struct page *page;
 	unsigned long flags = 0;
 	bool locked = false;
@@ -599,13 +599,15 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		/*
 		 * Periodically drop the lock (if held) regardless of its
 		 * contention, to give chance to IRQs. Abort if fatal signal
-		 * pending.
+		 * pending. Count probes rather than pfns, as the scan does not
+		 * always land on a multiple of COMPACT_CLUSTER_MAX.
 		 */
-		if (!(blockpfn % COMPACT_CLUSTER_MAX)
-		    && compact_unlock_should_abort(&cc->zone->lock, flags,
-								&locked, cc))
+		if (!(nr_probes % COMPACT_CLUSTER_MAX) &&
+		    compact_unlock_should_abort(&cc->zone->lock, flags,
+						&locked, cc))
 			break;
 
+		nr_probes++;
 		nr_scanned++;
 
 		/*

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.54.0


