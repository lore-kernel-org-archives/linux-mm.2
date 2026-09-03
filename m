Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA1C1C61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 02:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598A66B00F1; Wed,  2 Sep 2026 22:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54AD66B00F2; Wed,  2 Sep 2026 22:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437D66B00F3; Wed,  2 Sep 2026 22:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10D096B00F1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:34:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 605F01203F7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:34:42 +0000 (UTC)
X-FDA: 85170882804.18.AEFA1B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 97AEF40003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:34:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i+e75T3Q;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788402880;
	b=hotLlWjWvo4Dtx2OUhKs/gT8owsW2I+66h1dlEZ46QnWQWpn5wlfLEgAEqjqU0bJi/cgRL
	GdZj8I/0q1EXMIrICG/UwlrbxOSgVinMrk4dhPPZYvBuPnZXjxPwoREUa3U5naBzS/+L8W
	ap2kdXJzXkbN4tM37fJVZL7k96wsyeo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i+e75T3Q;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788402880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+fWXehxaYYCzvlRSEIRP+NK5n3Ol710P9XjHwbzJIk=;
	b=gdnbOraJ9SoibervaAKthi2kdrLzbQSrGlCPwzDItH8UnV0N1pQn6T2HY8UhhdOB9e+Xx9
	rKhraCY0cT8KtZsnX4f7l9GEnjJ9nkVVW7XZRjERg6Q8yZHgFaaI33RBRe6zmdyElThBmH
	JipiT2geqrylSJ6rjGiZKpLEE+9gYFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9418E43DDD;
	Thu,  3 Sep 2026 02:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E512F1F000E9;
	Thu,  3 Sep 2026 02:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788402879;
	bh=R+fWXehxaYYCzvlRSEIRP+NK5n3Ol710P9XjHwbzJIk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=i+e75T3QIFabgdq4302+e/kAAWTtzWgtO+55pSIvME9tAcEFC9IdLKuwSXWkr3ev2
	 mKtF8FGkjcZ9gFMt02ZfCXsxE1v+7eSbDFWoAI7EGYwYkkXR0L8ovgyp8ulCCWd52Q
	 uGw5lCOdCAr40/87QDQuNJc6zE5LfRktXgWm0f1M=
Date: Wed, 2 Sep 2026 19:34:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew
 Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory
 Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Mel Gorman <mel@csn.ul.ie>, Andi Kleen
 <ak@linux.intel.com>, Muchun Song <muchun.song@linux.dev>, Jun'ichi Nomura
 <j-nomura@ce.jp.nec.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] migrate: Skip hwpoisoned hugetlb folios during
 migration
