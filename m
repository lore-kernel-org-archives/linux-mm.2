Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D040CD185F9
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 14:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28A6D6B0088; Thu,  8 Jan 2026 09:15:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 238E96B0089; Thu,  8 Jan 2026 09:15:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144626B0092; Thu,  8 Jan 2026 09:15:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0538D6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:15:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B55D814017E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:15:37 +0000 (UTC)
X-FDA: 84308994714.24.0BA5686
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id 00A25180017
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:15:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=I7mWRrOI;
	spf=none (imf06.hostedemail.com: domain of BATV+5298a8b8e8947b8d05f6+8173+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5298a8b8e8947b8d05f6+8173+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767881735; a=rsa-sha256;
	cv=none;
	b=6dFy8+kjDHAa2RYUIzZIkKOPY0rf8e4/4w8A7+nm24ZWcQ11BTN97YOev/GcFiXTKA/xtF
	1UZVupEwc4frEAcQKIgF3HTg0P9rtdfObRb0wahcpr1N7jes7VNZMs0Qe9BexizCCGU7lV
	3R4XGJojoCyymRd+FgiIlfoeHNBK3b4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=I7mWRrOI;
	spf=none (imf06.hostedemail.com: domain of BATV+5298a8b8e8947b8d05f6+8173+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5298a8b8e8947b8d05f6+8173+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767881735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSaw2shMuWRUK0Hbj/JfulYmVztyKaVf1wunSQycaE0=;
	b=2/NfkN3fMZrIFHS88zK+e98JSSWtRoIsrvqREGd1s+FYkNDB4yRxF8rRUEZ52YV9+XvaWG
	uvwLTe+T1Ld2UK7ZC1GP9RkBn01RO/8POcScOFNs2o3NX2fk5nwhDslTpvogiK/VKMZHzo
	TkaQf3Ouq/XXfnczlcZdN7RlQEGs3/s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nSaw2shMuWRUK0Hbj/JfulYmVztyKaVf1wunSQycaE0=; b=I7mWRrOIlJaTHHh74LoVGNPw3k
	2TaIYzgKRoTRZTbjUw0nSgqAOEpJpibVWU+ZTHWXkpKPk3aBJQYb7R9Ouy+Veba6g6eyYhQgF/EHy
	qb42JPL5Dd8tCPsNVvNBzkkaJmnTfNguO3oKO3v8MDfGIZ8UEn8O+AbUrVJTMM2Z74yBwuiWFB8/K
	uQGMj6zbYRe9RXpFN++PSFTwtb3oGndTHkH675b+dGtnn9jXI3zecgFElqU3SdDqJ5coWgqcpam44
	Tcm6eeuMORFiusqv1u0Dq0e2K+50TLKwzuwsTmmrXLjKspVt8fnsT8ewYxQySi4QqFSC0UcO1jE77
	AI+SO2vg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdqnU-0000000HIQB-2n67;
	Thu, 08 Jan 2026 14:15:32 +0000
Date: Thu, 8 Jan 2026 06:15:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, klourencodev@gmail.com,
	linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH] mm/mempool.c: set @elems slots to NULL once freed
Message-ID: <aV-8BFEtV-dMNCCl@infradead.org>
References: <20251223231054.16061-1-klourencodev@gmail.com>
 <07c4f991-ae41-456d-8e7f-287bf8676c9e@suse.cz>
 <aVyqPfnVtdAM4HYY@infradead.org>
 <e1f271a2-6215-4d16-b17b-45ff8548f8b3@suse.cz>
 <aVzDVxhLp4tfAkKk@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVzDVxhLp4tfAkKk@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 00A25180017
X-Rspamd-Server: rspam04
X-Stat-Signature: ew1jjrcgsu45axk38q5osawa9p8aexyd
X-HE-Tag: 1767881734-63776
X-HE-Meta: U2FsdGVkX1+i0Tx0dK42llrz1//GH78wZ5GQgVD4MjOXbxw+Ok144MR/sy+8+q+EigXuKVZVegBT8EovFFdCGhxJNG3xxayHwA9IUjntwKXHoK75I0o1fPx9qWeV4IaaEbzNg8SSHZN4QSawXHwSM14b97j2E8CToo7y8TOj7Ej+9/u2wg5JcFhOe1XePyaTzpW0I6B7f9EIDqA5+Mzhj0d5xg4G+S6ygoE/YmUY7PzHZS99O8IJnjWnfO2rqjt9IwjfFDyO/Pmjhith15EqYEvRRaJLEFvd0iq2Al7MxX1ZqTmd4EvbRkDZeL5usV6tCmQk6UC4lNdJ7LTvU8jqMUa/EACtAckRfxWrjpkwjGZ26f6KPRZKimBhFPtAiZy+DAaCJLL2l3Q9Z53rDxWrr4na31LVahiEU4ZT48QiPxPpli+DLirQIagN/8UUgE9FHgDJP17EEt+TnSWIDsv2Hw3CE4LD9JpZIYfYuJMn3P9mdeKYUVv2sZnn7EPuyul+9p58HJfU6qT4OJSM4hyOafroN3TiJisyhMMkiIyJxcy0yJNk5dzRu5ZOV7lPVg/R0Rrg5Ws/3TcQ/L9N3QeUmhSjsYydDjzTCC5WhbN2NuVSMmEwEAQHEd1CdyU0RvQnNzFXa7dTTbwtvcZxhL8yVxagsoerWot4jV1W2Ud7x02qjUTadLPWK8vU8FZxtwjz/WYMPUpFTUrqZFluCs4B/3QHLnWMLqC8fKGnCdhX+89hMq8eDlr5olo3atww60c2p94q5oU/qPPjL8fMEojshIwcXYUUpbaYKTThDSHEKbjtSjxfpYVPz3Zk6JHWgo+gMU3c1KLdSeb6eRk5vCpDz+RGlAxuIgbaJ//WH28ips3J9Mx98aZisHmBp/Y8hCxDlDIYPskS3foyJfM6iQpe5JUv94YubFQZ8r82uwqZfV/CKZhidsaEdGjwXeheB7Vj0g/c/5mawiFELhoPYI8
 5gTaEaDx
 7DBjm5Hd8SoyJiAhhMaSe2I6gJhXpvsp/yPZQPVEZANZdCZM8QmPmTJD0nJ21QMsYdKt8DwnOzldQvRMvM8V2kikWO7m6jrBJ642jx5sDvLPdu03agne8L4nHGFB1BAZfLRlxzIgV53/4c9kNkrbXRTrV9ktuVqGoD2wkLRIoS5z8CqhFoR5zfoSA5OylYVwxjhW+S1r43wcwoE4RtmMoAgEMLfPsqiWmUFkVqaGccV1hwUQwZvW8wo0Juwk5rBzyBd1c2tHk3wi7SHL1CA1QeBIGKtUOGltP6n5LDv6ZG1bCTITXy12gFilOS7cqU4Bl4QMaIDNl7u/JQJT8O0zpYZk0PJ2s8L/7nbxEsEpn54L9PpAbFRG/K5hcHe1ZGuSykhE2iC98Zv2SiNwvy1TX/Dk/IuQVt5fz6qs1ryMShQ7slJosQJwuUCc8khN+3Ui0OR0HXM218IpjGldv3g/RVN+WdW2OC+9obKvYX6dNwxChgMymV8kBnZDT/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 12:09:59AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 06, 2026 at 09:00:21AM +0100, Vlastimil Babka wrote:
> > > Not sure. I hate the magic null skipping behavior in
> > > __alloc_pages_bulk()/release_pages(), but given that we try to stay
> > > compatible it might be best to do this.
> > 
> > Well but release_pages() is null skipping but not NULL creating?
> 
> True.  Let me think about this a bit more.

I thought about this a bit, and can't think of any benefit in zeroing
the slot.  So I think just updating the documentation here might be
the better choice.

