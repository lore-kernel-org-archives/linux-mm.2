Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D52C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 18:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48F36B008A; Thu, 27 Aug 2026 14:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20836B0092; Thu, 27 Aug 2026 14:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0EDC6B0095; Thu, 27 Aug 2026 14:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 880916B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:08:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9AC21C02DA
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:08:15 +0000 (UTC)
X-FDA: 85147833750.23.D2DC3F8
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2A07D80005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:08:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mb4mBA7T;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787854094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plMv1alWLSmRUs996GTzyKVxl/InS+Hvvr87SnLX3mc=;
	b=ll1An05XagZhi/9RfKyjlKUfEQTWc+F/vo5ObmmQORNeCdyKNxA0V2TyyV6gUzF906mej4
	n9PiAtiSZEKnfoEckJCm2RUfWWcNGyMurHI1HcGHrgdo8iWJz2ZvUndfPH4WUffykkRo/D
	9s64nlWIW88S25KrW24+ScG6sUuvQJQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787854094;
	b=IZYpgTEzad03dllQ19/DfB/uFiR1y5moIFwlxwWCDcWvqBFyLukYyn/F7LnHPLRlxj7rq1
	VSP19qEX4gmR2GofNTmh+4kv3v94hruINZF2cbp02URiYhiwm1dWuFHMggbEYpxcyjflDV
	T6UUYU5qsmajfTxtFtOcE/UFdawyZEE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mb4mBA7T;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38759bcd877so379036a91.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787854093; x=1788458893; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=plMv1alWLSmRUs996GTzyKVxl/InS+Hvvr87SnLX3mc=;
        b=mb4mBA7TluTyUYR4W67LVeBR64c6JWq0MdMH0JWQl35iCydIwhvb9j6MbBk5r/TRpd
         qRNLzAxBvYDPdxtCMiIUyuRdwdblM+0lG07/X3n3B+dW3vRoqtiYdujYQVpbQtWwUpO4
         nrNS1pmIo6+jzs4yUhFjWWBfyNbXPCltbinzNVv3WRkJDClNoC4rIG+e097p2XahHX+k
         u6mbpJQC1VqujnDKyFFA6/gXK/Nb7ZicVPVAG7Y0Zmffm0CdVaM1aa5ldCm6ZXucYstA
         t4o16t5T0HIhu6UdxTEEHrS0XHd7iidnDnv49Dk6PmPhTz3BQi2fJVhellbh4G7Cm4nd
         fogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787854093; x=1788458893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=plMv1alWLSmRUs996GTzyKVxl/InS+Hvvr87SnLX3mc=;
        b=ON/db4N6pyEBMW5q2BcbONeZPRfIGjfkzNsT7qmJqRe9d+XEWc+xfYC4/bkudKcN3y
         mOTwYBJrQKut0/din4llifu+5RrWfDRn2UY56Zov58DNAKou0Ac/kyQBrsmXwTpEtawr
         qm/B0EKQe6xWshkIzp37yH1wYpFVSkNNP8CIGHfRIyhb2HqSpXD+fbYIj4LcsN0MrMml
         WlKbYS8tO0hZhgGdJkdit85Hi8XAoeroW/pNkyaTZcgk61D6Dglv0owrRYVWA0koy7Yu
         RgtxpQK3nMr9WqL0nVWv7nKDVxlUVnPsjklE5XJR4QIvCl+eHOcprcl98yCmt1OFgtL1
         qqIw==
X-Forwarded-Encrypted: i=1; AHgh+RpTovUBL4jQzgbQx9RiSM4WFB4sbVzzHo78PsogiqfimP/dvqFB5snzp8nuosflhlQnmDSr4BvRaQ==@kvack.org
X-Gm-Message-State: AFuF++kKpV+GizyZpCAjn/57x3VEbIuSRBTGasCQUALH2Q29cT29SWyc
	84c90/HLClN9C/Mr4i/k8WQPeizoBAAA2AOKU+h1c1mmk0SuekfMUcHZ
X-Gm-Gg: AR+sD11gTa8npecPZE4p/On6NrMtaQwhSLS8MmWNaedDykE79K/Q6a8hwlVMVihraXV
	e27225F76mZ1THg7aJxcghMq6BRMWX/z+bmXm7Q4+see26IeYVl+qe3NisHLWfwvfi37wMrRIUS
	t2Iw+1brU85oHxGOtnz5I03qtAJuPTxNAKSdrnN+ynGfPudT1oau3uyPf6dJwstT2EY7ay82fm/
	pi7gt2htxIS9jB+o99KPooyGdpHVipU0zZV1xqlTQmf4XNSDG7RtZUBvJKcbCxfMgkmuKGrYfQb
	qXsA45osrmv0B/ClMZHSEQv+M2HLynB31l+7FocXHm+KQJqmpxTcDhZEUFyKbi2PXFDu8T4x4jN
	7w6ZSwYbOL7uykiajuuaiarjrWa2EHqTWr6RdaDzpPlYJ4vMhzOurOx5g0BDgZHJO/65qfDGy+S
	WhpDehdscb7X7olmEJVliACJJBBt0YB/dwz6IzgNKWlnACQI6unlQmL7PTM8k5cDXaI4MEbqIrN
	EONcQMsjJchCI03WVs=
