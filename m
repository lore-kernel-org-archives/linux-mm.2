Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67DC9D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27B76B002E; Wed,  3 Dec 2025 04:26:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7BE6B0088; Wed,  3 Dec 2025 04:26:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0646B008A; Wed,  3 Dec 2025 04:26:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 974386B002E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:26:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63FEA51870
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:26:07 +0000 (UTC)
X-FDA: 84177628374.28.0742BA2
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83D2CC0005
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:26:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=MmqUKW8w;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764753965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tah9iA7LYO4yjBk7uiNqYdwsN3RihMO5xorllOIAWP4=;
	b=03F2D5THFH3GkRINUeGyQxmApwUIeboGgh45vjNLTEVR/84u1xPbTrrP4RuJB9lcHAP8tR
	lki0xYJRQkcdhp2h2snT9GzoY+RoDZU0l2bkjjq1RCDnQHovz68GTnhbcWwZgn3i4F5S4g
	5NQJ/NSzSoAPISkvDjaHVOTEtDblqo0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=MmqUKW8w;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764753965; a=rsa-sha256;
	cv=none;
	b=p/UMsmQtrb7NjfqVvasVAm0CGX/L85pg9AVhQsXvGvPPH8nyPnp0Ho5S7nQijvXRpW5AjL
	dpkgh+8yYQ2grqggWAd6wDs5xZy/OBLPp0MiaV4QpkCMIkDNTZfUQu5Hbkh+c4Hhlw4tos
	T6rp0XMNa1XrjjY+8wT+5eA4Rgs9vEE=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4eddfb8c7f5so59834581cf.1
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 01:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764753964; x=1765358764; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tah9iA7LYO4yjBk7uiNqYdwsN3RihMO5xorllOIAWP4=;
        b=MmqUKW8wouNi8+lMVYXumdxaJ1phhYDzhntGEEVTpJW4fL6MHd/+y+AvwSgQzoA+5D
         o7itZqOQaJKO99dsryJPqLjKOFK09Pi5xUWooKMHuqSoA2eEay5t9pfWIZrjAGBa6kIg
         BEKkFDU411sWXAQnsWta6RKkY35ltyQhtTHVB83GOyCIfeFUvFTlAHPBCjO/oTU6/sN/
         UHBDCswh2f/n9pBtQ5imhUJSmV9bE8JbnOsS9TbyrVSgGrVSWX/lsXJ1uJIGAw9Y7ds3
         2gGA2Jnsu7EtF/zP67zeKO0hnMeK+wNBzx7cwyX5lYGXjgS3kSsqHYY/nji7BUO4UD65
         Uedg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764753964; x=1765358764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tah9iA7LYO4yjBk7uiNqYdwsN3RihMO5xorllOIAWP4=;
        b=fXzPPgDFzq9vL4LwoGL3Y+j301XAJBJWtUI0QCW91YmGTCSgvIee4268O1UZeQdDLl
         RuhQNSYjFm84KK2W7ZZpjwVrBsfMQkfEXOwFr/CQhOjLlEm/BUfhjA3wh9SXuAadATFc
         3sBByzAaqsLoUj0FCPLyaLPYUH6iBosw+66NNlpsYDLdWTDe2T8/QUEBnQpI0cCBQajq
         2CeNNaxPzULNyK1JNQP5ohNLJri4Dfpff9NdVH0GNZeyjGfRSd4opIZLnacDQoI4HhEA
         Bq+B3AoQhr22ma9+NT4lD/ThXs+UzqlG6ndvf1dpo+40BodHQYoGQxnWPjIeRfjmmAjI
         CxpQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1mMF2FT1aQsSUSlUWH8ydcdehhJftXodEzyMsucDMvB08WSWsGD5tNzz+gy+VUX9xotXfsKJFlg==@kvack.org
X-Gm-Message-State: AOJu0YyU4SrvXxafkMEopFBJQPjeJ7qaRMqOfx8murbKJEVfSMQjwGbF
	eLIT9uQhrg7IJy6YNnlTzqfJ1NGNxfQGBO3bzgR40pnK8JGIt3yS7YRBoilVTnYUYbg=
X-Gm-Gg: ASbGncu2XJPqEEq5nRtQSbt2I28rK5mj23uYfjkgfDFoXpVRgQBw9Zd0p0jhKiPpmLu
	L5EKpRT4Vb4weKuPigV81w9jKW4IB0KtVY7WqWfu3iZjEzdsb2OTMJbBmm4tdOYOz2YTAX3adCX
	Ni0PY8/K6F4dCHK4A27DFoSlh4Hm7u/cmJNFn9EiXBxLHbgaTwqK8ENPIzUYpHqas0RQcGdA2mh
	JKhzVUsKsgHdgBEjjE2kWQos7RaDuvrk9Q0S1foNBHT5+RPG6CDqOckZHuWcKMFR5RSjCJs6X1U
	mVJOjd+HtonHVizs2hxCI7cX7AiBOPyu0NQtjPt9FtFNWCH+mPfdgtUht8Ie7a84XJhNfxUu59Z
	XMsSo6AyKl1Ftq3FYhSWXyP+gkB7CtcT+EAXQqZcsZ+DS34u7SvTYUwyypxa4OrsUH6bRoZoaSF
	90usvYvYVxYpKz57+1uUTy2hVwmeLC+1i2azhKdht6kOYkhAMVQCHChTdBmXiePJvciBFjvA==
X-Google-Smtp-Source: AGHT+IGCFbc47aPEF11h47uDLP1j4N+ZFov86gzUBU4eKZNiHrSyBdqxK04QEbh3fwr2eha0kQT3gg==
X-Received: by 2002:a05:622a:190d:b0:4ed:5f45:42c0 with SMTP id d75a77b69052e-4f0176bff73mr22805341cf.62.1764753964647;
        Wed, 03 Dec 2025 01:26:04 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd341f2absm109317821cf.17.2025.12.03.01.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 01:26:02 -0800 (PST)
