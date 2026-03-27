Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D70C10ED656
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493396B0092; Fri, 27 Mar 2026 06:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4445C6B0095; Fri, 27 Mar 2026 06:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3321A6B0096; Fri, 27 Mar 2026 06:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F22B6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:52:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA8ACBE66F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:52:29 +0000 (UTC)
X-FDA: 84591529218.09.C465CEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 190EB140003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:52:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a6Ir3LGz;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774608748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ASTkbCuo60cuDZ6QRJt2rSZR33L0KsQ+FX0RcxQxKY=;
	b=xsvMZ47ta6d872ORrk5Ip6iTNsuWkbU9KbpvEYI1BypHwU+SkP+rTMIMYhDM7DSywN3gBU
	tLdarCm5DVcrdrJG6hSgbRlg+eys5HIQHHKTaXcnBrL+1Pu0VQlO39y2O0sB5LcUIJGh48
	jnFfVfabJ8/yJVXiUWcIjhfO7SUY+DQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774608748; a=rsa-sha256;
	cv=none;
	b=do31QqdCPl4/a+npCQTt0gbBPUdpT8eSZyCm1CvrMIMRXJxnfVu1jPoa6THzISxhXZfiA9
	sncUir462YKn+qyNdUqdqfZF/Vh9WVnbpYhmsg/iFbUs8mVSFfckuGDbnnekTyg1U0dE/K
	MyH3Qu0/4s+V/v003DQurO9ECnnvehY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a6Ir3LGz;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE02E43ECA;
	Fri, 27 Mar 2026 10:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34928C19423;
	Fri, 27 Mar 2026 10:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774608746;
	bh=4SjsHNQaij4Ul47a0KgRgyuR0vjtulUGrJXCl85vN2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a6Ir3LGzyTB83PJvIQ/CLXPuP5nPRvr9yI7QVcyrd5yHPpzmYr2mYUbhPB2A5G4yu
	 Qwwe5Usq2090cT7Mpda7YiP/xkz8FPINVuqx8aTtD6qaCgFJi0Bo6/4aBw1pc66r1W
	 kzZ7YWIsiMyxyGAyKAD9FcrppppDor5aftRLLz5mLaSdKws55VP/ZkYTNeycaD1f6T
	 iahHUta+H2Y6ZjqhJWait0Av15TqwDHb84fMd3jrdvefEbJuC+5m2SzQqZTYR/zFMV
	 ZJPh8RVw6PIzPjqkEKW5XdAnSaolOinB9QKSuh7X5fqJXtaOnuIYJpW94LaTL1zSMj
	 aG2uzlsPMgzqg==
Date: Fri, 27 Mar 2026 10:52:24 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: akpm@linux-foundation.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Audra Mitchell <audra@redhat.com>, linux-kselftest@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
Message-ID: <815b2fc9-cee7-4bfa-8036-4b93d1b47b4e@lucifer.local>
References: <20260218184210.206466-1-audra@redhat.com>
 <c1b6f8eb-602b-4306-ad60-7a181fd94a45@kernel.org>
 <abludfGu4upPcyRI@fedora>
 <f635585f-7488-4bfe-8566-1c19f493c6a3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f635585f-7488-4bfe-8566-1c19f493c6a3@kernel.org>
