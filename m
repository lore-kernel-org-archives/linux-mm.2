Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C14606A339
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lHrUnolf
Received: by kanga.kvack.org (Postfix)
	id 141D36B05CE; Wed, 28 Oct 2026 11:48:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2186B05CF; Wed, 28 Oct 2026 11:48:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFD726B05D0; Wed, 28 Oct 2026 11:48:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDCCC6B05CE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:48:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05555160166
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:48:50 +0000 (UTC)
X-FDA: 85372468020.24.3DB29EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5130C16000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:48:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lHrUnolf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202528;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgJp/0Bmza7ipLqb+lZFfXeJ26JvK37iVpiObAP88/8=;
	b=wXLxzA+9aYvs7BZcgY5lXyo1FAKFluvn+mLAvckSEhSPMVpkq+fftKylht9eMS/UQsPaSP
	YzBENEOSeYweGdyAd5OyjnY6NGKoLkG05eVmJT228ZJy6IWDArqbwCG1WqWE6cqP5QQvWV
	JWsMJaA12PMwTLQRkYZzAhwpPQGSyiA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lHrUnolf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202528;
	b=uxDQ3Acly2CRB7JT+NQrFRrVYmOjOpUr1lioU4HmZawnQJCGSeKcmunoH+NvvNtqG0Kprd
	RUH0ETxRo8/g7SLIfskOr4TDlDPfOH4/BofZgCAjp47aZeEPvPgx6auazo+lkl+5E5eCxL
	o2QHhhH6oDhDzkAYTvR1Z7Bq9+kb0sM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82F5F43F98;
	Wed, 28 Oct 2026 15:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A94E1F01828;
	Wed, 28 Oct 2026 15:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793202527;
	bh=sgJp/0Bmza7ipLqb+lZFfXeJ26JvK37iVpiObAP88/8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lHrUnolfy+YsLFeyY2tP7vYLm7i3gMc9YoxQBihnfLd27aOjScxlVDU+LhJDcuIGk
	 9qv7MFaNczHRsglMpcqDCwhS4qiUU3IpO3D391xTblXQUT57ysbcvEYFErI43cnjeL
	 9K1jZ1PWdN43Pw9j8eoEnNsR+B2fHKp3G4sBvX2Wr8aaaGW6UPd1ej+lILxKKC6cIi
	 rGd98CbkfubRGrPRcR0rNhK/IOS5vnTbO/pdIARDcX/VuOUfszYRa9TYAXbv/nan2q
	 zWcN8fNOylcY36JomFflZ6CeOtAgsiZT9Ss+/qhfZFn6HEm2jY/v1dhfx7dkNS/Ujs
	 UPY816FNkHuWw==
Message-ID: <sashiko-outbox-188091@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 09/14] iommufd: Map guest_memfd files
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
In-Reply-To: <20261027154649.91571-10-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
 <20261027154649.91571-10-griffoul@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:48:43 +0000
