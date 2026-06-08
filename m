Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2873BCD8CA4
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 19:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78DB66B0088; Mon,  8 Jun 2026 15:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 764C96B008A; Mon,  8 Jun 2026 15:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654356B008C; Mon,  8 Jun 2026 15:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 525B26B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:33:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A4718CCCC
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:33:48 +0000 (UTC)
X-FDA: 84857745336.29.DE0E4BB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id B124D180007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:33:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CEI4wL1C;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780947226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3dDLQst0ldE4FdJBA8ABzv/FPI+QsS8HzDNtt2amioI=;
	b=rxaVaEwDbN6aa8Q8s55Gf59sbEwqi8ua77rsfi49pqad/S3ToqEB/5vI7EPchIxiP+qKuu
	DA6KYUL0noGCe4e0guNxnpDfEVarpTsuTWuhSBSzwDPS2RRck+y151FjynezqITWwv2FPX
	/piTRXeKT5D7tVAHAENQjAzMlD/N9/w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CEI4wL1C;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780947226;
	b=xcK7Yzmq3+mWG5LcFJK8tdTydowe9/wWhEL2nsvsfGS/5FpmgPk0QTLAdvWApVAkn9c8BT
	j3AxPXQGuUl2cKIIKUSDJ3wjh3/dTrcPCUnmRTmxCQlweNb8wZCBW7CAxVffJ1P3cg4PCZ
	bTc0p31ao//ulUPksORNod+ghzLYQI8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780947225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3dDLQst0ldE4FdJBA8ABzv/FPI+QsS8HzDNtt2amioI=;
	b=CEI4wL1C20CYMj+RQn3O3zJ2C7+HGXPxmMeRwPY29P46hWyGfKH9P9+RtBT0H0mSvbOwCC
	tlbxytKlG3hpg+RCJ2dWxw0uwu9TbkGKU94a+IPqDZuRSN9YfiHQMN7uOSuV0nUBuf8DTw
	oj+maHuwZqOEw6QAReONgaGzl+yOGzc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-158-N2KtCd0lOEmxrdcZ_srsPg-1; Mon, 08 Jun 2026 15:33:41 -0400
X-MC-Unique: N2KtCd0lOEmxrdcZ_srsPg-1
X-Mimecast-MFC-AGG-ID: N2KtCd0lOEmxrdcZ_srsPg_1780947221
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490a786f987so53558405e9.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 12:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780947220; x=1781552020;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3dDLQst0ldE4FdJBA8ABzv/FPI+QsS8HzDNtt2amioI=;
        b=mKiXXvpiD5mSWMYrKEOPVO8qVFp9sYHR3UHNft7wqO5XOb7IY3j1f2rYYfvcXPgw2R
         Y5ljI0b8K1A3mVzsV9fBfO4+k5BtJ/KgPP53O5bdMiD1YO4YHHeu7F/7ApqL4ONOhLYM
         pFB/LIMUeHaaa/kXg/cTOYKx1P+aJEkHOkxSuN6HIQsQnQkSmwk0g6hKTULlxu07bf2U
         /e4icFW1fyaNctG32JMWXr9o0LFnwC32Go5bx7R+98QkYEyFFRsTv0kC6mWeKoFdLXSu
         UH5HiKhAevTd9nYavVAClif+fPRpBr4JO+fF+VcDqlNh1dLYTEwRmeXH/bCQF3l20RuT
         tgOg==
X-Forwarded-Encrypted: i=1; AFNElJ97U3uuxcqrXuUYlECV3uRORYmBSC8ROxjpI985lVivFOD8lwtEbVO8ja88TKdia2trQOy25wz27A==@kvack.org
X-Gm-Message-State: AOJu0YwAUSIUO+wOfrsRhwAk6N0f/R7DZzEJdlOnn25UStHQZ9N+T87f
	9UkNITa5pTKhtmwzvavGB8r+SlxXFu4+aBc/vPjICORDWCTo17/7AqP5c6hMGG/a9bK+Qs4+hoI
	JoXAn3i9z36k7CeQTK9ERrTOw7p45QGntTJ7C4kED34TzDcFtowiu
