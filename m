Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7DE8606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UKdfT/OZ
Received: by kanga.kvack.org (Postfix)
	id 110626B0C06; Fri, 23 Oct 2026 19:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA986B0C08; Fri, 23 Oct 2026 19:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4386B0C06; Fri, 23 Oct 2026 19:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA7FE6B0C06
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:32:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A02512026C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:32:22 +0000 (UTC)
X-FDA: 85355492124.25.6893342
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B8FB8140003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:32:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UKdfT/OZ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792798340;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cUpsYXA4p+AgcY2utW3SVs0gcNM9y9RphrhZOvqDytA=;
	b=aQ2pmQasuhtAD62/so6qzvO6s3WjGTwqmqQ1CfGhDY9AKwBXWyENePc5UiwiwT6sN/j93B
	2s3h0F7CwNysz1NM0xubHlj1Gk+1/djkzV/YocEfV5QfX+kEtD7FwIB9YicVooTPtZyjRE
	zSywTHqVZmpbt4QMtwtqEhlHXaQdeIg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UKdfT/OZ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792798340;
	b=qXByYswj255dtAiqHhDenWLa8VLCvJm+aVGsHbefDf3cfzYQODAZOiu2yWba29b2ZoM1et
	hG+DxOHo3H0yow4shwpbUOX7hNWjdNrnlcG9onIDgpyhCyxeEryzSObWcC/ZGwecJ7JVTi
	KedbPBFzJjwi7lnpyTLrkaUeHY/MPtk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CB4A60A52;
	Fri, 23 Oct 2026 23:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC0E1F01825;
	Fri, 23 Oct 2026 23:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792798340;
	bh=cUpsYXA4p+AgcY2utW3SVs0gcNM9y9RphrhZOvqDytA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UKdfT/OZXVsr5JNMxUJ4xUGR5FMzBjw2rLouHhtfv7TsAdWvn4MfBIXPwZiFuJpZm
	 LlpP3saAINecEFdJUKm1nQnQH/7RBoHPEkAQqUJVuODcZofE467/Uwi5TUgTcKeCUr
	 +uSzdFDPmmpXGm1K2DPcEcWXE3V6lFeWIJK5QaKXny2yBHmuTCRxqzYF+WaSE55+r2
	 svOHmVOGFENXAq3upyZATpdYrmNhys5CiEZRsVO4cVvCuvAS3521CF5lP9l2G0+UZ0
	 tTKj8lVqNE3iW21v3+zFjJQlRreIMS3FfAo4AnSws3PzY83j+8YzQfduZ9mogig340
	 ING54nvBLYZHQ==
