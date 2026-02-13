Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4009EEA87F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 02:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3BEE6B0005; Thu, 12 Feb 2026 21:43:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBFA56B0089; Thu, 12 Feb 2026 21:43:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB1A6B008A; Thu, 12 Feb 2026 21:43:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7026B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:43:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B097BC18EB
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:43:47 +0000 (UTC)
X-FDA: 84437888094.03.876B1BD
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9858580004
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:43:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770950626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8ydLn0FmLonUtlU5Jw8tJH8YhPfwxnIWq2TG/ACdy8=;
	b=HMWOxWIt6/vic1GVgByDx9uHUiTglmzMmH0OEXXX8H3t1VcS1f9IaB0RWO/zngbL9TGYMC
	5oBaZZz69Be3PcbsO4T8vj74Urk34IAH6Oo4Nkyt8tUlGDJzSP7HrI3teb4j5LTEE9whNs
	dB64U5I9qbMLikVpwrtB0IGjkYxEf7I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770950626; a=rsa-sha256;
	cv=none;
	b=MExEVfEBA8+089sahDFDBrCrYSN3Bt29yO6/1eJcI8CLt4Y0RIahjqrYbcsrf46Y2v0sBB
	ED5c3yMYgvIWZXyw3dudsLdkC+S1pMJWoPGluWlHssE6T7yBczan3p7rsLBYG38dxNxLSq
	uQnlS4za+RKgHMEvWBnIEFVJtJWF17I=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 13 Feb 2026 11:43:41 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 13 Feb 2026 11:43:37 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com,
	taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <aY6P2ULxocDT7HV/@yjaykim-PowerEdge-T330>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <CAKEwX=M5nH3=aqSLybCfLrtScpYKz+jRWt3JYG7im70DCoyjJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=M5nH3=aqSLybCfLrtScpYKz+jRWt3JYG7im70DCoyjJg@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 8enqogqmjuyronmjugjxziri4nbgz7tk
X-Rspamd-Queue-Id: 9858580004
X-Rspam-User: 
X-HE-Tag: 1770950624-706157
X-HE-Meta: U2FsdGVkX19hf9DiPAw3U9KuZdYDXYbIM0KOZK1lEE6IT0C9vTG3Z0S7pWO2YpxiLZLsTo4pgC5RsWukfWAlLtx82lcZamktUOuCVgsh5txrh6JDUQ3gDahM2lJ6OdfhSBAPzV92Eq2lJNmaCnqBi8bGmlC9h69osORODtbjUDu+gBw5GHhCMKzqcjv7PnRm99I99aF0gIsLEbSrh/9FA+3VXpvXuICOENoTfZmn0Vt7wIYJTRIoy66FeASoA567G+sPlfdcMWTQYQr5PtngAiZR89RSR+FZXWsmnckaaxh9li9hjre6hj5CEHx5STnDZgIflF3NZfNpKigcN18tzIGA/OKYO8bPqdf/ZD09fBZuDPPZxHPOgXxIkGu9uvJQGSM+JDyaT39oCw0RzCO1MQE92dZEKD6RQxeyWhDQwO5s8jphoo4dy2D2cbX/yFlCU2ECXVT/UW6xKj6KBwqsUmsqud+paBODI2m2ILOyRhvtAJPdm/Xu3yblKiX3GdmPxXfTJ9ETe94oB3U+2ewolCVCXwR/W9quQcjB44no7Kte00joLodoiK3fA3tBguUX6EUIJ9lSJXEy4htSJWpr3Wj6bEfM+feOuuloLs9alfkDyVLKdP+l8bU5zFalR3SwdmhZWckuXm9Ypb1lMoQPVOyg+eqh1iXR0/Wq6mzUuR5tKJzRQnW3v2brHbGKBpbzlWXj0r/PGvXqegxiBk0D+eYLQyoEMR5myfjkPWb+IAaBpygdf8wNdbjsenPK7LrQV3KNzKiyL/jQtktD/JAcWs0Yx4rvCUhxk1v5V7ztWSkcRhxG1s7eFfyGNyyntrAeeYWTAnvawxEXnfR0YRGSs71U29d0Vvg2M7YelCgSd+zW+HDgRGSP9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 09:57:40AM -0800, Nhat Pham wrote:
> On Sun, Jan 25, 2026 at 10:53 PM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > This is the second version of the RFC for the "Swap Tiers" concept.
> > Link to v1: https://lore.kernel.org/linux-mm/20251109124947.1101520-1-youngjun.park@lge.com/
> >
> > This version incorporates feedback received during LPC 2025 and addresses
> > comments from the previous review. We have also included experimental
> > results based on usage scenarios intended for our internal platforms.
> >
> > Motivation & Concept recap
> > ==========================
> > Current Linux swap allocation is global, limiting the ability to assign
> > faster devices to specific cgroups. Our initial attempt at per-cgroup
> > priorities proved over-engineered and caused LRU inversion.
> >
> > Following Chris Li's suggestion, we pivoted to "Swap Tiers." A tier is
> > simply a user-named group of swap devices sharing the same priority range.
> > This abstraction facilitates swap device selection based on speed, allowing
> > users to configure specific tiers for cgroups.
> >
> > For more details, please refer to the LPC 2025 presentation
> > https://lpc.events/event/19/contributions/2141/attachments/1857/3998/LPC2025Finalss.pdf
> > or v1 patch.
> >
> > Changes in v2
> > =============
> > 1. Respect cgroup hierarchy principle (LPC 2025 feedback)
> > - The logic now strictly follows standard cgroup hierarchy principles.
> >
> > Previous: Children could select any tier using "+" regardless of the
> > parent's configuration. "+" tier is referenced. (could not be silently disappeared)
> >
> > Current: The explicit selection ("+") concept is removed. By
> > default, all tiers are selected. Users now use "-" to exclude specific
> > tiers. Excluded tier could disappeared silently.
> > A child cgroup is always a subset of its parent. Even if a child
> > re-enables a tier with "+" that was excluded by the parent, the effective
> > tier list is limited to the parent's allowed subset.
> 
> This comment seems a bit clunky to me. The "+" is removed, as noted
> above, but then why are we saying "even if a child re-enables a tier
> with "+"" here? Am I missing something?

To clarify, previously, the default state used all tiers. Using "+"              
switched to "an exclusive mode"  where only that specific tier was used.         
                                                                                 
I am changing this to a subtraction-based model. By default, all tiers           
are selected, and users use "-" to exclude specific ones.                        
(Then not "removed" but "changed" is more proper?)                               
                                                                                 
In this context, I intended "+" to be used to restore a tier that was            
previously excluded by "-".

> >
> > Example:
> > Global Tiers: SSD, HDD, NET
> > Parent: SSD, NET (HDD excluded)
> > Child: HDD, NET (SSD excluded)
> > -> Effective Child Tier: NET (Intersection of Parent and Child)
> 
> But otherwise, I assume you mean to restrict child's allowed swap
> tiers to be a subset of children and its ancestors? 

Exactly.

> That seems more
> straightforward to me than the last system :)

Yes, that's right :)

Thanks 
Youngjun Park.

