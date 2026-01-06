Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 684D0CD0437
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 05:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595866B0088; Tue,  6 Jan 2026 00:08:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538DA6B008A; Tue,  6 Jan 2026 00:08:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442516B0093; Tue,  6 Jan 2026 00:08:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FCF46B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 00:08:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC63E1B4B8
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 05:08:42 +0000 (UTC)
X-FDA: 84300358884.29.C001E86
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0BBA5C000C
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 05:08:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=aiQiW5Ty;
	spf=pass (imf28.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767676121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFbnawxlHXDDkgXSSpYv3ae8u1dbcbfkYb5iiUdscbY=;
	b=0L4BUAJKrbUq9zYXPLNm8DQ+N8kpWHW+YlswfIia7aNhicRVYfEYKWmE74PdRw+sYibRWd
	ZMhAc+J4fLrkQsK5C5Swmb6QmZPkVKl78aCgz5L+OjD5emrstgVYUhMN7MKSdBfKO/pN7k
	1C/wV0Mugum4Nf7RZQuTzcuVBcvKa9U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=aiQiW5Ty;
	spf=pass (imf28.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767676121; a=rsa-sha256;
	cv=none;
	b=Jjwesb1BKNuaY/cEvvceYPhA0Xa4z2YqV1OFjKnF35x/pTdvUvaG7jAHrS/G1uTIZL2lXn
	A06HvPwmqLA1cAaZUFRKa3IJKpCzh56Fj/9NYJOiNe34flMpMDnfMILqyf9m3PahM8xlT0
	xqDlHM/MY1Zs+6GXU8HzMrJ1NLbgXuY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=pFbnawxlHXDDkgXSSpYv3ae8u1dbcbfkYb5iiUdscbY=; 
	b=aiQiW5TyILuzYRMyoEsy0Vst58yDyzhehww90uNxQtv0BmNiISBPEmO6Gwt4lj6PiPwoGEZsaK9
	yP8RNgft85zHS98sF9U+9biJyL+FLGh2Rm4022NbWNyzNRG32linDyN0LnmHu+dTwZ1KzlwKWw0/z
	3vlG+3Z59GStyqhblp8jF0AtEDBl8HQuQEMaOVs6UFYKcFOso4KLySpCtYEKI2PU6CEjnyDTOBMAx
	/46WYAiK78baEj9eVpMpcj8v++DebputBqe/yT2NyMqONRdheHdvUNq0LQyCNBiKO89s8xkXQRG9c
	z6v9/m+0nuoxdY2GmLp6dyha8YHHQuRdppHQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vczIf-00EaDb-0Y;
	Tue, 06 Jan 2026 13:08:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 Jan 2026 13:08:09 +0800
Date: Tue, 6 Jan 2026 13:08:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <aVyYuS_usi-lpHkM@gondor.apana.org.au>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
 <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
 <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
 <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
 <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
X-Rspamd-Server: rspam02
X-Stat-Signature: nncwbzeidqeodn6jpbtxjdbc89bnb1r9
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BBA5C000C
X-HE-Tag: 1767676119-884376
X-HE-Meta: U2FsdGVkX19updVwe7GMdMnW3klq5LqQ6PRY6wVDxFu5/Y3GPqWT28Uw6UqXtaiHyVqUiFsMAOj2Pz51KO1vlLBTqZ5RdMA6/X9Otcx9Gto/smCOBBAH7oWeBtmRM+bt0pFoWcT7d9lTl5V/uv8BIP5flpgOFYqs4xIiObaZ+Bu/hvuw/ZZq4sghgYq2J/jOqeHq7Gg/q/OjUhO1joUIR/7QrdhY9oqDIPRBzl7p0pECHvei6GKtYI5gasOOyiJEUlmoiqCKtZdxcg2YcyInr9BTsGWrxX8g9W/CtuJon7+LCANNA8CGsROP+/B3B7U9KQzc6SOWLftN6LuTMEsBTX5hslUmF7cgd1Wqq/8hgUyJyfXHc/stQhynkDkS90AyzyT4xkhQJggZfDo2nTRnntZ93zC4dzjMzKHQifL9xcotOjBjyKVPTfs/YL3Mf8d51KOyTYH7joDfzpz6ndRYOOitZVPKnJP7BoYvkOEBeIHDu8+mcRoO/tmaOV0QCrM9phhuhY35imieO3rsPvavu+sCfDc6PSSgo6ckSpXW/cGhy9SCayiKlkBhL2lFSCg5LHOyMWDSg0bd7+kTHjL56zw/+UDCep/SppNMjt8qXl2yJyTPSoIIVAzuHMPCC7GEOcgsfsdqKZmMPIX5sHN5/BzPy2cVbQkAHUb58DAi33SAxqCpfwPk+zhL9azooJ9d3y0Cc2u/0TSVOfalYVWz05yabogPSewGWuqujPqkBfeA4PeruJ8BWES8+cIygnL93lskXIAm6LdWELUrU16+NQeRAf/JsJVQM/DKP3PwBbeqHdp3oBT/SiU6onqltvHHyCC49SYNKvsztq3nbhV0YGIIpmNq5Kvde9Yn8KaYBoW/S+dPTwIp32iOjpLsthHTOAknkWYPqVC9eAFeXSYreBuansmpM/+9UmFqyF3qjn6V2m70aNKiTpfEAMjjXFJMdegfQ7DnBO1xfM3JCn/
 8Imd/Mu+
 teKQkOvQBSMkkD/ReZCZrxTIARLUKHAVmy/grPkGXSkwoJVlx+vu5A9KPF9pMtOGBKNz5QJQxL9DkWZrzfXrAWiR5CIUAtJUWpSEa/bg/Ge0W7djnhjW0IByII8VOKCPfk+Bam3CsYAA95zjnW1kH2cVaffQb1BEP+9vjfqqoVVO+OIDqiZqEI4AWrGE1SiMVEg/K4sgBPEcocD5Is4oc3xSgIJ0wLdpTxTGfvM3ye6S/rAT+wa3Ec6jSDhSCP9Ocq+vB3bDAXhJfEDZGjLNIDoEH0npKGK0MwIRc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 01:22:45PM +0900, Sergey Senozhatsky wrote:
> On (26/01/06 13:20), Sergey Senozhatsky wrote:
> [..]
> > > I am not sure tbh, adding Herbert here. I remember looking at the code
> > > in scomp_acomp_comp_decomp() at some point, and I think it will take
> > > care of non-contiguous SG-lists. Not sure if that's the correct place to
> > > look tho.
> > 
> > Ah, so it does kmap under the hood.  I suppose that can work.
> 
> I'm hallucinating, sorry.  Yeah, let's hear from Herbert what's
> the direction here.

I have not implemented the underlying SG support yet because
there are no users in the kernel as of now.  But if this is
useful for you then we can certainly do this, at least for
LZO which is fairly simple.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

