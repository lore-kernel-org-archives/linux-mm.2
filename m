Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C4D2CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 16:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7F566B0088; Tue, 23 Jun 2026 12:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2FCA6B008A; Tue, 23 Jun 2026 12:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA256B008C; Tue, 23 Jun 2026 12:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A0B046B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:14:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10BF3120467
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:14:04 +0000 (UTC)
X-FDA: 84911674008.18.98D0BE2
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id EF6C3180010
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:14:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VomVhN8W;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782231242;
	b=Zg4k9tsJi3r/oXB95kH0p3XfX6WjRqpiCT+J8vzTbShh9Bl4QR3b1eSMdPPMuZ96R93oZY
	tJq/51qSezfCmx/VGdp4Tm9CLCUAfV/2NIrzUGS5OIrLA120z/ZR4Mnmalcyw2x59r/gGK
	Kmt4z1Ugpg1bJJc/AIUaUVd4WLeBuKc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782231242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDwQwDzvONAtx0EaM5WMpABAgDhtGeMeJ2yvy/pReek=;
	b=m/p7lEPkFOOetGEtYlP6Y7lxbpD+MC49KlXno6YBfyxNpr/VH0TYuHejRXq8W2QfwaPd3W
	kGq78KfeDYdtTngcCquSmkYTgul3MvwGZRblqBq/okAWZaSA/JKYCNWi4Jqn4ZWULXhiFd
	i7TK1shYGhk1XkcPcvGICAeyZlljGfA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VomVhN8W;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4908b92904fso992755e9.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:14:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782231240; cv=none;
        d=google.com; s=arc-20240605;
        b=cJfD+S6CS1bsIoC7xc3AqRYzzgrMibEl80xcKaiV/KLKgkkUk6x9bFmo4Rur1GqzcR
         d7ICgb1gj5rzBhWzbh00WNqb+EH3GE9aZVw+FmJ7L8rb5duaDjT0he+thrZczVFVx/FQ
         /T2vb+BDfLA964fG83VmbrKF9Wxa4tancaR2Ds3i4cEFuQfRztOx9V8utru4rx/bnV02
         WiOzg+tn/aTGw7XuLTu6nvoC0f8XmukvmhgZI76nCghNjYzyACGVjpeQwUVody/6VtaK
         a5GYggM9J3af8Z7losQqrQoKhDGZFr3ZSUBGQi60Tws2o9S0TK7PfpI7IohRDoCf2WYh
         H9zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KDwQwDzvONAtx0EaM5WMpABAgDhtGeMeJ2yvy/pReek=;
        fh=AZoLbjsrojl2sMBEwbPAMnXFGWOEiblroRqsDriD4eA=;
        b=WHTVxrHIdtL8hjTkOxeBwBu+SLrxbbtm/x8Az7jc47tTAqOsxxrgaPfz8yH9lsMl5/
         KbVdLaQse/IPyQjZ3BBHLTU/krHJqiWlIjsrXnY2jEK6gaKwE6hyBOFO1fwubEkh62Cv
         vmMflMaBPFZ4vKaPO7Um9GV36E5migRPm7pLsz+adfhaPplovpqb19CkqaBoTkkpltzv
         nD/6JvyJ34ev3653/dTCZ3worwRGgskuplwsy389eTVrjjARQyl3GFqwBeHHWZY4+prL
         GZysS0281pf/KaueoBClUoTJRcA2zcDQdKPE4HxqRrW5G1LhdNALy0pKZlLaLBH8eYal
         5dtA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782231240; x=1782836040; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDwQwDzvONAtx0EaM5WMpABAgDhtGeMeJ2yvy/pReek=;
        b=VomVhN8WFtyR/ao4CAHCLCKEtUuvuuz/fsuo2408Pd6C3WEJJ7nXIUXMV3A+4Yl4qI
         RWeeWS9OLQ2Y0z2nrD72s14bc8Z42dld9axYlO4HMkP+w1SogrgKZM0VzCHMPflUiszJ
         4d6Liv/sS8ztiQJnHOL9qD3xhFnglv2QqmiXuuIvOAgrzT58m+aXBFaeH/KgqgjQNVyQ
         1NjawiJYGMCIdVoPrVtbPPCAQ0JPoSlKWZwgnz1POlM4Qal3nLDA+Fb6wPKsBF/Cteso
         YrJm8sNHmUCa46bcSoJkYk3VodJ5OC2AOuGVlpMOQueFRPlfZUdlG21ZDUqlk9KS6EC0
         EAjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782231240; x=1782836040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KDwQwDzvONAtx0EaM5WMpABAgDhtGeMeJ2yvy/pReek=;
        b=jMeaAMAuHJF+WGkU3zdpQApZX+/+bRsltfWYefsOVWGoDZgwtHx9LHfPUh+vFA9Mw/
         NMxiwWXbZEx9bOgf7BF+eWlCngUmYyG7/yAggg1+Q+wXPFXY+mAnw4O2amMLCoxvctgN
         Z9ZvRtF8X6Tagb2zFMYaypFrd/2nYjJLIl4gpvVfitvK6DteMqAdwpfm5dOV4pdKlyPQ
         x7S7NTrJotbOHUHJVpY28Qg59jvj34FDd9r7U3nEhlv6aJa4fLGtl5FGAxLyTKTgP05w
         AzKOmXs3bowQqy1MuLF4vtJYZ1NFJReJ1szCnp4UgC/fr10gGfeLHjIFljUpz7jrXczZ
         JcuQ==
