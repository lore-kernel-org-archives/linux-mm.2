Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 946DACD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 01:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2CD6B0005; Wed, 10 Jun 2026 21:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73696B0088; Wed, 10 Jun 2026 21:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89D86B008C; Wed, 10 Jun 2026 21:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 976A36B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:36:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45AFF1C11EF
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:36:58 +0000 (UTC)
X-FDA: 84865918116.26.BC0576B
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id C97904000E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:36:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=abgBlKoZ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781141816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMIRrh+qQia1RzMW2pfyqYI6BiXhyEOuqFiFA/0GGvE=;
	b=VUwtn1gy9QTlMiEn7Sxkdj5te76r/hQiiXEaA9ELkyQ+n3173+ItLZL1rMY9K8j5wW05F6
	TIcJsKbNAGjHSXdQgEEnqkveKpvKJTlRhkysg5xajy5FYaCiXwF9IdQG+5mrbH0I/eti++
	XAt3JEl+JnRj4iEVZbbWoM85tiVILkQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=abgBlKoZ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781141816;
	b=NZJxMSIyNkV2Xw6mPXnMb9pIbWHfRWz9sUtjHRcq/C9YCaVDadJJIC9vaAXfOaxKlkT9+4
	puaEwugNdNtTDOFf9grWn29wCi5fbdx0fWWnl9gSOaPcvsSzOKlgrQTi9N8LdeIUHtFMwj
	TGsuk4eXrMRD0jZJjzOFsnoiAizV+ps=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781141811; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=oMIRrh+qQia1RzMW2pfyqYI6BiXhyEOuqFiFA/0GGvE=;
	b=abgBlKoZXpn+uMTKhLQc6twVFyhKwA5DjTq2gdk3KpcLIyt4p90grDFeQdHwjM34sr/rZBmyFexNXGrodbgHEBgt0WW+0FG8ybPf9dy3ClU+07T0SfK1S5lzEC9NCtBP1H9AxYPlDezbctll4Gi2cGzqhyr4s3AuVQoIpDWSkFs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X4c2kGc_1781141809;
