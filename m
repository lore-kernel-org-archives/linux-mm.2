Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63308D3C925
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 15:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B177E6B0006; Wed, 10 Dec 2025 10:53:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEF0E6B0008; Wed, 10 Dec 2025 10:53:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C566B000A; Wed, 10 Dec 2025 10:53:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 97BE66B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 10:53:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 234E7C05F7
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:53:57 +0000 (UTC)
X-FDA: 84204007314.16.7D4B6C9
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf29.hostedemail.com (Postfix) with ESMTP id 14E16120006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:53:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=npvABpqV;
	spf=pass (imf29.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765382035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gu+cBRcg8tNEeGl6figbDsVmD/cE7Gdc4leREM0GO3I=;
	b=2gCqaR46ft7fPRKH1V5LkUP52UVWT7PJ203wDAuiBj3jNI52bw4SMyBeRnBmcLOBTvOxas
	YeDXZ//Qw8nHhETvtyeq56lybV9+y6lOHJMN27f4J+nrBPepMA3+EoAxMaYkCQ5huHcgWr
	rBCRrSyorReaPYWfpc7vO9prGVPtUqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765382035; a=rsa-sha256;
	cv=none;
	b=s+kynJj/78LuZv/QbI62KZtjoCNd817FlGXFbJudCxijkIL7gX8x4Kv5p3365ma7zX7q11
	3kXyreUAYNeJxzW5Orcj0OrgmAKrvl6TdV/tbZsx6g4+JcW9igKZXl7G1KpTI39iLPGW2t
	ZOjY0N3Ei5o3R759zDQwo4Jd+2GA7/Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=npvABpqV;
	spf=pass (imf29.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 10 Dec 2025 15:53:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765382032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gu+cBRcg8tNEeGl6figbDsVmD/cE7Gdc4leREM0GO3I=;
	b=npvABpqVopgh0Tb2BbPoLJjsiS6VzvhLSo9zzDMMgRMDd0+McGQsjc1RdJan15mQdPLffd
	4DBIOwEnLDBM1hrhbaHETg2ZoKYaHat25tEurPfKB873eqWr7GQiF6R6SrAOjQ23Wo+ruG
	B9Ee+P9Bdx0OF5wtiJzQIUpzvk7g9BI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	SeongJae Park <sj@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"kasong@tencent.com" <kasong@tencent.com>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com" <clabbe@baylibre.com>, 
	"ardb@kernel.org" <ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, 
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <ysfladvqa2hkprl7teggrxbr2gzxvvt3sfdpey5jz4wfrxdcrh@gznyrek6pzgt>
References: <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
 <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
 <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>
 <aTj22_idykAfpDNw@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTj22_idykAfpDNw@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 14E16120006
X-Stat-Signature: 5rtiqywsobzwaek7pze3o77q3hozr1ur
X-Rspam-User: 
X-HE-Tag: 1765382034-724300
X-HE-Meta: U2FsdGVkX1/XIExKMWnRvcMv8uCm9bRdF6vHI9EswAykYhxKth9oGNw/JjasmjYDC33HZBwZzVT9R1wi/i11ed3J1BFfjndy+OB/AU850o+O338hVj28ISMWu2gQWKw7xa+IG2FitNjJQgcSSUsrOq8xYZ/slORBpahDPk0w9sY+laHto58MHu0dUb9nDA/NzuU5THPxwhzsYS9TfkYES1KQyvShPMxlo5XmjO1BZzxAHKHqp4GKY6UgyxhmuKVlgWnVYRL1P97K7/hxKXseZ/2rW0QDGxW92GG0zxWW3+ZKn7m2vQcAmOPTB+CDjT2QbUnFOSzpkXyH3A7KtCdJVY4DuVywnoytyykHwSrqWSF4zNVhoZeCBf04xwk3+Xcq/HemoKvTJ0+KDjNDdspo83pGjzscL9MuFqwpwUn/TJQHZlMSUXxKNrlF0VFAht+i4dUuajm4VVqZz19/s+63Oznf2B85QOdSlXJAaCqWfspuNXHyomyrjh77LVglQ0O/KYIHrRPXxg5xmmcKWZHQC83KtBwqH5iHzcjx8StE7c+v99k1bwLUKI0KyoGIBHpENUq2gYaJVDh3kO64IwUYlVngTd8W2fKQAEkVKVyt9L9Rz3suZt1nPycMMAz6gRVVgqKzJiaSLROuP3wv5u9tMMAeiMYE/U0zXhwi6i6N7LYf7pWcUjDprtASwDlIM+b69xjnqMv06QSeEfCujwNnkRHzV3Q6MlWa95H5o+6S7vRdrNrR0rSb0K383w5dOolkDpbJKiahhgq9BfudmEpQD44rY2ltCha1tctDh1vu6k4aBKUMDZA/tMYeUrSKN4BW4XHgOXx91RxnEm/WTJrDgnEVtYxLeZX74jSnkgynaPExD8n8ToYhwEGpoo1gjMnHNwNRL89l4X8AKXb6TagmsG12MkpURTWVIVWay8kem2cghSI/f8Sxn+3TSp2XryWe8KR/lTA/s2FEVlKHBhA
 VJHC5oYW
 wtDfGU4pDsqdFeAyi5+JS6M4LJ3wNDtuSPa2kFwJZDaIw1U+m1hjNmzNSdxF6moRvxIC5qr+KrWXsHtv8b1SXjOVHdG67v6JVQn5ktIXbqz5uQ+1JuzkY7hWsUy6b3gj0FaISe3x2xgcEKEkdZHOFB2OPpAI/0u+dCM6AhmUtSs/h16RLqxBuYEtX9OmMMSpLuoAt04Kc58WQG3EZZCYHaBq4yNEYlANDjbKncyqHvj4OPW8IX8jexfCQWNcYGceTUUxlX8r6HOijsf87gLFtMBIkBoUUd6c4szfWnf6Y/ZI7kJ9mzU6PIBiBxq0WnkrIz2XF3Q431ekKzBlHjjhqXR433RUyaIwx5+A+OX2rQmv4kyw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 12:28:11PM +0800, Herbert Xu wrote:
> On Tue, Dec 09, 2025 at 05:31:35PM +0000, Yosry Ahmed wrote:
> >
> > Ugh, yes.. I don't think we want to burn 7 extra pages per-CPU for SW
> > compressors.
> 
> OK so the consensus is that we're keeping the visible batch size
> attribute for now, which will be set to 1 for everything but iaa.
> 
> So for now I'm going to just provide a trivial acomp fallback so
> that non-batching algorithms conform to the batching calling
> convention for a batch size of 1.

Thank you!

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

