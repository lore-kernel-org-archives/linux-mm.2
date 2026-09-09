Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B480C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622C46B0096; Wed,  9 Sep 2026 09:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3446B0098; Wed,  9 Sep 2026 09:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49ABC6B0099; Wed,  9 Sep 2026 09:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BB9A6B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:21:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 660881A01CF
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:21:28 +0000 (UTC)
X-FDA: 85194285456.02.2E8F079
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id DF25840011
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:21:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EuCpZHWy;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EuCpZHWy;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960086;
	b=HR3mlLXkr/u6ljRB5SavtD1CGuXrM+34eMH5ivf83+MTuAqehfdNjLQxaPINeiqGx6Ulbe
	ZnTAcWv1+S/UApqt2E5jHBlrBWeZp7J42K7/n52TNMvhVCtoxEjoSVpJCsn1S9sx8C+2+S
	JMdsIafxoKzpBsM7JaqJz4iQD087dQQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lwnt+uIwVb2GPV+2IM5Jzk0YcZTtM/PdaaHHgmqpX98=;
	b=gwXmbyh3WcyWTd8l8++Dejd3BXillYBlr8H6D3RlrNs6sJG5y9oaGZqqNhtf+X0Jgvd/g1
	erOyEvFpj7/afQMMRNPd5nQ3YLi8mS4uvAdnskTJkISMo2XnbAMfbeH1hC8gDhSjfWNRqB
	cCcOraIbO7JR20NFCvJgG8BEJKGM2Uw=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1Xnl1930793;
	Wed, 9 Sep 2026 13:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=lwnt+u
	IwVb2GPV+2IM5Jzk0YcZTtM/PdaaHHgmqpX98=; b=EuCpZHWyn7am7j+RkZ0lW5
	5Ib81wwbDMz/LSR/XcnaNFSi3mqVhO82c9KGxDWz/4ALeb5Vy+ogDgqgOo6FFIZM
	ZBPTyYmQ6EVzttWWtOAIuzjDZAOdts2Rw8gh3y+ivt4iTFO5ZO6DXSCF0t/hIqbF
	thKv4uU7997K9JcNgpawg8T6Jd/ukleWXD1AXMuTUMEG5OND/1DPARIuONQt6ybF
	alJUHwEeuBnnbWmatZjFWGEOriERQCt46H17TnSASNUPdOLXBIOEV1yr/jxhO9+O
	TJWRfK5K4iQUOo/5QRj/+Eay11NaQsiP/ab0ecttPcaCzrqjuDOgWQ902/SdSg0w
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbqk60gt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 13:21:03 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689DBEbp001065;
	Wed, 9 Sep 2026 13:21:02 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggymgj9p9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 13:21:02 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689DKwm341746858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 13:20:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 20A462004F;
	Wed,  9 Sep 2026 13:20:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B217220043;
	Wed,  9 Sep 2026 13:20:57 +0000 (GMT)
Received: from p-imbrenda (unknown [9.224.75.30])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed,  9 Sep 2026 13:20:57 +0000 (GMT)
Date: Wed, 9 Sep 2026 15:20:55 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand
 <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Jonathan Corbet
 <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Peter
 Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Mark Rutland
 <mark.rutland@arm.com>,
        Nick Piggin <npiggin@gmail.com>, Arnd Bergmann
 <arnd@arndb.de>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Marc
 Zyngier <maz@kernel.org>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 27/39] mm: rename is_vm_hugetlb_page() to
 vma_is_hugetlb()
Message-ID: <20260909152055.475f053c@p-imbrenda>
In-Reply-To: <aqFDKJlj76O1hR2R@gremlin>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
	<20260908-b4-mmap-prepare-vma-flag-sanify-v1-27-dacf19cce22b@kernel.org>
	<20260909130141.2c5d250d@p-imbrenda>
	<aqFDKJlj76O1hR2R@gremlin>
Organization: IBM
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: fVmbucRpDXqYs95uPJn3gAtDgliZy_hJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE0NiBTYWx0ZWRfX+XnzXV+hr28g
 E90nFzP6XF6ZObxAKEAUq1J0igT86F5x1TgyrAzYp7vCkC8fmorxhzNCOS9hnE3ypA1Hfc1ne4e
 aMiCHHlgUtwe2xnc8kZenLByslkkWcw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE0NiBTYWx0ZWRfX/6M5OJCe5NLD
 NxNf1sIDRWa0GW/z4cn108sE3iVT/OK9ygEDgpxSQg8V58ZWikgcUGzCXHlfKE/kWNHqCHhb0f9
 buRoc1LWTrP/k473nMF0Qiac8/8LDJig0CEQOJUBS12AV/AZzPMgAdNAnUaFcHzPJt74KU7l5vf
 l9g+WJ5QfiKvrKPEb5/97swi4uTbHQVmrJCjCC4kqBdjtTIdvAxu8iwX5lYdVme8+LMbIdzHOc8
 NFnCacTVrOsWSqK+i/4n0TqDqFgpdTgsCJ9YBcJTI/JUPJZlE//xj4ZQqKGa1LX+S58V5svWn8J
 fSmi3TSboWlhHVfjhSRq66Ud/KkI7BzU9s8cZI0+WqqEknXSI6u77Tzemji4/eUnk/ETKWi/fHy
 yYk7Y6cUXX641skzuPwB+CyfseK1jlyQmSYKtBaz9jt/4La/RTyJQTzybmVtGVJzJoM+STiLCAI
 d5rfAK+vLixTZrIqF/A==
