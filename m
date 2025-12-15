Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E02D4D5B86D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763B06B0099; Mon, 15 Dec 2025 16:17:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72ABF6B009B; Mon, 15 Dec 2025 16:17:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664656B009D; Mon, 15 Dec 2025 16:17:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52FA06B0099
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:17:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F1C81A03AD
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:22 +0000 (UTC)
X-FDA: 84222966324.16.8D587EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7041A100007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Me5YjcTE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833440; a=rsa-sha256;
	cv=none;
	b=T84fxUJx4BygIdei1oVdEDfRHf0mTEbIm31nANLiGHphqB9zba8oFjeFq5l1NQyoiJbplF
	aeBekdT9J3E5EVsDqLJqq/EOdjGs4EgTVeoioSWbx76bh05r3Ceef74DtB1OzFgmIi/AWs
	dKRDl3MBHfSvIfDcPIzshSd0Qe3WK8c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Me5YjcTE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ait6SZZngNXoHHnOqheyBbMc11rfYo1TPeFRuknnOOY=;
	b=rzonwuYMEP0FXVIFCDgWsn36HrtJK8cYzYu7Ol6PLUUz9MEGB/zWeRis/AbPnFrTCvJj91
	Ja4UETCjxFomUY1vUWyTk3rmO0s8+aKBdb4fOeLHHo6yLLQ8uBAF7BlAwZN9FEZKn2x3Qk
	cm6zQdUFtKzzUtixJOOJUB/Gb/KC8L0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765833439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ait6SZZngNXoHHnOqheyBbMc11rfYo1TPeFRuknnOOY=;
	b=Me5YjcTEA+9X3dDuj8g43SCEa884JOhe2OyOmvj1Xtjz2eCzssIxg77OBM7BNcUzhIS8Rn
	foIoKlkJYXJSRtW0xcupvA4hZrsOf7djUMBusj3a2YT9WTBn/LJ/W4bX7YRGapkl0b33I7
	KUzp4lf1XNGmWlIVy14BMiiaPwkmhkM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-520-nzzYKGg9MMiqcgReJcMjCw-1; Mon,
 15 Dec 2025 16:17:16 -0500
X-MC-Unique: nzzYKGg9MMiqcgReJcMjCw-1
X-Mimecast-MFC-AGG-ID: nzzYKGg9MMiqcgReJcMjCw_1765833435
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3906D180035A;
	Mon, 15 Dec 2025 21:17:15 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3C4DC1955F21;
	Mon, 15 Dec 2025 21:17:14 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH 07/11] mm: shmem: use pgtable_has_pmd_leaves()
Date: Mon, 15 Dec 2025 16:16:49 -0500
Message-ID: <e2eab9e249d10ea559e1e3c9e9b224bf2822d13e.1765833318.git.luizcap@redhat.com>
In-Reply-To: <cover.1765833318.git.luizcap@redhat.com>
References: <cover.1765833318.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspam-User: 
X-Rspamd-Queue-Id: 7041A100007
X-Rspamd-Server: rspam10
X-Stat-Signature: ra1rtbc4bsqowxhb77w3rysudk4snkqc
X-HE-Tag: 1765833440-570153
X-HE-Meta: U2FsdGVkX19DOetwhQDVBZ13cOOSfhcUY1x73AAi6AajQ81ofAtxe9otQBGbojWcCE1BnylpO+eJmvW0PvymfrpHHDuXKMCRAxPP37UAOuiD9v08JUgFaFX/uob+0vhy50GpTrtblaS9qllipvTENuXqKDslS+DGx6mNA/SEo4SyOMtKq1dLsdwPyBT9LNAwx63FwypNRHQOzNHy7IMq14RQLIa6Z3zZ5xexrjcYM0ucX9d31+v65l1w1Rw0uOAyJlCbIACRbwEvnQu7udc2H4hUaCZzh2KQu38Z5+FRsrr8BWxpPvy+N8G2DZk1vV7RpUyuub95PAgJwi7f1R67h4lu+Q0S0dubw5VYXSrX4BBE8zNem6ZJNt9YfFPA5xkvesQAu30HfBtDA5uGEsmD5EtHh+yGUffY2I/j+x6bFNAKxd3ChFfUHndViP/N3zndrpRVRhLFy8VX9i1M0r7EkgKF8t0DABA3sxDzxgtV0heokxMIr1lI3Rj0E6x0rSdR4AdXsMDDpgF4Ng8dm8FWcp7nLJ7lVYFTSZr3bI1tUeg2qZlilDkoPMbzqY3rtbCfaE8MjKgX+Xm0NA9oBgQtyhM04OupT/tC9GOpczlBsTtsY3WMcEjgrO/pebadTa27DB+pYB9UFzmtiA2dVgvTSL+nGO8froKlZrUPDAmi6elYGnaabf4MsCOXh04kGNBBF4OCc13hRXyBdwWjFFqR0xUsk1XlTN9kXhg0eqPUvQTht5rIB1kfWBWu0nAJcgqtaHuo/sfWxTB+XY0/Rt7I6jTMTRRjkW9kUMG9hn6iApj6XeMqX2WzqYnIxVEWVQzs3sgP7S53h5CwUCDhwUshJHdFlcnQqTPCoGrNyj5Nxh5FEjwq7wzi9ucwGltr+JzmZC/g/Botnp3iEXanN9M1J37CmfSZN1+GfFaQCe+RaiGrDW9Ow8ONh8Vy+g4cJz+cTuCgZzXGYZYLWFquSv9
 QyByfppa
 QWaVUpE8i66tvt7Zr0JiFJ31KaT5YlubwbhrS4XhXoUMhMZdzUFSWgXL5RBhyL+AgKnKaSujQnM2P0kJStW4tfC+HOB1WXo9E5AGYEuIh4Yr+ls4qUfIa6NsBt6XbNpd90KAOYy+3jvWjLXYNgqm6ESf8ZdzK8Wpb/hj9MvpcVY3qrIQZNXyW++r/cDihlKRnM2pPIlNP7A6/h0zaoWbUDmUPOtN0uREaxiH4Q+NWrs9lV1yW7dGiLCpfrZ2lurTf23wpHstRAa8y2d061pRXJ8IiFhjzLrEoxSGtDsjJE3DxiRra+2N20MESCYMfb2nXa7yZXBHLDPXOwe2VWvjvOn+Ma4C7FBkmTMNfXpcnGM5tKf/JmB6HqI3F4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shmem uses has_transparent_hugepage() to check if PMD-sized pages are
supported, use pgtable_has_pmd_leaves() instead.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/shmem.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b329b5302c48..ad5825667b49 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -689,7 +689,8 @@ static int shmem_parse_huge(const char *str)
 	else
 		return -EINVAL;
 
-	if (!has_transparent_hugepage() &&
+	if (!(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	      pgtable_has_pmd_leaves()) &&
 	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
 		return -EINVAL;
 
@@ -4655,7 +4656,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
 		ctx->huge = result.uint_32;
 		if (ctx->huge != SHMEM_HUGE_NEVER &&
 		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-		      has_transparent_hugepage()))
+		      pgtable_has_pmd_leaves()))
 			goto unsupported_parameter;
 		ctx->seen |= SHMEM_SEEN_HUGE;
 		break;
@@ -5439,7 +5440,7 @@ void __init shmem_init(void)
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
+	if (pgtable_has_pmd_leaves() && shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	else
 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
-- 
2.52.0


