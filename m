Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A64AC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647866B00AC; Wed,  1 Jul 2026 03:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8556B00AD; Wed,  1 Jul 2026 03:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8A46B00AE; Wed,  1 Jul 2026 03:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1466B6B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:53:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BDD812027C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:53:15 +0000 (UTC)
X-FDA: 84939442350.22.C9F8DBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BF453C0003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:53:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZKWT4qxI;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782892393;
	b=Z1w620cspfcZGky77O5fcCOpn0rWGyMs+RZ+kDs/dt0d7PvzTCF+/1bovnwVa50+/kcDJl
	dxVDL7U4K9Sx4U373bURFa5+Ebx6Srr2JioAw8aZK6o0mZtNr6FdPIZDw6R1w1THmPMI5e
	T9dtcKBzjXwddJanfXIDSqbQTtH+uEM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782892393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ZqOs+Ac3N8fel244wP+HYtt2C1Z8hNbICjemOVEohw=;
	b=0CpNy8dcFxiP/I7s0FJ/JV1TEhPazCpZfzWXU+DJlvnj/SBf/5TNVVj7x1XTila36SyIxW
	wO7cmneLKelodKX7Co1FyuOLqLI7OzMLPfC3UVQo503W9DJq3OHWF4ogSHNIPGpkYwbZOZ
	8to62idt09yYQpNwksJi02LB756AVas=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZKWT4qxI;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1177841ADF;
	Wed,  1 Jul 2026 07:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A041D1F000E9;
	Wed,  1 Jul 2026 07:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782892392;
	bh=6ZqOs+Ac3N8fel244wP+HYtt2C1Z8hNbICjemOVEohw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZKWT4qxIbsgyec0zKfgP/6WMd6o+EtZ0asgxpWuiN5zNmmxMmhP9yyJzwLHZNbPN7
	 aEdftbdQMtuSsvql1aux4zSdV10z5yPewaWYqKevJd0tJCC9xKoB6HUVz+nDKHfbXo
	 LbtwljbAzOvQaSpSMwoOlnnASzp12brTDj7/0eUeny6kNX6vmAFfvHtSKPLezCSa9s
	 U+dPJGW5vksj1TTLQqX4j8QnrZ5YKCoVfQK9766ndg0i4hp7gARNYSFBeNgqvQqu7L
	 8uOe/+3ypdS1y5gTQpZ7P4qM1AJSWbNXueY2cDSf3Zpm7Vt9xiAWXypsqVxS8dy6uO
	 wnEomIB1bemrg==
Message-ID: <9ceabeb2-fb48-4ad9-8463-6c7ba16a8644@kernel.org>
Date: Wed, 1 Jul 2026 09:53:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/16] net/funeth: Switch to higher-level allocator API
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Dimitris Michailidis
 <dmichail@fungible.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-12-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260629-alloc-trylock-v3-12-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mspdrgcezmmuo1wgbagt8jdnutujkc17
