Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA9ECA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 16:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00FDB6B0088; Mon, 28 Sep 2026 12:55:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02A26B008A; Mon, 28 Sep 2026 12:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCCDB6B008C; Mon, 28 Sep 2026 12:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A286A6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:55:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 177821402B0
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 16:55:40 +0000 (UTC)
X-FDA: 85263772440.23.865FC6E
Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1899B10000D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 16:55:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oObjyTMi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of dmytrokoziuk68@gmail.com designates 74.125.229.42 as permitted sender) smtp.mailfrom=dmytrokoziuk68@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790614538;
	b=PfKFL+4GKPeZKHxQHx+1jeMZhQFmhNSRq9ls6jYQYRtl1PKXPlRKjxnnyEd80r9MsEOK64
	fv8tcbOoFCjHtPVakOYC4Sexqtum3g+wyiF66Bqkf202o36Lyu3ngUYWMKRb1HypEJ7wsG
	RK6JuAN4SXIQSFymhPqcFm83rdpK7+g=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oObjyTMi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of dmytrokoziuk68@gmail.com designates 74.125.229.42 as permitted sender) smtp.mailfrom=dmytrokoziuk68@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790614538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6s4XNqPyMsAZrWg+mBHW7PCfGqW8dSbNXXOuFI+D+8=;
	b=DoejOAdZ0Bp1ulT0MqqLKeedJB4EfzVDHR0WS8oyRtQwJiFOCiAwrCEn/YgnRLfP523/nv
	BRGjji9p5EP/cHMnbTqL10yhuhlLPVJ5WFgTqE7d9BY8bqaU1s3yusru4/lNPjjeRjZTBt
	FbpF5QAQHJ3CK1W+nLebwf3pBV8qJFM=
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-341d5303884so2267688eec.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:55:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790614537; cv=none;
        d=google.com; s=arc-20260327;
        b=mIDy8YtauzrvnGH/+R39kS80OT9Gmbh+Lanb2yi7kijUMmhWLE0AoTSTleBoaa6Z0l
         jHPAMrblfR+x9Vaw/DY+hTtFWVZqwLpGlJuaDgSywIsLOzCff/mOIfoklJl8G3ZaOxhM
         2AKN6PH6tgFLCXSMuUEUAwZ9nLtdMWvBmCXNDqzjeDFAnF0YvDSzSuIGIvtJnGPDvblI
         dc2875X574tshxto+KKaIr1VTEKTBu+WapJDnfN5+49xopakwpOkxJNEnl+du7nhP1Y+
         1U8/3lXf4J7Xpgv1rTWVg90mZ1XZT0+aL9Xh6guJpji/Z8oBfuuxAwODtnioGVcClhcA
         0BZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z6s4XNqPyMsAZrWg+mBHW7PCfGqW8dSbNXXOuFI+D+8=;
        fh=BX0JIZCRy+s4xtD/I2WsB0wbNTztz8efuv1vSalhm3s=;
        b=rnRy4BF2qEh6HkLWdkSKkt+xgu2rMrXoZYNZoCy+I0Crms2HgFZLpGWje9+wgsJIB7
         9suL0kMZF8B3nh0RcUEmdlHdlFulviq9tPe1K+Qr1aoaBG3PgxREb34lZoLJ19CfyiRG
         y4TchSajsb5SQ048RO/uZu1jnaMIC++hEb31JEjlzIsUyHtGshD/YfG+aeQ6ynGqCLsW
         VKwVwLJGXKQGBC21FeZU8LzLZztsnQ4TQLdrM4Zhr/hqA5DfK4fkGv5Y4aHMuMYVrn+0
         zaYVgHfelJ6B5AcjSvH4CuWSStK7CwPnM6LRvU6aG2cTv89/2OqaL+5U6+jYWL2Su0bF
         oDxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790614537; x=1791219337; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z6s4XNqPyMsAZrWg+mBHW7PCfGqW8dSbNXXOuFI+D+8=;
        b=oObjyTMi28QCgrMG70gwZNqXB6igqbeqdd7Q4xaY7oauOy0MnUrD29BfI7C1NidCLW
         i1lf9qqYFcHCNHETFVvSvC9NM/OPGGBSeLAWTG3hJ+ZtXJGKBX5EcVqInXoJzOfDKWkB
         8ODPPdGBZofJuGHZiKjnH59eF9Z/z5Xi2n5Z5HNWYKAuw7uhhrCEz2on9usuKze/kZ5/
         qrH2MzqqeT1/4p6umJhtx8OgyzPveOJKlTr4Rcj92IkylKX3mGU1lIIMyP4dBx6IF8to
         uWGV7Ep1KjyZFG9SxhkfQht76FBPAaIpmaPuySPUzqLe3CUyx/iSfjkMc9pm7JzpqpzZ
         jCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790614537; x=1791219337;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z6s4XNqPyMsAZrWg+mBHW7PCfGqW8dSbNXXOuFI+D+8=;
        b=QCA8O09kGXLRCBIHU4MkppkSu9TYgz2c+Kk83cVQmUE5zywCea+OnlU4d7BuEwIPWk
         WGtENUwLArJQOlsBBbQ6bb7H9AoX9aFOPKG0um9eiImLjtDq5Jgvav4dTot8bv+HK02O
         irYbpSjomzqWOX77vtOUh6Do+RZH4XdSK9eg13l62PImGC1cvOFHNcnnzk+jxYCwPzaB
         19b3SDMTzVAePuT7BvGXnyXVimrA4p0nlM9zcAFFrVG6fFH+dZPQrJDqmPkQRFwUpdsk
         Ij3zQvgrd3/s2BeSxpVgrAFt7YXxLhFdf6bkagOaCj9jPrx9DzV4WLTUxKv5VsrWODSP
         b1OA==
