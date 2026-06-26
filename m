Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE38CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30C446B00FB; Thu, 25 Jun 2026 20:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296556B00FC; Thu, 25 Jun 2026 20:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186A36B00FD; Thu, 25 Jun 2026 20:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E31816B00FB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:55:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 746DE1C242F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:55:22 +0000 (UTC)
X-FDA: 84920245284.29.BB134A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id BEBD620005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:55:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AhNEfsFm;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782435320;
	b=njRJM6pwntt7J8rZ3WWKzebU1A8OzXSvjm+lXguEmZGrvDzk14Y/YiYV9I0Z1vzKn5n29I
	tBQWj7uxrTeU2Zd5Fm8rMrZO+3goLZNISkgtK97o8acfnlVNQrMsgdtNIwEqJy1fufbpXP
	Yzlt75lOTzCKDupeboJbbgoybfVEas4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782435320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gAiyQmyQj1R9+q0zENY7sPgSGoLOh0EnuwizhQfIl/Y=;
	b=p1kOUiXA8yGy0RPZvMUJMdjmlxwet8VWziDxe2Gn1aiY+90XBYT8tWOm5O8617AOrLt0rb
	DpJ4lWZ43hNan3uDCKL8sT8FgWt+asYZggVPEYAtjfoZNrl87qdaaM48NKHF/dp/oIG5C5
	sCgcEHVZJ+ZEJy7daaGZk0rcAlppLOg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AhNEfsFm;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C623D4178B;
	Fri, 26 Jun 2026 00:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517781F000E9;
	Fri, 26 Jun 2026 00:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782435319;
	bh=gAiyQmyQj1R9+q0zENY7sPgSGoLOh0EnuwizhQfIl/Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AhNEfsFmx67rHeiLL+T94BMFTgF6Q7hVh990FIfGh5uc153zE4LuyC1AeFPGn9OOS
	 /NY5xr+An6611Ay7V55cHYIm1EFBTvzHXMbf91PpmDO9Q7+WmEMcXFF4VoPBUCtoHp
	 GEI77BU40OZj5syt5TizBcQy+6yT6Wn2pmXsIwe4=
Date: Thu, 25 Jun 2026 17:55:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zi Yan" <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Brendan Jackman" <jackmanb@google.com>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Harry Yoo (Oracle)" <harry@kernel.org>,
 "Gregory Price" <gourry@gourry.net>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mm/page_alloc: drop flag-conversion "optimisation"
Message-Id: <20260625175518.d5b4a051cca43f03b1666a00@linux-foundation.org>
In-Reply-To: <DJII6XRAZ7K1.26C7HGGRAE5IW@nvidia.com>
References: <20260615-gfp-pessimisation-v2-1-65f1319e6818@google.com>
	<DJ9KK3Z7BPYU.2HDB5IVO6Q40@linux.dev>
	<DJD06ZZOC9IR.33KCFLM7L4267@linux.dev>
	<DJD0X2R79SVW.1XM7FV4REYCHS@nvidia.com>
	<DJD12YR8S99G.1I43PSHB77TA2@linux.dev>
	<fbe1e70b-2a33-4db0-b390-3841c1a84522@kernel.org>
	<20260625155045.b1e2262c552e5a5e0116f884@linux-foundation.org>
	<DJII6XRAZ7K1.26C7HGGRAE5IW@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BEBD620005
X-Stat-Signature: yrqtdukzdmhsnkx5yxmkiqa1p5wr53gu
X-HE-Tag: 1782435320-32336
X-HE-Meta: U2FsdGVkX1+7G5O7LlfP0CNsTGgHYtyUZiwr9i8aa0d2Aqo1/P28NxswMTs/ZaoWp+h28hvhJ8kcp+WdHKsaBho/8/0h+fgB4ClY6F7S48cXxHYz8PrhfTsWt9Qt+4CqZR7HwSW+2g+4u5DopH8iDi3qaSB5cmw4hsXKtcICH2D0ERP72JHWUtlvGl8ejx6EMWGxNLg4XG5NHHR1+lHsBGx9YTlgydW5s0atA+3SMQ6JB6huRmpai4WAcCmqJUFozlxNgni8AOdKPs3GU8h9nhNuB/uZ5Lc7urISBgxAuibl9yEVe0Kmww19BmoXiOI3gdK8i/yN260BhOwCPQHNPR3SY+kGyS2XNmffnakNt6ViyWgB67exkMJWrFMZ8xzER7QbwQam6YXzEmj+Pkpaf5rj6ZUTay6VAOrCLotWGNAm690GbGtmD8GV+/AbjCSorXhM3HNP6HRjsuptRqS8kGsuWRuEAK31OUqUOZSxxFrj7iBehrA05F/+dTLk9ZNtRST4IgSCIa1+1QyGg9mA4mwngCv2odfVrdBjIFS43wFwGUM+3hkvo3FWu6H61bmVh66A8wOsgf8nahD3V6lISSKZZtRruXta5suTd9fFDbxV5wS/NowmzhyivKVDyZmVa/dv4ty7gdlBttJaLSqMwHq1AYvOEbHylucI7CmLe+yn4qJQzygIL9xElgEOUXAdBgnql1ybmCRZ1DnbNxN5/utDTtU0vyqqJsrRaqFI4xJP9IFRsUi8vOACSH1dfYTGbepsuVJUGojUufRInUy7gFnuB17N6iQas9hXo52396p2IXqnk9jaalgY96VSpZjX7VMfwEc4ilwnbG6oAg/BNjl7v8oC/TBgFj9MC6TAKhL3b/0D07gqyGyLevCNTykd8JN8GfAh8gH78FxEcVfs99mqQQPurInHncmRlq8CUaSwABwA/dSVO2/EJsixH/chUfKEQus3Sqd0AhRKYbb
 vbTCYr6s
 nnhpQr8JbdA6sBqDwcvFlU+CTLqJGKED+dutWxzi/Jsx4IvrlRZFDp41dtXL396I53PpStxiWvDmJEZ9br+oGygIgkjmI5AiWaENhndcIEjvRfs91UJ1dKrAhxgpSIl6oBAXlvtQGoE+Wgt1kK5CroijpW0YiAdtg4f3JuGLCOjt344xmQ5kV2Bx1f/A2YAMlsZ7jk5c3epINX/3qZYd9U478uS0NIoluKxAvh2Y8Cz+3PHhZOlteRtwOFDZYJMFqNeSVo4O5b22xNdIZ44FFoOuNlcIbiuJqtwLiUrrWhPYW4qRbjPq1oOm+v25zx/IzWR7Uk4MmkH6wO2pfy0/eIy7IPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 19:02:43 -0400 "Zi Yan" <ziy@nvidia.com> wrote:

> > This particular patch looks nice to me.  Code is cleaner and the change
> > reduces page_alloc.o's .text (x86_64 defconfig) from 46571 to 46443,
> > which is a good sign.  So I'll add it, along with a "needs more review"
> > note.
> 
> It is actually well reviewed[1], but Brendan forgot to add tags in the
> original patch.
> 
> [1] https://lore.kernel.org/all/DJ9KK3Z7BPYU.2HDB5IVO6Q40@linux.dev/

Yep, thanks, I saw.  I added your r-b: because you anticipated the
alloc_flags_nofragment() change.

