Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F176BC53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAAA56B008A; Mon, 27 Jul 2026 08:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5BBB6B00A3; Mon, 27 Jul 2026 08:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74196B00A5; Mon, 27 Jul 2026 08:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 982DE6B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:35:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29F541C0EA8
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:35:08 +0000 (UTC)
X-FDA: 85034501496.13.6E1CE26
Received: from va-2-115.ptr.blmpb.com (va-2-115.ptr.blmpb.com [209.127.231.115])
	by imf08.hostedemail.com (Postfix) with ESMTP id 94D2216000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:35:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mQ0lGolf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785155706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9x9VDbOxUNOBcTgPJT1SeUai6ki6VgAWRhEIjunYZb0=;
	b=juDrhr58DC46F4MzQa5F8u5xOk1JXXz1dFv/riOJkwGpWVVn5yVtYqRJAGfhxV/YYx49px
	PzbdP6q5Nwn109xN/CNfNc7THvXbP86w5Gnknb9a3WhkUuzfvTceyQHGIK0COwvgrhOF5l
	oaLoqa6RqHSkWbtzMm7RpjSz22yW0ZQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mQ0lGolf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785155706;
	b=E5izmzTKdkBJJ3OzmmKlQRdec7o0fFVQ8BDoys+mhOEjzNCLn++Yw9jBb6QmWMFMdxJWB3
	bzyW1gxR+X7cZO0Kdg38Mbz7/MEaCWh8j+d7Q9TqmYTmXQv3Cn8G5YAnLPxhAbGknOQHX8
	E3SkQgH3NSYyD+lb8+VLCU1jZFqnNVI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785155699; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=9x9VDbOxUNOBcTgPJT1SeUai6ki6VgAWRhEIjunYZb0=;
 b=mQ0lGolfNPRS+8yxwe1mks78nl7+V/0Rcp+CGjd/70NEui/nBX86CFcGE3ewDiR28q18V9
 d3j2M+CyH3Tp3s2RjzYsOskA72ya6K7Tyq3vgmYC30a4bOdaCzCRyr2LRnzNFajet9qGyO
 RYEEC9hL6A9cnJf8Y8Xe7VgGwn1UV96/e8vN5bA5sdeWzc9WYkrsxx01Jf0fllHrAawYOc
 Jl72KvuLcSGyf9u/9tVhQRb485471Qx6IOihYVFSNZq8O8YxUSTxMbwGaT5igGkhk2NBmh
 GFDPJfgbYXWR41nohvFwe6V0zI/Mbnhq2M3VO4spVXBd7eA6CFKo/zZpyEnnQg==
