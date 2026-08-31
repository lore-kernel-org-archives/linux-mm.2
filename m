Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E055CC61DF0
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 02:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39A06B008A; Sun, 30 Aug 2026 22:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6026B008C; Sun, 30 Aug 2026 22:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85016B0095; Sun, 30 Aug 2026 22:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA376B008A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 22:59:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2772EA03E6
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:59:15 +0000 (UTC)
X-FDA: 85160058270.16.0F55267
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1CCDB40002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:59:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TKt3RH9y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788145153;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VBkMjLhCwWXOFeyRJOAOZa88lrqhXcBtmFB4cgMI3RA=;
	b=tHfRIXC1ANswD7XdrDmKA14qr8ydCmtA6YZdlKPank1hE8Kydd1iGrLKuW/zukCsDZE8b9
	Bwt1OOLnmbQyTsC/YRCqMw5SfqrSmB9tarNMfbQqjiOuWauSQbK75jBUlOM6uI1iM5HpOY
	g0ipLomUz2rjeEnk5p8BH8d3H00whcg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TKt3RH9y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788145153;
	b=HbeCknaokXupG9+aGGsgefKfAZNa8Mj/gN2h6kNJ+NtCYXMHH7vRT9y0yW4vOX4MhFLOEA
	SUqGL0KZr3bUEIIKau4G0hl7ThVFIx6D2ZrMgXzDn5OL0kbe/R2s5qrwUKOd3xIH1hukHH
	Q0m8eVpVLRHBzMjo80GnwUXyVsM5+XA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD3714126F;
	Mon, 31 Aug 2026 02:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BBB4C2BCC7;
	Mon, 31 Aug 2026 02:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788145151;
	bh=RMKGmZEdzeP7q4RQyJWLL5ub3gwDxt6jUsCX6DmjrtY=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=TKt3RH9ywQh+2U+bclod27pUMCxZgwIvkUJdtlPCxfYjm7Uabt3JtfceAakC+o9Qv
	 4UT7x1TQCIIpab/pm17iQBOeJ5gqOBCLfmlj5MsC9Fa3EFubPbJ/BrYqkg8lMAXyOg
	 DswiXsCZ5EbzaFkkeLBMYX/YMZfqOIiMDkiBEhbamv7Ul1oJiOAMiiQZeXm4txn/7a
	 /0gVJTfoxrqo9gBIWQnjZod1wX618QP6E+WuPgN4+UwaVa/1Tp3YvgyNUYB+1CLbyK
	 UW7alQbh0kpPDYeOAYAnu9Nz/swlgQ7w7zHaXLcxTi43DGHRQdSFMvbNLjiISfV1Bb
	 R86G9pYd56NBg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7596AC61DF0;
	Mon, 31 Aug 2026 02:59:11 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Subject: [PATCH v2 0/3] pidfd: add task path ioctls
Date: Mon, 31 Aug 2026 10:59:05 +0800
Message-Id: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPntlGoC/2WNyw6CMBBFf4V07Zi2PAKu/A/DonQGGDFA2ko0h
 H+3oDuXJzn33FV4ckxeXJJVOFrY8zRG0KdE2N6MHQFjZKGlLmSpKpgZW4SOAswm9B7yqsgklhY
 VkYir2VHLr6N4q7/sn82dbNgzu9GzD5N7H5eL2r1fXcu/+qJAgrEpEWVSpphfm4exAyD54WxHU
 W/b9gGsVnX8xAAAAA==
X-Change-ID: 20260819-pidfd-get-paths-59640d8cd1ee
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
 Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3549; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=RMKGmZEdzeP7q4RQyJWLL5ub3gwDxt6jUsCX6DmjrtY=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBqlO37ZFQatvNIJ/XqWG5+bT55C46sV06hh7vsz
 nV6esn8i+SJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCapTt+wAKCRB2HuYUOZmu
 i6b2D/4puD5mcrb6qIcY8fPVCL726xa5XVAfOmZYE6ujw+AMfe7DCzs9at0X6tjITAq79046tno
 R5lu9W07Yl/SyM8SQbe8qFMyICkr+dCQ3aBgLyO02B3xMmq/of+Zl9hwX+mo3B5v6WOesIdTwDQ
 ApCXcjyvz/BhV+Xa6QLduRrop2wnXfW6V6xCtLzL5hbJs1uwmo+E32dxz8vTN7WnkaR1/ZqRIxY
 hqOD3WZzgdr+xYctOVSe59+06DaT1Ziry0N96FozDQvkNZSkutS5jo1TTScGN9tbczg4yoyYKpU
 koJVijkxkaTvuGAKoJSLr3PKRljhvkHdo9/wMlXrNNjYG1Q2WRyqqG/z78ocMahd/9MSaPC6x6y
 7A2kv53KAl0orXsUKgHWUIeG4gzH4oZn4c2cZgecEymfASxrfpGLZCWAGE+vwcjzNjoKe/UNpEd
 zcxjqRzNnH/rqKgf6HaBzhct7Q0tQLRiVXg8zRgqiVchfEVZ0JOGR2G6DtSl6D14PB6uPEDZi94
 3HuakPqCsEKOzCKy192XUvPpBc/NsXTV5OvqJIYMteXtl16ZE28S9msyF4sC1sJscpVZRKuu/c3
 vVuQalPUCIYjCo2Pu9b4T0FwHNyGiCABxIPhgoxnuwB/dB+LhKkt58Y+pMUC1AK1GGj9JwkRf2M
 2feItAuIEwUdetw==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
