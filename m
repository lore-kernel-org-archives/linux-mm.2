Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D31C87FCF
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 17:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647346B009B; Sat,  9 Aug 2025 13:48:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0AF6B009C; Sat,  9 Aug 2025 13:48:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497E36B009D; Sat,  9 Aug 2025 13:48:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36FC26B009B
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:48:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A94BC1DA7E4
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 17:48:44 +0000 (UTC)
X-FDA: 83757954168.26.8225117
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DD388140006
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 17:48:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y8nbYeg1;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754761723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7iN1/TVQIzWnaBbjH8QJk/0Q2lcOgPaBps+jeVc+Mc=;
	b=bI0/P7kGyNX3q3z2GVbMoXIJQKaBE7EJRagHJlXOvH5eQQdOVcNMO6w/XrtT7X3VKxT68R
	8hwuzt5cv47u1qDPPEN0bQY51NvpqDheqZ1rFC2vKE9Xe9L2uHx5yKaAn8XaH0nDgpgo6w
	3rhxYkSNrR0Ym8EmZBfsImZ4JDcHrJo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754761723; a=rsa-sha256;
	cv=none;
	b=BEQqqpXeBippA/7dR5QZdxMtXJ7rqISaE87uhyl4GXlH98LVCoHQAg613oK/kssHHdzJfm
	U5Wp/2AY7C+Jg7meASi0Lmmnh4p/kSV4W6/Tm7SUdx2kJa/yR+NzfPgpvQV2sDD8J09AE/
	3PGcDFlgL/ecATslxBVpKO1Lcq7zyk0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y8nbYeg1;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8421C43BD7;
	Sat,  9 Aug 2025 17:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B059C4CEE7;
	Sat,  9 Aug 2025 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754761721;
	bh=aKDkF5RSgXGbhrjBrkjvDv3sHb1LUhd6gxPgYdPrLoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8nbYeg1V3Bj9tiIH2hWtnSPho7Srv+KMTxfn8pnWyK6hdtiMxPK++yQ1KeQzD8eQ
	 a5piVkWP0R/tTqmdZvX1FRART50cKQqY+k4aaFndhzGuiooUZ5AEC0/UPqG1aBQhy3
	 IrizXo+tBDtE50v3H01dpCeW5NDq8x9ZYYk+GF3QsId5hMsTSjA9Lj9qt8M/ebSm9H
	 tvkKqiLd3e60qwo0HfrYiXBEHt/6q5vc776usWnQx3iSbKMLQSqq2KttmIOrQ1X/0z
	 ufPH6tli8Nb4LqKCQ4aWzu69tqHVpFozRoDsnbiaGFgZ8ZX/e+ZMvnZJQoJEHFoofl
	 eRucwiUvXLBoA==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: fix commit_ops_filters by using correct nth function
Date: Sat,  9 Aug 2025 10:48:38 -0700
Message-Id: <20250809174838.71485-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250809130756.637304-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DD388140006
X-Stat-Signature: 9nz1a1jqzt86userh7ho3jy8w37m4pxk
X-Rspam-User: 
X-HE-Tag: 1754761722-850993
X-HE-Meta: U2FsdGVkX18xVTu2n3F6vy7nBjdP/V1OVGRQkLrfVW5Fida1v2ZfypIBNuHWangpzwRNw9etqLrra8GWRj8agUZckfPIE+hSo3M+ciHRMf2CISOhbiTUcSYQbZZL489PnXvlO4XJSDa520bl2oMZI894C8NhJ+6VYDxVqa2SjN0IRQLbYNhMMpVzRHLDJdv+ZDrVC7/1edmV18sMvxexb7zLHgb3d7/SylwZTu1DD0c0NOTwKZJhxHTGAuOoHJvKoh9ZkeQ5bXyUNZf10Ak2wZF7FnqSx7ZQ5iQ3NuqpOWYEkTDcqmimCV/Y2vfxfKh9NfNeOykBkD16x2qJas3sm/5Fx7KE4AN77Pg3/IMQ6rPt1C1fhE7FS6QPEP+s98SrBBthuTThbNFy7JpY6zn0V9Nd5puWOrBPnz5zxjlP5CSeKGYmO62YkuxJjNIzs1Cg5sX5ZYvkaHKa3YxVYpNy7lKyf1RNK25EF6LPiGWElgqLF1NnxerRgPTh1+T510O3TlZPH2YdMLTb5wmigcO0bwu6YjAHo/kXc7dARixGeMlSYsOeyeICclC7L3/5KukuwApO2H/H3GPoe1q+l5RCFunL2EfeKQ8JhrSJL9rqWejEHP25E76lT1CitxdrQ4Indq0WTCcjFzSv4aJtMeWyfKP8Ud4Lnv23v3tRNsCIbztUBumzijj4pEgx5OWHnjNUd3ghj9M+Y9d6HuWRw/g1rapS3zK4I9DX168E1vFY0Uyy7XQq/li/BCmlMBMzJIIThBb1S3FW35nQ++VFTly67vV0u4Ej/hcanc8gBP1zOzHJmjgoQvEYlnm+l/goZhIDxt1abr2X8SIR2YF1QW9uPLIxqkpi5bX+mck22CpVPFxopLHZ+/wt4OetbKddODf4RGtNua9Jlr3FjkOzG+cIjTBzt87GzNm22Zsbiho8SZatEFJ0X4Ukc/KFrvS6ebWgIbgh7cUCeF4/2FvHBLR
 +ThdByXE
 9hTqNiAq34TeDmBXRWbu0GnCEQxPWG31SFVbjp3x8FnzF2S50FeNlL6OcJIgvFcX984FFRLTiNmKcSYdofMlaKRS61tsySbRedzkZkx3Fkn1Exxx32E8AAINuPY1q/0m957bTRmczYjucWoZGjNhi0bLBWyNo+XR2lsgmjAN/7UAsWWiW+kOesQYC9/GYFHlsOQU/UvxlD1nlR8KWChfgGEqLt5rqyIUShfYI4So1qNjlVi1fCUw/OWIt/jx+bmBJlkx7ek2njhv6dw5QsX39He4n+ZNWofHliUELsCAYhOyaVZk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  9 Aug 2025 22:07:56 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> damos_commit_ops_filters() incorrectly uses damos_nth_filter() which
