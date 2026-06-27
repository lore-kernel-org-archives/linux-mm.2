Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E64C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 09:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D716B0096; Sat, 27 Jun 2026 04:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE776B0098; Sat, 27 Jun 2026 04:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613036B0099; Sat, 27 Jun 2026 04:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 411116B0096
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 04:59:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A45B38DEBA
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 08:59:58 +0000 (UTC)
X-FDA: 84925095276.08.CBD8695
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 195B820002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 08:59:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFP15Yvz;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782550797;
	b=KHCx/7n8McvUohmldg4V2vnVdu0CQqjrlAAb2YeJJF5tasvfcfl6LpHaZnNNuNcAhzdREF
	safc0QLbP0U6SqCWxxBi9DUTHRl2RgygKL3e8/LwDRdseYZj8Q0jNuNrbPe+3fCOUxxcsC
	cp/ba3PaEphwHTi6Byaz3I5pNFEy/6E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782550797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AYyHhsOmrkOkHlnQ8kt3V/chet8d/72eUus0xZyb6s=;
	b=ggtpruikBgGdoDkEx6UEoxfhUtuxROlolJrvew9sVuXW5w0aohUPB6QrlX51MEbmLiinHe
	LsO/dEmpPeiKeOv4i9Espuh/fjdigj/EC3MSvEcAmF6a30jSjya4cKi7LwI/FjXN+6nIIW
	I1Qp4uROyoTMpoDId2HRtXJk+23vwgU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFP15Yvz;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B50F600AB;
	Sat, 27 Jun 2026 08:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76571F000E9;
	Sat, 27 Jun 2026 08:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782550796;
	bh=9AYyHhsOmrkOkHlnQ8kt3V/chet8d/72eUus0xZyb6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QFP15Yvz/No2SgGk1kPy51T0lrTgCp3RvoVAQKRGq3FwcrpVhBCmHwf5sLmX7gALc
	 s7pgeKTC/YH+vYPEQQvYL9AuE5oeIDNBklqx3/Y4fSj+DkRdXGKV7z7HpE4d2jdiyG
	 98jWurSeZA8J6pNz1O97UKkTVL8Dl9yOuLyWiyDFdkXw32vMxBO16FhFA8x/wv2EQ+
	 x5kf7YF2hBfHwlWnojxn3OAHnx+bkVmqCOL4kT/h2vxmwN5+AKfk0hqDbnHVMdQQnp
	 v5wsfYeRSRfFK3UJFPI7k6cl3TjIKqB/lp208ve+ps8rNALo6uhqmLGw7v4YST1UlM
	 0KS9DEgKwcR9w==
Date: Sat, 27 Jun 2026 09:59:45 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, kernel-team@meta.com
Subject: Re: [PATCH v2 0/3] mm: __access_remote_vm with per-VMA lock
Message-ID: <aj-QuW3sEtVSKQ2X@lucifer>
References: <20260625015053.2445008-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625015053.2445008-1-riel@surriel.com>
X-Rspam-User: 
X-Stat-Signature: wwg11dejbyuin419888945wtms9o7db3
X-Rspamd-Queue-Id: 195B820002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782550796-845545
X-HE-Meta: U2FsdGVkX18YKn2KBoNmHP10qUtgS2wrAfErwum/eaq5imgwTjA6XbIuJtqdL4n9KoPx+es3ReROPgxTKd5kkirJSwg3jmW51/7KPtCL3sXF9jUYpj302MS9iOP0dM9MWmlTfcAJayWE7JC2RGCeJHjeFoc/C+YMWLlaqo0vTWliv3brJrE+oycSsaKWypzyzgDAXx29y089P6EvPIcwrYKhNzc2gfMnZ45JybO5cZuzZduw9FqMJH8IQzNO1K5pvUW4Q7atX33YfqYivRPUE+S0t+7UztFi070dNwa/GlsmmNU5QME9zZ9OA+nrN0hmMYpTBXpsU9Cfu8778siYQTt141DGiKOKoujV30mK1ctKOqMMKaRbwt3tjYuBAnF3fe2w+Lxk84AIVOboNo/eqnmIrqUkMSzbIaQwsNjBUWobCpJP0LoPClXjpi8+RWnW4vsYVRf4y12fpQef54Xl/fKL1uLDD5oD7Mnt6WO4mE0v2yrSEd/V2GD+rFkFG4Bvnlw8ACsOVwYwkCL1yH6mdUANk7DHJEzwfOOCOa618fBsUB+4umVSk9j9Xf29vx2NO045k8907X1/SJfwUtvw2PhgUIZSf2Rz3sNiRz68aRCDl7u3PuwNePukFx30uHBpdt1bhpSAHwwlp45kpG7meuav31yEUq1NbKWoFCgZ8Nx3uJc2ENYEUBUFeNi1Q/2YlkpTLuWYUBIXsVqUB9tfwpCJaUxx75V024QEgszZGOjoibirdWMlO7POmVtI6lqh/C7Aamz3GczZlWn2hY1eJRx8RZFBE7uhlbr1DMrp1rcsUxnhxwaVSkyXjLtHl+YvRhj50TFr/tMj8LfbeyE1i56e6/V4UXfDKq/8T9Q9v9fF7beO+dJOCrgBd87cqrySZeYZJ8wvZb5fmuvkOjrPLThw2+FgpUnA3ZQoJPSR3HX2RCoBKAV8nVzA1JFDovvAgtVlREJBjCMy3MUNeC+
 1ya3GU/8
 tZzR4VKDM9cAEGwH6NwCJBkvJEAlLb/VES9N/y0SgRgD15akPIZFQCOVlRVDlRqIAsoOlQGj7huyApUaTUALsl3l/6LR4gs9KCc/SLTGi9zV9vYsG71l7ghcdUvUX7mPxzafndejCP6FQF6P+jOMBipSpy3fCi4IG9FXT7XT54m2J5X3+KbYCkzFgVgUmoSXLPBnbJwpbabshvMRR1Qh/U2c1wGZy7OJT02uUTCHh92HJreEs9AgbBo3MT7/efpBFROY9xZcpXJYMXs8dd20CrHrKyS1JmmREDpnaujsePTSRfe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 09:50:50PM -0400, Rik van Riel wrote:
> Sometimes processes can get stuck with the mmap_lock held for
> a long time. This slows down, and can even prevent system monitoring
> tools from assessing and logging the situation, because they themselves
> end up getting stuck on the mmap_lock.
>
> However, with the introduction of per-VMA locks, we can improve the
> reliability of system monitoring, and generally speed up __access_remote_vm
> under mmap_loc contention, by adding a fast path that does not require
> the process-wide mmap_lock.
>
> This fast path is only compiled in and used when it is safe to do so,
> meaning a kernel with per-VMA locks, RCU pgae table freeing, the VMA
> is not hugetlbfs, iomap, pfnmap, etc...
>
> v2:
>  - simplify the code, which should be ok because these copies are < PAGE_SIZE
>  - clean up the code
>  - fix locking wrt tlb_remove_table_sync_one()
>  - hopefully address all the other comments

Please always send a diffstat in your cover letter by the way.

I noticed you didn't do this elsewhere also, so please adjust your tooling to do
this :) (git format-patch --cover-letter does this by default).

Thanks, Lorenzo

