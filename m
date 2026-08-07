Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B40B8C5AC80
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83EEF6B007B; Fri,  7 Aug 2026 05:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EFC26B0088; Fri,  7 Aug 2026 05:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0066B008A; Fri,  7 Aug 2026 05:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5D56B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:01:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0674A0360
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:01:29 +0000 (UTC)
X-FDA: 85073879898.17.5232008
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id C45F11C0018
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:01:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W4paKvFA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786093287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iG7BQOUNjluMUKJPYfIHD5r/Uah0YPlbWHQVgLWehtU=;
	b=kv6jKPCfc9fj0jhCCc3BD7PewH/S1SZL/IuLuT2wh89nOsEg/uwxdQE6ALeNOIfQ3ZbkaO
	uAJjOQLOBa0nhW/Tqs5wMn8PK/ftoUhvzzhg/IBBNyuyOWcHRb22aiWSdCh+5AA4BWol2p
	cCH77VZcZDPCVPbN+LQ1cXMDCPE4eo0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W4paKvFA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786093287;
	b=BZRmHCm0NfvJqxbGoe0I67eesQ0DoJV0V36BA6CAp/srkaNxp6k1yyszvrnxrcZudor3rh
	A4eUKBQrg2JsA6dDur+IgL94Jp+d0q8jOr0a2rG46Y8DpXZnIvBWtZUb9t28F+xKWWYKMN
	cgDweNz+VyyX04J/gvCXHAJJZcZ/sSk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786093285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iG7BQOUNjluMUKJPYfIHD5r/Uah0YPlbWHQVgLWehtU=;
	b=W4paKvFA++v1+lPM1ytHVfF0PZgUR7OB0TF6XKLapSuMujihGcrfh1cnW4DDbj0JgZF4hM
	uzcLPRGnqw+YY1zkx6ns8pfJsv7N2hXW4gK6iqyVohSLE+pv95PdLIOdAdnstM5ayQxb/b
	I+VmA6gxITBSkq9zeH/4MNwnK4FYdSw=
