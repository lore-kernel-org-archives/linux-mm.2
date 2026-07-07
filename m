Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F19EC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 23:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760256B009F; Tue,  7 Jul 2026 19:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738796B00A0; Tue,  7 Jul 2026 19:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E636B00A1; Tue,  7 Jul 2026 19:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AEE56B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:27:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62E54A05C7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:27:30 +0000 (UTC)
X-FDA: 84963569460.03.E49A8BB
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7E36940009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:27:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Y/WMqxV0";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ziyang.meme@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783466848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=056knz1SGCh1gABAXpDMbPSHV+jE2HKWxGqRP9xXJ6k=;
	b=AP1Gl3rzI1QHYpT+FJRm9tMlQnAsBy1BPiDj5G9LD3xpltwXGWwhBIgo8Q0JpuhyvQF3JQ
	IG5B6A6ot7/973XknxqdJQgFtMsgc8BU1iICVsm1mNw6FM+E7mgkWeMgiorhsnBllQ3kqQ
	TFT/piYKvtJ8QtDZFpzDZGTrxu6/X4o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Y/WMqxV0";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ziyang.meme@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783466848;
	b=sPKd5ajJ42kdz92IDWKUtZBjA5rxEqHDrLQLLoG2dN6qsegKUDEAF7hjxJf/qH2mdRmbL/
	AXKM3WRfvrrc6anuOBozzYrzxF8MKpyvBuQGBW/Pgjkks4sB0YNVxmuqS9rwXDoL4f+vs2
	ilGQyRd63w008GzKHBR6kPxC+hLaHbc=
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-380755c89e4so33182a91.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 16:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783466847; x=1784071647; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=056knz1SGCh1gABAXpDMbPSHV+jE2HKWxGqRP9xXJ6k=;
        b=Y/WMqxV0Q6v40L64gkYvzUI3egT6nZ0kKf6m7QWa83foGQrevzucvF9Pb96feYSygL
         meULZ92YUfKWU1czhpI1GQ2QYkz4RTOOtMawUoXiaw5b2wEZBQPTn4P+G3mASvBBxG3f
         Ej+OU3a02OgV5YfWUFSudl1PrdNOXw4DetLbggkpcYuw3kIeZ5NVZrsGvA0vrR1fV7m4
         qxPWc1LHU+LxKTUHM8a5xaq7G1kyVuj0x6dzK+DXMFEOmoW+gstxcAdz0t0VmAkC6QIe
         AgNdxYODS+BtoQphFbSPoq0zDGdLB7+DjhbRGDQZky0sWqe138vr6q5D/15u75QBgtVq
         uuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783466847; x=1784071647;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=056knz1SGCh1gABAXpDMbPSHV+jE2HKWxGqRP9xXJ6k=;
        b=IqLAi5bY03wObN+A271SqpVBxrkr8hvp8H5ik1/WeLp/eq/1YfpozISjpc6ZVWqsLC
         dQSoyZH5lmsvmL/ORjbVWTiGlWT2h0+1Lq7XQ2RTVF4em9dcMFGtEDU3VT/2UM2eZlYM
         A4Ie/dQmrAY/VkZXSVs2h2Id27YatEp4X2Y8xID2V2lvuFD7VrU96wtf+iOtFAowU8lt
         OeKwC7Dfxlc7cXf2+VhpOHogAzwkJi6tuhPrYLTwQFlOiWCnTGLg+zkB5oYONSo0QOwn
         PqTB5tY5Vb/Nuzv8w9bOJIKofDI49znQBila9HJPRLHhkT0vr8QavoFI0y7mBNN0e6Ig
         1OeQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr/J6egOOCo51QIyCwO7ZM0kW10GTgNAWyd+S2I9QhFDXZAD2N7VhU7+TEkH54OdpQxTB49xr//uQ==@kvack.org
X-Gm-Message-State: AOJu0Yyc4HRq8Sys837nMaSYmEZT0QjhHIsSWQbXkBAhtxy783bJaJ/B
	rnAgVxFyAca9Koghwmnb8pTqIMIABT7iuY+uJ/y4Mv9uJlhckWrtzoyh
