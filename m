Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4EC4F45A0F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 23:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361F26B0089; Fri, 10 Apr 2026 19:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312816B008A; Fri, 10 Apr 2026 19:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229436B0092; Fri, 10 Apr 2026 19:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 169616B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:55:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DA8C14060F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:55:39 +0000 (UTC)
X-FDA: 84644305998.03.9E0AC17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0C2E3100002
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:55:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QiCNVA3p;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775865338; a=rsa-sha256;
	cv=none;
	b=Ql7E6bXhGF1cWOj40lXzCUei6UgY4t3Zr1DNjmosSSHOZg9XYBERh3Xs6XRK49XF5T564n
	SR+GL2e/71NkYWB9v+bh1zY+VXz9YOd4ji59woN8uFk5rVrTP9Ldch8uDlQ7E2b+kbYBFK
	iFOGxlJxmoEgtKjep+ckLUPDgv3z4ug=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775865338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zE/vdtBFa2ECewv5xoOY5lscrf5s9YqwSkuoPFtGpDA=;
	b=r+/Z2fsXctuLWoqn2uS/6pRjBeTWRO21RTn5Vtdid95rkvg9poB5pz5A9+K8OGtG+oLLSx
	9uuxJhelDkjrYKkzuuzwBtoY5cExdsDH1RJF8GHZwJMR9l7aYHqvoHobHWONlUQaajiMNO
	FU3r/bvn5qAw/FiOhYHYcP/ThfJhhQA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QiCNVA3p;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5933960142
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB6BC19421;
	Fri, 10 Apr 2026 23:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775865337;
	bh=zw2XYHDnlTw0qahEiBS32vzXn4QNwRFUrjs/0wSN/yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiCNVA3po6Yxr8/tG452qobIJP2c2RhkzOCWFUUS/Y4TeXCnBhnZZPHPefmndSb7G
	 o6RZWXMZ2GWPsXRcHxLSvswNhNFaaPx8tO/+oBzqeNDv8wZ7PtndWSP8sSsOnVzq/f
	 DABSpZFfGpj3AuJ6IjSQPBFJ1nx5whO8CpL/4CWc5qSryGLdDIwZTalwl2zNuBzF/7
	 yrhOSbsvYzXeH3nNI2j9itsT9wK2Sww0GKBFBDLbs3e8qL9zR9rlhc1g+XKLxwFaVK
	 L/c69jZGObXUmGOHRD8xVvmse2MPfOvxN6AoEhdxkzRLpuZ1/8LcIJGou4r6Ndc6HD
	 aeFqXDAxPu2dw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5 02/11] mm/damon/core: merge quota-sliced regions back
Date: Fri, 10 Apr 2026 16:55:26 -0700
Message-ID: <20260410235527.90900-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0C2E3100002
X-Stat-Signature: wbt4b11ypnimfby365q4tk15qyaskqxe
X-HE-Tag: 1775865337-115250
X-HE-Meta: U2FsdGVkX19mqDJW2V4fy/YeUCNJjCGqfzN66IjUlR18mOaVgXC1/QuRDce1siRigxUma/ZV6KBBCJahxXnjeNoJ7wlfXlDEr9aETUMWodtw6kzshLGqj+CZQwJTI8eu74KA8/4tUV2kvsRFL5ncI4MZYXEXtz9PCy2M8W4jgAUZSJBoMnDTOhPVgp/Oo2IoylVqXqal/1iu1U9H3qmGWmvNvoaI5KyAWDjdesq4z0Ur9PV0P5ADtlaDHEbV0PFf1nTPELKE0cBuDqmazHinDx7N0rzEQsGj3sb9ekkz9LaWMIMwd7R59O5zqXWmLX4CC7EyhZoGW3cDJD36QFsWT3TghxQV2cRnoDvkJRpzMyt+/ZyVrx17CJwNUppXfB3FSuOE9xqxhSlaNJ+aj4nqQsOOBRpo6V/L/tM9s7DBvPtnWWhvlEyoeQ1/HopqQqhIXEXHTiqqKMBZi5pc4gNT/JPT996lLDm6AQ2Ll4HNo+RYk8kzPeJxLwioM4E1SsuJEuKqJ895G+ldlf7HBUaPzQf8AuJrqAE/8tv5nFPsouCKw2Hrcbu+eJnF2egIzrBr3o2E/Xw82Qtf3J/z6ggGVsA1APW0FMJWhf1DdNt2dcwb5q9kXemWp++5X9u3NC+1Xy2cTkspuuxIojPcrTbwkTdIdWuMU8c6seGpMguZKYZywuUOvF/r81s9TSolwI+4q8hsbJINPw2LaFIpAFol5e+oawTF7+cklfhlSvN0PR7aAGtqurkWIjB/7R0xPfROyN8qXQVjMmvmvcRBeTUkhyWn6iixnh1pm/6n89A07CxAjUPWcgK00GJHm+qc10nmg3tgujGKvRwz+nrLO0Xm/alzFyceunZDESY4chCHCtm5tW7ammFL/tBY2nlsyV5qnLPQ0NIsVcvbYrWl+Ry/csMHNH01ODeDhhscBSd7W5KpOD2/1LFR1vZqU0nFQzqgbG7Wyx9tSkhgRml10gJ
 QLFpl1Jz
 aeKZUlD5kg5ASA3Rzy605ASWaw234iXkW7MTYvJ+zX2+HoMTkfB98NWmNDSPwyVB2X0H0P+5SnCSwGaABRwbvzcl+npjTZhjC1MwhnuYT+J/dZfOTpilzneVEeu7MQO3ns6zi91AP7MQFRPKIhyeZlJ9/oQqRtuFok1vFsKFAOlQZaY1hTUh2SNmAzXpYLGXHFIRwM+xJGn21BqSX3ebIM2a0Obgqasls1wAzuaDlhiDnOEfPCpmG3VOpkhO1cu0cyZejG7+fsPjomMnobJcgHqvIx3eXdulqSbfIdS10vGSvGuh0MWU3ZB8CEKJDEOQazycBtXsf3yz3soUErgXCSwCMw2sYgs41oMVlL6I3aFoQp95NcCozF6qzOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko found an issue.  I will address that in the next revision.

