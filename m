Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D2B3E9A031
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D03F6B0088; Tue, 17 Feb 2026 13:42:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E186B0089; Tue, 17 Feb 2026 13:42:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756046B008A; Tue, 17 Feb 2026 13:42:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB866B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:42:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C674D14029F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:42:45 +0000 (UTC)
X-FDA: 84454819890.11.81E322B
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	by imf14.hostedemail.com (Postfix) with ESMTP id B7BD2100005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:42:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b=suxc0XKu;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=s9Uqrm69;
	spf=pass (imf14.hostedemail.com: domain of andres@anarazel.de designates 103.168.172.147 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771353763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tim9+xAAp38GkPqFll5dGAwqa6OafgbrbBgQCgOaUR4=;
	b=tnWYvjJVJRZvJKAyVEGgkumlaLzxJpHyeb8xMeO2g9GKZmFwf1AQmIIkMtPTzNKOXzBkY7
	dG/JYhoQ4XQJ5TcZ7ZLrU3UeVMvcfyqg13PVxBhaIqkOVuUX7o6Dt0cWD6710VQ4GjC66s
	JeCimolyYpOiY9iLXZq4VzwDHlPwLH4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm3 header.b=suxc0XKu;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=s9Uqrm69;
	spf=pass (imf14.hostedemail.com: domain of andres@anarazel.de designates 103.168.172.147 as permitted sender) smtp.mailfrom=andres@anarazel.de;
	dmarc=pass (policy=none) header.from=anarazel.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771353763; a=rsa-sha256;
	cv=none;
	b=8n9HF4th9aVdJ2bAkn6e2otMeHAi8/vGhlolI/W5SC6ivXVV27ohRPN3M2FCM2uaLNs5As
	B2hAFiknSK7DitLp0AXAjPBLfpJx6MGyDFr7kW9xmsiMxf1QxljIEpqVHcpUNz+sHSgtNA
	cSTCoaP43P0sYd06Ns5H/hAuvpV7/c4=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id 15F84EC0321;
	Tue, 17 Feb 2026 13:42:43 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Tue, 17 Feb 2026 13:42:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1771353763; x=1771440163; bh=Tim9+xAAp3
	8GkPqFll5dGAwqa6OafgbrbBgQCgOaUR4=; b=suxc0XKuCX70QWE+Btruduu0mw
	sdm0uZN2FdjPKboJId6Lten3F3JJ9YZjIA7+dRWm4X/BZwEAmSJha0+RbYngVYkU
	tD62n2wzXjLTvVMLb+vovFtoBVYpNfI7jNEnjstEczIf9DrKYFuP6d9pLb12D17Z
	+SLzKQy+61uJNwjJw9mfDyU4JZLha+mLbiZkJ9kpcv7S28nL9OvXbBer0Ec1QQLI
	Jzh0gPygg0PAH8r2MMhz5C+SsppC3CN5X4sYRpe05zbxViTlZXYWKXjExwhBqV50
	nPTwVjXJlA2/Cmz/bRpDprGKN3+Sbqxw8fQL/yjp0d5GrnDnvCLSwVfdNCFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1771353763; x=1771440163; bh=Tim9+xAAp38GkPqFll5dGAwqa6OafgbrbBg
	QCgOaUR4=; b=s9Uqrm69JkPh2X5OWT4A/0fQv1Gkbi2P2fTVZpNwU2hWHBRAvSY
	mDFRjy2fY01WAXVBwuQyIZg4RIab8dAMlkEU4qM4NWZA9EhziaOLIWOvXK5f5UUK
	+g3kA3lvZ4QsIMZMZDpFvp8viggvcsug8C2HziP0a6PuQIXNjh4Eh10FRZu4nLs6
	N0Iyo/ofn9Sm7kDaAnPJOL7rwja9wi1SQxK8G6Nr8U07cFKgx6SwEcbVGwF2Ug+A
	tGadeu+SYuaSTux3ojXE4S5RcWFiSV0QT/5zZ82zbsxuZzxo+oR6+9zlNFPs54Qz
	TASitGk/Z9h0LhwwNolO/k1dyxeNEhxhdmg==
X-ME-Sender: <xms:obaUac8jc8fMlE0yBod8v8xZNKZ6xzodK47LDrhrRtH_8OCJczJvqQ>
    <xme:obaUabqW6fdBwP0V13T8wtVWVaaOVPeQMewQqezSIbGK8xnGE8RCkCIlY2coZ1yxp
    A17H2BW5PDPg42cO7UOXFZmNbwiiG_3h_NxQIR54omzhWbJ7Y-7xg>
X-ME-Received: <xmr:obaUaXGbR10xinrEaNbvyFmnyDB-J0UKbdAKHsooyJ3GpfaOV8RnAe_1FLuAK5WKvNtMVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvddthedtucetufdoteggodetrf
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
X-ME-Proxy: <xmx:obaUaTntBnx6rpqiHG9owA7Jy49X7iSEow-kxj5DbDtpfIKn4Jq9OQ>
    <xmx:obaUab8r_0CTVNWWlJ0bdAj3kehesx_tkQ3WRiIfHvsC3FPaqOMWZw>
    <xmx:obaUackR2WCzPIsXU-LmvctkKyz0kkvsi4pBsiUNI94d__4P10h10A>
    <xmx:obaUaRlx_yjIQRUjhWYZGkBATvKc_khebU0JAcF1PU8doWiObfwvOQ>
    <xmx:o7aUadldnWuydphqbxA0KBJbD5iQb4jYh5mXbY_wDBW1W-6VQaYcip6R>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Feb 2026 13:42:41 -0500 (EST)
Date: Tue, 17 Feb 2026 13:42:41 -0500
From: Andres Freund <andres@anarazel.de>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Pankaj Raghav <pankaj.raghav@linux.dev>, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	lsf-pc@lists.linux-foundation.org, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, 
	hch@lst.de, ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>, 
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, 
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <yamn4f3oympcvc4otmzrrjgwxd5xanvk5j376dojky76lrkfgv@agfxv32zyfvr>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
 <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v>
 <2planlrvjqicgpparsdhxipfdoawtzq3tedql72hoff4pdet6t@btxbx6cpoyc6>
 <aZSzJs3WIuV4SQJp@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZSzJs3WIuV4SQJp@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B7BD2100005
X-Stat-Signature: agcc7p91p8ia3dupj1szrgr1ou1sc4eo
X-HE-Tag: 1771353763-220422
X-HE-Meta: U2FsdGVkX1/Vy2dxPA7LVpMp65fCtl7sVHK0mlz4+t3doZLmz/rVb/EJyGk6cqqJaYeBwGfnof/BHTHpmhWV0D8ipL1lfrjDv/CryJsk7o+rp6GZkNw1SgKMNa1xQxWOsxfdOaBqSYCJbPGZoReoxnOZLpLj+YIB4zoaG1ijk7EbYDyLas0TUemectuV9/gxpCFNcEMx2vh3xlrfxAUcw0aeSQKRNZ5ItsOZWoiWuj9SXP2gvSkObwQ372DT6Hr81K4w5+87jY3BDICmWI0Nv8BjGbnZ49+hugAcfm6+1MIr8S0fi4NzsOSEn/bkTf6mHU2o8ghqPb5ubTiX45aaYCOnuaAz7rXWrD+OBI22xucFTbRaNwwdjnx+CIvs1DalpoMRExSsHZKyvrixuwL3ioXMCYdwBnER+kf3SuEnFFuqE6d05RmAWxFPtart5Q3p3FgxW2NSYvvUv1UhOi30af9u9w/nzAhn9KxFtTQKem2n3q9CU0waigApMXO9gIEvdvkH/dVzufIb4LpLfsLu/sVvJoHW4zS8njmo917twx3YWPlysPNaZd5Awqj9oAUiy7QdviPJJ0R7o75Tzm2ArPMMyM09Z0bu0BkHzdWuZJbKf2d8dlvUSHFUMRATtF76l0stC+QIN5IIneSmYtIROnaAo9aef9hdyFc7VjCPncFw9lZH0uPZrxt2LTnP/aB9CpSr0EoVOHOAqm/K2ol645ESvwq3RhWjgA9EzCJnd+EHlHDwQTtcdpF5bh5h+X+2ILsVTVj0lFx0ThZWPzs5n3QG6FOnLG4B+5gjKIPCyrask7IzusQpyMStM174sHYBCzMmFgUtk7LZakzDKkBz3clEpwFqqMSJ6mqeqiNcv4e3IVV4/8CU4tM6gTuHzuLpZevNOe8ay90ChWdmhXpluHlNm8XqImFg2xLCwZeW0uAsXADeLMpcbi3c76/mkmvT0sRmFsDOx4CAP0RlpSM
 qf8By81p
 cCqSwcF4qJ8aMYMsMnomFrYVP9lmcxijvSi0780PmIRzj2DGM+AIYst9/zoTZAuFGV2ap7sxQMBME3D6rgdQ2PPPXl7u8y2+lgHB0MCdBQFVh/k+xMmnbMjS9pMdT/hHzXL/kDuTIJDPDJhwnmbzy5PEVJQ1Lq7eiyxMA/rhLB5ZM387CrvXsrFni4mcFNQ9HX2PuKEM5QoLgVl99uLymFVBqml5OAH3DVz1t7tckIUgrJ4RKBWkmHhfS1rbpU3azZscZUyi3veJ4PpwOgVzyn2QlzSaL1MCQsv61YUl0RzHVHCEGRjHiCoLUvoOe69shZvmlGGo+0xrBQ2ZGOYhTyZAgLxIU1B98/RSN//UQfB89aCjXgp8pCBPkRbv9Zxwf+o5Dwj3HLogK1vVTI56lWFbl4pgy5dhQJfxY+rGIrxKbhtoYpvevJuZFlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-02-17 23:57:50 +0530, Ojaswin Mujoo wrote:
> From my mental model and very high level understanding of Postgres' WAL
> model [1] I am under the impression that for moving from full page
> writes to RWF_ATOMIC, we would need to ensure that the **disk** write IO
> of any data buffer should go in an untorn fashion.

Right.


> Now, coming to your example, IIUC here we can actually tolerate to do
> the 2nd write above non atomically because it is already a sort of full
> page write in the journal.
>
> So lets say if we do something like:
>
> 0. Buffer has some initial value on disk
> 1. Write new rows into buffer
> 2. Write the buffer as RWF_ATOMIC
> 3. Overwrite the complete buffer which will journal all the contents
> 4. Write the buffer as non RWF_ATOMIC
> 5. Crash
>
> I think it is still possible to satisfy my assumption of **disk** IO
> being untorn. Example, here we can have an RWF_ATOMIC implementation
> where the data on disk after crash could either be in initial state 0.
> or be the new value after 4. This is not strictly the old or new
> semantic but still ensures the data is consistent.

The way I understand Jan is that, unless we are careful with the write in 4),
the write for 0) could still be in progress, with the copy from userspace to
the pagecache from 4 happening in the middle of the DMA for the write from 0),
leading to a torn page on-disk, even though the disk actually behaved
correctly.


> My naive understanding says that as long as disk has consistent/untorn
> data, like above, we can recover via the journal.

Yes, if that were true, we could recover. But if my understanding of Jan's
concern is right, that'd not necessarily be guaranteed.

Greetings,

Andres Freund

