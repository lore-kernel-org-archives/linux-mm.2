Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF516606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VJi1is//
Received: by kanga.kvack.org (Postfix)
	id 128AC6B05D9; Tue,  3 Nov 2026 03:05:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1796B05DA; Tue,  3 Nov 2026 03:05:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBAC86B05DB; Tue,  3 Nov 2026 03:05:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C273B6B05D9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:05:39 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F04AA7D2A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:05:39 +0000 (UTC)
X-FDA: 85393073598.24.4CE0BE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9D5C1C0004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:05:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VJi1is//";
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693137;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umnbAdtT+FfOvb0pvOhjXpEkWgCQHgGLRUKTgDc4pQ8=;
	b=Oq3If9wqlv5v6FkPiLJ34GTSiTV1sj3/nzyvbU4yANhWATIgJWR45mV1gsSJt8FHSqeV8y
	D5i51kfcLbLj4EuWBQ3oNCHjCrXWi88r4+z7+5czdErLUEOPmqPOfz/9zlPheNFFvpk9Id
	MRw/Aew1X5qStbNkAmGPjgvkwh5WmjQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693137;
	b=C4QlXOttWQuv2HrnN4NYj0IeBVNdz98+dTKXnZoA+XD0Cau+qC0dNE/oysSc3lUwWd62hV
	jdB4d41MU1UIXoVbyNxtO0wJTk92AxJvobiK5CljFRGJh2KJvTlOyxy8bzQWqQVhPKw5ag
	Bn1T0tix5cHQnkUGPTYh8TfDHJloAGU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VJi1is//";
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD4A842CE8;
	Tue,  3 Nov 2026 08:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258971F000C1;
	Tue,  3 Nov 2026 08:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793693136;
	bh=umnbAdtT+FfOvb0pvOhjXpEkWgCQHgGLRUKTgDc4pQ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VJi1is//p2sWAyWTwjaVVIExKc5I6lZlBxcdxKoFrLj9H91l+ReJkCJ8L8aM92RAm
	 yQCWRfFKaTDxG1nHrezU2Dhgznt3AlWVvx/T1jJNdivtrOYJNk2bdJc4kNhrEeW6Za
	 BWAiyzMGj/Gr6oJjv+fAdVVh+F6RNr37eACPRlUAlVsmFrcwA5lMkbFX8UZ9WpdyRg
	 d+zvoaX7tILD9qv+aMT4rcqPPNxUeHqHz6d1c45/XR9FXCgaCAzJkJeRDJfmHbpAUm
	 X1j9iO0TwfHSQKsMLweEgS7DJ4Szxy3ltDM9LCY16q1n4OGGGXaniv9KBH99dw75F+
	 72M8AnNaTGy5w==
Message-ID: <sashiko-outbox-194794@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCHv2 bpf-next 5/8] selftests/bpf: Test user memory mmap
 kfuncs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiri Olsa" <jolsa@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "John Fastabend" <john.fastabend@gmail.com>, "Federico
 Di Pierro" <nierro92@gmail.com>
In-Reply-To: <20261103075916.100050-6-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org>
 <20261103075916.100050-6-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:05:35 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: hh7ujcx8gg7f9sdnyrozihyzir7nkeji
