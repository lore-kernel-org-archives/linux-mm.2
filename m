Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA06CCD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 441FE6B008C; Wed, 10 Jun 2026 23:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F2E56B0092; Wed, 10 Jun 2026 23:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1FD6B0093; Wed, 10 Jun 2026 23:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1953E6B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:16:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B26BE1C28CD
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:16:34 +0000 (UTC)
X-FDA: 84866169108.05.900E40F
Received: from outbound.qs.icloud.com (qs-2003f-snip4-11.eps.apple.com [57.103.86.63])
	by imf07.hostedemail.com (Postfix) with ESMTP id DB5374000B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:16:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=wOctC8bb;
	spf=pass (imf07.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.86.63 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781147792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cx5WsLzy5EMop1LAYacetf6b3lNRD+oGL1mjgLaY/us=;
	b=fkjDdOckaltsq6Gexl2JZpMf1hFxDA3Qm2WhhH9b6XPjTtTXb3vcszP1+CVTGBmlYgp3dD
	GJ0y+Ue46pohIHNhwiG4WKO6HuQKnS2rMg6e298DuSGY2q89jC6Fo3rpPi9Qi55MypX/ph
	j7IyxSqHRBdLSA70ruqeqAUTZBzfW8Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=wOctC8bb;
	spf=pass (imf07.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.86.63 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781147792;
	b=sjtAtm3Bpvq9hcwWrUGfgtj4YyBMWR5te3YX7b/Yj04kDC6vp3V5KIf9eggUjiFcoq2sra
	OBUDrFQJLoOd9gge1Lt1K0Vr5g0xylwczi5KWs6XWi97Na3Gry+O9+IbKZDDWrNkS7PfRj
	M1SP2RdAnGZkSeZLDpTrasLhsE2W/SU=
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-10 (Postfix) with ESMTPS id 9639818000B0;
	Thu, 11 Jun 2026 03:16:29 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1LHVwEWRxBDUkdXwdLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAVhbCFsEDx9MDFECQgVWXkgLHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQUZWgJYAnwJdzwBPA5dUERTOH84fCpwMXBVfi4GVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1781147792; x=1783739792; bh=cx5WsLzy5EMop1LAYacetf6b3lNRD+oGL1mjgLaY/us=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=wOctC8bbl2IalnPoB+hZO6LmlxEnlUSui8CDAdSCXG6pAX/0JVEUWP4J7UM8Ihob1LcA91MJamQXIqIBd9Z7HNBqLK5Gk7g8A4G8FDH7QoGsqJUTRTJ2y7gtaoxEDTX/i4oLNSb1wg6GrzyLUG0tH3pE3KzEGCf4TzeE8mTho8W6mduv8M2uxEwOcXhwqeHbZfotwHfDtVB3z+FeUgW0TtpK9e/Enr7WPCNCiyRIaNXZEmekW3yqdikaFHXK9z3ipTwdcU/gixmOFQrkXTThWhKOMV1eT8oWv9GEJ0/Qqar/PNUfaosnGIyfbESHpjzUjX1zwo/iS/R/UquyV3r9iA==
Received: from localhost (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-10 (Postfix) with ESMTPSA id A2EA1180058C;
	Thu, 11 Jun 2026 03:16:28 +0000 (UTC)
Date: Thu, 11 Jun 2026 11:16:24 +0800
From: Luka Bai <lukafocus@icloud.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org, Luka Bai <lukabai@tencent.com>
Subject: Re: [PATCH 2/5] mm/khugepaged: use slab cache instead of normal
 kmalloc
Message-ID: <aiooiNyND2Q96b4j@LUKABAI-MC1>
References: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
 <20260531-thp_collapse_hint-v1-2-e7f8c2035621@tencent.com>
 <d4636be2-d9fe-4464-99d7-b0b9902e6b52@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4636be2-d9fe-4464-99d7-b0b9902e6b52@kernel.org>
X-Proofpoint-ORIG-GUID: t5BKz75ZnySRwTvBBiKMnByvzccKJ5w6
X-Authority-Info-Out: v=2.4 cv=EKwLElZC c=1 sm=1 tr=0 ts=6a2a288f
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=m7Ui_3NsPc4YXKPq_aYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDAyOSBTYWx0ZWRfX4l+a9oFbl2ox
 b88Qc2+ZGmKn++3zFz882O+a9KPxBFQ3YHYIW46q+0JhG5h8r6Cx4c4h+SI6IZZdxv/+q3g+SeO
 wv2x6YY9/NY2v+vQqPborxdmenjriyGjiocUi5Zxr+9TwwASzEM7VZ9S+MCiELPuXRgG+jESZQN
 TEDibLodPu3OcTE3eXqkm6g948PJrjS+LD3Hzmv8alpc+qN86XQjW8Q1qAbP5PlE/p2W1O+dV0P
 Qf+zUZsMtD0GuzpQmoaOMsE3ljscNkv3IVl7TdUeIAZXee/MG+iQmxktBk3EjGPjS0gA44vmOhv
 hr7Qmd04d43M164WJ89sTL0Mlg6bFR9IuYBxsdwsySpR/Qiheq2RvXwxkAA1Ww=
X-Proofpoint-GUID: t5BKz75ZnySRwTvBBiKMnByvzccKJ5w6
X-Rspamd-Queue-Id: DB5374000B
X-Stat-Signature: o1mwsk3b8zsdssdgiaey83rgksecryy5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781147792-998890
X-HE-Meta: U2FsdGVkX18WNZlDlxfz5BfWF2ki4Bomqtwqz/Upr3sqQr9ZkvfiolzQhds+OLFeLt2CJHLNX4Y57pnHtPlrBV4jkGUpPToD3gCHL0IdJuC4kHskpVN/rdOvKJgRb03T3/vdi35Wbtf3Hmekst8E+e6XLO2wjWyan1tsDc7eMH54Fi/C6fPOXM5qBRA4T5dB8F9R/T63Kq04J5oQkATLlN8e1SHCwFOnFDe59Jbi37PCVsyx4076LeSOT98uochyx88zSgbiW/xSMSX8hDYle4xHiJ2VsfxqYYjFuKOn4vjl/ChTz5dpAbJTJFw/fwi6iMpefYhHegCYLZgKKpeAp79hfaj2Gs6HNmDiLijunxQ0j53TlM47wJyCCIKvz2UMBxV8FAkxcT9aqHfiFTP/xnmbS8JfaB/uMoFb7ygFzZdEmHiR9M3i0p9y56WQVyDYo8aDVY1uzDBbP5ZIodQkOfnKvqZ2qOTFrwzNLqw7G71Jn1xryFNnExyJ9Rt28NWVLUUpvHjOO1RtbYyQsP4fOzDRkgBPbleyTexfnXHkv6gBWLQxioM4jWrRASBpMysUUZplZo2B/GNb6ZcPPd3Hq1zGHABEGFMJSrUHjhyQpRro6WQZX+v8I6rJS27iZ2LrJTTWVN4dNM8U2+Pwy/RXZsX3smHZ20YMWrQRH38Q9EODFVbnHBVljmX37FSzDo9s8cOhL31iFF35KXlpPCqHeOEqZSQWWRFUowYTLqcutxcXBm8aFfpQXw5BF9G4XlkIln25hVwMlwZmyCyjQK55w30rsvTfqYWweCDo6SOYnfm5tsDjial7ik7jcTm1RxoiUZQ6BhBBy9G+a/7U83RSd8SJLHUeBvS+uKAFnIlY9t/MthVLJQjKlMkmAJ4C7H+pxLtGWlSAuq0dR/mG3R/o3AgVLC4gWvTzLcUcdYFt/A+pjaL5TZ7se8oggXheBqVDxiblD3f/R41mPthVpyY
 UOG15+BT
 1qOH9dVtjclpgqF2GNSL9Inbaq+hDjaSxIaFsHzWHMAQxhkNIzEn8Xa5Ei2wefdvQ4YubnDe2B/7/Fqkxhwi/81tnjpI9LU1k1ctoOdt/HsqQgLTsdOUbvkaQNWyOwB3ners4q/LriR556kabBcOdfBYPicH6EtIrPayNWYgZI3Y1vDKXV7K3ZMJu8qzskknnYm+eRnHq76gP6Gsoh8MEbikenj+4jCLofT1scJiuDVyvwGX/GobDUki+NoDDKqpNkAmlGPpYRS1ZiyJHpRg7AZvfcmkxYEkvyX4gBgGI/y0kqD5TlE5Pkm4YMumK0qEhibMgkYoV+xDFKvVn+wIVDMw7o5kEPoVauDG0nCtLxABV/snjU3C2RuvdOlkIxcfe4rbTWKZNkTV6BkH+GKQnrmaWmTDYYmGuXbKyJKv5EWmdYkObPUCkJSUs7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 Tue, Jun 09, 2026 at 12:26:18PM +0200，Vlastimil Babka (SUSE) 写道：
> On 5/31/26 06:23, Luka Bai wrote:
> > From: Luka Bai <lukabai@tencent.com>
> > 
> > We added a kmem slab cached called collapse_hint_cache for
> > khugepaged collapse hint, to improve the performance in allocation
> > and freeing for the hint structs.
> > 
> > Signed-off-by: Luka Bai <lukabai@tencent.com>
> 
> Khugepaged isn't exactly a hotpath? Adding own cache comes with memory
> overhead, so this doesn't seem like a sufficient reason to do that.
>
Hi Vlastimil,

Thanks for the review :).

Yeah Khugepaged is not a hotpath. But in my implementation we will allocate
those khugepaged collapse hint structs in other paths like walk_mm() and
lru_gen_look_around(), which may be called more frequently under memory
pressure. I'm a little afraid that directly using kmalloc may compromise
the performance of reclaimation... What do you think? Thanks. :)

Best regards,
Luka

