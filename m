Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE325CA600E
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 09:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0CEE6B0092; Thu,  8 Oct 2026 05:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBCCD6B0093; Thu,  8 Oct 2026 05:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB826B0095; Thu,  8 Oct 2026 05:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A26226B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 05:39:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 050A0404DD
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:39:51 +0000 (UTC)
X-FDA: 85298962224.16.B289817
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 72D8740002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:39:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=gqi0G9mb;
	spf=none (imf27.hostedemail.com: domain of BATV+5ec9ac32e36676a6fdc4+8446+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5ec9ac32e36676a6fdc4+8446+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791452389;
	b=QllJVHp3KBS0wRX6pexFSs3MiWs9DCytApP9Xaa7bCCZyanF2b/M5ksQbTubWR657MBRkj
	c9VnAiwWs048iTreyF2Ap0QC8lqV9zlp2wbz+hOM9qK2/YmHtQ9XphRH3YkUEmkJGuqoPL
	2h0hwocb9qpMkQXbwTwHvg6YIvPACPE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=gqi0G9mb;
	spf=none (imf27.hostedemail.com: domain of BATV+5ec9ac32e36676a6fdc4+8446+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5ec9ac32e36676a6fdc4+8446+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791452389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXGH9Z2sKf9gd5EF+DR8x54cjdZ36U6rmco1+5f+14s=;
	b=MeHX6ESeKMi2+CSMpF9rukU1FXzHHGoaM6r58hcUqfll8wdO27TrFQv7xz1PLXbFG1jrbD
	7Zu1Rjbb88gmNj+56yQBp5HMwQ/hVZEutK68EoV7AP/2IabWWn9jTe0Fc9NGm/VtEChbh0
	V1gegFz40lk8NMwCXleZt0CmaPMYABc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SXGH9Z2sKf9gd5EF+DR8x54cjdZ36U6rmco1+5f+14s=; b=gqi0G9mbFX9h3tQxOi8M1kjNU+
	lXE+9FcOKN08OhEE3n9BpzNpbCiWaTYNI4VDB6Xa7Pd5QDMSLRaIePjWCpZIRkoK7FScuRyGNDLZW
	jL2s+38BefoFKe7l0mToh7TnkHe4zjvd+qvgCoC+Yp66yzEYe3LHes8ARn9dc5EMs1mwydCdWez49
	qUqsIPJ0WaOAQnfLga0b+pZAr5/OahGUp9mgO44cN8p1VbqHNAt2QrG+GVxpt/4/er5i17xJd4eQE
	hlrzq/aG/Wq9+Pv/m8y2cfp7SR3HEZPccQ38eGKAFRm+oLfhyJgc6ozF7fv/HD3tpapJLHKqbPlJN
	l3Zq2pgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEkbH-000000041Hy-439N;
	Thu, 08 Oct 2026 09:39:43 +0000
Date: Thu, 8 Oct 2026 02:39:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Julian Sun <sunjunchao@bytedance.com>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, willy@infradead.org, tj@kernel.org,
	akpm@linux-foundation.org, Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <asdk330xyUL8xDyR@infradead.org>
References: <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
 <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
 <asNfNHd-kcsI4B1S@infradead.org>
 <bsb5vk2s3vyqglw6bv6pgpoqqvkho2p5kfnskfwfban5azi2vt@sceqd6t36yai>
 <c4d76912-581f-4174-95a7-d0ecaae79d3d@bytedance.com>
 <dzq3d5yosbsdeml4fdb3rpowxxnjau6edluw4xoewwwbv4hykg@ywkjm3xlbimv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dzq3d5yosbsdeml4fdb3rpowxxnjau6edluw4xoewwwbv4hykg@ywkjm3xlbimv>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 72D8740002
X-Stat-Signature: sjgye7ndpdm9yutstzyqbyaiupw475w5
X-HE-Tag: 1791452388-972934
X-HE-Meta: U2FsdGVkX18b3utDuN3j5tLvPjbj75xTpi9VPqg644+gCFrUTJlN9EFCQMVukO4ecvH4iy8huu8osRXmRKWzY9CTWPukFYxu7B5kKVoYy6BAxxEtdH2pIw+jsCQ+HGskchYFsWNvQHV3ozTtnPYNxMsCaInYWNAfq7nYfuJ1QvG6Wo2gU1WQeGWMzG8WE7+QHh4CwtVopEsutjQYo3Ggo6rkpGKNypIqHL65QNGTIh0IZl+jn8sVQNFEj/l9tgws2TMWgXFZqiLuiaFLF6I3ep24tLMAMox9mPFTiCdB9qXUKN7wj37uG+oNGQkUOw47ZdON1huu3x/RhMYVOOlM0m1B8lt5CTMgVbbzzJk/uED0hMkZYSmeChF0Hndeh7TBFyG/oC+KCqd+hr9AZd3wwwsJ1bgqEhRFBOXEf2g8XbC655ZAiBNpIv27T6yVD7m8fL85QIyQcqQCJAUpgbVnly4X4rIBRJZvg/9pOV8hl2BIDXQMzChzfb6iwcLMtfg7DU8/ANwE8p87pLzV8RaVK0fiHPh+Sjr0ZHILe9XOmkbZ5D8T7V3xTm77V7tGM4s///knRoG+O1yM6h8zTkKKRNPS7P1f8Elp0mJnhxV5SajjrquWqRLzrsYN5HEOTntdpWNGoeQswXIHWo79mBarZQcBBFg/r4ixoUZGamYCne3yCsP8JSw2zqBs7ZpGIUjUet+tKltZg+ji6PLF1QwMi6SGOJrPIkFPVcJgSkIdJ2M2AzU11lx7AdFJXBpNntH5qfYh4V6tvB5I6/+1jievf9becOaYSmjl+mhKAHe6/WMHr32EDCSvEUgaH0GNt0brQdQa/YL0QfnkRGIjLD6u1KbYa1fzG/FgGkYZjvfybE45xblh+Bub/d8MRfrTVHmZGG6r2cVKuHXa1Ov2rWfL8/cX4X505zic4vcFsnfZhnEmZojISiCcS5E9DRjA3+8LUVMty1wmFQA82hevmEx
 rqr+ipWN
 FoQGSPgwNRXATH1F9pM28z7/dKdTo9L/QrgX2AU7oK+bOpLOESPJQYXbvALdp4JrnSmjdSdlk5O9H5bKnivjzNLxXWZ/4AbEKoxHMKl30z3V0FvNOATJyiYsOsq9JVbuOT1Ymt+lceLlousYZTAP4oQyWWQ5u5ihtYJUjoEBrbtiFn/ZKx8hyfeDByjDMXYuFMKziKSMSnb8krYuKac5WU6BiM9vG6knXbPIiWlybcctTzw/lWj+CQqs4Yp6reB3/G7jfuNK6IZ8oHvIoT1Wqxy+fhqB+kUj00h387NXln9Ao3vyZS2yfHvjQnRoDqbME/4SCPgt/OVK6wCoTTiKNFqwL54jvihMO+otGU73cRJGD/5iA7Atscbnu/IDTDgpJ38xnPVlHvHDVaNOLUnF8mI9X5S/iY4bwOAiMHEfiUiHZ8ddDCLccI4Wf9T3r4aDbfdoE3RUjSO2WStFm8mfXQvkZLANrsya2THzBD13DtKhLt5+T705zm3JIYCa935cNyrftwt4L1wXECmOA1DRyN+qrdLVzx4VsA44us7Q4O7pDK8/5FJqjPDbPutkq0X5f5nx2fgFJnbtIpA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 08, 2026 at 10:51:08AM +0200, Jan Kara wrote:
> In principle, the mechanism looks good to me but I'd place it in
> fs_bdev_file_open_by_dev() & fs_bdev_file_release() so that all block
> device based filesystems are handled. ext4 is the most used filesystem that
> has this problem with bdev memcg accounting but in principle exactly the
> same problem happens for other filesystems using buffer heads so I'd prefer
> handling it in the generic code instead of fixing them one-by-one as people
> complain...

Yes, this should be in the common code.


