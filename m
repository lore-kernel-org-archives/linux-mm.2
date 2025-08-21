Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EADECA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 12:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068DC8E0007; Thu, 21 Aug 2025 08:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018EF8E0008; Thu, 21 Aug 2025 08:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4B5E8E0007; Thu, 21 Aug 2025 08:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D317E8E0007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:58:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E385138565
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:58:00 +0000 (UTC)
X-FDA: 83800767120.08.292AE6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BA294180011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:57:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of "SRS0=upZg=3B=redhat.com=david@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=upZg=3B=redhat.com=david@kernel.org";
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=redhat.com (policy=quarantine)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755781078; a=rsa-sha256;
	cv=none;
	b=ouU0gHR6blBogdw2M9iqtnd1tNW0O9tg5E5TZKq9JowAxLnI1JEbCTwW9+98WPDEU1l4NI
	WRyWvZwvClnHuwBLi2kiWl7BetGx/rwMNC7G9bT7DWV31CMAylqoh1iS429CaXnyE1ACCd
	QYSbbzriaSRy4dteYpP+0wW2X2scacQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of "SRS0=upZg=3B=redhat.com=david@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=upZg=3B=redhat.com=david@kernel.org";
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=redhat.com (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755781078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wfdnY1BwFUCgHXS/vIw0HtsEknUc+zqFe2NOZ3p897E=;
	b=LyHnlCduKDF1KZo/brItMMkvM15VNBNFXvagbzLBF9kGczvqOBVw6LIVnRXf98oszQ+xuB
	QGa52hDi+P+tfIPzfBrUnpyb3hgPCNVt7FPgdPXxe3nq0WD3zyUh+3knH6NjoV5W+NOmif
	Fd5NHjCuT5PGY0Q/+dSlOxYSDPvqf40=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E091C61152;
	Thu, 21 Aug 2025 12:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42653C4CEEB;
	Thu, 21 Aug 2025 12:57:56 +0000 (UTC)
Message-ID: <bb6e89e1-ff86-43cf-980d-b03b644d85be@redhat.com>
Date: Thu, 21 Aug 2025 14:57:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] filemap: optimize order0 folio in filemap_map_pages
To: Matthew Wilcox <willy@infradead.org>, Jinjiang Tu <tujinjiang@huawei.com>
Cc: fengwei.yin@intel.com, akpm@linux-foundation.org, linux-mm@kvack.org,
 wangkefeng.wang@huawei.com
References: <20250819140653.3229136-1-tujinjiang@huawei.com>
 <aKSdsH_yk69EvkMX@casper.infradead.org>
 <b7a1100c-2302-4781-97c3-1146ed2b44a7@huawei.com>
 <aKXCz0QOlE8QkPIn@casper.infradead.org>
 <98f0333d-1ae6-4a5b-b5cd-c8abddbfae5e@huawei.com>
 <aKcU-fzxeW3xT5Wv@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aKcU-fzxeW3xT5Wv@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA294180011
