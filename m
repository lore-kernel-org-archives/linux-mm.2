Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45351CCD1AF
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 18:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68AA68E0005; Tue, 21 Oct 2025 14:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662028E0002; Tue, 21 Oct 2025 14:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59EE68E0005; Tue, 21 Oct 2025 14:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA238E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:52:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E272013B76A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:52:45 +0000 (UTC)
X-FDA: 84023017890.20.8F0B69F
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 203471C0011
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:52:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KnPD8xFG;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761072764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLvUWCk0Mz4Y0PzOoaEb6Yq0ejoswRanjDyfbct8ulk=;
	b=ZyjWmRMDomAawgKyKX1OCuvAb2U/d53NDGBcLUSDAgeJYsScMS+6ozNltjDqO4i48yZvq5
	/lm85qL+cY/zI7WqaX4ZWoAHktRYmp0rcZGkmU+/ZVCmxBOomOKSbqSCSXpr2NA9ipLBhf
	F8f2zfOcn6dGuWFUd/Pg79JSjS5NGN4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KnPD8xFG;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761072764; a=rsa-sha256;
	cv=none;
	b=OXKwm/WvpsuF0T7yIzUsiUri1/5u4ET65TAVNAFSrkg8/xa2GNJYcm3EVw1TbEogK/s0kF
	38LiwL2vLtfmUMDChfm8YR4aFbMVyzcj1mkhxD1XnmPVTqJ2LGsxdmlPS0DQQPNfhFUv4E
	GtvK1u2JM+7DdClTLFtByerLZaFPaAE=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-87c1f607e72so2247346d6.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761072763; x=1761677563; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HLvUWCk0Mz4Y0PzOoaEb6Yq0ejoswRanjDyfbct8ulk=;
        b=KnPD8xFGHDWtnd/JKfcn2UjHL3TPdZMWDHBmmL+6ZjkYaL49/7ipWykk1FsHoj5xd0
         B2nrcATLyQaPvyrVgypjJ9ENdR57LGHRPidN3oPivvPGkKKUMdNKzmDSZMXnce2s6mlE
         UMftalpVsIsHlMouF0/v2+FsWNdfh30z+W8G85jwJ7iBihQAmdIgsVXWhuKmAvJMuZUA
         RlHGuUgVdOdmKAQrpzhqJHy+UBs2C/7tR8AekHFDVPUwSx6a2ZDqa86eI7ikGaQUxS0S
         T7/XBcZhGYGk503O9PHbdWf2s1IJzKFbxu/XNuASYD0tETbEhg8RU2Tjk84A74kha7wu
         tu7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761072763; x=1761677563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HLvUWCk0Mz4Y0PzOoaEb6Yq0ejoswRanjDyfbct8ulk=;
        b=ZJ6gejJvJnYA9pT/avRejB3hTCaltaJbVb0ZCviAzm8pJV96S9Th3n7JX5YKhiFUlM
         8SdZMzMdPm48h4Aq6QRM+rPuJ8mY+fcuqrdh4QFSyIrfm/V/qyLt+aauDNCuNBP3hKeE
         Vq1wyZwZiZyx9iOTA0U1rkD00asLbeDTU7SMWrQY8HG5aaiv3cnJOxH5qTKqCYbwuaiD
         H0hXc9VLWLX7Ide4uJFQ1Zi8uLXwzugLXWU18yRfN90HsRVL1skllDtDYEKZ3fOGsZXC
         iro4VsRnA2T/pjMk1SmvajM7d+v8iywPZ1GqOzlWeVOAguocp53SeTBDWe9sElDGKTIv
         8i8A==
X-Forwarded-Encrypted: i=1; AJvYcCUs+bbu0uwYhZioZfFiiG5tcGIJq3WKAZliKd/+hZSDb6Up5+KNfyI5OrLWQS8CZHVOwdrjrTrMZQ==@kvack.org
X-Gm-Message-State: AOJu0Ywvkg23Oew7uOLeaq0gHMJGwUJwFOXoOicnoBJReZD4d55oQRfW
	wFk+qSs0dkstn0lfLeZViYTYg/M3/5G9j0GfWtdyJUPgzqfBj79URF3riBusGGh8a3Y=
