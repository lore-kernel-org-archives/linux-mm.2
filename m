Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D290CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4A466B00A0; Mon, 25 May 2026 11:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFAE06B00A2; Mon, 25 May 2026 11:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11196B00A3; Mon, 25 May 2026 11:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B02B46B00A0
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:03:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A6DF89324
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:03:47 +0000 (UTC)
X-FDA: 84806261694.01.E4DF206
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 97BF41C0014
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:03:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jTveyExv;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779721425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oG2htbyr2bmaHj2ORzyR7CVTQQkB7de80vpx4poZg64=;
	b=JTKlqqblqKSytxCy1uRiRRC+HHKEiy7AWm2YRvuus70n054XxdGhNB/dXTeZHd9cOgXHD9
	ROXyyPKO7UsV974nQSQkPtMDFJ1cWAeAPJaWfeYKGGJw+mndQsQ8nuSRB8pyUpFbXSelcA
	eiCYjCob+ojmJwpLoBi5n1zibNfxOnA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jTveyExv;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779721425; a=rsa-sha256;
	cv=none;
	b=1MrSE/g+21vXqQMBt5a6i+pv+HMFshHoJev41eT1hUQxtho4Q1bAl7ELI/6RgyvIQJo+mk
	8VPkbBmeTxurzvD8jaiCDrYxhWYp5zIzW7Fd+xrgXxKkkzGBBm4t1xEYJXGXIxTrTjCxIp
	uQ1N43bQAJGPVP73smnXR6zj51Ez3SQ=
Message-ID: <094015d8-00d7-4f8c-bebf-593ff76b5e4d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779721423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oG2htbyr2bmaHj2ORzyR7CVTQQkB7de80vpx4poZg64=;
	b=jTveyExvhUic+GTcPDHxJN57hAlSx7wUUIeHKYMlP5MmKyBYsaGj8aWkM3VDAbDDEid2Jv
	Xv1hIW0NWuulEKDVlWEXa7DfzZNPFSEPSZFEQj+D5pMkdh4j4Ii+2GQR9grJ8YEczKNCl6
	UcVY04GOOe17fefYJtpQp16fLfGk5nM=
Date: Mon, 25 May 2026 16:03:40 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] mm: make mmap_miss accounting symmetric for VM_SEQ_READ
To: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org, david@kernel.org
Cc: hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20260525145751.2671248-1-usama.arif@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260525145751.2671248-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 97BF41C0014
X-Stat-Signature: p7ozbuws6jmbjjw5j3c3uq8xwwobocra
X-HE-Tag: 1779721425-8593
X-HE-Meta: U2FsdGVkX19L/8Kc+97BFmrhpBqF1i0lavOLYUenL16WyKTcIOVmr3Sw2/DqxknvD03p3dWh47Tfj54UmKejvp4r++ijgMBnXEEn7SalbZlLCwhHWw5hSPoQ3M5AJPBg86lSYgoi6AI2R32VJ+vX8mp1m37jP9jnJMdeHMYwx7dvbQOULTcC9ZUvkErlQq9/fchWyXfhwBmLp4pwKtenD6i1+VCi/UfKrLHG+AT4RtCknWeTaBlACDPwIPhQ9zZsgzcs4lvQCpaT2xQ4iVG3+6szAnN80oSWDCynrRiOYpbw3WM8W79W2nPQQK3YeBczpHrTydNbILRM9kTEwVXY2WmF9jzlb9a0LJTusuBxNJ3+5ZQcoKR4MJ7gqi8dxdxqb/lH0QPUVpSp+d/Ke17H/eUDZWij1whiEoyFpdZCoKcyZwH0xSgp1LRL796Z8m7RszElI4LWPB4y8JGnl61CKJcC+oVzfEFeCL+ACqqAUa4s7CUqPKmB1yXVSiprlzsIL1k9eitM8JXa5mQFzjzc9fT5pT4M/CHC3LMoQtpDXnzlKzWRqJdCF+FR1MMS29BlSFwcCbgzBie/bmIaNHEFqyIS/xMLqmlQlx37ENEXur9vVGeSINWZO5cJk2YnN4i/BmFhUuV0ZmJ+rzx/CG3IJywewT+wI0KAe6fM7eTMKviinPC6i+eno+uDGwHpwhpHCfyfgAxAeOBPqhiy7ddnPCeRwlu+dyqVFAs/Tih3fdR/XJHETvoXgs3r6Vt56Iwxb8MMbrn3pLHDFIImWsg0AvO2lQoTSurnY4KRMnhaPEr5aI7I7TeCg6s3Rce+SWBlQdYKRj7V/y5tMzCQLvqKgBhGNypMqVTRg8TPLagiplBdTDEQd2w0naNaKkUpz+RHIaeEerd68qbJfq3pO+SX04yHmWDq84uwvkRajdZHXEbF+g0ALW7ZVS9ccz4r6Y5jlRjKN/a/FUfTBAMd9ew
 hEnKXSFC
 CN6lObZqNsCWSGk1N1REzigFE/AS5eVFmTieelY0XLar+qil8Q6YMoPW81re800tg79bJ3S/sXm6Ya86NMCz4yIkevV9SAcf7o5RLfcqUxC3ajJ6vdJT5ZXQyImSeYHybs7B1vSaBWgFVNHRxrnhUlf5iCiWMNw+WytCNhyD6i+vBa1Z4VBzRaiI/mlGc2Rz7G/zJ/UhTvfoQ+0yATJQYmTXj6ZkC9vZArsPPEYlzP4bnsrjN9Bs6nA5n6jVa7gY0cfFw9hqcd+KLFcYPxb7ZlakZOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/05/2026 15:57, Usama Arif wrote:
> do_sync_mmap_readahead() skips both the mmap_miss increment and the
> MMAP_LOTSAMISS check for VM_SEQ_READ mappings, since sequential access
> is non-speculative and should always read ahead. The two decrement
> sites in do_async_mmap_readahead() and filemap_map_pages() do not
> mirror this skip, so concurrent faults on a VM_SEQ_READ mapping can
> still drive ra->mmap_miss down to zero through the decrement paths
> even though nothing in the sync path ever increments it. The counter
> itself is per-file (file->f_ra.mmap_miss), so it can be moved by any
> VMA mapping the file, not just the one currently faulting.
> 
> Skip the decrement for VM_SEQ_READ in both decrement sites so the
> counter only moves for mappings that also participate in the
> increment side. No functional change for VM_SEQ_READ users, since the
> increment-side gate already prevents the counter from being consulted
> on their behalf, but it stops a VM_SEQ_READ mapping from biasing the
> counter for other mappings of the same file.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>


The patch is a result of review from sashiko on another one of my patches:
https://lore.kernel.org/all/8edc8cd0-f65c-4456-9b3f-362e744c9a96@linux.dev/

