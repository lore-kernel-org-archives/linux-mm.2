Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34EB9C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 295A46B0093; Mon, 13 Jul 2026 07:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2467D6B0095; Mon, 13 Jul 2026 07:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15CB36B0096; Mon, 13 Jul 2026 07:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7A7E6B0093
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:39:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70519120113
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:39:58 +0000 (UTC)
X-FDA: 84983559276.16.93917EC
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 62DCCC0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:39:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qZYeojcs;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783942796;
	b=qxEl5k8/95h8S1bhj/IptRZ6bQBTFdi2LJZmb7yk4cbOJNbj1eAgYvuDSpaecou3Okp54L
	W1YHp7HQPljgJ45AeZuiDYMnflWw4D7wgAlrxYLxBTUs9xIuc0N9UIwVlX0pQZolo+1lPL
	eZmzmgUjwx7NyzfrI4xUPN9SLCJsOaE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qZYeojcs;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783942796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhEJSmb1zAc+1BJfU7rn0s0R4zfNHqR+TO6aCnEihGQ=;
	b=sVPwQgB+o/AkiWQhd58UbS7rSRVwpjuYo347NoW6lX3nP/af8m0pMPaZw1SGpMGn2V6Uaa
	f/9eZ0C1VJC1uVC5ZpVQ5u5XiCQtNoDYb9vo/++19Oa4dNK2y5fd3GdrHAOOFCD5Z+rRXs
	qV9e4Kyxbn8vDqBLQsl8wtGyT5kj/lc=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493f45e20cdso18254295e9.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783942795; x=1784547595; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uhEJSmb1zAc+1BJfU7rn0s0R4zfNHqR+TO6aCnEihGQ=;
        b=qZYeojcspurVOpcrmROJvNUlY8Z02n5vjHIRPisVwsnmFB04ELmGnqO8/vsJTLVeKc
         D17OY9yYgXfhQCx8Q4PvprANWud9vejKEci+rP1BCBGWnyreREpCsS6qyIg3Yhywvtcf
         1g0om9pid4clIyG3rl+aBYso9a17NzGTULC975epuI3RAQgxcCcrRx7cr6ZmsLdDZ4Tm
         6l67MgWNQ9QSW6XpB2ES7DekHs2HY7tSTRvyWjhh0HNHcUS79WP8usb483R4Y+Q5HTF8
         +oLvuaZIudnFwMPHn651/U0p7CGitv0b7BM+F7E06s1jZ6b4DrA0BhX7lBNXxojxAoGt
         Hwxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783942795; x=1784547595;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uhEJSmb1zAc+1BJfU7rn0s0R4zfNHqR+TO6aCnEihGQ=;
        b=rk2kqsQngU/wD48vNInYBlCcFCqjHeOuE+bEdN6h+myQrVoOBQlAf1LwvNCk+QnJ4G
         VW4o6Ai9/FGp5rMcVvwjqLPvJIO71NG2VU8yiAv8v0whZnWYcs5sfOF4avmawTjHZt3t
         yP1WGXMlUJldV5K+7MpqpfHemyjVhh43UlhwM27H3/UjjkWsBqWtTBSB0UqjR5CvOKkY
         7ojUj8hOoevDYIFTx2ap5PPu/ttpkKq3WeGnVmY1mOuXax7p86lzYS4HycxV9/T6IPp+
         7FuQxy+IW7LALT4+NzJMG2svTFuWK82Mx5F5VNneXMvfDMjIoMj2AcP5pH431SRBrCTO
         DMTg==
X-Forwarded-Encrypted: i=1; AHgh+RoQyPaGtsdduQJ9WlFErZUyrY+KncZ/bs+TLKT9to2om4cYQoCGi1W2eeaHNXB2ub8xUtwnEF1jLw==@kvack.org
X-Gm-Message-State: AOJu0Yw7RtN+AriO7pdxF6HjFD+KEALtS9BvH8pwsQvjYPKzk+6dgYVy
	W9A9P98z+6kN1PwkelLHMpRLOFG+O9SQbnJYo5orJ4akQ6AYJFDwmCROsv2CxS6DwEw=
X-Gm-Gg: AfdE7cmC77WopZIHLttDgkB+18XygOh8GYR5rk+gh/mOVsgdEj8f4ICuzq+G56uC+dj
	o8+E3pIp8xJFz6537+TF3JOB4NVZnQyVolDxiKh+hUuKq3TSFgjT3ICCsSlmJvgMxhKGWbIL5Kc
	hBf4qhFxOBDw0LWf746FwSjif0kKWK+mriFXTZ5ZJS9DS1pnqLrkx4WMdX89pJ45x1oL1p8DFxm
	O6vWJpx6RL2f+HpsscA4zLuzrr6vJmZc1w69jN8jItjCFpRLTPsR2KYFKBXWAiwSXcAuOk08mIc
	9jDMfSvsoy2TfTbuEv4G/LhlkwNEn+SajCuRaDjG1zheThs9kKznEspJspGb9xhITo2/lbS3afX
	kM3GcDkQWkK7GH1TiSXyP05nbrOBI9LUuCdqy+rtkmtCZw98xU8SeUg27aOgWjCQ1c00YY1ueOZ
	/Q/T7H1FiVrRnZEelkC13s
