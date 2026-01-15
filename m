Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD6ED46600
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B399D6B0088; Thu, 15 Jan 2026 12:27:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0AA66B0096; Thu, 15 Jan 2026 12:27:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A7B6B0098; Thu, 15 Jan 2026 12:27:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC196B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:27:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56771C1C41
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:27:11 +0000 (UTC)
X-FDA: 84334879062.05.335A057
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0A56D1A0009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:27:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=acae8XOA;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768498029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bCHkVRU/U5rQgsQH9vl2iyXpnOOqBXnwog+zjgM/cU=;
	b=S84yiHNeb9Lcs14BvIVPpNaGZWS2Khlj+7T/uC1CkC7Zm/pa9csMnzst2maCTuOgpIhk2Z
	3rKcM93M8hmH9X/HFZQhAa4ksnCLA7AI1I7F2KtoXCxVGBXOKzTByTqEuadISFfsMR5rwN
	KlDtCxc9LQM9dePlFdhvv0s+hhqKHNI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=acae8XOA;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768498029; a=rsa-sha256;
	cv=none;
	b=iEnru/eoZsIVpcMQj4mnyeIkiDUEKFvBlisEuEaLVQB5SOjImLKtrgmLXmkZp1guS+tioz
	ooPtHLvPKdRZ/j3aqf1vX68oLVshoS8+MEqETXqcb+BXQ2QlIvVFccdjFeSg08BsDc9Xee
	Xjf/lWYPTJtpo2NIEpxGFEogzcKf8Z0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 031B244351;
	Thu, 15 Jan 2026 17:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65452C19422;
	Thu, 15 Jan 2026 17:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768498027;
	bh=efvNFfmmF55G1OFW1ALmJUn6yfpTkuk/CjfnMcYZ/94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=acae8XOA+V0EFGSWN3XUYMscNvAOo5loDdvJECOaKFaNAMNRTDs7SL3tUjLPb5zWx
	 e0TVqOM7bVQPslulGtaSad40Em1YRIrN5U3E8vJlrP7w1aD8vRQ5QimJH3b9c+HKgu
	 h+US2ILkv1WBC4A9OgmB9VMAqhrW5cXgqDPTzwIKCkJWRFtbh1llfpK83zXuC9R9VS
	 hZk0X6JZxtPF4nGDIYCNboepa6LzYAoIh1kLmOYivLoDxxP+g3Tr6zi+uGJJz0BOST
	 5S9G9nZ8zoc7J8G+QuH5rKjpppF7gBy86wnVt4EkB8UkWEZ5ZdYjPGy9JHaRsv6SQI
	 cBJNtlsGsTYtA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 88920F4006B;
	Thu, 15 Jan 2026 12:27:06 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 15 Jan 2026 12:27:06 -0500
X-ME-Sender: <xms:aiNpaT67TyoasDbt1LAROzmdavez0EtG9XZ4hLt70D1cKeF4kR28qQ>
    <xme:aiNpaUSMkyWdh7DErH-Zld6tQc8ZERPmUFwtPHiJo7TC-uFmQ-mUMGc0RrqKH1W7K
    hUsTZzCYDaA0JQfC1wRgZ-WLF3u73AcuTx1PlHFF4l5jVctTvliMOs>
X-ME-Received: <xmr:aiNpaT3XOAMXAUpRbHD_dzICsRzXQL064V-i-NcakVjqhVQa3dW9BzPkom0NLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeiieehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinh
    hugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhn
    gheslhhinhhugidruggvvhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:aiNpab66OzbiPAXpkXGHGfosXzW-t3DjGgOmKWPezmlE8xkE66bv6Q>
    <xmx:aiNpaSsiBrJrQ_mf7q9WA0ALDkKSbdHKuxzeWLSaCSLI3Nx2vvkdQw>
    <xmx:aiNpaUNYWLfnJJLjSaZfGmAGcEdoXy2A1Ve0aJ9clipvfyy4PoAiAg>
    <xmx:aiNpadWQz6_MT3yRWc7sv9_TKNcCU1R0c277-2wZxFDQfefaYrnXjw>
    <xmx:aiNpaV1jQGUDbMggZzPUu3pCUoZ-tdr2sJjWOjqWt79gBJT8zU_6To9b>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 12:27:03 -0500 (EST)
