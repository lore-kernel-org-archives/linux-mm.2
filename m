Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA72FCD98FB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2396B008A; Thu, 18 Jun 2026 08:58:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9E36B008C; Thu, 18 Jun 2026 08:58:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498D76B0093; Thu, 18 Jun 2026 08:58:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2013B6B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:58:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 930EE406FC
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:58:45 +0000 (UTC)
X-FDA: 84893037810.01.DA6ABA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E63B24000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:58:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ctpv1ayz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781787523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ivz1DyTo0J84nVXXYf8vVRV2fher9kNuAq0AcbuKdXg=;
	b=JDfLh6lqITF3Loz771jb0bJjluc1cG2S4pE7F66LwTGZexxE7uGu4Y1P6pnBNhGzfcE4s3
	xKSX4m7gqzqUCoNirFNJ2gWNOqCOPmYJoQyjMk8YWVEz/qphzu56RSLN/GX4KiWK/QMKeI
	RN8a41HkS9MXf+xNj0KUNyvBfCmF6bk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ctpv1ayz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781787523;
	b=MnsX39TBj2tf5FKql+4Wu8BpGDVSOUncp/foC72g4zeh1jT4XzHLm5PKeiE0xdUYkfgvDD
	R6ReQ/sjMHGcwwVByqfo3pWNVBRhMhfCQSGDzeA7G0bVboa2hIhS2Ljp2fMCvPfyDiNDTK
	rsxu5TSz1CxKg+cbR9kHPNtHo458/aY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 676F160120;
	Thu, 18 Jun 2026 12:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C131F00A3A;
	Thu, 18 Jun 2026 12:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781787523;
	bh=Ivz1DyTo0J84nVXXYf8vVRV2fher9kNuAq0AcbuKdXg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ctpv1ayzFZKGhkR/oi5ScZKpMiaY0tKFvGz/+QCD9XoUIh0ywNeX1BXv0v+neTaP3
	 Yw1V9JeL0wPUf2e00BsvjVS9XaWg+GF75ke+Urzuqjn5PkPlhE9anbQEUVLu0dF/Ry
	 qvsqOEN2h2tGsrSpXrArqsLuCNGv0tzkc23vrWvi8wLTqGHfbstMFVa9TSB6Ho39m3
	 hVjHxF80exzWfRHnTJWAjnWGTms6O/72LcxuKlHX3CUWptxtQiSw6xUeW37Il/EaXa
	 2VlL3MPeE11iewCe623BTUThIIpsCoDoYeYw0qg8yL5QiAir2Thoz6F9uekusJilnT
	 PQTkhK432zCow==
Message-ID: <58703c2e-867d-4b81-a78a-0802136bb379@kernel.org>
Date: Thu, 18 Jun 2026 14:58:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: mincore: use walk_page_range_vma() in
 do_mincore()
To: Pedro Falcato <pfalcato@suse.de>, Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
 <20260618092845.3905740-2-wangkefeng.wang@huawei.com>
 <ajPZlxq5z1hyo1kE@pedro-suse>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ajPZlxq5z1hyo1kE@pedro-suse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: b3oopqsjq3sqcmh8wekhkrr7knwogjpi
