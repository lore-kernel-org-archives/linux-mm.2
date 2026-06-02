Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F47CD6E56
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 02:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00E226B0098; Mon,  1 Jun 2026 22:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01296B009B; Mon,  1 Jun 2026 22:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF0B56B009E; Mon,  1 Jun 2026 22:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB86F6B0098
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 22:55:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A4DC1405DC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:55:24 +0000 (UTC)
X-FDA: 84833456568.28.F40BBE4
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id E2C1AA0002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:55:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZKnzaNXq;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780368922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Th6POTS5cfqS0INpKHeDI8jZg/Oz3hxMZKWpXyeBNo=;
	b=P5JIn7OHLB/TbzwJxoX/DJ21Jbk8q60WStvMhxXsuMQ/LrSu3Rj+ZgwOXIrAF1kRGILH/N
	4jY9DZJgow9toZFRhu76PuZgHpwVwnm1rmEI6lqua3hQMEtWlfAW1Q84YIij1isfLX4YJu
	38e3liFoT0bIPt6h06vKK/H8vBGODts=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780368922;
	b=NIUWWMAP53vWyR9vK/8mz+wHJ+c5whc0g84jMgJ/4eP9K80vjsA9BweS54raSs6y+Lqlsn
	Pn9qJcJBdHKZT88LG8zMnAyE+hMcTVaoO/BIUsRVUdn/MZdadADGkb+riZUCdzrSK2UZXp
	afaKhaT3L1OMinPY+TAAU4hCtd1YfBU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZKnzaNXq;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780368917; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7Th6POTS5cfqS0INpKHeDI8jZg/Oz3hxMZKWpXyeBNo=;
	b=ZKnzaNXq+vXDrD+J9IiOhArvdTClqs/9YLHaF+LyZf6XpKS2P5v0v//tJSCqqHimzPxSG7YlAqtZBvgoY7PipHuUqp0YgyKi2YnZXWaE44LlH1r5I2Hf814/Wd4oEojGmG/KJirsvpQzm6fyscYgUHD/j96yVhUe8sJnzgeg/IM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X42efNp_1780368914;
Received: from 30.166.17.138(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X42efNp_1780368914 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Jun 2026 10:55:15 +0800
Message-ID: <4d8ca368-d37f-4a8f-bec2-bcbf159ffc20@linux.alibaba.com>
Date: Tue, 2 Jun 2026 10:55:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/14] mm: shmem: allow THP support determination at
 folio allocation time
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 ljs@kernel.org
References: <cover.1780066530.git.luizcap@redhat.com>
 <144e7639734a501340bffe5652f8ce32b3657e23.1780066530.git.luizcap@redhat.com>
 <bbf10c67-435a-4a32-97d4-a90fed2fecf8@linux.alibaba.com>
 <e4db1872-fbda-4378-b2a6-82915a8b69c9@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <e4db1872-fbda-4378-b2a6-82915a8b69c9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2C1AA0002
