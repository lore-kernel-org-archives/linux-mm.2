Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8D0E606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0FBD6B05BC; Wed,  4 Nov 2026 04:15:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE6126B05BD; Wed,  4 Nov 2026 04:15:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25946B05BE; Wed,  4 Nov 2026 04:15:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE94A6B05BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:15:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CED4AA0651
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:15:52 +0000 (UTC)
X-FDA: 85396879344.16.E4D1FFC
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf05.hostedemail.com (Postfix) with ESMTP id 032D4100008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:15:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b2dMElOQFbRVtowHgZXN+VNpS2AR+GYKqef8wfoWtBE=;
	b=XDtHPnVl5lPjip7fkT3QRVuBHpH6TcuS9KQGvtlIe0Q8svhHzOEXAeLeIDtj1CtJwBzRQV
	9NU0LnlV2ljav7+QWwVZFVEpO/Jnee9KlyMiJWn10rwS5Or1TmHTIxDhnTJ/0ocCyHFnRh
	llSx/KU2tXySdxuyFGkJfymSTNDzYEg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783751;
	b=RdoLuQZjZmxnTQ033gH1EAHCyVWWE3u/cGMdS9d+M/6daFD3j/Fxp6H08llx0vv/IgwPva
	MQr8UQk9lJeh7w3rbFFpaZT0CakxokrVcp6wiEpEVb+18Vuc6Ja6wLzRDs+y3kkO6th3vK
	XdKsVUZ3g0Q1RT/AdtcmuBL4sJFEgdE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C108C68BEB; Wed,  4 Nov 2026 10:15:43 +0100 (CET)
Date: Wed, 4 Nov 2026 10:15:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonathan Flynn <jonathan.flynn@hammerspace.com>
Subject: Re: [PATCH v10 7/7] NFSD: drop a shared boundary page only once
 both WRITEs have written it
Message-ID: <20261104091543.GA31130@lst.de>
References: <20261103211754.35352-1-snitzer@kernel.org> <20261103211754.35352-8-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103211754.35352-8-snitzer@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 032D4100008
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: w4f8r5oq9upcz41pyg47w17kp34p4fiz
X-Rspam-User: 
X-HE-Tag: 1793783750-218506
X-HE-Meta: U2FsdGVkX1+IBK3/8Ca49oyqSxrFV+TzYvNpomO7eBCp2OLmS4mQzNKugV9wnrTVTqpmoetaR1nCgs2SB/6kSpWIPNIHazn2RTzo8uhksADC3iCGHM+ESWyCW4qctjIssSdVMLR3JE05N6h4k1Rnsldb8OZT7m3B+xQ3mCs4aQlTRXRX+iu8riKubcNyCcIbB1ogkVpFkbC7C2a/P49vx8Z0P/H+8KI0x4O5sHH1rLsbVTPqQsNAFxVwk1FT55G/wkTmI7t9JcEgwQxop/lbUgRaFkY94rxIOWSN9v+YP8QAtD2Zzgb1YUZYCrN1awrx8VDCyqk7hOq/Fdw1x+WkoTJ0f9jtXZaLKcR7GHybf9j/f1J7+Xo1cHbW1vbBGbD7dzv/GSJzeq7I//jOwvuQK/K0kZXAw9qzh3f9hZRv9eVstpTKbkxMY34PzTREECOodtKWj0NVPBJZBIQsPWw9WwtvS0kjDTQinMEREdznpziiwFHmmTma8eUpwhx0Gtj7SuaeFiQZNV3fdBwbaYdVQvcPcK2/Sen0CqJD+1Wa3Qw4eJ46pPfCz6M2Xerjx+XXfCOzt9+6txOuVNdhyJdkUewJChrsDcYwuclxlvcaCvid7b3ODCTJFA+qAkV7g7hS/2YqptkRcT8a4nRYQcEo7NrrceeOlRL9Ge4qkN1rV2MBiXlXgNd+XSN7fe19h3F/OT/RK4MflZQoUxNeaaD4oNPD1NA9nOS9qyifLFiNMS7ehs19XRoHoVCdhv1/QQhe+QBQFmTzmXjjRwvVqHA9KPcKniZQCOOhW9B0cOj8T4fur253Pgk6fwEmo9X8OY040DsAXIFBKER/ualSCyRg0i73Nrgilg4dM6xYy3ioRwSLHISwb08FMR65nh5200vnP3wtQ0ZpCUvUcjy9Ec9vts9iREXTYG4Ab3LbgFF/bDOKnrOtEU3tYuOxXHchR9BW/BnLl5CslXCaBje+Lue
 d7LBeeXF
 2dLlduTsESpvzG5wxFqlG3ZfaUEi+4PaGNIXjwsVai/cWg+hM9NsfFBSaNZHdIAElL6pcB5S05XFmy+/mc/7Plz05I72RclsFNg6TDb1SrIRUSV3n/WMCa5kIYM907SieTQr31eC+NkYKCYGKgcrAkHV6peW/F1+kFlHnTk9D4tc+85Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 04:17:54PM -0500, Mike Snitzer wrote:
> NFSD splits a misaligned direct-mode WRITE into a direct middle and
> buffered DONTCACHE ends.  Each end covers its first or last unit, the
> smallest folio the mapping allows, only partly, and shares that unit
> with the neighbouring WRITE.
> 
> Issue the buffered ends with IOCB_DONTCACHE_DEFER.  Before writing an
> end, ask filemap_dontcache_edge_completes() whether the neighbouring
> WRITE has written its part of each shared unit.  Once the WRITE, its
> fsync included, is done, complete those units with

Why does the write include an fsync?  Are these STABLE writes, and
if yes, why?

> filemap_dontcache_edge_complete().  A short write completes a unit only
> if it wrote its own part of it.
> 
> With this commit, 32 interleaved writers of 47008-byte records through

Can you explain where this very odd number comes from.  Is that just a
worst case?  Or for some reason actually relevant?

> NFSD DIRECT read 0.0001 to 0.0002 blocks per WRITE, instead of reading
> 0.99 blocks per WRITE.  FILE_SYNC WRITEs no longer wake the DONTCACHE
> writeback kick, where they woke it 23,000 to 65,000 times a run without
> IOCB_DONTCACHE_DEFER.  On a four-server pNFS flexfiles rig, the page
> cache grew by 2.9 GiB during the write phase instead of about 11 GiB.

How does this compare to just not using DONTCACHE at all for unaligned
tails (and maybe heads, if for some reason they I/O you care about
reordered writes).  And how does it compare to that plus manual
sync_file_range calls to micro-manage the I/O?

In general I'm not in favour of so many core hacks for
very nfsd-specific behavior.


