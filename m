Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8BBF1061B28
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 02:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A715C6B008C; Mon, 30 Mar 2026 22:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22086B0095; Mon, 30 Mar 2026 22:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95F606B0096; Mon, 30 Mar 2026 22:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88C316B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:27:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B2821609E7
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:27:44 +0000 (UTC)
X-FDA: 84604772448.25.3BA7415
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf15.hostedemail.com (Postfix) with ESMTP id 626FBA0008
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:27:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hW57cjof;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774924062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnMiibA4W4Ig7F76dyLFhn4fKhWlo5n8E1B42uPMv6U=;
	b=tKbj8CQIyg0wlxhMN/CxiWim66S9RFIfsxYgNhbTFfk28lmhUTPx1DNWhR5x+11skQN1Ct
	rj/NnCOv6KRUoGxqP5wOQULyJXwpMYC2FddGeiWKXQInaXGwsaQzcDsgd64WUgrs0zDeWP
	ixObLjhJNZHUqSce+mULGFuFZXhl1kA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774924062; a=rsa-sha256;
	cv=none;
	b=VGt5IGAATC2bEQqUkvPAlIxd5Bm2KN+Cm/H8XDhrL5FXiuz+HOornHnA38+foaVw3j2axg
	v+f/kW+nnWcMohg3dBSWJlNNYC/53+7ba8nfesqn1UfH3rAATdmnt+i0y2qW6POZEZbvCm
	L5NwlEqzBEudcYmdeX8BY9pEWHvjFJs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hW57cjof;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YnMiibA4W4Ig7F76dyLFhn4fKhWlo5n8E1B42uPMv6U=;
	b=hW57cjofNyt2Z8cfky5nD0k3qupiKnrd769HNDVr4A3bIgeIsfIKeLWlqkHuWqzRPTn2AfcQV
	USdejPQSAK0bUdVRoJzGYDvEUGDw50qMtIzt08JubSyyUz0hypD6PR45EJEIZzhErx4Nfqvtc6O
	MnXUDQSJtgCIyERZJXpiVGc=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4flBhN0PSJz1T4Hm;
	Tue, 31 Mar 2026 10:21:56 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 2A33C4056D;
	Tue, 31 Mar 2026 10:27:35 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 31 Mar 2026 10:27:34 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 31 Mar 2026 10:27:34 +0800
Subject: Re: [PATCH 1/2] mm/memory-failure: add
 panic_on_unrecoverable_memory_failure sysctl
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260323-ecc_panic-v1-0-72a1921726c5@debian.org>
 <20260323-ecc_panic-v1-1-72a1921726c5@debian.org>
 <a88d62ee-530c-1a6e-c05f-de324f940b8f@huawei.com>
 <acp8wYLHDGAfhzI5@gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d8d2a5ad-9b8a-f0e2-3eb0-ee820eb7a148@huawei.com>
