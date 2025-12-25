Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD860E7AD41
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 08:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ADD56B0088; Thu, 25 Dec 2025 03:21:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A7F6B0089; Thu, 25 Dec 2025 03:21:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366746B008A; Thu, 25 Dec 2025 03:21:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 240496B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:21:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B689CB9B56
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:21:45 +0000 (UTC)
X-FDA: 84257299770.16.6C879EF
Received: from sg-1-109.ptr.blmpb.com (sg-1-109.ptr.blmpb.com [118.26.132.109])
	by imf23.hostedemail.com (Postfix) with ESMTP id A542C14000B
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:21:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Kn1MMYcw;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.109 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766650904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yiNawinEFDT7RNWcuSmOZol6+g8othUx6jWLOxsN1Rw=;
	b=UZXLAP2VupzWEinQ9VuhzUtLufN9zSF9Xr8YPCwSOfoAqteP5CLZBtGepjvUPcjsYMt4dA
	hbSqIAihtRdnolIDGvIGmWv+FDJSjVpuiBtVQiAJuhYiXcfrEZxT3RIq5kIpYmy/2evuqE
	8Qcw8HJ7g+IIsX4Bt0/C3QprsNBm0Ng=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Kn1MMYcw;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.109 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766650904; a=rsa-sha256;
	cv=none;
	b=JbEyXv1o+8ctUdA6xrdYKYcLbE2G+A7uvh/rt/cn2rViBOSMBkGLwm6uC5ZWcRqG53xDel
	+5p3lc68c/p5vYbMR2xd7XfwAtncEBHpWTPYmrzrRL5ZynUkg5V4/OaTffr2Eg9yy+kCV+
	ym1hUAuT0sb/qMd+j+Z2RGrBD6cndCc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1766650895; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=yiNawinEFDT7RNWcuSmOZol6+g8othUx6jWLOxsN1Rw=;
 b=Kn1MMYcwsf0iDzNFiZcE6plkN5gixFf1IaUPo6hP7whLh2O/DCwX40toUK2EGjArdIQcK+
 9owlX7Gn92c6+NlHiatqNskH0lHK8eBdFpRro53eZFO5pdtpRNfzg3A0vj9Q0CXWhE4+PO
 FbkvPXZN+YK7yMr9B6AMBUs+ok1ft0JKl2/4FnsipohR/NHEO76YbmD90mYOiTqVq78ojq
 7YuK0U7wOgNDTI5vX6aCftnNqEUZYaC8mC5iaRBOg/3+YlQNl2gfHxO6QfG5GoZ1MDmB3U
 mLJgYzG3ABY/dlgUnBSZ+AZpS7668DOFlTQvuA8xW7BEzbJLse5QLzTbcsC/zA==
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
Message-Id: <20251225082059.1632-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: lizhe.67@bytedance.com
X-Mailer: git-send-email 2.45.2
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
From: =?utf-8?q?=E6=9D=8E=E5=96=86?= <lizhe.67@bytedance.com>
Date: Thu, 25 Dec 2025 16:20:51 +0800
Subject: [PATCH 0/8] Introduce a huge-page pre-zeroing mechanism
X-Lms-Return-Path: <lba+2694cf40d+574a56+kvack.org+lizhe.67@bytedance.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: pjjqwax9p1entaebbwti39b1md5xomc8
X-Rspam-User: 
X-Rspamd-Queue-Id: A542C14000B
X-HE-Tag: 1766650902-816378
X-HE-Meta: U2FsdGVkX1+Il9ig0ZUG2OpEaAI3WtPG4dBN44IRklA7wZmxAGvubgpDquXb88sjcIqLhWHbR1SRjUfr8lpk7Cuw6h2rVnXRZ9bTbsyBU/qNyIp/Jz7JjLqc4W8cm0M0xa+ksXxTil+IwbyFNAC4LtK8TokctG+GW2SP/RobMoxcu5QnpVUbookpi2IIIid/l8sVcN9En3uMKmKSqHo1swQdJszHdrPT1SKDNNxmPQndny2Y8B6dH+ymFFMes+aUYEFO4ykDtEQP8P/qHcvrCG4Hc3uYWMAiRI//OPr/7JiegAN/1XS/qjgWDA3UdYLY46PZruHDl0va8FXKGDTpht6RLK6fSmUQHajq+R0jnTYU37X9FRdXwK8bYjVMTBmcUIkwoKpbW+Zs8FSebfMwyRXsAgQ48Lw2tNXYon7JTCxBarrufS8PZ52R91fxRGYxCUYSxAfCMXCJPu3W5Af+RhkedM03luRgciwleFhHLiILip9vLrvUcvAALQzAeeun/8XonbF5AphNOsRqJLBlYw1I44vq/2XzDMAkI0Z3tRDCWu3ptcaVRtR+wLw7BMMeTRFHjxkNYDw1Ly1UHpjDQJjZo8EWJinXSUaFupfT+WXLCz0jlkqYd/9o1/nclz635fRn4pC+/ySOmbPY1iZo/U0J9EmtDRTAxFd/uQaTM87grBqHcIETdtEcVoIOGF1yhgn1s5TJ4uYJzeCanglGoILmmzFX8RBMOOZ3IpkeKjvot1gI3HbI45ibxwlxIhkG+ypwwYSS905Z4WTIYTW6WfW9xNsggFrMQfMDwJGj2p6kB4sTT+hTMT8fS+ozzxKE6yAuVdbBvsO7jjrvxMilsb45754/rax5JkR/EkZv8hxrj7oLWfokr+nD42n+bq/D6Uw/cgcFYGcIukqXgMbs1bf4B48WPL+xHdOYFCcenAMMvFqCxcluhgkivJ/NS3lTJnQBS25wRUfaZxTLXhb
 pFs6QHtt
 JLozEDelXAXTxm2z3XefY0+F4gVKi3vC/yDlzbdAKRSk6D7W9gdYj5Waw4oF3qW/MAbznBDWsGucOv4+ohCyd63noDds5fpUc2i6qrHN1dBSzghH1DWraIBGD6uQ95njsuDYFURBHUyCwin0MSRATM2dvPNu9b3Wgq+tgdYJXuj6kGHurEi5P4CwTnyCfoAQoACGemZ3/JKJK5LBLuDSMrjdUUqvmEnBnIWqKCGuu5e+y0YjkMSiv76NEhumubyGhHt+sOCR0Ifz5cI8flXDF2OnIwEv95vgp5SGmM/f8I0FDMXauj5hVRM2cU2S8mulDG3pVgEp4lFmptRk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

