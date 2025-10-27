Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3353CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1A880072; Mon, 27 Oct 2025 12:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252148000A; Mon, 27 Oct 2025 12:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119F680072; Mon, 27 Oct 2025 12:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF78B8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:32:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C752085F4C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:32:03 +0000 (UTC)
X-FDA: 84044436126.01.8FAE52B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4A29140002
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:32:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gbxakDrD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761582721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4SSBM/POjfRiBE6DHhiqMi9Y8mKWaQroye8KGKfKMM=;
	b=G1Abm8SzmmbQDi9M7MxigQI2xf274p1AdhDZCaWEDM4OAJRTwuRlEMhO2SC9fwEn9FMw5a
	sVWkPzs6+VxLIRYYjisz6pdQvX4ZO84JFW3R+RZD0SJIvuY/7ZNIkC9Vahv2Py/5XpITZd
	RxnfduYk9KiOHa0O76stObRcUsgV0nw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761582721; a=rsa-sha256;
	cv=none;
	b=ScobCatO4A3ujMIjSNl/gMzpJTwFFuuLBAPlobjjx+qQcnctskQm3Dg190PnF/baJZ6l82
	GuuljZlBgXqwnyo4jtmj86NdTeIjy7sUQM9PMZsVuF1O87WC1uTLAPiwZj1W3ZMoij2DGb
	sgZIfHEcujmYENx06vozn8Qq0BJH0DA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gbxakDrD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761582720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=a4SSBM/POjfRiBE6DHhiqMi9Y8mKWaQroye8KGKfKMM=;
	b=gbxakDrDCbMabVd6hrUKAHuVAusX/ByplZAFX8NLNCD67r+pbXbddv+TCLDgbI4TmB5Fi9
	mHnM+MJBWXcppVAPZnbVTpPdx8iBz2ehlDQlMIa+NYr5ArvcMhOTYYc9E6YzPUDsLWpXzE
	WxWlwqGOj3Ii6xoAim2Ab/PrcoeQt74=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-odJzLh5bNlmCrPQg0Vz6jw-1; Mon, 27 Oct 2025 12:31:59 -0400
X-MC-Unique: odJzLh5bNlmCrPQg0Vz6jw-1
X-Mimecast-MFC-AGG-ID: odJzLh5bNlmCrPQg0Vz6jw_1761582718
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4711899ab0aso34199315e9.2
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:31:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761582718; x=1762187518;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a4SSBM/POjfRiBE6DHhiqMi9Y8mKWaQroye8KGKfKMM=;
        b=N5DsGvIX2Q7cpGNswK5vouiboQ9Rk1+WBGSs6yn7/EJkmOHFIs//dWJ18Mufox2Iny
         ZHnCNO7zntWSDL3xe2+UYmk29VA4tmM36QO+W4qSHdfgSJje58VirZh3+em/d2u+ELmS
         tB/siCkmrkv8udFAzxdDjRcEAdksqA9jYa6jPtTMV1yFhQ6dK//EYls6ziICKqOFSqxu
         /uqYdAL4Iunfjb3JMXrSviWgWd81+PPBXrRn9u96yFX1JYA/uZzUwAZv9wkqdv1Rs/Po
         dwtCWHkA7AgyON4j0GRFh02lX8xTaDLyPcMsLoi+lN7hAAqw4bwrRHoJT2fAAvLv/sqO
         RoJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQ78ZuIWgnBiL8D2PDkyiawgsD2OlFAodQ4MFqWCRyOjIa7ZVmZsWXDp2/UwsoA8r351/kuqK+lQ==@kvack.org
X-Gm-Message-State: AOJu0YxkBCvlyw4t67ScVgK3fwf2SkLUDxYGfrJclb4fBP1Kd6pk6ojS
	/2xV9nFsMePF+kXmfw97/C8OESql+09sC5dSXpbRcjyLcIeZTPxo2fIJQhcgjvCHYPo53LOSL/K
	SX6lK2zISRM5H3MrL9BoqTDa9psQNgILXmBZ0Jtwn9mr+3sK+zzvA
X-Gm-Gg: ASbGncuU1STG7pupu9OxzLA9ITgyVy6bqMVkCx+HW/9DTprDBIgFnfwM1cQwOhivLeO
	KdVVZH5ogo/kDa1TBuTebHgaTxzUYaiqcYU50BUwOFUCwB3VjbB3jsx9jaAq1rVctfCsjya3/pp
	ANtBe3qXLmarNCUtL595/vl9dnDxj7Prp4usX0oof0JBlQ0o36EVg/cMcCseTD7Gp5bATsC5Dnu
	x+TQcDJowcAtk+muRxCFKTESSqsQn+FhjRB9nMh+j/nDZkcTJzEf/pY3rmlVRzFrfUCSFgtoYHt
	q3AGIjd1WPyNIUTHDg1zgzYBIC70EwuejNB+8+w4hwV5Q1FMsgN92aeqAOYrczhskpIx3emav6G
	bKNGSrGS3EKzD7m2I60RULbmIVLnaOMurbM7yFvOuvcpzAoKa5Ym6qCClgpBpeQHXZCOgsom5+P
	p7ovPkjnpvb2Qqvz5exkP9c6ooyQE=
X-Received: by 2002:a05:600c:540d:b0:46f:b42e:e366 with SMTP id 5b1f17b1804b1-47717e6ae77mr2486025e9.40.1761582717987;
        Mon, 27 Oct 2025 09:31:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9hBUduL/K2sJ2VMSMKpTvh6O7vT8Cwrl1/5Mssg7iiqgi3rWLBvdxmliRcG5sUi4pRS1k8Q==
