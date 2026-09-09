Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84414C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA2B6B0095; Wed,  9 Sep 2026 10:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88CDE6B0096; Wed,  9 Sep 2026 10:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1A86B0098; Wed,  9 Sep 2026 10:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 539806B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:38:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3F8F12025F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:32:10 +0000 (UTC)
X-FDA: 85194463620.21.8DD6F67
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0C24E1C0006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:32:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ooE8DWa5;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788964324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=81t5dUSp9NBhDobvQnuTMVyhlj2QjrqDWTWphqDthVs=;
	b=KMKRQxpSml/Tm0lx66r0Q1cCRCYg9JgrycshH4m3SVnU5thKpVk9mpfOuA6h0z260zhnHt
	hv4RSHsmihQn/NNUZpI6rC/FF8K5pKEQs9HaWeMo5UxLmX/2wIzeB9ybwHb4Kh1BKJSzlY
	0Kq02rViRstJ5OuQR7ow0b6MjMD9ueQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788964324;
	b=24irfMCmE6cS+Wqyv17WprWj9YMEw5G0pZxxzwyvSoaYURuhzEM629qIVaRcr9OMNDatXZ
	tE4ertjSJxhM3CuR4wS1G+X5mRT3lfwja0L4HcCPIsUriyjMy31LvE/827m7iFbR/iSGef
	1EdrC1lXkFZoPkwXY7IM/ouEEaEnqtI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ooE8DWa5;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 629616020A;
	Wed,  9 Sep 2026 14:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111A91F00A3A;
	Wed,  9 Sep 2026 14:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788964323;
	bh=81t5dUSp9NBhDobvQnuTMVyhlj2QjrqDWTWphqDthVs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ooE8DWa5CDIiME+I6yLmCXTKES6hNTyRb7PC8UxkjursSc8yN+HrzSX5UyO6mzMIV
	 eqKqU+0oFTCr/RTvmo7df6nyKIN/3tYL2Ut4KbBoBqDPVFMQH025G+H3g9edB6dIhD
	 5jzVh9mjdj3vbNdizWQoV8/MbCU8/u/CI8yb6JFQctbgQcuasxa4z34UqihPB1OhXT
	 kB/dWNswLQiw+qzzkbmwu3VnbxWY0KL6I3d+Qc2thdBfbAsgEc3g2LLUdGoAO8aulM
	 9WYEhgR+uCb8cquBu0fepHWMAdhSszvuSH0jxUn/EviRDLNyH85H6lpRXMOkIMF71N
	 UC7rL6M5zItUQ==
