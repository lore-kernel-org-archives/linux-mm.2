Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0906FF60D9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440B76B008C; Tue, 31 Mar 2026 04:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0A56B0095; Tue, 31 Mar 2026 04:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30D846B0096; Tue, 31 Mar 2026 04:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1A28D6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:08:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C03D08CC1A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:08:44 +0000 (UTC)
X-FDA: 84605631768.03.E017237
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 51B3140006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:08:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qZlsrNIi;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774944522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EV8xJIqn8NAPK38T98iwmuljhSW4bjva9mw3ateav4A=;
	b=4vsMHJfq97o1AhtDpb5VK2pTyHO3dX9jqN43sWdnME7EHghRy6XadBoGpynGPuGCNelg5F
	GdQ0JEoGqPbd6Z5mB38CMCss5QxtY2aGY7G4cbokamYQrxOCDRyCD5dLrNkZe8YiAvqnBc
	xgHhAFicIDwCT6wDbA6suT1TOst8UP0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qZlsrNIi;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774944522; a=rsa-sha256;
	cv=none;
	b=AiDRUI2u6583GL9p36nvSYCAi28n4fL0TKrLBlG0P7d4vi6YgAIHJei32vczLMumr7WVNT
	Krhou33Ld8WgPfK5bRl3xgCi/MUn+zAIbdrQv0zwFbvMv5h7h4EdSdauPE6qYR2s8oDSNs
	c0Fttgc86mKU4npF1od0+BJcGQLEjaE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774944516; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EV8xJIqn8NAPK38T98iwmuljhSW4bjva9mw3ateav4A=;
	b=qZlsrNIiUWCGDsbamO89trxfeJBpZZ24Lba6vM3RsmN/KHO6binD8ZTX7QCZlRye4+Uo0lWUmuKoHPmz01/e3TLvQ6QIQtI9UymfDRv9MAZ/bcNrdDfTtZbM/Psq7cRYm9UexvcLlSKfYWLgbeI/NN7lJ2VPcMGxFpfucHsK2rU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X03n6My_1774944514;
Received: from 30.74.144.129(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X03n6My_1774944514 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 16:08:35 +0800
Message-ID: <5a9333b4-c2d1-4db0-9c31-b9d611eb32b4@linux.alibaba.com>
Date: Tue, 31 Mar 2026 16:08:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/12] mm/mglru: use a smaller batch for reclaim
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
 <20260329-mglru-reclaim-v2-6-b53a3678513c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260329-mglru-reclaim-v2-6-b53a3678513c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 51B3140006
X-Stat-Signature: puadem3n11t5gdpntiicx8h5ng9b8fnx
X-Rspam-User: 
X-HE-Tag: 1774944521-726069
X-HE-Meta: U2FsdGVkX18Hp9Fo6bOQkmUpIANeAqX4EUQfnHcM3V/H0l7O6Q7jmdHfHy5dcxv2dK0NrXypNu+f2RNlJbXZTA4/50w2++HQBBFqYHYJFO95n2z/JOM25TlEwFCeW5cy26NfD16VP+iQ2yUbQ5BazG01NkrucPDoqoH8xPom8ToHVYZS5fOTn509TiLHcNgzl6NliqDShMMQtg+Cpc1eE0e/GK4jmrCXM3TLimyq+vPqVf3IAbd+kuRHk3dCUjNmhsZiR5eQ8ALplQTTjvPE14/O7w0poszjF2wslXJQ8lNMueTaZGDyCogTMFuEqS8h9ZIbIWDneZ2Z9s5DqnC3eeU41DdHC/ckq/LNv2cNgjRCLuAED/kjnjXeVmcQs0J0cUrRRv3iUz/+11pvKopnesmiJh00XA4qbkGJFYAm/q6aBolIX9Nb1ONEyMwt6jyAj2pkKUdibMdbTHh4QQMUfpOmiMStSYBLtmU6f5sE/Etgs/Eq34RT0pxbeDsNjCK+Cist8CgyKAZzhfdHZeO3mCAimSCp1tEmRcgqR09P4VMzfcV96sOLvNs8t2QE0MPDaCg31iX6qKVz+3xnIqWlbExlaDwl3TVMq1tVI4K9pPltW+h5b3XmxJmgt8olKpDFPrzMa+/J15BMU5DS2xCUoXgZaafymo1fDQLLAS3QvvGBIAd5AavTH7GdyCB76Tkw9AKd34V+KSXcTf0uzp0wZXkQC4wHigaIOu2MFU9IReL+AtGAupUcfACdZghH1Oj9msVuNuptKK8UfW8PFvS0l3DSgL6S1+Owkdf83guCtU8wfxNqzYtMxBH4mwpsoyu3hgpRrbDvgZ928F624bXEChQpFhYDI1N7w6WiM5P8xYhdQ2TZPr5AW9Qr7h61VUYPvyCt9u+H98PSnEfYt7V8s9OPjY4e8Xde4MwJQdref6tqRioNiSZx3UAPqt3JljKedP96Ua4r7avpzTR4NVU
 aF5e9JT1
 rOYf/OMVKrthU1WVofOfyhiK5hE3jmtrLyY9lIBi9BPM+rOTJ5mL9wszRiiI1FIup7y7dA4Acdp6ZKcieYOwdRpziCygFFlsQNna78T/v+ba+xQ806j/8FvzIbqA3oBQzI6DxG6E/C0ClBmebo1BOQqEChfsm7VT4vfOlC6mfzr7A0vw/T5J9oNSyosh5QTwuWFCHkv5RTNG2Ie+w+uY01Yf/AMnSt161VPCg/0KtWObWbCzIb5sEKg3unxdZrKlyU86nsGuTQSNi7eR/luRCHmkSQOS1ye0t7zYkR4M/dvYYSu9+5UqoVZvRxf3GsH0LnwsCNSGPClKGZYzq8lbkuGUh4PukhT7Gy8MPLYULhTK9VudOqPnORcM1A4G9VyW2OzXtS1PEzT9uu4eB1adterXzROMkaX4yT4IY/2CUG74sweGCwSBdqSNnFp6UUxRVRNaNjpeWE5dl48RMEUMCVCXZl+nRu3+JY0dG43V2JLmLEzOb9RCxzLMwig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> With a fixed number to reclaim calculated at the beginning, making each
> following step smaller should reduce the lock contention and avoid
> over-aggressive reclaim of folios, as it will abort earlier when the
> number of folios to be reclaimed is reached.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