X-Rspamd-Queue-Id: 9D5C1C0004
X-Rspam-User: 
X-HE-Tag: 1793693137-8666
X-HE-Meta: U2FsdGVkX1/eKFFvhRe75iZfrNCpihO2CO3ku14C6/G/hP9B3UHTITyk1Dk9/Sxs9k1Z9VPlG51xEzSw3DkP9w6HBMz2aCRivXBSLd0EKjxtgmf0uOV9W5p5fGPjZgPXXuaduyev/d83QztgEl/0cdlBygCB3ZrFknLrCf9ZSAd3SU2iMcGE7fCHAlfKAoea1b4VdHGt8TBB26Qasg7wDWL/7bjTDqdETNwLsuXYTnQf2AT19HeFms3Awy4/gSjcv04DC+TriWE+K7ZNdSZopEHvxxUCX24ibJhQkQwTWPzc1QkTV9QNWThFkIWAEjCtAEgSycwONqvjfADxl3KmpowXk5iIdYuH9+EYQPv3yuCBmlACLlIqoE5wb22X9yMqCt68G/vKZVj1cOsql/Gz8w00kzBEXzzffmIY64c/eQcIMLP1Dq6uiLE186BF/SHPl+qvBVQxOrClhf07iVObnKbGbFGef6vX51x4sxMRYFh7phtL1iZ28oCJJ9w2KsHcr+U8/9u+ysdHIb59+29Tj7WkqVA3naYbMhgNaPiULHiP2vHoeJs7viFnUE4+Lp3Pz7QmbakFg/5LMjeWtViI6o5kH/w0SIYgUxcBpF5+y0g9w0KPyqMd8iqYBniwT/c2MQmKUnfK7nq1+7NsgOR5WGGC882K8LpSZHt66cqRi/v8tqrHFrQDSKd8z+983kxsKw6iss2dy7NaM6iESc+QKoQywt7CKA9vX0cEcJP46VoXMuv4klJVnbjo03PrEyFmxYd2Eq7jZXyw8XWydFpmyZzHPDLo7TDlIL3FeTzmMO5GQrD6fmNTtvwFkyzXl3rdFcLDL2Ta5W/nqtJCeEXHPWmgyGbx9rlo23bQOHdvR3+Xw4gJnPlgIPqzXsFML7/xiK7M7u7v68s/9WTM4VuI7SC5eUWhkF7veIOzoTbFFVxDcmrxL65DYzvx0zUgviLswDarGdsmU71UHYSVb/5
 WzdfC990
 AHOUtpp1Xhj/o4bx1TJbrf0gWjuncOS0vG4j7SmzoBcQ9x8eB6za3fHr4zkWOYoIEgX/Wt6zaaMLtXY462uZDVXf955RwmZWcq4Pe8nmPNMzP9w05MWCdQ/7/WMoGP/w/PNR0BOIem2yoxX2I82f8/XJJpbQi92PggbFceOn7eKd6OTUmKj6iyPvHSh87uQ1fy4q4Ua8UjfF1zNnUrBR/Z8Ov0d0QwFN8j3YLDaFd2cdQqEoP/taJtTZPrGlwfmlDC5uGLbS/KNDGJzdyuY24souYwDd4JsoqHZBMe2gwIBcu3ND97FOR5VFQ9TwQV8SiWYXggt+CB1yZ2lrak/V6CCvYXsKiC+dO3+A6Nued7wnVQD+cPTwGzsmenhjWIy9/U6kyXEFUS2hTllPO/TXHgqz8jdTQKJUwv+sXsEcP7jKHPP87m3Jq5Xr3IAmPi4gI0bauh498x4DqYx/ozPItbUqyj4LB17DUlGXxqyREO006cXCJaSvnLGdGqrVR/keN5txzZZZN1wfZzL35AAwoTCnJgapkhXyuDAZ9ZvlgWyV5sn4GF4Ds2hh94l/xEhwhtuGhXNSBLugpNIPwMZeyW2nOM6WFhqZYAzxeOt52duGHbP94KdXmGJ+Tn6IC/z56Z0AXS/zkMU+0/7wLFG98HILcvOs7oD6sV1e0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] selftests/bpf: call to undefined get_procmap_info() in user_mem.c
- [Medium] selftests/bpf: unresolved kfunc externs in progs/user_mem.c
--

commit c7cc5f98b3a4b4d8d168ef0934e6c41fe197849d
Author: Jiri Olsa <jolsa@kernel.org>

selftests/bpf: Test user memory mmap kfuncs

