Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337F9C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 05:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E89046B0092; Thu, 20 Aug 2026 01:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3FF96B0098; Thu, 20 Aug 2026 01:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00C96B0095; Thu, 20 Aug 2026 01:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A109B6B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:45:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 186B7120598
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:45:51 +0000 (UTC)
X-FDA: 85120561302.13.8D8F9CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 29C5540003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:45:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ni5xikoU;
	spf=pass (imf01.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787204749;
	b=W9ya/wtqsdiGUQpcqM7Y5DI+5ojIMVbCSvZyPzpHP0j93MervkMPSo6+i+vJThY1elEfF+
	LYf4/6wQ/5V0455UysgB5b46MXrwabm9IGL+KgBG5RGyMBMWOjVSPawtqe0pQzkCl27eB7
	3buATAf4fKE14Cit2ATch1g0NSE+Vt8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ni5xikoU;
	spf=pass (imf01.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787204749;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eUl4LZVJjVLhyl7++pY7xSC+VLHtVW7lAvnSwTcHtC0=;
	b=mMtEXb+/puYNyB/bskItUvNnJx6irqN3MaJyMMrZPzDrES9YV7XGizNEn2LSI1sF4By83X
	brkv/urjz64yOmBgwskWkukBEIYUPoD1gfKbg4m2tiuZz1wo5ONE1f9SiNmYx6ceGHsmM8
	0iKG/4NxvYa0jVG2hSF2X7rOt19QWp0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3500560A84;
	Thu, 20 Aug 2026 05:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9F29C2BCC7;
	Thu, 20 Aug 2026 05:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787204747;
	bh=UY6R+FfPzasxj/Dnn81Uka4E7YYktrqvv/sImm7YIxQ=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Ni5xikoUjotIWFdXkUzYf3aNbSTk6RPR5KWQfCS0Ensw1jf0eMIokklMQtS3YnMzn
	 lnm7qn+KbKV/JUe+jzt5UKyOqoOQcLfIVCOOAHVRxrd4ZxEjbLGgsX/MxkCs0w3/Jq
	 9ZTYpX0lQB/ZTiFD/siwG7ZkGtabcWa7XMmA6TYu0Gcz95IhLZQRYO75gZESqxjwbE
	 UXY6QDdo26CN9k4AuNQSknZGsCNbM1t+iTI9oWun8Axjf7/00gsYneucEprdaiZd5m
	 54s808wj2kMB7KUDRzIkJKMv6fvBt1wNDTgFTbqHtRUNNppHyT1B4aFIYriNakraoN
	 l+GLuZS0X277g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0756C5DF85;
	Thu, 20 Aug 2026 05:45:47 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Subject: [PATCH RFC 0/3] pidfd: add task path ioctls
Date: Thu, 20 Aug 2026 13:45:38 +0800
Message-Id: <20260820-pidfd-get-paths-v1-0-ac3eee4003d5@black-desk.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIKUhmoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDC0NL3YLMlLQU3fTUEt2CxJKMYl1TSzMTgxSL5BTD1FQloK6CotS0zAq
 widFKQW7OSrEQweLSpKzU5BKQWUq1tQACpIQNeAAAAA==
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
 linux-security-module@vger.kernel.org, Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2014; i=me@black-desk.cn;
 h=from:subject:message-id;
 bh=UY6R+FfPzasxj/Dnn81Uka4E7YYktrqvv/sImm7YIxQ=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBqhpSDV8lzoXhNWvb6mCjlmhmRXIKL96NlDz9RG
 uwcg9YQkTGJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCaoaUgwAKCRB2HuYUOZmu
 i5OnD/9Q2SjkQW1h+c/+qLhCrhq/tFbDRt8y4anyttX5n0ozBKY1ROAd5938lTwWrxvE2on7GH2
 Ed2SCyxk4p/eAUkUx9Pnx8Mt7wF9UxcSrv5gPlJujrDJ0ayEqcfekGWK3ilR+VjLlX52E8W0oE8
 Nsub6HhzxTJF8hA6iudjclMoQAOLRtYKbSxB9eoHfKqNsaPSSKJfWdIYYr66FmgKDTe1hmFnavD
 8m6w4oNr0pVOyIAgF6ETD/xMhFA0L3MrjtjDSDrqZFxxAHK1pPCdLBWXdO0lSRj7zV35KNNaTsd
 Kk3xNNf9ExLiO6+hvF4iqOq+0HNblbojWt/criDINke66q29D20hZcGReta1XAW4uEKYp56XWMi
 dVwZncXvkTusEUl9K1UXY4uRAkWNdOyDBv3zAHqzzAXfzPuUhYvgfZfbnJUl2sMdMiZw+cVJZjS
 uxyELiapFXp/I/yDnsmJ/+jQJcLQPpXhr7U0smvU83Lfcpom3dvOFhVQTgIJrkCHDz0Giv9RgzZ
 A5xGV4k7XSuM/A24/oZhz/ylcYTFJyxcj5gZSA6DYZbfoT7YsFVhABW5DckRCr9hzF2HA1KIDCs
 rx4LYqHEWwi84GPdEcVZMoj9GIA1S+b3UYvC8Q2MQkxF/Rga/hXhznAc679HUyG2vzXOgtHSvqS
 GnM6BZwjacrSeBA==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/default with
 auth_id=573
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 29C5540003
X-Stat-Signature: 3mn9p7713yf8c4skwsprhbkydbfhf9ft
X-HE-Tag: 1787204749-503793
X-HE-Meta: U2FsdGVkX1/iLghlpdChRvQrRDmX7/F+yzdXv6nuIyCECfIG79al3wYpaW5Dbl+T+TYRi5DHxKVKgs/+iESmzzjLFoKlG8lVqZEyGNvweaMqkkuibK6onsQQmRod3EYBirpJh1byvFvpLq5JJVS8cov5ORP3hc9DjmsB4/7Dto/mYCmSQ5IyhionG/8etlNy2UpCareRVPM1b8ES4dQKhqOPp64caNA5r1rAOGgdR8A0WDhc3Ywi3BEsotCDRSZFtp7WX1OA5xmyM3Ql3kp/rshWI14PSmNKAvezx3gZcuc21UqOIzpVLEj4WSnNV1fvwgB0a40I/RlqHhQgUZaR3pewETLy7aX1UWVKj/IlylHdqITYBZGjZHtTfwOP0FEVWrCYkeCKNi/N9162Zj8z4dmc5HNl2Tq9IpUkAYuNdnTPuri9Py7aMQE7BmJGGiFWDBa2Yt9H/RqGZCCDmP5bBxWI0et8ubpy7adbKQYBbH+pW7DDK+bNbT4jRTc7CkR0/pZ6wtyPfYvbL2SyT3DidgQzg3DE+JqAxlnf9/CkqUocWCACiL+41u7iQKZ0xqWTVCuvCW94iP6ZMYLowKaCKbQBPg/TXK7jAbLu82xk1hTUWvieNpLP4Z2b+ZMUGEr3HfAEJgytmHCuMkVYKznUi7tC74ATzgMg5G9dXPFfiattvxexQoePJtvd+FnomBpl2455pT8Hn8MNMIA5qbNSHYDrlULplC5WZ+UKkrWhDpAo2IlBFiDARs7w5uUM+35Yqz5BH0eo6Oy8fvSuDJNmS+mXF+xuG1aOQSREjGPhSEcGSHe6svToclmga/3iJ5QoFTdmXjJvuG9gro/LEt5+Y5HcDTwRpQSXZajQYOKPn2HO6ayFqKkLyqaa1ZHl1u5edaOW/vPYLPRwGi3DiGK6clXRukYgHcgwPmi95ZbzTakST/GDMYT0NLHfQ89IgIeGV3rBoN4upzzPYWyLAxu
 dUWtKQRo
 uRfrWR7ti/h0ez/2O+Z/vx7mIgyLYZkJriOcGyK4RQEwINk9jrdAPRCiEYEpb63mwmiY+QFtK4QwzUg5h+d2ZpPyKyOGc/ml68U3zp0hCM03thNZvC6m43AdlQjG5J3mtX8Rz0B9kzpK+P6KjHZviqpOs8RK3fbsT9WMm0M+rfWNpdphkZmkfY28+BJuP4zr+5qp1jHs3Nto5DaT/aKt5WKAnGG2jAJoKNr28EwlAmG8pGSLErLNQrFAZl1e8dJDPe3B2oNSlQPohpr8W0e3e4JvzoNpzmr8GFj7G/WvkhFqZ98BNAAB1X6S49L16l0pz3JwY4L7l/odTOwEjDqUr4HH/y92c0O26J0w0kvNQ8BP5izXKg1/Su6uEph/uhN9XV0ji
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
Chen Linxuan (3):
      fs: Introduce task path helpers
      pidfd: Use scoped cleanup for task access
      pidfd: Add task path ioctls

 fs/fs_struct.c             |  44 +++++++++++++
 fs/pidfs.c                 | 161 ++++++++++++++++++++++++++++++++-------------
 fs/proc/base.c             |  34 +---------
 include/linux/fs_struct.h  |   3 +
 include/linux/mm.h         |   1 +
 include/uapi/linux/pidfd.h |   7 ++
 kernel/fork.c              |  21 ++++++
 security/apparmor/task.c   |  12 +---
 8 files changed, 196 insertions(+), 87 deletions(-)
---
base-commit: a4ff2be345d0abc943da8dd8da98151843b750dc
change-id: 20260819-pidfd-get-paths-59640d8cd1ee

Best regards,
--  
Chen Linxuan <me@black-desk.cn>



