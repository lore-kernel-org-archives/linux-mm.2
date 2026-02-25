Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35F8EF55440
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 02:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4949A6B0005; Tue, 24 Feb 2026 21:41:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 418066B0088; Tue, 24 Feb 2026 21:41:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323C46B008A; Tue, 24 Feb 2026 21:41:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 19C4A6B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:41:53 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7C55140420
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:41:52 +0000 (UTC)
X-FDA: 84481428864.27.BB02C6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3F649180004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:41:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oE73Lipz;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771987311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qz4T9KtF4OpVPbLm/tKvv+AAw1nv+sJ/T4iDdTAWQBs=;
	b=gn+pvkQpJX/BATFHAWAH2HRFMMdJFzKpKhQPOkEP/3HoBZIYg+57d2XSrkbCLXdU6diArP
	2L0bdN6FOXhYvDmIs7a8n/zUmPBfXgTwfGvhnwju12cRyxoNpGi1+lvaUEwLXlW+ju7vme
	L4VhOQsbYOVn/N1DUiss1zspyRqCjl8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771987311; a=rsa-sha256;
	cv=none;
	b=UDXuaT8C8kj7/YpImHrB0j769STiHb1P88XFu5qxuEPlFDF85xMgCaY8v/nxjfPRgy8v3j
	EfaclQO814BlsYExUrHagx+6pKX8NK1TNH2R7fDoHTgQUVvXyNTGVAbWAOnVQ/jvedsXxE
	9b/jY55GgIhxVK6LYXQ+jyqVtNSGd9I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oE73Lipz;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8965060053;
	Wed, 25 Feb 2026 02:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD360C116D0;
	Wed, 25 Feb 2026 02:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771987310;
	bh=X+UCdq3EltqI2kB2VmHcF9/abSCI9lHMHlMt8E+9skw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oE73Lipz7L7jhvkhCXqac26wsSU0x3y8PBJpcNZ7pe46/1BfZAXyoGdt3hDYbbdjO
	 Ewb2I/doxXaY29qKojKMTxfwETmXiEnq4Sxu31H83Az+mCIbP1yMUsMg89qSYid5ju
	 FYuPwyH484mW00JtTx5OuqWpnTYMGlT7KVFqJehdxeONWZ6ufnHCzmyzVOH+1dvase
	 J1MiCAvR1+TYJBvmEjxjcIxq385v88Jc+ZRllGrcEvOz6718VPM8F+kbQnMtzGTCyn
	 Uw1zoA24xlTT9nuCyV9sumBZZAAnaVbMVGwHunxbwvpPMmSJ2FOd9Xa8xLwwKExOs6
	 gAf6Fs9vp6tTg==
From: SeongJae Park <sj@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ron Economos <re@w6rz.net>
Subject: Re: [PATCH] mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
Date: Tue, 24 Feb 2026 18:41:47 -0800
Message-ID: <20260225024148.63615-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <88B98450-B0CE-476D-9E09-98DF6A1F6E3B@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: 36e1pkiztgxq4bwpb1aukajnxsdak5hz
X-Rspamd-Queue-Id: 3F649180004
X-Rspam-User: 
X-HE-Tag: 1771987311-763529
X-HE-Meta: U2FsdGVkX19Sv8+jM23F3FZm84RQx3EdfyQtZdKxEeBol6AS9O8lyx7M7jUv4/cXwUwyDgyXfwY0L5UExMXdKn+gDNE/GLdLwsuQRPTtkczmGaKEUggDUhHPEJbyTnezaRPNCVnFYVJywC2QGwRRa7w+UKMRt27dgH5QfaS0lJonGO/PCD8YbtaJKUtlCKmhCpcRY6mm2Q3fzAYCSDaPXlKJV/PSIrfV0ooiNbrtLULCl58MKbYhvFqxSzUPl/XItFapw+PN/6sNtPWMD1r+keocT9X5KuqAAR++LxuWwyb2JFK6MAZYUOVTJ8X82/WN3lc+zgveXP0uNK7GXYOA/NbD4cwb/GEUdNq0Ul+a+8phMCDASnP9cWzNb561n8LplrJZ5vOiEoL9sYTNBMbrPyuqWM5sxOfsZ15V/mWVNglXLuNtVOhT1OXK98/zTsRIJu9yBeHi/oDsmeslwHCDHsmbf8fXoO6NFoQxALaTlfVP/W5h5i+SKUi7IXV8TrChfHMzr2m/pXtbRW0+jMk1dUrq6hL+2P0vjPMN78Bi6MyRG4Kxv0+3UgL8dK6cow1hchf+S9+MI2alLb3wJS1UxDeVGlHHP1Fg2s3hQ8akYeY+qI/x7p2wOSOaxrlGTDbWUIkujivElkuJ/6719zXgovq7WMtlr1f0S/CcCM166r/PXCBGMVFBfaQ4pkGynBTyheW9Cq3t0Y3578ZDdhttnyXxtdXH13nxwsQM4tsQYzCGLyyGi6aB9OxjXM7Smhws8cl/3vaEKgsj8Cz8zd5hgJ0f7tKJLO0tdvN159RPeezS/pEIv4wQKQo38iPB8U/C8bgdj4REyH+QP7ghEr7Is+wLAdIEemO9aXjnfVWGUQNXm55u6Ur22NnwNAdV8Lh/JrQnZlwy+aTIUhoGhuw9LYz9R4JCK1vxO8j6lPY3MWR9Yezn4G/Rqcgf9fkQchqTWhu5Z9C3QAgXJFx3rwb
 cfMQhfRw
 9V8eWDD0mo4cYZCOfdTDOynD6Wxg56it4Ap6gLGSvxNvpSU8Qs8dolb7B6Ptqp/EYt0r9cUUxFTbInGa1ruUfL9z/qh8w6XygvnIAbGrLzbGQNP2MFngFFQ6n5yYW39BCZ2KE82R5V6tTuFqaBFDpnRCvC0B1HlOzW8TtGXpjPGFPVhHgQlPlZy9Cmtz9vewfcgORUrhU8GsKM4jEb+HUXNoPp2gqNRdm3K7k42v12kSdVNoqgLnLnZ1jYeUwWWuwZmAmtoM4Lgrn8X5S6KQsILWZ0VN6R82WwkduHFUDKIjpEpujNSyXT9byRonaPjR72aLWDPE+ujlJ9hKDVIXsdrZ3dFiJpZlfqvQ81iz+y5q67yw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Feb 2026 21:21:55 -0500 Zi Yan <ziy@nvidia.com> wrote:

> On 24 Feb 2026, at 21:20, SeongJae Park wrote:
> 
> > On Tue, 24 Feb 2026 18:18:44 -0800 SeongJae Park <sj@kernel.org> wrote:
> >
> >> On Tue, 24 Feb 2026 16:39:46 -0500 Zi Yan <ziy@nvidia.com> wrote:
> >>
> >>> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
> >>> with side effect inside it is incorrect. Move put_page_testzero() out and
> >>> check its return value in VM_WARN_ON. Add __maybe_unused to the return
> >>> value for when CONFIG_DEBUG_VM is not set.
> >>>
> >>> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> >>> Reported-by: Ron Economos <re@w6rz.net>
> >>> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
> >
> > I forgot asking this, sorry.
> >
> > Should we Cc stable@ ?
> 
> The commit is just in 7.0-rc1. Nothing is needed for stable.

Ack.


Thanks,
SJ

[...]

