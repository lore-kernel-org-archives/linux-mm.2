Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6202B10987A2
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 15:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C996B00BB; Fri, 20 Mar 2026 11:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFCDB6B00C4; Fri, 20 Mar 2026 11:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB806B00DF; Fri, 20 Mar 2026 11:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 923926B00BB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:58:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E1941B7115
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:58:45 +0000 (UTC)
X-FDA: 84566899410.19.5B1FEC1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 42EAE20002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:58:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=M3L209Em;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774022323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0ttI541UQY84WArzRfOEWNiNuBFeazGDrQAgFDGq44=;
	b=e2YYrlMQTI9CXdKyQNKr/roRWBvFHEpMwNc4D76A/717fGSjYVP5Aa0+CBvrdfuw42ZvIx
	5+VpP8Us1EImuypIIHEB6eeTwPSe0gTSKH5Rmlf/Y9lUYIhvxZvmJHnNDzO29Kt38RrFVY
	c/Rst4bWRoGAS8ZYZBwho/pMe3A/bJo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=M3L209Em;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774022323; a=rsa-sha256;
	cv=none;
	b=lcjYj+sDVUkuybNV6SKmpeNqFE3SgBy1rL/lf0K5i8oR8vCAnYJPuisxnetqHzp90gSiOK
	o0PnO0PnabcMpb4ug3zsgoZWYYTKdhcys8wlqlsJSA64UAdWZVIosRkaFqopa/ds87mAqG
	O9iHYK3Kn5pd70tAb1BfzwsR7MAt9WM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=e0ttI541UQY84WArzRfOEWNiNuBFeazGDrQAgFDGq44=; b=M3L209EmfHhmhx8qXXSa3pll7+
	UWQpI0rPR5iUZxltAVuV53KVp8vgAVRpSTE5EYYh5kFJDTe+TiMPaeTD0IAVZO2s6+tz3tpomEkG1
	xNDpU9byINpbXVjau0BeY+o7fIMw7Dt9gO+cp/uY+yZAQXwC/STkijtxRTq5klqUtwGIfeOmrjjvQ
	z4JJ5ud+P6oY4/5472KsnT0vk2Xg1XTwqJ53ybDJAxhYJFlzLCinx/dVDR1QJfAZTYCkWJHozpoFj
	FLkiuEv+Pv4EKGdopZ3E56HXZi9Bn7GKrbgGrkBjnTRU/CS62KWOFDFTOc1UzIKP7CFxLG1q/S+yp
	QYz3oMvA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3cF7-000000080Fh-2VkZ;
	Fri, 20 Mar 2026 15:58:33 +0000
Date: Fri, 20 Mar 2026 15:58:33 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc, jack@suse.cz,
	ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev,
	Liam.Howlett@oracle.com, linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, mhocko@suse.com, npache@redhat.com,
	pasha.tatashin@soleen.com, rmclure@linux.ibm.com, rppt@kernel.org,
	surenb@google.com, vbabka@kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@kvack.org,
	ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org,
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v2 3/4] elf: align ET_DYN base to max folio size for PTE
 coalescing
Message-ID: <ab1uqdcMBP1cBr7Q@casper.infradead.org>
References: <20260320140315.979307-1-usama.arif@linux.dev>
 <20260320140315.979307-4-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320140315.979307-4-usama.arif@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 42EAE20002
