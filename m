Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7612606D806
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ml2bXKue
Received: by kanga.kvack.org (Postfix)
	id 60FC86B05BF; Sat,  7 Nov 2026 19:44:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0336B05C1; Sat,  7 Nov 2026 19:44:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4857F6B05BF; Sat,  7 Nov 2026 19:44:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF486B05BF
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88005A8003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:11 +0000 (UTC)
X-FDA: 85410105102.07.D1A214D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C5279140002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ml2bXKue;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098650;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v+jhNrXXVDS4u+Yd6VZIyLG/BiyfW1WPw7MYWGJkhqU=;
	b=GlpAEGV3pEERFV6A28d+8A/euYX4Pf+zrLJavzGj+ev44S1NoZc93xTnkcP0bNEtfn6OX2
	WPgN8ZK/wQB7IZHloqfxBkI88TlONIuI80uGBhHvxfaujXHVO3TI0yjCWmmqJiw9/ej98R
	8VIlz6C/vO+5InNQdE//hgnu2qiJyFg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098650;
	b=kKn9MDJUw+GCnYmbgLSFEhLnvMklwJTCLDrfihEeFRi1wMANo/zD1LyN/Ux/jAHg0X64U5
	p6v9N0gHUy8UOnNIy3NgidD6D86Gmxk5sJUHqpEI5wR2alrlFNsJSTt0s72utOOTwHHx7u
	ZiPP6FTnlFhlmRKQzbVqvp1EnaVO7aQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ml2bXKue;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2299940701;
	Sun,  8 Nov 2026 00:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1466A1F0089F;
	Sun,  8 Nov 2026 00:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098649;
	bh=v+jhNrXXVDS4u+Yd6VZIyLG/BiyfW1WPw7MYWGJkhqU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ml2bXKuet1505fUBnmoB87l+0gzcl/0EbyRzXhZAyefnHuIj1veZwCY1sWza0nNUi
	 STfnrpMTvMrnJDQ7wDBPcCwloqmPrzpByN20LGqoXAhSzRv6AwLZFna9uyLKBFpKKP
	 Er1PZ3GhkNbd/AoDYvsfzYNjHmEI1g4SqcAsH64OOnMW+UCmxzx09Mhd207Id1sHFe
	 VVPWf+SZcLRV2BTJ8FDt8SDV6QW6TIH6ZKFBovpjEQKzPdRQJYXeeHVvkxJHVZ9ULG
	 xYij8zhUp6dLnoFt4gnokQlu7A6rGKKRQfoY3VR+xxp9mSOV5m23YOBJlKjLl/WMHE
	 KrL9NTLTAdMCw==
Message-ID: <sashiko-outbox-203453@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 42/88] KVM: guest_memfd: Export kvm_gmem_revoke
 for provider-driven revocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alexey Kardashevskiy" <aik@amd.com>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Woodhouse" <dwmw2@infradead.org>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jianxiong
 Gao" <jxgao@google.com>, "John Starks" <John.Starks@microsoft.com>, "Michael
 Roth" <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Sean Christopherson" <seanjc@google.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Fuad
 Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261106-gmem-alternative-providers-v3-42-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-42-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:07 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: w51sjxbozo6t36nxi4nbw7byeypdidit