X-Received: by 2002:a05:600c:540d:b0:46f:b42e:e366 with SMTP id 5b1f17b1804b1-47717e6ae77mr2485705e9.40.1761582717529;
        Mon, 27 Oct 2025 09:31:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd4894c9sm141374155e9.5.2025.10.27.09.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 09:31:56 -0700 (PDT)
Message-ID: <dac763e0-3912-439d-a9c3-6e54bf3329c6@redhat.com>
Date: Mon, 27 Oct 2025 17:31:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: Gregory Price <gourry@gourry.net>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Leon Romanovsky <leon@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Pedro Falcato <pfalcato@suse.de>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
 <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
 <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
 <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F> <20251027161146.GG760669@ziepe.ca>
 <27a5ea4e-155c-40d1-87d7-e27e98b4871d@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <27a5ea4e-155c-40d1-87d7-e27e98b4871d@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NVEO8xATuWU5jxzpW-0NcQ-jwi3kZFz8J9tIiZ3dQuI_1761582718
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A29140002
X-Rspamd-Server: rspam02
X-Stat-Signature: 7eex4jufwi96bai8mzuyjfgg8xgkrjkh
X-HE-Tag: 1761582721-833928
X-HE-Meta: U2FsdGVkX18c5GJk+b98vbaoVmO7GrfSqiBKVbNJ0GPR2gq1Uynbl/FZAlR5tb/K+9eis6l7ehYSJlBsWn8A5jtAGgXq6qAAtRy7sWDmws0eD5MGZv4WkD3FfTWtXUFGSZitk4xxM+iDni2sXMXO1ljOm4iUhQujXM7dwXqxtMpK9EFBvouCg0WBqDHLxIG/++T7MBnB0509bg/DtIoi4BNdybeFYV9aCk1IMbEu1SUplnUdnp7i7+roS2RM3PQ3hKuBrrhc7+7oRh2djyyeXOzfyyU087Ksx0X8OBU2JzzIlGGNsiQLZ58hiQXkJddzOB9Qhg846ra5UJzXCqfP5rkp0lcsxNPzSrspAvlkIBL/DdaXxRQXWSrWJ3G57S7AQvKjzxpJdze4G9MRxDkP9v6wkfcVZyYNTF3rQFmspYeFjxy2pkh2rThjcPnI/H4o40c+OeV8xnHz9AK/hOu6r3Boaxf/aTUAdffPflbemPz5BMPNQ2H9Cse86lFtEZLRgb6lQy7BmSXPTrN79KBZ2QoXsOSL/sr0xhlwZEhHBoPqI4FhTGpk1OF5UmysLpHaa0PWMMks+Hajmtp1Jrbi6ey9I3/PzyGcQil/oWsf3NrfBteIS1cx5Nm8PEWBSryl+C3SU5IwBgmV2RDWvWjItflMMwaJIIfPrVtv6kaLaUTZwbmRBA4HvASCfW/G8syYbbygRx9z9ZXi2sq5LmjhyprSdB3XvofTPN7iNFHL5WsPmSY6ujJfWlWGo3ycatro8Tw4iE16sVLyARstZJItb+jjKh5Kz/17xaVOzrnLPpiiaSFiIQGKkJE74L2mUFtifIuIftpuOZsS8wqA9ilqQFBuBf9dNHtjhSNXIgrirqYUI4PKpluamVJfqMT2cnAu5OJ4lIIxFl5cWAwWJP1UgSBKaBvKd1/1PX+6DRfdlSqLPSNeCUjlHZ4aty3LLK/pB8uOp5obJ2ZKFAgjVBQ
 YyEkVg4n
 G6Gu6db0SFIoyW//u+DjhcZsZvWq8urosBKa9YZYzlaFZok6qydCzfUD57zGJXBNSbCQn8cnHW6zvu9dLh24LaRRryBPJ7PEEo3h+6Txp5R5/Pts1Te4ur6jIvug1QNh1f24jJ7yuxydYAYMXhteBMBSOaBl2cLevUnJmSDcg0EtfNhc/cBdUNLu1dnzYk7oEv7mQAWKeATk5zm3gg0Q8t9xOPwgTUUs5GGMSv7n0Yg1NsJ/K53QSqGPxDNUV0NWyiHm6nJ9USK19Thm7yHCOxh3hGF2xYpBgS2+zqHwQfxNeohJfhln7uCbi9gIkZrjcBLyue7PUJzsZSIE3txXfTsRGBaJAGzGPuCZ9iXTRf97f5F1FqdxIUDDUizRDfPoXY1hiqnFX/LQRJKmvL0HnRWNiburMfQwKf7QPvJhNb10xgoBSVCaap8XyT/2HW1bmBBArUVTH9l8xsGxiCfa5YVthC+IHzT/UcmIkGFVPYFVO+L5+/ZxkkKwNu/UU0YTWn1xOT2aRDSQq9QAGBMYHy2fdQw8I980m9rI5mVxD1C7akxQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> I don't love the union.
> 
> How would we determine what type it is, we'd have to have some
> generic_leaf_entry_t type or something to contain the swap type field and then
> cast and... is it worth it?
> 
> Intent of non-present was to refer to not-swap swapentry. It's already a
> convention that exists, e.g. is_pmd_non_present_folio_entry().

Just noting that this was a recent addition (still not upstream) that 
essentially says "there is a folio here, but it's not in an ordinary 
present page table entry.

So we could change that to something better.

-- 
Cheers

David / dhildenb


