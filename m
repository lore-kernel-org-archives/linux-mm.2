Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8828CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 19:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47FA88E0089; Wed, 15 Oct 2025 15:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4302E8E000C; Wed, 15 Oct 2025 15:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F928E0089; Wed, 15 Oct 2025 15:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7AB8E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:00:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB97E1602A6
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:00:14 +0000 (UTC)
X-FDA: 84001263948.01.A9AF40A
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id 08D3240009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:00:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0Q++cShO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3O-_vaAYKCCgacMLERKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wyihan.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3O-_vaAYKCCgacMLERKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760554813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cqsd/vPXiuTR4hJNd2SCH3oN5KwWIK1dnn9ppreK3H0=;
	b=jjkfzoSem1ElVYfPZEy25L74ok4XHmJl9rUAjiTGu4/zWMtXehQiDt5dV8R6PxPXXYZm1D
	RhJh3E0RpONz6ZvYLr+ia3XzcsmSYnIiyJnlZ/D1RvCNpmTkOQ2adJPRaS1zxBH0SQ3pjY
	f8jXFFtwI/FhGqqtf0p99K+0HCMAjxA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760554813; a=rsa-sha256;
	cv=none;
	b=ksMzDMukUy+8qkbJMOaCYDdQg3aCuicbrX5aj+2Wf7OYy3i1oawYaysT6dCZHdhKPBikFa
	KT9YbRzKzzsFjHOJLOtKuF+B+SKpX9FltnJxcxbyfZ3Vo93Us1w10SyRfp023b7yEm5Az2
	x6w1ARthLR/lM/vbdwcuQ+OpwtkI6ek=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0Q++cShO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3O-_vaAYKCCgacMLERKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wyihan.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3O-_vaAYKCCgacMLERKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wyihan.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b55735710f0so14571303a12.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760554812; x=1761159612; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cqsd/vPXiuTR4hJNd2SCH3oN5KwWIK1dnn9ppreK3H0=;
        b=0Q++cShO/Z2QJPnfs6DZlV8SnObtk/FB3nE1XErObRhp5UmjO1WL7nJFzoqRAj9b/j
         HuAcR+D+EpdezDO/47bv9Wy1JVPCW81jZ8W8Lsd0ZDVagTqF4o79aHhx7lQQNjc56PSX
         hMMbt7SLGQpWa9alxAuvCWUPDD4nms0rkjOwMAMbDM8FCxsug/5eTX1UYk7E1SR0S8jb
         xu5KfBn61IzLXEPM23JYChghjTwkEczr0gUoQcDZx0d8/W3LVKlHeipiS9mwjaHIuwPd
         qYAo1FnCq1lAiKCoT0HoISbXgtcpVeu2AMl6Xuj23m/PCCoJB7d2Ht3KBuA/mvPaxbjS
         3yzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760554812; x=1761159612;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cqsd/vPXiuTR4hJNd2SCH3oN5KwWIK1dnn9ppreK3H0=;
        b=NJlVxnx9+/xhyvHH2h1y6rJIW543cFt4gS5QLCdsPhmP4tsMIGEVUgSEeIlwMz7vZq
         oHSVCn22WY4EC+07DBGXmys6YHoFnzVDhJFV+C8aXBVgoU7/gux3fel3Fcspi9cn11Sw
         HVkpG0YKqBsquj2fp4L9e1x9DO3WKewcTyD7HLmIoendF7Vr1XjcLEL77N6yv1P9tQVZ
         h+urUX9N6vDlOaMbviQPLCm9mhlB22iDZAUa330L0KyZuaS356MBznYWDckyZU3P8FuK
         QRyCSNLkmBGSBmjEx/brse1PzkCvGkjiChA60E9ntvT/w6hywS9jTBhWORdRmzLZgLqS
         hxJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWuLGRIYEpr1oiySCvYrJqVeo9zqzP/TyXtrlBEbP6JEjxS2RImaSR4Ro4VViOjA9jmtbBVvJ2VQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0rLsqugjeWQhKibtEszSQEfURXTj1e9CNg4emSmN9sNxiqNTJ
	WsgUH2/TQYnk1fQFL/M+DeS/ShuptuPeM1vHlCHUeHVbEil001kMdw1iKCdYbeM9qpe018IYIHu
	mhVq8jA==
X-Google-Smtp-Source: AGHT+IFnNgFHzdVwVBgjv1vYxeJtKWTDydfUHZWWQm4sogrJBUuU/RaThVnJNJ/l8yi1LMJs0OC3cJqUm/M=
X-Received: from plhy4.prod.google.com ([2002:a17:902:d644:b0:290:9abe:4419])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec81:b0:290:6b30:fa8
 with SMTP id d9443c01a7336-2906b301097mr149049165ad.23.1760554811768; Wed, 15
 Oct 2025 12:00:11 -0700 (PDT)