X-Rspamd-Queue-Id: C5279140002
X-Rspam-User: 
X-HE-Tag: 1794098649-286892
X-HE-Meta: U2FsdGVkX18NxbXRRCDh9NAaKzG7nCmF91RxPRvvYqkXqWdNZ1Rrubt6iPjX6vjZgGEmhOUpwc3DY3HcCk78iCkO92kWlVPTmUoHhZrMivPe8Jopl/Je9dnMVawZXTrCJ/aIbxA+p2qk6GmGevdUgs7hmJGxPupcfRj8aKDgwd8SfkZumJg9dgnDPXK9gHPPOB7OqR2erOjkEGIvInbnBhO3QeVTFl3h3ZbxiHD/6J/fNHmg+MA9OG5BhTyXMnJsHP/pQTHbSWd8G7Yw75+GbbwgIYHiGJRvtafWFPIHeqVL99CMCkjbbHRfF/j340FKoZtS3XDkIrp7VsONGA/+lVal5gc5TkgtcNPK8aQSZUV9No8qlRfyMXYQOZ88UxC2hvxDGApxmnGeXLEcw8YPzoEBqNFP79E8mfmNjpKOykL3sICXOjMwO8Sh8jyreuc3RYB2kzJIvx6hpAtlxBc1bs9sbwPB44qs6/Bgiyu2WB066VZTj3RpAve9lCNG+RZlTTo+2jBxSmAdI9UKsVyXAJO96QOQCe79QLMuoMc7mMYNxdqc3Dh1/77p4l0Httc5LIt8rYw2UcbFk7KSHqpa2cAuizWF1c/uKl6YLrf1WxxNlJGtRbmGruHRwX0NFdbF0A5YiLRbr94E40ggu9yRfCbZls5BJWUvd9fKOO8hlFFytCD6ej9RgcaxvWzpHe2AsqCzMWy4GttSlX1P3Z6+jYQMvWrqQMlHhlWaEhH12pFipWJ8AQ2mzR2tAI0/8+JWOsdCpsy1z6VpLRnPD/pKKWnMD1bMLvrQ+VstaItGntdnSgcoTs/Av2B8zvBWAH50FcCbTyT8KHZ7XL9Ivg8k2DC+BC/pZAg9qTjLaeB09KWZ/1OZiAvRj3ITF0sflPXKpFuYamREQG49RRfWVBNHYofZepagEOEzw1Lw7HYataFG9yb0/MV2vjLiiKMO/a8rl/AQDQx+3llQWN3J0pz
 y2ilpbWD
 DNmyESnGyBENNYGPkcMS+l2625lWEywKMU/g4gxRnkkxXu9+/v6fuX3OTj8Boi8SX12HLyOAHhXocP3n6vZTt7S+HimXq2l1/vs/En3E5Ur1NncOfyCCCGLfyQdT8+3cvIf92QEkEs36UEOJDZp7IhpJh+ln6AHacl6Y/YGATMBrPLIQjZxs3xTWsub3Ikvi2yhyRZNHReXzo9hG0Ol5tV9C8Nufab923AummdDAudQsKf4vc5dB8qrC6cczxupMxe54IcjMcfUfTxLqZm9qgw0UMwzbavpc/6oYN+4ur9J7oZjqjLZEHB0cA6rnkxNzuv9cCQcgfBQwwv2O9vpf179edw8ppatA8LJmT3EOy/QSNFlT9COGnJ4x2JFxc3jKDbd4Yp8lJJK/lypTZYTTROSK/3yFBf4JwMCDH1ugbMldit8Tv0u7Ak3RY9p+Bnb70M9tYzbEYs46wtyLsARbl5+CSX+zDmr7Hk8b4lDB+YJctX4W0uwTL9XFnJRZMNMJUU0+TSd6RtEhH+PhUnEAxgAJSiagvHdijhjWEu77ifUSrIm//6AJxF2dPBLzbh2jCrLKeN4vHrb1/OI3O4qqOAYKJePsKx0I20xsNPJK5lHIJ8Mr8sRJaYaUBL9rUFJqPDm9XWdu6vbbdts85AefHQdBdLmvOcl3YgDE5k7WLU3UqI6r36iS/UepHlNx3M5l1bW2fsI/rAhFY4nPA+lKU3M/jUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] KVM: guest_memfd: race between kvm_gmem_revoke() and inode
  teardown
- [Low] KVM: guest_memfd: stray @mmap kernel-doc entry in guest_memfd.h
--

commit 3bc97f7ff873e4720a82787260ba8378c8ce9990
Author: Ackerley Tng <ackerleytng@google.com>

KVM: guest_memfd: Export kvm_gmem_revoke for provider-driven revocation

This commit introduces __kvm_gmem_revoke() and exports kvm_gmem_revoke()
so external memory providers can revoke physical memory ranges from
guest_memfd without calling back into .put_pfn_range().

> diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
> index 697f8f8c9b0ae..fb2279a001ebf 100644
> --- a/include/linux/guest_memfd.h
> +++ b/include/linux/guest_memfd.h
> @@ -28,8 +28,13 @@ struct mempolicy;
>   *           @pfn with uniform @pfn_attrs in @max_order. Once @get_pfn s=
ucceeds,
>   *           the provider must keep the @index-to-@pfn mapping and @pfn_=
attrs
>   *           constant, and the memory accessible, until guest_memfd stop=
s using
> - *           this page. Returns a negative error code on failure. The pr=
ovider
> - *           must define @lookup_pfn_range when @get_pfn is defined.
> + *           this page. Do not take locks held across kvm_gmem_revoke().
> + *           Returns a negative error code on failure. The provider must=
 define
> + *           @lookup_pfn_range when @get_pfn is defined.
> + * @mmap: Optional callback to set up user mappings. Called when userspa=
ce calls
> + *        mmap() on guest_memfd. The provider can customize VMA flags,
> + *        cacheability/protections, or reject the mapping. If not define=
d,
> + *        guest_memfd falls back to default mapping behavior.

