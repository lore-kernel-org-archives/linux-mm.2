Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C94ECC61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 08:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A26F16B0088; Sat, 29 Aug 2026 04:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6DB6B008A; Sat, 29 Aug 2026 04:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7466B008C; Sat, 29 Aug 2026 04:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AEF86B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:37:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B33BC16065D
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:37:39 +0000 (UTC)
X-FDA: 85153653438.02.497D781
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id D9F3EC0003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:37:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DCvhkcUF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787992657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4IwbgMrRyJTDKTZ/KQuUur9K0X+mbmrk/E1Z34LTpY=;
	b=eBqeTAenIG2NcHOEve324m6MrCAJdmAXxFMXKoO05F3G33C4cA25llwdVr+ArBV58nO/W1
	YKA2Ux68BMElPHYFQ1rJ0obMZcSEhibkdIATfTCBQjT0SUeksoLpa4N2+CMO4B0DGZl0Nb
	6GQBQmD1EBMpVPLTFxuRESCOYdR4mAM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787992657;
	b=V6nyzBOU3GJC0pZxN+ca0cmDo+3ScVKtplAN4ofRfz+/m60EXkE9Xzg6O6ds/8IAtUPSSl
	BNWmbpiiAOQRWqITARblPNx+F+w/a96bIRXjMargJF8ObuNkqtSwVxri2Ptw4olyh+Nx+2
	fbfXPXh3HX368AkVzu/gZab7pcuFvKA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DCvhkcUF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d71ae3455aso26909115ad.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787992657; x=1788597457; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A4IwbgMrRyJTDKTZ/KQuUur9K0X+mbmrk/E1Z34LTpY=;
        b=DCvhkcUFnHrSSHK2VUv6TpDwaZZjqmLOa/mDxRC73H5gbtA3ZMYFRnVxJX1fIcsK6D
         ZGvMxIAglOieJ1MHIfw2mUkIYinXFcVR4/W3kx06js2NNnPg3thzRiMBVjxlhw9euvZ+
         VpPYqApl67t94AZq2DxMZuJ4UEssIBt5PJfXTjFCu5RlwPUeKbKdzEZcZ8GRoeGqvj3Y
         ruMXvkqElWmyqaf3mwfX07fr41dLD6WK9Xf4niaYBYYv0M6fLbqlHvHu4z7eZ9bPP5/V
         Q9cReqbTqWaYQ7Brmnilq0tSEfoOSRi2J/sbAtPTqN2Z2EF9+pLMfC6oCoeKEHIN3Xzf
         lOOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787992657; x=1788597457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A4IwbgMrRyJTDKTZ/KQuUur9K0X+mbmrk/E1Z34LTpY=;
        b=XGVhjwEGpwEFll8Bfya9nf3GALyfXtdhWx+C0d32c63eekU0D7rGPDY4iAHiiOAovn
         f1EB5z58DKZZcSki/lulR3fm+v1PelRsW4enjWeNl/UVj5+LH2tndwpEkvBnGwyy2fer
         6ojPp8xDsReBgfLOIAgHcynk8NEaT6rSWC0vCQ4rYGP461hW/nzTgDUTlZLBkHu8H+LR
         XIukxmO8e0fLiCDn7fh3qLXTkWbWO71GjcfptotLyzOawKI3EknlFhUj9mcJExnHlxTE
         HFUfYptrcvqD/X83/5s9jFoCk3QdwtsBis+9E1+OsEsKo78tRsYF4eXSRamSYrKqr9jn
         uAEQ==
X-Forwarded-Encrypted: i=1; AKwUvBxWUls1+C3kzxafhOiPBRQOIOhqG6WdNGuhBO3UwnUPVXTTojb9/qZ7RuXBZG/ACakjbrFlz0lUJA==@kvack.org
X-Gm-Message-State: AFuF++lt0gwtp7fsceIIuGHLJTHPvBYKPxownWH8WiG8+D34yRLQE5iY
	FphaM50GNsQLJT2XoluZYEHG54DUI+kleo5GMliDtCVY0l5UpHT6/2XN
