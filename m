Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96E1ECA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 13:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A74F36B002F; Fri, 29 Aug 2025 09:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CBF6B0030; Fri, 29 Aug 2025 09:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9898B6B0031; Fri, 29 Aug 2025 09:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 860D96B002F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:22:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14B4114076C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:22:01 +0000 (UTC)
X-FDA: 83829858042.08.D392787
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7CD83140007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:21:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pvvWIUNL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756473719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UiUOtcwqE//F79Mr1iWJLxTjJf5cHmpeqdYR7AwoiYQ=;
	b=IpZpRQmiIkgh9lA/39rIwmo2ExTY3yyr8AoypisxkpS3DLi6WZ9Odl8mUE6rbGpkyxchzN
	yGsiBGb2sZuLDg4XN5kpxmeOGbQENaE5dYn5XRf+RVyjvIQcxUJz4cqlV4WF27rkGwHH3g
	KF/2dd0kKv1MclgUbIZ4AJPr1q4hKr0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pvvWIUNL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756473719; a=rsa-sha256;
	cv=none;
	b=P3KvZ42LYUf0341Cdkig7ov9us57tP2IAxVmgQi2IsaG5exd+5AfMcPfEkdqePpAllL144
	BrEoYH8HLAJuhXT6zmNY9vO3BL7zGlPNOWEf0QuQWKLNUYi1nnFitbLOqJgENjsLDbsYu4
	Tb8uXjt994xoMTIxfua5Jr8vRbjrhtw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BBE86013F;
	Fri, 29 Aug 2025 13:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7C5C4CEF0;
	Fri, 29 Aug 2025 13:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756473718;
	bh=MoQuInkk9tRs7HQv5Ll3cdnvNc+UUHtZe9abdWALjY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pvvWIUNLTDPfJMYkcneF12V40GscPyZxBZdIk0amGV0Ur+IDwkBMyqFXptdrxy26K
	 1wbuTzoqSSMhDFFTLy3wgYQjv73+azgZ8QRG2aw3mnQ9OmhakeOMMOc2l0JRuHUAWq
	 r1fr/ofSijZYCfC77n+g2a3D6I5p2SpqSs2jtgxiZWlDIn63rgEYO/4NKSy2zM8i1A
	 DU0NZhajL65tftYQuJjnnwba5ybp+dqkWUAGb17iwGSY3esIIV+hnEhtbrTijnkrim
	 HVJRUppT3w1V06iTeWNnYI4wshB+miJFe/jxxJ8sT2U4FCAmLlnpe65X+xiJtQAe4T
	 1ocYs99QTgA3Q==
Date: Fri, 29 Aug 2025 14:21:52 +0100
From: Will Deacon <will@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Keir Fraser <keirf@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Frederick Mayle <fmayle@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>,
	Vlastimil Babka <vbabka@suse.cz>, Ge Yang <yangge1116@126.com>
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
Message-ID: <aLGpcOSTGiJIRQda@willie-the-truck>
References: <20250815101858.24352-1-will@kernel.org>
 <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com>
 <aKMrOHYbTtDhOP6O@willie-the-truck>
 <aKM5S4oQYmRIbT3j@willie-the-truck>
 <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com>
 <8376d8a3-cc36-ae70-0fa8-427e9ca17b9b@google.com>
 <aLGVsXpyUx9-ZRIl@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLGVsXpyUx9-ZRIl@willie-the-truck>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7CD83140007
X-Stat-Signature: st34qaztgz734yx95qur15spaqdped1x
X-Rspam-User: 
X-HE-Tag: 1756473719-829766
X-HE-Meta: U2FsdGVkX18rdwewDT5NKplm4RwoWo9nScr5HoY/4d1ZY57TMOkEKI8S5kin/JeX5Iw/Upbv6MHErT8rUe4Yj5TIXkctvdhtc7MiLx8kx5pApJovCb4qOm4aY9dl5pn7XY0tS3WBfpoTpA4ZXF0koRruKK+TWf2K08ibFDCPqGP2iZpv6btAS1XO42NquzWZbABD92xajWZDGno6J/jDgcmY2R09YFKfH10ixwdZisVDomD0pM0pZr9hLa6F+7tPef17SL6ylq20zd0l7DVlgMlngfA4bXhGDC9jWegBQZVcVpsdQTLpulkX3bXQSPuxyZXeJKVqxbYL1M5vqMxe4D0HOSJQZlHsdmMsMKphIyOaWF8FQJP1aGKbAzgSPnIT4PXDAL0LRNVgr2MoD+akGu4yjaI2aTelDTS28xOkzEe4GX/yDmYmiJex6CChvFJWwrN8ZnN2QEdeOXJf0g4xDQ9TrzTPsx5FD5bbQgxEdqdWJjG7cWG9sFlN/QAwWHzizAkw4houdFlkkwrbaOxqkElOJ5njPayHtcwVylpEuC/N7kBWHRmg8S2IyJHHr12lceOUCbs45jzxyUCIZjx4nZXqwqDUYU7oM7hB2yZj9v/OLutUZV7ynK4BAm9VDu+XgnIXlklSaE/Zf17mJXgNP6YBehk1Ej3VdNfqSfSIQpOSeVhbUKlbuF0XKHeegxb60hsnlOqosXkKIgHBrZOGJoTMS+Sb09vWUKHXjNvvbBrKSmTzfu5dErHGXEkHtzjMmwGUvy0oICdDoSuKAT2TMZO8Z2GqgRl9C0BV3F5sWs9c0fpfQUEyVlWbTUaG/wfUKbeCTwoQVfaARv9KXmVqFL2uUOY4wgEYdiO570f8Y5WilHUUsFveIiEEhMSWdiCxG7qU3U99/FmUaYvyLBGmbDhVG6RZIMrl4Mo2rrt77vrcElnw15kudd/RwxKf/y8ZZH2hvvH1LRvZOh7j1uQ
 Yczi0fQ/
 g3xyQu8h+7sH52KlGILMedQFlCB1n59pGvv1y+pyyFK2P9MsygFKnuGlonDoKm/guWSYGdw1d4kcqDmbtWJ5ioD+rhGNhmOfyBItqpByO58qPVlN/RwxgF7hEEtVPb3vbCO0KEJbHvYh1rR+3qBG++niFXIUa4Xctld1ibSm8bVl+06tlCSug0se2WfFRE0ffzP2bgeQuAstS/3njcERPkWannU7ciNN9bA78W75UStfmEalaRk/7fMrTHUb0NHao5uU+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 12:57:43PM +0100, Will Deacon wrote:
> On Thu, Aug 28, 2025 at 01:47:14AM -0700, Hugh Dickins wrote:
> > Patch is against 6.17-rc3; but if you'd prefer the patch against 6.12
> > (or an intervening release), I already did the backport so please just
> > ask.
> 
> We've got 6.15 working well at the moment, so I'll backport your diff
> to that.

Notwithstanding my question about the synchronisation, I cherry-picked
86ebd50224c0 ("mm: add folio_expected_ref_count() for reference count
calculation") to my 6.15-based Android tree and applied your diff on top.

With that, I've not managed to reproduce the original failure and
haven't observed any migration failures on the GUP path.

Cheers,

Will

