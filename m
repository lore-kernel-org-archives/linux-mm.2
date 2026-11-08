Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F3E606A339
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cNpmm0k4
Received: by kanga.kvack.org (Postfix)
	id BDB756B05B1; Sat,  7 Nov 2026 19:43:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C046B05B2; Sat,  7 Nov 2026 19:43:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1A36B05B3; Sat,  7 Nov 2026 19:43:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 785A66B05B1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:43:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E294E1403E0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:43:55 +0000 (UTC)
X-FDA: 85410104430.21.99FA617
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3486EC0005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:43:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cNpmm0k4;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098634;
	b=FbZ3TApWjFvuYaJy4dPsr01cNzDxZfh2T61yKAwPz+shGISrPtUphCfhHfqiMTJU3P1N0M
	Ei9mU0zyYuQA3WnPQ1ukRjmowwyic+bLeAihzyLV45g/9mefe62I3/AW6jGc+Jx+3XdFPL
	+S/o1w1k79Xph1u72vp46J/+8nKohlo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cNpmm0k4;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098634;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CqmiBlIkVv2SuMbRjvFgJNQIb4gZ0ITbB/CfU8y6+Z0=;
	b=M/WrTqjjhv7P8uLALL03ASiKakrw9pQM3pBzkaqTgk5NmJ4L173c6kjbnH7Tia6acfZEv+
	eMO2Cpk8rPb6LPf62/JSmCSjKsdsmF0xuFj4STeoEQsIA4GLPLEZLW7Pb8xgevwarpeM4P
	Xe6D6dpN/KB9f3kGS5QX0MhOgLx4coU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FCAE401CF;
	Sun,  8 Nov 2026 00:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A181F008A5;
	Sun,  8 Nov 2026 00:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098633;
	bh=CqmiBlIkVv2SuMbRjvFgJNQIb4gZ0ITbB/CfU8y6+Z0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cNpmm0k4uTjSQOK0Pfe7mwdnEJlmaNrsFZXsO0nFarGW+FzcZR9xEZfBM7FXL7i7p
	 bH26q8JfzF2ED0iiKR7z594P7IVtIy9N3/Qom7yWatbl/olaGUqsPIpDRijSV3zbJx
	 Yu+SK9SqTIqiH95a9hkavxN99XfGAETSJpJidvaLXvOjj23kC/ojjR3cXItFl4W0PH
	 YpTDjFFTaM1E9m+G4YucZxBOObf6ZClCsmM+lB8GjilkbB2CRWtT1S3z+k6EDB3Uj9
	 8IzIoLdz5RlWBXEGJ0NeMKdVl6Uknn9YXgrcYhZYL1MDnDpug2e0Fu+kYso8xGD4yr
	 8fYMfpjRk05XQ==
Message-ID: <sashiko-outbox-203415@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 04/88] KVM: guest_memfd: Support provider folio
 invalidation
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-4-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-4-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:43:51 +0000
X-Stat-Signature: ec7uadaop398y1dwupg74q9z1mqmtq41
X-Rspamd-Queue-Id: 3486EC0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794098634-866549
X-HE-Meta: U2FsdGVkX19w5831LW+5wfgACJ5Puk0PAFS/KBPjgcZj82y7rumKZ/nR8+2vOtAiMdgi3JvVaUFpELuKHSzAY0q+19nxe5YhfAe9eq/LPjSAsu4VdgaEh6I6kWQSMkr8OyCCIfYNHpRWpjke/1XYYJa3sCdAAORJ5fud9gCaWWVzXAO6FkP9uAT4IOBKy6DPHPm0cZsZX4oTb6kN2rUu4SHjF7tGiABa3f8O1L1ev1aSahahW7CHt77ybjnDv51O04AnibQegBQGGMBr9NdYaIls7KJ0IhhNUz1Usfg+h9J6qEHjN3084rfRwONBNZUkGSNcnCsEJkEqHmN9YAfMTBdX1lgVE/2gA5YPkPcPTXhownoFJCgiUJo7VClR3catU92CfRMsEkFKtWVFuBOPpIcQDV2qL7cIjU3Erp/TNU6aiWWk+e8UbJeVk03hUic77WTIoqQxtdOpRnjuEOQkV4f81T2qmMXPXgD0aFx5H17fa4jQX29B7A0eDiEqkPUkjB/9BfVhC9OB99rbZ3GhsxeCcGF/qfR0FO93S5cXE0DzaO34M6uzC2H0Xo7O2k1uyGvChshmFuhEYq/H/KyA7Ihm6xx77borNA+EzpFLAILXk0v0Yf5jiTDPW1N4UxVWpyCi4MG79ALVBwqvNWw+uSupx329WxwHzOGxTGmZT6jSFMQ7pVQekOlA4+Bfs6i3SO0AtHRlA6Uuc1yMR7kgmv3glsKkt1fgm/3voiKGIU22IiQLFdlD3J0Bpn/Sy079YPqWjlYfKtAJZz4GjHDnpcjh0yUfk4SA6D9GyuI6GmQndr83ZgqB9Cwi56dG5jr5nzeKtwQjp5RUSKc1r0VGKrTqzOzn/O1/6l/nC0Fmex3qCKP+hDnuRuVd+gHMxYKdnY6aqmqZM4C0QXGN3JXiLK9H+dznAc24zrCC+6FtDL8AF7vsioVLAvmP3Ob9JHSj4Y3v9ttQSbKk/gnm9HR
 uv90VjYs
 RBkLWB3s/LFMC0J3QAk+eUcE8pJ0xHct3SFmjo/5PiUzzJYy8AFnT6if6QOvewgPGF/bwKcRRH+LZHRVeDtzRneWKJB9kuA9B1S0vXubuHV1PFvWo/4HdwC29iGQNPehVioCBUpXvwt2/S09EMYZD6p65ff64DP/+XOuWSz6ANTCoQDgrnpXujakStABGpFlywaoVx7UUOWoHvb/DOiT6gf6XASmIop4ddShLQfcgNZT8dXB6GozngAHDsyAvH69av4KNPVePf+mZEW/5n6wRbC19Nd+Jgf0668z7jr2bsWg/dzUWwE/ka7Zqab+5ybJ3jAe3p4u1lHgBI0VWsx1Ady78o+e0FQAr1Y4azpzLAtyucOGJcdWo8iS5YAebPxn4pX6+6VtBPw8FMSfZ5qdlRa6x0tsYQgtRSoFuVEyXI3u1HSQb9tighl9pbuWU61L7iiu1pFcDKEctOJJWFe6pIuXyrt7UGj1pZTVuKi4bVf/OgTr8UmvecbCenfM+G7J6QHEvT9jl0V7ZWgr/2aYA0ebeP/jt5mwpQhX9/x+aS1gqtaYlDEbA5V4YWoT5Hz/1CWEwPY9MoSkTwruVKSwZ3p4jgyDAXz4T4WToKJ16hdxTid1WIKWgSbOGAM5YHS+kFnk4oTWnR1wKJhsUn2XzLt2WKVBGhgxJXWA/PUGn6/dZybfRmoMYbSViOGFGJsEGR2bugOnLxoRkDYZa4kMYnXG94Q==
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
- [High] KVM: guest_memfd: AS_RELEASE_ALWAYS set without release_folio()
  in kvm_gmem_aops
