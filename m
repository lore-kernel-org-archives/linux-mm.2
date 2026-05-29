Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C05ACD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7BD6B00A3; Fri, 29 May 2026 10:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99EF06B00A4; Fri, 29 May 2026 10:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DBA36B00A5; Fri, 29 May 2026 10:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FCE76B00A3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:56:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47006A018B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:42 +0000 (UTC)
X-FDA: 84820759044.20.D39039B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6ED7BC000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ft/5wVM0";
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZ3mWc5l0n6bhlAtCP9EY/lUmJR9yHRu5TlYrKLhwIw=;
	b=ZAVyOYRxY/O54GuoJ79vqeOigY+OAVDwuIdpCt8SRaHpmSzf6GsWt+PTMtkNN1ZnFDWq3u
	FREc6rZ3SStuqmG37txYngNCqIUmzmRKNl3Z/4eFVmTxQaeAUq68fr6gHpIjeN8pRnC55W
	CijiFV7UCQJhRuAKGotBopmMtRdHaLU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ft/5wVM0";
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066600; a=rsa-sha256;
	cv=none;
	b=Wqt9nk1Pp8xpnBtOBdzMF1QsouAVpFMaZm50HjQEzq+df21KxMNDFjQoCxTVnF4zRQoWN+
	iqIbNphpx5F478vsxfSHhZHn7GyFLPhdeQiNZhhLAYImWe8qWWTEkuBqoUWbD6PPLVZCzd
	fvYrAb8CC46n6slMguLCksAzo/71tWY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KZ3mWc5l0n6bhlAtCP9EY/lUmJR9yHRu5TlYrKLhwIw=;
	b=Ft/5wVM0DS0YE206ur5cbDglbW5pH0HQZyjtot1ek0IU0tDswBF1E4wHGy237Dg+GPRz31
	eZ5oHyaLZ2fkpO8akbpkzqbybQ3zVUguUbNUdU4p4fXtJce9DpOL8StOa9bopEDS6WeBIK
	R/TGYV5TzSilB9Je9NryWtqdlpGJS3c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-3yvAaDdoPECChEOh7GxmbQ-1; Fri,
 29 May 2026 10:56:36 -0400
X-MC-Unique: 3yvAaDdoPECChEOh7GxmbQ-1
X-Mimecast-MFC-AGG-ID: 3yvAaDdoPECChEOh7GxmbQ_1780066593
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A03C1956095;
	Fri, 29 May 2026 14:56:32 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 36BE43002D2D;
	Fri, 29 May 2026 14:56:29 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org
