Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE77606A68C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=oVTZiYBC
Received: by kanga.kvack.org (Postfix)
	id 2EF716B0937; Wed, 25 Nov 2026 03:40:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6A26B0939; Wed, 25 Nov 2026 03:40:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD1A6B093A; Wed, 25 Nov 2026 03:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F277D6B0937
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:40:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A8CD80DDC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:40:58 +0000 (UTC)
X-FDA: 85472996196.12.8DB6682
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf29.hostedemail.com (Postfix) with ESMTP id D8FDF12000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:40:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=oVTZiYBC;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf29.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795596057;
	b=rDNyGu4rdwF90Y7B0TcKfB0RH/TgyGEVXAKe31T2fVZzOkcuN82e00pYLNjQzo2AcuRvF0
	VpoM5kw0UD49gGcfO/jMDHwv/iZtFViWOyBTnTLp1goFqi9BeZAVv+cfyv+EsIy4y919nz
	fS6iuY1p056s64X2+1W0OnP9IePCe/M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795596057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYsFcUK8+jsj7NvG+f903DGBWyTaFCEj4VNhYRMj1Ts=;
	b=npbsfecL8Ix15qepV3U2WKkypY0ErarUS7ndc68+vXEFyIjSpgsFLY1VnSKyVMyNTe8o7r
	45Onxej3AJBvOLP+pqr+e0f0fgY98/VRB5dTy48KiziOYtbR24reRW82hEMjwfoykF+jEI
	6Nt+wOoKtxp7Kwz9BX2v2EgjeC0m8+M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=oVTZiYBC;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf29.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=dYsFcUK8+jsj7NvG+f903DGBWyTaFCEj4VNhYRMj1Ts=; 
	b=oVTZiYBCgZc8JC08TT5kespwNby2k9ZUVlXQ4WERhVgTj2JpXDjezNg282p+5J9l2Eld9dCZjCT
	5pm3gqOdof2K/Pys0suDySqz82z4xFaEvuO0WjCH+Kr2318xipOh77qkGnA4efDUURjQv0bzV7mOm
	AKXNdiJfbf8eQnJaAvI96WY0vCrELboFkqEqTn4crF2aQVaY1l1JeUMcTVviXMjs9womPqajC02ZA
	YG9ZTzqKz4DGhiW5vpLVobmBy3HkmDkqOMl84B3XzabkFVSXO4whbtOV/1ahLu7WVIwJBGXVP9hC8
	JBjWuOvsec/lLSTp7WxYqqyrkXaHId2I/fcw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xW8YR-00000001lAN-2nk4;
	Wed, 25 Nov 2026 16:40:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 25 Nov 2026 16:40:39 +0800
Date: Wed, 25 Nov 2026 16:40:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
Message-ID: <awafBxDtUoIQW9iR@gondor.apana.org.au>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-4-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-202709@kernel.org>
 <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com>
 <awQCFZSSng2LLGnX@gondor.apana.org.au>
 <CACpmpocCqenTNv62dGoeSLP2zs-AXJYhXM-tj2cytm4zQTj1cA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpocCqenTNv62dGoeSLP2zs-AXJYhXM-tj2cytm4zQTj1cA@mail.gmail.com>
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: earbuschrd4hcat175zbwf866cnwbnqz
X-Rspamd-Queue-Id: D8FDF12000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795596055-499284
X-HE-Meta: U2FsdGVkX19ixMzK97IGKALwbLQuXOyyrDzaAcL7vuKZMrSwqzWo58ZuSTdEViYnYqodLUrlcULvkUfxNSojpve4LgxwFvqTuyTem+nP/rPc68EOH8Q9Mp4ZRvda7F0TQFhk1bpzYco70yu3cPmd1+W3P8dRuozxlkmCA5BFS87EXHZmyxNLKvgrHXZRSfrXPuR6UDdcC3fwrsAnga57VQO3geSK9EYjogG/K/QQlOU7huGvBfzXzy3kfNCXoSbeuvS2zMCBjYwtQgKo8ZVjMBBUlcfqfBRZgnulpIBopZGXcToXuLKeZ84Uc5GHi7aEnHn2jyfbKta/a7qySR3F0b4EpYsfoEKU29RXe7Av7z3yH3vlqFgxnQsZAGO4zU2I4m2/M0ynQu1DPHy0KwFXTolF42MY0fZVoImpUzDWHIcrQeTpkFAAb8Uv0fXZAh1LeOnwvOwV0JsUvmziI9Rg5bqZU2a24kRpfruEYxHE9ogwwnfgMiC4Tp9nqqVtUyJOVcfxOXO/TK5oO/G81NYfSsXLOH316Tt4AgHD6SgiuINAtPshwPB5zZXg8nFG2nwUZff6w7+JNfQ66VOND5nwErzX2X9hM+7x458OZi3OYUlN9liORBuTCzv3kfSAvKNjsxzRE129kQGXJVffCAK02N6F2SPBdpzVARC9wJMe4Bdg7vJUYNO10JaSd1XumF4oKe6ceRVBpX4xYxWB+4hEfuS6KNlyMtlBhvmO42wQnD589Qo4sIghWbCm0qIOmV6q0IQyzO52T2VLpteIRpw3AUE7IvE0FKA9MwZt5m3J6KLqoppkhVtUva69sOZX8PLC3vVkckuvWCq04IOUnMFqJQuigqFzbl2zaHIl4sMQJpxjUZqaMcD842wEGoKU3UDCuznz71fQO956uQn6VgPSnxP3CCGOAc8moFP5YbAEBWHVMUCzcHCARHd8CJLxpDbQApNmHdBvbgVYNwRrNTM
 ktDnrEmC
 hzk6I9WYnfCWjLftgzKGdiJsXQje7T8ZqXsd72L7mnnEkKCxx83dGI6TFCzNWV1E3NoRDT7JlUjp1tGFf/UJF65Sy1AfVfvI4pMJ8L7QcdvxDzuRSK9BeUL4zogqkQ0l5DRd0q4iEe62oHzRyHSBd06rUnlOY1K2FWZkm4+IlrNmfvA5GzSQYzGjL0B4oW1sYv8Y73XS0ZPkRJQknmOhQKzWMdegpx/mvmVcr5YigcLB/tMOY2uZxuSZBlWCbyugmwu1nU0X4ovXzoqjWDJwSAILMcDbFl9jPOiYmkBu5vw6m2EsYLJ2h6s4a2oVqg+Ig0IIv5CQ6DQc/5GGArSOR/9LWFAKNjl6vph8O/6BTMkK4OGmzX5WI7eJreEGQMtdNEsniQMzUweIH/H2G9KRQh+pj2saU5fdXKLLbT3B3nd12xnf9sTgST30Yug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 01:56:19PM -0800, Kanchana P. Sridhar wrote:
>
> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index df9e42f519c3..f0ff821b3560 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -247,7 +247,7 @@ static int acomp_reqchain_finish(struct acomp_req
> *req, int err)
>         acomp_reqchain_virt(req);
>         acomp_restore_req(req);
> 
> -       if (req->unit_size)
> +       if (req->unit_size && !acomp_request_dst_isvirt(req))
>                 req->dst->length = unlikely(err) ? err : req->dlen;

I think this should return -EINVAL in the sense that using a
virtual address with unit_size cannot be supported as it makes
no sense at the API level.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

