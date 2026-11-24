Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A57606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YiRvZG6T
Received: by kanga.kvack.org (Postfix)
	id C49FF6B0897; Tue, 24 Nov 2026 18:00:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA416B0899; Tue, 24 Nov 2026 18:00:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B716B089A; Tue, 24 Nov 2026 18:00:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CFD76B0897
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:00:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ECF9B1C485A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:32 +0000 (UTC)
X-FDA: 85471533504.15.26E2E0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1306A12000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YiRvZG6T;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561231;
	b=m9xFlVI5g5EZlkHJnR1pKEoeXm+lmrQ7ba6GaISVY/KhOGtJmIRZoMYyhbJlGinmxY61HC
	MX4Xw/roe/C1JkEN+YaCK2GUlutDees0vjpzBuZnR9maVUpG9BdFc2a0vMfsXh/+elDAgA
	XLd+GEXnsGCL5HZpYYZIyIYfGYWLu9o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHvZLsq7hnOdbwruvamY5wZBBT+mrqtWqcUuR58rX6E=;
	b=wgOQ/dl+y8RkJ+E1zp3gFqaZTCbAUYhEvXKmww88MYKlbKw/tDa27jbIAt+/izF4KmGVxO
	RsUpcSkKEtM4ehIiKSnYPzExps3RdqY589+TJep5gjOBPcRMK+m3D7lxRO3d3sRi73WpRk
	ZGmi0Mq38QXMkVZ2zotIlEzJqnogI+M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YiRvZG6T;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A776862692;
	Tue, 24 Nov 2026 23:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EC01F00A3E;
	Tue, 24 Nov 2026 23:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561230;
	bh=EHvZLsq7hnOdbwruvamY5wZBBT+mrqtWqcUuR58rX6E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YiRvZG6TgJBgOXVrxFjDs+ksGEIcjXpNrKPbX13/mo9kua/NCHghksmb/JUm1k15y
	 vH7u1PKWjrZpU+jtK4RA7TvKUAFYbLHNWXX5TvHdyjnSkKkqJ+ut45fLwud0Sug3oY
	 ep3NQ9Om33EWI7Or/2aZLvcYosHjEP0aexLZ6d6rmQIukr4zngnndFJNNNMRU1gEJU
	 S+9w/cyBRvtn0zc67zXpCOPcrxc2Mb4lCY8txBTkdiXkZT6Wg3isd/PA9tANYZ0cmp
	 YUNXw8jKMtfJjFE5wiEO8mDECdcEwURpQHbOTNfyWleaNutC0Au6RlWJmUvVps1ZSy
	 Tzj/SNfCtk7zw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:39 +0100
Subject: [PATCH RFC 16/19] exit: don't take the mmap lock in exit_mm()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-16-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=1832; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Bhh6F2ZX7wE8WDQ567dVS5J6fGn2WThh0ZTBWQRLCj8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSziZ1oNb4f4PPk/bPlDfIW195V3LnaGpSntOCxun/6o
 UAlyUtTO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACayoYLhnyUjyzGJIuWK2ovq
 ym0u02R7FtXkvNxjc/p875QPElc3WTMy7GxgmnVfIuBISsfFXWd5bGb2XWkWZ/k1fULguhlBMb/
 82AE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ekdna7ffpmp44js53rcfhypyhpj4uoun
