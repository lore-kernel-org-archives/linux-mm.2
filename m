Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD25606D834
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jD7YYdyS
Received: by kanga.kvack.org (Postfix)
	id A46996B05B2; Fri,  6 Nov 2026 02:12:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F99C6B05B5; Fri,  6 Nov 2026 02:12:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BE836B05BB; Fri,  6 Nov 2026 02:12:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8A46B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:12:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B906FA0CC5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:12:51 +0000 (UTC)
X-FDA: 85403826942.29.F531B8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9D716100005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:12:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jD7YYdyS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949169;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G5GTnL0QSwgRvtZJewk41VvHRXskbxubvuaGSLU0AXY=;
	b=6giJEx4H9PFfng5pTAiR5gvIUFXepjrgAwWHvBbBtTUfeUoquET6xWrLmLVX/fOC1tVFF1
	Y407JCaObuW5ydY5U6VnoCXM+BaTpDNJhCzx7g+OR0fkMftvM8ZXB26E0DhWcqS35as9Ta
	SEY9W5/HcAygIH6zbziPkcR1y7rCntM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jD7YYdyS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793949169;
	b=PkmnZcDAe2TrUKxyRX2ZGh5ujtrglBOVn38pJMd/tZkGRnXu2NiLXOsAqmIZrwHToezrW3
	jMucBkHpYGqflSS51iMxGErTdVubOCXVKYMAoVivXN6PddQjmx605g2pOYGZBUTA2emMTX
	3bLGZ4jTvta4uQIVlqn4nbBcZNb0nHQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E5D1601D5;
	Fri,  6 Nov 2026 07:12:48 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793949168;
	b=LDAJYbAs/gVZ6ToizZ9Bll8Fj1klc9XUSwaxU93v5Raq9s06mIDs68/7emViQ0nKSboG
	 wqyUyjUHE2US/4l1scWZJ0EUzvF94eL5LHm+OF1YTh/FtF5M++BXjceDwF8zhO9WNnEqw
	 LCDjk3jvr7v6TL7sR0QNGM6PxDnicuKPVxnNcXAnXJ8h8roWdiYZytUcNhUGQZw1svM6P
	 lt3d4iW+p7PgFBT0j316UoagCAfuIIY8yz3BJnWZKJLI4XKRzms6WKzVc6Uk0r8Ila9i8
	 5UzIjMjN0H++vOuQmV+6hrfWURLp+06t+5WaR8Rzdj20aUpdz+isugbyQv8ZOur2K5Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793949168;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=G5GTnL0QSwgRvtZJewk41VvHRXskbxubvuaGSLU0AXY=;
	b=FD5GKt5LuXGBb9/YpaEAcIDGEGg6b6SCz4+g6/+p04bWYIHdOwXPsa73rx9wq3JXu0/K
	 g/H7GSjUoCIZxNq9qg0IxId6jwGeQ1m3U0Fh0zz69rIqyLhWI5utgaSfcl1uoCltwehjd
	 XMGZP0PBCs/MBZwf42yqLD9ewho9QUmrCiH/S0Q5i5lOkn5bQDzobY0hfbIyO2lS85hq0
	 5J+9pG1NXX9vMpQz4X8QYC0A+NypTA0V3qbDDOHC8/7zZcKPAI5in+QHBoYyxSdEtVlN9
	 a5wwGYUBr6nRQlprhFbRH8LgT78Q5YXawKogP3+w4azKv1Kw8hrTWJb5mRBseqmttUA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1D3341F008A1;
	Fri,  6 Nov 2026 07:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793949168;
	bh=G5GTnL0QSwgRvtZJewk41VvHRXskbxubvuaGSLU0AXY=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=jD7YYdySMsTYm/P0V/VkUDXbq0fOBZOqVZGaSAUc4qhCEFrrjvCpn5Qtkx0gDN+l8
	 7765ox+qspA/ywXW1OmqNkBCJkMmQPfNNibgwsIEGfLEDIY3iATq8fh7Hl7Yq3b848
	 138UKedaEmIIho5YN4OHQgxSbLnqksFdGqS5D/YAcJ4fhAJ0NSCrmDqahC9OwPZW10
	 DlXIZAT8cy1Ki3LcUzzJWpw6jZyECaHfS1P3QnW1SFZNk6n5JatQM/jQREF//1iGsp
	 RkMF6OubF8AMD3xfMfPwzYqfxrrwWMSn8c/RPgAq2Dr+mM+I/vBwkdo5oanXEYial/
	 RonS9FdbK+/BQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6913B45C33;
	Fri,  6 Nov 2026 07:12:46 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Subject: [PATCH v5 0/3] pidfd: Add task path ioctls
