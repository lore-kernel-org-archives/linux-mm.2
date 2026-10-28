Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C260606A75A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gMVsWss/
Received: by kanga.kvack.org (Postfix)
	id 4C3CA6B05B3; Wed, 28 Oct 2026 11:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49BAE6B05CB; Wed, 28 Oct 2026 11:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363BD6B05CC; Wed, 28 Oct 2026 11:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18CAB6B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:48:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E87112015E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:48:42 +0000 (UTC)
X-FDA: 85372467684.27.2ABF0E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D721AC0004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:48:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gMVsWss/";
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202521;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WoLnYplPftaOBa6QSFMZqNIkryf8r7D8aUeEXV+6FRc=;
	b=yPI+RweoykC2mAH83QHEDjwQf0+AnnjPuX01gepBmfMf62jKM5bhVh34rnlMDNxbzgPdFd
	dkw2Kj2PsnydUeUUaLcO5CC6YBmUftYDTQeSOmy4bUdtSmjiYxRZe0kXR5/iOWNX+2Bc2x
	3yup5p9E4JpGJNMU4V+FvW4P2yd6erU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gMVsWss/";
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202521;
	b=xavenKymeI5iqEKDAfrfhJtn9AS8JbodHdNjZAygsmmy/aOR8y3Cu8LDySV/Uh+QUE/b9Q
	a+9YuH9tQ4m5CXs76bcF41Xz7Cg4ylbPrw9DMWvr2j2GA3CtcVGuX69ntkXVQrMmMQ5kfP
	u/z6YEd2Slo80sEVUxKi8oyV2ixU/Yw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 222A441210;
	Wed, 28 Oct 2026 15:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BD51F01829;
	Wed, 28 Oct 2026 15:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793202520;
	bh=WoLnYplPftaOBa6QSFMZqNIkryf8r7D8aUeEXV+6FRc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gMVsWss/mr5UF2gkAulV7LLqDWCYhBwv0EGaqSVURwA3s7N2bF5bHvf7z21565lG1
	 bkqr1uaDa1NKGx8SYXe42L5KuT3fqDORAc70B5If6AG069hlF8NFqeTGhPI64JU9xA
	 or0DHmbrla/np7qle8VI2TzjCq8sTUmD0sTwHDTJX5630CIC36Lm7ro17fN0Xf6Ewy
	 xw8bok+nH9cA3HyOt0oPc1YJxwyhWsxgs4i6KtdE5NGSOLRtDmix4PowmuGZONzvOo
	 VdIAI/BI/UyhxMQcj4s08hPRNII6FoLnGTOBdysIzV3yRy2pOdIvvUBcioFVv8BieY
	 ucEp+DO+7JhQg==
Message-ID: <sashiko-outbox-188087@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 05/14] KVM: guest_memfd: Export PFN mode files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fred Griffoul" <griffoul@gmail.com>, "Ackerley Tng" <ackerleytng@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, "Sean Christopherson" <seanjc@google.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Kevin Tian" <kevin.tian@intel.com>
Cc: "Alex Williamson" <alex@shazbot.org>, "Alexander Graf" <graf@amazon.de>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Alexey Kardashevskiy" <aik@amd.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, "Ashish
 Kalra" <ashish.kalra@amd.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Baolu
 Lu" <baolu.lu@linux.intel.com>, "Bill Wendling" <morbo@google.com>, "Borislav
 Petkov" <bp@alien8.de>, "Catalin Marinas" <catalin.marinas@arm.com>, "Christian
 Brauner" <brauner@kernel.org>, =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Connor
 Williamson" <connordw@amazon.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "David Hildenbrand" <david@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "David Woodhouse" <dwmw2@infradead.org>, "Erdem
 Aktas" <erdemaktas@google.com>, "Frank van der Linden" <fvdl@google.com>, "Gregory
 Price" <gourry@gourry.net>, "H . Peter Anvin" <hpa@zytor.com>, "Hugh
 Dickins" <hughd@google.com>, "Ingo Molnar" <mingo@redhat.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "James
 Houghton" <jthoughton@google.com>, "Jan Kara" <jack@suse.cz>, "Jianxiong
 Gao" <jxgao@google.com>, "Joerg Roedel" <joro@8bytes.org>, "Joey Gouly" <joey.gouly@arm.com>, "John
 Starks" <John.Starks@microsoft.com>, "Jonathan Corbet" <corbet@lwn.net>, "Justin
 Stitt" <justinstitt@google.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Michael Roth" <michael.roth@amd.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Nathan Chancellor" <nathan@kernel.org>, "Nick
 Desaulniers" <ndesaulniers@google.com>, "Nicolin Chen" <nicolinc@nvidia.com>, "Oliver
 Upton" <oupton@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Robin Murphy" <robin.murphy@arm.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Shuah Khan" <shuah@kernel.org>, "Steffen
 Eiden" <seiden@linux.ibm.com>, "Steven Price" <steven.price@arm.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Tom Lendacky" <thomas.lendacky@amd.com>, "Tycho
 Andersen" <tycho@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Yan
 Zhao" <yan.y.zhao@intel.com>, "Zenghui Yu" <yuzenghui@huawei.com>, x86@kernel.org, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Fuad Tabba" <fuad.tabba@linux.dev>, kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261027154649.91571-6-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
 <20261027154649.91571-6-griffoul@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:48:36 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D721AC0004
