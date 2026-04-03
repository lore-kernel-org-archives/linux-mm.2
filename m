Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6B94E88D67
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 21:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28C16B0005; Fri,  3 Apr 2026 17:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED9676B0088; Fri,  3 Apr 2026 17:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC80C6B008A; Fri,  3 Apr 2026 17:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC85F6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:24:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C614586C8
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:24:15 +0000 (UTC)
X-FDA: 84618522870.07.F587108
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf19.hostedemail.com (Postfix) with ESMTP id 799811A000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:24:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=invisiblethingslab.com header.s=fm1 header.b=aAt3L47A;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=kXAxLxft;
	spf=pass (imf19.hostedemail.com: domain of marmarek@invisiblethingslab.com designates 202.12.124.154 as permitted sender) smtp.mailfrom=marmarek@invisiblethingslab.com;
	dmarc=pass (policy=none) header.from=invisiblethingslab.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775251453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJDhh1aYQ1l4wE/5x0P8ZIQHMCjj0qGX6ZaMgUpSYDs=;
	b=q5fK6pFUaAcWBvtR1S/+9sGu/SCpir7AZXQP8sCOsrcRUuFNGUi5tYev0uxcSaXeWFFE9R
	Ng8OFUUMaVFTeMjiSIgyA1Gjfk6xVfn1SqNfMo4fvYDs5Pb/g1ZTMmcnitnoguKLOPBDfk
	+kvYm0dr9+JYtl++dhWvRO1+nkIyVNI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775251453; a=rsa-sha256;
	cv=none;
	b=7yIWIbz+euB74sSAneINBkNQgnqJRGyrvuKkNO5VC/Af92BC0GVJUL5iGOzquH/N2ZknsZ
	Er8FEjbA7AeBJdInZCmqu/cK4jUwi218y7SqqwpMDlzW4f+rJzDKkOAfv8906OY+KPZjtb
	JnEgBiH4YHuXJOfgHmTultRA6DpbSxs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=invisiblethingslab.com header.s=fm1 header.b=aAt3L47A;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=kXAxLxft;
	spf=pass (imf19.hostedemail.com: domain of marmarek@invisiblethingslab.com designates 202.12.124.154 as permitted sender) smtp.mailfrom=marmarek@invisiblethingslab.com;
	dmarc=pass (policy=none) header.from=invisiblethingslab.com
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3151F7A01CB;
	Fri,  3 Apr 2026 17:24:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 03 Apr 2026 17:24:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1775251451;
	 x=1775337851; bh=wJDhh1aYQ1l4wE/5x0P8ZIQHMCjj0qGX6ZaMgUpSYDs=; b=
	aAt3L47A9yhTQN+76uDqU6NmR6i1x68uMDpeEEV2ENc92vb/nKT/P50ht5Rh7yNH
	zlrAdkk0T9LEJUl2LGaiShm6nrWTQ63f/clxqaXyuUcpcDlT5jSyhvzwX0wJMOwF
	rChvsk0D5T+utpa8GcCE8TKjJ0i4qk9Fl+7jDnjIfM64oQN2MwSD1A/AgYy2DPYN
	qOsh/clXlm1OTfS58WOpqOqCyuckuTmtwrZSCuuc5DWvgAjX2uL2t+K+Wjgh9W3o
	uAstcaF5f0WuACIFuBBRkbiuqe1pbfGqB4NMox9L6llq8Fk6iAuBfohxPQATImp2
	77GrkYqP8XoJ9mibPRegAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775251451; x=1775337851; bh=wJDhh1aYQ1l4wE/5x0P8ZIQHMCjj0qGX6Za
	MgUpSYDs=; b=kXAxLxfti1IaQGTj5DE1eTHOVU3fz2e6HtUfswfA34t2NmT3GYy
	T0ANeA6MPaa7PwVpoMzWJ56wliT+IA004jOEyDytWbpJT3Asvk+ziuyuQy348QBJ
	UC3wzuSvg7PGMPWJPSgScb2oKO170l40zL7u5pPCZONCbWYfAiZlXB3c6t8BApIQ
	wPzPnwVlWFKBeNGVPgtLtHQlBykAbU7xbio1Cpu5FXOXnjrZgv4VY7FgOo6ToIaN
	FDfCTJb+MjFUkXXDKltkUPo21EhsCAw5KAV6e4lV+EpfXWCYZIv1pVDLOPrbi+kj
	ic8ZODfHppRaqjhSSnlaw/e68ivExmWTbwg==
