Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D765C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 19:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3CB6B0088; Wed, 23 Sep 2026 15:46:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4996B008A; Wed, 23 Sep 2026 15:46:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BAEA6B008C; Wed, 23 Sep 2026 15:46:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72F906B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:46:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF05A1A08A5
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:46:02 +0000 (UTC)
X-FDA: 85246057764.29.B366E35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 43824140002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:46:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KQsw85iM;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790192761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aVpa8WfGFX2pbLfLg8CDqkC1zJ+M/MISt4X62ud8C8=;
	b=UCe4akmRNJZfoVyK+Lzh6cxkivkJThgzjaombTq5meGxnezNC1RWPD6o7m7yfUop5Il/3Y
	wUVx29ScY+AyNlXPu/NXpduKisGfvBvxX4pvsp3OrR666pqrEMnBF+ntyLRkGMjbh02RFO
	j0hwTRBLYFQBD87Ydwrstv9M4HPVSfY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790192761;
	b=6AEPO+pcFQfFIs74rOl/yceGxjQ3XPTI6p9mVxhNsivdYGUVrLtuhMa/ATdFv3PY2PHTFG
	f2ojfQGD6KROOjnoO/Mek5wbyaNZuLdtNZVtq1tzwLMkTOQ4OCqnqM62J6gb7lRXJFpDLq
	ikAEeBdtYfwGqpR0HRDm61sy2jPe53s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KQsw85iM;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C276600AA;
	Wed, 23 Sep 2026 19:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EF91F000FF;
	Wed, 23 Sep 2026 19:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790192760;
	bh=9aVpa8WfGFX2pbLfLg8CDqkC1zJ+M/MISt4X62ud8C8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KQsw85iMZX67zfflOvv/k/8IXHZKNOpCZ65AtTIs53o9COFeMwrS/0vdEQu+s1Abq
	 Rs1W9gDeP7QGyNn+F83Xi1UDB06JTDar07KqEU9mBxuoIC9ntet9tRPWk2AsEjLMeM
	 oZPMyIiZPDJm7Vmo3rBcGgQ11oh6uEErTb0Movi4KKWyMgaww+MlLJWqKG8C+SzqTn
	 ncrO9/+B99nXnow5WjPNV7SnZdvtJ23mU2VVouP4snoR1L7ZuPMTtmGLB4xJv+FUak
	 H/dC5R8MsFiU8uTqSSxy+b716qlcuaCZTkF+kY21d5vm8a5nzZk+uvtGyXwx4ZQ/nd
	 6EBXAd/gMOKiA==
Date: Wed, 23 Sep 2026 20:45:58 +0100
From: Harry Yoo <harry@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] slab: Remove slab_folio()
Message-ID: <arQqdeTaYf08TYl0@thinkstation>
References: <20260923183655.3364885-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923183655.3364885-1-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 43824140002
X-Stat-Signature: dqwphxa7ygon1gk7b5uq5jxt984aftgy
X-HE-Tag: 1790192761-623967
X-HE-Meta: U2FsdGVkX19EheAcyFTGEnfcjNAWd69/rESfxRsjyypoNhrSx5Rm0UmWKi40euGAJyk6zHgvtyq6BJv+ibiqDVOvjBCyQvObc3mH1qKRbNWtLRDR0ScXiFKdC/PvJGoy9ZqVbX+HRRiWH/Y47NINdkiH6sefiejgc+cy7TKCteG1LEvVMHVRj1AYm+W2CnRG3+khM19gZ0/pHGisS+AUSc4ckT0zB/r97Yj8fIne8Je5OXm9ODx+OWX+vFQ9trJAaQj/sCymv9mC7sr8lPOWAUj/2xwyJ8Y3YFUitvz8DET+1wvZ7JBqUzITYQ7gVXHkTwxz03ma16JvrJNCdgkT+pIw3fKQHgxnGVQ1JHuuh4qTsYSbv6ZA8gGLG7ZKrAwPO2VhWTsmfLCxy91Q/KsqSDvi9q6GJyPq+u+mwG19NcBxrrPX89i8W4rJlDKgUvBa7pA2SA25w2BVy0tW5CJ6cdg6aedl7o7kXffYGfZp/EtLHqLdpaJLdSOgRam/uBmx13yVYSdS1ck1rVDUb0nUwa6ANObCFugPPoiiiuy4wXwu8WZukNg88gBVzrR7i4XLlvwddX8XTirE2katZkkVStpwDJpE+u2KNySKUckmiegN72nrPFuKsEbH6F+7FSmu8B5aGBtvEyV6ZsjA0qfQJpegW2B/cA0p0ncjTKcGTPObLncypDstlGpnCKaWU6ITxXbFQ6zQ+IrutNU1e9zURtdvMD3tZ5329UpeJT4107i1cMK4LicygZisrXL+Vo0via4Ukf3S8prXaDHguws3JJdSlRWh5O1cRVpjrFKh4BxXwNhU5uMpbnJi7WGAaYgkuRbdZuzaEKDtr5th+TzpyuCHULFuhmpSr8Mxi5cRd1RUOAAq3O/8NSBKsiFIm/v8RkLDEJ/Qn+NCq5j1fp170PtCTgf5FtBjWb7fWKKWjpmLTBcx/TO1NX5h6odS7+rJxjEEVw/1BmHAFzto0d0
 uCqGFtJR
 A8TDWVt81+lE/e4AWdR2nJ8VtaNM/eH72MS+hr7r2E6JR85lpqJbDhNwr+s6FCVzSfPVcDBYKHjr6mqjQ1az3ODuVGYCegHA/E0feVWmwgBGQEF+wL/iaAw+LUqu0PO9KoByF9DeOQwb4M10P5MknLQ1spZwtm8/V4ej9RuToNY14r6g1tvhh3O/QTKRqmx7bD2xGdmkncGRlZDI1Nnrtt7JoATcpEqtzVwJ0gp9ItS7i9jmLuzYSBa89dIOziDHEyNxK7+emYfzcjQjMiz6U5Hn/6/wCrvzj4SBegkvKSiyOQ7SqyZF/PQAbHJsOt39k+mCoyUKLTjqBpfKKlFbUTqt6QNTXpCNAODNaIMxHRFeLo7zgYsGVRKYEejZBEu/CPwLg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 07:36:51PM +0100, Matthew Wilcox (Oracle) wrote:
> This is the final step of divorcing struct slab from struct folio.
> It's still tied to struct page, but there are no more mentions of folios
> in the slab code.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

With a tiny little nit:

> @@ -184,15 +169,16 @@ static inline struct slab *page_slab(const struct page *page)
>   * slab_page - The first struct page allocated for a slab
>   * @s: The slab.
>   *
> - * A convenience wrapper for converting slab to the first struct page of the
> - * underlying folio, to communicate with code not yet converted to folio or
> - * struct slab.
> + * A convenience wrapper for returning the first page allocated to this slab.
> + * to communicate with code not yet converted to struct slab.
    * A convenience wrapper for returning the first "struct" page allocated to this
    * "slab" to communicate with code not yet converted to struct slab.
>   */

Perhaps you meant this?

-- 
Cheers,
Harry / Hyeonggon

