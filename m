Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9456B606D80A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Vx35EpeA
Received: by kanga.kvack.org (Postfix)
	id 97A056B05B1; Thu,  5 Nov 2026 00:01:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9247F6B05B2; Thu,  5 Nov 2026 00:01:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8393E6B05B6; Thu,  5 Nov 2026 00:01:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5958C6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:01:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6B65160948
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:00:59 +0000 (UTC)
X-FDA: 85399865838.24.834B05D
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3D84714000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:00:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Vx35EpeA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ehAwqn1JpFtE8NSK2eGRtzEx7P6AYMWxr9u3z+M2YhY=;
	b=OckJYGN8MXxsbLlGGxcAcmB3sscJFXa2xzlSSU5ukns3e6rxUEspxMpyb+FPL/OKfztZ3W
	+hqKWxVWfiAjJor0GM41wNAKdV4Jh1ndQnn5MmO+6GO2aLomkDYpxIihSvpKhrHiLmh4vi
	Tyyvhx3PK8AGkkw67H+5ugn4GteDMAA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854858;
	b=kzs4R6M/BczUNUOFCh5mp0++mPVyqLaUhI/RjOjVbMSsl8ljEC1Zf5HqjXuEaBTEYPlCEF
	UM+ksTToKjdALO4scm6YBGMZTsPnmBrDCi/qvzh4Su8JzYIQNoLhfpo7+ZkbjMKBWSIDaO
	jDIX0/SmW0U+r+CZXOnRWxe3Fj1GkuU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Vx35EpeA;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5eafb65e163so998519e0c.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 21:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793854857; x=1794459657; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ehAwqn1JpFtE8NSK2eGRtzEx7P6AYMWxr9u3z+M2YhY=;
        b=Vx35EpeAz0R/UuLleFx41S7PFZ1z5M4P1OcvksCv80ZYdGbmnb1vHZO6tZMzFcE3iT
         QNhUmT8/wzrOnlQUjrTlRpw6T5086pF7xwO66hZLFOa24c4+XxfAjK15b6VE+wdZNKeI
         WOXv2qmkjYEfDQX14i+IJHLg3P/U1dn05eOGeSIKQTkj/GUC+w0WQ0OZusFsKTegTe1m
         ZRUP5QBbWioRFO7bpc76wBsDpQNVRTHrtfAwTPvvgWiOTefERaPNFQlJQVBqMkuOWcJC
         jfatRVmI3T/edIA2p6jGk9AcYXGRZhjadDiX4GUmmcnLC5hyrWLxeHi7+y9U8Ms8mDfc
         g1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854857; x=1794459657;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ehAwqn1JpFtE8NSK2eGRtzEx7P6AYMWxr9u3z+M2YhY=;
        b=l1TomKulyxwLeF1I2YOazc7iN11NVWZpsw6FztwKHOJShiPZKpihWawG6/m9LJGLnM
         Ny2e8zeVf0c/FqmZqu9fc/p1Q88BQmNQBqVD4/oEhaTRXojDCwY3DZiasU1nhOqPr9Yn
         NjsI6u+2zwXNpR1W61EqUd9PFjRb3xOYwyXsdYLY43XQi+GDiRKycGpyZn9S5oq/0/26
         YYGos2WVRH1IKH77oYxoqWtZm+FLQTbu/vSNEIKcYDydxFYFeGvTo43ixn6MbDjL5+92
         O22hDdA0d6KwXm8/W7YQX37+urgbiYMJ2l6vWOPR7mG3cOrgTN22yXhNfD62GriR6XiI
         a5qw==
X-Forwarded-Encrypted: i=1; AKwUvBz5gVn52uWE771A8qDIamdj1dh+oYHNs1Tx/KSfG2nayMOcJeYJxRMEHWE2Uc2idaMIBE/P/sp5Lw==@kvack.org
X-Gm-Message-State: APuU4Z8o5DJcspXc1zXYIUGsIl1+fVhHn0HejsRbe4sYsLW5Ynke/uHH
	aeavqQU4jBcL7kLaLRFzSTJ6RLFBuBE8GnCZ/WzUwfsqQC9mVHQCdacbmo2c8pPb9WE=