Date: Tue, 31 Mar 2026 10:27:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <acp8wYLHDGAfhzI5@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 626FBA0008
X-Stat-Signature: a13f6aqcs5ugeoegor8pd9nytywx9ttg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774924060-302392
X-HE-Meta: U2FsdGVkX1+2cHJ/zLzJpkx3G4UpvmNBVErW0VI4xE9JmCm3TyIyi4kvQtTMW4War6MOqvrp1Uf9eDN6OIxthfT0ieJeVIC2GjpYri7qpqaLyC7TJIB96fb/TIfiNX4vnwN4h7+xd4BR+6kVtvvLmXkoeWPeMtXRcb7vhJB7/DlfyEoE3uTS9eDl23/KWhfs5xlM+z//hoXXtvfG1vfiRTBsadhbAVSDPiyVWXFBDrYrFHsq0QJ9+/LTKHhqt9bM5/t5qPopQC3h5ZTL/VcNOq4U6iFy9ap2c+NGUOHqF4MgJ2QmtI/i3+8y9AAGZcz+7erpoUFCB2w0Hk5UJS1FRqmzCXlgqFLoBcdOE3XGy9fWQgy4CaDS6x2kVPt+Nqn3li2eA7dQQJjdvNxxBHgS9kPdZ85f+I/AuXyT0FX6hTfWZRgkT0v5WoexYBMbe8vjCuTrm74iOUU3FzcPF0ZhUwoYCokfwckWYGKiumF9cxiCUbXsc68MAImv0Lshuphji91shBMfofvwLCsbLIeii5PZrfrJkaylRxFxC3Fi/Ye75GA1nUXsIAY+uy+VPyHhglZqKFnaiN/gDPi+Cdl0LCYoTgIyy4b7E1RWtjoOo2ma+qzYntxoFKM1MpPIvTKOW23U+exJIbiYSwOF2CxBsKU3yIrXbUMjC9OLnZgyvMyVw4iANVohCO23B1pIb+H4KLFnAWGJL4yridGvZt7VweTnLHx7ZeJX+rgdQPu5O/wXT0r4Sd472lx5DJt235e0frXY11r9YLG+zeYk9y521KxpBdLj6a5egur/CCelDN3nVdNTRcD3XO12Ubl3iX3+ylQAAA1LDS1nnUMJXHI8O66MmTVVKwlaeyHptXMp/WpWLj9aO0QDFO7ear6FmEFBOb+mGtEqxRuZ9BoXdQsgtCWQhuL5LaZ/L3tDfzW1TNJngOGW0BogoHT/T3lKa139t/VTFhYrUe7gUwdfvzs
 DDKCIxFS
 akoaqc6GK48OgKCSi9N7+OKf92OhxeaHYQ0YI6TFHyJL8cJoBD+YDRvvBguOPOhZSmEyHyZ4bdHVQgflz8QKsS77q+pBqokcQRi1vIis25rumzyjcCK52LdXcvzLyo4L/zIby0gt4lFZRkGtT5tb0XOJBux1HQi7QOXP6D7B0v9/7H2K6D7MUIW5q8fbf0ueiT5tHBGHC5rqxzqBZyVJ02dPyVXKRn5V42GYHLx+WNWkyLnO+GjpplNt4WZ7eAMai4QYR74HZddwUJbh7rRg2om0iOI0Cv4XypEBlvbmLOqXDqTxFP7H3gVfj//HL3YUuucA9TQObzrlcBERsqIl/L7tUAbz4txIovKjCMuOTDFofl6lDqTYhqhTDSkzb6LqDOWO1TERI5Qb7sTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/3/30 21:45, Breno Leitao wrote:
> On Mon, Mar 30, 2026 at 03:55:00PM +0800, Miaohe Lin wrote:
>> On 2026/3/23 23:29, Breno Leitao wrote:
>>
>>> @@ -1298,6 +1309,10 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
>>>  	pr_err("%#lx: recovery action for %s: %s\n",
>>>  		pfn, action_page_types[type], action_name[result]);
>>>  
>>> +	if (sysctl_panic_on_unrecoverable_mf &&
>>> +	    type == MF_MSG_GET_HWPOISON && result == MF_IGNORED)
>>> +		panic("Memory failure: %#lx: unrecoverable page", pfn);
>>
>> MF_MSG_GET_HWPOISON contains some other scenarios. For example, an isolated folio will
>> make get_hwpoison_page return -EIO so we will see MF_MSG_GET_HWPOISON and MF_IGNORED in
>> action_result. But that's recoverable if folio is used by userspace thus panic will be
>> unacceptable.
>> Will it better to check type against MF_MSG_KERNEL_HIGH_ORDER?
> 
> Yes, I was discussing this with akpm, and maybe the better
> approach would be to panic for types MF_MSG_KERNEL_HIGH_ORDER and MF_MSG_KERNEL.
> 
> In both cases, it seems that, the page would not be able to migrate. What do
> you think about a change like this:
> 
> 
> @@ -1298,6 +1309,10 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
>         pr_err("%#lx: recovery action for %s: %s\n",
>                 pfn, action_page_types[type], action_name[result]);
> 
> +       if (sysctl_panic_on_unrecoverable_mf && result == MF_IGNORED &&
> +           (type == MF_MSG_KERNEL || type == MF_MSG_KERNEL_HIGH_ORDER))
> +               panic("Memory failure: %#lx: unrecoverable page", pfn);
> +
>         return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
>  }
> 

Maybe MF_MSG_UNKNOWN can also be considered? Kernel can't do anything further
for those folios.
BTW I think current code can't reach to MF_MSG_KERNEL and MF_MSG_UNKNOWN cases
bacause there is always a (PageHuge() || HWPoisonHandlable()) check before calling
identify_page_state.

Thanks.
.

