Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D90E1FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50F2B6B0096; Mon, 27 Apr 2026 12:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6C66B0098; Mon, 27 Apr 2026 12:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FD266B0099; Mon, 27 Apr 2026 12:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0BE6B0096
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:05:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9EF98C9BC
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:43:54 +0000 (UTC)
X-FDA: 84704756388.01.53D58C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C2C5E100006
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:43:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Op4UAysM;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZcL9SJaWhIqQTF+xzLzlWxdkIlNLwuwdoErNyviWFdA=;
	b=RzRL5WaWpf37sBkGUptbaNgjOE8PFbswLKO2MNDCNgcuXmkZ74tNx+FilolXkQsCkdXQz/
	BM5+nz7PhuyrwE1KfdCdt+EDPQsuTvEjz9YKCR1b8aInC4IJ1BLZbwm+v6RRJ4Jg0O7PnV
	++ewCjG6nIRsZjln0GvP5acLEKggrAA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304632; a=rsa-sha256;
	cv=none;
	b=PHMlZTLsjDh78KUBmlcioRZX1e/vXFU7ccaXGIEydB93L/9QxI9AAUb2TPZA8ELBpc8DeF
	xc9YlVcmL0vrn0BWJscp2x0EiXm0wX/Pwwjk/Jc6IpYUsz78+iTS1fmf8UWMn8iX8laeDV
	ISxr/FtXmTpd7BMBnf5RDUnZ1q+GCRY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Op4UAysM;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB43D43382;
	Mon, 27 Apr 2026 15:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C9AC2BCB5;
	Mon, 27 Apr 2026 15:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777304631;
	bh=VvfxMnKh3iwekWUZ7AAC60YlyEPAqkx6fxSktTI4CnY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Op4UAysM/nDkZ+noUle7Jp7HBJEjirYTqilCyJV1SRbpIjv3iw/TmVGqMoQkUkZR/
	 nyNAtk33PpzjLvrhmG3nYVvS68lpltXjss5HKx+Z84d4QLIFVSvzHoeOrBs23bTl3u
	 RCf2NG2/A7nEMsYsatPc3D149htpYk56JmFYlZ6Fx1k3KllIWDcVKzx1OaCtZCjF08
	 l18SOy1WPgcWslNLwC+gJMXorZVqjLBkaGlgMwBTX+t34D2bxReDF9py8ZCmp+4aLU
	 5EeX8v9wi7l1yJmc8P0iyHiDWwZIWW8IkfAQQNM36XVUKUDkGL2VZqUUhJRaXKjBgX
	 rMh9ya7IGKNdg==
Message-ID: <42ad4017-185d-41bb-9bba-a73a8fdc4ace@kernel.org>
Date: Mon, 27 Apr 2026 17:43:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 14/22] mm: page_reporting: skip redundant zeroing
 of host-zeroed reported pages
To: Zi Yan <ziy@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 virtualization@lists.linux.dev, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Matthew Wilcox <willy@infradead.org>
References: <cover.1777223007.git.mst@redhat.com>
 <788d5a09394ed1456beaab23f75d91846ceeb611.1777223007.git.mst@redhat.com>
 <DI419PSP5050.15VGMJFDMWBQU@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DI419PSP5050.15VGMJFDMWBQU@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C2C5E100006
