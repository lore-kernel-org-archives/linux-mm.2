Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 306FEE7AD40
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 08:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0086B0095; Thu, 25 Dec 2025 03:22:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790496B0096; Thu, 25 Dec 2025 03:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69C4B6B0098; Thu, 25 Dec 2025 03:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3086B0095
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:22:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E57A140616
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:22:39 +0000 (UTC)
X-FDA: 84257302038.19.A524EB8
Received: from sg-1-100.ptr.blmpb.com (sg-1-100.ptr.blmpb.com [118.26.132.100])
	by imf01.hostedemail.com (Postfix) with ESMTP id 90EB240006
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:22:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=h6o3xmqD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766650957; a=rsa-sha256;
	cv=none;
	b=HhwvbdDarj0NI7FkCZWkJzsWIYLONrCF2zYiXbAOPaX5pEXpSScRaz26rf38S8n/2JyfL9
	t4lVbktE7Ks/B5ofgiOk6Dx6m/DjbARLJMfiKkCLbBEM0aHdhaLUCaY6lr2uGN67vwqE0R
	8jHC45RG2PFc02bE+J3hyAd8+tmFDvg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=h6o3xmqD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766650957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x60aj7gnZL//ydPkRsAnsXmDZpL6pv5KHgFx5n1s35I=;
	b=lj65t+iL0Ne3S56+QH9xcXbP9Dwb0fkR2OidT6+nknOjWcflORfTBw7imMKT4fbaYuCgI4
	e1vOtuH0QWg39eSHQGv4dA2ET5DqOwpwKvICcAoFHVuujplDmGOw2Kif6sL3jcqxOtyQ85
	PIGmgZ7qEiO9R90unx5K1gJWtvHLNJc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1766650950; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=x60aj7gnZL//ydPkRsAnsXmDZpL6pv5KHgFx5n1s35I=;
 b=h6o3xmqDft/dybsqQitwfvYQlBt/IiZOxNOz3EpMcNQTS3pnD/vVZf8XiL8YqDyslnDCCl
 G6+MqlP+yAZy1ZxyLFv4oPJNbCTYC5rlT+yzQciIzpTDSLbKJURJBuHUsgTiD/xweEvYdm
 Rj4pLj1BEat7/ZLuow8LaVSGEvuBTa1gp/Dux3bRQnmXD2opUbHtUh+5XjebSNroRmksKt
 BQW4h9U459+R3+QvLdlOgUd/gmH7iMWp8JJgbKTilqiuAvSwHq9NWban5oaFCKyQrAL5zJ
 0wgqfsA0xD/u4C//nlvAtwzleKVl7OLJ6GQlITQpdleTd5Ty3BcSHItX8mx0VA==
X-Original-From: lizhe.67@bytedance.com
X-Lms-Return-Path: <lba+2694cf444+685804+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Dec 2025 16:20:56 +0800
Content-Transfer-Encoding: 7bit
From: =?utf-8?q?=E6=9D=8E=E5=96=86?= <lizhe.67@bytedance.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
Mime-Version: 1.0
Message-Id: <20251225082059.1632-6-lizhe.67@bytedance.com>
References: <20251225082059.1632-1-lizhe.67@bytedance.com>
In-Reply-To: <20251225082059.1632-1-lizhe.67@bytedance.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH 5/8] mm/hugetlb: simplify function hugetlb_sysfs_add_hstate()
X-Rspam-User: 
X-Rspamd-Queue-Id: 90EB240006
X-Rspamd-Server: rspam10
X-Stat-Signature: g933fwoxh11e8jsnyi9rcznmo7kcixsw
X-HE-Tag: 1766650956-156403
X-HE-Meta: U2FsdGVkX19cR7gd+PJWJGkgF9pgcdov6apEqkvpI2vCdBLw0vlA4oDPIpqmsHF83PVP8Bhmkf0TErSGloOUuKILp7i9+7OwdDPMKoL/mcGOl7MWtR6s3BtUxEbpauQctTb7bOHHB7HwXjZDNolzMpz+/CtF1tvJprsPV67cE9ely4KKpa4AHuZds0U/aYDjKcMBHR7u6kR0/YhBUFsSwSFJjg63NeQSawszRv073O59nQ8K3c8FzIiLOFy05IPYelevriEKj+oHTi7HPT2a8s+jTnf3o7zr5CokmS9tss53/ywLZf1DNHTqMCbSm9lZaIc6TrQX4ncGcbbWdoCkQYVodO4R0Xt03soN6H+D6XNBfVRPqAF43a6gzXiJzzaTlf/B3fnhNa6d/6cw8GKbrAbzfT6FXuMr/m6lUtDEldFc65t7BcPSq7ng02uQTTAVW+uFjXFEahUX9QTFzo7OZV62RalZ7gGdihIaX9jYjZf9EumMVvHiXDcv8Y4KFRCen9E6LmRlbI9u3VOJaz7SRcfZuNCesTEJhWxF83JMsaUy0UXphbOldxNBXmPmSyfuXbswvCD18T5aIUxh5UpNhc/zRnlvWXk3CTSqxQBqOxzzd1lAFsb6n8IVi2MRk+6A0S8KECTx5OKDBi5uun8bVhDKCfxp9F04moHw9ZnyaKOVkdMpejM/JqP2Xy28pZr+nr0cUofAWaDaqUEQY6yEOoEdYvKqKohr+k9hNUf2murgifDncOMnMve54BEGqlSaYi6sKcDb8UA/eT0k39uPGU2dE5DrnfqsGKTOYMw2bM3kZfk+gfY8ABmbgitTBRDxgvK80nlcW/spIKX1KA2ZzbD+6mqkHzSJieUj701S7+WISGtIILuh9fhjUVAjgCrDGsBwaL4/DPuZRh8N3zkpO9NSssnpLLz5y42/txHlKIDIrxNMQcwhUQeBIrTmo2i6bXCgk1U8GLX37IwyD7U
 z0+u0sxz
 wUekgX7MlE/YtpEEDTw3suhdbMl8Wn2EQoqhk8wC4GJcjU7hvRWdtGhEoUpwq7Hlxk5IGOY0CUhYDg+IYxqGDKi9vyFu11HdlH3fNXO2KgtBdFTCzSi7pEcVvo1ikuXYTG2Pr/RfmGtVj/9zX6mJvCK77LdYNeZ0pncOPIQoZHTQpXeQ/aN+70rBSsJ+WkvNbaf0V8U4BYxP4p4crJyMDrVz6t/KE9JtQiGAWx+wEHk769vzxqHCc+1LFonpORSXApNAN/AebxwH7MtJTbPZLZvuAAfCsaIOCRb8HuShBw15dciiey3uMSEejjESvDR+efGsFpaW/SqlKiac=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