X-Stat-Signature: wwkrtu5ghif3jn8y9cgzade1ie6e4q89
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793202520-709897
X-HE-Meta: U2FsdGVkX19N75JIH7ZgZcVDtJlyCY24T4HHEC6Q981mC8j3U3H2ty8ZC/UoV9R3ttEcx+fggPNYbXpqFl11bydKFux99C0UvySk3tsRx72BJldJRCaYrT6vansw1HJ0BAyvIi0PdSHhVQQwY2culjx7hvRk8Vx+habB0i5RIZ25rLgIzLhiWXeAXZsnKAKRhBvRQiqC9ewb0W3Zh6H9WYBdTpute8K0IJcyGK9xOU/IVOu4GXa8CCO5EIokERR3cpe2hZqAjxo+nVv14vV9ZH3fMlI+Z5wQO9Jxb9bwFaIf4HmXV1oGSy/sy18uA8XwHvOt70jo52ydgamGGB6yrUNoXOjuxSzbDXbbOnT1E1lI3sUBekshykzk/ncOevk9z7sGtQbN3bgpcV+/ywTGxVfzQTNKbfi/QvoIT6/0H2n5prXASyX31kKG1jcEKcvaju6TIRiliCE1Ygh4MeiuciFlcZthW40KuZyJgKLEiPIGnxYf9+aDI0iFZTfisQ5E0O3VeOpZvCse+aPKIc/c6KcAKHVXa4IhnGdDJj8VtfJ8slh9mN54+B73W/2IgvfEUJZy/R2s5CdoeCgKZ3bCa/9dC5Q8xkjOK7Ldv91eEe006vL9gwL+7ZUomfrr3NfvuuAdZLGKsF+0ibw8bPdKW4YR+/zgaExQMc+v/mg1pAZMG4WxUF46ZPHXYoijfCBe18rPNZYg1B8vbzA833K66hrVixcdYWCx0rU9vwjxOXby26MUr1Do706YPr0/XCgBHNZ9jyCHaQaCQHdUGSXwtPpkMQLfBZNtkXz/5uUod2kMAnQ6vCSk3kpHrnMHGjrV90NMC7okMk8zGV75VtPFzbn3rozeJyCzpI0nFuZJSu/1mCn9YkP56fU+LNFxStA7ZMJXy9dmEBHhZuyhDIFwQ0+rEzIlpQ0WAXI6epDwXuVs29ZJyZOFYPb1rbsP4ZFSyKSSh84wy0KoqVG5bpe
 YiPXROqP
 tj7F+PGZzz9U29/1VsRYHE6R6tq5kZwwBY8HcU41T7is7HfR9qgQWgZS5or98UHznZCMWl3BhhwJyb6sKqHbaRIiIs96WGK/DhTmP5U1BGayvFCoMqOsVVI/ImH63pg9nGvDqSVc1HDFAqTejft+T/JeLV14UYt6BZqVzAztCDHi/PwEkPWLyiWr9P2vBQDtIzZEZBJLB5UMaYHyCfmwBABXEEces3BQlw3LsXqXcLFxGl9SKz7VzoPmK33U5ycDIWoYk8emlIKjBUwynUC1M+cbkSVYKniPvNffBWYne2KcemF1i0Tjcb9utavgrdRQU2XD9M5GxTTtiipIV23zyVjUXl4g9jqfmQfjnnErONSC2JA1S7LnYhfj3MjIFNGfj8vhoAv73RPr82d9rXThqeelsUZWcOmhD1acMJXLZriHsQwg96tb29CSKEljL3G4Tf/SQI6NwoqbmxnGBgADCM3pNPMfRFl5uWUpgcLptUHXekmIehwQMBH4Q9HSUhBW9pmcoxMu+o9roKwmsrdcQEstn9764weiwZ4ocpNd/5JrI4RaSPc2paj3LSJ67qFs9aI3PYnpvqVdxjTIuY1N8d9l/8M8otY4qn4hk5I3xp0jm5gfHkZkTavLsRbXH3zaUkI4NXNaSjk0TAFsFCar0Kh9Yl5ymxGNxjDqamZNSUr3oqkPx10LKwU/2+DMff7ASUwGd1jxxRlSIlKvhjYYbO+YQluWSqnmZftg4Muy/GKlDsjk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] KVM: guest_memfd: clamp export block order to i_size in kvm_gmem_e=
