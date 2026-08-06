Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB796C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9924C6B0092; Thu,  6 Aug 2026 14:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942186B0093; Thu,  6 Aug 2026 14:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8318C6B0095; Thu,  6 Aug 2026 14:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 58F096B0092
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:19:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C79B6A01BC
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:19:01 +0000 (UTC)
X-FDA: 85071656082.10.9058DA6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id D47B240011
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:18:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IKTfmDge;
	spf=pass (imf11.hostedemail.com: domain of audra@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786040340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6U8hXQyiT21+O1bLmwf8fA5hyjP0j3sekpPjxiz1to=;
	b=eIaHY9Mb+epvzbh3lvgv4ezhKLkppfegbAeN6PHiwShxejGVNhkxxP1Dy1jvByovWnUXbN
	dgg8nJ5b+d2C2kXX1oU1hVw2qrzMO7orOIBAmzn4XQuTD9Eumy7GcGosuO5uz4y+vSR6y6
	6cONpLTJckPtmeyVTStrZHLiiXIVdxc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786040340;
	b=feSDaokaB5puAn7fgGC7lgtzqu7/0oMYkkNlWbyoJ6ItgiesYNjnT+3VYwmDc/AmV7DNmf
	EsuifEft4/SA/EeVVR0y5QABshgN2do9bA12ixVU4Z31EfVXO5izUIHT2ZTO5Y1tDuis87
	ZO3c4MeLx+bLzTu1GBfnnbNq0YKaCI8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IKTfmDge;
	spf=pass (imf11.hostedemail.com: domain of audra@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786040339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m6U8hXQyiT21+O1bLmwf8fA5hyjP0j3sekpPjxiz1to=;
	b=IKTfmDgexHa8RLlZ7PpG0H1NNxXFpX+S5AqfERJv6tp6z3rS4JplAwngAIaDBXgwmxtB4/
	Ssvmu5KQ+h+OjjEyJf/969nilMCsb62g5HJ9BDvvqH5thc2fXEmtaKbN6Q30MzvCSJhh+v
	8bqUDyz5wDFkhzMItM6vMZCNqd2ozvA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-SoExRkXfM9ip5V-y16kW1w-1; Thu,
 06 Aug 2026 14:18:54 -0400
X-MC-Unique: SoExRkXfM9ip5V-y16kW1w-1
X-Mimecast-MFC-AGG-ID: SoExRkXfM9ip5V-y16kW1w_1786040332
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0BDD195609F;
	Thu,  6 Aug 2026 18:18:51 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.255])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D5051800347;
	Thu,  6 Aug 2026 18:18:48 +0000 (UTC)
From: Audra Mitchell <audra@redhat.com>
To: david@kernel.org
Cc: jocolema@redhat.com,
	raquini@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Andrei Vagin <avagin@google.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Correct __pagemap_scan_get_categories return value
