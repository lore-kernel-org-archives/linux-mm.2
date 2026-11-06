Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5E4606D811
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dOnm9spY
Received: by kanga.kvack.org (Postfix)
	id 6EC156B05B3; Fri,  6 Nov 2026 04:56:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69DCD6B05B6; Fri,  6 Nov 2026 04:56:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58B9C6B05BA; Fri,  6 Nov 2026 04:56:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2C46B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:56:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F889C0CE5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:56:19 +0000 (UTC)
X-FDA: 85404238878.03.9802E3D
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 394E840005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:56:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dOnm9spY;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793958977;
	b=O0Zcn3lbA8Xw2IZlNs0J97lbPDZ8t8L/D2a+aYfQutOUUi35fOiVuLommTWiZY6kK9id9D
	KZ4/byAn3SFUim44gfVBl4QctNyJTAT32P94ztT4Vmk/mM23qcC4h1JJvLEMjKfyUa+wRU
	T1x2NnhW5Ezj2rufBfWYTn1W78VNGbw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dOnm9spY;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793958977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVNqNcKixHGsvQRk+aF9Z3pXurarEsFSJxJzB1XGyf0=;
	b=GZDWMKTHYNlASPLapwx6rtDWw2ZpqS7HYG3sgdDyGUp61mnFydJPlcQSirU0D5A8eOczNh
	oN/wUDY7pBZ//bvb43cjrAxvFboRYpbQNTtNEqYrf9FYRu+82kFLR4oFBBEgu8JOmT7OQB
	2nf3ZWtKoMEBWVe4P1RNddgVylD2UH0=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-491846221ffso365211f8f.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 01:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793958976; x=1794563776; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PVNqNcKixHGsvQRk+aF9Z3pXurarEsFSJxJzB1XGyf0=;
        b=dOnm9spYQArlMtZ3SEfE3xLOyIvxY2MKG1r/k/36SuG+FnSwGZBivHpi7Nzqn3XMtN
         2pzyGVCnzJEx8bY+SZF46y3BxrRQsSBeKrqdStlOGaaRBDT6cKwwZoO3sNIGO/pXj6Xu
         W3Ht99hlTHVGnzoKfKeh/9capjKT3/i0Swxtz11XB1C6vJG2qwm0SZwvTittF/lSTyIE
         A5H2qSR5s4h7UYfyYRfqkSy51G89QoiECIxSzco1Nggzc9Zp7tZ8Np6fyiWoNyYp1GDR
         akTg4pane407G+glN+h+tbUHaiwsd9hDcVUC6S1xR7Udo441V1p+5XJCXap67LTYIkJc
         L3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793958976; x=1794563776;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PVNqNcKixHGsvQRk+aF9Z3pXurarEsFSJxJzB1XGyf0=;
        b=Q4O55jFx3HHvXHKH2Ja4qvKHpChzOLH89Foh0nk4xWnb5u1aS9nQ/Be819mntTHrkY
         Y/fGSlKOUrJsoOuTPt3plyygF/BgEfYHtfUjsIhpCx7vbUuf/PAuOen399Mwmf69SLWV
         7xe5fI0G1Br/yDWDko6N9j5BH4LnK21pIbnH5KRCdxaEfXE4fXXZSujSNfRYdFzeisYY
         +k1GDabrX3uIwRjVyqrPuk4I4YgoPMH8h/gI+Nzttw8jRt3fz/KJUxvWCXHVcaYGy131
         aWM3TU20yr4S96HT2nDiw4T+nvjh/fVYePR2CK4JESmxL+SQ9JOnVSyCE1mhKQW57SjF
         W8eg==
X-Gm-Message-State: APuU4Z+015f109n63652lrsgvr/eoSQoMMfrSUDGDCMxHRh05jF7qR6p
	6jdmOyLbDaoJhG0sgdxBkOite59AruKj2rc+bRgTg7+nHe6BAHPqWY6h
X-Gm-Gg: AYBFou2ur2iC7CRJe50oIPU7jC+s1BLFLYz++lYR2HTby6u3lLmgmNzjT7Ezl4eY1Ic
	I0Fr6nbwPcQ2KXyUCks+P3+6AxgTVwRExqTIb5fW3YCuvEY1uyWYcvMMkEty52+XEuqt1fxtYiJ
	4QP7qgHl/vMVxIEpiyPAVOa2enU+EXzFF7jL6xEIFeTpl7OtWIu89vHx/faLnGTLBkAuMa9f9c9
	s/ox2ph7WSNIxMZGZNTv761fV5WlxZLxm2fV+XVrtDcbQeQ6/9gFzYV1e4pbVINqSEUCo5gzfqM
	qCakzVmMO4n3EuGifcTnAotpsOOySpnX6vsse0BKBC/yBfoN1zcH6WbQZTpMTtIe92YgK6zxkby
	Lq/96dpJk7b7KcW2fm1mEifH4BQtNlafsBIU179OCxQAxuojvk2tZBgirzTPlJ8JOa8MIzPYazG
	a/u63tK4d+0HvJ3e3T4NNFCgeE3juQpjuBJixkfAAyBIvaw3qeWB7DMa94f9rvGAu7MDfonGfY8
	tMqej7S0NQSxC2GpG52sZSl4/3nmdI6/4eQXNWxUtTXINGRXySEk1hx1Jm/7ZikMJRUgsTlv5wr
	TWy2ID9+1OWuLFcYB8QR8DI=
