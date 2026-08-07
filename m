Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29DA8C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 17:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59F96B007B; Fri,  7 Aug 2026 13:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C376B0088; Fri,  7 Aug 2026 13:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3116B008C; Fri,  7 Aug 2026 13:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7BDA6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:01:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FE3E14012A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:01:14 +0000 (UTC)
X-FDA: 85075088868.12.04C9231
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 29B784000D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:01:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Pg+I3gpz;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786122072;
	b=zRkPETKd206RvKJVh7Smbc62rKxVh1HuusL+h+ElI+Z77LliyfGzm2yBjdvTcXZHctugu/
	c6hKgRJpmuRcfYwTtVHZqOVZ1RdQwbNDPUMdZYvd1Fy81qbGkS0K+IG9z6kLphi5gMAynI
	cFf4+/4Idig5GnW/L9KBplg+Lz3whlk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Pg+I3gpz;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786122072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02i1ooJbKuCBAzogAwLi+8I9El04yi+39Um7MRS4spQ=;
	b=zqWkA+v/fGOYDXBD6IPjlKpBpeIYOdeVElopT6DdFXo12ih+4PgXCZ5YLqbuEqS2476m3U
	jsd/l/1K7fz+k9+qDasWGW0gbPTkvAkVhVm+AXOscq5q05kkIvZ1y2zZMj/tC/lOIkFJ2o
	YSr+wI3Vzdzp/DffL2B/DeWoTk0daa4=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ee88fce572so36334986d6.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 10:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786122071; x=1786726871; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=02i1ooJbKuCBAzogAwLi+8I9El04yi+39Um7MRS4spQ=;
        b=Pg+I3gpzI2pMSW1+zyM4i5zFpL6LC2Pqq+Ogq+xtnGRLI++Ky6vmPqj+616zi56U7i
         nPEOOtJMFrpTwliGSRHurv/n1XRntAMQVaq9qGVdpNnYe8MvFZrWj7I6HxOlifd5OBWR
         1sOy8vlGemKhGWI2qBloaLxDWRmV8iyuA9JG7d2OFAH3rxiTFFVgoxpVGrBZXQ+SlSN0
         j+SK2qduguCh+lCUn5kZt1uXWNF6WR0IGpopsp9KSejudwttQjCN9CY78UIU3JrX2ElV
         +u2FSuJvAi1V55sVeawluU3mscDQo9flP5Ad9mp/qVeZULYQPG1R4aSx7IdGYbnkUe8s
         WbdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786122071; x=1786726871;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=02i1ooJbKuCBAzogAwLi+8I9El04yi+39Um7MRS4spQ=;
        b=j4OXNd+gtVnRSgTLcwVVOr61nHcs8vQbK5K2XGyO9J6+OcBRERyJ25M32R2Dm6mkyX
         SsJC87+zATHiGETn0jAiDcdAawnNQdd1q5jx/PcaK1b2LXMmLvUL7Urgb5gZHK92jgwe
         pp90Hf+mKQ7f4iSU+iu+kicL5/grB43+B6Qo6gi9ngAmlFFvpx6n1IQ3geo3eh+0umah
         bbEmPQtW0Qa+76bZ3g10IxmxOAnOCnLEHCP0wLGKbiY74hCPObQv+B7K2bUY9Efh1YPk
         ni+P2GGblr62o/AhKVzjCxOLAssxHeZwl3YfsCXxeZejACsYrneZlTtf2WUA1lwc61v0
         nOvA==
X-Forwarded-Encrypted: i=1; AHgh+RrKC/6+kA6Ehh0zin6/Y6zpWJdfYO9jgfIUNmMFUCbsTQA0NdOPcE1qsKYVJnL3bwKJTbC+o7fz/w==@kvack.org
X-Gm-Message-State: AOJu0YyfTynYGLllX3pl9CV3j52OO3mNFyWZBBF67xq9JqxgU3R6JNqY
	Xlin+sjmEXkLzmFrs0bxSn1ex5qrZn3KtzJtX3NvHBCEMnEOyQkFeflEYOBw226t1dA=
X-Gm-Gg: AR+sD12dqS5EOyYZJCHGToMg9GwTGBz9sdZK1DHE8mGSWUNS6GW9HtDnGnO3aBQm/Wp
	d5WQCzYmFxG8l45jsH/jdqbT9g2QBpnk6u+Z2PbYCwNGAJJSq0QUa9b7TqptGKSlKsXODSTC3/u
	L4ttQK+rtVvdbuSxsgrgwARnb3UQRWQ/JcyzHi6SY5ATGNA/D05LqGXgyXE0RMZvGBTDOygtfBl
	j+Jaq+epiK8NT5d74MYx7A2nLE8zhFKqIC3obwdlvIQsSVYYqsfnWP5EmRZV3YspxbUvwaUl0A8
	vBMsUZbvfSEZuFJaui/6pAnWGIWTW5rGSDnjk4mvItgWDLcPAqhJcz2yWK8v+543goJTc5RbWQt
	ZMn/kEQOUPDxO2dNKVotuBT8VJ3EWgvjo7FPfmqhZXWJDnSehmo9KDr+1nPxl9HSSZoMKhgDP81
	6PwqUWQv9YWig4tE+Y1HYog4EYJuJ9Y3YUGbyF0tk9aTDcIwjclNk2NIRiGmOT