Date: Thu,  6 Aug 2026 14:17:03 -0400
Message-ID: <20260806181843.1839943-2-audra@redhat.com>
In-Reply-To: <20260806181843.1839943-1-audra@redhat.com>
References: <7d6b4401-e230-4ca7-b64f-c1277fa643b8@kernel.org>
 <20260806181843.1839943-1-audra@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: KFrTitvHH-Ng1rnfFYbleQ_DE41gGptfF4EWKDkdMX8_1786040332
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 55fqiufsdy8j3t6qpy8thfu33rpj4z35
X-Rspamd-Queue-Id: D47B240011
X-HE-Tag: 1786040339-161169
X-HE-Meta: U2FsdGVkX1+vZbqCgaWNz7vO12N3q52B4BqXmTj7tRWmXNw46pTMbHSI25ddcvdGaSZKUuIPvFgjcxx3QbQWlX7iJ1xx67nu6GwxF8FTSJisS1XItxUszE0Gzcu5wNF3e4ZB5iXDfne+YMLoinsofVy1J2s/nnOt6OHNbm5A9ddX+uaXzS0svltfjzv+Imr8aIeGIlqk2kbassSLCXo6jbgdJOU24jWDbYs8CUy+1dq5ylpQtTfyHgzxK4DnIK5goojL/WI8TX6FZsDVW3V7hGucznvMtqDsfc6ywwL7tc5g9ETEyGk6mVK5zOzzNcXPRgAKbVqQjWyPlaIsitdv71VpprlLhoK1jeAYMj86s96KkoySzrPgdnG6z8NgVG8FfU090G9A6kBiKKpTaVgkHvKQMaJc4l41vQGcTGAHxrXwwQYte2emP9GCLJ6PFe7hY/VFS1HctiuG1t1RUVfH2Yu0VWQoTy+4Q/9c6YN1dx8sQqlF3UuOnDu49SX/51AT9Jlan3Cv/WBffVpWAS6134Gsd/P4x5wgUgVLVWPf4o668yKAl+An6Ra7krmhusnpl/ujpkY2Y4WwiUU1H/kiITyF6Bsj+cS3amQVsisj7nR3D+c0WG9iq1KUkbnGZSyqPZ9rpJSgQlUEjVCX6E7My6VRzkKMglBxzy7ccl82vZ0f3c9DeFOTGpOuKH6kMB10nAIWRepyn+jsYmTrnYyoE6uUB4lcjIe8cFmWr8uFIt38SZuozAvfKDNOdXN4aFmkUP39GoDs6Bd+zf1UMYdK+SKBKdI47WZfJefkZLo3kzWlZG/IcpPlPS2NH5sldRSxFy+el1r0PmsgxVq6awm7DsJpCTB8ATrg8MABt1ycCXFN6BlRZH4q+GDA5zRvr4pJTb9l0dfeKgwn0tohqQMEuNL8i7WXE5SH6cI3HC/nubRnom3guPppzLofkzg6mzDIPE5P3dCy+AdgklSEynX
 nFHnJbIJ
 q5X7EHs7T19CG1HWkzRlWG72d4bBiy7JspElRMpJKd+9hF9X9WqKfzo8qDnauEVSxIox1nPjB4ZiMr/YCugYZM0gStAtMWshX9sEQ8Q7fQHxym+TCTeOq26eBHf7N7Q7d6OMVc+GHEy+ah8DceTRZ7SYkCFpv4Gu+FKeyVTUT0SIrBqnUPxUM9nnR+fBx2Y/DagRv3jROOUjdyzXWB1cAuB866i12Sd6iHFI5UdwpucFeMWhPKHg79yizlmfFM1azBY2HpcpOV55w3JXCq1gwypAms7bQEigx0p4LOreZ7GfEkJtTqpqNU0bw78JH88UkgQl6q04ttIM/k3b3OZ5tKEd0mu6UhhjITFSx/wDfHOtkYD9Z+Yv2qBnliqDqnIznCtdprOpuD79wloZmE2DoklAXz2q5/CKLDagf5FwpkIcw832VeLnTWevTSd+dMqpdfN7rAwjTWPUNnZRv6CiKclDlbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently __pagemap_scan_get_categories returns the result from the
ioctl call which should be an int, not uint64_t. The ioctl may
return -1 on error, which will be interpreted as UINT64_MAX. Adjust
the return type to use the correct value.

Fixes: 600bca580579 ("selftests/mm: check that PAGEMAP_SCAN returns correct categories")

Signed-off-by: Audra Mitchell <audra@redhat.com>
---
 tools/testing/selftests/mm/vm_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 311fc5b4513e..6b65bd0a1e0b 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -31,7 +31,7 @@ uint64_t pagemap_get_entry(int fd, char *start)
 	return entry;
 }
 
-static uint64_t __pagemap_scan_get_categories(int fd, char *start, struct page_region *r)
+static int __pagemap_scan_get_categories(int fd, char *start, struct page_region *r)
 {
 	struct pm_scan_arg arg;
 
@@ -55,7 +55,7 @@ static uint64_t __pagemap_scan_get_categories(int fd, char *start, struct page_r
 static uint64_t pagemap_scan_get_categories(int fd, char *start)
 {
 	struct page_region r;
-	long ret;
+	int ret;
 
 	ret = __pagemap_scan_get_categories(fd, start, &r);
 	if (ret < 0)
-- 
2.52.0


