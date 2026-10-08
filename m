Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D49DCA600C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 11:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7CA6B008A; Thu,  8 Oct 2026 07:43:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A89F6B008C; Thu,  8 Oct 2026 07:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C4B96B0095; Thu,  8 Oct 2026 07:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0868C6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:43:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 996B71C2760
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:43:23 +0000 (UTC)
X-FDA: 85299273486.12.EFF6064
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id CF96A40008
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:43:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JoUVwG23;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791459801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJrfDVVqWZ8igRI9yMO1ArGRgj71t9kYTvI1ZTKISv0=;
	b=row1ACnLYV/BnM2JhtidtwuBVqyAdtobB5vHqyO4LNJs9eV0D4U1ikee1kZV9L5rVH20dF
	CxH1Q8QqpLenewK7fCGLv6vh7S24HTkXwfWl/XWLjL0aGgdSLz4QBaupBoJtBiVqKCuPqi
	5Nr4xbViH6PSIlYc81CXXj6VZZCHAXI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JoUVwG23;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791459801;
	b=lLIdCdJWTzbe6g0PVMTUkir6KZ32HdOr3T02dbtLALIrBn8IXPOBnX+0UDJ8Yqe00RgGn4
	bAR7JYn8KmJ5ptBXSzBLMNCJB/uEl+BiJUobS3IScLrq4rYVHh+xG4IFdmCwiFr6BVYLpr
	eBqwXvytFknFcH9QPvlNdhFLwqGhO5A=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48afbd2c386so2279733f8f.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 04:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791459800; x=1792064600; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DJrfDVVqWZ8igRI9yMO1ArGRgj71t9kYTvI1ZTKISv0=;
        b=JoUVwG23D0Sd1W0AivFr60+ASgXdgGGmONkLuWXYmPpI0CGprIscUiJdpVzSmlngg/
         HNcc+nLqaatYcRtOQlPypqETglPq6B/vDR/IJlhp7QqMJzV0xQ7qnLlr9DRtcrx6CmYI
         zNsGUArMBHiFkYAuWmJh3OMXuQ8o3eI2bPE/HJ7yU67lwpzvDKhdOBzKetqr0tljfQLx
         qFdvtfevDM6f1urxqbw3KBt+e5dPmd/ms057JQ1Pnfq38XAeSM809lzFFW/T/ACDfFpm
         OyHZ4QQq7AQ/TRGFjQdMVjPZ20w+kUWcnWDT8CzHbHmERUdmmBQK9EveFJF8fCtFMItG
         xJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791459800; x=1792064600;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DJrfDVVqWZ8igRI9yMO1ArGRgj71t9kYTvI1ZTKISv0=;
        b=XKAjLUGy5/rk9L+T6xQ34j9yeijoMFh9Uw0QXEOqrVEvDSGYAW9Nj1y9g7u6ZGExjT
         q1pzhILAptDPNiHe6M7PrQ6chffHSmJ5MIfmTl2x4eP5m1Fep4aSso8YIay7/v93SEVV
         sie05dsWps9hLqIEjWgxjurczMkHeSSNL7t9O6uyDRmYi7TntggxNgDxb97LRH/3uVjS
         547kFOi+PHW8Q25CPBgdFS2kMCF4CUjQGS5SP+q7TZ4a0Sj0S4BqBB/iVhruNow66Xtb
         4mHX4nEMz972OtscshhjbGh4HjS6YjsqpxdlP0dJtFFUIyt8dRLp9NR+OfViw8EFxwmk
         KGeg==
X-Forwarded-Encrypted: i=1; AKwUvBxrIPR2BROaS3iKTsA+av7zAdJFQf/L9RAihF13YIdtgzPjxIKPpkstCnBKOLXFYroNAksiUN9BrA==@kvack.org
X-Gm-Message-State: AFuF++kYTfjyUH8D7i+33eupIAhHyrZXJgoYzAuW01qyPqAfd6wW/Urn
	se8QiOFFtNDRBcb2VEmzDllDUjBzxXoHa4LKB7pPdEFXQBTuK+3l9ky8
