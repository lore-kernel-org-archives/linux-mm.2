Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D30BCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1111800C0; Mon, 27 Oct 2025 19:33:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1C28009B; Mon, 27 Oct 2025 19:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB084800C0; Mon, 27 Oct 2025 19:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A2B1C8009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:33:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40AB7C0273
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:33:04 +0000 (UTC)
X-FDA: 84045497088.20.7DCFBB4
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5CEAF12000C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:33:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="ZFQyD/74";
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607982; a=rsa-sha256;
	cv=none;
	b=mEiWgf++qt81yha7UFE0ivDrs7n2iQOUywKKNkgXQ8DYioBfGYOfXU9LLMDKQK/NL2bcUm
	PeJvQaukp2HhLwIRVxnADY8mjwitf92G/kCzSCq9FFPF5InASIWEtl2w0DOjQOGNxclZ+7
	xIuLQxcNJBjq4JA4xZIcTLKioPgEOWM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="ZFQyD/74";
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SeBkBGZ09M3QB76OpujQtXgjWBBtrpYzqcpEmFvCTi4=;
	b=jE0f9u7zFfvIdVZdRL+Kg1BJZr/5QmWYpajpX4EtO7OTqaXgV6abYB+ltXLoZDmvzIRg13
	3Lrt0Q5NVLbrpIIiOSvZqxcaCh1OC+g8ZaUQbh6j2B3dp8s9HnUBsYw4kVCMml5/w/osAo
	wYGSyuqgN+oOMOqqC0ikl5nuFYTfibs=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-87d8fa51993so61848706d6.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761607981; x=1762212781; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SeBkBGZ09M3QB76OpujQtXgjWBBtrpYzqcpEmFvCTi4=;
        b=ZFQyD/749pZ87cwpl0JVqAhXJEjQESEnooYwonwyjYVf6ILXhVJF7PjbU6A8Y+Kfuh
         760/MIEgB1NzAYbtSLRhx2Lk8o9l9LP0+hlL+qyNoMg+IzJH1bfV6Ya7D9CWppdVBJnh
         Pq+qtpDMxEXM+nsUCfQTT1JYbQp9rQ+mbSWliEbptc+5cffPuvWCrQm7BeplL+CUvYyR
         n5HAu0cvnDGkpYTia5DHGyDmYJNvGmEXwjLwxVJswQvd8PrKyUBaAGL2+xTMrg7AW/hQ
         AqRfTMI0AYCDPDCyU0w/CvGTyJ5gniFJow+T7BaAgOUnxJ6Zx2mr2UtETEk6DCCbIEHs
         cnoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607981; x=1762212781;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SeBkBGZ09M3QB76OpujQtXgjWBBtrpYzqcpEmFvCTi4=;
        b=Z+eEzCrqA2MpCu6b8HCz2HiG6Ib+03QtddMu3nDjJ4Chwa4orOEHVPNLJKVPNVsyE9
         zcguqAhQVg/zMH419pwgXS0bXlqdDZ51nbzE3P1658VNfUI1WB+KTeYPtWlO5Xv/kQVQ
         ogcg0/6a4EWH6GYVlm/BEAF18yKyOg8zDslKX/PUKZI8Llr7FA0Y7AKV2quzIfvK9aPz
         4iyz2RtqRqD0YdVa03ItT3He+jaESw5vZktexm1e8efCkPKZ5QHj8gKj5mfXq4tk2+AQ
         4RZOn9327L4Uf+0GuEooJxWCwP8NUntCOrbLmR2TUU+jt6T+yDgc6mBfaTxMTUeoB66N
         XzEA==
X-Forwarded-Encrypted: i=1; AJvYcCVyZKs4m986IqSwSy14O8SqHoHCbuZjYfL+kWYEHE7T4fDl1/gjDzhXUbzcMB6lGS7kgaloOFQxag==@kvack.org
X-Gm-Message-State: AOJu0Yw+rLCXah5Qty55/7B+ao63juibV6amtdO2y1Keys2yBBQfWTeL
	VCg8r/nbHrMmxhEBDsCfje82HQuia2AqE1jq5+76CIs46LCBjtpK4ddaMZkurfB6ZI4=
X-Gm-Gg: ASbGncsqCQFTvWwPoHyjbt+E457tApngDEQvEkpBsD00P6DQLCAm7tnNJWK5acpNzd3
	cYc4UZ5HBA0c9r1+DhSgSZyGMf5JNJM1nSarzX7wCeO2AFKcj7ZRmNogIcMuArRH5J+FPeo38ay
	oBghXlmNbIF4ZN29eWfsDVUuJeOVKIyxjSBmmuEg2of0tFOwqpt9fY3Q4zWvp+kGSBPWBmS3gx+
	cu50gePc8FuTyMDtZJBc4kAGF1/0J9OQLJsNSBMq+LMRqpJgq6zSUeHc9tzNZ2CAB8ZEVHicZgd
	pD5W7MRX4avBf7mC9wcQFnsMGmS7zf2DeurZjPrgBuhwLz2QtMuDpolRadLG2aqVUGfmT/zV7+w
	2l/M5l131EPJJ5McbGmpONp+sXwYbb9OZlQmruLUrSOfgFpeRvFqje6CwUKMBTkmcTwsCA8TfS0
	CmqK/jAyqbeMm4qsjY9TxyMYWTuq3dG2h37hhU5/wQ/wuH0PH2ZzBv8CWu/oM=
