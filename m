Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27ECF606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=H35BNz/y
Received: by kanga.kvack.org (Postfix)
	id E15A56B08C3; Tue, 27 Oct 2026 15:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6D66B08C5; Tue, 27 Oct 2026 15:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5366B08C6; Tue, 27 Oct 2026 15:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93FB06B08C3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:43:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 075491C43A8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:43:35 +0000 (UTC)
X-FDA: 85369430790.19.08A5F4A
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3A50218000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:43:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="H35BNz/y";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793130213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kt3m2QX4pRtZBRcLH3IFIQTcdgR87dlcnUp5/WDyAss=;
	b=MSqmff9rsCdH93q35ayYhY0gp+3iCwOC59uha/jcvS9vNzPzPLBHWjiS1Mi6lsH6vBKOG9
	GJCzHDUA+uGCib5mWPzapVk6qsMaovvhXb/4SKBvpFvUMMh/rf8fB4EarpozGR8/A4Yu3c
	Efn+iW6PoiRZPMI83P/lVD3X1GNLWFg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="H35BNz/y";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793130213;
	b=sufpM0c4srSrWZfI9q+HXmvXvGrYF/NmcUnTXVHOvfun8GJNHS4SI918tWwVVql5TeS+7S
	LdR2+uZRYHjuMU9aNnzK6bQhpooutsAFLz5LDgxuGtBTu2GzwfGvEct8HutS+SsvwxjCMJ
	Sor7nlJlDPaCyQZeWtUYpQW9hvHMcZI=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so465ad.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793130212; x=1793735012; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kt3m2QX4pRtZBRcLH3IFIQTcdgR87dlcnUp5/WDyAss=;
        b=H35BNz/ykQQjbh8MC1SCDiK3rOetgABd00UWEPdLsWJ+A3cqoUnMrMcelBWppcjqif
         03kikc04c2HhnZylU+9lvG0aj0HTLiIajoxUKCMaEpVZVUtlDA7ll5DlTVC+2MiovzYD
         s7QRjsUUdVYtXJKRtrLsqGtO3irgnxT1K/i+yqD1ZipHnhYYmgg1e1lYoPTOqVIiXyye
         6h0ImxvyIm4Fx3ZIuqkY63kchxWxcd2uPSQibZqDk1FIsQJubiTtGoTtbJ+iebww16no
         FbTbRhLwYI7naPfWJRMJ73/JYssfakeqV4Djv/JI/dSjHFi+yIR0HQzt+uR0qziYT5tP
         kMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793130212; x=1793735012;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kt3m2QX4pRtZBRcLH3IFIQTcdgR87dlcnUp5/WDyAss=;
        b=VwpX8F892Rp1AcWdaTyRO7BZAKIUeeReMk7bGt54xsLfbVREUdPUfZb8wPBZrOIswP
         aXq+jTEqd2XsVPXUmEGA9bg+AC8zEYV5ZtEnveSC+taV76G6FWg1KefonAN9Cno0xIBp
         Q+p61b5sNSklQAcft7IOsTpI4Sd55Rt3CnJo+Kx45Shyv4/nZoSnr7yzwhhv9LSN+FjO
         7nr1FsZu0xqmAycpOQS2/I6azUHi452oOa9b6PVAYRocfxABbfhMutc2RUZnnTTgscGQ
         X5+GjanHBhIv/5VUdFsnOs5QMxBzwwmjSFlErNzz7IK09g0NXdHf+ZOqKhQ3/lZYehER
         /Kow==
X-Forwarded-Encrypted: i=1; AKwUvBxbFy7V78Gha7U/L6CRcRlj+GyltJMsgVak2rA2KfO7n1Ybp+4ow+UXHCjr2JrH3mwBU5qJJR5Eaw==@kvack.org
X-Gm-Message-State: AFq9FYIOeAXvkomWKksjtcu03WLycfmS5o1K6lrk01J1CMe+UoqXWxYa
	diV8GWkFwOpKOv58L98UDmMhDLQCSkgSna/VVM6+wuvWqwE3AY138CEJQ9XFjBYbiQ==
X-Gm-Gg: AYBFou3I9dKvl5H/rHEdgKI+GWllLaC4EC6rw3yY3FzBCK1VKYzIZxnpU1iGyfbenfQ
	J5Gt7X1UpMORW69qkR5IVhF/w41FZ4wCpgPWBDAI+Q/PNys8GerOpiLgCN2mys2uh15lQfZEZCV
	sPVd3rTlYio9jScgn7ZHY5gkfXnmoi2JCdJYgGJsnCq+Lme9E4uWVpxXbA/EycRAEIlvf8NIxgk
	rFvhDYX7/6Tl4QZx0/GDjoeGhwo1PX6A52lvIJpEDisD+dK1qRoH1IZLiyBYerG3/NXt34LlorH
	2j491/ZAPSDRLpvsjYDc6uft1Wlx+4xWetGbxv5LzAYAjHhoazCQIt80er0wSaYEFQ/ZB1Hkkkh
	9mNLklj4DHOZRgeacZNb/k/ken43uSO8RVvDe7kT/xA/jzQLHsvPjARI17RYjrou44MkiMuw1++
	gych2xHV4pTlyvLMb6epdjrq4quCS0kAMmOYwerCiPLq1gBBfwoIw84uUahZFI7440BV9wV3kJ/
	kGuSrMlc1HtnBl45FqKZfRPXamhvgc5pALcamBh/xaNb5vaNp+Tgcb1+bObB2uVeAeRRq9ZtLe3
	2RRp9+d+ayOH/RM31A9JuGQHrDOUOvGBFRueI65TPZ78E97j
