Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DEC3EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983B96B0099; Mon,  2 Mar 2026 14:53:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947286B009B; Mon,  2 Mar 2026 14:53:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8776D6B009D; Mon,  2 Mar 2026 14:53:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 762E36B0099
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:53:31 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F0C2C1504
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:31 +0000 (UTC)
X-FDA: 84502172622.16.ED9BADF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8C1DB80002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Q8zFL9Ns;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772481209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vg2rbwRhJpGM/YZW+ccotHnBhwZDS+YIHJ2EbjRRlR8=;
	b=Z9TGIkCWcJS1CctgJ3QdSq6eKrltR3H7Imwbde2lBEO8n+FDDub+3J01HRpdSSKMVg1rSU
	N6SWAph3+l0ah6+aExnQCdHchNsiR3vR66FTZtTvRRvLjjJLLV7SYa83VME7Z9KKXaa1nE
	i7tgdkQU18l0GjRV5hjNe9YhTd1IdQM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772481209; a=rsa-sha256;
	cv=none;
	b=w+4UeY1e/srcBypjo6LGtreHL7+16Tvh/tuoAFrFXGmy4Me880RIW+2GoBcGOfqLT6H6k1
	NPa+bKzl4UikBnyaH8iVQC1Vg7G8h2Tl0OvGiBmk2YPksGYdFNHNsanhyEtP8JL3ee2Ccl
	ARdD1GvcdgTBJ9qTFdgDW3Z8l1zoabw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Q8zFL9Ns;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vg2rbwRhJpGM/YZW+ccotHnBhwZDS+YIHJ2EbjRRlR8=; b=Q8zFL9NswumAat796awyiryo+4
	oL8Ex+qYvo5WvYaRj9Ls1PqeGQ4lmKBJdED+K5Z1EEu5dc2Sd69mQ+SZL1vM0bTBd3qV7/pwpd1MA
	//s63mmdc7Fw6UkBnUofqgkEO9qnrn3hmvCBvR3A1w0BcgljSxjfiNtGn5Fx7OkIgNnDjzMHIGIuH
	VoPaNVy/EpiEHrKN0D93Q9TgeXyT3oee/1B/XKi5bCjucPPhWbfchmAaHePn2V+D0UNJKk+kSiiOx
	i8p7DygrDT/RXqyO9UaFmrUnATkOlokRX5q+L6yojgI+PSnwyYPPNTQ1zOsZGE9drkrcQC1y3BzZj
	6uw2bL3g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vx9KZ-0000000A00h-2iCh;
	Mon, 02 Mar 2026 19:53:27 +0000
Date: Mon, 2 Mar 2026 19:53:27 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Alexey Suchkov <aleks.koyf@gmail.com>, akpm@linux-foundation.org,
	dywoq.contact@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] [PATCH v2] mm: initialize 'seq' in gup_fast to remove
 -Wmaybe-uninitialized warning
Message-ID: <aaXqt8TD7r5wcrRI@casper.infradead.org>
References: <20260302193405.37961-1-dywoq.contact@gmail.com>
 <20260302194836.2932150-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302194836.2932150-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8C1DB80002
X-Stat-Signature: yhyay3yfidn4xrfq77cufgtsakhcauyu
X-Rspam-User: 
X-HE-Tag: 1772481209-61597
X-HE-Meta: U2FsdGVkX192W1r4oJbJyxsQ5XpMN+4GVVQ88Oueu/Gx+o7ls1x2aGDuDqltAWGW/9nW922RQHQqLp06mYS1MVQeMzmNPB9yYXGpuVtWREK0Nxuy0qRGdCko0xzExwd7wrCDeE/LqQht451lrIufZoCByVK3tjZgwHvbtRN5S8KWLlRNKaJh/nzNEsQGYdWeR4pfHvZIFcPxOpVnXU3d5dL/iFfQeFSCEVa0sUCx4zuCO/sjiV9NrY5cJfGXlBg4za3rgLuTfgXHgOmt80J7i+ywFZ947UxWkEzFCpMqB7uv3g83pRRpyrrd1cUbFc238yFeaCdVPB6PCA2PGOjP0PihkgYNkE5AqR48ycG4IwFEH+CKm0FwN37NGl7NqybbAA6NzUKicYX88smAXxmif6POOGYLzcYzC/C2McWWqLULXf51xLRC+pZJdjPaqq8DitAOdgaiQd4D1nZCAG8lWNoPJxz9s/l352KdXuPePQZySZoRanO3zs9XtSXMaDEyVpuFZ2IYxnP4cMGywaKxofpXFe/bn1V0xc+dfRn84oFFXWQ3Z9pFGSlhwZBauM2TFVCnBuutzE0+X6TXJpT9FJOxkHHNUnR8bscxWxULnuitv4zVrrh5FjMmOl/ODchtdAC02XU1L7jow5I4ngfzYhjdmmij48F+AGK2GfwqwPEHSXwdVElDlFFyAr6mTjVxpjBwSK9hEmRu34eRWfsmPueNUJteA+Ff7EkGuFLX5h2EpIoBqGOl3tr1eT8iFLpBE7ucRA9omGkNbp7Fs69aRMAnsJWamPIVGl0kWY62QdZl6HipTit5B3tVz4kdfVW0/KZqLmlYc26HGymLsNQ8GZY2OKUfa/ndrk2bo+c6LilOCh06Z2rUyvRFWKK+Qcq8bBwZZOiP9aZ5+0wocOcyh7uzmqSzaCK48P19Yz9sJv6tkCEsAC69bPDz3LLHxAQMz0pdBaYR9KUSQfmGexe
 bPYHF0Jf
 Tn2zykZ+Co1vd+D36x7seznVY5Sp+qmXQk/XpEnLgX7K0IzWlKONf2/MD/cHoW1j51OqlYwE6OQACgSyY4/RI73KdqE6mxMyDlU2qeKkC2SbhrGow6Pm1U3BhPiy7X82arWhng8meJt+gpts09Z0w8jBm0fBJCjIRCTvqnFehhP5Ev+SQOih//bKNDvu0Btq5QhUrADNArFxLlGOZwYbg8wl6/8DEQUZUDKc/o1lGf/Sy+mEwDGXYhm3qJU81VWv/1ROSD16eU34n5OpT4YbMRUrjjbI2uYRGTYOIlT2sKjLhuyyGgxorbOufmISKrg8L1oajfSNSd+xWzjzgWuDLLbdL4TwK0lKVXjFkxo2qHReXEoA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 11:48:35AM -0800, Joshua Hahn wrote:
> Unfortunately I think that this patch is still unneeded. The variable seq is
> used in two places, raw_seqcount_try_begin and read_seqcount_retry, and nowhere
> else in the function. Both are guarded by if (gup_flags & FOLL_PIN).

Yeah, historically GCC wasn't great with that pattern.  It failed to
notice that the condition was the same and so there was no path through
the code that would use an uninit variable.  Hence my question about
what compiler version he's using to see whether we can disregard this
because it's an old compiler that we don't support any more.

