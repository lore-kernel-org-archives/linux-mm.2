Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FEB2CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 01:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8058E0088; Mon, 25 Aug 2025 21:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8D08E0038; Mon, 25 Aug 2025 21:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF188E0088; Mon, 25 Aug 2025 21:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F04A88E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 21:13:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82C7A1605CC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 01:13:36 +0000 (UTC)
X-FDA: 83817136032.18.94FFCB9
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf26.hostedemail.com (Postfix) with ESMTP id EB234140003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 01:13:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=T6hjPgwa;
	spf=pass (imf26.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756170815; a=rsa-sha256;
	cv=none;
	b=T9GzgB+4LuqZc4PF76K4HC99PONtBqJvs1CGGIKhKEEY5VlyFSm+sGJMSVmyg36m28r/tK
	iBm2YFysJKRGxw4wYKAjQ0Pp6RZqPeloOi4Qn5GM3uvxcTURpGWSNB7hFJg57AMEn3tSKY
	wkmFXvihP8ocIx+La0NaK57praSSQF8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=T6hjPgwa;
	spf=pass (imf26.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756170815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GahGKMyDDWWgzcOoacVh1GqObdQHZAFm0vAPse1Lvgc=;
	b=5/wQLTUa6NGEheNGCpT5p7Q8fInLmrtlNDqCO40uGT+FxGxy34TdhLUVd+VNZbkZIJ8iaR
	briSx/z4jtB2eJ5+M+u9/EEa4NWuODUjEGdaxZwpnI4XoRLIHnjqXuPURLmpwWxeBb6R8z
	Nn0wrzEDaW6VvkTqwFoHbvfwgXpsKfQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GahGKMyDDWWgzcOoacVh1GqObdQHZAFm0vAPse1Lvgc=; b=T6hjPgwauSAvz2ezFKh/PyMHbd
	/zvg0/xfZQcNOwdWxylETa7s3AVJSbxho0c2nTbmk34LaHMzeXj+1mldn2Mp6d2f0uBLuxkzAiepb
	R0icvWn6tUqu+kxWUy655QEiqVk0WnjrwO6toSvK1qNYVU+svqBBQy5q+jvAUYW5b4KMPFyGelNhf
	xGqE6u+jzP8xGZRJeUfUyL3R9AKfTNTtjGGz9AmnH9u3iH0fFAFTjDBtQa5CqV1WJtaBe63hi9J2w
	DqxRidDI/ZOFLHYIPazSG25R8Ax0kq1blnQpxcMBiUemYX94HtY8a7ShYZO8WJoqY2bOnwWibi2uH
	xuVIpBog==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uqi08-00HGCY-0J;
	Tue, 26 Aug 2025 09:13:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 26 Aug 2025 09:13:24 +0800
Date: Tue, 26 Aug 2025 09:13:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
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
Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Message-ID: <aK0KNAmQh_JVgnML@gondor.apana.org.au>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
 <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
 <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aKv28XTvAITuq-p8@gondor.apana.org.au>
 <PH7PR11MB812163C97D4C533F0302FA20C93EA@PH7PR11MB8121.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB812163C97D4C533F0302FA20C93EA@PH7PR11MB8121.namprd11.prod.outlook.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB234140003
X-Stat-Signature: 7e94wuse1nnfktub7osnbicmdi4z6wa8
X-Rspam-User: 
X-HE-Tag: 1756170813-60918
X-HE-Meta: U2FsdGVkX1/yKGotStYyaiLyUH7c2crpOVMOPcetwk8DTu6+ehZ0dTtItLJuf/p6/1o239KpNyn+ZoMYCLHfAO6oyNwAaqqDnwzbGzCA0zdk6+sToDDipXqn1wDOANnxW6GC2fBCofD2ff6HuWQxmhZItrx9DgepI3WkCq5YdnlmLPj+60/u3EQNoOzf73KK7CZQ9ZT97J/VC+5kz7H9ORX/6sHq9YxJSUwlqDpRc2WeLuRKtWSRS4dim+WdrTylMZnBt37DzUfhpo9VdSKzPN1NqkqdaegK8n4T+NfdHcPRpKG+7qRHUBszgiclNPIusDmZuqwZ4EjnSk87W7FG7F/QaauWsM2cKGXR+FzyE1FyqvCsY++za2hSIXEj5pPM5ABCzIJ6zR7VL9aZ0ZQIJR2L3K18rldlos7kG4aseDDSA1RmLyGd/9IfDOApIkCS886+YITI9LyVNdJTbewGfLIa+FY1wNm2bp4QTb6sUKFOaTT3xif1Ly0hlwBZWbB3R91BpKxAPhlKcBPBh/SrPg2n3IDCilgo35yPg3iBescQ+cf7k0kvV3daw2fXE8ExTvveYZDemWI7+4rShtpWU5MTk+phY5aJKgF9+e74CKxE1FqEwki5AwNOe357MHWAnbOQAme146mR7MqINZVVm8reRwszwuDzPrJH9d479WXlqCzzlCjuA/nVMiVuWx1NV8zwyAtZceatGn3O9HIfoqAS3ZJQcpIF8WFLvOD13oGgpIC677I5U6FXOLVIFPH8ENiqPJvASLA2ZyD8EqLRHldQh/oEDZnip4POI4PFedN5fardKh2PLgLizSDEpyUQSXVFa14n9S91naZEnDfxjZwkUXE3yeVz/S4/6BTrKui2MYjnPIWhksnZwvZiZ+NWz4AhSDv6aI88OnixzButBLECeot8aEXi07NIH2yCCKVkBFpQ5Ne2Dv8BMt1DTlFKTis52QU/NI9uvp/nVrK
 YDFjqdeh
 cXYVCKOMl4Wkuy7kmwkEUmIsPuKLFVq1ZrhXYLAYDnlxPABnjSzOkN6lpqwJU5cdmyC3qjWtsU1gMVOMQzUr24xDkCJIJd2/CHSSGGdMAXcG5Y63pwp7h9kPXnFfh1BOP8onrh+O3LdWtkjxdb2D7AfCvTt1ujbP2zqjlwLjNcI9GoceWBIrpAxus8U6/8S49VhtwnHH1V+rLewcy4xaxrZa3gEZwWFq3ngU6eGm5Z+xACdcgh9I3MqSNIn1K72jzZyJR6cWsuOx//n/li5TmHfmcMAMCWQhqZC8UqqFZ1lETg1gG2Ab6UU5BAyACLFsQm+wVDHfKIrs7ObkvmAygAJtS1Xt9wbEgIzFT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 06:12:19PM +0000, Sridhar, Kanchana P wrote:
>
> Thanks Herbert, for reviewing the approach. IIUC, we should follow
> these constraints:
> 
> 1) The folio should be submitted as the source.
> 
> 2) For the destination, construct an SG list for them and pass that in.
>     The rule should be that the SG list must contain a sufficient number
>     of pages for the compression output based on the given unit size
>     (PAGE_SIZE for zswap).
> 
> For PMD folios, there would be 512 compression outputs. In this case,
> would we need to pass in an SG list that can contain 512 compression
> outputs after calling the acompress API once?

Eventually yes :)

But for now we're just replicating your current patch-set, so
the folio should come with an offset and a length restriction,
and correspondingly the destination SG list should contain the
same number of pages as there are in your current patch-set.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

