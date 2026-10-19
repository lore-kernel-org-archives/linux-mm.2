Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 181F4CCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D77A6B00D4; Sun, 18 Oct 2026 21:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ADA76B00D6; Sun, 18 Oct 2026 21:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C45B6B00D7; Sun, 18 Oct 2026 21:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0FF46B00D4
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:38:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 77FDE1C3E4C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:38:48 +0000 (UTC)
X-FDA: 85337666736.07.768066A
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf29.hostedemail.com (Postfix) with ESMTP id B88E6120006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:38:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=XS2O2QFf;
	spf=pass (imf29.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792373927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYSr5t9Me/2+kseI0M7kxouyDPY24DZfSxw67dym17k=;
	b=hxWYaNGfk0/LQLK06AST3DDXEQQuVQAKJLtGKkJDNMP4MurUA40vcmzP33HY+664L+ENe7
	GyZEfS1De2WFxd0vbC7NnRoGLKw0DlJdXIw9Q3ALjd71faurF4DhPphk+QfJAlhqXFsVRP
	bRn1PzTkwijPNfxbAKfj2jdFlSljALo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=XS2O2QFf;
	spf=pass (imf29.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792373927;
	b=gHXDx78RRBQuR5Wwf0m7J2szkYYdN4jgQy6ZOtxVaPS30YCjE4QK9soeYDT8Xc2heW7toG
	H60/bsq5cO+ZTjo1n1Th35sNiOV98qBIVYXtX+dW7yaLvfOZ+Xvpe20fCqApMa0uQouavC
	BrO0pYP2jaunNYpi+6M4gulZt/vUnE8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=UYSr5t9Me/2+kseI0M7kxouyDPY24DZfSxw67dym17k=; 
	b=XS2O2QFfMCYvtNTkFYEQ3C/pPZey7mrSbEHTIZJAugCQpIf41Haezhs+L32uXqL57LTD6b+WR42
	XJCgGNCwyPObaLWjfy4JR5Ahi0kUZBjAnfJWHvYwguevy5rDHaDZMdyi3Zu7SfrpMCd9FUsV4eaG3
	l+W0q0A+6JkGm86L0zKQhABbFDSBBUN2HFRsMlnvM1P/X3ZBeRfrwmm7AEO5mCBFGMVDRuO3lOhhq
	Cv0COUuPv4q+l55FerNuuUKtzGSN4hOGuA1t2Hd3/Pf3a7nnfYWa6kl1tlb9i65cSykVaj+1+amBy
	nn5mbkTtgFbJHekYbFybwnXesI01kCI45QMA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xIcKd-00000005Ctw-32by;
	Mon, 19 Oct 2026 09:38:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 Oct 2026 09:38:31 +0800
Date: Mon, 19 Oct 2026 09:38:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
Message-ID: <atV0l54Q43b1KSHF@gondor.apana.org.au>
References: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au>
 <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au>
 <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
 <atMCfhB63koot230@gondor.apana.org.au>
 <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>
X-Stat-Signature: jpfdzyrscjzxc9wtf6ueczjfbytywjgg
X-Rspamd-Queue-Id: B88E6120006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792373925-910802
X-HE-Meta: U2FsdGVkX18fwKYri8o930+6k6nyxSQovrZZhQr5IdA7K2GPr+2FcoXWV7Lh1BomGysbLxfbsgwPS9UX/k997a+Ii9iBvUI5TCHosydZFo3po/2i/+yHxAyE3U19bSU3FSLHOzghYyusJiD0FwkepOSx5OWE6Wj098exqYDEHcGGSIABhriixYeRHjtSS2fQS1WsJW0ziMji80fFREwGq4Tf8IZrLPzawH+di81xTpi2I5zW/OMWoQNJ3sQ3nOhERBaUko8ZhMX5x52OjXtICZ3RKg7TTMEiTApEqlUg2spl98iQup3Ou2feF2VuOifPbiohKob59DqiCmvCGMJFwMp0Q3TxVN6p41Pr4kdRo1HBWKRTKpLSrkuE6oVHjkDu8RVd5j1tGDgJUUgkHMX26PjX1GoEdaGD4HiUE+NQkXyfbsK7ZmT2GauhtddHwR96NimEsamMi4Xz4JJbQ60AezGTge8sbwaOHoHwxLJVI+y1cDahRtuwhvjM5awBeFXhlsB/rsVQICEcCAUMWXLrldYqnoMaHtu7S4w44DH7/8sky5g35ZyeCR9nMZTqx40wbsptpPIKXpFdGSbqwYdVQ0Iu0auZhGLOaU8FVrh7Y5awl78/exVQvYGkFOFqr2GcbN/JbJlwpk4NGgYLBlphffNfmBkk/zLKR2wduXyFp9MIxfsbUbomdrEiVFuD2rXuVEA9KHWV1sLL02cwdaydC19yLX6evjDsIQlOdBaCw8WuXgj6m6Y7VrSP01Cu1+yzIqc/aezYS9k+NRqB1YjGE3ShI0msu204zXaM79Wkf8/ejpsXKNuA+L8uviQJGNEtd83xUeN1KAZU9nReUXDsGF7N0e+Vite3XH7iDVaK6Gu8djQUJLS7Mlt7dW0J4gwPzPOU+HhRtODgMHsCsCfgmBXLIQ5kifjjOd5dRm8act3vRf1cupjkdexR2l6Gh7cz6j0D6xrDnxJGH7I760u
 l6vjEblg
 Z7GEZ+qvogXrjteU07D2FSKolGpun+C3NuMAXtSJSD0nO0fIeQm3hbyagQuF1GAYcuk9oKKYozneacwrhku+4PIMybFw8XW/k3urTRZ9pyOS2vMTK7TQwUSSRQ3mDEoYzoD0t2zVrkauyr2LGhmEJ3GVFZQyx1GULe+6fsXoGwlwBBka/jB/TYDzhaSOGyQfXux7vE16/w24By6k0acR1Sid/sJitI+kSuiiUzlj4XIevXaIF8WgHjj7dYFXFVMXrBKJExlTmdaKkp9jcc30RVkkWpVLb5m4H4ZDxA2wS9ZE+zuZRfKEtpRQyYjq88ti+vNp8GfpuSTXMLgA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 18, 2026 at 06:35:01PM -0700, Kanchana P. Sridhar wrote:
>
> Please let me know if [2] looks good and I can include this in v2, thanks!
> 
> [2]:
> 
> int crypto_acomp_compress(struct acomp_req *req)
> {
> struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
> 
> if (unlikely(acomp_req_on_stack(req) && acomp_is_async(tfm)))
> return -EAGAIN;
> 
> if (likely(req->unit_size && acomp_request_issg(req))) {
> if (likely(!crypto_acomp_req_seg(tfm))) {
> if (likely(req->unit_size == req->slen)) {
> int err = tfm->compress(req);
> 
> req->dst->length = unlikely(err) ? err : req->dlen;
> return err;
> } else {
> return acomp_do_req_chain(req, true);
> }
> }
> 
> return tfm->compress(req);
> }
> 
> if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
> return tfm->compress(req);
> 
> return acomp_do_req_chain(req, true);
> }

This looks good to me.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