X-Rspamd-Queue-Id: BF453C0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782892393-642596
X-HE-Meta: U2FsdGVkX18m95tjTwDx50j01e+OA8GdpugES9oeBqWMeVKsyjOWXRaK2aFvuRuoQ6CEZaSQPkbEqeyZEjHmCO+0QRUQxV4NcmbzJXTYnm2Uxhf7CXq/pkgxDDgg4pM8/mfCpPp1kHSVqeIi+zxajuPZN/X1mEMQfswpWnGR7NRxztpdgfEq+VhB7KoBdlaCCTd150vlnrM/peMdU+yGHC5h1pPbSswdUq/0KRWKyOy0QSe2zrkggrf+p7AjXlnyklhgNw+b5KJz07dqBowq4yjCPoErYb4KifRNTryLV9O4nMVx2QD0ZcURtvT+QCDEucJCeLwmoSUAnw+UBqOVQcTK/tNQnEZiO/Dj8ie4n0exRSQF1fUtMCdeQ0cg6QvAQ250jl7Zxoi1JsMu9AcW6kkpWFluPTZGIrpQZBQkvg9w3FBmLkBsKpKXZHs/G2rTNdStQQWukJ7oOb63EkjhcJ67o/d+yO2FAn+jPgxBrI9cs9QGj/VgfSlyPAHENpxN7Dm4Usjow5F33VcYlDUKwgYMjaeeJAOhetPECPdAZwcj3ha1KTUZE4IKo7kebnxHl8Zh9pnRtua1zhexPsBbH0fse/8YYlgenvJZItSVdfHJtyCmFMIoi3quPct0eNr4c1uCeyctAvpy7AUUcvr1HuVVoEpfobhkstWTPQpP5glRQip8lf9/HQJXFDAAiucGvfh8J+g4AOfWk15zJxEINtYZhcDWU63ZTZ3vNSxAgG6EHk+uyTDMefL/LODuY8G/jsR3fl2gC1zMl7I3g19hlQAb5uEW+KpGHT71fpc7KdHH/RsZHK2onU3CeY9zvjOSW031NfBYuG0VJdB/8N2JyNDMJIRyIhix/e5OvU23Vf14w4nqgGJeHjNz0gapzHEvSR/ukeGEDs+jj9tNVNgWiFReI0+lzJJYBKhN7y7rqvT6HcId24IvpoY0ZLdEP4zl3qBYc819vVbBZg/i9Y+
 6Tohlkjv
 2Mo9g8uPTaLi5j46GrNla5aU/LFZO6egycCz+ntjvZuBd7EF2XUzNS+hyZe41Tpu2+DuMW1QgjHuVOzLmblh7KR9V6e6iThWWpXrvGsiDKl7kS+j1B1/ankh2faXQSoq1D2PpQYVQCaf4bXEW6MD5tKVeTVd55VeRrasF9f/BPTWRXMIUEEnuffs4IjbRMhEokvjk1d3CZ2YvRtmvv3cKpGpuphpLt1VDS06JfSxG1binXcRnExgl2RiAiObGhu67SaKPwCHCvrxbgEcc2alBhZiRgPWvVDeCIaV/20UqJ0pguVPZva3ZhUC96/kRFTFJNls9Va3jw/+TMW6Aa2x99yFK0Hp2sdcnfEqBTRJWCyYSPgwqcdvuo02tK2v1j0+LufBoakXFbQP6Tk6jmizxacYedfBOOKQTsuAuPSl29tqaReTfOV5Q/L3vUoHNmrwn/DuqyErxd4Pd51iI7yXZDAoG2q1ZVjFajv3SLJcYgyx1oE8o9tvVad/9zHrO8sOHRjQ/6pfPHW61Kb9m8kPsxhVBct71nsVWae1V0Okp7nBjkiTOPIw7xYad6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:12, Brendan Jackman wrote:
> The difference between __alloc_pages_node() and alloc_pages_node() is
> that the latter allows you to pass NUMA_NO_NODE.
> 
> The former is going away and the latter works fine here so switch over.
> 
> No functional change intended.
> 
> Cc: Dimitris Michailidis <dmichail@fungible.com>
> Cc: Andrew Lunn <andrew+netdev@lunn.ch>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Assisted-by: Gemini:unknown-version
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  drivers/net/ethernet/fungible/funeth/funeth_rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/fungible/funeth/funeth_rx.c b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
> index 7e2584895de39..d7000017ac2bd 100644
> --- a/drivers/net/ethernet/fungible/funeth/funeth_rx.c
> +++ b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
> @@ -103,7 +103,7 @@ static int funeth_alloc_page(struct funeth_rxq *q, struct funeth_rxbuf *rb,
>  	if (cache_get(q, rb))
>  		return 0;
>  
> -	p = __alloc_pages_node(node, gfp | __GFP_NOWARN, 0);
> +	p = alloc_pages_node(node, gfp | __GFP_NOWARN, 0);
>  	if (unlikely(!p))
>  		return -ENOMEM;
>  
> 


