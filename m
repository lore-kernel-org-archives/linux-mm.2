Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C4C8C5AD5A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 02:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD81E6B0368; Wed, 12 Aug 2026 22:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A895A6B0369; Wed, 12 Aug 2026 22:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977BE6B036A; Wed, 12 Aug 2026 22:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64BDE6B0368
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:26:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE0231C1627
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:26:13 +0000 (UTC)
X-FDA: 85094656626.08.2626E42
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1F62F180009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:26:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dv2OTnY6;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786587972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJyuBNA61ADLE8D7qWrS7xw4VQ7YCE+rGhhYCzYs91I=;
	b=HmIqlyfUGul3vL3Oi1kuCVp1QCTGkcimtF8fQBod7B6pxfDbaLS45YGyZG60yxZKsBGvI5
	WE122VO+RaOvQNnhiak6ABfc2fB5T1vZSjGWgjlkxx2qehObGoUNwzrwsgQyKTk9x1fW9F
	WwWWW46Rcw/8Xkme1YrUAk3pEM6q3yc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dv2OTnY6;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786587972;
	b=yNmge25RW34weJpF6pVgdVaO3Tckoy3zkeJErt2didup2SOKhT2n/gq2aGRuPi3DXSQWZA
	ZqqPJUEDGJu0oRVJiHP4OCuHpebJf9iVAkI7liX1un+TQ57N4fxOHNsafT0AGk/CrxA8Qp
	Ce1bn2iqiMEH9QUPVl2SJPBJ4kTcRrU=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e7632b193so115171485a.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786587971; x=1787192771; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rJyuBNA61ADLE8D7qWrS7xw4VQ7YCE+rGhhYCzYs91I=;
        b=dv2OTnY65lh6MFBs/enjVEGr+O2V1GNrfVqLnDqKQcpvHcUziQpbeTo6CLAPcijDFr
         MD19ah9EyU+AprxSgV44gCRCPzz9F/hU/bd0yaf9VVOEni+CDYCQDrTKkqo9yJ4bDPM8
         o+6VjaRaO76I+FPWx7JKiEuPlzRYQ3qWviqhAXiVQ0QkXFf7Wz2emxNLQP4lyaB0x3+L
         IQJEhgB8k7NxIDUAZk2q7hJc/l16r0hioh2QNFucK06d8ae9FMoaegzU903GI1BAm4QO
         bLfv6KP5WLZ0BBL8yXw1Z21tmsGG2wlsU7P3gzTJTyOELV/uinB1TNFJzhzslmybPqzD
         IHNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786587971; x=1787192771;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rJyuBNA61ADLE8D7qWrS7xw4VQ7YCE+rGhhYCzYs91I=;
        b=BX6ECfmR7GJtLE4l5Wt1R+T49u4efRFFeao8nwUzTH3PINe0HaS2cacAWWys2RIo6/
         zMnyG0IgPPJN4IjqlZq/u/Zf+V16RIZBsReqTmgHxISZYcOAI5a+Hg/9yrjs1tQAoeP+
         53e7hFESyEMfSgiOOlEOUPQ2Wklg09KeP4biacqlT0lFL6qrFuEnVmY/eh12yWsmdb8W
         n4ONjSUzQz2RVba4++oq/UGA697aqIQ3MnAMkVRzuVzoPBNvmkk15yt1zalbRbn7HJac
         QIg87Uei/o1vlhCKyqrBMID+t/g2ZtcAzzZa6F1pCRwMRDoZx2j+l+4Jm3qsziHyOWir
         isEw==
X-Forwarded-Encrypted: i=1; AHgh+Rqmq9vezJ9nIO+LvoWHboJzPbOftwx3+95TwLlSkdfI9t91/NOrnltON1OezjOKmtuG3d7ivsXh0w==@kvack.org
X-Gm-Message-State: AOJu0YxuoBlGWEA19FZUohMxLTI6bK5GzUj3S4NrfnBUElsxMIt4hoyZ
	dAYH9WkKLxb9xt9GJ4NkYMcTWPBPtx9FrZOQLxhBwp+ozsSExWJieToXtYVf7/6kiXI=
