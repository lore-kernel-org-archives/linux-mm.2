Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D75E3D1037E
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 05:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E916B0005; Wed, 26 Nov 2025 00:47:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE9B6B0006; Wed, 26 Nov 2025 00:47:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E47F6B0008; Wed, 26 Nov 2025 00:47:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3626B0005
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 00:47:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25BA5C05A0
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:47:08 +0000 (UTC)
X-FDA: 84151674936.14.CB3B95C
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf26.hostedemail.com (Postfix) with ESMTP id 51A32140007
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:47:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b="OmplT/o3";
	spf=pass (imf26.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764136026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PiYG7KzQVU+BI4qqMtLKL4MJUBO1mej6VwEgS9g1DM=;
	b=OIcrSaNeRMaEfGSopvWasi0DlbmHx4Um7pgmDXl8QC4NniMcj/x6AbLuMh9sxIIHv6f4bl
	zZLFDxVfgg9Jxp97YX2R37kkmvsY4sJJWOEOiDeOJKu1VUN/Yuq1SZAioqcUO5sboCLkEU
	f8iai4qBYs9dlPJnwCGuMPG5GmA7OEE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b="OmplT/o3";
	spf=pass (imf26.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764136026; a=rsa-sha256;
	cv=none;
	b=HyDqrgyNLr1Hmy+sXC4zGRAJPh+u2Gev+4Bfow24q2PKxYMG80ytsXX2nhe6e7Y/Ql1PnF
	/lISeA2yoof2MXB29PP2WnwI55fBEjrVV34wNzs4+/4g7vFqPEN7tQLVSi4Xv34NEOwusx
	8ERfmdTju2qW3l7PWnc0tFc0w38EEJM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=9PiYG7KzQVU+BI4qqMtLKL4MJUBO1mej6VwEgS9g1DM=; 
	b=OmplT/o3NoKdujgRPehU7WFnzGjw6UlLogxLX6ZT+wVn1fexz00OjlJfqi0e+sLmKR5JWAMljWL
	GRmtRDshOqShheEHV0aPQe5YVY45kdzZcB8tWqG9uVscBfDAG/pQ0s9yRoGC5i4HOaUkEN6olnwme
	zKNjshGsQZ1qg3KHZkfKIEk8VU9jaGP0QynZ1ysHrC3XZib1oKmdKR5BYgYIFZr3jIipJ4gnoeTlv
	CbMyRJDhpSn2czokfIXV+RLm/DeSbk4eWOpQkbRUHVhZFeDBGl6OTWLfP3noGIixVXGULtNFBDS9i
	T0F2GRiyzKNtrwoT1Xb1p/iP2AHYuTbQou7Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vO8Mj-0061xd-1y;
	Wed, 26 Nov 2025 13:46:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Nov 2025 13:46:57 +0800
Date: Wed, 26 Nov 2025 13:46:57 +0800
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
Message-ID: <aSaUUez5J1w5WyE-@gondor.apana.org.au>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
X-Rspamd-Queue-Id: 51A32140007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: t4995i86fywjp6oh6pf48ybg4cbw8esb
X-HE-Tag: 1764136024-630159
X-HE-Meta: U2FsdGVkX18mrJJthQTstth3qi39lRtD+A5Ib+h3UkugI9AUri33slsdXQnnnnBm95/Cc2rcCfouF3RapSgRNgtTUDZdKzBjrxideAvjXfl6yno2NRrGVPCv6I+mPIrwHNdePuWOdIoFM0+eoLBuaw7zUSLl5bD2hsot4sEP60jP390FGApbpT+S4rOC7LcILPNkemn9Gc/rTCauNHhJ4V1DNJqfDGxIrKluCyVoDCb7palYz2aQvN49s4FxEgoBWQSSvA1bz1eltc84nuM4uiDwEaYrzC/oSB4go2F8DxwHHsOdDhn7Es74dvS3g6TIvE2cbhm0hUH5M0UusTgf/3IGWRZiyKEMAm+R6x5nPruxMhD4dPeHygbCXBAWxV+hK+ebVaerQHWdyZgf2kikSkWcKsNlFq83g4QRqdKj4+mHyt5CisjTpwNJEx30j3g5jCuCrCTpozKdYp5pqvpcOX/NfjbA8gIXn+UUWEHQY4dUl7/klUSbVZei6PNClbbYbwesQGx0BWo4lRsX9eJR85aNVS1gVqfrJVH16bax3zxSY7c57er92DaTwsGLgcB84n93HPSQxcTII0NwkyWcWiiqTQ1fSCPnxfJVq1uKxdr47ZHdMPUScje0Bzpq5ppb9TUV2zZ957CsNtx3krRDzxaSm1dBcW0ryTM2CXekrCB2R77e4GlNjlq23bR237/HZ64kXdiC1d7I/aTr2ZMhizJWvhYH/josz+EtfXZo/QMjqMXBE9YClqPbiDrWeMBqTCL7+llET+urxeJGbyKDh26WGs1R19I8ABg8Hp7KfZY0D0tJRzdTmiHyDxZxCAs22w2xynE9At35jEJ8Gkz4f0Y60BK935b267c/Wyo273F0CT5OLbK+UhXtscjiOCTlans/Imu3I6HQ3OclOMUWVj6eKkq2KXSPpu01BCJyCuHmNGOtNvHWUbqLKbOk3gVx+NL2F2wDVfhzXeJWXlV
 e+69xMEQ
 5n/jLO9y0Dch/TpAAehLGbEQlzpaWY1dutox7Iq0tOiLHTiWIQjCOYejbz4ttIY5PhUGxILvz4oHP9+lnltTqkV5F60DtpLNi0g1go1DLTdyTGHVv8loJ4os7f/GuacjFDkfP+eUfB/D80azhY/CGj1LYeJzwjyzKN82EPAo0la2GJyvr1HzfRIZOiuMWASESoNzIF/UWmxtQJKn/74OKeLqVpWaRyUDxpt9Xgaf7laPM/SAXw0ylyR3TmEgurB2or6RuNvvOUTMlDlbhEl8yWHQzrniRn8t5LezKX6/G/z1stwl8+Mp/1uZtbZxh4eOCT6rZw+9tNpQeMgyvPr5L3aQkYN23KnXA3DAhO1MrIY3c9Ci/zEPmlBfAAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 03:37:53PM +0000, Yosry Ahmed wrote:
>
> Thanks for the clarification. I understand that the error code has
> different sources for SW and HW compressors, but I do not like using
> errp as an indirection. It makes the code unclear. I would rather we
> explicitly check err for SW compressors and dlen for HW compressors.
> 
> That being said, I thought what Herbert suggested was that the same API
> is used for both SW and HW compressors. IOW, either way we submit a
> batch of pages (8 pages for SW compressors), and then the crypto API
> would either give the entire batch to the compressor if it supports
> batching, or loop over them internally and hand them page-by-page to
> the compressor.
> 
> This would simplify usage as we do not have to handle the differences in
> zswap.
> 
> If that is not doable, at the very least the API should be consistent.
> Right now the error code and length are propagated differently to the
> caller based on whether or not the compressor support batching.

Yes we should only have one code path in zswap, regardless of whether
batching is used or not.

The degenerate case of a batch with a single page should be handled
by the Crypto API.

So I will change crypto_acomp to take care of this case.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