The third parameter of hugetlb_sysfs_add_hstate() is currently an array
of struct kobject *, yet the function only ever uses a single element.
This patch narrows the argument to a pointer to that specific member,
eliminating the unused array.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb_sysfs.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 8c3e433209c3..87dcd3038abc 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -304,31 +304,30 @@ static const struct attribute_group hstate_demote_attr_group = {
 };
 
 static int hugetlb_sysfs_add_hstate(struct hstate *h, struct kobject *parent,
-				    struct kobject **hstate_kobjs,
+				    struct kobject **hstate_kobj,
 				    const struct attribute_group *hstate_attr_group)
 {
 	int retval;
-	int hi = hstate_index(h);
 
-	hstate_kobjs[hi] = kobject_create_and_add(h->name, parent);
-	if (!hstate_kobjs[hi])
+	*hstate_kobj = kobject_create_and_add(h->name, parent);
+	if (!*hstate_kobj)
 		return -ENOMEM;
 
-	retval = sysfs_create_group(hstate_kobjs[hi], hstate_attr_group);
+	retval = sysfs_create_group(*hstate_kobj, hstate_attr_group);
 	if (retval) {
-		kobject_put(hstate_kobjs[hi]);
-		hstate_kobjs[hi] = NULL;
+		kobject_put(*hstate_kobj);
+		*hstate_kobj = NULL;
 		return retval;
 	}
 
 	if (h->demote_order) {
-		retval = sysfs_create_group(hstate_kobjs[hi],
+		retval = sysfs_create_group(*hstate_kobj,
 					    &hstate_demote_attr_group);
 		if (retval) {
 			pr_warn("HugeTLB unable to create demote interfaces for %s\n", h->name);
-			sysfs_remove_group(hstate_kobjs[hi], hstate_attr_group);
-			kobject_put(hstate_kobjs[hi]);
-			hstate_kobjs[hi] = NULL;
+			sysfs_remove_group(*hstate_kobj, hstate_attr_group);
+			kobject_put(*hstate_kobj);
+			*hstate_kobj = NULL;
 			return retval;
 		}
 	}
@@ -562,8 +561,8 @@ void hugetlb_register_node(struct node *node)
 
 	for_each_hstate(h) {
 		err = hugetlb_sysfs_add_hstate(h, nhs->hugepages_kobj,
-						nhs->hstate_kobjs,
-						&per_node_hstate_attr_group);
+				&nhs->hstate_kobjs[hstate_index(h)],
+				&per_node_hstate_attr_group);
 		if (err) {
 			pr_err("HugeTLB: Unable to add hstate %s for node %d\n",
 				h->name, node->dev.id);
@@ -610,7 +609,7 @@ void __init hugetlb_sysfs_init(void)
 
 	for_each_hstate(h) {
 		err = hugetlb_sysfs_add_hstate(h, hugepages_kobj,
-					 hstate_kobjs, &hstate_attr_group);
+			&hstate_kobjs[hstate_index(h)], &hstate_attr_group);
 		if (err)
 			pr_err("HugeTLB: Unable to add hstate %s\n", h->name);
 	}
-- 
2.20.1

