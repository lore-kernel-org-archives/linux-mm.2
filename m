Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 797F4C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B386B0088; Thu, 24 Sep 2026 04:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F4F66B0095; Thu, 24 Sep 2026 04:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7FC6B0096; Thu, 24 Sep 2026 04:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7A6D6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:32:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6100B12022A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:32:54 +0000 (UTC)
X-FDA: 85247990268.21.2796159
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7CDA320004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:32:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Rj/tInhG";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790238772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uMdNi2v25zTW3iDv4HZ7uqUiehzQn5eIoW5GHS7bT8g=;
	b=7bfQjjdLurQVcfjl+KDXbBh5jekP7OiChQWCx8qCRaDMxSaImtvAZomL8Z8c0VMNnTx4Y1
	lefiGW+cTzOQTkvl/uMUpoA/de7lz+5OlDdgcugf00wYcsmZhJje6csMpgNoxT1bkI2JdW
	sxyrPyvXiLhQ9VXaP0EOvKqLIxFt8gQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790238772;
	b=u7VcOkLAsrb0udQ2yxju5waReJFhGkppBHqvUgk99sB9LnJg9+U5tdxqOk2zj0J26M1bf4
	TyU4Nf0OxamtYpxYgNO/I4IixUeSYAPMECJwWgZPdkCP0u4Lf36DlGmirMgV/QL22pSBV/
	kKbxH6vOzxFO5cKdrUb2dh/Q5fjnQz4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Rj/tInhG";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E452543A11;
	Thu, 24 Sep 2026 08:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578D81F000FF;
	Thu, 24 Sep 2026 08:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790238770;
	bh=uMdNi2v25zTW3iDv4HZ7uqUiehzQn5eIoW5GHS7bT8g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Rj/tInhGvdOS/wHiSquXaWLtqfgGMoueaCn387hoIF2xpfGiCmLak5nSdFpVz8hFr
	 CFoGs9Y76YxCIT5LYEvtw56D8GcZF1gb/LQlBdYBP1VxdAv0uyCD3XrasRDWJMuIGu
	 k3mtyIGtTxMGH8FohntwDYgfR83L720G9WTyJ6YaDK4vJFObnMMJFTP8zw5TvF0yqy
	 zcmqnMN6xr55k8pB/V98Xc8zOroz4t3k95Gs8Nqf/41DXgl8aqm8ilX4x+CN9Kj/lK
	 lItrZ8hIYbWw2XhZjLlDo3hahmBmKV5PIa+/HMvFrnJtb0f+WX6aYp4yeB2XFv3+NX
	 miE4APjvm6ICA==
Message-ID: <ce6659a6-a658-4311-8c8d-193d309bf85b@kernel.org>
Date: Thu, 24 Sep 2026 10:32:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] Linux MM Alignment Session on Hwpoison on Wednesday
To: Harry Yoo <harry@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Amit Shah <amit@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>,
 Christoph Lameter <christoph@gentwo.org>, Dave Hansen
 <dave.hansen@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
 Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, Kirill Shutemov <k.shutemov@gmail.com>,
 Matthew Wilcox <willy@infradead.org>, Mel Gorman <mel.gorman@gmail.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <mike.rapoport@gmail.com>,
 Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>,
 "Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Shivank Garg <shivankg@amd.com>,
 Sterling Alexander <stalexan@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yang Shi <shy828301@gmail.com>,
 Zi Yan <ziy@nvidia.com>, William Roche <william.roche@oracle.com>,
 linmiaohe@huawei.com, ljs@kernel.org, osalvador@kernel.org,
 nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, muchun.song@linux.dev, liam@infradead.org,
 shuah@kernel.org, boudewijn@delta-utec.com, linux-mm@kvack.org,
 Breno Leitao <leitao@debian.org>, kas@kernel.org
References: <45af1b22-49d4-5d60-e7ad-14a1a33c8dc9@google.com>
 <arPElEV0zDhXrteb@thinkstation>
 <42221bdb-44f9-4c86-a572-1d1372026836@kernel.org>
 <arPdnxhX9VHnDx15@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arPdnxhX9VHnDx15@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7CDA320004
