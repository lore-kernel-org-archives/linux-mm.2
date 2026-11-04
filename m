Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C20CF606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 05:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=QK0n3R8T
Received: by kanga.kvack.org (Postfix)
	id BB6EE6B05B2; Wed,  4 Nov 2026 00:27:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F556B05B4; Wed,  4 Nov 2026 00:27:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64C76B05B5; Wed,  4 Nov 2026 00:27:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 888A46B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:27:20 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7BEFA82CE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:27:19 +0000 (UTC)
X-FDA: 85396303398.13.1CBA487
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5085540009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:27:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=QK0n3R8T;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf11.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793770038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0lCmt30EUiatLfsbnSZVC7crDyhMJWqluU/myeillI=;
	b=eu+OrGuNwoEzsohHObNr2QZdStmSMkrvHvjtI4bBtwmTo0Ryawb5BT0WpagH6VYNpyk2QV
	miwqqV48okpsBhN3gxnUBjMRLZmCjad/+6Mbn9OiGp5piWk8K8BV1seVsCYodrWleAjF5/
	jMkosBt/WgSUf8UYf5P2sGXydczgma0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793770038;
	b=BYCoaTU7s7Z1XWmmEE+e/4wOC9X6Tn4zohvxQjlxKMXUnpw4u/Z7R9h3ng5L0RDxSTcYHK
	WOeCn1mqjBQNtGetYd8082uz6xYs4VT0YyOnrQgX7scwpxf+Xd04GYfv01XM6DGg+mhTGh
	+cxjL7w044LnrBTgWN95IL3CtMLnvF8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=QK0n3R8T;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf11.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=m0lCmt30EUiatLfsbnSZVC7crDyhMJWqluU/myeillI=; 
	b=QK0n3R8TKCA3wbnmyk3Dfxurzbf8yHdlTX+2PI62NNo+nne+umG/Fjw9XcSeafMgOHqU6nzLpa8
	f4G6+VDk6xERljfPHijnAzPCzOebtrFS9kqR7sl1hWFlyqm1u7xAoiNS6ja3donyQfWbQzmOEMSG2
	Ew+6nJGCE3+zJ2A9qXepeTLV8mF+/EYl5ezefzv3fvBLhLMDXnSw14KRqsjdC90jezJntIOyaURfO
	CxI3QjWmZAUYjKC3Kc/bYe/ZmoV/g5WdyDDbmKytotJp8YSJ2kEQchRC45gh4Q609NHWAQcrM6NWA
	4UdGGA7QMn1+5ivCebizL+fe6foVjlPqXuSQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xOTWZ-0000000Ajjv-3GDG;
	Wed, 04 Nov 2026 13:27:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Nov 2026 13:27:03 +0800
Date: Wed, 4 Nov 2026 13:27:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: sashiko-reviews@lists.linux.dev
Cc: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>,
	hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 1/1] mm: zswap: Move the crypto_acomp to be per pool,
 instead of per-CPU.
Message-ID: <aurCJ8wl6EYiXS2J@gondor.apana.org.au>
References: <20261103000313.13677-1-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-194595@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-194595@kernel.org>
X-Stat-Signature: xos83i8o7nrhhr8mc845cpkba3du9txc
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5085540009
X-HE-Tag: 1793770037-28238
X-HE-Meta: U2FsdGVkX1/aP78ePqWel2tzp0W6oaCqfgS4ogzzjDIbpqpvVx1yW7khb4hQZi3AT8eFTQNsPWyBHFX0HmffNfvaiS9sbNz5GvDBqBwdhHDiRgu9OZElYRyCr5JvBID6FSLhAAgHEWbsM4m1u0kS/LFhiP1to+ZPJxdx5qpjK5HbrJhjcERZUYDaN/k/rBsfIP/jZOe174pIeIKZKa3xXpPsUQCGBek7nV14eUMfMWtrvPK/nSQM1CFRQ8gL1eY/TXv/A+msarh5cPFsTXih8WoJVTR4Nq/EA+DgwQzfCpFjZyVZKe1idcKDgttiiHCJ0dV0cbgiIo8PWkAouF9e0fplntxO/U8veQUiTXqDp1d1WswoEgUJArznUojef8opmmLGnPOHjtie0t+1Y8VHUv1AFnllu4d1dKaM2UoruTfi7kbzWvG5KYACZJ9X7wWRTz1Go4dbw/4cy/6lg0veFyjlRkFbTRgtxLrJAPXrj++J5pjsln67LvzlCLZ2eWC1y5yYNV7U0BbS+xD7LqhfdNkYTEvxJhZt7vC9ujJlE+1jlR8QNWbV9cpmqzZCf4ub2CB7Ian8QBh4Ylqbsq4ynA+7r68SaW/65hZahHeq4XnAEEuSUUIfIl3fKZY51aF1Mx7TtqerHGBgmMaftlBjSB7LIkrK6QR0hwcFl7qJfFyJhuCLvNElXrsTg25MaFq4vtgdwR3+fGSILGoM/6eoaT7v3VRGT0F9bIZlXFbL1ww9vRqjDQJURD7Vrm/ltaZVxfqFzUEpcnuT8Q+U5CEVJwKrxG8gfmsJEfiNiTnzTjnzQIWhfik16kgw9G1rX6U30g1TrjTxdFE+T9YJnRJzT3KC0Zhz9oJ/6TjEp5MY2aJKs9NTxubpYqqNkPGJCM2zfxLzMDhteNqxNXDGF5y3iBQlFEb4UJIg+8OPLr/gogiZRyUpcUS4I+fiNR5brc6hVdpCIF5FrE0vsQj8BOB
 n3OZ/m71
 zium5j1edTtrp9i0mGi+Paash4FbgfBQiy4NohwTw9S9uVXVMw6/pv4kiqA8unrn+grKJscWR3S5+JL6yJ8EBCqqZhkLy9OxFTgmijHP8r127YLVPGz9xR8v8ZLROdAb4SgfX2PIRnPzUs+oWdWsNly+25UeOi3We3fnypsdDDZpfcwJUrbhQblGgWX4X4PHxQSsuSghJX1yreXeekNNkykXt1mlnmFS3wGW/gsykVJJ8LWmdCvo4LUmWukdcE2gVh3Vst+m51EN3MV7jh6bHf0vKuuBEq3bE4WXwKlwTQyWUG065Aji6SCMicbKE21c96R92PNR09Gp/5FUVT9fE7JCec54w47A6PEzcbj+cFrxYtZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 05:42:27AM +0000, sashiko-bot@kernel.org wrote:
>
> For example, in drivers/crypto/hisilicon/zip/zip_crypto.c,
> hisi_zip_acomp_init() allocates one compression queue pair, one
> decompression queue pair, and a per-transform request queue and spinlock on
> tfm->base.node:

That's just a bug in hisilicon.  The tfm is meant to be a globally
shared data structure.  All per-CPU/node optimisations should be
implemented in the reqeust object.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

