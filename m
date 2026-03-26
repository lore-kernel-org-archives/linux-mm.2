Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC0BB106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335BA6B0005; Thu, 26 Mar 2026 05:18:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30CA86B0088; Thu, 26 Mar 2026 05:18:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2237D6B0089; Thu, 26 Mar 2026 05:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 105316B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:18:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E58B1604D3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:18:21 +0000 (UTC)
X-FDA: 84587663202.26.B28F673
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 87EDA140002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:18:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r57v5qpD;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774516699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTgZwnZXMSXAjP/mhmVoX6reznHvCJTTC2W8KqBN0eM=;
	b=rDH6XgJTt6xQaNZs5BFpSTac9IjarZPgsUrc3T/KAvnGyfawouSp/ieGTqLkj6FjrKjTT5
	t9H5L8zI4i2VFIF6sr8dcyoZY9o74ZBRUkcG4T4iSvdWQYi1f//MAAAp2oPZOb0x9oZmsm
	RFD4xQCccTI12f9T7Msj7w7KocMUxTU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774516699; a=rsa-sha256;
	cv=none;
	b=C8mBk8IS3EtOdzcAJ/khPRYrh8a6k0zzwlIH/2ei2rvzq3grLqDm1om5M7iqTzlQkXP14/
	It0Ku0hnEyLXXv39Vhum/6D2wpebnWtpsaBeIjr+w8yWeJlanBOL7b/1+c2dvGyEyegxJH
	t+kc0m4rXfi1+1v6TAyI/STOagofHGM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r57v5qpD;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89D7840560;
	Thu, 26 Mar 2026 09:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6160DC19423;
	Thu, 26 Mar 2026 09:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774516698;
	bh=NB9e1yRv7pQYfcNDqbhIQZdzYe4Yg+3OBRyNgSet0K0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r57v5qpDP1JpL+YD/QaJaQgZtR5duvUUh90CXCPBJWiBbbSdK1/4QS/jk4W5Fm8pb
	 ybMjtmNodPUshgbu2mGVTo7i4SunYaneQLWeZX6F2Fy0SvXxmPSRBEwsnvR+LnBvbm
	 eFl2TYr+EMQZBFfaQSC+mVmACiLlvxpSL93C8f703OsXLv6CiWXRypuzJwj2oOpfFl
	 b4qFJAUKNQrV5pmJIR7ibXzpk4groEy0hej/wz07tzOiAbyW5PY9UR/FYCe9AZPKDb
	 HYGVATtm1OkvfnIE60Pnd8OcFtCwG2t0XJTFh0ByY2C+hUcJUaEF3IOCKyrUqYAOFc
	 pTDUCaouS+UDw==
Message-ID: <9ec9edd1-0f4c-4da2-ae78-0e7b251a9e25@kernel.org>
Date: Thu, 26 Mar 2026 10:18:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/userfaultfd: fix hugetlb fault mutex hash
 calculation
To: jane.chu@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
 Jianhui Zhou <jianhuizzzzz@gmail.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 Mike Kravetz <mike.kravetz@oracle.com>, SeongJae Park <sj@kernel.org>,
 Hugh Dickins <hughd@google.com>, Sidhartha Kumar
 <sidhartha.kumar@oracle.com>, Jonas Zhou <jonaszhou@zhaoxin.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
 <20260310110526.335749-1-jianhuizzzzz@gmail.com>
 <12e822c4-a4f2-4447-80b9-2eec35a03188@oracle.com>
 <CAEgWzV5ryMBgJWH3QmWfr9LaZoihXcffFWKjK6OfJF=pDF6BtA@mail.gmail.com>
 <20260324170311.dc5b54fe0765f2e680e3cc90@linux-foundation.org>
 <1075f7a0-232f-4268-94b3-573d11c4203f@kernel.org>
 <67287b4a-7b93-4061-af4d-65e4a163c61c@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <67287b4a-7b93-4061-af4d-65e4a163c61c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: qzbrzemnbc7yk8bhnaxuwjecyajjyf7u
