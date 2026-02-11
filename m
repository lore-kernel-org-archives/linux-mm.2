Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4470ECD6D6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 23:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12256B0005; Wed, 11 Feb 2026 18:15:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8D56B0089; Wed, 11 Feb 2026 18:15:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7FE6B008A; Wed, 11 Feb 2026 18:15:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89FE36B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:15:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BDA36C1F6F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:15:13 +0000 (UTC)
X-FDA: 84433733706.08.8448D4A
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id AE767A0008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:15:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KzzZFM5N;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=shy828301@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770851711; a=rsa-sha256;
	cv=pass;
	b=UiyP24lUcQMBBSRem6Xf6ec39TB0SFIQyDRTFXatPZIx6cpNZT4WABZyFyqWUjYFfU91qd
	TsaZPiiY3f6F925kCuxKakJUWvrvUa9ZVGq9QhST3hpq4yW8exvYBltK/ZfC+DtNh5oHJs
	ezH2c3cUNVeTePQT6rwtk9q43OlTFXQ=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KzzZFM5N;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=shy828301@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770851711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xKKRlCrmtvFwI88hY4WIqSlHXfMV0165I6waG2fSmDE=;
	b=Aotdzn03mjSmQpmb5rA6i7tRyNgkL2PdwZTym65VRgqwd4kJqzqwDLIi7b/lf5Puq5n2dI
	CSY0Df7JKdeg2RvFWYUQqzjgY8R1lsO7qOTjmg3M8u8rKCVcGK0ICQKeC6hR8HTCIXpxlR
	D90OVIVdOpZRrbR8MZrwN/1qzeqzlN8=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-65a36583ef9so2571803a12.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:15:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770851710; cv=none;
        d=google.com; s=arc-20240605;
        b=VMbJ5oAkvWc0Tlgt43UCwV2S9MP9rOe8li6OAPVzc4wV/y/R0F7kVLtNEaj1ISpygs
         YxTgzVo1hPlWxMaQN7CKdtnT39tgHjZxtUjjPrJTIzwKdymmtATAhHZHFa3JnBIHAJa5
         mGk+1e+4of4w3jtuc2Fs0JKJ3iStsojB8GX8oiFullrBfKmFhCcm19K+/M22JrG4ck9z
         V5tfX8HNRQUnVNNTnUiBJT8YNYPCgAXpx5++e4FogjhHm51wBzljmGWxBc+jBRpG3lwm
         nQ53YXWxTv5aZY4/YiMkkR8VQBu61qUlrxXq6uPzoeJBSmywHJ4effUVLs7bfs9yF6i1
         00mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=xKKRlCrmtvFwI88hY4WIqSlHXfMV0165I6waG2fSmDE=;
        fh=zk6wMhpxJKCvBWriYPVEbryJvrbLmHqF2/6bbLo1pDU=;
        b=S/okRqi0No0voxMsKpzh5TZdv7q5gFgEyL1j1nDtZkcrViL6QY9+/fTjPsUdW2JBws
         Xy/mCjIPSJgdpv3l8okdEIsgfZJe6YlufMdyGT3xo+i7n5h6cB/zTqd/I45tMGLraWpa
         Wu+7oJBOr5ggSRejd4CmynJpSlxlgBEeFlU49/I/9+Jzuaye+tXyA2IoOyxUC27WSpuV
         dgMUcJ5VGV/oxAVXC2638RRyI5GbMoHGBsQrjva+olTD7PrC5siGzdykc9KSLf1loChd
         Gf6TZUkmL4droMoUq9FT7CB/nCAXZezQTaLRSDtJCdgCPK63UUFr/BQUSx3lfNA2SH0m
         CsXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770851710; x=1771456510; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xKKRlCrmtvFwI88hY4WIqSlHXfMV0165I6waG2fSmDE=;
        b=KzzZFM5ND0JNF641fFFnMVqFX6iaQbfyJu+B8sP8xX/A5ZtMHBQWpu5v0sxgHnKuPP
         5/Gi9nCMUoIqEouo3D7Z5txbCkXWUO2B3F4PxnXzFB9YnHpNtKMUVskGYGDIidL4g+55
         OQrE3WWerCRznVnN1WwMd+/PBWquOlPg10kRlFzSNd/RTNA6XVKVALjg409ira8jvgMw
         jBLIJUWE8dmicPCpGpRwFStH3Ixct5mudbKz18qOSjewAtzGTZVs5ku5opJeN6becmQE
         8wWwWOt3Alp7bpaBTuDRjbshDKMTXiZH8x25ShNoPMf3rBAMPLJOVKIRvSR1mm57dTkB
         DSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770851710; x=1771456510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xKKRlCrmtvFwI88hY4WIqSlHXfMV0165I6waG2fSmDE=;
        b=bgfaRnFEY59Axy3BC0gJu1Qwoc2ad7dqXWaQFXAgg2upDs39KZhfzC52TRZgWS6I2b
         HnreFyYwpDQZmnHqEg5KJi0CksLFJCRLUM3obU25HyAtEY3at2ywTiJZeIDgLVz2PDaV
         7mKNZ+jbx9cTGdDmlhETVs/MJp11mH4LT/CtNC4D3t4/nrScc80vhXTJ7edoU6Vsn9hD
         G2Vz3Tv7U2uW42DNJWuOT81+8JtyiRWJajIHtED2Wsb5haIZbNvs/KUII9IM+hLfzNT7
         fcGx7W7kM55bmnWVijPypY7ydav+PiDbIa9R38Puxa16LzRisR4J3ktFcGWml7w+7Gmi
         8njw==
