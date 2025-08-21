Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D9CCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 01:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D928E0008; Wed, 20 Aug 2025 21:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445278E0002; Wed, 20 Aug 2025 21:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B438E0008; Wed, 20 Aug 2025 21:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23EB68E0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:11:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C5A11401FC
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:11:53 +0000 (UTC)
X-FDA: 83798987706.20.06FDBC6
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 43CE840009
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:11:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NqPE9tXF;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755738712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kcy4kiDvfXjZXkr3p+YJ3IZARRcGWf8p3DtdKNM7Prw=;
	b=h17wVJHrq110qXx/Ok/f3qYbWhv1e2glbG9dZJ8TIKP7xaorj1DRwkfW2dPxNvOghaVmuY
	UqsQmJOFVtCcue/087d1G62w2t35AEQLiqwSILif3B9WV9WH0MSxdTcOy6sEkfsLU6ZhAq
	fwLLtM53bwyfMCzz/44+RuhRhSeEfEg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NqPE9tXF;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755738712; a=rsa-sha256;
	cv=none;
	b=oOkbTOY+gXUboHBB0ASipdfZOsSd76oLg4lviXLto9ewcTESwZMazNe7sOij1EwgR8QrSq
	hlNkBlrGvyU6K965DAV5ZymZrHdUg2uNULXhjuHyvZq6wFLgJzPNHi+yfgaCLkJ14s9DtB
	/Xy/od6CBSlBDuDF1It7zYLUs/IqUak=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755738708; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Kcy4kiDvfXjZXkr3p+YJ3IZARRcGWf8p3DtdKNM7Prw=;
	b=NqPE9tXFa1hR0GdJkOXODOeDfZQ0XocnvmZadI2ocoiAScWahg7ngmWFpWcDJvXp07MthM2dm5MeHSVWIOavyFli9BMRx4mDwZARoBtPfu8H+XndFiin4yR+ruukn/diNAulM60ZE0V2433GItNmiLETmrL1NHX36NfXSXvIJ7c=
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmE-6ch_1755738705 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 21 Aug 2025 09:11:46 +0800
Message-ID: <816d77f1-aa8f-4580-b1cd-b8c81f929fdd@linux.alibaba.com>
Date: Thu, 21 Aug 2025 09:11:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] selftests/mm: add check_after_split_folio_orders()
 helper.
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, wang lian <lianux.mm@gmail.com>,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250818184622.1521620-1-ziy@nvidia.com>
 <20250818184622.1521620-5-ziy@nvidia.com>
 <a81b7fd3-c466-45c9-9374-361b780ce09b@linux.alibaba.com>
 <A5A3C9E5-7E90-4EB4-878F-D5143FE0F349@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <A5A3C9E5-7E90-4EB4-878F-D5143FE0F349@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 43CE840009
