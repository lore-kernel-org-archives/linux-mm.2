Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31E80CCD195
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 14:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DCFC8E0016; Thu, 16 Oct 2025 10:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B50C8E0002; Thu, 16 Oct 2025 10:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA588E0016; Thu, 16 Oct 2025 10:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D05B8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:49:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 00E991DD819
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 14:49:58 +0000 (UTC)
X-FDA: 84004262118.01.95B313B
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id EEBCBC000C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 14:49:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=J3oYpSpH;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760626197; a=rsa-sha256;
	cv=none;
	b=31XhuhPhGwTTZtb4j5T7OlH862t6Q/Ov97C56qGkBeLW+DDVp7XYiy+8uo40d4lca9K+li
	oHz7ZgoUVmA+fRjbUrOqFZkhMceaCyJFJFsAbO4fKw1u3zlBaJLPV5q5BPiKJnHMnkJ17w
	4XX5jeRIZvposM0a3ZAxLxULub3d+iw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=J3oYpSpH;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760626197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6F4mIwBhj9doOK9z7k7FEumR2hjJ0tw1xmmCLD9hKA=;
	b=FP3DXy+5kDBlBnZ5Hv3yu2VC2p0tezJ9gpdDTqqGtt1Njjl1H77sGrelRmgMdI9pVJKajt
	2YHhxzDhs/XbSpmXIyetgzMfye2eGX2WDKiZNhUxZmrHe4KX5wTCA0B1/JVXS11Qx57nRh
	DJIN5hTbj2zBimk4OBN8sUybSQ/+Z2I=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ee15b5435bso584672f8f.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760626193; x=1761230993; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W6F4mIwBhj9doOK9z7k7FEumR2hjJ0tw1xmmCLD9hKA=;
        b=J3oYpSpHU64wG86uG8yBkyo2eRAqFBYkW5shVlAImCanYuj9yF1OB9Zn2NhdlT+D72
         bhBisZXWPODv+kqOTtksXbz8Bye8yGBbtoDloUrBbAJ4CqcT2tUyUMJ+0XSt0pRwAI5J
         HjLnHU1ry+1npT6W7h8E1KzJng1AbD7qd1vg8nvOl5NoCWF0QD/fy/EEwTaIM4mMIkMo
         /npTO+NThmkYL6sRDTleTpiW67ADimzOP2PqdPFng87KRt83SN75A8mj92OVl1pUeHh2
         N+g2OBxonZjSWmB5HAuH94EMk2dAgvZxbKJv/SeROYMZ7hJsj2779RV5il+4zv/6yEOJ
         QkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760626193; x=1761230993;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6F4mIwBhj9doOK9z7k7FEumR2hjJ0tw1xmmCLD9hKA=;
        b=SeYi+owxOkO2RVYBzcVyh3tMcEOS3YYafnokdNlUj5KKMXpIS8C7q23XRLLgreloMB
         mkoQ817vl0Gg7bg84H2paQA/AHfHb9Xu1QYT7/ZG/9UKiGOKz2Ge7VifI2hLfsVBnMZY
         PY3t8Zp+shxMBLqxb8RNAAhD0BIS7b9avSUyrFtwPP8HsUor1xhRwsvZftct8x/DX3gK
         TvEZmYthOsqq137+Ego939rleKkJGPQj7Fax+w/x1qR8C0rtiJXsDdt0F/xS+zeF0wGo
         GjFin6ZIuVObxryMy1qxMEtwRU3rY0bgFS8EVfNiNSHz+JsYOQ80wt2m1SrBisPLrpBd
         xLbg==
X-Gm-Message-State: AOJu0YyrXboqCRCNjV6gWccKp4dJUmIk2Qy+l/UL/piICAHI971vnUXc
	sFh1uFpCNrCTV659feN74GqZuUqbuFoOTYMrjowM8KT5D/M/SFyj6E79OTJwn3/cAGc=
