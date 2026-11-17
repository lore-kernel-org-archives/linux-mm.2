Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B92606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0sVre7Iy
Received: by kanga.kvack.org (Postfix)
	id 1C6996B00EF; Tue, 17 Nov 2026 05:59:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177A66B05B0; Tue, 17 Nov 2026 05:59:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 066856B05B7; Tue, 17 Nov 2026 05:59:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFC7B6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:59:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62877A03AD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:59:25 +0000 (UTC)
X-FDA: 85444314690.01.665DFEF
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 915A6A0002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:59:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0sVre7Iy;
	spf=pass (imf25.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794913163;
	b=s+0b8QEY7FnDQ1xO3DJnXK0AvEa3Ugk7Mnic4g7KtoWXVp9VAzUgvA8hXxkUYcsO2Tb1v6
	Ce8Sj7BSE+bjU1ZTO52B4oyPCjj5kKboXBTGvVZuFwWtVxF6qnxB0bYmfkcJPhsM7xgN5z
	7QN5xPOoq3QI8C+ER2/uKvwhkiE8VYI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0sVre7Iy;
	spf=pass (imf25.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794913163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWPCuPoHCv+Zra6hIa4YWB5+e+mvMzbV0T9yKI8SxJ8=;
	b=52J3NVjz2H/RZ0jZzsKlY2Cretza9r6vIbQaDILxQHUuZ2PS1XcoWCp8GJe7a8S6bmVNZH
	5r7uHW0FvJEDlQCTJHJbg41BESWGqAgnXyc7PpAopcHrlUZJDRxJaKuN+ztBUCSYzLLTCk
	WIirLg+goG2A25EyAkJ4wrHaaygxwPw=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-33bb5afa736so444725eec.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794913162; x=1795517962; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AWPCuPoHCv+Zra6hIa4YWB5+e+mvMzbV0T9yKI8SxJ8=;
        b=0sVre7IyD4cgfVPZUZccMV/V7WuySQIQAy55PIsZvZUO73CkIvFK3debOPDY4U4Etb
         vByvNI9v2yhLv5oemkVTmX9m9yP5f+UlDRbwfjNo2hViBoSS0aSKv9CK4l8vcal9JHAc
         D7M4uO837voSbHqkb3w+LKxlS6uTseem7uBiFXCeaj7XKKwZ1N0KlxJ/+uFvSZrTaCZ8
         pv15GRHvun5OfNeRA9dWWCU8EnSlRSyx9I5dSiaGXCSqoalld2sODDOjhlqWRgbaySAQ
         MKZkD8tuo5oO/j3cYMOluPmohLPxv9fBnN/lEn/XCsu7T2PTfnFW6o4/GMTU7INTWeBY
         uY4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794913162; x=1795517962;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AWPCuPoHCv+Zra6hIa4YWB5+e+mvMzbV0T9yKI8SxJ8=;
        b=ONSKYarsZ3vs+njkXt9UcZ5EHh9n+q1rPYRjCn4yivi3xQEhoAdnsW1X/2rCv1krwq
         p0oKlKGOjm3cBCZuy2G+MyvOzWe1LVHIslIY8YOAWpn3Ee0mtiGFf8BENfjwYAq1VWiA
         S5fz4NCEYULG6JMY/jEyTtvRR4Puiu5TOcn/Rk4PjXDphW+VX/YSymunpMYQF5wzUIIv
         9E6eOKfG8NGZi9bbKb9sC7Sm0/bxPBYOMC6ECWH31gJCPvKCvSmtMm2svFK1LeTbgUpA
         Na62ceVjv0IaPf8YMa7p6gzzzv+bfwgCgPOm89QZeCXLWywFKL+Z+cRD+K41s9Vw7x/q
         TdxQ==
X-Forwarded-Encrypted: i=1; AL+hErEBzMMaQBBqtXRC4apv8C7dP4g1/5INdpVP3DYJ2QY+NTxWzotL/IowbcJy6S28S3lv3TslIG3tTA==@kvack.org
X-Gm-Message-State: APuU4Z8rWM9Fndnh3BpyvlKsPFLfXPGx6rS7bV/2uwTiLIowwH+i72Hv
	SWRxC1N+OVlYc3J5sYkxAr1WcLhN6ErWCkvaIkkG32JBUpsWCZCLPnRH
X-Gm-Gg: AZFdTZdUyWgsJJAQozDDPEOv+Z/DcOmHxHcdCsvuPFBY/ajmu/74HwI2GlDRG5LNIKm
	pxMUcTyXwd8f1rXI60+eMgU6neR01F3YmWMGCtGWPcbtAQfUC16/oyDhsGaD3S0+V37SYGTfbRM
	Prf0nTkMYwx3YLpfuqR7ZKpQYSxBGokGjhl2vjkaayWcW6Dbiehkm+uqzAirwePFYZR0BAayjMl
	XO/w5PJE6U0vHf18jjQlBulqkhuJ0vTckyj4KmHQ6RZg+MGI56Gyo9qV5TJMPboBQ8xWCKxhl3Q
	CxCrHwolMCr0jMnLzpjHRGVWoZ+vN27cyXgWJ4sUyWxjwrED1LWKGZWC4Zw+VUOXPKdcAqlD6KA
	2LIXsStKMOSMxPZEifSuPXLCd5zVVX6ccJcvmnlRlg7pqIVSxjEVj7zQNcNfxn/Sy+DFYjsE9Il
	S6RCDEhFd7E2QI1dlJuY168Dwx70k7MaymMmGaMotl9Eej4yRCjpsgGLH+bxb0TfxYDl5pDWoTS
	SeK+3tSEJi/k53H4V2dno8u4DV4E4V3hWA9Tft2NXDUItxx19mnQcuvNZ5vsLm+SpNHFIqck+PF
	R5qApAoBx+RGj4D6rF6AN4T0uX+0tHyqRsWu20qU3sT8GGURUWgzqNaovrYdMEUi1gw=
X-Received: by 2002:a05:693c:895c:10b0:381:6297:8f99 with SMTP id 5a478bee46e88-3816297a694mr2315523eec.2.1794913161810;
        Tue, 17 Nov 2026 02:59:21 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37956bb0c40sm44832996eec.28.2026.11.17.02.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 02:59:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 09/11] zsmalloc: embed struct zs_handle into zram
 and zswap entries
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
 Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-mm@kvack.org, Yosry Ahmed <yosry@kernel.org>
In-Reply-To: <20261111064707.2568433-10-senozhatsky@chromium.org>
References: <20261111064707.2568433-1-senozhatsky@chromium.org>
 <20261111064707.2568433-10-senozhatsky@chromium.org>
Date: Tue, 17 Nov 2026 18:59:13 +0800
Message-Id: <179491315345.964041.6401768578977065454.b4-review@b4>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 915A6A0002
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6isq531arh9ggccwpq9y4nk5bi83e8b1
X-Rspam-User: 
X-HE-Tag: 1794913163-220598
X-HE-Meta: U2FsdGVkX19XBGKBKJmgwE4uSBUGNEgSngi2eHUt4a1GAuemh23dAgv8VIUbtbnnDvUqCTM70qtVvkgY+wUM4Jt3HZgj1tyAHQySpM86ESnihz6oLLNEe4g3wtWDmS3182Ee5uR1+MDm6bbc7RbVK3UJwbMCb0b74uLY1cx4wO31j+6Jlsq2neu6wUKq1TlZwqLCLibravttUz2EAT+PQ7TwIW4KMq0VACAlGEH+oAPyFa9d03fFTqNsL4KXZybqkRF2+uMugrmVh71a2Zcuxu/QPWV739x1pbR1E39uBGepKduPW1sDjZZKu34aquEeWc2q/6aD66YZ19C5EJeyLKdf0+Uct0H5ngB3Mx9iDbsop9fTYRnqytIf9Sio2/D9lVl1aqshLaB+3mgTEwp2oPj8JkqFZ6kdvahrnyyehtvoJLBpXgOIwn3bjiEkOrCxjz+aQO35hqctt5gtJ7M/GLb1c6c1h1V9uELCNPMmLObf9Ygu/2yJb6tkAC0CRWqH0kChRQJ7tfdqtKv1IXWL/6FmfoCAIDmswD2P3U75YVUMYvntX+inXiUZfD6qYcePtKesshKvoDQIR6DscFZXfqeKnPR8NwIPYQHhu+UteFwudEKVwNOgxZqa7l6qdn+RdEQYKBNkQcYA3AkmpMXzuoYIUU1eJ79NQ31ecZXvUhOvldXtC5BraPQyarF0ugQlMc1eXsbKSttfUmrXwmnNSjrwO8CNfomVnE9ILC9PqzZhIuFqzLy4xiViTUwUiTTpcSmn6qW/ScxHjQsJ6kkf1KwBA7wgo5JwFpnf+B24Otc7AOkYuGzgpQZyBDlojW7qJNgF+ZR+2Z84vWNl+w7yGGr9IVZ8qB42xyNpRCMIOkJ+VId1q1Pf7v2b+/IZHjiDyiCFwd5HeNHBfLfQghd3l4RdbQKQ/JUgdDQu0tmRLoLo7YsMcS+UB/AVz5S7lW9zDVFUchT/hpMj47OHBtb
 oKvxDs7G
 6zf2K6jIEs7vrTroPh+tqJ883yw+h2FGHKqbxBy7wwLVmLYgDjwJplYzo7o/lzyyS8ADCEs3WKrdxImq4cN0Q1na26W2+mtMyvAz2VYSdFtXXiGMiv0AES1KaHZyO/ODFvhGKvL2afKpgetVvbXWXsdL3lW949m8p8Nt0wDRGOW7/y6LdB5YTzCrRqwLKZeO2X/bKjFB4zTyTGz54bkFbBRvvHbVsAQrzgFdhTCGaAtA7ycTkttikUYXOUYtvGgyTlm95r/dF5bRoeeisj3bLDuWm7rrN/akj0kRTXYVAcixjGzGr/Cz90XmCqS+QNV015OqL2CW2qOfZcMBM1ektAix32mm0PCWxr5KMmlAy8gEUWecrNwBWWxRU4Nmbmkv3Yu/gepQru1YnwNIMDP8kN2+LGOY6mWtIyC5mrynLGEYbGC132svw+wFxwNraRG3AuUH6qzpn9fKB/WOpnNZNtDiH0r7WN2wMbNBqWfjveAaiGZf6U2av2x2LMscOz1YGwlW/txyNrEF94eRvKcS7UwQajNFRqEuZi3DTYuDlUkwOTpIYGKxBNJYQPCCamdNHyLIbbcVsf/Zy6Ck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 15:46:32 +0900, Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> zsmalloc allocates an object from handle_cachep for every stored
> object, just to have a stable address which compaction and page
> migration can update when the object moves.  Both zram and zswap
> already have per-entry structures that hold the handle, so we basically
> keep a pointer to a pointer, which costs 8 bytes per stored object,
> slab alloc/free on every store and free, and one more memory load on
> every access.
> 
> [...]

Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

-- 
Best regards,
Xueyuan


