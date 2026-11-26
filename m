Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD38606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 20:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=GF7Pj1ZT
Received: by kanga.kvack.org (Postfix)
	id 9A0306B05B2; Thu, 26 Nov 2026 15:47:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976876B05B7; Thu, 26 Nov 2026 15:47:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8177B6B05B8; Thu, 26 Nov 2026 15:47:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9DE6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:47:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A28AD1A0111
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:47:09 +0000 (UTC)
X-FDA: 85478454978.27.BF6E405
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2D30E1C000D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:47:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GF7Pj1ZT;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of schnelle@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=schnelle@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795726027;
	b=lxvjQrQaLFfpYmb2JQTlKlRWkx0JOze6XZK7GYz9Og3M176atFxQQ480TfZZlkgImB7iM8
	reXMLZR/7n7M8i62D8q2r6r+Nk7O9bjva0g535ZsWGHtPv85XlSC8sVjPycknDDluqGGyT
	Z9HXUE2+7D91TxrNwDIQ+vMB0PyJT7U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795726027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TRZ70z+Z1nlNflbGDjmI948Rj6w7bC+zQbrt4UTlP3Q=;
	b=LiIP+wyGFnMCTDmiTR/qOBNbhbOSxdjN/1UmhRRD+AFBP+jw96wekf4oJxeScyC/MS1l++
	qvg2JwkPeMfUIPRDYFxXVW+CPvhyV2CP3+gLcY23iPWjVs/NzouYfjJWS/i2JClGh/Jwpf
	yNqmijX6LecGm/m/n8qUogbXkPIVIjk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GF7Pj1ZT;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of schnelle@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=schnelle@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQK4nu23683099;
	Thu, 26 Nov 2026 20:46:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=TRZ70z
	+Z1nlNflbGDjmI948Rj6w7bC+zQbrt4UTlP3Q=; b=GF7Pj1ZTnh8wViBir6xRWF
	UkqwEYfqQ8oS5W6b7f3uQvEa9rven3BKvwJm2ur2gxt9GN9fJEhQGBcGLXV3UlCw
	jfWs6PohdUOd+jzYziGb8gnSBai9gkVIyBQurE/hd4esI7vc7SPp3tOcP2P5JyG8
	Aoz9vferby4uGns/9gcH3RQBDbEUxcJHKPSJ/4UHzNKQYxBD1komWPKGeuvpOW/A
	MM+T+ENs78luBhl/Vw0tLNFoJyMgVDbtFE8u17UAILdwBq9Y52rwDO+0uVBRfd5t
	Y5Xevw+kWjSlD6tDQyLlpEbck/3XLMTwfmlDPr97DXOvYASK2ht6xAsOXWsR55eg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g3k34s-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 20:46:37 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQK4K4i1672992;
	Thu, 26 Nov 2026 20:46:36 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j5kfa7rxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 20:46:36 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AQKkZ9o12190272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Nov 2026 20:46:35 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 76C1A58059;
	Thu, 26 Nov 2026 20:46:35 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70BB058065;
	Thu, 26 Nov 2026 20:46:24 +0000 (GMT)
