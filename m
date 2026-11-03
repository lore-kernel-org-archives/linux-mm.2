Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D514606EE80
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O0Si+w7q
Received: by kanga.kvack.org (Postfix)
	id 05D586B05BC; Tue,  3 Nov 2026 04:51:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39796B05BD; Tue,  3 Nov 2026 04:51:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E014A6B05BE; Tue,  3 Nov 2026 04:51:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAF346B05BC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:51:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27DFE160398
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:51:11 +0000 (UTC)
X-FDA: 85393339542.25.F43A519
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 276B8C0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:51:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O0Si+w7q;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793699469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=egFZ+CUkcSsEU6Plv0bPxdEnwjHAJmOsofwONArJtfE=;
	b=OOneGRvOmIFx6q+6w7+w1zmIh2FeBp89fzAt//8sxhPTKaqJynXfLoVK96NqrtfMJdQcfK
	+RZW0XY82+EXf6P1Yx7w/qz6FJfTc0gLf6t3pQsVokc10lI8o3kml+J0KyO/unRHYR9JiP
	r4JubJeRRqTddU3Srlnv8fVhag1zQL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793699469;
	b=x7NKE+089/LmzxWLjR1t1IzSVeW1/Fa0bdtAvnCs0yo8dIc3sskSMuvI0uK3kZR0EOQs93
	o8lOER76eb6YJ1uJugfCfDiYtWaXgTTaL9i9ooLAefXwADsUVUFII/jOef9st5Gu3mLM2b
	ClEDOb+zKeJ/WEilOzmTDI+4xMPkMpE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O0Si+w7q;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 191D443F7C;
	Tue,  3 Nov 2026 09:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE14B1F00A1C;
	Tue,  3 Nov 2026 09:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793699468;
	bh=egFZ+CUkcSsEU6Plv0bPxdEnwjHAJmOsofwONArJtfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O0Si+w7qQU48iOAROrEodVnySMaj/guHd6/W88us2r8ZRAO4Q+C+7sLJAf1kJxt5y
	 qSP05yf4pmmUWy8Ibd9AWYba6LMGF7yDFZN7Nw9nPw+nFGbCfXWeySAEYrBu47wxlO
	 W4UZNyHQTv0CyBbjpdSIhjhBTy/VKq1s3+MUkMHgMmDaCQfcJy46MkA4AF/dmIjwMF
	 CkVCHNHHIgMCGjcxPMwonrN5yb+ba+vIVB3vcFROdXgApLvZESvRNYmt65PbrH0c+S
	 WhrDyyUA+g11fbwY4ec8gsQkxRmhoC/xywBGn0BljwHmtGHTQKAfmIm35j+PLdnxA3
	 aWrl0WBcH/w+A==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id B4B621980052;
	Tue,  3 Nov 2026 04:51:03 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 03 Nov 2026 04:51:05 -0500
X-ME-Sender: <xms:h67pal9ZnLbWHExwOAy9SGfyqSpwEUA3NMoQdTM_tJujWsv3OVjV0w>
    <xme:h67paicDmptRKFXkjwKv0nICnqf6UGXUOBoNs43PdN6dDU75HqZ_sRU53pb4eCnHZ
    NyYG72C9VWjHhnBKO_6yXDQ_XgwcuqbqayOrtgsPfmHuMB18PoKS6SVzw>
X-ME-Received: <xmr:h67pahuB-6My-vFtxfkBuHVD9wBj-SrVnKtNnHHVEzPKySakCJ2-hDMjBUM>
X-ME-Proxy-Cause: dmFkZTEafPFpDsB+iCHvxJAO8+/K3z3CdRdJQPrpIxEVD39bmGj4/U/LJCZAd51olEmH1k
    6qE564jpNX+1TdKbvOIB6IQqoEWMe6lmfsHXz/7H5av9n07ycVm9KaqNAIFuxM/2yQ6ZQf
    2WwWRfyTOBvsJefTEHwTSIlMEprKmlBMCaMQEiOCHNx9GlqItvdGfsqrXvTSv4YwWhfjog
    Hisq+Pm0kPe9yLdILX1nzJHxDiI4HZI/f/WiRyVg1IU5TnSyC+qdCi/OaPKH/o52uYw5Pg
    NWBfdHzJ6Nj9gleMoUsWymwlxC4s3Xd8EfbSP1s94cT1TvBMvX9Px0+DW0sTMVcz6ljQEA
    bNAqnrXT9kSnldOc7GBnoXknTZI4CrGQbGLxz5gcYZTcqrYDenzWioW72YDipsFCgRr9Nc
    uHBP0n3wHEHm0xd1bC4PM449f0K6KLv76IEdnFJtRBmsT/86yFTF/k+YNA7ynRtyx7gRna
    Kdv04/M7HAJayP6d0M6sfwsmt2NxrALe4AgmeDI6puNDmrhfuTxLwDKsNAcQvOKadj7BTj
    haYfLIDqjkraFwT0ww55Xb+vCFS+FGgc4wHxE4eUt8EVIgb2JTv4LQ1XW3ZWMb1d2KhaT2
    PU8/KLA1icWuLdOTL6ghs2iL36LEgDAWlkXyHmhA1D22rcIIoeNo1PaFssdA
