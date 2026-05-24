Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E49AECD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 18:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0DE16B0092; Sun, 24 May 2026 14:38:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98056B0095; Sun, 24 May 2026 14:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86A76B0096; Sun, 24 May 2026 14:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 916006B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 14:38:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B084140CC3
	for <linux-mm@kvack.org>; Sun, 24 May 2026 18:38:04 +0000 (UTC)
X-FDA: 84803172888.27.C4B33DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 57A1FC000E
	for <linux-mm@kvack.org>; Sun, 24 May 2026 18:38:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uwh7sFf4;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779647882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3Bi0Oe3WKFBfhaQU3r6X4HozuqIOgvqoIFf+5sZIZc=;
	b=qy1DPRCgIlvfr3SSZpUW99CWbB1R7Ci48rlW3TAEqmiFp8Gd7rFJZIK5xEK0IoTdjUs9nL
	veGz9KkkIKpaz3yv7ASOI5wsdot7UIVmcpUznMJnNDJuNotjGQmDgtK14PwmJvc+7ZVfc3
	4Wy/iBk9chG294QFPS3ysw4gyLci3sQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uwh7sFf4;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779647882; a=rsa-sha256;
	cv=none;
	b=wI2H68/lQ3LzCiHe02OLJVvbDD5lktOile1GKvOWqu0C+wSnH+TFjOrtrheNQClbB46QBL
	Tx+NA0hpiF0pnK0dhEGnEb1BTVO68RmRM+C1xoL5DLmWU/8+Q/OTEa/nIZ3txNTLd0p3YF
	c0MaYlTKsOEcSzZ61opVu51jFPYBfRE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40E9A43235;
	Sun, 24 May 2026 18:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79551F000E9;
	Sun, 24 May 2026 18:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779647881;
	bh=Q3Bi0Oe3WKFBfhaQU3r6X4HozuqIOgvqoIFf+5sZIZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uwh7sFf4RD5Yq38Xgy34+NfDbBdUlUYgSFlPJ11B2Rz5xuIqQaGvAwPRVnDs+H2NE
	 srqBwFFgv9tPUpKxGI69a0PHyEeamCc5UwkwmadPCqgwUXEKLyCRo0ZNLqGytQnozw
	 tvi2qJmkUZof6aPzT8167tjjF9+YbZlpqQTIKUSqxO27oTXXs62GDQV46w5/zcRMzi
	 Bb8+WFX9sIVHan4ir79sNR8EOEVKvBkL12bwHS0/nnIpUFTOEZjd7ntlGstFwOqV9b
	 SKW/9we1IBt9Z05BvzUI3g+RLBJa9Qo8tt7m0z628vlqjSFXC5idio2X472mRy/9kL
	 syrMrM6tmuacA==