Message-ID: <sashiko-outbox-183414@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 50/50] KVM: selftests: Test guest_memfd
 conversions with sample memory provider backing
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
In-Reply-To: <20261022-gmem-alternative-providers-v2-50-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261022-gmem-alternative-providers-v2-50-5dd1dc6c660a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 23:32:16 +0000
X-Rspamd-Queue-Id: B8FB8140003
X-Stat-Signature: fh7f1d3dcyo7qnr4w9xqbpc984odne53
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792798340-455733
X-HE-Meta: U2FsdGVkX19cVBDv53qEgD6yc9kROWKFSr1Oqj/0MkcB7NG86TeambZpJYJhsQmGTcu5jF2XffmNke6HKAuc0oNGydkIJBJXaqP/MNMarKV/FnMzBHqtID+qr8HCMVkfhUMzbP6HtZM1zeuL9YrsmDN79uKcpwp0c9tTg1oW0lU0gQxeGnaWOAmW+1ZA1C41lI4VtySBGVAsH8lQP5+JD3NPqnQDEa9D7NcVPzAwuz65u71BFHn0KqGpQfOc6pjiw66X8g8P7OjvGxItl/VPyWghwpf0a5zIgN87PuRT6L5ZmlqNr2HrG2Qx8EUalIOpR/C33ijnrV5g2tg81ypnw/EMVd7ukfBHuiooTgYWl9mVRAKRXD/w6r/jFyKdbpgTPIEsMAqm43a0cEOUOLcCsq3+BhamKJjT2MnsoJL8wQFb93tNGcbmnL+r6RamCR51giQJCVLr2ZMnajSHELevstRuzPnKbHbAXi706CbKhBUd4lkmnFKLOEW/8eK6Dv3To3bSapv31onbKONZA9x5NSnVasfJ98o8Rq9JcXPnKvPcQSQixE1Emtcda0SUfg4TOGICijUgCgbiI+PGBY65q4km+QFxpAkZZOfLorjW+3AfI/WaPEg647xv2tibfMk5QOgNQeOCiWlT9cKLNyRdViSz1N4fxI5ZFlAlH4jLIq8KVJybZBtYYcxnzfbcrr0vNtg03A9K3OgvZ43ztM7u8eZs12o5YGFhv4SQJ9x+lWaf73LY6+w13oTlF7Ct0Abxa+WdyN942EFxu43ozG0Rn1WOINuUlfWtl50zIqztZXTBdJYcO4/Tc1zj00irwcd5OEBqXfOB0y8GZ8EoPhzsOjPjSzkj2gDNiJ8JeRWGHPQ4nOWawVxr/VwBVJI7h34l1+HXDb/tp0DRTK4C1H4PVM7uQ4Nj2e5d3xf7C2IN1Yp4LseYcqO4Lqc3BIT/zd2a5p+f5Hl54UN+ZRJsDON
 y6fEHgAV
 lYd7+byR3Fblcj7224LUMcT0Mk9JqniovsbsRR5hRSlPe6raNLQPwkOu632uiokGR43IrIv5YLyhFdNr3mlCNaAYPFDxIaKP9f+Lm6oevZBYf2nOiOE2Jgk/LdI30o4a9Cl3BmHVjbl387ZIdntrm5MqZ/jveJv75EY4lGyB8UXl43bO5DrvLMXKaEgnY5+hR41vkTqGOSr8WIZzvHU+rvKVr+bFX8DikSbfStODTFJYEAcKjbw33EFReU0CTm2JsorE3EBPocZNs2iZOZY3zFztuTLmOfFqizsxABDDQ8llgbG1BrU6qSTqy90hrJBXtkt3g1pqcpdm91cI2HKnjpZZjS9kDWy9ciC+fNU5wFosrBkJQ/ozzjEUt0b5Xw3UHSVoasQCF3/7I7tVA5daYIv9w4oqWb3zw/d2EtbppSA8qYxU/5I6sVVVfdlTeQHCiWRfluK5r/avkaX4O83Z4vGsTRBD3UlJPrYz0jmaLD5nXnRwRpHftlYVWuUZdSz8LNSrafpJ4d0SJu1uZHJslCLrrTsz+PZwtCk4OpoTA/FIJw/Zcy4sw/KbGEG8nYQyYM6l5TaJ8roDs4sopBVLl6iTjLlcRO0RVKPtDsXSwzoqwwR0Pi/G+dgLUbRQ4R+keVeTsQbEuGMHRpTMmxU4uNYCh3G6mCGYl0Z/0UKhIcSY+0jB0kxISz228AJsv5VYVw6sJgo60GYpS7qY=
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
- [Low] KVM: selftests: wrong relative path to mem_provider_sample.h
--

commit b071597d5a3f5abd9db2726fb150510172e23946
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Test guest_memfd conversions with sample memory provider ba=
cking

This patch adds a fixture variant to guest_memfd_conversions_test.c to test
guest_memfd conversions backed by the sample memory provider module, skippi=
ng
the variant if /dev/mem_provider_sample is unavailable and asserting that
page pinning fails on pfn-backed memory.

> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test=
.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> index 023df9cb9d4a6..b99e4cdbab8e6 100644
> --- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> @@ -16,11 +16,13 @@
>  #include "kselftest_harness.h"
>  #include "test_util.h"
>  #include "ucall_common.h"
> +#include "../../../../samples/kvm/mem_provider_sample.h"

[Severity: Low]
Since tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c is five
directory levels below the kernel tree root, four ../ traversals resolve
relative to the source file as tools/samples/kvm/mem_provider_sample.h, and
relative to the tools/include search path as two levels above the kernel tr=
ee
root, before happening to match via the four-level-deep
tools/arch/<arch>/include search path.

Should this use five ../ traversals to match other five-level-deep files su=
ch
as tools/testing/selftests/kvm/lib/kvm_util.c:

#include "../../../../../samples/kvm/mem_provider_sample.h"

> =20
>  FIXTURE(gmem_conversions) {
>  	struct kvm_vcpu *vcpu;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022-gmem-alter=
native-providers-v2-0-5dd1dc6c660a@google.com?part=3D50

