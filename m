Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D76A6E6F093
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 15:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2706B6B0005; Tue, 23 Dec 2025 10:16:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E8B6B0089; Tue, 23 Dec 2025 10:16:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11DD96B008A; Tue, 23 Dec 2025 10:16:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0070D6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:16:35 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9A0613379
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 15:16:35 +0000 (UTC)
X-FDA: 84251087550.07.4C9EA19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 08C8D16001D
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 15:16:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GNmmWNv5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766502994; a=rsa-sha256;
	cv=none;
	b=P4HRpsuQzmpuOwQ9p87L3eYcoYSJbTeLmQxy7QwToyAAg/nGoSou/EvDMDOCx0aDPIVPSb
	DJhIDMBIXsw/uZ9zC7hZZTvy5CPRAGrbiQ32SXkBZt7nCMXXw9DVYh8WXI+vOWifJGpE0D
	FBGDjtQQKMdQcSs5jahchZkfJcXidMo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GNmmWNv5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766502994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6i6STglztduNNN/BxT8GuFiTUc1VSfue7E9LS9V7obQ=;
	b=Ioc8ZwVwZkQ/Bp1NZZ9SlE01PUT9NcsRn69c8ECTLTZ3Z1b7uqHG7cm06sESC173OT/5kW
	fJCGxSIY8ieadfeNAsDEK4slLaaBCVNpQys90efNkYvvlCiq2xRAVjvuyRUhrIuUQI7v/O
	9txTgKrz3tQiGVVNx1dONLAL5qs4UzU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE0C860123;
	Tue, 23 Dec 2025 15:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00827C113D0;
	Tue, 23 Dec 2025 15:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766502992;
	bh=MX0UEBGbGjeyT7I+fhRvt8AzC7Kbdy82QaHX7EWOjB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GNmmWNv5axguqpzzF5TE4K9OHVqQuwUPYn7m9Xy4O5zQEcBhdYuWYACcupNC3GUbK
	 oW2+cfENHoMcqbRbby7jWn2BmUXrd1fauW3pFEup7BKEk47nyIqle6LD9w6eOTMd9J
	 MAZqcMh2EGy49IdXJUbrDxuE/UiNrY1dxeXDWBoB4oPhLs9w0s/VtwK9L1yAqkvUhU
	 shf41UdhHRQXcM2m+TWEW/Amg+72ajreOtvYGVs4EFEnbxlGuB9fq0Yu/V+s3AuQkW
	 bEj1psfGTsi3frtp7vlRosrykLLEo7oh/Z2lOA3Qv6uVrDq80/wGYWOfg0mzPNyeo+
	 4OWUjWsJreuuw==
Date: Tue, 23 Dec 2025 16:16:29 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 13/31] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
Message-ID: <aUqyTUm2NipItcVu@localhost.localdomain>
References: <20251105210348.35256-1-frederic@kernel.org>
 <20251105210348.35256-14-frederic@kernel.org>
 <e0c0f8b7-112f-40d7-b211-89065e9003b2@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e0c0f8b7-112f-40d7-b211-89065e9003b2@huaweicloud.com>
X-Rspamd-Queue-Id: 08C8D16001D
X-Stat-Signature: 7cfoyt9t1gjfm1x5sgga1enhokwimfqk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766502993-718975
X-HE-Meta: U2FsdGVkX187HpAoii5mWlNPs30kZt7IHI0jq6LEsNk82KacIZFLy8CtNS4mopkYgzPm0eZNPR097Rdc1mYRsdp6qeHv6WPOdhZ5AAtwwlGjWj4lf331uNMRcp5vzY+4CDOpqZx9pGcL7Jw2Djmcqt2qeQXOHZsXA7vdb7wyxvuzxzuBGhGfAVZCnjiWwBWfD9fGv8G2gA3qcoiIE0qUOPYCBRlJtZYVeJHAeUJZ5aw0Mjrwh9S9Xi7Mo8uHLhTsTOSVzdWVR74p882Fj/lvXQznTLs01XLVhB01c/G5TsxIsDzWiaO8Iv2CvwOvXMnIYK55ck/LpIGYrbwc6sLbIS1TWUhCuvyndx02RGMuYr0WXqE3kCW13e9hM3bChknudQAxaJ+KvPMzV9xYPlAiSIxrDpaJZyGQGhzAIL99FNtQxstSBvrQqQcqKHC9pS2Jma+iE6410uXcAB2ASCfJw4HzsRX2KjMbdfDvm1pEj0BDxEzq2moclTLiV9Plb6ncC01Z6bdwL3p9K8FApXTUpJchXJemsbWTqZTC4aO9JKPXggYtiT0rKH22alNtrMC3N7+HWNc8yXFL4TbV8hfcURYFzoWMHjl4pnG7ZeX0fcMeezjhVeXSPP46Vqu00NqTzM+XWXzPA8WhAo65kCvbkJfHs8r1kVnHwFBJYwzdl45yGbSKHKM96VPIAyS+EC8KtAnSNKlZmNve7pGXoZvac3FiNFdx/zai/WNBjcbC+UpVruCv3VfO4fX4sRR31z9ejrcXJU4V6oOnX5raQrYYX/9KJCTE14QS7cAT6ckjgfBWRV3i4zuntzzC0aKUvYcQygW3ukFHKdqrcaK9QkZMr9BDlVCCPWkP8LKfq6/yMZsIeci1QdFzSr5L/+mwMm+bAgcpJpgK9j4wznLfmEW71OMMhKt5Fb0PTAKEJanVzlLdwii0Lw0dYhlGYdFp5990DAmYeydv9VPS3OsH2XA
 wFV9Knnc
 FnT0ui3vYRj3aLzNyBs/f+/7RhmPcFgOUO7aZhYvOFwAnlh3phjOMUYwXnvj6l8kbrZ6Wdf7tp/c/c9YpiDQxzAP5xNjnGxyIoxLDbV+/jkBUh7UBzEVfbQZ7ktwK/zd8NT3H8lgc03jUFmNl1rLC3VdjVeHC6CKPp7/+OIjPW1Oy+z38h1MFKajvqc+tn5P9cNeC0Y+poVzQ6pL6KmdZqiDYVGhq9BRVf3HjEU+n5lqGyUvpRabLVw+iXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Sat, Nov 08, 2025 at 05:05:10PM +0800, Chen Ridong a écrit :
> > +int housekeeping_update(struct cpumask *mask, enum hk_type type)
> > +{
> > +	struct cpumask *trial, *old = NULL;
> > +
> > +	if (type != HK_TYPE_DOMAIN)
> > +		return -ENOTSUPP;
> > +
> > +	trial = kmalloc(cpumask_size(), GFP_KERNEL);
> > +	if (!trial)
> > +		return -ENOMEM;
> > +
> > +	cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), mask);
> 
> Since there's no comment for the 'mask' parameter, would it be better to name it 'isol_mask'? This
> would make it clearer that this is the isolation mask input and what is doing
> here.

Good point! I made the change.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

