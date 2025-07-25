Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58EBFC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22EE6B0092; Fri, 25 Jul 2025 11:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFADA6B0093; Fri, 25 Jul 2025 11:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE91D6B0095; Fri, 25 Jul 2025 11:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC6426B0092
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:58:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DB90113C75
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:58:44 +0000 (UTC)
X-FDA: 83703244968.09.898B3C4
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id E2586100009
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:58:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PKTAzC1X;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of farman@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=farman@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753459122; a=rsa-sha256;
	cv=none;
	b=QrvvUmMEy1v+CYkF+GLTY4zzmf0Xlse7bkk3FQTxXxXhCciQx3rZHXYV9xSuE9RkqcVWr/
	8e9+r5B8akttEBi5zSJSnz5ziOkn6wWToQpiGUkDfiCkRUw3mSOTZzFHy2RWgs8oInoM1D
	jWKuRW42R6XZc9wTln8gI0XEzUBqvvE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PKTAzC1X;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of farman@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=farman@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753459122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LxbE+/gQ9gygsLq/HO28g0FVJfZ+6+Bs4E0ZbZMJV2c=;
	b=0AtXolkwlzZajnKKCYDuXhXhwuyBIvABqLitBh48e/iuZ50UUnLDltIxMZY9AMzumjH+Mw
	ABuNklFqTHiSbrXpyIYuXmCPwd3AymdiZtCdtPNB8IPKXdnxPwi1EiaOmf4EJkcLOhjF9c
	CCxIS0RbUCvZ2t2thNUHaI/nnDEMfD4=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PAvkSZ012234;
	Fri, 25 Jul 2025 15:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LxbE+/
	gQ9gygsLq/HO28g0FVJfZ+6+Bs4E0ZbZMJV2c=; b=PKTAzC1XoSKDQYTCBdCTeK
	vx5Y64HRg87JuoRXVl39ejgNf4GanhcckUvsNEsYGrLO1kpY/s+MTmk2PYnXLmvs
	vJ0/0JqLscTGM8ug8gr8275fFWyS8L1IeaNwdGgKKu2JtCPHp4Kaw+Yd4ycC2vFN
	ddCikuLwsBt92WyhJ2ItDSO+MFDrFLVJGCc+LUNzN6phO0jh1wsj6rI6UfP9VSYM
	aJThOAzLFu+y2Cnf7YJrUcFuz+BoM3Fl1PBXlZiEeaBuWi+Glc/TeO1W99ITAS5I
	8jFwHiddj55/laGE42UeU40TKMbPKy1qQ8KcIesKQqsX+BqDUSNK1S/p3FNmDx5g
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 483wchm038-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 15:58:30 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56PBlTUL005486;
	Fri, 25 Jul 2025 15:58:30 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 480tvr9e61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 15:58:30 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56PFwTX626936058
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 15:58:29 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F1BA5805A;
	Fri, 25 Jul 2025 15:58:29 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD0FD58051;
	Fri, 25 Jul 2025 15:58:28 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.34.8])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 25 Jul 2025 15:58:28 +0000 (GMT)
Message-ID: <4ec3adca59bdebe5a36083a381cc8f739b5026f8.camel@linux.ibm.com>
Subject: Re: [PATCH v4 2/5] vfio/type1: optimize vfio_pin_pages_remote()
From: Eric Farman <farman@linux.ibm.com>
To: lizhe.67@bytedance.com, alex.williamson@redhat.com
Cc: akpm@linux-foundation.org, david@redhat.com, jgg@ziepe.ca,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        peterx@redhat.com
Date: Fri, 25 Jul 2025 11:58:28 -0400
In-Reply-To: <20250725065937.65848-1-lizhe.67@bytedance.com>
References: <20250724105608.73b05a24.alex.williamson@redhat.com>
	 <20250725065937.65848-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Q7rS452a c=1 sm=1 tr=0 ts=6883a9a7 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=968KyxNXAAAA:8 a=20KFwNOVAAAA:8
 a=VnNF1IyMAAAA:8 a=_Q0FFdg1zWTTCSaKA1wA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDEzMCBTYWx0ZWRfX1uVIO4K4trS7
 YVcnFKrAcGbF60UsLZjo78TuBXTkPJaRgXy2FqA2vgIAxM62EJNzXBokmgjfcDYzurnZpYh8diE
 yiJm1RzL3AymQbqI+WT8gh/9JShAE1wkJXfthscOI1o/TcZdDtyuzUMnQkp8c88aRTw0DrUXGHm
 6t5vJEBzm9xz1B56XzWz9MktAoDRkl9eXiFXeBXADVKwFU4EwNO/R1rRnHvC0pJsjf3iuWKqrpv
 9BB1CRJ63n4NBssTo8r67IR8ifseYPucdmtM05/kJIGBoe7cH57mYrJf+WxDlvmy9Z7TDla1YDh
 1JgberG0o7MgODqXL4qcCqCOmRI+Y8LJ+EEMUB6xlDUsfkOvw20GuQTmJODMt7SQdsaOOIec6fT
 ZQtLI5zdyPITqtA24IGMxm0KRxHprbcw604ynTkEQX58g7v96StFYkGpTNJPjoJae4MBE2b6
