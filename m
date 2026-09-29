Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C6E2CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 19:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A82B6B0088; Tue, 29 Sep 2026 15:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759136B008A; Tue, 29 Sep 2026 15:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670546B008C; Tue, 29 Sep 2026 15:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F07DF6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:32:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C73AEC05A5
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:32:05 +0000 (UTC)
X-FDA: 85267795410.24.A82B5B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 455931C0005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:32:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUzCpH01;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790710324;
	b=4AjbJ1fkBLvAe8U7TTX7ctxpAZPyfQb/Diwh9/c6f8m4FYWviRy+TLPkmoj9mUsKmOI+SI
	R799ha2ac6tRgw0rIfzPreiZPfSIWdi/YPODGz2dBc7L0N9ZRHWCuYosIIxm4Fhi6ZTDku
	mEyfDm0qEELKqZgaRImsdhBVGaLdZCw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUzCpH01;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790710324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DE3R3xTLFa/aCwxhY4Huq+rp+2dkgvN41qawVfDVKA=;
	b=YlDPFX3elqQcwf0gXu1sQRB/Jh6Y9FeUBC0EKKPq3dkCyhSqsa/j5zyG/6ZsVt/uBAjb2J
	ZlkBOfKw8BtxFrwqt3EiXgznuiDW9j+H1ltDWSpr/aDR+iGEQsbeC2+xX/8+r88Q6vvcfD
	oN45rRdq1EX+WZdTi1Tby6koni+Y9sY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13EED6022B;
	Tue, 29 Sep 2026 19:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946BB1F000FF;
	Tue, 29 Sep 2026 19:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790710322;
	bh=2DE3R3xTLFa/aCwxhY4Huq+rp+2dkgvN41qawVfDVKA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hUzCpH016dhhQfIFFOTkj7wynEjxIF34pcXtGjdLgd4GJnOdCRLBDyoF5/x4CKqno
	 10hzxkun2w8/0qFO+Sp6M/IJEW/2ElTF83zCVNPCrXUvSO38NBmLHb1C2yxdL1GB8K
	 yOnk04sA9ZPsB2RfYMTxnPO+zVfaiGzFTR1yEqdVuq0jyRFAuFhOR2C6H77HfBkFPw
	 shG2tUdjtjbTh3y8g1WoW9Oy2aAwPZgfdQwLy2pFbondG//6GsDDt9j3bKDf4EZvHm
	 4mztCNap4h9n8XOpc+BoCq89/JsX/+T1ccrzLNOrMqr+96l+UWzZ8cS4t9kOkOCEaB
	 c6WiC+swFUkDw==
Date: Tue, 29 Sep 2026 09:32:01 -1000
Message-ID: <ffbfecce332d7f3a59f6533b6daa7f0c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>,
 Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Jens Axboe <axboe@kernel.dk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Xin Yin <yinxin.x@bytedance.com>,
 linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 ian@honeycomb.io
Subject: Re: [PATCH v3 0/2] writeback: let foreign flushes reach dying cgwbs
In-Reply-To: <20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io>
References: <20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspamd-Server: rspam06
X-Stat-Signature: wt94if9ts5b161eu4nqas7f9dzjc5yoq
X-Rspam-User: 
X-Rspamd-Queue-Id: 455931C0005
X-HE-Tag: 1790710324-728305
X-HE-Meta: U2FsdGVkX19t49No9x4+CWTAH6pU2I7Z59p2jaeMoFAmQ53ayC5DimbHgVNa2dsfaPBTrfmX/klFD0oEstqMUaV5rBO/tHF4XgUL6H59xI8dGMRdCz3N8tO/ISwM0+q1oizl9GuzT03ahl7NJw3KD/qH9yiAoIo9uyXIkl8mww8zernPKru0zc2F+gDpdtX06fABNqGHhnNYO0b+r6Yp+D9f8BhTcDnbgwotT5vJYHM5u8Jfyp2Vej0+FcTWs0Mq2Qzw2lb8VOgoIO9nu1WeaTvxMcp/aCSFj7Nd+sO+WMYI9USkDZhH/KuGBwxgfCBXDYycyFCLl6rO6eLx1wqcaDvCSdc9n7O9ovoevRqs26q7FL0Ikz+57L0UxaEFTQPElw4s7v9pJpBQjxzCbyR31AnYOSttlf9Wt4/uU2e/nOeIrpl3DQCz2APGlu59ku2zpkZpRawY7g/RBuZ+aRbgG5h99dKgBSXAj5BJLEff4bFkr6qmyp8D0l7u1dR2qyUZ/eJs9+lic9b033jX5unK7igWbxWiLOMTLOflg+lx8/nEAQM0CaVpgCuZADToVuz7ZOd33zpGWdtb871sdM1OLIVReuR7Fy31cRVDY7774x5Rw4TbLerwa37nxDm7XvzSHQjj/kUDzFrmggGvEp0uANjpE5uodGoYfmgGxlUTRgjI3kUCaKbsMHSGOohkbMHB7VdIUTcJBnu2WiK1rihCztyYji28kOkbxgKL3yRfZMBkeFByInvbPE3t9w5FuvHtgMTGgmEPsGPdkHeWJB0koSlSy5UzmESZUVqwgHbyOeolGOiYkQkJACUSXCQ62Whg0qv92HQA9VmgkWIcsNH9+6cX6EIHuYKKazYyq6GCxcKLsf6wWikJdV4MNRni6Vk0UVPxCY4mlQb0YDUmj9WulDuqhlnPeWon74Y8ij2SBkeb7gONXAJbS34TL5Hn52fR7nXAy2kEZIz9kcc9YGK
 HQFr8R97
 VkgKbeg2YJB5fEU7PCbgJYoUAwjfRv8meqixxsx+mW76Grvn9LcnjdqjWYgbOTGK3zhIlre8OMXMT7LQei2kus3lQ5iDRg7c8oqLjfYdvDYOHH3PW/J32Kh1m3MaA0eiSAYH62m7W9KxtNr5aJSx2ypem6oc0RNHwP7RhwHZF/Xo8ot3VeJsx95DSSFOikchxuF2IDsofuQs/9twhBh6EO+wjnjW8siDx8abvFOLeA3+4mIDiO3mC+AM6oqGkrBjhvG5x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Liz.

On Tue, Sep 29, 2026 at 01:40:49AM +0000, Liz Fong-Jones wrote:
> 1.5s and 19.5s with it), because writing back the old wb's backlog took
> up to 27s and the sibling's foreign flushes reached the new wb in the
> meantime. Should foreign flushes also reach a replaced wb until it is
> clean, or is that not worth it for this case?

I don't think the old wb needs to stay reachable if the new wb takes
over its inodes. Instead of kicking writeback, can the takeover queue a
work item which switches all of the old wb's inodes to the new wb, like
cleanup_offline_cgwb() does for b_attached and b_dirty_time? The switch
carries the dirty and writeback page counts, so foreign flushes reach
the inodes through the new wb and nothing needs to be flushed right
away.

That would also mean switching inodes on b_dirty, b_io and b_more_io
while the flusher may be working on the old wb, which I'm not sure is
safe. Jan, would that be okay?

Thanks.

--
tejun

