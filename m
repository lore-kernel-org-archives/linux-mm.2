Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0460606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XaIq6/Vh
Received: by kanga.kvack.org (Postfix)
	id 17D6C6B066F; Fri, 13 Nov 2026 00:17:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154846B0678; Fri, 13 Nov 2026 00:17:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092066B0679; Fri, 13 Nov 2026 00:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5D2E6B066F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:17:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAACC140B77
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:17:22 +0000 (UTC)
X-FDA: 85428937524.10.F918BE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 135DAC0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:17:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XaIq6/Vh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794547041;
	b=rF5jIlNh+Rf5IE8cCA21P8pBkooLhyheYuMAj3nLgETWit4xLeQFVqsIgpYP7OLWQ5/3nx
	2F9DkaasgEFQY5ZPlD08kz6YLGKRtxAK0vxIAHTw+E0bPstfNZaNfjXUbPK9q3Do9UPjbE
	RRmR0XhMFLegWcEvaumB48rRgmCsG/I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794547041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ES0HSLcfEcyNCTf+df1YGGr/NbZ75fBTnOENrmeTXX8=;
	b=HNytmG0SNtS8IhKnRG4HQPxaNulxielnG2wiGvDkuS78DBd8jQ1Y5OJMAut/DVqMCEDysA
	kApjesXx4f5jsq2UL+I2mKemLR2ze2s3G1D7K8glaHY7uxBMJOoMeePfaD+s++E1lN3vff
	L8CRwda12ZHrFVYCuSqFzBmoIqS1e6o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XaIq6/Vh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EF14437E2;
	Fri, 13 Nov 2026 05:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B091F000C6;
	Fri, 13 Nov 2026 05:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794547040;
	bh=ES0HSLcfEcyNCTf+df1YGGr/NbZ75fBTnOENrmeTXX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XaIq6/VhrL61o7pv5NadaXJ9pccIuJN47KjL74YT95MNpc19DOX8BKPdtJ3XEWxww
	 ccL4NS6L88QDKEYnzh0kp+z0ed028kCHmw4oKpENwNGEH9odWdbqTDnuCQb4WYK+6D
	 9go88kC1BCgFiNWao/cX3kTCi4s0wGcQx2yfJq3Tmonsa1ZrUC+cLadArFa8RH7MSB
	 o9xJSIpU0EADLlVU2RF/7KvxgRY2YzALUIVoElAkFX63Yb43eoZfRnS/xr0IXTMjgu
	 GGBS1upqk0lODyMU/zGzlQfMPMQ9O7dkiDFV8Za0RjwGU2Rl1ug0yawIvbu9ci28xx
	 fJmJm6VxTuoWw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/4] mm/damon/api: define DAMON_FILTER_TYPE_ACTIVE
Date: Thu, 12 Nov 2026 21:17:07 -0800
Message-ID: <20261113051711.89274-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113051711.89274-1-sj@kernel.org>
References: <20261113051711.89274-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 135DAC0005
X-Rspamd-Server: rspam12
X-Stat-Signature: c7opr3ek6ob9bp8bgzde5g9nj1xbw3km
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794547040-66230
X-HE-Meta: U2FsdGVkX18utL93TGMAJAThtAGqlGLTVwA72PmRW88eGB/IX3drdvF5fIivDmJ6OAh7t7k/MWMOoaXIy7ixd5X1WtWMJRFpoNL6rjJ64YGfZmhSq5g7QjOB+ulwDXzmJUGylFOXjLjtn2MGEu9IcUObHvKS+PxANU360/Tp36ChBClSIvW9/XINOJLkU7bTE4qBJUZ1+cFBXr4arE52/+yTRFgLvvFHd+42+eh32SPLfF6A/KpmCvUxThE8a4xJVeuYZp1/+LaIOi8Isgt2R+FY/iGBBwr6JKRyrpomxM7fE9/JUlnE+bacjsdBk09bp02uU7SF1JIUMK7l4TDgj+SfvCNXpTon0GMDj8d6opW0hULS2CE6j6jeruU4m9W9xMLqRnoG/nRcpBGcXkhM3fCE6Mec3AQRzbdGw0ZuCgjf706018bDWRF11rwc+0H29Xgvrag26fUZoQ4elluuoK5i6QJKRuH4fIZDTMKnCY0e3I1Tb0ZYR21SAV9S86dNtsvi4KGljJvjTK9vI89aXqYOlw0ApkUR6slLa+FNFycrhWFgftAKNlqFdO6IP0BYghNwgnE9WZxbsx4D14/f6Bp8bCVtmCda0DrDgp6ouA+88vKq3nQbc6NJrPmgl1BzYxOg6CUFEkVNbjM70VMSG+E6vVL5paVsh6c25fwccqECVafmofwUJaV9J/FOcfpdezrhL/+TssJO+xRYS2G+Ra0v1nmqPvqZnkJ02rF/EdRMHrKC4zGPnH0HIIJSAHDRpCPRNm2+niq4FKfdMvBmt5KEjooejKkzaNqfe40hflAhPZu0yH9NtEQRqHq/QoZa0jh8Bqh5/8aKK0wd1mYDkJLAoZIYV/xUtnfcWnDl4RdEWTSuQQ8wa5HsktTuGw7lUvutnQj7bnx+S+bLLuXXn2Gor+Et4vSyblf5zO7dQHiNJWlL825hWT1/zNBo16ARl6V14bGbYU+HCnCOAIi
 43uHLscm
 2tsg/hkFxur1fPaEDAMMJYiuqo4OkkQjF2vsmjHlfXxnYVLogRrKCtdmjqqbuB6+5O0qd6MQeKTLLlF8kDMKRVgHMCAexX6tFK0YLPFzLof7F7/pz56DVKMutLO81t6kPGdN0xm7eL0pPGQ4Fv4d8Xuq8hhZN8RUt44PutTA1N7ofoyluJTGqIND6yvi3Cn6rK7DgmoDHxcRCFAqeqI/kjUO0vo6WAsqZsgddlO5WKtEu2fKKj8yd+B3jz9A9wsog5uysHWDdbHmMI7uEloHsEvIvYTMHLx3bXikapjMRRqY5VoItU1bxPYFLsv6ylNANwPdo8Kep98e99ZbadWEukCeeC7HstPxJe+spXedblOvBv5tFo53SDMrcp5MDa+dEvIIrc8uDCnHZwQb/j3L/wSYY8b6qa+Sb+1fNw3/txQF3eGaTidh379qaCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Knowing which memory is on Active LRU lists is useful for understanding
and optimally operating systems.  Extend the DAMON core layer to be
ready for support of that.  For that, define a new damon_filter_type,
DAMON_FILTER_TYPE_ACTIVE.  It has no additional arguments and therefore
no additional change in the core layer is needed.  Testing if a given
memory is on an LRU list for the type of filter should be implemented in
the operation set layer.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index c32ef79c3acea..06bd92981af21 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -780,6 +780,7 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
  * @DAMON_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
+ * @DAMON_FILTER_TYPE_ACTIVE:		LRU-active pages.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
@@ -787,6 +788,7 @@ enum damon_filter_type {
 	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 	DAMON_FILTER_TYPE_PGIDLE_SET,
 	DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
+	DAMON_FILTER_TYPE_ACTIVE,
 };
 
 /**
-- 
2.47.3

