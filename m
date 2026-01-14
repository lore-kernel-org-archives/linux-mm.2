Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B768D31A15
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928286B0088; Wed, 14 Jan 2026 02:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9117C6B0089; Wed, 14 Jan 2026 02:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848256B008C; Wed, 14 Jan 2026 02:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75C0F6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:37:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4342AC1AD8
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:37:17 +0000 (UTC)
X-FDA: 84329763714.01.D3F89E5
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 601E6160006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:37:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=AjgfZ5si;
	spf=none (imf08.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768376235;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHQsKyub3KFmr4h6byT9LriJEMAGg3GjzDyedELWlcc=;
	b=c2DE+r+3e6IMYqI/VroxpQOhZtdUnvb9MS1cjfm+5NGWgafliz4T0Ne21sTAMzw8ahIt9b
	Kbtcwca9LQ8niH1R+iEHBKWsS/qx25ru3MyhNuWxUWnJCG5mHAIM0ByNNblhSeAiknlwn4
	r5Hpp7W0qJNtW0dnYNLZRBMz6FcDXjQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=AjgfZ5si;
	spf=none (imf08.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768376235; a=rsa-sha256;
	cv=none;
	b=Q80+GlV94cswp5qOVRxpXSX5AAvhu6hw5iuqJM23dpwNJDmmvRB6nsKithsyvsGOUNaHDS
	kVxCJ0nskVi7m9msYJN9tVbYjTfLHtr4p5ElicWu8DGkGjxOTiZ34oi1AeB+rTYUK+9QZc
	riul9FUr+VH/6afsNmiQARoeWQhjH0c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JHQsKyub3KFmr4h6byT9LriJEMAGg3GjzDyedELWlcc=; b=AjgfZ5siTzRzpyCDaHqGE3WpW4
	j+s7tQRTeqdNRkkpX27DMCVG1sb55Ac1nK8b+PUcot1E8QT0/VOhOCMldJYja5NrmzdkSSshcd8fX
	Mhj4gWQN5meymeDNRxB256BFcmLMetym+XPViujCEaZloYAP0/s38nRi/FSREV6W1naQ017yCZvOP
	MKk7NmvpKPjzRRu2gKeFhXrH4P2KwCtUbGC5o+lzSsFFXu0X7J4fvt/Lcb+0xmGqkUVYl+fKISxL/
	U70mfQEKThY1q8xh+h0ZFSDbBVaaSBufBcmq9foeN6OBCgDgiaE0h21qie5Z4IWKzQu7zbTsn9vrr
	PLvkHLRQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfvSi-0000000Gh72-07Qu;
	Wed, 14 Jan 2026 07:38:40 +0000
Date: Wed, 14 Jan 2026 07:38:40 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/15] static kmem_cache instances for core caches
Message-ID: <20260114073840.GT3634291@ZenIV>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
 <20260110040217.1927971-2-viro@zeniv.linux.org.uk>
 <aWdGEI6iQBl3Xibi@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWdGEI6iQBl3Xibi@hyeyoo>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 601E6160006
X-Stat-Signature: ormtx4pujckzfzkxgica37uc5pfgapcz
X-HE-Tag: 1768376235-985406
X-HE-Meta: U2FsdGVkX1+mCNUpYe2ruJHDwwh8MUuLzNXDPL/bLOCVaPATUgIHLn/tdPEU58MVTITpoPe4bJmoqYkXLixSzy5ScIN6IiqtswuszAhMbozXuRR8d47lsEJLPK0DAiMlRDr2MDzP0NKVdMWrDFh3l7uE3z47xjxAyddQ/ShguIlhptYxGV09aNkJ2aLh1uCuPr1KV18xbgRUPrJs6mZqYY14akJfIhLJ/OYcxhlCSjhgsEyoTpo6hGikeYB/vVxPoF8WHkhWY32eH7+zoS9xSLs3L2bGpgBNh01roNtzGnWa1P+yicWsOI81QhUC+C+QmIezK1ZiLUjqRhaEX5SoaF6bQsjnjLgL9GXvjR9RqjftFMbtskK+1MioY+vYz7vNNTi9QLm2tFOQzmxok97PgFTh6Q1XVrPiRX0KJc4IZVcZp+0A9G1GG8dAofRi5k9w7Iq9cx7fqiEs3LpNQYDs2pU8H3A+scRL8zgaB8z62iJ1vBpj2p8ZTEIvjte5n64nig3e/ANPXR8+oNX8V/nif833prEz9kIdMDSiWMSXWwIVRWijES2ckj+RRVXrOaQFgxB4qRQvZuX6Pca8YYYPscRGtUwdPfAZEly4uXlCSr3SfptRWpV4lmtR+UwuvV4Ft6x4eWwMz6SFjpexlNtL/X/9Cfda71qi/duAs7Xq5ZT3qzjWVy8cd/lce6+AjixhjAqSW8zwMROI89kKFWiyiXaf3OsK64Y2jzYqwIYX8o/9cEduV/Ka+FCJw48oZu/e3cD1EkYZf5OVW86OK/tyTb3/kdw406sxque3h5pT5Wk0lrM7V2E2RW/1/3jD4c2OSl+FJZPRUg0W/ofaLSKaRh17fEINSK5JnFbei24NPpZs5K+FqPBNjXDnadi2U+lSQRKIG3PuZ+oqdGtLKGfq58+vcCi1JzZroFrX00goeQTFyn5RKm4ZVUmnto4jXoaT0OhvhimD5LZCGz4RfM5
 ipypW5JZ
 UPfaic11+IHMoJxS36ljjwUe00KWf16QHemMm9mE2/52MwP2gnOEC9+Mz/Ucp305DtcZL3fQO/noxojmcEDYq1u5si+5AV9r3Gs6v4ddo3kzmTLtJbJkLAc5feC7FUll6GbMX7EByMJIUV7nJuAkj99E4sqe9VRcQQjmfCcLINrFuoDTQ6X2Leq/OAMpjWx01Q2iEhfEgjiEVwCFbUwhJjvceaDMOHTEDHfLCWTjNFee1Poi82H5JzWvVEINEdbNK4aKzm1ez+8av6lzOd41MQGpdrsRr/taSHyUcivH1Q++YQ7aNTNvJFFsd8Rec3A563N9GzQKFmG8Ip6WcUHCPyhbiGtgISf+lqjz07LgWyy4nuYLEnxczf4vdP3AACZ5HfKJP0FnwJuF3qJOiK/beOK1d4Kkz2UQ3rPqobA2ncSeYqUki9iDYZAlsfeEQ2s1zEklr5g3LLipv8sZsOpfe3ODlQcwAOjeLcuVwoL45p9d4k4w/M8Zv6LQT91h6zUr2cNWsHKULlIZMagc44Wi0PgIImSxkO3DZjYqM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 04:30:24PM +0900, Harry Yoo wrote:

> SLAB_NO_MERGE prevents both side of merging - when 1) creating the cache,
> and when 2) another cache tries to create an alias from it.
> 
> Avoiding 1) makes sense, but is there a reason to prevent 2)?
> 
> If it's fine for other caches to merge into a cache with static
> duration, then it's sufficient to update find_mergeable() to not attempt
> creating an alias during cache creation if args->preallocated is
> specified (instead of using SLAB_NO_MERGE).

Umm...  For static-in-module - definitely (what if it goes away before
the dynamic alias?), for globally static... might be fine, I guess...

