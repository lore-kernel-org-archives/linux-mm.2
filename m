Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E39760A2605
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 21:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m2KafdzE
Received: by kanga.kvack.org (Postfix)
	id 5B4676B06E6; Thu, 19 Nov 2026 16:19:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58AD06B06F5; Thu, 19 Nov 2026 16:19:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479726B06F6; Thu, 19 Nov 2026 16:19:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE156B06E6
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:19:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B0B11A0C7B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:19:49 +0000 (UTC)
X-FDA: 85453135698.09.42E09F9
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8DD1414000D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:19:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=m2KafdzE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795123187;
	b=b8+IvwINO6TTZJy6TuCsON1JiWYx5Px6OMAyVIBFwYHXV3sgqFagfLaGvASwlReDA6LJbf
	2tvISp2X/rhLHeJzPApmtfcYrRB5SDwviRpMTZ0G81E0euTeWPL6Q0r1S/icS7rbnpkbMP
	iDOg9QE3oNE84UFBY+s677dvjWc+Kbw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795123187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRAMHZ4S62Yo6hlTBa8X3X3JUkjgdwr/B0EvJfR6wag=;
	b=jwH4H3D3tfEgYeqKu+WLkQwsU/9Ax/TYzbno7W0T4/mDsqIuMzegeAO96JdwLH+thmQ+FS
	/2BWphqmKhKiio5Sh6H9MDw5V6Kt5X+XPTZbzrRdJWMyw+OGyLS2tW7KJpgShS16M/vhii
	mav/gnH2jf/qUSwJPNkJMJJZLa8CB0U=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=m2KafdzE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b8784a3284so284613a12.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:19:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795123186; cv=none;
        d=google.com; s=arc-20260327;
        b=DiDfDb4f5Lj104ojUBtanJhEcT0lYpbpJER8WAQYAYDB2/C3EUslJtleVcJrcmU6yj
         +kP08Rp6Cu8XTrcvof+OOiyMLul42EZnJ3K/M/ebdrjiV+rg1oGAhZRRVyTbiCPa8LJg
         txO4D6uUFaY52735ylu6WpIwqPjaI28rETqPqTzdJ0aI1JhclJo5ck1dRdXlTWnDwBFu
         BGeeM+MgwL4lgwOGqSCbTjm/B1uf4xPpcWeVAoGBMYVhzResLYiVcyZB7hxu1As24WlT
         ax5m0osAuD3pAF7NSns0T6Kf5vmBTxM/yg5h64NjfO1bJVDE3/9u8kJ/9Kbf8b3VNPCP
         vS0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RRAMHZ4S62Yo6hlTBa8X3X3JUkjgdwr/B0EvJfR6wag=;
        fh=U4DPDflYGgBHD5KDDWiw6ORr1cVLaKEYl8gaA9iBbBI=;
        b=s+AyETl+mMPy9F04JgLmOFn9OLeHb0iczvEppAD9alLTE76ouyR9m0MAp3J/2okI6P
         DHmuG5NmJyqFp4EIeRxfj04Gxo9hrd1+Dut9qC4+T/kaW9w+cCWeTzW0x0iwuAdNJWi0
         JFZ/IJ6F8CoB5lvCa4GJ29fnTFEDBsIvA1qWBGQqBZQdjruRb3Afsag3SAidWblokhc6
         AOHs1KqyWbXiLNTgjQ1UFYUOzHZbVOUQHuwQSS86p+Ny44S1lM3L7f6I24pUQkfpuuCE
         OZnLaUAr4BCALkwmekdd2td6j9ocBXCenNv1TwKWtdIDX1JGmoApA9Rm9kZ8pe5a+Zu8
         I45g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795123186; x=1795727986; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RRAMHZ4S62Yo6hlTBa8X3X3JUkjgdwr/B0EvJfR6wag=;
        b=m2KafdzEgZF/kNYiBoV3H+4nuR4Yvad8acUw+iJJI8H16gUH6hx1nIEKfZaE4dcIoH
         ZXhbLHnwdt4tCJwZNe3jnQjW10zzlQB+TZf1F3cZhmbcOPwINUPXoZizzUROpKA/YcwC
         AoIuhzqrE+gpTC7+EIi/fJCHA9kO9Am/llF2jUP09xMv93tORssrQGGqkvxLXphfAfOV
         pDrwh5ao2ez7Mk50SoWSOZQarYhFx7QQXRsRAUn90ClR3X5t+8z0Pzpfg8pydIR7rTTw
         /tjNHHIvQzyjyHX8bHbb1IWRvjCyes4T8OR+Sh2FXx9oK1Nu0QU1dSLCSmL50BpI3fdI
         9KEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795123186; x=1795727986;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RRAMHZ4S62Yo6hlTBa8X3X3JUkjgdwr/B0EvJfR6wag=;
        b=NNbnYtCF4lg2VcXEXwQOcOEEF29/yBFt51m/fRteau5e+c9Rs+arAPoCS+fC6eo07F
         tkcCedd+wX2n2AJVc5sjIVg7Wttjk3ZFIJ/V8Wcogz8Wb0vTdKqI0/y9/YUcO8FuF+WT
         Asa8F671LJE2H1kLX/7l2JLlBhtutGp0kGzfqTzKQNG9n0mkG2Bb8KNOSIxeyhXKCNm2
         oySgUCpbAC/JV0gzEudmGVUoSKfmyUprNRdxhcJ0z90UouzF28MRxukuheXEpkpXPppz
         AMKWZDb38ilkp3pTDYCHPhnl5VPCV1HeNVi4dEerWV2eFQsMjvILmaiZ9uiuTE5jqyw/
         G3dw==
