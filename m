Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D14606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UK1LXpsj
Received: by kanga.kvack.org (Postfix)
	id E60B56B05B2; Thu, 29 Oct 2026 22:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E385F6B05B3; Thu, 29 Oct 2026 22:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75536B05B4; Thu, 29 Oct 2026 22:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADE9D6B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:58:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32F85405C4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:58:57 +0000 (UTC)
X-FDA: 85377785514.19.4CB824D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9CD32160003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:58:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UK1LXpsj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793329135;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUrLM4J4qCjs4gnuU6Unm6BpALfnacabOygCpkoPuFg=;
	b=yacvg/PZGpJR0OdQgtB46M/xcL/dOOYRSSJYmAxfnvU9OXUN3aiWJL6ZQTbRBuL2V3jUR2
	/S3/veXKVdIcNKaBK8z1HLToCl9FRwEvx0jMXb9xB2HH15ORtBi8SRHBH4xeLyzAV806mq
	B1upN+AzpV9tJImWf3SHcV56sSP4L4U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UK1LXpsj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793329135;
	b=QxkgVynkxwCoHfxS7kNOzbfofltMcCmTBMzWNrOLAcZbxMB7b+odRBXacO8jx7RA8bpMdW
	2awdJEzT8/50VW7ae1U3m+t6yFijUocQhWNERHnDGfl1QLXvrpEpmXNqPBN4sOuPuqrK8Y
	W/kKPKFZP6l/1KfpdDpxL3osx9NhxPI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0D8E600DA;
	Fri, 30 Oct 2026 02:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6B11F000C1;
	Fri, 30 Oct 2026 02:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793329134;
	bh=EUrLM4J4qCjs4gnuU6Unm6BpALfnacabOygCpkoPuFg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UK1LXpsjT3IOdW/rc2RUdITgWFGhDNrqRK/cLXJ0shF6lU+OHJ2Jky3BGanUOi6PA
	 6ABpX0U/eJK3yYCoWsQb/UvIHEFm3h7mg/CwLwmOz/xyyKjyZphqQ+TIcBbRJKsIOi
	 Y9lHsuZRbY3Ih+XWMaQ6DKBUCCDmkQKaA4uDE++jcGAetxnH7Y42b4Az2/yA82V3zj
	 WaJRSR7O179tsdmBiAM50LkvYn89OHewdRjNW/E2UWSIcNO8kAmbnI/OtoBJf/+qcs
	 XSOrdC5i30KA4PQZ8L/a+OGvWYn8qPJ3OUYqZSxfsX/V5tjyDpXfz7MVZYZpre+n83
	 6JEIC+3gKl7Fg==
Message-ID: <sashiko-outbox-190189@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] riscv: keep booting if KFENCE pool reservation
 fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jackie Liu" <liu.yun@linux.dev>, glider@google.com
Cc: dvyukov@google.com, elver@google.com, pjw@kernel.org, alex@ghiti.fr, aou@eecs.berkeley.edu, linux-mm@kvack.org, kasan-dev@googlegroups.com, muchun.song@linux.dev
In-Reply-To: <44fbd039a5cd78bfe7355ccbafb197775dede29c.1793242457.git.liuyun01@kylinos.cn>
References: <cover.1793242457.git.liuyun01@kylinos.cn>
 <44fbd039a5cd78bfe7355ccbafb197775dede29c.1793242457.git.liuyun01@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 02:58:53 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9CD32160003
