Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A59ED5E378
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EB686B008A; Tue, 16 Dec 2025 09:34:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898836B008C; Tue, 16 Dec 2025 09:34:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779D06B0092; Tue, 16 Dec 2025 09:34:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 67A6E6B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:34:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1829D1406EE
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:34:25 +0000 (UTC)
X-FDA: 84225579690.17.A6F0BCF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id F1ADAA0010
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:34:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FdTXshY+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765895663; a=rsa-sha256;
	cv=none;
	b=xMY+l12DPtnpqwA5C9JqOWDbArJHYFssIhP7iJ5kppLrKhDLnH0rcvyXSupaFfiDexDTxU
	2z8p+s1+zy6ioSN0K+9GMj63ivPPtPa20BXcEKSZX/ayirGRaj+e26W6uUx1xfSS1rkYRZ
	6WdvhKwWrVEuaVST/IqGxZDIC6TJ0YY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FdTXshY+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765895663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpKutckCqxOfmJOuMItu3GFg7bTCQjnFmnCYbr9QM1Q=;
	b=y29d9wjAmA5N89M6sHxhoAdji/cTwVwx91a6/FYoOQ4W8UswcXb5hWGFEzqeOaNVvoWv+2
	LzBFtKyoRcBB2ZbW7dPYiRCfQ4pWuHVqq4qgey63zRp6dg7b5SBWC9vju/E22dtGvtsfpP
	q1Utww55x2/IhS7e8ycffIZWkqfBZmQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vpKutckCqxOfmJOuMItu3GFg7bTCQjnFmnCYbr9QM1Q=; b=FdTXshY+1tviM3jbfGd9mzVDhu
	JUuLJehi1W4VMESsmCl3NjwcYf7rLL/qGAYLyY4KiNmKc1Hd1mMlqfcVy6YyzN4rX/93qRLXBQ6UK
	dhLW7G42NGH0QJn6Rx82ChkdLAMWBnR1IOicQDQmccMSHYzt19q07rf4zKR6W0mLJJMyDi+vA8miZ
	DLvLnEx3Ix5KugXDJDJNTvwUQzVNivqJpTeAIgVN0I3govrsEybhJdJz4cdS3OfgWskAwwYrerpoS
	XZQqvq5BhplrdwoOe6tpvnpdCUgUAYwvhc4eAdEmsPlicZlvd366Gkw+OJsIRp/1+MZKFMYZZr5CH
	P2Ngcppw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVW81-00000003OwZ-1MoV;
	Tue, 16 Dec 2025 14:34:17 +0000
Date: Tue, 16 Dec 2025 14:34:17 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Daniel Palmer <daniel@0x0f.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3] mm/page_alloc: prevent reporting pcp->batch = 0
Message-ID: <aUFt6Q7TIbFV9v95@casper.infradead.org>
References: <20251216142755.2857688-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216142755.2857688-1-joshua.hahnjy@gmail.com>
X-Rspamd-Queue-Id: F1ADAA0010
X-Rspamd-Server: rspam03
X-Stat-Signature: 1wfxtsbmt8fs88z6gt3snd5idgr4ca8e
X-Rspam-User: 
X-HE-Tag: 1765895662-806635
X-HE-Meta: U2FsdGVkX19x/MPXa+ljZDJrfhpOeM4i8xEOZbb26Fxd3AleMTr56gVMp22a9HOAdC+lBGV5YFLhYvZ6JDWUEUA189eaXg8vrh1XvaywfBtOZ4dL8+cGGnb4fYWYbzWsYmiE4iqu8SXlO3OyPVL3o3Dgn6exZLI2LycqQrieDs1KXe917eNI5Hsef+AXgioo2oUdzHGW8nL0bCwTUhE+5X2H/Fzy7tI652SuLdfh7qHevdEGHX1HC+0qw9oS62TTJQKp1o++2bfXM5YUeJLtQ9jLGdkMTaSFbx6V99CZ96v5VJzS527Jhvg7zKYgVpbScdFWdWHn/5usxOnEHcAddb/C1aHFyiZAMH8d4+FFk8G2fbkMaSoXYclUQm/k3b1JePbFj5q+whQuBZFgXrvkxu7DpAVIh7BBfal+Ne5ns1lanv0af+M066rEB7+YbP80hwgDSmfNp0cwHzlmkNMRcrUiOD53ln76KIy+GfjIvgSCmUk8gkjB65DGEf499GA5RaVZIsHylCzABkI61n2ydimMDRcWkdF538o1tiVz2LNimm36n8WGkKtKWZ0W9v1f5vo9ed7dh/i2gG3OM4W+tV5IaAmdzLooZ8x5Q6hSuZDrIF8Os02cKYc58iokMRwRVNyn4SJjMl2RUx8rI/JKZPydLBqaVrRtwp74wdyiPRqP2QazeEGZH+f+MKVnDzQAgXJFgDfuirEXz3qbJLoC4f0HsseC34V7/Ab3CJFLs7Omafx2YVt3EmFjP9tvG3thqtZt1E2h/Y3reRQholfPZkQ/GaR8S7cRPdiyk5T3HngP4x/ZAXXqNbchJ1GfGUy3GTok4kP/VQkCMV02to+iDcgVOlrLmCXPql6KvAIEt2H7PGgNPQUXe9TzfXuCehAhZ2Bwtggz5Kwn2SidoshHwTYpDg5Qhn1OMpiTEKjb1+nKWQYGwrsE5qCBrkp9ctBCcChePMuQCCbmi6vN2jE
 ynnLC1N/
 W/X2xf7c7deYSajUarQdRxt6ZfTiUwS8cE9MGmb/ZA+AvR1fWi7JMME9FNUveuZlI888naY/v+1ZREJP3XTtCeGmNW6lYr8RMqKvppBs3UHsH4a3w0/oXAE1femsowchEgSwcERdDd6nuG2q//b6gDP7TuJnLALjKfOtogeiU/V6etdJPkbNF/3D6zaoKj0NRtmwUy445h8BH+t4kry50CEwgTTxrOeVdiRrpKmOKux9nwkH56kQQ4whg5rsSTZyN9ltCjxCQf/JB93csLJi8pJmhUY38WaIFZVT6lX3SzWwdi19hJP/T9bYyUoEqLLnekQ+uV4rNHQgCBMfwOG+1JdHl3ktmy7ughPor8W9LZvGXLjBJHhJd7eTkyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 06:27:53AM -0800, Joshua Hahn wrote:
>  	batch = min(zone_managed_pages(zone) >> 12, SZ_256K / PAGE_SIZE);
> -	if (batch < 1)
> +	if (batch <= 1)
>  		batch = 1;
>  

This seems like a no-op to me.  Did you send the right patch?

