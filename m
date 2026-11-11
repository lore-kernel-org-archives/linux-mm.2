Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA889606A89C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OIcV2Ati
Received: by kanga.kvack.org (Postfix)
	id 1CC066B05BC; Wed, 11 Nov 2026 17:50:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155FA6B05C8; Wed, 11 Nov 2026 17:50:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF11C6B05BC; Wed, 11 Nov 2026 17:50:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD46C6B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:50:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6CE7EA0470
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:50:35 +0000 (UTC)
X-FDA: 85424334030.28.549BFA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C312D1C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:50:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OIcV2Ati;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437433;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVTuJ1ZadpM8DW+Gw10f6JclMBh6bL2TpwjonMT6ua8=;
	b=X6q+tVNRoXvIv3yUIWeY8dvRaZFJL2L2Zua0ef6CS2Gqh2XcYXENIcGYuKzhID8THnEOWb
	TfOL3umM81+0cguQeU2uVSkAP2vDC1KWEpFmGFk/IEz9Z3M4biIJfcXWxLkq+6VduYXjwT
	2WTfA+w0fRaHQNBy6jp5Iuw3RvXg+SQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437433;
	b=QqNFDXJn4FToRnKsx1qciquuGE0QKn7iC5wK6T+pvCAdQT8jjZY2azryPgcrNi2kcZT9TG
	aUAnUu+fSMMUUy/ZZeOcGF3H+ffpBjMvmW6cLM4Ysv/3SnpOyja7O3fqdWpCYKdn7Jma/a
	SXOXVdvgjTxXC9MG/trYDZXy/1/1zQY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OIcV2Ati;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6002963BB6;
	Wed, 11 Nov 2026 22:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC571F00A05;
	Wed, 11 Nov 2026 22:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794437432;
	bh=SVTuJ1ZadpM8DW+Gw10f6JclMBh6bL2TpwjonMT6ua8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OIcV2AtiJytrDbWIJF1koHJiEFHT/7wOAqNsExJ7YxlByp8cmLqv/S92++fHtn7yI
	 N8RWmzH1Uqvi5AXN7hQaFJUiCDRpemD4kVKbtW3+5CsgMT/QEvdwzeKxywy09K9DAn
	 qnpnyvLAUaVlGuJe18ytH45hhxkLlDRG57U/iZP2g5iNxo1FR98Xr47Yu5Gus0TbFY
	 OrmNqMyqwMiZ+BNDa6tz0wNIeQpQ6ji/OCi9waoCJ536xngtL3hGCAz/p6L6io3e8z
	 ccx40a0SPY7yawRpbkQv/AC10u6B6J2/NDrmO6aq1rKYO8+9K2+aF6uRyAVl/B0DVz
	 uo50+Ter5Nf0w==
Message-ID: <sashiko-outbox-209832@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] mm/char-mem: implement huge_fault support for
 /dev/mem
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eliav Farber" <farbere@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, linux-mm@kvack.org
In-Reply-To: <20261111113045.35368-4-farbere@amazon.com>
References: <20261111113045.35368-1-farbere@amazon.com>
 <20261111113045.35368-4-farbere@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 22:50:30 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: nhx3ic4f86ushhxn5gd1f1txr87x64dg
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C312D1C0005
X-Rspam-User: 
X-HE-Tag: 1794437433-54401
X-HE-Meta: U2FsdGVkX1+Fqumyf4wLDFdEtsGi9RANnAVHp1l0youH9inSy7cZcUNLVDfnkx1hMMQ5bw/DOALDtrauTvkuxU35wdr5K/EXOVqGIMSwZDmqDDDu18v2+cFWN6spd6U+Go2m46nVZScm9981Ux2ShqXinzgcwOJ1FQdDmZGgw0W1gUFrP6k+D7ODFfa/+CDUqzI2ql90LSVn64BtWNp7NgbTtAM4+SLWJW04N7TR2dBjxlMx/XQ5D8aBd6rq88JS1iznLWPvVEijVl1YM0uUqb2iD9P1EPywqKMhyKkxKV7etj6b6DxVx/IzE4dNnJFSSqFlYVYc9j1GRk6CMzn8g+PvpdmLTItFrC70iRt6CHz5D+PcKr2SUcqY+huc3D4F3N/SVcjv9cl46r5viv/6yve9i4L1dY+765lY2E+lD+Dgm5znfIKmhK5nJYvj6bZWUdBYrObYqRykyblMxYBGLqy6T0nnw7vAkLW2bW1J6oxI8p+82Hqtu5oU3H9rAzJxB38iINFxHVsCo/h1yy/cvcFVcRzf0SufyDqrt8e0jk0Pr5SiDkf/ZDgyVgNofb9N3PYRF8ErzasQKGxFDPKFv1qWS03jA0XFAPabQ0XRuhz+SCAGmn4SdOQX88iWAKECzwDVqqH0FNJQ0vLj1vCmxFiDJK8SVDtiBBT+V1y5LO4U3Ilur0E5ofsedubjzllDjV7NOm61bEhYg9EhifY2YSr3X2UHy667D0f7dmf82kae/uJMEDbstIFPmyCi9PZEgWaRtltgGf7A+sTFyg96DnuCagpmt9UwEK9RU6eCqhbrSnQDk0T1BGWihxPEEUUThZpc1JF9ZzF8Cgd4q2pJii6pLphcjRV3/+dyZ2z+6/UfuCdrEqhKKjnn8zh0eU8HVzrWGfOXOqAy06U8jqvUIExS155MvbUO1YK4jNa6C+rMrF3Q6OciNl7ZoD2kbjw3Rvd7NImDB2VHbefJmGK
 WP/FZwD4
 g1VUX6mSXMHH+0ijZIZNSVmDKziA5fZiM2trOZDQOQCGkj3g1aeAsVQqYElZOOv/6tEG6W2kebpDbcdEYgbG/Okd4vWWaexhHE+rwdn96yt4ptiDzvAtxeNAOXfdA8/nL5DGeYE4/GhDhPBy740m/hRf2+aOeocxtnC5FNEvrqYIDBVFUT52OxwqFIzov3QTm6UlyYt9W4WhuOiTbt3pG8SoeiLGB9uCDpxc70DYWSwXghBd93yAw107/YH+8RmO2p5WdR9tJzxr4PFV2dG/8IyiNr2UM8Zzxb5VAtbW/Qyb0xeeXcLTb4MxKnRLfPK4A7Kil7HgM0YthrQmIwuJbf3+LPxg0ya3vZVHTREEWmdMhpJ2VJsYy+u0TX5A1q8/vyWOkX6gt/IunPuWBl98NXtPzKxLK/3Id8qjMmvlDXfpWv+daCTW5XZ8cVfNrdTs4Ao0y9KvuiVPVUjJt21e6Xatlg3YwnsYwiUcwZTHX+o3jORhqN7ju7hoOb2fgagJNedrUokwglmtXUCqFY90TcozYZoa66xHpZNskNQWqIlNIVjx3jPp17yY5BjGP1NPc3JcRzB9NHr3BYcb/UA6B4CVZ5Z2aPaF+y+q5aAK+E48ZySJ9vVXXCF0PUtdywkA0DJu8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/char-mem: read-only PTE after fixup_user_fault() in
  mmap_mem_access()
