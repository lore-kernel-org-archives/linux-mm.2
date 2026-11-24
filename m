Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87451606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 22:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fx6VAKSQ
Received: by kanga.kvack.org (Postfix)
	id 67C586B0878; Tue, 24 Nov 2026 17:59:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DEB76B0879; Tue, 24 Nov 2026 17:59:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6406B087A; Tue, 24 Nov 2026 17:59:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16A9B6B0878
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:59:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82072160C72
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:59:33 +0000 (UTC)
X-FDA: 85471531026.21.E9E39B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id AF4C440006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:59:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fx6VAKSQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561171;
	b=P5UzxeH8Zj2+NSNU0WnjNtLX/t1CIJVoXPnGgw/vKBNmq7rcgkzIrS/0gxuoS5ZMqnSbgk
	kQi3m3tuqD/ycexCPiWOFegzx4OC8lhl7nPjg26hWoTBniOcncTmRJOvc80V6Z6+FfiIgv
	4Pv5X+T9nMnJjR0pOgfZIjflxzwhW2Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rmQ2mWQe1HLwl5h32XWTPmN+b/bN2UGjG7wxAGIsjRg=;
	b=lnbW8X9E8NIfnlh7uaEoM3zPvaVh0socjV2LUtK5SxoOgx61hTtVmnItdJYwkyz/c6w4Z9
	f2gNGr0ps4lHf+UAnKoWBBOUxhKCEdGEl70bElcZrP7lkkQ8m9Qr9qqit53vN0i1T1BAWL
	kCHaPz8TGI4+TEJeuPdId+PrviQQcSU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fx6VAKSQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D05861CCA;
	Tue, 24 Nov 2026 22:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEF01F000C0;
	Tue, 24 Nov 2026 22:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561170;
	bh=rmQ2mWQe1HLwl5h32XWTPmN+b/bN2UGjG7wxAGIsjRg=;
	h=From:Subject:Date:To:Cc;
	b=Fx6VAKSQToO9Z1hdram1YUO1lEL5Vt1A4K83I+U5OyaiTgBQfNTEQxUXsyJ1IQxgb
	 IHT6YjJaea2BovBd5acGXlTUQQ88026Z7JTWJutZbpMdWKSogu0RT/hkkScA6kVoST
	 pbnUMIe93GcaSsv9oGFgEDwvPwdJPJ/+KU1mOJGE/SgQCjMJFP8sC+TgqwMgM5DSR1
	 tdmU77sDqmOfYcUfn8MJr03VXNILpuzNXB60i30QWHBikWocqq36zaeVcag741ONXD
	 cm9I9GJyDeMz8vFUV6FnN4fRRA/uDEUJ6ibotoWcsRjrxbxQC0fRL6erYnbH9jHGz1
	 Yk93YFfq3nxBw==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC 00/19] exec: move sleeping work out of exec_update_lock
Date: Tue, 24 Nov 2026 23:58:23 +0100
Message-Id: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/03MzQrCMBAE4Fcpe3ZDEoqKV8EH8Coi+dnaWGlK0
 mqh9N3N6sXjDDPfAplSoAyHaoFEr5BD7EtQmwpca/o7YfAlg5Z6q5SW+I6pQ5rJ4TR4M9LtGV2
 Hu6a25GRt/V5B+Q6JmjB/3QucT0e4/so82Qe5kUWeWZMJbTK9a7liW7At/mzBI1jXD6SXPUOrA
 AAA
X-Change-ID: 20261120-work-exec-update_lock-7f4bec04bd81
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=5297; i=brauner@kernel.org;
 h=from:subject:message-id; bh=iICEnBMyaYbDfJP4wFkUJlvvreRE2YBrucPLrqy5+d4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSziW3dMkEwIPUaF2OUU+SUnyK7/xpU2F6fv9C7YM0VF
 a3Hb/+wdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE4gsjw4rwP3OWSQvXC4qV
 38qqd9RquDKj/eVhNo6onCmJJVO71zMyzI0te2gQqm3dH74xld1aVE1pzS+r+h87GQT9HObxmPS
 yAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: AF4C440006
