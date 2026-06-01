Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55FBBCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85B266B041B; Mon,  1 Jun 2026 11:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832E86B041D; Mon,  1 Jun 2026 11:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748B76B041E; Mon,  1 Jun 2026 11:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62CFB6B041B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:19:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08E57C24AB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:19:10 +0000 (UTC)
X-FDA: 84831702060.23.0732623
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2171840003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:19:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThWjfRA+;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780327148;
	b=ONzdkE7tdJ3M9W+keNYhNAMjK6P1IhmUkIqwaQlvdC392ptbKJPgevA+D+1eM1i8sAgDVJ
	2XZOtc49mQXnXWUohPOOhJKxVGt6nouT9gE/7Q1PWIbNAZJv5V9vqQwZ5h6VLzfnkPgAFB
	US37qh7inGFxIMfSVR8WgX868H8AJHo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ThWjfRA+;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780327148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ye6crJnvDz9Pa0ZBPPt97HRJ+37E49toOuGpZ0Pauqw=;
	b=19Ro7httL4sxWakE89EZrY323kOwh3cCHT4lbboyPQK2mcGSc0e3ONBbehAInARoUaP/JU
	vP6LGCGE5HW7Plc5DI1egkmYHPVM29tEKZX8Y/p+t68m6qW027JIcdS0iW1E15OGFzEh3K
	ZQ1uBfG06rTDezi+XX3wM+CxSafm3dc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4AEB544045;
	Mon,  1 Jun 2026 15:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499A61F00A06;
	Mon,  1 Jun 2026 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780327147;
	bh=ye6crJnvDz9Pa0ZBPPt97HRJ+37E49toOuGpZ0Pauqw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ThWjfRA+TwaKPKAReyDmwfGI8QADj2wddX0kufFqiiXcLVXA1UmWUq+hdLeqXtQlS
	 Z3pv6s34ETDXbWE/JuSu6g+P7VY2705oMY2OXOzqgQ8BwcTTnXkQhlLuW6GhnwfuDl
	 tAuSrw5WiJe/+UO5ur7+CM/DrUl5KJhrbVpk35lwcZQBgTWLmbA3Jo7vPxZP6mOLrm
	 WXC0EGitoQ4L5kEEJGKLEnQpejQDbSbEOxxdhv3GyRQWLenlbRinD1U6d8QBh+zhzC
	 QIO+eZ7DHGd2+Xx5MHwMHu4peq77aE80bMj2L36jcKyC4OfPidwk+G3YhulYiDZgN+
	 T8QwqkFKJoHMg==
Message-ID: <b3c8d59f-c1ac-405e-84f8-79ac626379ec@kernel.org>
Date: Mon, 1 Jun 2026 17:19:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/vma: remove mmap_action->success_hook
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1779462249.git.ljs@kernel.org>
 <2521c19866f3f10f9085d094cc4f06769042be71.1779462249.git.ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2521c19866f3f10f9085d094cc4f06769042be71.1779462249.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2171840003
X-Stat-Signature: ztadpndz9fgst1saa38u6bbusw69r3eg
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780327147-338741
X-HE-Meta: U2FsdGVkX18+4snwtBJBI4Io5qTZ69rKa8nEka7a4tQ809GinDstVlSioM1V52TLOzV/TAUvg08ES1s6+p2buL7h6s5K3SzxZQLWm4d+ctN/Sz9smg8qKamtEu8MzrbrO7l484dFQEmZrIOG02oW0NGs7oUrIzuF+fBJGZ4T/wrHVIPUWyiAdKBsUYofoqkndD7bpboJrcv3fn11ko/BYKsOk1VyA0nrtVaJtqFNuBCBDhuR3Np0aqgKmcey+4IoFSBgaseG53rQmUXEX0FssAW+UFGcPC33UDSFyjpikcLfCkK7l0yG0znoSWkpXgxnvNr0D8DznB3Ur/WWBY79csBXMnTjOKIjzyv9J4yvjNR7Z60lefJJhkkVd8sR+nct0Q7DNc99cHF8ovJv0Cdv2Ugx7T5IZYzloRuRlk9ioPvG80aMe6W0Ac4WjxC2iv49bsghUYX7j6reB0dXu4jpFZUHDM3IGy65FP2QK0tD0bOPKjmoW6zAEiMdY26SlfbQgMLfbZMRPsKQc0vluX04YqrxYDCQnKuedSclPCQl77xOI7EJRVtG1ghWeYvjtKMEt7liJvT41CPvxags1hxwpeayqaRpPMJVEqyajUR+BqwpBeZSmE1qRPu73UA/mGZEu44IyL+j1BrLIBENRIqeE5ghx0troGww5T8Wdx47wSGOvnYH6ImUKXohGv7e8A8piiL0gog6nk5uRCRST+9Jz08Iutw5kySn8M8RmodvrhZM1j581R/WaKdNukPjfUID6KZp74gxyM66DOOHcb4Q8X0SmZvF1UpSIzWOtCgcBDq+1+MwwyZQp1OYG+BlhCPzsdsYQpBx80nQ07yCoza4cZTP/f3sweuYbVQB9dWZeVgm79Ymya9h3S/pMgZIasTytW8TGEG1za4T9sj1uYl3gDn15U2CHdBeRdktf2sJU5ENO1qY/pGCrlgpVDVi6dekxxhvAyYfIiAQegAfrcY
 9+v8Gc5e
 8NNKpUQ+w1zqMS4szk1vMWAKwE/c/iZR8DyDAZBvtSVAlAjT+9o8wm4G23yj/WZz36yWBzWIiTy6e/muxhbRKjAKRv6vjxkWnkQIOhDySOYOouk/SR3ESowwz1gF25Cgt3gG/0Yh4xskMOSNIUeC4oqzGxklpTKM4mV2W3au9hRd3GmHOMrUEvu6XbStDCdxGoj0FfDMmWbMMZ8dt15z84ymJnnBnUKtZFvi8Fqry+20zYjcbjd/0sUltXlqGcpCVfYvHad06pRK3fLVlSkwR+kOwQ8l4usEWSYYk8zCFGTj4kP4iSmt44fSETMKVNZu8n6ANxNo67dAmnXZDXoEa8mPfQ+1npycVImJ2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 18:00, Lorenzo Stoakes wrote:
> This hook was introduced to work around code that seemed to absolutely
> require access to a VMA pointer upon mmap().
> 
> However, providing this hook leaves a backdoor to drivers getting access to
> the very thing mmap_prepare eliminates - a pointer to the VMA.

Good!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

