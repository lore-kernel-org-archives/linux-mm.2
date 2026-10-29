Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78C5D606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=UeK4r7He
Received: by kanga.kvack.org (Postfix)
	id 804D56B05B4; Thu, 29 Oct 2026 10:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B62F6B05B9; Thu, 29 Oct 2026 10:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656A56B05BA; Thu, 29 Oct 2026 10:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38B7C6B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:13:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 71F891202CC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:13:56 +0000 (UTC)
X-FDA: 85375857672.16.DD7EEA8
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5D8431A000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:13:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UeK4r7He;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.218.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793283234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHQCBBokr9ANF1mnkSximMg4YC5imaFH/YUHtOF7V4U=;
	b=ng74J/g3BInTxVABYKQsPI9aOSh5lS5VcG1yI/Ylo+1vpBjSvl6Ckkxsj8flw/zIvq/nWF
	NxflgaWeG1KA0YRpAuNxDB3LhpfmnUUMCMXqkPg9YcAGv5WMtZarlwkv2Sm/rISmy/RYbv
	ubbJc1cEjqZr32V5pkcD9ex1Nda7bBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793283234;
	b=lDtqX/gDze4Ypt00bNjwpJhrxL2CLj/22DbQ/HsQONgIgBsATDYtHRTyFKZ8gLYfBDfdTa
	fJ+lzCM+yYgxrCAQ1aKDOkhuVTHoKIIAiZvy1ysTs9H0ArkmAahcgY7/GSnhN1PR1xoAex
	u00jL+FWpfVURmZonGahpPJtrpx7ccE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UeK4r7He;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.218.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso387774666b.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793283233; x=1793888033; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VHQCBBokr9ANF1mnkSximMg4YC5imaFH/YUHtOF7V4U=;
        b=UeK4r7HeM12Actt+pHgRABm1GjmdoWM96dKOVvAX6cofADGdPi7JeSSa0lWhFVURsm
         FLaJkOI/jGb2M3CF3jXduEsMCETng3mnhrKUCv0555vhrHvq9dXYzb4APeh/1jLkzbNs
         bUDnwT6y1E+fEVDk2ka3ZYmqE6UDlTwvjaAS6GsNv5S1ur3xkQc/ZN5pV8LUrl6QSNXM
         1r2R9A6v/6s4aKwLcpoS7j3Hvbtjjij8KNTo4SouAYynzBBoLpG1ILTvgvECmX9FjuyW
         OH+Lz6n8RpXfu7Hgb8IvIH30qKLISqm+UF8LCCl8l+0f8E1QQn15KRlzledmIeFITh9N
         19ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793283233; x=1793888033;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VHQCBBokr9ANF1mnkSximMg4YC5imaFH/YUHtOF7V4U=;
        b=FAe2PPBgRxSkcjwUBx0NeTlus/vaLTNBrEujfy93OUq92xL+JZyd3YFS7wi0O+nZsu
         K3qN5aJ/b3fsYcl0RX/iZkyvfRE4HEyqJQZHmHwVs4X8QTyCYzpEdOvTXZW2Ydl9X0yL
         3tg7eXjA9kMz4yJvQAl5TJP4Hvfz4VfYjfRG2r+oU+qzCJPb/UVhmM3zVKqEmdsMinfh
         MuK3i6/QqtuE62HZPA4q8nrEK8AJ2RA5/MLP2c/mzih/XGcgyxKE80YVmU9tWZShPbs6
         +y3hOdz/7yVZwcjT4ScQoC77qVBfyGkWqG85qYjeqEgAXWFCE3fylVvhLkMpyOSvBLfD
         ECmA==
X-Forwarded-Encrypted: i=1; AKwUvBwoE/VWdvusm0rvye5zU+agAd1VgEcpzLKs4IQbEYqRzGIyJ+XfXfKCML6V7PFptEueVjm3bkRTzQ==@kvack.org
X-Gm-Message-State: AFq9FYLdyNjrbB33lxtWCpvZnJQdSacsZJJdzACWBq/ZMYSq1LB5vIlJ
	hSqJAwGk6pRb+n+twQBsuPhEX5HAQi4KUWzPQjBo5In/Ycg/IOqt1lt1gkpXtH6U+QY=
X-Gm-Gg: AYBFou3kf+5xSaRIZRuQd8gQiDd1X1GoS+mBJZoN9ieRkf21WHMcoxztq53WPcF+Jq9
	E1/+t+Uk4klkU8mNofK5FHqdhSDeeIBCSFe0vVqww24v8KUPxL3obE7slhlc9nEZY4psodVlQPR
	83CC5NlttAz+MZIQi5aW6k2a352kPjbwdu3dxYAx/hBC479zxMu95JcHtF9DDv40LY5IQ5gP9d0
	XZLsXV58452ucIDjl5PzfjSSbq/nclkzrvTsKncRkn9n5f/KYnlkp6JlxNhkQzEMQHu6ZaTxfL0
	mNpJe7Qk2NloKTBGOk0ez4wXjm7jmHXDRHtMaSRkzyhZtOeohv4FshjqVFzl1WmpvBJ18Lz2wyF
	b/35g39xeQW6EMd9wS8IakY65YDLzm9BaJcB0NSzZfKRBTJnAMEfRAjZSFkbdvhb4rAmIXQMFvI
	0Z9OOrX6rOtcQ6KTenMgWnf3XyrJpyRDtCqhakZ/o0s0zlPcWWKtzQ4K2c3C0NCrXkUGR/Z1z13
	Lc1KVAhhXnhPy4vpwnsDRWrYpIYyRNXhQhfpozJ8gcvio1UUeEywsqjIgIY+yvvUryeAn7CJwNi
	lDsE36aBClOfB6TNAzs=
