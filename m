Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 896E5606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UCCM8jza
Received: by kanga.kvack.org (Postfix)
	id 6BA356B05B9; Sun, 22 Nov 2026 14:52:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66AA66B05BB; Sun, 22 Nov 2026 14:52:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580BD6B05BC; Sun, 22 Nov 2026 14:52:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 166B76B05B9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:52:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C58440715
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:52:35 +0000 (UTC)
X-FDA: 85463802270.11.03336ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id DF59BC0008
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:52:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCCM8jza;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795377154;
	b=d1FuRLxzPrDSr4BimrN6iCoG7VtwxSxt6wwT3N7Uz+opuYx8BdAkt8JQnMotm2AmqUWGJM
	FtI9iN7yDFJwgRUO2nW5SLRFMfCkhaKpHhyxXO8vuLPJml4pDqllH1Fnrwxm/7ipjaVI19
	wsFddH1X8D8wgJgr21vqGneCZ7ew73Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795377154;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oB53AiQQW9kpLqFTwPLdStd+pKNNCNgAcTj6vtNksiI=;
	b=YQMMcYjG28pBG+8Pj0BIT+oHhuHPbfR8zCIYBTSFlr1RyVn41WVufT5IEX/YlwyoFOw3KT
	UY3DqGjTn/X97Q4r6KjjuzAmgdMgU9eWhvI3Cd72jI5ine4Lr63vxbAPWOV4eLKZiqtII7
	nmyxjpKTw0jpdXzKhVGQ/INkeU/4QiM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCCM8jza;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 184784332E;
	Sun, 22 Nov 2026 19:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9281F000C6;
	Sun, 22 Nov 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795377152;
	bh=oB53AiQQW9kpLqFTwPLdStd+pKNNCNgAcTj6vtNksiI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UCCM8jzaKPGvBdMxxTt7G6+YtHW35kSK4nIHnILYexvOGzFiQGx7wbiJfTTEWQG2n
	 4KGWp0aMiu0+j5BLZk8+0GX6Srq518ciVqilMGs/gk+icFQzeznUiasFeCVLQUpnZL
	 rR2ynpIZQwyYi8sE9vCuAIhN+RGLJpZ3YU428BAav07mSf5NTBhAK4BbB46rW1LsUW
	 9Yh2qozw48I4g5Hgnp2fS2+7Z7R82FlPhPUJVN7hmMUCDNWf+5jd97Mk3RgfJVu+EF
	 4BbeRxuaY4QhSsgGPcQ5bsRRk0zibQsj8bqa330d+pn81fJW1luy4nPH/L65JCNn62
	 TLb3aIg/lTI+A==
