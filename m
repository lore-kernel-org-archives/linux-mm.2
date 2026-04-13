Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB144F3ED79
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 11:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17BDF6B0089; Mon, 13 Apr 2026 07:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12CD76B008A; Mon, 13 Apr 2026 07:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042226B0092; Mon, 13 Apr 2026 07:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2ECC6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:39:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C4BB137CEE
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:39:50 +0000 (UTC)
X-FDA: 84653338140.07.AA3B6BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 036E81C0002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:39:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RJ4fofg2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776080389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MUKjuQvDkwfeVHkESJ0E0SLjtPWrwdpHYBMedV42rgQ=;
	b=HNTDTNZjuefW4pU9fC/YEj4KLz3AiU+OKv25sveDJP4KmLXQjiwbs75xS/74b37/OX8jaU
	fXyN2v4ktJOfcdWVCaWqIPE0ZaBlBFWsshGnvnU+LP7cKOQx65LXJoMAtVIzQ1hN0gZaWa
	SfMT6pp+BcEM2L4FdVQ6cvI5/9ADDqk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776080389; a=rsa-sha256;
	cv=none;
	b=GxW1XQEgtbFDWAPaCp1GJ0Gaqg2+K5JkquQ20cmBUfgGbTdMK32F6RQwtJKTr1q6AwAtzg
	u/+z2Mj5OQ6MxK+xFT8nvYVu0evnjr19m6iNOZfYh/w+nh5mQhZSAEiO1D1tQnCBEma5Ae
	jrMMIwGFMBSTRllfVoUPbFBeqsKigac=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RJ4fofg2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C38E60172;
	Mon, 13 Apr 2026 11:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F733C116C6;
	Mon, 13 Apr 2026 11:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776080388;
	bh=yqHfFBHwS0Jdv4ZpGR4r2n7K28qdrVknwXUSckXWjJA=;
	h=Date:From:Subject:To:Cc:From;
	b=RJ4fofg2jOQ6Z5UadIlanaO/Xz8hKOCT9y92QLMeMDgY3PAbcPrSlKfmy7Z7auq95
	 93ZQW4Rd8r7oxTBiQ4e/bOK28n553q6c6LgiedgHT3FYOV+ShevE32Jmxo/cEbhyo0
	 k/oC6QiSyJq6Fiw9TNM90CYXWVVZRSxjcfZEbdOK5RWWIl7fKN+fgcC3HsGtvpuI50
	 lZjybfZXh3Ybt2LcX2RQL0JsuFNvVQtDA6TNfvr9MR5QlXW+n8I0HxJ/5D2A6/1kCM
	 bhOJJ034HrMov8xc6ru0oHecJNqDX2S98Wmd1AlT80fMuSV1IsZY5VHGHTGgLY+B5U
	 0pyVMs+fCFFtQ==
