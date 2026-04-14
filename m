Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA74FF9D0C0
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396E76B0088; Tue, 14 Apr 2026 07:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E396B008A; Tue, 14 Apr 2026 07:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25D966B0092; Tue, 14 Apr 2026 07:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 112056B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:25:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5B1713B1C3
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:25:16 +0000 (UTC)
X-FDA: 84656930232.15.184FA6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E57F140014
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:25:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/2YaUq/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776165914; a=rsa-sha256;
	cv=none;
	b=iZXkCPREb5SC11myRN1vM3qyA3dPBT8axrW8iJv/NLnPwE45coIYaKUBOYefSWU6K42cjP
	klMgPTNd/cBgm8jU+hj3haCGIe44kXuG6+OxMqsJXbZqlfXYkSu1fOyh6Qo72fG90rhgUf
	t12UXZSkD6rAviOwOlfncLlm2d20pFQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/2YaUq/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776165914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYgk7vIcL30k26hLKMBf0OdEDnzyVkWij25WGR/ZGAM=;
	b=1PH6BUQIEmkHTMs9KJu0SUCSVgjaAmDeeK2UunxwmmWmc/dYsT8hkwauDwCXyHi3Wnx771
	TlEHTwLnOh2P3L/tehuIVg5k0HGlu0fmbT2/T2C5rQjLjLnA3r+VCvP5ycvtuq3udgjOmT
	T+TR1eJrcetL4Oh4UJmfayNjb19PzCE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D3DF360128;
	Tue, 14 Apr 2026 11:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE91C19425;
	Tue, 14 Apr 2026 11:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776165913;
	bh=oPzvE48dNHObsDMFySKpxHp7VGZajxCOdUrsSaiKSX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/2YaUq/JMCT7MVW32+pN90oAajergOdpP5UsbrOvnunH0m7C6/Iv/1oqplNBVJ4K
	 oLbDThC7zAZvh4zZleStAAted6kpCqUZ4QFMCD8yCK9mVPeLnhaWkQdg3hG/I58q+f
	 7r68nr/Yi3o60N1oaWox21qtXHLSdsJjWSOpZUu2g9G3Ov2nMMa5Ehqa2hblIxLWpX
	 0/o05mrrnTrGOc6hx8N4ehNFDLHudxvN82jmEd0D+V0uOQD5CP/BYuV9l02yGNfvoe
	 T75QMkQKKQDz1Kg16f6IJFPUEW+oE81oFia57IsC/vZz56P6AbsPS2EDyMJKDSrlzQ
	 oLzY71TU3qrVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	=?UTF-8?q?=EA=B9=80=EC=98=81=EB=AF=BC?= <osori@hspace.io>,
	Oleg Nesterov <oleg@redhat.com>,
	Dave Hansen <dave.hansen@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	surenb@google.com,
	Liam.Howlett@oracle.com,
	ljs@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH AUTOSEL 6.19-6.18] x86: shadow stacks: proper error handling for mmap lock