X-Forwarded-Encrypted: i=1; AJvYcCWHKcxJEtpCXtyLwaMnqBPz041EaCRa3t5yxdDD2YLfosfF0BeoF+yHwbG/CntLclXEmHOZAz4s9A==@kvack.org
X-Gm-Message-State: AOJu0YxYr7IRKSG6Iz1lutyLg5QDS0ZUjMmeIHRTf04L/vGdptqhwIMJ
	jMkzLYG35Hrn7hlAeHmjTPtB0RXzwj146RT2o4H4iNenzBrMOTIl/ZlZ7nZBis+dX0uDLXVJKk8
	zih0dPGowHmDDq+1zuQ/8b3D/dmzXZMA=
X-Gm-Gg: AZuq6aKNqcW+3+bDJOsgPzF9e34YNDQ/EFN6WNvXhOJMwzkSgDdgl8LGQVho2kdtiBq
	riPi6C0MpChQVORKDYwvir98ye/tdUTh2Eegdy4UFBKxaKnEdPB+WRYGVWHhfwv0s75YKIzriyh
	Ug7FZ2gKxQR7PamoczhEhycfj3AOo3BRdQaBE5xSUKNllhMdZxGmjUy0/Y5kkZk3VFeSDp25Ujz
	mMvu0tUrZHR3ItCt9QGZRMIMI7LpZ/6GwYHOXShcqXhDA7amvuk4/ndMggB87Qs0WuJn5j3L7Wi
	kCc6b2/t7Q==
X-Received: by 2002:a05:6402:4494:b0:658:ecd:3787 with SMTP id
 4fb4d7f45d1cf-65b9b90c8abmr257840a12.6.1770851709756; Wed, 11 Feb 2026
 15:15:09 -0800 (PST)
MIME-Version: 1.0
From: Yang Shi <shy828301@gmail.com>
Date: Wed, 11 Feb 2026 15:14:57 -0800
X-Gm-Features: AZwV_QjKtzZ7EKADjV0Km4eVa1wH3_Q223RhY_d7w2LH2asH2VfD0bZ1-9PfvTM
Message-ID: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
Subject: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64 (and
 potentially other architectures)
To: lsf-pc@lists.linux-foundation.org, Linux MM <linux-mm@kvack.org>, 
	"Christoph Lameter (Ampere)" <cl@gentwo.org>, dennis@kernel.org, Tejun Heo <tj@kernel.org>, urezki@gmail.com, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>, Yang Shi <shy828301@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AE767A0008
