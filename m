Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 168BE109C03D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 805E66B0005; Wed, 25 Mar 2026 12:38:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD5D6B0089; Wed, 25 Mar 2026 12:38:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3916B008A; Wed, 25 Mar 2026 12:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EAA26B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:38:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02C5013B194
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:37:59 +0000 (UTC)
X-FDA: 84585142320.23.9F17090
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id 851C62000D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:37:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PVCwoTM1;
	spf=pass (imf13.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774456677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQtkmDxmslIExkFjEKNG8vtTuvQMZ1PB/p38zRImO1c=;
	b=tf0cEHC/O7XKfaYHQHX2S1uw6iJwOOrR3ps7FstFRba/ZsKtrjBRir0MDLkXKCndrEXHNX
	GpvIIaBZzvw79qi0hISmEPGoOtDJ2sisEieJ3zTsz6EISQor+UAVTbrg38+E/7lR0rCuqn
	3UffQPQECwZ90ttlr0FWsCoIW9Moe5Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PVCwoTM1;
	spf=pass (imf13.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774456677; a=rsa-sha256;
	cv=none;
	b=njBFPwqHN3CzjL91n0/CBqi/Fl4HRXbbKMrQf4kRnqEKRHLyFVHVAlbIGs5rbjXPIYJX4p
	uBM9XN6ZBEt/g23rvu6kh5nA5ktRclp5kxHDi6/5GtXun0pAhlmBeY7y0bDTbOirjlN451
	07GNihU1lCH499oSd07kwiQ5LkZ6Fbw=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62P9vdu0962883;
	Wed, 25 Mar 2026 16:37:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=FQtkmDxmslIExkFjEKNG8vtTuvQMZ1
	PB/p38zRImO1c=; b=PVCwoTM1GUxlYZzeY5gTWFwZkiK/Oq+MiK1gjafgzC/qkw
	8WIp39LSbjdNIMDwK5EXOLlC/qWbtQfSDxR2FHuXU8XVavmTFcndPaf2aOzUr9TK
	gktdUo1O1HbV998Zav8vZsuvFcmzCZv2LKBmG1IQrJLhVDVaaiHiXKmmCoB1sjfo
	TzNrLz2jQ/esbRLASo76DYtXsMJGjTRJRh99ELSVSTpTn7wcAQa+g+TwcWZ4pN18
	2MFDJ+ASPj4AcEIAa0eQ7xGXKcNrvgYoFGZ7ROarqJafbBWjiOicdfTPfXY5U7Ye
	o4MuuUruBFmmo62RhJR80Yo52g9tFniEU7321l0w==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kxqhehh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 16:37:50 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62PFNnix026681;
	Wed, 25 Mar 2026 16:37:49 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d275ky85a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 16:37:49 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62PGbjRG47448432
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Mar 2026 16:37:45 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6997A2004B;
	Wed, 25 Mar 2026 16:37:45 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 369E720043;
	Wed, 25 Mar 2026 16:37:45 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.52.215.75])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 25 Mar 2026 16:37:45 +0000 (GMT)
Date: Wed, 25 Mar 2026 17:37:43 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] mm: make lazy MMU mode context-aware
Message-ID: <939c4ed1-3335-47ef-a25b-6ccdbd48d464-agordeev@linux.ibm.com>
References: <cover.1774420056.git.agordeev@linux.ibm.com>
 <de89fd353a8dcd5e3bef4d91e9b6682d132ed9a0.1774420057.git.agordeev@linux.ibm.com>
 <44dd86c0-1845-4dd9-b4b4-2cef6d1c6357@kernel.org>
 <e096e88b-f1fe-44a1-bfa6-451eef028203-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e096e88b-f1fe-44a1-bfa6-451eef028203-agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ep-i31MGON5OlTVgHzD44qA7jGtcSV4f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDExNyBTYWx0ZWRfX69MY7zL9dYkK
 OOwrsP2i3IO+E8dzEkot+WcOQZ9DXy4PWqnzre6V8fRHZ+NgcsDWCcKjWhulxWSQssOcczL/I8H
 m+kQ05AI5VajjO/mI+dww3OQfJP91uYmIvEDivusZ7/WA8Vu19MwNQeSxvzIBK2D8A1/OkUbifa
 h8OUXnMJRySj8732fani84Er4jcyo48Htb2YCBmNgdPPwIcUYG+VR2nh5hzr1euMb3SwSNuWMfM
 fYHlDiKmwXjTFVBUtSQkIf7AzXSZVwXJMuGUK9d+eUaAFIasW9smzVTPuCrd79vS2HPin+rC0xH
 gfjG/4/Fr+EPjDhjzdfBoZ1lvRhQrW+nzHYMKt+P/2N04uhZw8UVuoa7zdrV0aEp6hMpYica32c
 o9qpa0NT4SRYusS7Vx8766TyOXnLv+TsPB+IiHpeVdcAwrx+7xmR7urMUcXJVHpYIo2VMqUME7S
 BwNKTrAg4EWvTEd9VyQ==