X-Received: by 2002:a05:6214:3c9a:b0:908:93ff:cba9 with SMTP id 6a1803df08f44-9089c06929fmr140577346d6.32.1786122071119;
        Fri, 07 Aug 2026 10:01:11 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908a91b4a6csm12874506d6.15.2026.08.07.10.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 10:01:09 -0700 (PDT)
Date: Fri, 7 Aug 2026 13:01:08 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>, Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] mm/swap: rename __swap_writepage() to
 __swap_writeout()
Message-ID: <anYPVB3dwJCVoXVv@cmpxchg.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-6-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-6-0899bac3b826@columbia.edu>
X-Rspamd-Queue-Id: 29B784000D
X-Stat-Signature: qyodmkha3m5amzyoezzihfgt71s84ymx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786122072-416255
X-HE-Meta: U2FsdGVkX19JiNB39G8J7iSOskIElDOQ5UNnHtym90aQ0uB4vKcO27p6DaJ+OvQqVTMsYipVG6Dy2d4ny5i8MdC6ePkBYA6D6QdzfoDGL/epy6q/7Ifg8Yt5mINcq47oB762rdCenSY1Rs2wn0E7naUWdX1sQiQhrFXIeFhTpT2TreHYMxOXOn/ZjS4UsIDr0Ozm4pJO7fsZYprpPT3jWqeFf+xNnVb2MjxSEs0P136/OUtTWf+IRwCpOU0cSu/pzG2Uf4viwcggI59swdPMDXR5nxBInH0r7sS8GLqhWYbk3GV83Lk2iSfTPYV55eTInEayrRLBAQ0eL3UeBIChXx7SuzNUBRoQgzOWkSjt/lFAqwbEUQXWhqgL0oDFuKCZAzkBAGpMYVwXQkt8s4rmYc1+GA7aq8a5Nrbt1VRP6Lgj6kO/LcjxzsEn+yJoevT1H7mZGthbfzLl6w1b21TOXRSP2IJiG50mAdtZW7Ce7UL0Q7KKrpZIGR6abaalwznmkLcWbVZR1x5PVc7RH/8l70Tkp3J1jUkOjWd1UznDIFB1VmFms1m5dncB4EEzrUltr1mTnAriWuJiTMoUulJGK2O3jWfYjEyrSjnPpyHCHhzh0wc4cKAK+4xgan0OQoIdheXIhduLiY5fd0myndnYj71E+OKgCqDDxzugWYWIl5V00+VCVBORyhkDhT3TY/U6I7VQHOnPvur4XJ83uqDBBXHtgnGALc8wV7LZ1h/IeW25NpsKJDZVvVJcdL2bSixY6G6LWwUMXM2xNk/32R21JxBh1ilLfE7acE2rJ1m1FJTckR7Z6pGnHsrcDENMIz+SSX4v5EcFq45QUq80D78bjqXavgBzIl2YJnh58W8Kbpjg7VJr9JbyGhbS4QVXz9JMXPUMpw24uZISVLaE4Vle3wSrs+Ges0Xb86kM8XRpS9IjcdqUsaXr4VKgzHdWdjzfxkjLbG4JvNvrkVYCa/5
 QU1rPqXe
 Ifb6rSARQtPFDASJrvJb38wPEUm1KsIcjwNeVgkE74C9AXFxEtnsosV17VuzwWuv7Q+nX+KVIx7xHoJHVbCKUEtohHywNTL0J1wnO+CCor3A6Szcsgo3ZiSjTpLuabu9YTmJYya8MwG/iaZs4XhA6E+Uv6lFabbQ+dbQ7ZBKVyv0UWF3vq7EpZlxX6FrZHiJ3TzQDeLpK37B806GMO8OR7izZUo9NahfuaFTBd+XhGB2+4QwArE5zb/Oi+wSVkZpeiAfBnbnAN23ecCguXdFj7/TI7Q+vYYgRbqBZy4HgwjBFCZ3kfVNo/kIU7veqvUVDwep/3QMMkIXm8+mB1qmcfNI29RnJyJaiqDC1u+hL3Zk5MYeLCB10rJYketVFGqtHJwzWgFwn+lnq/hiaXj9RLkS7DjG5xHRF9JwPWqBkff5YOuB3G59buBnAo/P+btdJPh4zmOz9BXy02H8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:38PM -0400, Tal Zussman wrote:
> Commit 84798514db50 ("mm: Remove swap_writepage() and
> shmem_writepage()") renamed swap_writepage() to swap_writeout().  Rename
> __swap_writepage(), which operates on a folio, to match its caller.
> Update a stale reference to swap_writepage() in swapfile.c as well.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looking at that commit, I can only guess that pageout() had an
influence on the swap_writeout() name.

However, on the read side of the page_io.c API, we're following
swap_read_folio* consistently.

[__]swap_write_folio* would seem more symmetrical?

[ At the risk of starting something, should the file itself be
  renamed? swap_rw.c or swap_io.c or something. ]

