Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F048CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 05:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CCCD8E01D3; Fri, 15 Aug 2025 01:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4D38E0002; Fri, 15 Aug 2025 01:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2388E01D3; Fri, 15 Aug 2025 01:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7038E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:27:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D4A5883634
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:27:49 +0000 (UTC)
X-FDA: 83777859858.29.0F76B2D
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf23.hostedemail.com (Postfix) with ESMTP id 38FCA140009
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:27:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=j0CBVXJf;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf23.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755235668; a=rsa-sha256;
	cv=none;
	b=ebOONaKAZlSLBJS06FhHra2Ih6SlLwosFtHFWxsksl8AYWuMvKbIi/FPPvZ6S9Dcg8gOxx
	CLK/AlPwWpVRrVzeOmE0KmMGn2EiGGCYvfI7s+CaQhh8iC57QK2RMwtnJ1uaXCiJmuGwgB
	jcZz/jfzz6IGhoGxtq6BdcMD8QJ5YIM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=j0CBVXJf;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf23.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755235668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekkS1ZWS+pzycnB1GVKq4SzJlmTvcVcs3EVUltOGUlY=;
	b=J7KSqAAKCh73htormkSnm6i7RwBAHpyRq1Mhp+QQ77WuBy3K/cX/cVhI97Yyk9X9pxLReP
	wTkFeBsykn1yPz/QJBatvI4/XfdjzR0B0uuXgmp5MZwK8Dl/yGWDJeJ9W/g7LNOdUktc4n
	H0tXjn8KGapwgRfRVvzUPyrCKJP+x3o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ekkS1ZWS+pzycnB1GVKq4SzJlmTvcVcs3EVUltOGUlY=; b=j0CBVXJfcqI74bfbvH0tEreTBg
	uGXoDBgkX2iFqTuj8sNfCHcw5GWQ2DBDZodIUtmym1xP63ToEoWUDbMyHd+ZsHwAIn9+Zf3W4ZilS
	QzGz7UbITEWnb8/8jhmKXtdHhIco4MOqwCZujOJs1IGeo+FpXa6nBQxvF5PHTovRUvnOhIlVn+Rf6
	lU9QCxj3L+6Ord18B/C+iW/yqUDyB4kwzgn74XigyN/8Q7f+O40a7NQm0tsdWjT7Aj0EsAmFYUzpb
	307jsIMlm9iLhSk537sPKFOqWkjpn0kyg6E0M9byB8IjFZmgB97+NblQ/D3rNEkhiXMri7cZ6T/ej
	tMsjNxZg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ummj6-00ETY7-3D;
	Fri, 15 Aug 2025 13:27:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Aug 2025 13:27:37 +0800