X-Gm-Gg: Acq92OF9cOr3LH591gUzPyU5CcOwm7VZ1cmx1dS6y8CBL1+XEbyPvw3ZHcakQLUq/tM
	mssduhfgrLbSUz856unQRhgHaC2Yh5l2noK1KSzHwzAh7i18rqKji6MmPIrOlbSpYFVv/6NyXw0
	yeGBpkGBrZ0Gh0YXPj1uzBUSw+Kq/UXJdXiL7G1A0byvGWpRTd8MKdTIG/Vqh/JRkfDc+UwX8A+
	fygt2gSMRurHyDJBznUQZS0k8LAyS7b+3P8ri6FbM0oLOepTcQD8vDL4qMyynqQPr8m6vkwcfnl
	tON6cDair5NqhOljf4Y1bJ8KogxTnb7OSy4j9yRcjNsxbl2l9dNG91ZI1wf+CGauDLl0UrL7VGQ
	iVi89ik7zz07466zEfLqC1ELw0cUxTZN6AqnQYn6uov8mqR9mf6Ajyw==
X-Received: by 2002:a05:600c:4708:b0:490:bd66:e522 with SMTP id 5b1f17b1804b1-490c26038d2mr274761705e9.29.1780947220372;
        Mon, 08 Jun 2026 12:33:40 -0700 (PDT)
X-Received: by 2002:a05:600c:4708:b0:490:bd66:e522 with SMTP id 5b1f17b1804b1-490c26038d2mr274761275e9.29.1780947219772;
        Mon, 08 Jun 2026 12:33:39 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc413adbsm420621035e9.15.2026.06.08.12.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 12:33:39 -0700 (PDT)