X-Rspamd-Queue-Id: 87EDA140002
X-Rspam-User: 
X-HE-Tag: 1774516699-437552
X-HE-Meta: U2FsdGVkX1/QJTnF/PHMbTZeaB80MFrnNMuObCFo5VyX2sxtNVHavbBKjBxvDzfr4MGW5q2oUOYbCPH6Oa8CZlfLPu6nnqmEgA2Npil5gxRyWmYpWxTNLZe5liPltdkGqPERZSDcd9DzbBHTPMNsiXpF5YiyBYy1G9JKcQ1zS6X9O97JwvNu3CJbuSjuvLQkrStXAOIjavhppQaWV1SJiixUml5Z7tGe0XNrqh0r80Q2bDNzK2RJnAI5I/rGdG6lH9A6irNjNnmV0O7mTqAdNY4xlfitgGGAGcgg3wYcqD4tgzigkCcb5WuoxtgHmA9kwHp1NvIoeI2PnHGooi+sU0+NPVlg/IMrETWxZ33WZsitMHSlY0WbLHbV7TEQNwmTh+YmD/RQqraibQIWBEf5xKW7hfowwisl0efmnNf/wBqmZy0KF06R28WK22kF17nBZiTmdHTJodri/OGg/U+hO7IA+feRhldMx+n1ufNl8PjmWMJkM5oOFJO4JUZps3qzm2hKVwzjIo7+Irib7Y0fHidSZuy9R6ZL3iSvqMXWjDUMQvAERxZI2YI/1pHrfQt5GUuJCYbH5HAxQFeMVSdgR5oxJC2b0FsUW5A2YhGhoT7aVZs5Wouk7nRY6ll0bQ4Q30MsdgfBadttwIY5Vzbs71JKPJ7lsGiRYxZYo7OgeypS7vjBRnWWL3VinFaJvkKBYyX222bh2TNPLodTnsnYKaghr6SQYmM+sS9SnWBydHTIkf3RtsHaXCqHMk3dggp/eoPNkCh7w5PWhjpweaJy+MeMuz4wLIe9V6kM1XHIR5Q8O8h0+IHKT05jmSzbXxef+V6G2Rw9V/QEk1s5GaUpOa2J4Yea9n29cvNnd+rJ6k7asao+6tA+myWg1h6yzE1URkzZddOHPQhIqpneizYWp9XwniJJ6GAsVIfpmHOJxT7fQqAUM6/hCjAuOzhVJ/FY0xaWIpRrp8OhZgRaQBp
 TOthc5T7
 K1vmW3I9y0kWhYHgX6EGVpRESrmyrPOnZa+UoC0LuOLNKN66mdQ56S+jRwDcRottYTiyxo9dmkBUGw0mCBG4eqy9y6EftL5DD2sGsFlFX3g3AsTJRFifGuAI43rrdmnGGfvalb0Zf4BM0wBuc90SvC2G/wkVVdTatKJTAk7qjsk8Ui1wV8FD32z93GRxyPSUyZFr+TWR4g7qr6qgXQXtwgK1DWhmsM183YnKeendniQCeJBU/3BMR4Tin0OUorzaKkE/O6UN291G6yOOUx8n3eqex98gDne/fWLEc8T0fWCuyuOxpu1gn/7hUlX9dNFdXvT8iLi/u4Wioz4sKy2U5sDb2vNrGPbN+LrpqDEXOFDIw4IQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 00:46, jane.chu@oracle.com wrote:
> Hi, David,
> 
> On 3/25/2026 1:49 AM, David Hildenbrand (Arm) wrote:
> [..]

[...]

>>
>> But it raises the question:
>>
>> (1) should be convert all that to just operate on the ordinary index,
>> such that we don't even need hugetlb_linear_page_index()? That would be
>> an addon patch.
>>
> 
> Do you mean to convert all callers of hugetlb_linear_page_index() and
> vma_hugepcache_offset() to use index and huge_page_order(h) ?
> May I add, to improve readability, rename the huge-page-granularity
> 'idx' to huge_idx or hidx ?

What I meant is that we change all hugetlb code to use the ordinary idx.
It's a bigger rework.

For example, we'd be getting rid of filemap_lock_hugetlb_folio() completely and
simply use filemap_lock_folio. As one example:

@@ -657,10 +657,9 @@ static void hugetlbfs_zero_partial_page(struct hstate *h,
                                        loff_t start,
                                        loff_t end)
 {
-       pgoff_t idx = start >> huge_page_shift(h);
        struct folio *folio;
 
-       folio = filemap_lock_hugetlb_folio(h, mapping, idx);
+       folio = filemap_lock_folio(mapping, start >> PAGE_SHIFT);
        if (IS_ERR(folio))
                return;
 
Other parts are more tricky, as we have to make sure that we get
an idx that points at the start of the folio.

Likely such a conversion could be done incrementally. But it's a bit of work.

We'd be getting rid of some more hugetlb special casing.


An alternative is passing in an address into hugetlb_linear_page_index(),
just letting it do the calculation itself (it can get the hstate from the mapping).

> 
>> (2) Alternatively, could we replace all users of vma_hugecache_offset()
>> by the much cleaner hugetlb_linear_page_index() ?
>>
> 
> The difference between the two helpers is hstate_vma() in the latter
> that is about 5 pointer de-references, not sure of any performance
> implication though. 

hstate_vma() is really just hstate_file(vma->vm_file)->
hstate_inode(file_inode(f))->HUGETLBFS_SB(i->i_sb)->hstate;

So some pointer chasing.

hard to believe that this would matter in any of this code :)

> At minimum, we could have
>   hugetlb_linear_page_index(vma, addr)
>   -> __hugetlb_linear_page_index(h, vma, addr)
> basically renaming vma_hugecache_offset().
I would only do that if it's really required for performance.

-- 
Cheers,

David

