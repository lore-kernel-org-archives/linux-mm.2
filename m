Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9825A606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 05:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=IG6kP8Z7
Received: by kanga.kvack.org (Postfix)
	id 8F0D36B05B4; Thu, 26 Nov 2026 00:41:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDAD6B05B5; Thu, 26 Nov 2026 00:41:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8055F6B05B6; Thu, 26 Nov 2026 00:41:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD796B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:41:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8CF21602AF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:41:33 +0000 (UTC)
X-FDA: 85476172866.11.F7B131E
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4053BA000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:41:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=IG6kP8Z7;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf25.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795671692;
	b=QcmyUPr4qt1hltqbZXvs69v4JZjVf2eJox2THSrna+xTzyy8XMpL7m5Hz85RIGNK4Z0dBu
	isXCLnjoypfM40E28K6iSuF5vjYGxRaMiDFLOg+1/7vuLzn/Tb+Xif1lTKpVmhCGd1odR9
	+8XFYDJSr6iv7y25nrUmbhuHJypUhw8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795671692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lB5Z2jAXM1MCahZXaWDYMLFa+FaZwYx21kct5EFKyxs=;
	b=QVZije5hCB1qZgEkLKBqqpsYtaOqoYo8FLgZ6jM7TJ/nPIUBQkqiM3WxOlq7lj+qFCN6nu
	6ycV1kLg4H1uCDNDAsn+7iSNJeXUFc5SmaK8AEmciKmngCb3AUtUDSSzPcNFtiHpYopdXH
	QH32VLcYpKm7LxQKMfz2wg5r3SBHBxI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=IG6kP8Z7;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf25.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=lB5Z2jAXM1MCahZXaWDYMLFa+FaZwYx21kct5EFKyxs=; 
	b=IG6kP8Z78B1+GAs3HdVj0OF7xN4BFXwTmMwOoZcez01WeFEZrA/tC5S6hHti9gLbezGKIBVG3rh
	cjAjMgwZ6UQi+6LcVu54fAAj5TOVTlN0TaeHvc3HaSFPFCSEHcU8DxsBne9pH6bVJBnVpLi5Q7EG7
	XosjJVl6tpkFHAR3DWL6yMSzrWQYZlf6Wa9YWeeoJluJNuck52OmcXzm/gee0+69R8qo5C2n2YlRE
	WyHtFm5yaTaEl+EMM1LI98g6wpdjLWBLcWQiUQkOOpIyVvh6qREeXna87cgGs+O3b4saRMJoso9cB
	somkNjo75RQeIyP7bTDkZY85jL2HTOh07+7Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWSEQ-000000029BE-1eI1;
	Thu, 26 Nov 2026 13:41:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Nov 2026 13:41:18 +0800
Date: Thu, 26 Nov 2026 13:41:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
Message-ID: <awfGfqMK8FfrMNvz@gondor.apana.org.au>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-4-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-202709@kernel.org>
 <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com>
 <awQCFZSSng2LLGnX@gondor.apana.org.au>
 <CACpmpocCqenTNv62dGoeSLP2zs-AXJYhXM-tj2cytm4zQTj1cA@mail.gmail.com>
 <awafBxDtUoIQW9iR@gondor.apana.org.au>
 <CACpmpocWW7pWGYiF==DupmZDB0-jETu32C3-9NYY8nssKcDm-g@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpocWW7pWGYiF==DupmZDB0-jETu32C3-9NYY8nssKcDm-g@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4053BA000A
X-Rspam-User:
X-Stat-Signature: 31nchecyjptg91f8r389wpu13qric6nq
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795671691-153602
X-HE-Meta: U2FsdGVkX18LxeOg+h8ySRkWagTb8veNi3Z+yNNerAL6vig60xuFI8NiLmUKfzailVtClyjetxNBT/6Ip435nQJO3AEojOIsHSIxTHCmQWjYmWgMuCSkb69VyUf5iuIV38Co+GAvnBKTgm7thZgTiRe+iy3/rdnn3T7PrIOtO2yyejjq5wNxzcc+FGFHX/vLUglyaVmSBf2qnyA/pMLFfznvhqIK/Ci9hLXA25I0WRGQ706VCPL3R1X0sUo7bSlNFK6g359gtM7at+iNwqVhJjPasVigUEhGeu6EXM3/LjmjwcS7RyFXsnHYzZxSm1/F9OfFSYtiPU3v8ctEjHhOfIxyx/V9PVuOOVuYH+f44a4c01ixsFeiFLfFQ8UEdV1s1XRHpAjqWr8rHPUtfaZTgLs+o65X6v/gYXHtWonWx1ePiznU49ss8vGxkJgmc7KH6dp/+DoNjzcCNt4BDzQW+7cVdQGeSGZLh1fb0n7TbxTlqH/UBEz23aoIO5mJ0fFbuv/AK9zSxTuyb0mKD+IPord3jCDhIbcCEVzHr4D61pgX+fkACHPoh7wz4jNPJ4iXIeMMkdgz03CByEYnD8yXUmk0mNJ/mHp1qTJgpdBSuo96xRlto1IG2zbF3LOC6lKHdhXw8oK7A7VhJrh+0KuG7a4GiGuZKoQm0IvTGJauRAiQ2yCwgcLzWriZNgeCVpG39pDuEztuos+yPVKT0E3y1zwKbJrvAqfgYBqZeW2M/YhOMpWpb0jN51GJyXHpUDH29j1YkUB9m5dFQevECv/pYr+CHX5JW+nTiLHeMmRIWlRuX+ZBHTP7lx9fcfNPxHHSPHz7cqi8D2zrSxIEEEn0CO6sc3RScuNl0bjV+giosBVeIteHXfRQQ1+j3GFWHLHcy/qRZ4dx2IHGqcAVk4VgyJjviPGgjdgZ/Cwms3RbUhzTM8cq4Brxz/hS9r7L7UP0ybSYsvaoKlGx3DGBTVw
 65WdzXeT
 nVSwXbgvBhCYNffA1+ZZLs61L51lGmY6Q2wZXA+syBsH6FLFhx+Kx7kKzSpKSr/jap0KV9emTSzPKlD/FAhPiIjojMkvfNwsZmbFyAO3AIvA5WBjJ5rJTPnPqITR40krXgaV1fNzfzHXq1PPUCkfR1Fe063E1Rj6fsoaVM9FpIeykDJXNEaWfEB4QowW6dYoOkgveYetbwvzKNQlKigEyJCRGYu9+xv7tVLpVVYXQAsuWczjUGL8dp/FdIwnF8f6SQ2zkt+JBW7IBTEU0Z07yAPrjMg015FC9GMbkU531PYkCKrlju9qWfJkQZOkoC8Dz+0wyQ5noWmN0J1s5dx+rYmQEmZxj4cRg/8JMDX9dyyxts98FkMuJNEsv4G6We+ckD8PtQz1sbIdN/f/CEK3dHbPPl74LEZe5ANgDZPDfRPB5nNV37Fi5vHzebw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 11:08:20AM -0800, Kanchana P. Sridhar wrote:
>
> -       if (unlikely(req->unit_size && req->slen > req->unit_size))
> +       if (unlikely(req->unit_size && acomp_request_dst_isvirt(req)))
> +               return -EINVAL;

This looks good.

> +       if (unlikely(req->unit_size &&
> +                       ((comp && req->slen > req->unit_size) ||
> +                        (!comp && req->dlen > req->unit_size))))

For decompression, shouldn't it just fail unconditionally since
we do not support batching for it?

Also how about moving these API guards into the top-level compression
and decompression functions instead of in the shared path.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

