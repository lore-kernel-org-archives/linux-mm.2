Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059A5606A321
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 20:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BGve7nPZ
Received: by kanga.kvack.org (Postfix)
	id 21A726B0BED; Fri, 23 Oct 2026 16:05:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2006B0BEE; Fri, 23 Oct 2026 16:05:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130666B0BEF; Fri, 23 Oct 2026 16:05:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3BC26B0BED
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:05:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7432214020A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:05:15 +0000 (UTC)
X-FDA: 85354970190.18.A272BC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E2072140007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:05:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGve7nPZ;
	spf=pass (imf26.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792785914;
	b=Qd19AWNaE1bM9Y9bRlTLKlmZUpoXT373PNNqple8YhW8Aqt1swkFebOaB1+sGqa9E/kGez
	BIP76P042NN50sneU8lLeAvn4qNpCl4N7VwkHBue2sw/cC6KVIJOwwW4s6neWl4dGze06I
	EMLweHQCJ2ZgF1srnvLVSxPKEzSK/f8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGve7nPZ;
	spf=pass (imf26.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792785914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=NMpzoe28Li6scyvq7gG95vJno5EdAW6a0YsgQjZX2q0=;
	b=l0q+u6jocUU+epLYOkFvgSLrcNJZMFZ+t4qYv+hP6DI/jefsLDYweXi+r/7yAcfuWRRWqQ
	vqLZtvWZR3Dg+90JqGHCA9g8xIKseXFO6xbkH8xRGnuiI8KIUJl1WqZChRHAr1iJot4iZS
	Qto5TFAmk1Q//+DY3/eZI3fs6hJUcSs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C994140179;
	Fri, 23 Oct 2026 20:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813B61F01825;
	Fri, 23 Oct 2026 20:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792785912;
	bh=NMpzoe28Li6scyvq7gG95vJno5EdAW6a0YsgQjZX2q0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BGve7nPZbSwa2LqTQNHByaYKCoffL8elEuhk+jlz/gI5i7hV1ZK7iwu/qtmG9KnfW
	 qDLQ6u36lWhx7UicKyDcMUNChfBFrWn3JenrDFldoBbRTNPnoVuGnXK7yry9/I+UhS
	 MWE4pDnSM609ghIOhSw3yImpZyKuDOHWSrhjgRD5US80G6Qkq1oMwCM7PasP4Odoa5
	 eWESoT+iBiqSqRyLeo/eyLiBZIlzhddfENhxpqe5rRVvDNGrCXD9ZfhommNweBCA6Y
	 MohZtgivmb5EyOPKL9f0ST9iqF4qVtUezx3RIOK809+Ej3U/6BhD3Jc4as7eFyeM2/
	 DlEx8t9aemyMg==
Date: Fri, 23 Oct 2026 10:05:11 -1000
Message-ID: <100602397eadeaae2e3206e1d9aae55e@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: convert cg_read_key_*() helpers to s64
In-Reply-To: <20261022042921.711624-1-wfelipe@google.com>
References: <20261022042921.711624-1-wfelipe@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E2072140007
X-Stat-Signature: x6keobz5n5j1wtnij3hgnzz1fa5oegr5
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792785913-57143
X-HE-Meta: U2FsdGVkX18iTkx4kfPveBagyBdAKqtCCiV+N+8cnCgnBj0aMtixEjiYvhhqFwO4qq3HDN8IRb7JVFqGJU5wzu8y3fq3cesa6Q1n6UDKWmyUtNrbRH0D87MZv7ac8dhCO+DRdepIJjh0zn0SEAryyyrkHVM9Y3bZEWVBtf3/zKJXPaHPMs3zqcJnF2DgFUJ9TnSFTRpEiVXloUYg004/7NjVLGcOmg08da4TSQCZAlaNBDqx0OgId7VBMsuK1WItbXqBS9zupgrFCanKnRTh3kV6swBCI+gmp45x8KqBdhrFXwpunns9a7/lXgflqfFkjDdvTqBIC7V9Hx/uavMzryl+LAuJXWASSQiShTE5zgWmAzoYm14PcDTj/yT9DKj6ynFarqh5+jvv7UDR8mtUl+sVCy0ge75EhzgVcS8baxFontAS4Ykrv4k6WynFF+OLbfsIjo/T6Sy4uBxxq0zZcg4SqxGWAFpNWcATdf/b6VJHQ/yRLpQe0bQfhel85SnEyjecjA0B/7ZF2SBlZDmFP81xzGzUA6KWzWsKRXO7Hqv7YLraTPT5kYplO+13mrrTM+JR4WSRNk1LVPCV9p3B6j3BZz9iyDG33LY0S8cNeHNN35gcbgQAO2RLt3SsUFahNh8kN9PAIlTDiIBPznAfoP24oXRfhUENaVKJYdB/b63aqRXAbnhWHatN3375oJy+Pti7rFGsCNvVCb98T5KiVssJxq2r4zSPOgay5ckf0V+nsohRPJnwqUGWyGI4cK0pG2VJP4erS/7mJv5V99yvtat0JAkDYRBHdp1inD9I9k9eJF5NPA8CiSwTshSMphlWIbpNKL7PD8XV2PSfJ84apokSKqRgg3vY+nqSgu9AhXJJXqX+A6QQTbEcSypmdFL+TBoJwGz74WaHr3sISjJoeDUEaGt0XY97MvJFuQyb07dBYiYRLwsMwGuXL37hNFAZYv5FdqtWpWBwA48zHb+
 FOfXZq5U
 thIqL5QwxRp4L/U/RDFtJyjrjo3wdwhBTuiqgQppYT6Qgw+0kirUd5KIbNsjlfey9dJHepvgN2TFs0rL9FMU24Al3UTuCWM+95N7eZlbyOecBq2UYVafsVa4cpEOEagNJ+tCIyXlhM9bU2yJn4cd9NjeHv0VGMIUkrFgJjZX/VCr7ef+ltZtcls1AKCtfEqPkT1JC4S6T4PKqoisYm13JdLxQKUrj6xZ0lLGHM/exFsfnLZ/5kx17GiKtX1hH8AoweQIs3F15UF+U/cTKC01QyxpmersjA3DREL8q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Hello, Wilson.

The following is a Claude-generated review.

On Thu, Oct 22, 2026 at 04:28:57AM +0000, Wilson Felipe Pereira wrote:
> On 32-bit platforms, cg_read_key_long() relies on atol(), which returns a
> 32-bit signed long. When values in memory.stat or event counters exceed
> 2.14GB (such as on 32-bit systems with large memory), the parsed value
> overflows and wraps into negative numbers, leading to subtle bugs and
> false test failures.

On 32-bit, glibc's atol() saturates at LONG_MAX instead of wrapping:
atol("3000000000") returns 2147483647. Event counters are counts, not
bytes. No test reads a value near 2^31 from its cgroups, so the false
failures are hypothetical. Can the description be updated to match?

cg_read_long() and cg_read_long_fd() still use atol() and return long.
They read memory.current, memory.peak and the swap counters, which the
same reasoning covers.

> - Migrate helper functions (get_cg_wb_count(), get_zswpout(),
>   get_zswap_incomp(), wait_for_writeback(), and cg_check_freezetime())
>   and their callers to s64.

In test_freezer.c, only test_cgfreezer_time_empty() is converted.
test_cgfreezer_time_simple(), _populate(), _migrate(), _parent(),
_child() and _nested() still store cg_check_freezetime() results in
long and print them with %ld. In test_cpu.c, overprovision_validate()
still computes "long delta" from two s64 usage values. A 32-bit build
with -Wshorten-64-to-32 flags all of these.

>     rebased on top of mm-stable to complete the s64 conversion across the
>     cgroup selftests (including updating test_no_kmem_bypass() to s64).

This doesn't apply to mainline. The test_zswap.c hunks depend on the
test_zswap fixes in mm-stable, which aren't in mainline yet. The
tcp_client() hunk in test_memcontrol.c conflicts with eb69e955de7b
("selftests: cgroup: make test_memcg_sock check flushed sock stats"),
which went in through the cgroup tree for v7.4. Can it be rebased on
v7.4-rc1 once that's out?

> +typedef signed long long s64;

This is the main problem. The KVM selftests build libcgroup too:
kvm/Makefile.kvm includes ../cgroup/lib/libcgroup.mk and links
cgroup_util.o into every KVM test, and access_tracking_perf_test.c
includes cgroup_util.h. That build uses -I tools/include, and
tools/include/linux/types.h has "typedef int64_t s64;", which is long
on 64-bit.

cgroup_util.c then fails with "typedef redefinition with different
types ('long long' vs 'int64_t' (aka 'long'))", so none of the KVM
selftests build on 64-bit. Maybe use int64_t with PRId64 from
<inttypes.h> instead of the local typedef and %lld?

> -
>  	ret = KSFT_PASS;

The blank line removal is unrelated to the conversion, same for the one
in test_cpu.c.

> +		ksft_print_msg("debug: zswpout=%lld zswapped=%lld zswap_b=%lld\n",
> +				zswpout, zswapped, zswap_b);

The continuation line was aligned with the opening parenthesis before
and now isn't.

Thanks.

--
tejun

