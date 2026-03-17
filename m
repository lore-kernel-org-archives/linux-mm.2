Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A11BAFD707A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5786B0088; Tue, 17 Mar 2026 07:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7EDC6B0089; Tue, 17 Mar 2026 07:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47006B008A; Tue, 17 Mar 2026 07:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD276B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:04:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54F59C24AD
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:04:24 +0000 (UTC)
X-FDA: 84555271248.24.93C4A32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3C58F14000A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:04:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CzqjY0Gp;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773745462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feNhlZakbRYDJtWwge52jbrFTlGD2WIO1+iPdyuWmss=;
	b=TypEMDefpIBJt2QdjXdS7Ok38zQmn5lLLNDTbJFcKoHT+K0Su8vhMzPDOtWZmKXvXROIPB
	A66dzK+8SWOMvvHw24zA3EzITZL/2LBKtYmZ/ul7G8IT7Hji6TAyU66wQoA3unGg6cLukp
	92m1TyJbDAk63ogo00BZ4RNSRfUvwSQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773745462; a=rsa-sha256;
	cv=none;
	b=N43ycFy38tRTWEYeBD4bzFvKyZ7u1AFy1g3Wdoj7IEyRtYzOdvFDRsYtz+AqQM1oZ7orcQ
	v7snruCejlNH2699ZiABbdJRYUv33bVoJnoq6zGXr58VK2TRVgSJj5cEgevAGgf5IhnPjy
	KB9e04y3F9F5DqHYOifAlwySW1avVwA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CzqjY0Gp;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CCD64170C;
	Tue, 17 Mar 2026 11:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C76C4CEF7;
	Tue, 17 Mar 2026 11:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745461;
	bh=FzN+JR6wTdlWoYca/iDWtBJ00teqmkhdZDjQECTdE30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CzqjY0GpYRBoRH5wfJ7qOPgfofiRN3ukCODjKqJ9Otaoj5ox0eR5hogOK9BhTiIdC
	 HaiICmEpGcxK5rPTcirhIp7HnQ0Vowjb+FmsAJGJRZzQwuDqULh31j3ENf5VTj4xmv
	 dqT1UOqBkgSWTAWbgKE2VvrXBGE7d1H8LIWeIHhcynIPPNFlpON3BdTstI3U+abwlb
	 NOeju95h6yOj8SnR4ot4yLZC9vii4975H7Wk9sjdr75PeqEiG25fp732DOlR5TQduu
	 4W+yiV9Mhq5WWjCn/dZCJWutSSeMyV814jn5Dms4tAT3nVD8MKm6DNUMw9s0FOdaiJ
	 DfCY9fH/rgJfQ==
Date: Tue, 17 Mar 2026 13:04:15 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kho: drop restriction on maximum page order
Message-ID: <abk1L_gpK7Ys4TK5@kernel.org>
References: <20260309123410.382308-1-pratyush@kernel.org>
 <20260309123410.382308-2-pratyush@kernel.org>
 <aa_zglmh3AU2_RA0@kernel.org>
 <2vxzo6kmddl8.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzo6kmddl8.fsf@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3C58F14000A
