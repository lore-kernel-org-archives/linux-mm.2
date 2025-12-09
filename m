Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BCBD3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 02:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934DF6B0005; Mon,  8 Dec 2025 21:32:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BEE66B0007; Mon,  8 Dec 2025 21:32:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786866B0008; Mon,  8 Dec 2025 21:32:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64B726B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 21:32:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19C2813AB84
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:32:33 +0000 (UTC)
X-FDA: 84198358986.27.D6CF7A3
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2BE9540003
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:32:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=gnjL+27L;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf12.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765247551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZLjNoakVV6bFoonKXxZ2uN/OSTmU5GF66yNKZJxxOs=;
	b=V17xB5EetyjVapl9OAUbrKXhV0pKE977ytHdN2ZhAtb4fXRj09oIuEU/Wa5MPfwngWjsKh
	mKznHWEGRBIjUYCnEdZbjnZd0e5eA7UnazofJIl66LytUBSy2l6UO2XckX+jX/xNiZE7Oy
	qnNrhz2EE7R+tK+jXmaLDMvfRBekTRw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=gnjL+27L;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf12.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765247551; a=rsa-sha256;
	cv=none;
	b=vCLQf467Hap9MZ1tmaeTx+OZDKqwNHXBqKQbSHQBhvxs4VHAtG+So7j4Jhh9IOTVBo81gd
	Xv6t/KL4Lbz+5yP/Gl6jjgbiBvqMWsdC5ogaMaDui5nQ14SgQasRq+kQPkcJR8vdCT46Lh
	v6GtDA43VlYUoZXFlVPZ9NkNXCu7B6o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=wZLjNoakVV6bFoonKXxZ2uN/OSTmU5GF66yNKZJxxOs=; 
	b=gnjL+27Lnwc//Pp4AsBRMlTPIpwoztS0SHJEc1yNf09XrIKkzhVBpfYKziPJ/wUrylumg4Phn+u
	VRerEwMBQVN3OvAuVmXUnsgxwVQflVtTgaOnUGBWe6LtCTI9OO05N7tvQdIlRhoYfwO6CFBlUWakM
	0HMPZs7RITXd2p7N6GUaMO0GESc6MsoANjD92lgJucMZPA7l+vPNS6rP4qGPUfNJM8giuz1XDuIwl
	oGaSBr6bg6g5vHnHUUGgaYM62UgXft8lerbubZinUhMGJPymUatyNxl6pRokIw1YBmXEa6mW8HG5W
	xMJmYDX8XpcwGVLHfv0DXSXHyP1IczXXW6ig==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vSnWW-008wNt-34;
	Tue, 09 Dec 2025 10:32:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 09 Dec 2025 10:32:20 +0800
Date: Tue, 9 Dec 2025 10:32:20 +0800
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
Message-ID: <aTeKNEX5stqjG55i@gondor.apana.org.au>
References: <ifqmrypobhqxlkh734md5it22vggmkvqo2t2uy7hgch5hmlyln@flqi75fwmfd4>
 <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
X-Rspam-User: 
X-Stat-Signature: 3zmska98hzcupbb11bsxd5pqfk51powm
X-Rspamd-Queue-Id: 2BE9540003
X-Rspamd-Server: rspam06
X-HE-Tag: 1765247549-354356
X-HE-Meta: U2FsdGVkX1+pxHhDg6XEzxnd7FLkLaHhkXLpDORRHsLMOrrw9CzsFVv/FkhBgHFi+2SGiQdS68V612XasbAk7N4K4w1YsagkJ7Q/X7VoBOBWXu5R270LQVFbe5GfpN0Z+2xJ1ol4PEWT0IV2nB1p2fZGGwiFaR6nxI8dBwpReRS5a8kCZqWyZ1x/AIsrrsyNnsdEsdvUYXR96Qo+e/yN7bJgSyYzdgXh0vK/RV6ZozYMat6Av4Nc6kggyTyxM2Gq8Rfs6qHXN9oaHFm+vcApoHqt2TeTvfrmpSM3Bs9tga5vuea3JWhvXiosj9aYyLA3CRiMYJxcdLtTJDWhQYjJAJzqYPT4HrsbqQoX+njlUyLholBITAOKnrM7s1aA2ffjo02HB9844V5XgBeeuvh8YPjjyN4G4HmQznM4OCSKEJe7v6708u1HF/4y6wjm6pwldpFL0h6n21n4s2W/HYdNQwFpz2w0EkyeJ7sHaFfzIGkTQttonBB7KB3tHrz2wyOUmZsdd6Gxr1ljkyg/5gbajK3qZOjvmgpRdzwAcplVcQRh2aLnIzjeX9IMgOfFZ2R4YhDw35Ia5iUtwBVaQVwBkT26N+N/7anbDZ621PriPYB4Rfju2MsmjVw5tIzhS+J0wXFTIO8GNR36puCaEQ+kXBG85/WPAorI3viF/pbnNXhecebf/TvIy3pyzTlfugqmkeyQjuKorPa9+ife/LdAB3XekRcCg8DOf5B9DwSCJqcFOzYA3gEfLdfoXaFGrI5+VNOO0pu9m30Hc/ngrOhmQcYUtNDUHE1h9vgVxlAaqu2wp3GL786tW4UrhLRQhDxtNExE0aK+HPCAVEooaCy+wgOGgLkk5naNnKpWymvAo4ATu/wz5yF5su9CajBdbVX9NBFULD4sYKzkChsSTw2eUgp1ErQGvnY57wBBXX3fk1uMaEPL0Lq++G6GYxM3wNyFumsHjYW+i9lYv2T1roJ
 x9uFX7oR
 0Q173P7Phuxy+wmbSfsQg5Bgjq6643L8tiaL9mCfito/Ns4XRITGE42icJNP0sWsV2rSuD1F5GirGUAQhXV4b/V7AyeLMry0/6I0Ovj6nk6Kt/QFgzY3IZGeuSSL4/Q/ELdx3soDeVvt4e/0xF5ZZDzCBu5qVCqBhdN40/SNgLLq4SUCc13N3Y049mLqfkxoaBDib8B09kCM8zmFThF7Lu2l66mROA3vN4d8wUeTagbrGBKqAEr7Sf6H9TyiT9/kj4yFwIr8Sw6EVK23aIaVb8t3ZX4aS7IqVElnngZmWRd8r0yrcH5Kllb/yQ0EWX5zAPoosJ0eYCeG7VCcTrktdpxiPQe9f631GDbz37wdh1Z1aJUUSizxCB3jThA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 01:15:02AM +0000, Yosry Ahmed wrote:
> 
> Just to clarify, does this mean that zswap can pass a batch of (eight)
> pages to the acomp API, and get the results for the batch uniformly
> whether or not the underlying compressor supports batching?

Correct.  In fact I'd like to remove the batch size exposure to zswap
altogether.  zswap should just pass along whatever maximum number of
pages that is convenient to itself.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

