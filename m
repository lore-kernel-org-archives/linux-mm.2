Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7598E81A2B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 14:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1169C6B0092; Mon, 16 Feb 2026 09:58:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0FB6B0005; Mon, 16 Feb 2026 09:58:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDE056B008C; Mon, 16 Feb 2026 09:58:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5EA66B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:58:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 866871A09F0
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:58:10 +0000 (UTC)
X-FDA: 84450625140.17.AB19BCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9DB52A0008
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:58:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="l+Gzv+/s";
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771253888;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfzr3LW2Q2TaUIH+Lq+oGW13CnmeXlAsUx9TPNgc7AE=;
	b=RxV/zSjsJ5czI16w4Joj9SvgR08llCVlQfRno+HPMEz5MbZniOavQaDX5Oeeh5k3vsGNNC
	QgVhmKb5nUGA++Ah79GQ9RVBCNi6cldBeJelxiEyZKdQlYjWIs025Sb+EN1MvHM4NXdgmw
	IVicJiTBGcYbdwm9rJJgNwYEjPBY7Oc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="l+Gzv+/s";
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771253888; a=rsa-sha256;
	cv=none;
	b=2qbNGHBdVU20uVsqi/yck5PvNkj5P7k2byn0YSzwEn/wS0vDrCvEuyFWstrVRI4IgIyCh2
	o73nMX2nZUV0MsTZAzu0FbBDih0bvy11diU2k7edD+feivmC1UVnXER+QV4iiof9qIzC+I
	CsJhUIlrl/7luC6doCIWOjmGJL3zYso=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 19F856013E;
	Mon, 16 Feb 2026 14:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB19EC2BC86;
	Mon, 16 Feb 2026 14:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771253887;
	bh=myZyOnHzp3lPkDV1e/C2uP7wr+40p+PY2MQZBb28QNM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=l+Gzv+/sQQ4gp2ucvDPntyFzntvJ9KJ0ebymysuwtN+qX7m7zMEXm3MMn/AalPv+E
	 jSEzV2n9MICzI1NIzmO8o78n297/bVF7g40z1thhSU9uTSz8wEluVywhNKGPPO5nLu
	 +KctywZ7ENltWgIDQXhQOB+taPHiBPtSZ+u6TqrY+egBC/xfSohDZIAuQXrJQH1EIW
	 wTCqr2oMh0vRwdhZ2cnoou0aHVW4h4dlvVHBBIZYIHhrn9lyzLmx/N2tcpyEfAS1BZ
	 rC3zOMX3m/ctsyCQfph+WAuANsaHTb3fEWJwS7nJx0llHjelyCJ+1x9AMT8UCIOtRT
	 tschDypbqiasA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A823BE81A28;
	Mon, 16 Feb 2026 14:58:07 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 16 Feb 2026 22:58:03 +0800
Subject: [PATCH v4 2/3] mm, swap: reduce indention for hibernate allocation
 helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-hibernate-perf-v4-2-1ba9f0bf1ec9@tencent.com>
