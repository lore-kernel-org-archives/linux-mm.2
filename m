Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D76F606A336
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WMqPKEaj
Received: by kanga.kvack.org (Postfix)
	id 813996B05BF; Fri, 13 Nov 2026 16:46:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB876B05C1; Fri, 13 Nov 2026 16:46:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E1F46B05C4; Fri, 13 Nov 2026 16:46:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DCE76B05BF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:46:22 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D86248015B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:46:21 +0000 (UTC)
X-FDA: 85431429762.20.A6AD6EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 20AA3100002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:46:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WMqPKEaj;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rpd6WLSmRU3qOkeaVFoKOfZ/LYCxe6ke3Meyy3vZKg=;
	b=oM6wnsTF+PRIviO7y9WRHIvyAUJ0k3O6rZ8PaJX9vioQOzf3aqLwd0fAjw7s4U6Nw6kcmm
	3XGE9fDCSQBjU9vZK5n3Iw57sokC5NEeY67mWwPhR3lQEYxfNil6Ig9Uv6SvKad91MhRtE
	19AiiMz2InmLbQg8PN18k5XS6Cj76g4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606380;
	b=FHtp4Ahy1n6Xqd4gzyV6VIGaAZxLZFmErdOgo2n59W5OLuOiqshppgcEB9Gegq9PHNV7wq
	LJvXk6Y0Qifu2jO8GnVnjqIPABafulKKdaeTk0KB/HULk/IdWq1w13GMBNUu9YhRJNqVqh
	PZXCVArTCP3mzjXzbDmgGn9XE1BeoW0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WMqPKEaj;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B538462434;
	Fri, 13 Nov 2026 21:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FD51F000C5;
	Fri, 13 Nov 2026 21:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606379;
	bh=8rpd6WLSmRU3qOkeaVFoKOfZ/LYCxe6ke3Meyy3vZKg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WMqPKEajsCLhGzUkvEZaGbSQ54SbihrSASdI/IghM9JQNHOHo3SgRPvLWU3fE6OYt
	 zKPrH4MjS6QSlFrH7DEK3hVvWDQgpS7FUSUlvjzmGaIfGT9bQq3wFfXNwspyDCJMIb
	 BYbdz36X4tIC6kUgLslyXhnWQzU1QJQzg81t2YlF5ZDx/akEUFTez5KFc7LOYblgG3
	 ZoMtLAYLzwBipJe1aqFSXoFYe71qroTQZpJif6I2UPdSd2bz+W8KCvXB8KDdBdR+ly
	 MB69v33NXvRXb0PA04gQF5hZ+xlel8KrdpgtKS+NSVoyvvnqr4lKUIdPNXOmb/Ryxd
	 HLmFei1P+LnVg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:45:22 +0000
Subject: [PATCH v2 04/13] mm/migrate_device: allocate THP deferred split
 heads
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-4-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1999; i=ljs@kernel.org;
 h=from:subject:message-id; bh=sueKEVWnjnuf/6gb3KihY296WkpSAIKgZmGa4KnlpQ8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t/yoSE/Udbn7csn+WJ7VBzJNikVlk3h/7s1tv5Va8
 W6hXsrXjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExkijAjwyx/t7W1s5IkpaZf
 P1a31/eWh7vL5lgdU8nJ3F0l9SfP32NkWHX98ee0Vac8cw7dKN/pKv7BNG89g4Lnd48dfbcsra1
 CWQE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 646h3krfjcgafa87ughocmtych1b3wf6
