Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFDFCD68BE6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 342916B0098; Thu, 18 Dec 2025 02:22:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32CBF6B0099; Thu, 18 Dec 2025 02:22:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264936B009B; Thu, 18 Dec 2025 02:22:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 182976B0098
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:22:47 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8E8D60F8B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:22:46 +0000 (UTC)
X-FDA: 84231749532.14.D1D1C13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 45CD11C0002
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:22:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IiFtzWuM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766042565; a=rsa-sha256;
	cv=none;
	b=txy9+b+lxORCT9fbVJD6O5fAqfuOhQ/BU0c2BQBufeJoi9969UBXrM3vui5d5ahMclLXLu
	FhVcBwCEgaa+0pgFKDYp3PlXwzZIoQ91GkQ4b8yH4xyB5yHA9f5L9lyvPbwxWEsIafwjdD
	5MtZE5N2FXblK3OBusLHrXOVu6ysJ0w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IiFtzWuM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766042565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06ivp1LsyfF/ybmuoASAsgqyQnssE8ZkhtWZFsUHRDo=;
	b=ADy4/ic3y0HpV1WmcDcnRa97CfPP34j8j14eA1Sw/L8rQXeZeei41uQSrIoSxngFOug9ux
	QDvoTev6vnHDQhDTwR7bo5gbdma+Bj+PsmqWo/khjqE380+b4b8mFYWFR7wor/ct8Z7Gzc
	f5pl0byPQV5EmYmSgsPryjnZHcOn5T8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0B3744331;
	Thu, 18 Dec 2025 07:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF704C4CEFB;
	Thu, 18 Dec 2025 07:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766042563;
	bh=v8cAalRQn43JyXFhRWos5ZPdRsZtNdz6rnazo+rNvyE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IiFtzWuMvKFyQXgkjfnEsQWHGnpImypXXT+oPLEYQCLJn/YvQN+eI2Et9GNHnUhN+
	 i+gH/qKbSbixNoOHsW9F5Blvg01u7KKsvOyMcGXMzwRFqll2KtwgTGESGuzyZ0Do7M
	 wMjhcvVZYs9r0oLSt1MBDGJNHqzosSrkpCPqxi3hbL/QZ3WR73t4Git79o6y4o9Wac
	 3PzQS3ZWVuE/xF/nOchsxWXkJoPKH5QO/MC6JACnRIVKMk+PKgfgSj8YomHVYkPvW5
	 UyBHYf5hV7J5ZeaXVCAQp/+cSoZ51yDkubbrrIn0jKf44Bfp3CTBIZzlhRzMFEZ60B
	 2hCYXKZYq2Iog==
Message-ID: <ecf02bf0-a107-4e84-93f0-48277fd4ba7c@kernel.org>
Date: Thu, 18 Dec 2025 08:22:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 6/8] x86/clear_page: Introduce clear_pages()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-7-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251215204922.475324-7-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 45CD11C0002
X-Stat-Signature: fx9adu5rqtqa8r3hd8xarqh4yy6zeq73
X-Rspam-User: 
X-HE-Tag: 1766042565-576972
X-HE-Meta: U2FsdGVkX1/9S2/ThM1o5B+j1ZkySXFSeM9/YqBLVmcioqOH0b3iLLxhAqRFFGfukZMUzQpByHQn2J98RFe8UEMxl1u29MPoZM1aanpsNaVQ00dAbx3JiT+FiIQtmB/jojSEuWHA/PTKQDE4hhUCCGQRFg39or0R01f6kAe0U2NTpqDPcvV0eWRepelpClyMIg/On58alKu5oxGGw0AvyCFI1eqSUvQPKz87ZLiZz5aQGai2wmSl7QiN79p4aJNgSu78vCjMXtlPNt+Ma+OMWzH2XyjbcHd2vYubeC6ixrvWJJPxKnROhHt/vGzcuRjx6SyMkfihx1X98H3wo/EKIkcStigVdE1rYczzOp251Q9iagEFh161m1NiWFckwW64a4ufKZ3Njw255HP8L5VvB2yJ5vbNjWP/PAcgxrAz9nrJ59gM0qQ1XscKz+dsL75Vl+i+X6KfDnm7sl4ZTpNR2cXCxW782mLfznCbJVIpqR9oEZ3dxJIoPhiiS0YKBOQAqeQfy4D8qZSuIfZdus3yFlJagEC+SrRduSKJAYwAs+sK1iYxbVyfEX+NjurxyfGGA/93nn9qt4QGGmcXSEGxBvHXIAtAvWlfXrmhntjMSUIox+xsEkouoo4m13cekUcGOQiD3WcuyZsPa/f2Ty+LxOCfoxaEz7mTEzLg1lF1qaBnYz+Kr+h9pcShpwttSfiGrVHMbQIigQKR45+b2MsJHTDktVFJE8+QCsrpIu1dy3x0votzPFurKKRLizisfPaFMprGFgxFuypN+Mv0gzrptfdeQCkSJ0ZwscIQ86+vVh3BV952Wyl/HSVkEshTDKBdotsUDQ+c6VF8+sdhJG1SCdTi91t9O50zjPykq3gEl9bLht7ng4EjxyhPCyPjYM1rFk2xI7KiCddEQ5cJ80HpGwxhFiqgTkzZjuZennwfnSioSrjuditdcH59RYHrJys1l30Om3TKRQfJvJD3crH
 Oy63hKO/
 tB3ej2V6Bt9GlhlA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 21:49, Ankur Arora wrote:
> Performance when clearing with string instructions (x86-64-stosq and
> similar) can vary significantly based on the chunk-size used.
> 
>    $ perf bench mem memset -k 4KB -s 4GB -f x86-64-stosq
>    # Running 'mem/memset' benchmark:
>    # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
>    # Copying 4GB bytes ...
> 
>        13.748208 GB/sec
> 
>    $ perf bench mem memset -k 2MB -s 4GB -f x86-64-stosq
>    # Running 'mem/memset' benchmark:
>    # function 'x86-64-stosq' (movsq-based memset() in
>    # arch/x86/lib/memset_64.S)
>    # Copying 4GB bytes ...
> 
>        15.067900 GB/sec
> 
>    $ perf bench mem memset -k 1GB -s 4GB -f x86-64-stosq
>    # Running 'mem/memset' benchmark:
>    # function 'x86-64-stosq' (movsq-based memset() in arch/x86/lib/memset_64.S)
>    # Copying 4GB bytes ...
> 
>        38.104311 GB/sec
> 
> (Both on AMD Milan.)
> 
> With a change in chunk-size from 4KB to 1GB, we see the performance go
> from 13.7 GB/sec to 38.1 GB/sec. For the chunk-size of 2MB the change isn't
> quite as drastic but it is worth adding a clear_page() variant that can
> handle contiguous page-extents.
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> Tested-by: Raghavendra K T <raghavendra.kt@amd.com>

Nothing jumped at me.

Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

