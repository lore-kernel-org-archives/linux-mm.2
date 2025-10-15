Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87CE8CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:36:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFDF28E002C; Wed, 15 Oct 2025 14:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE9A8E001D; Wed, 15 Oct 2025 14:36:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBAA8E002C; Wed, 15 Oct 2025 14:36:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADA3D8E001D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:36:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D7251DEDDD
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:36:51 +0000 (UTC)
X-FDA: 84001205022.27.8D37886
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf30.hostedemail.com (Postfix) with ESMTP id B34C680002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:36:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="zp/WbqZn";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3wOnvaAYKCKEXZJIBOHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3wOnvaAYKCKEXZJIBOHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--wyihan.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760553409; a=rsa-sha256;
	cv=none;
	b=dRoWORwtpu4Zam91h8rzKjaPVQHWr77vqNdk8xIDKhLd0lpM0Yv+9cd+VB2nTID7R8fVXl
	2LctlIFo5haE9vFnFQd1makBspsv+eFb92B2m1ACSou5MJj+WclSOU9X7RcFTJUk+hIgoQ
	jmB1JREQGDu4kpZlu4Lwqe0NdAwDok8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="zp/WbqZn";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3wOnvaAYKCKEXZJIBOHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3wOnvaAYKCKEXZJIBOHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760553409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0ilCg17JQ++to0ldYWXPZYiNCoMtQnD6yTXTJa/H8UI=;
	b=OQS57fuACgxzJW7Z0iH+Po4lcgB6eS9bsAotg0mQTRVpfVgRUyPtXX50uklluPrxoHyTbL
	qke58ez677hGBO86Kf5FDdrahDR2mUSBaycmDIc2r4x36x5whruoXTJ06OJQcaFqsVm7j3
	4WlpkzMPQaSGuv7OTKjM018DgM2wqMU=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7810e5a22f3so19616791b3a.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760553408; x=1761158208; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0ilCg17JQ++to0ldYWXPZYiNCoMtQnD6yTXTJa/H8UI=;
        b=zp/WbqZn0Q2Hq2aO26L0d4Rq86sWEfuHz9H6YSRFDc7RfaQF5vYEK3SpboRttXEaC5
         nKrMNEOTNTbUrjjGv2+CEAse8fMvKjH5LTllDdGuktEVU15Kk7ipSliCoCHiG+sU2bdN
         HuxAR77Gy9I5WvpZCnooowD0mJeumsyfEbrXalGSPLt8x1TYu8GpmEfq1+wQbVIY0pxY
         q+OrdNH76RlxcpWdFmmI1WYKcYXwQ8cR2kz2WvKNEzahgVwQzaFZKsBsTeHQde/TQhoT
         oqob7c2NVu1sa/vKfEy4mVsK9Wz1G8hz586uFMCZmCafM5Hpn9tP3aFjU6o3GwHX6jFJ
         xi/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760553408; x=1761158208;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ilCg17JQ++to0ldYWXPZYiNCoMtQnD6yTXTJa/H8UI=;
        b=eKz60loXUxJyN7MwHp3dfSI5pbcW5gdSRimg57O/d2291V/vKJyKIJlo36oKvr+Lav
         89Tvuw9IcpJpqa9eW9fykEFDoKs/20CvY+3TojWfUPn6WLzDLCZ4+aOlxmLdIWE1zgSj
         WcMpcylCKt/u5e9yf1FOWMykBC1uo942tocSXfSXXGfD1MmqyirONc0yeKqrAl7CT/mz
         tSl5GiCki+G7gZILYPvW2WCGGwXeLN9Rfd91UwcIP6uoBBT09v5o5ykV+LkeZqwfNjTi
         4e6Zn40Qgh1Fmrh5smJnHHNDG20Jxjjdte5HG/4dbrvUfCL5VRzhmvDvAwU0nblnQJ4R
         4Lhg==
X-Forwarded-Encrypted: i=1; AJvYcCXK9ImyXDq8n3Zm6Hp+mQIKWlgkutAWU77BvO2IMFNEkrTGmztItO1Hx+qkDTn6VHoFnL8yAOODXA==@kvack.org
X-Gm-Message-State: AOJu0YxJ0oi/vrD2C54e7bS2EvNNPJvkAP7zDysWwCk+rBFvcXfU42nJ
	R8iUn/wRXq9GBedvNVpGbdLzpaUKndm6an35S1/H4uXmzBnQcHlq1+bpJSAtEo19XD7RYjhSWLq
	Ac0ZNtA==
