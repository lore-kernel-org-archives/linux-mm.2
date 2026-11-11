Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559DD607010A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AV0siQNe
Received: by kanga.kvack.org (Postfix)
	id 6D64F6B05BB; Wed, 11 Nov 2026 13:14:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AD746B05BC; Wed, 11 Nov 2026 13:14:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C856B05BD; Wed, 11 Nov 2026 13:14:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7286B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:14:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7D2E16036B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:14:43 +0000 (UTC)
X-FDA: 85423638846.19.9BCB423
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1531440007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:14:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AV0siQNe;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRpJbc3M2/X7AED55vXwUGnGdH/DtKter23k70n7+p8=;
	b=LeFHdMOXjQH/g+2i/fnUlAUQJZBD1n4MAEu7V2VtiHzZEn6hMTu625gxz3u0dmkuWUeZvS
	3YFMH89WDQJTBDmn+gYOybHnM5n+4UyWsWURtZRaun4nT1flWCMR4ByP8Sa2s767OENRA0
	9Toqyhy9UhjQU/LnM4t70YLJFtLKwN4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420882;
	b=Q3yDaIsZ/YFZjiY5zC03dtBUJxvSU26A3gbk4tmYVkrdjmq2QImgLMS6M2rRdBInpfJhqI
	WCiEtrooheIvW9TXgYB7be1K8jt09/zySBLCaSxAs3dMud2z47cSPlOxxUovJNUaVeNRfW
	ZiIXreCWXLat7P+R+6TKusZjOXF7Zro=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AV0siQNe;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B11CC654C1;
	Wed, 11 Nov 2026 18:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BE01F00A05;
	Wed, 11 Nov 2026 18:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420881;
	bh=CRpJbc3M2/X7AED55vXwUGnGdH/DtKter23k70n7+p8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AV0siQNek1dXuFg9Q0e8WoAy6x3wkQwBOG2pXZ2fNQRN/4+5u72bqZtxUBvDeKkzk
	 uTtcMBDdUvxBy2sMqFXHsnrScNJk/CNKuHLSyCy9pEm6IxSJ07zgFgqM1cOw9U8AUy
	 vJIbaTIKxhqi+ZAP/E2dyum2uSWwN5A+48vUThtQK8gm0MmDQPHbjGp++TtAiWxkWD
	 yM5xi396brXVfCZqbRTXn/MVi6fsW6vsf5kyhENFxrbLY4/08t3XnaQ4fTr64pTDMn
	 BmTTG1vDJBbuIwmIcPs3ri4QtqA4LZzGEFNg5uAwoVdLniljxihNYL195c0YlSydTv
	 GtZVqCQ6750Pw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 11 Nov 2026 18:13:17 +0000