X-Stat-Signature: etxdcshqaz3jnz63uk6uf19jxzaqqmcq
X-HE-Tag: 1770851711-387503
X-HE-Meta: U2FsdGVkX1/D9K/lKGHM9Qcu/TSkR5mFujXVYLQL7jFcGFs+olnK3atEY+nc3mJqWBbMs+L+O5oWGmTZfyjEnGMS7T+96k/HynsxczrLKIi5Z18NvwdTgcwwaTlUsBFCjddhIVAtYGfsXAFn5ScZtMZ1XIeivTuQCtQGqa5fWiwtBLqGBdhX9kmTmzM9Cz0ZHuXLvSqMydYSIWA6KBWJpMPt1q3YtXDt6NnA1+hXhedDU1+U8fqRHlu+mwLW5SMk2/gacW+1uJDrTyN9tkWj1kQe27vXNWdKNWoo9lXZ7acvue0uuQd02GGNewZiutgGg571Qans91ErqtqT6n2udblLVBdH662TmRAqyX7Zqlzjq6hyxdR5MVALqNrFPeELeTIyRpLx/ipg0rF9DvYIl4BiQRPDFLSl6HdWSM7OqaQ6gy2nWY4jnBSr8IDhWO+kDhTdEwz/XGhEJ078N3xjO4qZJv8TRChUKvhnAanqw79b9MpmpBIgEugIrjLSFinElAjr1M43POk5eOfNREaZ0eJ+EGJ0yTAQgvINraFeHo7U9wFOByyu2Fp1XMMaqw3cqhl33bvCIy2tYKTpWfTWFGF4Ll5pHLFxyWF5FbfuwhrjMq2vSgVvgX1X6Xb7F2rnYQ4shev7U71jXxhpZ4z+zk7tQY0JbY2KDorGN5wtdmTtWh02iw6BLzqzG3NoNGZBHQJDD3d2kp2rX6+bT9SOQKu6CEkF/0GsX9nncPG6atqH4JGaeCsSEf+4ZW4wyA7cPwJ2NHAtvByZ7KrOvQhhODQhTKkXkHNWUdTBeEySPKDreo/MYJvg+WObsXFXeibAAhcYPCknSF0m8z0qvqHVQ+QbVqlEghjIFyGtUbBxaGS3YXbzM0hXDbg9jAVuFKJ3r3kcPjWkm+BNXlEb+6Q+xQ5nN/7c3BqpaJXvmjFkX6PgaP9CG0O5RUZQHzGD8v1ZGf0CGY9wgrRyqzIHAEt
 BHYYBQOG
 z7d7pF0qrRCE6pks0F3Fcn60D8pV5pkCZC8QGEvcocUyTF2j6TwJoCrYz33LoLlwcBec7/2WUQRVXI7dv7nHKCkkk0iw49PLzTHUkOWmhBazb+PSf2qzpbLky5AHap/ZnnRXWdqPdZNYWhRoaGrnjK5CLyKGeFXn/qf86K3K1n+GQnbOlldNHTyVpwAeN4mYPK9/CDqJHcQ09aXeKszHLFFGpsNLwb8VSs4oFC6YuMNErp/Llv373u7/LcksmYsbZRw9AsAtHbNurYLVDIDeppVOIBN7b0WBd84QHIIwpkbAga/yxNKLEF8qMylVdynAaWOHhs4raDEY9AciZB40jelMBMWgZIP2m53u2e2LeigSYGMPa2ETRmmqEcN0h8wRv2qk3Q3lNrWUMn/hdLyAqZJI+8ECAjSaGZEsVVTiKE2Hrvl0IEqCOpE8IYHC+XYbhMIFA53prrpk6PSgnDB2JYwwtsmrMckLbfO+ZdmdGM3maGV9WP7xXMp1LpsUmMvtUpwBzFeM43ijlWcWV8Wh/PX7fEu08X0+Q+cfbF1vKyPuWxh+PNpshNpKdTjPDCJR/S/EnCsPslqV8oi7FupSLQ/q+hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Background
