Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5763ACEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90A46B00A5; Mon,  8 Dec 2025 01:30:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39596B0032; Mon,  8 Dec 2025 01:30:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76786B0062; Mon,  8 Dec 2025 01:30:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 973DB6B0031
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68DDE134641
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:28 +0000 (UTC)
X-FDA: 84195329736.24.3CFEE3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B524C18000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UGROWyCH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175426; a=rsa-sha256;
	cv=none;
	b=fqCNQlqjdf3mbHx7O25IlNIoRLQhF4KLzvRqrT6Uy2xM4VoEcLAuEirdsNlmhBgZrq7v6N
	AtP6DBEHbEir0u5RWC/hGz2Elc9ORCeo2T876PCQd/YSZsowUkPdgSAdN/Vs0bw1sY12pc
	5SPWOJpBK0RFBaOcWQrHhX9TUPJOo30=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UGROWyCH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKGoZL2WQcxgViFaytyuKft77FPNq0zXC7vMlNBl0Bk=;
	b=Pm6E/uGnfS6EnUJItxSVzTE8MNyO/xJrKDgqrLSOmT9dK0lcNvrbp7ckqNmb9+3d3UgQPz
	9P8DyAC8PJ4w8zXB0HKm6QBmw9ADhL/oM3diF2cczcQqK3W0KuZ6WF9iV3nknnsdIu3+x8
	BppIsbSYAedeuhwcPvdh51IgfKiJJgs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D93DD43EC0;
	Mon,  8 Dec 2025 06:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6D0C113D0;
	Mon,  8 Dec 2025 06:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175425;
	bh=Z3BU9CS2/j7n/yC26uZia3+mZzwDzeK0PuZdStu70eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGROWyCHMiZMIYeqcr9kV7I8TYwKqYB9dRXryFVgu9qrdUCUTVwppf6+w9tTDAObP
	 eXbFXGQWcLfv6mSZ1Kk4gbN2jUTUBgrh4UsshTLQl0M+QNcp8Va6gBCWilhMd7FMaZ
	 4DUcJ9l49nwkMViyr0l9E75gM7sUyXIDQ523NrpDHVq09jSfynaZnvsyNP7tyDC7sp
	 OGof0rw1sVdJphQvqXV1bdF3WzW6jSzjaq5FeBZkl+tTFBq/iAzb4eTWgUtxvglXKU
	 3x/828CVdPgula6Cy67DeV3ihTijcTjCP1s2IJVmDO/LABJ+vgQ0meEHAxSsg1BHEY
	 iEoXYUw9mJvpg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 24/37] Docs/mm/damon/design: document sample filters
