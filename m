Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38461606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NoZ3pd5D
Received: by kanga.kvack.org (Postfix)
	id E089A6B05C2; Sat, 21 Nov 2026 16:00:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0B96B05C7; Sat, 21 Nov 2026 16:00:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B1E6B05C2; Sat, 21 Nov 2026 16:00:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 913846B05C5
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:30 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BF88A819F
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:30 +0000 (UTC)
X-FDA: 85460344620.28.06B9254
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8F2194000F
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NoZ3pd5D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294828;
	b=bmt3qmLv/yUu7I7634IqCBeSEjC4CMvU0xarz/GRR8IRLljZspHU3LvhgiLCbw9sl6erzI
	9szboWe6TR+zqMQrm6Pm1Eyjy6uASQknJyrQE2R6WdbPwFa5pcABCjk13tXSGOpTUmSfS/
	JMT1DUh2Q1FxyvDl8Js6Gar0ZSBQI1k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4c30zMvWlF/HAu21CDBSrVZTsdtRg90kDV5GhwCdMQ=;
	b=8JWR/euVYnTGDnv8p404ULUmcdcW3R6QaVMIuVzbm6fDwiAmUNF49hHOZhJdrTvFqGgbC/
	JXrxSOwLuTYia19oX7SDbI9TlwuzlHQiVIMQKDKRZsjF4rj5dWQIombIz8v3oI3RoJ0JBZ
	D40AmY9Mf71k5iRUZVd0aW4MngkozbM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NoZ3pd5D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E303D45985;
	Sat, 21 Nov 2026 21:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A201F000C0;
	Sat, 21 Nov 2026 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294827;
	bh=R4c30zMvWlF/HAu21CDBSrVZTsdtRg90kDV5GhwCdMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoZ3pd5DedxSdMbRV5EdiC19XbuqSRej4mObs9VCdwTj+8gbgxUF3QWpALHpZVM3H
	 +f3XAUwWm+Sug8JQfcOPFJ8ogCqKBYBZ+YFAIAv6JBwFDM6WTwMSSTqKB7DLnBbmxu
	 7V9vZdnhMuD6TtimhatbZtEEu2CS66RonZ3jgK6NGRENPHDtfd32HQNLXp8UpYA9ad
	 ppSiyhhs/on3PIJK1ARMyv7yHZhj9R9IQLwK4Ab8G4JQczAkFIVQZ+d5Q6KuzdaFaT
	 m+zWgsCjwHgNZoJI9iY4KvL3O/HJkGDpBWp2ZBds+zFxy51Ozw/kU4ER3tpYp05y16
	 EDw7KQtlAxa3A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 19/27] Docs/ABI/damon: update for REPORT_MADE probe filter
Date: Sat, 21 Nov 2026 13:00:03 -0800
Message-ID: <20261121210013.130397-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8F2194000F
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: i8ihea6jdx6pp5bb4684azu5wwbnu8ss
X-HE-Tag: 1795294828-990027
X-HE-Meta: U2FsdGVkX1+9v39Euf8tWUau2R2snsMOnIs90aQEkBwePBtV6Q87Dic+XZ08fBdptxZ7z/q5T/dwsuxB8Wse4TBL/fC+JLFl1Wg4yr3AT3R4DW4Q2ol5jUzRcuxUFJBmZxDBsOLaftkRaa+0MQVjQKeHskiWJgEeL6OAQ6zQJHHn72Oy6JhfX7uJkaQy18Myj4A284tK4OGQzmMibnTi5B79f30QCK2khfMIOonupWGMpPv+4Lm6N6jowozV65GjvyNTC1lIP892/IKZs4lCMdIlJH/9iVhwAjA8ba6PJ1jmezV5WqS6EhKou9qotL03SfWRBOcTqSHrLvTfYkFMmueXVnRGQlR29Yt8x2ZeiznfZVg/XqX8XuWc0cyhXnPTJQNjMH2c8lCd7XzTv1S/8XetqbMAoUU7y0kNxxB6XSxve3kjZNoIdpuMs/aODx1zA9Zm0VRiQ2J1sePJ2wSVESOoxUZHrQNB5nWCXkupsQGBtnkJHDmDtMAzh4PnJSvpbh/RlJpbuHoyrBkndhq4SicudJL/DKfg0wpNfwFuBnKgKL1K6RtJrrX4tWb4M4FjzmmLfrNf4PG/ThuTrPpipHa16sihBYTOgomZXA6vPKcw4S8rieUEIsVv+qYeu7O6GySM1H7UEXiD7HYMWtIrq/TWQsjaED/FDb/RvmTmrFuPDI6H7pGT1ajIRblbJ+NO1sCCQ/o2GnOp/XH9syodRHos331jY58lJAww5tuPtk5+xla5Ar6QKSLGjWQ78W67o7Luz8LSATAkw5VkUNxvzI1RgWH87szXx558iiLMBU80nR+7QrxLJyrXfkWZvMVE+RT7UFjPy1+EpwA1QHyXZrkh9OFINejiDamNw8/ba8c1n40Pwit22o4UIQ8qf9t0YokyeM+AxmqKGOEQHjEnUAvwRyoVlL4jq1tXbgZNN5dwwtR00KbQNOGFJcGQdI6Ib1UZI6/QRkTnaCf5q+M
 cSUZpPqW
 M6QeTPrg9hPDs3taVi7BFGHsI1n2MHCmwylFkoXXmde6xmSjwhM+OAcibsPFEGqyHVfFZHo3g5lMLm+maf926o9HQoQas3nkPcCunQRWipRsehP0aPMdrYJghL0X8SN7kPaN5zKizsSh7jwTs6FR1EKjPP8EjqdSGPIQmd0U+Bpr9euMUQaATW/9SBz40to5DjPbdFhMuhDJ0BFF5kQ1p7MqyLyJWtGeJw3FgLxq+EQ32Yz3OdFDMEbxN3/oqAfeRNjkAETmZvhE1n5+VqX+8KEsaTwJj4Vt3/pghvzhazgCIlTlf0T+igjS1iKZK/Z/BswzRiYI739KaHY1ihSu6rjjEMmuLHLUFbtzvMPRS8P1S9fh5LqvcGDQGlO5dSP19H/YHsbx6GOh1bS1Q8enCnjmPTo9JyqvWgOQjjz034kHg3zmehDUA6NuYBAQyT8znMDiIWTAbDyOyr+pyCfDXfRaGBfvqm6tdMpdKB18O4r4X2wJsmzHj7UrDkl90u1/oWVLQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON ABI document for the newly added REPORT_MADE type probe
filter support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index c9f718f126c70..e558dd4212f2c 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -233,6 +233,13 @@ Description:	Writing 'Y' or 'N' to this file sets whether to allow or reject
 		hitting the probe for the memory that satisfies the 'type' and
 		the 'matching' of the directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/filter_report_type
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'report_made' is written to the 'type' file, writing to and
+		reading from this file sets and gets the 'report_type' of the
+		reports that this filter is working for.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/nr_targets
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

