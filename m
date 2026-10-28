Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43A53606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Od2jCajZ
Received: by kanga.kvack.org (Postfix)
	id 413286B05BD; Wed, 28 Oct 2026 12:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4BB6B05BE; Wed, 28 Oct 2026 12:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B33F6B05BF; Wed, 28 Oct 2026 12:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF05E6B05BD
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:20:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82261A6EB2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:20:08 +0000 (UTC)
X-FDA: 85372546896.01.F44F5B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 74F51A000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:20:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Od2jCajZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793204406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0rATnQQTJ72YrBkABg0cEBhwiSsSBn8AUhfECRfpTKo=;
	b=QK8frgUO+6cuquJyDzHdKsk1V4bnoAEL/WIFprTOrGoAfqCspgsk4NM7hjp6EbPEmi7G/w
	sgioDEJwwjA/D0wozik28sbl75DmNy69qJoRciuu6iBpaALRQ3UULpkFlhA8JnFOzcNWkV
	GV9pHVdEcgq3VdrcLOw1Exnlpe1QwR0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Od2jCajZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793204406;
	b=DJeupdpmslj7ZswiMF01K54UAmZ/9JvnnILMtfZXVoRcY73hXB0K7eG8+Hu5QISvzwT9OM
	O/O5K4oUd0/hYkteWHjWKBQOAzJO9VLA85Za08mY1Rzw/AieJ++3SLnSFIbkM3QZSeTeoi
	d9I60u1YcKG1IrgRFbJfFg4BdzymFiY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9297643681;
	Wed, 28 Oct 2026 16:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24D31F01825;
	Wed, 28 Oct 2026 16:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793204405;
	bh=0rATnQQTJ72YrBkABg0cEBhwiSsSBn8AUhfECRfpTKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Od2jCajZKWKTDmGKxuYQxCznLzK5lE5I82XP6kHR/pVw15VviXOu0f+rBJztE2sWt
	 aHB1YXF7LuPYHU40KtFSmxWKD6wxnYzbFJeWxCtv5kmvj0IwusDwG6I8dKNYl5hbAX
	 qHQic4MJqltiIVHxUe3brboc9KewZxE/aWUva6VSi7IMJ81oP7hTDulOU8yLFxWP4u
	 W3jZr5qZ7IvLut3ypzOXBw5SA0Vx7r0s7K9pRjlpSjQpPHMhmwn5yGGklOO6EJ9nTi
	 wgAJwgkpfhsVSNks3KTWED/hZ081N4N8oDSY/jJ5jMBOtMs1oL4u97xlwL0bgFticW
	 VC7cHA1IM/c3g==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 29073198005A;
	Wed, 28 Oct 2026 12:19:49 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 28 Oct 2026 12:19:59 -0400
X-ME-Sender: <xms:pCDiapHR5_UfAlK6Y5IwuSd6tG-IN25ti_9qop6y33Mn7A8IfOyH2w>
    <xme:pCDiaolisVVX49paz5DMLbhyfp3Q6L1SCMdynmBx-MO6JItRfQaLAqjheIBSQuP6W
    utF727eX3BINM1KjFyEGeeFcQzdUVht_0jxrDU5lvFsc9Uo93IjJqpd>
X-ME-Received: <xmr:pCDiatI176GX8GobYrpPR5_2HleYubAakxHYnaCbeKCR92Rik7DrWnkMNEI>
X-ME-Proxy-Cause: dmFkZTGclD1JbppB9HJ+wc+PBYUc7y+dixlkOiA2HsCm5bBLjgZcXtU5z4GDtO5noWzmDd
    ORQFP5u9B2gtbQIzAfn62HyoZPZzOaRlPLXMJbRuOKsJfFDAVc93Ms6EaNrHWEq6z6wsvt
    Vwv7YGYHYp1DmH0JFFFqpqagIBWKJjdY8K+9fHquSKFVK4QpWZo3/X+8b1lo1wJj7cOP/0
    UxPerUKzYQfYIPe0+zZpOe+dudiR/ZmyEvfhO+buEi+HLpafl9BeNw9D79/rT5MOLUUGeC
    H20VI38/59YkMmPnP0Lyu8v9OMGay2+0LMnea7uAS3uuq0rtJ908MMUpIuTf0GbHo8UsAY
    ua+t7Qev6BT8kMHCeyM4V1m6u5YQwDA4moRebSE73U9F3vqd/sLjELfF2vONZb+ZcW5TQB
    94GQy7Qy9EYuo6vu61hPJ1VjyjuMJ99xhWVMI+3gZz6H3VQ84mHv5w8TE9tnJChUhoUUP9
    4BpLr6gQs04DR36/rOYGy/+LZjcGIu/GNpIN099cOSZ+EN2zqtR43z7EhAL94X1B/ytyyp
    oo/rRFI886c55KcN4on3qj6HWPCrIJtfc0D4lmBumEi5I8lrnU3HxQLS8Z22AYR9GbRHTz
    75P/PVpblWhTAf4127jPQ1kO6sZzgqCljd55hkW2aMHmD3LDpX4z8/2t8a7Q
