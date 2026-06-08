Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9053CCD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0492A6B0005; Mon,  8 Jun 2026 17:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01FF36B0088; Mon,  8 Jun 2026 17:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E876B008A; Mon,  8 Jun 2026 17:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D92376B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:53:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD0111A0326
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:53:08 +0000 (UTC)
X-FDA: 84858096456.22.BD3BE9D
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf04.hostedemail.com (Postfix) with ESMTP id 80C8E40009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:53:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z0tH7eyv;
	spf=pass (imf04.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780955587;
	b=MSxH7m0QpXvfL2Ns7uN3IFya6ng4snMYMjjjr0NIw7tUax0nvVUx63J8IvZqEq3q2RWUxk
	36KIFM5C7h158GLGIdGCwI5yBsUVLhj2H0QdbfCruA0ed2sYo/2JMzTgTdunkqYgVt/lY9
	emp4KDbWX2mjj6sq6vcE6yIMGA+71g8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z0tH7eyv;
	spf=pass (imf04.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780955587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6pSr03ULyB+otFQXS6JBID2Gw2Frem6Io7hK68okrmE=;
	b=16Dps1ZEiQ04GoXRSYM4kQE/jYDlkPkotzMijAML9EHYkIsDvkdYxgzM3HIHHUkNSBqEB2
	OIXJeDxiR5LSQkZfky+27g9eRfUm9aZzrogDUiccIG3M4/7NqH9paUMpfoxQIPllH1XZL0
	GqEWTD59jCLMJ/HUPOtU72qBj25e49U=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780955584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6pSr03ULyB+otFQXS6JBID2Gw2Frem6Io7hK68okrmE=;
	b=Z0tH7eyvG6didP9k0m2/dBTod2joirA5/jPmirgxeTtUvBC8DNqG4FXgPe5Zg1dLEdlBxZ
	Hssu/CcXYRKTimC00/pFSeHHzSUrK6fHeu7NF1kCMQyt3mELt0RbcXOMSAXIFN8wJ4W8kE
	9cPI6N0CLjQvcQQHWfrWGkvmwLsyvcg=
Date: Mon, 08 Jun 2026 21:53:01 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Gladyshev Ilya" <ilya.gladyshev@linux.dev>
Message-ID: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
TLS-Required: No
Subject: [PATCH v4 0/2] mm: improve folio refcount scalability
To: ivgorbunov@me.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, david@kernel.org, foxido@foxido.dev,
 harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, torvalds@linuxfoundation.org,
 vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, ziy@nvidia.com,
 pfalcato@suse.de, kirill@shutemov.name
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 80C8E40009
X-Stat-Signature: kxihmaqjqo53pzjyzezu48aj9c957unn
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780955586-684644
X-HE-Meta: U2FsdGVkX18tWmnxFH7JdU+UKRgINtIvw7OZXf8UZ7bwA3d2aNjf4mTqgKd/wz0N5R5HpFsV+ckt8CEaEAVWMQNuavsihJXj/UhRjWN9+liI1MyJfS3DUhRKyfZyjEo79AJmWXLY7C/daQQzzZIVWiaTfDuthYFVeeBii9iaVDIGcBzP7NjljqCKg5FSyDt+0pxPksQxV17ucD2gOQMJytFMcFaU/hKRK9CZvSJTn4DXTwSwL+ZMdYfyTqFQC9abOFx1Gf8/AEN9i3VTr/gjR+49HuLIJU1Wz+ftpQcovo1jSCwIYxZ4xKUsQFBKf42IXQ10gUxPJqU7+2+U8pNgHL7Z98krvjzyITi+3qBgnv8+Pwyir7sM20qluUE9BNFKuvLcJaKsPUG7jZrmEaJ+aXXUpbZgpTVLUEo8356PYIlE2PILdLKufuBpewH/SNIiSqcInFqo6riAkpBczHJcprXa/enhew6t9+IPMczh/eHIaXrwE0ZA/ZoXGAyJ6v/guFX/Xr91O4pUkvb3G8H6Jwj1G9uFa6leZg8nNsGx8PsnXYRtb2P5eK6mOJ3mM+yYDwF+3P8ec6ua6yaF0rfva6Z84Z0udfeDK0yeduGXKiAtW795WUTT3zSZ1T9/3Oo7Wd4s91yo9770HNHvSgYWP+nknIBhSBjTehq6UngDq29icc+HK8M6dGKGyu9emHgpkY681ahiiyA1yXppLW/qgcqx6xKxFL+elM98tcImMlUP8P4OvaArI9QNPYKmC8K2ARX/gPFXJbSTRarLcvGh8z9XRWGcWa+b1uWDsmPQv1cvbpRlyNCLX5TxjoeW8HSR05dFlysmYDVn84A1aVAStjQS7tNDugyBj+tPtWM6ofs71WEoHp8anAEODvy2ROo6s8bRBYNRt1vbKowat++ZQqErXvebJPAOHtuu1OWGQh+FtUfRyhC9TZdCxkFAuxTYdjEi6e98anhzbkahWTp
 IcBYYI+x
 zBzbcCzblX3WwhB2j1hHmPfIL4rPWKjtLJRLYrtFNxTA1VK3ecsjhuM/TdE0hNOv+Y0xCBaL1kBbR+RfGKwAOAqVgPz7GItN2XCmmwmVRBonpZgX5eF4Sq1GXyUxdfnLJJjcWjUN0kekJhwojK2LjocpEH22o0dzpAacjypiYDnajU2GpwSdRks9JCudxWHZxl7LX9LjUkLEtVEB+tmJOko6ptOSGmJJT1jSvLTEE1vceK6c4cUDMv5QONj/QBE0rfav/7+j/MIknGCSfN6iVyNweFKqg38R+Ovi3+9y5UFKpA+CrzOU+jCdakyEcjjy3obE/Qw4aAZZZyMskFeaQyHl9TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v4 of the series, fixing some dumb mistakes from v3:
- Fix asserts that were never firing
- Rename set_page_count_as_frozen -> set_page_count_frozen
  (
   I don't really like tthe proposed "init" in the function name.
   For consistency, we can rename init_page_count -> set_page_count_init(=
)
   However, if anyone insists, I will use the proposed init_...() naming
  )
- Set proper frozen value in the second patch
- Use VM_BUG_ON_PAGE instead of VM_BUG_ON

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

Link to v3: https://lore.kernel.org/linux-mm/5dabf3a748fee0c7b142c74367e7=
586f5db1ed1e@linux.dev/

Gladyshev Ilya (1):
  mm: implement page refcount locking via dedicated bit

Gorbunov Ivan (1):
  mm: drop page refcount zero state semantics

 drivers/pci/p2pdma.c               |  4 +-
 include/linux/mm.h                 |  2 +-
 include/linux/page-flags.h         | 13 +++++++
 include/linux/page_ref.h           | 62 +++++++++++++++++++++++++-----
 kernel/liveupdate/kexec_handover.c |  6 +--
 lib/test_hmm.c                     |  4 +-
 mm/hugetlb.c                       |  2 +-
 mm/internal.h                      |  2 +-
 mm/memremap.c                      |  4 +-
 mm/mm_init.c                       |  6 +--
 mm/page_alloc.c                    |  4 +-
 11 files changed, 82 insertions(+), 27 deletions(-)


base-commit: 2d3090a8aeb596a26935db0955d46c9a5db5c6ce
--=20
2.54.0

