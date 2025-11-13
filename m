Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E80CD5BA9
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 09:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5598E0007; Thu, 13 Nov 2025 04:20:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85D58E0003; Thu, 13 Nov 2025 04:20:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D747C8E0007; Thu, 13 Nov 2025 04:20:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD7998E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:20:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38E8B16090B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:20:38 +0000 (UTC)
X-FDA: 84105038556.12.CB21CA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 668F7180006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:20:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZpXHuIo;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763025636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxOI0YQl7L7c1TebB+aN+/DIlcdOEdwTl0d3vm6Qcd0=;
	b=UMI6ey7jMBQNjzKJT+dLWgq9ywCS/x6nf86ipm3C3vQ6rrdGIJZZ39VSQFcul60pl/1aEd
	ZzIMvIzIOvxnZvEHb0q2OATfLAlShfdcoD84+I3jMHPhMqcx6L5fgERgXdep/w3gBpW6xT
	BSUWkgXC9JEml9DqRol9vCYqnnvKTL4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763025636; a=rsa-sha256;
	cv=none;
	b=1RsktvYc0v+YI026r4NQjhgyowRn3TjWvf6rBurrbynDxbsNmAHE6S6uoTsmocV59ucxBm
	J816F5U69pMSaR13e5IPYxUAs/+TLC2VITplxO91HoU2o5N4g4Ppi7nAmmSwgU11kM7XT4
	naP0ggVEmB/eAJO7N6vIvzvqVPQnx/s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZpXHuIo;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8006542CE9;
	Thu, 13 Nov 2025 09:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318D1C4CEF8;
	Thu, 13 Nov 2025 09:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763025635;
	bh=qWeXKefTr39Z8QEjwx9tm3gjalzsAeVjEjzYhlbwRLk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mZpXHuIo3H0Egv1WBvo4ABjZoXf/Ci7KeFuiEV49hQKzupIZa+lZL1qvjl0IQWK/U
	 XmdIh5Wq8FVW4cGmedobTnlvmkjd1HEW2nvPphS6oepn5iJ46yxyc0WxGxl5Xarigv
	 FMYNO98+W8LvaWJcsQu+XKL48ez4hWlQk++JZ1IMAIiQzv9EED9p3oxHBf5bOTx6AL
	 rmKTRVIfQSRH5jstDjYuz97FgVmoKmqh0QWlpaKnduUGQP0b6pevGQlycLr/cFy7OW
	 VEVwCKkKnDimgS7OIxx7OeylF/s3pEFfHWbgdRjUwOnUtuO1P5XTXFM3jHt0vBLERe
	 LMHvQqEW79YUQ==
Message-ID: <6d104efa-0686-4621-aba1-3ce17ef85391@kernel.org>
Date: Thu, 13 Nov 2025 10:20:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memfd: fix information leak in hugetlb folios
To: Deepanshu Kartikey <kartikey406@gmail.com>, hughd@google.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 muchun.song@linux.dev, osalvador@suse.de
Cc: kraxel@redhat.com, airlied@redhat.com, jgg@ziepe.ca, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, vivek.kasireddy@intel.com,
 syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20251112145034.2320452-1-kartikey406@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251112145034.2320452-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 668F7180006