X-Forwarded-Encrypted: i=1; AFNElJ/RSCMQWXOnd+xJggwkMbS+VwLgcsKyzLIfC4KBCeYrLMOutil0nTmVyQbeYRgyypM8MAG7mNsVGg==@kvack.org
X-Gm-Message-State: AOJu0YyCvb4c+QQDL34T+n2PKbce4m2ky0T0caZTJxvbX7Da5OX6gVBG
	0XGrGhf47GmY31CIkShdvXnwSbJgYFHMm2msIDTKbVY+KiqxmYYgMq23sQOmMYWXnMTN8hCciAd
	RaOh2zZlzrM6GDwqprlM3w3unwwhcaM0=
X-Gm-Gg: AfdE7cnx6aIGXPXl4ri74uyvwjmH+1muRrlng7TCzl9awsCG5Gh7X1eOkHBLYdRdcQP
	7zkJGK3Swm9+aXKz6r4MIJsKmHBhDz7L1NmOocsKstOI9mRxTcjbAxzqBNq22JV5UnBY/VGSiRD
	UEKKVy0ri/4J/vqf/5EwewJQdl7QoauYUSTahIwhgmZoF5HblB2ppe2jio9saJ6oVQCjZU+Ps1v
	80F674TPpc4vPULy/Q20XMQEUmdHn2nDuPYhoITJQbTuWgC4mITL1wnrDpTquBUnrqTbXBK3m+a
	eKWv8s25roq0k64GX7B8W/zSBmXC
X-Received: by 2002:a05:600d:4452:10b0:492:4caa:e2f4 with SMTP id
 5b1f17b1804b1-4925b39c123mr41296185e9.36.1782231240208; Tue, 23 Jun 2026
 09:14:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com> <20260623111533.2285005-4-ptikhomirov@virtuozzo.com>
