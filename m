Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A1FFCC9C8
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 06:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC9A6B0088; Tue, 10 Mar 2026 02:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65AAD6B0089; Tue, 10 Mar 2026 02:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53BC76B008A; Tue, 10 Mar 2026 02:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 418086B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:28:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAE521A04D1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:28:13 +0000 (UTC)
X-FDA: 84529173666.26.E49FE86
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 777C14000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:28:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=swuCtPFk;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773124091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11zp6Xlu9HtM8NgFiRuGpK0JWZedKvnXV7uxGUZO7MI=;
	b=Vx07bTtbffMVCUF67y4m9MWHjvTgRQ0pGTJqpEcb8cCHj39eTi57Bbpuo6k9xBQo76ErEs
	jKfmnK0qNz5Dt36e/6PyuZXGdEjRYBZOUO1FEEbiMyZk0hyd8RcYgLRWZe85xCtMxFeS3L
	HYSawnOev7p1RvOiBFqquEknRuogaqc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773124091; a=rsa-sha256;
	cv=none;
	b=4POLCQPK7/26rGslzVtJ6fCpl+MuMlWAv9WKFi+raAgwqC8/UusQm7bSqNNibOKekVsGid
	mBU4NaCAlmGZX3zh5iClEG5aJWLcN2NSorcpmhOfijcfjxyA8W3UrXzW52Z8Wdxs8FVwAg
	hdiQx8fwnbm+JxnEjpIHc7DMXgXo/Pc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=swuCtPFk;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A5OGHR512979;
	Tue, 10 Mar 2026 06:27:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=11zp6X
	lu9HtM8NgFiRuGpK0JWZedKvnXV7uxGUZO7MI=; b=swuCtPFktVoEWAhDPvQATG
	6SLj/C369oEPuaO1oaPXI0DhluFzkddCKx8M5LS3+6TDj0qT3JVhhoa4gavTzPhS
	1Y6dOs7pcx5SEYD3rrWYhmDw1LHrpZG1aGSW2SQ2CDA3y6nCxz2pqFtyc9BNzai7
	8Zif7aXwsPx8JTQPO5x3hahR0m1xNkrA28GVtlroU32K134ZzOG3SKJY7+VFpb3z
	BxFa+24z3lYRE6e/xfu9TtqgiV7Ggi94wCSvnqVXABYzZQyZ5NPL48UoCSppPUN0
	Zxh86vb2tdUmbvUTwyFD7pIFbhdX8J8W/GXoFgTNapNb/RPVW5flon7F5zx5YBlg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crd1mhbu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 06:27:57 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A1qrKr024660;
	Tue, 10 Mar 2026 06:27:57 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cs0jjysgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 06:27:57 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A6RuaC7734126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 06:27:56 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F34EC5805A;
	Tue, 10 Mar 2026 06:27:55 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6B9E58051;
	Tue, 10 Mar 2026 06:27:53 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.98.109.174])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 06:27:53 +0000 (GMT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v2 1/2] drivers/vfio_pci_core: Change PXD_ORDER check from
 switch case to if/else block
From: Venkat <venkat88@linux.ibm.com>
In-Reply-To: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
Date: Tue, 10 Mar 2026 11:57:41 +0530
Cc: linuxppc-dev@lists.ozlabs.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
        Christophe Leroy <chleroy@kernel.org>, linux-mm@kvack.org,
        kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>,
        Peter Xu <peterx@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D0752596-C64F-4454-88F6-2D205CB43B4D@linux.ibm.com>
References: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=ds3Wylg4 c=1 sm=1 tr=0 ts=69afb9ee cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=TkzObPc7TtdjdkxZWH0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA0OCBTYWx0ZWRfX8Pbw1pZPSi2w
 8OEl2HmIth+EiBcYA5T11NX1NjHkkp6oRIuiq5ZYirgBIrxSd6K1LFFjFsJb0JLtjcHARShhdVi
 damULwfsnb1cVpzYQ7MX0TGoFDGT/pVZYHYG0JNx8zRj4DdvDj+Fh/5y2OP8E2S1Qrb7VGgsAbH
 oMETb8vmDg29Z2CcRX0XTkQhUUPDB3Muv/+W/Le1o1369QECfF/5BYEoLUj/nCijrY8Doc7a4nk
 Hvvrs8wJKR607HcyVbYNFuSh1hDS5iQHhnsmFJLgZ4oD5gxoI8wYoXiJtkw0p4ZfumyYVm+Slx9
 YB6HQZrRZixAfwjXWKP7Mnyzj3qF3v7QWzQgm6yyKqWXkBG1f/t+kzvqPaJChwkWyDjhxFFAPRS
 3iAGI6D4O+Xak4mL/f1iEc+Sa1DtEd8ueeotcjh7uew5ETjIDoxUd6/mJi1voZm6aYoZm2xoHu7
 0MzqoETFVvPLNqfOBBg==
