Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 800FAEFCD9A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72FA96B0088; Mon,  9 Mar 2026 07:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2F26B0089; Mon,  9 Mar 2026 07:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594486B008A; Mon,  9 Mar 2026 07:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 428BA6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:08:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D351686F62
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:08:10 +0000 (UTC)
X-FDA: 84526250340.18.B57FC1F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id E395E180006
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:08:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=lZMx0HT0
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773054489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWwVHwhFxPwZWzEvxtvZzmQI5X0pdoxE0LNq0dsk950=;
	b=KGpJEiy8GZ3W2m5uBubX2uy9edBU48uoKxPTniaadB6jef0+FvLoboZlf4PwjH9iD4cxNI
	nVhFFl0hZO7x38dIFoYDhd6oYZ9HqZPScxqud+jWrRIkv+vE4Kn9in8TyzszrkoVwK4pcm
	Gf2GnTlKBp/DMJSn5jcFz1fXuryFPCk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=lZMx0HT0;
	spf=none (imf24.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773054489; a=rsa-sha256;
	cv=none;
	b=R+m0j6rcjM7CNVCoL6GLpUEyU1s4jlN/axZVgXfDxVxUXtzvo0+Hf9bbA8dr2oWLtNM1gY
	hSKAI0s3hCb0631WpEsHIIkYO5lQqL22YBtA3Qwjv4Q8io4mw7gXpLC1u2FChVc/9M5gxR
	agIRT9SHaF1dsli3weXqag4TJCRG+Ik=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=XWwVHwhFxPwZWzEvxtvZzmQI5X0pdoxE0LNq0dsk950=; b=lZMx0HT0Q9ge1TmDMeF6Btdmqq
	GrfpAcpyPbQMCedySls6W1fihtN0AIv2+Fc4Bj9aG3KS9xNPrLPiibuF3KfQi+x2clCOo7Zrs6RVX
	scbyNP/vNzydyHoJATfCxkgMOnE70nXl1ebjNEdpTwuLfzHVRgqDX9Pe+Q2WeHVdMGRBj43ylX++M
	3yw/0gY2MTZWV2u6fsOC0z9OJ+rS2Cc8fZotsoLqmqWX4wNWO7EqUyDnsQsSllo6w+K1MDz+Wc2II
	moXRu5PQp28dG9P5RA32MlEBkFKN77mYhtnrPu4JZx9IXruQC++CKfVOrxKrU9P1kyHgbTUsB6aDq
	Lra49Fjw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzYSq-002AwP-T8; Mon, 09 Mar 2026 11:07:57 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 09 Mar 2026 04:07:30 -0700
Subject: [PATCH v4 1/4] mm: khugepaged: export
 set_recommended_min_free_kbytes()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-thp_logs-v4-1-926b9840083e@debian.org>
References: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
In-Reply-To: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1306; i=leitao@debian.org;
 h=from:subject:message-id; bh=nlToZmaB1n6dDw+eMzdYWKgFtlcgYp+PAKEi0NGirZY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprqn+JFWMLGaISD8obUOaYQc/aBnqki6WkYp3Z
 73Gt940yJuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaa6p/gAKCRA1o5Of/Hh3
 bQHoD/sElmky1V9utSUmBeA264BBtdY9tgT9j0rrkCA8R7RVXS3kjEmR3KPUj4lURA9FO3rxkMI
 KSGSWdJ6YtkEy3xkhIznu9vGkGr0ZbNLNYA1cb1YWTU0ygEFijHOp6+OD0e9OzXO22phZG4wTkX
 /3SeXP3mF0dkwCfoOF/CxUaJBSydOxL9jxqvA/V8Q2C6DlOjiYiwcLtJG6MlHzFbEDRxGI7TIOg
 1Emq5TQPeWj1Z8aThJkZ5LPBwzHQR5qaqb80v9EfaY1PryzFFf65xqFuKcQ+eyUV4kg6Q4kK60l
 ip+n7Mgw85UJDic+S9aPJRmZf9z0AOVwTTXs4kRPGQOOFBiocr4S6qQvMna2NKPNU0Uj5Ar15yA
 Q5apSWZ0/Xy5tLyu2+yI4Y4Lf28UzkS444rBTscC9RTHHOqYA6n9S4i5yuWS/C9TVf0msE4mUTn
 zVm8B+fveNNunLNQr9y9fU8D00mr3PWM88nvhZjLKHzfscx4cYl+50uR6lD8fnyOJiGw7YQMdky
 v9lyu2jEM8JxKR4sX1GOLSZNuq+Jk+swNb0O1Px5SVWcweHxRiER1Mj8GpWTrArqmrhii9mNVYF
 A/J49a4oiKeDydskHR9Y068Q6JsWauT7kEtNwEG1jSSVL6m5usEHwpu21da5nHKsjFanhRZjBfA
 P3Flr93QMxuhh6A==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: E395E180006
X-Rspamd-Server: rspam08
X-Stat-Signature: infqff3yw7bc1tuyjndk5m1odzpskw6s
X-HE-Tag: 1773054488-817355
X-HE-Meta: U2FsdGVkX19in+DHtU9DXviLkVeGsixFeM0dYKG/sBU6sKoi/h/ObAKZ2kxC4HYZ12Cp/SHDvoplvys68eIop05/mwMKrxCl8wpTPanqIAdf1cvL92PxHhTFgan75n/rdjECg00UnI+zctl3O+BFhzQTtrOVs5Sr4OAHCERmcpvZKWYMM68ZakZKir4U6LOQJILDGK8IrvS8QdQtHNlwSiHnYsislX5JsHtflA/HBEknz7L5ov0XrZnGQT1Ti+NCh3dhLjz3tjHCUJ8hHBwhP30UU5q6LXfcl6H0STykwfAWT5SOBWSP1h1efTTk2Gi5r2Bzzbbuq49ve/R7K9rPk3C0bym9IMmAyI9Yq0ImdUh/kOPR9BA5f4q+YAf7y9cLwJHc1Ofgix0//RkvH5rsLU8M1Pxom6mi57FzMpgQHg7K2OkdswnumkcwOOXSyRERTgf8rbvgR5vaqhuf5/QiJdh1t6eIlz7XKDHJQthzdYKa3XWoOfZg8ukgT+UxFw/MVGg5ZPAhiNjQwk8Sq8hw3vddbMK8BmqXbIkxYqaJAzfufdGMzw7elUekD4s3f4EAPpr/jzcE5jFJKjOyGAiPHcqYHSv6OfylnpZd9rkIDAn2fkzMl1EdMxZ+tgs4WTK2vrTT0WST9Oy/JSGeSBS3u/ecYiCHTxHtyAqPqTImQZgxhqNmpVHYc98VcV/otMbWz/adcSjK8lwqG1vs91QphUsyQIt6vNpvmcdNDjQnW/cZUkQ2o17fKiYnQNqvaqoBq1VqD50ur3M1B6ss5Uk/FUnnjZwVvm3bCmVUBWBdN8Cy6WgDsUaUsLBu1cEoITMfhHXG2Md0hcRtW1nehMwiH4vZOC2hh48d7I5StFnjOMOVIBecBAkVnPUlXSLPOhCoEtWE9sHTk3hKVJhZ8OXZmQmgyItjBsIKSZQwUaJCVEYX5Nj9Efyi3EYFS6qIqJ+V8c1rP9I+1l2ut5IaCVM
 fExJoP1K
 SiPiVsIiHBtygEar3EIdE8PEm/O3GjLBhjW4ipwXvFcPdyKmcxoXAVzViPTvtsx3qEHbespGvLtmED20sxiz7S38jtnSde/COi7srSN6ranWId9+P25r3okXxa2uaqPuquUR9y/9RyIjqW9SVfFFNZod3bwl6Gowa/VDEfy/WwbPmMQOsUJfwVyR3lHeKIgko5wkOEqNqec+uOMRbFYCPj2llpukWpawhzSjKvwBNGhdlugnRNtvYCMrPJbNeLU6ZfKZVtq5oNIaZvxw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make set_recommended_min_free_kbytes() callable from outside
khugepaged.c by removing the static qualifier and adding a
declaration in mm/internal.h.

This allows callers that change THP settings to recalculate
watermarks without going through start_stop_khugepaged().

Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/internal.h   | 5 +++++
 mm/khugepaged.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d99..7bd768e367793 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -623,6 +623,11 @@ int user_proactive_reclaim(char *buf,
  */
 pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
 
+/*
+ * in mm/khugepaged.c
+ */
+void set_recommended_min_free_kbytes(void);
+
 /*
  * in mm/page_alloc.c
  */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1dd3cfca610db..56a41c21b44c9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2630,7 +2630,7 @@ static int khugepaged(void *none)
 	return 0;
 }
 
-static void set_recommended_min_free_kbytes(void)
+void set_recommended_min_free_kbytes(void)
 {
 	struct zone *zone;
 	int nr_zones = 0;

-- 
2.47.3


