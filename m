Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81062C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC686B0088; Thu,  6 Aug 2026 18:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55CBF6B0098; Thu,  6 Aug 2026 18:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FEA76B0099; Thu,  6 Aug 2026 18:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2E2C6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:18:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 472EA804CB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:18:50 +0000 (UTC)
X-FDA: 85072260420.04.B6D76F6
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5FDDBA0013
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:18:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cfjWdnRJ;
	spf=pass (imf15.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786054728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ymry1hvBnXf9k9HJyCKIW/LGlgOgsWSR1QFJjFRqgWs=;
	b=RjJn7IqvNznaFxzA39DWrkgWEgC05hXVmyykeP1odeGAdY/ctgllY/2oyt0E7G6BXCqaqw
	Tr+ucVQnS15qxLYkY+DMpixEpS08Ih1B67xoDmK9DoA6GsVqtxh8h5zUO578eU2UfiRlN6
	+tvrCuNRgUllNGND8Yx9ehhbGsuSKkY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cfjWdnRJ;
	spf=pass (imf15.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786054728;
	b=CKZ15EvBR4yo0AKL1gBcsjINYro/X1ZyRNd5PFb2LOf3oFQ936tmKXH0U6Kwtg+U6aNdsH
	EsUjlPOG9fJKjv8aS1GLuPC8rrzpTsNuoVHxIVW/XLc5wydewcwKL/24YNx0xbTXzxOEJM
	GbA0Bqcpy37bGLDuSyNxD4XWU6zrBBE=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d02b4c3601so31397265ad.3
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 15:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786054727; x=1786659527; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ymry1hvBnXf9k9HJyCKIW/LGlgOgsWSR1QFJjFRqgWs=;
        b=cfjWdnRJ3Mn+BOOD8k/1a5/bQJrjavf8TEMev154F/rDoZ6ZRa8oRPzKmX09gUjQ3u
         K2EPU9cgheotJhma3gCHBvxUJN09KLRtoPPfNXCrxp/OjT5e4jnVKD9h9HilvXkayg69
         6A+QDKVt/K04+47F3XgQ1oUWAWscJhlyRncOQd4fvXe6/tz1cQLkiGskzokSBeNNo7rs
         0TNmHtafUEncsKt79CYXfO5PaNTFQmyGjMWYfPCC5wvADL5oUFszAqxay4y0Cph63qQs
         YLIdPESZgCHPHx3nTaVlonjxdvKXiwZL4vhqkgmWMt3Sva4i4vFtqz2INOKGyyfZxcXV
         OzZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786054727; x=1786659527;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ymry1hvBnXf9k9HJyCKIW/LGlgOgsWSR1QFJjFRqgWs=;
        b=P1+Eb5xAJxmPwCaUsbJc8MVa4bo22T9KNtG09mEausJ/VJ+M9FMq5VLHiV1dw62TdO
         UEYDhsAWpqnzcgSAIUxNPyxHtVfKokH4GRFfFWTA4GM7zitkcFJAkimE5oAJ58FvPH2b
         e0zFZ1cfRm8gsO9rCTfXGtpx+9rzMXuO0syvCS4DLURqbIH9/c45zGfYKjDSwEcmLtYk
         dt2n+mFxWTFSKpJ7O+ufHY5z6eqbpDxYZHFnLmFU30CmkOwm08nd6753v6Hsq0Cb33FS
         fS1epVY+qlu+1MFJaqFXTfe/VMbIL29vlfJt4PfHMc+CmxGT6TTN6NsIl8d2P0IOAMB4
         heLw==
X-Forwarded-Encrypted: i=1; AHgh+RoOPlqW62laANS07XNNRuzXSrJ8MSn6zzsaIupNbOYy3aFwCW2YWPlYiMx5GThi+YXMDTyRfGDACQ==@kvack.org
X-Gm-Message-State: AOJu0YzaCRXOcfypMbe/V822NvUUaISJX2d/lswPMvPusNZkn+y55kux
	teKI4KEellr/3+gUuuVzwiuzls8hIipZxdXiwklUt1GDYuFCFIHM5FS74oVExg==
X-Gm-Gg: AR+sD12TlsXmlzCFF1OzCkmQZ3PMWU1BahQQbecDklso7xTJ8yWTbeKiLfuWzkM4gR+
	e82LUK+dz93mkM7LLb/R0CAru9eJHMYi39P1+TrzTUqDdPS24VYeL5FpHrbnwnpl4XFDo/E17LZ
	9WtG8yGi7zga9UPJ+HwPaLzctuRGZwd7Lm6K0ktczl7fWmx4eJ87gNQc9ZxVfTgpfyIQMDwBkA8
	9SKZghY7adM5+tvEYZbZVjXXTY0lgj/TzTmDNPOzFsl+FeD98RSQUInkN87t0EXjlSIGEUJZcWs
	ZCiBUuwd6YzJib8B75fBUQMJEhzXZjfHePFJVwhPga0SG2QjyM6kV0KBJPYWoD89dD+i8VKKg0u
	OMzTXmARjLnqhFHrKP9YHys72NF3ybhC3msS/UKsrEMSRKssbHAzfAJy5vgy2nv5VTroSMsfd64
	kUXhalaVmebaEdsi8bqkI9AbgeFBgBaXrFH9CLrl/nmAM4piHkJs7LNtMD7Tth8ABLZkF8DZOb2
	I+wX6pe
X-Received: by 2002:a17:903:18d:b0:2cc:9179:32e with SMTP id d9443c01a7336-2d0ca759b87mr189529035ad.10.1786054726985;
        Thu, 06 Aug 2026 15:18:46 -0700 (PDT)
Received: from devvm16600.scu0.facebook.com ([2a03:2880:9ff:42::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bcadc59dsm585515eec.25.2026.08.06.15.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 15:18:46 -0700 (PDT)
Date: Thu, 6 Aug 2026 15:18:43 -0700
From: Ziyang Men <ziyang.meme@gmail.com>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org,
	linux-input@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-mm@kvack.org, kernel-team@meta.com, bpf@vger.kernel.org,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] selftests/cgroup: add memcg_stat_cross_cpu
 correctness test for flush
Message-ID: <anUIQ1oWjUSQhZ4C@devvm16600.scu0.facebook.com>
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
 <20260721174833.1232771-3-ziyang.meme@gmail.com>
 <amCBeD8sGVdi1Nm4@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amCBeD8sGVdi1Nm4@localhost.localdomain>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5FDDBA0013
X-Stat-Signature: qcpnpyqcohdm9r4e66up4iiacj4isfzq
X-HE-Tag: 1786054728-28891
X-HE-Meta: U2FsdGVkX1+UfAJvqcPFgMSr+966UNUFJt9QiLZSMXFtkaWZ9WtuqDhs+yIKlqGm7nXKttLGIU6EqSqyHcO4v3Ep9DVmsf9Vpg4VjOJp6mXV6BaXQSeJOGTaEDNIjKhsVu7WHzuFhADDhpe0nrscZMiMR/kWtXvRmnPJJscrSWCM5f72y8VD9fKPvdfJIsKDUK9F0QnTjZQM0r9A2SlMXRMc/SdTNAC4lrD6dJrWWtpFkKVeKNK8ECny3rwIX8OdreKhH0JqCOG3XVwF/st9avvlGqGPxeBHNTC28M4EjnptDrlwLq4HTnwlDo2+QT3u1OCefwI5iAppbov/9Wm8JIxn9/PfGuRyy0VqMg33AjQajHTkmVq1H+b9y+4Kof1FmFH9wCgaOhT3r/H2jdCIdEwm+9OYNyXftnc65PZ1PyweY1ogDIwbzFKfXoe9M9Q5YcvWYU1kTSsxg1busvu/MTKavNZLkGOy0gByM5IC7J1rbRAIswjjlrL+UCCyMuL7E4xVmu5ATMe/JnEnnKohWM8kqc/IHnJYzAc22yj3wBJnwrDZZe5KU3SdN6X7BJbE19rdnKQB2Y78GcOtA9KkWn5Zy3jFqA0nSdFmp2D+nWhm21Fbw2tzMj5cqRTkxVC7FQSMwczDhcZmsgFOqV4+TIT+gtxU+O60pQtnLOFxeZx2285yQ+qvzGD4UnPNyNSdLNDE7h6LTXFjuFZrTxa/dMQqAXxdXmNPPZuGFrDqi08bSCQO4nlapAq2K/l4QQBNgY5fUiTi+lLFCgbUG+xMFjKLEFnMt6eE61oICjQWpBjHzFg2yGzeKT7ecKujX7kzrmZwLsDiZ33Db9bhmc3sThTvlcZ0bM7GGVBKmOfFv+vJikRjsl6yFthUUHNg/HrrNp7UtKpHiVf7Ir9yt3vI+77BBlZRtbtE+I2pQRTzCnDvgUVffbrcgOEddd7ZE2YYyrDeqnYGoX5tAgEh9U5
 Rcx8VuYu
 DYpPV8tTkyqOWI6kWzDaXjWLcP6Agqojy9x6OlcoUIdAZkpm+RIfvg6ucTe62V4wL2i4Sd8/k6UY362YxmE4t++4oVkOcEgIxS+sF/oCGgu/3rPFCrDgbiade2IlNztmQHUaIME6glflAmcv9VqeTCO4ipNozIJ74nFq6lYg2F68o31ncS1Uq7GIRLYl2BX86VBV9qeSy4ojL8SO+6nmmt8I09DLReypsXfpHxx8ifAAYUAYVf+Ys4xgdZf3qxfN18KZYkxe5fU4l8ZH8+vWTft7qJVgLBqLVaJCizx5oXNVyLrNnszfE+bhhxUMRcd9a3H3ZXrG4I5uaqbaCc4fNW6E7ycKSAMHBd1Rsd6C3W9mUjf2iSqsQ9MUQ5IvkCxAGr0ZVOpXs0XuQ3eKPe98RmXLGilnu0CMIF1y8lAnk56yoaEn09k36liqNgo2JA+nnYUWQFDiMMNfXketOS48sxCLzkVIUvWAszKv3adlffZ0W/TNLkT+FYMFdubx0JWwTqIacI82z0RtGkkGmF8ON2Es7fHlTukD2bsQq+oOL2dJCIk7+RjJNmaqBFEKLv/DBP8C4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 11:43:49AM +0200, Michal Koutný wrote:
>Hello Ziyang.
>
>On Tue, Jul 21, 2026 at 10:48:31AM -0700, Ziyang Men <ziyang.meme@gmail.com> wrote:
>> Add a test_progs selftest that verifies the memory-cgroup BPF kfuncs
>> return values that agree with what userspace reads from cgroupfs, across
>> a whole cgroup subtree that has been charged on many CPUs.
>>
>> It complements the existing cgroup_iter_memcg test.  cgroup_iter_memcg
>> calls the memcg kfuncs on a single cgroup (BPF_CGROUP_ITER_SELF_ONLY) and
>> only asserts each value is greater than zero, so it never checks that a
>> value is actually correct.  This test compares the kfunc values against
>> what userspace reads from memory.stat, and checks every node in the
>> cgroup tree.
>>
>> Moreover, cgroup_iter_memcg does not exercise the rstat flush
>> (mem_cgroup_flush_stats()).  This test does: it launches a process on
>> each leaf that charges and holds memory across multiple CPUs (so the
>> leaf's rstat is dirty on K per-cpu trees), then confirms the flush works
>> for both the BPF and the file path by checking two properties:
>>
>>   1. after the flush, each leaf's anon is at least what the process
>>      charged there;
>>
>>   2. after the flush, the sum of the leaves' charged memory equals the
>>      amount at the root.
>>
>> The BPF reader and the file reader run in two separate rounds.  Each
>> round builds the same cgroup tree from scratch and charges the same
>> amount of memory, so both rounds start from the same state and the
>> numbers are comparable.  In detail:
>>
>>   - round 1 (BPF) builds the subtree, forks one child per leaf that
>>     charges the leaf across K CPUs and then blocks holding the charge,
>>     walks the tree with a SEC("iter.s/cgroup") program that flushes the
>>     subtree at the root and reads each cgroup via the memcg kfuncs
>>     (bpf_get_mem_cgroup, bpf_mem_cgroup_flush_stats,
>>     bpf_mem_cgroup_page_state, bpf_mem_cgroup_vm_events,
>>     bpf_put_mem_cgroup) into a hash map;
>>
>>   - round 2 (cgroupfs) builds and charges an identical tree the same way,
>>     then reads every cgroup's memory.stat / memory.current from
>>     userspace.
>>
>> The subtests differ in how many CPUs each leaf is charged on (a single
>> CPU or across K CPUs), and run on two cgroup tree sizes.  The charging
>> children pin CPUs and there is one per leaf, so the test is registered
>> serial.
>>
>> The traditional path reads memory.stat / memory.current through a new
>> read_cgroup_file() helper added to cgroup_helpers (the read counterpart
>> of write_cgroup_file).  When the memcg kfuncs are unavailable
>> (CONFIG_MEMCG=n) the test skips cleanly; the base selftest config now
>> selects CONFIG_MEMCG=y.
>>
>> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>

Hi Michal,

Thanks for your detailed review! We appreciated for your time.
>
>On one hand, this migth be useful to ensure somewhat stable behavior of
>the reported stats, OTOH, it's exposing quite some implementation
>details (flushing, per-cpu charging).
>I'd say that flushing for BPF progs should work (which is what
>cgroup_iter_memcg() should test IIUC) and yield some precision effect,
Yes the test in cgroup_iter_memcg involves using the flushing. Our concern is
how it ensures the state after the flush is correct. Existing approach in
cgroup_iter_memcg only checks whether the read value is non-zero, rather than
compare it with the actualy ones, e.g.,

	ASSERT_GT(memcg_query->nr_file_pages, 0, "final file value");
	ASSERT_GT(memcg_query->nr_file_mapped, 0, "final file mapped value");
	
This ensures the flush does happen and take effect, but it does not check the
flush take effect as expected. And this is why we want to compare with the file
reading: it is a stronger evidance for the correctness of the flush function.

Besides, another check missed from the cgroup_iter_memcg is that it contains no
accumulation tests for a cgroup subtree. Currently it only creates one children
cgroup and puts the reading task in it. The flush never have a chance to
merge-up the deltas in the leaves.

Another missing parts for the cgroup_iter_memcg is that it charges the memory
and then reads the stats on the same cpu, which means a (possible broken) flush
that processed only that CPU would pass the weak non-zero test. The new tests
strengthen the check by pin each child to multiple CPUs. This increase the code
length but greatly improves the test coverage.

We understand that kernel perfers short, dedicated codes and this is our
target as well. Please do let us know if you have any suggestions for test
design. Thanks!

>however, the comparison with memory.stat may be source of false
>positives due to noise.
>Also, this is supposed to measure convergence in some "static" situation
>but in reality the things are moving (memcg charges/uncharges) in
>various pace so some differences would still occur (IMO such deviations
>are OK, perhaps the test should spell out its preconditions and limitations).
Yes. In the v1 serials of this patch, we actually design another selftests which
simulates the real-world dynamic workloads, by making the leaf process keep
churn memory, and measure the results correspondingly. However this approach
incurs three problems:

	1) We have to manually wait the state become "steady", but it is hard to
	   quantilize the steady state for processes keep churning, so as for
	   real-world workloads.
	2) The error margin would be further increased in the highly dynamic worklaods,
	   and the confidence area for compare number narrows more;
	3) The code would be more complicated than this one.