Forwarding sashiko review in a reply format with my inline
comments below, for details of my view and doing discussions
via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260410142034.83798-3-sj@kernel.org
> # start of sashiko.dev inline review
> commit ae9f581463db42127fa24541161baf201709d5f9
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: merge quota-sliced regions back
> 
> This commit merges quota-sliced regions back together to reduce overhead.
> It avoids merging regions if their age is non-zero, meaning no scheme
> action was applied to them.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 8dbc365bb8e97..97b375c720251 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > +static void damos_apply_target(struct damon_ctx *c, struct damon_target *t)
> > +{
> > +	struct damon_region *r, *orig_region = NULL;
> > +	unsigned long orig_end_addr;
> > +
> > +	damon_for_each_region(r, t) {
> > +		/*
> > +		 * damon_do_apply_schemes() could split the region for the
> > +		 * quota.  Keeping the new slices is an overhead.  Merge back
> > +		 * the slices into the original region if there is no reason to
> > +		 * keep those.
> > +		 */
> > +		if (!orig_region || orig_end_addr <= r->ar.start) {
> > +			orig_region = r;
> > +			orig_end_addr = r->ar.end;
> > +		}
> > +		damon_do_apply_schemes(c, t, r);
> > +		if (r == orig_region)
> > +			continue;
> > +		/*
> > +		 * If no scheme was applied to the sliced region, the age of
> > +		 * the slice ain't be reset.  Don't merge that back.
> > +		 * Otherwise, the monitored information of the region is lost.
> > +		 */
> > +		if (r->age) {
> > +			orig_region = NULL;
> > +			continue;
> > +		}
> > +		orig_region->ar.end = r->ar.end;
> > +		damon_destroy_region(r, t);
> > +		r = orig_region;
> > +	}
> > +}
> 
> Does this logic safely handle cases where orig_region and r have differing
> ages?
> 
> If a scheme applies to slice r (resetting r->age to 0), but was skipped
> for orig_region (leaving orig_region->age > 0), the check if (r->age)
> will be false. The slice r will then be merged into orig_region, and
> the reset age of r will be lost because it structurally inherits the
> non-zero age of orig_region.
> 
> Could this cause age-based rate-limiting to be bypassed, allowing schemes
> to erroneously apply to the same memory regions repeatedly in subsequent
> intervals?
> 
> Additionally, if both orig_region and r have the same non-zero age
> (e.g., both were skipped), if (r->age) evaluates to true, setting
> orig_region = NULL and skipping the merge entirely.
> 
> Should the merge condition verify that the contiguous slices share identical
> state before merging, perhaps by checking if (orig_region->age != r->age)?

Good finding.  I was thinking the scheme will anyway be applied, once the
quota-split is happened.  But I was wrong, since DAMOS core filter is applied
after the split operation.  Also, age is not reset if the action is DAMOS_STAT.

I will address this in the next revision, like below.

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2439,35 +2439,32 @@ static void damon_do_apply_schemes(struct damon_ctx *c,

 static void damos_apply_target(struct damon_ctx *c, struct damon_target *t)
 {
-       struct damon_region *r, *orig_region = NULL;
-       unsigned long orig_end_addr;
+       struct damon_region *r;

        damon_for_each_region(r, t) {
+               struct damon_region *prev_r;
+
+               damon_do_apply_schemes(c, t, r);
                /*
-                * damon_do_apply_schemes() could split the region for the
+                * damon_do_apply_scheems() could split the region for the
                 * quota.  Keeping the new slices is an overhead.  Merge back
-                * the slices into the original region if there is no reason to
-                * keep those.
+                * the slices into the previous region if it doesn't lose any
+                * information.
                 */
-               if (!orig_region || orig_end_addr <= r->ar.start) {
-                       orig_region = r;
-                       orig_end_addr = r->ar.end;
-               }
-               damon_do_apply_schemes(c, t, r);
-               if (r == orig_region)
+               if (damon_first_region(t) == r)
                        continue;
-               /*
-                * If no scheme was applied to the sliced region, the age of
-                * the slice ain't be reset.  Don't merge that back.
-                * Otherwise, the monitored information of the region is lost.
-                */
-               if (r->age) {
-                       orig_region = NULL;
+               prev_r = damon_prev_region(r);
+               if (prev_r->ar.end != r->ar.start)
                        continue;
-               }
-               orig_region->ar.end = r->ar.end;
+               if (prev_r->age != r->age)
+                       continue;
+               if (prev_r->last_nr_accesses != r->last_nr_accesses)
+                       continue;
+               if (prev_r->nr_accesses != r->nr_accesses)
+                       continue;
+               prev_r->ar.end = r->ar.end;
                damon_destroy_region(r, t);
-               r = orig_region;
+               r = prev_r;
        }
 }
'''

> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260410142034.83798-3-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260410142034.83798-3-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

