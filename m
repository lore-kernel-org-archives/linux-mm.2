Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45703E7E350
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 09:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8B146B0005; Fri,  3 Apr 2026 05:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61EC6B0089; Fri,  3 Apr 2026 05:09:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F006B008A; Fri,  3 Apr 2026 05:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 874386B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:09:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30E68598B7
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:09:51 +0000 (UTC)
X-FDA: 84616672182.12.132463C
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3E31D1A0009
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:09:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kGWuq7hw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775207389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sz9Wfwf4HE6//HLhFzHYY2ZdJLoQJfdOpKqVtfA7nik=;
	b=vBXCXNajYyqvBuTa/PTRl5180DcyVqT0NYYJWSVbfbesb8g1YmiECozDNBL01V6noTeRG0
	sZOlZY9hqQW0Z8qom5ZYjBI8kqT5xw97yzHiUep33WQkpSdeK1WJfLY9Du8xw1ZsTQSm7b
	I1Q+LkBq0dthig2SfemWDSo9uwt5KZI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775207389; a=rsa-sha256;
	cv=none;
	b=JMqeCr5hhsJHc6S/mEipMyA//P3xuD4iUXh7wfB3mDZoAyEtS2tGHinxq4m3nbj33wUg72
	3/4PxwXcsAjTtCg5cdXdA+hBK3MhP4V/EHf/bQ7hr0zVOVCw1FINICsNngiU48WT1493jT
	71Ny7gso8bQa7NMa/yGuGtrI28jOV2Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kGWuq7hw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2addb31945aso12743365ad.1
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 02:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775207388; x=1775812188; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sz9Wfwf4HE6//HLhFzHYY2ZdJLoQJfdOpKqVtfA7nik=;
        b=kGWuq7hw2LzFPVQ4lPwYXdsxRcnY8+sVAMZ3/BLyWdtPE7zdkrlqU1M1NBwaTOvAQr
         912FflQaeOAmgRcksRML737m2+Td3uOl/MWC86+pLleeqE++XqGv0pLi2JHg5qe2cBtK
         PDlRiWeptfEXPE+4QL3lOzwAINRusvQsUQ3PyXYRLQfmjud93jopqUaDaOt+IkJyYgL/
         WArVwW0s03B/XxcmqFliTuen9NfTdpTgJ4HuQHqZovmwRkrGq96kk/A7Fz4ssMqUkCJz
         14HYIoK6VT+n0W/qoDdwSMZUJtNxawqnpH0J5E5KXEc1Rp2lO5HEaxUXRZZs1bBGPFUh
         Dc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775207388; x=1775812188;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sz9Wfwf4HE6//HLhFzHYY2ZdJLoQJfdOpKqVtfA7nik=;
        b=ixH2yOpJ5e341kACkkexQfXt3Y6pDmcn9myj9FiophXan7oBGVatqyqHxMfkvXn7QW
         qxrOeK5n4xvmc2ntjPIS81+FSCuTWckhA3SPNSBPgBEDrsoaUtHZmhb7GCysTP4GamZ1
         wvw+O42gO+jX5qswY8sDWmwkaKG51mVO1dIXlglSIEnzOkm0FgDcoiWPIJKZ1j6To1g7
         nQ/HHPQAFIXj1cE8T7TajjoZs/Z6o269QhGkgBdToK+2cYQzGG6CMunUIfuZgEj4O9Hp
         DXcfH9/Vf7MCHABdCdN+lOpyIO2RMlKSRcLxcuogLH9xc7B6/H1Q4+d/6SgPRG8lnC/0
         CNwQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7q0CnssUVcrEInhEu/7lZQK0ADXccNA31RlO0OWK8yKx7e1dqngWudFLPCGIQBL60XsD0F4ywxg==@kvack.org
X-Gm-Message-State: AOJu0YyWPyMsB5NKJxQZhNKM8ppWCgGxwHHQs1GazDWzJW0YX0RipOc8
	/VRE0SQ796Mlmk1ngk6z32myPL1w4feM3IM7BCv3xcxQpc+JblCL2X5f
