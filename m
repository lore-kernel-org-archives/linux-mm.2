Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5306FF8864
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A33C6B0088; Mon, 27 Apr 2026 16:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252DE6B008A; Mon, 27 Apr 2026 16:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 142B96B008C; Mon, 27 Apr 2026 16:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3B386B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:59:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC2AA1C0383
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:59:38 +0000 (UTC)
X-FDA: 84705552036.05.E5D73F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A896C40017
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:59:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fB0MsEdR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777323576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0xbzX9wZmv42XHV/ZmZTyw6S9VYjXqDsMwKLwQ2JuE=;
	b=Nfxw3/qz02k45tIz2NTgDSy90Tc7YBkZt5quCovh48MFfM7RhGpJjj7tIs7Q7QQwvHrax0
	GYTmR8Hodk+5ajWD89p4XfqwlB01ClKL6x0ZgSzChORitM2ijVoJghTV8mqJTFsg30+bnt
	Ug03EPUHm9DBPhvqCLBbUZOWfxLeUJE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777323576; a=rsa-sha256;
	cv=none;
	b=SJ3R6ItEeNqvHnQ8hde1T6YecycR89dzpxrhpEESeLrEiW0mLsdPaHds/+0ClAtMuGOMag
	cm+pJPt6vASYsaTOH+2dOq7NeHfDwbZTZvLLczitaO26pPpth8NdR0nTf2NhQ/l20rkKvK
	1wEcniES58yaqBdJ0GX6dFNjBNtzUPE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fB0MsEdR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D5B6401AE;
	Mon, 27 Apr 2026 20:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52FFC19425;
	Mon, 27 Apr 2026 20:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777323575;
	bh=4fCdoQX9tOKa3DEv8CT8f6q/tReZla5dySYrHKOPds8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fB0MsEdRgoihroZKswclQKQK7DSaYaBeTbYgcnwk+cGwwMNHZs+Ewrbsx8gMZ3CyM
	 QtJzJG7vGabw1+iCAwGf0eeEzwn4VwU6nVQ3BOASjmOtgG9H5rY8QhX2YWlZAfPVNo
	 zoz0HYLK/I5mosk9uxs6yULiL2WCKuks9JvwOebp4t60hFYZEACArzvOGq1sLEAm6t
	 H4DtPpdc96HIPXtY7h0zoyvunWqXabnlUPE25QE3718JB7KMtR/87czjxFFJIj5lo1
	 D6BQLhkgCE5rpeS8GUVhFAPr3DDqFGeq9eMkxXKmYNzBOJebAuAgqyooYpqY16Qyr5
	 Ag0QFqf0GI2fw==
