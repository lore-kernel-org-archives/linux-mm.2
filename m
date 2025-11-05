Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51BBBCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 15:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9A48E000C; Wed,  5 Nov 2025 10:23:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D12C8E0008; Wed,  5 Nov 2025 10:23:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E088E000C; Wed,  5 Nov 2025 10:23:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 716178E0008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:23:07 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03A3312C245
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:23:06 +0000 (UTC)
X-FDA: 84076921614.20.B48A58D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 49F3414001C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:23:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fI54FeAi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762356185; a=rsa-sha256;
	cv=none;
	b=2GY+pHb7koWrZgyMaRsPRXOhsuRq8sV4hyFamJeI1TOPon7+M5gXU8utgjMNnvq39blG14
	jbEHkMgYeiPWX/9nlCeViYyUKEPjBdTb9h4oquoWaAdlMZnAgFiqtE8vS+Bf0mGr5zCFjr
	3naCRonv634Ekl0MwPrXLRgyzOGS87o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fI54FeAi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762356185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5C7QxURq//NocpIY9CEsDLZ2QT+8QdYxClseUAsngY=;
	b=GaokMfSy0NuulBRKGdg49GSk6VkQUf03iHfK/JfagiXfwwm9hS59u0uUyZArDy4dUY3xWn
	fs+Qmfum1SF4A8/Q+RFda/J1VnNj72SZc4DPs7XgFWzw7y85QuSS+b5+OumKs1yHPD0k8+
	AX9fSQ1phadUL8RzGwiXmCsJpMtySX8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0418844362;
	Wed,  5 Nov 2025 15:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEDBC4CEF5;
	Wed,  5 Nov 2025 15:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762356183;
	bh=fusB0gibvJKJQXePl8CXgegfMzOrPm+adEItFF8rn4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fI54FeAijnMRfBlbxLG2+Iek1ya9gdrVicMOy6ppH48QNJY1JwCA0YIcMTsGcAyyZ
	 KuEb2RQHhUEh749M7gs858+NV46mLYZbGP/8Mp4QmoJ81PcA4BX5I+j9kHoraKETyY
	 5/xsZ+pDWMBJe6yrYwpFs/GuyQIvd/XVyzYLrl689vn8XudarKTwU0ZOlC8B+b3wxA
	 4M04j8KUlHVMArmw92JUAxOG0ooE93fYnwL/Ap60WXkOAbqG1sxhteuwbYCz02ush8
	 Nel4ht9ZvEnSBScs7Jx0YygYSCSf5Dvon/HzaCuHFaOaiCZMR0DrRHFWElXp1YaKVm
	 4kzXv9mqOHBdg==
Date: Wed, 5 Nov 2025 16:23:01 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <llong@redhat.com>
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
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 12/33] sched/isolation: Convert housekeeping cpumasks to
 rcu pointers
Message-ID: <aQtr1VM9k5-uJbfu@localhost.localdomain>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-13-frederic@kernel.org>
 <083388fb-3240-4329-ad49-b81cd89acffd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <083388fb-3240-4329-ad49-b81cd89acffd@redhat.com>
X-Rspamd-Queue-Id: 49F3414001C
X-Rspamd-Server: rspam07
X-Stat-Signature: bwkndzz36yg4ryk54ats83k9mz4n4kci
X-Rspam-User: 
X-HE-Tag: 1762356185-398776
X-HE-Meta: U2FsdGVkX18qxzWriozHwuqhJ66kx4m2gp8Ck1bH5bw02kAF6GOWSfdX9ZvIuB+KZ9u+hS87B77BmztmtxFBuTK+rPy5GdFzh97I6eq4Lcn+HbPogJOiipv74gIuMh4JIt5pvuxAQsYfQI7R2yi7e+nN9CNW4ulMkH146QmcK2XKf0gU4G4x+SzBN9suhtjUSzy+xgVk+a6G0HxXGR33bIZi2y6/PVmILBwfYS4LUZLjj0XbLyrialnkzmk/x1daoGFY7hFc+P/pIzBXfjVmPfutRj8vMLG5AzX6qant4wxzHt2jfJhIs6VBxybPTPPCX3myTuIy94dCWLorlK3xQOv62oRUnuYp8wpsrM33fwZRe/4Qv5Hj6plS7wTy9tbHHsw0fTNyEpBQ0I4rtuzJpXuAY5w3rLBogm5QpZfY/5EL9+wI6Vkpm0MyYaWI7oKcLz4tBQxxKLIdNI7p6erYHFuAdxhcTyJjngGL/tgXrbbUyahry9ii8AxKc/4f8ORtsEkyxNrS+XooonRnaCXvuKk7Wwap1HuaujuQNSg20PdnWJUKohaifXrM07MZRAsgtFyCXeGUVJB6N5L521CMnK1p/L2xBS4adTgWDMtQajZBQPc8W4zo7nue5MvVQI0RNZdh+FzZSxL2pI5otdsEjQjymBOLY4xR8Ykz8k8LJq4+M/tvjXLCMqylmU8PH/TgnmFxqd/XQc22GzgOTGVc2LasvqSLf2IEcT6IKkzd0V/WqcE6r6g+KQRybFat2COth2ImPn0Ql3n/NKv/qs0NC7NJ1VWytdUFfvz9VNpJkGFu5g6MFkWmxhYiVd9vrlx9DUvagEPmZvU58xJ4K1E53xynNEJZNZClVzDJX57hGAvDr8SxSosC8qPQRXClyV6PzFC7DDB3gPba3rE1oKpAOW6sW0WTw/dFcq5Ruu1vLsKDEIbOslcM+P3E1cNmCGECxAu2ggYxa34KFZQzPgB
 4fL7gtc3
 jNkvsOpVV1UG+1hjxXkNFZI00G8KLyW8c5yc3oVKeIhF1jTFo/kZuC834hyMhMjcqd/ENyfZzecVsDIbntKuiH7rHYAH9/216D3WeYWKLphAdjkoNl5K8PXkhd9PDTtLXe8mHmc9bwa/cQ+DO2T2zdaYAl9bePpos+/lcBwJdij3ilblIXfdDk1/bi/tUW35pjp0mOQU5P84GhMM5oUOQpdScW0I6IEFHAIZV/JZsJyQ+Hlk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Oct 20, 2025 at 11:49:53PM -0400, Waiman Long a écrit :
> >   bool housekeeping_test_cpu(int cpu, enum hk_type type)
> >   {
> > -	if (static_branch_unlikely(&housekeeping_overridden))
> > -		if (housekeeping.flags & BIT(type))
> > -			return cpumask_test_cpu(cpu, housekeeping.cpumasks[type]);
> > +	if (housekeeping.flags & BIT(type))
> > +		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
> >   	return true;
> >   }
> 
> The housekeeping_overridden static key check is kept in other places except
> this one. Should we keep it for consistency?

Indeed!

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

