Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F1EECC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 19:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10C16B0088; Fri, 16 Oct 2026 15:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5846B008A; Fri, 16 Oct 2026 15:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFBB36B008C; Fri, 16 Oct 2026 15:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89C6E6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:23:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06B7D4060F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 19:23:52 +0000 (UTC)
X-FDA: 85329464304.16.D71B0D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0B33640002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 19:23:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ic+GAUQ6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792178630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDxDHRYjDr4HrZlSoutLF6OW3h45qVrxe5irVGrAYMw=;
	b=QzSL6LSv3pwnkfv7WfhxhDeoNWdWbwJw/3Ri62RREuQkf7bUvgk31poIyV8oG16uv2ZsbH
	2aMY1j9+Jj0hkq92cXogkE/d8xr4/IbAh62gL1oMKL6XmdrqaI/uqVAUQUBCMf0+CMX1SV
	YBrKHHrg3T4fipApPuJYLOwrwcbAC6k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ic+GAUQ6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792178630;
	b=d/EyrSCiIzDQERLKdB0DNa9P+HhasgCt2hfUZhD4PrlA+ioSerkrlaYsRLnCaRKBBJN0gd
	McvtCmLBTDkBQbCeuIoKVWi2/i5DEmjx+RQ56/vZc+txVaxcMmNWS4LfUoJBFzdbD6AaLA
	NSFkvBi7jn28zVDIIaupigmaIBcEX0k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78DC860A8C;
	Fri, 16 Oct 2026 19:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8901F000C4;
	Fri, 16 Oct 2026 19:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792178629;
	bh=eDxDHRYjDr4HrZlSoutLF6OW3h45qVrxe5irVGrAYMw=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Ic+GAUQ6bNZfiEIxQG8434x/GXlrUiu6ri8UNwYMXgkObZcQUFX82K5Sit0EwmTLY
	 Xz/w0PpnRSTgclWwsH5lj/iWZeDVubpnoRikzklrXyGvi9d/lr8FB8E0th/N/6ecja
	 F5N7KmYYCLyq1IMIzm/Iocl8eENDd8z+2jzECSHx8MRVkt33zQa7K/GWSXMB5iwGHX
	 KAQdRtFOtWqdMvu3TJCx0v7riMOHMlwdfQK83aWx+QeJXfse6Q3n1kRkEKyZ4xV6T8
	 p/n7kA181GAuX7G2H/7+cUG0ZQrMhabiqc0W6FwiJClVbRNskCDsyceCwScP9GdtDw
	 lq2TmEETfsnUg==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4469DF40066;
	Fri, 16 Oct 2026 15:23:48 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Fri, 16 Oct 2026 15:23:48 -0400
X-ME-Sender: <xms:xHnSapmQa9LkJQSao7UxtiqzEL_tUqm21xPG3t2n_xIbspyWb6HIkA>
    <xme:xHnSavraUBIKIWVcsqSCSynMVzD_INpymrLG6GZcA8LfKWR4AVXJhkWhgg75tNMW3
    raGVMj-0zshiT8RJ-dXKznAzaP5bLmByVrDEvXWzTRpA4QXVw5Z4Hwg>
X-ME-Proxy-Cause: dmFkZTEV/OTu2cfy1D/4aCcfWBmdnYynU1kGj3uYGSyx74XdZmKu6IFptiOE4nfWNOl4FG
    LqS2axBCeoQIFB0g7ISVPd/LkUus9T/lwop0MH6km5J0X2Dv9tWyn2tQUhgfhaEIrqqc9c
    31vpN74rDHEqGTAgBCDOCLYMeSySBAxJLYnhoikahQrv6WSAbNt6bqxHMFPcqzadNQKXcy
    35zUqMfns90tS0m6t9o7lPCx8AupxdtDBLIHLdYOMgmDxvQ6pTMiCaA9LCn0KFnwYhnQNf
    sxxraDT85VPLLt7GbruuEEuGlexjaRUL152WT78Kz21ulsqc9atWBArPwU+AY+cgj8ZyD+
    uRq66WW3qddpQMKLzwOyQkGkoW7w6Pm6Uxm2O/h+6bJA6Arpj6O1Cw1L8coPJPCkWGzHHl
    lFCnutxMGd1e49MJEwn+/SutB+lhMkBI32JdBdU+PdRQ7qKxxK7VLdoF8gW561G4ExcBhS
    ZR973R8XyJRD7P+1K0vtWn6URpwd5C4fnyXv5NrVCKEFwhvPGS9IMxfWEWJ1k6wEtipuPo
    c7r/tvGVorTs4SX6kMAOHwRyYgILzNn/HmhJ+s6wKCB/8LgZ9cuhhjGmdcsH+re+6gGGXx
    1bMSWLOosPNW2Ks6t0XkpJr/1zdOfAhi+GLDsdk2zFcF2YuEWq0k3MmVDvaw
