Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13956D2E014
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA196B0026; Fri,  5 Dec 2025 02:22:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281616B002C; Fri,  5 Dec 2025 02:22:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE986B00B2; Fri,  5 Dec 2025 02:22:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 09A6C6B0026
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:22:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C63631604D7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:22:24 +0000 (UTC)
X-FDA: 84184574208.13.340967F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0994A4000B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:22:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HkvugYho;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JeAqTruV4OcLHk9vYHk8b3GMN2NaWtdV8V0PLUmnxFU=;
	b=6E+sxRnl0C83Ptgm7isZOvufcI9i6Q6afDTyTD17Ian+uggKqHfv6RoAgo74XNSXR9x4ki
	oF8qFu2gOZvO43WJh7/etdLS1XSt7KIjueq61hToKV/Ar1vSHfqnZEloBjs1ntMWQqFL6g
	DhkfhNnrUGs8RNd/T/SzfDEFVwyY/gA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919343; a=rsa-sha256;
	cv=none;
	b=cYDgwRRPxyBhgATMhYMo9S71HzyPZfzvfy90jmcZR3lMQ0ip4HWCxhf4oKSnWFcLFCg2zR
	GVXRygt/TWFN0pRuC/GPEns/nJ2Ii7Ulcovd8IUjvhYfD94IIbFUdx40USeD2IkTGrvZUw
	hp3IGyBbgAR4iij6PKqDOdeLJAje9w4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HkvugYho;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF00F41AFA;
	Fri,  5 Dec 2025 07:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D85BC2BCC6;
	Fri,  5 Dec 2025 07:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764919341;
	bh=eRQIudDpx1y4giwhG541g90Y9MfghdnwOzskcuvD0KY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HkvugYho0F9aIgpM0DRaEYlHie7SSEw+79avEpD0RTFvB8wX6iflW3MbDosHFDCgD
	 Pxb20SU2AQZ3XUPZA8eSb3n/RFULJglQpeHGZUNAsOdq1Ehys0jxAluu7lbow30Vgk
	 m27JnfimiwCqW7MdThES7VbmG3qxIpJ8AvC7i+g/KyK4uLE5QOgHEXQE0u/L8N2UW5
	 ACIVy5qmpWeRS+A4RYBALqV4vXvgRG3UZTlKtmOvTAIcYhkNqYOOCB4kbYE3Y29gmb
	 rA39pQAtCP6r6jR2DkpjvPxBH5tMdakSrY6M2o/8Y0rUUEEi36k3KEy8mUCDF5H6j+
	 eYifPJcMLtWVg==
Message-ID: <d651e943-99f5-431e-a67d-e4e6784e720e@kernel.org>
Date: Fri, 5 Dec 2025 08:22:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] lib: xarray: free unused spare node in
 xas_create_range()
To: Shardul Bankar <shardul.b@mpiricsoftware.com>, willy@infradead.org,
 akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 dev.jain@arm.com, shardulsb08@gmail.com, janak@mpiricsoftware.com
References: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0994A4000B
X-Stat-Signature: yy5ep6panao1bg69x471uzxe44xxkqr6
X-HE-Tag: 1764919342-157374
X-HE-Meta: U2FsdGVkX1+pWM3k8VruJnR7bOAZsTOSCnakNNhTCyPdWj0hLoByD+aUjxbCANVbRVXH6kuLXYAGmcGPz6kdZPQ7XsywRi5FtrvqiNvwfEWkG9wRYbJ1SW/4x9O2Iwv5JeTQ/idMKRP1W66XW1S45Ummfk1Bdv/jM2QwhvAlemLgHv+vP6lG+NQaAd49f4paVta7O7o03Z3ReDLes7C/IKJyfOUklOjdOl5uX/L0/PoqncbhxTvF9wwzCXJ8lxntt5g89jBCaSlUlQH33kuuElVuCiK9lvEeGAO4lpAJ2vCf0EBeW8NVIouJeiScOgii1YayKZOcj8IaA4uP9C9AZWo1GPXhJHjCEFeMG8GPwjFjeT4c1zHAMmuTiGI+3dLI9tpKC2Uk9uJ8LAq8jLkPd/J3iNJuEolYSZj0kKYxzGfbExxIjRDUBlFU5jDXfz+vBtg6LETGrKMXPnxkbGv5Sul7KcGpn+33eijiTlgLj5BwSMH4isV1PU1gf8tGyoxLb3cMT8L/l0vy3+vtrd6PLV2ipxd5MZJG9Mdg+INc6fHTvVPZPdMOjEtqBy6NxGQouKHZPuxCzc2nUeKNizd7D9RE3HBfaF9H5QujKYO5oLLR49zlxB9FQ5mpgU3UyUR9NgjpFk1qMjlmAbs+7VLu0p/yCB6TAg0QffP6kCxWTKcWBuk0TTpaWFzMfY1bWMtYwpHTs9yLlI/RppZpMZWfoXVBPM4ikeQplQFcSOO5PF1N8FnrSau2lTx9l+5EmddcUOWqb8+IwmW3P7ENbHteg9mGtRuH8qliLdXmnGoprnJXt+CvOwfE6FWay94mdYTDuOrouh5iJaEKZC5+04oJeJzu+hW56VXR88TnfE1br/kMaHXA6VqdMs8UeBwj9KV/7x4zCdCZ+wsE2cc3hDaUm/220hRBrbsruGwQ4mICSSJXTpZxxE3uqFLA6AmHLhsBsKAQOIXfhz13ToqsQZR
 I4+Tbfo5
 EKjwVSjFqD8z8l35zOgJ6S/ToQZTV2LqC0530OtSLKyEfoC/aAdoKRUspWJ6frE4J101eOZXFAmBadIzZThBw6d3RgQHnvR8yt2ACOlDYOCfy/J9E/k3Nuj8AwZoaSX8i2OyzTKMUky7Rpo/pBk8G9J8nOokbbwXtK2qoPIV8UotvnUc70t3oE9SWU2BCPhFbKlf2MTSCr5VNtIvEOkTk8Fj57ykdL+yqJ0lmN0LPxUi8jjEMNSSIRuNI278e+qGrVRYkT1PyPXINwc2mDL3GiklbgJaOZNcAXSKhDLO61oNJDG7/28B3IbiZbxprdujNWN17GkzS2hT6NcDplAUf9iyraoU76UCLXjFbcN/AHem41WW8JyzcfL3BVJAyE2QVUtgnk+Kr+3QYfQkTfcxOBoPx5Ga1sPuckKDeXA1AeSTfVeQb7KCJUdOruhbMdMd4c41M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 15:26, Shardul Bankar wrote:
> xas_create_range() is typically called in a retry loop that uses
> xas_nomem() to handle -ENOMEM errors. xas_nomem() may allocate a spare
> xa_node and store it in xas->xa_alloc for use in the retry.
> 
> If the lock is dropped after xas_nomem(), another thread can expand the
> xarray tree in the meantime. On the next retry, xas_create_range() can
> then succeed without consuming the spare node stored in xas->xa_alloc.
> If the function returns without freeing this spare node, it leaks.
> 
> xas_create_range() calls xas_create() multiple times in a loop for
> different index ranges. A spare node that isn't needed for one range
> iteration might be needed for the next, so we cannot free it after each
> xas_create() call. We can only safely free it after xas_create_range()
> completes.
> 
> Fix this by calling xas_destroy() at the end of xas_create_range() to
> free any unused spare node. This makes the API safer by default and
> prevents callers from needing to remember cleanup.
> 
> This fixes a memory leak in mm/khugepaged.c and potentially other
> callers that use xas_nomem() with xas_create_range().
> 
> Link: https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
> Link: https://lore.kernel.org/all/20251201074540.3576327-1-shardul.b@mpiricsoftware.com/ ("v3")
> Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
> Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
> ---
>   v4:
>   - Drop redundant `if (xa_alloc)` around xas_destroy(), as xas_destroy()
>     already checks xa_alloc internally.
>   v3:
>   - Move fix from collapse_file() to xas_create_range() as suggested by Matthew Wilcox
>   - Fix in library function makes API safer by default, preventing callers from needing
>     to remember cleanup
>   - Use shared cleanup label that both restore: and success: paths jump to
>   - Clean up unused spare node on both success and error exit paths
>   v2:
>   - Call xas_destroy() on both success and failure
>   - Explained retry semantics and xa_alloc / concurrency risk
>   - Dropped cleanup_empty_nodes from previous proposal
> 
>   lib/xarray.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/xarray.c b/lib/xarray.c
> index 9a8b4916540c..f49ccfa5f57d 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -744,11 +744,16 @@ void xas_create_range(struct xa_state *xas)
>   	xas->xa_shift = shift;
>   	xas->xa_sibs = sibs;
>   	xas->xa_index = index;
> -	return;
> +	goto cleanup;
> +
>   success:
>   	xas->xa_index = index;
>   	if (xas->xa_node)
>   		xas_set_offset(xas);
> +
> +cleanup:
> +	/* Free any unused spare node from xas_nomem() */
> +	xas_destroy(xas);
>   }
>   EXPORT_SYMBOL_GPL(xas_create_range);
>   

Nothing jumped at me, except that the label situation is a bit
suboptimal.

Hoping Willy will take another look as well.

Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>


BTW, do we have a way to test this in a test case?


A follow-up cleanup that avoids labels could be something like (untested):


diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b4916540cf..325f264530fb2 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -714,6 +714,7 @@ void xas_create_range(struct xa_state *xas)
         unsigned long index = xas->xa_index;
         unsigned char shift = xas->xa_shift;
         unsigned char sibs = xas->xa_sibs;
+       bool success = false;
  
         xas->xa_index |= ((sibs + 1UL) << shift) - 1;
         if (xas_is_node(xas) && xas->xa_node->shift == xas->xa_shift)
@@ -724,9 +725,11 @@ void xas_create_range(struct xa_state *xas)
         for (;;) {
                 xas_create(xas, true);
                 if (xas_error(xas))
-                       goto restore;
-               if (xas->xa_index <= (index | XA_CHUNK_MASK))
-                       goto success;
+                       break
+               if (xas->xa_index <= (index | XA_CHUNK_MASK)) {
+                       succeess = true;
+                       break;
+               }
                 xas->xa_index -= XA_CHUNK_SIZE;
  
                 for (;;) {
@@ -740,15 +743,17 @@ void xas_create_range(struct xa_state *xas)
                 }
         }
  
-restore:
-       xas->xa_shift = shift;
-       xas->xa_sibs = sibs;
-       xas->xa_index = index;
-       return;
-success:
-       xas->xa_index = index;
-       if (xas->xa_node)
-               xas_set_offset(xas);
+       if (success) {
+               xas->xa_index = index;
+               if (xas->xa_node)
+                       xas_set_offset(xas);
+       } else {
+               xas->xa_shift = shift;
+               xas->xa_sibs = sibs;
+               xas->xa_index = index;
+       }
+       /* Free any unused spare node from xas_nomem() */
+       xas_destroy(xas);
  }
  EXPORT_SYMBOL_GPL(xas_create_range);


-- 
Cheers

David

