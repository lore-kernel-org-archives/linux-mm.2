Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ABA8109C033
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60E56B0005; Wed, 25 Mar 2026 12:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11C36B008C; Wed, 25 Mar 2026 12:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927D86B0092; Wed, 25 Mar 2026 12:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 844426B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:23:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1AD851A0879
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:23:04 +0000 (UTC)
X-FDA: 84585104688.04.A32DFBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 35B6C180003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:23:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EcJrc4jX;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774455782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNS3L4Ed2ePfUxJ3Mt1m9TTP9IpJkzNhuIFw0PohGQY=;
	b=17nGIHRMt0SKv87k/Io8S0WRhIhMIA0U97af0/sPwZY5aEW3PyfzYVz1shi3j44tteWm0v
	6G+w35dXJ8DC0UfwLKbOZ4J0gpwNUJ7dlUvUB17VyZhvx0/1DHPr4gDW4fSdemZAGFn397
	08wVAwpa2O4CQnotsEw+l5Bq7/Glrnc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EcJrc4jX;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774455782; a=rsa-sha256;
	cv=none;
	b=fr8ONANe16hBGaLPP7oO6gdQCzAuPnFq/1KDNAfGAubIxnZlaBQX0u2S6eo0kcmmavJPKF
	qwukNSwOazdaogdRyDTgcj30MxGaPdQ9B6N5WzOhwMot5PVbsYYJFNs6GiF1cZNkYUS6AT
	Cvd+HivzArBTAZD4rROJytjnyN4VfJ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4145F44091;
	Wed, 25 Mar 2026 16:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809F2C4CEF7;
	Wed, 25 Mar 2026 16:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774455781;
	bh=HNS3L4Ed2ePfUxJ3Mt1m9TTP9IpJkzNhuIFw0PohGQY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EcJrc4jXhkjS1IwRHrJQpXTUU7493bM0vTlSie3lftXDQPec713pkTE7npY2RoUvd
	 Tbbtvgj7VE/dIFZIKnm6tg2E1/olfufGTh7Y/WK+x2xg5mzyZ5hCNzVDAHimyvzZsJ
	 VU+/mDbfKcVc907CHicbk8Ai6wZVwCNzYZH7K99Q=
Date: Wed, 25 Mar 2026 09:23:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>,
 catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 dev.jain@arm.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the
 references for large folios
Message-Id: <20260325092300.9008e605ed5550ce4935638f@linux-foundation.org>
In-Reply-To: <af9d8a6a-074c-412c-ac5e-3f0dadde3e7d@lucifer.local>
References: <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
	<CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
	<d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
	<43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
	<e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
	<86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
	<e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
	<e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
	<e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
	<20260325083016.a32095bea3f04488a7c9005a@linux-foundation.org>
	<af9d8a6a-074c-412c-ac5e-3f0dadde3e7d@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9o4qu1nmgy3zfg5wde58f5n3q7ote818
X-Rspamd-Queue-Id: 35B6C180003
X-Rspamd-Server: rspam09
X-HE-Tag: 1774455782-382629
X-HE-Meta: U2FsdGVkX18zNthg4KVkT6/W5VKzEemh1oPuVT4PROL/Y2ghzjI67hpfwz0K3BaYpnIIVwknQGqoM7NwUcMFmIYpgZPtlX7hPEPGn+p8xHEFyvjpVFec7Cd836uqzm4xzeJhaiVa9JArtqu1HJkHqrHqxiLQ91LT7rUnNC4+bVXo7SvlZYrddVzBd/4/iJxyvQh/rDSki5xJ7IhzN88YdaD+9ZqGTDtNv8M8R5cRNdZm3bwxx8SQMTyC5W0qTd6SCSZ/iDuDzdZK3DhfhJtWogZ8Qxpn3hsRE/faRUrgm2fRRrJ9lZUgzCZzyqLQbkziNThpUncfOqQ99UV4g2xsMOIuUth/T8CXuZPNLAyWJCrUYEEa2hJh67BLDUtLL8yNR+7KxwU50g7YvNndf65sCaigi55TAIOS3K9nn5YqMNIgQyACAOeui1krcaNHgDykhBCoW2SWlEpnfifwyblCGr6hrrzKG4yf3eleoprU1uFCs40LWqOzXPphWvZnY+C0xzDja/mBr+rC4c0s3imgcbM9woBQPIMr46xc+OH9SlNRHz6GvS/ooiG6xsvcTHP1rzk3U7YCsYoTFtaKKPXZW2JBHl7s1nWVkvwzNiRdd09lHGG1MEazd9UvLfSNNiH+HE1CQ5A81NIiBRTbHYSzuUUACKe8dWQn40TFgeFDaFQH8bKWQRGA4wkfMgLfijqwk60moSimYTu5jez0Jh9FHpVwuEcsn/MBA5s415zzo9BbDmFuuiyRiZ2O66Z6IkXm4o3jHgP6Ea66dPD3OS8LjmW20Tu3cvGFoInRBLzXO7+ojBceHPLoMt75qdxEJJqcRcCU619mEn3SBJl3T3PLXDu9QM6fCgr8r7T4FsTLxRyaavgw1XZWo6bG/SFqtfWn824ZvrfS6zYK9I/D51QKeEQY8Vma7xnAUvKkhBApUZsLR3FshgIvrajxBjDbFm9/XN1jH/dvYYwHUExrRyf
 B2emX9HX
 Zyg6tnL9YuO0htx8eRfx7Lt8ZX9I2+sgON8LBop1KPVZ6ghiNIV4D/GCvMHCfpY16RxubDKIlWANICRX/4x2sYzvpEwaDIr4wDmxz7q03L2Ge+lsT9Zgtpa3QoF2bbuGlYwhlXAaYww/W3xsVGH7kRq4tCXANIEMIXO3kJDJ5rtHdkqNhCI5y/GH0C6bGGajB9tdrs/h9IpXjpcg+JYnjc4mmmy8I3Dps7x6BxelmjOMThFZOy8YPfr7cZrFpbBU/tay+jf8yKo+V05kwwSUQwpdYcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 15:32:50 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> Really I guess I'd like to know the timing of when mm-stable is taken so I can
> know the deadline for stuff like this.

Yeah, as mentioned elsewhere I'll add some words into the series file to
try to describe this.

But the start of the migration is quite variable (-rc4 through -rc6) so
I'll aim to keep people updated in the weekly "mm.git review status"
emails.


