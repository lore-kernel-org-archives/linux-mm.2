Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A27FEEF55
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 21:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71786B0088; Tue,  7 Apr 2026 17:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB4F6B0089; Tue,  7 Apr 2026 17:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2C46B008A; Tue,  7 Apr 2026 17:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3AC56B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:43:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34F3F1B88E9
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:43:05 +0000 (UTC)
X-FDA: 84633085530.30.8639597
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 881351C0007
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:43:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D26D8gOg;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775598183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iLqfXsQT+5ZRmm6D6bg+MxhQkz+CgjvQnqxf7aaBrxQ=;
	b=fj1pJJ0e4wlcekTi30FRuOej+F5HK/NIjMuzrHxIjfNQhS1ec+UzR3IHo8T75565FxHpVp
	I+XiOSD88KFkxs+VHdOjkQcyiIzYrspofbPUrgoS2eNT4Jo7Gi88iLfg2wUugOiyFqFQvc
	Gv75PSxuedAtr0kQFVgAxvlznuBlNqE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775598183; a=rsa-sha256;
	cv=none;
	b=2jD19Mv9dBEsHuH3KapTjY2nglxj2HG50himmv+R5XqOepRKU13wnJYI8H62ohlHbmTrpJ
	1TXcehyqohEs1tpgqPIe9lR/dkxfQdR0mgZIJGOKier4frgFI4nrXxeMtze7FxBIiieYPr
	jWIun9FzpRC08FD7DpJ2yeCr+hz0JVA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D26D8gOg;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B9136013F;
	Tue,  7 Apr 2026 21:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8C8C19421;
	Tue,  7 Apr 2026 21:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775598182;
	bh=Jzj9VL/ne4HAC8Uu0kWPWPs9BChKAOI+YBOIl8kJd7A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=D26D8gOgBYtI9taH8eQ4kzyi2d8YxkZt8dSUwKgAIsKyai5Pvavyf/lTEVNg0+rSx
	 qXAiAuDFxir6oTPrOR+KcHn93C4TOIONsOi6a9mfJaFjrtAXVoEHVVpTDpDfwaCinp
	 zB6ialuk5Pk2obvLcr9QSOS73hKuFBvypa2DqZMU=
Date: Tue, 7 Apr 2026 14:42:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Message-Id: <20260407144259.011a26666eff9c96d74e39a2@linux-foundation.org>
In-Reply-To: <adTCJ8NQHGNMqR1d@lucifer>
References: <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
	<0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
	<fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
	<26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
	<440d6b8a-d299-43eb-83b5-6625f9468e5e@lucifer.local>
	<37132e09-9c03-4afc-bc73-4bca416c5343@kernel.org>
	<9d5a4703-a15e-4be6-926b-af2d98db40c0@kernel.org>
	<CAA1CXcCYLGQBy9nT-MSTPVK=XgWWtD6Af-QiA_6pXtM_2pybPg@mail.gmail.com>
	<87b83f7b-f0b1-4184-93a0-3b4b574c813b@lucifer.local>
	<20260401133145.90b094a7b87bdceb0013b5af@linux-foundation.org>
	<adTCJ8NQHGNMqR1d@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 881351C0007
