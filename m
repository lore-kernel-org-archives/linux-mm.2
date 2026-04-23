Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633E1FC0379
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 15:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33216B008A; Thu, 23 Apr 2026 11:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0BED6B008C; Thu, 23 Apr 2026 11:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA176B0092; Thu, 23 Apr 2026 11:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EFE16B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:54:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30CE28AF9D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:54:44 +0000 (UTC)
X-FDA: 84690268488.17.8487420
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1DE914000C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:54:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FoUM4B7V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776959682; a=rsa-sha256;
	cv=none;
	b=QyoUzuHbUXVquCO2Xqt1Q3ewMYCbvuOoQGh6DhKxu92Op/itlvyAjZei6LQYzgsfSjsL4N
	OJyPSB26bTdNTYDkYny37Hp9sqFIc/hRQrTJGTIIj0RKg3sD6D0SkOpI/cjq5w6jxUmSNY
	XB76JdviRtQWlA/Vc5WYExbTBDH4D2s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FoUM4B7V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776959682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vy+aLADFCcpxvsQFrusf7j8ad8pmGYveKtZdjczccZ8=;
	b=FSvYAXqtKjiXjTmUKltfCiPBzgGpE9dR9L2B9+pBLEpGChtyYl1UR/kyX0LDMU5Y1IMAgL
	RV90htXhlaTEErxEvfgsAjfm1BrPbwvsgljl40+V+hH20CoXgmO9E7GU2tGF2ajZDkiX/Q
	A3I/eF7HTtif1Mx3OxC2o1p+QGv/ZW4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D098941B32;
	Thu, 23 Apr 2026 15:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A57C2BCAF;
	Thu, 23 Apr 2026 15:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776959680;
	bh=6RU6hAbvXt8P+A6ag+w86/z1TMHEbmLhSFSKP7Hywwc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FoUM4B7VWJOm0vLQHqq/C3GfwDptB5lG5eISeQqilEeNEfZP1zeQxBnvv2PI34Q7y
	 zg9w5dGy5qWtRq3M09WFKnC7hgPm2yK0hMC4rpevdnrI5y8NykdrH4hfzkDUNxHDqg
	 viJC+MF7aFJffoJpwCBZ5+iePX/U5JU8jPY8BwuBCm0c9UlhGAm7hWMHNmSTkO6Ywf
	 9+Jd39Y1XPDBEZBQVLHuQzArjFkk0D1Crob2jqAx0g6pBBXnFGF3+XyXhF/+F6Xm01
	 eWhzTE3QaPNpJcFsTTZ7WCNjQXiNrkHY7PqM20s69p0uk2ZyCEVO62SAdg9L4xh5pt
	 QqmIt4RfTL1Hw==
Message-ID: <1ab6e58f-d984-4bae-a343-1b0d3c973ad0@kernel.org>
Date: Thu, 23 Apr 2026 17:54:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gregory Price <gourry@gourry.net>, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, linux-fsdevel@vger.kernel.org
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
 <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
 <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
 <20260423074433-mutt-send-email-mst@kernel.org>
 <aeohzbmhQAoOODPm@gourry-fedora-PF4VCD3F>
 <88b0765f-7cfc-4e44-83d2-c01a1755c842@kernel.org>
 <20260423104120-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260423104120-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: kwsyof1b9d85k8fknk38udaysfjheotk
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DE914000C
X-HE-Tag: 1776959681-816180
X-HE-Meta: U2FsdGVkX1+U7znZk694q5j7aNv/eIer+knBK1idjgsqICdghqhxRnwnjyedT/YPgfLdtO+jcmYEfpe2W1fn79M4LvkGAXg38CT8kHHYI0dHr3J+LNJeHpPAphe25dQ6+XfavQ+jr4ALaasdg6WJuzVl8T69RoEDhaAYpu0UUZB/piLH9HAvdI5Lhw7cb0niB15oHnRT8dVcCTDoU1I/1tFy5/ALhNfrhhQ4YPC3V7IQDSQi2YZ7aLI8ylzITbK2nK9VCTmuQBPWi99kidkgksTAhUxO+JfsLpinVq4/0IA7PB0j5ay6Ku9B6L7evkLzULjtgW5IY06SSTmAD2vpKHgVmnyCgUJuBBwgjbwK4jhEthqeUBEHK8rj9mepYtA8nABguu86WkY4NNeJ7liGSWumhogI7MoZAGsbMZVKBd9ZVKH/0PevcCYu0dr2m0znwiZHOY0pzg0QmfnhNeu6cdUE4jVq3aKua37TUViGfDZ33Vt7nAcvDZdI8JRUr8J2BC6tZ+sJUnmOopnfy17eWYgJ3MfY7k6eCkp0pCdJdbvGe5SwxsZl2+2H9zVc4CMiV0pNqTi2MpeGV2b66mx7yx3VVamrHJBT9v5EgC17pfQfs8Y+K1bzfwk1E7CM9daCDcSDv8p0lpvu1nixslpHCfyWKoGpWpUbZj4nw01Kq2dEeNOLb6S/PlFjQ3L2e8D2AxKKirWx7EGJwJDyrxFGVNlqHXpeEUAfJCAEdjRLp5FdUumi9WYFd+NASPqi++eyo00EcFuXm5oOgTOOn0q5jQ3grqOqVBl6sqxbDeQ43iK41qzj+kSoH86vTGqGaNu5IMcJ79sWoM4wGVCb9HFWxC1f9f8UMRULIP2D/zj51fxvX4Umobl+Vg14V8tQnA6hH3XXU7I8kqQ8dsIDrkV7rPvulsWwpcQ3u31AaVI5z59b2c8LSTZYwbsuUep2aqD17XOpql5b1dMkC3U1sUv
 I4bvVlWa
 GaVvkpfAyWaFTVMR5Dnm0++SclDnxzz1OYqPd5hAzdal4mXjxG1s0avDsHmbVdhE+QZXgU4Bg+YYx752n04vx55Tq9fESFLxwwXdAAAGbrjbSlj01c1BnQzlU0vq3Oh8aYHEIsRT3DpfTmlRU6KLqK/LEFfOXN2KZWmFg92fhz7ZH5zU1B/vP3S2COhus6eZuJPXNq0LRKzN5p6LpCio5j0O5Tne4i9E+PI6rIvAtRvAHUFf7iow+4JIfnDU1uhAr6G2+flQ/qQIttL1jMR/U+7+Hvrh70wJYO6KS/db+NbQNR9wnZhGJMoRgi8bITUaZEjWDBkn4t+PJY7znQTmZ62JKWpQlJRh9ygSLTVosd2hfDXB6IBcye5u+xsM5ccFWu7bp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 16:46, Michael S. Tsirkin wrote:
> On Thu, Apr 23, 2026 at 04:13:50PM +0200, David Hildenbrand (Arm) wrote:
>> But really, that hugetlb code is rather messy. I'd vote for leaving hugetlb
>> alone on a v1, and focusing on non-hugetlb first.
> 
> I just dislike it when things are non orthogonal.
> People are used to: hugetlb = same perf as THP but more predictable at the cost
> of being harder to use and using more resources.
> Here, suddenly, we have an optimization but only for THP.

Note that we also didn't care about user_alloc_needs_zeroing() with hugetlb so far.

It's not that it cannot be done with hugetlb, it's just a question about how it
can be done more cleanly; and that requires more work to clean the hugetlb part up.

Best done separately.

-- 
Cheers,

David