[Severity: Low]
Does this @mmap kernel-doc entry belong in this commit?
struct guest_memfd_provider_operations has no mmap field here, which
triggers a scripts/kernel-doc warning and leaves a duplicate @mmap entry
once commit "KVM: guest_memfd: Support mmap provider operation" adds its
own description later in the series.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 1b6fc44ba00bb..023bf095340be 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c

[ ... ]

> @@ -469,6 +482,45 @@ static long kvm_gmem_punch_hole(struct inode *inode,=
 loff_t offset, loff_t len)
>  	return 0;
>  }
> =20
> +static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff=
_t len)
> +{
> +	return __kvm_gmem_revoke(inode, offset >> PAGE_SHIFT, len >> PAGE_SHIFT,
> +				 NULL, true);
> +}
> +
> +/**
> + * kvm_gmem_revoke - Revoke and reclaim a range of memory in guest_memfd.
> + * @inode:    The guest_memfd inode.
> + * @start:    Starting page index within the file.
> + * @nr_pages: Number of pages to revoke.
> + * @pfn:      The physical address / frame number being revoked. Directly
> + *            reclaims this physical range without querying the provider=
's
> + *            .lookup_pfn_range().
> + *
> + * guest_memfd will do everything to make sure the range revoked is no l=
onger in
> + * use across guest and host mappings, as well as reclaim any confidenti=
al
> + * architecture state.
> + *
> + * Before calling kvm_gmem_revoke(), the caller must ensure that future
> + * .get_pfn() calls for the revoked range will fail so new mappings cann=
ot be
> + * faulted back in after kvm_gmem_revoke() releases the inode's invalida=
te_lock.
> + * Must be called before accessing, freeing, resetting, or powering down=
 the
> + * backing resource, and the caller must keep the @start-to-PFN mapping =
valid
> + * and accessible until kvm_gmem_revoke() returns. .put_pfn_range() will=
 not be
> + * called.
> + *
> + * Acquires @inode->i_mapping->invalidate_lock exclusively; callers must=
 not
> + * hold any lock that is also acquired inside provider callbacks.
> + *
> + * Return: 0 on success, or a negative error code on failure.
> + */
> +int kvm_gmem_revoke(struct inode *inode, pgoff_t start, size_t nr_pages,
> +		    const unsigned long *pfn)
> +{
> +	return __kvm_gmem_revoke(inode, start, nr_pages, pfn, false);
> +}
> +EXPORT_SYMBOL_GPL(kvm_gmem_revoke);

[Severity: High]
Can kvm_gmem_revoke() race with inode teardown in
kvm_gmem_destroy_inode()?

virt/kvm/guest_memfd.c:kvm_gmem_destroy_inode() {
    ...
	if (gi->provider_ops && kvm_gmem_is_pfn_mode(gi)) {
		pgoff_t nr_pages =3D i_size_read(inode) >> PAGE_SHIFT;

		kvm_gmem_pfn_reclaim(gi, 0, nr_pages);
		gmem_provider_put_pfn_range(gi, 0, nr_pages);
	}

	gmem_provider_release(gi);
    ...
}

Because provider callbacks cannot take provider locks held across
kvm_gmem_revoke(), inode->i_mapping->invalidate_lock is the only lock
serializing kvm_gmem_revoke() against reclaim and .put_pfn_range(), yet
kvm_gmem_destroy_inode() runs both without holding
filemap_invalidate_lock() before gmem_provider_release() detaches the
provider:

CPU0                                  CPU1
iput(inode)
  evict()
    kvm_gmem_destroy_inode()
      kvm_gmem_pfn_reclaim()
        gmem_provider_lookup_pfn_range()
                                      /* provider marks range absent */
                                      kvm_gmem_revoke(inode, ..., &pfn)
                                        filemap_invalidate_lock()
                                        kvm_arch_gmem_reclaim(*pfn, ...)
                                        filemap_invalidate_unlock()
                                      /* provider frees or resets memory */
        kvm_arch_gmem_reclaim(pfn, ...)
          <-- concurrent reclaim / use-after-free
      gmem_provider_put_pfn_range()

Since kvm_gmem_destroy_inode() does not hold filemap_invalidate_lock(),
kvm_gmem_revoke() can run kvm_arch_gmem_reclaim() concurrently on the same
PFNs and return 0 to the provider while CPU0 is still reclaiming and
releasing the backing pages.  In folio mode, evict() also runs
truncate_inode_pages_final() and clear_inode() before
kvm_gmem_destroy_inode() calls gmem_provider_release(), allowing a
concurrent kvm_gmem_revoke() to call truncate_inode_pages_range() during
or after final inode truncation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D42

