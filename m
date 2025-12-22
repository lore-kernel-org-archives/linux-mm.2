Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB266E66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F96A6B0089; Sun, 21 Dec 2025 22:07:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478AD6B008A; Sun, 21 Dec 2025 22:07:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C096B008C; Sun, 21 Dec 2025 22:07:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27CE26B0089
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:07:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCF195BE5D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:07:40 +0000 (UTC)
X-FDA: 84245621880.29.205C53B
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf28.hostedemail.com (Postfix) with ESMTP id BFDD9C000C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:07:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Z3BBbLsa;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766372858; a=rsa-sha256;
	cv=none;
	b=cMj0ctsmf5ZJ4vBsuNKr8qBSSDwIX+3at5Dkvvpr73YFKZjznw0SwFKwcPqLaZpSi8q//9
	wyHSNJgQ7SZXKwDPOS4J3b8NbGsRUhbaD4cHOm7Wgzxrk1/5SmhS26aX6Tj+XHJZiV2AJU
	2XrSDkhiue3NHmS6XD8CjoWWAGE/0oE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Z3BBbLsa;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766372858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=h+8lKFCCp03r8j0snro+1eHHOhQJKqEa1bSpen4u19w=;
	b=JoWEaf6JVNDFvHxLYzxPJ8m3nSyRToXAb27HUUz5dEPLXolhtvge+kUGxpWk+7RJI3PIHV
	+L009pVhlS12j8OUn8DL84CuEio0HDS9eczz4GCRhYEnbEDCxcLqQkdVJaaHsXP9n3BrtL
	KMoI2UNqRpeQrhzmTQ2W7AKUXX9DdAo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=h+8lKFCCp03r8j0snro+1eHHOhQJKqEa1bSpen4u19w=;
	b=Z3BBbLsatCeRTgS5umaRSaQUU7FNYtjHgfdSLmORXHhOeD+9jBCUhLeUZJbcoCqCsZDepq5jY
	ocoLK3dDqCBXzu05cHYuCaAP/mZcu2AAlZXwoqbsW2wPGG8OcxHAOlKRugYwkzid3Jlks97CvU7
	TuK5RB4G4wOUCdmpkk/Bz68=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dZNKB5B0yzcb0X;
	Mon, 22 Dec 2025 11:04:30 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id CBEED40569;
	Mon, 22 Dec 2025 11:07:32 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 22 Dec
 2025 11:07:32 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linuxfoundation.org>, <david@kernel.org>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <mgorman@suse.de>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [PATCH v2] mm/mempolicy: fix mpol_rebind_nodemask() for MPOL_F_NUMA_BALANCING