X-Proofpoint-GUID: paNnmCwECsKzNKZFAi4cfSyA9xrToEc2
X-Proofpoint-ORIG-GUID: paNnmCwECsKzNKZFAi4cfSyA9xrToEc2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_04,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 bulkscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507250130
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E2586100009
X-Stat-Signature: o3c8h3e1dscb9i75s9g1j1wo9zh8sdfh
X-Rspam-User: 
X-HE-Tag: 1753459121-941045
X-HE-Meta: U2FsdGVkX18qTe4bemsOwxA7J5SokoB4rDfV+NcDhbU7Mh4jB0EeFswlGPf4iy1HCSwZya+IVib0QgentK3ZhbRFG5jO5vKGL3g0hWnVJKohrcKdRXxCHNw8qhl+X2EnYnupJXUBhIRAZ9KvwuQk2RBlLJRwbfB9JTNNvIMA1elJNPEKNprim3fTK/gCBee39n6aPI7f/vSZjm05FkSazN+CqFjxHCOHWa5vItfmrvbds3hxtNMt5m0z9pTkk2zBuyTx6mKKR2ISEngucJP0mthymUSw3Iq4lbfLsdPGhc6jo4JqQjb6G1fdWXPNFYHRyuvjIMvojaNOJ/cs3WK/wgPlq+Qh0Kj50JjtJiONKROP3Y0zOamzDTQ39yL9gryMgCUiu70xTeuhF4DcRUr6B5XMaWb+nMoUpd5bblLMVvE0Wp77M0guQE2eq7x2o4fmAY37uXoBAdJu4ZZ7DoCugTNzRqNhxh50+rjbC393GyVJR9IxDv2D03Q0Yv7ZxmGGONF67jrCDlZVZgDMPecwAeLHh91P2SBl2DvqEKRXbt7BYEIHJsgkOu/jqUNwL9CJV/BjAs3TG04b7Hrw5zYX/aQe9v0qJJeoBzuMNVnAhLChlbxdl3PSyHgSMAge8heMxb53W2s03F+DgNjAu+XUYDrviVJx0V316O7igdkHZEUGueGX/xcRWNnO+YqfIrH7SDPWJjkEnQ0nwZ3xlvpj4UNuyupGe+zcK6JQQcAP88jwdoY3Jdeb7X4biI+G3iqRy87HNGCvTyDzXFt7sIunD4ujISJLhb2kCbTFzFgFXb26uk7OoaszxpCq4ln2u0JDLVCC7OTYgOnn7+shdj9Fv3SIosOZWu8mfVTkPgnLx/KJXKDwrVro0bOJoHnquVZFdEYZjtU31AJsbeA4/4wkCfmpGWEs7G8DkPRi6tNUcBr2+wHELSmY+Yj9fT4WNnbbjQNqyS5BxHRjWE9lBtZ
 I6KGQoRl
 r7CAY46X7wTZKlb76TDZu3O4NKI10d8uZPi+Dime3l3Zebc4dlBX/8Lzsopu4URke22/5uwzDRblezItyKv/jwphdCGelxuRTE5ikqLmF5WW8rCenHyg2DYKLDMJWHgu/w7KBAtcTNs5flYY2Zz76Wp70M6S9rAjjj5iyKwD6z1mTpUeDvNxXVydi0dzWHDMB4smNcGKEkEapF5J68GOzh6DfzHDzAexFw0VxPkiQVrDgbCrTD35itWfMcpFQ52mNifhnUlF1zirJC9JTPJtuyo0pH1U6ly0zULgWC6JnwCAFkrmaRPw9PJsoTL6kUosjimiRjuDwqhFTtLmryCUqA35RhZEme6XA2H13BUwq8ZvtSkLX0aZ6ZaKo4Y5Pf40tvWOUJWMfKQUsdjvfqZ3BS/T9cOWIaUVAHu5vgJLzF63Y4e8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-07-25 at 14:59 +0800, lizhe.67@bytedance.com wrote:
