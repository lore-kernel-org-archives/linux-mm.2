Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74290606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oh+yOnxJ
Received: by kanga.kvack.org (Postfix)
	id 477106B0291; Wed, 21 Oct 2026 22:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427386B0292; Wed, 21 Oct 2026 22:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D9C6B0295; Wed, 21 Oct 2026 22:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1EA46B0291
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:10:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82AE3806F7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:10:57 +0000 (UTC)
X-FDA: 85348634154.19.BBA8C37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E58B3180003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:10:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oh+yOnxJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792635055;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6BWfsJKKbZc4AgOHX3577EDrG/C46AQp9NylRfvsXE=;
	b=NqOhlMvdqST8S+1doXAsyT3lYmPq717stBI5nWf3ADvLtkflmVJVyAmb/UnNvyza8jYghS
	Pbael7ZW+PbuKffnZTueK2d4NYF+kKQkDqPyI7y119Q717fBh2USA0eQliRiXswGcXH1zS
	dOpnKC1zHk6rF9ErvcXp/zDAj/1s5rI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oh+yOnxJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792635055;
	b=8Fdi7JzOQGJLGl7iL9HoWPHwIDzM8QYZyquC6j7DkzUk+MLt8V1q474T9cBbXgbB/xywYT
	2iNwFMc90fDcw912SL6wBFBjLwN28qn5BmZ4YHV+80kZTudxKhYg4wA00U1vVU234z+lX8
	8wUyFkXny3N8xE+Ir3RQSOn5eCvzQ+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95CA260213;
	Thu, 22 Oct 2026 02:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC291F000C1;
	Thu, 22 Oct 2026 02:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792635054;
	bh=W6BWfsJKKbZc4AgOHX3577EDrG/C46AQp9NylRfvsXE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oh+yOnxJpqvgV/lk5Tacr1zrgvaauG5fP+KLuSvGtGQ14XSqCsTK9Rd4laENNjuJk
	 nGpGDIA1DwI0ALQcP0OXMhiPk3iSNFc08IGNUO/XgonthO9UwRohX27uC2/YPZrfM9
	 DZjMPlPmyj7+zt/d56wg4KaOU5WYeM4bEZ41jzcp+T0Wa/aEnttp4uWwNOQwPZZHOJ
	 GS+VyoffycoEu1NwRb1SXYS9xK2x21111VL+H6l4+t1Zpu5tWc3DEBer6lliG+Gns4
	 3mDUEUsLIm9m/aZ4QZOvkVQLnVtDOenQSh2ZZWlLUxPP7pnfO/I0kThRZ8nrqjvdcv
	 t871p40SLvAyQ==
Message-ID: <sashiko-outbox-180860@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH bpf-next 9/9] selftests/bpf: Test uprobes and fork()
 with busy mmap_lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org
Cc: daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, oleg@redhat.com, peterz@infradead.org, mhiramat@kernel.org, jolsa@kernel.org, akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, surenb@google.com, david@kernel.org, vbabka@kernel.org, jannh@google.com, hughd@google.com, kees@kernel.org, mingo@redhat.com, tglx@kernel.org, x86@kernel.org, linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20261022015712.1297331-10-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
 <20261022015712.1297331-10-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 02:10:52 +0000
X-Rspamd-Queue-Id: E58B3180003
X-Stat-Signature: 7sjqesdezzbjnr1b71nbeda7isbnsuyo
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792635055-917788
X-HE-Meta: U2FsdGVkX1+OwfyichDzxaZBJ2Ogq5UWzQy5dogSUGC3OKRSLzTG8r4oKr68Uv82ClXLa2JfUVETKznFkMISyoncbTjtpgtKb4R1IcuwRc9CFyWqXSxETeRt/KUj8W0cc5Wmiuovk5xpb9pi0d0J3xqkcQblQWGyvcekqK/ueHxts5sEGWzAB03VsOwX6Rb8RgEylMtBfBLdpBYVsLbs/e5elZCuQ+0PR93FbkuUIggSBY5PUYhHQXaMSHlHuXcLV5YMpj0t+B8lQ1VNHtODC3mvPhJbrb3dk8cgpqPCwrUKl4KYseiLsAGQ/JGAFkbofnzfXwBb/1H+tOMztLPUD6LjppbI/mY/EgJCN3jmwiLsAnPNx91qccbrlAETvE/edx7rDI8j5Jy1DgJEyLaSwN80bi7IeWU+WB3hjhPvjsYRkIjfSz2wsyUFCZqx0pQiCS4TV6IBK588VrSEWckTOdUJDOGfYkyxcZO8FLqc7cvONon0E7VanF5i6GUV10NsQT3YMb6LU25r0nUqOoFbm4DyUUuoGAvUwqy8/t9jPjo9WPAW3crlG7uosAJ6kxZ8q8QeKb66vG8ycyZEi0DNzG5ujRychfAyAf0nsuKktxLAMC/KINZ2pczruLol6V9lqV5iQvYApeaSH2uUcWutIkt8MVZTYafEFpTy0Phjfxtlg5GfPyR8HdRH0/ggPf6TgA3JXyRKCvyGDQuui2XDGS0xK51qsm8zxrfML/Nk9XxyvA6ncAMKvb8AueBadrzchadL86MpSOdfvIXCbyNw8gM70Vefwq/XpyjpUhUzf0QY53Aj0mMo0QLmSSb0TqLQBn5OYbscIk7c13UOKGEc8a0F6Y/xH8/ZzTK8wjc5oyiQnUf9ZMIhWB7W6CLwPhVWMozG7C8pZyqvIl30QzAOy6LfqfIkHTjfHN3iPyZV/u+lhqOLW37xavN9GDK8u5cdKXTXLV0PbSqjGMFBMqN
 Xj/ik7ye
 A6m7Q1BDBbqTug/bIhtK3fxBqNI5pfWUQMxorck0MIejcDZvNV5Ls78Vs8uMdMLH6IhgNueTXN1QLrhSM8lum5wEZWARHEzy8BsSy8ZDb65A6URzRpR0zmskKIVUKNDxuSu0d4/X3Bl6PmSuV1Q+3ma71P5GcwNT8XSUisQLY5LkQT55vXRALruXJu723WVaTi4CDmLuAliaMxY6SyKNus1t+6p+Z0o4w/kObxe+I4jsxolF54HZ1CQ2UsyT7z+I3DRAmKd16rqGj/LJGLeABCd3ksxF4Ye8swNnuh9fATF5FkxyOPuxcTcqIpznDW9CKbBrxaPjEzGYSmrmnpiJfcCN3FrSweyhRSw+5BadVCOD3iJRnSQZcjZKcy/euDCxxMBzxKUvcAOfaf3Aw/+XByrarT98oxAPp7Zy2Xx7GvbFEPeGpM5wSfaTP3Io4HYP2zWo8m2r7w2C3CTNAqqWa7vGc2xLtgddyxVc6Lfq2yHFyxej6CqJ0SM2uw+zBBXhn6UZaeYItiQSiquc0KJfE4AdUmA5/6/pAsUXo761vBcDlLqt/QONJm3WVblSRB9Ex2dS9wi2w7rcO8/ak1DgVa9eFokLnzwnz5DREbjBrqqpH6WITpA96Xqb2JoufSsebKfO2TDa+B5Gu3T9IDndRC5dRdSzQHpaVEqz1uXl+2lZBmK2xSZ7VLvsRCqTpz8AOZHIwFyZJx9dyY5SUzsCQMGA1STIc7nwOAgBxyyfgqatf6i0=
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
- [Medium] selftests/bpf: integer overflow of AREA_MAX on 32-bit in hold_mm=
ap_lock()
--

