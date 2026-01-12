Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D938D2503B
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 07:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1886B008A; Mon, 12 Jan 2026 02:03:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9A16B008C; Mon, 12 Jan 2026 02:03:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7A06B0092; Mon, 12 Jan 2026 02:03:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 879106B008A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:03:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F8BB1403DB
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:03:07 +0000 (UTC)
X-FDA: 84322420014.03.0115FE8
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id C23444000B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:03:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FnlWHg7y;
	spf=pass (imf01.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768201384; a=rsa-sha256;
	cv=none;
	b=OkVEzlywt36XUiJ6rcrTaDWIlEt16uxiqZZMFGW34teTB9lerZ/SGGuBZJoO8kFWDN4OZG
	NHNUkmfvdM+OF71u0kuubaa7qstJ0rPvsDX+XEhZGLgBKx4HnDbQAj01+a07wljYUD8MbA
	oslU8glPgy2szFsiucBda2z9HFBa9io=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FnlWHg7y;
	spf=pass (imf01.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768201384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DaR8QIrJoPyGAUdK2XoR50gjX3a8JtQ3y3ZpcU0sC3M=;
	b=aevrdnGd1vqYsaK69APZeu2Hy3UY+wRtkkNAtoviNmY4qcZcsHcpSeYlJ/By7VaAS1fOCN
	CBfTR6q+XMH3I58Y3GmjC1O4sDLTkOkupeQczgoZXb5fukZ4KasWdWChcdFmu2vtLRIdo1
	lK5KO6JTqffThPyL3KFoAkjpYDaJjdM=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60B8SDe5007270;
	Mon, 12 Jan 2026 07:03:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=DaR8QIrJoPyGAUdK2XoR50gjX3a8Jt
	Q3y3ZpcU0sC3M=; b=FnlWHg7yF0EhltIiIn9ZnFKG/nvLKG/pF1swSGpJYPCijY
	W3Rmt5GG9EndclJOkAjsYj7aziAqVbObyNXQkmpQybP1JTD40KYizrnejvBH5N0R
	uxWhc470C1N521DLBDW/4DIyhAp6m6ddM4POUpDrVis1Hlh6nnlYKZ+MBCseQRuL
	2/T+gL9VYGZJLh0qjYX71ULRHWwG39FOsJ/hdlnDgOBY/V7LzQa8RoX1JtXisNa8
	CSva6dlpDA66CEU6Mn19ZO4lOZMC2xpo5csLamqkyzMu14mWfv6OS/UZ3RdAJtGZ
	P+oSF809jDQ8YtKfRtAb1iHfsp5syvvLc4So3efA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkd6dwpng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Jan 2026 07:03:00 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60C72xtd026579;
	Mon, 12 Jan 2026 07:02:59 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkd6dwpne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Jan 2026 07:02:59 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60C5F3XY014244;
	Mon, 12 Jan 2026 07:02:58 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm1fxvq99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Jan 2026 07:02:58 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60C72r9n41288168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 07:02:53 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7F1020040;
	Mon, 12 Jan 2026 07:02:53 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E39620043;
	Mon, 12 Jan 2026 07:02:50 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.87.151.31])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 12 Jan 2026 07:02:50 +0000 (GMT)
Date: Mon, 12 Jan 2026 08:02:48 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Shi <alexs@kernel.org>,
        Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
        Brian Cain <bcain@kernel.org>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
        Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Jonathan Corbet <corbet@lwn.net>, Klara Modin <klarasmodin@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
        Michal Simek <monstr@monstr.eu>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Pratyush Yadav <pratyush@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Stafford Horne <shorne@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
        x86@kernel.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
        linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v3 17/29] s390: introduce arch_zone_limits_init()
Message-ID: <b211f877-f9bb-4892-b67c-d2610048575a-agordeev@linux.ibm.com>
References: <20260111082105.290734-1-rppt@kernel.org>
 <20260111082105.290734-18-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260111082105.290734-18-rppt@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bCS-OSZblyIq8lvlPyjEILoO8GzzpHGN
X-Authority-Analysis: v=2.4 cv=LLxrgZW9 c=1 sm=1 tr=0 ts=69649ca4 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7WlQhDu6A2usLaOTEWYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDA1MSBTYWx0ZWRfX59mP2KNE13j0
 a6aegnon1oN4dcuG8YaVOaJhcRG6s3uUJFEsmdkW+MZ5sZ09v9vfZ00cHaM+sNVIGfNSGFA6TA/
 amYWC8VtNTQv0JRk3gc5rBBltZHgc72KTXGu3prlXckbdY0t0zp5Lo5Yhjr8IF/vYaYhc4GEfSU
 Qn3vnNEGmBOVemoTnAoVuUgIbpnnLrr8prY2Jcsedc9458fa4aIErXN9hSBcQEeZAjafXeGIs3U
 PkSTvWywRsb27htzKZSu/lI9i25vaLSZKrrQYY6kqWC0MKkmjKSiCkMGVZp7eE7xKVafOgrDfKv
 /IgXdjJYtIVn8udUlyOpA1x4MgwEQYsjb20V4FINx3F9Zvbn5I4upMwVWMuGSRYRH4uAOicy3EX
 58rNjYtR0Ljy4P0wI73tlEk2VHClT7wveMeVEf9wv8ox2a4bReXLiwz96iuRvRG4P5usk/SQFvy
 YK5patORVNK5OiJVC/A==