X-Gm-Gg: AR+sD13djHlIpN0SPGTYFB+Hw42YepZ93xLXSXRbu0v+XR/VlD9/NTxEy9rBmu2YRFu
	Q/aS1iIpJKRd40XcHHTttVzSwdtfP2kESoyc4vavckKheGgwtueDI//H+VtgdsHSXMHmkFBGWh3
	iSc2oZtD+5UUqvUDZFY91jxhiVNUT6kmUDVzTfSgk43n9SMwblVD7B+srUOkUu3xHKNd4B71Roa
	9gw5+C7NBita66qbCxJWpBGOWbWHStI5+jaBy70DO9+5gMjnq43LLkPL8N9axmuWaLciRugA9YV
	XVMBN3pIjRy0FHkRIX55zZkXtJD4qNayleauFHnE5GvF0N9kwdV8K33tNt14aCgkP82qN20lgbW
	Yes2QUwy1iI/GXZCZGfD+NyU2oKpVU2gN7wi4xpcKsTA+Ao+XScgl4Cf5xcIHW8lS2FaEk3ppAP
	QnM3L1BkZ78V6+DnalLckCh1gVpg0gnYsPZBEZRMjxKW7S7A==
X-Received: by 2002:ac8:5892:0:b0:528:f72:a986 with SMTP id d75a77b69052e-52d73e973efmr27058371cf.44.1786587971243;
        Wed, 12 Aug 2026 19:26:11 -0700 (PDT)
Received: from fedora ([2601:19e:8500:d3c0::28fe])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d7400299esm7355661cf.26.2026.08.12.19.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 19:26:10 -0700 (PDT)
Date: Wed, 12 Aug 2026 22:26:08 -0400
From: Gregory Price <gourry@gourry.net>
To: SJ Park <sj@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org,
	damon@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, akpm@linux-foundation.org, david@kernel.org,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
	vbabka@kernel.org, jannh@google.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com
Subject: Re: [PATCH 1/4] mm/damon: defensively skip zone device folios in
 damon_get_folio()
Message-ID: <an0rQM7ZwWnB0nVD@fedora>
References: <anS-vK1MaC8sWoMK@fedora>
 <20260807000938.79851-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807000938.79851-1-sj@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1F62F180009
