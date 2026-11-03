Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16CDF606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NMJ0iy8N
Received: by kanga.kvack.org (Postfix)
	id 25D546B05B8; Tue,  3 Nov 2026 13:08:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 204D66B05B9; Tue,  3 Nov 2026 13:08:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3146B05BA; Tue,  3 Nov 2026 13:08:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0C7A6B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:08:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 732BD1404ED
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:08:14 +0000 (UTC)
X-FDA: 85394592108.02.6B9B51E
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id AD67A2000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:08:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NMJ0iy8N;
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793729292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XzdQYtOUXxk9uHo1ZAY0NXte1croEKcbZ0UJQV9jXv4=;
	b=GP4ypUmyiZoGyE9UqcqPtAYhp7Yp/JFPT8O4fTGheTPVrMWnqWmLeJqwIJWbswPT/X5wWa
	VMyBEyVQUe9mPCm2BwFDQSsmGv8dfft3CM7HUmgr7BWcvWvPUFOS9vNBuXtJxsciPffJns
	PcmajWYx3s33HAj63vfVoIQCAxTk6Pw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NMJ0iy8N;
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793729292;
	b=8jwhpjZyBU94CDK11s5TCiIRvz9G9BB5MM6BI/HCSShvELvcSZA4+lOA00A0J1OEhkSjWm
	qOYLjPRM0qWNkJ+meqvRQ0KUgeBqfkV64oRZmCnaN1EupFPzbLXnlX0iwixckZ25n43Fb3
	EpAf2mJZU3onxuA+QHc2MRB1L92+OGo=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-676804a3a22so3689392d50.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 10:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793729292; x=1794334092; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XzdQYtOUXxk9uHo1ZAY0NXte1croEKcbZ0UJQV9jXv4=;
        b=NMJ0iy8NYNeNWcTIz38ilzdN4QvFxq5X/vjSmMxeGCohiMS58ICkKg47nqj96rxsVb
         OlhQIihU8/r64LULQoHpB2+ByBeb6oq5IgZdj81PU5NUJPRLHInkd0qhwxblRVcd2Yut
         ZS6n/ddEeEiCM5XvUG//a/drJjaTTWZ+0YHEOooo+HczombEtKbYLHAPXQw7t87Snm4Q
         vJnD4+qiKC67vPvJ+f5my4l8k/VyMfOSt3DDionmxA52G9SkX3S9VO2wNkxLPKsR7VFd
         pFfSFg1JgkLSQr2WKAJETMAzaCnCuaj+opESyc24EOxH0G9M5Z/KjvU0JTMtfjcz51jP
         piYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793729292; x=1794334092;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XzdQYtOUXxk9uHo1ZAY0NXte1croEKcbZ0UJQV9jXv4=;
        b=wO1j/rRAcb6KjGBjSbmX8y183LMHksep8LGs0z5ZbHzbHa037h5RX8GCKf7VeLnRN5
         IDeH1uBCTHIlQoe3KVBmCL6Y6i6XoQEHMhxFPYYXi20C3YGqF1+PehlzMgyzE0Bu4hvb
         uohttbVEh2w0lil3Bb8U1MSTmZefmYCKKzcgm35AwDKStksx9RhfoQNiPGHv9NuzbSQf
         ijHy1KyoYYzsiUWljXKZAIwH+sp1DIYdkSKRMMQg+6k5zRDhL6vjQGDJ+FBOG9YQPGnG
         RxBJD3Sy3UwA5C/GUJKSH9KKno5NW4wrIa2676MAwBv6FAb1DXt2g4dCM5mKy2TC4T48
         nT5g==
X-Forwarded-Encrypted: i=1; AKwUvBz5dQ5Lc6//AIZMldUqzwXWPsIB76Erc53yDfUNRGDI/2PwEaCVhq2FSy0t/51yi7QTkBA8nLBcIA==@kvack.org
X-Gm-Message-State: APuU4Z/gCg7ue0rxk/AuA3527HdXD8eg6aipqilSTBGnC+afDzV8+H7R
	SzBVi6wxooYjtPmf6ss09DQ4dUo31IHyQgtkayPtMqfvU5dUPATEhvZE5mI2fy5rRA==
