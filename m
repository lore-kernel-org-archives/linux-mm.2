Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC4EFE668AC
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 01:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2736B008A; Fri, 19 Dec 2025 20:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C226B008C; Fri, 19 Dec 2025 20:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB0A6B0092; Fri, 19 Dec 2025 20:26:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE9896B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:26:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A40C56B75
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:26:03 +0000 (UTC)
X-FDA: 84238108206.03.9ABDF6E
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id BEABC18000B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:26:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r3WKDaPi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766193961; a=rsa-sha256;
	cv=none;
	b=YI/N/UgDrAOvckGTv1REO6r3CgZesAsu3AFhUpPqNJUWqnAd/HFUwWwdwoEM8XodcJ4Zwi
	7HFWmnRrSOsVO0zJITWZam3FxDAqUEbOZbNjKGKayIvIxNj2FXmkNfgrnk0oG5fp+mxC/n
	u1Ne10qRGr+XJQGHxyjwrdWWDpaGtuw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r3WKDaPi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766193961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=voaV2xOJnTqXL1OSyKUQC5/CATHtEmV/NM52XoZ8tvQ=;
	b=eupVulsrbZILBvkobgfNTilMmgnxNxotAGN6cbtUVn9DuFUtKAq57VKotk2PfItEAK4MN3
	7wN7YVBBnzancWpddTT2R2EEYSkhaaOc1uchWKwnaDw40ePozBlqYfTzMA3w5TAorYUdoV
	8KIracS0qbEm6b34N+/QQBkUektUP1M=
Date: Fri, 19 Dec 2025 17:25:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766193954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=voaV2xOJnTqXL1OSyKUQC5/CATHtEmV/NM52XoZ8tvQ=;
	b=r3WKDaPiy3qy7ziqEqHCTHCBq52Q0Q8OVceRdAoCsWBxiN0pGQzedZgq4H6rBql3fhZFVl
	TRom9X4l+iQxK5ZMnIb1qWJjnMjcT/t31vjho6t69XnFQz+RSjhkXtsO3xyX/fWRZly8OW
	wBeIFfUla4ujWBMnXcIkETZxhTLrHhQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 22/28] mm: workingset: prevent lruvec release in
 workingset_activation()
Message-ID: <3eiitl5ghm3dvueb73oedjbrungpidx42fae5t26gzvpsxgrh3@aeormwrvvkrr>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <195a8cb47b90e48cd1ec6cb93bc33a8e794847f6.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <195a8cb47b90e48cd1ec6cb93bc33a8e794847f6.1765956026.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BEABC18000B
X-Stat-Signature: g6cxtk6n1meemg3f1fd6jrtd7fmtzmkj
X-Rspam-User: 
X-HE-Tag: 1766193961-921450
X-HE-Meta: U2FsdGVkX1+T3UojV7Wn+YyI2q1jrR66paqQcScltfch2Qr0GTJ/9GadtOYejODWsWxPfNNIy90p2oRK6sz5+EmaLttL/HPnpQUlkDSiXGwZpJJDdKrc398JIcmRuvJ/9UwnYBv2u5Y7/fiGykH/TdVyRd1EfIkNm8jaYaEmk8QfM2w38nGhhme190EM2HHFJNqC81+sffp7JVdgvt7G1y62kW/enyCm61zMZ18k+IHSjp86vvQd9ao9uLJCgr2V1avNFAobTyJt35dOcwbn2Krl9ksbh5pIWMFs4q4VqSdX9v6U2OwAH4uhp2uU2vWgQi7q+n+baph7rk3hSB3anQuMwDMux2yIjOeUNoVOJJmPG/qj4HuLRxKc9sqSC4LOE8ARRuffjp08iAaZzzN9iAXhXFsPqYqeLmtuvKydrNRA7mqePvp3XSu9ycCr8gnfzWQLvlWxlUigik+zvZnSpTT4beQcBvt5Fq4d1Y38RJ61zciTd3Gu5CHuFJNvub5xBT77vDx8jXrsLrO3m5Rqqpft9HJ1zH84jdoRCTvX3Y5mC5Y9HSBkBEqC0bZ31iuvrN+5a/1AKitW1U9Sj2YkSgWUTu4/AUGlPEMCuPOtU9ErI5V0cTUHiIpdWwGAAY1b1w4qnu7lHVz5mEk8PhIKD+D1oGKaldVE5pNsQVhpa5MYaimUip9TtngAqaL1tUyRmRJJVL02RRYjgZkULcvv8tw+sC+Yo65MOw9XvwXt9N4VgcG2lbiHE2LUyvtmzopQ8o8iEUlgzCk84mCH+GHaQfYD29VMJYYnR85xYXk7/rLfqrKLtfYBOHntAeCgrcl3meoaRd7qEZ6Rwa/LGPashW21Z0Nn86PpMyZ/aMmsrI4lIMJLNNChmoJUzs6ZiGQIy2hyeA+avu8AMhNtnBGy3jGF+oI/RwlfgHezUgBscvkac5UyToArtlpeK3wWIMSYpDd8VgoK5xCEbSWFRLf
 YUiO5TVH
 DAaxizwFJhWoWYaEwtxc5XoDzmHi+4jelxA7HxUNmfA8xqub/8BUj2mwWOl+RHFPl5y3+3aU9d+S5kuKZjXZr2HTT14IiyOgKdjqwhvMKUxpQ96ZMMvKW2HQCL4TCLcgVXoznNew+RyHZjIf6vtLN9I6bKu4BG2R44R9oHrwkZID2YPntjSpNDPMCmjKoE4fRfdbvG43C2qOgSjCBnbuQW2UaLMC0KLDDZq7ACdKeLY09ic/ebzpBanh/PU5Rj3TDkocOZIn69EiEqAJqsSmSJsn5j+gw/pD3/PqQbmbycCcadFQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:46PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. So an lruvec returned by folio_lruvec() could be
> released without the rcu read lock or a reference to its memory
> cgroup.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the lruvec in workingset_activation().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

