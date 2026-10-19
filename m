Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 037FACCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 09:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCDFD6B00CE; Mon, 19 Oct 2026 05:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5B36B018B; Mon, 19 Oct 2026 05:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABBA36B018C; Mon, 19 Oct 2026 05:41:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A83C6B00CE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:41:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75F8FC0654
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:41:00 +0000 (UTC)
X-FDA: 85338881880.12.2FD1104
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B908A40002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:40:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZGgPxyKl;
	spf=pass (imf04.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792402858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojxx9nhEWkvJwn8p5+rm0APJk+Pi1n3Ff8wZwW56tgI=;
	b=un/3NchWFmioqNzLEbkA6BlmrHLv+zgTSmQg7qG+1z5sVi6mGUeGKKuWRPMJDXBAiv/gIH
	aaPWIPk7gEaxXoNzW7sm+Kc386BfyObhR5+1o+RwelmiYypmdMDAULPQJ9mz5tbxSIeol2
	F86IbQvHM/q8DL3uXDSfzDJOhbVFmxg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792402858;
	b=xaulyi1QeY4/mpvuY/Lt6eOa0zyuollW6LUPSQHvD/XdnzYmTTr5jJiqmo3wpkrTvn6D3O
	oG9EZYeMLCxB8qtIlIOHdopW9Xw+Jum6GGGqltRugksy6IXbVMN0H+unUk1x9T3KcoKtjP
	NIdZmtG5h4Is81qm4rqclhdFDIMZERE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZGgPxyKl;
	spf=pass (imf04.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1397B60DB8;
	Mon, 19 Oct 2026 09:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAC21F000C6;
	Mon, 19 Oct 2026 09:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792402857;
	bh=ojxx9nhEWkvJwn8p5+rm0APJk+Pi1n3Ff8wZwW56tgI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZGgPxyKlRG+mE/fXMg+GJXOOj3xNX3FhdnCOtWScVuFDNJHzvJ39Im+zQUmNTrn8k
	 lL0xKXJSnHvIEid2ZabhUrfq4d9YTjPvrxpfXjyFYU/U3pCOd3mcpID64FfAvHXFEj
	 pFotsfkMJ+c5Ze9/xuIT+6UI8D/Cr8oGRUEOuUF/Xl34/aLrqPfYcfTBNh5k5qyZ4z
	 R4/xWj7OvyQkjBY6dsixCZLxQSw4ESPbCW7F9z3SxvIdaOW2Ae0jR59XjNv6VX52NI
	 VGT2ZYxlS5wJrOyL3xwYqqOJlMs6EOquIzWTmHE6rdXbTnYwiWKpmkICmD9yvmxfpx
	 WbKc2YEbQO6Sw==
Message-ID: <2546936e-1ae6-494f-a3e8-1949436bfd3a@kernel.org>
Date: Mon, 19 Oct 2026 11:40:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mempool: optimize mempool resizing
To: Vitaly Wool <vitaly.wool@konsulko.se>, Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>,
 David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
 Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, vitaly.vul@partner.samsung.com
References: <20261014130301.GC15407@lst.de>
 <20261017090802.1423681-1-vitaly.wool@konsulko.se>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261017090802.1423681-1-vitaly.wool@konsulko.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B908A40002
X-Stat-Signature: ogoid35zsm1uw9ay6odiyzz43yan81kf
X-Rspamd-Server: rspam05
X-HE-Tag: 1792402858-499571
X-HE-Meta: U2FsdGVkX1/msi+x+5/7t5O4I1o0DWONABGKAuelZeayETJWNsl1l8z+bcoAzh7p1rJenfSRjVnTdu9ab2D15Y8HZjWaC/QhOMFCSUJMMb9d7AmLj8qXNp90cxGDUegu7VTxXNX30J4/4lbNxPqMpHbksGvNfJS60onrCCU9HaiNwTG6yqn/O9tuK7au2puKmJnUW/WSXCOayzS4XNSvmhlt2wW0eUx1iYh20/LzgD5Gv96K0YPsm7/qOJK1CL47EuhAf8Cjzp4sop+3MnXmDqwAvaDMHoFkByUngaovH+hlHAiMr6M7EybW8YfQLfO0aTk6U7tbLHBs1lFpIfT+m/t+CldLd/3kIACl/HJK8ZN0CShpqeVATW2l7dhFiM6cZ+HcynL5nrKGplK+TR+l7TPyRidod2ZYq2jcWGkTZQbPwA9NOTnVwoaqmKutyBub+ps0dLJgaRzB8Jb2vbu5efnecaWd9yZhGLoQpIHIP35p11pqke7E/lU4RK4hTbG6zceLImIcCSkMfXSaIkdLILhEz3SqTEVvhcT/TqW7iPf1j8+Gn6Wv3gPK8xML0Ih7f/NBi5vBvbK1tEpYtzvrY5xjtkkowj4H+yI4l8CNVEzLoipZwp78garubgltUvUzGuXUldfcwJGFtF49E20kwnJmzlPE3PFEjkb4VFCfCb03D/GWmKLMyZu0Oghp+J8PSGmsS0ucMcRR26DKGaymJ7K39VKqu059vKFd0oOEayv8PZPrwq4E2vgv34z3a7Lyff+eVCv8/exwIGA+kG8t2O9qwO1et/OxTF0qv9+dblokI65CMhUQzAmuHnGliWpqgfTV6+olNFvOIeaG1DpY0IX+VqT6GM6FOO4Zk7LurYSOucX+atY0KraG3DrsShN0QzknnkfekrBOZtCUHfNSm7tcpjyL7gK+TIHszvwaOZYrOtOzORorZU25khS8mvuD6gCFLjpPuKp2oMTdWOD
 IP5o4jci
 QuzxS2WWL7L05qZiP1v1d5F5cu3ZiicEZRX4Ka+xt4lOFLfS56bMgqdCxzpj/kqWXXABJlha/DMtdNv+Y0v00p+dcbff8iROTBj2Vck1VAAHK3GkI0RVmFr0UXE92qWewfwmfsLcNqmHg5+NBVQdg+QmLj67hb/HYp4RtTKmsrb32JESZ4V41TCFfqQtLlby/jfVmKc018cRaOF9HTb6TLLdMQ/Oi47B2b+oZsibJ8GkN3PmklwRoarCzmtDtsz7V84qDzZq7izy7DVIZSbi5F6o5TRTtwHpfUmZRJWqKnWDbk3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/10/17 11:08, Vitaly Wool wrote:
>>> Imagine you have a mempool with 10000 elements, and you have to reduce it to 3000. Then
>>> if you at some point want to go back to 10000, you'll end up reallocating the elements
> 
>> Who is "we" and where is the code?  This is a highly unusual, not to
>> say most like broken usage of mempools.  If you need changes to support
>> such a use case you should include a link to the intree user (or bundle
>> it with the submission of the new code).
> 
> This situation may well happen in the block layer (zoned). The numbers will
> be different but they were arbitrarily chosen in the example above anyway.

The block layer zoned code does not use gigantic buffers from a mempool. The
mempool is only used for small zone write plugs descriptors and if the user goes
over the device advertized max open limit, using lots of plugs, the device perf
will start going to /dev/null. So optimizing for growing the mempool for this
case is really not a priority/needed, at all.


-- 
Damien Le Moal
Western Digital Research