X-Stat-Signature: tc67zijk9em71dsneq46woryqn96cthj
X-HE-Tag: 1790238772-207074
X-HE-Meta: U2FsdGVkX18i8OBP+QfB54s+zrQeVR5wX2iJLDWaEp6SK+73cJNUhPj8wqwojrusgOkoEFny/PaWOBt+9VI0RFmzJe5Cx/4bLnG5DSk4LisCicdYYAmQR+WhK98SkW7p9KA4k6v6yUeGeLWIWFCHetMp3a6t56SQqKL8LWZ1Rn0aZcOx4Lzh9pfCeZLO70aLgEOoaq2bML41GseHjC+KiuVawUHSQJAwtWnG11OW5LFPTOnwfvto34Z1rZ0KRS1wmaNy2Usj+/9dviLMw4EYaYA8eV3lSg8uxslZEKHNJx7i8i6OLgZJR6glVpDShZIpUJYnLBhB6w0QKljmmAJTV9ZLPrSvsHQfZrx3VxWoH7uCL+KW+0sjthHpEBYCLetgh0xEFVbnkj8KLYxEnagFOYjVs1DuM0iuXiDYVG+Jsnaq11Zh0ToRp/rvc94eM8wKG8OdEzaAS0d2OpwF3fF0w0DbRgGwc1Ar4/ustSJUckfiU7i2H8TA+QSeHFXKswTKPPMkKmz+tFnQSrjBzM9dUo7PYtaDW05fjFzpQ8zNqx8ukdLNRbzTxRNzsGZ2DtfFukLm4TE0FqZetznUYolu5z61unA0M0CPM8xn1W4WI+C0udke0UXGZjZd7OAlxakqQRTG3LkqeFKocqmp79LYtxhusmqydYvLCu/BpEiVXN7reV1ExLh4Ea/j/Y/YG2/04pj8S++3A8ylVAl9qDbLtf8aFr1k5Lbiet+y/Zc6FjkgPoVhsuwUVf/EJ5pGObOwJbPiqxPV/6Rmy4ExBS0WDfERxdt4qFctwtH/rpvC1v2z7+Lw6xq+J57Lm5CCheqYcpZ1mYyKh5UdBkBMsmZYJrc1IE96I9BjZtoP6qaOOQL8AgPtraTceDSbcWk16YcBpe82Frhd3PQzP/i0FvNrvUjLXyDN3zdJgVBcWuLzr5AHmKCSE5quk7kRW0RD1xaarmMUAMU+Up+byPFJ7On
 0hL9hgWL
 veARH+scQHdQBYqEcw5ULbjE6CZsjku6/3d5uiVnjg74hHfkZMqltloI/MoF6MjiRh1F7ie6FR+RewTRIV0dvbo2zPnRR9NxfSmpg8xiDjLmkCkE9/Wh7rk6pvTiwJvgPtaL9jkG0RZTA8/MJeI8gjP7D5AXyQJP363a8AnsL7pgr7eLud8dX/QkTqNzaH79t2K5+ZvQClDGkBazxAwK1o3BHiLiTTGYXtk0er6Y/9YW+eVAF6OLQVGqZLufsTab5CbDp3c/5lJoFgTfOooZrs/l+qajSvjcgS3g/vyWjcmxGcg9KBFRCJ8VMCRTB+CBzC6rT7pOK5ALOQS8onqy40nRDXFihvklgepZT9paQyKiTzY6dBn0WLtb/S66P2L/j0UJT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 16:36, Harry Yoo wrote:
> On Wed, Sep 23, 2026 at 03:37:14PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/23/26 14:57, Harry Yoo wrote:
>>>
>>> [+Cc Breno]
>>>
>>> This might be worth some attention:
>>>
>>>   [PATCH v5 0/9] mm/memory-failure: keep hardware-poisoned pages out of the next kexec
>>>   https://lore.kernel.org/linux-mm/20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org/
>>>
>>>   - The question: How best can we pass information about poisoned pages
>>>     across kexec when the kernel accesses a poisoned page, panics and
>>>     calls kexec, so that the next kernel avoids hitting the poisoned
>>>     pages again?
>>>
>>>     One challenge here is introducing another source (a new EFI bitmap
>>>     that represents poisoned memory, in addition to existing
>>>     PG_hwpoison) of poisoned pages adds complexity and confusion.
>>>
>>>     David Hildenbrand suggested that we should simplify this as much
>>>     as possible in a way that we don't have two sources of information
>>>     w/ inconsistency between them and using memmap as the only source.
>>>
>>>     e.g.) By consuming the EFI bitmap only once when initializing
>>>     memmap (to propagate poison information to not just free pages
>>>     through __free_pages_core(), but to the all pages on memmap).
>>>
>>>     Another challenge here is that we don't have functionality
>>>     to poison pages early in the boot process before memmap and buddy
>>>     are ready. So any allocation before initializing them might still
>>>     allocate poisoned pages.
>>
>> I've been thinking some more (and will reply in detail to the series), but I do
>> wonder whether memblock should actually be thought about poisoned ranges and
>> refuse to hand them out (reserved/allocated).
> 
> I believe this is what the patchset actually did in v2.
> 
> That way we'll have to either
> 1) make any architecture that supports kexec select ARCH_KEEP_MEMBLOCK,
> or 2) make kexec scan the bitmap when allocating the memory.

My naive design would be:

1) Teach memblock early about poisoned memory ranges. Don't let it hand them out.

2) Memblock will naturally skip them when freeing pages to the buddy. No need to
hook bitmap scans into other code path.

3) Teach memblock to hwpoison the memmap.

4) Don't update memblock (ARCH_KEEP_MEMBLOCK) when poisoning occurs later during
boot. Any hwpoison happening after boot will be reflected in the memmap (+
synced to the bitmap).


What you are describing is "how to keep kexec from placing data on hwpoisoned
ranges". If we want to avoid scanning a bitmap (which I really think we want to
avoid), the memmap is our ultimate source of truth for hwpoisoned. I would just
consult that. (that's likely what v2 did?)

One complication might be that a single hwpoisoned page is represented as a
bigger chunk in the bitmap. So we might place kexec data on healthy pages within
a poisoned (per bitmap) block. That's fine (pages are healthy after all), we
just have to teach the new kernel to deal with that.

> 
>> So we'd use the bitmap only to feed memblock, but not for anything else later
>> (if possible).
> 
> We can try not to use it for anything later, but still we'd have to
> pass a proper bitmap (through the EFI table) to the next kernel.
> At least the kernel should update the bitmap for newly poisoned pages
> at some point.
Yes. I think it's fine to update the bitmap passively through some callback
mechanism from hwpoison code.

-- 
Cheers,

David

