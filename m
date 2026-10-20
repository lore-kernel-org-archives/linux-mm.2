Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09508606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 05:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SCgMporR
Received: by kanga.kvack.org (Postfix)
	id 232BF6B0408; Tue, 20 Oct 2026 01:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5DE6B040A; Tue, 20 Oct 2026 01:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CB896B040B; Tue, 20 Oct 2026 01:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBC276B0408
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:45:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51EFBC0891
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:45:13 +0000 (UTC)
X-FDA: 85341916506.02.619959A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B811F180002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:45:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCgMporR;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792475111;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uljf/9NZsn2sagByb+sfdykIppkfTxXBBdJE/0CcZcE=;
	b=I/vKQDO2BXxOnmXuIdAa+7gcAo6jnOR0Ds32p8HRv+w7CLbZJZ6JGsy37iGwprqiNGKuk3
	C5aSknCz5w+bFnqpn5AQ1JTOxZvvPLu65JjxISCgT+rT7AXdoPVIs29t8l+r8sdEVPcnXM
	chGTi8aZceRnyOonrG6fBgZNut7HlMw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792475111;
	b=rV68KyMMdv+UY2Cjw12nLzGWZGwB/xACzrFQU0ob3542T839S31JojkvAl4wzHt4I+XDmy
	iy5oEycev+E52hP68wr2FhXGtLxROp2UlYshSP/tVyVwqmvO+EJcsPPmkBW2UtwknTlY14
	IOQ9F5rKxysP2TaJcf4N+RvwhSJUpJ4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCgMporR;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A94D60229;
	Tue, 20 Oct 2026 05:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0007F1F000C4;
	Tue, 20 Oct 2026 05:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792475111;
	bh=Uljf/9NZsn2sagByb+sfdykIppkfTxXBBdJE/0CcZcE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SCgMporRi8LVLOxoHDCf5Du/3V2k6sLd98l0RKN/sZVJebcpEQQihjFv+yygkRDQG
	 K0edow1ixjEvA3W97a5G1YSjhtbmSo+w4+Unlhv1FIi46K3HGUNDCj0RxiSZmZM6RY
	 F4J02mAo7ubMjyi4seyLpe9tbFKez7/nKM8oVz5BDOJ9Md/Nsfw28ISm13NZOkxily
	 /IC+rN9zd2xljU1hi0s3CP3bh37rwrUsh1o/9c5MhJsNXmgUnng4vxrVNK2zfXLcB1
	 L/ITlBKBcCbXbKWwp/BMqWyFFvJKMk6ZwhYeqPU1Zem9rER/DhUBshBBMYzHXIarvM
	 mbNvY5+W5MAQQ==
Message-ID: <sashiko-outbox-178440@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/5] powerpc: drop redundant unmaps of failed vmap
 mappings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hao Ge" <hao.ge@linux.dev>, "Suren Baghdasaryan" <surenb@google.com>, "Uladzislau
 Rezki" <urezki@gmail.com>, "Madhavan Srinivasan" <maddy@linux.ibm.com>, "Michael
 Ellerman" <mpe@ellerman.id.au>, "Nicholas Piggin" <npiggin@gmail.com>,
 =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAoQ1MgR1JPVVAp?= <chleroy@kernel.org>,
 =?utf-8?b?Uml0ZXNoIEhhcmphbmkgKElCTSk=?= <ritesh.list@gmail.com>, "Shrikanth
 Hegde" <sshegde@linux.ibm.com>, "Alexander Potapenko" <glider@google.com>, "Marco
 Elver" <elver@google.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Dennis Zhou" <dennis@kernel.org>, "Tejun
 Heo" <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org
In-Reply-To: <20261019054531.87652-5-hao.ge@linux.dev>
References: <20261019054531.87652-1-hao.ge@linux.dev>
 <20261019054531.87652-5-hao.ge@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 05:45:09 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B811F180002