X-Stat-Signature: k4ubir9paee7nd7ozaw1bn3zqi1nehsd
X-Rspam-User: 
X-HE-Tag: 1777304632-867620
X-HE-Meta: U2FsdGVkX19ElfQJwaa/Ctjp4pCLfrl0BJbAj1v+2aLGi4kjBvyN2iveMvabqSc+iYbQ7oZJzT/DwPJMI/aJLcahiskC6Y6mIgVAQgxkP3vI9tF6DvelpWBP39KEWWecXbugfk58VTUASk+B/cNzhynHPDV1xM8FdQTRUNYPA3xV9zul5JZ9eoUfu3Im7k+OxAUrjfUX0n2ImcpjAYLoPCwihFE3JAciNUIuF1T87Qn4O0xHaS7rYCDQm2czF9gXLSrZQczKY5cJpNzURPj6gU58QGIUOP6uhdl5J55ktuvjv6jeJFGc2bzuusJfr2VMGe8QjhReq20qA9fhX8OhBOaHKu6VksnVdnIF0DTcrHF9bnrftqmvVStReXEHxF9aheWRVs29CMdZ5K9eud627eU9waQ/QsqCDWkPwC6LIR3uy7tjXV+uJKlvukM0+SiOnCiQyeSGonJxfw9ElSd+OuNrctl7NB+gUokj9AGh7V7lq+YqH/BzeuqQG1e7ddSu7Yv6oniYRdWQsHO3yDAtTgmYzMCu48bNGa70tMO6BaXtkAjIyzyxRhxLybeBUK9A9YkC6kgIr5PR5zhPHha53uaVv9K3c1a7RwnySyiMSddIpiOlIzOZhKhLExxxgAZ/CaSnZ/QApPXPz738ciLhTirfn0HltQUmCssU7+gSDT5D3gEYUVMiyoJwDn/DDlTOHUoypaIp1umh86RBcKjZTrI6H/IYINMusi50Tdw0M10oTDYVXnAKxrlLYQub+o48pXqb0njNoOgPJC+Mvz6GRjTxhpb2Wjum8gnF7dwQlu022tPD0nJ0oFdPqG/VSlpPFnXARsQSLa1x5j20rbhsY8bO99X9UIBNu9AAaiAVa6qm6aMJMnudqkfHussSu4rR7EoQ4IO6pkswtpixo2BcdfL8N0zaBBtfNiLNdcj+0RNhPIlWALUh+14kyUXmn1qB6OuQd5j+bPXvkEfl0SG
 oagQXFte
 XL6YqEGFmugfCKQh1Ei3spKmE88bvHawPrCGToMWyjgV6nyD0p21xN9uv829UGPd2LsLC6TgHexGzgTmzQe5tHLZN8bEGgt6AJvDyM6U2a9FhdytP3B0VtvEgmtVfy7i14pNRgD2xIHV424UiPMghJESTHbHR6ZCgzoqK7rqKCwyUpFKxwE9amAbUhXA/bFaxGbQbXqrCFtzLkHJ/KtxuOfCwZMgv9+yfUkgGrab7oTc3Ie5mBWW9sofFBUl43d4J+er/j+OIdG2lummRqEXNyGjHaKSumnAlwpHOiKi1s9ZgG8dZ4eLrS38/Dq9ojsEQnVwvKTwMS5itWEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 17:13, Zi Yan wrote:
> On Sun Apr 26, 2026 at 5:48 PM EDT, Michael S. Tsirkin wrote:
>> When a guest reports free pages to the hypervisor via the page reporting
>> framework (used by virtio-balloon and hv_balloon), the host typically
>> zeros those pages when reclaiming their backing memory.  However, when
>> those pages are later allocated in the guest, post_alloc_hook()
>> unconditionally zeros them again if __GFP_ZERO is set.  This
>> double-zeroing is wasteful, especially for large pages.
>>
>> Avoid redundant zeroing:
>>
>> - Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
>>   drivers to declare that their host zeros reported pages on reclaim.
>>   A static key (page_reporting_host_zeroes) gates the fast path.
>>
>> - Add PG_zeroed page flag (sharing PG_private bit) to mark pages
>>   that have been zeroed by the host.  Set it on reported pages during
>>   allocation from the buddy in page_del_and_expand().
>>
>> - Thread the zeroed bool through rmqueue -> prep_new_page ->
>>   post_alloc_hook, where it skips redundant zeroing for __GFP_ZERO
>>   allocations.
>>
>> No driver sets host_zeroes_pages yet; a follow-up patch to
>> virtio_balloon is needed to opt in.
>>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> Assisted-by: Claude:claude-opus-4-6
>> Assisted-by: cursor-agent:GPT-5.4-xhigh
>> ---
>>  include/linux/page-flags.h     |  9 +++++
>>  include/linux/page_reporting.h |  3 ++
>>  mm/compaction.c                |  6 ++--
>>  mm/internal.h                  |  2 +-
>>  mm/page_alloc.c                | 66 +++++++++++++++++++++++-----------
>>  mm/page_reporting.c            | 14 +++++++-
>>  mm/page_reporting.h            | 12 +++++++
>>  7 files changed, 87 insertions(+), 25 deletions(-)
>>
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index f7a0e4af0c73..eef2499cba8b 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -135,6 +135,8 @@ enum pageflags {
>>  	PG_swapcache = PG_owner_priv_1, /* Swap page: swp_entry_t in private */
>>  	/* Some filesystems */
>>  	PG_checked = PG_owner_priv_1,
>> +	/* Page contents are known to be zero */
>> +	PG_zeroed = PG_private,
> 
> +willy,
> 
> I was discussing with willy and David about removing PG_private and
> repurposing it to PG_folio to identify folios. IIUC, PG_zeroed is only
> set for PageBuddy, so it should not be an issue to set it for allocated
> pages for folio identification. Let me know if I get it wrong.

Right, we can keep using that flag here. Whenever we leave the buddy it gets
cleared. So as part of your work, simply let the buddy use the renamed flag.

-- 
Cheers,

David

