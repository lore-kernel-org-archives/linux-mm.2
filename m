Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4D20606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ALg7S6VN;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ZnY+bcNZ;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ALg7S6VN;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ZnY+bcNZ
Received: by kanga.kvack.org (Postfix)
	id E20746B05BE; Wed, 28 Oct 2026 09:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF8446B05BF; Wed, 28 Oct 2026 09:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E066B05C0; Wed, 28 Oct 2026 09:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B251A6B05BE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:28:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC6A2A8A4E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:28:13 +0000 (UTC)
X-FDA: 85372113666.25.DC38209
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id B34DB180007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:28:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ALg7S6VN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZnY+bcNZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ALg7S6VN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZnY+bcNZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793194091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I1RNhY463TlUij+3G3iMbvuChAlQ+OLmz5YWd+MK6CA=;
	b=xDAabhgqR/Z0Qt+ZcL1DqVQ+9KxRtM/oE5+Mn397pVUJjm4WgK3a4A+f/5OSEIyzv5N5ye
	W6Ea77jxrBnNPtyH8aQRrOqc6Ni6TxHIlr9JiM7XqgM0MfuRdBI+MMZW8sAe9qh/C8Cpvz
	jZ4s+gRcau/SDjAI5lz/gcIs7l0RS60=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ALg7S6VN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZnY+bcNZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ALg7S6VN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZnY+bcNZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793194091;
	b=hhyTduSjJF73j9wQSTETATO/YYk/hWjDz+Ueo7MG54GF8QKitn6c3c6UuxFFcWpd48fAz2
	tkN4hujb8nbXUz7uvRxIJQOhOF/v24T+edx4TULreWI1SOkihpbo4LvM8U/V3dgIYGiGnz
	Wu6zk4i0RF3B8WQA3ECUSxd3TcE1qxk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A1CC42211D;
	Wed, 28 Oct 2026 13:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793194090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I1RNhY463TlUij+3G3iMbvuChAlQ+OLmz5YWd+MK6CA=;
	b=ALg7S6VNVeN7jO6Z7rlet/HLuKH1zkhEgjQR2Xvm4DkhHKhTBLq53hW/xC+fT4PpUaiCNz
	B9QXxj/DluV0nfi3hKw4vzd/L6Iy1o9tCnhLX2zduQQH0uhF/uKi8emqpuWoDssyk2EeP7
	FPOU2p73i8PKM79PYL3ibH89LPsH9Rg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793194090;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I1RNhY463TlUij+3G3iMbvuChAlQ+OLmz5YWd+MK6CA=;
	b=ZnY+bcNZGtDLLTNjb64cdXLVrUWCI/Uuh2kNnd+cr7Tj56tawriBozgiH7MF4GNYbyz8E9
	1a1ICcFS7uYeiiCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793194090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I1RNhY463TlUij+3G3iMbvuChAlQ+OLmz5YWd+MK6CA=;
	b=ALg7S6VNVeN7jO6Z7rlet/HLuKH1zkhEgjQR2Xvm4DkhHKhTBLq53hW/xC+fT4PpUaiCNz
	B9QXxj/DluV0nfi3hKw4vzd/L6Iy1o9tCnhLX2zduQQH0uhF/uKi8emqpuWoDssyk2EeP7
	FPOU2p73i8PKM79PYL3ibH89LPsH9Rg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793194090;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I1RNhY463TlUij+3G3iMbvuChAlQ+OLmz5YWd+MK6CA=;
	b=ZnY+bcNZGtDLLTNjb64cdXLVrUWCI/Uuh2kNnd+cr7Tj56tawriBozgiH7MF4GNYbyz8E9
	1a1ICcFS7uYeiiCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9661213419;
	Wed, 28 Oct 2026 13:28:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4DfdGGb44WoUOQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 28 Oct 2026 13:28:06 +0000
Date: Wed, 28 Oct 2026 13:28:04 +0000
From: Pedro Falcato <pfalcato@suse.de>
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
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 29/46] mm/mremap: use pudp_huge_get_and_clear() when
 moving huge PUDs