X-Gm-Gg: AYBFou1yt/xGGlpCIsmFnJYha+ihEdTNYYL1fOp3pTyTKwWrWJ1AGoApEqRaRf5lOx8
	Q51m+Ik0xB+HLVP7DefuHrLXIjvQmx1n8GfPmTCWCB9bFjOTFXQjSEn/zx3ugnrnC2c5lXKYxtW
	oVQRxAZh4AnqOvuBQdnCrRKwQgT26O3CIwn/IXZ2qbYtK816CTkWUlhjBdYeXF94jYW/gQ9hse5
	ZmlSg1b1BQhz8YCTwM+B1pEMImb3fa4C5DUEDu6AsJjc624FxbsRQ4X5Gjk3U1UU+qyknUiXoUl
	ZPm3N+/RUM7onDc8uo4PDkgnzpVtnaLosQbNFXQHuVZX0QFPlQMlPECg++3+iuKn2gpkrXy3UwX
	JmkH9TBIKpJM5GjckbePY3/EFBEfDCyFNPIp7OBJERT97o3C7DiduBvIZOHxWQDO0YlvnNolrv2
	n8enZb6TmxjRNGu7GTG3qbKi5N9S0drzEXKNxTIhoGbGK6D17HcNC2z50GUQlSsN12epd5YdyhZ
	v6IfYTS7+oZMI70LVPL6HocB1sFgijBI6yWH0N8oLtr7kSILLD58D8s+fqtwK+2ocEaWIFUT/mJ
	uegvMcTQwW1XouMIXLzft15HHC6Mxjj5mWB2Jle7Oayv/w0lVqSVbAaQzebp/mmcnGpHXze5+VN
	l7iQ1fKiFrDKDID+jPrm0BE3g+J2FhA4UIa1C8b8OfCs8/6MgYg==
X-Received: by 2002:a05:6122:6984:b0:5c9:a60b:e5a6 with SMTP id 71dfb90a1353d-5ec689bbc49mr8844831e0c.17.1793854857202;
        Wed, 04 Nov 2026 21:00:57 -0800 (PST)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca8d9d62bsm3305282e0c.8.2026.11.04.21.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:00:56 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	graf@amazon.com
Subject: [PATCH v5 0/6] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
Date: Thu,  5 Nov 2026 00:00:46 -0500
Message-ID: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kejon5ae4f6p7j3yddpa1nbac9zhg19t
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D84714000A
X-HE-Tag: 1793854858-140591
X-HE-Meta: U2FsdGVkX18Wlu+2qulEgW0QEiC7twBS64l0k3ULW41Qqkv9jNMLMTwMw/oubXpXT+LioAVjbsba+O63IKZq2PitCqNre8Ll7op6/pls9LzZRKD33+In+P/GajHnjVgsvyDTPsCienuA7uoQDW83O8fwFyRpSW4LAfyHItnPeMhRcZXBaqFc1ih8HEO2Io3rZLSAiS1YKYCNpbDoZYV6/R0ZAhAxqiG/9EEZUrbbd9rIaO8bC+DAUCFrnz31siqFzMSC/38cBoJSBqchANq3DHFq2x5NlYXxogNRQK1KoaOu92kGGX1RmkeZ4tbpmvSdYrhGPIJV+i9pWFuF4xv28gxFB4x8WFED9miz1zTGOYjHtOAlfBj1sMENQaOll8IdJpgPQAlYqycpIUAegudVMEC9YrCZ02B8UtMMu7khTsjHgyj5W5PZmL4s09HDzJBHQcLDxtyN4HKzktUbdQx6ZiGNfzWdIExZgajpMraBAwxg23nuG1pwYwylqRFBI1fS8KJaIAyPqSD2np8Uoc0g0JnmHpP7xyeAQxHV58S2yFjfobkDukqco15UBvGysPvdkQqxiHPlV4UeHqYKdlK7VeWwy4kBDM9jyOrJARhazJcaXMz6BbwB9HrlylOl/Rc8eOUp+LmjM1neMqyg1Pol+OnkAJ8gawpnms49hqsM7JTLQQOmA4JEdIsUiQAq8KY7FjrKmepuDIvv5duKmQojdRTj/+mNKaUCguzhoIs0rgb3lZ5Iw+cr2UdE4GWkgDbQMDCKnDw3zs5Z1jtMXNkTBaiBVU1zkhMWBjNhhsKf95/QlYj4GxFEGjMQirSBnmF70/q1KrAZpA88HByJnhvsRffKjQKJKca4hZUngwgH+3/ib/lHSCYXd32hxJizeVqGwF2FIwhurk8TSy9AwgZdhCPfhzhorBcb+LMb0+u2FefMPCurOgPyb52E0K69ZRGVwbrTEHR7dQqXlVZVShB
 IYjs1uXx
 mQmFBP5/s9IO5KoZBdYmud8ZsPKntWvQsXEO4XHc7lKxhmjB04ugnpukF+cdCKhFbkzHM4wOm1PPR5U1dfrekzm/qDNEHbuE5MKxlgSylHhbc5ETrljW8C5yIHtF5Aypf6QxDOgJW6E002Ujdhykl1SqC/qLbgfQ0wwTM0VdrhrA7/m0GMiX1/YUrSj08Eqh7xnEjI3oyCY8J0gCVNCyMPQQg6JwW4r5qwvHkQQuajgVXoDOR84LYRHEeKUtFw3uMUfW3CJhhA+iYEAYSyEMIkfxXQ7CeL9QV1h8oAN9oHnmoIEWUU2gJCTeBcQmfJMt3sHfpD+/Wjd6FOot7x+KMBg1nxi1INdB0DNGDdYShHCrPxgz9wkX5ItXxFqbhrS64w4XF3rQK5Oe1iI6U5nzI7ICEQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, LUO freezes outgoing sessions only inside the