X-Forwarded-Encrypted: i=1; AL+hErEdMy5H3JdOfc0BZkrhaSqiz36Elm6U2NMW9uboJ91K4cO9i3TxugfnQkM80ep1yu2lRcvpC9zKmA==@kvack.org
X-Gm-Message-State: APuU4Z8qqulWUv1fdh02TBjJr/GVCfkvW5lc+eArrzIznF6Pj9u0rurF
	SMqMISuepSZ/G7sb4UGwCQfUsZEtD1+WafUGzpiMwxRWlSOWtDyjrZBvs1r53hTX22q7J9RVJRa
	xHrG3w0VW2SJ3xt5DXw1fBlT/YT/pbIY=
X-Gm-Gg: AYBFou1oqh0b4tCB1a+Kfa7Uv7o1XXdVLALUlkXgBLOeXZSUAtKbVijn9kxAOy/4o4t
	L6bm4NDgYD58j4cO+0nGK8KRsTEAChtGxfAOMlVt0Xv6xagng3r9S1ftaEf6jkQKxXRODMsYHZ5
	/vgIyiIbPLsW4haMcBy10v2dGnS7qBZo/JYbY3upp0Uutaol9wvHUr5jmZL1Su+WRdQ8HQ1btQl
	dE94+ERp69qrOFt19pPwa5PhR6kcuca7NiuKGQr3gRIy9nd1apUxoEIxX+Tft74jzYZNXnSJWNu
	GyjqEiQ9vO7MwiEcAbAJfTyUhldLIvN2FyKVVDu7NBkZ9WIZixUJngQFlQgQ/EvB07dJCGBpFPU
	r/x3GEVscovi8Pt4iHkAtWS+ByZ/vq7fHvWicJUraOI+WaaT0Jp58WFfNnEg+7lxKGUTliw==
X-Received: by 2002:a05:6402:4052:20b0:6b5:876c:a98f with SMTP id
 4fb4d7f45d1cf-6ba37ee52e4mr405100a12.34.1795123185728; Thu, 19 Nov 2026
 13:19:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxjHwtZEHu9xMM6zg9niSgNdLXhAu65jA8Ai_SKVg-W2nw@mail.gmail.com>
 <20261119183039.1505892-2-ptikhomirov@virtuozzo.com>
