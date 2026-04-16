Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E16F1F8A140
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 08:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4CA6B0005; Thu, 16 Apr 2026 04:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486CF6B0089; Thu, 16 Apr 2026 04:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C036B008A; Thu, 16 Apr 2026 04:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 29B5E6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:13:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2231160797
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:13:54 +0000 (UTC)
X-FDA: 84663705588.30.397422A
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id ECA25A000C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:13:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DcOhsUkb;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776327233; a=rsa-sha256;
	cv=none;
	b=WySIHJFASl/pL29OCiGxrPF0sSqQxZiOYvGQJ8zOheXqdGNwARRF7Itp4EVk6bko1Nm5fj
	d74r9AUUHUsRb4UjYOrsJXLUsNxC61VOWVhzORDDhoDdHKk7yDRcreizM58q4gRH1jJi1m
	K3dLWTpBYZ3B9jCVemoNMa4LHjuKgfA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DcOhsUkb;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776327233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLNrv+jbKX3dvT6t+AWEwUuCg0/1wdDs3MDa6W+BfeE=;
	b=5WaPI0Q2PX0aBnEYTPpckgiz3gfd98vsFljW+p0siF1fqv901/Bit3uuFL9ReXEOtx7HYo
	DfKIpjj/lw8LQUthSiq1TWKeK5IVzkBybDqyE4SP3bYgkyrkra7jN2MlTFeCqtCrj14r+x
	qaXElyIWGj3KLJ2qktMzNA65+Mhf2g0=
Date: Thu, 16 Apr 2026 16:13:38 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776327229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SLNrv+jbKX3dvT6t+AWEwUuCg0/1wdDs3MDa6W+BfeE=;
	b=DcOhsUkb5osvBmYgyMM+hgu6f65vYPc0NxEtxv8UEHHQLhr1aPCIv6e6MHO5XYMcyR5DCr
	mTGz5j+y5eRIChWjCubZO7EfFfFGrwcVROSbRvbz1P3q/4oNC29of1Xbg3tZPARNNAQncq
	/e9DzRwJarvESFEOTRaLYbyC6sP7GJ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [RFC PATCH] slub: spill refill leftover objects into percpu
 sheaves
Message-ID: <lmoogvambsangvnfnrlpey3mhrmkdnwtv5zcb4r5ej6r5nmhtw@qqgcmcfxmx3x>
References: <20260410112202.142597-1-hao.li@linux.dev>
 <ad39TJZYLItrEnIM@hyeyoo>
 <bbtmo4fffalhjglohnazrxvplzfxelmuivbonnbfi3gzsm7qj3@bvh42p47dsqa>
 <ad9mZeERenhwh7De@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad9mZeERenhwh7De@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: ECA25A000C
X-Stat-Signature: bcizq3whu1rz1pdujhrhx58ar5htzc6o
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776327232-361599
X-HE-Meta: U2FsdGVkX1/sLTikNAf1TUvucyR2VVRpBHEI+3E9oNoZcjkH0gc7MvC7zZ32117ZWN+Zd0HBFqkOqBoFA8zpZYhfTIAxiqbSCwobLl6ztXqZKYA/poDLaRLTAczgsE3Ae/yG9xbgsNP4RjJAk+FzuKOOIKw7aNQ8Ayoc/tjaxMgV9fSrxeamdIP90wSeI71ZXGuEKwEu96Gq9xMUj5bvDFUkxc02l8c8htogtNB0IoWuiswOiPRq97qa4J8/uUO3+KTEbSVTuj+QBRMxOcaEs6i/ONinUyL9b4iBKg+hjRPMN1s+Dbwc2evckgxVLmviYQ+crNVY7z6I25xAC69DCn4bMMuQD8xyiwDGK4pH/k9pYNpdf6ITpQaxCGBezZ7bAdynr0gwDbrNBpO0PjVXT6EX60ZdoFxcZOsW2kKOMhz6zSJu6WCb04WoWUudTKURmVJsjZVSb0hD/QOD1Vz/KqGyEInvCBf+lcx/fiLQqfKqYWvvomOOV5qLksZxwmgDp1GHdG0bwAJVkE6lf4B/H1MwzIR1i3/Lgsz7Yd883R6rrWcaEX9R4TNVVROG0QzLO+Ennht6IHgyEI0LFS1Enbv+1EH52BOH1xgdSSmL6IJAHqSQ8XLjwLrxjgoTsVaCa3m9Wk09lZzsQvyFekcQ/g8oWUVW9W94WGdOwMqXsEY4hIruTvRLDyI6s79kan9Y4SVnVl+G7rSU3T+HGNlhhJM1Zb0omP2irz1W2oHf+3Ng8Pc2BRRj1Tchd0deJA43fjeRXwJIZ7+7NIWKg2o7h39Z6owjtaMV3wqSreOaT4EWnn+FnmKI69gKJxiseBYdNOixdDr5KmWTgvls3m1vPIplE/oQK4k5S+5CoU2g5D1nogNApTxlDSknABDXe7oQLZtUHd8Nkta1iufbk5f4whS8leSEmtIMoGKKcet7HmMjaBh1huM7vFQvg6VU0SGuVHbeSsHYYteBsXezfJG
 +kRAygD6
 z82xLXcE4B+SoeAAU3pAX/bxMf81WLRq69JZKGvBIzQfYP5Q1Q7+mTVo0ze1bjXUbMGlCHSIJBGZc2KI1ARNgvZGuFrh7JYdsRlC0Se4jjmqEXhE3uwZ52LSAeGlTfT9kpW4PeNvMSSLAPbLTxYWfqX+aI/+8DChWeBFV7vjwZrBi4xxv3EIFwXbs2+ChilB/bb9QgcOo70InkYo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 07:20:21PM +0900, Harry Yoo (Oracle) wrote:
> 
> /me wonders if increasing sheaf capacity would make more sense
> rather than optimizing slowpath (if it comes with increased memory
> usage anyway), but then stares at his (yet) unfinished patch series...

Oh, take it easy, Harry. this is just an experimental patch discussion. Looking
forward to your next patch! :P