=3D=3D=3D=3D=3D=3D=3D=3D=3D
The APIs using this_cpu_*() operate on a local copy of a percpu
variable for the current processor. In order to obtain the address of
this cpu specific variable a cpu specific offset has to be added to
the address.
On x86 this address calculation can be created by prefixing an
instruction with a segment register. x86 can increment a percpu
counter with a single instruction. Since the address calculation and
the RMV operation occurs within one instruction it is atomic vs the
scheduler. So no preemption is needed.
f.e
INC %gs:[my_counter]
See https://www.kernel.org/doc/Documentation/this_cpu_ops.txt for more deta=
ils.

ARM64 and some other non-x86 architectures don't have a segment
register. The address of the current percpu variable has to be
calculated and then that address can be used for an operation on
percpu data. This process must be atomic vs the scheduler. Therefore,
it is necessary to disable preemption, perform the address calculation
and then the increment operation. The cpu specific offset is in a MSR
that also needs to be accessed on ARM64. The code flow looks like:
    Disable preemption
    Calculate the current CPU copy address by using the offset
    Manipulate the counter
    Enable preemption

This process is inefficient relative to x86 and has to be repeated for
every access to per cpu data.
ARM64 has an increment instruction but this increment does not allow
the use of a base register or a segment register like on x86. So an
address calculation is always necessary even if the atomic instruction
is used.
A page table allows us to do remapping of addresses. So if the atomic
instruction would be using a virtual address and the page tables for
the local processor would map this area to the local per cpu data then
we can also create a single instruction on ARM64 (hopefully for some
other non-x86 architectures too) and be as efficient as x86 is.

So, the code flow should just become:
INC VIRTUAL_BASE + percpu_variable_offset

In order to do that we need to have the same virtual address mapped
differently for each processor. This means we need different page
tables for each processor. These page tables
can map almost all of the address space in the same way. The only area
that will be special is the area starting at VIRTUAL_BASE.

In addition, the percpu counters also can be accessed from other CPUs
by using per_cpu_ptr() APIs. This is usually used by counters
initialization code. For example,
for_each_possible_cpu(cpu) {
    p =3D per_cpu_ptr(ptr, cpu);
    initialize(p);
}

Percpu allocator
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
When calling alloc_percpu(), kernel allocates contiguous virtual
memory area from vmalloc area. It is called =E2=80=9Cchunk=E2=80=9D. The ch=
unk looks
like:
| CPU 0 | CPU 1 | =E2=80=A6=E2=80=A6 | CPU n|

The size of the chunk is the percpu_unit_size * nr_cpus. Then kernel
maps them to physical memory. It returns an offset.

Design
=3D=3D=3D=3D=3D=3D
To improve the performance for this_cpu_ops on ARM64 and potentially
some other non-x86 architectures, I and Christopher Lameter proposed
the below solution.

To remove the preemption disable/enable, we need to guarantee
this_cpu_*() APIs actually convert the offset returned by
alloc_percpu() to a pointer which should be the same on all CPUs. But
it should not break per_cpu_ptr() APIs usecase either.
To achieve this, we need to modify the percpu allocator to allocate
extra virtual memory other than the virtual memory area shown in the
above diagram. The size of the extra allocation is percpu_unit_size.
this_cpu_*() APIs will convert the offset returned by alloc_percpu()
to a pointer to this area. It is the same for all CPUs. I call the
extra allocated area =E2=80=9Clocal mapping=E2=80=9D and the original area =
=E2=80=9Cglobal
mapping=E2=80=9D in order to simplify the discussion. So the percpu chunk w=
ill
look like:
| CPU 0 | CPU 1 | =E2=80=A6=E2=80=A6 | CPU n| xxxxxxxxx | CPU |
           Global mapping                                     local mapping

this_cpu_*() APIs will just access the local mapping, per_cpu_ptr()
APIs continue to use the global mapping.

The local mapping requires mapping to different physical memory
(shared physical memory mapped by global mapping, no need to allocate
extra physical memory) on different CPUs in order to manipulate the
right copy. This can be achieved by using the percpu page table in
arch-dependent code. Each CPU just sees its own kernel page table copy
instead of sharing one single kernel page table. However the most
contents of the page tables can be shared except the area for percpu
local mapping. So they basically can share PUD/PMD/PTE except PGD.