X-ME-Proxy: <xmx:pCDiahze4ae2vr6g0xh1CGHOySl6hdDch_bPcHI01gx7Cx5B5_AyJw>
    <xmx:pCDiapp2l8L-56W56KcYVToqHeGQ2dwKvVCsSdlmv3g205bP2Roufw>
    <xmx:pCDiaj3XJkMTDlTUcybqoOOCtsjCPlXp0xH4AP7sKqkLmlew_k_rVA>
    <xmx:pCDiaoL8lIOsfn_CSb0VzXBCgfJe6RSz91C-07dxto8nIE3ph-anSQ>
    <xmx:pCDiaopVBBj5qbjabGhIOaxTeF90y_zQKddqmsT3AwUNkwcLcz8ejdNW>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Oct 2026 12:19:46 -0400 (EDT)
Date: Wed, 28 Oct 2026 16:19:45 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 02/46] fork: take mmap_lock before copying mm_struct
Message-ID: <auIgkX9zz8TdnLum@thinkstation>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 74F51A000C
X-Stat-Signature: yhcw57eewijhdajoucfmqy3t6dt6j3ws
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793204406-75545
X-HE-Meta: U2FsdGVkX194JSGbDy+Z0a6sMmqL+65sD+u9vHATiCvTqPb0MNVSJgqBGK7LDGP2sN7kITtVUofUzZpi4PDpajHknL7ldUBgj9XTm5NgWRwUH0ZqbHUU/2Qj8ES8kQOfgm+GIzUEE+tWgzJ/JK20Rl71iVKr43gw2nZW3d/GK6L8w3alf6l4HM4xHLN72XnQKSSxr9o+pKBU4WwIrlEK4B/fM0HSuM1Dqubp9Fcy84Ajn3iKN8ypxlzpMlhV4BlgwtJEA3FBvceJb8Vnd2ewOChuS8o0E6cz54VS1Grkag0BYbcVLzssF285WTOLZRZNRIz6cAyDuPZS7smxXfsajvGYWc+glyeZ4dkSwotijW2NIWMs+pM5PpDEir7GEI1GoIEVWQQBy04vlgjjRV+Y1oVQNkSkeGY/2fnUM/d9ijA+5G8XPGQjtO9ZMGEWVbqDsYLry0JXZi9NRWbHI0/9mEmebjnZyjjGApheM5hBnvt6nbAbOGFDSdHOD4RrwPWu9BZYKl/7jjQc9f04sIfJo22nz5XVnmgdOnD9zPKn7Ngry6KDC+PJLQfhTh3F/bkYozQ1TzZJ03ZDn/hSU1M7ZjuB2beILSE1FXwQGc/b0HxkjL30FzR5eMjp6XNHBYw3fYChXQ6uGnkBF8/tQztIo9h/yLTBI06LA3tHZyorsqIAVtvJNhcdvwpBpeOohr9C42HsE0Qozt3b1Hs9graYmxXL9pCQeP2fLQ4NDGY0LXHFDKI/sTlXg/50PpdNf1krOl7bJFDYWdVki6AKDcfGP7AIqm9XHtl763ayqsO+eyOPSLjOa/2Ix/VAs7Bjn8nGMaf6p/qiMWFxd+veAUmsxhP8/1jvpU/C1cMgDZ0PCrTsxi9wONpGQS+Lc35x6kKpSjXF+xRNhSFVq8FYXhlzQGU6VTGmyW0m6iABm6MtfaqTbtC9T8NRMwMNX6YWst5EbA6QLe3HWxalLuj/q4y
 d31kfBQQ
 X4OXgmta9bRg27f4jOOFX9AtUQIRn5cPevDT+9ZafJgjolJm00pYYgvOBY5q7kr3gercnbF4x9aIz7pdG6SJYtfpZnDtx46brrXAeEw7BdIxxRkP7WqptzG9Bqfa9SjcuDipfZjLYh6c0NfQBMboWTwXnHRTf7cGDld27KGtmrpKfWZyyMWjnbVpdysdLw9s1wMt8SPxxAWShdx85aix6xho6UHKlVEimAd04jw28d8H0n7V0aD6XrKbuAKs9/NJ4OwdqMA0id67xSL08TlcoJx7yhrDRd3C/zZIp9Fj/Pq+Hpo9zi/DmwUyTVWP695GKAzsizvfyyQ0NyIn96McYOKEjZGV2glzCrC9Zhe0Pt/v/DDktPa4Od6cM8Vx6yWIeBOxwUBNMDDo69VxS71XizA1FWXpIf6ukdXFzssIZxTK5DsMqFbe9XDvxNkPs6w8oJXvOpx/EH1q3oINBi8pMb7IVYwCMF4n5rDeBQ21k8f6eBiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:22AM +0100, David Hildenbrand (Arm) wrote:
> dup_mm() copies the parent's mm_struct before dup_mmap() takes the
> mmap_lock. A concurrent brk() can leave the child with a stale mm->brk
> and newer heap mappings, causing later brk() requests to fail.
> 
> Other operations (e.g., PR_SET_MM) on the parent's mm_struct can similarly
> cause inconsistencies.
> 
> As a simple and robust fix, grab the parent's mmap_lock earlier. This
> way we don't need to update individual mm fields in dup_mmap() and
> keep missing ones. Stop updating the 4 existing members (total_vm, data_vm,
> exec_vm, stack_vm), as that is now no longer required.
> 
> Keep releasing the parent's mmap_lock in dup_mmap(), before
> userfaultfd completion, to avoid moving the userfaultfd handling into the
> caller. This should get cleaned up later.
> 
> Move uprobe_start_dup_mmap() to preserve the lock ordering.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

