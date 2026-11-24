Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC72606A337
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=oOnZvmhF
Received: by kanga.kvack.org (Postfix)
	id A85DF6B0825; Tue, 24 Nov 2026 13:25:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DC86B0827; Tue, 24 Nov 2026 13:25:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94C476B0828; Tue, 24 Nov 2026 13:25:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A2616B0825
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:25:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEE2B140C37
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:25:56 +0000 (UTC)
X-FDA: 85470841512.17.87172A9
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4D2681C0007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:25:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oOnZvmhF;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795544754;
	b=TjkcTudh3GxYhWf9h0DodovBCrPotZi4aUgmL25YK+yMpFqabWMiUUqaxVkUI3CO3v+jft
	6OhjUqk6+3fthwynfcsLVIKDwQj8v2/YlTl/cwM7j8DZcNNjtYZ+cxZq8RJnRDsrm42O8e
	ew0xq24NIrSagkPWHc00SVp2a8cVuqw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795544754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ra3jsCKFlcyeQDzEHh5eXFmT0/Lsiag2Ank3S7B2Ljk=;
	b=jY9Q3DKifv7LwLXoUca4K4BGBB33urXm26mRRanDsX8FDcy4AyOcMjNGGgnAgpJIf2Xxx0
	GnYW+ToknqoyyNx1gxSf1nJpPMa2YDtLV+gm/biEui6PATYTUlaj3WCZTh2/s7bELMEtT+
	03r2zlwTSr47qxh2Zc4VMqvTiyckGWk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oOnZvmhF;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOFa3Fr1235397;
	Tue, 24 Nov 2026 18:25:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Ra3jsC
	KFlcyeQDzEHh5eXFmT0/Lsiag2Ank3S7B2Ljk=; b=oOnZvmhFVNG5Kr8XsfcFc4
	5NIcvm4VfWZqI/AVSBiPZECeE8oY0iOTNcWveDWF0UkcikXu6fnz06Bdrc7W3dxO
	NoGlyqXgKRFHe57HciR3lFKsO0IcO7+88dtRrScNjIq2YAe5Op4+FU8wqHeG7O3E
	ixl+NcSx96vzOL71pWpVYdUmR9DvOqFhbt7iNt5/Kjd5X9x4lw0yU+r3f7Mdyax3
	5GddgGFKr3eIQ5/hk+b96jECQf+uLAy4gf2e+3stWsewwe9i5MMiJxOBXzRqEbGj
	1W+6/xUF4+oEiBYeMZtYkhNv5TjOTQ4RO0aYzmI2FA858YUOnuyaafjHExiZJyIQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g3948h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 18:25:48 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOFJbNd3536144;
	Tue, 24 Nov 2026 18:25:47 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j5axks24c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 18:25:46 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AOIPhDw52494668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Nov 2026 18:25:43 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D7A92004B;
	Tue, 24 Nov 2026 18:25:43 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F26520040;
	Tue, 24 Nov 2026 18:25:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.42.244])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 24 Nov 2026 18:25:41 +0000 (GMT)
Date: Tue, 24 Nov 2026 19:24:24 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Carlos =?UTF-8?B?TMOzcGV6?= <clopez@suse.de>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-riscv@lists.infradead.org,
        seanjc@google.com, pbonzini@redhat.com, akpm@linux-foundation.org,
        david@kernel.org, peterx@redhat.com, ljs@kernel.org,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        Steffen Eiden
 <seiden@linux.ibm.com>,
        Andreas Grapentin <gra@linux.ibm.com>, Marc Zyngier
 <maz@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven
 Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH v3 9/9] KVM: s390: don't unmap the gmap on permission
 upgrade
Message-ID: <20261124192424.157a46a3@p-imbrenda>
In-Reply-To: <20261112142039.907090-11-clopez@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
	<20261112142039.907090-11-clopez@suse.de>
Organization: IBM
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=SoQFe/O0 c=1 sm=1 tr=0 ts=6b05d6ac cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=AIa7Fw-m9XHv1_55a70A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA3MSBTYWx0ZWRfX6p5dAHjNm+tJ
 qQNhTSDIlZnGYtXWPLXPqs5WlzEtXy+hx65yydYPUl/PGfIM7uVi9ErV5Q32g+TgTNi6JdF3m7P
 5r7jOiAPI82eUkSec2zsoD31ScW/wJ0=
