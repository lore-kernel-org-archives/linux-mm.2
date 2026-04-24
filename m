Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D698AFE521F
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B68C6B009B; Fri, 24 Apr 2026 08:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D246B009D; Fri, 24 Apr 2026 08:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3176B009E; Fri, 24 Apr 2026 08:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 259296B009B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:30:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BDD087632
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:30:47 +0000 (UTC)
X-FDA: 84693383334.25.EBC3918
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id 27C0A8000F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:30:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UFHuXimq;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777033845; a=rsa-sha256;
	cv=none;
	b=cm2bBIhBuQkL5BWbrIWAZOtDAGdilk7ZrJp9JjHSm/IxjYY9Ou/hz0Aw9zZiuFBCCxcd1b
	ZM/Sp+2wgWD4+qrIgyvQeDTLHCWyl3waDFakGTi2gM+APOZjvrvzqnB70LxZVtzp7U9BSF
	J0m81tYXVW/LNB3bTmkXJhWInFFTj6o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UFHuXimq;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777033845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17ilqt7I+TGyWbe020Z7XWSYzkU4sazN3E/IBcELplc=;
	b=3Hj+IS0t4qz9I12SU+GbOllTkWSMO4gXBPvVxwnZMg+Tj0KK3TD7JB85uwvsfWuyXuZYwe
	rHxyXqlPipV1HTcxfMtgWF11SaDx4fFPqpewJLcF06g8MdGK1Cj3H/PsCS3DyysuX4UlyI
	EoyJapZkajt8cqpyoe+DwMJoWg4YMqM=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50d87c138e1so79467471cf.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777033844; x=1777638644; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=17ilqt7I+TGyWbe020Z7XWSYzkU4sazN3E/IBcELplc=;
        b=UFHuXimq7YAwBExzzR+fBMgYH6KHbKKhdsKtQ9n5ZX/E2tmrcQBM9cBLJ+U4xhwavM
         6VZyZjAv5v6/Kl3tqX/NH1s9Zq8kH5uUGt4euKcCrUJX6W/HVFm4WRckRcJ5yFGUSHVQ
         Qz6daG0k4davtp7+XwldweZDhiRtMFvgus28TnIf6mtBaMKFg8oUY74nmDrvHAj1Kz+G
         Nl2vQ60I5rwS37b/LVjy9i9hLfBKRclrmZCNTNy++aCihvYQMyvqTsjivnSLpR0FUbjx
         GgmrxSjl2mZQGClTb+8E+leRwt/zB7T5/sdwrB2qFm9y92lnQVdEH39okJUJnnYmW6sl
         Nz/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777033844; x=1777638644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=17ilqt7I+TGyWbe020Z7XWSYzkU4sazN3E/IBcELplc=;
        b=H5G8pUTCPFmKCVmhaz3ha7qvu//ZKqNPFpMtgaucph/yMuk+8+rCvX8+FGFlEMkUG2
         +8vr76wRN67Fx812Xv99FZz8wv8yv1M73kWUc3abIVfb3rQ8AWCsIo9WBnza6YVZBS2o
         H5hLv6xJQ4FDuaYipgO7iRIPLEsAjAPpkzK31e4ol3Za2opyHV/ETegCnnLRBF6xMFvY
         +UF1zup8kKUR33iI4hj7w7KeRlN4Z75xMN8b2dB3MJuLKq1I6YwmFwyuPJum42Zz8kSk
         tnh2XJMv6GkRK70l1P3dWbNPlVW3QWZZSFqzgYZfdhEptf2RQOKKlx1dx4SFs75w77jy
         yRdQ==
X-Forwarded-Encrypted: i=1; AFNElJ9IB3CIPDCym4+/TGEQfGqagyOCGYbztPYmsul9ohpK/G9k4yB6O+dYJcdGC4PHRjZ6X8BU+DU1rg==@kvack.org
X-Gm-Message-State: AOJu0Ywu7V+k4rODRr4mRUskMS2dTauyhmas77LnX3xDlQLIw64YDqah
	RQ8ed1Y4KNbUAPd167/Tz9pFPHUXAMxU0YEd9dry3ELsQDD38GsOunU69PupKZplqZo=
