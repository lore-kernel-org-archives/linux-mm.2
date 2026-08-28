Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3DB0C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9203F6B0088; Thu, 27 Aug 2026 21:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D1506B008A; Thu, 27 Aug 2026 21:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C06C6B009B; Thu, 27 Aug 2026 21:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 552346B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:54:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF3E7140256
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:54:24 +0000 (UTC)
X-FDA: 85149008448.13.9C67EDB
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 237EB40002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:54:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jEG+7lRR;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787882063;
	b=zHh2ezveeRrS+ENoPs0sezv8RRVDKel5okIOVrv9mFvGxvSc1plyyZoO4QE5KS3ee30LMh
	K/1Z+BopREznmncDctpoDosCi0QDgNJvbUmKOMy3NOYlRgxcsWAgNpkz7GjikDw83grg06
	mVktXgOy2gkFdr2fd5Oo/SCLreUGdBs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787882063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vd9OkwVydrqNipxeyj51CTYPIro5FcNJ7G6Zlk0IYLY=;
	b=L5nE/1cmSMEIiu69/VIRGhGH1fF0m8+Mkw+sviEZ+EZFPkQc3UfSwisqrECw4VnFdI6ORm
	+zO8cJMdS7mhSPySXAkhbspiO/6RNRLbvnUFJprqfY3JdkLOvsnoUpLJQ5f+jVm8rmcHWq
	4CH4mqbBONGXxSt9xu6bp8uQWT9rD8Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jEG+7lRR;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8558c0b26a8so529220b3a.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787882062; x=1788486862; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vd9OkwVydrqNipxeyj51CTYPIro5FcNJ7G6Zlk0IYLY=;
        b=jEG+7lRRU+2zGbCIuQe7GwlV1XIJ63CMdNHc9v9rU42UC7/Gda80GxJ5VoksR5PUsf
         gCgqYgS7Lb2333TDSZZW/wxMzNuZxupsOyNrv5u0ra4706OthgSap1yHlu3sU4JfSXGO
         JXeTOJJwEfT48QB2Ih7LxebX+kT4/XGa4Y3tX+Mfjd937GS16ne70BYzjBhoU9y/INWd
         u6oXt1jpdavtU/LxXIWQ9rOhSQ08rv4nT7GtNTU1yxb0n6Sv0eVXhOsfFQGRENiN0j2z
         pAuIaCsgqf+Dw90n3h7ohtSYhjiprx88U8bT+WUW//QBaTCCJjvWziRWlKUglZhMtsni
         vnCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787882062; x=1788486862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vd9OkwVydrqNipxeyj51CTYPIro5FcNJ7G6Zlk0IYLY=;
        b=XZeqTLX2T9EGYhNH+6mZtv69+H/ZTyTBFZYdzjo/5P2cY90uS+gqUfqqrKA9tcdh1S
         ghTBMkzmPKaz2aQ6pkndVvLEMLASHo6dHnyCZEE6OinU28+F9Iu6S7hNY3JdzanHZbvB
         wgQBqD9CtqPdi2WpMPv8WM6QQSBwxMM/x5rtvWsM9v4BeFSYr9swHzxd8UPwInkgKbh4
         c3+CsEL/rV15tkSThsaMb+pZjcT6DjTTic/v3vFIX2+FD/aVI+DICx+7jxX2nOT6caie
         nQG1/iJnTl7nXGeAh3Gkawe4JSnGqe0FXnU87Kx31CA8atb4JVse5RJyvxTXOuRIgPJi
         +VSw==
X-Forwarded-Encrypted: i=1; AHgh+RqBY3C6l+W31IFyZZOWAyQ1MKsrG0pFU6D6YOUm3qVcwIOFpcJhVTpam9u4KytCNmQqgmxzrvTEWA==@kvack.org
X-Gm-Message-State: AFuF++kT+F4gW6qjblNJLp6BUXK5ZFUKiJeIlD9NvkP/51W+UIZF/4Wu
	Te/tH1JST2bEBVWoywjjFSmHU94Xu+WDRkDoPRtKPm36gnrmMtXF7EaA
X-Gm-Gg: AR+sD10mmXJmltgeQDMhp1Wz9BIH8f5MkRCe3+1LLg9IEAPoC0Dpw8VWD1XT79jdGTD
	IeTz7WODjEW3AmMhOCjDkNzjEhR08eZTQG1hOzl42eb9CMkMYH47TjYcS5QqEJBN0qe8tJyNNd1
	fNjykJVU7kL3GHR8lfpaiE14B0xnhG3zT7J4k7So4LIJK1OxCtf/0p190NP3TyVIBk6fgC0lyJ1
	dlotD6nitA2xYW/8LRYtbpPX3Gu26nY9YKAm1kvflAVPSDh+Wj59TRnQ3HLGGkZ/GJnXPZVs7Kr
	lQ9eKeTPvtssmvmLTeklchqtSzuHflmmSvFpl0EbF9oP6dEZuvQnD+0UkLkDGVelx9xY0PsXglT
	x1m0VNXpSC7dZJb5c0jLNWOwr4PGuQAs3yvgi3ORPBzx7vrPCYCC22DJDZ77McNTMFs4X7pHyDX
	Z4Se/5REqIuqpbjL3whcxaCUuWUyBIxw0K8+a28RZWuy0pgjZNzh9R0eWYP54ZVdo6FA==
