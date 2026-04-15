Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA9D5F531FC
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 03:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232A16B0092; Tue, 14 Apr 2026 23:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E26A6B0093; Tue, 14 Apr 2026 23:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1526B0095; Tue, 14 Apr 2026 23:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EB18E6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:25:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 919A4B7736
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:25:43 +0000 (UTC)
X-FDA: 84659350566.17.AE67293
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0A306C0006
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:25:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yeg8Fs9K;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776223542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H8E3xMwG6jp03zBQXo4a+PQQm0Lb5d/w1uPUEFDcne8=;
	b=zwVGO7YJepZVdCEPVVb3z2U1awapukw7RExaTk58pir8yM4mydEbpJsqMxIis+l/zqg8lz
	QimYeZfM3UUtvzUAlyCANshSJ9fwnK8NExpCWiMkAKZurzRxnoou1k6IE23Y2ap2HmivRC
	+qilkKustH0LtKOyTyoDq8b/1mcl7So=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yeg8Fs9K;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776223542; a=rsa-sha256;
	cv=none;
	b=dl2Q7MXVPciltQerGLt7WtL5/sIsk2U0w5wjtt1i+Cl7v5503yDnq8qpq4koq3Qb+BBcmq
	nKc7zSzUjEOKF7vy4PPZwS12Wl9Z6oRvJDhFfag+pZC2uxys8JSnw5Yt6wiQS/IWzM+D0X
	NJOAwQsBf12o84XVpWfGrnCLbFOkpqo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776223538; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=H8E3xMwG6jp03zBQXo4a+PQQm0Lb5d/w1uPUEFDcne8=;
	b=yeg8Fs9K6bFh8xsFKWjJOMfnBv+LdbcYZZQyCLMRp4NZkWb2lTlDCD+YyYdEy+PO+k+JGMnXdvB+1RxPod1htVzvVSiSkWKtmU+sPw/bPcfLQfWk3zznIf1InaPVG611hCRxSFomK+hdFvovcdTvmFrkns/JPedvu5BiP3OU11U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X138zqv_1776223535;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X138zqv_1776223535 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 11:25:37 +0800
Message-ID: <a1104a0f-7a9e-4a94-ad57-227b78503024@linux.alibaba.com>
Date: Wed, 15 Apr 2026 11:25:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/14] mm/mglru: simplify and improve dirty writeback
 handling
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
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260413-mglru-reclaim-v5-10-8eaeacbddc44@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260413-mglru-reclaim-v5-10-8eaeacbddc44@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0A306C0006
X-Stat-Signature: 1izhiutn98sj46xak3cpfmkd6npmdfdw
X-HE-Tag: 1776223540-527737
X-HE-Meta: U2FsdGVkX1+YVnmZtwuaZd//ycypVFhSeYgHDedbIZBex7hrvD75u9n+ShoSnEwIyDJ+wbVlb++MPX5KjcHB5+Vl3eiFmqS+4fdEOhI6PGuBX/7+BgemmGyn9y40nbec/ziptzBEIA0BeMBmGOLhsyAvbmQwjMuRB2DJKwnsNFWOfRjHcsLAqQya6XizlwRqf+fd5Ra4/pkOILFKdLqnvTOL9qn05C6TUHrMwOoOCNlCajHJoxAj3K184ftjDDwmB/u1YHZ4T3oUMu6AGY7Ns07CWt0Gs5ZA+pNJSLNKWFytr0BPNAfReBcGrYYpJXj3v+sYJp3j/XXDuTAkefsPkuCDnheRYvY83Ku+lAdsVYVL8fRzTXKNbCwDoePix12nQAiWv7op3A+ea+jbiqxcfLaRsF82RRu5GwAxYsXo0qm1AWVGRIsbtDE9MUB82huHJoSi3Ka0ORNXr+uf6cahmodDni1dN4U/Dibofn7Ht0SbTMbSV16oRqpq9+kXG+eaKmRdaDblWQN6/9UM8Gy7q/J5R8wZE7pscNqtNob6Nng+Gybatdx0xAXxDHCbogZOgNE1QouYBhICf8LfuZRN7h7ie9apXD6Ocz9uhDMgajGPRoV/+CKFctdnqA6EqOc6MyPffc5a0kScWPxrzoPUoAejGsAJHw0k7LnoT5begrxvAt9Jr0nptkfeeOHNlq12DJraokK7KMGcFNKsQoC6fXOtnfYTD5/+WwPLmlv+oAMKKAwPBEcxmrQm5k+m0EEBCQjW+6+QP+oobo4bePzClqcvw/BO7d/U7p96lj8fdiMA0ZBoTQHBJWnqjUMvnVDcUMD+vfmilN/su/lcWYJ89sz2yNADWJVPL99MUmoxeKnT8LdWAX17R/ei1VvCuO/FvblGhk+1ph5JypEr/yfRMXlBqmudVFUZ8TJlvqvJLHQd01qQSFxhnhMMfytRx+/3CJUf0ZYFZ9SoaHnc+9q
 NpwmNon1
 i61khpCxQaE290nBlolG++GsVUaJOnfggt1/J3jwMynSapCjEe40wN+oc2TuKnBGqA7H6bQt22JtqoInm4MnKlx9rdOempKX46jZguOK6NpTIDXc70OR0stTGZRJhQ002/CN7ynNWrFCZtmB/+ap7DTCFSWy0hDLklTWK7mveiz3McwIbBAGkwL11qyebLXTy5eXt+5sCEQPpeZDgkHPebzZXBq/NT9U2oyi3NEFHGXc3xa+GqVmr+d6OgFl+A7JB+NPmI8YrF4dY1uytgR0SSk3FSqIJQKwxxGqRWO/OKZls7e/lxl5GKwU60DNc1bN0nPRdvU79j6duJoP9t5MHzHZuaK9cHfeY0tJxjDK0PulkFFBIxpPgffkd5uJiDCxKq1fDx+Q5g2lFehzIUQ0Y9RWyFIJQbr6WSBW4N6I6Yor1M2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/13/26 12:48 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Right now the flusher wakeup mechanism for MGLRU is less responsive
> and unlikely to trigger compared to classical LRU. The classical
> LRU wakes the flusher if one batch of folios passed to shrink_folio_list
> is unevictable due to under writeback. MGLRU instead check and handle
> this after the whole reclaim loop is done.
> 
> We previously even saw OOM problems due to passive flusher, which were
> fixed but still not perfect [1].
> 
> We have just unified the dirty folio counting and activation routine,
> now just move the dirty flush into the loop right after shrink_folio_list.
> This improves the performance a lot for workloads involving heavy
> writeback and prepares for throttling too.
> 
> Test with YCSB workloadb showed a major performance improvement:
> 
> Before this series:
> Throughput(ops/sec): 62485.02962831822
> AverageLatency(us): 500.9746963330107
> pgpgin 159347462
> workingset_refault_file 34522071
> 
> After this commit:
> Throughput(ops/sec): 80857.08510208207
> AverageLatency(us): 386.653262968934
> pgpgin 112233121
> workingset_refault_file 19516246
> 
> The performance is a lot better with significantly lower refault. We also
> observed similar or higher performance gain for other real-world workloads.
> 
> We were concerned that the dirty flush could cause more wear for SSD:
> that should not be the problem here, since the wakeup condition is when
> the dirty folios have been pushed to the tail of LRU, which indicates
> that memory pressure is so high that writeback is blocking the workload
> already.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Thanks. Makes more sense to me. I also did some testing, and seems to 
work well.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

