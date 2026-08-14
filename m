Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1F88C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 08:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3866B0653; Fri, 14 Aug 2026 04:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05BFE6B0654; Fri, 14 Aug 2026 04:16:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5EA36B0655; Fri, 14 Aug 2026 04:16:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C00976B0653
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 04:16:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AF641603D2
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:16:11 +0000 (UTC)
X-FDA: 85099167342.01.3141B0C
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf30.hostedemail.com (Postfix) with ESMTP id AA8E080002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:16:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf30.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786695369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wBnpdnWFKbMPDExaAanijJY4JVJrT8GIOKA7W6meRK8=;
	b=nuMkPuBS6cgYV4Ri4BzLKTEqqG0rov4RHPSPJsK4xycI3pnQzp+vQnENxAkwHWe2y4ZZxp
	8kH6rqA9T7FIvSZOglPOB42/xwBh2MpbRlGVvrx4LqryJ2wqgscRQ/uDJHFTOE2NWA2j+k
	dLltN3N6yaCM4W2pqiwWDk6nOZIRJ4c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf30.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786695369;
	b=OhbHtDsTwMI188L6IbK2o+VAThY+fUAwvNNO8QdUrw+u9O2nhW/3N6d8ZxaPMdIsIL6BFT
	Ix4yihx0QEMskiqhicKYt9sMcCul8yW95Zj4DyylpkqrgUHzmEE/yyhBoACpzR7/rs94Zg
	0qbSZ9FmorvRC9nGFNDjE6zOPrFqY9c=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 63B2B68B05; Fri, 14 Aug 2026 10:16:06 +0200 (CEST)
Date: Fri, 14 Aug 2026 10:16:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: yu kuai <yukuai@fygo.io>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Tao Cui <cui.tao@linux.dev>, Jan Kara <jack@suse.cz>,
	Ming Lei <ming.lei@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/4] blk-cgroup: store blkcg in bio before
 blkcg_mutex conversion
Message-ID: <20260814081606.GB13546@lst.de>
References: <20260811064744.1139446-1-yukuai@kernel.org> <20260814064537.GA9355@lst.de> <d1d47b32-b746-42d1-a391-5e37d4e373fb@fygo.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1d47b32-b746-42d1-a391-5e37d4e373fb@fygo.io>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: 3txybmua8yuog9umdcz67xkaukod6pby
X-Rspamd-Queue-Id: AA8E080002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786695369-462602
X-HE-Meta: U2FsdGVkX1+IzgGb7BiAWtIqhxTug25Li1M1rNQKVvcV2KNPzkDuIbpMD1DwfTVVDmP73KR6boKF8nU4XpXAjtJ9xOKnTqyitcM12b4j6+gVLRh0zxBaYQaXfAESMJRjBZq/zowOUNh7V0MVmxpaGGk/CciSwYvFQzzyvFpDAdPEVJYbCGYDKsiCIhkgnb2YdgJMkxfo9TZtHjFG9efjp224OU+mYHxacvDbwJZ38alrMcKG4x/D9NQVhfcGXxWeRpmwVVBT8l3fG4wj0Vu/0A2ow7IvUYfrf16B18CO96M0bjCi4XilI4u0okdyLyzYsr0JJNAfSj6q3uUf/teNDH/+nNI+yQCE6Sit1LaXfS8jQxMjn15zMTNJIeEnGfL/JwVbpRXPWIPZ0oMJ+Ky4hwMsNuRkkTkzR+o/8DOnKFPugDapALSM9E8atwngIy0ATsQrlX/QImpkqmz54PEOJkpSLY6X13RWwJYcLUf6CGGUWKd6TDe/uE8NIcTQeFeyHTiBEwN3AC+E1/dwHf9ZC6lT6Iz/8RDxSG/zNU2W2LBUuddWYPN5cUlHje7UQwiE/QkJYOkmrcn15G7vDLng8/mz/YK57Uvnuay5Ym4ric9YTh/wshDI+uLTajr+MDFjjgzhpZXt+A+8TarJBV4mJ3cCJ+TrEMDVRcoHh00vG3Y5CUY/nIgmMCQr7GBD17JBQCrxg/VWzy1b3x0Ofl1CnzFC/neqs8AB6g0+AuCkj8DA3UOlxGvzgjZIx5oMTesBYxWho+juORkcXmaXgdwbClZohAyyYZZa0htorl8XSLsmYmkLyD6U7kWxTLndpOpxgkxDjI3wLEDc5TT5M1VA/dXHWOvCpYOvIl5wDRdUyiJ+CwAmuzotmF4Bx1+Dwp6rQAnEWq5sWPMsvlE6IyQyDMeZLdt/hqX4hym1WSiBBRC+h9igX/BwJIfL9/jM8WWfF78SsFflpkJpqPUVp+U
 vTBd7/Zs
 pCsnire2QyAAvihF5DyNLafRqtC+FO8ezDhkDx05IDQtErYmILQqH/xajIxiCix8LQvehc+cv4tYCj5hoDcf/0Qvw5+m/p9dnyAZN2hTWq6naE+1/IrHLmCh+E1liV+ZyNY7BN9u0d+XWo+Yv118JiSDoy5Qx1bTW4pbuPbZgN+c6HRYtECTCrmR+3l7z6MRFi1stdue7RDVDslm2quMdSKgGjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 03:53:44PM +0800, yu kuai wrote:
> I'll rebase to the latest for-7.3/block branch in the next version.

Thanks.  For anything complicated a link to the git branch can also
be helpful.


