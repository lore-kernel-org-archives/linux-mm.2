Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E425D606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aupcWAQV
Received: by kanga.kvack.org (Postfix)
	id 164566B05E7; Thu, 29 Oct 2026 16:42:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13D366B05E8; Thu, 29 Oct 2026 16:42:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054136B05E9; Thu, 29 Oct 2026 16:42:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA03F6B05E7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:42:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3170FA0517
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:42:08 +0000 (UTC)
X-FDA: 85376835936.14.71E565A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 57950180002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:42:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aupcWAQV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmFFeOpTju++ba/4+xeyEk8Axf+jyt6U1SaWbXoiuJ4=;
	b=M80J/6hHZF76uu8blq4Y4dZU0aA1Oz8xzb5CE4CztGTrfuG96q5LDGV/uZuGZokcxgL7lp
	ju5AYrfMF8s+mUeb831QQWGNa+sKmNa1ILAAc/LYq5eh0nzl+7kI1wdBVeeyjCEy+e0Xb/
	jhr0gEQSNhheAvo6hsiO3o5S65zCBMs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aupcWAQV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306526;
	b=GuS4fEfbW04XFCOOm+DKryyQ59vMnDwwwMGB4jmqt9V8x6QBTMH6EYYd5iVdeTAYQ8HeD7
	uFZRZ+qQnZyETuofbMKlO0819GLEYKeNBtq/YWO/AB0Wzqr24q4UtvfiDXfdg8dln4zJs1
	46m8Yd5lxWVumuoom/GZk6nq3HCYnYA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA4E04119E;
	Thu, 29 Oct 2026 20:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823091F01816;
	Thu, 29 Oct 2026 20:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306525;
	bh=EmFFeOpTju++ba/4+xeyEk8Axf+jyt6U1SaWbXoiuJ4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aupcWAQVBJTU5Efp9WaPPRXHokXcM9AJqzyLpqG83aXFjxFt7JZ/KxBuLj5XfBFcl
	 8A1HXSJpx0v2mV8OmFjFfgEiQrctA7BiCWa2AjsSS8WoRaQRyd0aCK6rU84MfjOd2h
	 LKtHqaFV52W+DJFd2Zu10Gt0mzqUxMT2JZ2/clGN6CTEFYixvBfaHqCMg3UMkkr9mW
	 immrEuLeds/yA/5o0Dxsl1l87L5TafFkI2LWsR/jcIjDLTDVfs/jSTM9WABHdLUIfG
	 znmWD6Nyo5Mf5P7bc2R5bVFgPnZPyLmvRlzxgwlFeWU+xfv1JehQcmxcXuSeVhYFQM
	 TWNhKtkgz6Mgw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:30 +0100
Subject: [PATCH v2 35/47] mm/memory: reject remote COW faults on PFN
 mappings
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-35-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2247; i=david@kernel.org;
 h=from:subject:message-id; bh=NZgsSdEHxnbgHjPXcrsPLj969BYYYgAtMd+ESFDEtdw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+0oO21x57rIvu0fshoW9U9UFeH7v3SBKt+E3TK5e
 07veWrG0FHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEAjMYGfbvP1TLKbb2+ymZ
 M607Djdul16prRrWU53vWcS73WVt2yqGvyK2ZcrruRZEXiv69mWViZnE/EkPxE7f+vuSLeDilpC
 UR+wA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 57950180002