Date: Sun,  7 Dec 2025 22:29:28 -0800
Message-ID: <20251208062943.68824-25-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B524C18000A
X-Stat-Signature: 46u3ynjc66xcyhhja9zy9hfdwuxmmia7
X-Rspam-User: 
X-HE-Tag: 1765175426-540907
X-HE-Meta: U2FsdGVkX1/eGjjNvBaiJLvNjTB2E14c+U5nXZeR3EpI9HX2MSuEOgLgHm0fFWfOdr+NAcP6u9/B8MOJovuzQ35k28Cc0123fG4YF73/Y3BF1AMqkbTIFg7Qq4qmjyPtkM+CHdGwrTeuRiYFLYq6EkdGXHxHIl+NhKeqDo1HUWfmMUOZ6iUvOwIY9i3NyrMAvCoVY4Mvtg6OGW47i+iWzVhWb2BZ65jnQhQ7alw0xPxlmFEwgJ1S2cIv8zlHdPiL31s5CkBI9OO8kfIESmrx//qhxx9+1gprGxZteVOXMvrcPWZ4049TuyN9sTbt22++jXHQS+KGAJP64hpuxn/ZcJf433DR2ZavdjSiD4L7dlDL1X9uGBtuOmEHJBUWo1Iaf+8CaYXPsh4RflCH/+ILonIkuJQrf8+yn+qL4ag0ZMxubW/kXsA8kW0GDB05afGc3JyOzTnW7rmME5wep/LmZnxr2Snl6glVkMhGNnL7zmT6lYQhzLaPrzfucetGDKsAqykTnfy/dMQ7GzLQl8ORgRNszh9rkoYS2hhZw1k2TvsJFIYrwSs1aVoR3knfEjEqvjI1G4qnCICSi7xM/QIYGL7U4ADp5RIhM6fq0IbIZFIqzaeSJXZXGoZyBpXGKgJgkT4koz7JHJTrczFgZXiTAifAf48oA7sWhTZSUbXixHiZ5Tj2OT24YrGgm/fneOcknhyb8NyQJNpiJx4D/iSUup8rKtKLmpHprEvFY16e4bmQXVKCxxJgzqxQPjXnuas6bP+mXJ5JqZA5o9iGmD20nSdt7Y3SHoYSMg7DToYAzmSIuNz2npfm6qIC96nBgMQATba9cPH77B0ONnT5RuzPzInBysfluY/OwUwfJgZ/RAoCw/AdUH6xBHiqY5fLBdkMMhHlOvhThHnck7x53oeLHr8umZ5XcrZY9gcvYxIXNUXOUVcGwre5tWVxgLt6ZTjky4EfYhQUFn6+ky5nATN
 a4rife5p
 qDdZTR6cPBSYKKVCaic4/FY8swdxeljqLlkH6fO2vykHtIPqyW2GIZAQwEtwls1xejPadjkyG+EvE2hoWPhEKzZQ4NYJyPVRbzB9fN7EdVPn+rZCiWr1xKeobjDO8LEO4EQbelQujGr/Ww8K3C/9gZIXWCMumaE42INBCkaFyIv2JKrNcH/acFWwUKD0dccbGB0Th0bv6ErUfx+TW5iEOYCOrnTKEE8LKjY2NCcgJdsgCltY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the access sample results filtering.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 42 +++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index a21973b33bc3..9a4679de437f 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -146,12 +146,17 @@ do the access check using monitoring-purpose page fault events in a way similar
 to NUMA balancing hinting faults.  When it is being used, ``paddr`` installs
 the page protection in a way similar to that of NUMA balancing hinting faults.
 Then the page fault handler reports the faults happend by the installed page
-protection to DAMON core layer.
+protection to DAMON core layer.  Compared to the accessed-bit based one, this
+approach gives more information to DAMON, such as the access-generated
+CPU.
 
 ``paddr`` uses :ref:`accessed-bit based check
 <damon_design_pte_accessed_bit_access_check>` by default, and users can change
 it to use this page faults based one, using :ref:`access sampling primitives
-selection <damon_design_sampling_primitives_selection>`.
+selection <damon_design_sampling_primitives_selection>`.  Also, the addtional
+information can be used for doing monitoring of only specific type accesses,
+using :ref:`access sampling results filters
+<damon_design_sampling_results_filters>`.
 
 .. _damon_design_addr_unit:
 
@@ -277,6 +282,39 @@ support from the operations set implementation for virtual address spaces
 
 At the moment, only exclusive use of the primitives is supported.
 
+.. _damon_design_sampling_results_filters:
+
+Access Sampling Results Filter
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Depending on the access sampling primitives that used, the sampling results
+could inform more than whether an access is made, such as the CPU or the thread
+the sampled access was made from, and whether the sampled access was for
+writing or reading.  By filtering the results based on the additional
+information, DAMON can perform for more detailed access monitoring, such as
+per-CPUs/threads or read/write-only monitoring.
+
+For such special types of monitoring, DAMON provides a feature called "sampling
+results filter".  The feature allows users to set an arbitrary number of
+filters for the sampling results.  Each of the filters specifies
+
+- a type of the additional information (``type``),
+- whether it is for the sampling results of the type or all except the type
+  (``matching``), and
+- whether it is to allow (include) or reject (exclude) consuming of the type of
+  sampling results.
+
+Each filter is applied in the order of the installation.  Only sampling results
+that allowed by previous filters are continue to be evaluated by the next
+filters.  If a sampling result is decided to be rejected by a filter, it is
+just discarded and no later filter is applied.
+
+Below ``type`` of access sampling results filter are currently supported.
+
+- cpumask
+    - Whether the sampled access was generated by a cpu that included in a
+      given cpumask.
+
 
 .. _damon_design_age_tracking:
 
-- 
2.47.3

