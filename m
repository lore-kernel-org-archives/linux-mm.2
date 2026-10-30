Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2467606A320
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 04:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=WBlc5iUH
Received: by kanga.kvack.org (Postfix)
	id 8E7EC6B05B1; Fri, 30 Oct 2026 00:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897B16B05B2; Fri, 30 Oct 2026 00:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789456B05B3; Fri, 30 Oct 2026 00:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57E376B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:47:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53D4D160559
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:47:32 +0000 (UTC)
X-FDA: 85378059144.21.E3CB303
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf29.hostedemail.com (Postfix) with ESMTP id 01C80120002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:47:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=WBlc5iUH;
	spf=pass (imf29.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793335650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQr6UKipqGHD6zd99UaEJhP6rQntCtcMCzTwi45iBbc=;
	b=R11B3bDVWrFQKXYqje8TqtR3ef4NscF69ZCRwbmcgfisrDb6aoz3uNFBR6EM9Jqt2dleLF
	eUqrG+CGV4kvafVydHAog/ikcfuQro8qZv4lleXcu9Qp+c4kTRbgBzdRHl/4q2wRBbLPJv
	mfuz8kUSScK+atwH3fBn83nLx7l9Ahk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=WBlc5iUH;
	spf=pass (imf29.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793335650;
	b=6xt0TWcCqD+Pjb16DW3TCTGyrfbP9FU1rlOzuzSHKGgtvs4FW2KQR3nzBLu3K8QNLgsyKO
	Y33OFCnvAxIHH8xMy/Memv0ElhGH6XOHZZYdQ6GEUOvEIcCWS/LUdAIhhQNbn3OrCA8KOd
	HIsJThGysDxi/ocr7v2MZK7sPS72lvY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GQr6UKipqGHD6zd99UaEJhP6rQntCtcMCzTwi45iBbc=; 
	b=WBlc5iUH4ZDNgDqQzfvydJR82aAnMRBPMkhjjftiwO6DGu6+UInwDgNtZGItb5GeJrIOQbNItgW
	HT6hXh8wPbSbK+OLUPy8vx+hocfuWagmS9gq4o2uKg1dliS2kNFMGHlaqHqVDYb0WoMzZk+x4jmjq
	oOq8AFCh1N5fwz2ly7p6yWVURbwU9K8JvKLI/Mc1LX7NEiCAoaIxOO0x99r491CEMqu/zmuF7K5CZ
	/yReOS00OCClNr0jdqh9ql4Sdxwwi5k4tOmJWhR7EB3+ng4cg2jRFMDUxOw/K4ZfJIQ6nmeE9P2m0
	rpTdPN3KSzeaQUK0yEMA8h3Omkce9oWOC8ag==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xMeWG-00000008yii-49zp;
	Fri, 30 Oct 2026 12:47:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Oct 2026 12:47:12 +0800
Date: Fri, 30 Oct 2026 12:47:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: sashiko-reviews@lists.linux.dev
Cc: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>,
	hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
Message-ID: <auQhULh1VTh6lWoe@gondor.apana.org.au>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-188658@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-188658@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 01C80120002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: shkk8gfp6nghe71mkgm6iim7sn7krs41
X-HE-Tag: 1793335649-172218
X-HE-Meta: U2FsdGVkX1+ESO/pNapReaYQ3uxo2jJeXrEiM8MiY3vxEqBKACCgkd4PsDLsbN3vitv1cxB8GSuYZdMweLdeGBtdr3YiN3uM70Q0ZTog9biEwBnOceAR+V44ALVLHealj/B9m/K67AGVEwVk/csnIKI0uriOdMTbVGIMk9qLr61KzOcpWPae7LzgkJ7JFqy+S42eTPV4mSoKhCDRNCAIM1ZaWT0X0B6AfvnxeO1+uyGCad+MnRY8/5NB+nbBFkCNUGWfcJ4UN1HB0DMH2SKjvMMF7KWQuE1a6VVs7QvQONZ7nVu8y+k17Z8+AGQiFIpA8kuINVpbzXD2VcEBVRLtrwbvYqPLgX+eNc+dAskSABqSpQI0Y+QThk7h8i8wzTdeWzFNF8up8tM95dgFukSc6NhwdMuamIh1UrBp4DSYagfDrFEtDaD2IrPJnA/fwQdb5YCc4LylV71fm0aYZeoIDJqVv7+js5aw+Ocyp9RWGmXgyd4Yf0fR+C3tugF7KhiFq1nqwRL2yy7dTryehMASCJjh6OOHkhwstsdmvlDl4jkwloTbvY6dk3BEPUvku33oclJXLhakzhjH+N2fvd11QIrRtmE9F8J9TqqxSWDu2l9orMZVsgy0Q00mLaxt/2UPyMxW9dAm5XYF+qBATR77hzBH53ZOdt/zrO4aHrmn0ZXohAbsaLf2NIu/BZ2K/XOwfJ+WBWUoLBr00Atpg0uBb79giZNxTzGIduGuYvuUZ54tCbGXzHZKJzKnLVNbdS/Acazw4BewvzJbj5Zvq524WLCqJg7EfQ61qPrgsLRpCAlNYK10AlZPRk9+P/sVWOOK8Qc9a6YUwS7MNSGDwsz3t/pcHbC2/Sd1x71CUaTSTAt064zq8soYaw3K9GHK4GvcBd7sRWbFCdX6Rxx8u2m6LkrxvKfODh6IyZJd1pUyl31dgGWXHz/Z4b6e5juP63hWMoRucY0WrZQq9hTPCB5
 JoWWe0Wi
 r6KY41NMoymgozI878UTAfQVS7MhRTDDqLdQUkKSL+oC6TRus0bsiXJ2be7kMoGGH49WoMmb9XEP6rsraxw06jC2trPgdTKHcTYffXpOb+BWdL9QCLHl6QSyD3mJ1xefonXTpz25UhC8cPqMxFdC5ldOglX4ormPs0GW5UwZq9Nbo1p02U1rnn58s/9GOQO4zBN0oNxk1wleoE/HDptR4DaG/qhTRGAhW2PsCT8L/NU+p5Lz8rJxR6Aho3NUqWW9Q+xn/k+OF0Tf0oYnI1ICxJPWWC/X7SRaEYwKvKyV7z7rmEHGP079vc0br7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 03:06:03AM +0000, sashiko-bot@kernel.org wrote:
>
> Additionally, because each CPU independently calls crypto_alloc_acomp_node()

Why do we allocate a tfm for each CPU? The tfm object is meant to be
reusable and you only need one for a given algorithm.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

