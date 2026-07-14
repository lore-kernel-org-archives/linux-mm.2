Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44C71C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1293F6B00A2; Tue, 14 Jul 2026 09:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101B26B00A5; Tue, 14 Jul 2026 09:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018FE6B00A6; Tue, 14 Jul 2026 09:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C84AF6B00A2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:07:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F9E41C030C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:07:30 +0000 (UTC)
X-FDA: 84987408660.17.84FFF8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9341E100013
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:07:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K6MJtEwI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784034448;
	b=vG4PpHs9EtRWaJaTYhVEPJ6kc/kcKdqCjy/+Ux9G3aieZ76gG4kL73tTLxqwpFVhVZxraA
	mXk1YwEVKGJLvzI9nfYprLNvLAV308aE5Lg74XvPicZFMnfe1zesQcuGQLZJAMJSp/gcJn
	JWxcNruJQ1t4jKtZGoHD4RRLIGERBJ0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K6MJtEwI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784034448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EsVxz/W6sGxLsQuzAI42WMd1nMcUj94TONJ6LOFJRiY=;
	b=Nn0geani6cSzVLssOwwBWb4UqilCgZqPzvoaX7YK/TTjMLHyVx3cGzcQ+AEPXX9n6G9z1Q
	eQtA6MsFuXSd79gZgxyQB6FlB6cmKhZzgIfoOoqm+aBOASQutBZ08oUG7CSZkza6ft3Ixh
	0/a8L+9t5okOBm6SC/sgmBNDqyT/8sQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11ED1601ED;
	Tue, 14 Jul 2026 13:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B418F1F000E9;
	Tue, 14 Jul 2026 13:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784034447;
	bh=EsVxz/W6sGxLsQuzAI42WMd1nMcUj94TONJ6LOFJRiY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K6MJtEwIr80Vjjfi32H5DQ31sRLKgQosXD1UrxyuZO+SDKO/RhiT/VC7UX+MU8AxR
	 lwgtzDgRd40mzR/RL4Z8eooQuLa05SSfBzUeIAzV4sm/M63zqJxKg4Wvw4NB0Y3G6u
	 HMb/8jYYdcqK7RTOgPIgz5bXoodHytI+8YEFF9V3RZr7jlbKU2rUb5ifin/nl32jK/
	 bTSK9HurDgqm0M6CjmLowA/m5DhS+R0cTJHcGQzYVu8lazBPAK7qkWJX9nb32WgFeD
	 LJ9RNljwbDEXG6khInQe4BoU44os+kkARioKRuaLhMT+YzIw5i6i1Q5L2h5EKVmJ7a
	 /gKp1ESYlOTOg==
Message-ID: <4f36c923-fe3e-43da-b635-b7b752748958@kernel.org>
Date: Tue, 14 Jul 2026 15:07:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/9] mm: use enum migrate_reason instead of int for
 migration reason parameters
To: Ye Liu <ye.liu@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260714015117.78351-1-ye.liu@linux.dev>
 <20260714015117.78351-4-ye.liu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260714015117.78351-4-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9341E100013
X-Rspam-User: 
X-Stat-Signature: 3gu3h8311qqiu9qf6ywdkxxzok5s33pc
X-Rspamd-Server: rspam03
X-HE-Tag: 1784034448-114983
X-HE-Meta: U2FsdGVkX1+GwtqUjBQDesU/JHTv3I0XNAPYQ1xZkQ10N2wu+nJgswwy1eftQphWstGqMCh1QM+f1R8ImRWst2JUcItp9+WjXkxLDJ0euKDOjgehxrlcJpZSal1AJH+ncqXteAJOeQL/uonqaN9CRnKNsSu2kek600J+LN1wblFLpRhyFgLQ/TCuSat9TO6unr4DrLU4JK1et0OnBux/oZPPC+wHqhYVY+qBTcww1UpR+K7qTnTnUejLAco/6gS7M3R/XlRF/1kLMsOQ4zry2EKVC/K1mgLHvrIVm/qb6lF3EijpNMT2viqjI7ZfbdvIvlWQs5j+GokYzyMemIx4ivV9hTkJbtVdF78uD6sj5qR89ZpSdHr3L0UWrD/TUqCvgUilQi9jrpPtj568aU1jUZ5lU0TnIsl5aBaGLRgUhyuTiX8FblSBjqvjFKwUxwqS0ajEpC6WO6LoYkNiSiPHICMJ9FDmEf1a78a2U1JxSsmDFWjdv+IYtrlJTs5pmqsWX1iFKVMpR2ven0YEvYa3Sl7NpQ6vQotE7IkE4WMczkpUZuCNQNfSGPoRBkA3/byoBowxP9GwuWqi+ePjVY+qomqMzbFuOpOEP9FowanXjCOSl87PS0uUButWOE5IDbizYQI1YMEMpi5lnnLiGe8r3dw8dOqkFJW+T3tZAmRuLJuVFpkOu6rFkUS0V3ZcSLqbopPqVYzkTHnm5Vs8BdYiWq4P5gSW1mmXmREPLFxk80esXRo/fOd1N8eVan6RQ0wWiNKigqBp8BoZit9qyPSY7rucuPp90uDbgIqFl399XnqT7opoUB0dCnV9NI/auWxf2Ju5k1ghKe17X0JH5JbcbWUVG3RyYK0dZqMiskcrpb4ekjswb0/MdHwXOTG7uryaeYmqJwH07sGB1jtLzMqu3iufCOZMlcfvrUbYOx8O8KriHsIKVw9wWM5a+S7tGFajxKa5pOAzfbYtuJBsmMs
 Nz/yGlGO
 Znq7kdsppGAE567NqXR3VwR9juOOt7yF66u+6krpR5dr7h0wAY2WvoQq5mctWZ4kXpPI7DdfIHhrguwP2OSSJ9KgFVfQ3e88e9oYaTVUEU1BJATG9KOZ2eojv1ElydEi6QtUUkvtb+RgclvIiPcSas5ONC2CwUtXzEhE9TBtdh67BifvcFh8XUtMWZrmOVvW2uSJJaaOqBmoQkNktjIsyiNJ4pSnXTJUPZHELd1dC1rNG/vKiu+zlRXMxIbLY0qnKs8bpAOrNuuXBILfBVVHAu46D5Buh+rKCgaGto1mqvubVcjTJ2BIA8cUoNKqrkyV1adxuqu42JpD0o/rbs9flq6YV9I/gqjM0MUcxyR2iK7EjGZ3RUWiCp6wYcE3iEDUud0DKqryqe1VwtyjiFy8Wg6Pbhh5CxNwd3+Nx81OimipHQcc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 03:51, Ye Liu wrote:
> Replace all 'int reason' function parameters that carry migrate_reason
> values with the proper 'enum migrate_reason' type.  This makes the
> intent explicit and leverages compiler type checking.  The affected
> subsystems are:
> 
>   - page_owner: __folio_set_owner_migrate_reason(),
>                 folio_set_owner_migrate_reason()
>   - migrate: migrate_pages(), migrate_pages_sync(),
>              migrate_pages_batch(), migrate_folios_move(),
>              migrate_hugetlbs(), unmap_and_move_huge_page()
>   - hugetlb: move_hugetlb_state(), htlb_allow_alloc_fallback()
>   - trace: mm_migrate_pages and mm_migrate_pages_start events
> 
> The 'short last_migrate_reason' struct field and internal helper
> parameter in page_owner are intentionally left as 'short' since they
> store per-page metadata where size matters.
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

