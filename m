Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D084CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45638E01D5; Thu, 30 Oct 2025 10:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF5BA8E007D; Thu, 30 Oct 2025 10:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A908E01D5; Thu, 30 Oct 2025 10:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C02278E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:39:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50A9DC01AC
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:39:58 +0000 (UTC)
X-FDA: 84055040076.16.188FD33
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2F4D7180002
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:39:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761835196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tm2pzG46bgFpprAAwyY0eLFPUJp5ZCgFV3BeazrZuLI=;
	b=EqRKzlo3QaNSF/nUttW1L7sZi++sItKEWMNXBFv5vRS/el7joHM5PfcyDl1Apq5DMCEWKK
	t8+3z3UlHAC6f+WPyShMKvER1ZtzFP9xDAJiKEWB+oo3fZNlvdB4Hwe0TcHqCO8780wdni
	DAXVdik4RBBMQuxs8v8H2zBGdsqPp60=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761835196; a=rsa-sha256;
	cv=none;
	b=swwcPhKxzqdb+blzATc8JaYQVSCT6GKCod9cp4sHYEglX16UET2YVF+b53EnK7An4fR9Ua
	F+NoZ2lPqPfw3aOJzaVGQL2qSpdbopJ0al9OpH43q1r1TQjnFqCps5X8wJMirhbnm3Bw+7
	QR8Zw/zCz3dpJiPJYpdYHF6qxae2z60=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 30 Oct 2025 23:39:49 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 30 Oct 2025 23:39:49 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
	gunho.lee@lge.com
Subject: Re: [PATCH 4/5] mm: swap: change swap_alloc_slow() to void
Message-ID: <aQN4taRJX+Yms89U@yjaykim-PowerEdge-T330>
References: <20251029085659.2005942-1-youngjun.park@lge.com>
 <20251029085659.2005942-5-youngjun.park@lge.com>
 <xgj3sxgxcwi6lflt6oy63ifq3b3bcle7l2543oa7aotw3qpm2y@cfqwh54n3737>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xgj3sxgxcwi6lflt6oy63ifq3b3bcle7l2543oa7aotw3qpm2y@cfqwh54n3737>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F4D7180002
X-Rspamd-Server: rspam02
X-Stat-Signature: j5mgdmwwno8u8ec1dqtcsjfzexadm6kz
X-HE-Tag: 1761835194-193665
X-HE-Meta: U2FsdGVkX18/E6tL79//OHOrDwyoP/vaoPjRANLbu6bi2oO8DsUqo63XACpAhBr7RqPayVGs4IFJtrbecngA0GRY9OeO0B4L6b6CK9sfkunBKP2u2wPlabIjztCDVKzuKmDjgrrr9DGRRHRuQX1Wz5IiiPcVZ8oyQ+xwkfAD8ulFD2oQVzcqqD4gFzZ2TCfNm7FbtM8IhYV1IRRTYy6RoAwAzl9yUcPT9q3R0xuxKPHCUfy3ag7G5EWyCHxChVxP4shU8ZUfHkiNQ2rNlTR9sNoT6cGFHZsv3VG0EDbadMvBdXeXiSzX5z5FszIjklJF4K/V9pOHi0npuhsvV58LPWvyPseLD/UzrA+tvYmAjSnd8Eo2O52rkiQP6Nb38BoXL5Xxta9HcMFvxSEYW8/2oO+zrlltgwKOFJJihSa/HqCO/daWTeS8vc+NNKTuZZdAmiUp4ts91rbETIruVUDCHAHUolioZ8OXAAFPJLzypmTyeYQX/HmQH0ZxQO27iXQYxDxGMm055iWIFSq/3t/I7lDgzmSbVGlrkcsYW999v/oWCqsA0tnledizSrFeaWX2Si3rr2xsbuk7BkotIdbEMlyxO2nSaXq73CG69VQsMgRt1+hVv6PzbrkY0Eb9zduDFeEZHeLzCzYS+MgMuLl82hiNyiZbBBdW4VhipXJR1nPYvIw9eVqVxUdgGulXYAzFmQFoBoWyRlLCs0cpJJGWZ8lg5aHYQH2V18IP8YWkZhBoEaOdmpI5rtFjrFTos4l6tJPxf937u2jXV8LJlNSbCYqUaz6L0lM1EzhRtWllXY3OPI2g33mSOD74HpyDA6GPsmFb/t6D1oMR9f49B4FnynX8koUVjAATIEyv+TnKExIwXTN4GCI/ECUEiaaF/LnctYX6IvAHOGE6/HQztpYlFWr5Ae1a8gp5z/X8hLvmGE7stAb9vXwm/kKeZrrPIQ9CW3+/jxoHpXHPML5N6qw
 Y1WC2uzq
 xFeBaGPXcqySi5vmXYurqpO3xSvm2VSpXnPAaUm1tf9oFvW53Vt6ThmOsWrW3bH4SeJDHOk8KA9j6nNj2tEk9ifUs4ziQKKIxNVDrsNol6IIQtsCn5Z7Yj2lGxOsQtnzpxnl52P283yJsahEU1z/IG0wPbqEcnkZZoVxRoCd5G2iXC2vyyqPCeYUptua9LTEpCFLwLuKV8d6YGIuEnRKY68DAUzU/1S8jQ6wFmL3+62dVZO1nGk47CnL9Eb6mNzg5I7ErcUI0ywq0HPtwKFnCe5f+MEFI4pMHqIU+p950ihGMRNxQPZA2PGdMdlLfu7+Qjn0hbv37ZPchXlE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 12:13:20AM +0800, Kairui Song wrote:
> On Wed, Oct 29, 2025 at 05:56:58PM +0800, Youngjun Park wrote:
> > swap_alloc_slow() does not need to return a bool, as all callers
> > handle allocation results via the entry parameter. Update the
> > function signature and remove return statements accordingly.
> > 
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  mm/swapfile.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index b5d42918c01b..89eb57eee7f7 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1339,7 +1339,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
> >  }
> >  
> >  /* Rotate the device and switch to a new cluster */
> > -static bool swap_alloc_slow(swp_entry_t *entry,
> > +static void swap_alloc_slow(swp_entry_t *entry,
> >  			    int order)
> >  {
> >  	unsigned long offset;
> > @@ -1356,10 +1356,10 @@ static bool swap_alloc_slow(swp_entry_t *entry,
> >  			put_swap_device(si);
> >  			if (offset) {
> >  				*entry = swp_entry(si->type, offset);
> > -				return true;
> > +				return;
> >  			}
> >  			if (order)
> > -				return false;
> > +				return;
> >  		}
> >  
> >  		spin_lock(&swap_avail_lock);
> > @@ -1378,7 +1378,6 @@ static bool swap_alloc_slow(swp_entry_t *entry,
> >  			goto start_over;
> >  	}
> >  	spin_unlock(&swap_avail_lock);
> > -	return false;
> >  }
> >  
> 
> Hi Youngjun,
> 
> Thanks for the patch.
> 
> I just found a patch from mine series is doing the same thing:
> https://lore.kernel.org/linux-mm/20251029-swap-table-p2-v1-15-3d43f3b6ec32@tencent.com/
> 
> I'm fine merging your cleanup first, the conflict is really trivial and easy to resolve.
> 
> So:
> 
> Reviewed-by: Kairui Song <kasong@tencent.com>
> 
 
Hello Kairui,

Ah, I see you're working on the same area! Thanks for the review and
for being flexible about the merge order. Much appreciated!

Best,
Youngjun Park

