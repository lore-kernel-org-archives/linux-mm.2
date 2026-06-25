Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81798CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77D986B0088; Thu, 25 Jun 2026 04:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F0C6B008A; Thu, 25 Jun 2026 04:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6486B0092; Thu, 25 Jun 2026 04:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 394F76B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:10:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3AD71A04FC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:09:59 +0000 (UTC)
X-FDA: 84917711718.03.8163A8C
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	by imf31.hostedemail.com (Postfix) with ESMTP id D7D5B20004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:09:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=WXFlT0yG;
	spf=pass (imf31.hostedemail.com: domain of peiyang_he@smail.nju.edu.cn designates 18.169.211.239 as permitted sender) smtp.mailfrom=peiyang_he@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782374997;
	b=R6Gtw/4vwj7lFRSTwuqDED9pb83BoO7kjYUvS//kAU7xCwMcmFlAr6wSHs408/xmeaweRe
	LmpOsZm1WWA2Dc6fxoG8vShx90Kvn0gJ2WtWK3BzIBQTTMLRQOj712ha0QwdBH+UxOWcLv
	TSIfXLtLQyWq+G7rX63srSw2ZIE3XJM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782374997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zyJK8B23oxGHn172N926QO3i+pQ6Sz0c3dJ9gVTZyOY=;
	b=cCbrpbEs0a+pP+glxj8cKKSCKXPTltHmWtKCt3aQqo3zBu/EbxrT5iPI5nYSulS8/24wXI
	W4gdbGfApkytm64WxRFoX3xfyr6As5DWNNmNFGAEqDfI4BpqcMsDVkKSCDpLl44CaCpv93
	ptrwvYWkQTF8k1I4W88UvGEUBLQfOmI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=WXFlT0yG;
	spf=pass (imf31.hostedemail.com: domain of peiyang_he@smail.nju.edu.cn designates 18.169.211.239 as permitted sender) smtp.mailfrom=peiyang_he@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1782374959;
	bh=zyJK8B23oxGHn172N926QO3i+pQ6Sz0c3dJ9gVTZyOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=WXFlT0yGKnu8oYP2Tc1oi+YHNFVHnwdlJECeofDme13eVVINIjWK+WTJix7DYrLyU
	 4kFI1oeorY8ge6t5p4hUG5XZF/x8ojRQ8G+HG+xKdpUM2dlH3LHoNYJEgr0/2idLSV
	 CdNJhQlLFSi8OSrOXoXc2aX6sEnd/Bh0g9W9ZNlE=
X-QQ-mid: esmtpgz16t1782374951t0fff7946
X-QQ-Originating-IP: wulmzFysRr/NFb0J+WJZNEgu27wUdpLE0vGLc97S6cQ=
Received: from [172.27.139.54] ( [218.94.142.77])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 25 Jun 2026 16:09:08 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 16784617416225829723
Message-ID: <3B3C2386FB8D946D+d8adcbe7-ccca-44ea-8298-3dffaec3826a@smail.nju.edu.cn>
Date: Thu, 25 Jun 2026 16:09:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Qi Zheng <qi.zheng@linux.dev>, Harry Yoo <harry@kernel.org>,
 akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 muchun.song@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260623024237.45990-1-qi.zheng@linux.dev>
 <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
 <d97128c0-7d89-4b5c-b891-84f9af702fee@linux.dev>
 <8a76aefd-629c-41f3-b365-aefd4cc1411e@kernel.org>
 <7946da94-dc1d-4cf2-986e-466c378665b6@linux.dev>
 <dfe5d773-2992-448b-a6cb-ef633714a08f@kernel.org>
 <1d638906-6d64-4e57-a181-4b77683652b5@linux.dev>
 <b5c85cea-5daa-4690-ac41-a6f5aebd1555@kernel.org>
 <f18bf1b1-ccf7-4d77-9389-07311d2d1613@linux.dev>
 <1d78e1c1-0cdb-435e-b278-670bce9148b3@kernel.org>
 <1db11ccc-ae05-4b26-b360-c34ac9f97299@linux.dev>
