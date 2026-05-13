Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2072CCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 16:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8566B00BA; Wed, 13 May 2026 12:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9C86B00BC; Wed, 13 May 2026 12:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0983F6B00BD; Wed, 13 May 2026 12:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E84766B00BA
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:34:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 878DF8790C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:34:28 +0000 (UTC)
X-FDA: 84762944616.23.168207F
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id A5EEB180012
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:34:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lQ3bpsLQ;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778690066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+BIQ14oFJRJRvF17iizm1a/CWsNJ6gKyfT66tKDwfg=;
	b=iO0I+0f+iG3Y7FVoR+9XEcg/5aES5XZ2C0C0pmp0A7krg1Vw8eKirYbH3HO5lPLaCVaNuI
	vyiEx4hy1QnEIuXQNvik+6KZI4oNClQvLekcNtDx56bv5ljlcO9Dh2T4PO1FwLgrsbtgoE
	Kcs/UcemNiQMBjTYL797UW7rwljo8zU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778690066; a=rsa-sha256;
	cv=none;
	b=u/yvyiiLxSgjSbocZ9Jb/y/RqLfjuApdhdSyA0nC1DmRWDh03OEAb94DLsZ15Ooq92Rsm/
	Dvk2jLUhvh20bfeBfrpVsIK6Be+zkZEh825JOGzPM6LtcEASi0D1UTjcew280y2DDXjx7f
	X2osnallpx+dLgv8A8IAjHulGQIi41g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lQ3bpsLQ;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-90f850473f9so134105485a.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 09:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778690065; x=1779294865; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B+BIQ14oFJRJRvF17iizm1a/CWsNJ6gKyfT66tKDwfg=;
        b=lQ3bpsLQQePHac6fcwQ9xfHOL4hxCRVthd+BWCN9VgZV73c2sjxUyscOiChEloh58J
         cMljbctACeeiyELmCzDIK8K09y5NKgk/gX7KUFVeonK4BfI1JAAvXDjJTqIkDWi34MbQ
         dnKB4FgIKeYVGVASBv37XCg8K+qfpOMH5UCUhGwUlC8JvZLusrN+2ZZJ7nPF/SaZJP17
         nDD/M7HteRPIQe+XTJ9qZ02yUiVNCQpq+97rVxY+TIECFjUtLtWYplM7xngJo3QIUOeb
         PW+teYs278B3ljvwUlR48mQblV4p8X/3s/8dC1VyQbd2IxCoNceLVK2HL7GWw4Y6oBi1
         gmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778690065; x=1779294865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B+BIQ14oFJRJRvF17iizm1a/CWsNJ6gKyfT66tKDwfg=;
        b=SVtyJwwKJFnY5YMmXWi30EVWYu+cbH6KZfTBKh3KZhwheoBzkUhvWrLQs3t5RlS5WE
         aaxn8LoV2AkIhUmsqTiFImU67fUwbrWbDv+IHu3yLgLW533W6kmzVBChG+nKIPVZAxoO
         2vsZdn0U6HQzMtE+ZKAYehJ/dewjJV2k/nGdwDM2RTf5viPUEcL5ruBMX3PInQ3RN9GV
         FsNo3HxP4La4aFJdWw/Bw7efzRwf7W1R8DRHK5YoTX8mGxsW31hkveKQ9nP0uN1yeqKv
         6AE29o10thTZEcFgobLZWrppL0MY5UtMNNhSETetps5LH84TnM4vF+hWcNi7cvrPtzHd
         qKXg==
X-Forwarded-Encrypted: i=1; AFNElJ9NxqnwMfuWky+SKzGduA1I3ejLowFoiPGEaMlMXng3K5d28D0tEdBY5EwZlayOpqmzvqB/OPp/TA==@kvack.org
X-Gm-Message-State: AOJu0Yyy2NaTPa6AeN5u8TZeAHJprCDmJ3KbNxBXAcn8h0MjEY0QQ+pZ
	Pba2DP0qry1yBx4S0SYrKMc1doXHLPn1rOBwOMANhBbyqLy3Db248yDkhmaisIBca54=
X-Gm-Gg: Acq92OEA47j6cUPgZZ0ok6x2BE8wZoE3M6GyJovL5QJmWqwq+0XRfSRNqTbGiyOgYUK
	YORqkPNgGaSvsFJJxoGcR51TCij1xJdWuV2VWUjwyjrnQYuinSHGC7KNPYlqZgqJPdfwXVG6TAg
	qpetrSEbP7hMnKVOxxEUx6w6efPcm5QFyX1Zo0M6RDhiw8ME0Tg/GDLUXoGfOXX2L7L95ItBtRj
	Dz+WptknxAVDSxkSPi61ud1v7Z7ZFfBdolIC95n+03FX/Sq1I6ArlwmlYxaDu0JO5J1VCzIDkS/
	TUaBSM0GLQwFtqWO2Wss7ko9tfYUw6YVpyRFKB/MAQl9oL/zhcr9oFsSGX02IvA7KYNxpj42zHK
	xR5j46VslnBhBphRVVHgVg/JeHsmvdVlF3dOYk983Qv0cxPTttjBOA96fOvBWPCE3vtz1nN7aYA
	tkMO5AN1aeonKHyABxIwhJ6dbDpmQXvEUf69/YTqY7y3qBMI2qpOd9pUz9Ns0KRjg4qEYNWYdQ4
	+k58r+0xSMk
