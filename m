Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37D6F606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=p46/uRUt
Received: by kanga.kvack.org (Postfix)
	id 416836B05BA; Wed,  4 Nov 2026 18:32:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C53E6B05BB; Wed,  4 Nov 2026 18:32:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B75F6B05BC; Wed,  4 Nov 2026 18:32:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 001E66B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:32:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BDC88084F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:32:47 +0000 (UTC)
X-FDA: 85399038774.29.FC81771
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 89787100003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:32:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="p46/uRUt";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of kuniyu@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793835165;
	b=bNA3mJO4pAOaGD5DKuoFqtY9k1/hjCSOfroQ+ljfmGjCW/Xsb8JNseOUAlYZdLA6jTOvjM
	Urx2Z1XHbP/UM6244dz8HBBas+GFYHT0aQoNuYn+VtEZz10OhtVIqpIAjhS9tm5BFWGMDT
	cLOkz73MnOnPohXrhumysM8GaJYF/20=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="p46/uRUt";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of kuniyu@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793835165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkjyCgRLiyyLNFM8olRCBV6HjItGRbYCTvwNvN8lDwU=;
	b=60yXCyctOzNZXIDAbTYAeTz3qJ5/CvuZ2MCJmYm1g3Zs2oAMx9X3zi9GPVbH8gL18MMM2W
	2Fv0jpKN1sqvqSc/VXnlevZbrd6Y7Y97ijpXYDV4v572daM5IJorETqtBi9MfbOfBIEms1
	m+faNNqeHj+JQuMUbHfrIh9Yap0ya5g=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-15dd124bbe7so124710c88.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:32:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793835164; cv=none;
        d=google.com; s=arc-20260327;
        b=Iz94KJXIo9sGfVNb7WSZ/Cg2tGr2gHS1J2IGopvAnwxdYR5QejfzlR7uofQlTl3R/W
         BF3OW23x/qA7LGD1wYMsQr5OqE+DgU8ibd4G+3R9J9CNzvovNkiZboykaEg0jo//1T+1
         X25ox+vgK10g0GUH3z4b5NShQ1OUzWy0dbbaOk5MXqt7jqNXLD9Iuacz8hqXd6vrMHXF
         G04IJLLDzB6RQ3KSpO83IByWmXMqreXT6aO1dEqECWVuiOungK1oRVZmafyEbfB/VzaY
         kX2Irgprmtvuj09hCZmITIT7ekJX8DqCupa3rS5qI9/aefoxKWDqv6U7RIAf5TsQVx+G
         BMew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VkjyCgRLiyyLNFM8olRCBV6HjItGRbYCTvwNvN8lDwU=;
        fh=Wqh7ItOILMEy29CN2WdwVNME+GhHXkxtOR8py4EQyaU=;
        b=jUseBRefjvgdH4fEPazF+s4oVJ6kPV6JYanubESW9C1cADx4WAV/5ujlV+4lsktfRE
         sU+N+81ZxeVGN8ixh6gsl1Ni8ut9zCXCJto8OUgbT9Ob5HhAN0PI9f322ojZ9YZYqBDS
         vfgbQQx8v45cR2fzsltYerXSCOn9qqIm/LsfuFKST/Ldv03tdINrowIW6DNb0WCYlVoh
         ZNleuaHUUt0tbwZMqZoIr3iXyg/DyPaivEMrxAwUTdKcfkgJnMsbsi216xdLzujVAZYG
         3Z7FdljEzyh5e9Xh1feWyMPlGeY/zW5VeMgTMOIgZ8GuzHaC8bQT8m2G7mczVujSpIIF
         3izQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793835164; x=1794439964; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VkjyCgRLiyyLNFM8olRCBV6HjItGRbYCTvwNvN8lDwU=;
        b=p46/uRUttWiGIO9zvYb0ibP8GrELnyTQ3c+FmhCE9moOiZl4uzNeITf+G2/2VQuC3O
         1rZidH8B0yDVNE9in5ORwt5jPB5w4HiAz80nM2vC1juVxv7aCXauWWGaG0TCcOUi1XtY
         ttLBgTuFOgfG47gm+C2we74LvUpRuKIZ82Am04dY8tvvgXj68H/ZT5Wb+7TU/S5xEmSh
         PSL9zqJhu3uAh89irO1qtf8rM+jBQNs50vQq3WEr2gfloxRpxr+exgZ6NiF7X7XnoaNO
         YGx5quMi+b8ruuJ6A/L6fEd0dXDM+wB9uO0CDjYU3PX6ZyimKqRL/5qMbxghbvCqbdnR
         MnOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835164; x=1794439964;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VkjyCgRLiyyLNFM8olRCBV6HjItGRbYCTvwNvN8lDwU=;
        b=t+irbtY4TquNWOWnzhPvSrxRBeVgE7yQ8lhkj8t7HmzA8+VZ10nL7YeXN8S0rx1oYa
         9LuGa96l5qvx83KI4+6hpKsyKpqwSxB7kFQAfOHmvjP2zksXLLerZq3zirnzCc6xpYnY
         K5+C5DYLZuJYgMCvoH0j48yvtHaZr2vVWVAKqwY+MqihrlOIT8nlz8OM5hQs1LBihLqf
         +wlPvyTc7VpdVh0c9fCYmbEbJ23grcO0w+auVzcRnZzf2IuASPtc9aNmNUO9oZq/Q8uf
         Vh5Ujowcaq/yo2vmcMnP4YZmxgjDqUUIuP6vY7GQnka2eFR6/Qlzqlf3WH43OjaoH/XT
         JiKw==