Message-ID: <auH4NKaWuE0-8XBk@pedro-suse.tail5790ac.ts.net>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-29-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-29-6f74bec9a5bb@kernel.org>
X-Spam-Score: -11.80
X-Spam-Level: 
X-Rspamd-Queue-Id: B34DB180007
X-Stat-Signature: xpwoq7s8i6eisbik6euoq6hr5yrk4tp8
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793194091-227459
X-HE-Meta: U2FsdGVkX1+zpwajttDOt7SC2AGbBZuVf7egSubiDCznNvpBj36s0WWdjZ4q7Eyro7imbIF77JTyBES51FizTh5MFTc92bxuqu0k5nihu/r5yQ+VD16ICGrptXciw0UbOXGKp8xMOItLsVwPi77SEJJgRPk9cX0pCvrLTn2P/Ok/JKP9J/fIjkhOBs16GkJzTR6D3rHBT/vQHTmbS2zB+8yyw0m1087oG+DtgbpHTEnOi0VklGpIaB6O81MCv019S7dMoQ2ea4tqAve6mGkzH9kVOoBHj2er/cwJKZ0S1aY6lOIL9CjNu0V795VOIPlTAis3azcuIRSA6wX9ZxzmIIoIz9T2Cqpf4wlZBeljQmYcpEVHf4pjPjx1hw7ydBz50ncII2EydvkuT3KwmfXFeSSxQPiYZroSgNWR3dkqkdCwqlfFmZAwhElaOI/8Fx2tIMVtRwSA/qdjUpXrmobGa40FixLFgK8oTf6HUqVyJugQ1vdsLKM/PdqwVn8YKc/aD676uYGFeb/ZBJ6/5VhUFg2ys26coGhmQ4cfdjdRpJKwSXFG5fQ2XS02u+UT1oildY2UNry3S3jqCWm96/Ew0boY7fC96e28emV9BKtikh7qZhtA+OdncXNyaRYpTEFCeA3xUqNFFU4XNoq1Hom3RrUjzX+22PzpY0drUZ1IV4tkjXwboRwVf7ve9gnULmf03XGLyeTDvryEFp62q42sq/afQtB+FTwHxMFY821zunc9kOIBshckrmn+rRmiAfUYZM/DJ3L5lxJRXwuQbMRs5tJ+A6fCIO/QwvNFW73YUoWWjCQLkfajTHEIf0AOzuMBijiiiGB6Q8YYpLUNKctJ4ANSsS3DX0eLrXrzlO6WsGDtjnP3ei7mnbyAqcGgbIoeVBjLD6joW8+QXM90A/hCA3BJz19yv8Ku/+8kefivJxopELJlal/eJFPPizNcM7VPbzx/XKIW71KgEb4CVto
 sUC9x8wB
 VpeSN7IAxBq1Kzb5s8w01HPbNlM213AL2Pdybxyz2vzGJn5BtGqt2ylWd98yWeSLYXfbBB2oHYZyHgaPXq6gzDB3JRmXs5sJCjmqmDp8d+VUYisytXvSNel9AsDmmX7FNBvTaVyiXX0my5tL/hoRxPsIszNcjVBhYXFhv6o12751/FdU5AwUIoCDK2tB6x98gqA176wD81HCqe4+yHaiExmRpR+G7K8BMql5NYvrIQbIBS4SaLJhvmM/krnwnzWyg32SdtJ3Sw56sVQx0bl6z7yQ+Blqfd4skKslVyUwo2ZhLS/8jswcHyNrePq9OO0iuXFGmUCzx7cjXboAKgxgZz12A2s0Zz44cO78qJKLW5dzIm8GT8hU6cL++/h1/z7t8F8B0hvTEdhu5X+FXJPAXmZsuX94VQvsbBD8hvkb9EHEOAjofJiMXDCEtpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:49AM +0100, David Hildenbrand (Arm) wrote:
> move_huge_pud() reads the old PUD and clears it in separate operations.
> Hardware accessed or dirty updates between those operations can be lost
> when the saved entry is installed at the new address.
> 
> The raw pud_clear() also bypasses page_table_check_pud_clear(), while
> set_pud_at() accounts for the destination mapping. This leaves the
> checker counts unbalanced for mappings tracked by page table checking.
> 
> To fix it, simply use pudp_huge_get_and_clear().
> 
> Fixes: 7d846db7d0e2 ("mm/mremap: convert huge PUD move to separate helper")
> Cc: stable@vger.kernel.org
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

At what point do we ban straight up clearing a PTE/PMD/PUD/etc? :)

-- 
Pedro

