Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0151DEB5948
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 00:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22EE16B0005; Tue, 10 Feb 2026 19:38:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DBF16B0089; Tue, 10 Feb 2026 19:38:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109376B008A; Tue, 10 Feb 2026 19:38:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 023206B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:38:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CD9088B09
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:38:17 +0000 (UTC)
X-FDA: 84430314234.25.6A5F7A5
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 890B5A000A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:38:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nGjpWQG2;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770770295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbwdsItdNCVn/rOvfiUbXy89AP6MsD7J95YTJtH5IKY=;
	b=tc7E50+RcVhjJRcym7m9cwz+wv7pngz/yZ7yTUbJ9DJfWPJhPFoe1E5RfBy32hVgqVe7Vu
	mig0JnNmsE5IRdOta5+Kvt2Ks3fcfThXMk14wPf/V5rmXH6D2lOivjU4H+/f9vfI0PORHi
	kgx8opWs4F01ayySDlRrtSBhgY7S2jE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nGjpWQG2;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770770295; a=rsa-sha256;
	cv=none;
	b=XOCeBzTsGtN+/L5qPkxjkUyCwXUBmKwej8IotufRsbTjn4hKBKnEyXtyEVe6npwUnwHd9M
	rXcAwJpWrY6szodqyLh4SFx5bFxZuOPmMzSJ8nSs4ENHicKfAXyR211M9ruH8kSMSILPsG
	rop0XKQ66PbIefF3iy3xbrcjQrDPlto=
Date: Tue, 10 Feb 2026 16:38:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770770293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FbwdsItdNCVn/rOvfiUbXy89AP6MsD7J95YTJtH5IKY=;
	b=nGjpWQG2/c7L7wdCTrpV+AhW2KBz3M5rW7e7GCv58fHxE6WzUsIwwHKk5JLqeXsX5+05qN
	qoXZPTC9S2q3xvSGv8Bu+GVQFwoe8amFtgpZN4LDKfkYllOahsE7ivJOZ96n/wSlA5U+M1
	9wn+kGto9IbAxLcmGeUN3kZ2zd/EH/g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 29/31] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-ID: <aYvO2IaYnyWYDHTX@linux.dev>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <3ca234c643ecb484f17aa88187e0bce8949bdb6b.1770279888.git.zhengqi.arch@bytedance.com>
 <aYabQii_-9EVdgub@linux.dev>
 <0673b72c-8d7c-4bfb-a8b2-da5ae5bb5f00@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0673b72c-8d7c-4bfb-a8b2-da5ae5bb5f00@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 890B5A000A
X-Rspamd-Server: rspam07
X-Stat-Signature: dfuzqsp8dm8ktbjg8adpgy4pjjjgzhjh
X-HE-Tag: 1770770295-985617
X-HE-Meta: U2FsdGVkX1/jFjyZlIci0oyNgonw6Qk0+Yc6RIdtXYMlaqhARQDcCCioia/CSxLFFt3YktEjJDkjH/TuRHvRFUP48AklmsZnreM/JuUszw0Y/liDC+xLaBHSlFevoPUnFfo26/N5i/U+sYtknkx1E8//Xh87jf76aSSIHXNaeGSOgFI5j9r2vanTGtm46IFabOZ9BYrmHj6UjifgsOOcx8REGWclBsOhbBPewWCmWa6kdcso7nU7+VPLSyLOVp3j2qyCI+f359/4baTbdgkTLvtioeZnNeHTDLWOQQDyNNkJ3nyNf6xYWVJ8QCMd+6hZUZqxDI50CkUJyOnDuIFWRH6S5EuWzD8webIjqRgNJITAiGJ/FkJBxdiwLDB1FW6fTT4Ac7aBZc3oUoHnEpX6bhjazwMw3qz/F60e3WeAT7krCf6l5eQc7M5v+Agko+bLniuzoiuTXz7GqfhQbGsfnLHy7v5srfy5HY9f8WLKBNa6Rg9Iv7+MpmQf9ILEOaDmMJMQbu4zqElTN3MdCscV8mGKAMLRP+qe8teGWQk5CEt10Th5iM3T10nQlzY12mqJNKwFFeOQNrydquh5ULoj2CcS37LoZPIwMrofw2OukrFXYZdll/fgPvvLjbNdKbqgR2WkQwjkgVfSsZXDILJJgCZe526yvpIB5WNXtLyWfvASinV2hfB5nDiWm/Zv+gYx1TuKsoD61bP3QByWQ9jg7ksovI3vyjmycbaRabwe1I4pVXIopCZ0Yjs1Yp0n4/Q3PNaHeS1heZsuc4iST1E4e1U8ra3yYZnWe2D/Addh1tJARRzTmiSau1RylfQO0OgVUKNXpGCso1tTNGlE+umUhrExIvtErihoR+3JQh0iyFH4j/vyfQnbZEGafvABTnR7UH5qfBCO7A6B/3YblfbfzlVqphc9kN7/VeWywZBwQ1dm6f5Qi8dAkKnrTrgB2fdVa5DwtJZMeDPmAjDb5oK
 jeOI751Y
 4Tbq/jwCeKHCSG01AbzpGTcCz2jyVnBtBkkUXyu737JV+yK/I980s+3daQCHrKZUWK1G6RQPFau1kQovpSDZ9XDSAGDSIyD5GEeP/wHXVrWhCYjSH5uPe/+EmcgOXUq2YTPRaOZETFXJzq5ms7XZmBW6rNJNSQSuYQMZHEu9EpMHYaagUvb1BVdNF/K8/cWrGx+DFA0RnheD2S/VvJZOeMXwbaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 02:47:51PM +0800, Qi Zheng wrote:
> 
> 
> > 
> > Add the usage of these start and end functions in mod_memcg_state() and
> > mod_memcg_lruvec_state() in this patch.
> 
> Using these two function will change the behavior of mod_memcg_state()
> and mod_memcg_lruvec_state(), but LRU folios has not yet been
> reparented.
> 
> To ensure the patch itself is error-free, I chose to place the usage of
> these two function in patch #30.

Makes sense.

I think we are good with respect to this patch series (next version), it
will miss 7.0 but I think that is fine, 7.1 is not too far.

Thanks for pushing this through.

