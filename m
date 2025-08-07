Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B3DC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 08:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544D48E0006; Thu,  7 Aug 2025 04:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4618E0002; Thu,  7 Aug 2025 04:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4068E0006; Thu,  7 Aug 2025 04:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AD468E0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 04:55:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C644B135C5F
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:55:25 +0000 (UTC)
X-FDA: 83749352610.30.7490014
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id C7F63C0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:55:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HsR2Df6a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754556923; a=rsa-sha256;
	cv=none;
	b=AbH7JB+niRJDIMwUwH6l9cUxW3JRQgY3J7XtEEflYhAL7gkuk//SuKDpuEnTZ+mfDC/YAe
	GpwN7IqUbmlTdTiwUiqvgl7Pwx+cWXU5hYG3iVEbfxGdrf1fSiWFpfGsq0RVauLimL4jBx
	n0qsteCfxPaU0/dYlNSSK149WfjwwxY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HsR2Df6a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754556923;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDXmh75UDPVZcShbfv7sdO0bYeNcflHpZyxCdwnzbWg=;
	b=YrdzTFYFqNxLGJjN2F+jjptywv34ILRVnKZQGvudm8ofdhE/u42eR5eFWkD0ZVwFKMdZY9
	0Q0KdzIbmk3A0iunsWjPIBw+FpT6KxyVwXbq/S5zWWxeGfpUosH/BG+H9jcmbVdozcUrYP
	ThXICgjvCta24hGXzwaXXYmEQPcThyw=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-af922ab4849so109231266b.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 01:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754556922; x=1755161722; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DDXmh75UDPVZcShbfv7sdO0bYeNcflHpZyxCdwnzbWg=;
        b=HsR2Df6aUwSQqFUZcx9rIwGTAAgC6fL0qSGiDJYM8TUVTZWE9uxAIAlbF6rNh8BlTV
         hFbFiaJSJ7/AxbTzytM7cvibGB9+vrkq/4te+XpzyLCu/F5iQAJoFGDJz73wtXJJxRth
         RTv9Wf/1b+IUB43zudvVVD9nFUxN5dpAwed+qT7msQqhoh/4ZOvF20EvYCSE3OzJGluu
         z8AbrkJrp1HctATlB3+d7M4Q8qFbDdHnJRo/OvR03id/5D0NlzMceFvZWUslxb1a6x1P
         BO81wblXAIiXs4nRr3gdbsToqbYL8x2J1D110CfD0/rUDwDwhED0k8Tzq3vf2BEkVvS6
         LeRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754556922; x=1755161722;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DDXmh75UDPVZcShbfv7sdO0bYeNcflHpZyxCdwnzbWg=;
        b=CEIM/p0otiFI72/lXMLjA2VHuoQ/ScOkoGoMTzQChapHkRhSM0W0URmQulCvIg9utu
         y+/tHEAyZVw2wNCK0Q1A018jKs3G13048vqTxBi+96o2hSw7lflr9gpPP8j5tnxw+fUQ
         GLDO3vG4a8ht3SKBt9SfNhwJLNOk6/bYZRPd1gSFyjK5opWVDx3itnZDFqKZstn4VfVj
         UTU91u/XuZfkAiYNS2veZPI43H3rUcf60VXh9Q52glOxYnwdca2mioeySa/lFBIXetd8
         TGpNjyA8DIxhCWP4RG+DYkNHmWpOiGWXx4eAedGu5k9DJQX4y2tccUztfgp0akQqDc1s
         pd+A==
X-Forwarded-Encrypted: i=1; AJvYcCV6kjoIK0ZzeSZKrqB7b9EvIh/XVNS/5CxEZlJlsBxBXQOHEEgBqz3i+NpWzbv4U/WXBKpKAbnIUQ==@kvack.org
X-Gm-Message-State: AOJu0Ywb5pVdJzsKTw98A/l1yeHVD9gzJukZID6vdpMPzAXKap4tClau
	QeawV0hDEfidK2rN88FrUc1quTb1Tmt7t1twhONWUgpy8yun+H43wBNK
X-Gm-Gg: ASbGncvoafFbkgDZ6wXjWpOCz3VHbhn+Vi9Rk0Q3fz/WvCMv+1AtG/ycUHjEd4VHqXN
	Wx0rC8UnS8W5VIz4I8jU7wx2EGu1jm+94AkbTy0bUtuMpE30mVW5DskdqAvxs4Twv19rmA+esyz
	KY9safIYw1MPyFUj2JJNA5Py806M4tiDpGf8gHZqybaQPycm3cY0YR/BjcD3Q1MiofBYJWDZyzY
	GAa/2wVM75OryxVeTvPqfZMO6F4y4NKKNwo6TJfL1AjMeOnksfVYrT2xkf7rAwKGHvT+nOsdWS9
	CdZrDLuWO2R2tTxLsdQU14Ctjj5pqUqUtsZvKWZB2CX7DIQuUrH/AoqwpJNWmfRp3HD6EBvn0p3
	hCye4ZDpQn/2hGAjE1XiIFA==
X-Google-Smtp-Source: AGHT+IEMfydQQxrb5qVbUYv84cM9PkRXl2Hy6YQQDXc0ZkkpggsvAOcx80HhZPB2m/3PXSX7+GY/gQ==
X-Received: by 2002:a17:907:783:b0:af9:8c1c:b9be with SMTP id a640c23a62f3a-af9902976f4mr529061166b.14.1754556922031;
        Thu, 07 Aug 2025 01:55:22 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0df08dsm1250904166b.60.2025.08.07.01.55.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Aug 2025 01:55:21 -0700 (PDT)
