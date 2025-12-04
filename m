Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE0DBD24449
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 17:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE7F6B00B6; Thu,  4 Dec 2025 12:14:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47EC76B00B7; Thu,  4 Dec 2025 12:14:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36DF06B00B8; Thu,  4 Dec 2025 12:14:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 219876B00B6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:14:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB2D113A64B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:14:58 +0000 (UTC)
X-FDA: 84182438676.03.F06DDA7
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id D557140013
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:14:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oUX9g9gg;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764868497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ofjwqiOcg1c3d6qFlj4mCLrxvUQwOrLehDW+ZXphizQ=;
	b=PdFB8TN77q3N/JUqdbE099epGF+R8f92fnlIiVUO9hi34P10dDWn+8VD3mLhy3G2/3yCDn
	3wFqjW2ZXKf4Ju0/difuBucq6Xaf0rRY4tLH4UenuewV1r/7lwdgdA166ufkyRU8GLHdhD
	chuxVdMXPn3tja5QRTBaEyxoTwwewIs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oUX9g9gg;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764868497; a=rsa-sha256;
	cv=none;
	b=WgQxU4stEdo4JwIE4ARDeZjxeBxPe839EAd2H5kwCKbCW1w1oMH800LieSZFp9jpB2TGXl
	gV89wcoCrgLYW0ZZnBIffryQocoxRr9DXqjY7U3/7Gmo289AcCbZu2WM4WQEvo78SrAIn6
	S8Sj5QNjRcNbrysoIeTWyIJlWV0fzGk=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8845498be17so12508316d6.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 09:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764868496; x=1765473296; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ofjwqiOcg1c3d6qFlj4mCLrxvUQwOrLehDW+ZXphizQ=;
        b=oUX9g9gg5/L6JvDR1ltAmRwM+lvG/14yVCuziIwecOIsfGFzDVyRox6PHp7IlKBReU
         c3Yg0FE92igICUw0KSxcgeIFP+TbhA1jTUZNoXW1/5nKumzufLs4PeNmvgpxvdU+HsHt
         PI8k8NA5kZwsbQM+w8ClIZv2CYWhJlk1JtlUxYroClQQKW/FtCaSYRO+Oy386dFyZJSu
         3ifPtbmlHXDQvpXr1snvHlqavAqQhu17whYHma7ZEZW2D5CQtdM41L+AKdsVFNMnGj8+
         dNvsBei7gP031XFDJiVgApSOBwpd9b9zsf+xYjsjjKL0PB6B8CFPu7PHaoaRUCoCmVK8
         MmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764868496; x=1765473296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ofjwqiOcg1c3d6qFlj4mCLrxvUQwOrLehDW+ZXphizQ=;
        b=grORH+Jbi+jueRzXo/bxDt6zuOf/OCCKdTnAIN/3V6EPa5BegOnW+V1MJPn5jFgsFm
         acc/D7SgcMxG211DCfuHyp7qxFq8F5TOyOZTrZyp0xbh2HbFXRP1tsXXI9gtfW96M2mw
         nWRUw4Ivk3wDRQKX45IkXm5zHaFq5ZSSjCAbdvfMd5GJGpNgN8Tdliice5kz//8CEkqL
         m0eXB4MV7cT4C1bXAbyY1h1FsCTe+wIJjsqImBsyBjjz6RJDATvyEQYBeHQylTpL6ZSx
         BSgrbqqzAgdoAWmnrMC2Z2GkLQDJidfZPqSFq/o9QYis4e0jGbameZEAkffVtYZ2v/6a
         qvSQ==
X-Gm-Message-State: AOJu0YwLn8Ey0uOp5KQTYiYMX6G8iXZ3QWohCRcO6pIVN/FrQ/Qx5Loj
	pYswoiYJprwk9biseGS4BCbnwuPG2jJeGAmjjkZk5WjBLon4MYcqkcd6SVYCr4oghvo=
