Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F3A2109E54B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 06:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8270A6B0098; Thu, 26 Mar 2026 02:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE566B0099; Thu, 26 Mar 2026 02:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C036B009B; Thu, 26 Mar 2026 02:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9B96B0098
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:25:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECC925A8D4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:25:11 +0000 (UTC)
X-FDA: 84587226822.21.8557DF8
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf26.hostedemail.com (Postfix) with ESMTP id 28280140003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:25:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rxhh7gRW;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774506310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mls2FtV7WMQu3mL9+qsVNKeDBCzGBy4ttWLxN4SfagQ=;
	b=mp2ALkbRAkphnqAEorWwD6Rv0bxURsrosfA8A8GW7N97eV0Z+fAZUh9DWXVq6X7zwjjjqO
	nrtsQauPkXEr3inMZRhdiiytOld0/x8Z7Lucvg2ILQmD7GcENIH8aZDj71Z7G6t31YhoXh
	bbpEwROL5u66KN/pTKsoUbAF43UBgCA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774506310; a=rsa-sha256;
	cv=none;
	b=e5jiOOXT8D+xW+h19JwzuvNJuIAs7e0kLY0UiKov0Pq+JMwka4ze8EJaueDDzpArke20e9
	Tch1LO2aOm1vik4NNDp9ZZ3aiXn0+rCy5q0uYwnYDR4OxDVj+udl+aoERIwSL7xh4uwB+I
	2HWq5vHz8pirmyaTrCtEHsGfBXMLyJc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rxhh7gRW;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774506305; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mls2FtV7WMQu3mL9+qsVNKeDBCzGBy4ttWLxN4SfagQ=;
	b=rxhh7gRWIjtN9GGxjIgltpoRfzR2NArJP7/ADXVy6dIl4FKZd+SPR+oh7vWxOzb3p71Zn1dzqfJ92OAQ+45YNKR/64m6YrigKDbSoApL094IJU4bKteagi1eZKvIeaCdXJlTjH23ADjtAdJR7TpU2uOSV9NDDbcis3m7Vc1wMPA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0X.kJBWV_1774506303;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.kJBWV_1774506303 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Mar 2026 14:25:04 +0800
Message-ID: <cec03e62-f7fc-435e-90ad-60be503487f8@linux.alibaba.com>
Date: Thu, 26 Mar 2026 14:25:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm/mglru: consolidate common code for retrieving
 evitable size
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-1-2c46f9eb0508@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260318-mglru-reclaim-v1-1-2c46f9eb0508@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: tij81bc5zzn7i74nm3nr8wzwr3k7sbkf
X-Rspamd-Queue-Id: 28280140003
X-Rspam-User: 
X-HE-Tag: 1774506308-369469
X-HE-Meta: U2FsdGVkX19cyuH+mKFAGFjJhdEvRgVi4Y1vQg0IYwW7lmMbqo3sy7TOl5Y1xxcB0oIljRUOobae3VyVCEIuawBlfDANpx7xvU5EVn1ZThZ1ErClTMlT9452Y2/QCKCgMwB+cWTSN/7+TO5Acb8OdGxtzFPimxvPwIHVAtQRQ8/wRL8yEMGyi7hd/2Bpb+eDq6FQjE7/rlSS9HNR4p0jKPLYoQius4E+2W92UYquh3PPt2tJM5kGdBYuqMvaY6igVXOdICtm+vp2izHQcYyCsDrkIgs6/QNBtTtjRuqVhiTXxx0xgrXcLe26tAvVvflc1lKbMNuI3aD8obiQYMbatWbLFhNyuWiPaJeH3YqJrsHXjX9MVSbnp0KBUcZqOcaHg+E+1uCKYboVrkry8JVr3DdlFF6ZtKJ8b+D+b/MKh2ihM0TcohpV92Q591D5GUxoFXP+wry/P6cLdESvy748F3VnI6QNSNIESdG1wYaHZhGSgmmmukP5hhuo5HQGci+05hHE9NBk7PZ/zTnwhG+4IX9aIDD4LhC5+fgAsizgyrj7sJRNvGBwJKxGdvK7cXrkB1W+Vey2jhv4cmR9nhYCYdJFoLmE5A/FkiJiVvtLD5D/UmAg6UK75vUMvzPWAmRA4pXcBLKFPyrmVTP9r64dk0HSm69/CfnNuGnrOtZsMeyVW0BlwMs0dxADCFvvZAhUi8Pxat2CJcGwsMrwWzRhV+0msBS/y+9ukmu9QwUhXckFkF9TDE9gy6+ueJVKBNuucPr36p05l20y/wWOtOiZHtiaOgt0ADL+Jt4cpabFoJJ+chS6XVMxrSGCkDFWNecvRonUNMiSE8XghdHZzBCBP/DRTQk2F8SgJEEoL4M8PEcM3+m31ELYe3HOeLVqpD9pqVNGr2Fv1+KIWuqffse1D3OFZdIpy7D5kHBwj0XNARwOnvipq5C6OdFQpdu1io8F69zq4xdGygWx8ghieuG
 uo1y6xt8
 wJi222IT1xHuoqE704VfVYK0pORbFo5uDdKAS+1mSwh+8CR6eGlCo9/LEV+N6Onb8Sio7EHRuUk9D02YCswE60Wl2wbhTLOWDXCBbQgIh6cBOkM8gUbNzUlPGfvWxDyByNczGSN2BxWsohGeHKN/dzrLw+BH2MnCSGJ+xw04GVj+wntHzh/oRrisuIPAkGerG49HA/Kv5sbdDfmIIB55rlu+cXOlHXrmFjHJB0Iv1gt+ei246e2qenWCgWLYd80vokmMWcmirq7YrAsexmkdMiEuAXmNF3pLV/lFewnDVTv9Wyp8fVbfvTJa76QpwNGLu+DSC+PFKF9WYjywxr5aIlbn1YW/nZgLquNQxxcxAXVoajE4L3x/sfT6qGnv2TaEtJW707LMg2rjMV3o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/18/26 3:08 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Merge commonly used code for counting evictable folios in a lruvec.
> 
> No behavior change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

With lruvec_evictable_size() changed to return unsigned long, LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

