Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA95CD4899A
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 12:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29DED6B0088; Fri, 16 Jan 2026 07:25:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220FE6B0089; Fri, 16 Jan 2026 07:25:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 103A56B008A; Fri, 16 Jan 2026 07:25:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0012D6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:25:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9FAFE1603D9
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:25:49 +0000 (UTC)
X-FDA: 84337748418.02.16EF789
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	by imf13.hostedemail.com (Postfix) with ESMTP id 71D2120002
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:25:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Mjh1DSlH;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.65 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768566347; a=rsa-sha256;
	cv=none;
	b=XAGcQMH/pSWTuxwV+yn0NhQb14bmvyae9tl1b90GzION0w6Uys9RLMwY+aCswb5MOx4IXk
	4d1OB8QpfyUxdr2zhnOc4xvQqQFjURQV50b1myfXpTIRYyw+Warj1deL0NVUK16ZdBivXH
	p8SRPHROhYI817Ghd7DfVw86elpquaY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Mjh1DSlH;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.65 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768566347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFQMY/xsDJvG31vX56byjsZOMI0xogP8BAsnuUmd/Ss=;
	b=mZTB9wGfcBcbe6FJXXgL50jzDj5JXSKM2Ts9ws23T5IY1HlfcQAtzmpBHcYSTfxlG8nUdk
	kLxvdvX/XDZRae//ksZY2NOryhaj6ebDN4ya1s3iTy0q0ZtNbjZxhE9jguNITt4I8wbWIO
	PMsIgIAeQzZIbivSdci5HPEaHFM3SIo=
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-42fb03c3cf2so1410021f8f.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768566346; x=1769171146; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fFQMY/xsDJvG31vX56byjsZOMI0xogP8BAsnuUmd/Ss=;
        b=Mjh1DSlH4bLIgnovUETUoJmLkOzT4423jJNNwl7696kV/wnl5t2nnP41pxF7U/OTeX
         f12HWq384OcMV1Ex3ujCkQp926xaJ7jmb9MMje7Szz1xV5+E2S6Luk1sWhuzyl7lum2C
         LwMxWHscLpzA5SSQ2HlEHfRQD+qKS8D0XEOOMqkJpWvJ+swNKdxOnDeD530L42Xzjl+R
         QA2rjC/DpoxD05yYMZo2vMlaf9lIL0gwii9Qsclb/Ih1UEXxi6cw9tAg6p45fwAraP0w
         nk1S01fwVSrA4+FPHfHHD3K0iw7gBnoC/29lmgquwRX8Vz8sEfSxLC5PLrePaamKUQhE
         gafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768566346; x=1769171146;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fFQMY/xsDJvG31vX56byjsZOMI0xogP8BAsnuUmd/Ss=;
        b=iVI79UnYP9mIC6axvUVrLQAFdHh+e4qM+b+syEuhbbFaubHm02C4fl6wF/+dXpzBvS
         TbJWaTcRgLyiwKiI7OmQXnnavZXwxk6ry75zW9knaMKNwIqP1Ic8r2T6RIq5aXB7ZsGp
         JS2POLw2O+XpcY12NZnpLi7/yxOGSR9gYCzunmfnTw59eoakyaKvRJWOpIu5U0kxMJKf
         GWY+hzpRLBwDY/0uCDCg0jPBq0h90x+rOKkyQqJsJgFx35aQbg+WHMOEy9CWcGF7Baf4
         E9P88nTBd6MxFNiAB8IO9b9h3HsHsUhLNe/VncsK71vT7TzjPZ9D8prg6BZgDj0zgBYI
         qN5g==
X-Forwarded-Encrypted: i=1; AJvYcCWSTKWHd5e0uCGpfn4sWKdu0uI64R6DJEf47JjnjxXXej7Mgsa0rJ1nVXRmsAdv3H49lsEzhkfvjQ==@kvack.org
X-Gm-Message-State: AOJu0YwdHlgpbIhjPw40E/RIsMA9JF5wmEg/A2V6/CV54hhiDatuZ65D
	ETEcs+5KMvA2XevlSS9ouRW48f2H11l59xGBfMAdrbVHzVja0W3KHEXNJRPO6J93Emk=