From: Ridong <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	cui.tao@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 1/2] memcg: acquire peaks_lock when reading memory.peak
Date: Fri,  7 Aug 2026 16:59:59 +0800
Message-Id: <20260807090000.1532495-2-ridong.chen@linux.dev>
In-Reply-To: <20260807090000.1532495-1-ridong.chen@linux.dev>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C45F11C0018
X-Stat-Signature: grjypp3ndzxjptjie668uz73d8ok5hqk
X-Rspam-User: 
X-HE-Tag: 1786093286-574622
X-HE-Meta: U2FsdGVkX18WgqriTDnzJDX6bEbdU3ReVIntU35FRw7VLAYFXrGMjHoPtaRdQaugEZbESWtJjuiGYNn2+Z3jiqoz5+NF1cHA4D8asEsCdhxFQmjVNV/QC0VewepzlYhGTMCRqrurItd9E4jd3sffr978uDPuMb+EdmQoULpq42SqftX1GGHnxzkHVOlfeC1fePqSeG2nidboatASC9m8jJmDXi+ZJ4ook7Y6RvxatP0SIfO8fCyC1YCPhfDtiJR34UGUstBxq2LW1vPYhSiOYhphuWIxgM0242g2dKOVb5YRZw9u5gue3HR45109IgZrvr7WkPC2ySffwpFHYtK+PmoNohjc8t5hW2rIiWGd+EMzqznfR7S1eZIdX5zzKbhgRcFf6ZvMO+JlvILO3Qs7orwxd6Rc72ErkI91vHz7iQzJkfv0XLN3NkzpoDBZJplHRLWtFH0i0x1ZQh4YfaPXwxZLnri93SJ9K00eb31yO3pvme07O5po1lHXAXmEANmE6gRhbdbpKuGxxLyhNrfyPUFoQbHyij429AXTwuvrmrBsuypxTPqqX06768UkolvnWkCCJ47Z8VZn/ZramP3d9iUCOuH41/tT5MWY7s6o4ivWRlXjHvOIX9dy4ZNIvXsUuBsfE1RUPqAEtVhp8+CMN514m8UkYxl32D0HntBTgQK51IL09O5uB8I3EWxaVBXQo+JGRqMd28dMVog/r197LgJjVIydtiJ6lXPLX5aVEXSIUw/56YE+BxPTmQQVi4XwLCqaI+MD/DU4S84irI1LnFt9TJcnwBXcloNdNxwHL2B8DKsiGgJAI8A1PX+AOfsqx5wGiWwBBTGD02Ws39NephYS0b1K4Qx6S73rYyg7TRRRzpUZtwr11S+a0Zw+ALRQBdCUTgdzrDeXESrEy8+8ydunhlVD/We77xaQbPSUuvpIGEwXT08neGfag7DIaOH1F+MmfF4/Qb87Ewlwqft
 tsdq8I3l
 LrVyy9B0B9NRdCgjxeIxGeMORwrFX+Glxwb4if4IZxS7dRFcBlCQfXE64nzP7+GPdy4u/05wUvWWRgVtFuhCKPdtfjspXcb9oOloehPkgzgbn/nRbp1WWq2CfzC2AvA9SI9rQm8hsUYTgmhlxAMEEcUCihHeiL1sIIe/rGkHdBjITo7SrAMynxVK1eohsADKIioYIRl5bMAOg0sbcPcGlLr2kgE9Ik5seOCTfGmTd9dcZ69itS5xUi4MBVXRiXi5BHz8Y5S6eyN4LqKEEr9FiP6Al83VlvMtR329CZmP+3Ue9WExbUK+VqBlJTAvSkjGt0EsYCQEWumkKB7zerG8N3Jvmgk4VLgAHSZcx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Sashiko reported that a reader can transiently observe a lower peak
within a race window [1]. peak_show() returns
max(local_watermark, ofp->value), but peak_write() updates those two
under peaks_lock while the reader takes no lock. The interleaving is:

  writer (reset on fd A)                 reader (fd B)
  ----------------------                 -------------
  usage = page_counter_read(pc)
  WRITE_ONCE(local_watermark, usage)
  // watermark lowered to usage
                                         lw  = READ_ONCE(local_watermark)
                                         // sees the lowered usage
                                         val = READ_ONCE(ofp->value)
                                         // B's value not updated yet
                                         return max(lw, val)
                                         // both low -> low peak
  WRITE_ONCE(peer_ctx->value, usage)
  // B updated, but too late

Fix it by acquiring peaks_lock when reading the peak, so the reader sees
a consistent snapshot of local_watermark and the per-fd values. The same
race applies to memory.swap.peak, which shares peaks_lock and the
peak_write() path, so take the lock there as well.

[1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1
Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dd6b1c298345..2da55b778ae3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4711,8 +4711,13 @@ static int peak_show(struct seq_file *sf, void *v, struct page_counter *pc)
 static int memory_peak_show(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
+	int ret;
 
-	return peak_show(sf, v, &memcg->memory);
+	spin_lock(&memcg->peaks_lock);
+	ret = peak_show(sf, v, &memcg->memory);
+	spin_unlock(&memcg->peaks_lock);
+
+	return ret;
 }
 
 static int peak_open(struct kernfs_open_file *of)
@@ -5790,8 +5795,13 @@ static u64 swap_current_read(struct cgroup_subsys_state *css,
 static int swap_peak_show(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
+	int ret;
 
-	return peak_show(sf, v, &memcg->swap);
+	spin_lock(&memcg->peaks_lock);
+	ret = peak_show(sf, v, &memcg->swap);
+	spin_unlock(&memcg->peaks_lock);
+
+	return ret;
 }
 
 static ssize_t swap_peak_write(struct kernfs_open_file *of, char *buf,
-- 
2.34.1