From: SeongJae Park <sj@kernel.org>
To: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/damon: add regression test for damos_walk() vs kdamond exit race
Date: Sun, 24 May 2026 11:37:50 -0700
Message-ID: <20260524183750.1810-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260524100258.36819-1-saileshnandanavanam@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 57A1FC000E
X-Rspam-User: 
X-Stat-Signature: 5r4k8e1o94dsmankyzegd4hjq9ppfo7s
X-HE-Tag: 1779647882-672356
X-HE-Meta: U2FsdGVkX19VXCH9wEwiuBe9fgsPYL9TRdxLRa4OunbcSEh0ajPLI46kbfOIyIzS6qr4mw8ngH+Mn/9Y3EuAjiPzcEXutyP2DQ3VtwMy6qf3LvZs96IIz18puRkwLFi2z0WpHu+ytUxc/gp3eKumA8MgEYp1Uk63XkLbeLal47UUByunLuapddMVk7lRCSI7mJtAWh8AvoaxGy6/fUoxNcOZZS4AeXabLxfOJUyJBmn/DM/Hc58z8Jt3U07GUM4kPmwFKPfXczR6JsMfliQ6e59Ucwi11PfYt+tFJly/5tUfZGm4nM9SQgjncwuJNt4uuruuAYTi1VCKMC4AUyduKMXvKLHp8FjvcKUQ8Gu38msRCpYd/2dYiw7yoQTMefcrIL3B7eQx/ZihdBR7GYEHUCH0Y8uAntyhI9suLKxbU9D8kksjo+ntiYmwfxE3HYsKQqA9jq/sEEjc/ktUEcNN03s/95mLrd/MsYUTP1yKfWi5zbWSxbkd9to20lAVKbL1L++wfNrIoiBL0s6pT25aCVgm5hUIrotTD7sEI0fKmtI+PWqrxMOMF/UyNX6anwsdreJYCGMLyC3MBxuGtroWGI3a8I9KDlNlSQ/UqHQg5ZAoSJO8V+2ouRSCKW06jVfiYaevSlr22wIGqnewAMQg+cuWZVVVwuud5zf09/WQtISH93FG6gLAt11+CZio6CMUSpkm8VPrXaMGvuNBAdm77jb4K6+eKHHyhCUMlM+a7CFUxHbSS18+PyMK4/r650MVeHbsQgDX6mVumqwTLrDuCyRGTsMHkZEeFBq49xPF7SwUaEnoCw1/WK/0pFRPe71N5YTwZELJ8aOxnI9Rg8jct4L2HkOdhb7XpnzW2TbPwGZgK5m1QbK7DZVKlXz0lYRuxGFGHJsJSULB/c1PpFGAniinfFbufaKgZXLgtp9LnJBsnBMyU3ibVLIaoICDpYljT4QTRXZ0Wprk1MGP/j1
 tDt2XUG4
 T6uJ274h1ML9c5YemOg+FrlkryytTt82scNlWcq7GJWa4+ZXASkLBNBelp+Es9tDIgs3vdNW0O0TZ5R6FGsv4KlU0F6fLQE2qgXvq7oVJV/yQMRgdiuml1l+1KlV/AJJBqI4jFMMPXgUuFfeat+JabPAUriWcxzXtZ+66tyPHrvajMVzda0poBXZkq4N62oUkp7Qp/rA7fsJfLLi/5AHyoAEyDzwg6UOQOMA1TKDcI2ae+upgUvT2gxsf5lcFFnYQsf3CICVFuIaEbPaL5GyHDb8XY+j7Nc0/wyF+qTWgry1AFb0tKnSwcdHEg2xDIJum3mA884NdwCJnKJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Sailesh,

On Sun, 24 May 2026 15:32:58 +0530 Sailesh Nandanavanam <saileshnandanavanam@gmail.com> wrote:

> Add a regression test that verifies damos_walk() does not deadlock
> when racing with kdamond_fn() exit.
> 
> When kdamond_fn() finishes its main loop, it cancels remaining
> damos_walk() requests and unsets damon_ctx->kdamond. Without the fix
> in commit 33c3f6c2b48c, damos_walk() could be called right after

Please use more common commit description format that has the commit subject.
E.g., commit 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs kdamond_fn()
exit race").

> cancellation but before kdamond pointer unset, causing it to wait
> forever for handling that never comes.
> 
> The test starts kdamond monitoring a short-lived process, waits for
> the process to exit naturally triggering kdamond termination, then
> rapidly calls update_schemes_tried_regions in a separate thread to
> hit the race window. Using a thread with join timeout ensures the
> test can detect kernel-level deadlocks where the system call blocks
> in uninterruptible state.
> 
> The sysfs state path is resolved dynamically via the kdamonds object
> instead of being hardcoded, and exceptions are handled specifically
> as OSError rather than using a bare except block.

Thank you for this patch.  But, is this test reliable?  I ran the test more
than 100 times on my system running a kernel that has commit 33c3f6c2b48c is
reverted.  But test always passed.

> 
> Fixes: 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs kdamond_fn() exit race")

This is not fixing a bug in the commit, so the above 'Fixes:' tag is
inappropriate and may only confuse people.

> Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
> ---

From next time, please add changelog on the commentary area [1], with links to
the previous revisions.

I was able to find the previous version on the mailing list [2], so putting the
link here for others.

Also, before sending a new version, please share your revisioning plan and give
time (about a daay) for others to comment about.

