Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81734606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 04:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lqhhOw53
Received: by kanga.kvack.org (Postfix)
	id 454106B05B5; Sun, 22 Nov 2026 23:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4057D6B05B7; Sun, 22 Nov 2026 23:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA706B05B5; Sun, 22 Nov 2026 23:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 084FB6B05B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:08:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D0971A078C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:50 +0000 (UTC)
X-FDA: 85465052820.02.FF7668F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id ADD2820004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lqhhOw53;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795406928;
	b=BoEFYMPqML8587qQA87Qsf3aG0OMMgyJwi64FSLTTfkLQDET+nnhFip2M+9ct9mY+cjBX8
	a9qwCSglx0L+5RG8LolkD9/KaZEj3jwExEfCqU7DP6HURS2LmDy73YE6UPNEn9/rbbd3Wq
	ubO9xFwxY/lYjBIZKNclvv9fRMr7nDQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795406928;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSFrqelmXYOR7e055DYTSS38B8PMoWS3fijMZl1LaVc=;
	b=ll2UFUd/BvAK8irhcAMWp48i2Aai/oi0pDoLXpBx0QVczgcfYDRpco/CqOhPi7IV7530wb
	l86//z5okYIEUQR0Ft+/Zcp99dsKvUnykMrGA1/npjvBd2wUbjcZhU6Cp8oodQyTUQRlht
	34v8u+zLkLxrUXuc3fKhxuW4Cf7N6/s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lqhhOw53;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 093A143BF5;
	Mon, 23 Nov 2026 04:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9261F000C6;
	Mon, 23 Nov 2026 04:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795406927;
	bh=SSFrqelmXYOR7e055DYTSS38B8PMoWS3fijMZl1LaVc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lqhhOw53HKrcFD3ZAHM3Uu+DZcTtjv8M95dRHLLa7BC+uFRv3QTLs48wqp1Ak3BLL
	 6zMVFbJtkr6Lo3+fHBJ9gWzPUn6ZFiWXuoZAC1vkkiYs3MsKaENOiwd3elOkauc/Tv
	 whV7a+909cfNfsB9So8zW0ShO87vd0I41fl5uEfHkMdPAGoMl1JWCHngcg6zAxwip+
	 hGnMgiYjhriCotFPJDWnRF3qLW1E/yrhefUCzStnqKH2qUsbyng3tk2CloqA+Oy26S
	 ALvTd7AHULQeEeDSlyhGHjECgcmf/TgTQvRKwd1fcBAx6KtPmokrz7/DKaEl5guvqB
	 h6zAMtoZ18ABw==
Message-ID: <sashiko-outbox-228638@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/19] arm64: Add bbm_through_af capability
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Houghton" <jthoughton@google.com>, "Will Deacon" <will@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "Linu
 Cherian" <linu.cherian@arm.com>, "Mark Rutland" <mark.rutland@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Nanyong
 Sun" <sunnanyong@huawei.com>, "Yu Zhao" <yuzhao@google.com>, "Frank van der
 Linden" <fvdl@google.com>, "David Rientjes" <rientjes@google.com>, linux-mm@kvack.org
