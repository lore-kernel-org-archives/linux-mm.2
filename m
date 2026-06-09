Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFB48CD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26EDC6B00AE; Tue,  9 Jun 2026 10:44:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21F8C6B00B0; Tue,  9 Jun 2026 10:44:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E7E6B00B1; Tue,  9 Jun 2026 10:44:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F10DD6B00AE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:44:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF1931C2D9D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:44:32 +0000 (UTC)
X-FDA: 84860645184.02.A4E4F36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0192B180003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:44:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJKSK6tf;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781016271;
	b=5wd+bppf+4ot5I0hbLClM02y1vnUizquqfzPIw/fvGJ9croRSbPNnNlyoMl+bi94Jweq+w
	WSMT8+CY0nXllxla7yDri7hFvgOODHBVk04QJyfkRecHc+XWdxgLW3SXcMFErKpIK63XA9
	1aPxcwV8y7iwEX+HgLhNALjTZa3h/8o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJKSK6tf;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781016271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/LTuxyle4YoYh6mY0LGl6PYWDtEkH8oJY1eKe6M/oM=;
	b=GIMjPnuU6ajbkspxey9kG7eP9SqmvXasq5VJtgfieceSh7kJqcOYwZS2+4jxOACOELGg4l
	Gyw7yvKl++L5UgtXUHqC0b0j9uHD1022f/Gk25UxEwjeAQNx1ogSrghO9Xtd79Wt6RDiZ5
	w01X/7gnuPELNktR4bbmbNc2xcpEDIQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3663D400AD;
	Tue,  9 Jun 2026 14:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C241F00893;
	Tue,  9 Jun 2026 14:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781016270;
	bh=h/LTuxyle4YoYh6mY0LGl6PYWDtEkH8oJY1eKe6M/oM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EJKSK6tfVoJfiMgc65JDw1LIyZwhbCYFJ3Tz/3CwUMx3/5qsVcjmjKiAxzYA/3Qb4
	 QvQa4BIxuGn/y+ux8TJDW8wqnFVt4urkORkNhmAJlHwSGb1s5qzzX8ZlyIH98yBFRR
	 MKvmBJgT0TdeXaF7HkAvPYUx9HKR9//s1yI96X9/4rTdJsxLuRZZLjxYp0kgk9tISF
	 y1A9lH6yCx2M9/lCAm2cc24Ywpyr7XAnNyZZ//htrYoMku9+9uCsAhafxcYp5lGY2p
	 J3HEhuZxvxK++83GrMDTzCCiMkAhd03bO1Of4cCFG3HwLQMOZecKuLqd5oF1Ik0svP
	 JhWkimEXcNyiw==
Date: Tue, 9 Jun 2026 15:44:21 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: Luka Bai <lukafocus@icloud.com>, David Hildenbrand <david@kernel.org>, 
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, Luka Bai <lukabai@tencent.com>
Subject: Re: [PATCH 0/5] mm/khugepaged: add collapse hint machanism for
 khugepaged and use in mglru
Message-ID: <aigktfOjYwxhzEhb@lucifer>
References: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
 <CAA1CXcCLwS=3CY48oFDMUsHEkBkJzLWQJke41PMQE65k2DdR-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA1CXcCLwS=3CY48oFDMUsHEkBkJzLWQJke41PMQE65k2DdR-g@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0192B180003