X-Forwarded-Encrypted: i=1; AKwUvByxmY5BqvpSOWpH8q0yGybuFwF8a7EeOf14NMogJTnw1/o0FCCU0RqxJIdHI/uAIBKIDLpSi+zllA==@kvack.org
X-Gm-Message-State: AFq9FYJjuN+2VPPmsj4PbgzNhAukRjkBUFoaka/N5URa7mA6Oa85BZ7O
	GDbfx2/54gsAni7Q25TyuCB+CjeK0DkbSFtahnbDUFNqyxYm594YvYLbcMcjHZ+5IIL8igGc1kx
	1NaO0+uLy1EQzY9VcYGZsWllXMlZa35A=
X-Gm-Gg: AYBFou0bX1B+3CtctnBxusbpyqjkiJEs7gdxRhPnOFszQ47TshIsefqZ+sioquJstqo
	YKycEJnmbi9M4ePZPQhvQdYUMau4sQKNsSBU8QR2f5Ln0FmIIXVe768HoaxX3zkRn8DjVLaL8BB
	WtCxmpOtW7FOK0Xi5QacKHFwOlbATh/bFVMslfU6pRAtdr1x/1eLyVl7IwDM7EER2uiQEtSomrD
	VwuQJO8CBz0zPYRabduP5JBxJPOyzs1ZV6fwW2slo5cQEkEr+G0+KW74Y+ReVyXQ7wGS+1L56jb
	QuQ0kjbHpjc8U0hA0HHpgDnS1VAh3nYFTiH8PpaWwWHcjXUkl3b2QJkFLmc91BsjIqHialAPMeU
	HNF6bSUggG0FirGB6H2HF/Qy5CNGtiBSCZGpJq7J1tMVr7WdOXzQQM6keFQ==
X-Received: by 2002:a05:7301:550e:b0:334:2bbe:ad6b with SMTP id
 5a478bee46e88-34271a8dd48mr10931201eec.22.1790614536711; Mon, 28 Sep 2026
 09:55:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260915160207.2952-1-dmytrokoziuk68@gmail.com>
 <20260915153542.3b9afbd00f7e6cea87a3350b@linux-foundation.org> <CAO63FDVJaRzwE_z4-Yd6Z8fZNEGQyx=YbeFatBN30d9X8SYLtw@mail.gmail.com>
