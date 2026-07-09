Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12EDCC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 03:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01D3A6B0088; Wed,  8 Jul 2026 23:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10676B008A; Wed,  8 Jul 2026 23:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25D06B008C; Wed,  8 Jul 2026 23:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C21656B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:08:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E6971C7F8F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:08:00 +0000 (UTC)
X-FDA: 84967753920.07.933188D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id BDC0940005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:07:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lupHTsJm;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783566478;
	b=hiD3vnOSBXhzayNh1hAXV+yHe8BAGGMEfw9PmhNFx96J1ltGt684dOhqL/WUj8gjaqEhgj
	6fmMVLc91BLs8L5ecVrC7jJTXmSmUSKSDt8ymkls8/XULGYhPvnuDuSVCA5Ujn2oO2vl1a
	QN+SZTTZh0fW5QGHFpn/M16B2L37QDI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lupHTsJm;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783566478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d6OtD1ACb5l0qsIOZtpSyKeCdJxlePC+rcpmRmJTENc=;
	b=UssMCCrrpQuWPA4Rj/jlms8qPCGD062nLPD2CV6HKi+m4PDZX0pBG/O2O/hcho9TiN8EfM
	fLW0h2Y5FSbbeHrc0xxjELoXp45c6O+IRT6Jenp+MiTk0tkmLZL5SCEdVkZSbb23+b0Y84
	B9K7mNULodFDxP6Io8NXeyUR2aDCBX0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d6OtD1ACb5l0qsIOZtpSyKeCdJxlePC+rcpmRmJTENc=; b=lupHTsJme8FTJq/tsbyjGMUKT4
	vABln1h71aXgfb2hhmXzJlcOYxCCmDc3huFSFy0CandWsupPhe8b1ppwTUHuvw1YW1DHLrbFRIUx3
	T4O8nO1e4x6UcJYW/pnwZfmUEAdfneNPxjK783YH/5547t/ljiG8ZJitnIl02uxfXgLjNkb7NTV0f
	Suf4x3F0L3XxICL4c4C9rm+O5JU9Cz1Sob3En7ICYCf4XuEXRjjcHIlKnHpYyP9b/8KHIeLH8NZ3H
	1DCUOlDXn9NpCH/6xKaHdsekQqh43sdUBxVlILUUxEmEuEKa3jAJ5sKexRDqMGueCOOrIIed/Cs1s
	kJ8D8I1g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whf7A-00000003wJb-2jZY;
	Thu, 09 Jul 2026 03:07:52 +0000
Date: Thu, 9 Jul 2026 04:07:52 +0100
From: Matthew Wilcox <willy@infradead.org>
To: jane.chu@oracle.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/4] Use generic_file_read_iter() in hugetlbfs
Message-ID: <ak8QiCxpNzHDKj9q@casper.infradead.org>
References: <20260707181713.208282-1-willy@infradead.org>
 <f879bb87-0267-451b-bfed-a3e4b475b9ea@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f879bb87-0267-451b-bfed-a3e4b475b9ea@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BDC0940005
X-Stat-Signature: 697fhnfc7t4h6389ezioa85nznbx6z3f
X-HE-Tag: 1783566477-41635
X-HE-Meta: U2FsdGVkX1/Cvs/EU8tLP19d/KasYONoIA/tgare10d+CEPazoHAIP27Bz8Y/I2BR/ipgHU/3iP7ierZxtez2u0x/iAy7qQkp4cj6dyJM07NvpekALI8ybUEpWe9pPYw96siEWxsSj5/HuiY6ysU8jk07TEbjx7UAuHhBRfQjnGFB5QqEYr8GXKQF8MGMjSFkmmwp+FV35ZvkMWF2A+9f3t7iXe+WBKdSDyMMgQAXN6ModL18ticWplRrs/1QRVnY7unieZP08H9VSd2O+kyYyqv2/bZu2wrKZq+UKwDfHJZCyThNTZQjZXIaW6GGr5mkQ5e03fBCXdVWgBvNbh2zAO9w7bYY0PEDJfqhJbkJ0eH++gutotVngSCFi4lvWQO3Y3pWSr6B350MuxA1lm4UeG1bSrQbTYkisgBjUnFx43fEA9bCsjnJaR8CdGpr9SuDpCgl08dHcPWOcVZif9k/vRg/GvDL7z6xHGY9Sa5LLFFVVyc26vqfp3W9iHBUm+2/l2XiXmnOt8xanUx2PEahTw3Oh3XBUArWjDudCjbVEiUoa4+dFytn5Vn9NwLaHUe9sF08NdXX+IWd6R1zzUsDAzxH/Egt1e9ehd3A6blQ67jvVLx0EqdzvZf0w7Rd3F5xLDlMcjJcLqnvHQIrr6DNAiElEb1rug7y0h2MsR7QbWrZfL5k/WPxFe5ezvmvDPBft7zPvT6ktXv/qg0ZA9M0mmK/7AVuCXe5hFiGFtZDHC5rPaehDpR9EsFbCK71WqyVMaeTgFoDnGvQ0QHT8xnhKOBI2pknJMNjOnNOcPqUA5AKq6XvoU1EAJovpBnszWNsp+6MHHafR/G309MkiQYkCNtRNtJ9hMl9JXaKR2oIdAHHq5PRD/sJry9+9CkgiWdPBdezw4mGgDWfz3y6QBaXf9LmHrJgDr3T0rPndIuGrRwaO4OP9BmDF/ReAqZ8CcedCD3l7dKARBnGjkTZhR
 YJAPBkPP
 mpv85/bPnSIkBIqF8VkgCRCzKs+b88X9eRZ8Oz0MjsW3bxR03fJXG+iDQDan8owkecFb94sMXaCHwVT6p8ZREen2Ovgg7lcKNTlFhvkYwxXsvLEbOMpYJvlofWsb4Z4Xa+8X4WKOyB1XBAOnr6tno50yWPOTPKeb6knDj8z5/L/F4RC065Ks5VUNV8pI7glMr4/TnH4kxT3eAbrMPUtbnr5gG5/2tzC7VJlqguHFkF5tduuNZ3Y1QMsAVWJTSJIZqSibYwTOhgeCbVJSxYf1L6omi9faZlePAPraralmqsy9FWLC5KGfucnH+dlKQa82ikOUDKrxre6e04C7tKUu59mmNDpE9ZPn2ad34HleYspYYxVJLvN/4KlVWeRBOdAVSAaaxa2S43N+x/UI5hvfut33zbuVg+FjuJBg1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 04:31:48PM -0700, jane.chu@oracle.com wrote:
> On 7/7/2026 11:17 AM, Matthew Wilcox (Oracle) wrote:
> > This set of patches are separated out from Jane's earlier series.
> > https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/
> > I feel that they represent a reasonable amount of change to send
> > separately, although I'm going to keep looking at the rest of the sseries
> > because I actually need it to do a further improvement that I'm working on.
> > 
> > I'm not 100% confident in all of this, so I'd appreciate feedback.
> > I've run the libhugetlbfs test suite against it and observe no new
> > failures, but I'm not sure it's thoroughly exercising the read() path,
> > and I'm absolutely certain it's not exercising the memory-failure paths.
> 
> I can help testing memory-failure once I finish the stuff at hand.

Thanks!  Sashiko had a lot to say, so I'm working on a v2 with a lot
of changes.  I'd hold off on testing for now.  One last big one to go,
which is that we need to support holes in hugetlb files reading as zeroes
rather than allocating folios.  I have some ideas, but nothing I like
yet.