Content-Language: en-US
From: Peiyang He <peiyang_he@smail.nju.edu.cn>
In-Reply-To: <1db11ccc-ae05-4b26-b360-c34ac9f97299@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:smail.nju.edu.cn:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: MZ9nT4l2hsxVwPC8k7WMIZz4jueQsU7F/Fl1LkcSO0GJiwo/yxskLyy3
	b0DL5mwrVBHrQ4vKmaME+W2rDemDsogSZ74eFGePbdlk43abB3s5PRkv1t8oGuX0WpOc/Cw
	DN4DWjhx2u8/f6G9Z9CL4JRC8n25JUMzrOIsqYJ4deIoXl5nNbehzUCHvG8hniBnuxj3Fq1
	u5agajvlgZR7Fg8rvDrskYeLfYKcxMruxrxzh7cLln436F7mKQCqy0pwrUtDXMK7W2hNCou
	hLC7z7AwIp/oyZynpvAZL5aH4Ca0uN5Njc7UhtKmuYOsgGNfWRh+aKfTs86nonqj5+kinKU
	7sO/SjMRAWcl52TkFBnDeDHGnYY4Uis46iJpzDsaiqWsriOJI+1NRoDtZK+W7ycvLulqIVT
	u42jVCAq9/gPz/FbObJ0f0Nv4qAaVL3ft6nKQr3XkAishblQcIwRscLPEorL6/tsHE/M4UO
	1AwuLwMnlzakB+3bu83LlG8XWQ9Sfi1VbPDzP8UrtbtIqClMXQRGeWoLsCXmq4jDBIc7Mxo
	6ACnqAxETICHn4WnGQmGpYjF6JaQ4z2YSpFnmtl4tesz6gxNqElM7v0jAgcKpdP1zeylOpK
	WXbVxixlcZcMw1rInjLO4MfKO+YpHc6PHrU6eY/iV2WDeDpwPz9gUYwxjshKjdQCYJkxIYp
	npmo+g480FyRNJS2hadxy/EPWt/fptviqMBtQlz09TtsNZck1L1sB+JHEJOlCHp/UFen6kX
	F8yUofWSOHf1YhAEgIQPWfavBjRFgSsUl0rtib0pTRCD45SQgQClulwiDwtxK/+lWFRZ8aY
	HakkzRNobKtYEHFelhP47B1ezoUgXhBpcrTbYMHhIdFnbTxAIcevP6xHOcT2tGH9jDm5Lg1
	JMnY9za3cLaStfNBQh7bK0n4d4uO7ddQWIyowZTVgBx6Uw58yZG+QAgAyBRdc0M3jivwDSd
	OE9giTXVQJvVrGF5Qb2VWcxC82TXL/GEK9yckGn6jddWUwrY8+c2aKkUK4jr5Yzj1xevN8F
	OdzdrW1lDIbZzfbgTHc15NuU5gTEYOp3Rfqv29yp4zOKmf22EDubGjdERuXBxxB3s8IWHpy
	knTmXAkRSVZ13OM8weC92cWOYCFs4n19jZGTDVmuuiD
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: 7ooruhjx54e9c6sb4eddb8duru13fb9x
X-Rspamd-Queue-Id: D7D5B20004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782374995-975097
X-HE-Meta: U2FsdGVkX1/HItxUKlTUlGPvGW1WWjgRJ8IAKBhXS0bnLbSXCenXmX2W/lJokCtu5fdkqQueZEqDrY6FasNfjUTLSmmVLpPz03vJKKtitbI8XGT/3TtmN6Z6+AfsJv3fReK1R4pUx/UviWS7FMKusHLI6XzKoDzc4zS2pyQ4DKoQbSXhfwevHfrnmPUYwA8iyGTrQlXyyLBf0HAfP3A16HMvJU2OwnsYcg2B3jII6317pLEQTg1YObpm4lw00gO3oOMywKfUfPI5wA47Ki+L34PK8IYyo/U5DdMe/al5L7dXHsZLSxTr2o3co/xyyi0hEkwibXy8rxUy+oeWLixndiTgfV6bps7AjY6ZgIsgvYXho6rSUK0dCoR4UctUuE64xIiDefDb5TZyNpiVQytTY36uf6ByV1X95WGSl08g+qJp/xTCNoe7drS0FR4iB7EIHMnBldYfblZ8iLuKGvpzZwlRBaF8+w2td43k/Zp4JKSK8wN+0u6JTAf71fRFlqVOu3vSJsDIrRg2EaO2RJnK8Z/5L+wZ71FcEYPlg2QDSb7cCHxLqfUOBZLMF3jygZSL8c9amhZ+7WVkgTPKrnDgJbX6CsiBhaWsf92/HLVJC6BwBZQmMUBWtmIG5UThQIJRKYXBw98R3/GuAckx7ry+SVNA4RCXUynlm8KI4Jeovu0XvCaTn038BGStHlTezuONS+uoLLRAJLBWLD1gPi1JOcJW3Ghs4P8NYTM8Ht359FZDld3HEnd1Ls8RlDvzQLUCJpBJNM5HmypmPToZ8VUPfAONcAcTbcv+OgovoPZEQ39WMWpw0cM9pEU/5m7Or2hvqh8zUkAVmaA/duez8wXnIhLyqsG6QlYkt193fZWu2M81S4lc6AMAEoqF4nbYQvQm84v01Kb0c97geF0QHxeJr2zLT8AE2yIBCHmJG2LpsDCYHVj622gy+SlI/bLcfMHpAN39HDJMErTGHgpma1+
 Uyi9r94x
 cXeSDQMAn53WfNoGDjnY/uARrldLgj5PNpIZpkRstq8q7/mSyq6wcxPyEacE/nd5Pw1fJ42FXDGswJiuwwc3iBpbu01WkZxBpm64EV2dBegQwQbtqa2cwKmW6l3+OqnnbniTihK0Yo02LK6U4CqN+3DgZvY33EvVcYW8dTkFBR0ymRytf5LaJE2pdOCOfKsC18wQCkrOBca5WMoN84ykLT++uluL0Kqn/m4OUpvKDwrNJl12PMP2MIrHDCGAwMHMGgQKhOV2J9/z0VJStSABnyHMZovufYnTkCvRHWpU4rkBzsDWCr84pdzyJeECNJjeK5RhbkaBD/Uq+qEOb+AGFtngax9NqtRdRd+oaAcoS6A80DUCH+vEecjFSrdf5lYZ55xxDcleHdY9uxyhWEqQbZDwmYqBXqOcK1QJJT+qWxQ50r/hHh6x5fmHBIp9h0s321Vwz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/25 15:37, Qi Zheng wrote:
> 
> 
> On 6/25/26 2:32 PM, Harry Yoo wrote:
>>
>>
>> On 6/25/26 3:11 PM, Qi Zheng wrote:
>>> On 6/25/26 12:16 PM, Harry Yoo wrote:
>>>>
>>> [...]
>>>
>>>>
>>>>> So lock_batch_lruvec() can be implemented like this:
>>>>>
>>>>> #ifdef CONFIG_MEMCG
>>>>> static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>>>>> {
>>>>>       struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>>>>       struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>>>
>>>>>       rcu_read_lock();
>>>>>
>>>>>       /*
>>>>>        * The memcg can be NULL when the memory controller is disabled.
>>>>>        * Otherwise, the caller keeps the memcg owning @lruvec alive.
>>>>>        */
>>>>>       if (!memcg || !css_is_dying(&memcg->css))
>>>>>           goto lock;
>>>>>
>>>>>       do {
>>>>>           memcg = parent_mem_cgroup(memcg);
>>>>>       } while (memcg && css_is_dying(&memcg->css));
>>>>>       lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>>>>
>>>>> lock:
>>>>>       spin_lock_irq(&lruvec->lru_lock);
>>>>>
>>>>>       return lruvec;
>>>>> }
>>>>> #else
>>>>> static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>>>>> {
>>>>>       lruvec_lock_irq(lruvec);
>>>>>
>>>>>       return lruvec;
>>>>> }
>>>>> #endif
>>>>>
>>>>> Does this make sense?
>>>>
>>>> Yes, looks good to me!
>>>
>>> OK, this sync method makes more sense as it doesn't require adding a
>>> new lrugen->reparente. I'll go with this method and update v3.
>>
>> Thanks!
>>
>> Just one thing to clarify...
>>
>> So, when we check something that's updated _before_ grace period
>> (CSS_DYING), RCU is sufficient.
>>
>> But in folio_lruvec_lock*(), that is not the case because reparenting
>> is performed in the RCU work, under the lruvec lock. So the check needs
>> to be done under RCU and the lruvec lock.
>>
>> This is quite subtle :D
> 
> Indeed.
> 
> And in theory, the l->nr_items check in lock_list_lru_of_memcg() could
> also be replaced by the CSS_DYING check.
> 
>>
>>> Hi Barry and Baolin, what do you think? Since the sync method has been
>>> changed, I will temporarily drop your previous Reviewed-by tags in v3. ;)
>>
>> And hopefully Peiyang would kindly double check v3 still not reproduced
>> on the machine :)
> 
> Yeah!
No problem! I can help test v3.> 
>>
> 
> 



