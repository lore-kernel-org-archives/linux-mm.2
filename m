Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF35FFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CC716B008C; Wed, 29 Apr 2026 09:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D536B00AC; Wed, 29 Apr 2026 09:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C896B00AD; Wed, 29 Apr 2026 09:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 074086B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:47:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC33E140273
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:47:26 +0000 (UTC)
X-FDA: 84711720492.23.049A7FA
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5FEAC180013
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:47:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CNZ694g+;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777470444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rOMQ6tII+w8eM+1uscKo4u6a8wS/+ZJZoe0f7koUOJM=;
	b=fcqXayo+6K/jVNlA3fGBTYsBaIPHVgxyHwsrtWCCsFAAaE0PQ1khdBYpgAah5YXtf2wIYX
	REqANPP2LVvjs3ZK0QyW2FCwOlXmYYERE/YXQjD7Hkv73bWY3wBF+76+4i7biUEnwq7Uxr
	kls4gzKOZVVNneeKRT1u/lSGxI+QcVw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777470444; a=rsa-sha256;
	cv=none;
	b=t1beiVpLgYYxRUkmqfCq4XduiNkZEZrbQpo8ey4YjpuDFiM4SFdHFu9jEc2XmLVJYNPBhj
	1b5G4NXDLjeO6FEyjIsepGfOVV9hNwOLgQzHeu0XZazCvS+bRuautn+H1gs3LcTBlx9vUR
	o5dgZYzwQaiRE/9ZvAPs1kHPNkbN1os=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CNZ694g+;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63T4ZTsr1694171;
	Wed, 29 Apr 2026 13:47:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=rOMQ6tII+w8eM+1uscKo4u6a8wS/+Z
	JZoe0f7koUOJM=; b=CNZ694g+lx5Ew32q5FKyxrU3a3d0qvQt4rV+Ypd6d1X+q4
	s2HHxrzNN0odYWHZreznFG0prK/1o2U2F0rxQudEGlQvvW7nn9l2TGUK11ASI9C7
	YgZXkJ0gQXDEIT+TKhrjpFyhqqZmnOzPuxv1sAqgtQh06J6BlUZ4uJ3h1jD/hsGc
	e5zlCAdXO0aCAZluv5yZRjz2fpVPWdOgjIxJSRYKwUZuiq6r4tmqla7oAJdNpEaW
	Xjst4GMxaBcKtG0AZVXQJIo0zUdg5uzj3fxT1YKx1DKOi4BlcYxHX9InLRHptWnt
	KTc1cMI/MjetQ9OOPfq05+PPyk6IhQsPbdikwhwA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drnb5arpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 13:47:21 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63TDdIjW030500;
	Wed, 29 Apr 2026 13:47:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ds7xqemu7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 13:47:20 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63TDlGYk35324172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Apr 2026 13:47:17 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB56E20043;
	Wed, 29 Apr 2026 13:47:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABAC720040;
	Wed, 29 Apr 2026 13:47:16 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.52.215.75])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 29 Apr 2026 13:47:16 +0000 (GMT)
Date: Wed, 29 Apr 2026 15:47:15 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <ljs@kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped_walk: add missing pgtable entry
 accessors
Message-ID: <f3140daa-9a7d-440e-a448-35aa8797357a-agordeev@linux.ibm.com>
References: <20260427052000.196402-1-agordeev@linux.ibm.com>
 <69c4c12c-7cdc-4a17-9eb7-6fb1a61f9834@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69c4c12c-7cdc-4a17-9eb7-6fb1a61f9834@kernel.org>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=AqDeGu9P c=1 sm=1 tr=0 ts=69f20be9 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=j5aMtUXh0naQkGdsk6gA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI5MDE0MCBTYWx0ZWRfXxTSLyxKf6Pf8
 KNJ4rpP3Syi3oag+YKwk2Awq0cKPIrlvQRSHdzQTbeh8Q7+KoS2b+6HBEHa5H7lnQvExaY0Nrx0
 uevRDFwpfxCIba8sG0GOWAgPBMRx6xMSD0lNsaf6BIrg9H/45oNt82xpQrzFf8KFTPtEP1AnK/V
 sCRL092IemCs/GOOUIP0XsCiubusBVz5L6NAK1+dAgkWAC7uPB/O8tsPT4IBhF+ugi63H97hCf1
 IirZAWGGdvH7RW0veIlzaEdq0gN8CrRCNSu/FWoKPkXkfcatIQ3jif0uY4pixVvyZcB+5eha7e/
 TVh3KwJiQ4mccDPASbBftAkKi44/MGwjNOrxJpITyVqjz/SJ4QTejhmU0RbU/cZ3YeKRNd7GW3I
 kRdRVtuMV+4zq5820dckDRlgBJf7IGzgLmgeewbRj4rGfSNNKZXmtPJuXC45/1uPEkQqR/3m2dw
 23HZBNYyFad76jUnRAA==
