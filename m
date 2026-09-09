Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F067EC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 045596B008C; Wed,  9 Sep 2026 14:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D5F6B0095; Wed,  9 Sep 2026 14:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78446B0096; Wed,  9 Sep 2026 14:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C635A6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:22:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22664A0309
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:22:26 +0000 (UTC)
X-FDA: 85195043892.17.D49BB65
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1150940003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:22:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=MIEw72oB;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=MIEw72oB;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788978144;
	b=uSTLE2LXwL5GSMSXQvV4cN7CbiwVOg5iJU+T/ugrlN2uBAn1/37sXuca+I/timPGeTDvN8
	Eccx3YID2M5F25Ew6+kkqhYvdxQKiN+ZLfguz3kP5VsaZbxZeBsFq0xL4cQiPqFYUFfrGC
	Rjb1iOeFvfkNLndMURiWSXa8UZofNNo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788978144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdfhQUoai9I947DZmJ0Mq2HjjU3s4/4qoMH6601twbc=;
	b=M5lovKWDlYjAiSf7R6zscCY4kG1h+dM1LK1D8JrmZp83musQJoGqkHMNJ2RXOCe56zbxAJ
	Rz1uMJoPO5sraunNUOx7t+kpL7JaMY+x6ENsFUnCZ9524JIYVbOVO6UTc4Gm6dEQiTtA9x
	kFZj/c72WB+x7TeCZmOhTWBSNYZBZ4o=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66bd7857841so6769955d50.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 11:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788978143; x=1789582943; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mdfhQUoai9I947DZmJ0Mq2HjjU3s4/4qoMH6601twbc=;
        b=MIEw72oB7r+GWQbiQ4XfaUY0e2/eyWU1/pNRCy/spK6PGvSoif4J2BXWG1/X/0I5Cy
         x3B1KKqeF/MmRTwangWdbN0gKPtLHDmc06u7IFjzVpKdWE3icQIuJdnJcAqoGRKEuNPp
         zADku6Pmnc35TZzZtMrlDbP2dLmqJx1LoErj4o3Olv6URhrrKSA/+FePzq94ffEd/aUB
         oeiwvcfrYbyJO1DE79gbR/NwLjEqE1Iln0sH5C9qm4WYkDNh52uQMMRU3LeanTfDqssc
         bGLvz13hKebkfJ28bUtvTHMjd0mgIl7vaItMApleQGM1ryd31asobpgX+MIDVwoBtefO
         KG6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788978143; x=1789582943;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mdfhQUoai9I947DZmJ0Mq2HjjU3s4/4qoMH6601twbc=;
        b=NiMV6LrkvvEDnJNm14dFWSGChDCH/bki4LrLpUZdDNwfTkIrq0zuxU+nTdwOWfsYuw
         W92mDaV/5IeqxUUUlu/nUCZaCHuixUAdnjAAauF00sZJm9gya4/ne9/eGuGmkMLZ/xOx
         Bx6lXfC1/j2zr0OpbCqOghy1OdrNvMp6FjtoyTC3WVe8f+r6iN7UAXkNwd9Weq9uwcK4
         7P7RkxpWm96LxNuO5q2sYmnW0T6F07xT+mPPt8iJ8AhdxtPQxm2gLiupJ4YH3jHGG2d4
         8LVrpKdp1yk1GLvo46CusylPP0+T11R7hYkeJTb2x4F4bUE8de39G8tY2CMSqlyC86us
         NinA==
X-Forwarded-Encrypted: i=1; AKwUvByo1ePXgVcBjLMoocxaXs7rtDmEIltc563QtkO6xXgkl4CP08D0snniTgLItB4AHrbSOOFZnO+8uA==@kvack.org
X-Gm-Message-State: AFuF++nOqWRAXL92h9pci3U2Wvkj7eAZKOaAxBeprc3EaKlKTyPYzWwy
	0pk1TX1dkv7YmOhGZMNtMaMLp0ISTEri2flj9rQACu1dyngnyoE4ZIF7RxZ4qhkz7p0=
X-Gm-Gg: AYBFou02nkA4dgtUl3pyjDV+JIO+RGW5keIUEUf5y+4ZaNcWhSvKHvpX+Trcc5LZq3H
	uNglXmYfcv1uSm7D/AJ6Mp7YwYSSDd+kOXCOgMo0xvmrjFLK00yKY9lsWTlufW7YRQtelK/BqJF
	z8+tixtzDQiQ7c2hs966T0hvBGh8gEAv0R5e6TVQ+b6MFy0xx8dyqGyX/aF7QFnpZ80VYvyfEyN
	GOkLMl0xrDFJ9v4qXtLdrATe8hb7cOkUSDF2+HtvSogBCrOC39l0YXPPQTQj5UwS++kaRBSaI+x
	VJltX0Kt9T89eGBHWlXUONvnMlMUM70p5rmk6zTbhIVGtycgsU/XGhyfvM/yAgvj9Ew0OuZuBT9
	7JTL6+NGDCJnY3vAw99qmvA/t1NFeA+XBnm4wDJPLMVEYgY3QdZiFOO3v8y/uF/3LfKPbVN0Lsa
	H/0nYJe5eS1n6WTSr7UxdNSkmqyjBcjCMMam9bT2MRFjqIXq3WXLhRVCczQQzH0eWeU4mv1A==