Date: Wed, 3 Dec 2025 04:26:01 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Oscar Salvador <OSalvador@suse.com>,
	Juan Yescas <jyescas@google.com>
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
Message-ID: <aTACKT0b1jFM-G20@gourry-fedora-PF4VCD3F>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <aS_0bgCs2qE0y1bJ@tiehlicka>
 <aS_2Z6ROtrxLQcRN@gourry-fedora-PF4VCD3F>
 <aS_4E2H5aJmSvWF7@tiehlicka>
 <47a8b4d5-f4d2-4772-b1b2-ee96bc21e742@kernel.org>
 <aS_8ndgdVbffPYGN@gourry-fedora-PF4VCD3F>
 <9de2f7e2-a202-499d-8858-6936beb251d9@kernel.org>
 <aTABiHsL8NbGWNaL@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTABiHsL8NbGWNaL@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 83D2CC0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: p4ope7y3pezgf1gnfn7hu7ozuoctaa4y
X-HE-Tag: 1764753965-329913
X-HE-Meta: U2FsdGVkX19A9j8MDxxy6WR9vEEOnvsi1i1aa1GZNDvzsV3NNYWjd7IyoD6YFaAZKJRIEjPxS1NM+USPWFzfXa38TE05dAMNyX98+WIqJghY4XQJegCwzVw+J0/hxD0b0FwtvuQfQ6sQRg46F9v/q5gGPp/Ju8eDAHnKh4PtvjuS1zejIGjNCWu/8/VsLxrnITHgVHf7oCxHDeL1jcoU6PdoQZwKduZqeg3/xaoSbZB8BEfcb1kmbgheXJbAaUxHnKOSKupAMFFW0MZj18vUrqbGuUwSPcN3uVdx2B1fFmhDVOxwzFi19PPW9qugYQFw8VYJOihUDU85ZvU7TQongrmrOYdvZZTj3lq8b+mrmhgt0I4SJizQP/XURGyuiQdql++2Zb2Be6J/AFg2vie+FpegSql72ungXdRftj3jxhKqFRLsCpmoijLVG6StVr/07/JzLHjh5BdYKsewNOCwbD9Gsk51F6anM0NKV9qd/Coj74pSgN6gdoNLti4Km+iPV0D9ymYEk+QSLA31GnhtnwxuqOwYUidqYr29hR0m/sy2mablsJN++QZFzuE0OACGnY6Y6NapxY07zv8jvAuKnJNJh86Yau23RTo80e/istLb3x7D4OQCDma0jebxzr9KHkPcLarWSgxT9HN8ZjOKXetdBDRGnsCqp0JUipXQQ+S7AwEkxq5wO7TNJyPlSsWrigQIyUMrWQeDaOOjXHfKRBzdvkRZsCpMY31IXg4RgbHQvtP+TzWocIfbwRu8djXIWOTapXC1GyQY8Yd3JnYso8772W6B1ev2T1+bkkxKsYNp3peePxO9DTsKxnZjXOdlNgyBOlbOYBHmP1EdCYN6nHemk4A8v+4+25EQy5khqreRkZtOOGKYjT0tIgQL9h0L2uyb/Xvcyd1mJpE4BNxYdXka3HAr85+qpELcuqFRj8G7O/PjgRiQCKrqmb5y33oE3i7hLgsquIWLFvxFYfk
 kQ70qb2H
 gZchk8p9iBj0oNdOqVejAfMPaAscOBSXRcsJOHeHzu4UFZZ7xxGhGVJJ88AURdMw5PcLbarIrLGycl8tQntzn8AYXjfxJrclOJiU9ZBaBY1P5WoLuxbvN4n8cLt6r0O0vEB3qDpLuOYxs5Oo6i1VDQ9NQFdeqM9sLDFwHl8M17X0f1UcgO4xo5NcS5xh2MItWTsyp/C0e40N6D277dM4Pe2PUk+uZN9YFSq7hMT8zMESOOatAtKvBg2HJ1wGugoK5M3NZYFuKxeHm9okNsyznpRA6YcS4WcqIeGfww+KqBfqmXn8pO1LiBvD2Sv78WUWXhcaazQYOGElFcvX1vclv1CGFbDscOJFjqoctuk/7cvOr83M874treeXJaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 04:23:20AM -0500, Gregory Price wrote:
> What luck, I do! :D
> And i just noticed it's the same page over and over
> 

Should have noted: 6.13.2

but it's kind of a frankenstein's 6.13.2 with stable backports, so I
don't know what's been fixed between 6.13 and latest.  If there are
relevant patches I can search for whether we have them.

> [ 3404.119270] migrating pfn c06f176 failed ret:1
> [ 3404.129152] page: refcount:4 mapcount:0 mapping:0000000061ca20ba index:0xad28e5b pfn:0xc06f176
> [ 3404.148284] memcg:ffff88842e855000
> [ 3404.155834] aops:btree_aops ino:1
> [ 3404.163193] flags: 0x17ffff066c00420c(referenced|uptodate|workingset|private|node=1|zone=3|lastcpupid=0x1ffff)
> [ 3404.185408] raw: 17ffff066c00420c ffffc90066a13ca0 ffffc90066a13ca0 ffff88812b8502f8
> [ 3404.202603] raw: 000000000ad28e5b ffff888859fd42d0 00000004ffffffff ffff88842e855000
> [ 3404.219779] page dumped because: migration failure
> 

~Gregory