Date: Mon, 8 Jun 2026 15:33:33 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <20260608153223-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
 <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
 <aia-q026facbptoT@lucifer>
 <d0ff6269-8b8a-4983-8569-d9a8495829f3@kernel.org>
 <aibSPsc33YQiYSMI@casper.infradead.org>
 <ef14cfdf-5f1f-4e3b-846d-fe1462042883@kernel.org>
 <aibVTe5HTk-fF_kj@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <aibVTe5HTk-fF_kj@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 35u83BNErYQQOCNA2t9sWdyGBXJ13AyHUHFxgwa8-ag_1780947221
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ismc31fmurbyjswuqmgg5ofzbz6gg6t5
X-Rspamd-Queue-Id: B124D180007
X-HE-Tag: 1780947225-159559
X-HE-Meta: U2FsdGVkX1+KRi/Aah8SmyF9L4q9Yc/ox5Fjtsm7iQN3rxFPEwqlOS1BzxTcj5qGt1wSMjWpsVXz9RtTF+9CDlF9KX2uQ11QmeauKDGutgN/UL45pG5i4ENSEwbZ/YUkB0qLekotU/yDMRUxIbMhchaYEWPieJe3+HNth2munRKMYf0i1csehkkSvp3wAeV3HVT12yQ06Wr3OMCZ5DztC7DV3bpGBDAHKWuBbN5r8EZAvE/8wDxn93f0MNbmkBKbrsrRWpXRpHUfQCtUMrXQTiLlJzNJ0M5tqZLE4ASvRAMmkGbH1J3YhhQQdTMoOI3R7J7xiAGTfNa6ba9vzsjapNy8yTSaPmr6KLuDruHQH22aDtak/crwKEbJFtNeRDhwvWpTtQhLmfgLejxdkv3q3ltfBMj4ABUHhMz4aGHwX056Q3HtTZxznAhkInI7j0lO9zvAkbkw81q2dKpU9vkSp7DrEnIHVrnfsjk+sKvCWKV485NWamwLHZL6yozUcrEcDaY44MJ6mrSQijPpA6iwEEOYtyxkrspKfpWgagH/AxSEox+4slgO1hnRdTF5VdqvBbUWUcYmxek3Ct/T7ULTxnzaPnKePyW8GEgGEM0SzGxOgEjPxpBbRTjIHX+5GcMTq4P1/cj5guJZAoCu+5pKZMylJctFhzTtsHcNBaqmUtdbn9ix9YDEnxPtVcTJI+IfYYiiHEJ89Cytrp+CivXiE4qrB3zsnK1KiiBkkjl//YqUYHBEcZxajKOwqeuyLl2fzzewqfrnF/LciflJyg3pApdxjKc4rrP/2AKr523i/CzWq2wkAvZWOc+48sy6rJdh0xQy4MtTCsHZal/bkaM/wjUtrrMkEPIzj24rU4SZuJ5BxZXKITu+4vBSrVGdQZmr0W1CtggsVYdw4uNtLj4MC+XeiAQrC41OxRnZe/6B3sjxAlbPrrpIUg59xgHtlMCxHF0pg9quysy+0/K3fI5
 HOnYeL8i
 JAaPcog0IdwC+i/M8R7lPckI59MPbSnASXQCYcDo3Krcc0o5vQz6po7QxE78yo/iI6hpZADBtwl19/vyDOVCnQSaR2bgkYw4O/c9rOL6wUvTC6jRxn3KOkNKvQhuktrLsYND3HOOqg6PcOu1JcETFXRVgnzxgbY48huoa+UETI/jibMpSqlcvBNIwq2vAVeg2qWxHKSLeo0VYISM7eshU6hkaZxFfZZrXUoq5F71r5JjdttZtw5r4N7/JRfEkvzuXRk/Vk3s6gOJZj5PiXgqdfrO6rKSQL0eynk+vSSUkn5b3oyzNPRr6wHiaBxUzEkW4SAl0YHSbFUzNVVFS+FHFByHtfyhwAVoIVlrr8cNdspQX3VS3UIs5qgA0xvd3grvII0D2ZLajVUBWPA/bxo8zN0Z8RQnX6Zc/UQDL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 03:44:29PM +0100, Matthew Wilcox wrote:
> On Mon, Jun 08, 2026 at 04:37:03PM +0200, David Hildenbrand (Arm) wrote:
> > On 6/8/26 16:31, Matthew Wilcox wrote:
> > > On Mon, Jun 08, 2026 at 04:26:18PM +0200, David Hildenbrand (Arm) wrote:
> > >> If that means that we would handle __GFP_ZERO consistently in the callers of
> > >> alloc_frozen_pages(), that would also do I guess. We'd still have to pass the
> > >> user address down to some degree, through folio interfaces only at least.
> > > 
> > > What I don't understand is how the kernel page allocator needs to know
> > > the user address in order to effectively zero it, but the hypervisor is
> > > able to zero the page without knowing the user address.  It feels like
> > > somebody has x86-centric thinking where cache colouring doesn't matter.
> > 
> > (not commenting on the icache dache mess we have to drag along)
> 
> Well, that was kind of the point of this email ... I did ask the
> question you're answering in a different email so let me respond
> to that too.
> 
> > The thing is that with free-page-reporting the memory is already zeroed by the
> > hypervisor as part of discarding that memory previously (e.g., MADV_DONTNEED)
> > and allocating fresh pages on re-access.
> > 
> > So it's not a question of "why is the hypervisor zeroing less efficiently", as
> > zeroing is just a side-product of reclaiming that memory in the first place.
> 
> We definitely have users who don't want the guest to trust the
> hypervisor.  So how do they disable this optimisation?

What do you mean, how? This is done by:

[PATCH v10 35/37] virtio_balloon: disable reporting zeroed optimization for confidential guests


-- 
MST


