Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D956606A33B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y4xVmMwH
Received: by kanga.kvack.org (Postfix)
	id 601166B05C5; Wed, 18 Nov 2026 16:04:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6D26B05C6; Wed, 18 Nov 2026 16:04:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6A76B05C7; Wed, 18 Nov 2026 16:04:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F25386B05C5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:04:02 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 481C4808D4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:04:02 +0000 (UTC)
X-FDA: 85449467124.09.37A749C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2013E4000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y4xVmMwH;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795035839;
	b=oIlvScNwtsKGtEH115bxKq9KEsxOLmnQ/kySLXuIwu7ImPGx2BBFWAYrzoAYBhjqCKLDyv
	VMm1CDn6SuE9K7FzQB0JGI51xnGH+aE1GB713E1zViq6PyacVZGmtFT/GbV/LdqExJnl/9
	fUL+GkfZa+nfGl7HgqiFnFW89ukKixw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795035839;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4/9CXaCKwR+a8e+Rb4YtN6Xrcv9L6Zys6gp9ou+drU=;
	b=bg1GRhHCzSUpbhB7JRztmu2lo9t1Fmw3xoPF787+InaF1Up49F0XQUAvUWINgC8h9l/Hzp
	9I0Is7l9u+6WfFmezuXJbcdzAwkuR7a7lO8v3heMW1EK+yh8r7adpotRpw7062XyoEeSPI
	Hsb8UOkcdgEvRF8p2AroI4v8lrVDORs=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y4xVmMwH;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72B2F475CD;
	Wed, 18 Nov 2026 21:03:59 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035839;
	b=zxGM5tnpwRFcm0efdh8tPhzl8e/zf0lrT2opOycyLAJwSrveB765RHpS/FoYAK+/5QAj
	 9t9JofpKwnDOPoXrcwZipNMcznGu5vkN8zzyDtCBoPAsPGEM37c8gISx3T0MpvNb7W7vz
	 TtkyFWPaBUpuW5mS3Bqc6V9W1RVAR8faMMWgYuisYFx6bfLpidp0/BrVW5hfPLs4TwKTl
	 w6F5ypwcjAdkwh324mKhOsKq1bsIPQEPUQ4Uq0ly0t3Ii8g6NxDHSbOKUGMM2tWVo8E42
	 B7+xdzxNDQeiaHIwF+12EoufCbL5F+Nj1KlNxg2JXOzez9dCFFc3UenzZL7ptvn5TWw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035839;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=E4/9CXaCKwR+a8e+Rb4YtN6Xrcv9L6Zys6gp9ou+drU=;
	b=n5+q23gNeIQaTkjtS4PrhiRGSxEgypQy/ADhyasRTFveGU6s+RbumMsjlglNm+g6Joki
	 aIyO1HEq4Hk1CHiK7IdOusg8Fl0jEHS6kr2ujXUE1Qiq7csq4W/F02Xy69g03m/9S4nH6
	 Se1++4iEcNndfKRHSRGoDRv9fYJ37rHlLoqKhiQorr2g7uqVkcQsORrUJR1d+5AfOpePs
	 v0P+bVW1nmYeBbvqoHbYsZ+vr+wrS91oBMpqean0dsPlOLlf4+nNWk6D0xeYLB1FD8ca8
	 /UoM25CLJI+XXOZigIuWAv4nMLqMlC2GjXdr0HfAol6FQsUhYTfcfXgdOfD2WYsuXIA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 196821F0092F;
	Wed, 18 Nov 2026 21:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035839;
	bh=E4/9CXaCKwR+a8e+Rb4YtN6Xrcv9L6Zys6gp9ou+drU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Y4xVmMwHZqwF+ipFrLU1hTLs6lwC9VgdicAfuYjpLI+fKeyta6QsoTo8CkeI3VWPp
	 lq8dkPWmC9jMj+dHMFiCHP1gwnPIiy21b24ofZPBJ4o+c3U1NgSzAmnIi/jXrNOCKY
	 Mi7TgSAbvrLf2RnbzlQEcmuH1siTOyJN5kd6vREDKZ6UsZ3v/0Q4qogBBcOOIVldz/
	 mWDv9jSTpwVwISDj7Wdq5IzS88RYXtLZS8i4yFGBPZGRbxGtUqWAF4Zhxma5tO6arM
	 JLjm7ogjVuzgBJrUirjxlN+kSa3U0Mf5MP+IH6+sIH0aglcsGspStvkCODOVwgItkv
	 NWELs83lnSd7A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8367A4AFBB;
	Wed, 18 Nov 2026 21:03:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:46 +0800