X-Rspam-User:
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1306A12000A
X-HE-Tag: 1795561230-821841
X-HE-Meta: U2FsdGVkX1/2lRzlav05GDA0KhBTv4M0qVRMsWPlUAr0TuQAjbVGTNnhjs/ksxWymrRKVwXDsXZZoxVWQK9w6nzfGSju29uQZmcjYxj5J/VWLsduAoOdiOmUKiAEbkA9CYGmYLV/Ab41FqdIKtES7gpMIkTWKS1kdFb6oy4+PuZ+bA0rm5TC/sypNDwf9IUWa1kyBsBeOcVPDggjiyU1d/3lLLuHHDXBrws1gVNRwA3PUDEjZQOwHmlE0nrCt7RThdPTH0Ne17IeHmQyVBYgsIy3yh3qMmfq7hjDYvhFCdfQ+jUhM8H+w5A2iHNgTDtECbkG736cAAINIwGiEYbLLBOJYVARtC0jicIVmH3OT5qdTxz2HjEK2ZXeJ19lmWNqx94nOUtCkNNbB0dJG+/DMKXUl6zKH0ar5zDAwq/Mzh9zyDWOX4T2x/hKCooFjLsR6bPSDPnT1t+raLURHZQ41r8OtGsyBI5JQcDkFuRGjXkgZJoqX5LJ581ejlIkgSEyzY4ADvfGYk62/WLFCFzRbfvwrIEbrC2ZrJVrcljz+TcPbP46o4C+V2RZU80FJTiwY25TQE/gZHB/PrPOs1SrjDLQRgDRDarlUOWbRWa7rTDUuJtvsjOJYgxs9nwlvfWrEgD9qKxebZtVIJZJ498Fgr1rALuFaRxoToEi52gqIuTqxwhAg+bmAitd6cE6kYnfbCrg6dantXHaw3sK+fPAoYSNfaPNyv2f3eG4auniPzpStE7NkSig0drEZ3mO+cp3bO67+gZBvPX8kXenjuEFmpo4w4k0lO9Y7AkzBX6pe4odMJmCnXOkQ7fkX+3ZLovUMfacahh121WSZ21Xpsy5o8g/92tS6q/pm8n8jZfFxOl2CRT37eucMSkkCEkIFKjrNy+R/CFU37JfHMDz2zPBq7oKMLE80bypXJO12tb9X3U30xBGfwFHaIRhKCiBbmKxkrkO/1ERF+8UOKMnF2w
 gsOC7GoJ
 DlUTuv7nvNvdoNuTPx6qjriStw/WOjpDqLM67Nnm+pHTmts3f35MreABxi9USxcZCkNJlOMYKw6wELZCtXLN0avwKB1CFoYBXHuf/v6xTFtfZFi0jB7wCN4Zaa/T/mIdGWmooGK/woTeXKNX9zs03XtxYsySpSRXOh6Pl0itbVAkbIqDyg5UHPcn4z8tXSJLlQmYM/jXPwaubrr6Dpp1cJYEyt57tKfCYk6sOQ1xYy/O6fcBMd9xM6I5u92Z2Zx861JC+ghAjX7/SQUOmHeCiWgSoN68hxeV3GD5zDJzss/+7w4KfexF6oPxJ2MUMhXXdOKOKoTqL80I+VTcakg9Gr+MoYwgMq+e6BZB5/6KHB5j5vLeurYpFJuzBYU0K+dlATeyiqBul7RTadPG6L8dmzUEnuFUCiBRW9KS9z+XtPWPRokHjEuY3Whkmj1H2i+55G/F4ToOlNnZRF3dwnJ6kkbv2UH0hKEjDLSkFKZ09gHrx1ORkESRSLT1GE+1CrG7kMAtbTOLCsZqnL1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

exit_mm() takes the mmap lock for reading around clearing current->mm.
That goes back to 2003 (cf. [1]). A coredump took the lock for writing
and counted every thread that had an mm in mm->core_waiters. An exiting
thread had to look at core_waiters and clear its mm without the dumping
thread getting in between.

Commit 92307383082d ("coredump:  Don't perform any cleanups before
dumping core") moved that check into coredump_task_exit() which runs
before exit_mm(). And commit 0258b5fd7c71 ("coredump: Limit coredumps to
a single thread group") moved core_state into signal_struct and the
check under siglock. Since then the lock in exit_mm() doesn't protect
anything a coredump looks at.

So don't take it.

While at it, drop the comment that calls task_lock() more a memory
barrier than a real lock. It's the only lock that's left around clearing
current->mm.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/commit/?id=99365bd4725d431255ff4bdd51fb3dca60c47322

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/exit.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index d5e7bc2af804a..38de318a07aaa 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -559,10 +559,8 @@ static void exit_mm(void)
 
 	sched_cache_exit_mm(current);
 
-	mmap_read_lock(mm);
 	mmgrab_lazy_tlb(mm);
 	BUG_ON(mm != current->active_mm);
-	/* more a memory barrier than a real lock */
 	task_lock(current);
 	/*
 	 * When a thread stops operating on an address space, the loop
@@ -581,7 +579,6 @@ static void exit_mm(void)
 	enter_lazy_tlb(mm, current);
 	local_irq_enable();
 	task_unlock(current);
-	mmap_read_unlock(mm);
 	mm_update_next_owner(mm);
 	mmput(mm);
 	if (test_thread_flag(TIF_MEMDIE))

-- 
2.53.0


