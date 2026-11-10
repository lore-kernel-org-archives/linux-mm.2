Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A592606A833
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZVw6VuAb
Received: by kanga.kvack.org (Postfix)
	id 245C46B00EF; Tue, 10 Nov 2026 11:57:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CEF56B05B5; Tue, 10 Nov 2026 11:57:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0971B6B05B6; Tue, 10 Nov 2026 11:57:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D88376B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:57:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 749201C43D9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:57:54 +0000 (UTC)
X-FDA: 85419816468.24.7B11EB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B20AA40003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:57:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZVw6VuAb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794329872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yX9hjizhMmy5s5UE+lA9T2wHanfAnmcASyLGAaLx7sc=;
	b=7VpXjGTFzBc6HEO8V3PWH0+019M11aEPoh56C1Q1UKi5pBRh7ZPcjYcvVhoFlIscR0g1iH
	NvwSPTvpiRBdrqV5ZAUOFd4QycKih8IDQaGtvcrfKQqmpE6GmURJzN9vaTSNQj/0KpoFRI
	Nqm1yctNxg1xza7V5QGhZEAYWdMOB78=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZVw6VuAb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794329872;
	b=YnN3KEaHebg2IJjZOv9W/rURdlvoLQj+IpsZjvZTR6BrzKcI/2Fw5EjIhJzsreMsn8Khap
	d3uF5L0NYwE8oQbsFY23Hn//87VLpcEBKTJXaFAJXnNIxHVP6MwEsvYJLFEG3xVTyeGr9k
	ViOg8ueSXGMVtoOQCmxIDXkyRCEJCbE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DBC3631AF;
	Tue, 10 Nov 2026 16:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FD91F0089F;
	Tue, 10 Nov 2026 16:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329871;
	bh=yX9hjizhMmy5s5UE+lA9T2wHanfAnmcASyLGAaLx7sc=;
	h=From:Subject:Date:To:Cc;
	b=ZVw6VuAbWRO78atvQnc91ZRY4BJ+7QWDZCtCUZwD5jEVfpwEFaAffbw83L2cC1yGS
	 VKSN1m6CUvoWVZ3eLjKlsbIJoqMPQ6hA3qxvPaOpRUeZCya9oOB2ASD0MtrohvW6eg
	 d0vak2WgAM2ebTXLVS2Ite2zrZqGceW1wc6nvpTiEzA+shFb4sHoeR96Og7o66VSka
	 wge3RV1uFUttG+sGo0w8Z1MWguZPhgq4JAZOAhHsjMyjUd5cUXbQKSrL/TokKmscE9
	 jNKyKk8y0aPo1Rne3FvNjaHTiHtFtqpcSHC54OUAsKCw3gTMl16CE+uQ+ntkDzs3Jg
	 AxQgxChbkUsKQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 0/3] mm: only assert mmap and VMA locks if CONFIG_DEBUG_VM
 is set
Date: Tue, 10 Nov 2026 16:57:42 +0000
Message-Id: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MMQqAMAxA0atIZgNtkSJeRRyCppqhVRopgvTuF
 sc/vP+CchZWmLoXMhdROVML23ewHpR2RtlagzPOW2sN3hQZSyQkbfRWHEZDa/DE7Aw0dmUO8vz
 Lean1A7kYkSNiAAAA
X-Change-ID: 20261110-tame-vma-asserts-480acf6aee20
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2282; i=ljs@kernel.org;
 h=from:subject:message-id; bh=l5iwL7Qd+mX6ZPWsXKwr0c6XQr5oPSXtaBAMqHbTYcA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI++/IclC+d4SBazfRe7PastMRCw0B1u/P9wdcOzPrEc
 rZlW2ttRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACby6SPDf4fYQ39UapuEjI6a
 TmH6MKfq/CnRyokfmu6seix3wchwYjMjw1fV6ddD7SyWvt8r7t7xNGbKU/NYpXz/xVZPn3XfkHk
 TzAEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B20AA40003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5ijhnseg1ugkeaagdei8whrkzwgkiynn
