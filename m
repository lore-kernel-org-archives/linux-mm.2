Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E917C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 22:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0DA6B00A0; Fri,  8 Aug 2025 18:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26AC36B00A1; Fri,  8 Aug 2025 18:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A146B00A2; Fri,  8 Aug 2025 18:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC03B6B00A0
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 18:05:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DC845957B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 22:05:32 +0000 (UTC)
X-FDA: 83754972504.04.DEB7351
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf01.hostedemail.com (Postfix) with ESMTP id B7E2040005
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 22:05:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGcZUE1n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754690730; a=rsa-sha256;
	cv=none;
	b=ETlUHzYGQQHj7pCCjs5+clJ7YftCA5E8/eghKby+1gPiVvvw6yGUu1zIpE1rgFqGVZkRKu
	cgDUHVfJ+7d3Cvq3jm0/epBb/8wfa7xXCDYrtOnZTOV91Yqv53lAuDahe9NC/hsOgKtOo9
	egPPfvGmUOcOut2TaZLNTNWZwWxQQxU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGcZUE1n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754690730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYKYT7GKQlNFHwOwuSERUF1tTW8vMfmqHjrjAdxBcwI=;
	b=wRNvnFpKpaJ+LwihFRQhVoGoxyMu3tigjnY8dGBKviAAOCljzDomnHnw17o11W8R+8Q7cV
	u2FULVD9vJujV3eWBX9Ouwiz+mAjvIK45B0ceVgCocMhWJvMnBXT7DL0TL0h1c7LeoLoa1
	fpf0/uo8d8CJIdzTRUWHOqS2CAq1W54=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 02E0AA56BAA;
	Fri,  8 Aug 2025 22:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742AFC4CEED;
	Fri,  8 Aug 2025 22:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754690729;
	bh=pfGP4YkhAWdDQXnzRb1X7+xSMsz+/BM3ycyTOCBEH4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGcZUE1nNXn4BoM/oCYk/+0Bz2/6DINZSYVTNOQOTFZhbHe6KYaYn/Q3pDv+siVbA
	 mq1oW27vdPPEaUhAp3JGEzqYEpDq35bkYKyBq06V9PTdIh2p0Y3+QGRiDx9LTkr9Zb
	 /zgIbv1H5g+fVM2a77BlvwflfNNSPV16SlGLZ6oRPT0SaJG3dFVi9cQmeZtuQMwiWV
	 KAXoRx2yp+joRKfqCIAKu6ctb7RUZB8ma/bM6OYPgOFHxTigs35+mgdgqpbh4yU5Ek
	 hjybFPukDZ0fuua4v201yCkgzO7PPuINYj6iyntVPr/GZ/AbQ8RRVkXWhu9iYW8DZF
	 dcuUPAC05IFHQ==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] selftests/damon: test no-op commit broke DAMON status
