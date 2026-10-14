Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77EF9CC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16D756B0092; Tue, 13 Oct 2026 23:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7F16B0095; Tue, 13 Oct 2026 23:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04146B0096; Tue, 13 Oct 2026 23:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA6E16B0092
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:12:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F97B803EE
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:12:58 +0000 (UTC)
X-FDA: 85319760036.03.12BB47D
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf11.hostedemail.com (Postfix) with ESMTP id A503940007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:12:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="I/Ve6Ntv";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf11.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=18766350203@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791947576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GQ2NJ+XFehaoUKQh9K8T656Nb9kxKH0kwaVt8iqHl4=;
	b=XfW2xXbAVRD2jhFOSh/0XdqNxwGb9GwC/DLbFeEiJEumlnPPg+7yLflwXula+VsM51Sdq2
	7hRTvqAebJg7WWeBCsPBy0kuKsy3IuKzB6fJiWzkDmHxXdG3YySVvxxsT+q0xAx/ZeCjTl
	XqGswnYsrbyWuq2BcR4phNDohBEYUYU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="I/Ve6Ntv";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf11.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=18766350203@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791947576;
	b=G1bWL0asyunO0zsy7GP7CuKuud3ZBMbnfmWC5neWthVmoMddVDm30UuvRk+GsgHiStnuuM
	3HHcjXzR0KAhze5tuGdB7ePOZSxUR3++Qgl2QTkwGAmKNCQkWVvuW8YPM4LyYfwrU1uhHX
	At/Gw2xkvXVbhM9AXzVi8dWA4mF0tb8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=7G
	Q2NJ+XFehaoUKQh9K8T656Nb9kxKH0kwaVt8iqHl4=; b=I/Ve6NtvlPGIqUL+ZA
	VubSUKBOj9Eh28JifaDZ2YLNsyeYTJB6el9RxdWWhxSUeyfcASGDdcSdR5iVAIDV
	bv15TNmCIUgBABh7MvzDaB61Bkmbe6cgRNx+WuvX8LKY7XAvnExoO1RyyBcrN2vo
	ti6xnEcYS9eTsWg/IGNcjw+Q8=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgB36cMq885qzbNoEA--.22532S2;
	Wed, 14 Oct 2026 11:12:43 +0800 (CST)
From: Haolong Wang <18766350203@163.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memfd_luo: carry the exec-bit state in the preserved record
Date: Wed, 14 Oct 2026 11:12:35 +0800
Message-ID: <20261014031235.432509-1-18766350203@163.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <sashiko-outbox-170651@kernel.org>
References: <sashiko-outbox-170651@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgB36cMq885qzbNoEA--.22532S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXF4fJF13Gw48XrWfAr47Arb_yoWrtFyrpr
	Z8Kr1Yyw1kGa40vw4xZw1IqryrA3yIyF1rJFs8Kry7A3W5WF1SqFWFga4Y9FyUGrnaga42
	qa1j9348Za98Zw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Uyq2_UUUUU=
X-Originating-IP: [2408:8418:c22:8000:1bbd:2550:438b:167e]
X-CM-SenderInfo: jpryllawtvijiqt6il2tof0z/xtbC1AxWHmrO8yxxJQAA3-
X-Stat-Signature: d75ycik1msud3shz1xspam49jmxsh3bg
X-Rspam-User: 
X-Rspamd-Queue-Id: A503940007
X-Rspamd-Server: rspam08
X-HE-Tag: 1791947575-576344
X-HE-Meta: U2FsdGVkX1+RYzYm+QVupmRMbguPNqDa+Rm8KbytcWMhZQnovJx6rZDqv8nfBfkQfDzAi4/M2fpN1Mn1or6SP7KpYKg6wKjY1/oWBHTbMWf7ZEdsYKW2kbTQUwgT7aDstUh2FAaoIZCNmaR3BtKLS8dpYj+ej3pYDr8zXzqqUZKDu8VucUln/UcfSzUG5XpBJjYaZFk8wYx2R+Tz4/oiye5GZkD2u7Nm5d/opqi+/WjlmKiTyYog/Ftc8qrQu3WA/cRFNT/eNHJOKjRoG+cbaAS4UR0lpOetloSxAIWsgcP4CYlal24PloiAWlWFCuJ6siG2XfxchYRiYmCMZhG7bF3ZHr3Uyvr+0Mk/bCI64tzCTZFO3Vc3ohoIY9RxdsFA7ZwqQVZc9HwoOxa1SjpQNukRQB9f+5OTKr0Z588rnG51SoA1O9Ct//Shw47Puz1RVM/3ill3Ct/CxHrqlhN+gkdssqDL1bUApT3tEG+hxIb7AbF0Byx4R+agx5FOgIR0dA7NQcUWnMtMfO1EqaGhodOhzqMDkIG912xA/qBgtmcm+aOdqP1QYaGL1mwWQ0TTemHTSMxYlMsPbI8alxwvpI1fj/gjlE68hZIkrGitaUnnvL6oJhR2JHiuz2ZZwtIu2Jj30uWv127QArZyG3Pf1zzI9t5W0oMB+WTEpsyQTWWXfiXpAIYak2KfKsqXkQ8VP+6GG3goWK7PDD1BTKB5hvEupoZk6DxnJV2r1w+BpuGWvRuYWwXLX8IEQyYHh9ueqqaNBrLWpAJJCPKmbLHGzE3hGXQj2x9K3fki2UlpV/sOsHJ58UgDfOC1+7ZqHwXi3TUu+pXrsgJhc2vWTn+vnvyJfMD64o6kU685sshawrQBQkfBuPx9ZAH3i2IbOfE7oAxurARvi6F5fqMAuT3h64AoXnbaakzJK5VZGpI+ZnZqc5DK6h4DMOaTz+/6GVukiuI0mx2oCOJgeNmrgoi
 nR2dPyw1
 mZNQaKHuPYgC36GWSzk25xc4CZpvagTGNPNYQQFLeq8HN7Gvi6TBQsKYAu88EP/I4Jfd8pT1Em3t/9pP16sfGGfO/ytNEmkljbirMc/hvF8WDmG1x+BgNPRfN+iEp3oVsaVT/LrzE54tlm6ETYQIxKd/i536S6tJ57PO5x24TwGt+JCEaQlewl4qgle7UlS/wkxYdFRO07QfmMfGxm2Zrw3+wE8pzYtAOyN2UJCvj7IzSAzbBw5EGGXasdiyRIRksu2r7UkGQuFRzfuJYZXqsxWyVcAxDhM6iBeOBsV9x/QqS2iQZeldtHPtie0L/qhYLb9n5VyTzEsb8L/TnvHxUGys+OxHPGHXLGl2QAoIjPtVZxM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review.  Both findings were real.