Subject: [PATCH v5 07/14] mm: shmem: allow THP support determination at folio allocation time
Date: Fri, 29 May 2026 10:55:25 -0400
Message-ID: <144e7639734a501340bffe5652f8ce32b3657e23.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: rKnZJ2YmwG0aw_nIuLnjdCp88m4Ua9IdPPIXg8KrlIs_1780066593
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: rn5mc6wzuk7hzo1ryhd3k1taydqk6psd
X-Rspamd-Queue-Id: 6ED7BC000E
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780066600-541407
X-HE-Meta: U2FsdGVkX1+6T62RcvQHaRcNU/txdpPNaAulzUAridiXzPKiIUNWHTeBtCkwvA+o7IKTwxdFulP+fr9u7OlJ1RXSrFngoMZRLDY9utKiwL7yrVhfypqhK2dEMk7q4sQdcWAGuBNXO8G4PaZQAUEj/PJLcptJCZjKIKmT405GIUHFjsl+l4NFnJu1SiyZ4dKYiyYjQVidi2jozvyhcD2l8AJu5H04MrjH+wNg+F+30hCkX9/RFz5kHf1o6im8CpJdZvChEL22/6Pb+jrCUP/jQbBDLbU9tHumbQZI8Sp/WP3rxXoYaJb/XIeHMzRfyuu2vA/KOIdfmfhpgQihGkB8/WwJyp3KJ0PLoPe9Lo8jSPNEH40rKqrv9CxXBdwdCq9JQhrI7t7/832/pAorkIOOVEx6S8eMPWItTD1bSKBYK4fjVfNRfhDJebuX6mURtSjF6CkcxV3MXq+ej8DFxl33NK5SjcZrSFP6cG/ooIbm6ew5kzIavIgKuLJlUn279SGsBs2Z+o7ehXyJWSLXaasEDF0g57K8ONk7adaKXWEHXhbYOupEoA2fYRujr7xHXmchgQKlJaaUulhVpxI0aMZeUqGPPYLNgoyYzcUbVamAUPqqb5PJO+HMJzh6oBzMO3R/+3FVQOEzil8yrv7w777C12tVB7EZrX0PiMgo1iaIF4K5N+z9SonGaE2fGWIz0v35x9hKkpHaOB3T5dLUWPs2AvgUS0sw1sFD2g7S/ruotlqXGnE940IYEo9VlLC6jaPdG2z8ZgTcKpvgZQhUxiWxy4xAYWpAtdQppB4EZAIxMHUY3YB+UIHu7GmApH+AXpRa3ndPIkU1T78HpP2aU2XPC/XZMo4HwmHPoOmWHuYjrlfhiz1c3xQ1pbUP26I8GnrBAwDqf8wIfwteqE9hIUdxPcVyDSqRg5QbiAmk0MNVO1lQlI70PRc+h+pxqhvlFcXd2lZMQ665zGhjg/doDxC
 kISxUapP
 iafID5ZhGevC5F+kXH2gRQVMl3eUEpCN7Qplsaukeqdm+Ra7hDjxoN1QZ0eeLF/HmuBOcZLRQnDQoHnoI0Gf3WsmQ22Ym39qHs2XheK1vtUzRLUqxtHn3B0aE0xhdgRKhbDWkJujcXYkv4qBrCv/oHZ+yYOmE6crx7Jfjk52UPeDRu422/xn/L0oYAKLByXrA1wRclH/txcOAplezFPBjfwF9Fxm4/NWNbnEQ/bLqqUvd/0wvhuuODexyFbLnk7AOkIau0ec7gh35XsyumvspQeVAXErTVmLUNxLO32P0d5PeMQQjb+WjvOj6G9xwKcg1Typ3si/LyoaA2BwAUnQzZj54Ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to enable THP support in shmem today, besides the user
configuration required, the CPU must support PMD-sized pages. This
is the case because of the following has_transparent_hugepage()
usage:

- shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
  if the CPU supports PMD-sized pages

- shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
  the code block calling has_transparent_hugepage(), the
  has_transparent_hugepage() call is exclusively checking if the CPU
  supports PMD-sized pages

While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
in all cases, shmem can determine THP size support at folio allocation
time. Therefore, drop the has_transparent_hugepage() usage listed above
while keeping the CONFIG_TRANSPARENT_HUGEPAGE checks.

Additionally, we need to check if PMD size order is supported in
shmem_getattr(). Use pgtable_has_pmd_leaves() for that.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/shmem.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 88bc0c292f1a..108dc969b92a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
 	else
 		return -EINVAL;
 
-	if (!has_transparent_hugepage() &&
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
 		return -EINVAL;
 
@@ -1303,6 +1303,8 @@ static int shmem_getattr(struct mnt_idmap *idmap,
 	generic_fillattr(idmap, request_mask, inode, stat);
 
 	orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
+	if (!pgtable_has_pmd_leaves())
+		orders &= ~BIT(PMD_ORDER);
 	if (orders)
 		stat->blksize = PAGE_SIZE << highest_order(orders);
 
@@ -4658,8 +4660,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_huge:
 		ctx->huge = result.uint_32;
 		if (ctx->huge != SHMEM_HUGE_NEVER &&
-		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-		      has_transparent_hugepage()))
+		    !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 			goto unsupported_parameter;
 		ctx->seen |= SHMEM_SEEN_HUGE;
 		break;
@@ -5451,7 +5452,7 @@ void __init shmem_init(void)
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
+	if (shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	else
 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
-- 
2.54.0


