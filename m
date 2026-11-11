Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE26606A334
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G3G/Avwr
Received: by kanga.kvack.org (Postfix)
	id 550AF6B05C3; Wed, 11 Nov 2026 13:15:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5014B6B05C4; Wed, 11 Nov 2026 13:15:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0486B05C5; Wed, 11 Nov 2026 13:15:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF066B05C3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:15:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB47D403C7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:21 +0000 (UTC)
X-FDA: 85423640442.17.6BA8205
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C2BFE20011
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G3G/Avwr";
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/gMKka0KRVoDYIjz1ajHMHaZowebVJOe2Ih0vRtI6w=;
	b=vG8R5yKzs8TXL7rvMZg78OP6fZVUYDvegmpgbc9WTeSCs+P4lFMIlQzKCofUWOLzkszgaU
	PZqxfMTSnFeRCoyDoxHJEpMmcOUerNTSvalzE0aN5SEWd11xJZgSHP8MSJyT5cxfPHORyy
	tp9CirqtJwBQ74PTs7td2DRmNjvq0BU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G3G/Avwr";
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420919;
	b=wVRrc/0SDGoHhsCEvDt0Kk8vBTHJMAmdL9GH1kg/A5K6Am0HRPpJNR2bB0iEsL8sFBEpBf
	7KqvhxvLCsUQ2pLUlVf55OXfLT7hQrZYon4P3pc5MH6QXtjd+h2lQaHOVUmfwafJ6lq+H2
	LDqHDg1lMozM/IGFHCLWmbPOsO3y+Z8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19F4241883;
	Wed, 11 Nov 2026 18:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AEC1F00A05;
	Wed, 11 Nov 2026 18:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420919;
	bh=h/gMKka0KRVoDYIjz1ajHMHaZowebVJOe2Ih0vRtI6w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=G3G/AvwrGxMCrgciaaymdYokDEwWVMqcW7sQoSgNfmLG73ObWU4/CgPD83q/GF3HC
	 l6OrGPBF3VkAfcGm48h26cMxgB7gl+iWHYpL9jLI89e5MkWICAxZ9cXNa5RVf2AuDd
	 NkZMzfZtPNsjZ6C8UMlihXtXGK53CtGfw8s5FG19kEVcWjA6DBL+cbnKSq6cCfxLH6
	 H/tt27z5bi9yoy5sBEc4ixkK0plFfI3O6qSdFra3ueHxclDVFiCV6jAOKMIFxwQlzg
	 0uQHib+dInkNx5CR9sn3rPUgt8skTptKHSpECdXZOq/WGl6wPw96Z1SlCiYG6AtzPM
	 32lhC+r1+zjBw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 11 Nov 2026 18:13:21 +0000