X-Rspamd-Queue-Id: 5130C16000A
X-Rspam-User: 
X-Stat-Signature: ifw16j7u93tpf4xqdeks8crpsc7zcpka
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793202528-814732
X-HE-Meta: U2FsdGVkX1+0bjhhT/kdUKa7toAbguC0hRf3Z2SNElAq53nGMBsXtYabgcvzzw4+ydwISeUiMzVJQvXdaqf3BS+uObT8yMmY79NT02J1chgfK86krNct1giY7qWW9O7tTi4+LFaUtp9ozEZ4YSR+BmyTaDXg42b6lkNkHAdjrLnbaNzL0jYV4CE+2KncvMa5M5T8o6NPQSJGHCcLggzT5PLgD5UY8rssyVsJqPOyWMVAcKaHtwk3M1usd8CS4kD7rD/zzmioL3686ewyJsqwZS115LC7isLJ0GcBcWiry79s6Jq6DW1wqhK0gdsMg2xmtAN7oYLtMUImFNG7f73kHrTBSlYFCuZ7gusYXQkqZaavMPOG4J0L4kZNhh4zHDTFX4VeThdszNdYv5OxzOnbliRbWh4OogHq+6UVxQ2A9SGwDNnCI7GXamRNSE/CInG7OuLlz2+/bAJNW/1nmvAjA4e3ehioP+k60YSUX9Nrc0tUGHMYqn1ER1q8DorqzpcCoYyuELuFRekqftZjgVDvKeiveS5YO4kchp6k6AnzDMtihppZ0tyB/3IvMqmJzCQnI1zghEBQJ1i1GRgZF1OY6bZL60xkzSTyyLbgdWk/iSlb/VjYHOQja4ZRMVadyExNwsV70J4wRg0BqiKPUQT333H6KDPLEesxgBMhPL7+db4n10N//rd2r/h+3GXDiKXSgbG+fY153Aedmr7gCJbOAFFhaUbyivhwqeP/MicQ3JbA4s4FIA8V9pwMqXZrPPVmhXZQP8c055OGLqknp1r7Kq7YvwF5HhN9d9iUtP8acw7qewgcrrJc4+XKcLigyqAntTikIVK+Hr+jeTqPd7KnI83GbEL+3BmWXZIetGJiXO6hyA6JFHzzKpZR+g5M+kVSxQYM86w+Y5qBsWwgpEFynFuIRQ5I/1sdyNZIP7EXV2bckKpI/E3YD1ZPKUTwV0Cb7iE6Yc0hoNkJkGbY/ZE
 WpCC2kNp
 aFXZFycBClIgz56cUbbtc0FkE7v34uQTmjnsDF7vJvXS2cf6wR97Wm8XI7I+n3/uDLsF8FATIkmVGstvrOxj5YShHqlASIyo8zGqeb/HOduORUu8DnolOzDY4Yj+ViJENd4XBaGo5F/NVvL2tlNe2NimiadSIfZ4o0HXOVibaED27v1DnVjkasDbehZFHWKRn7k4LoEG/4l4O2THvX85qhWNVnGD7kIP2eJDDWgTQSNCjvk95X0/AVQSz9l2KvSfn2CJHHubsTZWCc7oOK+xWTZtJWIpUvcGcR55Lw1cotPOBa4wT+QSvEyeFC7vtlFTcAw+7pL+obwZRGFt/+Fo2i3YryQtGwrN/DusGXPNsjD6Xjgrtu3sMgJXZZHs5ZgUzRb0+6/Zr1FDTnGm3HeivpsvlinLrua5JCEbMtNvaIRxXXb/BQjID7l0PE4o+hyt7Og3AHc4reWaaEb4U/FxmvIbooVak2vh3HVNnMoqVuw28SY36FHR+cOKdHcJl6DAt8+HSnhn8k+VMNp0o+qCNu2cv3s/u0OYMbYDugWea3ZBumN/FIX++AtTA0/gG7MXCmcjmHazLuCP2fpEFMzvDc7UEms/q7jJ88p+PSMom4CaLyZNc0Jb0TAaKEebaPvyvtg8cHydQjrcm5W/HiWOufpKfiguFENuvNlaWSOv46rRzbNmusxMzO+WtL/dvOctoIO2bfIr2lLsWLMy7vBh/uHuaE5RcZqpY0+/Va+Ecv2xUWC4=
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
- [Medium] iommufd: missing iova page-alignment check for gmem in iopt_inse=
rt_area()
--

commit bbd05c04a17efd9d7e027af5dc5147510ebf160e
Author: Fred Griffoul <fgriffo@amazon.co.uk>

iommufd: Map guest_memfd files

This commit allows IOMMU_IOAS_MAP_FILE to map guest_memfd files using
guest_memfd's export interface without pinning pages. It maps PAGE_SIZE
entries and updates IOMMU mappings upon guest_memfd update notifications.

> diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd=
/io_pagetable.c
> index 43d518e4ce585..62fa553cdffc0 100644
> --- a/drivers/iommu/iommufd/io_pagetable.c
> +++ b/drivers/iommu/iommufd/io_pagetable.c
> @@ -217,9 +217,13 @@ static int iopt_insert_area(struct io_pagetable *iop=
t, struct iopt_area *area,
>  		return -EPERM;
> =20
>  	area->iommu_prot =3D iommu_prot;
> +	area->gmem =3D iopt_is_gmem(pages);
>  	area->page_offset =3D start_byte % PAGE_SIZE;
>  	if (area->page_offset & (iopt->iova_alignment - 1))
>  		return -EINVAL;
> +	/* guest_memfd frames are mapped whole, see iopt_gmem_map(). */
> +	if (area->gmem && (area->page_offset || !PAGE_ALIGNED(length)))
> +		return -EINVAL;

[Severity: Medium]
Should iopt_insert_area() also check !PAGE_ALIGNED(iova) when area->gmem
is set?

When userspace calls IOMMU_IOAS_MAP_FILE (or IOMMU_IOAS_COPY) with
IOMMU_IOAS_MAP_FIXED_IOVA, iopt_alloc_area_pages() validates the IOVA
through iopt_check_iova(), which only checks iova & (iopt->iova_alignment -=
 1).
Unlike iopt->disable_large_pages in iopt_calculate_iova_alignment(), a
guest_memfd area does not force iopt->iova_alignment to PAGE_SIZE, so
iopt->iova_alignment is 1 when no domain is attached yet, or smaller than
PAGE_SIZE when attached to a domain supporting sub-PAGE_SIZE granules:

drivers/iommu/iommufd/io_pagetable.c:iopt_calculate_iova_alignment() {
	/* See batch_iommu_map_small() */
	if (iopt->disable_large_pages)
		new_iova_alignment =3D PAGE_SIZE;
	else
		new_iova_alignment =3D 1;
}

Later, iopt_gmem_map() derives iova from iopt_area_index_to_iova(area, inde=
x)
and passes it to batch_iommu_map_small(), which expects PAGE_SIZE alignment:

drivers/iommu/iommufd/pages.c:batch_iommu_map_small() {
	if (IS_ENABLED(CONFIG_IOMMUFD_TEST))
		WARN_ON(paddr % PAGE_SIZE || iova % PAGE_SIZE ||
			size % PAGE_SIZE);

	while (size) {
		rc =3D iommu_map(domain, iova, paddr, PAGE_SIZE, prot,
			       GFP_KERNEL_ACCOUNT);
}

This allows userspace to trigger the WARN_ON() in batch_iommu_map_small()
when CONFIG_IOMMUFD_TEST is enabled, or pass an unaligned iova with
PAGE_SIZE to iommu_map() during mapping or asynchronously in
iopt_gmem_update().

Also, in iopt_alloc_area_pages():

> @@ -289,6 +293,9 @@ static int iopt_alloc_area_pages(struct io_pagetable =
*iopt,
>  		case IOPT_ADDRESS_DMABUF:
>  			start =3D elm->start_byte + elm->pages->dmabuf.start;
>  			break;
> +		case IOPT_ADDRESS_GMEM:
> +			start =3D elm->start_byte + elm->pages->gmem.start;
> +			break;
>  		}
>  		rc =3D iopt_alloc_iova(iopt, dst_iova, start, length);

Because iopt_alloc_gmem_pages() sets pages->gmem.start =3D start without
subtracting start_byte (unlike iopt_alloc_file_pages() and
iopt_alloc_dmabuf_pages()), if an unaligned start is passed without
IOMMU_IOAS_MAP_FIXED_IOVA, start_byte is added twice here before
iopt_insert_area() rejects area->page_offset. Should iopt_alloc_gmem_pages()
reject unaligned start or strip start_byte up front?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027154649.9157=
1-1-griffoul@gmail.com?part=3D9

