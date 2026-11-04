Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4299D606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G+8bQFjL
Received: by kanga.kvack.org (Postfix)
	id 5EEBC6B05B1; Wed,  4 Nov 2026 05:36:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0D56B05B2; Wed,  4 Nov 2026 05:36:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B55C6B05B3; Wed,  4 Nov 2026 05:36:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 292E76B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:36:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA9481C3DDF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:36:23 +0000 (UTC)
X-FDA: 85397082246.01.514D34D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2B885140007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:36:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+8bQFjL;
	spf=pass (imf23.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793788582;
	b=p3x6P1Pl0f3cPTpI2XLnNt4v7UPWHEIxIb7aAz1mlKhhatMG+vCqKsm/IqV4mQr7+hO2Wx
	qvqPhDYkaDsVF+NQ8mJ/jfRRaLflGeqjo8+mIFs1XdXYwqPLYVMOF9X+KSa+9QYJrBwz7P
	2Cqip7ZxLv5BG6m6x1XVHWyJvJzBCyU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+8bQFjL;
	spf=pass (imf23.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793788582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDTsHuiAv0ENOV6p7ACwagdR05GZdX+BTzzukNMsj1g=;
	b=5RGvHCqnxBHeUrNGK5Il3ivMjolDtPYY/+8beR5yqx2Gi6fzIO8jdau0ZJkqEOwfO0g+d6
	8SvtqzYRmL8ThLIF+Lr79R/lUWDRf2op/dfkNWUalHhvtcwy8UtIWxdubCi7UidhrIRvos
	UEsKztI4TTSDyWjUjvEpXcMb+1Q9j90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58B0B41A85;
	Wed,  4 Nov 2026 10:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E025E1F000C1;
	Wed,  4 Nov 2026 10:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793788581;
	bh=ZDTsHuiAv0ENOV6p7ACwagdR05GZdX+BTzzukNMsj1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G+8bQFjL7lxx+pyw4QKAW5rgfbkD1o90fVKkvCGhJPsO6ytTD6MJ3dfMybU+IGw8w
	 3PoetD7C7O8HEFJFRa61BnUjgzvQWp4zWSKZzIPuGvUtvppVH2JtGHgKXfy4ecZ+iZ
	 n7DAyc+/eJvurYZVEQ8VcBS/4dC9PrrkcaE/09xs93zv+EN9VDqDEYXKqBS3iq+6+N
	 EcU7/ZApz7ubZFjimkX7Vz5u6biu5H2Hn3cgTwfm9O8j0ASJI/1M8gtN1LbG32r636
	 IkZ+N0qxtbkd/ngXQ+pp7c3lhhOz/e3uaGyhMe/c0hv5rHKs/KiNp3s7gtmwXNqqud
	 p1CyW+z+yRW7g==
Date: Wed, 4 Nov 2026 11:36:14 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 08/12] mm: hugetlb_vmemmap: move
 alloc_vmemmap_page_list() next to its free helper
Message-ID: <ausKntv_nc_ggUNY@localhost.localdomain>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-9-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104023510.260766-9-songmuchun@bytedance.com>
X-Stat-Signature: 7rk9phy31jymsw8asy6564qibtzm1ira
X-Rspamd-Queue-Id: 2B885140007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793788582-885175
X-HE-Meta: U2FsdGVkX189FrvXxR98fGjCH9WlD7oyHyd9sZfZf5Sl4YjOadlRtf0folZDQV5GVGdrxB1dBKNVqPqvnmITUiLdQ6I0X4zTyQ/3dMTQ3kwG8wP4YUrXtTrEtgM5i+fmfpn2Zis7JYGtpoPunM/aGmudkksmJsYnyCYtkiEwIAja0fBiW/GJVv7C7VhGHPg/TsLQp5X5cj7CpNzf+tAc1D6IxslS15hBF/mh8yn25Lmi2vibSmcQN1lnrrnOTJ7o4HpL9UW47LNKyjzAP6YOj+R/79/VAbSk65KWUHQVhB1418j7t0bYiZVGQgnuxavRzwCzckpeMjKIeNt97DH2rlNhKkMLrpB9qE9e3jOdT89QHIxImt/I9nplt9LRtDiPUnIEUcLolS/LUzERSiP3vXSoIyBeM4J7oWd+Snn0eDwGtjc3j1j7CX11k5vT58qZ3k0NBD8LZsP33BalrAlvLicX7W2/sA76lfCVZFY8yMJcQsKNc2NtdpFfAgU737Rr/vfiQgxOLkJOQs++dQvtrZrYZuols2ysPL/GLgJKXQeSryF+aC9+Zuba204raVaJ3lfzCsUWpLhcPPfMSaATO+R/HLnPAMM+NsMBopV0PelOJsmiL+qFkDBE770m3UPrIsPTNh14VagorltXcWr2uFJ/NRull6IQlfOS1EKVWMaEg201akGEyrLbQ8k00G4eDgLj6mLqX/BIeKn29PfDMAsSf2Czv5Msaob192Orf71g5gDIoBKKecvkmXd8AXj612ayHBp2bYfCrzPaLMNvikrE3ZdlmAqLvR+Gc04sbo6iTGu7LXEOFE0ORSP9A9lqoUlN6mru5SeYqCx9lKD1QgSQnqGyXNZjHJffx8eRnbx3CMey+JzhHWh52hnyDc8c4X1E6Hof2DrpLcYl2BBAuz2WEaI8Gt+UnpHi+3vwHE6T2yMj4lPAIPkPYARis8EhOWQ30Ege5q2HjMIQPbK
 jHkjccEh
 ApAsV89Heh6RAj0RMBgjbBKzbIammTbbosVzv6Ke6I5s/X5KZLkW3BRI/0J45fD77twzdcRhWNy8/UXvsbmpj8D0v0UJxNzVyCZqmJ+yKXlzl7e20cRihY1qE+C6cihSY7KuvtrsDehY7XFXOgnA94fK5rbn1GMvzsB4XUtXRxicVpOGS1xtcrYqnji5kqy2dxvE43jwqGQDRvTR09SzsS330CeChr/xqllDSkmVAA6dXjFJm/DI9w/jxQ5dZV58bjHHXmKZ1qFuRzZ7hgNxzDlnmlVqCXHgloavFFeB3yD1CBb3yLe+9LWg5xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:35:06AM +0800, Muchun Song wrote:
> Keep alloc_vmemmap_page_list() together with
> free_vmemmap_page_list(). This also allows the folio-oriented
> optimization helper introduced in a subsequent change to reuse the
> allocator without a forward declaration.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

