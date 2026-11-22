Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FF7606A333
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 20:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UTfB8wPx
Received: by kanga.kvack.org (Postfix)
	id B90806B05B2; Sun, 22 Nov 2026 15:28:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B477E6B05B3; Sun, 22 Nov 2026 15:28:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1876B05B4; Sun, 22 Nov 2026 15:28:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39A046B05B2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:28:13 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75B12C0565
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:28:12 +0000 (UTC)
X-FDA: 85463892024.26.678F128
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D599820002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:28:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTfB8wPx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795379291;
	b=KubdV+F3t85yNlUVix5KpdeWdAJjSD2+8GlP3DUryn+s1uV+JqWx18F5Ghm6pCCNv7OozL
	jQTYmhGEzTiN7RKFD+DsTujuE6s1c8EaMQy0FoL34kKREYkV8B+caDBYdD/Vr+ljR10YUG
	AUtH01WikdQucjxAPtkdAY+DoZymUSw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795379291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5BSMgQQGkCT/g88ue+zmET8GWlmL1qSQjkUJLeU+lc=;
	b=Ao9xUPaKi7D1RG+RbHd9Ln2q20TMlU6ylXsS0GyYeKXFeNJHaOofXdQ5LAFR3WoPaXTUsa
	uP4cHRyyk0NogLh+mCW619x4fwRgAZVmSDHbSg43WHmcf0GjBXLcm3JpAuB+8GlBWS9bN9
	JEB2za3T3Bvlvx+qnBPwl7nGRpe1yw8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTfB8wPx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2216343731;
	Sun, 22 Nov 2026 20:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD491F000D0;
	Sun, 22 Nov 2026 20:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795379289;
	bh=g5BSMgQQGkCT/g88ue+zmET8GWlmL1qSQjkUJLeU+lc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=UTfB8wPxS/LlttWVeNSAmOOn251pAFPKGOJAcNLbwE1FGdHIcbaDIJ2IvUdtupMPd
	 dVZ/mn2vHW/KnjNOIpN97gq2cSGqu7M0JJ7oIgH4pcIL+p3DRTxxQwz5d9lM+xhEAc
	 t4C5W8b0v4yWMiU6OY4tMqGjjcWnXhTe7Rtu98duTLm64VZeuMOafAONH4HwD5JVwm
	 VOUO+1QknJoLeQm1nU95gshjNy2lOFYLCcb80kTTZrKO4Zub+F/TNLKwGxI62ZGtaa
	 jZxpasS6M1LGE5d7L28NozicCEpV1qDnqfvd4iiQAxR94A4eNPX0gXsT0lgKuiQ6+f
	 4dvRXHczFhgoA==
