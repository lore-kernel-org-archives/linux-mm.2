Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B71C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416A06B03E0; Tue,  2 Jun 2026 04:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0896B03E2; Tue,  2 Jun 2026 04:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2685F6B03E9; Tue,  2 Jun 2026 04:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12D8C6B03E0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:44:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A01C71629D8
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:44:47 +0000 (UTC)
X-FDA: 84834337014.14.9923A41
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf31.hostedemail.com (Postfix) with ESMTP id B257E20008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:44:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WWiYpgOd;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780389885;
	b=qif2euHW9aGw6F2HyJ8O3+ZX2E/PwDpozqrxCssWd6AXagNcU9tdYbNImgUH5tPmC4SGCT
	cPZ8GD7ABVHCo5DzRMeeuTCvVsUGC9LABuao2tATbaCUFJgKkRrbO09S2t05UqEIrjryet
	IXlHLSXGi2Lr0d5pN3Z0sBSf9e0HhR8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WWiYpgOd;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780389885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvSBfn8hnh3Fa3q9m3Os7/1FymexHNztWBt1PtbsT9o=;
	b=WP3k8YCEzgcEmon8lYOzO8Z49WV60bPBKu/B9kekHYG4M+P9MKs0y6DJtYyedAkuamp2t7
	mLhcql7BGh4l41tsTB9V/U14S0skcbGegcgCiYXCGTeZAZ+MJqYUIuJgEv5Nqc6HFEAQEF
	MPOtHAqtT8GApIvDXyWrgNfKjSpJOZw=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490af320e2aso11171685e9.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 01:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780389884; x=1780994684; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EvSBfn8hnh3Fa3q9m3Os7/1FymexHNztWBt1PtbsT9o=;
        b=WWiYpgOdQjLurAWQ6CzhmsbNNrqon6Dy+PDUsA9He/0cBCOcpPjMlu1knRH4RwAjRw
         XvwiTRr8mNF1mR2XlveH6KH5sICUFbkMaQalapbryy8SQxlFQVMzs+ZjgZkcBAahF1kl
         mmOUKJYqUPQc3vu57qV0GMnswBQgTAMcL2ENSGocm9K9eB3YQzztNQrB4wm5+gwOEJjQ
         u6KGgEDr8EWdsSCLmuvESB53ueCvKJpN1wtjMwhDG0AmEUjW/WxwBPxUsK5vIJwTownJ
         qau/Op0YWiL5lQT14IvhXPmiJWnGE236yiKTeYd/r2MkCS35vjUkv+GGuY72kwlWcMLs
         +cZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780389884; x=1780994684;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EvSBfn8hnh3Fa3q9m3Os7/1FymexHNztWBt1PtbsT9o=;
        b=YvdB8L+AyfIrTq/dzdSEM65H+9F/cJQ1rSTAAb56ZvozjtyvMGm93rVs5owKoHPzt1
         xOfKPmYdDLPGYiJ0uyZFPldquyjazbp28+BhVACvgox800ic0JSXXSRrkKCXafdX2nYo
         74PW8igblcx/u6SI/RBNYzJd+Slqb0O7TEIRRAdGpotGVOOj/5sdIea4gbvHuP9IORh2
         +YHWIhhBZPct/yuxIUMliQjaJiFwRvpvrmEas8Cal8ETfxapK8TzuPAT7zRDNZ+yZMIz
         oqZZ59RdKjXtoZNxw2NaYjGKwBDeUWPuEDnobizR4PWJu1rm4EycY3hvoh49j1xLg9Nv
         uDaw==
X-Forwarded-Encrypted: i=1; AFNElJ8bZdgDXGVxbaM4ptf77TKpwAdeGwLQSsgcE3lF0y9Hyd3EkLsGZa8Yu0na28ROZXHkyYThQeXM5A==@kvack.org
X-Gm-Message-State: AOJu0Ywujr72VBxbi+y4xAEqnykwpTQt4WFCYh6HVZe9zcl4x3+jMVN+
	+bigAsOwoOm6kzM8go+yLQjfzC2fjEhhAwUAzF684lhnmmHnNZjCJtqIPs0QQTn0apM=
X-Gm-Gg: Acq92OGgRkkBSAocZ8aFshCkXUtGokIBCeuqV+82X1tRW+3jWpjudu6oM3Wq7ZY9Zgb
	a4m3vuMdQQdkJVbOFFUM0DPlB8I6RGkZt90M4Gllsp7A1wX3e3ASnDxpzCtojVW5/z7kRECjNmD
	IKIVxCbnOQcDIMUSTxiuX3fZ+dO2g20DnBgaqBuwz6cTjXyDvOYinkQ2gUyythU6M40coyyqKre
	e6cx5TcY0XEoNAmCGQn4VgwfXI6vwxleSaCZyoRIwskSdZlnsIJx+4TkIsvlO6j0F8xBHal7U9Y
	D9cmnj2gn1Pe4flAoVe8WrARrmvxjZ5QUZmNjeO1oP8P+e4fx0t/emjWgD0jmi9m2HG3y0QOil+
	4QUWGWYvjXEF5tTHdrj716Cmrq3xIfYda4Mxfc7zG5Qn8u8YIV9GkMdsVw+bC0+q8VeOMRq8mWw
	U1fIb+8g0p9MVVGpTE/TEUTpijGAFV7Gk=
X-Received: by 2002:a05:600c:190b:b0:48f:f64c:c2fe with SMTP id 5b1f17b1804b1-490a298f29bmr64095055e9.22.1780389883984;
        Tue, 02 Jun 2026 01:44:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::6:6dc9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b1006988sm22198595e9.5.2026.06.02.01.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 01:44:43 -0700 (PDT)
