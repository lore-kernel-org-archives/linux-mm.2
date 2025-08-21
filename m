Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B8FCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 13:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 999DF6B0025; Thu, 21 Aug 2025 09:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972206B0026; Thu, 21 Aug 2025 09:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888526B0027; Thu, 21 Aug 2025 09:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76F406B0025
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:35:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 101C183473
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:35:22 +0000 (UTC)
X-FDA: 83800861284.11.5EF214B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29069A0011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:35:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of "SRS0=upZg=3B=redhat.com=david@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=upZg=3B=redhat.com=david@kernel.org";
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=redhat.com (policy=quarantine)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755783320; a=rsa-sha256;
	cv=none;
	b=bcCggEu95EUoZChjJ53dT6FSFRnowKfmUF2LZRwQdPYkdnPhhCSlfSvNUUaaPMqJJ9hDqt
	VMrAkdGkagtiE1tUklp8RqWTm+aVUllo96Su9wdlWrrXztqKdWrWEy7ndlPmrmb1dwebEy
	BonUPXBemE4MWVxFbyTlYmx9TbWw0Is=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of "SRS0=upZg=3B=redhat.com=david@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=upZg=3B=redhat.com=david@kernel.org";
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=redhat.com (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755783320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RY+aercF7b1LdhRy/1sDm+Q4g/EoO85QNwp+rPpCosE=;
	b=TGolNHp9r8a9KAUcYfMydlK/71Y2HwAxw5yBG5T9nWXKRVdtN3U5iSghPut/17tGKfPGTB
	LHVVSm0uJr/qRe7CkmrEUQFKGgTsdCkzz01Lm+7P79ICxLmBhKQg6lQpIlAv96C3eOwbXK
	+Mu1TMMYhQGQH7+pRzTv+i04Q69IfUQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBBA34198B;
	Thu, 21 Aug 2025 13:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53723C4CEEB;
	Thu, 21 Aug 2025 13:35:17 +0000 (UTC)
Message-ID: <b990aa82-bc98-4739-89e3-44c96e0117a1@redhat.com>
Date: Thu, 21 Aug 2025 15:35:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] filemap: optimize order0 folio in filemap_map_pages
To: Matthew Wilcox <willy@infradead.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, fengwei.yin@intel.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, wangkefeng.wang@huawei.com
References: <20250819140653.3229136-1-tujinjiang@huawei.com>
 <aKSdsH_yk69EvkMX@casper.infradead.org>
 <b7a1100c-2302-4781-97c3-1146ed2b44a7@huawei.com>
 <aKXCz0QOlE8QkPIn@casper.infradead.org>
 <98f0333d-1ae6-4a5b-b5cd-c8abddbfae5e@huawei.com>
 <aKcU-fzxeW3xT5Wv@casper.infradead.org>
 <bb6e89e1-ff86-43cf-980d-b03b644d85be@redhat.com>
 <aKcdBrq_xwOeUQTp@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aKcdBrq_xwOeUQTp@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 29069A0011