X-Gm-Gg: AR+sD10to6r0KJwDhb2bPSUgJbtd3TjArudfWzgbOVBiW/eOugwCdjH1s9bR3PrIwf5
	kW8rJEtVxsLMLIsMUn/11Z/oSCWQNZolaVFvhiLUSTzAKrOz1vpjZzlVCZaKQ9gB9VkcHP5huKs
	3ASLqlLJugtvrZU/D9ph4Rg3rV/RVYmTXKUvYN/MelZ2HJAWVt7Xw3JGCQBp6HNETu6mCrVFJKD
	5Z8fm2Syzb8AqnvTcJtWcj9RkxP+sviYqz/TuWIIpBtWtLUoL1VcjMiOTJ9weGxgOTOaXIyoIpg
	7RmgnAdDrlmOtQBG7rkyKWl7wc1TlZDNkWXcuiL1Kw/6Ufsiq4dkraBTCM6WtwIYpVmmqEt+Dt2
	RNptFFGUNMj5yPK8oJV3kvUjfvKS3ym7Pe4HI+zb6bxSXMvrZ3s/o9XjDXRO1DUR4TUJMJzwl7k
	/hTkIiO06uGO7PoRjm74SsunCcHHB3ax4xXrx+a/JxqvFlrQAGq1hZEQ5joUIPuDP/ePA+9i6V2
	mgT1919eLooDoD5+ti7Ojnf8GDb
X-Received: by 2002:a17:902:ffce:b0:2d8:d4d2:dc9a with SMTP id d9443c01a7336-2d8d4d2dfadmr79579325ad.22.1787992656523;
        Sat, 29 Aug 2026 01:37:36 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:88cd:27c4:5897:46d2:587d:19e7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d7594ffc94sm12819105ad.5.2026.08.29.01.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 01:37:35 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon: fix unconditionally skip last region
Date: Sat, 29 Aug 2026 16:34:26 +0800
Message-ID: <20260829083744.73299-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260828182910.70304-1-sj@kernel.org>
References: <20260828182910.70304-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9F3EC0003
X-Stat-Signature: s7fyt9hc8q3mxuicqbp4kij91xeu6r7o
X-Rspam-User: 
X-HE-Tag: 1787992657-512496
X-HE-Meta: U2FsdGVkX1+/TyI7RZdFbfbdqlMtw2WYk5vwOCljKG36jHBBNrVgRYSgtopk7aJiwnLgw0uSB7X7T9vRFXu2yXuSVCFp335Jjy/3oSfY+Q6fXXohDYIg0q9n07L7O8V4CEhUn4iYbNUqMAwnV2Bz6w19pr5NCDHwL48ZJT2Et1W5BnNLWzwuepLyTaUuDGerFsaavc9M4rBbOiKXahgeWMgaq9EmohJ6m6b81qIcuNxR+WwvOxMFgzZc8TS+68E6wUevYN07tObWK392BSQasc7UPD75vh/9qcjZohgT3/E4UHgWTlnYIoiibRBR5KyVieWCURrrttiRurseNaConJ8dsHjPXxEGsyQHlBSGHeLVptYT2qGUdZilymL8tJypAcG2VRc2BFYPXrJJqi5WkB5wly+8725C8NvNHZGFMre9WybgDqkBzPZrNLvJI4qm2C4z0zccNxTYvDYZ8kSMPrT07hFR/nmZJ5jVrkJUGI9tmtzqbfrPuTGYhyyXdX8oJERez1FSVZY2jZNESBH2vat71xWonSQoVhmnGmIgsI4KhMbPfmuPZxj3FZh6aIjIOys5yAboQSTL2RdfNWmVrIw+Uvf1DUNKaD7FTPC5EVkEZPb9lYFZqZRDlCDocDmH9L7Z0uu1nrmZEkP01OqVcuKcsQ25RjfM8LIfRqxfhcUpLVm0FdLoJEX6DRFj4M7C7ipfZvS11lGCJI1j2kZ2xP7vaVMCAGkL0bHymj5Edes/ICpTVe1968SnAHV4JzbDSDJL+9DP6JMiNLMGAyrhytuhgE8teTap8TiTdYTVE8nU6zwmKly2oD0rgr4DjvgooKaeOVjEtdD6JSR2PBz83bCRwhkBat+EGEYDb5Jj0irZttN7lgBWyw+GjdkXf7QBzpFFSTW9hBG3R45zbblqLcOquL/CYhmUnD6HHkP+ZyiB/nNgMOMlrESf6Be7XuZp2EhBxMuKQgS5SHmKtZi
 G7d6IGre
 X0VXxxwJDVEhpGwInGIfa3nCVPKPAND8mNKMyUJ4y4+MHN+EV9oQDI32Wjc6IHX340H/LPVifI5oYA4C9b1LeOMohSDPmY3Iu32k5RrfdeL27jN7W8McoTwXe8Drd5967LrHJET71ULqZZGele9kpEl6pGODNGO+sKc1U92peemSjxzn6tzjh4NFOVjzZv9F3E9mD3qnbICCTt6/4Oy9mUlQZiY5wqYvhsbZDTTC5YL+b6Nda205sC3BNQOYXa4VyTONG7YZtIbLlmPBXbCWb0ZC8WbbdqqasVBwCVezUyN2FDMxEicRDveqkOeEqNHwr4y0XsnlQkBRaplyl6orwsIZV441bOMa8m/HelU0olVAF9cXfg2vo6foE7ETkgkGyrg7oDR9cgK6i3hARlbXyWqCHzOEwX8tjd9QRsL/oJEYxrtD78ubKbo0GJ+Z2jyioh721
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 11:29:09 -0700 SJ Park <sj@kernel.org> wrote:

> On Fri, 28 Aug 2026 16:47:37 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Once quota set, the charge_{target,addr}_from unconditionally skips and
> > resets at the last region of the tracked target, so the last region can
> > be skipped even when it has not been processed.
> > 
> > Example:
> > 
> >     1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
> >     2. Quota is configured to process only 50 bytes per window.
> >     3. Window 1: Processes R1 (0-50).  Quota is full.  Cursor is saved
> >        at (Target, 50).
> 
> Cursor means charge_{target,addr}_from, right?  Let's explain that, or just
> keep using the terms (charge_{target,addr}_from).

Yes, thank you for pointing that out!  I changed cursor to
charge_{target,addr}_from now.

> 
> >     4. Window 2: Skips R1 (0-50).  Processes R1 (50-100).  Quota is
> >        full. Cursor is saved at (Target, 100), which is exactly the
> >        start of R2.
> >     5. Window 3: The loop reaches R2.  Because R2 is
> >        damon_last_region(t), the old code unconditionally returns true,
> >        skipping R2 entirely and resetting the cursor.
> > 
> >     Result: R2 is permanently skipped even though it has never been
> >     processed.
> 
> Let's make example simpler by setting R1 (0-50 bytes) and R2 (50-100 bytes) or
> quota size 100 bytes per window.

This is the updated example:

'''
Example:

    1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
    2. Quota is configured to process only 100 bytes per window.
    3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
        addr}_from is saved at (Target, 100).
    4. Window 2: The loop reaches R2.  Because R2 is
        damon_last_region(t), the old code unconditionally returns true,
        skipping R2 entirely and resetting the charge_{target,addr}_from.

    Result: R2 is permanently skipped even though it has never been
    processed.
'''

> 
> Also, it continues being skipped only in a corner case that the region
> addresses and the access patterns are kept.  So the user impact is mild.  Let's
> clarify that to not make users unnecessarily afraid.

I will add this clarification in the next revision:

'''
However, it is important to note that this is a very minor issue.  This
is because it is triggered only when the previous window saved/kept
charge_{target,addr}_from, and in the next window, all regions except
the last region were skipped by damos_skip_charged_region().
'''