>  tools/testing/selftests/damon/Makefile        |  1 +
>  .../sysfs_damos_walk_kdamond_exit_race.py     | 82 +++++++++++++++++++
>  2 files changed, 83 insertions(+)
>  create mode 100755 tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.py
> 
> diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/selftests/damon/Makefile
> index 2180c328a825..60c83d6c318e 100644
> --- a/tools/testing/selftests/damon/Makefile
> +++ b/tools/testing/selftests/damon/Makefile
> @@ -20,6 +20,7 @@ TEST_PROGS += sysfs_update_removed_scheme_dir.sh
>  TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
>  TEST_PROGS += sysfs_memcg_path_leak.sh
>  TEST_PROGS += sysfs_no_op_commit_break.py
> +TEST_PROGS += sysfs_damos_walk_kdamond_exit_race.py
>  
>  EXTRA_CLEAN = __pycache__
>  
> diff --git a/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.py b/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.py
> new file mode 100755
> index 000000000000..8e8006d63926
> --- /dev/null
> +++ b/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.py
> @@ -0,0 +1,82 @@
> +#!/usr/bin/env python3
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Regression test for damos_walk() vs kdamond_fn() exit race.
> +#
> +# When kdamond_fn() finishes its main loop, it cancels remaining damos_walk()
> +# requests and unsets damon_ctx->kdamond. If damos_walk() is called right
> +# after cancellation but before kdamond pointer unset, it could wait forever
> +# for handling that never comes, causing a deadlock.
> +#
> +# This test verifies the fix by rapidly calling update_schemes_tried_regions
> +# while kdamond is naturally terminating (monitored process exits).
> +# Without the fix (commit 33c3f6c2b48c), this would hang indefinitely.
> +
> +import os
> +import subprocess
> +import threading
> +import time
> +import _damon_sysfs

Let's add a blank line before _damon_sysfs import, to be consistent with other
test files, like sysfs_update_schemes_tried_regions_hang.py.

> +
> +def call_update(kdamond, result):
> +    err = kdamond.update_schemes_tried_regions()
> +    result['err'] = err
> +    result['done'] = True
> +
> +def main():
> +    proc = subprocess.Popen(['sleep', '0.3'])
> +
> +    kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
> +            contexts=[_damon_sysfs.DamonCtx(
> +                ops='vaddr',
> +                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],
> +                schemes=[_damon_sysfs.Damos(
> +                    action='stat',
> +                    access_pattern=_damon_sysfs.DamosAccessPattern(
> +                        nr_accesses=[0, 200]))]
> +                )]
> +            )])
> +
> +    err = kdamonds.start()
> +    if err is not None:
> +        print('kdamond start failed: %s' % err)
> +        exit(1)
> +
> +    # Wait for monitored process to die naturally
> +    proc.wait()
> +
> +    # Rapidly call damos_walk() while kdamond is exiting
> +    # Use a thread with real timeout to detect kernel-level deadlock
> +    deadline = time.time() + 5
> +    while time.time() < deadline:
> +        result = {'done': False, 'err': None}
> +        t = threading.Thread(target=call_update,
> +                             args=(kdamonds.kdamonds[0], result))
> +        t.daemon = True
> +        t.start()
> +        t.join(timeout=5)

I'm not sure if this is reliable to trigger the exact race.  As I mentioned
abovely, I tried this test more than 100 times on a kernel that having the fix
reverted, but I was unable to make the test fail.  If it is that unreliable,
I'm not very sure if having this test is beneficial or just make people
confused.

If the test has no false positive, maybe having this make sense to
opportunistically finding the bug.  But I think the 5 seconds timeout is still
not very reliable on some case, and therefore it seems false positive test
failure is available.  If that is correct, I think having this test might only
confuse people.

I think having damos_walk() kunit test for its functionalities including the
walk_control_obsolete might make more sense.

> +
> +        if not result['done']:
> +            print('FAIL: update_schemes_tried_regions hung - '
> +                  'possible damos_walk/kdamond exit race deadlock')
> +            exit(1)
> +
> +        if result['err'] is not None:
> +            # kdamond stopped cleanly - expected
> +            break

Is the above if condition correct?  Could you please explain why having an
error here is expected?

> +
> +        # Check kdamond state via sysfs using dynamic path
> +        state_path = os.path.join(
> +                kdamonds.kdamonds[0].sysfs_dir(), 'state')
> +        try:
> +            with open(state_path) as f:
> +                if f.read().strip() == 'off':
> +                    break
> +        except OSError as e:
> +            print('failed to read kdamond state: %s' % e)
> +            exit(1)
> +
> +    print('PASS: damos_walk() vs kdamond exit race not triggered')
> +
> +if __name__ == '__main__':
> +    main()
> -- 
> 2.34.1

[1] https://docs.kernel.org/process/submitting-patches.html#commentary
[2] https://lore.kernel.org/20260524091812.35283-1-saileshnandanavanam@gmail.com


Thanks,
SJ