X-Stat-Signature: d9zq5bs633b13shfniaof9csqpf9q718
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam-User: 
X-Rspam: Yes
X-HE-Tag: 1755781078-4208
X-HE-Meta: U2FsdGVkX19L1RuOoLYlk2hA01qq6Hg5ED5SsScMkGa2vg9Kq9bh+HD+Zei285gBD4NOv0EYn88eFuWvDKisY/FDO3OOUoAMKB8CtzO3QC3gpLJ3+2EWjoRQVIzarDQikTJDLn/f03gP5SN+CCpDzVxTFuv47JC2HJy5gwA8vmDsRim+DX1IkJpPSIigStSJRUf7cG0ZxdDrCps2LEMbmhKlHlC9DavKXf2e40vddgVm/aGVlnRFzOQ1P43mCB8nviQWYR68nkFrky4bxQZ7KOEIjQZUnNnUFkGpAyX2efd3P8I/8McIaJR5mA8IVil7ExO/mlYXFe9SfqNkuqKWPcgQCSgbjRVB9PUimnZQ1E8YvSNNrcvBhx1Vs0Skwz2W+NSRwjX2Uy5bTsYpC+U0taEACkDpP3+3McRtgbI9JjddOkkAj47RGtxUaYBDBPglLCT1RZRR8EhT9fm8UX6ET9UXueF+Xtj9z36psJfUTn8YSvt5PWZawglfcX7S9wm97ZV6mEGBU88R4QXuyXZ2Cb76gMOxp+ZjOxiUxZIrFvO2tbf1pl6Vr4OSP6U86QJ3fOu7+gwEPW5mU0ggg2gdFfNXJOZWcSFoqgaBFAtDPIZBbNuXu+aiiLZV4igeFeeEdHKBZN7YRd4YGxN/VMuSpQGhEbjA8GATBszPgREnluL8krAw4C/kzlB212LSQ2zK3QHLEdTMe69kdmCCxyJIWVJ7MzMTDuB7/kCH0Q8dwLxUdzFf3UZsx6LLXdhGLi8ApEXFFI9eI4DSYy3L6uniY46UWugMTlHv9fH3osM2rS3JMRC43NUlBH1MbB/4R/J63z8/E74l3R+jhkw+0BCx2ROUZYgzJhsngT8UopCrbdsTBkaSWgkeAm+HyyIgkU8WG7+hB+WwoGeAvXuF7x53h6rCzQOXGu+reI6Iogiyi7Tor4WyTzQec0BkkGYafOE8PXRHiNe6CFiivWkKjcu
 sCGqmryl
 DekGF7bF1ZlwMZW5ijh0bFVQlqN98E80ADYNFOZdsgkL7Q+cFr1UnMAFcuZN322AnfTqSy1qK6cC4f3eZPddtdVUDkYLCaXszWpkIoF6jzNvmIur3JytKk+0SgEELiwH4VHKjPWdSVdupryu6h3daVztcmTngGo+Mm0kkgUutqSdzwnSZ1aMfHHX1hYwmllWfke3Tt8CJBehVDtnts62wTilg0axhK+NS/TG5fiJn7z9zC0RuU6WpS/XvSYvYapvhBFUKqvX1EgoFDDdWIFDA3MknWIJQrWzPvvqQku5ZjxfM2MK3ejUQHIWmHXd5OLzq1eXncEnV1lwZ9Yz6ijJ7mu4SfiexL+vwrVkVN9AMdqC5hIVraFZUu+BNhBQQ+OcYAEHaaf7ce0OwOP06xNbXXebUigYprszkMpd3CxSTX7A1Tm+fXbRKix5BZ8U/gudz5JwyLJvZY8sW1DCDaCWvRW9BBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.08.25 14:45, Matthew Wilcox wrote:
> On Thu, Aug 21, 2025 at 09:22:48AM +0800, Jinjiang Tu wrote:
>> 在 2025/8/20 20:42, Matthew Wilcox 写道:
>>> On Wed, Aug 20, 2025 at 09:10:56AM +0800, Jinjiang Tu wrote:
>>>> We should call folio_unlock() before folio_put(). In filemap_map_order0_folio(),
>>>> if we doesn't set folio into pte, we should unlock and put folio.
>>> I agree that folio_unlock() needs to be called before folio_put().
>>> What I don't understand is why we need to delay folio_unlock() until
>>> right before folio_put().  Can't we leave folio_unlock() where it
>>> currently is and only move the folio_put()?
>>
>> In filemap_map_order0_folio(), assuming the page is hwpoisoned, we skip set_pte_range(),
>> the folio should be unlocked and put. If we only move folio_put() to filemap_map_order0_folio(),
>> the folio is unlocked when filemap_map_pages() doesn't hold any folio refcount.
> Oh, I see.  I misread your patch; sorry about that.
> 
> However, it is still safe to move only the folio_put() and not move
> the folio_unlock()!  It's a little subtle, so I'll explain.
> 
> We must not free a locked folio.  The page allocator has checks for this
> and will complain (assuming appropriate debug options are enabled).  So
> this sequence:
> 
> 	folio_put(folio);
> 	folio_unlock(folio);
> 
> is _generally_ unsafe because the folio_put() might be the last put of
> the refcount which will cause the folio to be freed.  However, if we know
> that the folio has a refcount > 1, it's safe because the folio_put()
> won't free the folio.  We do know that the folio has a refcount >1
> because it's in the page cache, which keeps a refcount on the folio.
> Since we have it locked, we know that truncation will wait for the unlock
> to happen, and truncation will be the last one to put the refcount.

I agree that it is save, but is it worth it having that subtle detail 
here instead of just doing unlock+put?

IOW, what do we gain by doing it differently? :)

-- 
Cheers

David / dhildenb