X-Gm-Gg: ASbGncv4pLCtUs/q9fF0WZCJlLZxcaKq12d3DykvUHBWnkXgZUZomVBlRaEcHFJ3b+b
	qUsFDMfDaMxt4dxzIDMVscnN8FWuTAFGnaQ+GJUcLOSm8uaiXKIo4coh7RCgWmbExeqfUe3QLq7
	lRmrafjULp6/Qr6YOFiteWbyfdDGHxaC99EsZu3gfQdA5+S1wn+IsA0WAub/+VVqlQc3HRnO0kZ
	1oDUnS6nx+INsUvnV+Hreshpg1147NoOtXsfYpqqEboUg5KHKqgx+/Z6NUNJfYLTzdZWfWbKe0F
	9n0th7AQcyU0jjAUrlpbWxE4HU7BvwQZuEHc94stB89mZhcSNXHujCBwIh0uCIU25D/ym4UIP52
	7UJEuRiYPyfyoMpMy6aZuZntRz+Zfy7W4ANYBpfwP9k0YRRl8DaAbCPjpntbSjXXwzEzaSPL8Nw
	I9q613z+xFGhQwkGk4J0QWNw==
X-Google-Smtp-Source: AGHT+IGar8v0iDTZx8UCaPIvELr3VKoaD/nSBrLLGFgIXeQYGbPyAEaN93A5aaeOEz6VqjytwYSZcw==
X-Received: by 2002:a5d:5885:0:b0:3f0:4365:1d36 with SMTP id ffacd0b85a97d-42704d8cde9mr319882f8f.16.1760626192708;
        Thu, 16 Oct 2025 07:49:52 -0700 (PDT)
Received: from localhost (109-81-16-57.rct.o2.cz. [109.81.16.57])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-426ce5e0a03sm35522625f8f.37.2025.10.16.07.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 07:49:52 -0700 (PDT)
Date: Thu, 16 Oct 2025 16:49:51 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: Add retry logic for cgroups with
 memory.low in kswapd
Message-ID: <aPEGDwiA_LhuLZmX@tiehlicka>
References: <20251014081850.65379-1-jiayuan.chen@linux.dev>
 <aO4Y35l12Cav-xr4@tiehlicka>
 <a6cd4eb712f3b9f8898e9a2e511b397e8dc397fc@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6cd4eb712f3b9f8898e9a2e511b397e8dc397fc@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EEBCBC000C
X-Stat-Signature: gim8zzt4b3c545aq44ftuc6eo6njbzgh
X-HE-Tag: 1760626196-730446
X-HE-Meta: U2FsdGVkX1+cLzrE5y8wNxYT+mBFK9IWM4OtncP+qQTLMHEGq+eLxThklVY/WpC/l3uV8tC4eF8vHB3ReatipNYbu/yKD53jVcsJxE5EBrlJjTSI5gTGy+VChbUmmpmLQXC9ab24gzPI+j5D+h0HbKnid1g/l03/2v6h/CdU7/gu5IWE+ufqI46MSE7I1Zy1JxHxrIAmGzjQRUaQy8sItzgnvjDmnb6rmfT8ecFjfnYlOf+AXnbFVcgba/Q5SqsaXE4sCoHIg1vMaHmHTAtsYt0FFZLvLiE8KUs/UHNzWwl1C+1Yz7mWKtRpf4f48FawJ+9Li/qtVHAgZNROLpTMJfN9KrcnGDihVb4/nnGjD3JozbfPfC+MKy9+Hvgu0EsAGy06MBNupIr7D0b/omebmYTiuOb+ZRO8dPfwV/lLwdu37ZU80g7iDbQUor19GBHTRzC+nOCxRSP9/rni1TQfN9cfAK4ur/TdTX+41/nl7eaQXqJ9WHlr18XpCZcg8y/Oa2C3Bzml1bUBns4wdZuAjlroq6uNunRSJ0nk5WC50DwseW/CeYaCYgr5FyzQrdR/jOa2bl3W/bVXzRWB5xd1Zobh1Bcqx4Sbi6S/2YkZn509/n3bSK8EIDYZX6yjaI+beaK7XnLosBIwAHDLU3CGKrnErkowzjG13DRddS7XCR5zcntAPL8PnbQBmRAuOT/NWI36u2Kdx9cNmr0Y4DajpklPFjrJyh7cUZte6pM1HZb+BReUL5e3iSU3howAzKrkxHhhKmHw/K8VzDCOyL6HsLtnxZIiakPIB+1Y/pOPjirAhoVeJXd93CMzqiz27VKKaqwyIl+EG9uCOtjTqKDg9GCtWRI0RzTu+WHgC/18KeLGgH4J6mGtmJGnASPya3mFd6+a23hk7VixdQvLWO2YwKkoxZrYCgmBQsNsCO5xP0+rSVcjO1lhXPPeiPGxIMbT/uqHVtAgm+5sz0YZG1t
 KZabFkFV
 JHpZrqY41/k3wOdqdGPGZucFUnfr0zbju/IOfSqByqPK128PbLRy6jqx5BhPMTCmWLjfNUjtH+UwcIRwezFGx8z4JIxYcS8EgkMPwxuA0JBOn43QzSstwIwObL2MAiRzRggFwM0mUVcehPVuaSyXEa/vJR4GtppT4rwTfUOg0pzJ6tEpKSF9up8HarHPdWdHABjidCPXv/S9159KeJ1es7ADW7TExqIMbvTij6bV79drX7+DKmChp1qVOKrz21Dk5vCtsBnl9kL01aiC0xNSbUUXwQqWJDCybdrCCxU7cKQpW0N8Sz935SLMMAoUKBOaa2wLEp8TuEAmekRUwXS7+luK4lExcXudOwDKDBWDzGzAOv40bzV8wMy8gjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 14-10-25 12:56:06, Jiayuan Chen wrote:
> October 14, 2025 at 17:33, "Michal Hocko" <mhocko@suse.com mailto:mhocko@suse.com?to=%22Michal%20Hocko%22%20%3Cmhocko%40suse.com%3E > wrote:
> 
> 
> > 
> > On Tue 14-10-25 16:18:49, Jiayuan Chen wrote:
> > 
> > > 
> > > We can set memory.low for cgroups as a soft protection limit. When the
> > >  kernel cannot reclaim any pages from other cgroups, it retries reclaim
> > >  while ignoring the memory.low protection of the skipped cgroups.
> > >  
> > >  Currently, this retry logic only works in direct reclaim path, but is
> > >  missing in the kswapd asynchronous reclaim. Typically, a cgroup may
> > >  contain some cold pages that could be reclaimed even when memory.low is
> > >  set.
> > >  
> > >  This change adds retry logic to kswapd: if the first reclaim attempt fails
> > >  to reclaim any pages and some cgroups were skipped due to memory.low
> > >  protection, kswapd will perform a second reclaim pass ignoring memory.low
> > >  restrictions.
> > >  
> > >  This ensures more consistent reclaim behavior between direct reclaim and
> > >  kswapd. By allowing kswapd to reclaim more proactively from protected
> > >  cgroups under global memory pressure, this optimization can help reduce
> > >  the occurrence of direct reclaim, which is more disruptive to application
> > >  performance.
> > > 
> > Could you describe the problem you are trying to address in more details
> > please? Because your patch is significantly changing the behavior of the
> > low limit. I would even go as far as say it breaks its expecations
> > because low limit should provide a certain level of protection and
> > your patch would allow kswapd to reclaim from those cgroups much sooner
> > now. If this is really needed then we need much more detailed
> > justification and also evaluation how that influences existing users.
> > 
> 
> 
> Thanks Michal, let me explain the issue I encountered:
> 
> 1. When kswapd is triggered and there's no reclaimable memory (sc.nr_reclaimed == 0),
> this causes kswapd_failures counter to continuously accumulate until it reaches
> MAX_RECLAIM_RETRIES. This makes the kswapd thread stop running until a direct memory
> reclaim is triggered.

While the definition of low limit is rather vague:
        Best-effort memory protection.  If the memory usage of a
        cgroup is within its effective low boundary, the cgroup's
        memory won't be reclaimed unless there is no reclaimable
        memory available in unprotected cgroups.
        Above the effective low boundary (or
        effective min boundary if it is higher), pages are reclaimed
        proportionally to the overage, reducing reclaim pressure for
        smaller overages.
which doesn't explicitly rule out reclaim from the kswapd context but
historically we relied on the direct reclaim to detect the "no
reclaimable memory" situation as it is much easier to achieve in that
context. Also you do not really explain why backing off kswapd when all
the reclaimable memory is low limit protected is bad.

> 2. We observed a phenomenon where kswapd is triggered by watermark_boost rather
> than by actual memory watermarks being insufficient. For boost-triggered
> reclamation, the maximum priority can only be DEF_PRIORITY - 2, making memory
> reclamation more difficult compared to when priority is 1.

Do I get it right that you would like to break low limits on
watermark_boost reclaim? I am not sure I follow your priority argument.

-- 
Michal Hocko
SUSE Labs

