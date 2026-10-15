Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C17CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 09:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6640C6B008C; Thu, 15 Oct 2026 05:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613DD6B0096; Thu, 15 Oct 2026 05:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48D6C6B0095; Thu, 15 Oct 2026 05:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0EB026B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:38:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 004C8A0986
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:25 +0000 (UTC)
X-FDA: 85324360170.22.9DA46DA
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5A38D40007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fvEUb887;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792057104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0shlhRLFxXQ3R4nNuzOyegjpP8vI4RmInyPqxYDwsw8=;
	b=CqF7A4XGEWftBf6l4p2ePLl9nf/QfvtlRztH83/M7Xcn+AFBvoJXCQBvFE1CuGQzw3iQKb
	TfdZRGhUUgZ2R2ktGmPLKhI3QvLPSNpu5dg7DDHM9el85GjCdL0SAacqdxT0fReH/++eeW
	kAz3UZVbb+elm/Vz6OUlK/cOIjb9UIs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fvEUb887;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792057104;
	b=DnWdZApHWvJn9n01aDQ9PFe0mImo4KCNiG6ZbrpqKaMCwd+XKOsHCYq/bikw4Ysn8d6PJJ
	FKy7Kp1iKTJ1/l39U9knhRyixKhaP/1vAM7fF0xwekqa3MAPFt5Dc6SI8k85vx6xmTgfWH
	izVETM/XVxPyNbFLN4K7VfXLmQRIw8g=
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5e9405fbc33so2201337e0c.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792057103; x=1792661903; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0shlhRLFxXQ3R4nNuzOyegjpP8vI4RmInyPqxYDwsw8=;
        b=fvEUb887b7j1Jz9FXH6fjlvxbGB9W9tL+w/y3WCkHOtGUmKMNLdL/8ILQA9osea8hc
         u5gjYnM7gKQtd7HbTJLzl8VKV9J3gf7jpED7g7wUR/UbaRJWEWBO7lmPCM32xpc7AMvf
         XPbPZsiIfJjiNBUi65kf8KsA8WgM7N6CMiC9Kb/rozs07qoxUMniWe6B9eqcmqo2lovC
         AnlFPStCvDLMS51jOfv33qiXUb5XMGC1uBGpQxdVJmDEgldJMEp0S29GapoCoGO2pRmE
         +ac4XAi4k9k/XuwqjNVGOsCf9Hf/xiURg7N9QC1TgY+lGVOjDWhWk/9EAQABJvqaQ2Zr
         81bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792057103; x=1792661903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0shlhRLFxXQ3R4nNuzOyegjpP8vI4RmInyPqxYDwsw8=;
        b=ykCds+G79PyPjizGcco76AqyWFJYGsTynMCp0MxWlK0vG7ndqNU/x0msp7mbae/ibL
         zY9NIvQCLhrZwie+qvUh44Fx1bBo7WuFn5lbwLe6pxg++qwVtBedHxf5mpYnAKbDyce+
         AORMZE0vDO8+bA2nR3pcwkLLJp4h1M3TYyMGz6WySIBRCJlLTZWGhqZppVhbQdT3bbRW
         GvXY6cFD21uV6Lf4+k9AdnA76ZzHS7Qdz5zKFXqAUr2ZDlB6Ym3AvLxOqdtim+/OOayo
         PEB1G10q6fzdYZYj+cUvgfefp2zRBgJzVUlbXA2S5LqL6N29eFH/rNSeDvYDJpFbb2/I
         iwHQ==
X-Forwarded-Encrypted: i=1; AKwUvBxP0l7boCoOi/j/pLlN+HMIzxR+azTTJ6A60tP5tkA4BUyWvSnkaNgC70g5/FDdTqX4oQtpCOqJRg==@kvack.org
X-Gm-Message-State: AFq9FYI/6EqcVnZqmSS80zMJoig+VWwMBYca/nkzmZWVw7UPGkMQM5Mq
	xjAe/0yiVQe3wtG0Db0VAKYfvqwF9UcyA6U8OV+uuqwPUttTdoKTityr/U8/asojVY8=
