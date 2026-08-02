Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3152C55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 18:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 834136B007B; Sun,  2 Aug 2026 14:00:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4AA6B0088; Sun,  2 Aug 2026 14:00:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA586B008A; Sun,  2 Aug 2026 14:00:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8F46B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 14:00:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4B2F14053E
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:00:57 +0000 (UTC)
X-FDA: 85057095354.03.4FE83D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 123AE18000B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:00:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hir3URuD;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785693656;
	b=lbXR1B4kgApEfUDPlLIChY/N4Kx93O0hf2vsIgENJagHc1TcwlQh+SnXKVEvqY4/1jxVKo
	6TnzmkPgnYi/84aO1zse4TfqdxAkTdkM93kImFAhodk+/aTewC+Mtf3QdV/XE+EROOREWL
	amFQqovCRc2pxhFc00wKjRnyLN1NCT0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hir3URuD;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785693656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aG5ekkfvn3A//KECMKgZl27slO76I4o4kDAK0PCOpLw=;
	b=DcM35Wdh5/doh5sIZPjoSXT/eM516FoUzxRVBRwoc6u/7hdTDcj7Pq2ewe8oYwDRvOqK4N
	uzLHyt3mutGLj490NnzldgJMR+BchoQRZ1KWoD6eFZsgboGYr3RN7o/MzoYF3ey9i2A5X7
	mz9NMsYGhBZKqkHAz/bTYXAtG0AYnpg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A224411A1;
	Sun,  2 Aug 2026 18:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA071F000E9;
	Sun,  2 Aug 2026 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785693654;
	bh=aG5ekkfvn3A//KECMKgZl27slO76I4o4kDAK0PCOpLw=;
	h=From:Subject:Date:To:Cc;
	b=hir3URuDIttID8b5GJHAXggVkRnfATo9lrEzTpHHqRlEhyX0DQwT/JAE9Opz2z5Hf
	 sOs7KLGhrV7UZS+cmcoHUTrJjiTFFi5aeccZryrOTG1zP0WOAGX/1jCdgvLabOcUi9
	 3Qmt77+PiLlYr7qsqB3Z2FZQtMXmBt0zjUReR9oimQQbIfe03d8Aoj+NtP8J7V9Z0J
	 QXrY9rsbJLJ2qbsZNVRbQ5nTPzs1qXu0l/wUEE6juzjhyWtBi8OylIze2tKKW2S/Ay
	 SFHPgpyuNBWviQFvJ9Nv41P0/qqvq1ilNN0PYN2wTqY4mkNvfxMZ0zcL1t9Of/5tEl
	 Tk0v9VZRjV7/g==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/3] fs: don't warn when a mount is completed from another
 user namespace
Date: Sun, 02 Aug 2026 20:00:42 +0200
Message-Id: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMqFb2oC/yWM2wrCMBAFf6Xssysx3oK/IiKbuLHRkpZd2wql/
 25jH+dwZiZQlsQKl2oC4SFpavMCu00Foab8ZEyPhcEaezLOWBxbeWNMTXPXvmPBkSQjnSM5ezT
 WHfawqJ1wTN9/9npbWXv/4vAprfLwpIxeKIe6TEPU7WrM8w87PpWIlAAAAA==
X-Change-ID: 20260802-work-fill_super-warn-a7fa82502843
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, Laurent Vivier <laurent@vivier.eu>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-f2f85
X-Developer-Signature: v=1; a=openpgp-sha256; l=1667; i=brauner@kernel.org;
 h=from:subject:message-id; bh=yhq9Fu4T1qU5Eg66CKyubI8uMlPD3dDLjZzzlC0UkhM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTlt1761vZrmk3uD7czkz4+dJXV/MDXkKflE//Rz9O51
 16TYX9NRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETCmBkZdoVcDNXWN3jFpjyV
 85zCT98J809OuBeeNatA+5bSzDOhhowM16Pb9obpl8W/W5N94PRz7Xs/RJj/ej7Zlz3rIJe2yOL
 rjAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 123AE18000B
