Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897BB60A2610
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NGs9hgRo
Received: by kanga.kvack.org (Postfix)
	id B2D4C6B05B4; Mon, 16 Nov 2026 07:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B04426B05B5; Mon, 16 Nov 2026 07:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40F06B05B6; Mon, 16 Nov 2026 07:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8147C6B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:00:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 912391C4310
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:00:21 +0000 (UTC)
X-FDA: 85440839442.02.AE36FD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 064A4100016
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:00:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGs9hgRo;
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794830420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ewJeUaksgXnSPjHwujvoiDsCY2620AwnIo92RczcOPg=;
	b=r8L9t426bd1+wZrE2rS1BpdgpWF3JR1Hp3WYvwcBzypSxsqYAT+XSXsnn4bQo9/HrYe2Gt
	Upmm08xyWTwYkv8I2LkvpuVXym/CDMn0n7grgh9KhEQ4Cj9Uh89L5SERtw7g0hER+oSM35
	hHjVsX0lZTqBLRwP9OT8wG96A1cxEdA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794830420;
	b=tT7uZ9YHb5plHvhGwyy4V5UDqQHTTaZZjcZTv+le5SnPxAWk4nFpQdnQzJFgduqjB41XzE
	20LR01l/Qjiy1wjIO8a8NMa2skmX8QFM80bUNOfP/fXD9rpnmYh5DZ7GGK4w8Hho5v2ulc
	CEe608BuL5D8XHEE5Bci7Ny5bN2IWkY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGs9hgRo;
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9956A62984;
	Mon, 16 Nov 2026 12:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1241F000C4;
	Mon, 16 Nov 2026 12:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794830419;
	bh=ewJeUaksgXnSPjHwujvoiDsCY2620AwnIo92RczcOPg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=NGs9hgRo8Pm53dwqOowj804JfWGt9pNSxyXsA5ZbufV3wNEO1pXrEV/P2nYSJ6s0h
	 RkTVtrJGGRLTAc/i5stGgdH7MoEG/RRlQzCp8xsSKAlYN1LFViwB+sXdk4YoAbt7yZ
	 PR7EK3GRWabIulVC1l0sYiPb/s/WJh1GIS+NuEi9fxzz0zXVvfrqLfrCezMd74ZtjC
	 IEP94sDVVDwuNz+mWo090jAlScdWhDl8h+8NtgR+BEvWRcqbaBD+sHm90zfAZDrFLE
	 Ium0YC6BRRHbiChOy1fGM3bxcnzkJeY8LsKxgOeIXXUZU9bjQC0KNhILzz6Uz/yD+e
	 WluvUktyVhSBw==
