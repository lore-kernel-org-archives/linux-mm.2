Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3643CCCFA00
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 16:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2213D8E006C; Fri, 31 Oct 2025 12:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1818E0068; Fri, 31 Oct 2025 12:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8818E006C; Fri, 31 Oct 2025 12:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF5F38E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 12:46:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FFE5B85F2
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:46:27 +0000 (UTC)
X-FDA: 84058987614.28.107FA39
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9136210000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:46:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xucfbgUe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761929186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Unpag1GTuLRnEJ4lWMfWIaIW9bG3sjlwA2Vnh4DAL0=;
	b=fL5GmrBS4Z9XAFBjcB0dNmeqf3oqYPFWpjT/taevtj9N+7XXl0p7sNFRtvyfnwA89CSk7X
	Dax6sf9sZj3dl/uj+onLCNn6IO551bvMP9bCaquw2TYoUwdwIiOFSzU2kF37rokBt9kUXg
	EL7heEbqtJM3sTWOtVfa9ZHOPTA47ZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761929186; a=rsa-sha256;
	cv=none;
	b=Wq4325Nws6eqEbxtV00si4SPINZNUUPXOB+FKNNWd+Nk5Zuw+Xk7WbM4mF3A3QnB/KoeIy
	ZFmorQ7e3h0s6sek47ZyA8n4HFy2QEpRXDl+Xx1mOpFN65Bk+HII9LuRwQJHj6SSnY1gCi
	FYPsJ2SEjvAEHkQx4/6uTPOgPY0xHzU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xucfbgUe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Fri, 31 Oct 2025 09:46:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761929183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Unpag1GTuLRnEJ4lWMfWIaIW9bG3sjlwA2Vnh4DAL0=;
	b=xucfbgUeGOAy8tA/Xe1aVXo/FOYPYd+FaIsLKKsEgfGG7J+u3nQTUA7pONLjB6k2G61HwG
	FAkgqw8RFvBsaIAQ1Kl2oWe80AEMi//wu4NNS2aOIoIPWmRpwfOLW27R0HiaV5zzkfE+Tt
	V5b99uSsr/dyjMM7lyCckLdt1Kh2IHs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, 
	libaokun@huaweicloud.com, linux-mm@kvack.org, akpm@linux-foundation.org, surenb@google.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, jack@suse.cz, 
	yi.zhang@huawei.com, yangerkun@huawei.com, libaokun1@huawei.com
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Message-ID: <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
References: <20251031061350.2052509-1-libaokun@huaweicloud.com>
 <aQRkTKTm08lSJZZi@tiehlicka>
 <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
 <aQTHMI3t5mNXp0M1@casper.infradead.org>
 <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
 <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
 <aQTb0NdyN3tU50ss@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQTb0NdyN3tU50ss@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: ado8af3ispbbokmk3cphwuf49n6qy1u9
X-Rspam-User: 
X-Rspamd-Queue-Id: 9136210000C
X-HE-Tag: 1761929185-429123
X-HE-Meta: U2FsdGVkX1/5Ku9ugBw2c3+PYtT1cT5k761Ys9BsW3w8GJ4wbynm4+Vg5FnIEiLMpHHGZlVTksaQGTRlbeqaclieoI7rT9tI6MHNQspavYDUHfztszSsnWgNhhW9KfMUHBtQ/f1y+/0mN2LzLhaP9jM+m0f8KJmZQ0iUlBIR1c1KCWBX0Hhjv2rTD3YhYwPfCqdbaEGd3mlubvNxOVXn2bJJui5ip3XEZomT4IEgdD4bYumhcrFBmVRUM8eoUJ7+dFjNTKngE2BdhsZS8cVMxBWLM+wj0YytFGOVRA35cNI29VkEoEofhuRMmhXLLNQUkg/EpV8uharJvsjjR6rcSyCNZar3piZyKedPHDOjQMl29BVSq9x++146kWrVqaTscMBV9/BmzcLUFenQsDWiXxyjEESJUMBNFOTdteG6ga2ATifg3PlET/YjHXYHWAKpVSJ4WzZyUBXtNENOsmdlPQCbSeye8V8oaF9i2MzqdzzvzZXapiXFWjkIt8LMTliPCiBDjxtL5pQUo/9XinvxvmrYqRqavrCRBg4yUA09M60+JJmnibOUVn01QsQEj6Ppq64di6pa+k8Vpb6zvCuq/IoNHGeIzA3/mMvyxASKCp+F9qcm/aGmUbAf1qzRttjWpIf7wLC5Lm/98w+IEh28AozNhXqqZbiOmr0oFisIYJw2JTaiQYYLWb9FG4rOoyavdEPRxHJl1Ka7FjgKWO8PxGKH1vw0a8SzEHKc0QBJiXae8apaDscms7sKaDW2Kf2Tx+wKuSF20ZaHwy1RC5z1M1KH6Z5NoMR4yTLwgdd8Codkzq0n6Vf+7l2cjI0pT7XB9QylUPu2yiKwEyLuesPJDafyhd+jwa/sKzsHCkKODbTHkID4kYVlSxHoQJEJA5zBJ1246Kry+Wug6zvQV5w1eYKyzlg4hfccdn+sOvLKxkv30WvlEgx2qpEZ6e/FULElI51LehktSnR9fG5h5Z7
 Oal7889H
 1oxCpC4wFOVx4enpGON/3blkLfBTtH3o2Sjxin2+eihCA56kvtJQgOoZTa+9FwW2oCdfxNx3JtiKWrE2EnVuxbf4AdietCwxAkL5RaII8G3bXBj8lI7WFuxiFHHRLxe+KE1hj+pkWSFIX0xTu/VA+uyoeWjsEYI7yMFz23vw1NHwns1/nOB0XUHwykidgFrByDuZckIkwUvs+xnPbqhmUNT4Qg62b+YGVTI0BRK+XEnDAGYJfQP6VX75gnho8CDD6LhHJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 03:54:56PM +0000, Matthew Wilcox wrote:
> On Fri, Oct 31, 2025 at 08:52:49AM -0700, Shakeel Butt wrote:
> > After reading the background link, it seems like the actual allocation
> > will be NOFS + NOFAIL + higher_order. With NOFS, current reclaim can not
> > really reclaim any file memory (page cache). However I wonder with the
> > writeback gone from reclaim path, should we allow reclaiming clean file
> > pages even for NOFS context (need some digging).
> 
> I thought that was true yesterday morning, but I read the code and it isn't.
> 
> Look at where may_enter_fs() is called from.  It's only for folios which
> are either marked dirty or writeback.
> 

Indeed you are right.

Now for the interface to allow NOFS+NOFAIL+higher_order, I think a new
(FS specific) gfp is fine but will require some maintenance to avoid
abuse.

I am more interested in how to codify "you can reclaim one I've already
allocated". I have a different scenario where network stack keep
stealing memory from direct reclaimers and keeping them in reclaim for
long time. If we have some mechanism to allow reclaimers to get the
memory they have reclaimed (at least for some cases), I think that can
be used in both cases.

