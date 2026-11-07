Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10436606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qkxhKiuC
Received: by kanga.kvack.org (Postfix)
	id 304DA6B05B2; Sat,  7 Nov 2026 02:40:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD7B6B05B4; Sat,  7 Nov 2026 02:40:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F3CD6B05B6; Sat,  7 Nov 2026 02:40:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F087E6B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:40:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81FF5802C3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:40:16 +0000 (UTC)
X-FDA: 85407524832.13.AF85731
Received: from mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0301D20002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:40:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qkxhKiuC;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.48 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794037214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vTtHhOU7KFGccpDaVfJbGmgTDtSx5A2CfyTXw9K8qU=;
	b=I59IiyuIlEEmPOs7SkDN7OdKspPmeem+2JTmwvL35OhPiUxTCRCCL19aUhJk08YHFrFbH8
	Juc2AOTrFfRDihIkYC1fNaElTSukk/XQNwpwOmK/zLfOsPjec/5MFpwSa7vPztKizUgQXc
	5nME37mfWJtJ91Vdf6fChwA+3RBWWzQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794037214;
	b=vJZMLKOmeai7sXAUQoTnyKGcO2DE0PnokwUKrmaxY0Gk9ft4kWfNuBw06fXCB6fuhODR2c
	bKomcX2ZV/9FSvhEyv3hroXxAY/20v5LaphEaG5InYgT12I7jnpJVRxPdixTOSfbugUhn+
	tEkTjUptJkAdAqIKVrPgGyCifPB5eW4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qkxhKiuC;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.48 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ba5vOU7cFBOUOtdQvyDB/MD00fPiK2yMPUvY9IZ/14M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794037208; v=1; x=1794642008;
 b=qkxhKiuCf51nEKbt8/RKaTf4dA8yfgY1A+zviok65ANjerB4R7Y9GAqkaj++W+d13UrOBQF/
 ns2+GE/FynhDeIs1BsLoh/FMfbtVcFVuyS3nQYBZ3LGjxgdDULcN/oYGxAtf5kHNERZnywDMRHy
 R358mxNUXLuIWh2qp+k5DW54=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 447480f83695572a;
	Sat, 07 Nov 2026 07:40:06 +0000
X-Mizu-Trace-ID: 447480f83695572a
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 09/20] hugetlb_vmemmap: Allow architectures to make HVO
 enablement boot-time only
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261003002123.505555-10-jthoughton@google.com>
Date: Sat, 7 Nov 2026 15:39:46 +0800
Cc: Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9448E513-B372-46BB-929B-E0D7D6A6834E@linux.dev>
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-10-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam06
X-Stat-Signature: a9unr68tfhnscc5eizmgh8k3obg3pntk
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0301D20002
X-Rspam-User: 
X-HE-Tag: 1794037212-217786
X-HE-Meta: U2FsdGVkX1/BGKid5la19UytWKYL1Cd3UByec5ia8GaX8lJTPR3xxokueccQCCgljmQdFbVv+jRnZf71c7Tue3VGzMWC1GIK5kgAmQR1N2U2/YZFuWlHnrBv5Zagf1H2IeaKixh8/eOBCqlfOhsJk9o8IlpOVfI6i4goigkZ3rxt4qyhA639f+txKg5nZF8VGGiswcpuTba7qdVaMs+0bW0+eHGQtVL7nOnqKocSl/SugWYyqbsJSfy1UbQiW0l8oLzTs/vR/0XM9drLcO7pnNFiLubFekeODMkGnL/GIc2LBMl9alklqCIbDR9iMfYDFtrVC+FZhK2lFeP5x7dSEuU397Xtdbyh2ljhGRWMi+f2JDT5JgmBZ+j6XKpt6cpy3KMpSpEYsVIHuEYUuE8fxpGtJkSEQzeD/iZVXnXGe7PrPHAkflfTCyoDWmHkWuM9uGJrJfEAHQiY91mUtP5+wP38FJSEm/B+s5fwu6eRA/fM11RgJoDkx6CSK2yGwngMOOIy+BySLQpTVczc5UtobV/y2CwAkkHV8v0LdVcIwxa21W9LBcXEmViYBitk8CJX+E2Cb+uIL2OOdtQSPdACKLL9x0enXgMXMiX/oirc2qK+8XfFFEcjWatdQi/0tb55z8nXxeBHgVTL8NnxvlytXfasPtYLdxORE2qV9u5nNsb5Ex7cDQ4l1Owb5BKbyuhgkvqQhH/wAgt9hRAnFJQbxl0gr1wdUQfs9obg7iMhLyfS3cuDVz2mLAXI0LGj9kz612z0JuB2nO0eKoi+yUUGjnlrOgTWtq7odHHi9ZPs/DSgWcjiKM0aC8e+jtSqugWETH9u6FXJUKfXCw7eJzPNyskmunEoyDzCQ/JQ58xvL/c7hRg52DTbWoZF2EXink4sEaaj3GUbmSp4RIdFOvEXEPppnKn0dfF/QWQ4I4orJWsCsE7I2NsmjWeVuQq1fH8nw7hhoHdvClphDJnLndB
 u5Va+KFr
 Z0MwLXqMMxFpUab+RiGQeiEtk0ALG44p9/U/c9r25ir4xJjUiYcR6aOqDbjJJCImuGnTITJYbvORRb6MRACl4Q7+tGgkRVF6DsOUFxxShYaw5NaNFlxD5bgoWcnM3d4z2guXsGMM0tS4iAA5KaSakxRqomOIYe6A8LJoEo1ZFWzLDvNPFNGvHwPMCAHcYTedvyQgxKBuN2yF26mj1Obd6fNbGDhIcZ6N+UDidfSDSDnTyygVYHWKmMoHKepjHL4lAUZDp+iYx1lXQ42W4XRc/O/SLeHz5OHtlQwcb4bhlUmFhc0ioUE1oLpEgenAUNbHOom/vd2TFVMqdi9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> =