> iterates core_filters. As a result, performing a commit unintentionally
> corrupts ops_filters.
> 
> Add damos_nth_ops_filter() which iterates ops_filters. Use this function
> to fix issues caused by wrong iteration.
> 
> Also, add test to verify that modification is right way.

As I mentioned on v1 thread, please drop the test part, for ease of
backporting.

> 
> Fixes: 3607cc590f18 ("mm/damon/core: support committing ops_filters") # 6.15.x
> Cc: stable@vger.kernel.org
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> Changes from v1 [1]:
> 1. Fix code and commit message style.
> 2. Merge patch set into one patch.
> 3. Add fixes and cc section for backporting.
> 
> [1] https://lore.kernel.org/damon/20250808195518.563053-1-ekffu200098@gmail.com/
> 
> ---
> I tried to fix your all comments, but maybe i miss something. Then
> please let me know; I'll fix it as soon as possible.
> 
> ---
>  mm/damon/core.c                               | 14 +++-
>  tools/testing/selftests/damon/Makefile        |  1 +
>  .../damon/sysfs_no_op_commit_break.py         | 72 +++++++++++++++++++
>  3 files changed, 86 insertions(+), 1 deletion(-)
>  create mode 100755 tools/testing/selftests/damon/sysfs_no_op_commit_break.py
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 883d791a10e5..19c8f01fc81a 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -862,6 +862,18 @@ static struct damos_filter *damos_nth_filter(int n, struct damos *s)
>  	return NULL;
>  }
>  
> +static struct damos_filter *damos_nth_ops_filter(int n, struct damos *s)
> +{
> +	struct damos_filter *filter;
> +	int i = 0;
> +
> +	damos_for_each_ops_filter(filter, s) {
> +		if (i++ == n)
> +			return filter;
> +	}
> +	return NULL;
> +}
> +
>  static void damos_commit_filter_arg(
>  		struct damos_filter *dst, struct damos_filter *src)
>  {
> @@ -925,7 +937,7 @@ static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
>  	int i = 0, j = 0;
>  
>  	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
> -		src_filter = damos_nth_filter(i++, src);
> +		src_filter = damos_nth_ops_filter(i++, src);
>  		if (src_filter)
>  			damos_commit_filter(dst_filter, src_filter);
>  		else
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
> index 000000000000..fbefb1c83045
> --- /dev/null
> +++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
> @@ -0,0 +1,72 @@
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
> +        return None, f'drgn fail: return code({rc})'
> +    try:
> +        with open('damon_dump_output', 'r') as f:
> +            return json.load(f), None
> +    except Exception as e:
> +        return None, 'json.load fail (%s)' % e
> +
> +def main():
> +    kdamonds = _damon_sysfs.Kdamonds(
> +        [_damon_sysfs.Kdamond(
> +            contexts=[_damon_sysfs.DamonCtx(
> +                schemes=[_damon_sysfs.Damos(
> +                    ops_filters=[
> +                        _damon_sysfs.DamosFilter(
> +                            type_='anon',
> +                            matching=True,
> +                            allow=True,
> +                        )
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
> +    before_commit_status, err = \
> +        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
> +    if err is not None:
> +        print(err)

Adding more context would be nice, e.g.,

    print('before-commit status dump failed: %s' % err)

> +        exit(1)
> +
> +    kdamonds.kdamonds[0].commit()
> +
> +    after_commit_status, err = \
> +        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
> +    if err is not None:
> +        print(err)

Adding more context would be nice, e.g.,

    print('after-commit status dump failed: %s' % err)

> +        exit(1)
> +
> +    if before_commit_status != after_commit_status:
> +        print(f'before: {json.dump(before_commit_status, indent=2)}')
> +        print(f'after: {json.dump(after_commit_status, indent=2)}')
> +        exit(1)
> +
> +    kdamonds.stop()
> +
> +if __name__ == '__main__':
> +    main()
> -- 
> 2.43.0

Other than above two trivial comments, nothing stands out to me.


Thanks,
SJ

