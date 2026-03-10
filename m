Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A0BFCC9DE
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE596B0088; Tue, 10 Mar 2026 04:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5DE6B0089; Tue, 10 Mar 2026 04:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D4C46B008A; Tue, 10 Mar 2026 04:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 794486B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:44:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A54B160527
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:44:03 +0000 (UTC)
X-FDA: 84529515966.25.4E46E77
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 303EB40004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:44:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773132241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1ur8stHKou9PH9HVPKtfEzt00VSj98Qw+AjpXHCQhiA=;
	b=kJsfQKmpShnutcZTB/g6J8AbPa4TD7rPATG6VJagfZpFrC05ccEKuUqgRpDsexy8QFRMhs
	fRponYzMZunxCH3cummsiDeMkhbQtVw+OOj0tVRnlrr4Z3YxKVfZVrEeccWgN+61aCOvx8
	+GoATxbszHkP5/Rg/Ez6nExNrhWnmn0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773132241; a=rsa-sha256;
	cv=none;
	b=Hu33te8xPA404qrr/8wR/AyqCjCn7mx93DeTpbPQx1ltIjZFi/f44qo/XV9tFR7abl/9r0
	3lf20DudHDIdR43ClD+Pktl2kI1c+Kr0wkkQg8P2BSXylP964EU9K8bfQbhJQGDRhL2mnW
	yGO5TNernXgkvB0OtRYMpYIg75jNUcg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC80D169C;
	Tue, 10 Mar 2026 01:43:53 -0700 (PDT)
Received: from [10.164.19.59] (unknown [10.164.19.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 508BD3F7BD;
	Tue, 10 Mar 2026 01:43:51 -0700 (PDT)
Message-ID: <e2cf5e92-b2c7-43ab-bcc8-58b1207658b7@arm.com>
Date: Tue, 10 Mar 2026 14:13:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] mm/rmap: initialize nr_pages to 1 at loop start in
 try_to_unmap_one
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 david@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
 weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com,
 kas@kernel.org, willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-3-dev.jain@arm.com>
 <92b8f168-b135-4c2b-a0be-36c8f8079684@lucifer.local>
 <58b3878a-24fe-4ed1-a870-604b44da71f7@arm.com>
 <b8f4ae76-7e96-4579-9b08-9913734262fb@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <b8f4ae76-7e96-4579-9b08-9913734262fb@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 303EB40004
X-Stat-Signature: 5oy99uzq1553kiodu6u9p4q3nzitq789
X-Rspam-User: 
X-HE-Tag: 1773132240-795614
X-HE-Meta: U2FsdGVkX1/QPxZBlx4ivZFDWUT9OY8w/GA+Py3nL1FmM0t71AYES06NGfvcW5Zw/h1oVJkJCcQVfOGStan+R0K2/fg0bhgbSVZ326qJAJqGBA7XT+Pj80y6kSpwYPGuUuQikV+dA3zMgu0p8qclBD6ApTTRyQbHgUYoPfZCpa1icbKRdi3fyMKZ3Uu6WSoVHtl8RA4i5hkjGzZr3tpyz/phuxiOJJi8LlGWxmKe+WnOUex6fw5Er3DXvh1qVRM80l3Xz3YQRpPCdq4NR5/im4nxj/nl5qx1ISaQOsSwfQMBePZ2GV8WQ3HvkLAMca4d/SZOZ/bQWQI3Nzao2q23lpI6WTHb5YOBR1ioPu8V02Z8qAdUkKPCmBLxjfM5GlMu/SzJzHuBZhs/kqVZeX+zKqewEwsixExwEu93daRT9UzybbBkdBR8z6WrJOJQdipub7PU4xbNp5jVxbmTF1iD38H7U1IAcqfkGR/4tZ93jpbj4zxIivctZdXCMXJ9MTbeKsf4UT57K9JZf1XqO60vTmZSPbrZh5Z4UhqiKSbZ9KP/6cKKu+cbR9RBigt39IxRQ3wmX3P4nhIhn46LcVt8wz7uuKHHfPVf2wyvPX2rG0KhItA1TuVjcXc+eOP4G+F9T5G0dJXVovV6REej/1Iuk8vTOo2eNMmtSLD+OR30uQwq9AVgMDS9dplfDy63rH8zZMSCxOzU8hdf6HC08EHa7NtpF9sBZgD+hxOkZOT6q7zZT8RbsddI4ua3y/J48WZT2HuePWh6eWbYHPZTA74GqOtDkApsl8tfrUs1C4OJIsXAYivfYvYh6FUE4lYtLstb4DVrnVlbkXAFZUpekuIk8r/ICdaULhvOymKlWD6DRjORSu9J8ZG59TeifJ/lf9o42dT+pA2wC++Pc289GVtDK837ZM9HwtTAgS/Wj6fq3R3z/GdJ6rY9SjeNOciNo0yvvs0QIQkWtdSHgM9a3Hn
 h1fua0lW
 3v7d7c+DlE/SCw1/n65XLwkk+BhUb+LdCkOViAS+JWT4Izom279w+r3KdQseaP2Jr9DENafnrUk+m2UWDg8uTIhWU66RFy4lsVs3W6Ixl6FnGbtLOnMAVG9Tc9B6QuTvUprz9bF1YVOb3pLFPM0FpBazefha7OGJODdBpVmH8G1QQO8Zx8ORqff+Mo2YSJsyblpk0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/03/26 2:09 pm, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 10, 2026 at 02:01:44PM +0530, Dev Jain wrote:
>>
>>
>> On 10/03/26 1:40 pm, Lorenzo Stoakes (Oracle) wrote:
>>> On Tue, Mar 10, 2026 at 01:00:06PM +0530, Dev Jain wrote:
>>>> Initialize nr_pages to 1 at the start of the loop, similar to what is being
>>>> done in folio_referenced_one(). It may happen that the nr_pages computed
>>>> from a previous call to folio_unmap_pte_batch gets reused without again
>>>> going through folio_unmap_pte_batch, messing up things. Although, I don't
>>>> think there is any bug right now; a bug would have been there, if in the
>>>> same instance of a call to try_to_unmap_one, we end up in the
>>>> pte_present(pteval) branch, then in the else branch doing pte_clear() for
>>>> device-exclusive ptes. This means that a lazyfree folio has some present
>>>> entries and some device entries mapping it. Since a pte being
>>>> device-exclusive means that a GUP reference on the underlying folio is
>>>> held, the lazyfree unmapping path upon witnessing this will abort
>>>> try_to_unmap_one.
>>>
>>> Dude, paragraphs. PARAGRAPHS :) this is one dense set of words.
>>>
>>> It's also a very compressed 'stream of consciousness' hard-to-read block here.
>>
>> Sure :) I'll try to break this down.
>>
>>>
>>> I'm not sure it's really worth having this as a separate commit either, it's
>>> pretty trivial.
>>
>> Hmm...well, as I explain above, it's not trivial for me :) it is difficult
>> for me to reason here whether nr_pages can be reused without a reset in
>> a future iteration.
> 
> OK you can have it be separate, let's just really clean up the commit message
> then please :)

Okay, thanks.

> 
> Thanks, Lorenzo