This patchset is based on this commit[1]("mm/hugetlb: optionally
pre-zero hugetlb pages").

Fresh hugetlb pages are zeroed out when they are faulted in,
just like with all other page types. This can take up a good
amount of time for larger page sizes (e.g. around 40
milliseconds for a 1G page on a recent AMD-based system).

This normally isn't a problem, since hugetlb pages are typically
mapped by the application for a long time, and the initial
delay when touching them isn't much of an issue.

However, there are some use cases where a large number of hugetlb
pages are touched when an application (such as a VM backed by these
pages) starts. For 256 1G pages and 40ms per page, this would take
10 seconds, a noticeable delay.

To accelerate the above scenario, this patchset exports a per-node,
read-write zeroable_hugepages interface for every hugepage size.
This interface reports how many hugepages on that node can currently
be pre-zeroed and allows user space to request that any integer number
in the range [0, max] be zeroed in a single operation.

This mechanism offers the following advantages:

(1) User space gains full control over when zeroing is triggered,
enabling it to minimize the impact on both CPU and cache utilization.

(2) Applications can spawn as many zeroing processes as they need,
enabling concurrent background zeroing.

(3) By binding the process to specific CPUs, users can confine zeroing
threads to cores that do not run latency-critical tasks, eliminating
interference.

(4) A zeroing process can be interrupted at any time through standard
signal mechanisms, allowing immediate cancellation.

(5) The CPU consumption incurred by zeroing can be throttled and contained
with cgroups, ensuring that the cost is not borne system-wide.

On an AMD Milan platform, each 1 GB huge-page fault is shortened by at
least 25628 us (figure inherited from the test results cited herein[1]).

In user space, we can use system calls such as epoll and write to zero
huge pages as they become available, and sleep when none are ready. The
following pseudocode illustrates this approach. The pseudocode spawns
eight threads that wait for huge pages on node 0 to become eligible for
zeroing; whenever such pages are available, the threads clear them in
parallel.

  static void thread_fun(void)
  {
  	epoll_create();
  	epoll_ctl();
  	while (1) {
  		val = read("/sys/devices/system/node/node0/hugepages/hugepages-1048576kB/zeroable_hugepages");
  		if (val > 0)
  			system("echo max > /sys/devices/system/node/node0/hugepages/hugepages-1048576kB/zeroable_hugepages");
  		epoll_wait();
  	}
  }
  
  static void start_pre_zero_thread(int thread_num)
  {
  	create_pre_zero_threads(thread_num, thread_fun)
  }
  
  int main(void)
  {
  	start_pre_zero_thread(8);
  }

[1]: https://lore.kernel.org/linux-mm/202412030519.W14yll4e-lkp@intel.com/T/#t

Li Zhe (8):
  mm/hugetlb: add pre-zeroed framework
  mm/hugetlb: convert to prep_account_new_hugetlb_folio()
  mm/hugetlb: move the huge folio to the end of the list during enqueue
  mm/hugetlb: introduce per-node sysfs interface "zeroable_hugepages"
  mm/hugetlb: simplify function hugetlb_sysfs_add_hstate()
  mm/hugetlb: relocate the per-hstate struct kobject pointer
  mm/hugetlb: add epoll support for interface "zeroable_hugepages"
  mm/hugetlb: limit event generation frequency of function
    do_zero_free_notify()

 fs/hugetlbfs/inode.c    |   3 +-
 include/linux/hugetlb.h |  26 ++++++
 mm/hugetlb.c            | 133 +++++++++++++++++++++++---
 mm/hugetlb_internal.h   |   6 ++
 mm/hugetlb_sysfs.c      | 202 ++++++++++++++++++++++++++++++++++++----
 5 files changed, 335 insertions(+), 35 deletions(-)

-- 
2.20.1

