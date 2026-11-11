Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 838D0606A333
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GMnpEq10
Received: by kanga.kvack.org (Postfix)
	id AC8D36B05C6; Wed, 11 Nov 2026 06:36:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79706B05C7; Wed, 11 Nov 2026 06:36:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9690F6B05C8; Wed, 11 Nov 2026 06:36:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7470A6B05C6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:36:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D0A51A0280
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:36:57 +0000 (UTC)
X-FDA: 85422636474.11.A55435F
Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0CAAC1C0009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:36:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GMnpEq10;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794397015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swMse98eNqiMJcwGyFipJhNVyCCyR23IATBp3xslRm8=;
	b=Ac4Q+4a5FXsxfXu8afcYDCjDmBY/vOViw4CTWsKcoC0Lon2sbTzNOhXey6XMOUkUDk15rJ
	ADO4qL5NDugMw2/FtnLSeYN/ut01Ixj8U2je6aIMD9DKr0LCy/hJYQMeHk7sPpk/jEdFdo
	h1taclCD3SqbMLsAgLt8rMDteYJjR1k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GMnpEq10;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794397015;
	b=1Rhv/L6FtQ9iFrVVH/G2kozGhaxOAXfpqf7CV05+272aKq5pbu4R+n/gSG8KYowGSnR0b4
	jsBa5x8fzYMo2IliXtzE2bki6BM8nlrOmXN4QVZCeH/aArI9EGzICNmouRrvgd6imztl5M
	0CUp+OwyZXYSVDKwOkote2/Ohj9RLEw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fEJSAiQwyRf0hWMsSCb3epTBXmZZN1Qcr2L+tTJSz64=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794397013; v=1; x=1795001813;
 b=GMnpEq10QGcPBXEM93OAvnbAIy5beCVgnowsVFE3VCN8fUNaBrroVVqsTzaubVcYfZHgMHS0
 szCx3+jKO2dtZbDN02RyACXrWNdFaSfU5gCkTaf5b8g2+LqmmCNJrwQheGYJ/xKTM3XW8yNRanG
 dPa/eqHnk+5F/nub+0WQoWWM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9124456fdb93fcce;
	Wed, 11 Nov 2026 11:36:53 +0000
X-Mizu-Trace-ID: 9124456fdb93fcce
X-Migadu-Flow: FLOW_OUT
Date: Wed, 11 Nov 2026 19:36:47 +0800
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/8] mm, slab: rework KMALLOC_RECLAIM handling of
 SLUB_TINY
Message-ID: <avRSHkq_jcNuDg1r@fedora>
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
 <20261024-slub_tiny_rework-v2-3-bf1419ab5ffd@kernel.org>
 <auHcj2G78VkXy-Vz@fedora>
 <auycUvCC2mL_EQ1r@thinkstation>
 <avE01iTQccxQnhl6@fedora>
 <ec39ce6d-e604-48ab-9582-04ff73d13c16@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec39ce6d-e604-48ab-9582-04ff73d13c16@kernel.org>
X-Stat-Signature: u9yp8uqx6x83c68rzb5i3h5xb74ph8qh
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0CAAC1C0009
X-HE-Tag: 1794397014-479840
X-HE-Meta: U2FsdGVkX19PtRODSC+ZSGJYXd7oatSQBIe5Ye2MzBH8gNB4DNp8lZMQ5mBNXdUpGtFydjPKARvKxwOLgDmeFDEE+ZtW7H+trWxcVV56fLkIengj+dgMp/qyz8x1fQEmSTkGF4AzcVKr3G7VCLQ/QTj8d2Tp2fPY2Bm1CABgjizQpp9o9VqNEe7dxJPIPSFvudaOhXE5SNqwsZwservDIW8g5+lcD9ov/GH85WpydmwD559nJU3nkFIQ6mafg5bvjCAmvWvEueIgr4xazXZWE83EsAcDQoXPr6IArP7V+gl1tf5n18szvYAepr6qD9uqGF8DaRGFe7g90O4Syj/4PwcsirJn9+BhOmQtG/a0/eZs3xoX6ULzeBhLEZq/ZdojzA5pPA2AtOYkoj8txKKAp70wHU4PsbzQWFG4AtCxK8SC9A29QtHZx0icALftCWQZlOR9m3zvGojHXvkwpF1iAzZNcMUBrqCPVWy57hrQGTEOhP04wr7FlGKzy3BlHGxnVYfP/l+gfRMo73o4GXHjUUQRXi39aOfzUBAkl6vVYy7KPItNfiZ/ZoSEw8jOZ/1z6cyYVaSagmCRHfoENFtAJBGcz4FethWQW8/p4lS9IBUiUCGgtz+e/9ssGB4fJ/8TdX+gFb3swQzH8g7eJ2/5V/w4uqYvTYnEIcyLwKTX99VZYbwwCErVtHsrardsHhgY7ANf7yipwXvB4hvRXBx5p17nCwqGQN8My5wUkBimj8gv0efYfodeNsWtT+m6Dg+BLnvXbXWb5XfUeIY6bRW99GPBBwHYiiOFSmP8V1vTVfHMtGKTQVbYPsJCz4RREgZSCKHgb5sEZ387B/iDgbQAS1t5j1zR6CngIwf5Ksh6+I9+WtJE5zHS48IhXb/DWPVZHT0WcCZ2uTvb9yLCNErgj8lIA7EHloDA7UOrSrpKHFQRaPR9KXSsklFaYF9wzKzRXwN3qQtUbSunzrpZtSM
 xClbEoH+
 HCF7nWPVnEgwI9jnth1eDdX0mpy1fNaaRWDhvvQOCy7zJdMXc4I7wOMGo1fjwEGHrYyiCnur8vlCxwiZ6Y+oo/r0dfkMiYafrfEkbz7Yl6QrpOy4J7I8EQFdtGB3aVURY6Rabkwj9AoQP00+CPlKoTBOO7/J8VEb+9OANzT5SMuZ0r5r2N748qT5c1h5E9qx6kJnCp2YGlWXienWrcSgUX39KbbrPbld/fAyTN7xPtFFH9g7QRMn/nnPPwT8VAw5F4UhNE/TBCVQh/gnjHu6BByXxrRFLXC0nrJnTzl+2wrLc4z7t8Lp9JjVs8nUh1FhNx3o4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 11:30:09AM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/9/26 04:01, Hao Li wrote:
> > On Thu, Nov 05, 2026 at 03:19:01PM +0000, Harry Yoo wrote:
> >> 
> >> > Given that, would it make sense to
> >> > change this line to something like:
> >> > 
> >> > if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END &&
> >> > 	!slab_tiny_enabled)
> >> 
> >> Maybe you could send a patch as it's a separate issue from the patchset?
> > 
> > Sure thing! I'll post it once vbabka's slab_tiny series lands.
> 
> It would be better if the fix preceded the series actually.

Makes sense. I'll send it out shortly.

-- 
Thanks,
Hao

