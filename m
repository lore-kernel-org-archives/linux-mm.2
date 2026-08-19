Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81196C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 20:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F12A6B0088; Wed, 19 Aug 2026 16:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1376B008C; Wed, 19 Aug 2026 16:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3901F6B0092; Wed, 19 Aug 2026 16:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 172986B0088
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:10:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EAE8BA062C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:10:53 +0000 (UTC)
X-FDA: 85119112386.25.987A983
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D834C18000B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:10:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROZMl7ND;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787170251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=k/cnIJhFcOgw8OwlBThrel8zcpRLZAbDDGHjoie65A4=;
	b=YDyGkARhXo2NfeDKVWsaTD+0RkWa9Ze+r0Ycaxbce2qk+Zyp2jqdFsKsiaPathVKbbcmed
	RNq/zgqSX5c5kFYfjFSIItjnkoBVelNEBl1o5CS8z968Uy7oLEH/o2Z8MqPirplyZNQ+Mh
	FZNnQXl4IDHjJ+cbVXD4DIJdN0TIjvk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROZMl7ND;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787170251;
	b=TH5L6tc2h+cNdpMKl/dCMCgttQYDQxOGAbp8Y+lsn9bm6ZCtj68eIwP2PUEMSf3vgqKpgh
	6dK1Oqo/8ZNSpLDZVGDWgyszeZhRajsCFgR3dh/I1ZJEZWY1TpyRbWL42ypJ3UbF5ypt7l
	veLreUu2mIEsdrsrUs73/xNbJaSHPnI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4230C40F33;
	Wed, 19 Aug 2026 20:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCFB1F000E9;
	Wed, 19 Aug 2026 20:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787170250;
	bh=k/cnIJhFcOgw8OwlBThrel8zcpRLZAbDDGHjoie65A4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ROZMl7NDZYXXkwBOLaGYhmKvoJ58W/CYqkZe4zWkEmEZ0ULoJW4fy4III5DeGHMm5
	 jZw5Ev4EigfSLFkGZgd7Qt4o+uODj0xZi3rbM/Qrn48G2a3y+ZMc46YrXHhLf+kfAx
	 0Z2nMTgwj0iK+lpG3JVtZmfMI7eahCFwcEq/AYgqF86dVU2pCxJgFtjNdaalm/ICgB
	 8Ki3++itybeL+DAJC8em8oA1aLKzP91dpDDDs6QkLnGrBjgq8F9A6Au5+QH2c/UeV0
	 0TQZFiJqvTK0G2rOIVMn7+oQ2AuYj8tAHMexNcatk52W5qBY0KIjeA4GVFNH/HLHuv
	 MOXNG1WOTQIiA==
Date: Wed, 19 Aug 2026 10:10:49 -1000
Message-ID: <dc2411ec4acb17b8cf947a9cd213e78c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Sebastian Chlad <sebastian.chlad@suse.com>,
	Waiman Long <longman@redhat.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] selftests/cgroup: set the test plan after the setup
 checks
In-Reply-To: <20260819083600.1351711-1-hemanth.selam@gmail.com>
References: <20260819083600.1351711-1-hemanth.selam@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D834C18000B
X-Rspamd-Server: rspam07
X-Stat-Signature: mjnhe6yakufswdq7s7g7z4ojk7x6uyaa
X-HE-Tag: 1787170251-764358
X-HE-Meta: U2FsdGVkX1+r6sjrlYBG/PY5klHaiuheL8ZlqkBFsyca5cFCr4YJCepKbpyc7OqMzkWBhk4xIMy9bBscQfBxttpizI9pVR1EtkR+o1yIPrWo3YAYEQIwxFIxGC7VzOuUWiYhFb4vZ7AHV0v0w6EjFUpFa5cXlNRGZ+85YcLBaZhO91hEB4/HMy374KoFRrzJwyXiru5gMN8rYcfjFE4j4J2WDl3PAvqFbUtWOfCcNhbELvSNCFbNa1lCyiZNqqKtsioJjZZCf1qKdLi7vXtNS/HxCFtIY8zUhTERDO2/rorg12epYxkVikeNwSs92bXoxZXSYvospGl5EyC/xIcTPSk02yIErHjZkc5GnGQUwEEsfDiHbG9Uu5XK6fMdHzsu8KkqdzLdi+OBPS67ggdGwmQwHFd3/S9yKRRTtWh4i7qbKr6zcxz+LOXfCgSteILu5EeHwg6HehCes/0UmC445YM2N4pHDfk4HZCZRB35lXbhrALbDVYzr9NEVe7Tj8+JKLsUqOy3EnoPD1GHQ5cc6LOahGXnuYBbNNwkvxpWuAByd/6nPE86/NYrhGwBDll/486I+VaxY/9gIBxMhaOaoWt9x5mcRnx//pspkF4Ek2u8jkPrc3ZhZSGP9jAcegTks2N2+hoKniLUxpWqUK3PiVsZOr1bhvKeNmAREpDdXo4iDj9MT2qr4/rCckICL8y2b+R4gT5+gGS+95ZRajtm0MjzSU1EyGfUJ63dTmEPfqKgY1e6oEwvIpmYzYbelc+8zck1Ly5ScCg+WCXwJxMNuqU22cAIFtWSlsw0kNQkClk4K61op6xqIJQB8FsB6Befs5ZSjpGSnXPiQOOjZQcjn+YzlyNXFibcc85HVudQRCSpyQiS1D0hpgbyfjkwRm0ut4lb54cX0IEKAfopizjGqFoLx00QD+FhQsUiCyResSqUNXMqGd6isj0v0ZTst7BMowu8POrAewYcM1jl6jn
 R5r3LAOL
 e+lF8urRjccyKC1xJRlj5CObH38zNvORe10m/Ddd7WeBasW67MjiybPOeZWAvZsjwNB4iApkrplSttRp6HjT55cVXMVL4RoMiQRdt9Yd/WjCjLCLmsY43l+kBTMo1QYv6Aqe2WPojBlxm/1XfLI7ro7MJP55oo9b9e/kvh0Bj/gR3PiT1iZYoHljx27PYO1Lh9gtxSw7JJ2OeW6kY6JqFsP9RV6Y1rZfdxZ9uSHCq4PE9qWrrunkrv/mUlb8sztY9xxwd8WaWm36zeDRGW2W2en4VOtjGp4xhNWmJN5Z/igelxIy1PPZSdEB3ad84fbd8iqzpKhi1NYUQwm5BdVPSUJgT/MBWO/7CSeub
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 02:06:00PM +0530, Hemanth Selam wrote:
> The cgroup tests announce their plan before checking whether cgroup v2 is
> available, so on a host without it they promise a number of results and
> then skip out after the first one:
>
> 	TAP version 13
> 	1..3
> 	ok 1 # SKIP cgroup v2 isn't mounted
> 	# Planned tests != run tests (3 != 1)
> 	# Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0

Applied to cgroup/for-7.3-fixes.

Thanks.

-- 
tejun

