Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 179C7C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 19:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3A466B0088; Wed, 14 Oct 2026 15:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3506B008A; Wed, 14 Oct 2026 15:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1E16B008C; Wed, 14 Oct 2026 15:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B12B06B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:28:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA73B40765
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:28:02 +0000 (UTC)
X-FDA: 85322217204.29.8631EFE
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id AC9B640006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:28:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PB+YwfMy;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792006080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79ZQLVF6/awVfagux6X340wRycgEHKIlZJR5+alEZXw=;
	b=oqGVra43u9NQ8+QNkFJ9GwTdxCS5WdriWSFaQrAnCsYbHAexD8EyAHSMpuxxvI7jPgzQnU
	IvpFYn1iId2ay4cqmGKpvAWKNCHwxKJvv1sHQNgIRKAdiMsT0fhVIbJsAI9Rt1AgbXTFdH
	2a162oe/64wzpJYbG042pGod2HCA8to=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792006080;
	b=hPClzUIiiScRryDnuoKxcklhGCYMGVZZazvaJWb8L2XgK+z06m5hQxZe11kic0eTZN+nu3
	7WHcDpJyl3reZNbNxRRG99djz30c9bifHNJ24wCc0tnRoX+Uix98IZb9FSIbvhYi/b+nbu
	R3CpMGmmNGMRDzrWhfa6rPrBQQgoB5I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PB+YwfMy;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a021c809e3so43406485e9.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792006079; x=1792610879; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=79ZQLVF6/awVfagux6X340wRycgEHKIlZJR5+alEZXw=;
        b=PB+YwfMy1yS/OMUdobHuv1s7uWNv/TBsj4BX6ujEnVG2VpivLnC9ygn2XZ+JV+J+Xf
         lb3KAwzfhxnq/6AwylkEiz+UJicOwqkNzmiiGOhHNNj82t2IO3CbI22lorA7Fcmvhj9z
         hR1E2o11uQWyeO0PEqkFVkYwaH7IsxgjCaTUkW6bDZzs1wPwddiAAW/mhQO4yRdmHEF5
         i3oreI4WviV0Q7oXUqZgJl2b+n/hxIk3W/enssm8DzOMoNAcRTvjOTukW4QVSmAcuQtV
         x8XPfdbv8GFrWjmZSq7tyrJpqBelMQArOW46n+ccFORz+bTB966rRMI2POzwpcY+NDGy
         WwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792006079; x=1792610879;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=79ZQLVF6/awVfagux6X340wRycgEHKIlZJR5+alEZXw=;
        b=nTib761VMBGSIp6f+w/yduG2dVeMmLasuE3mq/Q6LQ5UuwvGzs4aZDm/k5rXsJG/03
         iFYk43yVI1rYL9WgjF2f0cxLraJggvrFJJ6G0271eRsv/M7s6plf+M5lX80fhfeOFGjv
         pGJQAVvBrIY39XCq4NnFYpBmrG9PlVLsdwAGnnNqiA9fScTs722EbNbuxtIHrRgRmL0O
         u0ScbQPdpX70MW7Cv3vfR79R5BEQPFHt0YKYtExaqizWVIO8LuzpFeH4dzqX7x7XJmjP
         kMzBTSHn4ss6jC6w2KTJ1bHG5HHjhnxISiGpBnefK85H/yB80WXRrruZGkMIV6fAkcKU
         LNHw==
X-Forwarded-Encrypted: i=1; AKwUvBxn3FUvfmtMKvxgty3PpbIsmTmd5KF01CcV2jXQhX/awHQbQNNfrY20xiUfC1I85fRMqB2REJnJ1g==@kvack.org
X-Gm-Message-State: AFq9FYI1VmBo5ENh1AGZmrM1PSVZ6rvUqTeoFF7TZLCkwhTRpphOcDsk
	XLDlyLBf2LVFwgVeBn1pCFfezez8waiBNgKXkZQ1E6/UFiUHSAewkbbDamNYqVrEi70=
