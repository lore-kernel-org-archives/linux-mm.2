Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3163F606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 08:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=a6C+nt7i
Received: by kanga.kvack.org (Postfix)
	id 54BDA6B02B4; Thu, 22 Oct 2026 04:14:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523956B02B7; Thu, 22 Oct 2026 04:14:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45F776B02B9; Thu, 22 Oct 2026 04:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22B176B02B4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:14:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D9891A0763
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:14:26 +0000 (UTC)
X-FDA: 85349550132.25.D1EFF2C
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9401F4000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:14:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=a6C+nt7i;
	spf=pass (imf01.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792656864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sD0G4G8uCR6QoPuFMFokC4gDJ/4LjJ7maE0ec9iXuw=;
	b=qMdRj3fvabT+l2nDbaaEK2CgpARrkLcwxOwmVfk5xjt0Tm7ndcjqGp0nvzu+fHhYTf8/D6
	4dcgIjgZZXiOgG/OVdbgLCYsNRPPFeP5Krt9EWmdqQUHREc9XvzUI89Pc/WcdvDlncX0vv
	Crn9KSqOspqbPwM5BKBuFgqEojaobzk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=a6C+nt7i;
	spf=pass (imf01.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792656864;
	b=YBfalJMiKWztC6xKCG+7g3EBLfSblC3glUuQbZfjmfOY9OdFW6Z0bM9ks8viN6viWYrw90
	8tHtaVUcAf4WCQUGLdxGlBElGVoMORwtz8xAkA6eGRnmCnukInlWAMeWXbz8QJ8KX5v16h
	DPuzvFJD2d+DHiNRVbhgocpyhKv2Cyg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=3sD0G4G8uCR6QoPuFMFokC4gDJ/4LjJ7maE0ec9iXuw=; 
	b=a6C+nt7iqTVvYfxU6QjSdBPTeQZyNPTtqpAaRGegAEHnBAgGiGQM2em8ubMFe1+mi0LpiuxjZQ1
	qLGSJSv9CpXaRcaIPaU2lN4fTgfJz/Gl9500tuBzTazyvIeYgAhC4rZxMYr+14zYXZcSHuXpwxYB+
	C4uP7b6XHYzOuIy1PydxpFYJR1ppAkLStuM3jRxtNCRirVs8nkTiRvGvwHTUE56Z0YwUXsqMx0XR4
	Ts3zuI4z+xMgD/QjZIShvMPQv4Dc1RAg4zE0Hb3mJ/ySFIs9ZDS9zf63dF4+YXPknPIDlROiP2rr2
	1FpGMsIHAtCV6LFjeG57eTbtesmtOiF5znOg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xJnw2-00000006Sw6-1DCV;
	Thu, 22 Oct 2026 16:14:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 Oct 2026 16:14:02 +0800
Date: Thu, 22 Oct 2026 16:14:02 +0800
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
Message-ID: <atnFygk8xsQ-8Mj5@gondor.apana.org.au>
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-2-suseendranb@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021205626.3286270-2-suseendranb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9401F4000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: g4m6qku7zowcnn938rqyinxedf58uez3
X-HE-Tag: 1792656863-175875
X-HE-Meta: U2FsdGVkX1+WeL6xSpKWlIwf4XYnW13mtupuuhQs6yQupdR2P1hTYQ5I0gjHn27cOq7I4nGkVV98ZgOefpwfLDsDP9W8yaoL/JqdV5vbpCdWQNZQadz0JbtjWObpHu+pQqWO/6mpF/ELw39HKWeE8Dh5stGuVwNg55qZ5HIawBigmVFopcQMghQ+BpY9L9/x5Og+gwv86L5Kjl6/EZzbvYX4nJpovNhcatFs6J756BGpgXZrHjgJwd0aIKDlbhOmEFIsopgnTWJ0uuK8luHXjl571lgw2Fh+xjiYV3DqHQR/gx1tsFabXjQlHqAEV1hh4T9cUkpOVhkglthbdxv6O5fQwoFYwP5iZRKoQCmw4ngH01mLkNqdd/1vBOa26QVi/E8qtVtIDx0+gYDLCVdvION2+lBIKAHKMrbJ0xEgRAi4m9nO5HOGm0ms5nO029RnxAMJW60gHBIU588IagsI6eKR8lGiMoUDuM6ZzjxjJDq4lR61u7W6u3ENPZCisAojNsPg0087k0pEiBh7FNApUGV0Dz/mklxYCGtaFKphh4ay0Lm9OantEpi8cJ0ri8xnX7zke5rctvBappK1W2QtY1+snfAiaPQzJUbk5XgZSFSIVRBxlEZuO3oE940EF7iEzziYawj1/awq3ivxzQLkw6iJaFx2/+Ii3kLBoNeqpOQas+SDXkaq0egxwZLzI5D5Vh6bRvjjGmzjR0eG3fWMpaNkQG7EhTie1M4bhPDHH/WB3gEDpHG5r8CeFl6Wtx8xDz/jwNat5rLWzd9xCQ1Sd1p4aDG3Pfg2BLJWsl0YS6Wx4LxJeLtWgtmGDUIcuFSCN+jd++FcSxNuMq5xDTWtAPbu/EXDiAZv/4TzbmF3dIZ+fHF/J23ICosq4OKEUSzC5WgXmar+Bp6aslstfYIatZreOQpSLltsrnla1fv6OHdyHHmXG2669vkUQ3zjXno1nA6FsXpiMfT0EnkKKKq
 J8rkVWGy
 WE/gVdhthJyx4iBR+5duAl2So+7fnAoj/ClzU2mTti3tMqfBsrbdk3l7eC3dtdBTxKOUgE0yd8SIx2d+g0wCAYFrngivY9iJuzMlVOtQfyvdxhEQO1hcGhB4WKNq9OzqYBGZUSTvDD5KoXRMiU99k2YldJxN3Pn1aIOd1zQ+g0OwnoEuzDVD8YK/Ntn52BNa3lO9dF/Vasg8GCxBRuB8vIyF0kn8yK4iP6pQydeCcwQf2ecrvEwvwGk7gn/OGNIogaoHjdqCoWPIuYIUfWQxxTVsmvtILl+HyCaX0Ik2YRBrjk0Yp6dN5GJY+Xw==
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

I can take this patch through the cryptodev tree.  Is that OK with
you Yosry?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