Date: Wed, 15 Oct 2025 18:58:54 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <cover.1760551864.git.wyihan@google.com>
Subject: [RFC PATCH RESEND 0/3] mm: Fix MF_DELAYED handling on memory failure
From: Lisa Wang <wyihan@google.com>
To: linmiaohe@huawei.com, nao.horiguchi@gmail.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: david@redhat.com, rientjes@google.com, seanjc@google.com, 
	ackerleytng@google.com, vannapurve@google.com, michael.roth@amd.com, 
	jiaqiyan@google.com, tabba@google.com, dave.hansen@linux.intel.com, 
	Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 08D3240009
X-Rspamd-Server: rspam02
X-Stat-Signature: ygy3shcgkmwri87m4khth1whc3jtdhkz
X-HE-Tag: 1760554812-127076
X-HE-Meta: U2FsdGVkX1+mWQE5Vr1fJ3QjtXosZbNhVkFgx4tVczicbAnD2Y/CHA2jxmRkA7042Yt/2+FoZDzBTBIqTriqqlyvqJs1sQiORnxN5t5l7xm037MdnrnNkWJqVfeYgfbgQVLi9WNYO01bJWHBOMyn6qbapiv7xZX855lgozzxYgxM31Zxhs/QD0jgMOOhl9fcaYJ7lJf3N2pMrfYO36M+Bf6c1gwmp8Mnc7QJYRv33qr42nGq7rr0BvntmS49CIsRIu6CotcOoc4m4wG29YVyflgJxJ9Lb385qa2/9IKUjya+M4Mxv56zLOyZHHlv4AD7Gh5/kD4aGNgmCiKPxb50QBopAbwiErIR5oMrKk8ENYde0z6eO49rbFfKv0vetOkUfY7CheYRijUBfSd5BnEjBI0YidSsr42ljbeN2UfsREhgzetlZuFblbYdnMqDfm46qji30WQidyluMAFYffwbpZD97yh9BHXCoe9/bO/4b3rUVElbOn07OQGsJ63uIfYOQjekzuwsYaolQENSy1IZNLfrxNHdxMbU74CwjR+uY0Lk8tHilf77F+jfuEqT5ka1NgA+BbKpKN8JIXpEpjVwbX0dprNXMim2n7dE4QoWJ50d7zradgcqCTOmYZoJ6rHXG8ZR5yrL3Vfyiv4/2zGkrt2rZcyLiE87SPytUJ9r1MrrDfGd+9CgYHROmgyj9IdzfzesnspLm5eThO4pHoVatbjr92UsH87r3BW0NHtFaXpfVAzPaLY+3vzIBsSW5YypGHakayldBSwXpQkqlWLm6AZ5Q48NWiriJ954YGvBLoBfuWfXHtE8MH5J2mkmAAnRfV/n3ePNohYA/cNRGim/l0mG63TVMLMVPq3NK/9H666G7n0VQm84ktAfGCaxdK42v2qyBGcB8/PG3tkg8asAuHRoQOXCt9Lnzlqr2TDAQ7fMJuuuIxGh7BFP2g9xBRMfSQhfvHxp0My5tdgJeMe
 gnPtGBE7
 6aOk/pr2vU3Xsuz0ipDscUzGqQIIp9YicuYcJilm8ACZbGsBrKFskCnvJuH+BjeWhEvdmy71ue35cgaW8fog1xP5KkR4G8O3vJViRgjsNV1roCx6kXzftnp7Yyw+2EKB6M0CHwdKkbmrOID9oCiuQWp5aMVOb/qgEEupSpkMiSqmNLPR/9Ds1eyc6sUnQP/NTGbBmVZvOuFF7TIHTV9ytFrRovtWpVhDgKUcGx6nb78w+wA6Vz1YB7G/PDwS8T1LF/MMgaTfIftsXlTaFDZevsg3kudmIo1iBAb+vxQFcTxey/WxVFu7JzjROg6H0aelLcPwcIhPJOIGUJwg+m3p85QqtWtKs27pFAuqF5R5XVM+M+SpvX/HMWrU8DVroMUROsFREZR8v4MABYl9Lgx0xvNElewj8mhWiVSq7CzEOHOgJm/mx6/H3EcF+piUzWm1z2F3xX+KDDCPnzuPXf5qSWnypm8uV7geCA+vB+Vo8XaEiErbRlDIOk8n/2sV51IqdrtaOCR6MzmUu7ueS0Q4e/4iyXe7/kjgt+oG6llP98d4EdDwgmKwtr5ApZFcX/h658X5KHZZft9uWNGTBjT+8anNLUcnbzAfyDYjp9kqblE80ZXnkTHHGkl0R5Angk8C1qDdjyRPUF7mp888GxW+2O7lpoz2+R4YWI7VoSosqmcnoiVrVoWIwJluy8LH3twnKdPJyFS43vFMrSAM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>
Message-ID: <20251015185854.2-aI27LAkTVMyur38HRG8upvGWn-Kt49TfM8wHIRH9s@z>

[resend to correct the mailing list address]

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


