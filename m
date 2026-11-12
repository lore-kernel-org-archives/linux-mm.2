Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C93606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 23:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eE5/TkpH
Received: by kanga.kvack.org (Postfix)
	id AC8546B061C; Thu, 12 Nov 2026 18:23:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0156B061F; Thu, 12 Nov 2026 18:23:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B59C6B0620; Thu, 12 Nov 2026 18:23:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 804CF6B061C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:23:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91D684212C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:23:28 +0000 (UTC)
X-FDA: 85428045696.11.3C2C9B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id DFC3440007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:23:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eE5/TkpH";
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794525807;
	b=d37AADFju8BnESEoIQo7nVa6fON86jcIIJWG5D/1vX2j5vlsg+b22331qv4Vi5iilc0DB9
	8EdJ6ozs6CuSTHPoyJ6aySqp6vX6YF5qdZzDyw/pQGamOAyb4bOsVfKrpoyV2lZBztfAM7
	P5diLLh/C9KtHzsKiGSC8tjx67SJU+I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eE5/TkpH";
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794525807;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slSxur4sDJg4fQ33ppMP3o24B0K+D7GRAu+Y6pjxtcw=;
	b=6+ofkyWuY2j5N3H/qxSiixmD8iFaYi/du2JSWG+f/wxFChpg9Gq7D57RQhAWrBx/95rhXV
	ZIhIzVqP94So2TnvdBPiKs3sW5SqLnVyq4X+NJyFKqfbvqRg/3XTUCxxdOKD9GB71cUDX6
	gA0q+1nzxbKNdykusovSWJQwfxdTG00=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BEAA41142;
	Thu, 12 Nov 2026 23:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EBE1F000C4;
	Thu, 12 Nov 2026 23:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794525806;
	bh=slSxur4sDJg4fQ33ppMP3o24B0K+D7GRAu+Y6pjxtcw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eE5/TkpHr+G5xcCvDOUHv+IVctZPTWp+aT5mu/lygG1O5/RWe/X9qnwhWi//yqM/2
	 NBvWtU8kFgEQg1gpyPGYVWdMaxlkbDI9edUW5yYB9OXTXVdpBejmZayX6jJiYu7DSC
	 5gNJtAIB4Nvf2mpJ2aT7KjDFAHpPcMK9ydXG6UkJDtWF2MItiXFhhXeLRDZ0sDE7Gq
	 2fENMcbbOjN4bVMY5cA+GGXjVBr5SWdZDg5/SGJcVRZs+QElpEgyBR8OKQP1chqHsA
	 buIe5jTNrWYbtTeXyPli/3L8sMNJnWqU2+DRezwuwsiKGi8YFUTJAaFZzCOpf28uhT
	 jQj6GMbOjIKpA==
Message-ID: <sashiko-outbox-211950@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: zswap: honor zero cgroup limits after successful
 reclaim
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VG9tw6FzIFNlbmFydA==?= <ts@perfloop.ai>, akpm@linux-foundation.org, yosry@kernel.org, hannes@cmpxchg.org, nphamcs@gmail.com
Cc: roman.gushchin@linux.dev, tj@kernel.org, chengming.zhou@linux.dev, mkoutny@suse.com, linux-mm@kvack.org, mhocko@kernel.org, shakeel.butt@linux.dev, muchun.song@linux.dev, cerasuolodomenico@gmail.com, shuah@kernel.org
In-Reply-To: <20261112-zswap-zero-limit-v1-1-19f33081b09e@perfloop.ai>
References: <20261112-zswap-zero-limit-v1-1-19f33081b09e@perfloop.ai>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 23:23:24 +0000
X-Stat-Signature: 4373s5hwj63zzqfa93dhembw639umt9u
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DFC3440007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794525806-855367
X-HE-Meta: U2FsdGVkX18j0hU7R1KRZwimbgk1ANfz0LYaqPEFX7cNNoa22pq/BGul0+4GJAIvHSCE2UYB780xN05s38cmiUHxNGng/zfV+zda8GM2M76noP6ABTuFJ2e8DeOsK8G+lqklkzvu/5fFUpjl2ZP/72lOw5LxqZ+/L92dK/n0zK955VjJ9JysVEYrdLdcM4qRsdtaOkHvaKHEHz+t3rT8CpiwYv21w9OnEFRNL72hxcu8Vw5vPz9PUaQFs4y9jv7D6rAZyDv/8MroiNPoaJAhrv0DGSZYzE9GobtRbTF8y8I45DGJTFUFYeDqS8jfWayLKEi8xc/o7dqUnRKHG06nqwdI4DUAPVyhMObopqZNOrG95GB6vCu/mRbwl3PKhKkFJFyjAuoPAIOTLtHFvn3YUgCkpdtLjkd9RmvxPxee5C/flLHN6S/ks+6A4IpgZ5Y9wmy0HROYh6LXan4UivpyDwTsHh/hMIR2xueYCpUusgd+feUG+IXNA9RybkFPpN9cd25STpxLSWMISx7E/O+Uj22L91pdgF0rqa/kh5DYLfUppnHuPDjDB4x4rjBartbVdwqYFBQIdb1DGhEEUYTcCmzJ0kWaadp8i8q0walVY4Arf+BqX8r0MskFJKcUHuqfGys59RN/C/QGBgc0XC1locLVR/LrPPC+S/kh+DilwLvUay2HV46XQBQFBoYl5ki+gcsHoB4mZ0kO5w0kktlMQatJq5uuH7rI8yTCazi18V2i8Ef4wufMRuGxfl2uBzRn+yo1Fns1ZmfFDszpblVOXqTYlhDAtXrKYr1hLoNDFDSY6uOtQjU0y8Wr5XZzYeJOfwkZAyRHncUMPzqKHmJR/1pntiMEoH9OpzJorfgAM1MDpQmidtYK2iJi9eiJ5tVV8YIatHRbvv5+a6g2uGb3qBTpM5hKXWgWyp2qNb3BX95ecuU4AhJzbfsbwKpdEV7gRUEEsi16kcr5I8b/yeO
 Fcs4bA4d
 l5kKIo2uizPBLbxuNBkGaHNTukjtKYxw/AdWWVduQdoAMbNZNqrw6Rxerplk4/82EzTqguCaWRV068yAraURAbi87ntJ/KOfxmV5yzxc/76pfFLfzq+OYiIG90SVTK9lNgzylLpQGCqN6ifvO4DrkqG6zZo7IzeF3N8FiOOaLljOUgRjGfzPxjwpGG2DBtihSqQjso4lCSid9txHzeBPOBFD4HwthERoFw/vo8fg7YFTZos2B/n5gi+9MCh8Gq+LcD2FzbpoV5iauHtgrOzKKHCHaOtzWS0sO5ui1wXEPRrzIZ4ets85Qoh0YUocKF7kY++DVYGHo0lRx3i+5Chy4MKfPdJdFsG7fari4WZD6LNwhUAxpTgEa6IMYL48dc3gIJzqobFpVrCz/Z4hGJ3uKJZFgYXsnnBLecnBOf7qYuhyIVJObrr42CrnivNSQ+L41Kp6rmrMRtF79pPynZJvQbRLQmtzTWf3noYaNJrV4egxbv9DgqqSMe4l4WmJF5ZS2RX7HLQwSt75kosqFdyZ5ogQytbsZqd9jzJkIjt4YR6XWLP1KFkStb1Uec/A9PHy554Bf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] selftests/cgroup: missing wait for populated 0 in
  test_zswap_max_zero()