X-Proofpoint-ORIG-GUID: Mt_xEhUTi_ZaKY8BdbSWDFf-6SwyebPB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-12_02,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1011 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601120051
X-Stat-Signature: 5js1h1fu3bhrdbmqzkondqgjy7yyf7hn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C23444000B
X-Rspam-User: 
X-HE-Tag: 1768201384-311011
X-HE-Meta: U2FsdGVkX1+gd8Xpt2IS/Zi9aegt5tJv1ODzmdydmHm1V+i2G9PJo8wmJ7Ce1Ttw2IF5iAnqRtpondB/4St1Si7OaeK9Eq824EouhALhdcadW2RrU4pbMNcGJ92uslB2IKe/HmxbZ6xxw7OZ8D5R+oh8YcN8o8fhrMgvz6E0h21FVyJGyR4n7XPVf5qXlP8cEKLRWL6Yda8N4qyKVA81H/bDzYnX1bGu7ViIjk6Wim3DaXMIzoMr4od2XV7O3Cq6NDocW9sVjb5oLxiRFgqlhUolF4cXzkENWyhp5HvO59yLnHr6sQp46Ud/i/Qf2IpYRmwFzsOPijWjukyLoBrW2MprdXQ86lCZ3ZvhDNuJIOUXNwaP4N9A0vgLgfJ9HfFtLuK3oqAJiNZnPRDaQ9oMT9yYr3l+tCNwq+yo5vYgHmY80Ev3E0kXrAXhqtGExEusp0fReupSSUBGqgwPMnka2qO+cZCCawHX6wdiGxyIYd5Nb33aEwoNF/eazSseEiSwVKaXXeXatbzvD3fHlfk/jPHqWOWqXuHxJRMGV+lRuN8si4Hq50DRxWLxgXb1/bWsuBQ8GLnOTtOwkDrBBSlUK8qfSKk02XeMGOBB2XIaaz+utbEYyAU+HFN9SImy9QSZWs0OKKSUPdypVZWExk9lviWXi2dzdORy/B++0y8DYU25LeKBSMd9tcLktDLBAGqmZd6e2etjfnE0/ziwSwv8ceK6/BaYWvTTDlgI9uQg7xeh5re/TGM1quKjMh65RibFREPG4ikOwjV6s7eCqgKKbe5N13+NREfq7G6a9q7atfcmd7GBTzaQ/PSrTHH62NtuB0UvxtRCgU3J7NYxz3pnEru0bJ1xVIN6v1BC2v/aet2EfhO6FxHsldZ0FkDd95QLr6RcaoGy8iM5R4m4TWJNDObMN4S1ReDFxKSHP0ygPVQmAaKP0Q0dktcoIZMdovuz9JAYMUYtja7Rcj0Ol2W
 NfM6E/8w
 J6H+cFSB9I2JiZ8FC96FQeAPlyOS2DQpk00XOr7cifyr2s573/97MC/2hhYAup1omoyvUoDpMGl+8dxpZOESA3MFBJ8VlgSNN72AvBP1PfHJZOLvP4zQ38uraceHRkN0GvmVv2RszTE47UjexbvchjYumPb0WQyqOPGocX3GjNqFRRwCoF9Yy0Xh+bF8AZHmIT5yI9eFgsFstsI7vQpsKW9WSZigW6+XB+2cSnn5QwRrnmktkQpcIzU8SO4SsL/lUfOVnaHnAbt6R/O0FcYmV7FB3KLB9r2/C4IFTT5jzzbAvuO083JOoXnbp6yFcVyXHv0AveKy3S5JW8QsXlnM3EGjl3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 10:20:51AM +0200, Mike Rapoport wrote:

Hi Mike,

...
> +void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
> +{
> +	max_zone_pfns[ZONE_DMA] = virt_to_pfn(MAX_DMA_ADDRESS);
> +	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
> +}
> +
>  /*
>   * paging_init() sets up the page tables
>   */
> @@ -97,8 +103,7 @@ void __init paging_init(void)
>  	sparse_init();
>  	zone_dma_limit = DMA_BIT_MASK(31);
>  	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
> -	max_zone_pfns[ZONE_DMA] = virt_to_pfn(MAX_DMA_ADDRESS);
> -	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
> +	arch_zone_limits_init(max_zone_pfns);

You move initialization of max_zone_pfns[] to a function, name the
function arch_zone_limits_init(), but leave the initializatio of
max_zone_pfns[] to zeroes outside. Should not it be brought along?

>  	free_area_init(max_zone_pfns);
>  }

Thanks!

