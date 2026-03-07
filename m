Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0361EF55102
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 16:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D19F6B008A; Sat,  7 Mar 2026 11:09:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6930F6B008C; Sat,  7 Mar 2026 11:09:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554296B0092; Sat,  7 Mar 2026 11:09:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 47E876B008A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 11:09:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5BB814086D
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 16:09:03 +0000 (UTC)
X-FDA: 84519750966.12.3C6C98C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0AFBF1C0011
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 16:09:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vLA57anC
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772899742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMsK7bM5B63ETngSFYeak+wzJyKrL8AAUXzgpqkd3S8=;
	b=4kpjm5GizToCTg5wdv11luINamLMJ03hlhk4DwwCCcSyfBd/J38FPK6WwxX6OY/t9h9AZQ
	a5YQ5xwEvzUcO8vlHdx5S8pYR3C1t58OmZHGz5l7zoSVnIq8YZauOJrfqfvuklIn55AFxK
	7Yv/EgvDKOLBam9q41Di5n6KWnpCMoY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vLA57anC;
	spf=none (imf18.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772899742; a=rsa-sha256;
	cv=none;
	b=p36DASgDVW8XbeNYmdocmq6fS8J9w7jP9ejQt9zA146NW+LGeNY0IwWy78+p5/lWkiEmme
	nv6mI80hP1ouhHpMgKXtsPqkXt36l8JlkmahwHvZYp/9qDySde1CQaDMd6005e8IeMvbik
	Uznm4voEqXn22gLsb7nrewMzP9Wurns=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=wMsK7bM5B63ETngSFYeak+wzJyKrL8AAUXzgpqkd3S8=; b=vLA57anCPTfZr3sKp6F/baWHvv
	UC8qxxbtwcpSbW2dIyqgABteJ42mbwZq20K7uOdmbaEsqEG0UPEdndunEGCAKfzzc/uuZn2xlPR/w
	5FaCcRdUr+XmJF1YFsXfcfr7zOCzDiGEGkWn1vS+DgP5QqyWzujBNv8cZyY0BBdPvxDFS81Kd25fw
	C3o12YPxGWW+we/xYV/8tD3hKR9uWaMSaE0/Aze6r+xZkXrcnvOKIEPg9Wb3cIfXQl50trHNpxiQh
	Dj8No0gKpNLBCt2z9GyJxf7TDwa2oJ4jWP/uHC991mJGvi7EGsdSChDKQyWPtNMU/VVudBEPgXtSb
	uruz+YDw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyuD1-000nKY-3F; Sat, 07 Mar 2026 16:08:55 +0000
From: Breno Leitao <leitao@debian.org>
Date: Sat, 07 Mar 2026 08:08:08 -0800
Subject: [PATCH v3 4/4] mm: ratelimit min_free_kbytes adjustment messages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260307-thp_logs-v3-4-a45d2c8f3685@debian.org>
References: <20260307-thp_logs-v3-0-a45d2c8f3685@debian.org>
In-Reply-To: <20260307-thp_logs-v3-0-a45d2c8f3685@debian.org>
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
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1843; i=leitao@debian.org;
 h=from:subject:message-id; bh=gxJOAYW1B4QBpNiriL+Xya3ATpxserwPiuGqRjqavaM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprE146M/jYBIhqmoonwG80+PQZnFGxW0TpZfU5
 7lPztdMst2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaaxNeAAKCRA1o5Of/Hh3
 bWFdD/4muGHfgN3wEPB53oBk6T1XmgcYkTs113p09NYp6EbEkvPg848y/LKpsID16FKtBpcN/yl
 yXRE+EAEkew22gpyYrrNTns/e97pk2IDSlwvxNfqspVAyjRumZTirq8VRY6Z1EDr9ESiiJ59OaS
 cNJjYp6vaoZ6Czi6t44GkZVXZVXYIbOa68SSVThtLQ/FHZB4rWdooHHiBw43GtI4jyQNMqUGmNU
 PWnlmBXy0yUPwTGxdQG6uN5i72AuKnUr3+MrWjYhfx8/ru9NRmma2Jz+5FuLIDvTTD06RUd/RvE
 BAqPsV2M7LtZKOlbUUM9a90zBhJhQgYBtbPiUxyU2hDjwGCZwDJTBaRDjq6QqMkcQiougXXHkmd
 23hfObnpY68ckXphaNlzCEMTbd3GXNeQ1Jt5VmmeLCCHswD8KCj3Sun2iYHnGzTDl3KAD03tAH3
 etNUHV7aGSqmJxrcGn9nGM3132zJOECmXKH9GIxHeRTb2OjNW/VpiUC/ZivbsQ16zqQfw4RRdG+
 6CdbnHFG4/+Zouyf1i4G4CJqvVSURmYk31tfpiN2xiva8GYBcprtUyUaifyHGN7hA+KyfURpWDk
 EH+DfWrjQ6OypnUnUnpK9C8Jj4cHUhNHt5EIPEY8NtzNawYNTCBknbxrQVc0fn6WGA5NclJK+QM
 JodNgpZytCZSvaQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: dgtix5g4pb98hehm38cdbyfg4xbm11qe
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0AFBF1C0011
X-HE-Tag: 1772899741-411455
X-HE-Meta: U2FsdGVkX1/dfJ6T6zsGKqE2elN7u6SKpy/ypVTuHj5SZRZaD8NyQTNfP3D/BGdPVZbYQzlpBfxiLHRPvagRHfuCqGw7CGi6trzvg7sWdGNL6BaZZLnZ2fw6fQPZnPG4MfVPtS6ZB2yJlhf1SEvuTM3UYgM4G0+pLqDdGGKNFZcSdHaJ/d1ZZzhoVXw3LJxicCFqBxIHZQNh3H+joPtlGziPMaQMDBHqZzQuw9w1xc7hzPVIwt5VQO4OfuprHXXpT/D4cj8wUg5Itf7B9C0MxrWqKCa6QQ5z6wFsu6z1/M8Cv1voWsT4e7Mq97vqymOfvrzFJppxwVDajHwJtng4qEEvq9B2/yBu5PR92pLN8AvRjERqRDytxYV8VcyQSGrvBk+aHuqMoOw2ViezwCrnBfOv+KrPbadz5O+yuKnedvRml/QTkTPlEOI9h29QrYPx5TEfMe5dTKxuzgz5y3C86Ix7vpuTc4J0IVtM57u1bAMxS71LSqL+lbPGi2C+V93gN1qvkr/Rd7PObKEX9ChKLr+6zMolMBIfGAGcw1Im/LoxSh6xkB5AheGxRsQ9WbKgr/WJUrZd0F6kMMhmQ+QirelTVd13tQT9pbApcqKU+oNxb7WX6pYGEA7h7+5WBB+WICUI8+yoNTAgqka9oxcS28OBsqxWukZQ+ZZgxXh38ngTWKUhQVsuRQ+CG1lxS1AAQmfMA7BtyZ0hMSVyewofWQNKBEptFalW/9uTYyVuBqOdXyA24+oSO5wUpxS7z4yzL6KvwHAVzXG20Pq9RFHPUodHfSLHxvR46Ktdb4+tPTeQmPmBBBy7IqHAND6cDtXI2xCFTfMsUzqC/HbZlwrVRdLvaymvhUjCUGR3lsv0aWGKTXjNZsEY8lsot12f71WVd3gpdA5xGf3rSnIBLU39y4HLeqOdrfHUxKV1QMbpMu79K3jTLUbUFdRWS+51/c1s1Ee5bRz+/LnbPcIAOzI
 mshSGkcw
 CkWNdftJ0pBiSdCWHF09E2nvvo3Dwn1VpGQgYVnbqdUwgM4NBlMdfyLh5s8WYRcILjucOTzzI2qKuXvpNhYQ26fULWIfgXhFgMt8yGqMHGcHtsaW8aaauhXLbczGcy+/zfucZB/wcKEyfs2ZWKOoZrh+2FZFhoPkmAAtawWD5txG1UdULEeRVPVoz9RRCycj2vRrjVyJJSX1XdFc=
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
2.47.3


