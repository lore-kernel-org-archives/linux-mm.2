Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A969ED7B8B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFCFC6B0098; Tue, 14 Apr 2026 05:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD456B00A0; Tue, 14 Apr 2026 05:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C006B00A1; Tue, 14 Apr 2026 05:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B38796B0098
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:18:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 668731B80BF
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:18:12 +0000 (UTC)
X-FDA: 84656610024.24.7D16D94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8D9EB40004
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:18:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bQqLo/TN";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776158290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOC1HAa2kHjdYMZ5h6PswGQu84DoDz//zgY0koegNm4=;
	b=EpOZ6zIp05OzxJVI8xOx+HHJciD06z3vtIYnRaumpWor6IHakCpTIH03D71lv/KoCK5Etp
	lotq2X071l59Di03oML5MQonNvbYAu/eA9pQ6gw6teHqBO1LjZ6vu5DfnsngtzOjSHWbaf
	U5KU7LD9bEkkYEa1pXpbkaKgoarfl80=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bQqLo/TN";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776158290; a=rsa-sha256;
	cv=none;
	b=B/eICv9TgrdDi10BtJYhe0zvmSll2iWoHInZspJwcvpVOg47sgYfFXtgJsivI7d+SC35YB
	uOAnYw/Sk7oVBbXDBLwGl3k+Yl3a04W63XTNapxBlMQvMvlXSCpXlLvFDJek7/Ejttta5I
	QFoqIoiz0fYQcDhVBKglyIDl9w5WBiA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D57D4078E;
	Tue, 14 Apr 2026 09:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA95C19425;
	Tue, 14 Apr 2026 09:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776158289;
	bh=MnJtJqS5Xyd9/Qk6LVxPCSly4mAwMpZuLttyd+ihRbk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bQqLo/TNwazE2PEIhbMC5fjfFa7Ta2wqjzOJMNxUUfl02j2FZmaqdKPoA7R5Ogvw4
	 16He+N/W2Kxv3DZSjkZNAPH4EbJ8dC290wDsfUnJJQbYMFdQwW5BIbJeTJGdsce6rX
	 yl0qIo3Ca+qqo+VnByEpo5+VBSNWq+fDvApkudIa7lSeebfLc5F9HNbE6YQkKJV5OX
	 9tkjPWzUlU8zBriCVkfTPFrOkHGVWKSnpdoEV9ZGu6lI6x5KXadfH/u7Rl2K9I3sOO
	 v6vD4Foa4x3QgJJ+vQ2CE2rec5+3hv4L10B9zWyqKzdfO/vosYq7ncFoKhQ7lLlw50
	 yVkXc9kxIJzwg==
Message-ID: <244c9779-b4a5-4d0f-9eb9-ef0ec873e0f6@kernel.org>
Date: Tue, 14 Apr 2026 11:18:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/9] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
References: <cover.1776033471.git.mst@redhat.com>
 <ea67e39bc3aea1b0b491908f851ffce25154cd26.1776033771.git.mst@redhat.com>
 <2155527a-e077-4b71-80ee-d735f9984f60@kernel.org>
 <20260413163233-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413163233-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D9EB40004
