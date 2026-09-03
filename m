Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 357FEC624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178FB6B00D8; Thu,  3 Sep 2026 03:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A6D6B00D9; Thu,  3 Sep 2026 03:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040066B00DA; Thu,  3 Sep 2026 03:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6DE86B00D8
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:25:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 70F3C403B4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:25:08 +0000 (UTC)
X-FDA: 85171614696.26.889F848
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B779FC0005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:25:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPeyMhQm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788420306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wPucY5EIsuH+AW/lLxBJfKPFJjpHUnizOauIgQ1zZxg=;
	b=NtfHQzajBWN62oP1Q3NFkBIUB8UpkLitByJLYhmx8avxuHyCGyBVLf9wRs0rU7BQU0z4l6
	6sNDzuc/43OJx5b0qwOv1WvipY9HfERVMKSC3ECbjK8KXMBv4jgG00WnGU0rCwZXQtReV+
	egnMnnOGSXGP3shN8UlPYhl7/8A3zpk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPeyMhQm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788420306;
	b=jT29V4W0Maec7GmC94h6GcuKVnhY6GCe29KhEb8efmt/0bPTxcn3ej8U8ifT6uj6/7qZLg
	iqxMKLqN+PPHzLbeO9VopHoWy/SPn5FcieYiEYJ6nZCi4c7za08lX2Hl3rkDDlDNkUvqbU
	DnY2H/7VzO8KZrcpogIEtcBj/MiXmDo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30DDC600C8;
	Thu,  3 Sep 2026 07:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0171F000E9;
	Thu,  3 Sep 2026 07:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788420305;
	bh=wPucY5EIsuH+AW/lLxBJfKPFJjpHUnizOauIgQ1zZxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPeyMhQmuRqh1o2rpfydGq3APDtDy/93AvzUfWZQw/xAxJ3dgRQmyEfFHSvCg23ye
	 R97gIZnFomeTd4TekNQU+GJxsVr5AVFJddPE0ETN8VBw7eKgeOjgpEEEu1cOAZh6Ie
	 ktMNmSYDyATrXdZhSF/VC3LHqEiqWDkyjopi+xeJNTaTcBqW5O0Fw5aHTqMSVfGdcm
	 Uk5ZyqeM6IpTg3qU1LYyhDhvyQB3MYYiEaBt6HMZQrUB4A5JfRg9qzUKcmw+H9PoqN
	 go8AqgjDqkbK1rBOEYtqAZugW+hBr5qZHgqJ79quiWF3kA5CQNgoI65c3RS4pEE2ar
	 3MoaDG+zq2MAg==
From: Christian Brauner <brauner@kernel.org>
To: Sun Jian <sun.jian.kdev@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	jack@suse.cz,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	tasos.papagiannnis@gmail.com,
	kees@kernel.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next] exec: Drop bprm loader before closing bprm->file
