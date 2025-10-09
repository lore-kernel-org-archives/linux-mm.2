Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8310CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 21:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CE768E00B7; Thu,  9 Oct 2025 17:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7566E8E0002; Thu,  9 Oct 2025 17:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D02D8E00B7; Thu,  9 Oct 2025 17:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B80C8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:21:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CDDEBD0E0
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:21:03 +0000 (UTC)
X-FDA: 83979846006.16.B46AD49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 54669100010
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:21:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oBbSm2sg;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760044861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSE3xkt1j7BQMxtNtf9uD+Jzu75Lr74bU9wmBqhA2O4=;
	b=afLXhdzWWkUW1mc7e4X3cGVVgO290/JcQWVAXpgx4P3Goj7iN1P4Y3mkHhnhaOGsVQqFuH
	LIqGmeKn1poyzeOwgkA+Vz7On5urPjzZlB8K4lhqXr+wBvuVrq1suyrnAbG928NRIVpwNH
	aMIdE/Cebw7FkWFNHOhi1y39jOET2P4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oBbSm2sg;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760044861; a=rsa-sha256;
	cv=none;
	b=q0OM+16X7sKFosbhegBD2kvnsQ2iMZ1fIi9T4DJp3MImUs2R9CkRN9q3wSDf/IooXP2Xr4
	QTAqT9EtjnRzZwYSmPGtEdh15QQJLw8fCdQzLPY7iUDYTt8zQs+jzx5ttGRF3/64pef0Q6
	ctclXgYOFcIKqaDHjlv+Du7g7U4TPDM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6706C481D1;
	Thu,  9 Oct 2025 21:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AF7C4CEFE;
	Thu,  9 Oct 2025 21:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760044860;
	bh=LT7SzPWNmkjozXj4ZRhtWHCKmd+a1TEy/eHu+98PlFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBbSm2sgSupxR4duimHSUEtMTKGebV5ysf2bamIpK2SDE/2Ok5vmMThgdHNAs4MN2
	 u/eUHUFGnSZWVTHQ6ezelpQr6nlV4CEyQIaLmwc88n0vXcwnTHct2Jh54jrFDkbc94
	 AOEDhWcbQstqmAfyVceckgjTRPiGZW7Tba6nWNwbbWOTC2fq733OwlHzB1GQhyPZ2J
	 rGoxq7OgmtZ/J5wMlpzPtvox+8BZuJQXkO2MEniKGb5oyfs9BKUJESeb/Sw++Zkpyt
	 hV656KabYwa45eOorPmUvwqrwg/Wl7j5EQvCio/Itqd4BIdv4aemIzvyPhTA0BRUwL
	 yP3gqKxI5HeqA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 10/10] Docs/ABI/damon: document DAMOS quota goal path file
Date: Thu,  9 Oct 2025 14:20:42 -0700
Message-Id: <20251009212042.60084-11-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251009212042.60084-1-sj@kernel.org>
References: <20251009212042.60084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 54669100010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 95ostmwker893o1k34qyf7yrdoj1hqug
X-HE-Tag: 1760044861-481446
X-HE-Meta: U2FsdGVkX1+NheNzlRKQaYev+kcUHPApLhvAld6gCLmR4WedDjL5EelJTHqBqNpXuG13RoNI2CJ0gRXV9uonnahqtYPECnQNj6TohTKMqndT0Q0tvwfIWzNVYeMjWSlW1GIlEnV0Rq6CCKyNMoUnvIIrm7OTySb2KCYvl73uVvAnQFCLoRks1qy5HCdqFxdrj0OSteGasOEPOBQIaDNCvSJFaZumxfsk2XEo3BwvZLi3MyTRQj9lni0oZ7AKEIdYGlOEAkbMKJu9NHVqBnPvCHbhuC48QcutBW6nkeQSY54Nk9v6UOA3Na/85GUrfoaMwVivtgkLYJgzNlcQqg8kfCQShss+/0uCKq8gOEXWTQkdtiFvMU0U8EGC4bVrZroutRgU7aNnh2I6zMs/yLx+0q4bSzawPhmOxZqCoLRe3Rf76C9WIw1XuuRAJI9sdFMUbc+mvb0iEe5OpcI414u5+4I1UxX5TjdkfjdvKZK5SR9hK/ojnONu0qiHlMtk9GwbWqheUkMV9Jrlbk8hW4qu32CUav//qqyouou7BZkznjMM7dfxmU4PDzd0Uk67ZQJ+cE5d2z7MHetMtQumiRjYuB3Gi7GufscSzij2zlYz7xtzJzdvRNP3tRUZK7sYReDkvsQf5J9s/rtUolBFer8CgSQ3K3DGFmBRP41qpTkBcWWt5S5M64eOMj9SGIarGsghZHWDBoEz57jGOKOUPxwA4inOHb5WCKpf6/CrX34jWB178+4HwWg5V+B12PBjcypF9GwsQc03H/e8HATlfUzPcO7NgXQEas7SgcqFyF6M+EypAWzF/a9liV6M7aW57EVJ+oVrQFCrVMWWEW4iyYERWJjhE586a6sjW2mn7nCDRDkGdFCuRUGcpCWwUu1D4AQV7Xm/vLuEfySL0ds2S+c/x/pr8piMzr/xc/9YtQOmilzq9oDjzaDNZUj6XLM1hobMiYk9qZJKKjcXUnxdD2+
 MZDhbISG
 ilycDgkk8vEBH8IV9by7RwBNJDuXQWcxVb2WWggov7Jltqyto+OOvGVHGvhvtUNjtSuwNErcgIjYXx72eN3NXfDDxPOLmothN6/0w+IUmEJTHVG2ava4jDU1Zav6NNOusGdTHB7DnAAHLjvbeKFiYp4whfgFHIDVXtuhUKv0jEJnsuxJPYTApKvZW2xEr7mf24Q/21t1pQ673ILzUt87QhqC1HBLKYTV05jSwvvv+MFjT76GyXVWXo53JdpTArj+9g51QTdVEq9+bB70SQmYL9MRF91gxWRQjIwk1/5KkxNWfQHw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A DAMON sysfs interface file for DAMOS quota goal's optional path
argument has been added.  Document it on the ABI doc.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index b6b71db36ca7..dce6c2cda4e8 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -303,6 +303,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the nid
 		parameter of the goal.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/path
+Date:		Oct 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the path
+		parameter of the goal.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.39.5