X-Received: by 2002:a17:906:7313:b0:c45:c030:732c with SMTP id a640c23a62f3a-c49be03a73amr545832866b.41.1793283232717;
        Thu, 29 Oct 2026 07:13:52 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:4::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4992141068sm521507866b.60.2026.10.29.07.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 07:13:52 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 18/46] mm/khugepaged: check if PTE table is empty in
 try_collapse_pte_mapped_thp()
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-cxl@vger.kernel.org
In-Reply-To: <f9067f65-fcdc-4ebb-bbf8-84db9e22af0d@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-18-6f74bec9a5bb@kernel.org>
 <179323853182.453251.8510731747954180380.b4-reply@b4>
 <f9067f65-fcdc-4ebb-bbf8-84db9e22af0d@kernel.org>
Date: Thu, 29 Oct 2026 07:13:51 -0700
Message-Id: <179328323124.453251.12177231963891458248.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D8431A000D
X-Stat-Signature: iky8injtgny69gez3cuktwukdchp9oqp
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793283234-840826
X-HE-Meta: U2FsdGVkX19WppJ2UuTA/2Ln9Kr339NIcSCxt3rd0sfQ7YIew8gRsucck5fDCpGeoUnQ/h7m25CRtD76NIpCPim09dsF60GQjWGPTbsMYIVbuoSQ3N9NiGz2lyC0/Mp01ax+DPn07FnQ+sp3XoyFSO5l4buWv/xSTvpTkqEXg0VrzZLKtbgiwHcywIPEcZZFk7WQI6eUijsF/4Eu4IJJ60cSBS/5WY7uL0a0REudaHTT9YX+2CHHqXQHj0/NR759SR3+Hhj0GjWo3JBuhjXM1Wjh6+uvaYJIz4NFU16X4xQ1pZQLtMFzVzU36zDoNB8mJkv3TnTw5sZCM+olzTgm8g5MPrU7JXrBswOZpC+3qsfThNTtqFhiEERLAO0ohTSug0WqwtMOCO+Y5/WrixsK5DLSGI2bSnPANOShS5dzyIbA2rhsYHbgB27jgth05j4D6pbBHdzdjHBf5yQ1L9YvbV0oiYXfwcMxOQMNCUj46JJGxk9FADdmapS5k/7wwU6+OUKbdGq77dK6MsOjvhdB93iYQ+CahiSClVNU74jnWS2WIicSx1As3SrEkm1lJEnjK40GilHjVccZkapdZZoowijJgHPgW4Rgaoy/guy5SoKMpPugHO78WWL+Q0IiI0pWvAZMwz4JyKsC8KktLr5Vo+PDu5Kd+QtJExN3W79mtjjdaxFO5Rs6DK+bcv65FdIWmZcllnqaghDf+gZ8rn07NyguSHU4jk6VSapIma6fMO4S+YSYjZpb8YmhoMA5zsklHl/M/+p2bHJ9nVn0apV810JzY/c5c+lg7cbAafP1tvYOn/0QmOxNabgXlbKaSDwQ4niu293fZzWTzvZW7FF07vQ8jZdjcuzm1bJQOCcgataPch/859BOz4LlgTg+QVWEvfvj9f6H/epgeeVViR6Yx/JS6LkYL4LUVQyI2LtyZHyMRgzXiPEFzgmc0Dg8Mr3iGQPe46Z9Rq0dFIF+wsW
 +i2VnOUU
 v53l4Oa6FC/lk80kFQ1TF4uDDaVX3S4TJjpjS10vWF5qB3iBiuK2sfRGLUmpTHnA1Uy7iRPx+LpE0rno2ekGCqpEcDDyK2QLlI1S/Yq/UV2zdCOxEr6xegEGkUYqSTE9tBqKCL52w9BSlxegooHOwWUQkO31Z/8pprLwQu2FU99ESAkMayGMYM4YOdKyMfPORMbe9pzaGNhh/2ah7RzfxZ/O4BFycJz8vEgbwPSUcS+RSCjlgEkj8dVk5lxEaOxDDL3eq7vOEDCUOZBrRMHHdsWMzV603AylsCYdjgmDQ/K4Vmz+LgZAnETw7LXbWzt7aWR5fZEevuu+wbAI9t/gHFgTn8od2smqnuhl8MMjQH6VypioaY/Pewmc1Y4zhZgjx8J8Xpuhe2VeisXL01Eu5NaZwqF4xlYTwWs62QMJy+7+dIyYI7D0fiVE8gh1eTgldN34ARkXzuPaJBgMicJG8oXXfL/2r7BGZ3ayFDcP9MNIxCDqo6hc0fU9zLZyjDaJt7ORgzwsO0iUvrBs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-29 12:01 +0100, David Hildenbrand (Arm) wrote:
> On 10/29/26 02:48, Gregory Price wrote:
> > On 2026-10-27 00:17 +0100, David Hildenbrand (Arm) wrote:
> > 
> > I get that you want to avoid taking both locks while zapping, but
> > wouldn't it be simpler?  I suppose we don't know what kind of
> > regressions might pop up with that though, bah.
> 
> Exactly, that's the spirit of the original code. We would just block a 1GiB
> range of va space for the entire operation.
> 
> If you think there is a more elegant way of doing it (while minimizing holding
> the pmd lock), please shoot :)
> 

Elegant and this code do not appear to be compatible.

Another look, i think this is the preferred route.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>

