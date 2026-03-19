Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 718401091926
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 21:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4806B008A; Thu, 19 Mar 2026 17:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F1A6B0095; Thu, 19 Mar 2026 17:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61CC06B009F; Thu, 19 Mar 2026 17:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49B026B008A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:33:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD8E78C39A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:33:55 +0000 (UTC)
X-FDA: 84564115230.25.0589734
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 030C34000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:33:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lVT0r2zZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773956034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rA37h1H+t+5MIHYmWOwMvW7jtN1zx/LGYLLRVu2/OGI=;
	b=tz7wvH426rZUQK8+mH1OBb6wT7+aCA6jymSrAIQgKZznt3ajVbVz/1PgwyjpoqI7OX4jeE
	QSS3MR8yOmX2xE0WXQ92YMkMXrZfqGsI6EOVlJCNEv3xlrpiAqYLc6hbTTOI/HZUZll+DX
	qIfX0Gr7Il72wFMFydQ7xvt/+kuqwpg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lVT0r2zZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773956034; a=rsa-sha256;
	cv=none;
	b=pjV0pOy0KmZikJWRkNj0lughKU1q9qWd78WVFqrEqCthrTE+2HY2h/g0s5CMDjYw+QSX4I
	SyW+gfi85n0QE5tPMnkJbpOQPhpc3JuUKAGy4Rq7vjhzQthw5FBV1/eutWEAbbFxCLtV40
	q2L3V2qXaxsFWXyv4/TvlXPpQhvouKE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DD8C600AD;
	Thu, 19 Mar 2026 21:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DB1C2BC9E;
	Thu, 19 Mar 2026 21:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773956033;
	bh=xN4d73AFx0YGytHZojK+cFhok8Wstr1JBl9qe4KChuw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lVT0r2zZN4LrARNdQvbxRMTMKYCbEjQCMNGTjK/n1LEPZF7VQvpEGzqTAtIKmAPoJ
	 ILU8nDzynbJ2RZ90zbAsd8btfuoGQxvurU4npry0Z5WCrqxQImtUYIVzCLpNiASASY
	 kYrzOTwRP3GkTfSz1yDrVvxRfxdpE5zpUUueuN2YbA3sxbj2bGDXiTVqfoAIfqfOyR
	 xCenGxPYqrusjm6ohzrlzqGvYAehc9f3jYf8ajcz0gOW3ahU0wSWG8O7rI44bKJI/P
	 K9XGcQbs1bXPNsuvQeLHhT3tv6Deyx5pRpjudoUs5NzBBVExFAiI7MD2zFmg/FK62C
	 4j3xTdPpE0LHQ==
Message-ID: <f0ccf41d-16ca-404a-bb84-fe038bcfe0b4@kernel.org>
Date: Thu, 19 Mar 2026 22:33:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm/mprotect: move softleaf code out of the main
 function
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-3-pfalcato@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260319183108.1105090-3-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 030C34000E
X-Stat-Signature: rm3ddpy6kxpnoj3jd58qkoyi5jgid6ej
X-Rspam-User: 
X-HE-Tag: 1773956033-646115
X-HE-Meta: U2FsdGVkX19Fsjfsh+U2+jz07rCoSG7NlGtOl/faK74aiGFnEByt/X/BKJqgR/WQtrcURlARXq2gUnoa5aONUyEhjbK9DiRQpD3p2GF9xApsWkKJwTzV9MA9i8ZHQs3/t2oYnqUd4W8n8HMKEXMzOatMAziCu3vyqRtYMA0hUgTwxoCEHcYB1nmCZe8+ipUba5uwpconcS+K6+9OcbEE2x8xB71SJQpPyFHtvdqYMUmx7m5KFWFw+ts6LjsPkozBEV+xeoGh6SDT+v1Te3ZoKspaok7nXFpSx2y30Gw2+ApCX9QHBR9ksl4lY7MwNAwLTfgen2wG5PI2E9wvJ49t3mfNWXlpv9BGPT4yiP6XtBuMewst8BcHBUfjslUODqip54V93knTtex0RXMaAj/wWamjBGFFitjktOoT2F7P/N58+npFr6u3vDopnSxdjk1fpdd7AeUiHy2Sxnz4jzqB83CuuhpNl+damYLp94rOWYjR7n1BW8j6NeSXa076QEL7EtDocbB74xlQHxR8Xf4RRRNrtLR1Bq2BGBLYt5B7oEWt2dKzdGrx0vj/DCFBx4xqcVgIi9PZCwcWPulwrpZVs6ZazvucLwojG701zdG3uYAnGvf+VSiVwkq4zZ3iqx01H25vunzutIoE1d+dJKBJzm8NaOPj9svLmEPhOwi9rI/KXPtm2A7XZuxv2w6WtLKsuDLazHemUzRl8p94Ij3WCETqKNETK7UYdFG0tyLsbn3df3nDMaODSVT39F/e5vLm/xBXsOSdwpYzNmG2TjThiKexQsMg0e11h5MpHa243KXAMxVpoVenOA/4A8+srl0w8GfZrbIyzzUdzjOQrtOEwcT1K7ZsPSWhS4vqvtbrQuoHKnGIdslSqyaJML0hz9crym0melZf4ZOxVgpwzihg0AnemKnOzsW196Eet4KL9E4FldUTzDRA1zlv2EUXS2XWPqdaYkCL9XMHrhe77+E
 2z+uCKIg
 09FiB9skDwMcbAQTcef35nmv0k9F8BJNx5Oo4HP4j1cTt1NGIUgS6fJwGShu3P2DpFUIl8IuzfgICYfdkenzvIvdKuPxTpQCULVaOqAhDlyiujpTewucnKKs5sFF2ifrvVfnLI8/UQX4H9rWwmd4i2757ZZ5MnEWvdQro5zQ3PNtdRrnSeEwTMvn6uaptGs4LfRkKct8kqDKiwVzFwb/fFoAUjdcHT65WubIUckiNJbtPqcgifmfHq4kiTNyv9v1d0WIEra1n80NeGplhAuZ9C8/ZHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 19:31, Pedro Falcato wrote:
> Move softleaf change_pte_range code into a separate function. This makes
> the change_pte_range() function (or where it inlines) a good bit
> smaller. Plus it lessens cognitive load when reading through the
> function.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  mm/mprotect.c | 128 +++++++++++++++++++++++++++-----------------------
>  1 file changed, 68 insertions(+), 60 deletions(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 1bd0d4aa07c2..8d4fa38a8a26 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -211,6 +211,73 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
>  	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
>  }
>  
> +static noinline long change_pte_softleaf(struct vm_area_struct *vma,

Why the noinline? This sounds like something that works good on some
CPUs and bad on others, no?

I like the cleanup, but the noinline really is odd.

> +	unsigned long addr, pte_t *pte, pte_t oldpte, unsigned long cp_flags)

I'd call that "change_softleaf_pte"

> +{
> +	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
> +	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;

both can be const.

> +	softleaf_t entry = softleaf_from_pte(oldpte);
> +	pte_t newpte;
> +

[...]

-- 
Cheers,

David