X-Received: by 2002:a17:902:d550:b0:2ea:4a1:e8a4 with SMTP id d9443c01a7336-2eb01986bddmr124955ad.13.1793130211108;
        Tue, 27 Oct 2026 12:43:31 -0700 (PDT)
Received: from google.com (163.1.145.34.bc.googleusercontent.com. [34.145.1.163])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae578f19b3sm251941a91.17.2026.10.27.12.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 12:43:30 -0700 (PDT)
Date: Tue, 27 Oct 2026 19:43:26 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 20/46] mm/gup: fix clearing folios in memfd_pin_folios()
Message-ID: <auD-r_lTZ71vbSKu@google.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-20-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-20-6f74bec9a5bb@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A50218000A
X-Stat-Signature: yzymowdoy4nxksesh7bnnb9xfno4kuui
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793130213-894536
X-HE-Meta: U2FsdGVkX1+K6Yf1N9raRRj9B/xIoOkEI0EOkCPCXz1eYWjNT2Zp6AdLq23BHRKOlROwHt16PaB/LrlbFRczZQg0rjAaqXHgGWC49YnXPRGl337ecljuDSTUtcIGLKnhkWlJfk8DQoD0Ksh0S9lmYVZLC70cJQqI/J57jkQ1IWmhQEGeRzf6zEX1K+Gc2slu25Q8qbMK3Q7YJcG+S526kch2aDNMCETDrvwGlfKz0eR+WkRMa9dPUbmfBeArTJz57EQF1pnYjaKuMCsmT+EIIB5igPceErPfEfCX/7cWssYINCIw9WLIQmflCjy9zuC+mvkFI3Vqj7jtTKtdXWU0O3kIAq7ax3omENvKmGh348y4FycMiChemBoWiRvInASfAynYqpq61yq+LZ6KcaBijDjJmkLCE9GtuFSwILNwI4hvOgu06bj2j02aXLDQbotDXhnaj8XFG41KiTaYDIC52jSf76JXk2V4r0SEk37vrBqUu4wB3WJiDNeZsbjefkTgjLgJO9JPQDlliCyMetRWT/CKd89NfHK8pQ98venA7KiRJKh3Zjfv3zs3ivSkGfKfiSitrUHbmsoSyj7ZPvcR8HVzcIAT2ZjOTcBC0qiYtSn6AAd6igHjXaZmrLoU6c7lKO/oK36ZlOpTIGW8bQU0rdRUXj9Z2m/j//oyXdD7RGIvdYhGe9K1DbUj8BzcqXMryRV7Gmg/w6HrcxDOiG5/yGNvylK9RJ0FT2Ev9nTdfwDK+oJkZo+lkLYID/PSCvJH2dW3zbZdes8AU7Z58S5G6sIvkOTi8q43sydJxXZu7g3pXZTT5iz9wZKLJlMH/8Fr50ajcQZWlQskMa4TQBXA8QLD73Igf0MYf9croHlEo5/5Zm3hw2uIUj/c1awHkw0KAhM/kvFg+QKRBDcPsk9Cg1sd0HDwcNPlkIH7/t81Pv03nmPB9t1PkpnP6IFRAFGZ+WTPLYW4njjP6Vbr/xx
 9C82QrEe
 vTpg+ZTIuRkdEdecJQywhYYVjBjAABomZkAWx9Ecwo5z5HyOetYffmtMHtQ6YBQ30b236DvlKbws1K0Vlf48qrBcX4ze/yTtKvikqb6mAsWQheiaZW7C4kMirWT+KGia/SFv/wjJV+XCL+wXAjwHiCqRLy2YVBGpRY5GJ9vjiv+l52AeRLDyzPkxq5sK+wWOPKLLCJd9cfiaxWUjSe1Omygx9/pMcTufU9KlGLs0fte7pBaWmMhK9Uq32d/Rf7uSfig5uVmNA0cgXcJ40yUCqjSaUlHNWApcCjuuTxF2mO+SR8OX8fpaks1GaQquzXsyhHoscar5sWYh3vt7imWzw0r1B3YEASWr04kXsc3ggYEhkah6gBRIP41lCYu/1gycuUK8P2TErNgxl5GRYKD6qXWhx+kbkUCPJQItO8bPBOURPgFJnVcZX99gXxPy3rRD+b7BJ0xjxB1AFF1ZBDWwtmYM8QDKS8OWFNZMkKzP/aC8HdC433+5SlMJmOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:40AM +0100, David Hildenbrand (Arm) wrote:
>From: Chris Mason <mason@kernel.org>
>
>memfd_pin_folios() pins folios obtained directly from the page cache
>without checking whether they are uptodate. However, shmem fallocate()
>can leave newly allocated folios uncleared and not uptodate. Callers
>such as udmabuf can then expose uninitialized memory to userspace.
>
>Clear non-uptodate folios and mark them uptodate under the folio lock
>before returning them to the caller.
>
>Fix generated by an LLM and sent by Chris Mason in private.
>
>Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
>Cc: stable@vger.kernel.org
>Signed-off-by: Chris Mason <mason@kernel.org>
>[ david: simplify description and comment ]
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/gup.c | 14 ++++++++++++++
> 1 file changed, 14 insertions(+)
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Tested-by: Samiullah Khawaja <skhawaja@google.com>

Thanks,
Sami