Date: Fri, 06 Nov 2026 15:12:20 +0800
Message-Id: <20261106-pidfd-get-paths-v5-0-3147ce6571cb@black-desk.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23R207DMAwG4Fepck1QjuvhivdAu3AcdwtjbWmyC
 jT13Uk7NE10l5acz87vK4s0BoqsKa5spCnE0He5sC8FwyN0B+LB55opoXaikjUfgm89P1DiA6R
 j5LbeGeEr9JKI5VfDSG34XsX3/a2OF/dBmBZm6TiGmPrxZx05yaXvT1dio0+SCw6oicgIob19c
 5+AJ+4pnl6xY8uEST0YWm4NlQ20NcEOlHSlembouyGFfLKHzkarjDVGOOW0eGaYB0OVW8Nkg1T
 ewpSksd78Zb7FNdLXJd8h3TJkDiJx7M/nkJrCS23BGauhzHmANrUWznuQ1BrnsQJsASuxXuJ+v
 6b4t1OCeMqpIsXIXVmXhC5nB6bJ59jP8y90/dO+FQIAAA==
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
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4196; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=wgKnE8AT6zpqmdbQXKjfkpLb58iWgrFhxz3SEzzfreA=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBq7X3o6Ky5NtuZHI7eJbXQEVN+9Nq8XbqFkVBdO
 8jaSwhvpUSJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCau196AAKCRB2HuYUOZmu
 i09oD/9d2F1RAOVF0ehGGa3AE4njnpiPsiT80fknzuhT1hJ7a67xlavnz4/+JAWndScNFA9E/48
 tx6ItTLkqhPIWwmjIvmQVrNG5+JBVoX0E7KwAU+/I38w3r4r3Kv8kUrxsAtjRXSKvKY1MZeg0E1
 GI7FUxgc8VX2zrmfJqR4CfT0IyEPp4FRJ39rxM5whQFfVsMx7Nt5kgfvVG0wK6D9s7kfzfuICPw
 odaxYeCSLDor6nuvxEoonHOw6LCsWaOezdl9vtHcchQj/BYbp8Uv0XWj7lbzdTNmTwWG4oxxzV/
 BuXIHcgkznW+xvBlEKt7RvsmURt6Vv5iE1wh5l7dDZZw8gLKzGkq6QeKnvdhCyoXKNkGIj2KIgo
 l/GkyZD4ysSXUl47gVsSye6noyB2H5u+OTojO1COV+0YvsH4Je3eplF6BazgbcaqlS9CziVgRRw
 vUd3RfL4ptcVxwKg1nhBebybrE3EkgHlfg9q0nP2UnefKX2WB/nk6cChGivjOHge4fuppyLrB4u
 xrWdja/usdKvVQ6y1Ot3INkX5s6Md7A4znqNZEFM7gHv5eHP/Yc/xGanTUFS/X5rHztkGPwva6s
 Gp2qWU/r09zcUxpOZqYTHJa+5smlNTQUey5kqx5F4LpNpoXgm6ZShEKkuDqDKE2czYXDHmcnq82
 DZJFI4vAMkaG1KA==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D716100005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ezarb4ygh6a34bofhed9cp5abkxxi7ub
