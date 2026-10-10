Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE50FCA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 10:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455B66B008C; Sat, 10 Oct 2026 06:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428416B0099; Sat, 10 Oct 2026 06:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DCA76B008C; Sat, 10 Oct 2026 06:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCB596B0095
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:21:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7465D1C4169
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:21:24 +0000 (UTC)
X-FDA: 85306324488.02.3E54478
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7AF5210000A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:21:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cmUsAjO/";
	spf=pass (imf05.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791627682;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WJ5ypd2G3CAz32QNoD9Z2PgKJgsTW+Fh8ZZVrEKrW94=;
	b=lmQB5974KehMlVo24MBkK0IV/HgdA1fAC0fLVcRvM0GzRYXxD76LIZbgrDXrD+CW16xYaz
	OitZNK1LgnKFkUb+Rczjy8jRGwQaEue+Q6oDQknqJHeo6ayLHEz0oxmCKWqDHVA+Bo7usP
	wfgYHTIJVfGcpAKGTGz2eZkIP1LHYaM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791627682;
	b=jLk4Hpk+BTSkUK3QpZHY+JXuR8BbG+vEus6lwLR/Xmo7WNsq00KOJpkOb6vEq0u9hhBs7+
	MOsPUABDkbOfQehmBzJApBwkGdxRY3tY2UFlyVo7YiztehPbPfSfomDUdzO08kcHNMfu5Y
	OUcr7YSh3vlKk8sGDGbsh+mmm3Nud40=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cmUsAjO/";
	spf=pass (imf05.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F7D7601EF;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3154AC2BCF7;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791627681;
	bh=TgTd211oqhG5HGYlI973E8KqCDKc5Oeemvo00Ob4OL8=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=cmUsAjO/8fOQm8Wu7nFGIifVL4V6XgnKn+5UpCzjGTroEHFiovKPQMAR+x5v7OoR5
	 JTQi/u4yMjF/l+GFHOZXAZT2K1h4ffbc9y+t4cJsgsb7EjB9iYq/e1kFEbOw0KXglF
	 jo/RG7pt3Splf543kz9O16fktt4a1tykni5vkCrJD/VwKRnQJyYmhjHBss5V6M8SDq
	 Xd+MwYDppexQO59H5GzerPZ29vA694Y51++H5rvpTSyXq7nG3H8VKiZlfw7aFBZL3P
	 LB1n5XIomAaMBsXjAfbGlPiEIDLz8uTGvgGicGmsWeF+wUS3rrq19AffXvt+nxdNct
	 aWS/AvysKhsPw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6E7CA6004;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Subject: [PATCH v3 0/4] pidfd: add task path ioctls
Date: Sat, 10 Oct 2026 18:20:49 +0800
Message-Id: <20261010-pidfd-get-paths-v3-0-f245440b2b30@black-desk.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIERymoC/2XNTQ6CMBQE4KuQrn2mP4DgynsYF6V9QNUAaWujI
 dzdFl0YWU4y881MHFqDjhyzmVgMxplxiEHsMqJ6OXQIRsdMOOUlrVgNk9Gthg49TNL3Doq6zKm
 ulGaIJK4mi615ruL58snu0VxR+cSkRm+cH+1rvQws9b46pxs9MKAglUDEnFKhi1Nzl+oGGt1tr
 waSHgL/MQTbGjwaqqhRlpKz5sD/jWVZ3uBuq0sIAQAA
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
 "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
 Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4362; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=TgTd211oqhG5HGYlI973E8KqCDKc5Oeemvo00Ob4OL8=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBqyhGFlEg1oLTbVChctiMxydeM+7PjwrFf6BR74
 5jDCIlEhsuJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCasoRhQAKCRB2HuYUOZmu
 i7vJD/9Hrm25jbDpfUc64kgjy8iRATYE2TMYLB6diuEQCIz7H1iL2mW93MuWwP3X989ErNtXZhk
 wcdjNkfx5ClKKnS0eJM0n+WBqP2H88p4GLPSk5PfFmg2l1TX6E0S0OkkCKCP8Ks+zewv69+YP+z
 BGOgltFVJWtyxPIAcXtn2nSby8bLmCDNgqvFzy9+QuvYSVQ7o5SD3XKcRAxX2w/RSRZBf3yvRLj
 Zci55BEaFRJRWhN6zFoT8IbyPRh2CxCsr0leOa/HFSPxqSFuHB/wWmt9ZDDP7qv4BATDXckxKbt
 Pv7iF/dYQJxN+rh/7deQ/KEn6lBD3oklYjxgIUMxRkDmVZsvOUZ5TkO0rJefnM5J5MdoFcg/aaV
 I7GoucITJWlMlX1bkXTzAiBsoCApkZ4B6M7t2ka2vnBNceKiHNowSMnoNgg2z5uDdGCXFZdYqie
 MxLe0Od2DPXHqKGj4NxoR2rQljt+3yF4h2Vd0Uw2cclXrsU+S17cr78INgv7hHTD9c5AjYjPO8h
 e0lDzLSxjUh/s93HeXNSkpjvZQRB+kW8oifAQ/dasIFjm3sqWu9LsmHwjK1RrPM5YRGWCuboCoj
 z16jxKJV5IMOv1xa1w2+oJs3blCF8aDd+X5KC4ig1N282vKrm66q8IjZvQlsPG+RmJ3TAnheECG
 urAVptAhXAnOCTw==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7AF5210000A
X-Rspam-User: 
X-Stat-Signature: gimc83nsmratyjoz78647ajncqsa6k56
X-HE-Tag: 1791627682-675392
X-HE-Meta: U2FsdGVkX19R1Ew0T8unz4WcRlUfalLlJjfd6aBSn90KRDPdNc/dkxpdMwSNOXNBP/iwmQ2975RXrzCf2lVWwbhRmkyHgAQBQUiM+DkvtTEDUs1FGeb7mjR7VuLduGXZKuKsjJpB2OsTwK1nKcw63dQZ2wgqbCZ/anTRKLAagd2Vqo62F6KGLMSsWX/XDcRUc4zkQqFQ7qpWfftgc4aZOQnKEXx7TqGroQfux4z2FLxxF399AlooAbhgbply70p9Rafx4cFDnOE5R2gIBLWICZq3ty9yOu3UMOVV+oRq6CymE12tkGZn/dRJnoRyJVGH1L625IThRGaeVjkJbu2fJYOQodayoEfkP+zz3CFHHqrI69fJncSXcCPhilmegZ3YdePX3aFv/1llx6aFHI+E/8TiNEDhZYMyoucD8mReDt7sDg9ZyZZah82sPCO8B/WET3O7qFzfe3sbGBcro/yETLCg/0/6rmXkazEj/PHEskfR+zI3LMhfacX5wkwpTvSN7bRVmZA74aHScgpkoScL+NkxiMCFw/uCMCyuGd/bb/Tr/8iAsQ7POHiIqsd/K50Iy5M9gFumGnLaXDa98BhttdpBJZTlJ0Kxekr5ryTW5RokW1PwuxtdXc3d+iXdTzCsUezKkkDqZAnEQU8s2OMYJ5Z714Zw0RMshyBG8TbkN+9AT6292nYSS5ozBpS/AnIHvwdRg9zUNHR7/+r4CGgHyxM13CPKeAieKBYilfoGVVuT37oUnNP1ZgK0gI/2zoqhsMmLu9kuP/1oCMSlkYfsUDj+egXXWM20ogdSzf3rll3V23NTvgZicJGHIfr+GPozDlqIrdaKeDljYt5T1vEll/1XYI8Rmn4J6rN+zke23QSzeZH1G+T157CL1Sna/piS10R/Vi/6RH4rTvruqMHYaGuymc6DbMYSlkshITq2zPVf5v4qfxfx7U/vn5txSbQ2sFPmiwAJCbevGfy/ARy
 qcGlUn3t
 QMS721/dtndRqEwL+DVVLZ5SRtnEU2Z5jPWpxwHDuPg2heZVKtHgMCmgi4iEC3SQBxFUr/+GWcp2P7jN14pGXYANgbOCrM9lM4tMm++VbKugvFDZ59X9XFjDkBKTnZFKWqYwBeFe18cJnnVCscplpskQwws7os7gu1+izlLUJi4tVhM7yQdYAfgfsLQqndWP8jWlJZyyAk3wRPDIfhLRjywydmH3xrmGyLF048nwge+5Fv03hCS98Nxw6MMu8O+jO4i+o6EtGdLDMkZjELOYaPdy+bCKfHNXpMhAYTdjiusAmNujCW678LFQ1laO727md1Opx0UWRaI9w146zU6SUz69mFFtgUXOc+sgIXq9nuuOw85w5oxFOtm17zogqDLnBOBoH1ZXAr3m6Zlgv9Y5ch3/v6t15M3tXMcEgDIysW7RBktwtIsr3DZgsGi8pL9HXTS62nxI7RgSspaqMpvdbXPDRB3V3Hm8QighCBmbD1HP9AcwFoWCAe6EPh88Gxl5Y2Erav77fhygGk1kYEO2oqBh4MoKpNlYaXuu4/9sQ8DDOW8ZUQfXjAwcdogRJZGgXU0a2YQFkK3diZtYTJ+vg6G5hdHv05bwpMLK2BNl93C3WkPnYpmVufNXWVNA2+fJyGxtIQd805qczeqxlO6xfTY27pOv+KpOMgpr+InYGm1tspoQvO6SfgyFv5XcjcK0yzFydNzW5XEaYXvkliJIGfrgFhH66oQY19eM0jAzuG3wOrR5+GhVv7crOPaXMQtipI/GtOZJrldQ4VGdpG8f7zPz4kR+ogQ6+T98aHgrar1gZWhFSixtGEI10lm9D/KbiANSowl83jlXgl8CE/NHrFV6BG7E/hWicjWUCBK+z6lzckmBgvHWOyOclhRDZ8rOYFF54Sa05DZCKCV8MpuCl+Qi6ZZIJZHPgqTFR14aaOiyR6K+6OrF+M5rC5w7Q5hGVw5B702tUWAk0u/GI+Lpy3w0w77vx
 tCbfraym
 aP0lADis0torCFDp2PH72h4iPqKd7i05EkCswyuwpJTy6C2Zb6MQQPCF1+8Ms7xbSUziVcb8bLg5G0hIhQISRx5MJHNylWj5AqZ4MFJXPgZksqtlJ/MVETHyTdLTfO/YyvsIILkQvxq/2CTn/CcNJjhK2s5IG+4B1Xxxi/tx17hJiEBOXVhgIPamABKxiNXLlrfbDEBWSeFA3RkU2ZBJQKgmKdB1g2yx2vfOFlokCsR9hR452GYGA58M9cOCgV8WFNq1hraT8sCU8EdOJGvwg/h3exhdvTWF6wbKAFbTizXHfSJHLuWewHrhoeMPTIRu
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

Since pidfds can cross pid namespace boundaries, the first patch
restricts the existing namespace ioctls to targets visible in the
caller's active pid namespace, failing with -EREMOTE like
PIDFD_GET_INFO.  The second patch factors out helpers for acquiring
referenced task paths and reuses them in procfs and AppArmor.  The
third patch introduces scoped cleanup for privileged pidfd task
access, carries the visibility check into the shared task acquisition
helper, and separates namespace lookup from namespace fd creation.
The final patch uses these pieces to implement the three new ioctls.

---
Changes in v3:
- Restrict the pidfd task access ioctls to targets visible in the
  caller's pid namespace, failing with -EREMOTE consistent with
  PIDFD_GET_INFO, following review feedback from Jann Horn and
  Christian Brauner.
- Document that get_task_exe_path() leaves the output path unchanged
  on failure, as suggested by Jann Horn.
- Link to v2: https://patch.msgid.link/20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn

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
To: Jann Horn <jannh@google.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: apparmor@lists.ubuntu.com
Cc: linux-security-module@vger.kernel.org
Cc: linux-api@vger.kernel.org

---
Chen Linxuan (4):
      pidfd: restrict task access ioctls to the caller's pid namespace
      fs: Introduce task path helpers
      pidfd: Use scoped cleanup for task access
      pidfd: Add task path ioctls

 fs/fs_struct.c             |  44 +++++++++++++
 fs/pidfs.c                 | 158 +++++++++++++++++++++++++++++++++------------
 fs/proc/base.c             |  34 +---------
 include/linux/fs_struct.h  |   3 +
 include/linux/mm.h         |   1 +
 include/uapi/linux/pidfd.h |   7 ++
 kernel/fork.c              |  22 +++++++
 security/apparmor/task.c   |  12 +---
 8 files changed, 198 insertions(+), 83 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260819-pidfd-get-paths-59640d8cd1ee

Best regards,
--  
Chen Linxuan <me@black-desk.cn>