X-Gm-Gg: AeBDiesEdp14mQ+vQzmDCTDBkYCvGoH49Yg7ezHP7qBBKH+uGDTYKJMdkyTLLVQTJkt
	tWav914deLr4sNB3tkiByJXUmzs0ihlWBGH3nPBWwrXlln33dsRAN+PqzFXl3TOy7n4lYNy/MI7
	MOjJ+AzwK9/0bJo8Ow0idivq2gtlWVZzf4s+6D65gh52IghmgFDPVnlzBoeiHCmuaRTGwyVEBx1
	AbEIgMfoBT4rbFMgsa/PuXTZ82SlQsXYWJMdbeRaDs8suoydH6enGJlMFO8ihXMZ0P4l8iNoQXL
	b+ehsyT3mevtr36WdgQJhdloPze2+0HMBn6dNq0iBDQjtdjskeJheU4EAf9OoV94BCbM3a7RyV6
	8emffV6fCGAmXCxYzajIeJkmvjHtexhNecIM+rFf6TZph7QZSZs2uW2nu05q46YworZ7hDaNo5m
	IXxm4mNIf2nTpNY4kksDFamPd2OHSMUjAsb0p8MRY+eq14KVz6QlcrnbsUk8T1h/8AnnYPMhk9q
	Uyv1Jo=
X-Received: by 2002:a17:903:f8d:b0:2b2:42da:25cb with SMTP id d9443c01a7336-2b281888ac2mr27934165ad.19.1775207388021;
        Fri, 03 Apr 2026 02:09:48 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b274979525sm64174565ad.45.2026.04.03.02.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 02:09:47 -0700 (PDT)
Date: Fri, 3 Apr 2026 17:09:40 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v3 06/14] mm/mglru: use a smaller batch for reclaim
Message-ID: <ac9xnv1Opj6cVS2R@KASONG-MC4>
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
 <20260403-mglru-reclaim-v3-6-a285efd6ff91@tencent.com>
 <CAGsJ_4z2=Wrm0NAfpE_98rKqEgncBceVscqFRGDPeuR0eCxQCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4z2=Wrm0NAfpE_98rKqEgncBceVscqFRGDPeuR0eCxQCA@mail.gmail.com>
