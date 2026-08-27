Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE4F0C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 05:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804C16B0088; Thu, 27 Aug 2026 01:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5E46B008A; Thu, 27 Aug 2026 01:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3EB6B008C; Thu, 27 Aug 2026 01:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43C266B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:54:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC24CA342A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:54:20 +0000 (UTC)
X-FDA: 85145984280.05.269D838
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 17CA8100002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:54:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lkiFdxHP;
	spf=pass (imf14.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787810059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=plMv1alWLSmRUs996GTzyKVxl/InS+Hvvr87SnLX3mc=;
	b=wN1t4SOuAu07u+5oIX2XsOBcl8wVgEg1gjyTwnfTFC0X6H16SrFyiOKTOnNee4mDRvgpgH
	6LCuPSlOyowQ7Y+qc9liKrQlgoZFN7QlARk8sV7tWvGgHrt9noXjy93eye1FnJa+3BSm+H
	+YouYuN8Po1M61zSe7vYRFXMSMDQq/U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787810059;
	b=Kd2jo5DTbjkhERzsOrguH5s8C77UvuYugW64N/vaQ+jyvVr8VExHHoDO/ZAA3wEhwlmAFd
	S5k5YdSbagtyp+WGVqX1QkIvo5Rg6SotI119Pr0APV33rudjSw6ihtdfeUxzF6Y/m/yYT9
	+Qy19PaRd0VEi+JTiCS1P00dT1JuRbo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lkiFdxHP;
	spf=pass (imf14.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38fdeaed181so605813a91.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787810058; x=1788414858; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=plMv1alWLSmRUs996GTzyKVxl/InS+Hvvr87SnLX3mc=;
        b=lkiFdxHPLVLVUKK1YCA4VCdVX+sEc0R4F3DxLkgGdVSyAdd76jXBTkm6KmjEDDDC2H
         RCk0bIftVEIbh/MpBHJExdR0uaPJRp0qPlemeT2WfSaTZZua4SeyQfynVJ9K0gC1n4xz
         0j+iicdRnq2CfL7TrPTcp7H7JFCDckaYuk6z/qkjVdRRkk7h1iv07XuQWSAfceR8qEJq
         GiqbKgKSsBxGhjdN5GlxyWZnaOAU5uGfSEqOlXvc0Xa+n+YZmo6UUtbxVnWbF+mOfX7g
         VAAfm8q/u2cLFo2pT2APL1h4T2Da7mns7zNNB7m2oIwYEy53g+zTFt5WTL7j0kKX7C3X
         Dj6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787810058; x=1788414858;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=plMv1alWLSmRUs996GTzyKVxl/InS+Hvvr87SnLX3mc=;
        b=jaU/xhm/YaM7VbdN8KXOTNvZep70btVotPr3Q0z5EndTkJchTJt32+ZM675z5w3yEK
         sNhIFFUyS3kuTEJcz9J4aSbCWXiu0x7QBjH4uvkR+I7D2wKhh8Fs2wX3IitjUqug8o6c
         fTPLKmeME0TrUes66sfeaSFx20aIff8PMG4PL42lglBd1/9PAFlnFeIQI1GB+EypAXWW
         djC9qtnMlvdTSRW2+0gssO6+6KUjwd7W73LmjzmpZAXOClaZCMhfh3jxqbQbRhrq2AlP
         v2aQEjpEvPpi80w9ISH11PMBdkzc1SdEaZn+D9lCSOD7MmMrhaP2lrcSz5SCoqEa2uwv
         kCyA==
X-Forwarded-Encrypted: i=1; AHgh+Rqgi23aThO956Vglq/wq8YcrLtAoxMLJ8R5Yq3DsF+ywHNxyq70flZwZzf91+uQDZSa4zkGYMlMYg==@kvack.org
X-Gm-Message-State: AFuF++nKwRWwLGEYu5F36KOyNqGMtkClRzy5oIbmyGTP9fqIQB7+Vby+
	sHLUeo089quIasEs0vAN+rcrhfvz5HyqEooNg77oR4UiZnjjw6YPMfzd
X-Gm-Gg: AR+sD10Cs8IXNL5lxXXBzMp565nKxa6LgnUX1tHQCyoK6BUfs5r/b6RrJMiuq4qfntS
	rb3T4rRh/lMALPwgLShorC4gT8w9+KTnc07x8PBnkRJSt4IYTjSInoXK5njrlko8opK5gZ3r2JV
	zMhxoc4y+/tlcJcZ36w43XKZP76iGhq7AMQT58bmiEWi2j1ShX0R72A8b38r37a7dqfgdFG7AJW
	VmROwUSPkc1TVYrZoZPI7GDLWBQpPYasJndiXZkPLAqlwLj+mLPYBe7uDut29jTkbodCFzdZ35r
	gwC/j7LY2jtek0jJc5+599I1qu5TVU+v7s9yCM0oipc26tmcTjdUcORY3NEwPdrBhdEyYD3lUs1
	vORHBERR4ScZdMauX/dusdBJGhReaUdYfnjaEGlDcwi6x7qXrOW2JHghJCbtwhKt6fgdanvb0q7
	AUDf4a/8uMgIa3moThTA9XEXu207u6A9ZtJwX6TpcDIUGKcUHxvPFYXyJ7/qERXmOlyPciOsmbJ
	XI9
X-Received: by 2002:a17:90b:17d1:b0:38e:8300:af51 with SMTP id 98e67ed59e1d1-3966d20b09fmr23255966a91.8.1787810057653;
        Wed, 26 Aug 2026 22:54:17 -0700 (PDT)
Received: from celestia ([2402:1980:88cd:27c4:5897:46d2:587d:19e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b112b57bsm1361107a91.17.2026.08.26.22.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 22:54:17 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/damon: fix damos quota walk-position tracking
Date: Thu, 27 Aug 2026 13:54:26 +0800
Message-ID: <20260827055426.16874-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 17CA8100002
X-Stat-Signature: nse4b61jbff6dxnxf9gaq7jyg15jqh7o
X-HE-Tag: 1787810058-125234
X-HE-Meta: U2FsdGVkX19MISbfaAE0LSWu6HcE/qpRLipvC3eZrTE1VqXbqZ9vdW9sjztoW+JgwclQKVlFJ8wcJbOCIHoGgPHxAHAbFZSVFOtV7qPS5VyalQYXdXtB/95TONpUNe4t7rVWXVfs0OKWAEMgzpWRkPcfQhQx+P2+8Mh8Vm40UO2sAjreCvSUNul7AEVDpvgzBO6RGMbKwHA3JMF2d2vx6FgEh0EL9VbPJSFQnopN/bwA3gEh6AcXiI56GbVOy44gab8hSwC3ufJdyeBe9jKsmhzcgxWOGuynPHqlg0UEBEK1fekK3cTkcsTyZc560wFqeD5E/OVNrUcQ1dyip1p2mysSa22vwZ/RMW5f5XSSD9a31E7tfA7l9V1PTwOIRmHtwphOyRuBYDTm9KmEQ/AcgHzU5joIH/rgO6egVm6ZkJR8Do3ODG7wIhpEB3G/ub0Fzdo4uLaOKCWfnPeaRGeAbF19M6AEs/+BRn3O/l4/McWRhsK0at8qahKXHuExji0etZVE77h2C/pAdvPg0rqCbKtfd54FgFXrz0kruocQzAqAtFBFR6PTqrMkgv41rSoePPAN9keTTo3Q5GKdQWEg2Nr79CDuoIZgC4ysnpKry6CQ1TybTHcCOsXxjI8OvNzIWgE1rEUkZFBwrVdBHnRgjdBSn9LX5qljDf5jJc/N8NQbZnXupEZjAtQUG/EthEDUVoY7sEkiF3NChxUPrzsb5+IEj1uhfzbIzT+/OhLzrNPKOGzoBtEkBJWrtpQhERxS4ua/QhPpFHaARHgZLbzcqumb1VPELfFhN8+z7Cw4ghjs1Bkmj3jBX9oPRWczm7fVQtJ5vTclDz96l/qFymjFQry1p7lLdPweCCt+N1lFRQmtYyFW1Z0qE20omczA/2Y5l6FT8nZxUUC00EL9x0cK13Sm911iRw8hDMbzX2IqtA53Mz9i6XWOI1lP/O5BNYO99/OrI1kZtmSyLuzTXXI
 ybaVTVRV
 3sipNJEa0VYDfy7xQcWeX5foiqFitXeahNyOp4XNoeZBOH/XJBz8q4rCjTIWbElLDHjd61CgQXecTqAtUymkYMONViMSNf/z2mxYCULOfMLtvgzlCNSEekoG2Yup9vByjEtWIOrIdB7lEpxpaATn/AkRDXkR5tpCZowE4mstWQpjhnyNiv2ort2VSN3lh/6ECPTs85HkP4GIMxn1q502PiO5T6wlKg+KWypZ3C4oYypi5THq/6ZzwSu4DC7nMlpZ9UsMgyHBNTnBPb0NkJuJD1HNPCxOEkXGeUJqKlioCRzUMK7fJi3Ud46qxdOpucKNQGj3ZDFHxREwy07H8eckkfB5h8G6YFi6HdHo7HJuLu4wYquDuzBWhfuCXr97roDUpOGFrgGm4g1It02jNkUXKdT6LsqZNeKVyvoptDQK9gaSckPOWKSqBFCs0bphIH+BoDZIz2YHpGYlHBvV3HgbDetHAVL/eLJ3JpDzR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026 17:44:38 -0700 SJ Park <sj@kernel.org> wrote:

> On Wed, 26 Aug 2026 07:05:08 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Wed, 26 Aug 2026 18:24:13 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > On Tue, 25 Aug 2026 06:54:57 -0700 SJ Park <sj@kernel.org> wrote:
> > > 
> > > > On Tue, 25 Aug 2026 20:46:16 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > > 
> > > > > DAMOS uses charge_target_from/charge_addr_from to remember how far a
> > > > > quota-limited walk has progressed.  The current implementation has two
> > > > > problems:
> > > > > 
> > > > > 1. Once set, the cursor unconditionally skips and resets at the last
> > > > >    region of the tracked target, so the last region can be skipped even
> > > > >    when it has not been processed.
> > > > 
> > > > I don't fully understand this.  Could you please clarify more?  Maybe adding a
> > > > realistic example scenario would be helpful.
> > > > 
> > > 
> > > Problem: Unconditional skip of the last region
> > > 
> > > In the current damos_skip_charged_region(), there is this logic:
> > > 
> > >     if (r == damon_last_region(t)) {
> > >         quota->charge_target_from = NULL;
> > >         quota->charge_addr_from = 0;
> > >         return true; /* Skip */
> > >     }
> > > 
> > > Scenario:
> > > 1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
> > > 
> > > 2. Quota is configured to process only 50 bytes per window.
> > > 
> > > 3. Window 1: Processes R1 (0-50).  Quota is full.  Cursor is saved at
> > >    (Target, 50).
> > > 
> > > 4. Window 2: Skips R1 (0-50).  Processes R1 (50-100).  Quota is full.
> > >    Cursor is saved at (Target, 100), which is exactly the start of R2.
> > > 
> > > 5. Window 3: The loop reaches R2.  Because R2 is damon_last_region(t),
> > >    the old code unconditionally returns true, skipping R2 entirely and
> > >    resetting the cursor.
> > > 
> > > Result: R2 is permanently skipped even though it has never been
> > > processed.
> > 
> > Ok, makes sense.  The user impact should be not that big, though.
> > 
> > > 
> > > To fix this, the patch advances the cursor every time a region is
> > > walked, regardless of whether it is applied or filtered out.  This
> > > allows DAMON to accurately track whether the last region has already
> > > been visited, eliminating the need for the unconditional reset.
> > 
> > Sounds like a big change compared to the problem.  Why we cannot modify the
> > last region case?  Have you also considered other possible simpler approaches?
> 
> For example,
> 
> '''
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2686,14 +2686,15 @@ static bool damos_skip_charged_region(struct damon_target *t,
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
> +                               r->ar.end <= quota->charge_addr_from) {
> +                       if (r->ar.end == quota->charge_addr_from ||
> +                                       r == damon_last_region(t)) {
> +                               quota->charge_target_from = NULL;
> +                               quota->charge_addr_from = 0;
> +                       }
>                         return true;
> +               }
> 
>                 if (quota->charge_addr_from && r->ar.start <
>                                 quota->charge_addr_from) {
> '''
> 

Thank you for the example!

While your approach works, I am curious, why should the cursor be reset
every time the function returns false (does not skip)?

In my opinion, a cleaner and more deterministic approach is to reset the
cursor only after the target has been fully iterated through.  This
separates "skip" logic from the "state reset" logic, making the flow
easier to reason about.

Here is my proposed minimal change:

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2347,11 +2347,6 @@ static bool damos_skip_charged_region(struct damon_target *t,
        if (quota->charge_target_from) {
                if (t != quota->charge_target_from)
                        return true;
-               if (r == damon_last_region(t)) {
-                       quota->charge_target_from = NULL;
-                       quota->charge_addr_from = 0;
-                       return true;
-               }
                if (quota->charge_addr_from &&
                                r->ar.end <= quota->charge_addr_from)
                        return true;
@@ -2368,8 +2363,6 @@ static bool damos_skip_charged_region(struct damon_target *t,
                        damon_split_region_at(t, r, sz_to_skip);
                        return true;
                }
-               quota->charge_target_from = NULL;
-               quota->charge_addr_from = 0;
        }
        return false;
 }
@@ -2658,18 +2651,26 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
                if (damos_quota_is_full(quota, c->min_region_sz))
                        continue;
 
-               if (damos_skip_charged_region(t, r, s, c->min_region_sz))
-                       continue;
-
                if (s->max_nr_snapshots &&
                                s->max_nr_snapshots <= s->stat.nr_snapshots)
                        continue;
 
+               if (damos_skip_charged_region(t, r, s, c->min_region_sz)) {
+                       if (damon_is_last_region(r, t)) {
+                               quota->charge_target_from = NULL;
+                               quota->charge_addr_from = 0;
+                       }
+                       continue;
+               }
+
                if (damos_valid_target(c, r, s))
                        damos_apply_scheme(c, t, r, s);
 
-               if (damon_is_last_region(r, t))
+               if (damon_is_last_region(r, t)) {
                        s->stat.nr_snapshots++;
+                       quota->charge_target_from = NULL;
+                       quota->charge_addr_from = 0;
+               }
        }
 }
'''

> > > This patch ensures that every target is traversed sequentially and
> > > deterministically, even when the quota is set very low.  I omitted this
> > > benefit in the initial problem description.  If you think it is okay, I
> > > will add it in the next revision.
> > 
> > What's the problem and benefit?  I still don't get it.  More clarification
> > would be nice.

My original idea was to ensure that every target would be checked
sequentially, which seemed like a fairer approach.  However, upon
further reflection, I realize this might not offer tangible benefits and
could introduce unnecessary complexity.

Since the DAMOS Quota min_score mechanism already ensures that regions
truly needing action are prioritized, the current behavior (eventually
resetting at the last region and moving on) is functionally sufficient
for typical workloads.  Therefore, I do not see a strong justification
for this change at this stage.

Thank you for pointing this out and pushing me to clarify.  In the next
revision, I will drop this changes and focus  on the minimal fix for
Problem 1.

Best regards,
Rui Yan

