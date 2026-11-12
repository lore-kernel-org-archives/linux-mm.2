Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BCB3606A339
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JShWTYBw
Received: by kanga.kvack.org (Postfix)
	id 9925D6B05B3; Thu, 12 Nov 2026 06:54:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9696C6B05B4; Thu, 12 Nov 2026 06:54:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B686B05B6; Thu, 12 Nov 2026 06:54:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FA416B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:54:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDF2540569
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:54:19 +0000 (UTC)
X-FDA: 85426309038.06.ABC1C54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 52BFC14000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:54:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JShWTYBw;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794484458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXwEBWpVcpvZcrV+jXWqjYnIWZkbHRe6QYcaP4OKLgA=;
	b=euYLY3w/9Fr8OGBfrcc1qyJKiDOqt1HRPQOTyk5FpzE2g2kSs6MBgbcBjdXT0MD7aSdEhZ
	UUeL+bKdR1hOpd8OO+DUeNbpAH5iW+oPYQhaHL21+R82J1gIyUXjt5qqqUgG7i0cxDzCF4
	vc7BZKEji2b/pBXMeMZEC1kZwwl6vYA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JShWTYBw;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794484458;
	b=X62FFCzO2Z6fye2zhMzGwP+nHQwOVEe5wVPHv5REQx7lY5yQkTMf/VpOMLnd6BkWlRXB1L
	SnjFJfB1E/4uRjwrveZZUFdg29LwITmXzTl3v0upJ7rSETALdkMp/tXp2kdA9Ka5DiJKbp
	WTFIlEAuljL3dG+8Htb1hwQ2OAXq6u8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAA5361CEA;
	Thu, 12 Nov 2026 11:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A951F00A05;
	Thu, 12 Nov 2026 11:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794484457;
	bh=AXwEBWpVcpvZcrV+jXWqjYnIWZkbHRe6QYcaP4OKLgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JShWTYBwz3T1m0D+gMlzyAXZUOV5lZTEdKWEmPLNzsIRW+v6wGYjzrWz/3a+qlIIh
	 uHEBwZWTzfI+8nM1pcwM53SGkhGVtDsLBHshuYSxtzNG61JCXbS2MprM5hV/RW220H
	 EL1fsA/x1UUGroAbYZBw+qSGfyZB4AOspBYFjnzgVnaVolzaeMfQXuiyzSNiu/Vp5y
	 FZk8uOr8DWU5XDcsKIwXsglFSq2MXx57+zvKA08GWuWTcIghT/EEC8a7yprTEzE1K1
	 C3sWmvVFn06QL/mupd6DGhe9ParugCE3t4qUWqqEJB1lwXJ/5dePwtcAucWejA+WvE
	 v93jIoibDc7rw==
Date: Thu, 12 Nov 2026 13:54:08 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH v2 4/6] mm: drop HIGHPTE support altogether
Message-ID: <avWo4NrAPX8BisCY@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-5-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112112528.1116405-5-arnd@kernel.org>
X-Stat-Signature: z8nr6gpemw3pt76fkupppcf4pd88j9id
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 52BFC14000B
X-HE-Tag: 1794484458-462759
X-HE-Meta: U2FsdGVkX1+4La9ZjqH16GLSOcRxBINOvmahlcdq3uAu3uZTU8VeoPIbtRkJ4L+JHyeGD0+9T832dnhkDVQhZXGCLBq4+/ggd2aQiU+DcL1Yc3whTssoUn2cnqG+zbLFx3lg1jWb9bV6QoLMghZcQgItZe08/Lk/zOjTwh+EETnddmtcvEaJIy9vlZl6fqwEfpPu1rX5+vgzMhuqWv3tWzJ96EMyr5lJCGevcffnnE4KK5fc+B5y02RImhT7Nkcs8Jy1/QPibYd6iRvu8X9qyxqkCcZrpP3c7MwidKWHwS/6uxhpOn3bojiP2nJT7K7UZQSRnJHhCh4rd3LDIURhwjf8CLGG7zZmCBGprTOBkpgavKidvdOihyFBQjB67INQHgobAMMdDpAxB+RIrr96NOYNuL14p/4M846llRIt0u/wE6CUZVq05MIrD63QK2eTuDxAbj4xQxWS/5AIfbE7XYKPRZl4LNTjN3O4oKaQSjs8NQk9TWwkzqDeAjPC2gqXpgNudvMsQErCj10wwaOxfozw9tyNQxb2SCj1n+J1eKJQBZdqCQrLiDDk9O/rhfE0VcaVA6YYO54rjfez9PVmupLoYe4hQ2gxpmNLyRiwN7tI+NpZkZHXdyWKGE47uRRtLT2v5iB1dL3iY1hWO7O2cAhF9ANqwYt7k0KinfavdMu9+uqAvAuAxBbBt16VTPxixLLUierMMJUQTQ9AlSYSvhDXY/a6OFzk6Fqj5le+rL0YbaVKiJDl9fdm+sUf5oKrcWO9RtphPr+w/a/vGaRzbxTkTQIbuR+3IWN5TbBTO0fdMC8G8SzzkNsg2GQ5nGD+AkMeYFQ5cIsH6SKIWlYLCniYKSzaOWs9IhBiXpNq+Ei1ELq7XMx5H2J7EiTsAMk4y+tPisZHDsh4K+oglB7UF/kan3oce8yiwSI7tw7pjMkhtaFGQknNHt6LJcsvdvqMMfjX5b7Jq9pHsr1UncK
 v9LEaC+c
 6VhHj407orB7+030M/C/RefmJintvo/KMnVYFp1UJdqcE4aGrzrckz2xvtijfNy5+h8q4kBkUXTvo1eTnsAIytIbzMK8UbdvhZ1bBWjwXsFAHYAhvLgh0TSxtf/BkOXgZw/ba8nerLLxN4gm3hNTH0wenI2A9DUkyPdOnHesRkDuIeDyvOd9ntgUchpCt8KLROAQBpqKB/Eja2QOlEQeHzAc12Yx3Gtkb8Dvq1/BaAFdLucgd4LEyYVZB6nNRX398DAbPIHE3ELyVwvUiGnNnhD35yQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:25:26PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> With both x86 and arm having dropped CONFIG_HIGHPTE support, no
> architecture is left using it, so remove the remnants in common code.
> 
> It is likely that further cleanups are possible in the page table
> code but those are not obvious from the config options.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/linux/hugetlb.h | 5 +----
>  include/linux/mm.h      | 1 -
>  include/linux/pgtable.h | 9 ---------
>  3 files changed, 1 insertion(+), 14 deletions(-)

With this and arm HIGHPTE patches applied there are still a few leftovers:

$ git grep  HIGHPTE
arch/arm/configs/vt8500_v6_v7_defconfig:CONFIG_HIGHPTE=y
mm/memory.c:     * Dumping the PTE would be nice, but it's tricky with CONFIG_HIGHPTE,
mm/pgtable-generic.c: * kmapped if necessary (when CONFIG_HIGHPTE), and locked against concurrent
mm/userfaultfd.c:        * index ordering when CONFIG_HIGHPTE is enabled. We mapped dst_pte

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

