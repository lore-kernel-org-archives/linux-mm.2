Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0135E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2416B00AD; Fri, 19 Dec 2025 23:29:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55196B00AE; Fri, 19 Dec 2025 23:29:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61B46B00AF; Fri, 19 Dec 2025 23:29:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B19F46B00AD
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:29:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 642951A0431
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:29:22 +0000 (UTC)
X-FDA: 84238570164.28.396B42C
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf10.hostedemail.com (Postfix) with ESMTP id D8253C0004
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:29:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=woWtFC8D;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cO8WtEaXesAo47SuaG+o4/YJs4sol1oYaZp1SwxhQ0k=;
	b=SiPeCmqtLRZ3X0FkVvAZ17OIqnFoNQLtkrvpcG0dkuis/UJn7sWJTDw6qL6PJoJTm+GC9o
	hcbXwp4aU8DV8Ol+XQ2k4+XPmpf3oi+eaD9iLDFUoNF5+MUBG31iQgyz7zGG9fKMhzX0yM
	xumtszufimqmdYEpIy7EDQ9iCiFsXIA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204960; a=rsa-sha256;
	cv=none;
	b=JEatNYM1Qnwcsc0Vd3iE5nauU6dEefm3BMgnqQtc318SW3W+jZE40+1awgmkVXiI8ao7x8
	Q0TMpLeGbgDIgmG/DEwubZWBfgcVth+/0WpHUJbiKGDmMt/GXoeA0XiSJOiB70auCALGCt
	XP+o+zS0HdVRupxafsdKJwa8bKJtnxA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=woWtFC8D;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766204955; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cO8WtEaXesAo47SuaG+o4/YJs4sol1oYaZp1SwxhQ0k=;
	b=woWtFC8DFaElUqBMdx6sb+qbrhswM5mFwAtjHxVfPA4Jti/ao60IsV+XS+Pd/xQ9ee/3WxdzeqqVNR/Rfa4V93Gx7OlIukWy+4gJf9ApQBzNJL6hRKuBpcgbj3+mpLMM616+CexNi+wCH8lEcdXcJMTJ90pFUnjI5fvbW5/zgvY=
