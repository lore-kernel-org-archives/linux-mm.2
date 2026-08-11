Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5172C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00CF6B009E; Tue, 11 Aug 2026 14:20:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8026B00A1; Tue, 11 Aug 2026 14:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE286B00A2; Tue, 11 Aug 2026 14:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0606B009E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:20:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30FE8A199E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:20:19 +0000 (UTC)
X-FDA: 85089803358.17.39D2515
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 73B0B20007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:20:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUR7edvf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786472417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82HGZsPxUpcnk6FVJkVR/8JEXad9K6uAipsabFS3WKc=;
	b=KCr6xPsgOJf05wGCYGUWG365PCIMO/aNMAwxfCtcKBIgkZ2CL8PlPoC2pTN2TOOBx2n9PD
	KVp8gaAMlAtc4ysTli/s9VeXAmmrgzsMGn+3yWZPjn93p3Vd3cdbJCGqGmtKW3eV0QJJpu
	CSFkGrTHrKbbpNoojqbqDUv9Rszws2E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUR7edvf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786472417;
	b=O/Mw2k30QX48WBUBkO3ARJxw9DyaTyBygjRg1nNCKEiGy5II5Dgk9i5OJcKe6KxvTXCEZE
	g7DzF0oBTzHLmNU40fhjpUMOTZqDgVoVx99Usf6wuqmxj0JhWXdjGQrgeDFykYHzvaNGtH
	JarpzIUp/JUR6ucdKm1dvCNH0Mh3xhQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8195943C21;
	Tue, 11 Aug 2026 18:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFD51F000E9;
	Tue, 11 Aug 2026 18:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786472416;
	bh=82HGZsPxUpcnk6FVJkVR/8JEXad9K6uAipsabFS3WKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LUR7edvfMpZPiPQqCKTxT7C3PKhPuFxcyN3AHk76XXbKOfB1CBf4sTCfdKV5Ptp4R
	 B0Rr4m/ibr0q7uguVB5xMvUrzpA8/e+L2+D9mySRGX5Sq0cqu+VYzXeRVwQrmn8234
	 LLnbTRtpZli/PRucZ123m1vW61I1Ec7S9rn6NHL66Uz8AgA+u1osyHEAldC8tMp/bB
	 3BQBwPF2oCqK3n/Lk1m+IdZa16AC9fzGUZA/cJejpmaPF4+nICKJrHugBAWx1OXFHB
	 1g92/VYVXhZEus1ZDlSComjJTk6nmL6YLxSHx6h3SPp+ggcFhbtYmnXS3XfL7840n/
	 mAUvBvG/OpnMw==
Date: Tue, 11 Aug 2026 18:20:12 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <linux@jaseg.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
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
	Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
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
	Simon Horman <horms@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
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
Subject: Re: [PATCH v2 00/13] CRASH_WIPE_SECRETS: Wipe secrets before kdump
 (was: CRASH_ZEROIZE)
