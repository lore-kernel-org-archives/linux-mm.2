Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4851606A32D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Zb1GeGbo
Received: by kanga.kvack.org (Postfix)
	id 12FBB6B05B8; Mon,  2 Nov 2026 06:44:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1226B05B9; Mon,  2 Nov 2026 06:44:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F115C6B05BB; Mon,  2 Nov 2026 06:44:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0E456B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:44:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70A8E80C29
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:44:55 +0000 (UTC)
X-FDA: 85389997350.30.88A95A1
Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id B9E1E40004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:44:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zb1GeGbo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.47 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793619893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=who8ZKKpx/jTygdDf46XygrUGTNQ5Ti9QGrea7MK2kQ=;
	b=voIO0edwZihhaNEYT/cjMfLhE1fHIJgvJ0cBzI1kUTIs5ueyqpVgc94THBPtbD9qr9AvvW
	P7Rp+LiDsxXq+JAsN7gYZaANERmnHM/YP7bo+ghKhHAXMvWxdRXGx/RXKNC5LtefYrtM3b
	Rr5V7rcJBIQX+bRM+RRDqm/t6mQg1nU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zb1GeGbo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.47 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793619893;
	b=XZt6asPeKw/rxr/RBHiTlhTUvvjWK48aNUBpPjwx9ecgyd6+fcCmZtnFtvpDRt4h4CzQcX
	QST4tyK0tJtKRzeR6hPvsA7pMzBOULlFj/VB1T8mjjWi8yjIYDO5SXNoaKs+LDQxxn9e53
	o9BsWGnc2s3mTbRd6ul3bwHG1m4Y3IE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fgRhZQDSEmJFZyIgGkSRYKnhjZ4Z1l5m8LV8w/ZXnHw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793619890; v=1; x=1794224690;
 b=Zb1GeGbojxXveT3cZxDPn//4R8A7h+RMO72HLl435m67FVvM9SHf44yaVVp55n3SAPWWoirq
 Hz8XE56QJlzs5IpeJmF7MvIRESwEWtyXzDq/oA5mLYy34SDIJOr+HdZ4EG3OGTtz9aHGD3cJfWY
 yqj/TBZodxsUUHX+M5Y8plAE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6ed161f8dd0a3c59;
	Mon, 02 Nov 2026 11:44:49 +0000
X-Mizu-Trace-ID: 6ed161f8dd0a3c59
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	peterz@infradead.org,
	jannh@google.com,
	pfalcato@suse.de,
	hughd@google.com,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	riel@surriel.com,
	harry@kernel.org,
	apopple@nvidia.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	osalvador@suse.de,
	minchan@kernel.org,
	muchun.song@linux.dev,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	jgg@ziepe.ca,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	stable@vger.kernel.org,
	usama.anjum@arm.com
