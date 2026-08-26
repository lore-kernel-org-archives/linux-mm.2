Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45A31C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D76B6B008C; Wed, 26 Aug 2026 12:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF596B0095; Wed, 26 Aug 2026 12:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6F36B0099; Wed, 26 Aug 2026 12:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2AC6B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:18:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24CD64010A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:18:36 +0000 (UTC)
X-FDA: 85143928632.28.80793C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 90A5380012
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:18:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=liCtOcA7;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787761114;
	b=Hv6Ih8Rf5wiL7S6Otl34C38aUJUFabOLA+5LY6z7c4NnM1xfQGLS87ep4xHqsAwJlcgc7q
	4QwQUW+ur7uwGxOLa9Hi2/2hnswpDAGxObBlwLgDZrlhIBpehvs/dYp2AMhGgmXrevEMSk
	Z0eDVclABn/4TqDbDDJrXrCLHvj3Tts=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=liCtOcA7;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787761114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/KVGzZ6bCLrBPb8pvmrm7J/N+QzEWznI/LjnFx/3QBs=;
	b=q5SWocpdC/7tELHXp+Fns3fU/5d8CiloeL4X29jkIgRHD3zrPItp5j6pfeI3V8yENdBahW
	q0PcdmXqinccZ2A31e8Vp3d0RYI4uYw21aGjoJsnoSiayAft4eXjXk1xTM4VMNj5MHG50G
	+dZN/gcypX/Qxwe+7t4B2Lv051WcYrM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01252601E9;
	Wed, 26 Aug 2026 16:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C448C1F00A3A;
	Wed, 26 Aug 2026 16:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787761113;
	bh=/KVGzZ6bCLrBPb8pvmrm7J/N+QzEWznI/LjnFx/3QBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=liCtOcA7GvslOr4ZLCnpb/gbXm10r40SAE/IlDbpIizwyH71smht55fHnWjKYhN8e
	 DVErh52p2FPnyNEh/p3RHjzKaykWRfWcfHF9YB7/z//SG6LtNiETuirVB3kIv3hIJG
	 zvhn7k/ZRxCKpBy98geSWMsDDitu+68LhCFmrVGZBl8VTeFzBVFZWv5+qq0Qdm3FJR
	 qqk5XMCDng15tEmU6xIwR3xKLhrEET/nizgl5g/q+NWZSjP0D4A9zYMtvqJQDVLn/f
	 ZrnWnLzPmL/qqvrIfBYid4aQWbW+9M+DmPKOYQxRArALupgUkmG9x1W0OvQKd0IdZL
	 gAjKjRWz8nZgg==
Date: Wed, 26 Aug 2026 17:18:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Daehyeon Ko <4ncienth@gmail.com>, stable@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Hagen Paul Pfeifer <hagen@jauu.net>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] mm/secretmem: properly account locked pages
Message-ID: <ao8RZlK6mBa-oNGh@gremlin>
References: <20260822-secretmem-accounting-v2-1-fe445a7c6eb1@kernel.org>
 <17e9f7d6-d095-44ee-9997-8dc10646f3f8@kernel.org>
 <ao13TmFVVpsv0zO4@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao13TmFVVpsv0zO4@gremlin>
X-Rspam-User: 
X-Stat-Signature: kjhhwbut7cwshmu3c5b8dtmeosmic3zp
X-Rspamd-Queue-Id: 90A5380012
X-Rspamd-Server: rspam06
X-HE-Tag: 1787761114-334904
X-HE-Meta: U2FsdGVkX1/knkYuh9VS0yYaiMGHkAyHCEICFtBc7VsyAzxBJw3NQB/pmeIVNODDfwYonXm7W7IXYSwYKPOYKzZkzj/uE2rtxOTKsIa/RnkvQ2eKlvEfTlirH0Fs9N5gdkpfMHSU+Xa5A3K1rVxU4nXLH5SHLSKJ4AmpozjsfXrmhIpS7rxms9gvmXmQK3Qf/yLR3p5yWBcNYLeAYFwyqHp9cANAi1M8G+tiXmmWSNie+2kGkZeB/Jlex+r9dFavZIccacO2rVxhlLfGp9mvIr1bFzAAfV4ij1UXVXwDbNspVDp8CZWw3leEeQbwWHuRXF+Tserz9L0mfc/Xj0zwsJRlwqUvuy2ZaLo0bW26cWYQvGf6bMQB7ZDaS3vs8/2YJqSUI7k5CwrJQY0+CXuUuqXUh+9qKF7RBBWku0ZwuifUy4NDMOW6tpgqpK/HtkurtVt9o+SzV9xXTT8CXfaRvF9G6six2q1mK9mYQ+TB0Sma9X6wnr0LErOInxjEPFb9Wts4DYtxBQq8JvuhXj++4KrKpZ2QtbuAc7ynbp/5mqRHgGoeG0m3BklqAAcOcnAebl5tDYs4E22AYgZJzR9HAXCnRW3SdndWenTpbpmldFOPvS+oFJit1mi/J8ZdnarjPNhPqTG/Na4FDY8xVL4DOnD8Ju/3Qu4nkLDAfwlxUYp70ZppJstD6wIoAsHaez6TsrxkC+C8TaU3rEHmhX4GP5A9HMPYj5rxm7b4Nrh10XCMhXibkQkMwxAimlqfVtZeFN3Nr2/uqoeUfIdaupqeWqZh7oWj+WdtdIyDDmkICR82UGwe9tU7OpJA9zOPKT44FEbjU0CgVxBYqPh2u0/9nF7U33qLylr75fuPYMcM2cBj6UMP786aRtS4/8hdjiu9x1AzByWsHJ3P4EFyYIOVgnJzxkR1jZydjYgY14FCf5UlHlm3qILfXvjcPucUM+8FmlYSf5BX2jwyVicq3oo
 gFAafgfL
 zZeSe9oJrxu15xfoAFnVzgWNs1mx+PNH2NCoQDtsR3W3wzgy+NXoyxEop9EDWN7hjS/0RYXI1hRkOdciT1Q1mW1MAW4agZC5ZS35BFDX5eQW2AMhhvSxMcSpYCBDlAHH2SH9LAGqncFlRuvC7KHvqM743NExFANC9F7ijzgCqYx8/AMgS8K4bnGQbGBvU6fEGYQC2Qh5u7cyqVwb/zFWEkTpuiLbgwIpKxbUiGF5Bzssa/n52ZpaYC5bX17R2MXCAKTA6oVlIMcnDl5mXrE1+ohluDyIJCerdivdxXOfKxyMH37iJ/5SmZNyKDqtyVi0e3n3daL9jT9qdwt940idlErFo52g6GBEw14Mi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 12:18:20PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Can we split off the selftest changes? This stable patch is already pretty big.
>
> Yeah I can do! I seem to recall people wanting tests backported too hence
> the change.
>
> >
> > I'd assume the changes to the selftests are not required just to get if fixed,
> > because the changes should not be breaking existing user space (and cosnequently
> > existing selftests).
>
> Yup confirmed locally that the changes don't break the tests.

Correction - somehow I was working with an incorrect version of the test
file or kernel locally, but the tests do fail with this patch, that's
because it only seems to be asserting the mlock_future_ok() check which the
patch removes.

I think the easiest resolution is just to remove the test for the purposes
of the backports and reintroduce the improved test as a separate patch,
will do this.

--
Cheers, Lorenzo