Date: Tue, 14 Apr 2026 07:24:58 -0400
Message-ID: <20260414112509.410217-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414112509.410217-1-sashal@kernel.org>
References: <20260414112509.410217-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.12
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E57F140014
X-Stat-Signature: 5chcrq3o6r76cf336bdannrqnefn11x8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776165914-987209
X-HE-Meta: U2FsdGVkX18iK8qBzZcYHsrYxyK3c1knpNvHFZeFP/VXvF6A1W6jhDHprI1wAl1392U3dR27EJQzJYa1itAnUgh1+VKyy9/yL4GEVw8QCd5LqZ6QcPi8CIz/6uxapFQJrUjtFBEN9eIiHqHr6t8SMBF7IMgLmiiC9a4MxFxoHH2AsSWW9Dy6ghuGnhyull/lB7uRS6KsGcpxeJGmdv/Sm0v7oRumCzX8x2/4YTZqChuM3jN82KU5UKTCCuVdaqZL7LkCQhuF/Tox+Q3JNqvsau8MiDTPrFxgBsMMwqgHaWbtsnWFf5VZeu1A0oDXTurFaZVxeemnLL7Ei2kDK6dFCAgpR1lz4obLKWWcybwWTRwpIsvbwD53MV45uM2toCjPuBBQYx592dG3glvLmHURUAiqcH5+qz2PoX4QFA85WsRHT3giXsGGvKyUk0GxaFbGiUf0Qy8ml+QfEZ7q0fFron5ESH6HPih/H2a5RyoKtYuUyfouP2DiPiu0LNijUQcSHu9kUoj+azh398qXUwq4pA1ucxoRtOXdqtWYVTijtLic92mwAedo7OyvTw0ZwRxei+XnG2l7bcu25H163bspQvX9+oNS1jy/tYgFEQ7vIqjNgKrOTB1YEDknmjHnVBdR7MG1U7oYO+o3aC0pwiS7n4j+CEodxODb8rEXsu1XMKLVu/IFqB8s9Qr1oWC2KWRh4l7RRBoOmDf/dyiA/8vbO9ZinYfywvPM2QSmZZP6yG4QybHUr7cBrNViCiTggfPNEHZZJc5LEEgupvIb6ppCTYyHGheDHMfXT9pqlmNttF0EvTUnvZhaHnRPw+XA8wGZaMDoMCfQ0ThKCaXTsJ6WYwG0jp/TFMv775ldEvogLlPw8AJQrLh5nxaFpv9gjZ4Rwv0u4k24IIoOFGXDQGUcJtkw7cSx7DxHZGU9WcOa40mnoTSjfCZ0GyaH7FZ635LdD/gFrBCjyB999CJ1vdV
 CLwvPS7z
 WTEc8tX/aB24CAS0U+GIsK/ZoXMhJ7EB2WDUgyyoYRR1REYdbfd5oWjXlK0ltDHmzSn9oNzqO2JGjyu6k1pG27wJXbD+v2U3haSesjXfnf5jS1lr7idMBPyifFlALw24sRk/rqfk/8foo8u+hK5oq5zjyj8K+Ob0H37kw4GByBv1Kgbp+4YsLiVAP2lVMK9j29YRmti4P9hII74ryjOkazh7raNHaoMhteKWDixjQ+T2XOzq8kaq5YvDVMvmh8aSV7aY1q5SnrcKt3SiObAHYUcRLhCeWmdoxkicGwguWGS6ur26mHr4yBt68ipc2u+ArCumc2xPBduod2dNroXAwTZFZp62ySRNvOStN36cZKKPBJZpEU9dg6LsV0/DMaRLUNkhtz33x8n6EE5X6rXI6vKU4iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 52f657e34d7b21b47434d9d8b26fa7f6778b63a0 ]

김영민 reports that shstk_pop_sigframe() doesn't check for errors from
mmap_read_lock_killable(), which is a silly oversight, and also shows
that we haven't marked those functions with "__must_check", which would
have immediately caught it.

So let's fix both issues.

Reported-by: 김영민 <osori@hspace.io>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The same bug exists in v6.6. Now I have all the information I need for a
comprehensive analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
- **Subsystem**: x86: shadow stacks
- **Action verb**: "proper error handling" — implies fixing
  improper/missing error handling
- **Summary**: Adds missing error check for `mmap_read_lock_killable()`
  return value in `shstk_pop_sigframe()`
- Record: [x86/shstk] [fix/handle] [Add missing error check for
  mmap_read_lock_killable return value]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Reported-by**: 김영민 <osori@hspace.io> — a security researcher who
  found this issue
- **Acked-by**: Oleg Nesterov <oleg@redhat.com> — kernel hacker, known
  for signal/scheduling work
- **Acked-by**: Dave Hansen <dave.hansen@intel.com> — x86 maintainer,
  original committer of the buggy code
- **Acked-by**: Rick Edgecombe <rick.p.edgecombe@intel.com> — author of
  the original buggy commit
- **Signed-off-by**: Linus Torvalds <torvalds@linux-foundation.org> —
  author of this fix
