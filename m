Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 026D0CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 07:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E25A6B0088; Mon,  5 Oct 2026 03:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592E36B008C; Mon,  5 Oct 2026 03:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8BD6B0092; Mon,  5 Oct 2026 03:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1219E6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 03:53:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 858204016F
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:53:15 +0000 (UTC)
X-FDA: 85287807150.16.22A0496
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0387A1C0004
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:53:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EEX+P8CP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791186794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p8pB98yXVn3emMjSSVc5iGuD87aD74hXLFXwrp1IR14=;
	b=hJyx6myVSTYhbSLGmKSNw1IfXf80o/pJfWMz5MFzkZ8nwio9XNWbcYVnk8J6bcQQg6txtN
	5W1PZRJni4NO1T1z+0VcGPUj6ueyocAkPb+V7LBTFTNY8OYlhye8htKC43sSy7K/fI8j7H
	RG5w4KR7QDR+2IoM95zpAxP/M1j/oRU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EEX+P8CP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791186794;
	b=HaM8Lhziw1J2S2QOGfXGFBF7G9oOFnY2trdRXOD/hd0gEnFgrzcpnNjXn2br9tl3Cb76SG
	UMobrnH4dr4M7zrbYVujAqvemVl5HVtW2bhVWZIpVv9Iza2zw3l9Pxub6CxtFk35UKnaxF
	NdjfyTYdMg4nffHzfOt9D6WhJ0tRBgU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 560716022A;
	Mon,  5 Oct 2026 07:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9521F000FF;
	Mon,  5 Oct 2026 07:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791186793;
	bh=p8pB98yXVn3emMjSSVc5iGuD87aD74hXLFXwrp1IR14=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=EEX+P8CPFeqWLSN59RzmGW3okJrWBjL6X4WZQ29o3f4Nq0tIqMaqJhXpenBYRESYX
	 yLr/6vNkyiB/QVgs5zLCeYF1lZ/eWykY2jayP+n3JLO0BDVzLklA2oN66POyCpJ0M8
	 ACoSS1yP91wzs2/kkXR6AGYVCW0G3/htMwHDa56r5fUmx5ZGlnI2TlDZval00GP2vd
	 evxYEkphbACrDVnO3o/U/I9epZ0n8riPwtBTcw9qOkk/kHJh8Lw7KxjINSemSfbp9e
	 jjBzb3UMLUYfwz81sU923vgWgmRmwclgx/rRb5kdSlzAN6+bKnYI9hvtvI9VL3OaWd
	 EQXmRq8LXJ6Mw==
