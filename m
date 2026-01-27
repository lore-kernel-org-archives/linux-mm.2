Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB206D2FEE7
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 22:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59286B0005; Tue, 27 Jan 2026 17:00:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DC166B0089; Tue, 27 Jan 2026 17:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B39D6B008A; Tue, 27 Jan 2026 17:00:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 751226B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 17:00:08 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2689E55D2F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 22:00:08 +0000 (UTC)
X-FDA: 84379112496.29.227CDAF
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7C58C18000D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 22:00:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NURPhp79;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769551206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjM130EplqqQ/xeoUk9+p55WLFrsTBothNzba4XDkwI=;
	b=zoB37OneVNIoJKl/v50rpRIkHXyb2kpMaTvEA2F4YX1NYm16E2n3DWpOqMW8WdSoIMrg4K
	eqFmGzk1bWpxiv0duxesbglWznxnYHst3Y38neiXIAm9HE3+IyEF4fWIU/F6n0G5W/9eLf
	FIxrunuTmcj2QVAFvwo0y/O6pJipnlo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NURPhp79;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769551206; a=rsa-sha256;
	cv=none;
	b=JlVnP2u9xZ6VK3iHpGUy0BpAKbO/Qd0Y7B3iS8ZtMS3jfOcJlE9s+LOlEHhi/ubmy+p4od
	0B2b1KdE3tiHSpLnDZ0Phn4kLdeZVw1tDblesbiBxH7LBtYvjUnrBVFONclQCNqTnqfDoc
	SXCLAqzuEVENAEnnN+gebKZGeWTrv74=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7942b9663f8so55766807b3.2
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769551205; x=1770156005; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IjM130EplqqQ/xeoUk9+p55WLFrsTBothNzba4XDkwI=;
        b=NURPhp79niS1Gw2+WSXv6bY9djSrEGLYBgrETOZ4mbeXAITDAAYpR9F8pbLyJlEKDl
         Wus9L/9JeMoAQ+cuZGYfTTiykbZSqDSoz9u3LVvzKNi7Q8B0jq1qAPMXggBht5MQsZF5
         i354Cjazv2zTxMnshkDYMCBa0XvfnR7eweXozyBVgISol7k948/ZOxjzXnc4o8q4oEKt
         QYA6TJbWbuA+32v3IVawNDotKhL3AfXqDiuACMmU/DX0QrnfWQDAyxOkuQtF+RAUVlCg
         cQcguDEjIuEgnCoRgAiEl6LV+QXTgYSq6hGtWBbQ+/TwOQNeN28sR6YkoSaLr23u8Tds
         htIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769551205; x=1770156005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IjM130EplqqQ/xeoUk9+p55WLFrsTBothNzba4XDkwI=;
        b=rKRdK+eQmjeDTeOreEDHCuSlJAzcHgCizy2cP309WIw5Rhf5godhEReac+8F5S0sGQ
         mS/+Z9Oc3ikSclWo7lEvE0lwUxTjw6jQnS6jE6IJzOmC5TkPx8xbG08ugza6sPZrxJS4
         LQSLo/QmPp88H6M9I1/Rj89yc77ZI2jXII7gU+FfbBnbWl571JP2CnVp6b3tGwWHN8Md
         3Du4siI8fnwPnAnb8huXDGQ5oa6ZER4XnVuDlyK04zeESXTuOj36cgKpaLBmmRB9YnOs
         nOJdNNm49az9GEGRqZGMRtckoPAw4+o119MyZaRYJdUNaMFBpFBsJPTjtUMTG/Tzdwsl
         egiw==
X-Forwarded-Encrypted: i=1; AJvYcCVqlqlrIKIQkYpeeuufhLwBs302LvixwwBoTn62cp+6DKjdT6TKxmi8l+gxy/MISL7vp+wO9HSINA==@kvack.org
X-Gm-Message-State: AOJu0YxJwayeJWw69kCFfPPAJK20/fIuUOrNUxQjgL7LEnr1uY0ENl4u
	dwbfPasdQmo555R6CGULof8HgN6ZxLve533/3FqSa/p/FdKTJs56DpAL