X-Rspamd-Queue-Id: 190EB140003
X-Stat-Signature: eijunaswfss891wy3mj55dc36w3iegnx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774608747-454361
X-HE-Meta: U2FsdGVkX19gkImxo1gPF1jlD6uAyNswC0/E9F3JxpWxmCNwdown3tMUvntvoMbicIQtR5D395ONGL59GVEY5HZpEeYI1Gp/ro3Ramu+zYdLdS7gE923uWKk3v2aU6PIcGwRmMiF6SKMaMpyHhDaSzenSNahfQ5APpP8myrLBv+Lt8Nf8zfP9f8iWl4gkMNcQAuWNnrHPFDtEjyEbWD6zB8ljcOpo8f1SsiStPj9+l9mrGnU+Z2KpbtnI1MHmvHtxMWsIZsWMQRpWTI9ZFMGTwkbYluObzwItXDyqkua9c58e/QX4/rlNrRSDASEABcLbxd6oBVjtD9gV/8Xl3/687TXWCJ5HlIvwCWZ4OI+X2cQuEjKVpN0ev3UOZUUcu2ozqH/LO16it2mIEYS530qlMKk09vC40lgIYV6SBf5sy+H3bOU2NieZ1W/JeaPXQGF/fAXZY2dQSZb4LWqEZwOoIWPnID+rL60O33mEd/8g6eFqRxhq1BAgj5nWWSCdxps9MUELpfHmcEMdQhFD1WImyPGqml8VCrofLg1GwavtfJWG01pQbMdIFz6+QRjF2cZ7kc6kDj7feLS69lYCaoEE6+A3oF1n0PeBwAvjo1awkRgemOjOM0QQLgkSOcTXFhdnFsnhfo3yEUuoPW6BIMzhOeNpKBpkaEgdiDJfisDGmG66Qayi1h7LCg99BBj6nfFwVVAX+XvSAhA890tcVoSieTGMLAZw+zqkLnJ3b50ySvxPpMXejJ8tullzW2gtH9TZ/NvLyln0i69wEvR3GAnQ1+c9rV1p0u3s67md30KPHZMIwGHffD09P0fizawnn7JaUNNCvtg7ezhLH99vyMdu8VghVMm7z6qUqt2pR9E1sqcfd1nfiIzIKCQLqVAQY2tw1eOU1jeVOuVPV8FFqIFKbwRB6F+Ej5DZILoKmafXJOokr8nqABkz20cErV7SDlrxfC51hOFG35q2H73a1w
 nrrmM2ji
 5Reb6lWZcmAOT0vpxqCz8HtlwE9qrY54lsuDLQ2dUzxTKI9ubzryVOYGpxZdxM2MGO1wqwnkV9nz5F3FHKQrMy/a2cKzqmqI7Gsx9XRSV2l9aknghWUG/Pb6s+IQdJDLyuQe87B47n8iO9PJxsSkegkeGj9JCzD6+gTCZEkvrHwjZ00q1o7H3dtI5/g22bMJ/5Sbn4Wa4XjOOjqtWS2Q8tRh6o3x75rvtciFT5LsrlB13Xp13KwwLY9xQQTlOeicM+qO/OMLoqD0X9xxaI8xIfPavYxAIkBVT1ON51toc8DY+vS6/WDg7Q1x/GsMl0lcnuDP/dV4Hxl9S3Nw4XL84VznZNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 09:17:41AM +0100, David Hildenbrand (Arm) wrote:
> On 3/17/26 16:08, Audra Mitchell wrote:
> > Sorry! I missed this email so never responded!
> >
> > On Tue, Feb 24, 2026 at 05:15:14PM +0100, David Hildenbrand (Arm) wrote:
> >> On 2/18/26 19:42, Audra Mitchell wrote:
> >>> On architectures with separate user address space, such as s390 or
> >>> those without an MMU, the call to __access_ok will return true.
> >>
> >> Where is this __access_ok() you mention here? Somewhere in
> >> fs/proc/task_mmu.c?
> >>
> >> Where in the soft-dirty test is that triggered?
> >>
> >> I'm wondering whether the soft-dirty test should be adjusted, but I did
> >> not yet understand from where this behavior is triggered.
> >
> > The problem arises when we are checking to see what features/categories are
> > supported. The call chain for the soft-dirty program goes:
> >
> >   main()
> >     ->test_simple()
> >       ->pagemap_is_softdirty()
> >         ->page_entry_is()
> >           ->pagemap_scan_supported()
> >             ->__pagemap_scan_get_categories()
> >               ->ioctl()
> >
> > We enter the kernel with an ioctl, expecting to have an EFAULT returned (see
> > the comment from pagemap_scan_get_categories():
> >
> >           /* Provide an invalid address in order to trigger EFAULT. */
> >         ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
> >
> > Once we enter the kernel, we will check the arguments passed which includes the
> > call to access_ok:
> >
> >   do_pagemap_cmd()
> >     ->do_pagemap_scan()
> >       ->pagemap_scan_get_args()
> >         ->access_ok()
> >
> > Here is the path within pagemap_scan_get_args where we expect to fail return
> > the EFAULT:
> >
> >         if (arg->vec && !access_ok((void __user *)(long)arg->vec,
> >                                    size_mul(arg->vec_len, sizeof(struct page_region))))
> >                 return -EFAULT;
> >
> > However, if CONFIG_ALTERNATE_USER_ADDRESS_SPACE is enabled or if CONFIG_MMU is
> > NOT enabled, then we just return true:
> >
> >         if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
> >             !IS_ENABLED(CONFIG_MMU))
> >                 return true;
> >
> > The intent appears to be just getting the categories available to us and
> > verifying that we have the feature available for testing. However, this corner
> > case means the soft-dirty test will fail with the following:
> >
>
> Thanks for the information, we should clarify that in the patch description.
>
> >   # --------------------
> >   # running ./soft-dirty
> >   # --------------------
> >   # TAP version 13
> >   # 1..15
> >   # Bail out! PAGEMAP_SCAN succeeded unexpectedly
> >   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
> >   # [FAIL]
> >   not ok 1 soft-dirty # exit=1
> >   # SUMMARY: PASS=0 SKIP=0 FAIL=1
> >   1..1
> >
> > Since the intent is just to validate that the features are available to us for
> > testing, I think we can just modify the check so that we don't fail if we
> > return 0.
> >
> > Let me know what you think, or if you have more questions!
>
> What about simply testing for success on a test area, wouldn't that be more reliable
> and clearer?
>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index a6d4ff7dfdc0..489a8d4d915d 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -67,21 +67,26 @@ static uint64_t pagemap_scan_get_categories(int fd, char *start)
>  }
>
>  /* `start` is any valid address. */
> -static bool pagemap_scan_supported(int fd, char *start)
> +static bool pagemap_scan_supported(int fd)
>  {
> +	const size_t pagesize = getpagesize();
>  	static int supported = -1;
> -	int ret;
> +	struct page_region r;
> +	void *test_area;
>
>  	if (supported != -1)
>  		return supported;
>
> -	/* Provide an invalid address in order to trigger EFAULT. */
> -	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
> -	if (ret == 0)
> -		ksft_exit_fail_msg("PAGEMAP_SCAN succeeded unexpectedly\n");
> -
> -	supported = errno == EFAULT;
> -
> +	test_area = mmap(0, pagesize, PROT_READ | PROT_WRITE,
> +		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
> +	if (test_area == MAP_FAILED) {
> +		ksft_print_msg("WARN: mmap() failed: %s\n", strerror(errno));
> +		supported = 0;
> +	} else {
> +		supported = __pagemap_scan_get_categories(fd, test_area, &r) >= 0;
> +		ksft_print_msg("errno: %d\n", errno);
> +		munmap(test_area, pagesize);
> +	}
>  	return supported;
>  }
>
> @@ -90,7 +95,7 @@ static bool page_entry_is(int fd, char *start, char *desc,
>  {
>  	bool m = pagemap_get_entry(fd, start) & pagemap_flags;
>
> -	if (pagemap_scan_supported(fd, start)) {
> +	if (pagemap_scan_supported(fd)) {
>  		bool s = pagemap_scan_get_categories(fd, start) & pagescan_flags;
>
>  		if (m == s)
> --
> 2.43.0
>
>
> >
> >> Do we have a Fixes: tag?
> >
> > I always hesistate to add a Fixes tag on situations like this since this is a
> > corner case that was not considered by the original author. If we need a
> > fixes tag, then it would be:
> >
> > Fixes: 600bca580579 ("selftests/mm: check that PAGEMAP_SCAN returns correct categories")
>
> Yes, please add that. We nowadays also add proper Fixes tags for tests.
>
> --
> Cheers,
>
> David

Audra - to be clear this is discussion about mm process not your patch
specifically.

OK again I'm starting to think we just shouldn't support fix-patches at all any
more.

This is an example  of a change being done in a fix-patch that's _really_
causing issues.

Because this has now caused mayhem in mm-unstable and the 'kinda stable-ish'
branch now won't compile any self tests.

The fix in [0] on Chris Down's test series was for too many args to this
function (the patch changing this should have been rebased on mm-unstable and
changed Chris's caller there).

But now since this patch above ^ got yanked, that 'fix' has stayed in place and
now no mm self tests compile.

And now we see [1], hilariously.

[0]:https://lore.kernel.org/linux-mm/20260320195751.5b08b3e32ca835c3451d7bcd@linux-foundation.org/
[1]:https://lore.kernel.org/linux-mm/202603271115.uE9vpppi-lkp@intel.com/

This kind of massive levels of confusion and 'I am just trying to run some self
tests on what-should-be-for-next' is just not helpful...

I think we need a for-next branch that actually consists of stuff we genuinely
mean to take (i.e. review has settled) instead of 'literally everything because
we move stuff from mm-new unconditionally'.

Anyway we should revert the fix in [0] because it's broken now.

Cheers, Lorenzo