X-Gm-Gg: AfdE7cnjJlctk76ub+D7ZsGM6WHlbCJV8ReaQwYMBWMP9eeuTnIOLcHyRhDxVKktfyp
	uYIL62zbmDzhqyk74IOfvrBKA4NtRL3qI2NBXey1242Zd+cF3NSliA/exlC5BY+QU7dvK8Vg4sw
	d6i77GuHvB+lpoHcJ+YihcwGAtROxggglHo9ojU9ny556vYH5fM46nsn3kB9ixpeUT2kZ3n16YM
	cDIJnokaQgd3Ot0UPGblhwv/C900y4PSdWfuk36/OTXJVlVl6LsAf+xapp0y1p18vTJSDj76d8z
	16qTa9ePqM1oWtgNdiYU3FcnAWTMaFdUHPvo+IG6o6DO29f0EK41UAxjVw3hN11SqIK3VkT6Yrq
	OqgxcMwqUgIICv3QxJ4E+4UoLXwmqMWdkZLICyoYC9WpQEa2drZYFzNnVeodtWpKeZ3l5HopRqT
	0rrbVHi5zvh78Kse9TIBkMO53pxH7U54Fi
X-Received: by 2002:a05:6300:6186:b0:3bf:6c08:2b27 with SMTP id adf61e73a8af0-3c08eef1138mr7948741637.47.1783466847249;
        Tue, 07 Jul 2026 16:27:27 -0700 (PDT)
