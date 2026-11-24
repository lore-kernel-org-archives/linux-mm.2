Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28CC606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UKk60pAG
Received: by kanga.kvack.org (Postfix)
	id 202446B0765; Tue, 24 Nov 2026 10:36:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9386B0767; Tue, 24 Nov 2026 10:36:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1171C6B0768; Tue, 24 Nov 2026 10:36:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E41506B0765
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F42CA0B1E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:53 +0000 (UTC)
X-FDA: 85470415506.22.AA7A977
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C5DA140003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UKk60pAG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534611;
	b=DcjjMT28FZIZSB+x4JmZZgmKzf8SNjLqAMHUov0tmd8fKicr0utAcz8Za/L4fLstiJjq9A
	f/5FSd2+ByoRk5goAkZBj6DRpNhAzgZPgXAIQvg9IJwLrhu3N+XXB20mPgprZG3aCLR0Cm
	7B9vtjkRCz0udSnOHISUMazR0fCJMqc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ptv4jOAXRZnBZ5AEQq8DinI9EbwsThp4y5iPRRjm17w=;
	b=tGLGxwQxSFl1+FmcjqDMmszc/W6689jf02Jc8CYYngRX3yvoLcJ5DFgGTVjkZgg+TL3gJ/
	M+hPOocSeZOMSTxt/oL0IVNMznyubS/C6hsplR5/P8LOZl5lRBVcb1pso07REFH0+xOVh9
	wcptFrv63seD+mJrmEl2TTx8uvtjWHE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UKk60pAG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28CFC45AF2;
	Tue, 24 Nov 2026 15:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F28C1F000CF;
	Tue, 24 Nov 2026 15:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534610;
	bh=ptv4jOAXRZnBZ5AEQq8DinI9EbwsThp4y5iPRRjm17w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKk60pAGDh5L4v3L+u9Q5Y1hz3ltvr3bLxQPUjl1NuXsleEZEAKn4BHswNJmgYHS2
	 puJYwhMZIzFsG/bx+fp/z7KzFXdEuPYBRIGuoLFj52dS8JkIw+V2qwIM/9r5XoSaTU
	 4SlSR7wGfaIF2i3wI/e4oMupDdp3bijVZB/GHrnpV2/Mdde9DHGlMENKUXEaE5Q3Xz
	 RGNK5R/gGd9u6gFmkBEWP1lxIrNMUGm0lwDro2yqAUmjWqHBNSbRR2yBJEIfpe2LCo
	 GtdU3ppiSks1GFB9yYZak3RrNxGrCi0CJcPtPr5/ntauKU4BmIHUEklax8NOSNLe63
	 da3M/4zxcjkxw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 09/27] Docs/mm/damon/design: update for report system
