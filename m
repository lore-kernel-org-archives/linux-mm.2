Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02CB6F8925C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 11:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3399B6B0088; Tue, 21 Apr 2026 07:17:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA016B0089; Tue, 21 Apr 2026 07:17:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9076B008A; Tue, 21 Apr 2026 07:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8896B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:17:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF9CCBD8A1
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:17:55 +0000 (UTC)
X-FDA: 84682313310.06.64D84B1
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id E617A10000C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:17:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gQeX7If+;
	spf=pass (imf14.hostedemail.com: domain of shicenci@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776770274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UAxfHPswwQ5G31rFFAOLdCIIYxIqmhsNU274XI2LiA8=;
	b=Ncyl2r7FnwlnIlgF5kB32blTnFeMcw7a3eX6AhMOEGuj8/esQuLJLsG/WDDcBUkAzL6Vs9
	x42vg0trZ/YdRm3cACkOCNbQcYrDo2vPRsFujKhR8y3xfDqknUu4MzCP9SJL+dajUv34pv
	zK4JrL2Aqo1n582ArrW0ME60XQmb8vk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gQeX7If+;
	spf=pass (imf14.hostedemail.com: domain of shicenci@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776770274; a=rsa-sha256;
	cv=pass;
	b=4a4QgT5ynTQo9SQOnWaZqm9hF44K30JvSW+YhNN3+l6OXWRxmKHJrStCyt+HDMlVRb8BM3
	ORnyrPy/8JDhIWyqvV0/DvUnx80qIc6nurrKtGobI/lxfk80Jf+AZeoFMSAdEk/PWg0zQg
	0WYILJbHvo6fsJhTug09xyxe1bDdRZ4=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b461310af5so16053755ad.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:17:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776770272; cv=none;
        d=google.com; s=arc-20240605;
        b=lS0WS/MtaoRMywni8tNJROeqqaYat37QM6Y8PRPNe5QoaeXvEr+znZdf6rs+mTqKYv
         5535bk/chm/3VRSV/qeN0fcoMsN8cfFoZeNTotGThO7uNnbnBN/0vzGW2OXNi3Ux9Qd3
         3j8WR8fhFOpvv4DT9nNHDjKkZOaWrdpshWQ5VyAam9N8H3CvS2z7Gluq9MLsl5KmQMa3
         iRTZ9Pv6eW1+2nGcrVqZFMq+B+8X/+oDTsPFmhxIpw6+xhBU1/z3dcs8iRXnU+uMkKzf
         YSR6Lr06/u+9OsNsLy8QtoCr8SY9X24RXqOzOUyKtW2wmxIah/GlIksu8YHggivt2AUe
         CpXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=UAxfHPswwQ5G31rFFAOLdCIIYxIqmhsNU274XI2LiA8=;
        fh=SE3zyewpUcCqiPQOMljTuLBzsoq8qqj1t/jNCufcqig=;
        b=fcwVCFhJhUaU5KalO1LZpN+plO1Tq79MAZUUsl4LQIzOb11lfx9+maUbpX7coNOpdI
         nByKkrwQJmvV3MQiZb5+BglQtTENBaOGWFgDpWR+1XyiI+4djDOA+a6mcXVQDtYyEN/C
         i6UA4+oPw/7FO5qUWJrhnANpxQj5r3MFRGlINDto9RfALM8/brPYhYy4SYQhOSo0HSVr
         n25gbcoZPqXMUKnR4fQkD1rXFAHS1BDRaeZ9ujZKtVjTcljQMFW9MHrrsWch93HWSNI+
         7g+4wmnaCwRZQQBPyFIpEQpff3qCz5NbS8DQd+F55Jk1GXeqvLwQe+y5tvwBQWMErljL
         l+FQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776770272; x=1777375072; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UAxfHPswwQ5G31rFFAOLdCIIYxIqmhsNU274XI2LiA8=;
        b=gQeX7If+Ko51vx3Wf614rVWRt6z9GjR24tSeDdUSFlgsH9kviSuit1zADcTWxqSmCc
         nXSHTwCVSbnKPsqN9BL1YdTQyyzJOPLw1lUs58jV7UtT1mpO49CIvDvdzhywwEIiC1gc
         NxCXOvKNI29fde/YUWhf64uSYCFcKubQGAFbrPzHFe+IW1cNklljwpZn2DtXVQcr+3em
         /XmzP1MtcE6nqL+tTmn2xm0CcZEGzhmWhtECDeOOiZ7GkJbBi9InRdQmCiQ3BNN4Qxj0
         OmkiVgU+JgnLgGesNxLlKsz+AybXM2g7kRSdzOjptar6/We3+wRqArK2g8zn5szLrEig
         cjPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776770272; x=1777375072;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UAxfHPswwQ5G31rFFAOLdCIIYxIqmhsNU274XI2LiA8=;
        b=i9o6TzFdAWWlkskoB0c6bJPR1ceeKfEnje5HvZ9nbUwS+Ff+9kjkfPQFiLSCzaYYNq
         CfAcG5Q8gydQw0oSv4emW6qUEH1z7prt5T/7gFHaRHDqJU8WOx9WeDHBOZMxGb5WdQud
         FRZQ+1onORMRFmXXOh3R9fKdlf+IWpi4y75MWpXmyzHKsB6teawnqWVzwbFk5/BQIh2Y
         srPbnfmvft7OPseeR+dwEA2ewIUulFJaNumTk94DL39DLsuLkyj97IkE4SmxiXVsbaYa
         TvULwwRsCN2zYFZoS5EEmW76NcmpxlLaEM2bWOT0eJa0TOtPNX2TmTDczuoHrZXaX0i4
         lQvQ==
X-Gm-Message-State: AOJu0Yx/arE9xJZvLwxxydPlMgRcTeFtgXmqiW0LRrAo0oIKDHEocD6g
	S/1vqJu2xTYwAzNetg68kPaHeF/IuFd3Mnki8Gjdt/6PVUCqkCpUJSFIDQ1+V2Srtsps9my6IRx
	PL+EKJXxjioiXHr3mwBEJQWngJKi2Ul1hfrdZ6rBsOA==
X-Gm-Gg: AeBDieuEk10Q3hYtu5GnnFamUoMY3uEWclI+Sm4kKfK13X1bo3Galte96BogFu/5SRB
	RrccShGpLdk9WyeR/sYtqaI/ehJnf6TrAQBe0lOMs/NCL7j/8rtyIMvIIwdSAhyoaCmbG9w89Y7
	hf145ZIvTlHdOQtDo9/7YwYITkgeI4KlyRg9v3MzmX2s7k3dOUt//VvrlQPhqM+EmoJP7id3hoX
	zBQxpfl4MoCNQCkQbzRn9VcpQ6G/WW9AhtmqZ7ry2yPjQkbslsx+GkDxjmMAIzRr/vw01iUXgwF
	pq4Iv6Q2gtposMQFZ/ojYokIzmbE
X-Received: by 2002:a17:903:166e:b0:2b4:64cf:e8f8 with SMTP id
 d9443c01a7336-2b5f9dbcd22mr166529785ad.2.1776770272491; Tue, 21 Apr 2026
 04:17:52 -0700 (PDT)
MIME-Version: 1.0
From: Zw Tang <shicenci@gmail.com>
Date: Tue, 21 Apr 2026 19:17:40 +0800
X-Gm-Features: AQROBzCvxTzVOatYGD3oQlMzZmTAz5McY1A204T_VliE2k6DNBeXHfpitVDrZ9A
Message-ID: <CAPHJ_VJGTsRDc7_Kv0oDObuDX2pJ0evcAvH-mnD_RYMX536+mw@mail.gmail.com>
Subject: [BUG] WARNING in workingset_activation triggered by KVM page fault
 path on Linux 7.0.0-08391-g1d51b370a0f8
To: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jr89wwn4jxzjeoh7gz8bfa3gkx8ww617
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E617A10000C
X-HE-Tag: 1776770273-866111
X-HE-Meta: U2FsdGVkX1/GBqlsJjYkO0EIisEECrg2BB/RvEfOe6IdZgWj1EHYiKvX1ySD0gQdf9W/PaCk6PxdRw/bW5KSVq2u62iCy015g56wnkvdKP406vIDOHX1wPN+e8xA3Qm8CsZbdFaeA8CQ0kbNMjj7868QVW5QNEOlTn6czOtfrKqqEaz4/YZVxWsVGvoxTIbCFN5x9uGAF8+egfxM3UzX6YefaonxBfplqFdALD28hA69ORuOy98JATudt9PsjpQQZ6Ef8q0BBMHtaASPcteZYjFj2c39pqBBIh2t28B0MnFZ9NFAqr+tZcCWRyJvmS+RBchvB0Qk1vgC5pc0YLtqA8QCofwETWJmTPs5olS7ZuriTLZYzPD7DoqreQkL9pcIGiX/qTmEIthZLK4c+Qi/8TQqu3i7r7jUUVqpvVOKgLGNC2nb/crlwdk09IxyBQMHPHExURrQQP1/TXQeEo/if7KOmPOIULfHxMWUOVdDBMsWSK7D2l7yz/ltZz7SR9pOHt7OBogyvczF3yOmI8lAlkJHomyT1gYGowZToLGpjzOalhg9lq2Yv4pdvIlVACnKmK8N0Kr1vjIJrVaCiRWbW9JdWGSfggymXYv/ctxcfVbhJoeYZuJ+F5UOkETweOgWlrSQ/laKbvX9URH2Try6YWsZdKcGKtZZWUsZY4msmpyeD8jgoxZADQ33grSNVEYU8YQQDja3THTo8pZer90HLy66l/fin0NpS7e9txtq3BJauGrS2/kt0oPzPYB1+VYkWvwWfetzi8t5rUUGhS/hckjxuAvkWkUGucIHlopAo6XMdvaY65RmTj4ychmP4XnLpHTm3PztM0jN80/AMWEq4Rhn8HAC1LGp++WK6934X3aolZ210nCzAIIjVKxg1JuXockrx2MZIN9tteZkJGNoI+9rsmk/XX5soA5k20+P09ycHcGMx1ugsAk+dKeBrI1HSBUI30xZKSSoB142E2j
 9MYzP2iQ
 WCQiMt23avCwYQeK1XApEobXTX9LsOrR7Sb4E0CLbDA89MiShGVnrrkpw8hmIfRm3I6db4dKL6kfsblqvCuYH18XXHHuwdLkUsGckfVtF7395q1miI2P08vTmB0RpNl+sd0Wp4NZJFt7SQR7KPrLc43VmzfjQwn2MPXVx3ZW0gYv3MmZUZqi68GaFp2JEXVk4MjveTB0ENwz2DptIYuvJJLPILT4fnqJZXnyILe5oCnymmqvcwk+yD8KIZybDydQeHmxc86ObK2tHX+O6wL+GjXvHHYnzyicZo4TI4S4klo/VMJvzCngXNBu+pey/rmnDXEdDybDrwX+7y2xqRTAqDByjG9zc/Lk+p2oSoTOraYsox8s8HUfQ7rbbnhToZwBSCNkqI/NXniaNEndeC+nu5Gop8+t99Y8AyrdFhiuKP8deNQT3+tluAb+yTwJXd/aA0xDDPduCUmtgRBtxxt2Ef48TEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I am reporting a WARNING in workingset_activation() triggered by a
syzkaller C reproducer on Linux 7.0.0-08391-g1d51b370a0f8.

The warning is hit from the KVM page fault path:
kvm_set_page_accessed() -> folio_mark_accessed() -> workingset_activation().

At first glance this looks more like an MM/workingset issue than a
KVM-specific bug, although KVM/SVM is the trigger path.

Reproducer:
C reproducer: pastebin.com/raw/zzNSd9HK
console output: pastebin.com/raw/TuipfpyA
kernel config: pastebin.com/raw/aq1V3cLk

Kernel:
HEAD commit: 1d51b370a0f8
git tree: torvalds/linux
kernel version: 7.0.0-08391-g1d51b370a0f8 #1 PREEMPT(lazy) (QEMU
Standard PC, Q35)

The warning is:

WARNING in workingset_activation

Log excerpt:

WARNING: include/linux/memcontrol.h:381 at
workingset_activation+0x466/0x540, CPU#1: repro/238

Call Trace:
folio_mark_accessed+0x1d3/0x650
kvm_set_page_accessed+0x5a/0x70
kvm_release_page_clean+0x26/0x180
direct_page_fault+0x553/0x11a0
kvm_mmu_page_fault+0x35b/0x2020
kvm_handle_page_fault+0x1aa/0x380
svm_invoke_exit_handler+0x7a/0xe0
svm_handle_exit+0x416/0x7f0
vcpu_enter_guest+0x26ad/0x49c0
kvm_arch_vcpu_ioctl_run+0x697/0x25e0
kvm_vcpu_ioctl+0x737/0x1610
__x64_sys_ioctl+0x192/0x220
do_syscall_64+0x117/0xfc0
entry_SYSCALL_64_after_hwframe+0x4b/0x53

The reproducer appears to drive KVM into a guest page fault flow that
marks a folio as accessed, and the warning is then emitted inside
workingset_activation().

Because the RIP is in workingset_activation() itself, this may
indicate a problem in workingset/LRU or memcg/lruvec handling, with
KVM only serving as the trigger path.

Please let me know if I should also send this to additional KVM x86
maintainers, but mm/workingset.c seems to be the primary fault
location.

Thanks.

