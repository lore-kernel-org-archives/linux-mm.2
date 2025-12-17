Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D52D65C49
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 13:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85BCD6B0005; Wed, 17 Dec 2025 08:48:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D916B0089; Wed, 17 Dec 2025 08:48:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766BD6B008A; Wed, 17 Dec 2025 08:48:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 641546B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:48:53 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 029E1136F0D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:48:52 +0000 (UTC)
X-FDA: 84229093746.21.7D6470D
Received: from mail-43101.protonmail.ch (mail-43101.protonmail.ch [185.70.43.101])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1B7EA1C0002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:48:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Q6rcfmRS;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.101 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765979331; a=rsa-sha256;
	cv=none;
	b=MZPbZeD0tFRZkEoS3jwhI4aN7EqKnVtrogoSVt528wcw1UOjl/c5wshP8biDoUV8unGykY
	ZXu3LAyTeD4iEf2PfCE1e70PY6KEoNrZE2OXF7xcdqdrmSttBPZCYL2/BrCDzlu1dte+dy
	xTXDW7NRcVhNhekAYn+zUc5EY0FLnhY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Q6rcfmRS;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.101 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765979331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0jXeP64J9NWSfjxyXFi/0TIVi8GX+FvR7ErLahIOjKs=;
	b=3ahpfsvzdO4/ltuI+FmbvEe+LeURiTGyq4TNfubx6GfZgInSvx7NETBYKs7l8tpZdWzpNB
	Rtapf9LqtvsUjlo5skIW6OnLrZE3uHQGz1l4x02nId3/+UzDXwvZVCQrVRl8OQ2hporpsq
	xXxyCWcAe53PS0PugIGVYSMNKx7ruQA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1765979329; x=1766238529;
	bh=0jXeP64J9NWSfjxyXFi/0TIVi8GX+FvR7ErLahIOjKs=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Q6rcfmRSC/AIPuIGesUV+byki77OMlY2Hrk9xgcJumpzywimv5+/Sz3qmoLlrxkMf
	 8RVN3C2YHHl6i8hIgmMz2RviNXg0y1QD11Lb3qbFbtKz+Z9eDLJ9ErDzK8dS+xbsOP
	 v6ujfX4VQRlMhIC45kHXlU1oQSBHfrdOsL2qvNCAkoQVXhUW6NrbAtgdSjvfBFYfkN
	 w7Up/fqjnB7QeUtFY9UaIzIaa98698YbuoKzG/g9CXK89Kdpvwjh0SSjAgzVLy2gA+
	 ACr5O/q6cOojfaxeJJlkFqa7C5HmPkqsxqbUOOhdTawb03D2l9CwDt0onCZ2ArEFDh
	 kRF+1nSgo9hWA==
Date: Wed, 17 Dec 2025 13:48:44 +0000
To: akpm@linux-foundation.org, urezki@gmail.com, kees@kernel.org, elver@google.com, andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, dakr@kernel.org, glider@google.com
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, m.wieczorretman@pm.me
Subject: [PATCH v5 0/3] kasan: vmalloc: Fixes for the percpu allocator and vrealloc
Message-ID: <cover.1765978969.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 23204708c692a2f57662abaccff2e44189916c62
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1B7EA1C0002
X-Stat-Signature: 4a1yxgzcxiwwzcx6cfxyhd4uyngftrsz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765979330-745916
X-HE-Meta: U2FsdGVkX1/JNexo8FZ+Uo1HcOLyQqLYHQmAomLl03RB6zVwQqm/a8VAZU0xpilE//rENiNMOnDEY1uPoB3S2S7ZH8Yn7mZAVcTsnkwHSXx5talzbQ86taCfMz08bnOOgWl02HTmJXQEw/SIyjSrXqhrV8+BtfyyQseRv1afs/uvjv1rwaVy/cY7jORQP8JijAv2S3/KKPeqsD5luG+DB2Kp47f4c0o0qH3waHDTebp+SoW3Yx+AyqFpZoF0BhVn03YwztvyAyYCla014K0e9nzOugyYh3FPbXAp6/zh3e0NFcCdxAdkHPU6Ky9E8yqzE6gGaahND/r0GDlUUoUa5mgiFbzjKVzs2bGn7OweqGzDrSvFDPA6eROKjnMuthVlinD6YmTE07AMtLfIzky7JkCULHg9VlazPKa9T29Wy1zvDe9Wuf05p6fBL+piB5xMDhtqMjkjWMMDYolvj7sHj56rdWBNE1NFqiisV1wYInFTEcUeZCaJFqltrhlJKtdnjXMrM0R139r3/5N30+qHgQ6WgYX11p0v5W9QUAGnrvdg+4jIYjhR4M5J/qRxswdJQoYpgqGobjNyZ5tWHvUsvLlJAQTQPcPnvUn7eno1Iqd8r1td8JP4ot+hvRkBmMoeVzauu0m4yPgaCATizCWRqMUMzmfIQoyzGYf7BZsWPeRU0V8h7RLUsXuQ8Ow8b2ND+Mt+rLDGtDkA5i8uG6Ib5dHQtX1vGCXhy8JlSOvRDYa4UQtFZJX792dR2YPdj05A2AjdA84uJJj9K1PNQFcc5G8oYGloqlMPrAQ3wDks4RIbrCGnJ0mE20r+R3kXNxMau3HWFTLNCdrUEQKtvufExS5mceWc5CnLkGcYGDaU7aj2hKWpuz3dLmydKJgEH2AQEVYkY/yiOjrTQIPxoSCX4JiIyideN7Z1XGtSWAEg1q4J6wuNhCVJeyBg/iXcu4LtOSHfRqs7tt5hBGZgUVF
 GBJ1Buno
 6yEqyLvSRmR6BAz0lK9feCb8frFIyN9Wjk6RSzHs4MtSGVLa8JwwGng5Ap/FWaZp+GdWuOipqoDTALjRFK2LLKthh7iQuV6ry8TPtHv4aTtD+LzXQWTk7MwuW7KiXuD7uVUYGdecU20B3fET5/FqpRQmFt9dR0+/N8WK+hizJCE4/VaEnoUtNO2qQAMU/AzaezXBWRqHeJinnW+/qbdgtpEvvGqRlQNdPOOKYfJ0aYeozVt0AQaUXlLO7WC/bypTbpw+54gqk7G5hNXnqfdtq37H8jZTtehXwNBXZtJ1sqFIlGRBkyGlT2sLek2MxX0WAzFk54qp3GF8/yCPwR2SD7Ub4ES5gbxXne08eC7EA04HCiqTzgIdQLjeLTcC7GrYYlX8rfOkDpy4oYXTQMooJpZSV1etlyMuL/Y+a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patches fix two issues related to KASAN and vmalloc.

