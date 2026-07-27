Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F32C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 191FE6B00D7; Mon, 27 Jul 2026 10:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A626B00D8; Mon, 27 Jul 2026 10:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0806A6B00D9; Mon, 27 Jul 2026 10:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDC926B00D7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:44:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E8291401D8
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:44:22 +0000 (UTC)
X-FDA: 85034827164.04.5852185
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A5E19180008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:44:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhVGoeHy;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163460;
	b=ud/KRNPZD4q6G13USZfxOakXqbJB5KhxwJMY4p7j21alklWMfZh1W9guZ7jNoj8sxrvqc7
	/qRwsm6VEv1Fxr06uFRB+pvJjJ2IwrJd7Ww4Qt3YEOWK5gqg/JjqS0QxIvGDXxHyKEv3qL
	Rc6k2P9AhDsFUhxlhrOt3udHVKP9tYE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhVGoeHy;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9dVdzXw/O9Qo+fRyZpEM/TgP7hh11wbOH6xloCAG0ak=;
	b=Wk0HWRJDFqcp8kOJxN7mo9KVVZQzQZvYXaGaHJ16LLf08o0XdlVzIcFv9scjZLEWGb3Z1Q
	bqIr+mTTZ/n/CVF4+tvWVYi3QsQ4UeqzVQDViwxZ9twGqtE03yK604YgIWjyUs8QnaAF/I
	UGdodHuOXrQZ0OJxSytgZS8j4jbUNFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F26EC60254;
	Mon, 27 Jul 2026 14:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFF11F00A3E;
	Mon, 27 Jul 2026 14:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163459;
	bh=9dVdzXw/O9Qo+fRyZpEM/TgP7hh11wbOH6xloCAG0ak=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PhVGoeHy8JxQDq4dBfU7UzadtQTNbux9yx1M1nF5IWCDPKsj6+e+vVpNWfQ3LmbNE
	 tO2Oqj2Y3nB16V5VyHdG1HtWXKtboMn3dFVzmNjfoukR3RA0HlM8qBYHKrhA2kCD6R
	 NKWMUdkc3IKrdL3lqS+seJQmoAEIW5L3BqGnjoyYCM0ycRaCZNBVeKYt+ankm19Efw
	 kK/ekAkBII7oXh30iRWfV2WGvHhBMZulq8v8Tgo892r5+67o2AhLWkjx/BW9eVFDgd
	 Aa9/jGsEDb6g34eDMzUY0qkDMsaUzTTOhuFJ/VNifyyud1Oh6HIiQ1ETvBt6/3zBZl
	 jtSwRrAVu8J7A==
Message-ID: <880981b5-ef79-4c9a-a8bd-7540002fcd15@kernel.org>
Date: Mon, 27 Jul 2026 16:44:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/15] mm/rmap: index MAP_PRIVATE file-backed folios by
 virt pgoff
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1iskbj1syn9bcnmeyx78wzpxudi1mce3
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A5E19180008
X-Rspam-User: 
X-HE-Tag: 1785163460-289750
X-HE-Meta: U2FsdGVkX19DIBhgtCFPobga2nmBx5wzH7dzIXoFT3rIkvJkhdQr0sOnRyvfqKUN0b4TtqHqBmP+e6t5STkW5MS9cNRAvjni5tBkviuERKUo5ID3QZoDnkJzI5sPE2ezV6PUTUGR5T++P8gLUpJflrfv/1XTaDcjEVMOug016cLhkmkVix7e6LGqQ1DLi7RXq+A6Zibt/Q/weNP2sULBSyB6rjHjNxIHgCkD8WDhz7L4DmQO0Rqd3dP+7RyUIYYOmXTp8DUtQmSCA8qYJsjsfzYOhZ6jZ4gau0clEiCqxzag37MXZdf+MRqa5y8Um2w5O0/IXlK4F4Ciy7gbyDZVpl/5K60rp7IhD9s62DgdMKQYwQYOO/ylA8MrXBGc8zOL5oCJz/QghGyefBxKTiJEfztmju0o7WogwbflQfsEvSnvEhFmM1fTxgkh6t6Z2lV5SeQpe1YOYIs0CjjXEG5Mrs4gkT/FViIv93hXfm8AGodrQZ9XsZx+7GYOlg4iwGC4Y7GOhOSyi7ICJoAvjA3ZeFyeR43hHQE3j/rXYjTczWP3ueXReyGXkc1qlTLsPXyQ9vyfciFq8S+DKMdldMLXYB+geqM6VI53w6bVOyCJFLqzJXcQUIskyPCC9/hpx1gNtkqj/O7np4omm4ljj7SRj8xLhtcVzQ+tmJ6alc6Jv1kY8AxfXJ0BkyN2iVPZtKuUj9M7OsIm0u9J6KV+I9zq2AAylhqAriSAWJsPd8JvOwVgf6EUazI/thwcW9lWMInRjTjV3c3QTDDG1YuPOmJA8+UxnvCHgS3P/OnUBjoglxsv952zuRnQO+XwTQXH+5b3VChWh48+NynW8zK4OKZhWeVN0sa+yaYAmYat15O2T5ACkehZmZ34VP+gR/Fe332QZodP2UtgU97Mx/s3f+lvMf/1RhPQTi2+XBh0TRDNk+1AZMVhRNxDeBO6M90z2XdCz7PBO99QabQhSRy/gbF
 1UC8SWTP
 i5WXQ1X6QJXc7H1WPM5OYyXIjSzd5iOd2sySUQREce39e0w372IYkUUyJORZnfdNHDS7sFGmq4AQ0O3Yj14jPqP7wYircbVTSeoByC48h/z5M4lhgyghF9IO2VId1gkaXZERnzYR0inHvqTyrzDO2WO7tRdpDqyVqbpbGkvDIWCL6JC6hx2AUH88frbV5J/0O+DWa49koaMKsW0Nna1X4+oRUMX/AVRPK968F/NVjBqe1m2C1CZCXbBBZHOGTpP/bdm7xKh3iMYKtukvWqN3BPdSB37WMFX0XGU8HB2i16p08+7fjdzaX7vo4zJm/WfUq+2l0vhhdverK3HMCarrNwqyET5ystSciDqG4FX1FeF3mbdRxGZ6Hn5q/PXNOk6HThyPA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 16:38, Lorenzo Stoakes (ARM) wrote:
> In memory management we've managed to manufacture a great deal of confusion
> around the concept of anonymous memory. We have:
> 
> 1. 'Pure anon' memory - anonymous VMAs whose folios are anonymous and
>    swap-backed (thus for reclaim purposes, treated as anonymous). These are
>    simple enough.
> 
> 2. shmem - file-backed VMAs, file-backed folios (from rmap perspective) so
>    present in the page cache and mapped by an address_space object, but
>    whose folios are also swap-backed (thus treated as anonymous for reclaim
>    purposes).
> 
> 3. MAP_PRIVATE-mapped /dev/zero - a strange beast whose VMAs have
>    vma->vm_file set, but whose mmap_prepare callback clears vma->vm_ops to
>    satisfy vma_is_anonymous(), which results in VMAs that were mmap()'d
>    referencing a file, but are in every other sense anonymous, including the
>    folios.
> 
> 4. Other MAP_PRIVATE-file backed mappings - These possess file-backed VMAs
>    and have file-backed folios until CoW'd, at which point those CoW'd
>    folios are anonymous.
> 
> This series fixes issues 3 and 4.
> 
> In order for us to traverse VMAs using the reverse mapping, we require two
> fields - folio->mapping and folio->index. The first tells the rmap code
> where to look for VMAs, and the second tells it at which offset the folio
> starts within the referenced object.
> 
> For anonymous folios, folio->mapping points at an anon_vma object. For
> file-backed folios, it points at an address_space. And:
> 
> * For file-backed folios folio->index is simply the page offset of the start
>   of the folio within the file.
> 
> * For anonymous folios belonging to pure anon mappings, folio->index is
>   equal to the virtual page offset of the folio.
> 
> * For anonymous folios belonging to file-backed mappings (i.e. CoW'd folios
>   of a MAP_PRIVATE file-backed mapping), folio->index is equal to the file
>   page offset.
> 
> This series establishes a new virtual page offset property of VMAs to
> allow us to map anonymous folios at their virtual page offset, consistent
> with pure anon.

As raised off-list, I consider the "virtual page offset" concept hard to grasp.

Maybe it's just me :)

Skimming over the code, I read "vmg->anon_pgoff", which is pretty intuitive to
me. Similarly vma_start_anon_pgoff() / vmg_end_anon_pgoff().

Could we similarly just call this "anon_pgoff" /  "(linear) anon page index"
even on the VMA level.

IOW, in patch #9 for example:

static inline pgoff_t linear_folio_page_index(const struct folio *folio,
 					      const struct vm_area_struct *vma,
 					      const unsigned long address)
 {
	if (folio_test_anon(folio))
+		return linear_anon_page_index(vma, address);
+
 	return linear_page_index(vma, address);
 }


Or is there another user for the the "virtual page offset" concept? I'd assume
it's only used for anon folios (including KSM), but maybe I am missing some
corner case.

-- 
Cheers,

David