X-Google-Smtp-Source: AGHT+IH8PPaE3dBlYhL9Cayq48vHN7MW+dNQWzXLTzpeemhgXmBd6s/PSaBxdBzVpqnpNlS0tiwU3TI6UZk=
X-Received: from pfbbe19.prod.google.com ([2002:a05:6a00:1f13:b0:77f:6432:dc09])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e13:b0:781:1771:c12c
 with SMTP id d2e1a72fcca58-7938269d8b7mr36969858b3a.0.1760553408537; Wed, 15
 Oct 2025 11:36:48 -0700 (PDT)
Date: Wed, 15 Oct 2025 18:35:51 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <cover.1760551864.git.wyihan@google.com>
Subject: [RFC PATCH 0/3] mm: Fix MF_DELAYED handling on memory failure
From: Lisa Wang <wyihan@google.com>
To: linmiaohe@huawei.com, nao.horiguchi@gmail.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.or, 
	linux-kselftest@vger.kernel.org
Cc: david@redhat.com, rientjes@google.com, seanjc@google.com, 
	ackerleytng@google.com, vannapurve@google.com, michael.roth@amd.com, 
	jiaqiyan@google.com, tabba@google.com, dave.hansen@linux.intel.com, 
	Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jgpa7ssdcgir47jcymjy8acktb5nr18p
X-Rspamd-Queue-Id: B34C680002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760553409-943638
X-HE-Meta: U2FsdGVkX1/CJSFYt1ZyRFXoXQrunyhx5vkalXzq37eWGK7E1UnYnwORaP/N5Vcznc4fk8qFw68xwyABfdMrWxOXTf+8gUrwaOFhy1L1d2mbpjDnGdMbdQV8Q0aMKk95nxe7gBE5Sh5Kqjiogwyh6fD3CA3ig/KmwP835jTydVe6DaVKNxL3ECCTIUPUJGg+keJ2zJc0AqLkJZy4KyowD9ddLyHSCV+y0ISBsPls4SCdE4IsjZYZJ8wEwpHRSfLXJw80PQO6kbzFkxe7GdsIXAIi+3T8NWu/ov39pMBt5cbFVXsW/D9ZhVSHpDyYS3jTWRVVM+VwLgRgvAeMpIbACZREnTNt3RrswGdTmXzOGaQOC5i7G/jNoPJzwu37Ed0+3F7TtbUASYj5Qn/ws++Wzgs4ryz78pEOBXg9mEBIuZnpX8eAw1qf71GI/Tfr+EI2FF9UK2kv1GZroYgyJ4nUea9avSdJX7wf0jLCS9+5v+SfEMfEA2WDvhzlWvAw+AxAfXpO1z7Chj6TQUNsHGmU0MT69gXELiSaBULCBhkct2Cj5WhC6wfiTyymqo5R8Q7fAyAVSYKbzW0DFsVYWGID6B7Wh4sBXBPdIMlov8FVXCUxMcbfg1tRGt1Iv8404XPFkKS6IZAV0kKAlPmMuUND7kdwX03YjcN3vHMdHmr9Nt0N7id3Y9DQI9J9AxQpO8vqR6Sqz3Vd/IpgclMiAO4tq1wZnrNN3+xCzS0Snv3SRSx78elZCsQ/1+oS48Y0z97v/H8Xm/FA27laAXOJYHyG+JCfnb0M35JFZQb6mpXe5DJJ3trQep9UNehVLpnnC7e5TCeit9OZe3FfW9Xy7/V6DwKjzelgD5+ba9bw0U00NIgGkHdzdJ92nS1jcAUO8oNk3HgNq1Y4H8Gme2OmtNW2UY9Nggy+0kRUNzSCKF5Pbf0I2LhOVLtaJhvodMvom6WzDLv/GCpNNW8h5Gx06gt
 cu00pO4o
 NCqaQ3XB9/KrQipL3DfoLEUwIhAloeOJo4jfrR4WeMYzkz2twJXJWWD0x+E11oul9/Vdq0h4k7A2oiG4EMPgi9b8g8n6PV8o0SizH9Gf9ykgmYWrS//DHtDZPUbCA4lorDTg0sjb6bClmhV7diY5izi/5hWK7X5oiPqm/aM8ukDvycNwZudVo6eg+V9mjeg640P5s24K0jj/ZIFpFJ5jNzN0dSWj58x95e+l6D/wAFWYXcZeImIoPNs78Lt0vRj0aUOVcBJ2cneqfdfILylbAcPAk0fgr84d03YtjTWj8Ar7cZCjQ/1uJ4Fu6mx6vEzPBg5UtzAqlc9R7PfpZNSP/JgToMsWikizGc5WvoiWTTgnpwSX8ctcEGJmL09IZFYgCTMGvfQIxrmVSvFuA4R4YQJeav4m+IiihBzPh2EwRQT1aQGycbk7vSBXNTxkOTournrC1BSYztRPspfcW/el1mutchJwn3NMDh8WkFRY0SpkUvZV+w7xP+SCySmuD3dHKfchk04OM/Y474NjyEoi+Yy/9uq7ZL34wae3rmlRMkyRMzax+eYoZliDH0DlTODAfrrS2E96MgXIvxHFAq3EWHmg6AFPqvLnasCDaN9JC5NVHiTwq9p5Tnks4J3ivEcmKYz1N1n+SnUhcHNkcCrGaNeum5vEvzflH6V/dXTv2+rM3GVZEuUmRm86O8k2z0eqBZFzMf2RM521Szw4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This patch series addresses an issue in the memory failure handling path