Received: from devvm16600.scu0.facebook.com ([2a03:2880:9ff:63::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b6594f9a0sm13570646c88.4.2026.07.07.16.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 16:27:26 -0700 (PDT)
Date: Tue, 7 Jul 2026 16:27:24 -0700
From: Ziyang Men <ziyang.meme@gmail.com>
To: Eduard Zingerman <eddyz87@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>, Ziyang Men <ziyang.meme@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, kernel-team@meta.com,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] selftests/bpf: compare BPF and memory.stat memcg
 stat readers
Message-ID: <ak2LXDWoPFSJL2Q9@devvm16600.scu0.facebook.com>
References: <20260704045617.487664-1-ziyang.meme@gmail.com>
 <bc12730fe6eccde10d36e6544607ae2464357e05.camel@gmail.com>
 <akxW5dzvR9e2CfGq@linux.dev>
 <eccfd9a8dd1af1668e142b9b866194333647b0d5.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eccfd9a8dd1af1668e142b9b866194333647b0d5.camel@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E36940009
X-Stat-Signature: waq6dj1re7k14u7uxc497zzmby169aw8
X-HE-Tag: 1783466848-783473
X-HE-Meta: U2FsdGVkX19j/5j6M2SeBLpzvCvcmdZv1GSSBthSuaPSWte7wSnHTfjTIqJMhN95k4wdJiduDeAoGWkmkoy1iJhdLn7eHqDv/x19jnnizF5H7ZaUIgwpprublsk1+dgLHCHqpcZd58AISCFqncQvMzS52K/7KNE45fZ/LqIocHsrEZcK1NlS8i/ZEItjjoQYj3crHqAVS84QKw5taCpIpbmZQ8kDJhswdV3MyqRqPH163+Gs5jp38m7dAe9/nmI4r4tui//x26dJfnLOPRHEjRBWeMdsv9OBIyNxzPHJ9l6ah9nA0PBAKvnVzbJzC7E8PX+6O0ULi8C5pp/40sL7+9+fIWvHkHdhNUUrP68V0lx5ZO5SmJ2jJfaDEusaq4vLQ2vK0lBXc91FdHWlv9KuNhFIojf200tfWu1UWlTIr3i70Ign49Z1UHzbBJWW8N+QJpINI8hwp8LCHoOVC/e6S7kXjePHmV3aBckGGFFKh3XD+kHnDSRzvBe1Bq1jEJrjwsMLrEAzJPBLhpoiTC/iF1x7l5L15OO636e2jvY3g7idmhhCpCEnlQTOYuVlON8cK1bRYrk/W5OVU3Z+cTMNXFQeV/90Z9j4SNMLwYvjSnw3cX1yG19t9IxR9tKm6RDjpMc+ecTiAxqBq25RnENWnT6cfinuqCew1/edwpg5QXm7DOWaLUHJDGjgLxBZF13pNetLBFzsBoxpM1gf5XSRnsruuWyvax5Qxa2Mc+nxOHTY2QwlR7y9tDw2bmFbmcJ2sAmd2EnV0OwY/tVBMsSNKEhi9hyFf3UCBHAxttL3nwD/gDsqIrDPRXgJe4f5P1FeppUykZal5tSYETGqRZW6+kvrBvzhomsza1Iu7/Dei0BIy7GCj6EcyO/NZozhsKnhd/yqh5Kz1xO3HMjsRMbm53e9X+bH9r7G73bC605hJJiNOXg1NH2MoSEEdceOiPtl8b7qAuIIK76SBtXszrB
 FaIUEfZe
 B1awcOZuYFeSS4Fp1YsgdoWwhIvNVGXA4xuwJCNiX+rhJs0qrGKKobZXnBEfKvcic5Z2KoJPf14jEz+EPAUhwb1uY1nQMjtMj2q0op7A9Qivh5ubuGeIiLu7shP9e9GbE8JeNwmvY6mZvc/nu/XfMJ7Ly2u/iG4Vi5q/09FgGGJjf9v0/01cB1Z21fWVT1dYa57hBW/1QbJ0SGlc/hZLDVuOTKdNym77fayYUhow1ZckCBWyucUBMuA3l8+9JVhVjxvd7/5kvOOCdgH4IUiI7CZyquOYYHI9Hj2Eg1Brj+J/r72bG++FK9AZ2EVvg8Hp1ZhqR27HQz9JX1RLVbnbOOIRFoqSMhhVVTZqPEQCY32WVlpeiVHYOzRBjQc9sL1sHeJCuwtff5Lu11AuKkVTsmn86976fEMVrzde2xwnWP/mHXkoEPS+HpVTVMry9j3z+gHgV9JLxExZEZw6ZA52f4uIJQhPkzMKxBHySunGHMPBWdktrPR5i7zToLZBOZ6Adj3BbOX+9Lfv06MxeCxgXTA5qFRMkM/4olOfuHfybL6xjDbQOY86ndwJEC9d3W775VTLg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 02:21:59AM -0700, Eduard Zingerman wrote:
>On Mon, 2026-07-06 at 18:50 -0700, Shakeel Butt wrote:
>> On Mon, Jul 06, 2026 at 05:17:50PM -0700, Eduard Zingerman wrote:
>> > On Fri, 2026-07-03 at 21:56 -0700, Ziyang Men wrote:
>> >
>> > [...]
>> >
>> > Hi Ziyang,
>> >
>> > I'm a bit hesitant adding 2.5K lines of code to the BPF selftests,
>> > as this code would need to be (a) maintained, (b) run at each CI invocation.
>> > Hence, the tests added need to be relevant for the BPF sub-system.
>> >
>> > Regarding the benchmarking part, as you state yourself:
>> >
>> >   > In my testing (a 60-CPU VM) the BPF path is roughly an order of magnitude
>> >   > faster than the per-cgroup memory.stat parse for a whole-tree scan, mainly
>> >   > because it avoids the per-cgroup open/read and string parsing.
>> >
>> > With this, I think the benchmarking code can be dropped altogether.
>> >
>> > Next, the three memcg_stat_{reader,churn,churn_percpu}.c files share a
>> > lot of utility code almost verbatim (e.g. tree definition/construction).
>> > Such duplication should be avoided.
>> >
>> > Finally, from the BPF point of view the test exercises the following functionality:
>> > - kfuncs:
>> >   - bpf_mem_cgroup_page_state
>> >   - bpf_mem_cgroup_vm_events
>> >   - bpf_put_mem_cgroup
>> >   - bpf_get_mem_cgroup
>> > - main iterator logic.
>> >
>> > All kfuncs but bpf_get_mem_cgroup() are thin wrappers around mm/memcontrol.c code,
>> > all kfuncs including the bpf_get_mem_cgroup() are already exercised in the selftests.
>> > The iterator logic itself is covered by 8 sub-tests in the prog_tests/cgroup_iter.c.
>> > Hence two questions:
>> > - What do these new tests add in terms of tests coverage?
>> > - Why do BPF selftests need to exercise the churn and churn_percpu scenarios?
>> >
>> > Shakeel, could you please comment as well?
>>
>> Hi Eduard,
>>
>> Thanks a lot for taking a look. The main motivation I had behind requesting
>> Ziyang to send this series (beside making him learn the tooling and process of
>> sending patches to lkml) was to have a reference implementation and performance
>> comparison for BPF based cgroup/memcg stats collection.
>>
>> However you have correctly pointed out that selftests might not be the right
>> place for such kind of code as selftests are more focused on functional tests
>> and run by a lot of CIs while this is a performance benchmarking code.
>>
>> I am wondering if there is a place for this benchmarking code in kernel under
>> tools folder but archiving it on lkml might be good enough and should be easily
>> searchable. Anyways thanks again for your time.
>
>Hi Shakeel,
>
>We do have bpf benchmarks in the kernel tree, the entry point is
>tools/testing/selftests/bpf/bench.c. These are supposed to be
>performance measurements and are executed manually from time to time
>(quite rarely, as far as I understand), not by CI.
>However, if I understand Ziyang's assessment correctly, this code is
>not really a performance test, but kind of a load test.
>
>Thanks,
>Eduard

Hi Eduard,

Thanks a lot for the review. Yes, as Shakeel mentioned, the performance
comparison for BPF-based cgroup stats collection was the original motivation.
But the patch also carries functional value: alongside that comparison, it
checks the correctness of the stats the kfuncs return.

Let me first answer the main question -- what these tests add over what we
already have -- and then lay out a plan.

First, the static test (memcg_stat_reader) vs the existing cgroup_iter_memcg.

The existing test calls the kfuncs, but for each value it only checks whether it
is greater than zero. For example, in prog_tests/cgroup_iter_memcg.c:

     memset(map, 1, len);                    /* dirty some anon */
     if (!ASSERT_OK(read_stats(link), "read stats"))
             goto cleanup;
     ASSERT_GT(memcg_query->nr_anon_mapped, 0, "final anon mapped val");

It never checks the value is actually correct -- i.e. compares it against the
value in cgroupfs -- only that it is non-zero.

Besides, it also walks a single cgroup:

     .cgroup.order = BPF_CGROUP_ITER_SELF_ONLY,

and reads only five fields.

The memcg_stat_reader in this patch adds three things:

   1. It compares the numbers. It reads the stats through the kfuncs and checks
      they match the values in memory.stat, instead of only checking they are
      non-zero (memcg_stat_reader.c, check_correctness()):

         /*
          * anon (NR_ANON_MAPPED) is rstat-flushed and, with the charger
          * stopped, deterministic: BPF and memory.stat must agree.
          */
         if ((b.anon > f.anon ? b.anon - f.anon
                              : f.anon - b.anon) > anon_tol)
                 anon_mism++;
         ...
         ASSERT_EQ(anon_mism, 0, "bpf vs file anon (rstat-flushed)");

      This is the main gap: b.anon comes from the kfunc, f.anon from parsing
      memory.stat, and the test requires them to agree.

   2. It covers a whole subtree, not a single cgroup:

         linfo.cgroup.order = BPF_CGROUP_ITER_DESCENDANTS_PRE;

   3. It reads a much broader field set (~40 fields, collect_full_stats()).
      Minor.

Second, the churn test adds something the static test cannot.

These counters are kept separately on each CPU for speed, and are only added
together when the code "flushes" them. The existing test does call the flush,
right before reading (progs/cgroup_iter_memcg.c):

     bpf_mem_cgroup_flush_stats(memcg);
     memcg_query.nr_anon_mapped = bpf_mem_cgroup_page_state(
             memcg, bpf_core_enum_value(enum node_stat_item, NR_ANON_MAPPED));

But if the cgroup is idle there is nothing to add up, so the flush does no real
work -- and since the result is only checked for non-zero, nothing verifies the
flush gathered anything. If bpf_mem_cgroup_flush_stats() were replaced by an
empty stub, this test would very likely still pass (the kernel also flushes on
its own, periodically and on thresholds).

With activity going on, especially spread across several CPUs, we can make the
flush do real work and then check it by comparing the numbers after the activity
stops. That flush check is missing from all of the current tests, and this is
where memcg_stat_churn / churn_percpu come in.

Finally, my plan:

   1. Keep the static (value-correctness) test, or fold it into cgroup_iter_memcg
      if that works better. I also noticed that several kfuncs are not called by
       any test today (no callers anywhere under tools/testing/selftests/bpf/,
       only __ksym declarations in vmlinux.h): bpf_get_root_mem_cgroup,
       bpf_mem_cgroup_usage, and bpf_mem_cgroup_memory_events. The static test
       would be a good place to cover them too.

   2. Keep only one of the two churn tests -- most likely the per-CPU one, since
      it is the stronger of the two -- and change its correctness check to
      actually verify the flush by comparing the numbers. The current check is
      weak; it only checks non-zero values and that every cgroup was visited:

         ASSERT_EQ(missing, 0, "all cgroups present in map");
         ASSERT_GT(total_anon, 0, "tree carries anon under churn");

   3. Move the code these tests share into a common header, to remove the
      duplication you pointed out. Or we can combine these two tests into a
      single one if works better.

   4. Keep the focus on functional testing in the selftests. The file-vs-BPF
      timing could stay as an extra bonus -- printed only as informational
      output in verbose mode, never as pass/fail -- but I'm happy to move that
      comparison to the bench framework if you think it fits better there.

Please let me know if you have any concerns with this plan. I am happy to take
any suggestions on how to improve the tests, or to change the focus of the
selftests

Thanks again,
Ziyang


