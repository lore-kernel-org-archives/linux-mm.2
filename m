Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 910A0C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839306B008A; Mon, 29 Jun 2026 06:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 810246B0092; Mon, 29 Jun 2026 06:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D5C6B0093; Mon, 29 Jun 2026 06:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 547176B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:23:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D88CF8FC14
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:23:39 +0000 (UTC)
X-FDA: 84932563758.20.6BBB4A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5595414000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:23:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f3yZOVsI;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782728618;
	b=xYsemuhmceL6OT9nltMaNQxWF3d7A4lGyn9/NJR5xVth9xHQcyw1QWqFezFqiDOY2fDK07
	UkHi2vbeM3K0hxZEDXlQBkuQMMyInrJmQKAEhP2rZVL8s8xQ0HwnMnd1daEP85Exa617+S
	K2PDDSHptHDk6DI3svBCFFsApsS76rI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782728618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMPIAqcNhKhzIHxMXNRypzSpgxgq+4eKBgqLmwcn81A=;
	b=enmYOheEY2XbyjM3CL5u85lpqxkDb/X1MNn8e7hZGW13YCtOqhGQv9dkAz7gXRvttVOdcL
	hWGjd6OCKztZMtAJr5TMog5LiC0UU0bBcX7ypGNSKEJjrOJgnZan4o9/y1IGDzQlPQvcbx
	PLaB6G43IRq8zDWkmvFknr6B9XrtvVQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f3yZOVsI;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB140600AA;
	Mon, 29 Jun 2026 10:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC401F000E9;
	Mon, 29 Jun 2026 10:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782728617;
	bh=oMPIAqcNhKhzIHxMXNRypzSpgxgq+4eKBgqLmwcn81A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f3yZOVsIgo2uyjw3Y0zF2phd3/OPl12+Mu1OToptSS/rJFN8aeTuIiuI1KCFZuPpn
	 kWopVQL6l8c1i4sSAGYQXF8c63uY8pktl+imRVn/nCaWld6pncKfKBN9QwQWOgGMuR
	 PRAfNyysATJ/siBtDK49FHkllPPUPCFiS6qvZ+xh79EQE8U1uUPjI9PvsJPO0TSFw9
	 bPDWqD1peRxBUjoYnZgPOF5wj13KSzwL8/maCN4anq9eiUMTlFMOyPRksYtc9PrN93
	 DFeXRYMMR+fS82Gvr87yIslcM7RD8dPoz79AB8DW7Xk1yQZPi064FW9oDyxcH9PBBo
	 iCDTg2Y5p5hew==
Date: Mon, 29 Jun 2026 11:23:26 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Xuewen Wang <wangxuewen@kylinos.cn>, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: annotate data-race in cpu_needs_drain()
Message-ID: <akJHit8BV-hWRXYk@lucifer>
References: <20260626053700.2036899-1-wangxuewen@kylinos.cn>
 <04ea3e05-5b83-4c2d-8759-67c544a7b484@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04ea3e05-5b83-4c2d-8759-67c544a7b484@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5595414000B
X-Stat-Signature: 3tqyxbmt7991yqusm151xbgxgf18jxa3
X-HE-Tag: 1782728618-350548
X-HE-Meta: U2FsdGVkX18NiUIeQs+LutSK1wTderi773WV5uVXbso3EfvKyJSc1Uubalvl+1OoA8tPaDG7860I1e2cBwYSNx6pJw0RdvEBlmBFgFJuXvdt3bFuFMznDSeaqqxtdTYRw5ly65Hy5tJ/e1SLxfbAlz+dji+GU0IIVs0CBFMWegKXCrs46GgENtzd1BJWp4opsn6+VZnpuK3mqU4C0yVRO4bJQ6QawBvedYPwDU+g1RyIgYQjbgI6QQjyL7UGCUazhICDm+Ojj3WJNSQUqMZ+FR302a/sv0OomlDJDKkLfdpVtHta3Wg+pAz5R+vJu6EBfIlpgxw2rJBC778Jf5d26be8c+XSSCNOwfSlF5hY5DJh3gYzWd69C44shT4UboegyZZf2VtRdcs3tltCdfHBDvTZnTw3grTTamCdC7vZL+wln2KaMLI5CMzPbT7fktj9FDAnRNtj3EL1UlTDCuXkQne9Q3riU+v+Yi7yprh9iwdbcpD3eM/tFvk8lfLZ2cZQy7XlcARA3ixEo395STTpRSfLeSm8cua3i/kTzz3tPJkn3YjYcXI4YLz4cceiVARu8RrcfhhC13Q6/immejyTZ61Z6IsgHKgOLa8cHJDLjxr47J+/hWBkMSY/iiT+grkPVxozpVrkCMwulG9evQUgewxyYaRNOr7gIQlLoj7ZH75LPOnK9j0WXKIKMiPBa9eyYFKEMdRlVUHeiPumxO+7rMAM7XpMCQjcsgaa65IJzEWxge1p7LH0a1N0R2XOIVL6Ze+6zte3HEH43TAeijTZEOLHp11PWtqV04KzRePzPt/5B9jPo99lpZ6QebSdKqIvNdnLMARZZ1454ZqWwME7Gers35Kb2KtI6sp4vqT+Rv+WYzhXYhpWVSt1zWDjkIQAGNoLwXStFHscN06z8S/QV1A2jodmz6le6rm31t0ALkM6YxCTuZwLZxoop+dbrPJTd/j9rQxCNiTENOACB8U
 IOG1fOF3
 QoYwJXU61KJwh7pjBJrlY6K7strc1qHEidMzNOZPJDZYKEYOpzyHxKpvyLJ3/5sBBgxC1wsquB5GoZaV3W/yI4e6Jrby2emsr6lOFgUKSP9QIAeZ93QfGIwllf08wtbx+7hI7mtW3Tdp4mT2yd3c+0WgzyHtK6Uu9yhq1H3xwmv4ZOx67VnmsZoY1C2Q8lLPVb2zHS/wsKtx4UNc3DXucdYIcHRtU56ey8OJ+tBH82ndrC0n8muqw0EChYXZCkmpCQbW559TJ/RoFt3RLfifkc06NQ9OpPgpTCJm4L2UsP/CzTLLt8H9zfcbVRrrhm6IhkznB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 10:17:14AM +0200, David Hildenbrand (Arm) wrote:
> On 6/26/26 07:37, Xuewen Wang wrote:
> > KCSAN reports a data-race when cpu_needs_drain() reads another CPU's
> > per-cpu folio_batch->nr without locking, while the owning CPU writes
> > to it via folio_batch_add().
> >
> > Reading a slightly stale value is harmless -- cpu_needs_drain() only
> > decides whether to schedule a drain, and the next iteration of
> > __lru_add_drain_all() will re-check. Use data_race() to annotate
> > the intentional race.
> >
> > Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
> > ---
> > Changes in v3:
> > - Wrap the entire || expression in a single data_race() instead of wrapping
> >   each folio_batch_count() call individually, as suggested by Pedro and Lorenzo.
> >   This is equally effective and more readable.
> > - Remove data_race() from need_mlock_drain(), as it is now covered by the data_race()
> >   in cpu_needs_drain().
> > v2:
> >   https://lore.kernel.org/all/20260625065153.1581419-1-wangxuewen@kylinos.cn/
> > v1:
> >   https://lore.kernel.org/all/20260624092606.1083449-1-wangxuewen@kylinos.cn/
> > ---
> >  mm/swap.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 588f50d8f1a8..46ea207e0624 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -828,13 +828,13 @@ static bool cpu_needs_drain(unsigned int cpu)
> >  	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
> >
> >  	/* Check these in order of likelihood that they're not zero */
> > -	return folio_batch_count(&fbatches->lru_add) ||
> > +	return data_race(folio_batch_count(&fbatches->lru_add) ||
> >  		folio_batch_count(&fbatches->lru_move_tail) ||
> >  		folio_batch_count(&fbatches->lru_deactivate_file) ||
> >  		folio_batch_count(&fbatches->lru_deactivate) ||
> >  		folio_batch_count(&fbatches->lru_lazyfree) ||
> >  		folio_batch_count(&fbatches->lru_activate) ||
> > -		need_mlock_drain(cpu) ||
> > +		need_mlock_drain(cpu)) ||
>
> The indentation is a bit suboptimal now.
>
> Would read nicer as
>
> diff --git a/mm/swap.c b/mm/swap.c
> index 588f50d8f1a8c..5958e6fdd3593 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -828,13 +828,13 @@ static bool cpu_needs_drain(unsigned int cpu)
>         struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
>
>         /* Check these in order of likelihood that they're not zero */
> -       return folio_batch_count(&fbatches->lru_add) ||
> -               folio_batch_count(&fbatches->lru_move_tail) ||
> -               folio_batch_count(&fbatches->lru_deactivate_file) ||
> -               folio_batch_count(&fbatches->lru_deactivate) ||
> -               folio_batch_count(&fbatches->lru_lazyfree) ||
> -               folio_batch_count(&fbatches->lru_activate) ||
> -               need_mlock_drain(cpu) ||
> +       return data_race(folio_batch_count(&fbatches->lru_add) ||
> +                        folio_batch_count(&fbatches->lru_move_tail) ||
> +                        folio_batch_count(&fbatches->lru_deactivate_file) ||
> +                        folio_batch_count(&fbatches->lru_deactivate) ||
> +                        folio_batch_count(&fbatches->lru_lazyfree) ||
> +                        folio_batch_count(&fbatches->lru_activate) ||
> +                        need_mlock_drain(cpu)) ||
>                 has_bh_in_lru(cpu, NULL);

Yeah that works for me.

Andrew - maybe easier if you fix that up? :)

>  }
>
> But I'll let others decide :)
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

