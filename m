Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0AD8606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 07:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=imaK9aMz
Received: by kanga.kvack.org (Postfix)
	id CA9906B05BB; Fri, 20 Nov 2026 02:03:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60526B05BC; Fri, 20 Nov 2026 02:03:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B496B6B05BD; Fri, 20 Nov 2026 02:03:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FC886B05BB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:03:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9BB480DC1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:03:01 +0000 (UTC)
X-FDA: 85454605362.05.CA2919E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7F57040003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:02:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=imaK9aMz;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795158179;
	b=wx9uXcn65YXkXxEyW7ET0aGNvBvUWTpFkvaaQcW6yykJ4B7J9dVjB3f8F7FelD5aqhFWDW
	1KjroDUIG5sbzOZaAfzvEc4hycp7he9wi2UzmNqjDJMmBgE7CugGIJhln4aNz6pu6k31Jc
	Ssf81xBdET+GzS1rqU9RTxgEvsMVXdQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795158179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afa95FYRycSTILjMsqGzLRYXv+PeRp5wBtIh6n6xeOo=;
	b=097gZmprctgxetkb//9uuno8eR5jHS8phJnoMov4wrxL2tqyoVrDxhQlCcfB4fphf+QutS
	KJfDVEdoA/Xejdsz+JUTgId54s9/8+6rx2Dwi0axDqkywl8GPcucquupcc5wn+WwB/ILLw
	udor+WLFqrzCG97GLGU7jJ+Pa4U7LEA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=imaK9aMz;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK3uab61965675;
	Fri, 20 Nov 2026 07:02:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=afa95FYRycSTILjMsqGzLRYXv+PeRp
	5wBtIh6n6xeOo=; b=imaK9aMz6We9WdCUTzVaTg7txsXokdCrRM0xgJq/DmbmUX
	CXm/mN7NYuQLdyd6iHdiF0MtOh5rzYuaGlWmm1HAxZPxaEwHQNEgTWBlAaxwrd5k
	fsZ3J8cl1NEeFTTp2XUa2TOZ9sasCtUxUIAydid42mjZgn0n9+jixFEmoH5p3ZpI
	NV5IEUZdFWj4W40YGSpV+OKPhwp+Og1D1Dq6nrp61Urw/m7Ll3buMxtZDK4GqanK
	N3e2D7OXjE8M+TrrGO59+Br/VWY3dYzg47DOy4yu4spFAYCxHRlJk8z6KiGpqiA4
	w9lr3HufL4G/lQUbs1pJjVAJunfRWQfiVjgNut4Q==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105x6cqa-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 07:02:56 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK6xKEQ600883;
	Fri, 20 Nov 2026 07:02:56 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j1bb5jpsn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 07:02:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AK72qqZ46924182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Nov 2026 07:02:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F16492004E;
	Fri, 20 Nov 2026 07:02:51 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B98620049;
	Fri, 20 Nov 2026 07:02:51 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.24.221])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 20 Nov 2026 07:02:51 +0000 (GMT)
Date: Fri, 20 Nov 2026 08:02:50 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/5] s390/char: replace page allocator calls with
 k[mz]alloc()