X-Stat-Signature: mbc9ozj5kx1q319qfkfm4kwzsetfwu6s
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775598183-491284
X-HE-Meta: U2FsdGVkX1+Tz3LfYOdrPg+isMSLOmzLpj95igCnDBw6Q6TEsgI3fWsZVxqcUz4653lTOwg0hQNxnO0RhU51iaSy/7a9TvjuDvKNn12LGuGO3z/j8zncvqJEgWw0QyuKvGQwOjKRuyOSCGOcVkeT5vTfe2eqSDlJhZtgyNXbIVitGA+qcM6/0LgNs+ITuhd4RtnVIOv1m3VtmIvu9ov1Awe4jvkuKYvv4DGB83JnxUwEihSVFwS5uu5nCAr3aPWvyAZwkPbOsfjOjcMYfDqwKqBo2QHnlG570M9hYnQSVLYH30cdzm8Jz/Lud8u3YxKYRXOlFC9IWrwBf1HSVKVRqwK666NcMbpQoIPqfhwVh0oTvn1oQzEa7YqAFx0BNH6yGFECXIbEWFbm5SEV5q+SQx2I8va78pBdKsRszVZI1or/OWmnAOT7f89XNv8zIK+4X5kgkB9Nts+CwfWCvUB89GVv893qyTs4/pdzW9v8KUsSxzyk9j32seNgrb3//TX4TwCV5kwuop0EohOdidsDiElvGGb/hXDQohD+gBFOzAeOs2Asw+a+AfpxS9Bg6Kb851BrQy+bwAUnrwkJ6qefYLwD5fFMvt7kCu0OA3MdbB8XzHxSlERbGmTKmAeaknEmnFpGOttarCwDcRCjCPZUbNGDuL1Uyi1DUxx8Za7sgoz6si1gN3bcy5cYF0uyUIpGRTL2VOQJl9ci7wrtcIHNt3IFMog7r4MbhbzpHbNkOX5hMzONfVQI+zSSyBDD3NGnw511Ym0QEiReWQkLQaRarw1QYlpXLMgUSt9aaEoSHzp6+rXHQM7KAGH+FO9QhQsclZpt0MTqn4uByD0wWEs8o0bWS7OfdAXcuRTeOzGlVLR/jyuTH0yb10h1xHLV3BWzzfSA+gn3Ykx2BpL1r/vThTR/Jc+JMJJA66iYQ632iySdEa7bFEfmXCJnJF6myNkXAhkDB26wDzLeiguqIIm
 DLh/Q5bk
 v5qDFgtp/gMcJmyaD3NESVEc7dJvd02ufPxN6Z6s7XONNy/DT/gM9LuOjTPfb+DQFToWyLkufa0cVspFC5/M75Gx8XuruZA66jYQS5AOwzv+iRG5JL9h8pZrJU4rEvGHrTEE8c2i+BtgXxaWqdj4OU1giMyRE66ykSQDc7+/ffihra2hgmQH57CKuNzGmxmlZchiEtDtbqoGy83MYafXZU7EkadWNG1fcoQRyJskBgqBAW/CUy1HbH/zvKRqnKYineuUYdP+d3kKofBpJRETbACfnVkC1SQUPWH2lhQvI61rzHqbyEY+56uCbs3YtZrC/lj0rTCiwytRP/3kYp/CScHSor4OsdFgFLf0aXVm1LB5yMn86SmHgsjNFpM9B1bLRFjrkvO7HSiT4Qy/fG69x/HPwwX5ggXdiYKW1c/JW+WBTWI/rlXYr6KvOuCzIZW1fVrxrbDtVOHUxzoeOw5OsCpw+WgW1tDRWOQQ5XqMKYv/FN3bHVdLoh9/6VAcTDIJU7GHgFLgeCkFPn6qMY/Hz7RWlUlr2+V0E1TtiWWyxueaznetU/gwtLiKA0ESbK8LP79yiL7Pijp3JNFR4WSS0ekIpEweueT0qKgmPFYLHEhxgz2sPNC2i53CNqIWEgqjfdQr6yROxlehCjEQK8Qj4CoXU+NVVxo03KEkozypOpEjb+evkfPg61SKFxQ2snZJwz8T23v+WL/mlIpix9rPMXHQtmOl2puvXb3s58Udg0HqBIXP4NcHqWcxh+KrgYmCy+ezmj7E4sKeMKftkyFMGP48jflvKbf1JMLDYjKHJoGcW/7rorjhBvd2hov0nkv0pBznBcTQSdM1PxImwRqBsad+FuSaIqPubmI4t5FBDClI70emXJMjrzAafgGUgm/HN3+mFsChAhIJueVBKY2n+8qdAVnfUCl/GwETOJQheumihsUAl5cHOQETbv8wNMyqeflPCkPzQ1ED0NPHtbS+4scTvUs4E
 zjsCcWPN
 jp+hXVa1D2+BUpcINqrJbM58v+4S120cW8Lh4XQFkT+txdlfImdwpoTlONaNDc9waRxofwuuEAvC8T4JF/35ZKBBP3CCm4K5B2y9ktWXEoMuVj1K3maaKtGdSYlfeP4IGOg/DL96LI6xr5B94LAnq7VLOsB8fCQNzltcE87q7O4kKmxA4Ptb3nia+sDQEwJ04pkvhDBmQ04KaRbUY+uOtMuC1jGhjJn6TJSzx6RcVRjSNT9N55/lqqqf9otG9SbkXVBWGPhFn/7MjmUzig8fqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Apr 2026 09:38:19 +0100 "Lorenzo Stoakes (Oracle)" <ljs@kernel.or=
g> wrote:

> On Wed, Apr 01, 2026 at 01:31:45PM -0700, Andrew Morton wrote:
> > On Wed, 1 Apr 2026 09:14:35 +0100 "Lorenzo Stoakes (Oracle)" <ljs@kerne=
l.org> wrote:
> >
> > > From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> > > Date: Tue, 31 Mar 2026 13:11:18 +0100
> > > Subject: [PATCH] mm/khugepaged: fix issue with tracking lock
> > >
> > > We are incorrectly treating lock_dropped to track both whether the lo=
ck is
> > > currently held and whether or not the lock was ever dropped.
> > >
> > > Update this change to account for this.
> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >
> > Not sure if I should add this?
> >
> > Should it have
> >
> > Fixes: 330f3758a3bc ("mm/khugepaged: unify khugepaged and madv_collapse
> > with collapse_single_pmd()")?
>=20
> (Sorry only just noticed this)
>=20
> I mean we do need this patch, if you plan to do this as a fix follow up t=
hen
> should have a fixed tag, but I do worry about bisection hazard by leaving=
 this
> as-is.
>=20
> We definitely either need this patch folded in or as a fix that gets sent
> alongside the change.

I added this to mm-stable a couple of days ago as 5a62019807da
("mm/khugepaged: fix issue with tracking lock"), below.  It does have
the Fixes: so I think we're good.


commit 5a62019807da4a7add0717c962ac83b23dd12b2c
Author: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Date:   Tue Mar 31 13:11:18 2026 +0100

    mm/khugepaged: fix issue with tracking lock
   =20
    We are incorrectly treating lock_dropped to track both whether the lock=
 is
    currently held and whether or not the lock was ever dropped.
   =20
    Update this change to account for this.
   =20
    Link: https://lkml.kernel.org/r/7760c811-e100-4d40-9217-0813c28314be@lu=
cifer.local
    Fixes: 330f3758a3bc ("mm/khugepaged: unify khugepaged and madv_collapse=
 with collapse_single_pmd()")
    Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
    Reviewed-by: Lance Yang <lance.yang@linux.dev>
    Reviewed-by: Nico Pache <npache@redhat.com>
    Cc: Alistair Popple <apopple@nvidia.com>
    Cc: Andrea Arcangeli <aarcange@redhat.com>
    Cc: Anshuman Khandual <anshuman.khandual@arm.com>
    Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
    Cc: Barry Song <baohua@kernel.org>
    Cc: Brendan Jackman <jackmanb@google.com>
    Cc: Byungchul Park <byungchul@sk.com>
    Cc: Catalin Marinas <catalin.marinas@arm.com>
    Cc: David Hildenbrand <david@kernel.org>
    Cc: David Rientjes <rientjes@google.com>
    Cc: Dev Jain <dev.jain@arm.com>
    Cc: Gregory Price <gourry@gourry.net>
    Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
    Cc: Hugh Dickins <hughd@google.com>
    Cc: Jan Kara <jack@suse.cz>
    Cc: Jann Horn <jannh@google.com>
    Cc: Johannes Weiner <hannes@cmpxchg.org>
    Cc: Jonathan Corbet <corbet@lwn.net>
    Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
    Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
    Cc: Liam Howlett <liam.howlett@oracle.com>
    Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
    Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Cc: Matthew Brost <matthew.brost@intel.com>
    Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
    Cc: Michal Hocko <mhocko@suse.com>
    Cc: Mike Rapoport <rppt@kernel.org>
    Cc: Nanyong Sun <sunnanyong@huawei.com>
    Cc: Pedro Falcato <pfalcato@suse.de>
    Cc: Peter Xu <peterx@redhat.com>
    Cc: Rafael Aquini <raquini@redhat.com>
    Cc: Rakie Kim <rakie.kim@sk.com>
    Cc: Randy Dunlap <rdunlap@infradead.org>
    Cc: Ryan Roberts <ryan.roberts@arm.com>
    Cc: Shivank Garg <shivankg@amd.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Suren Baghdasaryan <surenb@google.com>
    Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
    Cc: Thomas Hellstr=F6m <thomas.hellstrom@linux.intel.com>
    Cc: Usama Arif <usamaarif642@gmail.com>
    Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
    Cc: Vlastimil Babka <vbabka@suse.cz>
    Cc: Wei Yang <richard.weiyang@gmail.com>
    Cc: Will Deacon <will@kernel.org>
    Cc: Yang Shi <yang@os.amperecomputing.com>
    Cc: Zach O'Keefe <zokeefe@google.com>
    Cc: Zi Yan <ziy@nvidia.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d21348b85a59..b8452dbdb043 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsi=
gned long start,
 	unsigned long hstart, hend, addr;
 	enum scan_result last_fail =3D SCAN_FAIL;
 	int thps =3D 0;
+	bool mmap_unlocked =3D false;
=20
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
@@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma, un=
signed long start,
 	for (addr =3D hstart; addr < hend; addr +=3D HPAGE_PMD_SIZE) {
 		enum scan_result result =3D SCAN_FAIL;
=20
-		if (*lock_dropped) {
+		if (mmap_unlocked) {
 			cond_resched();
 			mmap_read_lock(mm);
-			*lock_dropped =3D false;
+			mmap_unlocked =3D false;
+			*lock_dropped =3D true;
 			result =3D hugepage_vma_revalidate(mm, addr, false, &vma,
 							 cc);
 			if (result  !=3D SCAN_SUCCEED) {
@@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsi=
gned long start,
 			hend =3D min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
=20
-		result =3D collapse_single_pmd(addr, vma, lock_dropped, cc);
+		result =3D collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
=20
 		switch (result) {
 		case SCAN_SUCCEED:
@@ -2893,8 +2895,10 @@ int madvise_collapse(struct vm_area_struct *vma, uns=
igned long start,
=20
 out_maybelock:
 	/* Caller expects us to hold mmap_lock on return */
-	if (*lock_dropped)
+	if (mmap_unlocked) {
+		*lock_dropped =3D true;
 		mmap_read_lock(mm);
+	}
 out_nolock:
 	mmap_assert_locked(mm);
 	mmdrop(mm);


