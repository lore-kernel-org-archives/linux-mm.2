Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41BBDE9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 21:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1796B0088; Wed, 18 Feb 2026 16:04:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C996B0089; Wed, 18 Feb 2026 16:04:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4466B008A; Wed, 18 Feb 2026 16:04:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA5006B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:04:28 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 859A51602A0
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:04:28 +0000 (UTC)
X-FDA: 84458805816.14.F2F61A2
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf20.hostedemail.com (Postfix) with ESMTP id 67AF61C0018
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:04:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b="Bh/39XMQ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=plf5A42Q;
	spf=pass (imf20.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.149 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771448666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79/kJXt6NEqGLpu83/22II9pOyL9CJZBDcnxuiTjByE=;
	b=3QOc22VZsSEqcIBYbqiIaHjc0IFZf2noxtqaI2xgWO5F0fvzbws/fSOyPHBApasZJWhFHM
	diRnmD0DmYCw3EbkIMRi9OIougblPN3vrV7XWcuLOKNQ9fk9NJbELc0YS/i2fp2826eXCr
	pZU4N5Xvlj/bJQ1eoeGOt2Jv3Z0X4mw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b="Bh/39XMQ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=plf5A42Q;
	spf=pass (imf20.hostedemail.com: domain of andres@anarazel.de designates 202.12.124.149 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771448666; a=rsa-sha256;
	cv=none;
	b=AQWGdf+G5jTvN0buPZT5Nh3BMnJ6sMxOMYXPcjZG3PxCE6XCJ3SfErPDHZjptgFhD4ALjw
	SsrtQjgXMVfF+I9LfakVehHftZyoPOxNmae8KgeOu73/kAlKVAy+JwxjhrkhftkPGLixps
	LVKr4nK4wD/14c/d5N6lU3xYdtkwTxA=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.stl.internal (Postfix) with ESMTP id A844D1D0009F;
	Wed, 18 Feb 2026 16:04:24 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Wed, 18 Feb 2026 16:04:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1771448664; x=1771535064; bh=79/kJXt6NE
	qGLpu83/22II9pOyL9CJZBDcnxuiTjByE=; b=Bh/39XMQnn30o0s4flayPigsyj
	iLSxJdJxnt6/OODgLrfYAwvsthfWVN2ZOXNvgyDVSojr+mdYCSWiPNqvusO/gdzo
	mZi8PK7rtcRUiwDiFNO1/EE7Hc1H3RlYEOA2qwNlAtI3Us3/Tx7IPSrZWEeqoe2Q
	J4IxytiWUqW12hyDSwUbqYMPUkiRblqQN8oXKHA9RTSDi70NMyWSjTzoset4usrl
	kqlSMlrC762jp16JSib047e0xN2pnHd74QyGofVXuYIemOrKRQYxJYCjsnBS3woR
	6g0nIwHjv6W4dqfWOydiby7HNp0VPFLdHXAf+X1JuT7OoILI/YVsYNBGhH7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1771448664; x=1771535064; bh=79/kJXt6NEqGLpu83/22II9pOyL9CJZBDcn
	xuiTjByE=; b=plf5A42Q+m2vLEDVo+GEDFNfNo6E6+Kl88RUWt1TW+yNjqFpFhq
	gVKwHjP7+u7UT3QocF0auccylkpWDVBRxsNPXuDR21sEz9ZPXKytOzZjxM0cTD94
	P80ZRl6lXdMy3qopRIBEg23FwwugIBxc76xaIdbfx1dV2Vvby0htIK4Le5QpoKse
	+O3bPhTOiP/oJLjoEjRV2cTNNbTU1tetxgoO/DVoezX/0cAMbvM+DU+/h6kvUT3r
	hvtrc9GYtNws2N1rUfjnNztclxf8UiUrJZyehzPiHzTLiKObVRgSBTAhp9AJOTxo
	D3An0tniQvkFjfNwc/23grTv1DcMEqWsnkA==
X-ME-Sender: <xms:VymWaSrIzlXjCsnAYGCr6xdql40_0LTWNqWB6zX29PQhU9nFGKQqug>
    <xme:VymWaXlTfFj0KZGeV51jL5MXBHrcX8spy7EBb9yo8qxBYpV2BmfCUjJ4uwnnza98G
    cnR6iMmXjjsb6iy6Vy4QrJz5V8WHncpvO2h4UTPQaO_tttzrXgJJYU>
X-ME-Received: <xmr:VymWacSSafM0PsnWDUm7AgS2Msq20DMBattPcZ0xsxwdl4ZQo7y-FymK3Cmi_dTfK8xDvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdefieejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepfeffgfelvdffgedtveelgfdtgefghfdvkefggeetieevjeekteduleevjefh
    ueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hnughrvghssegrnhgrrhgriigvlhdruggvpdhnsggprhgtphhtthhopeduledpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtoheprhhithgvshhhrdhlihhsthesghhmrghilhdrtg
    homhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthht
    ohepughjfihonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmtghgrhhofheskh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
    pdhrtghpthhtohepphgrnhhkrghjrdhrrghghhgrvheslhhinhhugidruggvvhdprhgtph
    htthhopehojhgrshifihhnsehlihhnuhigrdhisghmrdgtohhmpdhrtghpthhtoheplhhs
    fhdqphgtsehlihhsthhsrdhlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtph
    htthhopehhtghhsehlshhtrdguvg
X-ME-Proxy: <xmx:VymWaZDNNedCP64l0E46dD9lLg36JpqYO1KPIWLHsYjbPIdv7y8wBg>
    <xmx:VymWacratkOjQM04gQdZl7bQRkeBFvXaU9-a_pdTCR0cXQhb_NnDQQ>
    <xmx:VymWaXh7dngNuF9kHXhZqnN1wxk8YQCeueKRXygZR8STS22FLxsaCw>
    <xmx:VymWaZyqTNM_2DYBW_uaObIxNOusgXnfMG2JPmTodyw7HkpAbGlJvg>
    <xmx:WCmWabh5bbTPfYVpP0IyJzPD9TpaBT-GGaehkCixY6X7M7HwcpitLldk>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Feb 2026 16:04:23 -0500 (EST)
Date: Wed, 18 Feb 2026 16:04:22 -0500
From: Andres Freund <andres@anarazel.de>
To: Jan Kara <jack@suse.cz>
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, djwong@kernel.org, 
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, ritesh.list@gmail.com, 
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, 
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <vr6xl5ntbgh3ou6uahu425xknlseclqj5aweb2ntvyedrgree6@uwbqiqamzec6>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
 <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v>
 <2planlrvjqicgpparsdhxipfdoawtzq3tedql72hoff4pdet6t@btxbx6cpoyc6>
 <umq2nlgxqp4xbrp23zjiajwd6ombed4dfwbajuh35xd4vphyee@26g2y6a4rdnu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <umq2nlgxqp4xbrp23zjiajwd6ombed4dfwbajuh35xd4vphyee@26g2y6a4rdnu>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 67AF61C0018
X-Stat-Signature: 3wdihokf6nxd8ihht1qpdiqjmmc8gsqn
X-HE-Tag: 1771448666-986219
X-HE-Meta: U2FsdGVkX1/8eOEVEhQbmvONwpRV9lmOM+pqBrnFqCegQHq0QbrEyl15KKtxiKvMp38iP6+ep6o1F8GvkD4RcPiylui4Xm1r3KFxE8Ku6MYm5RS+CgUgT6lIWgJH0nUPVvxoCD8t+UN3xPzz3j0/cr8F5lxNqVO2PF1zFEHVMzNtKNaQ9az2ZslGdfJWkVjs6lYs/TRGDv9+7rkmfHfbJ3vl/3ZwqabuGcFf7LUpYWe9enFogXSm3lwRSqzCXWNRUOtLJkCYa/UGoqsAUYStBaHkVx0wZRzNVpjRMB4PgDsDT+1isbYPL+4hcmfklRs6CJD4mScDordkX0f42Dh+Gyx+ycKLRr5v0nRNCxdU/RiPMjNJ9T8EE7/d67U4rYYr4RDNcPkf3UvT0N5Df45+CCrloUPGu6wBs+aA5CG4gWTPaNbsjlsUc2h5jenQgn4J85AMURkvKOYMeCHRqYr3TrJWzWXUq1mv2WIDLmGfT0s94uDU7FpR6Y8EbhGhXgAc+/L5DYvcCLW+2pfycn7mFchmOLMshdFXe5g0bNuq2MwpPsdGEed2NcYkQXOa4Rjx+jrrfQsKxc6v1J1z/CzmCZT/yd23wn3WkOK82fx3pXv5WWa8CL7SRSGzeQkKPXkYpOv3MOvqh3KH1ogC0WV18/fslVvJJ3DJoaLYVWNSbmS7P/9wEIOskUCEEX/7TG1YSmW3mDq+NxOkJX/mSAYg4l8LEId4wTMoWIQwt+kZXJfeTBG5p06/FEmVZMeRc2QO9hNWTFuxzFDzpC3hbEObjY7YDM5QghpeakxutPwKkjZv8m871tkvbyKmIoqoVwd5uVuN3xWcTfQYp2C6PX3C/apcur3Nw6kfd8aSvvdZhpQjGVtEEIrXlVvfITe0UcvNdQ2LcPfOgTWhqGC2R/zFaAjL5i+sqmlxvU4Pj9G6TMtWISlh9FPih+VLA1Pxod9hIkD3kP3I5zQj3TdiBgJ
 mR0v2w8t
 H2NdXrjO1LLepUzH258/FDhDg+6cRKQpIlj/g2LiPhCUCuG+BHrLhi1JmIGPzPJ2C79sbJNwYWi2Ro1kbdsngDyYqxQ+LK0fcltkgaZ7iuyBCERyzF6Aee+vyDlU+MpgK2vvYV1HVOLZOkjAyMPHBiq3C7d8ooMTUCqOjB+OnXBJu04hOiFpwNv7crS93RWLBdOzfKeti/DPnVz3fFasy92Jk/t6FPvr2tu9XTWyybpR6DEOx01JNcT0i1YSfbUOi40Qb0Sg//SUCR2MlPafLyg3FgmOfoJFpf2s7ubczmuRKsmqCYN42osWNRHhqpAIO6SPV5kvftibNcyITmfzPufItVbQIfgoqXThwS4TH3bw+dv6elZm5GiyrENwzokNZ51pU+dNgrs1FEpCUT3DLnG0fAgH1dbTXp9NQyN0pDLsT/x03G2+j37BdFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-02-18 18:37:45 +0100, Jan Kara wrote:
> On Tue 17-02-26 11:13:07, Andres Freund wrote:
> > Hm. It's somewhat painful to not know when we can write in what mode again -
> > with DIO that's not an issue. I guess we could use
> > sync_file_range(SYNC_FILE_RANGE_WAIT_BEFORE) if we really needed to know?
> > Although the semantics of the SFR flags aren't particularly clear, so maybe
> > not?
> 
> If you used RWF_WRITETHROUGH for your writes (so you are sure IO has
> already started) then sync_file_range(SYNC_FILE_RANGE_WAIT_BEFORE) would
> indeed be a safe way of waiting for that IO to complete (or just wait for
> the write(2) syscall itself to complete if we make RWF_WRITETHROUGH wait
> for IO completion as Dave suggests - but I guess writes may happen from
> multiple threads so that may be not very convenient and sync_file_range(2)
> might be actually easier).

For us a synchronously blocking RWF_WRITETHROUGH would actually be easier, I
think.

The issue with writes from multiple threads actually goes the other way for us
- without knowing when the IO actually completes, our buffer pool's state
cannot reflect whether there is ongoing IO for a buffer or not. So we would
always have to do sync_file_range(SYNC_FILE_RANGE_WAIT_BEFORE) before doing
further IO.

Not knowing how many writes are actually outstanding also makes it harder for
us to avoid overwhelming the storage (triggering e.g. poor commit latency).

Greetings,

Andres Freund

