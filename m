Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B952EF483F8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 21:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 031C36B0088; Mon, 23 Mar 2026 17:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24FF6B0089; Mon, 23 Mar 2026 17:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3AD26B008A; Mon, 23 Mar 2026 17:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D68BB6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:08:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 823751A0CE9
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:08:00 +0000 (UTC)
X-FDA: 84578565120.30.1F547B7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id E158F18000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:07:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RFZdu4G+;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774300079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNBJuuzzq0GPbd2BLBr03j+XIuHlYuWDg25dI5hkPwE=;
	b=PbYD8qfcaPPMlP88OcNM3CcSxyCvioS9Wn5s9744qiz7aXBBHSd4CEfEMf3TFlKdifzKhs
	Ox6eu52+TpNnX3+FK/dnZoNFbJMOaJqXVho0UfXCTDjbGe175/eFlBJ7Ygs3kwwg7/VaIT
	c7r2ONCyiB3fSC1Ujxul/aWFqJ3lqnY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RFZdu4G+;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774300079; a=rsa-sha256;
	cv=none;
	b=0srdVEbSgDTsPAWnd6MUO4E2KeE+Ya9t1Dt3zytMBWjF5DvUgioLUgWvUFYg0J/ak1OQav
	YMGrkCb1KvtCpYcZE2mrR1hk/QG6UoFJOy2kMl01ma8e2eURvMzsxyjT6y/EiBKWMmB9mI
	LCH/SP0ae2t0EmWC7AmqFFJxvnhbnfI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KNBJuuzzq0GPbd2BLBr03j+XIuHlYuWDg25dI5hkPwE=; b=RFZdu4G+/00qiBpkU8fCw68Rrm
	W21rPmkkxyeKei7zPQ6uFrp2Ilx/Ygk8xHRAFFNsfW/OTOcLGh88XbvHxkn1siM2RE7hhwdfNiKwL
	kW6sIpIjUmF7cVGoDqi0UBijZ+pECnyIfuo5Vel1dAapffmjCAD7Wz7IUqvoVcsVhlCa5gFNw2zc7
	tOBW0lRvr92PV2NOlCMtO6MRR6cTJtnNTGP6Q9gcvgfA0IsLjFsneRQ63bLvWtKJxnhNO3Ppr1cmR
	LOdsbhkMZ9gjCjgF/7FerOwR9HbMfmtljw53vvxc2Zsid5VhsSG0Wvq6dX0TskhRYjxo5LeOPkNvL
	jHKwwSVQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4mV0-0000000Csy9-2jBe;
	Mon, 23 Mar 2026 21:07:47 +0000
Date: Mon, 23 Mar 2026 21:07:46 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 10/11] selftests/mm: remove READ_ONLY_THP_FOR_FS test
 in khugepaged
Message-ID: <acGrokwjvIHqDmSP@casper.infradead.org>
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-11-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323190644.1714379-11-ziy@nvidia.com>
X-Rspamd-Queue-Id: E158F18000F
X-Stat-Signature: c3hcjwqy45imwrbk9e9r33qbg947f5n6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774300078-960810
X-HE-Meta: U2FsdGVkX1/WhPxt0ErvQ4Ug3qfkt805DQfGvMSwJsXIm5s89VFgzzzbkJGQ69Yq78pyNobsRfnDuFWQIWpFqEFr1Qpzv+NuzLHpcb0yXWU35aMzju7VNhkb+Wf4DGTjZvIO4cvmOaSpVbY/PF04vIm0Akg1+/JG3jSlXp2JZ/Y+UWeZeK6mX6zj012G2ycXXSXw94oh5x1/cOIJIQnHklHEcEQVOIdGGfL2cPlK98Cvq4F2gG384myxusKW36mQaai0af8YwBv+1jPv5Y7AP1YutPZ1KxH2rBr/cKuPdr4pgTBuU4FByuBkaz0maEUPnV5lWY6gk+MAL7HSIU0+7X/Yik9azTHtTRU2VsQzDHH/+U3CTZ8TdjWaMQ5WTYXIUjrLXH/7Q8v0HU8CPyQ22TLfpNMSSJ+6TBdHWk/I+puveseeHBV2Vv72tUwkxT8UNfyoy2s1A999Z5WFiVbDKizGXJsSziU3vLTqrtNuQeUMt4X/FDqjVEvQ+F+V+QBtwXQvhtRWmfrs7GnOeFnOPMM6MRkjwMnntaH2fC+x3CC8OPKn852JFM9fw4qKt43TAmbA2DrgyxihC5fKhDUrnnOc6vpbDoOvsxidQVKQbUhAlwyP47QVWF4Li4G5/86vif5ujuI3hTXUEhyRGg/MNEkgN/oa/PS4C7TMXO5QSm8G68clHRQtx7nVIhlkArSiIaqgBygcVZ/J0lieOB1nJYX+5YkCCvsYPV+053IMoJN5zQlCcILf8kCnuyvFKWd6Kn7ekA2Qm418OwBOfRYdNUjCgRFyturCjDIwE4LA5KPMWF1Y3MfZi1a+Wnk1QvlGh+jz9v1Xv58G81XW9PMYZrlBUda/kErV4YSs7l/0b3yVYwicARDOEX0dJxkbV9sYaj4p2DuZ1QmQaOJ/bPd6dcfnYulR0WFruALwEWaTxs5s9org0PAnFlwChIhBOtR6q61MZlJTj9wS8ygKGre
 yc62wcvZ
 nH2BiaDqB7LcTEZelp/9ohHzGk7u1ge64UHX17D4uPUNPMKxAXsC7aMU4ZJ4nlAmVaT8G5d1I2wQbBLIi40a5P8+cEguL/ut33Xopcy3Zh0bOyHxakSwUgLL/vUFE7OQWHP/bZqB+8yJECNXE4O+h0xI8VaLoDe1hCeyH84B+ir+FGtBbYW+KFHGBg1/ePsQh2xt7bAi0Ti0tuJA/IKQn4XfrQaNz9C0jrACub8rNuw5ksC7owIc/0TmGFcVXx4qz7Y+XSYm6d+SJVcsXdBUPisyhdlO938Jj+cdtWYo/T9Rk1Qc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 03:06:43PM -0400, Zi Yan wrote:
> READ_ONLY_THP_FOR_FS is no longer present, remove related test.

Um, surely we want to keep the test?  It's no longer conditional on
READ_ONLY_THP_FOR_FS being enabled, but we still want to collapse
mapped files.