X-Stat-Signature: uu1wknayk71bdfm6we1h7p1wgu5brqk7
X-Rspam-User: 
X-HE-Tag: 1786587971-936298
X-HE-Meta: U2FsdGVkX1+TZpIHV4lQuI4lZ0WkwM1r4nrYmkkcfhIgzoDFP3Cgfa7Md1eBmgSkv8apPttE/fvPzvs5E3d0J/yE3T9A4fq3KFs0ahg6qZEOeMMVyozO+Yk7wzwVwTQsfdI21j+FaZCCilda2+8AfyRP8zkur/joES5MsR6OkpN2zNDOBMJiW/AHqPurgffiQ5IQOVtYuc0/XVwLkMtrPB5FW4MihEK7Xwa3PrRKa0fuWXObIYZ6De3MkdwNlrGyfJM6p+93tI446DUdfCLn9hisdLR53cw6R60SCkv2h24sGH+xenWRV51pXfRdruKlWUgwutF0weAwGBtoU56IwOPa0/XgH458Hh9kTdwAEW0mCO00woat+KWC13SfYuLG3lkTPwSlZtLUXz0wCF3YKm7mGzU3HKd1TD1aQ10VJu9TYEv6oFuT4p3AjvqWss80MzRXIh26+m5l8gMG5/IzWLGj/MsaDw5an1u0pGg+mvslgxhz+PbxidZ0ejzZr/DIMn66Eu7F066JzU3kDX55aoOOsrqmzL5zyUGnvheiP1kPZYPe0EpD5822LrYLqBfk3yXurm1/T4J3d1mLwcQvaoYGUSuNhL9FZcOX+y+qx5IVEJNL+pth769rhMPiQ9Idxqp9Yj6HOtXMH4NYSvtIj1PXbC5gCA+ZtI+FgCk7pBMZdpyToE25tdDfxgzIut0iJNMKBIz4kemu10nMVk99C+D/Q9D06Vb/9ZoTmwAfAkG2Gz6Jc95HfN4WpRX32sElUQVjsJKIrFTW9HpSqFeqrHzcLozh261jKbusABlYTewKpp0S+4L5RRN4yD41Ln+jYwxZLJsqfGgJTAX6NcmI5Myn2m9BzXloG4bFrpOIH8BOLVATw/H5RMUEGZNWMHklofDfFxnUasUQHmM/cqjmPkqnD0t5bsF2Vqk5/WCrH3wIeEE0ci48Z8Xra452V7hKcLBLfr++9qsM3r/PfdE
 ijAXviTp
 /DEztv+BQmU2DHP9ugTDj0ISg2yONu4QhnDjF23dRtZByJAdglEXYADQpHUNwb7LhA3vpIvrnazk12df74uBbdCE9fN386CucEMCdMGyMQP1u6o1VJyXHAPor4N1dj+2ZDRJps5Fn3cO4kB/kUV1BjJKB5De09Q+hg0O6Q84YSIY+KHhrsVT2fvUgfkhFGdQJTYdvfrPVm+W3y31e2na9cKMV/fFMhcLSVrnJWHlQ3PS0/JuCo1R14O4OU2AMAwqUpQpF60l8y5JnAQlAzWAwVzIhh9/tQp4ZRXB9PXj1d3yywsIh94Y6QYVy6aSnsIOr6WiA0Ue0L/GZZ3LsiCfCR156tGxs0/uBzX4U8X+nTEVz0muDtSNqLTXj5Ra7LnYcvPvA03q9gl4RaXAA6IA2etegI7s2ehQobkMhhltyGJwVOND2cESfZwOBokeuJOv65MbsgijA0gCB1c/vZhyxasliuTo69dMVbwYd5AnepZBn8QZa22fkSBLo7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 05:09:37PM -0700, SJ Park wrote:
> On Thu, 6 Aug 2026 12:05:00 -0500 Gregory Price <gourry@gourry.net> wrote:
> 
> > On Thu, Aug 06, 2026 at 02:37:59PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Tue, Jul 28, 2026 at 03:47:11PM -0400, Gregory Price wrote:
> > > > All DAMON physical- and virtual-address operations obtain their folios
> > > > through damon_get_folio(). That helper already excludes ZONE_DEVICE
> > > > memory implicitly via pfn_to_online_page() and folio_test_lru(), but
> > > > this is inconsistent with other callers in mm/ which test explicitly.
> > > >
> > > > Add an explicit folio_is_zone_device() rejection in damon_get_folio()
> > > > so the guarantee lives in one place and covers every caller uniformly,
> > > > consistent with other mm walkers that reject zone device folios.
> > > >
> > > > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > > 
> > > Thanks, nice to make it explicit!
> > > 
> > > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > >
> > 
> > SJ Asked me to drop it,
> 
> I didn't asked you to drop this.  I asked your thought about revisioning this
> for my concern.  And you replied [1] you can drop this.
>

Sorry I didn't mean to imply you pushed for one side or another, just
that the feedback you gave about not wanting dead code is reason enough
to drop it.

I will probably just go ahead and drop it unless Lorenzo thinks the
patch is worth keeping.  In my next private node iteration, it ends up
back in anyway - so we get a two for one without the intermediate patch.

~Gregory

