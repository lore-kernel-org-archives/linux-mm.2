Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B51A5606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 13:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QPgnEKcE
Received: by kanga.kvack.org (Postfix)
	id D02C76B00EF; Wed, 11 Nov 2026 08:12:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3526B05B0; Wed, 11 Nov 2026 08:12:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9116B05B3; Wed, 11 Nov 2026 08:12:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2CC6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:12:17 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28CFA1C32FD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:12:17 +0000 (UTC)
X-FDA: 85422876714.30.ACCD44C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7162E80005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:12:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QPgnEKcE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794402735;
	b=JBtln/ORO6Pqe0EoFFBxZH3/f7LwEUmcIuKZ2RTJuGWwtLDgimgaUKnb2D1iqEp+8qR+gf
	S3Vyg9Csa6BEVJVoAEmogNPTjXnVt0rH3VQq9v91k+UxBrxc0e9iHh3L8g158S/DFp9wLU
	r5dUliJFaqm/Bd/PE0sXFHXFt+uU2jc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794402735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xirn7Dc5oy647ZCJttt6/JzcrWgzS0z+CjkgHSeTgmY=;
	b=6HgK0JmSTEJKAYfANIhUhzrM/f4Sba5w4Rmep6gl7myuu2YXBzWPb82qURvj7VE1qfagVj
	DIztOc9dn3d6eK65OwRvxu0vWIZYd1afQfuqis8wMeV9rII0rwzgrQw5wIxhShM9zWElUM
	5MALLgWenuzzAJdK+UY1JWO9/SlV458=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QPgnEKcE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 997FC42B20;
	Wed, 11 Nov 2026 13:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BC91F00A05;
	Wed, 11 Nov 2026 13:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794402734;
	bh=Xirn7Dc5oy647ZCJttt6/JzcrWgzS0z+CjkgHSeTgmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QPgnEKcEXcLAKi338Wys6RJD3/FYKNJ5CVrsbIAIhTXiYT33NsN2ikRZnDIQQ4svP
	 l6Y4jnx2K+CzoYu1sSMeRd61PP0Si4EjMneociGmxStIgRH5G3FAZSZkSqT+KMgdYO
	 yonn5y+0Bb34WiujcwmlpVszPm/t0E5s9d1B6erVXKjNVQZRIz78pAyI/ZguiFBSxv
	 uEQVBZ6NTQRvAijUBWfST3on2FhgEDUQL8Lj1rwUMrxwRQsNFlPC8XweeVrklaVBhe
	 HtDqEmKG2Nxi/LtZr/zzr0Tds5KMqAjl+y45p5rs2r9bausaqoTS+APpOEXacPgXhN
	 l8YP5Le1qx/Kg==
Date: Wed, 11 Nov 2026 13:12:06 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shivank Garg <shivankg@amd.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Ankur Arora <ankur.a.arora@oracle.com>, 
	Pedro Falcato <pfalcato@suse.de>, Borislav Petkov <bp@alien8.de>, Bharata B Rao <bharata@amd.com>, 
	Hrushikesh Salunke <hsalunke@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>, x86@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
Message-ID: <avRnJiDLdGcbSW5d@gremlin>
References: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
 <20261111124006.GI2668564@noisy.programming.kicks-ass.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111124006.GI2668564@noisy.programming.kicks-ass.net>
X-Rspamd-Queue-Id: 7162E80005
X-Rspamd-Server: rspam12
X-Stat-Signature: k7uyaw5pmxxg8x7ai3gj5g8mr61h91ee
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794402735-264670
X-HE-Meta: U2FsdGVkX1/H3n2W5Lu0O+j1T8uDcxcFxdy9ZdXE9cnb2qW4T26RfSn1xUAV6ga0gKrWOJ6rBU0VMoMKiE5HeO0ibwdmwIy9jWHLqJ+yZ5kqtQnprbIoOHRykekEH4dbFWrH+dvRp/4QGdItTbVG2Vm77ZCu45JQzBKtMzbRhA6tciw4Zn6A0zzvw3B/N4UpJRpCzdq2epwotcm7NuBDnP7TFBHRqVoHU3CV4tiBTDwZUo0iagDaaWW5G38gx2rN04ZmUMI96IVRvoSeq3EzDLwgsdK+SAMt7MbQpTLXoEq5C2RO7QCKnP7kFjpZbVstVtccFJNvw1X9sk3jA2r+QPg8MSQyzEBUyMOZkfT+rRJg54D8ao3tznmNrRoqxfyhqqN1MmATP0Fd2rRiCqaMctJhKvTkmSz1s8xBBY0gB6w/lLr1vvn3ocFqC+qOqElyprWuQfp3tpwSP8dnfFJdlxFyr3XefAnRoraFZATbspXdYhZ5iJD/mina9btHS1slE+s4uGeVSxX/4yU1/pF5cP6EhFsUyq4fl5JuACAr1gT080CRInTKGjWr3VfCKPftHvs/uk+61XkardYzOpzkZyLITeyYUdRfIzJ/x44ufP3B2dIxI61p+McuwdQlHbMwGgoJfQBdp25RxI92Zjkub3eRUveZE8KC3cdGHlyqlPliGJoVw9BGhcsW4BjViq/FRrwgIky8j0L+BxmRkLhwt1tzpvNOH3icYHEZbfiNpldW3tUZ4DOwsZGBnFiZ7G4YFFPjRKpFsgvm8si6fHh0RjmJUt/fpgeEWB3idOhAMAdaHwbQN2Xx8yikGLNOvmjNY6N6IV8vHHT6jqHANwSehMmrEJSbyoa25tunsYssptiSjVbLMiDXgQoi8wPMfK21g6ch6WRBlmTdmJdBoQi/Yh0ODhRh/hxfDpjppWV/j41hib/4D7HtpMXYbbBrYbytpvpHDDvHZLOidV3yct6
 THSVHHMg
 ZuN8yeYhyvwtZQ+G2ihpLZjTliVbLKlAmAqw1k3W92uSg9I7btViTMyM4HXOvElXVUU+7Ts84KyI0TGDwMwi7nx9v1yxilx9jfXCjSEl0xqjZd1OcR0XoyAz8wQGpgRb1XwOsSRETVhJu5yZ4Q/7te6MQbvCYXYC1694anEcQSiytWDpqkOs2ijqkrqJ4VZ7mjupXuxwgzBW/kXp+nIlw8GCANtosT8TPJArlDK0MLVf5rq/pU1px3P8L8Kp+TywyQYPOOFL97tRU6dE/t9iVOb9ebdGyJbqG6d8fb+qgY5fdswKIVLjDs8mmfySX5jfxJKg7Ww86s2eCUivE0pFg8pspbfqNfR+ePMWqJ5KM4/iju50W5ormiNvQZCDd6GJ07VFseYckbXkmGHqCs0k1m2nhd55KytQ+vvTtw5Y63KlhCpjw3eICcAEUXj3/1Si5GRh6GNuvIL2RB1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 01:40:06PM +0100, Peter Zijlstra wrote:
> FWIW one could do:
>
> 	for (int i = 0; i < nr_pages; i++) {
>
> and forgo the earlier variable declaration.

I guess we all got used to the existing patterns and I for one only
recently found out (doh) that this was legal in kernel style (because I saw
it used in KVM)...

--
Cheers, Lorenzo

