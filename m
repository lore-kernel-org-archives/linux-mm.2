Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6287C60A260A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=b7nkb+ji
Received: by kanga.kvack.org (Postfix)
	id 7BC9A6B00EF; Wed, 18 Nov 2026 09:26:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794146B05B0; Wed, 18 Nov 2026 09:26:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 682996B05B5; Wed, 18 Nov 2026 09:26:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4E06B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:26:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA24FA077C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:26:33 +0000 (UTC)
X-FDA: 85448465466.26.6C41889
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id 519741C0004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:26:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=b7nkb+ji;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795011991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nETXuTUZePoLw4pXYNvsDz7unqCWR2e+XYj5vtu6Xbw=;
	b=ZTwxo2CFRA4jDW4CZGqK/dx9/9Kqq7jfLOBSEc1Efgv3Fsye7/1MdlebqvrC8aix/Trc5r
	KfCLj0QBA4dLKqDDb0jdTOLAexzwNm1ycv/uQXFZWcmU1X3Sv15mM8JXBpApEzzT6DmfrL
	LY5bOU2UgVD6IrJVO5dXXIGEEq5qTxM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795011991;
	b=xgBvU9RvmYNlGcN65JemB5u4proNB34ephbXE60kVNRefZqpplFfSdTmErt36J0ni8AFja
	b1svhsnYSFFa9CEaaox+v77D04hpjnURf3axphoSi8E3OHcpxLjhOlYWpb/oaxHHK2IwSb
	DXTX2acUzJOjkrgGz9RKpFRWcRRNDkY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=b7nkb+ji;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AIDQfZb1374452;
	Wed, 18 Nov 2026 14:26:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=nETXuTUZePoLw4pXYNvsDz7unqCWR2
	e+XYj5vtu6Xbw=; b=b7nkb+ji0sAeZT+2Zi1PGSCXTbjkReHpVOLQieE/xWBB/X
	RyH01Gdbxor1wSF5iL0pYYAdyXtz+56AGUR/vj+BHprjnq7NmsyZY4pjZQrtcBo9
	pSNiYzu6hkbD9NZeTH2233UGObBdBG6doumOYcZ5VkzoKksdTiBEAqjqL6LYiyj7
	HFzsJYasMpWuJ67dpmq5b395JOr78Zn1L2NZ1k7UQGBNWvLS7DKVASWXTsawgaVe
	gZ13INipP5whutNZGT59rZC6+nIP+SI28oRaCeu0g/33cTRWbcVUjaJjGADqCfC7
	/yrX9zZldynyjP5SIz0GnyI0qM8iJULbZ0an2xuw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105naubs-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 14:26:28 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AIDYtAW3470648;
	Wed, 18 Nov 2026 14:26:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hyxwt8r1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 14:26:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AIEQNni53019016
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Nov 2026 14:26:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EBE720043;
	Wed, 18 Nov 2026 14:26:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 58D8120040;
	Wed, 18 Nov 2026 14:26:23 +0000 (GMT)
Received: from osiris (unknown [9.68.31.201])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 18 Nov 2026 14:26:23 +0000 (GMT)
Date: Wed, 18 Nov 2026 15:26:21 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/5] s390/hmcdrv: Replace page allocator calls with
 k[mz]alloc()
Message-ID: <20261118142621.14542C9f-hca@linux.ibm.com>
References: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
 <20261108-s390-char-ready-v1-5-3db507722530@kernel.org>
 <20261116134656.125125Fdc-hca@linux.ibm.com>
 <avxMOsbgkaC_kQA_@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avxMOsbgkaC_kQA_@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDA1NyBTYWx0ZWRfX2Qs/rg4vM0I3
 4PYu/gEpES4RTiIuLHfARi8JW9C5camfvf2hLMAnZdwmNHhLG28liLJbcex7zeNvxCm9FsCtKLC
 9z1qdqWXjQws6YvkhkcjdQeW6+w1WGVrMftAYvW+pLARBJTa3VFocqHP0UHcqjKCwS5+nY5IT3u
 yu/lqXFEfjR24l4G9I38/erDiFnT7sqjIDDesw3oDYDdqc2yO37u1LRO/NEbKTvmo1s4aTZ0uWy
 O4WBxL/u7ZwRM8DRAFxCTPyFA8U5dPVPdUM1KWjlNr2zyyiWNzv4vSdM0DRrVg/MPAGH2Xxdc2J
 dtl7Mro5Y5TSdAc1nnSfKIWYrImtjgWQlYoDq6ehuVDTmqc7MuL07fH0LlyCppVO+BjDyDwjjYg
 0h/kdR5CVOY5PnJLmLNVpzcdI9I21rUu27OsrrZ1tWHeQHSwTCVy86JVvcbXAKXVLR9pYhHg6B5
 U8oAJEcIeSZ5yM1L8tw==
