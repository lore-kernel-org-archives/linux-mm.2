Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF5F0C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A72AC6B008C; Mon, 31 Aug 2026 10:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FC1F6B0092; Mon, 31 Aug 2026 10:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EAD86B0095; Mon, 31 Aug 2026 10:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 601FB6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:47:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B0D0E8017E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:47:44 +0000 (UTC)
X-FDA: 85161843648.06.9B200AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 07049140003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:47:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SdsBr8V8;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788187663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRlTOiEIY3tiJAO3FSkFxauqKn7UWt45qGOpOASV3nk=;
	b=fS2jc3xrbZjjqAZHwVH005/w7oV5jljMtCALWnuH3DIfLVih1Pm7sGGRRUhHnUXGvKjvDq
	E2P4hk9j1a17ATXEomSvlY7uAvFFVUGzAF6OVjtJrgOuXe25FdN2SpiniZw27Xp/tbAWZA
	VXWeijmbnl5JtxIR/4E3VUMxyTA8RO4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788187663;
	b=c1ta/SezyY6C0+qJLboTZ9LzeNgUujdqGybBJHGVuiuPuYJAVTefZnlTvbb4qgWdiq9YjW
	jVuTXI3PMarRkJ2njJ9EuYf08ikyG5MPTOnjuoNm84tRmjvm9aD+gmifWJqtG5h2TM0N+j
	JIfoS7e4at5RC8rIkTocJ7Fk/p1Rt2o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SdsBr8V8;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FB7343C13;
	Mon, 31 Aug 2026 14:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020C41F00A3F;
	Mon, 31 Aug 2026 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788187662;
	bh=jRlTOiEIY3tiJAO3FSkFxauqKn7UWt45qGOpOASV3nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SdsBr8V8Wz3lqkMNdh5QCy+1X8yc/Nvwitq8jvgztKAbCU58EZKIJwLdIs/Ox5nLq
	 VHcBEsCeDDQTjjiH9neNf14ngxKWXuy4QQQfr5rL7UqCiN6DbOJtmTXIWgbafyUgGo
	 ijRAOEffpePeH+TVg5H0eOMz/IGChahtEprI4adZszGk4OGKx0P3qWFf7wij14SFpv
	 LA35NY33vziyekYX0s8BICIkmTzF3Zi6vjx548fS2TNkXFuZHgicQxfckNwOdeznss
	 iHtS6Xr1ZjOqMFHvzQ/b+p5MqoqgrR67lD8Wy6Mzi+GNHPyarAmjHxfOGU25nt4Hdk
	 0qOHWqPnAe81g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 2/3] mm/damon/sysfs: support hugepage_mem_bp quota goal metric
Date: Mon, 31 Aug 2026 07:47:29 -0700
Message-ID: <20260831144732.80910-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831144732.80910-1-sj@kernel.org>
References: <20260831144732.80910-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fsr5hdaf1frqwoyqqaj5te9umoquztxp
X-Rspamd-Queue-Id: 07049140003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788187662-582524
X-HE-Meta: U2FsdGVkX1+yZTjrJgAo+z5CiJHGB/OChYtL3kKyMqsVNb0vUk/4UJWq7+qGjSXZ24XmdzCgFdKJU0SK6RaFqF2Lw8SKA7r/ILZzzkeY+4/ztBaYWrdZaPyZVMG9NT0XA4n7nfDgIG9Op/V0bkQPRoj8tZxejbuzStPPOQz/ka2ZtzW+fO6RV31BTXpfKJzU+d9HHSEESmCpsZmF/NQVWJAuVmFktNDGxwdgW9TRjKVBKtQFyYcHpMH4+6YOczBuuMAd1rt8Dx4RM7X6tbxMkKHUXUWUudrgZN8zNG3xBEOHiNWfDlrF8HzdLK8n3cPuTHYz8n+c6tr2F6GQe3OS2GDxoRCtNWiOwrRXRyGQBwgidAx6+MfXg7rSzQoDigGRwzAqR39OEMmHUAn+zcisxGizUAuV02Q6PjaBvH+PeVf1S+aUblrmUIZtYqod0RgjaX50PzdheMBakkTSIlNX3l65hMx4r35T4wosAO8CtpBqtEd5YoMXJ6G98TqFkFVSVsLzaQ5hAMaY4SwO8KxSEr4ktg0D4oMKmW1xwoLv2J3poV5oydPW6dFfdOGeSg8t6k2GzajeIUxHQppyqqy4Y5flTjw+i05oiEynz/KWWWneTfrD9jLA0e8FCl6TmVPw+5Y6L3oKZ2kFCGOdZMQ88Bx/jQa24GnayNokaA6Sy6FLMVBludorH9oooNlC0JXzSGGgXc6RrKiLSsAuGkXmg149rfXRy/L+PryNPPBCts2TarmkRxgqYuB6gtIOIqC7wxxGRIrhMJUWzs7FMSLZVMD83yTm9J/8IcoH2KMxePuG4lBDSz8zXwFxXgdVXx1KeK0AR5i265eTCuKMfV89kn8j0JtCWJoSWPeGFXgwpo1KYgeT+9QRHRkigOSrdcrlFjsmUviNqv7ohuHpBzbBFUf25CeCKAOrozcLqui6utkj8+zNJnC/FzIdVun10LNcX8PgJewxuu1Ihss0FTL
 g8Bb3s3x
 PZGe+TpDL4d1BungmLlxoT7hrpDmfld0+/LpV6RBA2JhJHpeaFZP933pEgUuNoxplFXgu30jg0y+ssZVPGlsKcYgD60ancR9TUDK8twPKtAzSi/4Rv5Rb8W7SipMG8e4xbpF3TQOOH0kSI9NxaAgM0COnV1pLF9WRF9k1dajA7CqJvcfTs5F3S8UCQ01XMeSN7dKW5xz1fFPBeJf/4xzsw6MqgRoAEsOmqyXLtxfDZ9x/n9hHAATcIkCLmA0i4P9ZNL1T0Yfy3lMfB/2aGfRSXGp+7NwVMsi5SOa0iNL1OQshnTm3dYYB6kgmiPbKVwhhhdwT3BYbPf4qPxYu4ckUhC0JKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

DAMOS has a new autotune policy metric: DAMOS_QUOTA_HUGEPAGE_MEM_BP.
This patch exposes DAMOS_QUOTA_HUGEPAGE_MEM_BP through sysfs.

Add the "hugepage_mem_bp" to the sysfs-schemes interface.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 32f495a96b17a..d9b81d7b5910e 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1269,6 +1269,10 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
 		.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
 		.name = "node_eligible_mem_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_HUGEPAGE_MEM_BP,
+		.name = "hugepage_mem_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
-- 
2.47.3

