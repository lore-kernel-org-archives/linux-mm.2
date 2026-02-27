Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D85FEFB5E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5F66B0088; Fri, 27 Feb 2026 10:32:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566E16B0093; Fri, 27 Feb 2026 10:32:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4523E6B0096; Fri, 27 Feb 2026 10:32:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30E8D6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:32:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0FDABAA41
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:32:26 +0000 (UTC)
X-FDA: 84490628292.20.BBB6577
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5BE7680016
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:32:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=abdOL05C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=puBOlULr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=abdOL05C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=puBOlULr;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772206344; a=rsa-sha256;
	cv=none;
	b=gF2bpeywzun/RfBlR/3HVl7os9E161eq9m5AnNMydGS/ZdVariV7qS+uc/jEG90s9+7Ceb
	xLWqU6oOeDEdyz1PHRI9KH6Q6LutqcpiEZgx0zWgtCDfF1O/s95ol5hcN/znQjNASk0liI
	hpkdWyx+ddbwBF1ca9Mn+/BdscAXi4s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=abdOL05C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=puBOlULr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=abdOL05C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=puBOlULr;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772206344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aiCgKQVi3dUFiUibT/uh6m3Uz8Bs/xGtX9sK7unl3iI=;
	b=ty+WXhicFqRBQstNcn1X2N5o3+uOta6sr9jyfH3W3PvbEjVib6cp0PM3JVvd3k83V3BxwW
	LZsx3rKtm6jIi09p2MoPON9yjyj8xlbBe2fKM5F56kIhD9ccmhezADHMMXcluVoSom4mxc
	jaFFMh9kzcqb2kA9plGmoFAqOqSelCI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C54144016E;
	Fri, 27 Feb 2026 15:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772206342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aiCgKQVi3dUFiUibT/uh6m3Uz8Bs/xGtX9sK7unl3iI=;
	b=abdOL05COYb01PZO0mHWmJDigRktpsMjCGPhXhge9tkF1pIDAsu+tmVq2NbNG2/h/EAT0U
	0/kRh1F4QbIY1w36hy5AK/L6oX/dB6PzWunuvoarz4Ve1cX+0IY38Y94DM9EamO0MFtuND
	R72mX13U4xmsKWgojmrpb2kQo2dBQ08=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772206342;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aiCgKQVi3dUFiUibT/uh6m3Uz8Bs/xGtX9sK7unl3iI=;
	b=puBOlULrNvGzbYBWZU2AHhuAxNfQamn9MPCpldggVQNZiA+Za0kavZotm1JbndBnpyFYXp
	xRw2ucJvgjinMUBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772206342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aiCgKQVi3dUFiUibT/uh6m3Uz8Bs/xGtX9sK7unl3iI=;
	b=abdOL05COYb01PZO0mHWmJDigRktpsMjCGPhXhge9tkF1pIDAsu+tmVq2NbNG2/h/EAT0U
	0/kRh1F4QbIY1w36hy5AK/L6oX/dB6PzWunuvoarz4Ve1cX+0IY38Y94DM9EamO0MFtuND
	R72mX13U4xmsKWgojmrpb2kQo2dBQ08=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772206342;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aiCgKQVi3dUFiUibT/uh6m3Uz8Bs/xGtX9sK7unl3iI=;
	b=puBOlULrNvGzbYBWZU2AHhuAxNfQamn9MPCpldggVQNZiA+Za0kavZotm1JbndBnpyFYXp
	xRw2ucJvgjinMUBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B6D2F3EA69;
	Fri, 27 Feb 2026 15:32:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fKmhLAa5oWk2LQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Feb 2026 15:32:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 75DF6A06D4; Fri, 27 Feb 2026 16:32:22 +0100 (CET)
Date: Fri, 27 Feb 2026 16:32:22 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 14/14] selftests/xattr: test xattrs on various socket
 families
