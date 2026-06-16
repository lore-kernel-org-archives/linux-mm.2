Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE836CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC4F6B009B; Tue, 16 Jun 2026 17:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD4876B009D; Tue, 16 Jun 2026 17:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8806B00A1; Tue, 16 Jun 2026 17:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 773616B009B
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:02:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EBD8401B4
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:17:07 +0000 (UTC)
X-FDA: 84886280094.03.553612D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id BF3AA4000D
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:17:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OpYEyvsX;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781626625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSQ34ivI/Ck5Jq+TGrrZE0Mw5Nd/Xw5eBhLGnI6+rzY=;
	b=8XUOF1WuXzlVnv90HQFsMhEgUMYnC66YGUEXHH+zEIPjkbgvURiXPmi7h/MJVwsjl1m4Nx
	/UB+g+EpcEuRkOa/DQ2UIQDVE96OY/oqCxqjUz3MeaA/GdRNv/NZ4nA55gxLRxDIbQ0IUI
	+aTNfJu0bOD3WReRrzPRl1pMxJYpC3s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781626625;
	b=PUlA17330KrVhpt7fvYMHr0HTqfob9f7CogaAcqGfeL746+DHOQ39s1G3UU5tMduoc1UxO
	G86TMvwu/VBTEBZzQlDL/cjlXc6AV2t3k6JZ/pubZ/zohbimSzVw1AoTslCk5jSk6UNQJq
	M5tpEdYBQjW150zacYKV6Ou8fE8FGrY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OpYEyvsX;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781626624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fSQ34ivI/Ck5Jq+TGrrZE0Mw5Nd/Xw5eBhLGnI6+rzY=;
	b=OpYEyvsX6e3ieiSfqA5zJ9ezG84yJFCnx5oPKdseH37bMnres2UUiPrNi1wbZhyLC6XWLH
	4VMJvd+L3y8ti1KQUZKXvku5nIsOV2RUDQ9/I6GnVECsCcExXpuhXJMmxFrgJJpFoL0cSA
	Plvzf4xYu4841ddX64RCOESX0mgE9tI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-250-o71Ktco0P--fTE8WiKAi5A-1; Tue, 16 Jun 2026 12:15:48 -0400
X-MC-Unique: o71Ktco0P--fTE8WiKAi5A-1
X-Mimecast-MFC-AGG-ID: o71Ktco0P--fTE8WiKAi5A_1781626547
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-461da6328c9so16012f8f.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 09:15:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781626547; x=1782231347;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fSQ34ivI/Ck5Jq+TGrrZE0Mw5Nd/Xw5eBhLGnI6+rzY=;
        b=IseM9+mq8tFXNTm4IdZGhRPLPbLNTWwIRWPYkYEw+awm7SYV/gwmn0ywXGndqiF/QP
         mWLMtgb4FHsWe2vkqj5+cPHEaucFokfm9O13PMSd7767MQxtPOQg6jfZWgMz3cVt84w5
         85jELMXbwgrcPLYLMr9+MuvQBkakFQX7gNwLzhR4eBw2k4IPv+xeNHnO/Ue58JcVFVSF
         wEj3++E0zWOc0jy4370FzbIYCse/KRFJIKaRPc2kzucfATDjLP6V5pNcIn5o5R3B3S5Y
         +bhQprz4ApTLrZvNdNr6QEJWZd4w68pCEt9gzOq3QTKI7URMn2l09c5Ra/by47SDwdVk
         N02Q==
X-Forwarded-Encrypted: i=1; AFNElJ9YO+wrtI5QT/aMAOICd+ny5SPeR8oAnhN5x+SQl8E1+0nUXKjNs+jPSu07LKeTBVkfNjIueZpnxg==@kvack.org
X-Gm-Message-State: AOJu0YwNzgLLieHilZd2F9/pOf3NWhPnHpTiSWazOz581KmwIYiy6/M5
	k8CZCzImpRiGTAHjkw4TrjfmEin/3muaqxUxEkB7JrTY8gNJs6skmCWlXSnzeI05BsLHd5N36U/
	KC0Aj85ZjgYh3Umi3PnZAse9Iv29eN4x7v1/byH/datTbBaOb/pLG
X-Gm-Gg: Acq92OHYKvkwtKg8qv+nYY4ccexTZIhgQWaRR4AMnkNDwhPdeoJsECPA6gQUCF6CIcw
	wf9U9e47r/O0w9ZY5W3YlAllA2PctV19Y7eosOizkLToRRyTg0Z8+tVMwToXrEusy3ZGzP8uObD
	c23NytG49JjuapvgcqB8ezlPNbm1dfWJKOQF0KO8nK8Hm8K82iZ2Ha+5z/0vGzNYoJdC+/FmpCR
	iLKkqB2MZLoPXMI1d516mX50khumcQg17i3XHGYMXeS86WxnwIsonegcXAf+9xhuJwvSo2DErBW
	2thAGJnJKgiYxwY6h83A787GvBPGDVp102EOhVYDUZ0wupP4QbwXHDsqi/ClYDbybJ2urnfdzMB
	xMksun3uv/jqn2K18ESlto0vynvL0jkMp9Kt7SHhvNNQ=
X-Received: by 2002:a5d:6b10:0:b0:455:51cf:9f92 with SMTP id ffacd0b85a97d-4622d7072b7mr429464f8f.18.1781626547229;
        Tue, 16 Jun 2026 09:15:47 -0700 (PDT)
X-Received: by 2002:a5d:6b10:0:b0:455:51cf:9f92 with SMTP id ffacd0b85a97d-4622d7072b7mr429076f8f.18.1781626544025;
        Tue, 16 Jun 2026 09:15:44 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0d70sm46116268f8f.19.2026.06.16.09.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 09:15:43 -0700 (PDT)
