Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 237EA606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NYbQqOrh
Received: by kanga.kvack.org (Postfix)
	id 0240B6B05B3; Mon, 23 Nov 2026 04:31:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16696B05B5; Mon, 23 Nov 2026 04:31:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52A06B05B6; Mon, 23 Nov 2026 04:31:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA41F6B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:31:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 412DB1A07EE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:31:36 +0000 (UTC)
X-FDA: 85465866192.13.E714AEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8E010120010
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:31:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NYbQqOrh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426294;
	b=gHZY78CNYr+bRfHI2VFx8pJJrC6wuoaDYa/V+YjL4HavyhczQ4AGF0aSmrT4LGJm+FdEs7
	++VQLh5/amOys10Q6AS/+d1zT9wyswiWSee68M4CI8hb2n7Dt4wSOkC40UKTBsN5A4GUyD
	fSzlmTiegUEwLzynPfPkMyh3fPU1ZJs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LEZQPbX7zIrfyumi30Iuldtbz8hOyWeoj1cQmTHb/4c=;
	b=AFNrfbeNXWa/5RjNvhbLRGpEk0pCdsjhdFNy3juyWUSPpugMBneB/TAhSbOgjlHG5a2xSm
	VK/i7TrG0RAvJ/SwMWJFgCJ9Z34jmcGVhyjChha5RUu0OQZa+8DZDlvkaNwZ+mEo3fqv8O
	dpSiyhDQqSoMjzHN/G3/Y3yC7463/I4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NYbQqOrh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC4AC415FE;
	Mon, 23 Nov 2026 09:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC0E1F000C4;
	Mon, 23 Nov 2026 09:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795426293;
	bh=LEZQPbX7zIrfyumi30Iuldtbz8hOyWeoj1cQmTHb/4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NYbQqOrhzX2/icuZaJsZyU3TkKk9NJM791Bmy6zOLVKfGocWltOuytH3cgylFY7Mb
	 5Ixrx865urTwyPPEF9dgo6bU7esfYBSqkSVS/vrh+IqAZSBlyEN/wI3ihPQbCavVo3
	 Msj3yTqgMDe0VbwJpS3sAtCU0PXUI+sCOrlfqA6uNPvHrnIx2QepvrL/7zFfAg/WbR
	 AwAJdBJXlwnl0COoVh8tfxyvtj7tGaFNr8c9FREDmzYSfwVvPpSbjtp48sYQhk7cC2
	 auYy6LCrLGJZixGstmvRHkie8DL0K8sujRegIfMjkqAVv0sEYCEh14uG8n9bffadmU
	 hP5qDSdcqFyTw==
Date: Mon, 23 Nov 2026 10:31:25 +0100
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
Subject: Re: [PATCH v3 05/11] mm/hugetlb: drop boot-time HVO handling for
 gigantic folios
Message-ID: <awQH7ZAWKC2Zrhy8@localhost.localdomain>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-6-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120100856.16929-6-songmuchun@bytedance.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8E010120010
X-Stat-Signature: xei5k86wi9fmypqpdq71qytuihyszx5q
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795426294-603686
X-HE-Meta: U2FsdGVkX1+fbA/GFY7JyQKcLFULBr5kTathe3OUgeNm1p8Ys2XF0oB/bkjvGbIMvsNhrJJV6sAOhTUhnFA/cXGqBQzaUDdfs/lOlaBOZm7o1cHLe2yrbAdQTVdikeZxcrYNpA8iReYQoBr+l2bX8AQLqayY+MIfhZ+oA1/L0N18QauPya7rQTNVQTVY5mta6wGhy9QT4srQ0zjZjky8HlRiqbBo5Zn95z34QHdYhCnTV04QkYk0avhnF0MVxhqxWd+chtbFMsFoXG9haRWKg31PEJx3tFMNUfULrl9D+izUbD5HFAwqtfOOo6x05KUikJch3DIqnSzKD2Fzfq2JVlQ4rjdLcr+jgfpFIv9IA+FY9Xv8nEAnHqQdfVVlqvCmdF6kqrm0hyUrK/NYre9OFhqLP1SyDbVoQpuOATp+AnS/CnOiEAMCCb8G/4gHCHqUISAd4wKeOCHahVCf8DaBDQuXks8KUYC8pgtfdWWFgi+ncmqEJb6P3q2J6uhaVile3O2C4NUb9VOwsTxHYa8yMiUFRzdWkgOXXpH1DiKKeeah4eseluj+R9KbTFaBDgRw35sgsFEvjAT2sexgAHQW6Cam4gieFm4Khu8m4dkeRstxkjLjeafurI4NRVZYQFybucqH3+VZJehDp1TKHUhg+/Eei1nfWpqUhhcubEAb/vVmrkd67p0oCUaQEaF6bpFTbdPGmz4g86EN+txQL5R3CHa3qQ2Bpzh3zLWv9aNhcP1t4HJw5GKLAJUEhWH16ZvQ9O3N0FcvlwtBHlkOzuFmnT7gfcjdMRYRAXSfEMckUkh5BUqNsahsK8F/UT5yKzBZ7w7CQwGlY2ulYQK4Y57lmufz0ZmHXG1Zd1MOzx1rjHgAzKnQ3jDecA0duwHtvtCCVEqWt/dmwv3P3wbxRtDA3seFswZJZLcxR00H4VZi7kUT3DW2K4ZfXKAB3jzzFGTX5XcQV5pxODzEsX8cINK
 1zcpBNuw
 4Lx9NiVBlnaBqTkvhRvk+q9hOqG0csLCTr+Ytg1wYZpvmjpT7dAv4uLovBmwvRFRnXh48mJEeTPFsduCCA+LOqMDeu6nabjMFtfQ/TdhIJxLULUM4b6/7dYn+X1DD9xGJYs88DQtuBI25AFvaNRLgT4dP9DDUJgLgDjnp70j9MZVKxL5zMmG9hXWI1FLkpukOsQ10vKZIQJlK6pbITtYXm5qRXuBI+941fZLlo8eQUIY2/MhfHk6A67d32VkoH7857NDXbgA58e1oYxaoWcoRaEjWI1+x1Pxx8REoHadMe8s5kGTVahXgCIu0jtDfj3eQz42FbdTnAHl1WP/lY4DAfmwg0wsqP/b3Vp6DJsyiEVKwF2fVFYtDpo5naD4VTVIrajUx+NB/Ym41yfFEt+zX5I8cHWFg2JFVwM2wLXV5Mwc6D+T1vBEJ//oAxoAUhlVzkptKq7SGKbKOvI+RRTTaX7gSHDdqzNINjPjCD7Xc65ydHb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 06:08:50PM +0800, Muchun Song wrote:
> HugeTLB HVO is currently supported on x86-64, riscv64, and LoongArch.
> On x86-64 and riscv64, gigantic HugeTLB pages are larger than the
> section size, so the existing section-based vmemmap optimization
> infrastructure is already sufficient to cover the whole folio.  On
> LoongArch, HugeTLB HVO is supported without gigantic HugeTLB pages.
> 
> Therefore, boot-time HugeTLB HVO folios can rely on the section-based
> vmemmap optimization infrastructure directly, without the extra bulk
> optimization and fallback handling.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

