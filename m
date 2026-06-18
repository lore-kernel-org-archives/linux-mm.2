Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ACF6CD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226596B00C3; Thu, 18 Jun 2026 05:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7096B00C6; Thu, 18 Jun 2026 05:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ECB66B00C7; Thu, 18 Jun 2026 05:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FBED6B00C3
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:29:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77F76A05F3
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:22:02 +0000 (UTC)
X-FDA: 84892491684.14.6E540A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id CB21F1C0009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:22:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ouTe4zgo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEYJ9kMeEHLO272k6shUEWPID4kYl7yFrhvCwSW9EyQ=;
	b=csPjRwSdTxnhmd/g5vtLW+/aZeEcoFEntQXXTGMlGfmtiieWW+uUTfUd+6JeQE9FQq1rKo
	rZk7pn5SAhiv9SZA/7gVzQnze5uBCOLBz6fX99ilVHQLRr+TuHFg4W76ASNY+d6hbpYOpd
	yM/r27deXBLSH06qfwMEff+rpLiOGSE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ouTe4zgo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774520;
	b=awcC/HKjm5UUBlr2/3kwRO/XNui4GkEtOILE2l0RO+p81C+SFl+QSDygTh9V59gHOCIMmT
	G3f6Jltl3zZujNaQxdEiJhLf2NYZoBXO7u4xaxKoe5EuBvADi5BNKKnEjITdUkqRgIyRYe
	AXWRW9DMHCPk74FV3mQUDi4h23sb8/k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41EFA601F8;
	Thu, 18 Jun 2026 09:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA031F00A3D;
	Thu, 18 Jun 2026 09:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781774520;
	bh=tEYJ9kMeEHLO272k6shUEWPID4kYl7yFrhvCwSW9EyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ouTe4zgol/qqvYdtUesO6rnH51nqxNfQqJrFucoXdQT8nSDiy+4iUGLreqe9CTCts
	 k34aRchUC67G4GJScTMgV7qLie0WngGjy0TGU84hGnBUS4j1bWOapDB6yiCQ2vjx3p
	 IBIygbkEI4qXzBFZarYkRXARmIWZaoxRV/Hzb2+brMGPMV4WUu721CKEsFszcUlPzA
	 AXoy597hfwzuk2KgOe2vTy9TXE2vAzRkMFHW0BjCj+Ke2BLD0t9Y2focow7JFgFOYr
	 90bvIuzU5MPLvWTusXIo5ChW1D09UBJYJnMloc+dtMa44O+5bIyDXrs8C6asHc5JwO
	 /UHnkSkoCPfRw==
Date: Thu, 18 Jun 2026 12:21:52 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>,
	vova tokarev <vladimirelitokarev@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: prevent registration of special VMAs
Message-ID: <ajO4sLq2UBciSgOn@kernel.org>
References: <20260617194059.2529406-1-rppt@kernel.org>
 <5a993689-f730-406d-8515-8bb6025cc851@kernel.org>
 <ajOtfdGgFQYL-T6f@kernel.org>
 <ajOvwGs5xhnfBu-k@kernel.org>
 <41ef0dce-e973-4947-b5e3-150fdb07f1a6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41ef0dce-e973-4947-b5e3-150fdb07f1a6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CB21F1C0009
X-Stat-Signature: 8snrt3se1bqus6m5kpqguni3ky9apg63
X-HE-Tag: 1781774520-187911
X-HE-Meta: U2FsdGVkX18TIEM53ZBbQxBzv2EW3gCKxM4FCHETxrGMS5bwo8LW/oSqiJ/8r7azya19Gs1bcpqBI+N8MCPHMPjLWQj+LXxkv4GhqZ6w2sijhq3NzIKRgR7sgpYePIUeI2JQJwQZbFSWeAoicTznCuRdnZWwV0ZyEIpBMDBfGc6FBH+OE14jWzMt28ses3spXzkFKzL4x/pcOeDsY10xpA2CT2fw8bttbd2MSY0saFNcihIZnlEj+7VKxZuvRY9KpRHveNqlprSX1/wjSZUuvk5xxYgpMVArOamnNLZ1l0CDT7yO6F0GRFBTDcpBApMw6oALE/OjA8TFXMcuVaFGbJiCdnbUnzMOiht2JfD0uCB8XZGvdn/6Ah17+YWoTC8lZ/S/dDYz+MrYClp3MrMHdCKoXCzM0vvY+njFNGqOxf7diyEzUHZpIJX8qTRzXIqylm9Bu7151chqwqegO54gl9zmKwLQw0Oeo+4r483RvAa9WHwZWEV13DuIqpRpjp2tDM0McBwj00veXTmOc912LHyx5DlJMFFqiDYO71it5DfkZnFpSG5bzrmyoqjfuJKb/jasQmaXhnPpQMuIxu9iEpoI+afi+rlgYe0Z4nhQsHWNfBdN/zIxOnS8BKdUYZpAbNK6Tpl2wmxRZmpKOylTO6sB8CN/ZtMWNoVK/w10qkJ9q7ryH05GJzXwzbnpZ0NW5KgsSb5J/OndL5h0qJDsglYfhzvrKIo3VVr5tjWl1GeS6RHbUAaVqoqiPpZpJUpfJeBo+jqF2rfGHrvctZOkt6xsFLB6PIwgZyLkis1Gw7PtQCHSE6SOmR0eaXCA+dYzeAp2dNiVnwkewojdfpdWG/RqYvQ0V35aaJafv8yWJOZIBNDJvLMBqB0yYv2CJRbMuo1X5bc2KxNEcxXBYSvsIkyYirLUxIQ0Y7fNgJtGgt4BIfHxWgEchj3sxkrvd9rNd+Jgawsi7sHMh2qgWh+
 Opd0H2t0
 Ece+iMBwsi3huxkZ5Yn+YidS2/D9ilRWXQ4bJT4Y2yFepflBJNgX+RcnKVA5PM7k+ZRVMsYU3KKjRgNQ8YssB/pSXEvCAsEyrYPljQ9wZvuX3PK6HA/2LDyKeJN68SQeGSDMvNLpzFrdl5NtkiwxLfrNZWjJWoLNRgnQPtofPP4V6v87wyq88XlaPyL9anUr0OrExSMs+aROa/5GPgoitZoT9OLZT6p4lRt7eWadCcUmTZ7mM2SnUhIwIN6yu9XOFdY5H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 10:47:19AM +0200, David Hildenbrand (Arm) wrote:
> On 6/18/26 10:43, Mike Rapoport wrote:
> > On Thu, Jun 18, 2026 at 11:34:12AM +0300, Mike Rapoport wrote:
> >> On Thu, Jun 18, 2026 at 10:19:17AM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> I'm sure you considered VM_SPECIAL, which additionally includes VM_DONTEXPAND.
> >>>
> >>> Would that be better, or what was the reason to allow VM_DONTEXPAND?
> >>
> >> By itself VM_DONTEXPAND won't matter, as uffd can't resize a VMA.
> >> But thinking more about it, it's better to make vma_can_userfault() more
> >> restrictive and just use VM_SPECIAL.
> > 
> > Ah, hugetlb sets VM_DONTEXPAND, so it must me excluded to allow uffd with
> > hugetlb.
> 
> It would probably be cleaner to just allow hugetlb, and then check for
> VM_SPECIAL if not hugetlb.

Cleaner in what sense?
Will be uglier for sure, just take a look at vma_can_userfault().
 
> -- 
> Cheers,
> David

-- 
Sincerely yours,
Mike.

