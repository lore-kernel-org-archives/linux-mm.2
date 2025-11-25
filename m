Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF37FD0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13CA26B0098; Tue, 25 Nov 2025 13:44:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113EB6B009B; Tue, 25 Nov 2025 13:44:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050846B009D; Tue, 25 Nov 2025 13:44:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8C4E6B0098
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:44:21 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95B24160384
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:44:21 +0000 (UTC)
X-FDA: 84150004722.15.EB3A79E
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id A213240015
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:44:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JvZMG97S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764096259; a=rsa-sha256;
	cv=none;
	b=bCDI0QjJmRbMKOTG0Q1AWzsb5sBXCJQWnC7MBsvObtAyGMRy41VAp9WZVadbwwyvMpFemo
	5gD/vObJl/locxNun+VTEPlj3U25YKhAG7R6EhqlXdbB/+Cl5OO63L5EvYI5gwx0jkh0cm
	YrF7lnB1nh3q11haiXzN+RtcmOxWvpY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JvZMG97S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764096259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EuCC5DFWaWyOL4X15A+FY0iDuG43APf6t+DuwQP4zFQ=;
	b=L5q2IxJeTmrX/mEw+t7yk9kOGcrwcbhMHAjFW5lBFHayDsIGXSuEqNbwYS2/P243PFklOs
	ce8QDNxsJl/cSSq/RlbzVLnTRtw7SgEv98J7VoBiQYWREinqzTaD5Q1qNzDw3O93zk8k8H
	cBhz66ORrCpmxpzM1f6AXqmxDV+Pe7I=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-78ab039ddb4so22957437b3.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764096259; x=1764701059; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EuCC5DFWaWyOL4X15A+FY0iDuG43APf6t+DuwQP4zFQ=;
        b=JvZMG97Sb8LhdxqjV4d+muthmnSwmmtTmxY9gjPD99mM41azwkuhVCO7yoQL1kmVCX
         REGCjAomGl8ZVdJAv46YkywvkZ79qt+RO147Ryf8c+kOZgQj4ymmblRIDM7JgHWBmNmp
         3a2pSckPzi93K78ukBL/CBzilVvqCYzioZAZeGehZHdPtUPxH317Xkw29spC2mXuZ0qN
         r9beQtBISLaly1d+z/O2PEteyAO9JcHa80gHCiBOTjEQYxg7+HMyO/qWtS8B87sxBfsS
         gUfqZ5463MDgxL7ACZV2+lz5Q63SRd28jeIjmgKt9b/605gBh4M//3cGK9DR8WI8FKuS
         bCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764096259; x=1764701059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EuCC5DFWaWyOL4X15A+FY0iDuG43APf6t+DuwQP4zFQ=;
        b=xFeHyXOc+ICy/rLFHCegmP4Sg40MzxbUWGR/59ztAkul92CGlgLlKqXIDWqoHb5aIq
         fOkWDAf+KPlzbNTL3CTYG9Ta5liQn8Z9WACu+0lkf/D3lzZnApdV4WwXs73qauDTJC4k
         zwGm0ktbLOiX5iCMdzWAWJxaxYVh3B4j8Usv4xunBp1tJ4MQxARay/llt+9fHDTN5GbN
         DWPb46i3XR6d/x58VblDyvBFZVe2OK/1dwVTaIyZh9QPHPVmiUosxAglpkp2wiWPHWoe
         8pfjeQGUK/lbYZqstdwsuMTYNXSz065Ec0ucpwyINuHxf1M3v3YuiRuTLSbMpr778ODJ
         4qgA==
X-Forwarded-Encrypted: i=1; AJvYcCVqlJNGxm5+YRKO4NFQ17Eos3uj8uy8bPHS2w7OHmecVcs0Pxlbwp+UqsOoGqiDA5Wwu9E0jegIvQ==@kvack.org
X-Gm-Message-State: AOJu0YzCAnAVWPpYiHUPS8QwZFa1nPYhGXWPn9FVcw7S4IPQ3AfLK/dB
	DtDqaKwWxKd/kLMdylWpBxoghf/Z7asGOq4oKdmkQFfRVEacmb0v01IP
