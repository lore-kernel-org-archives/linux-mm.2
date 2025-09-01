Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C62DCCA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1004E8E0008; Mon,  1 Sep 2025 09:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1238E0006; Mon,  1 Sep 2025 09:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1B48E0008; Mon,  1 Sep 2025 09:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D82BD8E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:58:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99FA91A087B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:58:28 +0000 (UTC)
X-FDA: 83840836296.18.7FABAA8
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9DDAE140006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:58:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cCT885LL;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756735106; a=rsa-sha256;
	cv=none;
	b=V+xL+NWc5Pj0kDyzVZYptT2iZ9AFr7gpMsPDP4pd+C7AL42sGQvpi0Ec4b9A3Df3qmfDZ9
	gDcGNOl5uSjYVqgzhzQHwL5qqAHtGFan1ykB7LPP7PAQ7ppFGS7DPdnzcFfMZ2D3I5QW1R
	P6535Ea6sYFGoQ2PNIjjipoV6q7Vk2Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cCT885LL;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756735106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ueYdCbMLexoztimExa3457paCNKQkUYPulx+AE/Qd40=;
	b=tb4E1hvDQdDd1Dy+aqodIVLbzqT7Y9aTxKlK+pepr0HzukF00MzA6Xq+/FquKNPmaLGqW/
	2R18KgiakjuP0W/+xswRFqIBa5cqZM1uqhqYLtxYxGS0pWV46WN2G+Y7lrwQCNQ3OZGBtm
	/Frx32v3WL8CUPjhDtPM08WqZgwEbYg=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3d4dcf3863dso913601f8f.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756735105; x=1757339905; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ueYdCbMLexoztimExa3457paCNKQkUYPulx+AE/Qd40=;
        b=cCT885LLM9JqKyJRtIHZBMiPRLWRVJc3OVEHYIw3tUNu5Oxv7Jqd2GXeviAm8Uu1YI
         62tzy3rWSZam46OVNvwOXuJ4+hjZuuRF98kY3cZSJSAk0Tae91jhA95A0jmhQwmZImDX
         cuy3bicxCfOlMko/jk/rrN4OwP2v6QsbTs5jRl2UnJKhFL0jEVrxfeUB5DNVHDJFVAT3
         QvDXPi9lT8XuQubjOz13wMwtGONU3S5OrWai2u9+5z8MQvz43T0bMGICM7EAtKeKinCx
         v3ckQyEPk3vtCISXQ+R/mvCzh7hzICXSEzYvChB8fPTcu+mEMOLsUcmxY1Fi/9sZaVZA
         P7WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756735105; x=1757339905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ueYdCbMLexoztimExa3457paCNKQkUYPulx+AE/Qd40=;
        b=pNKRtT0PlfkxC1fLT9/zZbCpVSqLcGqtg49eBaoT6rcPijMunuj4+NGtlb3o/+/wQo
         vtnpZrBShKh+daUJtTaycoghmMjrFRBh5fgBkJJzA0XBSXqmxpoytsVDZrUaMqIEYQ5n
         TgWYm3nbjApDz4snEwEkq1VfbACpMcfWM6b+yu06Otu//G+pI0JrFd56b8rpXaSfB3C6
         orPtBGDVIiZi18iDcyFoobxELX80SdDCbWPD+BuEyYWt/MZefYmNQ7uqFc9tIvcjlimZ
         B8at1KgiHM57PsJ5EK4hhPqU4gfO+yrHfepJ0OkrU+qmsKqT4+s1ZBLqdgsAPDAECx4T
         FlcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVT0wyXqBUCYIeRIk9JEI1PF5NzOWZyiBfRQpsuuhdC8nO7g9BmStWvc34EmQg3n5Ayq+3Y9o/mMg==@kvack.org
X-Gm-Message-State: AOJu0YyCrcCMNEQK15JB/MQoIgmUnUL14SSZ4qSZLZo49kAKZwpvMtNR
	I0/ZRCTIBoXIo7ItReYfCsk7U5tk5YKmYf/n8WeTZxyuAl6PB80F/1Oe0Ko63QTFJew=