The first one, a KASAN tag mismatch, possibly resulting in a kernel
panic, can be observed on systems with a tag-based KASAN enabled and
with multiple NUMA nodes. Initially it was only noticed on x86 [1] but
later a similar issue was also reported on arm64 [2].

Specifically the problem is related to how vm_structs interact with
pcpu_chunks - both when they are allocated, assigned and when pcpu_chunk
addresses are derived.

When vm_structs are allocated they are unpoisoned, each with a different
random tag, if vmalloc support is enabled along the KASAN mode. Later
when first pcpu chunk is allocated it gets its 'base_addr' field set to
the first allocated vm_struct. With that it inherits that vm_struct's
tag.

When pcpu_chunk addresses are later derived (by pcpu_chunk_addr(), for
example in pcpu_alloc_noprof()) the base_addr field is used and offsets
are added to it. If the initial conditions are satisfied then some of
the offsets will point into memory allocated with a different vm_struct.
So while the lower bits will get accurately derived the tag bits in the
top of the pointer won't match the shadow memory contents.

The solution (proposed at v2 of the x86 KASAN series [3]) is to unpoison
the vm_structs with the same tag when allocating them for the per cpu
allocator (in pcpu_get_vm_areas()).

The second one reported by syzkaller [4] is related to vrealloc and
happens because of random tag generation when unpoisoning memory without
allocating new pages. This breaks shadow memory tracking and needs to
reuse the existing tag instead of generating a new one. At the same time
an inconsistency in used flags is corrected.

The series is based on 6.19-rc1.

[1] https://lore.kernel.org/all/e7e04692866d02e6d3b32bb43b998e5d17092ba4.17=
38686764.git.maciej.wieczor-retman@intel.com/
[2] https://lore.kernel.org/all/aMUrW1Znp1GEj7St@MiWiFi-R3L-srv/
[3] https://lore.kernel.org/all/CAPAsAGxDRv_uFeMYu9TwhBVWHCCtkSxoWY4xmFB_vo=
wMbi8raw@mail.gmail.com/
[4] https://syzkaller.appspot.com/bug?extid=3D997752115a851cb0cf36

Changes v5:
- Rebased onto 6.19-rc1.

Changes v4:
- Added WARN_ON_ONCE() and removed pr_warn() from last patch.
- Added missing cc stable to the first patch.
- Fixed stray 'Changelog v1' in the patch messages.

Changes v3:
- Reworded the 4th and 5th paragraphs after finding the vms[] pointers
  were untagged.
- Redo the patches by using a flag instead of a new
  __kasan_vmalloc_unpoison() argument.
- Added Jiayuan's patch to the series.

Changes v2:
- Redid the patches since last version wasn't an actual refactor as the
  patch promised.
- Also fixed multiple mistakes and retested everything.

Jiayuan Chen (1):
  mm/kasan: Fix incorrect unpoisoning in vrealloc for KASAN

Maciej Wieczor-Retman (2):
  kasan: Refactor pcpu kasan vmalloc unpoison
  kasan: Unpoison vms[area] addresses with a common tag

 include/linux/kasan.h | 16 ++++++++++++++++
 mm/kasan/common.c     | 32 ++++++++++++++++++++++++++++++++
 mm/kasan/hw_tags.c    |  2 +-
 mm/kasan/shadow.c     |  4 +++-
 mm/vmalloc.c          |  8 ++++----
 5 files changed, 56 insertions(+), 6 deletions(-)

--=20
2.52.0



