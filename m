Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AAFACF64A0
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 00:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B136B0031; Wed, 19 Nov 2025 19:46:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542576B0032; Wed, 19 Nov 2025 19:46:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47EFC6B007B; Wed, 19 Nov 2025 19:46:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 390D76B0031
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:46:55 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4B01140700
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:46:54 +0000 (UTC)
X-FDA: 84129145548.06.BF6D274
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 272DE40006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:46:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E5mzQQmp;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763599613; a=rsa-sha256;
	cv=none;
	b=KqaFPxYKvD+4ba5ybKK9U+5ZQvXaMkZxPvv3bnXJFF6kjYI/keurBAIF7tetMs8cI23vEN
	ImfwnhF6gS/yyZw1UxGaGGaUpjdEdaW8YvMiABDrUWisl38yhelS/GIv84GJmp5evlIVIW
	56tF3/z3fiBNtS1KQ0558QVI9KufTPI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E5mzQQmp;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763599613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yig7EtEkh+Kwl+qDHdzFsGCAm6iuJsG5WqgGpKt0pkY=;
	b=mh0QnysX726ahQPWlRBVSeXolNWXEKK/U/C3JoykdIYia8ok09obqG/MdX4wwWiH567cr7
	0oHofiyTlZPcKKlLMdfeCHMf4vYLkqPIw4XkHVaGq+4EKthZHCKzhEpuvod35P+1QluPGe
	2ugQ3lR3mjczACcVnpfTWFkmhHWZT9M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 630B26017F;
	Thu, 20 Nov 2025 00:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8463AC4CEF5;
	Thu, 20 Nov 2025 00:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763599612;
	bh=ex36AqEu5u6kvJkLAoT49xL6SZDajGUNQof96jW/Dwo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=E5mzQQmpAZd5076RJmQhBoM5Dq46hvfibPyu3y+pTuGawh5HfOV9d5sec0MS2OE2a
	 zn29VpHtncY9DmbtvoexxXjcXmn76f0X0hVB0PteiBD7V7hK4eBl4CELexLBaZzrg1
	 FWBWO+zBWbUdnc6xXp8MfAm7HAHgOL/UR8xPhKXg=
Date: Wed, 19 Nov 2025 16:46:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, linux-mm@kvack.org,
 stable@vger.kernel.org
Subject: Re: [Patch v2] mm/huge_memory: fix NULL pointer deference when
 splitting folio
Message-Id: <20251119164650.e5ac7e3b5fa6062016652149@linux-foundation.org>
In-Reply-To: <20251120000312.xasxdzmmztvp4spa@master>
References: <20251119235302.24773-1-richard.weiyang@gmail.com>
	<20251120000312.xasxdzmmztvp4spa@master>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 272DE40006
