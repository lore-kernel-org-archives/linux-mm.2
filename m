Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F48C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D83B6B0093; Mon,  4 Aug 2025 09:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0676B0096; Mon,  4 Aug 2025 09:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5EB6B0099; Mon,  4 Aug 2025 09:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0B1F6B0093
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:39:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CEA491DBCFC
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:39:33 +0000 (UTC)
X-FDA: 83739182226.28.4B4D822
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 904DEC000F
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:39:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aAVFTlNd;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754314771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUyTG6aS9q1a0tmKCUOqPG42vT1QYZvjXAgeWspdS+8=;
	b=tDR0WvZOwX9NOn3xLO9BxYHwXDxx7eclEH4I9VmI2xAqG4p3EkQgV7ftAEX2uHwI0xeOlT
	9qiZdpdcrvcofcUuzhG60pXqJd89mRRrzJrrM9RuA/HaGxk789bWq475VaHP9pza7KU0rC
	2CtmmsCIhLew8b86lXGgf5G/isVjsKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754314771; a=rsa-sha256;
	cv=none;
	b=Hz64kUKAJzguetrYsJCsd2/z8ohhbr5uWcJ+mQbhn4JgK5qvYPSMH/tWU1W0nFzERm+8Uy
	oLmr8FGu9XUbcnkoS+ovfh8+5ZDSor9EYAaW6J9LUm4TZ019yY7+ZrxPh9GCNkh1SywrGR
	g9zlTyXILDNqRes84ziUe6O5vAzrhhk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aAVFTlNd;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5745u2Lr023854;
	Mon, 4 Aug 2025 13:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=EUyTG6aS9q1a0tmKCUOqPG42vT1QYZ
	vjXAgeWspdS+8=; b=aAVFTlNdwg83cVTP9cyUcgJo+T5AfpXbWqCsamUqpIfMWY
	I7l9jRF2F6Pc/lcGoy1a2bFgFqRK25Kjg7EVtqGWu0+LwhEShUYtXGqBD1lpdce/
	AhBQcUERnEESEk1fshzPCMViZlooexDfy3YbE7IDOVZyTpMnMPneYPe8xslrm0yN
	auxRLobt4r4FJcFYhz2HonlsX6h9QM+iBh7AIOgFYMyEVCHJkCMBFZJ6wBbT4Ds2
	tXip7bovQr/t/JUBLZW8zQEOCukQvT5VN+Ido0kaSxtJP9pTvzGvB/LLveRB68Ca
	SbBKAkZl+8YSgv/P9VSN/2HcVB9BtZNQFHRH+JqA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 489ab3h7qm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Aug 2025 13:39:30 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 574ASL6V006876;
	Mon, 4 Aug 2025 13:39:29 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 489xgmdys8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Aug 2025 13:39:29 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 574DdP7h20447534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Aug 2025 13:39:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C3DD320049;
	Mon,  4 Aug 2025 13:39:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CED820040;
	Mon,  4 Aug 2025 13:39:25 +0000 (GMT)
Received: from li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com (unknown [9.111.65.243])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  4 Aug 2025 13:39:25 +0000 (GMT)
Date: Mon, 4 Aug 2025 15:39:23 +0200
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH] mm: fix accounting of memmap pages for early sections
Message-ID: <aJC4C7PndXlcDIro@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
References: <20250804090859.727207-1-sumanthk@linux.ibm.com>
 <1e259390-67b1-4d08-8174-a65f1fc9eccc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e259390-67b1-4d08-8174-a65f1fc9eccc@redhat.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z+jsHGRA c=1 sm=1 tr=0 ts=6890b812 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=4jqXR_ZrKcS0ey4vrCcA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: fqmc2F5T_vGsYwpUnWewDSxqDOJSo7wI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA3NCBTYWx0ZWRfX/l/TpmOTZmIm
 fhyX1WzCXwwIbAcCAAwAPrqVAfkoA7IPz6Llhi5sMoft1TRt6gJS6Ji8EiAomJpPC8ByHAcvmWx
 k54nFeZJoxo8In1Xm6SuU8sbHlINDV5lgRna3e0fBnjawqcj8u7dQBEnrAE/Z32X/3h4PfBOn19
 w5r3cn9YkiwFaU7aI+JIhLW4j+Vmx1yUjSMa0zwQ7cJA+UuNZYO4gE0EvFxgVqNWkIFdMXxqMDd
 3D3xHKyWSn7jrTLqQnxs1Yjmv+T5bhoDazuyjCIeo5fGkPYNlgQ0sF3zn7gFyvoUHiLwuECT2Yb
 mFWd6i7ResyKIYH4W8ww7onRkiRcNJbXAV0sUFsgQgMGHUx+04E2mP2oX/um4q7IB0uyjfkksFG
 PVsQRUv3nh0LWjv1sZAbNvMPlXvewB1OhUd2a2a45EbuPeiR4TtbY6rms74jdjypgXx2XXg7
