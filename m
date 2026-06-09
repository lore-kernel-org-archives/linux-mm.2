Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E73CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 02:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4FFF6B0005; Mon,  8 Jun 2026 22:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01446B0088; Mon,  8 Jun 2026 22:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16586B008A; Mon,  8 Jun 2026 22:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C17C26B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 22:39:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48D3914011A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:39:32 +0000 (UTC)
X-FDA: 84858818184.17.4819415
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6192040004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:39:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TjAn0LW9;
	spf=pass (imf17.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780972770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtlygfYK5ZWM60nS1lbLJPtb40nPfh/c6avQxVCJIow=;
	b=o98rBuZygRqcyDXXkg4R3/wy2R7stFK+ZCtLiMnV9xp3tUfhOg+cqM/d4H4iR/Lqc/HcaF
	d4qLcTUNtVx5xiA2hEzWOS1w9d0Yqjrxh2l7UxOipHOV1Ni43m6gbU2AqJ7rKNIYrBmrYa
	xicPhDj+apSjXjMU7blVXt2roSGFKDA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TjAn0LW9;
	spf=pass (imf17.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780972770;
	b=6r0MUHBsSM6jE4NhhC+Jpf1wTH9OUIWfBUW1KOs0rHlRsu/eX00XdPrQaMUAQD0NBjOrce
	xLxk0VG3xsOwuh3PB/XRdLkpUSmr0/oIyI7ZsKCOeCfaeioy7rfzBXu9ufIk2hPuglIEvO
	wMAdHnxAZ7bGUjL3W25Q5KOJzBleBvI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=BtlygfYK5ZWM60nS1lbLJPtb40nPfh/c6avQxVCJIow=;
	b=TjAn0LW9zPesqYG48M58ZA86DLn9aCGiPpV8lYTfGKl/80+2Y6G284eU1iW+QJDF6X0Y25+Ey
	jeJ58Srr9xJ8MXSzFpaF+5L8tjs1ov2Q4iNAxrZWIfUdNhpmxdnQQRotp0akqHhiuppgywBvEgS
	P6STz6TQKtOMYtM6UnrQig8=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gZCbC4gMvzpTKY;
	Tue,  9 Jun 2026 10:31:35 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2BDB24056D;
	Tue,  9 Jun 2026 10:39:24 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 10:39:23 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 10:39:22 +0800
Subject: Re: [PATCH v8 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
To: Breno Leitao <leitao@debian.org>, "David Hildenbrand (Arm)"
	<david@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, Lance Yang
	<lance.yang@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-2-9ea0cfa16bb0@debian.org>
 <19f968f5-1289-f573-4406-e5c91dcd8923@huawei.com>
 <e3d023f1-ab6e-4424-b304-55f1294480c3@kernel.org>
 <33ef8821-c809-b7d1-ea77-6e8a07a6e784@huawei.com>
 <21732071-14a1-486a-951c-34de97b7c757@kernel.org>
 <4b27467e-935f-5587-2f48-5a794c30a592@huawei.com>
 <aiKXrovzrNN-gExm@gmail.com>
 <f1a742be-80cb-4256-b1f9-e50a0f83cb15@kernel.org>
 <aibN4osY_QF1Rejh@gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <4953bcee-5a0f-2bc5-7295-63e5e7513e8b@huawei.com>
Date: Tue, 9 Jun 2026 10:39:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <aibN4osY_QF1Rejh@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6192040004
X-Stat-Signature: 694jdjs5e9xchowwi1di8r68enqp35wx
X-Rspam-User: 
X-HE-Tag: 1780972768-655059
X-HE-Meta: U2FsdGVkX18NZN796eZqBLVmfzvQ/ZnhqUF7Ll5wLzkaiDpcOWaYsqH1UBeCDD65yPl6VeUhaBAu5wzFbJ4dxWwuJx3CCnE2BrVdqj9Y6LvTxOhphJOnTspHE+7G9r1f2GgNQhq09zXYvf9ttLeTJml1j6mIQIThPEc/NIsmKreUBfUdgcK2jLrVtZZE68FiH5YxHgsxxMc+KFkfMMVDBVMG+xSsr4eDjcLA18EqVoJXA8HE3HgJXOii9n3YrTpUsXPGVtyrlciXCtt+wcmJS7fSNGInDydKKpNPEygKJzcKHFShtIN6tFU+M7q37vkDDI/opXKaopbowRBoCMjqv1kyVtjw2D5Jfx+6j7JQlgpGaUTSC+ajEaRTWi+IbKwXR3JSK9dKuESx/ZKHFnRHSq0q09SC+iSnx7J/WoR1ubCirUce9EUL9u8XPcy4/rUqepfl+/MmnWZS48SOX+VEiHESBQrB0AfUHeF/qcI9khG/NFdYjKl5NZjp38ihWpGexCArFSmeuXtvYfPMa3iy9tF5mMGjmhVNKjkyK6Fzf3xwU+hBtst2SbkNMYMecUIf6BfzHI54tsj+Jxc86RVheOruMnYwXLHLxxXq4uSjoDLDgQbhSXFXfL2oBs/q5SuFAhNw+wey773om+ZB3obIk3GSwXx8/jc09/E0jJBCNycJla+ineDeEidTM+Wl/4rv0Vygi5dy56P+9do/auMHgPdEde10dr2B6kTtSIiYv0mXK6YqGA/gO/92p2fK99uVa9DLypKPV1qrWG0z0ilIe8iUnNkymymH7FOLPqtez2FP+6rVJGdoAWUSqekuDdLZ2jAwy1cp+qMo7XQ0t7Y6WQYsU2M8IHV8FF0EcN+4oxRXQi6Me52PfF0e3ZI4xcsdwaSzeg90CIHA1ptcd/0c3VVdKBCPx9prUI0qBCkHuQ8mqLnw8FsDpOTYTQRlx/4QFiI/ja5QXTUYZI/86jX
 U8boBjcX
 Elyh0izFGBQMKJoJ0WobI3YMfgD5Ap2U6oz/uyrNjjmVtYXa7Wk8uN3gp6MY1YhYAaGZTmXz608pSSg11mRUmjy5oWDSxY0UqK9ERwG+HpxkAazzE8PqwB3PMthPLiSbRGCCXaSXPL0ynOiCTFskyfAJbDHkBhEe7AO2YqnnsG1lBE0wOTgVQCewQqhmKLhwODy9+qdI5iHIw6HMeLrbKd8SGcmihyuGd3cvCvhle5BHARx5En0EnD2SIj1F4UB+AQNPDBl3OvN7L9WCGqulMJSV++1A2hDHrsuDIkfKgILqwgaJvjCm5hhidBSI15Tad6wTvaiQGVnmR1PS9AF5HDLgw3u0yP17escyX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/8 22:15, Breno Leitao wrote:
> On Fri, Jun 05, 2026 at 11:42:53AM +0200, David Hildenbrand (Arm) wrote:
>> On 6/5/26 11:35, Breno Leitao wrote:
>>> On Wed, Jun 03, 2026 at 10:33:04AM +0800, Miaohe Lin wrote:
>>>> On 2026/6/2 17:41, David Hildenbrand (Arm) wrote:
>>>>>
>>>>> Races are fine. We might miss some pages, but that can happen on races either way.
>>>>>
>>>>>
>>>>> I'd just do something like
>>>>>
>>>>> if (PageReserved(page))
>>>>> 	return true;
>>>>>
>>>>> head = compound_head(page);
>>>>
>>>> If @head is split just after compound_head. And then @head is freed into buddy and re-allocated as slab
>>>> page while @page is still in the buddy. We would panic on this scene as @head is PageSlab. But we were
>>>> supposed to successfully handle @page. Or am I miss something?
>>>
>>> You're right that it is racy, but I think it is an acceptable race here.
>>>
>>
>> I mean, any such races can currently already happen one way or the other?
>>
>> Really, the only way to not get races is to tryget the (compound)page,
>> revalidate that the page is still part of the compound page.
>>
>> I'm not sure if that's really a good idea.
>>
>> But my memory is a bit vague in which scenarios we already hold a page reference
>> here to prevent any concurrent freeing?
> 
> No, we don't hold one here in the case that matters.
> 
> HWPoisonKernelOwned() runs at the very top of get_any_page(), before
> try_again: and before __get_hwpoison_page(). The first refcount taken in
> the whole path is the folio_try_get() inside __get_hwpoison_page(), which
> runs *after* the short-circuit.
> 
> So get_any_page() itself never holds a reference at the check -- the only way
> one exists is if the caller passed MF_COUNT_INCREASED (count_increased ==
> true).
> 
> So on the MCE/GHES path -- the one this panic option exists for -- no
> reference is held when HWPoisonKernelOwned() does its compound_head() +
> PageSlab()/PageTable()/PageLargeKmalloc() checks.
> 
> Given that, I'd rather keep it racy and take no refcount than add a
> tryget + revalidate purely for this check. As I've said earleir, an operator

Would it be acceptable to add a simple recheck? Something like below:

retry:
head = compound_head(page);
PageSlab()/PageTable()/PageLargeKmalloc() checks
if (head != compound_head(page))
	goto retry

Thanks both.
.

> who enabled it has chosen to crash rather than run on corrupted memory;
> mis-attributing one such rare, genuinely-poisoned page is within that contract.
> .
> 