Subject: [PATCH v5 14/17] mm/huge_memory: mark folio as accessed more
 accurately on split
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261119-mglru-fg-v5-14-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035820; l=1979;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=vrmC2+9un5UxKDyFv7OO9k0KgNpOMmdZ6k1J7wplnr4=;
 b=QbYGss5INU4OZp8SggcIPzbLrD6kqcII0Rj4ALNbbDFMY5rCSN4SVyukVmNce4vSBNBwVPH9v
 N2OQruy/P3EAfo691tZIfocByLpuriqA2ipbGuq7KWvtwxZfL2QvItX
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zeq6zxc4pjfh9zaxw7r1q5tq7xnt5yuk
X-Rspamd-Queue-Id: 2013E4000A
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795035839-707692
X-HE-Meta: U2FsdGVkX1+mFHMSBFCZdcrhbR7sCz2bD4udBIoMgHpAJey5nkT1y4uL9/++aDMMzPPUvbocX4HN2QPztKrmhyctBvVUOMaNeiq5AvkX8DZy7f4cffl+oB0iQQUb4Zup2USO4+kQS0bt1rAld3a1gytzoJdqQAaOxc+BUEGC0Re2eN0PzG9PiPRjKwf+O9MxZeFRn0ObL7U1CmLxLahqHDhREH2/43VIvnxqGFnBRnjjFY12Almsc9hhP9du6mUMkAgsi4RZigYorKh3Or2g32lVuC+wUZqlh0fth7RBVHN6r1QjXRJhppP9JsVVGjkIw5XUrGjD+XLzfzy/Rgqt4uSKy0RmRIxcD8CjvFnPl5q3AQqWtjZEE73Ag5DqgqsBeyi74hDrQn98Hdq91kMoPYT8OCsP42jNOs2eLVteZ1zBYDP+eKO3b9wfMQWVeCRVkab12Sn/Qu1hygXif+imkBRF1BjWlpzGlypOHK0RLjdG/RCH7j6Yz07vP95yHlnXT+JRsa1NM3+hGWe+4Pdobz49GecAoViC1nhNklTIE2guJfU/oDDkCLm/FqqNlkhAuOx7mp3OL7fknnqBHDNqoHPjo61gpIt4Cbi4PrQaivqXAkv9o5gtl2B60J09MDKDhb65paFlAdGUzIwBKWjC9ozO/MSLFdOhl2tXbx0ZZayXkQW7OMB7vvT1a+ODtb6bLBSXn/bueASsVbDIaZbnFYeYnvhUo3dz/uXJ0q/LuvMSme5PKYZVPr55QY9cNSD1keWFKLFdZG0ufg1+LXWyo7OwUD6SJijIbf19eEa+cQKz0xRjr8pnyeYDa3pjYmHG1lSdYDxcO8fmZKSxXZOgKh0UnV1Ydewl29MGqDfbtZbrOtky6QT78WaUSE78FB4D6N+0d6s9t0sHBt5dqhQwXlhhhxL/5vVaZFwGjSrJ+XrblJ2dTHxqJJkgqmL+jI9nO7YSnsbqr/4Pw4KB5wC
 Earc6hGU
 PCARJAILqL0MNNzm7im2cZQRaMxhCtXxy3yg9GCQgu6IqG3o1nGAeODFMFfz1BTOvw+Bl1miJiXWqYpV6/pLHjQc5O4rTdqCQ1czhTrQkZvA36D7+TmVNIQanX+MiciKUsKLejeVoYunHydJd72M0VJZw4U17swRGXs5sL54bJtob8bDptmkSHPZjKmQ4Wi7g3maMXwcQ2U4sS1wPtUtxPSw2rd46syEC+PjojMQ97QCOhriKhyeB9sMolBLa3eXcgyWPCfwbb4Kvdmb5wQV4edN6B2xyjlqyuXrBbkQV98dphzoaxvm7kl9VPlOdZuEK83sz3Tl/5e9+cGdtTh+R9iBWg0xmNVztNkv8Pc+CyRxNx0OAarRjXSYwZWbVAoS9q8yTQCp2tdmSmSWHrw1ucPPib4HK4fHo4XLj2ZbM0S5z/F+vqsRzMvYls56kMCE2Ab0O9JvvCDz8Ltoa6N8TIAcME/7g1WMbaQKZLDGJkHrm3g9EE0PX707npL9RiQ94h4Ra/wzhFVWmSYOKnbgkIG4SxcO41GZ5e9F/OL/0m1plxbLz1kDRV5UlwD6H5kflYjWiXCPgyhPFe5miUVIiC43cyTPLiBekL5HbKSiWPFpGqWwGBNRBoC3BVzCjEZR0GICu7aYysbziWIFn76bbuFlVX/w80VOZwlwswrL8RY6vNjxsjB5vhulG9k5kFl8rhBMTEJiEPhc97nlAyLVLD+tavejzdryi9NfNyAZ677wwzPGXlktB4th+1NI3sA/bLL5qod7S4d/ulY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The behavior of updating the folio's access info isn't consistent for
huge mapping splitting or ordinary unmapping. The page table's young
flag has to be translated into folio's access info.

Right now it only checks and sets the folio's referenced flag, which isn't
enough since folio flag updates on access have their own rules. Ordinary
unmapping (zapping) calls folio_mark_accessed(), and it also checks
if the VMA has recency to avoid false updates.

So first just use the right helper here to be more consistent. Keep
accounting the young PTE as a cache access, sticking to the current
behavior.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0d589be136d2..1a415a6704be 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3104,8 +3104,8 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 
 	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
 		folio_mark_dirty(folio);
-	if (!folio_test_referenced(folio) && pud_young(old_pud))
-		folio_set_referenced(folio);
+	if (pud_young(old_pud) && vma_has_recency(vma))
+		folio_mark_accessed(folio);
 	folio_remove_rmap_pud(folio, page, vma);
 	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
 		-HPAGE_PUD_NR);
@@ -3227,8 +3227,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio = page_folio(page);
 			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
 				folio_mark_dirty(folio);
-			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
-				folio_set_referenced(folio);
+			if (pmd_young(old_pmd) && vma_has_recency(vma))
+				folio_mark_accessed(folio);
 			folio_remove_rmap_pmd(folio, page, vma);
 			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 			folio_put(folio);

-- 
2.56.1