> On Thu, 24 Jul 2025 10:56:08 -0600, alex.williamson@redhat.com wrote:
> =20
> > On Thu, 24 Jul 2025 10:40:38 +0800
> > lizhe.67@bytedance.com wrote:
> >=20
> > > On Wed, 23 Jul 2025 10:41:34 -0400, farman@linux.ibm.com wrote:
> > > =20
> > > > On Wed, 2025-07-23 at 15:09 +0800, lizhe.67@bytedance.com wrote: =
=20
> > > > > On Tue, 22 Jul 2025 12:32:59 -0400, farman@linux.ibm.com wrote:
> > > > >   =20
> > > > > > On Thu, 2025-07-10 at 16:53 +0800, lizhe.67@bytedance.com wrote=
: =20
> > > > > > > From: Li Zhe <lizhe.67@bytedance.com>
> > > > > > >=20
> > > > > > > When vfio_pin_pages_remote() is called with a range of addres=
ses that
> > > > > > > includes large folios, the function currently performs indivi=
dual
> > > > > > > statistics counting operations for each page. This can lead t=
o significant
> > > > > > > performance overheads, especially when dealing with large ran=
ges of pages.
> > > > > > > Batch processing of statistical counting operations can effec=
tively enhance
> > > > > > > performance.
> > > > > > >=20
> > > > > > > In addition, the pages obtained through longterm GUP are neit=
her invalid
> > > > > > > nor reserved. Therefore, we can reduce the overhead associate=
d with some
> > > > > > > calls to function is_invalid_reserved_pfn().
> > > > > > >=20
> > > > > > > The performance test results for completing the 16G VFIO IOMM=
U DMA mapping
> > > > > > > are as follows.
> > > > > > >=20
> > > > > > > Base(v6.16-rc4):
> > > > > > > ------- AVERAGE (MADV_HUGEPAGE) --------
> > > > > > > VFIO MAP DMA in 0.047 s (340.2 GB/s)
> > > > > > > ------- AVERAGE (MAP_POPULATE) --------
> > > > > > > VFIO MAP DMA in 0.280 s (57.2 GB/s)
> > > > > > > ------- AVERAGE (HUGETLBFS) --------
> > > > > > > VFIO MAP DMA in 0.052 s (310.5 GB/s)
> > > > > > >=20
> > > > > > > With this patch:
> > > > > > > ------- AVERAGE (MADV_HUGEPAGE) --------
> > > > > > > VFIO MAP DMA in 0.027 s (602.1 GB/s)
> > > > > > > ------- AVERAGE (MAP_POPULATE) --------
> > > > > > > VFIO MAP DMA in 0.257 s (62.4 GB/s)
> > > > > > > ------- AVERAGE (HUGETLBFS) --------
> > > > > > > VFIO MAP DMA in 0.031 s (517.4 GB/s)
> > > > > > >=20
> > > > > > > For large folio, we achieve an over 40% performance improveme=
nt.
> > > > > > > For small folios, the performance test results indicate a
> > > > > > > slight improvement.
> > > > > > >=20
> > > > > > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > > > > > Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > Acked-by: David Hildenbrand <david@redhat.com>
> > > > > > > ---
> > > > > > >  drivers/vfio/vfio_iommu_type1.c | 83 +++++++++++++++++++++++=
+++++-----
> > > > > > >  1 file changed, 71 insertions(+), 12 deletions(-) =20
> > > > > >=20
> > > > > > Hi,
> > > > > >=20
> > > > > > Our CI started flagging some crashes running vfio-ccw regressio=
ns on the -next kernel beginning with
> > > > > > next-20250717, and bisect points to this particular commit.
> > > > > >=20
> > > > > > I can reproduce by cherry-picking this series onto 6.16-rc7, so=
 it's not something else lurking.