X-Google-Smtp-Source: AGHT+IGY0mnN3CFDP7vaLRad7aeAt7RbVIUmDhfxoFPsiCMHR/zS0q6YLuuynQuqtuF/1igQEZd8Tg==
X-Received: by 2002:ad4:5cad:0:b0:87c:2b03:c776 with SMTP id 6a1803df08f44-87ffb0f3094mr20891046d6.47.1761607981318;
        Mon, 27 Oct 2025 16:33:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48ea92fsm64277606d6.24.2025.10.27.16.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 16:33:00 -0700 (PDT)
Date: Mon, 27 Oct 2025 19:32:58 -0400
From: Gregory Price <gourry@gourry.net>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/12] remove is_swap_[pte, pmd]() + non-swap
 confusion
Message-ID: <aQABKgQYfVkO7n9m@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <20251027160923.GF760669@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027160923.GF760669@ziepe.ca>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5CEAF12000C
X-Stat-Signature: unrsq5sct9d85fkr36745szkmbageu8h
X-HE-Tag: 1761607982-495465
X-HE-Meta: U2FsdGVkX1+ctQ+NpCA3CDAgcCyQOGEu2+xvVJ/3ptdrVl4/Ppuldgiref7W7Jdf1ij6K/a4BPVAa3K3/8I9BpnaWzN0jBT62iEwj3e1xa6KdYcQrpeRlYefIPuHa3Kv4kb+dPwhiSLO0oXGRx3pzC1fMb13yj8VHKJaRsi6cZxZJ5zoOEYm3PCSAvtuqXPMG/HNYW36iO0X6KVw9GXoMne0LjgJgmWohEmRdVSUBNyAIB/zYTTh2A8iz7wcNuf9odsWp/8ZInVAWRMFFqLrE4huq6eH/J5dgKMWz9O02lcdSdPOEisBRCc673iKcajvG9x04LpI3CicB/xFI8NxfNOuRepmf7S6r+zcS0EukXT2Iav2KxZxCc+egzZzpHyDG7tGvgZEC06qhCwgEjkXRwWcNum2xJek3CoEaEpWrhiyAJQruU4FHcd0rlC9mC9gxuVHXstsAtjvYxiB10EznLqiEAZra4JfjSmaJWTCbQWqcGbmwbGgXobGZOUVpezsIdE9fpHTsL4AtJHLu/KGR4rWfhpoLXBwgnszcpmbDw768gXz8X+bP+SrouyFzKwAJqdxfI05+DJaXXpxOM0gVlTEZVoKNfgdrxjyxGILKIqghXbJkMJNHKCB2erCLwcM5hXpp9QWdy+AWQBtXjVbvBSehWAhqHxbyUgqHZe1Eb8AyYDvAzJQ8oaHj20mfpMfpLGVwuwAphsmebSDQGOOSMVOc5cF9Vq+Z9CIGXJRkIvbf6ack5NSZN3QClLF9AzmK4XjIWh2BnrQfYV9ewJrMF4hprOEdSF/uX7wmzfV0VxYMFuNQhcKUwFGNpzVSaf52zkLYH+3kGrnTIFiFhLk894xxuPV6TZYNdGQE/gypyeFVKKETB079Tz1QPuydFQDuBW5PX16HF5p5zN35NDT7QLeM1TE+J9KT934HeVfx7pPKKuGaSn3+LM1tERdLjos0pjvxM4k7HmPoc+tlFu
 6o22zSjl
 qiU1+WmFKaq1vlGC0IIS0bQ0edFZHYg6sdN6v/aderWRIkYLGP8sz4eQE+8JpaaArVCWNVQeJZreA7GwFcQbxEmJxgOvijgpdONJJ2DN3hMfvBPD0jhZ9oM/uXE/7FmhqCKKa6nFTzYLBXnS6wdQZCNk+lU5er2r928nQuOkUk+e1wmM0MuB6JQHqm4WgmmJ+GR8KUxPXreDb0I0maN6GATT6ZAm8OOUzdECN2U03UhZqxLPfUPfER9Fy2gRc0RMgizNYcjNjzUFnCsgJShJLFFpFjXzZPt7RjUqpkVxA4sLShp/qQDqBINFQs3ztU0lSNyrg5QfOEbOSVX0jReohT12ml0cMI4JTljkZi8GQxzSBQqYwXHoRqVUYsuy5r/4GWwGsuhnvZHwWc8mpAF0Q/bWrPi2RwogmF9bmX+dizsRPL0GYdatfwScnSsLwChYryrDD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 01:09:23PM -0300, Jason Gunthorpe wrote:
> 
> I'm not keen on is_non_present_entry(), it seems confusing again.
> 

The confusion stems from `present` referring to the state of the hardware
PTE bits, instead of referring to the state of the entry.

But even if we're stuck with "non-present entry", it's still infinitely
more understandable (and teachable) than "non_swap_swap_entry".

So even if we never get to the point of replacing swp_entry_t, this is a
clear and obvious improvement.
~Gregory