wrote:
>=20
> arm64 needs all CPUs to support hardware updates of the access flag to
> safely update the vmemmap in place, and it will need to refuse to =
online
> CPUs that lack it, but only if HVO may be used. This only works if HVO
> cannot be dynamically enabled, otherwise incompatible CPUs may have
> already been onlined at enable time.
>=20
> Add CONFIG_ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT for architectures =
to
> select. When selected, vmemmap_optimize_enabled is __ro_after_init, so
> it can only be set with the hugetlb_free_vmemmap=3D kernel command =
line
> parameter, and the sysctl is made read-only.
>=20
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> Documentation/admin-guide/sysctl/vm.rst |  3 +++
> fs/Kconfig                              |  3 ++-
> mm/Kconfig                              |  9 +++++++++
> mm/hugetlb_vmemmap.c                    | 17 +++++++++++++++--
> 4 files changed, 29 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/admin-guide/sysctl/vm.rst =
b/Documentation/admin-guide/sysctl/vm.rst
> index 5b318d17aa4b..d962d563cfd4 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -692,6 +692,9 @@ pages.  So, those surplus pages are still =
optimized until they are no longer
> in use.  You would need to wait for those surplus pages to be released =
before
> there are no optimized pages in the system.
>=20
> +On some architectures, this knob is read-only, and HVO can only be =
enabled or
> +disabled with the hugetlb_free_vmemmap=3D kernel command line =
parameter.
> +
>=20
> nr_hugepages_mempolicy
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 1454b7fe9641..4222db17ba02 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -267,7 +267,8 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
> 	help
> 	  The HugeTLB Vmemmap Optimization (HVO) defaults to off. Say Y =
here to
> 	  enable HVO by default. It can be disabled via =
hugetlb_free_vmemmap=3Doff
> -	  (boot command line) or hugetlb_optimize_vmemmap (sysctl).
> +	  (boot command line) or hugetlb_optimize_vmemmap (sysctl, if =
the
> +	  architecture allows changing it at runtime).
> endif # HUGETLBFS
>=20
> config HUGETLB_PAGE
> diff --git a/mm/Kconfig b/mm/Kconfig
> index acefc994d9a8..ad313fddc9da 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -475,6 +475,15 @@ config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
> config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
> 	bool
>=20
> +#
> +# Select this config option from the architecture Kconfig if HugeTLB =
vmemmap
> +# optimization may only be enabled or disabled on the kernel command =
line, e.g.

I suggest using the following phrasing to specify precisely what becomes =
RO.
Something like:

# Select this from the architecture Kconfig if the =
hugetlb_optimize_vmemmap
# sysctl must be read-only.

> +# because the architecture configures the system at boot based on =
whether it
> +# is enabled. This makes the hugetlb_optimize_vmemmap sysctl =
read-only.

I don't think it's necessary to include the last two sentences. This is =
a public
file, and we only need to describe its purpose. What specifically caused =
it is
architectural choice, so we don't need to explain it here.

> +#
> +config ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT

How about ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO? I'll explain the =
reason below.

> +	bool
> +
> config HAVE_MEMBLOCK_PHYS_MAP
> 	bool
>=20
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 817ce39d4cf3..de4148a8aabf 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -428,7 +428,20 @@ static int vmemmap_remap_alloc(const struct =
hstate *h, struct folio *folio,
> 	return ret;
> }
>=20
> -static bool vmemmap_optimize_enabled =3D =
IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
> +/*
> + * Architectures selecting =
CONFIG_ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT rely on
> + * HVO only being enabled or disabled on the kernel command line.
> + */
> +#ifdef CONFIG_ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT
> +#define __vmemmap_optimize_enabled_attr	__ro_after_init

If we do not set vmemmap_optimize_enabled to RO, the implementation =
becomes
much simpler. sysctl is read-only, so it was already impossible to =
modify
vmemmap_optimize_enabled in the first place. Therefore, even without =
this
layer of protection, we lose nothing; on the contrary, we gain a simple =
code
implementation.

> +#define HUGETLB_VMEMMAP_SYSCTL_MODE	0444
> +#else
> +#define __vmemmap_optimize_enabled_attr
> +#define HUGETLB_VMEMMAP_SYSCTL_MODE	0644
> +#endif
> +
> +static bool vmemmap_optimize_enabled __vmemmap_optimize_enabled_attr =
=3D
> +	IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
> static int __init hugetlb_vmemmap_optimize_param(char *buf)
> {
> 	return kstrtobool(buf, &vmemmap_optimize_enabled);
> @@ -751,7 +764,7 @@ static const struct ctl_table =
hugetlb_vmemmap_sysctls[] =3D {
> 		.procname	=3D "hugetlb_optimize_vmemmap",
> 		.data		=3D &vmemmap_optimize_enabled,
> 		.maxlen		=3D sizeof(vmemmap_optimize_enabled),
> -		.mode		=3D 0644,
> +		.mode		=3D HUGETLB_VMEMMAP_SYSCTL_MODE,

So, I think

  .mode =3D IS_ENABLED(ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO) ? =
0444 : 0666,

is simple and enough.

Thanks,
Muchun

> 		.proc_handler	=3D proc_dobool,
> 	},
> };
> --=20
> 2.56.0.rc1.315.gc6ed9934b7-goog
>=20


