Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C27D29FB0
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 18:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AA866B009F; Thu,  4 Dec 2025 13:57:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033F66B00A1; Thu,  4 Dec 2025 13:57:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65536B00B7; Thu,  4 Dec 2025 13:57:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D234A6B009F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:57:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61ADD16027C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:57:56 +0000 (UTC)
X-FDA: 84182698152.10.980A8B7
Received: from mail-106120.protonmail.ch (mail-106120.protonmail.ch [79.135.106.120])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6567A2000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:57:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=UWp8vROk;
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.120 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764874674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ltaZZFKeOqkudCnNBawaeUoF6+LWTp0Fb4Ul14Ym3zU=;
	b=Jp0cHCGh8xbszL5hL+jEhkJT+lxLdo4T3zql43/cDCWcaxadY5T0yi+9u/KTBxdAsyx5Ty
	PhN1Pol+8SzoWgKP5erzeL9rQS3GInAmgqkUsrPJYWns7TT6RezKr+0NHc7WDhI/1saW+c
	7PMJNfVCs64HEfhn42+b0FMlsoCuFHQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764874674; a=rsa-sha256;
	cv=none;
	b=JoZobs8/8vD7tFV8w+4JwPWCGlYoV+FDHovGSR4lexYsRBXwZlVIjVB6LK/Ho4dAP4i32d
	aBgaqvJqA4ujo3LaUoK6J+N/FOEjj2yy6PxPJg4H0pk8uU/AzmnknPGVk7maLGHPpYbMcR
	XzWaWFrkc+5KoUxsqdCnTT5KoQZlO8M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=UWp8vROk;
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.120 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764874671; x=1765133871;
	bh=ltaZZFKeOqkudCnNBawaeUoF6+LWTp0Fb4Ul14Ym3zU=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=UWp8vROkeQwXXPNCN4cMl6Py/Z76xUryAQvwOnFW+1c4ZVzQIWZENgMnsSgb8pY4m
	 BFMcTfSTCGHdgKJZxqJ+9eAHozzNxYrniwLbq58oV8Cf/d5M81cD6O5wEiEy7mhe8L
	 jcXY8TUA07YodU8FulvRD0Cy+ln1FrNlXMkC/6u0H4WxPkMZHPhHnH8ZfCpIJP7eAC
	 m/soRU/Sb3S+ujKT5SWdY6wJbwaLVqbRTQDwmZe3Dj6hoQw6PvkwS+zsR5yxgKBw1j
	 wydxLbNYpc2vGK406RAZhrbaRhnl5v2qkyCkfwcY1ePv7nq2Hz6Dm9R6wf2/B4cohW
	 Nud9BPWKZY4Lw==
Date: Thu, 04 Dec 2025 18:57:44 +0000
To: akpm@linux-foundation.org, urezki@gmail.com, dakr@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, andreyknvl@gmail.com, kees@kernel.org, elver@google.com, glider@google.com, dvyukov@google.com
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: jiayuan.chen@linux.dev, kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v3 0/3] kasan: vmalloc: Fixes for the percpu allocator and vrealloc
Message-ID: <cover.1764874575.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 40cdbf8e09bda976df8874685f1eeeae05616409
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6567A2000B
X-Stat-Signature: hbwmoophwe6kd5bc7owbh54s6minhe9z
X-Rspam-User: 
X-HE-Tag: 1764874674-237505
X-HE-Meta: U2FsdGVkX1+Sh/onWJlM5JK+Ie4ZhpnPA0oCgjiSlQo6AtU8h1xkcyiIbEmyknwvpnR8aXStGgCvXdsoCt9a64skULjoyB80+6MqeBewE4LrACKc7YexQPCAYzmcveh6JZsdyWxrChVpSfgvhevCcqOiuwpQqpA6p/j9oNlp6q2uGoJtd8jLj2RGTlQBlhy4logFMpkS2HNHaIv5gHoAglmPYthuqCdF/7lH6dFAQUWFcJ8lJvbXvEejQmglPIdxjC+dE5pxYd1YXIAJSg4xlirMbn2Xk2UooOZtw3CtggoO28yNdMXT3vwuGS7r4Ph1pkLTyrQKsMShf8shRd291kFb7KYrSYBgE7wJHhBssYFKFWdINGVYpOCOfsuAJRSBAJ7UDiwpQkttu7rwRQx1vIB+d5+O+SYqVV5XOShx5AuRJJJkxI3wISUNUeKRFFgJd5mz1Ao4rzDIMCzsnvBwuLGqydV4DxZ3PcqEpZQwljpT1lgNp/TdTK52jf2bGg0AB1YupM1TuTn9ksPVRTDPyk8C+AK6Xn+tux/sTpnroMhlFM1mWji9hCtsGQc77jcYZZ6VTF/AqmqnXzvmuonzv/M2fbOw4FUcreEiG3RMadR7lprsKrc59QwhGgNPVXLZCJw1LOqbnczL6rZvN0Ai3lOx3cXX8qdfev5axcf0tPb4EgoJz7aV5ygG8jJ/H4E8p9oIQnHmpmA/LFG3c2eVFM6Th+HN7k57bqJvOFogWcWZGp5O7h4wv1KLmRD8Oqc6J4+LNSsM1FkCvZCYgtIyDjjY/grfY/DOaMgfHfAElCTcqB8ikg+18+dBzInHztuPbCpkaZue36OI2ljZBFqxRArKJQqn311XzYqumMB3fmO83oMAe7H9YM9LKnSq7Y5Mv5aF8ogtfHFRnRI9oPtSQvBHyNolBByhKgOmC50w6VBbzol506+O/KtTUX5Kqu8FoLV5bb7hxY1PYNTk3ro
 AleCC3i2
 Wol8IMTcdCmitDXdb4iELni5tGUG5te9d0DOsu73z4Hip8OELLKqn1jU08Q8M/taX/iRLg+CHq3u+XUdhUAhMbKiD9gpw7WA0NfZYViuwhZwSZlTkC7Iu62TUISor6cF5dVEzhpM+U0hJS46ABf2FY6rnFKSO1ZKp4StmVBR4107DxI2b1OafVyh+Uc39MJg0MrNFDcSo9X9tMHs1Bqpe0cZTGhQvF9ukh7Ma4UtPOKio8vAs4Egd6guqPy8yzl1NIon1+fHXcjkNGXrLG2j3PFhNpwpcK3M+p++y7RbTxjLfFBQIcPNLnux8W2hvWYfkXOnvgJdv/erhzkl4d3c9gBzhZgLx8WZAmf3B1INvQtgiFTIXQMQ04evSzzimZxzQB2xhwOizoty8L9Rg+wzeHdzXCuAqW+8sChFp
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
 mm/kasan/common.c     | 34 ++++++++++++++++++++++++++++++++++
 mm/kasan/hw_tags.c    |  2 +-
 mm/kasan/shadow.c     |  4 +++-
 mm/vmalloc.c          |  8 ++++----
 5 files changed, 58 insertions(+), 6 deletions(-)

--=20
2.52.0