X-Stat-Signature: x66uo6e34byufojygnuo4pg6ysu9f7c1
X-Rspam-User: 
X-HE-Tag: 1755738710-278163
X-HE-Meta: U2FsdGVkX18HkIEEM3zIvRbNp7TNjn2yhvv7JYdphZmkA59njm5u0WjTgGA7hT43hOFV0z1Oj3LyYJ86u0ogxWJj2qDpj73DPNjEt41Shg7ipcIGymeQgZb2Sng6j9v+qNA5dh4I/6TKpskZOBtL0wDyh7NW0AAFyGFYFS3Uk1zc949rsTJ3G7IgNqW112U1cMFRXTaQT0fRi5+fCGy2bCqgYtabfiN+NUSg3pk5P9IZT6oHQZmt/xeoPQ2kn6+r372VVVMxQpXRZzxIagnRshIyKlVvNCZkra8cr+uFBr3Oj3cZMVy3q8VaQ6apz1fA9NWC6+jn2dK84vVKEFBPysDebbnFXIQxijqqb7Fn9FUda/FCAdvXVPnt/TAXohXeX1K9pv7Zn5UqBS19sNZxDpGT8gLemLyXTC2H/p4iGY4Hr4c2BpzHZYQ6oM5Vd46ab/UE7yJaTQP1Fqqz2fEq1Ha8vgytCn4kDsi6K7Rv2Dkstw100ZdPDUGUG4PisaAwFwgHKStAFsPm5vn9k7p/SVt3b5eqGL3Sqa3wr3npq1jXp7fiEqoLb94lIhXQX6zSeIfW1TKqhf9yt0GlJ4InEiinhpMOEFggBHiQ/VlsjT+1iZSQU7b8cTBHmNoY6UrDLyyk+WYKnuOD4CKjqeybnUYpSOAkHJ3pY3Qc+pI+puyUIrjNDBAzhzsVQYh67z4DagC19fXpr6Cz2b6UEVGJh6SaxX4U3CkeliNuV4Byw/Cg0qOtyUY99hqcSjU1e2Kc5mB9ZB+QXiwvw3RdUzglWFAZw+VpXoHbN9xBuTb/F/4ZpTlMmOihRLaQgApXkRwI0W606L9cpUPNDNSE+MiZ7l3idX7Hm3nZ1Wc3PVBf9f9ATP1ohVKKn0sYWFwZUJvCFFxzPdfTCPc4ymzQqGP6Sd2OQ9s/M4iEFvN9EiRfumHc/Uqezad7XyjLqL6sozK07wfd315YX4k5KXRx6Eh
 c+3dh31h
 0MkmXpM2+sNNfMd0DPcz0BYceesxgOE1nuwMa+X3qocyBu+ptW3SfKdHVj6iYpGyIMZh8GFP/iVM9RKHLOW0rNXOZm1r1QeI2CNK1wJTjhjwRmIqapQ4eyivTZ4YE8GOGFlpDTFKBo9yhaC9nfdTCLg5sPLXlzb/+Uihf8scqFXwoCwUe5ldcNR8q5F8gmzPReBXec6shtwAf3FXy8TRZp9/hmED9VSGAINqy06mqp7vi/p+P8aCXi+jc2j9befaNBHF9zXg/imqoAkmSQZZNuaaUHlNDYjwtuD9kjEtCxoawE5NRjANqXNwB54ekq/A6dxGvlF4e3kBUD2UEt0Ex09qvBVcCGsuHKm6zmzBzWYV5khju4hxjH0fP3ZecwydatPb2gKDMloIbsiCA+YkJLsAztM4toL5HdnoWZTCAib2qJAWle67tccH5djua5no+Udn4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/20 21:49, Zi Yan wrote:
> On 20 Aug 2025, at 5:22, Baolin Wang wrote:
> 
>> On 2025/8/19 02:46, Zi Yan wrote:
>>> The helper gathers a folio order statistics of folios within a virtual
>>> address range and checks it against a given order list. It aims to provide
>>> a more precise folio order check instead of just checking the existence of
>>> PMD folios.
>>>
>>> The helper will be used the upcoming commit.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>
>> I tested this patch, and it works for me.
>> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> Thanks.
> 
>>
>> By the way, I moved gather_after_split_folio_orders() to the vm_util.c file as a helper for mTHP collapse checks in my patchset[1]. I'm not sure whether you need to move gather_after_split_folio_orders() to vm_util.c in this patch, or if I should move it in my patchset.
> 
> Feel free to move it in your patchset. My initial version has it in vm_util.c, but
> I realized that its implementation is very limited to folio split check and moved
> it to split_huge_page_test.c. If you find it suitable for your test cases, feel
> free to move it. Just note that the code does not handle memremapped THP, since
> it only checks page flags without checking the PFN. So when a vaddr range is mapped
> to a THP/mTHP head page and some other THP/mTHP tail pages, the code just treats
> the whole vaddr range as if it is mapped to a single THP/mTHP and gets a wrong
> order. After-split folios do not have this concern, so
> gather_after_split_folio_orders() is simplified to not handle such cases.

Thanks for the information. khugepaged also does not have this case, so 
it works well for me.

