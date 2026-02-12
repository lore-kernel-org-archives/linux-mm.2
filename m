Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44A36EB48E9
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60136B0005; Thu, 12 Feb 2026 03:50:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0DF16B0089; Thu, 12 Feb 2026 03:50:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5A36B008A; Thu, 12 Feb 2026 03:50:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 807576B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:50:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52F64567F0
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:50:37 +0000 (UTC)
X-FDA: 84435183714.18.19914CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CD92480005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:50:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XNDmJQoV;
	spf=pass (imf30.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770886235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fALu6XzmQg5TNwqJBD9Gx7tUBrAgJBieKbX0TkViqno=;
	b=3SmOvPAe6v/8UcRWPtrwPPCyViI+kz6tToDezlYYqDGEVX6139FURLLmDtMoQmUoDXCMwB
	9q7yrVrfeLSrqnsVzve/DOk3mZx/QIhaIo3jDnsNCk+B3TSoRLd0ltbU5bxMocywczEvBH
	y4q/pE1tQ5+wv16zo4xmyW68FAYkZuM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XNDmJQoV;
	spf=pass (imf30.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770886235; a=rsa-sha256;
	cv=none;
	b=26+Cz3GGWRoMculIppzyh73UrXQgjes5wS1hWU5I//wsnYTJ0foZoyQvxvAWKY4XOppr7E
	uzeSjQMAUZNuAg1ev37j+kBAF4Tdr7q44ebK/DEM37bWOqEVmXrdpmm1BpQ5cVdYHEq5xs
	bawbWV8w3Sr8yrdtqKqiDk4p5TBA34c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0ED5F60128;
	Thu, 12 Feb 2026 08:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379E7C4CEF7;
	Thu, 12 Feb 2026 08:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770886234;
	bh=tFZNX6x5kQa3R5bh2C+SIIXI/4UmBn0oMjHEk4eUOEs=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=XNDmJQoV2PMqhuDh97GJvfMGlGBF7Q4ElssERNNNLKV2ldSnj4QlGhLAA9YAvptAG
	 4sTNQ55sWaWq9ec3QQPI+mvBLBCPKrLZ1WrcV8AuLDz3F7ojRZPae8DDf4HXxKBnrd
	 /KB9ua7da3oyfyjNSG7JGNdiWChdRIK0EYJ1yFoNBUYjK4Ts/BkMzFhFWZl1Loyl4r
	 EtvR6WUW/0tR63+S4ugd29vq+hmqVkrJzI0H/Z/Ion2miO6+CgocvMp7vrzl/EVhAQ
	 llK68uWfw68MNc4uXAJtGuyS5EmJ83OabHpPpA6SNX3xHXosfD+nnKagX/WuXvUELv
	 f3UNhYxZ1Zq9A==
Content-Type: multipart/mixed; boundary="===============4217100397236680912=="
MIME-Version: 1.0
Message-Id: <0d926bdc5b5e030fafc82de73c3f3e5412c051fc6763f77da9ea6aa316bd8f13@mail.kernel.org>
In-Reply-To: <042df9438d9e78bcd66f1fa0e7043b9ea8cda96c.1770883926.git.zhuhui@kylinos.cn>
References: <042df9438d9e78bcd66f1fa0e7043b9ea8cda96c.1770883926.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: Check bpf_mem_cgroup_page_state return value
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,hannes@cmpxchg.org,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,martin.lau@linux.dev,eddyz87@gmail.com,song@kernel.org,yonghong.song@linux.dev,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,haoluo@google.com,jolsa@kernel.org,shuah@kernel.org,zhuhui@kylinos.cn,inwardvessel@gmail.com,cgroups@vger.kernel.org,linux-mm@kvack.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-kselftest@vger.kernel.org
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 12 Feb 2026 08:50:34 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Queue-Id: CD92480005
X-Rspamd-Server: rspam07
X-Stat-Signature: jrxp7g98b7emqj16ginybymihmbcsz3u
X-HE-Tag: 1770886235-702470
X-HE-Meta: U2FsdGVkX19/LFTd0NT3/d/Vk1/lV540npbQhMQ9WJUENwT2NuHC589oYpnmojphN7t6+aVsWVuGXBxTqz1m+wDPDim4248gzaBjpEnFvSbmqKqkLOcDjQs6KVx9FqtnBIYeaLrnp/MPfl1qLelNGVrMYdKTRq+SrvNslYY3RxvY4hxII2Hq/WT8FAMcmEClUd3WV68Q7BYoVEQJ1EGaWp30pfap71GASgEC4aFnge+UhBhAQr5e1hPXIRXOtMtDFD/7nqqhMYivBFi3V/J6+PJlQG0R/68f8hGpKBdup9NSXjucMroOlKW5F+iNvW82ex0Ke4/7lgfqyJyttsfAhv7j1IwC9zdLdDpM4BNKbjZLqQMSi81weQGMy7ORPv+xO2vg8mZ/lA3T2XVGBvyHZLEc3rASxylDH0RLDROATK02dtaEqpm+0SXsu3pH3VSPOgWjVRSbgR5o8RLxv2BwgOaGZMFJnRUCaeMS1MO8W9EnlBPWMfcV2dT0zYo++Rph6wYGRgUZcGL2ozatGuTpFcOyxs++ltoMZvlwiVJB1r00WVwbgvxnonXMFwJRZQl7tUIiyoT3D9xLcJeYTPSqJeWs+QxV54tQf8u64FY4np3J59/vNAquIMBqmz9IFLxAeMOfmgcRhdHZMJXTIS3EHc4UnGWb9orWrNqMEzruF3hjTPddXHM/ox8o/NmrarJJSl7WJ8EgT3AdQRcRKPgkjFtYNKWrAFQGAy7IN00wZFTtrK6Rw0vt3/rzSL5E1YI4TtNr2qFedjt9+N58BvUJ9xDzequ2+Ho32BohSWWl6NYPK1Xr//c19EBw8t1HW6b7sODi907mKg/Uop1ca5vgYiQL1A+M/txlKEDtFVOtlXC4aI1GXaqMTwVxSp4sRD0TI5550APU6QNDtnw1xPFvmCdaQlVsy9umma1al57fT1mA2OuBgKYU3Ty9ys5eEJB/JaBU+q2ZCKdjSjz/iQw
 FJH4I4dT
 WQDal4mowQQVChw/TCglglZnplYjTxvmCpcbz4bmHSaiyAdLAk8BE28lPTgEHXiEI3PdtVCvVgZ9xn2pDr01iP0c+AcagfLuaDoiYuXQh+8MilT8YnQHIO99i8ER/lpiuXBrsnyx2lJVDsSzmqgbBY31uXFzZklX6aq2T9yf2mlBh5N9Aqim8FgybjMiYt88+m6zetWcpQBwwhIj3WJqwJpuIYbv17z2T/bq8ffy/2CA0sqRaE6tw/YpG8u5XjqBJ9YrBgaIgsdKJcBf/Pg9truOhr/KWZsUto3efNcwZrjt+QLzjzeqKyrBIdUMXUsPrWNKojeSwGs2Yr6yNaaqwe8CwnuIZYfz0ZzdQ4BqD8o4WegFBXbUA2osTMJv0b1spzwBA7XPurwm4z6KXfW+qYrS8BaIqMX5xkx6Kk4Zxw2/yeOmIays5gWrSrnh1ufapdkKIri0OyrMjvNsW5CBh3rIepnxw1fVK+I+InUzH7krYlCaU5DCzvVr3m6FUIf6y1Fqz1iVqut4xhzc8tVGpsX3aXvkyrGDyCyqI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4217100397236680912==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> --- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c

[ ... ]

> @@ -170,6 +180,8 @@ static void test_pgfault(struct bpf_link *link, struct memcg_query *memcg_query)
>  	if (!ASSERT_OK(read_stats(link), "read stats"))
>  		goto cleanup;
>
> +	ASSERT_NEQ(memcg_query->pgfault, (unsigned long)-1,
> +		  "bpf_mem_cgroup_page_state PGFAULT");
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^

The assertion message references bpf_mem_cgroup_page_state(), but the BPF
program actually uses bpf_mem_cgroup_vm_events() to retrieve the pgfault
value:

tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c:
    memcg_query.pgfault = bpf_mem_cgroup_vm_events(memcg, PGFAULT);

Should the message be "bpf_mem_cgroup_vm_events PGFAULT" instead?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21939182103

AI-authorship-score: low
AI-authorship-explanation: The commit message uses first-person narrative describing a real back-porting scenario, and the code changes are simple repetitive assertions typical of human-written test improvements.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: Minor documentation issue where an assertion message references the wrong BPF function name; does not affect test correctness or system behavior.

--===============4217100397236680912==--