X-Proofpoint-GUID: rUIBbepxIgIMAZgVxnhSla9Np10kf9Vh
X-Proofpoint-ORIG-GUID: Yn-QkYj-UwAT8YKWAgDDbqyS4eMFwDC4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 clxscore=1011 impostorscore=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100048
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 777C14000A
X-Stat-Signature: 9nzczo5gfa8gawgys94jsyhxp4staans
X-Rspam-User: 
X-HE-Tag: 1773124091-167889
X-HE-Meta: U2FsdGVkX19OPj+5MACizPZ2Zc9afxQtyiepSurnSjAE2AeAseFEdzP6XkdNhHI4PDmjV3swJ777+MsOvIT1YpkIJPbzuruKo3Xwrp5c4KryM7/DJwnigYmFEwOvgTUHf6hYdJOTTu8m6qpVHCObcI875mvEXxuBE64m+ZCwFd68vp1Tm4q9L657Ezxby/1ruOpFLFfcfgH/fuV8mDXoGNuWtuCpLup5soeki9EPMz0HzHMvJdKgvnvjzA65Iu6H5P4r6dd2VjnQoL4icH+MtYtSo2LrL5enhHH6/UVCU+pAf59CfiRAj1WDWgaYlXyU/MpgIyIrfeHsZAri41yQf9gNcJMbsWYiJnCldnqFhs9WqWrY+lHvWQwi85kk8N8c0Q0yIwZaHzDgmQNXyPyrReJIsIXc6pdJa9ERHBVz91hNBLap97WdOa2BdY4EsXSTgMJT9Rf3bUEFwbzaOjnWqHi/DkRFaTm0om0MEglFihxg5gE/mdUN63E0IZZR65vrHXbf37RILB5R47eSk4+aWDWcZy+D7qPkd8y2CEiEDjo4jpAlwGrZeLgDvIuAkdwknVGAFKEgK9rr/o165A6MTKXpIaQCfhdhViK9gDjYwEGJFW439twKzTjMrCvGcOqQPTW+9qHWn48vam1d4iY4LeGNgtpWUyu6x8fpNd4duJvQZKqYk16KP3q2SukxBymtOqJin+kn1FjF/yxfrxqYBe8iQH7bMFeXB9tNQXiPXyOSsdzwOuyX/6d/Ie35X8F3tPIwiTfIgcgAnKPLEr3zNti0221VD3UkEL9fQYmJIzWZgbUku9NaS9uI5xXA/oaIZtQO3jrnY0/ewBjtkqYARJxf3FDYPQlZ16L74A/eZMHGb6zIMzEi+kf73KnAttEwpCvO5WtynrcDJ7jJjwfG7OpDIGw0snz6E2HeZHQDEeSECjyf0KBl7bP2q97Lk6HDdvt6AcDqjulg1pMV1Fz
 EIv59NJO
 EpVub8lhTsG0UeXLM02PRBT6mKfcsdI45T/aBp30s+X+h4Q2PDliBP7NkGQoQNsCcrSgYsVSmMuoMEpyGlNme+VgLmpNqgm5TxTei8A2hiogItgdC2SIow4qPIBDz1poA2WJjj+VPRheZQvNu28Qnx7E+9wqZst+qVxpBSMvMswgjcAfOYZtKhOlyiz/8qnTUuzhNmHYPH/3WRVxsXBKi6YQ02SZI9wXsYj+93DmOP+dhu9rd7UIgHx6+1dpSS9u9iR+aK0zm6hlhn6uMGdXIqlUYiO/N78p0SAKCrEUCLPv7lzoWOP8BmatnIbSPoHTNQK0Xwuy9skuYcDxK0AxazalGdqf2hrkCypROaKdnpOCpDJ2uESyN6pJpSx+sIk3ij0fLH7vS3hbclvJFFeh9TScfnQS9EzUDOucZwgImXSdC/uz/2DMJKBLblUk4vym//gtOzyWw6NX8PmcR8MA0zbbG0DeNGMPk4h96f2FFKh1Cs6AbeNgFev1/YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 9 Mar 2026, at 6:08=E2=80=AFPM, Ritesh Harjani (IBM) =
