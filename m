Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49983606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=miQzFWbC
Received: by kanga.kvack.org (Postfix)
	id 106CE6B05C2; Sat,  7 Nov 2026 19:44:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B89A6B05C4; Sat,  7 Nov 2026 19:44:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24C16B05C5; Sat,  7 Nov 2026 19:44:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B260D6B05C2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:15 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 547A480304
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:15 +0000 (UTC)
X-FDA: 85410105270.30.BE16459
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C932C120006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=miQzFWbC;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098653;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGBKPRzEO0tszR5z3zc5sWYnix5oTgdEyRhav4QwANA=;
	b=BF2oNg+L7d+kJBNO6ALTbra75Fj++7HgpiYCr+EDZi+j66Uvg6puSRJv47+fuuyvN4JOQ7
	uKccscyXyGdkBQiLxAPWhYmSgz8sfmpLQa5qaNHx3Czw/0QEgnvA3x7RGvrmNiVD+3Ejmj
	o+5GBgEqgWZCzFncjvFkEpi2SvjsXZs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=miQzFWbC;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098653;
	b=yI7CN9SHIZTBXCo+ugC8ppH0gH/UNVrDM5EgWgZCOjWfapyK4D3VexRlIfQZuEgJpWXEYm
	CmIzjZiKV4Eau1r4vbNRP/EDjhh5maoiG8Q3tWPAOE/wIF4uObLNQl3y/7Bl087lyi/MrF
	a7Tvw4kvHuq9l9vD69AktFzVL++PAO8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F8086129B;
	Sun,  8 Nov 2026 00:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417FD1F0089F;
	Sun,  8 Nov 2026 00:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098653;
	bh=UGBKPRzEO0tszR5z3zc5sWYnix5oTgdEyRhav4QwANA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=miQzFWbCpnHfvfdQ32bAxe+xMAtmIT0OgKdkBXv2CN6IIPy/P8g86o8G4bASKpFJd
	 YOAiYHfw66IWmD3ezco3eUWkC9CQF91siIROZjHr5m+KepJ6Dte136RqqG2A3/XIU4
	 U7WGR19JdHQ011rZv4veA5cEP1Ao+KeBVUhFWUvirUVWKp/ywg1FBhbCCB93W/xpQl
	 9l1WWEr5yDtG4nz0xnrhTOV1P2Qm8vHqy7oY0hBitJIPDLg9whGhxwlr5DntXdSV7s
	 eWxrlrVkNsLM1VnRqalToZ+tzP9Bde92IJP1922rzIefvXlNoBvv6wSuPIFyu+kvGf
	 Vy5M7uVfee2EA==
