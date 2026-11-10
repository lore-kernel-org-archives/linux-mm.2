Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB4A8606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 06:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rJSKN2bX
Received: by kanga.kvack.org (Postfix)
	id DFA166B05B6; Tue, 10 Nov 2026 01:01:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83AE6B05B8; Tue, 10 Nov 2026 01:01:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C0D6B05B9; Tue, 10 Nov 2026 01:01:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2F7D6B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:01:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 363D71A08C7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:01:43 +0000 (UTC)
X-FDA: 85418162886.11.CB1B47E
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf24.hostedemail.com (Postfix) with ESMTP id A7A8818000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:01:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rJSKN2bX;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794290501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JmICRKQID+0ulQo3yfMRoaH0uyFxjYtLwmbQRsLy1kA=;
	b=sYAQNN7YQtbi0ykkqhNc1fiCPGNze7ro9+i8vwA67t+To3gQ9KaqrgwFFi/0LmjQiXp0Gz
	z0tinjwBZUCExxfW+tj176mWLxQQTqo7F3wz10hZraXVDxOuWGPIjIkBhgzDhXumwS7IMZ
	UH9KBpGh4KM/ZYlf/2agIBig/yx82Hg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794290501;
	b=dBL6bA/iW2hetET489JMZCSrW09d0ZgFZNrtm3FbfSNNXUelCDzsh/B3MNZhvczI5KrC4t
	xnjZNa3yxypwLr5VTFimmsfwmMC3S5rP1qjW0CZb1WihMOTbVZImhjNSURaq1oKy1H7jad
	fk1GNtD4TOrtX2W5KBMd5fpAm0LKFyE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rJSKN2bX;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794290493; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JmICRKQID+0ulQo3yfMRoaH0uyFxjYtLwmbQRsLy1kA=;
	b=rJSKN2bXx0z0PtNbJWzlnVpzKNAwJzofMyRXq5hR3tbcFuYAygIfKqnxD+EgIz+gEqysnoUG2n6h/vUEyHcqpq5D6GfOc5lsTMdWcImXNx39D661eAVFJh87RLLrD1VXGbOoxxBU1Gvz7swwrN/QtmdowoGC+bcM1Y8r2g22GVM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XEUDAMA_1794290490;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEUDAMA_1794290490 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 14:01:32 +0800
Message-ID: <cb36df5b-ef41-4a2b-b8a9-848d5c12e44c@linux.alibaba.com>
Date: Tue, 10 Nov 2026 14:01:29 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: vmscan: allow writeout of swapcache folios
 without anon mappings
To: Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 axelrasmussen@google.com, baohua@kernel.org, baoquan.he@linux.dev,
 brauner@kernel.org, chrisl@kernel.org, david@kernel.org, hannes@cmpxchg.org,
 kasong@tencent.com, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, shikemeng@huaweicloud.com, weixugc@google.com,
 willy@infradead.org, youngjun.park@lge.com, yuanchu@google.com
Cc: stable@vger.kernel.org, ryncsn@gmail.com
References: <20261106160432.2552507-1-nphamcs@gmail.com>
 <20261106160432.2552507-2-nphamcs@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261106160432.2552507-2-nphamcs@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8jy4ewf1b1xg7nz6hugezzzcrnk8atib
X-Rspamd-Queue-Id: A7A8818000A
X-Rspam-User: 
X-HE-Tag: 1794290497-347427
X-HE-Meta: U2FsdGVkX18s9wDcvuYmE0bHr0i5GBGwlmITFHW0Ukx0f118AIs10+KRZ6wD13II3rdOXszih7V4XLhWH1aok3+UItJNui0CrTt7uNtx6QGuJR2KZe1n+V/EAsJIdjOrGd/XWEAK24WOsP7jaZYRbBvw8G9nWIgVTkyoaP1EuDjP3kCK0LWcQ/eqgn+NrzID6J+AkD68/GVFzpnpXrk2zexQQrljbLpRwbYtf+daZOUbc5zLkKb23XZUmLeTf7GutjrxBAQXL5RGAO8WwQNN9j+rhkYGduCLQ6GI5wcJomsaJAablATXCHvAGmkKR/YSyzx5QPVjeogWsI6QKnNMYI5g+Jn7yq5Fr5YdT4TeflnpHnZE4MLrHzhPT1v9OOldYNzaVomwZ1QSFIgnTDbUKWO55ImQwg4u5GnqfaLeO5qiUDHtxMUyikuecbnBB1TmZ1mpVd2+tZ1r49ENBXfZY4B0WK2zk//CJV6Vbmsr48SCrrDeUp/qwF6BaAyTncpy2ITqmFG6SP3LgI3WXi+/cqhgin9PFef+smGspyv9/VCZLlgERXU+JGgJGzBX857a735X1WW9LHPkyJ9FG1/HvMn/dvHT5K333flq+RtuGL3lv3AoLkkU3oli3xgHJEK8xoW6Rs1CWilLcmhmpKVCyy1HYkdAp5ttTCFxn/LfTUZAJZxOkJxxWe87V2R10XvV0dL6QY0QqwUM8cwIJbss+XyEHftn/AwY0+QL7Y3wASgjq2FOmhMz3VG3+CqRmhP7aen1t5qkZunKift232umz4nUhGGyEYgyFbVwNF5bXSfwxHe4/67TGKwtIoWTliTHLejGqpztIiYTLWQQ81bvHt0JZN54aQ79Tgr6qjMRcrl+EcLnoesm1J5oSg2krhT/yEeHaPyQxbrGkRXnJvCVcWxKQ9o1xvW63MkL8VBCv7QOH4NmdcEj9LDN/EJ2X0YDYUMorUehn5XULocdm4q
 gx1FbjKW
 TdVm6x8bLiGkPkx9RljoMc6CegSEwrry0CJMH7PjbaAgPieyBVwbWteHlYMQ9wY34vpbO5jbz2W6GZrSvdrvB4vgag9ExF/b8BQjJeCQ5rld57lWFPevsWaxIMe1BRaFY768+OVYCckpgL08qqwtW7U34w9AJCqnKB8ErH03ejbkP0gUhiuFTpbYO2nl5AXiYwTxbq9FgaS3DNvr41I5iXEfV00qRLLdvMlJ6KcZigOA7Kjim/sx/H+JmzvMqsxr1DVMjk6KbMlU5yM6i4ieEq5jvFRbQKChZ0E/2gYFYFCr8rh1s5jYy5jTvHukwLl3Yk+vaAk3qP/EV11KlVlePdV3Th49td3pRl9tA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/7/26 12:04 AM, Nhat Pham wrote:
> Unfaulted zswap readahead folios can be dirty and in swapcache without
> an anonymous mapping. pageout() rejects them before swap_writeout(),
> so reclaim cannot write them out while their swap entries remain
> referenced.
> 
> Allow swapcache folios through the filesystem folio check. They already
> have swap entries and can use the existing swap writeout path. Anonymous
> folios outside swapcache have no mapping and already return PAGE_KEEP.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/all/sashiko-outbox-181078@kernel.org/
> Fixes: 84798514db50 ("mm: Remove swap_writepage() and shmem_writepage()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