X-Gm-Gg: ASbGncsvEEy/XUpTFe9QUD/x2aYU9quo+mPilPCHt5knzh1/ka1zGq4XmPQEjsk+feH
	+7C0WcDrGH9CF/prkUl8KlGpv0TkpAWU7l/P+HT1Aywkelhsz/U9KD4WVJP11SyzSQcqq7eWfjs
	jiNmaRZcijVj3qQp7nrmE6QszMM0yaEjvHEQpZg5vJGDZLOhZM+lqRk1Nw58ADDeg9voJ2l2A08
	5MHLkQ9VnPtb53eooji/3kLQVLPFMWTrvttG45JRqm9xZ6TXlFy1lu/TRi0CoX9tijoWJZhCMLT
	i6gCL+bTfDqHKEbWTiUBKKU+2quKwXVcwVF3hAbfeTzs1ko7q4bnAhkSqqQi1y2pbDIx9uYg+7O
	9mbAQClKfa3l9SqZ9FYcnjNOA3qYtTYR5Q0/jClm1XbAsTJZo2vH4QCf04+dY+RF3zevoxu8+pX
	e3or6d4pHiPu/8nlVJMUlRWfMjwo/z0NhrBYOljBLaD2VRQtIRBoFxwzTqo87kUOEaHJ9xtA==
X-Google-Smtp-Source: AGHT+IFLxNiDK9rQo9yZICzkfx5ZdHibc8P8WJL1rCPgVT0okFH3vVSL8J1wXE0uJ8ACsbEHHX4ZRw==
X-Received: by 2002:a05:6214:2461:b0:87f:bb8e:410b with SMTP id 6a1803df08f44-888194c5987mr105661836d6.3.1764868495500;
        Thu, 04 Dec 2025 09:14:55 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88827f3347asm14832226d6.6.2025.12.04.09.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 09:14:54 -0800 (PST)
Date: Thu, 4 Dec 2025 12:14:53 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, osalvador@suse.de,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	muchun.song@linux.dev, Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] mm, hugetlb: implement movable_gigantic_pages sysctl
Message-ID: <aTHBjU5-Fio6CrwD@gourry-fedora-PF4VCD3F>
References: <20251203063836.187016-1-gourry@gourry.net>
 <305328e0-3011-409c-a040-76fc478d541a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <305328e0-3011-409c-a040-76fc478d541a@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D557140013
X-Stat-Signature: qt8i1y1weprwzudyxdbxmw69saz1e8t5
X-Rspam-User: 
X-HE-Tag: 1764868496-959837
X-HE-Meta: U2FsdGVkX1+Hk+kIstRwNs0x+R1iIoGSrOvkWy2Xbxco1R2rHhnRGK86JGbcaJTkr2SCwkeZSrFpfc8LETXNyecIvAIdVAonHR1ho96U6SPlfbov4ZFJ5qgSDgnKrxxA2StSeWUZmZHDE2p1BhD6p4csEN2ie+70gYZD2h81cHUzbs3ZqLXCrk2t+BF0IOH3ax9RWlhu/kqjfreOf3jN3AVbKlhKlyjNbwSyixYxwmXiEZzssTRVLwhscQyHYcsdl7lK8YuuuKi1Z4NiIkLvkiUzHyV3iSgWf5TuJkQ2fKkMbsai0Wyn5QQkAiyNHe5l+gw7D4ol+MzpysT5Tte9YtLxNnzU3pnTTlJI+/shuSj9cu8zwcKDc7KotcnYauCKrqFAvTgaMR3Ggp9mR4WUId89pD/w3SczetzKxGmRMukmWeB+Fz0MERZ7qekCRJqYs8dYSwWz/47PJc3AlwkWCf2Yir083S2mMNxEAIkk1PcQcMwqoO4rxR8Elv51rXVRDGeQtiNbJA6eom4jv2VO5r4rBB30YxYq7vyRTsamEsObNaeHI+pMTSbzjdBwq/Uu0HbUPnX3nI8wDpGW3L6jO4X7Kia40lnZG15hb1pSFCUSFC4a05soy6cCB2s/1bk0ps/bvQrBWB6f0iG3tjPwNkCtZYlr9CVk1v9DzOQ4SonaqXi9aO07xC8NzqxRpAhx1hzUwe0MHHx3Pp5qaDEAXIaUdNtt7SZnuT6UUALrRSDETYP0GiovJTHcfnR2yR7kimeLOlhWPzQSDQbSm7ZUuQpQV/RqWg72seBxRBKx34X9ijxHBRQQVZ4Kp6UYYxTXZA0VnyKSreNtufq/QeQjbju/0qTw0Sj1wJyQmhK/TEdkUizhiDvcWJU4kFfOzEIjU/AnqM5kxFzIHS1GI4tMIoQJBhJOsdAyMYMwBrsc6DpL5Mn0jc/ZwsXjWezry7jewB2C7MlITM3nNulQCLe
 DdypYWEA
 S1NqkuYbIUlHX+SY2dhHgPomyKGSiOFafDmuq8lzP0QEYmfREWU0mGWiPIUXHw3OnojAQCJXk8RR0ntgtdOe4rdy1nSvSsMbTxzfZmUcMTQ4dWv8VC4ws4QhskhzhDQ9H6fWy9XYSAPOYQbn3ReaWEtFOgXgitr4f+h5spPc0TUqkDEPgTCxHVOFVgLoUaQmqDLqkdVkFlmybrlg2URj0T5JjHBcXqzMv4XBE02eeuVgKr9B8yz83JiIO1jW0VWWx3gv7Yq/S6OpbUdJhgjWFM2z5EiSLsv8F7vlQlkDrH/NC0mDJlP4zYjzisnqvY2csIfa4xjuemOXf7FS4q637vGutnaUgXeWFdOKJhD6OkoWhSPZpLyGS2dz7rlgZGIpVLjymCqNEFvbcowEerpf1b+KI4lIfEMIY1nFWnSKM3W1cr6mQzyFJ/KryTEWSy0UoUVeZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 10:26:20AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/3/25 07:38, Gregory Price wrote:
> > This reintroduces a concept removed by:
> > commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")
> > 
> > This sysctl provides flexibility between ZONE_MOVABLE use cases:
> > 1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
> > 2) onlining memory in ZONE_MOVABLE to make hugepage allocate reliable
> > 
> > When ZONE_MOVABLE is used to make huge page allocation more reliable,
> > disallowing gigantic pages memory in this region is pointless.  If
> > hotplug is not a requirement, we can loosen the restrictions to allow
> > 1GB gigantic pages in ZONE_MOVABLE.
> > 
> > Since 1GB can be difficult to migrate / has impacts on compaction /
> > defragmentation, we don't enable this by default. Notably, 1GB pages
> > can only be migrated if another 1GB page is available - so hot-unplug
> > will fail if such a page cannot be found.
> 
> In light of the other discussion: will it fail or will it simplt retry
> forever, until there is a free 1g page?
> 

It retries until a 1GB page is available.

Example test:

echo 0 > node0/hugepages/..-1GB/nr_hugepages (dram node)
echo 1 > node1/hugepages/..-1GB/nr_hugepages (zone_movable node)
./alloc_huge &                               (allocate the page)
./node1_offline  &                           (offline > memory*/state)
sleep 5                                      (give offline time)
echo 1 > node0/hugepages/..-1GB/nr_hugepages (dram node)

This node1_offline generates migration failures until the last step
occurs, at which point migration and node1_offline complete as expected.

The migration failures produce the following:

[  707.443105] migrating pfn c080000 failed ret:-12
[  707.453353] page: refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xc080000
[  707.471315] head: order:18 mapcount:1 entire_mapcount:1 nr_pages_mapped:0 pincount:0
[  707.488504] anon flags: 0x17ffff0000000848(uptodate|owner_2|head|node=1|zone=3|lastcpupid=0x1ffff)
[  707.508393] page_type: f4(hugetlb)
[  707.515940] raw: 17ffff0000000848 ffa000007d873cc0 ffa000007d873cc0 ff1100082366c6e9
[  707.533126] raw: 0000000000000000 0000000000000010 00000002f4000000 0000000000000000
[  707.550317] head: 17ffff0000000848 ffa000007d873cc0 ffa000007d873cc0 ff1100082366c6e9
[  707.567699] head: 0000000000000000 0000000000000010 00000002f4000000 0000000000000000
[  707.585085] head: 17ffff0000000012 ffd4000302000001 0000000000000000 0000000000000000
[  707.602469] head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000040000
[  707.619851] page dumped because: migration failure


I can add this to the changelog if you prefer

~Gregory

