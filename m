Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB713CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0276C8E0055; Mon, 10 Nov 2025 11:39:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A548E0003; Mon, 10 Nov 2025 11:39:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B188E0055; Mon, 10 Nov 2025 11:39:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C65388E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:39:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D1F3B65B4
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:39:43 +0000 (UTC)
X-FDA: 84095258646.08.E8CB112
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8E0A618000F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:39:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WQmOVBQs;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=71k4Aqcvt4zm4pBIL7nawrN8cq1oW6fljiRuZFAJCXA=;
	b=T6BkwdJG6xldZwzrlc3mFNVH6/hB4OXX5v4EqF+FcAXUMVbu8RrQTPSbI92hMDE3prKXuR
	/mh51Bcib/PqX+chUAEMj1u44ekQ3XSq055YSpXk7e0UNn/KKpIyeOp9tg5n3FmsOIpB4/
	O7bWiiV9Yt8ryDbdAQah2oKXAZejxzk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792781; a=rsa-sha256;
	cv=none;
	b=RMpE9CqDMWtSReedYZU1VXwZm7v2U2eSKz87lLKy2Dq1cphgfWFaE1Ki92O++MzuUub16K
	n0L86+kYX6Z6QCzKrt7eSauwJixuwb1WH4LlBoO55AiBbIxKi67R6uFIYpJDrf8+IgXMMb
	iWtLVMVkBKWUtIFpl7IlUO6PT9d1jPg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WQmOVBQs;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <bfe5a925-69ce-46af-a720-14e1d2fd30b5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762792779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=71k4Aqcvt4zm4pBIL7nawrN8cq1oW6fljiRuZFAJCXA=;
	b=WQmOVBQsVjvEFIIj0Mr4IysESvSJeCebhz7JgSaXEHGHMXWSBEtauuome72QY6HLZ+jstl
	k25tc83o1SIDPXXr/QSG4/rmeYeNnzPruMBz9F0cHC+221wIpjZl+dn2xKyWRvbKsos/hu
	wsT28tzQqqwPz2nZcJBqz7N2vNheEXA=
Date: Tue, 11 Nov 2025 00:39:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] mm/hugetlb: fix possible deadlocks in hugetlb VMA
 unmap paths
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org,
 syzbot+3f5f9a0d292454409ca6@syzkaller.appspotmail.com,
 syzbot+ci5a676d3d210999ee@syzkaller.appspotmail.com, david@redhat.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev,
 osalvador@suse.de, syzkaller-bugs@googlegroups.com, syzbot@lists.linux.dev,
 syzbot@syzkaller.appspotmail.com
References: <20251110111553.88384-1-lance.yang@linux.dev>
 <aRHX1XIyymGGWKHd@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aRHX1XIyymGGWKHd@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jc6q968hh9xx9zka8cerrrfkia9ib9w3
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E0A618000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1762792781-544244
X-HE-Meta: U2FsdGVkX19zfmy1Dphka0IfMJAoaNvn+hH33tAYdaGQ31K9DG9Ol9bnDUMl5/MTif0+/UmqTGmabahosgZ0yd3uxZKhjYBKwKtm76JawMYNb2TeEEofiP6PTD8D3deBoJ7Fw+CZU5ep/5ccXKKrJ6IN61HiJ7njVw+8PT74xRe8rQ9aaaxwcntD1TUSPg8s0G9bGvhVw6QvLZ85ZWOvXBVNuL4IIJqLG2htGmdUUz13DR4BGAOREeI2Qgeo3nM6XlCeI0jdwfGpXalo4uJLf0M8eEPuN1csB34xSvwb4mZ4OzRh7/pfeUh8DUJl1k6w2EZ7ixIbEa97WF/uOtufBicMdYTJs0NxWpXuxuoB2eIbqADMgHatYznJM2BILDEGEidkIfaR3UViu4zzBjt3L+3oz8wi9T34beKoVyW6RzBCfwngCChzCbF0RiKO/h4MyUV0jGtRiShaFeT1EfffyaEhKhoFpADMu9Isyk4fReqX5oZSq3Xsqd5W21Sa565CjDFG1X9kNSSzgHZ8TEU8NiuQstZBhyYw96LQHPwhocsuyBM1f+8nvDTciGTVLX9orwAnSlbLsnDenotE2CpijHo4TlgTtQrFMIMk/+A5kX0Fs+VN7r4oz/PZb+I7NsETfxZVUrBNXbDqI2S2EdEZVnD+/yZZxodk9+hMpSnjXtpuUiXUXdBtkUOM1hIRwRXt71mqj1SuSmcntvsmVKhc5DM9wcBGxwGW7VHM+RtN9b2LKh38ZFdvHs7T+pDyBtddzFc8Ubi6xxuJDW1wJQEy/Ju35u6bhBXo41my7zXq1qHZd6zD6SxOLCsqRid+EDmB/hEV3tWK3EmeA2JDpTAGqX1pVUjezGGGGFPOD3it0CKfzVAMkBnviwOCWxVbt9U9ZvwASGY+IZIfUwOW8Wf9DAqnxO4CvJD1T2TP3dN+jT9oRiDBt19FXnMHTuwXQydStGC2y5gThksfYWvKEdV
 hmEOmU7m
 waeZUpc9XCRKLjowQByiNoWTx/DZJcXuVKvsmcAf3uvyyCOpetc/QJ/WMkTwazbV1JGpMF0UdFwnUaIqnftf0CAVhSAh9+PU673udUzrROr2qSTWjg+uWVtyDTqjBM4Gk6PBquWVy0nZBk61ESexS/c0py/u+a6IFye2byeAULAoP7IlnhnZJpRi3lsDkdorQCAnVrwvGHoDUzliaViPZLiVrA+FfBWQ/+5BC2genMhOhaSWtIKEZz7eNn3tUofOb7HDl8W+cLTkpFL2Ua70QhpTBsSGnTr9BsMtqvvQlN5rzwKw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/10 20:17, Harry Yoo wrote:
> On Mon, Nov 10, 2025 at 07:15:53PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> The hugetlb VMA unmap path contains several potential deadlocks, as
>> reported by syzbot. These deadlocks occur in __hugetlb_zap_begin(),
>> move_hugetlb_page_tables(), and the retry path of
>> hugetlb_unmap_file_folio() (affecting remove_inode_hugepages() and
>> unmap_vmas()), where vma_lock is acquired before i_mmap_lock. This lock
>> ordering conflicts with other paths like hugetlb_fault(), which establish
>> the correct dependency as i_mmap_lock -> vma_lock.
>>
>> Possible unsafe locking scenario:
>>
>> CPU0                                 CPU1
>> ----                                 ----
>> lock(&vma_lock->rw_sema);
>>                                       lock(&i_mmap_lock);
>>                                       lock(&vma_lock->rw_sema);
>> lock(&i_mmap_lock);
>>
>> Resolve the circular dependencies reported by syzbot across multiple call
>> chains by reordering the locks in all conflicting paths to consistently
>> follow the established i_mmap_lock -> vma_lock order.
> 
> But mm/rmap.c says:
>> * hugetlbfs PageHuge() take locks in this order:
>> *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
>> *     vma_lock (hugetlb specific lock for pmd_sharing)
>> *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
>> *         folio_lock
>> */

Thanks! You are right, I was mistaken ...

> 
> I think the commit message should explain why the locking order described
> above is incorrect (or when it became incorrect) and fix the comment?

I think the locking order documented in mm/rmap.c (vma_lock -> i_mmap_lock)
is indeed the correct one to follow.

This fix has it backwards then. I'll rework it to fix the actual violations.

Thanks,
Lance

