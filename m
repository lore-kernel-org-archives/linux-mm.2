Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50E2606D80D
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UWleJ/sF
Received: by kanga.kvack.org (Postfix)
	id ACA6D6B05B4; Sat,  7 Nov 2026 19:44:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1796B05B5; Sat,  7 Nov 2026 19:44:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8426B05B6; Sat,  7 Nov 2026 19:44:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74B846B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3AE71A037A
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:43:59 +0000 (UTC)
X-FDA: 85410104598.22.93F769B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 48061C0002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:43:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UWleJ/sF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098638;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxHF+HxMAXdqXZTq/8M2Y+JwmoWt4VoRh1g2RwdITdw=;
	b=2+E+9FuVCr7UZd0u0F2bUtQZ8DyT6wTCuAlXenLVWbIxrzfnxmg3UHljsFlEsjkhUZvqON
	CHKRXTIY73a3CjMsQDb4D3vO7gXOBhHAPfkiYQEoVSDBE0mtBlUrCgSoZpY8zriR79Xp56
	/Ta2mmQmiSteWfuMviCS2Oq+l0hXN1k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098638;
	b=p6DdUgbLEfik7Ar4t4ozP2sfpLO5BuPdk4wQ8tLsvvbdbDvLM8kf3g+VKygGeLrApyB8Jk
	gO/Cu9OXy7LjMxMW9cEDO46AzJylc3fOjFOkB1fdWBYuJHgFvlkYhRqAQq8wRWgC0ksKpB
	OXn9UGz6r3mYYHGD7JlBnUtMW3u8wTw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UWleJ/sF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C94443BB3;
	Sun,  8 Nov 2026 00:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2791F008A1;
	Sun,  8 Nov 2026 00:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098637;
	bh=yxHF+HxMAXdqXZTq/8M2Y+JwmoWt4VoRh1g2RwdITdw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UWleJ/sFhbPjTYUwvtieIOwhWr1zLN2XNKhrggy+vZ9k5fhbP4hS/AMBHeVyaO0G3
	 yBXgvrR2cMindlHKNbqVd+2m3P8Ww1/4O7h29Zd3AqVJ/5QG4RpvELKLvulD/Mkngy
	 FkptAiib4HO2USV4zhjqcSCzB3JWrGnQoakHSTYQwEqM5EEp/yYnoYZP4A05O3CpVx
	 iLnPaRFHo2/ynFVsXgzL3u/wbuoho2Bc2ytyK5KO0OJzNoeYnXNXu4e8k9JRMU9hkU
	 wNXj4bPUfDrhb/opyT9GMcgJrIYW5djJfqVevtLvCMBR1ohK0oWHPfq1fbI0rYGQrq
	 KeBlC4Bzcp7EA==
Message-ID: <sashiko-outbox-203421@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 10/88] KVM: selftests: Test rejection of swap
 tmpfs mounts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alexey Kardashevskiy" <aik@amd.com>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Woodhouse" <dwmw2@infradead.org>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jianxiong
 Gao" <jxgao@google.com>, "John Starks" <John.Starks@microsoft.com>, "Michael
 Roth" <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Sean Christopherson" <seanjc@google.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Fuad
 Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261106-gmem-alternative-providers-v3-10-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-10-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:43:56 +0000