X-Rspamd-Queue-Id: 3E31D1A0009
X-Stat-Signature: 1nbwmp3cd7woizcfbtbdebzhr5uupbnk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775207389-143758
X-HE-Meta: U2FsdGVkX19PN5bUMjjAA3j30ENEYb9Eb89b1641ImswAwXW2gi2NMgck3oUz6jEbhjE0S8x5yKaAxrsQp/TulcJ5t7sf+rbvD/iavhMGpaUCPftAcApQhJGk+7rN7SaG50zcwIYutUld7IN+zzNv6sV0OvqVpwtpKJ4Y1iBXyLqSaNpOG0zRwSuBmf9rcw2bBwfHPOYx0K1hpJWz8aFTI7OeBzD8DFwa9SZgcKst+LjpJ1CVMpTkHX6gHvzeVy8LhIJ6JvYzPwig79ynO5RfhygnXjcm5B/5upII5tZaeTOsZmT0TUxOCAZtoom62MzPBwOEIBL46ERAeaZv9IDezYsP1iPbtkyDyNWr7zZK4s1+GGuCMwHYhrePUznacDfGYH6qc5+O4bem0DqrqkFp+H0g/sP3V5Qf5NMhwcoT6NDijgNxUzoteG8TkoBAG2Qy+OmendDjm+eWIzXLckF0XLK2uNYGF3zDich2S8jR83FFCHe/yQG7k+Bbj8o4OrhXZgeEA6KHz69zYZg0RCAvQDgPBB5QuS8sQTNaw0Rf3vPQ6SWe30RQ10+MWmxLdcrpTscyatnLrJv0tEBXjJfor1dax+3UIz0+ZFA12Wm4QLw0cFI2uKjQ1iL9OTsoXrmGWN4Fl7R7piO7/fXeWIubCSY/Gt3K18qHJlRf5srf7k0hqXG5c5iar3sUfxOmnJuQ9kqup/rANyup1SUjyQ1c3+tTK8g9kEmAVrbwgpMJaXObfOGwEu/OJw1Dq6ujWocGfXob37iRIBm4uiUwODaGP9NawqKRsNDlgSlywhhUlrwSvaUkVRn4mcAE/jDiKxnoHQZ0TJ2K+fiM33btzUAPjC6iX4aFICvdwwhOCH4a5sA9+OQj4N8fC5PFKj4ty320CVBc8xybDHtMt6Myf1FgOtDP+VgRiDcQox75geoVk/pqsDhEUABRZY8QTaLZpN90uVC8X8b8SgrfYIL3WR
 0G9Wt9x4
 IRFY8MXs8DkCXDcnz+sbaI5rJMZtLYGJOSaOxkP91fgSO+A8JoaxRJ4IRLcNo7a20brArQNe4PQQLUg7njLa4Ps90OKyRaPRn1S0GUOgeaNFBiVONXpUGbuw1cN9DvF+EqEd1n30I+R6NVg/v8Elrm+FFwx1fC439nON2cjcVhTSxekCj3Mu83nlzWk8CAQ5mfdN7T1M0HYD14E0cDXaYvd83Lo2C97mE0zloSK3JjWuPbkfmKhHYDwm0tQ1kBmsAE7VVWtoZuua5SsBky5oA7CmSrx7f2XwB9pruw1Ey2M8WdDkX/i7qPeZ+AD7eh42TCcd0zTAZoPcnjyrSl4pQEWx/gulVHzxxRZHl6OBkODzyRRCs9c40lThj+xwuZilSPbkT0i1IJcD2RK2ta/sh4UjWP0R0QOq+MpBDu1mWalcYsU5Vlt+SXBsS5ZNZjczKN+39U6QtrAUUZDRbjAmxU/5DRc1aV5pSR6i6jJghlAh2TXH2N8pXl/94TWy9EmyBM5DXnHtFCovPbygJdqpMEUYJx78zP3zk1Jp2PHOz8sn5z6efvFHHCmbHBX0o+Z8X5joA9oSzMkZbJYRxuQYD/+IymECQhNil379/MeRI1KJ01zyRD7j9TJtfPGmT5UNWWxoDicFTTmUeoqU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 03:50:37PM +0800, Barry Song wrote:
> On Fri, Apr 3, 2026 at 2:53 AM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > With a fixed number to reclaim calculated at the beginning, making each
> > following step smaller should reduce the lock contention and avoid
> > over-aggressive reclaim of folios, as it will abort earlier when the
> > number of folios to be reclaimed is reached.
> >
> > Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> > Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/vmscan.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 643f9fc10214..9c28afb0219c 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -5008,7 +5008,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> >                         break;
> >                 }
> >
> > -               nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
> > +               nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
> 
> I’m fine with the smaller batch size, but I wonder if
> MIN_LRU_BATCH is too small.

Thanks for the review, Barry!

It's quite reasonable value I think, for comparison classical LRU's
batch size is SWAP_CLUSTER_MAX (32), even smaller than
MIN_LRU_BATCH (64).

I ran many different benchmarks on this which can be found in
V2 / V1's cover letter (it getting too long so I didn't include these
results in V3 but I did retest). The new value looked good from large
server to small VMs.

It's also a much more reasonable value for batch throttling and dirty
writeback IMO.

> 
> Just curious if we are calling get_nr_to_scan() more frequently
> before we can abort the while (true) loop if reclamation
> is not making good progress.
> 
> Assume get_nr_to_scan() also has a cost. Not sure if a
> value between MIN_LRU_BATCH and MAX_LRU_BATCH
> would be better.

We are calling that less frequently actually, in a previous
commit it was moved out of the loop to act like a budget
control. That's also where using a smaller batch start
to makes more sense.

The overhead of other function calls also seems trivial.

I also wonder if we can unify or remove some
SWAP_CLUSTER_MAX usage, that value might be no longer
suitable in many places.

