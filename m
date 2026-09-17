Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79F1EC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676C76B0095; Thu, 17 Sep 2026 05:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64DF66B0096; Thu, 17 Sep 2026 05:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5664A6B0098; Thu, 17 Sep 2026 05:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8166B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:59:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D96C1202B8
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:59:57 +0000 (UTC)
X-FDA: 85222808034.06.18D5132
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7F62A180007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:59:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n197orrt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789639195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rHt157+yBiRSCduhhuqli6luHdUzlejn58B4cMvCDzI=;
	b=B+rtoxQOu9/NK6E/uiZQqAm2sVzwbnqwcRiBbtQA8noCuruyuPMSoNNC2BtrUIdoG5iP8l
	kuVLSkRBsXJYdVr4/PYtWRJedWAJH8ehITbhWJo0tYY0amps6w/ZcdacC+C+sA2RkZT/g5
	O+wU3fROckkUb+j/EcjbQWZw6oBugtY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789639195;
	b=n9kM69V+N/Qs5SfrSsXFjXBA6H+VAY5YzW19XeHNoR77LfQZdx4ToPYt9kJj5uVBrCAmZR
	AyGHAwHNa84Jq+en94dqBsuWzvjlo/JqXzupDrd287R0fMwWQoeuEIFHw1pvH0m35O87S9
	HfdpgSJzjhd5PVp4Yw8DftpYp/GKTzg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n197orrt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F000160211;
	Thu, 17 Sep 2026 09:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC351F000FF;
	Thu, 17 Sep 2026 09:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789639194;
	bh=rHt157+yBiRSCduhhuqli6luHdUzlejn58B4cMvCDzI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n197orrtCx4Bb2bmHB4DM8dWbLdMqQa+evif6TFaYfJOIGLwpDyfrp9sqTnXpu6l6
	 suEJ6LrnzY9kZEblR5EWAXAMVmk/XiYKeebRsgijfbic2zelWwM8LqcGUhTQRvq30I
	 8pJl8oF/eJWyUQsko4VWcWVw1OCG7OJsBBaIMK54PlAKM/ZW4DhsCUc9z+a4aSs7TQ
	 BsEl/Aya5exe1iGNgpmUEvjr2+kVhZiGVqL8XXSwXdTh5a3Lk2wlgKcoj9s3D/jOKB
	 Jm3LTyJy5yxG/wh0Y+iUCu6BWzsVavtVAeTaIi1hxSv3UccHgnrVqk9RMz8/RbI6O1
	 KM7wJQjI7p9lQ==
Message-ID: <276ab9d5-74b7-48bf-9cd5-94de0190f221@kernel.org>
Date: Thu, 17 Sep 2026 11:59:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] mm/ksm: use per-VMA locking for find_mergeable_vma()
To: xu.xin16@zte.com.cn, tujinjiang@huawei.com, akpm@linux-foundation.org,
 liam@infradead.org, surenb@google.com, rppt@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, chengming.zhou@linux.dev,
 usama.arif@linux.dev, gourry@gourry.net, harry@kernel.org,
 vbabka@kernel.org, peterz@infradead.org, borntraeger@linux.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260913121716693wiN5osmShywgtitghSm7G@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260913121716693wiN5osmShywgtitghSm7G@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7F62A180007