Message-ID: <sashiko-outbox-228295@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 25/26] selftests/userland: Add userland test
 suite
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Aleksa
 Sarai" <aleksa@amutable.com>, "Alexander Mikhalitsyn" <alex@amutable.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andy Lutomirski" <luto@amacapital.net>, "Arnd
 Bergmann" <arnd@arndb.de>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Eric Biggers" <ebiggers@kernel.org>, "Giuseppe
 Scrivano" <giuseppe@scrivano.org>, "Hugh Dickins" <hughd@google.com>, "Jan
 Kara" <jack@suse.cz>, "Jeff Layton" <jlayton@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Josef
 Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "KP Singh" <kpsingh@kernel.org>, "Lennart
 Poettering" <lennart@poettering.net>, "Neal Gompa" <neal@gompa.dev>, "Oleg
 Nesterov" <oleg@redhat.com>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Zygmunt Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261122193539.3334213-26-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <20261122193539.3334213-26-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 19:52:31 +0000
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DF59BC0008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: s1i41hioag7oafxrjonr4oxbbfweuxrf
X-HE-Tag: 1795377153-30704
X-HE-Meta: U2FsdGVkX18q12khRV1dwW689m5+U2Jx2k4PxxzF5QBF2+pO6PfF50sQBPWVyOzPUQ1csafgTsu0DuKV9ygoMfBTN4zWC0wgHIA+dEDLUd0hWhCdeQKcZW7ZbaqWP9LLZuVBz+g7WMOmoDAUjTq8jzDyMr4T4eA9VWtd5CyeiCPtroDtjTgzDDlcYJ4sER6RsDEztAMNlaEqf4IrBmtgTJy48ug9vIEKT1AWE1/w2TGc6RjtGkNW0tQO+495WrFscqc0nWuJrLrHFqnloMYJ5kwbOv9pPbt5qKLz4jMaQXeEfbnwiOOsYncDJGg7g0Lif4erb6a8aH7dFzo8hdhdp/tyHC0V6YGZfXaCITUGp2S+cNg3mlW26X0098IjxnLeDLzMGsXjIRPFRLC0Sd7BdZrcQCYcV6E1V5+DzEIcammir082abmqDMOfvC34/AxTjwGfqvoh8k4G24K3+D0Qxo8zrITR08fpE2BGcOvSmovHT9riPMaI7WuZN4zhIH0/wIpUaZrFap7ACV3Q7Lewa4HX6JEkfQcMfDxfr3y+CvooSqtpGH8/hAb6+IXDBaXgy0IQ9PjumM/Wt6k812p5QAqI4q3A3wkp83YqkcD9sfuCui0kdDvep68IIVKUBbsQdwatZuqkum0NzmyoFe0Jw4LOpT2QWWWtkrOjrgXjw3qt0gljMf6EGaX3X1KQeeNe/S93j1lr8vsNz405H4Zx1lNTh3Dm2EHiRNRB7b3SNkG9nULCCKlMm6LyC7A+oSdUqLNxzws0KpoxHoqNosUusAYUUQ0IehcgA4M75LsXm8xm0pmYT3qX4CdcbTNorFzKumyvGgPpEOEyVXaBHZj543eeUAOAOqi/hB581Y1LiWqJ8AauKsCa6fIOHyqyyW8HEOlBfXxhnxdhiyCBYpXwBQoA8BHZR0ZKs1cvXE2kNcjivU9GTcf+8q66ovzNdLnbngw6oWc4nB7nqqg7S1y
 tjlvFwOx
 i8JvmlCriXSX6b0HoZYqsRuFM5pD1bUnBlDKLzPVf9GkgGafqXe/73pPwvzm+1N+uZs0eTO9glYUHpc1Aucs76AD5xUaJbRivnNE7xRkuW9Nm/GZ3Zu1tfEZtiKorQmVcCg9RuYbinOSu+6hjJnkIFgcbnMpB4d9HXcPNTb8dRnGmSTNmesWtxQenjnOJDOTytGo+IwETnfhO4iytjdwRAnIfEnmbxLzkTVV/MzwoKvdKT5yaTPLvV3hCnr3n6HF12AK92Vadv0bDtDeKfB/P3H7JpSVsCUwfDLZlDUB/ZX4/+FsgtWQQhEq67W3Nwhx6tQTiYhu3H4NGspus0Ltv9mycGbFuKjw7KPRBtNhCEXFCPcZane8PXXh/8KajdVToMh6xIfxnna5pCfEc5hozkAwgqfxWbwNNUZnicv10owx+la42RZQ4V4DXIgpN7TlOL8POB0TaPoO2M9M9vA1Qy3a2QGln/l/5E8d2r8z1JjfUGCUCT5ENaPYyx24MOrth2+RvhitF3t7GG+6KFitCCqCGsaS3lxkqkPZipswMOdx8t3m682AiHNKJIsSXhAtvhkDvJhhrc/6r6GWVMVQGh4EEeTBboefBpp6mr5T8G+1iO4IumEzrfEc+/sTthd9SKvAJy62JmLdRKYmALza2rn49yTEXiLEifauuwvP2Ye3b98sQYrRUk8rVI+AYvnQLzMyqWsppCxTGwTjucCdiuVDnodtzVyRqD46UjqQEVwAzGmqEZ42sKSXr47R4VRaizJe/ApKsVerBgbrunr6rSJgHDZbQ/W7rkeAIqDlERP6yBE4+F5nCp1Tid3F69Q1Rl8s9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] selftests/userland: host /tmp mount leak in
  check_child_src_slave_locking()
