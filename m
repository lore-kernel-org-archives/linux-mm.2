Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41C6BC531F9
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 11:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083D76B0088; Tue, 28 Jul 2026 07:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034596B008A; Tue, 28 Jul 2026 07:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D626B008C; Tue, 28 Jul 2026 07:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C37A36B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:17:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A9FC80364
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:17:49 +0000 (UTC)
X-FDA: 85037935458.18.D011196
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B038C1A0002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:17:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEaWLwMn;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785237467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3Jzxz8cTBKJ4oQjMR0dsChUMmbd1kyxivRCL+os77E=;
	b=YTleiyYFqkC66GFo7kAXRX2zbbOFS5wKywocG5avJECMnRGaYclm61JmyBswz//2B1fol/
	mRWIQFqDlYdd0BjpxPsCyJozUzJC15Rik4rIXw9FCDt7sAOwT1nJ66/znS604uDoMvVCQk
	Dar03DA1vgJ5XgbXuSQhrGrXxNNszS8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEaWLwMn;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785237467;
	b=weY3gdHtmnKLFBeg14CARaMLLr8Gx+YVBz/JXc1F0Xf70BkFEk4VUHirjQHiz6Uaax5R7i
	rNaxo0WtgmTmBEdgrK0//HRNIVK85BK7yeZwRGTAuaK3ABMSOkMm9tWpNwXala6v91yLUK
	5bIA4mXo7JzsQcntoBVD0waMe9abe5I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BF8160A9B;
	Tue, 28 Jul 2026 11:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7F41F000E9;
	Tue, 28 Jul 2026 11:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785237466;
	bh=c3Jzxz8cTBKJ4oQjMR0dsChUMmbd1kyxivRCL+os77E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LEaWLwMn/SH7yWGkv9FDUMXJ/oT4Y5DSiJs8nA9k/fLDZCybRc6HHMqUW1swC5ZXd
	 IW0gxe/iL0DDhZ3B4O5GdzwYhCpRIOI18lPEfvKohj2qUfF80pgk9roQGRs9Qv/u1r
	 MrCKe+2KEGdamnHre/AfpqksnW/y/MRXJrlyiRUG/+ncbSIYEdEp7cRnneFZBeaf8q
	 dHJtjrj8AVq1N6chHHvmcc8F13IHbG+6A1Zhhkm2yQP3W2c7ueSgMdxttY7+61pjVr
	 YWpnU0Uj93DTKaTuNL4C44n5cTExFOdgEGdjVsrFut6WdY3hZuK0Jjd32XASGU4v9I
	 qcMWJCTyB4+HQ==
Date: Tue, 28 Jul 2026 12:17:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: pratmal@google.com
Cc: akpm@linux-foundation.org, vbabka@kernel.org, david@kernel.org, 
	sj@kernel.org, corbet@lwn.net, skhan@linuxfoundation.org, 
	anshuman.khandual@arm.com, gthelen@google.com, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, liam@infradead.org, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_reporting: Add page_reporting_delay_ms module
 parameter
Message-ID: <amiPTPKfTOEpgetH@lucifer>
References: <20260727230545.262579-1-pratmal@google.com>
 <amiN82J8p5z9l_Rm@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amiN82J8p5z9l_Rm@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B038C1A0002
X-Stat-Signature: cy9esiihy6sx6qqq4xu5zng1nb9p5fom
X-HE-Tag: 1785237467-912863
X-HE-Meta: U2FsdGVkX1/vi0yIPFia6hL1yZMw2/dcIQLdNAawYqYejLGNpdM7PIN/JUXWFYvjJM6hknj6nMXS6TFeTBQQRogZlclFGGRdE1sGpmdShgKAkl7oe1Ktq6Up7pPdPMpIhY4wystM+r+jrSED/iVjPiCSk5NGj5XITtuA3+XaKme1J+slEP4t2dM7dG27IXsIFAsoTZS3CUo9hoQSdKF1PoPo+FjJTAsa1hP7IojhWVPC0vzSrbUkt3W3mPGH6yZ4EkO4GbHuehMsakhrxK/v3D6m0AhAMg8mZkJf7LvmsAaiGfq4vC0gdF4aoQo5xD2W8zZXBTqSrO67dObz3USMKBi672Z3V/lKRKPdq6lK4Fkn0luhhEmJg0iIXiOFTK3sEBkyPo1f8mHznYxDNaktocRv4Mh4SBDbR17TZQc9oEXgw/PC8WwZc0g7MlsE02zOhumoj9Ntlu0sVjW/AAkifC6TCDV7BlBnY4aAP4hELw8v1BZl++kM73MLOfEZgDMVZA6wWZcKjI9FyjrbExOssm2c8XNm4kinPGOYmWTxiDpr/bSxfqdRGLlEdD8EjszPA+4QuwR18AZYVXSrYdfiS0QyC9r3QYwN46hTe21wupYLRoFTSH/MXAyAfB330TU2QSX3ZW0nC0rXbOpfelu23/76y0X4Vv1CMLMZ43CPrAQuFknyAhMuNm2E4qyVGRM++7HZhkUb0vG3zQqOagN/SkINIyEi3AIhgUCxaHTef1kVBkjuFfeoi2a1bingJuN+NobC+06a085oLaO5FiULGk/yQOHlCSCgYNv1G+9u9skn+QZmBiYi3PLXAQ4j3+EVYxnx5qisSAGgiV86rLmoEvdI5ueCPW+MSH3y3wjyKMrDdBujvk08xeEV/qQbNHjEBO2TI37X4FsaQcuzQSBHte/POD5DW6xTLuxWcEsZ22dT9XYpoJcTMrWtxTC8aunoqVrAHYMKa98kx7QyboA
 ZtkKonUW
 dS/tgJu5Vc+wgqsgDmKVT2UG+1F7U9B3mCEU+MGYUuSQYXnplMbYF+FB++B7zebggfTfWSfsOVfjmfY37v79Cpv71DtletNZQ99yVaXb56aYgRbrQ8DqGo/YDkxbzGN8VsyEYlfcJ6hT7+kDxgjOYrl9oyZq6qfSb+Y6qIZ4Nc1DCSmS7XCsNZ3dEICStYhbh0uIhvRgRN2AwSjI1Grm3QmJuYnVFKxHaEEiSErHtLTYWR6qDfBWc/Xq60xuN+U3JRLbzUQ/ZlmvhmKlncawven7REKBBvjX3OnB9paNJCnu1E2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Also this patch should require a tag from Vlasta as it comes under the page
allocator.)

Cheers, Lorenzo