X-Rspamd-Queue-Id: 20AA3100002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794606379-751287
X-HE-Meta: U2FsdGVkX1+qdZcawQZ/TarFpGc6LsV2bCh1xCk+/aiPBh0CiNmYpckbw65B2mJ1cuPL4ZNxdjfjDmMyNT8i1G2ol8Ftr//dYaQVKXJwxXzt5V2jL9cpGk6xj8DtrsJskka1ClgDQtZ4fO5LwHH0Ty7OmB0o3zY/aKwvVpRftcBcnhp5URE8ivTqxSzveeK9A57uuKR4dSQvCN+4LCJOEBfaG14FOw64jQhU66DnEaME8r45A3rDj1uuQIGouwZz9HWCJJ5MHSClfq6aLR090Q2SrnbeDuXaKPXOAiZY19MWKnqCd94sIMvL61GufGBQrJPZLikb6oLbdwE5n9SIVLh4Af6CkUP+xULKsxNSGpuvYrAC/0tTqL9yiKT5rcmnVQDVQGPlbmptN4gO8Cz9WGWT7a5eyGREyRRh3wm7P0qSvyB00Z2THQ3MGXJhdfqk0IURKqPsxj+OQXyWDOAPMp0eN+bPGjEGnJHj+72SqweV81dNB6DPKqkKVgvLVAZ2YP8IV9p1GH6dCglqaa6Apz2q5nHQMOiSyKyjAnYz3v7OkODbu+PquFdzYn2YSq+1qyqO4kbulitvQnIjblDyOXKiM79AI6fnec8VAjvKtpQYmnqyfXC97+c+Bi+YBxcqUsw+jyRms0rEyGoGnBxTY/XsT1pCai24VaB8eaji5D8fqjNkZa3cUYT/pzaWR92zl2IcBzQH4ZuDcwKt1hr/9Vj4dtV9FiKDPSk/0kVWJ+D4VsOkIkbH32ND5oZCQZQd67tbihBbL1Ao2/r3CH4tUIlIiSsOvumz9yZWEZav1bDVgf4UMXkg2wWCualowiPVDjLpId+fZfR+lNb6QW87RRNASPrLzDohmrYuGdf0ncdNQZ01VcntExGxYQXgrF53nTSJ6tb3Yhvn9GSHjz8XO0uJ1tDdhBdjERuvV9C9IDtCD3Z+jDOfBYe6LRs8DsoYJpavMYRPSQMvgM6NlLl
 +8Vm/7Gh
 JUErmUhacvtsNafojQHE4lPTomyqmj98kUclpMVlM5zfNlQwmAw0QQIn/kTagzQ4zicHQMUcybBvL6GnWMTV5F30V6rAoF9kW8d9aw9L15RYfeUKT6IC/k7wCgRZhXAe+gITvUBpNVLFv0FeDfVsnRVunGiyqRJQVsKibHDvNUcjtERepzXBdbumFBrKoelf+oZnyjuDGik/Ergjpbhc0geCagUk736JIB1r88/+e6DfUFg7w3R4K7jkhcU93XH25b7d5Zc42Py3PHDCvhp+oyIX91zoLZZhkeeczALxgWWkZbVCToQYlTEN3BONYu8r7dYmMzCeuwNQVbWbYNWUy8PMb8ocp15AkQvtAoZpfdoWmIj8Aiua+xQ/4z6MtMzFjFNKsGDpFNvG3j0x3U8tpHY0gVh4BRnJdiWKRjqaK7C5CZTBtDMIABON3pPTjb0kToywgTC+T9qOtcm2m3ym9hGavQrsiNiMP55fDhGQaEKwD6kgcjJq68cS2Qsma9y4Yd41xu5RMpY3GSxAJHFOCKhKGYvWmLleCXRQAj1NsfCuC+GbI6u/3liBSZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

A THP that device migration maps into an empty PMD can end up on the wrong
deferred split list when it is later queued for a deferred split.

This occurs if the memcg has no heads yet (resulting in a warning if
CONFIG_DEBUG_VM is set), where deferred_split_folio() will then queue the
folio on the parent's list.

Once a later THP fault in the same memcg allocates the heads,
__folio_unqueue_deferred_split() and the split path resolve folio_memcg()
to the memcg's own, now existing, list and take its lock.  They then
list_del_init() a folio that is linked on the parent's list, racing with
anything holding the parent's lock, and both lists' nr_items counts go
wrong.

Resolve the issue by calling folio_memcg_alloc_deferred() after the charge
in migrate_vma_insert_huge_pmd_page() and falling back like a failed charge
if that fails, as __do_huge_pmd_anonymous_page() does.

This was originally discovered by code inspection.

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ ljs: tweak commit message, remove unnecessary comment ]
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 9e19fadfa65c..9e5dab8e1b77 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -833,6 +833,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		goto abort;
 	}
 
+	if (folio_memcg_alloc_deferred(folio)) {
+		count_vm_event(THP_FAULT_FALLBACK);
+		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK);
+		ret = -ENOMEM;
+		goto abort;
+	}
+
 	__folio_mark_uptodate(folio);
 
 	pgtable = pte_alloc_one(vma->vm_mm);

-- 
2.56.0


