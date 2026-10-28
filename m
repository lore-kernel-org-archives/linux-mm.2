Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D228606A747
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ogsZoNea
Received: by kanga.kvack.org (Postfix)
	id 009AE6B05D1; Wed, 28 Oct 2026 11:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F229B6B05D2; Wed, 28 Oct 2026 11:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12246B05D3; Wed, 28 Oct 2026 11:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC44B6B05D1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:48:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55C31A016C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:48:57 +0000 (UTC)
X-FDA: 85372468314.24.509BA34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 92421180008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:48:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ogsZoNea;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202535;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1JDBLPFOu6JXnIWw8Oy0ZhhClazUCLSQIjUwYJcSrM=;
	b=g0Mq4sPs3wb82r8Zhd/770FuBiioyfZtLgRw9Fz+S9dCaqQufczYsn+3M637rkfpNcMrNJ
	luHTDrclR7IwbqLi+Rwmzt9uRpJq7feLATnQtNv+Nq8LCAEIv+FFwfOVSRFdYt6yy3svoF
	yU4aTIY6v+2EWSLEgnSGaIoM2kb+94M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ogsZoNea;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202535;
	b=P1xc7TrY1ou5XS2Gs9N2dxR6Y5cYbuvRL+sdV6Scb8s45bK8dU1zqPTQ60aeL+GhuKjF/d
	0TXOBBcXTZcmzM5MT1cYmVH9b+gTxqVABAcHC7tBjAUhymy963WWOv1ZRw2Ex+dRuK0DDO
	QosgMqit4z+AHOkAovx0JAWSgXdG6V0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBEE040F1C;
	Wed, 28 Oct 2026 15:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ADC1F01828;
	Wed, 28 Oct 2026 15:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793202534;
	bh=K1JDBLPFOu6JXnIWw8Oy0ZhhClazUCLSQIjUwYJcSrM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ogsZoNeaTQNfOirbMVKSK6feq27pIMRM4V0VWtg4Db+xUyoFKNllWKv6Jr9cdTqFD
	 Xq4HPwuvGIxEi3dHAguImSCmj0CA+m7xfLj5LD0aE8ogB9pn83aVidkbxuXYCsOAUG
	 S2t9blyXTKBgSGx4zaJpDYVQ7ijBHlrlIvAFiDyb+JfJuS2qMGRUVgNp7AKO8MqtBX
	 oRZp9iPOwk8n/CRuY2YOe6knYA2scnjcyTDLi62ohDMemIcqhj146bkQfds9Pn6Zkc
	 kip5mr2qmpKADJLd1Bnavr210B8cSCKoc3BpG79rZl2OJf3UMo93vh5Bb8I6vpkdJr
	 pA5asqO6hJUAA==
Message-ID: <sashiko-outbox-188096@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 14/14] KVM: selftests: Test guest_memfd mapped by
 iommufd
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
In-Reply-To: <20261027154649.91571-15-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
 <20261027154649.91571-15-griffoul@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:48:51 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 92421180008