X-Forwarded-Encrypted: i=1; AKwUvBwmVwoz+3U+lxWSKFJNTLZbLtUH5deYV+QQdgvSSFTcsuIDCcUGyhj6Lfg2caWN9/KhPGgy75gGUQ==@kvack.org
X-Gm-Message-State: APuU4Z/PelhkwkzL/9n3yWYCXazo2eNiibCLGGh09gQ3BtDvowHJThmB
	0BjTtqjgb/EYY3kXsbYBk7184RulNEBi28YSywoeM9sG4SPOQKpt4UYSY3a6DjOeSPK8vLsUXoJ
	EMwdOVGlIV4seWRpGXJ1mjC08qQInX1k58i/p+lyQ
X-Gm-Gg: AYBFou1s1dwCQrStnyA5exzS52ZGaR0kx1i1ZQ8gsvUxouf78RVB/P7ffubLrh6nPHS
	WXTu5j8cjijzNBha8QYpbR+g9E9e0h10/277m++pocr2dDUK3qpqttvPOatBR741xQQ7a3cqOqT
	5NVn570gh4EPzJ6eqMaNBsjgb5CaYloV6a0VCuTSziBntbJ/HE62uZ2USLlJBzDg1GWRsShOSf+
	/nUbEf2VyYsxD0S+s9NZvmd57Ru2T7p8i6ba4+T++ei/crl5uE9BwLbjDF/aXMcUVRaaoUtjhGW
	cc+/OC9v0XV2E9SEwj4wENC1oxChxBtyU3tbu2LCcUZ/rcRECdthml3JLoAe5DnfYszvHlZzUYK
	QBDUoASxMLQzcVGvQgL+9aoy0SzbImpyuzsv5tbmz4uwtq1fvp2rnIxNbxXK6uf/GZ0P/nrpXtK
	jMyV6EnSbU4n9nzgh4BCXuoJN2Z0Iqpkz43z1pXRllaXCG1P6lSzm9Ygqo1XIyQR5rKAKE9WcS5
	2+QmTBehg==
X-Received: by 2002:a05:701b:454f:20b0:167:d73a:e994 with SMTP id
 a92af1059eb24-1ac5ac4f0b9mr27337873c88.24.1793835162463; Wed, 04 Nov 2026
 15:32:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261029194452.3189365-1-kuniyu@google.com> <20261104150258.56cf6be2efe442cdf5ff8da1@linux-foundation.org>
