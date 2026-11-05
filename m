Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415F6606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftjSanR5
Received: by kanga.kvack.org (Postfix)
	id 5BC746B05B5; Thu,  5 Nov 2026 16:41:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546086B05B8; Thu,  5 Nov 2026 16:41:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40DEE6B05CA; Thu,  5 Nov 2026 16:41:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17C746B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:41:41 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D88C40C76
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:41:41 +0000 (UTC)
X-FDA: 85402387602.21.DABC3F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id BD82C140006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:41:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftjSanR5;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914899;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OC6xPJuoLtag/UNVUOAoSaQZwd0BWlf5yd9F9l2dg+8=;
	b=HDSP1RrYkFi0zjNmLDYoLC2ie7Xs9kgP72+PUj1QzhhKtmu8XYdjKPthjMJ6NkJtpdz1U/
	PF8/7dK0kOm0IsIAGPyhRazrulg1M3WgvS6fhoWBo98r1YfktshzHGaDZRjn3u92S/iHUS
	cMmd3YIxzUQfHD1tD9Fp1zyfBJ+BhA8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914899;
	b=J/Kac0oYis2aSf6MUsLWAag2iq9sLc59u9ggLUOMwU7PdrXq2cohSjqDaiqVZk1TZvX8Zx
	DB+6GWQzfuC626PRtdEi6sEV0CQmDyKyGUCWVA+DVAgMsQtMVtnh4Ju6imoyAM3vxmD2t8
	EQtxsDJd4+2sMQNOBVjsHXbGvKsXDTE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftjSanR5;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 02FDB40D9D;
	Thu,  5 Nov 2026 21:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05BF1F0089F;
	Thu,  5 Nov 2026 21:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914898;
	bh=OC6xPJuoLtag/UNVUOAoSaQZwd0BWlf5yd9F9l2dg+8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ftjSanR5NYRVoTeBKZ9GKKb5Ejk1Wo1LW5KsXglEAcnlyjjvxN2a+oB7TS+tqIO48
	 mLWMUruChKgreDIeGVIBYX7RKGlsxtvnxnVOabXGjobAB/fVlZBcpRSb4QcmM+aPey
	 H1GN8tWl7V0jJslBLXgjRHT2fPyQBR4w0/b8W6NY2gw07MVWVDA9NQN/Y11ulVuQIA
	 85VS68u9z1a4tjmBgnUKmKpo/fWULan3ie+4z30hlSVqrPQol/nhiJzLckViEBmmge
	 zkrugiLnzvT9AifyLkUuMzOvKx+kKGulAQEqHn+yOT6n1ONFUVd0hOc+ZZVtqSd1Kf
	 1pcTL4VXazLdw==
Message-ID: <sashiko-outbox-200257@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/13] mm/filemap: convert fault and readahead logic to
 use vma_flags_t
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu" <peterx@redhat.com>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Rik van Riel" <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Harry Yoo" <harry@kernel.org>, "Jann Horn" <jannh@google.com>, "Lance
 Yang" <lance.yang@linux.dev>, "Zi Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Xu Xin" <xu.xin@linux.dev>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Nicholas Piggin" <npiggin@gmail.com>, "Michael
 Ellerman" <mpe@ellerman.id.au>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAoQ1Mg?=
 =?utf-8?b?R1JPVVAp?= <chleroy@kernel.org>, =?utf-8?b?Uml0ZXNoIEhhcmph?=
 =?utf-8?b?bmkgKElCTSk=?= <ritesh.list@gmail.com>, "Shrikanth Hegde" <sshegde@linux.ibm.com>, "Pedro
 Falcato" <pfalcato@suse.de>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Leon Romanovsky" <leon@kernel.org>, "SJ Park" <sj@kernel.org>, "Rakie
 Kim" <rakie.kim@sk.com>, "David Rientjes" <rientjes@google.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>, "Arnaldo
 Carvalho de Melo" <acme@kernel.org>, "Namhyung Kim" <namhyung@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, "Alexander Shishkin" <alexander.shishkin@linux.intel.com>, "Jiri
 Olsa" <jolsa@kernel.org>, "Ian Rogers" <irogers@google.com>, "Adrian Hunter" <adrian.hunter@intel.com>, "James
 Clark" <james.clark@linaro.org>, "Masami Hiramatsu" <mhiramat@kernel.org>, "Oleg
 Nesterov" <oleg@redhat.com>, "John Johansen" <john.johansen@canonical.com>, "Georgia
 Garcia" <georgia.garcia@canonical.com>, "Paul Moore" <paul@paul-moore.com>, "James
 Morris" <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Mimi
 Zohar" <zohar@linux.ibm.com>, "Roberto Sassu" <roberto.sassu@huawei.com>, "Dmitry
 Kasatkin" <dmitry.kasatkin@gmail.com>, "Eric Snowberg" <eric.snowberg@oracle.com>, "Fan
 Wu" <wufan@kernel.org>, "Stephen Smalley" <stephen.smalley.work@gmail.com>,
 =?utf-8?b?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, damon@lists.linux.dev, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, selinux@vger.kernel.org