X-Gm-Gg: AZuq6aI7/VjjwlnVuncApczJCN+sw1Uar7oGuMBT1xmsv/JK7trKCjiJ51rSzVNRkvM
	Sq7CwV7bOpf8hQ4ZhXIqoJYouT7Cp45/A1SNrVC8eOxwie7fjKQheWepdtl4/msXOPHtLyauvLK
	zjZBdOuLGwpxcVhxLQUhLcvbGCrNQsiWqkoXPMxrRTiXYVmeI8eGhLx0D39YSsXamuAtT5dghGR
	pqKVmi8zSRDk758goRnQ/ZRwYEDB+4ey0aptTPmlqa5q5T1giHN8LOlZ0dK8Yp0BiizL6Wonjsu
	gDBHNiQrxk3gL/wRQshIED21cVt/As6ApFqHRRwE9aFOEuOE7p8kzJhMXQGRU1betBolgRB9D+0
	IhaulKzCmGldvhDOBJaiIvD76V1IZptPQxBpy3Jp8+RpnBO/GayKEpM7+6dhtQd7qdgPKkQWeye
	KHRVQT9YTnlucsTj1dnJ5z
X-Received: by 2002:a05:690c:6982:b0:793:a94d:4fd2 with SMTP id 00721157ae682-7947ab1d0b8mr25216387b3.6.1769551205384;
        Tue, 27 Jan 2026 14:00:05 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:11::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-794828ab4c6sm3043037b3.34.2026.01.27.14.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 14:00:04 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	bingjiao@google.com,
	jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough free memory in the lower memory tier
Date: Tue, 27 Jan 2026 17:00:02 -0500
Message-ID: <20260127220003.3993576-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAC5umygEq6xvpDFnVnDLYLyqJV7qChEsJ_+W-KCBJ+EXj1948g@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C58C18000D
X-Stat-Signature: hkhfteq4hf9fmjo1wya75ke78twuoaiu
X-Rspam-User: 
X-HE-Tag: 1769551206-595199
X-HE-Meta: U2FsdGVkX18NFQ/dVCGm5MqiYWQCztRxvT4hXFcD7PcrEgoEDe8V1ILT8wY0topZ6Dbla2tltMRL+rqA7w7gC0Ziw4rmQzvp8tgiab4IYcvF1YwZKd0xdNnDU0wTom+gLUAz+Iape9jafEDc6CMeRmt88geRvwAVp26yasrUY9z93MZ6/+gEi8zH3Zdocwy4Mh/MUrOB1X04PvGw++jAEedfrRnIkXNle+rwy7aIZNck0kMMzfnQ8QXF+I/YbGIxYo8i3ICGXT4TNfymUayO5IA9ok8+3hVjSlR7Q4Z7hcg3ydsKSplda9+gRDk4jEaHtKdA74AMe44EXWqwXt5Wqexs0Xq61FyHT9QvD4NAonR+1uRg/Q1whmFoJJZIej3ZxZWqd1jG196dXblX71qb89qACch7WmMM6gyuRsV4h0/Hjlx7ulyJXN2GNpr+qCWHarnsPWKeNps0hGB8sKBIu5nuyqTUnjwE6P41ippM/4+DUXKUtmPpUfwswFPXo/v4U5ryOJUF+5vEG0pyuoHkMRp0KjS04Ax99UvG2Eyii23toBsLw/Skzh3mBLSAeTbFhZOexZZgbG48lcjvSbIblzbYLLGo+uYs1AQ6mDxxHg47ZeBG18g6FKxPG6WfQbDgzd84aubiDNQHa4fE1QnVHT+9fRaaywXBgeXI9muKZpkgjcH5dpon53RjZec6m7LsdXPALYeTX2/SMpHFfdMzNsiQiIjizat2Zk0N1cYxoKUfvJpwY7NWWkM5Qozn03PUTC3Qoh1XGOrWIFnXMxs0ydF/6y0cGUz7raIxpJq7fhVBHmlJ5h89tqdgNQwouk+aIe088+Mi5m+H5Rj/W/g4i8JRw9k7DMpDe6ZqssDkBowbGZK/sLjL9BmFMrWu9tcAb9zAAWzOdxgXO+JL1sPM7N7wHIxCjLCg30m3A6CWqCfd36fvNbljZkzXPGCFoBgXSuIQOmDZUw9I3ypj6QY
 p3LGAYyM
 zdf9/5xOhA12rpNuCQJS9+F5JTk/42QqxsaRds4EUhH05xrJ7ECrh87p45ZHlmZssksBdM82cLKVwPYBuDKQ21J0gP694muvWx8ycZIdSlnHZjld0Xa7RRUlt3/wO3gq0phj7VGcu2j2+Q+BMrQGl2cAy1hqjfUeBNIh/YLBnbJSwLo1FAsnxbOdoxszC2yeXRDNmCPHlSJfBkHDS1916vECHiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > Therefore, it appears that the behavior of get_swappiness() is important
