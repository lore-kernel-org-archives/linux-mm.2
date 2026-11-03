Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43EED606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 04:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mkciFVIq
Received: by kanga.kvack.org (Postfix)
	id 21DA76B05B6; Mon,  2 Nov 2026 23:01:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0076B05B7; Mon,  2 Nov 2026 23:01:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E936B05B9; Mon,  2 Nov 2026 23:01:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E04936B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:01:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5611012031F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:01:53 +0000 (UTC)
X-FDA: 85392459306.10.DC85D1E
Received: from mta0.migadu.com (out-217.mta0.migadu.com [91.218.175.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id 03505C0004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:01:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mkciFVIq;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.217 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793678511;
	b=Kb6+it64G4OmpQLkUyuK7lOIIie3CxSBBwMarKADxuDnvMmVkHdE/emjr0iXPqUDYivnve
	su4771wORqphcGg79T+XTPSt8vI0MFDlacYiWTwhza33+BB/oTPENdl1eptjS+5vjfnWnt
	cGvB3D+SZkxRIpjtdr9V4gyHfnds5t4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mkciFVIq;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.217 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793678511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lDb7VF7t9vCGYbcoBtIdF6dRw3MWvJEbXZ5PMZISlw8=;
	b=3tDR/cCtUGS+hXFUzj6+Ixjf/7dgdEZ8iK8p5dKHjEUTFZz+Q2+jqoohiSOTtzsSExGWv0
	zAuNKGjFcXV0rUmILEcsCZHoic7QBW3aAaClPrUeJXTEeK5Z20bzyTue0X67PG8CvFqrf+
	PAJOxriXDPdMbXKPdw7cTJ+TkuADBR0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CKEHs2xNjn3vFUKXk/OC1dgxFsocWFipvyVq/CmrhPw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793678508; v=1; x=1794283308;
 b=mkciFVIqfGgD8r4GUzUx/IMdlICBgx1UnRaGabM3UodtroGDLhWeiFlH/0shEeRCZGP5IB92
 06thgCYP1xhGDvEoArNEuo+ZSvUlgpHl6Lnk9yZfhdVp/+l5+caYDg1VrFQ9lN820ojB4KYhvkg
 gcPXLyqFh4T7yntjinwdzxZY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 54dd4c98615b8fc8;
	Tue, 03 Nov 2026 04:01:48 +0000
X-Mizu-Trace-ID: 54dd4c98615b8fc8
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] riscv: mm: Add KASAN shadow mapping to flush_cache_vmap()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261102134422.610837-1-alitariq45892@gmail.com>
Date: Tue, 3 Nov 2026 12:01:27 +0800
Cc: Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 linux-riscv@lists.infradead.org,
 Alexandre Ghiti <alex@ghiti.fr>,
 Vivian Wang <wangruikang@iscas.ac.cn>,
 Yunhui Cui <cuiyunhui@bytedance.com>,
 Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 kasan-dev@googlegroups.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <63411FA9-C16A-4E40-8C3C-13C58FB844A0@linux.dev>
References: <20261102134422.610837-1-alitariq45892@gmail.com>
To: Ali Tariq <alitariq45892@gmail.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 03505C0004
X-Stat-Signature: ptotezzzfu1c5hcmad5c1jen65iazkmj
X-Rspam-User: 
X-HE-Tag: 1793678510-268355
X-HE-Meta: U2FsdGVkX1+6ksZAXTGkx+sXoo4q4pXZjwGRCwmNsHtladKTCCrq+BlVtVKhXc6vvh/L2U64xw26WXQtVsGW+PmhEpccHJ6ClQ1gEiXJG54zi3x5sWfJFIIUixzLEOXKrOeJBq/sTlGFbdCfUnV+Q/rix2vnOwW+L/KuTOEcVa0/mKrcK1d7ExrTwf8KB1UGp1A01uVXxLz8lGT9IVzPHVR99gwsdwS9961uXFS1iUToYe2NuhXCbCDbU0fROwN3hXFRvg/ukKlc7U00fXGgSQ9tLl9iO4X9BPtgGyqf8/NlAChE0glmHtrbPFmbuj5suX9DLgehhHYjMnDlz3/wbj7Vr79SrVgaNmAYT3dmiT0lyXi8esyG9YbAoago7HTx+mX1hoU4oPU77VIB+QSrxY2XgV+cb+/xcKpqaNzWMkygBRHy73edf/lPslWE6e8CZVeZc2ahAJ60rBA/fj+TgY/rI4sDzVjpqfRn0dxKC34hLb0HlP9gQuNOKg8tua3uAFWIrJ2pkv25LsG2nSqTGrjdreOMFh+ZbrEMp1wMwSwpIdcxFd2/3SyVzMcLwXFnhG+TTOzxbSibXkFjwEOGHVXAzPjXXU6oCpqCZFbZ///X8AHViNipZyF7fdZKlaPBHXEOXV9qhlKXjcukaZMuPVybXU90yKHypveHcoX/IrsU21ZfP81jOUwciqClell93MMoXK3azkiTmkxl3B30a9D9lYcGJ7EKqlD0ohwfya5AvsDczTOSbg7loE5O8dzmaj64fNdT8YJSyCzLN94vhvoO409uhhOmO0QmO8hqVgH4AcpFMJLVqNWstFDuB1oxCqRZXk1uK2F96v16kvAXJUsr2LfVIrOwSJqD0FNKX4Ja8JywHTy6PWaU5cYBu3iu2P/kqxrJDyN6e4O2e/yM+KDjqeKrjHFnpuXv7tHAoWpVMSk2JB60K0SIPAbiJUEqpyTsa3tfoEnlRoqe+jY
 K7d90h3M
 0dFcCzhYecQVrtpxD0OJc6Mtvy+TU1u5C2WMpFDi/wyazvexolxKzrFPQJoALwAiBGamDFaIkzW3EuDa7UrDgtwy7waUGGxTU21Gqrynb8ScsDnAzM6iQZ+ay12AE96joY0AKRbtT+FvfY+je5UWHPNjJYO2OXIHeP+1jrmH6wKCsNkmnHn5rRF2LJYhGGPp/4hc6A8sCPOoR6sRIG/ed8fb3AUw/0hAdps6aAq+yDrDbugUBGbTrHIxKWtp07pw/AWA/hmjhnKBpNAjdFi5SBLH/8G/6FzbDE4H2STYOqmyiv9m3vz2+R9Ev4Kc4QrD2o4hlHIWSzySYIRacqiEI+dazNA1YMbrOKPQ4GLP53I91NxK39JzESDdncQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 2, 2026, at 21:44, Ali Tariq <alitariq45892@gmail.com> wrote:
>=20
> flush_cache_vmap() sets a per-CPU flag, and a kernel page fault
> that finds the flag set gets an sfence.vma and a retry.
> flush_cache_vmap() only sets the flag for vmalloc, module and vmemmap
> ranges. kasan_populate_vmalloc() maps new shadow pages and calls
> flush_cache_vmap() on the shadow range, so no flag gets set.
> For vmap()-style areas, kasan_unpoison_vmalloc() writes
> the new shadow right away. If the CPU hasn=E2=80=99t seen the new =
entry yet,
> the store faults, and since there is no flag set, the kernel crashes.
>=20
> [    0.675216] Unable to handle kernel paging request at virtual =
address fffffff7c009a000
> Current swapper/0 pgtable: 4K pagesize, 39-bit VAs, =
pgdp=3D0x0000000004504000
> [fffffff7c009a000] pgd=3D000000009ff6e001, p4d=3D000000009ff6e001, =
pud=3D000000009ff6e001, pmd=3D00000000400e7401, pte=3D00000000403cb0e7
> status: 0000000200000120 badaddr: fffffff7c009a000 cause: =
000000000000000f
> __memset+0x60/0xfe
> kasan_unpoison+0x26/0x4e
> __kasan_unpoison_vmalloc+0x20/0x2e
> __get_vm_area_node+0x1c6/0x276
> get_vm_area_caller+0x52/0x84
> vmap+0xf0/0x264
> dma_common_contiguous_remap+0xa0/0xd0
> atomic_pool_expand+0xb6/0x310
> __dma_atomic_pool_init.isra.0+0xf6/0x1c0
> dma_atomic_pool_init+0xf6/0x1aa
> do_one_initcall+0x134/0x928
> kernel_init_freeable+0x532/0x60a
> kernel_init+0x28/0x162
> ret_from_fork_kernel+0x82/0x94c
> ret_from_fork_kernel_asm+0x16/0x18
>=20
> The PTE is valid, so the mapping was in place when the CPU faulted.
>=20
> Tested on Orange Pi RV2: without this patch 2 of 30 boots crashed,
> with it 50 of 50 booted.
>=20
> Add the KASAN shadow region to the ranges for which flush_cache_vmap()
> calls mark_new_valid_map(), as commit 4edd70ee6a7d =
("mm/sparse-vmemmap:
> flush_cache_vmap() after hotplugging vmemmap") did for vmemmap.
>=20
> Fixes: 503638e0babf ("riscv: Stop emitting preventive sfence.vma for =
new vmalloc mappings")
> Signed-off-by: Ali Tariq <alitariq45892@gmail.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