References: <20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com>
In-Reply-To: <20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Carsten Grohmann <mail@carstengrohmann.de>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, 
 "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
 Carsten Grohmann <carstengrohmann@gmx.de>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771253885; l=2613;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=NAvqyk1BCM82J8HW6Gnh4CX79o/hdmbrD/B6Y3rHXiw=;
 b=k/nFxKLOf037gv1sMhovQ1z7Lzzq5b7SFtNWk9LCk4plm6mzv2JlgbNEHqsWpL6ecmjVkQy7s
 lmvDhThxszvBx4B7SxU8s36kT/fNDml41igu0SWj6EFXOnsA1XxehU2
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DB52A0008
X-Rspamd-Server: rspam07
X-Stat-Signature: 3s5nwrrk556d763y33u1naygttejrp6h
X-HE-Tag: 1771253888-66773
X-HE-Meta: U2FsdGVkX1+Fo0SZSQcaBuqXvdiA8GPIjka7dF3OEiq7qB+lJVYImqbceM+2YEegFSbC+tzK7VKu69IQ3TkFk/rmEbnX6O9KqpAgSBiYFpxP8jAes2wVt7vRjrJ+eobfxA+sONN7Bj+Zh7eVOQH8Uw7C5zrD259U3u9DrxvmDtpf5prHxcsNHChuLtK+CQAB2hKPNORzNhszlTafpNoN6hBRpUjXSymHjckYa89cgZ7ktg8wBU0SCFwddS0xnLfFBC/dO+x4iRP88uqENFDkjIkGi5xyx7GMzLx58vYrnomO6T01siOCfbTtOeBVA3E0Ur5l8QajGs1w8LXUiHu5gdbKtiY8shrAsfyuC4KDf7/fntPyU+a/DQjTzT6u0sTEV6Nv2H/YoJmYJUfRDIshH1CSJYJ/Yi7ydyuyVNW70RQqcpQtiXQVUxzhgFaEPBgCBf9AfbI/TpRNaJzJ3YYOi6VNUp5eLUsYe87wI9pBa7XLaBEJ8rn4QpvsZsEaqHEmDIZ26A4UoWUHhuwO/6eZv09G6x/OrEnATEI1bHCdt2tF7t31Lyjnv+2OL0jSgLlQmPmA6QS5IYxon7ztMsgYAcbJ7A+H443edaXvYLZLDzuW31WWpgJpmgqZaTMzXIdZxiUQ/ojtHl9f9i7KRw7oPNTTyvII7u4AuVv6inGLU56QBcF3zy1QMPuV5m7UyEJ50P0OYAf8gPuzb8ejjWZmeeTPo3J2bRaIhx2/0z43hWQvWLMxPH+AQi3CZzjSi1PlZccbO9GrmZDweIIx2wT+z5v/tbAMvLArjvVV0WEii6g5G9qSuBA5RLZwoE3SararjIgIhfdfLJNIIlMgMIbTEWDholwhWMryGE693Vu+SIybXKSK3R2gTPEPJvrGtAMN2Z/kSQlOU83TyJHf874rCnWmfPyKk7c5qXZj18/DURm9ycUi4I6jG5dIrMpJL9lwthfGu0Zg7Q3yblwed8G
 btZc0gUr
 vF+RwpVyaJPS42Tlc5iDPMeGWOBhd3xtrDAHxuROOFLbgwgca+JRDmZQGmTe4jnV620Yo7yFPhHDnct0XaJkOzL+l9IG8yS0whL9vSyImKYtox4gx1eWgI1SnQW+/kz8g1f/62hDXwA7r5erdsZ6CdYI2Zt7lBLa0ZynYqRRJnhdI1nEIaxGcQNsckeUas7Bs25DCBnc/4+l8wfZL25xk6yehquqtHJIE1Keeam5cX8DUJ9qR8BONxFawwbOxwda0/HeBnQKwFQ0pIjvHFNlaqlZaeQH9NsaH9UltaKFbZtCD3F8vMs62/H8Jw6YOyWH87SaxpIFDyqH7BxCW4wl830r2HU6CmkmRzdzC0ThpnjSBw2Jy1FieLJLA+Q==
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
 mm/swapfile.c | 51 +++++++++++++++++++++++----------------------------
 1 file changed, 23 insertions(+), 28 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 32e0e7545ab8..ea63885f344a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1931,35 +1931,30 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	struct swap_cluster_info *ci;
 	swp_entry_t entry = {0};
 
-	if (!si)
-		goto fail;
-
-	/* This is called for allocating swap entry, not cache */
-	if (get_swap_device_info(si)) {
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
-		}
-		put_swap_device(si);
+	/* Return empty entry if device is not usable (swapoff or full) */
+	if (!si || !get_swap_device_info(si))
+		return entry;
+	/*
+	 * Try the local cluster first if it matches the device. If
+	 * not, try grab a new cluster and override local cluster.
+	 */
+	local_lock(&percpu_swap_cluster.lock);
+	pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
+	pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+	if (pcp_si == si && pcp_offset) {
+		ci = swap_cluster_lock(si, pcp_offset);
+		if (cluster_is_usable(ci, 0))
+			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+		else
+			swap_cluster_unlock(ci);
 	}
-fail:
+	if (offset == SWAP_ENTRY_INVALID)
+		offset = cluster_alloc_swap_entry(si, NULL);
+	local_unlock(&percpu_swap_cluster.lock);
+	if (offset)
+		entry = swp_entry(si->type, offset);
+	put_swap_device(si);
+
 	return entry;
 }
 

-- 
2.52.0



