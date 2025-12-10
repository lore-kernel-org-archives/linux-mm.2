Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B81AAD2CE17
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 04:28:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 250CF6B0007; Tue,  9 Dec 2025 23:28:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2013A6B0008; Tue,  9 Dec 2025 23:28:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E686B000A; Tue,  9 Dec 2025 23:28:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0868C6B0007
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 23:28:23 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1B6558941
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 04:28:22 +0000 (UTC)
X-FDA: 84202279644.18.3CF234B
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf28.hostedemail.com (Postfix) with ESMTP id 10CC1C0007
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 04:28:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=o5UKxnlY;
	spf=pass (imf28.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765340901; a=rsa-sha256;
	cv=none;
	b=OUMGXMlOc8x27Y6Vf318qCUQDSgoCLHLb6WKVcU4yWLsPpr84y8X8ZdBP2KEy9ZCmTPZpC
	J9ee4tPQiDwlz9mrBuhvo2O8f9NJHX7wrin6aJSIFyqbNsghlRaYgDOGp5nLbI4nfpAUVf
	xGsZZLpuY0bAhxewvMwGEBmuwsRyN9I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765340901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQfWpBVkXWRGjFGQWDDm62eANx/f67q4RwxOcophSOU=;
	b=VmusFrNt8Dggp78yEMPbK195YVMZndK0m4sZ4hwv5R9BLG2jwELZAA7jCmH2ZmC1gr9ais
	XoT58PVRYRskUrd5/QWw8jNRcgtVWTd4aYvZWTbP4tuuz4Sn6pbqpbu1XOH0oxOCsCZ6bd
	UproOALDUceF6qvRUl0P/s9MU6adNQ0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=o5UKxnlY;
	spf=pass (imf28.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=OQfWpBVkXWRGjFGQWDDm62eANx/f67q4RwxOcophSOU=; 
	b=o5UKxnlYep7lSUUwWim+bLfjwfHoogk/yS8buh8k6PyJYw1yI5o6xGQ9xBQJDxaxqQANVQFK9MS
	505DVNridkct6fi2LwX+dcbHT8Zq4RsmktcnEUAPY3riX3DBGZH7Ai/GcTpRKQy0Mi00E0yi5iH4f
	p93hlXyZI+84CNmdpT0aQeXxiOHQCTm1OI6FTDYurbMnxQiyRk69S8QsxiikKc/9vf9jAZufSJ2bP
	TmGRNBGWpDmHcaMRlezqlqasklsa5QitG7FAfkkEqVYQD+AnxHXVxQqU93AFSElFdXBpuKrNqakad
	pA+tUWzUMnBJfYiaNNefDxgrZU6Zoe9o5blQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vTBoB-009Bre-0u;
	Wed, 10 Dec 2025 12:28:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Dec 2025 12:28:11 +0800
Date: Wed, 10 Dec 2025 12:28:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>,
	SeongJae Park <sj@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"kasong@tencent.com" <kasong@tencent.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <aTj22_idykAfpDNw@gondor.apana.org.au>
References: <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
 <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
 <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>
X-Rspamd-Queue-Id: 10CC1C0007
X-Stat-Signature: z334f7ob67s43q4c3bqykxw6cfpat657
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765340899-324136
X-HE-Meta: U2FsdGVkX19XrzLuU1ZQNSrihkh03Fsw9MQOG6dJpUONziwXqxk/c4WOKZP3zAR/XhfdyMtsmgkmLIOghRakkXLQMMYmRZFwgbSVO7KfRWbzcbRSFWfXqY3FncfPx3PaOUjGBkepuMdfqXA+l+DEUEaGPOS6qDU5KvXiKVc4xd9BMEHCYpBqJGXVzNSz1cDlDW/7lI2nO9Ud838jgrc3GnILN1uAuqmrQfSu0gbfOytT7YfeKzKULZJ0EuuyZcAahmuVLQafZbqR94NE6eqgCJOENwbLVKn8f+yf/oBK3Wc9gysvXc+/75+iM3CCgeJRQnfdFzwpfmkuKY++KsQrQgugJ7GdUQjIYCLDU+kVDrKvTyLPJbawV5G8gHJDBsTnnSwAVQEs1WwcGX51HAT5q97Kk9QJKeAPz3ar1u4U59aRn/YAB2QIL1pXUAs6OXprxpLvv5/wpgxrSRlkyDJL/ZGAdcx2WGwZBB0jdz1VROtilbF4JHEx+nsQQq+Ro9Y0dfVFPj2AUYNK5ulu4B5RsnL9hKcuVs+2UjyiuAUCFxCRx5v00YrTEs8WM+ROFsmz1Xn/zDa/F7FROW7+x20vIn6QEGpita3fyQp/7CNn17VAf00QOODLkbZyzBHyhdO44WDqlWBcrLm7ZS3NKgZ33wVV4YaNmKiwe2s2OKDVzajmxtQUhxZEQNBLMvT7azv1ltS6t/Axwu+jVHSio15b8/ERWO42mzgFoooE/KfCyDlCLBqevxl40buL73Lh6Zqn2NgCfy1Vks/j3qitjcUzXVbgdYLn+dNjIjyEt9sjwNcpO6DQKlckfh/RC0zByn+Cdv304NEEel2k3LKy5KE99NSRKXc3B2rMB4NNdQ0nYO83ewpCQDTFcMJP3vCTflKL9WHXoa0Zgn0w09U96/DOHzhE8bWd45Hawcmh0Sm1OHTTY8AMaruDjbJdc3vNe075j0LlKhxGlfuLVSFvdeL
 I5xIW6Vh
 A0Q84cGMEkBwDe3HJcO/4zOBMAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 05:31:35PM +0000, Yosry Ahmed wrote:
>
> Ugh, yes.. I don't think we want to burn 7 extra pages per-CPU for SW
> compressors.

OK so the consensus is that we're keeping the visible batch size
attribute for now, which will be set to 1 for everything but iaa.

So for now I'm going to just provide a trivial acomp fallback so
that non-batching algorithms conform to the batching calling
convention for a batch size of 1.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