where MF_DELAYED is incorrectly treated as an error. This issue was
revealed because guest_memfd=E2=80=99s .error_remove_folio() callback retur=
ns
MF_DELAYED.

Currently, when the .error_remove_folio() callback for guest_memfd returns
MF_DELAYED, there are a few issues.

1. truncate_error_folio() maps this to MF_FAILED. This causes
   memory_failure() to return -EBUSY, which unconditionally triggers a
   SIGBUS. The process=E2=80=99 configured memory corruption kill policy is=
 ignored
   - even if PR_MCE_KILL_LATE is set, the process will still get a SIGBUS
   on deferred memory failures.

2. =E2=80=9CFailed to punch page=E2=80=9D is printed, even though MF_DELAYE=
D indicates that
   it was intentionally not punched.

The first patch corrects this by updating truncate_error_folio() to
propagate MF_DELAYED to its caller. This allows memory_failure() to return
0, indicating success, and lets the delayed handling proceed as designed.
This patch also updates me_pagecache_clean() to account for the folio's
refcount, which remains elevated during delayed handling, aligning its
logic with me_swapcache_dirty().

The subsequent two patches add KVM selftests to validate the fix and the
expected behavior of guest_memfd memory failure:

The first test patch verifies that memory_failure() now returns 0 in the
delayed case and confirms that SIGBUS signaling logic remains correct for
other scenarios (e.g., madvise injection or PR_MCE_KILL_EARLY).

The second test patch confirms that after a memory failure, the poisoned
page is correctly unmapped from the KVM guest's stage 2 page tables and
that a subsequent access by the guest correctly notifies the userspace VMM
with EHWPOISON.

This patch series is built upon kvm/next. In addition, to align with the
change of INIT_SHARED and to use the macro wrapper in guest_memfd
selftests, we put these patches behind Sean=E2=80=99s patches [1].

For ease of testing, this series is also available, stitched together, at
https://github.com/googleprodkernel/linux-cc/tree/memory-failure-mf-delayed=
-fix-rfc-v1=20

[1]: https://lore.kernel.org/all/20251003232606.4070510-1-seanjc@google.com=
/T/

Thank you,


Lisa Wang (3):
  mm: memory_failure: Fix MF_DELAYED handling on truncation during
    failure
  KVM: selftests: Add memory failure tests in guest_memfd_test
  KVM: selftests: Test guest_memfd behavior with respect to stage 2 page
    tables

 mm/memory-failure.c                           |  24 +-
 .../testing/selftests/kvm/guest_memfd_test.c  | 233 ++++++++++++++++++
 2 files changed, 248 insertions(+), 9 deletions(-)

--=20
2.51.0.788.g6d19910ace-goog