In-Reply-To: <20261122184453.2668189-10-jthoughton@google.com>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-10-jthoughton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 04:08:45 +0000
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ADD2820004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: soytafzmkm1cst6u3ic48izg3yrbwjdo
X-HE-Tag: 1795406928-609933
X-HE-Meta: U2FsdGVkX1+NbcX+LMeR7HXA8S0rd4J2PNRiwdhm/yoqi1dv5p1U6vLDMuKPATxij8aHxKroHLKq1JdS2X+SuWHxr5gDlg7bQtXRw7oJ9iolGI6FLD3qqpUzccMlFd/BPhkuXq10d4O1uv7enne2qtlkZFHrY+tg3HMmsgMSKvzZ0d5AhHV7IYioGyyr2AdiIhY6TNXkI/tABW3u6WVS9Gj0A8J4oK26Hq/EvNkerxp1sTRGJt/e2nRg0P9HOzEgS3VJ5GvsgMa0kARI4fmTwXKNGobfUhEky0rdZ5Wl6VGNE+k4F7oTJcVqAIaNUALot0hNztAeCcx+/NKz35cUMTbU/AjXGXqGYoUawpuFZUjqww1OiBy48A5DfafZCaukbSzNu3kj6Vx5Azjh0r1d1vFKKGz7ZJahgx48vm3dwB9Vijb+CzEnT9AzpRfnHuf90vf72dt25s4ovFqO5sbVeO0XbhShL8qp4FczcnPSfiToHkXy/OViKirsiLtxPpCS18OhEpragA0qMb8YDhADYbO14zBDOs8FYh1ZggpP0b+Rg/G1/ZHP4ZRc1yPfcmrTy+oZM4x3jJQB+ez/HIoYy9c1UyBIPxzA2GDl8wT/UcoSF6LMYRYRLLYIWenvujPoTbVR9ZmPfQVDrASvi+8pD803F2nRqJGnKrPKu1eBP6wkViHHJKsgcmo9DELfEKzXcO3lLYx3pfsZvbIjnnSdupRgl0YL9Cg63tNZMolXLFoBe56jjn7it1CUtFMmDwVihZ/CKKllFbNtyD4tZ7dqqRJLogmhBZkwZIEgVzg/oBr5wQZDnLCPEUYUp/aZiZOiZxBnZtd9c4Cee2ZFibihGIZ1fmb4LPj6KAFbYjbQect+Jnkr6xzXKWsIdZ3lLlqIn3scHu6Zx4kN3vZba3Tk6i4MGCqVdievXuVQT6edmRe+5VOWOzqGcJNwRKj0OM4wP7lzqCGZ9BGvC0PHOOC
 nG7UMs3B
 BMxaiFBNrMvFxtUvVvv9NOeIWcbRzUDaqK/gNOdY/7pqPOEIZP9VVI01I2dE6F7HOlyJUWy+E/Ty0QCnHSKJVEOR7eymtXIpqqpFBJqRwYCBO6rmlgN1+bHC8xRjj9tBD3mZZp716Uu8KG7ZHg/Z6yDiUJDaTLXjqP0crX0sSA60v1wrX+7qDw8xfyaUSvjjj2oXunl1Bu+jfYou2PaYL9C9qVQsA51KapqU4IWP7BDKkH+u6LD6CYYzIJ6mglQ3r8XnGjrCE/ZH2ZWugmlqke1qeHu4ylJKDkpR2A+hYkO5eCrW4h1oLtyj3YluBjt8h2u8esg1afFFCa/6FqzODo9D30oJaRRXfdKBLsj60jcendwHHjLj+VUaFBKF2mmz7HFjVl6S2OzYEpx49vG+0BheMzqbzyD15v0wp3j/mMRk8dWoxx+vj8H8+qBRW6oXApF8yAV7IdXbsfdHOMi86sf+9MgHH7lqMWiJlVuIBAsjUeGc8OAk55/5186VaZWWt06HQLIfO2jkPHcab6WBOZ/x3Xx8YOzz6ERfodUMNX7qXXxFpJoXDRGi+KeYZhIXL24yUI4UWDztLzvKVG5MwKV2cqZY9cIk4mHu0NZVsVU3ODH0lwtaZHRXkrMphzX1A4CiprMBcfOdo2oKzF7peYOyiVjOptLAWvY7Ffwx7R6XyHzgpyvtmoshWye54ao38MaS7ZA4n8w6VJkOO0eBxecHwPHv12nyiemqF3i47sv+3HkHBJXcgQtIgDQ7qafV9wgqYPb7yQ2pMYNXnM/l4oneVVYmPOXyHS8WVS4BzWpVR9O5hi4NprjkFoVzXg+Op23zJ4mMwPtmV1kqDYQioqQ1YxIpxUABeTlBypacbqmWOwZQVTBmlrVRBrrTompwr8NfAhBnxqE8mObmwYfVhd2biyEytJ6akcXyJ1DePWyC+4xfV25hKO96zGoz74NURyMcv
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
- [High] arm64: cpufeature: has_bbm_through_af() checks BBML3 only on
  local CPU
