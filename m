Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8771CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 10:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08D96B008A; Sat,  3 Oct 2026 06:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93226B008C; Sat,  3 Oct 2026 06:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B176B0092; Sat,  3 Oct 2026 06:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5BA6B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 06:30:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 34F5B1A0947
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:30:38 +0000 (UTC)
X-FDA: 85280946156.16.E35D954
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7834C20008
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:30:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UdH3lgUA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791023436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wPZq7gjHJpcJmgR7EaOFKtvjMOo9Jsmtk8qeZDcxeRE=;
	b=YgmQcyNlU5/51Um65rWFxK1iGW2Lh/l713CshzEydLPI3ewuhaVoypWOv6Wo2aiRwaO/64
	dJ1osHPaJ0h7Ma41tDrwKMfrhkOSWpCvrwuiimaJMj3l8XZh/gD+mHVGrEGvPhkmJp66Cm
	kDVPEvMtZdPti06KDSNnv4M4oLdxL7I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UdH3lgUA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791023436;
	b=DTptZ1mNW6HD6ReM+yv3HOCRhd1zFCEB4CgwVHYXrkAyZJxlmY5EDiPfK1s3cgd7c+ITXA
	q9tAyCJPEZ9m+O4KruY6tMIk7srbghc1A8/D4CBY3GXKBjrEJO9GQmIxSWsL496SIUurX0
	7NN/OENpes0YCRPwYnPiSwnyxfLA0sc=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-398b3b189e0so112914a91.2
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 03:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791023435; x=1791628235; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wPZq7gjHJpcJmgR7EaOFKtvjMOo9Jsmtk8qeZDcxeRE=;
        b=UdH3lgUAIqaZC85VZOftCJPH6vnx1OZp4evouw9RzqRbnLgHyjsrn9FNXZGahzUPUo
         qSnJbYIlVE46Zin/MSgnm50N7gKIjNYvVjSXKsqvG1d4abQryhVOa63s/Gu8xsUXwMqc
         5VbnI5qRFeuBpPoPBHxYj/qZrA1DHgLkWxHeC6uQjNdyLVy3Rh5vLOIFrksdN0Jfudlm
         Etb8QVrRoJdTc5dawvVsbrL9n8XVKUWqI9E7r5Pmabsnb8/ud9Mz90tAbt1euFjr4xuO
         FGJfypkc7D4kYcg/LMb4ZA8dRYIyaZJfxbvYBvUvH46WepQu1WU6/icpI3dJxvC1WQ+O
         sYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791023435; x=1791628235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wPZq7gjHJpcJmgR7EaOFKtvjMOo9Jsmtk8qeZDcxeRE=;
        b=Wy0taFJ9tZKg0yF5JhjQ/gbkSBD/1N72QBMDBcEcarzUBn5Q459Cl3a1Wy4LY1tMZF
         ezvgVM8AatF7BgpTQoIz/V7q1uj/Mugoe+9Uq5/bDTXuvj+Uxe6HwCegrwR4AV240ymv
         OYBxAhRyFqf+PTzHpI8rQ+IDtv0p0VkBRwxDDRskt43ShTjS6TU+hNO2s2hIguZHWZMU
         HtO58r1GvYYtmJW52+MNjoqs+3/8s4B8K9LRQiI5AQ53qvm6ZK+s5/Ognl2OlrxzdUAJ
         IfgS8x5oMMKXdsnK9AXxENXgPTv7ue9ulVYCFy1aRReSTqt+hp+gihga+NryphXzSHei
         eEkA==
X-Forwarded-Encrypted: i=1; AKwUvBx5nwisr4IfGodnX7W5Bn9gU/J+FgosM2PPDVSpJLmjE2PgzO4oDkWL5s3qEtIc0fBCWqPEAuKJ1Q==@kvack.org
X-Gm-Message-State: AFq9FYI2B29ICF5YvbpbK7rXP9RbJChPtYhRgUkoCvA23lRNFcjWdfDV
	RxBIPQlMeo+pw364wOLVu9bI6c2nzcWIrS+65+2TyOnjZmvEqOIPlUA=