X-Proofpoint-GUID: yrv26ZzoKgHOt5QRWgP9HHSlaVzGQMv6
X-Proofpoint-ORIG-GUID: yrv26ZzoKgHOt5QRWgP9HHSlaVzGQMv6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_05,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604290140
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5FEAC180013
X-Stat-Signature: eqzicugwschh5rpyd1nhor9gycoknrca
X-Rspam-User: 
X-HE-Tag: 1777470444-301607
X-HE-Meta: U2FsdGVkX19ZP9cd/k9tGUpWVqlSVAAcaMkaI2fbuTV4e1Zq57kAWvZq3+TGxYJqFLDax7BCD+e3dv0HTTBXHs07K0IfNyf+YQWia2DyEtPLCWhQIW5fTRsIWMD2QLgxQVhwGFNicI5DEESEStip3tDCyTcJuYwymYpVWf8OygURTfk1CR9s+LZVJJsZYdpcWwVTtB1+rKavm4s96tjPVJ5OWCk795kC2FTx2m1MdgbLErwcPsNtRAzHhlC5/ozBWV8fWGikWt1f2qUDIX8+L7+2vJLla58KRv5v6hA0bzfmfvGUvBKnQEmkjYMDlCRetVw09/M1jhD959BZJwESPX4sdyj1YSMSrDpg7O9R+nN2F6apXIUZAJZbI189DZqpNJV8bKIh4uESY+e6qTCSUb3I6ylxLQfBRGYd1alv8vvKjwBWz5DTNKCOcQ/fVecbOT+yjZzZQCgvfiU3zkxL+vG4aPXD4JF7BiXyqURSX9PJONOqA39PlRPuXhcGdY7JmHZo2awMlCKEyPV3xozn+a/HdhvLKL/+BJQpejHe8/a8vRnmaCeCbjyAQnHDkyhNrHIlmPbWM6BifE2PxdIpHOAx3oEPLfKd3M3Z0nzaCyBWbiSsVrgworeEZJFlz4w4uECq1QQda0Id4WwvGogeF5/YHn/NPWrifrW8eHTLGxCpEazC0/nVmSTHiPtybwMWg495ELvlu1+BSZuuTzKrppzknSNSYcoodv47SKMWI1qWOfkBVgrbFwIhDm1jK6924bXvTXKxQkDn5u4xK2YKGQrTlihuUqV1NEWcHHtQXvSuhCr1Xh3AkRf7613TzBtsOWDUraoeDABn4G8JFP5KD/VQKate+Es8GqWkQZwWTyhmj/6wJSwfrhier26jLyl+xkumcLoCA6BYrMR7ElunhGwuiaWsqKpUuFJmNFLndoCQrgYSV/mLMeH6bVXPUdCrnAdwr2xDIUYuVzqSMZV
 EdYOPKIB
 6beeIRSbPPuPtVXfkN8eUY/fklP6KAvwCbSbOzSb6stw5VYNcgOqQNLdmVPCXgPpSZ2t6vFnYX2JbMc6bNDnRlkSBIvv/Ebp8yO9jQKYx2Sv5yoEmoR03kGea9rYL4Gu+92pICgxxdhKRU6TWmw3v84lyudC9sM7ehaxb1wX11zBEyk2nrzXGceDfBoDl/JD+JP6AkuyB8e29T5TzyeG9YFx9OrWM8cQiuuuLljTE22500Tb04nPoix0J/8RDoSBmxFka3umquV09nbyS0LQDPQ6GqFVoO3ZsiGNjySmFkfFSqqG7Hng5h9lp4G1AqYnmwtkvwuXA/Ekl35/QVR7SvPj1UeIqCaQg7DrZ2FtjPjfGFQRqAzxJJYpwzleAklhtdIm2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 11:02:50AM +0200, David Hildenbrand (Arm) wrote:
> On 4/27/26 07:20, Alexander Gordeev wrote:
> > Convert pgtable direct entry dereferences to the corresponding
> > pXdp_get() accessors. Use ptep_get_lockless() variant for PTE
> > reads when no lock is taken.
> > 
> > Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> > ---
> >  mm/page_vma_mapped.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> > index b38a1d00c971..a4520bb10d2a 100644
> > --- a/mm/page_vma_mapped.c
> > +++ b/mm/page_vma_mapped.c
> > @@ -41,7 +41,7 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
> >  	if (!pvmw->pte)
> >  		return false;
> >  
> > -	ptent = ptep_get(pvmw->pte);
> > +	ptent = ptep_get_lockless(pvmw->pte);

(*)

> >  	if (pte_none(ptent)) {
> >  		return false;
> > @@ -219,17 +219,17 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> >  restart:
> >  	do {
> >  		pgd = pgd_offset(mm, pvmw->address);
> > -		if (!pgd_present(*pgd)) {
> > +		if (!pgd_present(pgdp_get(pgd))) {
> >  			step_forward(pvmw, PGDIR_SIZE);
> >  			continue;
> >  		}
> >  		p4d = p4d_offset(pgd, pvmw->address);
> > -		if (!p4d_present(*p4d)) {
> > +		if (!p4d_present(p4dp_get(p4d))) {
> >  			step_forward(pvmw, P4D_SIZE);
> >  			continue;
> >  		}
> >  		pud = pud_offset(p4d, pvmw->address);
> > -		if (!pud_present(*pud)) {
> > +		if (!pud_present(pudp_get(pud))) {
> >  			step_forward(pvmw, PUD_SIZE);
> >  			continue;
> 
> Wasn't there a problem with folded page tables, where we would no longer be able
> to optimize out the folded page table accesses?

Ok, that is a different topic. I actually tried to resolve the lockless
issue(s) in (*) while the direct dereferences just seemed to be relevant
to go along (similarly to the GUP patch).

But I would rather resend ptep_get() => ptep_get_lockless() fixes for
this patch.

Would it work?

> I thought we discussed ways to resolve that. Let me dig ...
> 
> 
> -- 
> Cheers,
> 
> David

Thanks!

