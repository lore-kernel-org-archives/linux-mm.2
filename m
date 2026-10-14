Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9C7CC6B2F
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAAEF6B0088; Wed, 14 Oct 2026 16:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B806B008A; Wed, 14 Oct 2026 16:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74346B0096; Wed, 14 Oct 2026 16:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 894716B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:01:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E6CC1407AD
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:01:40 +0000 (UTC)
X-FDA: 85322301960.13.35B93F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 936C24000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:01:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fxvqOx1t;
	spf=pass (imf07.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792008098;
	b=sHcK1XWs6OwFlHu/SbQRcsZyqO/sdddmO7bPocQM+MRh4vlaYga/xwqwMSaEtmkfMxj5fD
	PXutPN0mtwXhbs6Qsc2Q+5Vfl9KqbDW7t47MbJhey0kxzA344VbMIxBLvz5DBBeAf6JbW9
	icKSEh3XfqkCt07yh3XZQoSQ9raqO2o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fxvqOx1t;
	spf=pass (imf07.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792008098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iLkP8vnDUW9ZlMok4Q2CsS89E/vjvuztRiGD0DVNLnY=;
	b=kdaWFt3sfFTTxLEwhfdPVJdVorvootAdtg8faZ0BO/K/6aXLGd3mE0MvdLR2elT44a7Hgg
	wxgy9YVw1lwakYEJzKcG9bVmmlqYtshDm8s/cDNT1HHIgfQlUWXRmzFBD3gV1Lx1prbA40
	gTsoWlMOQT7ONdk9/Ae8YIFcBk1foIM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B978641AFC;
	Wed, 14 Oct 2026 20:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C436B1F000C4;
	Wed, 14 Oct 2026 20:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792008097;
	bh=iLkP8vnDUW9ZlMok4Q2CsS89E/vjvuztRiGD0DVNLnY=;
	h=From:To:Cc:Subject:Date;
	b=fxvqOx1tZxtbBA12TqYuhlWyLcwaf5KCmkqlxau4XUntk+36D2inS+Co/m4/4VOSv
	 ZG4mNZz4BZfsF2YP9/5phOWSEpmiuSd7TrkFKu6Y0qU7ytUezwd8kmzJFlauMUoHZY
	 HX61ECIgh2egtKL7V1cwHhS/KPb5sRRBmwf3qfdA4OmN8mjmnKheUpcaYoFD4Yym9c
	 Mm3w4oAhXAVqWHu4wa5l/AK1gxvOpsMwNjCKDmWdn94K6wniSAHouwSLGFmcLlxfde
	 1JA+wWaB0ITkFGjPwLN3tOCOGqgagzKSloDPIdMc5/4fLBxtwmmiBNAVB2Jo3QZsq/
	 dd9HecXI7/bPw==
From: Sasha Levin <sashal@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Farid Zakaria <farid.m.zakaria@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/exec: report the skipped binfmt_misc_bpf test on stderr
Date: Wed, 14 Oct 2026 16:01:35 -0400
Message-ID: <20261014200135.1364053-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8yeyxsiacusbfk5we7yk9wafyke5r3hf
X-Rspamd-Queue-Id: 936C24000C
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792008098-158595
X-HE-Meta: U2FsdGVkX18ofo/2UdFu4CJnqjymhX3Kqqk1Awp0ZNqwwKrx/u3E0RSeluEuMHsvUDaetJRA1U1MMCNaqxbaX/ibqU1SKg2vXgi6tjH4DPpyDa4hrf2ZiBL2zQdDZt6dG1qEvvFt2rwzzFXM/SMJlEvhf9zc5mS/O3FVUqUwi1mTP1uuIe3mXRC1bDK9Lr1vagB0yBFvK0aZyNfT5EaG+zlVKuncNmSZ9+uhPPCrUuNYO78ahYMhWyXLz+BWoft+A2oE+91s9Ds1dLL6KwF54nl7cvvv098/6x3cll11urN2TXd2Wg2pOTmj1/AI9CycCKDtXxnafuf/vnCCam3DpP0ecl9P8tm64sTQH4wQ9k4RNUa+6zs7yTSuTNnNVpoKGoOgCbBFaYy5cO5Lk/z+sfYrd7K+qOEGf3IX7zSZkOxUMuSqDnpjOk1+KH6ltePUagNuTBLIBbUrWhJtkLou69ORXtIqn6n13jy8FUT5X8Pg1KzNRKn2jYp1WlXhO+zyHaiqplTU9223qnRx46d8QG+AFBVd7rTcw5JTBY+ztsbRIWyRMQd9sZeOdbyjcK+5o+tlsS9O+7Afg93vtZZ5HuUUpRtdrFbBZGqyarAazbF4wiIEIZJfh7yS4yYj0Eg85wgfuGJdhlgt92agXQpRLJBQ88/nOZUjqq/T/PFhhB66cQikU1ZNhGXfiXevv+21Rw/Jqe5GxFgWkEUuRgEtyhimyOVcnjM8rgsuaXkG2H2zU+3wQZKbduiibzQpgU1ioLWMPCCnk8edPl1ztswWHMXqkbqGVet2mYaSDJZutqWvV5WjfLwy5sSEAP63Wr964pMuDOYkYuzHUVbU9BOAQuOlYDi4oJL+idhrXwUX48QFOLPvpePvNKq0UBdSErzbNj65v7HRtzbUA6SRxERZdE+qvhX1u1HwNYIUZyLUaCjovU3nsznI2TClywnMPCg/sKg1sWR3JoCruD7cKvS
 4jgxNwrn
 hK3Fqbx4onlneTbYNdiQrFUvD9nUo/Mh+D8AY+SJosydQrkhx3JPV26U/f08LNb9a1/uCRZFLaCzOU2ofGrwUgkSe2VZ/Kqs89c4ldt8gjgkrA5T5EE6NDoWMxs8o3mCT/seoZUBQH9K7xFkaLNfRHjm8EM4ibCEP3WwmaYviY3EO0Uw4q2sMbeaykEwkOT8XTIy9BREOfE0GHW7XsA9frcCUW2h26ZwsZug38Yurh6846WOXkRedqB5Svdp3kSWhhy2gGEcG1UPv7vCsltwCJ/NpsiS6JOodFjqBkLZEDfjjOGICy9VxjgYqrfubYyuRRTsV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The exec Makefile announces that binfmt_misc_bpf is skipped with
$(info), which writes to standard output whenever the Makefile is
parsed. The selftests install target appends the standard output of
"make -s emit_tests" to kselftest-list.txt, so on systems without the
BPF toolchain the runlist gains a line that is not a test entry:

  exec selftests: skipping binfmt_misc_bpf, needs clang, bpftool, ...

run_kselftest.sh and CI systems that parse the runlist then treat it as
a malformed test entry.

Use $(warning) so that the notice still appears in build logs but goes
to standard error.

Fixes: 277d787feb2e ("selftests/exec: add binfmt_misc bpf-backed handler test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/exec/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 2220ed345e920..91decfa8ff2c1 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -67,7 +67,7 @@ TEST_GEN_FILES += bpf_interp.bpf.o nix_origin.bpf.o transparent.bpf.o
 TEST_GEN_FILES += loader.bpf.o interp_bind.bpf.o
 TEST_GEN_FILES += binfmt_bpf_interp binfmt_bpf_app binfmt_bind_interp
 else
-$(info exec selftests: skipping binfmt_misc_bpf, needs clang, bpftool, vmlinux BTF and libbpf)
+$(warning exec selftests: skipping binfmt_misc_bpf, needs clang, bpftool, vmlinux BTF and libbpf)
 endif
 
 EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*	\

base-commit: 4eb2586bd40db27d77cc5b724ca9386ed0c71d53
-- 
2.53.0


