Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD93606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ajjRSYjH
Received: by kanga.kvack.org (Postfix)
	id 0AFC56B06D3; Tue, 27 Oct 2026 09:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0617A6B06E3; Tue, 27 Oct 2026 09:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9486B06F4; Tue, 27 Oct 2026 09:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF3556B06D3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:14:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EA4AA870C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:14:28 +0000 (UTC)
X-FDA: 85368450216.19.3E4FEC7
Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf31.hostedemail.com (Postfix) with ESMTP id A58302000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:14:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ajjRSYjH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcOL6ipNcctSomEyqgwFYm+J+StqaPe/l3cry1c9MJ0=;
	b=fpD/2H8lpTVmgQhGtLJx3aGWROM7zOTnpBcxcnLa3cORa+TfQrPL2L/5VrCtEVmXSvESaG
	30Kgy4IxVYHevMOPuF4F5gipgIPJs00Pi+cHiQNRC9NxUI+FLyCRikMtvYyZrif6ajuGu6
	6x3fEhhr9yGwXXHSei/FtCR+hpE6FPA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ajjRSYjH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106866;
	b=aLC4EnHRoYXUGzCZIDhXIolbDxagHuaF12n6pDIe3asxWEBrf7+u8hVkaHN0e/jchUPl4u
	rTQgHrGW7HrDA7tLG9Uxxkv4wkknsEFGqhLOwEmQHQYltM5rGTyTG7X7uEfELwwWSm4naD
	Rsg4Pm1KnlQfsfamFLj1mHWZtqUTpys=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m3gTecYYwq2jZUjUle1w7O+ULuPN4Q/r80sxuGVnYTA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793106864; v=1; x=1793711664;
 b=ajjRSYjHFYuNa/S1FAovfJgvU9eBuzz0cefMPjG3K5sLx+1eCR6qnER3QIEnWCDqS1CKx99k
 reeKOqTgSWJDgBMTs9yAQu1VwaENazBo9/Te9qKh6T8ezL3THGkbiwnTOa8owwaqTKpduTvZ3kO
 xmKoEt6jNwmhfg0YcmtOCC/Y=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 1793c71c60f3bc72;
	Tue, 27 Oct 2026 13:14:23 +0000
X-Mizu-Trace-ID: 1793c71c60f3bc72
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <auCZFckDfBMrlfxV@thinkstation>
Date: Tue, 27 Oct 2026 21:13:58 +0800
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <070DDE5C-2183-4A8B-AC2D-891CAE15E581@linux.dev>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-14-kas@kernel.org>
 <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
 <at_f43oDv73y-t7O@thinkstation>
 <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
 <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
 <auCZFckDfBMrlfxV@thinkstation>
To: Kiryl Shutsemau <kas@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A58302000B
X-Stat-Signature: ntqkqoc5q4yb4dkpxx89a5m9yui96irw
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793106866-44205
X-HE-Meta: U2FsdGVkX1/QZb2DhJDCszuDMXscr7Csv0nCRDYt6HGbuRVqFyBcr2AXiEMHI+Y3ouzn+xgCQRrZAKu0YBP0EDro3dTJcTdGC/G0Sm+VSgGMt5O173+WhWQxq7fFUpsAURfINXwJu1nUWwX4sMC2hOP/Twv2Jjaz1g4J0F7ni3pbCAgbGLO86HUwe6JxeyYdGdsZJw4nUWFiPLUrtUU5bcrRglure4os1ST9R/e92DUf32xWGHeYUn2KvoNzoKhOc2BqyXPCwUIV1r5kjdNPWRhhL1aMdw0bzCpSxiVoWHzrYg5hID70onBMwmwLs0F6jne1Wx1bzXmyabAn1MNwLvZ52qCPC9jGK/DOmszkFLWzwVgn9owxuQWLmlVP6fw7ZMLw41q7rw+VoO27FInmVwTCZl3eP+oluIhcFwJuj+BrQde39qKgtDz2sr2oFl7DB2d0Za6g9iHpBOCeW4wyugsq7h7ZnCRRxD2ejg4kLxr6HAQJZbBJ5h+lb3ur9ozl1R19yahpNthloCXcCiiEhHRUfRAWcap5p8QOgaroG1FTm9LQ8sfzkNdeHuFA37NF/R5tcN/1mBWKD7LHUEqTtLbAnQXVk+rcXwKjRVkpTODnfBYnDfV/gJ0p3vh6hNX6bjxviZamHIYfPuAVsZP00KsUCy8U75x03MN1sAlV/jq8M7djLt5YkFPfF8T5QRlzoT91sHZlSnQxf1QJjOcngl9iyTaIoMSs9Luwtc7juhC9gsSk59gDhmP7yzCXM57CBujbUhTbnVZcdtoeG4MV/1PZK/rdMCQDFCN9p+/iJt2+jlAaPgkl88i9tgljGmPuT0J4yiYx6Ek5AgOZdGovTZYJKi5a0SP+MnM1z1iDaeIYAP0NzGIfOryZBmHs1aLQL38xdfiuLH4gPpREh72WZqZfHPGzxbu3zFEqkrmH93CUFKa1KpTJYVOgyszOmWeHpvkLc/a8vMYeziZzh12
 9iK4Ha4x
 eoh5e8mZCWAjReYOvDEeYDfWOTf0wy3XGuDyzicK4mzsiq+Ue9C5+blhJ/4bEA5UixkvuDKqVW/Ew0r78YUxjftH2lMUsg+tEdhYsw2bZblCQqid7d3oMZy5w9+A9ZNga5GcfQhL91xN0LCB6Yhi+NLjiMdrYk4tgCtTqqqx45qL9XqTKS+jF0m6I8UVosK7ufmjo5IJAbRyVZw7/PCOQFHMU6ygddzHCeNQHLTEyStU9hSyuFndHGU2uvu4AH85QMRNykTYEtMx/hlz01HVY67AQkAx+mahe7Z2g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 27, 2026, at 20:31, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> On Tue, Oct 27, 2026 at 01:05:58PM +0100, David Hildenbrand (Arm) =
wrote:
>>> Writing this, I just realized that we have another option -- map the
>>> shared tail page writable. A failing LOCK CMPXCHG writes back the =
value
>>> it read, and the get never changes a zero refcount, so the race =
becomes
>>> harmless. The cost is the protection: the page is shared by every
>>> hugetlb folio of that order in the zone, so a stray write to any =
tail
>>> silently corrupts all of them instead of oopsing.
>>=20
>> Right. Without HVO we would just corrupt pages in the single folio =
(which is
>> also not nice).
>>=20
>> I'm also questioning whether we need this RO protection all the time =
active.
>=20
> What do you have in mind? RO only under a debug option, or switching =
the
> tail page to RO some time after the remap?

I don't think enabling RO only on debug kernels is a good choice.

Within ByteDance, we once successfully caught memory failures using RO =
(because
we backported HVO, but some missing commits in memory failure caused =
write
operations on tail pages to persist). These operations triggered invalid =
writes
to shared tail pages.

Under the old HVO schema, this invalid write only corrupted one folio, =
but under
the new schema, it corrupts all HVOed folios. Therefore, I personally =
believe
that for the new schema, the value of RO is even greater.

Thanks,
Muchun

>=20
> If it is the delay, a grace period alone does not close the race. We
> would need rcu_read_lock() back around the get, and then it is the old
> scheme with the wait taken off the allocation path.
>=20
> --=20
>  Kiryl Shutsemau / Kirill A. Shutemov


