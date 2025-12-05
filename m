Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CBF6D32D92
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 14:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FEC86B0156; Fri,  5 Dec 2025 09:56:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6F96B0175; Fri,  5 Dec 2025 09:56:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213DF6B0176; Fri,  5 Dec 2025 09:56:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CB386B0156
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:56:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B424C01BF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:56:30 +0000 (UTC)
X-FDA: 84185718540.15.4B8ED6C
Received: from mail-244116.protonmail.ch (mail-244116.protonmail.ch [109.224.244.116])
	by imf06.hostedemail.com (Postfix) with ESMTP id BBF9918000E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:56:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=XwvPcXci;
	spf=pass (imf06.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.116 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764946589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=383jLSyvcX9dMsFb72iSsTG6CU8UwzEbp05NdSalEfc=;
	b=0WJgH/5ONqj1vqXjneyzMcAHVxIJDply2hvAZvNxrovZtl6tR5Rqx1cc0rSIw6m4AgtwzN
	US9EBRC+6dpMAQkftjxw562vAJ9eCcZpmrwhMGqY1plw8DeCDgsZj+2ULhU/j0JholxkGn
	Gj4jUs8nDF7r6Oj9n++a1QrdgSYIOx0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764946589; a=rsa-sha256;
	cv=none;
	b=c9aBx/RtZ3QdW0zgkRDWeho8L87DCJGtrmN9UREPeKroZCZ/hH+6/pwiNiaYpfmvQF2oI1
	STOcfA/1AsT8+hvPQS/ablAtN9OEgpJsLRFGHBeZvO9MKquKy+NHOcxaTlecsEpZGjBYDZ
	zxMzDUUN5oztHwa2kHRGjQ61OC2C9r4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=XwvPcXci;
	spf=pass (imf06.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.116 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764946586; x=1765205786;
	bh=383jLSyvcX9dMsFb72iSsTG6CU8UwzEbp05NdSalEfc=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=XwvPcXcimdB1jDkUaOzBPCmHJdAw33Pk8z8+cnwHD6kI4tZiQM6nIENGadAjQpOVM
	 VpO/eGmumHQ7+KRsLjmjE+mBAAhZ2KfX5ROINwRuH02lO078LmYUeQDfys1aQU+f8o
	 R0+tlHd07oN/ICFwDdB9wVCDjBgkzJbvXWgBbUebYJJ3lLbtFF01FQI0G2LXbW34S0
	 m7fH2ip/naYmO0n2qmlPXXmys1l3HPfACspOeuRkneiCuGFpJoTUTVKgV0E7hQ9mIn
	 kt+ScDTKmYVb5OcsU77rpPu4wO0F6FrE2JSu9fnWAfRyzBRgEzTVgul6LquA29cP1u
	 z3wPQYrpTEM4Q==
Date: Fri, 05 Dec 2025 14:56:19 +0000
To: vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, urezki@gmail.com, akpm@linux-foundation.org, dakr@kernel.org, kees@kernel.org, glider@google.com, dvyukov@google.com, elver@google.com, andreyknvl@gmail.com
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, jiayuan.chen@linux.dev, m.wieczorretman@pm.me
Subject: [PATCH v4 0/3] kasan: vmalloc: Fixes for the percpu allocator and vrealloc
Message-ID: <cover.1764945396.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 2953a64df10d9b54e8549fd874bdc490c4648bbe
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BBF9918000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: m93yyuhugut46ewi1qjnhq33cbt4yruc
X-HE-Tag: 1764946588-845929
X-HE-Meta: U2FsdGVkX19YEzI26KAmiIssCkH4Fmj+W2aehTgkKpKjlaGS9G/OxZRp51n59zXCSVgJaWnzxON93cD8BQ08Zoeo31Bmcfimwtv+h9FWePKU7hxYrUhfb4cEkx91Un6YD+xv582Qsxl6NlA5buIXExERy/QclIScqjn6ueR8fz78d42xoFDsyIa5ZffJt34KLc0BmqKIXFBpkm3w2wdXsL3TTdNiHl5YnxHP0yG4tCRvc75JG3dZRmQmt0BWf5I8XBZuma3lGFCT4QfTftCBs/M6NHvN8iHPcd/Gkeb36JCPGngol4qMbOna2kVRXraiDZsyv2BVmiitl66jEbdMsirED+KkuWm7nr7mkm8I7QV41psM3H83mdg9F/gDy2kPlYyMthGxokLi/GF+fJK9AA7NA/eUF9kOG/Gc9PcdrF2JFGaFozrwiCoQxuaKHSfxJ5d4VPsKeQghu02HtPxA8PabdbHHvBACtjOVB7NaQXwBLbpN//hyVbm9TiiiJU8iHH+Wi1kUK6VoYonlyOF7TMkpV0YF4qDh2zFl2j3Z6AQlKP6snIoL1jZjul2g/d4o8qCEeiDLcQJO4DjOsTh70KxHB141fEakpdMDKHabyXmYEUjy96/x6zA7OCKkKHszT0sOWNLsvRpcCt8QzrFBshQ1XkPirl5TkNW55/Jnsv80mrntO2ACDMMbmn39P7N4nI4OtG4JrX5aoKHJlA1NxrxfqlnuIDycEybAsb2KJxGb7/vRKJ+ohxQ8Kh4WxiTdTvFVFxwK6m5OCAUSbH3T6hOR88Zwu4oW4pD1QqydNJs5uzGw5NV4n4UOXZdSi9UFcdBr83PIn+ilJTwJ4LRLa4FL4AscQypA+k/aovxad99567JKXfQnPUDPIxs47Ae1+IJp+VhM0hAP5HfnUVcCBkq02w3oo7WL
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

The series is based on 6.18.

[1] https://lore.kernel.org/all/e7e04692866d02e6d3b32bb43b998e5d17092ba4.17=
38686764.git.maciej.wieczor-retman@intel.com/
[2] https://lore.kernel.org/all/aMUrW1Znp1GEj7St@MiWiFi-R3L-srv/
[3] https://lore.kernel.org/all/CAPAsAGxDRv_uFeMYu9TwhBVWHCCtkSxoWY4xmFB_vo=
wMbi8raw@mail.gmail.com/
[4] https://syzkaller.appspot.com/bug?extid=3D997752115a851cb0cf36

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



