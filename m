Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3028FCD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 645CE6B00B2; Thu, 28 May 2026 05:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61D146B00B4; Thu, 28 May 2026 05:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A6A6B00B5; Thu, 28 May 2026 05:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47C2C6B00B2
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:58:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04B5A1A06F6
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:58:12 +0000 (UTC)
X-FDA: 84816378066.25.A6B6507
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id 88C82A0009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:58:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=YUJuo6pz;
	spf=pass (imf25.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779962291; a=rsa-sha256;
	cv=pass;
	b=iigHch5Z8gP65Ry001Rd2GfODe7bZmlz662GRbufv3rGZLzCCVf37jbtmSrRwrXXI5izQB
	yLZWn6gN16zlshDwF1Is8NVgnfJ4qPXNXPkFmDoD5OQZu67+xlq0Z22+lbgJbZ2+lNy8mO
	iJo2FW7gBtkVt/NcxNI4y87QBh4vZQk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=YUJuo6pz;
	spf=pass (imf25.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHFIJ1vwh+H9qkGl5p1gj4xNKLC/W2D7/bdfKg3hdPk=;
	b=wNb9J+ki7MXBDCc5QyLfjjaJKGo74nioFxr9IRpPV4xwKtcDVvKW8+4RfxGdglNhxp/cMb
	cRT4Tnlz8Tcl/zd8fWbEFEpQ3wnqmE5ibw0hD52Bypf/jCg/3cmju5H1+68xmKsRLZHCuR
	vXLGeZJHbvtMWG8M8ipqOQpoy9Ah3Xs=
ARC-Seal: i=1; a=rsa-sha256; t=1779962067; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=dB9yOHSNdn+pWFMuwv0a5OAZPV6rGF6mxWBxJYpmxnEQhcE9PL2qzlDtn+HCW4P572tQZIbnSjl1UThemLDSlHOb1ox6eGvNTl2c30rdT7plQX0/sSxhEynNGE244uzmVMwUwGIUYH+I0SGH+lM+u5tpjxoWeVbb1D1BLn/sFLw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779962067; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=IHFIJ1vwh+H9qkGl5p1gj4xNKLC/W2D7/bdfKg3hdPk=; 
	b=mYzWwm9UB/Ibj317Bb1PC9rRaGISOA2iVqGm0hi+RK+JmoPPQIbXazZ02brt9atvBtr7mcXQkRWqrtiUSXokiG/HC+l1oUn8LBEK9bORfoWQ6/qwCPn0NTi2lKR4hfTze889JeRBdk4JJsTnf1qTswL7XgVnizMzdl5FMmSrGSM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779962067;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=IHFIJ1vwh+H9qkGl5p1gj4xNKLC/W2D7/bdfKg3hdPk=;
	b=YUJuo6pzThKZZRmNDytEoVG8XxhsJEgV2A64AF9QCP+z4KxxS9ZpHYsTi5cgWN+m
	xbowODJ26oN67r27JDk1J0H00zzU65hURcQW+e5i88PENqjWcJCO40KgZkUszKdfKLF
	QCRs14tqi6O2lD4jNAljNciyS8r70RPa3Ie1MejE=
Received: by mx.zohomail.com with SMTPS id 1779962065945647.9310517427938;
	Thu, 28 May 2026 02:54:25 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	x86@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH v1 11/13] exec: let close-range actions target the max fd
Date: Thu, 28 May 2026 17:52:32 +0800
Message-ID: <20260528095235.2491226-12-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
References: <20260528095235.2491226-1-me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 88C82A0009
X-Rspamd-Server: rspam03
X-Stat-Signature: pqyu8d7gy8uy4t7hkiih9oenpbmhpjzj
X-HE-Tag: 1779962289-535275
X-HE-Meta: U2FsdGVkX1/nE3qu6kwvsMfup4UJYDVGSODDwgAfkHTm7T/W5WjKw6fPuRe5/JScG+GHNdVotJE613Mix1paRvPjawsDMe262ECqRM/S09cpElCh9ImbozmyHYW10JVZzeKMQvPgtoLzt6i8hJAAAKtVlWIp3LCNfQO48HddmBm1HDxcQAubO/EjEGFMK3fliw29D91DwIHNFqm/bZTv7ff1jFhgxIrtA3ma85/RHR6TO0Q30lzzSW/KL8oLk/Akz2yXRrZIiDNLnfNPmy4M9z2qtPKdy7jY7qeu8NBzM6z97gTpWckTWQXlsx86e/lopRNNxd84uo4PPUa3DUs031e2isgzFl8Knw4QaQZj6diGttHGl0WwYKjNhrgoIY/TxXJJH9iS4ltCIVG6opBipFlVziSf8Kizhic+jqO/I6NNh0LaPYSnWR57lfi2fJIEiw/drvxDqEcp7vrosSJM5P4s035EzntkQ5gZEoPNt6+0llOsTbdsd49C98dBW30dI+A0qB1jQtYleTxf1yQUrjle/QcbPFF7jIq2Cq8A7he65fqFlmuFoht3Bn4J4urBfo30Ft1KZfJcz+GeZi6xmuYvkHESVuuBvDSr4OvZZdvdAt6SHDvEvVvzsCO0XLjKg5TBUHxWO7jkq63sjyr+nZVvQomsLUhWHmXfxUUwS28Duwl5oNxZVn1gZBTZiJfDv/qLscmJqXkitjY7RXJs/IKQn6ebWfLheNUE+kk0VmaDnTldkOsxqeVSzhn3Jz3inT/dvA06HIhhCNknRY2B0Bh6Chvb54tWkYrEBSH5PkNEbXVvGXOiEvsb2tutA4OTHiO/HSKV7jaqUEvVfv/3VVE5x02VA7doJQrezuSQJVd0/VgxO78wseuWlpbyygO+5ao1iJW/e7ZsFIHQAYcHPH8Xi0CxYeeQxENWFsUNllDUiPjNwQpCiSPtZMqALEWoPCzPf59NIdedJBOet4t
 /Odcc+DU
 wM0NebR7hYcRH++o3O4HIWGs9P+rJT630g2VdARSYiRNNJQVY+zcKNwMOglVzv468BtmVdrj5j181lYT0mTI1Mkjt9wXmCZKD0iCBLKUlM/jJOeIHr4kOJ1OPOC9mPvC28OuKA7roIeEKmQtKCY3wGuT1aXjiC6mBgABxPVriiMI7goRy2Mkn2YeZdSsRZaFNGBdKV6Jb2oahf0TNKshuEe8d+3WuscUbsdnDZY/vL7yzqQI8gCsX0izyd5pxbJYaUWKmzQSuLDIGnGvDvolyOKJnmni0z33UevDfahQU7ZSlbL6tan9jccJeRiDXKsYV0Z2WsYRxzogjMDWLljb3lDYI+rywsgJ/jrDFtwuVGLIT1MJF+JHLiH7eXwJuPGC/R5bKAphVYSUdF3DHfiKdkrasMc5jfe2CjTi6Qj/H1+lOdS1so82bz+aZIEou+Kib/ee1HjW/cPTxB+E+EH5fLZE+bvzuALzrhaJX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow CLOSE_RANGE actions to pass newfd == -1 to mean the largest
possible fd. This gives userspace a compact way to request the common
close_range(first, ~0U, flags) pattern even though the UAPI action uses
signed fd fields so OPEN actions can still carry AT_FDCWD.

Signed-off-by: Li Chen <me@linux.beauty>
---
 Documentation/userspace-api/spawn_template.rst |  3 ++-
 fs/spawn_template.c                            | 10 +++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/userspace-api/spawn_template.rst b/Documentation/userspace-api/spawn_template.rst
index afe215e51db6f..be66be20d4fde 100644
--- a/Documentation/userspace-api/spawn_template.rst
+++ b/Documentation/userspace-api/spawn_template.rst
@@ -86,7 +86,8 @@ kind of setup that ``posix_spawn_file_actions_t`` commonly performs:
   Open a path using ``struct open_how`` and install it at ``newfd``.
 
 ``SPAWN_TEMPLATE_ACTION_CLOSE_RANGE``
-  Apply ``close_range()`` to a child fd range.
+  Apply ``close_range()`` to a child fd range.  Passing ``newfd == -1`` means
+  the range extends to the largest possible fd.
 
 ``SPAWN_TEMPLATE_ACTION_SIGMASK``
   Set the child signal mask.
diff --git a/fs/spawn_template.c b/fs/spawn_template.c
index 6430a6645fb57..82b833bc9865a 100644
--- a/fs/spawn_template.c
+++ b/fs/spawn_template.c
@@ -220,6 +220,8 @@ static int spawn_template_apply_sigdefault(const struct spawn_template_action *a
 
 static int spawn_template_apply_action(const struct spawn_template_action *action)
 {
+	unsigned int max_fd;
+
 	switch (action->type) {
 	case SPAWN_TEMPLATE_ACTION_CLOSE:
 		return close_fd(action->fd);
@@ -251,7 +253,8 @@ static int spawn_template_apply_action(const struct spawn_template_action *actio
 	case SPAWN_TEMPLATE_ACTION_OPEN:
 		return spawn_template_apply_open(action);
 	case SPAWN_TEMPLATE_ACTION_CLOSE_RANGE:
-		return do_close_range(action->fd, action->newfd, action->flags);
+		max_fd = action->newfd == -1 ? ~0U : action->newfd;
+		return do_close_range(action->fd, max_fd, action->flags);
 	case SPAWN_TEMPLATE_ACTION_SIGMASK:
 		return spawn_template_apply_sigmask(action);
 	case SPAWN_TEMPLATE_ACTION_SIGDEFAULT:
@@ -306,8 +309,9 @@ static int spawn_template_copy_actions(struct spawn_template_action **out_action
 				return -EINVAL;
 			break;
 		case SPAWN_TEMPLATE_ACTION_CLOSE_RANGE:
-			if (actions[i].fd < 0 || actions[i].newfd < 0 ||
-			    actions[i].fd > actions[i].newfd ||
+			if (actions[i].fd < 0 || actions[i].newfd < -1 ||
+			    (actions[i].newfd >= 0 &&
+			     actions[i].fd > actions[i].newfd) ||
 			    (actions[i].flags &
 			     ~(CLOSE_RANGE_UNSHARE | CLOSE_RANGE_CLOEXEC)) ||
 			    actions[i].arg)
-- 
2.52.0