X-Gm-Gg: AeBDietKgRYlGuWhl+ZBDDLJ9c1ya0M5qrb2WNTKBYQcMfqqPmIo/g16oliaNFeFB4j
	w7/J5j3AwKKKiq4ZDvXhJO1PcOE5foRWNIM0ZBUPq5shb+z/UYbX9JtpFv/X4PcJdtolSgrNA8B
	UKxhpbSwXzdD5EEwRXmEoj7uV9hH9fXhyDG8dThEXUC++Tp5XyHoNDYdXiSULycrEmKfOVILyXO
	+/Jc/MEwbxXSSoX3Q8mMVzXoUX4qPrOeZcx46nCyKAOeL0YqfFrhxiW7eRWvkBMwwrazbHkKbMQ
	XQ9aD7mFm4shPVRiU6ANAHn3w7mn8xecWCj7xGMpucncjiI3H8rzxjRXcYzHuxVCetS41EbqI27
	Tcy/IezC5B1psWGcCfQSxk9IZrr0KluJRF7S53jTqF6htrjx1qvo3IKGv87ltNO621pkQzTf6zE
	moarEb7Umx/4Fz2druNEyYJFR1YVip2t3h+gdHThTWAWf/g2Uz4jJniDc/PEYJh19UOZ37OH18u
	0jOzw3TUE5x6koPYA==
X-Received: by 2002:a05:622a:4f89:b0:50d:9cf7:18fc with SMTP id d75a77b69052e-50e5b19c3c0mr269700851cf.11.1777033843835;
        Fri, 24 Apr 2026 05:30:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-70-94.washdc.fios.verizon.net. [173.79.70.94])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ac81a9dsm184499016d6.21.2026.04.24.05.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 05:30:43 -0700 (PDT)
Date: Fri, 24 Apr 2026 08:30:40 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <aeticBh5XlAlD1vn@gourry-fedora-PF4VCD3F>
References: <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
 <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
 <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
 <20260423074433-mutt-send-email-mst@kernel.org>
 <aeohzbmhQAoOODPm@gourry-fedora-PF4VCD3F>
 <88b0765f-7cfc-4e44-83d2-c01a1755c842@kernel.org>
 <aeozRZ9AvW2jTQkX@gourry-fedora-PF4VCD3F>
 <016cc5e5-044c-46c6-a668-200f90a64d85@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <016cc5e5-044c-46c6-a668-200f90a64d85@kernel.org>
