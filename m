Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09F6C87FCB
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 02:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7184F6B0093; Wed, 30 Jul 2025 22:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1D46B0095; Wed, 30 Jul 2025 22:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B17D6B0096; Wed, 30 Jul 2025 22:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 483B36B0093
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 22:58:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC0178057B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:58:03 +0000 (UTC)
X-FDA: 83723050446.01.58190EC
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0E2261C0008
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:58:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RiArcWtE;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753930682; a=rsa-sha256;
	cv=none;
	b=MKOOVqkj7L3zWlx6xq7fWh9MtuxCQAmvYFxE8c4VAAyqkFBpfA6MUV02FSYaR2Z5VnK+LX
	1ZcYSinnoC8vG8mHGjg9nHYUIT+QTHQ+PrFRmaH7rMoJadZNVr4mTQqjWkkqBpg/blWST8
	4dnQgwp/1dBZFTdffULefHrTo0EReFI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RiArcWtE;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753930682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0DMe1rYjfdKcGwYqc0RA2Njo+26yNUA5TqRbqsuCvok=;
	b=Xf89b1lREKGM/dmn6+NKduTwxjWSlwweQ2HTNNqT2Nc135UYmKYlzxGEfs8BvfYM8dR7OH
	IwR1QAOVUC2k5wx/drCsLgxahgS+Pa7Piq351RPXL9gg3QJnlWbx6AZYDgydiwovaZgJua
	7bO1PFRPfGiwmEMT2IvnXBreRGCZToU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753930678; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0DMe1rYjfdKcGwYqc0RA2Njo+26yNUA5TqRbqsuCvok=;
	b=RiArcWtEcSucS0zekfL6tQyYkIWR8wLDkc7eE7QYCUMJzGAAt/QcuUKsALbRQzXU6bJd1WW5xWUtzBK4htbDPmZaO39og3XEphwfREIK8y2WU8xNQSx6btgTBAjm1W1zE8PEg1mANGjesowAn2UcQumHM/N4pN11VXHZasXM3WI=
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WkWYsmM_1753930676 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 31 Jul 2025 10:57:56 +0800
Message-ID: <7ee29e25-d4d5-4e3f-816c-a877f1a5e7de@linux.alibaba.com>
Date: Thu, 31 Jul 2025 10:57:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: shmem: fix the strategy for the tmpfs 'huge='
 options
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, hughd@google.com, willy@infradead.org,
 david@redhat.com, ziy@nvidia.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <701271092af74c2d969b195321c2c22e15e3c694.1753863013.git.baolin.wang@linux.alibaba.com>
 <5578907d-3583-4a87-8b60-0cda0284a358@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <5578907d-3583-4a87-8b60-0cda0284a358@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0E2261C0008
X-Stat-Signature: n4m15m3wsckhfunrangs4w34hknsetfs
X-Rspam-User: 
X-HE-Tag: 1753930680-100357
X-HE-Meta: U2FsdGVkX19pekF/CIBM1c7QwoSH3XtKh/ftq9+DsBgvDh6/kJcL1Xya8uSpTMwNSSUnoHcLlE7r0u6R51jtpRdSHL8lMfVAJ9aS0hrQ74H1KcDM4IwqlcacGn+GGaMC7DJrXK8hXbwFzF4OxvcsW4i89ibmf4AHvbvnA840i7Do6wXM2ztK+Muw9sI+C6VXV2SQY4nSgPf8XQWVUfEBW0K8RdEh3zNpFTSHL0HO65D3aJkoXKXDD0XsDmbNDKm9wJaMeNp/b4pmJlC09FQyzJoM8UTd5h0ISSJNFB0nT3YQHGDnvgl/Ny8oKRXmpE9F3Lsf3Y9DNI3/sZ12o5pMPU2BJ9Cu5jhQP+MIF14OIBe8uzbHZs7Qd6bi6xtZCbQA2iolrwg48/2GA71hwzJyW8UQJAQAspwR9ee8OiWIMHw72iTdB9Ak4eDhlugWzDWY1uJBKeZhPCH66LZfcrB6fzB/erPwWyd3yNFF2ViwL4F8cU7FDbLFL6q+hHRvhKqIGUV16KXGMYZDMQwdxRsUqI+6IdVuMZKyjsNrCmUr7uJtKGhO7Lw9G3eR2EJdJ4LccPHvkQR69QqxHnWJpIHNrbGiQuVg5PBUZ8gpIvlLfBDr9SNCurJo656i5/QGElN3dfx7olfW3M/BrSfzrSCYO44WkDAC4qUDXEXdhQPiL1gBipj8ftkZaQcmycXUBs1/Ad4wBp2lYIVdo9gnGFSGuQGDzOX7RU/pwG7IAtqGxkdUyrdd9NfHinqaNofkdTvlgegm+dj4oE0ctUHV+odR1U8Mt7zUIfnOMkBB+Btll/BqlNwNzTGAROyyYAySdJguTEuWz0y+/awTv8QWwJIrCpl1XI5rJH66lr1qHPzybFHtmuFrh56NXgVQmxJd84vTBMbjcI5T1mVN6bmgNsS7x3bHAgUSXXWbCerN8NelySoeuzZQ8yWPcRPHuwyPWdJTPNGehAqZWzsIbAUIsVY
 Ynx5LgMo
 UJIt+aYoHL6z17o5Qt9iZfm/borBMAuwgFgW4JNoqHwi3HKPxRhMtNfbFkM4bbSNi82wIX7S+miY/dWVYiheSpREUEYDa17XC+s6PrzzLQcR49gPw4zAdFFYivV0iNYetybHm0RWqCQ+7xsXKq4hmyJZwPRnIY7pQdC3CaC85PDkr3FQQy36NcJ1uQmlP+Amc/aWUQGbXbunhBGhIh++gCQb2dqbVd7pqbbs0plI1yuIst4rUsIaP8y+Owm2xnEMqfqB7up5caSW10MFzBMdGr06yLVNdcFh2kaRtu9J6iVkttwh3PtFhYhAqkHHa7s5N1/VOoK+eRV1eQQsU4OIR4Xn5IKt+rGWwglvR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/30 23:17, Lorenzo Stoakes wrote:
