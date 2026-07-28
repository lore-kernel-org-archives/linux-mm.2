Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37A65C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D87DD6B0098; Tue, 28 Jul 2026 11:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39056B009B; Tue, 28 Jul 2026 11:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC976B009D; Tue, 28 Jul 2026 11:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81ABE6B0098
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:34:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02D92803D4
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:34:55 +0000 (UTC)
X-FDA: 85038583392.15.C86B544
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1D00AC000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:34:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qXYEsXld;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785252894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yj9at0AOCKB+hFHP3o4jYqBof4rkU5PEz1Cj3CzlN0o=;
	b=iFxQYd21Ho95LC31iXkXxNStVka/QLWQuZPmOqt788p27kuXXppwI16YJsJLipaP6WZ2Qt
	b0FDiyGPzqLbDVHxQmHsbodgJKn/+1fkQiz51qWSo6nWKvB28cK2bW9g4lcQM4Ki5BJGVs
	SgfRb+zkXbJ7bkxxXRc4ac8INSVv8/E=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qXYEsXld;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785252894;
	b=7HruE5Ouoa8KV7lhDufPZYfmduD3nnixt1ybxAeKCPgi7SFw3wefsNfTc/sjnf4R4Aeg/X
	uAKoi78bwd+qyyCgJJQEH2cT7Lf8mVnGi4y2tSRdSSuPJzeKfta7gzcb4FzifXubTzCoj8
	ybqgBEGPVXKRx0R21UT35ubvJpZoPhI=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47f752b3423so2510620f8f.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:34:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785252892; cv=none;
        d=google.com; s=arc-20260327;
        b=VvU+2MvW5fwJ2idvVYphmzCVmWre9wncKT1E73/PCJSFNDbfPYmKRPf4i04craFDuU
         2IXVv7SDBXw6vFrArgOTNYeM23l4vKElnb7SZ7iawuXrcfteajennRWviR4Xv6+KNNuB
         KkF9nr5CIu/le1BvwNCaHgLprrvKj0YvCGbCeAF79zzYxfocIfnZYdsE1+fJ0GHYwjiE
         578KPD8jXp7aEE1FcvjX4klUZsfgN99+9ARarzsK+tACgNmL008eXj6xx9OcwF+csOyg
         iNAxIFtgVDPfBkqTtPg48l5bdiY8bbp70ucZs/dCVOKJQIlMYV9CswHxLXyiOBXCuJ3w
         9q6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yj9at0AOCKB+hFHP3o4jYqBof4rkU5PEz1Cj3CzlN0o=;
        fh=Cc9cPp9RUo29CfGM9lMQ5F/VFGRdA31Hhw2bla1LZgU=;
        b=gBtSDQ8K+geZM7s9Hnejpivw2WEcQuC65Mlekoi27GJi/9ebtxLh3wkZFsqeOCSKSl
         W+joQrxIrHeIJHF5B/GhJlOIZgJhDSaAedFTJjB3tpVt0+rhm92K8F4NGbqxoVjWJRta
         Q8B7u5FjmDOb632VecG4KDlMK2Xk0mT3P2P77j6GYGw/62ekV+47zENRYt8bpRKjRzuo
         dFUQsyEPYBexrA8yFjWqzwJNUA9EJzhZXIO/12f7d4eC/epqOY/HKI7szyRzaf7yfBZO
         O5cCeMgvmNfROeJ0oZM9e18bjugLPX4Ff04cHN65KSi2ct1o9/TVC0SAWq3T8nzBqBYn
         2ppg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785252892; x=1785857692; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yj9at0AOCKB+hFHP3o4jYqBof4rkU5PEz1Cj3CzlN0o=;
        b=qXYEsXldZoRDO1X8WNet8B2WqVWHok2OkAvGH0vQPdozsOS0bWALwhz+ahFOydXWja
         YV97DGD0T4oh4xFlco6ck5TgaPeUFSqpdliHFnVadS465BCol/jex26crCkBYD1JkO8y
         OQIXnkSgUcpzE6nB+2s5MNfzeeatcweOMaDJxZSTPooBmdaKHRPL5Asy2+VHWVnHdDsC
         PeZtx2CZlso8rL6Qw79rtSVrZIQ/SnaMtKwKPEKLhL+h08uqy/DpC3EZxUxRdPrgknkq
         7CYkDcbBa0xmuz+kO7YJuSN5ia/f5EmuDZcg2esu4NXHEuBJxtCUX4q+bjlgGxUrkqF6
         49bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785252892; x=1785857692;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yj9at0AOCKB+hFHP3o4jYqBof4rkU5PEz1Cj3CzlN0o=;
        b=Ozt6zrJGZ4H1dnp2RZEWLkxn6YC52MOsghHV+LcZCaR9fN+iQ+s/eMWq53PMgK/ODV
         7zk9Jn/6APMpjQgMP7MCmBC+xth/Bx0e89ku5eUbOIogqfZ70G+vDNz/N/6HfdqvHhT4
         raceqlwcxtlnftz5o8FW8uMwLjLRyCzdXdxRZuEpj7L4KolklBoaJbGVBlDXY/oEAWHn
         RptG6lIWxt5bAtDcEXgG/SRuo0B7aCUttBIZ3L9SKw5uvagYk+04YGeu4lUF+U/tfPIW
         r022gEwrbiBF+gP7dAl6OTrT1URqqDbRrm3d7ug3HR40nAnD0YNIeqmW3aacfCBBVL/5
         uttQ==
