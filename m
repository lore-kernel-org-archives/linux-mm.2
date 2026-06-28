Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34913C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 00:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2586B0005; Sat, 27 Jun 2026 20:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5C786B0088; Sat, 27 Jun 2026 20:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0D76B008A; Sat, 27 Jun 2026 20:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8490F6B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 20:57:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E56D4C153D
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:57:30 +0000 (UTC)
X-FDA: 84927508260.16.F2A7481
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 638F0A0003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:57:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQoWwsCX;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782608249;
	b=VYOtuPNBruguZgOJyU9frshJQkyX+cKpBkzxYSDOAaVYbNX0KnAf5i3ved/QRYLXfN60Dz
	n1ejePyisghxbLSYeMprqEJOgNtio8V2HgS6H1TI0BRFqAXBKPP89e9sM3pWZCHBeogCnc
	DqrHPjh7DdShYfgibikqmiENMqqEVkQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782608249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tznSpU7jKgoi/IAc701RjRwzUrhhlndb6N0yCpqUF6Y=;
	b=i70aT5rjPQ3uwqYv75fZ9wIk2w14sTMrHZgIIu+KhVsn8ySAdfxpAmOsj1i9pidlR3QECS
	lhzSvFZXHF6xAIS8eLtsYMt++kAXOmh2PNrZXkxT7kxkMtoup/aswfc3Bh0TQIIdVb0+xz
	azoxP7k02x9u2O4HjHt36+6uRKOYZLM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQoWwsCX;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6842443584;
	Sun, 28 Jun 2026 00:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04AA1F000E9;
	Sun, 28 Jun 2026 00:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782608248;
	bh=tznSpU7jKgoi/IAc701RjRwzUrhhlndb6N0yCpqUF6Y=;
	h=From:To:Cc:Subject:Date;
	b=ZQoWwsCX3UlTCy9mLO8MoRulCOcTI/rsGY6DC+7jYEDPeCSwHh3DuH6UUYn/qvglO
	 QeTKbLss8rNnaeU7rPAlafnix+x2kEETjfv6ZqkZfHogiEnIagnXH0I1FEVVrIMMhf
	 HzmndrWiHEBMFTQrKyHNCkgozfwLjTCNvtzjD8Q7+7twokBaA8NWh8dxk8dBE+PVcN
	 SLPWtrgdbrBfurx9a9mfbbpRmiijXXK3T0Uw0gQowPODmqJgobSD8x+36sikkGjeLR
	 ebX3SI80TknbXFhnECtX10/IvQbWBqpRjjcbslINxKkY3KLhGNVea6YHrac4Tbvb4o
	 ZRRkqzqVJRy3Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [RFC PATCH v1.1] mm/damon/core: validate ranges in damon_set_regions()