> 
> > 
> > Fix this by only skipping the last region after it has been applied.
> > 
> > Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
> > Cc: <stable@vger.kernel.org> # v5.16.x
> > Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> > ---
> > 
> > Changes from RFC v1:
> > - Minimal fix, only fixes the issue where the last-region is skipped.
> > - Add an example to the commit message to demonstrate that this error
> >   occurs very rarely.
> > - RFC v1: https://lore.kernel.org/damon/20260825124616.5129-1-aethernet65535@gmail.com
> > 
> > ---
> >  mm/damon/core.c | 13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 644daf5a1656..21dc6b086c42 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2347,14 +2347,15 @@ static bool damos_skip_charged_region(struct damon_target *t,
> >  	if (quota->charge_target_from) {
> >  		if (t != quota->charge_target_from)
> >  			return true;
> > -		if (r == damon_last_region(t)) {
> > -			quota->charge_target_from = NULL;
> > -			quota->charge_addr_from = 0;
> > -			return true;
> > -		}
> >  		if (quota->charge_addr_from &&
> > -				r->ar.end <= quota->charge_addr_from)
> > +				r->ar.end <= quota->charge_addr_from) {
> > +			if (r->ar.end == quota->charge_addr_from ||
> > +					damon_is_last_region(r, t)) {
> > +				quota->charge_target_from = NULL;
> > +				quota->charge_addr_from = 0;
> > +			}
> >  			return true;
> > +		}
> >  
> >  		if (quota->charge_addr_from && r->ar.start <
> >  				quota->charge_addr_from) {
> 
> As Sashiko pointed out, this doesn't work if the the last region's start
> address is smaller than charge_addr_from and the end address is larger than
> charge_addr_from, but the size to skip (charge_addr_from - r->ar.start) is
> smaller than min_region_sz.
> 
> As you replied to Sashiko, let's do the last region handling in every case.
> While doing that, let's do the charge_{target,addr}_from reset in only one
> place, like below.
> 
> '''
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2688,36 +2688,40 @@ static bool damos_skip_charged_region(struct damon_target *t,
>  {
>         struct damos_quota *quota = &s->quota;
>         unsigned long sz_to_skip;
> +       bool skip = false;
> 
>         /* Skip previously charged regions */
>         if (quota->charge_target_from) {
>                 if (t != quota->charge_target_from)
>                         return true;
> -               if (r == damon_last_region(t)) {
> -                       quota->charge_target_from = NULL;
> -                       quota->charge_addr_from = 0;
> -                       return true;
> -               }
>                 if (quota->charge_addr_from &&
> -                               r->ar.end <= quota->charge_addr_from)
> -                       return true;
> +                               r->ar.end <= quota->charge_addr_from) {
> +                       skip = true;
> +                       goto out;
> +               }
> 
>                 if (quota->charge_addr_from && r->ar.start <
>                                 quota->charge_addr_from) {
>                         sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
>                                         r->ar.start, min_region_sz);
>                         if (!sz_to_skip) {
> -                               if (damon_sz_region(r) <= min_region_sz)
> -                                       return true;
> +                               if (damon_sz_region(r) <= min_region_sz) {
> +                                       skip = true;
> +                                       goto out;
> +                               }
>                                 sz_to_skip = min_region_sz;
>                         }
>                         damon_split_region_at(t, r, sz_to_skip);
> -                       return true;
> +                       skip = true;
>                 }
> +       }
> +out:
> +       if (r == damon_last_region(t)) {
>                 quota->charge_target_from = NULL;
>                 quota->charge_addr_from = 0;
> +               return true;
>         }
> -       return false;
> +       return skip;
>  }
> 
>  static void damos_update_stat(struct damos *s,
> '''

I noticed a potential subtle issue in the suggested fix above:

'''
+out:
+       if (r == damon_last_region(t)) {
                quota->charge_target_from = NULL;
                quota->charge_addr_from = 0;
+               return true;
        }
'''

If 'skip' is false (region should be processed), but it happens to be
the last region, the condition 'if (r == damon_last_region(t))' would
still be met.  This would cause it to reset the state and 'return true'
(skip it), which inadvertently re-introduces the original bug we are
trying to fix.

To ensure the reset logic is centralized and correct, I refined the fix
as follows.  The comment is intended to help you and other reviewers
quickly understand the rationale behind the compound condition.  I will
remove this comment in the next revision.

'''
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a1656..82c5aed8a417 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2342,36 +2342,48 @@ static bool damos_skip_charged_region(struct damon_target *t,
 {
        struct damos_quota *quota = &s->quota;
        unsigned long sz_to_skip;
+       bool skip = false;
 
        /* Skip previously charged regions */
        if (quota->charge_target_from) {
                if (t != quota->charge_target_from)
                        return true;
-               if (r == damon_last_region(t)) {
-                       quota->charge_target_from = NULL;
-                       quota->charge_addr_from = 0;
-                       return true;
-               }
                if (quota->charge_addr_from &&
-                               r->ar.end <= quota->charge_addr_from)
-                       return true;
+                               r->ar.end <= quota->charge_addr_from) {
+                       skip = true;
+                       goto out;
+               }
 
                if (quota->charge_addr_from && r->ar.start <
                                quota->charge_addr_from) {
                        sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
                                        r->ar.start, min_region_sz);
                        if (!sz_to_skip) {
-                               if (damon_sz_region(r) <= min_region_sz)
-                                       return true;
+                               if (damon_sz_region(r) <= min_region_sz) {
+                                       skip = true;
+                                       goto out;
+                               }
                                sz_to_skip = min_region_sz;
                        }
                        damon_split_region_at(t, r, sz_to_skip);
-                       return true;
+                       skip = true;
                }
+       }
+out:
+       /*
+        * The last region may remain unapplied for extended period due to
+        * various regions (e.g., it is invalid or has been filtered out),
+        * preventing other regions from being applied (those preceding the last
+        * region and all regions with different targets).  Therefore, when
+        * encountering a region that needs to be processed, reset
+        * charge_{target,addr}_from.  If necessary, this parameters will be set
+        * to the correct value in damos_do_apply() due to quota is full.
+        */
+       if ((r == damon_last_region(t) && skip) || !skip) {
                quota->charge_target_from = NULL;
                quota->charge_addr_from = 0;
        }
-       return false;
+       return skip;
 }
 
 static void damos_update_stat(struct damos *s,
'''

> 
> Btw, I think damos_skip_charged_region() may deserve a kunit test.

I agree that a kunit test would be valuable.  While I am still getting
familiar with the kunit and it might take me a little time, I plan to
work on it.

Should the tests include these scenarios?  Note that I use 1-based index
in here since it is easier to understand.

1. Baseline test:

    - Parameters: charge_target_from = NULL, charge_addr_from = 0,
      nr_target = 1, nr_region = 3.

    - Expected: Returns false three times in a row.
      charge_{target,addr}_from remains (NULL, 0).

2. Skip test:

    - Parameters: charge_target_from = target[1], charge_addr_from =
      region[2]->ar.end, nr_target = 1, nr_region = 3.

    - Expected: Returns true, true (for region[1] and region[2]), then
      false (for region[3]).  charge_{target,addr}_from is reset to
      (NULL, 0) after region[1].

3. Split test:

    - Parameters: charge_target_from = target[1], charge_addr_from =
      midpoint of region[2], nr_target = 1, nr_region = 3.

    - Other: Ensure region[2] is large enough for the split to succeed.

    - Expected: Returns true (region[1]), true (region[2] first half),
      false (region[3] second half), false (region[4]).  Total nr_region
      becomes 4.  charge_{target,addr}_from is reset to (NULL, 0) after
      region[0].

4. Sashiko's edge case (Split failure on last region):

    - Parameters: charge_target_from = target[1], charge_addr_from =
      midpoint of region[3], nr_target = 1, nr_region = 3.

    - Other: Ensure region[3] is small enough so that the split is
      guaranteed to fail (sz_to_skip < min_region_sz).

    - Expected: Returns true three times in a row.  Crucially,
      charge_{target,addr}_from is reset to (NULL, 0) on the third call,
      preventing permanent state leakage.

5. Last region processing test:

   - Parameters: charge_target_from = target[1], charge_addr_from =
     region[2]->ar.end, nr_target = 1, nr_region = 3.

    - Expected:

        - Round 1: Returns true (region[1]), true (region[2]), false
          (region[3], resets charge_{target,addr}_from because !skip).

        - Round 2: Since the charge_{target,addr}_from is now (NULL, 0),
          it should return false three times in a row, proving that
          subsequent regions are not incorrectly blocked.

If there are any issues or missing edge cases in these scenarios, please
let me know!

> 
> [1] https://lore.kernel.org/20260828090410.40AEA1F000E9@smtp.kernel.org
> [2] https://lore.kernel.org/20260828115047.332978-1-aethernet65535@gmail.com

Best regards,
Rui Yan

