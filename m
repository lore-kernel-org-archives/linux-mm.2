Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B93F5CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 17:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1E9C8E0122; Thu, 30 Oct 2025 13:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF2C8E0089; Thu, 30 Oct 2025 13:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE708E0122; Thu, 30 Oct 2025 13:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA2F18E0089
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:54:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 439F656B64
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:54:26 +0000 (UTC)
X-FDA: 84055530132.04.90BD0F3
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 465B7160013
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:54:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ioAoAJ0j;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761846864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnGHUYavdaKYzYofeQc3x2iVgQ4gD7UndQ+CtCjwQis=;
	b=0DhWsoBAwjuWAfUpVoBhSco4XW8L7Utm/lhId/DBoFPEBA2565D8BDlsBOj/XcQUVuREhe
	19Y+DyIPX/lmKICiWGvrVbaHdqMvf/5HnckIB3lLQHTvq8yoxPaoEmv+wAiTYStwPt4mO4
	sm6E99QKPoQUUdsXUnyE3nJvrLorjJc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761846864; a=rsa-sha256;
	cv=none;
	b=MIijt0gwJTA98orF7u59FgJGshVQ4eFROCWWyp+VyVMPwguBlHEGuahvqUTq0lUNidXBWE
	hyoJM/IEiDWKw+y4n3F45hC6GXOMItBoUu5jrdGnKeWfwTIjWxqGoZdwJhWEBbtXO8laa1
	MSo2CUY9CdF2HVQ2uDH/cbW4UJHKXr0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ioAoAJ0j;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-7ea50f94045so24911036d6.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761846863; x=1762451663; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xnGHUYavdaKYzYofeQc3x2iVgQ4gD7UndQ+CtCjwQis=;
        b=ioAoAJ0j8p1pFF45PLwAJxzhfnQ3mBnZoavX8/Qf3B74Lqu8dYec0H+4FvQoMrdDaf
         7dAiBEyMbdoYMICXf1vKMrUabrUM7Jho/vdP4tWYH1MNbXARlhv6aekIXYLN+L3OzMRG
         h8ePGvCby0/JrfoIr54ffx0FZIwIWElmV7xDQdstMI5dBB3bkenEsfVbpOCPqxLeGboF
         66wjcgYgwocXvU+b1Gtxs57VszwK/bRvJNw34ffltfypLohxzJ+nLBIKb1nUU2g6naRV
         ffLWENmE5a9MLP5BuZ6YTGNZMk1OzUrva3hke0WDz/3du/JW48lu7QPFgzTyYC82+jyv
         jtzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761846863; x=1762451663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xnGHUYavdaKYzYofeQc3x2iVgQ4gD7UndQ+CtCjwQis=;
        b=iy3EN5U7iSINX8BiqYVsm5L1osTJS9m4a5pB89I6DKjukKqegqdGJMvjdFa7eHPcpg
         VEKUZGo35rL5flHoOfkxbYKHCt/EnYKDm/qOC0I8tB4sCHOM8ZUjUbGzo1zW5ui+R48Z
         cmKEx/DufTq9eoaUBRve/tPsBkuruJlalRIKROwYyYMBUzFq3UyP2xqOLD4q/YC9PqSQ
         eL6H29FzfJ6hGMoMce+MIzM2f/U6PvgXy+nIJvGTD0oLMPTc1C2Xp6/+fHMOIBG+uz8l
         QAOOx3K+XnW8YXzffje5jrctRvGGLgchzk/33vFQyRNDzCfj3VooV8wnfy0gwhBKX3r0
         TKlA==
X-Forwarded-Encrypted: i=1; AJvYcCWghpS020ia5TfFdrHrjDvbdFnHIEehZm+Re7nbv4Fnn+g56oq/iyOgt41dFlPxHdyF0lvvZhT02Q==@kvack.org
X-Gm-Message-State: AOJu0YzTexnwmhhnzVW7lbnQ2JaSc900xEHEkTLTgxD8ptdatoG2PzCF
	raqbzY1cUgPyZMQLbc1LKeG8SJu5h/nbuQdwOv+p+viP7DBKZrqryg53CZQKRU8wG2U=
X-Gm-Gg: ASbGncv3E2zIJIzskvFuPMYWq7z3WOUF+URO6sxwD2U/kH9RxDRoO+ZowBLTyA2Y+Xy
	HXN6RK7rGkHzmLUm6W7RBpl3vIaPAOUmBffJc7V81tSknFH/ggViu77LYkP8Xhm/CLy+namJnr0
	4DFY06PPIVWCRxSs5Bp3MFwlrdRJ03UZxQElMnyDl/vSGYJuS+5qTGW59P7xiPAjVm/665AtE1S
	uWJqNY9rOyt8Wfl6FJHUU+WYMZmiU42p/YVhGaBGhWRAKWxV0dRp4screUQxBURAEgYPsGsyxHK
	Fbylok+PG3EmVjQgsbWVZScQyJIxkPNirNf9XM/eyBarZWBRoQvWKToC3TkupQeSCH4TVUNZ+vJ
	qwkWvWi58df1CGGiDx3CmrnsEKLfin5d6A7vq5ZlEJGmqy3Ux1+i6xz+CccDgybqj2aUyQ0aCQp
	0dx3R8PO1lYE1sY7d2suIGnF24mu3gehXFcx4fub61mKhM+g==