X-Authority-Analysis: v=2.4 cv=JaKMa0KV c=1 sm=1 tr=0 ts=6aa15d40 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=jmM3fxk_Nj0IWXPWY-8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: N2JLtHebNUOVPKb7AWQq_VfpI8BmxIJj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090146
X-Rspam-User: 
X-Rspamd-Queue-Id: DF25840011
X-Stat-Signature: hriywr9qo3kzhaqamdjzettpqq9bq9uj
X-Rspamd-Server: rspam01
X-HE-Tag: 1788960085-720409
X-HE-Meta: U2FsdGVkX1+HzOQi7zbu1rKLvClVmZxxC2zH+0lvxd/7/VQz7rubiddRD+LobYgdxbmV+IoNwdxdS30twOLnHuqwJs8FJVpUP0tdZVGM4BN5Tk/YOXfrkqGZzIX43+VEE0dOx5JIKxgc+QlWJO6Jn+9gWeZtsqYcishp53mjlVdn7Ynu2TPKx+toFjpfGfNyAQP1dGhPRPjOg4ZmoxNx4KyqfZZ7Iix1Us33BZf1Qx9naKLZUFBD7fiva8eS8EAR2wwOiihyc+4ntWSAt0XVc4BZAKJoLgli4Oox9l4LJkEb8mGrvlfc0My+d9s0EYCmlxJXnI+YvNBL71lyRy151Go2dCmPwt4YmsYPwQedkrF42VevUzjJJR1lSbq7MIV1S+yA4aB0UcHGR3LXmT4WVE0IXPhh+WQkO6a5DsMduVjbhSISzXrnEvX6WlQVro50vg2swPz+0Yaq5c9pK36zSlYgzx1KvZz5ASgB0hYD5D0YYnZ3XqG9vSVEOm/NnDLi1Y9+olv3M36WH+WoMZBWgDs7SA0g8vs3XovqjlCeGzvnQLQpntAiP8+NYjDFkYFNacg3dCaQRoG7/io3RtylvgD2acPANCIZ1uJbqlJhgCJOB1x2TbctUQrZ/C2k1+8VDXRj28RrLUnWF7/SF2mf8frjhacrTGf/AqbBp8f8bLbOs9RoEeVFbO/MLSEzafiDCobOgFISxhUILXZWxqTWaZ0SZaZsroi5NudctsX4Iou5FzsQtIgaxLwJ5uLunKQJ7oU8hk7RRtYFkHDeV0AZlon/g2mvF2JGKkEfN9h2ClHP4KP+0jsDb/FFnCDryB6ERPpJqBj9cXaXVfSvPFJPtw4tuXc+GL74kUsX1Ksdkrhs9ra7AoPJ81ZIK1cuyypR03zRyMRJyrI/Pl6jRJEpCN7OzuOQABqm/LwwWGQGkE3kjrt7xPjsaS77LOnQHj+O9QVMoDHvGTZI0LtwV1K
 wkTPEL/3
 2k2v6VD97WJXAHyKvLMeJsNeCqcvYTRx+nBdadCRvJKKlsdfsnuWYVOvfMOLYVoVWDkh2++AFcyGn3MgL2/BLma7/CyQAuzHrEPmL8JN+djhwvcXGHr0gE0n+p0p2fhBbzth9aCrSMoyMhViPAXTcBedbgXXKJyYLFwuNsPDFRfkereXoEHOy7hElwNN+YTG9xobncrjO+em+AvM6QqcAMLDp0uCh4Fp54gxFJkrWIk4P1YtN3Gd3YrOMaLPJSomoOfeh3JK47Ow6jHq9gf9DpuPvNP/rA35BMPBj1Dkav8reHzNl9HS53hhXvvVr0dcL5zPZJoeNEOc+E6u36lGpugslNg4Lh+3Q8lvPvvSDs24PqhjpfjMkP2EZopL4w7iJrnFi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 9 Sep 2026 12:30:45 +0100
"Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> On Wed, Sep 09, 2026 at 01:22:07PM +0200, Claudio Imbrenda wrote:
> > On Tue, 08 Sep 2026 21:01:31 +0100
> > "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> >
> > [please note that I had to prune the CC list quite aggressively because
> > my SMTP server was not happy]  
> 
> Yeah sorry about that, I already pruned the list a LOT from what b4 wanted, and
> still ended up with a ton of people (I consider maintainers for stuff I touch
> the minimum cc, but also added mm reviewers).

yeah I did not mean to fault you, I understand why the list was so
long. mine was just a courtesy warning in case people reply to this

[...]

> > > @@ -247,7 +247,7 @@ static int __gmap_helper_unshare_zeropages(struct mm_struct *mm)
> > >  		 * proof to catch unexpected zeropages in other mappings and
> > >  		 * fail.
> > >  		 */
> > > -		if ((vma->vm_flags & VM_PFNMAP) || is_vm_hugetlb_page(vma))
> > > +		if ((vma->vm_flags & VM_PFNMAP) || vma_is_hugetlb(vma))  
> >
> > Would it be possible to replace this ^ with !vma_can_gup() ?
> >
> > (obviously not in this patch, since vma_can_gup() is only introduced at
> > the end of the series)  
> 
> Sure, I could squash that into the 'use and apply vma_can_gup()' patch. Will do
> on next respin!

excellent, thanks!

> 
> >  
> > >  			continue;
> > >  		addr = vma->vm_start;
> > >  
> >
> > [...]  
> 
> --
> Cheers, Lorenzo


