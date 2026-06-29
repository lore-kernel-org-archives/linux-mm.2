Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08867C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 20:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97026B00A4; Mon, 29 Jun 2026 16:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6EAB6B00F1; Mon, 29 Jun 2026 16:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E6F6B0102; Mon, 29 Jun 2026 16:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86A4D6B00A4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:44:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 07F2E1A028A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:44:27 +0000 (UTC)
X-FDA: 84934128174.03.B1A045D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id B0A6E100009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:44:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XmAyMmMw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782765864;
	b=lf2XXWQ9SlzPSh6CkaaLzTdSGwhL1nkAKqJp863q9G7iGWPQ4ivvDvXJe9sOX1LlEoLpOX
	EHNdJ8roVtZfRClyycbUXeeUy18yF/v8oZpTIRh3ttx4YdI1MoxK/Kx0WwzsUx/94FRWSH
	t3zJu0JTeto5NSsDWQmU0peFLLkJ6xQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782765864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOQpLe5g2es+HuSRD8vnoaoM9ObrVUNQWd1XrTtB+E4=;
	b=ALuRc5Q5DWRJruTtgcWeJyswWMy5+GtNiIElCXxt9KeaiuV+D2lx5OdjeN95QxcQmaSX+j
	UroljZOXmjJPk4XxEGHTktR3FIFUzOa61MuHQ9xZqum9xHAPuwcn4+JLUlTGZiBipbmsIo
	T1bFwkDVp5tIFh6954ue+/z7hL6p/iA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XmAyMmMw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782765864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TOQpLe5g2es+HuSRD8vnoaoM9ObrVUNQWd1XrTtB+E4=;
	b=XmAyMmMwmftSK49Agi47OtWX5GZNhuw9l6LW1rjMEa2OwC2biKy2S2MgT337avMjg2md1Q
	/cF/zPPWGsZhPcO1fbhfw+J02HOtkB9TEuVHA9smdE6+YAlValOUS63tmp6Tq62+sJGvE0
	DD30B9PZ3OAdl/qUK3b0tvJPYMEHxmc=
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com
 [74.125.82.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-8rcL4LptOseAkGkGgJvngw-1; Mon, 29 Jun 2026 16:44:22 -0400
X-MC-Unique: 8rcL4LptOseAkGkGgJvngw-1
X-Mimecast-MFC-AGG-ID: 8rcL4LptOseAkGkGgJvngw_1782765862
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30b877ee493so5718471eec.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:44:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782765862; x=1783370662;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TOQpLe5g2es+HuSRD8vnoaoM9ObrVUNQWd1XrTtB+E4=;
        b=fMHnDvFjQi+qKLPg0JFc7NW4etuORdICvVfbJq+0WiisQSyKGISt+qAMqFCHQCEJrr
         X2KT0QDvYl4jXHpV23Gcsw7qVRV3IRCF9cB3BjRqgPK7XBwGbSFJEwJwe0w8TGmadSA8
         SyfafqAVKnSbswWeE76DZShcP+bwPQkRa8T4SWKoFPKf3HyO9btj4c2d7cnZoRpuLZMv
         BrItwQQ5WW9Df1DNPeAiUVQXGro0X2q1zQBrDaR0MVkyzW2TDCm/y56h7n4DXFhtGgKR
         nTAPpru6TejdJIXHZkuH7lrZHyEbftuxgiEBE5BdSuG8gDvE6gdP/WnNOl24cL4jbd6F
         nzPQ==
X-Forwarded-Encrypted: i=1; AHgh+RochASGzajr2QX/F/GKBPGeP0aoCLVBLca+UellDchEGHcPpLzqCWNtxxy4wG/dpU++e+iD/j69cA==@kvack.org
X-Gm-Message-State: AOJu0YynG/kUCcLpHO8ZxWVkNCyBsyxZBIzIJRugU7/5OIKiXv1hzhOi
	+sAm1h71sPHw2qIotkhCIjuIhfesR+EEzVQ+pwTdclP/4eK0zJA3Mp9Tt63U03LSsB24H2yjLXC
	oJyk+I0KnG/3EOp7mjhyWvXwh9ajunxlaXxXawvWYy3ZVHFnMFtfY
X-Gm-Gg: AfdE7cnV722j5eM5qw3PBLofSANtu5jTCOw+OG7ZGhyAqSSIdanCEhZG72gGQF3jc1b
	SCoW2LPaqq2Eb6eMMwgfN6Rjj6P99YXOKK6Q43h0/zqsctl11J475LjVH8O3jDhsZKo+/K4/kdc
	3TBoHa5rOMC0gMqj7JYfvn0DiSWp+O1ktC1Kc8vRmGv77VYBNlBn0GtzZNH/ONzXPpT+VasH5m8
	5Hb3jLkOUK4c3Ob4h4/Gg+uUAl998LOq4J1lAc7b5r4Icy2zbxlnGB9ZesE8nZv+/HSXvyCrHn2
	XTTXriUZIklC3R5RqziYbv2vCHgIfPp7sSwEATkkJC1ps8Saxd1Pu4Tt3FFmyk/OOSw1Q3jXaFr
	gjeD9piHXkoMnY5sc2SpyvOifwmm3ZEt/
X-Received: by 2002:a05:693c:8948:20b0:30c:ab96:7307 with SMTP id 5a478bee46e88-30ee18ba288mr436345eec.22.1782765861516;
        Mon, 29 Jun 2026 13:44:21 -0700 (PDT)
X-Received: by 2002:a05:693c:8948:20b0:30c:ab96:7307 with SMTP id 5a478bee46e88-30ee18ba288mr436310eec.22.1782765860825;
        Mon, 29 Jun 2026 13:44:20 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee2f5e4dcsm857053eec.5.2026.06.29.13.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 13:44:20 -0700 (PDT)
Date: Mon, 29 Jun 2026 16:43:56 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <20260629164258-mutt-send-email-mst@kernel.org>
References: <cover.1782676497.git.mst@redhat.com>
 <akHUboUaYi-OJHFu@firstfloor.org>
 <20260629033608-mutt-send-email-mst@kernel.org>
 <20260629043417-mutt-send-email-mst@kernel.org>
 <akKjOG6iFhGNTFYC@firstfloor.org>
 <20a5dfd4-b3c7-450a-8a70-08d0345aade4@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20a5dfd4-b3c7-450a-8a70-08d0345aade4@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uuNq9p4JvYGhbmAjsCJ1T6YySiMre_wr-9IIML5cFt8_1782765862
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B0A6E100009
X-Rspam-User: 
X-Stat-Signature: gie43yekxehg1sop34rcssfm4zxdd4s3
X-HE-Tag: 1782765864-26205
X-HE-Meta: U2FsdGVkX18iNOW6AHLpT3RH3rrC8OM5EpudE8+QUqSgfpVVOuWI8i/gk6E6YpSdrGCGmV93SuQqLeETCu+C3UEtuOOTGg9upXy+SanjndF5gFy2+3wadgYzKeyf9lNQfotwpVGTDz7QBzH9rA74CQzSO0S+u4pWmJYOcIlIF7Tmjg5LV7E8tfAWLyIoN1V/RYmb9UspTjA+pGNn0I/OGDLz7CZ+Wmj+cqmyuIJYJph1A4qSqjEo5qT6peda3hjX3Iry8CcRDuix/zdsRcpthWy85NbL2XR4K9g0FO31sRv/tBQPhItEjhTSiX5lXG/ghAwUlufqhFcBqmWljW4lCdUIIwtVfs9cA1X41sUFtXl4DsrTuIYJLhiHaWkhpMiEnLZRGqsszR0nHRxN85n3A3VDrgaVlFb2ZrnQxAVZpXTIYAuv2lxPTCgovYjU8ILVDTOlGjo4gy/npb5/EdShiD24HQxmfHkuCjImEwcz4phvLnZkqMaTgqwcO530skLUXzxz3Y+p9HUXbqNwuikXxkNOTJTEEivuvnHK7ouA7Isa7e50l6iNMCQCRoKLgW1419wL6OyD5deB6L0xgE4UD8wr6eFU6rJBHGDxEVD8+I1WSU/6cj72zVUWy3JQ1RokGkjttcO5qsMSzh+sJuu9KfulAlmUMgQMHlDR6RQif6EPJJ2AgJxDIap0VvUKPWfssvHvsK9qmehhInRxod5opUyI7deEkwTU9UYJjcfcMUlKpZdfY0JmAWCfvZ11HKV8RzUZWdifwuZ4d5sF9rNtH1J97KgfJuK8bOWAnWWW2IEdBhlBbMajFYG8uyVqUQQBjzy0tiJg9XR9R6FKD2qGSQHmXhJmmxPVE1H2RxOPvrT0JTuFUOvGLXf5rEmJX6uiCZPzojureBPOIV9sueGxRyEKC2Z+1tIjCz5xHGpo4PCJFTYPpslRnDWghFX25Fyqe4PoGTrVIFIsggb794S
 lfCqlvhm
 wlXA97ClQP6+/LxLmjhgtnQq6I1IGrq8NUM3TNRTQ7uLBsrYG2OHVD7/SdN7LVXUXO2G4sRj/CvJrn2i/aZVAX0g+gy9g+oMmyFhET1K4XCBuEx9TdcXdAS/VssTdBSEg0TFDh3xXBH5qVtx6rUaKC1lhwsUyx2MeQI+PhS3cBQ4EmJeX6d4ndh74oEC+AjjmAjOAIbdyBJQr2Z0MHqC0NnmLuVwGgURd6Y2zhK5rKVybzFLxlRujmv4GnsfzUZoikn8kqiHdRjJK2USw4HwS6iLV5pZlnMWLDOv5doXPz/fmuRM8wq4/TAmx154yO0FkUuGxpA2tiqKQV6XmM9x0IbznROahxub/6+LFX1+BHAq1jwWunuzJ8qLEUIbGjIM/VQnoe6uuEdwR3Wk8wBkAwrZkpYKdS1KWlW3n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 07:04:25PM +0200, David Hildenbrand (Arm) wrote:
> On 6/29/26 18:54, Andi Kleen wrote:
> >> However, this was a basic test, when allocating 4k pages. With 2M hugepages:
> >>
> >>                                    insns/iter    cycles/iter
> >>      -------------------------------------------------------
> >>        base                       20758 +/- 12.5   191208 +/-1946.6
> >>        rcu                        20785 +/-  3.7   197108 +/- 132.1
> >>        atomic                     20727 +/-  6.4   204591 +/- 160.2
> >>
> >>        rcu vs base                  +27 (+0.13%)     +5900 (+3.09%)
> >>        atomic vs base               -31 (-0.15%)    +13383 (+7.00%)
> >>
> >> and even with THP:
> >>
> >>                                    insns/iter    cycles/iter
> >>      -------------------------------------------------------
> >>        base                       27220 +/-  2.8   192151 +/- 483.3
> >>        rcu                        27248 +/- 30.1   194159 +/-2746.6
> >>        atomic                     27186 +/-  3.2   200526 +/- 746.2
> >>
> >>        rcu vs base                  +28 (+0.10%)     +2008 (+1.04%)
> >>        atomic vs base               -34 (-0.12%)     +8374 (+4.36%)
> >>
> >>
> >> needs more thought.
> > 
> > Well the alternative is to not bother with RCU, but just wait a bit and
> > check if the bit stuck and repeat if needed. While that could in theory
> > livelock it is extremely unlikely (especially if you add a bit of randomization 
> > to the sleep)
> 
> We discussed that a bit already. Hypervisors make it fairly unpredictable how
> long you would actually have to spin.


Way I see it, this is not the issue. The issue is it does not fix the
race:


CPU1:

read flags

CPU2:

test and set

test and set #2 - sees it is set

CPU1:

write flags clearing the bit




> -- 
> Cheers,
> 
> David