X-Received: by 2002:a17:90b:440d:b0:38f:bbc:6a0f with SMTP id 98e67ed59e1d1-396d0e5f35fmr1346864a91.1.1787854092659;
        Thu, 27 Aug 2026 11:08:12 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:88cd:27c4:5897:46d2:587d:19e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0d80008sm3682194a91.6.2026.08.27.11.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 11:08:11 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: fix damos quota walk-position tracking
Date: Fri, 28 Aug 2026 02:08:22 +0800
Message-ID: <20260827180822.4037-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827004438.82746-1-sj@kernel.org>
References: <20260827004438.82746-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: npekc3md4jqq3gk71prztr8sshyqohmk
X-Rspamd-Queue-Id: 2A07D80005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787854094-550471
X-HE-Meta: U2FsdGVkX1+M6pNVryv4lSjdGYpq/EZxiW8VJJ53GHRw+xydKVo64DFdtKD3IYpnEkmwCtOgRNsMleK5HIv4qUeeIHjU+KjqWw1kn0HWl+ANKDJ0CipnWn7LWfZCHX8LKcuLw63bJh0uDSoGdlgY89NpRqQRNyrKCfnmhY15Fr3LqWdT9s86NVAbyNeH6aU/oG//WhNNIOa79lbTUXIvzGAaFfZvLz9CfZX9sY8j7SRKn9SQd2oIYu9YoYS20ClktHuv4xMhPGvZ0vi6zkM6fy06hYtNv+x+Pq4pXt3V3UogY4IStQbrcRrVp68rZdhvs/qiYBhGRIaYlECpM1LlmUdUoQpi622oFKdBcODB//gAjH9DSuLv3EYQlyXWbjwn8fFkLw6efrBw8QO3/tDH19mwIrsR58vImX0FsJpzj2b2P6hhIpeVhpuRhY2U0ykbyCSHUi47ZlWVv7KlA3biJf9qACrp6ocYvdC7Q+6AlOOo5c04h6yb3APpcDVMgqfCQgCqFUgms2eWgAlIh7BTtQTtxmwGf7TOyIlS4ICjIwOPcBBgMnu/Y9usNuE3t9vawo0+eiuL8RtzLpyYF4mhQEM3yNQmlNwL1bDDHjv+4p0GzPMtbL1naFQ5nUKYFM2+mELFMn7a5sWE9yBIruWfJjnzMLG0DzbLsUvjuAk57zrZHUzI5gWk4yGqZi4+bHBaYpjCSLlxEW7GYxIZAytvQdGJtIW6v/NXmKMkmWQiFxuRgQ43XUWXEYt3aZwXd67dnuY883lS7UzTG1Wuwfjg69Px4pH0DKHw/xD45K6q8uypt4rIhae+eEMKB5WG4aIUKl14wsnL+OphhhezapGYiRQuJgpnSa/IFGyC8fnmVLZmA7meQwmUvt7YOAQnMSd+2Pi18oGCRCO4C8Cj48UgJFON13jPotUAN27RW4RhSAU+zB5ak8w67kmF1EA5Nrmt9Mh3JXmENpSNV8lelYE
 WCc5YACO
 n7F5tP8gSsOovPtMWGvCAb+puWw3THFV/OCB2MQIzEzWeWw5N+Ob4tqpzx2aB+qGNzxc8wk4vIqx26WiD83M8C+4Ru4DfBFGHE0IuX/UwQ1+b0eaHRUUEpmYjShwFn7H/hJ9tGG62JuDuecCuIWCLsY3CVmvzmGFF0QyPL7xq6qsmHDOI6CNKDkxG3mZGRr7sVVCmD7E3C3HMYSH1Pom4eS1aocxoDGhg3tXuAvVorkXxWe5M0eUu2WrVCLaUjMsdwhaqVeXxuNiaGXwfAkfmLzLi7JGPiSVuW6cbBDA8MgoQZ6L9xjpAgfmM9WHxENaTEqBEOoXuF8SixWZhsJMYSFXBG66wjAJEEF4yvMS/dtgzVo5vQsJSrZfZ+aVFjYcjtVjmVBFSfM+EyZyvCIT+gIIT96isRBgPw9jr6PVJN5e0AszCP7LmFb3S+BRxPxnRIBHu
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
revision, I will drop this changes and focus on the minimal fix for
Problem 1.

Best regards,
Rui Yan

