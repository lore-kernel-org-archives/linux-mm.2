Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E637C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335546B00A7; Wed, 23 Sep 2026 06:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCBB6B00A9; Wed, 23 Sep 2026 06:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15B6F6B00AA; Wed, 23 Sep 2026 06:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC4126B00A7
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:15:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70BBB80753
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:24 +0000 (UTC)
X-FDA: 85244619768.30.184DABE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E4DB080006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SxdmR5D+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mS1OGjGueuh9xRDDJo/iscVAdMoJD4YdolHQuoVSGCo=;
	b=l0ueydE+LKcm8Msb0kf31Zzm8rjOzXXWY9zA4/VDt/q6hfsmMpIovRp4gLL9ecMFNh/PGQ
	oQTllAbHXW4RSLUZWFCH8O68iMEJO5yNHSmyU0Gptz1slvACPuqcyrd8MXczXqihcXnYDm
	gbqwUo+PxOv6Zzp5+sz/rbJ5D/W0vjI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SxdmR5D+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790158522;
	b=ESA0P96BusfYiqZLimIqfeASgpRlJSqvKWgtSHiFpQMjFuVSty8vFdN3armqvFXOTHUqIW
	nIaQXUAU1cj7IQg/MX5F6G6L+EKIO9vgqNADoL4WceYpV3zw5AZScmZGq2UfcFym3ofCob
	qI2gOAiYdgAqKJNEdFoQfHLTqIJheZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DDCD601FB;
	Wed, 23 Sep 2026 10:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835391F0089C;
	Wed, 23 Sep 2026 10:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790158522;
	bh=mS1OGjGueuh9xRDDJo/iscVAdMoJD4YdolHQuoVSGCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SxdmR5D+x+a9bjNYIJJa/xFr9r7VnWhtn0QxulWtSOsE+AwFogqEJVKZvIyUpmGQH
	 ASLdwYCFNlUevU4cH5uIs4t4rNCZBQ1rWyASxledL8j2vcizNDStdITTgd1goMYU9F
	 9c7/P3vMPbYt+kjRyUkAaPpTQvxjPuQhpu92Usn+sJGtyku7oSGb3ao7eN4Ajs+FFG
	 KqLgdz4Oq23CMS2TlK0MMeer5IBCpqTNipCx5SfxkUs4sI2GZnt0b3XWNFHKSlU9YR
	 0l3ulKcf3z9LuKJW0vrTjlfj03AuAB8NRNh1htNjpfozXY918ZbFjLFe6sM2DXelSP
	 A0cInBCAC/+ZQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 7/7] Docs/ABI/damon: update for quota goal metric complement sysfs file
Date: Wed, 23 Sep 2026 03:14:52 -0700
Message-ID: <20260923101454.5748-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260923101454.5748-1-sj@kernel.org>
References: <20260923101454.5748-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 86nbkhoxfc9iitbqb3ew9aahwo66977x
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E4DB080006
X-HE-Tag: 1790158522-634590
X-HE-Meta: U2FsdGVkX19caPxeuuH6j076ZKqIUVzayl+i8UtEhXbidydm0eTfOm1tnmouIbFH4lsI3Q3J0YcYxnv9H872KaYC/1mX/AiKBZceD6gEbPGReN/DuoyUZJ9nskkxGmasMVGia+pfOgLfzfAZzHIapSBEVHD5LeeF0ZylKEA/NYcOlLY2eIKaxAEueLKJHVqXr6bd3qUv8UJw0kp5u6GcKGtXHZAx0eslLLrmCt7VMRGCNF7Zfk/x5n7TZ5jJVm9QVvCaaDxiGl2n8XPavlf8SrKRWArSRyZmY+BlcFKPiaxeM6qRPe5ScFlEKtJZkhCVDUWbt40hCbRLsTkSpNe41IlLvCUhrETNgKJn96Ay8tQX7Z9NXEMkoDV5ECak/iHkXW3fNRD7G0M5idSPDSglkNK2jVaHPsB7pXJl7uySCqZtT8QqADPo+szZACDUEikWVD89eUuEH/iTjyPSAdSORVSFeGTcrJYVG2wDlGcDVZQJBAlPPledTtOiHBlFqjYSE5er4B/7QXlIAIn02xik9QQ13iYxmmL3cohxVN1qA1bW+tLp9mYAjeivNbeEt8mpsBmjtAVUHsi7ljxW51PvrxeDaLBjONF6UbNAc5wv88gCocRSs4WqjazUzjeNDeR0m6nB594TiYZkVLWUSdtUq9a3LaPv5+2V+uFvDQRO0ar5oHnpNuMtOUUiEYKYdvk/SpJVWn0u57NOv2nKOheH74aRDwdDO0ejCLjkeH9VzFitw2ki+mrgXAF68Ruk6DzsyVWmNcsbqYSTI36qNHljFyAhuYGNc5dQrIy1ytK3FkpIeuxTNzMmEtflPL82b+ffxQ7JZLQEc1Pe0jkNtF6QZWSTyCns8EX4njhPLrcNz8Yp2J7ERp5UNOEdxm8waOB3JLmcoPjdLYSOMeDBOZtxzTa5Y9jwz+zvT4+eNWcrmIThdirOq5QViL/jkhjn3Z+ECfPk7wWLwf3FgYpKWFJ
 AZmoVA1L
 T8AgyArqyqB0yzF/O0GVELbjWhg0h9KC+eyTYQ/OgboLBJzF+ghCW3ESHpYXvemcEsh5ocux2fVh5Gxl3JWVCIhO/hgKHX4FVCSvGm+qQ9bUr/PPc3m8PdbeDiXEQIsiaMjp/IVNPvUwhYkLNzZiaFwNtvF2FzqYp+rP0Kq68xfZu1nV1yWP1tuL4/n1ZqZxwWkRsSpBhApZyu2MBwPorilGYIxX/FdEmad4qaex3Iil80YLzhPmrrFydn+1nMv5TVj8Q3WJ9/hogEjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added damos quota goal metric
complement sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 55df688ea596..4acb2015c2f4 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -375,6 +375,12 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the quota
 		auto-tuning goal metric.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/complement
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets whether to
+		use the complement value of the quota auto-tuning goal metric.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/target_value
 Date:		Nov 2023
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