Message-ID: <20260811182012.GB2895176@google.com>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
X-Rspam-User: 
X-Rspamd-Queue-Id: 73B0B20007
X-Rspamd-Server: rspam07
X-Stat-Signature: 4fqhz6t1mhfqwnmgpe4fnnyiegmqj7rh
X-HE-Tag: 1786472417-420074
X-HE-Meta: U2FsdGVkX1/EX7sLGgTVx+r7JiJ5r3dsaR8h5NHXpuT2MDtKDl430KKCLOVfb+oUKMmUfkcZCJAtrqojG2DK/4LjX9v7ezQPgPiWyy80FdMUHozieEM9dmum1pNJxBzR6EQcFB4/q99fC4eTDCw/rJx3ff20ZkqB5OhB6nMv9rJRFL2JA2evN9MfYHWik7tKxLgUUsu8zpYLEUsBXoY/+pFoOaK8kj2uw5uexeOOgUhU8AThXvMdcoaok7hQqY72tI+GyfuggxCFYrq/PD0IggnTb7L/JVc8tgEtnjlZftoaBeRVo9Q9RsdipvIp5kEVNDimtLCx1mosN1CnGXUhKE340nHcxbyPCVBdnvYe8pjpdgPb119o7kgrDLE62t8Db1eBsGGiH+JskTD2Ua0ziE6Pp8l2aEXwnNvVLYdD8lt033lUfOHMGH3CQ9uoIjGP/qa5n9XMa7fTLYFxBR58c66wCWtuNaWbQ4S3ZSE5TEAJeSHrw0ALns3lybF701nRyQ/SaJ0zuvKBVesFqMq+wWLEPipaKvIDpR+x+N0bUA4VG47Gr+N082HPbtPgWuDt5fHjb7gC6YdHwuo5N7NC4Ecb4vDuBITfdQYio3Ls3DHaFx/vuSVijb49rECnYb76xUX8bqtJMIyLOE5GrRibbua/c9kuaT04goGb3ztLipX9ntTWqErZDZKHEJj8XpUvSnu7iR5JMub99vk9aUp9OKkbTi3roipDkb2RTrhQgOKvuIMoIDqrYGx0OhWdiB8P9I4665wUyEfanliQqgLHy4pGbdbJlf+Clo3irdsnLkBF0rNhv/dU42bw2ffkKuJOw+2w7xMm5fyeKVevzAmr5PUpUgkipIM2ePdqsu7UF8nksyElYWxd523RJOSENNuUmdTjPhOXA2aCa99WDRZMVExiOMH6MBl9CjOc+7w0fznCBLOu70CTXizGUZ9wiE4fslQnLK3gB8glukSNhQp
 x9X66eXl
 JMbeJ2BiPjWm9mRVk0L3ybgRttS3KZD+lSTHjCmYHHTV1aYj3EdE5mbCUjiAJCEj5cmoepArPcT1YurdaMgI8+d9+wyx43zJo1HZdLpDkytDplHTdgac1zABeM0eNNB84aAVL231ZANbxX/jC3sdlbvZg2xNILNQKu2e3FCTK/Dsa5w8V4tPtPRctRatJ+5Y20VuLkbhKedzTktfaooXYfYBHM/PRWaYZTdaN+wAd67Xs9CI6wMzgLvp4tY79lX6tlybgb3qKfmqWJ4XnzKe+EoQXkNNNo0iobYpVe+daihRFtvEbzBqZkxnseIu9NZnZbFcin9RkUTCPz3WKMwYSwK6/Q6y2D73x9/Ah4ymae44E+3e7iwks5D6EQSbSoMmieOBIyUJkAfrgT//vhdefIGKEX8Z4mSkFoP+FqdnkOlA4E1eiBx8wtRoL/468rF+czUpuRRN/XxNuGow6HTbLEwo/aPXR6T/Ki4wrKcX8UuzCFym6jUGQk05EYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 07:52:49PM +0200, Jan Sebastian Götte wrote:
> I'm using linux on an embedded target in a Hardware Security Module-like
> application. One requirement is that I want the system to be able to
> quickly erase its memory when it detects physical tampering. I'm
> approaching that by using kdump to load into a small payload that
> instead of dumping RAM, erases RAM from start to end. However, writing
> all of RAM, especially on an embedded target, is rather slow. For this
> reason, I propose the mechanism in this patch series:
> 
> Add CONFIG_CRASH_ZEROIZE (default off), which when enabled makes various
> subsystems handling secret data do a quick, targeted wipe of these
> secrets before kdump. This behavior might also be interesting in cases
> where you run a normal kdump kernel but you still want to keep things
> like fde crypto keys out of these dumps.
> 
> CONFIG_CRASH_ZEROIZE is a best effort, defense in depth solution. There
> are circumstances, such as when a panic is triggered after memory
> corruption, or when a panic interrupts some operation that mutates data
> structures under locks, when the kernel cannot safely wipe some memory
> areas. The handlers proposed in this series will just print a warning
> and skip the affected areas in this case.
> 
> This series introduces handlers for the major locations I found where
> having this sort of thing makes sense. Notable omissions right now are
> the Ceph and CIFS subsystems. I have WIP patches for these, but since I
> can't easily test them right now, I omitted them from this patch set for
> now. Currently included locations are:
> 
> * various key types in security/keys
> * rxrpc
> * fscrypt
> * dm-crypt
> * crypto tfm instances
> * secretmem (which I'm going to start using in my application)
> 
> I've verified this patch series on an ARM64 target using the helper code
> at https://codeberg.org/yasec/crash-wipe-test . This code stuffs the
> affected kernel subsystems with keys and secret data, then crashes the
> system, takes a RAM dump and verifies the dump is clean of secrets. Note
> that the helper code is partially LLM-generated, so read with care. It
> passes a positive control test with the config option disabled.
> 
> The patch series applies on top of linux-next but should work on 7.0.0,
> too. I've tested the patches on a Arduino uno Q (Qualcomm QRB2210,
> ARM64) embedded target.

Can we not?  It's already hard enough to zeroize keys and data at the
normal end of their lifetime in the kernel: that's something that is
always a struggle, with fix patches regularly going by for many years
and many subsystems never fixed at all.  If we can barely even do that,
we aren't going to be able to correctly and completely implement and
maintain separate zeroization code for every kernel subsystem that runs
only on kernel panics and has special constraints, like not being able
to take locks.

This is never going to be done either, with the scope always wanting to
grow to include other keys and data.  You may think this series covers
"almost everything" but it's actually not even close.

Could you perhaps narrow the scope to one or two things that actually
are useful and can reasonably be supported for the application?  For
example, secretmem seems to be the only thing you mentioned that you're
actually planning to use.

- Eric

