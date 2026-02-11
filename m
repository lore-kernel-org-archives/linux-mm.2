Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ADCCECD6EE
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 23:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDFED6B0005; Wed, 11 Feb 2026 18:39:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D636B0089; Wed, 11 Feb 2026 18:39:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9F96B008A; Wed, 11 Feb 2026 18:39:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC01E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:39:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B16E1B3CD7
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:39:06 +0000 (UTC)
X-FDA: 84433793892.04.4DA9C04
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5BFD8180006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:39:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b="Th/f4JVF";
	spf=pass (imf24.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770853144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vAcRO/WmRaYKNRMytp9/Kta0ZFKTLDhhs58Vz/QOHK0=;
	b=DzDkv/+gocPo9Q6kr8GHb9wz5XahT5ccIvIzjEdZLU+IoGxOTcQEPaurppJlRIW50xCZAJ
	JU3/5kMglve5jKXsf40QW2vNQ58n596P/OX1R3V6P5MN+sYs3nom7wDPQBkxKP3qmYPgLe
	hcIgSZljGEQbnBfZIoQpLMxf486aNKg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b="Th/f4JVF";
	spf=pass (imf24.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770853144; a=rsa-sha256;
	cv=none;
	b=r2rjHSNdaI+CkqCrUi3dnSdcBnVf22ruQMZWNUy5Mv8C1r3IADmKhqUCNh7MclF2/IffkD
	EEyhGgyujHkRqFLScYD1yyGVdygNsIajmFMSBxC6FmT8KAxlJdFuVlNXeqxGakYn2LcxiG
	iELxoGHJlATLXLRZ4XatAM0IR3Ja/z8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1770853142;
	bh=vAcRO/WmRaYKNRMytp9/Kta0ZFKTLDhhs58Vz/QOHK0=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=Th/f4JVFRKr7JgmTwZK8qFzlsudyYzT9AHecmGVBUdDVmuEnWy3dx/hxvDnkMyCSP
	 JAcGXaFl6Fcs+EiCZED1v87aoi2cGchIOrUpsf4NsqJsMvfMTww8h8i8ORhCMh91rE
	 Fh0AsoZMXe3gU60a41fywcgT0onpQRbfYEvTv3lM=
Received: by gentwo.org (Postfix, from userid 1003)
	id D1A7240B01; Wed, 11 Feb 2026 15:39:02 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id C98C24028B;
	Wed, 11 Feb 2026 15:39:02 -0800 (PST)
Date: Wed, 11 Feb 2026 15:39:02 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: Yang Shi <shy828301@gmail.com>, lsf-pc@lists.linux-foundation.org, 
    Linux MM <linux-mm@kvack.org>, dennis@kernel.org, urezki@gmail.com, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Ryan Roberts <ryan.roberts@arm.com>, 
    Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
In-Reply-To: <aY0Q7QhGDKwKk2ie@slm.duckdns.org>
Message-ID: <c6ef0444-9423-4026-5a3f-123183246ddb@gentwo.org>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com> <aY0Q7QhGDKwKk2ie@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Stat-Signature: ugjisyihunco3occo5hphao5j9on5wfi
X-Rspamd-Queue-Id: 5BFD8180006
X-Rspam-User: 
X-HE-Tag: 1770853144-453258
X-HE-Meta: U2FsdGVkX19QsSlRmf1c08C9fdRWODsmq/pXp+Kfr05OSFRBZ1MTwQDtarImRDUkzJ8gL6QMfNryf13jC+TEgPMZ7Ab6335Ws9I+pS8GSNUCIHNOYji1RzEfweETBti2pKYC9PDCQ3GXa3tn4wc9tVSmfQ6kjY9MvPFVFOJObXItilxC2umBLkJgt409ysJFQV8Ezk6dTwR9ny0xVtYTb+kOym3dy0uAmpmVy17T2jhHossvvsq7srPTf3ihn/WCW7ZqVoRFHGCcGG4a5jaDkeC5FX3z/x+iUxHGfduyoc35XFe42RKhLF8YsCej5QvcnFTpjg45DBpWKgtG2wxyVTaRGcrmmCVeqdu94cF7jDDpiMcMs5gLvNCgD/v50jii1EtxNBKlETz5vd5ciHpkpTEV5+OMBvPy8Bm9yoK+Vhxm4Kke8oDe109k4Adbmu55Istxiti0puOxG6Z6Q/dXOpJ6TCH3TwNgGPcEjPV/moSYjNB1HiGHacjSJ7qIm+z0Jr9kP9UGdOxtEpSshmgT3aI5Trgdf8DeRRnjmwzFflECQPITH69dOB+q41VwS/hkbLDQV7zJ8BSCGlMXSjqzTOmn6tNWGES2Px3CH1HE1ogISdQ9D5jTZ06EQbk8yYh/dY+BYWxvRObpMTk/virYqyM0pB6CJsUj8nERRnvXy4vKoiYQKn9MYjsrVq7R3qfPRzq5Y4QYHx3sb3tjDx3eMQEU8LYwOUE7QiL7Yc4CJXhgwIcpNxFnGFGFOgp6/foJ9rGcBc5VR/oMheEx/bcM15+EwbkylP6GS4QhPm3JCrX/tWjHj6CXWzcMTqzKvp8HL0n0YhDsA9XlWg5XXyS7Ww3PNe6HCrtKwn090PzO6IsoT6x4SC1CdljMxmC7GG/nle6UgeqVEsQBMGqzUcgWmM1Ps8FcS44i2PQLAwtkKJLoaQTQUkWS3QiZPPL++ju19Jrg54cJyeS0C1UO8F/
 L6DMwB/i
 FV2FZYFOm3WIx4c9DyHWvbefX22KWPXKR+uRlThWOuZjuIQho4skgDq0in7b6bI1KXmZLVi/jHEGcVpI4TQO2vuOOy6V9qi7hcQfnCGoKjG7nLo/njOTfePRX4p8GDqIHfeyxuvJmgR3Ku9BD/wwa4AEHivNZu86/0m688b46qzwA6QN2jkLOXjPjnV+J15w8Pq5sBpBVyOjptqUhelr6zIPGb4xBLoXcy58g8vDF0wgtqbhXpuWxsKKatr3eeZhaIWApY9aSZS70COU4dpxBBMxxOFuNQNnIvnyuHna7uArFJuFNtvgGemmZNOHvUSdR5cOv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Feb 2026, Tejun Heo wrote:

> One property that this breaks is per_cpu_ptr() of a given CPU disagreeing
> with this_cpu_ptr(). e.g. If there are users that take this_cpu_ptr() and
> uses that outside preempt disable block (which is a bit odd but allowed),

this_cpu_ptr converts a percpu variable offset to a normal pointer that
can be used without preemption.

If the scheduler changes the cpu then you would remotely access that per
cpu data in a remote cpu. Read only acces is fine. Writing could be dicey
in some cases.

> Generally sounds like a great solution for !x86.

Thanks.