X-Stat-Signature: 79hfcsgft39t1c3xw5rbj4xxo7zrqu7e
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793329135-245067
X-HE-Meta: U2FsdGVkX190AtwqOSW1tVSsCvcEmc8sp3N5Voc4WkPYAscIfMRfXzRT9UBCSQelbo5HOnYIxy6GCsrDfqRLXezfQKbBvA5+5ftHzmvX317oaHiucy8mDJFyQyvS3zf1JkKzK7MgXsQH73ATKns9hiIlopCPRPLDFRb4RJWIjoE1ygb9Rb8acUrMLWnqJGTDyJ6GEk3x1gZkJ4UxsJh77I6YJXHqYFmi9sP+3xrb2Sdmgkp+GVrXy8Zdijz7Ip14sXkEAlPBqEKN6juWNhhMg4VnoQbyOP6QCCwAIEfroylQu7PJmcNVeK2Av2AgCzAUap/aoum0MM6MZMtKKYl8qy+J2LED/+FfPk9ocSOeCeCu3O+lorMzS0NmyUzt/SO73vZ/cKMUiZdtbqZRsjSPAR1pkhGxW48tLLes70LtMiK2iP1q60fYtSPYyR9EWLqm+eqVuZFF5eF6DV366Y6/9VuT44HJt+ZwNMlxdVFUCUMpJMAifg16fjookoLYHOz/tWuyPm/hZQ9a97PQvgAaxxQWoi9fWGHaQct10OXiERdZAEqhlHPImdvMRQcHsqctdc7pG1hifGxdTQwvunb95Q3hjoINKO4ke1Jdm9HoRrUHV9R6SOmBYoePS5T/duUKJ+p6U2C8XHCUztDFYXoQusm0zY8PeibW0FMvKBEmrdzZdDqPBjK8vZtYnKsiFWtXoBPlH3LD0xMQJVtVzoGwcnlvfG/29S3+PGg0tXMzN7BfyeQdtfF9CK+EKXks3ar2+iiEUkziu9ySZPUEAwEpFzak2OFhf+p+bV/JXrCnkldy93JQKsea1hhW0/EdyUkVh2Po3NGeRawj1rjGuH++qpYhI3U4yFOYjPE2ETIK8XN0pDYTo5Oz4xU1ZNYJ3tjMQzwkz/lP5g6+IIXmtzXTHDmO/EI7jEAfljBo2wk752ghtrWn5eUtfKGFFSfyOnJV49YWdUiuurDVf0GF4Zs
 rXU3haGK
 w22tvgPmXvd5TxMIuofOj4IqjUNUxoYnVXeWeffl6s0NwVe2YALQtc8rQ68eiEcpim/2ZZHKAU5uavwcPkDafR41o+8wOr+wn6ujm4by2moYXYyK/si32bR50NfoPEqo6Ow2rMrAh0xN3zMLfh4V/rR+eDaFEmgCDRmEXlqH7ssDobuCIKw7zxrzoxFMH70PWF8WNesDRis9YgDbcvmPsSNmnHqD/PrTLikaZqAPlzuKHRQsfGlV8iPJxkgYHNz6AVX5Jmch3e1ElWjymTVrGTWbv1JotL8A4Tekfeuc/31npfGqiMRNMsPmZ5jjas9lV0kvZeLodiPu/EozZOkfB/esY2/yU8HTVfyhcfaxJi4tuU9O67h29aGQUbDAwpWt6cqeaaS9UJ4PvBBPA5NMi+Szp97h3DBp+wDQ51Ni96m6BXX6APHBtVf/fHP9B/vlzQXYcgrFBnVxMuub34U28fjktXw3jseSBk0g9pky/lW4fD/bP48QCCtaDzttf9ZgQ0A4PShJF38KVQw1B+fDKBj+I36T2A7957dIEU7MxQZ8z0DtIHVT5hb5UcQ==
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
- [High] riscv: kfence: incomplete replacement pool rejection and fallback =
memblock leak
--

commit 3fb224ed3ecf516e32ff76314492cf99262a5a4f
Author: Jackie Liu <liuyun01@kylinos.cn>

riscv: keep booting if KFENCE pool reservation fails

This commit avoids hitting BUG_ON() during linear mapping setup when the
early KFENCE pool reservation fails by tracking the failure in
kfence_disabled and returning !kfence_disabled from arch_kfence_init_pool().

