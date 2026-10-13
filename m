Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39CFCCC6B0F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 21:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02A66B0088; Tue, 13 Oct 2026 17:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2F86B008A; Tue, 13 Oct 2026 17:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9356B008C; Tue, 13 Oct 2026 17:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78A426B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:38:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1EB616025C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:38:43 +0000 (UTC)
X-FDA: 85318917726.18.0FE5844
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1B35920006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:38:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f6D1x867;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791927522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/XoMYPDJ3CILTtAwqkClhAHy0hWo2jdLCjloKhts5w4=;
	b=qmoTZeWn/KK1eFC/fIa8tHvEXRPgLFPaFsWc0sPkHl4pcfjMTJR74SXONVBcBhYwGr7dwV
	Mlnj90Gc3HfDIZT5H4t801KZGsWO8W4XO8D9EYfOZakOTZYIOnkU23+KUqYfZ6HwP73yKb
	PKzh94zXUFEX2O75XVRb4dpNFsG0nW8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791927522;
	b=tJWVNPlKMTspN7Nw6208ricqq8fS7R2wMw+cWkdFKfmoeC5IgStKPQJ4cCsGTvVjPJc7VA
	LL34+7S4VVSZJ2LDjN659jPJ4cWcaSYbIpdwszl5dMkrTuWxMjOB6ktQggyv5HNYlfpaQo
	oaEiivpfRCveFOE3VdVLuAmPNtxhgdo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f6D1x867;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22FA5601DB;
	Tue, 13 Oct 2026 21:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0E41F000FF;
	Tue, 13 Oct 2026 21:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791927520;
	bh=/XoMYPDJ3CILTtAwqkClhAHy0hWo2jdLCjloKhts5w4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=f6D1x867qgT3m1y0qF8auL0MjUypPMyLq+fTqRiwRqS5CaqKXmjUxitdwDMx/sUjc
	 YXDFW2Rxffk0b62u0SEGMfAEb6+qdH5Sp45t6hVaW7bok/b70qHYTm4SPMEEnJIT7i
	 DGv8oeWwd8bVHId+bgAtk+tgTCOLMcaL0QA+gPcI=
Date: Tue, 13 Oct 2026 14:38:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, Lorenzo Stoakes
 <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, "Liam R. Howlett"
 <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>
Subject: Re: [PATCH v4 10/13] mm/collapse: open-code collapse_single_pmd()
 in its two callers
Message-Id: <20261013143839.832f1a4db51f801a2b95f850@linux-foundation.org>
In-Reply-To: <dfbb4bac-0def-4e1b-87a7-91c9cd91349e@kernel.org>
References: <20260928100630.21870-1-kirill@shutemov.name>
	<20260928100630.21870-11-kirill@shutemov.name>
	<b2133cff-ce69-4a45-bf33-c44b774dee7b@kernel.org>
	<ar-nKHZ5hlbsXeFP@thinkstation>
	<dfbb4bac-0def-4e1b-87a7-91c9cd91349e@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1B35920006
X-Stat-Signature: 1a6wkrra5frbq4n1oobeix4j5kmdeacf
X-HE-Tag: 1791927521-269113
X-HE-Meta: U2FsdGVkX19RlQwvliBXOnfNenK3j0bCAjHM4CE3x4FIsLsmApAV6ijDluMHbRUuzccjdilJHG4LPlI7BYTXPUtCDsmFiQIop8BSO/lFHgbUTf+BhFjeNCq/DOKFH8Gqxe0ARVPBYdmptsT65Jxp2LkN21qWfswNXzY/hNcUnZq2yFrWF/tSRkYhCSFvUkGmLXT+KIDZb5DPww6Q8LjEhhqiRISIwQT/xYDM428EJj6m7aD+TifDNLi0lSQPV9r7mIr+/8DefFy78kyjO6H/99pXbNB5pxH9zgYuQSsoL/e10xcgIlDANUimC4EvyrIC//lObvvHusN1J/I8sy+hUY5DT3Is2aoiBmXBJKMLbX+gF6z6BRvsbGHaE7faG2D3v4UXMnKVQERTfQXKzd43WmzfY3dhRXff67nHiQqDtL/ZYD0uWcJTcr3uaF6J1SXf37myuiCBCklRJLHFK4twcScydJWEVWPdgc+K5xL+Yagmcb2qvY53L57IZbWhQRPAxpN1df7DogYWZTgpWSDezaiiTMp9VrVne9lKjjx4VvKRAM6lYBQuTAtP4vyLHtxWl4H8FCt7TFZAcxT5DVGdZFima1ac77IssAb2uBjVs5CqXeikSPpvEFSLxJA4hcb65GFRUdO2DZCPfkpmcxU0Ii0nhlGJMJyBBg9cZp3eW2sMuaT5Znx/9kv5QTIvcj5atWdgjG2DWxrSmjUuvt5/COtAeMB9I14N9a/IHYqdHbexUCd4M+UbviyfjFRyb9OsHeEJOIYrE+DPTr9ruDMfKdxypAO3YRLs3j0FAhKsq/22GsjYnuQ0RTfksDLB+g+JRx/4qdmY8IzJGFP7IZ15mGBV7pf1V9PubL1Gof8MoiHgSq1YZwXGRJ9VB/Pog76pa1ptGikhKvqBeWe+rOO6JRgStXSBoS/BUL8FgwmCsvAWWrOW1NZzEkTLZDP9mf3QTryJvh0wZKc+3ps48Nl
 777isVsE
 VWk8/4VWxlTJhIwFCOJiAu2vKN3y4vu/IUNIxmkYBxOVmjXdrOUDlVCXk/rdTqNcIMsuneWkMa33J16AjCpHAi0FLKoHosdlufxSBEpvyiO1tuXOhDF2nooom4dMm4eWQwD6osOFCcMylXSneCnfZDtlY4JAKa29sowgj4mev8C9+3EzXd/UckSw65AftOl/D/6Go3zYO9J8JBl5o3N0osPpiAxQm3TJvKrX1qydzfb1m/0Z/fabaxPJqO5ew0aaWCFeBjyxLztUdRZ1sVkNDqN5AO8EuBDKDJyZAeG4VceZSfPofsOdo28VgNqDq5jNd5BQC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 22:25:21 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> >> Based on that, I'd rather want to see collapse_single_pmd() to just inline the file
> >> and anon paths, and see how we can further optimize the locking internally (e.g., perform
> >> the pagecache scanning without the mmap lock).
> > 
> > I see the appeal of the single entry point for the collapse engine. I do.
> > 
> > But it costs us on both the locking picture and the scan rate. That
> > does not work for me.
> 
> So this is in mm-unstable and I want at least the first 9 patches to go to
> mm-stable rather sooner than later.
> 
> As raised in person, I don't like the open-coding here; it just results in weird
> API. I wonder whether we can come up with a better interface, while keeping the
> locking as per your requirement cheap (scan performance).
> 
> While we figure that out, does it make sense to send out revised patch 1..9 to
> move them to mm-stable while we figure out the remainder of the new API?

I've suggested to Kyril that we park this series until the next -rc
cycle.

But I can bring it back - we have a couple of weeks, three if we get a
3-week merge window.

