Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21E76F3C24E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA1C6B0089; Mon,  9 Mar 2026 09:42:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B596B0098; Mon,  9 Mar 2026 09:42:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773AD6B0099; Mon,  9 Mar 2026 09:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 67CF66B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:42:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E6FD1A0119
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:50 +0000 (UTC)
X-FDA: 84526640100.23.652FAD3
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id 54E8F40007
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QnXvFd2E
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7Ml/vJyi0FRJgghGtQCc2586RzghnjwSv1hQiNW19c=;
	b=dwmz0lg9K89FHMl0MhIVwFZx3VoJFiyBW+jYbl5GRNiTcCQ4me/ZOFlZNpSlNMzkOibCGJ
	w5N1FRSuhyx80r0PTBUAHEKI8SsGdn864oejc/utj6TkAe8Oi1c5uXdSsk6NUzpQRrm8AH
	98bSQYolVU6kfUL+tYDdpqAnWXTbFQ8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QnXvFd2E;
	spf=none (imf11.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063768; a=rsa-sha256;
	cv=none;
	b=UgXFSlLM/wMf7noL2/heASDa+iwCni1HUXCP7SQodk3vQkAbpnqQwhPwn176P7rBvGMhSE
	lFg/tp8fUilTaE0Rd/DWHXSk2tRzhXrDxm/bam+F4RHrxULyJJBQ5SR+ZCWi8XXOdl6knW
	G3gzVcIY9zJyhsn2UUU5PzEZ/iWQjIE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=O7Ml/vJyi0FRJgghGtQCc2586RzghnjwSv1hQiNW19c=; b=QnXvFd2Et5S90TK4Ts/A++2Ztl
	Cn/VR9gXgY/yUvfvqBzs6m7idnfnCuJpz9xk1huJY677VCStJcKu3lGhGjGPYntaChOsBlxa0KkK3
	lq4feo/BjeHAMPAzBVwhmn6M4jCiBDGDZagI83LFOx90LaVIemMdN4DdP8zB+H0RDceNcJPzpjNcI
	Tebz/53FVEPqzrgkcNKeiKGnwt4krm7LfX5+X5WciPzDX0JEr+gwI8N3lad5FNMCTAdqboaikDpWn
	qKkK1CYSwBT5bOPFTETm8PmaVYQRcDqoVVKGd6flSNNmaa56En8XONgahWyMIJodab1IiJQ0+/Fp7
	IGgthkzA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzasa-002G4H-Nw; Mon, 09 Mar 2026 13:42:41 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 09 Mar 2026 06:41:49 -0700
Subject: [PATCH v8 6/6] kho: document kexec-metadata tracking feature
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-kho-v8-6-c3abcf4ac750@debian.org>
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
In-Reply-To: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, 
 Breno Leitao <leitao@debian.org>, SeongJae Park <sj@kernel.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2486; i=leitao@debian.org;
 h=from:subject:message-id; bh=GuS2S3Wn71jXKGx9RIpG1q7JVYnitQ1EXkky0LyglZk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprs4ze/rUp861RrV5t62pTbJLJtbdntrR9AyI8
 qkmZylG1YeJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaa7OMwAKCRA1o5Of/Hh3
 bZgPD/4v3Yod2PPxx34KIn9K3RWl7jTuWUrsFK1hW5GuknLIksUYSy1hNqVshjLJL0tJFoK3wbK
 Vtx8cP6mtyX6+bJqGT38vExtFo2tWIe/55xDb6xyYSFvL4b+tj3K3+A6nHr4S+5Pq94JzrFg99V
 NXoqxOcxj46lsy5L5BHNIABY5rDqSuHF84zlo/2CJ+7pMUrS25J5mMwyPpbbWBQuRZLk7JS190/
 k6Uqk0QxlwagjSHgnnjKNxib/DwMW76TD67dadJv4hzW4JKA+zZvfKYG+wvfPs9dDdDb8ydbMHy
 sPol8dSYkjkF8rrvyXAFuzX3FMjQ8tmxTZInP/oXcwhfYGKDaUgYKb20OKL1CwkEUHZfOxlqIUx
 tlEPhKfp3oCZuYTt+HIQqeXLLNbIxRUdcAAag4DjWGdHgYnwbvrF35b1NZyDN7s0bCMAEb3mHQ/
 OH8tyo88JiSVeNtJcd7fHF6i6L9B3jxJY953cHHLrHlYOpFJKe5QEO4kZ82UEiP7F5vjAOC82w3
 Ce7XCPByc1m/rvbfXZnpIalWvsCeDzgO/XgUO/mNL7PVsHabR18OWb8DkeaBqsOg5xZ4Bz4v1dT
 /j6A+KxuQ8FbDrNLwb3mInMqwr2JH+L2rHio50MXWAPzeFhnPGkMnSSGknAarZQp+tpypF8BbJi
 1Z9KvPbhp3tRUEw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54E8F40007
X-Stat-Signature: 86u9cb7ead1p6kopt3a8tt1zwj38zkgh
X-Rspam-User: 
X-HE-Tag: 1773063768-385196
X-HE-Meta: U2FsdGVkX1/U/4ZASFpGAiF3WwU8yIvQYwSiadZ5C4VuoEY6HFSwRMC7IBPBtIah2MDp+m7xmvKcDxpxRMvkJoJLgMhSF3O5T9zP9DwqLgviVfMHgksI1FK6F2PuqV7oMEirZonaXUcgJ4f9GlV1cZ7GuyJAh1WD+Gw+EFSaSHvOTJNR/P4l3b8kLuf/RWpui8ZwbXfBZLu5TJxkH2N9fiXwi0mnV0AVm/6TFDLTbuQfpggjTioZgTOitAEzFJvh8MqEF95Tom7dnsbG0vQp1UaYcWMZ9JA9JlnaIR5EyCTuu8+25fBGgD+xmN9bF8JzWDvOij9pMzyVGcvVWKVaZFjr+9xbv0SopR64A3IWE74zcZH2UzndvDkC/YczZ0ammx5bzVjfB3ctCvrHqim8fyYg854nCD3AS5ukUz+mR/08LEx8LRK3mLKfD0FBr/FEVJ/+zHQjoVNEL8/AKNkdUqviAb9oEQjAQPBfWoCZx8AyrvEBhpb+hP7a3JV+CZGCa/pKSXEEURx2ACvxwSkvzUZbdGfAX2/ksLOVD4EHgOMATVX+TYUsciE7Wr/poR8LZq1idmxu8U+4qttDSGcryrhpc5xSR98aKBddLaIgdR/zPikHNW4w4y05IrUzYiPuVIRBUoFdy4ATVVo6L/tTndp5P6CIU5XJ8ERAk6Py8bcl7tCsKM4Q6WVxNCVp7DETa9R2aNH8d4KuM3BrLdgALcwlNfwhlroWJKqFgyDnOGxqxAhXDbvle+1uxWgAWllGHy6/yWBaVnndUQroSLR3gdqUL6H5r0ei1po6/BB5gs8oyaCaMiUG1kz5kS9I/sYxlnC7UKFMBdRkud72ztlF+UHu2+iUg1kFkYCp2ED9qb89ThoyXy042tU8LbafN9Z4PQCZvhcsome100SGBstycHJNRDMpvreg49KYI8xZiUJRVg8CQ2rUdsOmbbYGll6f80Mj4Gr4imNHi2z8aPk
 OifDDGsM
 FJOABh2CnCMT0S4ekFhM6a2wTzS1JQZPXomL3dpO0vhJ3INUhHQeqgOVoU64U6k6ZzdL4c8Ml67f1Grn9sFJMyWn77XnE86coK2+fO00VaMWFUkilWkxh03LVOwVli1kfRNW60rJEOzNkr0OsVx5ckkWr6q/U7zodxjhNXpQGP86IrupWwLl7hinlQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for the kexec-metadata feature that tracks the
previous kernel version and kexec boot count across kexec reboots.
This helps diagnose bugs that only reproduce when kexecing from
specific kernel versions.

Suggested-by: Mike Rapoport <rppt@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/mm/kho.rst | 39 ++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 6a4ddf3440465..2c26e560bd78a 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -42,6 +42,45 @@ For example, if you used ``reserve_mem`` command line parameter to create
 an early memory reservation, the new kernel will have that memory at the
 same physical address as the old kernel.
 
+Kexec Metadata
+==============
+
+KHO automatically tracks metadata about the kexec chain, passing information
+about the previous kernel to the next kernel. This feature helps diagnose
+bugs that only reproduce when kexecing from specific kernel versions.
+
+On each KHO kexec, the kernel logs the previous kernel's version and the
+number of kexec reboots since the last cold boot::
+
+    [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)
+
+The metadata includes:
+
+``previous_release``
+    The kernel version string (from ``uname -r``) of the kernel that
+    initiated the kexec.
+
+``kexec_count``
+    The number of kexec boots since the last cold boot. On cold boot,
+    this counter starts at 0 and increments with each kexec. This helps
+    identify issues that only manifest after multiple consecutive kexec
+    reboots.
+
+Use Cases
+---------
+
+This metadata is particularly useful for debugging kexec transition bugs,
+where a buggy kernel kexecs into a new kernel and the bug manifests only
+in the second kernel. Examples of such bugs include:
+
+- Memory corruption from the previous kernel affecting the new kernel
+- Incorrect hardware state left by the previous kernel
+- Firmware/ACPI state issues that only appear in kexec scenarios
+
+At scale, correlating crashes to the previous kernel version enables
+faster root cause analysis when issues only occur in specific kernel
+transition scenarios.
+
 debugfs Interfaces
 ==================
 

-- 
2.47.3