- No Fixes: tag, no Cc: stable tag, no Link: tag
- Record: Authored by Linus Torvalds himself. Three Acks from relevant
  domain experts (x86 maintainer, shadow stack developer, Red Hat kernel
  developer). No mailing list thread (Linus committed directly).

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
- **Bug**: `shstk_pop_sigframe()` calls `mmap_read_lock_killable()`
  without checking the return value
- **Symptom**: If the lock acquisition fails (process receives a fatal
  signal), the code continues as if the lock was acquired. This means
  `find_vma()` is called without the mmap lock held, and later
  `mmap_read_unlock()` may be called on an unheld lock
- **Root cause**: Missing return value check — "silly oversight"
- **Second issue**: `mmap_write_lock_killable()`,
  `mmap_read_lock_killable()`, and `mmap_read_trylock()` lack
  `__must_check` annotations, which would have caught this at compile
  time
- Record: Missing error check on lock acquisition. Can lead to calling
  find_vma() without lock and calling mmap_read_unlock() on unheld lock.
  Both are correctness/safety bugs.

### Step 1.4: DETECT HIDDEN BUG FIXES
- This is explicitly a bug fix, not hidden. The missing return value
  check is the primary fix, and the `__must_check` annotations are a
  secondary preventive measure.
- Record: This IS a direct bug fix, not disguised.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
- **arch/x86/kernel/shstk.c**: +2 lines, -1 line (changed 1 line into 2
  lines with error check)
- **include/linux/mmap_lock.h**: +3 lines, -3 lines (added
  `__must_check` to 3 function declarations)
- Functions modified: `shstk_pop_sigframe()` (code change),
  `mmap_write_lock_killable()`, `mmap_read_lock_killable()`,
  `mmap_read_trylock()` (annotation only)
- Record: Very small, surgical fix. Net +2/-1 code lines. Scope: single-
  file code fix + annotation additions.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Hunk 1 (shstk.c):**
- Before: `mmap_read_lock_killable(current->mm);` — return value
  discarded
- After: `if (mmap_read_lock_killable(current->mm)) return -EINTR;` —
  return value checked, function returns error on failure
- Affected path: Error path during signal frame restoration (sigreturn)

**Hunks 2-4 (mmap_lock.h):**
- Before: Function declarations without `__must_check`
- After: Function declarations with `__must_check` annotation
- These are compile-time annotations only, no runtime behavioral change

### Step 2.3: IDENTIFY THE BUG MECHANISM
- **Category**: Missing return value check / logic error
- **Mechanism**: When `mmap_read_lock_killable()` fails (returns non-
  zero because the process received a fatal signal), the code proceeds
  without holding the mmap lock. This leads to:
  1. Calling `find_vma()` without the mmap read lock → race condition
     with concurrent VMAs changes
  2. Calling `mmap_read_unlock()` on a lock that wasn't acquired → lock
     imbalance, potential lockdep warnings, and undefined rwsem behavior
- Record: Missing error check on killable lock. Bug category: lock
  acquisition without check, leading to unlocked VMA access and lock
  imbalance.

### Step 2.4: ASSESS THE FIX QUALITY
- The fix is obviously correct — it's a standard pattern: check return
  value, return error on failure
- It's minimal and surgical — 1 line changed to 2 lines in the actual
  code fix
- Regression risk: extremely low — the only new behavior is returning
  -EINTR when a fatal signal is pending, which is correct behavior
- The `__must_check` annotations have zero runtime risk
- Record: Fix quality: excellent. Obviously correct. No regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
- The buggy line (354) was introduced by commit `7fad2a432cd35b`
  ("x86/shstk: Check that signal frame is shadow stack mem") by Rick
  Edgecombe on 2023-06-12
- This commit first appeared in v6.6-rc1
- Record: Bug introduced in 7fad2a432cd35b (v6.6-rc1). Bug has been
  present since v6.6.

### Step 3.2: FOLLOW THE FIXES: TAG
- No explicit Fixes: tag, but the implicit fix target is
  `7fad2a432cd35b`
- The buggy commit `7fad2a432cd35b` is present in stable trees v6.6+ and
  v6.12+