Received: from [9.111.15.131] (unknown [9.111.15.131])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Nov 2026 20:46:24 +0000 (GMT)
Message-ID: <d42bd9452d00a0b2a5b7d6652d556c9fc8d2c830.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Naman Gulati <namangulati@google.com>
Cc: Luigi Rizzo <lrizzo@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew
 Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Johannes Weiner	 <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel	 <joro@8bytes.org>,
        Will Deacon <will@kernel.org>, Robin
 Murphy	 <robin.murphy@arm.com>,
        Marek Szyprowski
 <m.szyprowski@samsung.com>,
        Jens Axboe	 <axboe@kernel.dk>,
        "David S .
 Miller" <davem@davemloft.net>,
        Eric Dumazet	 <edumazet@kernel.org>, Jakub
 Kicinski <kuba@kernel.org>,
        Paolo Abeni	 <pabeni@redhat.com>, Luigi Rizzo
 <rizzo.unipi@gmail.com>,
        Lorenzo Stoakes	 <ljs@kernel.org>,
        "Liam R .
 Howlett" <liam@infradead.org>,
        Mike Rapoport	 <rppt@kernel.org>,
        Suren
 Baghdasaryan <surenb@google.com>,
        Michal Hocko	 <mhocko@suse.com>,
        Brendan
 Jackman <brendan.jackman@linux.dev>, Zi Yan	 <ziy@nvidia.com>,
        Harry Yoo
 <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes
 <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li
 <hao.li@linux.dev>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara
 <jack@suse.cz>,
        Jann Horn <jannh@google.com>,
        Catalin Marinas	
 <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki"	 <rafael@kernel.org>,
        Danilo Krummrich
 <dakr@kernel.org>, Jonathan Corbet	 <corbet@lwn.net>,
        Simon Horman
 <horms@kernel.org>,
        Jesper Dangaard Brouer	 <hawk@kernel.org>,
        Ilias
 Apalodimas <ilias.apalodimas@linaro.org>,
        Willem de Bruijn
 <willemb@google.com>,
        Kuniyuki Iwashima <kuniyu@google.com>,
        Joshua
 Washington	 <joshwash@google.com>,
        Harshitha Ramamurthy
 <hramamurthy@google.com>,
        Alexander Lobakin
 <aleksander.lobakin@intel.com>,
        Christoph Hellwig <hch@lst.de>, Dragos
 Tatulea <dtatulea@nvidia.com>,
        Pranjal Shrivastava	 <praan@google.com>,
        Mostafa Saleh <smostafa@google.com>,
        Randy Dunlap	 <rdunlap@infradead.org>, linux-mm@kvack.org,
        iommu@lists.linux.dev, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAMP57yVZx=s-JXHfQfd_ouv2jV6MMsJXpxVLkQQHG=7qfFVJfA@mail.gmail.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
	 <20261120010655.467825-1-lrizzo@google.com>
	 <20261120135013.GO3115493@ziepe.ca>
	 <CAMOZA0LmZ9PFzxLcc1SuS8piFyZu6P=vX_qR2jy-3QRUoNCUKA@mail.gmail.com>
	 <1f10002ea9ee16a17087bd06e4a1685a973fdf6e.camel@linux.ibm.com>
	 <CAMP57yVZx=s-JXHfQfd_ouv2jV6MMsJXpxVLkQQHG=7qfFVJfA@mail.gmail.com>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 21:45:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=SoQFe/O0 c=1 sm=1 tr=0 ts=6b089aae cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=9jRdOu3wAAAA:8 a=AYP4Pnggl5clyuVTJKkA:9
 a=QEXdDO2ut3YA:10 a=ZE6KLimJVUuLrTuGpvhn:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDA4MSBTYWx0ZWRfX7y2nZhl4+ubi
 FWX5zWRwcAmuzRkuebBq1cTCWDGv+lCPQjK4q3lrBxdZhW7ihblzuEWYgBBzvPLv65ipqxvEHU6
 h6xDrjn860cWaIx+PNHfAzubb/AxIt8=
X-Proofpoint-ORIG-GUID: _NB78zlRf_P9-O9HiYlEA1VklFdHsUbA
X-Proofpoint-GUID: VPHT65VoCiUnCEkR2bZTEbEzQ7dyLUEe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDA4MSBTYWx0ZWRfX453nIMPIcDZV
 hP6Bh0Q4oBItuZwj85YnFNVsNUbGvPxCPfssInDe70gydwYTF9s/2BpwJTkgXzlp1EnS0qAyiyf
 6FgUgG+uIGxfsFPdi0Wkn7YQB4ejP77GGO1D72dLE4sk1EnNSQY97CttoBlRNsg2AwkupyTwbIR
 z7YJGzLN4NeRqjSr9MoAF+I/ACqLUeCNaF4NH2UXer3zmCL70wClyceD4y0r8gHIB1A/pVk6DmQ
 NkjO7MNxXP2BklO0Js6dGgWyMcqC9BhQXISKoOCnmNnInn160t4pgo9Fz8XSgqwrxqjtNBsOgto
 SLCctUSEOER8lX920eq4nq+Fpp2/ssG3PdhLAItMbefpL6yc5LFc0XrQWlTkC7lNV5+4Aedm9ne
 r4SZ+f3EghM5Y80TOBV7rXzqXZ5PjRTs6p3h6jpDBTiaDiovnw5qMQ4Os1VrW3CqDVEuYkyY4tq
 u5kWMw44R/R9oxBCOQQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_05,2026-11-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611260081
