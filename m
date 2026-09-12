Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 124A9C88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 22:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8EE6B008C; Sat, 12 Sep 2026 18:07:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A766B00BF; Sat, 12 Sep 2026 18:07:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758E56B00CD; Sat, 12 Sep 2026 18:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0DA6B008C
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 18:07:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28B9316058A
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 22:07:26 +0000 (UTC)
X-FDA: 85206497292.21.A6A4136
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf27.hostedemail.com (Postfix) with ESMTP id 65AE540008
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 22:07:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fiaJcs+n;
	spf=pass (imf27.hostedemail.com: domain of hughd@google.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789250844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rv9y+bdGfrIVxvXFR+/Wb3gMq5lM5A+QpTE+pSCVxcc=;
	b=MvIr8SEPJ4gcIiCfOEn6FcaqHV+iCUhpwb10zWw/mzxeqeMeaAg8SO15D+MGAUrNzMsh6s
	fT87hKg4LpgFCZXFTKftbpZDo/3DY7ymKJNJBpjoMBi6lyu6oiR+q3FqnvVItrgamlih1H
	7LLbd+5a7+D8UkKhXHQgPdJ8TbLM70k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fiaJcs+n;
	spf=pass (imf27.hostedemail.com: domain of hughd@google.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789250844;
	b=Uttn2G2iPDUkKKBlzi2fGydxV44ziM1CKhMHeYJ0MzfBHTxG2XB+2GTkc473baK+xZ3hGT
	PK0l/Ow6S0LFZsA989++b+bIU+YZmkEWKeFQz+NczIGfk4Hv/FjWOq+NYfcElmEQi4raMV
	3t5H7yWSudneji5AGdefu5bYQiKRMXY=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843378fb37so301250f8f.3
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789250843; x=1789855643; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rv9y+bdGfrIVxvXFR+/Wb3gMq5lM5A+QpTE+pSCVxcc=;
        b=fiaJcs+nmRXQ/LIMdlqO8YRI5rvXD6sitIsIEZ10la3Tz/vVwSuZa4kFf/JiiRShw/
         gwMK8L0GSxEs3SpqbU/i37PASd7xEGJ/VbNjIrzijT/GGG2WNyMzA8wZeyuKdZU7OICD
         hd0fx/WZtpoHMp29kCsNdsFY6I3e+3JGlz4eDu3rPFsq4dyIyBVTeAxAGidjs0Fs3qMU
         vBwp7UbOQvIRPRJHhwYHAJYIM+No5hJq8UnjKyTEP7xdFzwr7BMAJHULq62JMrpNKpb/
         zgT73i9Wmy4pmoCM7I3fJo1LsKjUAOhZkcnz/LXd2Vg/uRZi/s8ZQx93JagTSfjtfUO9
         wLvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789250843; x=1789855643;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rv9y+bdGfrIVxvXFR+/Wb3gMq5lM5A+QpTE+pSCVxcc=;
        b=D2ZnNgnFbLpUjlB8qd7aL4MVeQa3ipqxQNoKxwH/XZ/SxKJF5gn8xUah4UbQdj5cEc
         KyX8eE/W9zC4w3Zlv3blaYIZOOyvRbrtjUHnHQX5jyKOf8ZsuUIOx7NvQbY9p00r2dyM
         YdywneNGWN+Kc8RCx2BfTkMY39jnyMdP6xXeg6RXpQlfWylwvmNcIzq5VxISzNcckQ+9
         YoR/WCNsYAan/aojXGttpQmdKbqMEySnOB+8NSUKxAukvx3rw3cvqQGsI4Gq4UrHrA3E
         7F8S8xNp0kCMA/Dwu2pCRRXZ2hfQgpbhbjsd+Lq0xEKc7Cjl90wPC5km/M5a9BaPlRrO
         e0Xg==
X-Forwarded-Encrypted: i=1; AKwUvBzEl3sHS8WrxAM0zSOhjkH+zwwjGTDErbib6H4UDCx7k/VOG1/OKb4Dj5OdczLlVpElg0Bpx6+bgQ==@kvack.org
X-Gm-Message-State: AFuF++mfObZJRRRgDQQOBcACMkTDUjbhrJgdvBBNz8P2amIigxmp3LNt
	Of1rIzCtlOIB03v2dxKmHJmQjv/KFS0xMjQsQCyXib3/mUikpJhtlBki5OLhqF4KRw==
X-Gm-Gg: AYBFou21N6dPjRDqcXZmi+rchD1Wx7CJcKRhcoBfFIynFno3qJOu12+cjtBkSJNXItU
	Awb+Cr0kDo/ba1JtgT9rHRQakjgykDl3zdJZMHta+UL0lxvhhZbWTDRcOssaUocOuzne7/+sqwe
	s51MNRol/sAmmGvp18BEMlT75vkK3tck5CQoPd5BDBEwNBHiHfjodaMgtXDWIpMEXpYFHAYf6JA
	xYr2QZC1+XQIXhmvygc2wyQzytjYMhbYb+v88tAQo9zyO5HlDWRPvYi3B0+nwp9lddxwWq0tnDz
	nox1dxIV8Zle0gBa7Z/E/8rsBIIZ9hS+k9EiedawITZEHez4mW0g9yjlKjD/CG7TvgBdVXG0eqi
	SgxXX33fEkHdOgqkMRuNO/xKdoYXUeAmlOm48CJDDGrPhtL9avaIcN9mz8+LM9f76CY2BKfgN4Z
	+Z+edeC1DDpyWE+Kzt+L3FVa5q0wJ8qP61gblHCIFwHOxcldB+lRfJmpsNKJTDyeARQnq9Yslwr
	MEE9Tu13AQxycWWWCzY
X-Received: by 2002:a05:6000:2f8a:b0:486:e920:6726 with SMTP id ffacd0b85a97d-486f6d5956dmr4081301f8f.51.1789250842159;
        Sat, 12 Sep 2026 15:07:22 -0700 (PDT)
Received: from darker.lan (104.157.125.91.dyn.plus.net. [91.125.157.104])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb33ee5csm15513089f8f.20.2026.09.12.15.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 15:07:20 -0700 (PDT)
Date: Sat, 12 Sep 2026 15:07:18 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 06/26] mm/fbatch: fbatch_drain_lazyfree(onstack fbatch)
 before ptl unlock
In-Reply-To: <ac4fedf1-168f-4166-8059-353f2cbf04ae@kernel.org>
Message-ID: <9ca87753-6851-7b54-4305-75d5319b069d@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com> <17e1a6c3-525b-1cc3-0731-349f0850e3ea@google.com> <ac4fedf1-168f-4166-8059-353f2cbf04ae@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: gn9f4zi7mgjpbfccyfdmgbhmz1mzqohw
X-Rspamd-Queue-Id: 65AE540008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789250844-986499
X-HE-Meta: U2FsdGVkX19Ic8s4QH1aHP/0mmi2RzY2W894v2ykcaR7frgkJEkqZTj1hRJYk8NsL0GHS97J54rNYHOtbmf7kwpomKB/eP02t/KzDgGKBEiT/JxlcbiOaxNE7tls6V24d7S5TaTk/009iRsjjmGyeKA6bPnGto9EeUfivDuv12RAifYAdh8Cpdr2KYHmWY4PCmZTNJndcRhxDbzC9KxhCdwNsnH/GG3Kp0sPe8zA4DxSsS5f2cGesiX/Hw7NkLahXHPNj+EQ+BYGDaLaBHyALFwov0CML0Zu/GBXAxWBm9qStz1yK11SWPGu07cfo9RaPsS0pA3BmhFeWfgRsZy/afmMmbLg+ohszDY5tY+8WGMS3ZpRugSIojXC+EvzawlkiMFkwWOnR85IYafUiUKFmgmXTkHAz8feZVsmrJS/5sMTikYVhFnVVD8m8vMRl0xsSDLlnpnY7EwNI6MNL/OjSTEtW2kQjzM8VDpRe3nXwjzMF+5VhFbjpjhATisin0rhmL2HQuCp1UbvBU8wB7VHeu8xLy7a9wkJ2LrTHoVzZQfL9CENLOZ6j+i39oaHTax2hTYpNXLDcj/mroQkGhA4/l/WU5BT343VtbStSiIxD2TzA8uSu1TrAW5FLIrVIZcyiohzhHyk/19N6zowGRQCozSnRQjOtGhOUGV2JiyYcd50qPqPr9cEev++O3y+8jaf5nOMGgP93IHakuZoDcXG+qbcgZoR63oUdDSH/NB0XiZlO+S4wxDGrSEvvfNwdLwmKburs0+q+DRsc20UvkXJey2zWJC7u1/ZQ1E+QkF2OCzQ3IZbFV169nXf1qqjQlvi9JBjU5wy+ilDCNRO34a1vgDQqv6hGRDHhKhe4Iq5k1Qchrsqo9EJyvxSXE9V4A1sSQVPQ0G3W/MqgpZMydCNZIAZl7+ictCLMF+RfsCH6KTG/7oiT3MiG3w4UCrF4l/gIn8zSGSFEJWbSD7y8f+
 g/AJOJI6
 Tk1dQiwHMb4qpqou1cqJvaUtIyqd1/jA4Tcl9Od1NeLY++SEKHFdRiuJcLo9LpkkhdpzEUtkdDhqpPncz1mYgLmBUcvhoqJcvei1e2IaGvAI29ZsdgkdpgyDiqJyLQUrgaSPx8Cx07BOkTdlkHs4WwMJ5cYGZHEXefxUh6DttFHTfb6HGpqxChhZyv7iMc66p+xUAQxxG6rOLAWE7zXiNAPhunFTAnynXixn2b79GRd53Uaei90s17hM0n3Tmiunx+cvnBXGUiSA3g0rL+IJoKaP+x3wsazavwY9dauIdM97/2LmohQA/0bSjxOu9AaJNd/egBmP6eofBsU5BdHXefvYI0BF7uaXypxDSvaqO+lcydXNuDxPriPSWJ8edU9F3/bz1BloRUdZlu6YfMTZ5afBeOibHJpSIOS9ETS4vlKLQQw/EmMVlcqvjzRiacYSS7ZJOtew5+lswNCqQB8aCD7IyfhRmntnUI3rLXnQEwidnbpU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 9 Sep 2026, Vlastimil Babka (SUSE) wrote:
> On 9/9/26 11:53, Hugh Dickins wrote:
> > Re-enable lazyfree batching for MADV_FREE. But it's not safe now to leave
> > potentially stale (then reused) folios in a per-cpu fbatch for lazyfree.
> > Instead, madvise_free_pte_range() keep an fbatch on its stack, and drain
> > it each time before dropping pagetable lock, while the folios are secure.
> > 
> > Ignore folio_may_be_lru_cached() and lru_cache_disabled(): limitations
> > irrelevant to this fbatch drained under spinlock (even if RT); though
> > in practice madvise_free_huge_pmd() does have to drain every time.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> 
> It seems correct to me, so:
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks.

> 
> Might be that something regresses performance though. Guess we'll see.
> 
> Also seems to me that if this patch was preparatory, the batching wouldn't
> have to be temporarily disabled. Doesn't matter ultimately though.

That's true, the order of patches does rather reflect the order in
which I got to think about things - but I thought it might be easiest
to review in this way too. I was anxious to get to the core patch (04/26)
as quickly as possible, to find out whether the idea would fly at all;
I could see lazyfree was a problem, but wanted to put off its solution.

Hugh

