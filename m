Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6112FEFB56
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6806B0092; Fri, 27 Feb 2026 10:30:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283DE6B0093; Fri, 27 Feb 2026 10:30:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15C026B0095; Fri, 27 Feb 2026 10:30:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F145A6B0092
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:30:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BF828C35E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:30:58 +0000 (UTC)
X-FDA: 84490624596.06.74690F2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 477101A001E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:30:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nIJznJMj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3ug700Kk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ER0jE8ic;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=h9uX+LeD;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772206256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFOw/CipdsoxjPCODfI4GMcSSYcQzdPIxtrDNHFZ3c4=;
	b=Xo3XAftTFP8XNpZqpG8dAI5AOPMLnSIpY+XCcWAR68FZt/71KY3fAN+8vbcuYlH922vSoU
	/SqbFD5J5rbA+oxEfa/s7TrqT4Fy7s8ckMQ1zWnbGKrQYLSzAa+OTazzBORLs2g/Lm779a
	CxIWGKoMdGM57jxUsIJ98+LdFRnU+x8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772206256; a=rsa-sha256;
	cv=none;
	b=xDz7Wm4gRZsW8Yae59pFkGJr50kuKXNiNQzVED8BIf1wSXFPnlfCLOX7f1fGsDErUAF3nY
	ir+uYjCdM+MObOiM0yPICpjMElOs4EdscNfVjLaciNDdH6esH9QzHW7HP7VY15DAgGfx1W
	mR8aiTSqP1XGS8EAB26vR8dLrWNkp4o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nIJznJMj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3ug700Kk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ER0jE8ic;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=h9uX+LeD;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 044085C43F;
	Fri, 27 Feb 2026 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772206255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rFOw/CipdsoxjPCODfI4GMcSSYcQzdPIxtrDNHFZ3c4=;
	b=nIJznJMjktcoLwWwVlSLsfZIKyVFzo/o9dV4chF33xfSYsWOJJRK6OQH2Qlh2e0j9Z776P
	zP8GJHTJ0JR5r6Q5knxSQ2Uby1DpQpTn3QTDqgfT4vjwtaKI961zVQAirM6z6y6Se3gGVm
	dC2XlTgLDhv+5kxT1tiOzPMjN5/vlmc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772206255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rFOw/CipdsoxjPCODfI4GMcSSYcQzdPIxtrDNHFZ3c4=;
	b=3ug700KkirGOaxaxqZrb/7OLkoKkwkmUPN2sx97ELg3WLdiWDPYsZ2emzBNxSeGSITR8Wt
	+BekfokGwWGZsZCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772206254; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rFOw/CipdsoxjPCODfI4GMcSSYcQzdPIxtrDNHFZ3c4=;
	b=ER0jE8icm2+ekpA8i0zpk6jhD0QkDa63Lys7NGlSPMEgOf7R/SIQ/urMclT7P5wF0dHo64
	gZJlVrmMeZyvfrJoKD/+oh6WUnyDtbISa3L0loC8of+SjIw++hd8d+IElHU/maHN9qn9tq
	Cb5W0vQ9gqBwi+O+SOGHTXu20PiDbS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772206254;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rFOw/CipdsoxjPCODfI4GMcSSYcQzdPIxtrDNHFZ3c4=;
	b=h9uX+LeDvz4h+Bsig1IHp1e7FNcBVY8oNM9xDhV1deTySxlga2EZ2D4nppEBHXqM6cvozi
	A9oVBK1DnvmYbaDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ECECC3EA69;
	Fri, 27 Feb 2026 15:30:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 44bVOa24oWlHLAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Feb 2026 15:30:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B2030A06D4; Fri, 27 Feb 2026 16:30:53 +0100 (CET)