X-Gm-Gg: ASbGncvXwvtcHIk+vJFUWeom3VoKOKFb6rVT41SFUk+7QSCZiN9oo/GJITj9CkxBXgS
	9axEC5KsuYBeaFnNJ0vOYHRQwOuCeoIoHna9+Nz7LQhe5dg98/5YPopQexenB9T1U3q4yly4YfO
	l17QGiQtUiQiIEUwX/T87pwikaXRkJwSN0I7aSqMf7V4rldfmdPfDEMARGH6IKILCHKdSrC6OOW
	vphbEaJU851bsWkZL7kNO1AVAbTkanKnWiU6bBQ4zqvE38wTcb3m63B6oDozbFNZ1Dhjepx9Tfw
	Avfu6x0HT70On6JTAudC3x+Ht1ho8TOMs6ZG8bDMq940a+KCze8/MULnoI+OjfQw871x8ntX9KK
	X5H0Wkt15q1k5CC4PTBym/Wb18SyK/3+BGMc=
X-Google-Smtp-Source: AGHT+IG2Yr2jjXAkZHUpidJxihTiVMsaYn3d05/QQCYWt2Zb9lpyUMvnPQCYNVDURtcLZR4iIeq9Rg==
X-Received: by 2002:a05:6000:2c04:b0:3d1:61f0:d253 with SMTP id ffacd0b85a97d-3d1df828682mr7655133f8f.60.1756735104898;
        Mon, 01 Sep 2025 06:58:24 -0700 (PDT)
Received: from localhost (109-81-86-254.rct.o2.cz. [109.81.86.254])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3cf274dde69sm15435253f8f.14.2025.09.01.06.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 06:58:24 -0700 (PDT)
Date: Mon, 1 Sep 2025 15:58:23 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: akpm@linux-foundation.org, feng.han@honor.com, fengbaopeng@honor.com,
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, liulu.liu@honor.com, lorenzo.stoakes@oracle.com,
	rientjes@google.com, shakeel.butt@linux.dev, surenb@google.com,
	tglx@linutronix.de, tianxiaobin@honor.com
Subject: Re: [PATCH v6 1/2] mm/oom_kill: Do not delay oom reaper when the
 victim is frozen
Message-ID: <aLWmf6qZHTA0hMpU@tiehlicka>
References: <aLVKYz6C5bXYG1v3@tiehlicka>
 <20250901093057.27056-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901093057.27056-1-zhongjinji@honor.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9DDAE140006
