Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE86FCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637BD6B008C; Wed,  3 Jun 2026 08:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8486B0092; Wed,  3 Jun 2026 08:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF076B0095; Wed,  3 Jun 2026 08:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2616B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:55:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BBB4120342
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:55:49 +0000 (UTC)
X-FDA: 84838598418.04.59D7AAD
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1615D100006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:55:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=tSnbWX4d;
	spf=pass (imf14.hostedemail.com: domain of "prvs=46141c1cd1=mnissler@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=46141c1cd1=mnissler@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780491347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aZJXhZ1R6tmRZeIAA1pMw/fmLtckUxz+309lEoPq9uQ=;
	b=n4/0DtowJC/QtpKjU4CX2l7e/rH8+XouywcmytSpZqpwyemZcUSSeSTFONW4Ysi1Cu+HLP
	FbvPFkSyJ4PdJ+Qcr6ODCGKtqp34rl5BZbmO33XNvV6caTrYnpB2Dd4I3byRaPg41XbPZA
	Ea0NP5nJLlid5See+V3aZYKK00AmPXc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=tSnbWX4d;
	spf=pass (imf14.hostedemail.com: domain of "prvs=46141c1cd1=mnissler@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=46141c1cd1=mnissler@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780491347;
	b=jEAOIygBHHo45sPTL321CHZ5ZVKqO/nGz7pt4K/4QrQcBuwLnNGzDkKZYKVDjtCFXwfY3O
	2r9Strb+XHOlsE3on2Mq2Bpbzm3AVcA/SR7QXUNrrcLEtbEgoiU6K1r7Zq8w5wpcBHemPA
	5RNQitkQBcpwjnQtY0hB7BDVM564YHs=
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 652MS0Yr251538;
	Wed, 3 Jun 2026 05:55:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=aZJXhZ1R6tmRZeIAA1
	pMw/fmLtckUxz+309lEoPq9uQ=; b=tSnbWX4dKPfPErIJ1iZbKNYLqMLppHG3vN
	5RJRUim0Go7/rPjdnC6mA76WzH7B3w8EBk7E94wuyHcz5uRpnn4z6OYCeR8we7ci
	xsgglJTJnbvcDDo/H7679e9OXbfjJXvDVJenHMV8Z3ZUhHyDWItRAXXrmSLWnI4S
	As3SUnnZ4OiN417HKKz0pVMKgrZ6oAKvkdU5Fdl+O2NnfTfT7CTZPmJLftzEeli+
	azCQmmiVKnnFcqKRCEq0uMtQF5klGFhuLTu4btgcfI14DFTR/T65rtMCl0vuE7fU
	Bqp0KMuzik6oO3H1UEJtxPPV2y/MqnIhfp8y/fDhrfS0Z47HLd8g==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4ehxr4qwm9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 03 Jun 2026 05:55:44 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1b::30) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.41; Wed, 3 Jun
 2026 12:55:43 +0000
From: Mattias Nissler <mnissler@meta.com>
To: <linux-mm@kvack.org>
CC: Hugh Dickins <hughd@google.com>,
        Baolin Wang
	<baolin.wang@linux.alibaba.com>, <mnissler@meta.com>,
        <mattias.nissler@gmail.com>
Subject: [RFC PATCH 0/2] mm: memfd with write notifications
Date: Wed, 3 Jun 2026 05:55:19 -0700
Message-ID: <20260603125521.1468362-1-mnissler@meta.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::30]
X-Proofpoint-GUID: IOOvnXtSp7o4UO-yFHkUgAek_2oEtYTw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDEyNCBTYWx0ZWRfX8tOsleKKKtcu
 0cfnwdgnhBZBvf5vmc6XEgIhCjfH+8k/0REW00LDMEBOURvv1+FjXQS6FzaFp+DnZhLnD1+g7sp
 dWS4g9huwpZE2mJkPw8RcFDhgHhj+mZHD9AGZNQbQhXxzF4nF7HdB3H1lLqT+IrPP2BTWe1WG0c
 9DajmxuTZ7GjTRnSBvmdGJdhzr6WrfOFR95b1Bj3OauSmSMCOFHQ8b0vGwR26mLweeFXcdRQP+B
 uaHuTVZMksVjrw2s4jDmPdQIr+3dbNFlt0afGkM/EqjfIK2NiQPNWVoMQM3rGkT7xSJFyNpxUOX
 dlDXgulXIoVd0opu68ipok4w8WdDcUS9j/6UwlAIHWQd37VeV3IDZh/cvajHdJzk2gJuNpDvyuj
 qlcS86/pHlF2J9chM2utnJhziOChCAJl+fYteQ1Br8peBT8p/LhshTMPfgz/bwKFnU/SjIcMbui
 cy2b/EYPP9n1d6QI6lw==
