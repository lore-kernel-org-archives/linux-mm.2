Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EADA609CECB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WVLVPBtv
Received: by kanga.kvack.org (Postfix)
	id A92CD6B02AB; Mon, 19 Oct 2026 11:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44AD6B02AC; Mon, 19 Oct 2026 11:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9329A6B02AD; Mon, 19 Oct 2026 11:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7CA6B02AB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:14:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 018E31C3EE6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:14:32 +0000 (UTC)
X-FDA: 85339722426.08.680124A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id EE0C6100008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:14:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WVLVPBtv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792422870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80EtpdVDdwo9wKnZFJQeT1iQ7dsKuP3ZzDVfRulgDQQ=;
	b=FZkClFhSG+SIRiQmJR7pD7mGyDEcb1wewn0RIqX0Ns1idA6F6ZCOfVYT2g54AtxS94oJL/
	xqszW0KKMFffr7BMN9N4Q4sNASdaJe+R2umlvhvNb29/P9gXn3Aa0o6671qV3g1A01PrCq
	aoJVQUOoQ10GtPRIh2raUpBe0d5RX/Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WVLVPBtv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792422871;
	b=SM3cVgPpZbEhNjPEFubqvw2iisfys2VMez1keosKgOLwei9kc+1e82lRm4Ks/6Zs87CS8S
	fA0tdyUnKhQm+VonNZ/J4xllQnvedMZW7m+U8Ouvc61JBtCXd94x6xq6Nr9IE40w601nyj
	BrSe3uQ4jnDAZAAqHDsNGecqqmOtHZE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6312660210;
	Mon, 19 Oct 2026 15:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36961F000C4;
	Mon, 19 Oct 2026 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792422870;
	bh=80EtpdVDdwo9wKnZFJQeT1iQ7dsKuP3ZzDVfRulgDQQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=WVLVPBtvuDYvooSX3aytg9/zskV+QECbtCIZ3FtIPIZUwkcAeQ4KnXr8ALqAIRXoP
	 XT2Bnhj+XYfvJjlYhI+RlDHGCEUeeZCUJG5MVqMtThDnvJfgErSlYu70W26iNIMhFn
	 RcaDSkDlQjA/3fksCB/P5R83yJF1USiYTjXOENSyqPYPeK342MdyX1bI5p3bqrS1aA
	 8vZiMJ/WdBSrX97upqwtcIHK5VHEh/2boXdpAjO9Lf69ascp/YH38Dk/woz2Phqn9E
	 ZGC5FIszipVD1f+7niy6auu8PnI0wq+JeN4tlHqPL5MZ5QgOT6z23DwjLshVUQVtJh
	 2XBItIH/D3W/A==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id EB370F4006B;
	Mon, 19 Oct 2026 11:14:28 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 19 Oct 2026 11:14:28 -0400
X-ME-Sender: <xms:1DPWaogwgLSKSy-OlP0O_lOI1SPmRVkUeAzWZym5GjMeeqbpwVPexw>
    <xme:1DPWar2tHY_ldW5nGJh7r8rfX9iV6nmlVm1_kHSN5mdDmYsCL8EWz5smO-hVnY4Cu
    -NhIfZChyroW3P0wQBUWI2Nn0zc2QRcQSrIz_CjwZbFSNJQLVqL5lpQ>
