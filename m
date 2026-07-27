Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 498D8C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 10:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0648D6B00AE; Mon, 27 Jul 2026 06:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0157E6B00B0; Mon, 27 Jul 2026 06:41:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46A56B00B1; Mon, 27 Jul 2026 06:41:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C06856B00AE
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:41:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4231F1406C7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:41:03 +0000 (UTC)
X-FDA: 85034214006.23.D0FC8CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9684B1C0010
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:41:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mMrJaNc5;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785148861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txiq8QrTyyhkb9nTEmIJGHpjEn/LEuQF6NB5SHAzZCs=;
	b=bZBegYSF1vtEhe+eEtuecUW0QjfqOUFTRQLb65TgB3QMrmmao5lxpTrwUBSIfZ95xmiLVe
	q+XbAGqzRxYLKavX7MT5qkvYjURXbm2aY+8tGT4iMWbu3FrZX358AjNkcLj9JBpeA8w4cK
	/wTRNJQObroq5bgQeVSPW5Kz9CkIF9U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mMrJaNc5;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785148861;
	b=bfG7owVWGB+N/3qU4HeTKjavJCtmIap7Dv+m5nW2Y6nDupTe9rbapNnYxTiyW6a5kHpH+x
	xdkSLbktgnw9ay4TFToY9hdIGGFslsC9utqT8NgIOsAEz6S88rWxjy+kA+I+pFURkpbCVw
	jpic8jupfQAzjGxY10fWjOQUn+QzjbM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0ADFF601DE;
	Mon, 27 Jul 2026 10:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10AA1F000E9;
	Mon, 27 Jul 2026 10:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785148860;
	bh=txiq8QrTyyhkb9nTEmIJGHpjEn/LEuQF6NB5SHAzZCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mMrJaNc5obR+wc2RR3OcLKqm69rsLWDFK6bfA0eWocu7BrA8V/7xryW3Mc4B+qLDu
	 5JBLSV2+2ltsQce+tKwdl+ant0L9sGGiPib+5ZK5bFW4bcIA/6sWYWFZp1hBkRFyyn
	 Y9pGVDPepGtxkMwGQQRqnNguuupyxZJv/5xclJ031Z8YPEXspUhGFjblfgbKZzz+or
	 fctc+1T+pHFDbX5Pt6/jgJoa0HwPJQGn/fSDj3v7gSh7QNtENZPryBvvNBO3abVksi
	 xwlOsDswgk/Ze+cwtvwpDpcKss8EjX/G9q5/4cnsfbME6ta+C79dw7q/qaNShFOGxT
	 7/U+IUnvrkDjg==
Date: Mon, 27 Jul 2026 13:40:48 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>, rientjes@google.com,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev,
	"Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
	Patrick Bellasi <derkling@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Nikita Kalyazin <nikita.kalyazin@linux.dev>,
	Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH v3 02/26] mm/secretmem: make use of
 folio_{zap,restore}_direct_map
Message-ID: <amc1sDYWkcriuLm4@kernel.org>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-2-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-2-6f5729aa9832@google.com>
X-Rspamd-Queue-Id: 9684B1C0010
X-Rspam-User: 
X-Stat-Signature: hj7c9eiqqgm1uppadpfryucjndw7fpkd
X-Rspamd-Server: rspam04
X-HE-Tag: 1785148861-613592
X-HE-Meta: U2FsdGVkX1+IUaIftyFNexrhMK+fGKY1POEYxnLdJsUE+GZPIkoytpubSbbHRnh7Tr2dej9F40LrvRiOsK6Wia9jsmqCSmgbnOjbryj6z85T4Riw7p2JJ188bT1+M8J587qK08UvQsvM+gb86gsYVMwtn2TUeYjW0gXkizZl+7iV2CrhoUg7XmWCUdjHYLm1rWbN63tX5t2BwedzE2ceIaMOkqslMegnoRJAvdAatC+GIzDG76wxZa9cvHjZCD9Fq7sOpyYuL0ZjhrPlfHosoB0wur+PHchsiUKP0NPxRZARNaLThXmS71Gf/by3wMrhGXbURUKgrkSDEehbeI3Ee1QW6qCnlJDID1wIEDf/GDwcyXHFfCL9gnJ5LWsl8OVF6ZXCFWgpuc1N6kDhx0NLgrzn+NTj1A4lHCsyV8hf6NO9r5o8ZJJbF1JNXLccvgJ6bBDMSk1TNhfCMuoPcetQ10DiJMVmapbuwRMwYDZwnyadgTCuB0cRJSkQjN8x/WwYbHaH5nSTSX3Nvq/MUKWae1CBfnHoJifTfa6Zfi1RYy/peHF0U1MnafGFqy0fckfidhIsY6Wci1GSgBYW8MYgJNhag6PAh28D+aDhK0b9cT9yta4DibslKxtZXJlOX1Giw8MWReflKONYpt8SIpYZvwfjyq5YcKtiAEX2UE9hixajL2wYTZhON9+dDtjdbWN+W91vonRxTdUO18dX05HxR9zhOxHZRBpUbtgqE+ycqg9+waay/BkuVPphI8enmuyViR4kocLuy2SyEjjIFQcvUOcMEiIPziNST5dceWBiC4ZcJHfLo2ujvMUctFDkshhi4fFLgMpQDeWrcxcYgcY+ssAKl/RIvZmanfcfbRHW2ogs7CH42FSEPJxlTYuzJu+/zcJyTiMNlIYvbfGMzcqjPN+m9ly9t5ApJcxLdSwq+6Esqx0DHpBGjdQB912fDVlo64sbvJYuAoWUdLvcfex
 Mg4yJUlT
 IB/Fc+j6/VRyV19SNV4T5ra8+5O3z5NmCVx3/om+dUxX2UYSQdk088RYkSGa5SS9r5wbIP85LXl2BuETFmrk8spjYD4/2mbWuW9xV8ni33G7PeIFBsWIUiOFaIZ4+LHYXEcxG43/gEWmxgtPF6KxZkT4wWW8I+EmNg63+PCeA/1uxx5IfecslibWNlp3fBoxbulfGSck0TsZcW4ajK452cm9cXNHVnaiMuefL5FD1YXzxz5RsYJRu1XaKmbawaX9EmeL2AogQzVMiLt8PPsGVwI4ldk7n7YLeIuCZBo7V30UMO5Aiv3S46hJq3pSrAbdut3sD6r4N+ZZR9K9rgLUarlBB+KwD2sq/lB5p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:35PM +0000, Brendan Jackman wrote:
> From: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> 
> Replace set_direct_map_*_noflush with newly available
> folio_zap_direct_map calls that take folio's address internally.  A side
> effect is even if filemap_add_folio fails, the TLB is still flushed,
> which is not expected to be on the hot path.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/secretmem.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

-- 
Sincerely yours,
Mike.

