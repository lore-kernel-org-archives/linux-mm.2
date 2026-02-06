Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A551EB28FA
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED28E6B0098; Fri,  6 Feb 2026 04:42:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9CA16B009B; Fri,  6 Feb 2026 04:42:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F3A6B009F; Fri,  6 Feb 2026 04:42:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C921C6B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:42:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61D4D1B27CB
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:42:35 +0000 (UTC)
X-FDA: 84413541870.21.299D217
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 839EE140009
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:42:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GSvVnMTC;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770370953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhtg/7GX3NXsxhckQh7kks7D977Vk1pRYCk+7yLlU5c=;
	b=CPRzrPE3Y7c+fZu2q670pXLIQuUCJYrpFjH/jho6E9U4aAT66id3ObhW6px3OAO7o7NUw/
	0JMNb0nJ2MlowsyFjbuNIqRfcWuFzMjqwICt34mCUJ2cYiZGcyu4OGq0nU9WU3NLJ7V3UN
	8WJrQ9W3Dy4o5XL0gM8Yl2uV/l8JMyY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GSvVnMTC;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770370953; a=rsa-sha256;
	cv=none;
	b=b5moTExp6zxTz/0Kz2D/uSBDZXcRKl7hjl6oKvYarwGYefbjny9rn+uHY7TbBGJf3YPpaf
	kD760+LKtQjzKox3QmXzJsde7vyYkwz1A/lfyHGFnNVX96ND0NuXjxLTl1I9sB31Q75yIk
	0/+feK04ASgQQlNSoPNZyrzYUzj9x4Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A4F5A43867;
	Fri,  6 Feb 2026 09:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FF4C116C6;
	Fri,  6 Feb 2026 09:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770370952;
	bh=LhrTzSWf7NEah6Z7Oux3u9gbfwj2MNl56bdSDhRmPl8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GSvVnMTCcRhkxqlqeDx3rM6srCHZuDenv1DdtPoFP9SUQF8TtuPX/r+4ffLF35a1z
	 Ya3vXMuTz4OOJrBpC3QVOcQytVqQMUT1mJ5GxbGIGf7EJGU+N6gJF9KKyPHkdhuied
	 j04tYZXUUvXAkbj2ysXMysEc59RfXPQGZHhTSA6i6PI4+j57T7VPUOH69hOp+j/cy2
	 yVhWELbxXuWm5SP2qxoGok6mGdD2AiEEDOTR9oIxhwob/7H52+k1jLuQMGzMgKqnNt
	 u8PlegUm+gteaVi/n5UohU/uGYeeR/8vQpstamEQl+CsHkiUMRiikbcO/+Ojwu/bls
	 wMOHaiNU6bRzA==
Message-ID: <ad1a6ccd-d542-420f-b862-b41b7a29054b@kernel.org>
Date: Fri, 6 Feb 2026 10:42:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 13/17] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-14-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202155634.650837-14-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 839EE140009
X-Stat-Signature: aouxa5mqegeed5wco76nn3g1bb3mkd4i
X-Rspam-User: 
X-HE-Tag: 1770370953-63962
X-HE-Meta: U2FsdGVkX1+OprUD1kK5/k3Bs7nVm52TqmGyfnYXmF0t7QJ+mtRJzZRmWeRjqQUEaQgHsVrFHY2+1Yr/Ye8ujeEsrhv/hd2tQUea0My07kR8eHB7LN9/Nl5ROBwE6Z+uFr2nrjRd3ywgrqHHv1C+Q+LS5mL/ZLX5KhD+tkd2vXcKcq9NYFb9rqudRt/Yf16NmuhLXq08KQhO271UPbKIHk7ldVolxKVaz336C3xc/RY1H9+pmUAhGpY5cIk+4tXWIOqNb+B4WMlJAbSD5Kcdn5X/v7WAgVsiPIPwWu5NcCOwcOkAmYOtWhub2t7/SdM0pnVeVQZOm+UKz3Qm+WmxLeAtybvAasjlD7+vPxn/s9QOYxFsIn1uBkSjhQVQvD4fIki7oe+7/eIf2A0tfcfoWQh71ZP4W8KhoxY9WncXRRY6Uzdpps8/XqIDNw9Rb1Sskdx0cHNiDwDY8D0hQQKSBF9RLmTkFFyTYJVms8XqYzK2B2cYE8FHPt2upXBWNxXvyKrDZOl8un3We+pLPEKQkpIkRtlj35jmaAHdlOcRsytA0RH/iypFtQAYgY05ynZohg4/qffa5c8ZWe7A0OccieoPlmnkOfi6MyhrV5oxsWC+e6VmYn8+/8lnbBeCvJIjX70n8825OSV1cZscydVsCSXfen68ryukDCmUncDW5fpzYxkGZ6r63cxj9jeePVBHjGps4GBnTqC8J+A0hjSxveu0wGxHKXNgCV7aTM+hlGjZEGp/acHatCOP6A4+PszY/Of+zoYw0hjDERQ0ek41FltNya8YIZKrDHjaoLAeM80CDZjmqmme3W8UnkljqCTU1tiDsIe0oPbimIEOyRPd+WoZehaE3svMx3IHECqnNE7DhVsvQZFSbNhe+e/mej4oph54baHl+Kb6e6GZ4qVJGFEd0Qn2GLoepunGmpYbuYYOl8caNSUFkdD9rRx3jAK5ddUfpU7JaXqYJw7RatV
 exUidbbI
 46wQolO07LGf22IR2HGqqBXVx7y5/PylV2gm//LYmDrxtP8lDXbATbDHPANUGGtlSuL/tOdcH9+o9L6jyvSuDbVZyhZEsWkFeOVN8zAX4RB2XvSo9PNl4LBaoGtMZg67XFzhWlSwTjcodp/mnQnGYNFtCcMBr0tB8J47tubfEeRgn4lT58Xzsc4ZoS5bVKPRj2uh2/CRkJpGNdE1dC6MdTDlm6U96xp8FVVnHtyMmOz1v/biL69AJ5QKwUQP5mO9C3hG4SZrURSMAmIqyCe2PAInZ9waBVZUxQ3L+xkLNNySppch9wnP83WPmDXFb2yv0UwU3fTtY2ZNqNKM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> The VMEMMAP_SYNCHRONIZE_RCU flag triggered synchronize_rcu() calls to
> prevent a race between HVO remapping and page_ref_add_unless(). The
> race could occur when a speculative PFN walker tried to modify the
> refcount on a struct page that was in the process of being remapped
> to a fake head.
> 
> With fake heads eliminated, page_ref_add_unless() no longer needs RCU
> protection.
> 
> Remove the flag and synchronize_rcu() calls.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