X-Gm-Gg: ASbGncuxr9uCPiTfH9/Si9KAAkNDLue5t4wI/OxttR8yWBceARBfNJnDNcGfrDP1edm
	J9KNX7auMkbIogNUom4Zlo6R84CtC6sX9+XTfnbvR0KESjQeOyWe2+HHBNcm8tIXejkVPBuwaJV
	8IAhs4RybvZN0oGw7sTSEfsIZdhOVgjJkICCi2efMsvNq3X54aib5IlOEN0p2z4enQSku5Gee9l
	d3SzKFo405tzzUesyk9MdnuWKzC578w7Tpp/261Lq1G4qPlQxbI/iw7odAOOZhKVs2vxSf0oO91
	+K12etfWpeu7lTZzSzXbdJ00keNyrpl/Wav9vwaHXuc/OyWzK4HMKDO7vCFKCTGIwxQxwN0PILp
	n0n5yzwHLf+si9OKikWRVPKY+RZ2UApaT23cNOdg2IKW06eF4T9hJU7UiqVefQPS87mgGuA050C
	SAKBWBf4f32M4ABqmO8/HrDw==
X-Google-Smtp-Source: AGHT+IGL0IWhgJSuT0/x34hD1ZnZBCQoO9+9MuB14e3zIBSvN6lwZFY8kFf7BpE4AVJ8D7mB99nxjA==
X-Received: by 2002:a05:690c:4a11:b0:786:59d3:49c8 with SMTP id 00721157ae682-78a8b54d8b4mr132611937b3.49.1764096258560;
        Tue, 25 Nov 2025 10:44:18 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:13::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a7992511esm58735867b3.35.2025.11.25.10.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 10:44:18 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm/mm_init: Introduce a boot parameter for check_pages
Date: Tue, 25 Nov 2025 10:44:15 -0800
Message-ID: <20251125184416.1493908-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aSWDkuJEdk9cdVCK@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A213240015
X-Stat-Signature: beg68etngqjas7836dpm66zjf88mc3ak
X-Rspam-User: 
X-HE-Tag: 1764096259-930485
X-HE-Meta: U2FsdGVkX185b5oCjroOAAzTDZbsDBF6zzOcbTyhPAADuys4yVBSBpk+yPPFIIeJtNOLu8L02+nSSGCyCEYbKTS3/LxrGZIle8+y3X0Dh5GJ4C4eIqoiQCGc8b4ufzzhYwwk0Iwc60o7T3KsRsAxVVc6d9I9eCaqxgHl0s4efUCX/mMgy+ZpW0jIVU4UBKG6PHDeL6i4dwz68NUErfNFxfcJ/KJEGPUAkdadQxrs5cKKRjLuUl/jmEfTDhY0AfhvffVKnWf1bK0gdfCse9qLA5IbOrIQM08rylzMYmJnfGyk77nXayarWjxI1UHkqMn3e1yRCgtqi1lwm0QKNgu+5j0tR2DK8p/FBfHTaI73bYcYdJItKpV+Ijm95gfvfeabADFmI033KIymLGFBcKyE+EkGSPNtgxvQ53Vusuk0K0tNcziEi7tvZygFxrccXYt5cthk62rlJRIX+hToLDCVtYG9g33nyMzyuc6WKgoXzeJ9wfYeqvi6i6+KYq/H5u72yrSL0s6exIUpXDJF8iHyHUi+8tYQ5Z2eCad+42ykJvj4GUJOrqR/zbAxfPAPhhdNryAU0d0vjYStGo7v2S+BtkNK6Uu7JzowTa3Nr8vVY9wLrA4MIfHGQrX9zRMydljmbw0VTQOIOql8Ed/7UxI23Lx7gtEDEiPwsk6jrWDAKpMhYkodRZLc37Un4ecfLuK0oY1MtL+TF++rmsplewKeR3J/6B8s4O5/nyFRKmtNzb8lodMRXbbD9ZUUn43IeHDsPdFmqaKKQqCfMysq/h0gcu08Ga9VjBvKXGCTxpE2bPfeeAXtAFOQCotznFroy0Fg+ouIvLwj5Zc3wgduJ8VljKlft4HXk3nPIPo0B0YW2xSg42uCASa8KKPV1e1Nkk8yttqZez6hT/0MKwskWy/j5/o+lU4Fi8XzLrE+D/MzPd3q1Gm37qHCGogI5zyyYSQR6lRoNWNWFgMdMhi6zrk
 S8ZV6C70
 5bWFwOohWbzte1mLDuS/J4Em1KWrxDGyLnJWNAtEb0io7JS4hv/eNoN1wUaMHebRxpKhM6Q6ov5EdBCiJYPs9hPMKDjlo+yDfPMI5aiiQETJEezGUmGsIWMKpDREkFgklmJGmtJAhqQazcT/wX9dky0iMIoYB/yJPT5VP2Otpd7XkEkwXny7vMVafEc+rt+Kzvs9uAyK0p6VDYf6G6rpf/BKUb6gvYXNFEHY4YMPDL6YmaWZQakm6At3EyUbDIIYIZlF99k7hOio35yfBxDUxd0YJR6i6VXvom3ApcNCkhXbl8yZ3GoxQGeipaS32knGky8gOr8CpqIA4Ze1QHFR9rqfme0/Sp+AT1gP8q0vqy4Fg+jj0zH1RWJLJ+ph267bfU9G6x/cgKkYXKE1LwsAmDZy75zGwDmfTuqOrvWjiiK3F9sks92cCjlH8pDcLRk18ZTLYUVdWAlrQVo6blTC0nlsqrelZzL7idhq+ptld4C5iSDS0RfNd8Yppu243G65t7NalktyTW4ry1cRKfFurTg5HrLLkYxakLxrtpuD1bQW4wdA3ZO7UP3pOuw1u77vQU4H0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Nov 2025 12:23:14 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> On Mon, Nov 24, 2025 at 02:54:06PM -0800, Joshua Hahn wrote:
> > Use-after-free and double-free bugs can be very difficult to track down.
> > The kernel is good at tracking these and preventing bad pages from being
> > used/created through simple checks gated behind "check_pages_enabled".
> > 
> > Currently, the only ways to enable this flag is by building with
> > CONFIG_DEBUG_VM, or as a side effect of other checks such as
> > init_on_{alloc, free}, page_poisoning, or debug_pagealloc among others.
> > These solutions are powerful, but may often be too coarse in balancing
> > the performance vs. safety that a user may want, particularly in
> > latency-sensitive production environments.
> > 
> > Introduce a new boot parameter "check_pages", which enables page checking
> > with no other side effects. It takes kstrbool-able inputs as an argument
> > (i.e. 0/1, true/false, on/off, ...). This patch is backwards-compatible;
> > setting CONFIG_DEBUG_VM still enables page checking.
> > 
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

...

Hello Mike, thank you for your review!

> > +static bool _check_pages_enabled_early __initdata;
> 
> No need in the leading underscore.

Gotcha, no preference here on my end at all, so I'm happy to drop the leading
underscore. I was just modeling the variable after _init_on_alloc_enabled_early
and _init_on_free_enabled_early, but it seems like those are the only ones
that do have this leading underscore anyways.

> > +
> > +static int __init early_check_pages(char *buf)
> > +{
> > +	return kstrtobool(buf, &_check_pages_enabled_early);
> > +}
> > +early_param("check_pages", early_check_pages);
> > +
> >  /*
> >   * Enable static keys related to various memory debugging and hardening options.
> >   * Some override others, and depend on early params that are evaluated in the
> > @@ -2591,7 +2599,8 @@ static void __init mem_debugging_and_hardening_init(void)
> >  	 * of struct pages being allocated or freed. With CONFIG_DEBUG_VM it's
> >  	 * enabled already.
> >  	 */
> > -	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages)
> > +	if (!IS_ENABLED(CONFIG_DEBUG_VM) && (_check_pages_enabled_early ||
> > +					     want_check_pages))
> 
> You can initialize want_check_pages to check_pages_enabled_early, would be
> clearer IMO.

Yup, totally makes sense as well. I'll include this change in v3.
Thank you for all your feedback, I hope you have a great day!

Joshua