Subject: [PATCH 07/13] mm/migrate_device: look up fault folio after a split
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-mason-migrate-et-al-fixes-v1-7-3d2454362e8d@kernel.org>
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
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1644; i=ljs@kernel.org;
 h=from:subject:message-id; bh=4y13Zn4Hv1aBFdu53Ug8OJJPI5ryvtg3+l0TbgSLV/c=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+bMiuPGJq8Kpaq2TdZ+lvpce7bHgDLux73dg61z/n8
 1/R4EVTO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjAR/VMM/5TmGzLqzJ/p75i+
 4/qipbOme54KaW6avPTDk0kZpg8Kz5QwMvQsmeGpL6hfW2uxSua96fsk/f/LAxdMWOl7fOvHrQ/
 2K7AAAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: aw99fiwij969dswbek91ttw9wnmmwrm5
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C2BFE20011
X-HE-Tag: 1794420919-733939
X-HE-Meta: U2FsdGVkX1/sjt/uk4C88IjCAf3jy6i0SIix4MjC7+I1Alcto2FaKL1YsvGaOpxDmPQqQZeJa0MOWYOCL7hFzr84si0mfxQFKKxIK/ZNsP5EeS9WPZkYgWzTHVa+xY3TkkY3mkVbDg1ytP15sAFN8XUl+ChuXPf2EmzWuTocQ4Km0RkkmEh5QOfDUbinZxuT/qNyZGXu/mWB40iwkcO2UowagmbEOb9o0XcdiGmxkZCa37viJfLzbufbKcbTDaFOUV3Rr/pSd1SH3l9SE9IkXbeLJO1qWvY+8rPNKlMGUs+veIGujPPOhTVkAmzIO3zeNefSIz7IiBuVBcdRUo9Y1MMwUwhjZAjFmad2P8DKFsXSDlP30Pbc4gqJwtD3lxQ0QmURjBW56KgCUZYZt1AzV1lbhC1KZhFLABc6RBKOHsHNfjVjGoKsYLIlghIkngQ1gxfNwafa9oezQMjIYNHEPtsFI84XTwqio9yyRKPTdx92Eq7MEBFritqvZSVo4N+GgXFPI+P4x+NjSK5YqnYaWUV0jR1TCpicickHtpvzAWK85oI+9ad/j7dGwvh2leAT48FbDc8xWfuKpBpkrLMbz6NwCZdNsN8zOYMegp0Rqj/PR6gYUQTSdGg5EkQwFM4BOHaBljGXwtrXNEQse2jvMMLbTiS9n7chq/K6v2bbCNAaPc/NnlTiOAV3gOTX5mfJ5xgpkgoM1f/SI/8v1t+/8dk3Hr3FNDO/DeekaBGhTVnQ+gUrwK+Swt2BhMGDE33QOBnhfgd5+YNZxjHCEuJrN1gZ5c4i5OaA9bAXpcvhIB1tIllDZurLvT2j4eTrlUA61bCFj0cJx07m1ggI6pwxTEWngYiYQ3QlCnOy1L+6t8tlN/etP0/SQkUElypCYjOsx8DuRDA62vke+ZkFHg8kzSk/TDOEq+5LBtlY8osmgEF6rFllA0CAWPG+nzm2xUvyARKuj6KJ/FxkBO7m17u
 9ysblj0p
 AUKAaPpfBw7q4r7w6ZrrCWtbDK1mp7reHsEZKSdwn3nrE4zufJhTiWUieEF15gWtKJsLSvhKJ3cwLvcoGB5mu+Zj6+fiMi7GeL4aL8u2fzxJAb/WmDvOdFsCPMq9VRfFHqgAQYsRTo3fG5ZsGvLcn5hFAfcdwFeSgUs4tXeV1P2EaTj/EtXX8M8V6L/dTTchDGJ3F/UjpRDcDTmscpQQGoQ+E+RnH7BKlMqW+qDhDo3PmReFAdX10joN+R3Ba+ZysW+l8SBc/Q3IWM0GWT9qv3OBUX527iS+Em9V1OYGrZEyQdy6Ce51oEOtVwyWe50JYvPMy/LL4mcKIkkRrHQicfbBsX/FuJbNHlqd54XhoA22ER+pJ4kvQJ8ds0LVsyfutiuVfdhLT0E3iPRDnbViEw2KuWn8blQTQ3oGv7hwVtmEHMIs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

migrate_vma_collect_pmd() looks up the folio of migrate->fault_page once,
when it is entered, at which point the folio is locked.

The fault folio is assumed not to change after this, however if
migrate_vma_split_folio() splits a PTE-mapped large folio which contains
the fault page, the fault page ends up in a different folio.

Resolve the issue by looking up fault_folio again after each restart of the
walk.

Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
Cc: <stable@vger.kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ ljs: pared down commit message ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index ae795fdf36f4..45e571dbfb4c 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -233,11 +233,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = start, unmapped = 0;
 	spinlock_t *ptl;
-	struct folio *fault_folio = migrate->fault_page ?
-		page_folio(migrate->fault_page) : NULL;
+	struct folio *fault_folio;
 	pte_t *ptep;
 
 again:
+	/* The fault page is in another folio once its folio has been split */
+	fault_folio = migrate->fault_page ?
+		page_folio(migrate->fault_page) : NULL;
+
 	/* [start, addr) is collected if we get here after splitting a folio */
 	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
 		int ret = migrate_vma_collect_huge_pmd(pmdp, addr, end, walk, fault_folio);

-- 
2.56.0


