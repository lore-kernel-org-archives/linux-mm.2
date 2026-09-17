Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29CD7C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 183DB6B0098; Thu, 17 Sep 2026 05:10:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F956B0099; Thu, 17 Sep 2026 05:10:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3B16B009B; Thu, 17 Sep 2026 05:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA8036B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:10:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3AA51120281
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:10:08 +0000 (UTC)
X-FDA: 85222682496.10.A55F8DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7F866160004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:10:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gB/wFH2C";
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dWahTpadJ8SVAXJFFy0YTTM47N8xZaWr7TRB490RZI=;
	b=vXGXU5LTA+JmWMj/sKI4Ta4olQXf4z5AwM63OtSEESM0roI4lEkIAfFO/SxKwBcWtvL6Rn
	+ONGl8qXeZxmPtL8HkFElJk4cPzubMdJg3ZnSw24yExe6/LreqMMBjr0qrkJG9YbWlLvxb
	LjH0DxuF6t/8y86Pr9r8ZQt7K5BUqiM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636206;
	b=FW552QgOtWh0o2Wf61fQFuzqLMRORj5mBh+pHhKnQcL3VC4fxTCcAti+FJo+Vy3ACc2pMc
	PswoY1X/mDuUJxhBQZ6NktlsXa/z7XuO531EphtoK3YH04AiWo14P3ksBt+dy6TXskAevW
	IcvriN88CnenUgMLBLfG4koLfBSjKt0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gB/wFH2C";
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1876360231;
	Thu, 17 Sep 2026 09:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D271F00893;
	Thu, 17 Sep 2026 09:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636205;
	bh=6dWahTpadJ8SVAXJFFy0YTTM47N8xZaWr7TRB490RZI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gB/wFH2CZNIyTyzKz6rMZb09+PgNTjUmU9H+6Eu6QBXgv+KymxIPpgYbmkzflAQrU
	 333+7mJ3A2kMGLT23ZySfOlzw7hqX2G8T9dO6f/Qu32WgqkH066+pbE6q3csCBOJhn
	 hVwJvSqenhZsWVto4JK5LUDNWiDFgSRr4SPiFoiBdYSNOulqmHCvK17qzpVrUB9knh
	 DwxjmfSuTDS9Rvyi1IKr+fRBTuThlHhHi2c3yTEEnl8wU779+BxDljLnOBC063luH/
	 Qeu0whojY0FqyPpX+sBJ7x4WXtUCJ8RhJj4+xD+LK3aPYwpIvuZYf2EKHwPsuXaN/1
	 6baEMzbhlX7jA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 17 Sep 2026 11:09:44 +0200
