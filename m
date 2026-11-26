Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8809606A332
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 02:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=apKRlw4O
Received: by kanga.kvack.org (Postfix)
	id D17266B0B5F; Wed, 25 Nov 2026 21:11:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7FA6B0B61; Wed, 25 Nov 2026 21:11:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7556B0B62; Wed, 25 Nov 2026 21:11:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 853FB6B0B5F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:11:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC81714022B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:11:47 +0000 (UTC)
X-FDA: 85475644254.03.D192899
Received: from mta1.migadu.com (out-218.mta1.migadu.com [95.215.58.218])
	by imf24.hostedemail.com (Postfix) with ESMTP id 97D2A180007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:11:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=apKRlw4O;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795659106;
	b=QX/9UTh/0gME+jqGJOiQ8kq6K3/yWNA3Gsp31+zNlyplQfW+5oxznBroZqPQaoyejIpjpD
	CVoYyikqSq9WHZ3NAytSoRO2GsVQJvnvMzAFnt9XgrHYJYKhnIfl0zyi8a4cWoTXzT2CZK
	ykZB7jsw3AWCIA0Sv9dHfckY1M4XlM4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795659106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vtrF8jusFMf2lW/rRdAFBKENFPwZGZsrZsRLf4xeGz0=;
	b=jvo0If3TQMkoT3CbBMZVKgOtu7STA3oGXPm/aW0s0spBuCl3ACARNHG5JaE5Ca1rKYzAVz
	Q1qlOuECDxuwcWioePJxoMU3/2OuvzvAgdR2fj/DETUuABat42wtzDE1uiZxCyUcmIcGWz
	SpYRdjm4/PtGqImJVa75BAB9kmxBqlg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=apKRlw4O;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BHZECrat/VYigSRXJnPVnKZEhBZ342/Z/aVBvJO8P8c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795659104; v=1; x=1796263904;
 b=apKRlw4OJ/iUTjdTjtKfmaZvZmP93yrnR4YaVPWtyMoZpH0zA6JBpaw9dLqt5qDJ+RImpECE
 wnRo5WHV+Qxab5pOo6vNUjz+XagG9FYJB5Set5pLSD2SJXL6XvHP46fsyNf6WkNQaXG1s/LffBJ
 EtT8x5Zz88Sudde189gYg8NM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 925c7fbcc772d409;
	Thu, 26 Nov 2026 02:11:43 +0000
X-Mizu-Trace-ID: 925c7fbcc772d409
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 18/21] fs/proc/task_mmu: don't clear VM_SOFTDIRTY on
 hugetlb VMAs
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-18-db27fd2f71a8@kernel.org>
Date: Thu, 26 Nov 2026 10:11:14 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jinmeng Zhou <jinmengzhou22@gmail.com>,
 Hongfu Li <lihongfu@kylinos.cn>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Dave Airlie <airlied@redhat.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Gerd Hoffmann <kraxel@redhat.com>,
 Mike Rapoport <rppt@kernel.org>,
 Mel Gorman <mel@csn.ul.ie>,
 Dave McCracken <dave.mccracken@oracle.com>,
 Andy Whitcroft <apw@shadowen.org>,
 Adam Litke <agl@us.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 Yang Shi <shy828301@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>,
 Gregory Price <gourry@gourry.net>,
 Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Byungchul Park <byungchul@sk.com>,
 Alistair Popple <apopple@nvidia.com>,
 Wanpeng Li <liwanp@linux.vnet.ibm.com>,
 Andi Kleen <ak@linux.intel.com>,
 Kenneth W Chen <kenneth.w.chen@intel.com>,
 Hugh Dickins <hugh@veritas.com>,
 Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Joern Engel <joern@logfs.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Michal Hocko <mhocko@suse.cz>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Sasha Levin <sasha.levin@oracle.com>,
 Guillaume Morin <guillaume@morinfr.org>,
 Wanpeng Li <liwp.linux@gmail.com>,
 linux-mm@kvack.org,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@osdl.org>,
 linux-doc@vger.kernel.org,
 stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7E44AC1A-59A4-4FD5-B5CB-4CFF49282C93@linux.dev>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
 <20261125-hugetlb_fixes_2-v1-18-db27fd2f71a8@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 97D2A180007
