Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEBF6CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 09:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09976B0088; Thu, 21 May 2026 05:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA6E6B008A; Thu, 21 May 2026 05:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8176B008C; Thu, 21 May 2026 05:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6D0E6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:03:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E0FCA0587
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:03:37 +0000 (UTC)
X-FDA: 84790838874.19.D562E9D
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf20.hostedemail.com (Postfix) with ESMTP id 06EB91C000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:03:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mF4eCJ5X;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779354215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrnVGH6dDfaaQ40W7JPmtqE+tjdS8R/R/GaDGUtvKHQ=;
	b=PFN4ue6YpWQdvsIqsfLX5dCgnIcr4c77yX9OeTyflN3rF/aKLmXy4sYKi88IstbI8mRBQ8
	4gHrYGV0Gm/PC1QYlviY2pORr/0OlX5ZTNOkpWgFv61A08OL8EE50nUHPZlHVVUc/yfQx9
	ZH9TaO/ddpVpmy92n50gkyF01ZwV4pg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779354215; a=rsa-sha256;
	cv=none;
	b=8Ruz3ZR1OzUquwXTH1JjBvggfY37akFIHT+IvjvwPrEAxhXgojmRazJcv3ECWXoBykqj2y
	db8sgvDWnB5sD1SFXYxFbCDxxlWKFdiZl5QXmtv1cx9YqM+a18LMt8zmuavL+fvzNcsGo7
	875FXMm97HM/jXo049OSnaolvdMFvyE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mF4eCJ5X;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VrnVGH6dDfaaQ40W7JPmtqE+tjdS8R/R/GaDGUtvKHQ=;
	b=mF4eCJ5XT6XZYpof3clC6+G2YMhZ8q/RrJGjC/kyObJZjFgpnrR16Q14lBkJBu/z25lf1maVt
	DBBT3b3dNofApFORGC2C7dtluqvxwsz+BxYP57hWuNPE0EZ+EEOBeK3oS5oplGW6AJUc7blhq6D
	7yvAQV+rt72ICP11xK0I7bU=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gLj0x4mK3znTVB;
	Thu, 21 May 2026 16:55:29 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 3F5D940539;
	Thu, 21 May 2026 17:03:30 +0800 (CST)
Received: from [10.174.177.15] (10.174.177.15) by
 kwepemj100016.china.huawei.com (7.202.194.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 21 May 2026 17:03:29 +0800
Message-ID: <13c29ba1-adec-4cca-b355-c8817b927247@huawei.com>
Date: Thu, 21 May 2026 17:03:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <mawupeng1@huawei.com>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<david@kernel.org>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>, <mike.kravetz@oracle.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] mm/memory-failure: fix hugetlb_lock AA deadlock in
 get_huge_page_for_hwpoison
To: <osalvador@kernel.org>
References: <20260520020128.3506168-1-mawupeng1@huawei.com>
 <ag1tNtzmjNlrj4Xm@localhost.localdomain>
 <4ffe8dd7-86b6-42aa-a979-a9ae941e068e@huawei.com>
 <ag7GxM02D92LUrLd@localhost.localdomain>