Date: Tue, 24 Nov 2026 07:36:15 -0800
Message-ID: <20261124153636.91854-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: C5DA140003
X-Stat-Signature: 181yz1747bhm34ct6ifxfcdqj1nkf3ux
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795534611-328310
X-HE-Meta: U2FsdGVkX1/Px6WHkUjQtbyPxmUC333P4n3OLel02HSMhxs4umPAX34OQSa1nOzKP3jd3vcRiozupAP/U80DD/3te4ID6Dbaw8EWal68A/4zUtS3Fg+N+7+dgCmDBuWvK3cb2RVC0ripb5UZaEgLBr21lKxITPaxtQnWsf4CSEve77QxOZR6517Fy+u8IMM7r0c8nRRsQreosjo+a4ZFYUM90n3wfMBghiNA1HmeAQWu+Kz+hmE8r3291IFGAS0cTySMaXDYdwYP1kZyh6vqubIsk4mbM40p+O3aN72CnG36bNC19mbJuuctJ4wIDh1QxacdNFlJdBYr0Vm8yuWxGkXLGrq61Yqyco5UpaP2g1Co3unVPQDL0cfM+t8SMshUU7mZ+Wx1hx0qbN/OYgAe+MEjW2pYxvZVSVGNdPVJ9btjI9vstqihWj5OkbyeZSRJHGVuT3SEZvQRKAyk8hGbAqd7+2lrhuQQkgFbmByer9G/2mR+wegOPBhJyqdkGdnFDVJC0xKXr4UZeh6viXCj6ov8xb1jAqzUNbjahLukwwQzqT+xP9RVoYIEpcIOh1wcJnWLx7xpil1eBLhRi+c9uwN3BPoB8MU57Wg+n5KSw9DxtD/baBYhCvzrzaCEnVpHGPD/IHxThde95z8potN4TOwqSjck6HTxumg1Ynn3VUMQdNsWveCqaXCMZ/Pfda0KvvqkevfQFbLtQtdAF2vJZUdHed4mhmZAV6iVa+tZGXC+DWi9sjbKVHW52Ooiw5qhDQWrSCmyznQi4mGcn82Pscjp17hbhjgoD9T5k/QXgoMrm1yKrQMvaI/kjBjSeNVqisey9jHBK65+xvLA3u9Q/CTYMnvYSTITws595KrJNnjkn7ySxOgETTwGsIzn7Bf7gwXw9e3jwnS3plW6BnTtJlTNdX+dXlsZgGNurB+tA4XC5/87GpqOrPUkUbGOBCAzwUHz+2bPOAidtzMJVVT
 lA6dPSD+
 /bWqKHI7QgatIWgRmZ9OhfHEbs9URpmNz9TaHSuauw6C2GTP/OZ2jPdZs0/qCoxJs7tXsQDOX1YA99ObNjxVU8oDsvuHJvcl5W0egJ9bhYsdx+6TyqLyUO5WVp3hiEuZe/JkdLIPXC/YQ6QWhevPq2XtPd8s1sw2K0BCiPF3va8bgswI0TX+D7Y6nXQUX1I4jvQBbsJMdhyN9s2YuYjo9bfaAObLtDZvDPWEWe3IlVLGsfrrdwdZ2rCb31LPou+F+His4sU8+nMQnuLkBV0Egrj52HU+MKPfJp3dWDBjMfDxPQFHB6kvVgcMIS3LhpMhFjetxEVUZIn4mIeo79ob+BqYjbrhz06f3IROenm83z3zW4602OydbQ07PeQo3qMx9bQhnvmYBHxU7WQ+u9D5ZbWhy63qkY92piTupPlemPtO4DlLC5IeJjTxkW9SrXt5UVzCD1P5RHFUJUf8ux6qDSuFU+vySQGyizjtnNHmcDPYLUofSjcYhvPbVgQ73XjCLuD1Wx64xG2hl8k6Cf4rI9d16VhAclabgagUWUrTuXDyWCoW1oM+4k924OA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON design for the data attribute report system.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index ca8fbf93d556f..59dba2fe0dfbf 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -356,6 +356,32 @@ monitoring.
 Refer to the :ref:`admin guide <damon_usage_sysfs_probes>` to know how users
 can use the mode.
 
+.. _damon_design_attr_reporting:
+
+Data Attributes Reporting
+~~~~~~~~~~~~~~~~~~~~~~~~~
+
+DAMON-external entities such as other kernel components and users may have
+special data attribute information.  DAMON provides a system that let them
+report such information to DAMON.
+
+DAMON provides the kernel API for submitting a report of data attribute
+information to DAMON.  A report describes what type of the report is,
+representing the reporting data attribute type.  A report also describes the
+address range of the memory that the report is made for.  Depending on the
+report type, the report can have additional information.  The report is saved
+in DAMON's internal queue.  The queue is automatically managed by DAMON with
+its best effort.
+
+DAMON provides the user :ref:`ABI <damon_usage_sysfs_reports_producers>` for
+configuring report producers.  Each producer is configured for a specific
+report type.  Users can dynamically enable and disable those.  When enabled, it
+can generate and submit reports of the given type.  The generations and
+submissions could be done automatically by the kernel or manually by the user,
+depending on the type of the report.
+
+For now, no report type is supported.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