X-ME-Proxy-Cause: dmFkZTFD3iB6Fi9wEihA3a+/aoG1DIdu4gKSsQ+2y1bIXEoaqdBebrGrcnUodJXcKgkR5q
    YBO0xaHkPiOP5d9uzGN45wzhr5LWUB3Qw59jbaNjBanA5VfH3AvHYZ7/278q0OhLO5nQB/
    utcjleP0cxbocTWzcTmSdKFCwDeM4waXpzQ0te7oaxf9qSGQVFMbRARxJUvCfX/CgK4d7j
    fmOigay9TLvP09zXKX/hqOjtmGRunPaDOwCkXazQMTSK2RpBWwEUwoymiB5mV4jExn08jt
    gksfwM9AM0D+/P4YxP8YD7rd12BC4o9pNCiIypgrVh8eDskaCplPQFPZRj4eGErvJNxjcz
    jw/sfRxkv0avpE7gxDPo0olAGrldZx6BbIfOx7Yyww9odeXpRwYyP5eASW5lz8nCrbWHtM
    Yzquq7EHm4mtIRPVv+SBGBDinjCUBs7p94Qh8Ov6zN/kAaBJTVRB7ZSpzgt5lkWdHL1kiP
    UVMGhZahw9psbRryQn6SoSzTMV4gis14mmDozEi430hQMuIVe+bxnYmDcBiSeMWcD3uFaS
    OWACcGRNfSxxIRgFFi2zq33FiopOdYIQAI5yXo+kT3RAEHW+KwavZ/QjFw412Kh7mM1zac
    bdEC99ADli4sUIa1WkOtLnfszKzKvoJhasWO7cVKjdvrNhN4UWA292i2rUcQ
X-ME-Proxy: <xmx:1DPWatjqVKDPiGAwnO3rChM9-X8-mIQKikwjCAt09Hj9I99Wr02qWg>
    <xmx:1DPWascb3yfMl713G-sdeGRQqfVL7wDbjIp2M4czwj5g-Sc1aYuPHA>
    <xmx:1DPWakkc0uy4gzKO6JBAjThFYal7p5I1U9PROppUBCajAM9uXGvq2Q>
    <xmx:1DPWapzCG3knP9IXOzxIfSucmlgzAh5cHwkTcvaOxZSJ5WYDTJzLOA>
    <xmx:1DPWavyj55aJqTYV7jh83GbaEowjMFyW8bKyAj5-7p3mR0Pdv3fw1rNn>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id CD0FE782738; Mon, 19 Oct 2026 11:14:28 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AS6kSLE8WzSk
Date: Mon, 19 Oct 2026 11:14:08 -0400
From: "Chuck Lever" <cel@kernel.org>
To: "Mike Snitzer" <snitzer@kernel.org>, "Jeff Layton" <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>,
 "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>,
 "Tom Talpey" <tom@talpey.com>, "Christoph Hellwig" <hch@lst.de>,
 "Jens Axboe" <axboe@kernel.dk>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
Message-Id: <78b61d82-8f19-442e-8e0d-6cce861e49af@app.fastmail.com>
In-Reply-To: <20261019150725.1507-2-snitzer@kernel.org>
References: <20261019150725.1507-1-snitzer@kernel.org>
 <20261019150725.1507-2-snitzer@kernel.org>
Subject: Re: [PATCH v5 1/6] NFSD: add tracing for how direct-mode READ and WRITE are
 serviced
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EE0C6100008
X-Stat-Signature: t6fd5aq74oppe4b8aci9cyrhw1iu14bt
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,RCVD_IN_DNSWL_BLOCKED,
	RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792422870-254496