<ritesh.list@gmail.com> wrote:
>=20
> Architectures like PowerPC uses runtime defined values for
> PMD_ORDER/PUD_ORDER. This is because it can use either RADIX or HASH =
MMU
> at runtime using kernel cmdline. So the pXd_index_size is not known at
> compile time. Without this fix, when we add huge pfn support on =
powerpc
> in the next patch, vfio_pci_core driver compilation can fail with the
> following errors.
>=20
>  CC [M]  drivers/vfio/vfio_main.o
>  CC [M]  drivers/vfio/group.o
>  CC [M]  drivers/vfio/container.o
>  CC [M]  drivers/vfio/virqfd.o
>  CC [M]  drivers/vfio/vfio_iommu_spapr_tce.o
>  CC [M]  drivers/vfio/pci/vfio_pci_core.o
>  CC [M]  drivers/vfio/pci/vfio_pci_intrs.o
>  CC [M]  drivers/vfio/pci/vfio_pci_rdwr.o
>  CC [M]  drivers/vfio/pci/vfio_pci_config.o
>  CC [M]  drivers/vfio/pci/vfio_pci.o
>  AR      kernel/built-in.a
> ../drivers/vfio/pci/vfio_pci_core.c: In function =
=E2=80=98vfio_pci_vmf_insert_pfn=E2=80=99:
> ../drivers/vfio/pci/vfio_pci_core.c:1678:9: error: case label does not =
reduce to an integer constant
> 1678 |         case PMD_ORDER:
>      |         ^~~~
> ../drivers/vfio/pci/vfio_pci_core.c:1682:9: error: case label does not =
reduce to an integer constant
> 1682 |         case PUD_ORDER:
>      |         ^~~~
> make[6]: *** [../scripts/Makefile.build:289: =
drivers/vfio/pci/vfio_pci_core.o] Error 1
> make[6]: *** Waiting for unfinished jobs....
> make[5]: *** [../scripts/Makefile.build:546: drivers/vfio/pci] Error 2
> make[5]: *** Waiting for unfinished jobs....
> make[4]: *** [../scripts/Makefile.build:546: drivers/vfio] Error 2
> make[3]: *** [../scripts/Makefile.build:546: drivers] Error 2
>=20
> Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---

Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>

Tested this patch, and with this, build is successful and reported issue =
is fixed.


WithOut this patch:

drivers/vfio/pci/vfio_pci_core.c: In function =
=E2=80=98vfio_pci_vmf_insert_pfn=E2=80=99:
drivers/vfio/pci/vfio_pci_core.c:1677:9: error: case label does not =
reduce to an integer constant
 1677 |         case PMD_ORDER:
      |         ^~~~
drivers/vfio/pci/vfio_pci_core.c:1681:9: error: case label does not =
reduce to an integer constant
 1681 |         case PUD_ORDER:
      |         ^~~~

Regards,
Venkat.
> v1 -> v2:
> 1. addressed review comments from Christophe [1]
> [1]: =
https://lore.kernel.org/linuxppc-dev/0b8fce7a61561640634317a5e287cdb479471=
5fd.1772170860.git.ritesh.list@gmail.com/
>=20
> drivers/vfio/pci/vfio_pci_core.c | 19 +++++++------------
> 1 file changed, 7 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c =
b/drivers/vfio/pci/vfio_pci_core.c
> index d43745fe4c84..0967307235b8 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1670,21 +1670,16 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct =
vfio_pci_core_device *vdev,
> if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
> return VM_FAULT_SIGBUS;
>=20
> - switch (order) {
> - case 0:
> + if (!order)
> return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
> -#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> - case PMD_ORDER:
> +
> + if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order =3D=3D =
PMD_ORDER)
> return vmf_insert_pfn_pmd(vmf, pfn, false);
> -#endif
> -#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> - case PUD_ORDER:
> +
> + if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order =3D=3D =
PUD_ORDER)
> return vmf_insert_pfn_pud(vmf, pfn, false);
> - break;
> -#endif
> - default:
> - return VM_FAULT_FALLBACK;
> - }
> +
> + return VM_FAULT_FALLBACK;
> }
> EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);
>=20
> --
> 2.39.5
>=20
>=20


