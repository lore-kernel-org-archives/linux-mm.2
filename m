Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D250CAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B978E000A; Tue, 16 Sep 2025 14:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12D48E0001; Tue, 16 Sep 2025 14:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928E28E000A; Tue, 16 Sep 2025 14:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 820C88E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:08:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A7B2119593
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:08:23 +0000 (UTC)
X-FDA: 83895898086.18.BB49969
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 35813C0006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:08:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cYepO1lc;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758046101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9wPiuMA/lNn5RD0leBMSssZIAOEsu9p7VC5bMNaBr4=;
	b=yITlcmGXPLtREkvFmvw2SFPF4PzyyGLWaBX3U68ktE0JuExVDZJXME9yxEH9hmmehvb8OD
	RbUybBY+EXLbsQF97K3oubhWVJPtJG1pl7oBG4naoe0WCWMor/WvVwapM8ptHRW0nPlDVR
	gYdqLO9mvEMO0xek38o52dqXfzxrLD4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cYepO1lc;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758046101; a=rsa-sha256;
	cv=none;
	b=EDj/0ouVVurv9kRGbr+2XoJDEgd3S1FJhsAfg/XMbFxW63VkKnOr8ewlWKo8dE15co9DgJ
	9+goNumVHT7K201oViXXxxCJo5KtP0BhW709iKPgU2dnjy+rnifuXhPKGEs13x4wGB300/
	SIAlI6RGhT/SJ6pYRcp6m4ERRssZ4jE=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-62ee43b5e5bso7897377a12.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758046099; x=1758650899; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C9wPiuMA/lNn5RD0leBMSssZIAOEsu9p7VC5bMNaBr4=;
        b=cYepO1lcDsEvFhSLsPOMM3nrhei3nhlO3Lj4nnEgdCw59Zkk+5ci8hG9+7H/BNbSMB
         aFFkZs8YP0iNjNWs15yw3EgyMk2F+4YzOJB0lBpqFcX0ZsMr5sluoti+FsmMwTX3n0b2
         2HFoIoKwq91tkI2IB5IgnsJB+lNAdfEsd0349ZCVTadFpP7QCZrZ0FvJbd0KIQX/v4zB
         fhwHTmLTrRKlPez/JZoltThjWGNduriYbKJhOj4lLzLqqphnELtHP3ju9jxnseAWFXj1
         idPK4IaZOYkt4GHJXtSLuGYHjR/5KWtCNDiZX/FMIIezTelwHHdjTy6wt33NTEECI9Wa
         FSmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758046099; x=1758650899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9wPiuMA/lNn5RD0leBMSssZIAOEsu9p7VC5bMNaBr4=;
        b=J0mv2YhhwtzfPQSJIVUoqnyrX3Vu8/k3Wb+FZSLQ/5wqUiGpnj0s5Bb63P0xe6E5H+
         +FiUTp6znGpFSkz5yOLcMNyzvZvQOWYTPA6jQ5v5v8mqfI0c74W8gKyNGNsI+X2TZFCo
         AX1yNeVKPp6Q6FcpWJ4FnMSU4YEw0rMU1fCTgyaeflVmQlumCsTOSXiXqwhGZdfrb82n
         5GxPHfNdtkbi0czcpNobafyBS3gNi0xr8doPMaAo1T3guN63CvHLE04e+czhF8hJoDAr
         o7lH9IoR6d5sHPRAlddV75A8zkfrACfpSWArrgP3/eB7Gi4Qt2xZnTLN+PXyGtX81e9V
         xy3A==
X-Gm-Message-State: AOJu0Yxticgsi4IzmMzNZX4pb6bTSVEukc9iAQ8kC5bsdQMJMcNZJX7j
	32gKIP1GEK5m05j8z2aXBV1Mbo/r3lmvGbqeEPgxUP33LKAQa1hNbyXWK0hdlXuxqV0=
X-Gm-Gg: ASbGncvKhzjJPhmLPY2Gb9k+kfGcVykKe1q7euLcpDLTulJloI81HKeDHoggrOa+TSq
	SE76GF+AhWcFstdvgSLgb+8Dr3xApVkGaKcG1tIGaY3c1dOEBZIJ1ET8SElI4ykI7NdqfxMYFtr
	Trx5dZAJY8ZWUeSRvfoNTq8Ry7JnuOLZ3rU4ExwPnYpCBimrncDHdE8+Xna+LhjubYWTGwkNiCc
	j8MMCJfvb4XTDgcMKigRpy6H2auE6HoZ/V5WaVZbArQZFFVrfPYQbbTJQ/G4tIPmysMHOty6Etl
	1EeEat076cT1Ot7n/3kfhLp7FQrdBS457P4Aj2lmSfVYMuqZ1B6WvtF963/L/oIsce++MSjaFSq
	ki951KTxPIABFa1mrhNCYPBaCQC5Gyj9Xcw==
X-Google-Smtp-Source: AGHT+IEmjqMbM7yAVIrWQBEMCgOpxwhHuI9jQbonVbCl/9GRXITN0RxctJFLvP6OJyCRvVP2xIq8PA==
X-Received: by 2002:a05:6402:1ec1:b0:62a:82e8:e1f6 with SMTP id 4fb4d7f45d1cf-62ed841e656mr16870681a12.36.1758046099490;
        Tue, 16 Sep 2025 11:08:19 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-62f11390075sm7251508a12.40.2025.09.16.11.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 11:08:19 -0700 (PDT)
