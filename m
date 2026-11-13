Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92074606A88E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h+diSbf1
Received: by kanga.kvack.org (Postfix)
	id B95D66B05BB; Fri, 13 Nov 2026 16:46:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6EEA6B05BD; Fri, 13 Nov 2026 16:46:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A847F6B05BF; Fri, 13 Nov 2026 16:46:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 885866B05BB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:46:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27BB780156
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:46:12 +0000 (UTC)
X-FDA: 85431429384.22.D847D57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 57F214000E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:46:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+diSbf1;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSGDbQCcTAUSRH7G/fxYE5gB5OxnE3KFAroSX9Yeoig=;
	b=DjzIEwLJBWF18C34cOa+4CKHE3/8o8ZO0COMMv02BfTiYiLvqCiA1hSRTS0GftJOwkTqip
	r5llPXl0wtL+HOwhjx65WtIKWkSorLGz9pviYIoSL9XYffHihl23TwszGXbXHumFT6k4Gg
	Xc9t2U1RTzOwClovkW+2D3AX4I4jyIw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606370;
	b=p5HBeYWg3/Y+YbbEC/n3mP/mK6gnKm6rW3uMHyNnRyPEdM3IrfFWgKee+SOOoUtFnUOoYS
	p6sObDkXkeMUCRyYX6DMl05czvwsLlJ0yYAViMBVtcIip5LpysWwjGz6UljxZQW08qdUzL
	XY/ZZRCS2CHyyszxmJb7p4xGHqASzSI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+diSbf1;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C33C434E7;
	Fri, 13 Nov 2026 21:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783581F000C9;
	Fri, 13 Nov 2026 21:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606369;
	bh=kSGDbQCcTAUSRH7G/fxYE5gB5OxnE3KFAroSX9Yeoig=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h+diSbf1SuhC6aFNsHOme977E1ZvwU97QzoXopEuhlIB8TKotYFMevmSp6UYzTjjn
	 FZeBCqM15Mnt2X2QQ2AB3koBYK+6mDB43xHWQszL+inYtuGHaR83oC9sbpFLS+f0C6
	 xkz3NWMU9n1zMVtX+l60Y74eUjxb0O0csn+shbuBTEqWXGhJYBK51xoqFzkuawsOMV
	 Q8zEswz9yY4YJBacnDHaha//uClVvE6rjjq9K940lycXG2YGhlU71NttRaWeUyYI7P
	 PADgp+xzd+leSC8aoGyMzk5lcig2i+1MEFKCo4ieNxRDJ7tUTtIjpSrNrbD0OnM24Z
	 ofN2wsrpH4Smw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:45:21 +0000
Subject: [PATCH v2 03/13] mm: cachestat: restart the walk after each entry
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-3-50a2ed382b61@kernel.org>
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
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2976; i=ljs@kernel.org;
 h=from:subject:message-id; bh=lUSIkZIR6P4SuNmqWQyzCX54g+mtKdeum9Py8TZcLQQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t/zguiHA9DlRiPeX+wLWT9Yyk4tcdNnWH917zS3wp
 dwetthHHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIPwVGhl+hxfcuPbsXZ6HV
 5B++6g3X3W0Wr3cdmDv3x8wyxqLNIvMZ/ikxn1r4KWXT6Qzru093Tf6oxM6YmXCuqu7/F8dlilX
 1HMwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: gpashm3der185eso9h5o3n9qroy47eyb
X-Rspamd-Queue-Id: 57F214000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794606370-123806
X-HE-Meta: U2FsdGVkX1/8/wujBlftBQDRLZ95VwXBqzckeIxksqunfmGflq28fLSzz2H0B+OheadIV1I9DzxFhomxi4jS6aeglMNH0hl7KBDBiflqz37x3Vr26xMtAicdopZl9DZdRGrL4wAVcQ+sx2SMeY6UxHAZ4vB5zuFC4ZKhpuzYkKC0YybEWO2GY7j/3pIiIav3hwNnqeMImHuHrABSaC8HonAHztTwoEl/1gja5y7YvUWHUKlFsH75KO+kIGjbPE0kl2LEpsJmI/t/FHarPpbYPMnG0wM+3k/ohgy/bV/aNgVUl9NlUeLL154eP7LzC8v2ZIpmboJLxiMVNnNLOY0ozqZB7m02WauO5exMJ3IFiA8AGb2/qV4V22UiGrBXExCDjG2fV2J3nxnlJrivnZ7oN7PKacns6YxLRE7hbX871j7pOj/Y9jkFHqUfqIvR/FDHcmGJYAUsaiumGZjxfTjtxsCQ0JfjcDQssgkw4m7ywKHlrZ84bOltWesiUlFul7Y/Y1XJ/yGKwcqMqrARsOzpHRbweEdD4SfpSr2KvCDsOH0LMbPMXDwhhIENc5WLNPxSSSditv5D8watUyMi6ThBrzmzbi+IK9PXpO89CDNnHOxk9kEaStNaXKYyqcfEvKI7uYzA4USFYzWde4xcNcwrpaUPXIHtWdOicMsh5UZlOMc4DQ4fSTBp1F2ihCEODEuJKyWiNAI78Bh8RFsKkzSGv6N7HzLjHSwcvzzpUn0etsCyTQDIlw4AI8eqO9BnEsZ+Va1S5tXZ02+cCNIr3KwXAORIPoP5jBZRUXfP6alnS8XdJOU6Mg53XUsyn4WFcQlymFpH8ATXzYDBFe4U5IJxe76/DmGribG8zjDjHF+IHxpLKpM90ZFCL7dYSWqfiQQqtgnIDcSjCfVxIBtERXa42EAnNZieaiRtpYpAYghiRHc9kIWUffFcm55jQlxGWPEwa4vG0hTppEZXAMuIJ5c
 EQlQzovM
 9vAkiMUiZAg3232Q215T/BvtDwDqs0YfFAdLhKvPM7gO7HAbe42eUsUfV/2JJDQm2HNj9ZA6D89YYBNqJnQzTlwfEik4vK/73NXSJhF3W5pB2m/7ucUuKILRW9aOMpGHk0XB5NugE7Gk0cUv41xdYtveJ5PJGzXVXb2DXemEPUBve4wtN3JhuY8pxcVPPtjKa+V64ke9Ru0JKm+nKcYaz6vDmoUeKjWBs5HiTLXenqBXzO5GYm6z309q3/Qz2f2Bg+tkYauGRHpU+LAZzEbMGscmABOcQxU4Ry+NfmhyF1Dj46hlxqt6mtkqfV4UQyRvr0YZauLQC1awE2FgTYJA6h8qT10vMqg2P86A7mNAlDIZQJR856RHldcmWAmrzjreHr7VGW6Ip2kSPKaqJcgCXpJq9u8Xh9FTmJYMUM3wruSzPRUVLks3Ff3m7QQ==
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

Fix this by resetting the walk in each loop. This incurs a performance
penalty, but given that only the RCU lock is held here, it can't be
avoided.

Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: squashed 2 commits, fixed up comment in code, and commit message ]
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Usama Arif <usama.arif@linux.dev>
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


