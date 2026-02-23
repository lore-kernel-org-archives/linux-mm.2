Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED6D8EF5862
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 04:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75AF6B0088; Sun, 22 Feb 2026 23:29:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C232F6B0089; Sun, 22 Feb 2026 23:29:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04F86B008A; Sun, 22 Feb 2026 23:29:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3286B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:29:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E372C1A0743
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:29:07 +0000 (UTC)
X-FDA: 84474441534.05.DCCE71D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 27C2DC000A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:29:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EGbJhp6R;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771820946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHLh3cKXZKjxYpTI2A5f4Usbzkmd+cL0G7dSp1H+f/4=;
	b=VHvlufHTmXzZ9uSsQWzlLiS6jA3qN/ttvpyfLF6/cPn/L8b/gIhsaVNZ8Yborw0JZfSbo8
	/Gd9+Y+nXdUPofBp9Q+AIPUIQhY/cYHGQoQI7BMWDciTc3bW0BNioAwJhP3AFFcS2nfIne
	0WfqzKknEVMyhsV75H5oUrfHpqHHti8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EGbJhp6R;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771820946; a=rsa-sha256;
	cv=none;
	b=zKThhdHE7hRRgoGwHj3Y4AJUtJW11IAfe1Z7jZCHCc7cJN+LBrmwsfK3Mp72XzRY3DBR2E
	XAuO0FhdYn6d3Rz9cR1j34TFsnMrbSmFSYZadWKFpuxTxnEY78FtDl+Uacpert4tJepREI
	LL5du5LC2eKNjQQ8pGZnKFMZayGhd1g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZHLh3cKXZKjxYpTI2A5f4Usbzkmd+cL0G7dSp1H+f/4=; b=EGbJhp6RfZrjSCE2rvuy7WsEoF
	Vned+yo1lQzDtP/c65f5E63hpbQmW6y7ucwgA36tqcLB4ihf5O1KbaWOvkp2IapQ30+AHXOFJWjXB
	/RWGxNJjNkWwtJ2vl+0DzbR9bVX7lJX6j6a8nOhuWxbaagFLoHIZzmBvLxcDmeGhZ79DT3yuiIuoU
	RNWPH+fe4mULAm0Y7nJRODD7d45hZJKcUrkZcuC7gBNSAFo6dq/qtqDzakWfbPlqe2ane9otf5tBQ
	Ldl35tPIftkoei5Z3t519AT4iV+zg/Awk4rFsN6hLBbWwOB9jXkwPiv7EEbVbPCilvKeUUBH9RNd1
	qxBZyxog==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuNYo-0000000Drlf-3eoa;
	Mon, 23 Feb 2026 04:28:42 +0000
Date: Mon, 23 Feb 2026 04:28:42 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org, linux-block@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jason Xing <kernelxing@tencent.com>,
	Yushan Zhou <katrinzhou@tencent.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Eric Sandeen <sandeen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>, Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Gao Xiang <xiang@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>
Subject: Re: [PATCH v1 00/11] Zero page->private when freeing pages
Message-ID: <aZvXevheBMQ6LuUu@casper.infradead.org>
References: <20260223032641.1859381-1-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223032641.1859381-1-ziy@nvidia.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27C2DC000A
X-Stat-Signature: k1ocodji788tx13yt4frht5ujxfphece
X-Rspam-User: 
X-HE-Tag: 1771820944-166383
X-HE-Meta: U2FsdGVkX1+jdc/LumUlt6ON2GWkWyesFugvRLak+Zfbh0ozi5qwr67TnGUAdjQUse4uSaDmkw68R5z2lRJvaHLti6jHvcklB9/jTXrsNu/UUUunkrp+qwBLhkJbL+XLLdudWaITorRMR1iLmLmLcpec5e3SQx+ZRroHDkfJTitpMYaG8LSdMiYFb85xfmTKT6lVQpVybXEmIC7X+YsdFCza3G5oiEv4/kirQTNscN0v3vqosZHU/XZReHA3hAtKUdH5CUzyQHaiCuc3HFt2b3WSSBIxwVgeKzOTOdm9bvc8lx04XdTSwqKJhC8hdp/9hP83FsXCTE0arU/oLcy3o4Hjr5nGTvwKP66uqhJSNWMJtlvsxnugtqRpnN5LvL/uxMu37XJf5alGkL1tFWdoNnSFLTaHYoUpzC4nO+MsiDm0XUJ+CixJh2P8m/9awdtSbwFiPm0o2zky5ozwFLhlIcPGo28f4tfyr+W3cu1YludJlb6NrHvijTZWcqzy/Z+DC1gECvB/DuRe5llcWf0csugSionY0lcNXMNh0q/nzNqLDwa1nXPIIljN/AaE7lu6kaOotQrHjSsquWIZ86nYJJLOnMlwPT7JybRbx54udOC6nxqB9nOaPQLyC6sgOCjgyhH0rC4opW/r/F4xs/SSQrMtXe1gTLl5bz8rUNk+HRHHdbBkafP86R0QhVuVZo4SzGRHMD6LSGp4LT3mDgVn4FJgQpVH8y5mGJJSrkQoy8hYTm136cuwVTHgLU5tIxY3w95c8ip503BbmsQj1xtYl5+3BQLFfHzSy6qPymZDry3QzwMt4SzMB3V0EJoPM8TtAavzApVI/D9DFhzKaoEL015J4dygMVnjVFL9kk8itblGECV25ndwM+MnpSozljrWZ0XpsU2CwtTM0i7BoR0zWDXGntFdTaeQgCSiFD4N2Uv195xkm58kioVUjpqjwovE1jTq8K4eZXjotM9WKin
 WmwkjwJ6
 XB2CmW+r1uSTltIf0zsyudR6ub7Vx9bAgAm8l+MqlgDl5zaQdTSWqQSTHf9gtyHm9NiLD7RHGkP4iabGkP1I0wvF/mJaqbqOQ7RwQyl0gdaD2HCMl5BpWWhfGeHCOsWQP1c4gSeFKs1LJMaTltbni2rSimkgiTFY6OeK3m1aHeKwunpAEI/OD8LcYydLj4pxQCeGbSkJQkat8+WoFQjFIUxBYIGMxjcMuVi+bBuRhb5AZtVtZsdQ1C43iZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 22, 2026 at 10:26:30PM -0500, Zi Yan wrote:
> Based on a recent discussion with David Hildenbrand on page->private
> is not zero when a page is freed[1], this patchset is trying to fix all
> users do not zero ->private when freeing a page and add checks to make
> sure all freed pages have ->private set to zero. For compound pages,
> both head page and tail pages need to have ->private set to zero.

Sorry, I didn't notice this conversation.  It seems entirely unnecessary
to me to zero out page->private before freeing.

I'm a bit confused that ac1ea219590c was needed too; I thought we
cleared page->private in the allocation path, and I don't see why
it needs to be cleared in the freeing path.  split_page() should be
clearing page->private.

Can we discuss this at the THP Cabal meeting on Wednesday?  I don't
think that introducing this new rule that page->private must be cleared
by the users is a good idea.

