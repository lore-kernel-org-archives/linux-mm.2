Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E93BECD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F42D6B008A; Wed, 13 May 2026 22:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CACC6B008C; Wed, 13 May 2026 22:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 508BF6B0092; Wed, 13 May 2026 22:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 41A566B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:35:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E47AA1A0221
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:35:51 +0000 (UTC)
X-FDA: 84764460102.08.05EEBC2
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id ED2DAC0004
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:35:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G+ZKSnnC;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778726150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4R4J3RwmjA53m4R5RtoEscHz/YnvUKFxIVx8Fa4X0Y=;
	b=nW0TcUItA/Cge11nxpL49S15OfY/4L5urgrE2kAZheYBFM6pqjs0GWJCZpYFZxl7xaPtLe
	JhoLQWeN+2dp89SAZ6KorHHeuN2tZkoxAItk6zTikZDxVhGCMaO/mV2G69Gp1rlAPSwTKv
	PcYjWSS5Y96fmXhE35t8AAQC16liF/k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G+ZKSnnC;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778726150; a=rsa-sha256;
	cv=none;
	b=WbaJ0b6zB39XY1KfbTCC9146B+yR/0Omr+EBww7U1C29ac84fuGAuP5Qgrji0r5qLL4+Xj
	lIhuyVwgBMThO39ZkuFGHw4wDti30h53x5+76dkzcESogSEmv5f8BY/NogWJJOq+FRRX2E
	q0ceVYrjrxjzEYQmr9IPZsk9Sw5ALtk=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778726147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L4R4J3RwmjA53m4R5RtoEscHz/YnvUKFxIVx8Fa4X0Y=;
	b=G+ZKSnnCixAkusAvNx6AviFC3l0Yw71F5NKxYrgFc01CFGNA8UCorUPtvcKSg93EZexN6o
	LY/S4mSvSVORzskYnSqY3BqBXcs53W74fBdTaaxkCqDTFWUT87NxnO7gEnFac81DF2uyN/
	sbLMEsPwxcBoPKg6XFBJX2woeDspPkc=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 00/69] mm: Generalize HVO for HugeTLB and device DAX
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260513104640.b0f02b844c57f92bc954878e@linux-foundation.org>
Date: Thu, 14 May 2026 10:34:56 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Ackerley Tng <ackerleytng@google.com>,
 Frank van der Linden <fvdl@google.com>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <72F6690C-D94B-4398-87C7-4611A96C50AC@linux.dev>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513104640.b0f02b844c57f92bc954878e@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: ED2DAC0004
