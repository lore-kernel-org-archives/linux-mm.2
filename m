Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E4C606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 08:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HHd5gRUn
Received: by kanga.kvack.org (Postfix)
	id 4F89F6B08D3; Thu, 22 Oct 2026 04:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9A86B08D4; Thu, 22 Oct 2026 04:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BFDE6B08D5; Thu, 22 Oct 2026 04:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13E926B08D3
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:33:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77AA5C07AE
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:33:12 +0000 (UTC)
X-FDA: 85349597424.14.F361773
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C60AF1A000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:33:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHd5gRUn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792657990;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I7P4Z0m4H0zqdvZ0EHWJXAmTbybltS5XLjPO30+Sp4U=;
	b=WqU5b6lk/Vjjid9n1cW2XmiFlaHqxsRxIIYr7TGcfn0p+lpw60QA/c0ZvYWizvn4wG/zRI
	mHlp/+pAbsxKSliFUMFmKrD/QCQxlNxhpOhTP0U2C4P5xej6pfPf6S3yGXwq95KYp93on4
	seBuJCrmEz/nglq38Oz2YTYR9oOsE3g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHd5gRUn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792657990;
	b=f+yU9aVCrLf9jTmvAyuSACkb3C+oftKvyjhVEPNwgziTfsumhzNhZo4NG1SeBcEPW8zZ4w
	EwfYAFMJKAN2R6JGqMFZETfQcFJBrjdvJqPlyTnIrXkGEA/2M04urs2Z+WVusPCCrJssYG
	zbQQdNlTRhLXmYMWacWbyW51US7wYmY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10D9343583;
	Thu, 22 Oct 2026 08:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3205D1F000C4;
	Thu, 22 Oct 2026 08:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792657989;
	bh=I7P4Z0m4H0zqdvZ0EHWJXAmTbybltS5XLjPO30+Sp4U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HHd5gRUnE0JYDC3bp5XYFM4M/eFH8QH8Dc9624RyNopi6jrA63TrpPxiyLDK/Hxjp
	 dw5vmKunP6b5VJRmYtyolQYedMj8zpkxe4kTSvv6Yx5TLKjoz7LVRCaaJRZ4SmqgXS
	 RM6TsMCxzxI4Qw+eWb4axqtD9EgAr/ui5D8M22eqSDsnysEV9vlhxtFEAf7EDzaMV3
	 LVkNFsb2Og6luB4nAm1yyk8i2bQVKZXnn3Wz1vbnU+J8D78hHl/zN+anlyf9In7npl
	 qFa9L+D6YdrtMpgoGXVDuikaojWF4qso2fNrL2X5Luk7ZwdIzcdEo79jL6ezwFUHb2
	 byjglWZorCaRg==
Message-ID: <sashiko-outbox-181179@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 3/8] crash_core: serialize crash header preparation
 against hotplug
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wandun Chen" <chenwandun1@gmail.com>, robh@kernel.org, baoquan.he@linux.dev, rppt@kernel.org, m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, chenhuacai@kernel.org, kernel@xen0n.name, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, saravanak@kernel.org, akpm@linux-foundation.org, pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev, robin.murphy@arm.com, devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, conor+dt@kernel.org
In-Reply-To: <20261021083011.2170525-4-chenwandun1@gmail.com>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
 <20261021083011.2170525-4-chenwandun1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 08:33:07 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C60AF1A000A
