Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E756606A33A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PBGMmnjh
Received: by kanga.kvack.org (Postfix)
	id 3A2A36B05B8; Thu,  5 Nov 2026 09:02:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354E36B05B9; Thu,  5 Nov 2026 09:02:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28FDD6B05BA; Thu,  5 Nov 2026 09:02:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 052FC6B05B8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:02:55 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E713BA0A4C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:54 +0000 (UTC)
X-FDA: 85401231468.25.18EEC42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5AD4D40014
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PBGMmnjh;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793887373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zn4FGyqcpXuDOI4yAR+P0rUnqH2M0CuU1TGwYX3rR+o=;
	b=AXd3+iY743jYnX9eUlrhP3F0k9spI3tDiyssSVQJn7hMVZ+WXO2fSsKNu1G1tQ/QDfcCLP
	eYxdm7XoVRW26kFFhDfmdxM7ho2I1SRcnNrctfCrOV+d8ryCIslpCtbKELfY3/87G+RPfK
	G9Wz1D++eJAhF/drZr+m3OUvPDZl8Wc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PBGMmnjh;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793887373;
	b=S3qGFXJhS2plN1HBTcCalkh2TiCkVgpWhIsPdGNiC1r0SLFek1jrbzKSh6cFUJ4Qt8wvfT
	7U1t+qSYrulZWXdJaDatRtaTICZwTtnOTiAMOJ6ekIQ8rmtlLLl0F7oIavy67Co5A9CSVt
	XFs9C92bQLe8QDoHLbx85Fenp6yjOlc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D2F9160A97;
	Thu,  5 Nov 2026 14:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A31E1F00919;
	Thu,  5 Nov 2026 14:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793887372;
	bh=Zn4FGyqcpXuDOI4yAR+P0rUnqH2M0CuU1TGwYX3rR+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PBGMmnjhDZ38hOgzwbJkh3sIHEnlSGL9uYp2wngdD276txrDfZ30SbBzuawEV1nnq
	 Rv0xUXVLJMiY178nhfx2khC2t9XI1dRXm6G5TlAoNS7YPerunjz7djsPlvLVZ0/C/k
	 26g4h1VjB/HlAFQV1zmssZ7NwOIYzsSSZb0yhkM1tOMG25faR5/ai3+x+Y/3RVOPDj
	 gdYrprathq27egizqYSvwVuvU1wkKGxUxFpKE7ymPIMPn6A9ky5MdawMzjXl4/mefd
	 pI0UAGhaO/oyhaxueCevuZ2zkOe8TTbhuwEgihtJKqK+ADu/Zx5bMOsVPAt+1bETdu
	 NZoZqyIdegmtQ==
Date: Thu, 5 Nov 2026 14:02:45 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yonghong Song <yonghong.song@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 4/5] mm: add and use mmap_read_lock[_killable]_nosteal()
 on contention
Message-ID: <auyMat25VPKwzSuL@gremlin>
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
 <20261103-khugepaged-latency-fix-v1-4-a07ab16ac860@kernel.org>
 <3a77219e-39e5-4e98-8f88-6f90bccf69f0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a77219e-39e5-4e98-8f88-6f90bccf69f0@kernel.org>
X-Stat-Signature: dtb6d63ukr8agyq1ggrrmn35etmr9rbz
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5AD4D40014
X-HE-Tag: 1793887373-798922
X-HE-Meta: U2FsdGVkX1+LBJuh71VuJsmJ3Dr7uRdyL2v+RF4kxwvrmMWpPShRKtn956P5UUGEOBMz6vn3QC6JKr1DEftv+i3SSSUHciCj8dnsemeeW77bjx0GBIZ2dU0d/JbteMWTa42ZijPngxWA/X6VfuhxFxKzDOR/6uJytqqkVxuRR9N/4zPxb3nBlQOAZw/3fNOdOvdBvOpMGa5TChkxgBX3I11xld4cdBjK7TuIL0BrtDSejips9DHgjDEZ6DeE6I6p4eQ3wzs3vpkTMHIGy5JIHu7BaoPJvCsMbAWVIQV5qWoKG5tg+WBx7nuR9r9T9WQDqMxO2InJ9yRCaNRbHpabbmqdmXNpAPE/KccdzIMQP3qlZpW1Z6KfHaDPbfD6dtQdEesGPKTss004sTM4APIg6sLGGBbd6NTwmZxg3/AqhC5udKcPVuY1GKobO/KJeU50yg1Zm22ctVFR39uEUCLuURwJuJsJPOc4yyLSBSPUfoqIYS9GbGnlkqJcWhnmTNDirdML+NB4CUVOMadOCEq4pmIsxKlhtQg/6VuLQyoxoZxopukIM7qhx76NPEhIMFYgPzmcd9ff7FDVx+Q6D+5CWvddK7pICOiislD8oXHCkkkFMP2IBBnF2pcYhvMQcGo5CYdzCDdoAWlubn1fnhWgn30uL8gbHLrqRapZkt+V+dTgD6Pc41fK8OA0rzBXhxF5IAROGEgUXdNueSKmBBTe9v8pv8whu0YjPvtWMArVSQ/Ub3+JuVrBRqllqGx0HkJj8bnrJWbKa8n3A3pY7vKwxgg98ZWJLgfznQZfUKMZ+w74Sg11iAdxQm83DCiYyauiq2TyzrCGa3ZxZUYpW94o9z6OQ55u6RZae+z1cPLZuehLNdRwZj3FYlu0bHPhgvvk6SrJ+J2UPZu3+bTJpH5NBK2KOXoISIeqxJymzDSBbnCeh6fOxPgnoKBRjYVxIWOrpQzVIfMKcGOW4Jq1BZr
 zWcpk3fA
 ZymCAV8fDbZ8DFXp+w/TPspfsk64ItVNOtakHBFYzsKJeEOOInKNjviEozqDg6XE9w4rUePB7fATYtpFDN6pb4XtMdM4Vr9Lv8K74Fh5dq5XN3IVP0IM0HYaSAR3Ez9302Vtd00mkDh6U+pZ6At4prUAg8954Q3cyi2lVIbQIT1vQ348op8vCbUaPruo35mxTUMTU50969CCtQ8OeZ8W/j2IXueKBjQ57VUm85/hnPs7XdTkVwQHds6X3PFdrRIsUVwE3PTBR4Z+eq9IUT1CicTNRJhPeJHafLCU2jlRob/NCd/Y1Dym/Vm7sIYSuWEI4d5wb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 11:16:23AM +0100, David Hildenbrand (Arm) wrote:
> On 11/3/26 09:27, Lorenzo Stoakes (ARM) wrote:
> > With down_read[_killable]_nosteal() available, it becomes possible to
> > release the mmap read lock in such a way that a queued write lock always
> > takes precedence.
> >
> > Expose this to mm through two new wrappers - mmap_read_lock_nosteal() and
> > mmap_read_lock_killable_nosteal().
> >
> > Make use of this in scenarios where the mmap read lock is dropped
> > explicitly for the purposes of relieving mmap_lock contention - the BPF
> > task VMA iterator, and lock_next_vma_under_mmap_lock(), which is where
> > /proc/$pid/smaps_rollup re-acquires the mmap lock after dropping it on
> > contention and falling back from per-VMA locking.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/mmap_lock.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
> >  kernel/bpf/task_iter.c    |  2 +-
>
>
> I'd appreciate an ack from BPF folks and a confirmation that I could take this
> through my tree :)

With the rwsem thing as a separate patch this patch will be dropped in any case,
which simplifies things :)

--
Cheers, Lorenzo

