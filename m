Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A5B7EA852A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 15:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215896B0005; Sun,  8 Mar 2026 11:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C3926B0089; Sun,  8 Mar 2026 11:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A9C6B008A; Sun,  8 Mar 2026 11:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EAA4A6B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 11:33:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EBA91B906D
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 15:33:17 +0000 (UTC)
X-FDA: 84523289634.09.0D191A2
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf09.hostedemail.com (Postfix) with ESMTP id 50E33140010
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 15:33:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm1 header.b=M8oMLKHe;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="r NdLk/p";
	spf=pass (imf09.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772983995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j67XtJ9OGsdlKsg8v+Rh/M0QEDVD7WMs+occTWtaidE=;
	b=CMjUgQAscnmFzG/ANRfs1Yr8tFL4BubbQ9ELzhcvtCgpKbl7WXWe9A/70gorLBNm2/S/CR
	hkxBPGLswIvuQPqOrywB5co4qI6NONTy6brLFwqd+UREYWrxr/yuTdFj4toNh5PsaWLjyU
	Yf4A5WpGBgga60yi9G6lAxzn4z7I7qY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm1 header.b=M8oMLKHe;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="r NdLk/p";
	spf=pass (imf09.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772983995; a=rsa-sha256;
	cv=none;
	b=8EOV0FCr2EAgOI8+E0dLqefgOIBPIbDXM7kySG3xthJjrFPHvVHApnAIeExUjkSNn+BKwE
	NjBNMWGjQWYGDWl+jVeWx0zRY6TYz03eZb7Y02iiy+E3E0YNGi9kiUrQ0vdGivTPfN2uWT
	yqHtUDd1bKgKUnjRI8MoEJM5kzNwvBY=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id 93A821D0000E;
	Sun,  8 Mar 2026 11:33:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Sun, 08 Mar 2026 11:33:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1772983993;
	 x=1773070393; bh=j67XtJ9OGsdlKsg8v+Rh/M0QEDVD7WMs+occTWtaidE=; b=
	M8oMLKHeJC1qqUKI5wl4oHJh7TlqciEYhO6kYd7RzJ2jC4XoEhFuubaAPWAGuit+
	3JE3EKayzXDkDwXkVn3Fcmfb7D7Gd2fd+ztdjiYLLvTFscp4rAOmHZWaCo8T/hfr
	VJ06mIg0Y1VsBea+wPPBr9aj7Qv2+J2ybCeeT/ssvq7J9iPRtHP+a7TScPE4WUzu
	/HyffTZTwKpCuFxA3cOnWZQJOrYdr2nnAFcuI75M8pb1Pccn1voqqxaCi/et3QK7
	f8N4bbfjThQn7VPdu/JPn5XWY49A6iYaV25sb66F807jxUOegh2qWk/9Ho9yEjvw
	8aG+NibXye1ZKyYbfZV1uw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772983993; x=
	1773070393; bh=j67XtJ9OGsdlKsg8v+Rh/M0QEDVD7WMs+occTWtaidE=; b=r
	NdLk/p32TQDKOBkrSnPA2MnysyMVa1WS+6lXiU81IfyWLSXZ4m9MXaKyWwxOnZsh
	X6GSMd6Xw53CYtt5hUKoNi23Ldd/c7y9VEJ8SE7KVWRe/IL/cr0b25pZYndIlZIB
	gwi5DouetHBxepC9B+1HcM482KeTOXJWVxcWR+SveGzv7c8X3ZjsKn40LUihfA43
	T4tJ8FU4zmnQhAinCgLgUzZdQVLNo+fBieTrnZjcXgEY9sSTpwJvKHi8BPgnSzY5
	Kg9L+AxNIOqYxoA5sjOdVeOy3hBy7NfUg7Y9Iybw4UXRx42sfAaDyRVBrHJVVO3+
	DnT48ti0Pvq1lrRM/3s4w==
X-ME-Sender: <xms:t5ataVwCm1DrshxsYPYAjikWwiata3XhjybKXJVu9wRn8VF4pWedGw>
    <xme:t5ataRL48WYmaazofgmpoG9726ua1f2FnGRLyRl3X2r44PM6sT0Ve8CP0SRCI8PrH
    rGsE4wH2SluW0f_2AU8zhTgOeKKFW2Er6UQL2VfBzffOSDdyWtBag>
X-ME-Received: <xmr:t5ataa2yko-EbDXivTKMVyzLWK43LK26FoGPv6CJraasA3aXJR4fBsPMXTCiAL68ncoEVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvjeehheehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkefstddttdejnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedtleelvdfgjedvffeiueekfeeuleffhfegfffhgfffkeevueehieehhfei
    gffhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grnhgurhgvshesrghnrghrrgiivghlrdguvgdpnhgspghrtghpthhtohepvddtpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomh
    dprhgtphhtthhopehrihhtvghshhdrlhhishhtsehgmhgrihhlrdgtohhmpdhrtghpthht
    ohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopegujhifohhngh
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmhgtghhrohhfsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhope
    hprghnkhgrjhdrrhgrghhhrghvsehlihhnuhigrdguvghvpdhrtghpthhtohepohhjrghs
    fihinheslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehlshhfqdhptgeslhhish
    htshdrlhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhg
X-ME-Proxy: <xmx:t5atabdr7P5wMdbGIgFdb3ItIOC2ChWHV7AMfKIRxqK1W48aO0FLSQ>
    <xmx:t5atae7_j236xrkK0fKiAb7qogWk8a7ApPSSz1SSbBwZmBaL5IoZAQ>
    <xmx:t5atae9iAxo7ei6UuV1V5whjymcmGSwjfJspj-VputDXUjfJik0psA>
    <xmx:t5ataVL7cZ6ttfoZ9QCbSAFcajRLT-wbNEyIjafmvuPb5m9qassYdA>
    <xmx:uZataaeyBP_MPNczw099JYvNBOlN3bTUpmojFbk_LjJMiR9yZYqA1_33>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 8 Mar 2026 11:33:11 -0400 (EDT)
Date: Sun, 8 Mar 2026 11:33:10 -0400
From: Andres Freund <andres@anarazel.de>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>, 
	Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, djwong@kernel.org, 
	john.g.garry@oracle.com, willy@infradead.org, jack@suse.cz, ojaswin@linux.ibm.com, 
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, 
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <pyyeaqzjdpgkpjfyxkrlzawwwj6elzvidubtq73toufr7wgoec@prv4u3o5ixjy>
References: <v7f6u19i.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <v7f6u19i.ritesh.list@gmail.com>
X-Stat-Signature: r11omqdzroap18xc9ef9sgwe7q3wdhse
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 50E33140010
X-HE-Tag: 1772983995-207520
X-HE-Meta: U2FsdGVkX1+oGdiRRU0U1tI6FuG9Vlmhsa/VfWuM9/83GLvTRELcgmRmK5AiDKTKkuaq97k1uKuoQ+fSz3o9YPcTJaLLIC5dTilaaTVn/uZNinc1Q0EG3Vn4PwKkIyLpMx6Ci1AaFXD8bEkKlbsIoxHpOdT8eo6c8MNsiy/Sn8RsOmniRgwXn3VTbZT3SuQt/JA579kRO1eMakzzb9w3BMaG7+2tzhs97S1n4mo3HIw+qDMuif0tjMnAbLkx2r3qZ1viVOk3OOprdbmRlG92vhGq+u7gNmvfxQmBZ7uMNq3Ar3ClNXJowKivAmJS6Twf7DJn1VF1i3C4Vu0jAGU+gru0Rt5npUUim/ab1xFEfMqxKVfbAtckjbWsbteOiuHD1yQjQ/PJJ3THYkXFLPkDhFJyd3AdZiHSR4R4gG5gRSrMVd2TOt/PVrz44+nFD0HfB1YyaiVz7GZ+2ooTd4QjEE4t9VTKN9hPNp+yQTpBu9AXQ8vIJ0Fi7AicosY7iTDuznV4x52we9sJz1g/tFrnRAYryLQ1V4KAw7CBI1WOqQbwKk2KSms9Ss8pUOeh7y3/J4GPlknUpB3eAgdVXT6qNfn23cfYMOltdPre0WVQK0YTtxNJkmIyGwgC/jIsv5Fc2L5ZPjXBa3jGek2jN7H6uaynb74g/WUmQQ1z5kXi8et0iLKS8YrQOkmtlpO4G5CCxzn8N6rrvc3ahmz0RJzUI4Bltr1XmV9YLhra+LSY28Qnl49s9ABFiLQGeWS1d8CNEsm5oDC8+RBq6JiSXf5J1UVqp1hfA2Kh4cR9Ugu01t5RRmqbRnlYU2ovkalOoxqDLhUSHBy4wPiHATFIoBXCDXFedWx/IEXPDJD9mik0AhqBn4IBA/iOkwvaxkOOdqrk8CBfIKBqFs7MEF0UvqCpKKUO3v7tLXQf+U0ts0L4q7Yp5wloABkJOj/ztmTMeSq0I5vDyyham9pMZo+2TuT
 itVXxoQ0
 tsQE1vnXSmZxYRSQh0YinCaRflYH3M58yDnMk8idDeYlb3jyP4Wo7iBxjbcSR83Q81cP6uUVAW1bcJEvHn/wYBhDFQGF3MV2iQwcFrZBW9ivZszUIw+b+CzADNFa7ne6f6Fu3AsgMt74Ixl4WUsUjnr5rU1PIFigTm/zXQTC7Iv7E1h9ZTQWLhTx0Hc5a3Gx7B1fj8Y8+hH6rMJhjIkcHjuT9gaFTA1UXXRcCq9TB5Vjgb2wJ+acydYX5sH0cIVTEWSzEDEiTCjMH0EZpuv+UJMFpzE2GHOKXVUdYYCSgQxzwRcjJU6O1d8Mm2C0tubb4KAPafgkJ1w3GXcowGTOUe5B12oj04/RapmZwmdFpKVDJvR86QTnZLScEMj/kmiI/ilb7gA7Di5VNHWUTNEeiFJbd6j8Unj1Vqg2kMWQVoyvL40jR1mI1OmqoTJFUG54a37FliLjjfy3uwGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-03-08 14:49:21 +0530, Ritesh Harjani wrote:
> Andres Freund <andres@anarazel.de> writes:
> > On 2026-02-17 10:23:36 +0100, Amir Goldstein wrote:
> >> On Tue, Feb 17, 2026 at 8:00 AM Christoph Hellwig <hch@lst.de> wrote:
> >> >
> >> > I think a better session would be how we can help postgres to move
> >> > off buffered I/O instead of adding more special cases for them.
> >
> > FWIW, we are adding support for DIO (it's been added, but performance isn't
> > competitive for most workloads in the released versions yet, work to address
> > those issues is in progress).
> >
>
> Is postgres also planning to evaluate the performance gains by using DIO
> atomic writes available in upstream linux kernel? What would be
> interesting to see is the relative %delta with DIO atomic-writes v/s
> DIO non atomic writes.

For some limited workloads that comparison is possible today with minimal work
(albeit with some safety compromises, due to postgres not yet verifying that
the atomic boundaries are correct, but it's good enough for experiments), as
you can just disable the torn-page avoidance with a configuration parameter.


The gains from not needing full page writes (postgres' mechanism to protect
against torn pages) can be rather significant, as full page writes have
substantial overhead due to the higher journalling volume. The worst part of
the cost is that the cost decreases between checkpoints (because we don't need
to repeatedly log a full page images for the same page), just to then increase
again when the next checkpoint starts.  It's not uncommon that in the phase
just after the start of a checkpoint, WAL is over 90% of full page writes
(when not having full page write compression enabled), while later the same
workload only has a very small percentage of the overhead.  The biggest gain
from atomic writes will be the more even performance (important for real world
users), rather than the absolute increase in throughput.


Normal gains during the full page intensive phase are probably on the order of
20-35% for workload with many small transactions, bigger for workloads with
larger transactions. But if the increase in WAL volume pushes you above the
disk write throughput, the gains can be almost arbitrarily larger. E.g. on a
cloud disk with 100MB/s of write bandwidth, the difference between WAL
throughput of 50MB/s without full page writes and the same workload with full
page images generating ~300MB/s of WAL will obviously mean that you'll get
about < 1/3 of the transaction throughput while also not having any spare IO
capacity for anything other than WAL writes.


The reason I say limited workloads above is that upstream postgres does not
yet do smart enough write combining with DIO for data writes, I'd expect that
to be addressed later this year (but it's community open source, as you
presumably know from experience, that's not always easy to predict /
control). If the workload has a large fraction of data writes, the overhead of
that makes the DIO numbers too unrealistic.


Unfortunately all this means that the gains from atomic writes, be it for
buffered or direct IO, will very very heavily depend on the chosen workload
and by tweaking the workload / hardware you can inflate the gains to an almost
arbitrarily large degree.


This is also about more than throughput / latency, as the volume of WAL also
impacts the cost of retaining the WAL - often that's done for a while to allow
point-in-time-recovery (i.e. recovering an older base backup up to a precise
point in time, to recover from application bugs or operator errors).


Greetings,

Andres Freund

