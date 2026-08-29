Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E61DBC61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 19:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78C096B0088; Sat, 29 Aug 2026 15:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73D5F6B008A; Sat, 29 Aug 2026 15:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D406B008C; Sat, 29 Aug 2026 15:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 360876B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:03:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B258014019D
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:03:22 +0000 (UTC)
X-FDA: 85155230244.14.90EC6FB
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id CE110180007
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:03:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NKmrkWjh;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788030200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwBa+9bQ9e6n2dIJ1FHVXbNuvQY4O8W1fjuVGTSJWDM=;
	b=Hgr3QeoMRH6yDt+V25WIw7s7mnHVvoaVeSsI04SonEogRL66QNp63nwhD2q7ydDNSeP6cc
	uRMwX6eDFyLQ9WB5Ah+UCUnN0zK+gAHh938xy8IRlECDb5OQPcAH1rJuUNRFsB3k7zvONV
	YNniKtcl+7+1iylyzOj6NfGkVnEc2kk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788030200;
	b=gir+DaeIGkclIscu/0THR8lj6WmBYKcS+0qOF548svstDxacEKCecQ48wr+tMbWBRbg4mI
	yKIRC9ugYUaa2EIkgLZoO6YnLIdjnWPuFs9pnQaNHjBXevLlyDBtLTNCsLvtP717WjxJ0J
	qDfgXPyqUhjeVxR9+jydsZ6IBxycf0I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NKmrkWjh;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d715f4a587so29532005ad.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788030199; x=1788634999; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pwBa+9bQ9e6n2dIJ1FHVXbNuvQY4O8W1fjuVGTSJWDM=;
        b=NKmrkWjhPE/FbEcC5CroCSLok5Tp+9+eBx1lDeardc/1w5gRyLetS06ifIu4zRjwmU
         Leq1B06EpGiQvsN+y2+dhjRHJy91iAKz3Ro+aTEZJcgRuNlaMNIkaVzjwuCeoJvn0Uk+
         DKtu4IFyZB+0JiTEhNdJ3LpC9p1CeroEgSVNMSzBTY+zgDeDoPh8eB4c5V2KNtwoup3W
         Zq2wdVpMjOFYQf4v1wHORvGwXEz7wqRmGN2HxHOunhaimA1tzGxlXvULD8wxXGMVOegV
         CZGP3Rjv8D7urlDzQTosN17quayUd4Mo6HEBytAd1EYFMASgFQJwQ2XD6sJnfECQ+c5d
         GT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788030199; x=1788634999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pwBa+9bQ9e6n2dIJ1FHVXbNuvQY4O8W1fjuVGTSJWDM=;
        b=nJeZFzACIDBoNx8ngXNfGwL4aIR2OcHDoi2yWxxfgBVcbtSy6zHuR2YDms6CVsoGfE
         tkv7I0PI9TdhcAG0ccaBeYsxLLvBHrKB8pyfkkej6/x64OLUrCpEEVbGV10l9I0JFioq
         pv3zwyaddNBDPZu3cveYqSVHhsaDFhhpOaC0T67EmVuxpwIEqjZPCgbrJHAyUQ3e1MO7
         bchIyzETyxWkVFBLE+nVqki/Aat75arP6YVbFv+9MVklFYWRT7tHmZC+ncA/Tb96NAyB
         bFEq8jlgOUhUH8XekPXy2IjCtXcQfy+0b765rtxEeZzV42zmaUdz2MjT1x+QINsMRXMO
         4a0w==
X-Forwarded-Encrypted: i=1; AKwUvBwSuDRX+v929+cFIZP0aQ+8BHuLwJuNYv2ZLaX7+yin8z3/t+fZgdrOpPGM2lVL3DIS7HARINTZYQ==@kvack.org
X-Gm-Message-State: AFuF++n7BRvm99DtekUXXN9U9T51+b1JJZHIkRB31D83DoqO8lCkeR6K
	zAacFrJfWci2dNfb8JN3WFuimG0Pyf/7jA5xNvEUiDlxMhcoHr05NiY6