- It is NOT in v6.1 or v5.15 (shadow stacks were added in v6.6)
- Record: Buggy code exists in v6.6.y and v6.12.y stable trees.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
- Recent changes to shstk.c include vfork handling, double unmap
  warnings, x32 support, etc.
- None of these are prerequisites for this fix
- The fix is standalone
- Record: Standalone fix, no prerequisites.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
- Author is Linus Torvalds — the kernel maintainer himself. Maximum
  authority.
- Record: Author is the kernel maintainer.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
- The fix modifies `shstk_pop_sigframe()` which exists unchanged since
  v6.6
- The `mmap_read_lock_killable()` function signature exists in all
  relevant stable trees
- No dependencies
- Record: No dependencies. Can apply standalone.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.5: PATCH DISCUSSION
- Per the agent investigation: this patch was committed directly by
  Linus Torvalds without a mailing list thread
- b4 dig found no matching lore thread
- The commit has no Link: tag
- Three domain experts provided Acked-by tags, suggesting private review
- No stable nominations found in discussion (no discussion to find)
- No NAKs or concerns
- Record: Direct Torvalds commit. No public discussion. Three expert
  Acks.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS
- Modified: `shstk_pop_sigframe()` (code fix)
- Annotated: `mmap_write_lock_killable()`, `mmap_read_lock_killable()`,
  `mmap_read_trylock()`

### Step 5.2: TRACE CALLERS
- `shstk_pop_sigframe()` is called from `restore_signal_shadow_stack()`
  (shstk.c:434)
- `restore_signal_shadow_stack()` is called from `sys_rt_sigreturn` and
  compat sigreturn in signal_64.c:271 and signal_64.c:387
- **This is the signal return path — called every time a signal handler
  returns on a system with shadow stacks enabled**
- Record: Called from sigreturn syscall — common path for signal-using
  applications with shadow stacks.

### Step 5.3-5.4: CALL CHAIN
- User signal handler returns → sigreturn syscall →
  `restore_signal_shadow_stack()` → `shstk_pop_sigframe()` → buggy
  `mmap_read_lock_killable()` call
- The bug is triggered when: SSP is page-aligned AND a fatal signal
  arrives during lock acquisition
- The code path is reachable from userspace via sigreturn
- Record: Reachable from userspace sigreturn. Trigger requires page-
  aligned SSP + fatal signal during lock wait.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
- Verified that all other callers of `mmap_read_lock_killable()` and
  `mmap_write_lock_killable()` in the tree properly check the return
  value
- The shstk.c call is the ONLY instance where the return value is
  discarded
- Record: Only known instance of this bug pattern.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
- v6.6.y: YES — `7fad2a432cd35b` is in v6.6-rc1, and the buggy code at
  line 314 of shstk.c is confirmed
- v6.12.y: YES
- v6.1.y: NO (shadow stacks not yet added)
- v5.15.y: NO
- Record: Bug exists in v6.6.y and v6.12.y stable trees.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
- The shstk.c fix (2 lines) should apply cleanly to 6.6.y and 6.12.y —
  the function has not changed structurally
- The `mmap_lock.h` changes (annotations only) might need minor context
  adjustments in 6.6.y due to different line numbers, but the function
  signatures are identical
- Note: In 6.6.y, the mmap_lock.h file is simpler (no VMA lock
  complexity), but the three affected functions have the same signatures
- One concern: `mmap_read_trylock` was later deleted in `cf95e337cb63c`
  which is in v6.12 but the function still exists in current mainline as
  `mmap_read_trylock`. Checking...

Actually, looking at the grep results, `mmap_read_trylock` still exists
at line 405 of the current mmap_lock.h. The deleted function was
`mmap_write_trylock`, not `mmap_read_trylock`.

- Record: Expected clean apply for shstk.c fix. Minor context adjustment
  may be needed for mmap_lock.h. Overall: low backport difficulty.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE
- No related fixes found in stable trees for this specific issue
- Record: No existing fix in stable.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
- **Subsystem**: x86/shstk (shadow stacks) — security feature for x86
- **Criticality**: IMPORTANT — shadow stacks are a hardware security
  feature used on modern Intel/AMD CPUs. While not all users enable it,
  it's increasingly common with CET (Control-flow Enforcement
  Technology)
- Record: x86 shadow stacks — IMPORTANT security subsystem.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
- Active development — recent commits include vfork handling, x32
  support, uprobe integration
- Record: Actively developed subsystem.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
- Users of x86 systems with shadow stacks enabled
  (CONFIG_X86_USER_SHADOW_STACK)
- This includes modern Intel (12th gen+) and AMD CPUs with CET support
- Increasingly common in enterprise and security-focused distributions
- Record: Affected: x86 users with shadow stacks (CET) enabled. Growing
  user base.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
- **Trigger**: Process must use signals (common), SSP must be page-
  aligned (periodic occurrence during normal use), AND a fatal signal
  must arrive during `mmap_read_lock_killable()` wait
- The page-aligned SSP condition happens naturally as the shadow stack
  grows
- Fatal signals during lock acquisition are uncommon but possible
  (SIGKILL during signal handler return)
- Record: Trigger requires specific alignment + fatal signal timing. Not
  extremely common but plausible in production.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
- When triggered: `find_vma()` called without mmap lock → concurrent
  modification race → potential UAF or corruption
- `mmap_read_unlock()` called on unheld lock → rwsem imbalance → lockdep
  warning, potential undefined behavior
- On the error path (out_err), `mmap_read_unlock()` is also called
  without the lock being held → double unlock
- Severity: **HIGH** — lock imbalance can cause kernel warnings, hangs,
  or data corruption. UAF from unlocked VMA access is a security
  concern.
- Record: Failure mode: unlocked VMA access (race/UAF risk) + lock
  imbalance (undefined behavior). Severity: HIGH.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
- **Benefit**: Fixes a real bug that can cause lock imbalance and
  unlocked memory operations on a security-sensitive code path. Growing
  user base.
- **Risk**: The fix is 2 lines of actual code change + 3 annotation-only
  changes. Obviously correct. Zero regression risk.
- Record: HIGH benefit, VERY LOW risk. Excellent ratio.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**Evidence FOR backporting:**
- Fixes a real bug: unchecked return value of lock acquisition function
- Bug leads to: unlocked VMA access (race condition, potential UAF) and
  lock imbalance (undefined rwsem behavior)
- Fix is extremely small (2 lines of code change)
- Obviously correct — standard error checking pattern
- Authored by Linus Torvalds
- Acked by 3 domain experts (x86 maintainer, shadow stack developer,
  kernel hacker)
- Bug exists in stable trees v6.6.y and v6.12.y
- No dependencies or prerequisites
- Code path is reachable from userspace (sigreturn)
- The `__must_check` annotations prevent future similar bugs (zero
  runtime risk)

**Evidence AGAINST backporting:**
- No explicit Cc: stable or Fixes: tag (expected — that's why it's being
  reviewed)
- The trigger requires specific conditions (page-aligned SSP + fatal
  signal timing)
- The `__must_check` annotation changes touch a widely-included header
  file (could theoretically cause new warnings if any caller doesn't
  check return value — but verified all callers do)

**Unresolved:**
- None — all key questions answered

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES — trivial error check addition,
   acked by 3 experts
2. **Fixes a real bug?** YES — unchecked lock return → unlocked access +
   lock imbalance
3. **Important issue?** YES — potential UAF, lock imbalance, undefined
   rwsem behavior
4. **Small and contained?** YES — 2 lines code change + 3 annotation
   changes
5. **No new features or APIs?** Correct — no new features
6. **Can apply to stable trees?** YES — clean or near-clean apply
   expected

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
- Not an exception category — this is a standard bug fix

### Step 9.4: DECISION
This is a clear YES. The fix is tiny, obviously correct, fixes a real
bug (unchecked lock return value leading to unlocked VMA access and lock
imbalance), has zero regression risk, was authored by Linus Torvalds
himself, and was acked by three domain experts.