X-Rspam-User:
X-Stat-Signature: 36b5kzoij3pfnyj4e9zd9wkmcfyuutae
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795659105-361915
X-HE-Meta: U2FsdGVkX19K1q1gI+lA5SWKuVvMKl8s7l/tMBPyJZe3jJypz1U8E3O6wtxKie4FChXwCK7FWRcb+9GgmlA0BHVNYA2a65E6bohsCPlzb1NWgNofoLuCOp7Ngw+qDvhxpL5CGvciEEyg8RSUxJA79F4RglNToQuvz7GNt1MPGlVCDPAgKHtiDOvtj4wQBvQz837gwyeoSqw5D0i5JeMgwBsW0jCas1h90VsfF+xzTm72Oz3iWPEf6BBozMpuJJI4aV2Adl5zbbOGA80zsKh4cVRGZ1q5LqnJ0d89hm0yVtnDj6Y/M8OzDSeAnmL1WRSuHQFJ29J5eJo/s+L9ogPC9YNuxWuorOT87ng0jwk33KGxEmXbUh9nfV45NzRfIl3CBTx/qBqRGSlCWBxZB22uXZ+eT8rcPQug19n13Yae02eeYG81L1XaoDBfdQpwNwq6VghUFlxrPvpgUfuEog3diIiI+/4b52XoM9VMDyCqH6J6N8YitFJL12iSALazswxwE6s0GMggvSX6sXr2Ch7hfIAylzE8SBMras8uog66bkGbhDSnsGNQrJQBZKXCphOSOg6Sdxau28LFjKwv1TDl5YkesSBBVWNnTNMbuNijf5EDLWYK+EaCxVuM9nzvM7r2SfjFMUAGUrozUdsxbQ/sW/MS9PDnpgo9L8YZBtVNgrcS+9SV9170xZAbtC68Wok9FYnlMnu1QcMi+dNnqplXA6f4c00YFlczT1+zs9z/EC7GDXrUjt5oWbl9AESxHbCQpjSLJ9wwOd5A8ufyi9Ij6c2QksBl+RBamJb393vUBk622YRrAakiZotQx5AC1NKI786jlPaWQPEuliWsTz0P4ik+jDDSpp4oGmWuZArMk2IGSSDi0DglhOXnOUxtatEkjJMOXrxlwGIzRAXVhvwipjPQcsWlzkJJ8QA5Yx2O/zdEgzo/Mnffr6Ye/SO7dP9pVmljc9NITdecf8hWmhg
 Vv/UxHSb
 BE94G3vzLBvR4vkXpX5EjlcXSSRBdeMHtpb0BjAQMsPUeU9AUY/CP/IRyVh8gqLdExaS8uPeoi0PtqMIRqwy5csOBqxULVTIoVgzR3+6+YJLU0ZJE4MfOoeyqo/2C7Y2oZUdZL4qPFQ0QyloOLHvwjpGcboueKdLx2di402exLOr+U6E116fdJHHyv1kdFU9nfx7F4skInB9fuhb3SbN4OnIcXQOuns4dFDfO5z2GFUDCePndLD48pcNF9tSKP9dvYh4o1gd8zaC2eZc2EXphH00gdOb56TWeGejVMJEkZSRQaHgQi05TAEGGY4BZc3/9iX+YOVQnmbAaOgGmC7ixFWeHQG25pLF3zti7cwI1XzOp2Kl4/7UKwRdj+NDfsBzRvSlwbkeKw6r8ghcNKs+k73ymi/HGVlX3zx/2s+w6ivr2T2ZgsdUxbKn+UkXAXaUFUWNhKgfREuimDSo2TL9OWlyyuRGLDybpM/PuUgxSI150SZ+eKYIOHqX2D9aTbEpOHsCawJoqlbK2zhpo8hs7RHQArXJ+D90KNL/A72dgDM1DPKVIm32xF8vtGfJFRpnsu81sTn10PzkXiWnJm1ztLK8AQRq+Hl3RY5hMMsS+Rtk95ryIFsefjMllw51qjvRoVdDYniEFusMLBZtYieAUbNOEgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 26, 2026, at 06:33, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> hugetlb does not support soft-dirty tracking: since commit =
f96f7a40874d
> ("mm/hugetlb: fix hugetlb not supporting softdirty tracking"),
> vma_wants_writenotify() ignores VM_SOFTDIRTY for hugetlb VMAs, and
> clear_refs never clears the soft-dirty bits of hugetlb entries.
>=20
> However, clear_refs still clears VM_SOFTDIRTY on hugetlb VMAs. With
> CONFIG_MEM_SOFT_DIRTY, a FOLL_FORCE write to a private hugetlb mapping
> without VM_WRITE can then loop in __get_user_pages() until the task is
> killed, with the mmap_lock held for reading:
>=20
>    __get_user_pages()
>    retry:
>      follow_page_mask()
>        follow_huge_pmd()
>          can_follow_write_pmd()
>            pmd_needs_soft_dirty_wp() is true
>          returns NULL
>      faultin_page()
>        hugetlb_wp()
>          set_huge_ptep_maybe_writable()
>            no VM_WRITE: the entry stays as it is
>        returns 0
>      goto retry
>=20
> Let's fix it by not clearing VM_SOFTDIRTY on hugetlb VMAs, so we =
always
> treat hugetlb pages as soft-dirty.
>=20
> This has low urgency, as the loop can be killed.
>=20
> Fixes: 052ccfbcc6cd ("mm/hugetlb: support FOLL_FORCE|FOLL_WRITE")
> Cc: <stable@vger.kernel.org>
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>



