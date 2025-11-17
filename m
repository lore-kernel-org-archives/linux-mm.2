Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 641A0CD4F3E
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 03:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FFEE8E003C; Sun, 16 Nov 2025 22:12:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888E18E0002; Sun, 16 Nov 2025 22:12:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750DC8E003C; Sun, 16 Nov 2025 22:12:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 564378E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 22:12:53 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00DBE13C191
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:12:52 +0000 (UTC)
X-FDA: 84118627026.09.6EB7BE5
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2AD17180009
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:12:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=NDAU33er;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf16.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763349171; a=rsa-sha256;
	cv=none;
	b=TodbQo9LucRH38nRa0PhDyzm3Y9/vZzdaawizm36TnITasptLltWx1ZM6p4SrOb3NKxmuE
	bfXLJfpW0AV++chuOFs89xQGBNAHuHehLEBl2Wyy7C6SIjGuS7MWtQ67sBMJBWfA47gv1y
	xKccETH1YjnPCq1SzgyQwymN+HQ5GYk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=NDAU33er;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf16.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763349171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlMm7biMHzU/zsZZyzTao9DZXlaYBoqAWcxIHDHPw+g=;
	b=aPF+S3RoMy8QKFBdVGPw1of3SmiV3BOjqeEz1P+AGV1RWDLKa6rRhxmbC6Xsf2PWVmAGai
	T/keHsZB+BvSNU8Fmh3XX7B3NIZbO9VvABKIArSSoiGFcIj9aJPKZ4Jo89T73pKcTUAvRx
	UbJVJjzIfJkIaZ1VMAXfuV+AcVGJiAY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qlMm7biMHzU/zsZZyzTao9DZXlaYBoqAWcxIHDHPw+g=; 
	b=NDAU33ermBIPLm0iZPr7ZbtstmHVK1fT8vbiK32I/+TXIudxyEiy95h0Y1MtWBO2gejVIrzFdil
	tMka9Y3xgSfYjmUr5U/aipQlTEkLslTrbne2RqZ3cgPEmWMpdUNI/rG56P1YQ5DoBLCPkmRc7mNRL
	/d2mVdaV2HEq1PAbtwJD0Khcs6RmSj3Fioe629km/kUeCKUbxXuNsX3dKzTglEERqW+aWTc5Z/kwN
	/pAlMMdy/D+oLpWT1CjdVlBPxEVXZrMiLJgCK8PejqfeID3o07oN/IxHy9aplA7+L7z8VRgxjg8pq
	4xJ0ujuq8J6RxqtFfo4IoH49S66uT2Y4B9BQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vKpfV-003WMc-26;
	Mon, 17 Nov 2025 11:12:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 17 Nov 2025 11:12:41 +0800
Date: Mon, 17 Nov 2025 11:12:41 +0800
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
Subject: Re: [PATCH v13 13/22] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Message-ID: <aRqSqQxR4eHzvb2g@gondor.apana.org.au>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-14-kanchana.p.sridhar@intel.com>
 <aRb9fGDUhgRASTmM@gondor.apana.org.au>
 <SJ2PR11MB8472EB3D482C1455BD5A8EFFC9C8A@SJ2PR11MB8472.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SJ2PR11MB8472EB3D482C1455BD5A8EFFC9C8A@SJ2PR11MB8472.namprd11.prod.outlook.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2AD17180009
X-Stat-Signature: w56y93rjdspafpab3ronf3w8ibfozcak
X-HE-Tag: 1763349169-866378
X-HE-Meta: U2FsdGVkX1+CsiNmh9OXBTHDiCg7w2pLXc6y2l6tyVd53OzFD2dfJFJJn++1m8L36gagYR9BNxBYIF9JR4KuPZSYNZlKK11+jWabjPfR/i/g71ugus7HQwtVIuvnk5x1CjOEHwFqO/DCMW+0sGya1Z52ZlRzbQyUQHWVQZpwap+us652c4qQR9VIACWffn6FZIkeNt9uHEcRPA7QD7aPBEkOKd6E54SpzzeE69szhX7GRocdP6KvBcrJm5SuLBhf8BHtL2OifB29IerQ2m7rAqF8Zo+1V1kqtqXb0aOzeONTg9ib21fF5qlfW/UZGgFVY7+nqw5fJXgMNsJc5huiS4G1KTOPjw/JfVJAlkZ0kFAvwfIFs29bXOZizHOZJ7cc83iplE4gu7Un/oVpGQ1CPqoOOyG0a8Ug5n73utigVjtQbrIl7OHxvwDbmw2aocbELiqwPS8euYEeDJwqMokhlig02wstt1raDqRtN3/k5vKLrPobk63fefpz1Tc5KbdGXbA9/ksqXBa7hFeXWoZkQNf+iQq5sR+L8jAdPCzqaVBORwPZXWUYFV7pBTMHakchZNbSoZmeXoInNnaHiEbZI2jdp3IJ7zbyffo7rUBlaTKOJpM8It/nxscCIJ2imU1bOrt5RF7B8uhAJ2TxJi93vVNiYyvePKziMrA/YtaMKwhrQMnILIjm1H9jAyDIzMZ3Pw5FK0LBqdRgF80g1KUNya8nnPllWXWqlws3im4ojdjGf3RsK03UtQXPaHpucG/MBb9yEEwyPY9T4SdT/QAczirDWtX8oOqPyrfWVA5OtawA24a0Uakdd6eG2qj4E1/ucpmaXl7NXn/TuDNgHCxWiMFRhZ/jPomgQBnnSgWms+EIHV5oChyLjIoJyxrWJcHcpVKCPu8Wmdn2JZq3DNN+YyHeBwgxjDTzEq7y2yUf2Fivb4Kwhws4erLBzWEn2Of+UL9DNiLRcr91Qjpn3rW
 WFYtfjDP
 WNj3NoBXDEl7BOWMfh45BRB3bmx+3Rst58UN6ciDkvYoZBVgScjMl4ylCvm6tEcGypYXL44Jg40IUawWGOzwD3NjJ1/+kJevJYW5ND8Y6+zIpP2XbP8olIoWaRiCg4Saq30NtcTyaGGG17Kis3MhxknizROeeMEZlprN0Q4KbZ3zM4dYIpjgp1cVwzZyKLjUp5O/u3yn69ORn/10yKH2nMFa5aG5WVA+DpKVR6Qy0ySh0LrLGIzvlG35qDqppLD11WtEaefxzeVDtNnWrlvQ6gAf/fPT6MFti8KRD5VMDwPNUchzC1hlj7u/h8KGNEd3YuYfnhu+bERm8rZpCeP4fIV3NtVHdjgraZ0mF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 06:53:08PM +0000, Sridhar, Kanchana P wrote:
>
> This is a simple/low-overhead implementation that tries to avail of
> hardware parallelism by launching multiple compress/decompress jobs
> to the accelerator. Each job runs independently of the other from a
> driver perspective. For e.g., no assumptions are made in the driver
> about submission order vis-à-vis completion order. Completions can
> occur asynchronously.
> 
> The polling is intended for exactly the purpose you mention, namely,
> to know when all the sub-requests are complete and to set the sg->length
> as each sub-request completes. Please let me know if I understood your
> question correctly.

The issue here is that this code is being plugged into the acomp
API, but it isn't implementing the acomp API correctly.  The acomp
API is supposed to be asynchronous and you should return immediately
here and then invoke the callback when every sub-request is complete.

I know that the ultimate user is synchronous, but still the driver
needs to implement the acomp API correctly.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

