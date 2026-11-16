Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 137AD606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eHxVv26i
Received: by kanga.kvack.org (Postfix)
	id 3B3D86B05B5; Mon, 16 Nov 2026 02:29:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B1A6B05B7; Mon, 16 Nov 2026 02:29:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C9106B05BA; Mon, 16 Nov 2026 02:29:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DB456B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:29:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 785DA120737
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:29:37 +0000 (UTC)
X-FDA: 85440157194.08.A5ADF31
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf23.hostedemail.com (Postfix) with ESMTP id 16CDD140007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:29:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eHxVv26i;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794814176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gslwsSOHnTDJQMthG4yS+2Lt6ZuxgQnoAJ6oPGnvEDc=;
	b=44CMKVWsvow1koUjQPOsG5WTZAiypeoHkyUtEt4km3x/Jfse5QKQT6kgoyySTqVxQFnHCb
	2RfoZXg4JOBwkqtnjjpQVVvYDH27z9oVFRPv5xYX9WipsGgK1uawp7fJjFiATHS4NJsRK8
	D6clnwcHPHE9NnQHkrIAN60MYjzvmyc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eHxVv26i;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794814176;
	b=IjPblNGgKtb0gGXtk8pqw/X0F2oGmudds/h19REociCPAJLAWXIj/n3nMAnfRdAbKjPLy8
	RFSlqPzfV3RgL6eWOvjPyJHjTyOGBeXh7kXEtzZdnusvVySvkqFWVGjQcDTnqoKI3LoxR7
	CGjbm2mDZCiL786rtxfTVzfLbQX/PGw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794814167; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gslwsSOHnTDJQMthG4yS+2Lt6ZuxgQnoAJ6oPGnvEDc=;
	b=eHxVv26iNdbWkQC5Cr4DnOTiL5jWxECShMBsDeTeh24szj0mhUZ7jOh7c99pSrILBqa7yafzGO9JoH1EKS7niUaO2CgPegCfqo37GHf3VeXSzRoyt2uCN0HRxkPGeW2j6IwTdYMFKafiVbB+JRUebcSua1prSCnQRuiScek2WuY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XEnonjq_1794814165;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEnonjq_1794814165 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 16 Nov 2026 15:29:26 +0800
Message-ID: <b6449fe5-a697-4fa4-8985-fff2e0b0ed76@linux.alibaba.com>
Date: Mon, 16 Nov 2026 15:29:24 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/mglru: use a smaller batch in
 fill/drain_evictable()
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20261116061158.333826-1-hui.zhu@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261116061158.333826-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 16CDD140007
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: iju8765zuqpeotqm775en8qze14whauk
X-HE-Tag: 1794814171-428021
X-HE-Meta: U2FsdGVkX18I/dfISXAXAp9r8RDfVdgL31jGgl1PX2P2D8G74LgIegedqDJEIa7brnyAU8BIJq0kxeErowaXgeMGI/liY4vRiVvYEWZNOVXr3T2s+o3/b/FwRpULp1VNOZCVgNTN7eCFY5t46ynurT/vb6+FdOwKu89RwJ5gExpA77YzLz7H1q/H/aSW42PUntNssyH2L5Jjs2PVBZDwkrQDckVQ1HgjlFGbK6T8invh29qPOKqIjWwr7qpPXYCUNH0Q0/8pA4CfmG7Ct1gtIN5FD3LLNpwh4R5i7aephuQl0pylWlIQN1IuHW6vFUtjgWsSNmHibxmB/qem3M5KEfi6arout1nr4Kwc6PZbo2upkv4bFhC00luVP/UNCysj1I4shbQc0UQu0ImKeEPWRQZosPfz+9DQQbOqVGDYZZoYQ3GbUANhqRENYm52zUPby0vhIZen2BsnQcTYvhZnBYFlIqzdpVXtUcpWng+qayr9P6m8teqiNGUzmYoHhjvDjvnhwYAA1iQ9QckxGvo+qHNksnUk5ujtxhPHf+vv689F1EETdTkaOwkghvL9SYPFMcqBSmaKsaUQJIBEkXJxv3q2GtPcufaCSNcsnAYvGfnJ8kohQXnhLMgIfolAYHEqWRlfiMNRSg3/Y8/PQXzUEf8+6p4wHh7DuJyPelqr+3DICejBgWakw2V7JowCZWpIBuzZA0mLBPRyXHXFXFOErsXzeEIr6Hf8TDNep7Pbim3/v81pZTn7/7I3yzYQ74LG/teURWhVI46SzzO6iqwxPZMwLMLKlLcEybhWJz9v56DbNiPhtRplc8mA0mNG/y7oKWG3w2OoXErWvVFGHNgPV7jDkt1DMOAcQIDyyiC8WKtmYvhOk4VA+aD/MRdMGajfxF5vj4ydiEbrNxOxGB23e0+IheAqtJxILgZzYX7yq4deEc2JvuJ33LX6ba7B72PPvw8E/lZEJi1hS4qnx9s
 Z6bR08Vi
 bC8XLVsLwxcsZtp2Kioy+dk+NEhZpG9uQ3J5loRXn+skEZyDKmD5ikh35Yh9VL52RE7ecXIrLz7nW706KOqD+fiXLH4U1qqVmb0ODtc3WZV0LECPDbxSpsis7d/dEb/hawtz7Jd5hLYY50b27S5ENlnyqFagOOVshgfsxmBii47EDcory8Ikq65yXmiWANLxFjo35BJsMojy+vpAqacq/xTRR4xxO3WBpS9fjnvMRbgKiGxMH7mCPsft9O097TveX9X/jf7cgfChxvT/YSWYnIBoUPnTIn9CbePJ/E7YNOUgdOVDoXLuVkYC/MXNogHXxDrh7mdUgoVIhcpcSZMg8tv8iiU4Bc83qoIKg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/16/26 2:11 PM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> lru_gen_change_state() migrates folios in batches of up to
> MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
> keeps local interrupts off for up to about a millisecond, and CPUs
> contending for the same lru_lock spin with interrupts disabled for
> that long.
> 
> The caller already drops the lock and reschedules between batches,
> and the restart protocol does not depend on the batch size: both
> functions make monotone progress, so a smaller batch only shortens
> the irq-off section.  Use MIN_LRU_BATCH (64) instead, bounding it to
> about 15us.  This is a cold path that runs once per kill-switch
> toggle; the extra unlock/resched/relock round trips cost a few
> percent of wall time on an otherwise idle machine.
> 
> Same change as commit 6e9be217a3ce ("mm/mglru: use a smaller batch
> for reclaim") made for try_to_shrink_lruvec().
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---

I'm fine if the small change can fix your issue in this cold path. Let's 
also see others' input. Feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