X-Stat-Signature: rcber1tuzcnu7y48cjw478i1fi1fmapj
X-Rspamd-Queue-Id: 2D30E1C000D
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795726026-740574
X-HE-Meta: U2FsdGVkX1/raAT6EAs7ELeQpGxKsQRR/r5aqK9Y2lgqJt9hwX4AGBYr4NFVUiCZpyAfP9po34mBLS+f9fA0XYYs3NMlNkI2FrtxsHdk0bBt8c5Xubxc2906C1cIhJKiXjh9PaE9TIPWvMCxZLAEb8hWxy0sVnVFp8osW6SZxBrw72ZqZfEmhisgog6xDFwi9tAdHZI6G1EMMyi41zJ0RIgIEuWVspzi1tSf7bG2ktU8MzHUMYxoWtd1EPf3/WzvQyRCGhVy/fBlUB81snyh7Z7/KQimLhuUkWI55GpiyHAiwBniUs7kgQGikg3CbCveqSnF45p2ewdSS3IMy3DFKs1qJgj7p7QgPChF4mPTqag+kFDo7VAmFy51Yo1AQht1Qhw5ktD2tIGJtr8npvozoQfY6nie78DQUEYTU08xepqkyUIkkH2gZJzUQCRw4ArE3T8gNu9jBGwCUX3gzk91tvY//ZSVdxHPk+4HiWh8KcIsaXWHR29/aWeOmEpmXWyT23iR4eJ2er8Upx8mN93kxBpmO2bl4+kTfpCYJ6MBA2kiDB7YBEMet/UwZLq5LP0c9mCxZdrolKkUI8/KQi/qT6diQ7X0p9u0aXKKcqfAMg1uF4IRs+UWkDdAY3aSo8vhf3NCtdod6DPcONWfDTVDktjrbZQHFU+elzBoT41G/pYs0PGnPOMN2jMHuz0Vfy5PncyKR56vsiTe7jq3g+jJsrIyHP63RcdaU+/1Nnau2tyMacqNBTE6adklKOPSQtzewyaYUht/xmKrFsQJdp3f+2F12kGjJIP2mQWD/4tJjtQzxUcvRpLRq1id+U7DeM7O8rQRFiBNm40uyqJGS/qKShRPYBKzea0kCFRnVzuSjM6BipQVs8xngq7ZzIrqSjx6R4HO3u9yHN7U7NrfC/wCii/iMqid6cZzinBmAH5fb0fekZgczCmO6mxY49swS8kEkrBrOtD6djy2ZJ5qgC5
 7HWVLal5
 Ja6ooWUmxX4HQU31gofgHHggaZoBJ7dF7UnVQCw/iRh8JxuHe+5B9kN0R+oGZwlpJU6Pe/M6UxazRktz//HTsXa6uZv5p1ff8YsFRdw/WODCr60MDawe0t0BMqCjR2jux+wGXScChZTbDw7gqREx3cJ9XE0FcCO3/qZfAPXAq7xz0bfa+KE7nhPiF4134lATHp26BZcOyB7Ldx4nYmqkSrj+uVj9oKda2NikWgirro+pUfI1FTwfNRyS0FADe1faex3rcVIc2d+7Uhb02lT/PparUiKJVDYlR3EfM2f5OkkAJULtv4Jdr1pRCps+RlyrAD/xTOnOgZX3MHhYykDbcCGumn2ftG7c7j70QcnJ6aIC2slhR2xfOXdIK1jfhjwa8M+n/n/qournNw9hEhkgrk7f/wjFwhleb+spQ2ZMtrU5xGdNMfjDW/BbMffgoDoB2YTkcS28rzHXcMo+k6fmKBQduifb5QGiKlLuiBEKB0zkfH+WgkTy+pKb986HzO4SWMnN5VWYxrZWBncLL8EpNZXD1Ltrp8ReaYm7xl5h28BKs6BAZf2bMzKg0HnXMVxMxhPvpY2L4BR5xgk1TQ6miHGn73l8bzJxOUZtx2qGGEeiDUBGVxsIKX7IGsnkugiVecaO1KLlUFJPai6U+o2YkIkHp4zZnyJMvRfw9PuRIwKdZLJKOZ+cyHOeQPPbTAQNaSEe8Mq4vEzCSyC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-23 at 09:50 -0800, Naman Gulati wrote:
> On Mon, Nov 23, 2026 at 2:10=E2=80=AFAM Niklas Schnelle <schnelle@linux.i=
bm.com> wrote:
> >=20
> > On Fri, 2026-11-20 at 15:19 +0100, Luigi Rizzo wrote:
> > > On Fri, Nov 20, 2026 at 2:50=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca=
> wrote:
> > > >=20
> > > > On Fri, Nov 20, 2026 at 01:06:30AM +0000, Luigi Rizzo wrote:
> > > > > This is v3 of the RFC previously posted as DMA_PMD [0], now renam=
ed PISA
> > > > > ("Pre-mapped IOVA Superpage Allocator"). The text below follows
> > > > > Documentation/core-api/pisa.rst (patch 25/25), which has the deta=
ils.
> > > >=20
> > > > I thought the conclusion was to just do this stuff in netdev pagepo=
ol,
> > > > now you come with an enormous AI series spread across the entire
> > > > kernel?
> >=20
--- snip ---
> > Now, I wonder if we can't start with something simple. What if the page
> > pool could start by allocating in batches of PMD sized and aligned
> > folios of contiguous pages that can share a single large IOMMU
> > translation. The page pool can then still hand out pages from that
> > batch without having to do sub-page allocation but would already use
> > much fewer IOTLB entries and the locality might even help non IOMMU
> > workloads. So, I'd even hope this could be enabled by default and this
> > is actually something I don't like about this series, I really don't
> > like having a tunable when we know that larger IOMMU mappings are
> > strictly better when you have an IOMMU that supports them.
> >=20
> > I think that approach would also align with Jason's idea to keep things
> > within the network stack and to work with the tools we have until their
> > limits become very clear.
>=20
> Hi Niklas,
>=20
> I have been working on this idea exactly - extending the network
> page-pool with a memory provider that allocates large pages, splitting
> them into N smaller pages that all share a single IOMMU entry. I
> breifly shared my approach in the v1 PMD series [1]. I'm readying a
> short RFC to share shortly, would appreciate your feedback.
>=20
>=20
> [1] https://lore.kernel.org/netdev/CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69trm=
w+BJRVYf3JB1g@mail.gmail.com/
>=20

Hi Naman,

This does look more contained, but I'd say you should still go simpler
and fewer steps per series. Some thoughts:

- Drop the CoCo aspect for now. The shadowing / virtio-iommu and IOTLB
performance aspects stand on their own in my opinion and the focus
makes it easier to review too. As Jason said it's then really just
normal memory that was pre-mapped for DMA.
- I'm not a network stack expert but I think using the page pool for TX
warrants its own series. Maybe just start with RX, this is also where
we see the biggest performance issues and it would hopefully make the
patches at least a bit more manageable.
- This is still a LOT of churn, my gut says much of the benefit should
be possible with much less churn. It's really too much to follow but a
cursory look makes me feel like there is duplication between rx and tx,
which is weird since for the pre-mapping they should be quite similar.
There also seems to be very little integration with the existing page
pool, rather it seems to set up a parallel mechanism for the pre-mapped
buffers. Really in a first step I think we "just" want to use a more
efficient DMA mapping and contiguous memory chunks for the page pool
and also keep the page pool API unchanged as much as possible.

These are only guesses from looking at the GitHub branch a bit, I did
not dive super deep.

Thanks,
Niklas
>=20