> On Wed, Jul 30, 2025 at 04:14:55PM +0800, Baolin Wang wrote:
>> After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"),
>> we have extended tmpfs to allow any sized large folios, rather than just
>> PMD-sized large folios.
>>
>> The strategy discussed previously was:
>>
>> "
>> Considering that tmpfs already has the 'huge=' option to control the
>> PMD-sized large folios allocation, we can extend the 'huge=' option to
>> allow any sized large folios.  The semantics of the 'huge=' mount option
>> are:
>>
>>      huge=never: no any sized large folios
>>      huge=always: any sized large folios
>>      huge=within_size: like 'always' but respect the i_size
>>      huge=advise: like 'always' if requested with madvise()
> 
> Sort of hate we have a million different ways of setting behaviour for THP
> and they all differ in subtle ways.
> 
> Also this is similar to sysfs settings but with slightly different
> semantics... <insert appropriate meme here>.
> 
>>
>> Note: for tmpfs mmap() faults, due to the lack of a write size hint, still
>> allocate the PMD-sized huge folios if huge=always/within_size/advise is
>> set.
>>
>> Moreover, the 'deny' and 'force' testing options controlled by
>> '/sys/kernel/mm/transparent_hugepage/shmem_enabled', still retain the same
>> semantics.  The 'deny' can disable any sized large folios for tmpfs, while
>> the 'force' can enable PMD sized large folios for tmpfs.
> 
> And what about MADV_COLLAPSE?

As Hugh mentioned beore, the 'deny' option will prohibit MADV_COLLAPSE 
for shmem, while 'force' option will allow it.

>> This means that when tmpfs is mounted with 'huge=always' or 'huge=within_size',
>> tmpfs will allow getting a highest order hint based on the size of write() and
>> fallocate() paths. It will then try each allowable large order, rather than
>> continually attempting to allocate PMD-sized large folios as before.
>>
>> However, this might break some user scenarios for those who want to use
>> PMD-sized large folios, such as the i915 driver which did not supply a write
>> size hint when allocating shmem [1].
> 
> Hmm, this is unclear to me, surely because it doesn't provide a write size
> hint it's not this behaviour that breaks anything, but rather the fact that
> we base things on the write hint at all?

Yes, we changed the allocation strategy for shmem large folios, but 
forgot to update the shmem allocation method for the i915 driver.

>> Moreover, Hugh also complained that this will cause a regression in userspace
>> with 'huge=always' or 'huge=within_size'.
> 
> Will cause? Is this not already the case?
> 
> And what is the regression precisely? That i915 doesn't get huge pages
> because it doesn't provide a hint?

Yes, see above.

>> So, let's revisit the strategy for tmpfs large page allocation. A simple fix
>> would be to always try PMD-sized large folios first, and if that fails, fall
>> back to smaller large folios. However, this approach differs from the strategy
>> for large folio allocation used by other file systems. Is this acceptable?
> 
> Doesn't this imply a waste of memory?

Right. As I replied to David, using the write size as an indication to 
allocate large folios is certainly reasonable in some scenarios, as it 
avoids memory bloat while leveraging the advantages of large folios.

However, there may be scenarios where PMD-sized large folios are always 
expected, such as the i915 driver. It's uncertain whether user-space 
tmpfs mounts with 'huge=' options have such scenarios, but we do have 
this concern.