So the current design is a compromise of the dynamic workloads and fault tolerance.

>As for the implementation in general -- it'd need some tighter
>connection with existing cgroup selftests (e.g. use integer types like
>cgroup selftest, utilization/adaptation of existing helpers to reduce
>copies of same/similar code).
Keep the same style as other selftests in important for long-term maintaince. 
We totally agree with it and will cross check it in the next version.
>
>
>> --- a/tools/testing/selftests/cgroup/Makefile
>> +++ b/tools/testing/selftests/cgroup/Makefile
>> @@ -14,14 +14,29 @@ TEST_GEN_PROGS += test_freezer
>>  TEST_GEN_PROGS += test_hugetlb_memcg
>>  TEST_GEN_PROGS += test_kill
>>  TEST_GEN_PROGS += test_kmem
>> +TEST_GEN_PROGS += test_memcg_stat_cross_cpu
>>  TEST_GEN_PROGS += test_memcontrol
>
>Yeah, this is perhaps so much different from test_memcontrol that it
>deserves a separate prog, OTOH it'd be good to share some common
>cg/memcg functions across the two (some notes below).
Good suggestion, we will take more common cgroup functions functions in
the next version.

>
>
>> +unsigned long long cg_get_id(const char *cgroup)
>
>This duplicates get_cgroup_id_from_path() from
>tools/testing/selftests/bpf/cgroup_helpers.c
I see. Will replace it.