X-Received: by 2002:a05:6000:26d3:b0:48e:6159:8274 with SMTP id ffacd0b85a97d-492765a3e9emr3874962f8f.27.1793958975594;
        Fri, 06 Nov 2026 01:56:15 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-492d7dbb0d4sm2752385f8f.50.2026.11.06.01.56.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 01:56:15 -0800 (PST)
Message-ID: <e3e15340-d6c0-479b-867f-e5eeac1e0e2c@gmail.com>
Date: Fri, 6 Nov 2026 10:56:11 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm/mmu_gather: flush pending references early before
 the folio limit
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 iommu@lists.linux.dev, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-3-70b9c655da3e@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261105-refcount_overflow_stable-v1-3-70b9c655da3e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3emzc5mqnd8dauh49bssq38z4yr1p74k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 394E840005
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793958977-867469
X-HE-Meta: U2FsdGVkX1+buF5gT8kf/1eCYvHDhY39JCzLerPKcRW4rzZWGSNvGby2uhQjtg47F/8GgpJELzX5CdSTVbWjbso5K3iSSKQ0Q2V5X11iYynajDKCGF2ggQj/0P2dIW2R189cTFY+d5ucE+u3TqYN+/KhHHoj1R5CCQxO86U3GXIw0wu6AP+P6in9D3kIbbUDNUJWeI3cqsnixgYps94vZ2aM4bmwDH0AS+Z5dND1kRKMlRYq9JwQLxb78NS3jlcgbFMND7i2xMiQJ7PueRU48vahWpUldWPou9zD1Bw4eZ/3z8CaaiDnteRB3W5yvtIqSorqYmFlq4Sb4pxQUP02IKj7dlmDh99OYawHDZR97U430uZUteTuvNoIvCOjogDMTYlzN9z26mdglHY0BeMZ+fYNxF0nKVd9ceDxZUG04c3+evdlTMnee296B3qByYpzWRxXUCtCLKUXPOKFwr7bIgyiURxBRFl8l2eS9GCrwWmNumdl57nqnR1fDFL+haDE5vEagZQjNAeIkVKP7+2RwxGEZ16/PrYFtc3qfjdpvHe6WBI7u0YTPW8o29sC+5iTX56La/bwigT06mHx4i9cWh6EARyH9U1fNVtcDr4Goaz+gRsBVvWjlmoYpylqUNricbRunoupX375WIxWymAsRL5am/H3mm3vlJRG/XGxjZiaxdKywS9TKMUNgGUa+EIk/4Uy6ibEp1jz+sI+Kry6icWsPmI/3AWaU1dx2ZHXZ/+hjvIlbAQxkmGjKeAqwF5e2F5FpU/gZYmQKMIR8KEHQusmnvA3q87TZbpFfwEwzgPh+JmfqvxOw9vk1wZ5jW95IFkc7zTgwSPCViThq1DL8Qw98VfeyKwD4btt90+0wjoaXX5qik7ORUeTWWeQ1Qw5hLQzWbPvzjFtOGL5lWPYIumy1yGygNjGqpy1v8nwXU1N/TVYnNinNNe8NtxuJnad9h9Sme++wsTwrLZRFd5
 moaeHl8h
 p2JRGHiK38QO+Tm/0dUKs8TiOZLk1Aak8ma8Cfaz9Ug4y11tscAZLC8OUmj3QBcxbFSyGS8d0ABXR7gilFx2NgN3TJLuf2BhH9JCbZV2REAADEmOcObJ02Huo1c/GeJhkR2F0D43PAqOzn3e86/BBhXGtIugQeyrbmPadZkrw7Qg57Z+qrR+H78H2Owl9Y4lZT57xF1Chxh/3fiLHlsXARHf64wKYbd6sBhfyxJTTt8UDh/TmMUhjGWdCKTVUIqxWKNggvX5t0pXQD5vFmVFHxPnmR5sETd3p+vly4jzeWJgFpeLNMmM1+8U2W56gdAMFSfYCGU/Hl83+N25Pp+mYTtVkn4muyUubDK7bPqrKzQTOyhYkdCWalC+WUfoS0C6bbVG3M1EOYf5A/Bo+CtTyKErv+1wyflfHbpLYiw5065aTRvFUkrZylefL0EplHO0DSIiUWpXv2ns/uigde3dUayALYdjG56BTtGq6Hbmwsm7hhm/LnSORQfWC+8IjfevedCNhJLUxVZyetNOZ5/eEOKAtLjhm7JQZBs3WqJQLBWDdNlihmrdALgX3ag3AbK7DfK25rqk4g5Fu7JrX25qpav2LzBg94tFfzNLgowfPAdgtUao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 2:10 PM, David Hildenbrand (Arm) wrote:
> When a task zaps mappings (e.g., MADV_DONTNEED), it can drop the PT lock
> and defer dropping the folio references. In the meantime, page faults
> can refault pagecache folios, creating more references for the same
> folios.
> 
> Let's just request a flush after enqueueing a pagecache folio whose
> refcount reached a certain threshold. Start flushing well before new
> references are refused, regardless of the caller's privileges.
> 
> This is a temporary measure until we have something better.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 10ebac4f95e7 ("mm/memory: optimize unmap/zap with PTE-mapped THP")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