> > > > > > Without panic_on_warn, I get a handful of warnings from vfio_re=
move_dma() (after starting/stopping
> > > > > > guests with an mdev attached), before eventually triggering a B=
UG() in vfio_dma_do_unmap() running a
> > > > > > hotplug test. I've attached an example of a WARNING before the =
eventual BUG below. I can help debug
> > > > > > this if more doc is needed, but admit I haven't looked at this =
patch in any detail yet.
> > > > > >=20
> > > > > > Thanks,
> > > > > > Eric
> > > > > >=20
> > > > > > [  215.671885] ------------[ cut here ]------------
> > > > > > [  215.671893] WARNING: CPU: 10 PID: 6210 at drivers/vfio/vfio_=
iommu_type1.c:1204
> > > > > > vfio_remove_dma+0xda/0xf0 [vfio_iommu_type1]
> > > > > > [  215.671902] Modules linked in: vhost_vsock vmw_vsock_virtio_=
transport_common vsock vhost
> > > > > > vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ip=
v4 nf_reject_ipv4 nft_reject act_csum
> > > > > > cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv=
6 nf_defrag_ipv4 nf_tables pkey_pckmo
> > > > > > s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_co=
re vfio_ccw mdev vfio_iommu_type1
> > > > > > vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_=
multipath loop nfnetlink ctcm fsm
> > > > > > zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390=
 prng aes_s390 des_s390 libdes
> > > > > > sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rp=
crdma sunrpc rdma_ucm rdma_cm
> > > > > > configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc=
 scsi_dh_alua pkey autofs4
> > > > > > [  215.671946] CPU: 10 UID: 107 PID: 6210 Comm: qemu-system-s39=
 Kdump: loaded Not tainted 6.16.0-
