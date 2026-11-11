Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845A4606A334
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=B8qHdfto
Received: by kanga.kvack.org (Postfix)
	id 969816B05C9; Wed, 11 Nov 2026 06:15:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A536B05CA; Wed, 11 Nov 2026 06:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808496B05CB; Wed, 11 Nov 2026 06:15:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 573C56B05C9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:15:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D013240283
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:15:34 +0000 (UTC)
X-FDA: 85422582588.23.B56F750
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4492D40005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:15:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=B8qHdfto;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf12.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395733;
	b=qjmCtzI79aQl27m7g9k3nj5Blm9/1D7YH5Am/8JROo0Wz636UXHHCxLb3bN+HDlpuaYNAM
	tunJ71ARdi19oiUco8mISlb4DwlO66YXwgv5MH44WII4eigdX/FZ3eAI61ZEXyvGLZ/Ppv
	0jdAN1UrBF/ZoQBiB72wBNSVnOwHCRk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlLqYPADNwQ1zF+v5NfxkIsk70HEKIc18L9HL/VuUSM=;
	b=y1r9Nv7uG/YVzKuME9bkBXheO/5neJU7qOYwGBOZ269spPRwLHRWE93oq6xPmYJHB4pV1Q
	Wa1wRTWIoFF4bLMUDsUM+MmcLlqUM33+bvJ71GqgCk2Y3ndFPtR64drV7hkQWAT34Ss3ua
	URiIDLT6PW7WQnMcjUEK5Vp001xtWVw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=B8qHdfto;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf12.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=BlLqYPADNwQ1zF+v5NfxkIsk70HEKIc18L9HL/VuUSM=; 
	b=B8qHdfto/kn5BTMJWabTV7zaMUonK0Lpj3afLU6lnKrKz8Cj4B23jHuUj9lyOOFKFb3WbRJrIlR
	S+GcrjPE+Cp/DpYqReoBXauBUMJgKp0L19de/VX+b1vD2qcylI7IxlnM4z/xU+9arSljgiCnfp75s
	hE3tzq5QepQ0arZjxRTNSE0SGHR2cOdRj0Io6OQJO4h/Z+McC461ArautLz12Z4h5d9CJO8NFJdxA
	T6HW9asiJU6Polpu39186KRNt7gIjTTSSMstlVA63wNopTMEeBctRTJeeAZdpaelDyS8x2Rc5ru6o
	/JNCunrTVW0yWESUWInkH+8RqBjTFqnStSRQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xR6IO-0000000DmXP-06l1;
	Wed, 11 Nov 2026 19:15:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Nov 2026 19:15:16 +0800
Date: Wed, 11 Nov 2026 19:15:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suseendran Bhaskaran <suseendranb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"David S . Miller" <davem@davemloft.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
	SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	linux-crypto@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: return -ENOSPC on compression destination
 overflow