Date: Tue, 16 Sep 2025 20:08:18 +0200
From: Michal Hocko <mhocko@suse.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 04/10] mm/vmalloc: Avoid cond_resched() when blocking
 is not permitted
Message-ID: <aMmnkm_E7hDO_yN0@tiehlicka>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-5-urezki@gmail.com>
 <aMhIv3HfRMyjlSec@tiehlicka>
 <aMmCJOJFMTuCXH3m@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMmCJOJFMTuCXH3m@milan>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 35813C0006
X-Stat-Signature: 1w3zqmypei9em1nzt1ochnru3zhzzzk6
X-HE-Tag: 1758046100-730603
X-HE-Meta: U2FsdGVkX19tkj8uTvtN/jX2a9tPGo0C7okOMy15R+y+zZOVevQRIQAXp9VPWq4lbnbzgA6R8QOSraiK9BuraEgalPxk7qGuHO0d8gJhkNXoiNtvGiBlWHYmr921GzSbsAlDoJUNeY4uz0a9sF26J3GxU53pnCqPZO/Wx9+Wx+MKULPN8nBeT/ppRYf1EZ8u1cwuJLnKZC6y4COmfcddC6Do4MJxMN+X6Okrs1YK5p8foyhxRyFoURyw5zvH6lPVHevLpQU0KLWAYB6S9INPIioonuu5a0bubCD+wglbTRH0Aj/3TrsI9umUONEfkf88GPSvRuFR1XVwDHbVgkPQQqukPrkCm3MENgVlxbdO5Uq6AELFcwbizTIUcj6HFATh/pG6R2wmLYoKgsFIG/xSyNs8Avq6ABQRYNybcmdlmunrHp2rfHuffdV4c12yIsFUm05Y0KjvcNTJGfXPR7km+W965ZEs1vI5ZNvaLN+qqh82jd/gfWVEr25ueEM7eDRnWp2Nn/mWJXBk5jKH9YkSfUsRKlEWgbIPFtooPentATAx+0a2BMSqI79lYlZxPEjwOEtckTsOnY7Ld1lML5Ctb/H5FihXxtZQHaQQwA7J1LLYy0aUMrltuN9L9QQgFlPQtncN4LmlGP+6gZ4H3YcZsGEoV42/AMRTHl1hipf0wvEPKl1/xL9YYZCMHQEOLb48E8geNe/nISN2TRykN730LZmAB1fmh5ob1nS1jd7K7ydEKJc3i2KNEq4oL/f2jCuZjriwnlEsOfYsAVvVzadBfPWJ6M34q090BOND0Bs2mOfp6t9GU+TNt7hFPio54vBmxtyHb+7Ia1NIiJum1wjUmBs/CLMRAqk9B/A5V6BdyFc9TCi9qPR5s+5YB2Nz7wvNR9nAbeEcPJsbtVheKhU0BmZiEeIE4eRGblRx5++FRPnqdsdr85VLP/O8mEe5BmTpivWVuIPUTMyGguVsQK2
 nCcDlaWd
 wLXxEFfrjD24Op+HMtg1qZFsjcj2c4qfH73d3Hv+NK91RRylQxxpHG7zXq4nLp6G4IddtiNRJ6DDfm7YjFg1ONWoNm8WD7zSKCHGBN/bQdybfYj2K9F7ZwCV3M7wsMAwbQioTfmX/WPxDg3aiLoAk1WmQ4Q3nxact5MI9Xo9FPNbhQb2er6ra/2Lh4aqZXjelvFNPaMhxyp+CWg3EGTNAFJbvLKtTTvn3KkP/bCLjKNhlvo+vYD9P/TzDCxCvCKc6trI4Q5ButnDmKmpwV66H/1oOqlxIO9wa2KSGcY4BHnw+TcfRVORrcB2l1qPQOzyoqgFTDF7WPKGjp9XX719KRc0CcyaySete8ykGAxDQ1qcwogNq+sO8hav+Yictb5Q/pxwpMrBtNEgzv2X6eeMISOWPcgdhSBaIUq5V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 16-09-25 17:28:36, Uladzislau Rezki wrote:
> On Mon, Sep 15, 2025 at 07:11:27PM +0200, Michal Hocko wrote:
> > On Mon 15-09-25 15:40:34, Uladzislau Rezki wrote:
> > > vm_area_alloc_pages() contains the only voluntary reschedule points
> > > along vmalloc() allocation path. They are needed to ensure forward
> > > progress on PREEMPT_NONE kernels under contention for vmap metadata
> > > (e.g. alloc_vmap_area()).
> > > 
> > > However, yielding should only be done if the given GFP flags allow
> > > blocking. This patch avoids calling cond_resched() when allocation
> > > context is non-blocking(GFP_ATOMIC, GFP_NOWAIT).
> > 
> > We do have cond_resched in the page allocator path, right?
> > So unless I am missing something we can safely drope these. I thought we
> > have discused this already.
> > 
> Yes, we discussed this. I did some test with dropped cond_resched() for
> !PREEMPT kernel and i can trigger soft-lockups under really heavy stress
> load.
> 
> I prefer to keep them so far for consistency. I need some time to
> investigate it more. As i noted in commit message, the vmalloc()
> path only has those two resched points. Probably i need to move
> them into another place later.
> 
> As for page-allocator, it is in a slow path which i do not hit in
> my stress-setup.

OK, so the fast path can trigger the soft lockup? If yes please mention
that in the changelog so that we know why this is needed. With that
included feel free to add
Acked-by: Michal Hocko <mhocko@suse.com>

-- 
Michal Hocko
SUSE Labs

