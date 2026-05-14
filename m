Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C5ABCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 11:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F99B6B008A; Thu, 14 May 2026 07:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AAAC6B008C; Thu, 14 May 2026 07:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899FE6B0092; Thu, 14 May 2026 07:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7830D6B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:53:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1BD831202CE
	for <linux-mm@kvack.org>; Thu, 14 May 2026 11:53:10 +0000 (UTC)
X-FDA: 84765864540.01.ABF8A4F
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3726940009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 11:53:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KJJKLiyE;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778759588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ty9zU0lNlVt9XsC+dbjcc2MTK2ZG8WC14RYLl53PeRE=;
	b=6gbLUTeztwRbhPD1E3lMu8rDcH70uWdDBtKreLRVHSFx0g3/1veAKnJjRQ2eXfQMviG0Kc
	tcuSNnb9SbFkQa/oXSEE0lHyiL49wyxavwLadkvRw5U23t0OKQpkFWbG71uIFxpoChWiua
	vYLh1PEMEQaY8tm7XqpFNxyvP3Q1y6o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778759588; a=rsa-sha256;
	cv=none;
	b=AVS5Lzk23nN3yNhaqkXZ45i4JIpXBYkW1iGjbRveqhuHQ1ZfcMX26DQ7jFMvWwLIV4oE5L
	jQ6a9AI2R74qkhELuO773U9dFrLIPuuZ0Y3ZvuhGwIsXi9DnbQ9cq3kudE30X0HclRZbTN
	ARthIOBrt+cagNcw8eCz4Ei9MCDjZGs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KJJKLiyE;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8b98482b253so105171886d6.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 04:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778759587; x=1779364387; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ty9zU0lNlVt9XsC+dbjcc2MTK2ZG8WC14RYLl53PeRE=;
        b=KJJKLiyEcT6cevoV9GKmPI5UBWP7QQAi2n0J79tgcpAtN/ltIk41uHdwrftgiREdJ6
         /uCigglt/IrPWKH701CvQYLjLR3xLZJmZv/wzN98H/OyCB46sNllV8aUCVBZarNDMIcT
         0bKZsBChdEQ9z4HBTOIbG6p/8EihNn3Dk+QzfeGwCi0YuagCF81k65Wx4zLtlnjd84a+
         /5755+ynRv+jTxV9AYLMTw1di2ZOtbm46QrT4jsIA/WhOM0aVQzarL5EANMKzuBYXfm7
         r91Rj8X4J7A/EcBUmOsL7jL/AqhKmUEB3xwg1Y8jJpoOX+w3rp9dMgRAxBchfGuBL5cb
         KdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778759587; x=1779364387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ty9zU0lNlVt9XsC+dbjcc2MTK2ZG8WC14RYLl53PeRE=;
        b=LAA+e690p4BKmAsMQQZOlItEAWUf5DEBBDvSdXaB2lFpuN63mtSWrqSx0C3gw/mvnO
         OPlnXY83iwZo6cjs30hAmcZqKYjycBaEKIZ6n9hP7T90xOtJvMZHXbJ9k/XyQaxdaTO3
         dpKDZdaIqMtD4znwSfcjcI6UAydjsIAbJGpxGYL+LnNLihWcZ6zCIkw5c7MrQhuf4M7P
         OnV+rcmSh/eOFYgOB/gxGpo7M/r8Hld8fKFmNKBtsEZngsDrh6w+Oyo1FscaaYo3DCWI
         G5CTCggn4+KuL9lbvbwP92OsI8PpmUF3CjFrdiZroitNahOKEJpoWJLIdO2vt9kiBqQm
         DFRQ==
X-Forwarded-Encrypted: i=1; AFNElJ8cwH0PRqBP5caN7Jzjup9twjn6aDM/Zz4biJrNSfbuzQ4BmkAn62Gd5++IcD7hGeIXXCejTv9Cew==@kvack.org
X-Gm-Message-State: AOJu0YyahtDE3eFIIkFuf+pFr7gI5/RWzsPSnfYn2mmZSmn7JcotwIHy
	VG3TKnhavoy2seHE7rPcqFlNfUzUHl1wjwj3JkpEiBiAmJOqkvS4i04jFITemDZOKL0=
X-Gm-Gg: Acq92OGTJKZ80loBHhImh1GHJ019H9rY7YZx/T1MKQILJ1BeM3E3J2DpqTDk+uR/S1s
	3F3VFz9R/somTXRdQgxsE1hkrNNhYpgNH0AUs8PGiXvTIApF7MfrLGLsoPcrpIDC8okjCrv8nab
	datNQO95rktc2s+ZsfLtzGgvPQ6YXRBW6GbKsfbt4hDHZHI1K4GBF0JALBJ3qgiq4VHoh9x6Qfo
	PFxoi0VRG4H6HH/9GH+8ASUU64G9sFS/eQF6WItlb1RP6hj7e4iLWlmBmyX4NrVBEW+23C3lhh1
	d2bIoYEa2kSOH/HPSUOlDEDwqxVv0DQY+ilBGoE48Wb5EzByeSJ7dSwHmdZoTzDMoKhKjF4iZ3/
	lL015f55PxsTeyK3zh2h1H212nyd3obNW7XJaRWmEp7YB+BLTQ0a9nVx7+MUsyayr1JLKrtAGht
	7CB8Po/kRYB1XH0/HKw4SKQ92z/OXRyu96BdlQ0I0i4GeK7jJoJfFGrPkwNT/xV+3zdei1r3vQI
	juNH2SKirgR