X-ME-Sender: <xms:-y_QaRr1XTAQ9LyrLFOTPLlOumIgLtbXY3IN9h-aKuVs7xuuiFzniw>
    <xme:-y_QaUUm3hDRjGEgKKc4_OY_USIx7Ot-s3oZvcSuPSaQEQOAqZe2qSXhZ9aPDXWVL
    43z0grLVYPrs36reD07Zfpl1j3ZPGmgtb7UCaYPc_A0n9rmBA>
X-ME-Received: <xmr:-y_QacYdSSqSmKaieuB8VmUHk4MphOc0deUQEqblCeedqzy4HW2bcMn21A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeforghrvghkucfo
    rghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvhhish
    hisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpefgudelteef
    vefhfeehieetleeihfejhfeludevteetkeevtedtvdegueetfeejudenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrghrmhgrrhgvkhesihhn
    vhhishhisghlvghthhhinhhgshhlrggsrdgtohhmpdhnsggprhgtphhtthhopeejpdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopehtvgguugihrdgrshhtihgvsehvrghtvghs
    rdhtvggthhdprhgtphhtthhopehvrghlsehinhhvihhsihgslhgvthhhihhnghhslhgrsg
    drtghomhdprhgtphhtthhopeguvghmihhosggvnhhouhhrsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepgigvnhdquggvvhgvlheslhhishhtshdrgigvnhhprhhojhgvtghtrdhorh
    hgpdhrtghpthhtohepughrihdquggvvhgvlheslhhishhtshdrfhhrvggvuggvshhkthho
    phdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtph
    htthhopegrrhhirggunhgvsegrrhhirggunhgvrdhsphgrtggv
X-ME-Proxy: <xmx:-y_QaRfxtirIBioAWRbktAN6gJkuRnR1Ev5RQjHr2vJoizemSi6lTg>
    <xmx:-y_QaW2sjTPblbnJqzQf3RHHa_I6V-7ksolTPLy5osm8Q8GnAQdDgg>
    <xmx:-y_QaYJTIUWPC-0nxvANtutqJl3H2VayrOkd-Hz_jzPH6aNL2eLSZw>
    <xmx:-y_QaVEYnKui8E_TxwxLNAFiA4fij7N4ZS6lWjiBy3_wCrh8LoWPeA>
    <xmx:-y_QadRujxaY6YfeywYpy0HDzSrdZ0nAizMKR0kLY1kncJmTVSVzuRq->
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Apr 2026 17:24:09 -0400 (EDT)
Date: Fri, 3 Apr 2026 23:24:07 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Teddy Astie <teddy.astie@vates.tech>
Cc: Val Packett <val@invisiblethingslab.com>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Xen developer discussion <xen-devel@lists.xenproject.org>,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	Ariadne Conill <ariadne@ariadne.space>
Subject: Re: Why memory lending is needed for GPU acceleration
Message-ID: <adAv-HfiyKptEVvq@mail-itl>
References: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com>
 <c38387fe-beef-4f50-b928-74f96b881b7a@gmail.com>
 <0bbf0349-1006-485f-a2db-6c8b795b4242@invisiblethingslab.com>
 <1de15ce0-9f7e-4253-80a7-ecd94caa4325@vates.tech>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4Ae0y7aT9vuqArIi"
