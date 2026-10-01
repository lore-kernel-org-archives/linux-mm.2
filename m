Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4020CA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 16:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0C066B008A; Thu,  1 Oct 2026 12:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E30A6B0092; Thu,  1 Oct 2026 12:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB246B0096; Thu,  1 Oct 2026 12:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6BEAD6B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 12:07:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6EE551204C6
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 16:07:53 +0000 (UTC)
X-FDA: 85274538426.23.E33C3D4
Received: from mta0.migadu.com (out-220.mta0.migadu.com [91.218.175.220])
	by imf17.hostedemail.com (Postfix) with ESMTP id 42B964000F
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 16:07:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rLnx4miu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790870871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+rRTTSo39ujkgMqAmXbsmEGf9WZCcK9Kch9Skm9J2g=;
	b=Hyz3ClymQK93JuceVUnRpBj+/TiZlJVIil78YyBQYNIosxWWTU+XOREf4ogSIUWPIgESJM
	wvUcYn8yxsr8UeJP2R8KKz0w6K47eqr39axpUexpUfqo61Dfit00j6c0sz8RoNnnaWJr0R
	NUXMxDAN0AteiWtOogy/udfbRhQSLVg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rLnx4miu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.220 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790870871;
	b=fPjSX9yQt0PT/VmIHkYch31cP96kSVK+CgTBqM47whpIE3Io7VlGW4SZSbsMvlPfwt3Wg9
	eqDBMMekZ2uVvHDv8ZDk8BTKesiK+zXwuI+RSTWm80n4QgOd+r/QT4H5j6o9XThZC30uaC
	js1qnqQSv2Bc/lk9pqPpqkgtoByKKJo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XKakuNwu3Om7gwJbEDCid2bRDqw/CvPpxhwYERhBdAY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790870868; v=1; x=1791475668;
 b=rLnx4miuxqSZqAa89KPYNmCICPUM4ZHMu0+z6jrjyedz9XHedhQXDO67ofThf5Ik/L8VbTnh
 6+tNHwI5PwjsqjDkftNrXdQ5kLA86UXKysX1ByqRLMlsvLaGLnfyy4N1oZpb/OwTIUk919IWKDC
 IWf/DWjE1DQ3TMz4C74sW6DU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1d5925f2877bd100;
	Thu, 01 Oct 2026 16:07:47 +0000
X-Mizu-Trace-ID: 1d5925f2877bd100
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: rppt@kernel.org
Cc: songmuchun@bytedance.com,
	maddy@linux.ibm.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 6/6] mm/mm_init: add zone mismatch warning during page init
Date: Fri,  2 Oct 2026 00:07:37 +0800
Message-ID: <20261001160737.25348-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <ar5xbQsUpSQZg0wO@kernel.org>
References: <ar5xbQsUpSQZg0wO@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 42B964000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: og43ug1518b14r3e66bzxwok8doncktj
X-HE-Tag: 1790870871-84488
X-HE-Meta: U2FsdGVkX18vtd48MgYhKVFGGMhlhX2u+SqF4xYwoEcFdLGKYD3eyMxknIgkscwxv2+vPoANHfO64xuHLR5TpjgR5cyh48k59bZgC7Ac0l4cCmDC1kodpMikQXHD4DjHyx59X0U9pq+NGiXx4v2mc2zDmYgj7pozvAKGO9RXNYxTf5njgMD3RYqfIPj6Xk8li6nIoPXIsq98D6gR4S15F3A9ljPR/6QCzwT105ZxrCKNs7AeKq89ylQriyM4UbPa/TUbDc8ni5+YMGBVI8GjM01FjtqODZNd9yynZmDIZlpm6WMGwqcYd7B3/gTcVBViKjv+u7boT8ah8r981TtlqZ+jEsx+PKQSWoRSGCQhzUiEPu5vOecIR+tpFkztja3tBAA01vwrTka9YsK6Atp9Egm/tPxBMWBFh4ZOZYWvuH8wMn6YNp9GtWtxqk5+n+ne3+F6h9N4bJPuaFiW3e5bfzYuOyhiUllIQ5MxupEgEO7Wvk6qoJjfPwQNs77nEd/2mkQ6V0MzkjNPgfBXWwRdUmzb0+N8HAKqTfNTaqsbWKks0r7swHwsp+p6G07OphYRxsue0GqHAmcNj/HzFcq6QH7PyFmtn6DVn6IdX5Hqh73bVT41w0SMtMxfCNiWgP7ixow8sypvcC491rAQJNaKtEFXRL9JhyG6+Kb4pmu1VFP/Gx83q6Y8wjxG5oI1dDkGgPhxrSf4uki+lNm0yWSH+g3aICblsaD8ps5Gtezoirb67kux0GgspnS0tZl3Z2/XNERqOP0EGmPh6RFNr5FUOrn8rR7qeM7pIfVF/tqFBXL0FM1IvwbZk+lzy3ytxvS5EbNrorCz+yFSrpbFtDVuGhHIY2H+aDKb34c68BXVSeL0yjaHTjQVVrQyagkszgCNxzc/h7z7uYbGfvPzuNNynV5QSgygJIwm+VvRUSRs+RubDaAdFr6opGsQjBPv21wOK0w/k/HjqjkPc7AG69O
 1f1ZXTvQ
 SWfg/X5fWDmiy6IKrBIEHC16WrsdQk3L5BiBnKs7aR0uOFwiASaCYmaY200qwiRuGomr6YJoBxwP+NZPyCzZd/P7ouX69hDeuT2CBxEwGkUXyWyoihW53Q9lIuHuyhO3MBrofk58TZYGxBQcFt6RRVFGE0uRxSaa4B5z5wDK9TweDSsZV5qJiXIdHJLS+EAIgdQsdahd1jQfzg8JZRHAZTJugpSt0/TTwNjUUREHVTrdTysYoKKwNrfTHEgf41AgVQHGYKusS9r5vJ4tzRYqw2KpXQsfs1/uCmjIH1K5H9QhnN8q9Fe2HKFFtI/StrPV/DUyd+FNpy0hkdIF/kscx8+LfwfrcHxDfiiTGIE5QX1k14eVvo76+qzlGXLrAcPF4u4GR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Oct 01, 2026 at 04:42:53PM +0200, Mike Rapoport wrote:
>Hi Muchun,
>
>On Tue, Sep 29, 2026 at 01:32:31PM +0800, Muchun Song wrote:
>> For vmemmap-optimized sections, tail struct pages may be backed by
>> shared vmemmap pages. Those shared pages must carry the same page zone
>> ID as the struct pages initialized for the section.
>> 
>> Warn in __init_single_page() if the shared tail page has a different
>> page_zone_id(), which would indicate inconsistent initialization.
>> 
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>> ---
>> v3:
>> - Collect Acked-by from Qi Zheng
>> 
>> v2:
>> - New patch.
>> ---
>>  mm/mm_init.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 1650d6bc1211..bd02e8d06965 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -609,6 +609,9 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
>>  	if (!is_highmem_idx(zone))
>>  		set_page_address(page, __va(pfn << PAGE_SHIFT));
>>  #endif
>> +	VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)) &&
>> +			page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
>> +			page_zone_id(page));
>
>Hmm, page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES is initialized a tad later
>than page so it'll have stale data in the page->flags, won't it?

IIUC, the shared tail struct pages already initialized by
vmemmap_shared_tail_page() during vmemmap population, no? It calls
set_page_node() and set_page_zone() there :)

Cheers, Lance