X-Stat-Signature: 4sgjcwa47iyng43k61yrcj6au5gja4d6
X-HE-Tag: 1789639195-763205
X-HE-Meta: U2FsdGVkX18wqNWtK8nlumPAfvp2GtUY0cK4LQyKx7GmXCjtDicyOlwNZkZmz+wQWMErClWtJ6LuJv2mS+rY6uDKMdtlFk1dx12JPBj5RpyB5hcJMc2/yO0jtUpNa8B3hzbVbBH993Ys6ReJvnVY6bT/GalMte2197fwaFAUr+oCUASMpHMNeBBmGO647W+cBYeAq9PwXwukDtSJsMlSaO9y/yr3r6gvv68s5i79oH3nwlm3sxwxSnw6j3FLm3Cq+EsOlo7uwwaETyLnTy7VJmFo7EvRydq+Bkjzt5U2xjwRot8z8EzY61d4L6fUXVgbgkDIgZCgAiYymcd7YLc60b+cPuO3RZ44Qb9ufU8lk3fz/s7up1TU2wKyATcF0/neRgYqtamJsLBcqjdTGRBoR9T1Ub3nWYmjT8yyCEvBHeZJo4VbzxeHFKqy+lLFl14tVX37KI48camSqt5oj90tNaBuSOuWsCpqVt94zCTbKTIXvnyF0NXm5eJ49+XnJwfSMEvfCaorjWAtWdukv6KJvdzeWGRY2U8RkWoXFiHu4/3aF5WgapvlTeXNaIxLPWgSUM3nPKQaI/nHvgy/IO9aGYyB3jOSjLo2mRCb+Zm6UNgCTLujoHrzqh9IiFZga441p6EwQ29J0HIaq44de3QZV3fyGHcVHHULyQVP3iPjzrkT+EtDxIBP+Wf6/4zuS5uoyTM3xcd5lylDc9Okt77lZoBSvLjVrL9XSBrhQGdUOrPZpfokgqZ8rwwtViqC1vQz46qSHAtnXlT4n1xYGPURMKPf1WNVeIVtGe61FlSe8HUyLwhldifsx+dch1bYI5YpjRTaZOGSBR1x8o7uCrV58d8UKnUXIYz/4bv3zMpowWKKYji0O3ebCWqfRcBQG37ldk2NGxnspxEcKOflJ3PFLJCGt1k/Nr6vIha6LuM/Lg6cujM/JVSo9jBT/HOfcPm1EhjImxbHI8Mupt5dlAa
 6jq/yz5S
 PBPUnyII4H58b4Kd5NYgMxJ8O5nbDGUS+tcGXxjBft/eoN8ik5x5OnqqbsGkZ2YxdwmPzLz8n6elnbZN9NDGuJyaMOmt0k56GKdhE11vkpZSnjWUwsYqg5meprBg0CCpIevr+h8ANbaXt+snHhrC7418VU6+zl1ZtyTfJ5wK8FZLicvejNI/zX72cdoiWAWVCjMfgzhbDMvbyD+Zw41sYfPbpbc4Xt3gvrRgPs5HU2P9jVZnFGkUKwHMyWXP6e9Tpet6u2jIgK9gDVZYz73XVMuc4RSwpY4WbOR5Vo3MZQFrGoeXliwdTeEcQijepMKRwGQhgcBcZ/vPC/nPi66xocMKpjoHEDPOGKok++aGCCgJ28SNKpmq+JF43g6zdjkT93xpL93FK+L/Ecs+UqFrNOxanodaStMYSbM2W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/13/26 06:17, xu.xin16@zte.com.cn wrote:
>>>    Patch 1 removes an unused 'vma' member from struct folio_walk.  It has
>>>    never been used since its introduction and is pure cleanup.


I am trying to figure out why your replies don't show up as properly threaded in my inbox, making the discussion impossible to follow.

Looking into your mail:

https://lore.kernel.org/all/20260913121716693wiN5osmShywgtitghSm7G@zte.com.cn/raw

Message-ID: <20260913121716693wiN5osmShywgtitghSm7G@zte.com.cn>
In-Reply-To: <40c0c081-d636-407b-898e-f40f3d5d38cb@huawei.com>
References: 20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn,40c0c081-d636-407b-898e-f40f3d5d38cb@huawei.com

Something is messed up there in the References: tag.

It should be

References: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn> <40c0c081-d636-407b-898e-f40f3d5d38cb@huawei.com>

-- 
Cheers,

David