Date: Mon, 27 Jul 2026 20:34:20 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a675071+887eff+kvack.org+lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Content-Transfer-Encoding: 7bit
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v8 0/9] mm: optimize zone-device memmap initialization
Message-Id: <20260727123429.5673-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 94D2216000B
X-Rspam-User: 
X-Stat-Signature: xxcpk4ad4hgwndatrs4so1c9dbipbpca
X-HE-Tag: 1785155705-456024
X-HE-Meta: U2FsdGVkX1+6tG5yZqQyN90joAmiOJvv79YBsIsrDfGRGcUx9fWb0ezh8wef6moTExAlLhERcELSylOdM1Zdk1n6nkeLLl8LLWRnsgwBkpGZe4e8dBihav7C7wmYySBBDzb3U6xmC65RfiXBf9/Hw4Zbbx9/DH5VVZI754nLmmxnmMIpJun1KD7zLT/mpV11N+TB7yuFwIXRJRtf9DyulO1q7evN+5KF/5tounSCQDpcSNIYxBp/FCCBG7fzDYS8Oaew6Q+tqcVPoR6lkbLwl/EoY8AJWN9/1QFGn5Mh6aV0GQGJkEL7Nn63mNMhtFHiUvI9H1rLtMsGCmip0hWRISGPCekLTVvmJcr7q+XjDUNPcvS6LiahzAehHRLxNNVR0atpXSyC5qcVepV+gq0emA03Qkw/zb/Qx+mDSclnZcIOQejHQMQEl+bcadDLUB37PQzw98QBDbY34/jwDmFpNj3yZXnNhv5vr4yO32zpjhrZSMqSZ4+BiToZzXW+s8u+6uhu7qVF2vvYuoVm0WSycJPw8BUxyu/6VJrZ+8Ba23D4LMcazrErzB+ntD1u0aKcPNr+dwHK2cJD318q3cnf20B191qvBbiAKXXgJpTio3uU0zR7gPGUQ9kJLV8EGgSpq/HITT0dRESQwLALEBZtHgR6RCGJODNlJ/jRsp3VhKF5czTAWFyoAK88vnDxdJoilXEMoRpWlID1fffElNkPcxF4LaKwRyZu62kJF4nkv0In2/7SmDqBdJnnl97+6fchS+Wo5H49ymVPABsFYXpruQFxKbEXAcBBG+9IwdsjQ0IFM7FWUPtkzKzP118Q3+WMAC44WVhIoVpbh47eEO5xP0OjO62FU4QxdqFcJtEV0rx3nXgVfxexgawzm8iQc8GLF2TFdBOxT0xm5RWe83kCCGGGUhFTV5BoKXA4JZWPOfGW/JcM6Iz3fni4CUCzZamExdrxBJo08E+v5fsQrZD
 oTFPlLug
 Lv4wkdt3X94fDx8+s5ej+1VoRxfopcQ27cHiFBpO8Xj2lwtM7yojYKIzVJ3rkzi0irvlxSmvCiy44m3opG9aIvxo7rlJ6iq/KtD8WXdsYNrf3QiKS+Bx6EwleXc5Junjs5ctfrlSjztYjZjN96WMjTokdoh8LM+K8v6ZV9R3NYRaKBjxTiFxLvUEvbNkdCbseihYKvE+RZGFJMh78yf67BN0EVScCAi2Sku6q600I9HldiKdBB65FEDOWTF16n4VPwGXinVwWqu5taoBWTx9Nn3zWig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() can take a noticeable amount of time when large
pmem namespaces are bound or rebound, because it initializes nearly
identical struct page descriptors one PFN at a time. This series reduces
that ZONE_DEVICE memmap initialization overhead by reusing prepared
struct page templates and, on x86, using memcpy_nontemporal() for the
template copy path.

The main target is large fsdax/devdax pmem configurations, where the
cost of initializing the memmap shows up directly in nd_pmem/dax_pmem
bind and rebind latency. This matters because the cost is paid in the
synchronous probe/bind path for large DAX/PMEM ZONE_DEVICE mappings.
Userspace workflows such as provisioning or reconfiguring
nd_pmem/dax_pmem namespaces, bringing hot-added PMEM-backed capacity
online, and recovering or rebinding a device after driver or device
changes all wait for this initialization to finish. Reducing this cost
will yield benefits as lower user-visible provisioning, hot-add,
recovery, and rebind latency for large DAX/PMEM devices.

Patches 1-3 are preparatory cleanups and helper extraction. Patches 4-5
add the template-copy path for head pages and compound tails. Patches
6-8 introduce memcpy_nontemporal(), extend the x86 fixed-size
memcpy_flushcache() inline cases used by that helper, and switch the
template-copy path over to memcpy_nontemporal(). Patch 9 removes the
remaining local opt-out predicate and always uses the template path after
the first real page seeds the reusable template.

Architectures without a specialized memcpy_nontemporal() backend fall
back to memcpy(), so the template-copy optimization remains available
without arch-specific support. On x86, memcpy_nontemporal() maps to the
existing memcpy_flushcache() backend and can use the fixed-size MOVNTI
paths added by this series for struct page sized copies.

The numbers below measure the time spent in memmap_init_zone_device()
during driver bind/rebind. They are not measurements of the full
nd_pmem or dax_pmem bind/rebind operation.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.2-rc1):
  First binding for nd_pmem driver: 1456 ms
  Average of subsequent rebinds: 244.28 ms

  First binding for dax_pmem driver: 1462 ms
  Average of subsequent rebinds: 273.31 ms

With this series applied:
  First binding for nd_pmem driver: 1272 ms
  Average of subsequent rebinds: 96.79 ms

  First binding for dax_pmem driver: 1354 ms
  Average of subsequent rebinds: 119.04 ms

