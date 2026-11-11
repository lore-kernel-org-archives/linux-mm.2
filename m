Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A86A5607012B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mAqi/pv4
Received: by kanga.kvack.org (Postfix)
	id CA2AC6B05BF; Wed, 11 Nov 2026 13:15:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7AD86B05C0; Wed, 11 Nov 2026 13:15:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7B96B05C1; Wed, 11 Nov 2026 13:15:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A13496B05BF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:15:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7CA7403C8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:02 +0000 (UTC)
X-FDA: 85423639644.11.4A1D714
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0991340006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:15:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mAqi/pv4";
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Buk3PCdlUKSvrN/rLV6mnuKwPReLzCz01F1nyw9gMnE=;
	b=QzskBzfMbPWhG2GVdauHCq7y2cR52Abod2eYTC7xuH7q4+OgMnjIx8LW8bgZC0XHYCWVw2
	Ty6CVP4LCUQ70LeVeB9p64qxzCZuiRGLrmVs0CmgE7xDPnuu9GZeJAvmCvwNrlCC7BWA96
	ChFC8m+e3XDXvsAWSoXp9+xu48jWPXM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mAqi/pv4";
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420901;
	b=0eQTffsVtLUjTLA/IrIP0B63FeOBOzP1ylhmxz7ZydYGa+yAtc/uXzEMR9V/dT3s2jlgZH
	uKoSg015g7WvTmAQZDznYPHkRp+g0IyaFBHewemoNX5hnnlUJ2uRIEc5miwAzW7zim0NmM
	UzabM0wbkKjbalUN7owjtDAzLoBfFtM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EB0042B9A;
	Wed, 11 Nov 2026 18:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AF11F00A07;
	Wed, 11 Nov 2026 18:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420900;
	bh=Buk3PCdlUKSvrN/rLV6mnuKwPReLzCz01F1nyw9gMnE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mAqi/pv4v4Iopb7CiXqu2cDOEuZ0ArviQcECPk+lduBzPgLoWeozZ1fBgRqlh0Wr3
	 9cT2tSNJOstlvhqtkHbi4OuiUFT9CKQWwe1+dOzvcOjsR+THcIH8JG+GlC/NZ1wjpt
	 TPa9A8G/HZyD0IdR/MwzymJuCdDpoNunYGdeaq2pO8zG3mJ33r3WkEoaNrifY60Khh
	 jvF3sPAaiqsS5SJgJYU2jQdfID7nMJiLqBriAFrbWOQ5fuLDTKYd5oJHo2k5jKQAjr
	 vMIfcelKI2iCjeyul09CNd9l7vyc+Ja3PuxltmkMtbkpDvvOQaKIStx0g/H73U6OcR
	 qT0CDECZKQozA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 11 Nov 2026 18:13:19 +0000