Message-ID: <d8e9b629-4198-4281-a3b2-d54445201fd2@kernel.org>
Date: Wed, 9 Sep 2026 16:31:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/14] mm/page-flags: remove PG_private
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Baoquan He <baoquan.he@linux.dev>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Jan Kara <jack@suse.cz>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 kexec@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-14-6ae22f9d9272@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-remove-pg_private-v3-14-6ae22f9d9272@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 67b9ihfoqke3nhb7m6eb577uepbof597
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C24E1C0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1788964323-457616
X-HE-Meta: U2FsdGVkX19Us5+ivy6Xr4KNh8EHI88QP19UVUSRy7WhzADvsy9UJxcn9ig1hDD1elwzQ8J1axIkpO7cIkau5+TxD1p13g00oKhSqJFYM5gnzXa/BZZlfcUxMw/5q94b3nN26Ze/3G/GlYJuD9RUrgLUYBFLuQf8k9mCywfoiO4Oe2xwVdTPzMKY2Bv9U/IOQ72HfbEgAV+TDTA3OYm80O080zaR1dJXLXqM4wnnJLe83SuRXYE+Rr+c4KMAkKWmoGG5ZqkGz9gwKgSIsOV4k7dODl6VLQfMmi85fk2vo+ZrWQCReM/DkEqbqiVikIKbR1qtHp/MAj/IvnXIBIig/gV1bkKSgUvTqInUP6q2Z54tIFbt4q7+hQJYSmSRVcAt2fdhv2Ed8ZyvU1DW0VUoBTlpIWp4R9VmTC5aZekKVNT5CRdW+TyfxJ8k/TynLTVfvmozYQD0wIBwR8Tx5rpnm4xcZK55iUWbKtBuu5klJ/tf8p2FiTKv7unGV3NbQpRL7sPb0YtIvBFY327SJrs0V3vHiFM/jdFmGU+RxZ8kFBwglSR8R+fpI6fIlKNHZHNR+v0SLmcOBXoXwK86XM5u0xp+CZny3b8C6GeUEMk/Gss+qZdxhSK7nmXmQ72BfYsr7Tbm2YbPSSMOB62Y3HyYfXa0N4HDUKqX4in98D8CN2D1ETnRHyY2pCuyNorX9SczgHnXIlFeLs1+3ye+acuZOi/E+VLFuETleWuRk0F9Vt8e1l8KW4EkBpy7LNJJk5zFQNYPJnYy3dAUxJCRciVyObP+ywCg202SMMwiJXRTB4XwmC57Is/ryoemiT1nf98CPzh1mEjrYU6TNQrCeQH92amYgJBGGD7nt+u8dzFzJZxn9zcdtecm6sWnMW7rnavphJJylV0YYN+CrA8FbrPgN+K2IWvipR30MMOpipsPn8lu1/iIQfpmbJuCgJiBQnmrVS/pzgcSWsWmektFIUL
 3mdhErwg
 tUE0L7cQUGcUZCXIf4hOIz7L5lcj9T27YRohOdm3oYHgSB4ex2FcjvkkY4eB29kypnmZxzCKu100bDy29a68CITbZnr4REaGndIZYDtezcaeE4P6kpy1KCODlQFO2xAleADzC6Uy6fhJZgXrkBseicRhDuSQors+jSABtdkYuv/uj85lznzFf0JYvzJjQt5ibZIS0sfk9pYskL9wBrcooWB/BQZ47utn2ql4Awlkc7dfTocnf2J4D1iPgppMfHJhdOQA/zPLtJjmfBGkNMI7wXWdHk6gRVV0r8fwm655ORseQNETzctrcKWyAc/6NvQnmnNivUTTFRQOTiTkZYY9X2E7a/ecQp5KolcWPNKLAJrvllpqIUKjRhRd9MNHJmiM88N6mR2FUp9deYDMfznH0uDyOrSre46WEzHGZl/DGaOmOYb9hnAx2Iw0MJFzfpENCWtqUZvk46MukoHvY9CDi4Nwhyf0KfC/yVPyY9ozbfrdLWe+3jPmlGLSIhnvf2pySpM8iv4q0z2w7coSfyxWSHKEcYVFhPCmzace9sRN/ZJ+bFsdNJ0ng2IhK3wCQq8ItvGlrsyvDtdTj2GAhg2aMaZncED94PAD/rjMGSBZjx9Ot4OFPSu8sRrSKYPW/bvkcVvJCB4tCyofbmBWTGJuibhfc2lJqfFp4a60MdxvQK6nz/VxTbAKtWXxZyT96j9C0lUHXjHFrNlHyyRCcgF0AzxWvzRvbEr1l4CM5UuIZUq0OVAIp5QDYjAsR4biDFsDyeMteKEg1hOidZrpHOvOBszIzFiWJGz8FVbmYS9idNiRNsObKmIVf6J/2DPRK99vswJb9Ntg3PP75SH8cRVbpEzgofz2g6SG+dv/Xj7p6wETmpdFJYpAQ7JkeuQi0pp70asld8K2VbHBRw0PBqsakNGG0BlZ/DqKGvpm7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 04:56, Zi Yan wrote:
> folio->private != NULL indicates a folio carries private data, replacing
> PG_private. All PG_private users are converted. Remove PG_private and
> reserve the space as __PG_folio for future use.
> 
> __DEF_PAGEFLAG_NAME() is added to show __PG_folio.
> 
> Also update files in Documentation. hugetlbfs_reserv.rst is outdated and
> left unchanged. It should be rewritten.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Baoquan He <baoquan.he@linux.dev>
> To: Mike Rapoport <rppt@kernel.org>
> To: Pasha Tatashin <pasha.tatashin@soleen.com>
> To: Pratyush Yadav <pratyush@kernel.org>
> To: Jonathan Corbet <corbet@lwn.net>
> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> To: Jan Kara <jack@suse.cz>
> To: David Hildenbrand <david@kernel.org>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Dave Young <ruirui.yang@linux.dev>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: kexec@lists.infradead.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-trace-kernel@vger.kernel.org
> ---
>  Documentation/admin-guide/kdump/vmcoreinfo.rst |  2 +-
>  Documentation/filesystems/vfs.rst              |  6 +++---
>  include/linux/page-flags.h                     | 19 ++-----------------
>  include/trace/events/mmflags.h                 |  3 ++-
>  kernel/vmcore_info.c                           |  1 -
>  5 files changed, 8 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentation/admin-guide/kdump/vmcoreinfo.rst
> index 7663c610fe901..5f1df6d080508 100644
> --- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
> +++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
> @@ -325,7 +325,7 @@ NR_FREE_PAGES
>  On linux-2.6.21 or later, the number of free pages is in
>  vm_stat[NR_FREE_PAGES]. Used to get the number of free pages.
>  
> -PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
> +PG_lru|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
>  --------------------------------------------------------------------------
>  
>  Page attributes. These flags are used to filter various unnecessary for
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index d3a93eec3945f..dec7816303c6a 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -649,8 +649,8 @@ Writeback.
>  
>  The first can be used independently to the others.  The VM can try to
>  release clean pages in order to reuse them.  To do this it can call
> -->release_folio on clean folios with the private
> -flag set.  Clean pages without PagePrivate and with no external references
> +->release_folio on clean folios with folio->private set. Clean pages
> +without folio->private set and with no external references
>  will be released without notice being given to the address_space.

This reads like it would belong into patch #13?

>  
>  To achieve this functionality, pages need to be placed on an LRU with
> @@ -674,7 +674,7 @@ filemap_fdatawait_range, to wait for all writeback to complete.
>  
>  An address_space handler may attach extra information to a page,
>  typically using the 'private' field in the 'struct page'.  If such
> -information is attached, the PG_Private flag should be set.  This will
> +information is attached, non-NULL 'private' field will

Same here?

Likely this could have been restructured to cause less head scratches. I'd
expect any documentation that refers to PG_private to get removed before finally
removing the bit.

Not the end of the world, just a bit confusing while reviewing.

>  cause various VM routines to make extra calls into the address_space
>  handler to deal with that data.
>  
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index ce7fccd90367b..7b7783c0a5216 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -44,10 +44,6 @@
>   * Consequently, PG_reserved for a page mapped into user space can indicate
>   * the zero page, the vDSO, MMIO pages or device memory.
>   *
> - * The PG_private bitflag is set on pagecache pages if they contain filesystem
> - * specific data (which is normally at page->private). It can be used by
> - * private allocations for its own usage.
> - *
>   * During initiation of disk I/O, PG_locked is set. This bit is set before I/O
>   * and cleared when writeback _starts_ or when read _completes_. PG_writeback
>   * is set before writeback starts and cleared when it finishes.
> @@ -105,7 +101,7 @@ enum pageflags {
>  	PG_owner_2,		/* Owner use. If pagecache, fs may use */
>  	PG_arch_1,
>  	PG_reserved,
> -	PG_private,		/* If pagecache, has fs-private data */
> +	__PG_folio,		/* Do not use: reserved for folio identification */

Do we really have to annotate it with __PG_folio ? I'd just keep it simple and
have the comment. That also avoids __DEF_PAGEFLAG_NAME just for this use case.

(sorry if this was discussed in previous review rounds)



-- 
Cheers,

David