--

commit 2398e62524e61afe6489b128b93a5b0922afcd83
Author: Eliav Farber <farbere@amazon.com>

mm/char-mem: implement huge_fault support for /dev/mem

This commit switches non-COW /dev/mem mappings from eager remap at mmap()
time to fault-time population using ->fault and ->huge_fault handlers, and
adds mmap_mem_access() to fault in untouched pages before calling
generic_access_phys().

> diff --git a/mm/char-mem.c b/mm/char-mem.c
> index c5761ddedbd7d..b9ed8473baeb7 100644
> --- a/mm/char-mem.c
> +++ b/mm/char-mem.c
> @@ -318,9 +318,92 @@ static inline int private_mapping_ok(struct vm_area_=
desc *desc)

[ ... ]

> +#ifdef CONFIG_HAVE_IOREMAP_PROT
> +/*
> + * generic_access_phys() only follows present PTEs, and a lazily populat=
ed
> + * mapping has none for pages the target has not touched yet. Fault the =
page in
> + * first, so that remote access (ptrace, /proc/pid/mem) keeps working.
> + *
> + * fixup_user_fault() refuses a fault the vma does not permit, so an unt=
ouched
> + * page of a mapping without VM_READ stays unreadable, where the eager m=
apping
> + * left a present PTE.
> + */
> +static int mmap_mem_access(struct vm_area_struct *vma, unsigned long add=
r,
> +			   void *buf, int len, int write)
> +{
> +	unsigned int fault_flags =3D FAULT_FLAG_REMOTE;
> +
> +	if (write)
> +		fault_flags |=3D FAULT_FLAG_WRITE;
> +
> +	/*
> +	 * COW mappings are populated at mmap() time, and a write fault would
> +	 * copy the page instead. With unlocked =3D=3D NULL, fixup_user_fault()
> +	 * keeps the mmap lock held and the vma valid.
> +	 */
> +	if (!vma_is_cow_mapping(vma))
> +		fixup_user_fault(vma->vm_mm, addr, fault_flags, NULL);
> +
> +	return generic_access_phys(vma, addr, buf, len, write);
> +}
> +#endif

[Severity: Medium]
Can a remote write to an untouched order-0 page fail with -EINVAL when
soft-dirty tracking is armed on the VMA?

Writing 4 to /proc/pid/clear_refs clears VM_SOFTDIRTY on the VMA and strips
write permission from vma->vm_page_prot via vma_set_page_prot().  On an
order-0 fault, vmf_insert_pfn_order() calls vmf_insert_pfn(), which calls
insert_pfn() with mkwrite =3D=3D false and installs a read-only PTE:

mm/memory.c:vmf_insert_pfn_order() {
	struct vm_area_struct *vma =3D vmf->vma;
	bool write =3D vmf->flags & FAULT_FLAG_WRITE;

	if (!order)
		return vmf_insert_pfn(vma, vmf->address, pfn);

fixup_user_fault() only invokes handle_mm_fault() once, so it does not take
the second write-protection fault (do_wp_page() -> wp_pfn_shared()) that a
CPU store would take to make the PTE writable.  generic_access_phys() then
sees !args.writable with FOLL_WRITE set and returns -EINVAL on the first
write attempt.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111113045.3536=
8-1-farbere@amazon.com?part=3D3

