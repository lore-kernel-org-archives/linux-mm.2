Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8451FA1FF0
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 20:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3592B6B008A; Wed, 22 Apr 2026 16:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2B06B008C; Wed, 22 Apr 2026 16:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AAB16B0092; Wed, 22 Apr 2026 16:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 064FF6B008C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 16:30:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C32E81C026B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 20:30:08 +0000 (UTC)
X-FDA: 84687333696.14.031C8FE
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf17.hostedemail.com (Postfix) with ESMTP id 95EFA4001C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 20:30:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b="HNCt/eZM";
	spf=pass (imf17.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776889806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZQPUhx+rXb0qQBkKzoRsQxVCKYwUq/JfEdgKMzTeTk=;
	b=aYovSJsRWxhJV1/5cxqsYmmtw1W7X2at+2pxmuefMmnMg6imumkfGXdp1ApIejNsRGiFlf
	9O6UbvH/CK5UV8soGiMH0sVhc6FWJNLd1IdM3Z39ZvH3bjY3htSsJRUUsZhCldJFLBDZaD
	pS/jwzg8CpWbTMOhOBOd1PIGOifaDWs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b="HNCt/eZM";
	spf=pass (imf17.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776889806; a=rsa-sha256;
	cv=none;
	b=8NahG235aZ1Brz6RALtjVARQxmQNpNAkd7gT9bKytxJ2O9Ikmxeh1zbrJINap+YHJV8Yro
	eabxPLYQO1UIWxMs3orsm2HSknoG4DBI+fvXnEc7MJYAO7D88wU4pS+d8UzquUBzYG2g6O
	Conr9/W1YmEV47Cty48qnN8BSLzLrdY=
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g19nn1cZKzlffvg;
	Wed, 22 Apr 2026 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776889799; x=1779481800; bh=VZQPUhx+rXb0qQBkKzoRsQxV
	CKYwUq/JfEdgKMzTeTk=; b=HNCt/eZM92V4a8DUsj//sCu4BVDsEhMIQqH9AWxf
	A9dFwDjzecKhicDRODlprsewUD3xYpBqLhcykXGooDqbWvZW4KTXDDe6d2Drbez8
	9WpsCKdl+/Jj/eRaV13QthXvPnPzFNVZ2JGwraMMHd8tcYhNSl4c1Gc1yXXMifES
	db6PEK5zxfKV6Ytkf4zqDR3JStar0DXdOK7AxfSh1KyFJMd7qWlrMNNFcc8Lk4jh
	ghEEAEt848HZX4nw3Xh1n90K1T50fdoL1yslUTj9b8KYdLxp5pb7rN0DOZxKTSDc
	ImqYZpEoFytrKLhitP4ypYnIrE0Mvoll0LN+QsYfeJ5yRQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MpgyuWK0q_50; Wed, 22 Apr 2026 20:29:59 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g19nd4DxMzlfl5n;
	Wed, 22 Apr 2026 20:29:56 +0000 (UTC)
Message-ID: <81033e57-99e5-43f1-a6c3-c363e96f9c9f@acm.org>
Date: Wed, 22 Apr 2026 13:29:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
 bpf@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 95EFA4001C
X-Stat-Signature: 8us3rtp6igb3xn8bm53hq7jsb6erz55q
X-Rspam-User: 
X-HE-Tag: 1776889806-581148
X-HE-Meta: U2FsdGVkX18ZqA/cZpJoRMM4gS9dWL9cKZySchjU+YwbNmcieaAoHXSeGQKN7YXvwWa9EHSbMoYBhLvczIKcTHZu980Xi2BQzXjP7xUEL6kAqyvHClb5ems4widls6ghTiLdwCCbZ7rb0LeIYQVtknQVg/80PhqvNKFX2jZhzNMKTSa4hq3yplWoGrfn5j/v0Kkbt/y0P8tuzHf3fdmAbmqjUEE8Tq1/GXwkBbwwDG8eHqXsubdJE0MsGQX3fEPuYya+V7RAOZ16BM4FovVLnCr+e9DISGZ0ayparN7ieB3hw6TbpAx4kqmzjvuxRWsFcINLKp+1xVo2SlOWjB9tum/I4i0XhsvlwiqXsQJMZvMYsP0MYsyBKHzjEL/wx7yyKQVFB+hk24D6Jgx+pd3ofssRwhxgaUxqShBFtcaZ+P+cokmwUKGQ/ecHezAheIGliOPS4kleEhlXc2JgIhjlpgLF7X7Bfa7DJ55DM8OeuQxtXGGSF976WrQdQ+5hqog78vgPcTsvR6lnyG+rIsVhVz/mdDGZ4QK8fE4kvngVp2OGUer1UZvTWNAXKb/KASBlY34P3lyLmdky1YAJwMDMwetBqbcFom/9GuEu9DcadeMZb67cDYTrB7dT3OvzFeCh4DPN4E0qqU4C6FUGIOXrqiwKC2COajpUdasCrTk/4qw02XpGPqPV9A/8ZytxpPonesHN6Vz6tpU/OpW9I8HVP2iHz9gpnBHlPqMivouLEtKoatm/D8B6SkYWXS28xl4lUQtRF04LYtbHUdwDxLNkC9/DuLtgFt7gwrxEagFCs5oBeXUquuaMIHpBNjlXGOYkgWUPiG94GwixGdv4zhbubXbRnM0pV5DNsohprpbi2pLvKLaIIRmP9NnpgCSGLM6HvhEn592fYKqlYrFMwUKL+5wzZ8P40nMLxvcOZkKuMacKCsFsu+Aof2l0QBYvP25sDm45LzEnJrQF3ZyU9wc
 l13SdIqn
 akAJCyKzM4eFdyQwfWeABTnshatIBxab+ewebFNuaApTmqVu6vu2iHb6UDr8uXO1HGbRO3F1OCyjmE20HjfLuD6Eb7QyjXGk3n9YFla95wL2yjH+4hqONV2M3C768FhjxDGiY+OMKkBWTeET0H4BmjYoqdAZXUt/lrcbeuR6Q1D1HxQ/1PC2DC6ajtk/OP/5JAn3PG7C45XGeNtPENUICkBy99Igd7PXeskl9NfBNliOST4bi/2w2DqpT1cuEpt8pbi1klfMKdQvQYj/HcTSxwQtVM3aFisXTX/Io93oAXvIIK9pksk7HIa4fVzfXzgC8XV6CnUXpaYMwRWXIZPi4vDQcVscAZTh18x6/zT3lGmOQ2RVs/H29ccrsBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/10/26 5:24 AM, Christian Brauner wrote:
> The annual Linux Storage, Filesystem, Memory Management, and BPF
> (LSF/MM/BPF) Summit for 2026 will be held May 4=E2=80=936, 2026 in Zagr=
eb,
> Croatia.
>=20
> LSF/MM/BPF is an invitation-only technical workshop to map out
> improvements to the Linux storage, filesystem, BPF, and memory
> management subsystems that will make their way into the mainline
> kernel within the coming years.
>=20
> LSF/MM/BPF 2026 will be a three-day, stand-alone conference with four
> subsystem-specific tracks, cross-track discussions, as well as BoF and
> hacking sessions. Please check out:
>=20
>            https://events.linuxfoundation.org/lsfmmbpf/
>=20
> for further details on the venue and hotels.

Thank you Christian for being one of the organizers of the
LSF/MM/BPF summit. Will a schedule be made available before the summit
starts? A link to the 2024 schedule is available at
https://lore.kernel.org/all/20240510212132.83346-1-sj@kernel.org/.

Thanks,

Bart.


