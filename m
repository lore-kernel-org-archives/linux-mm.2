Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFBDFCCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36FE4800CA; Mon, 27 Oct 2025 19:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F92F800C9; Mon, 27 Oct 2025 19:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E865800CA; Mon, 27 Oct 2025 19:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0AE800C9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:48:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7F3812A3AD
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:32 +0000 (UTC)
X-FDA: 84045536064.13.868EE2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 621F1140006
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IjqGamAZ;
	spf=pass (imf26.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761608911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DDFmqisK5z58gHwTE1x5mS8ptI53BiJ50z88UcWj98=;
	b=kckaYTzEdFg7lATVBV/EgKnKnY9IwI99yMIaI3zmn28EEznHwJ0Lk0A0wzyJPpFSqHAtWb
	ujde2Q89glPpryg/MkClr7pmrdba+7BRajoUtr+wlj7LV6nrw3MaiHn35et2Yw0JWxhv7k
	jxGpdUJV5QOJxsqfPIEv8ro+y+/hdKo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IjqGamAZ;
	spf=pass (imf26.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761608911; a=rsa-sha256;
	cv=none;
	b=qdpaF+vQvEV0QU9RmNM0EcHxGpXUtKj/6v5YfHDXAS0k3pI3cOI9OboBwS65G7Mx/vXmPG
	vswtIkhf0KPXEn22Bu7cBfp0Tfo7meVm13KUhZW2U+C5wDLjjW+RCAzjNHr3dSVgU88Bz/
	6XXKGP42cg3g9s1w1ukB3Sy250YQd4Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E2D4161205;
	Mon, 27 Oct 2025 23:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59EAC4CEF1;
	Mon, 27 Oct 2025 23:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761608910;
	bh=zTR7NNf/0/v66tZ9uBGApZ4ujktgFV1nV9bNyBtCkTQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=IjqGamAZxJF+TwcJQx9bAyTi3yBwvFFX9hLNbgr/GOomJEIGfSIqEUz5tZ05Ji0LM
	 neYa0tZUKxXMHYwhnxTRQhhheBO+DNEz6c2nu0x8Q926psVnohcuVRnDhC8Qzganc7
	 mHvtqyE0FcEb4/RpZYS7FTsrVQaJj6JArFr8xoPiixfK15bq8uN2FyshkpGEhCBdw9
	 +Hg/0M4GrSULoixm0TP1DQBFMFLBFVKbXfdQBI2ywVoZK4WALgY39bkAZOQj0ZdnKa
	 mS3AEn/Efpe02m+N/9/dM5uk84UXGGKd5bPNPZAPawlxUrlS4ttlfu+dOeNS8Dc8RV
	 bRXHJgbBvP5qw==
Content-Type: multipart/mixed; boundary="===============1951758182374278910=="
MIME-Version: 1.0
Message-Id: <ab8c7bf2f312e150c22d83e5ebe91e17f3c4be42b3ff0825623caf3aac4086af@mail.kernel.org>
In-Reply-To: <20251027232206.473085-13-roman.gushchin@linux.dev>
References: <20251027232206.473085-13-roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 23/23] bpf: selftests: PSI struct ops test
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,ast@kernel.org,surenb@google.com,mhocko@kernel.org,shakeel.butt@linux.dev,hannes@cmpxchg.org,andrii@kernel.org,inwardvessel@gmail.com,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,martin.lau@kernel.org,song@kernel.org,memxor@gmail.com,tj@kernel.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 27 Oct 2025 23:48:28 +0000 (UTC)
X-Rspamd-Queue-Id: 621F1140006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: inrkxrak6ow3gfxegj8g1bj1jyt9uegu
X-HE-Tag: 1761608911-642712
X-HE-Meta: U2FsdGVkX1+pU1bqrk31ZY2Q8szg5jm8Ml6URALK5ioiCrCeU0QBoFTdc3qJQhXk92zSFxVD7lPsrOcSea9TRGBB0nxe76yVYxyjTpktFPiXJtb0IQW0GpakfhV+YxF2/+XDFFHEqBcOm7A7E7TLWdBg1Av0/lA/xNR9hzaO+8vZxTeokBAzs0b8oj8BRyMqOMQi6Nuw7WAL+JDTi40kX+utHW9Dkg3jOhIS16iwHaPiy8Nk7OGV3srBbLYHL8YcQHV+zHobPA58aMe9W/c5v0kP/lj9GIRjBXMbfyktW+xQ3X9xPsKogmi+1y5aJrhXBR2RbeXOylUqSFwu9cvkkZGED5Gim7p98N1cQ0/M3oeMjfxFCz4lznL5LaXdonPEI1lYYG4bnHiKLE1BLX+MetSnFvD1nWNPn51Gvq9S5PjZUZBlPmOadlmTVvMaVYTIzXxHcqbHCvUgntUumpjAyINcuuJpr6R0cKjWbOsJzHclR/xiPTv/l5vOORZysouX2soNUc6hA5XoiaN/As4LHQtcdAuSnTfSOJAkRT2zuGa1/K65Ir9HDo5bLMgDoCITAsHutMUHb4OSWpjIpfu2xIMHj9vKo433hKvNw9gV0H5Xt7EOVr3jRTuK/JMLtY2GnmEwAX6ZLQW9eRi6b+Tx8+JNWuW+STaxDdnKyiJ7+AtUOp8+hBLEEt4MTIuhAgNyNzsa6OC9PszFfgMYnxtfxM1rQP1tPUcrpDd4uR3aDLCvY2wIviJow5RdAuxxrz1u2RwEQzXI55Hs66/XEFlS1hz70OHo25dvFiiW1E4Wv3ywQS166o1kIsjOF/xRNSp37PoCRjXVDKeNjXnDE7A0yJEHVEZPBhnkCeSrLH/u6rHRmSGr4YFTfvoc7BFcASUnYGogfo81lCXppHMty/TjElSUhX7jEAHpULX4TqSiy3ofGa1gvxwbiqZ58tqHw2j3Pn480VXYP/5xUipPmih
 lOQ2Fuhr
 /ECtEpnrLtkq+6nNzPVGSJTW9s9mbjaw9QwnBfRYRfOWECIRz3pBL4NAbPcOvMQ2QcWXqLBTOs+U9zehG8zrAq4tKDn+RkVG9krJb/jskoIcyWDTzFKkouMBSSyf4IHUS6JLLhTa7HJXlSM4pl4Xtn8+BnSx/8AAZ8C0p841Kj4JI7rHUSDuajE2Zp6P/ttRFIsT+oNaHwHOVdEJFSFMoOhr/Af+iJTZn0MBX9nT+KXvtK01ek2R4bSqy2DTM48a++rOINtoHXrNUHzH5ESjUoumfd/jEevB2U43kHo7XHMZ+CW3RamyGngz4Zub4Swqf0qkcD8IgoQG5oKsxQOi5puU5pJ9lSM21SwwWzFsgiePI5v8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1951758182374278910==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


```
commit 70a4d534559f5708a811241190cd158e83451a42
Author: Roman Gushchin <roman.gushchin@linux.dev>

bpf: selftests: PSI struct ops test

This patch adds a BPF selftest for PSI struct ops functionality,
including cgroup lifecycle callbacks, PSI trigger creation, and
memory pressure event handling.

> diff --git a/tools/testing/selftests/bpf/prog_tests/test_psi.c b/tools/testing/selftests/bpf/prog_tests/test_psi.c
> new file mode 100644
> index 000000000..b294cea0a
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/test_psi.c

[ ... ]

> diff --git a/tools/testing/selftests/bpf/progs/test_psi.c b/tools/testing/selftests/bpf/progs/test_psi.c
> new file mode 100644
> index 000000000..4ddec7ec3
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_psi.c
> @@ -0,0 +1,82 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +#define PSI_FULL 0x80000000
> +
> +/* cgroup which will experience the high memory pressure */
> +u64 high_pressure_cgroup_id;
> +
> +/* cgroup which will be deleted */
> +u64 deleted_cgroup_id;
> +
> +/* cgroup which will be created */
> +u64 new_cgroup_id;
> +
> +/* cgroup which was deleted */
> +u64 deleted_cgroup_id;
>    ^^^^^^^^^^^^^^^^^^

Is deleted_cgroup_id intentionally declared twice here? This appears
to be a duplicate global variable declaration - the same variable is
declared at line 13 with comment "cgroup which will be deleted" and
again at line 19 with comment "cgroup which was deleted".

[ ... ]


```

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

In-Reply-To-Subject: `bpf: selftests: PSI struct ops test`
CI run summary: https://github.com/kernel-patches/bpf/actions/runs/18859027430

--===============1951758182374278910==--

