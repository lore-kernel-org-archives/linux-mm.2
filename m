Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C917C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00F26B018C; Tue,  1 Sep 2026 09:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9026B018D; Tue,  1 Sep 2026 09:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE086B018F; Tue,  1 Sep 2026 09:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC3A6B018D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:19:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 274291A0406
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:01 +0000 (UTC)
X-FDA: 85165248882.01.E8A5A36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7EE9AA000D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:18:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ImCXP+vL;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOwz6J3a1XnteJ/KkvbDIvrqBi7xM/5c9ntF246FqLk=;
	b=VivvSSyFd8MmLafiIIQHcamz+95qhRI6oagU+4/R0AJOklg5bPH5mitMIw83TsCAz/vHsh
	fAW3IUTWNBjHKQfGA31brBNVcCAWQLQ3IPD6yJDeyN+rG01w6M9YCw0u+k8Il6rK47mCTI
	jYQpg3LRdzbO5/vtTbd9HZUijvgFrsw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268739;
	b=kzNL51SJ2MILOgxiNDBQaQ3DEzZmo6YH5ksyzuCiUSGM5mU7rlEB2RDEoxDFFIzQV3DM02
	RVX9JgL2LsAt+g/VN8cuMiX4akJxgkpmEJD6oSXc0s+S4zph29+q0SACnl7DPeoP1lx97S
	KHGSei7wfXefgViH3mjkXjjQrVNteo8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ImCXP+vL;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EFA360534;
	Tue,  1 Sep 2026 13:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BB21F00A3E;
	Tue,  1 Sep 2026 13:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268738;
	bh=GOwz6J3a1XnteJ/KkvbDIvrqBi7xM/5c9ntF246FqLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImCXP+vLdIt+iBu9YhsGSFkDJzHMPqdAqvr1BGs2r9lzIHNWddp/ldzgzxqepVC7A
	 2LsHoK3DeY3UZppt+5reS8KRckSjTSfrSFZsl3+z3oVIU6HmQfUsERKoNVn00SSqQS
	 thSg0yttFoUN9fDERmEMcsZoKyK8+rTI/JDQ+lCcZc3qL0APgOeBGri9kdng0STkdT
	 e78a61s2obsl2fuCLIfFgHWvU9OhmKQo5k9wK1A4WVn1gPMRhv9upfk+kBSYH3U/ZO
	 3CVedT1y6R8cchECkrprWBo6Tm/MA4EkIbREbDyAoW1JqD3ZBZ6wCEoBwELIcob3Nw
	 IVChnrKHCBBzQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/8] mm/damon/core: skip applying scheme if region split for quota fails
Date: Tue,  1 Sep 2026 06:18:42 -0700
Message-ID: <20260901131850.98037-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131850.98037-1-sj@kernel.org>
References: <20260901131850.98037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7EE9AA000D
X-Stat-Signature: e5bn7ketp3nmwrrhpmm3m3csgtw78t3n
X-HE-Tag: 1788268739-750093
X-HE-Meta: U2FsdGVkX1+YDbB5DoNxhYAmRcC7AtJTpb+PPhTyhctwXqYisZCL3Iny+l8/PAU38DJCc33lE+5D6cNNU824WN0UsuIR5mB1NoEnP3dN32css75GYUT/x89ti7dExfXrEHgBWK7QGKP5F3CvyncX/Sv93vHK7+4tdBwav2Avhj6UQXX3AAS+inIoUj5eAeMo27VfhatJCQsEnPE+d4ka+i9NhgR1jiOku9AbnPdHbd6lJkKGCncgy8CEkH17xM1AZJaSP+b4WJ5S0e/eru2JyjZMONYEyG1DGYFir3772/modXloVYVgq8Kp44wjwca3mEspUDnyvYevnR932tpdHH7+2/0y9VYg6w/LdBpgPUTHEu80WVjg5SWzlCfoSslaeB70tJytvrEjmmZmCk6f9u5a+IE3TR/SOv01tVkDf/0vsj8poWKWI40Uoy5tGUYUyIW1ZL35T7Qkgnmq02nVKnbaQrdkXmCt5zcIdpn65H5rBd4ZuJNYes6PT4KnlVUkAosYAJERCR3ysHQR/kwa7IIIHMadNAkP3PjSe7J2oDCzP/eWLQqWRSXLYqe3UR84tS/Qnv4OMNEQSfABY/PVfbTyZrCA9qHBT+AKkg3KV5eh4Um5VxmC1P3Lr5eDOP0iGJLYeFY/PcO4kckmXdVRj/tUofBnoNym642vl0nRQQ5hcRSqR3G0ZwwFxirvx9y6IktxKQHeolyoMQJyzz/4UqlF1LLq8kK7Dz/bXT+vZpRLpJSPNgkwZkGWgDjSbObOpr+9sy4E04RpOw/+Al9Ma+s2rFYDWbptzKBHqPFIqNSpqLx59lX3hlMtCPR5usCto0SXWNJz/HWON535S2T5czRPh+bIvsSDZPOPpGmbL8/QNFvAb2uheNaXKMgpBY7OpQgWmFIWgL08Ua/ANYPpbZQXnNuq6EATKAb/+JW8b4R5Gh8cKBAsO8zrEY/jvnvlgFKI6y3VDEeXzAYyeT6
 M8yUaXSU
 6I5PRbCwgQjpavOjgVzPx4LclgWk9GBzuomkjIOhEYPn1343khEF6ZjK+cK/cHYD3kbZFHMLzyT2+RIkyfgAuzoQsssvV3JgXgXxO/6c/l8U8IOLOSNcCeaWQvL+QhCp4HJLHPsQy1ihxwqI94zf6oWli1wY5zkLMXH1UKzFemgD4umMn3nzLCsKe3vYsMJBYNYk/MxQ812nWCwHsPu8sGmecCR+f7hBu/z583mGuPkgc0lk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_apply_scheme() splits a region and apply the action to the
subregion if it is needed for not violating the quota.  The split
operation (damon_split_region_at()) could fail for allocation failure.
In the case, the quota could be violated.  From the user's perspective,
DAMOS becomes more aggressive than expected under the extreme situation.
Handle the failure.

The user impact is not critical.  The failure of damon_split_region_at()
is unlikely since it is arguably too small to fail.  Also DAMOS being
aggressive is limited to the single region.  Users can set
min_nr_regions to set the maximum size of each region.  If it is
reasonably set, the transient overhead shouldn't be critical.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org

Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3f89cfdf5f022..a6fdb3068262d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2604,7 +2604,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					c->min_region_sz);
 			if (!sz)
 				goto update_stat;
-			damon_split_region_at(t, r, sz);
+			if (damon_split_region_at(t, r, sz))
+				goto update_stat;
 		}
 		if (damos_core_filter_out(c, t, r, s))
 			return;
-- 
2.47.3