Content-Type: multipart/mixed; boundary="===============0647874907332121866=="
MIME-Version: 1.0
Message-Id: <3a4688cd7929354339fc61a5f4e8a0109e426a83097d9d9a2357ac6e3fe2c9ea@mail.kernel.org>
In-Reply-To: <20261005070625.8871-4-kmehltretter@gmail.com>
References: <20261005070625.8871-4-kmehltretter@gmail.com>
Subject: Re: [RFC PATCH v2 3/3] selftests/bpf: exercise task storage from hrtimer_start
From: bot+bpf-ci@kernel.org
To: kmehltretter@gmail.com,peterz@infradead.org,tglx@linutronix.de,bigeasy@linutronix.de,akpm@linux-foundation.org,vbabka@kernel.org,harry@kernel.org,ast@kernel.org
Cc: kmehltretter@gmail.com,mingo@redhat.com,will@kernel.org,boqun@kernel.org,longman@redhat.com,corbet@lwn.net,david@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,stevensd@google.com,daniel@iogearbox.net,andrii@kernel.org,martin.lau@linux.dev,shuah@kernel.org,ameryhung@gmail.com,swarajgaikwad1925@gmail.com,clrkwllms@kernel.org,rostedt@goodmis.org,linux-kernel@vger.kernel.org,linux-doc@vger.kernel.org,linux-mm@kvack.org,linux-rt-devel@lists.linux.dev,bpf@vger.kernel.org,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon,  5 Oct 2026 07:53:09 +0000 (UTC)
X-Stat-Signature: 8ams4ft364khphzqj6fm7g1esjcocx8d
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0387A1C0004
X-HE-Tag: 1791186793-194311
X-HE-Meta: U2FsdGVkX19Nkq2svo1ZFbTT+Wbcie2OL5EIMGlH6k0flQoHqFlSrmw1E0dg96IzgdqNru28KlrjBQyKJOYVAS0+yf1aM22jlZ945yfzKvr7EiVgF2JhbroR5tldQ+9vzdu9OKPD6SN7cJByCS4I6F0GFZilFw/6TFKGtVdD/vbdNpIiEwPuL0iiRpGDvTse2wH22ugyoXHSLMjIh6s3Yiojoky89meGzPXIPW1fj7nsJ+simCPhSFTScyBgoX/E9AlpsVDainSSZMIYzJgeoZVvgpUH7p2Bd4siXDtp2HB3fdj5+2glXlIk70ATE938I1Obm1cpR5qkOVDtLXD6MGhyrNBg6flRnYYyf9A7lx1KihIWRVm90hpmO62WUHaRXUrbPAtr408ZCydBxCQqWXap976CjDG+Z9MMx7eDORwS11Ali5s7lIBT0qohZg86D/EpVh1yHP26pnhh6ZtmWsn+gv5JDiwU1L3XHPf5j9pfTZ02w+QTHvRssExr/LXIF7Z86FuUoIsHsR3VPFSn8AIm7i4XMIGJeaAgm/tVTuU2pPtWW82D8B1mbFHT+2BSHViCz7XJscjhLgkx3eo+DVk6yAjakQwcpYNCoHQdeuQ4P5KJd98P7145ZvH7Q45rJt8odXhzU27VpmtS9GID4CBMiR88UCRfb3wcsl23ZX3Ny3fM3d8IMZ8rdvMVHq5b7CXSl0GC46x7kaLDQ0MiGwAPFGR6lIqhJr6ANT3r16z3/inNnXUgO3w5Y/UH4ox4OymPG28fLW6t02oH+PX/A6VHORRZj5f0ONMrSV6QqPoRrO2JYRb2if+2PByJNrzue0MlL+PPshWtwtKfUI89cyZWc3q9lV8SHbcZNRf3wTuOfIOu2HPwFlhIzD0MD1j/4rbdt2CrEbNfhFg8tA4yCoacUeGhHb8tiHzkeD9eKDWp7Tzu8K5Y4R+DOldTu2aE8B1n+APxtS+/ynaKB49
 kOgTQx+M
 0CwnQjFjKG1rPKy6Br+9E5cHfGVeeZl9OOnPBrLkFCwL7tAZzlfs0pxVKlNQSTlm4CiTupLoMYkTKfpQpiGJAdSNC9HmvWfFhyRNs3V+vmXdA9k/sOSJIt0POZakfI6xjgAFqZnnOebB+yHCGkll5ItJf9GJY2QeIPD97EfjXRGRznhRQVDtABBhdi3Kf2pov8nt063qcBzgH1Ni4kuaAiU7/7QjYA95u7xGENWqPa/QAtXDV2Wvqf6DoPngpPqAJy41zbscSeC7+Fbu7+2sZUQbehN+Xv++16W6uess/4JZ8HfxPJmqZAmEZvftcdEqn7t5w9tplJSicMb8mo6PLcUe1suOO+fA+unwHZlQO+GxuJ0Vam6QdhgNFyebSkB0HTt8n9m5mOopp9EaXQNrPnOu4Tmq98l5BS4HUX4wKGTw7ZpZjfuuIoed+jMntpksTl5jZf0U17JaoOyeFo/5nCj1/mfqj/IoD4w1Mf521G11o1WkZtKcO/lZajoxMUYy0uHiO1ZtN2wxCz/pV3nkQo60w8CbUQMcE9w+q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0647874907332121866==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: exercise task storage from hrtimer_start

TL;DR: Test-organization question only: should the new hrtimer task-storage
selftest be a subtest of task_local_storage.c instead of a separate file? The
review finds the test logic correct and the standalone file defensible.

> diff --git a/tools/testing/selftests/bpf/prog_tests/task_storage_hrtimer.c b/tools/testing/selftests/bpf/prog_tests/task_storage_hrtimer.c
> new file mode 100644
> index 000000000000..216e66263bf6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/task_storage_hrtimer.c
> @@ -0,0 +1,50 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <sys/timerfd.h>
> +#include <unistd.h>
> +
> +#include <test_progs.h>
> +#include "task_storage_hrtimer.skel.h"
> +
> +#define TRIGGER_COUNT 1000
> +
> +void test_task_storage_hrtimer(void)
> +{

A subsystem pattern flags this as potentially concerning: this adds a new
top-level test file for a narrow variant of behavior that an existing test
in the same directory already covers more generally.

prog_tests/task_local_storage.c already groups the general task-local
storage tests as subtests, including test_nodeadlock(), backed by
progs/task_storage_nodeadlock.c.  That subtest performs the same
bpf_task_storage_get(..., BPF_LOCAL_STORAGE_GET_F_CREATE) followed by
bpf_task_storage_delete() sequence and counts failures, just from a
different hook (lsm.s/socket_post_create).

The only difference here is the attach point, tp_btf/hrtimer_start, which
reaches the task storage allocator under the hrtimer base raw lock on
PREEMPT_RT.

Should this be a new subtest of test_task_local_storage() instead of a
separate prog_tests/task_storage_hrtimer.c?

For balance, the standalone file may well be defensible.  It uses its own
skeleton, as the existing task_local_storage.c subtests also do, so folding
it in would mostly move the test function rather than share setup.  It also
exercises a path that no existing selftest reaches: none of the current
programs that use task storage attach to tracepoints emitted from inside the
hrtimer code, and the programs that do use hrtimer tracepoints
(timer_start_deadlock.c, test_vmlinux.c) do not use task storage.

The test logic itself looks correct: the tp_btf prototype matches
TP_PROTO(hrtimer, mode, was_armed), and timerfd_settime() with a non-zero
it_value emits one trace_hrtimer_start under cpu_base->lock, so the counter
assertions are consistent.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/37277547264
--===============0647874907332121866==--