X-Gm-Gg: AYBFou0LqglhLk/psXRBQPl9BTLpk4hC8DUHJ3DyG7fHWEJaoK1pYA38NhTRITinmcr
	nt1Ir2SdOuGiBAL5I5HHYxzxMqezv9UeRHK6BRQVxxEvT96yh3SG+sHsiBrnVID7JCzw5vB/YdI
	FI+CvjWKropQo5daaqv2hhpXi0KosZMK5GemGYEQgLQvTfAj+9U0Vwm/VbLcHpvaSNTN3l+PgJ3
	RGnMn8KnfJuoudX2RKCIU0MxyhM0tRsfOPthWMmcbfDTGFxi5pdCUEHq1eLmvKjpUm+ft7ZNQQZ
	q6budJ5XT9qDiOA/5wNUp8HLNiCekDNHD4z6rjDHYrQe1+GgMID8M9i2NfjFHQSgJeSxdzpm5pR
	X6EE6zxs8VU+pFlhBVMRLwrSoDrXbMp+X0/Yd57KCHVjBh9xvHSP50nV0PSrIWw/IwiS7n0VeGY
	KsRl/QGQVgggIQcbzUx6dF3GCSVzSmV/wrEJxw357yrvN8e8S+dhCE9uJr36HMQHtEsNyKZpp48
	FbtWASLFeOgdkmwJohioRmwpvDp2yHFRTEPgK3YLMxwpFzcZm+bxdbX/jm7XQBVXWWuxzZsYZRJ
	AYZiyfq9jDNrLTGLExY=
X-Received: by 2002:a05:6102:14aa:b0:7bb:81de:ebaf with SMTP id ada2fe7eead31-7cb372b60a2mr4935421137.15.1792057103138;
        Thu, 15 Oct 2026 02:38:23 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003d37009sm12275672241.2.2026.10.15.02.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 02:38:21 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [PATCH v1 0/7] liveupdate: tmpfs preservation and early freeze
Date: Thu, 15 Oct 2026 05:38:09 -0400
Message-ID: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5A38D40007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: n43i7gnox79cwccx9m5gojna7okpasn1
X-HE-Tag: 1792057104-884214
X-HE-Meta: U2FsdGVkX1/Xtohd7bdpHZ5n+4+rpARWXmZKNU7woHSHiATjBTWOtmEB76vzxLCDB/fv5iYzw7IjS9/UgublYW6H0C1ha8PPdzcpERtmkwn3eBmVQpOb0YFv2zz8U8tuFSpNzBte7q4gVkEB6m3GBfR5lRl2wqgt5YZk+Pgr7JYt/aVrr8xwbIau1JM6T3M8DDkUl4dxb3a2DScsD6DUxhTXr/yDEhfMjoCgx1s57ooa+k5Yfm7nh8gxPXYroMyN2+Z+zqSPV6MKKC6AO8iKeXkVUnE9G7/Vw5jRn50Naf5GMOAC/YOLgC1i41Rjo51Gxyg8phsR5GfUCKcsqaK7jt3vcnslsYaYbxfJnYnARcgHSQ/Ibo5yn/v9CEaDlC8btvWr1YmVGRBWR6emiLa9oGXBUH7gxuKESvZkpsNYhEz0VX6bFlJvk7QyJXZrHdIoMAby48JFD3NQdLx/jSWnnP5U76xfyrSNdODJU/t1rGvTg2gzRK3XNisC5ZVb7oIP3QsnddbWoPrYo6AGzT/3+0hbKfDGCtlgDkUp6GR0PGEWOSOvd66VbjjZTBnBVuiZpB2WaYDlRDneQpKqv0iBqP/YogCj8hWRPquL1c4NkObRNipddtlu6JB9KaqUNwRZVfOa2ALI6NhsRzNyaVjytL0EOErQMe20uC1huLmH1JKwSH6r+6RrzPILVNwerNNgOl2Au7jGtzZEEuLF64H4QB8/kplT6UcgGFUtl/T41Q16aDwjVc0O8LXGgSFjmz4d1EwP8pFbXCc4QZWqZL88OnC3UVOHF9GSXwbA+zAomxcpBVT0s50+/Oth0G0RJ0bmEbxKdG+sMUzrlOfRyve97XcjEnzblPi9SzTVmRNgCWvs3l8GJkF11WJT8ENEHDADW84my3oVVgh74pS03+v9gTNoMHVC71HFTSRq55PwznTONYyg4pZhZmIewBIk59f1YDg+PnCUK+cfE5FJbMB
 4SI9ACuY
 SqQV3qTymWWN9pdmgtUdyAeNIUQA6Ul8hcYzGCP8FFRvjdt+KN/x5mCIoxKnnoOwJPW0/HDhcduPxlWiUQtkML330GFv3QLjOjTeQ2RJU1l4Jm7/mDSDPDZKwn9/zAXxSEMFMUrZuO+Ge3f0C7kQYuGEbLORvHdbB1xqroZQg/qxXvaXK0zQbGTwyd30x0o9OWNOHzC29MB66OZCQPvot5X8vgdEmgS+FW6Bs0d1G4nmJr1povAGF14R7KeEipRIUYhe7WfjDo6n+l64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series allows preserving files in tmpfs via LUO to survive across a
