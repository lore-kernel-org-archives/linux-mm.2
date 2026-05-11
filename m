Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD89CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF55E6B00AD; Mon, 11 May 2026 04:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA52B6B00B1; Mon, 11 May 2026 04:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D976B00C8; Mon, 11 May 2026 04:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80B336B00AD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:56:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B4DE140620
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:56:57 +0000 (UTC)
X-FDA: 84754534074.28.871681B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 14B8380005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:56:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ud/2BNUq";
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnD1FHiZXru8LRZM2pWajLsAH/hxpz4Ki53NfN5H2pc=;
	b=eCojFtmClMrAQNr+f2MTKQeagOmT1vrA/pXqBCFd439iNBqrTLU+mLaIlQg0j2cYYS4fHi
	bxsaEoMG4mj+toj+60R75AhaUPNzdakTN0xLCAFS+8vAsXidy9NsXFvshdoMV9fUur9IRS
	NL6uuDbWPj9Enz+6LkvvtZ+cj3ucUTk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ud/2BNUq";
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489815; a=rsa-sha256;
	cv=none;
	b=LyHhxgOJrJJWD9lsPp12v2O5UL8HykTfG2ogkC/Pb9rXCRis/Z5mTaXi5A45TISCjq3FIU
	nYQKchhV898ofz190yG/dWs7jVuK11Wp6mbxH3XwAW66RduVniVm1qcrpVIf2zEps4O4Bs
	IHr6xawTGukRyoNDjz+turWEe9clSXo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YnD1FHiZXru8LRZM2pWajLsAH/hxpz4Ki53NfN5H2pc=;
	b=Ud/2BNUqHDKuOciKsJabzLEgAaJ9uZJcYBVZW9GSIHOCljwLH8doDh+9z7T82KdT1ZPVg9
	sxVikpF/bBMYaP+c+Q95C5M48cF1BGqcwZmIo39x7I67vHqf+uPVcqMwZzCdJiZiDNlcXl
	6w6QP3qD37ssxdRUZwyQhCiIlQRkbjw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-6zYZserUPSyJMrhw4kcrvg-1; Mon, 11 May 2026 04:56:53 -0400
X-MC-Unique: 6zYZserUPSyJMrhw4kcrvg-1
X-Mimecast-MFC-AGG-ID: 6zYZserUPSyJMrhw4kcrvg_1778489812
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-44dad1b938fso2450965f8f.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:56:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489812; x=1779094612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YnD1FHiZXru8LRZM2pWajLsAH/hxpz4Ki53NfN5H2pc=;
        b=aX7ylMFqKbPWthP73o3mCBRW0bFtfjQD3CLjojmQQFCTJX1NyJbK1DYcvH+hxS6sZ6
         nAOahxkcmhhUmPezkfErWJrYSay4x1oEU+6RL8xtQQZH0TlSZ8eYyh2REZGhtlfzo7wr
         vFB5ti/aHIsGh2vZvwjhDaI2kKERS0o+TMFdT9/GHa6el9u/NC1+YtTeBmjA0oWGDh+7
         VJntGYC8Q/lszIhnDHUbSpXCAzxkTRLTIwzICqQe+aImhcMO+ilpM/HsOVS8JXdLum6v
         aUNEyvZkATFQQIyDfBxkzQxjgbuA5T1xAtWiG0mys1B1EML6zk/GsH/EkAZqGqFkagb2
         9AzA==
X-Forwarded-Encrypted: i=1; AFNElJ+BjNsAjUux6XHcFPBDXotZnZpp/nZpMxXkS19nBd6PGgEJ8c2J69lwrcGu3ZS2PoVN9whC7An6qQ==@kvack.org
X-Gm-Message-State: AOJu0YwIx2ND4IKKUjnww+04HPGp2dVtMvLQTQngPf/5lWlmVnZZmTy3
	+6AUgYOLxPjIebWyWABGrZYnG0w/9ropObXB/ihWa3wLhYmivKki7RjpobB0bVFGVOUaEuv8Ymt
	YaHV/RKfXKBZCSiQSxrI0DrH+E8hYcyDAnWmCdMcQhuJD2JsgBJEm
X-Gm-Gg: Acq92OH547fjUvJLY52v3GYi3y8nSE6Pwv07J4MrP21OffCfcXsurmjH44JvbKEwU/u
	w/N7qSzb9IkuFGatx6mwbSBDiHp3/QxgTRIXi9yXrX5q+IEizr5i3Zs95/eC02iRyGxe591B6JA
	/MhK8/BXGkM/NIQ0hOA0zn7WolXR6Eyt9bVi2110+MpF6EfrKUC3wph6iJj0D4pJO2MBIoXUdEi
	yg2Qehu8HUfpCLfgawbUrsi/4bocE1CX+UaYopx5kf+YZgNVb+wdll56iZQAJ+D/YBy+3uBq0qo
	Yo5/ujfD+nvZnF/8IVYxI6EyV9LFs7/ydTgM/1IdEpIX5kWtx+Sasmz7ahWt6+Se27IgYiNOXx4
	SWqjR8cZ6UJ/RVJA9vVFpczmDzPL+tc3XH/hUQXD5
