Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4545EFDEE39
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD9F66B00A1; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3B8D6B00A5; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB276B00A7; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E52C6B00A5
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F1A71403D8
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:38 +0000 (UTC)
X-FDA: 84690542916.03.E4A2B05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0B6F114000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IbnrwSSz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966216;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QtvLSQmE4aDRAb8DiSU0AlHBJ78BfZh8qIC573VC+s=;
	b=fOazy7P+uo5+k8CsEMOGFOFMLlZ2X4eO0lHlyPATNT/dmCAAQGZAAVHNxT2UuzkwUpbTIc
	wcBtBns+FaRuxgQy39z0tvsV7b1I82YFnpsgZDWLbhKFrjbRrPJKRdravutHtXSemnZBuA
	GZ6drAayh8yMoycd/PxqPXkXKpgUAmQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IbnrwSSz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966216; a=rsa-sha256;
	cv=none;
	b=loRQRmsI1XgL5NzZT2bJveghIVm+1YMqx8yJKWRIihDCZDc3AJ7kHtcisKXtT/GKgFK6Cr
	H9/uYKIFaMgmHDbR4aQuverXITO0LfCRAHW4mWi12JNvqBptbLpETU4kG5l16vgCuX5k09
	on4fWogn+vIV206ojpACTryZ1pA3QNA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 59FB844775;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 358EFC2BCB8;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966212;
	bh=84Sdzb0xN+DMxvZserLaTWqJv8AqidSImQfw43Dn4S8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IbnrwSSzqdzeVjwidFVG0VAA/UBgxVMO98gOI3feeAMSIo9r9LH8lfqhMmE1F4rH4
	 aKCqS1C/y5POe364fSq6vFicAuu94j9AV2DDXO+A0l/YuJghXiAEZQynW9NI6H5DNr
	 SeyFq1RLmFJLwFoS3URF6vytSzkWrnx6uQz3f9ZVoHt7RQafIxmTZY7OzJvoIfn8Rn
	 1th9ka8tMArrP16PxR7XZOKjYr5gYsEVenGdtzyCYvGJePzenz5pB7BIspEK7G9Lzo
	 zUYRD0+OI+Fj0CYFdKCBeIvxR47tjlZJLm2yJo5dpVj6W+KDIOMP8Kg06/DoWPw56E
	 hPxh50wTCvyYg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC79FDEE35;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:24 +0800
Subject: [PATCH v6 13/14] mm/vmscan: remove sc->unqueued_dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-13-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=1092;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=BcORidMLEmQouegYnHcnzJgwCLFGF5hvusRRBleG7A4=;
 b=jK5uHZZUVzeN0NAKTODLaABCBqMJKZvZMubU/ltTUylOFyl+ZQ+lSpeo1aKQ9OOUQcBVjTDM8
 sqJIiKuJZBgCgIMWLK/Ppy6q83QKXlxGiq9gk73Lt0d8XKZ0W8Q61tk
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0B6F114000D
X-Stat-Signature: zfass6nz7oary6x4mks4pwbg8ktc1x1g
X-Rspam-User: 
X-HE-Tag: 1776966215-86859
X-HE-Meta: U2FsdGVkX19YJkYtQRXXYB5GEWy+eQVvdV13+Cu4Pfns/J7igpUFAytJhE6T+xcdIF5kSCnP219Y7EXZa53hfSGNnfUI6imMkedsg4rTU0kwstJbI0rYmiN7iSubqHBSbsXCehn5tpqKKRFO6wsdKR5ij4fHLIn4sLEAk4otPLVr1PgyeQlNRipFGfkTl7PL9LfWE3rDJgu1oyU87lN4ir74WkuqRTt3NM2MWjXaRM+f0MjAke0Y6rheSNA0q3xSPRFrzTG6TjFFbb1k4WdIXUAjzWKb0KZt/nRHKuQUly6sC70qKFkyNdn2tszfEtPBP3r+qJwFKlQSWLrY+1WE+g6D+F73yIeyhHWOTiKayNXNIAieEC0Ud6gEg7J837IXUfVIAgEOapedDFEKebFAZsVEzMt+tslchOCJyuGiPM0yXcnbP5FctSQJkkNUdR+JpNGgCoBtyPLxs5ToCf5k6wU3XNcEDKNNWBb+TcnBvaEdVA7F4ChEw6NY6H8Xjc1WMAUjsO0Ptnpati8ZPte0HqawfX+TRbNTTMCAU9aZZwexwulCq4i3NLNlLwRQILjdlw6gf5TbTGnCkMN4QqkPFaC9HiXWDeyz9Uz5458uaP0enqZ+IAo/e/SJbWikUdGZHMWUIWWAGwo4y/0q3PNuqHkBjzwl4B8wmRrrbI+pxreoa8Pd4t8EfqNkaTa5OHxhiSCoqg6otfRv7m/H4iQ02vceMZVwuxCGaSeiYksAzyU4qSoba+6i7MNgpA45oKECW7wNAqrvpWqQQoatA2ABNa5kcYPw8WNFXLmz/fF4RfyqZIwg5B+8BRWmuQPv8lPSd2WuyCAPYfNU2xnxLIlO4xivs3z9wgq9Dxl/ukMxVDZ+YZxuIVML234alnaL4b1QB3bZ38g6wDJNnsZ4lWrh6lnPfaPXldNauTkwz6aYEwWrZL0IfvsP71rHhFbi3xVeWVZkRy4mH7ExDoKW2Pi
 muDGDF86
 EW6CJ3A83bIKC6an1CdwcYoG2nuN4Q5KmT1BtY3fBpVy+dcui+iuWLVnKyzbRt8UpHF8VkbleFHepF7wfQbIoPdI7apDKb/LlLtlh9mbOK+3CdgSUAYJHeptzQcKJz7S4u9c0R0uIQfgxsVkcimxsVe4cOE6GeIPK1VMTwJwhH8hRxpMcdTJqUaA8lKOXBZj3tPOQqx/HYTPNPs2B4e5UQeEIavap/EoMr4IeQrGynm0ry+4BdE38sQEcGRZEo6kRFlbaQF6RIc24c3JSLcOWMieF8/ylaBPOuT1WGFlDqQEMrC0gyJyditbzNhOamdept6w0SaWh0tLtAyLDo4jYJK4IWXmtTlQqn20PT8ivsfjno5pacR6lBEvTJ1S6okZLfcfeRQQWz9N7Rfud3YtvuSYJDpaS5O5JIVsr13yPDicL4+rVu/uXbLnhKdax/lKKI8MwRlYKa/NbrAv+fBLI9nNmjRrhajylpwQGrS06jY8bHlBplFkeGGDHT3mxNLbniZPFPx0QrQU7itYyWGcaJE7swC0TWC/JtdfX2X5GICQtOC7Ws2iOVehZbold9L1lOPK3XqOwRjEMI092POLAVm89Oq00GTKF1ZY5sgKJf7bzBV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No one is using it now, just remove it.

Suggested-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7bec0ae51465..6df5ab625e6a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -169,7 +169,6 @@ struct scan_control {
 
 	struct {
 		unsigned int dirty;
-		unsigned int unqueued_dirty;
 		unsigned int congested;
 		unsigned int writeback;
 		unsigned int immediate;
@@ -2035,7 +2034,6 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	sc->nr.dirty += stat.nr_dirty;
 	sc->nr.congested += stat.nr_congested;
-	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
 	sc->nr.taken += nr_taken;

-- 
2.54.0



