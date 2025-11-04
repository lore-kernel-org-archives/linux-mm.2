Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 796E0CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 11:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6DFF8E0130; Tue,  4 Nov 2025 06:09:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1EB78E0124; Tue,  4 Nov 2025 06:09:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B438E0130; Tue,  4 Nov 2025 06:09:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B1BA78E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:09:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 609FBC0449
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:09:31 +0000 (UTC)
X-FDA: 84072653742.14.E488AAA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id BCBB1140005
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:09:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hMs8UXnu;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of BATV+46153b84dec453ec9e5d+8108+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+46153b84dec453ec9e5d+8108+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762254569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K636kHKOtARt/ZcJFrFL1GtxK5zuMOMIE2/8C0vPMVU=;
	b=r6MihqVI934fIR7PWEWQGd+x0+dOgq3YmnrucrzILQF04rTr119N1TrQPvWwsOnOPDyWN5
	SjHtiKMxW5sRXW9O03aaiukUy1XZioP2SMAXswXGVXEzZtpA/MYGXhKLFJdzhtVGScGGCz
	sLsRpcviZQ8w55H4rQx2/VrBmxOhbGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762254569; a=rsa-sha256;
	cv=none;
	b=XaOUSgeHeDr8cHZqmDZ5/NWJH4qD+bPhS1+y364mims1PlgcbWRFgaKOYu+QFEMgzzCx53
	76r+aMJoZOCLFTNFZrj/SM0oX/7mCxwkzdBfrgbHWSdpTkvPgnw9baK3XRJhzmcZqMVsyN
	kn/NuCQX7gBdenqwv9+GNvanKCaiAhk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hMs8UXnu;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of BATV+46153b84dec453ec9e5d+8108+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+46153b84dec453ec9e5d+8108+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=K636kHKOtARt/ZcJFrFL1GtxK5zuMOMIE2/8C0vPMVU=; b=hMs8UXnus5ZoQ2JWbzy5WPT/jE
	dC9J4jgIbzuAwapymMIaYrdKWo/Qfao52h/MNjzrrjg50MD0EocdENbyV3gj8mfMxLeBEwbEfQW1J
	2+j2od9RN/iAln3j+1/jbVlToitPUwzc1exSjUnJXyl2rYXX+k20Mk/e4Lhpk1xJTTdRSA55Zlq2x
	xxzqKTgSdkm08soAB9hgDQCWkS6rZctCu09DQYHyluTgVTNyPu0Eo6FZtmICpJwGxWTF5bMg078ko
	iwnADhIygRztrPaSQ8d9QgeNl/Riia60WxT8+fqfpgIhHOsTF3Vu4uwg9Q/hNZTaKyb3hY+8CzmBT
	XQc/zZ2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGEuk-0000000Bgu6-3a3O;
	Tue, 04 Nov 2025 11:09:26 +0000
Date: Tue, 4 Nov 2025 03:09:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Message-ID: <aQne5je7dTkaf7Lv@infradead.org>
References: <20251103190429.104747-1-vishal.moola@gmail.com>
 <20251103190429.104747-2-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103190429.104747-2-vishal.moola@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 3xzfwwxsimsnq8m9khyartxojd7oc49b
X-Rspam-User: 
X-Rspamd-Queue-Id: BCBB1140005
X-Rspamd-Server: rspam10
X-HE-Tag: 1762254568-917621
X-HE-Meta: U2FsdGVkX18ourXxLSq1PnPoqvfnpqqB4EKr5P3OusaHF0ODww6P+7pV1BT77oKKQdFx5uMil5DaYrT1NrppCSwEJXn8nU1cgvUXhUZZGHhodGui/LLJaOgTDvGFdXuIwN3c/1pgfs7UjrjdifBzYsLUcxyRKFGYpfoWvddYU6YXWEgxmiDoO0e84IWhXAqZY7Nux6ddGFf8d4ZtUNuJKCihwYZpNj+uAgfyfJEj540CpSJ9xhRXP24+2wSEBpyZcfRPrvL5mg5y1/ID1dsNvE8NjBethoFLvL7nVlNgcEll5S/pwQ7AGpE6+VbN3E2a+46N9EfIEtP3STqUU03r5OPKlyrW3oiFMC1kznZFpWth/WfJjAMy5LcQkiCx3yGzptaJXsO0fv/n9kJh0nvJaHxOF8NUm1RiMdnOaejE0+B5xp3ApNiAuhvzKuPb4OfhsKNgc/G6hb9uDexzDuNLfZlD9frVY4R0/DcZAe7vujfH2jT+67aknrIfoKRoU1dHPNVDazbjRhapSm42feoobRSitXtIzeqyTn8CSgDuI7zlIuLqMS3aEVIy2usiRlcxmX2021AMlsTuZSAoM/VSavjy2GRwiowa6OTOoQS7Pwu6u38ICoDPTbub2bSHfsJxZToR39rw2PrLVAwVVgTE9xPvFWhPp8JR0eUqnBZqJTOci+DGeW0rCgzLO9YhkGqZLKTP5e/xBftHxLwAruE+e8mREMg/gzVyT21s9AFK3BY46ZBbLYKyl1KdxG4m6LPx7w0feeDyh2UiFw4TaLRRRX5FzLdyyVGPB4FxI4hxfoHCKg9LpygF0Rgw9SqftBtv+183V/4fXtTKCAqlTuD5jV7BrLYp/ZtIQ2Vi7DXCQBN+PfzPmFZrN3txfT4GAoYwo9kRQLJ64M/oYQTm9NKzvLdXRjXTPRtFHzXuO7p32hdaRUhJOM15IWia0p59JRVTquoGVcqqZOEvKglNg24
 cbqbnscH
 wv2kOYuVhdD7fHs520bqfetweHl6WeED+HvrjTw5TzBLAC70iBIfHlB9HzNycAkEILfYupPOueI6GgzSz9z3Kee81NoZGfts7PQhaEDh9fDYlRuZ83jolsVTqx68WqMKgmXmnGbpbzvHXAOUkB63ReWyhr3I4SHZwV9zlJ/fp7JFBq3SXORjkVFQJnB+1fPMtt2bIgTo/J6dNSh8px+CA6jn0rK+lHnB5dmJcYEHSyvdjqBu2BmmjJS5TxaTIBzFO3ikHynNVYaLTGB5Uv5iJP8uQBIBTgn0yLZbVIBR34bB3Lm8RDiOpUHgsPH7kRx12kzEjm1s0L7Z2pit1hBwFt9PVNIrFkOIAS4L5IRmYJjywNr6/FG6Heqalmwk49oEwY9bFwkhVvh3yDYh2/fB0jt1DiqjqNpeg2VvEmDkKD5l36yFL6XVLNYCTVo/vwn8dNhSArk0ijVLguDSziT351IShUMU75ICuow94yADItK27ha+xLhv0aZPKki9jQ6JnBkQ6ITbvdlXsBfD6ei+p5IA8QYdbvAiGJMRYFDk5I/TrFCYGS/Ab1WI3DeLDbI6W5kMr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 11:04:26AM -0800, Vishal Moola (Oracle) wrote:
> Vmalloc explicitly supports a list of flags, but we never enforce them.
> vmalloc has been trying to handle unsupported flags by clearing and
> setting flags wherever necessary. This is messy and makes the code
> harder to understand, when we could simply check for a supported input
> immediately instead.
> 
> Define a helper mask and function telling callers they have passed in
> invalid flags, and clear those unsupported vmalloc flags.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

And just for the record:  I very much suspect we'll find someone
passing unsuported flags soon with this hidden somewhere that will
need fixing or at least temporarily extending the mask.


