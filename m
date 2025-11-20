Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09BF0CF64AC
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 03:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680876B008A; Wed, 19 Nov 2025 22:05:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631126B008C; Wed, 19 Nov 2025 22:05:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51FD56B0092; Wed, 19 Nov 2025 22:05:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB196B008A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:05:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F765160704
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:05:02 +0000 (UTC)
X-FDA: 84129493644.15.7A358E0
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1B190180004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:04:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gmTMIGEy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763607900; a=rsa-sha256;
	cv=none;
	b=Ak/nwTVU2HQYjx1ogRqpB3QEeuSTnDWikyFG6b5C8XTBWlg3GErSiDhhz8D7QBG3VqDQ7R
	rE74j3h/Cg3yEWowVxwhtL6Fi/TUQZ0loSN6WJbBAxNotb0FAWPzPZakCs63lizw7zIAdD
	AM5yAEnGUQzgAWF22Rez7vi7a3S5KNQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gmTMIGEy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763607900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mp9GsOxlS5mfbOTt7JkQadj8FOcXU3nLzOqalaTK7J8=;
	b=dCX2PtvsyNmkUftv8ln/dNsRWYj3C8P9uwZlgY7VJyoeYxnxQqTsVb4kPAVC3tdbZgL5Ia
	t+41iq6/DaWgo9jBQNr617h7m7u4yIx+6LqLjCc45jXA9YyVJxkGzBB4fQRIVxo5jfpuEw
	q9Qk3ERNd3o2xSlVQ9/u0JIp+VAfIKo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763607897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mp9GsOxlS5mfbOTt7JkQadj8FOcXU3nLzOqalaTK7J8=;
	b=gmTMIGEy3i6I93R2sPQbtMUa79JbcV5wpW+rsn0T1+//CcMXZPMpTsNMKh0WgfL2rmzhgq
	ADk90CoVVwjbe3RjNiViIqT8mC2EN5Jomd5GyIkHb+plaECxd3MqAnCY1lrWF0ponxW9M7
	l2DfKVoplZebUgVFAX6ZaGNYgOU5h80=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Muchun Song <muchun.song@linux.dev>,  Alexei
 Starovoitov <ast@kernel.org>,  Daniel Borkmann <daniel@iogearbox.net>,
  Andrii Nakryiko <andrii@kernel.org>,  Martin KaFai Lau
 <martin.lau@linux.dev>,  Eduard Zingerman <eddyz87@gmail.com>,  Song Liu
 <song@kernel.org>,  Yonghong Song <yonghong.song@linux.dev>,  John
 Fastabend <john.fastabend@gmail.com>,  KP Singh <kpsingh@kernel.org>,
  Stanislav Fomichev <sdf@fomichev.me>,  Hao Luo <haoluo@google.com>,  Jiri
 Olsa <jolsa@kernel.org>,  Shuah Khan <shuah@kernel.org>,  Peter Zijlstra
 <peterz@infradead.org>,  Miguel Ojeda <ojeda@kernel.org>,  Nathan
 Chancellor <nathan@kernel.org>,  Kees Cook <kees@kernel.org>,  Tejun Heo
 <tj@kernel.org>,  Jeff Xu <jeffxu@chromium.org>,  mkoutny@suse.com,  Jan
 Hendrik Farr <kernel@jfarr.cc>,  Christian Brauner <brauner@kernel.org>,
  Randy Dunlap <rdunlap@infradead.org>,  Brian Gerst <brgerst@gmail.com>,
  Masahiro Yamada <masahiroy@kernel.org>,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,  bpf@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] Memory Controller eBPF support
In-Reply-To: <cover.1763457705.git.zhuhui@kylinos.cn> (Hui Zhu's message of
	"Wed, 19 Nov 2025 09:34:05 +0800")