X-Received: by 2002:a05:6a20:158d:b0:3c8:d3a4:7b40 with SMTP id adf61e73a8af0-3d266ebcbb6mr5931228637.2.1787882061816;
        Thu, 27 Aug 2026 18:54:21 -0700 (PDT)
Received: from celestia ([2402:1980:88cd:27c4:5897:46d2:587d:19e7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f3312146sm58242a12.8.2026.08.27.18.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 18:54:21 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: fix damos quota walk-position tracking
Date: Fri, 28 Aug 2026 09:54:29 +0800
Message-ID: <20260828015429.131338-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260828004049.62386-1-sj@kernel.org>
References: <20260828004049.62386-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 237EB40002
X-Stat-Signature: shqm7bo86kbqwkxn9e4wjutdrzaqaw99
X-HE-Tag: 1787882063-402256
X-HE-Meta: U2FsdGVkX1+7Zxbelkc31gxdrxqFeqQkjJO9aBBxRc4ndqmsYJxsRNx6QA+dThTj6ukOlx3iOikqeTf4Eds5CZ4x5x9gJmG16Pu7a05qEpyQewFUGuEK6edDa3UpsR4EoAibHvGhDlhePkyI1eoY+32wZOad2S0BU6kJTg7WKnBFpzs+eyk5520if3ig3G2MlF+FM5AR0uBtK/8UrTTwkTyrXTScCK5+hxDwkJLvAEzXLLrn+TosCYj3jpgaxIdHlggIalceViMnfv5Xvu9joTqvb1llMDErj8vZHGgJLKFMCjsd448YUrSpa88v8McMZnrj9jZyKnQHgZPBYMJjq1QRrUB0VjCPRKp4qZA972beJ58C8lFRI/UBiiCmmgPmyDq/KROg1GprZZg6bJMHfbL9KTiGAZQTdF1umlFfenEH2CWo6B1STJzd/XPTKmOu64ZO7hKq1EdRRauQNXgKcfpSI/7alms19G+5kU1CadnQvOeOE2VCMIs3z1f4gnSn16/Qla4s4msylMnS0ERLedsHJpV/ZqvaKizPDi4QgeatI5DlnCzSoh2q2UXa6PBZbhBZsbP9S09a5+LL1QMdxfMK6r8mx3PTO8z55VmDBA7phJiRUw27xywdkqnwm3WeWQX1qAo3XahNDhoupC1S4lHU3QbPjs/FwNu/jQoLFu45DYQkdkJNlXl1Cspyq+C2pz50TBB0uvC9VteG7K7RNbdif4h2a9WKvCMilT6fyMhfLyqC7oWLHr8sgPUTsDgy53SdbCgMf5KXbyPrlb+fhb9ywK0cJIELiNWmyBDJuWuCPY5ZLX7dQOGK+IIK+dAfyKA8HULVN5HF2EeLYNawBkdOaaxDe+mx7ubR2rliWMU5HsSAkvgjtCcBi2eQ2UyRUQxEQoTg+XGODRry0O9k+RJYWWPVbpHQ63Et6uWd+LPhrQZD1p3KHzVK4+2LubbkwPkaGUvVROFkj0uwI1n
 L1yzb8KY
 aScMt7pyoIXbi1ch7NVKcb0yQqO+36j3JORES1szEikXeqSs5CU6g7p0hNv/HCbEaBjf1Izy6hzSp3ztYfFE3kAst+gYn9T1uFaH12EmLVbvmC03EHxifzhkuh4Rp5ftg2N4D7/BfKwmNJFbiVHmXL2uSUjSKUihUE5LnGE8bFvuokVFL3RvZKRGrfswkgQZGO6XzZmMqktxBV8kCm+omwXazMHLbpszZdQrI0cccJlEemzvBuTR97gJdZztYsSTqy3Du0amhSLykBf195V3F1w5UVhfBakTTjlqA7cJmMyOQlmm1lBqaoeoNvfm5ZehVO6akVL3KMS/0rn5Au+CRczvN1yHZILK46CAgDwcU4rB4frjWBLEtNPO723rU5/WkdJV/k75QRrxCHpch8/v4pLoIpGn2w38QN6jOpLIzhK8GuqdyFXjoFCQNYkmtPjyn1UrM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026 17:40:48 -0700 SJ Park <sj@kernel.org> wrote:

> On Fri, 28 Aug 2026 02:08:22 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > On Wed, 26 Aug 2026 17:44:38 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> > > On Wed, 26 Aug 2026 07:05:08 -0700 SJ Park <sj@kernel.org> wrote:
> > > 
> > > > On Wed, 26 Aug 2026 18:24:13 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > > 
> > > > > On Tue, 25 Aug 2026 06:54:57 -0700 SJ Park <sj@kernel.org> wrote:
> > > > > 
> > > > > > On Tue, 25 Aug 2026 20:46:16 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > > > > 
> > > > > > > DAMOS uses charge_target_from/charge_addr_from to remember how far a
> > > > > > > quota-limited walk has progressed.  The current implementation has two
> > > > > > > problems:
> > > > > > > 
> > > > > > > 1. Once set, the cursor unconditionally skips and resets at the last
> > > > > > >    region of the tracked target, so the last region can be skipped even
> > > > > > >    when it has not been processed.
> > > > > > 
> > > > > > I don't fully understand this.  Could you please clarify more?  Maybe adding a
> > > > > > realistic example scenario would be helpful.
> > > > > > 
> > > > > 
> > > > > Problem: Unconditional skip of the last region
> > > > > 
> > > > > In the current damos_skip_charged_region(), there is this logic:
> > > > > 
> > > > >     if (r == damon_last_region(t)) {
> > > > >         quota->charge_target_from = NULL;
> > > > >         quota->charge_addr_from = 0;
> > > > >         return true; /* Skip */
> > > > >     }
> > > > > 
> > > > > Scenario:
> > > > > 1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
> > > > > 
> > > > > 2. Quota is configured to process only 50 bytes per window.
> > > > > 
> > > > > 3. Window 1: Processes R1 (0-50).  Quota is full.  Cursor is saved at
> > > > >    (Target, 50).
> > > > > 
> > > > > 4. Window 2: Skips R1 (0-50).  Processes R1 (50-100).  Quota is full.
> > > > >    Cursor is saved at (Target, 100), which is exactly the start of R2.
> > > > > 
> > > > > 5. Window 3: The loop reaches R2.  Because R2 is damon_last_region(t),
> > > > >    the old code unconditionally returns true, skipping R2 entirely and
> > > > >    resetting the cursor.
> > > > > 
> > > > > Result: R2 is permanently skipped even though it has never been
> > > > > processed.
> > > > 
> > > > Ok, makes sense.  The user impact should be not that big, though.
> > > > 
> > > > > 
> > > > > To fix this, the patch advances the cursor every time a region is
> > > > > walked, regardless of whether it is applied or filtered out.  This
> > > > > allows DAMON to accurately track whether the last region has already
> > > > > been visited, eliminating the need for the unconditional reset.
> > > > 
> > > > Sounds like a big change compared to the problem.  Why we cannot modify the
> > > > last region case?  Have you also considered other possible simpler approaches?
> > > 
> > > For example,
> > > 
> > > '''
> > > --- a/mm/damon/core.c
> > > +++ b/mm/damon/core.c
> > > @@ -2686,14 +2686,15 @@ static bool damos_skip_charged_region(struct damon_target *t,
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
> > > +                               r->ar.end <= quota->charge_addr_from) {
> > > +                       if (r->ar.end == quota->charge_addr_from ||
> > > +                                       r == damon_last_region(t)) {
> > > +                               quota->charge_target_from = NULL;
> > > +                               quota->charge_addr_from = 0;
> > > +                       }
> > >                         return true;
> > > +               }
> > > 
> > >                 if (quota->charge_addr_from && r->ar.start <
> > >                                 quota->charge_addr_from) {
> > > '''
> > > 
> > 
> > Thank you for the example!
> > 
> > While your approach works, I am curious, why should the cursor be reset
> > every time the function returns false (does not skip)?
> 
> It doesn't.  It resets charge_{target,addr}_from only once after the regions to
> skip are all skipped.  Am I missing something?

You are right.

My concern was that the current
'return false == reset charge_{target, addr}_from' might be a bit hard
to understand.  However, I realize that my change was quite significant.

To make the existing logic clearer for future readers, I think adding a
brief comment would be helpful.  For example:

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2368,6 +2368,15 @@ static bool damos_skip_charged_region(struct damon_target *t,
                        damon_split_region_at(t, r, sz_to_skip);
                        return true;
                }
+               /*
+                * Reset the charge_{target,addr}_from so that the remaining
+                * regions in this/next target can be processed normally.  If
+                * the quota becomes full later during the walk,
+                * damos_apply_scheme() will update the
+                * charge_{target,addr}_from to the correct position.
+                * Otherwise, it implies that all applicable regions in this
+                * target have been processed.
+                */
                quota->charge_target_from = NULL;
                quota->charge_addr_from = 0;
        }
'''

If this is not necessary or redundant, I am perfectly fine with dropping
it and just applying your minimal fix for the last-region issue in the
next revision.

Best regards,
Rui Yan