Content-Disposition: inline
In-Reply-To: <1de15ce0-9f7e-4253-80a7-ecd94caa4325@vates.tech>
X-Rspamd-Server: rspam12
X-Stat-Signature: axbdbqhhwzpj8cwnntp1i4ftdxwagd17
X-Rspamd-Queue-Id: 799811A000A
X-Rspam-User: 
X-HE-Tag: 1775251453-234416
X-HE-Meta: U2FsdGVkX18rL/8U2wL+SspBhTb8c9DkBurq04GbcXvDmXne7t+JBpd/vt+aGq9sTlQ4SS44MlvnMsxYAqAjkCJ+UH3/ueWJs5914xVJI1GcJk2ZUSDCKs7lmpuBg5bMrdgKg5D9Ee9/n3XV6S4xrovpx5qXoC8uOUajEqG/t3p05ZLlZLvh9ukgXzHWtT27oerIwn+QBm0mrlkTnHJc2//7ar9M0yycNTWMDtLeOTz+iVpVE4b/v3ipM9jImtnzuWhcYGRQrNqDW9lUqCGKwKtPqxFyOvHEE2SFchDlSV3oP9oLf5Y2T76k9Df64u7vRCm5zfzpQdRaC4dt8es0HG8BH4ruKlPFNXixJ3XdA58DNnQ/OgzwmVvF9PtvhIhpRYLw8aqaU75mnOIhUeu2DWsWSyJ8Y/RcYfF8zKj4z+0rel42BrSjCBZnctm0UQmF17An93tAv5N49sgZ56F8L1abS0D3tusveuB9sKOe0HOj/Uv4qv5jwiox2O00Ugv1icnEJgvjrsRD4zhRGQiNl/5LHVgYnI/yLvKaCPdptrd87C22sKXx3pjDzIwhAiFThu7XOjW/8RVIIkUR681X7m+f0s9xMHTGGlSBIBQ7eHiRG6GF0jKUOOdnu7xagBAse6VDD9XymVPtZaySkuK8Sh88L0jnSpnheFMX4F0W6bRBqIkGYNIyu6EQ7I74q7dgPHdS8uncmNjWBMUqxluvh3GPRx+105/w/kMPJZvB6ZL87g4k0RUheKUuoB6ofe+gaKYbEVKFipkXLIC/YHJ61j5KK4rdIkQalrOIZaxxcKlFX6ydozrTwdc+6WofNaAufdSsG4GYGg8dUCmoIFSfoYFvwlpZzSaDlNtYYm11HHrqC05VGkjFWQeuAZiYjd/BW0sMc8R1sTSdYQlEVCmbOZ0yg0vMk4Dq+Dq+3F4NKxx6SCY4aaJAoWnH5bVPt4rAeOB9kvg+drW2441+HYd
 f5n4lSXK
 1fpGcAGUNZKYBn4nHgX32nsK1bRH0WTX7fQbLz3fMjzWwNJrld3QBh1rmBjpQVZz+NjPyHQ9LRamF5o18ykhsG2Q6WhJoGvhQCvOJTxh7ZdxCKF8Gwd43BBSgfPdo7ojlaTlXMZNeiGcc9I5hNTBdJFP2+GZbJSprtuzp4eeY8buneIJgK//bYoXQsLTpd6Jy5ctI1jq1bT4qXLdWn6ENYXc1F5ZbcWM1HTkGCekQdSTY+WPDGXt9a03vhMgqARsE/XnmWWfEV081OzJBWD+Too8xLD8PPwQWrQn+bnuoGxc30A5SrDJyVqVprYjT+2xSaPoHWPGXq9DnxNdLsyatKlh0NQltjUEOWtOeunXSY7S7lhA4+g0YbUsrP4SBaDt+CBwnbd/ZSfM6z3BYvbIhIVpSdrviU0YrbPt4Ol8SMG5lAyplIE+WymljnchpSRshAXRInwnBjkP8vRPmmDTtQaCMMp2W1IEwhx69p7ws2M8hYUiVAVE5pc1kbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--4Ae0y7aT9vuqArIi
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Fri, 3 Apr 2026 23:24:07 +0200
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Teddy Astie <teddy.astie@vates.tech>
Cc: Val Packett <val@invisiblethingslab.com>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Xen developer discussion <xen-devel@lists.xenproject.org>,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	Ariadne Conill <ariadne@ariadne.space>
Subject: Re: Why memory lending is needed for GPU acceleration

On Tue, Mar 31, 2026 at 09:42:22AM +0000, Teddy Astie wrote:
> XEN_GNTDEV_DMABUF has been designed for GPU use-cases, and more
> precisely for paravirtualizing a display. The only issue I would have
> with it is that grants are not scalable for GPU 3D use cases (with
> hundreds of MB to share).

FWIW we do use grants for graphics buffers already - window composition
buffers specifically. We do run xen with extra options for that:
gnttab_max_frames=3D2048 gnttab_max_maptrack_frames=3D4096
And similarly, on domU side:
echo 1073741824 > /sys/module/xen_gntalloc/parameters/limit

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--4Ae0y7aT9vuqArIi
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmnQL/gACgkQ24/THMrX
1yxbGQf+OgsupCAnm7yeXU50i8UAUbaCxLl6LTgomVWE8BqqFLLzbd1uZRBaxgwi
08KM6UwaNDnWYrJjTzzuVajjgvb364NRxaCcDQMU1gg9QaScwe0rvqNXjTCyyZIZ
KcGYITuyNobu6TEOlxjMZCYe09hjh5Tv6YIAjNytG/v4Wj0BeLd6dpU3y/K79rsz
k5Q2KuSQNJBm0DrX1xHtYDI34Ecs8kMi+QNmTxBNirLjkzswlCpewSvOONNsy8Ff
8k+hGeZuhbRQMidzb/toBQpk5p82359YvtUwGWz6rn/YnryTk6+3x3Vr1octMvgz
5SPKxfVNDvikjgpYpZpWowiX1sDLHw==
=Aya7
-----END PGP SIGNATURE-----

--4Ae0y7aT9vuqArIi--

