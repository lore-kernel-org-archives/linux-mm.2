Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF1CC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 02:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20786B0088; Tue, 11 Aug 2026 22:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD19C6B0093; Tue, 11 Aug 2026 22:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E7066B0095; Tue, 11 Aug 2026 22:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 775006B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 22:03:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED87C402F8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:03:15 +0000 (UTC)
X-FDA: 85090969950.17.8D5A924
Received: from mta0.migadu.com (out-116.mta0.migadu.com [91.218.175.116])
	by imf30.hostedemail.com (Postfix) with ESMTP id BD60480005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:03:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EEXudKNo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.116 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786500194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4PfHnmlIfOJPa7YCWK5rmQm/4T5A6xCvVno1eH/iTYI=;
	b=GuxsQzDF1htIRKBNUtv1aRlghEfKwlLrqbln7e5wFg5t02RF5FtI0tGkdgFREzogaQy+YK
	YmFTmtdubjjSFJJrg2ibtES+xozjP4FZ3hg1g8E6KGg+xfvufptruiJMykH/LiejXCeS9T
	iMy6wByIyacIhVRwpSLM/zIkONyhpUI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EEXudKNo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.116 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786500194;
	b=xOH9ZkyXCUCwuPSYdwzmH6Mhcx49PSmeF7K0UdBGYpNB3WNuH0zTCZUmlCBKxj3dNPr+41
	DqtPl/Ih+HIteUIQe4UWsllvXn2gwgT1bYvRdjiGZiJeEJstnKfl60bP9jXfsMqlpubSDR
	xlSTL+/M5633KOKwhZC3tJCtUvOtapk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WXz8poCGQHTsMTeMQdLmtjs1wHxY8Y3zIy5+1lnV7d0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786500192; v=1; x=1787104992;
 b=EEXudKNoiCplueNcx5lw4SaxIp/WMxrSDLYcPq4HZzuDAT2Fc/utR+JD+COg0s7FAhdtWyAH
 sJcgJ54ahTx1d76Uyj4VtbO/ej7P4fwxGXOJZDNtRK4ThbwQkYsQkdAp79pV3BzqCQxUZuuYfb9
 I4dQdlqhanY5Gt6l7lkraFF8=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (183.241.155.34)
	by mta11.migadu.com with ESMTPS id 51bb0a907f71a2d6;
	Wed, 12 Aug 2026 02:03:12 +0000
X-Migadu-Scanner: mta11.migadu.com
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v7] mm/hugetlb_cma: Fix null nodemask dereference in
 hugetlb_cma_alloc_frozen_folio
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260811185531.b8e3fb91c51713b2f29bc1f0@linux-foundation.org>
Date: Wed, 12 Aug 2026 10:02:45 +0800
Cc: Sourav Panda <souravpanda@google.com>,
 osalvador@suse.de,
 usama.arif@linux.dev,
 shakeel.butt@linux.dev,
 wangkefeng.wang@huawei.com,
 anshuman.khandual@arm.com,
 david@kernel.org,
 surenb@google.com,
 fvdl@google.com,
 gthelen@google.com,
 hannes@cmpxchg.org,
 riel@surriel.com,
 sj@kernel.org,
 vbabka@suse.cz,
 mhocko@suse.com,
 bjackman@google.com,
 zi.yan@sent.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D6E48175-9D38-49E3-ABEC-6283F00CE399@linux.dev>
References: <20260811052909.475635-1-souravpanda@google.com>
 <20260811185531.b8e3fb91c51713b2f29bc1f0@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspamd-Queue-Id: BD60480005
