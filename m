Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB641CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 04:10:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 274318E0038; Fri, 17 Oct 2025 00:10:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24BB98E0002; Fri, 17 Oct 2025 00:10:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188C38E0038; Fri, 17 Oct 2025 00:10:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0628E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 00:10:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 849351A04C7
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:10:02 +0000 (UTC)
X-FDA: 84006278244.14.DD925D2
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf18.hostedemail.com (Postfix) with ESMTP id 216891C0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:09:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=DMrvuDlr;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf18.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760674201; a=rsa-sha256;
	cv=none;
	b=zoP3qXS4TJtThz8Fykl+Gn75v9Y2gyfYrvJTIU9l72PIppx1z0J8vR/XIPguPLT9tuL7qK
	OoWn86ZdhQ1/DusNaz6xuuBeVq/ufemV9LLq+w15YE8d7m17BpEdN/vIsH7TUH1tMMu5Op
	wrt8DA6RoF2MX2vc9GaudpbjUFZoRNg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=DMrvuDlr;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf18.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760674201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpPlT+7SwkvzqCG91Lt33LnkHbmeGe8CImCIda8ktbk=;
	b=u0TfyOTxi79KCMG3zn89dm1qy8R5nf5JHpQ0A1ozoqT10/yCfayUAGqdCsEzlTLaOFz46S
	t4Nfv0WVoFsySHlBfgDOdSL01pLGxHXSzDnmMC+ybE/cDipxI/vxBpFbjDWzr9CjzgQTHs
	ckbb+u9kjKGSb/7TiPLecwe18XTs6rw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=EpPlT+7SwkvzqCG91Lt33LnkHbmeGe8CImCIda8ktbk=; 
	b=DMrvuDlrhgie7oLUABRNt2ck14BU8ZEPSCPhfeMdGIh187lS070UcAVGKYFmMnoCO3Y4Sixl4Cl
	eKM4xVsWoNP2jlCwsOyNGkBgZ78ZXOuitTZpidSju80v8I12GnvgrHqCBOsehqDF2D55W1VmAN0vM
	X0sSv4JQF5nd+TPEXpQOnbD+ctw0xe8gJI6hIG4ZUe9dLHsirW5To1YQpEBMbG18r1+HTrYYdVl6t
	uTUyBr8FQ1rAym0/rCcxYOW4DML4Etz5szruhZs4CUoGczu/muqv3h8YguvzHmDdFAmjWUnKIqRFy
	NunefqaHlhdDEKqZsGb8Cd4kQ5Tatm6I2ysQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9bmp-00DKDa-0U;
	Fri, 17 Oct 2025 12:09:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 12:09:51 +0800
Date: Fri, 17 Oct 2025 12:09:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"sj@kernel.org" <sj@kernel.org>,
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
Subject: Re: [PATCH v12 14/23] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Message-ID: <aPHBjyWMTddVNnwl@gondor.apana.org.au>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-15-kanchana.p.sridhar@intel.com>
 <aPGXUxRZeYLO_CUo@gondor.apana.org.au>
 <PH7PR11MB8121C3BAD72D03573D6B4951C9F6A@PH7PR11MB8121.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB8121C3BAD72D03573D6B4951C9F6A@PH7PR11MB8121.namprd11.prod.outlook.com>
X-Stat-Signature: 9uhzqhw917jqa486r9gkk4pzkrtwa8m9
X-Rspamd-Queue-Id: 216891C0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760674199-342338
X-HE-Meta: U2FsdGVkX182J7KRHGT0NFs6MlX2a/z51DgfSidrXbp+SWiRWml+5bCfjBU0TziJw+5Mz1B0bveNKQem27LQCdwAgRpHZ6DujBJv4BWW2lqb5/fRE+VjXqkYMrtNq/H6cPFzv22zJBxVWm8UQMyP6kPrQCZ9UsfxWjE6IyOAGlgp6A9iVcM7/jySfY0HqvSLVWxy6mcFY9WAjQewlRlWO/c0DIfzPwtXprQz46xAJzDoc55XHh4ls4OwI9FeAoWmj9H4mb46V0kb/4aIw/AMy81oy+hKNDQloXAO3E4wzz9ji4VCFELOGkloL06nL7W9HujYsEcoq56uumQaFARjLhHN0JSpw3K9Ozm/uLFlNQyzXxmz4HalMT+dpdtJA8/LoPQKbnqNh7ArR3KEWCnQFhkkk6SIue6v1IlSPK6s525+rg18Bmf47rEDGgKcQDxjv6REQwnbaL4H846gwWCJPYpyTjxchEdCxwPtY6kWM2sxZXDGpvi/HsFwoaApx+6VggPGfc8D6Spn+Xwe15bWBY4HDA0L6ZR78r2P1T/hDMHU8wOQuS99jj4pte9DVhFfqnXCAA9Pke7qY13TlD2LhhkATBFEojiR3qYkFY/TuQysNZ1vnZJVC6ZxBTmBd/ps/cr/r/sA/PCIMmepVNzMrTYAgblp8kso0AgIjfh5UUmBnz8STK7w1x5LTC0wF/rgWqSTTZUi7HD9l+S1AhzEF8/0ctOi/fPIM1EVzyaw90+8T0J79oGN52PeMkPsojCM3r729j+DSfk0T5lVwxivPSSZyWZhHtjDhQa/0mWnWQJJlaUyLSdHPsLWSe65KOlefC0Po0TSsN56qhG6gp0+wvdfCAjcS+SJVxDbOn0nwrR0OjQKX32uft0bJVuGMbhj19T4FPouWH2T12WLJpaQJuVJK07UiV6XzriPastavoW0SHspM9KyFvA4/FKA16YqNs0ej2H5irV1eT7aLir
 gpCoaM7F
 idwZi9WzGL5A4PzS/6+xyrd+JA58GZrNDz6NW0zmzj72NCV+/kldotkTcdysmRCBeHYYWPwuZ1VEdGiHvCG/sEI85b164pFvV/JqA1ESwTu/KJy54DrPCORIishfWOOP8c/BmDwavn4eT5xeU98O9ETrervBZKlwC/EFp9StL4+rKFM1qCh1+VEgROmgDLek6h3Xoohulp6f0vpywO7cF1AkO7qUSAcrgjKE8evh8UKK6vs7/skiBBOXV8+Q2/RqqYurdV8CVznLs/P1gClBAu2KvjiD2qY9tBCZMqXq16xSWK3Vu52us4CeTFc2/W0zA7m2hCGxeSsWnMdc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 04:04:56AM +0000, Sridhar, Kanchana P wrote:
>
> These are for non-crypto users such as zram. I plan to submit an RFC for
> zram that enables IAA as a zcomp backend with batching support. These
> API will be used for this purpose.

We should be converting zram to ahash instead of adding this
interface.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