X-Stat-Signature: foxoawszffg8zgytzbqmp8nzku3bt73m
X-HE-Tag: 1763599612-561399
X-HE-Meta: U2FsdGVkX1+7JuUO1GL1RR3Wk9GtoeOfNOqPgprWPZo2wQImGbaLxm80FpkKvwjeJHNKykWgMlWgqazYyam9iJ8wz0i7yVW69Vhw3WsUEnQ9I3lQ0jtWwOPE/uoZATiJuaWJnwN2hXgL9itJZpZpTBu9cH78FPh6YKGrRyNHSd2eQ8P+qMhPNurstwg65I5SgZ5i85Kb4Li7CpCUVZlBoFj6FSXlxh4y1Hr6Esp2iiEikQ+S0rNmOKEv+3WqpUzp1zfLLY4MyAmtAODNQmIhFfSOAeii3r9Uq17zdYm1xBMPtRhWjMEZmS+tIfoI8vhFoOrKqujSMPVp7OIM7OtrBukcmc+YKg3yPx5YdrJTUrBBzFxR4IknJBtYRpa6Z/tRWNVhaNg/tIiPYjHgMAHZk+MNNvNCOGLkqTULLu+sCmZVXFdqQaf2J66etfSadvmeMXfaAbjNT6eRLiAlgpqmf33yeMPwbmndNNcq+pIwGKPl384KE9z+CjRA3ZLKS6Qg5PzAPnrt46CWBmpZrly8pdy7c/V1RX0gGEjDqa6TrU0RAfXEfYYSBENEfb6bAVjRDCgunL93v1f+Un10nYx7eF6xaMGo12grIIiowOZLAMUUTlHSX4A1bDfOV4n9lycrhzSo55+v5vjIaPrOm7FG4qd822l35UqayIbrd1jZbcqh898HzNC5RRDV8GZDXSH30zP3q+MgXw40sI70KANFQSWfI2nL6KXa5bcOGFNaxk+WtqO+5N+GQEluuu5NU212h95nbX8N4r7mmnWz4fEjz4rP0E5WYrBJPSPjdtwt4/9uq6Ix1VcH+ZBnNnUH1eID7qwyQfDWLsn6Xq94vuh29WFpEjZv2PhLC+/ox9EjtjB63h8D1aXKPHLoKoGCLbW3DewBygkwQxYYvNqY93NY27V3v2ndiw5cZfS/6j3lRFVWR7UWa77X9Iz/xb348ltRkE1+8J045B7C4M7bLxQ
 vd3mtTiL
 DFVtYuP38K6WufTCk+GDBBoD0k7J0izIc1FDQgRE5qe6lw841KLV3sM2Q7NUZRD8pXVdMlEu9QOiHCfArNNYIo3XKutjgF2MOQsvJy5khkXhebQI5aCygHn6/OvYjqqvGZmtVK0iXeiaxPfilhO2B+du3Cp0oqI32hU6vkypW1qVHSPv+Kiz2H/V8tf3AxQz7teKnQlfXmh5Tm3KP2XE/G5bZRd6Ck3HvBb1QIElij+LJqaA2LhJp1K5qBR3S/2y0vCOIS8HWuFxP+OMF3SpBIsLHob6kbcUK0bteXlmooaf2fEVMX7BOLQKrlRYzDTVeseuf1DuMxj/StjKV5m4VMgCyyY3WVZUjOwOpELIAGILGILgSYo9tMVzcz9ntNr0cGLeuQ8AmQxKFucp70shlf20JB9bYnHkycyAyduTqptJhymEQtbWcLh2FWAoZ5WJTt0U9pk254Pr3JxG0it0ktGCb0/L3+zaIFGRMOpTKBm0E2f2svpS/rgFnPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Nov 2025 00:03:12 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> +	 * TODO: this will also currently refuse shmem folios that are in the
> >+	 * swapcache.
> >+	 */
> >+	if (!is_anon && !folio->mapping)
> >+		return -EBUSY;
> >+
> 
> This one would have a conflict on direct cherry-pick to current master and
> mm-stable.
> 
> But if I move this code before (folio != page_folio(split_at) ...), it could
> be apply to mm-new and master/mm-stable smoothly.
> 
> Not sure whether this could make Andrew's life easier.

I added the below and fixed up fallout in the later patches.

If this doesn't apply to -stable kernels then the -stable maintainers
might later ask you to help rework it.



From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: fix NULL pointer deference when splitting folio
Date: Wed, 19 Nov 2025 23:53:02 +0000

Commit c010d47f107f ("mm: thp: split huge page to any lower order pages")
introduced an early check on the folio's order via mapping->flags before
proceeding with the split work.

This check introduced a bug: for shmem folios in the swap cache and
truncated folios, the mapping pointer can be NULL.  Accessing
mapping->flags in this state leads directly to a NULL pointer dereference.

This commit fixes the issue by moving the check for mapping != NULL before
any attempt to access mapping->flags.

Link: https://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.com
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-null-pointer-deference-when-splitting-folio
+++ a/mm/huge_memory.c
@@ -3619,6 +3619,16 @@ static int __folio_split(struct folio *f
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
 		return -EINVAL;
 
+	/*
+	 * Folios that just got truncated cannot get split. Signal to the
+	 * caller that there was a race.
+	 *
+	 * TODO: this will also currently refuse shmem folios that are in the
+	 * swapcache.
+	 */
+	if (!is_anon && !folio->mapping)
+		return -EBUSY;
+
 	if (new_order >= folio_order(folio))
 		return -EINVAL;
 
@@ -3659,18 +3669,6 @@ static int __folio_split(struct folio *f
 		gfp_t gfp;
 
 		mapping = folio->mapping;
-
-		/* Truncated ? */
-		/*
-		 * TODO: add support for large shmem folio in swap cache.
-		 * When shmem is in swap cache, mapping is NULL and
-		 * folio_test_swapcache() is true.
-		 */
-		if (!mapping) {
-			ret = -EBUSY;
-			goto out;
-		}
-
 		min_order = mapping_min_folio_order(folio->mapping);
 		if (new_order < min_order) {
 			ret = -EINVAL;
_


