Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90302FF495D
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 07:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3ED66B0092; Mon, 30 Mar 2026 03:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16616B0095; Mon, 30 Mar 2026 03:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53706B0096; Mon, 30 Mar 2026 03:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A3E036B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:59:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5254113BA0F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:59:23 +0000 (UTC)
X-FDA: 84601979406.14.8F556E0
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2601D40003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:59:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AXPYtrdY;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AXPYtrdY;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774857561; a=rsa-sha256;
	cv=none;
	b=dRUXddH5l4/qfMQqkW0CoRpU9/GPFKUu5ztMkM8k5iR1T7K1up1V691UJUowMl8+GxMQ8Y
	oCCvjkQOMAAg7Sq/Ahqvs9Oy+1QmBxipozv3bP7YX1KcJVwJrMLV0QLX9mAVYsCdKFEUWM
	4iQTillAS8dEDqMRofrbl780QVA57ks=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774857560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDES+AFFgmGvx0gQMExZ60voHnnQ7hBjinDGrfhyCrA=;
	b=ejCFoMAVAWssILka/47YEPw+xcA0E45IbxN31VuTClB8mLsdlaTzynCumo9bKlgwGAA5Su
	2UoSzzyHNdrCE85B1VNwHhsI2jD+I3Rxfs1I9DUwo722XLTJXbrMRYVl1uGcZz5gBNzmKY
	BGzVfZ0Lhs3oHLypbp9raG4AgEv7LpQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774857555; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GDES+AFFgmGvx0gQMExZ60voHnnQ7hBjinDGrfhyCrA=;
	b=AXPYtrdYJjVwrUEDgO1lTwrWPcJwOhBTzzHouuhiCnHpIfb9xowiicMQwUZ5n4FUCHx7PvrhZl9EP7brAKF7G1jzwFhS9USv5x+N0+UwKc73DlbvccErHWYFC2s+mpUB9qrlgeEH0eN5cJW1ajhmEhEklU75k6ikKVXIE4TD14c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X.wCb4S_1774857552;
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.wCb4S_1774857552 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Mar 2026 15:59:13 +0800
Message-ID: <dc97a330-b83a-4f32-9bc2-f996fdc33665@linux.alibaba.com>
Date: Mon, 30 Mar 2026 15:59:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/12] mm/mglru: rename variables related to aging and
 rotation
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
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-2-b53a3678513c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260329-mglru-reclaim-v2-2-b53a3678513c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2601D40003
X-Stat-Signature: 93xie7qiy7ko31hwbybiupz1nyirbrjo
X-Rspam-User: 
X-HE-Tag: 1774857559-299280
X-HE-Meta: U2FsdGVkX18hq+gFH9//tTfx1oZKnZye4MGdIagymcBwcB8Epq7C9NDeNRSFz/pAVUt6UV9iUTiE/qtFGtpcAbE0x0dSmiTKtZv9FUwEaL5/Lfy3ko3MoOmq7q9a7b+hG/IVOv6pX5E71fwu1EfZouH9BG5Xk4LPmvs/thmRNjuZbS8Y8O8vyEYb6E8qENEEJkvZFVJWHSRJZoWgXJuDjBexshEqR+lfFVz/yCk+AqRWvsTmhPxMgbo5AiC3HxNZMZ+ny7jcaatUxsOqLRoiNmYdMg6GSk3k8fgowl/Q16AvO/hD8ddvTyrPDRnbYwkJShsTmWKkPpMICIesy7V6YRg8zwhV6HAH79j0OXFfHJUvReCEhuKVAmr1LDsXU3nYF3RmSLlhNYaQrjohb2lVtDF5ld+XX9Ygbc7FomBr2v70Ieq7o2aYCF6feEbu2z69YeG6of8dSxTF+Ra9MWsQgrzk6d8V5lynsijI3S88LTvuNIEbdWbYolpdBUBNa4wr8tXeAuQwIF3PchpaUPhU1RTTDqF8re8WDFcq8skS6L2VI/49Pzk0KiyVTZOfcTUOKKQCgGhdx2E04FymYDi0bglr0Fd7ERejKJ8nFW5Ot2Jd1ZL1BAVlV35Y4EAZ5dZtHpKEOPCoN71sTvbzZusp8AqVeaJXT4AxctEWGyRlWcJh3P6p5u6T9pwjaKDa4LjtLvTM90iNoOx6e9rf/Lht9Zi0oKFJc5GiUuA7L3O/dFCYLMoZkFOUDyKOtzqot8o/zH1y4d6e/bIvB1fBUoDTGsDkRrowNIVk0sa8G5Ggcax2BmWqIzfPaGo4gLudwpGaI8IxvP2L6waV4MBxGqKq+oOYBMrroHmq6rWQS1eXcq/DPxf7U+2oXbVEY+yjCxEpUtheMZtQ2JmGOYA2pUbf9R3pbTld4ZgoJEeAOblemXLpfCrXo+mKNBAuKBp+Yc0P6PfMLgeh0ydjuFGtfeC
 n6vCS1Qs
 odZZoh6prcZlD0ac/Ac2cCADyVJiKrvqXt0wne34SNosn2SKKCybCvyslZc9i1BUfjTnyBmws/wbJbZktI2RHbtFWsB4V8nOGmqnW3n/nld5ytrLQku43nS9fr3CW9ArxKhdb18Z9pU2aIujKE+h2ZgkCAPSKLhUzS0HqBHyib5K923uQ9xU7KW7aNQ5bYyydIHs5ucNt/QUOfDNdj8Qzy1BSSHdt019ThvjnNBVb7ZyjFsRZ37eicJfB1WSbD+zqr+Wn3q0eIWky6QA6xzQq2zc28kNLxBKL7XfVEfBQrTPDnKrx2pzK6gW5cfmWfRvoXtAXLSn9of1+w/tWpP2ObL/pE3cPxvv7Yd50KWdtMlFV7wrlPp7xAscyIHm8omIPQKiBszPMkIVMnQlJ0tRTs58DsWmnFvVrvAaJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The current variable name isn't helpful. Make the variable names more
> meaningful.
> 
> Only naming change, no behavior change.
> 
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

