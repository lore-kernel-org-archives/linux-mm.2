Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D9EFED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:31:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE1A6B0005; Fri, 24 Apr 2026 14:31:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9ED66B008A; Fri, 24 Apr 2026 14:31:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB47A6B008C; Fri, 24 Apr 2026 14:31:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA2956B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:31:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 387E0A02AE
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:31:48 +0000 (UTC)
X-FDA: 84694293096.25.5C83816
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf24.hostedemail.com (Postfix) with ESMTP id 97FC418000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:31:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=Pq9kbNWE;
	spf=pass (imf24.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777055506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pbv4EWq/Cd5RENoa+J7LVRBPpcEtejZq7+JufMh2ebM=;
	b=kaptuaF0gDDGvmMNMl5IxS7g+JNimzKabGXVJ+1Ci8aNEhO6GBxUUU3JveuvY/5HskeLMZ
	NJcdwJpa7+47McnTXmTtrMgUrAl01Y3F6+ezM5YGf5pEHwxGM1krAzFszUdi605SHqbbJK
	G3l74Zv5PoOQZ3QvX7C65iUOujUsE9A=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=Pq9kbNWE;
	spf=pass (imf24.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777055506; a=rsa-sha256;
	cv=pass;
	b=DOlzhkVAYSWDKQVquSBLzSIELdoz1Ge8M6YpZ+XvPSyXGK7e98Ho2iZQ5uwQXnw04WUxRu
	intFLiEhPD2/rCV+ZoAl0eLWBNQqKvLc9BQUgHgzi30mTYgLw9dhQmXNBoclEcGm90aUM6
	3mwa7+9oSSwLw5XDKBAQI9fOvNmy2e0=
ARC-Seal: i=1; a=rsa-sha256; t=1777055483; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=RgGwWgsQ+knSqmPynRcyy5iAyNoEqmOVONANwdljTpHS8EXo7ACnE1/VBvuWKoWDZRIV5PTsoc4YwHf8K1+xiR5b83YueOJf8ggZZlUqwv2PDj3XZW2pWCaP1XxeLixtNIqdn1/WmjmtUpZCQPACm0cbnciOuOb8hvDv7kgtlYc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1777055483; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Pbv4EWq/Cd5RENoa+J7LVRBPpcEtejZq7+JufMh2ebM=; 
	b=CGdNQI64fWl1Vk96GPsBXjhcX0y40sSDyXeAdkYSUQLj2k7AtJOS9JzJKsifMqfaOc96ua66ECn6aNi+oR0t2F9ZHKRx95jUSSk089mj+vzDBWtX2dSrcBABcaz+W3LeY8hXMk1hGYO8PRgv5X1gJ8YIMsWHvitGM053Xdmgjwk=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1777055483;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Pbv4EWq/Cd5RENoa+J7LVRBPpcEtejZq7+JufMh2ebM=;
	b=Pq9kbNWEwX1hftXkDLdATvNPKvhxVb+m7p0oxxM3U2rmMMgxnSSsav9Y/WAl4WRR
	Nue0JMkYVqgOe0l9485TcQNKuR8b32st8ZWyqjmK+tUvE7jUb0okA1jcF1SGg3vhfdN
	PfwP5PmYw2KPOMGXkeFzOBmeWaL1ySeGyR947DUA=
Received: by mx.zoho.in with SMTPS id 1777055479390430.2742345262843;
	Sat, 25 Apr 2026 00:01:19 +0530 (IST)
Message-ID: <248498ea-c5c2-46a9-80b0-4197ebe82b56@zohomail.in>
Date: Sat, 25 Apr 2026 00:01:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/5] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in>
 <20260420-vmalloc-shrink-v11-1-cad80b00853a@zohomail.in>
 <20260423103654.2b50501df33f9fd03d48eb34@linux-foundation.org>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <20260423103654.2b50501df33f9fd03d48eb34@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 97FC418000C
X-Rspamd-Server: rspam06
X-Stat-Signature: gngiat4m5qwog1zf1c4y64kyso5ajy1w
X-HE-Tag: 1777055505-530284
X-HE-Meta: U2FsdGVkX18VMDFDRu2EyeuTtc7QnRtz2BNDOgzdm9Ee1EdwC1jHXt/I4Nw/SqiLtSTUJSpBxIAijWsPP/Cbt0YRGdST9Ss9ohBALRhUrK8ubWBCTwqyWSXJv51XUAACWwFpQjWWK36p5f7V1AYzQagizz5XYBwSCcfhzTXHbxDwsehRJkla7Xh8s4IlqD/MC1+b2R9ZiXMKzAnIZFBnaXmMXG41tJfLRXajlcG8kEP5iCGAgGp8BdGpGun3WHUVyrZbBdt0m/XU38gBG14wQV/MZzb9VMajiU2ERUshLbZ8ZxblOMALyh+mnM1tuM+Y25UPP4+WVz8jP4oMtS1XF+bRyJ6rzqU91rxsBN3CwD6GWsNBJwsb6do9J6YOdvKkLdwoMH21pcstl6Ohy/D1sD28LhNi72fihheAseu9897vflgXxoZxWVlpGJRFaeuuJL0fyr1op4oFPThK0kv33+vJix7m8MzgGpPMxMMLDIolt+z8bCI356eARGpNRaG+n9M5DiAH/92goSutf9mZWc5/tzxApnbyCiuMKVKou5HqMFQTjfUc7RWHeat4sjPIPTqVgz0Kp/hodibBfLLmTvkmXSuwbsAuuHN4peV2iVG3cL+gYbayAxmVmXIsuQXSWqVjM6oHDSh3idQ6sD96FyT7Gp66OMtFTdofdiUf5EflIV3Ukc+iUYwGm/a1WYaaT2vieyqP1vIGzBuY/cklv/jul7GhfbqgcsefWlZTRa94TrorXDdpxsj250z5Hz4FyFq9VQXoBt3JK5etuS2B5YFX5mPYb7LTjhLoAvpDsorOZpvSUCDRRpxbdlUQQMRKkbC364mdkjHXmg5t4f7JQ3rthc/X3trUBL45QGpeivvZsay5zx2SINM/8wtcu2Xb6zQ1Uvl3J4P9Np8J44Q0efVZOVIdIgGUlYw69s/luJLxdNB9qaWUcCakYofKFMV2iH515jgxLz/IgkCgvN/
 6SQHDnXH
 1JUubIXQ/YVRPcyy02y1c786oVOZSmxx8cBny1NvjY6gvyPBNZ/dEnLLl8QvbgIxsdTI/xSGszphPYlfAGSLr/0S6gBIosKJ+NgrrY9YDe+5lvTm9cTl7wJ2o2PJZf9YG9EF3+k2q0f0MTI/RjPaAfWo8V1It+EMBvi0f+N4A4D931vW6zkQ/XodlKVlSySA3dCtxvwWzbl+ko4OiKwn6jgKe4SP2vW2R8xVQoMOGMcGWRUAXJrrOpJPIBfKfyUiFttMwheXninPWI+RXnWb/usvhueWBU8amGTGDylcIKDvhqiXfrLjrLj5N+13qVqVUwZaBf5065BOpAawDBvT8wDQXnqy6u0Y8scW2bf9OKO5z+m53t7dJVW4GVUFQPj6gEChwfix4Jc+z1T+oMWKIOsWRsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/04/26 23:06, Andrew Morton wrote:
> Ryan's "vmalloc: optimize vfree with free_pages_bulk()" just altered
> all of this.
> 
> Can you please redo this series against mm.git's mm-new branch?  I'll
> be pushing that out later today.
Sure thing. Will update the patch series soon.
> Thanks.
> 


