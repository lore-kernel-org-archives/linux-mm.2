Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57866C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50CDB6B0092; Tue, 22 Sep 2026 02:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E48F6B00A4; Tue, 22 Sep 2026 02:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421AC6B00A6; Tue, 22 Sep 2026 02:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9906B00A4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:49:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C06380396
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:49:48 +0000 (UTC)
X-FDA: 85240472856.25.F19CFDE
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9C65DA0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:49:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=WtDu5JPB;
	spf=pass (imf15.hostedemail.com: domain of hsj0512@snu.ac.kr designates 74.125.227.170 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790059786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dt+xEJCMHk3Wb3Te/EW5gGwA4SLsGhrrMq07tSq9fOs=;
	b=KQfY7YIZSd2A6AxqhRFObBF2OKOAX1OPo+j+nvgC5vdqXg0vRZl4F4L030vNJClIjQF8++
	Sw85N5s7/89kugsuBk+l9XAD//chvGDxZ1xym4jPZnQRuB8ZqYrh2CXNgsX7tajpzVecEt
	g9cFxOjn2xkC5XKBPikyeEBS/gjjJU0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=WtDu5JPB;
	spf=pass (imf15.hostedemail.com: domain of hsj0512@snu.ac.kr designates 74.125.227.170 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790059786;
	b=u45X5jSaWkcU9Xd3C0ffes5LiD3yRQUBQHwfKzFLdqzyT5d2gVXSjg8xnCxJgRK6mUYCzG
	DaCDnvq2TgHmvW4lOTk6Iq0s/9VUDxl0FmTsLay0dQzNiFm+PdzYGv//+hRyH2YOQNQ3vy
	eITrYkz/vePoiJmbN8P5Gf4PXziHBDE=
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-39b5b07ec78so2615162a91.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1790059784; x=1790664584; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dt+xEJCMHk3Wb3Te/EW5gGwA4SLsGhrrMq07tSq9fOs=;
        b=WtDu5JPBLEYGw22j8qoOjUZWGguX8qWFBNh3Dp5wA3cCBGHk8kcoJWtk6slObsC8KB
         qPEtrWO3PknuXm7xyOXHFRGWbisKrNwTkHrQ52BIFQTf9P/Mcyql5SICne9jzRSYidwa
         6bbCwrbYNWObJ9OusIgpZWq8KdQcLx3/k2jT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790059784; x=1790664584;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dt+xEJCMHk3Wb3Te/EW5gGwA4SLsGhrrMq07tSq9fOs=;
        b=Pqe5mWfL7xf31KnHvSyZWYbDPVVhBQFIzkBT9H7Cnfn1hgPRQceK+GvSr4dec8H8LC
         CtDyqcycqULcv2yAGy9nS/f1AxvJVX06L6/pvKGWrTHWtuqYd71cgaDxy3zONcaP25hC
         qhPeJAzP0q4htqMq/OKUbYnu2ZccUxMUSKYH7rdM2jPp9bOVJuv1qJJ1mGxb4nnN7aIp
         2/XZM7iLMlvt5nY0hsvhTD41GLDVyax2bChAl9A34qmA5Ndoqm13OnuQLm24NOuoXh99
         vs55+QNcduQHtwJh59IQtNKKH2BDQrZozQ+pdv/5DXlKl8sELvAoEcQqgtTfPaiAO2jB
         XuzA==
X-Forwarded-Encrypted: i=1; AKwUvBxboijhKmwmB15lFm7tYrC5pkvZ2RKx6HdAPat9DGDQRw+dv7bCiIR+/htfPpZ8tzdOKOx/DAS+Mg==@kvack.org
X-Gm-Message-State: AFuF++kdswlll0vL79QwVMbJ3gmZg9JMC/Sp0yDMxmGM0zXj3hxvzqqS
	Rg0RQy+hUA9zhbJ/Nfx2Ue0/TcP/MDWLnf5g876OVhh2uRxrk0ujH5WzC7ImjoZZ4D4=
X-Gm-Gg: AYBFou0FM8bno2BK3SvXx+NL2y7n63Z6IbY/7Oe1eY3zJz2sjJef7Q1ld/yt0Fz62nB
	TqkKMBqZE1id4HHNX6Al7f2SquYgS5j58Kcgg4vtFvJ7jxvMtUQrUJEbiZtGZJw/+dsvryuXjXZ
	/yQgfcaX3ha2uAFZZqwSyMzFIxLrc6+7KWrGoOSFYQ1OgkkReYX1g9sHlWTApTYbysk1mscXyiW
	+AmtypJCcFuKMYP+R7SR0NINhMeYdUfG7XpZTkj5PNYZO+XQvDXc2P4iN2qizGXNRa4zJSNctth
	+Z+Dz8zzF0qCmoPqZsPRTVoDbvEnUkahm3072Eo9FEt9WgZEMxq5JHKUXqyrzl7xXJbady0Y7pE
	NOEE9E13b8Th9N6UbFjue96OIQkES0TJxi5d7ffQfm7Egj24B/X/E6eIN60uDyd/whGIByuYUyT
	R9znaGVn/udUqN8K+O2dmeTaLf0z4GGQfGkCcS9mvv7WMYW/oZwVZymqzop/YeF3EF
X-Received: by 2002:a17:90b:574e:b0:39e:4c81:6c61 with SMTP id 98e67ed59e1d1-3a073119e14mr213705a91.28.1790059784299;
        Mon, 21 Sep 2026 23:49:44 -0700 (PDT)
Received: from 1c1aead48890 ([49.142.45.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a067409854sm2985765a91.7.2026.09.21.23.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 23:49:43 -0700 (PDT)
Date: Tue, 22 Sep 2026 06:49:36 +0000
From: Seongjun Hong <hsj0512@snu.ac.kr>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Kieran Bingham <kbingham@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 09/13] scripts/gdb: mm.py: remove fallbacks for
 SECTION_HAS_MEM_MAP and SECTION_IS_EARLY
Message-ID: <54itd5fvuuqpwzc7nr4cvygcpfqh5tfizrt3oudnwjth7nwbs7@lk7pjhgoxmwc>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
 <20260921-b4-sparsemem_cleanups-v2-9-54d81d65e125@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-9-54d81d65e125@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C65DA0002
X-Stat-Signature: spnt1o1d47heefs6nzrqhc4hcadzfmfs
X-Rspam-User: 
X-HE-Tag: 1790059785-613938
X-HE-Meta: U2FsdGVkX18BE/KW3N+OKALoV8WEKX4Lwfo1ejX0GNFExOvyIAFd5VZDy2xr3meXE/UKX9JVVRopwLcjtWCOONNrWIwi04Tch84AJON1NWuHD3GedenvfQ+cX8Cti6+tIio6lCmiIqxXXbDCtL0+Qmf3BDCvOWLx9YK6HaPGl2e4z1592ETQYdG/YoubJjOYd1bosdqXhQbrj1U/nkUhTezBA7j2Uf4a5XwWm9ISQQI/M7pRKHdlmuVPTX1n6qYnBtMrrlU2Jz3jWFR7Ms7sOrFfMWMpi4luuehdTpV6Zu2O8M2axQxnqCcJgrpSn5XPOCswMqik4oIPuwKM9NK7JvFMFTt3Tpx8Nr7yNp1QH11JkC5MhDzi5HzSmVKuAZ/ONVQ+ZNR9brGQXMCmCOlGPt0QAz9vS6nlk2/RXWjm2VLRFJINWMqfPb8mCQFGqH94m0qZc8HLCPYe6kHMhmE+XT1h8yxBlGWHagxSHq3dtzyFqLl35h/ZLkuZb8MOh3U/uYtXhvIS6vvUyOehm3rmRoeFTGnJ2JvdFRUy4kMs2MUSLzaQaq6Yul8D2iXvMNqnzPRElyApfPlOlx0CiztD0PnVK9c9HXqeSLUWB2dgpxQYC9pqsFETGT5T8q836Gmf1iJC+ybWsEfTsPyBbfynFrsb5n0hpEqNR155ORwtRnxGrJIkFaRDaal+A4MH6XhHkKfyPqhzkqpB0TSmM6YvafHXXI4/+/Ka2LruUtaXndkAchYVBwBUE8XPkWRe+Iuif2XOhYx7fMu5UinHKPHRpyz/m/4VsyS9U35mdGRSXtpHmw5aLcYpT8sUV7i5DLTs1+F/lfuN92qned2p3zcNELhxEA+pm9G+x4doQ6Aov6EJub5FuVMLIu4Hb2tNVAXiafdc+wBldraa/51QzvxZH0cp85AaG54xiq2udnbo8t2yNsmoWyOOjfvuBVBlTbPzP8wyEjiFCYCX4+3Egtl
 OctdeRPn
 E48a8q3QHV9lKzpo/WPI7VWddhf5tf6e8J8zlr0zR4doVje0aMONs7P1FFYNneINXgfxRF5i9lk7HzKcKPyY/6q8ng5MSo81HcajFpTEb2yxsnEvm76B63jzOrWn/JqNQaCp22zeAJ4pUVsuZHmlhg3zCNIIy9dmX3l8kcOFv3E8a2imDYOMJbTI2TA5q8rGE0W0W+O8lK0YRgtEb7yVqEB9V1v7nSz64lNPoG6447qWYjwfdz8CIqe21TqXRAzD2ViX6iyv6PS4Ztz3xnZwd3+e/BP+eZPVeU+tNUSt8sS9I8kl78pRifENqK1ld4uguidRIe1jjgIiWEzpy9iVueIF75Nkm3C+UTF4TCdRqV4vwbCf0DPYd/q4t3xpw0UYuq6VYl0UN8QmjDD5Fi1WjM/tTMl71xI0H1KdleTvmaR9OicQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 09:59:01PM +0200, David Hildenbrand (Arm) wrote:
> There is no reason to handle the absence of the corresponding BIT
> values. So let's remove the fallbacks.
> 
> Link: https://lore.kernel.org/r/vpz5zqg5nwbpolxbkip45vxxdt3lni7j2haal7q42skc3b57tu@uh4cec4x32dq
> Cc: Seongjun Hong <hsj0512@snu.ac.kr>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  scripts/gdb/linux/mm.py | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/scripts/gdb/linux/mm.py b/scripts/gdb/linux/mm.py
> index 193a88d763abf..7398105ff3f67 100644
> --- a/scripts/gdb/linux/mm.py
> +++ b/scripts/gdb/linux/mm.py
> @@ -71,12 +71,8 @@ class x86_page_ops():
>  
>          self.NR_SECTION_ROOTS = DIV_ROUND_UP(self.NR_MEM_SECTIONS, self.SECTIONS_PER_ROOT)
>  
> -        try:
> -            self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
> -            self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
> -        except:
> -            self.SECTION_HAS_MEM_MAP = 1 << 0
> -            self.SECTION_IS_EARLY = 1 << 3
> +        self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
> +        self.SECTION_IS_EARLY = 1 << int(gdb.parse_and_eval('SECTION_IS_EARLY_BIT'))
>  
>          self.SUBSECTION_SHIFT = 21
>          self.PAGES_PER_SUBSECTION = 1 << (self.SUBSECTION_SHIFT - self.PAGE_SHIFT)
> 
> -- 
> 2.43.0

It looks nice.
Thanks! :)

-- 
Best regards,
Seongjun Hong