Received: from 30.120.38.205(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4c2kGc_1781141809 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Jun 2026 09:36:50 +0800
Message-ID: <7b05bd27-2152-40c7-a777-390ded5defd9@linux.alibaba.com>
Date: Thu, 11 Jun 2026 09:36:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm: memfd with write notifications
To: Mattias Nissler <mnissler@meta.com>, linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, mattias.nissler@gmail.com,
 "david@kernel.org >> David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20260603125521.1468362-1-mnissler@meta.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260603125521.1468362-1-mnissler@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C97904000E
X-Stat-Signature: at85s16nrh6pybk3yzxhnkz98qi84ouz
X-Rspam-User: 
X-HE-Tag: 1781141814-136659
X-HE-Meta: U2FsdGVkX1/MrooY7P6iy2KEV4tIykIn4Ckn7rSWIntrkepJSPQgCNmI//65PcqD4ejTdmYjqiXBBgdqBGbWQtugz7WT+8a5gLvtJJLSqp5GixDevnxFQMqHIJiXqkC053ZBU/rcidE50FJYa909KfUcPGkh9eTPbmC5YWhKQmujH/g2olHOWap/4FLVo9kMH2OrTUs9eK4AKbuLowwFnNrr4xTc3xwF/nn4WIRaA8Q4yY4zSpdclBL6Pze3gSGiWEL5fYU+jTcVdNYJ94FoEs/BEHLGCplY/hxwouy0sOhsq4UyXRy7w0Kvxj2EaSUho2waTUu7qM5MX9G1ENGxGYLMHZlcLEHZaw67DOGEFQ9HYD5zacGr7lIpvCGedOnxBLTZyPLC+2ZqiKVn4pzhkcXJXRSJff3UNZ/YxGFyuQJtE1QF7oVJbcy4lK/Mvi4JGaAerSQiimTfvhP5gRwuOGjONgl5D6SY62eE3d8vw/lU0SQ9DTz7HMqvv/0X7WelBJdyumWCNfQTVqpuZDOm/O+UVoUPjrYT3QPIn9C+7cALGWQ3EDyKEuNYxZI8O+X4/cOWoRwcJYk6JJNqVPvkQNOI5skE2/9uRMLLJF692MHJroMwL/BgTl5vywybx8spQm48siiuf+BDR8T0XMBywliWeEa08iSh2fp1KCED1poXFPGY2fBAu+HcKfMPI+9BFpO2GK9zzIn+FQkk1konceit8sNr06at94Hg38mh2up+T4WoY3gTMcw7+vrh14FHft2dU1bAgnP8wVo8ed68+Yczrykbt9h0U+mPqP1bB2ZrYTI/Wk6gDajfQE4/79fUz01fQGPRV5G8HlLXdWMisjMsfqDvM5mK07HI9sE/51Z9nNizgS86HxmN3wgxKO1sXbMgccd1xhl0skyGXfMLWGyNMyMiB6siSUt71tc/lKr7FdP7cKh2jibhv9nIeyrQngv/uHsi4yb6Uyd3z94
 KCvA0ehv
 UuFR5z+z2fGuh74DMzVnu2Errtb82ZERJ9mos4MdbYHCkooNcezN3F/9nXqjYZyuwFZptG28Dhv5X1RQkpHP0rZzA5LrORJh8gUenKwhwPcxtgErF6BER3I2JDyyvkLN7CTyPGNHO7p0dEnxGe/5tsc+iZPRdJbBhJe0O9tezRWHGri/EB7dsIrXUk7OQvzXlDaRA6qisARsD2U/+oodpLoyVHpDX+v4cpzCHcbMidv6pWzYa7b3KHvZntSg15DOYztqJvW7izkoaw9ZhGE1oIpaCtrSLMMQfnuVcUDtzrlSZ4tSiNU6aFTlcpBSLBT2CCvfyXkp6ez8hZ6XngNOSwTsU3xFtM+NYgLG0qIkalkPtA9zyhGochx8hQsAKMQ5Y9A+HaVpcJY0TDZP6k+pxymr0h/1AnovdOUjN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add more MM core maintainers.

On 6/3/26 8:55 PM, Mattias Nissler wrote:
> I want to propose a kernel facility to have user space create memory
> regions that can generate notifications on write access. This is useful
> as a cross-process communication mechanism, where a producer writes to
> the memory, and a consumer polls for new data to be available.
> 
> I'm including a minimalistic proof-of-concept implementation meant as a
> vehicle to demonstrate the idea and clarify semantics. It works by
> mapping the memory region read-only, so write accesses will generate
> page faults. The `page_mkwrite` handler can thus trigger notifications.
> It also allows the mappings to become writable temporarily until the
> mechanism gets rearmed.
> 
> Intended usage looks as follows (cf. selftest code included):
>    1.  Call `memfd_tripwire` to create an instance, `ftruncate` to
>        configure its size.
>    2.  Pass the file descriptor for `mmap()`ing to the producer and
>        consumer (potentially across process boundaries).
>    3a. The producer writes to the memory region whenever there is new
>        data to publish to the consumer.
>    3b. The consumer runs a poll loop:
>          * Wait for `POLLIN` event.
>          * `ioctl(MEMFD_TRIPWIRE_ACK)` to (1) re-arm for subsequent
>            notifications and (2) make sure prior writes are visible.
>          * Examine the memory region to collect and process the data
>            provided by the producer.
> 
> The intention is to guarantee that no change to the memory region can
> slip through undetected by the consumer. The ACK semantics are
> instrumental in achieving that. When the ACK returns, we assure the
> consumer that (possibly concurrent) writes to the region are either
> visible, or if not they will trigger a subsequent `POLLIN` event. Note
> that there is no guarantee that each write will generate an individual
> event. Neither are any details on the triggering write provided
> (address, value). The consumer is expected to inspect the memory to find
> out what has changed. The details of this depend on the communication
> protocol producer and consumer are following.
> 
> A direct consequence of the above semantics is that for a write to be
> detectable by the consumer, the write must change data in the memory
> region. Re-writing an already-present value would generally not be
> detectable. Sequences where a location is written briefly with a changed
> value and then restored to the previous value can't be reliably detected
> by the consumer either. I'm calling this out as a noteworthy restriction
> that will prevent certain usage patterns.
> 
> I also want to call attention to an inherent race condition. Page faults
> signal that a write is being attempted, but obviously they fire before
> the actual write happens. Thus, write notifications are generated before
> the write, and race with the write actually taking place. If the
> consumer wins the race and gets their ACK through before the write
> manages to land, the consumer could see unchanged memory, and the
> producer would fault again. This is perfectly compatible with the
> desired semantics, but creates the risk of a lifelock situation. In
> practice, it is hopefully exceedingly unlikely for the consumer to win
> the race consistently so that this can be ignored.
> 
> Switching to motivation: Producer / consumer communication can be
> implemented in many different ways. Pairing shared memory with a
> notification mechanism such as `eventfd` gets the job done nicely, but
> requires the producer to operate an `eventfd`. This can be undesirable
> or impractical for cases where the producer is designed to talk to a
> hardware interface in which a register write also conveys a "doorbell"
> to trigger hardware processing. The proposed mechanism allows software
> implementations of the consumer side that behave functionally equivalent
> to the popular ring buffer + doorbell consumer implementation in
> hardware. This is particularly useful in contexts where hardware is
> simulated, for example in VFIO-user server implementations. The tripwire
> mechanism isn't restricted to that use case though and is generic enough
> to be useful for other purposes as well.

 From your earlier requirements description, my first thought was also 
the shmem + eventfd approach. It seems straightforward and avoids 
introducing a heavy new system call to reimplement functionality that 
already exists.

Moreover, I haven’t fully understood what hardware constraints you’re 
referring to here.

Anyway, let’s also see what others think.

> In terms of related technology, there is some overlap with both
> `userfaultfd` and KVM's `ioeventfd`. `userfaultfd` has a write protect
> mode that will generate notifications upon write access. This can be
> used to construct a similar notification mechanism to the one proposed.
> However, the producer will be blocked until the consumer resolves the
> fault and provides a writable page. The consumer will then have to give
> the producer time to carry out the write before re-arming write
> protection. Furthermore, `userfaultfd` is scoped by design to a process
> / `mm`, whereas the proposed tripwire mechanism makes the fault handling
> and notification mechanism a property of the memory region represented
> by the file descriptor. The latter is simpler to integrate with existing
> IPC protocols that already exchange file descriptors (such as
> VFIO-user), avoiding the need for additional setup code in the producer
> to instantiate a `userfaultfd` and pass it to the consumer. Also, the
> tripwire mechanism doesn't make an attempt at providing a generic fault
> handling framework, which sidesteps the access control complications of
> `userfaultfd` when it comes to handling faults generated in kernel
> context. In contrast to `ioeventfd`, `memfd_tripwire` does provide
> regular memory semantics, whereas `ioeventfd` discards written values.
> 
> There are also a number of design choices / alternatives that warrant
> consideration. For simplicity, the proof-of-concept implementation
> generates `POLLIN` events on the file descriptor representing the memory
> region. That's somewhat unconventional given that `POLLIN` is originally
> meant to indicate a file descriptor's readiness to be read, which is
> always the case for memory-backed files. An alternative design might
> associate a separate `eventfd` at setup time to deliver events to. If we
> were to deliver events via an `eventfd`, we could possibly also fold the
> ACK operation into the `read()` that clears the `eventfd`, which might
> be considered a cleaner API.
> 
> Finally, I acknowledge that the proof-of-concept implementation has a
> number of gaps that would need to be filled in for a production
> implementation. This includes read and write `file_operations`, support
> for sealing and THP, etc. These features are already implemented in
> `shmem`, so a production version would likely make most sense as a new
> `shmem` feature. I wanted to get high-level feedback on the concept
> before starting work on that though.
> 
> Mattias Nissler (2):
>    mm: `memfd_tripwire` proof-of-concept
>    selftests: `memfd_tripwire` selftest
> 
>   arch/x86/entry/syscalls/syscall_64.tbl      |   1 +
>   include/linux/syscalls.h                    |   1 +
>   include/uapi/asm-generic/unistd.h           |   5 +-
>   include/uapi/linux/memfd_tripwire.h         |  19 +
>   kernel/sys_ni.c                             |   3 +
>   mm/Kconfig                                  |   9 +
>   mm/Makefile                                 |   1 +
>   mm/memfd_tripwire.c                         | 246 +++++++
>   scripts/syscall.tbl                         |   1 +
>   tools/testing/selftests/mm/Makefile         |   1 +
>   tools/testing/selftests/mm/memfd_tripwire.c | 695 ++++++++++++++++++++
>   11 files changed, 981 insertions(+), 1 deletion(-)
>   create mode 100644 include/uapi/linux/memfd_tripwire.h
>   create mode 100644 mm/memfd_tripwire.c
>   create mode 100644 tools/testing/selftests/mm/memfd_tripwire.c
> 


