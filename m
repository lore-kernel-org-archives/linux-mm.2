Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E0FCA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FE4E8E0018; Mon,  8 Sep 2025 05:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5708E0001; Mon,  8 Sep 2025 05:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB858E0018; Mon,  8 Sep 2025 05:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0DBF88E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:35:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AED70140A37
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:35:01 +0000 (UTC)
X-FDA: 83865574002.01.E5628EA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7E8B080002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:34:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oCtuKkM6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yBOVeWDj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZgmwtYny;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dIYLb4so;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757324099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ATHhD+TQdlzaHBjKd+J9L+O0Silgvpqcmp5Kq+vZDKA=;
	b=WecqVmiPq/W9yh52H1QEbt7HDWeFZyisOLk86lovvlLpqVYqJCIn2Vt8j9k9jtBbYzM6Li
	slJwgLJtN9xiGJX94ZRCeHjjp/EFKEEFL5wRqcEfRRtfuMjbSu4uOaT394PYNXROUi5IkZ
	O1ysTI8BBqfA+ureaXo2sVnECNMnBiA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oCtuKkM6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yBOVeWDj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZgmwtYny;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dIYLb4so;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757324099; a=rsa-sha256;
	cv=none;
	b=PaJq5UGkS4M8vWJUEdyXxDkC5jc3heVL7Bnay68+MwiJVItcVihZwcUF2xVbko/kE+fPs5
	IzA4oz85p2w0+OSrnkx1YMROBvVbJhsdnrRrwTtu5mzkidhcI/Dox+E8m6Pzp2MYApkB9N
	/1oYC0m2JgdHg+n4r0pEYhNu/07VY3g=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DB57920E64;
	Mon,  8 Sep 2025 09:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757324098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ATHhD+TQdlzaHBjKd+J9L+O0Silgvpqcmp5Kq+vZDKA=;
	b=oCtuKkM6tas9goJ0bpAZbpgDEU+0crdsWaWaoMNlRsPi1x5uCoDmM3MU3HIv0dQBzLpsvP
	VKDC0D/AJIs/n+800ueykjIWLgSQsLO9JAmOeYQCRbihjRvPQbU8/w7HcEOXsG63ZBbDSb
	eJmB7FyO/O2oGvlewalx/sth33hOTCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757324098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ATHhD+TQdlzaHBjKd+J9L+O0Silgvpqcmp5Kq+vZDKA=;
	b=yBOVeWDj/fWhbS/VC+ZUhRopsX8bLufG8fLtWxsDbAYdJ2gMAIaBdxbz896zioyXut/S/8
	Zi/K/TN+OfDyHaCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757324096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ATHhD+TQdlzaHBjKd+J9L+O0Silgvpqcmp5Kq+vZDKA=;
	b=ZgmwtYnyI2M0KJ+8HmkPSEQEgvJ0d1r2XmLTmyxO1h1XRDpmfnMCjV0zsVSiyXhJIu6PVz
	B7gEwlmxLy4xojs+Gnymq3yKTEUfQKZCKqmgRwGhOiXMamWaNSHcM+0yq+o54HJ8bm8J0k
	x895Bvb/WbiUCFZxThAFZk0cmIjHfEE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757324096;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ATHhD+TQdlzaHBjKd+J9L+O0Silgvpqcmp5Kq+vZDKA=;
	b=dIYLb4so7JVtwpOrmevI3ozaiMlhBZCerxSHmuKhTfN8p3vGWhFtLORbZUx/Hz5C5w0NBQ
	/pS+gwIHa6ZdHGCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3FF9113869;
	Mon,  8 Sep 2025 09:34:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4tzRDECjvmgzawAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 08 Sep 2025 09:34:56 +0000
Date: Mon, 8 Sep 2025 11:34:54 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
	jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 5/9] mm: hugeltb: check NUMA_NO_NODE in
 only_alloc_fresh_hugetlb_folio()
