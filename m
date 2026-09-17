Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E150C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF676B008A; Thu, 17 Sep 2026 05:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469526B008C; Thu, 17 Sep 2026 05:09:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3316F6B0095; Thu, 17 Sep 2026 05:09:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 123906B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:09:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93E22A02BE
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:09:54 +0000 (UTC)
X-FDA: 85222681908.27.1E3ED5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id DBAC440009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:09:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ru9GCvTo;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5vMJLxb2WgC5tIFea55buznoCzbmE9D2zqOOZHr4b34=;
	b=Bu75uJfr5Ky+ZLstVsQyeTs3TL/FUKzHO9PqJfihQ5nOPuaSD7PI4XVdKN+No2tGLgBjq3
	hdK9SL6YvWlawwkhLz/VSVZcKRA3hxr062bSPFwEQ0A+2uR8MG6VbYDxV7jzuHkc+ptov2
	2CYPqVMLRJx7p4H12HWqPhi8CCijXmI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636192;
	b=v72pAwgwCIi5mHP3CKvAtITIEtghkvY6hMy/5mZteADzK/vurZJC1SpHpxkgx2fB9WKCem
	sIowpC0vDRLDxPoqKPVLP1NLUHi+zFnf9pHspS5TvI2TMMty0r/itnyS55NG+n/UFAZLjZ
	27aBoqrSNkf9V0UMZ6Ejx/2/Xm5/jPg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ru9GCvTo;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5984360204;
	Thu, 17 Sep 2026 09:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105E01F000FF;
	Thu, 17 Sep 2026 09:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636192;
	bh=5vMJLxb2WgC5tIFea55buznoCzbmE9D2zqOOZHr4b34=;
	h=From:Subject:Date:To:Cc;
	b=Ru9GCvTohAXBBstl0Oex+tcL4dV1TFEds9pYcha8vwp3uXnuo6Bi4iRCjcMaYUc+X
	 FRaoT2J2ypp7jwP9fPqAlO/8jTWjT4ksZdMcaLNFBxXAspLv+oGpF0LfPNTAi4FeRt
	 4Q2/SIm6LLegLzIYwqwWdk/okWRmseIE3TDOfXCE5QKsTkdlIxWMOJJ4MgoXgzagyR
	 D3G+JLehh1359FDR5O9sk1BkGQKTU/1oPN6qAJf25VfXR3/OX8XHyxlc7t7ueaI1N/
	 lP61+MRN4zBiGK9O42ALPFdK1N7Cr5jEb6wskgo1qJAnOwL3dMe2iSuNiJ2MtPEWxZ
	 rwbNFtO1doZmA==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/4] file: simplify and harden cleanup handling
Date: Thu, 17 Sep 2026 11:09:41 +0200
Message-Id: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/0WMywrCMBBFf6XM2oS20Gj8FRGZJBM7KmmZ+ILSf
 zfRhctzuPcskEmYMuybBYSenHlKBbpNA37EdCbFoTD0bW9a223Va5KrinwjFcNpFppRSBEO1ph
 gdmgHKNfiI7+/2cPxx/nhLuTvtVUXDjMpJ5j8WFWt6lrV/6quG1jXDxZPwXekAAAA
X-Change-ID: 20260917-work-file-fd_prepare-ea5966d68a95
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 freedreno@lists.freedesktop.org, linux-media@vger.kernel.org, 
 wine-devel@list.winehq.org, linux-xfs@vger.kernel.org, 
 io-uring@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=2102; i=brauner@kernel.org;
 h=from:subject:message-id; bh=a/nFbwjEIOju3X1MIW/sqlGlbwK5FvdVNYvXKi7Xlgo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStXhfJMm/N0WLv17efbFU+rraYVfylV+3zo4W9JoeUt
 rC+/ezh0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAnCRSYwMi+JkYraZzsnZOaXx
 0UUrBavd6ybar69ZsHjTIzYDdp1D3xgZrrx7/l/ZyezGU4H7pU9+Tpr0xWLmd7ErnyWOROy5EXb
 vHB8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: zq3hwychhenoxod9jacs5wwy1ffrw5sy
