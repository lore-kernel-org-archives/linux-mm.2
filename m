Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C773E10ED640
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BE3D6B0098; Fri, 27 Mar 2026 06:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2483F6B0099; Fri, 27 Mar 2026 06:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 136AC6B009B; Fri, 27 Mar 2026 06:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 025956B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:00:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B745C13C57A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:00:52 +0000 (UTC)
X-FDA: 84591399144.24.33FDEEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0ADD08001D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:00:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SHEWFF4D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774605651; a=rsa-sha256;
	cv=none;
	b=EJ5eSgB50aB0zyHNhMZDbDxLNRp7QbTt0HfWYBM/gcNKtZikxrHmWFmFMs438RApgUiSWw
	HVkmqZ5b6WYjbFOZBJGnhuJhZP4qYngVqWZAenCe+on7GeYWjiF5Jh4SkXv0E2wTRpJ2XA
	RJ+X8L+uTUvRf+zsvUQwqH9jP9PHxXU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SHEWFF4D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774605651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+56grdb7ac39ib9dNl2LtTcrr4nD402U9sEfODjWW0=;
	b=1rrgWlLRvmrVlgUxdo/SUNN/YaXN0QO9KKOkEbBdaZV1xdI5ot6hAAawE+8d7B8IaNX90h
	kOaGMxdDURnUYggnWubM1Gp0dO622zpBxfenuG9IsKrIx1lfZwvhe4gb2rWEHhp3Vzbqzh
	BX2qntuZISb2k712YHLoFYFD1GlhZik=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 61DAF60133;
	Fri, 27 Mar 2026 10:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16E5C2BC87;
	Fri, 27 Mar 2026 10:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774605650;
	bh=o+56grdb7ac39ib9dNl2LtTcrr4nD402U9sEfODjWW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SHEWFF4DGzAUakw0NqO9GKKRmb+hHKJcxiJIGhVRQzTY7M4bta6YERD/kiroO6Pr0
	 omcNn9ffxRkOkUo0LJIAMQRgmJe+tVO5KlaHYsQ8WlBLduUHKd4UoX17+E35lrRjH8
	 4qcl0+8DqCnKOykRq5jTA8ShIhz+WY+NDIPJlOco+S4BovRxMNxlLCKMlCGMNmOACh
	 8pZIEJp6s8rymij3r5asHb0aS/0MVlC66+pBoMb2rz+1LCeaB9OJfPYIRzVWHZ6cT1
	 xYm5M+WsWB0+fDtrmgfFja5SZncbFWzRtKUDXiE38PdWZBY3wJ8KTK4udTmR1oOqQT
	 wJ8DHYsIKy7fw==
Date: Fri, 27 Mar 2026 10:00:44 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 00/15] mm: memory hot(un)plug and SPARSEMEM cleanups
Message-ID: <5a7ad1c5-6e06-4829-9971-05d3c599e581@lucifer.local>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
 <20260326195816.60110f50cd464d0076aad0ff@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326195816.60110f50cd464d0076aad0ff@linux-foundation.org>
X-Rspamd-Queue-Id: 0ADD08001D
X-Stat-Signature: cb9whobbgrnsur78h3fb3nfirmpn6u6n
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774605650-124192
X-HE-Meta: U2FsdGVkX1+DkjeuDAfHLCUH8UYvmFwZem4pN4Mq830GRzOm8gkdeE+QLhslIRcmAB+4UmGlEEg9gVhloCFM9PplITWHUsohYDy83M6CJfvuJpJ8OV92LPs+5sRVCieJUfE3aR9jCUytMKq9/rsd84SHz7ISC3clSv8UJxv9N6ozuEGFRHwE6EEMHucEvkA7UennX8FYUbgkMDLA2MXndKUYi1ieLZKvdra56r/4mjeg1Nbx1K/KBU3t0+Brosj8j3FGdh9D0dUjk2CHS6GMQfBthmlnn0Vjrx+vEMfh2ZrNGAgNbMRHEIHcWsASMgju/f7ETyBtcPRqs/zbC5HRYlICXeXD9UGoH6muJBwWRBPnT1RuknvU4oirvFBvcHlfDONqcqWMo1pAN++I25a+gl1MjoypZiVaSPLDC//UIx3rQtYOwXH0Dsv2JVbZmSj0AOyaTFzY2rofSFxC5xaU+Fu2xo2jgTbUOuJxMDmSYY+Ein5EzQiU8Z/QaS50smEp8KTrXwayg5fixlFE+ayr2suqL+K+9WARWEgJZi8qQwxiCb79e47H8dIZgNEqBRrzWdJg6kFFyyarWmZ97/TMNpiTGePldIUb8mIWetYFNAaQlaCIk24c57m5c+stmsdCf5UZ40pughYLXKHeBye/pwsVkiHA7DZ3rJnatC6uaApIMZoUY0dp21GtoYD5wo0s42eg49fIgyxKCs/jxnGWtJr7aYiyEGe9oO8rWwLS+Vfc8ZRL34v1gWWNsIv1xcoT0NMXTKyi2tBhR0b0rHZAw4OAKtkOUP1h6NQHcd9lU7ZKQ7onzg+MYgj4JJnmny4beqrV+mwqAZHrCxxnKVEUcZBu4m0Wd/Z0/Egtr6DzmRmPUXM0IK/rlwUy2jfGBntWTq/0X/epFI6AyjkXkK7Lj6Xi1sj3pORKH2PQM2hEhn/+/OiUPI/YErOstqLSRcAqlTpt56ingq2uwBIV1Lt
 rUKoZnSc
 n+HUTIpxRWlt9DjSj0ESEAPJuKMNPyYubHHogDLOabvMea05NMC6lL6H1X0fMic9t6l5GdLMuL1/R8QOFXix67cLuc4Be/cO+WXlb5zuqyr5ddaM6fZob35S+ZOCMPnf8NpAEZCQB0BX9zQauFt9Nlbjrt7pF+U1qW+znwFlUERsZkOeCwoFZJ2x7tEePHH0mwrzuWep0xpo8X48xDgLQ+QNh1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 07:58:16PM -0700, Andrew Morton wrote:
> Lorenzo, I've assumed that your conditional R-b on [01/15] is now
> unconditional.

Yeah that's fine.

Cheers, Lorenzo

