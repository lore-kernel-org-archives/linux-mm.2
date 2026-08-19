Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D2A1C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD80B6B009B; Wed, 19 Aug 2026 03:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88366B00A4; Wed, 19 Aug 2026 03:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC4936B00A5; Wed, 19 Aug 2026 03:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC9A66B009B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:02:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E4741A04A1
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:02:25 +0000 (UTC)
X-FDA: 85117125450.22.532AD65
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id 69D1740003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:02:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=c7x7+LxZ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787122943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKZ7k5xuvKelkXAPGEl7SiL7VHybzzQJ3aLjy7GPMSg=;
	b=X2JYuJNr+zUpNwGoi9Ad02PiiLSVNG0Jn3YbM2eGDQLN7TtYK1EY5w4ayk1dR43kANXOLf
	A7Y69njgK7HanvyGJ7fZIgQoohTs1Qsd+Aq0xUx62FocCopENMhHkbhJHAQvKUJ9ChmIFA
	DLBCrCav+kJryY0R9PkryoY/ADBf5lQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=c7x7+LxZ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787122943;
	b=v9fQsRzBz7evPUEF9+tX+TFaFd78sPLKlZABrKBVwkvkT56iLcirtWF2WJa5LQiwDiG5LP
	tlyBMo4EJODAwnEtCNebCmW34pUqH5Wgqsrvk5qQ0OprYfaBmvRT1CbBNznMbNtUOyb0Pc
	BgzvQMd+nI30jcnP3+UlkB7iZrZQtwA=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47f3b39f2a1so515768f8f.2
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787122942; x=1787727742; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DKZ7k5xuvKelkXAPGEl7SiL7VHybzzQJ3aLjy7GPMSg=;
        b=c7x7+LxZ9aYgsv5FuDdzro5EaiqSvUPZSuPLDyiL9BTd3ZVoiov/mnIR6H2YRWuopB
         HKpVuNuYLA9Y4HfGhCPLzZ0flNgYY3wdV2gvwrfO0M3rwrSsollUuIDWgJ63uYS4j6ms
         +NDFhjCaPBepxBHeYYIRKcWJPVN/4IjpNooOxdOzGich9DJAmr1PhgSDeiwI52TMHDR6
         7eB32T7dAksxPXya8zHHUc9VVOMune9wRP8//QKL3dEkSgm765CxZJ7fZMCzlMlAN9sX
         zUh7Y1faaAeR2/J2Ug8CKFI8TM/Vybzy2aC8zOiwvf442hwUyRCarFqMXl0dWPX02C5J
         GJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787122942; x=1787727742;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DKZ7k5xuvKelkXAPGEl7SiL7VHybzzQJ3aLjy7GPMSg=;
        b=U8eI8MnlFUl5pqTfjpN1Y+aKk4cdSxhboD3pfamVkcshD09IIacWtgF9HtUbLETJPh
         08y9A16akqNQgt2BvyabpI4MaJaYi/N5pILWnjVG8ax4C5V3Hs9EdeCOri8rgRX1jB6m
         wEJNrwwkfPdeMmx9tEGc/lISyhz+DujugIp0dg0W4W6TxZax8Rq0vTBI5t8K89Qf/D+N
         T9TgAd00Z4u5My+A3sz6O4OpwyvJ7KCUNAhssfIoaQv+XEUvMOfe/IpWd+PV3rIALOob
         kHUiNijCYI33WXcE1dLnmWiBq+nEvJXGpapgGYnGGFZsSdKqGWIvhnEFTA92zW8cEKXa
         33hQ==
X-Forwarded-Encrypted: i=1; AHgh+RpsQlD3HNtNRg6SL7nXfGvLYikqR6x7OdkVUhepJT8gg6lkjIpBnijgbioDPkkPVuYERUj98eZxQg==@kvack.org
X-Gm-Message-State: AOJu0YyrBTc4c3U9yVw2OBSWn5ZLt6HHP1HHRuLqAgoafuu4aWjO64Bu
	TmHZIcMvauXR1DMc8v5Ls+zZfj1eRG6lxUgw4hFHwLFnPW7sC3hD31QStF1Dq9AcvRM=
X-Gm-Gg: AR+sD13f1chCNEPp7ShlDeC4DGPzX1vMiaIyKKCXJrwzFGhq2eD8nfvyticDMq0gokw
	3utVJuB7vdlWqpHhD35IXh/wkEM7Q++/zZ4Pb7+M0+hurC/Yip3pYxXK4W+18M4iXIiSLFJCqc1
	Ed6vmZFr+vxgevZSQ5lS3ZDZeEqgM+QZJx4+Hsg3ldJRTKKs5eLmRz0wLtJG0UNUeozmD4lnHP/
	zAqwvHFy6w/ZgwoNef/et00JxayuiTynXprbdY1trRpLJlOtckMie/IxwqWpOJ/3LjHOiln9ltQ
	tuVlD2Un2jVXItcvx8A5+Gkan8p8rGVrRRDOVezEE/jVFpsb5t48RC85VxiuZHpJqYise2flqfi
	tbwJGrHCxZWXxoPy6xUemUPFx28dpH/CMeqFJXoLIH8hc8BvEo4Hc9k8eyApHhyGrMDVVoBkYYU
	keYJSToBwTB1AA6s+qKTmXk/6wfZgf9PfmI82ee9sNT/sLipcRdlFwO9CBYOZG+1KEdFYKz4xXQ
	A==