X-Gm-Gg: ASbGncvZs/mYfJyEqD2VRzfwq5nJqPj+hzEGqtnUG5PZg55uHGp394bekZEs2/2A849
	yfZiuHOsgUgvJFYbsbV01gsBXFVO7aaFQadjCSnOaATprAkPny+8e5kWDM7fKpiTCPnlyWZYutM
	SUFIWH7FW2hVG1qLa3VOCEGO46C2azFqpW9uU+PWgRHJjQ7CInkxmSdfbHuNmo7XoBPGH/4IcsF
	gJ/AgX2Zk73Upq76DaG0EclXDqBmD8f4CdvrXNGv59CXvZ2/RgsyOA579jextGilt61asBHuyVp
	rbIznyeHlYC7683fP5VE9x2yDxy82uKBgPNEWb67MLMC9Wj7cY61NJkrt9ARlsGAv18wOphSCd0
	Y978fVRT/15euCyWdsb660nKj/XuWDU1Sut7Nt8NxcOJrPCYmEXPKkuLGj2B4iZsrWJR4tHiVdQ
	i6iLCzzczSf4tpPJH2zPnWV6kQfeW0FzNTYgWh0vXHZaX19SCSjVKIwZZP1/I=
X-Google-Smtp-Source: AGHT+IECNSsoqasWHr7E4/BHoh0FWWJN2h6QnlVVo6n6s/g3DObB3176YMdFgdU0/Gh837/Hks5Q1w==
X-Received: by 2002:a05:6214:e8e:b0:87a:97f:de8c with SMTP id 6a1803df08f44-87df6760e0dmr10210096d6.28.1761072762996;
        Tue, 21 Oct 2025 11:52:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87cf521bf8esm73053056d6.22.2025.10.21.11.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 11:52:42 -0700 (PDT)
Date: Tue, 21 Oct 2025 14:52:40 -0400
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>,
	Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dave.hansen@intel.com, hannes@cmpxchg.org,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com,
	Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aPfWePBq8d3v979f@gourry-fedora-PF4VCD3F>
References: <20250925162426.00007474@huawei.com>
 <aNVohF0sPNZSuTgI@gourry-fedora-PF4VCD3F>
 <20250925182308.00001be4@huawei.com>
 <aNWRuKGurAntxhxG@gourry-fedora-PF4VCD3F>
 <aNzWwz5OYLOjwjLv@gourry-fedora-PF4VCD3F>
 <CAOi6=wTsY=EWt=yQ_7QJONsJpTM_3HKp0c42FKaJ8iJ2q8-n+w@mail.gmail.com>
 <aPJPnZ01Gzi533v4@gourry-fedora-PF4VCD3F>
 <20251017153613.00004940@huawei.com>
 <aPJZtQS4wJ1fkJq-@gourry-fedora-PF4VCD3F>
 <20251020150526.000078b6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020150526.000078b6@huawei.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 203471C0011
