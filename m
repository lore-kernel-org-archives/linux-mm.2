Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A8D1FF8850
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 01:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73F766B0005; Fri, 24 Apr 2026 21:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0316B008A; Fri, 24 Apr 2026 21:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 606D86B008C; Fri, 24 Apr 2026 21:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 503166B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:50:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D53B01B7108
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 01:50:01 +0000 (UTC)
X-FDA: 84695397402.06.903AB40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1CD13140005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 01:49:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fHkZ/9cv";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777081800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NliBQUSC0dwXBo+nlJ3y+gVE8tsZd7d/vnDIvBP2UKc=;
	b=urdr6itO7Tp2eD5vfWSAp4xRJnKDMZM6D7AFsuNm3bSB2iN127LM54ZlRjzMOf006FNJfN
	1YE31Y7JsvaNMZxYtic/hg5SJFS5bzOJavR1vdSQcr3r5405tzRZ+M21h6PIDnqdz9n167
	I1ztcTsI/tVD+05Ll6JbtvJwarVtOp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777081800; a=rsa-sha256;
	cv=none;
	b=WVw3BmeC456zpMY87/lACcgNsDua6OnXKfkxy3htHF5T+aYgmcMIFsY4ZnlWtQjYaqTQX5
	CHoKBZjjr7neVyBkUyzQ95Nx4Dfc+baDSIG25aji/OOQ5p4FO0jGv0FKGuE/+HXipKTtph
	iDEnBDGzv4E5KsrFev59vFn4sJQ3q1M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fHkZ/9cv";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDB6342A0D;
	Sat, 25 Apr 2026 01:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93114C19425;
	Sat, 25 Apr 2026 01:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777081798;
	bh=cZe5KR8gXqJ0UYWSpQT/r2XTDRfD/wdI7o/f+ADHK68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHkZ/9cvjrEwZz8qTdhfIK3NxCvYPJdL9qIwgARX6uX7diRaGPv3KcNGplPFUlj/Z
	 jbjp0iSVTkwcq9DoDFygERVX5TAYXJpBf6iMldWp18I17rNxk4QdMLfDPaIE4CHbrR
	 DVoNPomvoSjQSHk97+Ls6/XsqOMt9nrQJhek6m5kTt3wMHhkKMw2w5K6SbMFW5Z9R1
	 99AKLelNxOSRP1kWrLBFZlwIYc8iguVi+A5XTEkCull2vHoCWv7+47kuxLK1ll+zGx
	 R0eSaejRuusGU+sVkWbg1wfTa9aDUAXrYrOoekJnqsAjvvuQWSEcoB9oKw+wLa/bDm
	 Ki3FZUY9D0brg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] MM transition
Date: Fri, 24 Apr 2026 18:49:49 -0700
Message-ID: <20260425014950.86217-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260421094216.8dfe14a8c62f2420fa5aace1@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1CD13140005
X-Stat-Signature: x76kqtkq6r7xwzuzochksynxac1gtjga
X-Rspam-User: 
X-HE-Tag: 1777081799-846881
X-HE-Meta: U2FsdGVkX1/ei5WWCdTMatGe5CjyE93IbObHZh6yag+ZUqifM1qxOhBAJMckUZxSOzWJGaqkh5jJE10KgQO64eHeOhzspgTpZBatC92PaTI/goczedSDnZDmFulBLK4B8HkdBfWANZYszHdVx8E5mKW4SrNa6wsLAsE1odQKoG1O9Wmu83BUTXXqVcovWO6zcfmPk+y5yMoCRvgb86gmYhx1StTSS3yv88s6v+MYI059rf/2/OcOuGf+x+utBnmPNThA2HkBpPYA/2rRgeC8thzG0Cwik5TqSH98kO9wDxKZEw8UE0xZDrQiZ/4HIwJl8NVjaemopFO8s4u47vZ8/h9GtRd8EKRTyzwdZn4dvc9xw0ONfKNVVEX/TXq5KTxj1OJdc6UP0Sz4/Jj7icpg2ms897mTCWa4N+1ReecqhlqItjn/EGHKr+OCvEHG+6yaEuKWpbBKyyEgsOYofYjwTSnhcXtFpGIYyxOmArrv9eH8LaPRX0YRiZ7hJNtYEn3pG3VnOIamzR1wUayF09VGeoIpghh7jou1WsTqbCVN3jtib+k613d5YGoStwQsjAwq5CL6PTICAVcnurrcLGnefRj/2UabMZBhXVGSr+I97WTeEtrxWpx78BjiyyQeS8bkLTji1pgJKcxSmx+qgROyWF+UYgG6qWwwDa9jhJmh9N6uq8xGvTFbT457xNp9cvduGHRHyWy9kpaDrdxSdJsAhyLuVC4LiKGliuk/UQVyqAihxC9dTPLfg/6lhqxzlVHv5irJazuUqTDT/4QoQ9I4An6hyNux3ej80EZd4tHxCTl1y697HwJdNnrAdAfow1pTcLyvzUpniJ5wRrZOcyK4/oUSxQe+OEWAvbYTYZtelOIev6NrxudQp/SdiBaYLbwjg4EoraakNjpvZGeOYxNS2o0dnP+L8isIBvmfXwLce8OhEg7IcBJv9UztQCZUS4xEDMrAUgiGf6OmMvhv4WC
 cvtIZwzo
 wwX2w287n2O4112rA0oYg6gferEU7MTRKQ5jjnSE7P3iI4+pAWihFVnDmbXiTWDTMJTs0/RDbsIhqSFPK6ZTWetBhAA0A6S8x8IYfUIDdRdFiilk77/rWFZuUXRLA+AOPFbuqVFV+FuCfrPe63n6xJFagDm2vYJYp3LrMeSRyUs73v7xDlNukdncpkKtWiZHyIqmc2+3IDSBroQiCG8IGkm8ds8jqhPjUSrCQsscvIaXqTWjYXiLqBMpygoMCgMLLmFqEI6UI5u4Am+nyvKpJTmNC4puU0olw+2TG8ROsfKybW9JypZmSpKw40Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Andrew,

On Tue, 21 Apr 2026 09:42:16 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

[...]
> mm-next will initially contain mm.git and, I hope, any other git trees
> we can find.  slab and memblock at least temporarily, if Vlastimil and
> Mike are agreeable.  I want other trees in there apart from mm.git so
> the tooling, processes etc can be worked out.

FWIW, I maintain damon/next tree [1] for DAMON patches.  If doing some
experiments with it can help you, please feel free to let me know.  Your mm
trees maintenance is huge help for DAMON development, so I will be happy to
help back.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