X-Stat-Signature: zf4rfryjp8ruuccaab9rqe6ciapyrnei
X-Rspamd-Server: rspam06
X-HE-Tag: 1776158290-195097
X-HE-Meta: U2FsdGVkX1855K05UpgJ3OFPivIShXsIxXVAH5OzLFJO0uH/4Uj8yPvjnO0t6JpN81mq1C+CZe4EPKbReLuFLqy2i2jKeS4xXrw9aeqcukEKvryV/jXR9fNbLj4hEMBtuL4yXoP7BSulmRYXa/4E2FpjS5gv/eD/8YBAd93nva4OqvSicERf9mmrWPedmEsSGwVY8QqcPGSSaUfjhVdWDgqeh/sLv5NWDMfss1CPCNaSgHLQEviwQG7KjZQxbcPYj3VMB2PptI3Z1/7LQBgxQA7U5LLbaEJ27/SBqUXi2RSfE772HUa3vxNOtQAT0iHPtKIo5O+PkRWhxvgh/xG4aDxUjjJjBu2BRNlmej2trgJT//RwD0cendkVBpaEWCaOO/J+zZ54aAYNXxKgfBzAyBV59GWgazhgsijnx+2R2T14IG27PuWEVQf8Ov0LGuFVi0CuvUKNVj+1Xf0iJGr5KOy3uH6YkHzrlRicjB7Vc84rT2oaXEdK78I2HuwUfqQDwezIW35+BeY2Hxmaj2AJSVKHfczc+p994dyM9tQZLDEYOmmSOLspfWkSr6o6BLNaExENvaNl9fKF5VWLC4PJsuLvN3L1pfsLWMQCShvbJnj4ms+4Pznd5YWSm8keTkJ8pVTCAN8DPIFK+BvTEhgLtOBSVxja3aKVv/XMyPaW8xC1ivt/sQJA9vtEPZw+RMvgkZmtmUgT0cVsUNGxi1qAwEI0pAL3xIA0eIiNSLKVRwMqGzA1P90R6gXrH941Ii7o3+Xqhuu26nVWxoRc+e/lly+Kw+pjERr70VkImaAsyYKYfEUFh7XYHTxlCGlX/pQro3YW0wljZ6UfZFSjpi7VpCib/Z4mZ5MPtpabgl3EeoMOAN5/ZH6Mqig/F8hda/lej+t2Rt0r7is7gd/zGsFddyrx5pxefndFHHstDJLOsrRKxSWwe3w/ufQNWTZ05mCzq7shxfZSeDtVKQgA2+3
 MR4c3Boe
 Kb/s1bT0RdgMWY+MEjceU+1GJ9hvl2eZwJLY6kCq6ov8oQKaZOUuPjOAEJAepa62W7BVj3vWwtNaQ8u4eNMQivfmokGXspty5BL0CJpGQJd9TVzxdPtkY6fJV7PUxFmn9ROsmNc0wGZFNGgLc08fv4By6Rtru1MPGjGvMu0RILzu7Zw6JUZ7QRXZKeYQvHOz/hvYR5pRbw3mNFttxbp8gd5FesaymLAoN/nd++QwpPXcLUqtdmR80gDPwZXVVYRudZzFLtjdaU9yFPWYT4778+g8PXPGAx/nZF5o0ZfM2XkzQ99Jxtn/oN/WZUqXYOEtQATdprCI6VKKU4NQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 22:35, Michael S. Tsirkin wrote:
> On Mon, Apr 13, 2026 at 10:00:58AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/13/26 00:50, Michael S. Tsirkin wrote:
>>> When a guest reports free pages to the hypervisor via the page reporting
>>> framework (used by virtio-balloon and hv_balloon), the host typically
>>> zeros those pages when reclaiming their backing memory.  However, when
>>> those pages are later allocated in the guest, post_alloc_hook()
>>> unconditionally zeros them again if __GFP_ZERO is set.  This
>>> double-zeroing is wasteful, especially for large pages.
>>>
>>> Avoid redundant zeroing by propagating the "host already zeroed this"
>>> information through the allocation path:
>>>
>>> 1. Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
>>>    drivers to declare that their host zeros reported pages on reclaim.
>>>    A static key (page_reporting_host_zeroes) gates the fast path.
>>>
>>> 2. In page_del_and_expand(), when the page was reported and the
>>>    static key is enabled, stash a sentinel value (MAGIC_PAGE_ZEROED)
>>>    in page->private.
>>>
>>> 3. In post_alloc_hook(), check page->private for the sentinel.  If
>>>    present and zeroing was requested (but not tag zeroing), skip
>>>    kernel_init_pages().
>>>
>>> In particular, __GFP_ZERO is used by the x86 arch override of
>>> vma_alloc_zeroed_movable_folio.
>>>
>>> No driver sets host_zeroes_pages yet; a follow-up patch to
>>> virtio_balloon is needed to opt in.
>>>
>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> Assisted-by: Claude:claude-opus-4-6
>>> ---
>>>  include/linux/mm.h             |  6 ++++++
>>>  include/linux/page_reporting.h |  3 +++
>>>  mm/page_alloc.c                | 21 +++++++++++++++++++++
>>>  mm/page_reporting.c            |  9 +++++++++
>>>  mm/page_reporting.h            |  2 ++
>>>  5 files changed, 41 insertions(+)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 5be3d8a8f806..59fc77c4c90e 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -4814,6 +4814,12 @@ static inline bool user_alloc_needs_zeroing(void)
>>>  				   &init_on_alloc);
>>>  }
>>>  
>>> +/*
>>> + * Sentinel stored in page->private to indicate the page was pre-zeroed
>>> + * by the hypervisor (via free page reporting).
>>> + */
>>> +#define MAGIC_PAGE_ZEROED	0x5A45524FU	/* ZERO */
>>
>> Why are we not using another page flag that is yet unused for buddy pages?
>>
>> Using page->private for that, and exposing it to buddy users with the
>> __GFP_PREZEROED flag (I hope we can avoid that) does not sound
>> particularly elegant.
> 
> 
> So here's an only alternative I see: a page flag for when page is in
> buddy and a new "prezero" bool that we have to propagate everywhere
> else. This is a patch on top. More elegant? Please tell me if you prefer that.
> If yes I will squash it into the appropriate patches.

I'd be interesting to know how this would look without the GFP flag,
when we don't have to leak any of this out of the buddy.

-- 
Cheers,

David

