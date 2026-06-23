Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 683F0CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496116B0099; Tue, 23 Jun 2026 07:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446DA6B009B; Tue, 23 Jun 2026 07:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3362B6B009D; Tue, 23 Jun 2026 07:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7E96B0099
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:48:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7CEDD167024
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:48:25 +0000 (UTC)
X-FDA: 84911004570.01.01896FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B1A5512000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:48:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sgu2UXjg;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782215303;
	b=zrd6uFPHVloAHsK+b0Kruzam3CrxIL0ZuXq2l/N/SBBrTIVQ51laKLeR8bmjulBAu+ziNF
	z7U8xemLXFbTWDb6hASp1F1zxPaklJaDZwrOdutrdikZryplm/lRboc699j4jS7bZlDZ1b
	T0aqEtktwP0lo8Wzmo3sPna/KBYQgFk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782215303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OtjwWXEuZAsYDPcpleuNlTNndFnbrGXHnPOWcgGQAuQ=;
	b=T969s7Cy5iGxzPs6USp9pIQbLoX1XZFFPmj9ejWuOuyt3HaKP13WVqUS3HLosuS8Zy/4al
	qo1k3isrP4+btmq3e18NXD1xkrGiUSE1eOxHBa9QTaFxvkVqGViq3ATSiK8KiyP/O7ACj5
	qjVZwEJkgOQsz+iwc3EFcMJ3XFhshnc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sgu2UXjg;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E69F9441C5;
	Tue, 23 Jun 2026 11:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9061F1F000E9;
	Tue, 23 Jun 2026 11:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782215302;
	bh=OtjwWXEuZAsYDPcpleuNlTNndFnbrGXHnPOWcgGQAuQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Sgu2UXjgmvNoZiNkjzcPVn8oGkRUMO9moGfMrVyBk3H/WGLviFw+NBhtmjASYDxIh
	 ZM14RIJKpQVaC/o3WPcHHvv1kKCWdT+Uw4oGJ+cNGurNhDjgtCOxS3Vo2HA1SzenjB
	 gLKRQwnhvbjccM3DNkZdsOYNWyYaJNyGVLtNYEqXBN2USpcYHK7gRqc9tVs+RnvdNr
	 Pu73Qk4/UP8tMmKJFwXMyjGI0/1iSutTqeT4v9jGCAut9ODJHZF3WSTPQgNbj71kgs
	 zyIobycGLTz5v83JwlXWWUfxw/nphCJ7uR9n0mborOAxgiwFoY8R9G1OZ9vMYHFxMY
	 HdZ4E9SSsu2jg==
Message-ID: <b7527f33-c0ef-41ec-9eb5-1b9a4d547689@kernel.org>
Date: Tue, 23 Jun 2026 13:48:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: avoid KCSAN false positive in memdesc_nid()
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20260623084432.701120-1-hui.zhu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260623084432.701120-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9pksehgi1q8nkpuzyaarce58hnqthazh
X-Rspam-User: 
X-Rspamd-Queue-Id: B1A5512000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1782215303-63618
X-HE-Meta: U2FsdGVkX1/QYp6XUV17dVONjbiuMxmDhIECX3tXm5FUDfz5FjINt6+Rsz+Nw+u0lf40x+0+3/lm6EqhCBFY6wcKQBjYz3Cd75lhYkcvhruKis+IWyiPb0Yoy6Cn+9RuhTAmbIRpubIy8yxfETzeAvF2R0uPyWCTlT3pnq2kIKPwydWSmfBSdCSQkC6BjCYnr+yvCyIQD0FjhhO2O6aBbR0HkyIA4rM2Q7GfeafYBszqXi4kvAfXWkwHXudH7mKMu9Loa5dDKg5MrvyheaCIyXUQeEg8mY3dVgqlhCEYv+fgpz79gDQ4huIOFzHOVqZbmLSeKufBXM1wN/Y8HbPBtZ/9+OBWlZJjYYIF70gD9bFyLn8dFb03MCrlEdIZTp5QztDT3/tkpn4UpxrZPmOHpFNy7m3dp1acTTA17B+H6GweVu2eqT2f/JTceWD6VXk+VuadQd9pReO31geOXQRyTA8yvhfXIFVxjnasQmqQgWGl9VcdGhP2jXjQICXiRX/eN6XIwOh8MuDWbOGdq28yZoMdFOfsVahMPCFJ5thLSWb9kRB+eaUKhPT/c3HeVxKsxtOX9j56IH8X9C6guamTLWrXptHlNovQksGyx9AHqq/ptz7FEWedz3QJXpkYckfFSkukBrA1fKs+DrocnZtRdYVt34yyWJN5Jr8ZRgogdiOG9u+eh3sVW+agnJLYVvwn9JWaf3+btBooijq/R7VhYbUvbVaAvrpohtrjGSGtDhgirSGjYWt3cxmvJTbFH/z75722c0KJgOZfAGMnle7SwbW6HdsYd/yStGs+SmbTGc1pGebKW8jeB59cNg82c0+W+ChOLbIS3kGLBUR28K93p+tZJDDclj96386vdVpWaZb4b/6Hv/yYeasxy0dBO/PDVy4jsfh95MDxKLT8lssU+vuA1kRjgTdh6+5axgDv0EoGlAt5Cm8QlZ59jsrgwuZEWWSXasDTmusP8fua5ys
 Cc/PmHqk
 FB6YiQ+vWrYUw6mreik9MnZII8X3Uttd1sSdK1f4UegL7ylTr3vGZFx/x9FV7naDYYJIwnEe2LIp3oaWBBWOwYNUir8QhGSZU/0whoAuyAZIjPLkkeky9KY7Z3U2hWvsV30GjRFrSxun1v/c3V5ZG7TRcEYdSWht7d94BThDDR5teML/AU2JjwNtZcBhmrPjmfcm02psxmfFAJl8OIlg0EvFJjjeurOxewOKUsAc38d5quEjzqoupui7G4aNmPqo6MbtfV6kO4ftLTxRRJJHj1AoSgKnT6OkQosdcn9Z+tQ+qqPH/VQixP42WPPWneu2bvgjo3HhDP6f4csU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 10:44, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data race between page_to_nid()/folio_nid() reading
> page->flags and folio_trylock()/folio_lock() concurrently doing
> test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
> 
>   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
> 
> The node id occupies a fixed bit-range of page->flags that is set
> once at page init and never modified afterwards, so it can never
> overlap with the low PG_locked/PG_waiters bits touched by the folio
> lock path.
> 
> Use ASSERT_EXCLUSIVE_BITS() in memdesc_nid() to scope the exemption
> to just the node-id bits, consistent with how memdesc_zonenum()
> already handles the same class of race for the zone-id bits.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

