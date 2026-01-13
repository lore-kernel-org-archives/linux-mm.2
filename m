Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F3B3D2F34C
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 18:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3862B6B0089; Tue, 13 Jan 2026 13:03:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353F16B008A; Tue, 13 Jan 2026 13:03:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255C26B008C; Tue, 13 Jan 2026 13:03:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13F1B6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:03:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4DACB73DA
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:03:11 +0000 (UTC)
X-FDA: 84327712182.01.331CEAD
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5C67AA0020
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:03:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SlHeVN7y;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768327390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6vnju4rgxejMiIuLIDciDiSFQtiQcgq3dIXAnV1zY0=;
	b=5SgAgAJ9wH6hx3brmFq0pQbEkKd2t6Tvf09xPZlhWoz9oNt4H7fdPA6/9fGFRtwOQcJXe8
	QpEPjVAy7lgHiNoImyVigw1osmMjlZ8TZ0Y4V5hnKr04HSRMsr6udE5Z1c26G4apEfYCmc
	0iy810bslcZoXeO4cVWxdvS6u3XId/I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SlHeVN7y;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768327390; a=rsa-sha256;
	cv=none;
	b=3qfza7q9W8BT7eYUpquKRoXoWeLuzm4FI2S3qL7/X+3LKNyrW0hrW+DZSg46VUvucjIQz6
	FUHcv0p45uVYpoYydxZV62g2LLDfEtcgHBE/rEiIy+Ln/Eu+5sYaOi058loo1VHNriwyDW
	nuESs/EX0fkNLeGNbNN7jZ5MFdt/wZY=
Date: Tue, 13 Jan 2026 10:02:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768327386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y6vnju4rgxejMiIuLIDciDiSFQtiQcgq3dIXAnV1zY0=;
	b=SlHeVN7yg51Kwf2Jww/oqTDrxn9DAqIBMIrjHQrUO7r27AAwJ76KRU+P3gIdaLxjHwuSp6
	UgnwfHzU+oLleRo7xSnFvSEjHsqQSpAK31KqNSz6pPvCR7l2nmeuHpt1efaFiwhNv1AsR5
	Jh/iqXjkDCbfORrnKhQY0MdrCtZWZlQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, hannes@cmpxchg.org, hughd@google.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <oo7re4nov5jar6nzu7awvbwlclh6esp3mltiflylzltjt57dca@jbt3hs7kgb7i>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <aWUDXtsdnk0gFueK@tiehlicka>
 <7c47ff99-4626-46ec-b2f1-f236cdc4ced1@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c47ff99-4626-46ec-b2f1-f236cdc4ced1@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5C67AA0020
X-Stat-Signature: mnxn5powfbh67upchyzxarqux7z9f7t1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768327389-650771
X-HE-Meta: U2FsdGVkX18nKjide8lsNsi+scKmBybpr2tDC+OWMaBSFjcg8LK+QpdaRnwZKiTtgDjCzsaUnDHpqO+S5nMrG+rio2GGzQU3AOot9EP51mvKeuGKmAb9TikL0GWAT7Pnr26K3riD8I7ZIsN4v5iE2SKtxCsr3uF2Wq23CBiyylKRoS6tPX8F0ZJUGsSlz9zRSkcJUil51jAstslA40Q1lZ+XT6ARBuQjs2jEXu16O0cIUYM4DtFFYfBvEQEwuHcX8hujb0cJBbhwdKK1kktZ/6cw0G8tNMNAT4PvXDbiXz+vf7ma1wGUz0kdjVflYBaGrGXvFiO7JXHZ6ENE3WyiFEmrSMIiHnbiauKKBZt6//x4U1tsOd8bP38K+uIljKWc012nJl21cc4LVAwq3+Cqr4NErznMedHtb8uG22gfXpkeG2L7uRn2vypXxvheAJsla9B5XwIsCEo8DvjaAEy9bs/HQea4ZpO9SUqeo6BRYAPJYTAzrvA2BsRZmR34DFdYTASl8jtXN221CYtBMVq5/ac+/nLBLQxC1s7Mu14yf93qiGItz47DCRW3ubVdO2pyhI+j3rFcp78pqpx6O7zS6e+/h1ZIrFVvAkbpeTNj+aH3dC1bJL2HU1+1RUXAZcci+JtyIB1mT7SCiRfSDQ5BYXJ1JPkpJWmQyPD3p7Exu6SuG2Lzg237/rAE22mGE4caotog7zvx6i0EeiGyyJnLk3nYNM2eLJnyx4JaflaJFqzfcHXrB93vaxh+WJwRLfMcJaJDdClFR9waYdxuJgjDTbHXb+H9y6vAz5MOUc7dQ9gAW1C55pUswfaVqV53tIbHp5YrReEq5gYV+SYEnTCNGBK1hUWd6b7c2dkcFWa7GS/0gcRX/g9SW4nQ2Hna6q75oNMpEhtcdFC+/zf5Dt+yCDiaNRIQGGDGCTgraG7YcRVUENeUQJnPE9kRUALvjDwQvJiChjl15qrfQZzHEY2
 dFGxOOxI
 0x0T0xZUrkD7d6bh3wQVYMAnT1w4o7j2FbmF/oB6QRBpLuu8p/QJ6qyh9RdzGy/u86AVJ8L7LVbYWeSfSrO+VqWTQlxkPBlyQ3tAqv1LLDR3rUiH74VlVmbFiJphIQbF6t4Hb+HNL+GnvedXp20Mi+FFUBoUHl8KpmS3qTB5sf8DrQWFcZXMH+rpTAqvz2Pm4jR3E/Kqsx/YmHEqfWPH76QgOTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qi,

On Tue, Jan 13, 2026 at 10:34:08AM +0800, Qi Zheng wrote:
> Hi Michal,
> 
> On 1/12/26 10:21 PM, Michal Hocko wrote:
> > I can see that Johannes, Shakeel and others have done a review and also
> > suggested some minor improvements/modifications. Are you planning to
> 
> Yes. I'm working on them (mainly non-hierarchical stats issue reported
> by Yosry Ahmed).
> 
> > consolidate those and repost anytime soon?
> 
> I'm testing it locally and will try to release v3 this week.

Please take a look at the AI review posted by Roman. IMO it does have very
interesting comments, so at least go through them and check if those
makes sense. Please point out if something doesn't make sense which we
help us to further improve the AI review process.

thanks,
Shakeel

