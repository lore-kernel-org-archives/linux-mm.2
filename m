Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18890C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 03:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713AF6B00CA; Wed, 21 Jan 2026 22:54:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB396B00CB; Wed, 21 Jan 2026 22:54:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6212C6B00CC; Wed, 21 Jan 2026 22:54:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6AC6B00CA
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:54:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD54F5FAE0
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:54:38 +0000 (UTC)
X-FDA: 84358233036.05.7B3A62B
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2E602A000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:54:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q9wgSQgA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769054077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vw444WMHV1aHVgp9YPBVa4B3NTBF6Yg7X7f7oG/aDTQ=;
	b=2ZyZg8i6XSu65gB3Oe/ilzNpncWjabYLaxp3QvA1xktcMeroalTdir0Gw32cC/GydHdDyO
	wROBQgMw0PjYhKZjncqDQ77rA8zaOq/tnBELYoc6QNOFhzhtw4/p3gour6sweSgEx8LHTm
	EbGyC7rG2gZ4Z4PUkFWbtwJGxMVGhW0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769054077; a=rsa-sha256;
	cv=none;
	b=To3xIxZAG9eJPmmcPIB1iE5fY4hgLfmNfvZPjjVY4gd+kD/DnUbNh4ay1SUnUe1mYqGhpA
	rFRuOaUVYLW/VB8Xf/s8FScZdHfJSyweVMBtMceGhrtisqC270RQMffS/mUkITKf3KGajc
	U5TJD88Z4lhmFb502+Cd62pxoPEfiTE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q9wgSQgA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev
Date: Thu, 22 Jan 2026 11:54:24 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769054074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vw444WMHV1aHVgp9YPBVa4B3NTBF6Yg7X7f7oG/aDTQ=;
	b=Q9wgSQgAUaAxbYPOPHC/7e626j5x0IAyk83MJrhyfQBagKBGM1/HedPrIHJ4/5P9RFaM/p
	cYa8LFP72WuoDnZ+ZxZXDiSBXmqrpYKnQ62Xpj/EkRhWr+pKC2F6qY96wvKvOwg6Zl6urx
	TDBrlYggwJZMqqLUE7u4pUwlXUg/91I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 18/21] slab: update overview comments
Message-ID: <ki4y2wnhznq5s25hic2j25ohgxzjae3y7pkjjjkle75hp34e25@juljp5mukkfz>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-18-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-18-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2E602A000B
X-Stat-Signature: 3ju7nbgn6akx66mojz4ono9dfh8m8a8u
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769054076-449385
X-HE-Meta: U2FsdGVkX1/5cDGxYj+E6a4A/IYv7rif5ELyl4bqmUMZkdZ2+KrQaS4LZmHsF6kF2b1VQ18/eFl1RO9RCFYKr0X24HZgVGwrt+e6lgDUx9wD9SlE9syOS7ZkSwIqL1mIo2Vlwsct4ozWi2+l3lBqHiv/WKyLMXK7qVyBLHALeCY7/8z8wGfvYjqK4xyQNrFYX/ysdH5sVACQrWUIy2mB9Tf/+VwC232Sg2gwqDTn9K4ideWUc5cB9fw0RPfRY2/FghhLFYOAG+jibONwMqiDEsIp8H+OJBG1wfYjsDAeVGL17t3T+aPFmziiNSVZmsQR03nqAYmOAB2ZDcBD5NDfB/N8ieIo1qQLdv6u9A8cTpjWS7+m8xUKLdLpFXAb13xHem33Ry1RJFEEqEd904UkvkpUie/YmpjAdN075ASCrKMYYFNHbc0t0e1Qf4xESlBdySI8BNzIV4ZWbB/BfkiFVcRhuvqXzzkM6Q219kqDGYuAhWIpv7XLqCItcqK3CuOfAa6Tu4gj5Lsh4liaUJmfV+thkhgaYQ7N3r+sGXmAXZ+54muCOMs56gjIOP8cPOi3iEHOytRJumgPjdfmWr52LpdYqxcm6kugtNKgEMXSEIg6TetjFstk6ytw+d07lW58tiMKwVLmy1hCRufEpRUPLpyXTeYSWOs0NPdwjwps1MvaiBEIgT/LOOAV9GsVs/1pENGAqTLnjRIC4XoJQXweTwIz0utSvcmxmjToIwQ8l1VrKhXns9bgAOTlOZHkq7JVV8a1tQiTBUUyU1DhtymfWJwCHFezfPtYjY8g/oY2bYEWnCXUiEU2cFt3ruZ4HbTnW69p6evhzBCHlgGk+eV0gVAVMBQqmfMxrQcrpJJ7J+UUFCR2LcDa5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:38PM +0100, Vlastimil Babka wrote:
> The changes related to sheaves made the description of locking and other
> details outdated. Update it to reflect current state.
> 
> Also add a new copyright line due to major changes.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 141 +++++++++++++++++++++++++++++---------------------------------
>  1 file changed, 67 insertions(+), 74 deletions(-)
> 

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

