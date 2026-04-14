Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53FD8F531F8
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC5AF6B0092; Tue, 14 Apr 2026 03:46:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C7A6B0093; Tue, 14 Apr 2026 03:46:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA606B0095; Tue, 14 Apr 2026 03:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9FAA56B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:46:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 446D31604C6
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:46:35 +0000 (UTC)
X-FDA: 84656379150.16.B60C2BB
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id A102320009
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:46:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776152793; a=rsa-sha256;
	cv=none;
	b=XkKgfXqWZr2Oz9irZiHCR3p4SxyFMmHhp1tZHHMdnq0wiwxmPI9u3V7f0BzuE9j4jq/MEf
	XXXJP7gTLf1lGITKSbUdNgtQp/f5KxNOzjtOHNrquSdqUrEy/xGquplPd5wvFk6tAese3m
	DbvCelwGwBKOWw72B3M1pxidfpybFAg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776152793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QPkiXwrGpAqxcD0du6t0azYCpI2UnbEtsBEGgM7HCe0=;
	b=xAqJLzL1FtxmRXAfUgi9cHI5VryEKgF9p+FKAjxdu0pehl8AxCLLOFSs9rhseBX+DlvB9/
	uXpGFEOVrsqHiDyX0vSIxj4e7TUt3xYqnTnlt70KeB1Fc1pDDOFltGajLblBRklBmgIOGO
	wKlzAvOR1YRKNHzZEU2IvU95/VavtHM=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fvxCY1Lr3zYQtlV
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:45:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 2CB374056D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:46:29 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP3 (Coremail) with SMTP id _Ch0CgAXErzU8N1peDpsAQ--.17S2;
	Tue, 14 Apr 2026 15:46:29 +0800 (CST)
Message-ID: <c82dd23e-1d02-424a-9cfa-605f69080ad6@huaweicloud.com>
Date: Tue, 14 Apr 2026 15:46:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/14] mm/vmscan: remove sc->unqueued_dirty
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>,
 Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260413-mglru-reclaim-v5-13-8eaeacbddc44@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260413-mglru-reclaim-v5-13-8eaeacbddc44@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgAXErzU8N1peDpsAQ--.17S2
X-Coremail-Antispam: 1UD129KBjvJXoWrtrWUAF1xuF4kXryxWw4xXrb_yoW8JrWxpa
	95Ka1UKay5Jr1jkr9xAF9xZr4Iq3y7K3W7trW7Zw1UWasxXF1rWryakr1Yqrn5ur97CFy3
	AFsruFy8Kw4rJaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jxOz3UUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: cbow34x85qq861yxwgm9eqheygzoctfw
X-Rspamd-Queue-Id: A102320009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776152792-676286
X-HE-Meta: U2FsdGVkX1+cgD1bnhSEbwIOLCBhAjhldIIFA+YtJW8GHZX9b/0tT10lBO28KpOsNLm9Ih/r8LZIH9/3NMUNYWgbgBPuAqqRmxPt4HofqpI3jKqVNHKdktNFv1ALHy8uiwu1yhVSfLDRIUnR1rPrtms0AVHBUr/0n/DkV8a8vt1ofgp6o9I7JNZfnnysAXGsZcMMCDhCJnpt+xBW6qIsPn0855elrfrxU9FjfFV5Uh6isMYJ6/oWhKKpym5yFysf3ppe8FkgH3cBDBrX3MThu5kJUflb5aPHyIedzYxLrXN6GoqR84gJwzQrfXPTFGCvQPN+EZfQtlFdtdmqqQ23ZM6X+lHFAMwBV7F0R9bmpv3s9q6OzM6zYVhUM+5p7mpBPX9f/G9OiKx8TV9g7Bs1EFJZKnNhf9QBHvy3jNdsSiSN01f5FC7c4ln+YYN5Rnu1nXXUzeJO9EJeZ4uLhuaGUJhNKYyjwHykIYBIooEbOJ/aMQdy4CfFET0K1BLxn2yoGEq+xNO1zxb8bigPf6XpFCCD/N50Mjg0sPKegi+BmNQTNpz+8Tz3RY4zbjPYdPJKRdoy3xzkPWQg7Yj7iB6+9RJEeCr0C5qmuxh86o4NFdW/K8i4MiHezG73WTjy9fy0zu7I2VZB4wRt4kRpceOE921LnIOkcig6FqEAApBPQarEQ4Ryt4F0laTniazKq/5wHtfdz1H8XrUGqVB0+YcTHMiW5UF9XNxxQilLRe+fGAWK9/+L3C9rfn50xvEhsNGPGml4aUtVu+eA8s15rv9A8mvras5LDacdqZ3Q+JGqBAE+UOaLWpuAVC1kvltyxSZdgFjhOsJbURHXzvbpdXCEl33bTDGMhlyzjiExDXCvMXg2menVaMP+kvKuDZG58ogkO5nRVNlzJZ2I7zQFMxP0lS4N0BhvDMnISL4JRHdJUGZb31ZgPpMxorl7mJT31G0moSV2B/d3QcJKpw8yXq0
 4Gjd+2kw
 WiUQaUhZY49oZiGqY/mF1dEsYMZf2WJOa8y2MjFNKT1sAOVa3OQUh9ibD8lQkMS7wNJRzkf9Pgu2qWS1spAH+O+Rs+jETzFSdA3KGl69ArNaipEo93tsmKwFzR9vA04N2SaPDXfY5Jn1xDBtlHWEjL/Pvb3/c3qjNjFvoDiED7vDAOVGBcyXKeR+tL0rYN988bwRgdsnrKOE+Tsy4uuqaznHhTYH+hhP5sdiHkKbCwIPFNbdqdrdcv8k5abVXwSCi75MEFHmZ6FhWnkp+ypWgP6mBPugAvedWoRM4lZyeSyphCqkrJu/FaIyYx7xzANo3irymS4I82GiANIUwTzngIec8mkAcZZq0vwzzeOH7aeCCuWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/13 0:48, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> No one is using it now, just remove it.
> 
> Suggested-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b0b66c03d4dc..a431f94ff3a3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -169,7 +169,6 @@ struct scan_control {
>  
>  	struct {
>  		unsigned int dirty;
> -		unsigned int unqueued_dirty;
>  		unsigned int congested;
>  		unsigned int writeback;
>  		unsigned int immediate;
> @@ -2035,7 +2034,6 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  
>  	sc->nr.dirty += stat.nr_dirty;
>  	sc->nr.congested += stat.nr_congested;
> -	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
>  	sc->nr.writeback += stat.nr_writeback;
>  	sc->nr.immediate += stat.nr_immediate;
>  	sc->nr.taken += nr_taken;
> 

Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>

-- 
Best regards,
Ridong


