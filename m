Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16419CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 05:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A5D6B008A; Wed, 10 Jun 2026 01:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531F66B008C; Wed, 10 Jun 2026 01:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F6F6B0093; Wed, 10 Jun 2026 01:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39DB86B008A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:14:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8B30920CF
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 05:14:49 +0000 (UTC)
X-FDA: 84862838298.25.88D2D5C
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2DC39180003
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 05:14:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=SRtexRuX;
	spf=pass (imf16.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781068488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=CAQW/woRlD6nMS40SYfYEy04qnRENam7hotbzTsoZO8=;
	b=Cd6oDbdDboqcGbA9tDNkAmlaE6z6MOTgd7SxbfRUnpY9+KBjLNxqCs0/odfKv3B2qbPUXV
	+cBKC1lsjLzQK5p4Ufx7/UR4cuk5FVl0mCrryu9nMm2GxLxdGF4txDR1erPUkETykBZhzU
	sQ9N7y4YmCv9e1uAB9x4NEOxrTHAYuw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=SRtexRuX;
	spf=pass (imf16.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781068488;
	b=xDIxmTaJpIJOHhS249+gTUwvy4Tr1jy6Vrs8HDzzl2upAZVpf+A/G316U7vvUcC9aTibd4
	mDEpf3sVw2ASXgfHOxXCS7eN7KymEgtJ3hUN7a1SkYSVFL/k5yqSpDbEpGkHWuuR6+NI2f
	mXsQHRMxRh/VWTKAIT+4CR7knSHCstc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=CAQW/woRlD6nMS40SYfYEy04qnRENam7hotbzTsoZO8=; b=SRtexRuXBTK493UySnuP5ALAyo
	Ufy0HINvTDsaMlNa2KbGBrDy3M2mD7oyb3K1uRfPZMycB8X6zumdthneP7PwKuWnxd5zs6rionpGo
	CqVwZyAAgtMS180w2Sww0de4fpAm3YKHdPZPh4Q5m8+BlUowPqXDnOu/OvmIeJeySkzUlQVQ80poU
	UfmB5QYu7L0pjXyJBBSf14lin4VNjPcw7OMXBPS9dJK5aJW8WVlAgKf4YfupIYwp5UaqDfieNMppl
	d2qkzQ1y1nhCAHFMEtboyBji+UBQaYqHGcvs3No1FfiumRPjop7cisWUioyEz0Za2KLJZliLTqXRb
	zHrKaoZA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXBGr-00000004AWe-2FLp;
	Wed, 10 Jun 2026 13:14:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Jun 2026 13:14:33 +0800
Date: Wed, 10 Jun 2026 13:14:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: metze@samba.org, luto@amacapital.net, safinaskar@gmail.com,
	akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
	david@kernel.org, dhowells@redhat.com, hch@infradead.org,
	jack@suse.cz, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
	patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <aijyuX14ahOf53zM@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whL0oLvmh3FO9SapDhgrXMT_d6qkP2V3OBjysOWXod2Og@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
X-Rspamd-Queue-Id: 2DC39180003
X-Stat-Signature: 3ed9o1xhpsgihary5hxuf5oxiwwuqzaf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781068487-434827
X-HE-Meta: U2FsdGVkX1/PZalO9OGDMQT631YBQoQjYd2THQSvPPLFxWjNRLPOvwTCNEFhBc06ZB6O8I6Iqi8txbul1Yhrx5ornxEncxSQ1VMrR4Ji9KN+qxjem2nQeQp4K1UgxqGa5IkGUx5DKPX3J4L7qLtMh/TR0RTKGsor8g5h48RgfrKagHLzOE2wKp5Pi/F+j72MWOalNFScU8DYvcGFXBIP1eHM8QQm6z6qaeL8ls+ky5ujQ+WDxGWmexemd9lY4hgB9s/dD394XWSvOkwG+en407350yxRCo0MfokMwkWYKKNPbeHmgy2WtRgC3kVcsUWoAbVu3mj+47ZnBgudMR1+QQ2xi2b32oXsQolY0T7plPdGgcpWte6hRgKgCIVLPdCPsw78Pwbejz7rJkbQUXoBSSM5pwGOG0QXCxEQnnL5uWiWm67PfFkSImUyMcL5k/HHCvUObL0cImh/fwi13jS99MbpgbzPKPyN12fPFQN636PM5KSVgBEj0E0tC8bgOsA8+YPCX2TXdoZrv5K+qk7P8veBqfylyWa9YsCRmg/4Ezl5lGzr1QJO5twCNgIrCvLWTy+dXyMY92DscEVmFsSlD8Cr6/F4POEDNhy2k2tYnz1iHzYWd2V/uJYS/7QQcCbvpKDRR5cnNx4nFjSedaEFwOmVB0ghQTg1ZRMVRMXGeHMSPqQy5btXXwWCY8ArFsXU77eXdsqu0P4A/CkaMPUyBW04JNqPMUn4Xx4y1qL6YQtTEZz0BnA7UjlSaD8hB01cVZbkldNAvlGaGR0fNgy2XSMlat4JaOfEMGbreUSe/bc72IvVUjacwwQdo04DlF/q7MRPemQ020GFsiF1IrABhdn4S0VBbj1MghG7/XzEoxed7xKtdDeueyIPXw9R9Ki3J3a8bAq+nE8psjLMTzNkd2OjasiwKH9zTQNd3mBUDnDP12wzZGgFM4YOqC/p9CJzV4rxT6VZXb6d+4kpcVe
 ykd2t6fa
 3DCOZDC5XdhaUME8rjfC4+E63RMnOBcTLkuQQ+gX0wg0LRf6a7b5qvDEDiq7O/XK8Dse1HUEs9I/XihcsX70FZM1x+FximiPKaoPoAY3x9srhOQ9cJOs7iLLekEAOaAlr6pC+XDbs7YWeZSK/Z47wzGlQB/pDrI+6IOyOA+wtorEdvFPJm2ta2++BFaAjRfNi+Whlzzi+rhjEVbsLV4mfYp64uq45NHCeo75VYNkQw2fpl7xelbyxx7ncXeF8ImhE0FWi7uD1jfgB4xIpcJ/Uoe7kcn2n2e+vqrgzHh9dg7a+nxAAUZ7/1FUtfTIvP2ZVjNlLmELJJIdM89eAGvERrprTsKsTJgE3AP7n9gCeQ54vhKZveT3nhrMFpRRErQT53cI8GKxWXZHazdII8HZ2fQxs8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> Nope. If your web server opens files with write access, I'd be
> extremely surprised.
> 
> And if you don't have write access, and you're sending out data from
> files you opened just for reading - the onle sane case - you hit all
> the existing problems with "I can certainly look up pages, but I damn
> well shouldn't pass those pages to the networking code without copying
> them".

How about using write access as the gate to zero copy?

IOW allow zero-copy if you already hold write access, otherwise
perform a copy.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