In-Reply-To: <20261119183039.1505892-2-ptikhomirov@virtuozzo.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Nov 2026 22:19:34 +0100
X-Gm-Features: Aa3M54qPR6beAzPiPDvVeM7eC1sDIvJDE2oypEtexE164vDya4GKLsVUqI-JH_g
Message-ID: <CAOQ4uxjj9inY=n-WP83_sYpuZBLKumxqiVACpseKuB2hkW-Auw@mail.gmail.com>
Subject: Re: [PATCH] selftests/cachestat: add overlayfs test cases
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Ding Feng <dingf3ng@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: neyk78t4wnuoip5rwy5srnjb4b8ojcb9
X-Rspam-User:
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8DD1414000D
X-HE-Tag: 1795123187-368473
X-HE-Meta: U2FsdGVkX1/pNCbNvYqtDAgpCuEOhaSjnobpmlhWsc3YGcnEtig390YyzFqobVLfSJ2ISHWbcWM7cZJg/b1pmD4oyRYgyL7Du7a7heRx3qlbDFIBN3SjQXWSVjSDdyONw24pNWfPmkK90OAApWXyQP2yDxpEgc4qhrQuoyc5kwXlfF8TG8uzmKV4k2laESAv31aKx9keNb7P8DRzKuR71nL8Jgk5wbMTraDf4FWNCzQ1gOE3dtXU5C9JaGymyQnBQRmSWcxUGZNKsYWAOvOqZKRfT9AlVyAM/gPRfb5LgB2U6If3dM5BUAaLewxpdzi1kGWaW5Nr2xR77Ix1+T0CB7SkV8qhtg+0qzHC7uHOYnGsNSdQPPo7XqcFY0mQBhw1ZnSLvusnJ9czAlES1yDv9D9hiXNvBsdbAJe+LRisteKsF+yhSZPWil8A3076gI9c6YGGSI3nRo02mUM+3+vfqCgfPJLm63e7mwxigm6uPS1Zr0R/b2yLh9XdjbcYw/VNqlVtb838pGa6eugByqqfox0IbNA8Co4D6zBtsaGrydcFaEhMEO2VOKWv6zLYf1oFBgVSD/TW9eR+2Ad/hm5lYLr5F6BKMj9fvEQXFOiFhXPjMCPy87K7sA8r6RegnpKm+YRbZA+7v7gqq3ereQVYmAel6xeeZx9MleE7cMYCUdZ80FHrBSqxzQ1i59TcHcY52RJSlzrbnWJKQkK7WJYFqci5Fn5kbM2+ltus/laDdi2cltN53+VilkViLXHK+ny0KCdiEqhyykymENCk4HtF8e4Jm/WLuVpPmOfT2HipyevFpooYfUQ5zs5hekhbpor9fIiNVSFmlqWx+ETMhLHCNcPhg5sxCtunMHmPA2zEFGTajXbyDh4MXImnFJkjHdeOpSciO+vIR/ztcRa70ltLRPZQwbpHriWgby3fx3ZVwdQS/BTOBZqVz3lL7ioQV7mp3TqJQCe1Ep4fsBaQfvm
 JKZp/RnW
 mPG7wOIcYsQdZQThGpfk6RDvTPat/LMUfxmj+WLBgKKZFUSy+yxiW4WmSF8j+N9oxeZfdFoOr7/P16Vq5k/y9Db75WypT0bvqbmfdDf8OYkHV+I1Gl99bv/gMabOryIpCugO3X0S37vByQGgwIgihv8RK5qkLh/WLr83NuCa/BbqQxuitz2xnL0Gh07wo3rgkPy2c4G+yClWR3naKRMfzw3iN3KQeE4Dqh0XOflX3daMQHJz2t0MGQA3qVmmiDyC9ZLpzZNW/d8itQUEmglWARzcTKNsyQMO/M2S/nwqnYk/ROLMXsws05L4z9oPnqIBXgXwcaSxKVRdWk2dQJiwFmiEoiOIesz5/AV8kh6GrQuV5CYIhcEkf9jn0D88Dqbn8ABv6GfFJE6fpTVJmaw9Al6O5jhMrvDyTBse9W9XXPz7O7H/JJYTJMJS1Rz2nUta+NoQWixf5YSqlLMeaKPNqRqFLrs5oWSVCPvPPiz9s8b0B54vA1gpuNlVUrkn9MMPk0bQh2rjtA1R7IAhweKJQu+1+zDh157xx1rxHaGd1NNWp9m6I8pjwL1CQ6OJhREaxc4ST33xnZHzheLARg6FtFVLLdkk+vPn676Ri83rdtx0JcLyE/dTKqrCJpBCDO70n7NNrUTCwMyvHkIAGrhEkXuNvxaAMQOTnp2eE6OUV+MNPe5Vj6VwBXIbPuJyQHYQ7iHB3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 7:34=E2=80=AFPM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> Run cachestat() on overlayfs files in four variants. The file is written