xport_pfn()
- [High] KVM: guest_memfd: missing barrier and range tearing in kvm_gmem_ex=
port_pfn()
- [High] KVM: guest_memfd: TOCTOU race between lookup_pfn_range() and get_p=
fn() in kvm_gmem_export_pfn()
--

commit 3bf31837d177882cb062328d3af172d19383cf4c
Author: Fred Griffoul <fgriffo@amazon.co.uk>

KVM: guest_memfd: Export PFN mode files

This commit enables export consumers to attach to PFN mode guest_memfd
files, looking up frames via lookup_pfn_range() and get_pfn(), and
updating exports across revocations and hole punches.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 65a951fa49c26..015f6657c3863 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c

[ ... ]

> @@ -515,15 +521,32 @@ static int __kvm_gmem_revoke(struct inode *inode, p=
goff_t start,
>  	kvm_gmem_invalidate_start(inode, start, end, filter);
> =20
>  	if (kvm_gmem_is_pfn_mode(GMEM_I(inode))) {
> +		struct gmem_inode *gi =3D GMEM_I(inode);
> +
>  		unmap_mapping_range(inode->i_mapping, offset, len, 0);
> +		/*
> +		 * A punch hole gives the frames back only after the reclaim:
> +		 * until then, lookups find holes.  Afterwards, the exports map
> +		 * what the provider backs the range with.
> +		 */
> +		if (put_pfn_range) {
> +			WRITE_ONCE(gi->punch_start, start);
> +			/* Pairs with the smp_rmb() in kvm_gmem_export_pfn(). */
> +			smp_wmb();
> +			WRITE_ONCE(gi->punch_end, end);
> +		}
> +		kvm_gmem_update_exports(inode, start, end);
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
>  		if (pfn)
>  			kvm_arch_gmem_reclaim(*pfn, nr_pages);
>  		else
> -			kvm_gmem_pfn_reclaim(GMEM_I(inode), start, end);
> +			kvm_gmem_pfn_reclaim(gi, start, end);
>  #endif
> -		if (put_pfn_range)
> -			gmem_provider_put_pfn_range(GMEM_I(inode), start, nr_pages);
> +		if (put_pfn_range) {
> +			gmem_provider_put_pfn_range(gi, start, nr_pages);
> +			WRITE_ONCE(gi->punch_end, 0);
> +			kvm_gmem_update_exports(inode, start, end);
> +		}

[Severity: High]
Can clearing gi->punch_end with a plain WRITE_ONCE() here race with a
concurrent lockless reader in kvm_gmem_export_pfn()?

In __kvm_gmem_revoke(), after the first kvm_gmem_update_exports() finishes,
the consumer lock is released while kvm_gmem_pfn_reclaim() and
gmem_provider_put_pfn_range() execute (which zero pages and update provider
state), and then gi->punch_end is cleared via WRITE_ONCE(gi->punch_end, 0)
without a release barrier or smp_wmb().

On weakly ordered architectures, can the store setting gi->punch_end to 0 be
reordered ahead of the stores in kvm_gmem_pfn_reclaim() and
gmem_provider_put_pfn_range(), allowing a concurrent kvm_gmem_export_pfn()
to observe punch_end =3D=3D 0 and map the frames before reclaim or provider
state updates are visible?

In addition, kvm_gmem_export_pfn() reads punch_end and then punch_start
without holding inode->i_mapping->invalidate_lock:

virt/kvm/guest_memfd.c:kvm_gmem_export_pfn() {
	punch_end =3D READ_ONCE(gi->punch_end);
	/* Pairs with the smp_wmb() in __kvm_gmem_revoke(). */
	smp_rmb();
	punch_start =3D READ_ONCE(gi->punch_start);
	if (index >=3D punch_start && index < punch_end)
		return -ENOENT;
}

Because kvm_gmem_update_exports(inode, start, end) only notifies exports of
[start, end), an export consumer mapping a disjoint file range (such as
[200, 300)) can skip taking its consumer lock during a hole punch on
[500, 600). If a lookup for index 250 reads punch_end =3D 600 during that
first hole punch, and a second hole punch on [0, 100) then writes
gi->punch_start =3D 0 before the lookup reads gi->punch_start, won't
kvm_gmem_export_pfn() observe a torn range [0, 600) and falsely return
-ENOENT for index 250?

[ ... ]

> @@ -1310,28 +1330,83 @@ static bool kvm_gmem_range_is_shared(struct inode=
 *inode, pgoff_t index,
>  	return true;
>  }
> =20
> +/*
> + * PFN mode: lookup_pfn_range() first, so that nothing is allocated, then
> + * get_pfn() for the order and attributes.
> + */
> +static int kvm_gmem_export_pfn(struct gmem_inode *gi, pgoff_t index,
> +			       unsigned long *pfn, int *max_order, u32 *attrs)
> +{
> +	pgoff_t punch_start, punch_end;
> +	int order =3D *max_order, block;
> +	unsigned long raw_pfn;
> +	size_t nr_pages;
> +	kvm_pfn_t frame;
> +	int r;
> +
> +	/*
> +	 * The end first: a new end comes with its start, and an old end of 0
> +	 * makes the window empty.
> +	 */
> +	punch_end =3D READ_ONCE(gi->punch_end);
> +	/* Pairs with the smp_wmb() in __kvm_gmem_revoke(). */
> +	smp_rmb();
> +	punch_start =3D READ_ONCE(gi->punch_start);
> +	if (index >=3D punch_start && index < punch_end)
> +		return -ENOENT;
> +
> +	r =3D gi->provider_ops->lookup_pfn_range(gi->provider, index, &raw_pfn,
> +					       &nr_pages);
> +	if (r)
> +		return r;
> +
> +	r =3D gmem_provider_get_pfn(gi, index, &frame, &block, attrs);
> +	if (r)
> +		return r =3D=3D -EFAULT ? -ENOENT : r;

[Severity: High]
What prevents the page at index from becoming absent between
lookup_pfn_range() and gmem_provider_get_pfn()?

When a consumer calls kvm_gmem_export_lookup_pfn() holding only the consumer
lock, neither the provider lock nor inode->i_mapping->invalidate_lock is
held across these two calls.

If index is present when lookup_pfn_range() runs, and another CPU starts
revoking index (marking it absent in the provider and calling
kvm_gmem_revoke(), which then waits on the consumer lock in
kvm_gmem_update_exports()), kvm_gmem_export_pfn() will proceed to call
gmem_provider_get_pfn() on the now-absent index.

For an on-demand provider where get_pfn() populates absent pages, won't this
allocate and re-populate the range in the middle of the revocation (leaving
the revoked frames mapped after update() runs), or deadlock if get_pfn()
acquires the outer provider lock on its allocation path while
kvm_gmem_revoke() holds the provider lock waiting for the consumer lock?

> +
> +	order =3D min(order, block);
> +	if (frame ^ index)
> +		order =3D min_t(int, order, __ffs64(frame ^ index));
> +	/* Nor may the block reach into a punch hole. */
> +	while (order &&
> +	       round_down(index, 1UL << order) < punch_end &&
> +	       round_up(index + 1, 1UL << order) > punch_start)
> +		order--;
> +	*pfn =3D frame;
> +	*max_order =3D order;
> +	return 0;
> +}

[Severity: High]
Should kvm_gmem_export_pfn() (or __kvm_gmem_export_lookup()) also clamp
*max_order so the returned block does not extend past inode->i_size?

If a guest_memfd file is created with a size that is smaller than or not
aligned to the provider's contiguous block size (for example, a 4KB file or
a 2MB + 4KB file backed by 2MB order-9 provider blocks),
gmem_provider_get_pfn() can report block =3D 9 for an in-bounds index.

In __kvm_gmem_export_lookup(), the trailing loop checks whether the block is
shared via kvm_gmem_range_is_shared():

virt/kvm/guest_memfd.c:kvm_gmem_range_is_shared() {
	mt_for_each(&GMEM_I(inode)->attributes, entry, first, index + nr - 1) {
		if (kvm_gmem_get_attributes(inode, entry) &
		    KVM_MEMORY_ATTRIBUTE_PRIVATE)
			return false;
	}
	return true;
}

Because kvm_gmem_init_inode() only populates gi->attributes up to
(size >> PAGE_SHIFT) - 1, indices at or beyond i_size_read(inode) >> PAGE_S=
HIFT
are NULL in the maple tree and are skipped by mt_for_each(). As a result,
kvm_gmem_range_is_shared() returns true even when the block extends past the
end of the file.

Meanwhile, __kvm_gmem_revoke() clamps revocations to max_pages:

virt/kvm/guest_memfd.c:__kvm_gmem_revoke() {
	pgoff_t max_pages =3D i_size_read(inode) >> PAGE_SHIFT;
	...
	if (start >=3D max_pages)
		return 0;

	nr_pages =3D min_t(size_t, nr_pages, max_pages - start);
}

If a consumer maps the whole block reported by kvm_gmem_export_lookup_pfn()
as allowed by the export API, won't this map provider frames beyond the end
of the guest_memfd file that __kvm_gmem_revoke() will never notify the
consumer to unmap?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027154649.9157=
1-1-griffoul@gmail.com?part=3D5

