Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDAE9C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07416B008A; Wed,  5 Aug 2026 07:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1B166B0092; Wed,  5 Aug 2026 07:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2A16B0093; Wed,  5 Aug 2026 07:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98CAD6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:33:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1677D14044C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:33:52 +0000 (UTC)
X-FDA: 85067006304.15.17ACF73
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf25.hostedemail.com (Postfix) with ESMTP id AC5C8A0006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:33:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="F//47ujD";
	spf=pass (imf25.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785929630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4KGtsHPrI21llwIbHUdeCyeA20ZKwag/Q7Ksa5cO0iM=;
	b=SqUqRGv5CSCgha7U8/mXHxIWPTX9g8NOKDH9GOp6hy2dJruzHg2yb1KEYJay6pACyLk7FW
	nsqQ6GKwBuk7V8hNBeKpsFRtcrpcoYRbOixr2wPPLzccynnfRVLh7tzeSUt5R4h+r+DePD
	MzguUOXzh9DkT4+rs/2bfP8/LUQIcpM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785929630;
	b=MK8uj4POOtC1WUfuonfP8737A8Gr5NV3om53TlVN3jGZOLIocYoBHPaG4UMMTObSnUb6RR
	M/2IB4HatOo1RPI9GSsqL9OuP4+uS5ilB2Ty++bbCHs/R4xremvG31APqaPbxZPzXEn2pl
	9JeaGuUU5fijCbYSvpE1QiGgEwg3N9Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="F//47ujD";
	spf=pass (imf25.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785929630; x=1817465630;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XFroAvYH17C1kIbfMY9Te9f7dnenPbxnYxawMiiS4nk=;
  b=F//47ujD1qYvJQZpZOqYBr1NbpLVQrlUSOFMbTUQsNL0gzCA7nm8TMO1
   Vw2QfUkX80OYWT/BJl6O+dg0hYSoTkT70a+CATG5Ra/+DzHFokD3e5xVc
   5aO4fBgjNPMbFA6824pCZXVDVdWc+agETtwIYGDUWMXGY1E1VZK1s6sR3
   3O2/HuyrGW8Ucb87yTXk1LwCYvIXbbqUyfEvYOniv523pmR1i/qAcH1Tg
   TgQ/xzGy9zUQQOYzI6H6MQWqMyOYy23lNz4zBDq2tW2MmWwvTVmVK2qlg
   ENP6mXHNhksUw2zoLK+04baY7fgJEHDfAzznhFY70q027E6dXHF8bXv/C
   g==;
X-CSE-ConnectionGUID: rAhYJH1KT2e1Kp+ud2lGWA==
X-CSE-MsgGUID: 1IsNj5B2QZCRP/i/U/uSNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="86358154"
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="86358154"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 04:33:44 -0700
X-CSE-ConnectionGUID: yffXgL7qQ8GKqJjwPIMxtg==
X-CSE-MsgGUID: WKTCoPiMSbiE5AxVR+5rQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,206,1779174000"; 
   d="scan'208";a="265289741"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 04:33:44 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH 0/4] Fix device page migration in low memory fallback
Date: Wed,  5 Aug 2026 04:33:34 -0700
Message-Id: <20260805113338.3742178-1-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC5C8A0006
X-Stat-Signature: g7tpu8gbqchd7rmu366oiqjyfehyr3oe
X-Rspam-User: 
X-HE-Tag: 1785929629-163257
X-HE-Meta: U2FsdGVkX18OVjNr8VDsWoN6JRTzFzONrjKETn69tUBWlcGZMi3BkTR/dM261g1y8EAXsUotAmrh7X40JldND/BrgcbFqZfdD9RKw3gd25+axeJ+IiiTnxq6ihFtDrXtxirgt6i6UPSpTsJwIrkfVEa1um5sZziqTMkCtEUa2mtEIgmWsVDJ5qhRMX3IzMq3b6JvQ2LqmrrsTWHT4rA+TFl19VbrzLmwNddYUs0J5TU2dGNk0zGGXAKr/I0C3OOxTPeaEeOCFyyGCQtd/DFOQVIow6ybpZPglHNkxYYq6KW3kscCk3v1ahMZCoC9nslQC7RcKgcf+SWWmIddyIpgZOoL8ozsPPH51gxjPJXZ00/BnlagaxhxH2HR56dwzcB9Qe5EScpPH+48B2JsFqpQZ2Z9IbxttOOZfW66wS7GGm9Dc0HxLrkEQHwwg18vmbgSHbibKzSrPZOjXgnOyC1G69/hhXOTnGMmm5fpKHGucl3t8XR2cAE7T51SjtAneb2zafX90M1+xtOfC0KVeIumCmz6fEGLz3C2ss+TxN77UEPAiU7gzvV1Gk6BDFlW7WZyvLXoOsL7iimZ0P+fzJV3Q2D1KR+vhh6Pbx4N8SaapfygxJqFf8ZBI4BxmzYyEvcjI9sVIT7DQI76YV72uQFu5myajz5r6rqYaki5VgXLWjNLMazu5jlG+B8NDkdQygJSty1ctBRJuBJQRVE7No8cWOmqUVvVh6SNznN0VaxlMptnBgKGFfUGtawVt+z1S+5Px6NqCMoeRCh4kYyqz0Lv3FyawgmPrVSUlvANyojnD5r9SAx52Kj2L+EusRfk7u+qNB5YD/2C4H5TXhRzHqCyy6Z/5jbNkdBYLygrGoZfQbaV7XdF/Z4EnefV/XPBmb3FJlmBUX+iCFoOt+AUnWSq4dcKfilNAqMvhtLjQez0Y1mq/ve5Tupeqpus7EEAT+XnngS6Xdf4AF/nWKB9sTp
 q0hvaYSg
 Gb3c6WyjD6n47AZnRZQ5Ks69hllUvvzAmtGzdc+FanGu2O8J1jBUpt0TsVjUhDGvpXPUyJtgsFn+I2RSUEj0tLmyNUjO39o7eg0KoFdbQeov1SCu+RGuvA+R4Om1fbjVsEXDDJ5Qf2c2kqndjio9OwwugdBPYqcWWtU6bQ932kaR72u5SVUNw62tojeVT5CMCUxg9tgStLoQ6y4d5chI/I7C0ALZCJDaLKGgr4JrlmbQp0m8SKTQK7C648L/cqc8a1DvcePvWt4lmIR/ZGjMJYkm9yocufQhvu9mqDo1789OnYbf11AX/Oy6pWMpJuFvjhca3msHkXOEPxNXscOJCWlOomOWZW2EQyVMkMV05TZAEt9/QEcVe+KBgVdNmB28K6Optqlh+mBS/o1k1VkoUJRUWy8ZwWwPALiu7SLFrdS5zlSvHmiQEWv6PgNEBq7wz3H5OVADxHfhh9/8HMNymJ/wFki652oeTyjp7PkJw+MT/tnZacuGBB6EWl1c1qAHjxECMTcCuAIlTdO+UB9al71icIKZytxBxJCjNaEdyKR1cROchOT8mOqKun87FdT7d4EQqedIabboE7SXmL4DG+7aJtM8ig4xH0SJLz+O2HosiZYmtHuxrx35Upgz7JMK0zMTTDvQsfmL+FsE/o176Ivgefciu3+9j+lL5AuIEzhTIHQq1rXaPPQ8Hf2PopAwH8pAeEGHPvEtsQCHud+fYClaL50HqjrkwaqeI5o2uUyrtjvRN6LB19Z2hPp4veCT7pZLXeDQhzcPEbDtTENdLKl+zDLduB/3UC7wfeV0pqrwGnzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

LLMs made my breakfast, lunch, and dinner. Not really. They served as an
assistive tool while I performed the debugging, testing, and analysis
needed to isolate the root cause in core MM while fixing a known DRM SVM
issue involving THP allocation failures in the CPU fault-to-device page
migration path.

When a CPU faults on a device private PMD and the driver cannot allocate
a compound destination folio, the source THP has to be split. That path
is broken: the CPU fault reference makes the split always fail, and it
demotes the PMD only in the faulting VMA, leaving any other VMA mapping
the folio pointing a huge PMD at an order-0 page.
The latter is memory corruption, previously masked by the former.

The DRM side had its own problems in the same fallback: there was no
order-0 fallback at all despite a TODO saying one was needed, the error
path computed folio_order() after put_page(), and once the destination
is demoted to order-0 the source page array has to be populated per
page rather than per folio head, or the copy stops after one page.

Validation was performed using xe_exec_system_allocator. The issue was
initially discovered on systems configured with an artificially
constrained memory footprint (mem=8G), where failures occurred
intermittently. Error injection was then introduced to reliably
reproduce the failure condition, enabling thorough validation of the
fix. Results were confirmed through pass/fail A/B testing.

Matt

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Assisted-by: GitHub Copilot:claude-opus-5
Signed-off-by: Matthew Brost <matthew.brost@intel.com>

Matthew Brost (4):
  mm/migrate_device: Fix THP splitting of a CPU faulted device private
    folio
  mm/migrate_device: Apply the fault reference to the correct folio
  drm/pagemap: Fix folio allocation fallback and use-after-put
  drm/pagemap: Add fault injection for higher-order RAM folio allocation

 drivers/gpu/drm/drm_pagemap.c | 150 ++++++++++++++++++++++++++++------
 mm/migrate_device.c           | 120 +++++++++++++++++++++++----
 2 files changed, 230 insertions(+), 40 deletions(-)

-- 
2.34.1