live update, and allows userspace to decide when to freeze a session
instead of delaying until auto-freeze at kexec time. Once userspace is
done with a session, it can freeze the session immediately (and across
multiple sessions in parallel), reducing blackout time by not postponing
this operation to kexec shutdown where all sessions are frozen serially:

1. Early session freeze (LIVEUPDATE_SESSION_FREEZE):
   Currently, LUO sessions are frozen automatically only inside the
   reboot(LINUX_REBOOT_CMD_KEXEC) path, where luo_session_serialize()
   iterates through all outgoing sessions under global write locks and
   freezes them serially during shutdown.

   Add the LIVEUPDATE_SESSION_FREEZE ioctl on session file descriptors so
   userspace can freeze a session as soon as it is done with it (and freeze
   multiple sessions concurrently, since luo_session_freeze() only acquires
   the per-session mutex). During kexec, already-frozen sessions skip the
   late auto-freeze step; if an early-frozen session is closed before
   kexec, its files are rolled back via .unfreeze() before being
   unpreserved.

2. Per-file user argument on preserve and retrieve:
   File handlers may need handler-specific context when preserving or
   retrieving a file descriptor without introducing custom session ioctls
   for each file type. Whether the argument is required, optional, or
   unused depends on the file handler.

   Extend struct liveupdate_session_preserve_fd and
   struct liveupdate_session_retrieve_fd with a 64-bit 'arg' field pointing
   to a handler-defined argument structure that begins with a 32-bit 'size'
   field. Because IOCTL_OP validates a minimum struct size up to 'token',
   existing userspace callers passing the 16-byte structure remain
   backward-compatible and have 'arg' zero-filled by
   copy_struct_from_user().

   Add parg and rarg (struct liveupdate_arg_spec) to
   struct liveupdate_file_ops, initialized via LIVEUPDATE_ARG(_struct,
   _min_last), which records the full struct size and minimum required
   size while enforcing at compile time that the argument structure begins
   with a 32-bit 'size' field. Core LUO validates the minimum size and
   copies non-zero user arguments via copy_struct_from_user() up to the
   handler's expected size (or rejects them with -EOPNOTSUPP when the
   handler does not accept an argument) and passes the kernel copy to
   .preserve() and .retrieve() in struct liveupdate_file_op_args. Also
   allow .retrieve() callbacks to mark early argument/target validation
   failures as retryable so userspace can retry
   LIVEUPDATE_SESSION_RETRIEVE_FD without losing preserved KHO state.

3. Tmpfs file preservation and retrieval:
   Using the file handler retrieve argument, extend mm/memfd_luo to allow
   preserving generic shmem-backed tmpfs files (not just unlinked memfd
   pseudofiles), recording MEMFD_LUO_FLAG_TMPFS in
   struct memfd_luo_ser.flags so that preserved tmpfs files must be
   retrieved as tmpfs files and preserved memfd files must be retrieved as
   memfd files. Introduce struct liveupdate_memfd_retrieve_arg so
   userspace can pass a writable, empty, linked tmpfs file descriptor via
   the retrieve argument and have the kernel populate its address space
   with the preserved folios.

David Matlack (2):
  mm/memfd_luo: Support tmpfs preservation and retrieval
  selftests: liveupdate: Add test coverage for tmpfs preservation and
    retrieval

Pasha Tatashin (5):
  liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl to freeze sessions
    early
  selftests: liveupdate: Add tests for LIVEUPDATE_SESSION_FREEZE
  liveupdate: Pass user argument to file preserve and retrieve
  selftests: liveupdate: Add tests for preserve and retrieve user
    argument
  liveupdate: Allow file handlers to mark retrieve failures as retryable

 include/linux/kho/abi/memfd.h                 |  13 +-
 include/linux/liveupdate.h                    |  74 ++++++++-
 include/uapi/linux/liveupdate.h               |  59 ++++++-
 kernel/liveupdate/luo_file.c                  | 152 ++++++++++++++----
 kernel/liveupdate/luo_internal.h              |   8 +-
 kernel/liveupdate/luo_session.c               |  58 ++++++-
 mm/memfd_luo.c                                | 144 +++++++++++++----
 .../liveupdate/lib/include/libliveupdate.h    |   6 +
 .../selftests/liveupdate/lib/lu_utils.c       |  71 +++++++-
 .../testing/selftests/liveupdate/liveupdate.c |  84 ++++++++++
 .../selftests/liveupdate/luo_kexec_simple.c   |   5 +
 .../selftests/liveupdate/luo_multi_session.c  | 110 +++++++++++--
 12 files changed, 695 insertions(+), 89 deletions(-)


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.56.0.385.gd3acb90ef8-goog