> I mean if the 'implicit' semantics now are 'always ...but respecting a
> write size hint' (which kind of sucks), is changing this ok?
> 
> Maybe somebody relies on that?
> 
> It seems (unless I'm missing something here) that in THP we've both made
> never not mean never, and always not mean always.
> 
>>
>> [1] https://lore.kernel.org/lkml/0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com/
>> Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>> Note: this is just an RFC patch. I would like to hear others' opinions or
>> see if there is a better way to address Hugh's concern.
>> ---
>>   Documentation/admin-guide/mm/transhuge.rst |  6 ++-
>>   mm/shmem.c                                 | 47 +++-------------------
>>   2 files changed, 10 insertions(+), 43 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
>> index 878796b4d7d3..121cbb3a72f7 100644
>> --- a/Documentation/admin-guide/mm/transhuge.rst
>> +++ b/Documentation/admin-guide/mm/transhuge.rst
>> @@ -383,12 +383,16 @@ option: ``huge=``. It can have following values:
>>
>>   always
>>       Attempt to allocate huge pages every time we need a new page;
>> +    Always try PMD-sized huge pages first, and fall back to smaller-sized
>> +    huge pages if the PMD-sized huge page allocation fails;
>>
>>   never
>>       Do not allocate huge pages;
>>
>>   within_size
>> -    Only allocate huge page if it will be fully within i_size.
>> +    Only allocate huge page if it will be fully within i_size;
>> +    Always try PMD-sized huge pages first, and fall back to smaller-sized
>> +    huge pages if the PMD-sized huge page allocation fails;
>>       Also respect madvise() hints;
>>
>>   advise
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 75cc2cb92950..c1040a115f08 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -566,42 +566,6 @@ static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
>>   static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
>>   static int tmpfs_huge __read_mostly = SHMEM_HUGE_NEVER;
>>
>> -/**
>> - * shmem_mapping_size_orders - Get allowable folio orders for the given file size.
>> - * @mapping: Target address_space.
>> - * @index: The page index.
>> - * @write_end: end of a write, could extend inode size.
>> - *
>> - * This returns huge orders for folios (when supported) based on the file size
>> - * which the mapping currently allows at the given index. The index is relevant
>> - * due to alignment considerations the mapping might have. The returned order
>> - * may be less than the size passed.
>> - *
>> - * Return: The orders.
>> - */
>> -static inline unsigned int
>> -shmem_mapping_size_orders(struct address_space *mapping, pgoff_t index, loff_t write_end)
>> -{
>> -	unsigned int order;
>> -	size_t size;
>> -
>> -	if (!mapping_large_folio_support(mapping) || !write_end)
>> -		return 0;
>> -
>> -	/* Calculate the write size based on the write_end */
>> -	size = write_end - (index << PAGE_SHIFT);
>> -	order = filemap_get_order(size);
>> -	if (!order)
>> -		return 0;
>> -
>> -	/* If we're not aligned, allocate a smaller folio */
>> -	if (index & ((1UL << order) - 1))
>> -		order = __ffs(index);
> 
> We need to care about alignment still no?

We‘ve already done alignment during shmem allocation.

>> -
>> -	order = min_t(size_t, order, MAX_PAGECACHE_ORDER);
>> -	return order > 0 ? BIT(order + 1) - 1 : 0;
>> -}
>> -
>>   static unsigned int shmem_get_orders_within_size(struct inode *inode,
>>   		unsigned long within_size_orders, pgoff_t index,
>>   		loff_t write_end)
>> @@ -648,22 +612,21 @@ static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index
>>   	 * For tmpfs mmap()'s huge order, we still use PMD-sized order to
>>   	 * allocate huge pages due to lack of a write size hint.
>>   	 *
>> -	 * Otherwise, tmpfs will allow getting a highest order hint based on
>> -	 * the size of write and fallocate paths, then will try each allowable
>> -	 * huge orders.
>> +	 * For tmpfs with 'huge=always' or 'huge=within_size' mount option,
>> +	 * we will always try PMD-sized order first. If that failed, it will
>> +	 * fall back to small large folios.
>>   	 */
>>   	switch (SHMEM_SB(inode->i_sb)->huge) {
>>   	case SHMEM_HUGE_ALWAYS:
>>   		if (vma)
>>   			return maybe_pmd_order;
>>
>> -		return shmem_mapping_size_orders(inode->i_mapping, index, write_end);
>> +		return THP_ORDERS_ALL_FILE_DEFAULT;
>>   	case SHMEM_HUGE_WITHIN_SIZE:
>>   		if (vma)
>>   			within_size_orders = maybe_pmd_order;
>>   		else
>> -			within_size_orders = shmem_mapping_size_orders(inode->i_mapping,
>> -								       index, write_end);
>> +			within_size_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>>
>>   		within_size_orders = shmem_get_orders_within_size(inode, within_size_orders,
>>   								  index, write_end);
>> --
>> 2.43.5
>>