X-Gm-Gg: AYBFou2+KkG90J2wk/zDQW9s1D1DGQFWrzv6XefCQY9CXcsAjAtoRE6sA8/umxj8fh0
	70m09QFzEv7zmtl877P+UuudA+4So4U8wEkbDNOD3RO7VswWjNE7XWpBZNc0D7lMgS5VCTHoCRx
	MqOZk7vSSgTjep0Zdsytx3hgh8pbZT1GBTo7kPPYeVA6ETngCIQmFYFv3i7b9rEdI4hgUZGTJdv
	2fM0uqkRkmkreHCVDL25G4VnGdFtdcQEklI0T28YxX9y2by14r8z4PdkMs21RjeOmLm/UcXs7em
	PPDI/jSeXg7Cal39fqnGUyI9hrky96j5X3MWoTJgLqJK2urVYWI2ReeGnvo0c4orHqY54cyrgOk
	8bI4ig0AqLwcD2FPaRROlXbXyMWBd/a8JSzHH1+8+n1VkH3QfosFFktSCZSbn2RQGdA7AFP7IER
	zfmj2l4kkCCZD71LRyPzuCI8ODR0F8os5unSaLq+rsUbU04k/F6RvX+8+CXEdZRNp3T7NbyLjUN
	UlM0JDUrRvTP/mNeNULx88+yg==