X-Stat-Signature: kxyqtdxrd6snnje7qmbd9fcipkiucjq3
X-Rspam-User: 
X-HE-Tag: 1763025636-553341
X-HE-Meta: U2FsdGVkX18G0Uxx5eVfd00g/tZscg2arLdKY5OL2H+E50eICELMrM/oF76tIwSguOd8M753vIQ8gUyJrqxTC7qqC+e3LuJLkxiOtxOblXriYqoVMUBQaaqDHg5nbBK3ForimFPETF8hLs7ZU7Iqo1QxtWUJ+y1i2g4cneS6xNL7CzFwFc8GG/JmuH2jNId0JuQ5X2EeRkoTM4Xvhz+ksjMURI0jsvciRmIjM31LAuApM5ytneJ+uPfdROnDS8PE80UbkIfWAMekiCYs+XL+cVxUr0iE5A2N4p8uKk6xo25vzMA5pkEUZN3GCY6CkmZbikWXtShmXMeIPKcesBbTLhfUmkQK3qHqY440Hs/cL7mfaZ6JbAxdMaD5KXNXQOPrbj/Cn7QGRVno4lgQcZqL4kOdgNYVVfl7Zi+5Anz7eSrZHJnKMtoO3053Uru3ZQcegPAz91ZAtoMAxz68O1/LcYl8uob3nU6B+TdR1cJdKq9lAYOBCzR8qGIQ9zuv9ueSgPbd/AIU8wI+2fPahnwExEJIuZEkfgh37dzFtWrIcnwiU3QJqge6b4893bpT9Bu05JUEOMfcKCpjXFfZjtDz00Oj+xKKiM1OJ+zvESrAj/BQOpR++yV6sRpOkrwQw/aKWl/4kl5AKEmEwiNgkC3vWeCytV1Z6FRxu/1PPDbztlR7soRIbBYkJC9phRfzYjihTwa7pT3hbGTzQPZSgFGNNRSW3lHRUFGx2hRStdybXisw5ilsRAXLhDTR5/9dCCVNu2CuCrXwSRp8euTvkhKG1ucQ9YRdhiqA1YkecsmYa54M/osZMDHSqc8TZ/Trtv2yNNYlJ/Sde1bCvs1X7MDaFuItKLY5H5cX7N1oATSKvlPxRF7jdZRFQJa8suJLfGcafkJ6PN9ieRpS6pIH7Vkj7sQp0d2J9SHQ7cKK9pv1J6ygEbJpNo9k/CDDbPMPAJzEzampKCWcRSeDhFbnfRR
 fDqAejoa
 FgD3TjazEuCV+/rZ5i4U1F6hxVTnBUWmGSdcb3rOtEo8cpxqr51+PcU95nPFxr5nZopb91SDBUQhKAIqtoyhWsS7HijBC68iz9MXE6RyRaIfAYGwANsclJY/HsWCp/A955kGUbvBwIvf4Tr22eSi0rtpR1epGbCS2X8mDcqi3t+27Zwrvn6HmssMIDEYCb61WYJwUgthF/cbCGKrnHYchCitlfLnSuQT8OqhDojEzJwuCm94oTDZGYvUS1FzdPZyD7l48TrCpXCtutjnRRbsgdFfKRFc3frHT0tuxp4BYYLXpaijfwRWRVEgO9jzooq+EcZ/VmENU6DxmVFx621bX8VZhar8L4nDZ3cX7q2ZFFmZUYKvYdxvhImBLok7lO1jHoxFXB0R32Vq6UOQCSwYpai7WXKCiXL69o5cmK+1Zr1iP+aNeH/8PCor7F/jX+8auVrOm7qX378AuKBKQQMqXRrieuhSWij1K/SGoCT5+80PG3pLA0I4n+1jLruQz+MdQTKI1opNVd68Iw/C69I1mdm3gnumX63YsHkZB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.11.25 15:50, Deepanshu Kartikey wrote:
> When allocating hugetlb folios for memfd, three initialization steps
> are missing:
> 
> 1. Folios are not zeroed, leading to kernel memory disclosure to userspace
> 2. Folios are not marked uptodate before adding to page cache
> 3. hugetlb_fault_mutex is not taken before hugetlb_add_to_page_cache()
> 
> The memfd allocation path bypasses the normal page fault handler
> (hugetlb_no_page) which would handle all of these initialization steps.
> This is problematic especially for udmabuf use cases where folios are
> pinned and directly accessed by userspace via DMA.
> 
> Fix by matching the initialization pattern used in hugetlb_no_page():
> - Zero the folio using folio_zero_user() which is optimized for huge pages
> - Mark it uptodate with folio_mark_uptodate()
> - Take hugetlb_fault_mutex before adding to page cache to prevent races
> 
> The folio_zero_user() change also fixes a potential security issue where
> uninitialized kernel memory could be disclosed to userspace through
> read() or mmap() operations on the memfd.
> 
> Reported-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/20251112031631.2315651-1-kartikey406@gmail.com/ [v1]
> Closes: https://syzkaller.appspot.com/bug?extid=f64019ba229e3a5c411b
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
> Cc: stable@vger.kernel.org
> Suggested-by: Oscar Salvador <osalvador@suse.de>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Tested-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
> 
> v1 -> v2:
> - Use folio_zero_user() instead of folio_zero_range() (optimized for huge pages)
> - Add folio_mark_uptodate() before adding to page cache
> - Add hugetlb_fault_mutex locking around hugetlb_add_to_page_cache()
> - Add Fixes: tag and Cc: stable for backporting
> - Add Suggested-by: tags for Oscar and David
> ---
>   mm/memfd.c | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
> 
> diff --git a/mm/memfd.c b/mm/memfd.c
> index 1d109c1acf21..d32eef58d154 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -96,9 +96,36 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>   						    NULL,
>   						    gfp_mask);
>   		if (folio) {
> +			u32 hash;
> +
> +			/*
> +			 * Zero the folio to prevent information leaks to userspace.
> +			 * Use folio_zero_user() which is optimized for huge/gigantic
> +			 * pages. Pass 0 as addr_hint since this is not a faulting path
> +			 *  and we don't have a user virtual address yet.
> +			 */
> +			folio_zero_user(folio, 0);

Staring at hugetlbfs_fallocate(), we see, to pass the offset within the 
file.

I think it shouldn't make a difference here (I don't see how the offset 
in the file would be better than 0: it's in both cases not the user 
address).

> +
> +			/*
> +			 * Mark the folio uptodate before adding to page cache,
> +			 * as required by filemap.c and other hugetlb paths.
> +			 */
> +			__folio_mark_uptodate(folio);

Personally, I'd drop this comment as it is really just doing what we do 
everywhere else :)

Hoping we can factor that out into hugetlb code properly.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