X-Received: by 2002:a05:600c:8908:b0:48e:6275:27ec with SMTP id 5b1f17b1804b1-48e676b6393mr136866225e9.24.1778489811972;
        Mon, 11 May 2026 01:56:51 -0700 (PDT)
X-Received: by 2002:a05:600c:8908:b0:48e:6275:27ec with SMTP id 5b1f17b1804b1-48e676b6393mr136865715e9.24.1778489811408;
        Mon, 11 May 2026 01:56:51 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6daf496bsm82521785e9.4.2026.05.11.01.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:56:51 -0700 (PDT)
Date: Mon, 11 May 2026 04:56:45 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: Re: [PATCH v6 00/30] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <20260511045608-mutt-send-email-mst@kernel.org>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GLX8URktKPrHn5O6m0soU5NjPIuO-t8Pamz1VmpObek_1778489812
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 14B8380005
X-Stat-Signature: t7ds59w4d6fsqm6wysrr96dwgw661667
X-HE-Tag: 1778489814-872812
X-HE-Meta: U2FsdGVkX19wkYDk5UDN0UXjRKsn34tZXkU9nJSYG8D1mHttXciJuI5t/Cfp56yCmD4wIoHidNMjTA3p9ZeTPlZfIUxhFfcWHGWoXfqnCNwZgr8g0QhYG5cEwvV0T0BUKdgYX8Ft1FSNlQO4NQq3/8t4E2u4EDqamO6nrPEjTBks77jbXEc5SyjdgmjuKCviBK0zsy4swUANhuxEdO4QKWMSD3dTdOZOhFxxe5TKSuPW+8PT0j+7p2L5qduobqEfWmG/qYL5dVTKPYvpQOf0KBXYBsD+Wg9bcmFHaq8z3FyGolR/s/38YgJsHl4nfgKadITRN6gSe8Skot/pv0xuhnJgxcKYsXqJbKZGH5a88Y95n3P67+VvCTcl6HOBIcCfQIGGIQ5lKXGeM7Wc09PucZqd0Y7PDJf4+r0Q6Vj2GbybztQ5zVxqjb5F03ncBeLvz4WMWE2vfZjmaoE+DZD6Fpf7xB3XIvb5HOd5e1xJR2gAb7hPtLAv9og5d5GIOku3IKnGDCgr2VPiDNcVago7Q5eaNRsHohpyRmtOjjnJC6EhL0spyvSMiDG3jGC2wuOJJmgIk5JkvJii+RIWhbOg2LBT8TMGtGGB4ApgcVENjgNDyfbMGeOIOKul680SYsjmTc/zezZuDaVq6HWrgwr/QJRl4+dYvzYdG+gK5Fnu7TnvFJHju6ezHbSrFPCYwY7Gop59Ha5v/uTZMHj/A2KMS47Jo2dQOkfee4FrYARTHwDQe0gKJ0R08P9dRQTh1mTyt+dv+MCO/g1v04Eo4IhK3VqfEpDy8hpaIxaUiBiVPppL9kDo+udvWdB9miqKoZPZUcCK3QBOukWG8RO2iIjlkv+EVNeWt2btse0KwaQ/ARDLfhXRkj/772a4RCotaNQsxev4JK8toS+aNeyJrxbaXgUXG1QGiRBdxg2T6rDzWKUEjd6Pwv5L5CZ7x7H6N9xI7nEprHemtA8r0kFWxsG
 zJAFFTJN
 wsayBnUweZO14PN/ClRQ3HEVSObHpW8O3I1bqyhCafF0NGwMVRhKrWH4CPAFn1GA4Jd5LvrmKgBGXotGUBknP0/BBn8LJZtJymmELagJtDW0vBMJJT9299v8vCh0Q1XcIToNDt126KsmWcY4K/XT64RnWqlv2q5UM25rWJBX6B5nB1HayhvBJtBQCrhNcehs8uGTPRFpL5HQuRgMHu2Xf2FOhc0aJQsa6FzqJ28IGKjqwIvozXTMCViKo96hdZNUB6JNpY2qMrDcXA8k095QrbTqyJg2PZhY+V+7hLGL5phwczWg6eSmJQ3H5ZumKcd1nqXerYuS2J3Ymp5C3LAMh7IgBpZa+Xl/gfMURxX2Qiw0IJoRfpfJugNfrqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ugh. Had old and new files from git format-patches in the same dir. I
apologize. Pls ignore, will resend.


