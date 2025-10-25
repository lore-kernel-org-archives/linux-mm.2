Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D0F8CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 05:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA208E013B; Sat, 25 Oct 2025 01:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5AFD8E0135; Sat, 25 Oct 2025 01:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70A48E013B; Sat, 25 Oct 2025 01:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 965278E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 01:13:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BB495E932
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 05:13:43 +0000 (UTC)
X-FDA: 84035469126.22.FCBC1D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 75E34140002
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 05:13:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IJVI+X5i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761369221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1eDlUcI3d7V/f/mk1Td3hyy7JjQiwCckeKpe0bN5Gb0=;
	b=yZCh8IVHYDPTE9lqrZv3WezVng9LXN1jGZRbA+lV4BImxMdR+rZCj5VSxxlGSjNLdCtq9U
	x8PSBxvkCqXW3GcsHwBBiU25svf/Q+aMRJMl5ladAPPTkTmDEkcooKDrz3d70qh6qfaVeJ
	IQgX0972VKd4LFdgjkq60pAJBhoOnC0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IJVI+X5i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761369221; a=rsa-sha256;
	cv=none;
	b=rLKN34k4UbA4DZH5ij9VZz8Hv3Q6EAd/4uVN/uzMdhpZ8Ccs/MzOXgEiFQoQun4CXsLlaF
	4dApHJsJ3VEmTBcapKz7qj/5nvV3IPNkUp+lRIEybrD6ENyWAOnKy5c45zZVMqDPoXCMqN
	EP7wVN0GxspzaZiM67543zkf8jwcdQc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50A9942BAA;
	Sat, 25 Oct 2025 05:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260A9C4CEF5;
	Sat, 25 Oct 2025 05:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761369220;
	bh=1VhxwTV4sdwWSJRcuCIhvvladHFWeUlpYcqFsLM0igE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IJVI+X5iwFou8KDDuBWOj4DT71xelY8qD/kWKC5M3CoBf+EPX0m8QUdmHPqw3/hkc
	 9Ij+aG+7e0DweAJPtOV34CB887xswLV/zPt7R6LDVQiP2DiMYZ/1WcXI3bQh6XPjvR
	 mGUEHnKrRvInYfik/nLX/Vf/4jod5U55GAQ0hiLtSuS5ln1eDv7ue8DkMjJDtO4X4s
	 UgAdiWCB/nmMozeEYlt1EgWB6Bup12CN8XCy5Vsbz1nn/XIivRcTPLpPTgTU+/Rxq8
	 dOwU4rs70rOwmKL12PT34LWIJEc+MrxGFcZ1gELYvlK7vyda5vO9EJy8Q6ea7W55lH
	 tRaDDhk6bygbw==
Date: Fri, 24 Oct 2025 22:13:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: libaokun@huaweicloud.com, linux-ext4@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, jack@suse.cz,
	linux-kernel@vger.kernel.org, kernel@pankajraghav.com,
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, yi.zhang@huawei.com, yangerkun@huawei.com,
	chengzhihao1@huawei.com, libaokun1@huawei.com
Subject: Re: [PATCH 22/25] fs/buffer: prevent WARN_ON in
 __alloc_pages_slowpath() when BS > PS
Message-ID: <20251025051339.GR6170@frogsfrogsfrogs>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-23-libaokun@huaweicloud.com>
 <aPxV6QnXu-OufSDH@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPxV6QnXu-OufSDH@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 75E34140002
X-Rspamd-Server: rspam03
X-Stat-Signature: ucoxiquz4nkndm3te5xb3gzsa14nk66n
X-HE-Tag: 1761369221-887900
X-HE-Meta: U2FsdGVkX1/vKX9PWCgzrH+I+o3I8rU33Y+i4YB6Fezi0AFeDuIqN2YTg3GUKm2d/PwmL8v0aBbK4K8GVGaJ2Dn5VHDcv9MjkCOiAIwP2TzYXBulX44ZLm7tfHOAAG28ZgreJRPaepCZ6+6nwXYCByrVZ9bb1quIwdrD4owJYyl5EscW68b0DazwYgZV3xzO1AWFOZcKkJ8nB/I2BA1awAYEXNJqWVjFL3dNjcWT7TxmJUQlvb0/UYOD0ZDbc7EEUvt94ugU7ISgfKxU3SM2nY6ywvCpcsFeOiihiqHWaJ1VC6vDnMe1NToINA3Rmgt6aNPtO3RQGjeBUs8dkRf+z2JTtD9eADNG8v4EP62bWuEXbBkuYJppIY3WtkTG6bBEZyLVsUCJK7zXcWLGcsy//UHhQNHKSooOHduQfIWps3BDFDzWw5Miln9riOZLaJfRrh8Gv6TczVHmfyvNAjTqMXlX5p8xCOmV1MfmfAyfbK39g15Smq+a2GCfqipJ0r74PX0dbdnUiZO6DRUUWAIIon82MYT15Smkz97TKmOqom/rgEh32iXXiyhaVESKDsKBMNtLfZGcBI9hUHHL+9YPuf+ovlSQNxOKHrg4A/nVrTPHs18Co4cIF5cFvJMurlH+qsIcMSOFkIYoIl1RUfCdlw2pgKKBTvv8/sGh9feoiiOqoqhDuini0K2BFMMiaL5fJrVBgnya678UmLgmfkGvV4VjufiuZXlOlGRuXnT28tZhnqiJuHcpaS395oR2IDIJaE7k+Y7fs9sv6TpoTGz8FxT3YQyFABOgImzYLZ2DMu2XvxWKX3OlRUkpooCDOJk7DdeUu8/nu9TdsVG+s4rASCS7PmuhzJxAtQ5tqe/DIg6r9zedI/DyR03HkOyT1k1o62ZY5tydlbPjCFbkRtTfDf6xT4gv2f1vHg/wlfZFpYuptMnmzYzE20HqSwrZ8GtOY01i7WZAWO/oZe09X8J
 WmWZxWHe
 sTO2NcmC0t9mkI9CXupIZhPV5rHZaTh91doEHhF7a0NaB6WnCooG/mAbrfS5z4aBXbp6JVzlllJW4JiGCf+zoGxsUAsIpzfZ3uW5aYYrS1rr8tR0KT7tphrpyesVgBBqIibT62p2RpxuhDYRYEdCo3p+xK3IsVTv+yZW55a7hX3yzaXuQdUmY8QQE5QsHT3QSqUUyTg+iLJUrgDHHpcYmZr1U8wBJmstMEMYD9ybos5Pv8WemRN6yQvO1IAUr2GHm3rK9qmrWsQfrr6fTTNi+/sH5aLGsZOhJ14eIVwoChpPRRjEA1eBAr5agS2hTvLW/6wih
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 25, 2025 at 05:45:29AM +0100, Matthew Wilcox wrote:
> On Sat, Oct 25, 2025 at 11:22:18AM +0800, libaokun@huaweicloud.com wrote:
> > +	while (1) {
> > +		folio = __filemap_get_folio(mapping, index, fgp_flags,
> > +					    gfp & ~__GFP_NOFAIL);
> > +		if (!IS_ERR(folio) || !(gfp & __GFP_NOFAIL))
> > +			return folio;
> > +
> > +		if (PTR_ERR(folio) != -ENOMEM && PTR_ERR(folio) != -EAGAIN)
> > +			return folio;
> > +
> > +		memalloc_retry_wait(gfp);
> > +	}
> 
> No, absolutely not.  We're not having open-coded GFP_NOFAIL semantics.
> The right way forward is for ext4 to use iomap, not for buffer heads
> to support large block sizes.

Seconded.

--D