The kernel also maintains a base address for global mapping in order
to convert the offset returned by alloc_percpu() to the correct
pointer. The local mapping also needs a base address, and the offset
between local mapping base address and allocated local mapping area
must be the same with the offset returned by alloc_percpu(). So the
local mapping has to happen in a specific address range. This may need
a dedicated percpu local mapping area which can=E2=80=99t be used by vmallo=
c()
in order to avoid conflicts.

I have done some PoC on ARM64. Hopefully I can post them to the
mailing list to ease the discussion before the conference.

Overhead
=3D=3D=3D=3D=3D=3D=3D=3D
1. Some extra virtual memory space. But it shouldn=E2=80=99t be too much. I
saw 960K with Fedora default kernel config. Given terabytes virtual
memory space on 64 bit machine, 960K is negligible.
2. Some extra physical memory for percpu kernel page table. 4K *
(nr_cpus =E2=80=93 1) for PGD pages, plus the page tables used by percpu lo=
cal
mapping area. A couple of megabytes with Fedora default kernel config
on AmpereOne with 160 cores.
3. Percpu allocation and free will be slower due to extra virtual
memory allocation and page table manipulation. However, percpu is
allocated by chunk. One chunk typically holds a lot percpu variables.
So the slowdown should be negligible. The test result below also
proved it.

Performance Test
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
I have done a PoC on ARM64. So all the tests were run on AmpereOne
with 160 cores.
1. Kernel build
--------------------
Run kernel build (make -j160) with default Fedora kernel config in a memcg.
Roughly 13% - 15% systime improvement for my kernel build workload.

2. stress-ng
----------------
stress-ng --vm 160 --vm-bytes 128M --vm-ops 100000000
6% improvement for systime

3. vm-scalability
----------------------
Single digit (0 =E2=80=93 8%) improvement for systime for some vm-scalabili=
ty test cases

4. will-it-scale
------------------
3% - 8% improvement for pagefault cases from will-it-scale
And profiling to page_fault3_processes from will-it-scale also shows
the reduction in percpu counters manipulation (perf diff output):
5.91%     -1.82%  [kernel.kallsyms]        [k] mod_memcg_lruvec_state
2.84%     -1.30%  [kernel.kallsyms]        [k] percpu_counter_add_batch

Regression Test
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Create 10K cgroups.
Creating cgroups need to call percpu allocators multiple times. For
example, creating one memcg needs to allocate percpu refcnt, rstat and
objcg percpu refcnt.

It consumed 2112K more virtual memory for percpu local mapping. A few
more megabytes consumed by percpu page table to map local mapping. The
memory consumption depends on the number of CPUs.

Execution time is basically the same. No noticeable regression is
found. The profiling shows (perf diff):
0.35%     -0.33%  [kernel.kallsyms]                               [k]
percpu_ref_get_many
0.61%     -0.30%  [kernel.kallsyms]                               [k]
percpu_counter_add_batch
0.34%     +0.02%  [kernel.kallsyms]                               [k]
pcpu_alloc_noprof
0.00%     +0.05%  [kernel.kallsyms]                               [k]
free_percpu.part.0
The gain from manipulating percpu counters outweigh the slowdown from
percpu allocation and free. There is even a little bit of net gain.

Future usecases
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Some potential usecases may be unlocked by percpu page table, for
example, kernel text replication, off the top of my head. Anyway this
is not the main point for this proposal.

Key attendees
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
This work will incur changes to percpu allocator, vmalloc (just need
to add a new interface to take pgdir pointer as an argument) and arch
dependent code (percpu page table implementation is arch-dependent).
So the percpu allocator maintainers, vmalloc maintainers and arch
experts (for example, ARM64) should be key attendees. I don't know who
can attend so I just list all of them.

Christopher Lameter (co-presenter and percpu allocator maintainer)
Dennis Zhou/Tejun Heo (percpu allocator maintainer)
Uladzislau Rezki (vmalloc maintainer)
Catalin Marinas/Will Deacon/Ryan Roberts (ARM64 memory management)

Thanks,
Yang