X-Gm-Gg: AYBFou3d4aOdvXgPlBt+Jz56sBeOSisqYp/2MaGOAc1tO8Eh+vGrhkQOrhUr6JCDK3z
	wCGlWO+n7hy2cr6TjLDoZAYBRZOM0byHOmhyVsNM808DRqDK8TqDwIljdmOw72vq5DCke1MYzfq
	fOZNXh0pnt5Qfamb2P3PjeIMbcS5W3BbsXX1u3STFdi+eOhw4kMdw/vmzTDnzD+FIEbwX6n2DoF
	VSzPThQZXb1YS0SZpSo51NEhYA0wAfZzD0N8edSfHD14rIJE1gdfzYJ2QLUmjqd+dR/arbaQqqj
	hDj2Tq9J0epUWgCNzK8P3LCO1TktKD2Z2QD2U50IL2y2qPtCmptqdYH2A+G1hN/ryA9mwk7/bAk
	3JUu7jIqH9FYvKeZcE8PCtLbYDqFTKlFbe9UsmuvYSZeLUQCFufN1eflqfH5cvYPqY8Lawc2EJL
	5yzWOSsANIOIAvUF+44Lqa4hyDeRxj7u/BsOK6E7hDfgV0Hu3350DU5L0/HedkS/C+9EMGum16R
	3SAGmckoFxs/RdCxQWvwOc0Rf1zwZM+SA==
X-Received: by 2002:a05:600d:8654:10b0:4a0:2391:6533 with SMTP id 5b1f17b1804b1-4a1815a2080mr59349355e9.21.1791459799957;
        Thu, 08 Oct 2026 04:43:19 -0700 (PDT)
Received: from KASONG-MC4 ([90.160.207.74])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71d2eeb6sm11131954f8f.43.2026.10.08.04.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 04:43:19 -0700 (PDT)
Date: Thu, 8 Oct 2026 13:43:00 +0200
From: Kairui Song <ryncsn@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu.xie@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	chenridong@xiaomi.com, Yu Zhao <yuzhao@google.com>, Bo Zhang <zhangbo56@xiaomi.com>
Subject: Re: [RFC PATCH] mm/mglru: Avoid reclaiming kept folios during
 retrying missed rotated folios
Message-ID: <asd-8uoATmpH9YN9@KASONG-MC4>
References: <20261003054216.9155-1-baohua@kernel.org>
 <088f991f-429f-49e0-be11-548a77e8d44e@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <088f991f-429f-49e0-be11-548a77e8d44e@linux.alibaba.com>
X-Rspamd-Queue-Id: CF96A40008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: atw3s1c3f8q1uwikci1db4tpgdktwpcr
X-HE-Tag: 1791459801-976656
X-HE-Meta: U2FsdGVkX19C1Ek2nvpvww9tP2/RcjlFACS6ouQmQrFQAdTMOoxcGR+7VkhbrWvkY6hTfbaVXe2VUzb3nPhbWvhp9xklFsZXxsAe9V7v71ZEa/YqzDbqub6bB6D7PpD8/l+3jNMhUnFoU9PVfRMOiVrklWyTe+oteMDcf7K1wdaO7kb5A+msD5XjjmRD+Wl4N9ahINnB60myslICYXCeRmw9w9vz8HTvt6eT0Qhh1Q1HI+a39drxK3UbF2l/5C/URp/0gKlQvcBhCeH1vwANIdmSOImP1rpOIfyI4EwJBpJ6xsrWK2OQtoJLgaJlzO2MZ61idElro5T7RoRe3/eDaORvPQwCBd2dPkVtiueOnJ4LU0ISzQtXZt0VRTakqPOVeqDfQdd+nnOwm2vyjrSgZq0ys5l9KbP1Qf5wF+WaDh3EDvezU6bcDkn3Uaiq526h8pNzU2Fu/nwnv26ZIidrBHOyG36OHh1YFLQ+cfXZ9WbPTRqAF0dLItAph/wTq/BGPSBVYSF58tCbESpyUsEXr4gTf0GjUVA4pjxvzze5NelJ75plihdcPwpdEiIGH2PAcVpLKItMDzmLMDfxzbBdCZ/uphTad4QKuKiGVvOLTIZ4FUDGpF54C7kf9HHb9LqPALNUGZBShnzgEw5OTfDCR02Uwpp/+DbXEWlHkZg1IzWxTukmiUoLzQ8yQ17ageFpx0yGU3ZfPG39eaZOd5LzPnDgPn/bExeofeO3wLqo/UEEG5SmEAPirv99xa/h6ghesZToGzzxw0zAiLAdyruOJjhXSAwd7dnhfl2YbZbcOVWIc2plwc9VOrQcK3knVD68S1p/sGW4xrDDhprmeTF1jn3fGvQEs0W55haBmSOoDTKshzMklhchUi0sF2ZpXHYrpuYDTBJB8J5xtwqESTE9sY4GT81y/hVfqYx/tIW2IbfR3kHYfljea8tU/fAIQSe5XZf3bXIxlmUNWJluy4A
 lSO7+wuA
 +UzMBiMBfKLo/yWKDB7TbnyMc4jCBdDBG8gaQ5TC6aIn1rihQvAJrJXhbBixDqSqjpiV9INv0Mx7N0+/ACuk7mcZKGcf9ALyKaKs1ZyEPwCzcrYQJ0nOCE3xO3H8lt/vKfwQeuSkxOoJFkqxs3UzKbN30a3AnzsGtPMjNve3xWVcmGEdQHJ7jmFJ4dFSw+lwg1CAM4ZF8M6AMeA//RZ4sCvEEBH2zj1ykeHi+PcsG74iby0bpT5ehEP7Ui0HrtfQ7/xZ0Y15wN/iOAcfxWUOESAvbdHUajyftoP4vUKeevU6iK0ntQaxC+ed+mDUAVIlgrKPpvsTqKHvIlo8+ncgvwUPAt5m6qBpkAlBpUMLTlQzjFAcrVfPZE4gThuGgZGMjfa0TSjn9VgQVJ+GQRn22hXsf9TBJOgij2wZ8m/hRCw25ErCxsX4vbOL/g9Y2f1/qpWI80us3XYfHMmHIzNCCK2/ypAruWOwYAf/1ggRR1WZ5i7LehwXvCimDMo5hQmRGyk9X9n5wsYvuh2X/UeTC+g+gaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 08, 2026 at 02:52:35PM +0100, Baolin Wang wrote:
> Hi Barry,
> 
> On 10/3/26 1:42 PM, Barry Song (Xiaomi) wrote:
> > Since commit 4d5d14a01e2c ("mm/mglru: rework workingset protection"),
> > `folio_test_referenced()` was accidentally removed when checking for
> > missed rotated folios. As a result, kept folios without an active set
> > could be added to the retry list and eventually reclaimed.
> > 
> > The impact should be very small, as we have the `folio_mapped(folio)`
> > check before retrying. Kept folios won't have `try_to_unmap()` called,
> > so this is really only applicable to folios that are unmapped by users
> > after `folio_referenced()` has been called.
> > 
> > I'm not sure if anyone else has seen any issues with this. Sending an
> > RFC to check whether it is worth fixing.
> > 
> > Fixes: 4d5d14a01e2c ("mm/mglru: rework workingset protection")
> > Cc: Yu Zhao <yuzhao@google.com>
> > Reported-by: Bo Zhang <zhangbo56@xiaomi.com>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >   mm/vmscan.c | 7 +++++--
> >   1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 91295070ca33..6a931b576b7d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -994,8 +994,10 @@ static enum folio_references folio_check_references(struct folio *folio,
> >   		return FOLIOREF_KEEP;
> >   	if (lru_gen_enabled() && !lru_gen_switching()) {
> > -		if (!referenced_ptes)
> > +		if (!referenced_ptes) {
> > +			folio_clear_referenced(folio);
> >   			return FOLIOREF_RECLAIM;
> > +		}
> 
> I've also been investigating the issue of referenced folios being reclaimed
> recently. The background is that classical LRU will return FOLIOREF_KEEP for
> folios accessed once via page table, giving the accessed folio another
> chance.

Hi, thanks for looking into this.

> 
> However, for MGLRU, if the folio's pagetable access has already been
> consumed by aging or lru_gen_look_around(), referenced_ptes may be 0 at that
> point, leading to reclaiming folios that were accessed via page table, which
> could cause more refaults (I don't have data yet).

If we go with MGLRU-FG, aging or lru_gen_look_around may move the folio
to newer gen which is identical to the behavior of promoting at eviction
time.

> But it's not easy to maintain logic consistent with classical LRU, because
> we cannot distinguish whether this one access count comes from page table or
> file descriptors (for anonymous pages, it can be distinguished). I'm not
> sure if Kairui's MGLRU-FG patchset helps with this case (I haven't looked at
> it carefully yet).

It definatly helps, check this one:
https://lore.kernel.org/linux-mm/20261003-mglru-fg-v3-4-cbd4546a5bd9@tencent.com/

folio_inc_lru_refs and variants will promote the folios in a consistent way.
See "First access only defers eviction from the oldest gen" part, I believe
that is the issue you worries about?

BTW promote then to newest gen directly does over protect them, I've see
regression with that.

> 
> Perhaps at least for anonymous pages, if the referenced flag is set, we
> should return FOLIOREF_KEEP to give it another scan chance.

No I think we really shouldn't do that, it will over protect single used
folios. Promoting them to second newest gen or second oldest gen seems
a good idea and similiar to CLRU, and this is the behavior of MGLRU-FG.