>
>> +/* ---- allowed CPU set --------------------------------------------------- */
>> +
>> +static int *cpu_list; /* ids of the CPUs this process may run on */
>
>I think it'd be simpler to just use cpu_set_t and the standard helper
>macros/functions for this.
Make sense. I will do it. 

>
>> +/* Recursively create children of @path. @path must already exist and be recorded. */
>> +static int build_children(const char *path, int fanout, int depth)
>> +{
>> +	char child[PATH_MAX];
>> +	int i;
>> +
>> +	if (depth == 0)
>> +		return 0;
>> +
>> +	/* Enable memory on this interior node so its children get a memcg. */
>> +	if (cg_write(path, "cgroup.subtree_control", "+memory"))
>> +		return -1;
>> +
>> +	for (i = 0; i < fanout; i++) {
>> +		snprintf(child, sizeof(child), "%s/c%d", path, i);
>> +		if (add_node(child, depth == 1, NULL))
>> +			return -1;
>
>is_leaf := depth == 1
>doesn't look correct (I see below the test builds hierarchies with
>depth > 1)
>Ah, it's non-conventional meaning of "leaf", I'd suggest a subtree or
>partition or similar (IIUC the purpose).
Yes this misunderstanding mostly comes from the variable naming, we will fix it
in the next version.
>
>
>> +		if (build_children(child, fanout, depth - 1))
>> +			return -1;
>> +	}
>> +	return 0;
>> +}
>> +
>> +static size_t tree_capacity(int fanout, int depth)
>> +{
>> +	size_t total = 1, level = 1;
>> +	int d;
>> +
>> +	for (d = 0; d < depth; d++) {
>> +		level *= fanout;
>> +		total += level;
>> +	}
>> +	return total;
>> +}
>> +
>> +/* The tree is arranged in the DFS order within an array */
>> +static int build_tree(int fanout, int depth, int *root_fd)
>> +{
>> +	n_nodes = 0;
>> +	n_leaves = 0;
>> +	nodes = calloc(tree_capacity(fanout, depth), sizeof(*nodes));
>> +	if (!nodes)
>> +		return -1;
>> +
>> +	if (add_node(subtree_root, depth == 0, root_fd))
>> +		return -1;
>> +	return build_children(subtree_root, fanout, depth);
>> +}
>> +
>> +/* ---- cross-CPU charge (one pinning child per leaf) --------------------- */
>> +
>> +static pid_t *charger_pids;
>> +static int n_chargers;
>> +/* parent pid, for the children's PR_SET_PDEATHSIG race check */
>> +static pid_t test_pid;
>> +static int charge_ready[2] = { -1, -1 };	/* child -> parent "ready" barrier */
>> +static int charge_ctrl[2] = { -1, -1 };	/* parent -> child "exit" (close to signal) */
>> +
>> +/*
>> + * One charging child, dedicated to a single leaf and spread over K CPUs.  It
>> + * joins its leaf, maps a resident anon region, then faults the region in K
>> + * slices, each on a different CPU, so this leaf's rstat ends up dirty on K
>> + * per-cpu trees.  The region stays mapped, so the charge persists while the
>> + * parent reads.  After signalling readiness the child blocks (holding the
>> + * charge) until the parent closes the control pipe.  Never returns.
>> + *
>> + * @base is this child's starting index into cpu_list; its K CPUs are
>> + * (base + 0..K-1) mod n_cpu.
>> + */
>> +static void charger_child(const struct cg_node *leaf, int base, int k,
>> +			  size_t resident_bytes)
>> +{
>
>It'd be nicer if this shared alloc_* functions from test_memcontrol.c
>(module adjustoment to cater both users).
Will do. Thanks.
>
>> +static int file_read_node(const char *path, struct file_snap *o)
>> +{
>> +	char buf[8192];
>> +
>> +	memset(o, 0, sizeof(*o));
>> +
>> +	if (cg_read(path, "memory.stat", buf, sizeof(buf)))
>> +		return -1;
>> +	parse_stat(buf, o);
>
>We have cg_read_key_long() for such extractions.
Great. Will use.
>
>> +
>> +/* ---- correctness comparison -------------------------------------------- */
>> +
>> +static bool close_enough(__u64 a, __u64 b, __u64 tol)
>> +{
>> +	return (a > b ? a - b : b - a) <= tol;
>> +}
>
>See
>tools/testing/selftests/cgroup/lib/include/cgroup_util.h:values_close()
Oh I see, thanks!
>
>
>> +
>> +/* Dump one node's bpf-vs-file stats; called when a mismatch is detected. */
>> +static void dump_node(int i, const struct memcg_stat_snapshot *b,
>> +		      const struct file_snap *f)
>> +{
>> +	ksft_print_msg("node %d bpf : anon=%llu file=%llu shmem=%llu fmapped=%llu pgfault=%llu\n",
>> +		       i, b->anon, b->file, b->shmem, b->file_mapped, b->pgfault);
>> +	ksft_print_msg("node %d file: anon=%llu file=%llu shmem=%llu fmapped=%llu pgfault=%llu\n",
>> +		       i, f->anon, f->file, f->shmem, f->file_mapped, f->pgfault);
>> +}
>> +
>> +/*
>> + * Compare the BPF kfunc snapshots (round 1) against the memory.stat values
>> + * (round 2), node by node.  The two rounds are independent, equivalently
>> + * charged trees, so the flushed stats are compared within a small tolerance
>> + * that absorbs per-round overhead (i.e., a charging child's own stack pages).
>> + * A wrong unit, enum or field in the kfunc path would miss by far more.
>> + *
>> + * Two per-round checks verify the flush itself: each leaf was charged
>> + * resident_bytes of anon spread over K CPUs, so its flushed anon must be at
>> + * least that; and the root's recursive anon must equal the sum of the leaves'
>> + * anon (rstat propagated the charge up the tree).
>> + *
>> + * Returns 0 if every check passes, -1 otherwise.
>> + */
>> +static int check_correctness(const struct memcg_stat_snapshot *bpf,
>> +			     const struct file_snap *file, const bool *is_leaf,
>> +			     int n, size_t resident_bytes)
>> +{
>> +	__u64 stat_tol = 64 * page_size;
>> +	__u64 pgf_tol = 1024;
>
>These are central values of the test.  It's necessary to explain the
>choice of them.
I think it would be good set per_leaf tolerance rather than a total tolerance
since the errors merges up at root, may be we can try:

	stat_tol = leaves_below(node) * CHARGER_SLACK_PAGES * page_size;
	pgf_tol  = leaves_below(node) * CHARGER_SLACK_FAULTS;

>
>
>> +	__u64 broot = 0, bsum = 0, froot = 0, fsum = 0;
>> +	int i, mism = 0, flush_bad = 0;
>> +
>> +	for (i = 0; i < n; i++) {
>> +		const struct memcg_stat_snapshot *b = &bpf[i];
>> +		const struct file_snap *f = &file[i];
>> +		__u64 bcur = b->usage_pages * page_size;
>> +
>> +		/* kfunc path (round 1) compared with memory.stat path (round 2) */
>> +		if (!close_enough(b->anon, f->anon, stat_tol) ||
>> +		    !close_enough(b->file, f->file, stat_tol) ||
>> +		    !close_enough(b->shmem, f->shmem, stat_tol) ||
>> +		    !close_enough(b->file_mapped, f->file_mapped, stat_tol) ||
>> +		    !close_enough(b->pgfault, f->pgfault, pgf_tol)) {
>> +			mism++;
>> +			dump_node(i, b, f);
>> +		}
>> +
>> +		/* memory.current is live (no flush) and must bound the flushed anon */
>> +		if (b->anon == 0 || b->anon > bcur) {
>> +			flush_bad++;
>> +			ksft_print_msg("node %d: anon=%llu exceeds current=%llu\n",
>> +				       i, b->anon, bcur);
>> +		}
>> +
>> +		/* each leaf's flush must have gathered the full cross-CPU charge */
>> +		if (is_leaf[i]) {
>> +			if (b->anon < resident_bytes || f->anon < resident_bytes) {
>> +				flush_bad++;
>> +				ksft_print_msg("node %d: short flush bpf=%llu file=%llu\n",
>> +					       i, b->anon, f->anon);
>> +			}
>> +			bsum += b->anon;
>> +			fsum += f->anon;
>> +		}
>> +		if (i == 0) { /* nodes[0] == subtree_root */
>> +			broot = b->anon;
>> +			froot = f->anon;
>> +		}
>> +	}
>> +
>> +	if (mism) {
>> +		ksft_print_msg("bpf (round 1) disagrees with memory.stat (round 2)\n");
>> +		return -1;
>> +	}
>> +	if (flush_bad) {
>> +		ksft_print_msg("flush did not aggregate the cross-cpu charge\n");
>> +		return -1;
>> +	}
>> +	if (broot != bsum || froot != fsum) {
>> +		ksft_print_msg("root anon != sum of leaf anon: bpf %llu/%llu file %llu/%llu\n",
>> +			       broot, bsum, froot, fsum);
>> +		return -1;
>> +	}
>> +	if (bsum == 0) {
>> +		ksft_print_msg("tree carries no anon\n");
>> +		return -1;
>> +	}
>> +	return 0;
>> +}
>> +
>> +/* ---- one case ---------------------------------------------------------- */
>> +
>> +struct testcase {
>> +	const char *name;
>> +	int fanout;
>> +	int depth;
>> +	int cpus_per_leaf; /* K: CPUs each leaf is charged on; 0 = all CPUs */
>> +	size_t resident_bytes; /* anon charged per leaf */
>> +};
>> +
>> +/*
>> + * Remove the subtree in reverse creation order.  Nodes are recorded in DFS
>> + * order (a parent precedes all its descendants), so iterating backwards
>> + * removes every child before its parent.
>> + */
>> +static void destroy_tree(void)
>> +{
>> +	int i;
>> +
>> +	if (!nodes)
>> +		return;
>> +	for (i = n_nodes - 1; i >= 0; i--)
>> +		cg_destroy(nodes[i].path);
>> +	free(nodes);
>> +	nodes = NULL;
>> +}
>> +
>> +/*
>> + * Round 1: build and charge a fresh tree, walk it with the BPF iterator (which
>> + * flushes and reads each cgroup via the memcg kfuncs), and capture one snapshot
>> + * per node into @snap.  @is_leaf records the tree shape so the later comparison
>> + * can run after the tree is gone.  Returns the node count, or -1 on failure.
>> + * The tree is always torn down before returning.
>> + */
>> +static int capture_bpf_round(const struct testcase *tc,
>> +			     struct memcg_stat_snapshot *snap, bool *is_leaf)
>> +{
>> +	struct memcg_stat_cross_cpu *skel = NULL;
>> +	struct bpf_link *link = NULL;
>> +	int root_fd = -1, ret = -1, i, mfd;
>> +
>> +	if (build_tree(tc->fanout, tc->depth, &root_fd)) {
>> +		ksft_print_msg("build tree (bpf) failed\n");
>> +		goto out;
>> +	}
>> +	if (start_chargers(tc->cpus_per_leaf, tc->resident_bytes))
>> +		goto out;
>> +
>> +	skel = memcg_stat_cross_cpu__open();
>> +	if (!skel) {
>> +		ksft_print_msg("skel open failed\n");
>> +		goto out;
>> +	}
>> +	if (bpf_map__set_max_entries(skel->maps.results, n_nodes + 8)) {
>> +		ksft_print_msg("set max_entries failed\n");
>> +		goto out;
>> +	}
>> +	if (memcg_stat_cross_cpu__load(skel)) {
>> +		ksft_print_msg("skel load failed\n");
>> +		goto out;
>> +	}
>> +
>> +	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
>> +	union bpf_iter_link_info linfo = {};
>> +
>> +	linfo.cgroup.cgroup_fd = root_fd;
>> +	linfo.cgroup.order = BPF_CGROUP_ITER_DESCENDANTS_PRE;
>> +	opts.link_info = &linfo;
>> +	opts.link_info_len = sizeof(linfo);
>> +
>> +	link = bpf_program__attach_iter(skel->progs.cgroup_memcg_stat_cross_cpu,
>> +					&opts);
>> +	if (!link) {
>> +		ksft_print_msg("attach iter failed\n");
>> +		goto out;
>> +	}
>> +
>> +	/* bpf walk through the cgroup tree and fetch result */
>> +	if (bpf_walk_once(link)) {
>> +		ksft_print_msg("bpf walk failed\n");
>> +		goto out;
>> +	}
>> +
>> +	mfd = bpf_map__fd(skel->maps.results);
>> +	for (i = 0; i < n_nodes; i++) {
>> +		/* Save the position for the leaf, used for later correctness check */
>> +		is_leaf[i] = nodes[i].is_leaf;
>> +		if (bpf_map_lookup_elem(mfd, &nodes[i].id, &snap[i])) {
>> +			ksft_print_msg("map lookup failed for node %d\n", i);
>> +			goto out;
>> +		}
>> +	}
>> +	ret = n_nodes;
>> +out:
>> +	bpf_link__destroy(link);
>> +	memcg_stat_cross_cpu__destroy(skel);
>> +	if (root_fd >= 0)
>> +		close(root_fd);
>> +	stop_chargers();
>> +	destroy_tree();
>> +	return ret;
>> +}
>> +
>> +/*
>> + * Round 2: build and charge an identical fresh tree, then read every cgroup via
>> + * memory.stat / memory.current.  The tree is reset after bpf read, so each
>> + * read does a real rstat flush.  Returns the node count, or -1 on failure.
>> + * The tree is always clear before returning.
>> + */
>> +static int capture_file_round(const struct testcase *tc, struct file_snap *snap)
>> +{
>> +	int root_fd = -1, ret = -1, i;
>> +
>> +	if (build_tree(tc->fanout, tc->depth, &root_fd)) {
>> +		ksft_print_msg("build tree (file) failed\n");
>> +		goto out;
>> +	}
>> +	if (start_chargers(tc->cpus_per_leaf, tc->resident_bytes))
>> +		goto out;
>> +
>> +	for (i = 0; i < n_nodes; i++)
>> +		if (file_read_node(nodes[i].path, &snap[i])) {
>> +			ksft_print_msg("file read failed for node %d\n", i);
>> +			goto out;
>> +		}
>> +	ret = n_nodes;
>> +out:
>> +	if (root_fd >= 0)
>> +		close(root_fd);
>> +	stop_chargers();
>> +	destroy_tree();
>> +	return ret;
>> +}
>> +
>> +static int run_case(const struct testcase *tc)
>> +{
>> +	struct memcg_stat_snapshot *bpf = NULL;
>> +	struct file_snap *file = NULL;
>> +	bool *is_leaf = NULL;
>> +	size_t cap = tree_capacity(tc->fanout, tc->depth);
>> +	int nb, nf, ret = KSFT_FAIL;
>> +
>> +	bpf = calloc(cap, sizeof(*bpf));
>> +	file = calloc(cap, sizeof(*file));
>> +	is_leaf = calloc(cap, sizeof(*is_leaf));
>
>(This caught my eye, it looks like those could be better members of
>struct cg_node. But I'm not 100% leaned to it.)
Good catch, I will move them to the cg_node in next.
>
>> +	/* round 2: file reader flushes and reads a fresh, equivalent tree */
>
>Hm, I think that's quite a strong assumption that the 2nd tree would be
>equivalent (wrt memcg state). Could you back it up with some arguments
>if you want to rely on it?
Yes. I just measure it and it seems the anon is identical but the pg_fault is
not. So maybe the two tree design is not necessary. I think maybe we can remove
two trees in the next version, but just perform one time flush and read from
both bpf and file. This can remove the noise and provide more accurate results.
What do you think?

>
>
>
>Thanks for an interesting comparer,
>Michal

Thanks for your review agian and detailed feedback!

Best,
Ziyang


