Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1029BD3514A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48F426B0088; Wed,  1 Apr 2026 03:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 466936B0089; Wed,  1 Apr 2026 03:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CC96B008A; Wed,  1 Apr 2026 03:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AFA56B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:08:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9EC61606C6
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:08:25 +0000 (UTC)
X-FDA: 84609108570.07.22DBD48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3B69E12000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:08:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gz2eKhzf;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775027304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juk/yrwlqljfx3yfY2+dZnX8QwkcUowy3ScbgHmbN5Q=;
	b=nb5hrhdc7QVJ0DUl6/HkaMWURhBDXNBixUvBT4z6VOOz4Cdn5tmwJk1U6VlYO9XlNu30zc
	5HF2PjzwJCOpRDC1zC7ecWT1n+3AvtzrSSKumdTDwp2a0xVzNfZq2grl48H2HArS95AECh
	19NFfYbsOoOILvnJVC5nHp5I0GHqryo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gz2eKhzf;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775027304; a=rsa-sha256;
	cv=none;
	b=EQ1qaTIsYfWXtXyskYCigCHZjuQE5X8xQEDFYId5bTqCTmY2W1jeNZpk75SIuF4qKZaQeh
	9d9RLOngt2RsvhKj3RW2V0i5DfsZL+73Ww4S/2eeAE0iUYR1Gs5cqn7azsYyDFn74YL3vx
	tcRri8zF8AccPi1sJXHR541XrKn4NBY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48AD060127;
	Wed,  1 Apr 2026 07:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C981C19423;
	Wed,  1 Apr 2026 07:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775027303;
	bh=9dWTDjvpA+ASwfwn7e7CTy1SkAgAXTZVgBAk3qFv6xo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gz2eKhzf9cD7Z1Fi1Va71fGpdDvjsc60Y/YbH/UE0lJqnUJYdRjLamgTeC1oAE95e
	 0i2oDHTvM0ImWMjhx/4rFy9CUnT9NstLmN65QRpje15iK2Y1tUUInbuUkbmRWgkthE
	 Kle35fD1WEj8RP+Ut/UFDu+h8PPIEjbLPG0sJrMqClfFg7nKWrNBYsBz5DX5xuAzG4
	 HMfVjPZcUfh9ammj6UMlDN/l3C3Os8dwR6vmNR9HLW9KdLBmISlstIkTbSyH0kdtTZ
	 kqfbQeqP2uEXWoziN87VBCaSCzC6iLA2UvgefryUt5SXPPhKrFT3cokmpjeLLB7gM5
	 9Aac07ayJoyvQ==
Message-ID: <9fddd112-e304-4ce1-b3f0-a4b133fcb281@kernel.org>
Date: Wed, 1 Apr 2026 09:08:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Petr Tesarik <ptesarik@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
 <32789381-f860-4b60-a1e1-4c97f6ed08b1@kernel.org>
 <7C90E910-D229-4F60-A62D-E893A89D58F2@linux.dev>
 <1742503A-F912-4AB6-AAF6-6CDB06829024@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1742503A-F912-4AB6-AAF6-6CDB06829024@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B69E12000B
