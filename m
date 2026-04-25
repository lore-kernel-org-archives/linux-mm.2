Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ADC9FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 15:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4686B0088; Sat, 25 Apr 2026 11:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984B96B008A; Sat, 25 Apr 2026 11:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89AF16B008C; Sat, 25 Apr 2026 11:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 780866B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 11:37:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 056661C0135
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 15:37:36 +0000 (UTC)
X-FDA: 84697482912.10.5006E8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 66F9E1A000C
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 15:37:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dJJHnpRW;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777131454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7PdBQ1kOULz+lVIBD9m5Y1st1YOkSDbk6WeA2i3ax0o=;
	b=mJvPFGXmuMgsh6C4Ms3Q14B6cgJqQF7hbymogTHpEgPJWYeDKkhwSl/li+QnosAKoN5Bd2
	e6fkqSh1SIcwQ2E2Tes8TDd0JL8BwHFnN4nw1aEpiQFKugu1YG9zhLAjBVBceWs+qb1O2p
	bxBh82xVCv82wEoHGjZp8Mrz92KKfyM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dJJHnpRW;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777131454; a=rsa-sha256;
	cv=none;
	b=zM5d1dRnoGxvo+2bWXOeCPku0l+SmwENBwb382PtdLzuA6CnwbtzfQ1yIuJ+Z6VuAf+0HF
	5dSNk2U8iqCYJgi7rsoFTXIFSao48AQgg91bAtmP313QBp3+vbatlkfMjn+Hb/99eXhMYk
	j00BFasTuz9w+Zmyir3+GhY7WZ/nBa8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6716060055;
	Sat, 25 Apr 2026 15:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BC1C2BCB0;
	Sat, 25 Apr 2026 15:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777131453;
	bh=QvQvNJC7LvyQEmdZeYV/Lpf/XYhQlzkNstKvh8ss6gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJJHnpRWXOSWFvuGVf93+nyAHul0E9HhqmZai5gxzO+EFGza1Pf97SNMO/q3hHTot
	 c0u3tQqMxX4x4cuNOJ1VoijsF494IScHpjc9LPkMxs7AihGn6Upc+nOwlvl17QByc9
	 1HuCmYY3Hr+9mjrQ7WTHVByEob9jgZGws6nZmyy1OX0u6BvZdCk8lkTaMqiP/23DgG
	 +guf2bI3P/YW4LMnYqWBDNSWSVZ4OcVHGV8iOVNyW9MYz4HocUsP1KMzW5NS8Ay/e0
	 mjmBDIqqujw5IYM0si+oINPo4NpgoWeAa0tXoInGUxflAJx0y5xEusiLhXjWNiVTlP
	 RnNsv+6Bo9wng==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [PATCH v7] mm/damon: add node_eligible_mem_bp goal metric
Date: Sat, 25 Apr 2026 08:37:21 -0700
Message-ID: <20260425153723.89488-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y16VuXb2DfeiBiE5avpEsqGVfc6DAKZWacNsu-1hD51hMQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: piw1opksqm8chrhdxzhoqs8oefkqz1wq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 66F9E1A000C
X-Rspam-User: 
X-HE-Tag: 1777131454-470352
X-HE-Meta: U2FsdGVkX1/zotiMR94x86eUzZLOib1j7jtQW0QTqtIqe9GpmNGc+REz90CYkZmSm7lyMJ52uXoq7Hw6q8QOVRhmXQtn0tq4aqo4fzo3F78XniQaI8hLiEE1mkrD5bP9MnPY16B8NwqstTL9X0dRd+hz1xXWTsdOrpBNbNW6vW58vR7CyS07ntUSRgnNg9sxtVG3m3s0d1bfq3x0NOp3JniNyv2Vp8Ex0OWltzP1y/2OkvOYdRCNH5RRxxt+3nDkD7T8uznJoqwDZzdEZG+wlE35OBX2QNUdfu7XSrbe+30rB5OsEvLjf61t7ud/+pDxRUIk8TS6obhtWE7UHzVRWvBW3QuchRgnNUHQz8AY1u9dLmc6Wtq3CLg5EIKWiCEDJ0SkqKQi97L+PxO/nXMr/udX4ame2MkGOaFD9+2ue7oWBNCULxuO+Volw+5Sg71veq7ZGCIwqx48vAif0He1jZXCd9Lm6+H3FO5MGMu1R553sBlvr+H3+dCyUo09opJiaH4c1Cav/jz/A09Xo/frDDSMv+xDwfdTsJeW4r1C7AMmuHLCv+lf3g0lOWQ5+xD2PIJUNk5dg1mYRE5tOCqOGgkW+itLfzcX1LkEnann7KnhIzH9RlclomvBTCiaPKoQrPot4BEDyBEKB2oZMoIWi7pkLy56mEwx3eTNKWBY1uunLQGqUSXB1wDUn3yNY0gmbIF7ZKKx098IPD+1JMhvjlxSHZqE21Wk92SK3AV5g/n6BlqQZYzKsX3vA++M1J8uNIX+4YGo5Zic0wXVb1eTHoVABFcKchDnm5RkUQqyqA5ehFRHekfpfUK2Ox1eB2CfW8+6JyWOCHZuiHatCGBLwlEtBdAgKvmmkqs67m8UTQ3nhF35tlquaJLgWo27V/Mjebot2Iyufz/1j7TsrOvPALcDzaVnvknCHdC4yb5Gy+n5SZQIzFajYwLI8d5zr12Dzkjetub3hhZw/8m9G1G
 TFeMGRpe
 sTURu6jyv13MFI/6hl3CxeNQHWBxrXneoCdH2qmIKNA8S8SGi/EthO6CTB9qTRCRq5rlpRwgHMB1/DeSW770SurfMnBPdeVshCfu76/3b60+Qz/5p1PKH5a1zaRQTOkW1kXSTFxgBkyoO2kpxXUYP6NKSnoo9eHkXdBQ3XERPXjA4qKwrwoK2aqzwPIW5GqcXtVYX/x4EQ3NfU0hKJPlTqmDvWdF16pBws8BMV6bIp4xiO28UMSwVDeIlvL01Sfzxp2LC4+B4ub6KEE7e3LgcGHaOK6vw7CrosM9Pwj9HOxrLzZh0eVScbSwyqFjvcNA/fbfe92H/LW+sxz99a7j9gWMpwQlpYho6+sbdBlhk3VSFapKX/C8eWKxPO2Lku+ZkqTjZyKVDedtIYtqwB46zAzJWgnSM6tD5kfU7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 21:18:57 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Fri, Apr 24, 2026 at 5:39 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > Hello Ravi,
> >
> >
> > This version looks good, except very trivial nits.
> 
>  Hi SJ,
> 
>   Thanks for the super quick review! Very helpful.

My pleasure!

[...]
> > So this looks good to me, except the trivial things I commented above.  Could
> > you please revision for the last time?
> 
> Will do. Summary of changes for v8:
>   1. Mention addr filters for source-node filtering in Two-Scheme
> Setup
>   2. Move implementation details to commentary area with full
> changelog
>   3. Wrap the 80-column violation in damon_commit_ctx()
>   4. Use PAGE_ALIGN_DOWN(addr + PAGE_SIZE) for alignment
>   5. Wrap damos_goal_tune_esz_bp_temporal() (81 chars)
>   6. Remove unintended damos_trace_esz() from first charge window

Sounds good, looking forward to the v8!


Thanks,
SJ

[...]

