Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE499CCF9F1
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 11:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D0A48E0143; Thu, 30 Oct 2025 07:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8718E007D; Thu, 30 Oct 2025 07:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BE578E0143; Thu, 30 Oct 2025 07:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9CA48E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 07:16:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90BCE5C513
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:16:12 +0000 (UTC)
X-FDA: 84054526584.10.2D67EB9
Received: from insect.birch.relay.mailchannels.net (insect.birch.relay.mailchannels.net [23.83.209.93])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3DBA210000F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:16:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=CAcB0saY;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.209.93 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761822970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDHL4ewZk9zrCDH9K3OikY1VZw90grf8AVfLkeh2kCY=;
	b=PXTbXyy1V/nJjmThUxq62lJYD2/EI//4h4bHUFVMrz3kQ/0rCsW9sdUnvRKXB3HoEE6/jm
	AMbisDOD91OBInz5lzSjusZurgAg0q40svUTpQJTG4tgZfbV8ije4LEmmP7uBDehkKdmNC
	nXd5N0ldF3zmpgSCbvgOTwOtzw5G3e0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=CAcB0saY;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.209.93 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761822970; a=rsa-sha256;
	cv=pass;
	b=NQuj+BvJpZr+HlrlInL3UnonzyuhiEYkcrZI31iZoQJubaBEmh2oz4iQuZpPm9gVvsbvNl
	3syoMoM03fqc0ltaMLE/t0aVewWEx8stv89FylZdxN1jtJFkf3cfbR7yvV7VrYdYiZn+vz
	/o8jT0l2itC0Rp4JJqhROVrqZA6QHKI=
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 3C5A57E3BC7;
	Thu, 30 Oct 2025 11:16:07 +0000 (UTC)
Received: from fr-int-smtpout17.hostinger.io (100-121-225-152.trex-nlb.outbound.svc.cluster.local [100.121.225.152])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id 2B02F7E2A99;
	Thu, 30 Oct 2025 11:16:05 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761822966; a=rsa-sha256;
	cv=none;
	b=BErV2McJc1hkGSdKLyrYzjg+21W0sgLZYoadhHA7h3e2Ok4BoKYyE6PpFt3LdHWQ68H2Hy
	VhG9CcS4qtgt9+RqMv0VijOjlL6waVX4irBKVGWLtIN1p0VPpslO4Gr1gSVMN/1IjrsqzA
	UoJz3ot8X747BCvSYUzZW/fPLyTQumiUJSgpMf7tOX5g7qb6bzmZkUy2LicJe8Q9+qowX/
	ccikcBSgK2BfC82zsfVCwu/mi1u74N8XoUFrB2c0A51/AK5IBjphRLApTO3E66uZv7u9iA
	bmGgaL8bk73GdnB+oM5t6SS5OSfFQzPoTr83Z/BUsi+c4phEUpFYGTMbGi4STw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761822966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDHL4ewZk9zrCDH9K3OikY1VZw90grf8AVfLkeh2kCY=;
	b=g6iAedbE3Dh4huHhq7VoWR7Z/jLKM5YXS08EXE/0H8EiLsWav2WwMvpy/jv8z2Y8ajNv/b
	JXHYhtUBLHZyBhrsW28lbcxkfRL+FBBOioj0FwaJDqfIbxFgnTb1SbX5y/jiPaFc87fq1Y
	x4mUc30UTs1hzuncyHy/IacUblDHvrDdLvCY0782vSWn+SCfcDId8PRpxogg0H+llAPg83
	ePEx/2ei/1zGF3gI13JoBWEeA8PNDAULzEz4shtcwKaO5Sb2qtiyGcA1smc9+c0HZ2m66Z
	cTZwSIexIFPBKZ8MFfqpaNgOI8xq77Y76/OtaBzZZppcQGy1np1f0nq4BwmZqQ==
