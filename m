Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C38FCFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 06:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1576B0026; Mon, 24 Nov 2025 01:15:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98DA6B0027; Mon, 24 Nov 2025 01:15:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFCAC6B0029; Mon, 24 Nov 2025 01:15:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A3CCF6B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 01:15:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10E2C1A0240
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:15:23 +0000 (UTC)
X-FDA: 84144488526.12.4D42A94
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf03.hostedemail.com (Postfix) with ESMTP id 56D9E20006
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:15:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763964921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v6tKl2qVuFLiG1Gcm7G1tL3Ntw9ZzCJMnnFdTTsFu6U=;
	b=nOB7XPXRjqp7I7yMpKUPoeQnIHTI0UQ84yjJBVDBF8RNuYsppomrxLrqPoLFulSYbweqHK
	FxKCHc0z92M+mAHQ8klz4dkHnqxGhrSE7Bufy/pZPFF+h71IycmcEVe/fKRGC0glXudmGX
	wpyUAibNODm2f+d9O2C0OiUK7kTJMVk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763964921; a=rsa-sha256;
	cv=none;
	b=cRJEafiLo5cZ1ZZTKvZUNu1kgvVQD0/TPPEkzzBilSAKL8GC5ifvb7Bf/ExsM/MUr+itBm
	YrLQepLgMaICbqC1AZMpsMhVp4X20pd8WNgP3Htvme0g1XcSD0qMdao4JXgtVUvsI8R+SF
	AXQOErfzgV4DNjsczA/QVtUpTuX+EJQ=
Received: by verein.lst.de (Postfix, from userid 2407)
	id A4CA668B05; Mon, 24 Nov 2025 07:15:17 +0100 (CET)
Date: Mon, 24 Nov 2025 07:15:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] mempool: factor out a mempool_alloc_from_pool
 helper
Message-ID: <20251124061517.GB16260@lst.de>
References: <20251113084022.1255121-1-hch@lst.de> <20251113084022.1255121-7-hch@lst.de> <a8a2c740-2208-5692-cfc6-f475ae0f7d45@google.com> <7b1265bc-835e-4c7d-af75-f237c46bc3a7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b1265bc-835e-4c7d-af75-f237c46bc3a7@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 56D9E20006
X-Stat-Signature: x5nxcogy71xon4c1nrxsnj64i9xuzcyy
X-Rspam-User: 
X-HE-Tag: 1763964921-364162
X-HE-Meta: U2FsdGVkX18FtHEg2uzOh1SHakZZM1mKm/TPQ5u3ZDqil2CfywtkVHNpyEAgt2S2Donowoxe62qgJlLjfIkTMqYvUnolZoM2ahBQGlmSzJiU9oJPyb5uI1J+4S/ZflZoaCXKLgYStXlG+GozuK8cbJLMvHaKzPXHlainkUctF89hpOnow5Mea8387Vr/LK0fnQbl8ZyHdCswNfk3/h/T4IasaS0ku3X/X/+Lo1gWXF64M73pK5DQMXxJdzDTLHSCDrIrI+efhijyCoPpMis1oO/TmI6eFWNROMNV5QpJUZqb8hkZ2ZWovFqb/qBM+Y/x1cxmdewZOYPT3ZPJ3Go9TIb4jX2HsGj47P1vDdI7wTnxtkN7bFYcJs0u1eWzfDHqqFPeZKIGMyV9/43UYZWduFLFlJ9Jj1qVoBFwQPumyrcdamLo/k4ESk5ZOfr8kAqTWzRc9oIFGeNhf21HuNmmwfi7yVKdfntm1i+Vgs879VoX5FXIPftqF1GO26TsDVWks/AvYfQDhOFcwVd6Hh6jrpTafeaCtltitWtB6PqKkWzCMCCxDYlNAobF1hKeO5kU82ZmRZHsbNe0b0Ar8s6Rio6av+UFYvmnawxcgF+CoB3LT61U1nuDVed3Qx3VLCzju6uPkoIc2kk1wISWx3FfUbkHnxyZZokqojZE2R9PtzXNJCumIEQ+Be8bRHPujiLqeQ7bqjExDaaCSc2JVBz436jIOai9f9MvvQLPYklZ3gsW1HeVqXv3xdpEqLonG42PpU6AwY7iaaE9liRLb8P70BiIuXALngO3iNOzZMmrGdaGYy9vZYgjwYcO9dCmzkjgrTkKSP2wHWfW3Nw9NdkK+HRPOnGiLlS61XrxWLurw4SDE1WYgv1+bi1ub5VbY/nwlZRtvO1otc9m3QhKuFeuyqs6AEA/XURhDv6hX5ODFXhmVKnxtCV1iP7J6JclFuG0fqIYEJp2Keyfhy7CdTU
 zN4SNyaL
 ky+pQIARTAF83H2+MlR+NMk0UcFbHpP6k11NX8T46Ob75uLcD2vtrPhbzK+fajiTMH4LJb2z/HMl56Psuzp2kxXgVc5rNldFyvc24RDmIazE3P+gfQ2abE6y1ELZCHIqcIlHTQUtrrzWXsxN7yCqgHd7GwkIUHzYFYsRssPvGNcRwv++XPPqxHULsQQ6tILaD5VDo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 12:34:40PM +0100, Vlastimil Babka wrote:
> Looking closer I noticed we're also not doing as the comment says about
> passing the limited flags to mempool_alloc_from_pool() on the first attempt.

It does, that's gfp_temp.