X-Rspamd-Queue-Id: 27C0A8000F
X-Rspamd-Server: rspam12
X-Stat-Signature: z49bibcfqfc9uc8txn1r8zfr4wfyokg5
X-Rspam-User: 
X-HE-Tag: 1777033844-462964
X-HE-Meta: U2FsdGVkX1+dF5FMVLqc+NaXlTLYWp2Ih4GnlGSditCXuy4vDBnYSAUsoQ41j4twX8a5Le42DQrsw+YvrqLt3iXzmiTbLzwLK4Iunmz/WhwbF25fiukmYeM63eLb1ZMBvBPPGWlEzaw+hCz6d9BM18v3y4UJOG0dPiq5l4h77utu7RGyPsz8vRAJXoX6L4OKW4DO/YjvBnl6DbM4RrwllcuSm9loTxyhLTmIveu1AUlIWvotQTADC9ETvPVkYWT/iuLQaytZuV5krwphvfc3BGdRbxbSwUE8xu95K/eaEiBJBGwnoKLYiW1IXxE5Dd0ISkcBULxTJ1L8Xq344uRvf4ds7pJXpQ7kB7BXRTFo2nCpAqVU/eNGj83moImq8jDP8yK4/rNLN9NulErCtfuihLUD7BgUEbgoaV4QclLqC565Z/xtd1fh77kmVcUXfxjNVFaKr52PWABc0TP157SRIbQxE/9TeHBGggaMp0MVeIQJSUc1+YzDNG9QXpqfasjoe1hEBKealsP9ZhRAw5CbM+50NdDCjw94WAq+fsQrWEUTeT1Hsq9jvGl7SJNB0JrE4/jV0VzBBnDmXhmcjL/ragwg+i8Hh0tvHYrqAAkr+JsBWj1i0B+BQFE4aUZDjbcszBPC7nD3CvkbJJdAhlS4d4HOrncC3pTf+omnOP2TximElrpnrHElEqhRsi5H1AdSBC91T+XpYOZPm7jvaYQU5VsNOMHjAvfDm0cZmnsJ7OxXChilvgBWyl0gM4GjCHbG9IeasdlKJf8NAq11rXwcIk3eyfGiFegfU3ejA675GaQzr8oI/0ki9j5AvWJ8tSNJQtn28H6WXVkX9XpYCkRYaIiWKFp1sWUMftCS9WFhkruBaO3ExAP5gdsW1ZFJ3vrFcvhy+wVztqyeAW+lmkN2+HYoTNcgtJM256giM0ZQ6i5H6H50eQdG9rRGrLaARagzym3e4O/fU8nOnw0Tc3A
 ze8UIphZ
 NU9MTdtQKb1KDbrT7gOX9Pa8gIgtJx8usRCAWZriI6TliZQjZBzhUIR5p1BzTWoYn8sMSWt9vAUb3Yh/oc6bRZrQxi3GoUXEPE2J4MQE8eQEzlD30nMH6mRtt6yPq4NXqjYyedMCfRn1g2IcnJ9zcl+5/U36QF6yas6jxQJhe86KfFw3rHZ1BtrZp/DZyAbed62zP3RY7oTmaZbsE1MAmMYpLIg2XhPe/Enp/R1LW0sKfFumvk15uY9zLqwFOslnsaMFFU5J813sSdkauAfW0Yglhy/J953h+fYi07tQ69Lt/s3CKAl9dTzAHBIYU2hjy6dFZCnlmPzQlRw9YPbaPFpwdfYogYOEYjGH/J4b1w0z147/6ZLlxj3ci1oe4e6REdMHfif+6yw+I00B51kKuBI6+y9FFFCEYfe1xhlWejLHguZCOUtQEsoTWqHNGmTzmGKqe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 09:28:36AM +0200, David Hildenbrand (Arm) wrote:
> On 4/23/26 16:57, Gregory Price wrote:
> > On Thu, Apr 23, 2026 at 04:13:50PM +0200, David Hildenbrand (Arm) wrote:
> >> On 4/23/26 15:42, Gregory Price wrote:
> >>
> >> Maybe we could forward the vma+addr here and call a vma_alloc_froze_folio() if
> >> we have a VMA+addr to have a clean interface.
> >>
> >> But really, that hugetlb code is rather messy. I'd vote for leaving hugetlb
> >> alone on a v1, and focusing on non-hugetlb first.
> >>
> > 
> > If we're ok increasing the buddy surface this way, then I'd vote for
> > only updating the exact interfaces that MST needs to update for his use
> > case in a base set of patches, and then have each additional updated
> > location (or logical set of locations) updated in follow-ups.
> > 
> > My initial go around with this - the patch was hard to read at best.
> > 
> > But I also think we should also seriously consider not increasing the
> > surface of the buddy. 
> 
> Exactly, that's why I am saying that vma_alloc_folio() is the only external
> interface people should be using with a user address. all other _noprof helpers
> are supposed to be internal.
> 
> For hugetlb, we might need another interface for frozen folios later, which is
> why I suggest to defer that.
> 

Yeah I follow now - we're of the same mind on all this then.

~Gregory