X-HE-Tag: 1794329872-416456
X-HE-Meta: U2FsdGVkX1+4XTZMzt2G6J/xl2w6hdeCOgvHiKbLggw/g2bjn9N5HO8QywDsVsl9LFj6JcnG9pThn61usq0E83olfBUmYSz8jPRoTKr96DawDKOs6ae824DjuLlLbx7v+Ft5hefs4MNm72ujBPC6yHLA98FGVPgzLFF+nPN0iOm+m1egKKND/RO/19lfZM0XP8qCr7fKnp5z79/VnILLZFiJnC11Tlwj+Hj4V6iEIzSYfkZRvx3qxvMN/jPM2/L6uhl7d36Be/aUYuFX/iWYzXtTeTwlf2+OFFDgUzv/O1EU7RbF4qUgRa2Ty4+/xAmrE7UbaltoDKx5Gu7pkTY0BKTTcAzSb5ch92ecP6Nz99avUd4Q8la2/XUey/mJkDOgDtzxAria/Zz9fmXkAA6bH1Pph+2Q4xtykKtJGLD957ux+XCIdpRPv6XmS9bYLO9uN/UeO3V8+A/N4Ou+WFaBOprGt+rZeM996GGMpGRAJ//BqWQ1xkUtv+AIaFU4i2EJiaNUNGn0HnNluSyaAEXpF3L4b7qnsgV8D8DdukP8WmJtjuu8UnRTTQ8ucVoLvgBA5xya5nNHzo5P4634zvu9DNA9+/cvNbKhJLtD9a5oFLeBytqJjYNSfyAnllzvOuU4FEgRy44HTLK73cckUtse9eDZf9NKNDD26Xo+++4DcNjxf5hSCha8pNW+Yi8xOKTpDiGn5pP8vr2TGxBttgdd7wHIiav3xwb/dKzCMyrIFTZpxt02J1B/tZ0fyQNGVBUjijYmTR5zFRr3rwottc0JXGFSpquFHgKA73bi028DYgz3+QJZI8Fx9ODdEWCFXSPuxkmM2lmdHg+5ASLhVIfusDe+0uXky4dJ67lWRMkC1gKZy+jt/DaVnBb5jqMZf9fGF5pZfNP4KO/CL/6eJLeLTe4tE7iTJj8U+1yQayFjhiBeMPOdMsE7qEdzTL+lCbqwVvZVLdJr52wPm1JngOQ
 7wsmSect
 u/naKvF89W1v08aXWmOQ+8bzMDSo6V6blsyiFr5YR1Y65TmNjC7SxChQmBxLqbsDFwydRdfs5rA2rfJvt5DqFq71vmcLGjZ54zErycvKbSujgVI+BGGz3uCx9aFI0DHSgppUhmbjlrmemhdOkP78Jog8/G3xE3zEAcgfoIa+XCuBoYUMp3AxxiS3dyxQ4u57JK7ioZDVZW9SQwGOnbXFpbb2x5XNSyoNJ83EuKDGmQ00RXTel2nPkPPluHwvkMpTTtzGWNrqbxAwejnJl7+i43NBdfTt89+zlnCjC3AHSesi8ET21ajpUnd13rymgk9vXS7AVGXM6UV1Z1o3BbpVvao3poJzoseg0uu1lFQyIgRvg8b6egWSB5iDx/UVpB1RXUKl4ux176f2uyJIC7yxip3RhgO8I06QFIkH8xnTUgE+llHLh76DJJDPIppHYa0smu1Ru4wWL+tyVErMGtx7Gd/IVS9l5rQt/icCYL/UymLz3yjw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently these asserts are all performed at runtime regardless of whether
or not the kernel is intended for debugging mm code (i.e. whether or not
CONFIG_DEBUG_VM is set).

These are explicitly programmatic checks - that is, checking basic
correctness in mm code which interacts with these locks.

The problem with this is that checks like this are generally asserted in mm
code using VM_WARN_ON_ONCE() and similar, and thus only checked if
CONFIG_DEBUG_VM is set.

So having some assertions which are unconditional and some not without it
being clear, creates something of an unintended two-tier system.

Since what is being asserted in these cases is exactly the same kind of
condition as those asserted in VM_WARN_ON_ONCE() assertions, simply
predicate them on CONFIG_DEBUG_VM.

Retain assertions for mmap lock asserts if CONFIG_LOCKDEP is specified in
order that expected lockdep assertions continue to function.

The VMA lock implementation already performs lockdep tracking regardless of
whether CONFIG_DEBUG_VM is set or not, so no changes are required there.

---
Note that this series assumes [0] has landed and builds on it. That patch
is the uncontroversial bit, this series contains the bits that are slightly
more controversial (but not really :)

[0]: https://lore.kernel.org/linux-mm/20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org/

To: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Liam R. Howlett <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

---
Lorenzo Stoakes (ARM) (3):
      mm: only assert mmap locks if CONFIG_DEBUG_VM or lockdep is set
      mm: only assert VMA locks if CONFIG_DEBUG_VM is set
      mm: convert WARN_ON_ONCE()'s to VM_WARN_ON_ONCE() in VMA lock code

 include/linux/mmap_lock.h | 23 +++++++++++++++++++----
 mm/mmap_lock.c            |  6 +++---
 2 files changed, 22 insertions(+), 7 deletions(-)
---
base-commit: b82f7651c53524960fe38a54aa69677dcddff655
change-id: 20261110-tame-vma-asserts-480acf6aee20

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


