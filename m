Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C3D4CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 12:28:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ABB58E006C; Fri, 17 Oct 2025 08:28:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683358E0006; Fri, 17 Oct 2025 08:28:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571E58E006C; Fri, 17 Oct 2025 08:28:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 461608E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:28:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6CEC1DBE19
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:28:16 +0000 (UTC)
X-FDA: 84007533792.24.BA98C0A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7CD54160008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:28:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eE5W0N9n;
	spf=pass (imf08.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760704094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zcD/4uYFsGN+ddlc5XN7jrlEbZPy90Q3VYii2jxgM9Y=;
	b=wimM5lnzp1uZqLZz+jh0ezEdNaZuTEHX44dkKSapS9r9va6QdtqAf+hA0R1MH41hM0pUjp
	NzDozwQm9/ShcYkCpXwUjJ9B2GAHKHMgeeDEEK8ubPgFix0UsRpft+lJ/3dQw2TRoxcF6b
	AdjrKhqv8AUkA/dozafvCc5iWDl/rcw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760704094; a=rsa-sha256;
	cv=none;
	b=Br4xN01+14zLLZqySxXnXegadbof6+YuhjBi5ObqST/bl8XxUC41kskg7OudEUm7tQafCy
	r/w5BFCy7GPJ+77z3MwGb/7ZncHnev9lWNuedexFdJx4u4AjeatmumujphXFYab3Pa5UYO
	k2Rg4SVrn4tuhhuvlGbzTF7NBdO4ffo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eE5W0N9n;
	spf=pass (imf08.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HAarsL010294;
	Fri, 17 Oct 2025 12:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=zcD/4uYFsGN+ddlc5XN7jrlEbZPy90
	Q3VYii2jxgM9Y=; b=eE5W0N9ngKQsBCaEoKP5X7uMprOx6srXl/Y5VSnftyarLC
	FSGEDSCmpjEvwqDQFh7AEijQZhgnsC4DjNtYcVSD2tWylUvlrd4mw2tUZr96iquP
	/Z+lp47gr9mIxlR3dOKgFjPzYEUIvnSowb+LGqWv/mwux3Hir+753eGvRXblGAVl
	S/1vztL894fE4p+ROE4dyTuhsSxnbHKOHNZ8TZpwoVVIQRwGqR1AFUMHqQ1rhx5Y
	oJV9EhNt4y4mTiiWLDsGZ5H7lIV3YJc8+elXhzspQaeNoIjaX6oeGSgjxMHKd8Bi
	2/n7WNnKjsQMvJom9/+Vry4AmFzLW57ZDlOaJsVg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qewujm35-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 12:28:03 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59HCS2e4011949;
	Fri, 17 Oct 2025 12:28:02 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qewujm2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 12:28:02 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59H9Ms3A015041;
	Fri, 17 Oct 2025 12:28:01 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49r3sjvxxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 12:28:01 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59HCRviL24904158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 12:27:57 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 80522200F0;
	Fri, 17 Oct 2025 12:27:57 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE081200ED;
	Fri, 17 Oct 2025 12:27:54 +0000 (GMT)
Received: from li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com (unknown [9.111.68.179])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 17 Oct 2025 12:27:54 +0000 (GMT)
Date: Fri, 17 Oct 2025 14:27:53 +0200
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
        Guo Ren <guoren@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre <nico@fluxnic.net>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-csky@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org,
        ntfs3@lists.linux.dev, kexec@lists.infradead.org,
        kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v4 11/14] mm/hugetlbfs: update hugetlbfs to use
 mmap_prepare
Message-ID: <aPI2SZ5rFgZVT-I8@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
References: <cover.1758135681.git.lorenzo.stoakes@oracle.com>
 <e5532a0aff1991a1b5435dcb358b7d35abc80f3b.1758135681.git.lorenzo.stoakes@oracle.com>
 <aNKJ6b7kmT_u0A4c@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
 <20250923141704.90fba5bdf8c790e0496e6ac1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923141704.90fba5bdf8c790e0496e6ac1@linux-foundation.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oq4BBwfqQ48M4fFrJYto5eFg6cOrIUo4
X-Authority-Analysis: v=2.4 cv=Kr1AGGWN c=1 sm=1 tr=0 ts=68f23653 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=Q64uQKxdJJvBSAPQG9IA:9 a=CjuIK1q_8ugA:10
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: 6VusDNc5IkEdh68Kaj2ZTeyqGB4LSNCy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNCBTYWx0ZWRfXxloq0CHfoAPH
 XWVL1aBHdkm9/xfBCuiQ3NRDkHBHHJBzuRDZONYMy2fb9zEbQIvnfmYJ/id2eywCKro3ajwNeBN
 4kh50+Ptwe9WC/jgv6TvlSU3BjTjj8J4e8Q28WaUW15+fWE4+obYIhdatSNa8pR7s7K3qc9B/vz
 /NrDUP9sclcVLmwCaUq8/8kitasnnMGBQ+06iNPPJ2JLfYTXft3CE9tZA6j7MvZnByxSm0WG2L9
 6HJF8v/KHOyke08jKmTMex92BViTc6nNAZ8Mf08l0p8tEVPKsDoeg+/woBR1eJnDItXypZ8WKoi
 4hmgIRXSm+rnxVDlrmJgusCv4UyparD/Ec+dlPRV+dFyojmExkE6m1pDYvzlIJcGkJRfebaDxiR
 gMuyJhCR/K7vXVkZsF8tcUl7kIfexg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110014
X-Rspamd-Server: rspam05
X-Stat-Signature: gmkffqask34kybkjozydxpik49i1yufg
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CD54160008
X-HE-Tag: 1760704094-880
X-HE-Meta: U2FsdGVkX18NM2S8lDsHxtzj9nFwOvFTecY4v31q7x1ZRjQ9W7Wfg4YHFdUUTtPg4Im5RCnUwnN/RWUiOMo/VxSn5Wv//+8sQQ93mQgqAlRIewnmlum5iIsb/nDFeLYYlKiDERZOxntRsP3N0J/Y97h1X1vcqORWFMgLdB05eBUeRsiozweYu72uUluMLQEwUQGaY41LM6e9+tgKwKuZYbaSvdCGysufry4G5c7Ie3y9q/1nja4HtM5jLGvdBP40JyYUHk/CxrBzId0VSLbXfBjWV7ivjL3IoqHsgHPKQmVEn9B9t+eZ0bV/a4tIfYwWqFZVFaC4CBbXprefiw6VgMIWeVPFgI+U5vUcWib5k0TaKXkMhhj80ow8w0vVj93dk6VyjvaPrmQhfAXFjgM3GSo5mOOvjkS5wWRmz+3Ae41AfI9Xm048wAcsD/yrHAQUhBDf+AAXRHigqdcinuVdEmPO0nPdM6sV5aZK9aCD+0TEppgHUMstabqYhixReE8a5qlyfcrPUnAuVnatV7ui1qx+b4OEky91QGHE6oqrgeFIbA5ai2wULkhwqhjRV/dh9x3Fa/RkwO/fIU6H2xggrXWyI7ykdYGyTjcPK5OuRihcMPPXc+RP+NuaDy4bAICk4xHvuzIqs6Xdf/ewrEMHKtTmh05yJnYH4yHfEZhlOyXnN05DUPp4MEq/4Z/WdSzcOlKQmCkr00iKIx2G267oO0MzLw6uQUNOcsEInUWNRa9kNRO6G81BhKvlKnp222pIKMHGr6Htb8moagvYn9HwOYTdKFptoVylbeLO9TIUu9YIFkbNwOCAlX1kdM/gjDDl66iugaKLPH3w7veodvQMN1PPY0nTkCQ/dmmm03rmWuOFcxI2WlKmHXn0kTTow/qWnhruWJS9qkzJAaaKAV4NY1AuY+nzh1cmYnPTr3k1tLztgFu0bR+5RzG+Ao5edfffRzpBCXAPfIN+dTUcYtS
 M6L40juB
 fcCpb1BUAWYIXbM+1O1cmqRKRx/Wqrd+rvsmhFQUTzRfipqTLFeCtRlt9H+V6OWJerA+I+yrJuGMuE7z5G0hbHjKYeE53pyr2TgECTyN4lfSf1bY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 02:17:04PM -0700, Andrew Morton wrote:
> On Tue, 23 Sep 2025 13:52:09 +0200 Sumanth Korikkar <sumanthk@linux.ibm.com> wrote:
> 
> > > --- a/fs/hugetlbfs/inode.c
> > > +++ b/fs/hugetlbfs/inode.c
> > > @@ -96,8 +96,15 @@ static const struct fs_parameter_spec hugetlb_fs_parameters[] = {
> > >  #define PGOFF_LOFFT_MAX \
> > >  	(((1UL << (PAGE_SHIFT + 1)) - 1) <<  (BITS_PER_LONG - (PAGE_SHIFT + 1)))
> > >  
> > > -static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
> > > +static int hugetlb_file_mmap_prepare_success(const struct vm_area_struct *vma)
> > >  {
> > > +	/* Unfortunate we have to reassign vma->vm_private_data. */
> > > +	return hugetlb_vma_lock_alloc((struct vm_area_struct *)vma);
> > > +}
> > 
> > Hi Lorenzo,
> > 
> > The following tests causes the kernel to enter a blocked state,
> > suggesting an issue related to locking order. I was able to reproduce
> > this behavior in certain test runs.
> 
> Thanks.  I pulled this series out of mm.git's mm-stable branch, put it
> back into mm-unstable.

Hi all,

The issue is reproducible again in linux-next with the following commit:
5fdb155933fa ("mm/hugetlbfs: update hugetlbfs to use mmap_prepare")

Thanks,
Sumanth