X-Stat-Signature: rrad3djfei8uqtbrxdkbuw591r8jhire
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792475111-709931
X-HE-Meta: U2FsdGVkX1/3OoqATm0axKjcn2Fbk9NHgJATlsLrYDQ0BRgrldHkAypmEtPEcl9qesdHuayq6mD2waFU9xRxv1B5gXojQatFb9q+4knpqvlBwLtvo/JrXF5WpI5LcF9V76SVihZ/ewbsYIbulLyeChS9h8NoK25nxtgkFmK21RpzX3C47nUBTlLNmkmBD336kSt2RbpFmvArzU6vo0FE0qJDDBa98k/+zXMukxLrkoDDmYR4KrLiuAlhhY9Cljra2tcZYDJW1urBAoGAW82j3m0qJG+8pKuU/L18/2+LkytS0qNfkhkKnEexXZQ8lW1sL4n+MQr0VBOSHzhdt84oaCstxmc+DrViYaM4FWXc7JeABEqNwjTWIz2dPT272y3WIFpeNuIndq4r0Dgaj7T22WdEF2becOFfTsOvvxNetf71jp1heF5I6zAhl2wfV+sBvWjpCnZ/XQDqhnI7r5Fyomjg4qurTxCHIZNdAqQxioTAM2IJnYd85DYZaS7ca91CITKzEbw/YQx4E8THRAOM8T/T6XmcI73eQmo4C91P8cfZaVM5wcUtw5Y/ViTNf4mdmaKZqvBM6KOa6KxyMizQEd5r46sv7wgyxPkqq8inNeJprDVGUToimWzziUM5p9O4T9ZbNVVAK9hkvew1ckUA/CVqI3FTHeQcFPgPKZGrzAyU5Wfuca5c0CxtCc1b0SK7zQyx8e3JEezVGU+ppGVTWc3u9KvNd/wjtTGMJ/0CHJt6YzwK13x94YP0bBSfw5vTS3C/VXIxXOcTX6t/RrcvN2w2p0+hPZ8QvvB56D0W9uOV/yesqzVwYcFFAjpgutprBeEgifRCRrpR9oH1Wr+yW5HTzGf4z6VLPsRZpq6ScP3Ryo1vHX0bHyqBt1D6cm1mUUpCsdyk/fmOsuc7kbbXuF7evcbpV+Q5J0tzB/2XA2U28ypkmdMjyfR/667TLtPB1/RMg37bDCIP7UxU0Yy
 NoU6Tns/
 vraYUjGgrqQxF17bzHaqUbG6lqYNUhDwwagF7M+0N4wVCua+SLj5U6CQEiR5VfsrIbt1AvSb1Nak569XLH0EySO55wVzp8UNJ3KK8iSlTFowOpOKbm5dqOzmn+KonqE/YGReAI7MdKo9MKpYzfY0lQ4bwujmKnXxXe846ZLls3ynwVXZN/zU/T5noWjwRIvlDeznav0KtfLFLfR4fWEDCASyiwCz26YWRhkFOirPdXKemgENRB8hgYS+mggPZ3TcLXeDl/kT9Nqf46jR+XkbMdTZFHsCJV1DQzcuRa9KG7M59PfJ+2sQOeGTWRqupr7KjwP6mxRFp6IncUQvXsnUOjgEpIZz/+mCNjxr8PSazXmWFGhm72Ib6jzPIhOmiodGLYsMnpa/SrK8ZsbAKOrgOejjQSZydkZwQnaergrC/sot0UBvn8XyooGafzMGEy5XNbWpD0Y+ZPeO4I2RmhUade4TMyTJ1F2D7xcw2bsIkkx7LQA8a+yqUIS4W2GkSRalj0+ETT4KzC3W6qYI+GBji/2AcjFbuj+8o07igvqOZl5U0Lf/TG9uQ5C8C9887dRPji2CFsoIM9oWT4R/38AzbS1VdcBTowqXpp8iLrnFxtsZcZ56IV91Map8/ViVNXbUNDomxPK4UL+Z9SfR9Ht9MrY/pde5xukfqAIXW7o9UUxqrXFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] powerpc/pci: leak of vm_struct in ioremap_phb() when ioremap_pag=
e_range() fails
--

commit 293efb97e53f2ab49d30288da6e26fcbf75e032f
Author: Hao Ge <hao.ge@linux.dev>

powerpc: drop redundant unmaps of failed vmap mappings

This commit removes vunmap_range() calls from the error paths of
remap_isa_base() and ioremap_phb(), since vmap_page_range() and
ioremap_page_range() already clean up their installed PTEs upon failure.

> diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
> index e27342ef128b8..f74269636d5ec 100644
> --- a/arch/powerpc/kernel/pci_64.c
> +++ b/arch/powerpc/kernel/pci_64.c
> @@ -139,10 +139,8 @@ void __iomem *ioremap_phb(phys_addr_t paddr, unsigne=
d long size)
> =20
>  	addr =3D (unsigned long)area->addr;
>  	if (ioremap_page_range(addr, addr + size, paddr,
> -			pgprot_noncached(PAGE_KERNEL))) {
> -		vunmap_range(addr, addr + size);
> +			pgprot_noncached(PAGE_KERNEL)))
>  		return NULL;
> -	}
> =20
>  	return (void __iomem *)addr;
>  }

[Severity: Medium]
Does ioremap_phb() still leak area and its reserved virtual address range in
[PHB_IO_BASE, PHB_IO_END) when ioremap_page_range() fails?

Prior to calling ioremap_page_range(), ioremap_phb() allocates a virtual
memory area:

arch/powerpc/kernel/pci_64.c:ioremap_phb() {
    ...
	area =3D __get_vm_area_caller(size, VM_IOREMAP, PHB_IO_BASE, PHB_IO_END,
				    __builtin_return_address(0));
	if (!area)
		return NULL;
    ...
}

When ioremap_page_range() fails (for example, -ENOMEM when allocating page
tables in vmap_range_noflush()), vmap_page_range() rolls back the PTEs via
__vunmap_range_noflush(), but it does not free or unlink the struct vm_stru=
ct
and struct vmap_area allocated by __get_vm_area_caller().

Should this error path call free_vm_area(area) before returning NULL, match=
ing
generic_ioremap_prot() in mm/ioremap.c?

mm/ioremap.c:generic_ioremap_prot() {
    ...
	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
		free_vm_area(area);
		return NULL;
	}
    ...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019054531.8765=
2-1-hao.ge@linux.dev?part=3D4