X-Received: by 2002:a17:90a:c105:b0:3a7:aa1c:476b with SMTP id 98e67ed59e1d1-3a7aa1c5b5cmr149517a91.31.1791023435221;
        Sat, 03 Oct 2026 03:30:35 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([211.230.25.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a709a4e80bsm2121961a91.4.2026.10.03.03.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 03:30:34 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org
Cc: peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v4 0/2] userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Sat,  3 Oct 2026 19:30:28 +0900
Message-ID: <20261003103030.63380-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eh383o1zetnq1cj7bszw9cgxbbgo1br5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7834C20008
X-HE-Tag: 1791023436-899004
X-HE-Meta: U2FsdGVkX1+IYip9sJB5WqCwddfSKiIsIfmct6bG+CaOosCUbENVPDz+LH+kIoZ2HnkxTBUsImPQItTyhd17NMHgX3Qbx4LomJHEy5i3jrzLeAUTtFD7WLNo4ngpMdw+cXvfxG6GXndOk2LfOoG0Tu2JeiGyTdpdVfxJRM6dkcCY59sQgxvbrnkjKboPjxuwxoJ9XzpAY2RCVLPzO8wkzU8b0ySVGtzvnw8pE5skrBpvwE2cZ+g2Lv9nwUel5BDKp3i8Qhrc/I/yzg5mNn/i3i4XfByRk9Cfjgzgei1RnPkbQ0xmv0lOtJgK/iqffFyifUdmFUeEehWysy+F5TaKzoBgOMgean/wlCXbV4/rpuFGGV4gk+6KEgD1k9jpj0NKmWluEmiMlJzzqjUK1Ce8GRHVOw+iCOZGtOKKUsDRsmod9GocO0jp94jXPQJC2BQw8XoOSOQYMmEfGtg+mo2uvDhEIhnB1zFr0sZU8/EKbyaP49aTeu9nN3U32IuXTFgsiZ681Mc6q06hru0JD/bpemvkB6NXWtEdKug62VWNXkQuBp0NTK8fLMsHjDFDd7hZsRCpHsLbmISrzVWskMURAa7HebfaQ0rKaUDqwWO72Y674Mdfei6qtVO0egVuXzpGxRH3rWNhYfzhGxBqAlqLBmRHGoKJriFV2ev5Rac48giAOL0EG0q/hGL6yw21quW99PiLKX2Pfysxp6cF4adCWnR0SCdXmr0okiz4zHHpj2iE9RuJa1eqT81P1o1skv/jtONRi2RHhIKkTwlavKMxH5bbVX3vWZ90d5XCt4biw4Nb7za43H8oqLo3oWHLiYjYp4jE0izvxEeJ48Eo4wJVJniq+S0HctKyDlm4DvPYWGZM4Ks6wYZgvmkv6j222UC8UBe5J7GIyoKZCb49JuP7dKeygT9V6OsaCbu/uYFqhjh9gLx5Q5gVHyR0qQbFnGku8VY29Uw06VDc07hEc3N
 EsprHRV0
 9oU+reAGMEThYbg9w4U55aJfVEUAf376vr/lsnEO7oR2PU9iy5Q1P7Ihb1XSG+IX7eJ2nrAaFuJ/rqjxKL4Oxzpyf/TzyyJVa/ZHdXvdoJpjQiVa4Ua65ltQ/mCM/D6OViyRz0Y1gX84W5HQtMt1RdkDmWz+ReZ/c4jyAvHOUtnIwVLkvAzGkfvtFZ3SrqyvAWT8U4OyyBGVFTqXr/mOiXmvBIZ8Bb6Db8BqkVyRrFuLgHDCdEisUKXHuxPM0SNPkB2e5mfadzz8t+RGFfZzNQUNkaHNT0AadcgdxnjBj818mYER3AZCFakPwk0/ED38RZOAFFznl88FoRIVEabYx7uy1nRf6UUbDDrxP/252JOFZ5ItLua7s/iXeYP8KgasKIf6BmjrakuOcL1tIvF3e1ZdSu7Ld8zpZy52hYZf/+/xs52UXJV9/tUAB+Dz4U5P3/r/FJMYk4+pQOl1VJgScuZpgmv6qlNfnfSy8VrE5cDvD6sihb6lI47BrvTsOBETVisb92gy8hHD8xpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UFFDIO_MOVE on a swapped-out page installs the source PTE at the
destination unchanged, so a uffd bit set on a write-protected or
RWP-protected source lands in a destination VMA that was never
registered for either, and nothing clears it afterwards.  Patch 1 clears
the bit, then re-arms it if the destination is RWP-registered, which is
what the present-page and zeropage move paths already do.  Patch 2 adds
the tests that catch it.

v1: https://lore.kernel.org/all/20260919004630.1159895-1-donggeunyoo.kernel@gmail.com/
v2: https://lore.kernel.org/all/20260925042907.2330519-1-donggeunyoo.kernel@gmail.com/
v3: https://lore.kernel.org/all/20260926124145.2878520-1-donggeunyoo.kernel@gmail.com/

Changes in v4:
 - patch 1: add Acked-by from David Hildenbrand and Mike Rapoport; no
   code change
 - patch 2: protect the source right after registering it, open pagemap
   at the top, and use a designated initializer for the move (David
   Hildenbrand)
 - patch 2: fail only the test case, not the whole run, when UFFDIO_MOVE
   fails (David Hildenbrand)

Changes in v3:
 - patch 1: describe the userspace-visible effects and the backport
   (Andrew Morton, David Hildenbrand)
 - patch 2: drop the MADV_PAGEOUT retry loop (David Hildenbrand)
 - patch 2: add an RWP case (David Hildenbrand)

Changes in v2:
 - patch 1: clear the bit unconditionally (Kiryl Shutsemau)
 - patch 1: rewrite the changelog for readability (Mike Rapoport)
 - add Assisted-by: LLM (Mike Rapoport)

x86_64 defconfig plus USERFAULTFD, TRANSPARENT_HUGEPAGE,
PAGE_TABLE_CHECK_ENFORCED and a swap device, under QEMU, on
6812ce4e4379:

  uffd-unit-tests                    before   after
  move-swap-wp on anon               not ok   ok
  move-swap-rwp on anon              not ok   ok
  the other 103 unit tests           ok       ok
  uffd-wp-mremap, 38 tests           ok       ok

  11 unit tests skip on both, as CONFIG_GUP_TEST is not set.

With UFFDIO_MOVE forced to fail (len = page_size + 1, local change only),
v3 aborts the run after 15 of 116 tests; v4 reports the two move-swap
cases as failed and runs the rest.

  pagemap bit 57 at the destination  before   after
  swapped page, dst not armed        set      clear
  swapped page, dst WP-armed         set      clear
  swapped page, dst RWP-armed        set      set
  resident page, dst WP-armed        clear    clear

  MADV_COLLAPSE over 2 MB at dst     EINVAL   0
  fault on the moved page at dst     WARNING  none

Donggeun Yoo (2):
  userfaultfd: clear the inherited uffd bit in move_swap_pte()
  selftests/mm: add tests for UFFDIO_MOVE of a uffd-protected swap entry

 mm/userfaultfd.c                             |  1 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 84 ++++++++++++++++++++
 2 files changed, 85 insertions(+)

-- 
2.53.0


