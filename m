Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B483C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 10:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED4B18E0033; Mon, 11 Aug 2025 06:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E868E000A; Mon, 11 Aug 2025 06:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25938E0033; Mon, 11 Aug 2025 06:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDB418E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:20:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5FBA4C0779
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:20:09 +0000 (UTC)
X-FDA: 83764081338.29.93C752E
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6F91840005
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:20:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b="g745/gIx";
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf01.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754907607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDBt9G451b4z8m3hFF/H1Ireg3q2+0iEF/cMTnKNzjI=;
	b=Ez8FBuzoJh4GM8zNyGWebuE01vpL1KFQ03FRFSkWK9yLVX/mvanKYNU11Y/936LH3LvQff
	l0mxVLd7cRq2y3dzALmF9DtNV8F8JBdDFV1B9am1jG9qP6L2gtZDJLCfLBqpS10wy9H84Z
	ZyKGGM03UZ1kbrGI2ycgRisnH0YIuMs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754907607; a=rsa-sha256;
	cv=none;
	b=ijeUO2zneYqyhtlLZOBRqwhsXqnHrPHx/Na3bntvQSKVvqXwJo7UKpMo/Veray3OeEvUGr
	jznbmmXSBkzQhcdIdf+e34huw9NdBoTUCvdcYLIJ3wSSw9QXw2DzK0hGfXdK/L2GqGQoFq
	KZaqN+zVtH1gdUTfEbMT+VLy0AuHOkw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b="g745/gIx";
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf01.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4c0rH42b22z9sjB;
	Mon, 11 Aug 2025 12:20:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754907600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fDBt9G451b4z8m3hFF/H1Ireg3q2+0iEF/cMTnKNzjI=;
	b=g745/gIxsbzXatM5o0BK3LZFVN6WHz3Fg23aj1XXyhxFSZy1cW+pJm2UEOjzgJeffNYz37
	GVM3XBUXUQZ8JW3wbKjUWS/+aivLVvyPnn8Pvu0j+wRyG48R6a5vdqmIlXSsBfC6r/4SgX
	ziz/h9mKmEnMlRZwPfmH9VPESZ2khnyampl+h4lh5/aZ73vmLygtHqGP57JAiTg8JYkzBc
	VlrAh4pSk//WffTSUiQBeih6Onm1GPDJefFzjLwQRL3+sNAsirC0Fz5+8G5hhGYJZr5xcE
	PU9G7R+5WBj4xL0Ed9NB3pSGCKDk7GXeKrnwWYSugCBPnrtb/+POv+xDYeaHug==
Date: Mon, 11 Aug 2025 12:19:51 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, Ritesh Harjani <ritesh.list@gmail.com>, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v3 0/5] add persistent huge zero folio support
Message-ID: <p6ciia5cm5re4paau3tqhcdk3cdjmnwjuc2l5rv6ztb6kcgvyp@2g6ei7okvuw5>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
 <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com>
 <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com>
 <rr6kkjxizlpruc46hjnx72jl5625rsw3mcpkc5h4bvtp3wbmjf@g45yhep3ogjo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rr6kkjxizlpruc46hjnx72jl5625rsw3mcpkc5h4bvtp3wbmjf@g45yhep3ogjo>
X-Rspamd-Queue-Id: 6F91840005
X-Stat-Signature: bouz5oiw5pgshhqmd1j3z9fyhryg1zmj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754907607-804748
X-HE-Meta: U2FsdGVkX1/N9YlFz7D23mF9+zUwJ1pIh0zM+lLZCZPj+/1LkD6Ptl3udRv5Jx2yI5UL8Q0qLKJ8M3CRKkB/FcNK9ub3csWWYUsB9wgUKc1HP/PIh869j1R7n4OryqY/BoLALi2pj12R0trB8GF7FhApEgDcjXmrDHLT1cwBntK8Gby0hHphBWtG9C9DwhpYgABc3FTIXh8Wi3xOd8virxblPXK+riPTanszvVvptk1ilZTWwy0eZmaHmjv6ScuLoK/UkW8WzNGtEnCGhNNyAKuosU38S+U3L1aMgpF32bE4bZPBZHlmQyLcXVYY7Ga0KVODgJXJb8eBZ2LvpHSpzmDsnDW7LlXdiLrvPgUXdBPaqlwH1PUzu7GOlWU/N8MkObqCoEplZTNA9LVg0ZDT3/ic8trduLqonWWUeM6jTI619SNe3ZhvZSqol+SgHDvcfLkPtMTLdA4h52z8GrlOthlmIE3gztZzz1I79ozwnvilCQZpaEpLzIeWnYGMqS/q8SohOmnlALNA0ajVyZypbxkoi130DEWMI7ra5NM/Xx+ZO8nMdZmapKtHSil921r/lo2ApVcfHV01jjtAq0aR8jp615T/r2CEwU3fpSHiSHU0ndOpi8qjhYUgT422T/o36WtAXKaJSmpG9EC1/hKKO3BsRHvrhD0gIgJrC8QoV+G5lzaLIUB8fDkW5qG/w056SEJh7cEwW2qQYFsDj81lblR7AZWZK6AuMUvn9q+hYvVqcwFB+MWdAQg3aLrI/qCizkIe1jHV+Jq2+dbnVkuu5rpTBa1Ly4sBAqD2G1N3+9GtCztS/SoPh6NEeZq8YMH4BfPVeJt/uO6bTsMp1cmhUGKMHd1+TDZ/OxB0foNSAeaLIJDvlbwIRFPdx0V3iHTjxuxe7dJ1Bc+OBxjYQTpWe/JhDHxai3IWQtBbRBfEptc1irel2Mp3YiRKSBitdY9rqj0vXCflqDC5ym8tnXk
 6Gjj+aIT
 li613Cc8VZuvvNG3o903MHPRNPW1wYdBfhTND1sAhuJ6IZkOIs6G2NdDNfX72JBwtXdp88n1CejpPE/VjW8nvnfaGKYdr33dzHoczAQp/w3/D3/7y/JB2m6zl1bPQxDWKVadzqjqROx+gzKPwgptNF6UfeRORNEJU2gyVZMVOjaMuLxONxlm7xd8L+lfdhkAHghnnIOXkojKDdXRFgEaR/Yphl7CMiYvVDPEsYXOZ4VgKB6m7rQ1mBe20rSgMZ/4rL/86rFFudQvrNOipv8V3Q6zzvAmNLfDvf0vviAVAib5FTwlINglhwIVY0E06dey5fETx4dBrLEXLbXEPEuHP4yh58LCStJWqWewDm1HhYl3P2fsIPrdbOpt4jQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Sorry, RFC v2 I think. It got a bit confusing with series names/versions.
> 
> Well, my worry is that 2M can be a high tax for smaller machines.
> Compile-time might be cleaner, but it has downsides.
> 
> It is also not clear if these users actually need physical HZP or virtual
> is enough. Virtual is cheap.

We do need physical as the main usecase was for block IO where we will
be DMAing. The main reason I was seeing an improvement in perf was we
were sending bigger chunks of memory in a single bio_vec instead of
using multiple bio_vec.

--
Pankaj


