Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2DAFCCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 09:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CDF76B0088; Fri, 16 Oct 2026 05:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E066B008A; Fri, 16 Oct 2026 05:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AC66B0099; Fri, 16 Oct 2026 05:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AFA66B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:52:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24301140315
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:52:26 +0000 (UTC)
X-FDA: 85328024292.12.BAA3838
Received: from mta1.migadu.com (out-147.mta1.migadu.com [95.215.58.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id C1DAD40003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:52:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xB1w8S3z;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.147 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792144344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gr2KJzdAh9yULg7Am+/tTKh5n7rcHxn9V7KaA6ZsJX8=;
	b=5O/47Y37924GKA5Bd58ociXNDYXnTCuZr9GaEKYteXY8IvmiTrTG8JQ/d+J5m0MWaSXtOj
	VGW57mQ6hPwnAyey2P4OetCZU6Pcy48iFB9Ezcy7VGnGROc763FqyuN0hnuaR52JhHWTJ+
	sifdryzSPcDGPc4ZV5mJMUwLZqzkxDk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792144344;
	b=hpIu4h/L7MFMBeV20yKEVCH8zfg+ZM/3LcFxlKAhwpJscHdRHKcGcizxv3QBXHkmJ97/gy
	upC8ss8ibhB2GVhu03mZiEXP1f/jo3+2zXpIux1Sti0AwQZEjdfuubaz/P0h5EVbQyEZlK
	W5SI22c2G5IXPTy1U62NzRiW5Wn3V/Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xB1w8S3z;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.147 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cYDQAo4y4RUVTtwoUXBAS+2ASZSDHzhPf6jkQnpyU60=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792144342; v=1; x=1792749142;
 b=xB1w8S3zBSgF2SQ7hQW2j9zrs6T4Rn9vpXhT5nPI1tgerR4OAToFbei3+msLxVTpPkaJTCTe
 iLeCfqpa9KihhS2EFrkV9JaPzMUsfpv5vkdntsCBTweJtnh3n9KEn6qUptxLwL447hv3Gfn4Bcs
 mpvSb0+3iWXmexUxpMphehC0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id be15a02e218a3bac;
	Fri, 16 Oct 2026 09:52:22 +0000
X-Mizu-Trace-ID: be15a02e218a3bac
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 05/10] mm/hugetlb: don't clear the resv_map of a VMA whose
 lock is held
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261015-urgent_fixes-v1-5-42796911043b@kernel.org>
Date: Fri, 16 Oct 2026 17:52:04 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Adam Litke <agl@us.ibm.com>,
 Mel Gorman <mel@csn.ul.ie>,
 Rik van Riel <riel@surriel.com>,
 Peter Xu <peterx@redhat.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <92E58ED4-A09C-41CB-A3B8-12F6F834FD87@linux.dev>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
 <20261015-urgent_fixes-v1-5-42796911043b@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C1DAD40003
X-Rspam-User: 
X-Stat-Signature: y3zsde5kfxkamqgxrk53djcgrhyf8a7h
X-HE-Tag: 1792144343-55307
X-HE-Meta: U2FsdGVkX1/6I2Kyf+TelUHhXhW6E5+mXbgKszUa1RZz7Ofxk+Bo3VtTTfFCTdxS/L/U7/u8/IInrlERnmNRIRf2fmqkeDVNAXAK7p6VpDRZ/5LcCX8y9X54HqW8R2xTzlSmhnfGnPDsQ2qx1LE3L4CGWh1wUU/YVVmtCLmvsNvr+5qPMHGEYT7qOS7bfRVZR/ncqHXjmmvMZsf10lQe+JBCQmKLl4CP08ZvSKk4s0jm2NKPFIIJEYP/YiijJjbCM1rw/uF6AQYX5eUccnk4TjQBFDGi81GFGmFiQJyQdFr32ihU+dg4kJ5U581/Lx00d00cvxts92DmYjEcF1oILhJHekvpvldZ+B3ivX8Y1uuvJfA2NA6T2dFvNtSEIjVC9whrD8zUMsu2+Bq/Tgj3C6A37En/GtIiY7hb2gSQ3e5WyRQrCsydI/JifPeEFxOSTpE3pqvurEhbL2Ljg3e54KMlXcUnxP3pU6h9oq/G+aeEQ4Mba9ywGG9g2i+nAdFPeiPaq9sYckcuXWVPsjkhs+06he3J7qraXSXyDYvsTY9X+iAjULJatnl3Goof5ueowzQToFBkShlmghB6He2wkXfuQRNqkUIwIG82KwbpmSa99asWmaLlFRIxfk05t3MKi+KszRSRBbVJfJzFNCmpfgMUqyrP4HRXoovrBdgbMuOmgY1I99IEPJyP0PiFElHDMU/Zn731jZDXBExQrgYFdEKukufqAVEPJH2epK/A96lfjst16mLdXgrFAbH4FLfog6m/+hrh8oZZgsHgkQs2aMKg5Nf5k6P9YVsCGRSYWStqOvTdfz5P10AnL7XKWfu0G+8Zq6iwPlHjhannmg2n+WsmnJpYrerqhPR+1fyBEeDfXLQVos22mkIWr5ktDDWEYpdEXY0/SgDcxmYdKVGqhWLXEtNfTXNhY31D0R1B/avOnaeAcb0x9v4Z222kaEgj8uce7pV3k8aH9dSjBKo
 qAex8Bxm
 IiSFIPuxVJmz8SkiVnGq21yHwmM/ogCRMdis2BJgZSjZyfO6G1CZraxQtjeLJ6bBArKT0Z24izU0RWx6BBXOtW6QpEKblUbbaMe336Dgs6ui382QpGJV5R5VLJb9nAcqUedZ4Bod880y2nCu5SUX1ACP9Y1r1wrUOj4XT2WeBJ6TJSJLbdSQWnzNo8/QHw37xLxbwWYMhBap8tV83KEAhytCkFBqV63ou9jjKZezWXxGOuPDL9YDGbPqkmwLIs3b7stVVz93XoJkRH2v9AJS9PkhzPoWdTK7yaBIur9ck8nHyw/U/DoqJNdGoPHM5fHhpGuYFS90Ed0V/xHrEvVl0Ikp3CZLoM2DwzNKQmXU6XLj5Gi4QoBC1/ffoOwp1HJLdfB4cDXJ2RyR5b5Q1OBWAaHM0h4zpqBVSKQlUfPHA0PEt/Ku7OyI5GOdwrdb4hUFWlxHRnpgNYSye3HTjLpmEeYe8/gqJ+xiQfNqozzb79uZROZ3fBHeYUf9JRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 16, 2026, at 00:07, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> From: Josef Bacik <josef@toxicpanda.com>
>=20
> Since commit bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to =
private
> VMAs") the lock of a private hugetlb VMA that owns a reservation is =
the
> rw_sema of its resv_map.  The hugetlb_vma_*lock*() helpers find it =
through
> vma->vm_private_data, anew for every lock and every unlock.
>=20
> At the end of mremap() the old VMA has to let go of the resv_map, =
which
> now belongs to the new VMA: clear_vma_resv_huge_pages() stores NULL =
into
> vm_private_data.  mremap() holds mmap_lock for writing and has write
> locked the VMA, which keeps away everybody who comes through the mm.  =
It
> does not keep away those who find the VMA through the file.  For hole
> punch and truncation hugetlb_vmdelete_list() does
>=20
> hugetlb_vma_trylock_write(vma); locks resv_map->rw_sema
> unmap_hugepage_range(vma, ...);
> vm_private_data =3D NULL
> hugetlb_vma_unlock_write(vma); no resv_map: does nothing
>=20
> and the rw_sema stays write locked for ever:
>=20
>  WARNING: lock held when returning to user space!
>  mremap_punch/116 is leaving the kernel with locks still held!
>  locks held by mremap_punch/116: 1, last CPU#1:
>   #0: (&resv_map->rw_sema){+.+.}-{4:4}, at:
>                                       hugetlb_vmdelete_list+0x46/0x160
>=20
> The next fault in the new VMA sleeps in hugetlb_vma_lock_read(),
> uninterruptibly, and it holds its entry of =
hugetlb_fault_mutex_table[].
> That table is global, so a fault of any other process on a page that
> hashes to the same entry sleeps uninterruptibly as well.
>=20
> All those who take the lock of a private VMA without taking the =
mmap/vma
> lock are affected: rmap walks. So hold i_mmap_rwsem around the =
clearing
> of the resv_map.
>=20
> No change of behaviour, other than that mremap() of a hugetlb VMA =
takes
> i_mmap_rwsem once more.
>=20
> Original fix generated by an LLM and sent in private by Josef.
>=20
> Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private =
VMAs")
> Reported-by: Chris Mason <mason@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ david: avoid local variable, move and refine comment, description =
cleanups+simplifications ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


