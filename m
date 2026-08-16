Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86742C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 12:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513BD6B081E; Sun, 16 Aug 2026 08:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EB0C6B081F; Sun, 16 Aug 2026 08:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428596B0820; Sun, 16 Aug 2026 08:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12DBF6B081E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 08:13:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18B6016050D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 12:13:43 +0000 (UTC)
X-FDA: 85107023526.06.E666D32
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8991F160006
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 12:13:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of lukas@wunner.de designates 83.223.95.204 as permitted sender) smtp.mailfrom=lukas@wunner.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786882421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cn0zUN/hrMLQAPmuNzHmIPISGC8g6oolk9qIb89TBIU=;
	b=tWV9CZPRxVoDl+gV8letDZvoBMRk7B8eDYHLyhJpGvUJGgZnd4HXsA66W54mNPcp4fRB52
	RKlVaOF+gyGC2eFBncIxhHxOUjffAJNAI98nuRNIn3rEzxJe8MAKhs00MzCBU/4cZcgPVl
	rLsonJe939FmPg0yXUFb3N377PlJfQA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786882421;
	b=C7aPuSY53wOoglzVxyxxtYOCD6savX3qkiN8xdceYDLisivciGvFEcW27uk2U2xy7GMn87
	TORWHwVxAYwUZuXyj0rgXsFUGSKaXExhi2oZl/PeguvkoFLkpwJc4Z8wx0rTRi3JLVW2oO
	KfHIWJFmjKJS5VghdAHT7stqe0qtOv4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of lukas@wunner.de designates 83.223.95.204 as permitted sender) smtp.mailfrom=lukas@wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id 83A3F3BC;
	Sun, 16 Aug 2026 14:13:37 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 61BAE629CE27; Sun, 16 Aug 2026 14:13:37 +0200 (CEST)
Date: Sun, 16 Aug 2026 14:13:37 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <contact@jaseg.de>
Cc: Baoquan He <baoquan.he@linux.dev>,
	Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <linux@jaseg.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, keyrings@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-afs@lists.infradead.org, netdev@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 01/13] kexec: add CRASH_WIPE_SECRETS to wipe secrets
 before kdump
Message-ID: <aoGpcczo5GkBsPwt@wunner.de>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
 <20260811-crash-zeroize-rework-v2-1-9561d13c2340@jaseg.de>
 <anw9ILJiO5xIjP4f@MiWiFi-R3L-srv>
 <9765f7ea-36bb-4c7b-a19b-7facec97b762@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9765f7ea-36bb-4c7b-a19b-7facec97b762@jaseg.de>
X-Rspam-User: 
X-Stat-Signature: 7y83j9neyk6bj7whfrnj4wsys36qjwr7
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8991F160006
X-HE-Tag: 1786882420-456980
X-HE-Meta: U2FsdGVkX19yMUek5bofDIynFti4A8DM/EpqLEUh3KmVMywvadj4JKKzklUQ/mqAa6K2SOwt+RQI3xmCrm7N2Lt2jndvCJ3wG8FFKfCRsoM7f5Sc8i2drV1vEkLFiUtRyS7kyW4qQXFdtSfIuVBIzgi/CbT4QTZnYEtreJgrELS0fvLTkgxME1xxWcUwgDvMEacA81PGkcYXO0zB6Kkt9sCDjM0jPGRjPvn3Mwk02TAXX2YHcktqklTnVBIG0lJcKPqh+p3WqiwDs9Pf3+Divkundtyzd15gAboHCz7TtgfrDRaLDlf8Okve8uqpLLivx58sA5seKPIRAZH1w529csj0PaZ4zeL0rV4zV9ZGdju55EMO94yt96qCD9LEkCQcNsqKOBpI3s9Kd4JfBIj4aZdOUVTf7tKyei7TZWuUxNlFO0AnYiwsVS4gIesA4XUMF4E2kQkhhCagUfza2/xxgfVWvw6mv+peo7cOavHwFj/Q4g24QIYYOx74NG6cc230l2E91u8/QqIVH7Trj5dK+8JLhcPJ6ovnGE0qOGqKw5XUFlmlU79EiIQxSf4I+WpmXKlSWW40jHVSs0NrkJAYtV3zcAmEh9i2iiN6Zsv6TXPdrEmIjwtLE2dnvozy0ewS+iR7P1jCqlyUHCYDnEFuxpuWVZ4wdfh9lCTA/eWZ2DbatcG6Njsvy+Oek+8+BYp8SsZUtJ+bkgj26wK+5zZKgBRCMM/gQGPlyygBaNXwJym2cj73EgSLKjYKD1eCuRyLjuE+n9Gcy8BwtWiJDOv/av1GiwyZM8WgqV8nozv68H6pZUqepijRD6734/sAeucdxDr14myT8iDjM+yCKrkTDuYqpBb+jGLvr6/UCofm0Jj/qQ+2y/FNzPdNBApa8992yspNEMPQblsIOWDtlRBwwuInc5SdDm1P21M0t2IW0+AjpSeRxGjl99au4WlsNeI+ZdrSpYkxwPSfXup+n54
 sME7zURG
 Ns4GQ7U4t5HlB6fNUnNGnuuubzxOgbr5smEkDSoS2RU8Bim4zXlhhdpvysoQ90747fekY7dVvCxdW3kY2HbTIBuWdIvSUZ6rpcPBOFl524STVO1l+TlkuWdm4rC7V6k4jh4gITybs2f64vIoRgy63FbIPs2qV01ifX2QJHW01vb78thzZhHKkAMaN/TuVHZOwxoK/9UCBXNFZPYpO5Y7sbrUib0Vx7ghDy0oE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 12:08:39PM +0200, Jan Sebastian Götte wrote:
> I can imagine one alternative way to approach this, tell me what you think:
> Instead of registering wipe handlers that memzero places on panic, I could
> put an optional registry of (addr, len) descriptors into crashkernel memory
> that the original kernel populates with the PAs of buffers to clear ahead of
> time. Then the kdump kernel could do the actual memzero. This would remove
> all code from the actual kdump path here. The registry could be made
> per-core to avoid locks.

Or create a dedicated mempool from which all sensitive data is allocated,
then call mempool_free_bulk() on kexec to poison everything in that pool?

Thanks,

Lukas

