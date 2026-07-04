Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69F65C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 00:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F57D6B00B7; Fri,  3 Jul 2026 20:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A79D6B00B8; Fri,  3 Jul 2026 20:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BC826B00B9; Fri,  3 Jul 2026 20:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F131C6B00B7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:57:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6CCA7A037D
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:57:05 +0000 (UTC)
X-FDA: 84949280010.22.788C8F4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 595AB40007
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:57:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="SYk/KA7F";
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783126623;
	b=I/zUMUOZ6vxL44Lk+WILCwv+UEP3U7i/1wzHLefUvoMpoO+tNoxbptXxZynWmO6vmisL9g
	JPf2fIa3buMkcN7dxOlQlONSV1JlpeyDzZQKUQV+IDZKZzvu82B0LrxIdNRUDF5pzzypuk
	n9QHLoWnxzCTnfp5+5YaCi6RhqSG630=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="SYk/KA7F";
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783126623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1EN6rIeWL899rhI3FjLhGXZyIEwiV09wTr+KM4FDTM=;
	b=zxLNt98dw0rtM0vCB0PSNPrwr/eY771Kwg0PeqDU8euzQ7gpuhIWW1SQEYJZhooX5b/Kbi
	707jPAEj/0c6rZ4PGxj0CbK3rqKag3PJQ/lSEgca7xY8kyvqlwg3XaKKwFYeYZUGK4KY/y
	wYEfjNHAPTQIojge/oYxWhtn1cJ/yOk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C1EN6rIeWL899rhI3FjLhGXZyIEwiV09wTr+KM4FDTM=; b=SYk/KA7FP2Njc/3Os3mIlmBBrQ
	1OPq+arUCKlVVRVccWIL+WJEXCjmq0Q6n7VKu2KePL3pmbUrmwD64SGtIlek7q4gVkqy8pd5ADts5
	A7AeTdtK+imV0kXiQZepZPH9jOvXqprXb6mWAECqjK81XGx+InJubX6UQluBb7A2zfWkdt02u81hG
	1UKpo6MRmgWCqmHoenzMBq1In+k0xYR9XLb2/ZhTXYmBYepSxthyxCkzwtxNit7Oma5UHqURansxO
	aU6Q+iFWdT1JkjbW9fN7LEGhJu3j03o5eDDdGdJTArlb6WVj7tETonMARJ5UEl67JqCdkUYR36eCJ
	V2QzSZ7w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wfogl-0000000B6IQ-0SfH;
	Sat, 04 Jul 2026 00:56:59 +0000
Date: Sat, 4 Jul 2026 01:56:58 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, gfs2 <gfs2@lists.linux.dev>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org
Subject: Re: iomap_writepages WARN_ON_ONCE(PF_MEMALLOC)
Message-ID: <akhaWrUHXcubQQab@casper.infradead.org>
References: <CAHc6FU4tz8-HmEf2_XKT0NT8N=rv5OMcY79PxTACkXAVLOAUpg@mail.gmail.com>
 <akZEjH2Hf8-RR8yQ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZEjH2Hf8-RR8yQ@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 595AB40007
X-Stat-Signature: bdwcsfja1hztcdkzeeywt1kuiuukokof
X-HE-Tag: 1783126623-130817
X-HE-Meta: U2FsdGVkX18RwnLtT7flf23erAB2qZ7ew8V2GvX+KKxntCgobWb4JwcbT7FsPT8vfuO/orzLOSRkTrTW01i0zDLmrbSzC2pFAq8XW6+q40tai7b6w5ZgWoszHFAPkyFWl31LPUv1ofglr6KgnYUno+svMNt49JlmugQIPqJ2YgyTum+knJVNs4SHtcrOsmemI7qyBkRHQ8t3mq3h3HyBQJ8KweU4/1k9yCPo1etVoPQu4SBW2Z0WwlXGqB1isOSpf2hcYK0sTUwWqri/MDZJMDRAkfql873RWX84f8UcxMkHmXA3m+AtHbm8pSSQA5eXN96RfqtxZZ4YFt21RNed+Th/Oq8QXQIGLpXMdik2sfgd/r6GUrvM21QOdNas08SHivjsDsBeSNzuaEadu9bCyuTdm2CBrPa7A4FzwcdOL90iaF7a5114NC9lwDOi8xjvEGZfHM8DXH+gb+4zYKDP/I1oHgIMEANhByhk27EeNQfGcTpVf5LFjE7cXnfROI9iH+w/ra4AeXjmWQN+GM1TQhsfvf8bWwse9ZsgiqDDpBt0mdyRioC1OaYqgw2pIt7lXVrHKN55dRr4EhF7XDNWE4m/OWq1eUtEy/rTPGgOc02NN5M5olWCcMEk2hFgFfLdBMNl+AYPRl1kpJwUIFJ7aRnrivl/AAsUueHFseGjspeXcDTzmlqXtN4Vz9fxTuOjEvP0gI+PfYHvwWFo3bonY4kPQz9x09z51uorbbA9bjSJqdBLgsxYTAv7wNWVco4jWqNb5tgemPD/+X3YMp5xsnKUoBgwmze5J3xV3sGem4ibRY0N/p3Svg06HPa6SeRsR2bNBTij2+x2z7NY/oYapK5lRBlpQs6b4yID4HJyQUIpV2+AxLbVuIFVpUNITNT6llFWXLG1eUS9anomvsB3C5pBoXBt8EpcfnX1e5W4L5pv1WPWwI5BO19SpciqyjSO8op9AWClxBVbT28pbuA
 OAj2eU39
 HQwbht/2cogErJhJkr8s/OpF8hiBv3VGGsuhi175hlGZapa2jUJ1BvYj+7cmHsQngbI5+EcQ6AeZMaLN04j47wfl37+35f1siHHcQhwgDbV+oDGcoikFk7PXBvWxy6PO8YkdOL/KgqsfqksO8j+LKk/S+aaCemRPYOIrSzNENbOxc7e1ZLKtwiipMrBH86Wm0KOmnopqD1YDcZWZwh4FbWafUkfyy1yOQ6/TC+8xoiU+sA3DWG0AdVo/juLYDBM85B/EdD2jePHezAummE6/oOsvoCAB1Xu+hDh2YSQOsBEy6XEeU/PxadHwWhIyjc6oyV9ZnnjPrP1uqHCD/TaGEa+aE7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 03:59:24AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 01, 2026 at 10:51:06PM +0200, Andreas Gruenbacher wrote:
> > Do you have any suggestions?
> > 
> > The above is on RHEL-8, but a similar code path exists in cgroups v2,
> > triggered via:
> > 
> >   echo reclaim_amount > /sys/fs/cgroup/.../memory.reclaim
> > 
> > That code path starts with:
> > 
> > memory_reclaim -> user_proactive_reclaim -> try_to_free_mem_cgroup_pages ->
> 
> PF_MEMALLOC is a sign of direct reclaim.  cgroup code is doing really
> weird things when it is set and it is doing writeback.

If we're going to blame the cgroup people for doing weird things, let's
cc them so they stand a chance of seeing this ... original at:

https://lore.kernel.org/linux-fsdevel/CAHc6FU4tz8-HmEf2_XKT0NT8N=rv5OMcY79PxTACkXAVLOAUpg@mail.gmail.com/

