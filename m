Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E1BCCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 08:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785D26B0093; Fri, 22 May 2026 04:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756466B0095; Fri, 22 May 2026 04:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693646B0096; Fri, 22 May 2026 04:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD886B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:57:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B2BB1C1DB7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:57:02 +0000 (UTC)
X-FDA: 84794451084.22.5BAADBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 730B320007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:57:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xzw3XKT2;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779440220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wl++rc7qAneafJ55JR13bw6NqLW3bgI2BMfioSnBIUI=;
	b=fWTau9RYWSfzbHu8sNuKbYqy8cMIP2jIw9b5t+cu9uP9YukkbMumxhaIODaxtv/NV2XKfB
	kkUx+aMILxGM0o2O7LUMdmipSHLMnXahSdzZNzYi5pJhqxCUVFMnvE9UhMQBM96nQH2bOE
	yqVzNdy1ikPZUzCGVXHEx9TKnAI147g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xzw3XKT2;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779440220; a=rsa-sha256;
	cv=none;
	b=XtcdvGlHYc11vWY1YC4kJMBkbN7uTcBAL7wBTFWtWEyvjl9KMHFef272qDsLzDSQPBQSk8
	GW0CzmElySblDo9n/eDKbnfolmc/0/NnVAmE6gM0e2M+7lFGzmDVFRsBIs+5PSg9pNw4qa
	MImz8EsM1+jM+Uul2PDDxvFXiPs8qpU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C87760172;
	Fri, 22 May 2026 08:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE841F000E9;
	Fri, 22 May 2026 08:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779440217;
	bh=wl++rc7qAneafJ55JR13bw6NqLW3bgI2BMfioSnBIUI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Xzw3XKT290Py6aKFLaCyb+YtmMQyWpaVPO9XgJ7bE6GJUgCTks8F0DUme/d70g/dQ
	 XbUduXE/Rw6sG4Pfc+uNAphK/p6relnp5bpiAzopwpIBkwF25RtkgZZFv3Pz5XIEUo
	 tf8XXrop3wkF8Z33nSOF90NCRnW/sFvO0DU5oQ7VQlA4/iGMVL4IJ4d4mbYiUzEXyZ
	 1HxRcuXKUspUhJPO610s2I/i1CD4HYwGhbQv8sjoieEKEw7K+R82p2GiughBmbA8VH
	 D842kFI70s6DcKhblCH5ynn7yAaSP2Mg1RYugYq7KT0O0oTtcWihMPaKsTUMNaiqds
	 pOqA3fOtBt3nA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 13/69] mm/hugetlb: Refactor early boot gigantic
 hugepage allocation
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Michael Ellerman <mpe@ellerman.id.au>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
 Ackerley Tng <ackerleytng@google.com>, 
 Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com, 
 joao.m.martins@oracle.com, linux-mm@kvack.org, 
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260513130542.35604-14-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-14-songmuchun@bytedance.com>
Date: Fri, 22 May 2026 11:56:36 +0300
Message-Id: <177944019668.3663073.6529634450029926963.b4-review@b4>
X-Mailer: b4 0.15.2
X-Stat-Signature: upyaa3gbie3c6jwkir1wr8wo58awunh9
X-Rspamd-Queue-Id: 730B320007
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779440220-189564
X-HE-Meta: U2FsdGVkX1/1fP1sL+0NBQ5JQWyi8qnTJaE2I1eD7qm5AVfn7nmE1HFVGlThx7DlTgtkI6gyFJXV3uTgEIjNZfbQF3bYsKU2UmFIjfvsIeiwDBW1XtGrbQXUHyWD12FZSJXeXmoGmOojUufU9P39RH7r3v2GX20eSAO/EqX7wzUv4grY9dIyhPwrxEKypYlM5i2s9aDzIFZIsnoPuV/ugL+NRA13REefiuMqC2Jew1ZugZLXNjQA6tzFPpN62QF2ZQn3WFHjULs02Dr0fpoovxLM/Vum0QT6W3kN9setYclzIWQypWztQrzncjrIucYm/Nr+piQtTDHuXwsz2ja8hiyoEh8SfeUvPI1aW7l9U+Z72ZoX/FTb60vM66fll29vVQUh9CjXnDg9Fm6IrZDT7yhikMIZDi5jYJOGdrBRx1JCqQKbN4Q7utw+qJiwOG0upk/R5Q9HMjkiZGuUCb2giY8/cMLo/KvyRpsB5O/l79zrpYHmZlqVoIknNxllSON7pOe2/uzNvuprVipPIZdkvN3xBy1RRGRp7r054Nl/zoL/mUsGexPZ4kb/vfXFEeOHef8uFp2Q+p4LUPFp7SrECkjJjYaMlvbAtNZaVvMntGuvALEQlOdj5mmayPFq9oUPSuTFtsYfr9WddU5ryJGZtvqwBSyXCr1qpEIjnW5mJep0El+lLL9PE/bSq0LXW7YKZB4RzdYtrsL2Z57aOswVnLaNNV4ve5YsHC/exlWsBkwGCvZ+rAm+qT2usDfywJaVCBp4Wqfqe9ArMcSyf6PGIzoND0DDaI8MdbxGoNH83PTUOYdc3jyNqo6t5QgfZpbcwRN9LLDkZwq6nv3hSUzeYsz+JNOReZP1TeBD1da6ZumYZjS0BUvqZYpUS1yXfSC+YMlGO7frEAUSLECclWf16h/dsDlFa/E219dPwB6qo0y1fmrIc2HQT2sLx5cORj+egEmdzMijx2gpNnZqo5x
 4DH/hNzi
 5Hnj5y4mZ0BT5DkozenBtEkwfZRXcGadQqPH7eglhjygfvQWpezn+fQMi20lEwP0d0bTP+pnqtIw5WBk8xsdX+UlURoUFpDJ7seFZF9HdZswAPG+9+5T91Da4zoDpnixm8ObW3JgtMkWthDruK8SwNOjSWI+S/S1XerAQ6q94x9gEREq16n3dXj9bSLOZMZH0bL2QUgQZIKNSFXOADBacdyQx1IiQv2Ce+iEdSYJF3IAFFlpcsIzHi6FlBb3Dy7j2MxXgYhFXBXgUsaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 21:04:41 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
> index 558fafb82b8a..ff8c5ec831bb 100644
> --- a/arch/powerpc/mm/hugetlbpage.c
> +++ b/arch/powerpc/mm/hugetlbpage.c
> @@ -104,17 +104,14 @@ void __init pseries_add_gpage(u64 addr, u64 page_size, unsigned long number_of_p
>  	}
>  }
>  
> -static int __init pseries_alloc_bootmem_huge_page(struct hstate *hstate)
> +static __init void *pseries_alloc_bootmem_huge_page(struct hstate *hstate)
>  {
>  	struct huge_bootmem_page *m;

This can be void *m and powerpc code does not need to know about struct
huge_bootmem_page at all and its declaration can be moved out of
include/linux

Other than that

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