References: <cover.1763457705.git.zhuhui@kylinos.cn>
Date: Wed, 19 Nov 2025 19:04:44 -0800
Message-ID: <87ldk1mmk3.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1B190180004
X-Stat-Signature: 8dh7tfykzt9txrutjcwo17zou6fo1xhp
X-Rspam-User: 
X-HE-Tag: 1763607899-346285
X-HE-Meta: U2FsdGVkX1+AlXft7I6keN7qvwtqP0Y7aOGnY4ShhG6G8gnOSMIjloUwQYuJHbTZJCH0r3eSJWACWnlW37covMBl+IXNVDe+OBpBBvoe9GRQVsmCJ3vflwZ7qTGRL+7HoQk09GvyerEuuYzY4x9T5J+D5jM+MZEhR6Z2BicHqG1NjenxZ/YyWxtxnvBi3UMMUp+C5s+E7fVxi1s5LwtY6MswSEgwlCbU09SrTK8N6HohAD42WHnRtI/n+WppOreGH19jpRhlzcwq5KhW93sPNwRiVfPlo+dOz8k92Ro6o2tZ8F8/b3h0YQTBx02m+kdyFNb8PIQ08Onynt9171w0OoAcYfEeMSW13YQwEtYJir4n1fHUAVBvlm00hdFowKmbnfBGCsD7QfGYgU3szZ4GNJIvs606xHsRc668whjShEqqSJ9+kB/oikS7scRrvmkEKGRRzrDqH7+EFKZUqYBgpHUdRFAjsZX3cvLdxPYvIyRbrwK+q2cNPR1lOlJ3SIiwY/nyEiAjKYRYE5g4LgTCdAVPWwTqOwfaqATf9j64UaWrSfIgxg6jmmMAe63WVmcVbAsfT/biKCfY1KyFEJXe4j7VsvoKgtHkOEl/Cqt6XhnibTwGLco0UHP+48EF4Oq2UHM3D9s+Ag0/ztIWuQ1chAondzpWEyyJnVhmZBU5xgpauAJdu8vlKDGt3u0mgWHV0BfdJObY41SJIotOEDmtDghajBHLf2+CFQwBVUmRr6+c/kbmEtH7FqoZBXau0/cSbFNdjBwGQugUm4A555Aq5nxKcgkqUtXrZ8H7osI2za85SPCDStKYvqlZl0KlDRx+4ZMk5VrWQdjoaHuW8wR43z3WWeHVRS+GN30q9q8mAVR0mF7SWMgCc4QpzpzEIMOS0SqnoKTIOZJivqh5OBsaxlzT98sdXhgArlEXnOxieOuEBPB1U2RIPPu9rNQfN1kK69oLcHcfldr/kuJqdgE
 oAdYBLS/
 /Ms8Abjbtrci0fdVaxBHk7RxxtFQTvxeBxph9HcB2FcufrPxvJn9V47Hdo91Y0/69knjY6GjwyTEZd7wO0sxrj9Nwgl7YvbwLZYNYogOod6F2CzrqgjckcOVWDeQCV11LWgNMhCAaJZ09rcxpfnKKuQOkpXknq3OSHuP2UTr7OVpbbyUqS9mybiCP4ZyFVmDUWzwJf9sfSzQGK+FupOKvwIviH3XheOTh1YMxByGYzgS9PQo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hui Zhu <hui.zhu@linux.dev> writes:

> From: Hui Zhu <zhuhui@kylinos.cn>
>
> This series proposes adding eBPF support to the Linux memory
> controller, enabling dynamic and extensible memory management
> policies at runtime.
>
> Background
>
> The memory controller (memcg) currently provides fixed memory
> accounting and reclamation policies through static kernel code.
> This limits flexibility for specialized workloads and use cases
> that require custom memory management strategies.
>
> By enabling eBPF programs to hook into key memory control
> operations, administrators can implement custom policies without
> recompiling the kernel, while maintaining the safety guarantees
> provided by the BPF verifier.
>
> Use Cases
>
> 1. Custom memory reclamation strategies for specialized workloads
> 2. Dynamic memory pressure monitoring and telemetry
> 3. Memory accounting adjustments based on runtime conditions
> 4. Integration with container orchestration systems for
>    intelligent resource management
> 5. Research and experimentation with novel memory management
>    algorithms
>
> Design Overview
>
> This series introduces:
>
> 1. A new BPF struct ops type (`memcg_ops`) that allows eBPF
>    programs to implement custom behavior for memory charging
>    operations.
>
> 2. A hook point in the `try_charge_memcg()` fast path that
>    invokes registered eBPF programs to determine if custom
>    memory management should be applied.
>
> 3. The eBPF handler can inspect memory cgroup context and
>    optionally modify certain parameters (e.g., `nr_pages` for
>    reclamation size).
>
> 4. A reference counting mechanism using `percpu_ref` to safely
>    manage the lifecycle of registered eBPF struct ops instances.

Can you please describe how these hooks will be used in practice?
What's the problem you can solve with it and can't without?

I generally agree with an idea to use BPF for various memcg-related
policies, but I'm not sure how specific callbacks can be used in
practice.

Thanks!