X-Stat-Signature: sj7i86uxpk1gh4wptp943cgierm7xacz
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1CCDB40002
X-Rspam-User: 
X-HE-Tag: 1788145152-499014
X-HE-Meta: U2FsdGVkX19BjXQd0h4D2YuEFoBNtwXeRlF2sDOauh7nJVMqUZwpL6HUnE52Anm+PwNrfGJsRe5FzZC0y7mi01MhxlWMir/FcqmlwuWFvASLH/qz1YnssJi28lUmuFUy4BMbcGSljrP+OnNJi+EcQhPxPvO5wuZ+4SIRs8Bxxd90nlpNPrK+Hze0zID71IIgHlqUitaZO93AlL/9puxvpTjYsYFn3oeLDelRDXIpT+6xwjGpeJtPMl7fwDOQowWXVIRJIjjfPwKllxDED8KzemVECgAgzhYa2zlHou7wnGOi9Iu4lIpDFBRfnsPjKrEXJMAVPWyR/DH4+jP6VPjDqpNMB1IvyQiP8tis5tHhjncSoJ/OxMYX53NqPqKzYNNzT+2lBWVZgVZdC4Bt6/azXFqFT+kZLIbZ3KBi5Cntd4wrD3UhNqluLz8FC/q/QMcTucXN2AWfKAnqPF70zcUSqVr14vD3/1FawPv09UKG6K44TUGKRe92vXtH66FNvD/fYagxkhyrcDBvwzv8+66XJ2tveuDbmMRblfIatTivBc/KUpFYnHE2JW3SkTLkGpgZIYvvwIbKj+dQ1ne4poJ/1kS4c23ZnQyoQ9vVjhUs1rRQ29Oy0q1XcFzYhPjYOZ7+BXhyuGftwsbGbrENIgss5Mo/0k0BRt1V7GSbw7dVM7n67wEuKFGgRvEL8Nh5D1sW0CGcOmly26X5PysWVi6eAXRJ2Bp5FcC+xi3EGumB2kCjYnhSfqFIRLELnd6cQpm5uPTb10iHou2C+oLbu5DB6Nf5K6euxu81sPY4E59l9Ga+oIEOQZJuevp4tUrB8Xayh1fEsgUBmG7ohrGRQBX3x+LK8Qlns2qQCRM5020v3eYt+/5meobL5otCCFw3fSHIUM5BeULkrtW3hT28tgGiQ0UZ7M6DCz4InwS0rsZJyKeWPEt5fZO8YpxG4mZXoOBh+hK4P7QrmBfrQJAWKUW
 pIqxzYCI
 Azs2RShX8JQo8gGYQ0wf8f6U7/otpvFPT0dJ0V2SaJydf/d5dgEfRjaPGGbZpVW2JNGkANbO1oNpbFHeyHjnDDwSv3bOccXH47BmlKw0vhF1E4z2vXlRXzR3jjwxmAayyNTSJr8/zMk5G94leJCYvr4dcDDLYZn/pL6JBGTrgsuSWRCKUWNA6XanvG+1EIyb4gtejNOuquCeYOARmo6nJixBGpZ0+oEuOj9+ACHPXq0bQprwad7YEVemDY+t9/L2QkcJVX8ABIZIlzBqrdGXbFLg+qArGzxS7NmdOCqygAtlbFT/RAkArH8Da/vya/BSUSbq43Jkf8fo7NeMaASCL/MCg5Dm4H7yPypunv8DjoxnHGRwav9aGm2Is9A0kSPcHrryrGZ79twS3ZRk6xUX+31U8QK0szE8OPwl6EBtxiLT3SjQtn2eq1cmS/lWLy0eNhv9oFap4+85gIOVjyoHHvJAztwuD0SvRoy//vTmDBZfb4VDvWpw7ffGsot3yO9JGJYSv0hzrZACQuR1IcjeEM5elfeKpSD9oLeUKra6aq43fhkSB5IInDtOMqZDEid69U2yY30mebGGl97CaEhpKS1nK+2auz1nTcpVC2GHPkK7qqQ6yx14ZTcc3svFIJatjMXpjQnnQanbTB7yPFTynEVJHW2BEFyKB+NCOIXdsJ0gxF0q+KwTNva8oEHC2Qtkiqs1NDby7bnk5/GspzS2XmCyi+b1q8yzUxH/hop4q+khG0tu5pfZvSVeEIrZDX0C9KnqgSwpJY0pJHcVgaO8KKg2LUKL0BzoFGtc3jc3qpC6Ab95BCMWtOX7l6KEaxECGrINKB1LCpIYA1XX3cKH7/EoS1TeMMIlpsLBK14h1ih9YyR0l1A8OgaP0w76hz70AC+3zAUkOMdrXlwHU33u4PjE/n37MTSVBNFHqRHXuWGia7k0b5jV7K9iFIRxYO6ItHOe/lhDbxSIr5hTR/BDAxa7OxsnG
 qAF0uMzt
 T9muBhw1J2OL+WdVsBHhoX4+r3OJI4ZsZ4L9Ez84C9MUSHJocaJHm6HuM/LvdH1NASzSk/KZ1g80jE+3AQsg2baDibSwGJQDzAshe3Oj3gng4YjMLc1GQOeAbHQkfAUDM2RFrUPv6lijcHd5fGojHrjWZQRgRb3lsXR2UyF50ozfhnY590N4iRO3kYvxw0UCcxL82Au+7+loDxLxqdsrRykXaIcIajhI6BGCIXM27hXxzFtd3YiZbxoyYPlZ4yo8JVM0YndWABg/IlTRLXHfEpK1YEeYSvhD1w5MQJYnfk6mbi6wftB50jsnPD+aDMJ/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Obtaining a target task's executable, working directory, or root