> > > in this issue.
> >
> > This is quite mysterious.
> >
> > Especially because get_swappiness() is an MGLRU exclusive function, I find
> > it quite strange that the issue you mention above occurs regardless of whether
> > MGLRU is enabled or disabled. With MGLRU disabled, did you see the same hangs
> > as before? Were these hangs similarly fixed by modifying the callsite in
> > get_swappiness?
> 
> Good point.
> When MGLRU is disabled, changing only the behavior of can_demote()
> called by get_swappiness() did not solve the problem.
> 
> Instead, the problem was avoided by changing only the behavior of
> can_demote() called by can_reclaim_anon_page(), without changing the
> behavior of can_demote() called from other places.
> 
> > On a separate note, I feel a bit uncomfortable for making this the default
> > setting, regardless of whether there is swap space or not. Just as it is
> > easy to create a degenerate scenario where all memory is unreclaimable
> > and the system starts going into (wasteful) reclaim on the lower tiers,
> > it is equally easy to create a scenario where all memory is very easily
> > reclaimable (say, clean pagecache) and we OOM without making any attempt to
> > free up memory on the lower tiers.
> >
> > Reality is likely somewhere in between. And from my perspective, as long as
> > we have some amount of easily reclaimable memory, I don't think immediately
> > OOMing will be helpful for the system (and even if none of the memory is
> > easily reclaimable, we should still try doing something before killing).
> >
> > > > > The reason for this issue is that memory allocations do not directly
> > > > > trigger the oom-killer, assuming that if the target node has an underlying
> > > > > memory tier, it can always be reclaimed by demotion.
> >
> > This patch enforces that the opposite of this assumption is true; that even
> > if a target node has an underlying memory tier, it can never be reclaimed by
> > demotion.
> >
> > Certainly for systems with swap and some compression methods (z{ram, swap}),
> > this new enforcement could be harmful to the system. What do you think?
> 
> Thank you for the detailed explanation.
> 
> I understand the concern regarding the current patch, which only
> checks the free memory of the demotion target node.
> I will explore a solution.

Hello Akinobu, I hope you had a great weekend!

I noticed something that I thought was worth flagging. It seems like the
primary addition of this patch, which is to check for zone_watermark_ok
across the zones, is already a part of should_reclaim_retry():

    /*
     * Keep reclaiming pages while there is a chance this will lead
     * somewhere.  If none of the target zones can satisfy our allocation
     * request even if all reclaimable pages are considered then we are
     * screwed and have to go OOM.
     */
    for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
                ac->highest_zoneidx, ac->nodemask) {

	[...snip...]

        /*
         * Would the allocation succeed if we reclaimed all
         * reclaimable pages?
         */
        wmark = __zone_watermark_ok(zone, order, min_wmark,
                ac->highest_zoneidx, alloc_flags, available);

        if (wmark) {
            ret = true;
            break;
        }
    }

... which is called in __alloc_pages_slowpath. I wonder why we don't already
hit this. It seems to do the same thing your patch is doing?

What do you think? I hope you have a great day!
Joshua