In-Reply-To: <20261105-late-2026-vma-flags-v1-2-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-2-0d3cd15ab75f@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 21:41:34 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7u9fxw9439eab4c19wpbniofn8w11h7g
X-Rspamd-Queue-Id: BD82C140006
X-Rspam-User: 
X-HE-Tag: 1793914899-940181
X-HE-Meta: U2FsdGVkX1+/2DEL8kG9Xycqn+1++sB4kvK1IXulxOGg94j5WnD847DAMS3ssmBBtM1IO3hGfUH8FukF/JJT50ucn8dByYqZDVj1LCDw3MQsKAH9djX19d5wdgVKSXnJsVw2C+OkSeZaSc7DHPbDEuBe7QNoWZiAey+EUedlYGV7hGWy54h8if/nFGDvBb94tphTv5Od8UjqDd5dq7U/tSV5HfZtougqWCU+3bHpqQEPcZJ3LHMUu2XuviQlVHA4+kdLJDErS9p1llsbYznbxq1s93XqoJ1f8FjTNGmqUYMQfbMGvTMSYWlpnxG8t5yoHgXZWjx/nzdjDOlKZEDUY0S7LvrVUDBKOFe+1kQOgad4LtkNQm8bVz+mcgNc6fLvlqRiV3w7deuAsLRFR5MAEaKTY+O2cEscTVaC4k+N+AtZS+33oMZndUgPrikeWFEjC3z6Zh2PFdwZKEB1stX0sjeSO1kbluJGUQJM2tQ5kThpMXKQa3o8EH9/lFcfz73jnzo+qiKU0T0Pf+2OJH1dXcuzdOw82Z/xHLA6Eo3PIulSHpnnZiivwquJnipYUNNUEaeqkaKYe7EvMBfO3/iR7mSre6N0wDaLIlpBMz1cihYF/YsVpJI+/j6Jq9ej7FGme3zvnlQ/S1XSXKuhWdGGe5sGa0N78z4sEWUCT6tlwwgiylBs/K5JvAQn91ZzaYFrY+64FVkbjuqCRuNF4VcURnp6l+YqLFfAkoxPUY/GzObaKwK+FCsUYljmcEp7amFDo0l3xAUsqPfMBYwi110SQxhI6dExVwulZRrFbeRrvZNS+kj/UXkOhMVuRQdAlYqwrQZbVcp/QPgwKq3GfmspPK9OrMwmw5rj9Ic4q9o5Z7mEJATBjxyA0dGUaOcFZwUnpjERCGf7wqzakvgzBJoMAGhHmjR64YcASVauKovsEzkjCoBW3WZmqnVyHOGq61Fc2hje+nJWAlvz37P72M8
 TSfH4MZI
 ckBFhUCAXGWy63MfwCqzcxWoP4POh0u565UBIyg02M2JeNop7444AFg0XlEoNZmGpsMTdxmG2PjTnUBMh+HrpGbJDtK4ORs7j+ZN74ltKD4k+nIR2uUZeeFgXasee0ofCeqeiDO+AMq0p/I2t6/snlWLH6Gjbw6v4nOlcEHbQMs9xvoDkT+5kV/gpAMMuQqbp4a0oBA73AD+7DzuAZfiXfUsTg4R246pCg0xT/q1syyzkTDIET35Tm0g/x3EKOGB0fRPWAItXAOzhOl52RMaGFfQEFVn4ScSF/s2LWsFuwnj+XUomtHvddYnN9erN0Y9kpjjBhinqQdBESH5f0O+jxcboXnPuAc3KMv1cwVqB7FbvRT4YRj6KDfTXc3Wqyk9Hxv+MOvIgR639O4HBKoE+gW50MNrVBs6TJ14t7J01FibA3Xh+ZKNmdvxPPPvDnI8+HogOivBm9YnvPHcKiXxZWYz/HUfugkYN5rtZtjyHHjw0roZsERaNV9yYgqqW/+QWwexG+LK46g/3tFUnruJyep6qWo0Rjw/c+6rIbJdyfuU1s6MZa/xqrF9/QvceK6NvZ3wJakvzVUHBa6UhITgQA3kUjoXiUHp1Wv2p48Q8zYAo48NjqAn9RjVC4cDucNrfYiuCtZ7mfydtxZeYcY1lcENM8YwxGU9xTSmhevY7no5DG7L/kg/Cn01KlNmOXRUolE48qEtsGZTBuqadfoEqbXNMCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm/filemap: use-after-free on vma in do_sync_mmap_readahead()