X-Received: by 2002:a05:690e:108a:20b0:66d:28d7:c33b with SMTP id 956f58d0204a3-66fb5ad93b6mr9645565d50.40.1788978143182;
        Wed, 09 Sep 2026 11:22:23 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694c35sm149647686d6.36.2026.09.09.11.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 11:22:21 -0700 (PDT)
Date: Wed, 9 Sep 2026 14:22:20 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm: list_lru: keep per-memcg lists with nokmem
 for NONSLAB-backed lrus
Message-ID: <aqGj3I87H6MnAZRQ@cmpxchg.org>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-3-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907110111.2286932-3-qinyuntan@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1150940003
X-Stat-Signature: 19keayw8ro9gpg96o4x41znodwwfpmg1
X-Rspamd-Server: rspam01
X-HE-Tag: 1788978143-841274
X-HE-Meta: U2FsdGVkX1/uQV0UPfgK+zgNFcbTPZ/uCGBi8ju1keGvYpJXlyOcv0y4ajyB6vckowPnAdO6mQSWQd6Zj9y6Jvb/MIj2MB1/Bgm3e2tJkDxhJdeTbsregkS9migYuOtEmF4xv1+vHCKUoda/iT/WmXl+HkP1QlkqjaHs9ed7vJoRHYGvTVOSUS4bu2RRP4NqSWbzjg/5tbIUhJy7FbYWo69BaZ455i9ReTT3/I+Jn9kWDMJktp+bxUIDKkTcGZEPPJUISHDRD2mq/Qlo2EJNShJ39Oq67g1rtnGvzQ6nNxtNHN60Mn9uc5wA0X+0SOu+9dqtWLL+SR+u3Svhi6y4MXEkRWu49llDqXa7weriNd3kAePdmZaZO1kL+fkSZ8eq2sVclkYt6h90JSrJ6KC31LS1dHPPziL3jr0yjVvcxxI78zpQqilgejyLmGU4XlZ2IZarqoJ1TcuUEFn9ccGmeK3tvlL06JzapWBq2ef9OYiG4WcYG3n5saQma2w9UaVEe+KazReHoqnN09nGX7WWyyNlQqlze4h9a4lA4th8UGL2UuTbTI3zO9y29d29L3FqabMhRssm1D9we9y5TU4YECsDQJ7ZEhUXKRKltr86g7EWzsAUqRxmEdDbvlq1TcOEXExyFEslFao4iGoX1SBLSdkrdVwOzHatgTwhFh5SVE36XOo5TliZAsJsV9XChoTNA9m9jgKO08hHiQVEHtrUruJsirHe1Wu2IUn/qCLJWwdBgLAZ+ebFEDnUDTTdInGiulRk/OQ8hYqFWmlHKMZtbda+SRrN8mOJtnHiWTtrHh2Inp755vNNWjipqIetANiC/2KU/yVmw6qWhWLPbxHkOnqGF0hY8wsRZZF5Ee5K/L+2/9GhCrzXFoHQo3e9yf14O3U1xfPIeiuDS42Yb5rbn2653Mvy4Gqf2x4vacTZ5xh1tR/C68iImRtNoGs0RgRrNi/6LY6asvAFt374Ff/
 7goV5cf8
 0FrMU6xWECW5b7gnjg1CVcJ0uSgdlmbvIMTRq2/CdN/r3649n/qG9UvD5w8mUUHNIxHk6q4QsNpiU3RgUst1LKeTpffcZ+evCs4O5JITgfSgmxZQRyZtsyYzNTAO5w4N/ro7NhWhOhKQag1iQR5EEg2W6bPHP3A/YKvH05TpvkQsTUBrezZElTZzzemcKw+PQkJxxGZVvzAjm6kVt/58iyhip4W44z5Lc8HbtabbCyTfQjkHZHQ67Bg0PofZuAsbp/dDgXV4oIBlVRkQSTeoPtOOHqm7Zpj3mQs2Et6wpwdah3n3ECD8vvtLp1gy6jxb5Gig2kIh74xN5tN/7n3UG2IpfjtEnJvTTxFEG8ogjBOT66zs5f5iZednodr/ud8wo46EEOCXIKlNVIyA9PwFaFL81L6UEaA/1J0eIlNJVUcKXP7CjZq05H7c19TLjJUjdz87PEPk0tXNdlmUK/8qUTq8zgXjULjU6TQdDDAD1vYM2GQk60w5F4q4KTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 07:01:09PM +0800, Qinyun Tan wrote:
> With cgroup.memory=nokmem, __list_lru_init() collapses every list_lru
> into per-node lists.  That is fine for slab objects, which are not
> charged per memcg without kmem accounting.  But a lru backed by a
> SHRINKER_NONSLAB shrinker, e.g. the THP deferred split queue or the
> zswap entries, holds user memory, which is charged regardless of
> nokmem.  Collapsing such an lru loses the per-memcg view of its
> objects.  Reclaim can no longer target just the cgroup under pressure.
> 
> Keep such lrus memcg aware under nokmem when their backing shrinker is
> registered SHRINKER_NONSLAB.
> 
> This leaves the savings of nokmem intact: slab-backed lrus (e.g. the
> superblock dentry/inode lrus) still fall back to the per-node lists,
> and the per-memcg lists are allocated only when a memcg actually holds
> such objects.
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

