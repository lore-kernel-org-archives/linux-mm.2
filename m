Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2906AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352EF6B009F; Thu,  9 Jul 2026 06:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32AC56B00A0; Thu,  9 Jul 2026 06:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242E26B00A1; Thu,  9 Jul 2026 06:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0291D6B009F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:04:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91911169213
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:04:46 +0000 (UTC)
X-FDA: 84968804172.17.4A3A595
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C7FE6180003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:04:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EdiPHIZc;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783591484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEjdC6USYA3HLQ21aIlfnnUhh8aipys8c+0LBLQreXw=;
	b=fhNx0V14hH0xpv2tOEMs1sQNaJYuoxXdkiA8/x0D2Z0iyEAteQR18incCoGncatW1oN0E5
	BBKowRkvgOcGRNCWUXIdmCy/OWqhmbcvJ330PLUl/z6lU2OEe+Hn0rbAnCei2A2sWqAvt7
	jBqerQoeCM7Jy+ZN9dpru7CWfydkCp8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EdiPHIZc;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783591484;
	b=iM4DmaM+V84G97XaAMJGojwgdarknV4nYsOb4DUyLb7pHxWIn2Cv0PuDdN8l4AcAnTumNH
	hmGMrBDb7yN0Y19ERNpSXvb2X4PtukObyRHJPcw+uRRvRTCM4WzeG4W+e0BZg3Q/6IFFu9
	L8xMRRxNiIqIJRJ4P4RVfBBWptaiG/s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4612041A1B;
	Thu,  9 Jul 2026 10:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA1F1F00A3D;
	Thu,  9 Jul 2026 10:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783591483;
	bh=gEjdC6USYA3HLQ21aIlfnnUhh8aipys8c+0LBLQreXw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EdiPHIZczaLrvC6LCXy6Vea01EDNtOVkGVo3avaCvJVFCiuCI0ZWN6D+yYg+4ECN9
	 qqR/mB6j6RsZ6BQ/jn9d5dRz1SRdcIRhDQ2enMhEPNwDYGZBpBGgGJHvvykl0RsTxU
	 iO3fyhJIGlhQKdaimWBUwJ7dfKj/iX+lbex+oEvoKs0PDODt4UeeAlIRnp0T76GfOQ
	 r6+BgDmwMW7j+cmCzjpkY7nF1wyGCJxvSO0x2wos/ZC4UNMqX3TrxhWwRjlsLR/G64
	 I/klgEq+NszAafk61X0XcXwkzG3NU3OEiKSu4Q8K79F4mTG9heBe6mULLpBIBxd0Yv
	 cIyZzfG+Rscyg==
Message-ID: <9b227263-56d9-41d5-ba8e-c969d8d68785@kernel.org>
Date: Thu, 9 Jul 2026 12:04:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm/mlock: migrate folios out of CMA when mlocking
 a range
To: Wandun Chen <chenwandun1@gmail.com>, vbabka@kernel.org,
 rostedt@goodmis.org, mhiramat@kernel.org, Alexander.Krabler@kuka.com,
 hughd@google.com, fvdl@google.com, bigeasy@linutronix.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, pfalcato@suse.de
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-5-chenwandun1@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707125925.3725177-5-chenwandun1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pwo1qh1zp6g7ebwen8ezb7c7rjnrf784
X-Rspamd-Queue-Id: C7FE6180003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783591484-906899
X-HE-Meta: U2FsdGVkX1++IBZABaUtQxXglRS1gKCp7pULcAq/xBLfokRdKjlFv1J9/PIt099RniKKUr8g4owk9f/czEwJrn/JHEg72aXek3smkcZWm/LydsPqziVfaFzxjy2+pAcZn13x9qMuwCGUXNvDGUmsRbyFSKBFXjB+OJPFIafFT8iH7LJWH3OHWAm+jEDNAWihNk5RAtulPcZrwHYI/KlviL6bumK6Yn7scZHApbHBQ53Ctd+HTxOH9diZAJ8oEgrWgE8RU7y/Ga6TFQ5+5cW/ZhHr3lA0AHP0bJGJYLsadM28lgsLdJo2F0zG6AOHidArFAxR3SkKMBQ8aNIYNV5EXsn/Tsqxw/x5mCk1NqhpkwsqRyspdjQVtPoND041NqY01K7O0TCWBEJnq0y/r++LjxGxCtG9PHA3FulvSe8fxdVwBL7tNmaSUIXhVjiN2myMWmf/csVbyVlcU+F1bFdWg4zQmKTIGsPd67SZxaS9Idcj1vwQHoWBB9q3aifSaSDRfovXiA+WH/dyzz+QVpI7lSOQkTPyDqSr+yNE1tbMZhetPmhYc3ejTprsL97E9JiBZYldKUDW+BFhz4U5Cl4zisah62SmEZFPA7hpijYFtVd6hZbQmPA8rYW1vAJgw0hdinYFYlx0Y4QmD/7dCj4OaBlV9rDnOeiOLPgDq9ZypRmePP145T1vpWXHNu8NawpHrTWOHd8yIgfmjb0Q6NkLnM8Lh01I8NDvabktgRZzU3cqTzn1sR6ph687QIJjACDQ+fk8JyI3Ju+uI3c3m2F65ht5SOR3mxYr30n5TbyuQ0CIcx767mM2m5ZboqPy8pP2aZc4Mb3s1RuL7NZdM17wiJXmMpjhzNZdrw91dAHNnQ8dlAF7uEleBHxaf46e3O68mplB6K5mhQj4Yw3nmn3B7i+94UwSTgYg68gfBG66UT0KafiopaAIFU2MawWNo60yF0S8jjGqPaqG5T0dst/
 dQGI58oD
 Nx06BHV5HFLdAvtKR+WvjHvbUc8ilx5HaZuHxvdqxWLElOwtNZ6bEgBI0DDuBrbK8K+DJj89ex1hz1ak3UWgk0fY/yZerDybzA0GZijw2leMjkpMG0AeMxQw1seSrUCyzF8YC4STMmg7u3fIch3qB0AQQdQRdZ043sCQb0NwxNGL5b/1LBRsp8WoRqhdl/JYwS+8VorlLts5URM4mjgFOUAP25A1DIaEAuy1RcLV3Ja3scXJpxsBeyrW8MK+Diut+rkn6wKxSN/HbpemoDpnuNX3Aid/O+0u2c5igNvupEmJ4edfs4v9BvPqSE7uYfQguAndrX/FyjiGbk7hr0jb2RxCzRP+4HKWblnCATnPpv/exF29/4/0RtW4+k/USklGv31afL2spviiKC58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 14:59, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> The region covered by mlock[all] may contain CMA pages. cma_alloc installs

What about ZONE_MOVABLE where memory is supposed to be migratable?

Also, what about drivers that mmap() CMA memory to user space, and
__mm_populate()->populate_vma_page_range() would actually try mlocking them, and
they actually must remain on CMA areas?

-- 
Cheers,

David

