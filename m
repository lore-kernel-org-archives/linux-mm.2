Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52634C5ACD3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 16:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5B86B0005; Fri, 20 Feb 2026 11:50:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372F46B0089; Fri, 20 Feb 2026 11:50:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255476B008A; Fri, 20 Feb 2026 11:50:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F05ED6B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:50:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7BD781A020C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:50:53 +0000 (UTC)
X-FDA: 84465424386.28.1A05828
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A6A6540002
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:50:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d5W1HDLz;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771606251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhJz6AO2smTz4OPHnhTTcMcb/SkGEP42mmzEHHMk7X8=;
	b=mDzBDrz+LTXsg9XRT1Ev4JATVp8PIwu9oizp9hUJpniK8bTjEWYv8HTddpUYpTYZBkGRr4
	uHAnc9adgD3mSCblUHrOrKnljeFiZ26RejNiC5I5ppTVjv3Mmhr0QMQNZwTnocYaepc0MJ
	AbBOD2hLpw7+qimN95nmf7gtKIXP7Oo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d5W1HDLz;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771606251; a=rsa-sha256;
	cv=none;
	b=INzTX+cfOZj99WGRZKzxn6+XEJZrU0Ibc+Zb0UawplJn4yhnGGevvd/AzPO6kti6CRZ0p6
	6VAVI59a57DHb5HRMLnrD4t1aISSWPkhljS+GlEYvvEpZAwkScQ9Y8hYLjwcfcuPIdPzR0
	mxXWK88US3CZ0pnji6NBE/wnXGY+5Aw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B34BC41AF2;
	Fri, 20 Feb 2026 16:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BC8C116C6;
	Fri, 20 Feb 2026 16:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771606250;
	bh=+Uij/0xoD2fksuZzZkZLFNcIAKJYICDzDr0TGD6sxow=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d5W1HDLzSBMx3frw2niVk0GR2O9vcnpmuDh3nVZ09DxzHczZ5uzY2u225TKsjUTua
	 bZnCGRvMT7WmR5K5UJUVsUJk/Rt1oUCOQozAkKZYIbZ5sd1vuDPYRD+oXzRT//KPRH
	 DvrTY8DWFMcDHceh3SgIZQCVBHw+KKQ9PO9czG3ta2WIyETUS5IG2NxNpHIC333463
	 3fjyC5hLQVzbEqVqV9OP0tgNsDBH5aj4jjeUmOX8aBQDVWuDn+VTfFHZSlo2clBzd6
	 ViGv4WtWdnCqQdApp6geo/GRYIvEtQRzpZfwufEoU/00iPUg7GvvN2ngvmfIGhopfE
	 ecrZkicAFaTMA==
