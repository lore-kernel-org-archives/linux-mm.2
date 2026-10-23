Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75484606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j9V6hJZx
Received: by kanga.kvack.org (Postfix)
	id 333586B0C05; Fri, 23 Oct 2026 19:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E5B6B0C06; Fri, 23 Oct 2026 19:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1306C6B0C07; Fri, 23 Oct 2026 19:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFE216B0C05
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:32:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79EBFA025D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:32:18 +0000 (UTC)
X-FDA: 85355491956.05.0436054
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C1CD440003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:32:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j9V6hJZx;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792798336;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+uRpCta2+s96dD69f8bWRQjYDk7aUtR7RRhgbFZAQD8=;
	b=BxTnMSu5Cmcdp1FmMLGJ3vdoGzZEuRkhDxKJtTXO2sOLNqbyKKxNhW3HmPPh94s2L14W0p
	IxbheP0l6mSJGURHQAYTWpy4CMmOCz7deO9u1/dmkh8WUYxN+y6COZAUJXiJlunG0wBvxr
	dNZsqrO7kNfHSTklt1RTWon0KoYkHnM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j9V6hJZx;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792798336;
	b=n4/Og+nMDHxrOGbCWR2uZvDS6KQvTWYRJfZikDZ0hvRPMeZtuEiTY1pKdZCsujJ9qCspmV
	OQJZkFC92ylEDWDwI1Q12iVeV4As4ksAgtvU8DXKe7ft3OTrhrtyIgu6j73G5yD1SEOZad
	vYLtAUWSPoSIw3CEOZG89rD0ds6ZC8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03E63437BF;
	Fri, 23 Oct 2026 23:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7027B1F031E0;
	Fri, 23 Oct 2026 23:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792798335;
	bh=+uRpCta2+s96dD69f8bWRQjYDk7aUtR7RRhgbFZAQD8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j9V6hJZxS239yXCckA/anEyzWHe1D+TUClFYUZ5SRLNgcY0APoWFx0NaVJRifd9m7
	 HVILKLOc/vtTX3wSiwrebwEbypEAD6D7x029EIJY3Gzl7p0z83ic0uCX3OwOTI+2Un
	 PdF9NXsU1VSzhLWvhbhpoUxZ2Il/IXtZiiztsm1Oafy0ufO/nUgxD68taCTVMsLiaO
	 xbWd4Vy9Wy61u5FKoW8QphbbYWIXZpW3BO9RFi/omR5PxPT+/zLS2nzNVsKTHNqqW9
	 wHcJBpQx+GULCGD3mV2dd3zAZP7mVFvmndKhyiH1HiGHoSUiCHkOUhv62mDJ+vCgMZ
	 RyeM0UfQNNnxA==
Message-ID: <sashiko-outbox-183409@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 45/50] samples/kvm: Implement attach and release
 provider ops in sample provider
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alex Williamson" <alex@shazbot.org>, "Alexander
 Graf" <graf@amazon.de>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Alexey
 Kardashevskiy" <aik@amd.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Ashish Kalra" <ashish.kalra@amd.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Baolu Lu" <baolu.lu@linux.intel.com>, "Bill
 Wendling" <morbo@google.com>, "Borislav Petkov" <bp@alien8.de>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Christian Brauner" <brauner@kernel.org>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Connor
 Williamson" <connordw@amazon.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "David Hildenbrand" <david@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "David Woodhouse" <dwmw2@infradead.org>, "Erdem
 Aktas" <erdemaktas@google.com>, "Frank van der Linden" <fvdl@google.com>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Fred Griffoul" <griffoul@gmail.com>, "Gregory
 Price" <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, "Hugh Dickins" <hughd@google.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "James
 Houghton" <jthoughton@google.com>, "Jan Kara" <jack@suse.cz>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Jianxiong Gao" <jxgao@google.com>, "Joerg
 Roedel" <joro@8bytes.org>, "Joey Gouly" <joey.gouly@arm.com>, "John Starks" <John.Starks@microsoft.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Justin Stitt" <justinstitt@google.com>, "Kevin
 Tian" <kevin.tian@intel.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Michael Roth" <michael.roth@amd.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Nathan Chancellor" <nathan@kernel.org>, "Nick
 Desaulniers" <ndesaulniers@google.com>, "Nicolin Chen" <nicolinc@nvidia.com>, "Oliver
 Upton" <oupton@kernel.org>, "Paolo Bonzini" <pbonzini@redhat.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Samiullah Khawaja" <skhawaja@google.com>, "Sean
 Christopherson" <seanjc@google.com>, "Shuah Khan" <shuah@kernel.org>, "Steffen
 Eiden" <seiden@linux.ibm.com>, "Steven Price" <steven.price@arm.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Tom Lendacky" <thomas.lendacky@amd.com>, "Tycho
 Andersen" <tycho@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Yan
 Zhao" <yan.y.zhao@intel.com>, "Zenghui Yu" <yuzenghui@huawei.com>, x86@kernel.org, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261022-gmem-alternative-providers-v2-45-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261022-gmem-alternative-providers-v2-45-5dd1dc6c660a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 23:32:12 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1CD440003
