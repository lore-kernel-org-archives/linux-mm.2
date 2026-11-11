Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3628606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kqUyIhVM
Received: by kanga.kvack.org (Postfix)
	id 725CF6B05C8; Wed, 11 Nov 2026 13:15:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6276B05C9; Wed, 11 Nov 2026 13:15:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5AA6B05CA; Wed, 11 Nov 2026 13:15:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF2A6B05C8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:15:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A4F7A024B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:49 +0000 (UTC)
X-FDA: 85423641618.08.B3E4B81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5BAC62000D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kqUyIhVM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5THLcBMLeSTN5K3PiMki3R6in5uEjKDjlZfoIyutMo=;
	b=7ReKd3tFQO5kuZkRshBPh9atwPOBVX7yfqub2A+dPPyEsTlxIj3KMVVVhFe1jkZ/bRYeog
	jw4i2UtE68xPGP2C6v6qMKi7q4L4YyDAQhxjsyxA6swYN8bFxRzsOKYCJFQyV4piZujCt9
	HM33hD2e49Q1jVogi0scAXFG8nrq5CM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420947;
	b=xV+2Il/0PD7yTPgZ1e9WFdJKN9almxBkERvEEmoIaWaCwxXtZvwJZPOPyBpY9rrodY138w
	OQt3zMXwVVuhfhAHYlQfvtBNFWmJfVPgTyWQWR4ckfhYzItZbaUVNCMxUPHskIG4YLF5y2
	x7VN2j4uZRr5bItP0GULF3L0P6O0Z/0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kqUyIhVM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3E4543840;
	Wed, 11 Nov 2026 18:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9AB1F00A06;
	Wed, 11 Nov 2026 18:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420946;
	bh=h5THLcBMLeSTN5K3PiMki3R6in5uEjKDjlZfoIyutMo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kqUyIhVMNg0ENWRKdyQc8N8j33+TGLGVIncqmNZ+vBtJ+7MWKgecLJZTcRZr0NYzA
	 EzwRv/U4qhhZNRxt/3BImeIrJ1AO2hWC0D+qCzXomrCIVcETdfHqQWqgclbJ7+RCV8
	 aNGyS6AgyZbx5pCIwNvZ17pvVbzgKMeZcUZXaLlk2BgjEkN6gJuYQFXZ8JNFDg674B
	 iUwDMVIrF0bAypSzyKgWOGX64GoQ2eQMO2gs3GWIpiZebajQE9dweskDOIW6toaZIg
	 cyQT2j5kW6RImC9NpPXIZ5bNkcsoeIb6RKIf01tBXjjLLroIRmYEdSDpG/qhLjUwse
	 Uaz7aZvEwK2/A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 11 Nov 2026 18:13:24 +0000
