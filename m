Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A15606A890
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aM3mzmKI
Received: by kanga.kvack.org (Postfix)
	id E83846B05BD; Thu, 12 Nov 2026 05:39:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B016B05BE; Thu, 12 Nov 2026 05:39:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71BB6B05BF; Thu, 12 Nov 2026 05:39:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A19336B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:39:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32FFF12054D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:39:27 +0000 (UTC)
X-FDA: 85426120374.03.981DEDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 793B91C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:39:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aM3mzmKI;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794479965;
	b=k+9EssEXg+HaMtW4MXylRjuCPwPgzisiCZjzQZ3F2Jb+ogOwg5y0AxmwSIFzdQyaDS0564
	3iVuJrMgjhAx0pOuIdAi3ATxo3uZQ+lzVCshkKDsrO2bawmEMVLAZmnz4mmn/kkgYvN206
	TwKBDFHoXHzf68C5DL1zOrsU5xZS4gs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aM3mzmKI;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794479965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cz2r/Y2RPzkO+j+uVzXdreXvdepgECgH9EKrVQJEg7Q=;
	b=mI5oaqmbr+1XOdWWpCciY0VqNxNFMwO+7QTzU7+m2oiKzbn0yk0L6wBBPWme0w49y94hQy
	oAAnFYMxS6p9w7plcv49kDVCDGm/25Bzb2p27xi64QdnBLEVzW39XLktRBYPg5FvnL7HpQ
	TTO+IeZkyz961jxJ0rsQBysdzInZd18=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1267473F1;
	Thu, 12 Nov 2026 10:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A6C1F00A06;
	Thu, 12 Nov 2026 10:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794479964;
	bh=cz2r/Y2RPzkO+j+uVzXdreXvdepgECgH9EKrVQJEg7Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aM3mzmKI0GmlyxQCwRqIdTeDtT0/EkcRgXJqO8ZBSxOztx0GD3kM7pxCxTvuI6bWL
	 MAKSxVbRYHVhlIvlXkKUKAAfZyvvr+Ydf0POkAqRJf7LOKPxy8YakB9NQK4bUKrK90
	 vTfKz89aFtB9W2vtJhdgPijQChR/2aNFBgW0zCJ58q8xOyLwnNLj9Qcqy9FGSacTy1
	 DpUmPBZEEqnDVIu9K8UwDTpwAiycuDEh2XnUj+LHjMN/vWv0HAu+Akq6EIQUbHtG8n
	 aSlHPG19OlhtCa8az5aDP76zrHzt2H+/GoUaj0qUBw+C2HWU9vCt48hdNRe4zjs0BJ
	 cDAuDWQHAJFEg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 12 Nov 2026 12:38:57 +0200
Subject: [PATCH v3 5/5] kho: docs: update description of bootmem regions
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-kho-bootmem-sizing-v3-5-f0c8d00295d5@kernel.org>
References: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
In-Reply-To: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>, 
 Kexin Liu <liukexin@kylinos.cn>, Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 793B91C0004