X-Rspamd-Server: rspam06
X-Stat-Signature: d39x3q5qbj5hp4g3rapzuum3no5s5eoa
X-HE-Tag: 1778726149-186218
X-HE-Meta: U2FsdGVkX18z04Qi2s/XV3pEGsbVxCmX6bpKvPJt7UMvqyLODGusjEHp3V93w7YrReL4whtp70OkdgBmJ8HkVu/8jQJEitlj5NIJ/qDTu2KseQlaNUyO/3gzbiYHZWrYQzEMxtaOTcekDWAmH09TOB5sDbsgfJjSaTiJ4BY6/90U/1XQhzOQbNzTjc2Z1AXYIysnvTYMaju8R61N0ogA2Wybuh9qKArhCcNkHvFfs4YHjRO6gIO6ByjOFHZLj2EdHFyyoVSvSNqCCUk2esobYoBILAy+94+piVfRCaAD9z6YSBQRNJaHuElTmcxsytG/nGLErJcsJJTa5i7wja2RSyENVLoEuBsde7yMU1PhR/2Xa3P7esbJYZr06vq3FePIZUbkq1WzL4yY7rwkTF/HZ2JCmupf5uyhVYxantiTvGXE+V/XBgXHj40kNBPb14tlQ/VPNJXA8knnoI6eZsgwba8O+0BFq4VU+tFg2Yre/vDyOKC4oQDjwC7iCjOeNMHTjccKpm6sUOoW41LO6ileKChGNwkqxbbK1vjYdDlh7DWTCOluWvfYQbiSkVuLbW6sjt7bTEs85C2ZwVqii6O9/UP6SuTZo/mrNeH/5ghUTZmzqIpvYfjGGmHAjVYxAMdYufcjozjFi9o+gTbngoRIbD8hji41DIjgG18Un0aswogO4ZgziNx/vXKHaTV9pc1dr5855gLY7PqTACZr/J952C2h5aDkbSg74A9xRP7wQzYq+CaOBe4PlHqlJSLcp00s6rPPQnRErBfc3LMt9qgm35qca5oe8tNfQDB1W1OUCpg6+4AMUzpE6uPEbHaxPpuczLhrdRsd+IkZ8wvniQAI8gWMT/BYF0NvGZJwsB8ohgfNIFKGeJGksJIUmL6GYWLyFUU4anGqxUTWVySTckwBPizjPPpGUW7aCptVgMSIGA1WcF6DXqXPMYDJ0M6jbbnkED0HkmBV/T/XBxBdgPW
 7fbYe3CE
 VTRUVcRsjvvashRikFEanBJvSUslucLlGSzeERFNZoeyTitLsxvz7CGlllC2FEz/HIjCI1knLcMwv2Y1LaI9xRO+wGhl+f/deP38U+u1vOC/JtCwuujSKIrKPhA1F5c/WHRDOM+nGfFiLbMZCY43ziMiQux4339v4EqeOBfmFeZc5ajMsdyVxphdMIzbb+lRAT/QRA/Sppu9kM4GUoYbIu9PQigHg+SbXIDLLLvhBwZ3HqxRO8sfZo8LdtzP9Tnc7gecUq3QQqLqHHEzvDXco2Uh/cwEAZuMhkj/02C89B3HH9K9a2vbTsX2a2+uN+IzuukV6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 14, 2026, at 01:46, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Wed, 13 May 2026 21:04:28 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>=20
>> In this series, HVO is redefined as Hugepage Vmemmap Optimization: a
>> general vmemmap optimization model for large hugepage-backed =
mappings,
>> rather than a HugeTLB-only implementation detail.
>>=20
>> The existing code grew around the original HugeTLB-specific HVO path,
>> while device DAX developed similar but separate vmemmap optimization
>> handling. As a result, the current implementation carries duplicated
>> logic, boot-time special cases, and subsystem-specific interfaces =
around
>> what is fundamentally the same sparse-vmemmap optimization.
>>=20
>> This series generalizes that optimization into a common framework =
used
>> by both HugeTLB and device DAX.
>>=20
>> The first few patches include some minor bug fixes found during =
AI-aided
>> review of the current code. These fixes are not the main goal of the
>> series, but the later refactoring and unification work depends on =
them,
>> so they are included here as preparatory changes.
>>=20
>> The series then reworks the relevant early boot and sparse
>> initialization paths, introduces a generic section-based =
sparse-vmemmap
>> optimization infrastructure, switches HugeTLB and device DAX over to =
the
>> shared implementation, and removes the old special-case code.
>>=20
>> ...
>>=20
>> 46 files changed, 743 insertions(+), 1812 deletions(-)
>=20
> Gulp.

Sorry for a so big series to refactor lots of things.

>=20
> I think the first 15ish patches (little fixes and cleanups and
> refactorings) are ready to go in immediately?

Overall, I believe the first 12 patches (excluding the bugfixes)
have already been reviewed by Mike and are theoretically ready
to be merged.

>=20
> Perhaps you could prepare such things as a separate series.  Or tell =
me
> which ones are suitable and I'll fudge up a [0/N]?

I'd prefer to group the first 19 patches into a single series (titled
"Refactor bootmem gigantic hugepage allocation"). Therefore, I
suggest waiting for feedback from other maintainers/reviewers;
once patches 13-19 pass review, I will send them out as a standalone
series.

Muchun,
Thanks.



