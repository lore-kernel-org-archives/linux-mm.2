Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85ECDC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA6E6B008C; Fri, 21 Aug 2026 05:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1A76B0092; Fri, 21 Aug 2026 05:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7D96B0095; Fri, 21 Aug 2026 05:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24DEE6B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:21:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8C001203C3
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:21:37 +0000 (UTC)
X-FDA: 85124733834.15.3B800E1
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C11B180003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:21:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IcMgJufO;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787304095;
	b=8pXVAgItBMwBsnj3C40hKIrcG85KkNlXJhkVpr36xy7tbrcAlfv9h2XOex2Hr0LC8A+hpp
	MsTK0O7f7NRFYvm+0FeXyn9kerPind5bj0VQM9HmAsEty2dgQtfX1+v5NRQrr0itBhNWLF
	XREhDGXYdlLfjiWdKNT8gZi/yJQfUgE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IcMgJufO;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787304095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6n6jOb/zWKy+uFuqnOpxvnr4nj6Kewh54Ypx9tbGovo=;
	b=YUFVXk/Bol0Ov0oXP+/rFyTI9KDXUy/gf2KMntxb++90WJTmqR20CzlSrWpRD13GKB7h4B
	mQH6Vxi12xrwLJWfsGWU+Vc4SeC+IbTPqew1vStqKtcSbh5y9u52NcPOIvi1BCFJvH0pIX
	uSbJor2MLP29Ukj0953MkdcwYGn2oq8=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c197eaaab00so131731066b.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787304094; x=1787908894; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6n6jOb/zWKy+uFuqnOpxvnr4nj6Kewh54Ypx9tbGovo=;
        b=IcMgJufO+YL78dy/nCfgxua4gJNqg3xqQ4XfQSYOb9G7QRq8E8+OlH/DcKghIJi/6/
         TrsU4ZnoMF0g1wBQ+xhE/7forqqmY+uBXsq9hvVBf7g6k9JlSRxJwb4yQI6f9LmT9LAT
         ZD2aPoG3GFSY/6c/4sBgjUw74QZzfWpa/q8b24ngL9M3IWUO0Zw3xvDhf+evwgKyOc9J
         3rCNH7mMSnl4d4fbMUYnZDAh0DNYgmTJU34ztutDNqtdQly5+SdkVJWpdbWTEqAMQkFN
         ZwN+STtfN+7k/Z0H+OGAYTj53h3tT1Z/sguwU3c6PmBhUbqTiq6tLYKW7VY2T35ZNMVY
         WETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787304094; x=1787908894;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6n6jOb/zWKy+uFuqnOpxvnr4nj6Kewh54Ypx9tbGovo=;
        b=eze4ViZqcDO8OCeiimFh6IhZZuXzIar9W7nHrBqb7Z8b++eK9RV2KVETj+lJjZQl1S
         Ttdc10lM4sQXULVXe5tZSU0141Kq+10HcM8IuOzNo1BT7JeiGk58TtBnr5Kt9mWbYTmI
         cklm9fZwz21huhHUsj6pEFZLtnbs0u7Pl/QJNNrS3echpQgnN/648O9I7l+VyU6pWtRn
         9k9iP7xR2U6rWBKJmzBph4RXBwAEOP1B78lZWpJwXAD6a96t4MHaQEhLPdhOZMKx8xpe
         FOUAseXbCSBT/Cu7vys4LYD8t8kya8Ty+udAoZtJZTQiNuuxXmLBWuA1PdnwCmLazY+j
         QfMw==
X-Forwarded-Encrypted: i=1; AHgh+RqWjfQ6uHR02IQ5Ynu5J5qBgA8MC/hoT0ZsMCC8T5jfwwwc/n5xCInezEU29xvjihL4SMmRLIUsCw==@kvack.org
X-Gm-Message-State: AFuF++ldjhm/3g7HMyHW6ZxzAQQ0Z/JTTEKSSRAn/4+DcisQrRT9SZ4B
	Z7FFP6wbqsKQs1Jlb98PyUjfzrN/1BwXyfFrhDG8kBnRLYZXT0CQOMUgZ9DIXZPIMno=
X-Gm-Gg: AR+sD11J8CALbFPvWpnf46ZL6QD7RMDs/EKOO5suyD9/6Gxs7qNfaWaBaB/qKCgFKv4
	B2xiDAs3NSEWfcTYQfskcOBYldvjt8KODppcAhXKUa1pnIk6noeFcW+aXm57aVXRU6dnqXWauQL
	WNrJ1SISu81rmB9nok2lXIQabQsuxhhYyjODSQYMFD/6bM3LaGAAgWY3Iw9dF9JIc7k4El33cMP
	JDlV0ZSl+jW4hukhcg2er9eg1NQAE2X5XAJ/mguyp8jZjV6cnMvajMFxUTngDA58uCnLBHmVnFj
	saBxSN57QvhnrUwMR95sgo1S7oXeegvbUYI79U0PObCpM+0i26L3mo+zojlllkLmPLhtWN4M/lw
	C1PQx4Ky22ZSfl/JsND+PbzIJCzFz0qbU12Isvq9nQCwW7gm3zQLnF8u9WlUX8qH1N8gyMHrHs1
	kQH4/o4lp7m9RiHbhH4btr5mws+RTCdlgCNkGDIgvbN3PNxgU5yuhgeUT0hB8YoyiIezoEMeIDY
	A==
X-Received: by 2002:a17:907:3d56:b0:c1f:e9d6:2a6f with SMTP id a640c23a62f3a-c2469f9991dmr528416666b.0.1787304093460;
        Fri, 21 Aug 2026 02:21:33 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2459223af1sm385166566b.58.2026.08.21.02.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 02:21:33 -0700 (PDT)
