Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF56F8DFC9
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 21:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EBD16B0088; Thu, 16 Apr 2026 17:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475E36B0089; Thu, 16 Apr 2026 17:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363DC6B008A; Thu, 16 Apr 2026 17:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2275B6B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 17:49:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E4D1E49CF
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:49:48 +0000 (UTC)
X-FDA: 84665761656.29.D697C1F
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id A52801A0003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:49:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z7fUs5gH;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776376186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvn2jbgbxVPa/dgGDSzpzj/SD9CZWwQkugRH34yO08g=;
	b=vrHQLx7nP4MuKa4COIAUK3CmA+27Y2G4Y8kPu159DbI0FWI78ulK9FHj9WT2mtdMHyOZm/
	rZhzz1/VAPVDx9xjKxF2QUpFp/lEaOKtO7epZYc/gaxeXI8w7m5QMp9+ThqxivmEp6i6hE
	KPvedbJy5wTZfmnbVoyR7iUG4wxbDro=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z7fUs5gH;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776376187; a=rsa-sha256;
	cv=none;
	b=tVCWCcV8G9LbVy8qwl4hRlF0cPGDB2rxOeOJUM29HNePru2Gc5FG6XsmRsNTKAgMNteZVc
	WAinErRzRzsUufrG9sRO4/tPnwJA5Jc9FeqnU/H9pnjSbKSLgzyffYdzzcB6nY0LWgos+4
	mP4/aA0/Yck5rIf1R5EIdsU1JWYmqJ4=
Date: Thu, 16 Apr 2026 14:49:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776376182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yvn2jbgbxVPa/dgGDSzpzj/SD9CZWwQkugRH34yO08g=;
	b=Z7fUs5gH89FOSfMI9saN+Mby3wvAW71DOFfNOEucQSEDOB3KjaGIRufT2wxCv5E7n5wy2R
	Ro99vrtZYZ6Ttjw2NV0gdwDViWdAW+Tsqxl9bMC6kglcW/KH/qcWdTbkcMdsOptx9uqltL
	Rek9Tdd4RFbbuxKoXxSK12K0qPK+jsA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matt Fleming <matt@readmodwrite.com>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Minchan Kim <minchan@kernel.org>, kernel-team@cloudflare.com, 
	Matt Fleming <mfleming@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Require LRU reclaim progress before retrying direct
 reclaim
Message-ID: <aeFYrV78Q19c-RnB@linux.dev>
References: <20260410101550.2930139-1-matt@readmodwrite.com>
 <v3j7f476gbj7b5rxigpcorxhaimg5dyhgtovsl5quo7gc33swc@7i4ypekahw5h>
 <aeDuVmN8Q6cpNTuT@matt-Precision-5490>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeDuVmN8Q6cpNTuT@matt-Precision-5490>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fuybb7qxj9chud3f9a3psu983w6ppynn
X-Rspamd-Queue-Id: A52801A0003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776376186-519953
X-HE-Meta: U2FsdGVkX195/1mh3Fh5nzZQdAVdOFYvsBEMhIPPfxya/x9SfNxiX3sm45TURo+VGrrZVvtVeYQ+CIU6HncYeURKB9kEBjQ0OZzXy6z1MlVmnSx5PBMnCc+I3UNqR592EedTE/dQF2G9q9/LEAz4ipV7wyIEBwBuqw7wp/tLwr+VIH8FAmmGrDkJRbAO4grM1zIsY+5SIdlshms0Ae/W6BYZTlOBPVOG8k4jdr4eVld2Mp1ZaHeQZ10PGEeBDPIBWonqKXKqYSCcTOPpv55eDVg85d/Q88zRDNWZm+i5ZGjXXk/hIx7tKEW+qBAdhvzyzHji+mwvHbjDhvCgFruYO9Pxpm8GLZprR5YpDPR7hCK8ssfmyXztStsvsYtX2CH8Z43wAEMXi/i4LIvroN/ACML/7SwbLpvZseNMyFNNe7EgN0Y4dYKrJV7zx8k+gmom3ES6AQXOYgQt2CpBSmrUI0aLubUqBRi8HUeEqqfKjBRRgjrBpJWBDxOPqttMKOo3cIdf/w+60DlB/facTVlP3gdEe4I0H5xGEytNDO2pFYwjc5MV270JdQ5MJRVt8xhnIWpN/tykxt/5A6wSgPOXYJXukAyrxUg+cCkvcOj2qafh9FskhVG/TcTkOkb0wmsg2vxx83RwPJRyzRWAPe3Ry7vBXBA0uLlWvBFEXCb3yr23GFw0Jw7DR0rV2J5Z5pHf0doo2MjzLeIo8vg+xhK30v2fcKmHB5rSiB5dFl4p0N2UFmmF2+tW+zDv/7a6ufnedRVwZDscDhZGfJM06uaSxhIYLS+IXuQF095FwhgczpeQxBGliHd0nO/8y7NNqG/wdwMSbuvOkKVnu/bUbrg1a7p8hdhc5WJQRkqIRDu72yMYhE3Sy+/WnaaL+yhpIPnM+6/A396ZiOAPee/5CGVFlV5yBuVwJe9vh3e7RWQTJI4POenCW/+WY7PdBOMUUaoEAxRaYvGUj0QtVhbbgRh
 niir7mC6
 dmb15r/SFanJIbxkJqyGLxX6WXFBW3KUXsduKg9JrZ2TwFnnrOynKJFHedJP2j3r2/4LYLuAtafeXjlC+PuDn2pTrYmLCWlSulzji6FJ7QwZphynaK8JIP5wbvfIxnVJRDg1K6sIxNokSdrbyGwRMSCWjLijnEjTqfaZwf6V4OQ6lC3LTbecOibBkZWp43oq96i9mpauKrFy1cxMum6RYqWLNJRefkQbqUtla2tATSBZi1yk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 03:51:04PM +0100, Matt Fleming wrote:
> On Wed, Apr 15, 2026 at 03:57:25PM +0100, Pedro Falcato wrote:
[...]
> 
> > My theory (from merely reading the patch, maybe I missed something) is that
> > a pathological case for this is a lot of folios added to the LRU in a row,
> > that are set referenced (or dirty). Say SWAP_CLUSTER_MAX * MAX_RECLAIM_RETRIES
> > - it will simply OOM too early.
>  
> OK yeah I think I see the problem now: this heuristic applies the
> threshold against all reclaimable pages but that falls apart when doing
> SWAP_CLUSTER_MAX chunks of reclaim.

I am not sure I understand the pathological case. Yes SWAP_CLUSTER_MAX is
requested amount of pages to reclaim but the kernel can potentially scan full
memory twice to reclaim that much amount. Though those reclaimed pages can get
stolen but that can still happen today before this patch.