X-Stat-Signature: xhif64u6gd4hg86h7xje3dh3a8bw6sfm
X-Rspam-User: 
X-HE-Tag: 1785693655-386414
X-HE-Meta: U2FsdGVkX19gGs0fherQ9zKeow3f47Kggh9VZsQGoLATtzUWWd+vcvJ/GHb0AbyLBueFvu2jMk/kMXVAFQxq3wn5KhlFUGG7rROrtHJtsY2XzOQyIR33LzUD/kMUmmkFiWR/zk3M0TTE8APbFAgX7ROL5dq5zQbdfRihqJS81BPWGTRS92+IS/ZH40eqv4vI2bJ9oLGpBLaOxom4DFwGRRHPLEWXtqv40i8InK1qaqr/bw65/SPrfW82UT4m1VLcbotHlJd2ZTouOAlvCECFAHGrtCYPt0OMZjNIjiD276PjRWHAFva7j7Pn0UKsXRF19iBsPIB1s0YhNITsxTE1O1laU+qWRspVbs1XFpz1d8JpV0LhXQnzi7InlpxdJf9QUlDGnwcCt8cOnLNeyo52DcMy4j2DwDJkTCkxLB+AUl2G3XFwujLSIaMugS+xZnyhTitO/LdajtauQupXt7JvTHRYpSCwPhPHem/4Y5PmMiLwG6lWIQfIqLnfXYrnX3aGl405IktbZYHgRnhn7DITUAsdACSGgtRlrT/dKeDeoXbF6O4gz2AbATT7EU/KvqjmjPqf/gnnvNui/NFBeh+EVj/pz+W9AcwVXyLYCMUR9tqq94ylXyfsHwk9Ur4/7llMiB4aiB5GvV0LjRabRdyktbC7NtsyJVz+YAGxaGiO/pI+dkf+/7/nMWyvL1TtO9hD9lxMJOj3CJG1AALuoDKgXjtvwlLLSLhtGtOTxNKTqn1u88bUgTR3p+zVTq4LnI1eVpp1i39POyd/TZVJEkMzoHSn4AU9EekCJRjsNd/F2ip1mZ5LhyY8Mf9RtqEQKZqeeVZC6gp6AHtekYVsthEPt7ZLhZZw66u5m8LHdVIgEx+/p8k5HDFQ9xyiPEUMamKIAG9IR/+IvpoeQufzny3WlGmJAxIsD5Mqn3nHv3cOK73u4a5nP9VxU/4Gy5Q5y1sSkgUnSJis2I83Fs5gdPG
 +abK7gA2
 dYuEiJLUXQf1WJB0aFIcTYVqAFu/Fw1dGvWzaSJXta8CG4S0Rx8ihRB/yrAwlrtLrFnPNNn+ez0moneSdExzBmbdNMjkW2zc444sx6JaHZg7P13+Ffcsn9lrislMI2K9nYH7w0Stq8tpdceHDg6x5hqlKPOszZOvZQxBwcY4Uh5nQzUYBZV4Vf/VQu7OCo8zuIhOSpxZx29b0rYU2dnKlxz153DBZJejNPSLiCip1IeJMyDz+VeaI+Smy9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fsopen() records the caller's user namespace in fc->user_ns and hands back
an ordinary file descriptor. The task that calls fsconfig(CMD_CREATE)
doesn't have to be the one that created the context, and mount_capable()
lets it through as long as the caller has CAP_SYS_ADMIN over fc->user_ns,
which anyone in an ancestor namespace does. So fc->user_ns !=
current_user_ns() is something an unprivileged user can arrange.

Both overlayfs and binfmt_misc WARN_ON() that. They're plain WARN_ON()s, so
it can be done in a loop to taint the kernel and flood the log, and it
panics a machine booted with panic_on_warn. Keep refusing the mount, just
stop warning about it. Overlayfs already spells the same check as a plain
error return in ovl_parse_param() for Opt_override_creds.

And add a selftest for both cases.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (3):
      ovl: don't warn when the mount is completed from another user namespace
      binfmt_misc: don't warn when the mount is completed from another user namespace
      selftests/filesystems: test completing a context from another user namespace

 fs/binfmt_misc.c                                   |   3 +-
 fs/overlayfs/super.c                               |   3 +-
 tools/testing/selftests/Makefile                   |   1 +
 .../selftests/filesystems/fscontext_ns/Makefile    |  10 +
 .../filesystems/fscontext_ns/fscontext_ns_test.c   | 239 +++++++++++++++++++++
 5 files changed, 254 insertions(+), 2 deletions(-)
---
base-commit: c679ce3be6cb63763d68ab9b5d9d73ddc0a40762
change-id: 20260802-work-fill_super-warn-a7fa82502843


