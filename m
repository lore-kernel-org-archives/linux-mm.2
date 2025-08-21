Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD20CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 05:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44B48E0012; Thu, 21 Aug 2025 01:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A008E0002; Thu, 21 Aug 2025 01:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B579A8E0012; Thu, 21 Aug 2025 01:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A4ACA8E0002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:02:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B37CB6E24
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:02:16 +0000 (UTC)
X-FDA: 83799568272.13.8DB2445
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf28.hostedemail.com (Postfix) with ESMTP id B1CA4C0012
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:02:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Dgsa7x8C;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755752534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQ6rweUyRrd6FRbnt31L1OFYZrfkhbXeS/99x2tU5H4=;
	b=ZXO3pHjyiv9SVStjzF6RDtbMzFSj2quCg+uOwhFJsGmfTAkovNoG81Cx2A6AZHx5yRFo49
	dMpkdHZRNhfypIammTCZkpKPAMAtbLZJrOzvG6RWuNoYrxBpekvseQc67PMkOmU277k6i4
	ZeSjVUGUP+Z7LMW6VSI6XxR/Y9N/rg0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Dgsa7x8C;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755752534; a=rsa-sha256;
	cv=none;
	b=gMQ+yJMZgSOBhf3y40Hwdxhbtzz7bCAMLPUIKx8Ip4zoiSkj5eH5XjE+jRfXbzrd+PTnpW
	aHG70D/sDcsZ3qeXBrNeLpJ7XEZfwU0WP9mRo7Nc3snwN2uJR89zGLbvKcwsLxo/RH/MWM
	lR6yUiQ9tCvXgplf+059GyPGxrl/Blw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 13519A576DE;
	Thu, 21 Aug 2025 05:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5D7C4CEED;
	Thu, 21 Aug 2025 05:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755752533;
	bh=juudm7vCfpwqTNM4dxkFPZuyYiZ5R+VQzHcLM91Fsb0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Dgsa7x8C8tWIYQQ/s12+OFSXr2Jl29hGtb+NWQ1pyqKXx7fw6Gg0hOLHCahd0KsiY
	 izuLVvZrF4m6riNlJPR3Qkb6l/dUEacijzfvNQ1WhqKIfGu2UQBbidWk43S+C6Hut8
	 MwLqEl50vfgyplsXCIqOSOX78Tsl9Ews9ZgXfsCY=
Date: Wed, 20 Aug 2025 22:02:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, "Pankaj Raghav (Samsung)"
 <kernel@pankajraghav.com>, Matthew Wilcox <willy@infradead.org>, Luis
 Chamberlain <mcgrof@kernel.org>, Jinjiang Tu <tujinjiang@huawei.com>, Oscar
 Salvador <osalvador@suse.de>, linmiaohe@huawei.com, mhocko@kernel.org,
 linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH v2 2/2] mm/memory_hotplug: fix hwpoisoned large folio
 handling in do_migrate_range
Message-Id: <20250820220212.bac0423a778d3b04b05d8bec@linux-foundation.org>
In-Reply-To: <a65acb01-282b-4b6e-979e-e3bc2fcd9b15@redhat.com>
References: <61325284-d1d6-a973-8aa7-c0f226db95fa@huawei.com>
	<924d9d25-e53c-f159-6ec0-e1fd4e96d6e2@huawei.com>
	<eb6a4203-1555-4aae-8320-99679cec90bc@redhat.com>
	<4c5d4fd5-5582-11d8-9fee-24828ac1913d@huawei.com>
	<8c9719f0-c072-40bb-b7f6-6f2cc41a31dc@redhat.com>
	<1D589FE5-3515-4ED5-B12E-D5CE23BA5D13@nvidia.com>
	<e505c25d-c4bf-4d87-8284-6aa0da2fd979@pankajraghav.com>
	<641F5B0B-2B48-46FA-AC58-3A8A4BEB1448@nvidia.com>
	<3702f6b0-27a9-4ca1-adbd-fb1e2985b2d3@redhat.com>
	<ocgxb3ggoaza3irdpea7xhcw3is4vbt24omy2qki36cxkmtecb@jpn7qtco3lvx>
	<345f7ae6-b2d6-44cd-b8b6-2bdd4b33e9d6@redhat.com>
	<CFAECEE9-24CE-42FD-8D55-FCE832D65DD3@nvidia.com>
	<A1B06D4B-5B39-47C3-94E9-93FE3F0A758D@nvidia.com>
	<c0f5492c-f9fe-48c8-98bc-d8cc8e7e00b3@redhat.com>
	<E0D87F2B-20AD-4AE4-943E-C126395C3CE5@nvidia.com>
	<66bc7274-ec2a-423a-8094-b8d4cc9438fe@redhat.com>
	<20250719192300.9e32c35ddc49f11c7954306b@linux-foundation.org>
	<a65acb01-282b-4b6e-979e-e3bc2fcd9b15@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wo7s6prco3w3sj4ainu3uq9qpiykcy6w