X-Stat-Signature: oq4pn33ddzmgc8tq7onbnamk4a8ecwh3
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795561171-807846
X-HE-Meta: U2FsdGVkX19Bjd31CuZWvHdk8Op83Z4PIpOrzkfsAF1cooXKYcm2qw4MAm5soOh4nclJ02+NSdHkcZ5RaE51Ehs94lGoTTCXENNGXNJu9K8QAUA10xaAEz/wgGSlWQiA1OwO4v3iqEmTCcoDmyQ6zE8+YnF7L4/7Fg+ZdEsh3m5WJCzfVQll2HXuUlZsV4yY9d4Mr0+g+hicmhssegV2VSxqmweu9sEQi/Qlhoyox2fYLaU7ktFlj1EzlAzd3/JtMQtmHI0ttYHJB0gq+ZltEyb5ORA5qzAj7s27vSv0H+DYFXZrYTKam54+t44kv9uXpwYYqj6TMni5T8EG1i5YSyeyZyqYGwoVgdMn9kvofZqyTwkAelC+19mLLSEtEnqXer7HGdF+UEWamtRb5IKvhnx7ziJ/jtSpc8PL52/0Wo2q8yUsKdyjvJoCpdK/x0Di9SL4ixzSFHVdt7vb4BKNMxcIvnFWk4kZLW5qCLyq8wEM7CPJMX2SQ8+TUrh3UsjAZSuvt+qkHwOrLIcnqRgAz3H5agjVYRVOIc96EjF/Fy7gNV/mnPm8nmZlL/k9T9+SWj8rf96zxCL1XC9wdwVQlIESabt0ns3lAc2AwRdyx4GYnsWj3Ca3hvENntpx1cJIMdiPeEXeI5GoaQj3J4u3Ll3lVpraX6SfgZps6gNkitPBWvMfR7K71YUrRflLlePY3BgE102DzXU8pOf3i6kasCUqscJiSmNbLrF9h4pq94TTvijjfxUVdw17MfRxXvU6emvumnFX7oqt3N8pM51hTImurDlikJIglpCgwUSRoZ3fBHznI2pl6tIJn+3qHGdv2Nd228Oq0euJgHsnuEp5LIqY6o7mac8zcJkBck2gH64MFb+Gpbn3vzrJqBRTOw0YSakyDWc8Pn8FlvKG+FmLR0abHG/eqoviyPLGXqVzVZVlWr+1a8eCSMQDB01TuHgORLMNxtvSzslEHn6ZmWS
 jb6sY/Ab
 RKG9cdst1lM4tsxYYDP3B/3cfY2Pe5hkd8R5dTmSDcKAe+cB6+CgcOk33QRtcGho0u3USdbGvkvMnXS5RewOjw+hwwz17xz8Ic6zRinOIkZW6XVaElMojeSJkJl3eAe3svdAaHFHi1/liQSI88qz690Czj0jmV//TANe2PnXeRn0MHOzbdPiz2vdn+tJ9sxZvab+9KylDrTebwL7PXwqfxvMz/gShoPtMugfHZj/QLQxudzECISE46DWJs//h2H+33mss9Vv08b+PJtbMlLJ0STAFBcnTuk09nofQv50c6YGd8vzC1s0YaoPP9rnIprwLI0tPhfXyPhN7k1JPYVrbBiUCLvZzZJIQWsh2EIl6xd9yH6yHubzneFITQAc1GMOvcp6DbdoeU0cRSEQcgqBVdWnGqyAmBfpfFfIJlLjn6E2/kvxv9wKnCDBW/tSeONaL+7e5rPt4d5G8FnyLP6n9r35DgoZC2k+vIuXM1U9WL79+8JmoCN0idyEofyGY6AdrqjyEZ82rVAe3hPUaNKvYbjQe0EFqFsblQ2X/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I've been massaging exec quite a bit to move a bunch of stuff around
and get rid of a lot of sleeping work out of that path or at least move
it out from precious locks that are used for access checks.

This is another round I plan to upstream. The gist is that we're relying
on exec_update_lock in a bunch more places now and we've been
willy-nilly moving stuff beneath that lock for a while. That's not
sustainable. We need to clean that up and really only do the absolute
minimum of work under that lock to avoid stalling tasks indefinitely
just because stalls an exec. It's also just good hygiene because it's
getting really hard to understand what that lock really protects.

