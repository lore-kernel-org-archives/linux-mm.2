Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C425C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A2F86B0005; Wed,  8 Jul 2026 09:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453E06B0088; Wed,  8 Jul 2026 09:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31E2D6B008A; Wed,  8 Jul 2026 09:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 032176B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:08:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 853AC1C68CC
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:08:58 +0000 (UTC)
X-FDA: 84965639556.16.FF2D593
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1E6FD180002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:08:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nsf1KWgn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783516136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U+rX2CKg5FhtAMYxFR8MmaCVN8SdzuEUH8feY2iANJc=;
	b=6BAdporGf3JG3+5gJXXkFBDD7OFuZ9DuZO1LaymWRvJ1wJlwgleuwZBpYINutJ9lxDSl1N
	UMA5xBwqy3eKqwPPvOfVkuaPL3/uVQDTtD7/4kVgmslWujw1Z/aGOdoPYphC/M7NQXiBRr
	GO72HNHU36/MFN40xCyea/ICjQIlxx8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nsf1KWgn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783516136;
	b=Gb3aXlPehuroSjKBI+czXrYU1qvh7o//HCM6Ys/r7PC4vDoxk9vybpOiO2TUWdgSMKxBBs
	/2nInbhFKZg0N5XoEeGyJPeaHheVBI0+168WI/cKRpYqyyjVB0Gv7zxqGfr8cbj8IkWINE
	i/4Xrx5Qpb2RosLl0BfBeBTSGH6o7Kw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783516135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U+rX2CKg5FhtAMYxFR8MmaCVN8SdzuEUH8feY2iANJc=;
	b=Nsf1KWgn9A3cbs6NAEMfyl3sVL2Rydewrwnn4CQqvREnSxMiZBhz5+lgJc2Td4EPx8C6oI
	QUad2eGDFHpQI+VxE7Q9v/DC6R7vMIa/cYjZgIvXzKFwkXeNRR4CCJ0Gi4yAzcXaEJYG1W
	xHAE6I+O24/ezKLdhxsXP4yAO3ryiF8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-_CG98utbMjWqupjsUwrQOA-1; Wed, 08 Jul 2026 09:08:53 -0400
X-MC-Unique: _CG98utbMjWqupjsUwrQOA-1
X-Mimecast-MFC-AGG-ID: _CG98utbMjWqupjsUwrQOA_1783516128
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-47132f8a98aso625538f8f.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 06:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783516128; x=1784120928;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U+rX2CKg5FhtAMYxFR8MmaCVN8SdzuEUH8feY2iANJc=;
        b=i/M4QcwQ/id0NBwe5X35RO+iJT0KxX1jityNeBsCpF3/gxbAggear+8iAToIJUJQHm
         Inkr5qWFfX32bGc7RNePi/YUYCa6A8w+DDuYTn/lzphEq4NCl4R3o+1l2JrZotLATfpx
         SHmvHYEqzjFteoYTHrXxjN21S4Hdqg6ZstGGx1Pi61Nijs4c7tOpT2htkM+CF2F1a2WM
         qnV/YMpzEuqx+GKhmKFYl/B1aBmeiB1zgFhcicHEEdh9rcZ0NYRcBY/b7Jnn0qPl1xN+
         n/gvtIcKUWzXZLnkg/7Oxr23t/NjGKmG9+1Ou7Kn27sShwNraiPKr4IUIgXdpbPqVmux
         7fcg==
X-Forwarded-Encrypted: i=1; AHgh+RqJs4BmswiaLEjmhhaCm5gHTRudf623uUUAkQtJbidZaogIKWj2fSgdJp60jXoa9az1MmoYZVN4Cw==@kvack.org
X-Gm-Message-State: AOJu0Yzln+qHOv0QFQCkWrA8+hCvTnDiMX9E5IQbNIvL9zFopj3ePnaC
	XDnkvuC4VdK+LNNHFdetH5gMpOJhJ0/Tbex1+GDG2RZsLOR4qFCo9F0SCQP9yeX9Ev/gONqEgU1
	kxYYsWFiT39WebCaU2qfqBJmkhBjrYor+3TIpzWTJSyZZ+moOy7Zz