Message-ID: <sashiko-outbox-203460@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 49/88] samples/kvm: Implement lookup_pfn_range
 provider operation
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-49-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-49-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:11 +0000
X-Stat-Signature: j5psdrhm8ebnw8734ad8du33xf5rm6ge
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C932C120006
X-HE-Tag: 1794098653-132415
X-HE-Meta: U2FsdGVkX1/iCTZIqgIxvgHBEvsOmUmC8NJR1QXWHqL7YzcqflcvNyvmKIUt+NH5Z9Ka7STWPQVLiIDSfoaDaNVrdq2o1fbqyNcTkgzk/PmASI8C83Hjaj6A1UJWB4Mhu23AmgoFT5Z/IUUhv2f3B78lXa/hfu0qoAXiTrRbOSeEJILfjIAqxQBaSIk6Po3NighGGD+3YrFVbTizmt2fLeCS9wFrnGAzF6YYsxpBvsrst/i1VY9jg9s79AoFXnPiWC5MDVFEmT4QquQm7Ler0iAFb9d4SEn56aQ/8zZq1BJDznwOATWrSiqCKABZu4b4TOj4XbL91L6HW19ZuINcgQYku6DNi3PVaK7m2KRwPlQhpN1b9quJBWasznPg8sY5mrahV/r21PlmxS3Macc0HC3JpuVkSI0Z2ZkT7ZRBs0yxXKR3d0lXiNgEXNo9kN4tvb9d4ENDnzNIFYlJqRX34DmglyIXP4zDAAhRaWjJ3U7UN1J/YSlETgEQ6u/OtSx0BlFXKHA61lgSoP0lXEK3BkJrFt2pMBVB59YQMsiZY2vgB24/4phjNZ4Pg2/cZ4t0sbRxn3iO7uGsipDNL7E+yLyM+nov7uCEZ8VmqwySbOVSSb8xeD3AtLp/tlMjdO3tFpNqdirfVBTuFes0KL342uXqm5UqQu0npv4f61nPg941c7EkQXi3TZ2gjR3f0Q3Vw7qV92yExDCBfSLCzvyj1Pv7ReUQm10YRFKPffB2eyV38AYTX7WFv0n9DURZ/UvJThUYKnNDfBj0eexYoR3iSsp8FbrErGPumA3yiWgrZ5DTmwSeLe3tCdH0uX+A4NDYov7u6MFTWW7T00Y9gVUPTU8Qt69m7rcxRGiS46+bmyYA+ZukAGD6JW66IR9HH5iPw0gsBWTa1PWcaTMhyHmGEeeYuJ6NebWjcrjiJVMYIlqoRyGqbNqHnU14+tbxtlUyU5v4q8dylAEXJXtRKGa
 ACCPIpfH
 Mo6cQU9v899r+z/EjUlDnGamcvpd2lI/k9gctCoYlEut1vXG89YShwDtPj7ERQYP9TvBm/1WISVTozoE0ZA076ySOOQwI+WlMlhZVdoXzQqpEkrctpqJlLpE2g0AaiUNYIqNR6ZWmcHu4x67RjTZEoWPyf3rHa6LVoykabd+U1XxUVQGMd8HsSL8f3bHPavAenE2rXqY2rH4frrNH8U3S6+qhf6pwUC9f+cuG/tOuldfBnWPMg4MsGl37X3oK1b8SIpLgFd96L02QV85EMKzlzYMfFng3OkJw7xEU6lULBRYLM1Nih1QpHTfBcX+7QsQFaXA0C2e8OWAgvZLx/j2qV14Hc4QCPGdykl6OmvFDOWL7fNQO19dljolbqpLAVcfenkrz80nWKrnzyc55gTbGmxvDJnb7WLdMlubh48J30THt3J+jbCRmRp9uuJJ5XiwpLAqa3I/7yhY2M3MfITW9+yOqNqIXnbrcCpO+FppGVsgKaLcqHAIRRe58uioN4DUKVq5fWcgrOJOLHm2akC39NAw3gc9LUezL8vSTYL4C+Fio31j8HMp7f5Uxgx8S8adkYeOuwBwEeO/FulLKtO4qVCMkePhDTfLDBqjT6vO21wbor4K3oMxpM4U66iQ8EOWJMTEtlQ5ElvKm2ifvlE16ZlkKh/MwR+tJ5QAgBSz7UI/k4oO/H+uDcn9un8sULOD4PlF7YALjoBM7Xh12HlLHYo9T8A==
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
- [Medium] samples/kvm: unexpected -EINVAL from
  mp_gmem_lookup_pfn_range() past npages
--

commit 547b053613c36c4e6a545e75a670dd8b4151e0c0
Author: Ackerley Tng <ackerleytng@google.com>

samples/kvm: Implement lookup_pfn_range provider operation

This commit implements the .lookup_pfn_range callback in the sample
memory provider so that it can act as a PFN-mode provider for
guest_memfd.

> diff --git a/samples/kvm/memory_provider.c b/samples/kvm/memory_provider.c
> index 926f3cf68ed49..7fb7365b65940 100644
> --- a/samples/kvm/memory_provider.c
> +++ b/samples/kvm/memory_provider.c
> @@ -249,10 +249,34 @@ static int mp_gmem_get_pfn(void *provider, pgoff_t =
index, unsigned long *pfn,
>  	return 0;
>  }
> =20
> +static int mp_gmem_lookup_pfn_range(void *provider, pgoff_t index,
> +				     unsigned long *pfn, size_t *nr_pages)
> +{
> +	struct file *resource_file =3D provider;
> +	struct mp_info *info =3D resource_file->private_data;
> +
> +	if (index >=3D info->npages)
> +		return -EINVAL;

[Severity: Medium]
Does returning -EINVAL when index >=3D info->npages trigger a WARN_ONCE()
in kvm_gmem_pfn_reclaim() and kvm_gmem_make_shared()?

Neither kvm_gmem_attach_resource() nor mp_gmem_attach() rejects attaching
a guest_memfd whose inode size exceeds info->npages << PAGE_SHIFT.  When
closing such a guest_memfd, kvm_gmem_destroy_inode() ->
kvm_gmem_pfn_reclaim() walks up to i_size_read(inode) >> PAGE_SHIFT:

virt/kvm/guest_memfd.c:kvm_gmem_pfn_reclaim() {
	...
		r =3D gmem_provider_lookup_pfn_range(gi, index, &pfn, &nr_pages);
		if (!r || r =3D=3D -ENOENT) {
			step =3D min_t(size_t, nr_pages, end - index);
			if (!r)
				kvm_arch_gmem_reclaim(pfn, step);
		} else {
			WARN_ONCE(1, "unexpected lookup_pfn_range error %d at index 0x%lx\n",
				  r, index);
		}
	...
}

Once index reaches info->npages, returning -EINVAL hits the WARN_ONCE()
and falls back to step =3D 1, iterating one page at a time across the
remaining unbacked range in an unkillable loop.  Should this return
-ENOENT with *nr_pages set to cover the unbacked tail (or should
mp_gmem_attach() reject oversized guest_memfd inodes)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D49