Message-ID: <5f61a5fd-ab38-4635-aab8-5de515c4015a@kernel.org>
Date: Fri, 20 Feb 2026 17:50:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
To: Matthew Wilcox <willy@infradead.org>
Cc: Dev Jain <dev.jain@arm.com>, lsf-pc@lists.linux-foundation.org,
 ryan.roberts@arm.com, catalin.marinas@arm.com, will@kernel.org,
 ardb@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <aZSHvt9Trlq7k7aH@casper.infradead.org>
 <2e68ef61-dcf2-46b2-913f-14980a104faf@kernel.org>
 <aZfn0tbKl_1JD-VM@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZfn0tbKl_1JD-VM@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mj5no18ikynhrpjf6wzp8tfzkdwxiq5z
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: A6A6540002
X-HE-Tag: 1771606251-990258
X-HE-Meta: U2FsdGVkX1/X+tPL9IEAFqdalLVxtlvRqm1QbIr7rIAtrw7YXmCZlJzhOe0ow5KYXKR2o09y/lVd70tO2/EqQWWUrs4AEibi6QIbiXjIGYy3OJwx5svsmgyTbYkeYvni0Fwh4T4gSvV7GveNWsJtqt+XNjU31BzNBwxa6rw5opvgzH+4j0H5baZI4afC7jeN6NT02OSJP5suNhFJuH22vDgDeTKZEpIC9VlEanEAjkkLdmWm0la9PMEbYwr7SUD321ukjP7Rg62fh2ZZQdJiG/gIO080mVbv4eJillAyxUvtrehpn5I7OM9rdzN/XkdQZ9klaIkdL4cz2nJX8Y6pZgJaUvL1XX6YsOSFUpcFRRZw6kGQg5OQ853REW9R4LDkj0sJFedH+4YB7IlUtzrYB/hxM+XYM4B8a+uRgljiL6oSwChwHMHsA3HAm9UD0Ae6XzmdLg2UiOw0jrPxE8GrNxna2yrcHJZ5d7hoLoLuLdtliDzqNx3MOzabGxcTc2IAK174QTp2KqScv5sUMw3RZJZBtCunkeqRrTz3g2ZbwUhtua67M6/A8qPv6dQHdpVo8+RhBqEts4bwstwYvQWSgVAv066dFUtwAtZzR3smSnynzZH+7hCigz6x1UggJgQ9DuHXgKoOZ/lnYscf0sFX3lCQLxsxIZY8aCsyDH8h5DPTwAnFMlhE+v22qIbX4ELEZ2ofLUXq8B2hZmOK7PcIz99FLNy0Rlt4z8mvJew60nYL/80UxzdY6dUO9fezwOCXUlAkzdny0RzJJIt3RWlMSS1dBujDtE0sxse4B9obUDiljrimffsxOQKNvC/UInIWxSQGCRKZOlcyOcX6Sfy4UT/LFGIE4Fl4xFv4JxW+0fr9e0m7PyLWV0rQJSKwZa/jagTDtpPrQlsauFO0k8GP8D3ts3DsUgmPmZpcTDR6ZWPPRpgMZgEt3EfRsA3vGQUMvoP6BX7XwHFNcUTnfPt
 jjsjyx4j
 cyDL44vZRzvwBMiz//XfJNqvsWM+gI44d4ataOCjRRV4ny0a8RXHKXhdapXSeMJRsULjGusPxQjuqkWUDsXn8sq2UZ8JWVBdp//fb6g3SmaD/+/Ek6YW13HwZ2mMWu4Ryu7SYyFI1liE9qGgLSrqA+lgTk2nQmgatRub8LA7xqmsVCeWL7cSMUt+rJq9NWf5GN56QLZHEwkgffVnwkQUTpPJFh5oa18S9YiBs3XKh1grAARk2nPzB0Ts0X//JS6vm74gv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/20/26 05:49, Matthew Wilcox wrote:
> On Tue, Feb 17, 2026 at 04:30:59PM +0100, David Hildenbrand (Arm) wrote:
>> In a private conversation I also raised that some situations might make it
>> impossible/hard to drop+re-read.
>>
>> One example I cam up with if a folio is simply long-term R/O pinned. But I
>> am also not quite sure how mlock might interfere here.
>>
>> So yes, I think the page cache is likely the one of the most
>> problematic/messy thing to handle.
> 
> So what if we convert to max-supported-order the first time somebody
> calls mmap on a given file?  Most files are never mmaped, so it won't
> affect them. 

Yes!

> And files that are mmaped are generally not written to.

Well, let's say many mmaped files are not written to. :)

> So there should not be much in the page cache for the common case.

You'd assume many files to either get mmaped or read/written, yes.

> And if no pages from the file have been mmaped yet, they cannot be pinned
> or mlocked.

Is there some other way for someone to block a page from getting evicted 
from the pagecache?

We have this memfd_pin_folios() thing, but I don't think we have 
something comparable for ordinary pagecache files.

... putting them into a pipe and never reading from the pipe maybe (I 
assume that's what splice() does, but not sure if it actually places the 
pages in there or whether it creates a copy first)?

But yes, doing the conversion on first mmap() should handle mlock+gup.

-- 
Cheers,

David

