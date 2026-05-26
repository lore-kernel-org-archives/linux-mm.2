Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D9BCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EEB26B00A5; Tue, 26 May 2026 13:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879246B00A7; Tue, 26 May 2026 13:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7415F6B00A9; Tue, 26 May 2026 13:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5CC6B00A5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:23:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA305C10E0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:23:36 +0000 (UTC)
X-FDA: 84810242832.12.CFD0B5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1D37118000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:23:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDnupCzN;
	spf=pass (imf24.hostedemail.com: domain of rafael@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779816215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBmrLR1ZbY+N01Es2izV7iJbI4gh7h+5gxo4g3lHGBY=;
	b=Z2+ylzMcnUAZmTx36lwaZHPmNZsUEDdObcZwaeti5c737ckBabRNbY3PtiRuXkkS2Gk7jv
	0T844mxpYXLJI5mOMglzomSdja2f0KOVV+GuBPJ5f/lBJ/O84x41oTxRumw/M0R1EFHnti
	eNH6WU54n86PiHJUoaktZyTPKdBYCGc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDnupCzN;
	spf=pass (imf24.hostedemail.com: domain of rafael@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779816215; a=rsa-sha256;
	cv=none;
	b=i3IoPvZ1ERtR0cHScuhO64vX7yBI79PfpCLdiZA4lFo/WlqRn6m3IR7QuU6lwgpv22VUeE
	u1OQCVGhRsbfeQT5d+4+JzoDyI8g3+TOShAcysrdH60+4o11RJUspJCsIvOBzM1XHVnxfa
	rDvv6mWJfU6BKN3FndH1yQPWFqdjkZU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 660D360018
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7701F00A3A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779816214;
	bh=sBmrLR1ZbY+N01Es2izV7iJbI4gh7h+5gxo4g3lHGBY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PDnupCzNPUbu6XeNWpdGhkEh5i/2jkZbkRTbyDHpaOolRbFKpP9GOtjcw4diHnMCU
	 dykjQbzNHA0OY8NL4FJdKBn06/9kaucq4tTiUkAb5VbR5NBpZ3Qr3TnJjSTD1lwgWk
	 XDHhqPBAQbhWLhkb6Li9tWAgbe16b6R3zKPGS5zMgSwLdvVocsYgOFvVaxA6pUz8Ht
	 m8ODfxgWJTGXfAHdeTifoxNOeDEuwzbXcvqAXttn2qST6i3zMO8tGEO7jRsg07hyr1
	 I8KRgfdaXTD/z9/Ev3kTfVb5pr+Bsxgw9qpBNL/yb6ahEqyUylN8nnVXBeppTGK0Mb
	 BhsPpoO77cjxw==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5a8891f0c88so6645430e87.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:23:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+giZnPwcP4ZpYfUgH5OJWsRBAKnqXPjFDEYK4HKx0kNjzHGLN74m13NSq0DutLHfPWuI9vYGEHNA==@kvack.org
X-Gm-Message-State: AOJu0Ywk7jeMKzezbhalrshpS0+rpvscmwKiWfcMjnGPgojNcgPjCAPi
	l3GKmJ6LdMtPzhDZbCWglcYa0O5CXwtPc+8ooZNUQqeLSLA1Rx0ULEdfDK0LjQb40e7aNIIEeNl
	zxI5zmS2y12k93GySqK5jzK3vxEwmtfQ=
X-Received: by 2002:a05:6512:2204:b0:5aa:b6a:9257 with SMTP id
 2adb3069b0e04-5aa32393ff6mr6223087e87.44.1779816212398; Tue, 26 May 2026
 10:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260414143200.1267932-1-charsyam@gmail.com> <20260414164937.1363887-1-charsyam@gmail.com>
In-Reply-To: <20260414164937.1363887-1-charsyam@gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 26 May 2026 19:23:18 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0iTx12iTfOXKV+MHAgSxY7MiDm6MrApzrxYuan7JQkpww@mail.gmail.com>
X-Gm-Features: AVHnY4KmTvgDP0QfkJkindj2_o5oLYnU2v4yWVRLWxJjVGvsdrthtVCLBw-f0GY
Message-ID: <CAJZ5v0iTx12iTfOXKV+MHAgSxY7MiDm6MrApzrxYuan7JQkpww@mail.gmail.com>
Subject: Re: [PATCH v2] PM: hibernate: keep existing uswsusp swap pin if
 re-selection fails
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Len Brown <lenb@kernel.org>, 
	Pavel Machek <pavel@kernel.org>, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 16yix7yyoe4g4t7fgpk75ghyhw9f7w37
X-Rspamd-Queue-Id: 1D37118000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779816214-216520
X-HE-Meta: U2FsdGVkX1/8pVtNJEPeVflv5504FNzdcOGmirLXtoZp2tbvqX+uxSnjIKJNysv387xr8AiWxRrtEW0+9uTnC0ozLhbgBqkW+qcinA5B84+Fyp8mTa8y9/rTfNlOAb3PWNDrjrVYaFz2rTNyeg2sQG2O7l0YGaXmaZhSX42aWlyrQNkMwoKfRbM1b9CLxjKHYqwHobq/C5BC8ESYAvgthgUevt06+ow/4Ic37ypwF71a+Qpi7ixN8BEdM4Cqh2Xi5qFAam6c3DLL2BSC0ZdjxYF2m/l/pR70RO5udqqmInC93aoxemcaYvPEGaBeQ8tekmjV4f2dbRvNb8S42T+xz6Qg7aeXdN+ssl0CapmdMdRB9gfqOb04quodvHaBB/8GcVMwi6901xo9bid6+cO9bnQ4lnm7BT7oLvXXLtYwdHUMEo0Largw2NVaE5q5O8zg4XjKH7oXoz8eKV1CaokmrQWK/Re2AQ2r6tJ9CCV5DuIZD55kLG9ltI5+HpTRcx69fVbt54BFA4IoeMCsDU7q78c2GxYGccr60mbdHzH6McrXQCxoTitqMoW0UYSXfytqn3/f1gmH5UeVgCvTrMEMj8oJHpE27Sv0VrZYZtUXsBJRLcbd1g0KHPA/FnQDqQX/plowhLLXEs+9gVX5J3drvhgNgcIdCxXiavAC+rvRVQ6TFH6uqE87T4l0RtqlyeWbltF1YJfp8k87xc1fo2/YeWjrf72p5MNhyc4FLypI3/3UCci/3MwZDWIKIhb9jjG3i5KT3puYpQTxf+moH2KkHCSFNOmPzDHtlu2CEdLG/XvZppQQmlGObtn+/vTw9g+W3TfrkRNgVyq9KTPUpcuyE/Lvds+YidIDlMCgfFsXyfcEbz65gehKXAXqwwmK9ZNRwkUgqCDFHWkvJyVQf3SFBVpZVhHjRvLtuJdfHDtoH4PsVX2Oy289biO8k8d823swZEk+gTksz0FhUBMs4jW
 Zv7NIbnU
 MqKl6fMk2/EBy/YUlcIR5XlYI6ikgtPJVWQBlwd6DlDuUnlVl5qSgoCc10nup1+5vytgciSjxQ2iQy6oTfqRYU9JwOCOjzndSeOkJ5dkAKv/3eQBIUUy38OHEsmrogrdjDVaGNhqgFKoJEioRa440BUsMa09/Uo2Gp/8w0wIzmOkX/k3XHHGPCtN+0G1/dBbvzrAX4V+tYqQP5p4LHIdvJXq2A84ygma8vQIXiViPAC+utBBxsFZCTuos988kkxB3vpDsvE1NEqCE/QRW5XYt14n4zDlVU0XNEnxSguXnzdGMhLlY6sdVaKs4KNQ1wuWkemsmhMZxikeMI1zk7QnFsVzJxPkqEd/0fmGCNblZGOT3mpE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 6:49=E2=80=AFPM DaeMyung Kang <charsyam@gmail.com> =
wrote:
>
> Commit 5b2b0c6e4577 ("mm/swap, PM: hibernate: fix swapoff race in
> uswsusp by pinning swap device") introduced SWP_HIBERNATION so that
> the swap area selected through /dev/snapshot remains protected against
> swapoff() for the lifetime of the uswsusp session.
>
> When user space issues SNAPSHOT_SET_SWAP_AREA again,
> snapshot_set_swap_area() currently drops the old pin before attempting
> to pin the new swap area.  If the new selection fails, the ioctl
> returns an error and user space is expected to abort the session.
> However, preserving the existing pin in that case makes the kernel
> side more robust against a failed re-selection, while keeping the
> existing userspace-visible behavior unchanged.
>
> Implement this with the existing swap helpers:
>
>   - look up the requested swap area first
>   - treat re-selecting the already pinned area as a no-op
>   - pin the new area before unpinning the old one
>   - leave the existing pin in place if the new pin attempt fails
>
> This keeps the hibernation session protected against swapoff() until
> /dev/snapshot is closed, even after a failed attempt to switch to a
> different swap area.
>
> Suggested-by: Youngjun Park <youngjun.park@lge.com>
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
> ---
> Notes (not part of the commit, stripped by git am):
>
> Changes in v2:
>   - Drop Fixes: and Cc: stable; reframe as a hardening improvement
>     rather than a regression fix, per Youngjun's feedback that the
>     current behavior is intentional and there is no concrete
>     user-observable harm.
>   - Drop the new repin_hibernation_swap_type() helper. Rework
>     snapshot_set_swap_area() in place using the existing find / pin /
>     unpin helpers as Youngjun suggested; the change now touches only
>     kernel/power/user.c and adds no new API.
>   - Update the subject and commit log accordingly.
>   - Add Suggested-by: trailer.
>
> v1: https://lore.kernel.org/lkml/20260414143200.1267932-1-charsyam@gmail.=
com/
>
> Baseline
> --------
> This patch is generated against linux-next at commit 5b2b0c6e4577
> ("mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap
> device"). Mainline does not yet carry that commit, and neither the
> helpers used here (find/pin/unpin_hibernation_swap_type) nor the code
> site this patch modifies exist there. The base-commit trailer at the
> bottom of the mbox records the exact commit.
>
> Testing
> -------
> The behavior change can be exercised entirely through the
> /dev/snapshot ioctl path; no actual hibernation cycle is required.
> A targeted assertion test is below; run it as root in a throwaway VM
> with two active swap block devices and one non-swap block device
> (three arguments).
>
> Run inside a VM on linux-next at 5b2b0c6e4577 with this patch applied:
>
>   step1: pinned active swap /dev/vda
>   step2: swapoff blocked with EBUSY while pin is held
>   step3: repinned active swap to /dev/vdb
>   step4: swapoff(/dev/vda) succeeded after repinning away
>   step5: repinned swap is blocked with EBUSY
>   step6: bogus SNAPSHOT_SET_SWAP_AREA failed as expected: No such device
>   step7: swapoff(/dev/vdb) is still blocked with EBUSY
>   result: pin preserved across failed re-set (hardened behavior)
>   step8: swapoff succeeded after closing /dev/snapshot
>
> Without the patch, step7 instead reports
>   swapoff(/dev/vdb) succeeded after failed re-set
> because the old pin had been released before the failed pin attempt.
>
> What the assertion test covers:
>   - SWP_HIBERNATION is enforced against swapoff (step2, step5);
>   - the success path moves the pin from one active swap to another
>     (step3, step4, step5);
>   - a failed re-selection preserves the existing pin (step6, step7);
>   - the pin lifetime ends on /dev/snapshot close (step8).
>
> What it does not cover:
>   - the snapshot_open(O_RDONLY) initial resume-device pin path;
>   - the full suspend-to-disk image create/restore flow;
>   - concurrent swapoff racing against SNAPSHOT_SET_SWAP_AREA;
>   - the type =3D=3D data->swap idempotent branch (not externally
>     observable since it intentionally skips the bit toggle).
>
> A normal sysfs-based suspend-to-disk cycle continues to work; the
> find_hibernation_swap_type() / pin / unpin paths themselves are
> unchanged. Build tested with allmodconfig and run-tested with
> CONFIG_PROVE_LOCKING=3Dy and CONFIG_KASAN=3Dy. The VM was booted with
> oops=3Dpanic panic=3D-1 so any WARN/Oops/BUG would have halted the run;
> the full test completed cleanly with no kernel log diagnostics.
>
> Reproducer (C source, for reference only -- not added to the tree):
>
>  // SPDX-License-Identifier: GPL-2.0
>  /*
>   * Reproduce / verify the SNAPSHOT_SET_SWAP_AREA pin-lifetime behavior.
>   *
>   * Run only inside a throwaway VM. The test manipulates swap state and
>   * leaves the target swap area disabled on success.
>   *
>   * Usage:
>   *   ./uswsusp_swapoff_repro <active-swap-1> <active-swap-2> <bogus-blk>
>   *
>   * Exit codes:
>   *   0 =3D expected (hardened) behavior: pin preserved across failed re-=
set
>   *   1 =3D old behavior: pin dropped on failed re-set
>   *   2 =3D setup error / inconclusive
>   */
>
>  #define _GNU_SOURCE
>  #include <errno.h>
>  #include <fcntl.h>
>  #include <linux/types.h>
>  #include <linux/suspend_ioctls.h>
>  #include <stdbool.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
>  #include <sys/ioctl.h>
>  #include <sys/stat.h>
>  #include <sys/swap.h>
>  #include <sys/sysmacros.h>
>  #include <unistd.h>
>
>  static int encode_dev(dev_t dev)
>  {
>         unsigned int major_num =3D major(dev);
>         unsigned int minor_num =3D minor(dev);
>
>         /* Match new_encode_dev() / new_decode_dev() in the kernel. */
>         return (major_num & 0xfff) << 8 |
>                (minor_num & 0xff) |
>                ((minor_num & ~0xff) << 12);
>  }
>
>  static int get_block_dev(const char *path, dev_t *dev)
>  {
>         struct stat st;
>
>         if (stat(path, &st) < 0) {
>                 fprintf(stderr, "stat(%s): %s\n", path, strerror(errno));
>                 return -errno;
>         }
>         if (!S_ISBLK(st.st_mode)) {
>                 fprintf(stderr, "%s is not a block device\n", path);
>                 return -EINVAL;
>         }
>         *dev =3D st.st_rdev;
>         return 0;
>  }
>
>  static int snapshot_set_swap_area(int fd, dev_t dev, long long offset)
>  {
>         struct resume_swap_area area =3D {
>                 .offset =3D offset,
>                 .dev =3D encode_dev(dev),
>         };
>
>         if (ioctl(fd, SNAPSHOT_SET_SWAP_AREA, &area) < 0)
>                 return -errno;
>         return 0;
>  }
>
>  int main(int argc, char **argv)
>  {
>         const char *p1, *p2, *pb;
>         dev_t d1, d2, db;
>         int fd, ret;
>         bool buggy =3D false;
>
>         if (argc !=3D 4) {
>                 fprintf(stderr,
>                         "usage: %s <swap1> <swap2> <bogus>\n", argv[0]);
>                 return 2;
>         }
>         if (geteuid() !=3D 0) {
>                 fprintf(stderr, "must run as root\n");
>                 return 2;
>         }
>         p1 =3D argv[1]; p2 =3D argv[2]; pb =3D argv[3];
>
>         if (get_block_dev(p1, &d1) < 0 ||
>             get_block_dev(p2, &d2) < 0 ||
>             get_block_dev(pb, &db) < 0)
>                 return 2;
>
>         fd =3D open("/dev/snapshot", O_WRONLY);
>         if (fd < 0) {
>                 fprintf(stderr, "open(/dev/snapshot): %s\n", strerror(err=
no));
>                 return 2;
>         }
>
>         ret =3D snapshot_set_swap_area(fd, d1, 0);
>         if (ret < 0) { fprintf(stderr, "step1: %s\n", strerror(-ret)); go=
to setup_err; }
>         printf("step1: pinned active swap %s\n", p1);
>
>         if (swapoff(p1) =3D=3D 0) {
>                 fprintf(stderr, "step2: swapoff unexpectedly succeeded\n"=
);
>                 close(fd); return 1;
>         }
>         if (errno !=3D EBUSY) {
>                 fprintf(stderr, "step2: expected EBUSY, got %s\n", strerr=
or(errno));
>                 goto setup_err;
>         }
>         printf("step2: swapoff blocked with EBUSY while pin is held\n");
>
>         ret =3D snapshot_set_swap_area(fd, d2, 0);
>         if (ret < 0) { fprintf(stderr, "step3: %s\n", strerror(-ret)); go=
to setup_err; }
>         printf("step3: repinned active swap to %s\n", p2);
>
>         if (swapoff(p1) < 0) {
>                 fprintf(stderr, "step4: swapoff(%s): %s\n", p1, strerror(=
errno));
>                 goto setup_err;
>         }
>         printf("step4: swapoff(%s) succeeded after repinning away\n", p1)=
;
>
>         if (swapoff(p2) =3D=3D 0) {
>                 fprintf(stderr, "step5: swapoff unexpectedly succeeded\n"=
);
>                 close(fd); return 1;
>         }
>         if (errno !=3D EBUSY) {
>                 fprintf(stderr, "step5: expected EBUSY, got %s\n", strerr=
or(errno));
>                 goto setup_err;
>         }
>         printf("step5: repinned swap is blocked with EBUSY\n");
>
>         ret =3D snapshot_set_swap_area(fd, db, 0);
>         if (!ret) {
>                 fprintf(stderr, "step6: bogus unexpectedly succeeded\n");
>                 goto setup_err;
>         }
>         printf("step6: bogus SNAPSHOT_SET_SWAP_AREA failed as expected: %=
s\n",
>                strerror(-ret));
>
>         if (swapoff(p2) =3D=3D 0) {
>                 printf("step7: swapoff(%s) succeeded after failed re-set\=
n", p2);
>                 printf("result: pin was dropped on failure (old behavior)=
\n");
>                 buggy =3D true;
>         } else if (errno =3D=3D EBUSY) {
>                 printf("step7: swapoff(%s) is still blocked with EBUSY\n"=
, p2);
>                 printf("result: pin preserved across failed re-set (harde=
ned behavior)\n");
>         } else {
>                 fprintf(stderr, "step7: unexpected: %s\n", strerror(errno=
));
>                 goto setup_err;
>         }
>
>         close(fd);
>         if (!buggy) {
>                 if (swapoff(p2) < 0) {
>                         fprintf(stderr, "step8: swapoff(%s): %s\n", p2, s=
trerror(errno));
>                         return 2;
>                 }
>                 printf("step8: swapoff succeeded after closing /dev/snaps=
hot\n");
>         }
>         printf("note: re-enable with `swapon %s` and `swapon %s`\n", p1, =
p2);
>         return buggy ? 1 : 0;
>
>  setup_err:
>         close(fd);
>         return 2;
>  }
>
>  kernel/power/user.c | 35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index 4406f5644a56..e1ab85db2e95 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -218,6 +218,7 @@ static int snapshot_set_swap_area(struct snapshot_dat=
a *data,
>  {
>         sector_t offset;
>         dev_t swdev;
> +       int type, swap;
>
>         if (swsusp_swap_in_use())
>                 return -EPERM;
> @@ -239,18 +240,34 @@ static int snapshot_set_swap_area(struct snapshot_d=
ata *data,
>         }
>
>         /*
> -        * Unpin the swap device if a swap area was already
> -        * set by SNAPSHOT_SET_SWAP_AREA.
> +        * User space encodes device types as two-byte values, so we need=
 to
> +        * recode them.
>          */
> -       unpin_hibernation_swap_type(data->swap);
> +       type =3D find_hibernation_swap_type(swdev, offset);
> +       if (type < 0)
> +               return swdev ? -ENODEV : -EINVAL;
>
> -       /*
> -        * User space encodes device types as two-byte values,
> -        * so we need to recode them
> -        */
> -       data->swap =3D pin_hibernation_swap_type(swdev, offset);
> -       if (data->swap < 0)
> +       if (type =3D=3D data->swap) {
> +               /*
> +                * Re-selecting the already pinned swap area is a no-op.
> +                * Keep the existing pin and just refresh the cached devi=
ce id.
> +                */
> +               data->dev =3D swdev;
> +               return 0;
> +       }
> +
> +       swap =3D pin_hibernation_swap_type(swdev, offset);
> +       if (swap < 0) {
> +               /*
> +                * Preserve the existing pin on failure.  This can happen=
 if the
> +                * target swap area disappears before pinning, or via the
> +                * defensive -EBUSY path in pin_hibernation_swap_type().
> +                */
>                 return swdev ? -ENODEV : -EINVAL;
> +       }
> +
> +       unpin_hibernation_swap_type(data->swap);
> +       data->swap =3D swap;
>         data->dev =3D swdev;
>         return 0;
>  }
>

This doesn't apply for me on top of the current mainline.  Maybe a
requisite change is still missing.

Please feel free to resend it when the mainline is ready for it.

