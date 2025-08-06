Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA11DC87FD2
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 02:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69AEB8E0007; Tue,  5 Aug 2025 22:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64BB88E0001; Tue,  5 Aug 2025 22:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A808E0007; Tue,  5 Aug 2025 22:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41F688E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 22:44:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8E9680D49
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 02:44:10 +0000 (UTC)
X-FDA: 83744788260.12.86AE216
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 36403120004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 02:44:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MhTbufB7;
	spf=pass (imf29.hostedemail.com: domain of airlied@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=airlied@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754448249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yl+QGO/FoekIvls1YM3Wb/aWR3GhVD7gGl3r1b1iECk=;
	b=jxp9AuWLPPQ/HGSGC0qQ736ZYeAZN+oMuccPX02O1PlYFXsSBTG/VscefomPInuIIothSx
	3fTYLvwEB0ratoMVtpPZCC+QMEPlQNweJyAo/H4PWuX3QQ5KMmGOxzxSsrYS+dGBMDSQ5s
	ezu6xiwxVaMLbvK6hE1VDTnPqw852do=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MhTbufB7;
	spf=pass (imf29.hostedemail.com: domain of airlied@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=airlied@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754448249; a=rsa-sha256;
	cv=none;
	b=M5zNLO5FEOJJy0IP5asD++ZPC/QFLbeSepgfkr67+gsDnhdrVx+dU9uqeU4jGdkn871C5J
	/THTjkODS4ZN9IgJ8ltF3c2CazBht08nVx73CEA2WXhu+mJw2xt0leSodcDevNDcL2mP4G
	iHLKsc44JC1smSKsC0RanWnyk4Ka1VA=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-60c9d8a169bso9082818a12.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 19:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754448248; x=1755053048; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yl+QGO/FoekIvls1YM3Wb/aWR3GhVD7gGl3r1b1iECk=;
        b=MhTbufB7GssJMCQP7+nw7+SetaY1cAaKfyVRwSYMIg4W5K5BVsxmQXtibj15nJ/J7p
         d2cT/2e+huPxPf/XfbEBuSWJSyhkaVZcD6C3xlXTxjxlSRTqsE8ugJblF+pkM3mg3N0h
         yhzVNxmzS4kqfBA52QFNO9ROuKewochZcvLucEPAAJncjuv7mJ6hu77icAAgZB/SIkCs
         r+P4cr8ikF6phe7eNye2FXwYOQnXbxAPS4L1X6waC9fddC4nCJNRoUbrLJP/AyqNO4DT
         8M5rbfOIGJMCzKYLNlexscVOfJtbHWB43EV1szw4oVbLKDFh3keAj7cAch5W7roH1cGU
         51KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754448248; x=1755053048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yl+QGO/FoekIvls1YM3Wb/aWR3GhVD7gGl3r1b1iECk=;
        b=vVHTSusVR0Id0N22U4FVfKctKLEudQ0/dY8YfaDb94T5asQhypzDTny0y8bBekas4R
         tWV41rU1Wt8ZeuaAAnNvhlpMUd15GNQWz1LaCn2a0fY7XLKt4P1VB/fCBiUYYPAFAAry
         SX6tI/Mw1EvDGqiMlr/VMPr0LUb7AZqm3bHjyT/3fLjfYDFs6ldZORMF/7hfdBouircV
         X6p2ZS5wFzPwDUX/GEfFSdLI8vDlCVVtxcPIMa/fOz0IM9ASkuJjYvhfiNQ6oNmQMpFD
         eHXenVqSVaK015K1na4cYLuLmgTJ3kizBvdYLqX0IBk231UCxLrZ1Ry5nK88vCErRos4
         7+mA==
X-Forwarded-Encrypted: i=1; AJvYcCV/sYIc6RxIyceexBS6/A96HMVy9PLfA+qIIkGTkixPSeJf1WitTDFdRlVvd/D99+28Ph4BfheDlw==@kvack.org
X-Gm-Message-State: AOJu0YwTfQguvHmdYXp9HyZmweKYJvEMFfjaGGwL6WT/6X9bVJWOjGxy
	FVL8IO+CwkC4K5y0U6dnFVf/+sxBjNHAw7kvQ4nejTduFIboxW4qzhBAtQ71ZZbtghhdCcqM+z7
	s7Uwa57vbNnXNAutPwzJ18qfq9jjhLQY=
X-Gm-Gg: ASbGncvijL2GCqzGhk0C/gEyV4mH0id1rR0LgVyyJMo0GR9/N5dTvvxLK+3suu7RkBd
	CHTyMi+pBDzvPkOd+6R5BflOvCin2T/PDnoEUEEEyc3yhkwMVt4XSV/f4dZYNzrbN8LsD5Q6uyZ
	8TXJ+wf4yiO048/RMhKy8eG6K3lffnvAq798Y2D1AzSxYORUMqCUCVZHrn3sQ81Vn0jyCpSr8U3
	c/Nnw==
X-Google-Smtp-Source: AGHT+IF6gdunMuxxeD8XNnNrX3S700rIKtscM3tEiLfMAUDVgc9a/tKH7mRQBLP0x++zaPZbw+qA2m9BHuLZYyUg2SQ=
X-Received: by 2002:a17:907:972a:b0:ae6:d94f:4326 with SMTP id
 a640c23a62f3a-af992c8337amr68053666b.57.1754448246990; Tue, 05 Aug 2025
 19:44:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250714052243.1149732-1-airlied@gmail.com> <20250714052243.1149732-14-airlied@gmail.com>
 <77949b3a-201d-4e7d-a51f-e77274e4a4be@amd.com> <CAMwc25qP-42wMX4UYhZWiYfvf_1dBVNL9TU9i_Wq7uZPqjQL5Q@mail.gmail.com>
 <CAMwc25pyqhcq-8ubGZT5UX5AYroewBYP6oFN-JmjzEkHgFLTrg@mail.gmail.com> <903cbf42-2fde-4e38-89e4-2d7287b845bf@amd.com>
In-Reply-To: <903cbf42-2fde-4e38-89e4-2d7287b845bf@amd.com>
From: Dave Airlie <airlied@gmail.com>
Date: Wed, 6 Aug 2025 12:43:55 +1000
X-Gm-Features: Ac12FXyxt1T3fE4KRr9aHM4t1lx2fuu-xcZzTkB4ybZNfSc56ewnbwyqjXQ1XGo
Message-ID: <CAPM=9twR1S+O9G6gQMJkssTh22KRQ-rb4WsJPnXiXz+y_9oi6w@mail.gmail.com>
Subject: Re: [PATCH 13/18] ttm/pool: enable memcg tracking and shrinker. (v2)
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: David Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <david@fromorbit.com>, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 36403120004
X-Rspamd-Server: rspam06
X-Stat-Signature: 9ugxurrh7xyjy78hnmqsrhqj7fh6mrpz
X-HE-Tag: 1754448248-982790
X-HE-Meta: U2FsdGVkX18ztYi/OnjWbQrpT/FwKn2VVCw7grjx9ebplbOGr772LNiEeA+uyjC+pAvpLwfsfuKv2dSflWbdLZ7TtO0PLoFHdblPPHxmbW5ZnRf5V0Ctcq4vCcXUSidmsJaBQNAwzccxZ9Jc5L3fIftEfrGqhFTFNEokY2UlxTVEEk6BBIQwyUinFCoD0xQFaA03lGMSowWQsyN7vFMISU3hySNxG81aIAG1+s4JjDwDOTHAoUFs0UHg+vkHiXu4fPV1B241YQybJH6C5DBmJ7sImJdyPoMJWX51Ub79JOWIAUrmiqqZX2uNxjv5dB2P7jMWjHVFbNSXM0QEDNlLRVBaR0gXPVqtVS1WQaLph1V7zhX1LEyRD5H3/NVxu9xVelLuzc4qf7pjaOPnnJuHlMLdlr+LKDrlLntqxlKTmNWyoUAjSGU8tg3s15kvikZ45VztoMUt/rFaSrRrRtsbaW46MFZgNI8+RyHnHFC2cS5eb7+1XO1bx371W+/hE75JtfZRDr2fmTT8gF12xVEihvF/j4DR1AeewTf2XC/n+1rfBApBEoTKS7pifNbOsD65WiKeomMPvgPEu0dKUXXiMZY7LArFzOqw1Pg93dXAzUCMoB86ZCZj4A0O2bPs/5vq97Ydn3z8CGbGddC9BsfkXJrVRWmEy6GRQwsuGWPNqgVvakjJUXbQq0lrFJUlS9OJptGx4mtXgXq3Du2nzGQgbwgOyZkBLrilRhwUVimsSOvAef6l/aN9FrxlmtaO4eahwS7BSgLGaO9x7HGnNh5IGA4C+q6X+hJSZd11I3vuZm/hz8W37id3ydWlTtfQNETjTryy9ukUMIgdNPqSCZTOBhM/XVLvcYUO4Z66zN9rg8Gap++n+SYe6yxtR8YjwxZftupFutQFr48CGXBsGbSL18WWvWbEXnhV8D3T3JjcidDgsDqi+PDrmf5PsLYYSLfZUCcjSRwW0mV+8oQajnJ
 N/MDlPJJ
 ry0bj4gxnazjy+yY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 4 Aug 2025 at 19:22, Christian K=C3=B6nig <christian.koenig@amd.com=
> wrote:
>
> Sorry for the delayed response, just back from vacation.
>
> On 22.07.25 01:16, David Airlie wrote:
> >>>> @@ -162,7 +164,10 @@ static struct page *ttm_pool_alloc_page(struct =
ttm_pool *pool, gfp_t gfp_flags,
> >>>>               p =3D alloc_pages_node(pool->nid, gfp_flags, order);
> >>>>               if (p) {
> >>>>                       p->private =3D order;
> >>>> -                     mod_node_page_state(NODE_DATA(page_to_nid(p)),=
 NR_GPU_ACTIVE, (1 << order));
> >>>> +                     if (!mem_cgroup_charge_gpu_page(objcg, p, orde=
r, gfp_flags, false)) {
> >>>
> >>> Thinking more about it that is way to late. At this point we can't fa=
il the allocation any more.
> >>>
> >>
> >> I've tested it at least works, but there is a bit of a problem with
> >> it, because if we fail a 10 order allocation, it tries to fallback
> >> down the order hierarchy, when there is no point since it can't
> >> account the maximum size.
> >>
> >>> Otherwise we either completely break suspend or don't account system =
allocations to the correctly any more after resume.
> >>
> >> When you say suspend here, do you mean for VRAM allocations, normal
> >> system RAM allocations which are accounted here shouldn't have any
> >> effect on suspend/resume since they stay where they are. Currently it
> >> also doesn't try account for evictions at all.
>
> Good point, I was not considering moves during suspend as evictions. But =
from the code flow that should indeed work for now.
>
> What I meant is that after resume BOs are usually not moved back into VRA=
M immediately. Filling VRAM is rate limited to allow quick response of desk=
top applications after resume.
>
> So at least temporary we hopelessly overcommit system memory after resume=
. But that problem potentially goes into the same bucked as general evictio=
n.
>
> > I've just traced the global swapin/out paths as well and those seem
> > fine for memcg at this point, since they are called only after
> > populate/unpopulate. Now I haven't addressed the new xe swap paths,
> > because I don't have a test path, since amdgpu doesn't support those,
> > I was thinking I'd leave it on the list for when amdgpu goes to that
> > path, or I can spend some time on xe.
>
> I would really prefer that before we commit this that we have patches for=
 both amdgpu and XE which at least demonstrate the functionality.
>
> We are essentially defining uAPI here and when that goes wrong we can't c=
hange it any more as soon as people start depending on it.

 Maarten has supplied xe enablement patches, I'll go spend some time
looking into this on there as well.

>
> >
> > Dave.
> >
> >>>
> >>> What we need is to reserve the memory on BO allocation and commit it =
when the TT backend is populated.
> >>
> >> I'm not sure what reserve vs commit is here, mem cgroup is really just
> >> reserve until you can reserve no more, it's just a single
> >> charge/uncharge stage. If we try and charge and we are over the limit,
> >> bad things will happen, either fail allocation or reclaim for the
> >> cgroup.
>
> Yeah, exactly that is what I think is highly problematic.
>
> When the allocation of a buffer for an application fails in the display s=
erver you basically open up the possibility for a deny of service.
>
> E.g. imaging that an application allocates a 4GiB BO while it's cgroup sa=
ys it can only allocate 2GiB, that will work because the backing store is o=
nly allocated delayed. Now send that BO to the display server and the comma=
nd submission in the display server will fail with an -ENOMEM because we ex=
ceed the cgroup of the application.
>
> As far as I can see we also need to limit how much an application can ove=
rcommit by creating BOs without backing store.
>
> Alternatively disallow creating BOs without backing store, but that is an=
 uAPI change and will break at least some use cases.

This is interesting, because I think the same DOS could exist now if
the system is low on memory, I could allocate a giant unbacked BO and
pass it to the display server now, and when it goes to fill in the
pages it could fail to allocate pages and get ENOMEM?

Should we be considering buffer sharing should cause population?

Dave.

