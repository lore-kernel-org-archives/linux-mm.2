Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 801E6CF6BED
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E17676B0096; Wed,  7 Jan 2026 00:26:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5816B0098; Wed,  7 Jan 2026 00:26:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D846B0099; Wed,  7 Jan 2026 00:26:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B58A36B0096
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:26:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64CAB51986
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:26:21 +0000 (UTC)
X-FDA: 84304032162.29.888E4BD
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf06.hostedemail.com (Postfix) with ESMTP id A6A44180004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:26:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=GJCRqXRT;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf06.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767763579; a=rsa-sha256;
	cv=none;
	b=iZfCxR3p9GQHAAfOyhAa2QTBDXgrsjt+5W5C6rpj5SPQLntLcGd1qskTaOfKuZKrlgXKjR
	DQbLKfRXiRomWeIZQnf/5knDFSbHrMRmlM90gdDwl12jRyrD+9DgCQFsd1FFpTdndaN5v0
	DkRJ/3yLWIA0sAZHXP/D3DRXjh2DVQw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=GJCRqXRT;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf06.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767763579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=An3OU9c40o4Pp3HahHmZO9Bx8vnl4b0LJZ7HTtnswDk=;
	b=keEyR5BUYQ9JpGKkvhhirW7DXzFIy2K78MDE0lgPlBlKBXLx+1jasCfM14CeIzpyMYBwVm
	aXbn0Ag0klJ088Y3dS5H8uAHYq8xZZ9t+Mzrum9aJ34CBcbOfsArTNstOXVjRYjNM80jmN
	44c++5TFRBxSWYiFm8xvaWFhmc3yY9U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=An3OU9c40o4Pp3HahHmZO9Bx8vnl4b0LJZ7HTtnswDk=; 
	b=GJCRqXRTvG2JqtjZt8AaHTfezhDpyFvN8tSVbrEWez7N79ujNdZXLZ9LCVFQZ0i7M57XlMnEvZI
	q1KHOAGYsZ312YiJ1Z73etYDinbXe+lUXD0DR98xAh4jl9HKnYT0CPmOx6MdDWw6tSEWn/km7QeWT
	WK+SCjY5nxlqXF6W8B9XIH6AJ349O4z3MwHrTEkZhtpBIBhkS6RwfZ0R3CjC9tq28X/QWqb3rj9cS
	deGUmvEqiy+A2d77Q/B/oXP+hpwbQV15tNmRDcbg7UBvmwJ6LgEEB471/VblvL3E/d8Ba+zaOtzHY
	Z4ngPhO6NZX8BBDiFauzyp+OyUz7eRusEOdg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vdM3K-00EqD1-0P;
	Wed, 07 Jan 2026 13:25:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Jan 2026 13:25:50 +0800
Date: Wed, 7 Jan 2026 13:25:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <aV3uXguDCaVAbY53@gondor.apana.org.au>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
 <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
 <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
 <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
 <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
 <aVyYuS_usi-lpHkM@gondor.apana.org.au>
 <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A6A44180004
X-Stat-Signature: ebo6uitkiimp61see4wsnasm55eiwdf4
X-HE-Tag: 1767763578-783041
X-HE-Meta: U2FsdGVkX19Uq18jM7pzv3TOVD9qqBoMeoBuTxOO8IC7++FOnVVBQRZI/wXanMLhYQA45kfS9PLC9Gdj/eT2YqKl0W1j0RK2AdzjAMUWGtPVbBvm7AST0o0ZUXJWbevWu3DdtOIrj2icx/DYpd09Ck931TlekWKlINjlhqHb2CwTDvKAx2QV06NHj7vu8Zm4lgfJhON3L5OaMV+t5rpAJqEpD9ygQ7nK65hX16qgv3sbhbB8xhG/N5ctWvg2/FHEIV58WHiBle0J58stDix54vJXij2V2/c9qcnZT8Y8kSQMbdGFmMakyw5bV5q5hHM66rOTAUIMPQDO8OZqrD2Oz4m9SwctRsm47r0F1/AhT7zaLVrgx4H62q1oT7n+5zFzbxF8aMvWHRDitR71drN03uTdXr6vxS3BX0oetjxemvY9MuGEo0Eo6kkkATJkMsOIXsiN4ls+xsW/qu0t0WfnV0NePYTJkm8ElxoWj4ZkMqYhA7H99UUYBDCmeO3LRF3ily4oJ7qFNUlo2YEiY7YZM6i/wngTIe8z+bPvPScZ1I0rzP9/XwI2t9LkKqTVFA0kVMMCchHdBAujQ6TNg8HNXMxgaa20rWsdPoct7n3EHEPaMFksyG9U+HSJMxjnZFEoD3ej/mQ0sJSxUgszYZ+XcnXnNGz11pvGHfGeCb8UauEVJxDuWNZINfI+03qKS1VriCZAVfDM94OWY1xdp1X7EjztwmSELSAmKQvMi6J0u0/XwwkNmoxxZuz0q44eRx+IglpUsryLUbwds5tqME90rngAvaSaI/meviXP88+t1a3g2ozACsH8q1OVB4kifpU9wQUHHeD3vAcAlhHkYTL8YHApOZG4epiTe/vozOdmU56TqIsni/rB3aXDQRQvhj5cbBkWhZTkAoNqiS4tSwtp/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 04:24:45PM +0000, Yosry Ahmed wrote:
>
> Just to clarify, IIUC the SG support would mean that zram or zswap can
> pass a non-contiguous SG-list to the crypto API, regardless of
> compressor support. I assume that the crypto layer will either pass the
> SG-list as-is to the compressor if it supports it, or copy it into
> scratch space to be contiguous if needed.
>
> So zswap, for example, will get an SG list from zsmalloc and pass it
> directly to the crypto API for decompression. Then the effort to add
> support to compressors can be done separately.
> 
> Did I get this right?

Correct, you can already do that today with the scomp layer providing
the fallback linearisation.

Adding native SG support to LZO simply means removing the memcpy that
scomp would otherwise have to do.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