Subject: [PATCH 05/13] mm/migrate_device: don't collect a range twice
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-mason-migrate-et-al-fixes-v1-5-3d2454362e8d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2005; i=ljs@kernel.org;
 h=from:subject:message-id; bh=kqozfbS2qa3Y1PRYknIOHsgbbOevcTlvnNv/lqyBKgQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+bMhW/5h0cbeo9p9lTYXl0Va55ocYqntOGgrd7L59k
 1HZZfH8jlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExkSTQjwxOmvrkm7Gs/Wezr
 yL0QPGd5epJ12LNFdmrdU7q3LtuwaRsjw+c1LptN8o5a6mhy/HBOOhSxjzvYaEtxyH91680LFxz
 cxgQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: o9u74i5hjxbz6a5owc87iscba5kxmbr4
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0991340006
X-HE-Tag: 1794420900-348799
X-HE-Meta: U2FsdGVkX1+MUqkXTFFjmsIbQy7NcCKcfc1W53XllAJu/9vgiqcf45Zzs/Sf7/OJNsbFTT9NWo8lt2RDswJKRpQD/XPkGek+73Ul1FgSDME4xAWwqMDp1pUIHZ2ugHQz7Bg5JT2nIDCa1hJyM5HWw94KeDKjElGftZesnMKdJ7wrqz5fAIv3jqqdtEeTWvJKrxIqSwMqxcUk0Olrt5qOyL8uPihTCl5nZeC6xrqONOr1Sdg6Zq5/dXz420bAc9XEFgECyakirkkz9FaLAauQyYwpdbr5hdoQOwSJKiHr9oDurxElBpbpalgtfHZlBOhwar2IrnOVNlbZjS2pwOG6euvT6exEB4YWC3Fp9SzhNjqx8OjfJI77MndbScmq8Q4lZaO0PJaKfo6KWbmWZNuMet1Vh5iZHsqPNDR/dciO9+OyjNpH6o7CGcdtlVdigMEN/V1cH4hXLR3fbQ/25NEH7wND2E5uHUVMw5jllkUusDm8yMQcIcvwBkgS+fPdTmrap/lrWFIgAwn8vuPK5TuwAfWPZLX3Mqes4mDewtftljT4mKl7IlHgFQ0zFMF2aKQjziyX0H6bSsr7k2W8huhBX78FvsX4sU4alcElr4BomwOaA/M6iV92DO1/l7dSNxrbJ2S29c2t4N0/GdPCjydFTavTfasNYt8cZt5qa0WXOCJkUN6Ular7V6N9ymQrW8e4ErFKKYnq6JMbhiZiXd2CiQWjw7zD9hvBQzp54XPIUQQSoTqQUwAmfKufRy58praYkOREgGCe7hjMTFLpW6IqEwfhSjCfUeWAZ9LMMUOBQ2pZNxEQjmwLfCsAy9ZmxpVQr9qgVWETU2BhH17lJ3Na0Q9jbHWD1lY55LdafLmnCeDBiYzWiaA/kSC0BRbtoLTq4LuBI/xW6KKNM9Sa9nFPzFRTV//J4AXN/fLNLJsHkzOrPFe5tPvmWeGzbppsskpQ+6at5ccqNfHqtJ4/dYL
 7H8Zw2x5
 ZX1qpmgfPX3j6dVkwt6kSotDlivEauBHaLlkabimYe2w48x1Y2jRysZURtuigjjkIb8lGTkdM5Hyr+7motFdLPWof65dNqC271qYmcaD1vhga9VHTkLbN4tUK9KKIiiVEzr36Jyc6JVC96l2UPVP2ikxBT74ZMwjz0d2Z6w1v553BVVAWAhpqWyguZRk1TX2t/qmwI8tPAxhDB4Xa7IRIdbqvLss7PTmKQtPtIgeXkTeiLo2lTXCwi0LSY8dEBf1k+TtPsKUEqtM4c1IaTzQYw7WuNTQ6px1gJDXVFfdk8SrcSDXZYTiLMs3GfZpQoJ2m1hxDg4oIhd+wcjsP8mdGbJcM5cHN9tJ8cX2IdhelOj7UpLU8Jhjd959UBDMSaGPbSZieeT5Iai3HHxD60w4++dRSz9A2LmYURtU9jlXNGruL/WM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

migrate_vma_collect_pmd() drops the page table lock to split a large folio
which it finds in the middle of a page table, and then starts over at the
"again" label. The entries for [start, addr) are in migrate->src[] and
migrate->dst[] by then.

While the page table lock is dropped the page table can go away, in which
case the restarted walk invokes migrate_vma_collect_huge_pmd(). However
this is passed start rather than addr, so [start, addr) is collected a
second time.

This can result in migrate->npages exceeding the number of pages the
caller asked for, and therefore in writes past the end of the
migrate->src[] and migrate->dst[] arrays.

Fix this by only handing over what has not yet been collected,
page-by-page, and flush the TLB for those entries which have been
previously replaced, similar to the other returns in the function.

Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
Cc: <stable@vger.kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ ljs: cleanup commit message ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 9e5dab8e1b77..28ed706109da 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -257,13 +257,17 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	pte_t *ptep;
 
 again:
+	/* [start, addr) is collected if we get here after splitting a folio */
 	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
-		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
+		int ret = migrate_vma_collect_huge_pmd(pmdp, addr, end, walk, fault_folio);
 
 		if (ret == -EAGAIN)
 			goto again;
-		if (ret == 0)
+		if (ret == 0) {
+			if (unmapped)
+				flush_tlb_range(walk->vma, start, end);
 			return 0;
+		}
 	}
 
 	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);

-- 
2.56.0


