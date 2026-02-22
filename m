Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD94C6369E
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 23:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786646B0088; Sun, 22 Feb 2026 18:51:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7349D6B0089; Sun, 22 Feb 2026 18:51:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63C736B008A; Sun, 22 Feb 2026 18:51:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB046B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 18:51:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D207CBAED1
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:51:07 +0000 (UTC)
X-FDA: 84473740974.10.AFEDC39
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 06CF714000D
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:51:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d0mozPun;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771804266; a=rsa-sha256;
	cv=none;
	b=w/Obk1bFlHfFuSFYTmOuqEFvCwEzH1TMCamOEkXWCZtqPJD8/pdjB0+tNwg8rrUWHVdfKU
	wUdbs0rKHh7IjvlddEI/neFaA1wmN7iz84HE8tpL+FxckDl2Ljk33W+ViUtAlH+SgXEbyM
	181w2QBZUoLy/f+rMfsCvEpJIGg5fMg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d0mozPun;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771804266;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3DenEUfvzZ4Gn6BP0nDuZ8nQgEdkOBl43ceISWkWLE=;
	b=Xju6IuA3AXsW88XqOKovkWsJO/02COJtbq2Y7BAwyU9McTuLqOxADmCSzP6j7CJv+FDdKU
	02gNVJOkum27A4qzLbg2CFshAs3vdzsgKFpNu2PxMhRxTZYrehJKNeCNNN1p3A25u5H+AZ
	Ct6ZsQf5L9mu+22afXihc7gT+wxntVA=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6597a7bd7d6so4957383a12.3
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 15:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771804264; x=1772409064; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a3DenEUfvzZ4Gn6BP0nDuZ8nQgEdkOBl43ceISWkWLE=;
        b=d0mozPunvq3AtBF306VrdXxtLJDaPdt/ygMc1JOGNc5+wN16KJm3rk7YB5RfThvY/v
         Jw/1gLaKu8tUMMt6nlJ1hQWi2PzyupHJXC9LrF43zVLyjMG3gCs4kYiBzB5AmuAm4Y6l
         bClRX/FXFplsajdt5U8307eqkHkf/5Bwcg0ft4w8t1d1rspXXDMyeExoAgYsKvB0aFyw
         ESo+LcoE7jBc6X1jhuGTXrIk5HGpT7730oh+Acfgr4XeSaCOUZabYDo7T+v7umv+SNyV
         QHcOo4jZoqAPsFvk+6zK/qDFtfbkZoXA6eC+iv8WMO7Nps/M9kV3P4lvrTFAdAGIal6G
         meAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771804264; x=1772409064;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a3DenEUfvzZ4Gn6BP0nDuZ8nQgEdkOBl43ceISWkWLE=;
        b=HjWVPnlcD2zNXKJugTzMV6gjFaaStYt3ftUAJy6n297zz+/AYVUh08C4BxBq5mjFd4
         TX+7oIZQSKdksSrjPzHO4gD6Ap629cTbcTxP//tp2lyojpFj22hrGJDvgcWsGLJh7s4y
         P8Joqbawwy5BurGFpZcOtqjSXdkDAXHsGq6lmaWAwrQA/Lrv2BwKNp8dQZA/1E14gD55
         5qsvqwQc5szpQNMBxZHTKSznckeMIQkfZhGmbJ7xcbsofcZDo3HxoY7l+qX0nYpk3ZvE
         MSCWN6T1pPNxzfMLnyAa8TtUpSSx7IK+fAtgpNikzoo1Jza1xe9pbn8NI6fmieN2g+Ev
         wTZA==
X-Forwarded-Encrypted: i=1; AJvYcCUtUFw4BlKjvPpQa2pd78oMfsRhsw3BQJeMgfh/Cs5fjmZseSgasDrQI3AdWTJuKVSUow6JP3zoOg==@kvack.org
X-Gm-Message-State: AOJu0Yyn3pNqN7uCcxZAE9+ElHY5uSHUNLmElOd9pnZyaSZF6Vs7JS51
	odNRJgaVtZGZ0M6TeuhDKmozeG2dYO81Ha0G+vBWTNS9H1MrggIQUUTd
X-Gm-Gg: AZuq6aIiq6z7ySel+wnlhNg8L+MBv+VlReAKI9i79jBY8aQBxJ5y0tZwzhqmfyNVxh3
	l2FREG0LsaiQ/AlR1mAYQ1lU/oj8os8ehi+CWme9SKoRAyg9cZAO7ul7JlOMpuCx/1xfKscawZi
	nJoheiLWvocIBnOEJCy/4i1S8xOeSLJKmSByixq0oJrca7sGQz8JaorvHxBMrI0HpzhL45+FaDh
	3nDIxyVHUPvnVa5p7UwmFBvFjn97m7tpg3DCwA+stC5+ZX1BJftqFOMjjpqJV/YF8lUwACp0rmo
	lgW+qHn/gmNQFy1FhXGPKTsdTEsr9so8PFjkHr4F4QDXIPwoyBAcMBnLsSg1yUIk6efy3xYsdpc
	Y8tYCaas+BsLwGOh+pfoN0cJgBmTOtQl8d4oFV1KZZ9MHGQusXC+B9EOf84xbZIq/c2piKcrqhe
	l7JCdFV+IBXVjgKLo8pb6RRg==