reboot(LINUX_REBOOT_CMD_KEXEC) syscall path, serially under global write
locks, and binds every outgoing session's lifetime strictly to an open
session FD until reboot.

On hosts running many workloads (such as VMs or stateful daemons),
workloads do not all pause simultaneously inside reboot(): they quiesce
one by one ahead of the host kexec. Userspace needs an explicit
per-session freeze point to snapshot final file state (.freeze()) as
each workload pauses -- concurrently across sessions under per-session
locks -- along with a way to commit a frozen session into KHO so it
survives closing the session FD.

This series introduces LIVEUPDATE_SESSION_FREEZE on session FDs:

1. Freeze (flags == 0):
   Freezes all preserved files in the session under the per-session
   mutex while keeping session lifetime tied to the session FD. The
   session stays frozen as long as the FD remains open; closing the
   session FD before reboot (for example, to abort the session or on
   process exit/crash) runs .unfreeze() and .unpreserve() and reclaims
   all resources. At kexec time, already-frozen sessions skip the late
   auto-freeze step and are published into the outgoing KHO subtree.

2. Freeze and commit (LIVEUPDATE_SESSION_FREEZE_COMMIT):
   Freezes preserved files, immediately inserts the session and its FLB
   dependencies into the outgoing KHO subtree in O(1), and commits the
   session so it survives close() with full ownership retained by LUO
   until reboot. Once committed, closing the session FD (or another
   session failing to freeze during reboot) never unfreezes or
   unpreserves it. This allows processes to hand off preserved state to
   LUO and exit prior to kexec, and makes committed sessions immediately
   visible in the outgoing KHO subtree before the host reboots.

Overview of the series:
- Patch 1 decouples luo_file_freeze()/unfreeze() from
  struct luo_file_set_ser.
- Patches 2-4 add incremental KHO publication helpers for kho_block
  (kho_block_set_it_append()), LUO sessions (luo_session_publish_one()),
  and outgoing FLBs (luo_flb_ser_publish_one(), replacing the late
  luo_flb_serialize() reboot pass).
- Patch 5 introduces LIVEUPDATE_SESSION_FREEZE and
  LIVEUPDATE_SESSION_FREEZE_COMMIT and updates the LUO core and uAPI
  documentation.
- Patch 6 adds selftests covering both uncommitted and committed session
  freezes across unit and multi-session kexec tests.