ARC-Authentication-Results: i=1;
	rspamd-768b565cdb-vxqzd;
	auth=pass smtp.auth=hostingeremail smtp.mailfrom=linux@israelbatista.dev.br
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MailChannels-Auth-Id: hostingeremail
X-Left-Imminent: 2c2af0c46274d279_1761822966546_743931888
X-MC-Loop-Signature: 1761822966546:1214081577
X-MC-Ingress-Time: 1761822966546
Received: from fr-int-smtpout17.hostinger.io (fr-int-smtpout17.hostinger.io
 [148.222.54.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.225.152 (trex/7.1.3);
	Thu, 30 Oct 2025 11:16:06 +0000
Received: from [IPV6:2804:d59:8970:3b00:5f26:e2da:68e6:2358] (unknown [IPv6:2804:d59:8970:3b00:5f26:e2da:68e6:2358])
	(Authenticated sender: contato@israelbatista.dev.br)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4cy1km6VZ8z1xnd;
	Thu, 30 Oct 2025 11:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=israelbatista.dev.br;
	s=hostingermail-a; t=1761822963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VDHL4ewZk9zrCDH9K3OikY1VZw90grf8AVfLkeh2kCY=;
	b=CAcB0saYZ0TRqppdT2MLgdkZBHkEpLRpKnNi41nKaGVw4Zc4V+4yj/q6JJ8ukHyc/sZ10z
	HMCGUhwZi8f/AkVhit6pSROeTQM3afJSQB8mjmXUG5SLlSxCGaVJk2pcBCEVwETLmWgR+r
	sN1tICwSs8tZnHhT9HPDTxjAVKFnG8/8pKn3kKWMGlEII1QiLsQrCEm8XxT/S0wgfd2Mmk
	VwekRg2TckNcgGK9dhcRoBIFcR0bF128vuR6EadKu97koXiV+JocpObKj1dFbJHCe84TTO
	3iqdTognOCt+Nrl1SmTPEjGS8V9U1/3HDXrUYdwbs0q5wJHg57hnhTGR83bXoA==
Message-ID: <f7dd549e-7dd3-4fdf-89f7-ef6993376809@israelbatista.dev.br>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: change type of parameter for memory_notify
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: david@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
 osandov@osandov.com, linux-debuggers@vger.kernel.org
References: <20251029195617.2210700-1-linux@israelbatista.dev.br>
 <20251029195617.2210700-4-linux@israelbatista.dev.br>
 <004bb148-a818-43d2-af04-2f2ed85cbd67@lucifer.local>
Content-Language: en-US
From: Israel Batista <linux@israelbatista.dev.br>
In-Reply-To: <004bb148-a818-43d2-af04-2f2ed85cbd67@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Oct 2025 11:16:00 +0000 (UTC)
X-CM-Analysis: v=2.4 cv=NuiDcNdJ c=1 sm=1 tr=0 ts=690348f2 a=WIeu/gG1zxr2CnNbFFeIHA==:617 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=D6iVMuFdKyQZPKt9lRgA:9 a=QEXdDO2ut3YA:10
X-CM-Envelope: MS4xfCPijR1zT2gvS2xZDo2skE0BVZOpfRXUrmejQzIgVHzmNSGG+Z7IJhTNf5qdIlEVSroN2MUFFep0E309stSbauB1hA6pwFC8Lbn+6+r8q3zyuc5PG4Kk oth7ABm3rHw482hXBaXHAj89bpcgrIY00zs76Ey8zPn7+sftI4CEVEpDQ67jR8bsPKBhHkQJAyZ7Occ4LCLiOZLbKZdK174UzzjN6w7iVepdXd4Avi0fO78s NZJwzsmkDU9xHBVY6s+AUxP9eLKhyreWVtkYXvqVJeGJ2Za4dYE1vxW1ueOxERbKKEAzD7ermT6JBvVUQ241YgeSte2zqPi41CuqmdOg/j6nLxShVHULtcQ8 Bk0UPr/eVwOsr8RykFWDQ1ixFYgHeHIf3bJtl6wgmgxg9OA4+CKTwiyObnfIYqNcTKNIpQJ61UHJ6BRBJdQfeng+Dol1kUzn7VvERpAwTSJDWfwfvRY1xgm7 n/o2A5msHC+nGMhB
X-AuthUser: contato@israelbatista.dev.br
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DBA210000F
X-Rspamd-Server: rspam03
X-Stat-Signature: dq3ai1tns7zt91rb9okkk66irb5okghk
X-HE-Tag: 1761822968-861666
X-HE-Meta: U2FsdGVkX19VPcLdi76dHnnjOdjAOpoLA3JceoLBHGwr5p0bkAgn3CQFWTBiY9FZLDmuGZ5FCL9QOsNeTNI+dFbZPMNnW0fl6wVNk5ZcgUzvL/kGYA0u8XSs3uj7bu8WkvHwRu6kp2VzewmdcelhbhHW12NdSnLFeEpU70PAzJWPhkuG8JXDr/BfG1xsIsd4udJUZvHjjoJgNP3XThe9UYNn8SwwjlKlFYzK6o6KF4cDGiLttH7neQnoHORKrOM2OJe3uqPsKEHO/AOl0erJFoOmGpW7KaWpVaXEafkZ9s2pdQ11GVIdIKAQ4WQhGsAqh9B/eyrgRGR8XihDHUwOZ5BQXMgz/XmO1Su1QF9IgS2/5J7+k/Grw8lURFSNnWnHCfZAYAjg0q7cqELoaDvPoTeJtbyrtGAFoCQKjsUFrH8NalO5N2QfBrHNyJrfFNTza26n+u0dfAeEUjkFLLsxGhoL+NOxZAjmRmkzGMVgW+V2MqNELFbdKGe2VNgLLkeNj0fYft4va8+oXeORWN4kdpemwBS8xtHv9s/P9xHBpMSwpJvca9xH0TU7Jl2wu7vprGhciFnjLoftjySyyM3JSFxbyR3ffjLI1TBlMOUmsifCbOj0yj6C3sJtihc7ilXmbcH6Dq/18b1xGkgZmO1n4+jVImWhIJR44FjOaE4ZWOexxDqL1YylnOZo5kwTMnPdJEeJhpy/NPioWZz6byO/ZotqghQ1GXjCRqV7fEZ7pS590CpuYi1mDewlsiTyCWh+EWpb2+yOGtFQUQ/YzoShpEaNUXB8qeg5hHC8CtqJ/dPuscnUr5HTsg5gBuNY1M8i3AXKsP01cDWcwwynHujbdEEKf/qosdFC7CLCOmLnu9+aUzWOoOy39WiWwiwXWd91ma4FedB1zoyXZxaICcXWpX9oBFudPQ79AvhCTaUF8T+tj2I6c0Ogn+5rPPJ3sCmfnsLTkCHG7uNbzekKOpi
 RkWR0ruv
 ATCqgyAkVFS3lGpFLSXFamAD5Sv/Ggp8xs6/6l4lGd74nzhHBTzLcdk4/QHDL6uN6HBoqKWtN2wjlY/BtxBKG/bCVI2A+RR7yy4DYuAo1iQzoqsQlwHzkZ5r21j9v6oEUc56jW3fzdDulHeeZZEI9u7iA9P3YKKpTTUaDzSAoK7rOrJlsGYnYGXHplNIe+WtD36Zy/R8lw/X/GHaoPuFcOttfOuoned0q8jJgT9HWW3ayGRv+ZAlpbaJucWYI5vAoyLHQdLv6BUdkUeiCGFKS4NuqBFihnCnNrXpYr66gZx5NoEXXTIKcpEodTdzg2zQxEkRp+p1Y7uZvei2dmyyqT2Wr/5hMjaloimzD4X2yrii9+udgZFsHU/XH+vsq6+py0iwn07eOHF7tB+sBrq6qm1lNJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.088353, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/30/25 07:56, Lorenzo Stoakes wrote:
> This seems fine, but I can see a whole bunch of others like:
> 
> kcore_callback()
> mm_compute_batch_notifier()
> page_ext_callback()
> reserve_mem_notiifer()
> etc.
> 
> So I think worth chasing all of these down?
> 

Yeah, I figured there were other cases and was originally planning to
include them in the patch series. The problem is they are notifier
callbacks and changing the type from unsingned long to enum
memory_block_state would break compatibility with the type notifier_fn_t
found in include/linux/notifier.h:

typedef	int (*notifier_fn_t)(struct notifier_block *nb,
			unsigned long action, void *data);

So I think it's not worth the trouble for now.

>
> Some of the switches which don't cover all cases will need to be adjusted to
> insert a no-op default:
> 

Good point.

>> -extern int memory_notify(unsigned long val, void *v);
>> +extern int memory_notify(enum memory_block_state state, void *v);
> 
> No reason you'd know, but we have a pattern of removing extraneous extern's like
> this when we otherwise change a line.
> 

Oh, that's good to know, I'll update it and keep that in mind for my
next patches.