X-HE-Tag: 1793949169-898348
X-HE-Meta: U2FsdGVkX195msvECTvcIolBclqB1Bn0d5YFBmYLCdw3Qh43Gf+vMM0Xrak9PQMCnQsCEK8TTWMtYhR43IdszdAXKjO6VJRuKV9raEzR1Kec74n/cYdiisKizuIF8D7rOmeG+IQbyZbhvN2tDGOE4eduG/DBo65Is3ZfNX5ojeQsnoV/JEompWayWJtKlrV8kNRantDajA9UDkdY8cR52EpdL0dyfvFg1EmUW/1aC0DeQOOvvKfCxZn5Ax22WhU8BJ1AuYbNTNadnEE/2THWxtljAQjqiF2nTvpSfDZUThX5IzmzbFA7Lr6q+3xriFBCBm4zWDA4HmOwAV9oiS88f65kJ/9+VfNYQwXbxxAHLcMaP7YtC6Pa71uJ5z64GQ7rIYn05OP3lSHQYVrAsQwNLJ4ieAD3jjqOaLSlYe+BJbgflxVHUQqADtys2N8yu2yUqLEmRWlQy5LpsIn8WuAWSwzNh+lUPRCyVd5mq+tDT9P3SUaEJDzde0Xb1LrYmd6tNTYY7JZkHI4xSU8evo4Qb7ljCGEPlE4Qp2g3aiZbPnmVv86Etd7DFbuipg3S0yw1H5HJAHIKDWCY/yKD8dIwAYuhtNpKifbyzX2/+FN3iu34+g1cEzuM9ff4HUpiB0ggmSLzOpTyVvZaXezXWXkdQJX/9TfvH05Sl4RUCmimGXaEk20byvuwkEhEiMbkgY8EWUOKD8RAb856l7PmOiCVij5ZBov9RyUNaqNjxSAXmGZOrX+QbC64m+NBu6IGzX8kyqevwOfuQhj3c4FAiZv2YrfFaLIWv4/8yjXUwMIotGXluJdDskmWEUfL+BjIIfVbFvYhPmtGgRtL1mStrHLaAPogIKgheeuxRd7Sek98GDR1QHVulFQ7EEbW6XnfuaA06r0HG+lQ2H2opBIel19niiAPq4/gFdiVrX16THcf4MSi5eE8LxcxXwhSc1l4pbH4yGxbXAUhsH6lweZRaqV
 EB3hw0A2
 Ixb7TQY6Im2likqOIwBw7Gaw66dfARUhtbIqmtb99u0fZrHQER2PgdXqAeBnSyEia7XYPHv3GiiVpT9HW380xNdEY7wrx9KZ/XaUvMmquXSw7gHsgP/cl+mM6Sltrse3M2gahap27g3Bc9z1M0RNw1REHoIlihhVoR0PpYriXEetEnVmG62aPk5OvOV/JXaSMaGEjuuqMAtT/9sTH/B8AEz3odm6D/y3/LkbFdG47KhWK6++ZBXiNOjpAzBLZc8jmpkv/zChsnU2IN1ZB6//Drb/iDp3IJiLIHub6D0xLIFzLUP28uWoClqfQINqdyfTgU7cXopyj0NODtFV8jCDfjnQyNIZI5IgZNgP0w0LX+PW4ZXS1Gy60kbvAvjlmiga01havxCwF3in+6kgCWfsuQw40tYi+JhA4vzE/dmii4RDpR/H1J9jfX1/QDvck8gPIZWiUDYYPLF1YUkraJdWE8KD8/8/flAJbX5nr8vt+OxChRbx6YADAYOv2zmz4eQ0TquVYd2MX4u7nTcBu6qMAdt3upG6vTACmnobdFNPL6hb2Xdws5NvX7wlhriIbajdgW2KPjrjgxQLTYLTW1lxWjrQWU/yQu+tazFbjtRQNIfW6yzVwtg3SJyFO2kJFpDlJnT1IwarVLgdwI5LkXgCTGX0EfFKlGtuFTa16TIo/C4+aydqRv8pc3SWQNaxBH+SKHFksv6HsXO0CZuxf0TyMKlcSA0H9mg9lqzi+6GZFy3VlKCIeOJXS3kXc9NyOh6l9dYYP4L2jbbVrnCAMAzz4fEdajdVf4RvdIUtXDF/2QSlrMVJocpCl22K8YTA+TOw1w7thorGV4wNK8bqLEs2sOZvmZPe2J8isTru0pVTXZa6ouM/hOQirx0sG1NewKcmJhTkXUk/BuDAcxy/aqWPY7p62FQkf/yN8KOBMzu3SXUGD3ghHfgAMncJn/KqPnivFO7SO6/7NQcA/cN89K9TzM6K76VnJ
 t75gnS/k
 P428vivXRtFHQUGK4iuzhxLGGnax0hM1d4/SzH0ooJvbd9Cp/QTcPRpUqCXzS9LtxZsBilEePeV+EtSlkRJ2yC45ER6d3xNNcK1taw55Jy4ljK7kSc/VgRT/As4Xyb0TDhILCAJWYStrgqUNJHtx+sRlcVfYu5vzXsI0Oom3VKftKg3RjC5BIFlCXuelAf46J9Xu56QuvW95dB0yqJjsWhFBCPFa9S/QNBeafKIKPqM8lYe7QzTJhVP8Y37lSWPsRg84Ldjp6116LAUJib4FGFjdVQaoLcZmCdixQskxBAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Obtaining a target task's executable, working directory or root