Message-ID: <avRORN8bPgzDY2Rf@gondor.apana.org.au>
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-2-suseendranb@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021205626.3286270-2-suseendranb@google.com>
X-Rspamd-Queue-Id: 4492D40005
X-Rspamd-Server: rspam12
X-Stat-Signature: dg9hsiu4ggz17eenzkkxej5nswk48x3q
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794395732-239698
X-HE-Meta: U2FsdGVkX19DmQPkGLmNyFVySLv7lMVII6V40dlHwxcRJh6UkzN49l4QJiUb7J5ZBc8ycg9j81HtaJM/z4GsyUYB8Nh11CqbJ7ugb2FfFBNQmcyGZiwP94bNRcVWIczCui6Pvs8HXm6D4TXsmkpTC+VD8NfSRB05Mp8ZQ02B4O+Q2xoVr7IoMgK13voTviu0EHckF6nLt/4rNJZfTKS+7Pu5QlcmfwMVLSXWlvnu6VWwrraCLC4IqpfqDrrz87A/6/D/aU7tXPqPpwmY7lBGipsixkyECFtbXcS4/gwBKiXtPrZbM/J2CrviMwQcn25ShMtspl2TbxJwNnI+2j0DaHVf6YGYXjjLb6wB7o7C1KnN1UhQ53RY39a2/ph8DF2HUduE8tZfMh9w/JpsEVQzXK0TIyZK7yqyhA7d4PQt93BFlNpCVsxHQKq/fbcayrfB6OKBqWxNEC0tJDqWuHl8havaavOA3wvOn6p4vbFnWhr5sIFCaL7P71brCbT3kus2QcAdO2J7Kr99hJuAuBjlmA9gEQ0Lqm4Kg4byK8FCTdozPeapVufF6mnNOK8yOHMQjSPWP/L+TlbTcqD92jCfPQL1XMT2BEgUwXiSiPbcle4g9GilOYmYRs/3fdZ39QmDdXV2YBqmpYVf0ZRnmCBAYYWD3URvulUMTgxuXPjoLmtEdEiDpRpvxWwlQ3XOP5455jO1YBauPsxnii7NXd0Bfk+xdBFHDRptZMPg3FRTJLnD1oBiGEgN9cFS0x6lMD7EejSm2+DtpKnHDkeMf9+QLiVLUWgiytgMf896WTsGTv4nl2DnQxaiCagUHF9CksTAjwav+zv5VMs7FO7n//K+nbCr11CMLdDqtLYDAzJQzYxrxb5vv0BkuvQc4ScMCldDHIEt+1LLZmvaqdHkQ4aW44J1YQma14FFRWHqj+NATKyk9OZXCt+MzNGJe4B5sP1YAt32joIf33O2KX6sZjo
 MdfVL492
 ObavWEdhh6REn9g+kbZYI878pNQj8UFaiT2ZF3npg/Mcgekz30JH3ivPp3YeT9j9Qi+aP96vpTh7zaqUr9e2gbhxWhKfY97JtkYNAowiVJ0CD4mHx1PAy3UtGc0/T64gwBRgFveUl5+12Qw+K06lz3IujqQbkCIcETQrn9oVKWA32KHwNEfFrGpgWHIi30C7ZYxAl2+s4LsqGcReIBECGQjLMCniM18a8cCE2+MEY1iXD7qPu8zJHG161tnF6ogk1JBOwx7rM53eruKxUhs3vEBhXRYYAzdhXkV0RVFhL31pgtIuYhB+cDyPScIHhPsCR1iMHuMPIeJKJI/nxb1FuZLzum/xcul1c+/ywb7IwhOBy1cfTjxSKF3g7+34VbWyCFXoMtc13injwsNVWavf9jAa2jmHyOyzahV2jAuofaRvOLPcDZ35rM1b3nBrk3ozknOeXCOoGZo2EVchbuvFilLaAIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 08:56:25PM +0000, Suseendran Bhaskaran wrote:
> In the acomp/scomp compression interface, callers pass a bounded
> destination buffer and rely on the return code to distinguish a
> destination buffer overflow (incompressible input) from genuine
> compressor failures (such as invalid parameters, uninitialized state, or
> hardware errors).
> 
> While the multi-segment streaming path in zstd_compress(),
> crypto/deflate.c, and lib/842/842_compress.c returns -ENOSPC when the
> destination buffer runs out of space, the single-buffer path
> zstd_compress_one() (taken when input and output are contiguous single
> pages, such as in zswap) as well as lz4, lz4hc, lzo, and lzo-rle return
> -EINVAL instead of -ENOSPC on destination buffer overflow.
> 
> For users such as zswap, which reduced its per-CPU compression buffer to
> a single page in commit 0b1bf60c324a ("mm/zswap: reduce the size of the
> compression buffer to a single page"), incompressible pages typically
> overflow the PAGE_SIZE destination buffer due to compressor header/token
> overhead. Because these compressors return -EINVAL rather than -ENOSPC,
> zswap cannot distinguish a destination buffer overflow from a compressor
> failure, causing broken debugfs error accounting (reject_compress_fail
> vs. reject_compress_poor) or masking real compressor errors.
> 
> Update zstd_compress_one(), lz4, lz4hc, lzo, and lzo-rle to return
> -ENOSPC when the compressed output overflows the destination buffer,
> matching the streaming path in zstd_compress(), deflate, and 842.
> 
> Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
> Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
> ---
>  crypto/lz4.c     | 2 +-
>  crypto/lz4hc.c   | 2 +-
>  crypto/lzo-rle.c | 2 +-
>  crypto/lzo.c     | 2 +-
>  crypto/zstd.c    | 5 ++++-
>  5 files changed, 8 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