Content-Type: multipart/mixed; boundary="===============1962703051549190966=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <56b5bed0bd75b5b0c7368009493734cda89f1ca37c0fc29c81ed65048cbfeca4@mail.kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-44-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-44-8cbbea1cf34f@kernel.org>
Subject: Re: [PATCH RFC v3 44/44] selftests/filesystems: add backing file tests for pseudo files
From: bot+bpf-ci@kernel.org
To: brauner@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jannh@google.com,mason@kernel.org,josef@toxicpanda.com,hch@lst.de,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,linux-nvme@lists.infradead.org,viro@zeniv.linux.org.uk,jack@suse.cz,linux-scsi@vger.kernel.org,target-devel@vger.kernel.org,driver-core@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,linux-security-module@vger.kernel.org,selinux@vger.kernel.org,apparmor@lists.ubuntu.com,linux-nfs@vger.kernel.org,netdev@vger.kernel.org,fuse-devel@lists.linux.dev,linux-efi@vger.kernel.org,xen-devel@lists.xenproject.org,ocfs2-devel@lists.linux.dev,linux-s390@vger.kernel.org,linuxppc-dev@lists.ozlabs.org,linux-usb@vger.kernel.org,amir73il@gmail.com,linux-erofs@lists.ozlabs.org,linux-kselftest@vger.kernel.org,brauner@kernel.org,alex@amutable.com,chris@chrisdown.name,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 16 Nov 2026 12:00:17 +0000 (UTC)
X-Rspamd-Server: rspam06
X-Stat-Signature: ofy7uotpm17kfwaq4a8z4kzwhxrjcj8e
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 064A4100016
X-Rspam-User: 
X-HE-Tag: 1794830419-334511
X-HE-Meta: U2FsdGVkX1+09Dhbv623eflKNk5alvvZFBJK2vRIcGj4a08xqTn9+e6C6CTq+VdHSR/df7kDCUxWzXR4w2JGzl1NEL3xSoEtXnnS3nYLiF1sAQRmkmBDwikvtMu8OsfKIVjQhuSRcpR6XkE6dk170jjE23Blzk/b/ecAXRZvfSgzKN8cflF+Ivks+njh1LKQeuxcSdx7+5aoFi4tJUd7iCopbeDYDEgwHJW8ZIIB2xWxV68QezYZ5EZVashwPuoHAU1noNb7NNjj1f7fM/KMD38TUtkJ61GeSv83B3jAYTNNLEpvmFAZ4sHP8g7hxgN1APlOLvswjC5juGZWBb0ypkH5GPOr7XMI7Mspl+CgqOn+/fMxdsWAvx+V8pPTpX4ebR2nZnciOXDbitM4s3p8gN7NuSVYDWnDnBG2+6nkDj02z++FpZIbi6kgqioXE8stnIN0yyE4HTilKiNnKT/fiHGCkk7xGEm5fngnQkYNIuFNk2+lahE8mGvK2qGEuD5UWD2NwI1tT5/awVbMw9f+kdWSjp4oSLaletiW+oGYQKfM3ZZkGO7bB6dEgem1V1G6m2fgQcXr5Vh0ZBpLo/BDdQl1agWNON73u8WdLBgAN/zkmHT0sDJ8tST41XNfOhn7gtrShQ76w3LRRwHqHIe+GAxhNDyBf/d59IMn/XJmwzDdOzTvN+CDSp89KPhCQwQbNy/QTfne4GLD7Hqh1/orW2hNoB/bzx8h8npTcAGAKM5HIEYjw9IityNUJfPfBXGr8ASk/B7wXlXeREDD3uL4FBFi29YHU28DdJSvoK49svGHoH6BnVTomgNX9m5tpqAiNimfdvJu+aPxSK5ZbZGZVSGR93L90oorN4c9daXbiajzV8yeynwioP9OdFjyLlP0iH5OUxVjUu0BFE6DfMlLMqeS0BRGuuVKozDynN0M4vA2ouXf01+LJ6Cghr1kaX2bvY14Qvg0fqJ0drsQdAG
 ZWxRGKdL
 J77DjsTNU5v32yC+eb9J4B5l6zjbOfqlvegaMHbgd4xesbEPT6hYEN1ZirlPz4xH/O8qEF962RQCo3w5gf+kEgGJEn8t43Tx5eYE9aMEBuy8G8MWQhJuMUIXU6lm59t3j/3mB0a4jasgsyLYOYUPlGd6kRTmQok3zCkDhRS1iUkIErXjMkJcJ6uQIvLXBzWvgv/vR9Ydg3al9TPOnqAXJ2oY81gCbD8iEyRe0wn5UYL34upJdyDvylbWR5RXm5FKKOyUYxlZBZYAvDDPShYiHPVib0FPm46JWSlsxMAy+XQYs/cuN6WONNBHV1Im6PE38cLvJ/IYJDNk/xlJA5fQFIhbV6i4BjmAxjUhzOlqGHkxzW7UfdQ1oanEh32AxUdDNYFFR6K0xkDa+oi5bQUnm73IGNgO3kJBVCdSLc5xi+t6gETyyi8ujQFznZ8lOnJxXzaAhr4puIUfo/lM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============1962703051549190966==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/filesystems: add backing file tests for pseudo files

TL;DR:
- Selftest: fuse tests may fail instead of skip without
  CONFIG_FUSE_PASSTHROUGH (-EOPNOTSUPP, not -EPERM)
- Metacopy test may fail without CONFIG_TMPFS_XATTR
- Minor duplicated setup code

> diff --git a/tools/testing/selftests/filesystems/config b/tools/testing/selftests/filesystems/config
> --- a/tools/testing/selftests/filesystems/config
> +++ b/tools/testing/selftests/filesystems/config
> @@ -6,3 +6,19 @@ CONFIG_NET=y
>  CONFIG_NET_NS=y
>  CONFIG_INET=y
>  CONFIG_SYSFS=y
> +CONFIG_BLK_DEV_LOOP=y
> +CONFIG_OVERLAY_FS=y
> +CONFIG_TMPFS=y
> +CONFIG_CONFIGFS_FS=y
[ ... ]

Should CONFIG_TMPFS_XATTR=y be added here as well?

TEST(fuse_passthrough_overlayfs_metacopy_file) mounts a private tmpfs
through setup_tmp() and then does:

    ASSERT_EQ(setxattr("/tmp/lower/file", "trusted.overlay.metacopy",
                       "", 0, 0), 0);

shmem_fill_super() only sets sb->s_xattr under CONFIG_TMPFS_XATTR, which
defaults to n, and CONFIG_TMPFS does not select it.  Without it
setxattr() fails with EOPNOTSUPP, the ASSERT_EQ() aborts, and the run
reports a failure rather than a skip.  tools/testing/selftests/landlock/config
lists CONFIG_TMPFS_XATTR=y next to CONFIG_TMPFS=y.

