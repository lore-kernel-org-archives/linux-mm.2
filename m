Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61C1CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4992A8E0055; Tue, 19 Aug 2025 13:58:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449DA8E000F; Tue, 19 Aug 2025 13:58:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 360958E0055; Tue, 19 Aug 2025 13:58:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 265FB8E000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:58:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B78D0140189
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:58:26 +0000 (UTC)
X-FDA: 83794266612.16.8D86CA9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 801611C000C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:58:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qZAJKz7D
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755626304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2u20SMoYdsLpcqSk04cuuLa5bN3KKOvsCGjJ7RTbNo=;
	b=nQ5W5TUt383yH+NRc07SbtuP4N8qUsPJJSS9uy779Hokm3i0jGh7EbHcAPIpUBXG8Y6xsA
	qbQzNHLzkmJMWSGcSOW9seMRhbyoerJ/Z8QVMYhcog4z6Y35OgMSGlcrFINXuS2FNunwNO
	WqaoyiGjOW85iGzrhApPfDB15+/zveU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qZAJKz7D;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755626304; a=rsa-sha256;
	cv=none;
	b=wf63iXKJVtDlDKtCv27SIDd7FgrQiAiwvyXBxrBrhYLWXXBqn57x29fiiUkYt4wrG2Q3Mg
	VBDSNiD73+p9rEFddr9FCZJhJQ5uC38dpkEdOt6Hl/+MQXFf9+czwj9TEhv3I/EuiFAA5f
	1cOdKgRunH4ZXkzdm5mANfAU3ZscVyA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=b2u20SMoYdsLpcqSk04cuuLa5bN3KKOvsCGjJ7RTbNo=; b=qZAJKz7Dkka0M1NjWMLOdurXLh
	VpmzY2raKvI4ena/VgzpDf9egeGDdeilvVJ058L90/S6GWe3oY4QcEv+0n+mT8FV5N+CccukeAO6U
	142qIb58qe/LNlbbnnsjM0kQXRLj2cpDCK7b7AYHFmuTVj2m8sqIzl2TyXx6Q+tIRvzwYwd6TcqPH
	KWaXIw7Fz5id4GVwW5xZmRH9EUUF+lrXJzjyF3WhpuG5g1M52Y/MGacTp8lgTVa1OU2KSxa+vSRpV
	RxsCDLlYBybrksp//szoIw3JSy1PqxU3uS0Jk73kU7rEu/wLOvQG1Dl+7pP94npiKlxxSf0OHTbo7
	D4VuBDYw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoQbG-00000009aVh-0Xvo;
	Tue, 19 Aug 2025 17:58:22 +0000
Date: Tue, 19 Aug 2025 18:58:21 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 01/11] mm: Introduce memdesc_flags_t
Message-ID: <aKS7PRUfJRKWKnt4@casper.infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <20250805172307.1302730-2-willy@infradead.org>
 <CAMgjq7DA6Y3vY=dfKCk4WvNA_AtH1uHmXo15UYipPgOXYw80VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7DA6Y3vY=dfKCk4WvNA_AtH1uHmXo15UYipPgOXYw80VA@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 801611C000C
X-Stat-Signature: nuocr1gg1kkdapcnpxtb35eniubs3ehx
X-Rspam-User: 
X-HE-Tag: 1755626304-403024
X-HE-Meta: U2FsdGVkX1/9OaKZ9gV+CWthTxMd5OMB/hBfZxwqvPsyNj28V6BqCUkcmuBiajYapN2i8BsppK6B7pWfSK/7UAtwEYyNg0lwpDQGAj+NxCSDj0S30L01qqQJDc3nnkhmndZFVwN5JkwZDX/UZBcZXOtFdemv8OSWHulCc3U57da6VbJbiR6CfbxrUvSm1COihjtasSukLW/ovYS1VxXsp+US+TETztiUzaQd3edKFyRynyDuklvZmAS9UHr23Cd7x5K0ZYenLuARjp/EZ0nw979YX5xuanOAwEqUBKfLRMAc/gvCr/zOBP4gd6CI8MnMAw9TSrkIGfId+90o45mMH25YgWLyeIha4owIOlsSY7tR31MYkkkiPMbzmx2sVRsf9uh31jQFlZYym4oOEv+Ax6Mn8LbsmKtkCGDextaNz6+x54LJMiKGtmeAz3+gh5YwNKMXuwFqTUVADIvAgv/9Fe0XhQcNu5uVhKGA+2VLeQG95cFrmgnthAxOYhfjI6YYdwTRX+uNlQSzbXVeQXfKAHEKR0+YgbBzeWtAyEfJZfwrL19PBCBOEYh5H0w3rMp3kxrqp8odgD+Pu/SmT/6xY2Jmd6H3JtH5y/E7TQUe/Z0BrQbeqJqhkEqo6i3ai9g6qSzUKz0cT7NgIKxW+G6Y7VG66Dd7TLkXaDUTMVtFCT2g8ZUTRN2Ygv4O9uCLOYbEkUPWNIiju8pwo24EaIpQgiMokceQ1OoQ0DgV+wyP9COv+01ZoVk7K2TG2cG3LdYBlcKZAy9tJSwzjD2ips4J9AGbJszrm9mstXEogiUFrSjWSZjL2j9cqqQIInY1yG7fZfMhZflxpkDSyRzpPrHWnoewXycwDJWMXriye67T9iAmSc7ALchfLCyCekIDdth/Mfm/11bJqsEnukYeXoFG5acWuZvGVQ/Eb28e0PQIMywusEZ6k8WF9VDvsgm9OOg3fTyQpPheeN08H8lfhUr
 ssD6PU/x
 2yeTQEUMH1WOo548f+7t3Uk4ST6jBVa3eKEjbYgxVgUv5l/rbzWnaL8iH+6ztJ2CZgVbVXIwCHRT0hRDD0xUiVjE/kdbIs3Az+ghRRRBrWcM8f6hdX0I9C77vxhjqUn+BuCut1ajQ9Orwdx9E6q7FHBZB39UnA3GFldFWW6O9i2GlElBziaz91UWv4Hn1MbO2yzSlJuyuhhiPAjKyY/9cVoguMSlIEBMBRa7PhYnxCkBY1FX63wZF2BGFSKvjzJ30VL7ZFcHhdlKRUPnJ+RDsurO/LqxStYhe4nuGhTKUz0I5ItCIuakDPlFtaFN8N+vXRefxRw7vm8g0tIE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 01:49:54AM +0800, Kairui Song wrote:
> On Wed, Aug 6, 2025 at 2:20 AM Matthew Wilcox (Oracle)
> <willy@infradead.org> wrote:

[you really didn't need to quote the entire 900 lines of patch]

> I'm rebasing on mm-new, and seeing below build error after this patch:

See https://lore.kernel.org/linux-mm/aKMgPRLD-WnkPxYm@casper.infradead.org/

