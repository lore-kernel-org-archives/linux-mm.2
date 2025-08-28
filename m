Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B12CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 03:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1E7B6B0028; Wed, 27 Aug 2025 23:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF1B6B002A; Wed, 27 Aug 2025 23:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4636B002B; Wed, 27 Aug 2025 23:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA3E36B0028
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:20:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51DDF1A093A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:20:10 +0000 (UTC)
X-FDA: 83824712580.11.670C3DF
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf14.hostedemail.com (Postfix) with ESMTP id 791CF10000A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:20:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EU+Qb3PW;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756351208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xzu8+xsZjYSLmXizNts9wj9/0I/vHYewdZb5tT9jxWY=;
	b=PxzJmv/1Fmsi7Z6LcSE0lMU4F6LgqyCdk0Ib3B49kaAwubMohB+0thM9TFdKeIcmcZrCO0
	GoYdFZ9IksMInLtGE3mnjEpIOqehIbI544DewjAeBBMzVfKqXIxjBqQCHOm+kUBaJzLfVD
	8lh+I4noN/47dqN+8WEss2ETsvJuXTc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EU+Qb3PW;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756351208; a=rsa-sha256;
	cv=none;
	b=3ECKDtwJOS0mRm85WL0IajBjP0EYiPrKNiPuCfxBOeBfh3aQnIS1o3+geyWJ6vm8h+YiPQ
	/NArOp8WzB818atJ3QSA5xkG+d3JngUTBsSnMX7OirtoEWI2K2dlKE4qcIT8g3gYX94mgf
	hn4Z6uzobyoekOVk0ePHf5zS6rPDpzQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756351204; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Xzu8+xsZjYSLmXizNts9wj9/0I/vHYewdZb5tT9jxWY=;
	b=EU+Qb3PWBC3iSQTOX/6v7LUju2RZZcLiN9SVIokLr2ev2Dm+q8JvB6ETVNOGvxdK/6BLquIK9SV1PBt/ZvJLVhbB5gWGfItHOVcZH0Ko0dRVwgPr7elYSdAQb/agl+1PBL5o9TwJbKK1Ah2zVHh8mSTqJI8aMafY6elRyZNoxKU=
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmlD5lW_1756351202 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 Aug 2025 11:20:03 +0800
Message-ID: <105cda02-e433-4b28-ab61-7b63115e694f@linux.alibaba.com>
Date: Thu, 28 Aug 2025 11:20:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>,
 Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-2-ryncsn@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250822192023.13477-2-ryncsn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 791CF10000A
X-Stat-Signature: 1rymipn5jipzhsqgqfxgu9y661ts3a6w
X-Rspam-User: 
X-HE-Tag: 1756351207-583793
X-HE-Meta: U2FsdGVkX18vxjUM4xj4cnDdjotZyGGFkxAJ/+8fsB++ffHYdOIQkWrTlb7xY+VN0t/i7q0qz+SAsuzMSuiN5cEcEYcFHayG1cshZveip8Ni84R7trDyBD4E/LXSkUTkhPxypdGlxEmoKqK+JOSWaxrHqe+i+sHh7H6dF8DOSd3DZqhRtOmmSuj3N3coXcHfprQYDru3JwK/zMstmtCNEJGC6Hjgso0nH1UTfcnA/qLksWvEmvhvvMHgfLDCyi87CiCJzJ69vvqlmW62VYK1O9PkvqGZ8bz8J7Fzf43u5455ON01dnc6cQ0DJrhK95i4kM9k+9LcGqYsQcsGkXhZftCR6dFXZLg/aKomqrs/epzq/BHlJofXfrZaew+beOEAgq9xDluzJUtROBbhcKutl5mIoTuv3gUEzPAMPyrMsTHlD8rhY2yQaXrTnbhZh6BcqStefki0A6Fv8teuLhVQjww5K8WXFWgkKJanwPDdacYxrRhTLLewbOQDZWKQZQ835pu0XUVy1JX8PHsO/Alo+nWlfSc92+zUz2cpd0Z0bVb96ycVbmvPVmhzvLFs3fH7IdUAG8PnOulL2Aa3Ws+EaxME9G5PF0YdkRWFE9gXwNfrIS4d3UyT95FxYDxMQ4z3b15tWxCT2gf9ERn1cF/BrX2ZM+6WwGpEVHF9TYIo1lwhOY5OhJIrAxnIr/P2IjlnEs1PQLlBfoC2KHbcJZvrg1tBKsmhTowcVlvXu1WTjG8pSeDVKFBLRf15DHLhqOtLnjSCLxtnQrnPYwIxm4FugyJSqK46hHM2qPpz99WDSn1Fs2Dk366L4XwA4aIXqUQRBlfwKLwK97lOBJk95ZXt+NcHEDI0kf42KJ7y6vIJyUZx38s/aSyN7Z8JB9U3siysFnV1+V9oAPuu24VXMRPAWflM0OYSlofABP9qcMBgGmjkPlrgAzzMdVs6hm/m/+Q24we0EUT1mB2jMIvTzBr
 g1/RNDlg
 hRFGNnmxcxgiVuYju1oAWLKx318bYwyRkP9yTqQFma3W2wApGRkJ7zgiJ2aZ/8TvJnjYeKvIZsOHcdIG0n8dheGR0KZ2pm8ZLhd+c3D78F/QiLjEQewNq4aaDS9VNHg2EYD31LBOFl9up2YmzJWNJ5Z0+i76AWCk91nPwPE0RpCkxeVAVFgf3w7RGSe4KFUn76+ANIzfnPhgSdwm/yvGjrdgBXWg0NQVgqb4hsrIk9pEFGAfCByeh24r/XiTPjHEgqIYeXHxxUPaiBpXu8bZG7s2grrbKg5ehqRhk0A0NpH9lgiJMJa3fWiud01uAWFiucX2B/6HCcHBw3U/u5BtpWfVhqaU7Z1jhCEp0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/23 03:20, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Always use swap_cache_get_folio for swap cache folio look up. The reason
> we are not using it in all places is that it also updates the readahead
> info, and some callsites want to avoid that.
> 
> So decouple readahead update with swap cache lookup into a standalone
> helper, let the caller call the readahead update helper if that's
> needed. And convert all swap cache lookups to use swap_cache_get_folio.
> 
> After this commit, there are only three special cases for accessing swap
> cache space now: huge memory splitting, migration and shmem replacing,
> because they need to lock the Xarray. Following commits will wrap their
> accesses to the swap cache too with special helpers.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM. With the commit message updated:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