Message-ID: <db0210a9-0bce-476b-920d-7e90f54fe72b@kernel.org>
Date: Mon, 13 Apr 2026 13:39:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] slab updates for 7.1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 036E81C0002
X-Stat-Signature: n7ubp5bpkomenair7xmne8xewth6u9kr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776080388-742651
X-HE-Meta: U2FsdGVkX1/J+4TM5jYxWiM9qMp28r+fhATa7w3XzTaTMIAs28zyggeLPfYytWNVqZFCl1/c+kbBP7vyQEk7XawUM60/LkCzIAtt8IcuuVvt5kscL7bXZGNCYCHjypIA1dQvGfo1ZR9PgjHwPI18Gc/uSVppUYCUVy+ryTyv95Eq4iXsx4Rd9ulN7ipM2dnfnKo3bCVRhYPbqdvB+I8BeKbgngKDRYiIGcbOkdK87iXqgyTgR9gexXNtSI4KeSOP5itLKFr9zLk1iYqzaSB66Ln8m+nlHHkJzsPZD5kplnaIo1rUzxtHBVYRAJ2ewvCb03oYeY8cBKUjoiYpeHaQY+XvNDw3eUYdlrCeiBRG8FcUvn/ac3NPEtGrhs1q/1yBuipVX298APsqb0TyWODftBQPs6eUlOPIbMTOq4wZg1goaTKWmq+uSYUs1tkdghRqI+m6TEQk4quMY2groRZ8eYBeM/oPPPYQn+It+2pivni0eTFWR+Vtfobj5QYohKozNcbc54p2wHUVmibVtFzvBBKbUhbqkMnQJRrKSy/Y/XoTqxwjRpKWRSzfnLb1xsHqL/mVYtJT7UYcMD3iKjWx9xPImkB4vaQwfCCAQxbxwGt1iuzQumPU7BxIuLFDnyPTkvg7UZsJ4paoktCdCVmKf+0H8kFAqwRe+idEZZaNrBHGXziwkk7ZJRy6p8WNDhRrKCGCJiTP6pJ3HK+T5kor8Xyx07HOY3hFV7loHuOt/18rHVMtvLpLjfyB7aozfABgCK6E4lgG4a4sZJ13bf6SHiL+N5VIz9e3+towGEsq2I0mT5h/Ia08HrqQYbBRykGi9EjNah9tBaCcrm9S9I9LTqDo7bBWt9IDU7kfz234vT+9gzmWf08C18hcC0U96qhPxiTsJP+c3dAUs1I/SCTdJh30fS5pLELsE4AgaUcEdh+s7TkRCCGFgkhSH4IDM0Wh8weF3BCshAz1FlNDzn/
 dFo3fIeX
 0dGEGnajTfCutJdX3MO+4aXDGyBdW5jgexTNw7TZSiqSPHsCp8RnNWrurx8r+3eQs+Ag8W4AlDHva4xZudZjQWOZSD2Xmj+w1nJZFan8DxIbqHCrdpjlMEc167bp1vt/E3pUx5yR50yLQeVlA1fPDzGb0Za83FU31k9N0MXdhcf1nYevAneOc4s6A0yEfaou9KcyXpT4d07pkTDF70ky0aBIICZ1WLmBKCvFzsCNmP6xER7wamfhgdHIceWZG/vDukWHmEzibT3UOD2xXH4bUsKMNWf70zFWP4taXp1l9F5RI/eK3KqX4IKOBgVt0lXoWipfaxm3K8YYjMQITkB11H4Uxww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1

Thanks,
Vlastimil

======================================

- Sheaves performance improvements for systems with memoryless NUMA nodes,
  developed in response to regression reports. These mainly ensure that percpu
  sheaves exist and are used on cpus that belong to these memoryless nodes.
  (Vlastimil Babka, Hao Li).

- Cleanup API usage and constify sysfs attributes. (Thomas Weißschuh)

- Disable kfree_rcu() batching on builds intended for fuzzing/debugging that
  enable CONFIG_RCU_STRICT_GRACE_PERIOD. (Jann Horn)

- Add a kunit test for kmalloc_nolock()/kfree_nolock(). (Harry Yoo)

----------------------------------------------------------------
The following changes since commit f338e77383789c0cae23ca3d48adcc5e9e137e3c:

  Linux 7.0-rc4 (2026-03-15 13:52:05 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1

for you to fetch changes up to 44e0ebe4accd67c67134cf3b805917153041a300:

  Merge branch 'slab/for-7.1/misc' into slab/for-next (2026-04-13 13:23:36 +0200)

----------------------------------------------------------------
slab updates for 7.1

----------------------------------------------------------------
Hao Li (2):
      slub: use N_NORMAL_MEMORY in can_free_to_pcs to handle remote frees
      slub: clarify kmem_cache_refill_sheaf() comments

Harry Yoo (Oracle) (2):
      MAINTAINERS: add lib/tests/slub_kunit.c to SLAB ALLOCATOR section
      lib/tests/slub_kunit: add a test case for {kmalloc,kfree}_nolock

Jann Horn (1):
      slab,rcu: disable KVFREE_RCU_BATCHED for strict grace period

Thomas Weißschuh (2):
      mm/slab: create sysfs attribute through default_groups
      mm/slab: constify sysfs attributes

Vlastimil Babka (SUSE) (5):
      slab: remove alloc_full_sheaf()
      slab: decouple pointer to barn from kmem_cache_node
      slab: create barns for online memoryless nodes
      slab: free remote objects to sheaves on memoryless nodes
      Merge branch 'slab/for-7.1/misc' into slab/for-next

 MAINTAINERS            |   1 +
 lib/tests/slub_kunit.c |  92 +++++++++++++
 mm/Kconfig             |   1 +
 mm/slab.h              |   7 +-
 mm/slub.c              | 351 +++++++++++++++++++++++++++++++------------------
 5 files changed, 322 insertions(+), 130 deletions(-)

