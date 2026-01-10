Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88DC6D25028
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 23:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7C4D6B0095; Sat, 10 Jan 2026 18:43:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2A456B0096; Sat, 10 Jan 2026 18:43:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D0B6B0098; Sat, 10 Jan 2026 18:43:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A49C76B0095
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 18:43:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 426245861A
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 23:43:31 +0000 (UTC)
X-FDA: 84317683422.14.8821205
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8192040002
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 23:43:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="2c2rE/7T";
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768088609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJ+soBJvdE6qKPL7GfHCcC+8ZlV4DrEg16czXPmi9kY=;
	b=XW+oHIG/LzAjeoQvJ70nwLOI1Jg6sgdVNgU0/JY6j3SwsPvL3Ix48cFEbX9FDM1ym4RjKH
	fmQIovpl2KpkUbVO0AIVgOUZ/pyplu8rv49wbHsVB/TFKfosc/mAeCK7U3HkHoS4fQzKAi
	H/3muL3eQq8nxJvi91Hq0fIuW6Afo/Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="2c2rE/7T";
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768088609; a=rsa-sha256;
	cv=none;
	b=KkgqJaxBsrJJiQiSVKhFI0W74BgnoHNRtJSTQ/0HTdvSzTphu6eONtIE7CXKusS0HSugc9
	Y90KGGcf+ETK8WZKdtMQPC4l9aLPFSj4/Jd3CJHSJ5e1j0UMkDxT5to1xQWJjzNIVvkDsZ
	t8B7G+1MUvLdrtim7Jzr0sweyLmGrEY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B76A4385D;
	Sat, 10 Jan 2026 23:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1D4C4CEF1;
	Sat, 10 Jan 2026 23:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768088608;
	bh=gSQecKaKkLaNLAcTBZlvSjsQawa4mlkJmaYF1xzN7aY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2c2rE/7TLO7rK2pbdBHNbNoNqgnZflo1uwgnNyYSRqKb5YnxtHATv5XE70IslL5JJ
	 EnmDWkdn9QlH+CMcQKK3lYS03CD1iCPTPXVzlzZjCkqQZmwejb14Ub26p1jz408ICA
	 ed/IIPS0kCGJpJBtB69B7BuQIWUU26ixhx4XM4WY=
Date: Sat, 10 Jan 2026 15:43:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>,
 Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
 <willy@infradead.org>
Subject: Re: [PATCH 1/3] mm: page_alloc: optimize pfn_range_valid_contig()
Message-Id: <20260110154327.6a723dc91c059ac219272bcb@linux-foundation.org>
In-Reply-To: <20260110042111.1541894-2-wangkefeng.wang@huawei.com>
References: <20260110042111.1541894-1-wangkefeng.wang@huawei.com>
	<20260110042111.1541894-2-wangkefeng.wang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: narppntc5pssbocfscedd1ntzesm9jmj