X-Google-Smtp-Source: AGHT+IFT5Fmbku/PhtCEDW1KeFw5jyVfP+ejaWvNde5H/+ME0TqKpHB8wRouWON1EINpWnQqdBBBmg==
X-Received: by 2002:ad4:5ca5:0:b0:87c:2095:c582 with SMTP id 6a1803df08f44-8801aca0a1bmr63713946d6.18.1761846863017;
        Thu, 30 Oct 2025 10:54:23 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eba387a61bsm115313061cf.36.2025.10.30.10.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 10:54:22 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vEWqr-00000005AuU-2aX4;
	Thu, 30 Oct 2025 14:54:21 -0300
Date: Thu, 30 Oct 2025 14:54:21 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] mm: introduce and use VMA flag test helpers
Message-ID: <20251030175421.GC1204670@ziepe.ca>
References: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
 <c038237ee2796802f8c766e0f5c0d2c5b04f4490.1761757731.git.lorenzo.stoakes@oracle.com>
 <20251029192214.GT760669@ziepe.ca>
 <0dd5029f-d464-4c59-aac9-4b3e9d0a3438@lucifer.local>
 <20251030125234.GA1204670@ziepe.ca>
 <a7161d7d-7445-4015-8821-b32c469d6eaf@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7161d7d-7445-4015-8821-b32c469d6eaf@lucifer.local>
X-Rspamd-Server: rspam01
X-Stat-Signature: 5dipdhiy47my7iz3d8bxj8t4c64ao59m
X-Rspam-User: 
X-Rspamd-Queue-Id: 465B7160013
X-HE-Tag: 1761846864-516327
X-HE-Meta: U2FsdGVkX1/Zz7tmiYDvq8W07y1BiKLGK3n3K39z5C+Hn62c4V+x4XYOc8bOa9i4qdSdhGIVy52qrKhY8IisHUDSuH/0DpggDVxRbv8aqKdPG92X1OzhJAsN798uJ6DbDlOTHLFG5xcYdvm+bdCzuXE5GP3tj0JpOTGcO5nJ6Z2clDJnafBpJ6twQh2m0DDuqF8iD/QG6E6YH/8rZmiYj/wP14XN+DEkVyz6ivg1F0vsmCwxq3wpq1nRyGeNLP1Eo25pCBAxpIj7BkmqGDsF6nG6hT3iT+O3Dp7ALtUJ73t66naIu519kpHTXK+iiIY6vuCcLkG3uc2EDM9EFV/nJm2OJeo6GqUazCUHlBdzPB89DzegqxqjxCTiNAEw4odaEB7pwFBC7UXDvadDjUvb9dnN9FMi/fJBxbJQKXIOLu9wKAIyb34AexzXbwE5oV2WgvoJ0lZ+mU3qHVUHH7Mkncwde+gjcKF8fzOi95kWIKhNPqBuN7ATOPpsRGMNnyz/fp7Dh29QIfzeigknFcLDPD2p5vA+epYhoX8lA7vNO/58VlWnssadRjE9kPs56cibD5fYM73jE1vyUGdvYjuor+WWQ7B5C9TI6zJx2m3iBW0DUJreZyyixmDTmHcaoQ276b738slBvkkC+fYJ4+/DO82wGiennqpnkflSkfZ9fxJa+KVUUGDAh8Fxv+yQ9fy9eJBLdMXa9LqM7IhCHYnqm1ujkSE06bcuUyF9XxauETg7H/Ezr3flUqviDcf7F03KeiMF+H5TIKeOluOIgbRG0MbY8DAiAC/uNESsn9VaMbNw4+i+c4f/YJO9PKkejGQKSgbC21BAZlVG/fRpD1x35QYGgHaV9wqnSWfy3kVgU79HqzkaInUn9Ox3uwdEcP13U/sCKzrAIFU06xlYIpc+QqeP+KvrVH509OqNkgIjZ6zEgIGP+o/9en8QYgtEPDo98C6s+r9YqPFVyzjRaRd
 1Ls1KchR
 uL4gxKdNFpPjRfYHeOlA/w4Szr5lcOY3jRv+/FfdMMe6NU5kDvrZm5PfZ8SiCF1N62vVx6/F1TRfhS4825KYfWaKUy9flQAB6WJhLsCGgYMOcwOk3GM1z/D3tJD2o6fIqvkNPprySjdb2kzbhI1P5zfbWFOdE0UY5C9DlqlBNbdhOamrF7JRVny3DO1YdrDdjIL0pcLBqrG/KbB+0ZoQqEsuI+VEN1llOIS+CddxJRMGFbxtE90jU8ViI7PEWtxxvwg8xYsmEjt1MzKg+ky7/fiXOrihOw25O1xLMc64Cg9mgGVpCSFr/n1HPP5gaKcJlQL5fEa9b4L0e/6U4tFdTX9tuqpRM8Va4ycR65ncxtYe3ihvamyQfp0i0obK27m+NC5f2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 02:03:02PM +0000, Lorenzo Stoakes wrote:

> Yeah, OK well your point has been made here, the compiler _is_ smart enough
> to save us here :)
> 
> Let's avoid this first word stuff altogether then.

I suggest to add some helpers to the general include/linux/bitmap.h
"subsystem" that lets it help do this:

#define BITMAP_OR_BITS(type, member, bit1, bit2, bit3) 

returns a type with the bitmap array member initialized to those bits

Then some other bitmap helpers that are doing the specific maths you
want..

* bitmap_and_eq(src1, src2, src3, nbits)  true if *src1 & *src2 == *src3
* bitmap_and_eq_zero(src1, src2, nbits)   true if *src1 & *src1 == 0
etc

Jason