Date: Thu,  3 Sep 2026 09:24:53 +0200
Message-ID: <20260903-normung-opfer-matten-d29bbd55cf46@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260901114011.112375-1-sun.jian.kdev@gmail.com>
References: <20260901114011.112375-1-sun.jian.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1344; i=brauner@kernel.org; h=from:subject:message-id; bh=JJSUo2r2r3NvI07vkjwgk4phkhRYmLbnSW2ji/Irias=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTNVDiT4h7JtqGdtbju2HO/U2cXH1dSbtg81Wh7eYnFD Ju011xCHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMpPczI8KZr853KpVN4dCPt fnkbu/GsaLWr9Q9TMJRkfad3J2RxIMM/u6oNDZU9tx6u+R65I2H24XPWq/nlToY/6ZstfyJqSXc 2HwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o4tiwt5rk39qymr4grphw6gxguf56yar
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B779FC0005
X-Rspam-User: 
X-HE-Tag: 1788420306-350347
X-HE-Meta: U2FsdGVkX1/PVt0T9LZLDbzElh+BAxAp6s3dCz85KseKSdT4LTE9iEDoeLoCB7SSvjsXF7QxFTT+ctmaOLUoXvex3SUZs8mVZoFOoDJThQjDmZdXtk3rxlQiVupqTMTzO9keUtD2td068z9U0xv+qguWZn4w2jWsWUuyL8p6tCVa0XBjAe2ZwUPZ0PmnIXcMW8ahNhpvrmOQawb7qwiLFI1XXZC0ssPt5qmAZZHyw6KOFf4b/xWCkqFfNaL+s+CYWyQmjBHU2QWCBnEqytZlN6ljGfT4OAi33ffmevumySN+LQT/OUBK7j5ZCQWVeVqzVOgQUuYX8dYESEElVhLVjzAtOjE11FJIEG7/JcdquDF8o8UltWZJbV3TPK7QeCWDjCtWGNMFgbopbfET6wwdOrq1N+w6oq/xMq3rqbEqxhZACl/ZWGIhNkO+MXpuShNVWXQRqvWvW+pwnIOmKt/scLGPFSlQaxQHGLuZMxnqrntKc2gAqCkaQFoGAggNFKPzaranS4jV5mFZiCkJCoAwhB4MiErrJ7844kQ96Tq+u9so4bLljQvsHs06pi0OQNHciyGkZa77zuATfFuZZOfK9pr1BED5JGswHrK4gbRr+WysYlFyYxw6WhVFKQ+YGDQ448RjPLqDBjzCHU2t/AEBaa3dQeDNOl1cK62ea1Z9fEmkZXDwtpJuw+gLzMffEaVQlQKBKOds8oVHtJi0AfN4Ruhay6+P2mD9eqMf9zcA7USJ1/xIo1VbUB1Wy0eeOMqVeXfBx0ZEqqQpgEM6hRvKvZ5YUhkb8clEQ9UfvmEA982Gibmpc0hq74NYeuokVvtqSJKv+o/BuvGZpdPWOQqm8RA9O4RNTryAT4IWCGSdx+w1Aj+nAPOKInW2mga784+J2KbAdsvsRlyEMoSfF/OhCpZtf84foJfhBDqlwEYzi+n4gZswOu5Puau4zM1Fy6JKZ9oaxVPeFEdbX/AgRQA
 HrMgMBNa
 GF9Pxw4zWPG60AhZGzACYnsFx8v7Um8soVtXs0NiEUmAqc2vJShEdiHyu26VLjJIY8mKPt5n9VOBN6A5a6InLvP//5BJIIH21NJIPq+T7NeArK1HJCIMyXARKQAjrmtP8wAxecNnm9+Xd3B0lm6dVbM3mXpOSlaGJ1JG+NS4cTp7QuNjzuU2DkMLBubXYIDSU6jZg9U6GsVKwC0Tg2T1dk+MGJTgGsqLG+QpqlKfcWK2KB2kJKQMNPqStOknPLMzya3bMTOt8v3m37g3aOCpYDJu/gpOsN9A8ScKthhMczQ3ns2E7Tt79ZYgZOt6J8ffqvDYO2zyxLH+PndKKt/nUJ9UGdOhQN+zqc630eFH70/UyygM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 01 Sep 2026 04:40:11 -0700, Sun Jian wrote:
> free_bprm() currently drops what may be the final reference to
> bprm->file before calling bprm_drop_loader(). Since
> bprm_drop_loader() is attachable via BPF fentry and bprm->file is
> exposed as a BTF_TYPE_SAFE_TRUSTED pointer, the file can be observed
> after its reference has been released.
> 
> Move bprm_drop_loader() before do_close_execat(bprm->file), keeping
> the file reference held while the hook runs. This preserves the
> existing trusted BTF contract without changing verifier behavior.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] exec: Drop bprm loader before closing bprm->file
      https://git.kernel.org/vfs/vfs/c/115bf3e51538