Date: Fri, 15 Aug 2025 13:27:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	hannes@cmpxchg.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Message-ID: <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 38FCA140009
X-Stat-Signature: zrc6hyu9jqkr3cnis8zmqpe15cdcpdck
X-HE-Tag: 1755235666-995420
X-HE-Meta: U2FsdGVkX1+5G4N2xxbrwWztNce6Sju9sjq5TmWTJPy7lCJsk9fKtppZqbussavN1+DlvkvYeYZakveTRhWAtN1vJlRlPSw1asvlTAWe622fAYkSl6QQr9iyZ9uBGVmyoZiZE0nTrKUTKiFzQ/wHrJLUB69qgfgpjaJ8uU4PVJFEQT8zL5Nw35S37SlQ2RIcidMFIJqcf8fG83BbLhk2Bvc/gSED0bEAnnwE2Fys2Fzqom/rM21I1VxstU/2HoE2FRDYwOlVVcRpxmYBSDbX6lRszPffjeaTI5UrrXhHlnLgX9RgOoCv8rSJOPpYWs1VgGZDfLIxs4n3jqvTBy+4dTKtduIjmVSvYnjIoryQgAsXHsMkq6KqFl0ojC9QJUJz/EJjWxR0qVqbLNOqQntsoYOEExmMYkWH85Bsnl49ZbKxVBk058EOs3R88p8EX8vRcgGKcS+J0cKL8kZIN/6Vb2sRDE0h6rtc4W5RdZyitaOFSFugT6akTTKRy1dajhB3MiL8a8m0S2etoYNXt6pPdX5vdSxQazHe02n4UaiUrKNWJhuYDReZeIVDmcpVBJqVtfJya1X+fAGAKEbOm1yegFhwc83sJKsYYuo3IYe3h6DpVvv/UnJMyC4J6+UR/PCCirvOzG5BWjp4I401ajigiHB7hEzQTfx4jA3hoOfFUcI5UHNX3+5++XloB352m2BwSrbRO0Rd9wCcYanXlWjPi3ZWenHcY29Y0VbpWYVvQlt2yclddNfIHrQ8APUgHK+GC4Hj2aeYlNpam2lrYOTICcDLuGWSp9kEw623DEEYZQ7JXk/ybb0467IQnCp2u3yiiwi86S/2MxPffwOVgYqffGRTaKXIe5QgX1w98le27eDz4dxsjoNhorsieV1Fkui+ZMVtvByQ2HfsF1odKwwa6eVLUjGpLAYdCuUep3cKZgxUFrl2xrqxB9eZDQheUuuROi3Uu8/hBYo3BzL14nw
 Ups2iDk4
 gUUSMHxlf44O0jTPKZMLHibmWFe9g1U5l/bAQLtCcEhmzcHjuS6CRZZyY+pFRsnxcFZfJkPhX6fcxIZXUQvJAmkVL9OfcNzny4eet1/1zQL6Mw/xDSkKgsISU5VUlH1865HsDYeNVeYONlaS3OWCWZ9Qwa0mWUM2ZZzz7NNm5CPa1GI4BkJ7vJB2hp8woDxKiiQBKic+lsga/L92Icsbgsf+pH3D/AZo/J3LDuoaW/+o+tD9d+NXWmTsVNvlHvgdvVlEyptVUg8EqUZGxknULLOrFy6nHVpbBSbvn2cDsYGJWhKBCTNVLx7v/kENY69+Zlk6t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 04:51:14PM -0700, Nhat Pham wrote:
> 
> Can we get some comments from crypto tree maintainers as well? I feel
> like this patch series is more crypto patch than zswap patch, at this
> point.
> 
> Can we land any zswap parts without the crypto API change? Grasping at
> straws here, in case we can parallelize the reviewing and merging
> process.

My preference is for a unified interface that caters to both
software compression as well as parallel hardware compression.

The reason is that there is clear advantage in passing a large
batch of pages to the Crypto API even for software compression,
the least we could do is to pack the compressed result together
and avoid the unnecessary copying of the compressed output that
is currently done in zswap.

However, since you guys are both happy with this patch-set,
I'm not going stand in the way.

But I do want some changes made to the proposed Crypto API interface
so that it can be reused for IPComp.

In particular, instead of passing an opaque pointer (kernel_data)
to magically turn on batching, please add a new helper that enables
batching.

I don't think we need any extra fields in struct acomp_req apart
from a new field called unit_size.  This would be 4096 for zswap,
it could be the MTU for IPsec.

So add something like this and document that it must be called
after acmop_request_set_callback (which should set unit_size to 0):

static inline void acomp_request_set_unit_size(struct acomp_req *req,
					       unsigned int du)
{
	req->unit = du;
}

static inline void acomp_request_set_callback(struct acomp_req *req, ...)
{
	...
+	req->unit = 0;
}

For the source, nothing needs to be done because the folio could
be passed in as is.

For the destination, construct an SG list for them and pass that in.
The rule should be that the SG list must contain a sufficient number
of pages for the compression output based on the given unit size.

For the output lengths, just set the lengths in the destination
SG list after compression.  If a page is incompressible (including
an error), just set the length to a negative value (-ENOSPC could
be used for incompressible input, as we already do).  Even though
struct scatterlist->length is unsigned, there should be no issue
with storing a negative value there.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

