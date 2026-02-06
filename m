Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE16EEE2085
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41F036B0088; Fri,  6 Feb 2026 05:48:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6D66B0092; Fri,  6 Feb 2026 05:48:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320936B0093; Fri,  6 Feb 2026 05:48:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 243826B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:48:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C99FE1A0737
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:48:08 +0000 (UTC)
X-FDA: 84413707056.29.36C4F03
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf22.hostedemail.com (Postfix) with ESMTP id CBFFAC000E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:48:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=HWLXCPne;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf22.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770374887; a=rsa-sha256;
	cv=none;
	b=2ycOmkOctIkIrnN2yLmRkt5Je/TYKdKFe4xSvZzrXc20cnEFtYKiYHaJaX9J5PRn32rtX9
	yRfiyM1pvF+OJvxwASbBUTaZzpLLLJEZqQ56/b1vqucJwGsTTwP3Sn31Z3XLoACR70uAar
	DDmfrcjBoHH2OP1EnZOXJS5mlqchoYo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=HWLXCPne;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf22.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770374887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnLp+WfYpx0MNvkgCWm/fXSiKjmhsszDBOKmLwjwMCM=;
	b=IxALKFog9/glFdyz0qb9Nu0sA+BqCP+HfX/FB6lnXtCwgEsPSulsWczjZkQUXqqBl3AYMx
	CB+iy08dyBVeRY5PObB9RMczUQXwDpocKKjhFVtS7CBpjViN0OsNSpcBPUxHda9p1fDR6m
	AlxjFV4Ba+zebN2nqtOgqXa8vb+kMlk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=FnLp+WfYpx0MNvkgCWm/fXSiKjmhsszDBOKmLwjwMCM=; 
	b=HWLXCPneoPqOp2feilbLaD8sWXv+kMGDHjz5oVF5J6FrhZMF9zOfUEenLetiTDLcubVGHb3CP6w
	R/kYrwQPJdPGD2DX7HGMmM9dkwpo8J4oRiKfPR6laFL2qe9emMStjQtG08/cDXsgvDa4J15xOYH/1
	/7vGAwLRfRu1FgiWAk0noV7ZCwq/E4pRL39BVpZkdbIU2SX7bXqgPL/AlrNisk+q048ckcorGoso2
	JWw4WTteqABY03wXPgqiJ6UXHd4jaoG7t01QPHor2NuDeCHztvJL6icR93opPsV5pSCIF19Szh+/a
	OY1G7qcUe8Z3Y6eqaLvJhmN4WXoNGMFJEkRg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voJNV-004zIe-0o;
	Fri, 06 Feb 2026 18:47:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 18:47:57 +0800
Date: Fri, 6 Feb 2026 18:47:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, giovanni.cabiddu@intel.com,
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 02/26] crypto: iaa - Replace sprintf with sysfs_emit
 in sysfs show functions
Message-ID: <aYXG3RF4PltO9wtA@gondor.apana.org.au>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-3-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125033537.334628-3-kanchana.p.sridhar@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CBFFAC000E
X-Stat-Signature: zzui8r9w9baowjoynkku8o78pxta7q53
X-HE-Tag: 1770374885-824479
X-HE-Meta: U2FsdGVkX1/ykN65m6mbthMytgj44N9A8dhbNE2Q1eYmEqjvS9XtvJaF2Fh+W8xJlI4HqOj5WYaHWUu98f8zpQl3Ri/UJFW6O70IAsTmltJwEfmxCk0zBXqEipVRul3woaVooZGIuV5W3MBANEVc0KsewZxJqwzAHcNqyZFw1N0ILaTPLvr9VIioe+lXRR53mzAaQoEj/QgKaDi8cFAOjkBb+SVNHEwjsQMm2GvEMa10ur2LKxMl903v9FucTu5Mmn3mWZ2SSBx7inKUBhrit1uK+GKBglAdAtFPa1BAB9LHmoyKgOpU30v4VcXldirzSn04W8vSL0UFBvngFHQ8rKRWg5KQQL1180S/nTSyqk2U/K7Quw0q4aIGtvgVtcmlk4YH5uRWE2otXKVvcKj68KW6UFeTvPzs7bhBZUkuHrlsvLikSbPvfTn/7DbcrIDPHL/W1FJm6V8PZMvGLn3CsGc2N+aS4HsqbANpyP6CJEpgXYLnlhRUJRyDEHfHF94rlXm8CH5SEinqLr+R7ZmV/Ecm0qkAz6ythWO3oxrJMM0BrJJuxZ5EFRJxhCR+KnWns3Bsn6TGV5e1SNtreB7kLLDVFDMAZ4nnKDpjz/RULqEetmPDHRbnUwcefaM0/oE88vqwOR0N9w45l/DGXIu7OoBzPaSaxZKnxayeqQlumcAJxW9uEXfP7yhh5f5GGkpZG6gBHTlP+JhAbpXsPgePfq5UUBAWA7eodo6EQpRLZat1hyOoCiy3JT7I4ii/ARXW7nkohgFUcZI4oUxzBEaFO7qWvVG8dFphNtzwPr33eU3J9BMAoWwAXfiv3bw7BtXlC969dUIBhkzyjhEDn//g7qWLH5mR8p87/i6lvroz3kcnz1uLIfmIbbaDeLDx+36/vHYMBc5+4IQy9D464GyBHikKMyRzMnEoLbGJVfdGv/QaR+8cph7rrdgjpLYL9UdxCoBdyXvIbw93G/rUXto
 7I3sctog
 1nKHe320WFk6DqW2KQKIUT41mpNsPCdBcuDJzI6hx9Pj2ElswPBBT0pyMHyMdfokPSRQEvr2dIDHs78bDTzZuU/hmEPXQGm8ZCc9OUoFzQNaYfTxD6Gx9xaGviC+A4/RI/Cx/Yw+DvJd0VjzcQ9HBT7yskoFeIs7IEmBXj9mUK6JfcRVW3pqPFJmDXnAE+mWMM4CCekIIj1JL3o5heJlSp1L70WLo5qv4qtaR7FsSqMS2W4QFnDuhrP1fhmB6A5H0AarY8OrjJKE/pnm9PigQ2XPTrMmImBjIiNv2UifyKVrMkQ7Ock7miIVUskHMvG2w0Ruh7T745NIbCUYgCFm/9GFc1FkhU0onICJ4rtOF6cPdbkN3ptgUjthFjzjTjKm6LAr3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 07:35:13PM -0800, Kanchana P Sridhar wrote:
> Replace sprintf() with sysfs_emit() in verify_compress_show() and
> sync_mode_show(). sysfs_emit() is preferred to format sysfs output as it
> provides better bounds checking.  No functional changes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> Acked-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

This patch has already been applied to cryptodev.  Please rebase
your patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

