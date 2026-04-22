Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59135FA1FFA
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 21:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B0E6B0088; Wed, 22 Apr 2026 17:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BBF86B008A; Wed, 22 Apr 2026 17:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1476B008C; Wed, 22 Apr 2026 17:28:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 484A56B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 17:28:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0D3A120134
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:28:37 +0000 (UTC)
X-FDA: 84687481074.11.1C9E578
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf14.hostedemail.com (Postfix) with ESMTP id B525F100013
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:28:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=daA1nv4E;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776893316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cgpza/ygVqVA9S3quWs8Q35TCmfB+GLC9CQWXkpoesk=;
	b=sgRWy3O3/8P64COaNdM5IPHSTWF+QY5vXx2WnFzNuHqUHnd5ieBPDlbgLYNdWqbdrBX9dM
	bqVdsqEuk7ieZUCl4MpotYRaiU0kM9r3zHzD+5XO70OFvQUUa2hPfZ78b9GGhEabVqYZs4
	N3rVb1oWEeIrto0s/S9Ty+eK3nh4UgE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=daA1nv4E;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776893316; a=rsa-sha256;
	cv=none;
	b=D2HotMKge4R7LBkEG4TMC5Gn6tNBn6lVlhZrMKyq+gQY1I/ZUwbq9jbNGyBrYpYSchX4Ya
	VHxwRbLNOha8Icw0uuyI8hB6pDuEJDGjO+3mFreTN1rz751bEycOppq/mQsj70PrGGlMfN
	aot9VDcuww4Vi2o3SifZrpdQEMovick=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776893313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cgpza/ygVqVA9S3quWs8Q35TCmfB+GLC9CQWXkpoesk=;
	b=daA1nv4EjYnSQLIE7dEMjIdoIMZC+orNAQvKRf1ByycCi4bPaBGaW2hGTdZwDfyOdXa2qb
	0glFoOF2Dq6n0hpicGLRRDEUCYyZl+PTLFy5IJHVTiLMpzuAZq8Q2iKR/VLZKTaJzprZpO
	1cwVSZV6Ayy/jV1maIfiGf0YJyB+YWs=
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (1.0)
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
In-Reply-To: <81033e57-99e5-43f1-a6c3-c363e96f9c9f@acm.org>
Date: Wed, 22 Apr 2026 14:28:17 -0700
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
 bpf@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org
Message-Id: <32CD853E-921D-4EEA-B1D0-4E4A7537861A@linux.dev>
References: <81033e57-99e5-43f1-a6c3-c363e96f9c9f@acm.org>
To: Bart Van Assche <bvanassche@acm.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ipq9wg8n5hju3twuo8sbzftd9ynby3n3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B525F100013
X-HE-Tag: 1776893315-209784
X-HE-Meta: U2FsdGVkX1+Ox5IzpDO3172iH+spH0fvE2wiHdGl2c2291hDX2KNr7kWXQF5/5NWiyCkh8wrsKuEpi9jUb4nIlb7xmv8W8Ircj6aMICcrAYMq29crANjhX6UD/7e3gyLzymyKCKfGHlbxSnkq2PMO6E/oY9YzMO9rjwRHmDd1HBW87hKwpuickfsETnUnLq1HDdZ7wI7m644rPO3FIEfI8ONH7sHM5gJwV3TeqNqmhz9DxG3gvcDOwD1U3kaD8tbv249poTXybsZTlLTiJ3ycdx8FUOInO2TUeXwJ3T+q4lzYW6f+5lk58LVYL/MxjsOEr3F0y6FkN6IWWB5pU3GNlvRafXQJv17PbP4VzkxEEnzfDiuX0hYnowX68dKD95QMcVhHW++StCjiZi5TUaaeYgjlE1RNqbclerCxm5UUm5XI9SIsBD+V/nEyTW9LisV7Dr28ZmffOHk6NFABUp44PQ1y5heDd/a/fEemBATYCRyUhXpJAyAkvEfC3904hr7fPVNaxadRABrU6EKCqh5JFBbKzcJJT6ODYaGJ4wWXh1cXCxXC0ROFC6aqwy9VRfMUMpBvHEPHuEpTJS/IHqGnxdTibP74mfJpG+h5ArrH9GhXLSxCH76c6wDo+R+Ump9gP5OIQjd269NH3enPUCZuO+m9kN+gwEpnruF41lMlQ6Sbj4AVRHcxgZHv6lBtcryxuAoGuk1kUfsuh50RJA7XYW8M4RiUQ1vO5IloWxCMVLrNX0wrjEceHjOMzVJo/WOuVO6Zy6wJ7mEFYuA7z2l7nTOIUz2W/V0+LhubhMg5Kty+PCYFh+5SZ5Sv3iDOn6ZHouYmk9PJO60SCeldKbgK290yQVf1C6TqIM6pYGXm9CCH5xNXb9QSj4FQDhKYfJs19ZO0Z2piImk9Oj82g+vto4v1fUXb8hNyLaUgACGnBcAXtix0TOXMxwib2oOZiMa/di4p++SpkzdDwrx+aX
 wgvwafvI
 1h6yOPUOu2iouMRjSg1+IVmiUKxH5kpb+fY7GW9ODGftKt1kipsiSsngNCPxEBhjXD3z5ezoo7z42SQUWPOFOHzVCB5M2W0MwkZKBfclAk951yHASduezNh/M+3qlrEoLE8SqUsdb1nB48Z2iqCHQmwTYoS5fLKJzGujuILYL7DpE6xopo7QLc55h2uXzhv/kcdEBuWlUjPW2wUVRZ8CosInLwJEcMoouw1CnPfsgpyfl40Z6nxIEK3boUyDsnpooStQf3R4qivH+dQ7YBUXHm7Q6uEaeQ/I/vutL51BsjXdlu3HI2xg61dm6wbyJz6UgryM1Nm+X/5iSCBQYa3Tu/VA0Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I suggest LSFMMBPFLLM :)

> On Apr 22, 2026, at 1:30=E2=80=AFPM, Bart Van Assche <bvanassche@acm.org> w=
rote:
>=20
> =EF=BB=BFOn 1/10/26 5:24 AM, Christian Brauner wrote:
>> The annual Linux Storage, Filesystem, Memory Management, and BPF
>> (LSF/MM/BPF) Summit for 2026 will be held May 4=E2=80=936, 2026 in Zagreb=
,
>> Croatia.
>> LSF/MM/BPF is an invitation-only technical workshop to map out
>> improvements to the Linux storage, filesystem, BPF, and memory
>> management subsystems that will make their way into the mainline
>> kernel within the coming years.
>> LSF/MM/BPF 2026 will be a three-day, stand-alone conference with four
>> subsystem-specific tracks, cross-track discussions, as well as BoF and
>> hacking sessions. Please check out:
>>           https://events.linuxfoundation.org/lsfmmbpf/
>> for further details on the venue and hotels.
>=20
> Thank you Christian for being one of the organizers of the
> LSF/MM/BPF summit. Will a schedule be made available before the summit
> starts? A link to the 2024 schedule is available at
> https://lore.kernel.org/all/20240510212132.83346-1-sj@kernel.org/.
>=20
> Thanks,
>=20
> Bart.
>=20
>=20