X-Stat-Signature: 1r3hddq1jzxkxueogy7rtdq4th9xobp6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786500193-34421
X-HE-Meta: U2FsdGVkX1/qYHmL+WyvFvys4H2YpfQ9MJfggvthEXGNGmwfrwB6jZxCca7gl79YTq+tq9cn7vfOBUswhnyWejCo4Zwk0PjkJ/9j6jcqVhcfbhTySfboPeE/QIabtCsvHm+a1++rxjdQheCEgX74/3ofUvm1DUFY/po/eSkEq4WDGjhjYlj8G+Ttxa5a9jtTwf4nxebxZjAHX262A4sztGGUnPvCFG4AP/27kU4bxACeI1OM+UCJupofflzilIZroXIvIhCqVCbyBx2GUTlai6NzUfv/bLKnEMR6ent3m+FBi4/YNNcN8lAANgQqbAhbUVEjTi+1St1GbTOEhcePSQAyO1XtB8OeNua8hiSdCUSHBwbzZ4t7KM2tTvjJgErWmhorEpEy4/ncO1ac203dJ7M7c7+CL7ZuGrcuhHJUw7Nd+5Y9XeLRuluo8qeflJ/qPlX7kyCWhFobMA9zHwXRh5KXl8SqSY7ZD+PJR0Ih9OIeKYXg2+tGeNnsNVOnt5HORHMU7koUSJjKPne+s8q5PZvx3LS7rUaReb3m0EHcKl7oxG9ic83bS2MMV7XCaUH4wPseZzxwNGw+i5wYcFdsugHiMa9gjYxQzBocayM9ArirGFHEi7SETsnUUfOYl0gbLVis5urkrOhM/6cCX07R2aK9BOdkKRDJlpLXuMylnXtYqJM2A9uYnSorH/5uo0ND0Rufca/IYL+BF41Hx/Bg9xSXQk7xMbwEwkD0Qc45UDQxBu1JyRfMiIC+ddIfPM0+wAuVBb7qKpfhoo+lc10sE8c6R5dvUIG6q8dw7/WR4nkG27cXY8NH3O4cEVWzdizCtuyTYXrtiwW4GVWhU96ItUaMxP+RGWFypyqievTQV5H4ZlgB51Ra1GqoN/F20qkgWzIdYbLCkEgaD9AHvsIQNh3MfoBju0sxf2yKOAbCWXTCCudnw+8FSdisc9LG/jy5eJCoETfeLgrNLPb645f
 SgbpDTrG
 tnq7PSddnKzNPU4YHLP1jPmtpMItHbrsBN1PsFJmd+Mkb6krWdjaAvCYJ6wXTr3uq1FDBv0uYrv1zEFkU2Ngr3UBtY6I4k3is9buBjjLlpyWCLqsIoax1EgjQ1t8xE/UMLU0h4k1xQJPNwRjfsRLKyU1daygBBu16LQjGYSNtiLHjEkCiJvXC7uCNvoL3D8TokupbLXdOIR4NLYrqjHPO25ZoDFZKoqGyepe8Kzy5dYAvSuBdbBpn0HU/MGUFZwAd+CDwzadFsOPV7ddJzAzUlJ39ThtebnYHi4MnQ4kMMWgId6A1RtRm0iEYw+RRUAJ85In0N5y7fOfUYneOWb1Ip/dqMrtA4K6VYaVadBFS2tClMxXAafxMSSUuz2tJ12473fP2Ech/9XZKt1byGPhUN30fHoJJrgM7dPkMO3YpG2vPkZBE9keWiUA/Xu8hae2Ltz7Vt6OVjMJqw80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 12, 2026, at 09:55, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Tue, 11 Aug 2026 05:29:09 +0000 Sourav Panda =
<souravpanda@google.com> wrote:
>=20
>> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
>> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
>> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
>> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
>> alloc_gigantic_frozen_folio().
>>=20
>> Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
>> allocation on hugetlb_cma[nid] without verifying if nid is included =
in
>> the caller's nodemask. Adding a node_isset(nid, *nodemask) check =
ensures
>> the initial preferred node allocation honors the memory policy / =
nodemask.
>>=20
>> However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask =
in
>> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
>> leading to a null pointer dereference kernel panic when nodemask is =
NULL.
>>=20
>> Fix this by checking if nodemask is NULL in
>> hugetlb_cma_alloc_frozen_folio() and defaulting it to
>> cpuset_current_mems_allowed. Enclose the allocation attempts within
>> the cpuset seqcount retry loop so that if the cpuset changes =
concurrently
>> during allocation, the attempts are retried using the updated =
nodemask.
>> This ensures that the initial node check and fallback loop safely =
honor
>> the task's cpuset without violating cpuset constraints or causing =
NULL
>> pointer dereferences or unexpected allocation failures.
>>=20
>> =46rom a userspace perspective, this bug allows an unprivileged user =
to
>> crash the kernel (trigger a panic) by requesting a gigantic hugepage
>> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
>> configured on a subset of NUMA nodes.
>=20
> Thanks.  Sashio might have found another thing with =
MPOL_PREFERRED_MANY
> and CMA:
>=20
> =
https://sashiko.dev/#/patchset/20260811052909.475635-1-souravpanda@google.=
com

Yes, we already noticed that issue in the previous version. However, I =
believe
this should be addressed as a separate patch within =
alloc_contig_frozen_pages
itself, rather than in the HugeTLB code, since this is a low-level =
memory
allocation interface that should not be tied solely to HugeTLB usage.

Muchun,
Thanks.

>=20
>=20
>=20
> We're days away from 7.2 and I do dislike sending hotfixes upstream at
> such a late stage.  I expect I'll upstream this and a few other
> hotfixes after 7.2 is released.  It'll all end up in the same place.
>=20
> I would still upstream hotfixes which address added-in-this-cycle =
bugs,
> but there aren't any of those at present.