X-Received: by 2002:a05:600c:37c6:b0:499:8f9f:e9ee with SMTP id 5b1f17b1804b1-499aa173a16mr44660575e9.7.1787122942071;
        Wed, 19 Aug 2026 00:02:22 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa0fd7a9sm51540595e9.2.2026.08.19.00.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 00:02:21 -0700 (PDT)
Date: Wed, 19 Aug 2026 09:02:20 +0200
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joy Chaoyue Xiong <joyxiong@yahoo.com>
Subject: Re: [PATCH] memcg: trim the per-cpu charge stock instead of draining
 it
Message-ID: <aoVU_OV777Xgascf@tiehlicka>
References: <aoQt2zKsQT-rvjd6@tiehlicka>
 <20260819041747.1111965-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819041747.1111965-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 69D1740003
X-Rspamd-Server: rspam07
X-Stat-Signature: m7m3i7cohzo4jt47grmjgujdo5d4bzst
X-HE-Tag: 1787122943-81493
X-HE-Meta: U2FsdGVkX1+jMR2k/CimyId87wQoiFXs5E562tGu8aF3Gwos7DUZsOWCeH9IYpIHbGJcKUiyXxAQWxtPfJGQQm8jHM7J8kuZrKRZEsM15+pM0kUaKcyU151hSYs1AZNfVhKYsl2AxtNYu/ZfQljQ52iAbhwISCjpK9NYciFpQK88iJ4FRNqirKyQLK1j7SaWqqI3dGXghGX296StFDkeTkOQY1JrDgEoLuulIi2p8Q/rGbHBJ0N8SV8do3InfGdg/irXAUlTDE9bXO5i+0eJvF0g5ddCMQAgfaJSQYe9lHw0zGqOIg3CsZYlVIAYM1YrCdRHkbGGSyHvsx1viUJhfLHiizCspbB9ERWc6xelac3OdG3MCcNNoCgY8jSREQ+aIeTeKM2AccXFwl6HSkmLjJHH0alIrSHstMZGf7c3U1EfxXsa+HhNsu2X6WwBPA2Z/w9MpB+tOHXrFXZZ+0+Ar8uzIazhBUXJiq2p9/Cnsu4nUdxRbSLOvSqQHDCUSlyoXS6uCX6aIEM+7vZiJN01HCT6XzLF1aYDBvA+O1XqDcLdHhLGM/vxvRrEFTc90WUSZd7FSS2lfrabkVtuoGyfx46YXqpIPHc9JEgAZRCeFOgdHdpSWh4hbaJPvLojz/yfuSyV7nP6onB1xCkuXS2NPm4siDE+uRm2ta3xNxKXpcuElZHS4UDk2dg8Y9txZAFl0dT+w7rXomchH+PkjEestFIVrsj6aXyjwvIofNPHoIJF7ypDhyRuWkfn1ngNqN6+eZzBChpH6nXn4VAi5KNU9cnBigtWoOE757KvxoPSZND6U8tbxT1yMfmL15Anyf85eB4WAFK3k2ABpGQNwnJ7ugkhyI4fCZAoWY4/hQSzbpSUsAuDguAOpbX62HPOnKYx1vrjoX4BYtYNzmFjnxlOnrCTDWEKkdP9sGItVAH+N3s4dXgBY5J0bU1gUncHM6cYA+Dz8hyaz2ICxvq4Cm/
 zSbwSuzo
 cw0KwskZdUIX/Iin7/c0PfZrniPImAY5raPjG/wKjA+M9hWSK/ERU9nZAzgz6GHEscp8zEXWE2Tq4aw1/Fa9uymxgdACadXfZjVt/zSmyK0FZVQFAdHDkNaITqitBFzx2iBnifAf0RhzTVdwZqvPS4Bz2XmubaqchQ1bimkPOqUR5ZVa+dMdFHBmFC6/3v0nUd71xUB1lEyMms17aHSr3ZEnfw0s055aFO93+hC5k3P/cw2AM6BdwiB8HMuAalvO9qZGDAPDbfSNwrx7t7GW+o49bY7B2NWAYg2vTdjA2abrT5HvL73OzIEbPtLag570UM2mcfdg2X4kk40O0mGSt/1oxG9CLChNf919Mh/SHQGDVa5ZNU7qDhY+kCd53AFqJgOSgNi04IHT6wFBG24iUD3HjUk+pPtlLDsLZYrEvYw+erO2TgnCm4pYE1ND2EIPk5i8MTUxsuDr6SkN0ewPji8p4su5xffZVAT7ERw441r1oTq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 18-08-26 21:17:46, Joshua Hahn wrote:
> On Tue, 18 Aug 2026 12:03:07 +0200 Michal Hocko <mhocko@suse.com> wrote:
> > The idea is sound. I would just not increase the overall stock size in
> > the same patch. Fine tuning can be done independently and ideally with
> > some numbers.
> > Would it make sense to start with MEMCG_STOCK_HIGH := MEMCG_CHARGE_BATCH 
> > and  MEMCG_CHARGE_BATCH := MEMCG_CHARGE_BATCH / 2. That would preserve
> > the maximum stock size while preventing all or nothing behavior which is
> > indeed suboptimal and pushing charging path to a slower path way too
> > aggressively.
> 
> I like this idea and I think you meant { MEMCG_CHARGE_LOW :=
> MEMCG_CHARGE_BATCH / 2 } right?

Correct. Wrong auto-completion on my end.
-- 
Michal Hocko
SUSE Labs