X-Stat-Signature: 6oj8m45us3mi1bu3eny6bof8kgc5o1w9
X-Rspamd-Server: rspam06
X-HE-Tag: 1775027304-60268
X-HE-Meta: U2FsdGVkX197S6JxewJUZgqvBWJxT1GZI4Wie/C8eOqxiFxrHRqUd4+DIO0KSwVlwzoIYIeEUc9/HYylQdkLFjQ5eSBPHbpFJEpXYx53553luONHrGVNe2MLSp3KbjaCU/uaLIQw3aB2Y3cbGnC8GzQvEfcIFUX8lyFqbPaGnnW9dgx7kxKx0Kvnl2QTHnTBhp5Nyc3LRj0S3iXTuifNAQnyaOYJCS83Pm+TgFJ2eFZ5b5QEygLoqMjvIvX8hMpYjDHyWQT8lquYPF6Ip4GaL0Y2D1qhnQl/DO3FnloLYZTxgcOYQqr3sUCLjbALPd55nmb7eRtVxMzeXZVGdzT10TTdKWfoFA/Jvr2OxXoU94WMtF7m6U6wFGa+yg2ymYS/j1ZpIMXHkk0Eb+kaL9vKqsMvEp4EGRVZz2mziZNmhhm87yRp89PuDEclLnQvy+Fb2cfulKyiLaS8rzTgnr1KVBKGRYpa2IuCgQtXNGNtLU0CxQ/gLdn9hI33FoGxcsplLxRBcOSKzCLTAYZsx+dlw9ziToXDXpX0yVdmp0fM0EsZp4N/zJ43NyabTaYIuByfO3NqflKnN/yao0X/jZXI3lkIhSvj/Eq0leU9cuQCG9zKSVU6u2mkJZyYMSNnsi5Rasm/Zk4C2CXZQBaEg7gEeTmQvqQBAOh6MoaNWkmKJtik0dYFBDZjfHGTNxSs6I5l3aVo0Iw9RfVKyvVi4W0OkG/Yf9vWmkZvoSs68Irw1c5RbN6cPPDoxqOA+hiENmZZP2X8LGXol3hvfxJTk65Z0m9cPyMm3WUDBp9rWwKLSZBVTEE+T7/hEVMY+rL5Hl9CNNUkHRBlDDzFVrqHRXO4i0/4LALJbzHWVnw3Zh9ZS8h938dYsDwEb1+EBzFctzgBozgAbVhvLo36XYEPulObRSUht7O9g4OLCNr02aOIJKwZShejD9HtDUDTts/kYqFIBrGAeunIMj3J5fM7oju
 mSDGjlK1
 /J1l5DfZJOqGIhmYhdi4ZI5BHrQCQ0YyNgZONQcTilyH9GDWzOoxznvgoooGOyFaJv3+QjQTloGQSabQpNLExNh50z9SCaR+S3dPYY375IJDOBPLKbbBsI8X6as6sOY3OANH/c+unWMLP1BTyWUA/y2jEF4BmCcXTPQ+zf8szWztcY96uPgngfV5m17QfO3rEahd82TOSCoHFLcdP22+jjVJiHdozsRWpyAa4uQZheE6y7w3As/2MUUDoBF3+YTaJ9oT93sUdXYC+Hkpqbuwk5bI3J7cZwn768W4WDdCIQPL8XdD/UiUSVUM99AmRMYOdtkqs88jQl/30O4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 06:01, Muchun Song wrote:
> 
> 
>> On Apr 1, 2026, at 10:57, Muchun Song <muchun.song@linux.dev> wrote:
>>
>>
>>
>>>
>>>
>>> If that would trigger, wouldn't the memmap of a memory section be
>>> smaller than a single page?
>>
>> I don't think a memory section can be smaller than a page, because
>> PFN_SECTION_SHIFT is defined as follows:
>>
>> #define PFN_SECTION_SHIFT (SECTION_SIZE_BITS - PAGE_SHIFT)
>>
>> Therefore, PFN_SECTION_SHIFT must be greater than PAGE_SHIFT. On powerpc,
>> PFN_SECTION_SHIFT is 6, PAGE_SHIFT is 18 (the worst combination).
>>
>> Sorry, but I didn't understand what your concern is. Could you elaborate
>> a bit more?
> 
> Sorry, I misread it earlier — I thought it was about the memory
> section size, but it's actually about the memmap size. Let me respond
> again to your question. On the powerpc architecture, when PFN_SECTION_SHIFT
> is 6 and PAGE_SHIFT is 18, it does seem that the memmap of a memory
> section would be smaller than a single page.

Right, and I am saying we don't care about that and do not support it.

For example, most vmemmap code I am aware of relies on a single section
covering full pages.

So I don't think this patch here adds any value, except faking that we
might be supporting something we don't?

-- 
Cheers,

David