X-Received: by 2002:a05:6214:2f90:b0:89c:bcbd:c26e with SMTP id 6a1803df08f44-8c7bb4b1e07mr116683036d6.25.1778759587110;
        Thu, 14 May 2026 04:53:07 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90c35cdb1sm21031116d6.46.2026.05.14.04.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 04:53:06 -0700 (PDT)
Date: Thu, 14 May 2026 07:53:04 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
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
Subject: Re: [PATCH v7 04/31] mm: hugetlb: remove dead alloc_hugetlb_folio
 stub
Message-ID: <agW3oGO8qwWPnbRI@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <0143c5e2086fccb05703500c9269a899d4784768.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0143c5e2086fccb05703500c9269a899d4784768.1778616612.git.mst@redhat.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3726940009
X-Stat-Signature: q6wik3goucf417jjakmkte88tw3dar1w
X-Rspam-User: 
X-HE-Tag: 1778759588-461023
X-HE-Meta: U2FsdGVkX19jdc6fGDI54VitEHwxM6uN2ET1ZbpWYV+26/B+p5wcp/zI1PdkUuSgd79HHqXHVucXU02qSDmp/slMK3d5uvat2Oe2D5hdjK9HvCDdf623xr17aFoN6FIYAC3umszTdSuNs85gyGzhonN1dU0FRefqk9R3MiATzf01JZOWylICpz8uZ+pcJvbuKndKbS4mhYra1lw8FAn0ZWone9gRsQDRIxg6kiUOIJHadGfdixef4WLFXTsXGblN8Dpyh0xHmOiKttSpQJt8XFXHQP3mXPI7WLT7y2jY04EwmNh5qzVvMFYq5YYBMIdXR7c5U6PoreucRCyKLQh313AU4Pcq3FRQ0BRy1i0x71p8kn+xR4POH0CzLfMDvBqIWpMFDQne9LiPHQ5zV6IB3FCpiCV/VAkrXYVjgOOmLyu0hRLWcgp4/b/jpSLiYeJlUmVXntLR+NnfY5wHsZz4RxPw8Nnf7Nh5/UZWzr1hu+u7i8w+rRQrOoBmCscE2UscIODfYFO81DyXuUp8KUnKTjynLL2vaAuW/WI3zePJuFN+Y4TOGE4ZncBOWNgMtnx06OWq7KZIfop9wVZVSxwIzwQLSWAieyZpNq/xX/5KmJ5BYXyKUXZJ+8RQlgOGfU1dkSYvNXuqAw18dpKibbBq91OLnrIVBHGi1bIf01z+eT8ByZ72ZAxGsUwheMbsryqCm1SKMXKS1ug/IDuj7qzi67EaIqAejDFUM+gWPL9cCZvjQqt5PDfxSZ1y7BaOTENuUwAxGEI6fAgm4dO2rL8RXVTNuTwBS1Yf0oukUSIbUN/GA3b7VIHRDTVkEwsYyFrDZANT1W9FzbnKiw9q1YhN8jcW37D9FVb2WE9fXe6dNLWTO2KsokK9TQ1/BBc5gPtPVM6flgKt2BzhQ/RO/bnPO8q+b81QdN6LBuPoT3oUTnfVIOymD8ia5gnRlyLITO9hO46H2M3hqFKgOVJfoTI
 ah1xJQx1
 Jp6wfd58//hIP9HuouKWbdK3oHRK0di7uADJi+AvrcfrCOZ9DZBUdB7ouCAukLGwuvcI4sHwQQR9M8UdxTeqkjaQ9zhp+blP4ePbponQYNrwklmFkrvsjgf4nsaIGQU8xxmBmnfsrP5u/XyjlKeTv0WLeP0Z6usw0c2fXktKayDbOBzJNLNYLX27Tt+UR1Zvz7i8oG6a1ddXkSGxTrOSbAOZiPsXcj1qp1TY5LSL4lrYJP5xiV0Rtf4WJ3/ZoSidmmvMeRAy5OWFpGVHNE9/m6SlvMlveL626e4yhydFA9uB14iZdswFwA38m3oFUd2llluguTxiQY0Z26gen2/C+omGoKrYkMtRSsMtDspJnfftzigwBmZkF7oTIL++UkA349MZWq0+FeshBgsOjZ/9qX9BpJiUhky8UmZYrgYE4L+lDeKsy1712uQJpblsoP22bvhmSQkJHYVgvVab8jFofoaWS/psBVI5naCYFtTamodtS1AhkzKn0yQIZircwbeebs2328eMZ+fJ/qxuBoKLg3LMBmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 05:05:26PM -0400, Michael S. Tsirkin wrote:
> Remove the !CONFIG_HUGETLB_PAGE stub for alloc_hugetlb_folio().
> 
> The stub is dead code: all callers are in mm/hugetlb.c
> (CONFIG_HUGETLB_PAGE) or fs/hugetlbfs/inode.c (CONFIG_HUGETLBFS),
> and CONFIG_HUGETLB_PAGE is def_bool HUGETLBFS with nothing
> selecting it independently.
> 
> The stub is also broken: it returns NULL, but all callers check
> IS_ERR(folio), so a NULL return would not be caught and would
> crash on the subsequent folio dereference.
> 
> Remove it now since follow-up patches change the signature of
> alloc_hugetlb_folio and would otherwise need to update the
> broken stub too.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6

Reviewed-by: Gregory Price <gourry@gourry.net>