Message-ID: <97192ac3-643d-4393-87ef-53a9f3ddaf95@kernel.org>
Date: Mon, 27 Apr 2026 22:59:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: remove page_mapped()
To: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>,
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-mm@kvack.org
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A896C40017
X-Rspamd-Server: rspam04
X-Stat-Signature: u7p3gg9df7ae5ki6bkgei6yypo1x6e6s
X-HE-Tag: 1777323576-89407
X-HE-Meta: U2FsdGVkX19P4wERUZLJMuD4puh7YEdjAjMM9qX+5SjsC4gip35daK9xeKb6dwS0baHUQD+ITnmrT6WIN6A+RP1X/rBFWkTPoiyt73ICJdqPQuyc6pDj0KFWNsbNyULQaJwwgWd7wAfb+Ntq4Wv2vwoSaoLqqTzu3oY/4IBk0Sw2b/Tm5bDZvsrJTQ6jK1o2CTdJnBYr1RhOGid/OBBFTVPh6IDphrPYizncXyb/vxPoyuwuGs/VGUQv3NgpKak3rwns0S/hPOaYOh8o09oCAcbdwAkREgEL5ZN8i6ui6mAAnH68XmlzhnOp8XVNz5r3extCxCFVHWbWDfzP+gGYuyJZK4BPlGkz7GROUY+c+rnOrxKa/5m+azweSI0mY2ps8MYi5a/9y0L9dv897//tfZKziyYIRzYNp8Ig8JhhKDqtfXgUw3Cu0ROvo62U+KhyiCpBkF80yxrGh5Xw8ntK9JpCkEtX7IpA1mVbOFPDoW1eHi5oJ1rn/OMOpnXMDyq6cvMWVM0o76dF5ufVFaJ1lV50KYHO1l758QwupK0zQgCt225XEYvymBsyxk2xxOW0zNRE/O7KLTiFqvob2ILhMLPrq6U49uz+OmKV7kKuBss3pp8ku+NnKhR6Q8McTfXWk+TSV7zlpwbYLiGHYNcIEmj2Aso8T1xE7wXOs0fLgHoBhsCSrhvs2nfR1LVY+26QG+ZbLLtiG96t+5EdOkFtHoFJDEPziLeFoEbNE2HOUZmH4v7J5p4G4m7QD3Oy2vo+Q43cPaJlo02qVFewiwQVV4dmSXRPQEs+hIF3Fnq07DokPa4iM/EityAtiKPnfuddbNQMbAzZUBHAsDsx9oBp66OXDu6stLx/ikCCqVBPjpMQMquWI1yGwn92306b81fQ3ZKGAUG3kZ6DQU+JJTXjNwD/ZFUAf9MZp3Aw+i+zNfIecBo335P0DGZKtbHW4RZ/74pQF0E/91Bghoc0G/x
 oqjHeTu1
 2Fk8Rhfxgp10t+fjQvB3WOuukVOdOytTfoMS7viGHb5/KIaqbPbt9+QFWjgHnuat8QPvhAEsjkjEzEHn8x8bCIfoKjSYpAnEunydY0XC93d8iLR1EwqLjtjIQyJmDofH3nc/Pf5W1kdFT+yUUMmo717l/+oBZlh95C703dJuOi6lFajNvYg6mpCDEqBD9f7uz0Emur+Ndx9+KFXDGNtnLYwYpYW+YXl1zdeONU2PuzY777bn/LajHlsVEZhP28t+mAa31J3+tCn+/ag9yeGQeJHyBCMVy4Mk4TLPRubBxZSVI6pPohGQx/36l/3z8bdvirSg0yLMOGpqMHLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 13:43, David Hildenbrand (Arm) wrote:
> While preparing my slides for an LSF/MM talk, I realized that I did not
> yet remove page_mapped().
> 
> So let's do that. In the BPF arena code it's unclear which memdesc we
> would want to allocate in the future: certainly something with a
> refcount, but likely none with a mapcount. So let's just rely on
> the page refcount instead to decide whether we want to try zapping the
> page from user page tables.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

I scanned AI review and I think it founds something that is not related to this
patch.

We use the page_mapped()->page_ref_count() check as an optimization to avoid
calling zap_vma_range(). We must be able to call it even without that optimization.

Just like the bulk zap call earlier

	if (page_cnt > 1)
		/* bulk zap if multiple pages being freed */
		zap_pages(arena, full_uaddr, page_cnt);

It talks about concurrent "munmap(), unmap_region() executes unmap_vmas()"
racing with our zap_vma_range().

Looking into the details, arena_map_mmap() calls remember_vma(). We reject
mremap and VMA split. arena_vm_close() removes the VMA from the list. The
arena->lock protects our VMA list.

So in zap_pages, the VMA cannot go away. If we find a VMA, ->close could not
have been called yet.

In vma.c, we call remove_vma() after vms_clear_pte(). So after unmapping the
pages and freeing the page tables.

So munmap() can indeed race with zap_vma_range(), and the page_mapped() check
would not have changed anything about that really.


@BPF folks: does BPF take anywhere the mmap lock in read mode before calling
zap_vma_range()? It should do that.

-- 
Cheers,

David