X-Gm-Gg: AYBFou0bi3OGCyvyR3WCIVA8gIV6xbwNb7cQAV4pjZwO5jIWIuFeiZ8Nq6FFBhVZUdY
	kU0+3+75p7EMuVSmH/3sYrTUG3i8z/FFn4wZjno9Jrm20xu56UUgHhzA0qmInp6f5R/s5JG6y22
	/b/ktmDwDuHAfkhmczg/NIZpiyzMKZR1yQlri31SZhISbAtuajxK/fvsEMSRAB+4UYC99MCiCYv
	KL0FjRJhYE/4uNs9YUPvOJsgUG+YaUVo5GCz1gyaBZuP9rc3ttaF+DiDqLvDRTUdS/WnEvj7d1h
	gcqEM92VAqHedIApmOSATHYvVrTgM/NN56zPuzTTeNvNHYRoRXTG5GCjfWXJSeRptlAv6pxsChV
	m+NkPla4jTD4leUpMoF/mViG/5QKlHYnc7hOd78PymvS5CyprBnrT5XBGkbZRpCyq2/1nl+onZb
	7mfHuovbENHyTEr5pVCuZj/3dOBaEqUn4jr8a13j9/z2w3I1qfem2Gvz7gMUx5zH8iCbrmeSX+f
	DQl+coowKAkeRwH6hJMqw0FsuqrwNNc9mz0D+f7ASEHNYi0IcGKEYp4TpZBuiFX+M3aSAKz8OtQ
	Xtx+UaHTDivB3N+j1D/YI7Dd8Bg9lQgUDWdcuzHEkZmkwXmTr+W8fY/Y5ekBucmNFIbBDrxfder
	s1hFfjG81T+PbnbrZfyCgU7A=
X-Received: by 2002:a05:690e:4141:b0:67a:8648:a87f with SMTP id 956f58d0204a3-67ba507da19mr9462809d50.79.1793729290959;
        Tue, 03 Nov 2026 10:08:10 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67baf3700b8sm7600510d50.23.2026.11.03.10.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 10:08:10 -0800 (PST)
Date: Tue, 3 Nov 2026 10:07:53 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: Hugh Dickins <hughd@google.com>, Alistair Popple <apopple@nvidia.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
    Brendan Jackman <brendan.jackman@linux.dev>, 
    Byungchul Park <byungchul@sk.com>, 
    Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
    Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>, 
    David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>, 
    Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
    Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, 
    Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
    John Hubbard <jhubbard@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
    Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
    Matthew Brost <matthew.brost@intel.com>, Miaohe Lin <linmiaohe@huawei.com>, 
    Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
    Muchun Song <muchun.song@linux.dev>, 
    Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
    Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, 
    Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
    Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
    Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
    Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>, 
    Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
    Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
    Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, Manfred Spraul <manfred@colorfullife.com>, 
    Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/7] MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