X-Stat-Signature: scmhrhpgr8berb3p646a9cdzo3sdqt4g
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793202535-494151
X-HE-Meta: U2FsdGVkX1/alE49Ztz/CBMG/oASVp7Hd2SORsDSquIXhuxkz8flxqzX9MV6+fN+Z3lfg3grZGTtoh4KIOhMdxJ42YtYjpMcZ130SzLdZFLnoWgbwIeVoSKDOArfps/U+1ipKtOsFuuqzpE7aBLutQPA1OJ5qATmT4kUwvGihNMoNs0FpuRR+2xewlYX9yVqVf5voD9N0FzquUoyzpZbbQNwdUMvVp1cOS4sbbSeugPlEZ8QprtISZM2dE69LTbz2+LGKE6EQUTZkcKLc4XyYfa3eZMV9bHxMy24b/ycO8pdnaGizfrXgy0QQL0BJNLz1Fcg9glxBJa9bc+/OuV+AJ9Y2F5w/C3Zt9Gl7rbcVXr7u8Pf9CzYIWyVSJnIjNRDd+ahom9NJtpTDwUrCsQEevzl1SAnYxxuWz78JdJcgx513fU+Yl4Wp3UGoVk8JwSQ7GjYNUBxI7c8ooz0aXJ+WCTqYWBoRLXCQGbzcP20VZtEzEfT0kUU1zu1IzqUONwZQr522s+fZHt5v4xfMPOUkmLrgq7OqOPrvnASi/arx/ml9fvKl1U9BnQVFrOa6oS3Aob+f5CWcdHwO3cP6JoaxhOWysmpePcDUNz32/bU5Iya5gYnFj76rQG3janJ7W7JQe7o21bVa5T0d7bR5BUiHxWtAYaeBk6Srbu7FqwvQczHieryQx9NMPcx6rn0VyrXGhSJLTa/PvSG0lsUxK8neszRUhk6dLaaDRcVQfiJekuvjObrYb3nzFg/FF+hx+r9Wm+wNDp9MajOenp4LaYD62orvP5YiuHaRScT4a+7ElxPYyjryQ85OAdQF4aaHj4EC1O5fp9PFHvhwJCiPXeJLtrrDjnRS95I6AyTFt9GvByzdHMlflFYI7GmAFM+4XyjNhSSbX/jZjD4nG8EBNUbAcQAh89D90TvcoC3i58JOzlH7oX9P65Aj+2KF9d2mfc9+l+6W2NMpvAghGVDlkE
 /aEgeHpt
 5qcR9SGJd5rQ0nM6Hhl5vrWc+Qxbjdiz2pkAUuW94OXq1CihMrhCG3bY7Ilmw1e5WrUH7a5iwt19sVvDg/A/S00gBn6pJDiNnJbvFnbEsXqt/3mKRKolrJj52s6nw1P+bt2T5UhPdzSRCnK5rxkCXbTPMTg1EhQlP/qW8478gM7g0tofEmNcW5nb63yE5V6qp/DO/JIGPKmEoiuDbjBarGk7aDfp3i4iuBnskt1aUnaYmNuxuJ2MA1VCKL65A5CYYnwpb7CqtK5qhj4NJpC7fOYJTEV6cCyvUyqaB6BwemBRRT0CULRERir7wSNFi+CVkO/Sz9co3hkNDnt7Hgh9gxYhDIrrv/Fft6RB1s4lTOtyTkBM6zac2ykxL5kZtgX5mGynBS/uqhpQ3nCJS10XEKCUizUfsx93i8YIn9SZKctP4kRE6kupU0pJqHyXjfExwegt8iDwb/zUMY7nhh9BKylBJnWbnRfu8AqD2DO7svZEyYM/1zI+r52GxjAtP147QacaZKtmLU0qqom4KlTyx3+kLDmOBMolthUnNiaFrgFMr3I/rBwfPlLfB9P/idpo4Hvo/e7LNT4eX0N3ypEHZ1+jSvviHQlY6gR895W8clFDxVr3zwf6PkMXZMbbESKEIXyaUPAUvp4A46X3OVznkv7j0/oo2jHwUPA2HjL+u3OcxDJLjrgWJ+L/96VR1BLdiIDJ7pTjNS2fUNUGRZjX8TJxO01SiDqKDXtsRPshWz1IUdU0=
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
- [Low] KVM: selftests: host_access() reimplements TEST_EXPECT_SIGBUS() poo=
rly
--

commit 039c70671ebb1232a61b8053400cfbcf04938b2b
Author: Fred Griffoul <fgriffo@amazon.co.uk>

KVM: selftests: Test guest_memfd mapped by iommufd

This commit adds gmem_conversion_iommufd_test to verify that iommufd mock
domain device mappings of a guest_memfd stay synchronized across conversion=
s,
allocations, hole punching, memory failure, and PFN provider operations.

> diff --git a/tools/testing/selftests/kvm/x86/gmem_conversion_iommufd_test=
.c b/tools/testing/selftests/kvm/x86/gmem_conversion_iommufd_test.c
> new file mode 100644
> index 0000000000000..5d17b0e2dd438
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86/gmem_conversion_iommufd_test.c
> @@ -0,0 +1,956 @@

[ ... ]