--

commit 2a00824af3a696cc40b4c36a78f74b7c53a20eb3
Author: Ackerley Tng <ackerleytng@google.com>

KVM: guest_memfd: Support provider folio invalidation

This commit adds a provider .invalidate_folio() callback to guest_memfd
and sets mapping_set_release_always() on the guest_memfd address_space so
truncate paths invoke kvm_gmem_invalidate_folio().

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 545c3e646e9c1..ee823f2ef0368 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c

[ ... ]

> @@ -942,10 +950,24 @@ static void kvm_gmem_free_folio(struct folio *folio)
>  }
>  #endif
> =20
> +static void kvm_gmem_invalidate_folio(struct folio *folio, size_t offset,
> +				      size_t len)
> +{
> +	struct inode *inode =3D folio->mapping->host;
> +	struct gmem_inode *gi =3D GMEM_I(inode);
> +
> +	/* guest_memfd only allows truncating full folios. */
> +	if (WARN_ON_ONCE(offset !=3D 0 || len !=3D folio_size(folio)))
> +		return;
> +
> +	gmem_provider_invalidate_folio(gi, folio);
> +}
> +
>  static const struct address_space_operations kvm_gmem_aops =3D {
>  	.dirty_folio =3D noop_dirty_folio,
>  	.migrate_folio	=3D kvm_gmem_migrate_folio,
>  	.error_remove_folio =3D kvm_gmem_error_folio,
> +	.invalidate_folio =3D kvm_gmem_invalidate_folio,
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
>  	.free_folio =3D kvm_gmem_free_folio,
>  #endif
> @@ -984,6 +1006,7 @@ static int kvm_gmem_init_inode(struct inode *inode, =
loff_t size, u64 flags)
>  	 */
>  	mapping_set_inaccessible(inode->i_mapping);
>  	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
> +	mapping_set_release_always(inode->i_mapping);

[Severity: High]
Does calling mapping_set_release_always() without a .release_folio
callback in kvm_gmem_aops cause filemap_release_folio() to fall back to
try_to_free_buffers() and evict guest_memfd folios without invalidation?

Because mapping_set_release_always() makes folio_needs_release() return
true, filemap_release_folio() runs on the folio and falls back to
try_to_free_buffers() when a_ops->release_folio is absent:

mm/filemap.c:filemap_release_folio() {
	if (mapping && mapping->a_ops->release_folio)
		return mapping->a_ops->release_folio(folio, gfp);
	return try_to_free_buffers(folio);
}

fs/buffer.c:try_to_free_buffers() {
	/* Misconfigured folio check */
	if (WARN_ON_ONCE(!folio_buffers(folio)))
		return true;
...
}

When soft_offline_page() -> soft_offline_in_use_page() ->
mapping_evict_folio() runs on a clean guest_memfd folio with no extra
references (for example, a private folio mapped only in the guest page
tables, as kvm_gmem_get_pfn() drops its folio reference before returning),
mapping_evict_folio() calls filemap_release_folio().  try_to_free_buffers()
triggers a kernel warning and returns true, allowing mapping_evict_folio()
to call remove_mapping() directly.  That removes the folio from
inode->i_mapping without calling kvm_gmem_invalidate_folio() (leaking the
provider's per-folio accounting) and without holding
filemap_invalidate_lock or zapping guest page tables.

Implementing a .release_folio callback in kvm_gmem_aops that returns false
would satisfy the mapping_set_release_always() contract and prevent
mapping_evict_folio() from evicting guest_memfd folios behind KVM's back.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D4