Date: Thu, 7 Aug 2025 08:55:21 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/huge_memory: move to next folio after
 folio_split() succeeds.
Message-ID: <20250807085521.bhs2o6wk6pe7xf5x@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250806022045.342824-1-ziy@nvidia.com>
 <20250806022045.342824-3-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806022045.342824-3-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: C7F63C0002
X-Stat-Signature: o7zu8ztrpc5y6z4ee1twgbjf53h8kmh3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754556923-862572
X-HE-Meta: U2FsdGVkX1/m1ZELSpihepMa9nCVO9+5GsLyDFNiA3VhR7VSaiV4tB0eMrbYfEXTRJ1SqLqEv1pl5lchyg4oJt7sbjYFoQHAH4PE/ws7c4ioPjhH+R6iPCbJo9IqBtzK+oJLhLGSTyqjHsMxirCY8Y1iV5dnPeyR9Y8+LCPkxVHAl6qsXy/YXnrVFfTWgZUMWY2nFInOzzzLJHPLX9U0p6luwLYiV6uPn5wEP531TQ0sgjINrktepKHepLKPHCAjyPBrnixQNqSPw3ppD/s0DaNpb9zbHDUAp0QeZHDAYDDNX/wqi5s2pi8jXGs4A8HupYc1yrOH0PCD3fa5hLIJRjDtbzkcZnG6svSSA/GIIUdRW6pVURAzvf9ZjeyrtmRC67cbMgvT7GhSifZD4270Fn/+ncxitKtR+Bh+nyQX/a2pSTyLduxutp94nrNR3FcX7a+ofT2VyWPYYq65Uji1Vuj+jwwg6Pv40XDv4bTlwcNjo7c/dIt/dE5QFDjKLDUSFCyDVvgizbkeg7Ca8uP0zHsjmXqHIUStNZNXS+7HVovck2Ab+clAVOxZyAseZFDusn4FSHLRfKhyGMX0wLEfxMrqnhrvQ1IYAhfI8sFUUh5I0yEYArTd+iczMQ9bRU9O0NAQeioo7OnHLiMeH2Ibbx6xYSnquCab90k5Ub0R61kCl0UmDR6cHvqTl1StTTVt+reuIo7mTHb9JLiZQr+Wk66MjE9JjoRqdB5/DOprPYHqfYRvRtb1HGTd793VRCYnGpg6tgbmSesf3P5nX0gp+6QORucR685mwD0J8RYSwJZTjg3qzuqEeozTN7Cuf3jr20CcHh2x8hDcRrkCD+h3GbPGvYlw+s/f8lcEgDHwYiwVwAUB8l5sIHT7qrmHQVhK73JdGCuFmLMN4Bxtpdq2M4BqXDZD+eF9ck/cEeVZ5iPOft/HThW6jz0Q4NhOkNkYh6Zy7B3zipAWwqrsYZx
 XZhVIAwS
 0Y5vhhqM85wdqnlsOXoCKyIC9qXdT3GelR2R9QRxNliuh385ITgLPMtPXbs8xmQMS4YnOoAupkAkTlJgpHlkkhEhFaZVyYg/vLPIAWlbvlcx8XLUbOUaeOrlMU7AWs9SfjHM98+Wu1RGG+Alr7jQdCVeBDePQMIBgcZGblYMRu1e0SMYjaZaz0zDXsfQ1McqiJy7smBmvzmRY7+X5eNnQeslNx9jeUQk5pr6qdWA9MxEKNM3JyERfHMJFf0RTU5vaDarL5j5FGI9TvJ+A8889iMlYGU6nADLtmLClQKzxh25wiMo9+5x5utjT7c+lv6cIHTyPsYLU2KTzWE70eknoY2aRdYEvEmNk64t5gNRGGhpAvmsWjXVqAbGHLvJmJ/lxZXtK9+xctiT1SCluoRJKrZdIjfKun27oLux3lsFeWMuXPmITvx1ViR/S2x1RKdv5ZmXzeNivK4AsiF/XP0knJOJCnHvqLf9UpbNxDu+9OyI+NTPeh0cazXy3E25fC5TYgtGr/p3n4Thn9XKtnZJJODSYneObjgk+sqnz5hiAGToNCYq4IrowIPZL5rfzCDV8DfFPw4wew+Hc+L3WR5SejglNgbphpZhyMWvmg+07dAA74Voka/T6LWkelzhE51yDPsfvt7vvpA9JTVg4WuFzIlFFk8jACpzGQyY7xusffNu3dUeQCt/xRUcBNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 10:20:43PM -0400, Zi Yan wrote:
[...]
> 
>-		if (in_folio_offset < 0 ||
>-		    in_folio_offset >= folio_nr_pages(folio)) {
>+		if (in_folio_offset < 0 || in_folio_offset >= nr_pages) {
> 			if (!split_folio_to_order(folio, target_order))
> 				split++;
> 		} else {
>-			struct page *split_at = folio_page(folio,
>-							   in_folio_offset);
>-			if (!folio_split(folio, target_order, split_at, NULL))
>+			struct page *split_at =
>+				folio_page(folio, in_folio_offset);
>+			if (!folio_split(folio, target_order, split_at, NULL)) {
> 				split++;
>+				addr += PAGE_SIZE * nr_pages;
>+			}

Are we sure addr points to the folio start?

-- 
Wei Yang
Help you, Help me

