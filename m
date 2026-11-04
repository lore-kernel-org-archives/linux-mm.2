Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D45606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 05:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=nKNhpjXt
Received: by kanga.kvack.org (Postfix)
	id 5E4E96B00EF; Wed,  4 Nov 2026 00:58:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596686B05B1; Wed,  4 Nov 2026 00:58:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AC676B05B2; Wed,  4 Nov 2026 00:58:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA1F6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:58:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 987F7160659
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:58:13 +0000 (UTC)
X-FDA: 85396381266.22.69C216B
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf05.hostedemail.com (Postfix) with ESMTP id C7633100009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:58:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=nKNhpjXt;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf05.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793771892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GuMgcgXi2d8E9GAegF23L5yqInpKNepyztEiRzZzVFY=;
	b=WCBY3qj+X5X6koxJTtL1wIGnCVq5HG3PTI8d5HL5Fi6xMjV+hLseiSf97hwRRWvxJmKdhv
	hYNTF6IokPtBQoxIcUIq8Ny8eaPjk7ubgPU4SVY+eV6SsCWUkPSRsOBvrAaNQexKm3wL+8
	gSlo5AyFL9vWXS69Zy18gklorbCVLmU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=nKNhpjXt;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf05.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793771892;
	b=BGdiJEGqELWAnKum4j1hEruBP5GRRXhRDY3Zfwdg9shcp7VdqgqoQjCr/FbZcNgRyDFvm/
	sLxpm1I2Wrx0/1J8XPTY3IbBWazk5SEh3oMd0mkdP3PRtdJCtJzDbHIZi/iY16wPeb7+j2
	aAPj2WLmqMtNmIJFh90omIUS/Kmb3Go=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GuMgcgXi2d8E9GAegF23L5yqInpKNepyztEiRzZzVFY=; 
	b=nKNhpjXtNFPq3RPGi6Z3gnojYnP7E9wP8YpuIKrmvFVH9l758u0Z2rhJDSDgSCm6+owCN0gKm3Q
	wSMC9l9y9ZHRsw+HtyemNhMuTKV2aSYs8iccdsfHA4+09FuaAXGjPpmJtncoSiwlMorNl1NAO0Mol
	WDM04nQVzydHwNsEojj9PVyNGoPhm24p4i14e9NI3qQvnvvpMU0cyHWwhj6s8MIatcCvJDPZcM/5g
	fAqdX2giQB8BmTQoPALJXawvKupLSiQ51WcQZzIkEDNecXkW3yQ2Ob+kNh6lX73ziNnpXftTo8+NP
	9Ds7ZSeaaTHFcLIa6C+fEFpi2IQ+kFqTi/Pw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xOU0V-0000000AkBq-1V5g;
	Wed, 04 Nov 2026 13:58:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Nov 2026 13:57:59 +0800
Date: Wed, 4 Nov 2026 13:57:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <aurJZ81qnbiHH_P1@gondor.apana.org.au>
References: <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C7633100009
X-Stat-Signature: 5ufbth1ep6oobscegaaqcku83zt6mp7h
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793771891-849880
X-HE-Meta: U2FsdGVkX1//CMVsDq6ML7RnRwN5TfjMeJLpOKapjXAKW4R1JJaglQ9dSM9hp+kUf/9Pul2md+ddHXkhfxqtka2k9Ea87RqMBlFdEZKCEg89STX1Wf1zkNCMrf5XbYBEvL3jBmyhjcdU3M6Gm3wE8BhKoGUHCt0vJN+J8+0vFTxWhTxkddEqNDmg05W7h8NYLxnjZPPrwbRXZtNx1SsJwQROuXHn7+AcZv0/oGh0GInLSOhS5zuAD6/FSFAUd0spmPiEfWIN9+k+AsU2mIF8bn9v+xyL+ChAVFnRSvBf9SLHVmvBUDzR+MPsIoMhiBxxDR2Sxg0Qk3fpsbebfua08hxy86FB1/qsizk4w4DGXltD8juiTcwdi2eLRVM8DBxeIlpE1eOl9XWlyoxPWd7whDkiKOmjc0Lv9UonYHRvW4xwAcJsRmyAFWdCmUZcbyIJ+iK1dNM/aXhT8TOP2OH/SiVE+ASdrRckqpFT3jQzHMzi2mYBQFqjwmfqwsPBVs6BNP+Oy0HrwQcXQ3k2cguIkXynkvWxBkAGZjk+KjlXYaYdLjUIApi/sfBCPOqy/TRCvkSvahkzeEnJsYfw77PDQ3B3rMfL7s5En+dKD3mH6A2l1GUfjIf6e4OCc2S1LYdwr44nH6CUNQsiZRJe4N4xJMkKuqCdsymsuPeyTods1atvWTaPny762NGZM7FEwMDDHi9/SLD5Jvab6bySKsU1+p1Tp09acVQoMABa5ZrI4iCOB0RtsvpkEB+g6uvXvsko8ub14FQTYVFCg1VWVcmvCxy+lU51XaT1cF5tUDggY+ctQN2hauf85PNNrQiK1X0CUQLzNp2tPC6FxS54I0PIWvB4k1wUX/jwQe8r5q30pllvQ9gtWZcvvS6EQEURcQXXmxrEUkDXPNAl81h+JkpXlELBKa9WDMkuzsAkIrudAgLK4OFg8NhxkS0bCD/ni39nr4vmseigC//wlSAc6M/
 m+dA5uWL
 751X0QGZRwd6DgR2MbZQsRmNg712srBBySY6ZY+s6eCLFAJL43PX+oPWUv1pnVuyXMdF9aDa6YE72s/qs1TLjsV2qcfeocah5QejMh7327qzyKRYZuUs8fv6Y7YgkaP8+jBtmgjIDQhixnOKQqh6+AXu0tG0acMxuyFgnbF66RRbinqe1AX0GIZKNyuu/EwPEjcGanTHsWGajFYhFFYvuZekMRt5nKefLE2g9z2qEwZyHR/WSNgkQ+m4DtCCZLemnJbzouC0x9EUoQDQmydqnzdOwg4G3uEsg9V7HuLtU3JtkEMHqkUWW8S4RdC5jBmB0vLn4Od8H0VCrTO/aQqUPEA4ZV2nuk7ujRvnHcr1E2IqB5L/gkJjixF/m1uQ4WGMI7ZPzHZKYm0LQv2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 09:39:03PM -0800, Linus Torvalds wrote:
>
> None of that says why.  It only repeats what I already said: it seems
> to be due to kmsan doing bad things.

Fair enough.

When I was told that folks needed vmalloc under GFP_ATOMIC I didn't
question it any further:

https://lore.kernel.org/all/aeiHkG7X_dieMdw5@milan/

Looking back, it does look like it was never explained who these
folks are.

Ulazislau, so who needs vmalloc GFP_ATOMIC support in the kernel?
Or is it only used by out-of-kernel code?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