currently requires walking procfs symlinks such as /proc/<pid>/exe,
/proc/<pid>/cwd, and /proc/<pid>/root.  That makes the operation depend
on procfs being mounted and visible to the caller, even when it already
holds a pidfd for the target.

This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Each
ioctl takes no argument and returns a close-on-exec O_PATH file
descriptor referencing the corresponding task path.  The new ioctls use
the same ptrace permission check and nonzero-argument rejection as the
existing pidfd namespace ioctls.

The target task is sampled while holding its exec_update_lock. This
keeps the access decision and the task-state read in the same exec
critical section, preventing a concurrent execve() from changing the
credentials or target state between the check and the use.

The first patch factors out helpers for acquiring referenced task paths
and reuses them in procfs and AppArmor.  The second patch introduces
scoped cleanup for privileged pidfd task access and separates namespace
lookup from namespace fd creation.  The final patch uses these pieces to
implement the three new ioctls.

Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
Changes in v2:
- Make pidfd_get_task_locked() own the task reference until it is
  transferred to the pidfd_task_locked cleanup class.
- Link to v1: https://patch.msgid.link/20260820-pidfd-get-paths-v1-0-ac3eee4003d5@black-desk.cn

To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Ingo Molnar <mingo@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@redhat.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
To: Ben Segall <bsegall@google.com>
To: Mel Gorman <mgorman@suse.de>
To: Valentin Schneider <vschneid@redhat.com>
To: K Prateek Nayak <kprateek.nayak@amd.com>
To: Kees Cook <kees@kernel.org>
To: John Johansen <john.johansen@canonical.com>
To: Georgia Garcia <georgia.garcia@canonical.com>
To: Paul Moore <paul@paul-moore.com>
To: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: apparmor@lists.ubuntu.com
Cc: linux-security-module@vger.kernel.org

---
Chen Linxuan (3):
      fs: Introduce task path helpers
      pidfd: Use scoped cleanup for task access
      pidfd: Add task path ioctls

 fs/fs_struct.c             |  44 +++++++++++++
 fs/pidfs.c                 | 153 ++++++++++++++++++++++++++++++++-------------
 fs/proc/base.c             |  34 +---------
 include/linux/fs_struct.h  |   3 +
 include/linux/mm.h         |   1 +
 include/uapi/linux/pidfd.h |   7 +++
 kernel/fork.c              |  21 +++++++
 security/apparmor/task.c   |  12 +---
 8 files changed, 190 insertions(+), 85 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260819-pidfd-get-paths-59640d8cd1ee

Best regards,
--  
Chen Linxuan <me@black-desk.cn>