Message-ID: <aL6jPgh-jw-een_P@localhost.localdomain>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-6-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902124820.3081488-6-wangkefeng.wang@huawei.com>
X-Rspamd-Action: no action
X-Stat-Signature: uzjgn8cwath9gwjrge9cyd8anw35d5yq
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E8B080002
X-Rspamd-Server: rspam01
X-HE-Tag: 1757324099-809769
X-HE-Meta: U2FsdGVkX1+8wLq1re6GarKnt6kZeSzgaZWsjPt0I8a3EAjF9wRwIhe4QS2ciKOxTnx9Ez53eZ2ruLCTeFYQMjZpY01DOVI9pdww72t3Lt/SFYonwhm/d8CWdNKQh9RHrzHeUDDYkieZq5bDholpxGUmWlziP5eHWmcigEwm5ToMzHXYOvgOelg/Ejyp65t8ajh3xzYHPzgIOeYqx9nwQHceY010nXyPCG2eNFAAI91icN2oFPV4ouVVGUIyXRsaw1pbKX7lN76iKv/Lmn/3DbAVfkJLOdxBxnyRPyHWIQHgszYTzoldJLECY7c9Oqp73J3OX6tHkk02TGWH5eRhaT5TOzQsPRLM7NdwpMUGuhtImO7blN9wPiQz4K5AdKmXCLTwVsv0AzVWkB0rTQ7y6PVx1H6s+G4kSAzElcpnVTbKfp5qEcIskeNZ2PQkhEPMO9FHDGRpQaPbondTRBwlvQFc9Gisyr6tEojtUDzcli6R+it+i2/fU/maThXxksQAt3f1lc+pKUXUHqNdx9HdEflgxqiG2Tg7xusFg/WM12cMjLER7JwVqb9uWSxNOQ1FMqS2JuIFst/e/Twymoy9EpKbajayHa7boebVAeTUHbnq/vFju8GtBZ9YllhFgM6tj4RsLon3AcAHEl65ncpxzdea5/FoyM1xFfG4eemjMA7AOcMEvMSAt9069anH8KRTPzyYZTSDi0NuyaSsd8mNo1+2GsWEEh95yGrBJOF1II3J0G75GEMqB04GnEPxYJhysWhjVsBJr01CQgRgvLaXFTqgZbozKvpZ1sGiz19QuuUKOpx+KDUlRVDY5zTh44GlyKEB+beF/9U6jZKXRr/d1SEdUAXSSnLcj0vWTEnZpU7GmxjXEyWWRJNnJ8KZHvmzVHuoCiKpE+H3l8+OnF16ckmdYWZgnF9EUd9hYlH9jHDvlFOYSIybzzvjolpPhiktYhD+lDkGp8+V4P2FNwX
 40U0r1lE
 /+BodOxxzMW67H3oJ5p+MlOJ3xewX05izeRPxHTGOFFhGWyRDdJqWsc8TaECx/uX7+6/18LXmSxBiAC8oGrH9+Rm5fFGar2mD7iX6h6ZXIqs5ZU8myda1aWCETnaQ3sWjpEcOqi8uA1ZfWnsQMVuSxeUg0i5CRDqWNE4oWld77z4SGKxQicjVIKpm+/nJJtoFpogWV99eaFhZdiUflkKpqe/aQbklC321wPJ+gqDXj8rxKut/18KsllrEaJVtDhVT0b8AVShHWRr2skkusODQHd8j3klVonFXWDiKSCqi3TotsKdN6l3imNzG0m6AK7JUpqnUaWRaIjaMnsXOBbC5OupkqNTShjFep2lzqGQkiiHpiuk7agLUA145tFebupYMYsCb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:48:16PM +0800, Kefeng Wang wrote:
> Move the NUMA_NO_NODE check out of buddy and gigantic folio allocation
> to cleanup code a bit, also this will avoid NUMA_NO_NODE passed as 'nid'
> to node_isset() in alloc_buddy_hugetlb_folio().
> 
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