X-Stat-Signature: epuidfu78to4tcg768unq9rdnef4r6s8
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792657990-834931
X-HE-Meta: U2FsdGVkX1+iD775b34KPrcJs3HINdXGsek5R9ro/EgU5TAn5lYmN8iSCl1OP+HEJa1Wk4XrvkotpbUwZD10kp31f+qgXD3SNZ1dPvyTFOpjKOVUCp/WqQ57LtCYYNDXMIOwX2sbTl0uW1ww3ShraDvD2zsP7wjGDZpkQUj+jfNunm90kokIHEUv3AGD8u9Uk3GDMOa+0vrzLk4C6daJrStz0C6nEwkDa4qrUdSlt3b9P0TYBLXSrLT+MKYhpwPrKXIVyeD/FL8C2Bktr8LQ+QUXr4pH6ca9kCTE4WbU/6BSL4Wmto5GM9TpAWFQXpNahHYsikpLD8KjUZ75NfkdDs3Gzp6u4kNTeiFBH+2HZMXG1/Gje/Yh6fUaRzzfL5LWncgGkw/DeAorplmOoM11+XfOLlcLlQecRLaaWY99yoy+DqhyoWLLKm3A1XitWBVTH25eAH1uZvD6Dt0rw1TubNh62UvHnWRmTlfsxQIxNeeMtZJILweNU4tOoH1GX1YwrdoICmmP6mgaQCUnP9ddtIyYY32mmtermI8dHibz1XE6+c4e+t2DxiLXBoLm/rRoYR58yoD1/9TiDupfObm95aSvRJz7t02zyhnJJE7p8V2H9gtg4Tg2TrwkLhmnDRDYm6wpf3E9kgw6rAOCkT60qyBzJaVg+fcwH5Wy+Z9QLHowSiUcx4RY0xOKsjgYHcdaNbfLf94Vt4s9gFvtjLRN1PVaEImLWzpTmcxQIE8RyszGyCLlnha/v5FzvV0NpiYxbj/4yXX3x+Ndh1eP3Wul3MyKXPJ5Wp2jMFuIWP/HMyNzeUu9XvY2+rn/xumKA5mMFOrpYbKR2MM/y4BlDWn6KMTWxvx/1YBGH6FXEz3xg/PVEmC8uZXXuBereXejVKGbNplNEZOaLtim+kBXbveDiiRTVRryPI/65Pd/4+Yd9EDtaVEudIF5YoB80iFRP7c6CRHpHSUoj0ALBqjL9Mi
 OKlZaPLw
 ELI/oAoNZyjfj+QTFkJj7t0ZjQ/9eeZCi9fpscNACedJ66svt2bUmQ9BSLvyreijdqzQi3V4nZA+CKnwntTXbIhetK19kHCpOLT//pSXQc4TvHFnimHrgNH66SSDYdoCq5Q5OLZtKwn6oqVaXjaC8m1dFK3Wf3QtM5cpfepJuSy31mKi8UwdiVYL6QBp61Y2s6mgMXoJVWvOV8sT2NpRWjfAnT9Sl4dBgnafOMlqxU9mZn+sRZ3iwGIlsyudqPO6QbwdzRHA9jBxc8SfB2GR4xkVzgdnE2wmReOjtN6XPXJY1YCPa4wxijodQ15NG62cgNDY+3P7rIPGu2GiEJ5gZRdUkKlEAdEByZ5FbjU2+sGVUcU8XfiCJI2v0fKaptquK645ND6JFSbLFx6BEF8r3/xmPAuCQEJ+7VRvoMbk0u4e8mgWTBsyvwMLMdiavanfhNOdcq1ZaDNqoE9Bymcen8BicMNjR9D8osAt654xREvXQun8biTsha7cOenM3r1Gksbn45xJy12F/M1B18hfPuNCQvN60nPR/VPRiXTyeLSbGjWMgQDOOojBTIIq+VqpWB3Q0ohkL10QS8Hd7uMHUkFUvN7j0YSdlu7XsS+smPfdX9M720ehavGCSGTT/vBcwFu82DzRUZw3DVdLjJEcSOmFW1l1lHLv8y1Ic34QxYizMA6FSEN5nSARrA8LvnsBJvqLtw25a6o9AJ5yT/yGzWimBzeqlWsGAU4pGC5sNkYYYN2w1ljCSQxzsRS7OsaPds8Pw9aGhhpUgxWDEpc9gSz1hob9+K7zID1KfitjC7YnEan9ZxsbSce7+kbgtIdQ6fn5e
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
- [Medium] crash_core: cmem->ranges overflow via unlocked iomem_resource ho=
tplug
--

commit 24cd8bf08b74ae3e07f992972d3cd97b77d9fcf6
Author: Wandun Chen <chenwandun@lixiang.com>

crash_core: serialize crash header preparation against hotplug

This commit serializes crash_prepare_headers() with device_hotplug_lock
to prevent concurrent memory hotplug from changing the number of memory
ranges between counting and populating cmem->ranges. It also introduces
__crash_prepare_headers() for hotplug paths that already hold the lock.

Link: https://sashiko.dev/#/message/20260806101002.1F84E1F000E9@smtp.kernel=
.org

> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index faa0f22dbb41d..8a861a946e261 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
[ ... ]
> @@ -344,8 +345,8 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
>  	return 0;
>  }
> =20
> -int crash_prepare_headers(int need_kernel_map, void **addr, unsigned lon=
g *sz,
> -			  unsigned long *nr_mem_ranges)
> +int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned l=
ong *sz,
> +			    unsigned long *nr_mem_ranges)
>  {
>  	unsigned int max_nr_ranges;
>  	struct crash_mem *cmem;
> @@ -382,6 +383,18 @@ int crash_prepare_headers(int need_kernel_map, void =
**addr, unsigned long *sz,
>  	return ret;
>  }
> =20
> +int crash_prepare_headers(int need_kernel_map, void **addr, unsigned lon=
g *sz,
> +			  unsigned long *nr_mem_ranges)
> +{
> +	int ret;
> +
> +	lock_device_hotplug();
> +	ret =3D __crash_prepare_headers(need_kernel_map, addr, sz, nr_mem_range=
s);
> +	unlock_device_hotplug();
> +
> +	return ret;
> +}

[Severity: Medium]
Can cmem->ranges[] still overflow during __crash_prepare_headers() even when
device_hotplug_lock is held?

In __crash_prepare_headers(), arch_get_system_nr_ranges() counts the current
system ram ranges (plus a fixed number of split slots for exclusions),
allocates cmem via alloc_cmem(max_nr_ranges), and then populates
cmem->ranges[] in arch_crash_populate_cmem().

Neither the x86 callback in arch/x86/kernel/crash.c:

static int prepare_elf64_ram_headers_callback(struct resource *res, void *a=
rg)
{
	struct crash_mem *cmem =3D arg;

	cmem->ranges[cmem->nr_ranges].start =3D res->start;
	cmem->ranges[cmem->nr_ranges].end =3D res->end;
	cmem->nr_ranges++;

	return 0;
}

nor the weak implementation in kernel/crash_core.c:

int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
{
	phys_addr_t start, end;
	u64 i;

	for_each_mem_range(i, &start, &end) {
		cmem->ranges[cmem->nr_ranges].start =3D start;
		cmem->ranges[cmem->nr_ranges].end =3D end - 1;
		cmem->nr_ranges++;
	}
	return 0;
}

checks whether cmem->nr_ranges has reached cmem->max_nr_ranges before writi=
ng
to cmem->ranges[cmem->nr_ranges++].

However, Xen balloon memory hotplug inserts new system ram resources into
iomem_resource before acquiring device_hotplug_lock via the call chain:

balloon_thread() / xen_alloc_ballooned_pages()
  -> add_ballooned_pages()
    -> reserve_additional_memory()
      -> additional_memory_resource()

Specifically, in drivers/xen/balloon.c:

static struct resource *additional_memory_resource(phys_addr_t size)
{
	...
	res->name =3D "System RAM";
	res->flags =3D IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;

	ret =3D allocate_resource(&iomem_resource, res,
				size, 0, -1,
				PAGES_PER_SECTION * PAGE_SIZE, NULL, NULL);
	...
}

static enum bp_state reserve_additional_memory(void)
{
	...
	resource =3D additional_memory_resource(balloon_hotplug * PAGE_SIZE);
	if (!resource)
		goto err;
	...
	mutex_unlock(&balloon_mutex);
	/* add_memory_resource() requires the device_hotplug lock */
	lock_device_hotplug();
	rc =3D add_memory_resource(nid, resource, MHP_MERGE_RESOURCE);
	unlock_device_hotplug();
	mutex_lock(&balloon_mutex);
	...
	balloon_stats.total_pages +=3D balloon_hotplug;
	...
}

Because reserve_additional_memory() inserts the resource into iomem_resource
and drops balloon_mutex before waiting on lock_device_hotplug(), and only
updates balloon_stats.total_pages after add_memory_resource() completes,
concurrent callers (such as balloon_thread() and xen_alloc_ballooned_pages(=
))
can insert new system ram entries into iomem_resource while
crash_prepare_headers() or arch_crash_handle_hotplug_event() holds
device_hotplug_lock.

If those entries are inserted between arch_get_system_nr_ranges() and
arch_crash_populate_cmem(), wouldn't the extra ranges consume the reserved
split slots (causing crash_exclude_mem_range() to fail) or overflow
cmem->ranges[]? Should arch_crash_populate_cmem() and
prepare_elf64_ram_headers_callback() also bounds-check cmem->nr_ranges
against cmem->max_nr_ranges?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021083011.2170=
525-1-chenwandun1@gmail.com?part=3D3

