Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94A9BC982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAD266B00A1; Sun, 20 Sep 2026 08:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DB66B00A2; Sun, 20 Sep 2026 08:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94C426B00A4; Sun, 20 Sep 2026 08:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70C066B00A1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:25:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EACB7160449
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:25:38 +0000 (UTC)
X-FDA: 85234061556.24.D96537D
Received: from mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	by imf29.hostedemail.com (Postfix) with ESMTP id D419C120006
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:25:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TceMJkOy;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789907137;
	b=FQ6R4F8eGfaFEHXi5GWAX5hyUhKqQysF9p2xH5cyvmAaOi6qMfz9QjebW1N5CiiBb9wXUW
	XqlJ4AL+sTU5RNYLqxMIXGmVetn0Bx4R2pCyB+0HsGDigqf6YJPl185ZrMx+9RX9ZGCZdc
	g5yQ0nfRN5V0i82mM7DORSdWx6ofnQ4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TceMJkOy;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789907137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TNvkjiUoqy3g4TIzPj/wRPZI5ntvCp5F3PhGB5tG9jI=;
	b=8Wh1uui1r6spLJvBr8umVDW3GU09aaIRJlkzskaC3swI5Fusw4KePd4kPWc9PBtdvWRBCd
	64j+ys/MdqvHMlLGhJGrJJanxxsvQgEh488+t72Vf3F/EVuwP/+7WXwEB6Ow82/QV9UH9T
	ZVaQiujoPp3CDvl8IrvG1OhHuWmRBFs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=W42kzDiSpz8PxcqIdsrRncQnFltKx9M42mKJrJhvMWg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789907135; v=1; x=1790511935;
 b=TceMJkOyZvjrSs6BJ6e3dUW+JsHj+O6lHyf3xh226lssIfEecUlG6lfGQ18AAJS9WRRed0gf
 f7WUmPQwkt4lSqsFzE7lJmHWnQiJ59gnfPqHzMaNe8Tu2yxhPfNCcedonuL2zmcMzPAWtsG0Int
 zMhG/pDRDG4m17uHHu49585k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bea8566f21ed8081;
	Sun, 20 Sep 2026 12:25:33 +0000
X-Mizu-Trace-ID: bea8566f21ed8081
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	surenb@google.com,
	liam@infradead.org,
	vbabka@kernel.org,
	shakeel.butt@linux.dev,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	rppt@kernel.org,
	mhocko@suse.com,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	pfalcato@suse.de,
	riel@surriel.com,
	harry@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	peterx@redhat.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	trintaeoitogc@gmail.com