Date: Fri, 21 Aug 2026 11:21:31 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Message-ID: <aogYm0fKNsYVyBM8@tiehlicka>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka>
 <aogQ6iDA7RkuTtDG@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aogQ6iDA7RkuTtDG@gremlin>
X-Rspamd-Queue-Id: 8C11B180003
X-Rspam-User: 
X-Stat-Signature: cwh13d411gwefx3pubpu71zmzcfq53ax
X-Rspamd-Server: rspam06
X-HE-Tag: 1787304095-106433
X-HE-Meta: U2FsdGVkX19wJgjHIUSwzucl46FRJpqe4XNRIs6VCjwPeacogWWE32RFufA3R/r2cqalBMy2ZaWLY7DvTk+c+z/l+wBVUKMwJFiAItPyxQ/3OQCwAmFJ7daynbF4uBOxUW3D9oBPXfxgeZ1h6zylnGoni3fZYqZpBEw9lCW8h45oulfrYPDusNSYxguhkbXPmoERcTBRFfD+fLp555nVQevbda098j+8R+nfjoOmPbJupn2OoOh5qExO/pg9YHl+p54IQMc7ILkV2gvm0X645Et+Ka1dLUqY695YdEngWX4GloIt0rERYeewt1dxUxvqZkrbHTVFnRbyhMtZ8wchvo7QtPRbVilgfjuStUNLizr4Gy+M/sS8u30rOTXTAINBR79pIB1ggkVmamF6ZOMF7jg9gYmD904fEwspR/mF5zrdsHOb4B+gCayzooj8UHR58cCYErnRAZSllHbNAUYmOFo8PBRqkC9t5gFkDyPfJ0rWw3dLlnbfeVbHvf6jJDCgQZ1EtA0YPmTTF6ygccTbj+7Zf9ZW31CDpYUB2+Xp0/PdZKzNqC7nv2E3h/yU28btOMCnRpG0ZXj/k2Md3OKRbdZbMmen3I4mwRnpKxLAb31zxuKYXfKMbjRxp6CBtXBXK6xlgz8ZwMSbkdGTa0H91RKjJAMqHgHnIfi2gdB13Sgp/1YyCz12chHvd8O/WcsomJecWGD6n6gHjMWOyJVKpad8ch9UWoSKtfBnrE8rb4zSTTW63MrvSTs0m5XzLqG3WHXGzU5uSunREKhYZC4GvXD24ggCt7IFsVKg1cPjoHf9A875hr7jZ5T78x3IngfWNLW0Yc6LNNQ+sQ424halVos8WlPGu27Vcjt6kHCFW8JthJIDsAHzvgWUIwIfGbZd1XWsF/vuIqeXV4Vwp8jCkv5YPqfKMQyQKHIY6sI5G2Ah1EtP+lqTCt2OtonqteCuybh85UBsvH7cdB3FULH
 zA3vd1N5
 zePMp1D/77d3vycHO4ixvZYxanVPyfGNS26C81W+jK5PnkaSUgwUDyJPNH2jed7IKtEt4makhsYbE4huQ5VJeW0zHalYp/s1DTH+2uEPoUhp2ZuDhU8lQD7cPgV301KROhxrOZGy7fDbcc8K8jr8KTcSXGcUixMS5MxFgE/fIoUHR64lJKreBT4QTTQMFHVKCxsOV9WC+KyP0JnF4UN20mLuqiYQ9FsN2iBQF1wf+i9IMBHo832KS48/o+i58ZcLiO0KXMaFQJTi2yrLGAZSMgsuW9LhFs5FRhI42b7DsDqCKlwnbT91+G1lAJHosl7xXz/wDQxYIIzgoBu9kVWzxbk+EvJYhmhHzesjVhL0Aml7BiYg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 21-08-26 09:58:52, Lorenzo Stoakes (ARM) wrote:
> +cc Roman for suggestion.
> 
> On Fri, Aug 21, 2026 at 10:31:06AM +0200, Michal Hocko wrote:
> > You are explaining what but missing the most important part _Why_ do we
> > need to have this addressed? Is this just addressing Sashiko review
> > refernced below? Is there any real usecase where the current behavior
> > matters?
> 
> This is exactly the issue with these 'unrelated to your patch but' suggestions
> from sashiko.
> 
> You end up in loops:
> 
>         AI generated patch --------------->  AI generated review
>                   ^                                  |
>                   |                                  |
>                   |                                  v
>                  AI generated 'unrelated to your patch but'
> 
> And _at every stage_ reviewers have to do _additional work_ (with ~50% signal/noise).
> 
> This isn't sustainable.
> 
> We already had _too much work_ prior to the slopgeddon. Now we have a multiple
> of that.
> 
> Roman - I really think we a way of switching off the 'unrelated to your patch
> but' stuff per-subsystem would be useful.
> 
> Maybe we could figure out a way of funnelling this stuff somewhere separately
> longer term.
> 
> (I have I think 2 slopped fixes to rewrite after the previous what like 7 or 8
> this cycle? So forgive the grumpiness :)

I wouldn't blame Sashiko on this really. Yes it points to a theoretical
problem. That is fine. But we should encourage people to not blindly
follow that lead and immediately jump at fixing something that is not a
real problem. Quite honestly I even haven't looked into patches until it
is clear that the usecase is sound. We should enforce this more and
leave patches lingering if they are not sufficiently justified.
-- 
Michal Hocko
SUSE Labs

