Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56AD2CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 20:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5110D8E0002; Thu, 11 Sep 2025 16:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E82E8E0001; Thu, 11 Sep 2025 16:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE4F8E0002; Thu, 11 Sep 2025 16:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC148E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:57:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9D4B597A2
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:57:22 +0000 (UTC)
X-FDA: 83878179924.24.9095B32
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3722D1C0005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:57:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=hpe.com header.s=pps0720 header.b=cSQfZyXH;
	spf=pass (imf20.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757624240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0ID9F64YdLXnEJhVLSOMHkdqi2X6q7O8dZhA/oVjxI=;
	b=o0HaQp1NulZqEhyzXjOw7+hjJb/14gBu1OqJFFZpH08Lb2M/ouFj077sspT2YhJlpXLsdz
	nuBwnOo3ho6E0ecmkcoBhpgeHrVJzeWsAGKJiOzNy2ahxr5rrW77Nzd4fSO5gDe8xbQ+/6
	+maGwi5lEz4aEbhC2gWwI6q86QgN8Do=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=hpe.com header.s=pps0720 header.b=cSQfZyXH;
	spf=pass (imf20.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757624240; a=rsa-sha256;
	cv=none;
	b=No+VghMmDJA6DzBhbOespB09nVp7u7ddHWhPA7qu3Y6E/3hbFe3HCKY1MdGt+jG9yOecgx
	QWsLAixmUh3L8Vm3xihwiwDcLQ2BunYVV+Fo7ZnO7VzXTekxTfPXyZ+HV+6aj0CkUahyzD
	tS8qaXISG3Y4VA1SLJfae9CR4NFiaLk=
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BFINgC007212;
	Thu, 11 Sep 2025 20:56:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=J0ID9F64YdLXnEJhVLSOMHkdqi
	2X6q7O8dZhA/oVjxI=; b=cSQfZyXHw97+qAk5GLrVBgwewFdz885Cteb9qF6kZC
	cl0B/IlTfIYZlYVAQL80a6ViC3RMb7LwXyVxWpyeUQW2ZjFRH89J7JwZPy7swLK8
	bfJdi8MluU5znLPe19N6KRAHsTlRVjl9hc2fwjmchGWfXeicxabPj8CO4JJ95aRV
	D+zFfqrdQw7/J2i1jmRyxhcTzHsKKP8MGvlaz9Bm3J2WYbe576VycumLp3m3y7wL
	cmgGV0a94bE4YbFXaAsE3e48TESw/6B8qRdJ7MM59bacGyVJ3D/ggJqoVo67Ocpm
	Hq8fo4AFsLG/i0MW3vGgTuCEWf3aENH+ykwjbcc2Wq1Q==
Received: from p1lg14879.it.hpe.com ([16.230.97.200])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 493p9xfpef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 20:56:34 +0000 (GMT)
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 206FD132D3;
	Thu, 11 Sep 2025 20:56:32 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTPS id 708208118D1;
	Thu, 11 Sep 2025 20:56:28 +0000 (UTC)
Date: Thu, 11 Sep 2025 15:56:26 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
        corbet@lwn.net, linmiaohe@huawei.com, shuah@kernel.org,
        Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org,
        jack@suse.cz, jane.chu@oracle.com, jiaqiyan@google.com,
        joel.granados@kernel.org, laoar.shao@gmail.com,
        lorenzo.stoakes@oracle.com, mclapinski@google.com, mhocko@suse.com,
        nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com,
        rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com,
        surenb@google.com, vbabka@suse.cz, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/memory-failure: Disable soft offline for HugeTLB
 pages by default
Message-ID: <aMM3elPmG1MdUNrJ@hpe.com>
References: <aMGkAI3zKlVsO0S2@hpe.com>
 <749511a8-7c57-4f97-9e49-8ebe8befe9aa@redhat.com>
 <aMMNVA9EXXHYvmKH@agluck-desk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMMNVA9EXXHYvmKH@agluck-desk3>
X-Proofpoint-ORIG-GUID: Ethw6hHnLfczx3VAEZBXc-08gscPDyGN
X-Proofpoint-GUID: Ethw6hHnLfczx3VAEZBXc-08gscPDyGN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTExMDAyNiBTYWx0ZWRfXyI2+SdrKv+fr
 J09MeyCR3Ioip+tv+DaUAAlfVfIk22LrAWmlkzH/QV5q4UAWPgfHNFOl4+ub//1Adee37pHPb4b
 764zMHo5pXXt1CcHaobNJvfMfwFmUUV/nH/D82/1aTPO6jutWA9MvX8an2UNfGrfTzL9DSk8XRW
 WdZT5V1erw/xxDMTunGIMHe9T2MS+FKEBZCOwsxI4yn8gC3OcGhueHg0cu+lqePY9/N+YX888Hk
 3sUbWytd+nDRfz/JfHwjdEa8Usy/cqfyazlCUsltcgMUe3O7HboftW1ebSfQdBIJZ49UPQ+CDK2
 gt4/eks53CHvrIBOELJSndItTN1QUeIx7bgqpZ1GHhLx5QsJwOy/K+Q1x9blJwm1hm8x2x3EJNQ
 nmqPYiXa
X-Authority-Analysis: v=2.4 cv=Ke/SsRYD c=1 sm=1 tr=0 ts=68c33782 cx=c_pps
 a=5jkVtQsCUlC8zk5UhkBgHg==:117 a=5jkVtQsCUlC8zk5UhkBgHg==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=e0XSXhz86abGffj2R7MA:9
 a=CjuIK1q_8ugA:10
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 malwarescore=0 adultscore=0 clxscore=1015
 phishscore=0 bulkscore=0 impostorscore=0 spamscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509110026
X-Rspamd-Queue-Id: 3722D1C0005
X-Rspamd-Server: rspam05
X-Stat-Signature: yuxyogyziwn5rwbicga6bxywhhjqtx58
X-Rspam-User: 
X-HE-Tag: 1757624233-993164
X-HE-Meta: U2FsdGVkX1+wUoyCBlTXzSXv35xiCBffobBJ6jFZxzdzsWTaFw7N40AB1l9Dqv7J2KFW+e0VOvW6hlNDz+uM7aKTKUkeaL9mrv1Mbex0qdZBJYTQTUGqBqhei31FDBTMCmqYCv8rPEf07MkF5CbOem2ca1ZOGYi/sLXTLEc6YP8Cufm3nHoXe/dSZWvpN1biUGUxL0U7tF1EXxZJ2XgWBPoRKHHfMgJngUy/lVGmprDxlsJymaxS55Kw+wxwAw2Sbvz7sh11HmtxSPhlv72TZcbueHGhblduAN80T+RP20SDt5mGPbUcplECaLltF0EFG097yD3ZBOrny4gU8PDwzPZNtUmFK6msVxd8MxVLOG5pftmm9LmUuw5hwEv16radoaF/4FZY682pQa6P7RlUotF1092fh1KDBNxYdAri6dhc19MzNe1h7dOYivorrFTUrrlKsXt2cUmuXsBlmGg20wqJ/S7SIBAGM7MR0qtknoF63TG1Sgtg0o1njDqxDlAeEJkUC8Ae3IyY4HHLxaogmHRU94ZGxwLG1kg5ThsZi4Zmv+UQ3Oyazr+djkZaK6JoSwKOinIE9YBJnj5+s/9Wus7vpHHWT7cuHR552IObKMLJ4TdC8PSVCgik0dw2+Te59y6PJU2J45ZI3nSdORNlqQdZ6MzQ8Koy65Ayi/6uenqr5i4QQyn+wQ8H10okNxLEAlinAMDn1kflLfCQNSzY4U5bRxQN5xl3X1ORgmiEZb2u74eq+xjsroc4tQV+cXORECIQaIC4LoLIX8OWl3qDa9XmlDUda6v1uRrB2x4LcxZC0juyYv9FA8LGlgDg1alaPJ2cEmxw4n2d0VPZNlwG8WxuRnFZ88pRhWW4Ilc/mnvcjSnnnKXiLYP0imju7/Sjgjv9P+OcTi4CEgW3G5d6ERUy6+7Qcx4lAumZvVw0yORh5FwhRm5naLGw7ApviOHNm4ko6NaoVD+Vva7sJ1V
 FTucuiyY
 Kgk43xhr3cyQ6tM7iqRo4ukocqRVMIFCmgKtaVRE/xla/TxUp0fSS+tkbS0hBFv6v88cSrML4obJ8B0wqfCar+0u4bidBsAmi5eixS22REJbC+To55MsIBHYlQ80h65QWWLbeJVci0WzCNc+W2h8qpVqrKpNN05HeuVNmWD77ho+V7c1qax0UHmlyxDIlGRRJD5u/xR9ID7yxMyWxxTA5+hdBAwBqYEN/tN2F2fFTrXMhUc6LMHHwxLf1kpPsxzsTP7bLrXb3tIIKTjspMGjTjbUaWJPkKevWnef64qDs1Bwmwgr4Z7ykT3ihnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:56:36AM -0700, Luck, Tony wrote:
> On Thu, Sep 11, 2025 at 10:46:10AM +0200, David Hildenbrand wrote:
> > On 10.09.25 18:15, Kyle Meyer wrote:
> > > Soft offlining a HugeTLB page reduces the available HugeTLB page pool.
> > > Since HugeTLB pages are preallocated, reducing the available HugeTLB
> > > page pool can cause allocation failures.
> > > 
> > > /proc/sys/vm/enable_soft_offline provides a sysctl interface to
> > > disable/enable soft offline:
> > > 
> > > 0 - Soft offline is disabled.
> > > 1 - Soft offline is enabled.
> > > 
> > > The current sysctl interface does not distinguish between HugeTLB pages
> > > and other page types.
> > > 
> > > Disable soft offline for HugeTLB pages by default (1) and extend the
> > > sysctl interface to preserve existing behavior (2):
> > > 
> > > 0 - Soft offline is disabled.
> > > 1 - Soft offline is enabled (excluding HugeTLB pages).
> > > 2 - Soft offline is enabled (including HugeTLB pages).
> > > 
> > > Update documentation for the sysctl interface, reference the sysctl
> > > interface in the sysfs ABI documentation, and update HugeTLB soft
> > > offline selftests.
> > 
> > I'm sure you spotted that the documentation for
> > "/sys/devices/system/memory/soft_offline_pag" resides under "testing".
> 
> But that is only one of several places in the kernel that
> feed into the page offline code.
> 
> This patch was motivated by the GHES path where BIOS indicates
> a corrected error threshold was exceeded. There's also the
> drivers/ras/cec.c path where Linux does it's own threshold
> counting.
> > 
> > If your read about MADV_SOFT_OFFLINE in the man page it clearly says:
> > 
> > "This feature is intended for testing of memory error-handling code; it is
> > available  only if the kernel was configured with CONFIG_MEMORY_FAILURE."
> 
> Agreed that this all depends on CONFIG_MEMORY_FAILURE ... so if any
> part of the flow is compiled in when that is "=n" then some
> changes are needed to fix that.
> 
> > 
> > So I'm sorry to say: I miss why we should add all this complexity to make a
> > feature used for testing soft-offlining work differently for hugetlb folios
> > -- with a testing interface.

I would also like to note that the current sysctl interface already affects
testing interfaces. Please see the following commit:

56374430c5dfc ("mm/memory-failure: userspace controls soft-offlining pages")

The sysctl interface should probably be mentioned in
sysfs-memory-page-offline with or without this patch.

Thanks,
Kyle Meyer