> diff --git a/arch/riscv/include/asm/kfence.h b/arch/riscv/include/asm/kfe=
nce.h
> index 29cb3a6ee113d..57e57426a7d60 100644
> --- a/arch/riscv/include/asm/kfence.h
> +++ b/arch/riscv/include/asm/kfence.h
> @@ -9,9 +9,11 @@
>  #include <asm/cacheflush.h>
>  #include <asm/pgtable.h>
> =20
> +extern bool kfence_disabled;
> +
>  static inline bool arch_kfence_init_pool(void)
>  {
> -	return true;
> +	return !kfence_disabled;
>  }
> =20
>  static inline bool kfence_protect_page(unsigned long addr, bool protect)
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index fb37b0b67efec..d21be990346c6 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -44,6 +44,10 @@ DECLARE_BITMAP(new_valid_map_cpus, NR_CPUS);
>  struct kernel_mapping kernel_map __ro_after_init;
>  EXPORT_SYMBOL(kernel_map);
> =20
> +#ifdef CONFIG_KFENCE
> +bool kfence_disabled __ro_after_init;
> +#endif
> +
>  #ifdef CONFIG_64BIT
>  u64 satp_mode __ro_after_init =3D SATP_MODE_57;
>  #else
> @@ -1229,10 +1233,13 @@ static void __init create_linear_mapping_page_tab=
le(void)
>  	 *  for this region.
>  	 */
>  	kfence_pool =3D memblock_phys_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
> -	BUG_ON(!kfence_pool);
> -
> -	memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
> -	__kfence_pool =3D __va(kfence_pool);
> +	if (kfence_pool) {
> +		memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
> +		__kfence_pool =3D __va(kfence_pool);
> +	} else {
> +		pr_err("failed to allocate kfence pool\n");
> +		kfence_disabled =3D true;
> +	}

[Severity: High]
Does setting kfence_disabled without clearing kfence_sample_interval still
allow a fallback memblock allocation and a late hugepage-backed replacement
pool?

In mm/kfence/core.c:kfence_alloc_pool_and_metadata():

	if (!kfence_sample_interval)
		return;

	/*
	 * If the pool has already been initialized by arch, there is no need to
	 * re-allocate the memory pool.
	 */
	if (!__kfence_pool)
		__kfence_pool =3D memblock_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
	...
	kfence_metadata_init =3D memblock_alloc(KFENCE_METADATA_SIZE, PAGE_SIZE);
	if (!kfence_metadata_init) {
		pr_err("failed to allocate metadata\n");
		memblock_free(__kfence_pool, KFENCE_POOL_SIZE);
		__kfence_pool =3D NULL;
	}

There look to be two issues with relying solely on kfence_disabled here:

First, when memblock_phys_alloc() fails in create_linear_mapping_page_table=
(),
__kfence_pool remains NULL while kfence_sample_interval is still non-zero.
Later in mm_core_init(), kfence_alloc_pool_and_metadata() will allocate a
fallback __kfence_pool and kfence_metadata_init from memblock. When
kfence_init() -> kfence_init_pool_early() subsequently runs and sees
arch_kfence_init_pool() return false, it calls memblock_free() on both
allocations after kmem_cache_init() has already set slab_is_available().
When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, memblock_free() ->
memblock_phys_free() -> __free_reserved_area() triggers a warning because
deferred struct page initialization has not yet run, leaking both
__kfence_pool and kfence_metadata_init.

Second, if memblock_phys_alloc() succeeds in
create_linear_mapping_page_table() (leaving kfence_disabled false), but the
subsequent kfence_metadata_init allocation in kfence_alloc_pool_and_metadat=
a()
fails, the early PTE-mapped __kfence_pool is freed and reset to NULL while
kfence_disabled remains false. If KFENCE is later enabled at runtime via
sample_interval, kfence_enable_late() -> kfence_init_late() will allocate a
replacement pool from the linear map (which may be backed by PMD/PUD/P4D/PGD
hugepages), arch_kfence_init_pool() will return true, and
kfence_protect_page() -> virt_to_kpte() will walk the page tables assuming
PTE mappings, which can corrupt memory or fault.

Would setting kfence_sample_interval =3D 0 on allocation failure in
create_linear_mapping_page_table() and checking whether the address falls
within the early PTE-mapped pool range (or disabling late initialization in
arch_kfence_init_pool()) avoid both paths?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793242457.gi=
t.liuyun01@kylinos.cn?part=3D3