Date: Fri,  8 Aug 2025 15:05:26 -0700
Message-Id: <20250808220526.49546-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250808195518.563053-2-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xt93ogzw3rn9ah3w1hhm6byjicgbiqxb
X-Rspam-User: 
X-Rspamd-Queue-Id: B7E2040005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754690730-377656
X-HE-Meta: U2FsdGVkX18oVrjfIWqwDinVeTfAYh6Jzgxa7GDqo3QXLMl9NfnlODVhF68bxfX2uHJ9a2WBi0IHNSjG3SUEwVaC/n7OEDX9Dr6EOId4DOCfHshMLEiX2wp0UleKzAJ9/0o8lzLZi2NYXBh7C3ZJeqXvUBkYgBa6e8wNKW0z824nSs1OHVLZEEYCgOpMF1ZjHOl3pAq30IZdBQXs7N0zNX8dpHt97xLcYKEjBKwoo16WdmKpvwhRN2899rBbdMgt5LZqROqOlp3PrlpIYO31z5zyiWUDB1g/VHmZyKv+Ikmh9VFaNuSGDTcZQVfwiiNi5cMVeiN2r9/MLXJPZTdPMZHbOSTlUrCUX0f+9QE6UXN3DeF3WfeuNbh2e2ta3TvFqa1Cc0CCVl+iaLiU91AtXH5MoNT1G5S5ELJ67bstuL4PlPUzMbrHXpd3GK8MVQpHXY/GnxHQaYiZAadqdi1cpivlrjHGJ1MdOTpx9i9ecrJV/I3EV9/hkoa1In5iRfGFn2C1uC2PNWDItBAeVPVAIYX1EDQOtFjQGk3iaaOdVrX2CqRHdDYjYdrXEhV5gNgA2wARJEAIFmBGGjndSVOxz0e+4sL2/Do0SPOJulN++cZ7pze7A3YrGIAHvPRnlX2GdDSxysuEYjdPVeooccFVwh1d4lmO+wHhl59baChbmSabW7naKol4qXIYwjt6Xx7BgJBpklq6RSCKXoFVOhK1/aTwKoNQfUI6BHZBEaRGPZLrRYUMcIVUVmplCW4lQwkI1xaKOcmsZBmBPw8UIrFWtJ2+Zx7sQDZNpYsntVh8wTocjt0scsVDMqcMLjtF9psEc2YDMmgzHOZAr/Up249dlFY1DFBtT0myXbdPyih6ySBHMe6jiIrX79gtnjycXhw3HeFC6WpGMBBk7lgZNvOWd3otL/LwagBHBhVogtkcTeA7sC9BWuDyivalxx2m2Qq30MhfWcjSGdPwfUKxiy3
 RVTt+XVx
 0ZWhWQ4dah1+FzmloM0dzi8/m6X6Qr5UsaG/ROgImMs5IHdMOBLKIot/lP/NmwKzvcBSChNTdkkL09AUHrRxxGk/Alo2NEv/FpVqGTrMB8UyS0jqG+OdrXDK9n/zEQZnZcgmnWbdLow+iXDqDuwJUO28fEh0/WbvHFGVlWhgJVNH00RRQoryn2+n4YuNXAryZr6rjE+M1Qi81V1bxFTS3IQBmM/aw4y268aUZWpeZVRN+WUs/ow90+EMpOoYr6gfcqKZg0bdH+EawFM3jRWNzrFHkDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Sang-Heon,

On Sat,  9 Aug 2025 04:55:17 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Add test to verify that DAMON status is not changed after a no-op
> commit.

Thank you for this patch!  I have some comments below, though.

> Currently, it is failing. but after fix the bug it should be
> success.

To keep bisecting goes smoothly, let's introduce failing tests _after_ their
fixes are landed.

> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  tools/testing/selftests/damon/Makefile        |  1 +
>  .../damon/sysfs_no_op_commit_break.py         | 78 +++++++++++++++++++
>  2 files changed, 79 insertions(+)
>  create mode 100755 tools/testing/selftests/damon/sysfs_no_op_commit_break.py
> 
> diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/selftests/damon/Makefile
> index 5b230deb19e8..44a4a819df55 100644
> --- a/tools/testing/selftests/damon/Makefile
> +++ b/tools/testing/selftests/damon/Makefile
> @@ -17,6 +17,7 @@ TEST_PROGS += reclaim.sh lru_sort.sh
>  TEST_PROGS += sysfs_update_removed_scheme_dir.sh
>  TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
>  TEST_PROGS += sysfs_memcg_path_leak.sh
> +TEST_PROGS += sysfs_no_op_commit_break.py
>  
>  EXTRA_CLEAN = __pycache__
>  
> diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
> new file mode 100755
> index 000000000000..300cdbaa7eda
> --- /dev/null
> +++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
> @@ -0,0 +1,78 @@
> +#!/usr/bin/env python3
> +# SPDX-License-Identifier: GPL-2.0
> +
> +import json
> +import os
> +import subprocess
> +import sys
> +
> +import _damon_sysfs
> +
> +def dump_damon_status_dict(pid):
> +    try:
> +        subprocess.check_output(['which', 'drgn'], stderr=subprocess.DEVNULL)
> +    except:
> +        return None, 'drgn not found'
> +    file_dir = os.path.dirname(os.path.abspath(__file__))
> +    dump_script = os.path.join(file_dir, 'drgn_dump_damon_status.py')
> +    rc = subprocess.call(['drgn', dump_script, pid, 'damon_dump_output'],
> +        stderr=subprocess.DEVNULL)
> +
> +    if rc != 0:
> +        return None, f'drgn fail : return code({rc})'