Subject: Re: [PATCH v3 2/3] mm: implement and use vma_has_anon_rmap(), silence KCSAN
Date: Sun, 20 Sep 2026 20:25:28 +0800
Message-ID: <20260920122528.8344-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260917-vma-is-faulted-v3-2-5c22314a72e7@kernel.org>
References: <20260917-vma-is-faulted-v3-2-5c22314a72e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D419C120006
X-Rspam-User: 
X-Stat-Signature: wwhin8sg37f8kxbgpjd9aybmk3yofhtn
X-HE-Tag: 1789907136-264146
X-HE-Meta: U2FsdGVkX1/QMKTmhknc4Zb9nZYlOkNaXBzDe4h/IGFmfrL2RFgBh1BM8lhZuU6H95zLPtQNV0Q97UbMThT5nSV6sEY6K867blMePlNQz1yJpPz6dFcu7QoHHufGvL+Zo7sNFGEhc1o0DSG4a/pdQkCPhT9CyKNLkZmdESg/OiGf7mu4e2YaFVIdxgq+tfFUY1JnG9QDChqByM/iFoiALMOihRfGgxSqGGTiw6YHTt3kVHea0aNUHr9wK2Rordb+SQEFlvgSvBZ58aKTaIhZvDPfXKMv3K5X75P6LXvtWPbtZGPpjng5Hjp+Gx+s/2uk6/6/LfSFDQvtr5zu8Us7TOUmqiOyChgScY2gr9VAjidKASEA8CnCSRrsy3RNOPI/1uxIJR2djYC/I0Ag6r0Zx03VvOOwqg6x7sSkQVvQCzlO0xfI0AuiYWO0Fg2xzTzm8YFbUgihnynPYP80chIqiNLa4gMztvEMqXbHuFzG5ilqj3G6CdtevrEPLN8ZnxJUjj/sCwJ1/+GNaakmskq0vHbjuO9GbvmAcbCbid+jyCVpIGILaRFwwgsIP4m6C5Q3oaUsZztZZM9WjkwKo3lDqdn0TrpyN4TgiqG/Hxetsga4isoeTyMK1Ek39Cjziw977zlWqI/IeHOzLMfW8z3eGyiuNmMxrWnE4Oz3Ingo1TyHcvZ0Q4lh9MvZiIn89+P9S23HKTwF4B7peP342W3oSvsU9xSowoUZm5c8NGYTB+YiN394yn16mtt/LI94Po3a8j5XWTjLUob85Pu85TcgF2udLq2v6cigle4D8JhPKDFGfCfjLe3kumwo9H92Laa9WuFhr9pb6eRyJrsi9PtJOivp/HQgs5hyhj9zSVG7YC9ad6FhLzgEQUbPT/+LrfQeNl3yVyMTylm/fRoGztKaGbrvP+xvKAL6yjaFHR27svFHF31RbdmOR9PltnRBtCeNse1pSxKOtFaWU7SUaBa
 0eLhMr/K
 MAcPUIfojfbWBvgvYQvu7JC2tYQDGOT14emsc55SiBSkB6AjY8sdCdF6Hdv89aKyonZP345XgdfiQQCf1ynI0yg6IJn1ANFY0giDi/+KAO7D2bgXhaS1H8PF6JVt+rCw75EWbbei/74tYcLEfBf72ciZfsjDVZNd4FPFz16bi6W3dek52vHDUT6zz7sTLZeYyVrHKpNRhk4gvX8z4U291VdRJ8syfUq7rpKIgCTZuJFbSCvexFTALCzYl4HwY8tqBcM8nImWr2CvdRN/Fx2yzqxGZPOjuhHQrYT5Xhb12vEaHRq7QURGxvPLwQhUIoitlTUVA2UbN+0Vx2XwzBP4LjBi0d1xnsUakQyORVgd4Z6/f1Uwrx0Cqtp+Jw88AbaWGYmX7TQWqP6UGUimD3QO1nRuAIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Sep 17, 2026 at 08:47:42PM +0100, Lorenzo Stoakes (ARM) wrote:
>Provide a function to abstract the common task of checking whether
>a VMA has an anonymous reverse mapping associated with it.
>
>If the VMA is attached, a VMA or mmap lock must be held when calling this
>function.
>
>For an attached, anonymous, VMA:
>
>          Transition          |              VMA/mmap Lock state
> -----------------------------|-------------------------------------------
>   No anon rmap to anon rmap  | Write lock/read lock + mm->page_table_lock
>   Anon rmap to no anon rmap  | Write lock
>
>vma_has_anon_rmap() never provides a false positive (the lock precludes
>it), but if only a read lock is held, a negative result must be re-checked
>with mm->page_table_lock held.
>
>A VMA obtains an anonymous reverse mapping when first faulted or forked
>and it is removed when it is freed.
>
>Detached VMAs cannot be concurrently manipulated as they are removed from
>the maple tree so require no guarantees.
>
>Use data_race() to silence KCSAN about non-existent data races between
>concurrent vma->anon_vma read/write on optimistic fault tests.
>
>Update the core VMA merge/split, rmap, mremap, KSM, fork,
>khugepaged and fault preparation callers which test vma->anon_vma directly
>to use vma_has_anon_rmap() instead.
>
>Finally, update comments that reference anon_vma to reference the anon rmap
>instead.
>
>Since the lockless read in reusable_anon_vma() is doing more than checking
>whether the VMA has anon rmap - it is returning the anon_vma to be used on
>fault - do not alter it.
>
>There is one odd one out - file_backed_vma_is_retractable() - which holds
>neither a VMA nor mmap lock and is stabilised by the file rmap lock only,
>so simply add a comment to explain why it's necessary.
>
>Reported-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
>Closes: https://lore.kernel.org/all/20260829100034.423064-1-trintaeoitogc@gmail.com/
>Closes: https://lore.kernel.org/all/20260909115723.528501-1-trintaeoitogc@gmail.com/
>Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Nothing jumped out at me,

Reviewed-by: Lance Yang <lance.yang@linux.dev>

