Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D7ECCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9C88E000D; Tue, 11 Nov 2025 01:13:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090D08E0002; Tue, 11 Nov 2025 01:13:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8B48E000D; Tue, 11 Nov 2025 01:13:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DAEDC8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:13:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5092886E3
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:13:53 +0000 (UTC)
X-FDA: 84097310346.23.98BC9FE
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id B2C2E2000C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:13:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=PnWvdDY8;
	spf=pass (imf13.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762841631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x6ye0KUrS4UUrF7S8bH5+znRQmU5zqbKdnyimkow66o=;
	b=T6TjSQX4t8T4EpipiNbvOhkioKH5G8G91b+CZdVEno52M0e6fmgJEnjauFvXeS+jbi6dOA
	nDnv7ogOCByXp9p96H6HGwivpSS3IbD8M/3Zd8Yd+XIuv/G0Ws4lEsENEK29idVMgsQ/Tk
	YQmGYzDPeQpU0teI7vhlIE3ilW/wcjY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=PnWvdDY8;
	spf=pass (imf13.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762841631; a=rsa-sha256;
	cv=none;
	b=Jd/iOKa0Ic5I0lzMaXAca7Wf7J6s+8QYAmgFFar7mqvi7plqJHGJZnZyXGChKfG53HFc2t
	scGmXJLGq5Z9V6jbuzN7aaqa7GNaVUEu5hWXsRLCVPAMHBfZ5XXUOsUADT3Ms3YG24GWzD
	PvnVZWaFbLBFNlb9c6kLQHYULXZrnkQ=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3410c86070dso2534057a91.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762841630; x=1763446430; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6ye0KUrS4UUrF7S8bH5+znRQmU5zqbKdnyimkow66o=;
        b=PnWvdDY8So9u6Lwy54+odheiKodpUjEEl6+nE53WrW1QDaK0vVI4wBAc8QMDhnWnYu
         3SIJ+VJ5yljwDKhx4xoahuu31yXQMSyWZjA4n/T+EY3GzhyLq6vllD4W0AOW/3NMV0xA
         ANMHhdJNQqD389t0bEs3GEXtaygqccSxzFtrcyIGBngnZQH39ymHA5s53N14yNyvZ1yu
         9MHeIejxkHVaVNVJGbwnE+/FkmQZG66jHvSDYcr8CbD7vrujlw/awuVnhall5yQlrbMK
         wE77gQagxX0Z1YJUtehnrLhj1+/izsvWqr9VLva/oBA56J0Q8pGoW4gUFFW3/4rJ3HdL
         wZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762841630; x=1763446430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x6ye0KUrS4UUrF7S8bH5+znRQmU5zqbKdnyimkow66o=;
        b=P2BzJ1Z8HgSjQvsNxku4/Tqt/RBWCm8nNHAmgVs4E5fD5GE2EGk72RPV55izwisXvd
         yzaf7YMefkRSox4Qs9V9ZRMbvQR7aXX4XdKm10nwAnHXgi40ylgez/P1X+q35qQ/aPZH
         NnsgQveYDE3IVyDeUcpBX+5jI2hpukpnO4RXXbAfD9r2UoAaz3KfbFgr4UDgblkuNLk9
         QZvRGAn/pFD6aGE/PTjJI+HSjsqX24KeVxBAgz7gpEHMN7Fo7gI7TnrpeeqmEWRBA5DW
         rbCYr8OxunV1GC6pGe6Ycfi2nr6GT7oMdFPsw0vtGDdZYMqhf9ryUnBvFn9cClq7ruHD
         Lo+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUI1jmDm82Kp0hTP4BzNbG+EYZRg7ho8yRKMKkt19XdxVjHTwzthm+VNnFA/unkzREcHedbFZ0sLQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7BffJMQ5jJANDs45LSvDSLR5KjEtspgh3j3i3ZLJiRy3QJ8lZ
	TKSXoP9WmDcgacmENZzRTkTZd1NoxNKxNpxnOec6972HsQd+5L2M6jPFF6pAZfvBwqc=
X-Gm-Gg: ASbGncs55/z/4SSRW2FOvOZHAa8SC+lIhw8syTtHe1mYJ2FiHfmx4kBMTtPyoJ4ZaJC
	6c5moDhlpHATCKJBYYpGZitjdx9ege/ro4+By9wyL8z29QW8W0S6Up79uyL0ZVuivFm3jcmtLhc
	xI7iIFOoMEbGy5YaJ6AyHNCzUjEuoBz07elUL/j+wKGMr1zcYLUadDBK4O/RfC60wn2LCG/6wDZ
	tPojMRIzcBp3bqbwWNB19nUxabav7MXmB2SbVlTlVVNlR5dDFDKeV7OLtfG9gDyyKcNuiQSTGA/
	zZk66NocAyoRpel/NOSMGCujEhqsfYhK2Ohuhjoj0SbONU1GmJBepvDeZyFOPMgOJ2FAci84wPm
	43/O+adHYzRccHR/nxujQAMqEKIC9Qu+74jj0rkXSgZEzyvg+pLbJD/Divud8zC0L+Gs1j2/+X7
	9xXInzzDIsmHOBfgrF2XahvWwF
X-Google-Smtp-Source: AGHT+IFit24Wfiz5/okT1CYzaOFSn2pdykfe7Yx20hV//KiCLFFviTnyJczCSUcO4P48kN01R/ygpg==
X-Received: by 2002:a17:90b:54cc:b0:32b:df0e:9283 with SMTP id 98e67ed59e1d1-3436cd0bcd5mr13428881a91.34.1762841630530;
        Mon, 10 Nov 2025 22:13:50 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc175d85sm14312666b3a.43.2025.11.10.22.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 22:13:50 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: mkoutny@suse.com
Cc: akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	jack@suse.cz,
	joel.granados@kernel.org,
	kyle.meyer@hpe.com,
	lance.yang@linux.dev,
	laoar.shao@gmail.com,
	leon.huangfu@shopee.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mclapinski@google.com,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	tj@kernel.org
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for on-demand stats flushing
Date: Tue, 11 Nov 2025 14:13:42 +0800
Message-ID: <20251111061343.71045-1-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <ewcsz3553cd6ooslgzwbubnbaxwmpd23d2k7pw5s4ckfvbb7sp@dffffjvohz5b>
References: <ewcsz3553cd6ooslgzwbubnbaxwmpd23d2k7pw5s4ckfvbb7sp@dffffjvohz5b>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B2C2E2000C
X-Stat-Signature: 8un5b5hhym1k59p6oghrmahxj7yz1dsp
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762841631-47406
X-HE-Meta: U2FsdGVkX18qv7/8Jvrq1AjMUmCPQJSqqZ402cQTb0V5px8PxlCHTnhj70PnMFxYk7V9zCLkezbm7iEAfzLpRywEZqgSbE0OsA3oHVWECV1O2eobdzjEL3KrZBuNlh38nPU99bfy8XMkJPsItzYAKwWb5xUDC69K3KBxHvNAI4a3hnvwn7EjqP69tAFx8T/9CCfh2NOwOmt5meiuexLIItTiPXwylJ+TJ79IkSVG4onGtvxG9LmZC4BYTRBVUuGyD03B8sEkbDt58TN+HV5mNghLvLfsJqW3pFlvTZhDRq70o60n0j4EbK2BmgSwT1tWW/51767nnXwd47N+TRQDOoxS9npO6cR8P5lV0qFYQxmDpcjd5xfX3yUKNzogJZRJB2SToEWrW4IHfIRkoRCz4TGINn1plA8kCY+s3LeaYa3IwMX8Gud99/H5Jm6cCOSeodhT2Qqfm/n4gxMUzFxZnmWTD4WdQD/5X2T5fu8d+vuC+AZM5ywmvchm4Barz0Las7vfQ/o0ivWDlE1dqE8OXubRV3IoU4UfRz+tRi7ilCJ/0ZXVq9/1bbVspEjI9Db5NmTuyQ+ITLEgTW+bsYFL4Dy5Lmr0nNuNccivvk4ZI3f9w6ECiv7h1poKW0h0vS2uB+p5Vla7JAbzy6xSpALjscQ0hr4FXqhuAZorSzClAJDsbJI4iTQt7LgIVCg9T+KdFFtDdLUscqz8gXPyy/emwft9Gp5pJ3QpKp/a8KfrKH3q0KGihH4t6IFpxm7w8JawPxMBNEC6Q6P/uM2y4tDdXjQVyXnmZe+LMuJRRymNbxuUB70X5svhWqVq4Tlz6bL8ghlF0mIQz9SbVmKVq6CFH440DXm8Cx+hA0BVQ5LPkQw/4bFioLXHQ8bSooYklPDTjopWdRxQP+BPvtqT3bxGQiUwlxLZA4Pcq+61xG/2qRTQePNF6U1Oddwfr+wpRD0oTencxAdIdmdjyqCE4uX
 RQzlcaCg
 XFAW6VV2XfE90OF5Im21eB+41bM6JNQrKm/cIczBeRIhlnKg15givHVBuxhA53TXEjxgpncmSD5a3u2EC1rAL6IlGPdHwXQ4fKkA6HaI3HFuDdeTHsQ4iroxySi8a2wtSWNozsdDUVld3SmDG3Hezjc/3RzHBwy/ZTdzcUql8m/QbZm8bEfHFaC0WAmzwvHOwY01ezISYzij4D9vdtyCM+cUdpQUMN/uzM6c8BAQX+OlwEnYOR1urb17SvIPoyvKlkETdrtCF5INXgwrblTDkVmSu5bfEpuGEm1Lbr0xx9Dao6XjuihA8UosFurnxvKlTtDfw1d4yG5BBLPwunPew8OPYl7nx8JaQgGolf1BiMliDA0YU6NR74QLX1xj+NcXUcMo9uUDMvfgP7EMw3t/ucpgyhTjzkSH6cjDz9taNu7e2524HdEQIiWsRW8Xll6UudUjs8QkjVa3Ingku7HVw009nWKOReAkKROuHWFGTZ9yxMZlF4ZbUqRKq8pCYap5AR9uPlf7zhPsaY30FKVjunl3EazkauJ7zUF9J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 9:50 PM Michal Koutný <mkoutny@suse.com> wrote:
>
> Hello Leon.

Hi Michal,

>
> On Mon, Nov 10, 2025 at 06:19:48PM +0800, Leon Huang Fu <leon.huangfu@shopee.com> wrote:
> > Memory cgroup statistics are updated asynchronously with periodic
> > flushing to reduce overhead. The current implementation uses a flush
> > threshold calculated as MEMCG_CHARGE_BATCH * num_online_cpus() for
> > determining when to aggregate per-CPU memory cgroup statistics. On
> > systems with high core counts, this threshold can become very large
> > (e.g., 64 * 256 = 16,384 on a 256-core system), leading to stale
> > statistics when userspace reads memory.stat files.
> >
> > This is particularly problematic for monitoring and management tools
> > that rely on reasonably fresh statistics, as they may observe data
> > that is thousands of updates out of date.
> >
> > Introduce a new write-only file, memory.stat_refresh, that allows
> > userspace to explicitly trigger an immediate flush of memory statistics.
>
> I think it's worth thinking twice when introducing a new file like
> this...
>
> > Writing any value to this file forces a synchronous flush via
> > __mem_cgroup_flush_stats(memcg, true) for the cgroup and all its
> > descendants, ensuring that subsequent reads of memory.stat and
> > memory.numa_stat reflect current data.
> >
> > This approach follows the pattern established by /proc/sys/vm/stat_refresh
> > and memory.peak, where the written value is ignored, keeping the
> > interface simple and consistent with existing kernel APIs.
> >
> > Usage example:
> >   echo 1 > /sys/fs/cgroup/mygroup/memory.stat_refresh
> >   cat /sys/fs/cgroup/mygroup/memory.stat
> >
> > The feature is available in both cgroup v1 and v2 for consistency.
>
> First, I find the motivation by the testcase (not real world) weak when
> considering such an API change (e.g. real world would be confined to
> fewer CPUs or there'd be other "traffic" causing flushes making this a
> non-issue, we don't know here).

Fewer CPUs?

We are going to run kernels on 224/256 cores machines, and the flush threshold
is 16384 on a 256-core machine. That means we will have stale statistics often,
and we will need a way to improve the stats accuracy.

>
> Second, this is open to everyone (non-root) who mkdir's their cgroups.
> Then why not make it the default memory.stat behavior? (Tongue-in-cheek,
> but [*].)
>
> With this change, we admit the implementation (async flushing) and leak
> it to the users which is hard to take back. Why should we continue doing
> any implicit in-kernel flushing afterwards?

If the concern is that we're papering over a suboptimal flush path, I'm happy
to take a closer look. I'll review both the synchronous and asynchronous
flushing paths to see how to improve it.

>
> Next, v1 and v2 haven't been consistent since introduction of v2 (unlike
> some other controllers that share code or even cftypes between v1 and
> v2). So I'd avoid introducing a new file to V1 API.
>
> When looking for analogies, I admittedly like memory.reclaim's
> O_NONBLOCK better (than /proc/sys/vm/stat_refresh). That would be an
> argument for flushing by default mentioned abovee [*]).
>
> Also, this undercuts the hooking of rstat flushing into BPF. I think the
> attempts were given up too early (I read about the verifier vs
> seq_file). Have you tried bypassing bailout from
> __mem_cgroup_flush_stats via trace_memcg_flush_stats?
>

I tried "tp_btf/memcg_flush_stats", but it didn't work:

        10: (85) call css_rstat_flush#80218
        program must be sleepable to call sleepable kfunc css_rstat_flush

The bpf code and the error message are attached at last section.

>
> All in all, I'd like to have more backing data on insufficiency of (all
> the) rstat optimizations before opening explicit flushes like this
> (especially when it's meant to be exposed by BPF already).
>

It's proving non-trivial to capture a persuasive delta. The global worker
already flushes rstat every two seconds (2UL*HZ), so the window where
userspace can observe stale numbers is short.

[...]

Thanks,
Leon

---

#include "vmlinux.h"

#include "bpf_helpers.h"
#include "bpf_tracing.h"

char _license[] SEC("license") = "GPL";

extern void css_rstat_flush(struct cgroup_subsys_state *css) __weak __ksym;

SEC("tp_btf/memcg_flush_stats")
int BPF_PROG(memcg_flush_stats, struct mem_cgroup *memcg, s64 stats_updates, bool force, bool needs_flush)
{
	if (!force || !needs_flush) {
		css_rstat_flush(&memcg->css);
		__bpf_vprintk("memcg_flush_stats: memcg id=%d, stats_updates=%lld, force=%d, needs_flush=%d\n",
					  memcg->id.id, stats_updates, force, needs_flush);
	}
    return 0;
}

---

permission denied:
        0: R1=ctx() R10=fp0
        ; int BPF_PROG(memcg_flush_stats, struct mem_cgroup *memcg, s64 stats_updates, bool force, bool needs_flush) @ memcg.c:13
        0: (79) r6 = *(u64 *)(r1 +24)         ; R1=ctx() R6_w=scalar()
        1: (79) r9 = *(u64 *)(r1 +16)         ; R1=ctx() R9_w=scalar()
        ; if (!force || !needs_flush) { @ memcg.c:15
        2: (15) if r9 == 0x0 goto pc+1        ; R9_w=scalar(umin=1)
        3: (55) if r6 != 0x0 goto pc+27       ; R6_w=0
        4: (b7) r3 = 0                        ; R3_w=0
        ; int BPF_PROG(memcg_flush_stats, struct mem_cgroup *memcg, s64 stats_updates, bool force, bool needs_flush) @ memcg.c:13
        5: (79) r7 = *(u64 *)(r1 +0)
        func 'memcg_flush_stats' arg0 has btf_id 623 type STRUCT 'mem_cgroup'
        6: R1=ctx() R7_w=trusted_ptr_mem_cgroup()
        6: (bf) r2 = r7                       ; R2_w=trusted_ptr_mem_cgroup() R7_w=trusted_ptr_mem_cgroup()
        7: (0f) r2 += r3                      ; R2_w=trusted_ptr_mem_cgroup() R3_w=0
        8: (79) r8 = *(u64 *)(r1 +8)          ; R1=ctx() R8_w=scalar()
        ; css_rstat_flush(&memcg->css); @ memcg.c:16
        9: (bf) r1 = r2                       ; R1_w=trusted_ptr_mem_cgroup() R2_w=trusted_ptr_mem_cgroup()
        10: (85) call css_rstat_flush#80218
        program must be sleepable to call sleepable kfunc css_rstat_flush
        processed 11 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0