X-Received: by 2002:a17:907:1ca5:b0:b8f:a32d:b90e with SMTP id a640c23a62f3a-b9096709ef4mr238666166b.34.1771804264073;
        Sun, 22 Feb 2026 15:51:04 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084c824a3sm263031566b.21.2026.02.22.15.51.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Feb 2026 15:51:03 -0800 (PST)
Date: Sun, 22 Feb 2026 23:51:03 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, will@kernel.org,
	aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	Qi Zheng <qi.zheng@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH] mm/mmu_gather: define RCU version tlb_remove_table_one()
 in CONFIG_MMU_GATHER_RCU_TABLE_FREE
Message-ID: <20260222235103.firb34hgaddqsc2i@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260222004512.839-1-richard.weiyang@gmail.com>
 <20260222114201.095379dd766b68dcecbab1c5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260222114201.095379dd766b68dcecbab1c5@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 06CF714000D
X-Stat-Signature: bnfz5jp9nhaubfcq36ubmoz8i8f5u5ab
X-HE-Tag: 1771804265-557020
X-HE-Meta: U2FsdGVkX1+BmsGO1KU+V9p8KrEzBiOYgXHoCq8MAvzdYJz0NXvNY9dHF9TAuYBQ0ZG2BNf7DNxSkSpcPhxLR1WXVlvvkT2Otvwx2fC1lsqo41HQI0el978sX9qUNyYqRQW6j1VMhmS7ABur7eJw+3GcFgoI1r6l3IW91DLPRaqbG/1ArkLaNAn+we+mGH37pj6ctuxal3mop2oLFDEVGluWGRv4/aWNRepIcavPWbjKpnF8ygoq5Zl75cvLBBIIPOiEyBV5JhFX/67DOXRw+AXH8Oge49J8ccN3Bilgu1zWvtBkiwQ3stKYVFzoBULngQACOroUcl1u2biLy7HrI2XeoC9Xb9ee23wvDj6gXKtoNStoL0Cb/0xAo36LkZfQ1+Cme+kABL31vO1R7jEvUerhLHPJvfwyj1jS5QLaH7b6h9+AjWsIEK4UShkMh1drThZiaNixmxLS/THMV1iKmzD1pYJHzSrOIlfTuDBydrIt6EpJK8uFBHam5GCvPVT+iHLYMZ1RARlRjATxuHZCNfvwQY5cb9tlqhAETgvBSL/KtzGg1psEN/tgJ0CQ38uNio/5vFcaMxV8lgHu+ze0M5eN2PG8Po/1zrihw3KkSCe/lVK9woruCae7KTHRv/mJlTOGMvadVEVcyN4f9U6fkQ2ho7PIwT+z0+0dDqh2GIHq7zNj9nvQv4eT0S2UGP+C4eAA3frVF/3bVNy8Nu9joEKmX2DpFDoawBetvnkNV08YPvwQPz0QMZiltiRl50BpHU94DqXBgil4R4qFkU9unpPyyW5enKJpjc/tsFGzzPyPxG0LvWd6T1j2NdIoD3EIV9+EERt0fbSvZiA2s0tRHkQfopLt+A7G+IehuNvBrmrJ3mCvWdedCjy4lrzmc1lFEEOST/1rYXC2NGDAPUDlWAy1oHKnPVL9JRdA/kgPe2uIAM9Z/K2+xXstd6RoeguFm2JOlfZJdS9xZBr0+gA
 +2uxDjXF
 fo+7+fXwbKY6y+YeWflrmT6hm3CID5Q6JYQtEQwp767G4xQ7JMMwn4wpq7JY02HdmTJo/+SF1k6cVWe7ck61l4vah/9uPYxsM+bk8cEuZjUYjg0INMn1+gnqwUejdPAUHxhSCS5mBAYs9wAR+IdK9JCnW/RtAXA967OfjhEgYcrkCPM0vBn5cZ8IK4D/g/ZnYzER+A4VksOZeb04sCQAmG4FGcfduv2ZY9rH2RgjTRXy/NWJKxNGqcpKHT56TstdpWoq6u951UN/EBsLyKorF/jfTOsSbCwDTbBpQtTqhCpczv+zj1c6T1zY1h5HUMhK4aylF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 22, 2026 at 11:42:01AM -0800, Andrew Morton wrote:
>On Sun, 22 Feb 2026 00:45:12 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> Before commit 718b13861d22 ("x86: mm: free page table pages by RCU
>> instead of semi RCU"), the page table pages will be freed by semi RCU,
>> that is:
>> 
>>   - batch table freeing: asynchronous free by RCU
>>   - single table freeing: IPI + synchronous free
>> 
>> This commit introduce a RCU version for single table freeing to support
>> PT_RECLAIM. While it is not necessary to limit the RCU version only in
>> CONFIG_PT_RECLAIM. It is reasonable to asynchronous free single table by
>> RCU if CONFIG_MMU_GATHER_RCU_TABLE_FREE.
>> 
>> This patch moves the definition of single table freeing in
>> CONFIG_MMU_GATHER_RCU_TABLE_FREE, so we have both RCU version
>> batch/single table freeing if CONFIG_MMU_GATHER_RCU_TABLE_FREE.
>
>What are the expected (and measured!) benefits of this?
>

No, this is just a cleanup.

Last time checked with Qi and thought it worth a formal patch. [1]

[1]: http://lkml.kernel.org/r/fd90c84b-9829-4699-b7df-c43020519ec9@linux.dev

-- 
Wei Yang
Help you, Help me