I've spent some time playing with various patches. Some of them went out
independently. This is another core chunk:

* proc_ns_readlink() copies the link to userspace with the lock held.

* kcmp(KCMP_EPOLL_TFD) copies the epoll slot from userspace with the
  lock of both tasks held and then waits for the epoll mutex which
  epoll_wait() holds across a page fault.

* perf_read() and perf_ioctl() copy to and from userspace with the mutex
  of the perf context held. perf_event_exec() takes that mutex with
  exec_update_lock held.

* SELinux ignores a failing replace_fd() when it revokes inherited files
  during exec.

* A vfork() parent is woken up in exec_mmap() but a child that shares
  its signal table with the parent only gets a private one after that.

* SELinux and AppArmor revalidate the inherited files from the
  bprm_committing_creds hook, i.e., with the lock held.

* Move the time namespace switch out of the lock. It doesn't need it.

* Drop the lock right after the new credentials are committed instead of
  in setup_new_exec().

* Don't take the mmap lock of the old mm in exec_mmap().

* Look up the vma for a link in /proc/<pid>/map_files without
  exec_update_lock held.

While at it, don't take the mmap lock in exit_mm() either. It's the same
leftover. A vfork() child that exits without having exec'ed waits on the
mmap lock of the parent it has just woken up.

* A vfork() parent is woken up before the child has left the mm, in exec
  as well as in exit.

What's left under the lock that can block is the hardware breakpoint
flush in flush_thread(), perf_event_exec(), perf_event_exit_task(), the
allocation in set_cred_ucounts() and a sleepable bpf lsm program on the
bprm_committing_creds hook.

The perf ones still take the mutex of the perf context but perf_read()
and perf_ioctl() don't sleep in a page fault with it held anymore.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (19):
      proc: copy namespace link after dropping exec_update_lock
      kcmp: look up epoll target without exec_update_lock held
      perf: copy counter values after dropping ctx->mutex
      perf: copy ioctl arguments without ctx->mutex held
      selinux: close inherited files that can't be replaced
      exec: move unshare_sighand() before exec_mmap()
      selftests/exec: test exec with a task sleeping in a page fault
      selftests/exec: test exec with a shared signal table
      lsm: add security_bprm_revalidate_files()
      bpf: mark bprm_revalidate_files as sleepable
      selinux: revalidate inherited files before taking exec_update_lock
      apparmor: revalidate inherited files before taking exec_update_lock
      exec: drop exec_update_lock after the credentials are committed
      exec: switch time namespace after dropping exec_update_lock
      exec: don't take the mmap lock of the old mm
      exit: don't take the mmap lock in exit_mm()
      proc: look up map_files vma without exec_update_lock held
      vfork: wake up the parent once the child has left the mm
      selftests/exec: test when a vfork() parent is woken up

 fs/exec.c                                        |  81 ++--
 fs/proc/base.c                                   |  68 ++-
 fs/proc/namespaces.c                             |   7 +-
 include/linux/lsm_hook_defs.h                    |   1 +
 include/linux/sched/mm.h                         |   4 +-
 include/linux/security.h                         |   5 +
 kernel/bpf/bpf_lsm.c                             |   1 +
 kernel/events/core.c                             | 138 +++---
 kernel/exit.c                                    |  10 +-
 kernel/fork.c                                    |  24 +-
 kernel/kcmp.c                                    |  72 ++-
 security/apparmor/lsm.c                          |  23 +-
 security/security.c                              |  27 +-
 security/selinux/hooks.c                         |  22 +-
 tools/testing/selftests/exec/.gitignore          |   3 +
 tools/testing/selftests/exec/Makefile            |   6 +
 tools/testing/selftests/exec/config              |   3 +
 tools/testing/selftests/exec/unshare-sighand.c   | 236 ++++++++++
 tools/testing/selftests/exec/update-lock-fault.c | 547 +++++++++++++++++++++++
 tools/testing/selftests/exec/vfork-mm.c          | 363 +++++++++++++++
 20 files changed, 1480 insertions(+), 161 deletions(-)
---
base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4
change-id: 20261120-work-exec-update_lock-7f4bec04bd81