This reduces the average memmap initialization time measured during
rebind by about 60.4% for nd_pmem and 56.4% for dax_pmem.

As an additional data point, I also ran a smaller set of measurements on
the same physical x86_64 host with a 100 GB PMEM region created via the
memmap= kernel command line, configured as fsdax and devdax namespaces
with map=dev and 2 MiB alignment.

For brevity, the individual patches keep only the VM results rather than
including a second set of physical-host measurements throughout the
series. The physical-host numbers below are included only as
supplemental evidence that the same optimization also provides a similar
benefit on a non-virtualized system.

Test procedure:
Reconfigure the namespace mode, rebind the nd_pmem or dax_pmem driver
once, and collect the memmap initialization time from the pr_debug()
output of memmap_init_zone_device().

Base (v7.2-rc1):
  nd_pmem / fsdax: 179 ms
  dax_pmem / devdax: 264 ms

With this series applied:
  nd_pmem / fsdax: 82 ms
  dax_pmem / devdax: 113 ms

This reduces the measured memmap initialization time during rebind by
about 54.2% for nd_pmem and 57.2% for dax_pmem on that setup, which is
broadly consistent with the VM results above.

As another supplemental data point, I also measured the test_hmm.ko
module on the same physical x86_64 host, using the test_hmm.ko setup
from the previous discussion that times ten 64 GB
memremap_pages()/memunmap_pages() iterations during module insertion[1].
By default, module insertion initializes two DEVICE_PRIVATE dmirror
devices, so two avg memremap values are reported; each value is the
average for one 64 GB chunk.

This is not the primary target workload of the series, but it exercises
the same large ZONE_DEVICE memmap initialization path and shows the same
direction of improvement.

Base (v7.2-rc1):
  avg memremap reported during module insertion: 116689362 ns, 116539263 ns

With this series applied:
  avg memremap reported during module insertion: 54607108 ns, 54458236 ns

This corresponds to about a 53.2% reduction based on the mean of the
reported values, which is again consistent with the pmem bind/rebind
results above.

[1] https://lore.kernel.org/all/aiEoByaQdRR3xtM5@nvdebian.thelocal/

Li Zhe (9):
  mm: fix stale ZONE_DEVICE refcount comment
  mm: factor zone-device page init helpers out of
    __init_zone_device_page
  mm: add a set_page_section_from_pfn() helper
  mm: add a template-based fast path for zone-device page init
  mm: extend the template fast path to zone-device compound tails
  string: introduce memcpy_nontemporal()
  x86/string: extend memcpy_flushcache() fixed-size fastpaths
  mm: use memcpy_nontemporal() in zone-device template copies
  mm: always use the zone-device template init path

 arch/x86/include/asm/string_64.h |  68 +++++++++++++++-
 include/linux/mm.h               |  15 +++-
 include/linux/string.h           |  13 +++
 mm/mm_init.c                     | 131 +++++++++++++++++++++++++------
 4 files changed, 199 insertions(+), 28 deletions(-)

---
v7: https://lore.kernel.org/all/20260720120259.1545-1-lizhe.67@bytedance.com/
v6: https://lore.kernel.org/all/20260709112520.24857-1-lizhe.67@bytedance.com/
v5: https://lore.kernel.org/all/20260701090553.62691-1-lizhe.67@bytedance.com/
v4: https://lore.kernel.org/all/20260603080152.64728-1-lizhe.67@bytedance.com/
v3: https://lore.kernel.org/all/20260527033636.28231-1-lizhe.67@bytedance.com/
v2: https://lore.kernel.org/all/20260521040124.10608-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20260515082045.63029-1-lizhe.67@bytedance.com/

Changelogs:

v7->v8:
- Make the generic memcpy_nontemporal() fallback a void function-like
  macro, so the API has a consistent void return type across
  architectures. Reported by Sashiko via Andrew Morton.
- Clarify the cover letter and commit messages based on Dave's question
  and the Sashiko review comments relayed by Andrew.

For changelogs of earlier revisions, please refer to the v7 cover letter.

-- 
2.20.1