currently requires following /proc/<pid>/{exe,cwd,root}. Add
PIDFD_GET_EXE, PIDFD_GET_CWD and PIDFD_GET_ROOT so callers holding a
pidfd can obtain these paths without requiring procfs to be mounted or
visible.

Each ioctl takes a zero argument and returns an O_PATH file descriptor
with FD_CLOEXEC set. Targets must be visible in the caller's active pid
namespace. Reuse the procfs path getters and hold exec_update_lock
across PTRACE_MODE_READ_FSCREDS authorization and path acquisition.

Following Christian Brauner's review, use a dedicated task_path_open()
helper after releasing exec_update_lock. It calls ->d_weak_revalidate()
with flags zero when the filesystem provides it, propagates a negative
error, maps a zero result to ESTALE, and otherwise opens the path with
O_PATH. This gives filesystems such as failfs the opportunity to refuse
an O_PATH descriptor without starting a pathname lookup.

The first patch factors out the task path getters. The second prepares
scoped task access for the pidfd ioctls. The third adds the three ioctls
and task_path_open().

This series depends on the separately submitted pid-namespace visibility
restriction:
  https://lore.kernel.org/all/20261027-pidfd-task-access-v1-1-d46cf0fa4ca1@black-desk.cn/

Tested with virtme-ng.

Sashiko AI review reported the missing weak revalidation in v4.
This entire patch series was generated with LLM assistance. I defined
the requirements, guided the implementation, reviewed the changes, and
made the design decisions.

---
Changes in v5:
- Add task_path_open() as suggested by Christian Brauner, replacing the
  direct dentry_open() call from v4. Revalidate with flags zero outside
  exec_update_lock and return filesystem errors without lookup retries.
- Link to v4:
  https://lore.kernel.org/all/20261027-pidfd-get-paths-v4-0-e2a6a47e3c95@black-desk.cn/

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
 fs/internal.h              |   1 +
 fs/open.c                  |  30 +++++++++
 fs/pidfs.c                 | 157 ++++++++++++++++++++++++++++++++-------------
 fs/proc/base.c             |  34 +---------
 include/linux/fs_struct.h  |   3 +
 include/linux/mm.h         |   1 +
 include/uapi/linux/pidfd.h |   7 ++
 kernel/fork.c              |  22 +++++++
 security/apparmor/task.c   |  12 +---
 10 files changed, 224 insertions(+), 87 deletions(-)
---
base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
change-id: 20260819-pidfd-get-paths-59640d8cd1ee
prerequisite-change-id: 20261027-pidfd-task-access-b797ecb260a4:v1
prerequisite-patch-id: 021f6b0840ced7fe967a849b99c366257160c005

Best regards,
--  
Chen Linxuan <me@black-desk.cn>



