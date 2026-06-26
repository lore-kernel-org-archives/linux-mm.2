Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D245DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B917A6B0131; Fri, 26 Jun 2026 14:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68AE6B0132; Fri, 26 Jun 2026 14:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7ED86B0133; Fri, 26 Jun 2026 14:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 801B16B0131
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:45:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0AC58A055B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:45:08 +0000 (UTC)
X-FDA: 84922941096.07.D1B06B9
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9CAEB1C0003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:45:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rCkkpNgR;
	spf=pass (imf21.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782499506;
	b=IUKr4j5PqvJQA6qA7jTqDVZbMeOrnBELbWTmiVRBsHL8q8vHZQjLZTx7xR08TWkEi1+9Rs
	lPfuJjPDNd/NJBGLdustc3f2XL4sgflhalwkQXXH8ee3ggKne/AR4HFVzPJuixPJlCCiuc
	b+1hOW6glEAxkoFYoesJi0uQYkHmAAY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782499506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pXfz95SCfqpAGTXTM22nCcCkrLwtMVyLAFRGqD9/R68=;
	b=JNZ8X5mNJcpbWQIoH8SsbwCifYR4qkiEKNe/2TQzfD+rcWeEK2704XBzhTlJYPvx++hRq7
	LE+T7G1+dXk9u68/EeBEiU5g/G/Mca3x6TJZ8YVfoZHTRSVoAJHj8G5sR/B42XG5IuH0K1
	OMM7Sssy6lLvGz3cCLDPJhCvY6UvnZU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rCkkpNgR;
	spf=pass (imf21.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782499503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pXfz95SCfqpAGTXTM22nCcCkrLwtMVyLAFRGqD9/R68=;
	b=rCkkpNgRbPKTMh5ghU7gP1QHoVHwrUQAtgfbn/tkckfAk8T5z3lWQ3Aa61b/t+fr6gcacZ
	zEuPbRh3LhHg7B7V/LMLhsdugPoR+5bwih7kkpq0IPFXzhX1f5vVursbicP5+PJv1qUy81
	m/16HAyhCMIPS2Bfb9qIEnmBTObIwkA=
Date: Fri, 26 Jun 2026 18:44:58 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Gladyshev Ilya" <ilya.gladyshev@linux.dev>
Message-ID: <bb1cb750157733f897df2e261cad3d5c42acc172@linux.dev>
TLS-Required: No
Subject: [PATCH v5 0/2] mm: improve folio refcount scalability
To: "Gladyshev Ilya" <ilya.gladyshev@linux.dev>
Cc: "Linus Torvalds" <torvalds@linuxfoundation.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, ivgorbunov@me.com, Liam.Howlett@oracle.com,
 apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, foxido@foxido.dev, harry.yoo@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, vbabka@suse.cz, yuzhao@google.com,
 ziy@nvidia.com, pfalcato@suse.de, kirill@shutemov.name
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9CAEB1C0003
X-Stat-Signature: j5e6sdknj18h6fn1isnax9yfdzq1csk5
X-HE-Tag: 1782499505-978110
X-HE-Meta: U2FsdGVkX1/uXJADhZUQOUb2Q10ClWniVEOf6kfjmoCQemI/juYxbjfk+b2kY11003pr4NvTRFkEXaMrm9VtkLuBzfVncIEQSWfR9qsTuWaaF6bIbILuA6gqnRK0nrTkc7rsb5Nv0CwDHGN2UUlSeoFIa67wc2UuQwUBFJstdoEtNnqjBEmr6joYBJwCEaC3CmstuiDwfW8Ssi78Nqq3eSENEs5RWrE6ok+rc+Sc4TjM3ITBxR1+zfmvSU9aOd35d2W07WSYN+N42CuOk6qc+AOI6kjJpdBrw6MY+NGmIFHJqrZfQ4k2JDcYJm6EqE7K8fQiVgXjIAU7m8RLLz0k7WmR/pEO2/zQajbqbhKTbgFyS5lLDqNJEZnAhilNbjWHeI1vAOKxXMpeigdSxCqbCmgF32l7ugteYUaKnfAHWYLKFt6pXy981J5WBexpuT3FpfpHUsqqQn84jjJCVDYmzbpJmup9wPztrMNhlTLeCH2g+k9nMriS+Kqgk/ovFJS22j4/TNRs/Vhkyn1yHMOlG5V3CwLuZhiwIE9W88C6vkSOFa7BA6KKGTpKyrOS7Hfu+6ffJu/EicTp7cX2TxCRdnKsLePKDvxICcohQaR+kc2YL2swBktzyJup88DTBw8LZ8LWrrPCearAYggYTMCguxP9J3Ug6lrH6IajhGeImJHrD7PJYgEOcyfJARfKH/F6aFPWLeg8mj5tIVpVQy5jUrm9JlAmL/9FEPOMpHQx5aT0UO0/+3e3iwUBSLFOj7GslzoxzRsZSJ8ZhgaKtKDd7TLEbyJMFPnswjJomBPIZqkLgaNe7pFV9648Ms7Gj0kI95w6DiHFZU4lz0fGSsHKDy5cmuSu4x+QkCBzjl7yxeKDWDmSf6iYb0MztHP64AsOnnJS2Dw9hfkKr6dyO5GP9IbsUfTktAQKznWax6W99J3DvtERa5CRPH1qzI0/tNuaxAzK0j1JY4NcI61R9hA
 ZY9jqJlq
 VeMasbEBMgfSFR1z5HWSrp1RVXVNWSMCI4kSjR6FKPIoBebxl4qkesZUZPBBkAGtZqxoNHSqg8dZqifZB57WNsv4la3J6DM/g8ufEmCegTzqG5W9Hi3iQnYMA0/qpTjEUcM4Pg2EZyWg0HCtnefFIiJurh9V7FQUIZXAikFMrYq8tAPAiEqOCQvJv4zg0NUYHuvo4VNwE6jfcm1HAOIVNGlPuLAQOVCEahiqMzmV7bXjAc4WD/WBVZ+AviqHDqjYLp4EGFOHiggf9A4/mA/WMf/GZ1JyrtD2S6WDequN5W5tDgZQpeu3DMtsAi5gCby1rzMD/sTe6IL0VjrW9g4Cl9xaGlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v5 of the series, with no changes to the core idea:
- Fix missing BUG_ON checks on the sub_and_check APIs
- Replace BUG_ON with WARN_ON_ONCE
- Fix virtio-mem incorrect page unfreezing (inc -> init)
   (Note: This would be caught by the WARN_ON checks during testing.)
- Do not loop for an additional cycle during CAS reset

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

Link to v4: https://lore.kernel.org/linux-mm/df26082871b4c65b2bd38d409026=
237c08572836@linux.dev/

Gladyshev Ilya (1):
  mm: implement page refcount locking via dedicated bit

Gorbunov Ivan (1):
  mm: drop page refcount zero state semantics

 drivers/pci/p2pdma.c               |  4 +-
 drivers/virtio/virtio_mem.c        |  2 +-
 include/linux/mm.h                 |  2 +-
 include/linux/page-flags.h         | 13 ++++++
 include/linux/page_ref.h           | 68 +++++++++++++++++++++++++-----
 kernel/liveupdate/kexec_handover.c |  6 +--
 lib/test_hmm.c                     |  4 +-
 mm/hugetlb.c                       |  2 +-
 mm/internal.h                      |  2 +-
 mm/memremap.c                      |  4 +-
 mm/mm_init.c                       |  6 +--
 mm/page_alloc.c                    |  4 +-
 12 files changed, 88 insertions(+), 29 deletions(-)


base-commit: 51cb1aa1250c36269474b8b6ca6b6319e170f5a5
--=20
2.54.0