X-Stat-Signature: 36h3itdphrtb1rm14t79cerkwhhzhydq
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792798336-599036
X-HE-Meta: U2FsdGVkX18/rbQYYn9t76G9dpUFTS/e5vrM1sZ+sXNkn8aNwRNZ8ns/BlTuyF5diKs1ky+0buJmSzkYnm05UNxKBxpjochUhiRrsnIGyVk/2m3W/M2YUMODyfANMihnhB+HGuPp6sRyP0wxylKRtu+/zcpsgbHwLVzGZ0jIpEOwm9YZNJP8PU8xWeeU5+TkhnMO5lqGQCPud4n6mEylcfMABquIcEysPc7ypHSM6Gf3btXp6lD8ygOFzm7oe6zHWd+s2FJDR5q1xVJoCmEFf5/V/MBkeE+cSWtzVzzLJoc41hVRTT3e4IXUlwWTlrk7EPlLr/KNSlJztM9MQWbRqLAdCEuSBT7RJLjQWx0n58E9BVDH/vH6Nd0UF5QdcZmW2fOC5UuZLsmIBRZTE+TiBo0oZYw9UMtpFARDQVAKPbzcH/B9h+fsbuYxzzFmLJ5E+kMq2FYzCwKq1wQGQPwiZnb6CI/cngkGNz/qM+5EXXhmNnHbNZ72G8YA+kv/to/1Un25cguI0VMCD+Jh4LzROM6EVMw2dKXvzNI01a+136rQXvEIfX9na4Y36sinxYxyf3AlemyxyxUchXJzIsbml/PstZtXHC30m7sM+OwhY6XjJlA2sUTJvDXGrJa1dYU7GbJ0ZAHb0yIIrswMKVp1+h+DWBfX3DidkUpGY7pLcpDO/mc1yTLj6QtYQ7WZtOerM15MF0YRHYQunSIMDHNOfnNera/mMbSAUhoyGnuf/Jewh9JsVPPPPD2WPyjDRttC/ZwhqQf14Ds90FmQaTI/sneG64sjmFZT0E8ushS+zAHoN1be4+ogEH7xlhJT+ig8r9sB2vRo4LhN4tLKVDUzPJ4FU72gkPqJ/6U0C87GpCMmCsctkioW7EWuTSsUh9P8EVUc12LZ/GWOhwwDlB378sIzAWBrMWVIMa0PlQa5/07aqUYrMWm1z8LvZSnJkcbXMkBtE6h0SMGdehQDGqG
 KUPYfa5A
 z8sDsxtEq0fIrDsC2CZ9052E1oGgn1TKuR8dodp6sU4wH9pmxPGN/fxyfLDJ9tKeFUwsq3w6+cKwaMpD07VjHWONrU+4aHsdUCMqkamPyH3OHArF5KUHukdI0/6Y1wWI8wo8txFcbLU+t6dgyL7QcvMm1EH60gwpGXgnpgSKblQ0gXyklegn+IJlIHmk7OCLgNCWgdmbG97RKR+j3p4Q36nehBjiYLZPpR4MyK4B3sXL4JrI98z8l0JR7vfnN0hzmRF8av6HQlwBImwsDFTpxThme8+UbVBnXQjgdS/q3PSwFiSFs8cBhB1g8nemLRt1VGBP8zRuUPL19iwIhIVXLRwGtpHIuryfbUyTTT1s0zhi2exL/EPFR2w17Vgk3Y+ykK5jrKub46g5F1hMvzJhwOYxgpDc729NejIb2D/YFOuPPop92Hf/O0Sw9gsvHiMwcO3QapY+ATKPj/cbjvGXqHkWZM7hx6XpW4EYnswOzf/cYvw0i97b0ioRk3JM6ZJg7rRd4Mt/Yv/DLirfAOeaMqADR+QCh9Oo+kquyunZjr1Atpdug0vJDRBOo5EarMoax+M+WxAcNU02ZQYEteGRfPS7Ox32J3ICyQA3Zk2Oi9TaG/T8lYk57KfrhtfH380/6GYJhBJmg+BL/VTtUDK+KBLEBnU2XWxQynL0s
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
- [Low] samples/kvm: build failure when CONFIG_KVM_GUEST_MEMFD is disabled
--