Subject: Re: [PATCH v3 30/47] mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs
Date: Mon,  2 Nov 2026 19:44:42 +0800
Message-ID: <20261102114442.65682-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261031-fixes_core-v3-30-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-30-d6437171ecc3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B9E1E40004
X-Stat-Signature: aycsrrp6h73o7f1rx68gk91qyocsw1fp
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793619891-372287
X-HE-Meta: U2FsdGVkX19C2dbjsUGuBdq6H+cZ2BDHbwpcwyNtaoZWWR7bjqCDXvEn4pyDWGeDgZUUefojOOAAJ9nutHq+UZbmGJSaSrtYYNQF78MUP3hjc5Mt8PV/kOcbhLxMdJOHvaDZrPAqpjyFBzpWASHVeYkmY67rHqSqCzz9xnVqeOc/IED7iXBbxtXjahq6nZ6JgO1h7fHTiU2DBzQrUgr/8QOaIHjrTm/vp79mkKYayvbQxfCEdUb4i1f5SoXlMG9di6yywkCrUi92JkSeBP5xO4IkXxCfZHmA+iQQ93WmKLsOeCDyhkg/JuYgI/vUXUmIZA2uXcSpGBc4lD8u1+u3EUg7UTp7Oqpc9vZ/hYeYP6hG8wAUbaAfuM16u78rQIYZcQpt9NSSQIcGel9zHGJglHqTvoCyhRwGl0X17Xg5174AdMBsZrowSVP7K+uTnQbiqoa5Y+fg7QrVan8BiXqY+fRN/XVneG0MBo24eaAt9R0Cs2enc0nAHByrSUZ6fEXPigiNowvFErk7i0dqNm4JufOcwu82Kv/sG0HoYbkFTbFYNB4NmjdbwqWGXu6lWECHvLeLy2YwkvF6fyGWoKYSAqbLohm4gkuKtfcSAQeYRPN1ZZWmQvS1wSwITm+b0BdGDxemOogknbqS7FYe36VTKwSQq4YodPfh2uRL+QOXljXzni5xUk8FCYz033w6lqH6qFQR/ZXUesGFS9gsbVYKmZ1dRz+YgWZW+RzrmTBtp67eMnVI/R7fwKOmMlgAvVhwAEbysj3sRiaYu3ET8AiLJdETZwu7AZvZuLVpgiYZUldg+fJoWqr8/nd7QTUCPUnh9x47e5QmEyZ1JMgWBrStX2yzJdbdAaVPiqzdWYXr2AwDHoF52gHFK9PQL/T5GiO+ULdrHHidLTva4aQS0unyEJlO0HwWMN2+bv9PPANAtBysCXqNzMCtQLssia4NyvOviyfXNWzGDPGMKuzSt8S
 SC5ewRt4
 uZtWuxzRSgSUInXVGItwvJ1ifb7LJ5dwp0EfndpoRY6uxCKafu6K3JgjB4f3xY7D5uJdTGgO2c28e/kTA3Tg1z0eTyuX34+ZWKNbhQUZI5dkeCkKm0mf5tiCGQ7PhWHKFfGfuDL+a1R8GmkBOIhNbJcixCtN4lfkVc3cMLhqUPEtKVH/DUaDAmbHbrj+QMsgXT4ISk9SRUxf1Vq90wemC2dnMgZ8+7BhWbEDnQGLlD+PbqID4DGFjcQ0yu7tGdk2vWjBv5TRpVyFzH6ZDYIBfdzY6YgfjAU4ZeW1YbdxRja3bQPSdgKYUXLpAa6cxOWiMbE4lmvrsRf2etFdRbiHEgLtC+nM9MDWljDKmtpyyt3cGbrWPIc+WuHqXTUjrV942RKXKgqe75V9d4zCDYUR5kuq7BeiKxmHPSb/N5JouTLYJUPAVryi8Tnc6mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 10:39:59AM +0100, David Hildenbrand (Arm) wrote:
>move_huge_pud() reads the old PUD and clears it in separate operations.
>Hardware accessed or dirty updates between those operations can be lost
>when the saved entry is installed at the new address.

Yep. HW can still update the A/D bits while the PUD lock is held :)

>The raw pud_clear() also bypasses page_table_check_pud_clear(), while
>set_pud_at() accounts for the destination mapping. This leaves the
>checker counts unbalanced for mappings tracked by page table checking.
>
>To fix it, simply use pudp_huge_get_and_clear().
>
>Fixes: 7d846db7d0e2 ("mm/mremap: convert huge PUD move to separate helper")
>Cc: stable@vger.kernel.org
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>Reviewed-by: Dev Jain <dev.jain@arm.com>
>Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/mremap.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/mm/mremap.c b/mm/mremap.c
>index 0d06d7f37f19a..16e736c72d9cb 100644
>--- a/mm/mremap.c
>+++ b/mm/mremap.c
>@@ -509,8 +509,7 @@ static bool move_huge_pud(struct pagetable_move_control *pmc,
> 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
> 
> 	/* Clear the pud */
>-	pud = *old_pud;
>-	pud_clear(old_pud);
>+	pud = pudp_huge_get_and_clear(mm, pmc->old_addr, old_pud);

Reviewed-by: Lance Yang <lance.yang@linux.dev>

> 
> 	VM_BUG_ON(!pud_none(*new_pud));
> 
>
>-- 
>2.43.0
>
>