> > > > > > rc7-00005-g4ff8295d8d61 #79 NONE=20
> > > > > > [  215.671950] Hardware name: IBM 3906 M05 780 (LPAR)
> > > > > > [  215.671951] Krnl PSW : 0704c00180000000 000002482f7ee55e (vf=
io_remove_dma+0xde/0xf0
> > > > > > [vfio_iommu_type1])
> > > > > > [  215.671956]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 A=
S:3 CC:0 PM:0 RI:0 EA:3
> > > > > > [  215.671959] Krnl GPRS: 006d010100000000 000000009d8a4c40 000=
000008f3b1c80 0000000092ffad20
> > > > > > [  215.671961]            0000000090b57880 006e010100000000 000=
000008f3b1c80 000000008f3b1cc8
> > > > > > [  215.671963]            0000000085b3ff00 000000008f3b1cc0 000=
000008f3b1c80 0000000092ffad20
> > > > > > [  215.671964]            000003ff867acfa8 000000008f3b1ca0 000=
001c8b36c3be0 000001c8b36c3ba8
> > > > > > [  215.671972] Krnl Code: 000002482f7ee550: c0e53ff9fcc8	brasl	=
%r14,00000248af72dee0
> > > > > >            000002482f7ee556: a7f4ffcf		brc	15,000002482f7ee4f4
> > > > > >           #000002482f7ee55a: af000000		mc	0,0 =20
> > > > > >           >000002482f7ee55e: a7f4ffa9		brc	15,000002482f7ee4b0 =
=20
> > > > > >            000002482f7ee562: 0707		bcr	0,%r7
> > > > > >            000002482f7ee564: 0707		bcr	0,%r7
> > > > > >            000002482f7ee566: 0707		bcr	0,%r7
> > > > > >            000002482f7ee568: 0707		bcr	0,%r7
> > > > > > [  215.672006] Call Trace:
> > > > > > [  215.672008]  [<000002482f7ee55e>] vfio_remove_dma+0xde/0xf0 =
[vfio_iommu_type1]=20
> > > > > > [  215.672013]  [<000002482f7f03de>] vfio_iommu_type1_detach_gr=
oup+0x3de/0x5f0 [vfio_iommu_type1]=20
> > > > > > [  215.672016]  [<000002482f7d4c4e>] vfio_group_detach_containe=
r+0x5e/0x180 [vfio]=20
> > > > > > [  215.672023]  [<000002482f7d2ce0>] vfio_group_fops_release+0x=
50/0x90 [vfio]=20
> > > > > > [  215.672027]  [<00000248af25e1ee>] __fput+0xee/0x2e0=20
> > > > > > [  215.672031]  [<00000248aef19f18>] task_work_run+0x88/0xd0=
=20
> > > > > > [  215.672036]  [<00000248aeef559a>] do_exit+0x18a/0x4e0=20
> > > > > > [  215.672042]  [<00000248aeef5ab0>] do_group_exit+0x40/0xc0=
=20
> > > > > > [  215.672045]  [<00000248aeef5b5e>] __s390x_sys_exit_group+0x2=
e/0x30=20
> > > > > > [  215.672048]  [<00000248afc81e56>] __do_syscall+0x136/0x340=
=20
> > > > > > [  215.672054]  [<00000248afc8da7e>] system_call+0x6e/0x90=20
> > > > > > [  215.672058] Last Breaking-Event-Address:
> > > > > > [  215.672059]  [<000002482f7ee4aa>] vfio_remove_dma+0x2a/0xf0 =
[vfio_iommu_type1]
> > > > > > [  215.672062] ---[ end trace 0000000000000000 ]---
> > > > > > [  219.861940] ------------[ cut here ]------------
> > > > > >=20
> > > > > > ...
> > > > > >=20
> > > > > > [  241.164333] ------------[ cut here ]------------
> > > > > > [  241.164340] kernel BUG at drivers/vfio/vfio_iommu_type1.c:14=
80!
> > > > > > [  241.164358] monitor event: 0040 ilc:2 [#1]SMP=20
> > > > > > [  241.164363] Modules linked in: vhost_vsock vmw_vsock_virtio_=
transport_common vsock vhost
> > > > > > vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ip=
v4 nf_reject_ipv4 nft_reject act_csum
> > > > > > cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv=
6 nf_defrag_ipv4 nf_tables pkey_pckmo
> > > > > > s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_co=
re vfio_ccw mdev vfio_iommu_type1
> > > > > > vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_=
multipath loop nfnetlink ctcm fsm
> > > > > > zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390=
 prng aes_s390 des_s390 libdes
> > > > > > sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rp=
crdma sunrpc rdma_ucm rdma_cm
> > > > > > configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc=
 scsi_dh_alua pkey autofs4
> > > > > > [  241.164399] CPU: 14 UID: 107 PID: 6581 Comm: qemu-system-s39=
 Kdump: loaded Tainted: G        W =20
> > > > > > 6.16.0-rc7-00005-g4ff8295d8d61 #79 NONE=20
> > > > > > [  241.164403] Tainted: [W]=3DWARN
> > > > > > [  241.164404] Hardware name: IBM 3906 M05 780 (LPAR)
> > > > > > [  241.164406] Krnl PSW : 0704e00180000000 000002482f7f132a (vf=
io_dma_do_unmap+0x4aa/0x4b0
> > > > > > [vfio_iommu_type1])
> > > > > > [  241.164413]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 A=
S:3 CC:2 PM:0 RI:0 EA:3
> > > > > > [  241.164415] Krnl GPRS: 0000000000000000 000000000000000b 000=
0000040000000 000000008cfdcb40
> > > > > > [  241.164418]            0000000000001001 0000000000000001 000=
0000000000000 0000000040000000
> > > > > > [  241.164419]            0000000000000000 0000000000000000 000=
00001fbe7f140 000000008cfdcb40
> > > > > > [  241.164421]            000003ff97dacfa8 0000000000000000 000=
00000871582c0 000001c8b4177cd0
> > > > > > [  241.164428] Krnl Code: 000002482f7f131e: a7890000		lghi	%r8,=
0
> > > > > >            000002482f7f1322: a7f4feeb		brc	15,000002482f7f10f8
> > > > > >           #000002482f7f1326: af000000		mc	0,0 =20
> > > > > >           >000002482f7f132a: 0707		bcr	0,%r7 =20
> > > > > >            000002482f7f132c: 0707		bcr	0,%r7
> > > > > >            000002482f7f132e: 0707		bcr	0,%r7
> > > > > >            000002482f7f1330: c0040000803c	brcl	0,000002482f8013=
a8
> > > > > >            000002482f7f1336: eb6ff0480024	stmg	%r6,%r15,72(%r15=
)
> > > > > > [  241.164458] Call Trace:
> > > > > > [  241.164459]  [<000002482f7f132a>] vfio_dma_do_unmap+0x4aa/0x=
4b0 [vfio_iommu_type1]=20
> > > > > > [  241.164463]  [<000002482f7f1d08>] vfio_iommu_type1_ioctl+0x1=
c8/0x370 [vfio_iommu_type1]=20
> > > > > > [  241.164466]  [<00000248af27704e>] vfs_ioctl+0x2e/0x70=20
> > > > > > [  241.164471]  [<00000248af278610>] __s390x_sys_ioctl+0xe0/0x1=
00=20
> > > > > > [  241.164474]  [<00000248afc81e56>] __do_syscall+0x136/0x340=
=20
> > > > > > [  241.164477]  [<00000248afc8da7e>] system_call+0x6e/0x90=20
> > > > > > [  241.164481] Last Breaking-Event-Address:
> > > > > > [  241.164482]  [<000002482f7f1238>] vfio_dma_do_unmap+0x3b8/0x=
4b0 [vfio_iommu_type1]
> > > > > > [  241.164486] Kernel panic - not syncing: Fatal exception: pan=
ic_on_oops =20
> > > > >=20
> > > > > Thanks for the report. After a review of this commit, it appears =
that
> > > > > only the changes to vfio_find_vpfn() could plausibly account for =
the
> > > > > observed issue (I cannot be absolutely certain). Could you kindly=
 test
> > > > > whether the issue persists after applying the following patch? =
=20
> > > >=20
> > > > Hi Zhe,
> > > >=20
> > > > Thank you for the quick patch! I applied this and ran through a few=
 cycles of the previously-
> > > > problematic tests, and things are holding up great.
> > > >=20
> > > > It's probably a fixup to the commit here, but FWIW:
> > > >=20
> > > > Tested-by: Eric Farman <farman@linux.ibm.com>
> > > >=20
> > > > Thanks,
> > > > Eric =20
> > >=20
> > > Thank you for your feedback. Also I anticipate that this fix-up patch
> > > will leave the optimizations introduced in the original submission
> > > essentially unaffected.
> >=20
> > Hi Zhe,
> >=20
> > Thanks for the fix.  Could you please send this as a formal follow-on
> > fix path with Eric's Tested-by and documenting the issue?  Thanks,
>=20
> Hi Alex,
>=20
> I will prepare and resend a fix-up patch.
>=20
> In my view, the root cause is not this patchset itself; rather, it
> appears that some kernel-space drivers invoke
> vfio_device_container_pin_pages() with an iova that is not
> PAGE_SIZE-aligned (I am not entirely certain. Hi Eric, could you please
> help verify this?).=C2=A0
>=20

Correct. The iova's we send while processing CCWs are not necessarily page-=
aligned. This came up
once before (while preparing for iommufd, maybe?), but I can't find any not=
es or hacks that I did at
the time regarding that. C'est la vie.

Thanks,
Eric

> Our current patchset changes vfio_find_vpfn()
> from exact-iova matching to the interval [iova, iova + PAGE_SIZE).
> When vfio_unpin_page_external() removes a struct vfio_pfn, it may
> locate the wrong vpfn. This leaves the vpfn red-black tree non-empty,
> triggering the WARN and BUG reported in the issue. How about we correct
> this logic first, and then reassess whether an alignment check should
> be added inside vfio_device_container_pin_pages().
>=20
> Please correct me if I am wrong.
>=20
> Thanks,
> Zhe
>=20
> > > > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_=
iommu_type1.c
> > > > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > > @@ -344,7 +344,7 @@ static struct vfio_pfn *vfio_find_vpfn_range(=
struct vfio_dma *dma,
> > > > > =20
> > > > >  static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *d=
ma, dma_addr_t iova)
> > > > >  {
> > > > > -       return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
> > > > > +       return vfio_find_vpfn_range(dma, iova, iova + 1);
> > > > >  } =20
> > >=20