X-Stat-Signature: n5wcdn1rdrahrmbsrusmxbpjgtoxi49e
X-Rspam-User: 
X-HE-Tag: 1756735106-566340
X-HE-Meta: U2FsdGVkX1/ZStb9FVdpMXSMPKbSnCH2kUZWirrwRwHP5GhjhY82OOZBa7uJI4mzyFQHUqSbnDIG8DqpVQOFVrLrbXF7cgLkUHy9YKK61ARHPvQEoH3drtPKCrwzp6Ll89ev0/2j/kvaj0jHqNbGdE0GP1WZk+cQkjhcEc5IR0E5qKrLpNZrBKgjYRHjEa9JAz2GpPOYV86hkNScHgDmB+0rdIHEIhsJfspbbIBWpMWgFw5vbKvD+Hl9PFI5C9tvOKtLGbqRGVAehddLlAAJPfkFJdovdODqXwK746un+SBW5LgzCvFaj4NtjnL/jdAPjmO8CvrVdVBdgEcWWTsWky6iocRKnXpH7hXo7U3qHMMKfJPYb7S1WRdqEvBbl1uE7Duh+e1lKg1P+ktOc0Jh/LxTvKd8yAX5UoIiWH8WZksUpadi54gEiE/PgCme5dn3kefjy1g1O8VEavrKgtP+VYOn/p9YKBrdPwyOa4ePgVJ9ddZDfrQLJZHu7p3j1QkX0VG6dHLZY/nTArD8K17fcXBDfARjFpgL702FlHM0i3mbAZFuitOeTa1qsR+lqLit435EjeYPrZPuaf+dmQeZ/NtEUgRYZ8ZHlyQvr90bOdcltVky89gDrumD1677XbOZmSTxbyQOqdQwTXUeF9nUptk9yd9WWjmi0vEzgonuYq7bbgMqm6k0d5aOk/E6tR8aETW+OQQHVKamNj+M4vjNwK3kIe739vt82L1ts/swJ64ofI0pCmru+6QZJeWb3DyHtaqFjktetMp+188Rz1H8D0fHnPPElLt4laYWojP0VNP3ydTAdxlhKVjVnnHxMa63LVtKHJGdCsXnT/eGb4FbwB+WppVbkJlX6I6mXGb+OFcpl8dUVFwEl7ocPiHNvCuv6MHlazmqouqGEwYLiIcN82ji5TwMuoc7GML2CH8oFnyhUhp4d0gomyqJBIsazA/Ca4jRGMwyB7Ar5Sqq9hW
 u+9dhFVL
 QLg+tFh/4baXlafSZ3VdNVkJ6AZUhSXTYs2CVWgvJO3bebPh0nsEd6IfGZDEGYiKzQg4ifY09rZiJwGVCVFgJmjhNSnudPcEHOnzggU15+NXnMsfzUlFpcnk5Ys7oUmHR7Gpfi3CApEROqKcmsGPJOneHCdQNCUnKv/n1/HbbPR0fDXRbNJuk1qFYKDVkvnefmmJJaunqioJg0q7kz7egNuWVuImcJtN/8Gl1stFfzr9QRxmhs5C9YP9iAAensQ2QYr/i3Z1J+ygN3h6SIQ6k7W/pqGawFS7bcFJMnGnTtQH0YSwQ4cOS/s2xPvzLMDZMl98gDgb0EaxtzFildjWQI1GbxLp6j1rG9rOOK9PwCwsLq9KerRxm5riqGMvQylGtNLFuSWs+wzvZk+XM6HZvKJIX0fY2AlgO0vUMb0wyLDAcyzRlw3ndpT2f4TKZKGEY7tKxfntErDJpXahW6qzrXTAEnp3CJMU95ZYJN7RKxFL+aptfvcppDZYceAP7KjtckdXwxcasVr47/Tr5DJ26SDGPaVj8jMVQ6ur4MghEzkUrjWaYYDLBa/qS/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 01-09-25 17:30:57, zhongjinji wrote:
> > On Fri 29-08-25 14:55:49, zhongjinji wrote:
> > > The oom reaper is a mechanism to guarantee a forward process during OOM
> > > situation when the oom victim cannot terminate on its own (e.g. being
> > > blocked in uninterruptible state or frozen by cgroup freezer). In order
> > > to give the victim some time to terminate properly the oom reaper is
> > > delayed in its invocation. This is particularly beneficial when the oom
> > > victim is holding robust futex resources as the anonymous memory tear
> > > down can break those. [1]
> > > 
> > > On the other hand deliberately frozen tasks by the freezer cgroup will
> > > not wake up until they are thawed in the userspace and delay is
> > > effectively pointless. Therefore opt out from the delay for cgroup
> > > frozen oom victims.
> > > 
> > > Reference:
> > > [1] https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u
> > > 
> > > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> > 
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > Thanks
> 
> Sorry, I found that it doesn't work now (because I previously tested it by
> simulating OOM, which made testing easier but also caused the mistake. I will
> re-run the new test). Calling __thaw_task in mark_oom_victim will change the
> victim's state to running. However, other threads are still in the frozen state,
> so the process still can't exit. We should update it again by moving __thaw_task
> to after frozen (this way, executing __thaw_task and frozen in the same function
> looks more reasonable). Since mark_oom_victim and queue_oom_reaper always appear
> in pairs, this won't introduce any risky changes.

Hmm, I must have completely forgot that we are actually thawing the
frozen task! That means that the actual argument for not delaying the
oom reaper doesn't hold.
Now I do see why the existing implementation doesn't really work as you
would expect though. Is there any reason why we are not thawing the
whole process group? I guess I just didn't realize that __thaw_task is
per thread rather than per process back then when I have introduced it.
Because thread specific behavior makes very little sense to me TBH.
So rather than plaing with __thaw_task placement which doesn't really
make much sense wrt to delaying the reaper we should look into that
part.

Sorry, I should have realized earlier when proposing that.

-- 
Michal Hocko
SUSE Labs

