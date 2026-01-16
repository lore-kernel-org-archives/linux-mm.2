Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07608C98308
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 22:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D833D6B0005; Fri, 16 Jan 2026 17:26:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30AA6B0088; Fri, 16 Jan 2026 17:26:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C674C6B0089; Fri, 16 Jan 2026 17:26:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5BCD6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:26:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6504E1AE37F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 22:26:39 +0000 (UTC)
X-FDA: 84339262518.08.43F58DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A4EFBA0003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 22:26:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zueuGgvO;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768602397; a=rsa-sha256;
	cv=none;
	b=XjKn5rspS4rxXsHRbx9dIjALzyadKEsfsyD1tBT/kAN9bMlyohCizRUfxS/110bMHvSFiB
	KBS5MQ0g9sjQZkxEPmQGvpXjB+jLTLNa+TZPXHw8ezyakZ20/Cb41urlQwlM9NWOAAt+og
	PzyqxHgJWh4mmpxoE5QobKssxdUU8pc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zueuGgvO;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768602397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10bHbMQGfL9J/pVjYQIJGwAO4YiTpvJwKw3dRcyaupc=;
	b=K5mHufrICzolLBMsS5nVg/g+6X7JcOWbTSn/n82QG7QmLld3ufym0XmWhAFD5YzEeU00Vs
	jjkpS/FAh0y1DRt/E35ccawj1u3+u/Rbi3teachDlqm+6VXyuh8zRJe4dNvZxAeH7q8lB4
	RjkH6De+fy9RljiIVu5H+0G5SW9mspo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F0A743C89;
	Fri, 16 Jan 2026 22:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7E7C116C6;
	Fri, 16 Jan 2026 22:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768602396;
	bh=jISp/PQERBVoxIY52JwSB/f2SYh+cfCMvfV1bJllKhQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zueuGgvOAnyooFyM3JlhrCN8Vj4JWFvldvWHUoVt6mtr0glNxpnRaiavAjfHPvm1a
	 WzKd3iwUjgVFuD60vkb13F/uS85XMXhUzoBlNETV+vEoxMbBSTi7kavoHnL/on7GfP
	 6uR7WjAkCgcoRXBEaVcDzjgFURfCjbZ03D6/ZdnE=
Date: Fri, 16 Jan 2026 14:26:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>
Subject: Re: [PATCH v2 1/2] kho: use unsigned long for nr_pages
Message-Id: <20260116142635.b90464ed9772c146a9842370@linux-foundation.org>
In-Reply-To: <20260116112217.915803-2-pratyush@kernel.org>
References: <20260116112217.915803-1-pratyush@kernel.org>
	<20260116112217.915803-2-pratyush@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: weswgebsik79m4r59pp3dksifsjwpb6m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A4EFBA0003
X-Rspam-User: 
X-HE-Tag: 1768602397-654357
X-HE-Meta: U2FsdGVkX1/qS1WGXi5idtbIt7t+lPos2kJNsqwTEe4EMUVsN06+vDym4Sh6IS/OE5UiqbycfsLhuXJ+DBYZDn72LbCiZOUk41IVViclV3yQdX1M/NM70gr91R0CyQgYPzlp921i91WvH7/uoxYR2T8PcP4iDaGWQKVj8l6LLkcyWUjeB6Bv6lox9aJAphZnRArcjfGmfxPoVeY76gbXzdwpC4rm9ItVw+RztZT8pRcM+tXkaK5RuJWlE7/ORjVZtZ+uLx95kANHIxSLiL4HVFSddmmbrSbwmpbabE8/7q/Ib89GKN/zhS5IvxJJoGEgxg+BMcBh3xpmnEVubvafigHCg01QDurqFG0N9ZcExkMv6voa99PW0zn4mHB9GvNogpoKNR6Yss8+TSNYjiG28G9uO3Tifmu8uuFdNVDC9mx7rV8V0rPveM3Lj1aY2Yqh5E1+zv892SmRPIjqgOhRMl0d8O2D4D+Kye+nDzzTHjaDyTtZg6s+aDW6HQSV+AbZlI+n19e+pfG/9zpdQwMStOG+VUKaJmo2CJ7RhhoBC6K+x46Ga0+fYxjygcMP4wPuR/XDokT7Kd6y4Xl4NtjM+9Da63Idx5pBMpRQ1kgw0hYOBgd6rEwIv5xV7Eg+p+MbphMGN/nu0baIdG0CujNB1PEsW1kClDis2ZUpwevPhQplayyOwH2cGYSopk5iz0ASiB12Mc2CTvyTEvfStWVoVhe6B3nZ4Z+AhfHuiA1+kOdj/t8bX4YTNPGOy+i+kve4IwLy5CulTZTCdzxdNud9yYKgAPhT0Lv9oOutMv0SM9Ia8rYPlpDI9c9HnAUh1ydl0YteWhssBWilGLOvkBp75t1INxFsigMuIn06IiczJNVEO0ylkHS6PVV8/8vSZTsOD3S0fgFRRaYDO7JHe48JeSxJk4Z4sfVQ4heBRnL1FH+B7LueATBgAtuSgvslSllCQ83Nt4D54OJZSz4bqI2
 yuAKWpI0
 Q5L4UxJZjX0fsfxeXoYqW0jJEXPunrLnLhFQPSB/cB55oKHXWrT7PSts328O5IlMtk1cOHb7FY429zPMDqm/RNFP/koV4cRMranPt9I0cH6mqT152xkgdYYGg2ic9mFFxJciGPtrHXzzQ4d0TL4hoYAQ9v/E4fD4wvq0HXplSAADUjiOBd2FcJU1YQAKlHVIhEEbyUHoYuU0t0FHHQMu+po7ApwSMMXKdP234OvObATYPDbEwCKsFuGH2PEeBj99hMC2UkFQxKMbZexkAJ8AbMCyyYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 11:22:14 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:

> With 4k pages, a 32-bit nr_pages can span up to 16 TiB. While it is a
> lot, there exist systems with terabytes of RAM. gup is also moving to
> using long for nr_pages. Use unsigned long and make KHO future-proof.

We can expect people to be using LTS kernel five years from now,
perhaps much longer.  Machines will be bigger then!

IOW, shouldn't we backport this?


