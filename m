Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AEB2606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PsP6tBH6
Received: by kanga.kvack.org (Postfix)
	id C5BBA6B05B2; Thu, 26 Nov 2026 07:17:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33F06B05B3; Thu, 26 Nov 2026 07:17:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70FB6B05B4; Thu, 26 Nov 2026 07:17:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9777E6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:17:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94AB640406
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:17:42 +0000 (UTC)
X-FDA: 85477171164.03.526E549
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id F3A6120004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:17:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PsP6tBH6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795695461;
	b=B4s92Qw2584CpKa7YNIYZjYR2gdRGQmIiemuRin2WSlxJQYLuvPmHBgz5GILaNg7CyS1DD
	6Sh2kzYfTRYfdgaYm13CBnCXn4PnNCRFTDakSQ0r/Ysr68Mt/LkAFYnBRTCtshL+S/7clq
	ATOgMx8Rcbkfm8A4rXzYJmVE9yrTU2o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795695461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wN00pFpWYZ+wwYrOlZbOLfT6UmtgD8JPARqSG6SJcEk=;
	b=KkZtXx6dXC74+CQog2vtdLYSq0aEKVPd8K0KIDBd7byTUmpvM2PzkzfW1ZZthK/mTvseG8
	VENrBF+XZohRZ4ZvvpaLoHYp68HBv5x1z0f5aNtA9O/H0SL+Cb6m9OBDmR5soe7QPVFOG2
	Hk+7igljsEDCTt8+1a8veNSYTeoDFf8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PsP6tBH6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2083546262;
	Thu, 26 Nov 2026 12:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686C31F000D0;
	Thu, 26 Nov 2026 12:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795695459;
	bh=wN00pFpWYZ+wwYrOlZbOLfT6UmtgD8JPARqSG6SJcEk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PsP6tBH6WtJZo9kBDkDcEo7nK21a3g4G9TlxSzx0CNHO9D/uWT3dqnv97vsZqueAU
	 mAOw9bnIBGt70+0KcN6NWNpZNckqHovgV7cF7F1f0CZMiV+KLeQCIV+8+4Is/98yRQ
	 ITgxwR2Z+rE2Xld+Bl7PQf4flKc6Z9D0sU/ZyiB+dsgE7cvtPDlu2iuR4wANLv0Ch8
	 29QHEtPvksIKOLAM0rvqDROlz5KdwAR9XizUF/W57CgYtrc0tcBBDrLXq1NpkH5rWu
	 Zv4teHyCKusuLxTB+behTb5z6NUBWT/NEaSyyi+zLfOak6qjkHkFqXsJ0UZ/qt09wK
	 Ri/w8g0JSvDvQ==
Date: Thu, 26 Nov 2026 02:17:38 -1000
Message-ID: <f188775aea9580f9ab2b477788503434@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>, Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock against filesystem freeze
In-Reply-To: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Stat-Signature: es4jg98m863tj85uug51nb4jn61zezfg
X-Rspamd-Queue-Id: F3A6120004
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795695460-445203
X-HE-Meta: U2FsdGVkX18ECpn3nnpTrA7TTzraZ3cUiUB0f+iUDoCj1cSW7e7Zt+S6YxeUvGwlwNB0ygZF5Mn5F12iMWIm2NMWmgBvz8ZASoBj5GUCDLJHjr9beOk20QSMZusDe6stlvDTZG4ThxiF5+jnSortNS6m8ZLDswPU/ZDzwd/qSXjyQtge5pSde0UIwM6n1pGgHs40QtYT4h3rASbfVpowar+agmsqz2NyHz4KPP4g3swMHOhNn7ppbctTa2k318fkvzKPV0/7ZSadw9fKrZjEB7wwoKjjCotnqQrK0DKbqARJtNjvQdu9f/WC/3d7Y+IWhlK2blFtT/UHOOdohXUPA7S5vVernhweIi0RMDEy9+zUkE20q4cJG0oQvAWhQH32B1dFIINCMAAQ4/DCA23neBJY2t1/fxxWr1lQ022WM06+WWBGCJmz+xqOsQ3PvGRQH/08QNkiQcNJt+fVy9/+Rx7nbGc8Z4XK+JhjyXLDRgePovMRbFLDY88wA+bh8r9qf6BP65jrjhSpxPBk1UUuPTjG9XBpgNWRz1hemq15/9a5zANkq3pRfVUlgSG0ILY+YsWyaL36OJ/hOIsP0MNB1kqml9UiKicpu11aA8R5D5beL+njLl4N9n6pGQS+Pz+h9Y5mPN7iK6EkWxv7JoWAoes185oPLsdN7cy6F0ASqkGYDX01g5AeS4qjoJfo3fhuOZWYZRs2NZUi3XSJbwBjlj6bMg4CX6mhERsJKWlmd8Osl/dPfAQMnpoXrzZCW6U+ILA2VnmzrQFgdNGUOv1bVXhLjDTOI8aGLIYv4DHYI7Xuaxfco64eS3JodDQWL6hCgd0DPaumt2k8gxBxPNlPlPnMPPSbYxZRk83LXzgwlljLmhcHs10ktCgZcqCnC62n93HFB+ZB6YLayQxSk/ZwPBlrkOVzgIjRrElNdTYy8TxNtBI2JHYSK/kvNsqL+zjwGq8pjplQ/bE9Gs/J/hT
 8k9aYBKL
 sJGxOdVGQZ/oN3wlITQoB7ZYXTZYJITgIL6nI8QLqnuCPXI0gV+AOrwjf+5CxpwxZMd4k7IaUOU/LFqbtwFTJKQri6uOYnDfFQbo3K/UeelYupNHRxFEhm+2Bu4e8P8AFAeDjpAb8Jym5p/lkfzO2lxFRNNYOlFb/v96EM5y35aidpcs918VPV85hCl/50AQeS37pVQLSigWJ0BDVpUxuVWcOzBa2d9BQdk85clyJnHFNHxvvVBetCYpsnUq45xWOl9DhVbK3Esos/vHGiw3LNgKkZoQvljm5gFgvNPOEa1J36/GW1g7gvz45IXIrZpA4JXTpQVjiSiXCwr56Z0p/mW0GlgH0+xhbWD1EFgZE7scVcpdOROHGCkqcPsnSjlyf4pxVPXuI52QNxHMSfPoM4coYSjU5GqHF6w2OP/rtYTey4gvEibbMDATIWF7uLzL41B0F91u9s7GjFeq/ObVwD9lxHLHsCBh3Yo1Vbs5G5hbVPPkjqfZ3pbM2tDrbt9kBgscrdV+6p+7QU0lTVFIuprq5p+JyqGPE5TovENFJw61Q8ebFMT98k1zx+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello, Andrew.

Your follow-up, "mm/vmscan: scope freeze writeback skip to the reclaim
target", applies on top of this patch and tests fine here.

Thanks.

--
tejun