X-Gm-Gg: AYBFou15mSIQREcKMUVtr2ff7at8AWpxT3EqsF3OVop6BqH2Cun2SSc7pQUisbVCZpy
	RXu/kzNL2HrWUek72PQHcKoQHR4j9wZIWVoZZb03ubjuQAc4XxH6ZS1pq4v2SpCOWo3NGmAmE7+
	xF40rTR6ooLKNerrWGuI2ygZ6ZoLOnljc5kLJNFNMx7Q7PQsMuGCPLqb7QqCEWUaUOMPLw1YAiU
	czZV+h5RNnv/HrBkbuLr+9kksTJVrSGxpy1aRYVVQj1A2FIitFXVJ5jZCAsn5rbntVqnNmDia9j
	Ynt/9c7Y2IFPyg8QXtLlmWHvdPPcKzopkVGElPLX5LOtjbtrgBTQEmdoXrfvBJWFw8dFR9vCtJ4
	cw0OnLT2fWfALyl57IvG6Ucrh/C2jyk6rufPtLfHfjcNZ6XtItedOr5symMxLxE9Cc294/zx71S
	7hf/L+T6CVADKFpk6u3kd+5C59EFAHNpNmh9yhF65mVX/rV85fd0fs3C7zDvLWOOTOlJ12tOC6x
	2KgNq5cu7yjW4lM
X-Received: by 2002:a17:902:fc4d:b0:2d8:d4cc:5bb0 with SMTP id d9443c01a7336-2d8d4cc5d79mr139929965ad.16.1788030199448;
        Sat, 29 Aug 2026 12:03:19 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d9055ddfdcsm900305ad.18.2026.08.29.12.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 12:03:18 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon: fix unconditionally skip last region
Date: Sun, 30 Aug 2026 03:03:27 +0800
Message-ID: <20260829190327.17400-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829161509.77406-1-sj@kernel.org>
References: <20260829161509.77406-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CE110180007
X-Stat-Signature: rxo7ypxnqu1s5xca4q7pi1iw3f9qdfm3
X-HE-Tag: 1788030200-53044
X-HE-Meta: U2FsdGVkX18vlI+4Gho1sLend3T5UELFwMZKZ8r46e5TdQVQ+FKRb+dDpljYAO7GqdidRdIDPDxqJEWS9wcU6xmS79VlqyMkNC8JWL4MH1dzO42Nxl0OiYf1JvdhFqXwLvnLBWliQ68U9Mex4t6ZoZplHUzob0cgtu1TM55/fAj3Ssvy+1N3kbKPEo6Xy6lTjv3vy79Su4YLtQDcgC5CYYIJavJcByOlHLCNnN8VYDzFOl2/gYVNUwYSPSBcLmWFMOS4i/TnucYwj4i7DuksN5v1HXRXHFWwG/w4ken55E5CDnGIRyA223H8sKML5AmdNspEOfiHgQq3PjnnRZLQpCBCpJw8wZKjd2SkMk790M60hISNl8394DFcJMPH4FuYdU+W5ukXp51ZlgY22bV2J5qon/Wp7Fd0kekH188jL0f0VKgnBckIK775xa7jx64Iu18hkljJv99LCzzDuntH9pE79n0projRoKwiKmDIQOVnwi95fVeuF0FMhMPGOPA/+ACqzuX8m4ZRFP47M7VQU2huuUWmjTWlaFMxPg/JDUjlhA20ytrRekMMI4IWqWMiE03aY39viGzd+XYVBaAYUv9zW8PXZVAxu38nm+FuzIXf4HpwOf5jM81o07/DpXrwdEoi1Ji+V5B6eWuw7yxb/WRr1NpWOWHs/nVkuAfRwQ6dij/lg7rD5WqCgGVBUR6m81uJPD0efb+in83M1s7YAC7OEWLf52M45rjPzEYB2zBXxqLJe01Vd5xLqQTqGTkYlzkMJ2smFlT3LSNFijpFwVx95s0+GI+ED8rFoz1mCif2VOC5lyYp8nkI8D1fSPHYdBvchG7mIN1cVSW/p6ALCL10V11CY/N5anKq0Wx33SZf3s8EaQG8+eZd8iG+rkaolnDhiswVl3U/iugW7uC6B8fnV/ty1LAvc2Mr8nvB4xi9viZvzhp0iowl3yjiVCwusZYA6DEjz082T2Ay+H0
 x1rOu/3E
 OTI6WLxxsacEwaLXKVhrO7kggqylJ4ooRYsMIrAmpdPCm1ClP86SONXZTBy0pb8OieLebrYVn/1Oa4meX19b9F0IB84ZUS1/g4bc+jl9YAa0sqi8vKJrpQcmB/jl8VWNdCAVW412d/scchUwq+ezoGBIMLVYTeKKmgSxZX/ie3rsdEc29AgZnCgVTBGFasta2Gmotr+KnMM17G5ybaKbFjrhmA+hWAQ3OGSQYzpy7+iaGE4QmzmkEieKGli/heMDqZYnypSSYT9Nqs+NUxHtoRA23CZfiAAlxuAGd6xSktlqfiTELD3s6dKnUiUW2n20uyMiPspS5Lv9wT1gkSNI30//7umZ+mE4tYTsSrxcW7EsXWI9JL/a7MLrgpn/PQhzg+vEVLEsOVJvnChIdZs+nYnzNHLPYr9bAmDWL/md5s0sOiF+/Bx6OSnCNCqnv+y02CJhy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Aug 2026 09:15:08 -0700 SJ Park <sj@kernel.org> wrote:

> On Sat, 29 Aug 2026 16:34:26 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > On Fri, 28 Aug 2026 11:29:09 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> > > As you replied to Sashiko, let's do the last region handling in every case.
> > > While doing that, let's do the charge_{target,addr}_from reset in only one
> > > place, like below.
> > > 
> > > '''
> > > --- a/mm/damon/core.c
> > > +++ b/mm/damon/core.c
> > > @@ -2688,36 +2688,40 @@ static bool damos_skip_charged_region(struct damon_target *t,
> > >  {
> > >         struct damos_quota *quota = &s->quota;
> > >         unsigned long sz_to_skip;
> > > +       bool skip = false;
> > > 
> > >         /* Skip previously charged regions */
> > >         if (quota->charge_target_from) {
> > >                 if (t != quota->charge_target_from)
> > >                         return true;
> > > -               if (r == damon_last_region(t)) {
> > > -                       quota->charge_target_from = NULL;
> > > -                       quota->charge_addr_from = 0;
> > > -                       return true;
> > > -               }
> > >                 if (quota->charge_addr_from &&
> > > -                               r->ar.end <= quota->charge_addr_from)
> > > -                       return true;
> > > +                               r->ar.end <= quota->charge_addr_from) {
> > > +                       skip = true;
> > > +                       goto out;
> > > +               }
> > > 
> > >                 if (quota->charge_addr_from && r->ar.start <
> > >                                 quota->charge_addr_from) {
> > >                         sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
> > >                                         r->ar.start, min_region_sz);
> > >                         if (!sz_to_skip) {
> > > -                               if (damon_sz_region(r) <= min_region_sz)
> > > -                                       return true;
> > > +                               if (damon_sz_region(r) <= min_region_sz) {
> > > +                                       skip = true;
> > > +                                       goto out;
> > > +                               }
> > >                                 sz_to_skip = min_region_sz;
> > >                         }
> > >                         damon_split_region_at(t, r, sz_to_skip);
> > > -                       return true;
> > > +                       skip = true;
> > >                 }
> > > +       }
> > > +out:
> > > +       if (r == damon_last_region(t)) {
> > >                 quota->charge_target_from = NULL;
> > >                 quota->charge_addr_from = 0;
> > > +               return true;
> > >         }
> > > -       return false;
> > > +       return skip;
> > >  }
> > > 
> > >  static void damos_update_stat(struct damos *s,
> > > '''
> > 
> > I noticed a potential subtle issue in the suggested fix above:
> > 
> > '''
> > +out:
> > +       if (r == damon_last_region(t)) {
> >                 quota->charge_target_from = NULL;
> >                 quota->charge_addr_from = 0;
> > +               return true;
> >         }
> > '''
> > 
> > If 'skip' is false (region should be processed), but it happens to be
> > the last region, the condition 'if (r == damon_last_region(t))' would
> > still be met.  This would cause it to reset the state and 'return true'
> > (skip it), which inadvertently re-introduces the original bug we are
> > trying to fix.
> 
> Ah, good catch.  The 'return true' is a wrong copy-pasta.  Let's drop the line.
> 
> > 
> > To ensure the reset logic is centralized and correct, I refined the fix
> > as follows.  The comment is intended to help you and other reviewers
> > quickly understand the rationale behind the compound condition.  I will
> > remove this comment in the next revision.
> > 
> > '''
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 644daf5a1656..82c5aed8a417 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2342,36 +2342,48 @@ static bool damos_skip_charged_region(struct damon_target *t,
> >  {
> >         struct damos_quota *quota = &s->quota;
> >         unsigned long sz_to_skip;
> > +       bool skip = false;
> >  
> >         /* Skip previously charged regions */
> >         if (quota->charge_target_from) {
> >                 if (t != quota->charge_target_from)
> >                         return true;
> > -               if (r == damon_last_region(t)) {
> > -                       quota->charge_target_from = NULL;
> > -                       quota->charge_addr_from = 0;
> > -                       return true;
> > -               }
> >                 if (quota->charge_addr_from &&
> > -                               r->ar.end <= quota->charge_addr_from)
> > -                       return true;
> > +                               r->ar.end <= quota->charge_addr_from) {
> > +                       skip = true;
> > +                       goto out;
> > +               }
> >  
> >                 if (quota->charge_addr_from && r->ar.start <
> >                                 quota->charge_addr_from) {
> >                         sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
> >                                         r->ar.start, min_region_sz);
> >                         if (!sz_to_skip) {
> > -                               if (damon_sz_region(r) <= min_region_sz)
> > -                                       return true;
> > +                               if (damon_sz_region(r) <= min_region_sz) {
> > +                                       skip = true;
> > +                                       goto out;
> > +                               }
> >                                 sz_to_skip = min_region_sz;
> >                         }
> >                         damon_split_region_at(t, r, sz_to_skip);
> > -                       return true;
> > +                       skip = true;
> >                 }
> > +       }
> > +out:
> > +       /*
> > +        * The last region may remain unapplied for extended period due to
> > +        * various regions (e.g., it is invalid or has been filtered out),
> > +        * preventing other regions from being applied (those preceding the last
> > +        * region and all regions with different targets).  Therefore, when
> > +        * encountering a region that needs to be processed, reset
> > +        * charge_{target,addr}_from.  If necessary, this parameters will be set
> > +        * to the correct value in damos_do_apply() due to quota is full.
> > +        */
> 
> Looks too verbose to me.  Let's drop this.
> 
> > +       if ((r == damon_last_region(t) && skip) || !skip) {
> 
> Why this becomes this complex?  We should reset charge_{target,addr}_from if it
> is the last region, always.  Am I missing something?

Thank you for pointing this out!  As long as it is the last region, we
should reset.

> 
> >                 quota->charge_target_from = NULL;
> >                 quota->charge_addr_from = 0;
> >         }
> > -       return false;
> > +       return skip;
> >  }
> >  
> >  static void damos_update_stat(struct damos *s,
> > '''
> 
> > 
> > > 
> > > Btw, I think damos_skip_charged_region() may deserve a kunit test.
> > 
> > I agree that a kunit test would be valuable.  While I am still getting
> > familiar with the kunit and it might take me a little time, I plan to
> > work on it.
> 
> Nice.  Looking forward to your patch.
> 
> > 
> > Should the tests include these scenarios?
> 
> Let's not add new topics.  We can discuss this on your kunit patch.  Please
> ensure it covers at least the corner case this patch is trying to fix.

Okay, I will ensure that.  Should the test be sent along with this
patch (as part of the same series), or should they be sent separately?

Best regards,
Rui Yan

