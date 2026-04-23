Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7778CF9936B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796656B0005; Thu, 23 Apr 2026 06:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71FA26B008A; Thu, 23 Apr 2026 06:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6E46B008C; Thu, 23 Apr 2026 06:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49AA16B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:49:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B35F1405AE
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:49:21 +0000 (UTC)
X-FDA: 84689498922.04.D9848FE
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2A7DC18000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:49:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XsPxQB6w;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776941359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7EvN3w//PIUjYRwZwYylfrXx/vn+cOQpw155rQd+i9U=;
	b=J+veG5QWq992tabZWEfZy1NpByN7+Nu/lH1quU10l1nauVl4ckCmfMJmX1WLnU8smW3k/7
	CI8qxs76oftijgOsXSpS6fR+AL9dxYy82V94tBHkKl/xJbm7hHj6++m9U814+XrnlvUnMd
	MUvdK+K667xK7bpIirQwybs1jxB9SzA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XsPxQB6w;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776941359; a=rsa-sha256;
	cv=none;
	b=6G+pjndOLTqqBIjoalv5MVep71TlTK7r14JG2KH+cJcg9jb7hxLpWhUpRrO+Cq2M+ciVY9
	vmBvI173vFzhRQYc2/mk7Gz4mv1LnOOQl6wKWl9Nh2blcJJ1TSwjDUXyjo74BjSrd+1/78
	ydfForUzYuB2ZOR/1Q+eYzrtssMzs3g=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N77ZiH3107946;
	Thu, 23 Apr 2026 10:49:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=7EvN3w//PIUjYRwZwYylfrXx/vn+cO
	Qpw155rQd+i9U=; b=XsPxQB6wI7p+RrQVN409ZIWVLN0kwVLgRh6VzOG9Gu+y3+
	eEKtrckHI0Sisn2lNwXgeLJp+rI6bhkMnsv2/SjwA2kTYkI8XBmVtLqM8FtSxkNa
	RKrcWCjw5Sg31aoOf9g5PlI8p5wp0A5jFHKlXU0fFGDYDjuzvdeEzChxJhuTKm6z
	havxtfm3ax9e5ExSKlumvsdCzy8TiNy5EB4soJPPa+Ikx4t9p4DYp84XPZBk5tSy
	7hJ3BpdTcTZpInTFRLe35oGrDygtbNPZUI5vDWDPiWJu+dNfutAQbQW3cLfLBMX6
	ENq139ORUeksNNKOPROsjHyLi3u7RoHtyuK/Ay5A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu6fpmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 10:49:16 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63NAZQr3011205;
	Thu, 23 Apr 2026 10:49:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dpjky68ha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 10:49:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63NAnBMd15073776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Apr 2026 10:49:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64B202004B;
	Thu, 23 Apr 2026 10:49:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 326D120043;
	Thu, 23 Apr 2026 10:49:11 +0000 (GMT)
Received: from osiris (unknown [9.52.214.206])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 23 Apr 2026 10:49:11 +0000 (GMT)
Date: Thu, 23 Apr 2026 12:49:08 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] mm: Make lazy MMU mode context-aware
Message-ID: <20260423104908.10371Bf0-hca@linux.ibm.com>
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <8809412aaed8a515fe2e149c822543d640060936.1776264097.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8809412aaed8a515fe2e149c822543d640060936.1776264097.git.agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDEwMSBTYWx0ZWRfX/5kJbJXQUVCI
 F9frPD4dSk79AVauSEX6ZJMkVo3UQj6wJ7fk/cvIVi67AQm44+76kFx4JGE6lWoIx9Z2ccJ6yy1
 QQ2RTFNbqbwDcCRgSLTZKwfZAVbYv9iDEiQZmGCDtYJKsQUhD4p10p7R9OlZdAmRrDrkiX6XhsY
 0L3yL/uqfCET3RQbav9ag2Wltrs13ysiXCOhl9xkOdVn6H5Qq8iV0ITie8iL0ZTEl6CslZnG/2J
 j28VaxEbV1kmQSNaFx9gEsMmXsWmN57JthJ+6W3KPKU4TkfhqqsTCvSXO9RpuApD7hLXwgJnZ5Q
 jIo1rk1hvF9sW3Ly7Dsue3gEoI56VR0xa6nYMNS8B3pHPO/z3a6hWk8PmTmF2LwgtX2P4qjf+5Z
 ynjT3DpF0G1Z8FiyXSMK/UJguc10655VH8ZoDVlsZGilmVTJziJMHPrzVIMysXyo6E/aP368g8m
 kclzF+quPQkGQjrAucg==
