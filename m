Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF07606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ii5KGgU9
Received: by kanga.kvack.org (Postfix)
	id 7FCDD6B05CB; Mon, 23 Nov 2026 04:41:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ACC36B05CC; Mon, 23 Nov 2026 04:41:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6767D6B05D1; Mon, 23 Nov 2026 04:41:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2936B05CB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:41:09 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8C42807C7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:41:08 +0000 (UTC)
X-FDA: 85465890216.18.4C8F442
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3784214000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:41:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ii5KGgU9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426867;
	b=XXwyoj3bl2+yPtK0i5eWQMlbtypr4vc+T9IPdEo0y7K++q7fGhIqaIMfv7ImyzmgCNhDjw
	yX4qWZiLCf4Ai8wAqsjtiq0TEh6NKpS63wY/YMCn1JRk3fFrpj4ZI/ZT4I2lQvdV719T/i
	nxSnMqPoNQ1MZWxIeUFc/7El1307E7E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDbsCd40aR7Nelqiz/HDZ/5GIrPYzGKWnCVoVVylrKQ=;
	b=gFclBr8gGOCvcGkGv9fcZ2X7RYc3MqQKhdAsWJ/YWkiWFeUJYKMTajvmz17rt+Kg12tQXC
	2lcDXguEyXu66/lidpIFwTOJetCKQmNv3kCA5OUuvFM6GVrl0IfwvOWyvHp03kgJD+kfwo
	Y+gfo2UFVfp9pMvHBPMNI229z/zmMn0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ii5KGgU9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E329618D8;
	Mon, 23 Nov 2026 09:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A971F000C4;
	Mon, 23 Nov 2026 09:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795426866;
	bh=zDbsCd40aR7Nelqiz/HDZ/5GIrPYzGKWnCVoVVylrKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ii5KGgU91+AwbrxiYqP9KH9Qd4WEHVCyZvPdZcqMGofPlPGy8+vUsx8utI1Qc+as7
	 2VH7UaMcpWjCvQQknd1XiMpG4PdTc2TvX/8pstKHeb9RzXXJDJzhKs/t9BifU4S/ws
	 C4mcsSDGgS8dXgHf4XW6DtisLdPPBhjdEsJr5JnFwMlauuOhTQioA6fwiSJYLUPOWh
	 /yUsoW2h2Ey9gPXxGg8MD6GeDuR79Qc/GUdsUF0MzrZjNYfptWG0dbxk9t6N+4APgM
	 c3jWodz4up8EhQQu1p3+wJk1CwO0TWnBfg++BYfabEfRjqijD3PrJVWxMjmv8ro6hu
	 twnyGDZej7qUQ==
Date: Mon, 23 Nov 2026 10:40:58 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/11] mm/cma: localize init_cma_pageblock() to cma.c
Message-ID: <awQKKhcwHGM-oiFW@localhost.localdomain>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-11-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120100856.16929-11-songmuchun@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3784214000D
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 16gpszzb194napwkgj8r7rgss5t98kzi
X-HE-Tag: 1795426867-124455
X-HE-Meta: U2FsdGVkX1+IVk85d1+MHyhCvyCTEn3suHkd77KuG9t0UrI8TnYwzy9w3/maSsO2RGMMb5N8XdoCdKkk/5fXE1Hv0LL8wIvYHfEyFlkY3UCwSvfZk1vvwdePemB2E+FAwQ+oexm/2Gx8+edgBsRbuTiY8G+xkhmzR5A3N5FmmclAQjyQ4uurS8C+H0ogsSZyZHgmCiA+l8WdPTEXD0mWtAfPGaGWPbOmNK40lRNSSPVn+B4LNmTpyC6A10HvTusq3uH6sc8k/ZlgM/DCTkg6EIxIeF2Kn+vf28fU1nh++aaJu/IWQ6Up7+0nTol/DWANy0eb1Pmi5euVsGu5zKOl/TndEGV5gfAJOw8YYdlfAYyzQCcok0pbYlkgSl6Org3+TtyydkdRJWe4PzPCdF10v2c5RC9IRAKf3Dhem/yU5RG7rBWzJQrjzsK08r6aoyWDwUBbYobD1LxAFPCRRS9egDEzzQoQjY07lQsQ1T89YBe/Dtkafn+w6HEyT7I2KNHgK6IxnqV2AWS7AIIp/lfWQgoESM5A+mLdXRSgoyjaxcn/uLk/0pNLzpjbWK9v0c0ndtQvLx17frRV1X6Z2pYOmjOSt/FvTdFN2iM2nMxIcRqDAj0Ds5b0ZT/0HYBii5/mr4rRsOieFNdY7AJ5g4/XWAeDRSDzTHby2V/v5tTue1pK10noKDPuiUlI30ex1DMuXaBq2JWhzXIxDZA85AYqvsxuLXYPJ6zUjezpg1xdibP4zny9pInAhPHIpWmvwSYUBRyum/gpfPSoJW0eo8hi30Eu7kHptddnzhNx2KJ0N9kiezb5OvgMWx4VYm45lMCTm+GaZ1BUb86gWmCRSMPEjPqqCo5etAidElPiiD/cxON0Mvguc7/WfXOcBMyr17zdlKC6Y4EafI6wmTW4kyufRs3QbqV5zfRqlnJynAZlVf+I3i7WRBxVmh3QKVwkEds2kuHkn+A2pv5mljMFaDD
 g5ryKE/D
 kqqdNgAO3iYzrBtrpVzp5t3pOIpGI9Xwv9NKGVGkz2xF50g8JaH4LG0B9TGim29eXR9p48iMuZTHRVYVrVj9hrkBQ3hskc1VmR2hDu4Mk9NKLrVJi6V7bMnwZMXbo+ZZz2HbAWrykvFnEs0ndeAI4f9LosOzO/bBFkKvgPLW2+BwY12cr/PoWdjjPGLJm2TiXS3MD6yVwJ7iS8+rElPUoXrf+FqzS6MWU2NDmZ8rjcK27OIX1Pi1U5zyw+Z1oWbjPysc4vx52TEXHyeSNkyryokoPivmSkJkgi+siozrySRrMFRGo148p3k2MfNFHwMYfDz9HweWPj1uvpxZ79kAYGzyvr3Pa7YdGan5Dq1DE1HNXSmVIJsRmGHiNNLIr/KfZyb67ILzHi714tvjibCQEw/aeixcJrFju8ti4nAiB8W0Cz0BrE6w9zq8+9aPbcf17tXTQA1fWY78mtJTfk+sNKbhrX2TphrPt7jjVIKydp9lBDOFcHYf5rOfdu6oPquc9G1qwGViX2mo43s/pWcFaadrtUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 06:08:55PM +0800, Muchun Song wrote:
> Move init_cma_pageblock() from mm_init.c into cma.c so it lives
> alongside the CMA code that uses it.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

