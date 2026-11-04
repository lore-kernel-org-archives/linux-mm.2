Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C4DC606D81E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HyzqrSVQ
Received: by kanga.kvack.org (Postfix)
	id BBDC16B05B8; Wed,  4 Nov 2026 10:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FED6B05B7; Wed,  4 Nov 2026 10:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C3E6B05BA; Wed,  4 Nov 2026 10:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72FB56B05B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:37:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6BAC807A2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:37:01 +0000 (UTC)
X-FDA: 85397839842.14.BA07184
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1696340009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:36:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HyzqrSVQ;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793806620;
	b=QDhk5BmDfjMBBsPOvt5qi9GrDyUx8cO29dorIzNoO8P5+czRfzdWIoes0HIbV582q8nMPu
	H2C41sZ5+2vKA9LsVrI8SuWk817BcFwXOn9eYKRmPtQDhioIs7vE2gMNqSF7d5uReokWja
	+lcGGzqTzxmMOcvTuUGGi9gWvYChpqc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HyzqrSVQ;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793806620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAbRG5nmi0Dlv5LNX/DTzBA1Q08jKkTod4f3ioIPBRc=;
	b=48k1nvK9hF/oHEHDdfWwi6hAk4NzIlTnQTikJjwKv1MKkX5PAwNH9NyDaLd/zC+gdELfHk
	d/ylLVttWANO/G7LDzIdawl6PKXz54sg6Mw0qfMkgVeSlRKRFHdLg7OqYI/v57dCNBrA+B
	5uc1hPn2AsBhUdixRckv1+t74pzTx74=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58E3E418BF;
	Wed,  4 Nov 2026 15:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176BE1F00A1A;
	Wed,  4 Nov 2026 15:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793806619;
	bh=ZAbRG5nmi0Dlv5LNX/DTzBA1Q08jKkTod4f3ioIPBRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HyzqrSVQ6lDvRB+5carwsfY5/dfrCbS7b8YgwGTw+pBn5RlmJZ9T17x3henuYRi5L
	 Ksvj7DvUvcYMH1RhFINlCUT1yEcevTW0O8n9nf0sERVp83bXd/Sjy31EAtDT0CKbh1
	 DWdMhzmFPeOPkXRQHYMmtVzJqvUofOzezFCJxxHcvsi0zeEvOJhxJFJUWnlVloT+In
	 8OnTcKVBg7bm8r5G1iCyUqHbmuChCdf4WPNAoqussylpLr8/yIo3FiIYo+jK0Wi3Qs
	 fUI8Nj5oJupXDIT2pecpEQSihhf1792kFBD7EB+TJkh2cAFoIRjsEsznE3i5FLJbGj
	 oBTivY+pTJHBA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/4] mm/damon/sysfs-schemes: support DAMOS_FILTER_TYPE_AGE_MS
Date: Wed,  4 Nov 2026 07:36:41 -0800
Message-ID: <20261104153645.82945-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104153645.82945-1-sj@kernel.org>
References: <20261104153645.82945-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 77pmhed5c395atuywh131euje1me97si
X-Rspamd-Queue-Id: 1696340009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793806619-209060
X-HE-Meta: U2FsdGVkX1+CqLqVBJea1u85WMlw0s52mphGY5w9klqPIFAK7hvzIxY5CXCV+IMWzv/ed56VV2dN2bVK70gRwNtsAJRTeCiTgHkWyQDUfLy14xJsZb8XhLVOR6FbSRQB1b6U9qA81jbGrwFfFIygH1lUVb9CpyONJK1vEnPV0QFisRPSKeJ8eeycsP1rhjbgPTuzdcwgizAJpuYScuNA0OkKctGcBxKLoqm3SM6gh+WFAtjaFQzVd3FWANTKEEvUBIm1oluJK3GHVmswbOzIAABzBYT2Z0mmfVZXukPenxFQdbXc1C4WlnrNn35xDv+kxJxMGtAia8nCfFSHVgJTSz6vXTGKGncsSL7FZqF9Y8g2EHAwGsr59K19uP1Sx9wqF1s9bqif+Yrjv4pdohwio6J1EzQ+6AgxrieAqpTJphX5xKCV9LHMDE98YnWrfhTZ+rse1WfK6LYn+3S4br+qanWbbVrPmmWyJTL616kAu4BnGNp17Qk4fvD/y/5ZHWDb5e0X6zWWD6sk3heVxgbMVlKXeDmRp1irwKjAZnKApfu9FUNnq1zKnjpCPc30hjZ3oXcG8VYv1EFXZb9BbsZTY+5ffGLmlzqrZGzfLriwxGuHS3Lo9mk3LLhgqZrm3r0ib3MwOE20GNv6tgwULtBS/rfFiq0SNnMlT5GDWC2IBXd7SfuHx/pZH6uoB2OpmQuA8jsQV7yxbD3hMJldxsueMgaXHN/3PGVwMl5vsE5U1XjcWtqjuH56YpGAh6qsQu7Bm/8JIl7z6VA2W/LqEtjLtlEwIKIyMtcOq9IWZEy8xDjsTRkPga+BOTbptIyIUO4Y3GmHtE3zIsnEKtvv8860PJPaLEzbRw57WfR/MW/5IFUSGu6k8PRc74P2EllWrZZWy4zk8xjAStJDoxKz4Gu7pq/w8pynAFmly67V76Q/rnK8HKIaDBI4WLe9S8wmtLICPX31G18w86rAM5BJtpK
 ah5VCms3
 tF1Hi4dAYHo+pVnJRPMPySbvIL9agddSWgCA9jVv4DnsaFsi4LluR4LFEAib0WJ0AQATdE/hnN5IasbMkul2GHnbls25bYbaJXYUitQkOUVltjTcLY08/LLe8Pmq4z2NvtxswqjmTvxGbxlJEjJ2ngnnVr0x5Ee13Sy4rtyTEiqLvVBQbt8whvxBPjf4//AGOUxPdH82FURzuloFqSJoOAOsDTKBUCnYBge8wqEMdo8kPK384SnnztvlxerO6n8poiSh6a8PC91hp24mVwbz0+5wfQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Support use of DAMOS_FILTER_TYPE_AGE_MS via DAMON sysfs ABI.  Add a user
keyword "age_ms" for configuring a filter of the type using the existing
filter configuration interface.  Reuse existing 'min' and 'max' sysfs
files in the filter configuration directory for storing the age range in
milliseconds.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 637f1bd0c950b..230987efac3ac 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -593,6 +593,10 @@ damos_sysfs_filter_type_names[] = {
 		.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
 		.name = "probe_hits_wsum",
 	},
+	{
+		.type = DAMOS_FILTER_TYPE_AGE_MS,
+		.name = "age_ms",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2875,6 +2879,7 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 			filter->sz_range.max = sysfs_filter->range_max;
 			break;
 		case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		case DAMOS_FILTER_TYPE_AGE_MS:
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
 			break;
-- 
2.47.3