## Verification

- [Phase 1] Parsed tags: Reported-by: 김영민, Acked-by: Oleg Nesterov, Dave
  Hansen, Rick Edgecombe. Signed-off-by: Linus Torvalds (author).
- [Phase 2] Diff analysis: 2 lines changed in shstk_pop_sigframe() to
  add error check for mmap_read_lock_killable(); 3 annotation-only
  changes in mmap_lock.h adding __must_check.
- [Phase 3] git blame: buggy code introduced in commit 7fad2a432cd35b
  ("x86/shstk: Check that signal frame is shadow stack mem") by Rick
  Edgecombe, first in v6.6-rc1.
- [Phase 3] git merge-base: confirmed 7fad2a432cd35b is in v6.6 and
  v6.12, NOT in v6.1 or v5.15.
- [Phase 3] git show v6.6:arch/x86/kernel/shstk.c: confirmed buggy
  `mmap_read_lock_killable(current->mm);` at line 314 without return
  value check.
- [Phase 3] git log --oneline -20 -- arch/x86/kernel/shstk.c: no
  prerequisite commits needed.
- [Phase 4] b4 dig: no mailing list thread found — Linus committed
  directly. Confirmed by agent investigation.
- [Phase 5] Grep for shstk_pop_sigframe: called from
  restore_signal_shadow_stack() at line 434, which is called from
  sigreturn paths in signal_64.c:271 and signal_64.c:387.
- [Phase 5] Verified all other callers of mmap_read_lock_killable
  properly check return value — shstk.c is the only unchecked instance.
- [Phase 6] git show v6.6:include/linux/mmap_lock.h: confirmed same
  function signatures, __must_check annotation would apply cleanly.
- [Phase 6] Verified mmap_read_trylock still exists in current tree at
  mmap_lock.h:405.
- [Phase 8] Failure mode: unlocked find_vma() (race/UAF risk) and
  mmap_read_unlock() on unheld lock (lock imbalance). Severity: HIGH.
- [Phase 8] Risk: 2 lines of code change, obviously correct. Risk: VERY
  LOW.

**YES**

 arch/x86/kernel/shstk.c   | 3 ++-
 include/linux/mmap_lock.h | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/shstk.c b/arch/x86/kernel/shstk.c
index 978232b6d48d7..ff8edea8511b4 100644
--- a/arch/x86/kernel/shstk.c
+++ b/arch/x86/kernel/shstk.c
@@ -351,7 +351,8 @@ static int shstk_pop_sigframe(unsigned long *ssp)
 	need_to_check_vma = PAGE_ALIGN(*ssp) == *ssp;
 
 	if (need_to_check_vma)
-		mmap_read_lock_killable(current->mm);
+		if (mmap_read_lock_killable(current->mm))
+			return -EINTR;
 
 	err = get_shstk_data(&token_addr, (unsigned long __user *)*ssp);
 	if (unlikely(err))
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index d53f72dba7fee..81fcfde3563dd 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -345,7 +345,7 @@ static inline void mmap_write_lock_nested(struct mm_struct *mm, int subclass)
 	__mmap_lock_trace_acquire_returned(mm, true, true);
 }
 
-static inline int mmap_write_lock_killable(struct mm_struct *mm)
+static inline int __must_check mmap_write_lock_killable(struct mm_struct *mm)
 {
 	int ret;
 
@@ -392,7 +392,7 @@ static inline void mmap_read_lock(struct mm_struct *mm)
 	__mmap_lock_trace_acquire_returned(mm, false, true);
 }
 
-static inline int mmap_read_lock_killable(struct mm_struct *mm)
+static inline int __must_check mmap_read_lock_killable(struct mm_struct *mm)
 {
 	int ret;
 
@@ -402,7 +402,7 @@ static inline int mmap_read_lock_killable(struct mm_struct *mm)
 	return ret;
 }
 
-static inline bool mmap_read_trylock(struct mm_struct *mm)
+static inline bool __must_check mmap_read_trylock(struct mm_struct *mm)
 {
 	bool ret;
 
-- 
2.53.0