X-Authority-Analysis: v=2.4 cv=dsbrzVg4 c=1 sm=1 tr=0 ts=6a202450 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=855S8uPTkML1Oy45N9_h:22 a=q0Np7pfqVLJJm0Jx16kA:9
X-Proofpoint-ORIG-GUID: IOOvnXtSp7o4UO-yFHkUgAek_2oEtYTw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-03_04,2026-05-28_03,2025-10-01_01
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1615D100006
X-Stat-Signature: q1qjzjknrm3311rjzrmsxg4spibp19bj
X-Rspam-User: 
X-HE-Tag: 1780491346-941013
X-HE-Meta: U2FsdGVkX1/ZIbin/e54YIfmgEdpaVr25kMpZhtzX3RWTk485KGntPN9rm4AJS6tYXZFdyKH3kt5Kq9+rvb5mYIyxgzkNDhgnhKP5GMGsqATQdpQWfTwEXlKHY5WSf0W8Nz3NmX/3f1c4R4WAh0Qq7a60BhVnUMYa29H4RtS7HeO56hKIMvyrZlnohlo8lNyxwaW1HUVNVQr3yOiA3Dp2e8cyjUt/4qM+peedHUMNxpRzS0r+9a/H03dgkB0wPvyoimK5QERV/9tRQta6ft6fjjIgRAeBYp6q1lXfrCgBea4RctGoxC1odr/NaXyFejewu6tSoPrPxTG60vIy5c9VYcZS8eZYA6t1SRo+v7aClGMKGtZ5TlITSIi8wplU0Swsq7tS3Y6m40zCGoIFziU6HX0s4rl/t0SiUCUzejqB3gLFhdXM9ZbC4QINzx2GZZ2WM3zmi65xZa21f+fvdSGdNULfgqdMwf/vPp2OiLDGpQc5M5l8UKuLPAkxmjndH8Nj3shXvhfkzpc8a+w0pi8TPCM0WcCwfV/x6yMxLdg9izN01DNVzj1TCq4/d1+pDALQQMXDRSWO47YYKjPDTQ0DL+z1Mpv6TWjGRWkleYKbZ2A1izE3790YMW8Lygtbpv6hwwQVdmehynWjMCh7G2PxXPtEST6TGiy62haMsHHpdM4r2aS5Jj+aVDed/Wz6pihVgjBKpM/kj7a4f3FGb6pewsI3ZzgEGSw4kjijmV19ngVcTy2AezmYJzxnr4LEy9rsd6B6aoltPUvnKgKnzhEZJx+qmKZkpS0KWsGF1YB7n9tNC1xtQ7eUNSld2FTHXFRDBVR77DVCkl13ASFwmRrl3WmxeqsWUWwIoCHkuyGILBqWhZlqMWN6RCIplw2NTSMBgVy1P5H4tuEUnwNuNUYLbXwtxiXz+aUS3qnpR/YmgzLL3s9mR0KCWx1yZ93m76znYxn6x4pHN3V44vq18u
 LYb7x7Wh
 RC7+5q/FbuH0wI5cRTx9VLGzI8Vl7aNUNzjByhlZxwwsR+ZuT5UZaavi1Hnlg7OG8tLRO+Su1Eq0pdllpuDQMz9EAz9PbwzSOWUuUA7zZ3aX1EIcz/4HKX2lmj9rAaqEjkBgYZkAwVGizjlEcZlUl7hW2ybZrNC8jqG430nDuC1AihZkkK+FTQed++oG/6v4THZZjj/Wys/bxHlH3WtMi7M4kv4KMuBMx9Wwx8SEoKWqrGrQIxX7pxufkHcAiPcjh/0GYuaBJYPoapb1IECJsE1gPk69evNhY5xNOvcfseYhaUkgCV/3+VTVM1M9qsBM6HvTW7PGqKQ6yqgkda66G4x86EjVb7R3HCjnDRpzRhOS9L3YAra5aUBAMBfKR9B8IruAZ4HcFlV+JSEYCY78gDJ9O6D9RMqvpuxRGjGyI6TqSf9eZtqC5fMt0XHcpUaJmCucC9rifJsS/o41EMXqFUKMcPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I want to propose a kernel facility to have user space create memory
regions that can generate notifications on write access. This is useful
as a cross-process communication mechanism, where a producer writes to
the memory, and a consumer polls for new data to be available.

I'm including a minimalistic proof-of-concept implementation meant as a
vehicle to demonstrate the idea and clarify semantics. It works by
mapping the memory region read-only, so write accesses will generate
page faults. The `page_mkwrite` handler can thus trigger notifications.
It also allows the mappings to become writable temporarily until the
mechanism gets rearmed.

Intended usage looks as follows (cf. selftest code included):
  1.  Call `memfd_tripwire` to create an instance, `ftruncate` to
      configure its size.
  2.  Pass the file descriptor for `mmap()`ing to the producer and
      consumer (potentially across process boundaries).
  3a. The producer writes to the memory region whenever there is new
      data to publish to the consumer.
  3b. The consumer runs a poll loop:
        * Wait for `POLLIN` event.
        * `ioctl(MEMFD_TRIPWIRE_ACK)` to (1) re-arm for subsequent
          notifications and (2) make sure prior writes are visible.
        * Examine the memory region to collect and process the data
          provided by the producer.