Subject: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow stacks
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1393; i=ljs@kernel.org;
 h=from:subject:message-id; bh=HHmymWLilfGbiIKGsQADYadldeCxqCYd2QRpmZM8e2E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+bMj5vWSa2KLz1dauO05K6Z3KEtijvmTOfK11z7T4Z
 3Rt/bZ6UUcpC4MYF4OsmCLL8y/i+4NEwuZ1XvB3g5nDygQyhIGLUwAmwrKB4Z/lU8MZm4x/vDys
 deLU1yeRp+7s9jBJThIPlxf2Eby49zgbw/8aBblFpnmTK9+aPWg48PD07xOpOzbZ9HbYv7YP4vx
 qepMFAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 1astgqyh6o3sx8o3k8wprsubieht5k3c
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5BAC62000D
X-HE-Tag: 1794420947-634181
X-HE-Meta: U2FsdGVkX1/0RQG+sh4H+CN6oCIfv80zNEveMXqsurYEOHQPG8zrZTPc0LRuS6OVMjByCD8wlJ7hG9R3C4sLRAFayC7HVrFa2+Zp45L136cPlJCCGY0Dz0bGVZAERFGzNLstgajPoBVF6euL6Arn7ahNj3ZjhWbcPdxu96oq8QeErZ4vkNvbmXoufIXfjVotdGtV8SGlgPOSKA7TFS6vSjCM3f3BB4D/6SmycmFCIE/CbXbNWDnM9cxEHNec7ugXl3+/MJ2ZY4XgnrSG+o8AGxB5AP/YuKg9AWHv4EE9EuCpViusXEN5yAa4eyGYiyfZoOU3WrTbtXHgkTbiKofKIpOAe5dvJpQeBqcZvaj0BTjXSteNRk1hn7G4VQZW4rk7gGHNMHWGO9hRwHsDQhzj7HM7YJ8OZXwXVptbodrX6rGS0ZJN11mnbIIRdM/Nba9dbjBjpH/7cMyiiCghdvgWEkrhyPFxNnGYz1GfmoPiGUkr3lF4X0L+2bbFKjbdh/jHU/ApTcZ4A3UXB+wTqx/i0PlaZgxd//YM48ciCuVuNPnUkSBM8SpSDJv+Q1cA/MUUbcJ3013UVJF5c4nrgITuwC3OxIZNDYn6cVOm/5UYGg3QYRLozY1ypS6sEK5L0Ua2+hbsG80OzQrXnAWwqDqrY5urvacrzH40P1GxVhe0sgVk83ugRtHiMFelerqBLKfRSrN1ezPkUTduSMTfecHM2bDxlNS5PDpXHIyWNbnrwiDXMgGY844lQsu85KLLUH4QEADHAy6VEf1vpyJfyyvdtRJr1ATguWKhmyT1+5eapoXZwjedA1wdOVCbALr9sxVhCHPlXU2vCcFO/P5kLa6CxQOUPMSAAzHnjHIo8cgeBBNAiwz+8hXGMTeRLGg0ydpYJ9moMfmB16Lxr0ohkdLZt4yHvd5BHUi3ESUdIOYJV4Eyjs0wJGAaohkAey6PbX3J/ESHpIigKWKNpBYrAdg
 3D9YGAXP
 ehe1aLmZ1rG6f70luldk+3wTAR/9zS+SmgoO9D1j6OnMxvxCRUQi0L7JJipvSXVC6KUKHuRb+0ERunnR/iSpU0uUEsKH60lI0/Rp+XHRRhnkkm7oD5fro6kPoWIbvt0yEWEdu2SW6xqBQ7z6forWyz0eJbHACBqz1giMxf3LP8s+4U8lL8Y4Dd8pygZYlmzXfFxJzEsvJtIjF4Nm9HUU89yV5yYOi4nS9kXCQfPgXkuPfN2yknhzKHD7vIPuZ0NYGWC7XyJaOjL/Bo5LxU6OmJH8h6+MgoE1axdys2Q5ojZlER1ZP0ENUpI2tH4WEccAfu56ijs2PYGw2LGMj9rx46j8C1LnXzdNDPhVGym0wnHIAvVJ/QGi9X2jDAOakOQ0CrhW3nNMBr7li3GkhVocUXpzqeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

The kernel blocks ordinary writes to a shadow stack. But pte_write() is
true for a shadow stack entry, and migrate_vma_setup() sets
MIGRATE_PFN_WRITE for each page where pte_write() is true.

Notably, the nouveau GPU driver takes that flag as permission to map its
copy of the page writable for the GPU, meaning that the next CPU access
migrates the page back into the shadow stack, and the page then holds what
the GPU wrote.

Be consistent and disallow this for migration.

Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: removed unnecessary comment, refined commit msg ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 5fe11dd01291..a59864f2e9a6 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -759,6 +759,8 @@ int migrate_vma_setup(struct migrate_vma *args)
 	/* The migrate_vma page walk has no hugetlb support. */
 	if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma) || vma_is_dax(vma))
 		return -EINVAL;
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
+		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;
 	if (args->start < vma->vm_start || args->start >= vma->vm_end)

-- 
2.56.0


