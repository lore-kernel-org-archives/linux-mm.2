Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0E3CCD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522506B00B1; Wed,  3 Jun 2026 15:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA206B00B3; Wed,  3 Jun 2026 15:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436746B00B5; Wed,  3 Jun 2026 15:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31C356B00B1
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:24:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD9261A05F0
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:24:25 +0000 (UTC)
X-FDA: 84839577690.24.E0C3B1D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9743040009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:24:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ClQ+uuBg;
	spf=pass (imf07.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780514663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gfUHrdoR1LzqY63DNhYraq2XhjxJEOvKb6+mvRgSVk=;
	b=5ZVuDyXrlEkuptN9EDP6lwdZEp+Q7rA0SI3CKwDhYQqhnSuAMghnenvUk+jxpc1lX3BkOK
	Z5pzx1JPdEQsJQLchuys/VImBp+5w6/Yez1SXdpaQz7+/DsnRjIntYgutTx2Yq/xdOnrsp
	ig03KkdNpp8dYwatdmWTHSKIgbgI/YA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ClQ+uuBg;
	spf=pass (imf07.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780514663;
	b=O7dfdow9vaxaZD0/ns4LQZtKvVnUWSKLxePgTXNB0eawZpHnGrHkpf+IXUhE2DkiuYK0YG
	5Fw6aFrv/00zKiMoa+4tpgJ7SBFhTsuHFNFtuNNMSDMWjH+NIHvLgCBG+Vbp9uB+wJQNv/
	iBkeDKNIRWUE8NyrPryWbietnVEwtPA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780514662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9gfUHrdoR1LzqY63DNhYraq2XhjxJEOvKb6+mvRgSVk=;
	b=ClQ+uuBgMx2Y78gHTLyLTVooT3mRxb+8aLUpYgZdtc/1c7/WUQ5bLC+21L/2vUPEvLOlIO
	PLlJyRlwEzw0Dg+aZIjpLmRiE7e8n7UMauGBcjwtgmmMY87eyiJRGakfxrnAb9EidjugUZ
	eux+oygqWjUFLVLyT0cGmTp80FED/ps=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-16-lMJTVDivP3Ogp6JqZBXk8Q-1; Wed,
 03 Jun 2026 15:24:19 -0400
X-MC-Unique: lMJTVDivP3Ogp6JqZBXk8Q-1
X-Mimecast-MFC-AGG-ID: lMJTVDivP3Ogp6JqZBXk8Q_1780514656
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CFCE18002FF;
	Wed,  3 Jun 2026 19:24:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.48.52])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 219B0414;
	Wed,  3 Jun 2026 19:24:08 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com>
References: <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com> <20260531010107.1953702-1-safinaskar@gmail.com> <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com> <ah2nBAdsE5vVJ2PL@casper.infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
    Andy Lutomirski <luto@amacapital.net>,
    Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org,
    Christian Brauner <brauner@kernel.org>,
    Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
    linux-kernel@vger.kernel.org, linux-mm@kvack.org,
    linux-api@vger.kernel.org, netdev@vger.kernel.org,
    Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
    Andrew Morton <akpm@linux-foundation.org>,
    David Hildenbrand <david@kernel.org>,
    Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
    patches@lists.linux.dev
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
MIME-Version: 1.0
Date: Wed, 03 Jun 2026 20:24:07 +0100
Message-ID: <22834.1780514647@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: 3QDk11Pub4BX7BArQiPPML2SgNqrrLczcvw8ikXBg8M_1780514656
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22833.1780514647.1@warthog.procyon.org.uk>
X-Rspamd-Queue-Id: 9743040009
X-Stat-Signature: acos6q57u8ixzjx3wek56xwgg79spbmo
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780514663-96759
X-HE-Meta: U2FsdGVkX19ra+8YrhNIa2xmXgvVtPVfCYZumuZp48THBJpG/5ZePZwlCjgIB6UY6L5pZIDaBlsZ4oVy+w8y0OlQTbOBF1wFuZrfBHyPytKyBxfIXH0Ut+2ntICp9OCWyb1lHU6YsCFvIQU3Gq+L/Z/0zfcQfnbb3B4Jk56slQ5nxN7NV6iEAdCU3JC79G8OmOQ8mgLAmUqO8Zuc2P5mQffeXyiW3rBvV/DwZeXIKlOQUtAMwypBnJ1p6/tz0SCtAxtw5WQBVCPG4MCE/Jwmyf9rVj6qNUJpQKKWJT4MLYK7Dei7FxmxmgynGCLRKVeRxcrOldKCbyCpkcMq1SSUOfDirMrwNnenxHBWtbuoEU7IV/UIz6/MFh4az+1VcDgbOkUKbkQ/XIU4i0Wnp6nIggIlnxmuwWUu3Up+Xsm4XpN2oRCAmSEeMQh5Wn4QRJ9p3ZAisGWa3ojxjbLLRvkG6kqAaXgcSnhNzgA5LIzBMFRGjYkuj//bUEVSVEdsuvgnbyxF9ktV+jSZGZxcvGNdOsOmgA5HDHJstUWGhw2j+XLgc8mLNV1rCsKKm7ZDpQCs7rFJiV9kUhIk2sV02buJQhlKEF0OJqEGCvyvAat1bCqtvYLESkavVctRd2p8GDim/QnJ4jIUQtrw1gPgMY8mak0i/zAztTCmhC+WJEMFWdUvWROwoirgt5UrN0IbpiewBXSQIY/rfGNnrg6mA8VSgTzmTFJK1B5jydfm1amjoLfm1AuFNcE187OHmcjOour1nj3YB3hoIkRWeZTRaXEYasKSjyAv6DuVOQ9E1L+Vipa+MNXRotzuMWAkW0ILBFSHRlcGWchsMD1IygU93wUkZb6lprNDzTW51KqZGud+5yK2cPpOowZ4Dws81IPJJbmC2HXAekxTayY79uwEWZKkMymd2Z9MAQ8yxHEgQELVWG/k+lLXtfKQIP3vh0sTdVAcSDZPP0Q/xMT/FAA4Bxs
 6ezZg8A1
 RlENZI16udjo1fRBcrwFerXL8UcQ2hHLBxQliovBx7FU7f2pMXgU6L3kx5s/J6ROMfkz4CQXyEusCZfHxnMavy0gtBF9+QqCbri9hjRZqFrK32DYrfZqQPvwWqvmcDMp8fG3zGFdeh0AQbMdf2/hUHvaXuJmzX/UD/f8yQfNcKE4iGwDu02A4X929+lWgCI0s1isNqzxjqTkMDpyeXx8wdGLfJOdMTFFQ/pPAkBAyydbHPE9/JL5AfM4TKQMDagpNfZSKyn4dkAZ80YZcQPxcfC9hu/OC6cpUw5A1EwobAdwoEFgM5+tPTdPBat8Z5zyfy2sDwQVmmt7UKrK2L/P3euvqJSFDa/9D8Y2p0h+to2zgjkI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Well, since it pretty much is what I suggested a few years ago, I
> certainly won't NAK it.

I've been wanting to get rid of vmsplice for a while, so I'm in favour of this
too.

David


