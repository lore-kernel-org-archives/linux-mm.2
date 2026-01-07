Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9862BCD585A
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 11:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8125E6B0092; Wed,  7 Jan 2026 06:32:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796056B0093; Wed,  7 Jan 2026 06:32:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CBC76B0095; Wed,  7 Jan 2026 06:32:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A48D6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:32:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD6931602B3
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:32:41 +0000 (UTC)
X-FDA: 84304955322.27.FC4CA81
Received: from sg-1-102.ptr.blmpb.com (sg-1-102.ptr.blmpb.com [118.26.132.102])
	by imf10.hostedemail.com (Postfix) with ESMTP id B43B9C0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:32:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=OuitK3DD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767785560; a=rsa-sha256;
	cv=none;
	b=GeVktDiRAWmNp2M9qcwsUgD+vDtfk6RkVWMtb1vmtLeChnflnhoJlRUwVzIgDDkz3pP36j
	nh5Mi64oF3j1cIOQ+sWRYgJ96gebuCh8VtMgkEbgsyHoaBbGrhu8a3Ugom6kli+4jKXh1n
	hQe15bTXqgm20Vd4lkc3CmrtTGoMKnw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=OuitK3DD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.102 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767785560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GWN8s+fPVzFbFNE5fFEjyzaMPuXFTsJ/qeHx3KgXK4c=;
	b=H0gMNEo14Q3dIHoCF6DMcQf4XB0gh4OhGkr43obSev9blDrUUXt2mF01qbFMcQ5qj4AQSM
	ZckQnC3o+kSHKWYzqqbzL3OLpQEP/eOdQElgFvPXC8wOCs6Ky07MF1u72NimtxDGbYa/i5
	dbRAg3rX+iIRfzvLxPzCfYbUnDB6yvs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767785550; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=GWN8s+fPVzFbFNE5fFEjyzaMPuXFTsJ/qeHx3KgXK4c=;
 b=OuitK3DD319Iilm5xtAzIwSw0BOwc9sfSlVG8rkxPxXiaf0xp22rdXINpSioKCRH69uavh
 keae7gYEPc5q+o456NzNUcYVkBNSDLdm3YQUVTt9Ec5m6cZH2G6AbKtOS8hJDiyV5SFilz
 pCkkYl7bNZPTnX9ittcTUNVbm6NUMwDaVxC/BMLQ2i6+Q9sxg5pGuH/+On5O3+PPLgj6Gf
 Ia8OuqTWnF5IjrVyxuMt09UWKrINYeqyqpg8BnsAw7Q9jSAVty9FH9Z0ompTAwTPXCK7yY
 Bk8VbWxYIhHLDu+NAlGq+YXKOzs7RM85I5VWc5+cmpJvHAzkmZEr6IptMFJXWg==
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260107113130.37231-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+2695e444c+8ad746+kvack.org+lizhe.67@bytedance.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
Subject: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
Date: Wed,  7 Jan 2026 19:31:22 +0800
X-Mailer: git-send-email 2.45.2
X-Rspam-User: 
X-Rspamd-Queue-Id: B43B9C0005
X-Rspamd-Server: rspam10
X-Stat-Signature: psydgufaohch94spp77mny8rnd4kr7k6
X-HE-Tag: 1767785558-863127
X-HE-Meta: U2FsdGVkX18E9yAmSx0JbwBCQIDbgN/54Q0CJmm0L2nfIydyt7QTzSzK0a78U9cgkQdUxY9BB0L8aLAPC/SAiBaaFtLFXE6yNr/K52ZMsXCIZ3nF0mmKLg7dTlVU+l7wJwscvCga4USOcqi4y/DFYT/Oyut2NHjbxgmJJFmhKEucy33DmyVJg1LyeJfIfbbQpcP//DUqEajD9r0351S5kZMrdZzBm32/itilj5aNZ6GyIGLSmV+QeKYQ7Hsva+XSGWAY7dE9X6N0F0lAQbSkjvBpHYv81Nvc0D3CU53Zm/aC/BCnjmfQrm7QKqepu7Fs/36EYqufmM9r3FWumkjvA9Yafe0eQ14Y+sPmO+OQAqYw1DgqoWOiW0hv9qWm6UazyfqCPw6YehSA2J3V4GuyooY0m7RiygH6Z4gQfVKjNr1TAP/ICZr2h1JOQJ8phIp2xRWFzwXm/wLvlDNzQUU5kLN97ZbEDEi9YMINyUOwfh1HdzJ44UPSyyyQtAHaf3tdQC2cuvi93k5HT9H5DviuGY3rxZUZSXvvbM5QwWnNm28HVctO8+v1q/H02xrugL4C7oWP2zaMKbTaohyj53Y/4NiRsdrHqVfwnu9iLKjpmYMuT067aO0ytolYEAdVr2v3q3OrA32Nlsdmvo/QNhoViIMFqTG2j5uBba2YuDzgVAoZQfIq4VlbHu+qNaurXhDdBg2fvWKxZyxKiYDdr+Ce2syPI/5DafCxOqYeYEUkwHXIy8zuaM8rNzELqZ1WPyJZGKWfOpBNcMV6KYX0OLLp2D6hEhtcRFHPjzKjTvt9B8yYIzmEdvMS3sehQKsuY9nPGR7DsHPWERYsiwn+MhBBLspGTVGHR5AzyzTUlUcXCAtOWb5W0ITCOUPssPZ93WqnKsZsPJVpdLrSTwDjTwqKDlPBA1z0aWh/x6B9YcBeiOKZz+s4c9hmdvKIPtrMP7CNaB1OiHTCWGnA8JnrtqX
 wmgcC+SL
 5t2f8spcYDWJIt2YslyyVTFE3vIYy5wukpnV9bic1v22F6dvFQMhn5jjDoKP1NyxDEdk6O+Oe3i3RsUvS59v5kbqW4TrfnvEja2puPdwJIUjEjSjHHrN7voq9vd53x3wZBtsBkf6/1ufHJJnZ0EzQKFGZQ1VFp1q0cOcE7fyxH+LPhf4a2QrTZ/ZyxBEB/Qers2/SKbC+lTFalUb9UZWawWgmZXo3q75KW2u441CR6LqXwc/UpR/l1DoVs/y+BiBGFmIeau7kJxaTjPgElGKMbaLJEu0EeEB/JyuWWkzICnLtiQSxB93h/QnPdd+eDgrguTpAMmSY1iiZJP8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset is based on this commit[1]("mm/hugetlb: optionally
pre-zero hugetlb pages").

Fresh hugetlb pages are zeroed out when they are faulted in,
just like with all other page types. This can take up a good
amount of time for larger page sizes (e.g. around 250
milliseconds for a 1G page on a Skylake machine).

This normally isn't a problem, since hugetlb pages are typically
mapped by the application for a long time, and the initial
delay when touching them isn't much of an issue.

However, there are some use cases where a large number of hugetlb
pages are touched when an application starts (such as a VM backed
by these pages), rendering the launch noticeably slow.

On an Skylake platform running v6.19-rc2, faulting in 64 =C3=97 1 GB huge
pages takes about 16 seconds, roughly 250 ms per page. Even with
Ankur=E2=80=99s optimizations[2], the time drops only to ~13 seconds,
~200 ms per page, still a noticeable delay.

To accelerate the above scenario, this patchset exports a per-node,
read-write "zeroable_hugepages" sysfs interface for every hugepage size.
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

Tested on the same Skylake platform as above, when the 64 GiB of memory
was pre-zeroed in advance by the pre-zeroing mechanism, the faulting
latency test completed in negligible time.

In user space, we can use system calls such as epoll and write to zero
huge folios as they become available, and sleep when none are ready. The
following pseudocode illustrates this approach. The pseudocode spawns
eight threads (each running thread_fun()) that wait for huge pages on
node 0 to become eligible for zeroing; whenever such pages are available,
the threads clear them in parallel.

  static void thread_fun(void)
  {
  	epoll_create();
  	epoll_ctl();
  	while (1) {
  		val =3D read("/sys/devices/system/node/node0/hugepages/hugepages-104857=
6kB/zeroable_hugepages");
  		if (val > 0)
  			system("echo max > /sys/devices/system/node/node0/hugepages/hugepages-=
1048576kB/zeroable_hugepages");
  		epoll_wait();
  	}
  }
 =20
  static void start_pre_zero_thread(int thread_num)
  {
  	create_pre_zero_threads(thread_num, thread_fun)
  }
 =20
  int main(void)
  {
  	start_pre_zero_thread(8);
  }

[1]: https://lore.kernel.org/linux-mm/202412030519.W14yll4e-lkp@intel.com/T=
/#t
[2]: https://lore.kernel.org/all/20251215204922.475324-1-ankur.a.arora@orac=
le.com/T/#u

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
 include/linux/hugetlb.h |  26 +++++
 mm/hugetlb.c            | 131 ++++++++++++++++++++++---
 mm/hugetlb_internal.h   |   6 ++
 mm/hugetlb_sysfs.c      | 206 ++++++++++++++++++++++++++++++++++++----
 5 files changed, 337 insertions(+), 35 deletions(-)

---
Changelogs:

v1->v2 :
- Use guard() to simplify function hpage_wait_zeroing(). (pointed by
  Raghu)
- Simplify the logic of zero_free_hugepages_nid() by removing
  redundant checks and exiting the loop upon encountering a
  pre-zeroed folio. (pointed by Frank)
- Include in the cover letter a performance comparison with Ankur's
  optimization patch[2]. (pointed by Andrew)

v1: https://lore.kernel.org/all/20251225082059.1632-1-lizhe.67@bytedance.co=
m/

--=20
2.20.1