Content-Type: multipart/mixed; boundary="===============7258520623913429804=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <ceb256f2afc7fa8c469f5f235f1e77aed593945868918788bc32ad76dee810ae@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-26-jarkko@kernel.org>
References: <20261122193539.3334213-26-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 25/26] selftests/userland: Add userland test suite
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:28:05 +0000 (UTC)
X-Stat-Signature: ueri7x3ojpnecw68pt1yhdnd4bbq5sgx
X-Rspam-User:
X-Rspamd-Queue-Id: D599820002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795379290-138631
X-HE-Meta: U2FsdGVkX19twBw8Fxdc9YltK8BmU/I/0E4lLb803HdpdxOo5G+83eOtAji56D1eiKbQGdBU5GfE6Yg9wks7yGFVGWMD7P3EP0VDD7n8QMbKer5s6txm1KDvhXql1vIes44V41fmcYgsBioETiQl75Gg2uBh7UIt6pbvUmgGkA55gcHFW79vDifO5ORvvDEbGr7JYvjvC+QwIOSyjnrZKtlK5i0yFJY3oufDVbh7dyanJUjFCpcQ+U7YQ23JVPc7rDkFbJiIQzHfe0lST6mt6K6nPLvlLMR94IX5qMsTd9nK9PbXdmRdpPGlJO1t79ytQcWFjzIFiEJv6E/We7gCQ6Tr5PrrkMgaJUY0/ZlPZg5A8InfqNZN3gOlG89cw3rPwIqo2rZdhixm+ZOe5uSiOKrPfW3lK3CIpH5c2EBMebE964vUeHRYJd/EGrOv3M8MWE2ERrF6/DI02aJrFc53q/lRRxwhxdRKp2W3ojzt3HMFUWufXmvG+u98WZ/6IoUbJZXlwwGxKBxCLr2LCFxJy3n0UtJzKnULarKJmqVt2pVzuS9t0fBgsZ4++0GtOJ9izvBrGG9t0crsKqlfomTJHD+Gf2a8ovrF9n4Jex7lXYgjHj7i1GAMmxVBmI8/YGnbSpS+6wbytNbPEHCarGlU8jKoJja1Cim0y9njcUx5ZmK0/PveeBgN1lgWeySFeSoey7QZ8pXD2+KM7DQ4mMD8TzRIEoxLKUucdPJhl3iX/Tfie+9V5/9XQk1AC952Xv6zGdoA3Mcz8UZZ3fyssCE3eELV5Pp78AdwqlwoUZxfzu1HASgtaDVsHAumrEV2O/T3BUwgY6ZVYpmFeRiFL9cUn45i5JevBIQ8SPyHySXUBHX+GxAenqPhIeIk8P9uHlj5H+5AxyULsYyj1yleGbxvSeFh/M4TFSpkReB7PrOUBfCHwln9OPHCWpu1+4nWdZMaZ3j2KmgptKg3T2vA1Vw
 mQoLxSAR
 920i4xnJulYJJfGy7Pl3knKmuujj56MpsKaidxVsTWFuWLVhZWFNDCT+tf5WULPLnWJWYuXaSvB9sEU70HXYVmbWh9QiFBZg2DKRUF5HZU1MVg0/vETVUfZwq1QWfIhhV+FyteiLxY44x6GtLHjwidTwQJEYvtjw1BwNtcMhf9zxT9/Pp1BKidpuXcbgnjTyl7gfyHxUo+sHo+5Ns+PKEL61nAjEb3IRAXAS7WzyHj+O73SdAiP8vyEjBW8Y+JAiXHj9900z3sbfqS+h/ZGo9R58nLQ9EaQGym9dnWki1H6ryeTYcAPaS01cXABnHcx/EONxcLsJYMNoeMZNce5l+W4jUo9Wv5LNXDzE4UPTNpiG1HbYxb4E/hjZUSfnylYAdcAdOfm1SpmcGfePRukVVI0GSQAqay/21nVJr6mdB2hJ6HL5x+4qK+ilT0CB9fpd9ePvsf3YG/o+lMDaImhrSW7zlTgIHa9GQses5z2gtEmuE1UyomkKw1kfSbaGEK11CJdN92TlO1whomDU/NJPP9UfgSjNLgrUDO/0mz7MLP2ogE7sysI4vuXY7Hg15YhKieSX521AqrhOeZIZnFju6ULIadxilHnlwlxZXcg8MMpY9rEejrmIRqlmjsqixKxXolTcOQ77KmNNmozzBurZujFMvydlNUgCuSlWpq3ld5eq125SwV54fHBVdJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============7258520623913429804==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/userland: Add userland test suite

TL;DR:
- Selftest run as root may propagate a tmpfs over the host's /tmp and leave it
  mounted
- Python 3.9-3.11 fails instead of skipping (os.unshare/setns need 3.12)
- E2BIG check may fail on 64K-page kernels

> diff --git a/tools/testing/selftests/userland/test_smoke.sh b/tools/testing/selftests/userland/test_smoke.sh
> new file mode 100755
> --- /dev/null
> +++ b/tools/testing/selftests/userland/test_smoke.sh
> @@ -0,0 +1,10 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# Kselftest framework requirement - SKIP code is 4.
> +ksft_skip=4
> +
> +command -v python3 >/dev/null 2>&1 || exit $ksft_skip
> +
> +DIR="$(dirname "$(readlink -f "$0")")"
> +exec python3 "$DIR/userland_test.py" "$@"

Does this wrapper need to check for more than the presence of python3?

userland_test.py calls os.unshare() and os.setns() at many sites, and both
functions first appeared in Python 3.12.  Documentation/process/changes.rst
gives Python 3.9 as the minimum.  On a 3.9 to 3.11 interpreter, with a
kernel that has CONFIG_USERLAND=y, the tests that reach those calls raise
AttributeError.  Inside Userland.run() the child does:

    except BaseException:
        os._exit(126)

so the test only reports assertEqual(126, 0), KtapRunner.main() exits with
KSFT_FAIL, and the run is recorded as "not ok" rather than skipped.  Since
the Makefile change adds userland to the default TARGETS, a default
"make kselftest" would show these failures on such hosts.

Would a check like this be more appropriate:

    python3 -c 'import os, sys; sys.exit(not (hasattr(os, "unshare") and hasattr(os, "setns")))' || exit $ksft_skip

or an equivalent hasattr() check in KtapRunner.main() that exits with
KSFT_SKIP?

[ ... ]

> diff --git a/tools/testing/selftests/userland/userland_test.py b/tools/testing/selftests/userland/userland_test.py

[ ... ]

> +    @classmethod
> +    def enter_foreign_pidns(cls, rns: Userland) -> None:
> +        with cls.closing_fd(rns.get_nsfd(CloneFlag.NEWUSER)) as ufd:
> +            os.setns(ufd, CloneFlag.NEWUSER)
> +        os.unshare(CloneFlag.NEWPID)

A subsystem pattern flags this as potentially concerning: a selftest should
not exit with a failure status when a prerequisite is missing, and should
skip instead.