In-Reply-To: <CAO63FDVJaRzwE_z4-Yd6Z8fZNEGQyx=YbeFatBN30d9X8SYLtw@mail.gmail.com>
From: Dmytro Koziuk <dmytrokoziuk68@gmail.com>
Date: Mon, 28 Sep 2026 19:55:22 +0300
X-Gm-Features: AclHuK8C0LQPHgVg0oAwvuYAM3nnvMC17hc19o0pmQNpDAVgyULxtsSzmjilem8
Message-ID: <CAO63FDUNVzMss61+TUYCWSezo1K1PL94iAdt=kNUoWepU=nhMw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: kmsan: fix iounmap metadata teardown
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: jujdt41m3855shi6urpu1fthtb9t5f1w
X-Rspam-User: 
X-Rspamd-Queue-Id: 1899B10000D
X-HE-Tag: 1790614537-591031
X-HE-Meta: U2FsdGVkX1+45BBsalszyyguhWoG7lel65+69ciwhAW0CzxrfwWdx0V5pt6zoncYSrYt/fMK4FxXOH8vApgXUJ4eDt9SD1MwMnBVkCKbFoXD2xXTK/EUiU72Vus6TUei8jwq4jNaTTNaJKVARtfmla8zhlmvhZx32Ao4vHGgkffyNtod2AYBm9kczVg5FM2ttQLHCs3zHeu4f//wWZqKAFz0U1sVs15EFFOeGapmckdBVOvQppFyVFpwZ0glUiS+cZmPFGCKwrZwMsmL0tw89zLRFicDyi5Obw2yMaIvMFdpxKaeWRqMg21UWZeuD/VsnOvZzAorHQbjvx35DhfVaXufCQMDh5XoUD6wvYjcr74wiVjWTBj8bC6JT/11FqN2v2Ssxkj4Y8USwYWY9tz/pv/pnWogwrNusuPmyK0VwHd0ZE8YNtJY54/KFr8KjWzacL8YngHas4W7jtbYoPkHyQ/AdzmXOPUYgqu+REYVaoyANO+NN10DFEu/qbEyEj7yLW8L6yYfYxerBRQhZLUf6EphCk7stjyx02aXpfjxPNaiSAAPkrAU2Wtve6HOoQRR+hCg9YokG6kB5ROcYpmUGtM1Zz9VchPSS4JZW06KsFkpB25BmJWK4Z7NKXKj73bZ48DJFQwRBlt0tTdnUFAMvzNjvF1xi7/f2qQtIz8pemLFu4Jxm5XZjLNbdxF+1j+AavlT/y744aQq0aRnY1KbVVXBCFXyhHaqxgsrV+3U9IIdSlQKux03rJoK/Gw8pFjSBtQdT3vUmsITvCXK2nZWd+XFrQk4MdRxO8V/10QPqM6x+I5O5CC/EWnCYPC7hTJHRptyjRS5NdXBrXtY+65SdGfcOV/jG6ouH5AcXSN8OmxneVD8DIH5u0YZA3cxUPZBA5kWuOap6l81KH3xCoiQcsXNeabAuPD6JH5sxvTvtUDAKjLgppmQ36H9jFB+CpIfQ0vPtULPSot2lhn/MVS
 YEkIkmi2
 JlOtmeiDcXEdIxlTgZhu5OfsG+LHgsw54J3CFcTd57e/tBtSi8XGrsJi8rwWWfUaRAseFpspQUVfLAEKZYuvw4aMcwS6nlO0mX5zXsIInG6Wo5u0WB7SkJbffxTPd+hgNAnF16D/PJ4ohW3TQhVt71nXCWCUytpA8MogmIfiDwji49pqepAU1wIAdSNQVSYwZxM75OOOXTtHUo/Ir9l+nBFFQ2gn8NYLRR6phvBjVMXJK/0BfYH4khBMJRzEqtqWBgpHqQaSffhnbB1OVkjtZDM7wxtum8waWIQK/RAZJU2jjZXN+CyK6W8nV2OTd/oYu0zxxD9bTXmIfpTzVNqPLTomHtV5ofNpbRV2Tzh0K45uKQtdH5IOXWv7gkAndv6VjENBnPIXalNzsAZPedXp2Mfnnfcnch+27JS6R5d+Ol3ELLHp3Hk5AHI1MAhK8HSHgH71PBoMh2S4WmKAzKBrQVwGfluehipkjWikTFmEzsL2Qca6FLVJ0ezNl7F//FBnUB0f1e8epwGfQhgZIsd0cUuoaMfU58G7374PT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Just a gentle ping on this. Is there anything else I should address?

Thanks,
Dima

=D1=81=D1=80, 16 =D1=81=D0=B5=D0=BD=D1=82. 2026=E2=80=AF=D0=B3. =D0=B2 10:2=
2, Dmytro Koziuk <dmytrokoziuk68@gmail.com>:
>
> >  AI review might have a found a couple of issues - please check?
>
> I don't think the patch needs to be changed for these issues. For
> normal iounmap(), the
> caller must ensure that the mapping is no longer in use. Also,
> the x86 implementation keeps the virtual range reserved until after
> kmsan_iounmap_page_range() returns and its TLB flush completes.
>
> For the kmsan_ioremap_page_range() error path, the mapping has not yet
> been returned to the caller. Cleanup and the TLB flush complete before
> the reserved virtual range is released.
>
>
> =D1=81=D1=80, 16 =D1=81=D0=B5=D0=BD=D1=82. 2026=E2=80=AF=D0=B3. =D0=B2 01=
:35, Andrew Morton <akpm@linux-foundation.org>:
> >
> > On Tue, 15 Sep 2026 19:02:06 +0300 Dima Koziuk <dmytrokoziuk68@gmail.co=
m> wrote:
> >
> > > While studying the code, I noticed that kmsan_iounmap_page_range() ca=
lls
> > > __vunmap_range_noflush(v_shadow, vmalloc_shadow(end)) inside its per-=
page
> > > loop, and does the same for origin. The first iteration therefore unm=
aps
> > > the entire metadata range, removing the PTEs for later pages before t=
he
> > > loop can recover their backing pages.
> >
> > Thanks.
> >
> > AI review might have a found a couple of issues - please check?
> >
> > https://sashiko.dev/#/patchset/20260915160207.2952-1-dmytrokoziuk68@gma=
il.com