X-ME-Proxy: <xmx:xHnSaiS70WZGrR0zxOdixYMqHOj4130g_9XIITqTtEO98GnxfVL7HQ>
    <xmx:xHnSamCMF1Wjami5nhdDf1288g9mBy1tuyeFMuB-hMaRQriIql2R4g>
    <xmx:xHnSapJI8wICbW0VwTIb6_BIfzE1RNGFK9LB2WkQ-XKSuoa8yfsQvA>
    <xmx:xHnSahDlRU4Yns0SG8C7cMSFkANGhwt1-5j1ZCUHdhm503006BaqZQ>
    <xmx:xHnSausCGvoe0YNlzoDHgTvmja0Y1qdR2JAbTtGSvAOhvo_t3rwnJAhJ>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 21710782738; Fri, 16 Oct 2026 15:23:48 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AfI0eCoY7JIB
Date: Fri, 16 Oct 2026 15:23:27 -0400
From: "Chuck Lever" <cel@kernel.org>
To: "Mike Snitzer" <snitzer@kernel.org>
Cc: "Jeff Layton" <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
 NeilBrown <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>,
 "Christoph Hellwig" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>,
 "Matthew Wilcox" <willy@infradead.org>, linux-mm@kvack.org
Message-Id: <f60b0363-c4d5-4539-990c-1c6c7967f8f0@slotpi15m67>
In-Reply-To: <20261015233309.42999-1-snitzer@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
Subject: Re: [PATCH v4 0/10] NFSD: keep direct-mode I/O out of the page cache
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0B33640002
X-Stat-Signature: sht1dpfhcem75bop6u3oinsnxyyenkg8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792178629-877394
X-HE-Meta: U2FsdGVkX18YZEp5zya5Y0xGWi6+EOqyjDOP8Kc9b3kRs823Z98wgjVWCIaPEcjscD0nImIq1LrqI5Ej25tkhl4IAlth7/mLlqQk6IOKrBDEzpF2neKu1wO4fY+L/3vSJzj/udZ/11vm6+RZoL+FzMjvtZ613SOS0n7+TcM+v7lEZUM0J42LoAVAe4OYueTPiVs4gt70YXsYHCqgf0KPmcPDApYI/koKW4CiAI0XQFvIvQ0vsm50vMzdcD9NIjVjuLsm2B31BoAfctnc4RrnKfFGNoD6vao7j3+eqOJ/RV4tteKPOT6bFmBl+SKIm3hTOsOZEW0B13m9SE7B7aagvvCwu87wCHaxCmXKoJNRJwQmvl/kyoljYoLhwYNhqyFrDC8DZxK34kvi25pQjueky70L+ymbccXwnLu6GW1wwjUWHVX3o8iZ9q9grVr2XxtqYwcr9qDDZId1wsrrpXZSRFBhD0snLPrFSr71zWlU0ghWf6fy1szez2/EzBg44PIxXQQcI/KZlXSWjPE3qOtWKZX/miyJk68C7Xr0wQ3eceOqElnIx/zywlyYWfLOjK23+6J/6cpo1VAxG20/XY9R8hQSyvl0F1jr2iR/b1eorSvLZ8pO5TO9N0jWMQP0GT1yGUgCY7adjiM5XxmWd7QrU/Fo02ZtQUDqVwQ5w8V8Wm8QbnXvVIzxi79uqPXSsIch9uS6+ATVL8YpvnkdqsTUDOs/BcocofZW3+safmTo2qZv6/xj1Xi9rYrzVkYW9XnX83A+HNsTwbSaRv44xhzLZKUxkvl1Wyh4J/o3RXRA+yM8SHADre8B5Vdne4zzJ2Et1ceIVYHnfpE+m+PZDbXzA4xQPQy02TtU65AWwjUB2taK8HK4qUK4vqtosVB/wTSRhQqFYyr+BoUuEiPiVB1YLb4wruzq4fLuDyD2dezdIuIjOY+0xJohgEDV4Hydq01BFugKC1fe3hXrPvKwSd3
 ZavA1Vet
 7M5sEjByr6qOFqP797OKC5VcWEH3+lzoHSjSltO0t6cVD2anaYcTK2XTkn/ktG4N7vBCfdsEKyY6ixH/jEmNwC9XbKUuZ7q4VI59rcTlqKBXl6kODFijWT5QPPQQhWoREXAyb0WUm6xUFcg81bmxVX1lzX4cXXUj6blwiNOewoQNjl41HnEtpJI5DwrWXEo4KSiKGYGHITY1NlJeGTZoV/WljSL5K/hC4Gxen+speO+eJ3SM0TganfmJTEmIlaG+5yhc38CLbHAStjsPsRbxCwylGFGhRATSB34qDvUsigp/1mqxWSZtZseWnfjeP5dqavj+Ot8sbWLrcgxFioPz+87Mn41jF8hWMsjem3al6NT33AQk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 19:32:59 -0400, Mike Snitzer wrote:
> 9/10 calls folio_mark_dropbehind() to keep the page two misaligned
> WRITEs share until both have written it, with no state in NFSD: 704
> device reads for 42895 WRITEs where there were 45144 for 45664
> (47008-byte records, 32 interleaved writers, 4 KiB pages), and on a
> four-server pNFS flexfiles rig 0.003 device reads per record instead of
> 0.014-0.015, about 2.9 GiB of page-cache growth instead of 11 GiB, and
> 2.4% to 4.9% more write throughput.

The direct-mode WRITE path started as one decision: aligned, go
direct; otherwise split and go buffered for the ends. This series
adds a page-boundary cut rule that depends on the relation between
offset_align and PAGE_SIZE, a minimum middle size, a knob for
whether the ends are DONTCACHE, a floor on READ size, a rule for
when the sync is issued, and then the shared-page pairing in 9/10.
Each is small and each has a measurement behind it. Taken together
they make it hard to say, for a given WRITE, what I/O NFSD will
issue and what the page cache will look like afterward, and that is
the property we need to hold onto when a corruption or a performance
report comes in. I'm not yet convinced that 1/10 through 6/10 buy
enough to give that up.

9/10 gives NFSD a semantic that DONTCACHE does not have: drop this
page after the second writer, not the first. It builds that out of
page-cache presence, with an unmarked folio standing in for "a
partner is coming" and -EEXIST standing in for "the partner has
been here".

Neither layer actually knows either of those things with certainty.
mm cannot know another WRITE is on its way, and NFSD can only guess:
a page left by a READ, by readahead, or by an earlier claim whose
partner never arrived makes the first writer look like the second,
and the description already lists the cases where a claimed page
stays cached until reclaim because nobody comes to complete it.

The 6000-byte numbers in 9/10 show the shared page is not a splitting
problem. Those records are never split, and they still cost a read
per record when the ends are DONTCACHE, because DONTCACHE drops the
page after the first writer's writeback. So the choice is really
between two things we already have: issue the ends and unsplit
WRITEs DONTCACHE and pay a read-modify-write per boundary, or issue
them as ordinary buffered I/O and let reclaim take the pages.

If ordinary buffered ends turn out to cost throughput with flexfiles
(or any NFSv3 I/O) other than just occupying memory, that is a
reclaim or DONTCACHE result worth bringing to linux-mm on its own,
and the right fix would be a DONTCACHE semantic that mm is willing
to define, not special state in NFSD.

Consider splitting this into two series (which I already proposed
for merge process-related reasons). 1-6 need careful scrutiny to
understand the trade-offs between scalability gains and
predictability. 7-9 need to be explored as an issue with DONTCACHE
that should be resolved below NFSD, not within it.

I'll study 1-6 more.


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