In-Reply-To: <c301fb04-1144-4ec9-a41e-3c98fb569e0b@kernel.org>
Message-ID: <e0ab5329-db66-ed89-5d6e-b57f7fdd6753@google.com>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org> <20261030-maintainers-v1-2-97278f8a5f54@kernel.org> <b04d8d01-b42d-d948-b7b8-c360f8ec6002@google.com> <c301fb04-1144-4ec9-a41e-3c98fb569e0b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: kn4n9mu73eor8trorg1i6imp8ozbntwi
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AD67A2000E
X-HE-Tag: 1793729292-152667
X-HE-Meta: U2FsdGVkX18tAQ/OOIBWF891Wn4i0tsoV3jPcXVUTpsjrqf9exZdNnKhDciHF5xxYsubW6J4RkI6xvWIn0I3QPLC8K4imcDjHAQtuJxuPC2WfHZbrkQGWQf45b5ZVNrNhx6T9A/y6iREs+S4ANF8OgGyCz76okoNxuO2KtiCLY2UqUb98k1l0T92oMqyiS0Iye6sMe4PNw82LOa5a4r96kzdOQsiXRFWtkuBiV0sDM25lae5WPberOrjbhoU6AnKhvRZRQHXrXl5V+QgfnUM6mAMgEBkaVyqueL8StgCaD7szJb2gdm3mNImj/EDlZf5b8Kv1ErL8Lx3oAKSk1Fi/7ptSt4Pgoni1p0GmsMh3n/mkzYBDu71sXTsVz8OnByEWy9/t7BXXFHttLCR6oXBPS9idJHFB4CgoAxQe/AB7KyjJnMNR3AVCJfOS0dzoollWB4/yQxXzbuYW8ste/G6G+Gl3hc/wApcbgdmjOA5N/gGtVsAgssgw4bK3LtnBt+nU5hA/wzKW+ZTZqesbix/ba5U9FFsZuIIZ1RsoxVjfikSXsvWdrqTk6R8+DDOdFnnOnPCeoZ1DL36n6G+weWVXUMrHSzCY4bl+O4PiOlwKd1Ih8KLj+G6eDgVydZ9VdEd/HH89HbzqeKaVdtIgoOTvZIw4lfBQ3ucgTOCDjBuxDLMe5/HxOW+fmNoXeRFRnJm7p1Saxty5SQUE7aeUUHRMwxPII6+vrah0u/kOa5Yd61fKTjYliVbR2GUBu+a+z2wQRAi3o7AD3C/tW2wqBLh/FtT3V/8jr0I/6uKHTDGq7xYjM0Sv0sT7YaRoeYy0jyCWs6BiDfMwfz2VXBaKH06R1vlj90X/KZ8V1ww//Pt6JladMJh+CLOIE3+fYX5P4glJzz5036qlW+kx/wJzU1A3W9HoquHo/2lEmSmb0Beu/LcSY5krlZo2UZvV4ONMUbi85cGsoXj768kl3z2oC3
 BmfdwwzX
 ua0zgMTeu3WUoAp4hXt4f5btz5EbtNqlu9bdowMfrlIc4hyXuYFYv7N8XopIOtE27UNi7mgHEUzwGcevM16q7AFI4KH0SCaoPASt1duvtZrNW3dkNmcdRYgMxwPi+MdqRXG9rS64Or48D4OUZVjuuBWB0Z39lHE4Y//kZFDBTI/pCKNC9UPdIHvHVIpGbjJiSDTPOveLb0YT4QX9joIDhVNCcY54AQ/ur5FHPqSvgl445+fd7iT58q1m7+Qfep6D+MzlSF6zCWkQSmFzQAamraUOJsNN5IKkTsqK1d5SLp9IqNCAHVv/E6K8PWECNDTKd4MQIfrYWhaBKE1AlBC5LbH43detoPBdn5iRA9Ue4tMa7u5DckGFWf9dJyZwNPHXH6YZgxWYDoca592D4676zSz3ROvofh7lpjrP3HMO4ejJxd4uIv1YIYpm30w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 3 Nov 2026, David Hildenbrand (Arm) wrote:
> On 11/3/26 09:27, Hugh Dickins wrote:
...
> > "SHARED MEMORY": should ipc/shm.c be added to our list of files below,
> > as mm/memfd.c is? (Though both can also go off to hugetlbfs instead.)
> > Or do you prefer to regard ipc/shm.c more as a client of mm/shmem.c,
> > rather as drivers/gpu/drm is?
> 
> I would consider it more of a client indeed. memfd started out as a client as
> well, but things escalated a bit ... :)
> 
> I see that Andrew is assigning it its own section, is that good enough for you?

Sure, thanks.

Hugh

