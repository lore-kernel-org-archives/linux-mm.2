Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B6B7CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 16:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871436B00B9; Tue, 26 May 2026 12:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8482D6B00BB; Tue, 26 May 2026 12:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75EDF6B00BD; Tue, 26 May 2026 12:23:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 666836B00B9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:23:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09E8C8EB41
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:23:23 +0000 (UTC)
X-FDA: 84810091086.02.EC057A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B98354001C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:23:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KatpinNM;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779812600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBUPm4P6Bl8HVm5j5M0bks7G/t81X8NaLRQmYcZmSlQ=;
	b=KfLWMaP836E6/7wRxR2mHQm9dM7ueqloZHMU+SugFVM84191rGiK43+hOoTxG2z0ZxSf2l
	+5TntU8GacBEXF5g9aM9XV+lW///tKh5+Pt0sgkQ6GHsY79VGr8KNBiGaQ056uHrofBs5q
	s1g7hvBC4bqNK4SKtEKKrpEm63CqE7c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KatpinNM;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779812600; a=rsa-sha256;
	cv=none;
	b=EpIuYyeE/pkFdWH3B/x/1f27/c5sMKnVvWj30mdZs4m9hPmcIeQqkPWSUymgnA/TAnCfSC
	r9mLuF1AfPS77lifdhdE40+OO/mzAUoukYeswkOvq4c5TS+nnIxpEGj3bil3l8/kL0sdzL
	/iSHMwY5roFTebBHMN7bgcBL2mLsm5Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C3F8F431F8;
	Tue, 26 May 2026 16:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138661F000E9;
	Tue, 26 May 2026 16:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779812599;
	bh=KBUPm4P6Bl8HVm5j5M0bks7G/t81X8NaLRQmYcZmSlQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KatpinNMFdRooR68kKMyhU6m4qPyr3dc39wmPeaRDNfl53kS0EzEWcYm+ieSahUZa
	 ouhlKiZEeggGGaeJa/O02sxmrnlzgpwgYXNXuyu/moAhLSqcV55Xf1AjHNstXCizim
	 HDnk7Sn1zo7R3Fl/pGTnCqfe5eX/v4iFbgTs8AShVunEZJWuVLqQPPRcaPfba2MqCF
	 yYfL3fsCwbNDQcu1W9BT7JoaDjzTTz8P/cVSQaTDEZFWaLKMk57CmZwOfXOepsBHP9
	 60X1w8Z78CDyYqEUGKr0FzfPvCMfVr8+7uozzgkqEU2wgF3MCy0gQ3tknW3AqT3oSU
	 /YtG5tHqGwDaw==
Date: Tue, 26 May 2026 17:23:17 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: linmiaohe@huawei.com, william.roche@oracle.com, harry.yoo@oracle.com, 
	jane.chu@oracle.com, nao.horiguchi@gmail.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, willy@infradead.org, akpm@linux-foundation.org, 
	osalvador@suse.de, rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, sidhartha.kumar@oracle.com, 
	ziy@nvidia.com, david@redhat.com, dave.hansen@linux.intel.com, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] memfd-based Userspace MFR Policy for HugeTLB
Message-ID: <ahXI0cK9fsOByvKy@lucifer>
References: <20260203192352.2674184-1-jiaqiyan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203192352.2674184-1-jiaqiyan@google.com>
X-Stat-Signature: r7uf7u6prhjyusnynhnsuwrcoe79forc
X-Rspamd-Queue-Id: B98354001C
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779812600-202834
X-HE-Meta: U2FsdGVkX1/5d5VHKAhq+zLJQtGeQvFnn6Jx7TIQZ9HVyPbR+fYBlob5FhTo0GoLvN6qevD3lbR3UEjYhc6BuAkGsPDSRk44UCkdDsed9e0cAqw11WTIVRY7Qb0jp2hkP2Gzi8F23zOQdwAu4sc62r8WYGouQf5O6Zh5C1W/5efVX9J464bQ7BRd5uWfDVnsTsjaMUL7tpoWC3IReQK3cP4B7xLzFikyGbOaBmoMN+ve0ESjPqs9nr4ifxTU77UsGitwoCzE4iL+vzA6Wq2Ync6pe7lj/bj4Y9T2MCpg3STjdcjj7Hxxmb7FRleg3un6IfznZnX0BVfL3PDo3Hyf3C+cuYuRX3anmyZaadEOetHtKdbHAE2CkXAnuTQiwEI3t0+FaoGBRGHoQ2f8SuAtTNcA6jSEnfP0Cr4+G95KWdXgJ9MaXgdVPDtSKlVRPmcXsa4mNg1QQcTVGSAjIDw1coSNkOPbzgMvi5MX2NytXIGJO1270tEi0By4X3N6fBfc6BU5FeO43X4oADQIETpz694jznDAMEdxHBWP0kHpx7Uf8Uj7QwhnPofv3UbTQ7XkoOre1Cu2ZxD8lzd+lQxqqGgl0+hZIhYkKsqnOr8A5fspANb59hvPd0jLWUHAPsBT2I3xqSdRqIr/qYZmnrs53mkOiI5rvbyJkD+sTmQZnyigxXWydffoYKtM6uEkmU4LpAUAIhmk9C/WHGjbLUYi9Z9U7IqWvRZK/5KA4ewT9HroeOOWrXgMx0qr69IIbz2bbObdHBa+KW/mF1HlgVT7SdYtS087Vg9sNwuH2VVyqx5zn8SRU7UNhFcOYFI7TLF+0FxYeXETTgXw/skOWRISz8iL2nRxymV5ynGiVTajijo3//8Sl4hJVcTb1r37avDwfZ5odQmmC7iIOFNqdsiJ6hAICyNODxsSH9YNFsf5ZnSzMtR5GsB+Fxn2D7HJcY6uoGBXHNPuzB4/wvdIdRh
 cqDW28sc
 oaQtp3B5dYqrTjBTXL2GIqIONMrua3YHgCYT+cxo+QNZSJBxu6UHhi6JnOgGJkBJJIYhz33RBfsS09kzlcKXnEuLIhUFJZIzizgo7ftz6+vMIiE0YhluD3XzYI7LZX9z9lxOhDRbN/7lxbUkYRETFRi4+mrLCwDtG3V+1YdGTy3nSIZtyf5+Q3Z3lkJQIUVU15cPZzzTSI6pcjgqV5CRQQQ+g7CTwOJ3Qr60H5Izr3KLeFX83zXTMhqE8NinbHtaRoWjem9Miccp8lauU/LyyM17s55hULKab/m6n/gRiOUB0x0b4uRFpZsIuwiam3LV5pF6eArXv6EBx8Hc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jiaqi,

It seems this series got stalled on review, wondered if you planned to
respin it at all?

Thanks, Lorenzo

