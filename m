Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3358BCC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16C596B008C; Thu, 15 Oct 2026 12:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E7E6B0092; Thu, 15 Oct 2026 12:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F279B6B0095; Thu, 15 Oct 2026 12:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD5726B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:07:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3DE1BC0399
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:07:32 +0000 (UTC)
X-FDA: 85325340744.22.1BE6A24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 776BF140007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:07:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oClVWSoc;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792080450;
	b=Se0izup7JY0w81qQLArXtHkzgoDRg0R4WD2YV1C/WQ1aIyPGrY4EArTPrQ6kVtd+gfnlVm
	pfbVxzE0IQkCITbJclmJa3QqAp3TeAle9/8jOuZGKlq6RpLn6ZEh9c1Gb12KBus+iPXxdc
	aT+3cRev6B6XcC+aCziA6RFIKWhVIlA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oClVWSoc;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792080450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CciFSgIFbCKdkyGPR3RAGdYw4f/ibGwxPnazJEcANEE=;
	b=mRyYlI5149cVj5dlNH+/988hamm20xF7UAmqpErUNaPKsFTrnHGGhi0Rw6V8nR4pKqlFIh
	Jfe/O6T3tlxah5dMmKCxLGkiDmyQ11AO1g3fvKLvjGI2ZU6AN30V+ZOmgXnPw+msuyzcU0
	r9/5naMiBRWp6zGWGYYvn6kdjBZ2JuI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 349A46022A;
	Thu, 15 Oct 2026 16:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B38E1F000C5;
	Thu, 15 Oct 2026 16:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792080448;
	bh=CciFSgIFbCKdkyGPR3RAGdYw4f/ibGwxPnazJEcANEE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oClVWSocfqvduPR2ALfzIteEFks2esswxs0F5Y2oZ/OA+HLCsAV/fLlib5j95qPEq
	 +3kZatFC0ANxS/DB0lRArKWAxUA+V/mKeyDOldSMMcAwzYJrl7fu+w2qeL+9QEAvW9
	 wuui8iSP/G/wc3mZPtq8nFawHp2pPEOzw51/wgIO95YwNYlx/8OW3tO/V1wUyYm4tT
	 upGx+ji2prBVevtIwEgY38MI2o90fU5H4R7Z4KqZgUtrXG6Ju8afkoBoaF1ddxngwY
	 Po9NzE5sqCS6nyjwxUxNtqLm3ObuglI8ZrMX9ToVMbhjAcpB0CN5NbdfdbsNMob9kS
	 2W5jC2QjzjP8Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 15 Oct 2026 18:07:07 +0200
Subject: [PATCH 01/10] mm/vma: don't leak the commit charge on mmap failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-urgent_fixes-v1-1-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
In-Reply-To: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Adam Litke <agl@us.ibm.com>, 
 Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
 Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3090; i=david@kernel.org;
 h=from:subject:message-id; bh=PrdvM6UwTy8T7DRmlAnUC/i1CY7asN3v2e9tohKJ6aM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIu/DL+dvLjnYVC5XPumHP1rnrR8tnh5Ik9fX+myYXLh
 yzxUueQ7yhlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAimlEM/9OLcg34K3TmMjy/
 kizyN7FEZ63Q0ohiPqWsv16H3Lcl3GJkeHSnM3SLOv/CjvtnxW7K8s5Zt2/jtcrvfBc3rCpTutd
 iwAkA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 776BF140007
