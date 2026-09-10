Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E6B0C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4866F6B009B; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BF2C6B0099; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175AA6B008C; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E13D86B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:03:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 736111603FC
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:31 +0000 (UTC)
X-FDA: 85196508222.18.A1B7873
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D6881C0007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EE9Pf+qI;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LMfK+vJvFqvjmpgUK8C/JqVd+cTrrKRqz+a3Phr1zw=;
	b=7B/DYawJsYb87x5WLTPyh9L2cBVbZRdKBvpd/r13rrA5vi9pudU1qwwX2VtoGq5AK2WYMJ
	iR6oYKjZ+UP7E6Pl9uLm90NyA+xaRqrjCIFwixSYktyzQpmgGtajrkU16H9P+saoXs6jU0
	4VNspzRSeAY6KK9esmNOgNC27hOrjQg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EE9Pf+qI;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013009;
	b=RLtI970gcOmaP4bq2iX7lOMgVlSm4EL4COlK2T4CknTtmWlzhCpRG5gEyKvYOsujdD+3RZ
	uO538iZ2d6HNf7vpjVMHXU1FCIVXopO/fi2CCN0JHNkFhFwPDwD0yitjnk0NjxKJyboLA1
	UITWaLlJJusm9SjgIVpkffyiYl24kmM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C46D43C66;
	Thu, 10 Sep 2026 04:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33881F0089C;
	Thu, 10 Sep 2026 04:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013009;
	bh=0LMfK+vJvFqvjmpgUK8C/JqVd+cTrrKRqz+a3Phr1zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EE9Pf+qIDe7mc+OWRcmkX3VYHDk4wReFNR32iCeACl4XIoOTU6prtmMiVwstXcv75
	 XHOV5aRK8P+1Wq+SzQfsMiTpQKwaSNPiNeizvT0J84KpF7cLAyaOPOGhmxZqvMMpNw
	 VQUhmHcKtt11GFH3eIUQM6O/Tukur1+s7dTftzt/Js31eM/MSkgZ1F9TLWozRhd4Fa
	 i4luehO5dD1mbEEUG3E+EH4puQuf5GKmBlwwGax29P/P8J1BSVtgTiFaXzBSXwsLHd
	 5Yc7a0oxZgZ4p14WnzERAF+OVFrgguuDNBAzkVFHsTFU+21JF9oc2MdhsfqLCe7T73
	 bR7Ur1atFl56g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 5/7] mm/damon/sysfs-schemes: support probe_hits_wsum damos core filter
Date: Wed,  9 Sep 2026 21:03:16 -0700
Message-ID: <20260910040319.147037-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910040319.147037-1-sj@kernel.org>
References: <20260910040319.147037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D6881C0007
X-Stat-Signature: ebq9n65fafcu3359hdr78qescauwo4uh
X-Rspam-User: 
X-HE-Tag: 1789013009-596725
X-HE-Meta: U2FsdGVkX1/MHthinCCJQNr61oXbPEEstRwlTBsR42Tt93z6LFBNgN7jNJONihcSVFht9KYz89HvWZfhwmuNGK/E9f6GJvvNog9CaEQiI4Dcyo8DSLSQ74Di21WtX6zIaIJaU+8jRXKJkBVnvJZcFXNQ2Isx6L3q5sxOGAAyH/jltTtQ5fvVVbwoKKf7CNDNX90mvhQDFW406s2ulijlxEgTaE0yZSL/TNArquWOjDEw2sFOdLdJdzglR2sh8ArjZWMJEgD4uzj2nnnItfnEo8lQ5qTIaw5HeqTDEsomaF1lacPztvqZ174y2P/8Woms/NI1t4Dc8lbNgHDOYJTYchRC2C3noMNLRzEK9d6GvLN32uTh/ndTbbv9zPj/cjSao6YB3oZR4s76sYgqUQy4uHZ/BUJMmWHDYm2Ins33WGU55lz+53QZJvvgFzq1t6BvoXC03m6TMkYVtz+qOLaGLa9lcA8JKl/2AhVVFlaEHgBKKJaM2oCu4KjnpoJeIWOBiedifBlqmHIorvT2Ap7AlR+kuSj/YSJ7Z8Ccfu3VmBSVegCKm4nX3JunHC8zutDqmuuruTUmBpu4rDk/mbOtVXk3FDdHF56GoFpjqQnegnEVqS1Xsq2BAWX9chItwDZrXIbYXi+OHxlgMMV0xvfIa4yErCVUBodMmBqQYgFRAY5WDQ2dQk/cCtmCISgqJHKnG6Sh/fzx51RVPF80Op8G8rPhF84zDyApVvseEmxXGfgvKqgajmBrd0j72yAHiedsUab7G26/uN8MYt+UQuzgeKqh575kitYWKB+BPqE1+pkDfigJaGtZum7bTLnbSnYW4qpU1RdZSeZrP1kawlProVla6W0ukAEyEsBgN9r9CdfP+Euj/l2rHYVgOLsCUtHXMGjNiGkphpcEmFewyBGfbMLPG8Jf7kTkPDlNF0J+Us3t9kRS5wPuY87kowTotJe3tFafMbCEJVbqVBzsvng
 AxeMw5sQ
 PIOZ1K/MhtpuBdzgE9pL4Y8HS9hXr0tMovsp3UKb+i19dEf2enIMDM6CYjEdpZ1yCZtDOi6M/KhH7G9VRnuB47e9gsdatz7XKpRQwQ5QxTq+Z1/IF0Mat9Pfv3hFCsZGeuMpnQ5gxoNhRly7LVEQMmOfeNCRmxsoie35bYrPj3JhiY5e25T07OqF9JIdFfc8yak8Nmr2/oKVUpqH9Bp9ncSY/hi25u44syD8r7SDwoDhqIlWwDCt/+W6lS/f0J0x679QlCdNvnupUYLy6B0x10gVk0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to support probe_hits_wsum input.  Also
update sysfs input based scheme build logic to setup the min/max probe
hits weighted sum range as user provided.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 4d9147d2a269e..d9dd4ee0442c7 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -589,7 +589,10 @@ damos_sysfs_filter_type_names[] = {
 		.type = DAMOS_FILTER_TYPE_TARGET,
 		.name = "target",
 	},
-
+	{
+		.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+		.name = "probe_hits_wsum",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2844,6 +2847,14 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 			}
 			filter->sz_range.min = sysfs_filter->range_min;
 			filter->sz_range.max = sysfs_filter->range_max;
+		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
+			if (sysfs_filter->range_min >
+					sysfs_filter->range_max) {
+				damos_destroy_filter(filter);
+				return -EINVAL;
+			}
+			filter->range_min = sysfs_filter->range_min;
+			filter->range_max = sysfs_filter->range_max;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