X-Received: by 2002:a05:620a:d8e:b0:8ee:630e:351a with SMTP id af79cd13be357-90fabcfd5a7mr529500385a.27.1778690065464;
        Wed, 13 May 2026 09:34:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910b785935bsm7101985a.0.2026.05.13.09.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 09:34:25 -0700 (PDT)
Date: Wed, 13 May 2026 12:34:22 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: Re: [PATCH v7 00/31] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <agSoDnbk5rjx9yM1@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <e7e9b30f-ee5c-44c4-b377-d70156be41e9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7e9b30f-ee5c-44c4-b377-d70156be41e9@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A5EEB180012
X-Rspam-User: 
X-Stat-Signature: 5aaakue1xx1js7sj6cgteaojpqx3a9yi
X-HE-Tag: 1778690066-575110
X-HE-Meta: U2FsdGVkX18/3DSoEO1yMrvaepwkJUAVBIR+1nXIDc9mRCdv0LpVgkplXe3heuHc79x3B0+BLxtoXmXi8wGyHTMkCLojBexNx5Ktqnth4ePS9njBgH/8y5LkBwIL1ZPQJDxw/wEroF/bEeEiQrbOfGz6Gy03HyUQw3rZhKXMMQ+88LqeC0On99DGJS73X+b/RYplbyVdrJLEQ+p9yaaL2d9/CjQDEq1SdZTYGR4EVuQUXcTjfbrmPmL0iqSeQ/stuC6zpUAM0o1JzX29nEfjv9CdSkLESvcAFWQhAdbAdFV2Hu1Vu4lvnSNdxbAr3m0MKxcxaR6xDFVNIMRUCmUDIy7YSmhbVjBbz9ttj7YRUt4VqpUpyE8WQ1Mb6g4ccnFpqjaTRn2C6hOZRTvKhalGTi/u2Q/nqlo3dGAJwGR9zHyaNReWL9vd7wRQfhRx5EcqhfSRlYKs0MJpYZe+Q6gfVWIK5IVepS8FHOZ0vKF1tXLnLRw1BYVO+lQqRKIt8HrqYiwqD1rUdJBT0djlp1FQkTbGqmffHNVxI+B/I2LvOyw0hawAmKCah2UrXUiP94Ma2ndur8dU46G5hgoKjH3YsaGdHM6EzY6toNX17tMtEtBONDdXcCKfD/ScNZ/0xd4ky+RVDy0Ze4Tp0rBGDvSU17asPHD+WlLjZGkVVImp4R7iA+1GHrX/g5NJAi8W9OOzzIyr+mHz166Mz8rc4nMM2CtHm0Z9FyO9vCA4F0FejNEiQYqPNKr5PNo/oMfqmBEAZTPPkxzVUhmRLdY+SNtm7vRvcvtLtdtkH3wzbpVCj3MQtVjO6ze54AwHv2n/mpzCnHZdAfAWLekgK3CebCANYRYf41qgpIZk6FoSTQ2lX6na2gZtpCenou649vAtr/RmecK0Z2/YMLgl1kdgIRWRBgnVaRTyNS/hedfFyNQzned+sryyznUBqnbVR+M/jnci7ZFfVFpyQHBhzZUeec5
 SrQJOCIW
 nu9lQ9cOM2ulyE+nfyMAkQQnXZuMbOUjX2gPVk3I++8HWdzTa1KS4jBIq5YNt9djCPpLypdWmiVQ2OMahNX0O+MNjL4rxQ3gpvlWb7NMan8JksWnixrcz2SU9+UyZjOQJsSOBkMLBekQ8UkFu+QVqI01CYJbk6e7bobO2hNiTPzqXIZe5VtLh8femDRR7qtfamimdmuwy3Q5pbqa8stf49EdU9ZoIjXQTJetBbl2c/gkS5dah4lyv+67dpw2aDdI3Gug29zeshYZ/WdXU7qh1W1Uogyrd9miN8kMASyU0BotbisKor9TsW05zRjJAyorzqhH9JGsM6nYpBbt3BAb77dXtKr1Sv2pvowWnfa8xtK/pXzhH/4TjvR0au9vkVae1g4EZB6FepkODvcMVnD42MrPKC0DukT44juKrq7NLl02a3S6Ntu4zURcrNrlKycm9cWAyM6jX2Nj9YD0S/G2sXYGmzzC2p/LrJRqW8JFaGU0chwE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:36:06AM +0200, David Hildenbrand (Arm) wrote:
> 
> Please wait at least a week before sending out new versions of this size.
> 
> It's just a lot of noise in people's inbox, and as raised, a lot of people won't
> manage to review this before next month.
> 

Also I wasn't even done reviewing what you had previously sent lol.

I can only spare so much time each week on upstream patch review :]

(This is also the pot calling the kettle black, I am guilty of doing
 this same thing so uh... lesson learned, sorry David and Andrew!)

~Gregory