X-Authority-Analysis: v=2.4 cv=bLEb4f+Z c=1 sm=1 tr=0 ts=69c40f5e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VJWC2A9Rxtiui5an8dEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: ep-i31MGON5OlTVgHzD44qA7jGtcSV4f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_05,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603250117
X-Rspam-User: 
X-Rspamd-Queue-Id: 851C62000D
X-Stat-Signature: wdg5eo6qcp8c7zusrgdrrw5h39r9k7e1
X-Rspamd-Server: rspam06
X-HE-Tag: 1774456677-80490
X-HE-Meta: U2FsdGVkX1/H8rydzt7kBeIcbBY5r7f70Wgdlt5WCPERNjxoLbDXpY8X934TS00eg44O5SS0JtffYlApB7001AIS82qSlzz0Ul1nsSfepRcJKCIAByZSx8/4Ek/2k5SK67UhvnBepKE8TPlt7U2zdGpZU9V2X9X+P/EA+wSp/qhMGTL29ipxZGfWqNnyzsQOt3fy2eORhkv61iZJkY1cvP02FOcOLxCRsrb6njcxTa0yv5vDi3gE9YwD7xaoQuB1+Za96VkA2lJ5xDs56MEr3Ah1jV5RGUpohbnq6SKNhdLxU2gOjZgVLK0GQQPQtrVOqdauVKgqE8rI5fqkOr43aYABqEBolUkqbbmzlRNbZhTqBc35s56qxAPV7vzZbywqgmydvHeAsnKSfouDCkDy9Qb2hKJW4zbfKKZF/2O4HIFt4D53WM6IBLoKJ0aVfqgn6MJCqcVUKhohIwT7BZMpNSRtenWJIY9LAxlCFEiZOZ6h/Q7PtVUVn2c/2LtBHuLYczpn2kOztFCRzHC9EKBJSpOcfD2NHGLMUtzWgycHOGg26odForxJDKHBLHo1Rvv+BccUth4Ve2NQD2FX/I175kq5+VM048et4P6V9/8o9ZEnM3QH9IAtAJEhD5u5KFuHX7jVqzGkFY1F07yeIbOb9kMFz6iLZbPWsiTKsFF9MPrPtlc5JNyfoRuDV9uZCyo95eRY8Ak6bl+qLOh+tenIySsDKIGYet5fCU9PCln1v5GtixegTCauHu2bTVhfPV+IHhylL2O92dra8KOT9a/JKAgE7nT/r4cukqJ69Nzv7u6k/FHqPENQmcnxkmeKlQoJXARzqI5NWRb2vi0f/uJJXUbbU5ssqjcch99I+kSqgfzXdhlJQCvZNRRayyi9cAnUXXaLhbyvsQCpVUf+qYMSjrzAFnbhNrXXObs45uSGDhUsFItUym0vsanDS7NIhWwNGlgrU9F7h2/3cUXp7KA
 vAdrSofZ
 sKDxYtW/uoh6mQSicNpX/xIbPBxuLBLT8LskQcYt1Ejxwe1/z0Eb6f4TPHiiGddsZDGe4hzjN5JaIBljRnYRomPKc1bzcjHXOqvaVYTU7LeFgnTtb84fVQtcMx9tWtNteZUf1Ec4EsbyN90VhsKmmv36wVZPPkDalvs/w9qeJrDZdGvzb+vLS4TQUPXrZoDUWDyou8EPwq+sKDQRQs+gGBwpWjWWNLp4gSGsV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Multiple different ranges still could be processed, but then one should
> continue using arch_enter_lazy_mmu_mode().
                 lazy_mmu_mode_enable()

