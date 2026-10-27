Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6D0606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cUUj8rbd
Received: by kanga.kvack.org (Postfix)
	id 9DDFA6B076D; Tue, 27 Oct 2026 16:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6366B0776; Tue, 27 Oct 2026 16:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CCB56B0778; Tue, 27 Oct 2026 16:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2A76B076D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:32:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8CC91A0ADB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:32:32 +0000 (UTC)
X-FDA: 85369554144.19.A807655
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0ECC5C0009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:32:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cUUj8rbd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793133151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=86fhQATGDo+8MDnZqTEUILQavbmG5W/eLVJguZT8p6Y=;
	b=f0PPQmKyaQXgFApNvoc6ak0nKCcqqla0z76nU+szlkISECS5iWKPD/wBys/Uppo2ddFu5K
	h2xDl0j0gE5yioZrMexd2ydhDjEIaLmoYJe76H90TtTa4Scx7RouvvjZJ2YhHPH4++xlEq
	vLYli6JBA7YpZR+W3FNm+TCUW9opXfQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cUUj8rbd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793133151;
	b=z56Ooyu/2h2/FFZs000eqzkjw4QyrcLLSatKmfzAVh4OX+oDv4R4DAV2VHmbeH694hEFRx
	2b89/1jevjk9VeaD7ANKbu79llPC45EBqkrLyDQKWqOo6YQktqob9yBx8Ym6D2iAKTUYVW
	8DoN2x07ZTHOMOiW3Td/ytHOR96MA+c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20C2043075;
	Tue, 27 Oct 2026 20:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5A11F01825;
	Tue, 27 Oct 2026 20:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793133150;
	bh=86fhQATGDo+8MDnZqTEUILQavbmG5W/eLVJguZT8p6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cUUj8rbdB8sxeJkMuDL4RCOdrYbrRplzvevKwnxFuwaEcH7HP+ENffudf2T0mpEpv
	 5IgYZPx4U8OILjqSgrQVM2ZVtEuU+s+iUCRqr37O0SlFEfCwYP6WH8sUr54mzsCt1s
	 iMf6J0wk9xYuuAD3vV+C40mhUS8iHT1njIORZz73KfNOXA2HaiIMPxjzwaUpjzGq0a
	 +HDzAe6Y83Ik9oMrM+EDzTEENc7lTwdaNWApON+amLO666KTk6vgqAwdt/I26Z5K2e
	 tnFRDkmrRt4vDlqitIfQMOzf4AtEOnF0EKCtlUHfO8gpTP2ZD2//SXJTbcFDzwJNgN
	 ttZ0nsquNOB0g==
Date: Tue, 27 Oct 2026 20:32:28 +0000
From: Harry Yoo <harry@kernel.org>
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
	Rik van Riel <riel@surriel.com>, Alistair Popple <apopple@nvidia.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
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
Subject: Re: [PATCH 43/46] mm/vma: don't leak the charge for stack growth
Message-ID: <auEJGq46amG5oPVQ@thinkstation>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-43-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-43-6f74bec9a5bb@kernel.org>
X-Rspamd-Queue-Id: 0ECC5C0009
X-Stat-Signature: cqtjoxipyj433kyuzxmbjcptk66w1h14
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793133150-748236
X-HE-Meta: U2FsdGVkX1++eU57QE6AwLph9IlrL8tsUTLq4tIki/pTKrLMcluiCFRqFDVPA4GU57tdhAU+XJL++y44w39TSL7aLoNFBACclsuM47ltYJX+FIngh/MfCGgNKEO6BlQcubw8hdl3jGpEol7CDG9JyrUqGDbAONgWDmakHVZxmZeZIJjjsIiKFs7oplxZRhqBX/xDbr6bgjaamGS4oAcflDo4lO79mr8Ut8Y4r3VzuKFwx410Nk5dmfD4zDzW62gtiBaXnpWcDAqljK6aaMPkG80qy3194NOoFpuPjGGQmOXcD3650v+tnunksMK2GcZuYIMEM9OkKvzp02fV63+6k3scOfhoMXkn5QhBtIXDhXEA8r3g3lZ6Lcew9A7aWI5bVlrab2rVVsVGf2bRrXChTXwDIdz7LIqrxeGFg2+RaBAiY4tWOxZdYjjbxBZT+W3akZuN79oqX2xRl7O1C//VFySNB9jIqmUkbq9rgA73uhmJ2cCErd7htUlfbf0fW2Yv42Ob2R244t8q9OEX5bHX7v3BhFtZ/9YFIa+qeePXwUgihUf7WiTkfAMUTgnYvygNOtTLMT2SGwJhNDhWhMRa3aAXntpVFR20RTvV9eqsSQP8GEY2e93+PMifZZqMBfzy3pc630Bh+OxznPT8R111l0TQGalw3hyk1+DJ3hqnFNzajq54nsheq5Ii0CtlYI35OdyuviDNuXbVwZ/I+xibvRB9bc0LPBrWmcdls2aWXkARdZgfc92ZtILSaRQk8vEbgV07r375tdX87muPxf5Y39VBASqPbNMiBHqgNUFFsU4wzgGu4JLpoAwyO61aSSHSSG5xm+982Zu8FhVrMvVSo1Cn+Vw789xq8VGIEW8Fk80UZ832W4WaruuFqT61CLoj1ZCThPsu5D74PtdKL0xAXJazvNEQBC/DiWagx1ml+9XPBX8rTfTvJZqCbmQLK9D1yqVG5IGrU08pWbbIc8S
 fUXs+17e
 P89igjh+b1ujDSFwVIDyhrncl5/Ln807EzFHN/ZJL52aWzNbZcjXejHEbEhzoeXwh9EEWMacjNq6h/sR34K4W/vuL5VSeP3/8LZRBATMu3QpsjH2k/EZeCiYhNo/dRIOqxg9FODr4OBb8yMMsCWMRxBck+NDXn1nWWZ+wmqdoVBCsorwoeKyX/QcybO1RIxl6Tv0+ukTPP50IaHNWqOOmRACYUTww8Lc/qDuOauMRQh/Uca084Guv54dDMk/lfeIF1unEeHnxBe9/dkrsqbPSBPMb+3ycevkOwo50zdL0qVMkJ/18o2XXPDOtSPnmLStZQVE3f5EVk6nahH6CPg24cQFkFmZ+6ooDdzx8nDe1f21cFhhdu5HM9g/OgQltO3aaFfF8F0HQyGcKSqmHl5vXQjJQQaT3EQfrNPNX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:18:03AM +0100, David Hildenbrand (Arm) wrote:
> acct_stack_growth() charges stack expansion even without VM_ACCOUNT.
> This can happen for read-only or MAP_NORESERVE mappings created with
> MAP_GROWSDOWN. Unmapping these VMAs does not release the charge, leaking
> Committed_AS.
> 
> Only check and charge growth for VM_ACCOUNT VMAs, matching mremap().
> Unaccounted growth skips the overcommit check while remaining subject
> to the other stack-growth limits.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

Maybe worth having a warning when it's accounting w/o VMA_ACCOUNT_BIT
or let those helpers skip when there's no VMA_ACCOUNT_BIT set... 

-- 
Cheers,
Harry / Hyeonggon