commit da89517936ff62d4ed67bf323c9cade71c875336
Author: Ackerley Tng <ackerleytng@google.com>

samples/kvm: Implement attach and release provider ops in sample provider

This commit implements the .attach and .release guest_memfd provider
operations in the sample memory provider module and wires them up to
mps_file_fops.gmem_provider_ops.

> diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider=
_sample.c
> index 397ebb3773f39..d9e57484c3933 100644
> --- a/samples/kvm/mem_provider_sample.c
> +++ b/samples/kvm/mem_provider_sample.c

[ ... ]

> @@ -118,11 +119,30 @@ static long mps_file_ioctl(struct file *file, unsig=
ned int cmd,
>  	}
>  }
> =20
> +static void *mps_gmem_attach(struct inode *gmem_inode,
> +			     struct file *resource_file)
> +{
> +	return get_file(resource_file);
> +}
> +
> +static void mps_gmem_release(void *provider)
> +{
> +	struct file *resource_file =3D provider;
> +
> +	fput(resource_file);
> +}
> +
> +static const struct guest_memfd_provider_operations mps_gmem_provider_op=
s =3D {
> +	.attach		=3D mps_gmem_attach,
> +	.release	=3D mps_gmem_release,
> +};
> +
>  static const struct file_operations mps_file_fops =3D {
>  	.owner		=3D THIS_MODULE,
>  	.release	=3D mps_file_release,
>  	.unlocked_ioctl	=3D mps_file_ioctl,
>  	.compat_ioctl	=3D compat_ptr_ioctl,
> +	.gmem_provider_ops =3D &mps_gmem_provider_ops,
>  };

[Severity: Low]
Does initializing .gmem_provider_ops in mps_file_fops in
samples/kvm/mem_provider_sample.c cause a build regression when
CONFIG_SAMPLE_KVM_MEM_PROVIDER=3Dm is enabled while CONFIG_KVM_GUEST_MEMFD =
is
disabled?

In include/linux/fs.h, gmem_provider_ops in struct file_operations is guard=
ed
by CONFIG_KVM_GUEST_MEMFD:

    #ifdef CONFIG_KVM_GUEST_MEMFD
        const struct guest_memfd_provider_operations *gmem_provider_ops;
    #endif

However, at this point in the series, SAMPLE_KVM_MEM_PROVIDER in
samples/Kconfig only depends on CONTIG_ALLOC && X86_64 && m:

    config SAMPLE_KVM_MEM_PROVIDER
        tristate "Build sample memory provider -- loadable module only"
        depends on CONTIG_ALLOC && X86_64 && m

A later commit in this series, 279ad9d61dfc ("samples/kvm: Support dynamic
revocation via kvm_gmem_revoke"), adds && KVM_GUEST_MEMFD to
SAMPLE_KVM_MEM_PROVIDER in samples/Kconfig. Should that Kconfig dependency =
be
moved to this commit to avoid breaking bisection when CONFIG_KVM_GUEST_MEMFD
is not enabled?

> =20
>  static long mps_ctl_new_file(void __user *uarg)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-gmem-alter=
native-providers-v2-0-5dd1dc6c660a@google.com?part=3D45