Alternatively the test could SKIP when setxattr() returns EOPNOTSUPP.

> diff --git a/tools/testing/selftests/filesystems/pseudo_backing_test.c b/tools/testing/selftests/filesystems/pseudo_backing_test.c
> new file mode 100644
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/pseudo_backing_test.c

[ ... ]

> +TEST(overlayfs_on_sysfs_backing_file)
> +{
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	ASSERT_EQ(unshare(CLONE_NEWNS), 0);
> +	ASSERT_EQ(mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL), 0);
> +	ASSERT_EQ(mount("tmpfs", "/tmp", "tmpfs", 0, NULL), 0);

this isn't a bug, but could overlayfs_on_sysfs_backing_file() call
ASSERT_EQ(setup_tmp(), 0) like the other tests, instead of repeating its
three steps?  Similarly, usb_mass_storage_backing_file() repeats the
statfs()/CONFIGFS_MAGIC/mount() logic of setup_configfs(), and the comment
"Mounting configfs on top of itself fails with EBUSY." appears twice.

[ ... ]

> +TEST(fuse_passthrough_backing_file)
> +{
> +	int fuse_fd, ret;
> +
[ ... ]
> +	ASSERT_EQ(create_file("/tmp/file"), 0);
> +	ret = fuse_backing_path(fuse_fd, "/tmp/file", O_PATH);
> +	if (ret == -EPERM)
> +		SKIP(return, "no fuse passthrough");
> +	EXPECT_EQ(ret, 0);

Is -EPERM the right errno to key the skip on?  On a kernel with
CONFIG_FUSE_FS=y and CONFIG_FUSE_PASSTHROUGH=n the test filesystem mounts
fine, and then fuse_dev_ioctl_backing_open() returns before any
permission check:

    if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
        return -EOPNOTSUPP;

-EPERM only comes from fuse_backing_open_file() when fc->passthrough is
clear or CAP_SYS_ADMIN is missing.  So here EXPECT_EQ(ret, 0) and the
later -EINVAL checks see -EOPNOTSUPP and fail, and the harness records
"not ok" for a feature that is not configured.  Kernels that predate
FUSE_DEV_IOC_BACKING_OPEN return -ENOTTY and fail the same way.

Should -EOPNOTSUPP (and possibly -ENOTTY) also lead to the SKIP?

[ ... ]

> +TEST(fuse_passthrough_overlayfs_metacopy_file)
[ ... ]
> +	ASSERT_EQ(create_file("/tmp/lower/file"), 0);
> +	ASSERT_EQ(setxattr("/tmp/lower/file", "trusted.overlay.metacopy",
> +			   "", 0, 0), 0);
> +	ASSERT_EQ(setxattr("/tmp/lower/file", "trusted.overlay.redirect",
> +			   "/missing", strlen("/missing"), 0), 0);

Can these setxattr() calls fail on a kernel without CONFIG_TMPFS_XATTR?

The private tmpfs from setup_tmp() has no xattr handlers in that case, so
setxattr() returns EOPNOTSUPP, the ASSERT_EQ() aborts, and the program
exits with a failure instead of KSFT_SKIP.  The mount of overlayfs just
below already has a SKIP for missing support.  Would a SKIP on
EOPNOTSUPP here, or CONFIG_TMPFS_XATTR=y in the config fragment, avoid
this?

> +	ret = fuse_backing_path(fuse_fd, "/tmp/file", O_PATH);
> +	if (ret == -EPERM)
> +		SKIP(return, "no fuse passthrough");
> +	ASSERT_EQ(ret, 0);

The same -EPERM check as in fuse_passthrough_backing_file() is used here,
so ASSERT_EQ(ret, 0) fails with -EOPNOTSUPP when CONFIG_FUSE_PASSTHROUGH
is off.

[ ... ]

> +TEST(fuse_passthrough_io)
[ ... ]
> +		srv.backing_ids[i] = fuse_backing_open(srv.fd, fd);
> +		EXPECT_EQ(close(fd), 0);
> +		if (srv.backing_ids[i] == -EPERM)
> +			SKIP(return, "no fuse passthrough");
> +		ASSERT_GT(srv.backing_ids[i], 0);

Does this skip also miss the unconfigured case?  With
CONFIG_FUSE_PASSTHROUGH=n, fuse_backing_open() gets -EOPNOTSUPP from the
ioctl, which is not -EPERM, so ASSERT_GT(srv.backing_ids[i], 0) fails and
run_one() records "not ok" for the whole pseudo_backing_test.  No fuse
server has been started at this point, so nothing hangs.  The config
fragment does list CONFIG_FUSE_PASSTHROUGH=y, but should -EOPNOTSUPP and
-ENOTTY also lead to SKIP(return, "no fuse passthrough") in all three fuse
tests?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43858134663
--===============1962703051549190966==--