X-Rspam-User: 
X-Stat-Signature: 8xtnrh6tksa97iptkhnnnhdi91pbj9pu
X-HE-Tag: 1792080450-84270
X-HE-Meta: U2FsdGVkX18h3hdV4S1GYrqPteTZgGFT3aJIlqfRA4iEoenTQTQQic3NAWmxrPX7x4EHg87vk4ukGjmCORk7TVw0JB3pxB1igwtrpijiE38y4239sommndk1oz/9Kqj75FtBkyAFl7wt45Z5HMVECzJ49a4gtqoJz2FR4Mx780D6/stSAaZlIJ3h1IKTmcY/SGzRwJoGEnuERLDYXs4+YpF2qDA3MDGdW9TOJsyrecOgvX0R2SkM5OMVrBpg/NpRUbuXfqmmVlb7FGPHW6/KAoGXDoYomLX72lj9JdDLpM1X2HP+A6WEEVtSTRsmmnh5qEYl0aFmh56mVIfI/LBk1SUHWuPGoWrMdtikNW70QNHtRctT9JNE2EpmNbh1Suuao+HEztOloNteMvncEIwwZWkm9FzkD/zkJ6Oie5KHUqKEJvgzVHD0hWQUIf65e1aXE0xzvswfwOIW9FVRG/ZfbWV43E9i8NUwrO8mN+KywySWhkYr/asyIjOqLLKX0URS6TTtRwl8xfKy8e2ocRiRmyHHWmqEzs3D0FOeAyxUSzyTzSaMp6Sy2vIssf4c2KXuNbXLVofjfBnm0Hd2RB1GmH208Y36/KpcmCcD1HPSGCbyOCs13vFtCeMTN2npLVkEo/PzdNVTsU2qlXzpeRAXA9u+OnVsu983gwnCAv2BDU1cJrWibtHnSFlxfkwmcsxwZ8rGC7R/lk/FyKT67N0XDlHVJJf8gNhHvbM4uQD8epr8xW4MQp+eDAyW3GjEnmzfvU27CJmzqHyRQ1/LUGoF03ABSp2ItzsUCrxWj1IDxY09xWkaHzyTzV0WzAhmi8gSx5yGiqP+9i1KYeWRLdXqF+S+OliVTE1IgZIlZU/f0FtW0/0XBIDFagSXWCqMRJ/fO+95SFAJ+Qsr2eFk95o+LK6tmwTkbD7sXFbrVIc44WcVpoYDG+lG37nmzop6YWzSF9D3CFt2HPi61IcVZQp
 4pTCLXWM
 JSJIHAcfPtjTyLpKYknTqNTO/CI+w3Z4e2bakXKThwfVnHTJ2FyOcpST1FgxNT2SvIGS+CFtbBG8X4Bsk5Y+Kqmz2nyDrNJAFZt6BrHtc03JdXFNgGXGQbLc29s4CTnmxkzgCKDtZGNTRVKMMD74u7IDLnL/Om+NCnnE1oMoWEpvpzL1leiSMIbftWO3AxBFzy0qzeePS/0iH5F3Z2ImNq9gbCC3CRXPkOVLR60In1zjISHREDsIBh01+4yuokWi9aHBZj9wF/9RqmPlxfFJ/5RFH00WNckfUpEVOE+p/Rx4fBIohWmS1tqh+ge+/dT0LEA+izcbdH8HxdY7wXMy67EmGbGfnxl+NG0chBPFE0UEmo4438xsT49ND4hZZwIRfv/CK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josef Bacik <josef@toxicpanda.com>

When an accountable mapping replaces existing mappings (MAP_FIXED),
__mmap_setup() only charges the difference between the size of the new
mapping and the VM_ACCOUNT pages it replaces. It then zeroes
vms->nr_accounted so that unmapping the old VMAs does not return their
charge, which now backs the new mapping.

If the operation fails after that point, the error path returns
map->charged, i.e. only the difference. By then vms_clean_up_area() has
zapped the page tables and closed the old VMAs, so
vms_abort_munmap_vmas() cannot reattach them. It leaves a gap and
finishes the unmap with vms_complete_munmap_vmas(), which uncharges
vms->nr_accounted == 0 pages. The old VMAs are gone, the new one was
never created, and the charge of the old ones is never returned, not
even when the process exits.

No privilege is needed to hit this, only a file whose mmap hook fails,
for example a socket (sock_no_mmap() returns -ENODEV):

	p = mmap(NULL, len, PROT_READ | PROT_WRITE,
		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	mmap(p, len, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_FIXED,
	     socket_fd, 0);

Every iteration adds len to Committed_AS for good. With
vm.overcommit_memory=2 this lets any user make all further accountable
allocations in the system fail with -ENOMEM.

Once the new mapping has taken over the charge of the mappings it
replaces, it owns the charge for all of its pages. Record that in
map->charged, so that the error path returns all of it.

A failure in __mmap_setup() itself is not affected: it happens before
the charge is taken over and the old VMAs are reattached with their
charge intact.

Original fix generated by an LLM and sent in private by Josef.

Fixes: 4f87153e82c4 ("mm: change failure of MAP_FIXED to restoring the gap on failure")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: call variable "uncharged" and make it const, adjust/simplify comments ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/vma.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 6c35f0d775ab6..81e2c93a1cc52 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2577,14 +2577,17 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
 
 	/* Private writable mapping: check memory availability. */
 	if (accountable_mapping(map)) {
-		map->charged = map->pglen;
-		map->charged -= vms->nr_accounted;
-		if (map->charged) {
-			error = security_vm_enough_memory_mm(map->mm, map->charged);
+		const unsigned long uncharged = map->pglen - vms->nr_accounted;
+
+		/* Charge only what's not already charged by mappings we replace. */
+		if (uncharged) {
+			error = security_vm_enough_memory_mm(map->mm, uncharged);
 			if (error)
 				return error;
 		}
 
+		/* Our new mapping owns the entire charge now. */
+		map->charged = map->pglen;
 		vms->nr_accounted = 0;
 		vma_flags_set(&map->vma_flags, VMA_ACCOUNT_BIT);
 	}

-- 
2.43.0