Date: Tue, 16 Jun 2026 12:15:38 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
Message-ID: <20260616120114-mutt-send-email-mst@kernel.org>
References: <dd8d89be-9c73-8ff7-7d44-9705bddeda4d@huawei.com>
 <20260610171646-mutt-send-email-mst@kernel.org>
 <14537566-94d9-eac5-2636-35f925a9d159@huawei.com>
 <20260611013644-mutt-send-email-mst@kernel.org>
 <1b5676ab-0dc5-ef33-9d79-a2bd6090a62d@huawei.com>
 <cbffabdc-42bf-4e67-9d2b-ace9a1e09f29@kernel.org>
 <984d9775-e17c-0231-b021-126b13a9aa42@huawei.com>
 <be1b20ed-5b75-46b8-b7be-3c9b029f016b@kernel.org>
 <d7e97bec-72bf-7d56-3811-6d9c41fefb35@huawei.com>
 <e4e123f3-ef32-417f-8369-ff944b6f358d@kernel.org>
MIME-Version: 1.0
In-Reply-To: <e4e123f3-ef32-417f-8369-ff944b6f358d@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F-EAHuT73MqgYZZJKngGRPVJ_8u5ksQRb6a0-M0LPwU_1781626547
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: BF3AA4000D
X-Rspam-User: 
X-Stat-Signature: hjdg68hysnjajmabzi1mh6ortkomqx38
X-Rspamd-Server: rspam08
X-HE-Tag: 1781626624-514429
X-HE-Meta: U2FsdGVkX19y+JnO5aw2zMeBZin8ZGDcj6E6lA6gYtZ3GgQlBsnNLcxBUBBOxvcklP1NmFBv/60WC7HtAcjFXG0uHUQV2wjFXQQNGVS1zpUNIye9Lw4I5csYHM4tmqyN7YBkx90JCAkkEd0P0G45XfvJ0xL2vOiqZ8obqNGnNc7uDPe4mBwCkO888vzvAAVaPc9gUMRDa8Kbr991HVUNPhtkL9Gn9yjskH3oAvLCE9xe2EgfgXmGE87RQtFOBJaTfyrhB1iWhcKWLrdpOJWO5L5IXAR+RdPzjUL5LLgqKBUWMQ9MbkaUhBgyq3cW2IcQc/ii5ld0Bcj0j2eJYWlcvPSkywSbQSP4c9dtSJY9pveBJg9QaLgvk/srJRFyhOzfrG+rbIXCEXyCUt7JNG/kZJ5/28+7bwPun7/6QWzX++fygS2ULZu76I6R0FBrKHsLGVW2xArYlyY+xKWJW/wxBGhxTRHjjUlTmEEwf/N5R/7bM6kpoBe1cUNGj/z0q7a+/3VRCYw5ClhgzsDxzNzyd3F9dEoDWCl7OafZdERO/ykGRiH9Un8RgCFvyMWa1uUR/0bMhJEEPerBY/0IJDcdqxoC7x5xRtzrcpqkg3JiqZRLXIYKqFZZrhS/zzt0m9ZBFbYES9qad68WX5h9FickAbMVGWPgEl41dBSTfS28+OnkRGVda322YxKlgYg9UiYpfFzkFUwFJr1ij5nLti0zzsHSUqvvB7Yxb9Xt2ogsmKCFXG+3Hbnh/nIzeS2h4cCT3pZFH8FkdbYv0DLXng5RTUDBlSuKHVoUfhxEzyV8bcLsz+r0P4SpBuJNvHjC9LpHwIN4EozT6uh70DTbdeTSnLFRY56UtYyj9u8jZnmefBaq3iarq9D6rfjks7sbRKfr7Ypn5d5+JGbizXx6VqDGZu+XL0LyYITNEVSXMuFeLt3NA7tg+BqMe2Z3/X9wFcdM3IOjZEY/NUPMonUra7A
 CXaBoQ5P
 B1vefjBoUnSqx29jQxm7RTUeQHX4M8hMtppQPMx8oM1zhmuh2h5QKkA2gdJDH5i+NYWpPjccSTwAtQr2tmj+TghZHx9qc+xZRwggxpm4pPQZHthEOVnG3FmqVt5vTltgVCQ5p1q2UctfDOqe6jhHTaD0hnlTi4fVqgndnfqgvLVjPVm3DOY+nXaWwfrA837jr5mBYaudJdhiEJMpnsN81t2LjvLiwy4eVE4TauxfC2DyBzKI4/HWs/SjlaiwOu5+hBEAffd3Qk+BMgwfnRPSNoabGVdOQQ3cuGSo0xtGj0xjUtkqbw4lyBzf+XWSuyUxsrMWSP13yBeS9rtWv2Ulpm/WDRqHCKgrQijhsKxwwii1wQmOp/NpKSYVIlzt4OCeIfL74LfUZSKm75TsGRwGFl9RyIqv/zvSrvTxA+bJyKixV1KmoNcYyzFrkvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 08:56:42AM +0200, David Hildenbrand (Arm) wrote:
> >>
> >>
> >> Assume that we enlighten all non-atomics to grab the rcu read lock, such as
> > 
> > These non-atomics are defined and used because they want to avoid atomic ops overhead?
> > So I'm afraid using rcu read lock in these places would lead to unexpected overhead.
> 
> It should be cheaper than atomics IIUC. Further, I assume that some pages could
> batch over multiple such operations (esp. page freeing path when we process tail
> pages).

Doubt we have the energy to bother with this much.
We'll have to stick them in the bit manipulation macros if memory failure is
configured and be done with it.

-- 
MST