X-Gm-Gg: AY/fxX5b82vMHZrdDKl3jfVTz1X+vk9kvj2/aPaR70ooJROtpLhXl+lsz4Ft9zBKTdD
	lWh2G2Zy7/iQy6ReHZUwWtRNbXhjObAiWpIVQxkm6F0RmsIows82MHOSzD1Vn89Uct7Efm3JEGg
	Kso0re8kJnPn1qzBO1iapNDcxe+r3vvNP6R2KWUPrCPB66payfpr1lIX+su8+VoDjIqdVCpoP85
	3A9F4p+yTmfDcFNeSwS+VzRTv3Dg50I94o5aHRJGuNDRX905EzMm5ZvrVEDP5HMqOPxLBIDAejZ
	OcUelay5C2d6NxLsmzUafHjr+6yOeICCITRWKwVMMNsGg24/kXWUOZAQwBVoS7l6g7x3MS/APJU
	fj4v0rJTVQ9OOWWhRIJr9Bvv7K2s2e45suo+WHl4QPfNEaTbhqYORKglaAdsMldiXiCHrhcSGmt
	yK7cwnnIrT3+/PjFk11ut+uUJR
X-Received: by 2002:a5d:588d:0:b0:430:ff81:2965 with SMTP id ffacd0b85a97d-4356a060dc4mr3007686f8f.49.1768566345760;
        Fri, 16 Jan 2026 04:25:45 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356997e79asm5028682f8f.33.2026.01.16.04.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 04:25:45 -0800 (PST)
Date: Fri, 16 Jan 2026 13:25:43 +0100
From: Michal Hocko <mhocko@suse.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, ziy@nvidia.com,
	harry.yoo@oracle.com, yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
	lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 00/30] Eliminate Dying Memory Cgroup
Message-ID: <aWouRwBftqNDz10t@tiehlicka>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <20260114095839.eabf8106e97bf3bcf0917341@linux-foundation.org>
 <0a5af01f-2bb3-4dbe-8d16-f1b56f016dee@lucifer.local>
 <20260115164306.58a9a010de812e7ac649d952@linux-foundation.org>
 <fee37e75-e818-46b0-8494-684ef3eb5cd4@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fee37e75-e818-46b0-8494-684ef3eb5cd4@lucifer.local>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 71D2120002
X-Stat-Signature: t73n7x7roq1r5tkhp6swof9a9niquefs
X-Rspam-User: 
X-HE-Tag: 1768566347-394121
X-HE-Meta: U2FsdGVkX19Um9XQXExAs1Cdrb1l5RhGrXcYmVGFFBq9/bCl47b1d/OLUEdmS+ja0WNhxgXE3IFrTXL7tCYyHpGHVEFCkEcKh6thr17YBWEcnObL93hXaFWJWomBMZYZadHof4VBCwL0tW0+IBS9sdSNUeQ/JMAeD3OonGOFSPzJ9S6ReJWB+BkLJpmiTIyFaAGF/WdPWMq/MMo5WynZztsZuaI3PrIs5LdqHRdcsMU7mkAGGsUPXx6z43eeBoGpiDJze9gSe45XBtESSmOsOlXgYskrsiGFZdl0P5NISc3+XnlxuLVAMA9vPX72TALoM/DmYiC40Y8CJ7MN3y8wgPYKJXhS1oxbu2Udr3+/Ew/C5Y1nVecaR8kJASYB7r+69BmInQUrys1oFv7WoVf1SOZkcfx1T7zKQ556ZNcf5w+hQ1RyV/lwPf4z2O42lsCdJGxhNFznInxfGQdYiXPdifO7sOcywzH984Ks41Y+5bl2gcQmEDoKU7O8suZe8roijAwjkC0sywwofB6Ku+Wc7wNCH+S4jZnzahvBvBpt56s5Um6A4M6WFcsP9XS4ya859wt+fFpheMD4XQY39gcXrsHhStQI3MC5XrUsrWzp6cw37uS37hDIWkyxrXY/UJI8NJWnr54scNqwOebEIJuI6GKd8JwCIy/OPDX9xu61NsVc6KguUdc9LAABufcQ2wx/tIbspzSqmcyultFgmcOFbS4v42CqYsHI2TSHnOTWrswmX5Rg8F5tjiUDjD5jUfsuPSn5OAvN4vrVFiyvOykI1GwgHhd8vdqGsLtdRxgH6PzHlMEla/BrdZyCj7LUm8lGt5d7DyxjTga8gVznbhzRm8yOsssSBLIR96LsbMglOmLNVgaNgpkJW6hu65XoesgjExLefCOGOFpOpGmyHkplQlOnu80+8M2CeIMz90cE0laswkYg3ld0uenZTe8eXvllcN9852nBbq70Ikqy8/b
 xanIl6jX
 ycxTtMnhKn2TMFzy25b4LwgjMx7aBx/AXe2aL69L1waStUzfHEnWkCbDQefiGtytNVUe/DfyV+h5ZIGNswjJcjKnyclMJ7piiiylwckFAAvkbMgEIvkvIOAyrc9f3/qUG+V92njpMkq4IIOi9rFDol/zC2P/E7OPoIx/eW2XwqGTaHdRbFWbPHmTYpn94PYrApDcVDzSno3p0carOOxxD280y0UoWBfEUeOSLHYNDP1oml5f8rbW63PW1vbTFssdpZykpbZr+yEAaLX67z7mL/fg+BI5T5dj7/DR2B5BiJkUhKYmSaq9PnQ43TAnNSRUeZjrczdIoSvhVql+4TpylyM9TDzei24T4c7i8vIjVSqgRO/WQ8pdZHv9IvLg/dqbRV7PQAp4mUa/GtcfbccnGPjvPAkZ24/4FXttYizd9JXY0OSsvZzVq2sBnXNSPA4MBfOlyMGEWXZkQIYeIbUgLtF2s2pr0YG4fBP4xW/AChHxmLGxqGXdCO601CyDZ15CYg/CJX0SwwPw73sqVUWc9Dn8wL1bsamDfujZfTsW+xO+7Vok=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 16-01-26 08:33:44, Lorenzo Stoakes wrote:
> On Thu, Jan 15, 2026 at 04:43:06PM -0800, Andrew Morton wrote:
> > On Thu, 15 Jan 2026 12:40:12 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> >
> > > On Wed, Jan 14, 2026 at 09:58:39AM -0800, Andrew Morton wrote:
> > > > On Wed, 14 Jan 2026 19:26:43 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> > > >
> > > > > This patchset is intended to transfer the LRU pages to the object cgroup
> > > > > without holding a reference to the original memory cgroup in order to
> > > > > address the issue of the dying memory cgroup.
> > > >
> > > > Thanks.  I'll add this to mm.git for testing.  A patchset of this
> > > > magnitude at -rc5 is a little ambitious, but Linus is giving us an rc8
> > > > so let's see.
> > > >
> > > > I'll suppress the usual added-to-mm email spray.
> > >
> > > Since this is so large and we are late on in the cycle can I in this case
> > > can I explicitly ask for at least 1 sub-M tag on each commit before
> > > queueing for Linus please?
> >
> > Well, kinda.
> >
> > fs/buffer.c
> > fs/fs-writeback.c
> > include/linux/memcontrol.h
> > include/linux/mm_inline.h
> > include/linux/mmzone.h
> > include/linux/swap.h
> > include/trace/events/writeback.h
> > mm/compaction.c
> > mm/huge_memory.c
> > mm/memcontrol.c
> > mm/memcontrol-v1.c
> > mm/memcontrol-v1.h
> > mm/migrate.c
> > mm/mlock.c
> > mm/page_io.c
> > mm/percpu.c
> > mm/shrinker.c
> > mm/swap.c
> > mm/vmscan.c
> > mm/workingset.c
> > mm/zswap.c
> >
> > That's a lot of reviewers to round up!  And there are far worse cases -
> > MM patchsets are often splattered elsewhere.  We can't have MM
> > patchsets getting stalled because some video driver developer is on
> > leave or got laid off.  Not suggesting that you were really suggesting
> > that!
> 
> Yeah, obviously judgment needs to be applied in these situations - an 'M'
> implies community trusts sensible decisions, so since this is really about
> the cgroup behaviour, I'd say simply requiring at least 1 M per-patch from
> any of:
> 
> M:	Johannes Weiner <hannes@cmpxchg.org>
> M:	Michal Hocko <mhocko@kernel.org>
> M:	Roman Gushchin <roman.gushchin@linux.dev>
> M:	Shakeel Butt <shakeel.butt@linux.dev>
> 
> Suffices.

I have seen a good deal of review feedback from Johannes, Roman and
Shakeel (thx!). I have it on my todo list as well but the series is
really large and it is not that easy to find time to do the proper
review. Anyway, unlike before xmas when there was barely any review
and I asked to slow down I feel much more confident just by seeing acks
from others memcg maintainers.

That being said, if I fail to find proper time to review myself I am
fully confident to rely on other memcg maintainers here. So this should
not be blocked waiting for me.

Thanks!
-- 
Michal Hocko
SUSE Labs