X-Rspam-User: 
X-Stat-Signature: w4x3ygg9tp8dwx98edffg9mpe796mxma
X-HE-Tag: 1781016270-514831
X-HE-Meta: U2FsdGVkX19Q0VDMLpY7NL+KJiKFtrHV/WE5xqMLQ+XreP5QSZblyfBEQJ5n3xdlpcUk3OZ2gd50uMdZrZktaM4Pqsg6A8Ns/110xqWwEe7tgDWSUkHde6iCoB6qEXTyKhnkqltUGRcmRODA7pyL2UPzPLjO6MHZSyGCSQPVm2GkeQUzKhREgOO3bBL0prMagvWFrJZ3EVoYDNfjq6M3LR9ynDOIiaQOjkaMTnzo2axmaiIor/QUp4DN1XbnSyP2oPDehsWryl9qUeYjijMRx0gXMKh9bQKMCifXr7yCsTFgQnYfsbF6mfkTKo+cJD1a9TaGaClC2Rbxm0NVEfOcyxD5yXeBXZFMfu157NXzw2wrN+/1YUELzEyIOc1npaQ8U2OkVVFobRLlJj1UThM1C6a8tnNzttusQXGEuJhD60fCJMVoDrzhFa+ngwtYMAH35LE3cm/v241IHqj8DzIHRv9qRq4I7dfe4yGvqgvrt3sdBGp1mFgReg3fZPsml2v5PgYKrui+qnjBx+kEcJpR05gSVzVZIykLPutkaIZdTx7aVm7TEMra/qxaiZ8jid9SPs4rSO2sZkVkrY8lE+Nz0HFJYOwUxyC3BVX13L/JiW8ODvU3ps33SQ2bLj7vwJJb/diw6UzSggKu8TvMbiPyw6mc2fim1UJT7VkDoLs1f3n4keE7nKey75WV4qEY0V0Bw+fcrINRPbqFu9grkzCS+tchNCcCj4dwdfzzyTp1oTEr8Y1qxWBm3jF2ufiyN6M2Nv/ZMZ3gTIolYE41KUk9naqisennNT/C2V2NQZ2M8dJ7UJ49gtj+Qq1BleYpI8SnxbvsGc2bnpbiVTJhYXxpUITZsq9NaW20yY+nwaodiiN3m8Dekwxx0S5Ii8juv5+lhOQr65F+iZsJbaS+JMrUtpbL2uF+kqYYrqY4wjiB71f+1JHQMF0ITmr4groFnKfiVCNB1maA7yK1RH2drvr
 vIDVfhvf
 m4nbfOr+hg5NOrkHFNIFX3WnOcqfCemTXVoIefpjLhFTqTzAgV77EM3qi+qATOUHDtCnukMKkBuoIVB51vi0j95AJRWZsa/pEBAL+GcGAck605zL3HAfCh4zm6UMBocHegcqX9r/aKfdfJKfIqChpEgZddm6NfCn14iLWZgQN1IzlUmchGlL1mqsGNLswd36/H+vBg6mhhIPwE1JlqoHKwqfcyc8j31hRj8lkiPNCYp3PKpcdAqUw2z7L0S0xjzjbWp0T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 04:17:45AM -0600, Nico Pache wrote:
> I had future plans for something similar as part of the thp=auto work;
> however that requires significant thought and investigation into how
> we can properly gather hints for collapse/split THP candidates. From
> my perspective we'd want a more global structure/system outside of
> khugepaged, that would directly call khugepaged (and others like
> split, etc). It would also tie into the allocator so that at fault
> time it could leverage the hints to make better decisions. My fear
> with this series is that making a decision now might complicate future
> work by adding complexity we may eventually want to remove for a
> better solution.

I know this is future planning stuff, but I want to point out that we need
to see significant rework of the THP code base before accepting any further
major changes.

>
> If you have the chance perhaps you can lead a discussion on your
> proposal at the biweekly MM alignment session.
>
> +David Rientjes as he leads those discussions. We could use that time
> to layout a plan for what needs to be done for this work, and for the
> work surrounding thp=auto as I beleive they will be interdependent :)

We prefer to discuss THP topics in the THP cabal meeting, which both THP
maintainers regularly attend :) having separate sessions we might not be aware
of isn't really helpful.

And 'THP auto' is a broad topic rather than a new feature. I don't think it
should be seen as a topic 'owned' by anybody, but rather something that we
as a community should discuss.

Series that appear from nowhere trying to implement significant changes
along those lines without community disucssion will not be hugely
appreciated :)

Thanks, Lorenzo

