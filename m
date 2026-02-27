Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72BBFFEFB5F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988966B0089; Fri, 27 Feb 2026 10:29:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936A06B008A; Fri, 27 Feb 2026 10:29:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80AE16B008C; Fri, 27 Feb 2026 10:29:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 641696B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:29:13 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1D4CBB03F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:29:12 +0000 (UTC)
X-FDA: 84490620144.29.969F47A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7D65E1C0006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:29:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="NG/NPYOd";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hiMBeIfE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BLpE28ZI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KDVNoDij;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772206150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4bxt3l5tiOZrsL/m56OcabS6LLFiteUQfh0DGh/2AE=;
	b=UsMPua7ek3QjxH9iv/JTUu6K2qqzoAeuZ7vbJSwFWy2DJmeDjZ5CKWcuyQ2VUIh21hb7r9
	5BItdeDGaAwWDsdsM4sES3IaU3t72UZ6qbOIpCqc96NjF1XFf5VxP5qEyTWt3W7LtM39WX
	G3+wq/F0vD7VasTkQ72XHabZdJWcIoQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="NG/NPYOd";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hiMBeIfE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BLpE28ZI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KDVNoDij;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772206150; a=rsa-sha256;
	cv=none;
	b=O6mCZQuD6fNzCqT1V01kIJMmYthF1EeWtZ49bUQSw1HlFqDsIIDVeuNTCrwCsIWNaPHEPf
	KP1gJU8GeP+IduNU7+u6C8l0Dy1jKY5P/0xFfPNQz0dUuRNq3tgTkiLmEloZliwTKfHOj4
	fFkjYPtYhxpIIcnH+7S8+mleDbXJBFs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EB6385C065;
	Fri, 27 Feb 2026 15:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772206149; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f4bxt3l5tiOZrsL/m56OcabS6LLFiteUQfh0DGh/2AE=;
	b=NG/NPYOd8sti5Ngt6uil2JzH2VqzG3deAvGiIA+koempgfaMvVH7BPlhbdx+po54+QC+Hg
	TrTlXSRgxEYk/y/KUqHwfjsVL1tkeqpb9JeGNgaz7hvF+d9aFdjjMO0MENBwW25rjqqJHg
	7R/+XuJT0gWN6u9G8EXPny6K5V6Gzkg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772206149;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f4bxt3l5tiOZrsL/m56OcabS6LLFiteUQfh0DGh/2AE=;
	b=hiMBeIfEoOZEkYGhGJW621e8zcNVwd4qknDTETzM4OAJkGE9W0ZweXRdG6UyjetZRQeWSO
	4IUZEV5iQpI8eiDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772206148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f4bxt3l5tiOZrsL/m56OcabS6LLFiteUQfh0DGh/2AE=;
	b=BLpE28ZIv2cyM4AdHPK8JIEoifMwNKNQNsxW+JUoIjOyZAFoyMIWY4Pgyt4pg4XPZRMSrB
	LDG2r/rr5PgSmefxSI6ftpvj4DLa/vfm2dJPMpFIt48gi2/lBi40EQsDK12/OrLuBO2x8g
	7BH4owg5//CXCDk459XH9KlIi7HPxAo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772206148;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f4bxt3l5tiOZrsL/m56OcabS6LLFiteUQfh0DGh/2AE=;
	b=KDVNoDijOnwG++4PBS+lCI0++vOjpCnlq+NU5tmIyL29dHRqetOMGaUAaCgY0ts7ZxFGlZ
	e9N6ry8xJAxPteDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D82803EA69;
	Fri, 27 Feb 2026 15:29:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bSe8NES4oWnHKQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Feb 2026 15:29:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 93FE9A06D4; Fri, 27 Feb 2026 16:29:08 +0100 (CET)
Date: Fri, 27 Feb 2026 16:29:08 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 12/14] selftests/xattr: path-based AF_UNIX socket xattr
 tests