X-Proofpoint-GUID: fqmc2F5T_vGsYwpUnWewDSxqDOJSo7wI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 mlxlogscore=409 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508040074
X-Rspamd-Queue-Id: 904DEC000F
X-Stat-Signature: ch6ycbh8ug4j3b3hzirsa6jte47i1an8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754314771-266582
X-HE-Meta: U2FsdGVkX19dVOp2FZVFdRyh2gMdd19yAetKg0szSB0I5xhtSscrIqsMsp7k8pmWDT9Q0RDyHLm3/2tu0RJz/YZVCbH1b/GEVxq2cHEhX2qA37lCesq1jDy6qxN0BZRBn5nJ+QhWAJ/v3V1HHxm85bBjt23yRcHOs2I8hBOEQSp+SIoldmRz8ClXKYZ/p6/BTxkldmtWTQiwoM4Rkui0njnBqCuZdAj0gdXRCXeGL/pLkQ2qVU+vfdA17wr25gy56AhNtQHOEm8uWbxOiXpHkgakHPyPeiDCTdyZnfvKVhsbNSH2EhPK6OSZJQSKirsaNAfkry3IDkicvXec17DiNxLdI11NJymSbUvf0Ju5XDMXMXNyA1zb/wni66SpKZxHYZKfH50Fo8tXxPQe7kgh4ZwPpAkjKrfOkQjJF9OeAGTBfe6IojGEiFURN2n5oTB8ylraZ5O/s7suDsosMOkN1moeGa54NA1lIxtNoC7AEPP9Z5eXIIVb+D+BmQcEQfOl3m/AJSkoeG7M0lpqsCG1S1ecUS6qUGI79FOpl4TnATxRDNAvAhnIuVu801eOvgD+qH/R9qjLCkHpRDbVRFOF/dIYh6/zEw9hZ0DTxx5lMHL1/VTYMLnQGFdbN1LKus3Rke9OG7Vihgu8PWmNNosw9xjAZaJU9+6ScWwJB/WCY9jHLaaaYYKhTGFYu5YZYWMbsGmcXfIxN2blXrZDpz4/JpF4Df+AU05toCJtqKYO4e0IpsfPBTEUe4+K8ihHr3OFOoIA3gRbAPxnGf42cFaqPAJPtfc8RxdxANqifsd3ImYrs3cus9hgO2BJfsxs58VbfAZ5srGWiMGzsvOIntZzXdMvZEH6RFy0y66EjnvULOidwljZ4mJUkYvQOeOFRYyOgo7t9VR4TJKeaAsRrzmuYjFglzhZyAjqG4oTmUoTNNSFQcep48cPW1GGwbc2iLI6Z072wJImkfvLit0mM8z
 C1KDTXp8
 h3drdTigHvD/HCmFfmNfi2oVTciX7JOI9fNeHiybCotymmFHsbPVaxvqcHDBjSh8kY5Nz/F3SWDo+EUrcYpo2GGDrIZdfnsHBQkoiLsXou3sAYc3gtoIfwgkhT84c0UdFsm7JjbI+OGUXcHuhieEa+qMCZN4ArR4pd1dc9xl0Q7n5qF7Gc4J5aOACP9CXNlNR2QFCeOhJ/g1bmIwx/SPmx2sIA6dIbYuUzz2zK4XRTjs3gIsGa1N24hbtYPJRkGZ4nfRpEPTQoD3qrvFYuXUkujR+1aR0bWm6ZSinDrg/lQ9KtSsihHDdr6lbnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 02:27:20PM +0200, David Hildenbrand wrote:
> On 04.08.25 11:08, Sumanth Korikkar wrote:
> > memmap pages  can be allocated either from the memblock (boot) allocator
> > during early boot or from the buddy allocator.
> > 
> > When these memmap pages are removed via arch_remove_memory(), the
> > deallocation path depends on their source:
> > 
> > * For pages from the buddy allocator, depopulate_section_memmap() is
> >    called, which also decrements the count of nr_memmap_pages.
> > 
> > * For pages from the boot allocator, free_map_bootmem() is called. But
> >    it currently does not adjust the nr_memmap_boot_pages.
> > 
> > To fix this inconsistency, update free_map_bootmem() to also decrement
> > the nr_memmap_boot_pages count by invoking memmap_boot_pages_add(),
> > mirroring how free_vmemmap_page() handles this for boot-allocated pages.
> > 
> > This ensures correct tracking of memmap pages regardless of allocation
> > source.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 15995a352474 ("mm: report per-page metadata information")
> > Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
> > ---
> >   mm/sparse.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/mm/sparse.c b/mm/sparse.c
> > index 3c012cf83cc2..d7c128015397 100644
> > --- a/mm/sparse.c
> > +++ b/mm/sparse.c
> > @@ -688,6 +688,7 @@ static void free_map_bootmem(struct page *memmap)
> >   	unsigned long start = (unsigned long)memmap;
> >   	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
> > +	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
> >   	vmemmap_free(start, end, NULL);
> >   }
> 
> Looks good to me. But now I wonder about !CONFIG_SPARSEMEM_VMEMMAP, where
> neither depopulate_section_memmap() nor free_map_bootmem() adjust anything?
> 
> Which makes me wonder whether we should be moving that to
> section_deactivate().

Agree. I will move accounting to section_deactivate() then.

Thanks