commit 27a041a03328fba58bd21d5e62e3d149445f0523
Author: Alexei Starovoitov <ast@kernel.org>

selftests/bpf: Test uprobes and fork() with busy mmap_lock

This commit adds a BPF selftest that exercises uprobe attach and detach
concurrently with fork() while a process holds its mmap_lock via
MADV_POPULATE_READ.

> diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_busy_mm.c b/to=
ols/testing/selftests/bpf/prog_tests/uprobe_busy_mm.c
> new file mode 100644
> index 0000000000000..30614e8b92cd5
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/uprobe_busy_mm.c
> @@ -0,0 +1,447 @@

[ ... ]

> +#define AREA_MAX	(64UL << 30)
> +#define AREA_MIN	(64UL << 20)

[ ... ]

> +/*
> + * MADV_POPULATE_READ holds mmap_lock for reading while it maps zero page
> + * all over the area. It costs page tables only.
> + */
> +static void *hold_mmap_lock(void *arg)
> +{
> +	size_t size =3D AREA_MIN;
> +	void *area;
> +	__u64 t;
> +
> +	area =3D mmap(NULL, AREA_MAX, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS | =
MAP_NORESERVE, -1, 0);
> +	if (area =3D=3D MAP_FAILED)
> +		goto err;

[Severity: Medium]
In tools/testing/selftests/bpf/prog_tests/uprobe_busy_mm.c, does AREA_MAX
overflow on 32-bit architectures when passed to mmap() in hold_mmap_lock()?

When serial_test_uprobe_busy_mm() runs on a 32-bit system via:

  serial_test_uprobe_busy_mm()
    -> start_busy_process()
      -> busy_process()
        -> hold_mmap_lock()

unsigned long and size_t are 32 bits wide, so (64UL << 30) overflows to 0
(and a 64 GiB area exceeds the 32-bit virtual address space). Passing 0 as
the length to mmap() causes it to return MAP_FAILED with EINVAL, jumping to
err and failing the test.

Should AREA_MAX be sized appropriately for 32-bit architectures as well?

> +	/* EINVAL without CONFIG_TRANSPARENT_HUGEPAGE */
> +	madvise(area, AREA_MAX, MADV_NOHUGEPAGE);
> +
> +	t =3D now_ns();
> +	if (madvise(area, size, MADV_POPULATE_READ))
> +		goto err;
> +	t =3D now_ns() - t;
> +	size *=3D sh->hold_ms * 1000000ULL / t + 1;
> +	if (size > AREA_MAX)
> +		size =3D AREA_MAX;
> +
> +	while (!LOAD(sh->stop)) {
> +		STORE(sh->in_hold, 1);
> +		t =3D now_ns();
> +		madvise(area, size, MADV_POPULATE_READ);
> +		/* before anything that can fault and wait for fork() */
> +		INC(sh->hold_seq);
> +		STORE(sh->hold_ns, now_ns() - t);
> +		STORE(sh->in_hold, 0);
> +		madvise(area, size, MADV_DONTNEED);
> +		STORE(sh->ready, 1);
> +	}
> +	return NULL;
> +err:
> +	INC(sh->errors);
> +	STORE(sh->ready, 1);
> +	return NULL;
> +}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022015712.1297=
331-1-alexei.starovoitov@gmail.com?part=3D9