In-Reply-To: <20261104150258.56cf6be2efe442cdf5ff8da1@linux-foundation.org>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 4 Nov 2026 15:32:31 -0800
X-Gm-Features: AclHuK8qPYiofzotxpZJ9SgyNdpa7WFtAeKrxFZ9YkpLUqaZkq8IFOxN9qosUfM
Message-ID: <CAAVpQUApRZ=Mhm0pmZ1EEvAr=87d7pEsz-uMzjqneeMzC6EJQA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] memcg: Misc cleanup and perf improvement for TCP.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: s7huitju6xbi9b65daye5nidgrop3xc1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 89787100003
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793835165-195364
X-HE-Meta: U2FsdGVkX1+7f3ZPerkQgZCgusuE9RlB5pP2/0aEWTW17cwyUYNYjy+M14R2nOPCKMHNt2qiS9JTtHwE5zzOc3vBHBKd8dFGGHLLO+R/texSdhZIsTZZPiWGIFETyww0Wsksn/wqD0aTJGYUm0t0ocUvsZETQlw6jsctUhHSDgBLWVqFRUcCqHWzLfOLdthlNSPhO6MBlsb5yiniBN+eqrZ0KB2TPI00cxgjv/wKF6/FZaIqi5bSA597fIzRMRCp7y9YNxZE61qjrl49SuT7jHfhDOp7p50M5/GiaQzjFNIhUcpikydCizLpLA3THF3OhXrqLri0df/VJxGOf4XTB85UZLlzujM3NMawwbbZ7R35wvklHMhm6eaP1X8P/ReD0yWo/vb5w2L3itGmvy5YS5/VElwxil7eSkO5FU/mVIIpkVCbNdZIdLgl0iY5QGZu4kIaRtSUyzAedH6I9mzGKBLZff7FR1iCiU+L209nMhZooe0qCyi+QadFbwweafFwetC0+XMY7EEiZiykfhtN9oSNto5K42tbfnXnHAyKLHDQWy8/bu9N+aAeOyT3/nH2B1DtPDwdMX/Y6OlxNEojXDciBLaICWttD83vBKovjmZOx34T1eu5N6Ol+NUddWo8hvwQQdkCdYmazmbqOeTK7Y7gYRe29kq5Qlad6+cvYQja+EUz3PFOXccZr1fwgkYaCAmkSpLRmDPvNwXAvQmL24gmQ3VCNsCQYPapvQsXw4b4jw9QWIfo4hYUm59aNGp9U2zcKO7QOHeW8PUpCZTJr3ZNb+EHxFr+Kksp/5AoEQ0+4kppt704Cuo7hW8AxkNXnUXeHuK2ZuKy9Jf3MgVRSU/NO9/O3xZ61NUuRthxSNAIsR6eRKn+pIp0RCUDkxO6RUfaNsYxj9iKSx/UQyILLEM0j/AQGnncZOsDb5Ir6Qu07pqiGfskpO3jOLjUyVC69Q0LHHNOjGs3qwkctyW
 WYk/rKBn
 p2pUyM3XK9hbRU6uO/GR1HWnl5p/gBbHqMjwNBtoK9X+TzjFRbJ7yhB7Y1HAYHtapHAcruY7VF+1s2l/6Uwbn9R/yisJxMuBGjNzgkX6HuyyZmorqvllyoPUnnRrY7L1i9h/4sTZule+RXnPD3Alik57WaYO0yub7oIVbL8MPvJMnmJKeths+V/CPgRHl7cihnE8s6Mw7hyfBT/j00qXV6Xv9KrhsnfawEZNAJrywYzg/moHr2fmFx03qb0ArmSuUDF7QlWWbxupEiqO7g+wKjc3OKi3hhXXL3l0JwxHF7Q61RCeJX1AfQghF7APfknBMKTjx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 3:03=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu, 29 Oct 2026 19:44:11 +0000 Kuniyuki Iwashima <kuniyu@google.com> =
