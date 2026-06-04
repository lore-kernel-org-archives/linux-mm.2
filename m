Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F18CCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 10:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8846F6B0088; Thu,  4 Jun 2026 06:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8350B6B008A; Thu,  4 Jun 2026 06:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74ABB6B008C; Thu,  4 Jun 2026 06:14:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62F266B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:14:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B847E1A0713
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:14:19 +0000 (UTC)
X-FDA: 84841820238.27.287FCD7
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id BFB9040003
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:14:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LUHVzuY3;
	spf=pass (imf04.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780568058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7RfhhlRPTYpJBSTipt+K7Og5rEq460EM63qs0/sDLck=;
	b=y0g/3ax67RejK5v/xqtRu83m9b5rJsvMrsPfxv9PGinYF7TJajXNXGF7sTFkwNgiBAnbWj
	TQ+yGGMSnSC+nnqlWpDWKZuf56OMJ4zS7WzvKxN4prG86Ot+ds9rxkKU5V41YfGwU8A1PS
	h1JDpLj5JPmQFzX70bQEE5cmTr3F99Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780568058;
	b=oDeJMCVF5yuUygAiPuCZMPWQuwOsCGSZQy6oFY5HjC+KQ9NmW+UsrPeD4fGwEMs+4+Otd0
	6Ijbwey3kJG94Ugg8H7Q56lOonAQlVYNoG4fiXrv7UINTPlxyWQeMF3eWYHQV/yD5Tn/hT
	uOEzersJHmzx+jv0pirNdVj39CwAIYE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LUHVzuY3;
	spf=pass (imf04.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780568055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7RfhhlRPTYpJBSTipt+K7Og5rEq460EM63qs0/sDLck=;
	b=LUHVzuY3zlA8yMvEm4KGrph0ydiDR1tpJyRdE8KJDoSM7tTSMishMY0f7qxorNGfZosiJe
	0pI2MWrrlDyPIO4L0xXorUqOGkvTOJprF0+y7WZayICs8B7imwyX7NdE7trFVmtG8GOEFQ
	53RCu8Ki9lt36gS2ovr7uUgr2N03ypk=
Date: Thu, 04 Jun 2026 10:13:58 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ilya.gladyshev@linux.dev
Message-ID: <5dabf3a748fee0c7b142c74367e7586f5db1ed1e@linux.dev>
TLS-Required: No
Subject: [PATCH v3 0/2] mm: improve folio refcount scalability
To: ilya.gladyshev@linux.dev
Cc: ivgorbunov@me.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, david@kernel.org, foxido@foxido.dev,
 harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, torvalds@linuxfoundation.org,
 vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, ziy@nvidia.com,
 pfalcato@suse.de, kirill@shutemov.name
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BFB9040003
X-Rspam-User: 
X-Stat-Signature: 7rzc3z55u5689m44pfko787hwjttndhz
X-Rspamd-Server: rspam08
X-HE-Tag: 1780568057-930400
X-HE-Meta: U2FsdGVkX19Vw3fr9r3JqkStYV8FVKuVNGeX98bQRItwGWsGna0AvAEczFBq/osXJbqptD8jTWieMufLIIsbn/AV2a4Tcs7/IEQd76dA0d4i1nsUwQ+kwg1Iq7fNxsz3atCAGy3zKncN44tK+nUs62FCamT4YDqyZKIiJzC02+E6xQPToI21IqQNp5PKApW17z+oTTDgI9GAY1SFUkogGt5qaMJqjWCfjVxP6EOjE9DF7DoqJOR0I4hPlsfUR+ksxUZ7SJRvOO+iZfvFUBDxFecaU2FCdSNHCEL8DLTihwwYU/rh/KCLUCbQaYCB8+IWATEtWNAn+QO20MTxvnUOPL+NblbNCT5x3HhZW/qQ62Wly8KSsm/8mA/xZE7PO7Vi28N80AXxMd3bDxKtOdI8rMQebujGCCbal5eaaFqDaOBkoFqLPnvKKh2Lcli+4oZEAJGIWmS8uXGC5UPsDIMJDIwAod1NVjDWI4bmWIBlJhaqoHVf1gpOtJiq1q2WHZ0MnbshB6gGQLx/8JGGpFTeMRkGr/onI3bcrjroheI/t5sMPtwFBfLsO4sx7HWfECm/9t27XfaSTq113dspDHrBAlUJWcr/bEGX1to6GDQRESo17D9nNzN141UFybLluvNsCEtozbnplqrR+VKcsmeky1NRZ1KHxRodeG5ku5qu0BqRM6EwKnHcORNSbzZYVU7bvoiSWxvSWgRbGLmeY1vHX9SkO/FPCbB7IWwZ/WDyAbz80q0ecpbWrl5Yjth82RfukawLqisaQF+M3coyYF5tAV4YAi+GoAyuCoP8jUYTKKeg6AVZqu5/Fo6xdCz0D5ghySd+EBZBuYBqS29Wua/6ZdqrQpWMtoZYjj9d2nZ+tlF2LtlD9KJcuJmly/kV564Fsw8oaZktpwhzlxD3sa0FWN4i7tFY39MxOfWAFev9m/p4RNVTN7FUgqs0mDq4JXID0s1O6hysColp8iRUrQv
 20kHyBOJ
 RWvp/ZOVxMqiu//MGt5QmFInKR8wFLr/mhx7rlBOjtt6lUkzPs5SjadvYPOJa+v6E0FuCU/ICPegwDxFsPsMG7ea3wJUNJkOq0sw+dIb5iY+gM7kF6djlQjtGANPP4GHHNY7pl6my8lrnj8kgM3fl+94o0oxOI4w3XBuken4kw+Ma3/NALvD6kLe60I1lx74dVQR+sw3iHBsVuz9hEsoPQNK3VvKCGFZKXPPkIvDYQeef4LBhosJvzVgvpsnZWCqrx0h5Un1T3GQVXK/SpRsEI6uUzajLKs6YzHa7SUyNmNxcP7xh30GiM+sFDEescBKl3EPC17Wik9+1O4HuqSGONOfC0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v3 of this series with minor changes since v2 [0]:
- Fix inverted check in second patch
- Rename "unless_zero" functions with "unless_frozen"
- Replace set_page_count(1) with init_page_count()

Small note: We've had to change our email addresses mid-series; apologies
if it confuses anyone. Also sorry for long delay, I will resume my work o=
n
this.

Original cover letter posted below:

Intro
=3D=3D=3D=3D=3D
This patch optimizes small file read performance and overall folio refcou=
nt
scalability by refactoring page_ref_add_unless [core of folio_try_get].
This is alternative approach to previous attempts to fix small read
performance by avoiding refcount bumps [1][2].

Overview
=3D=3D=3D=3D=3D=3D=3D=3D
Current refcount implementation is using zero counter as locked (dead/fro=
zen)
state, which required CAS loop for increments to avoid temporary unlocks =
in
try_get functions. These CAS loops became a serialization point for other=
wise
scalable and fast read side.

Proposed implementation separates "locked" logic from the counting, allow=
ing
the use of optimistic fetch_add() instead of CAS. For more details, pleas=
e
refer to the commit message of the patch itself.

Proposed logic maintains the same public API as before, including all exi=
sting
memory barrier guarantees.

Performance
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Performance was measured using a simple custom benchmark based on
will-it-scale[3]. This benchmark spawns N pinned threads/processes that
execute the following loop:
``
char buf[]
fd =3D open(/* same file in tmpfs */);

while (true) {
    pread(fd, buf, /* read size =3D */ 64, /* offset =3D */0)
}
``
While this is a synthetic load, it does highlight existing issue and
doesn't differ a lot from benchmarking in [2] patch.

This benchmark measures operations per second in the inner loop and the
results across all workers. Performance was tested on top of v6.15 kernel
on two platforms. Since threads and processes showed similar performance =
on
both systems, only the thread results are provided below. The performance
improvement scales linearly between the CPU counts shown.

Platform 1: 2 x E5-2690 v3, 12C/12T each [disabled SMT]

#threads | vanilla | patched | boost (%)
       1 | 1343381 | 1344401 |  +0.1
       2 | 2186160 | 2455837 | +12.3
       5 | 5277092 | 6108030 | +15.7
      10 | 5858123 | 7506328 | +28.1
      12 | 6484445 | 8137706 | +25.5
         /* Cross socket NUMA */
      14 | 3145860 | 4247391 | +35.0
      16 | 2350840 | 4262707 | +81.3
      18 | 2378825 | 4121415 | +73.2
      20 | 2438475 | 4683548 | +92.1
      24 | 2325998 | 4529737 | +94.7

Platform 2: 2 x AMD EPYC 9654, 96C/192T each [enabled SMT]

#threads | vanilla | patched | boost (%)
       1 | 1077276 | 1081653 |  +0.4
       5 | 4286838 | 4682513 |  +9.2
      10 | 1698095 | 1902753 | +12.1
      20 | 1662266 | 1921603 | +15.6
      49 | 1486745 | 1828926 | +23.0
      97 | 1617365 | 2052635 | +26.9
         /* Cross socket NUMA */
     105 | 1368319 | 1798862 | +31.5
     136 | 1008071 | 1393055 | +38.2
     168 |  879332 | 1245210 | +41.6
               /* SMT */
     193 |  905432 | 1294833 | +43.0
     289 |  851988 | 1313110 | +54.1
     353 |  771288 | 1347165 | +74.7

[0]: https://lore.kernel.org/lkml/cover.1776350895.git.gorbunov.ivan@h-pa=
rtners.com/
[1]: https://lore.kernel.org/linux-mm/CAHk-=3Dwj00-nGmXEkxY=3D-=3DZ_qP6ki=
GUziSFvxHJ9N-cLWry5zpA@mail.gmail.com/
[2]: https://lore.kernel.org/linux-mm/20251017141536.577466-1-kirill@shut=
emov.name/
[3]: https://github.com/antonblanchard/will-it-scale

---

Link to v2: https://lore.kernel.org/lkml/cover.1776350895.git.gorbunov.iv=
an@h-partners.com/

---
Gladyshev Ilya (1):
  mm: implement page refcount locking via dedicated bit

Gorbunov Ivan (1):
  mm: drop page refcount zero state semantics

 drivers/pci/p2pdma.c               |  4 +--
 include/linux/mm.h                 |  2 +-
 include/linux/page-flags.h         | 13 +++++++
 include/linux/page_ref.h           | 57 ++++++++++++++++++++++++------
 kernel/liveupdate/kexec_handover.c |  6 ++--
 lib/test_hmm.c                     |  4 +--
 mm/hugetlb.c                       |  2 +-
 mm/internal.h                      |  2 +-
 mm/memremap.c                      |  4 +--
 mm/mm_init.c                       |  6 ++--
 mm/page_alloc.c                    |  4 +--
 11 files changed, 77 insertions(+), 27 deletions(-)


base-commit: 6f3ed7fec72fc8979b2a8c7219c0a9fcfc8d07b5
--=20
2.43.0