X-Received: by 2002:a05:600c:1992:b0:493:f261:d295 with SMTP id 5b1f17b1804b1-493f87d9886mr86244245e9.4.1783942795022;
        Mon, 13 Jul 2026 04:39:55 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6d5055sm355712995e9.5.2026.07.13.04.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 04:39:54 -0700 (PDT)
Date: Mon, 13 Jul 2026 07:39:53 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Stanislav Fort <stanislav.fort@aisle.com>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: account vmpressure event allocations
Message-ID: <20260713113953.GH276793@cmpxchg.org>
References: <20260713085520.2953121-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713085520.2953121-1-guopeng.zhang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 62DCCC0005
X-Stat-Signature: ztcqd17awx6nu6tkdgn3zwix56ymn719
X-HE-Tag: 1783942796-50576
X-HE-Meta: U2FsdGVkX19TlmWzFZ7vPPg+P9TsZj4gAYi19/c7Qe68nAS6ST2dFtTplRo3sdbx+FGtECCkFko3DLurMGpqiJ1U4DEFcNmIvaPfx/u9fMDfhV2pmY+wcA8mFIvLF9+CAl4gM0Lcu+1ZzDxUOVrXGAJ7JuhD0D+KgoSfM4almkhCk3t8+VFFTVtbOHsd1MAjjwywHxcU0Tx63VvwJwJCc/dYPJyxPXjpyAmV6fT+aGTz65DzFr/PELalfg5yNS207vzBXphHP3Cvfc82POBP/iIl8PJxJzOqbZpR0ENlll6ddde5jwB37YHJUgm3rDn7LuaRFXUKmCkajThaNeEHKFsgdhL1cM0G1pDHWUXfAEHNrmx8/aQraxMBWVx38koVTfDvknABPX2wY3nqcmhTB15mL/h+KIz2rAqNYJmG1HHEfXDFWc6iUGTO0hh8OhpIctHMhEqGkrExTxlHzC7EyMovlLSBszZTAS2uXSizOOh7rE/XTIbkuPsUVgWKKbkg7pJzobram84ggIdjeU50aJaZyjbHm13l2Ui1fGi9HF5ovWPVCKDBeTG7/nQfwk1wqPJLnNSnjb5TpTC2Bm18urgD4EsLWC3f6ovjUg+xoTL55eVl37w9ZmPxLvCdTbHCb0nu8CWhnA8l0L34blirdJ5nDQzHPQK3Q8KH2gl9NqgFdpGcMFte5bCHPJmvyHrXl2Mg23TSeOwYmR1Zc7xZ9KRV3WT2PSBgbvvdjzASrNKbF2T/FvG6lU0MtVni0SBYFOxSREnm1QmMDKefJXyxmqYeyxaiUVbd6QGRw3nxH2MPuwbN6gYnqGS1dSi/4fSTXMHRgRadffvpJJwmkP55gwLVTHdGrLIAvB4cqK0jJJANoBMlyZRmvwXxSL7yW9/9FC4aaCb1bnDNTrx3XggLXZ99npa1x3tJ0yRFtzVZH1p+ApNCcyqLEUyYgVhr6NU3CfZT8q/4sy0yKKQ9bA8
 sWmjNUf+
 2G3nse2x32jtW4S5NeYGv+QHMVOK1Ook8QiOfVpSMgDZ4bjKP1WMMzFpLpWz8ZixSrtixbWgrlhVmoa7TAFVmUrQero2dzGvGEqUAhjzpOefi1+EDUfnQ6vZtLcr6/UJMVd4ukvccMV5ukkV+63KmxQemngp2irk59BgcsgnpC6xaqZsG4711NR6UaeoGL+Sotxsys+Mqyx+rt0wF5ajfEUd/2hjEWW1cwanDYJEVCx2Nn/eNQsJnv+NfC8p8nfejlzfrU2/WQfCNPwSWqXB4k+QfG+szMuYzUt6LFyYIexnmfArGFwr11XAx+k6ZB9COGLpfmvRv62KH237qs+SxiJLhafWrZbonjagCwG5RKbd4s1A3gxq2KpfMJTY6+SGBo4CO3JmE8sidozxwVEQlQjme7+u0w9irRVF7XMind9j8Jz7wcOqAyXziP0AJxvtLHdLpmaMSpcSD4u4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 04:55:20PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 72797d218b43 ("mm/memcg: v1: account event registrations and drop
> world-writable cgroup.event_control") accounted cgroup v1 event
> registration allocations with GFP_KERNEL_ACCOUNT, but missed struct
> vmpressure_event.
> 
> Use GFP_KERNEL_ACCOUNT for this allocation as well.
> 
> Fixes: 72797d218b43 ("mm/memcg: v1: account event registrations and drop world-writable cgroup.event_control")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

I guess :)

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