--

commit 65766d54bb753e1e16346fb12f4bb107c66114eb
Author: James Houghton <jthoughton@google.com>

arm64: Add bbm_through_af capability

This commit adds the ARM64_HAS_BBM_THROUGH_AF system capability to detect
when all CPUs support BBM Level 3 and hardware Access Flag updates for
HugeTLB vmemmap optimization (HVO).

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index c9c9a6889455c..d241638b51435 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
[ ... ]
> @@ -2044,6 +2045,31 @@ static bool has_bbml3(const struct arm64_cpu_capab=
ilities *caps, int scope)
>  	return cpu_supports_bbml3();
>  }
> =20
> +static bool has_bbm_through_af(const struct arm64_cpu_capabilities *caps=
, int scope)
> +{
> +	/* The kernel only enables HW AF updates with CONFIG_ARM64_HW_AFDBM. */
> +	if (!IS_ENABLED(CONFIG_ARM64_HW_AFDBM))
> +		return false;
> +
> +	/*
> +	 * BBM-through-AF is only needed for HVO. If HVO is not in use, don't
> +	 * penalize systems with mismatched support.
> +	 */
> +	if (!hugetlb_vmemmap_optimize_enabled()) {
> +		/* Only valid if HVO cannot be enabled later via the sysctl. */
> +		BUILD_BUG_ON(!IS_ENABLED(CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSC=
TL_RO));
> +		return false;
> +	}
> +
> +	/*
> +	 * We need BBML3 to support Block -> Table transitions without taking
> +	 * faults, and we need HW AF support to support changing the OA without
> +	 * taking faults. has_cpuid_feature() checks HAFDBS >=3D AF, reading the
> +	 * local CPU's register when verifying a late CPU.
> +	 */
> +	return cpu_supports_bbml3() && has_cpuid_feature(caps, scope);
> +}

[Severity: High]
As reported by Catalin Marinas on v1 [1], can has_bbm_through_af() falsely
enable ARM64_HAS_BBM_THROUGH_AF on systems with mismatched BBML3 support?

ARM64_HAS_BBM_THROUGH_AF uses ARM64_CPUCAP_SYSTEM_FEATURE, so
setup_system_capabilities() evaluates has_bbm_through_af() only once under
SCOPE_SYSTEM on whichever CPU happens to run smp_cpus_done().  Unlike
has_cpuid_feature(caps, scope), cpu_supports_bbml3() ignores scope and
reads the current CPU's local ID_AA64MMFR2_EL1 and MIDR_EL1 registers.

On a heterogeneous system where all early CPUs support hardware AF updates
but only some CPUs support BBML3, running setup_system_capabilities() on a
BBML3-capable CPU enables ARM64_HAS_BBM_THROUGH_AF system-wide.  HVO will
then perform live block-to-table vmemmap PMD transitions while non-BBML3
CPUs are online, and re-onlining a non-BBML3 CPU via hotplug will fail
verify_local_cpu_caps() and call cpu_die_early().

The later DO-NOT-MERGE commit "arm64: Drop BBML3 requirement for HVO" in
this series drops the cpu_supports_bbml3() call, but if the BBML3 check is
kept, should ARM64_HAS_BBM_THROUGH_AF use
ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE (or check cpus_have_cap(ARM64_HAS_BBML=
3)
when scope =3D=3D SCOPE_SYSTEM)?

[1] https://lore.kernel.org/r/aoRnMRZ0jE0ycwcT@arm.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122184453.2668=
189-1-jthoughton@google.com?part=3D9