Message-Id: <20260902193438.232552868db3af5d54ae3fa1@linux-foundation.org>
In-Reply-To: <20260701105544.97059-1-kaitao.cheng@linux.dev>
References: <20260701105544.97059-1-kaitao.cheng@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 97AEF40003
X-Stat-Signature: p4qu3phmcku5fefujm38trhh4hmfjq8r
X-HE-Tag: 1788402880-295182
X-HE-Meta: U2FsdGVkX19SjQp3+gFkGp66iVWfhRdOLUt5p2gRTUIyXAVtfV03b99XA+ViSeQEw4P9AaOO3cdjCfahvseKtAV5FUG0Sz2v3lpl9RuQ2y2W5+jhH8L8GuIuSxhqelkscc576GmpeGuyadnKk0AYgjjQDQ0Zz4BxgIk4I1PqzSM2GfUqhJNLW/cromYQ3/ej32i2DGI2oJlYhsgvva0eDY56Xl35SZXm62sT+Eft/nIIHdFOxJTXVwna5LFwTM2VDZAwcUBhRS/AFtQk4ClBtHESrY01A9Cx/Sh5nMXEXHDtdMKXbqBs2cF6RAMdpoLLZcbkLnMe0JgEfoJBwcBK7oU7ASxLDBaiEOqMsi4di+Q0nKmer0EvAovm2CW531exZII67qyRJAioVgQOCQWLijS6xFBaG74Y1jyzDvlgECwR7aIlXC7isKkJ9v253ndPHEgylj25khcU01RcSAGuhKP+Xxt0LorFMmV4SfHKEYf5rxtS4RNlazWHCXC9AWFaUVKc3EuRplCT0YMk7ruujI/ZhjW4XC101SPksxCpBCfSDLfz5L1GeMMyo1vwH+qcGj/BRVs9imB9bbDFpLUxFaYnYWw58xxmSjipT7H7kQLT3cGiK83ALGRPoRg21nyOTDwNAyhASEjt9f93whLyfcwyxQ+xvgyYCHXIWs+2Dzdl9bAGJi2QG7tRaHVwFxpEolSRM/LGVcSWMYzrgArVfvwuM+e+YZaLX7np5OEMnUWgYoJW4br1gw9LMXc66Dkkd2GqqX4OetdbPyyHYloXWg5AJLZ+SSfea+Fo9+a9h8JcUY/2LPs/Y20fj2dJLLW+oaorNBqIPk+aiRVWWwVCK3xA8QgGGGA52Eyw8K1/WzKVIfqCiGGgkoQEpeUAEBzAWk/cQEkwMrNZiJBxC/JY/0xkV00TJ6Z5U/u5OSd6ldvGLnk4VnzxcUoVkudY5EtObdoY9fttd3+aS90yI5d
 loLOLSSX
 8yVt3r18lAXlszRVP0ypAC+BGmfvKqEjPfcgFvdLRvOw/XEas5vRINi0+uhfUWzbVdz4o3YUHmq8nXyWTUnqiCfsrnzEz/KuRrQmEihft2AmmySucbd54Dy/gVjoBEInzO9DyMZHVtIjNdajL6cQ1mNhLRuGvmH4u4oO5Q3TKYqAsOf7LFEpmG1tJsDFEKI3srblrvD1wcXt69s5kDgm//oRiuvow28/Sp8f7nWXI4ldGAZ5lvYd4FObRF3QPSn0H22HMmHq6QCqPevjywaWw2krwfNrFtcFI1gXenHCFoecQob/JLLxNCRtDbl+ojFDSXhJgcuO1C3erdZpGqH7k3hxol+tQU2Rh6J+mWt96mtrEiMGQ6GlBstVED6KCpzl06TTd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Jul 2026 18:55:44 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:

> Date: Wed,  1 Jul 2026 18:55:44 +0800

Well.

> Hugetlb migration does not check whether the source folio contains
> hwpoisoned memory before trying to move it.  After the folio is unmapped,
> the move path can reach hugetlbfs_migrate_folio() and then
> migrate_huge_page_move_mapping(), which copies the source folio into the
> new folio.
> 
> That copy uses folio_mc_copy(), so architectures with recoverable
> machine-check copy support can fail the copy with -EHWPOISON.  However,
> there is no reason to attempt the move once the source folio is already
> known to contain poisoned memory.  Architectures without such copy_mc
> support also fall back to a normal copy, which can consume the poison.
> 
> Check folio_contain_hwpoisoned_page() after locking the source hugetlb
> folio and fail the migration with -EHWPOISON before unmapping or copying
> it.  This covers both a hwpoisoned hugetlb head folio and large folios
> that only have the has_hwpoisoned summary flag set.

As always: please provide a description of the userspace-visible
runtime effects of the bug.

Even better if you can present a reproducer.

> Fixes: 290408d4a250 ("hugetlb: hugepage migration core")

Oct, 2010.  So I'm assuming this isn't super-urgent.

otoh, now it's out there and known about, perhaps Bad Guys can find a
way of triggering this, so the urgency becomes higher.


Anyway, please consider the Sashiko report
(https://sashiko.dev/#/patchset/20260701105544.97059-1-kaitao.cheng@linux.dev)
then update the changelog with the above info.  Decide whether we
should cc:stable (and describe why) then resend?

Thanks.