Date: Fri, 27 Feb 2026 16:30:53 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 13/14] selftests/xattr: sockfs socket xattr tests
Message-ID: <yqxanlt3h4h2dwtpzgywsrzozdry3oe3c4yg22x6wqm2grntbu@pazi2ufzrwfv>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-13-c2efa4f74cb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216-work-xattr-socket-v1-13-c2efa4f74cb7@kernel.org>
X-Rspamd-Queue-Id: 477101A001E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: dyxm173ownyeu6irzwg16a3p55p9zy86
X-HE-Tag: 1772206256-731846
X-HE-Meta: U2FsdGVkX18BOzfQzkJz0Hqpg3SzJF9/1YXIPxl9U+5zJm/c/a/JLRB8qDSvX87JaJ5ebdXZ7laFS/RtUaQSRSP1IDOiRoCdpGJkfRIYbVWleqJQACR7pcdSDZImvyFYI9pyNc4Y2X1Rwu8NA+zvML8Z90Z0wI+RxY9frc8AKPQZwzRKWNFpWZBjH/jaqcMH5lf7V20aIO4HV/I8gh7tMzSxZXDaphcuOfwr5VEKsSDAsBywrTi2is3LOnXUDQ9KHljnTPkYt9IK6p5k6V+2MhipFusNbWQLW12as35z+qadRwZiGOyneN/iy98YPIxVo4iPaHFhPang3ZSqNESReX4vEALuyBxIyQvEikiX8nINWBVOwvRKb8ZGoB7/d64kBlmWsEQDyDPnuhrz4R1toXm8IT/a45Ptv7hi1+EsaCz3KbZl+eOpLXqHQdlSpINjBajK9gV7rh8vo0eZpjrFLlClBtYb9534bC9jX7Z7DCRQ3K7aMFbiT/Y5MigVgOKzZfd9VvLCO8lU5BzczNGoSbQBLDHSc8/cqOeUVhQXxyDNoMIX5VQtloTpP8C5fpEYToqNH5UaceyGfSAqfagnbNTF9cxBcAPyV2Nq9qnGRCAGjMReGRPl//uDc71xjbAlsXPt51kwIpecN7kM3TDscoyM8JEBm2BW4Il4Ks2iWNpM8aeI99Xkwcf5iMcxv10tvYEDxkrJyFbK9KqaJvF8A/SwrnY87up2kq8Cj+03EvSjVbkZhXkNQReP5lj8klHh97cItt/8u6aDUxvXyiJ6UFhuw1IP8OVtRs4Fa6cKMMgiqd0MKYXpXVRqUCROpJwPQhN2Vnuoo5DdpTcEvygAgmrsdbGkfEnSa1CE+cbEH5gF7bNU5SgKby9sjJ67d2FTJyKsoDrXVEsqLE+hm3uelE+IxyuPLWoDZkZbl2JRj47PCjsbb9SeYilw7b3edd5WhLD7Q7P5gSiQ1V439Gm
 UfO9mtyv
 nZVNVJ6aD6WyiU90EYr61DmpGi93GWCZz5AYBagc4mFdbftzZwLlT1dIWC8GPn0jMoLGBCPa7ffayX/Vjq22CQbDRClU68tAh+rp5ADNnc/WyUCdGVi+xAjVBJD7HxL4ez25UITPksSYbVU/4ySu6DOy9RgPBPK1aaaoG1s+CShduRAvRPiCNYHUysZJkWSqa0vWWduLYAwoPYK8tIhTQGpqiimaCdqh+/gSlszVfKO0t8wswl25+vtN7DtzpP4ow5klrEXjhCf6Av/hFXTxgft78CK19eliQvxdYBb2Nh8EQv++cQWnpNgclfEh6cgxeAQTO4ccn57vV2hmPHIgwUBISzBdqvYXbOGjjs0+E/mhtQGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 14:32:09, Christian Brauner wrote:
> Test user.* extended attribute operations on sockfs sockets. Sockets
> created via socket() have their inodes in sockfs, which now supports
> user.* xattrs with per-inode limits.
> 
> Tests fsetxattr/fgetxattr/flistxattr/fremovexattr operations including
> set/get, listing (verifies system.sockprotoname presence), remove,
> update, XATTR_CREATE/XATTR_REPLACE flags, empty values, size queries,
> and buffer-too-small errors.
> 
> Also tests per-inode limit enforcement: maximum 128 xattrs, maximum
> 128KB total value size, limit recovery after removal, and independent
> limits across different sockets.
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  .../testing/selftests/filesystems/xattr/.gitignore |   1 +
>  tools/testing/selftests/filesystems/xattr/Makefile |   2 +-
>  .../filesystems/xattr/xattr_sockfs_test.c          | 363 +++++++++++++++++++++
>  3 files changed, 365 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/filesystems/xattr/.gitignore b/tools/testing/selftests/filesystems/xattr/.gitignore
> index 5fd015d2257a..00a59c89efab 100644
> --- a/tools/testing/selftests/filesystems/xattr/.gitignore
> +++ b/tools/testing/selftests/filesystems/xattr/.gitignore
> @@ -1 +1,2 @@
>  xattr_socket_test
> +xattr_sockfs_test
> diff --git a/tools/testing/selftests/filesystems/xattr/Makefile b/tools/testing/selftests/filesystems/xattr/Makefile
> index e3d8dca80faa..2cd722dba47b 100644
> --- a/tools/testing/selftests/filesystems/xattr/Makefile
> +++ b/tools/testing/selftests/filesystems/xattr/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  
>  CFLAGS += $(KHDR_INCLUDES)
> -TEST_GEN_PROGS := xattr_socket_test
> +TEST_GEN_PROGS := xattr_socket_test xattr_sockfs_test
>  
>  include ../../lib.mk
> diff --git a/tools/testing/selftests/filesystems/xattr/xattr_sockfs_test.c b/tools/testing/selftests/filesystems/xattr/xattr_sockfs_test.c
> new file mode 100644
> index 000000000000..b4824b01a86d
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/xattr/xattr_sockfs_test.c
> @@ -0,0 +1,363 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2026 Christian Brauner <brauner@kernel.org>
> +/*
> + * Test extended attributes on sockfs sockets.
> + *
> + * Sockets created via socket() have their inodes in sockfs, which supports
> + * user.* xattrs with per-inode limits: up to 128 xattrs and 128KB total
> + * value size. These tests verify xattr operations via fsetxattr/fgetxattr/
> + * flistxattr/fremovexattr on the socket fd, as well as limit enforcement.
> + */
> +
> +#define _GNU_SOURCE
> +#include <errno.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/socket.h>
> +#include <sys/types.h>
> +#include <sys/xattr.h>
> +#include <unistd.h>
> +
> +#include "../../kselftest_harness.h"
> +
> +#define TEST_XATTR_NAME		"user.testattr"
> +#define TEST_XATTR_VALUE	"testvalue"
> +#define TEST_XATTR_VALUE2	"newvalue"
> +
> +/* Per-inode limits for user.* xattrs on sockfs (from include/linux/xattr.h) */
> +#define SIMPLE_XATTR_MAX_NR	128
> +#define SIMPLE_XATTR_MAX_SIZE	(128 << 10)	/* 128 KB */
> +
> +#ifndef XATTR_SIZE_MAX
> +#define XATTR_SIZE_MAX 65536
> +#endif
> +
> +/*
> + * Fixture for sockfs socket xattr tests.
> + * Creates an AF_UNIX socket (lives in sockfs, not bound to any path).
> + */
> +FIXTURE(xattr_sockfs)
> +{
> +	int sockfd;
> +};
> +
> +FIXTURE_SETUP(xattr_sockfs)
> +{
> +	self->sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
> +	ASSERT_GE(self->sockfd, 0) {
> +		TH_LOG("Failed to create socket: %s", strerror(errno));
> +	}
> +}
> +
> +FIXTURE_TEARDOWN(xattr_sockfs)
> +{
> +	if (self->sockfd >= 0)
> +		close(self->sockfd);
> +}
> +
> +TEST_F(xattr_sockfs, set_get_user_xattr)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("fsetxattr failed: %s", strerror(errno));
> +	}
> +
> +	memset(buf, 0, sizeof(buf));
> +	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE)) {
> +		TH_LOG("fgetxattr returned %zd: %s", ret, strerror(errno));
> +	}
> +	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
> +}
> +
> +/*
> + * Test listing xattrs on a sockfs socket.
> + * Should include user.* xattrs and system.sockprotoname.
> + */
> +TEST_F(xattr_sockfs, list_user_xattr)
> +{
> +	char list[4096];
> +	ssize_t ret;
> +	char *ptr;
> +	bool found_user = false;
> +	bool found_proto = false;
> +
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("fsetxattr failed: %s", strerror(errno));
> +	}
> +
> +	memset(list, 0, sizeof(list));
> +	ret = flistxattr(self->sockfd, list, sizeof(list));
> +	ASSERT_GT(ret, 0) {
> +		TH_LOG("flistxattr failed: %s", strerror(errno));
> +	}
> +
> +	for (ptr = list; ptr < list + ret; ptr += strlen(ptr) + 1) {
> +		if (strcmp(ptr, TEST_XATTR_NAME) == 0)
> +			found_user = true;
> +		if (strcmp(ptr, "system.sockprotoname") == 0)
> +			found_proto = true;
> +	}
> +	ASSERT_TRUE(found_user) {
> +		TH_LOG("user xattr not found in list");
> +	}
> +	ASSERT_TRUE(found_proto) {
> +		TH_LOG("system.sockprotoname not found in list");
> +	}
> +}
> +
> +TEST_F(xattr_sockfs, remove_user_xattr)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	ret = fremovexattr(self->sockfd, TEST_XATTR_NAME);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("fremovexattr failed: %s", strerror(errno));
> +	}
> +
> +	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ENODATA);
> +}
> +
> +TEST_F(xattr_sockfs, update_user_xattr)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE2, strlen(TEST_XATTR_VALUE2), 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	memset(buf, 0, sizeof(buf));
> +	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE2));
> +	ASSERT_STREQ(buf, TEST_XATTR_VALUE2);
> +}
> +
> +TEST_F(xattr_sockfs, xattr_create_flag)
> +{
> +	int ret;
> +
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE2, strlen(TEST_XATTR_VALUE2),
> +			XATTR_CREATE);
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, EEXIST);
> +}
> +
> +TEST_F(xattr_sockfs, xattr_replace_flag)
> +{
> +	int ret;
> +
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE),
> +			XATTR_REPLACE);
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ENODATA);
> +}
> +
> +TEST_F(xattr_sockfs, get_nonexistent)
> +{
> +	char buf[256];
> +	ssize_t ret;
> +
> +	ret = fgetxattr(self->sockfd, "user.nonexistent", buf, sizeof(buf));
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ENODATA);
> +}
> +
> +TEST_F(xattr_sockfs, empty_value)
> +{
> +	ssize_t ret;
> +
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME, "", 0, 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, NULL, 0);
> +	ASSERT_EQ(ret, 0);
> +}
> +
> +TEST_F(xattr_sockfs, get_size)
> +{
> +	ssize_t ret;
> +
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, NULL, 0);
> +	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE));
> +}
> +
> +TEST_F(xattr_sockfs, buffer_too_small)
> +{
> +	char buf[2];
> +	ssize_t ret;
> +
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ERANGE);
> +}
> +
> +/*
> + * Test maximum number of user.* xattrs per socket.
> + * The kernel enforces SIMPLE_XATTR_MAX_NR (128), so the 129th should
> + * fail with ENOSPC.
> + */
> +TEST_F(xattr_sockfs, max_nr_xattrs)
> +{
> +	char name[32];
> +	int i, ret;
> +
> +	for (i = 0; i < SIMPLE_XATTR_MAX_NR; i++) {
> +		snprintf(name, sizeof(name), "user.test%03d", i);
> +		ret = fsetxattr(self->sockfd, name, "v", 1, 0);
> +		ASSERT_EQ(ret, 0) {
> +			TH_LOG("fsetxattr %s failed at i=%d: %s",
> +			       name, i, strerror(errno));
> +		}
> +	}
> +
> +	ret = fsetxattr(self->sockfd, "user.overflow", "v", 1, 0);
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ENOSPC) {
> +		TH_LOG("Expected ENOSPC for xattr %d, got %s",
> +		       SIMPLE_XATTR_MAX_NR + 1, strerror(errno));
> +	}
> +}
> +
> +/*
> + * Test maximum total value size for user.* xattrs.
> + * The kernel enforces SIMPLE_XATTR_MAX_SIZE (128KB). Individual xattr
> + * values are limited to XATTR_SIZE_MAX (64KB) by the VFS, so we need
> + * at least two xattrs to hit the total limit.
> + */
> +TEST_F(xattr_sockfs, max_xattr_size)
> +{
> +	char *value;
> +	int ret;
> +
> +	value = malloc(XATTR_SIZE_MAX);
> +	ASSERT_NE(value, NULL);
> +	memset(value, 'A', XATTR_SIZE_MAX);
> +
> +	/* First 64KB xattr - total = 64KB */
> +	ret = fsetxattr(self->sockfd, "user.big1", value, XATTR_SIZE_MAX, 0);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("first large xattr failed: %s", strerror(errno));
> +	}
> +
> +	/* Second 64KB xattr - total = 128KB (exactly at limit) */
> +	ret = fsetxattr(self->sockfd, "user.big2", value, XATTR_SIZE_MAX, 0);
> +	free(value);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("second large xattr failed: %s", strerror(errno));
> +	}
> +
> +	/* Third xattr with 1 byte - total > 128KB, should fail */
> +	ret = fsetxattr(self->sockfd, "user.big3", "v", 1, 0);
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ENOSPC) {
> +		TH_LOG("Expected ENOSPC when exceeding size limit, got %s",
> +		       strerror(errno));
> +	}
> +}
> +
> +/*
> + * Test that removing an xattr frees limit space, allowing re-addition.
> + */
> +TEST_F(xattr_sockfs, limit_remove_readd)
> +{
> +	char name[32];
> +	int i, ret;
> +
> +	/* Fill up to the maximum count */
> +	for (i = 0; i < SIMPLE_XATTR_MAX_NR; i++) {
> +		snprintf(name, sizeof(name), "user.test%03d", i);
> +		ret = fsetxattr(self->sockfd, name, "v", 1, 0);
> +		ASSERT_EQ(ret, 0);
> +	}
> +
> +	/* Verify we're at the limit */
> +	ret = fsetxattr(self->sockfd, "user.overflow", "v", 1, 0);
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ENOSPC);
> +
> +	/* Remove one xattr */
> +	ret = fremovexattr(self->sockfd, "user.test000");
> +	ASSERT_EQ(ret, 0);
> +
> +	/* Now we should be able to add one more */
> +	ret = fsetxattr(self->sockfd, "user.newattr", "v", 1, 0);
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("re-add after remove failed: %s", strerror(errno));
> +	}
> +}
> +
> +/*
> + * Test that two different sockets have independent xattr limits.
> + */
> +TEST_F(xattr_sockfs, limits_per_inode)
> +{
> +	char buf[256];
> +	int sock2;
> +	ssize_t ret;
> +
> +	sock2 = socket(AF_UNIX, SOCK_STREAM, 0);
> +	ASSERT_GE(sock2, 0);
> +
> +	/* Set xattr on first socket */
> +	ret = fsetxattr(self->sockfd, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE, strlen(TEST_XATTR_VALUE), 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	/* First socket's xattr should not be visible on second socket */
> +	ret = fgetxattr(sock2, TEST_XATTR_NAME, NULL, 0);
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(errno, ENODATA);
> +
> +	/* Second socket should independently accept xattrs */
> +	ret = fsetxattr(sock2, TEST_XATTR_NAME,
> +			TEST_XATTR_VALUE2, strlen(TEST_XATTR_VALUE2), 0);
> +	ASSERT_EQ(ret, 0);
> +
> +	/* Verify each socket has its own value */
> +	memset(buf, 0, sizeof(buf));
> +	ret = fgetxattr(self->sockfd, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE));
> +	ASSERT_STREQ(buf, TEST_XATTR_VALUE);
> +
> +	memset(buf, 0, sizeof(buf));
> +	ret = fgetxattr(sock2, TEST_XATTR_NAME, buf, sizeof(buf));
> +	ASSERT_EQ(ret, (ssize_t)strlen(TEST_XATTR_VALUE2));
> +	ASSERT_STREQ(buf, TEST_XATTR_VALUE2);
> +
> +	close(sock2);
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