Date: Thu, 15 Jan 2026 17:26:58 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv3 02/15] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
Message-ID: <aWkivSMMKX3AGdMw@thinkstation>
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-3-kas@kernel.org>
 <be57dfa5-e6fa-4ce6-93c1-239436ff6e89@kernel.org>
 <bf788cfe-ac2e-4ffc-9349-64d9c36bf072@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf788cfe-ac2e-4ffc-9349-64d9c36bf072@kernel.org>
X-Rspamd-Queue-Id: 0A56D1A0009
X-Stat-Signature: gk7fosiautjdhocf7oujs4g5nhei6a3s
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768498028-942011
X-HE-Meta: U2FsdGVkX19G3IZrA7XH/NylNQH4WjVlKHQMu3PMCv6il1eKXJf1sDWX3PPb5UW+U/vCqy7Uh+9TtByvmgAtXvgOSKqQ1eaCyBZSFBlFCWir1jK3+dOhPTHvAOAMKcZFdCflWfWxA9laRIzhwnkykCyqF5a593vOsTFu2DG3KU7VKOE4dO/LE1LQ7OltuhUHC84Ogh50+2bP2VIa9/tT3zGA9+GzFxXBAUo0eTmMVrQIWUKNn+ZfyVtYo3gIbp4zTeCePvRHxhwvId+MeEEzUkDpUT2KEf/kOE7fmnOvM93hXvZl1NQsxM7tKLFfuZ+xrJLWbMXZzC4xYUwO32VYzN8quBt+be/lW0BUmNjjctLfPbTrPo3eIUw90Y+wfWNRHSV5Q1jUeE7X1rSuMELyqhaPttsjlh5WdfHErIaKA0rUUXlaJtW6O2JpMrDBNI69ZO/9Sa+YFIrMRyKKy+BrQun3nc7M9BOSYtziTerSDj3rteWo6xkqatuiRR3Pq3657EKx1kUHMdRvvOLp2g5sE0vDLrAonrXvAf/946TyiRSBbWRm4emhrw6VBuUgTk1tW47RNlkm1Yb37YPB17Z9zjxxNHY8PtmobyU7rTIqFOMj4pY/P8omwDCHcR4SuPHvD8K8a2uKYxdIjJRinlzyGfJdlXFYCbnEA0LjuMLRiPIpuRmKCZtk1uG4igPsuYKjcexy7yU+JnHemikDMHXtTospRhmRpv20tiIzsV8b5644PffNeeVExPYUrDuFDnW9vcDc6ExDJgq/uxIIovN2m+Ry8O8PtKzqayH3n9cxWpbS2pw3EASB8yRdZ7w+sTVpIbkiXUIeQCpUJifzmamDyjBLWO6KHuOUVwUGO6YgJuZqMEOc+lnAf4U2ZwQ/ahyobvM6Aog+hDG+8Se6O6JdxtUSgUqod1PIXJNrsnOYF32Vum8q5FEoPC+ag5U7Rb1S3CtzD9WiOBoRbncQpw7
 maExSBZX
 6qYXP2V3TYLJqqeJVc24nED21bH3iQMOL1FcdxnS6l327M40Zp3gfpio6e7crJDd53QxbkzKVIoDnLeTZ/w7YpkxmsczFWDIVxA46Fvhc3gyKDK2OiZqqvK5TCsKJfPpPGLt/NnUy57qSm89orn74WYNcfY2kFsrLw3Pum15ug9vzD7ntcvjdZ6VqkNvRQFBP7ryYUvNznV/3brZXu/oq16vwBtsd4T3SnZRtVkcSlxA/JERfyv0aYJ46AlqC6XxMj9z12u9ekeIXfGhwDOpXjZApko+CHn1Q1cheanMBFP1jiG08/CQAxoMpPsTdwY7wbJQjp+SctYjozXdoJk232KEmTNpACG/fPjpZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 05:48:20PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/15/26 17:35, David Hildenbrand (Red Hat) wrote:
> > On 1/15/26 15:45, Kiryl Shutsemau wrote:
> > > Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.
> > 
> > Why should that belong to mmzone.h ? Semantically doesn't make sense, no?
> 
> To clarify, I would have moved it to something more folio-type specific, not
> something buddy/zone specific.
> 
> I guess page-flags.h + mm.h are our dumping ground for folio handling. I
> would have moved it to the former.

I moved it next to MAX_PAGE_ORDER definition which seemed to be logical.
Moving MAX_PAGE_ORDER around is much more risky (will likely generate a
lot of build bugs) and outside of the scope of the patchset.

I think wherever they will be moved, it should be moved together.

> Likely we want some folio.h in some distant future.

Sounds like a plan! :P

> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Thanks!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