X-Stat-Signature: 7t3oscwobfe7xzkzi3od5ph6uyqzkes9
X-Rspam-User: 
X-HE-Tag: 1773745462-611524
X-HE-Meta: U2FsdGVkX19jdlgXb4wZaQE948QJT36I+9Klfp0vMTzA/ykINToKvsYk2Povz+alRm6r6bNQXLQKNE9cV1rsZgaBvkivGajkt3cammpKcPOdMlXzs64ajJrRa9NgXvIhu1xkzzL/uFEx1wl9/HGdd4fZ2pSN19MzxBsvXCOoD9khIuED27aCbuUErWZJMstFt55FzsDH/b7foOHcWWfB0SjBZLw7Fh7SdRf4xbacg56YLsISeZC90LFj3Lno8JRNBzHwTxptA1jKUF0p3T+ESKMWdMdQtnzLE4Ed9ergNH9nOkZwH0qOiqim+apVhmQ9QEpZzVKe0QyFxLNi8tBwkLM4pQBsy82hH5Z78mx6+NLUCMjkW7yci0x3zCrGQShk1fkpHtx5xswKFVbQsa16mi+6mN0qkNWked9am4pvBECzUgGaSnOzKtedLuprzpeN9L8rqjj9I9obXelRSQD6JAXSNHW4YDMtiELbjpBGrV9CYORJrVNHvnlNvsf+Ug0Q4ZzBCxJtIrCj/6EsVbyd9pcOsJ9Q1lY8sU8On7ZoYEFV6XxZJmhidxl5MfUtoXlmwWRV81rJFEeXA9ihIKGijvj5PWbW8xKDkW/WTykAojJStjqPKvupPWnyW0JtkdQ7Hob3QQcr/fMynutIQxKtZqVCXoRmoJMmST7GGV/5GVfQq9ajzaje14G6bMsvVivyvCGLUFGOLmX9Lyu0xdK9jyIkJOjM241liRCCQs4MWUd8SKudC6zObZzz3QkbbM/DzexAaV4Qo645feY6tSBtCxCvRRkNJgbKds1oRN7eQIZAIU6fLdwz67PPoyTYrvUsG43IFqgyIe5wPgDN7iGAc1f/4iVJz8IV5f8MxzYiGmZXU28x1+A+TDehaDkinaShVOB9h/Img5AURQBJnH3Q94lTMVycVAysBJTAOhc3QF62UF96mQsDXlgXU22YJbEe3ygNrN0mbkg1joIMUYX
 nTJxV5Nh
 c8UsjsbrZALyXU/RUTQrmod/A24xexYwwzggDqp7TZTtS0K3yw2FQQeWAQ0GqdKM+clrXx9gylO/+aUVqGT6rG/qnPhO+0asbTvsW/g1U9DCxSOxPsofWPlJI5hzI6JChrOXYj4AMMDIHtW+PM91l+GJlVctcjzoUSJzhQ0vIOF++V6ll0+OMk4Czyvc+zy6WACG9IxK2lWlCdYubQZXUFO9K5u/CeU8AVleEIV75nR/Dp1TLfyxiuVN0K1kEO6DYHWCwh5M9hW0t1T9idFVlvbuSnWzJO8LiKqkiylFK69uSvHbBuoyIDPNTtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 09:12:19AM +0000, Pratyush Yadav wrote:
> On Tue, Mar 10 2026, Mike Rapoport wrote:
> 
> > On Mon, Mar 09, 2026 at 12:34:07PM +0000, Pratyush Yadav wrote:
> >> KHO currently restricts the maximum order of a restored page to the
> >> maximum order supported by the buddy allocator. While this works fine
> >> for much of the data passed across kexec, it is possible to have pages
> >> larger than MAX_PAGE_ORDER.
> >> 
> >> For one, it is possible to get a larger order when using
> >> kho_preserve_pages() if the number of pages is large enough, since it
> >> tries to combine multiple aligned 0-order preservations into one higher
> >> order preservation.
> >> 
> >> For another, upcoming support for hugepages can have gigantic hugepages
> >> being preserved over KHO.
> >> 
> >> There is no real reason for this limit. The KHO preservation machinery
> >> can handle any page order. Remove this artificial restriction on max
> >> page order.
> >> 
> >> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
> >> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> >
> > One SOB should be enough ;-)
> 
> Hmm, I figured the unemployed me (who originally wrote the patch) and
> the employed-by-google me (who is doing this new version) would count as
> two separate entities and there should be a S-o-b for both.

Maybe than something like:

Signed-off-by: Pratyush Yadav (Hobbyist) <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
 
;-)

> Anyway, I am fine with dropping either one of the two.
> 
> >
> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Thanks!
> 
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