os.setns() and os.unshare() are only available from Python 3.12, so on
Python 3.9 to 3.11 these calls raise AttributeError even though the kernel
is fully configured.  enter_foreign_pidns() is reached from
test_clone_flags_and_pidns_ancestry() through check_exdev(), and
check_dead_ancestor_pidns() calls os.unshare(CloneFlag.NEWPID) directly.
Both run under run_forked(), whose "except BaseException" turns the
AttributeError into a failure payload, so the result is "not ok" and a
KSFT_FAIL exit instead of a skip.

The kernel-side prerequisites are handled through SKIP_ERRNOS and
probe_pre_idmap_mkdir(), and the interpreter requirement is the only gap.
The Sys helper already calls the other syscalls through ctypes, so would
routing setns and unshare through libc the same way, for example
Sys._LIBC.setns and Sys._LIBC.unshare, remove the 3.12 dependency?  The
alternative is to skip when hasattr(os, "setns") is false.

[ ... ]

> +            def check_child_src_slave_locking() -> None:
> +                self.enter_userns_if_unpriv()
> +                os.unshare(CloneFlag.NEWNS)
> +                with self.closing_fd(self.make_plain_mount("tmpfs")) as tfd:
> +                    os.mkdir("sub", 0o755, dir_fd=tfd)
> +                    Sys.move_mount(
> +                        tfd,
> +                        "",
> +                        Sys.AT_FDCWD,
> +                        "/tmp",
> +                        MoveMountFlag.F_EMPTY_PATH,
> +                    )

Can this leave a tmpfs mounted over the host's /tmp when the suite runs as
root?

When euid is 0, enter_userns_if_unpriv() returns without creating a user
namespace:

    def enter_userns_if_unpriv(cls) -> None:
        if os.geteuid() == 0:
            return

so os.unshare(CloneFlag.NEWNS) creates a mount namespace in init_user_ns.
copy_mnt_ns() only adds CL_SLAVE when the user namespace changes:

    if (user_ns != ns->user_ns)
        copy_flags |= CL_SLAVE;

Without CL_SLAVE the copied mounts remain peers of the host mounts.  On a
systemd host / is shared and /tmp is usually a separate shared mount, and
nothing in the runner or setUp() makes the mounts private.

The move_mount() onto /tmp then reaches attach_recursive_mnt() with a shared
dest_mnt:

    if (IS_MNT_SHARED(dest_mnt)) {
        err = invent_group_ids(source_mnt, true);
        ...
        err = propagate_mnt(dest_mnt, dest_mp, source_mnt, &tree_list);
    }

so a copy of the tmpfs is propagated on top of the host's /tmp.  The
cleanup at the end of the helper is only:

    Sys.umount2("/tmp/sub", UmountFlag.DETACH)

and when the run_forked() child exits, put_mnt_ns() calls
umount_tree(ns->root, 0) without UMOUNT_PROPAGATE, so the propagated copy
stays in the host namespace.  After one root run, the real /tmp contents
(for example /tmp/.X11-unix/X0 or tmux and ssh-agent sockets) would be hidden
behind an empty tmpfs until it is unmounted by hand.  If the test fails
between the T_MNTNS move_mount() and the final umount2(), a propagated
/tmp/sub is left behind as well.

check_standalone_mntns() in test_pivot_root_and_standalone_mntns_hot_mount()
already guards against this:

    os.unshare(CloneFlag.NEWNS)
    Sys.set_mount_propagation("/")

Should check_child_src_slave_locking() call Sys.set_mount_propagation("/")
(MS_REC|MS_PRIVATE) right after os.unshare(CloneFlag.NEWNS)?  The later
set_mount_propagation("/tmp", MountFlag.REC | MountFlag.SHARED) would then
create a peer group local to the test namespace, and the slave locking
scenario would still be exercised.

[ ... ]

> +            big_buf = ctypes.create_string_buffer(65536)
> +            with self.assertRaises(OSError) as cm:
> +                Sys.userns_set_idmap_raw(
> +                    userns_fd, ctypes.addressof(big_buf), size=65536
> +                )
> +            self.assertEqual(cm.exception.errno, errno.E2BIG)

Does this oversized-struct check assume PAGE_SIZE is below 64 KiB?

sys_userns_set_idmap() only returns -E2BIG when size is larger than
PAGE_SIZE:

    if (unlikely(size > PAGE_SIZE))
        return -E2BIG;

On 64K page kernels (PPC_64K_PAGES is the default for PPC_BOOK3S_64, and
arm64 has ARM64_64K_PAGES), size == PAGE_SIZE, so that branch is skipped.
copy_struct_from_user() then finds the trailing bytes zeroed, req is all
zeros, and the syscall returns -EINVAL from the check on
nr_uid_extents, nr_gid_extents and nr_projid_extents.  The
assertEqual(..., errno.E2BIG) would then fail on those systems, which
Sys._build_syscall_numbers() explicitly supports.

Would a size derived from the runtime page size, for example
mmap.PAGESIZE + 1 with a buffer of that size, hit the E2BIG branch on every
page size?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============7258520623913429804==--