X-Gm-Gg: AYBFou1jPidJZ1gAzoo1B89XAsdLwlAfWo1dquzSVmLXHUW9XGsuhns8Sz5sg+TvlKG
	Q+EgKWVwIwSm/8pf0JRrUVge8Qf2EnpbctWc3K4TYr3t1sH4/OIwKnYWiqDjnqv59JrO+yq0Qzu
	M+IV0v9QH0kNeIN7qvS6dJdA38n68NHaalIQlXk0BzioQHbBQV4ZWvcNT/O0Vndv/PhgrZ1VcGl
	jds56rTVTUEE7e6E6ZwZMv1HPY222uQ8puKjPhxhGRnKgIR7Pd7HFDSAYDfPOQPa8yl0sjfe2N1
	YQu0ZbByFrHonP5C8NvBBoJiTUgWM7Zy+QoBT3pbxu7vocCKmtaMuwrAitU+5Uo+MPdTl5omxAM
	SV3t2ilkUIqD4BXnzW0lyL7goq0JpGjmtgTQs/oX92HJLVSO1qe9xekayJvPdxFnuR/Z6Byu45B
	qhgGBWCXU79ta4rXHBSJoWey/YetvUxFAhw4yOyhwbGnY89koKX/Loahz7iROSgP1Ufg526AmzG
	zWA/njAB69f
X-Received: by 2002:a05:600c:8b78:b0:4a1:813f:2a60 with SMTP id 5b1f17b1804b1-4a18e47acf5mr381505505e9.11.1792006079203;
        Wed, 14 Oct 2026 12:27:59 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd972affsm12468825e9.2.2026.10.14.12.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 12:27:58 -0700 (PDT)
Date: Wed, 14 Oct 2026 21:27:57 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 4/5] memcg: avoid queuing high_work from reclaim
Message-ID: <as_XvRZzV6vR9dCo@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-5-shakeel.butt@linux.dev>
 <as9p2uFqCQprwdnI@tiehlicka>
 <as97Nzob4XuzO9Ss@linux.dev>
 <as-08j9_1C2F_N8s@tiehlicka>
 <as_AxtUlV8K2fkNu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as_AxtUlV8K2fkNu@linux.dev>
X-Rspamd-Queue-Id: AC9B640006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: zf6z48pji34drmuo3onsezhbto4ebk4a
X-HE-Tag: 1792006080-178299
X-HE-Meta: U2FsdGVkX19f6Zz6SepKunPcFo2fXOFfRxarBKF/eLZ3b1x0enlYCd18MRBL7UiIiin0ZSH3/5s4bscf1F8nAca7b0Du7CBDFvwmloXxaRzA+sLLmrtgJcnsFxYR0Nklewp2cXfL0Cchxh/L2abpTsZuQqcwftKazCyaTMfN3+KQx+obPGwuLOafsRCgxH9c5dyZk43zGp1puUQ2RyZh3uJEvlJ7McTMgdOdrai1ShJ5w1OkI3Sd/1x1VD6Q9CP0tnacD/1e4rOhbL3fyGzySqyYWWxBtaOLCmQKaT6c993KjI3yKTy4cPrO8hvdJk500q97+J8wM3Zd3oCChjLHqmXLtuFmifyCZn7mspoCiyAXeVpxF9U+2mkeRcj5p0WqVtaivJ/RlKUBaZDek9i55GajKBwicB/+hpvz6YHOemE29/Y9Fed71em385S2jCrjSrJZmgJCtc27gA3ybVOBo1V8768ZeHehLQr2By6O8uXS3lpK/itEubbX1oGEhOh6LIsVT+uGo5APLlyh0iEwwg0eoiHcjY7mRUp1PabbUD9bbLZ+z3aorA/neiNX1kjlLYHH4RNW2JNaf3TCxu/n2uD5ctao+m2ujiQ1Dx8bzpw3oEXdpvVaUDV5aWza9KeBS7uAQ0LXNZnTZ4Cf73/xCJvucNfZ+iRMVGbPvr+t2CJsx9yqTV6JR2Bh1SIvuezTQsq8vhbCW32KHswNuvignAqy3NdxFJQpecR+yUHx3UhcEItAWshOdoNb71SF9Wd7IKjms1lTtF6gB2ilD1TLHBlcJYXs3eETydewPq7PzBJypQc//BfzrG6+l/HpXh2tnS5dt5sTlVIlF7id6sxCecx7rx0DnIejAW+ieLpiiV6hmTrXu3Di0L73+AnJfZlnlI9c/UqqIYAWrLpKopZXPZpkqg3rKojqd1EKF1iQsfUviZNEmPVFgn1sX4q6xqr6QKiQMTg83wwkRgdBx0v
 e9FHymja
 yHJI7xGpZYAdMZnilN4MBKTfnOLUnx6im/2VaUdlS9JUGdfNnEhgs1wWz6mia1CY+S6V7Y8wTw+y5eOSbx/Mrfb8P7AzXBVffEU5uKkeQ9d2hszWvOVz7B4wuYRnyynNBU7Bj0FY+kIhirJAD64fiYLbdc8i8vBv1pdiUJjIOsKoAsGSPQWtaSbIRqmMy27s2bE75DW8pwRhErdSxWwF3qioqIz+/V+BjpyBZWOoExQQcR6VKgyeiT35qnesnwAQ+cLDJvDsbHqnTVue32NEgLOgwb9LzgLIhULZ+FQXHF9i1AXNZKkQ7lUZX6gK0xbnmDM2Aygz9r7tFqOmEiV0mmng+CSDVzr82VTHUs+ybyo4gMdwMy95KXtNFr7Ee0+ot0Ibo/Ix7aNllBitGvNeLznauSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 14-10-26 10:55:21, Shakeel Butt wrote:
> On Wed, Oct 14, 2026 at 06:59:30PM +0200, Michal Hocko wrote:
> > On Wed 14-10-26 09:06:00, Shakeel Butt wrote:
> > > On Wed, Oct 14, 2026 at 01:39:06PM +0200, Michal Hocko wrote:
> > > > On Sat 10-10-26 14:09:56, Shakeel Butt wrote:
> > > > > Kernel threads and remote chargers use high_work when memory.high is
> > > > > exceeded. Their allocations during reclaim can also charge memory,
> > > > > for example when zswap stores a page.
> > > > > 
> > > > > Without a check, the high_work worker can queue itself from its own
> > > > > reclaim. The pending bit is cleared before high_work runs, so each run
> > > > > can queue another run.
> > > > 
> > > > What does that mean really? Does this delays the actual run?
> > > 
> > > It will not delay the actual charge request. This mainly means that we keep
> > > enqueing the high reclaim work even from high reclaim context and can
> > > potentially keep wasting CPU if high reclaim is not very successful.
> > 
> > Hmm, so is there any practical problem if we do that? What exactly do you
> > mean by "keep wasting CPU"?
> 
> More specifically if high_work kworker keeps enqueing high_work, most probably
> the memcg does not have reclaimable memory and keep retrying it wastes CPU.

Yes but this is not specific to PF_MEMALLOC context, or do I miss
something?
 
> > > > > Skip memory.high enforcement for charges from task context with
> > > > > PF_MEMALLOC set when they would use high_work. This covers kernel
> > > > > threads and remote charges. The memory is still charged. Interrupt
> > > > > charges keep their current path.
> > > > > 
> > > > > In a VM with incompressible zswap data, the worker queued itself 163 times
> > > > > without this check.
> > > > > 
> > > > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > > 
> > > > The patch itself looks OK. I am wondering whether we can unify the check
> > > > with the existing one which forces the allocation through in main
> > > > charging path.
> > > 
> > > The force charge (and ENOMEM) paths bypass the memory.high enforcement
> > > altogether.
> > 
> > Exactly. Isn't that exactl what we want to achieve here as well?
> > 
> > > Only successful charges (done_restock label) goes through
> > > memory.high enforcement. So, even if we move this check in try_charge_memcg, it
> > > will still be a separate check before calling high enforcement function. I think
> > > this check is very high_work specific and better to be in the high enforcement
> > > function.
> > 
> > I meant something like the following
> 
> Oh ok this makes sense. Do you want to send a patch or should I add this in this
> series replacing the 4th patch?

Feel free to take it. I haven't even tried to compile this. Just wanted
to show what I have in mind.

-- 
Michal Hocko
SUSE Labs