X-HE-Meta: U2FsdGVkX1+DSVVOVWwK5Je+MWw3X0S7IKR9InhFH7QCvnwICXUnANXWS5AyNBop8p4rRz534dgW5GZVfyfOmXjN8ouJU4W205hkr8Cp6+tJDR3bjStSVDh0NzXRuIyo9tnTCi3SYJchscIPZPIJ8Ky34MfnGUZnd+0Qq++xZURcDYk4YtNdCLmR61JMAoN5Z0B2gx7Q/hdKvzmzZOEaByPR3z25OxmQ/+86ZeSh/ZGWIpxVDA/QL4wYV9K/Ka4XG2YqFu4uag8NKnle7LhWXFxKNMkd+dq8MJCo4ZJy7gjgExaSA59bU2V+lqQdbmopSLJbiC/aT9z0IXRs5B5Cn7ZGrVfA5qDuDv4lF8Dre0ltyV1Gd5b9Jc5T6eiKwnohqlr1MsF5MJksQmUOVhtr150D0SqiWGB+Xu80dB74hpjjcRh7FlDnOtcudwgtdHX8BAx1GIvIw0NlVmwKoKrF7yAv1K417IwYTpICG3gY9L798CMFMAwibroOH71evEWbWcc6iy30RfF+e2AktSH3RUuEZaR6KNkT1qzZbYq6qPpEJ08fYTFGKKk1eLYPmZkc9CRMUcI7EwOdARLeBL4K7XV4GEAazJyMP1yDhoshcXR4VuS6iybeVhitpP0PG5coa7w67DTEoZbstRw+OxPsgAVXx7DfhKAJBmweKhgfB5usVAfi+fFrvVZ0p6grkarIzt8L69tKJIUsLjB+Ux3u7z6wB++yRcuejlJh94oxfcjoVXzEUPGnZ+UTCNgvRUVRmeZg00aWvmtKW2mKv5d7A5pbuiAA4EBuDmoOshtMHaQR94NgLglG3q/co93LGyRsTHmrkFQaJ4nmdFysidSo82T6ruYpE6EDxblIOBJIkHoCqchsnh4Igyyxb3awx5Ov/KkNb48xbHlcQr6O2zgX9Q3B+0k7MtQvz4e+u2p54qglB9GClBfnqgA66aEs+y6KiyKQDS4eK6hzzZSQ2+k
 0RWH6cgj
 PY6QXasDfj0+1OwTbA5rjLqxOCYkc5wcE+c0YR9xr9M/OrM7Eg6vs0O6zB8fHYmhzmt9fo9xyfSJbAKPCLO9yaRgrXF/iIJJt5KmdZfQKwXaQd1G6cDiOUB7O6dJamrvV0gQZRBt0eUXz3BvvDQiTyDb2zpZmCrqW1iUxfTTj+mTVWiEaUpSe7Hoo2EIoiu9jW2zu1InRwsrSccZZ7SFi3A73x/higgpnJfMh6WrOWQgRIk8uiGgbIhXJmNgjHFiP5Inx+LPMmeY7igkb0gnuqW7CpxdsIs5VuOThJ50BM45yNDf/cSVIWYqVzXxse6bNdDcW8fczn/C2k+JPLBB0/vq2m4DLJPE6qdjA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Mon, Oct 19, 2026, at 11:07 AM, Mike Snitzer wrote:
> When io_cache_read or io_cache_write selects a direct I/O mode, a
> request may still be serviced with DONTCACHE buffered or normal
> buffered I/O, and a WRITE may be split into up to three segments that
> each take a different path depending on the request's offset/length
> alignment, the payload's memory alignment, the filesystem's
> FOP_DONTCACHE support, direct_misaligned_min_bytes and
> direct_misaligned_dontcache.  Until now the only visibility was
> nfsd_{read,write}_direct for O_DIRECT and nfsd_{read,write}_vector for
> everything else, so the DONTCACHE and cached buffered cases were
> indistinguishable and the reason a WRITE was not issued as direct I/O
> was not recorded at all.
>
> Add:
>
>  - nfsd_write_dio_split, emitted once per direct-mode WRITE before any
>    segment is issued.  It records the advertised offset and memory
>    alignments, the payload's offset within its first page, the start,
>    middle and end segment sizes, a disposition naming the path taken
>    (direct, no_alignment, too_small, no_middle, mem_misaligned), and
>    whether buffered segments are issued IOCB_DONTCACHE.
>
>  - nfsd_write_dontcache and nfsd_read_dontcache, emitted for WRITE
>    segments and READs serviced with IOCB_DONTCACHE.  nfsd_write_vector
>    and nfsd_read_vector now fire only for normal buffered I/O.
>
> The disposition enum lives in vfs.h, which trace.h already includes.
>
> Document the new events in nfsd-io-modes.rst, together with iomap's
> iomap_dio_invalidate_fail event, which reports an O_DIRECT segment that
> the filesystem serviced with buffered I/O instead.
>
> Assisted-by: LLM
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>

Thanks for sinking this one to the bottom of the series. That was on
my to-do list for today.


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