X-Stat-Signature: rhzbim5wosbruy669ab7bwgbenokx159
X-Rspam-User: 
X-HE-Tag: 1761072763-600811
X-HE-Meta: U2FsdGVkX1+bBICVYmPfbEdDRR1EHQ8HvSIa7TQebu0g4sgwPmvKvy6wHzkC9Lo1KHeNQWGK0u5ndbGywTBUGEqslznU/+jriNwMRwJiPeAJNRBHFhRCZ7A1lg57TW5Fa4HX7cOMlZsWGr7SyOTkD2vBzt09Yhqu1ayGt2hcs19QfZFJK01xusgA/LB0AWMGZU2d1vhVLCNeAP8eRb4M6RbbDsUEB2tQFyDdTX2/5YgYWG2OG3hSk319EDhH9rbuRGnOEImpBYlQrv9Fbgg5ujSa5EjcJML5l/44ZwQBCySDGiLQ8dQ1RNLp72/FUkx4VhHvoU0u35QR1x32JBKOX0XiqRiL7hRzRMRLRet/PtXgDdbUmuuHP03V/yXEHSanrtbxE5CjbFf9Jl4twnt8vxJF8yF+PDfoLhwQGXjEdRVL4xdix0Z+D8z//b5qWLJQrXqG4+10g/NSdWDTGeils2EJoHwcls/lHyc535JPP6us1gB6IpUpK2kJn4vIN6pHIgdQjX7U5uC05CJNlAWRmLbD7kAHaPWgUEZEF2+0sAt6vsIX03L07CJtU0X6ykPqsvVfd6wlcH8MwNo4cTkfiHnXA7x+RfsSGEBbq4GGfBKShGa9C1U0HQ4/QqPpZAwyr6rG0jzjlMWm88Nq3LXWHbLbWmon1lgCHGf6LITt0YbGb3ONeGetiN9NvWttLGngxGBCXHgZsuB6cZJ7t8pnAAX1bkvoC5uce8/Di58MnQCv4JGswDWrNy+6jD+xG4uJKtzMzK2CrCXVFbiLfrS6/9btqKfdB2RLF9FO4d2wb9waIGM+Mrnw0DqxA/x/6RIhMgK3IUoD/ZuL8eMpN87pe4gz+lCeG1RSxVhduJK7vGsvyefoUZM0st0ByLKdtz09X8q1geO41KZ3AxmaQbP+kS+3HAZIQ/NsQ+GjuLeTXyE1L2L1qupuOdFXl6QMh2GRi6JzblwTRfHl7YbSg0i
 SuDpMDah
 9xaLo/aA6VkfGQMAXsDdDNJhWewq3cj4bHUxTle5mHu3DL37/BJrGbaowY/fOqW4BLFCeS8hp7eK77d2bRy1B4phFffGJukDzGO4V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 03:05:26PM +0100, Jonathan Cameron wrote:
> > More generally could have a "Not-for-general-consumption bit" instead
> > of specifically a compressed bit.  Maybe both a "No-Consume" and a
> > "Special Node" bit would be useful separately.
> > 
> > Of course then platforms need to be made to understand all these:
> > 
> > "No-Consume" -> force EFI_MEMORY_SP or leave it reserved
> > "Special Node" -> allocate its own PXM / Provide discrete CFMWS
> > 
> > Naming obviously non-instructive here, may as well call them Nancy and
> > Bob bits.
> 
> For compression specifically I think there is value in making it
> explicitly compression because the host hardware might handle that
> differently. The other bits might be worth having as well
> though. SPM was all about 'you could' use it as normal memory but
> someone put it there for something else. This more a case of
> SPOM. Specific Purpose Only Memory - eats babies if you don't know
> the extra rules for each instance of that.
> 

This is a fair point.  Something like a SPOM bit that says some other
bit-field is valid and you get to add new extensions about how the
memory should be used?  :shrug: probably sufficiently extensible but
maybe never used for anything more than compression.

> Maybe the BIOS would have a look at devices and decide to enable a
> compressed memory CFMWS if it finds devices that need it and not do
> so otherwise, though not doing so breaks hotplug of compressed memory devices.
> 
> So my guess is either we need to fix Linux to allow splitting a fixed
> memory window up into multiple NUMA nodes, or platforms have to spin
> extra fixed memory windows (host side PA ranges with a NUMA node for each).
> 

I don't think splitting a CFMW into multiple nodes is feasible, but I
also haven't looked at that region of ACPI code since i finished the
docs.  I can look into that.

I would prefer the former, since this is already what's done for
hostbridge interleave vs non-interleave setups, where the host may
expose multiple CFMW for the same devices depending on how the OS.

> Which option depends a bit on whether we expect host hardware to either
> handle compressed differently from normal ram, or at least separate it
> for QoS reasons.
> 

There's only a handful of folks discussing this at the moment, but so
far we've all be consistent in our gut telling us it should be handled
differently for reliability reasons.  But also, more opinions always
welcome :]

~Gregory

