Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B394CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2590800C3; Mon, 27 Oct 2025 19:41:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD258009B; Mon, 27 Oct 2025 19:41:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBA0800C3; Mon, 27 Oct 2025 19:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADFBC8009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:41:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53BCE48ADD
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:41:57 +0000 (UTC)
X-FDA: 84045519474.16.9C22ADA
Received: from cyan.elm.relay.mailchannels.net (cyan.elm.relay.mailchannels.net [23.83.212.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9EED1140007
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:41:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=auF05oNm;
	spf=pass (imf23.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.212.47 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761608515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UF2FEr/ckedYBRJkD+m/g5x+lv+k26BHP65ZAf74xNQ=;
	b=DwWmG8R5aMTcqyGwtR7fv9/AUpBTNp8H1S0axiVUQg4ko9OlUIjDvK8G9H2jaOg9ulzwpL
	ZmNuNM6trOAPIvTrKaZg9XLs0U2umVadQEMON3Rn4hfGk1I0+EdiLprvAQatwnqoG5wzQc
	m05KnTMvH0jpStH99k26H6vyoE8qdug=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=auF05oNm;
	spf=pass (imf23.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.212.47 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761608515; a=rsa-sha256;
	cv=pass;
	b=rUo2MA6PD5BERY+0aGtHrpDS+st9ncsvNottRyc8wRKMfZh7/f287OClYK+XpXHRVY4RbB
	med41B1IAkBdfyZXpDflFeQuK/MxtQKIrCloiRRyp6hQODfzNnyRczGmkXv8XfradfXzG7
	uv2zicShouCmyMi+WymM8QhucAxs/lI=
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id B46E5421E21;
	Mon, 27 Oct 2025 23:41:52 +0000 (UTC)
Received: from fr-int-smtpout17.hostinger.io (trex-green-3.trex.outbound.svc.cluster.local [100.121.22.161])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id A62B3421E7E;
	Mon, 27 Oct 2025 23:41:50 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761608511; a=rsa-sha256;
	cv=none;
	b=m7xkr+ca1NqFxV42Z7mS4rEbu6sPMYlCU2JWEe+pCHNRhJqJL/AKiBYL1AoLfE+bEjuPEz
	DXLr4nvJfna3DOxziEmlEbM96bapgTekc36nrvOzXQzGYKkdoVBdWM7ObgT55wcG1LMCNB
	uPJmwWz76zJlg7hviCFdEVZWLGhfKq7Ss3lvZXzqtYngPkW89erCRSJx2sknUfr0rlsewc
	oRTJkUAJdw2DWGBOHVttTqo7z89LahG5iQRiYUz4QsQeDteDruXF6ncPScoxSm9yPMoK8c
	maau8tU3D4fobFX8sfNZKquZvN/F9ttsHASx29yA8N+n7Qo1miv6ScCQ2ybIog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761608511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UF2FEr/ckedYBRJkD+m/g5x+lv+k26BHP65ZAf74xNQ=;
	b=uvh91yRiU/+dKUBdaoEPtr5pxu0Yy0/Rs/5bzVOfFuqdHz3XZeYlgUSno2CfyNkrU9PNjN
	cfp8/lKr28+LA0hTnSg+moq/PpZQ+wJNPQB2MJ5f21hffkCQjP0tqVs0Oj0iWKNcl4+yXe
	XKKWirdWgDwXFyMRZSJBcxIBi8Ej/MzFHLOBmRVaCucByRJt29+7Y6oYiHo3BT2lvT6QPR
	vEIw8Rb2O59nuw/L34fV3ufneW0afhpXbF8UdWeltW/FaUoW0nEMcHWy6rvQs6tie2gWgB
	DBL7Zwa7FMiHV60ds/vjeXeFYejbDIy/Pa1PlbZfta0e259iNDpvA1AtkiPmNQ==
ARC-Authentication-Results: i=1;
	rspamd-674f557ffc-j5ljt;
	auth=pass smtp.auth=hostingeremail smtp.mailfrom=linux@israelbatista.dev.br
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MailChannels-Auth-Id: hostingeremail
X-Spill-Arch: 54bd9cc055e65ecf_1761608511816_2982394158
X-MC-Loop-Signature: 1761608511816:1182732274
X-MC-Ingress-Time: 1761608511815
Received: from fr-int-smtpout17.hostinger.io (fr-int-smtpout17.hostinger.io
 [148.222.54.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.22.161 (trex/7.1.3);
	Mon, 27 Oct 2025 23:41:51 +0000
Received: from [IPV6:2804:d59:8970:3b00:5f26:e2da:68e6:2358] (unknown [IPv6:2804:d59:8970:3b00:5f26:e2da:68e6:2358])
	(Authenticated sender: contato@israelbatista.dev.br)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4cwVQh09wBz1ymV;
	Mon, 27 Oct 2025 23:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=israelbatista.dev.br;
	s=hostingermail-a; t=1761608509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UF2FEr/ckedYBRJkD+m/g5x+lv+k26BHP65ZAf74xNQ=;
	b=auF05oNmU6sYaz9qm2z9Em6ubZJJ/uM6uorE5H9wKKlo2qh428/CODReNMz9anX6EenwHp
	Nm3imuydbGHNO4aY9HU2jwUcn3G/awHDfmV3S7TDhBGRGzhvFliISm+on3cjQcdtmn9Gyv
	IWIhoByb0/Ls7KovKUHiDqWg3nTt4r4/BKOWXGEdmfwL/q+mHATlJUHeVQwGi3ZlZPoU++
	47V9qmdeCoi3phUrjaa99ILdvbECX1hJ+TmDmJ81Qeht74aPrWZrHFdCFD77D0fXlBATUx
	t2ToOAGXCKFfnQM/fl1GordU5mUab8QmYy8bAE2Lu9scpJ+qDXsJ9a7Y7Du/JQ==
Message-ID: <391c924d-b6f4-429f-8190-b33e3b6a3942@israelbatista.dev.br>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Israel Batista <linux@israelbatista.dev.br>
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
To: Omar Sandoval <osandov@osandov.com>
Cc: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
 linux-debuggers@vger.kernel.org
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <aP-3dauwpc-Kq5Kh@telecaster>
Content-Language: en-US
In-Reply-To: <aP-3dauwpc-Kq5Kh@telecaster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Oct 2025 23:41:47 +0000 (UTC)
X-CM-Analysis: v=2.4 cv=NuiDcNdJ c=1 sm=1 tr=0 ts=6900033d a=WIeu/gG1zxr2CnNbFFeIHA==:617 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=_ZKPHTLhK7m246hEAoEA:9 a=QEXdDO2ut3YA:10
X-CM-Envelope: MS4xfLgx9kVtAxys6ymeasq03EQxMVirb1+nJXGZwAg3ORbMcDKG5wdrMLa0HedftkBrxOx+/jUR+EIXYem2+TTvLv1Z5ReIzc+StfggC8dD7+y10KFzl/dA +6wFkLI5bvgiKsFkrh3bEKV+ACC6VMe1h/ahP/ORloIijiYnMGQIOExxSzZzAGZeal50ib6bgzfv1SQEzI6JHBFyQbolR30/KpPF1DlF+KabGkqiUhteN4cX ZaFEyFQUe7OdprxS8Aa57Qbcy9zEDI8bi6FlGyU74gFJL5im7/p8Pzhpe9Q0VwGhvqiUwOF9uJNxNpXpZfcOKRWOPdaNpBV7wdvGnSMQD45ugbqNvFbrLCAp zXTXrEgBWqs0DlfAOivC9jgB5KamHh+SZrx81mJWdbm+1aFV/yxwJMioEjhcH3n9tYDVbU40AyxslR6/KDOA/doq0zP12g==
X-AuthUser: contato@israelbatista.dev.br
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9EED1140007
X-Stat-Signature: mbmkp9ymb9xwpk6yoquj6zxmraai33uq
X-Rspam-User: 
X-HE-Tag: 1761608514-266503
X-HE-Meta: U2FsdGVkX1/xvPzjYRKU425ye+tDvSRLJZ9Qhm7uJ3wHM2VZta4ckKLlFoX2H7BbHkyZnaiOse/QNe2kJ3WjtaTX0DNMHDS6AZAc8HIDb68iFrN4o2oTPQ1rGSOWhegcKOKog3QdpnWcoSRoySIL5UdPZM6WuvvS+LimOr78te6BmR03LMALn4+UUyX6WpLzvv9H+Ew66UzYqtOgEEWBVERAoL4A+USkCzfQjdUORBJGLs6UjOA7Ds84zTBrKv+4Zhudn8aRfwqzPi15Y9kUYzUEaGUvomVD60JZpkTeijUuthOBt9ixqikBwxAyivU0H4UJ3q80wvoF389+VV/NtWpDVqayvF0y4Lj+tZBJG62FWSzQMmUIrIR1wsLmkH2ajtomokcKJxpWh6toes6H8eWMeLOSOyq4Nq7UFGcAXUQNKIahVCnyQv4G0s2EhWP6kx27WuouqAHfYYwip8Zbqgcs+4vqVBCa5iMH0f5ffzldzFHt93WsV8GSIwtHeAsY40fGgXpIQxlBtoX6lME0+DhWmzcBIKkvAUffETclJO4l4EpdxyA0jqdAfypxcLrH+RxJwLBfqGNQu9SRIOFm6hKXXahEKLcHucrJzqhU7T9ZtEdBYwqGBnroPkAJDLIxREbQIKr0gnVDXcSKo1VgOqR5sYRch9BEj0rTMG2Z2yZ9NwQZ+TfmnD/BtsHXVRSqBfnbns7jLfg08e4G/oY0yp5VZqqeqQ/1ZPHT/59g0lHNCxWaEUv9q9BmK99Dn3T/9XyACjowfu73TaVL+7MY8KiWQzAibm+fDqdlDJa/dy5uqjs/pcps32hSyf62QnfctUqV8qaAkOh+u1SvTeuVyGxXXERQcs1WcynE0MIQoe1xjguOIW7K6kZbyS3GgVyf6hmvZ453A4VYUurOsagXsaNAyU0tBtFU+YRv2ayCF/IBvAk4opMzvjxjB/zUKkY0bzol0wnt1kNBsgawA6t
 b+FLUf8q
 5g6qc++HEqDQgYdgct9UACoiu8+95mKheb2x2oQ24QKURajjVwO2V3fB4f0TLuPATMfFK7YPYlkeJYqU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.325902, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/27/25 15:18, Omar Sandoval wrote:
> 
> What kernel version is this patch based on? It doesn't apply on mainline
> because it is missing a couple of definitions added in 6.9 by commit
> c5f1e2d18909 ("mm/memory_hotplug: introduce
> MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers").
> 

Sorry, my bad. I mixed-up my local branches and created the patch from
linux-next rather than Linus's tree. I will create a new patch with the
proper changes.

>> +enum mem_states {
> 
> mem_state is very vague. enum memory_block_state might be a more
> appropriate name.
> 

Agreed, I will change it on the next version of the patch.

