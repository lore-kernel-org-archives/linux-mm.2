Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61CF4CD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 22:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414876B0005; Sun, 17 May 2026 18:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5326B0088; Sun, 17 May 2026 18:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA726B008C; Sun, 17 May 2026 18:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FDAE6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:30:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B14801A01BB
	for <linux-mm@kvack.org>; Sun, 17 May 2026 22:30:30 +0000 (UTC)
X-FDA: 84778357020.07.D3DC55E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1047E14000A
	for <linux-mm@kvack.org>; Sun, 17 May 2026 22:30:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=j1EPakP1;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779057029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBu08lIsgmM685ISDCEKZMZU6xFJCxfmHVVSJI5JqnU=;
	b=av+UN1gxhepIaeko5FRaa4CAQZOueNCkxhffDccb5k8bzrO10YT0XVXkofwk9xVvpjqCFK
	wRH/Fc/7mRW6NJAIehrgjmugrsuVVeW1dH2iF8mTgyXNrSeMXyVGosTONtd9VZjmU+Mdu+
	+1App02R1+SwuTLK61NhDaxnI79UHEo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=j1EPakP1;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779057029; a=rsa-sha256;
	cv=none;
	b=VKtJ1uzKhN0Hw+AOlCjs8kuWHNSbS8jEae5kwYmv4ESkRbLxDwoGVLdlDUaDm4OneScMtk
	8V8/5BoCWvZNHY2An/Jj9BAjPeJbE1R+rYabN7n1qbY7fzhJtMP4SRW7h46heroxwuPV9P
	cNln7vwpFZgNdi61FeDsznWdNGMfW8A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MBu08lIsgmM685ISDCEKZMZU6xFJCxfmHVVSJI5JqnU=; b=j1EPakP1qWP2IxoHgVAwV6M4ql
	sackarG/GlT0nhdIaXPn2GZW0sblIGscHQUK10dmNNYLg5gPaBYhatjRqOdr4B0rxauH8CM7NKBGj
	rkLQ3d9+lj5cezLOZVwELqt5r13C0NUKyjdKZXRC8EAPGTAcsecjexigXkyHXMVvAVFd6c6El1Ra5
	Nl4UyUEoQ01QSibignO00IqNAEr31X9NnybmQi6KfaJ5UIHzCZxw7MXtlluGIcb+1SJ2Pqc4QzHI0
	az/RfSy9utL3Ctr+nBvooc4GRcuImM5tkNQiFoTTkFRVGqu7pPlZW33/rqJQoV1LcSALWAb7MxuI9
	eHbOwY+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOk08-000000049kn-0K52;
	Sun, 17 May 2026 22:30:24 +0000
Date: Sun, 17 May 2026 23:30:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
Message-ID: <agpBf3PUA3fW5Nv5@casper.infradead.org>
References: <20260516182126.530498-1-pfalcato@suse.de>
 <agj4mXKRVW44ZJ18@casper.infradead.org>
 <agkRpj4oU8TPgmTS@pedro-suse.lan>
 <agkXHu_ON_KyWtvP@casper.infradead.org>
 <agmDiAY-mmlvjX0m@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agmDiAY-mmlvjX0m@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1047E14000A
X-Rspamd-Server: rspam06
X-Stat-Signature: nbatnbgyk44c1ys8dib5iz99om9jg8yd
X-HE-Tag: 1779057027-658274
X-HE-Meta: U2FsdGVkX198TS5fFqNxqEPlgT6p7KHgz3wc/FX5HlucMsLin0NOtZWYyDuJY1QPEv25lYS0gxpFZdzZkOSJBFVUjyLzuVvBLWZ+ejqz/xGa/QXX/fFac151rEKM1Rr1oDveNxmRdSZWsfXOmE8TvzaI3zvfxMPKQVyklZtAPt4NpuaEk2Z7MGS26pbL2fj68TAgN3FI+RjMr/8Zd1n7CfW7GgIInGUiyiLp3NtUhBGZm4sykceJGCkrTviiwTkswpzK8JSRQEK02Vo+n9oslSw6uuCNsK8A5vi/W/TjFZdhUV8vSiHSTNWqkyIFErqPKvgC6eHVeagWXkLEgXi9tfeOU1LyfyGyhPSoHiS6mQAODc6strzPyxULFFYDd/HqXpP9lP5W6EIciPyC6W8MeRHBemFLd0vPg5qOhsHX2Yx0b156pkuEKb4k+ltNyxLz6bdrKPmwCkp6WonO8gqC+7w9DuJ6LLYsKU2JzB3NO4ypWjzTitMFUX3do/5ICkoZsy+1L5pq6+y6uy/FQXfLOkh2s5OYFVKMA0lqSt8EhRvohEK1Eb6ImT3olFA9aLwpPBOQPzKX2gvOYGNWdu6MX8Tc+ktHSfJgu1JE5l9KOWTnjeq4CwaSe9tSz8s+eSEbzFyHtBmkQafzT7ngH5LSaLdtT9WBtl8ApqdAwfuYnHbGiAoW2QTRkPOMb9c4Cj5k5BIe6KTcR1Yrs72/F47+FCZEUjk966hctuspzjmokqDp9rN8egxpgu+hmBfEViHN6f3UKivg/z3q65i9zVFHxrTSq1GXKprwiEXRV6iGWGDPdmveF1PuLEsiKLFKW2amuZ6K1ELsaiW3yzmopAJ14HH4UVjGjI2lqURjuffo6MVPcpUMxo3Ikzcv0PnaH7PCYzBx2rrW0WEBBheQqEj4V7opaGfkJRvldt94VNZ6EmPIW3iaihCR4YP1NLyGJ8/6kjDRwajq2aOOefsrF2b
 1xh6/Weo
 F/3U4o01esSmDxEuAvdLx+wZC97fCKj5RTi/3QTiwo+RaFP36Aa6RIJAlxgBUcd/L7wcmglF731t5U+CHMiadIkSr70RcHP4Vfg33CNkoAzvTj4HeQbULNg4DKChPRykdODKFJ9XIpOjiT3FiIE8Tkr552OSnp65V4ouIpQlNjRl6yf2Ju7CP8O0QIVXFQ2ZzSaJkMKnTTbtMomv7BrzjY/UkNfIstNtcmROJPb+pzKKsAHRu3F6vK9cTHcJ1aJbb/fJN+aAO6MeUEut/klIALTxheXjssoqRMkvOB1Hvnrzh5JM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 10:01:30AM +0100, Pedro Falcato wrote:
> On Sun, May 17, 2026 at 02:17:18AM +0100, Matthew Wilcox wrote:
> > If we have a buggy user which
> > can write to read-only file pages, then it should also be prevented from
> > writing to KSM pages.
> 
> Hmm, I see. Are you suggesting we unshare KSM pages here? Or just straight
> up reject them?
> 
> Rejecting would be relatively sane if only we had access to the VMA here
> (in normal GUP), testing on folio_test_ksm() is less robust :/

I think we have to unshare?  As I understand KSM, it's done to a task,
so it wouldn't be aware that it's done something potentially dangerous
(unlike mapping a read-only file then splicing from it).  Also, it'll be
non-deterministic whether any given splice might fail.

Bleh.  Maybe just declare KSM to be vulnerable.