X-Stat-Signature: gw6ep6aj8yjapkb5881az4ddyeiqkakx
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam-User: 
X-Rspam: Yes
X-HE-Tag: 1755783319-995870
X-HE-Meta: U2FsdGVkX1+TlxsceQdzIH07O5TvWWdnOZOSUdJmugHOBXzx6+qZsnQnOcKYWQJUCAdvLggbZ726oiT7KAMSWZQ+rMVv/9ri/9OFwwjWtMLmtbmF2UOuB9bntraLvorPjH/RmAXRnNNc4SkuJ0fa83gsAsoSKcKC1udJ0M34XKH6az7ZQKFrE1Z1rYgYnZsScV0luaZXafEEETwr9/o8Lm1psSm5hS55RJ2MDSmQ/p7ByKJNY96FPytZrLfeNOoqPyJKKe3bRYUpJd5/RuUT55eJIfnK5xeQBgShZcGMjnUxu5DTHIrIenqUD+1dmwRiINCuEA4QIUhxIXVDD+rM7DqPAO7VPKpssk/VTurm/zJLS5knOVQF7IZayob/vZe0dQUb5//vSY0uuaIKulStguEA2ddODK9TTuhUaW0O6CA1x4z+OmgIaOk0hy4gALsXmgWx/N55RstUQGdDixZbVi85uyp47UugOCQ4OSkwdX5rVGahxkjM+l3aFNWvNgbUYpuL6XrNl2R7nO/93HETKqVUsg7RdBmIi1Ocb58TvD1HNoalBwtEznZux1k/1MEo5dHlrP6UE5liy/+8UXlZ7aFjbPthZrNuECvtTdDTgnF6FdJT4dV+r2Mzuy6+oAR1Rg6UX/PTdJRFa150iIwePRRETej5BXSEEBv0cIda/GekQc4bIQbsRmX2UMTy5L+6KbG8nyz93Oh1bPNTlS6oIVMvjvaIgxCM5mGcsYbEFNC3grsTwNG3im+uDPf0C+tGwQXlkmmQ5RY753fxqQrfiXSGZ18SsqcZ/OmBWQOE5Fv9vSlJqv0A0vK1wKDlGKiwx5b652CvreE3tj1EyxahK7k01GF4XmZ0TH2VsH1aadl00CbuaD7FKScT0uN81JUHgQiP1P1GDLjExu5E52c39qrxR0EJO+iZ62i9YMfUraB/PVODmq0dR6Idi7Ww1AFKyBRfDg/u+eq7RtVEX0r
 e5lIslJk
 fcsB+xN/EslyHK/JBBCsYoxB4JAP/owf2o/3ONaYxlN3unQOJ23VMjUWPpvw5kSXr8wl3AVzU0+TOUVDtNqZn4FyDgaKHOj3t1v0Mhb1IBcneX3YRwlvOF9NOT1PSAqPAyXPKHxlcYy6LaT4HPJcU+g/+wlP4lfDhJvh6kQ5dQD+rtDzdRu7NxNhVQa9wd6kuXmpildV51rrfk0jLGlvoX+iTc/8RAA3lframRSWLFOTFFo8yohkkzF0nN7UZ1WrZfezVnNerty/RzPnoXh6ravvwTAkdtMoKGKSXTQzPUm1ap1hrj48uirl+k1T0Weoa/woj0sgGGL8qq+M58aPCDpic+YmLidm3oYE2Yi+Tx1jYFSpgoTzy6SVFSl0Ps1oeVN/xcmaDh1CzhJ14+gqg0I+iY2XiGXxH4Q+Gb0XeL2QQDhsBwZdQ6nUR5OmZ/6iwzjg8xdWPdgRtz/Q2D1kGl6cBLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.08.25 15:20, Matthew Wilcox wrote:
> On Thu, Aug 21, 2025 at 02:57:54PM +0200, David Hildenbrand wrote:
>> On 21.08.25 14:45, Matthew Wilcox wrote:
>>> On Thu, Aug 21, 2025 at 09:22:48AM +0800, Jinjiang Tu wrote:
>>>> 在 2025/8/20 20:42, Matthew Wilcox 写道:
>>>>> On Wed, Aug 20, 2025 at 09:10:56AM +0800, Jinjiang Tu wrote:
>>>>>> We should call folio_unlock() before folio_put(). In filemap_map_order0_folio(),
>>>>>> if we doesn't set folio into pte, we should unlock and put folio.
>>>>> I agree that folio_unlock() needs to be called before folio_put().
>>>>> What I don't understand is why we need to delay folio_unlock() until
>>>>> right before folio_put().  Can't we leave folio_unlock() where it
>>>>> currently is and only move the folio_put()?
>>>>
>>>> In filemap_map_order0_folio(), assuming the page is hwpoisoned, we skip set_pte_range(),
>>>> the folio should be unlocked and put. If we only move folio_put() to filemap_map_order0_folio(),
>>>> the folio is unlocked when filemap_map_pages() doesn't hold any folio refcount.
>>> Oh, I see.  I misread your patch; sorry about that.
>>>
>>> However, it is still safe to move only the folio_put() and not move
>>> the folio_unlock()!  It's a little subtle, so I'll explain.
>>>
>>> We must not free a locked folio.  The page allocator has checks for this
>>> and will complain (assuming appropriate debug options are enabled).  So
>>> this sequence:
>>>
>>> 	folio_put(folio);
>>> 	folio_unlock(folio);
>>>
>>> is _generally_ unsafe because the folio_put() might be the last put of
>>> the refcount which will cause the folio to be freed.  However, if we know
>>> that the folio has a refcount > 1, it's safe because the folio_put()
>>> won't free the folio.  We do know that the folio has a refcount >1
>>> because it's in the page cache, which keeps a refcount on the folio.
>>> Since we have it locked, we know that truncation will wait for the unlock
>>> to happen, and truncation will be the last one to put the refcount.
>>
>> I agree that it is save, but is it worth it having that subtle detail here
>> instead of just doing unlock+put?
>>
>> IOW, what do we gain by doing it differently? :)
> 
> That was in the initial mail:
> 
>> With this patch, we can get 8% performance gain for lmbench testcase
>> 'lat_pagefault -P 1 file', the size of file is 512M.
> 
> Obviously the exact gains are going to depend on how good your CPU is
> at doing atomic inc/decs, but reducing the number of atomics is always
> a good thing.

Ah, yes, obviously. I misread your mail, assuming you would argue for a 
further change.

-- 
Cheers

David / dhildenb