- [Medium] selftests/userland: 64K-page E2BIG failure in
  test_userns_set_idmap()
- [Low] selftests/userland: Python 3.10+ parenthesized with-statements
  in test
--

commit cd1410a72fb4e8338db290b21743ad1e3c5bf460
Author: Jarkko Sakkinen <jarkko@kernel.org>

selftests/userland: Add userland test suite

This commit adds a kselftest suite for the userland control object,
namespace sharing, mount-namespace configuration, waitid(P_USERLAND),
pidfd_send_signal(), and userns_set_idmap().

> diff --git a/tools/testing/selftests/userland/userland_test.py b/tools/te=
sting/selftests/userland/userland_test.py
> new file mode 100755
> index 0000000000000..2b43adbbb4291
> --- /dev/null
> +++ b/tools/testing/selftests/userland/userland_test.py

[ ... ]

> +            with (
> +                self.closing_fd(rns.get_nsfd(CloneFlag.NEWNS)) as mntns_=
fd,
> +                self.closing_fd(rns.make_mount("tmpfs")) as rootfd,
> +            ):

[Severity: Low]
Will these parenthesized multi-item with-statements fail with a SyntaxError
on Python 3.9?  Parenthesized context managers across multiple clauses
require Python 3.10+, whereas Documentation/process/changes.rst specifies
Python 3.9.x as the minimum supported version.

[ ... ]

> +            def check_child_src_slave_locking() -> None:
> +                self.enter_userns_if_unpriv()
> +                os.unshare(CloneFlag.NEWNS)
> +                with self.closing_fd(self.make_plain_mount("tmpfs")) as =
tfd:
> +                    os.mkdir("sub", 0o755, dir_fd=3Dtfd)
> +                    Sys.move_mount(
> +                        tfd,
> +                        "",
> +                        Sys.AT_FDCWD,
> +                        "/tmp",
> +                        MoveMountFlag.F_EMPTY_PATH,
> +                    )

[Severity: Medium]
Does check_child_src_slave_locking() leak a tmpfs mount over the host /tmp
when the test runs as root?

When os.geteuid() =3D=3D 0, enter_userns_if_unpriv() returns without unshar=
ing
CLONE_NEWUSER, so os.unshare(CloneFlag.NEWNS) keeps shared mount peer
groups with the host mount namespace.  Mounting tfd onto /tmp before
making mount propagation private propagates the tmpfs mount into the host
mount namespace, and cleanup only detaches /tmp/sub, leaving the host /tmp
masked after the test exits.  Calling Sys.set_mount_propagation("/") right
after os.unshare(CloneFlag.NEWNS), as check_standalone_mntns() does, would
prevent the mount from propagating to the host.

[ ... ]

> +            big_buf =3D ctypes.create_string_buffer(65536)
> +            with self.assertRaises(OSError) as cm:
> +                Sys.userns_set_idmap_raw(
> +                    userns_fd, ctypes.addressof(big_buf), size=3D65536
> +                )
> +            self.assertEqual(cm.exception.errno, errno.E2BIG)

[Severity: Medium]
Does this E2BIG check fail on kernels configured with 64 KiB (or 256 KiB)
base pages?

userns_set_idmap() returns -E2BIG only when size > PAGE_SIZE.  When
PAGE_SIZE >=3D 65536, size=3D65536 passes the PAGE_SIZE check and fails lat=
er
with EINVAL because the zeroed buffer has no extents.  Sizing the buffer
with os.sysconf("SC_PAGE_SIZE") + 1 would exceed PAGE_SIZE on all page
sizes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122193539.3334=
213-1-jarkko@kernel.org?part=3D25

