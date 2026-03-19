Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EFFC1091926
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 21:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2586B04ED; Thu, 19 Mar 2026 17:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9536B04EF; Thu, 19 Mar 2026 17:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B064F6B04F0; Thu, 19 Mar 2026 17:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1206B04ED
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 478D81B8832
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:39:11 +0000 (UTC)
X-FDA: 84564128502.30.3CC91B0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8C87240010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:39:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bCJoKvMr;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773956349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NfAvuRAkXfTh0aD8fDGDPInZ2PzmkXCAe9B+2L0obpk=;
	b=07oGJXoTd4y8vOM52kOTLCi+gkTSfH1d3NZYMzi6h23AIi8BnV+hIV+DYZ07lk1ldUAjIP
	smnPEY5xHGW9mHAcGi1dfdcwWxZTTQcVikU4v3+b73olQqNCVencn/iM+F+h2bWc8dKlph
	Rm0SaXgtX5Kr33Rv8TR2rP36pZf+bPY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bCJoKvMr;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773956349; a=rsa-sha256;
	cv=none;
	b=I4lUjTspOOuD6EGhDohxTWFZrmuc0409WJmUBrj3mij7nZ22ST7aExuojOcVabCHrDXxqg
	uGXNWnW3yPpTDlsTi+n4s+Ffs1jIkKqtyZcTxob1xDNOMdknX/6xChnKFNTKG+cEsUK9mQ
	RySmBjoFJC8qjjI/wHufj+nNIHLo8E0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NfAvuRAkXfTh0aD8fDGDPInZ2PzmkXCAe9B+2L0obpk=; b=bCJoKvMrE+n7v8Phg2+6TftTSy
	Z4gTRvb+7jTLCPTMoT2MSVfxu8FvPgYjOMl/QEe6/QPgFo/H2Hgg0S4mdNBd0GgHcmA9ND/rz+9TD
	PPasrCNfprfNPzhvGc9gqy5NSIgiDZBfuzR3ZaSvS3lUXF4Eo/XHX1Uv8MyGEdhq+rtjY0YzbG5yw
	XAQDeoZUkoduRWItj/Ph9u/p6qaLCihT1fStjxqZCBu8ZTyLNWuRXn4M6FePPhE+hjrUzzV8RcXf0
	FGYUHWXT0md8JIKcLJPPEIWMsvMbkm+agFPFC465n/bddsWD8FWgPtDxsoED3LsV5Wktx1kvI+zty
	kHIiwKRA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3L54-00000006k3I-3VIq;
	Thu, 19 Mar 2026 21:39:02 +0000
Date: Thu, 19 Mar 2026 21:39:02 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/5] mm: Switch gfp_t to unsigned long
Message-ID: <abxs9k__wWWLL2hb@casper.infradead.org>
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
 <abwqq28hWXMLqa5P@casper.infradead.org>
 <DH6Z95PTZYVF.3K64RCJC06GEJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DH6Z95PTZYVF.3K64RCJC06GEJ@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8C87240010
X-Stat-Signature: 9kxegmrah64nhtkpj5moaaw89ho99him
X-Rspam-User: 
X-HE-Tag: 1773956349-646435
X-HE-Meta: U2FsdGVkX1/MIjX0WrnDsCzxDtuSnd9mpN80aGq+Nbo2vn1zWgffi2c5YCGnLQKZ6sGXMK3apcUeGHboBomyqVGcT0KRqxFi2wpdw/KLxqnCytGn8e0xl1aGcJWIxJ24568+N3fyyMqudAwZH+5LqmmsNaIjXJScZD1jJJY77/Dbl04NJXMtIX6Q0Hhj/DXEdnTB37tfLi+h12k3VBJYiBY2DQU+I3Pszd1t0OXJCq+U5i5Cj0C8fMpXb9aaAptEBusNq8UwPDmp0NPTCUUaNJO1t8I4dVAzyU3EcSzeh1Mfx0UrV/gsPI8C2ApIzdqQWPuiGNo5LKkNNOG41yFse9LDZFfivW80iCm+rSY3UbGUX57CSWbGMsHQXB0/qx0f6ocXcMR/t4YIe0e6+Afj+gWtYu8EGdGZgF+vzGi+FrHfrJWaokah1EgI7bMP8taZmxiqxMMCq9zrhnFTRtgG2vb+P/iKgxNijr1Ywn219NQDZJO3K3dbUlFuwbf3nFAeSobNP3FTE8Prph/rxIsPu77A9tzO/IuyD3bPSaFZdRiIZYvqVl0djTRBBeR7+kvsKP294xC62ddvSgEXc1ygP+MC/w1G6qdQ04c6OMlSyDHoXMsC9jHTZ55m3YS0zNgUqaVJK1WzL6TDIbUTt33sRyVU7eozDrmcyCv+glXASKj0dvaU7mxvEssl+kuoudLQPioy5EAXfPhLR6R52SwElVLVz71WS3ymJR1zdPRD9ocIguzephye8zGMvl627svXFUk2/YcR4yZCwUH+Te/bpZdho7x9WugX+CjaFV7hcBNCKC/82XQErFhBNRWmxjXSxqPJAp7xvyYGRfEvKl/h/YFPGEleVlAoY/qWaMCHT88YlI3tiZoG/NRcBf2rSWvRQb1lttCVQw/dI2BKNf/D209587Yn/PKBatr2FdNZPNO9r6hoX6uCyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 06:40:59PM +0000, Brendan Jackman wrote:
> I will paste the diff at the bottom. I _think_ all the problematic
> expansions are downstream of struct xarray, but it's quite likely my
> sense for problematic struct expansions is weak.

Urgh, no, it's not all xarray.  There's one in address_space which we're
trying to shrink, not grow.  There's one in struct sock too.

I don't think this idea is worth it.  There are other projects of greater
or lesser churniess which will give us some flags back.  For example,
we could finish the GFP_NOFS and GFP_NOIO removal.  We could finish the
radix_tree -> XArray removal and get back three bits.  That's five bits
without even starting new projects, just finishing old ones.