Let's not add a space before ':', for the consistency.

> +    try:
> +        with open('damon_dump_output', 'r') as f:
> +            return json.load(f), None
> +    except Exception as e:
> +        return None, 'json.load fail (%s)' % e
> +
> +def main():
> +    # We can extend this test to change only the Given and reuse the When/Then.

Above comment seems unnecessary to me, since that's obvious.

> +
> +    # Given : setup filter with allow = True

Again, I don't think the above comment is necessary.  And this looks like a
pseudo code more than a formal comment.  If you think it is necessary, please
use more formal tone.

Also let's not add a space before ':', for consistency.

> +    proc = subprocess.Popen(['sleep', '10'])
> +    kdamonds = _damon_sysfs.Kdamonds(
> +        [_damon_sysfs.Kdamond(
> +            contexts=[_damon_sysfs.DamonCtx(
> +                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],

Can't we start this kdamond with paddr ops, and drop the 'sleep' process
invocation?

> +                schemes=[_damon_sysfs.Damos(
> +                    ops_filters=[
> +                        _damon_sysfs.DamosFilter(type_='anon', matching=True, allow=True)

Let's keep 80 columns limit[1].

> +                    ]
> +                )],
> +            )])]
> +    )
> +
> +    err = kdamonds.start()
> +    if err is not None:
> +        print('kdamond start failed: %s' % err)
> +        exit(1)
> +
> +    before_commit_status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
> +    if err is not None:
> +        print(err)
> +        exit(1)
> +
> +    # When : No-op commit, it should not break anything

Again, I don't think the above comment is necessary.  And this looks like a
pseudo code more than a formal comment.  If you think it is necessary, please
use more formal tone.

Also let's not add a space before ':', for consistency.

> +    kdamonds.kdamonds[0].commit()
> +
> +    # Then : Check value with drgn

Again, I don't think the above comment is necessary.  And this looks like a
pseudo code more than a formal comment.  If you think it is necessary, please
use more formal tone.

Also let's not add a space before ':', for consistency.

> +    after_commit_status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
> +    if err is not None:
> +        print(err)
> +        exit(1)
> +
> +    before_commit_dump = json.dumps(before_commit_status, sort_keys=True, indent=2)
> +    after_commit_dump = json.dumps(after_commit_status, sort_keys=True, indent=2)

Let's keep 80 columns limit[1].

> +    if before_commit_dump != after_commit_dump:

Can't we jsut compare before_commit_status and after_commit_status?

> +        print("[TEST FAILED] : no-op commit break damon status")

Let's not add a space before ':', for consistency.  In this case, I think ':'
is not necessary at all.  Actually, since this test is for the single test
case, and kselftest framework will say this failed, I think the above print()
is not necessary at all?

> +        print("===== before_commit =====")
> +        print(before_commit_dump)
> +        print("===== after_commit =====")
> +        print(after_commit_dump)
> +        exit(1)
> +
> +    kdamonds.stop()
> +
> +if __name__ == '__main__':
> +    main()
> -- 
> 2.43.0

[1] https://docs.kernel.org/process/coding-style.html#breaking-long-lines-and-strings


Thanks,
SJ