X-Stat-Signature: di77okqzeeuoexir8dpkcqu45juf798d
X-HE-Tag: 1780368920-524468
X-HE-Meta: U2FsdGVkX188BQ8iJDfpWlHNhLdS2OzMowQ5y6P6dCdb71nIiO0r3n2IPFJMeY30GsB6JHHy0zZZper/wWTFpq9HW+IybHTvsZ1JAwfjq02gaSyS1h35aQPgsVBwcqEFYY2EmI8Qle9Rzy4+Id8l9XVMJ4u0UjQ3iWAX3uGqzcmqcCNq/aahcLcBi3DyEXL1Fg6XUoyLk/skWUdBvk+kT+1bI/GskuTPN6nqxEhp7lGeGVRrsmFVEl0dwDEY3oZVuLHUTsnISbXeXa22zSh6jOFs/zs5Ef1QSlX5iUZp6kOhzIbZJbQQrALjjX9wLaQFKU55Ya+7a7/ZeftG+AaECpOeCj1lBqzphwSBlVX2yuk6GaYCOBCE+oj2/w4GIlBHPu23N5dE9eeC/8UJmQxATnwkuvVVstTwu8xTyR5z2xwrCpyONii9slcDKzMdLujA2YDFCBFD8r+lG8CRYejEZ0Tf3QrVUAYhjVH/obli9Sx2U2x+DDwMveuxCm95j2a/f1m30QjOzu5OOINjeQzp6EeMl5/smpph1P197VQyKmV0x6rP9NjQ5Tn8Vwnpsb/iDmUHEjfBB/q8jWKr120mVO/URj/IZmura+axLaYsvQLSTkWnDFziXgGwgZsn6N34QnpC6yFj9UIpJ7T6ga1soy4+TjFdHjYSKEhqOlu0GcjK1t8M5BatXXR3aZEtl5HAhG24S7BsIhQX8n1Pv7Gc/9WZBR+0aWF5r/xkbH+ko8B84o3qrdOnrNrYDpsNPpbWt9SiNs3j2QNXhArvz0NS+LViwonAnCrJ0E8l1k1OznfOzuXtbHGAdhdtKCvNq9igWRnVZraxSC9TSNuF32dZYEFOCZ6pCgM5We1ZqdiTPdATUkA1Ui7wq6sI1jiCtbjlkIUBbK45XJFn3ljnu65UUa6Qw1kfKKk3HpLL8pMO22ZzQrQb1ncGDKHW7Hf3/PqaBtvprfPWqNrHaqACkDA
 VW+CyJUz
 5osZElfLf3xx+k/iDbz7hrx7Se9hYjerpIUuhZMrRvgPWW4hVrryMb+DeKLmW9JZplGgjCXlDEKf8jdYzIIUiTbQyjJyrT6rz8hegxm96Ou/DK6ZjfyaP48DTM3O3MLH5p/0a+SmzUUDwdJRVZyxpHD7GpnTaOYlnNXzcSxo8pH2Ap8A0BVlqbYNwNO+txPb+nk+IaThTtFLfLTSbCk8zn29QwB3w59cEWoU88LUxqVaapo3zMTYkdU6F2q96b6lnjojmkFQIaE20k9e5uAAKSxbPw8kBfOXpZHPg8hl3IY8yLsy9bhmuGFyQn61SxfvkQcnTb+w3wQ9yK2WYt50qPBu5CGcuR/zVZEKa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/1/26 8:20 PM, Luiz Capitulino wrote:
> On 2026-06-01 08:09, Baolin Wang wrote:
>>
>>
>> On 5/29/26 10:55 PM, Luiz Capitulino wrote:
>>> In order to enable THP support in shmem today, besides the user
>>> configuration required, the CPU must support PMD-sized pages. This
>>> is the case because of the following has_transparent_hugepage()
>>> usage:
>>>
>>> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>>>    if the CPU supports PMD-sized pages
>>>
>>> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>>>    the code block calling has_transparent_hugepage(), the
>>>    has_transparent_hugepage() call is exclusively checking if the CPU
>>>    supports PMD-sized pages
>>>
>>> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
>>> in all cases, shmem can determine THP size support at folio allocation
>>> time. Therefore, drop the has_transparent_hugepage() usage listed above
>>> while keeping the CONFIG_TRANSPARENT_HUGEPAGE checks.
>>>
>>> Additionally, we need to check if PMD size order is supported in
>>> shmem_getattr(). Use pgtable_has_pmd_leaves() for that.
>>>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>>   mm/shmem.c | 9 +++++----
>>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 88bc0c292f1a..108dc969b92a 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
>>>       else
>>>           return -EINVAL;
>>> -    if (!has_transparent_hugepage() &&
>>> +    if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>>           huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>>>           return -EINVAL;
>>> @@ -1303,6 +1303,8 @@ static int shmem_getattr(struct mnt_idmap *idmap,
>>>       generic_fillattr(idmap, request_mask, inode, stat);
>>>       orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
>>> +    if (!pgtable_has_pmd_leaves())
>>> +        orders &= ~BIT(PMD_ORDER);
>>
>> Ah, you did in this patch, but this change should belong in patch 14?
> 
> If we move it, then this patch will add a temporary issue until patch 14
> where shmem_getattr() may report PMD-size for blksize even when the CPU
> doesn't support PMD-sized pages.

OK. I see. Feel free to add:

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

