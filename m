Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE9D606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q6fg1hE6
Received: by kanga.kvack.org (Postfix)
	id F31746B05B5; Thu, 12 Nov 2026 07:11:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE23B6B05B8; Thu, 12 Nov 2026 07:11:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1946B05BC; Thu, 12 Nov 2026 07:11:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4D086B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:11:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1FCC1A05AA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:11:57 +0000 (UTC)
X-FDA: 85426353474.25.B1AA4C7
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id CF7584000E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:11:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Q6fg1hE6;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794485515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xc3dkm2FkTj3bfcx1hRbhfim8mfu2/061yvWmQIUcIs=;
	b=FwBU/YHdemJ7S6ndXMkUzKY5TrARBC4KOvpUO4SjDhEIXfBqOmsTTO8+gMLqFEtsBsRxei
	mcQNAqqyb+rIgY/M0kuie9D+IIznKwM+8NMermOGEAN2+OVW9aP6wq8fxESbPod0n8Yhgr
	ZKm0vJQGarY5Qi/eub8K0PPni8jryDA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Q6fg1hE6;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794485515;
	b=NZoSQNBk7RZKyzu5vkQHgOB2FNdnMim4D0/StbhFWhpu+zOzt5QNdsI92InWYTFjVqE1ZH
	3TrtOMKGUUq5tksigGp0DBQHqWDzeVprMpq/DboN2l+NALpeCQUkTZwmlEf70jSxY0sTzT
	J3crm9U9JQVK84r9HAT1qBP9S5RafCA=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so1192478a12.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794485514; x=1795090314; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xc3dkm2FkTj3bfcx1hRbhfim8mfu2/061yvWmQIUcIs=;
        b=Q6fg1hE6rbolAzkfJUgTrh9cS989aTIHrCgK8rkiDP8o4DeyA+yFEIPJ0uF6YOsyE7
         FXTN8LeHoBPdhY0q0HB7X6HObBII1gwHta1LZ4THMQ4JVOq8mvqVi7O42wUaCx2jS0Ss
         nvSJjdsFkcCVt2d5zTwm/fNqFMAy6OJX7Mpq/mVzeBkuJPmTY2I5SeK5L1aFsTGC9Cou
         aC5SJBhz6neUTsXt3FaEaFRW8RAdEjWe6TfLqzlrsvcPtyV87BYVz4znhkqSCnrFKj/o
         VYl/vjTBDHkKjNjA37vCcYW8o1+Vb0aezy1kMIB/927Ax55fWdXlTKtTP4pvT7gBqk0r
         AzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794485514; x=1795090314;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xc3dkm2FkTj3bfcx1hRbhfim8mfu2/061yvWmQIUcIs=;
        b=xbTLigPGELnpd5oDnRUkyaxxtgZtYDJnfLMDZPFcDERqoD5TLnljs4RZjWdSlb1BQX
         QeLtYaIlAY4YolUQC7nxuEK17b/QnfrdQu0xWvO9sT1K09xoIYtX8gykZau9goduTiey
         FJb6FAp6Ln+4gSDjG1+KzdocHZxR3TtSgbugNCAoJXdq1VnIanYuzULTCnieajv7CIaE
         BsNgONBBGYWdGTxo2nLPSawPD+951MtKzsXd76BKV6py5JGTNJCsaM9EDMTzKCqmxlrH
         3fdWg4Eje3wAJFU9a6lJwNUpUZ3P3/75rVYFfbmGsSxnV5kKVldD6bDfreY2+0+TKe+r
         xbcw==
X-Forwarded-Encrypted: i=1; AL+hErGSsOQLhnjbvc78HkaxJZJv/87AGfKCVx36LzCcpUP9tpehy+LTGEJT772W6ucA1DBmM9MYf5SpaA==@kvack.org
X-Gm-Message-State: APuU4Z/jFxrziCV6wdnEKnYvpQgzIBIZlSkkHU333riWvcZgtWqPIpma
	i7cx2bfZi+U8EtjrFJAJk5A4q+m22KqgXsxVCsNVimfUsznDG1dVv0se
X-Gm-Gg: AYBFou3sxuRJkSyOwQYvxHO5zpRaJBQ2QQlM6pC58gIOm8kbvr3Tg7Esubjfds1SfdM
	ppP47LLC3XETtfFmiayC40r2SkkNsBy9p8AAZrg0GO1YbIOWmmv4vD/eKEbi1JPzrfVK7yFVuEm
	gUmGGBSKJsJdGo2W9uInt/J5FjHWnGqJEYdNoDQiOTW3sg6Nc+ppuZnPcQAnVe9qBZS3T5EfrEq
	I4wdqsD1wd579M2x5YGysK1I7AgtJo5BbnR+1DvNC2x9smwFT4N3eA6qD4x9DSr59ftHcj366ZE
	5RN0f7Tln5+Gdr6TZ+eqjzF9yCZObQOq8uXPezoKIS6RfvRH5UIprFqzVVtWPUr1zYVBdFyGlpk
	r7aUsMt4zw4eYohFmV6wypx0OCKVCg2l/WYBD5NRQwgncFTbaJHsGGmvJ/uBtkFFzIaGvzIdfIJ
	ETugqAnFQfNvczm7SRJkGpcQAbFTcK3yUp1ccGq4btsRM/kCXa471wtGKecAuE+rzTY82CnbNKj
	9aKsEYjQp10B6WKnu+n1kt0AhlRKcLEu3hEdjNOprqWnGjVmQubr/XNyuBqdxQtnWkJGQ==