X-Rspam-User: 
X-Rspamd-Queue-Id: DBAC440009
X-Rspamd-Server: rspam03
X-HE-Tag: 1789636192-786519
X-HE-Meta: U2FsdGVkX19AXCOxOWzNYt7iXBLyJ0TeUDycKvpOVcgYWSUjj1asPLCGVGpBNPDaBF5ZVW+u512ZsYk13dEiKLj3kdC4czZXp8a0L8mS9pM0dDZH8OrAPIqEhFQw8DAHnjdVYHp2XI3l7dncyeeZNDhCOqdZZzJDqRUwKP254PTrLeHsCNU3IFHZWwUT4bT4QtnsXsX5jX3GeU99IuTk314OCA7cYEq4ehh0oSoSD0jArxxaTuOVOpwx+w1FeCEklwvR9Sxde6H3P+NjNQG7XKdYYsQmrlaJrEuW0oOk90T6QxS4XsKwb/0RxEU4KVo052vdEsdmGWKbVaXIIgXr0KOP/g77lucPbffq5gxJTOi+J2bTo2yQ5k7bRqiaBCyzYKrqAi5lIrRLi9Fb0lktucZ7z8eWVVPHMTho4aRdzTWqKT8+jwZLpKPtk7roTB7FZzIATltkEMzJLmr97tuGWGu19QMSVDwPOh7CzbJ4dOpKR75A4fKgQ0qwHN2yoBMVaIqyBZXZ/zIV64GQaEbLcVdxwM7w50XKjV4wSlsG3fIqAzMHOvBTlSSsW+rs+O9hmVgjXpOtcaOaLCGdosiqKUoUD3vCqgxvgak7f9Ui0SdiekQ7aphpSoEfQUbyQSNNaWH7zIR+b0YRM20MaSctdjr2s286UsAkGese7gK5c2V7gue4OK+QltopUN7X4l9hV/YsHTOPKDH3UdP6UR+v5OdS7xRfHrzm8XE5ZQNL676uQyWsRdUL8aXqTDYjhQ28+s0tJnr91MuRfhpjRxbOLDE8yg4sUTH8Dr/X2pwN+zSPWnEW2JkhbTohInxfF3ingeGvIAwsfspmoOGjhTHQtEpy80t1JqgyGqcUNBMooXjd4uEBRcCmdKGPW/ek7PIHmDV1FU53lknkWE1mwaPxEEpB116ViQ9GhI+na9yDpB1QEzSmBJg3m/R4Rmyoc0r6ANLzgoPQk5nOGnmrqGK
 Pk44lQdq
 oUMtYLiq+IBKaZmXDBeGY8Mnba/aov7YaKokBBmZp4ZTTEVOkQ3MHVjJHko/xgdcPM+bfGUiYcDIE91ZcaQ1Uk85PyxJbusyOq3zW2KkEq3DUTzdniYcpYonhWKVgOTV6vWh0lpc61n3qYFZWFQ1TFsVjaakuCxWmnH3D4Wru8u+hodSTjw5fS5n+B2MjbbUeMsH74XuoPeKwSpG+ZMJxvhBdVxEIL1xUFktVLCP7erzxhgXjO1T+vV/8bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cleanup guards rely on unnecessary infrastructure and make the code
more complicated to follow than it needs to be. Clean it up. Also shrink
the struct a bit and get rid of the unnecessary error variable. We can
just make this more ergonomic by using fdf->fd directly. Also expose the
struct itself as const and hide the actual underlying local variable
behind a UNIQUE_ID() named variable so we avoid risking shadow variables
and polluting callsites. Code generation wise the outcome is exactly the
same but simpler.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (4):
      file: simplify FD_PREPARE()
      file: declare the FD_PREPARE() variable with __cleanup() directly
      cleanup: remove CLASS_INIT()
      file: make struct fd_prepare const and kill its err field

 arch/powerpc/platforms/cell/spufs/inode.c |  12 +--
 drivers/gpio/gpiolib-cdev.c               |  18 ++---
 drivers/gpu/drm/msm/msm_perfcntr.c        |   4 +-
 drivers/media/mc/mc-request.c             |   8 +-
 drivers/misc/ntsync.c                     |   6 +-
 fs/eventfd.c                              |   4 +-
 fs/eventpoll.c                            |   6 +-
 fs/file.c                                 |   8 +-
 fs/namespace.c                            |  12 +--
 fs/nsfs.c                                 |   4 +-
 fs/xfs/xfs_handle.c                       |   6 +-
 include/linux/cleanup.h                   |   7 --
 include/linux/file.h                      | 130 +++++++++++-------------------
 io_uring/mock_file.c                      |   8 +-
 kernel/bpf/bpf_iter.c                     |   6 +-
 kernel/bpf/token.c                        |   6 +-
 mm/userfaultfd.c                          |   6 +-
 net/core/scm.c                            |   8 +-
 net/handshake/netlink.c                   |   8 +-
 net/kcm/kcmsock.c                         |   6 +-
 20 files changed, 117 insertions(+), 156 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260917-work-file-fd_prepare-ea5966d68a95