> either to the lower dir of an overlayfs or through its mount, so its
> page cache is in the lower or in the upper dir. Then it is opened
> read-only, so it is not copied up, and checked:
>
> - through the overlayfs mount: the page cache is one stacking level
>   down;
> - through a second overlayfs mount, which has the first one's merged dir
>   as its lower dir: the page cache is two stacking levels down.
>
> Overlayfs does not cache file data in its own inodes, so cachestat()
> sees the pages only if it is forwarded to the real file.
>
> Add a check_cached argument to test_cachestat() to check the pages of a
> file the test did not write itself, and bump NR_TESTS to the actual
> number of tests (it was 9 while ten were already run).
>
> The test rework and the changelog were drafted with the help of an AI
> coding assistant (Claude); the result was reviewed and tested by me.
>
> Link: https://lore.kernel.org/r/20261118123105.1247627-1-amir73il@gmail.c=
om/
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
> v2:
> - Rework of patch 3/3 of v1 on top of Amir's ->f_real() patch; the
>   ->cachestat() file operation from patches 1-2 is replaced by it.
> - Add lower file and nested overlayfs cases, and a check_cached argument
>   to test_cachestat().
> v1: https://lore.kernel.org/r/20260623111533.2285005-1-ptikhomirov@virtuo=
zzo.com/
>
> The nested cases pass only with Amir's ovl_f_real() recursion fix
> (https://lore.kernel.org/r/CAOQ4uxjHwtZEHu9xMM6zg9niSgNdLXhAu65jA8Ai_SKVg=
-W2nw@mail.gmail.com/)
> plus EXPORT_SYMBOL(__file_real) when overlayfs is a module; on Amir's v1
> alone they fail with "Cached: 0".

Posted v2 with your Tested-by:

https://lore.kernel.org/linux-fsdevel/20261119211542.1509119-1-amir73il@gma=
il.com/

Christian,

Please apply Pavel's test along with the file_real() patch.

Thanks,
Amir.