X-Stat-Signature: xr6fpao7cepcasr1feh3f3zt4gnmfn8i
X-Rspam-User: 
X-HE-Tag: 1794479965-291359
X-HE-Meta: U2FsdGVkX1+krcz7CofrS6Btwub8GjEzkVy7F6OEsKQd70uE7dZHaza0KuylxpO3VOPEIkOFK9b2jo9GsQSc8Qn2BtEBbLzuW9lO7uCCHqgS6neNfQrUxwx9C/x6t6jqKASo+xG1mkUnXthr1uBN0CLvwMj6OkHN0ht9TipOK6YuMazIGMm4w9csijnDwmXmTOB+TI9BRvm2KoxOsjzzUyA3v2KD+PROc7R63ujXq2ZtAd1PzLHeKtjU9DOBK0mjOntf8UAov1+5Z4zLSe08PwYayjyUDs5IYq4Ftd4Nh1rrKkv4ws+WWVSZYANEAwQGw5DCO/vd8fteIPLVuNkLE4se3TDbpPO3YOZSkIRuRkSPd8oxKUyVkXP5qJ8NUSqrfnumQd96+fB9cJHp9G2BX2+hYnrlg0ibqKs33C+5eXbv6LhAwCGY96jLpGme5QHOSvutQ1EfmYeJYgrX0U6/wpyXb8wHBqzOFparmBlGppeu9+dQr8icZAGCVz/CDY42WzEAS26yMrqvwoe0X1V8LgE3ytQTdF6hIhpub67QR3X5oj8fHVBbPXEiNoE3hIBQzwKfojn2HbKOv89FYvviHWBSsfVAnT6InXLiJ3OcoAKsMsHXji+8ixC8HLuCxgi3fBb70CaNPGUiDrJ0dbmvdmNIwXscENj/aU3CcJGBtrkKIJL1CV3Xj9zruTZeuGj0l/QaZZOPZfk+u+3Jdt9QDeT1pmN+TWJp7WCXlLSbnvpV7NVGP+DxM5loRfKCNrY8pq8ttZUKPxQe70zR5suBOq2BL14EuAXQ7HVljC4v0ddZnJHxOqSDugwpzcIB0XXwytdGvYeIbfRE5nsrjTUqWniZKd40a0D+YFmmgLgEF/gMdHYOX/LVOU+qelsGri5zeZyk2aPMkqkDFZJ/EdyBTmTqMyUiwgkY8bF9aS90wSGPxM/tJUp9ZBRiAoLWBIj7Te7EilZMleVhjGr8snB
 mygw5MRk
 FwNTl5DV/kv7X1cz5gQzfX+ULRXvGXOdIGQD45+T9FUktgrpe1JdbnKjOIpOOGCW9IDQoKR7AlWjqoJBzxTG8UlLM1WOWAneeKp6rF2DSQvyanGyOEJb34MW4lkOx8tertgncqn0FFfIgHuvQtrSp4wRr8efXQYBfPxbw7E2Us516uiSvtkY9gJ6OokY+x94dKokvpFhG6zGr/RP1GouQ0F7DDmd34CYyjDzonMz33POj1/zPnWjvjh24Qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The description of the boot memory regions does not mention the low
memory region and claims there is always a region per node plus a global
region, while the low memory and the global regions are not allocated
when they would be empty.

List all types of the boot memory regions and describe when they are not
allocated.

While on it, fix grammar and split the description of the regions size
and of the CMA usage into separate paragraphs.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 Documentation/core-api/kho/index.rst | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/Documentation/core-api/kho/index.rst b/Documentation/core-api/kho/index.rst
index e78a2bbe2be1d..ce2bf9cf66514 100644
--- a/Documentation/core-api/kho/index.rst
+++ b/Documentation/core-api/kho/index.rst
@@ -52,17 +52,26 @@ allocations before during boot up to the initialization of the page allocator.
 
 We guarantee that we always have such regions through the boot memory regions:
 On first boot KHO allocates several physically contiguous memory regions. Since
-after kexec these regions will be used by early memory allocations, there is a
-boot memory region per NUMA node plus a boot memory region to satisfy
-allocations requests that do not require particular NUMA node assignment. By
-default, size of the boot memory region is calculated based on amount of memory
-allocated during boot. The ``kho_bootmem`` kernel command line option may be
-used to explicitly define size of the boot memory regions. The boot memory
-regions are declared as CMA when page allocator is initialized so that their
-memory can be used during system lifetime. CMA gives us the guarantee that no
-handover pages land in that region, because handover pages must be at a static
-physical memory location and CMA enforces that only movable pages can be located
-inside.
+after kexec these regions will be used by early memory allocations, there are
+several types of such regions to ensure that all boot-time allocations work:
+
+* a low memory region for allocations below ``ARCH_LOW_ADDRESS_LIMIT``
+* a region per NUMA node
+* a global region for allocations that do not require a particular NUMA node
+
+Regions that would be empty are not allocated. For example, there is no low
+memory region when ``ARCH_LOW_ADDRESS_LIMIT`` covers all memory, and there is
+no global region when ``CONFIG_NUMA`` is disabled.
+
+By default, the size of the boot memory regions is calculated based on the
+amount of memory allocated during boot. The ``kho_bootmem`` kernel command line
+option may be used to explicitly define the size of the boot memory regions.
+
+The boot memory regions are declared as CMA when the page allocator is
+initialized so that their memory can be used during system lifetime. CMA gives
+us the guarantee that no handover pages land in that region, because handover
+pages must be at a static physical memory location and CMA enforces that only
+movable pages can be located inside.
 
 After KHO kexec, we ignore the ``kho_bootmem`` kernel command line option and
 instead reuse the exact same region that was originally allocated. This allows

-- 
2.53.0