Message-ID: <zvdb5lqvbph3bvt5j2k77voak7xw2snkzntswnnmuv2hjq6zy6@k7bgetuq5zbn>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-12-c2efa4f74cb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216-work-xattr-socket-v1-12-c2efa4f74cb7@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7D65E1C0006
X-Stat-Signature: qjawoxoshxjha8dzkn7mqrn4jtjrg3qt
X-Rspam-User: 
X-HE-Tag: 1772206150-272965
X-HE-Meta: U2FsdGVkX18XZ6HfKkoDIk5VfCt7SeAF2J+a2psWFmLzkdaQEswdKqhOF5K79ZQDQ1Eq46DpBEoWVVL4MmoTPf8Uuepqlp0QJALrmV8U5rDmYuQEElZiF4P7fZNgjp+xYHTizne8frAEHpN5W7X0Bnqc6wDiQZ2JUILv6wfbKmTaIyLw01mELKbcV+7rw8CM4lTz+h7vk5dUPq5bGyt3BkE00OWAuB6QN905uErQtZqkPuFV9XZ9iwe8uWUUrEhyzFoX45bVWBO1GqRFSFqY7XluLJopoHnz+3svjGBpyZEb1zUkyAQ0HFNWV/moVSWlq/3NL/pjLdBEtnDN+5qVT4uq9q9fWXIoq6jl8Vu9O1FHaLtRLo3lQ04wR0paTb4g0pnp4uhdBBasn1P9rCehSS4VXBk803S0vOTjzGzCcgDVspf+y3+gtNRVAXWL8krA5mk2cST/ZWLrW+W/PyYIDKn6hN1RNsaNHWl1ohqbaiYdaRegOnSfvcEUSowLLJwt668tDsHOZGahbM2bjvrCCUEK0ZVBbGCpcVrJO3NvX/RZ8lw3otXmHKf0HpFz60dgt8ag1BYNOrE5IVARU5wKm49SIToHoV9QUJ1pEVezR0yRqtweHDL1VGeAz+22JnyJcFbYAbkwCpg4tr/PF7dU9+RHGxwZcw7FK5mr9ECq6X+zHE3ArA0vSfarS2YzJCNhMGBKArrzoQ6EBUh1/nFU/i5Dcol9pia8I61zsXEZWr5oN29wIAUP1AQ/ftesRSoELZz2ff4m25R5PMXzvzliPGjTsq/AOUvOtAp0QYXyDgOXeyXLr/fX8JeSN7+bbiGJ8K87RHzlRDF53XVpqsaytv0JcQJ585j5ynxZqto2tdcV54GV915M6P8OksKn69UpJZU8u4yGtfEWXWDuGMWPtpFSaS8NkFVk3+jYehoqenZTdbZgmPOZ8W2QZhB+orYNtZ0cbU0D02zLymMpZ5b
 XO1HLHmx
 /3ULzD3ZMnN6YPC/K21ZajgBnSUpfQnQFX9rdr26eW6nJMVbc1nJO/ADuVMvWC05I/HxW8pr/GU0n2iJWf+06d8q7+e1vEZxQZos0pMK62KWnhpsx8hJPd2VHtQQbe1668YSLbGTeAGOBsh4OKzA96iF3Ak1v89MGhdW9FqOuZRkpTp+l2qyoEVRmqkby+YLi964AjrrWV0ygUjPPVIm2+XldLtxdQcuslGIub4JLznOUAQEjEHPLxQwNoKoSr6RH2hrTU5uXcQQ9pNB9HNboaY8VutgvjyUXsJ2LiIdKwdD9GNvhqjLaPGL6r3zP8M4cIoT1NlWwNfG5AZfvUXN6SghPcr4KQC/YTPJqRzwBJ73eueGHqqqeeF7A349ieA2fO/TM9QP54grWHMr1oDg/tr7WvqOYtFCECpQW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 14:32:08, Christian Brauner wrote:
> Test user.* extended attribute operations on path-based Unix domain
> sockets (SOCK_STREAM, SOCK_DGRAM, SOCK_SEQPACKET). Path-based sockets
> are bound to a filesystem path and their inodes live on the underlying
> filesystem (e.g. tmpfs).
> 
> Covers set/get/list/remove, persistence, XATTR_CREATE/XATTR_REPLACE
> flags, empty values, size queries, buffer-too-small errors, O_PATH fd
> operations, and trusted.* xattr handling.
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  .../testing/selftests/filesystems/xattr/.gitignore |   1 +
>  tools/testing/selftests/filesystems/xattr/Makefile |   6 +
>  .../filesystems/xattr/xattr_socket_test.c          | 470 +++++++++++++++++++++
>  3 files changed, 477 insertions(+)
> 
> diff --git a/tools/testing/selftests/filesystems/xattr/.gitignore b/tools/testing/selftests/filesystems/xattr/.gitignore
> new file mode 100644
> index 000000000000..5fd015d2257a
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/xattr/.gitignore
> @@ -0,0 +1 @@
> +xattr_socket_test
> diff --git a/tools/testing/selftests/filesystems/xattr/Makefile b/tools/testing/selftests/filesystems/xattr/Makefile
> new file mode 100644
> index 000000000000..e3d8dca80faa
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/xattr/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +CFLAGS += $(KHDR_INCLUDES)
> +TEST_GEN_PROGS := xattr_socket_test
> +
> +include ../../lib.mk
> diff --git a/tools/testing/selftests/filesystems/xattr/xattr_socket_test.c b/tools/testing/selftests/filesystems/xattr/xattr_socket_test.c
> new file mode 100644
> index 000000000000..fac0a4c6bc05
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/xattr/xattr_socket_test.c
> @@ -0,0 +1,470 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2026 Christian Brauner <brauner@kernel.org>
> +/*
> + * Test extended attributes on path-based Unix domain sockets.
> + *
> + * Path-based Unix domain sockets are bound to a filesystem path and their
> + * inodes live on the underlying filesystem (e.g. tmpfs). These tests verify
> + * that user.* and trusted.* xattr operations work correctly on them using
> + * path-based syscalls (setxattr, getxattr, etc.).
> + *
> + * Covers SOCK_STREAM, SOCK_DGRAM, and SOCK_SEQPACKET socket types.
> + */
> +
> +#define _GNU_SOURCE
> +#include <errno.h>
> +#include <limits.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/socket.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <sys/un.h>
> +#include <sys/xattr.h>
> +#include <unistd.h>
> +
> +#include "../../kselftest_harness.h"
> +
> +#define TEST_XATTR_NAME		"user.testattr"
> +#define TEST_XATTR_VALUE	"testvalue"
> +#define TEST_XATTR_VALUE2	"newvalue"
> +
> +/*
> + * Fixture for path-based Unix domain socket tests.
> + * Creates a SOCK_STREAM socket bound to a path in /tmp (typically tmpfs).
> + */
> +FIXTURE(xattr_socket)
> +{
> +	char socket_path[PATH_MAX];
> +	int sockfd;
> +};
> +
> +FIXTURE_VARIANT(xattr_socket)
> +{
> +	int sock_type;
> +	const char *name;
> +};
> +
> +FIXTURE_VARIANT_ADD(xattr_socket, stream) {
> +	.sock_type = SOCK_STREAM,
> +	.name = "stream",
> +};
> +
> +FIXTURE_VARIANT_ADD(xattr_socket, dgram) {
> +	.sock_type = SOCK_DGRAM,
> +	.name = "dgram",
> +};
> +
> +FIXTURE_VARIANT_ADD(xattr_socket, seqpacket) {
> +	.sock_type = SOCK_SEQPACKET,
> +	.name = "seqpacket",
> +};
> +
> +FIXTURE_SETUP(xattr_socket)
> +{
> +	struct sockaddr_un addr;
> +	int ret;
> +
> +	self->sockfd = -1;
> +
> +	snprintf(self->socket_path, sizeof(self->socket_path),
> +		 "/tmp/xattr_socket_test_%s.%d", variant->name, getpid());
> +	unlink(self->socket_path);
> +
> +	self->sockfd = socket(AF_UNIX, variant->sock_type, 0);
> +	ASSERT_GE(self->sockfd, 0) {
> +		TH_LOG("Failed to create socket: %s", strerror(errno));
> +	}
> +
> +	memset(&addr, 0, sizeof(addr));
> +	addr.sun_family = AF_UNIX;
> +	strncpy(addr.sun_path, self->socket_path, sizeof(addr.sun_path) - 1);
> +
> +	ret = bind(self->sockfd, (struct sockaddr *)&addr, sizeof(addr));
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("Failed to bind socket to %s: %s",
> +		       self->socket_path, strerror(errno));
> +	}
> +}
> +
> +FIXTURE_TEARDOWN(xattr_socket)
> +{
> +	if (self->sockfd >= 0)
> +		close(self->sockfd);
> +	unlink(self->socket_path);
> +}
> +
> +TEST_F(xattr_socket, set_user_xattr)
> +{
> +	int ret;
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
> +		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("setxattr failed: %s (errno=%d)", strerror(errno), errno);
> +	}
> +}
> +
> +TEST_F(xattr_socket, get_user_xattr)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
> +		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("setxattr failed: %s", strerror(errno));
> +	}
> +
> +	memset(buf, 0, sizeof(buf));
> +	ret = getxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE)) {
> +		TH_LOG("getxattr returned %zd, expected %zu: %s",
> +		       ret, strlen(TEST_XATTR_VALUE), strerror(errno));
> +	}
> +	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
> +}
> +
> +TEST_F(xattr_socket, list_user_xattr)
> +{
> +	char list[1024];
> +	ssize_t ret;
> +	bool found = false;
> +	char *ptr;
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
> +		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("setxattr failed: %s", strerror(errno));
> +	}
> +
> +	memset(list, 0, sizeof(list));
> +	ret = listxattr(self->socket_path, list, sizeof(list));
> +	ASSERT_GT(ret, 0) {
> +		TH_LOG("listxattr failed: %s", strerror(errno));
> +	}
> +
> +	for (ptr = list; ptr < list + ret; ptr += strlen(ptr) + 1) {
> +		if (strcmp(ptr, TEST_XATTR_NAME) == 0) {
> +			found = true;
> +			break;
> +		}
> +	}
> +	ASSERT_TRUE(found) {
> +		TH_LOG("xattr %s not found in list", TEST_XATTR_NAME);
> +	}
> +}
> +
> +TEST_F(xattr_socket, remove_user_xattr)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
> +		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("setxattr failed: %s", strerror(errno));
> +	}
> +
> +	ret = removexattr(self->socket_path, TEST_XATTR_NAME);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("removexattr failed: %s", strerror(errno));
> +	}
> +
> +	ret = getxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ENODATA) {
> +		TH_LOG("Expected ENODATA, got %s", strerror(errno));
> +	}
> +}
> +
> +/*
> + * Test that xattrs persist across socket close and reopen.
> + * The xattr is on the filesystem inode, not the socket fd.
> + */
> +TEST_F(xattr_socket, xattr_persistence)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
> +		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("setxattr failed: %s", strerror(errno));
> +	}
> +
> +	close(self->sockfd);
> +	self->sockfd = -1;
> +
> +	memset(buf, 0, sizeof(buf));
> +	ret = getxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE)) {
> +		TH_LOG("getxattr after close failed: %s", strerror(errno));
> +	}
> +	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
> +}
> +
> +TEST_F(xattr_socket, update_user_xattr)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
> +		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
> +		       TEST_XATTR_VALUE2, strlen(TEST_XATTR_VALUE2), 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	memset(buf, 0, sizeof(buf));
> +	ret = getxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE2));
> +	ASSERT_STREQ(buf, TEST_XATTR_VALUE2);
> +}
> +
> +TEST_F(xattr_socket, xattr_create_flag)
> +{
> +	int ret;
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
> +		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
> +		       TEST_XATTR_VALUE2, strlen(TEST_XATTR_VALUE2), XATTR_CREATE);
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, EEXIST);
> +}
> +
> +TEST_F(xattr_socket, xattr_replace_flag)
> +{
> +	int ret;
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
> +		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), XATTR_REPLACE);
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ENODATA);
> +}
> +
> +TEST_F(xattr_socket, multiple_xattrs)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +	int i;
> +	char name[64], value[64];
> +	const int num_xattrs = 5;
> +
> +	for (i = 0; i < num_xattrs; i++) {
> +		snprintf(name, sizeof(name), "user.test%d", i);
> +		snprintf(value, sizeof(value), "value%d", i);
> +		ret = setxattr(self->socket_path, name, value, strlen(value), 0);
> +		ASSERT_EQ(ret, 0) {
> +			TH_LOG("setxattr %s failed: %s", name, strerror(errno));
> +		}
> +	}
> +
> +	for (i = 0; i < num_xattrs; i++) {
> +		snprintf(name, sizeof(name), "user.test%d", i);
> +		snprintf(value, sizeof(value), "value%d", i);
> +		memset(buf, 0, sizeof(buf));
> +		ret = getxattr(self->socket_path, name, buf, sizeof(buf));
> +		ASSERT_EQ(ret, (ssize_t)strlen(value));
> +		ASSERT_STREQ(buf, value);
> +	}
> +}
> +
> +TEST_F(xattr_socket, xattr_empty_value)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME, "", 0, 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	ret = getxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, 0);
> +}
> +
> +TEST_F(xattr_socket, xattr_get_size)
> +{
> +	ssize_t ret;
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
> +		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	ret = getxattr(self->socket_path, TEST_XATTR_NAME, NULL, 0);
> +	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE));
> +}
> +
> +TEST_F(xattr_socket, xattr_buffer_too_small)
> +{
> +	char buf[2];
> +	ssize_t ret;
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
> +		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	ret = getxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ERANGE);
> +}
> +
> +TEST_F(xattr_socket, xattr_nonexistent)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +
> +	ret = getxattr(self->socket_path, "user.nonexistent", buf, sizeof(buf));
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ENODATA);
> +}
> +
> +TEST_F(xattr_socket, remove_nonexistent_xattr)
> +{
> +	int ret;
> +
> +	ret = removexattr(self->socket_path, "user.nonexistent");
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ENODATA);
> +}
> +
> +TEST_F(xattr_socket, large_xattr_value)
> +{
> +	char large_value[4096];
> +	char read_buf[4096];
> +	ssize_t ret;
> +
> +	memset(large_value, 'A', sizeof(large_value));
> +
> +	ret = setxattr(self->socket_path, TEST_XATTR_NAME,
> +		       large_value, sizeof(large_value), 0);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("setxattr with large value failed: %s", strerror(errno));
> +	}
> +
> +	memset(read_buf, 0, sizeof(read_buf));
> +	ret = getxattr(self->socket_path, TEST_XATTR_NAME,
> +		       read_buf, sizeof(read_buf));
> +	ASSERT_EQ(ret, (ssize_t)sizeof(large_value));
> +	ASSERT_EQ(memcmp(large_value, read_buf, sizeof(large_value)), 0);
> +}
> +
> +/*
> + * Test lsetxattr/lgetxattr (don't follow symlinks).
> + * Socket files aren't symlinks, so this should work the same.
> + */
> +TEST_F(xattr_socket, lsetxattr_lgetxattr)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +
> +	ret = lsetxattr(self->socket_path, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("lsetxattr failed: %s", strerror(errno));
> +	}
> +
> +	memset(buf, 0, sizeof(buf));
> +	ret = lgetxattr(self->socket_path, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE));
> +	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
> +}
> +
> +/*
> + * Fixture for trusted.* xattr tests.
> + * These require CAP_SYS_ADMIN.
> + */
> +FIXTURE(xattr_socket_trusted)
> +{
> +	char socket_path[PATH_MAX];
> +	int sockfd;
> +};
> +
> +FIXTURE_VARIANT(xattr_socket_trusted)
> +{
> +	int sock_type;
> +	const char *name;
> +};
> +
> +FIXTURE_VARIANT_ADD(xattr_socket_trusted, stream) {
> +	.sock_type = SOCK_STREAM,
> +	.name = "stream",
> +};
> +
> +FIXTURE_VARIANT_ADD(xattr_socket_trusted, dgram) {
> +	.sock_type = SOCK_DGRAM,
> +	.name = "dgram",
> +};
> +
> +FIXTURE_VARIANT_ADD(xattr_socket_trusted, seqpacket) {
> +	.sock_type = SOCK_SEQPACKET,
> +	.name = "seqpacket",
> +};
> +
> +FIXTURE_SETUP(xattr_socket_trusted)
> +{
> +	struct sockaddr_un addr;
> +	int ret;
> +
> +	self->sockfd = -1;
> +
> +	snprintf(self->socket_path, sizeof(self->socket_path),
> +		 "/tmp/xattr_socket_trusted_%s.%d", variant->name, getpid());
> +	unlink(self->socket_path);
> +
> +	self->sockfd = socket(AF_UNIX, variant->sock_type, 0);
> +	ASSERT_GE(self->sockfd, 0);
> +
> +	memset(&addr, 0, sizeof(addr));
> +	addr.sun_family = AF_UNIX;
> +	strncpy(addr.sun_path, self->socket_path, sizeof(addr.sun_path) - 1);
> +
> +	ret = bind(self->sockfd, (struct sockaddr *)&addr, sizeof(addr));
> +	ASSERT_EQ(ret, 0);
> +}
> +
> +FIXTURE_TEARDOWN(xattr_socket_trusted)
> +{
> +	if (self->sockfd >= 0)
> +		close(self->sockfd);
> +	unlink(self->socket_path);
> +}
> +
> +TEST_F(xattr_socket_trusted, set_trusted_xattr)
> +{
> +	char buf[256];
> +	ssize_t len;
> +	int ret;
> +
> +	ret = setxattr(self->socket_path, "trusted.testattr",
> +		       TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	if (ret == -1 && errno == EPERM)
> +		SKIP(return, "Need CAP_SYS_ADMIN for trusted.* xattrs");
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("setxattr trusted.testattr failed: %s", strerror(errno));
> +	}
> +
> +	memset(buf, 0, sizeof(buf));
> +	len = getxattr(self->socket_path, "trusted.testattr",
> +		       buf, sizeof(buf));
> +	ASSERT_EQ(len, (ssize_t)strlen(TEST_XATTR_VALUE));
> +	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
> +}
> +
> +TEST_F(xattr_socket_trusted, get_trusted_xattr_unprivileged)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +
> +	ret = getxattr(self->socket_path, "trusted.testattr", buf, sizeof(buf));
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_TRUE(errno == ENODATA || errno == EPERM) {
> +		TH_LOG("Expected ENODATA or EPERM, got %s", strerror(errno));
> +	}
> +}
> +
> +TEST_HARNESS_MAIN
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