X-Proofpoint-ORIG-GUID: _bOIgOxr_71bpzoMoIN84JN7KDxL3hkY
X-Proofpoint-GUID: dlWeO2vv-EDCUQu4fy26Fmp8c1EHzeHa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA3MSBTYWx0ZWRfX+h8EAijKXqe5
 V6b1bS4c+YLh7vvhyQUKQ/smtKmFgYHCj6DxqojRQ4HVbE+AZ3JaN0DC2GvWKwfecsm5KM3q1tF
 HZJ1a8qM9WJxDWcUORAvrBEZXPaj2GF4tPsnQpbamBQi50GGUxdJTeBrWikcgR75u5jvyUr9AUj
 bMaPF2BWeCmR7hpNSNT0ucBQu8LOI8fZnu+ph9PXZscXA/9oYeTXxMxcdNYhGzbQwyvyxdrzXKr
 6+9hMmtZmT3Ha1CPL3DR1B99bmCpVaaTlKctbRkfy3RgEcXmrDon/5/Tz3Yt+k2IMsKlxlmNv1i
 qsB3cvUFV0Uu3hpBeMLU3bLOXLdlE5JWmAIXj08XCOwXpq6YcVdCgr/W+w/yrXpCKf0PvhrESBt
 O13rYkkaud/WnF6pBfqx78gZks+Bs2OIuTYpcwrxMskeBMk45d1lJ3Q/S1FnFyR2I1EmIv6yPiR
 Uz31equXc3fVclY/ACQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_04,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240071
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 4D2681C0007
X-Stat-Signature: ci9ommqfpcddgyr179b8ot5yfjmu1ngg
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795544754-909705
X-HE-Meta: U2FsdGVkX1++OuYKfUu9FLeYKQDXtT2Kwt9l0kNcxcSxHZN6qZmPD/xM62xeY5VUtL/dDO4kRw8MxC1Ak5ohXG/JLMP9fva3m9pCdL+qll1nDSGU1EzQ0ob8Qdq2xqZ1pXr/l2sVp/90EcXF0nLKIDzGeutTXPG6Ocz17V2+Ea68gMcG8VB3I5Ida0BPMqsqpG4z+ebBbNnLvS7Wvq7hrXYqfo5iR2xutB6hM8ENjx0WSYjCf0DskqrFIR44OpsbJGrdjNHL+O3CoCJ1nTMcIzb1ebBb7dCQJtHShXP40TySYIcGdicEqZ7OyQgnxxkq6/UXkMsdwWOz0w+fjD/ehyFpOwB97Yfy4TujgaZjtGszZYg0sjZo2XInNK4bDylsHXlWqZTheAyXIhvmezi8u7JXVCddmqWH3HspDhmTlqD8r/Mys/0GpjelwNEDRxXFgeTqbx+MPtw9Ru5fhDjXBe1EHP2ZyKwoc1Xja+OXd80mmdohmiqGZIxOtPkiGqPi7R00uxZ2Ps/n+LAyBzKqix+IidYOnOoZu5stwAaxplIsGyd5mowirweShwyZHPiv08e0vabQUqyf65cVs0nUZ1hCs/Wfbig+usno2NHGdPe/uHSEqtfAq8ZtTK3nIUpdqw72v1OK2jo3jYGAmut3BN5O5Og9iyWv5CUjCLedgm76Y7TztMs4yiSdoVVnEgUi9x2S/h9yacrf2Oc3jWw91h63x40MkNIuikWOkGSf6xmYhfd49rFFFZO8qhg0XnLj9Z5I/YWOmKnjwSFEvixpa/zgOkYIF/zrfK6BCgTl9dWxYXztwjFdP8ffYo0sGkqwm8VkPn7Mn8cFXEXm6Bi1AOKU7tgWL/3rLkYUTW1KGXMA8BAu7NoOPKmcDC8dIKXmhr+PJARQTfuJUsRo2n8g6uDxjLhiPLObojkGfTJDrCjvdLpQpiER8emzV1qKW+068c1tk1+8Pdoc9tfD3SO
 XtKf1BOu
 jO/v6VmTtr6ScoNRl3Js58Xbr1BsJyPpHLLWQTpT8nfpZycwxVgYlnwuoOnjF0Ya8s6AheeRjRI8Y6ydZTGPMcsEVcW37puVFb6LTgz12Tl/qcjkxpPT5uUmtARZGhUFXhofGnauuKidQTMFR8BxVldoEkxZlw4hOpT1+U6Pd3w944xYEhcAh70lilB5Osf4e7Lj4JflEyo5dV5F9J5PGEMnLsWDyzfHpirYHH/OPAnwd53hxnSycJNszBk2y7+GeoLb6JKuydhXsGAmedANJd7+q4qV9tCu0K3RTSS4lo33uzfRdRLKgnGPQE1Eth+KDm0CXDDUcTWZTIsAqRaAHiktEUYbDsP8Uar+IYFqXNsr5ykvrumQuEGlrr0IZtc+XDxgFBTHrWK8eILXPOMibtb/Cv+v6CU9q2F6NU8H3+susdnese/a9d4P3APTZmQXbNUAz5WWeV4cQV+weT4e+ZNvisYTsVXoUXTz7uehPXQijW1vafQmza5HpoH3sCC6nDHcobusApD3zxMVomdGpWnm3s4FztMpL9HTC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 15:20:38 +0100