In-Reply-To: <20260623111533.2285005-4-ptikhomirov@virtuozzo.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 23 Jun 2026 09:13:48 -0700
X-Gm-Features: AVVi8CcHejowD3jStN59P6Vi0fwypOnE949zrkPtRIHJOkgQQZWHlhkDWvN2F4k
Message-ID: <CAKEwX=PEE9=P-0=3mCRXArR9eL247P6SpDnYiGHp5zKZ4J+ETA@mail.gmail.com>
Subject: Re: [PATCH 3/3] selftests/cachestat: add an overlayfs test case
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EF6C3180010
X-Rspam-User: 
X-Stat-Signature: akbctu3o63ch1p9manxx8hxk66ggdyk9
X-HE-Tag: 1782231241-955582
X-HE-Meta: U2FsdGVkX189YHnpN9ohTSTfJdRg70LnzOHWXv+G6JzzkRzVLTvPNOSYuD6IgT+NSgp2+EnmDfVOVzXyOZACld83FxGCsC9R7tu9+h6n2qDlamAetZHntc1PcbZw6t+JRRcn+9wcO7uS010XEeJio6IaUiMkCZnfRaZetcTZaYjOzc+WIFBFiRQMXLkpvvfAmdvL4q2nH+qCEgGOkx9tn9Ioby5s2UofIBzBtQ6kbniO0TGTn7Jnqe5cOVVWEpySbNiykKXkRqrf4LRSW5EEkcPrqa8IjafhV3fgrTuoJga6XrHyC6rNqUUCnSQoYzQ18mL9Wp1gLbMZgvdhBHiW2u+DWQsaFlBH96AG1HzkxuT5rl6nf+e5cG4IOLG/kdGOOswTIF5aY77eJCL6HhEUMKjgirSaO8djcrlPizfD9Mo9U7jKMzqn2NaJZ1eiI0rowAcTL35VTmfsHcnmosp3+ee65Pq4MhPHrVBXjaBpxKuTM3vlDmmlteFQZOR4mdwW2FogkC6v5wv9lv9whQTqQ8jAT5twg7zw98xTfEYgnuRfgvw3qvuw4rwgAsjPFB5MErxAF6OQUiF2pZWtY7ZTsFuvuCoS7cbtW5Od6NJb8u2hGBVlC3F5+IjDfDv1hyEZvwCjtA9canrFfc9fg7vsLnfLXEHQvj92Ou2l8dplhtqm3nhVzVXLMchRzcHIOvdKy2yXdXDmSho9qUe2gyX9SebyTXsc90gl/2GH8QIUiRq0o9Xdl8nLfhKNXiYkxShXLKRvMzXHouC3hOrbqlMwnOjIZA/H7bNuhnnXrC0ax+hVh8r/hm74zVoeqxZDXTffzw4Q7l560ntMapaZ0MMqgafyz4TiNDz1JSYrbSNQhAktBcV0T10h0lWnInLzccajkhTB/Jood72fDnAecKj2MCYqUw0S483ZGB8B+JsxG835BlhA+Hg59CYIwPhx1KFTPn70xNyFnd1PmgwVJVC
 xuxyR1mE
 kD4a70Sn7ZoRts9OOn0/a4YiWqyWD7NPmJWF+LtIziYw2sIZCRVOo50COy2gNlXYgvPc2dODfQEembaRZBMh1JYCQOzW7J0C0mL/KtAaiyVNtftkY4ap95p+XHCsO7mCK1KvCXGEl7EAZXGi1ZhHe73TsQXJmiHNfuwlW4Ke16poF4dM8CLVqRcLyUaluYsMuLLDisKFYQohk2F+2V+QB1zV58rM9Ls4FxAFJs8+0+d5PpFGKEVk2SQnQGF7T7Nb/CvZygZjoBrNCzhjbi0Osoww0KYLUEXdQkzFW7vdxMzzDGlV/jZXuYF2pG4CI3FmxuGYO9QQaj3mzzhKgK3Ek+APm1jeulZXxoIEaip+9cEYb1FErblWYurJHIpiNasEqy6PzxctzGzD4sF6A9GFpLidVqOabZOmwPP50V3mcL54h4EQzXapypufPGc+b8hwpjVblthiSTVfMRhxJYUHWPIJFZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 4:15=E2=80=AFAM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> Mount an overlayfs, create and write a file in the merged directory, and
> run cachestat() on it, reusing the existing test_cachestat() helper.
>
> Also bump NR_TESTS to the actual number of tests run: it was 9 while
> ten tests were already executed, and this adds an eleventh.
>
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
>  .../selftests/cachestat/test_cachestat.c      | 75 ++++++++++++++++++-