X-Stat-Signature: 18pttk1m9xd6h8b6b8o8mjx3dgc61kdn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306526-232801
X-HE-Meta: U2FsdGVkX1+QuDOk70XI/yLJuq6CWMFBIJakePBbU7DLVn/sYLM4sQlhrcvJAu0eE2vaOpRJ75lgWirgBERbiCzQ1oev0EM/LuH01B7i0ffU0/vqx9jIDQRLe7RFzCRqeyqoKu6uiNaQZ98S3rV+uhZQ1BzgKlq2vP7+WJ9QlHTdI5aH28Qz8WZg8ABskL90Fw6rpX6b3c+utQ02l56F92yIuRmXyrJpdXxYPdZCHWgOallcIjCRZQr011u1P8MDVHepLFy/x3rs30oBLYp9v7wEIkof3Qsn4R1iGDiv2Jy1Y+gb5dbfHOmfxCiJUlfqOmMrERwlqptR7azS0n41Z1mut9bDvbOof2PihULsia335cDy9YQlPp3HxWJfMs8pRsdzwLp3UKxqs7IU62xDn8JwJH66BBBHRQLO6wf4pb4bzLZzYs542D0jQGmMM2PEKDK8A9g7ujLAvL6K73m+/XwWbSbwkkyWjX9FWTTGORBRlxO/7A7it/Ea0PGyRnDm+NlIna6V8DVqPXBKGY49ew4m+f2WxJWl/KRTRcq/zKe0gfxf6zaVGYI/PjcFWiGtvNMVzGioryUd6/3vJRs9wSsyc1QmTiQ3aGGsAzP8v/QnIiowfLZPBorIjVotkf9V+qbOAks/I2ByONcASEHRwvDvRQLtFJ0hpAjT2mAQ1/MKiK3l5/XD1gHLLC6j2pIu5rZ3EyHvSMr8P/hEiTfV6z7sY01lsR9j+5n/Eiwt2LNqvB0+qmtn0DgAR6L3oS6mdUHixSHkn35Py0zouoYzO66lEtYev+m3875VLV3gZdLhJyR0eVMZbNcL7sYrKgNN3RS5i0gPfKn2K+9aAMUTm2m+HtVSeomjWulVI79/AjsC9VuQhROXMg+MpFeE1u2X7tm47IE/A4dflzfrEuRA5bcIKPAhVEJIpjGs+DnbSC2jWsUcUKVuWXxwKruhyLl6sk1Gsomo80NV8w40/nw
 3W5IfVtz
 iUIgSRzUbFLmQXbFNp/9gMZS9plDBWRrKwKUaHC/IEIbOmPpqiGIkObAvE1stRbC9JsPrnCL92Od6oXhaHstugd2krnwkFVGCCuFpyBIf0vrZo0LA8RFirXUVFW3c684vLBaAkUfLw8TYi0a4pW86blCi+mKO3EjZ+YbNARZh+PJzOde7H8NIbvVDMS5nZeHdrVLjsNMBRquV7JnUA+p98nJQ/JJtExYW3AAaCpU2uK7nxTgeiMJ22dMUUH3ITXo312049Fw+497R+gnSx6hxIew/iTejs1khq4YdQIDnusR/2HOpvHb7tVBb5/QMXdlG9JrAXUdGfji+zyYzCY+721acfjIiCcFd9H9j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

When handling a COW fault without a normal source page (PFN mappings),
__wp_page_copy_user() copies from the faulting user address. For remote
faults, this accesses the wrong address space, resulting in wrong data
getting copied.

For example, user_events updates an enable bit in the registering
process's memory. If that memory needs to be faulted in,
user_event_enabler_fault_fixup() calls fixup_user_fault() from a work
item. Placing the enable bit in a private PFN mapping can trigger this
remote COW path.

Reject these faults with VM_FAULT_SIGBUS when the target mm differs from
current->mm: remote faults. Ordinary (non-PFN) mappings are not affected.

The user-address copy dates back to commit 6aab341e0a28 ("mm: re-architect
the VM_UNPAGED logic"); likely, actual ways to get remote faults in
there on COW PFN mappings appeared afterwards. But the fix is simple and
straight forward.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 6aab341e0a28 ("mm: re-architect the VM_UNPAGED logic")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: simplify comment and description ]
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 5392bcb1d24d..ae8d567bc6ba 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3761,6 +3761,13 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
 		return 0;
 	}
 
+	/*
+	 * __copy_from_user_inatomic() only works as expected for local faults.
+	 * Reject remote faults.
+	 */
+	if (unlikely(mm != current->mm))
+		return -EFAULT;
+
 	/*
 	 * If the source page was a PFN mapping, we don't have
 	 * a "struct page" for it. We do a best-effort copy by
@@ -4086,6 +4093,8 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 				folio_put(old_folio);
 
 			delayacct_wpcopy_end();
+			if (err == -EFAULT)
+				return VM_FAULT_SIGBUS;
 			return err == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
 		}
 		kmsan_copy_page_meta(&new_folio->page, vmf->page);

-- 
2.43.0


