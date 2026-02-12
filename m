Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCC56EDF02F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 04:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 190376B0005; Wed, 11 Feb 2026 23:57:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 114786B0089; Wed, 11 Feb 2026 23:57:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0203B6B008A; Wed, 11 Feb 2026 23:57:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2A856B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:57:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0340140605
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:57:43 +0000 (UTC)
X-FDA: 84434596806.12.77C7EF0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5C84DC0009
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:57:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YLXtIAKW;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770872262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73x8A3e+nUA8dP4EIU9NuG3xJ/7SYBmWQb6yKbWLCLs=;
	b=dmqYkHB6JBTsbyzMM9lQXTkQNRM2ZzyV3AqmXsyao1GOhw9foFpA630uF6YaYAlYZV2fCC
	50stHGC8xKgL6qJVFkYTXyiLf7cKdsXbkL5Tp83hy7gMJdOBRxZKjSWzPqnt5/Jd/MEbQy
	Wgai0/58qEE4mpGIOdCf5nXHP9lApvg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YLXtIAKW;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770872262; a=rsa-sha256;
	cv=none;
	b=NUuOGmFOTlSFkXXDv6Z9GChmStoFTKi33qtE47iFzDYIHyMzsyNfLmj9lQNhRR6/ZvTumv
	rf1im7siFVJsjNco8UyABMjCQQ/8nvr+URBtEHIlTqWlUCI6J80pv+0+sr8gYtD2xouEiq
	Z44nYDbPQ7ja0V+OdzHKbz/+yI1DHGQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=73x8A3e+nUA8dP4EIU9NuG3xJ/7SYBmWQb6yKbWLCLs=; b=YLXtIAKWoipQ8ssG4Buz8qOtpe
	p1dBoPyU31nZEE1Z3V3xU1qyy4F9OzrXqrm1OC0/5c6EB8wOCiKxl1fryLwUcI0aWlYEtwVZvgHui
	+g1wcvC36Np4CsS6BYtv6AhhIGdczGV1KIlOIrL6fU0aDCEkvhI/YYdMJZuJvepAvyStxrZEd4Ia0
	td7SEcZf3TKehB0Mye+RYZEFfNPegFBF6jfFL1fOVjnEN/3b7MyRNNpDGZaAbQI5QKmpVRQrU8tzi
	OjlB55YOejkYgSJXxIKViv0Fc+jp7E0dgsOgKGRZW/aSwPtaf6Qpnrvt2hae62wnRxAsCDAqGWEpX
	wKWNub0g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqOle-0000000Dgb7-1KSD;
	Thu, 12 Feb 2026 04:57:30 +0000
Date: Thu, 12 Feb 2026 04:57:30 +0000
From: Matthew Wilcox <willy@infradead.org>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
	david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
	mhocko@suse.com, rppt@kernel.org, muchun.song@linux.dev,
	zhengqi.arch@bytedance.com, rakie.kim@sk.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
	virtualization@lists.linux.dev, vbabka@suse.cz, weixugc@google.com,
	xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com,
	yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
Subject: Re: [PATCH 0/2] improve per-node allocation and reclaim visibility
Message-ID: <aY1dusLPzP2AHP6f@casper.infradead.org>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212045109.255391-1-inwardvessel@gmail.com>
X-Stat-Signature: 8mrx9mdecquon7x8h3za4cu3fapfqzhr
X-Rspamd-Queue-Id: 5C84DC0009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770872261-493181
X-HE-Meta: U2FsdGVkX19q1LS0H73jqQ6Q4JpZ3GCCEV8zp1YK/zQ8jBXycWp9uf3aZE8ystq7eMay+bZQ4xb7o35Lqxi4S0ycDz88UarCnXlBLJS4VjfdZQ5G+lTt5TK2hROegZi5Qe2OVknOUpRG1/lKPnNdT7UIEcnfYz/TeRQzQLTKhJfDgYza2U9R6cQOagHbf68bus9MoiGlHdcJ8vU3BPez6hpw60OVQ5XzlDm5k4BeNZRbX/W+GPywgQNxlyr5EzuiyeWnIVY26n2BZ/tbnD+q1t7+KDHGYr2mGEvQx4syjcDWG5x4JDum2oznbNt4OJnQnKWXLhUQSK5IKnEoXCyuFvPxupGU2QqRRss0VV1Fjn1pXHTYZn7GpmiAbP3SEHSfXOdRqqSPIyQapkNsKOxBs3AlNtRwkz3rG5//evIi5wQGOWxrkQZRlAoPjAytB7BVxxwSYrqZm+qoTG3BJ/b5JvtAzgrzL1vEvKR8SEfPt9kMR5jAcJ8eW0F7OdqmeUjwcowfghsIWpcQMqx+tjsk8C2f80KxH0erPgT7aQnm681dWcwgf8yQWmmwZ/h359FRXnlU2WKjImnPEW0LFMeDSR1WoULPNZcefXs7vGYJkeA0oSmJsZSzeazfmZZ+NFeYp2hpZeFrkm60gbWH7LjbzJ0+QqiBHscZyZx2OP5G7KPeDJxCTrFrTFR3/UIeMS1YQi8N6nMA1QYi4mwAIP9rKGZdswotLQ21LJcIWYAmpXhduKqVENpukc8Q9wqNgmi1hyYweThNLAqfyonZll768eYHVuPjFJGH0WFXq6lWeGj6AsZt0TdiAax2AyR7Lx0jivbDKiCjA7xX/x/WoC4nKV7HF+qxSZpSseFUjchASElEPPSWhua23pC1mslslZ7bDUV+Hetz0FEh2+4cNLch/JbHwJo9ITfnoEdMuZUU0Fb9RLN4mBtV4yvcZD7epR8epoTmChuTxKPVy8yuIsr
 TrpBW9hJ
 RKMIVef97dJrZsfY+fMIBpX71YN/O3WjsQml0d9qtMEf+0Og5sMphnOxAHPBCjDFMV1LjkmySofBlyTKhrmEKvd6GMZ6MJOq19bivZWYoi7EMQCeGb9QiL+/3LAWClKc6edAy+FsZgFmmtHxFsqIM1akey+rvjzDPXtyCEhdurLL9uYs/QMhGmgC4VENnXgcJWC29PGSCeTly8nbOSQawjCSTg4JG1pI+YXHHjPjoIbC1Q5LO2ELKinncbzhUrVewdXjNaHegqsPv/es6UMHj8z7X3nm4IV1ytOjG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 08:51:07PM -0800, JP Kobryn wrote:
> We sometimes find ourselves in situations where reclaim kicks in, yet there

who is we?  you haven't indicated any affiliation in your tags.