> ---
>  .../selftests/cachestat/test_cachestat.c      | 172 +++++++++++++++++-
>  1 file changed, 163 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/t=
esting/selftests/cachestat/test_cachestat.c
> index 542cd09cb4434..af8fa21c90ca1 100644
> --- a/tools/testing/selftests/cachestat/test_cachestat.c
> +++ b/tools/testing/selftests/cachestat/test_cachestat.c
> @@ -4,27 +4,42 @@
>
>  #include <stdio.h>
>  #include <stdbool.h>
> +#include <stdlib.h>
>  #include <linux/kernel.h>
>  #include <linux/magic.h>
>  #include <linux/mman.h>
>  #include <sys/mman.h>
> +#include <sys/mount.h>
>  #include <sys/shm.h>
> +#include <sys/stat.h>
>  #include <sys/syscall.h>
>  #include <sys/vfs.h>
>  #include <unistd.h>
>  #include <string.h>
>  #include <fcntl.h>
>  #include <errno.h>
> +#include <limits.h>
>
>  #include "kselftest.h"
>
> -#define NR_TESTS       9
> +#define NR_TESTS       14
>
>  static const char * const dev_files[] =3D {
>         "/dev/zero", "/dev/null", "/dev/urandom",
>         "/proc/version", "/proc"
>  };
>
> +static const struct {
> +       bool lower;
> +       bool nested;
> +       const char *desc;
> +} ovl_tests[] =3D {
> +       { false, false, "an overlayfs file" },
> +       { false, true, "a nested overlayfs file" },
> +       { true, false, "an overlayfs lower file" },
> +       { true, true, "a nested overlayfs lower file" },
> +};
> +
>  void print_cachestat(struct cachestat *cs)
>  {
>         ksft_print_msg(
> @@ -117,10 +132,14 @@ static bool is_on_tmpfs(int fd)
>   * Open/create the file at filename, (optionally) write random data to i=
t
>   * (exactly num_pages), then test the cachestat syscall on this file.
>   *
> + * If write_random =3D=3D true or check_cached =3D=3D true, check that a=
ll num_pages
> + * pages of the file are cached or evicted.
> + *
>   * If test_fsync =3D=3D true, fsync the file, then check the number of d=
irty
>   * pages.
>   */
> -static int test_cachestat(const char *filename, bool write_random, bool =
create,
> +static int test_cachestat(const char *filename, bool write_random,
> +                         bool check_cached, bool create,
>                           bool test_fsync, unsigned long num_pages,
>                           int open_flags, mode_t open_mode)
>  {
> @@ -161,7 +180,7 @@ static int test_cachestat(const char *filename, bool =
write_random, bool create,
>         } else {
>                 print_cachestat(&cs);
>
> -               if (write_random) {
> +               if (write_random || check_cached) {
>                         if (cs.nr_cache + cs.nr_evicted !=3D num_pages) {
>                                 ksft_print_msg(
>                                         "Total number of cached and evict=
ed pages is off.\n");
> @@ -294,6 +313,122 @@ bool run_cachestat_test(enum file_type type)
>         return ret;
>  }
>
> +static int mount_overlayfs(const char *lowerdir, const char *upperdir,
> +                          const char *workdir, const char *merged)
> +{
> +       char opts[4 * PATH_MAX];
> +
> +       snprintf(opts, sizeof(opts), "lowerdir=3D%s,upperdir=3D%s,workdir=
=3D%s",
> +                lowerdir, upperdir, workdir);
> +       if (mount("overlay", merged, "overlay", 0, opts)) {
> +               ksft_print_msg("Unable to mount overlayfs (need root?): %=
s\n",
> +                              strerror(errno));
> +               return KSFT_SKIP;
> +       }
> +
> +       return KSFT_PASS;
> +}
> +
> +/*
> + * Write a file to an overlayfs, either directly to its lower dir (if lo=
wer)
> + * or through the overlayfs mount, so that its page cache is in the lowe=
r or
> + * upper dir. Then open the file read-only, so it is not copied up, thro=
ugh the
> + * overlayfs mount or, if nested, through a second overlayfs mount on to=
p of it
> + * (using the first one's merged dir as its lower dir), and run cachesta=
t on
> + * it. Overlayfs does not cache file data in its own inodes, so cachesta=
t sees
> + * the pages only if it is forwarded one (or two, if nested) stacking le=
vels
> + * down, to the page cache belonging to the real file.
> + */
> +static int run_cachestat_overlayfs_test(bool lower, bool nested)
> +{
> +       char tmpl[] =3D "/tmp/cachestat_ovl.XXXXXX";
> +       char lowerdir[PATH_MAX];
> +       char upper1[PATH_MAX], work1[PATH_MAX], merged1[PATH_MAX];
> +       char upper2[PATH_MAX], work2[PATH_MAX], merged2[PATH_MAX];
> +       char cmd[PATH_MAX + 16], file[PATH_MAX + 16];
> +       const char *write_path, *read_path;
> +       char *base;
> +       int ret;
> +
> +       base =3D mkdtemp(tmpl);
> +       if (!base) {
> +               ksft_print_msg("Unable to create overlayfs base dir: %s\n=
",
> +                              strerror(errno));
> +               return KSFT_FAIL;
> +       }
> +
> +       snprintf(lowerdir, sizeof(lowerdir), "%s/lower", base);
> +       snprintf(upper1, sizeof(upper1), "%s/upper1", base);
> +       snprintf(work1, sizeof(work1), "%s/work1", base);
> +       snprintf(merged1, sizeof(merged1), "%s/merged1", base);
> +       snprintf(upper2, sizeof(upper2), "%s/upper2", base);
> +       snprintf(work2, sizeof(work2), "%s/work2", base);
> +       snprintf(merged2, sizeof(merged2), "%s/merged2", base);
> +
> +       if (mkdir(lowerdir, 0755) || mkdir(upper1, 0755) ||
> +           mkdir(work1, 0755) || mkdir(merged1, 0755) ||
> +           mkdir(upper2, 0755) || mkdir(work2, 0755) ||
> +           mkdir(merged2, 0755)) {
> +               ksft_print_msg("Unable to create overlayfs dirs: %s\n",
> +                              strerror(errno));
> +               ret =3D KSFT_FAIL;
> +               goto cleanup;
> +       }
> +
> +       if (lower)
> +               write_path =3D lowerdir;
> +       else
> +               write_path =3D merged1;
> +
> +       if (nested)
> +               read_path =3D merged2;
> +       else
> +               read_path =3D merged1;
> +
> +       snprintf(file, sizeof(file), "%s/cachestat", write_path);
> +
> +       /* Write the lower file before mounting overlayfs over it */
> +       if (lower) {
> +               ret =3D test_cachestat(file, true, false, false, false, 4=
,
> +                                    O_CREAT | O_RDWR, 0600);
> +               if (ret !=3D KSFT_PASS)
> +                       goto cleanup;
> +       }
> +
> +       ret =3D mount_overlayfs(lowerdir, upper1, work1, merged1);
> +       if (ret !=3D KSFT_PASS)
> +               goto cleanup;
> +
> +       if (!lower) {
> +               ret =3D test_cachestat(file, true, false, false, false, 4=
,
> +                                    O_CREAT | O_RDWR, 0600);
> +               if (ret !=3D KSFT_PASS)
> +                       goto umount;
> +       }
> +
> +       if (nested) {
> +               ret =3D mount_overlayfs(merged1, upper2, work2, merged2);
> +               if (ret !=3D KSFT_PASS)
> +                       goto umount;
> +       }
> +
> +       snprintf(file, sizeof(file), "%s/cachestat", read_path);
> +       /* Look at that page cache through the overlayfs layer(s) */
> +       ret =3D test_cachestat(file, false, true, false, false, 4,
> +                            O_RDONLY, 0);
> +
> +       if (nested)
> +               umount(merged2);
> +umount:
> +       umount(merged1);
> +cleanup:
> +       /* Best-effort recursive cleanup of the temporary tree. */
> +       snprintf(cmd, sizeof(cmd), "rm -rf %s", base);
> +       if (system(cmd))
> +               ksft_print_msg("Unable to clean up %s\n", base);
> +       return ret;
> +}
> +
>  int main(void)
>  {
>         int ret;
> @@ -317,8 +452,8 @@ int main(void)
>         for (int i =3D 0; i < 5; i++) {
>                 const char *dev_filename =3D dev_files[i];
>
> -               if (test_cachestat(dev_filename, false, false, false,
> -                       4, O_RDONLY, 0400) =3D=3D KSFT_PASS)
> +               if (test_cachestat(dev_filename, false, false, false, fal=
se,
> +                                  4, O_RDONLY, 0400) =3D=3D KSFT_PASS)
>                         ksft_test_result_pass("cachestat works with %s\n"=
, dev_filename);
>                 else {
>                         ksft_test_result_fail("cachestat fails with %s\n"=
, dev_filename);
> @@ -326,16 +461,16 @@ int main(void)
>                 }
>         }
>
> -       if (test_cachestat("tmpfilecachestat", true, true,
> -               false, 4, O_CREAT | O_RDWR, 0600) =3D=3D KSFT_PASS)
> +       if (test_cachestat("tmpfilecachestat", true, false, true,
> +                          false, 4, O_CREAT | O_RDWR, 0600) =3D=3D KSFT_=
PASS)
>                 ksft_test_result_pass("cachestat works with a normal file=
\n");
>         else {
>                 ksft_test_result_fail("cachestat fails with normal file\n=
");
>                 ret =3D 1;
>         }
>
> -       switch (test_cachestat("tmpfilecachestat", true, true,
> -               true, 4, O_CREAT | O_RDWR, 0600)) {
> +       switch (test_cachestat("tmpfilecachestat", true, false, true,
> +                              true, 4, O_CREAT | O_RDWR, 0600)) {
>         case KSFT_FAIL:
>                 ksft_test_result_fail("cachestat fsync fails with normal =
file\n");
>                 ret =3D KSFT_FAIL;
> @@ -361,5 +496,24 @@ int main(void)
>                 ksft_test_result_fail("cachestat fails with a mmap file\n=
");
>                 ret =3D 1;
>         }
> +
> +       for (int i =3D 0; i < ARRAY_SIZE(ovl_tests); i++) {
> +               const char *desc =3D ovl_tests[i].desc;
> +
> +               switch (run_cachestat_overlayfs_test(ovl_tests[i].lower,
> +                                                    ovl_tests[i].nested)=
) {
> +               case KSFT_FAIL:
> +                       ksft_test_result_fail("cachestat fails with %s\n"=
, desc);
> +                       ret =3D 1;
> +                       break;
> +               case KSFT_PASS:
> +                       ksft_test_result_pass("cachestat works with %s\n"=
, desc);
> +                       break;
> +               case KSFT_SKIP:
> +                       ksft_test_result_skip("overlayfs not available fo=
r %s\n",
> +                                             desc);
> +                       break;
> +               }
> +       }
>         return ret;
>  }
> --
> 2.56.0
>

