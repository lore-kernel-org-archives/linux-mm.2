Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72B6AC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602116B00AC; Mon,  3 Aug 2026 08:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58C946B00AD; Mon,  3 Aug 2026 08:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D506B00AE; Mon,  3 Aug 2026 08:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 132A16B00AC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:54:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA4B2806BD
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:15:24 +0000 (UTC)
X-FDA: 85059853368.05.9CD4EAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0FA8640008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:15:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iOPUIUfo;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785759323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8slqe05VD33waPBnQilZsaWx6TI48l4eo9pneGvh1dw=;
	b=kDigZRH4UWt1OGWf0Kytp450tlyqNkQDFAONyXmxrPbg1L9d0KvWTc4wKUhgQaG2AC0ccE
	fD3fXKFp68cZ/0b6YoifVchS7b3T3fg7GKbRsQ9giv3MoxgA4gEPERIEHRle14kRzDAfsQ
	pCMGtboqEcr/kTmSyHmKUcZhP7FP/yk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iOPUIUfo;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785759323;
	b=vCIT75+Y4D9KqC6M4SpT4h/P95/1a03K7WPU/tbqUaC62IbFPrtYcBcQcxcRUgJqj2OQVb
	rcn/g/dRZzhRv47FFD7ps9Xy8zllqKRnHgadbzKUm1Js9qOJgz0Fg+1f5uAoq3XBdbO/0i
	UhmjxLyiW8XgGeHueijoYb6BRBECYoI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC08260A78;
	Mon,  3 Aug 2026 12:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015F01F000E9;
	Mon,  3 Aug 2026 12:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785759321;
	bh=8slqe05VD33waPBnQilZsaWx6TI48l4eo9pneGvh1dw=;
	h=From:Subject:Date:To:Cc;
	b=iOPUIUfopJmGLJ/3nXyqIKBxlp5uu9zRpFCHQvutI5ceZ164G0fYWwqErUqt9jd93
	 S1Gkvx/BWw58afYmLRdMjwIafuyGBcP6+A/NcPbntCtmLjM8IXFGHtUlqvQz85d+tG
	 kA00gk8tRzesYyjUPja/sZtL/qL2ycQlNbtKWH+SAJy2BC0N63zyUlOvbeYYZfQ1JF
	 dKxGYk9LOs6XUiBqm/G/qzR6pqV8lR3MwPvPZSNu/rKixKx0/A5lW/M/W2keLRHLYv
	 HgEHxdKYhxJ0zwFxjs8/wKK8+Ylg+Ou/beqoNMSr61n6H0CD4V4+XYH1Du6huZTPcw
	 B/4rI5ekbFf5Q==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/3] binfmt_misc: bound the interpreters an entry can
 pre-open
Date: Mon, 03 Aug 2026 14:14:59 +0200
Message-Id: <20260803-work-binfmt_misc-interplimit-v1-0-4a2435500bd9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEOGcGoC/yWNUQ6CMBAFr0L22yW1JaJexRjTlkVWpZBuRRPC3
 S3yOZOXeTMIRSaBczFDpImFh5BhvyvAdzbcCbnJDFrpgzoqg58hPtFxaPt061k8ckgUxxf3nNC
 cNHlbNVRXGnJijNTy95+/XDeWt3uQT2tzXTgrhC7a4LtVTa1gXZpyO4Bl+QGtCoGBoQAAAA==
X-Change-ID: 20260803-work-binfmt_misc-interplimit-392eca4de742
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com, 
 mail@johnericson.me, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f2f85
X-Developer-Signature: v=1; a=openpgp-sha256; l=2445; i=brauner@kernel.org;
 h=from:subject:message-id; bh=arBQ7R3qh9fuo1bIT/ltszB5Q9NNONeVHQeT13NTzno=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQVtIV52OTOWeD6TM+Cx/9uSoJ68YuUVzeish7Py4oRK
 vxXvfZoRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQeCzP8T/rx2u6Ee4Aw5ym9
 OUpvxG9VS88z0ju0+2S76KSNm6ovH2L4X1mnwfqg2rsokWn3vry47UeV3bl6bH4b9IWfkNj/MHk
 hBwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 0FA8640008