wrote:
>
> > On host w/ AMD EPYC 9B45 128-Core Processor (Zen 5 Turin,
> > 2 sockets, 512 vCPUs), tcp_rr w/ 20000 flows throughput often
> > degrades by ~50%, 32M -> 17M~27M.
> >
> > In the bad case, the number of involuntary context switches
> > was extremely high by 12x (241733 -> 3093367).
> >
> > The root cause was that refill_stock() calls memcg_uncharge()
> > or drain_stock() while holding memcg_stock.lock.
> >
> > Patch 1~3 are misc cleanup for better asm output and patch 4
> > moves heavy operations to out of local_lock(&memcg_stock.lock).
> >
> > This series removes the flakiness and gives ~3% gain on the
> > 512 vCPU platform.
> >
> > In addition, on machine w/ AMD EPYC 7B12 64-Core Processor
> > (Zen 2 Rome, 2 sockets, 256 vCPU), tcp_rr w/ 10000 flows achieves
> > 36% more throughput with lower latency.
> >
> >   tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):
> >
> >   Metric                     |       Baseline |    Patched |    Diff
> >   ---------------------------+----------------+------------+--------
> >   Throughput (RPS)           |     20,884,499 | 28,453,051 | +36.24%
> >   Latency Mean (us)          |         478.46 |     351.07 | -26.63%
> >   Latency p50 (us)           |         453.96 |     343.04 | -24.43%
> >   Latency p90 (us)           |         669.00 |     479.57 | -28.32%
> >   Latency p99 (us)           |         969.38 |     593.92 | -38.73%
>
> Thanks, that all checks out here.  I fed the series into my
> LLM-controlled live kernel testing setup.  tl;dr: no correctness issues
> but the performance gains on this setup are much more humble.

Thanks for testing, I think the number depends on the CPU
generation and the number of CPUs and NIC queues.

The last number is from Zen 2 CPUs with 32 RX queues, and
the result was consistent, while on Zen 5 CPUs, the final gain
(+ no flakiness) was 3~4% as noted above.


>
> Gory details for the morbidly interested:
>
>
> : I tested all four patches before/after on Linux 7.4.0-rc1.
> :
> : Correctness testing used a four-vCPU, 8 GiB Debian QEMU/KVM guest
> : with KASAN and lockdep. Both kernels passed all 22 memcg/kmem
> : selftests, cgroup/socket churn, guest CPU hotplug, socket lifetime
> : across migration/cgroup removal, and payload-checked TCP transfers
> : under memory pressure. Final socket charges and dying descendants
> : reached zero, with no unexpected kernel diagnostics. Traces confirmed
> : stock trimming, eviction and fallback coverage.
> :
> : Performance testing used 56 guest vCPUs pinned individually to 56
> : physical cores of a 64-core Threadripper 3995WX, with 32 GiB and
> : KASAN/lockdep disabled. Host and guest each had one socket/NUMA node;
> : the guest exposed one thread per core. Neper used 10,000 flows and
> : one-byte requests/responses. All 24 runs completed: three 60-second
> : runs per kernel/condition, with alternating A/B boot blocks.
> :
> : Median throughput changes for the full series:
> :
> :     Workers per endpoint     RPS off     RPS on
> :                       28      +1.21%     +1.38%
> :                      128      +0.14%     +0.72%
> :
> : The smaller machine likely explains much of the difference from your
> : 36% gain. Your reported systems have two sockets and 256/512 vCPUs.
> : Here each endpoint had just 28 vCPUs backed by 28 physical cores;
> : 128 workers oversubscribed those CPUs rather than adding parallelism.
> : There was no physical inter-socket traffic. These differences can
> : reduce shared-counter contention and the lock-held interval behind
> : the RPS/charge-fallback/ksoftirqd amplification you described. I
> : exercised stock and RPS paths, but did not reproduce your collapse
> : or establish comparable amplification. This explanation is plausible,
> : not demonstrated by the measurements.
> :
> : Three conditions consistently favored B; 128 workers/RPS-off was
> : essentially tied. Frequency was uncontrolled, limiting sub-percent
> : claims. Both kernels had VM CPU-feature/watchdog diagnostics without
> : an unstable-clock message, and softnet drops with RPS off.

FWIW, I tested it with RFS and on non-VM.

