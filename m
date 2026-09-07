Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAEE8C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7A46B009B; Mon,  7 Sep 2026 07:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78406B009D; Mon,  7 Sep 2026 07:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C410B6B00A2; Mon,  7 Sep 2026 07:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A85246B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:39:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31A27C0146
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:39:58 +0000 (UTC)
X-FDA: 85186772076.19.3D02864
Received: from mail-m82105.xmail.ntesmail.com (mail-m82105.xmail.ntesmail.com [156.224.82.105])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4F791100005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:39:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.105 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788781196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TBB7uNJC/t4nAg1FsK0zep4fmBRgGrYzeZuS8gFXlog=;
	b=VNU0RPJgVY7Y1DWeTNhDQG15d6iwJZLuZz9b/LeBQzD3cfKZKffKnXORwch8b1FIaTJXpl
	V7W4FmphBmiOQrHEs79JReFkqVbvF7w3ku21Q+qfpHeCQm4ECFIa2thl502SKUmGuaMkN/
	L9Hw1aBg/iyx4IT5VMFy0biTucYl3E0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788781196;
	b=DieHip9bFPU21VrventPQ9sC+/hWRmU76ZOZTrFuk0GrO6GRE9V7n/AVeq0dwUP9lES3V2
	NaIFm62z1xoujLgD3edyU8jFdrNS5AVgn4i+58NUc5DVU/wnhFeHmtubcXY47IlWXfYFCr
	uHTHSZSEu++9tGqANucNYvhVEtiluP8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.105 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ec924d00;
	Mon, 7 Sep 2026 19:39:48 +0800 (GMT+08:00)
Message-ID: <810d5cd8-03fb-4cde-8637-e1d7cc1e1df8@easystack.cn>
Date: Mon, 7 Sep 2026 19:39:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260907082620.2083838-1-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa07baad5c40229kunm9172ee8f171186
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGEwaVkJJGRhNHxkaHRlLQlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	hKSkJMVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4F791100005
X-Stat-Signature: 41tur7muu3hmxd49iyo56u7gz5qjik3k
X-HE-Tag: 1788781194-97333
X-HE-Meta: U2FsdGVkX1+z/7E6HHZkqm/x1YUKGKnWuUAySWvbmzsKAaSGo2Rnfm9FJkSz6Dy/vXaQ2X6MZkDKdikB+DUY44m1Zyj7x1RhAwM839ViY/qLZRrdbz2lfv1Rv6NyNa+n7uUnBATNCh3v+/f/pOwMWhEnBdQsKIr9ubfEheb3GdMwGwfB8jTj56wZgzrrlhqLakFte54kVYhqGPHRMDSUxVsLQNDMjEpxu0+8Wje3nX90riII2cLCrkP/BuNNaYQAbWqWmgE/XV8Gl9ehWfcmYfHUA3gugd1YKsM2/R7zWHfet5E5zSQJqZlCIEXMv63rFZ2WG566WKehvmvJo8bNAulEa9OS8jE/gxQ9wfxw1rqtTrkK8sB8vXfJAkXED5wuoJn/7IQFMD7/CBi2lUTZOA3bh/Ol1RqiqfMAbhFNjNWZYo0tgZxjkhvP6oI0+YM6m3le5eapUCCfQzKmKM1PJe36dVuGvLL/dVFrznLZgG6TNEOwLbYh+0PQJYl2Mp23M/Fr8FfFLpEX+PXeXHsFmRP10M5DWey5zJ8SMSgo+1H7moTux9gimgwIJT2g07YTzXNtU9qgt8pIFImpAyabi1rLEBGOtq540S8vgEyY+Pm8bSJ941HXUKpLFLYpsKmUSXx99nJ7aiVLkTuOOZqI6bgyApmYz/XMTLdTXC2+HiCrrslLqGfvIJU+Hxlh0cWUDda6GxVG2rpvsCGZ1EqjddV+dHT9F4/i/xKJP/oaqH6tm9b8V3aAmnfYyfUZYacbHTq746ieBt+GZBPI1gpJtg0TNkcj4NCoVtcsdNYHhieH3YNaGC0eFN0HJRm6RwBYZb5a/dzBfu2OH0osWIiY3dTz0zM/kZBdTBLYp1gSKOEE3vt8SIF87BouLLLuWVyrs9grCNNWhw2TVsjogBKvrACasf/j2+RDrw5WZ3oT5tmbaKLxQKgtG3jCpmILHy/TogddAuJT3yKDCDl8fMi
 DzN4KO3f
 glU2vLGyYbAzu5cyQ6HdGhBiDYkoPblCCH+N1cOlOYAhqj8/BsidFp8S8eVJUARPL4LCdVekPjXfif3cdHbfQgcXHDi3sz21MVdN2I/hZ31wXOq/fLTxlyBiH0Hy2wEvMFWEr5NXNf4MQ8GyrF8efDdtriQ+GaIx/C+eAvs2kyYh5IdbTjJm0p0n6yA2XW4wg0Nac1/wnpXU+CG5mO9xBm66Vh8xlql1O9MiDRbhP28dE4aX0HlYjofm8g+fELtoKTa8ak0/Dbrh3ZKiDWavqgHCftS616PLp2H4j4mqKHbP7ZojNxK94bxUDLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/7 16:26, Zhen Ni 写道:
> This patch series adds process and memory cgroup filtering support to
> page_owner. Following the previous series that introduced print_mode and
> NUMA node filters:
>    https://lore.kernel.org/linux-mm/20260707115411.1714314-1-zhen.ni@easystack.cn/
> 

I have checked the v3 version of Sashiko's report:

	https://sashiko.dev/#/patchset/20260907082620.2083838-1-zhen.ni%40easystack.cn

It did not point out relatively helpful information.


Thanks,
Zhen Ni