Hmm this looks strange...?

>  1 file changed, 74 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/t=
esting/selftests/cachestat/test_cachestat.c
> index 542cd09cb4434..1662d9817c50b 100644
> --- a/tools/testing/selftests/cachestat/test_cachestat.c
> +++ b/tools/testing/selftests/cachestat/test_cachestat.c
> @@ -4,21 +4,25 @@
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
> +#define NR_TESTS       11
>
>  static const char * const dev_files[] =3D {
>         "/dev/zero", "/dev/null", "/dev/urandom",
> @@ -294,6 +298,62 @@ bool run_cachestat_test(enum file_type type)
>         return ret;
>  }
>
> +/*
> + * Set up an overlayfs mount and run cachestat on a freshly created file=
 in the
> + * merged directory. Overlayfs forwards data I/O to the underlying (uppe=
r)
> + * inode, so the page cache lives there and not in the overlay inode's m=
apping.
> + * This is a regression test for cachestat returning all zeroes on overl=
ayfs.
> + */
> +static int run_cachestat_overlayfs_test(void)
> +{
> +       char tmpl[] =3D "/tmp/cachestat_ovl.XXXXXX";
> +       char lower[PATH_MAX], upper[PATH_MAX], work[PATH_MAX];
> +       char merged[PATH_MAX], opts[4 * PATH_MAX], file[PATH_MAX];
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
> +       snprintf(lower, sizeof(lower), "%s/lower", base);
> +       snprintf(upper, sizeof(upper), "%s/upper", base);
> +       snprintf(work, sizeof(work), "%s/work", base);
> +       snprintf(merged, sizeof(merged), "%s/merged", base);
> +
> +       if (mkdir(lower, 0755) || mkdir(upper, 0755) ||
> +           mkdir(work, 0755) || mkdir(merged, 0755)) {
> +               ksft_print_msg("Unable to create overlayfs dirs: %s\n",
> +                              strerror(errno));
> +               ret =3D KSFT_FAIL;
> +               goto cleanup;
> +       }
> +
> +       snprintf(opts, sizeof(opts), "lowerdir=3D%s,upperdir=3D%s,workdir=
=3D%s",
> +                lower, upper, work);
> +
> +       if (mount("overlay", merged, "overlay", 0, opts)) {
> +               ksft_print_msg("Unable to mount overlayfs (need root?): %=
s\n",
> +                              strerror(errno));
> +               ret =3D KSFT_SKIP;
> +               goto cleanup;
> +       }
> +
> +       snprintf(file, sizeof(file), "%s/merged/cachestat", base);
> +       ret =3D test_cachestat(file, true, true, false, 4, O_CREAT | O_RD=
WR, 0600);
> +
> +       umount(merged);
> +cleanup:
> +       /* Best-effort recursive cleanup of the temporary tree. */
> +       snprintf(opts, sizeof(opts), "rm -rf %s", base);
> +       if (system(opts))
> +               ksft_print_msg("Unable to clean up %s\n", base);

nit: no helper for these? :)

> +       return ret;
> +}
> +
>  int main(void)
>  {
>         int ret;
> @@ -361,5 +421,18 @@ int main(void)
>                 ksft_test_result_fail("cachestat fails with a mmap file\n=
");
>                 ret =3D 1;
>         }
> +
> +       switch (run_cachestat_overlayfs_test()) {
> +       case KSFT_FAIL:
> +               ksft_test_result_fail("cachestat fails with an overlayfs =
file\n");
> +               ret =3D 1;
> +               break;
> +       case KSFT_PASS:
> +               ksft_test_result_pass("cachestat works with an overlayfs =
file\n");
> +               break;
> +       case KSFT_SKIP:
> +               ksft_test_result_skip("overlayfs not available\n");
> +               break;
> +       }
>         return ret;
>  }
> --
> 2.54.0
>