X-ME-Proxy: <xmx:h67par3REpkKj-iFbIx6OpMTiClv6JggmrTZ2vnL95mTjoV1WnqWTw>
    <xmx:h67pauDaZfE9CaGgf87_XUEHj4UdQQBG6yShD9rbXk1nBnYJmINEwQ>
    <xmx:h67pagcoelXpPMERwyrq_euIeL4P3SsGx8hAa2itEDWuoAW_H3ASQA>
    <xmx:h67paoxeEzN5MwZep7_7iT4Ux1UqJY_4UkUcxyapsgxs5qXS9IeIBw>
    <xmx:h67pajNnJMxSw7lfAbohqfwd3JfPbixn6e8WbpqRLjWogVqlRQ-CqeHQ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Nov 2026 04:51:02 -0500 (EST)
Date: Tue, 3 Nov 2026 09:51:01 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yeoreum.yun@arm.com, ziy@nvidia.com
Subject: Re: [PATCH v2] selftests/mm: handle child status safely in khugepaged
Message-ID: <aumtBg9KOgrY9MIe@thinkstation>
References: <auhvkuDO8cP9Pip4@thinkstation>
 <20261102185130.30504-1-ampr.mhd@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102185130.30504-1-ampr.mhd@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 276B8C0003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: j3ifmoncryartdbopi9tick7o8dbw6wn
X-Rspam-User: 
X-HE-Tag: 1793699468-273605
X-HE-Meta: U2FsdGVkX1+MR6WTIfHwc8qI6NEq68xTon9cbWY1A65Qjt85GCudGaPoXstIqIgDaaqVGHHOPFgbYpQJlXyKPJyO6cHud7Ij1NUFewp+5V086EMHMMgHBZ46Om9Cp99GPwmHRuIk0Y6OpZE1C4Z04/MYSAPVVuROd1ee6wg9e8nk5MV+x+nE7T0j8ZLv3g2lsYWUu1H7ETledIwaGLr0QCHXSjKOXVDyTa2DJ07pRPvfxjpY7JFYI1KTpkmoCNQqzH0TAz1U5nfzaIsx04/z/+Xq8MWnuWZ38ekrcZ2glM28SRhHwVit0qlssZ6C3Yer+l+0TLJWl/0+rdJNX262Nrcp9FQHv7YstzK/Uz1okt0/Syy/Cj8tooDkVDtsx0VjqZK2201kTVFQdKbk1IviuqTPUPd7nHtRAyS5jogp6JZnXItaRiLKlcuMQoeB1G6TvwUbW6hhoHABcEL26dyfI1PJZ0Qe4iM6TLr6bxHWPqvdadLXoRZmfdftEg8865INNoBf4YgxprobxD5GDeWm7GAEq0Ee6ZPGzX0qR7q8tHb0FSTAduRjuCbgD36KMFRoViLwoG397iQCSkc7/v2Kw1vxYVyYabhikY1Jmh96Qni8nY4RGWFUNJOGQHHyCXe7uEKJ3BqxWoj9xd7gWxm347RWbWCqzdhvlGkPqK1mbwfA75kJhIZRyl7B5IO/hjBUoDiSvf5JuFMy6GE8smjFBA4AG0oJApSTqkXxfGaUgW4NFBb+9rpyUhmwy3Y6TelBv4bELKgW10wat+OpVRGYgsAQOgwQ5aDkafPFnaDYOybqVGkqJMYppqMd2nW/O61JLvy4aMux1NugHT9ZE+i6nkUTgWT5L4/a4v1zlYRp+OSZwJw3DblLokceFRnhwNv5uCvHh/vwPmdo8zRTiSJW11nWXIY2fvEPjrahQCaFqnH4m/N1it85zjF41Q/ZUass9EfPF68xthHcRrcKbag
 OrAnPE/F
 d9/o2IQmZ7HBkL6EpXKGyzlxXBsbWASuKAAlQame78pDlo6HCoeY1wSXI4ygRPyOGmEu0gzvC99PEfcgXuM0qDyTie7nqjPNozjad0DjJu8Q9HI6laVcB/IsMbo9K1gj7vkF1WkfwhF0z0biqDxyvS7lLdcGyrU+AOyGDFVbISnjJLmaWrQ0DTIOAL7zqaFy4rEf8QnWV1eUIvmhYCX1GwqFVfph9xU/aafnOqDTPOk9l4fz3rVJ/4PM5FCGFR2hepon8N+QZcXxH6b0FcBPK/P85ZKjLcwp7/tD1hoLbSROIlSAaYuwTOG8UYfQSnfG8SszU5phCHszhrQ3bXru1RD6hcLNqJFb20id+SxgBpdng2ieuTh4l2vtV1g9sHftzLzLt4uFFAGzC6umAkpfJCLGQdRx0UcULU10VU0/MC5Gzymc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 10:21:30PM +0330, Muhammad Mahdi Amirpour wrote:
> collapse_fork(), collapse_fork_compound() and
> collapse_max_ptes_shared() take the child result from
> WEXITSTATUS() without checking WIFEXITED(). For a child
> killed by a signal WEXITSTATUS() is 0, which is KSFT_PASS:
> the parent runs its own checks and the test reports ok even
> though the child crashed.
> 
> Fail the test when the child did not exit normally, and print
> the signal that killed it. Also fail when fork() fails,
> instead of reading an uninitialised status.
> 
> Use get_child_status() in all four fork tests, and use
> wait_for_child() to handle fork() and waitpid() in the
> three blocking-wait tests.
> 
> Fixes: bd212a7dbdb1 ("kselftest: mm: return fail when child test result is fail in khugepaged")
> Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

