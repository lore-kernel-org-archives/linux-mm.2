Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E88BDC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1196B009E; Fri, 11 Sep 2026 11:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87986B009F; Fri, 11 Sep 2026 11:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9E036B00A0; Fri, 11 Sep 2026 11:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7626B009E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:35:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDCC740284
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:35:38 +0000 (UTC)
X-FDA: 85201881156.28.BC5A9B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 08F13100002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:35:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G8vhHNr8;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789140937;
	b=2gsFqErmFy7fmjawNVIAZB+sMDPpbWAWt87IzKDN3WBMZByt1rgw87WM5Y8nlk8rpQjs8m
	vMpm2nY95XqZyTIkNERZXwvRFBc4NYcexIhFxwOYvLxgzeBd1LrS6THIly5eyQRlzrIVXL
	XAwNvI+HTvxrGNb5CKk5dRyXYHCyO0c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G8vhHNr8;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789140937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8htBhrrS7QJa0BzCT1gDdtND0CWm0Fsl2BMBtjFjmjM=;
	b=N/O/cF3MHCkFVOcwWAjSsuW87cQmT0dpxuVAfhnrujmCmd4Fnf2L8pbtrvYDZKnVXGynsk
	Rb0RRaRsvZ78nXdSdcyhvZm5YvZgkqQcwGYF/GbHqMrOHLbiRDEHy8WNoLSsBLl261cvlg
	PGlSQSjyiVSpt0PC+qvZukvfxbMnm0I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F4CE41691;
	Fri, 11 Sep 2026 15:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA771F000FF;
	Fri, 11 Sep 2026 15:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789140936;
	bh=8htBhrrS7QJa0BzCT1gDdtND0CWm0Fsl2BMBtjFjmjM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=G8vhHNr8GtxwAZiagsKXcAhnsR/45HrxtPYuUh/1TqNcr6fNSt6bmUiL910FhgmCo
	 yxWZWx6B8z3+Oo1cFZ2293FRzkaEms49uD1pDZVNta8+wj7YlHcPCPCcEtwWpCyV6D
	 TYtp/uEorhAmvL5kwQZK8VnHGFYW2lpQOseEbEvvSHO5YiAWHF9P5SwL+ahVr1atu0
	 HDJ489c9eh7svfdUWlwWIJXS/hj/qO0oBIwSlH3rGmaRjrWbIjvROVGjAvXoRLjvdQ
	 Vr+Dpl3OirERuF0oRgKNXBZGtL+rK43A0hcJ2TzRu0Jc2ELJARzce2uj4pC68TTHYj
	 0tJOg2moMTOsg==
Message-ID: <20de0829-1d74-44d4-a7cd-9c3e99d3caba@kernel.org>
Date: Fri, 11 Sep 2026 17:35:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] proc/task_mmu: change proc_get_vma() to stop
 returning gate VMA at the end
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-6-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260910234737.1340642-6-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 08F13100002
X-Rspam-User: 
X-Stat-Signature: mq4iqty8s7h77c1hx86zaqnww86e5zp8
X-HE-Tag: 1789140936-837721
X-HE-Meta: U2FsdGVkX1+EUopy/j5Bvd08+WLoRoUygiBNl+S3xMg9Ml6QljfjBpCjrb8okk9cqDZ09/csUW9ZSiKVZCdOTH8tU9VOG00WjrtMTgIOKlsfSPmdvg+pq+351VgEOG18pVlskuuVAs7+ZnsO5EtavrLmWozPAZFOTHHDTVRfAXzkE8clx8QotU/Hc4eQol6dRpsaHbSib0Lcs2ZXg6P9uRbAtLbSXrh5yXG20MGYYV++KSJxw3ZPvQe/AeaCjG6bJQnuxtqkEBF968N8uNyUqR5mvpF2trOz3igIvE37jA72KoILz03kXdHvwVaX6QpouufipmC015/2XB7+htSFjsCBOGdBOAuQb5HbnZYcRviovSetQkXzV/1/jXFiV/7Ps9Gx3ZUEhKfPM8iFSPuzUFMSQ3Yaqp7AvJKr3d5wB5ChC8uDtGFZ3WVNtqcUwnaToBIHevHP7lzOCdic3QYG2pqUyuclkAOp8L6rCqtjvFGkWRMVuGrqmnprXZHPr02HLi+Pu8a3oTPk71dcA/AlCVKXOb4gPBn2vT/lAhZzo8GtPq+IHEPHtnMPeXfwdwT8iFLeLcjHSZvRu1u/1EK64OVZaCrdOLLAtj7YR6agYdDvjDkUHE6QZNF9U97QCTWL1mvjsSd/mvD89EE8P51sA5wmrYmXAOjYAXc3iE50dUYTpPZdq+crw24rk+r7+UyUiFtoL1XK4961rpf+ynpb+3EBzllQZvbM4RJQ3EjI/vXPfrkDElOr5oGALrWO7J1fKaIVl+dxaTJJpQgE+BMIEGYC/6FBwaPl+iFwDAk+P0blXDgXvbAPkbFNxgbc34trInAbyBGsbafzQ38TZ7ZgO3E92EXY7wX6xxt8aj8ZyRsgH0adbI53BmWqq8SmaqFD/t0RVLaQy/P3Z6H4qPDJSSrC2T44NuoPbrm7eAYJbi8Rie/T4u3DYb7FJR7cK5+KQQTL14toF0r6EWcTw6+
 ntZXarZH
 FJEx/h/VcBMVHlB+8FlQFDirBfCYgYHh/hQgcc82nlBNYv85mRJ6Ebk8cJetHM0200YRCWy5ygAxcbjW/Rxvjd7yWtfkZ5y4fIShouIsPUK29aiUswumNoYXXDog2rqP+lmmaR9yGD4iau6QjfT4CP/Z2j7XPbBq6ZUy9aI5Etr34rgWRDcMmZbbWYgagKBKAEun6F23BkEvtax94V9TGVJoFouqtTJhHKBuBvryHi2/2OnIKuGgSeLMuT7ZMN2g3FXm7ru0T7viA3ynAUCZS/YrgnaJbLP+e5iUNUNMqInNpikzzDRlh0uwQyrK2W8yEDz447ybwMxyWwrFKGQ2oRlytYWBVv2Vw/k/PbC2MvG5L8ojdbqAmBn9wmEQq9BByfsdXO1+rc9teo+at9zVSzcbHmkJ+iBtBTAyshiUBc70GrUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 01:47, Suren Baghdasaryan wrote:
> proc_get_vma() returning gate VMA at the end is desirable for the its
> current m_start/m_next callers, as they need to report a gate VMA at the
> end of the address space. This behavior is very specific to these callers
> and makes proc_get_vma() hard to use for other purposes.
> 
> Move this usage-specific behavior into the callers themselves so that
> proc_get_vma() returns either a valid VMA, an error or a NULL when no
> more VMAs are available. This makes it more generic, simpler and usable
> in the later patches.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