X-Gm-Gg: AfdE7clElH/tHI5q1H+YYxcL/3ONm3/fWyehpWTtPIa2wmRSurVJyVqvMxItG0LfQYO
	umOkuF5lo6nzxErnxc+uot5vyn4GtDwRfMGJEgfNN+oHfJ6JDFt0JkaAxLUNKY6F+NBf5yxkNVy
	dZRckb7CtDkRxqCHXdN7pZm1fGSNkl0kkFPDmfoo9u2nfUpO2Sru56haTNqtuqCwO0Pnoz2iQxL
	CzdfhuYEsl9yEzz084QNxL2WWVY8wBHJszo1LgPPYCgQ0jC1TO6fZpfatuV1aInIDYmaBSV4U5x
	8XaEzVn4aLk5XImFVFdJd6FcyghB1/WnsSnrjSvQF+2T+UtLbHzzpKNIaiwVQubGFd9P4Asahce
	FWm1++KRETgXj7ADmsKFJSYUkg4TA8Dwe
X-Received: by 2002:a05:600c:8284:b0:493:c8cf:27bd with SMTP id 5b1f17b1804b1-493e68642c1mr25878175e9.19.1783516127937;
        Wed, 08 Jul 2026 06:08:47 -0700 (PDT)
X-Received: by 2002:a05:600c:8284:b0:493:c8cf:27bd with SMTP id 5b1f17b1804b1-493e68642c1mr25877715e9.19.1783516127480;
        Wed, 08 Jul 2026 06:08:47 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0f294a6sm259459405e9.1.2026.07.08.06.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 06:08:46 -0700 (PDT)
Date: Wed, 8 Jul 2026 09:08:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andi Kleen <andi@firstfloor.org>,
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
Message-ID: <20260708090739-mutt-send-email-mst@kernel.org>
References: <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
 <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
 <20260630174852-mutt-send-email-mst@kernel.org>
 <2f884bfa-3cd5-4fba-8aa4-c2e68890ab64@kernel.org>
 <20260701041112-mutt-send-email-mst@kernel.org>
 <d2ce93d9-c3d8-4915-a511-d08eb2c1b374@kernel.org>
 <20260701043024-mutt-send-email-mst@kernel.org>
 <c03ec696-d635-4c7f-8c77-89a439d9135b@kernel.org>
 <20260707155658-mutt-send-email-mst@kernel.org>
 <6ec8f683-77c7-4ddd-830c-030a3d984715@kernel.org>
