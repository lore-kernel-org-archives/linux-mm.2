Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D029606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=seZBUxhm
Received: by kanga.kvack.org (Postfix)
	id 1719E6B00EF; Mon,  9 Nov 2026 22:38:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122906B05B0; Mon,  9 Nov 2026 22:38:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015166B05B5; Mon,  9 Nov 2026 22:38:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD1986B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:38:24 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ADE54C027D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:38:22 +0000 (UTC)
X-FDA: 85417801644.25.7074BF6
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf21.hostedemail.com (Postfix) with ESMTP id D70CA1C0007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:38:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=seZBUxhm;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794281901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzDE/u8COOmDW8zDGo5m9Cv7FQzO3s8Vy+gEWM/IoTI=;
	b=cugXlI0Z9rcNP0/jVaaITtxkfDjSw0nnkDrdcD71/n+oGf+H4Y1p9InSDSnc3boRwO2hFv
	N/RUb81+FmLc7Fc9iq/nXbbu9LAyEC/T2WOAB8vGBQBrYQik/Jy1dBXsvlfllIWEqXr/Ob
	pmpIBOaVkQ9o0t+TfQgnY6jo6O57S+k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=seZBUxhm;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794281901;
	b=aqCoatQh+ozqkPdZpg1sZ+CZC3Fs25+1+QvAvhfWnMRoJ5f5luOI66G0VY0TcQ5tYd5/s2
	IvA8XADK3L+lSf34r04DCqRFisU/4LWJCoWitjk9pYRMMuZs4m52ttgsiW0qy0g9NURi22
	OIlgwUnY8hgYqJ0L1Y5gsEFlqBx9YhA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794281897; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tzDE/u8COOmDW8zDGo5m9Cv7FQzO3s8Vy+gEWM/IoTI=;
	b=seZBUxhmZnbn+5dDRz4EdQ4yTVHqziolPqLzVGVtrARFXSSOvpo3/1Qf+6N5h44AXOk8yQPnzIoFK7In8PUaHrfTFmY0E1KQlJLre4uY85q6OZW7ysn7fWSr2sovvGPMDfxnRGaXA6i7Dh8NEV+qBwCW3u5lSosVM5R/x6yhBPo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XETnmwY_1794281895;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XETnmwY_1794281895 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 11:38:15 +0800
Message-ID: <ed1fa872-6da4-4262-81ee-b2d411b36c0a@linux.alibaba.com>
Date: Tue, 10 Nov 2026 11:38:14 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] MAINTAINERS: remove myself from MEMORY MANAGEMENT -
 RECLAIM
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Lance Yang <lance.yang@linux.dev>, Ridong Chen <ridong.chen@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
 <20261109-maintainers_mglru-v1-2-c25e6de60bcc@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261109-maintainers_mglru-v1-2-c25e6de60bcc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D70CA1C0007
X-Stat-Signature: 9tr81am5w43ox5f4ocqkdcg79g8ek875
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794281899-402991
X-HE-Meta: U2FsdGVkX19vyeZpDj4QSeHQwES2Bm5jg5CVc4Zp+8FiaFk5iCfzxdKCbxt/6phAoiYJ27sx9MEAxFyffC19lBt6YjJ3cMuEO5dP+axN2+VJP9wHEgVdP8mNfrmesgBAGgkPKBDf88JzzLakOV8BW8IpSGNv+d+PXh04crhfyI0fyur4K2I72mgjpG1u0YtpUwMwfekrlSW9nXNloR5ddY+7dOCVEREpou791L+E5NC9DSw1EGhgsmIpmrJ3dt8JupMH4bqgX74QE2FMvCX2cYWBDPMX1YFbtKiKzZ/zdKwvT1OyFxX+s6Wh+EPSj04JNs0agI6duKP6ai+ONMesGCayJRtopR9kOCF1+H4aUW7d3ph49YwhGOxSszAaHCijS+rmi5nOByGEy+BYiRdzeaby9ixpMKHPOX7K3f/qUo+Q6ExXMZdSbrM0Y/ojicO6jd9zl1s5i752XCl5pDNOemHhCOYyY8z/EjE9+iJ8IiVYmMOQGvpo9J17NoiSTJD9ZM38fBKg7ZgREkRu6e14XMyHANdRolp1BtZVSu3huMDjA37QqceDZ56BnSe2mHR+YFbGVbJTl5DNBD3R8ncoPY4ytiDvycqjkiRlAOg/qf+mgU0GN1VuaHCfBY7bkP2oCVA2vs2SKq7heq3wSMrQ18mPfv0C6qbYivrEl2J9DIMknjt18XgwawLu/0juzgMgxF/8b4lz81rK6cm6hxHtQiAnUDdii0O0ZDmcjvayR7tJg9Zfid+7H970uCu4cKr0EVsSI6+0ezexTtas2Hs+sR6iu1QFVBdYmsLSZpGtysHIl4/P7hN45DCb84HI9Gbgq8aOllg/yXG0KCASb3vVflbKEWvQzjmjZ8AZ5UUX9duQxpMTpfKcxRLGqQRBM5gVNYnY6/5diwQKS5c4snRWRdsFi00lfgaaEYG8S9ebhz5UtgAoQxOnWedmp2OxH8N1qk8G4kvSZAHlTP1zhJQ
 jSo5BV9D
 ZqwOvtQlt579MJDT7taVPoMxUxLfetS6fnnhFf8A6EQ+xCymK88qKlQDaMOXmAY5mYHd61JOscrSDwhpVsS1FbltFa2Ca6mDSSSn65MAqnctp8rU6azMtp2iRTKA+0snIOXf/7RCDYK0ksRcjQnLDUhazTdN5o0yIK3l4VGrfBDEB+7LDpIQzN9Uo8bx9sVdELUwoCtxbDRb3wr78ye8BopJ52CMM672IEFWzrtXfrkWi75vu+7EGtVsvqu3A6hPvnGod7hLQhpQ/t2uldT1lZ65ew054oQB7ldrd5gte3DT/4SJBZpKI32f3gUGQHnDeqfxuC+7rfi9qmiY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/10/26 2:31 AM, David Hildenbrand (Arm) wrote:
> I don't really get to look at most reclaim related stuff. For things
> that are actually relevant for me, I'm sure people will CC me.
> 
> So remove myself from the MEMORY MANAGEMENT - RECLAIM section for now
> to have a bit less noise in my inbox.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>

