Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8AACD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 12:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B827B8E0008; Thu, 13 Nov 2025 07:33:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33228E0002; Thu, 13 Nov 2025 07:33:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6FB68E0008; Thu, 13 Nov 2025 07:33:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 968D28E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:33:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F494BB8D6
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:33:03 +0000 (UTC)
X-FDA: 84105523446.03.398C159
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A9384A000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:33:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T91dFYre;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763037181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqG0ROgWoV22AjM+5JBccanZB6p1DZXl3D5nfHcdr70=;
	b=CyzSXqXMIRjrQVi2D3KbONsoBhzMvXXnZW1hNiVuEI2ubgwEgpsbYFYsEQSuKwq71o5fC7
	JBMUgo/2bReqnGCAJ5CnKi0BwRGfLdoM2uwn4iPO5OvT3u4SzLOa+Ver0ShbkpLBwxPxtT
	wduKvO3ga/9A5qFybo+yC+Fz9ER3+ME=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763037181; a=rsa-sha256;
	cv=none;
	b=k6nMAxIEwJtEHlSrrgeli7CU8hN5OcQ8NJXSMKHuyGScys4ebJ1EpsI3FZxKnaUtszLwYs
	+IJVhrp/V4i6J0Wekzac8LDviHQJoi9Du2rQnEHI74V/nS9zPBkmijQtaPYF1x50WQ85+h
	ZEWL3jmrrrbDLafRD5Pk4djaVO3zlmU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T91dFYre;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EB84A601E7;
	Thu, 13 Nov 2025 12:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1958C116D0;
	Thu, 13 Nov 2025 12:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763037180;
	bh=4dupOVHmvDBrhZbk7OqPGyWrm9rKMdbUnGFtpW08ALM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T91dFYre481ljj/UtX1xra7hVwzE5r8q3GoDigssBiPHqUI4ufRSOU26qhm9mD59G
	 oPcNSguHfR4CAmUIzwalN+MNUsJ496GNfjwyYbL/J8/Z5vL+zRfcGcMZsmRZrKkkm7
	 AavnYIbSn5z50gt5/lwfKbW4enpzr1W8+fj79kzWuOeL8w/gborxyAjab3xxGJ295X
	 z4gLJyp+EfABbOdqViOUQxBgAwNxBZra3805rVnIBO6QH0jbW4PxGPCEdrDIGyD0vt
	 Hk5t2K1f4y8vJE194LHUblwWXQ3IAElOqEojEOKRQd2OpXIx+iOHuhcfGZKv4mqfKa
	 ZDoBpei+AZdjA==
Message-ID: <1a591ac9-920f-4de7-94de-54bb5baf2647@kernel.org>
Date: Thu, 13 Nov 2025 13:32:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/16] slab: Remove folio references from __ksize()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-3-willy@infradead.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251113000932.1589073-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A9384A000B
X-Stat-Signature: jiwtgkqkbkyo1ipftwodn4yoxhckctmb
X-HE-Tag: 1763037181-432600
X-HE-Meta: U2FsdGVkX1+I0+cmPiSHybDOTYdrrjnv9f64542JZZ5+gW2Iz3bMfTQYCiabrJFbPBE0+bK4Wc+9FKdwbEO+r5oA4UtzWyLcxofxA82eSyxapvcS2uhCzWsMw/qd5/uRFKgW9TjdkHKvVj0RDl7vTsLaozmFaFy258tNX0F7wxT1PkYbQl0ZIhLwdm0bNLkgE+m9YjxMZoLbYlM/Pt2MnLyBk/IrfoqUXXxiOouP/pB9Qx9Rpz+8l/+SBgjWnTFQTBgdqpcInvhBbL8NfX0CZsQyTh0PtpR46CXx1crpFf/jlGMfrQySR9DFOK3/bo9K4ZCd+exc80L65tJtbe+pBF/ugj1YWlze6GAVffIV+Ycq+1prJ/ZDuirW0rCIn9b1WXlCo1sTVs3InsdP6+Rx3zFPAa+xqrdmunlFf718TLBZV5nwVja04s/xnYve/vKOUKrV81FtfryiMBXS6YSmRY2aJtyqHnIaW4RS4lp8IpVAxBg3pa6LGs+QICvbolDXvpisrXb0r3CGlkkhCH5Eb0u6L+OrGv6vnlr33Fs7LiyfVfvfGQsUst5rvjp5mPt0H5fVYUm4hzoE2amJVyVWkVDbxh2Mv6bz/mfjtzTH2KNWYpGJ81fwm2Ba4nYm6phxc4ywhRynlduDJc+uj2jsjrCMdqqzGR74Pr/CT68t8/gqrrgiqsTITB7dGL/54THd70GuY+goKug3kXvGvt46SomtYU3pYcJg8SPcmGoI2CKMbV1GfblKEWmbR5FxmRzRUUwVO1L7ldmy7gZEzuXD571oRODtWRSAKC4qcVpXA8t2BwvzcjDQb6bBbOWHDEwF5fMKzcyv7A3LrPPBLZAoezalukicx3xPMxytUfaeS1tsBnJ/lT5McDBcooFGQ7LZ9ipg/KiKql9ou1d09REdbeOAROQOz3dHOREoTk9cmljxBVmmgZa7lWBlUM2AXbGTg4uK/lnTKUxr9tUpdAT
 wo0lQ+4q
 uTzDvDloJvRTdtSQ6j3yAYcqAcBC5kvlF8xPiONxSgHqI7IALG7MdxGXSGKNkFU0vVYEzuNcS/cJFUXoJiCqTdMAz2NFgc4HVIuTtGkJc4CXYY62/PhdgU+qmLgnJ0JJtmkv6BF0EDM2WYaPWluCBdo52Vwt5PeFsxLSvD4VDxYO8eFLTMHTJiCIiuPQ3HaLOafsNgoF1UTojcTPnXa0gQCuFzaDvw1RdoIHQ5HzjsCrf/2UkGN3ri8lc9gge3fl3am8IDKPrIdHFvo7wYuyO4N6VG5HxyNfOHFXOE4TcK1jFNbAD1WL6suE/KSqDFPOSb3AfB4VE09kEF9HF1cCg9aKFthFYGcuR4Xb0PhOk7Z77Sf/+6okHFt40SYbTygMwRHLyjfhS8HvcXYN4+Ee8LH6Ztrxw+eztXpDt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 01:09, Matthew Wilcox (Oracle) wrote:
> In the future, we will separate slab, folio and page from each other
> and calling virt_to_folio() on an address allocated from slab will
> return NULL.  Delay the conversion from struct page to struct slab
> until we know we're not dealing with a large kmalloc allocation.
> There's a minor win for large kmalloc allocations as we avoid the
> compound_head() hidden in virt_to_folio().
> 
> This deprecates calling ksize() on memory allocated by alloc_pages().
> Today it becomes a warning and support will be removed entirely in
> the future.
> 
> Introduce large_kmalloc_size() to abstract how we represent the size
> of a large kmalloc allocation.  For now, this is the same as
> page_size(), but it will change with separately allocated memdescs.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