X-Rspamd-Queue-Id: 8192040002
X-Rspamd-Server: rspam04
X-HE-Tag: 1768088609-679749
X-HE-Meta: U2FsdGVkX19cBfVuavJRzLNDhxU2iqqgZvNNBvc/D83f2c9j4PIaKAFVjMcy1h1fmIntHen36JEQpUO4DYBwyj5VqvdnIXJ9Hw8kLBWLqZI9eMw9UL4jQbIwZSgHCKWTNFDoYIgJljbONMKGaJP4bbHz6djp6BvXJlW5dYEmGS2Yl/SU2HKZqSfgkSfWx1KJffWlbT1RgvFdo2QAcYPcpafkjznHLVzhx9sk5TUlFbBhYSfg1kDfx2cOVD5rDArZJkPiMRFK87Udp0BQF6uLeS/9h5vM0F/8ZouyBEgbOOnVIDGAgDDSnKyLuttCrJpofc99GXv2S0aYQzwdQI02Ho9guIXDrs3896lsykn/EZIqyjXCbEPJ3zYZ5MhhDcnxxhMWmUcAQoc/jyYlcynjgPxzQbt0wzHg8YxI/lsBR5NPLQf0pazjECIVewVOF4VGfnt+Qch61mWD8tSQ/c4OrM8UFQYORfolBePfLE40SVxj5iY0FgK7Y6EULLXjwG9idB1q0S/b2nQUzvKBoAQR7jp/TzpKmjUbNQ+21H7BW8J12nO7ViIhNU596/G2LszGasuTWg+eiRx1varWMGPfE4tkUaWnR4JFzMEHN5LTA3j7voHYmZ4Xk8QPBfUXQsllUfjPyOAQtPLRCOA1wRuuUn/LNCtoVBtTkpHiX64haI4uzNdPjdbdXFBqq97ogeGL43uVSczqnzmfKgmywg8SJiGTlte46hTXAEqAhRIoYtxPUttFRcAJ60LWMgP0c0NnVn4lPHN+jrPH9e5eddgQ/87SegMQzGaBczCXmD6weWj6qXR7BCrO07EQgCaFwXqfPrSBpV7vr52LW4ERRL/A/oAlzLzujQ7bEWF1PQhVsCehwHAcVy2T8N4i0xrDyAlS8oyJ6RuFRhlWOe8+3rBk7+GBSUTph/OFAl8KOZWF6KrFgwFgU9s71snxK7Gg/JLdBgR2ufEgd7S/nYzxP5d
 rB6c2+A6
 Y268NE0VEkoje4VWZnWnmCEe8P2WIiVNWsxgioz7B96/0hLoxFGYJ1uvOwUHMNRl4ITet3oR6CwiT1Twx1+YTma6mKsqAJRTcoqpzmc6/NYL9knIm7HyQ9qruIzSE4jvGJqkJbFk8LVjcflzOkl37QMJwGTESabMELguhDrKbkI1njc0dcfDUOIcSo5RgWQHaoy7IiEC7IKtoEdgcOwS1ReN9t12ojn1LdXpqYbcpDnH6p6s/OuZGxUHpIMAqDKHc6YSpfPLbfH8P25ciBXnII2vunzKU8x+Wk3f05EWg2lMmgkyGwVLsTucC3m0b1dnwPX8I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Jan 2026 12:21:09 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> The alloc_contig_pages() function spends a significant amount of time
> within the pfn_range_valid_contig() function.

Trivia time: saying "the foo() function" is no more useful than simply
saying "foo()".  "foo() spends a significant..." is shorter and causes
no information loss!

> - set_max_huge_pages                                      
>    - 99.98% alloc_pool_huge_folio                         
>         only_alloc_fresh_hugetlb_folio.isra.0             
>       - alloc_contig_frozen_pages_noprof                  
>          - 87.00% pfn_range_valid_contig                  
>               pfn_to_online_page                          
>          - 12.91% alloc_contig_frozen_range_noprof        
>               4.51% replace_free_hugepage_folios          
>             - 4.02% prep_new_page                         
>                  prep_compound_page                       
>             - 2.98% undo_isolate_page_range               
>                - 2.79% unset_migratetype_isolate          
>                   - 2.75% __move_freepages_block_isolate  
>                        2.71% __move_freepages_block       
>             - 0.98% start_isolate_page_range              
>                  0.66% set_migratetype_isolate            
> 
> To optimize this process, implement a new helper page_is_unmovable(),
> which reuses the logic from has_unmovable_pages(). This function avoids
> unnecessary iterations for compound pages, such as THP, and non-compound
> high-order buddy pages, which significantly improving the efficiency of
> contiguous memory allocation.
> 
> A simple test on machine with 114G free memory, allocate 120 * 1G
> HugeTLB folios(104 successfully returned),
> 
>   time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> 
> Before: 0m3.605s
> After:  0m0.602s

Well dang,  I'm surprised that the previous code was so bad.

The patch does a lot of code movement, which makes it hard to see
what it actually does.  Is it possible to split these apart? 
move-stuff-around, then speed-stuff-up?