Date: Mon, 22 Dec 2025 11:04:56 +0800
Message-ID: <20251222030456.2246728-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: BFDD9C000C
X-Stat-Signature: odofk64pnz5y4mjp8j1kjtdipiyec4s9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766372857-705969
X-HE-Meta: U2FsdGVkX1+SdqHO4MwrVG+XRNnkGhCgqvsZsdu7XHwasMDE7AlhEXLG3spXbhpmT/bmu9ctG5vxG0riRv9ukgXMC9Y4Wj9gXwNka4UFC9/Bqjo+/6t8c+3hvavK27lU6hupKHbG8KJU6IzlXOfd1mh4tE28bg+2HJi83quO9zobtRjlLn3TWOyyHAUhn4S+8lqRs/GfmXsaQaSI7Px3aOPW+2Dn+CJ0VlQLkWQtuo6lFjYCPe9PfdBk386JnxBZq9M2rMgvAdH7RBes/nKjtEjyILdIPdcmPuXo09IKWG3cijavTRjTt+Gui1WlgMKbFV+PzyspZP1FDGsR9HFGOZ3Ma3jxbdA++4PS56ggCQPiZBHWjUeOLaY2GjtdnSJAQ9w06QliP4+tgvFUZkUmV+RquWo/lv0Soa9IFzJP9bwMpxQTItX5S27/lRbUd2qTw6ear5hjpH4fcQc8ZiA64H+agkoqnau+O8AkIXntkd8LqkZB46mzfrOFjy5IfiUV3rzdz8vT6ReA35z4zIKFgSLfbBR+aQvQsdLWexDDEOwtthd7Soi/JajO0Uq941zZVwH0TmvuKT8VEbr4EuXFIxbiHTpnqT9sAgyHUUoTA6aQwRsb1jYzmxpC1emIpeSNwHydpidtgNboRpoWwhFVNW5V3+HTLYywhEzfDTPYDkDok2ZInzpBJyurooxTyZDP4nEPFHJGdgktMyNFwOTEvJLU7H4iYfE79O8Pt+rdaWh+HB2aoW6fnfwF9idNW7eDPcgfng3+5mZ2LUDC6b5bkFlvWZB17fEnVbFW+C6n97eu2Hvwz7+nAzVrOhDq1JISQK4dpwPUM5JYH39z1XccHJJ3bDF69GwEKoG9t6FR7rr3Pb7XCX8P92zVHXsMpd483w0WqB9+bSoG56W0vi36yHr6SCzuRsIAplgUqz7OEspEpKGvGXoPEuXhnmRllwk7A1u/5BvaCjGzltjcyk3
 quIwqA1a
 EkUSaXBO9N09Dmy9PQuqWp6usm6cuz79VCfmob1noooZISKK/M7mUJdvFFagrIZwheITDNgBTeZz/daAOYu1RbA1zgXJyEn2HafPOpWXvgR5biGypeGBkWsaG8GnKeDM+JmKZcXFCJoXpQqZX7nVBgf40nrKj+WWbAm/huuE+kA8wLiMqyUgv4Z3eXqNN+9Zc4775CoAOs9zdog2SmNWVhn6p0AOy7pBBnrp038Pp54zRRDJLTZ1RVCbP8w/zfm+Fu+aEywGE8BzL6VYCUa9Ogill//kWBD+Tdza0LyBp8a9RO7AP0kibsMvvrH55JN0PZAJuM5KS8JM/MwOHw3AN96g0gSCRPDggXwYTRMQmkLlV1iyym27KphZyjY3bgFmQYFZrS5eU/MgV07GLN/qWvQ/TgTemSzZroXHhfBvZqBhx0a9tUWN2IpVED53WIT0LSw0Qaz37AX7dqLetjN/l54tdRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit bda420b98505 ("numa balancing: migrate on fault among multiple
bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
for MPOL_BIND memory policy.

when the cpuset of tasks changes, the mempolicy of the task is rebound
by mpol_rebind_nodemask(). The intended rebinding behavior of
MPOL_F_NUMA_BALANCING was the same as when neither MPOL_F_STATIC_NODES nor
MPOL_F_RELATIVE_NODES flags are set. However, this commit breaks it.

struct mempolicy has a union member as bellow:

   union {
       nodemask_t cpuset_mems_allowed; /* relative to these nodes */
       nodemask_t user_nodemask;       /* nodemask passed by user */
   } w;

w.cpuset_mems_allowed and w.user_nodemask are both nodemask type and their
difference is only what type of nodemask is stored. mpol_set_nodemask()
initializes the union like below:

   static int mpol_set_nodemask(...)
   {
        if (mpol_store_user_nodemask(pol))
                pol->w.user_nodemask = *nodes;
        else
                pol->w.cpuset_mems_allowed = cpuset_current_mems_allowed;
   }

mpol_store_user_nodemask() returns true for MPOL_F_NUMA_BALANCING
incorrectly and the union stores user-passed nodemask. Consequently,
mpol_rebind_nodemask() ends up rebinding based on the user-passed nodemask
rather than the cpuset_mems_allowed nodemask as intended.

To fix this, only store the user nodemask if MPOL_F_STATIC_NODES or
MPOL_F_RELATIVE_NODES is present.

Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
Change since v1:
 * update changelog and comments.
 * collect RB from Gregory.

 include/uapi/linux/mempolicy.h | 3 +++
 mm/mempolicy.c                 | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 8fbbe613611a..6c962d866e86 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -39,6 +39,9 @@ enum {
 #define MPOL_MODE_FLAGS							\
 	(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES | MPOL_F_NUMA_BALANCING)
 
+/* Whether the nodemask is specified by users */
+#define MPOL_USER_NODEMASK_FLAGS (MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES)
+
 /* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
 #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 68a98ba57882..76da50425712 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -365,7 +365,7 @@ static const struct mempolicy_operations {
 
 static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
 {
-	return pol->flags & MPOL_MODE_FLAGS;
+	return pol->flags & MPOL_USER_NODEMASK_FLAGS;
 }
 
 static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
-- 
2.43.0