From: mawupeng <mawupeng1@huawei.com>
In-Reply-To: <ag7GxM02D92LUrLd@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.15]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspam-User: 
X-Rspamd-Queue-Id: 06EB91C000B
X-Rspamd-Server: rspam04
X-Stat-Signature: shrx3rdgwtbc4hn84heske4oxko4o763
X-HE-Tag: 1779354214-630174
X-HE-Meta: U2FsdGVkX18wC3oOMdqNx/2DNeJyYeQxGC1v2WgdP/ozjh9nUmrciT3/UDtTLnB4H7FQRfsahwrUS247bj03lFUel3W7GWQIpz/RTrk3LRrZ5bIlkfp9uoSmT5IBy2Tp8FUvWsdfrD59IbH5N1d7VttRzmB8xRTTfBinr7lErMXpU+iAifiILf30tEERqNF2A6+0fhlYnoyRvKpxp3GzyLEJjAC5W5r/7sdAG+lr41/7pwzojwcvPuC9N7h+A4m9NBXf9prNZYLUMjddM6Uuf2obYtWahdzGGhchTvDkQGlpZtSy1bJm838hmB95CJ4q8WggtxZSTc5qQkkjhZ4sPXP78m93pkImCh02wx85E5VD0VlEHL2NIjJs43SWLHwj1ID7w1V4vT5ZmX26+tF9wi2oE58STV40cCZSrepWCrmYefcmG9uzYvt9U5XEhBS20lWrDDbdef1AjdgdZ3I4B7Hy0r5B8x5FY8Fmljrqwb35/Vq6s6Ti3IkIoBM2WhlpCV1oTiJ2mHb5b3MfX1PpEz3q5Q+4Yu+v35IvRAWgQeZQN3RWIySPP7peo595nVt4/TvcewJVH6r1Ph3Bq0kLtgbxr9HhR2UruZBJOTVuieHB7iBry8yTLL60AlVwIfnuJkrHmhhJ/HNSVw5BDMI42MjiX7uDT+hbqKEhd8uNDpJHb1nzcecT4KoR6fD9fh5M+nNWMvTWNc0OBAU2CQnXt7UiUYqFOC8wwwJqQk2Ouf14LpJiDBBi6YHvfju3l/RO2DyBX0CmhL5Z3ISuZgLIH+cxBoV4f86lDkDy0Z7O55QbuVyw42hRNUjvIvHckuHfODF48g3oNi5lf+HewWKxE+WKPTgNnoVS8O9dlX0b3+DRm8nQ6A6yQSZstv/TcMxSxBIRDeuwbuNyQ/71ni2j/tdnlsYF5DY4C5OiSkXqtjrzoWMrXseFZasmw6VkAF7yjZ7TxTQBLgYeCIHQj1o
 7GzdWVtI
 nArf5ePiUPoEZe/yiYerSartb6pWPVm4ewxIJF5NrRXrWnAob+gzcpK1sIwE38fgUCD4wUpGbRaKab4yiYEfWN96yMh75/00MMVk4cPd5CxomEAaX4mM6toew6z6f/xRu7RD2L6rPCrMIvcpCPEB3pUL1EfdqOeHK90UTuWgOCFjxApEEAetal2KBIypSIsgAR64Qx3HClQLIYBwOvO5pSoGkSIpBmjc1b0N4Y7JVM0k17EFVwRtsxNJwizX0AQrRUtSrrHKO0T2fqv4l3rf1ZBUmLfNPaU+QiYxZGhZ0/0W8VxMw0M6Ycn2cerRDLazZppgu541adwNXytE9ou6+kpBuzLeYAjeXk05ok9gkB8EczjriwzHBKWylnHLMdFqBt9i1ufGO8F5TVXQjjvyPf2w5p4W8Qah3bEyb3aCa+lLO2v0IMhZjzw1RcJ0GYSKArgHynvFyxSDyTtk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 周四 2026-5-21 16:48, Oscar Salvador (SUSE) wrote:
> On Wed, May 20, 2026 at 07:24:28PM +0800, mawupeng wrote:
>  
>> You are correct. The refcount dropping logic in the `unmap` path was indeed flawed. 
>> This issue was originally uncovered by fuzzing. Based on the initial stack trace, 
>> we diagnosed it as a recursive locking (AA) deadlock on `hugetlb_lock`.
>>
>> We initially suspected that `unmap` had prematurely released the folio reference 
>> count, triggering the free path. However, after a thorough analysis of the refcount 
>> state machine and the actual execution context, we confirmed that this hypothesis 
>> is impossible. The root cause lies elsewhere in the locking hierarchy, and we are 
>> currently tracing the exact call path that leads to the nested `hugetlb_lock` 
>> acquisition.
>>
>> The deadlock can be triggered by injecting hardware poison errors on a hugetlb
>> page while concurrent unmapping activity occurs. The following minimal userspace
>> test case demonstrates the race condition by spawning multiple processes to
>> widen the timing window for the lock contention.
> 
> 
> After staring at it, it is obvious the code is wrong.
> We __should__ not be calling folio_put under the lock, as recursion will
> happen if we are the last user holding a reference.
> Thinking about it, I cannot think of a way we would need nesting here.
> 
> Anyway, this is a genuine bug, so thanks for that, but it all got very
> confusing because of the traces pointing to wwrong places.
> The thing is quite simple:
> 
> - We start with the assumption that a hugetlb folio is mapped to
>   userspace and that madvise 
> 
>  thread#0                                     thread#1
>   madvise(folio, MADV_HWPOISON) (we poisoned the page)
>   madvise(folio, MADV_HWPOISON) (second call)
>                                               unmap(folio)
>    try_memory_failure_hugetlb
>     get_huge_page_for_hwpoison (takes lock)
>      __get_huge_page_for_hwpoison
>        hugetlb_update_hwpoison
>         - we get MF_HUGETLB_FOLIO_PRE_POISONED
> 	  we jump to out which does
> 	  folio_put
> 	   free_huge_page      (takes lock.. yaiks)
> 
> 
> So yes, the fix is to have the folio_put happening not within the lock.
> 
> Please, send the patch with the right changelog (and no version) and I will ack it.

Thanks for reviewing.

I will send new version with right changelog.

> 
> 
> 


