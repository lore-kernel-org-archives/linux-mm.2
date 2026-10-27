Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F96606A336
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ayiRgza/
Received: by kanga.kvack.org (Postfix)
	id 395B26B0674; Tue, 27 Oct 2026 05:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3463D6B0675; Tue, 27 Oct 2026 05:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E866B0676; Tue, 27 Oct 2026 05:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2D4B6B0674
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:47:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A19FA867F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:47:28 +0000 (UTC)
X-FDA: 85367928576.06.54C7BE7
Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7C9DDC0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:47:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ayiRgza/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793094446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vkRbVEYH/IpHfx5799qbaRy/Rz2dM/B52EsX44m71XA=;
	b=pzIXj91Tt0dNG11vHG9VNXlrlJf3nP4JOcBY5cQFdfQoRJ/dgd7a+PH7EAtTEM2bdmOVVg
	CqsFhfnzYsOBETvGXdFR/X/ySar6+YkVBOTtfuIfnR+MKJIMVVRHeHzbva8bQpWa597TF4
	ZnuxYPIurRXbAuBctcIp5AfCw0Rhy4s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ayiRgza/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793094446;
	b=tyrz9TY14FLrmW1h9vAD4DPZ8S5p/qDQnWdJQnimiETBOeVtQ+F1rhJH7/Ua4GbT4cqlSr
	eIZE7yufdoJHdnsz63ktvpQaWlriz7eZiu8OvannWfAYT+YLRayszTlJHs/heUgfGGYZon
	6mJv0PMgasRGgLU0tMVSoO4l/R4aUag=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cPhbwrLxrBeT9JsGny5RJdPlGOD/1Ehjle0H8Uiu/2w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793094445; v=1; x=1793699245;
 b=ayiRgza/GxxmiVI9rgFsykUvChZWAtRADU5um6RBV71Km8e1c4L5jy/cPURegap7ZDCx6IFM
 bX37cSFeF5CycBHA7SWLRaiZAOMH3jO6XedepEVuCZJjsKpGXjjrmoB32a0QwIDJDb6RMbWFhbi
 OUBk4/abpc9TguYGICF4Oc9k=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 4eebca5cdaffa06c;
	Tue, 27 Oct 2026 09:47:24 +0000
X-Mizu-Trace-ID: 4eebca5cdaffa06c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 37/46] mm: fix deadlock of mremap() against UFFDIO_MOVE
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261027-fixes_core-v1-37-6f74bec9a5bb@kernel.org>
Date: Tue, 27 Oct 2026 17:46:54 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>,
 Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>,
 Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>,
 Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>,
 Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>,
 Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org,
 Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EE612F16-A900-4E5C-8F9F-523F1CA690E6@linux.dev>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-37-6f74bec9a5bb@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 7C9DDC0006
X-Rspam-User: 
X-Stat-Signature: 66x7ywfo3oh9g7m163k5qptt6sauzoyc
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793094446-162579
X-HE-Meta: U2FsdGVkX198g7bjjUpUtJhHY8pEyMpm1Qd28r2p/grmgOQyaCtDHXHvtatNU0IRuQbL1XOGK+IHaa5GTb5PWIapXZ3ltPAmLoM0oujuyaI2F1oysQ104GvnO1fu7/PDpavrAMd+3jEpFN3OocqRRtmKIjtPftU0LX3askVRV+KMxKyZGThgywyXexJfuNuzJj+LtSngFLinM4yB7Ac8ppBsAtXoYi6p0s0ESBNbrNnE8hr2DDuyAKlYtk5nmGa/YKQH2GWxfHYHXfwhtXkmVXKgdWOpZpth/qJvJ17Rb8sVoU8v9eAdJ3+a24Fmhn+faqMyw41jZn/tyM8l0IrL+OenrAFYE70F+aOFr7i89ggLjWvUaeVoZU1x9tDQAhp2/+YP+AeF5eQVvUSv34KbugcRE1jnH6rOFe0K1sQ4ADuotmbtWGSv4Xen+bjS+VCD+CifgGbvaY7iaGNE9gaOiYeF3bDBOnqnrSW0RInlG5Q3TSyUzCDTbFdA7XzqMfPNAb2UHlzb8Mm03NKHNu0p/h4Lbo4ugyddh9E23pbqhRmZprchee9Extxc8bgLM3hyao4b+Tv2Y9nhauTIanVBm9Xyd3s0NN2COkbB8eY9eLpVJ+P2p5IZyEPcIEdTnZfy6VQ+Kj3DSV/hAPgkEaIv624hULy2/nUhBCEpkeyf3MdJgMylWnpjQAJaSl4Uoo95W+ZCOIwPelIQGsvBCuDivq3NLkvmaaKpll1sFvAvG93sW4P6Ny9hKzO+M+53a7jB6YCCXGUIbh6St8/CXnSVpDTaaQPn8dhdGHywB5H6rr3MOFUCLkqHyxAbYsG5TS66/bPUHazcaDJTb9GJJVerlInyJYqjZXqn9M9DD97u1S/wa1nM70AHC5SiixacRkbdChrn4tR2SQj/jV5OoTO/r6rRaRWdL/RGPlBx/MXBGs7qsAfWcg8ZTd5JMbzB/75a61xTUaL9BiFCI0RmiKW
 FlMmoTNz
 Hj0hia1OFI8icpaQ6STAfs4Qj4FGfoAlP+kofEUimVI9wZDEZOs9NU2KGV5ZZTzDQMkMTFIXRtc+kubvsqowW3Jc/k9Ndcf/Q26NdvPAOCtHCO0b87gVeO928tkuKwLVQrABf5qU5ZLpFdBieZgt5i1oJoXqws71q2W5Wz+zq9joTIqSuZSoqGzsFXggTdfJdR0920rwme+B4kn6+EABizUrhkQAArlQjgsbK6bUE8XLcEW/kOVLE1yKQEISLASfn6DEFNUjL4wkYnjqR13INw+QLVQjUEkqxr3ucFY8UZpgQLgLavo6WAHjN2fSaB7BmiCfe3Z7My2pyWMFknG5evUULPib96ez+LI/VPnufrXuEzHU7NpAErBpvxWCBurTzghWBtlFQhmVRfYI8UKBrEo23I3c05vDL+934mToCekZ1P6n1PeYIHuPfzeECh4QcUWrx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 27, 2026, at 07:17, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> From: Chris Mason <mason@kernel.org>
>=20
> With per-VMA locks, UFFDIO_MOVE can run concurrently with mremap()
> on different VMAs in the same mm. Those VMAs can share page tables, so
> both operations can acquire the same pair of page-table locks.
>=20
> UFFDIO_MOVE orders the locks by address, while mremap() takes the =
source
> lock first. These conflicting orders can deadlock; mremap() holding
> mmap_lock for writing no longer helps.
>=20
> Move double_pt_lock() and double_pt_unlock() to mm/internal.h and use
> them for all page-table moves in mremap(). Preserve the source entry
> checks after acquiring both locks. Remove the comments claiming that
> exclusive mmap_lock makes lock ordering irrelevant.
>=20
> In move_ptes(), make sure to just recheck source and destination PMD
> after taking the locks and drop the overly-long comment.
>=20
> Fix generated by an LLM and sent by Chris Mason in private.
>=20
> Fixes: 867a43a34ff8 ("userfaultfd: use per-vma locks in userfaultfd =
operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: use new helpers consistently; simplify description and =
comments;
>         move_ptes() fixup ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