X-Rspam-User: 
X-Rspamd-Queue-Id: B1CA4C0012
X-Rspamd-Server: rspam05
X-HE-Tag: 1755752534-43372
X-HE-Meta: U2FsdGVkX1+fzg849Dd2Trfsd4/CkjT0aLpJS8WSC45gDWrZxV7iJF8Z/FvvD2qupZJA7kLhPPR09K1/p1Ktg4cDGei863iwK8V2SRuFy0bnH8f04HYMATG4SDaSrZzq6csxK14g/SQxdoLqCTkUrOWgZvaP67/IAO7TviITLjQtt0z+82ISJEwpHK3eoLolkmKYRNCWLwmwIhoSqX7EzEF3ruemSnqeyLHxmnPOlBIjVLPOTElW1rQg8xMMBu49YhA0GsTTn2oCCjnmbWPmAfwPQMlPbzOqcEVmE+UiOmnOEhpwq7ngyt2nEVzy7MqunIj6LaN8w2YSOU0YP6jp5FwhgsZ/23t1QTuosdJF9r2TfLYTpwqXoAdTz0uenHBJx26z6ImCLcvbCXipjBmCUdOQeqUGilZbZDa8FakRQ3U8kFxdfKtjnQVydMtyp/bo342PZ8ygwyCrt+VqIdZbXVCdNOKtU2LPVUmj9b123J6bJoF5uqPzwpZpqqRIwbT5sG2pTWRYdufNoKM0G2dnMkG1adJ/ko/GczEuOyLk0isyz/HtCVNOI8oxsMBa17kkW2/rgZIXOwbsWZqTV8GUlRE2/4AqCpQkUs70q8MY66rLKBN2lql54uJ8SrdosfD4Jp3a8yjts36eB7V7pH0tU2e5j07Pn0By+LvMlpvFw+rUAmpNinyjiusYIKOBR1cU05Mc3WvBJw6h7v85ggeD2vBvQdncirVrb+DhJ9L5qa+OA0HDLXcHXJ91KInguFz0Ojf89DNu/e+w8KJT0+He5UJeMQjESIZ8w1LlMiznkehSm9OSqJcDYdNVD2/LkAORVk2aC2LM9evUARE9TJRqb+tB7u91alSe4+kDIW3ibDPEnQTdFNJiACwBoIZ0DsbwlT0mN7Xm7AHXVnyHyoTN0whdruiQuZG94BUZgbZ37zMsXLiuUivyLim0W6Jb22F7KqIsezGxXAHcoCitc8Y
 XN0yewrR
 AiqseiQcXYZ7epTQEUHtHvy1xqvBod0Wnl1tTrmLnBs75TUZoPaMrZJD2hHGwrfL5+stCBPtHuPDhkqBYQoJ9pW4ox2cbubWCTRslCA4ivjyVoEUv3I+DsLf4+SPdC7e+O/BTzWV65Ek4LlUcdbNylRp2psKkl1b5NUY2EirIkwdv/hiPzJjhKPB3AAZWdLrnoyk5T1ktvaxxXIpMo0IbY7tVZvWldfyL0hAbCETaWQPpl5LmlMYa/aJt9Tluu9Ou3svp6QZGNmWb05jRT+My9LGwwn8yrHn2vKndH4rsEeXP+emKIdlIy1qfCG28PuPlg+E7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 17:30:06 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 20.07.25 04:23, Andrew Morton wrote:
> > 
> > I continue to retain the original patch in mm-hotfixes as part of
> > akpm's lame bug-tracking system.  3 weeks in -next.
> > 
> > And I just added a cc:stable to it because December 2018.
> > 
> > I don't expect many real-world users will be putting fake delays in
> > memory_failure(), but it's there.
> > 
> > So what do we do here?  Add a TODO, merge it under the
> > better-than-it-was-before theory and move on?
> 
> I would feel better if we could just not fail memory offlining. Memory 
> offlining is documented to loop forever if something bad happens, and 
> user space can cancel it.
> 

Pathetic monthly prod to keep this on people's radar.

