Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 430DFE8B37E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 23:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670566B0005; Tue,  3 Feb 2026 18:37:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61D316B0088; Tue,  3 Feb 2026 18:37:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553BB6B0089; Tue,  3 Feb 2026 18:37:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 42F9D6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:37:43 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE2A416064B
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 23:37:42 +0000 (UTC)
X-FDA: 84404759964.19.353C1F9
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf08.hostedemail.com (Postfix) with ESMTP id DBE6D160005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 23:37:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G4EN4N0Q;
	spf=pass (imf08.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770161861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAriT1IFXsdmsUE/eZugcF1/82Lk+o0xC3QsHdbeLj4=;
	b=gottNP1kAl2D3jM1JrFB7lVSmOnURKIPo/bY40/XCo6soFBylc6mMY3wA2RfvYBsmL8BHt
	5vmUy4OyIuut6vacDf1OVyg1G5P9b8ev3lq5KNmFmHjhibhVQD242vNPtybIc2jCWJtSGZ
	DIMTRAJEZhF84lJvYJtyoBOW5y5yhgU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G4EN4N0Q;
	spf=pass (imf08.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770161861; a=rsa-sha256;
	cv=none;
	b=gFf/VVXzI8SK8eb99DLdeuOv2Ab8pzQ+mX/2Q2qzMHb8NYeAPuKphjCiOFRW244nhqYsBr
	jPitmeT/8QUrXiGl5NZvKHV4rvYD0i9WRmc+3Z6xxAVb1Ltwpdy/tGI1AVCEFKZT16MVzH
	XQ4J3EyXDULF3YqR0Qa9SY5JWwnhZOg=
Date: Tue, 3 Feb 2026 23:37:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770161858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JAriT1IFXsdmsUE/eZugcF1/82Lk+o0xC3QsHdbeLj4=;
	b=G4EN4N0QEri3pU6Jw+EVDxHytFcy5lyuhVmTosJyXCNmf2kXMLvYYvR3U735jF6nYIvWqX
	gvxCyEJ4n4rSTUSyL1XD8qGC/J+I/bIaGmKrW/gHXIlhZyN2tLHPQw/eR1OxzTnqdPMe6D
	mEJTbktF7lkwGbdCZhKVwO0nzaOZDVg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] zsmalloc: introduce SG-list based object read API
Message-ID: <n6n2q73tcujoz64it7p7bjjydsptsd6fyu2wwrlajl23uit3su@mvsfy7ibggni>
References: <20260113034645.2729998-1-senozhatsky@chromium.org>
 <wb2shm35vigisxnokcp3pw3yzu32kezo3ox2v3xu2u5lnxo45n@ktccxxzg2vsc>
 <CAKEwX=MRz7dL5=cP=4QN6uTgUJLh-xCt_zpfxytqZkYdycUN5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKEwX=MRz7dL5=cP=4QN6uTgUJLh-xCt_zpfxytqZkYdycUN5w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DBE6D160005
X-Stat-Signature: eys54c8h8k3e8wbkh39w8ek6ttf99ypm
X-Rspam-User: 
X-HE-Tag: 1770161860-706
X-HE-Meta: U2FsdGVkX18T11wOStnlb9xbWoYZGYpRt9PM2BJ5Vg99drkwY/9rhgzUDRFf7f8ud0fPsc0qHKj5hqNc9AeNUBCXFry3rfFfJc3K+stZDADKpQSJr8ipqfZitGHpwrckgT7JFuj860GtZ0xw4uORJu8zU/bh/rDrNI7LqHrww0ovSfzYkAHTZ5Kklefwgn6SrrYaFZhXYuIMnLHGeCDr/5IJYcFUMDCPqSkL9NSszJzKf0qfBEvnPuuWT9RAKx8Sczh6Zsrr5jZkQr+qK2G54zQyKTuOuVHgiJtGSpsUNwrWBvnRe7LCm4b55aSL0FHTDVdpFqwCdRhkX2Yggs2m4AFc3KBTwk2ET36Uwth8v41vhNBW3FxglQE5Xsg9p6XYZTsyPTUzusZhHfM9dff4JvSHrRBWU9Uo/EV8p2UDFri61qbrBAwzjNAWZPj3osMltK6QJKa3Nc+HFHX3RMgoNeZrUPToVdLUHrvrqdpKZIGoSpSsJ9dVK+pzu6YDbj8IbMSs1IqCnnwhV2P77VuMbycYa1luKHwigtGcYg6OGpRsr92wiQwQANlqli1aT82jK7JpcZq2dfJ3Hd8o5OMN4Gh4hzZR5K8FoJhm1stKdDHTu0ra5sBe/2qB7AVvlKmL/yy7cQWEqKV0rsr3Ig+1hICjUOXe8PgVqfMqfunZwShn3DgD3yw0vqTL8CGiX71vlxR0labtrlIb3HR8hdhp8WvjKsArxP7YBDJdoD5xfBnHvxmbS6cg2Tve2bsRXpicaF+YZ1C0XKMdPxv74u34qHc3LVideyF/p6l5we5vMNUpy5RAV6SqMSgXneBhlb99Boa/I9eoQM6zko6sHG+F4RPl00mZVJRn7HFf0uexttr1PhlL6rCsIcG08wk//FRMZqBHI10vnU4ChtiM+80NKk3YLyOuIZBfBy1cygO8vw9ipieevw5S/AbwbdtRk+J7u5/46YkCcrefvcsA0C0
 FQneB/UZ
 A2sJxg1s0IvZfP+3W8BNNLYJqB/xCTnpGGO2ycYPf+sfc7fsrd95tyC/qZc0yweStD0o4237wg8fdNflNtBokDx71HrpvR7ZS3OLpMAsg4oM7KIb9cQgcyGUQ3uDkUV7kTnJpCPQ65oZzEo4XN997HIOItzRZbYmJOpkgcW038zPRR3T+J/OHBkZwc8UPhdNgCnviZOQhmEVd92Kl++JAy7X6Pt4vLfCTERmA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 03:14:06PM -0800, Nhat Pham wrote:
[..]
> >         zswap_decompress_fail++;
> >         pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %u->%d)\n",
> >                                                 swp_type(entry->swpentry),
> >                                                 swp_offset(entry->swpentry),
> > -                                               entry->pool->tfm_name, entry->length, dlen);
> > +                                               entry->pool->tfm_name,
> > +                                               entry->length, dlen);
> 
> Just style change? :)

The line was too long and it didn't look uniform, so I snuck this in :P

> 
> >         return false;
> >  }
> >
> > --
> > 2.52.0.457.g6b5491de43-goog
> >
> 
> Looks like the new zsmalloc sglist-based API has landed in mm-stable.
> 
> With that, the zswap API conversion LGTM.
> 
> Acked-by: Nhat Pham <nphamcs@gmail.com>

Thanks!

