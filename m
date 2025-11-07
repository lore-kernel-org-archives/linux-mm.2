Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F534CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 03:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 547DF8E0012; Thu,  6 Nov 2025 22:30:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51FBB8E0002; Thu,  6 Nov 2025 22:30:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436288E0012; Thu,  6 Nov 2025 22:30:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3138C8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 22:30:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD3854AA6D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:30:43 +0000 (UTC)
X-FDA: 84082383966.04.131D7C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 379B3C000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:30:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dmx93Mm8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762486242; a=rsa-sha256;
	cv=none;
	b=AbRzKYK4DB3G49BwvZ8QCu0TIjBYaLZRQ41EESDsjFklkzuy3cYuOSM8UfK9Ku21s7ujYs
	y3kGfNe3MkwYUtVn/y27ufrv3wMzVk9rE5+lv10reDTO9WcMpLDjF5HEmA05jQUKNIy7TD
	GNMtdZo3OvvYsNraVm/eRbGJMvCW5BQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dmx93Mm8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762486242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nXNMn/2HwuSsaQdDRLZ63wMahNVoxSZ+qM/8WePp4Q=;
	b=G3JpWDfi3hlmrQppaNCo+CQ3bhw6mh7TKsGREHT24MkzPLKi0n/ymTEt1c+pksOgUB5fv9
	C4cVDdd2VnRyNe3FK1IZMeBRG69zvO8P2NLduxGq3uzFmL34bnoWL4Xo3VjKe+raCQfnqE
	/sAh++avPyyE4UBs9yHCzsZVoAP/0fY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A225601A7;
	Fri,  7 Nov 2025 03:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09E9C4CEF7;
	Fri,  7 Nov 2025 03:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762486241;
	bh=zK6jf9HHfZm7vm9mP8L9SdDIGPKOC1ipjKdiWKVH24U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dmx93Mm8sPB2G+whQZKs6CQHv8uOVVzQjnxcJ3abtl+hKc1VTMCuczlTNSgu3cAlq
	 IllRT54BTxToeD/15INBQxbSMEIhFN276EbRqTtb0RAjvPsxLllAVPOHnAGO2mJwGj
	 qJ4cP8XslbcUN/IkiiLS8TEGKhkO0C4T1JwLKPlNDFNzmuWCyMKF6Q6kj5VsnB+yVW
	 UA9Kg0ePw+ctcbpnodSL+xh/lN5cQ+c3wrQET58OKHwfe03rAsYS15uaYtGz/WeQvq
	 xgqQl8+VWLRjmo5ELv4p7nE81hd28CHkpOnVswAYSFicMxMrrx2PA+62nBferFcKnK
	 TIyioAuJNizEQ==
Date: Thu, 6 Nov 2025 19:29:00 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/9] mempool: add error injection support
Message-ID: <20251107032900.GB16450@sol>
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031093517.1603379-3-hch@lst.de>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 379B3C000D
X-Stat-Signature: 71359ciqoechd4ca8ossk87gz4h4sxmy
X-HE-Tag: 1762486242-766862
X-HE-Meta: U2FsdGVkX1+kT6YIuxOyeiA7MiqmKikWZ8jA+yVu2edftcykNyhMsy+g/nJ8ukXDW5jc8ZgDr5Su5+nNjOiu3DWjnCyvI+PsnA6dwkOCnLLnoqxvfjYmlZSSo8BpgdbYJhNg8pOep9NalqrND1X48PTBmSkZHMXEFCXIl07kObKeWEoysn8VIR4/h/QagoJV0hxlgVnsUkfB7g8H5uG83wfmUyD8otUsz+Z0h1HMR4qkmHYnakgaku5DqOomQ/NhfbeUwa1FbQfXgv4omfngti0TsDZl8NM/xgZ4nbnuMecf9oLrlAIODWkq39blwUzua6ezpUruMEa4shUcWl7IOiiHpOPjrYu2KInXbOACu0w7AhQdzQZmbuhji+2vsKQvh8C3eWNrEjy01QMvc/BnudsvGvjyv/ZSIqOs0Y1Rjzm6dvuG0zcXuT4GUtCfhuKvS7mUzt1ps/vWiR6F52M2v5isLNTH6qtfYa0nMaW2UqiqPBBlDfikM+M7nYAg5WEA4BMSyKZERom2bNvde+YFEcuLZ0oy9PUAJqSgx3amNHsXHtY5HTY1XMc1c0ro4vAkSr/TwiazGY0w/9lCwk8rgJe25tdCz8xh2oB3h83W9i/XI0PwCg7nSQN0fZbVRDYLeNtiQIiyFcR5iHPBi/vyrF7pBP6+1bgPDfvwh9cLSdMqMw30C8IM78s35+bAhbxSVSsh5LM2kbtcnEEQFK9Xl3xrYmYh9k45vpoH/V51iTQuF56fE2pRZav6e2NpSpyEwtu4xx6LDLfdkgfxe55hUkt+pPiXgrKp6rdSAvdyjsMs4qExCFgypXxxo1QM185Yym9DkewXi7z8f2lJDu4i8f2FpYmHrfFrUPaLbURFtd2HfjwB4Av4q4fnshzU4kzcPwAN7/+bx6+ahsdgtUmvtSjuHw7qMntiUjII2DzXy5j0Ke4vpRTeprB/Vpbezu8Z9YxV+pqghMOuf106dsF
 56yQ+M9J
 hipB1RoXKzT4REohMA/27lhS+IcWmPFktCkAC0etmF6pDXMoxj8iHULY4Jim4l6N0OoWVjniXrmUmePBBrViBiI/MvgoxZyHgaq85JXV7E+9oEwZ0VtxT7pA+ivW27s24NA/HQoK3WCTiYZUWOL53wvrw+orXw/PTtU7jBpDKAgfGYFtGsfOPKB0rE8ppLeLKytTfqJAQL8lcHWJhO49pb4YsoKjiXsvURzXS61KQxlZupHCs/dJtChOKGQwP9+Ff68cD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 10:34:32AM +0100, Christoph Hellwig wrote:
> Add a call to should_fail_ex that forces mempool to actually allocate
> from the pool to stress the mempool implementation when enabled through
> debugfs.  By default should_fail{,_ex} prints a very verbose stack trace
> that clutters the kernel log, slows down execution and triggers the
> kernel bug detection in xfstests.  Pass FAULT_NOWARN and print a
> single-line message notating the caller instead so that full tests
> can be run with fault injection.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/mempool.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index d7c55a98c2be..15581179c8b9 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -9,7 +9,7 @@
>   *  started by Ingo Molnar, Copyright (C) 2001
>   *  debugging by David Rientjes, Copyright (C) 2015
>   */
> -
> +#include <linux/fault-inject.h>
>  #include <linux/mm.h>
>  #include <linux/slab.h>
>  #include <linux/highmem.h>
> @@ -20,6 +20,15 @@
>  #include <linux/writeback.h>
>  #include "slab.h"
>  
> +static DECLARE_FAULT_ATTR(fail_mempool_alloc);
> +
> +static int __init mempool_faul_inject_init(void)
> +{
> +	return PTR_ERR_OR_ZERO(fault_create_debugfs_attr("fail_mempool_alloc",
> +			NULL, &fail_mempool_alloc));
> +}
> +late_initcall(mempool_faul_inject_init);

Initcalls usually go at the bottom of the file.

> +	if (should_fail_ex(&fail_mempool_alloc, 1, FAULT_NOWARN)) {

This doesn't build when CONFIG_FAULT_INJECTION=n.

- Eric