X-Received: by 2002:a05:6402:450a:b0:6b5:875a:c2a0 with SMTP id 4fb4d7f45d1cf-6b7775eb13cmr3884877a12.24.1794485514349;
        Thu, 12 Nov 2026 04:11:54 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7834cdc23sm1610428a12.12.2026.11.12.04.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:11:53 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 12 Nov 2026 13:11:51 +0100
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v4 4/9] mm/vmalloc: BUG_ON() on an unaligned range in
 vmap_pages_range_noflush_walk()
Message-ID: <avWtB-nWZUwLdQdP@milan>
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-5-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110112546.261415-5-hao.ge@linux.dev>
X-Stat-Signature: 6jri8pm5ym6hftwjzd8s5c7xm4j4r37u
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CF7584000E
X-HE-Tag: 1794485515-813299
X-HE-Meta: U2FsdGVkX18MaXSrK6ugTRuvZ5IDsc+qOQCcYGBrcAHz+2cTwRqc4hExQP7xAiw4wsgkecCzGIbLAZ2P6FUket6YUOnyJ+2zs5ggN+tFUWtYCvIfFroDq49h63edO1hKntqgHSb1BdwUznZnDs0zlZdVB8BWHD6nYAHaOraqP7OXOBtVY/C5T7A+o7a02Jlh0YwBVA8bsnF7AiJEG3fnyl+kdTWxhN3FUZddpBD9bPqPb4k5f5fzKDl93WiHyH+uQPvu+7EMsMxMNYrFcPJA+LnscXJVmd2GHicm9e8fVtAleHsBpqrQX7IUMB/8w41J0pmAsBDgW7UYQvbHaPOBphEgG+RYbLBPUdZVF0hU8QndECST3c/5wcxliaXd60VtanTBhZkaYWzNfIglVZRCgf/IQBCG8Ex7d+0uzucawHjo+waIqRK/REVr+guM7AFZ4LaxHUm/3tFvmoQ093wqb1iR/7ZCafjhABLYhBegIjdmM6abDD2uUApO7riRBJjC7F2cmD5imx+kEBoxMLcR7jJVWKbuzGNcahWX8kpxXDdYzwJiTRQ+79U5EtHtJheVpkjAle3BeNpn2H+iemaSeIZ6OCjmBnCQjL00IMPdS91LD++q7oMcW7RyVdUiaezQYCMECj7FubvCFMGs/wBZ3MGr4QKdfVyRCWROs83oL7Y7HxnrqXEKV1JQyEIr1MUv98BfJRa+mDRLMQxTc1VTV9SzYooFvi69YpOjb0pILxbN4TZ1Z3uCIf5WDC8y+uAP/K1UFTr4DMqZqEKpF0uVpQHJwFJAyPgBCNcaQlTU1eoyQs61cejAmG78eTLe7B1k6bKeF1AaSJAv8bJAv/VrH/JFRKYoshYiKyU3clLE6PVEwIPooIJiRo4RWG1465eOSeWoEllOC2v52GMtWksdmBn17nSeSQisEYIqC6MO5OZGjjpCszJtLI8xtFSMUob6xULnE30gC2VDaJT1X/4
 xsJXr9fW
 c3z3PdJ9sebkgO/XG5wI+JvSRpCSg7DT/MI/nMfG7LEYNRR6x6JwfqGP4zC4ZsQjqnxi8lzKQ/rNYRlufa3Uisf5yT2jzO7xl8K3f6CwNOkfaI2RmbPmWQ4goF7at7gT97HVE9wmqeVqxZjjh1VEEdj3uRDbguss1KBFTynQSJJX8W39VgAwCfpAqKUk2jJ7Uxu2gZdP8aw7X9RIgzpjzkreVaQdEsQYVbOenwjqrC4igv3j04En9ZLBJ3O0+aXeVzBN5w+tbiglNwtfM+cjNNMMoX2YjAGEsebABqZP4CNDUOV4/nmySCRn1Yg+c19f07au7/40oAJg3Tx9FrTPq8uxxNdhp8t9cFDg43ko+G8ubv41MaEi4q8lVdOQCWOzLB1SVw6J+AO5x4EgbBEWmQ3Xouhw0xUUlnMWZMQcFAXGoHNgEZ7tZcYMBrI4XdvZLGbF759tETJwDZRDLhb3fjp9ybPLwyZq8P9PwopSHaQGwU3jojyNXLOGkFLdHVrt/8SKxwUBjyyZffLFTrD8+bGLyey9LHC9Mk2IMZyFCEKjRKhFYuROZJYUf5ZtbBcdaqXKn9okNS6rlyKDXOXg1QJD7NiToqZZ+XUs61y7Yu0Na6JU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 07:25:41PM +0800, Hao Ge wrote:
> The pte loop of vmap_pages_pte_range() maps whole pages and stops
> only when addr lands exactly on end.  An unaligned end lets addr
> jump over it and the loop keeps mapping into whatever follows the
> range.  An unaligned start maps the page below the range with its
> first pte.  That corruption is impossible to debug afterwards, so
> bug out on addr and end at the entry of
> vmap_pages_range_noflush_walk().
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 27f2674a5556..86fbb1d2b27a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -698,6 +698,8 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
>  	pgtbl_mod_mask mask = 0;
>  
>  	BUG_ON(addr >= end);
> +	BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));
> +
>
But why do we add this? We used to live without it and as far i see
we have not gotten any report about any unaligned addresses un-maping.

The vmap allocator grantees that va->va_start/end have to be page
aligned.

--
Uladzislau Rezki