X-Rspamd-Queue-Id: E63B24000B
X-HE-Tag: 1781787523-873970
X-HE-Meta: U2FsdGVkX1/YRctm7gzpzFnipg2+R5BcYIG/VD+NaT7PdfU4k1m40bko4fFUlUNblhv/Jvph+7QPVZOMsBZHqLoUx4VGH3XOV6EHT8/Dw/vBI1XxKZ1KKjhzKmT8+ckWdXNlad9DNTYIdTA5Tkh/mMq1G5RfroY+6O3trOaPu/++mh6fIJ5tHjd3ssb34986/0ZscEIme834H+2YW7lj+fMMLCzjVA7Myk2X8DJB/nyWJtJnoI1PMDR1ZPBJ4qxig6+xoiquzpKK6gs0/Cb92MbXfB5PusSDGK2w5nNpDIYu4Klh+ry9aZtNu1TwYp7c1JmBoY6Uv9yaqqiyTTmhbROnTTkb/SDlIqJX6MnjbAtfl0ALI++QNh+D3mcRUA2G9+MYi27vnYbSTOKybLx73wdraW2EPosvqbMR2ILMFuJz6ACGz6ldLQ80ijedk7SA9XZFn7n3QPJoA6GErN46hTMFWm4xh1bttU/MOEu78Qh87LW7KTTE8oMLTSRjs7LQvPBndS4nTY5BlfkAYuLAIjhmTxtIFnMgEOD1fU5hyWr2HJvfvNKxWExTLjH4G1nkTbGgu+TQZIzMVmdls35wUBB7fmRbCkmh7e3m2ephaR6OxUrmvE9WqlpNiXlg4O9FuUmRvSUzogAE0pv6m73BTpOW/K+Hyz+2PgZImCSvmIUvf/38opSr2jH/YDxLNVauxLvmJwEHauifz3997TwYwrr/PrizWzK/n3QVo1sSO8dgd3DSekoQyBrHQnpiiPUhpH9Syj35PwIwPfpBEfKd26DGcJfDmB36yLAi8lyU2Jrc3jFveUQUBSjALSyU13mW2x6HB40+S53o9jUH7gU43a6WlGD3E0UNbEYbqmYs5bEtcfR7rZ0jZ436VTO05Pq0UF29AIeGEq49R66NaONKA+KHIHmk0YcMI5xJUEIZcmTbQh04T4pKr7dr0BuogGIjxhRPhwodTVQiTN9j77X
 F+rYcHYf
 52DJacbHuzoPKHZpaBpdBJsDA3f+hvb1mflY14zXHRIqK6WXMp61xGnA6aMPHPC+quBczkaHKadekoPVLHcDp3hPZHs0Oqn3ni4dD11yZx4xa5aQSXgSmiIGisBMU9MI8zsGX+g5SdbHB5Vr+m/lDQCBWPPrlOJsjp/UFeppnzVj/nVCxYf8RhuF9ph3axhZGxkH7maqxnXDWjPLwkj+J6qT7Bpe1E14KkJ7LmQ6iKHbMnobt3H4NBuM/nMHCwd7tWqufSGazfjOtPBCfAJqo5b/EGA6bfxYWuY/agBlBEzNqurgg/qlCTYGk0LADb5a01Y+bAjGc9Axq6ww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 13:49, Pedro Falcato wrote:
> Please CC reviewers properly!
> 
> On Thu, Jun 18, 2026 at 05:28:42PM +0800, Kefeng Wang wrote:
>> The do_mincore() uses walk_page_range() to walk the page table.
>> Fortunately, the caller always passes start/end that falls within
>> a single VMA, so it's safe to use the walk_page_range_vma() in
>> do_mincore() to eliminate an unnecessary find_vma() lookup.
>>
>> Unlike walk_page_range(), walk_page_range_vma() does not call
>> walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()
> 
> Why not? Can we fix that instead? I really don't like having this open
> coded in callers. Are there callers of walk_page_range_vma() that expect
> to look at PFNMAP mappings as well? From what I can see, the callers all
> seem to operate on folios (and/or anonymous memory).

I'd rather not.

commit c31783eeae7b22dc3f6edde7339de6112959225d
Author: David Hildenbrand <david@kernel.org>
Date:   Fri Oct 21 12:11:38 2022 +0200

    mm/pagewalk: don't trigger test_walk() in walk_page_vma()

    As Peter points out, the caller passes a single VMA and can just do that
    check itself.

    And in fact, no existing users rely on test_walk() getting called.  So
    let's just remove it and make the implementation slightly more efficient.


-- 
Cheers,

David

