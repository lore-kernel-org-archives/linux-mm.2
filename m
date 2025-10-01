Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A159CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 20:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2A318E000E; Wed,  1 Oct 2025 16:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA638E0003; Wed,  1 Oct 2025 16:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF05B8E000E; Wed,  1 Oct 2025 16:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 984AC8E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:32:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31C9D1601D5
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 20:32:00 +0000 (UTC)
X-FDA: 83950692000.02.1E4D108
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6BD1980011
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 20:31:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GtSBY9ji;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759350718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8cl546pRBlSjURQN2qzH85BDelkOMeWv/SWuYfgS4w4=;
	b=114YEiQib2mmhpMJjHH/06xqLZ9w0JOZXx0hOnbRxbtm+VWVGAVNOMAGwz2MIuy23b1mfO
	xs0vKokG/6m5mzyi6LeCA14xgk7doNT47KzJBD6ZND7SJ4ElgrTvjS6m8WFAHn/pVQo3Sn
	f5CiejZTyOEUg854yXJ/PpUi2t1wSQE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GtSBY9ji;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759350718; a=rsa-sha256;
	cv=none;
	b=7q/e8QkMmvgeOI7IIqnNWTMUGpqUNkAyYsGXSqMRJMb8CI5eFEE4JZt3vCtn7MHFthAW+W
	Q7mkgrwUjAJd+ZUNhTbRt7kaPbfwjKIYRRn7lXLuCtkGZwswX7fyik4YOUT8xaTrf7UQLt
	tr8KE/LTueInJtMCK1aK4GBbqnQzhgk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29597451AF;
	Wed,  1 Oct 2025 20:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C54AC4CEF1;
	Wed,  1 Oct 2025 20:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759350717;
	bh=Bv5hhmAcRm8XAjOStM5iWa+2ztmga1rCzP4YUCpzihM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GtSBY9jioJZOYjv99tRc0FiQ2/d+P6gJIYgpG61yl1vGps8M7mGNuQJjjXZ7eup3p
	 HKxlT0MN7/G+PCl3o6ewuu+IqohhlCD5Qn/AtGiLYHgtJ/4b3M24GlEvWp3Rq3gH7H
	 qEAznsBN6hj6Mz9TQa0F12tGhWK52if4nyxMcB9Y=
Date: Wed, 1 Oct 2025 13:31:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Message-Id: <20251001133155.e0fa0553030055f8745a6991@linux-foundation.org>
In-Reply-To: <660dc0e8-a23a-4cc8-a9df-bef07b2322da@redhat.com>
References: <20251001142823.4050-1-richard.weiyang@gmail.com>
	<660dc0e8-a23a-4cc8-a9df-bef07b2322da@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6BD1980011
X-Stat-Signature: y8igmtnbmimznf4nbpcyhqbs7zizefgn
X-HE-Tag: 1759350718-466848
X-HE-Meta: U2FsdGVkX18AtVkWSzyccp7s1la6LFDd5oXPkzYkM08Y7JtPDiN9vl2cGrvYmtBYmSfwwUSOyvvu8D5ICCn+W5bxp3sHaJpCjHpjOpHVKWHSFiHO0In9uWF99zp1msSoS/+YKaa9aTY5HRxrWNa3cEeDxxbxX3X77V5MBLpCBdKnA9a2xhdKJbbMlckG7gMdlU91wZ+fkdf2wVftebuIk+gyS9f5MtfhBTwDpOHpm88SFBr2XV13JzjVT4qzDJPan85/UsTapt5+u22U3tiSGGu0Ry7HnrmFA1KzA7QCVuUL1rBc64e2hZVOhUveKX4NJt0+Ct+RuA7g3k1Hb/gsYiUKu64Bld/nQAZC2bgaWuDezzgkgPgkq3/xs6XqoaCZF6PXS2IvChA73AEviAeukIjXO/IQEknSeQBRRsUa1ubce7T0Wv43FIqD66UGFdfXeS0lDS0elhAeXuCi6fcaDcH5bL/B+8BtO9M2dZu4KZm2uVMMCkU/eSvJgw0Uhs+8MC5BZ6AD8Gd0Jd+3oLB3Uqz86yRzGDf0kpWwue3NpiD2XlHLVhu+RSUeOHpUrD+2STnLGo5sDXh/BtcKtcW9O+pXKSvRbr/ojyV2AGc4QZKmZgIL3eLREAGYqtTus3CpUihutB7/xMX+cpSqaBMx242E8+9NuGVFqteEPZTDTHkgbBnRZ/zvOupvIlb/7mOXv3fPdKfYuVfL589QDVireVorcAfGDxjcRKlluQgnp/nzcT7iemLNOWjJYTnJnMvVzgFUSBRRa2s9+4D+4Oomao8UNKWVaPwSimYUNAGlYiRq0/ezhi2z20Q2ZuPfeUF9f3fevbEWUbU7WyoIt5Hue21UrNpwg1CpDPUWujwyZbJypLE9/2KUtKNu7X689I7U64K99Wx0Cwv0c9y0IKWvxPDQQTFIpFN7DNL2ZZt91+vHohwXqLU7QOwwDD1fZcST8mb0z9MJ/LAXGMcF7Zh
 qhz/gy31
 6aJ0n0KYrPwnBHtAgMBUvrptj3s4GfKIXYsLvs9j/+C9Ms2jKRit1Tm+rqDs6VgPNsbW5x2fkrX3Tj+CgruoEGsgf5T8eUS+sdtGpfjOOz+/d9vjAz1qXu7a7GrgjeeTrZ2VNIv/icSuNqQYfWoNGcVfakoS1l5wa0i3In74KhZWPaNmVFL+sJZ3svLaoTCIh4HohVGAqBVXngSVaZbrwsV+vYOpokxuEooJFbyZzXx68k7ltgHdjWzKEx2ApVWakHBOXP/CyG0unt6UBJs8tTYUojz3822LhCILDpblVZ3Pl2f+zMpiyzJXjx2HLUQWCWqWq65Jl4FdabKVnfntpZPwmS+5bgK2R6vn3+ESO45fsBT4fzvlvcSxsvu7jgSGKH6PFkzpjyz1Kgx1J3kz3lxeGF+btA+DAkfQa22Rm0n3s9JMelTtb0qRDMpIIuKxBBJsDFT8RNI021p6IMGvx9wru/+Tbz3+504aw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Oct 2025 16:34:45 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 01.10.25 16:28, Wei Yang wrote:
> > We add pmd folio into ds_queue on the first page fault in
> > __do_huge_pmd_anonymous_page(), so that we can split it in case of
> > memory pressure. This should be the same for a pmd folio during wp
> > page fault.
> > 
> > Add it as expected.
> > 
> > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Lance Yang <lance.yang@linux.dev>
> > Cc: Dev Jain <dev.jain@arm.com>
> 
> Fixes: please, and I think we want CC stable.

And a reason for Fixes: and Cc:stable, please.  ie, a description of
the userspace visible runtime effects.

Cheers, akpmbot.