X-Stat-Signature: 157ob55k17e6zcs8sppekjf6ofztyuhc
X-Rspam-User: 
X-HE-Tag: 1774022322-364125
X-HE-Meta: U2FsdGVkX1+8XXA4xQVl2DTeFLCGRT93x9j+EGbClTCBE1rHH22InlCLUjjH2C9jgr6dSyOY5CXG8fwiauVz/WKZXgYg8o2thJ7EHPqdsR1JlnsPt80B7e8ozWnWIFSn1qbDGYY4DK05wFeBFczKcYcpaT2sfS5Tci5UiVrQR5p7tyOOmj0wfGpC24PCGNWkEEB7Zfu3RZKNPFYvdRuxH/vCnuIeWERUj+rSwvz1BfKPHDeWG+3PMln1oVbKdzsDH0Iq37zMRyrH48xcIfyK3M5nMeYhv1BIswbCF45WtbpUGGL5+j5fLfNt+kkslDu1gaZOcHnM/Oy+152HhGKn+3f1Vz9CJkOIRB3jYngCWY2jW3yJmiFkA4DUxiX5PkbMTv85VqcSMUG3ld+ac2lbk+y6MKQnXQLGZGBlToAuboJWHbPus+dfStCg+XTLW3b1wS/h3KDNkn9wAprivjadiC/nYYayyz8q359f2+jsj7/OzNzz3EWqnXLzBCIfDHDaD/UadIuSkCZMzphHFbSBAx58vgb4wqqIoTy5walGOOIuRIa8fcHpOvuXHDlt1wAD6IdCRP0TEpnqX0Q35sH6AIF4n0BxXRBw+ZCfScKnFXLpk8fRwjS9TSFd6ujHdFyS/49AHwRH/sYEiasbfwDVFzIWOMuQEMafTmY/baPCA3OpSRZRsBzqfSVVyM91yNdiCRtZ5ySVuzwGzPiJpyKhlO0XJN616zek+ljQG2YZq5YsshE3/lH0g1Hvt9CFvW24FT63DQemndUVwjOgerBmgwWgyGbPh5OQz9wB3z0sJdObQvSkcOqT0GYSptt77fXEJzFkUhiq4SmaOkFUBfDPccI/2w+X4gS9IIwyo3zoxQRbAPNJwRyhz0R0jHqKKBpsbB12yiSQg/6pCaK8DweWqQjJOL/oZckSZcOYP8FTbvzxjWWIdPbciiNssLPPRTGid4YxLYKeWEg3ktVQLK7
 i0yELVbS
 yVH3RxWTwEObesKvDM94juCLWUAg+FIncA0k4ilBbRcM4Q624p6WL/jtoAK69Fd1QqT7uTXLNXXl6lk5MQWy7pmWm3I9dCQonOFte4SPjnOothXCs8OBlUO4OqvRoN8Z8MfjwjdF0C/ExoIa2sCMUmhD/jM0CIWRA027wxypx5KwZc0ZhYxQem0vj02yght//ksvoB9lXu0DTSsYQTl72mLF9Twu4MjYi7G5W6Ms4oH9kE3UG7mb2n0yux8hhYxvG90omwH1S054INjqrmof6M8Z7dP10VrmcSQecaajyOESuUSMPSS8UvB/hi7Mp2k36kgQn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 06:58:53AM -0700, Usama Arif wrote:
> -static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
> +static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr,
> +				       struct file *filp)
>  {
>  	unsigned long alignment = 0;
> +	unsigned long max_folio_size = PAGE_SIZE;
>  	int i;
>  
> +	if (filp && filp->f_mapping)
> +		max_folio_size = mapping_max_folio_size(filp->f_mapping);

Under what circumstances can bprm->file be NULL?

Also we tend to prefer the name "file" rather than "filp" for new code
(yes, there's a lot of old code out there).

> +
> +			/*
> +			 * Try to align the binary to the largest folio
> +			 * size that the page cache supports, so the
> +			 * hardware can coalesce PTEs (e.g. arm64
> +			 * contpte) or use PMD mappings for large folios.
> +			 *
> +			 * Use the largest power-of-2 that fits within
> +			 * the segment size, capped by what the page
> +			 * cache will allocate. Only align when the
> +			 * segment's virtual address and file offset are
> +			 * already aligned to the folio size, as
> +			 * misalignment would prevent coalescing anyway.
> +			 *
> +			 * The segment size check avoids reducing ASLR
> +			 * entropy for small binaries that cannot
> +			 * benefit.
> +			 */
> +			if (!cmds[i].p_filesz)
> +				continue;
> +			size = rounddown_pow_of_two(cmds[i].p_filesz);
> +			size = min(size, max_folio_size);
> +			if (size > PAGE_SIZE &&
> +			    IS_ALIGNED(cmds[i].p_vaddr, size) &&
> +			    IS_ALIGNED(cmds[i].p_offset, size))
> +				alignment = max(alignment, size);

Can this not all be factored out into a different function?  Also, I
think it was done a bit better here:
https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.cc/

+	if (!IS_ALIGNED(cmd->p_vaddr | cmd->p_offset, PMD_SIZE))
+		return false;


