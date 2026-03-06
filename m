Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55826FCB621
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAD656B0099; Fri,  6 Mar 2026 11:44:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40E06B009D; Fri,  6 Mar 2026 11:44:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85BC66B009E; Fri,  6 Mar 2026 11:44:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F8386B0099
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:44:14 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08221BA376
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:44:14 +0000 (UTC)
X-FDA: 84516210828.13.C41E9F3
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	by imf24.hostedemail.com (Postfix) with ESMTP id CD8F4180006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:44:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=HJoc8+If;
	spf=pass (imf24.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772815452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CFRBb5lEm7w27aaK+Lcy6sw6cbfVPzK3mN+ShFsf6mI=;
	b=sP+hY74D+Xws85XwJ8YQSJmKJbUa7XqAb8bp9J8H5EYb0F9OYYIDXLwSK33gzQsigviwFU
	wxPqb3InWYiCo9PhLPJVAlBCwdMrABJMjtuuc9yDWvG21v/BWBZogAVfGd2yYYNbCIoc3L
	moKMHupnCye4M0Fs2jRfAkIi5opHIJw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=HJoc8+If;
	spf=pass (imf24.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772815452; a=rsa-sha256;
	cv=none;
	b=3/ffpI9nITpsPgOoiLktkf0FUxUXl4tQ1GqRw6HAcX8wmP0EL43QwgIlEZ+hSUfhffa66D
	CoIGrspJYffTY6fMs4V47e4tn0PIB7Jih/5Ti3oJcKraiZhA84Y7zpTKmws+D+t87Oy8+b
	+x4fuhHbzoqv1ldOm+TptI+nvWmhqPI=
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id C3DB126798;
	Fri,  6 Mar 2026 17:44:09 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id svw19_WXS9CO; Fri,  6 Mar 2026 17:44:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1772815449; bh=aiJ6HXP5kCacUDRaAKpFlRAJSn1zFnxlnfcHt7afV9I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HJoc8+IfvN0CgFey940Q7K9ddWRhGHjx/tu5AW/Q+UlbrF0GIGLOeLWEJwBlMEqf7
	 SP4I8vLfpwRgmAVXtC8s/uDRmzsSk9Hemu3dHgF75CvvGeFBNcrcXnublJyvVuKxfo
	 GrRGrQcFjQ+odUr5Rjkkg2GCojpMCGHhcJ+MWq6r10pW3QNwlQO8jix7lzRh5i0iHq
	 TTHT/pvWfqvvGU2/dtkdzKK5JopVQouRjDhp0MVwtSPaCzJ9JFQfPs00MVWpNQhaDi
	 FWPLrV6hudW1HpsaXd0NAIhkZrkZs9EsBtHgqit7AcZNNOIq/7oOkRvUljG33UB3ao
	 hMfgY0ZP++gaQ==
MIME-Version: 1.0
Date: Fri, 06 Mar 2026 17:44:08 +0100
From: Benjamin Lee McQueen <mcq@disroot.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R .
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3] mm/vmpressure: scale window size based on machine
 memory
In-Reply-To: <aar4T90zjolmTGFa@tiehlicka>
References: <beab70d3-470d-46ad-a890-76fabe49272e@lucifer.local>
 <20260305043038.2176-1-mcq@disroot.org> <aar4T90zjolmTGFa@tiehlicka>
Message-ID: <31c4680848b833d53b1979b45d5a368d@disroot.org>
X-Sender: mcq@disroot.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CD8F4180006
X-Rspamd-Server: rspam07
X-Stat-Signature: eymxzbzns4nztan9gaz69wpjrmtwmoox
X-Rspam-User: 
X-HE-Tag: 1772815451-982510
X-HE-Meta: U2FsdGVkX19hLQNtu07wqYzxWQesijb/tqTAeR7Rr+4a+ilWt3Xl0+aJA58LnjtKY/HeRI6HCoY+ZWeljg3fJvRHkyHSwykJNAR2FN+9pzsD0K9hrIpqy51zWnCRPrjuZ5WXsGC28JiL6Lq1Jtgqoncu1b5GNS51hrEwNUsgsmi+3ksPmQSMqpFZ5xHR/FnFP/fDUeYYWFzIVDtHZ/+uoy5O6TNz4i+xmoZCS/LcqmgxLkB0hdPkNIN91fOmRUv7aMS2YVvbfCTtKU808CCUL2JLrBfhYIcIuvXZqWFf7UpNHKQs6uvfDpDI8QtE66ajpZ47RBaR8kAM6uWyDDd6NzQiG1iIppjEYasbgOyxtKjyvD0fsm8tjQDnpgAtWf678GQT6vmydvg3YBfMffDwjZu48REBlCyVVN54ThzDhUujA6CmanDeJgOJHt0HSweV9jnGQkSlBan6PBi/bDOJUJlsKkRedg4/4yE522msebyHupd6zjwgc7MKzbAkCwrnF7fWCaRBA4gw0fzWvPG5+LICIDNBbFWf4XZx7eV0UfDE2TvNdnoAmij27LCMcojXpJJBfaEVbgZ5EbqGZwhkz1nB/muh5mT16+cBmlyoFeXlf3l6y1qKCOidg9lpfUYR+ualvkzbrQkTVg7SLR038ShBNQE/EqGIbHF0MWzlutzBSlhj0geyLqJ67syyzNkJs1oywdVMOPpHaoylN6i+RJ0PJuJET0BhnOH3FDFykioPyTguDQULU8yGGN8avQSK5Es0PHnuTvccI5czq4y1/fxWgILIuEtQOWqyrjd7D4xZ3bCKiwUfR+l+Lmb8dt9Xr1FuuzQet0mdppkrZtghO07w7n3MkboQ8hOQKpMG7BXGgA5ZNOOpqY4FTbtDTcExcV5ZVn3pLQNIgp2K9ufmQPicHJOWCEJTm7aFErckw0A+w9VZD/8kQv8s4/VR9O6cpHejL+StMF7utcmK3ug
 s1Pfmn3+
 gInKg3AYTi5nRRp+jhOmnJUQ5oonpYMwPpF8KQWiWZ+HAp5vkN7aUx8CIPXydx6JpUFxNpRhSOd2GbL4BmTRtktmiqo3Mbc6WDlmLVpWRIsW0QsPtFGRkMk1LWDv5DXqFp3GHlEgaR8SNpFDO1tcCUtFTj9VebX0wWPiOst3zhp/t3bEH2Loe7bQt1Zq0pEt5BouktQbeSfMcMEwPpVuA95hlaTjJohSwO//A9abEdqcuLsk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-06 16:52, Michal Hocko wrote:
> On Wed 04-03-26 22:30:38, Benjamin Lee McQueen wrote:
>> the vmpressure window size has been fixed at 512 pages
>> (SWAP_CLUSTER_MAX * 16), ever since the file's inception. a TODO in
>> the file notes that the vmpressure window size should be scaled
>> similarly to vmstat's scaling, via machine size.
>> 
>> the problem with fixed window size on large memory systems:
> 
> Thank you for this much more detail insight into your thinking. This is
> a good start. I am still missing an overall motivation though. Are you
> trying to address a theoretical concern (the said TODO) or do you have
> any practical workload that generates bogus vmpressure events. 

yes, as i don't personally have a workload that explicitly requires
vmpresssure to not generate bogus events, it is still technically a "bug"
that can still be improved.  i believe many legacy systems would benefit
from this as they still use vmpressure notifications.

i agree PSI is the preferred interface, but vmpressure is still used in
other production environments, like Android's LMKD, right?

-ben


