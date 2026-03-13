Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04105105F7A8
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 13:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6497B6B0089; Fri, 13 Mar 2026 09:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A346B008A; Fri, 13 Mar 2026 09:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520BF6B008C; Fri, 13 Mar 2026 09:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3486B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:46:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D683A16017D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:46:42 +0000 (UTC)
X-FDA: 84541165044.18.035991B
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by imf03.hostedemail.com (Postfix) with ESMTP id E51DC20004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:46:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773409601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FSEu7XGwXnH7f8zOyoeq/60PMcjH0ptUcExv01ZKhm0=;
	b=m6v0FdGjOwUbbvW+xxeNmtCsDwrZqnBOOCHUJCUeOYf8+qW2lGGsu/BJGbiVLXzHD/4/7l
	VF0N2JrYtIBarimp1fBv+toOwAzK8TxmWmRw8DYUMKrVde5INBNU+ADpTLSXKTnKdUvIv2
	tiSj6di9zJ/jtxc/Y3UPDgYbSkgD9fE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.194 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773409601; a=rsa-sha256;
	cv=none;
	b=ed1iXUToX4iIkoFTSJximy1gFGTaDjdFbc2/VwwYZHtk7ExEv2eN2jowrax8OGqaawE0W6
	iL1+v+GOhq1r+mcdeNpAUR5HiSCX/PTZYRLWK2Xz+1w0AnfVQQUmjNXJC/WGCWrEvcw4vq
	lPWaXQUxtkwr38U5U0o3tlUR6SjVYbQ=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 408A73EBCF;
	Fri, 13 Mar 2026 13:46:32 +0000 (UTC)
Message-ID: <16819a41-1605-41bf-996c-64d7bcee6d46@ghiti.fr>
Date: Fri, 13 Mar 2026 14:46:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: Rename node_get_allowed_targets() to make it more
 explicit
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Byungchul Park <byungchul@sk.com>
Cc: akpm@linux-foundation.org, alexghiti@kernel.org, kernel-team@meta.com,
 akinobu.mita@gmail.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 gourry@gourry.net, apopple@nvidia.com, joshua.hahnjy@gmail.com,
 matthew.brost@intel.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel_team@skhynix.com
References: <20260311110314.237315-1-alex@ghiti.fr>
 <20260311110314.237315-3-alex@ghiti.fr>
 <20260312052831.GA60352@system.software.com>
 <0761a728-34ef-45b1-9aaf-0e6c5c360299@kernel.org>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <0761a728-34ef-45b1-9aaf-0e6c5c360299@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeelkeduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpedthfelfeejgeehveegleejleelgfevhfekieffkeeujeetfedvvefhledvgeegieenucfkphepudefkedrudelledriedrvdefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedufeekrdduleelrdeirddvfeekpdhhvghloheplgdutddrudeguddriedtrdektdgnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpqhhiugepgedtkeetjeefgfeuvefhpdhmohguvgepshhmthhpohhuthdpnhgspghrtghpthhtohepvdekpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsgihuhhnghgthhhulhesshhkrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrlhgvgihghhhithhisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehmvghtrgdrt
 ghomhdpr
 hgtphhtthhopegrkhhinhhosghumhhithgrsehgmhgrihhlrdgtohhm
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E51DC20004
X-Stat-Signature: duwst3tdhxu3wy1pdoq3zcc6gw4fe4eq
X-Rspam-User: 
X-HE-Tag: 1773409600-642178
X-HE-Meta: U2FsdGVkX1/wNm3lDNOi+rkCBKXk4hXRgi+dBKWKSeXCWuzS2H1kAYkoxf7BCKPZQxI0AjSCB39ok6/wmToR6wpD138YdyxypNqs/cwEj46adlNdr3Sda45SezxKI5zrvhZh2l9EUhnpi3wYWXIxIQFdQna0gppbngxjaxtMoIYX+MfTxtJm1cQbewsA+tQooVFRfO3dM1PCxBKWcDFcAjNAPedqg+YBMLwEx1rxC1NqgYj5yKz9ooGJH+i8WclSaMUl2tBPDDANAWEHVeg8hOK6pXU3w2CEO7sjLZb8Ct14+DQQA1oiLQeRfEl3oSx4iV9Kt8lVvyEsTYRrqmR5MWQJJ0Z5nLrrsvNpgHqoAYDncF30HPJzjleCKQGcDw1bwTi5gXXxr23KW/5CaVrGK7OiDuNzgbQOchORs+HDd2fcq5XbVFegxi76kgVVWfEnO9anD1TXtBv+2mi1nTRSSJg2oEkH01J+9Y1Z3RqUDKqzEcstJ5XP95aXWBmbf8n4XN3PYdrNL57PROPhHpQpmhqd9jKIcfA/vtZLKTa/SKpaQoCvSSY3tqgwyPI5Y3tcO3RBB6shnUacAeBd086S0rSZFwRISodP49cSlP4OBH2SAF9WQQIY4Xq6F+6xLIDo/Wmmr6Uuo3tmokwlt+eC8xkhmGKpwOykyw8lt2Q9gH0A7pG0C0mvybMYZVNSCyN14zWyfVxQ/MeJ8rZC2kQKi2rctrm+AjDY8jKMUsFjVRGu37vwpvTY/FFH5nU2mI6bbDkf3tPesNWQZGx1mpNF3bfipxcn7xBMgEj1zt7VqNLE3EyN4YeB/+HYxceKjum966PHySkV9Uma0hLQE73aB8Y6UnJdzStIQI3XapZe+q6aJmrWXuKH1UGEKmmm0t97p47+UPxWn4/CqM/RG+WwbBBkF2Yw51Hw0xw6C3pITV/M7kqk2eXgd1/UgtlEU2CaIYkQxdMXSlEfCSOFaGz
 jtZKM0AW
 BgTt4GxiERzKawV2qYBWCVlUELl+MfHMDvzglKXOjeukqxXS2ZNv5h96o7DEQbkGDVQuQCZjsh+ezL4NbZLU11/88w05ESoZ1uvsGQVBkNtBzGA5h5wWoIji/cLOv+VlWwlPoRb31W91sndA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David, Byungchul,

On 3/12/26 13:58, David Hildenbrand (Arm) wrote:
> On 3/12/26 06:28, Byungchul Park wrote:
>> On Wed, Mar 11, 2026 at 12:02:41PM +0100, Alexandre Ghiti wrote:
>>> This function actually returns the tier nodes that are targeted during a
>>> demotion, so rename it to be more explicit.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>>> ---
>>>   include/linux/memory-tiers.h | 6 +++---
>>>   mm/memory-tiers.c            | 4 ++--
>>>   mm/vmscan.c                  | 2 +-
>>>   3 files changed, 6 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
>>> index 0bf0d002939e..ec39dc3c39e6 100644
>>> --- a/include/linux/memory-tiers.h
>>> +++ b/include/linux/memory-tiers.h
>>> @@ -54,7 +54,7 @@ struct memory_dev_type *mt_find_alloc_memory_type(int adist,
>>>   void mt_put_memory_types(struct list_head *memory_types);
>>>   #ifdef CONFIG_MIGRATION
>>>   int next_demotion_node(int node, const nodemask_t *allowed_mask);
>>> -void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
>>> +void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets);
>> Look better than before to me.
>>
>> What about just node_get_demotion_targets()?
> +1
>
> Maybe throw in the mt_ prefix and call it
>
> mt_get_node_demotion_targets()
>

I'll do, thanks

Alex


