Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68FF6C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 09:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6DFA6B0126; Thu, 22 Jan 2026 04:13:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A936B0127; Thu, 22 Jan 2026 04:13:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47626B0128; Thu, 22 Jan 2026 04:13:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A0FB06B0126
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:13:54 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34B338A168
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:13:54 +0000 (UTC)
X-FDA: 84359037588.23.9BC8B62
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3F2ED160004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:13:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xFnYZbAa;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769073232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+KyNQBKKJPUaK/wW8N+ZLRmAcLZADaNx1sFkt8g5Ew=;
	b=uDQiKvDX35No9EEHK+oMJI4i7FRgY6/okJyT+6636ku6ycrvFepPOFAbP/SJ5qQ9z2yGWW
	4/kaSYGsfi8kQVntzoYP21jgnIJUSNkcBzeSKboXY30636iAUoLS5XCLulL6JZ2swFrulB
	XpqZ+9Hc3H/BcZ/W2pVUym6qfm+Pl7I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xFnYZbAa;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769073232; a=rsa-sha256;
	cv=none;
	b=6g5M8FuPCSriqMtKxWe2LHbCGDCENWYdGYaKsuZ+mITb8iE0X5OaeRsysYP/WcJE5ez/KE
	LvYJIs6Oqr2u+dAgeNz8FGvX7aqvyAdJk5RJ6Z+iCGjCKlvSPGdSoJmeNJ33R9EUa3e321
	WX/80gCIPgK+O1YisPdpgOCK3L+21f0=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769073229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/+KyNQBKKJPUaK/wW8N+ZLRmAcLZADaNx1sFkt8g5Ew=;
	b=xFnYZbAabOqzFSmJtBX/KGte0MPJ5qXzrgJxhvtBQSprrumcS0OcbzIkfk5mNYhGH7a5zU
	wS8YDcRucnPQ37plWU6Ku98H9FVwtkKZT/JD5f+SYgIvWQwvx5quPq6JRYqsz3KriL1J9F
	fos3lLKM/qCUJM1sSKNxjuNqOaEju6Y=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v3 27/30] mm: memcontrol: refactor memcg_reparent_objcgs()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <843e9537bf6b99cc7f19744a6f53b92338c96bfe.1768389889.git.zhengqi.arch@bytedance.com>
Date: Thu, 22 Jan 2026 17:13:03 +0800
Cc: hannes@cmpxchg.org,
 hughd@google.com,
 mhocko@suse.com,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 david@kernel.org,
 lorenzo.stoakes@oracle.com,
 ziy@nvidia.com,
 harry.yoo@oracle.com,
 yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com,
 axelrasmussen@google.com,
 yuanchu@google.com,
 weixugc@google.com,
 chenridong@huaweicloud.com,
 mkoutny@suse.com,
 akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com,
 lance.yang@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: 7bit
Message-Id: <8F366ACF-6CE0-4751-A0F1-70C20DEAF190@linux.dev>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <843e9537bf6b99cc7f19744a6f53b92338c96bfe.1768389889.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F2ED160004
X-Stat-Signature: tcnu4owxu3yinnfftin5ef9r64nu6uby
X-Rspam-User: 
X-HE-Tag: 1769073232-966317
X-HE-Meta: U2FsdGVkX19mcAFtRaJayh7RWCitWoRq5NG6MF60uNuvfmUHKr9iZLVp/Spr1Ca26/tMvrKxCpBpIqy7pJh0Q4JlOAidbz9XS75w2PQ6Q9BGxRyt6KfzNns/nSijLxODETUSYzG0LBBo8XOda6gp4Te/wrxa238P2HWY5o1yz2X1uu5mFX3JF/cO7qH6vT2bg2cHRf/8DdYTR0OwuJzkU0Do98++WlWSPbuIBApKgVB4/eeFAz7+dgEhM4SOEBnETbW4WyseE8q9WADGc+giM0MVtII5PSBNhPCAfy91oklO8gWx1WMHlb6KDTXZ9VgpEjFpmnSfRTS316OcvIxgCYIkENxbs7Q7PW8yGYM0N2eJ5HZIgIFBCs9SKU0MBEDP3cOruWjQg0SPR7whh4Y0iKigMa+pnjE00YMtZOOeOP0EJ9axaYAHl62PbHl9lzm36SMID8L7lz2+1lcRg7ZIOkevcVqtBlrI25eI6mpp9/jDEE9acQpPJ8wXpFr01oth311TiRf7gIpDeU+BT1bmyHg6DK4N1HlLUgSdziM9u/CmAt0Nj3WQvRZnKSeeqeRbEzw2xMuubM3bnyyMBcz7GxPRtTg5rBFBU9bryCz2wM68obY0zmX2jcjDSOiUjMSR/79GqA8O6ng4iK7H67fcnvsdrSTQ2by9joR3IDAJ/0TZIePvbhYedtj0dJaK1mjmc6Bput9oC56U8CuzUqehwj6F7GcvXzeq9ntATfot2IY6eC3pTbXzZ5rzqawfNJRTajc5baO2yc2+an6HBYhpbJtu6Yrchcyl9WMC4RolJeKI2oC+fAkXVLhOuCbAghZ0WaEq5Y5eGeWvCwT/KfsbZ4Kq9LkQ61xUB5Q0uMlyfkHwOcSsDXn0HU/11AbMC507/22rfLj6arW+V4sEOo3inV4G5nbWRpMqC89LMJ+bhbQSYZoacU8BlsQJnL3kFvOgbhh68UMfA0vntl/ibLq
 hvXehUA/
 k/Zvfli5SD+e9fNvP2xV4eXqycc9XkD55Fa2QoU6t7XKweN1awXCJ6qgjK0gP3Tjgr0tRaA9GSb9xbJfFIBXg1R0vPwGVvmDMUYOi+NYC5yxSwS7DamuhAuaEY9ykHqCtU0HpyOuaTzQjN3BFLk4ss4P7jhkCyFqOy9y12rgSHGv2Z72ugQeFCkfCRUJuI+ti4vEPfXmNHLCFKRWgG7DVT8j9H9YwkWu99qJ/W5L+7CZr6hBi2FIP/3HOowhSiKnmQUFgwoumsasjN988XK9vqmUGNRLD+p9EQaEmoxnH6kQxdSK/4ZC7K7LRIvF4VXaeidgCR6292BUiyGfDqJEgTFXM0UnbPtQyiqRD7DQYe/DH1M4wJpeec2XhRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 14, 2026, at 19:32, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
> LRU folios here.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