Carlos L=C3=B3pez <clopez@suse.de> wrote:

> When an mmu_notifier invalidation only upgrades permissions
> (MMU_NOTIFIER_RANGE_PERM_UPGRADE), keep the existing gmap entries
> instead of unmapping them. The PFN is unchanged and no access is
> revoked, so an existing entry is no more permissive than the new host
> PTE.
>=20
> A write to an entry that is still read-only causes a protection
> exception, which kvm_s390_faultin_gfn() handles as a write fault. This
> applies to both s390 and arm64 guests.
>=20
> Signed-off-by: Carlos L=C3=B3pez <clopez@suse.de>
> ---
>  arch/s390/kvm/arm64/arm.c | 7 +++++++
>  arch/s390/kvm/s390/s390.c | 7 +++++++
>  2 files changed, 14 insertions(+)
>=20
> diff --git a/arch/s390/kvm/arm64/arm.c b/arch/s390/kvm/arm64/arm.c
> index bd9d85235f43..5aee1817aad8 100644
> --- a/arch/s390/kvm/arm64/arm.c
> +++ b/arch/s390/kvm/arm64/arm.c
> @@ -678,6 +678,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm, =
struct kvm_memory_slot *old,
> =20
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
> +	/*
> +	 * Do not bother unmapping if this is only a protection upgrade.
> +	 * Permissions will be faulted-in on demand.
> +	 */
> +	if (range->flags & MMU_NOTIFIER_RANGE_PERM_UPGRADE)
> +		return false;

this works for now, but in general the meaning of the flags bits depends
on the value of range->event; it wouldn't hurt to add a check like this:
	range->event =3D=3D MMU_NOTIFY_PROTECTION_VMA

> +
>  	return gmap_unmap_gfn_range(kvm->arch.gmap, range->slot, range->start, =
range->end);
>  }
> =20
> diff --git a/arch/s390/kvm/s390/s390.c b/arch/s390/kvm/s390/s390.c
> index 18fb200f854a..954bf6b64683 100644
> --- a/arch/s390/kvm/s390/s390.c
> +++ b/arch/s390/kvm/s390/s390.c
> @@ -5871,6 +5871,13 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_r=
ange *range)
>   */
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
> +	/*
> +	 * Do not bother unmapping if this is only a protection upgrade.
> +	 * Permissions will be faulted-in on demand.
> +	 */
> +	if (range->flags & MMU_NOTIFIER_RANGE_PERM_UPGRADE)
> +		return false;
> +
>  	return gmap_unmap_gfn_range(kvm->arch.gmap, range->slot, range->start, =
range->end);
>  }
> =20