Date: Tue, 2 Jun 2026 09:44:41 +0100
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Waiman Long <longman@redhat.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
Message-ID: <ah6X-RtVX75YP7VX@gourry-fedora-PF4VCD3F>
References: <20260528124133.c88c27b11a8ea0ef05e494f7@linux-foundation.org>
 <20260529152616.2308736-1-joshua.hahnjy@gmail.com>
 <ahnRIDBk4bQ3xX2q@yury>
 <fe33c767-ea11-43e2-8732-f752c9c1205c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe33c767-ea11-43e2-8732-f752c9c1205c@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B257E20008
X-Rspam-User: 
X-Stat-Signature: 6uofu9in5nxjaxnwqwmbcdxjo1c1fe97
X-HE-Tag: 1780389885-874770
X-HE-Meta: U2FsdGVkX18CwLwAJ1crCIZWr7oFx456ne+skYHSc7anbBDoIsgbDjO+AKus8IK1eJyPA7Nrh0RqpOwfuI5p9k09wQbxBAVU8FiKNrmboK589SfaNXLuRpUqFW/xVoXXoUkNuWlJeXED1Dncun/NeTs3NKnI5yj7i8cmGUwlb5TkpcvJwXGaRfKDXWt2B4eY41TH2nSX/GD1pJd5X1TlWfwRfjOxY+CpKCIx7zcYpk9MnyiHk+mmKU8abZTxvqTFTJ48UmBRO8XYTOw/vu0XNx4959kutO+hwtINMYjrKFHwSOknNWPlAGlRaU7Arpnke0+1Mfm+CnB/vO/iOho/+rT8Nw9LqDtBgXbh8B7mhFwwWNIfn92qkLo3omPQ7vifycu5CNdfXzhSmDzzmyv0KwmFCQBXmvEMu9XBWVZNHkcoUjwaMRDWfilG3OGO6/BQ4Nkr4o3AOcUDvdMyY9RIT2Qrg8MOv+08TgChoDZyzRj6/Xh3A23fizAoz9tXPmFqqX4SSWNjPlF7kstzmNtS6tIEa78Z0BkbVF+d+/OS5r/z73VEnFLm18THj07Axjgq17lIejXm5O3nSQvPj106757SPM7cpFXkqxa1f+xnR+v0tBLtoCRjrfBAMg1psBhMU4qesZ8E6wnsBOrrrgcBNCzutf/f3iKMAXA312g2jta9vcJkuhsvW0sic25xywMAXQdQpqN2lDExt+KLwDxvXrgnLAL1n7Bcp2+VdgIewCAZ/DzPBhdNTpua9B9iADfdG1M+A+ztCCe79AYl49k99nJJfWn0Gbadh/Lsimu030bPs4OZ6d3jnswI/6INO5JGDT5ju5Nuw1Bf9V+2M8u5jmiURIR3ZyHU8cdz9fesCbj1OT8sWmdmVMJvJolx6E0sN0rWs7ZSnF8lH5CEp9z2wkvgJp7s2iOJBO5FmZmznzqGcqlHAWd+rXvAVRq0MTEdWG/nujvYWmH0XtYIMrb
 10mQyz4n
 dMUVyn5j/wzuRLMGZM8p3TlcvOw+pvYoGxy3/X8mIotiM3J8Q74Zgv5s7dyPjxgnVXHMOwYONhbvO1PL383/rTrnLzhyFhiFg+/HNwXDPY4QW6duf/bP5b1jVLcQgtyqcULQZd35xVGJPhCflfTwI+B/4Wkine8wC0bl5ZhBZFQFhMg7kGu7oIWvxFj0FDPy2Tv1GYDP1XGEimQs8pSfM+hra1mI6cWfB8yf2TpJOF83E88S/SVxdU7fmSrgSZIuhDRcO4utryq4GTVDBNBeOMSzlhOtxHLPiwlNQTok8Ee471OY2w235ZPIG6vnGLM+XW40zm2OmwuptQHjJG+FY2PhDnn+TGEV4q/zGBHGCZjIYD/nknC0dKqvfvTsqF7iNyPmEbVkpMRkqX0hcNwoFW21eAcs0a+FXwp6MVH9ALYyPa6zwlyrnSF31Yt590D+d/hPZMqGnd5mR/M2IzpSQKpw8J/Ud8vZ+4138WlaYmzfk9x55KzPTRqgVvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 04:32:25PM +0200, David Hildenbrand (Arm) wrote:
> >>
> >> Thank you for taking a shot at fixing the bug report, please let me know what
> >> you think! Have a great day : -)
> > 
> > Hi Joshua.
> > 
> > Indeed, quick and dirty shot.
> > 
> > The problem is that nodes_fold() can't work with the sz == 0. In
> > other words, folding to a 0-bit bitmap is an error. We don't check
> > that on bitmaps level because it's an internal helper, and it's a
> > caller's responsibility to validate the parameters.
> > 
> > nodes_onto(), or more specifically bitmap_onto(), is a different
> > story. In case of empty relmap, the function actually clears all the
> > bits in dst and returns.
> 
> It's very weird that mpol_new_nodemask() (->create() callback) disallows empty
> nodemasks, but mpol_rebind_nodemask() (->rebind() callback) would allow empty
> nodemasks.
> 

Was this actually observed?

mpol_rebind_nodemask() happens when cgroup.cpuset changes, and
cgroup.cpuset cannot be empty.

cpuset only changes with sysfs twiddles or offlining.  In either case,
cpuset *guarantees* that cpuset.mems will never be empty.

So... is this an observed bug or just a statically discovered
"bug" that can't actually be reached?

~Gregory