Date: Sat, 27 Jun 2026 17:57:22 -0700
Message-ID: <20260628005723.28549-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3kjdfb9rxfa6ps1uu7qxui8yu9xtwuwz
X-Rspamd-Queue-Id: 638F0A0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782608249-290404
X-HE-Meta: U2FsdGVkX19ZsoHBAJYh9idIpwdEUlZb5rvXuPBSf/AMieYc/hd9Vvudd0pI91eS1GVTGnp/Y07H2P2gGz7r4PXFLPiHRkv/TRE2Bu0WXgAesY1ZJZsy89x0W/T58ZsZGgA2XDxAyadyCpU0FMzq7tEdXXFetzJIN8XETKTpjNx1shyG5akLIRgVrtN5y65387n+WFyrllkB+AUBA9IH4X3fiouSAK4fgiN4Xczja39crdmwz+7nGxy2hWGfj4l3G0saVRrE7FPYpqEJNHtiT3wa/PHk/w4QsSQkHoY1OU5mVd8Y2ftvgzlPtFWafCIgWj5VwH6sxjy9TRIDD1ACM71Q9KmAqXZRxBWSfRGmsfehPsYdfOmERK/YQlMYThM6W0meKl64/LdqHoNoLhj4d2wU/vlQLU29+XKRG7Ypu/pbfbWLtl4jxHqWcQ+98D1dc2aZg7comP8VNSvZSxl067o7X9eCSkyjGzC9soKS7F220ZTS9FFyPIPcQnL+voBuum4UhKSA/6RGhpsBhIrepZ0Jle16VKuGNvf8kAsIM5DMIUdvJyE8zIyp2mNcPSrnL6t58vzKmFTwgNpm027b+OuOSlYOutdn7wjbgvHCfRrp7YnDd5K8yZYa8RzCTJxx1ZJGWxETp5z3v7hRjmw8Cq4bxmHLanul2VzDpaaOaV1J+nR5j+ZSMCgRJVm37bezjrkdNeZxR/lDY8C/PIixr390X7N8IRzrRPaBVozB60M6ZNYxPz/5C/NB+4V1b6j633S53dHtxGQZlBX8L75/gUZBjs5/aHEsyNKgB5IB/4oPugOatBvIz0Gi+nik9e2H8jMxoQQMjjQNwEwPMD+FxVmSeJGdmXvFDxu6KcWAsH8Gngby2Sa8vEScD/VnQq6JhO3Atn7PGfNEg2kD7oGpugwa5heijlBbbFb4Fe5MTf6rgjwnkEUDaqp0TQeAbq4jstOOfX4R/36+r9quP7b
 8YdwyEI0
 yuyit4/0C3w4gRw3+qlsJ+YVlmTOdmKHCTlbOgrJq4z1HODESEPUUoF5gFCVFH+qVBEUEDK8FKDNsraHwvpBER+aB3JWc8nUcAe84ZVPIjsHiSz+GpVp8H/uaqJEs146FXwl3KB2igu7/Uj0gE4cIGfdGjkcBEdhdc1K4xeAwH4H6qSl2CM4GPGGRs3qzhvyxz7Exr6gxVL7LlUyHNe0vSLCC58Kkd/uddgFLgJ17RKhotxy5jaNwyLGVxboHzUiZqOMNC3CCN/1u94ih9D4Szzi78Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core logic assumes zero length regions don't exist.  However, a
few DAMON API callers including DAMON_SYSFS, DAMON_RECLAIM and
DAMON_LRU_SORT allow users to set empty monitoring target regions.  This
could result in WARN_ONCE() on CONFIG_DAMON_DEBUG_SANITY enabled kernel,
and divide-by-zero from damon_merge_two_regions().

For example, the WANR_ONCE() can be triggered like below.

    # grep DAMON_DEBUG_SANITY /boot/config-$(uname -r)
    # CONFIG_DAMON_DEBUG_SANITY=y
    # damo start
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/0/targets/0/regions/0/start
    # echo 0 > contexts/0/targets/0/regions/0/end
    # echo commit > state
    # dmesg
    [....]
    [   73.705780] ------------[ cut here ]------------
    [   73.707552] start 0 >= end 0
    [   73.708452] WARNING: mm/damon/core.c:359 at damon_new_region+0x6e/0x80, CPU#1: kdamond.0/758
    [...]

All DAMON API callers eventually use damon_set_regions() to setup the
regions.  Add the validation logic in the function.

Fixes: 43b0536cb471 ("mm/damon: introduce DAMON-based Reclamation (DAMON_RECLAIM)")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260627170057.1867-1-sj@kernel.org
- Fixup the commit message for how the fix is made.
- Do the validation with min_region_sz-aligned addresses.

FYI, this fix cannot be applied as is to the commit that introduced this
class of bugs, because damon_set_regions() was introduced after the bug.
I considered making three fixes for each caller to make the backporting
on the old kernels easy.  However, the first LTS kernel having the bug
is 6.1.y, which has damon_set_regions() and all the callers are using
it.  So porting this to necessary stable kernels should be easy enough.

 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index d99f7a297fdde..df0cc699494fe 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -356,6 +356,12 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 	unsigned int i;
 	int err;
 
+	for (i = 0; i < nr_ranges; i++) {
+		if (ALIGN_DOWN(ranges[i].start, min_region_sz) >=
+				ALIGN_DOWN(ranges[i].end, min_region_sz))
+			return -EINVAL;
+	}
+
 	/* Remove regions which are not in the new ranges */
 	damon_for_each_region_safe(r, next, t) {
 		for (i = 0; i < nr_ranges; i++) {

base-commit: 7c001190b88a32f80c93a6ac302af59a9756309c
-- 
2.47.3