X-Rspam-User: 
X-Stat-Signature: 9hcb6mtxqf3ze4fdzt7euoqz3h3y75wh
X-Rspamd-Server: rspam04
X-HE-Tag: 1785759322-96422
X-HE-Meta: U2FsdGVkX18rSrZgF/gpmqwP4ASxSg7kFrlrT/nJvbc8touzDZexOwtVf1DwNrrV9SSBZPgsU+1suo0yUQldUaEe3b5SJt8AckBudxmpSDJrXRRDfSTQHClo9nfkHAk3ThJ6Qqy6u2mW2oDpc6v9u1jY8fTbh4jqZnx07LGEhlVVVcvWsPg32OEfXxlChrhDXztR6g2fDGbEZ8Q1nJezAXhYxwMuw/MIBt34cJH9RK1pnrEJu7SRT/d3VuTKbSvUDGpjibuyCbZ+CkpbXlvNd0skmsl+vFl9jSWS/JdLf/X4hjZE3yKQPQezf4OPezIATTlLzkwmSQ6fxZP+UkRDW55BUy9FWHqleGFIlZ/+9gSz5kCl5QsvTCuYNwqJFXeDL9StpGogGIgArq5Tp9B0LPSfr4NhA2RBH0SJO143h8pRkgoJAqATp+f2Rq7PaDDWXEKa7zMNgP61mQTujxPU1IrMUxAm8an/3f34OI1YeB3BECXqvRGvHIi7ZCG8km2KZslRNRQ7pcyLWglwkKtOBhTcR2yLytxvBMadyWIj14AmlAisla8lK5reOaWNH8luVGQ2wRgfdA5TRqLyq+OISzB6CDl7rShHVM1K9D/WED3WxQDCbmTg+pU7VX1zU8iEvzuzQcr7EbFRyXX9XNWObFS/WwfwJrGtUFlUFsGPJyl2tM5HaDqIyeehkZ64qxXS4hbiMPt4EX9Lb/Vx3U6VKdhv7o8sB7/N++VoOnBvCHZrBpySWhR1nnwoV6TnvuMjo5IbLfyJVlyBbRWTy9SAWZnob/AlUp8OMVb9ShS/vV2VNc7i3/4VUq22gGkNjRunNVfk8VvinL4rVeOMiptIyrWCchIe6HJciKxuG8uRFlfRO0vwMyFsNSJWmPjAyE6PlDYuFuUbJv3EAtOWQTC/5Rz0ZhfGoVWfAXDSJgZkyR7ACXvo4tS9ZEwQE5T/cPvQuXVOHHn2au8IC1XVfM/
 FADbCq1j
 HfcFe9T+IEQIuEw/wNOosO9DTNTozzYBO/QpddeXyfPM+ljPWBzgrGJAl/4kuTbxUrW/tomUlICmsk8JWYsag8OumafVb1AI03eYKlZS5NisBMpTWSc60wwbnIa2nbq4wtVLFVuNiWJQwuRY/tmHoMIg7iwvsjeS5N4351HmEF0nsmwJINeXs0pe2SG28UF3j3AFtx6gazVjj4XtbIL1eO4XRRTO7Kea863KOUydKxxTeWOP7M66g+cydwaR08TzYs7DlhCFqN3+qlS8hTUK1ftOBjpOD9xFxrf5719qJdP8m/yub6Bv6zzMVEbjwopjy1deKL/88UST81CCxJ5kWfJ89jvClkZGUZNiqNeFOjdJ3NEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An 'F' entry opens its interpreter at registration and every exec runs a
clone of it. A 'B' entry does the same for each interpreter it binds. That
file stays open for as long as the entry lives. So it pins the file, its
inode, the mount it came from and that mount's superblock.

An entry binds at most 100 interpreters, but nothing caps the entries.
binfmt_misc is container mountable so all of this is reachable by
unprivileged users.

While the pins go away when the instance is unmounted, it's still weird
for an unprivileged namespace to be allowed to do this. And the fix is
simple.

Charge each binding to the user namespace and uid that makes it against
a new UCOUNT_BINFMT_MISC_INTERPRETERS and refuse with -ENOSPC when the
limit is hit.

A per-instance cap won't do. Instances are keyed on the user namespace, so
whatever constant I pick gets multiplied by however many namespaces the
caller cares to create. inc_ucount() charges the namespace and every one
of its ancestors, and a namespace can only ever raise its own limit, so
nesting buys nothing.

The knob is /proc/sys/user/max_binfmt_misc_interpreters, per namespace like
every other ucount. I left it at the max_threads/2 default that
fork_init() hands a new ucount type. Nothing anyone runs today comes
anywhere near that.

Selftests for all of it, including that a nested namespace can't buy
itself budget.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (3):
      binfmt_misc: correctly account pre-opened interpreters
      selftests/exec: test the pre-opened interpreter limit
      binfmt_misc: document the pre-opened interpreter limit

 Documentation/admin-guide/binfmt-misc.rst          |  12 +-
 fs/binfmt_misc.c                                   |  16 +-
 include/linux/binfmt_misc.h                        |   3 +
 include/linux/user_namespace.h                     |   3 +
 kernel/ucount.c                                    |   6 +
 tools/testing/selftests/exec/.gitignore            |   1 +
 tools/testing/selftests/exec/Makefile              |   6 +
 tools/testing/selftests/exec/binfmt_misc_bpf.c     |  70 +++++++
 .../selftests/exec/binfmt_misc_interplimit.c       | 232 +++++++++++++++++++++
 9 files changed, 343 insertions(+), 6 deletions(-)
---
base-commit: 7693ae84747b6e72a1a3d14b836f7bec11606e08
change-id: 20260803-work-binfmt_misc-interplimit-392eca4de742


