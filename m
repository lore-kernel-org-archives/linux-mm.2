Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F3EACD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67866B00B8; Mon, 11 May 2026 07:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3EF76B00B9; Mon, 11 May 2026 07:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7BC16B00BA; Mon, 11 May 2026 07:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 967C56B00B8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:56:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DC9D1C05F8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:56:50 +0000 (UTC)
X-FDA: 84754987380.12.AD73808
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A5672140009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:56:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LtRQQZSf;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778500608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vGdf13XXX13xG1g+PUbb7MpjUGk5XWxAWkONoYznhFQ=;
	b=LVaAUXd2Bzh5lQEFUvEeZcWXoYVEdeVXTqTivlAg/Kk25UG6MhUaOCXrW4kw+k83oyAw0b
	jOK/+mqlZdfWxasKdurMHgLybTF2bMhX3oAFTQV7VkssgLNPDlw632ZM8vZMp6dh7lo7HR
	bq1tOf/WUkh3uC1Y9eK7X6ciVIkZtGs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778500608; a=rsa-sha256;
	cv=none;
	b=T3iINRzJod9mvU4rQxUZaPKlG7SPfSFk2t+qnXYQh/cu8q3rNCpKBNdUhEB32Vhx5DhiZT
	Qhb0wkXeTJkHc/z+ZBLg7MsGgTupVBUoZeyeFL+szshmePJOPJ8N8wJi8k00n99sPMKHN2
	BU1+eFLeRPyEXCbnMqdcaE+yCFt7tIg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LtRQQZSf;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 73DD341794;
	Mon, 11 May 2026 11:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDF2C2BCB0;
	Mon, 11 May 2026 11:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778500607;
	bh=RPofv0sJIx1BCo2Ks5FWiQnTOmzxK00LHgl2H+nVruE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LtRQQZSflLpDPcYSSW2Eym9IkYemtgSZn79u/D4IwuPzXF/iUKo1YguDzKs8+jnZN
	 wILT2t0cv01gTvm9pHZ8SeMvXchNRjY9mP7pZfYrbBxkAqm+PbjBI8j6q5feGc07BB
	 efAR4iajWMdaArynmYG1xj5MjZkS4VAJ4ZSh3Fgyn9ktxfQdmnBeAkl+Ru7LwZ1nva
	 ooJYZqsTTcqnqIndjWfgepNBwndgLARlwUmGo1ucOMtHKiae5H1rXIqHyp0pz7gMsT
	 dhONrAoW/LGU7Jul3d2XzvVQRz89joXDRfwvOmyWslxOZYBWHo1nFZLC9xlbogETvQ
	 uYek6voYXOUvQ==
Date: Mon, 11 May 2026 14:56:40 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] kho: allow early-boot usage of the KHO radix tree
Message-ID: <agHD-E4iDhvUEZDS@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-7-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-7-pratyush@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A5672140009
X-Stat-Signature: 5fds87g7j6g6i1re4sksuwaoeqfbmb8r
X-Rspam-User: 
X-HE-Tag: 1778500608-837732
X-HE-Meta: U2FsdGVkX1984uRchdPuYK7necxTzjXssZNJxqBYRLhSVWae8/4wy0hGUlcFvGIgMIErJKBK2zCzN5xxOCjZa1O+FeQq6YOhj7AZkxLj8VWkST9trgOIJDDV4qk7jfAiBg+OoXCmDzUwAPEy+0jZEE8hu5nM4B/cfzTV0Z+MNuq4YD2SknhoCjwWXKeiQhTg+G1XTX/2kKcFYrjVYVDNvSr+iLeilNCebbBrl5YZ4th83ETDVkhmxEpMRCNSFA4Upw2pjF1nkpWm0QKSDNySsptNlGOyDcUVyR4kTRdL80SHh1fvt0fBZN+vRfBcxTT11Br75UhCLTPQc6iinv8BSxIoaBju8UcOADpfkANZz7fFiDvW65d1Rr/oyHYwx51XRPVaib+lCy2pS10OCF8/o9PTRhYnul+R4WDr2429th9PmK9baMHTfsN/OZgPnElchXItf/j5yCGMMencoVQr+7Y7WgG0CfZPUFGltPB1jbon+YI32KKysrzW8J5OnHolFSk+SZp78+xSmdWacNpdwIqXsfCHGQbfO5oT+KXXv29BZTUHr/Qyg96Kx8opGwR51VpGhaJqgunnh+m2aQiDx6i04SL3KiJdIuaMiWLtBAkIAzS7kWBoZCHMDyOnSX+c8IF3n2QQwseLsTToj9UQr3sAh5hWZg2Sb0g+jkLbRqxmIK8nQMzDMz+UAa+BayyJPDHLCP7yfxo7Dp2ItcASFVrmu8mAelzLqWYWyQka4sQ3HhpjEjwIfy/25h2AQdtoJGy3tl9QhhQQTKNeYJLABq8qKf+6c52kyNZzEzzbDykkT0L1Qu3Vks2Y2AUA21Ui0SiJG8rNVD9Bcy/3I0U0u5MbBGj1u5cTdvn2qYg3xbuP4V4rbiJqlvp9cbkhZbXJWrbcpsqPcKigOGAWleAroyHkaB7+kQRav5E1o9Nwe8cOz7hRrkHyrzd8TkAVSSA/ssZZ4rAnMzrE+Rrvepa
 6bCleBxR
 LCG3wtjUWXsPwYB1YNNrdNdtQFl+ojTqwsQKGRtxH2gb9z1tqpEShWP51u29Pr5NKQTbNS/0RYzNLJE9xXiYOCrA76xWtvNPcb6fPPIUO9yaNq4R/xig9AIY7OV3VfFNxGqR+rZ+R576WasRwJQFNB4KbVgvuvr8GqS1YUoZtXP41XOdIr7McbkgaIjeHx6oHvyXAnXRQHz8jSw7T6VSHfRzQFtHckg7jo9OVbD6qdbCzm14pEoDEhVmY14zNQ2aOGggMg5x0aZn26brTvAtrh4p2MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:39:08PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The KHO radix tree allocates memory for table pages from the buddy
> allocator using get_zeroed_page(). This is not available in early boot
> when memblock is still active.
> 
> Using the radix tree in early boot is useful for KHO to track metadata
> about its memory. One such example is for tracking free blocks for
> memory allocation when scratch runs out of space. This feature will be
> added in the following commits.
> 
> Add kho_radix_{alloc,free}_node() which allocate and free the table
> pages. They use slab_is_available() to decide which allocator to use.
> While slab_is_available() indicates availability of the slab allocator,
> it gets initialized right before buddy so it serves the same practical

                           ^ after?

> purpose.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)

-- 
Sincerely yours,
Mike.

