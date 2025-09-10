Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD781CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 293338E001D; Wed, 10 Sep 2025 10:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A928E0003; Wed, 10 Sep 2025 10:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8638E001D; Wed, 10 Sep 2025 10:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 052338E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:31:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADE681A0925
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:31:28 +0000 (UTC)
X-FDA: 83873578656.27.B45B8A2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1D21D1C0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:31:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dofEW7af
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757514687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKSB+4xL7cCmeYE/ZtEdtCjsvm7CIgVIfr0teJIjFAU=;
	b=Yc5yPd7I2OYMWAIPSURLNu9fI+wjF8z0fFJ+tMc56uQMX99st6txKrLwxdIXJd0Y9lJu5M
	jyscO07Q/bJOL1y1ix+pRJNAPjWKJpRcsDXYLoNPNd8TjiQGtzkqGShGJyE5TJH/8/FyXT
	H9+mnrcSLKj/zxfHskCTkqt1C0DVK88=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757514687; a=rsa-sha256;
	cv=none;
	b=1T+Jv6TisEuz63dawoC5Jrx1Ucj6HyEDropvPYPgBLx1iiqeR+NcoIudrTSXu6L7hTqL5u
	XxFkvkv1AFmI7uZIfbOFu/shkZBn8bC4vDdHaZfHEM/7jBsN7oWTRK0bxj5AldwyFTA7hR
	o8W4Hyd7W2o2jyJrgEBOqOgh2ZkFlrE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dofEW7af;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mKSB+4xL7cCmeYE/ZtEdtCjsvm7CIgVIfr0teJIjFAU=; b=dofEW7af/ejhmNipPt2aD1zjQc
	r/T1X53PF0e+BEfGBFGmptVoarxZBEN1Hr7xriD76R1w+M+nvAcyFt2PcHdzuHg+TQmoMQFUdBQaA
	jm/o6jj1rPqB5i/QW6QVLU4W6O2YAUS0S3TvZPMLDfVQol1YTS76QR+/j8xxBFEpwnMLWAqId4scS
	bdUpC9Pcr4BH4JRwC/mCjcKWJe0ye/ZaEnL2OllK0B+92NxsmXiDMXLQP/kJYOtEetOYDdThozbzr
	U+eiVsgCMI71Rea2iE366+z3/3jQiRamjgJEHnieliGZegYbRdaVVmJTC4g6lcXbzYemC7sUUzZ3A
	gI/iBz2w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwLRO-0000000A1bz-3lAQ;
	Wed, 10 Sep 2025 14:04:54 +0000
Date: Wed, 10 Sep 2025 15:04:54 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, ksummit@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, imx@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Richard Weinberger <richard@nod.at>,
	Lucas Stach <l.stach@pengutronix.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
	Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Andreas Larsson <andreas@gaisler.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Message-ID: <aMGFhuHyQwtwyF7B@casper.infradead.org>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <CACRpkdb=E-_6fZ+4mX5FJas9C5Njp3Gwrygs-cAfWNdbP594cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb=E-_6fZ+4mX5FJas9C5Njp3Gwrygs-cAfWNdbP594cw@mail.gmail.com>
X-Stat-Signature: 4n8k1b1ysxonawb37tpmwyuiquba7zu4
X-Rspamd-Queue-Id: 1D21D1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757514686-818311
X-HE-Meta: U2FsdGVkX195Mi3Z/HG7JbdDX/FZB3PQ2evXMyWbEfI+MsUFaovNfcl4mDquSJ0nYHdePKeByoBfPp1BdnWa0AWj9CeP8x9zRSAwn0Yjqny1xTmgc/wYKLN/bDUGeU+T+uOLe84LNK5dP5gpZg6GhVw90AijasFABpPdXgoisX8Z11cBl0ehbC4xrjjYv5aQ8LB0CU5qd0Nbq4wKseYfdUdJh8Rb41DypEg+52GmxZBwpjy+SpyNLXEt1qfxa5ZoSWWbfPpfjtctg0GkDPf+8YByySiA0kmTcqd5sTUtmIqslbfXPGNfY+IPeUXkuZScdtWz+wF0A+WH8pYv03UJKlN5Tiun45VNXs8UvjeI653rNw923jO7ItlEbBYuvNIbYF4697N5VeKtlRqgNbhsYDlTlRwvL+orF2PbZOUpkQvqJA3B8KWMwMfCoW3/PIzUGkpSIAuHq+XQwTTqscit+VRCgBI4rwN4fMxyov2D9DLzED+HCYnZFteIw+GnmzggFfDsdaJOvphqwfBTr2DJNtTT98/P3w7pEHGODP6w09cKOxlBG6MztCXZT9xpe+qy8/akfIsnesILZE2iaO8rMBlAeBgK5twk7YOy6bV6pi39UUK64d0GHdZba9hRqFQviOaKWn0hyQnQOBONRzRcbPkXQSfT03BMdZexFFYiJT8DgzkkPrU/Dy79gz2dP9Y/amGMpgVCemKdAv2YV29b1zRPWA9aVcMFEpR5Er/77+S/s7TG1Gox2a+5j4ABVrPfg3yiGakf2tdgu4KyWd2e7iRChIzLP6x6PjWablSdi88k+JhIjHZc9lFZiIXmxcFDFbHY+6Z2h26n2HN7J0AVnT5gIfqog0BbGHvyZ//9JsQkmdz2OUaKPWSU/4wBExQh473vAgtkqUw76aUqpnwbw7U4LM5LK/4F3PeX0wKmPD1Yyvk5uMPguCIM/8dNPhjZWmA9WEaEm66IDfjRykq
 aul2bHO6
 fBgJT7+fG+zIe6AXMH2WLlpWNe9Lban2U/kaawU17Zo9ZHqbCaudT3FBqAvIzU1+dG3JQCbU5mQi5N421s1ZF1QZGDjdV903CB3FgHca8zf2hnP+rOnn9bU0C0UQPfBE76mlKbcSiH0Na/Ug/RBIc1j3EvOZgBAdj9Ps+HrN+l6Y9z4IM9F2dSlHByhes0OvAIzmtarqZoF5CM4gUDLBcCDKiKHh/9GP5I0/U1mpv0VEi9EXBFNcRZWEXvRc9HZD32IjUVjLRvJ2XsBSJ6AE3Y+C35U9ryJy5ofU7cAsirKiovMbrzLtpqVu/3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 03:10:05PM +0200, Linus Walleij wrote:
> This is is done so that we can unmap *most* of the kernel
> memory but *keep* the VMALLOC area, so that e.g. exceptions
> can still execute and save to stack when they occur, and we can
> call into the kernel to execute said exceptions.
> 
> This in practice means the area 0xf1000000-0xffffffff
> which also includes the high exception vectors that must for
> natural reasons also be kept in the mapping.
> What we have mapped today (all of the time) is
> 0xc0000000-0xffffffff.
> 
> A minimal 256 MB mapping from 0xf0000000-0xffffffff
> should be able to cover this.

Can I ask where the MMIO (PCI?) window lives?