The intention is to guarantee that no change to the memory region can
slip through undetected by the consumer. The ACK semantics are
instrumental in achieving that. When the ACK returns, we assure the
consumer that (possibly concurrent) writes to the region are either
visible, or if not they will trigger a subsequent `POLLIN` event. Note
that there is no guarantee that each write will generate an individual
event. Neither are any details on the triggering write provided
(address, value). The consumer is expected to inspect the memory to find
out what has changed. The details of this depend on the communication
protocol producer and consumer are following.

A direct consequence of the above semantics is that for a write to be
detectable by the consumer, the write must change data in the memory
region. Re-writing an already-present value would generally not be
detectable. Sequences where a location is written briefly with a changed
value and then restored to the previous value can't be reliably detected
by the consumer either. I'm calling this out as a noteworthy restriction
that will prevent certain usage patterns.

I also want to call attention to an inherent race condition. Page faults
signal that a write is being attempted, but obviously they fire before
the actual write happens. Thus, write notifications are generated before
the write, and race with the write actually taking place. If the
consumer wins the race and gets their ACK through before the write
manages to land, the consumer could see unchanged memory, and the
producer would fault again. This is perfectly compatible with the
desired semantics, but creates the risk of a lifelock situation. In
practice, it is hopefully exceedingly unlikely for the consumer to win
the race consistently so that this can be ignored.

Switching to motivation: Producer / consumer communication can be
implemented in many different ways. Pairing shared memory with a
notification mechanism such as `eventfd` gets the job done nicely, but
requires the producer to operate an `eventfd`. This can be undesirable
or impractical for cases where the producer is designed to talk to a
hardware interface in which a register write also conveys a "doorbell"
to trigger hardware processing. The proposed mechanism allows software
implementations of the consumer side that behave functionally equivalent
to the popular ring buffer + doorbell consumer implementation in
hardware. This is particularly useful in contexts where hardware is
simulated, for example in VFIO-user server implementations. The tripwire
mechanism isn't restricted to that use case though and is generic enough
to be useful for other purposes as well.

In terms of related technology, there is some overlap with both
`userfaultfd` and KVM's `ioeventfd`. `userfaultfd` has a write protect
mode that will generate notifications upon write access. This can be
used to construct a similar notification mechanism to the one proposed.
However, the producer will be blocked until the consumer resolves the
fault and provides a writable page. The consumer will then have to give
the producer time to carry out the write before re-arming write
protection. Furthermore, `userfaultfd` is scoped by design to a process
/ `mm`, whereas the proposed tripwire mechanism makes the fault handling
and notification mechanism a property of the memory region represented
by the file descriptor. The latter is simpler to integrate with existing
IPC protocols that already exchange file descriptors (such as
VFIO-user), avoiding the need for additional setup code in the producer
to instantiate a `userfaultfd` and pass it to the consumer. Also, the
tripwire mechanism doesn't make an attempt at providing a generic fault
handling framework, which sidesteps the access control complications of
`userfaultfd` when it comes to handling faults generated in kernel
context. In contrast to `ioeventfd`, `memfd_tripwire` does provide
regular memory semantics, whereas `ioeventfd` discards written values.

There are also a number of design choices / alternatives that warrant
consideration. For simplicity, the proof-of-concept implementation
generates `POLLIN` events on the file descriptor representing the memory
region. That's somewhat unconventional given that `POLLIN` is originally
meant to indicate a file descriptor's readiness to be read, which is
always the case for memory-backed files. An alternative design might
associate a separate `eventfd` at setup time to deliver events to. If we
were to deliver events via an `eventfd`, we could possibly also fold the
ACK operation into the `read()` that clears the `eventfd`, which might
be considered a cleaner API.

Finally, I acknowledge that the proof-of-concept implementation has a
number of gaps that would need to be filled in for a production
implementation. This includes read and write `file_operations`, support
for sealing and THP, etc. These features are already implemented in
`shmem`, so a production version would likely make most sense as a new
`shmem` feature. I wanted to get high-level feedback on the concept
before starting work on that though.

Mattias Nissler (2):
  mm: `memfd_tripwire` proof-of-concept
  selftests: `memfd_tripwire` selftest

 arch/x86/entry/syscalls/syscall_64.tbl      |   1 +
 include/linux/syscalls.h                    |   1 +
 include/uapi/asm-generic/unistd.h           |   5 +-
 include/uapi/linux/memfd_tripwire.h         |  19 +
 kernel/sys_ni.c                             |   3 +
 mm/Kconfig                                  |   9 +
 mm/Makefile                                 |   1 +
 mm/memfd_tripwire.c                         | 246 +++++++
 scripts/syscall.tbl                         |   1 +
 tools/testing/selftests/mm/Makefile         |   1 +
 tools/testing/selftests/mm/memfd_tripwire.c | 695 ++++++++++++++++++++
 11 files changed, 981 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/memfd_tripwire.h
 create mode 100644 mm/memfd_tripwire.c
 create mode 100644 tools/testing/selftests/mm/memfd_tripwire.c

-- 
2.52.0