X-Forwarded-Encrypted: i=1; AHgh+RpMbCe22clK54LyCnB1wTLR1WpE/fRq8mbr3MqvkMseTm8qB1YQSoFiZ4XYLhXJTsy6fchTltB4uQ==@kvack.org
X-Gm-Message-State: AOJu0YyogJ7d0v29ZV+efYfT/jf9XnPobJEmNis5ZqGEAtMEgFkjCHT+
	OQC1oFHgu0jqazAkXC0qLoBDGhpHa71kcYJMHTMb/OikwBSPWxT0trihsYWEPnxJzYO7SRlzB4R
	gMuzZk2HCLj8QdjT/FyR9My9R7wVQ8eY=
X-Gm-Gg: AR+sD1205D0VrVE0FgX/LNQ7bvpcGhh/tDiKztN91fOfWW89XxXrnkcOqGxMgT943b3
	o7v5kfJCncOu+823TjvTiibzgeJkXBOhfL/edex9oRLG7qC7a85tl+HA4xtfCK8jPqH13TXl3aL
	Yzs/PtU3UTuE4wWbcHuNwjR7rRxIPRHCJ8ZyyaFhZ9ktyd7DD81Iyg8fH0vlKr9iV7xg2JRhZfq
	uaoHD/Ll/wdMbUo9xBNYskC2a0IXnk+GK+vc8EcSL9O/TuoWMNP5gt+W1JNJGa26sU55rnpIBFc
	K0YmsUxeStgR4Q==
X-Received: by 2002:a05:6000:1787:b0:47d:ec60:658e with SMTP id
 ffacd0b85a97d-47fb1ee079cmr3694666f8f.25.1785252892253; Tue, 28 Jul 2026
 08:34:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com>
 <CAKEwX=NLEmRKbgf7e4mQ8ynwGLhe8d3orc_2U8n-K_W6VjOAoA@mail.gmail.com>
 <CAO9r8zNbw4T4O-TtFsd9NMJh2RKRDuXTqfSKgMbe6o05MZxebg@mail.gmail.com>
 <CAKEwX=MwhU74Ak01kEa7VL_mKNY1gO_hX_aAPvMkXo-72MB52g@mail.gmail.com>
 <CAO9r8zPsQ6rzhuRopvepxmrXg6q2r+ixRvL2vdG2FVmxBcUn=A@mail.gmail.com> <CAJxJ_jhvyMukPLThpgcdCMHwbp3b3bFvc4Va1cK79_3z6ubhwQ@mail.gmail.com>