MIME-Version: 1.0
In-Reply-To: <6ec8f683-77c7-4ddd-830c-030a3d984715@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CkTK2VS7e1r_Hm__jPW5Sj0bEfSiKAafvVUrp8tBTbI_1783516128
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1E6FD180002
X-Stat-Signature: oed17r3j1bpsj7jbrqai5mnrwq3stiwo
X-Rspam-User: 
X-HE-Tag: 1783516135-774154
X-HE-Meta: U2FsdGVkX18/Nyu0tyFqz0i1dtMId1NHMLhIOE+BvVSno7tqEJnbaTsUXloqlENNQc/3xe7hizyDBlM0YgXZrkvLT7wYjw0gkKgUbyaEJt5RjQA/AUhAIGkZ12wXNPOLYTz8vr5IeUCLdzZJnHf4qxL/DttopWTdRYhRNjhP1DwcM5Pvnn5SIk2GjDrDK9xhS2wRy3QtE0GpieK45sZM8K5CY7+riMHLvceye1ghmlFFQeSxLp4n5k12Mcx0Ye1CpzbrqxVkYxBqmhq8xiAR27hpPUqTtcLfGlBYITC/QKIAVKU+LEMdtABkhhuNpz/6Z8D+qAx+hNYLPq5g2Fgj72sX+VZppYtszN9NKNzJnLIN/p19LQIEYIXU5XIC0VzV9rE0FZceZLc6GIx86NC8LypJgWmb23yczwhC6YtKOGHH6HaEjZTzotFwsQMA1in01Yk/IEEWKZFyF98psaFdn6zPdd9N9Z49Ht5CEp3r4SeF8H/ziWdy+jojygEF7o0FW6M4ynQd7oqwiR4ihLgQY91ODeF2GKA+Z+gN0vZinga1U6AUoJf0Aqzm+4+v56BMBpQDXnFyNT1hGwcteEMFyiV4xdL/1yfEYHebzDvhyszNrOj4h9fgZ5CEDhbZiq1djdVMLuR5e1hIJUpod2Ff9kgxPyqTgM25TjZ2KGdXX3n+4PiYfMKXJjs+rZR19d5EQk2IYURow6J16JufJErHzMGNYnhB69QD4EPJCNsFz1aKo5wfLrBoyDSfP0Juk4UW3Hv8PbIX9jESjque+nGTew66QAtWimFZiibGoXDR/OihSH3oXYa6TtVBD12twG6lhnbbDEoiV/Pbqunu9GEKa76s6I35ZHxSei+Mj0cIihwYwu/mOYkpM9GJn1AG3ZtVl9cvf5gr3I8hmTmC6VZY7wbMAsgSGxsCvfnqFODYzv/CUPaWcMlB8cCKytER1Gvorq9N9fMUabUsqtIoDSS
 W609vhrN
 r8wikVdviR1aCE0ze8k7EjRwiy6MYF52u3aK+YF8+dKsdeAEC+9iL0vX+QwiAimLOBf9HXMNnKV4nug9m6NiSbHiNKKr8upZXZ2pzaNbsI5J/N7tZpKAPfSMRlNDNrOzxgkxuphP4Myf6HfxfOaMs3k4UcVN122wjKz1APnHN5b609ryNp02/hHYjIaqV7hRDO/B6KYCdrxxLhur1SOvCL9n0yqvCV5h6znx81/6uEQjyb2BrObpLKYPvzp3JgaQJfo+OnzLt9kTBBEsBBn1ScgLPKh25ThXGLsiiLjLzAJ32fVj7NxQ8u3NeZlo2pt6f/nzEHK799mFxRmJMJp4MU7XdOjR+35cEMXMWn6+Sj1PTQEPTrlhsQfqV6Rh96jCRxT/wH7YDMt/6WBIur7MN43UUQ2MdI7rDtA9y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 02:03:21PM +0200, David Hildenbrand (Arm) wrote:
> On 7/7/26 22:27, Michael S. Tsirkin wrote:
> > On Wed, Jul 01, 2026 at 10:36:31AM +0200, David Hildenbrand (Arm) wrote:
> >> On 7/1/26 10:33, Michael S. Tsirkin wrote:
> >>>
> >>> what do you think ;) post it?
> >>
> >> As RFC please :) [and if it's AI generated, obviously properly reviewed and
> >> reworked by you]
> > 
> > I spent a bit poking at it, and it's hairy.
> 
> What I thought ...
> 
> > The issue is that we have calls to both set and clear bits.
> > When we record them in a side side structure so they can be retried,
> > we have to carefully record both sets and clears and their order and make sure
> > they do not bypass each other. So if there's set already in the
> > structure, we need to take it out of structure and only then add a clear.
> > 
> > It gets very hairy because we want to set from NMI.  So now we can have
> > clear in the data structure and set from NMI bypasses that. Now what?
> > And set from NMI can't be 100% safe anyway as we discussed ...  Kinda
> > reduced my motivation to try and make this reliable at all.
> 
> Maybe we should just really keep it as broken as it currently is. It's not
> really worth our time fixing basic design flaws ... given that we didn't have
> any report about these races so far :/
> 
> I mean, sure, if it's easy, ... but it sounds like getting more and more complex.
> 
> -- 
> Cheers,
> 
> David

Right. Either we do the RCU thing or let it be. But then I'm uninclined
to even bother with fixing other weird behaviour I see there.

-- 
MST