Message-ID: <i2pa5ov2voy23ap5vwbtl7ollwiw2jri2nzroethcqn4nnetrr@u2azc3pfi4qs>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-14-c2efa4f74cb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216-work-xattr-socket-v1-14-c2efa4f74cb7@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5BE7680016
X-Stat-Signature: 1bam4z18d6kp4xfe5mjtxjtuq41yiyru
X-HE-Tag: 1772206344-188986
X-HE-Meta: U2FsdGVkX1/60s+bHCtMBg8AR1El5fj+Wsb7A3cB3KLxcZqHErcoqDGSy/9ujkQWBOkZT2duzbBMsEaXDXcgU4QB3tM3QlqcLbrVbxKj/x34JxgUjq63LOATJ4yfIj5rLaD5tM3oZaYsbrqrC2uF5FYYhCGpF4XGnLYdjSWnPuL0OuEXHMqOv7HrNdlXbQqM5jcDoY8c3lVzEeUNlT6qkyYlvDIEG67bh58LbAlOjnGJ/bdJ1Cr/D0HVfPNNBKc0C5ZYQKZwiLRV7Fe595pX1arI7LVH+YgeXfeSJGjvW7anQjmzi1HPQWatakGspqsufmYtJERfY8CeZr8J+pMnfl+eBtzhPH8GkWqdc3MAvhlWVqTAd9XXO0nKcTY2QuAf6pV9oFu/y68tJdyTnzJTAIimamiKQiLxjxntEfed8SgfYCs/jawlOh8dOQxQChjUxMRlqZN2HCf2KS0jnTbIU20N3k0uysGze+yK4aMNY+L+LmZFpzn5HqetOQB0BE57ifsjBFPyhUAbMycDZyB/EYGgNfJKdtrAgOy+2sJJmP1sXHHEgm1vWtjXwAQXuhIUAE7OyEqf7/PaemnNO08vcmfZ5ox8wVKuzz5Itg1rqh/111NAP5Bp3Jl/2QE6fUHbYkOmB3n6BcSV3xn/DcXFvCSBeu9cImGlJVcL6nvLSgmmJ23HiNbk4XfoJeSX22At8kM27b+E24EgelmKPGqVniJlSI4QyCtXAYI/AQ785y4w5IzI0vwAon6eRpG+dV1App0eZueMMzFx5aMLPFTWRuxI++LTfbOeWruZR9qV6uvCvIwM5oAYHDa3iJq3TtsNdijSAvsDFNEmIAvhnHGudxKppBeZAR3s6rZpu9mSeObMiWph3EqeT+HdJNL155+FcflYGBVL5hbm8i7xOVYgDZ1+m+0i0ZgUn1n8NV1sj6cu5th1wKoFDmt7bIeNj2X1oSsORLGqNd8aHbZGViB
 a9SKyhEK
 dBF+FtZruHuObT4cfznlbLV12sBOX8LCKv6eNaLV3MLO2VU0Z8/77O2tSO4b66TU169CAVH2qIQzC6sKHArKWsTgVJTDhYGn53flg0HE5SY185Vji4qP1JYI6/QLKetu8fjiodxbQY2+aLW0YPANZBfv1ZucEZvMafOJcMMY6M4p/mQHo4Gk/3onV6/Iq0G/rIE/nMW8jVa4KBf6E6O/uwapfClNT/a0Vr4dWcRm10K8MLP3CZxv+HSFhuz0O03bnxq4xurmHyh4xwVA/LZx3OPlzvZDgms5TE52AKD7EBDuC4nW3HSRSFtr84ojHuUwoJfyzTsMr0Aj5OmHrUvHs4p8PCOTBcUB8zpT5Pru/dBOPxMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 14:32:10, Christian Brauner wrote:
> Test user.* xattr operations on sockets from different address families:
> AF_INET, AF_INET6, AF_NETLINK, and AF_PACKET. All socket types use
> sockfs for their inodes, so user.* xattrs should work regardless of
> address family.
> 
> Each fixture creates a socket (no bind needed) and verifies the full
> fsetxattr/fgetxattr/flistxattr/fremovexattr cycle. AF_INET6 skips if
> not supported; AF_PACKET skips if CAP_NET_RAW is unavailable.
> 
> Also tests abstract namespace AF_UNIX sockets, which live in sockfs
> (not on a filesystem) and should support user.* xattrs.
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  .../testing/selftests/filesystems/xattr/.gitignore |   1 +
>  tools/testing/selftests/filesystems/xattr/Makefile |   2 +-
>  .../filesystems/xattr/xattr_socket_types_test.c    | 177 +++++++++++++++++++++
>  3 files changed, 179 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/filesystems/xattr/.gitignore b/tools/testing/selftests/filesystems/xattr/.gitignore
> index 00a59c89efab..092d14094c0f 100644
> --- a/tools/testing/selftests/filesystems/xattr/.gitignore
> +++ b/tools/testing/selftests/filesystems/xattr/.gitignore
> @@ -1,2 +1,3 @@
>  xattr_socket_test
>  xattr_sockfs_test
> +xattr_socket_types_test
> diff --git a/tools/testing/selftests/filesystems/xattr/Makefile b/tools/testing/selftests/filesystems/xattr/Makefile
> index 2cd722dba47b..95364ffb10e9 100644
> --- a/tools/testing/selftests/filesystems/xattr/Makefile
> +++ b/tools/testing/selftests/filesystems/xattr/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  
>  CFLAGS += $(KHDR_INCLUDES)
> -TEST_GEN_PROGS := xattr_socket_test xattr_sockfs_test
> +TEST_GEN_PROGS := xattr_socket_test xattr_sockfs_test xattr_socket_types_test
>  
>  include ../../lib.mk
> diff --git a/tools/testing/selftests/filesystems/xattr/xattr_socket_types_test.c b/tools/testing/selftests/filesystems/xattr/xattr_socket_types_test.c
> new file mode 100644
> index 000000000000..bfabe91b2ed1
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/xattr/xattr_socket_types_test.c
> @@ -0,0 +1,177 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2026 Christian Brauner <brauner@kernel.org>
> +/*
> + * Test user.* xattrs on various socket families.
> + *
> + * All socket types use sockfs for their inodes, so user.* xattrs should
> + * work on any socket regardless of address family. This tests AF_INET,
> + * AF_INET6, AF_NETLINK, AF_PACKET, and abstract namespace AF_UNIX sockets.
> + */
> +
> +#define _GNU_SOURCE
> +#include <errno.h>
> +#include <stddef.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/socket.h>
> +#include <sys/types.h>
> +#include <sys/un.h>
> +#include <sys/xattr.h>
> +#include <linux/netlink.h>
> +#include <unistd.h>
> +
> +#include "../../kselftest_harness.h"
> +
> +#define TEST_XATTR_NAME		"user.testattr"
> +#define TEST_XATTR_VALUE	"testvalue"
> +
> +FIXTURE(xattr_socket_types)
> +{
> +	int sockfd;
> +};
> +
> +FIXTURE_VARIANT(xattr_socket_types)
> +{
> +	int family;
> +	int type;
> +	int protocol;
> +};
> +
> +FIXTURE_VARIANT_ADD(xattr_socket_types, inet) {
> +	.family = AF_INET,
> +	.type = SOCK_STREAM,
> +	.protocol = 0,
> +};
> +
> +FIXTURE_VARIANT_ADD(xattr_socket_types, inet6) {
> +	.family = AF_INET6,
> +	.type = SOCK_STREAM,
> +	.protocol = 0,
> +};
> +
> +FIXTURE_VARIANT_ADD(xattr_socket_types, netlink) {
> +	.family = AF_NETLINK,
> +	.type = SOCK_RAW,
> +	.protocol = NETLINK_USERSOCK,
> +};
> +
> +FIXTURE_VARIANT_ADD(xattr_socket_types, packet) {
> +	.family = AF_PACKET,
> +	.type = SOCK_DGRAM,
> +	.protocol = 0,
> +};
> +
> +FIXTURE_SETUP(xattr_socket_types)
> +{
> +	self->sockfd = socket(variant->family, variant->type,
> +			      variant->protocol);
> +	if (self->sockfd < 0 &&
> +	    (errno == EAFNOSUPPORT || errno == EPERM || errno == EACCES))
> +		SKIP(return, "socket(%d, %d, %d) not available: %s",
> +		     variant->family, variant->type, variant->protocol,
> +		     strerror(errno));
> +	ASSERT_GE(self->sockfd, 0) {
> +		TH_LOG("Failed to create socket(%d, %d, %d): %s",
> +		       variant->family, variant->type, variant->protocol,
> +		       strerror(errno));
> +	}
> +}
> +
> +FIXTURE_TEARDOWN(xattr_socket_types)
> +{
> +	if (self->sockfd >= 0)
> +		close(self->sockfd);
> +}
> +
> +TEST_F(xattr_socket_types, set_get_list_remove)
> +{
> +	char buf[256], list[4096], *ptr;
> +	ssize_t ret;
> +	bool found;
> +
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("fsetxattr failed: %s", strerror(errno));
> +	}
> +
> +	memset(buf, 0, sizeof(buf));
> +	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE));
> +	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
> +
> +	memset(list, 0, sizeof(list));
> +	ret = flistxattr(self->sockfd, list, sizeof(list));
> +	ASSERT_GT(ret, 0);
> +	found = false;
> +	for (ptr = list; ptr < list + ret; ptr += strlen(ptr) + 1) {
> +		if (strcmp(ptr, TEST_XATTR_NAME) == 0)
> +			found = true;
> +	}
> +	ASSERT_TRUE(found);
> +
> +	ret = fremovexattr(self->sockfd, TEST_XATTR_NAME);
> +	ASSERT_EQ(ret, 0);
> +
> +	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ENODATA);
> +}
> +
> +/*
> + * Test abstract namespace AF_UNIX socket.
> + * Abstract sockets don't have a filesystem path; their inodes live in
> + * sockfs so user.* xattrs should work via fsetxattr/fgetxattr.
> + */
> +FIXTURE(xattr_abstract)
> +{
> +	int sockfd;
> +};
> +
> +FIXTURE_SETUP(xattr_abstract)
> +{
> +	struct sockaddr_un addr;
> +	char name[64];
> +	int ret, len;
> +
> +	self->sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
> +	ASSERT_GE(self->sockfd, 0);
> +
> +	len = snprintf(name, sizeof(name), "xattr_test_abstract_%d", getpid());
> +
> +	memset(&addr, 0, sizeof(addr));
> +	addr.sun_family = AF_UNIX;
> +	addr.sun_path[0] = '\0';
> +	memcpy(&addr.sun_path[1], name, len);
> +
> +	ret = bind(self->sockfd, (struct sockaddr *)&addr,
> +		   offsetof(struct sockaddr_un, sun_path) + 1 + len);
> +	ASSERT_EQ(ret, 0);
> +}
> +
> +FIXTURE_TEARDOWN(xattr_abstract)
> +{
> +	if (self->sockfd >= 0)
> +		close(self->sockfd);
> +}
> +
> +TEST_F(xattr_abstract, set_get)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("fsetxattr on abstract socket failed: %s",
> +		       strerror(errno));
> +	}
> +
> +	memset(buf, 0, sizeof(buf));
> +	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE));
> +	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
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