X-Stat-Signature: iabsczseb1xq4su9ys9xzmjiqjdhcazg
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 48061C0002
X-HE-Tag: 1794098638-534543
X-HE-Meta: U2FsdGVkX1+ljPZ8gU8cWpV1quiR+3vI92BJ97Qxf/vafUa6bW1zCh7ALmU0LeK67nRYeAPB8aT6S18lAJCa1dzmeUOXL+7B6jazunXic+0lEDuUiapmoCXaOXGoKCIgiwhVC/e35schRgsLrLl0hD4TY1pxbpZmH6Xs0fjlsBAJ9Q1UYqqJKED739FyGKi9NeIoje99rt5ArVI6kAbIVUrrxnxE64nqv3z0bACikHOqW4OmLRu8lRcnKkPceVmrl8ybmCe2temV+BlxeCh8oShprooV+SFbjQsmozJLxpTqtX9P1oo/4wEHobpG+0nh052vcjM/8pFNGiJz54vwQQqcRGWRVjJwDA3df1SirdykpgoBE9SywnR3FZrfc8UFgGJK+ssCkZ/Zd5j8yUh7X66uG+oifClquH11G4k8Mu6bcsxgiINzWET9P+/uxH7fDQaDAvCYG3gbEKNcPixqo/bQtv/rVC7yEdLZqnwohVSDDNEAZMazwV6DdzszHcNtOBQX+976UFkKOoaP/DsK3uBVqKoRcF/rKnNh/OpAXGfNPUWptmvCL1Ic52jFylJ5n8t3401yixxBj0GjSlEl9DCmXoftciyvcVEL2vcLykmTMDzu2Ppq/ifJOStrN+3dLbfW3CBxGYS6Ap9X/fXdW8eF8OJJHSTurbhkpf53cOXQAuU20828upTzXw6vql5Fg/vwmMUfnRlRToNCespJNbHYpqWYKgKa1zDrMs6yXmOvesCpCFuR6xWLViBwtEl9NV5tcJHo/4uhE7J5Mrba7WNDlpHtDdcQd1MzVc3Lm4wH3dehK+BUSi3Ykx9FiBYckX4gCcyBDtZfCjqM1PC1wTkpgzp+xCCEb1UtnfBmK9v9lX8c9VEq+WEatzeWkCZhq3+kbN0RfaIftkQi3cvOGY2POfG3bmICO2doswmytPGRDQ0iBWLAzlzKQSi7+pg+910qWs0oKwHFhmilfNv
 fEX0pj/t
 K19w0cIhkpUoi8ubjwaBi6D8/wKD0wLOGn64hn+zeg4c76BM7DUCgRurXlQVDVaq4B1X6L92I4YJIP6ud+yS/1PI0ZpkMR/zlPsRxqzYvptLW1m2urba1HixD52xlJmRrGSEp8ML0ZMPmRkHW7mVzusNMMSuKspFJQK3cM7lRrc59ysJNCaJ0p6EWBMUXI3XscNFm3ESgnBd0TxoYM0sWm/etl5oU9cvcedjkeV5p2CrmuSBEqe056qXXG4w5w7XYV4amLqyfRTHuDbxih+l+dY0ECQNvFsgDlwykzWnkeD8JLv0BrhEg6ZimO8izTaydRz0UuptY52+38EBvVwDzC4+DpBxvofNCRxHMInGMuOopaN+dqtyzadYhck1im6rcd7npaK6OgbqnqpKKBQu1+MT9rM8UCTtls7lzUtNmUEc9v6CCB1M44ti4/Q4DwdQqPPzLGFRbzZOu7YINuZt/IwazoVjkf9hC2LXG58CvHpjkIgPdvNA5WAPVRUzCzftUVGvqJNfzZhY3Yrrakl57JrY+0/i3TQC8jjVlScKuDnNBpQeN9xRZA51eCefFyzKmg2sYf2PHPl2DlnJNpeA2UHXB82RBosTUy/sTHsaa5+D9/FlhP2J2ID40PVohZhQPeMNdUUzoD4RL+ss1amuoC4xnCdmH7O0qNEd7
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
- [Medium] KVM: selftests: missing CAP_SYS_ADMIN check in
  create_tmpfs_pool_fd()
--

commit 3ffb77e319f3b82f8e3aaa6439dea9dda37671d4
Author: Ackerley Tng <ackerleytng@google.com>

KVM: selftests: Test rejection of swap tmpfs mounts

This commit adds a helper to create a tmpfs mount fd and tests that
guest_memfd creation fails with -EINVAL when given a swap-enabled tmpfs
resource pool fd.

> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testi=
ng/selftests/kvm/guest_memfd_test.c
> index d62ae23256083..205f822e10c6c 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c

[ ... ]

> @@ -478,6 +480,73 @@ static void test_resource_fd_memfd(struct kvm_vm *vm)
>  	close(file_fd);
>  }
> =20
> +static int create_tmpfs_pool_fd(const char *huge, bool noswap, size_t si=
ze)
> +{
> +	char size_str[32];
> +	char template[] =3D "/tmp/gmem_test_dir_XXXXXX";
> +	char *mount_dir;
> +	int fs_fd, mnt_fd, dir_fd;
> +
> +	TEST_ASSERT(size && IS_ALIGNED(size, page_size),
> +		    "Pool size '0x%zx' must be positive and page-aligned", size);
> +
> +	fs_fd =3D syscall(__NR_fsopen, "tmpfs", FSOPEN_CLOEXEC);
> +	TEST_ASSERT(fs_fd >=3D 0, "fsopen failed");
> +
> +	if (noswap)
> +		TEST_ASSERT(!syscall(__NR_fsconfig, fs_fd, FSCONFIG_SET_FLAG,
> +				     "noswap", NULL, 0), "fsconfig noswap failed");

[ ... ]

> @@ -539,6 +608,7 @@ static void test_guest_memfd(unsigned long vm_type)
>  	test_resource_fd_invalid(vm);
>  	test_resource_fd_unsupported_fs(vm);
>  	test_resource_fd_memfd(vm);
> +	test_resource_fd_tmpfs_swap(vm);
> =20
>  	__test_guest_memfd(vm, 0);

[Severity: Medium]
Does running guest_memfd_test without CAP_SYS_ADMIN abort the entire test
binary here?

fsopen() fails with EPERM when the process lacks CAP_SYS_ADMIN (and setting
"noswap" via fsconfig() fails with EINVAL unless capable(CAP_SYS_ADMIN) in
init_user_ns), causing TEST_ASSERT() to exit with code 254 instead of
skipping.  Because test_resource_fd_tmpfs_swap() runs unconditionally
before __test_guest_memfd(vm, 0), unprivileged users with access to
/dev/kvm can no longer run the standard guest_memfd tests.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D10