> +/*
> + * Read @addr, or write @val to it, through a host mapping.  Return the
> + * signal that the access raised, or 0.
> + */
> +static int host_access(volatile uint64_t *addr, bool write, uint64_t val)
> +{
> +	struct sigaction sa =3D { .sa_handler =3D host_sig }, old_bus, old_segv;
> +	int sig;
> +
> +	sigaction(SIGBUS, &sa, &old_bus);
> +	sigaction(SIGSEGV, &sa, &old_segv);
> +	sig =3D sigsetjmp(host_jmp, 1);
> +	if (!sig) {
> +		if (write)
> +			*addr =3D val;
> +		else
> +			(void)*addr;
> +	}
> +	sigaction(SIGBUS, &old_bus, NULL);
> +	sigaction(SIGSEGV, &old_segv, NULL);
> +	return sig;
> +}

[ ... ]

> +#define host_read_faults(p)	(host_access(p, false, 0) =3D=3D SIGBUS)
> +#define host_write_faults(p, v)	(host_access(p, true, v) =3D=3D SIGBUS)

[ ... ]

> +static void scenario_readonly(void)
> +{
> +	struct vmm v =3D { .name =3D "pfn" };
> +	volatile uint64_t *page;
> +
> +	pr_info("   read-only frames on a PFN mode provider\n");
> +	vmm_setup(&v, BACKING_PFN);
> +	page =3D (volatile uint64_t *)(v.hva + RO_OFF);
> +
> +	*page =3D MAGIC;
> +	vmm_run(&v, 0, 0, RO_GPA);
> +	TEST_ASSERT(expect_sync_then_done(&v) =3D=3D MAGIC,
> +		    "guest does not read the host's write");
> +
> +	mps_set(v.child, MPS_SET_READONLY, RO_OFF, PAGE, true);
> +	TEST_ASSERT(vmm_iova_mapped(&v, IOVA + RO_OFF, PAGE, true),
> +		    "read-only page not mapped for the device");
> +	vmm_run(&v, 0, 0, RO_GPA);
> +	TEST_ASSERT(expect_sync_then_done(&v) =3D=3D MAGIC,
> +		    "guest cannot read a read-only page");
> +	vmm_run(&v, RO_GPA, ~MAGIC, 0);
> +	expect_memory_fault(&v, RO_GPA);
> +	TEST_ASSERT(host_write_faults(page, ~MAGIC),
> +		    "host write to a read-only page did not fault");
> +	TEST_ASSERT(*page =3D=3D MAGIC, "write to a read-only page landed");
> +
> +	/* Writable again: the guest retries the same write. */
> +	mps_set(v.child, MPS_SET_READONLY, RO_OFF, PAGE, false);
> +	vmm_resume(&v);
> +	expect_done(&v);
> +	TEST_ASSERT(*page =3D=3D ~MAGIC, "write after clearing read only lost");
> +	TEST_ASSERT(!host_write_faults(page, MAGIC),
> +		    "host write after clearing read only faulted");

[Severity: Low]
Could this test use TEST_EXPECT_SIGBUS() from test_util.h instead of
reimplementing signal-catching accesses in host_access()?

In host_access(), both SIGBUS and SIGSEGV are caught, while
host_write_faults() only checks whether the return value equals SIGBUS.  In
scenario_readonly(), if the write in !host_write_faults(page, MAGIC) raises
SIGSEGV instead of succeeding, host_access() catches it and returns SIGSEGV,
causing !host_write_faults() to evaluate to true without checking that
*page =3D=3D MAGIC afterward.

Also, in scenario_readonly(), mps_set(..., MPS_SET_READONLY, ..., true)
revokes the host mapping before host_write_faults(page, ~MAGIC) runs.
Because the write happens before *page =3D=3D MAGIC faults in a present rea=
d-only
PTE, it only exercises kvm_gmem_pfn_fault() on an unmapped PTE and leaves
kvm_gmem_pfn_mkwrite() on a present read-only PTE untested.  Should the host
read happen before the write attempt (or should another write attempt follow
the read), and should a direct store *page =3D MAGIC be used once the page =
is
writable again?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027154649.9157=
1-1-griffoul@gmail.com?part=3D14

