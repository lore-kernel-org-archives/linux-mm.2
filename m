Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A0CC1049527
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80FDC6B0093; Wed, 11 Mar 2026 06:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79CA26B0095; Wed, 11 Mar 2026 06:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC606B0096; Wed, 11 Mar 2026 06:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E9936B0093
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:19:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7CE51CB7C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:19:41 +0000 (UTC)
X-FDA: 84533385762.22.D6E3D18
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0ED3D4000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:19:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nLqrnyWI
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773224380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nzuz22HJlpi5hM3GMMNGDuF/FPshFhM/ibIt8PNUdHM=;
	b=i37rZq0hHri3jAlrXOcY4ySfZUT3+g7gNo7XZ6bNp6yJuKDyAK/KbESG2/R+YVZUdB5AfY
	E3xZzoMd+esSc+v9GzSCiY0d5oKe40n0LhU8+4QM8j7tIUB7DWus77d+8FHvG5Z7W8kNVO
	iCFx4wptT11fVwl5GBtrFxR0Fub0NL4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773224380; a=rsa-sha256;
	cv=none;
	b=MIxm/aFwTxRx2LBA1tsLgVPDbqZuU31FaHBPE36r/+teBF1tFmS5f4+uT95uiH5NykD7Yx
	peuIHJmgTkPSj3oxxkOo78YVMR41XAcHXFvP5gjK2LaSOTxZagwgg9GmzdsP6djzcpxMqt
	d4afRbXRZcHuzemTrVxqKibKF5TlBwM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nLqrnyWI;
	spf=none (imf12.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=Nzuz22HJlpi5hM3GMMNGDuF/FPshFhM/ibIt8PNUdHM=; b=nLqrnyWIY5Gt6JYWgBUsYihjFY
	hdw0cy8bACMvdua+Tql1P+JXMhjamBK/aK3XFYH0byntLap0XWuz1jffXbzyRihdcGDtbNtJUsNTe
	lDVeTwAjbToRt7JqZCMNYWVrA468Cf5SRcyeqggASKhXpf7aifctdclJr+b5gHWmBmy/wnkRoUXsM
	1vjxDbG4TwpAS56tgzteOULaP0JPSmIn2Yu1WY1eQSdtBAZhWimUJa5mfJT/85lGIuZVNOFoe3IKI
	NUjlZn+xIzuHX4EHq33htHk6qwRSgWHLIzMO3/F7SAxz4EBBqhNzk59ngFGVWcv+ksSH5xG14cglo
	xsyDuoMA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w0Gf8-003hL0-Kk; Wed, 11 Mar 2026 10:19:34 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 11 Mar 2026 03:17:50 -0700
Subject: [PATCH v6 4/4] mm: ratelimit min_free_kbytes adjustment messages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-thp_logs-v6-4-421e30d881e0@debian.org>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
In-Reply-To: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2046; i=leitao@debian.org;
 h=from:subject:message-id; bh=ve+lNwoqDQSYspSHS5OWSYYUOfQw+Gl9hm3vxR11Gs4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsUGZ9Y4BNiKt+ejJ6EMTJmA/lbLn4yECsyMFI
 LTlvTztlpaJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabFBmQAKCRA1o5Of/Hh3
 bYzMD/0akGeFFa5euLxXr0SCDjKxo8ulEvSsFBx2OMOnL6EQo2KXe5BgztyMFjVLE8HjzwDUGTj
 dp9feCbl0fs+3m5ZEkzje96BhZi7PT3qiPM7HUgd8vPXPUQLk0TD4q+RBW1XWBsaMBmsliMkOlP
 xISpP3b4fczP318KfRxlAjMDelhLNrZogrVL5xpepce4tFRoD+XOpOH5hCdL7gm0muNqH+riHdX
 OTjW9kaM62YDgGttxZKYuXs20ejLt/0Xg54LndX2j8ZGQnZ3zSaE7bAziO4v3KN1ulWDwj2Wi/z
 qZAVXm9kRrK7iu0LI4GUXK5YxdwI4P36HtZ2410v9YBcM/jUsOMjcYwXiIDHykjA49odpJ/v61m
 j7TC7VPeMkYjA0k+4e/QAJ5RlBUcifKoXIAyTTTRcymsjYRgDr7Uuuj9hQSwAtdcN25ULfl2WQY
 82CLgV0aWtfIfU+HSghYt0Mp8uO5YOyyaiOXUT1/pSG24r8atmuaSDqeRQwSFE+3F5E3t7hOuOd
 qfFRzmzMug6pDB1cejHUOa95cjWl8K8JvQqC4Lxm9eg/SYSwciQB1DMg2vzBk5WUb29c7MzDZ7o
 yYLOGBySG8m4qu3QjBrdeEKT0HUOGwRZRiFtZsq0wXXUnPYIqQ6UDF8E1CbKceERo3s98bV6O/B
 nBp0pW3oRj5sMTQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: s8fhja4uw475wk9n1rq6hwsgmgi9bpiq
X-Rspamd-Queue-Id: 0ED3D4000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1773224379-761859
X-HE-Meta: U2FsdGVkX1+0F+/dUlU92ulqhLNfuwZJgffLX8Wj19biOuk8b5EBBADRK5TVUCNTIWpytIIK7YC8uF3gowQ/UMP+uaCOqNYDmiavPWrFiHh25iaZDTvqM68KEQQlS369Y74PP2DowohIUqdtoVUqC33HRbtwz/WOIjK2ChMWE0bVDNP+kWziukSl38K7FOVGrdn8Ma3PBbYSkdgwzGIVbnt8w0vS+KQmiXiU8AIX+fIMsUXkofW9J1+6vXTFMxTa2FLMAe9UP8eu5xx0rGVEY/ziy8YQt4QXZVtva/Oj4qCHB4GYtdT2xgXT6WB2POc5y5CMZfHJ2NvoQuc+iuebhC74ILQHHViDpQQ7k+jTdhGmcn569hH7n+eUFMhWBCC+BNhn8ZaveYrcluWF8M/v0y9qJneIsf7riWL+EG+vzNKG+UQ5V27ytSpCYtWefZyiPGXq4RFTnsLNoM/3ZK4WsRCjNcbjSOcgfU52mtwONGqNPeznx/b8rBrEqotIf1Gge6gRNAb7ShWSgUvHnyhWp6PmxEeR1033h6OtT+MuoDdogjPysFdQrs12obsUx06lsYWnn7VTZUeJA2/EGQErvOB6NLF6PzfAyVMLo1u7Xw8YsNQ44TwjEXx1xzXYcH1TqBIHORIntjPfC7hV0aeVV0jfYXF8eCpPDULLJtKFTVHq7HcliN/a3IUIFUQ/bbdtCYK3NTzS43e38sUsj7pDEKAr64mnUZKkCLVEsn6m2pYBunZwx2E9eOpaTIebnam3ZzWO4b6TO4NnO0IRh0afG6JTeIf4ovIWDQ9M++eYu6keuKKQxb/6Ow+5X2vard0jjUxKh6tP6945OgPjOIqMw4Fldrzj6b02XQdf/BfAAKzBTY4jVwqtkGtP0Bzl6gLkYJ6X7pmyisP1ktgUnGZIOrxwgq2YoDe/aiQL8PYS3cVUOBCy4KUyCM1otqm4r1fJmcR9kMHHxHEpD7s0Jdk
 uzWS5eSf
 raGbXZxhEEvXVPROY6rBt0Yt4/lV7xs5qinjAVwv6/ukwn1cISusi0C10Gkq7VK06DUnTrSkXGLa/Va+q5jUfNbc8HxrlF0HA1MoOB15PBwFg/94zz0YxoWrUIteYNawL8aZXiBOTRTyaObcF1ELtwGhSKuitt+u4Xeu7gtszCc4Cd0L6agm2Ol90FwIJXdgqDevmEFfxgcdRgE4Ote11FF3DuPNPU8sGTkYlxGhUiKlCMxFqtmXMoSIdDYOMJSNbSybGRwqFzyv5lKOiRWYCMRyH2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The "raising min_free_kbytes" pr_info message in
set_recommended_min_free_kbytes() and the "min_free_kbytes is not
updated to" pr_warn in calculate_min_free_kbytes() can spam the
kernel log when called repeatedly.

Switch the pr_info in set_recommended_min_free_kbytes() and the
pr_warn in calculate_min_free_kbytes() to their _ratelimited variants
to prevent the log spam for this message.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/khugepaged.c | 4 ++--
 mm/page_alloc.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 56a41c21b44c9..d44d463ccfd3e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2671,8 +2671,8 @@ void set_recommended_min_free_kbytes(void)
 
 	if (recommended_min > min_free_kbytes) {
 		if (user_min_free_kbytes >= 0)
-			pr_info("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
-				min_free_kbytes, recommended_min);
+			pr_info_ratelimited("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
+					    min_free_kbytes, recommended_min);
 
 		min_free_kbytes = recommended_min;
 	}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554ed..c840c886807bf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6553,8 +6553,8 @@ void calculate_min_free_kbytes(void)
 	if (new_min_free_kbytes > user_min_free_kbytes)
 		min_free_kbytes = clamp(new_min_free_kbytes, 128, 262144);
 	else
-		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
-				new_min_free_kbytes, user_min_free_kbytes);
+		pr_warn_ratelimited("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
+				    new_min_free_kbytes, user_min_free_kbytes);
 
 }
 

-- 
2.52.0


