Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF68C44520
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8164E6B010A; Fri, 17 Jul 2026 20:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE686B010B; Fri, 17 Jul 2026 20:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707636B010C; Fri, 17 Jul 2026 20:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 47F756B010A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:23:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD23CA027F
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:23:50 +0000 (UTC)
X-FDA: 84999999420.01.B9FDB02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 17732180004
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:23:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pGPyVGzQ;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784334229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sT1lMmOrvNVAoIz5Gs7S2ofc6t5sDGbTcquhmwqvl/s=;
	b=5OKOebdgTroYXikLYOIvjsdsQpHb2b4aH4Hjnx7+l0klAYFH4UUgUxuMJOYmddxPYumZBR
	nn2jZ3/jm271Qvkclcy9jbhY1Nz50HyAqBDfqJQmAvqkDF1zM32DYsjEyzZ9u6yNcqODrc
	dUtwnyJwhlnP48uufiUhCg5+mn72AQs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pGPyVGzQ;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784334229;
	b=IPijviav2w6PR+LQj3/ox0s8FcLnqINQl4xhpo8suLy6t12DriCJVOp+B4ydQnH35HVpPK
	SLcA5RWcrKTpExuvi90EaUflPzNmr5LNhMyfHNEJLPNDQg3w4XC8esnEqui0kxKosTGBtS
	m4atFNuczctirObduPLDxanu3m8qJW0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 834CC60AB5;
	Sat, 18 Jul 2026 00:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086821F00A3A;
	Sat, 18 Jul 2026 00:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784334228;
	bh=sT1lMmOrvNVAoIz5Gs7S2ofc6t5sDGbTcquhmwqvl/s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pGPyVGzQUsnyeLeRC5KIXdrpQnKuV8ByqqH2HF6O5KhmV5slfq7DDPW95iGZso3kO
	 hINIOY1lG+QG6CzvXyUXY6/WLJnDp0vnMnljXHy0WmNIpI/I+Fl4/bQzxw/GwyoBO9
	 Ri1cBv8WJE+ozFeyg7OmRK+6hppNZFRnSsgM1xk0=
Date: Fri, 17 Jul 2026 17:23:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Sherman <shermanpauldylan@gmail.com>
Cc: linux-mm@kvack.org, tj@kernel.org, vbabka@suse.cz, dennis@kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/percpu: allow embed allocator when total size fits
 in vmalloc
Message-Id: <20260717172347.18b3c01b7553da75f6344c65@linux-foundation.org>
In-Reply-To: <20260717231616.9126-1-shermanpauldylan@gmail.com>
References: <20260717231616.9126-1-shermanpauldylan@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 17732180004
X-Stat-Signature: whksymbukyaxa58rz6ssngoekpo96czt
X-HE-Tag: 1784334228-730984
X-HE-Meta: U2FsdGVkX1/kJuWdVmCbgOMIZbjnRAcBmag+r7I26DfeTi1RHwMcLmD2VFcEjF3fS5b057YkQmQIMa+/VNxxGWHjUw8hq1xMMrwL5CeA8GtbsmLzEzPB8AtGs9qqPokhM03eIbrMMLQqk+3EsI2efg+DVFNntizOzI8PZDfZtfqGAv1/ZVJuvFbl4STUqfk1ChPwMufSQf4wX7C4OOGWkVCV+TAUUuKA785lnvWIH6xSWW4Lj/H1IPc00Ltnm+lvgOCWLTR4XXb1QvERpHI6Jg6yZh2q3nqdcolhmHj4zyIpnhpKUe9g9J7gP7xgwUx/dA7Nxtd3lFCJzzo+plvD13nI71IqYqyuUk/UPNMvx112gFEI+1OEwqlwuZyofyEoVRAlbIXEaypL3LiqiQPtYzvoRyRcgMsRbyziqCk4b9FQptw5qTZ0KK7K6PIZTAyXlFvsGkf7Ucs68gZpKB9x3FNpZn0H/2fen/V8aSSlyjg4B3hKC9/adB2/ff7rXwlxZNLgW3vaqDNhjWJFPecK6cpbkrwWFOpnWb6PaMqC7tGvWR/xApLnovj4o+GAWK/A0P0VMfA4AlexjHCz8+IkvdPjRfiGDKnUq2tg5W1YjcfVlZmfFIuKTLG914PIrDFiy3+owA7DsfuHjkYOOxz9bczaLRWQ11SasMOjpgulnw+4SMNPoZ+89JrlNzkacfpZePtgonTZVI7EqNkMGM2ofzzTi8QAmVmHpz6bM4+Nx/otCAhMEhzoIumYcRbmREFPa5vS6h6JPpnJKQwEclY8SoXljN3+njI8bC53Lf2CBuQMb7ucpxU/o+zu7wO+HdNB4k9va7xjGfDtAoh0NbLCozIXbvDpvZ+kw9EUM5elusgUp/cCEtfVOvgJdGsMibeqQdpCRD7QQ68SyPjVtI4SWSaK0A1qd46QLO7ALORiKyDAwnbIppycx6DvFADyvBOM+P6++LzGusnUtzKK1HV
 VUJQwVAS
 cYulhZvUImBRB5/NzPsJE13rhGEYX08l+ki7TBcGs99ZWOcNZAtEtdN4yWnnXUGTyZ4cgDQ5+9fuXIE7QXSbheDAfN/wDbqC67s4j3afXDvjWJXAIfnhUz0n4Ese2+pofwUT+DkeOQhPFZdCYf03n9CJpyT50jjuvvYeiXZ0YXJvzx0NmsE8HCgZquncK9udmtRcTgjge4fk5GhbFLLmbVkFeihPVYgAvKmu55GI8hk8nrT8dwn0ujlXnN/ojEbYA7tAKq3t6Fv3xJXhujbT9o4+b7klZ5v7dssRInh8wzj2NJFAOKh//mU5a5imFEn2XtfFWo+qclFa544rM8V97oPcUozTmjp61NznTwFoBAEisQ8MmB5nQ3zTRSZTNrORRhUc8uSeGeSR2my4fnMcGy0b4eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 16:16:16 -0700 Paul Sherman <shermanpauldylan@gmail.com> wrote:

> On large NUMA systems (e.g. 4-node 128GB), the physical span between
> NUMA nodes may exceed 75% of vmalloc space even though the total percpu
> allocation is tiny (e.g. ~6MB for 64 CPUs).
> 
> The 75% check was designed for pcpu_get_vm_areas() used by dynamic
> percpu chunks, where vmalloc congruency is required. The embed
> allocator uses the linear map directly for the first chunk -- physical
> addresses are accessible as virtual addresses without vmalloc mapping.
> The relevant constraint is total percpu size, not physical span.
> 
> Replace the unconditional fallback with a total-size check: if the
> aggregate percpu allocation fits within 75% of vmalloc space, proceed
> with embed regardless of physical NUMA span. Systems where total percpu
> size genuinely exceeds the vmalloc bound retain the page allocator
> fallback.
> 
> Tested on Sophgo SG2042 (64-hart, 4-NUMA, 128GB DDR4, RISC-V Sv39):
>   percpu: embed: span 0x17def7a000 > vmalloc 75% but total 0x5c0000
>           fits -- linear map used
>   percpu: Embedded 23 pages/cpu s54168 r8192 d31848 u94208

Nicely presented patch, thanks.

> Link: https://lkml.iu.edu/hypermail/linux/kernel/1707.3/00337.html
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Dennis Zhou <dennis@kernel.org>
> Signed-off-by: Paul Sherman <shermanpauldylan@gmail.com>
> ---
> 
> This fix is inert on systems where the original check never fired;
> it only activates when physical span exceeds 75% of vmalloc but total
> percpu size does not.
> 
> Architecture analysis:
> 
>   Architecture   | vmalloc      | phys span    | total percpu | result
>   ---------------|--------------|--------------|--------------|--------
>   RISC-V Sv39    | ~88 GB       | ~102 GB      | ~6 MB        | fixed
>   RISC-V Sv48    | ~88 TB       | ~102 GB      | ~6 MB        | unaffected
>   RISC-V Sv57    | ~44 PB       | ~102 GB      | ~6 MB        | unaffected
>   ARM64 large    | ~248 TB      | varies       | tiny         | unaffected
>   32-bit NUMA    | ~128 MB      | varies       | may exceed   | correct fallback
> 
> Tejun Heo noted in 2017 [Link] that the only constraint is vmalloc
> size relative to NUMA node distances, and that making vmalloc bigger
> would be the best fix. On RISC-V Sv39 with 88GB vmalloc and 102GB
> physical NUMA span that is not an option -- but the embed allocator
> does not need congruent vmalloc mapping for the first chunk anyway.

I suggest all the above be moved above the "---" separator.  It's
useful info for the permanent record.  (And replace "[Link]" with "[1]"
in the usual fashion).

>  mm/percpu.c | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)

AI review asked a question:
	https://sashiko.dev/#/patchset/20260717231616.9126-1-shermanpauldylan@gmail.com