- [Low] mm/filemap: inner vma declaration shadows outer vma in do_sync_mmap=
_readahead()
--

commit f5f0f8e634a6a2e2b76ad818de67e83f30cb7dea
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/filemap: convert fault and readahead logic to use vma_flags_t

This commit replaces direct checks of vm_flags_t values with vma_flags_t
helpers in the filemap fault and mmap readahead paths.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index b74bc1e5015c6..d8b538bd14043 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3351,13 +3351,14 @@ static struct file *do_sync_mmap_readahead(struct=
 vm_fault *vmf)
>  	struct address_space *mapping =3D file->f_mapping;
>  	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
>  	struct file *fpin =3D NULL;
> -	vm_flags_t vm_flags =3D vmf->vma->vm_flags;
> +	struct vm_area_struct *vma =3D vmf->vma;
>  	bool force_thp_readahead =3D false;
>  	unsigned int thp_order =3D 0;
>  	unsigned short mmap_miss;

[ ... ]

> @@ -3414,7 +3416,7 @@ static struct file *do_sync_mmap_readahead(struct v=
m_fault *vmf)
>  		 * Fetch two folios so we get the chance to actually
>  		 * readahead, unless we've been told not to.
>  		 */
> -		if (!(vm_flags & VM_RAND_READ))
> +		if (!vma_test(vma, VMA_RAND_READ_BIT))
>  			ra->size *=3D 2;
>  		ra->async_size =3D folio_nr_pages;
>  		ra->order =3D thp_order;

[Severity: High]
Can this trigger a use-after-free on vma?

Previously, do_sync_mmap_readahead() cached vmf->vma->vm_flags by value in a
local variable at entry while the fault lock was held, as introduced by
commit dcfa24ba6899 ("filemap: Cache the value of vm_flags").

In the force_thp_readahead block, maybe_unlock_mmap_for_io() is called befo=
re
this check:

	if (force_thp_readahead) {
		unsigned long folio_nr_pages =3D 1UL << thp_order;

		fpin =3D maybe_unlock_mmap_for_io(vmf, fpin);
		ractl._index &=3D ~(folio_nr_pages - 1);
		ra->size =3D folio_nr_pages;
		/*
		 * Fetch two folios so we get the chance to actually
		 * readahead, unless we've been told not to.
		 */
		if (!vma_test(vma, VMA_RAND_READ_BIT))
			ra->size *=3D 2;

Since maybe_unlock_mmap_for_io() only pins vmf->vma->vm_file and calls
release_fault_lock(vmf) to drop mmap_lock or the per-VMA lock, isn't vma
unprotected against concurrent modification or freeing when vma_test(vma,
VMA_RAND_READ_BIT) dereferences vma->flags?

> @@ -3422,7 +3424,7 @@ static struct file *do_sync_mmap_readahead(struct v=
m_fault *vmf)
>  		return fpin;
>  	}
> =20
> -	if (vm_flags & VM_EXEC) {
> +	if (vma_test(vma, VMA_EXEC_BIT)) {
>  		/*
>  		 * Allow arch to request a preferred minimum folio order for
>  		 * executable memory. This can often be beneficial to

[Severity: Low]
Does the newly added outer vma declaration in do_sync_mmap_readahead() cause
the existing inner declaration in this VMA_EXEC_BIT block to shadow it?

	if (vma_test(vma, VMA_EXEC_BIT)) {
		...
		struct vm_area_struct *vma =3D vmf->vma;
		const unsigned long start =3D vma_start_pgoff(vma);
		const unsigned long end =3D vma_end_pgoff(vma);

Should the inner vma variable be removed now that vma is declared at functi=
on
scope?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-late-2026-=
vma-flags-v1-0-0d3cd15ab75f@kernel.org?part=3D2