Subject: [PATCH 03/13] mm: cachestat: restart the walk after each entry
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-mason-migrate-et-al-fixes-v1-3-3d2454362e8d@kernel.org>
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
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2572; i=ljs@kernel.org;
 h=from:subject:message-id; bh=gVfN8ZkTuZTTiGqHsWf8o2QGVhWsCljDV9nO0zvGAfs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+bMieHfT5w5PqC4dPtG+/ZV7BlRr3oewoj9qzi9y3g
 w6Lbc9g6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBELicz/K99XlFUO3Vfkpis
 lWO5JIuRS+qfRv65BknSMxn8LB8W1DMyzHB58Wrq4yOm0lEideyS5tqCq5nWzdkw9/g8G8Ej2kc
 vsQMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: r3b1mfsfsyhmq5ot6okxffwbzizp6bti
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1531440007
X-Rspam-User: 
X-HE-Tag: 1794420881-44487
X-HE-Meta: U2FsdGVkX1/Ab6Gfh2wZkbC6lKbs+2npl9GpSYpANqP0bRogikETZEAmhoUSG2mvW69IWRDaSL7Mq7SRTuWt2qXLpSoRg+HMgIoWCWkCQeMZwrCQsBY7g7JcDyQ5WM6h9ey3wz00Vk0k9oq0N6eKM7RALQjAgihLLW/Ab0elv7evanZgjjH0S0GLTY6ktDaVyrJrdl0XOFy+oLLdq8f4mNWrUU3tWMj7lQWYCybY5o5gOQlfm9nhCAjIUu0WJAXqTXSrMKC6e8oC5Wt4xTT5JxApRSUo0uE9mnL18hTnU2vSX32cnIDmZI5G+o3iUySWV+Zjzekdgw4XbOEcawGTEUzTgtByRWwn2SzozJNJrJm6YaifUSjqLvbFRBbPPKEGsFNMH4bLX9vBtUcHYncSumka8zXE7DqH5q4mrcI7Aggbb00pVIuVbfCo+bDhK/HOipA6LsBLl7R57CNxaMKPg8dO3lxKDRPHry3XcXhldXvfh6VDWNAUHne34LWZhwXoMKIBCCqIFPu977xrs2S6ESG1N/YHKZz0+50bPMjayxE4QoFJ3vNTr0Lb73CaLpMapmWayvI62i+GU2aAQ+VNeoIC0TOwnUAGsAnpLk9GlFjhCZtR4R64SJXKf7Pkj+IoAllVSDi4VxXf3l3DTefd/ZxZRhTRx4whjQAIKYL5NdjpwT3Ck9jubE6wPLeMhVnbnDxWoYBqhLjjuwIf7E2lszc5SAayml4x7I+BWvgsUceyaeotIq4J61Pd7W31O69zBh+EXHJi4RlsmKEogfLguIrVKOxAbzmeBszYEA7HQzlZdDtDS56YOlWmzam35oR5hQPhxKtLUsmypGZL13ounzm/9C5rAxv8S7XfruIMvjqoME5k1ICyZRviFz7PvZNsqVCLUj+P77qvw61WufPNFvw1k6+q/a2LHQDX4IPTWwkRMLwkwQsJUUPwwGFjy9dKyBZoutsI3AuvW7HyTTs
 euOnytl8
 Ftra/8R2nm+cq1abdyudkiBH6FE7z57Ju6ysQqj9+KbEbUcVBs4chLw125S+Rvja3ocbpDJjecRnnqJam5N7gVp3GDVQ8B4+xnAZiw6XKDhqFQTF2Mzcu+hqivEYUwjNf47HC6QFXWIvKY75jJKNN8r0WXl15lqN0wWNKg3V+flWeDfqqHMCqr5wTNHU9LWc2g/yhzzcYFWH3pBBd5ZWL2+Z1gznqK2/f6hTi5Kmzk5KN8XwYaFCo2YJEWPw7Xa3TIUof/XjrKsnT2W84jST1nJvaEPFhBxQTX7G9QoPPYBSmP2qNU3VK1mG1Ef8F4NQkZIrc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

cachestat() can leave cached pages out of its counts. This happens if
the entry that the call has just counted is replaced by a larger folio
that starts in the same XArray slot.

The issue is that filemap_cachestat() walks the page cache under the RCU
read lock, so racing concurrent collapse/split is possible.

Thus, an entry can be replaced immediately after the walk has returned
it. When that happens, the next xas_find() skips the sibling entries that
point to the slot of that entry, since ordinarily they belong to that
entry.

However a concurrent collapse_file() or __filemap_add_folio() (when
replacing a shadow entry) can store a larger folio in the slot, in which
case the sibling entries belong to the new folio and the walk still skips
them.

Consider:

    cachestat                         collapse
    =========                         ========
    count a 64-page folio in slot 8
                                      store a 512-page folio in slot 8,
                                      with sibling entries in slots 9-15
    xas_find() starts at slot 8
    and skips slots 9-15
      /* 448 pages are never counted */

Also consider:

    filemap_cachestat()                  __filemap_add_folio()
    ===================                  =====================
    counts the shadow entry in slot 0
                                         slot 0: a folio of 32 pages
                                         slots 1-31: siblings of slot 0
    xas_find() skips slots 1-31
      /* 31 pages are never counted */

Essentially the fact that large folios might be present means we cannot
safely continue the XArray walk, and must reset the iterator each time.

Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: squashed 2 commits, fixed up comment in code, and commit message ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/filemap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 7c05e4fad081..c4e82891767b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4731,10 +4731,11 @@ static void filemap_cachestat(struct address_space *mapping,
 		if (folio_last_index >= last_index)
 			break;
 
-		if (need_resched()) {
-			xas_set(&xas, curr_index);
+		/* Collapse or new folio spanning shadow entries needs reset. */
+		xas_set(&xas, curr_index);
+
+		if (need_resched())
 			cond_resched_rcu();
-		}
 	}
 	rcu_read_unlock();
 }

-- 
2.56.0