Subject: [PATCH 3/4] cleanup: remove CLASS_INIT()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-work-file-fd_prepare-v1-3-b87534ca49f3@kernel.org>
References: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
In-Reply-To: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1527; i=brauner@kernel.org;
 h=from:subject:message-id; bh=gePQjgNJP3rZLgjxZMbNcyCVB0rhSfWKtw7rWIMHsCU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStXhcptiHRLFxir8hFQ7cX4T8XKIlF/9FhyhR+65ynl
 qu6Wcqno5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJzVzD8lWq5Gco9c839ZU7p
 jdrmawS83i4NPfWqOvxHVrbIx6usagz/LFur6m/9XDa34GfizllL3I9kJfeIcS3yyg6IPH70c+Z
 CfgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: sprq8o8w5tmr9d6ec531ggt8si4abira
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F866160004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789636206-891175
X-HE-Meta: U2FsdGVkX1/MJGzuOvOgU9oC2ox3rZ1ehI2Lo9zStIUB/1h20vCoIyRQ75lqcK4cLgIVwSj67P5zI/mMXVpeFedk2yxos/LJUOksun4E4+4Zc98tkvgFj47ygqz+NC2ql5bwZINSsc3afvC1tiwom9E+Xc1wBvlWDaBG8r0Gr6VmeIQO4fSaNXw0Qjtylc1ay/SDBfsOtkWidr6lfnnFe1NiCeHMb1tYwfhCmk1G5bgXGa0CHceMRLgDpsKZJLzpWpF8bGKo9hGVfz1/GkdYnGWr7xz2+nHUBPcM93ReJpxLnKR0zskkZvS8KGCBZ5Xi1yKqsa5UCvJg5GzQtJyLRks1/f4zq0q9bHd+3O21NCIEzSe4b1GWt7Zg0LBXVXlYCDslIdLIk5WYCsUE2HNtWPwuVp9Wu3/8mUASYOGOpUd3+iNfc8t9YREw4BTPn52dKztcilvNVcjyLMZyJT+JiYSE7S2KT4+TSSV0xXvzw/p0tif6uucwEZqKdTNQedihAdMTXvkfqsoRzgaXKbVbKfB+1vpEz3LYpQs6vG3bmZvr1xpQ8pJkN+5wzlRzLAEthUCogJYUJWZepN6lXGgJpxPu+gJCqjCpHkF2A8AM6EuJxITJvFPjCW9KBdSiICEOrYkufJs//s/P+sh65Vynqr6Nyn2eqX8xNLmfWVnigtFb/K70HwLKynCJ1Nrn5psFEEoeKdwQLYbi/LQw4bGpxJJAIG2L0pi7iLFs31hReZAkHTmzGKQhlFOdXK0bS9BY0COiuDCMOWYIm58ZVnRTSSeq9OhyswFK+NZJYNAxnRmtb8J4PPGfhjOvR3lIBTU6dRcM4V/or+zvpPTi/VszsaQdwR6YodgQAoyNra8f0fElvDaL1oNdSmQre5VP3arYQJFB0j6v+IgUR/mkZzhGHeXaSEjz68DtvfIrd+D7ZIID1qqDUzrY6plDITHP2XP/fyO6NitZw/noA9Sx78B
 VI9L+uqu
 YfC6hJuih+xtgj21b89lZzuvK9uwoqmcdDcmHQBW2EkfiC3XJY7I7LATKjhOdzX44jG0QX+rRkFulin4cPzHwv5I1n7aN8/HE0fzc4bRGsB7IhKO+l/B2EPI2+yavatKMLxTrBKqL9HDdxre2lrhqfMqFwrlRNvwAoo3rEejxaPO/S6ZeItcWl2gH5nrpL1KmpfYbyg+NF8OL8UehQuiNnQUo16MoohJFWvgaMknqpctpKVgXZyCLjedTmP3Br6V7dDpGD2Sgd9CgxXQoOLk+nyThq4Gdd/iDdHtU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CLASS_INIT() was added for FD_PREPARE() in commit 011703a9acd7 ("file:
add FD_{ADD,PREPARE}()") and never got another user. FD_PREPARE() now
declares its variable with __cleanup() directly. Remove CLASS_INIT().

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/cleanup.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index b1b5698cbf1b..1fb8058b897d 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -261,10 +261,6 @@ const volatile void * __must_check_fn(const volatile void *val)
  * CLASS(name, var)(args...):
  *	declare the variable @var as an instance of the named class
  *
- * CLASS_INIT(name, var, init_expr):
- *	declare the variable @var as an instance of the named class with
- *	custom initialization expression.
- *
  * Ex.
  *
  * DEFINE_CLASS(fdget, struct fd, fdput(_T), fdget(fd), int fd)
@@ -302,9 +298,6 @@ static __always_inline class_##_name##_t class_##_name##ext##_constructor(_init_
 	class_##_name##_t var __cleanup(class_##_name##_destructor) =	\
 		class_##_name##_constructor
 
-#define CLASS_INIT(_name, _var, _init_expr)                             \
-        class_##_name##_t _var __cleanup(class_##_name##_destructor) = (_init_expr)
-
 #define __scoped_class(_name, var, _label, args...)        \
 	for (CLASS(_name, var)(args); ; ({ goto _label; })) \
 		if (0) {                                   \

-- 
2.53.0