Received: from 30.170.69.111(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvF13NW_1766204952 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 20 Dec 2025 12:29:13 +0800
Message-ID: <17b923c4-48cc-45f0-93fe-84a13568c1bf@linux.alibaba.com>
Date: Sat, 20 Dec 2025 12:29:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Matthew Wilcox <willy@infradead.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
 <24b9d33acad627997febe9b61d398fc53739a333.1766121341.git.baolin.wang@linux.alibaba.com>
 <x2s3l56rqwgcpkhpu77pjt65tfwgmchuy4fuyrj7h7uag5gja3@c3jbws4quxrd>
 <aUV4u9pOHxvQiDcP@casper.infradead.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aUV4u9pOHxvQiDcP@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: se5g61nxuwaeyzzz4g9ebnpcho7w45c3
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8253C0004
X-Rspam-User: 
X-HE-Tag: 1766204958-954649
X-HE-Meta: U2FsdGVkX18gNJcBoQ6bj9KkywlIjEC7yj1TgnCfO68UIrFt0DCaexRqEzSOrmBp7N0Hucv7miD6SGPNg4DEY9dfofibCkuYx6K9F2LUri7Kr8ez1wzED3t3Xd9fZRAMvPe7y/fCtI5WIPmIgrOBoqDXOKjsGbItSVmFH5X5jDTsX1o1TdQ3hlfv9KPgNuY9Yyv120CY6a2LsPbrGb5fbTU+iA0JR4BONFCWVWBENSZ9OWOZtpq//oGE4MPW/gReYwYAO/b3sKG4fisRM7zeoRkRCi9Y0i9js/FOyvOYNXYYBznkM4VQk2sfH+8QaeL2Q4IxnSpD25aHUjPg1vStAlUFS+7I2GQkya7RpVLbehxz1CvVN/XUn2T7b745AzO+/uEZXa4PZWG1orSvaZPRtCpskofBuZpfQ93yAzcZBUiauyhXlmCU9a9+Fb6C2pvsuhsI77lZ3KBIosYr+FZMVOTbCeNeOJy7FGLL+zQS0SmbiAIrsILXOOze5HA8o0/wi3+h34Bm7poTpnizPVNogyg4FsrsfV1A4DcGRzi6g3Vm8eTQ3d7onc4rFW78a7RYXy9RkzgCl5BsYH25KtGbk3CloCgFPT8bDsxoEcZ868f3ZwJ4NJZUFr9jNtPcPan5E/QxLj7Ehav5L5MG2Jsw6DvILtMzoXGeoQ0Wb0pBuMr/p+lIXL/VGDbfvLBTSKdnJ0E4XMtbzGetDYrbTcD2IaigibhH9MkgOK9FnqMzXIsxbWrZP5sa4OqW7reEJga4mQZhsOhTD0Qt4ucxxkxJpZNSW+0Cle8u5gOztMjaK4Kd44Y8diEsI1Na4ZUcvrEpg7iPylelhkQo8h9IAFmCG7WcbkNGc/6bU0iFDLlH8/vyUq8aHwDuJ6SN/J5iMN6gf/uI+lJEzQcwo1K7YpIcDWYskkBMUC/rJkULTmMjdC3NHLbvYvnXXfpLuatWi80vfLr1yEFmR5Q3tjDkJoC
 S91WP2xU
 aPRP+ukIO9nNCZYr7pNNTdBxE2DWoVIRscVQZWMCvjoUi+zqCOgM9cskDCOVa6DjLoYV+w1AcFZUPk3me6FhOEm5f3s2v95onw3bA9tdGB3W9hYn8he4XB7YOIvy0BY7CAvTpWBhRGhBSUtM43cFbET/Yb7MY8IytCu16OTPtcrsd5BMP2k39sCz+6bLSFiU42h8r+SgQa6ZTRSn+8aH4WrCxprLeNBDDNB+b81BnvxAXAmpvaPuCukmxaiFO7EsNWJDf8xP/zIEaDDwHiqgxThSuzAq169+oXbsX11jW+bBSLqBETeNjDmq3nmpbQP446ui/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/20 00:09, Matthew Wilcox wrote:
> On Fri, Dec 19, 2025 at 10:47:52AM -0500, Liam R. Howlett wrote:
>>> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
>>> +#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)	\
>>>   ({									\
>>>   	int __young;							\
>>>   	struct vm_area_struct *___vma = __vma;				\
>>>   	unsigned long ___address = __address;				\
>>> -	__young = ptep_clear_flush_young(___vma, ___address, __ptep);	\
>>> +	unsigned int ___nr = __nr;					\
>>> +	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
>>>   	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
>>>   						  ___address,		\
>>>   						  ___address +		\
>>> -							PAGE_SIZE);	\
>>> +						nr * PAGE_SIZE);	\
>>
>> Did you mean nr * PAGE_SIZE here?  I think it should be __nr or ___nr?
>> I think this nr variable works because it exists where this macro is
>> expanded?
> 
> Yes, this should clearly be ___nr.

Ah, yes, my mistake. Thanks for pointing it out. Will fix.

> 
>> I am also not sure why you have ___nr  at all?
> 
> It's a macro cleanliness thing.  Imagine that we have a caller:
> 
> 	a = ptep_clear_flush_young_notify(vma, addr, ptep, nr++);
> 
> If you have two references to the __nr macro argument, then you end up
> incrementing nr twice.  Assigning __nr to ___nr and then referring to
> ___nr within the macro prevents this.

Yes.

> That said, I'm not sure why ptep_clear_flush_young_notify() needs
> to be a macro instead of a static inline?

Lorenzo also mentioned this. I'll clean up these macros in a follow-up 
after this patchset. Thanks.

