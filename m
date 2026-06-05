Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75567CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC1B6B008C; Fri,  5 Jun 2026 14:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D825B6B0092; Fri,  5 Jun 2026 14:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99156B0093; Fri,  5 Jun 2026 14:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD0996B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:16:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6AB66140275
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:16:30 +0000 (UTC)
X-FDA: 84846664140.30.5C1AF48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DA50B160013
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:16:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfMOpKUY;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780683388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hr3TDHITD2hFuly6b/zauwhYDrgCiLGzrw4YBwU12/I=;
	b=v/fthgjBAS6eyYkH2DmB9igP7aLJ4KgrFO0Ivib+4sbtCPJxEOJ61hB2QlzStpBrvlpzBq
	JC9ErE6NltpQAZa8SWRfVsEKKY4hVeWUb8cbYd/PhiiweYX2mQf4x7vS6K6MV0Rwoe6FEK
	93vQ6mgvYghnS22Tbm0rS85c1GJ9s8Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780683388;
	b=AIeQdrBnSo0AISMQURTtK+N7oyJ28YOwljc/7p05nKeS67Jp2rs0he02DDxYLwSiU3r5pv
	ROJxJzFPerLVOwNol+CpY6mwn6Ns3gTf6TbEaDijuP/bObfdYO59fBwKVo8tss9rXSkNGF
	YYLpc56WM7gugf7dO/jWYNkVvGZ5Zsc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfMOpKUY;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 74EAC601DD;
	Fri,  5 Jun 2026 18:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FADD1F00893;
	Fri,  5 Jun 2026 18:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780683388;
	bh=hr3TDHITD2hFuly6b/zauwhYDrgCiLGzrw4YBwU12/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LfMOpKUY0kSkBKh+0v34G7pUSesBtCCe09LObqD9AaUizQ8XxYq5F1hDWE8qOk1Js
	 A6FKdJImxkAT9Lym8c5dYvXt8+w+Zo4wvV91s2HibfZGKDTbsBCyVR0lTMYexbE8+r
	 Tn8jAQEmr6y+PVxsxcCX5tteSX4r5Czf9awjMF4k05p9Cvi5MV7NHv5GROydwdTDsu
	 7bafKU4zSxWAM3NsIafvT25unEEis1CMWQd7AeTx6Cms0jtwKTyNvGPhiOcUcsnHw4
	 Wem3mZc2ktdQYCN4JsDucEKpU1in37L17u1bMN4h2KM/mlA5zjqS6RqmhFEDalI95u
	 DSQTzvSYU/Huw==
Date: Fri, 5 Jun 2026 19:16:12 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, 
	hughd@google.com, jack@suse.cz, jackmanb@google.com, jannh@google.com, 
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH mm-unstable v19 12/14] mm/khugepaged: avoid unnecessary
 mTHP collapse attempts
Message-ID: <aiMSYAPTHDVEyP4N@lucifer>
References: <20260605161422.213817-1-npache@redhat.com>
 <20260605161422.213817-13-npache@redhat.com>
 <44b12ede-1e16-47f5-9051-27fa4ea34236@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44b12ede-1e16-47f5-9051-27fa4ea34236@kernel.org>
X-Rspamd-Queue-Id: DA50B160013
X-Rspam-User: 
X-Stat-Signature: k9wmghiq8z3ke7ejbwumhfqwpd83ctso
X-Rspamd-Server: rspam08
X-HE-Tag: 1780683388-852001
X-HE-Meta: U2FsdGVkX192DbAPMbNiUJfuuxBbhdZcyOXzD4wNh6o9WtOcTdAya00r97/GArdHMI8jLxv0KxNJ9R1xsqc6DHuQQ+6R/t6/eN6hWJ3HHT2UJ5So0ejVbQHuwIeymLbFt1W/19kvBnh//5OiP/toz//gjVJNdp6SwjQBAk4ErGGUwJ7fa+OI60DM073huaYtOax8oSpKhBcQvG/lat2M9mrfrUYy/NEqUAPpNr4Ic1MqrtJ6vplNzP7j3BSToHicyUrGl7YJiBvj32I4oYAUvx6d0CDpDl02eoELNCsnplfQMiajdLD6vB+Rv6CWn8CfoQ58d7KUvzHrmNXDQkUIIbSjmcxtgTTnKHOFKEyxoLFzCCxgtkRptjCjAjHhMvQtQz2W9L8qBZj6nhdGO+CpChhjd+y3eBVuYdHiyuRgPkJZMicSsAwUS/KeDzYIBjpCFakm7N7UTFJRWt3s+ZSO6G/5uvMOM7u6nri/pXKGeqi4kC/n5G1oH2F+XJwExKUt0qeUAUSw768U1xlm7eOXNayBd0r4AecHJzriA+DTtQMQ7w3ZrZK6vDOpUlbD1FWWxRpZbqmOUtIrHCwOTSNH35W14C5z92yKtNJPX33SyY37g9miGLaMA5kRRvM6ul8q5McSlZx9ANttn78eIYfeMSkVjUSCXUGi/2oCBTdYNZKtXSApq5NblpY42XFW8mP8M1SwR6MZ9J7DxlVgUvvuvQr9z+08U+w/mrSO4HIGCc5/qz0r+Fg7XWS/k7roIgz+hBzY5bttuLPnYDuhhUDO8lbjkexIIyiqWLjce5wC9zeIvepUkopJqNIXCP+Z3seMH1DWaBzAcCzgtVe+JklnQNESGTl2qHjEXysL2jS2bkP2d9b911tmeqZIVUOK7FNvLgmgtCicyS8rjhsFy2CWF3rfkdk1qev6ThdgP3GrAK/UPI8XP1DdWsNuKLsGjcwQgumu5eYZlOmzCDkJlsK
 J1Ctl9hp
 h/H1nAZheVlt6+G1ixIxYbbKCEy1GVPuNRi5DX4NG933pMThRhznr8NsWM9K+JQpZtwJuMPQX7+An7yhJgy/wsz6b9/FWoeER5VMhSdwLPDq1ZzOEdacpVfKYzKUdcghI4v4nMNu14y80cEsS6SoAQMRfOXK3+pLvzyV06zvKKwwkoMFyX1/xyGsn08b7msknJ1PmQhiays/08FQJWC2LqShb8c7g1fPcprvZitwS/EhMvbK8TTE3TEVZBhPzcjeRzj+f3Ee2QbK6NbwKmQy2Pv4aP80fGiDHzchiePl6HVPvMhOusx5u9xPVfUX9dE5xR4q+BoTX4eVV/6iQrgtDK+Exeau0dw/223OtWfmltXWNjBC4AflF1+cAKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 07:49:34PM +0200, David Hildenbrand (Arm) wrote:
> On 6/5/26 18:14, Nico Pache wrote:
> > There are cases where, if an attempted collapse fails, all subsequent
> > orders are guaranteed to also fail. Avoid these collapse attempts by
> > bailing out early.
> >
> > Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> > Acked-by: Usama Arif <usama.arif@linux.dev>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 430047316f43..7de92b28dd30 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1499,6 +1499,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
> >  			collapse_address = address + offset * PAGE_SIZE;
> >  			ret = collapse_huge_page(mm, collapse_address, referenced,
> >  						 unmapped, cc, order);
> > +
>
> Unrelated to this patch, but not the end of the world :)

NA....h that's fine ;)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