This commit adds BPF selftests for bpf_user_anon_mmap and bpf_user_munmap
invoked from a sleepable uprobe, verifying mapping permissions and
unmapping behavior.

> diff --git a/tools/testing/selftests/bpf/prog_tests/user_mem.c b/tools/te=
sting/selftests/bpf/prog_tests/user_mem.c
> new file mode 100644
> index 0000000000000..f301a18437062
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
> @@ -0,0 +1,112 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <test_progs.h>
> +#include <sys/mman.h>
> +#include <sys/personality.h>
> +#include <unistd.h>
> +
> +#include "user_mem.skel.h"
> +#include "trace_helpers.h"
> +
> +enum {
> +	USER_MEM_MMAP =3D 1,
> +	USER_MEM_UNMAP,
> +};
> +
> +static noinline void user_mem_trigger(void)
> +{
> +	asm volatile ("" ::: "memory");
> +}
> +
> +static bool check_user_mem_vma(void *addr, unsigned long size, const cha=
r *perms)
> +{
> +	size_t start, end;
> +	char vma_perms[5];
> +	int err;
> +
> +	err =3D get_procmap_info(addr, &start, &end, vma_perms);
> +	if (!ASSERT_OK(err, "user_mem_vma"))
> +		return false;
> +
> +	/* VMA can be merged, so ensure it covers at least the requested range.=
 */
> +	if (!ASSERT_GE(end - (size_t)addr, size, "vma_size"))
> +		return false;
> +
> +	return !perms || ASSERT_STREQ(vma_perms, perms, "vma_perms");
> +}
> +
> +static bool check_user_mem_unmapped(void *addr)
> +{
> +	size_t start, end;
> +	int err;
> +
> +	err =3D get_procmap_info(addr, &start, &end, NULL);

[Severity: Medium]
Where is get_procmap_info() defined? Both check_user_mem_vma() and
check_user_mem_unmapped() call get_procmap_info(), and this file includes
trace_helpers.h, but neither tools/testing/selftests/bpf/trace_helpers.h nor
tools/testing/selftests/bpf/trace_helpers.c declares or defines
get_procmap_info().

Because test_progs objects are compiled with -Wall -Werror, won't calling an
undeclared and undefined get_procmap_info() cause compiling and linking
tools/testing/selftests/bpf to fail?

> diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing=
/selftests/bpf/progs/user_mem.c
> new file mode 100644
> index 0000000000000..e3b0689f5f2a5
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/user_mem.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <vmlinux.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +#include "bpf_misc.h"
> +
> +char _license[] SEC("license") =3D "GPL";
> +
> +extern unsigned long bpf_user_anon_mmap(unsigned long len, unsigned long=
 prot) __ksym;
> +extern int bpf_user_munmap(unsigned long addr, unsigned long len) __ksym;

[ ... ]

> +SEC("uprobe.s//proc/self/exe:user_mem_trigger")
> +int user_mem_test(struct pt_regs *ctx)
> +{
> +	if ((bpf_get_current_pid_tgid() >> 32) !=3D monitored_pid)
> +		return 0;
> +
> +	switch (action) {
> +	case USER_MEM_MMAP:
> +		user_addr =3D bpf_user_anon_mmap(map_len, map_prot);
> +		break;
> +	case USER_MEM_UNMAP:
> +		ret =3D bpf_user_munmap(user_addr, map_len);
> +		break;
> +	}

[Severity: Medium]
Can user_mem__open_and_load() in test_user_mem() succeed when loading this
program?

user_mem_test() calls bpf_user_anon_mmap() and bpf_user_munmap(), which are
declared as required __ksym externs, but neither symbol is defined or
registered as a BPF kfunc in the kernel or bpf_testmod. Won't libbpf fail to
resolve these kfunc BTF IDs during user_mem__open_and_load(), causing
test_user_mem() to fail unconditionally?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103075916.1000=
50-6-jolsa@kernel.org?part=3D1

