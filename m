Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71015CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 19:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD336B008C; Thu, 28 May 2026 15:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6DA16B0092; Thu, 28 May 2026 15:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAAFF6B0093; Thu, 28 May 2026 15:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD8E36B008C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:37:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C4061C0835
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:37:40 +0000 (UTC)
X-FDA: 84817838280.05.26CC008
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id EAEE9100010
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:37:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vbdVjCk4;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779997058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=365/QyEIbQHX23D/D0iz12r6u0cbZ1h1Iww4gETb2gg=;
	b=ItuRlJQbN9evbNzas+ccfNGL8WFKJFWLoXu+Q5JQCPWrjDVWU/SCsSgCXYKOtqHDC3o6ie
	m7kyoLMESYEVWdNyBJECh6hGSeFAbwywnJoiobURbzy/ILYeLsLuyW2OUC5vhKi9aka4IF
	kxvOBNGahcRv/jkjV4OmyEeFC/COdXw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vbdVjCk4;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779997058; a=rsa-sha256;
	cv=none;
	b=1sx+YKtrwloGC/8XeBdsw7KZrqV5MkSSAk05gYupLnDYWou8STVH+DIA7U4MJEE0w9fZNk
	wqsH/X6W9F6p/+v17O2x9hG7a3s4GHOAxTNvKOD/aZZYeBe3Mg/hFGmHrmLOa4KcstVwXI
	sVB+mtzZJBhiPMkyki2DnYOw8jFIVrQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=365/QyEIbQHX23D/D0iz12r6u0cbZ1h1Iww4gETb2gg=; b=vbdVjCk4Sp468Yol27/B0dNUVF
	R9slRW3qAWTf1TbHIty+EV6z5VOAjSRuB2MDx0igwR5WGUFk16saTVcGndZpu8+CDPqIu8T4070sU
	mT7iR8QdOSmbmP3YBcSTw4nNbcmSzH8/mKZ6eRgCQyIrl3MMIV8TZTh4mkudQKsUkvVZRTDBNP+co
	yVAZXCQwOrCMhEUdoAARSMZa1I4hRL05wKQzfgL0plmMIHftV317A+uZosvBGV3ZpX18uWPZz2OZw
	X2xclxJp+2wFC75c6jCXnMajvNteogK/D4LuiJSNNVcTwzu4RU73PUsknOgGTmFeuggOGVPN+RKAD
	E84eEQYw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSgXr-00000004mKt-0H6p;
	Thu, 28 May 2026 19:37:31 +0000
Date: Thu, 28 May 2026 20:37:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Waiman Long <longman@redhat.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
Message-ID: <ahiZeqgwUxqAOPiG@casper.infradead.org>
References: <20260528190337.878027-1-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528190337.878027-1-ynorov@nvidia.com>
X-Stat-Signature: yhed747bz7qb56mpj3g7fk85sk6szkwz
X-Rspamd-Queue-Id: EAEE9100010
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779997058-701920
X-HE-Meta: U2FsdGVkX19+N1MPudWetRTXhQPCv9EHnfJ5rz9yF1+1ahhNDOLImRdrj6yr7W4fLK6EtIOUy+hCy3jF5i76LJPxGbhh3HQIXoyywyDLnJayFA2xQMReXALvWf82vUp5VaeMBQkohrtA6qFB2G7qld2KglLZZnzBHf8FcB3Nc7cU2Nj6Hvk1Et4rGM/ecDQIEJq4JEjJ+MO/8KEMIYbencW583bhOuAIIizmTFJ+7WpOjs7zWn67kuegLDMExIk6ix6UiQR9om+OZUf/R2XMAYpp1tV6U9ufmfADavoahSH26Ns2nwwD+Hd8UggRWmeRxTtkDloVWCSbH+mDjirOT0+L0B/dWQ/92u/eDR9rFdcUwa8h9N/LUI5EeJwvq1TfB24tnxvOoxEDrNoeIztht4UteqMshpo1b1Dm+l4SnEQQ17N1JqCYZocKza+vhSSIo+S0yOOcZQdxvrDTG70mZMgpTwP6T3uwAiHqVONsTvUaVDbAHSvCb7CchHlHvQ8KdCJ1fbEIOZwDUouERMljBuK9tclCSL6xJfklYKtmNW2OIVgDnTRloQcDSPPSU/Zzrf3AjMGe7zLWv1oMKN8TcJU8m4J1tKRV+9Kki56F/hsc3kunEitJX4PkTzMa5/Hh2Op8Wsw77NNpMO667Rm09NKjNRbIzTxp44kMjZfPR2uLLmCrAspfyJCi8kLuY/DJe6uUAArEKKa3eZjugxHaXtMpeCfdyVBxSN4cNrZVBO18McLHe0oEz2bwG/ZWhGzWLU8Me6gEwXZitcqkuQXUJDNOHfBGR12LS3jzb+x2tZQ9C2q0XkWf8PqnDJ4sSUXwlv1I1vbiXbMIBxG0RyowsILW2qVoh3i5kllJBMhipKyf9pTOzpWnSpFA0yLpbKU0d6Oklz9MdfJcqqNJNJY29NZvLwT83ntx5i4yTSAS5BZw980jWsBBP6LycQs58Mv9teFTaJb4kvQTQgmrlM2
 5BPFKgfi
 rE+0fAHjX4/bUSq7STAYok9X27NfMo1PdZqzdeytcBIQfILWo2eKQt9RH6dVJlvesDqJdQBY2Zm7lV4g2x068QOeY9IG0CprrneuAR3InkbYhQnnXdyWSJiob2o5nwrQ+2TAvl5u3Zh+OzEC9LcBo71E2JSCiGZpvxUnCLsWvXlBfaEn80YcJuRaUheASINwCJiLtRegT0EJwETJETa110NrTbAodnT/oQ9fDyCRMNN28HF3GEbHgo6C9qPDSFo+xKC9srDU56d/rKM8RekKBINM2gsK6D96Ot4y+hFZlrvrxGH4VrEObl9CVC7gUibvTrEMFMebff8Ndhs2fd3u0xKDMZqu2kahjKXN+A9i8mxvlOqCCYCNRBkqVfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 03:03:37PM -0400, Yury Norov wrote:
>  static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
          ^^^^

>  				   const nodemask_t *rel)
>  {
> +	unsigned int w = nodes_weight(*rel);
>  	nodemask_t tmp;
> -	nodes_fold(tmp, *orig, nodes_weight(*rel));
> +
> +	if (w == 0)
> +		return -EINVAL;

... this doesn't even compile.