Message-ID: <fe72024b-da3d-44ba-ad41-79dd5da7fac2-agordeev@linux.ibm.com>
References: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _Qgos3NoeD80laCUZJqkS_1Bn37hEhS4
X-Proofpoint-GUID: _Qgos3NoeD80laCUZJqkS_1Bn37hEhS4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDAyNyBTYWx0ZWRfX1RXMLaCa/04M
 aOYxs5DvyYE09AE2LUAJHqxmF5pRsVK/0iA69ltyJ1WFiwHmZG1Z0WIi19JXkzwH8Wj3pNUHQ7C
 i2/4XUoH/zBxUN2HnXd1/WtQrlRPfs8D+reuF4AJ1nCOuNpZfUHoftK+ac1VaMsrXV3TBGm+xVp
 Q4VdoBPPH2KJf1vmiHamehbe1FxxGi+AIOfelUffUCtLfI9+XNt7yKzJZc1qZPuE3FlaTb+1BcL
 gw5vhc9f0tE5f8zDd9Mm2kHL+iWwvwhVjq6+WS8imU7dlsO2Ub9v8WUWZaib+SIua3j6oadyBfC
 No7Wp/Zn9/DDIv4C/w07jac/NGp6Jg10U+JFNKQ6kbr5cRVlLA3XV+i+cVGxCqN6I+j8u92fct1
 GcrYuZ6I4UUigdmovTIECHWgubKpUmQRIs4divExlQ+OCA/UPUfxCRNrUrU7OSMftD1JiYvkeG9
 k9pvPKPlVaQPnYcN27g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDAyNyBTYWx0ZWRfXxJEDkFN3YIbF
 XIlkKdwXpookl1+MSBo3hkM8LNHRBVxbFVpd6sLoa/15c+FAdlIv7xody3pmScoq5FjW+NhpD0P
 +ixyYCwvYW7Sgce59CvWtrfe6qqg4i4=
X-Authority-Analysis: v=2.4 cv=K+m3jCWI c=1 sm=1 tr=0 ts=6afff0a0 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=bKjcd7YqMW8_FUSzF1wA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_02,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611200027
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 79r8w93ghta3jczccqz7qt3w8oisrkg3
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7F57040003
X-HE-Tag: 1795158179-534474
X-HE-Meta: U2FsdGVkX182kDgx5a9UD1s1QVaJQi3RdqXQwUA8u9MIC06aOxPQCDjrTfNW9A3uUbmPsAFoCglcxHaqcNQ96vpAjPrycpBCzhHv+8sccT2JdD/RD0AjEDaQQSx/FaRDmWIPaQ2AVBgQSviFApxVbWMDda0JmSQR5SZU10LmSPbwOcLtM0OJMF5npfOVlkN8fanrGZPXjPK8UGx+8gdKtDNVnczn3E/0wBcpvxGMPfCBxkKHhWmv6AMDXqBSFuEnfz2wiNlh/BmYKJ9fj6CsfrcreOMvAy02F3k69xzHnw+mbxXm8mXA3itRObq3soRKaTpwzzKysgH5aY1qyHpe1bqN4TckXp8EyrqEza9hU1sq4egItPxCFohL2cK0NsPQ/U4+3gRdHHpm+dF3sppDQTuw22U3xNoNAhecXV6SyNfqx0dNeM/3rRFLtftAvreYezPR88x9UJ8Zoh4L8guGlTym5XYdXfsBP29hecZCikNSlLrWtaslEe3ZnMyaLOWXFhelUv2aT9UYdY67zTkaWj8CgnYPhelxGPzIku27qnrZHlg1DpKdZR1b80JvkYn33QCYoszQRtNBkvhqdEtf8dFeNP7NeCMRdcdoNodn3OH4xcSUs1zdDNHqyTpu/XUuGA6TvhMg0k6nkd0StEssnLsmEflDN7+5eoR2P1Zz/0Fnt/ktv21kLAqg4jKa6QNXEU+YMzqoxJAuGvO9+kKhOZiUFDWq7vcf5HaLO0w5QAiStxWsovwo7sNeU4A/ZYi4Rfm4L+9rlcrBPyQ/zov+islTqDZL551lDGi1qzLbN9S20l9vRcDYbU/QN/cqdnyO4prVFVMWX9K6ZGg2PX8vCd1S45EAlWEHTmzNGFICJGhuSXtdPSpFZZrI2m1Z4bJyP2GPY3ESsP3U1IrDLqhyshFgrDVmz5c4XRTF5cgRV3nu3YN36qsQIycW0JW0KfHITCI9jEqVjB8OSCBcNYS
 zMFR+xi3
 M8fY5VIbchZrBbJZ/94pmuIIwnJxbVyBnUoCzKtSXPSgOFLav3ClrHO/5Vas8uRfNNnxNW+YSasqRhr4VjdkWHMGGoxOELegitJPIGVMecMVnv/ffQxvEvO108rPYZmYXKnu4OoGojgU2rYZxGb3vN6gu/KrFeNE32I7JsifagDIRygN1M8hLS0JHO4GbhibQo2wdxbjDIUYxnb32HgEheiNHSaiIqQAAMztYbqdj/6WzJxiWwylseXJvg9sO4enGcvM9xopzaIVdCs0SSpjAnXj2Qu3u/y80hhTYLcJOGNuzlMgpcCfn2GS8bNOPMDykLJ4ulbtLLAslFx1bqXkHg+V/ljfwgwLLkoR8WKWj+o2i0ucv/Byu2pR5LoxSTl99ZRUGyZbLkmNO/kHbJtIaRPsyzYyYxUHFkEEl92MNQvEEcOQ2b4x+RhahgcCz113nwvRkPYQl2ux/IywiqvYHUD84me+6ldye+pI38CJrP2WcoGEpcyVHVXcNgpfsH47D7p5WduKF2v+6SYSVigW1dO793aYqdbtr/wT6p/DhF5CK999+tya9zGt9AH63G83OtC+1Wu2MR+9Vhe5tKpNrj8FGAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 10:48:57AM +0200, Mike Rapoport (Microsoft) wrote:
> This the next episode of conversion of page allocator calls to kmalloc
> family :)
> 
> This series covers s390 character drivers other than SCLP.
> 
> = tl;dr cover letter copied from the previous posts:
> 
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> My initial intention a few month ago was to remove ugly casts [1], but then
> willy pointed out that Linus objected to something like this [2] and it
> looks like more than a decade old technical debt.
> 
> Largely, anything that doesn't need struct page (or a memdesc in the
> future) should just use kmalloc() or kvmalloc() to allocate memory.
> kmalloc() guarantees alignment, physical contiguity and working
> virt_to_phys() and beside nicer API that returns void * on alloc and
> doesn't require to know the allocation size on free, kmalloc() provides
> better debugging capabilities than page allocator.
> 
> Another thing is that touching these allocation sites gives the reviewers
> opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
> another size is appropriate.
> 
> For larger allocations that don't need physically contiguous memory
> kvmalloc() can be a better option that __get_free_pages() because under
> memory pressure it's is easier to allocate several order-0 pages than a
> physically contiguous chunk with the same number of pages.
> 
> And last, but not least, removing needless calls to page allocator should
> help with memdesc (aka project folio) conversion. There will be way less
> places to audit to see if the user was actually using struct page.
> 
> The patches are deliberately kept small, so that every conversion can be
> reviewed, and if needed reverted, on its own.
> 
> Also in git:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/s390-char
> 
> [1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
> [2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/
> 
> ---
> Mike Rapoport (Microsoft) (5):
>       s390/zcore: Replace __get_free_page() with kmalloc()
>       s390/vmur: Replace __get_free_page() with kmalloc()
>       s390/vmlogrdr: Replace get_zeroed_page() with kzalloc()
>       s390/uvdevice: Replace get_zeroed_page() with kzalloc()
>       s390/hmcdrv: Replace page allocator calls with k[mz]alloc()
> 
>  drivers/s390/char/diag_ftp.c     |  5 +++--
>  drivers/s390/char/hmcdrv_cache.c | 18 +++++++++---------
>  drivers/s390/char/hmcdrv_ftp.c   | 14 +++++++-------
>  drivers/s390/char/uvdevice.c     |  4 ++--
>  drivers/s390/char/vmlogrdr.c     |  4 ++--
>  drivers/s390/char/vmur.c         |  8 ++++----
>  drivers/s390/char/zcore.c        |  8 ++++----
>  7 files changed, 31 insertions(+), 30 deletions(-)

> Sincerely yours,
> Mike.

Applied, thanks!

