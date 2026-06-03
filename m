Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1984CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2973C6B00B3; Wed,  3 Jun 2026 14:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26EC06B00B5; Wed,  3 Jun 2026 14:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184946B00B7; Wed,  3 Jun 2026 14:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 089276B00B3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:14:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C78161C1A60
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:14:56 +0000 (UTC)
X-FDA: 84839402592.11.851CDD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3D5A84000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:14:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EYt4jGOF;
	spf=pass (imf04.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780510495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WrRoXO8ws2YpgPqY1eyvviLf48IBcpkEZY8IYp2NLo=;
	b=ExB0IyNR13qAQwZoASCGegBcFgVdaaz3uK44exFxDeb3JwOeCVYdU/OKj5dZly3LH2yXoN
	T+nr/njJvta/CPQqRKL+8FUEb/L53Fg9S13WjSTHIkg6DKmLCZ9pzU9bZ5bsDwhXLLyxTy
	lLukZ/uEI2ms9AvZdv2UK7vuInt2Jjk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780510495;
	b=UkeQ85ENP845xZlzNDQjtVnmvZWBkSuGj7XeU0vclQL8RNLiLxN2hzqITGyezE/63ZD0Hh
	sekMT3alz9U1Uvg93MRmSPZy34apROhyV3l6Djy3C8q5oBKag2SalWAv7TiLy36vWpX32e
	D6uPgcdJOdjq+42sDIVjTffnDQFEeyw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EYt4jGOF;
	spf=pass (imf04.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0AD96008A;
	Wed,  3 Jun 2026 18:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922DF1F0089B;
	Wed,  3 Jun 2026 18:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780510494;
	bh=6WrRoXO8ws2YpgPqY1eyvviLf48IBcpkEZY8IYp2NLo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EYt4jGOFf5LyezMTLV9dtf2WymLahWZzOV9zIlsR/s0qVRxpHXAAirSEbS46iArUz
	 3jFo9xc18HpY/AIlMplWvxVe2GOAw49DmR+mT+asEMqWykbJ3kaGZxjmXlhW4c8Ors
	 EW/vIn7AffpcwBX08cwjSweCluQTp3Sevfta9TJlQ7MM6F7ZVYwEsQy2HTUikfeGFa
	 xQZRg7I4AP/QtUfwHSQZfCZmhKiph4Mdhz2KEt6agP6Meih8rA58vz+GsKjWNqY2AQ
	 pEIH9ry/aBOAEjUXK0Ra/KnN1Fh7TD8mTUn2t3uUQKfwGWOkiN7vTRf9U+IHj5k+B0
	 fFWYzzBA9yA4Q==
Date: Wed, 3 Jun 2026 11:14:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Linus Torvalds
 <torvalds@linux-foundation.org>, Askar Safin <safinaskar@gmail.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
 david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
 netdev@vger.kernel.org, patches@lists.linux.dev, viro@zeniv.linux.org.uk,
 willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260603111452.7e7bb17c@kernel.org>
In-Reply-To: <aiAREqlHK1llOw_y@pedro-suse.lan>
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
	<20260602225426.122258-1-safinaskar@gmail.com>
	<CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
	<CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
	<aiAREqlHK1llOw_y@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3D5A84000D
X-Rspam-User: 
X-Stat-Signature: umuhrcwuknp11exowihtwrqionenehb3
X-Rspamd-Server: rspam08
X-HE-Tag: 1780510495-932892
X-HE-Meta: U2FsdGVkX19v+2VyKLLlZy5JH0UL6UwUmvA7iCi17Fyz7fU2xQcMklBAjyb0TSm7mjeNKffCWLdugbAKzo14mmlbTmJ0ipGiV05hWuGFRFe7xCcKvaMgRI7CrtgtxDswBWiZogKlagHK6C0x7nJHsJoX71oM/DKsQTbujzuifevW4MzwIPU6j6K5W2p1MzZNS25nDGmFz4vHxqIv5fFMFcddrtNgEVfiQoRSwLao5ZfTpoRur8ARqKMCdXGmb1gIrJEgimJFJQY8z5t5tJCpmDvHcczSSH7NhxcsM8is4phnXB6/P296oIbwC4FU/8tpVD4fVnJoapkYPDAHmORcYvF1/0nnTLpYZfKNhl6AGOFH7sa+SES36xjSpIAUFOOxmE4qPBrLMbklwb1GatTz3t0MXqKlr6S2OexCeaOGjZLWI1SCC/2/POSnZ8ll2VXjk95xj4B738VNKKtvjs0x+G6aKrsPe9jH8qRIsAG4sOggEGzuy6na69cOeAlviDEd2IA9SD5xR2ZTZx/it3GEHR1alzRPhzWntw6wI5vwSoAhm2UvAAK8H5IkLpZ8mOlBA7F+IcLwY6BqfT+lYrDMIq9z5FbwLzXN4qu7Ykz8ZxZUyFH2V/Au4lRICayqb2l7y341g2Z7Nr3CPmNT0qWWNM6pNssx0ERcI5nAXvdMGs5J/1lP30kNafvji7GXLlTZvqATkGzu5qKP0fAPHI6/1ZX0bLKICTNJEwG4gbIvXXeGP4ZisQm0MR9MkcZvzkhV1EgkMozvl5pFV7g9tQiwPB3AWUBw9+qRzjp5IqGuFEO9qOzJmmTaCBRHOf61G/hwv8D93t5gkJ3cyn7F1KsOW2Wa+QJVZipf6dqnwGGlKp5WGPJ/UV91CeLQKNsaIPSyrX9e7KEfylaaqHKk0noPHCwJmw0bImPRBLyGBX7QKoHCuO/yK+eH4A/uPDWtxN6ALKBePxSm+TyyoSYAkCk
 z+dVKW4P
 2VFQE/LvXoQx6VOjbqm6oiNyjaLINVLphQidH2Rg4LMxavo2f+8GI7XmMu8FGi/T0LZeApKEZM5Bh1mAYb7ZkRXBhvziwxTxyXyzezqyj+BMaj9FUvDCLdpECOITNn2b23ouHvxsPXVf6TzJvu0Q/BnHyUD2boPjLZpV+zv1teocy3BKjAy4bLW+IlNspOsWidYc3EmCP9C7d9GgrYk58bnnvZxb6eP29KaG7k6r4ssYkBzWeXOOCUsdEFoR3mB7GM48jEcVnjNOmQnu1LZwuvfjN8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 12:43:54 +0100 Pedro Falcato wrote:
> > Am I understanding correctly that this will completely break zerocopy
> > sendfile?  sendfile is, internally, splice-to-a-secret-per-task-pipe
> > and then splice to the socket.  How much to people care?  These days,
> > a lot of high-bandwidth network senders are sending encrypted data,
> > which is not zerocopy frompagecache.  But there are surely some users  
> 
> You can do zerocopy from the page cache, even with TLS on top, by having
> your (fancy) NIC do TLS offloading for you. See https://people.freebsd.org/~gallatin/talks/euro2019-ktls.pdf.
> Linux works similarly. Slide 26 is particularly interesting.
> (No KTLS I assume is using simple sendmsg()'s from user memory, SW TLS
> and NIC KTLS are both sendfile(), per the slides)

FTR this datapoint should come with the caveat that kTLS _offload_ does
not support TLS 1.3 today. So how much that configuration is used in
practice is unclear.