In-Reply-To: <CAJxJ_jhvyMukPLThpgcdCMHwbp3b3bFvc4Va1cK79_3z6ubhwQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 28 Jul 2026 08:34:39 -0700
X-Gm-Features: AUfX_mztKPCw7WsmE43lJFHVaI3V3GgyLQxcKgudtwTxI87lWz_isp6HECCdSYo
Message-ID: <CAKEwX=P-+=tfmohdG5+QKsrsWNyHtVahFv5+FR5nLeSH=kk-pg@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/zswap: reference the pool by index to shrink
 struct zswap_entry
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1D00AC000D
X-Stat-Signature: xq8adcnccmwp8b7x3uytdy48c5j7wr5s
X-HE-Tag: 1785252893-104458
X-HE-Meta: U2FsdGVkX18zEBcYql+x0w7pQI0yTs43YqD7YadVK0jzB405Qtp8Br0vlPAwZe0RtgGw8M878toUTqmtDIKmykmsXbfBVhRPdkV9cdX6EkRmlgd1by6aRU8iCFuq9pfT25PQWixTBGN2PgNQf1BZ7bGatmeydsGEpeSD5TBjQ2oxXVWPmSjqO94gEo2E62mFcfGHSwQzdjLNHdZirbq7M9zT3uUtccrniMstco2cRcnD//zTgM0+IkxgFn+eBzhaxnfKItnCM2W72wjy1m6eDeBXvcyvVpQ8K+K8obsYn5XrJJaOHfFLBcAn5RcP2n6ipUqKuJOBCtOsakA/5TPd9SDyjwRFNDxZhmvNTqTVmPycMfElZVojUSX+iiR3cSsrU0cJGyqtekOhIEM165hmaEcZ10fik1XSX9hDPr2ZUqzGULb/AGQHxQbYoUaRvM70GXsiLcTR4Tbgp/PDe8zkXf1nDOIgWhmJsBUwDiSoqb0K6ZXIiU1O/BY+NpE6qew5kvQeN+KRUK1X7ItVBs03XOy7FcdPz+ruI3PTVo2ObpNWQHMtRVTNEYy9tyZ9pM09Sk0e1mPrSn+bIvf3ve36x3sjCqvc3EE4limyWF+EVE9n7XxSVToDwQEqdKkpJiBvLzxLKVOAvDlrIxoOVxoXCJFq2Tcw/kHwkKWhbvbKHcu3NXxDSfydsElxDuSNGDn2bHK6a0fdC8ruSfER8uPXenn7dx72rpJ7k4ahyrWJJbKeOYrp/frR2fA32m53rxX8gbFsdlEcrWTy39OsxhIfaXQQWrfI13rMnJ/AHiZ6wK9tFa8U+IAI48H/5PT3PNvS395UBwgXq3/s6nVNso1RFWYdrrded2ZJ8+GAr0NWBLuUHhi0fe2N9sH5Mn5Kk9dtnzR+oki7PeiKZDPj5uW1kNV3hFSKuqMtfmwyu4hyC+c0s9oaakjjuK9D8JCupIhaSi19OVHjN+8m4N0WRQS
 fHmDA0i2
 XE++fCIPrMi9umKXLIne9tSKTHi12N4ILr3cE+lC+FvZvnK/SeElWq+i15F/sp+02wiQ3bJ1GQ3BTwHhDGBBnftNMbExI6j6p4uM7WvPgnaBOd3Y2xBPdKuM2W5j/dvHM0SE9iffU7MNIeGoijPD8d4sYyMtHoN7Dj1jrPjhEfVSwcsozI4Uq8K5SDqWkT9oBudLmrMS8B1FmGAyUeB/O1boPKJyzHvJhmI0cnvHdNB3Q1fh1p3vOMQy9EsBaGgsnPoMzsjX4KFCf7P84EURLW8LuJd1gi3UfC6U/H2cE7kQZyDlnDQPC22E/0V/YTsoMO6OHZWe8PvLAPAac16qGh8D0P/X6U+3GYmdu0A2VDCvr9PGp5EHpbzBb6RImv5kwMMD5u8Pq09XqPZ/EJofzbhPTQst5MZaC7QTijkqKXSNHspMShF69irrcQpLRC39N1RhxFruVUybY1YOnJ/15Q0YoNxYqqm5nudBb4HQHlH7NrOJgnVe3nBq0NGwWN56BmlbiPmrrfxpOkMQOyhK42w4RFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 6:17=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.com>=
 wrote:
>
> On Tue, Jul 28, 2026 at 1:07=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
>
> Thanks Yosry and Nhat for the review.
>
> > Technically we are introducing a new limit on the number of pools, so
> > let's mention that.
>
> That's good, can simplify a lot, will do in v2.
>
> > Did you try to benchmark it? I doubt the indirection would actually
> > show up as most use cases should have a single pool.
>
> I ran zswap e2e benchmark comparing baseline vs this RFC and did not
> observe a measurable performance regression.
> BTW, it seems zswap crypto-sg zstd and lzo are slower than zcomp.
> Throughput in MB/s:
>  alg      | acomp store | zcomp store | acomp load | zcomp load
> ----------+-------------+-------------+------------+-----------
>  lzo      |        1140 |        1710 |       1070 |       1070
>  lzo-rle  |        1490 |        1320 |       2030 |       2070
>  lz4      |        1520 |        1600 |       1710 |       1870
>  lz4hc    |         640 |         680 |       1770 |       1850
>  zstd     |         740 |        1190 |        980 |       1720
>  deflate  |         180 |         180 |        665 |        660
> But that's another topic.

What the hell. Do you know why that's the case? That's almost double
the the throughput with zcomp???

>
> > No need to document the function name here, most probably will be
> > stale at some point.
>
> Ack.
>
> > This seems like the only user of zswap_pool_by_index(), just open-code
> > the xa_load() here.
> >
> > Let's add a NULL check here to avoid blowing up if something goes wrong=
.
> >
> > We need a NULL check here as well.
>
> Ack on all of these.
>
> > Maybe just add a fixed array and call it a day? :) Seems like we can
> > probably get away with, say a fixed array 16 elements.
> >
> > If we want to be really conservative we can use an array of 256
> > elements indexed by a u8. That's 1KB of memory, probably mostly wasted.
>
> I prefer dropping the xarray and go with 16 entries indexed by a u8,
> keeping runtime compressor switching, which can increase when needed.

Let's go with that. We can be defensive and just block users when they
try to add the 17th zswap pool.

Look, you don't need 17 of them :) If you're switching to the 17th
compressor there is likely a bug in your userspace config/scripts :)

>
> Agreed, the list looks like unneeded complexity, will have a try to drop =
it.
> Looks obj_cgroup pointer can also be dropped on !MEMCG, but zswap usually=
 use
> in server with cgroup, maybe not worth pursuing.

Yeah you can leave that for now :)

>
> Best regards,
> Jianyue