X-Proofpoint-ORIG-GUID: 6d7ClHemyYgIXr5RcIsLheRHXS9pHYL2
X-Proofpoint-GUID: 6d7ClHemyYgIXr5RcIsLheRHXS9pHYL2
X-Authority-Analysis: v=2.4 cv=BYfoFLt2 c=1 sm=1 tr=0 ts=69e9f92c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=7ODufjUfLQ-iW2TkFlAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 clxscore=1015 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604230101
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2A7DC18000D
X-Stat-Signature: detne1zoczy6pq1mntkuie7ndqqygwtw
X-Rspam-User: 
X-HE-Tag: 1776941359-39498
X-HE-Meta: U2FsdGVkX1/G3hr5mNJBY8xHi3NnHSELnZo4Q/FhfiSsZVhAWvJBLEsJ561/ufBsdAU9hMhg9MZaIEjPC5lEBGL/mQtQ7JSwueNn2gvz6eYkwMJIg4kep1ZjyRmqyW5yF//6+KzAHdlBPgCubyCzwzZB7AvAK7UbwS3Fj/YOrGTeZTHBTyd1VRsgtPYBte4gS4MohUU284MZmCPBQoVE8JelKMO+GWVTM1TPagFeqYISQ1Xgd17PR1J2o/HjIzJfdrQWVcD0PdpN6KzoM0swCUEylB5HB2eSpYjFRAJQBXS+VV8lUkSsVPYmZM4SaBk5Qewn2WNcLa2IY9qeHzgzXbvRt1cv7mo69W640gcRIwv5ho5ttQ0JCfmSj+qoJaYLymgRl9O94JAwRFMdkggqKjyacfx5IQlQQDyqDQuKdFY0J/q7MUK3snP9zt3pfop2jowI0zqISgYwIEbMU618/KgyRnf37UotCHlsmFw321RejlejQbaX+r/LfzPbNmJnGtEwAT2cnR2EmioPRSVbeYcSqfMm3JmUuRT0JVZzbByiRCRii66IwUSYRRpa/boVCelH6MhR4WzIGJulr+EWMtf5xXQdRcEVoHE2UPNiUCybEDQqHPJoa1V5uaib2LZenk+lOFR5ckXKh553e+nwUWMh3A+8RztDnIJEKULJ9SOYCX89232FORpKnbIFSerKuJyIjH+xQg6smYLIsPK2r4a5yW/NqyELOa1PbtDSDenWK6x0AeJlqQkHeIv+dGa7SyctO+NYmxfhrr4BGWtNMnUTSD5MSF+bZR+5t2XxPup6AqbRJxzYQZJ2lwofvFvp7GIqGNEM6cAkP3wAp/dwSDWGSxQ1leJq8WsVqtlwo1YE1gv4CB7n1EnjgajBb/ZAL/MGBromVSMlghKCWq70cZqbgKj707K2GkBQqtMiHcbmEoPgwS4/aHy843XE1gAYSKfCeqOLKKiLAtakNF1
 Mry7qofH
 DLyr9NGIJxocjTsgAvxjRmilFwMNwelfvgvlmk5hTD8KxY+Oeia0Bd/gxg1b625W9oA/JhePhyR+S7WbzYRr4MqDLX7wAzIBBJQaj1j/Og+caePSmiidPJU0HTQ5JShZo+nU0P/uM9xnQSrypiYH9fyp8u3YhLoCi5wk/aoXxqfPJv8Atqs2VdCCe91FRlnNpl2c4oqjGSF8YBuJ4rlzRxP/JHEKfho2ZLTCBTE6f7T1IavmU+5kw1blkJjLwKk8raEaA21rWMXfXuh9PiD+qD8BZ3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 05:01:19PM +0200, Alexander Gordeev wrote:
> Lazy MMU mode is assumed to be context-independent, in the sense
> that it does not need any additional information while operating.
> However, the s390 architecture benefits from knowing the exact
> page table entries being modified.
> 
> Introduce lazy_mmu_mode_enable_for_pte_range(), which is provided
> with the process address space and the page table being operated on.
> This information is required to enable s390-specific optimizations.
> 
> The function takes parameters that are typically passed to page-
> table level walkers, which implies that the span of PTE entries
> never crosses a page table boundary.
> 
> Architectures that do not require such information simply do not
> need to define the lazy_mmu_mode_enable_for_pte_range() callback.
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  fs/proc/task_mmu.c      |  2 +-
>  include/linux/pgtable.h | 47 +++++++++++++++++++++++++++++++++++++++++
>  mm/madvise.c            |  8 +++----
>  mm/memory.c             |  8 +++----
>  mm/mprotect.c           |  2 +-
>  mm/mremap.c             |  2 +-
>  mm/vmalloc.c            |  6 +++---
>  7 files changed, 61 insertions(+), 14 deletions(-)

...

> +/**
> + * lazy_mmu_mode_enable_for_pte_range() - Enable the lazy MMU mode with a speedup hint.
> + * @mm: Address space the pages are mapped into.
> + * @addr: Start address of the range.
> + * @end: End address of the range.
> + * @ptep: Page table pointer for the first entry.
> + *
> + * Enters a new lazy MMU mode section; if the mode was not already enabled,
> + * enables it and calls arch_enter_lazy_mmu_mode_for_pte_range().
> + *
> + * PTEs that fall within the specified range might observe update speedups.
> + * The PTE range must belong to the specified memory space and not cross

I guess it would be better use consistent terminology: "memory space"
should be changed to "address space" in order to avoid confusion.