- [Low] selftests/cgroup: silent KSFT_SKIP returns in
  test_zswap_max_zero()
--

commit cb5209a5f058b3ca9ae23b219994b4a826f192b3
Author: Tom=C3=A1s Senart <ts@perfloop.ai>

mm: zswap: honor zero cgroup limits after successful reclaim

This commit checks for a zero zswap limit across the cgroup hierarchy after
reclaiming entries in zswap_store() so that a cgroup with memory.zswap.max
set to zero does not store newly compressed pages, and adds a selftest.

> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/=
selftests/cgroup/test_zswap.c
> index d50acc1b83ac8..7632aadd88662 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c

[ ... ]

> @@ -244,6 +245,105 @@ static int test_swapin_nozswap(const char *root)
> +static int test_zswap_max_zero(const char *root)
> +{
> +	char *group =3D NULL, *child =3D NULL;
> +	int ret =3D KSFT_FAIL;
> +
> +	if (access(PATH_ZSWAP_STORED_PAGES, R_OK) ||
> +	    access(PATH_ZSWAP_WRITTEN_BACK_PAGES, R_OK))
> +		return KSFT_SKIP;
> +	if (cg_read_strcmp(root, "memory.zswap.writeback", "1"))
> +		return KSFT_SKIP;

[Severity: Low]
This isn't a bug, but returning KSFT_SKIP here without calling
ksft_print_msg() leaves out why the test was skipped, since main() only
passes the test name to ksft_test_result_skip().

> +
> +	group =3D cg_name(root, "zswap_max_zero_test");
> +	if (!group || cg_create(group))
> +		goto out;
> +	if (cg_run(group, pageout_zero_limit, group))
> +		goto out;
> +
> +	if (cg_write(group, "memory.zswap.max", "max"))
> +		goto out;
> +	if (cg_write(group, "cgroup.subtree_control", "+memory"))
> +		goto out;

[Severity: Low]
Can writing "+memory" to cgroup.subtree_control fail intermittently with
-EBUSY right after cg_run() returns?

In the exit path, exit_notify() wakes waitpid() in cg_run() before the
dying child completes its final context switch in finish_task_switch() ->
cgroup_task_dead(), which decrements nr_populated_csets.  If the parent
writes "+memory" to group/cgroup.subtree_control before that happens (such
as on a single-CPU VM), cgroup_vet_subtree_control_enable() sees
cgroup_has_tasks(cgrp) and rejects the write with -EBUSY, causing a false
test failure.

Wait for the cgroup to become unpopulated with
cg_read_strcmp_wait(group, "cgroup.events", "populated 0\n") before
enabling "+memory", as done in test_zswap_writeback() since commit
5547ee3a76b2 ("selftests/cgroup: test_zswap: wait for cgroup to unpopulate
in test_zswap_writeback").

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-zswap-zero=
-limit-v1-1-19f33081b09e@perfloop.ai?part=3D1