On the exec-mode snapshot: the sample itself was atomic -- the mode is
read under inode_lock, in the same critical section that sets
SHMEM_F_MAPPING_FROZEN -- but it was taken far too early.  The frozen
mapping only rejects growing, shrinking and fallocate(); fchmod() of the
exec bits (until F_SEAL_EXEC is set) and F_ADD_SEALS are not checked on
that path at all, and freeze() refreshed only f_pos.  v2 closes this from
both ends: freeze() takes the final sample of the exec mask and the seals
under the inode lock and, in the same critical section, sets a new
SHMEM_F_SEAL_STATE_FROZEN inode flag before dropping the lock.  From
that point on shmem_setattr() rejects exec-bit changes, memfd_add_seals()
rejects new seals, and shmem_set_acl() rejects access-ACL updates.  The
flag is cleared by a new .unfreeze callback when the update is rolled
back, and defensively by unpreserve().

Two more things fell out of that work:

 - A single "some exec bit was set" flag was not enough: an execute mask
   of 0100 (mode 0700) came back as 0111, which is the inversion this
   series is about.  The record now carries the three execute bits
   separately, retrieve() restores the exact mask and rejects unknown flag
   bits, and luo_kexec_simple.c round-trips an execute mask of 0100 with
   its full 0x3e seal set, plus a memfd without execute bits
   (MFD_NOEXEC_SEAL: mask 0000, seal set 0x20, still writable), which is
   the state the original report was about.
 - An access ACL rewrites inode->i_mode without going through
   shmem_setattr(), so the frozen state has to cover that path too.
   Scope note: F_SEAL_EXEC itself is still bypassable by an access ACL
   write (posix_acl_update_mode() updates the mode directly, with no seal
   check anywhere on that path).  That is a pre-existing
   F_SEAL_EXEC/vm.memfd_noexec issue, deliberately not part of this
   series; I will report it separately with a minimal repro.

On the folio leak: also real.  retrieve() now releases the preserved
folios on every failure path by sharing the cleanup with
memfd_luo_finish().  The folio array is restored before the file is
allocated, so the later error paths (memfd_alloc_file(),
memfd_add_seals()) can release the folios directly instead of allocating
memory while already handling a failure, and memfd_luo_retrieve_folios()
takes ownership as soon as it runs, so nothing is released twice.  It
predates the exec-bit work, so it is a separate commit with a Fixes tag.

Two limitations I could not close here, both written down in the patches:

 - f_pos can still change after freeze().  The LUO file API has no global
   userspace quiescence before .freeze() runs, so this needs a
   framework-level answer rather than a memfd one.
 - If kho_restore_vmalloc() fails before consuming anything (for example
   its own kvmalloc() fails), the folio array cannot be walked at all and
   those folios stay reserved.  That API is not failure-atomic and cannot
   be retried after a partial failure, so it needs a KHO-side fix or an
   allocation-free discard/iterator API.

On record versions: the record is now written as "memfd-v3", and a
read-only "memfd-v2" handler is registered next to it.  The compatible
strings are matched exactly, so the matrix is:

  record writer   reading kernel and handler     result
  old v2          old kernel, v2 handler         default executable mode
  old v2          new kernel, legacy v2 reader   no execute bits
  new v3          new kernel, v3 handler         exact exec mask and seals
  new v3          old kernel                     no handler, -ENOENT

Rows two and four are both behaviour changes, and neither direction is
interoperable: an executable memfd preserved by an older kernel comes back
without execute bits (row two -- the safe reading; the old reader never
looked at the flags, it restored the default executable mode), and a new
record handed to an older kernel finds no matching handler at all, so the
deserialization fails with -ENOENT instead of the memfd being restored as
executable again (row four, which is why the version is bumped).  The
legacy handler only reads records written by an older kernel: its
.can_preserve() always returns false, so an outgoing preservation is
always serialized as "memfd-v3".

v2 will follow as a separate thread.

Both changes are covered by a QEMU live-update run (preserve -> kexec ->
retrieve) with the liveupdate selftest: the memfd with execute mask 0100
and seal set 0x3e round-trips exactly, the memfd without execute bits
comes back with mask 0000, seal set 0x20 and still writable, and the same
test against a kernel without the change reports "execute mask changed
across kexec: 0111 != 0100".  The numbers are in the v2 cover letter.


