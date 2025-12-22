Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A39EDE6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 07:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0119B6B0088; Mon, 22 Dec 2025 02:44:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFFC36B008C; Mon, 22 Dec 2025 02:44:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CBA6B0092; Mon, 22 Dec 2025 02:44:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD0416B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:44:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72F31C12C9
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:44:52 +0000 (UTC)
X-FDA: 84246320424.23.CD282AB
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2703D20003
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:44:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766389490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p60dGUVrEQY2tfdX+7UhzW9mNHqnJjlFrhEbjWcowVs=;
	b=tzYFcYDYsP4Y4abtOkQD7LrkuCaF2gW7s/urguIiUOYWkXC2vVM5fJfFHRQvXujyCgw9J8
	FtWbfasIW5iy5XgzhqTDtz3O3oCKV9/MDjRnXKi4oRFVAj1+o9MfQV6FxEBn6D3dTM/jeW
	avB61f4Wf5uEjuOP8Pb4rpQ2P1etGf4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766389490; a=rsa-sha256;
	cv=none;
	b=UPP/pIuECwbBvIY00DnhYvoTT0JcbYXWu/lTugBMmrxa4scA9n3XSu4t9xvCQijqUh119T
	HqRe5R0gznBVE6kxNEAL0s63lLIbX1l+HcuhLXxTJ39ue88yoC0+MoWcu1WYZOK90mYniW
	x+mAgNTSpStzpepW+tddr4Qf30mVsmA=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dZVXD6FJbzKHMPd
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:44:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 4EB524058D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:44:45 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP1 (Coremail) with SMTP id cCh0CgB34+js9khpkz4zBA--.9566S2;
	Mon, 22 Dec 2025 15:44:45 +0800 (CST)
Message-ID: <b945a2e7-6347-46b9-b06a-60ad0691201b@huaweicloud.com>
Date: Mon, 22 Dec 2025 15:44:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 3/5] mm/mglru: extend shrink_one for both lrugen and
 non-lrugen
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, hannes@cmpxchg.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, lujialin4@huawei.com, zhongjinji@honor.com
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <20251209012557.1949239-4-chenridong@huaweicloud.com>
 <7oyimceude4iqtc6z6e2l2l2em236qa3s6r5daf4c64mzmafp5@s5ayqhbow7s4>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <7oyimceude4iqtc6z6e2l2l2em236qa3s6r5daf4c64mzmafp5@s5ayqhbow7s4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgB34+js9khpkz4zBA--.9566S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr4kGF1xZF47uFWUZr4Dtwb_yoW8JFykpF
	ZxJF98ta1kAr93urn7tF4UWw4F9r13Grn3JryY93WfAFyDXr1YkrW2kr10vFWUXryFk3y7
	Gr4agw1UWws8Aa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	j7l19UUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam02
X-Stat-Signature: 16z4xxbafmqkykycdwxy1zrorqgszrdz
X-Rspam-User: 
X-Rspamd-Queue-Id: 2703D20003
X-HE-Tag: 1766389488-304673
X-HE-Meta: U2FsdGVkX1+SzC9lEeGgwHuu5lvQSQNy1xQwc130Fvs8pfQFbgeanRVMVYMVuDO+7u3U2S2kL925keANLpzTPM9uhn/NnhZBOh4ItPHMEFGle0atFU88b1A3Z3xLNpW6wG3IajFsPfBeFn0vCXyYo3CPJknFHSeKHnV0HllIb9YwQrUOt5YHqwAz7PtlmjTpgTfGBtIPQySVaaiWiWQ0jD+xtsBVtRw1Ri8LSXDo8daK8zRUlDYtxM9HsRe/d8t6OwkTfi1Hg0A/szi6VjNTD1munzanTcpcjWfsw9DzfTzyxGhShGIozQr/CmZ3otoOYDkCNh/FBJOoOK2lhyO60Y9NzbZyrr5Cz3uzZw5VsgEEMgY/K5b2qUPpYu20ENMsGn/rIm96Wbso+S5p8b8JOJGxOZaffXVPvcspdY0dUec/mBIfB9X9rfX9pnzbrUZbXervVvNej/rkDvHfKL9rLmmSuziBoalOo3ddKiSPzr+8TRQKNdVjQgBWT/5NFv41k361ZYwSShZQa/G6NXtFP1ADysVI8o2Y5OVf3dYyKyMeQs6spy1i3+reXPeY2suynIfy79DmK/v877vXEUkhrzOka+6ElVAZoe1eFiruOyMqSOi0bZjKD3PLvUTzHj0+OuT0g42JNfTcDPXgHONnchhRGk8aXNaewWqZSUE3E0lbZIZAX6MO3fLYXxaHz9vwCjLK2Xwss3OI7C8IY83K9ie9B11geKsAjU6IPr+iARRN/sHf2FgiHc+HGskIo+PdCfTIQuNfSF0DdIUYbFCYqkgWqwuSam2HL7hyzmN2eabgntjlYD4+u/vprJGeoSalkMis/qigqCnbt12nEo9DSZlszLuz5LMwwTlhE6x1dJgflMDs9VU5A1X2nJ+NlCPhFY17tyzjHGti2aVB+7WKj8QM1JsToGxsYxQSpA3AQPONSesDYCjhLjdiBjxXuOpym3aaaG3+tMVF24yWead
 h7sc4yrt
 6GMFigAfBHBMa77u9VIbmqwhkEUw/ISLg+fDAAE1bvorflYGk6u7TO160QL+8d3Pwg496Zdq68RMdI8q9bqJPOQQuQZDpd55dw9xTS2LEvkt2sl3rHvyujgixQULnZ4OW9SAitz9QpoHV5E0VBLJZmRrVk0wrUd6fQoi3/jZdbf/EQSiPlx8/7tEtysFhrEMPihWz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/22 11:49, Shakeel Butt wrote:
> On Tue, Dec 09, 2025 at 01:25:55AM +0000, Chen Ridong wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> Currently, flush_reclaim_state is placed differently between
>> shrink_node_memcgs and shrink_many. shrink_many (only used for gen-LRU)
>> calls it after each lruvec is shrunk, while shrink_node_memcgs calls it
>> only after all lruvecs have been shrunk.
>>
>> This patch moves flush_reclaim_state into shrink_node_memcgs and calls it
>> after each lruvec. This unifies the behavior and is reasonable because:
>>
>> 1. flush_reclaim_state adds current->reclaim_state->reclaimed to
>>    sc->nr_reclaimed.
>> 2. For non-MGLRU root reclaim, this can help stop the iteration earlier
>>    when nr_to_reclaim is reached.
>> 3. For non-root reclaim, the effect is negligible since flush_reclaim_state
>>    does nothing in that case.
> 
> Please decouple flush_reclaim_state() changes in a separate patch i.e.
> making calls to flush_reclaim_state() similar for MGLRU and non-MGLRU.
> 
> For the remaining of the patch, I will respond on the other email chain.

Thank you for the suggestion.

This change essentially moves only one line of code. I will add a separate patch to handle it
accordingly.

-- 
Best regards,
Ridong