This series is based on liveupdate/next commit d80a5528df4c ("Merge
branch 'lu-pci-preservation' into next").

Changelog:
v5:
- Rebase onto latest liveupdate/next.
- Replace reserved field in struct liveupdate_session_freeze with flags
  and add LIVEUPDATE_SESSION_FREEZE_COMMIT so userspace can either
  freeze a session while keeping it bound to its FD (rolled back on
  close()) or commit the frozen session (inserted immediately into KHO
  and retained by LUO across close() until reboot).
- Add incremental KHO publication helpers in kho_block, luo_session, and
  luo_flb so committed sessions and their FLB dependencies are inserted
  into the outgoing KHO subtree immediately on freeze, dropping the
  separate luo_flb_serialize() pass at reboot.
- Keep luo_session_freeze_one() / luo_session_unfreeze_one() in Patch 1
  rather than renaming them to luo_session_serialize_one() /
  luo_session_unserialize_one() and back once luo_session_publish_one()
  is introduced.
- Update Documentation/userspace-api/liveupdate.rst and kernel-doc
  across kho_block, luo_flb, luo_file, and luo_session.
- Drop v4 Reviewed-by tag on the modified freeze and selftest patches,
  and expand selftests to cover both uncommitted and committed freezes.
v4:
- Split out a preparatory patch that drops struct luo_file_set_ser *
  from luo_file_freeze() / luo_file_unfreeze() and moves file_set_ser
  handling into luo_session_serialize_one() /
  luo_session_unserialize_one() (Suggested by Mike Rapoport).
- Few more nits from Mike.
v3:
- Renamed session->frozen to session->user_frozen, - Pratyush
- Added Reviewed-by's
v2:
- Rebased onto liveupdate/next (commit 27be83a12b24 ("Merge branch
  'lu-pci-preservation' into next")) and split out early session freeze
  into a standalone series (tmpfs preservation and its per-file user
  argument plumbing were spun out into a separate series).
- Patch 1:
  - Drop struct luo_file_set_ser * from luo_file_freeze() and
    luo_file_unfreeze(), and rename the session helpers to
    luo_session_serialize_one() / luo_session_unserialize_one() so all
    of struct luo_session_ser is populated and cleared in one place
    (Suggested by Pratyush Yadav).
  - Unfreeze the session's files if luo_ucmd_respond() fails in
    luo_session_freeze().
  - Update remaining reboot-only wording in luo_file.c kernel-doc
    comments.
- Patch 2:
  - Add checks verifying that non-zero reserved bits and freezing an
    incoming post-kexec session fail with -EINVAL.
Link: https://lore.kernel.org/all/20261015093816.2438942-1-pasha.tatashin@soleen.com/ # v1

Pasha Tatashin (6):
  liveupdate: Move file_set_ser handling to luo_session_serialize()
  kho: support incremental entry publication in kho_block
  liveupdate: luo: serialize sessions via per-session publish helper
  liveupdate: luo_flb: support incremental outgoing FLB publication
  liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl to freeze sessions
    early
  selftests: liveupdate: Add tests for LIVEUPDATE_SESSION_FREEZE

 Documentation/userspace-api/liveupdate.rst    |  30 +++
 include/linux/kho_block.h                     |   1 +
 include/linux/liveupdate.h                    |   3 +-
 include/uapi/linux/liveupdate.h               |  46 +++++
 kernel/liveupdate/kho_block.c                 |  86 ++++++++-
 kernel/liveupdate/luo_core.c                  |  10 +-
 kernel/liveupdate/luo_file.c                  |  94 ++++-----
 kernel/liveupdate/luo_flb.c                   | 111 +++++++----
 kernel/liveupdate/luo_internal.h              |  16 +-
 kernel/liveupdate/luo_session.c               | 178 ++++++++++++++----
 .../liveupdate/lib/include/libliveupdate.h    |   5 +-
 .../selftests/liveupdate/lib/lu_utils.c       |  21 ++-
 .../testing/selftests/liveupdate/liveupdate.c | 107 +++++++++++
 .../selftests/liveupdate/luo_kexec_simple.c   |  22 ++-
 .../selftests/liveupdate/luo_multi_session.c  |  33 +++-
 15 files changed, 612 insertions(+), 151 deletions(-)


base-commit: d80a5528df4cdee5871243e392da08c2d5c92e43
-- 
2.56.0.398.g882cbad275-goog