X-Authority-Analysis: v=2.4 cv=HN9WhYtv c=1 sm=1 tr=0 ts=6afdb594 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=HvbnBzd4vKlcUxMVZJ8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: ycwvVJyxzljRnT1qnHyPKQkasI4iuNM5
X-Proofpoint-ORIG-GUID: ycwvVJyxzljRnT1qnHyPKQkasI4iuNM5
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDA1NyBTYWx0ZWRfXwZ0e+uBJ6A1e
 /b/WamLh66iGO+8atRWLyWoHFy8H894CPhOC52WaqUaeufRign61EoRz5LTz2ct20Va6rF9qUwV
 tuzb2DdOrTjInEHBoNmPKEn1rMIaSGw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_04,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 malwarescore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180057
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 519741C0004
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: c6ughdt6hftim5qp9qzbkiopbykfaqj9
X-Rspam-User: 
X-HE-Tag: 1795011991-545944
X-HE-Meta: U2FsdGVkX18GUKAYYXn8EUtKjBu0ckwhAEKvBqewsW6LlLSNJEw3IN/psxIGNPet7yaM0YreM1DewgWchusF6K+2LexDIjKS2iHv7ZLxtXWI5WGXxx9Z9DwtOoj1jiJiRj0RJaa3p475XuB6Sf4+6xxjmCZbV4LDBQV7spG7CoKQQ69WIG8zC+iZX05HF+q12AWCL5zzuhzGDbI2vHuVax9pf9fwmWKuwcoZoLXGVHeP/QDzL3rCgUFXguWGEFldYv7Yg4OJPXerPWFEtlRFQPGYdHy+GLnonnIghHg/7aj7sWPll/QmMuq4l5ZI1Ld3wIm1hjDnDRKpRdl3Ycz1ax4o+NZJ219D9Uf3bfy6FLDzBAXMCfifUqfmr2oaZdjohuLOfScpadEI/ozyPrX4iS6ncNpIHVJK1v3ghO8rZoTxxhZwooK1QslUo0to782zl90Of+e/6kUQAHzkP2TCA6O/2CRJd9NkC9iOz39upw7BX+s7iMmTFDiUmP8WNCI/2+kAxEb8W0gUUWiD+x60u+yav9IAxO6st/Di3a4wVGNUsdp0103mGSeH+KnbQoMMAjhaLGq0VIwhTMUnOztSv/UqlAChZCMKePUEArbltVqE81L+ZUNMJthTFrkXGyDhpPVPIAsCKnaSTkqBD2Qcp2D4lmZYjnYEB68P3F0zuaaeFJJA1OUxa5ll/QPik4LnbGh0IjHLC86ixd9N1cVQnkV2GyQKPUrx8r8J2CHPdurgAHiGWsZ1XWIpYgCPg7DL+Cmv9jFkzNjOinjvElHYSjR1hRygcCtoYgmoPtyg1EL4iQSLABie9YyboCJC9VUe/EvhZdUJ8+Z5Ix0BjOpwwKa8/0IoPDJRaUJJeR6j86UCiCrYnRWhS5LRHKeo3/Eim2BmK84eHvgezGI/4HJt8u9t6haP2K00bTUwFtzjhOB2XWNWl/QlvcI0FNYav7FeNe9RIFZK13x311PbfKQ
 otc98qkD
 C+TzC78o0QcypZhaeqxP4jK7c6q2kC+vnbNTBOQPXM49wKxDVaiNyBzxRZE1lG1IAV6oi9ZJD3G7wd7KXwmjxTenyhN2gqkIY6w04MhB1d/Qrg4XiAhBnL9Bq9AQ6avIMekSlUltn173/hZTeS27z8/1pc3PCIkvOhgRWtCfbqpOIDeVC3qv0M8+VxZNYLwmXl+iI7tuLccnsyyoHmTr7r8/zbXePY8tVPXyhkCucxdCheqn4r9h01uDRow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 02:44:42PM +0200, Mike Rapoport wrote:
> > >  int hmcdrv_cache_startup(size_t cachesize)
> > >  {
> > > +	if (cachesize > KMALLOC_MAX_SIZE)
> > > +		return -ENOMEM;
> > 
> > What is the reason for this check? I can see that this seems to be a
> > common pattern, however the buddy allocator would warn as well for
> > allocations larger than MAX_PAGE_ORDER if I'm not mistaken.
> 
> Since cachesize is a module parameter there's a very corner case when it
> could have value within a page of ULONG_MAX. Then round_up() wraps to 0 and
> kmalloc(0) returns ZERO_SIZE_PTR rather than NULL and does not warn.
> 
> The module would load with a bogus cache instead of failing as it does now.
> 
> While it's really unlikely to happen in practice I'm sure Sashiko will be
> unhappy without this check :)

Ok, then let's keep that.

> > > +	if (!ftp.len || ftp.len > KMALLOC_MAX_SIZE)
> > > +		return -ENOMEM;
> > 
> > Same here, and as far as I can tell the Sashiko finding seems to be
> > valid as well, even though it looks to me as if this worked only by
> > accident. Also, as far as I can see, the reported "delete" command is
> > currently not used at all from the only existing user space
> > application that I'm aware of. But let's not change this, please.
> 
> Sashiko is wrong about get_order(0) returning 0, it actually returns 52, so
> __get_free_pages() returns NULL and we end up with -ENOMEM anyway :)

Yes, indeed.

> So it's either keep if (!ftp.len) and let it fail for "delete" like it does
> today or have
> 
> 	size = round_up(ftp.len, PAGE_SIZE) ? : PAGE_SIZE;
> 
> and allocate at least a page for ftp.len == 0.
> 
> What's your preference?

Then let's keep the code as it is.

> The ftp.len > KMALLOC_MAX_SIZE check seems bogus indeed.

This can be removed when applying - no need to send a new version.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

