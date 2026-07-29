Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2345AC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 02:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0D66B008C; Tue, 28 Jul 2026 22:12:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C61E76B0092; Tue, 28 Jul 2026 22:12:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04936B0093; Tue, 28 Jul 2026 22:12:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DBE86B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:12:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCC401C08CD
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:12:08 +0000 (UTC)
X-FDA: 85040189136.26.F551B7B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id 467C9A0007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:12:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NuNf1sze;
	spf=pass (imf25.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785291126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=topRHz3QZ195McklxC1D1RWFNZJLSlFgQ9OISCVceGU=;
	b=EDFy0FzGKWgHJ/sorqJBfiVBX5Mhtwk2V0ZFdMGHO7MYpjv7gG/QwBqaT11bgCBMvkX7YL
	GTy5tV7JY23GueVkHPwkPO6gx76wNJA3hm1OgiD1in9Bp3Nrue/9Ih0VYtBZseDl6H2jz5
	GX0IU87QftSUrAxFTJvNVh8bPUrKBi0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NuNf1sze;
	spf=pass (imf25.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785291126;
	b=OJLWnjS2lrKSYwN4JGms6iD87v7xTKZfMpy0PRJi3z3dLcQiX26aNGxTdSn8mqKjxBe22J
	SYhZYVQnQ8w9JSiySwQuSISfvfmnBatIT/Glnkqjg1yTkAjv1ybw1jIKEK6RWwcJBiS4dg
	figrCsoSOtJU7pVzE5QfO58qCDD/6bQ=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T1Ivp8930502;
	Wed, 29 Jul 2026 02:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=topRHz
	3QZ195McklxC1D1RWFNZJLSlFgQ9OISCVceGU=; b=NuNf1szeheSaQtPeUeMqqz
	aXhL02JPcIJ8vN5u+ODEPrViXCFOEU7dt2tvOi3/0lPv55/qNS+D10YiHVNCNi/H
	MY/qofCW06E7HS9yjpPNqM9ZFB6oIYMTHRuvF7Xzmse0bJXBrte9XAgsomgl+eZz
	X3YZzgQ5oVxCsLF310BooJq7fAJQfcow/FoAX90GH/90Ki4WNheEibh1upNNIxOF
	Fi0L3MCuaQQelD4eUbEGBtF3DWBaw1PNA/hA/Xzq7fC1xuffwV27dTzcI6oVo0zf
	MorvPNxmLHqkizcZhfmJxXwvZ8Ix/nF1kLWD8CMeNPIZ25vfalFIHu5v2jI2lBqQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuycgdcx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 02:11:39 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2BMa7014054;
	Wed, 29 Jul 2026 02:11:38 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yhcqrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 02:11:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66T2BaI231195412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:11:36 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4363A20043;
	Wed, 29 Jul 2026 02:11:36 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E17220040;
	Wed, 29 Jul 2026 02:11:31 +0000 (GMT)
Received: from aboo.ibm.com (unknown [9.124.209.202])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Jul 2026 02:11:30 +0000 (GMT)
Message-ID: <1260a5746d88eff27565d506f69cf74bd766abc1.camel@linux.ibm.com>
Subject: Re: [RFC PATCH 0/2] mm/memory_hotplug: bound offline retry loops
 with a configurable limit
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador	
 <osalvador@suse.de>, Michal Hocko <mhocko@suse.com>,
        Lorenzo Stoakes	
 <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka	
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan	
 <surenb@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan	
 <skhan@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        "Ritesh Harjani (IBM)"
 <ritesh.list@gmail.com>
Date: Wed, 29 Jul 2026 07:41:29 +0530
In-Reply-To: <fdf72bbd-dd00-4a65-a196-75371f2585bc@kernel.org>
References: <20260722074811.378283-1-aboorvad@linux.ibm.com>
	 <3d18e400-5e7f-468a-b96e-d603d9535ac9@kernel.org>
	 <fdf72bbd-dd00-4a65-a196-75371f2585bc@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: JKiWrPs8eFp2rjQiTSZWjmLoORo4WUjn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAxMiBTYWx0ZWRfX995TzNs9cw2/
 UFrUA+XPxUatH74qgSpIEiz4oU5gm3UOXLLuEzAhe/bC8WwFJzTs8KBMARm6trsCJBRpqJezZC9
 nagkAgcXuhGcpjJ3mwoIYs04QwfgNdX2nXl4GV6zaJftH246uo6b+4GbppU7vdRgBYAez36uKtM
 uDe7YnLuVCgEMeY5ycHh9agNFWP8uAelkVkWxSGW732dFujT+9ftcnP3f9IvvbcoewHXThPVX7d
 dJgOK1B3iEi1FcHhsvV5TAbAFmDmvMoW511NMaUT4CMXn9ndxCvB15VfWRzKuSElgiUkV3W5FiD
 BatJeZP9VgePqEqvo590GXDI0py9DmKzFjfdkFiCxPhWbRDAVWUX4QG1/v9cf69+s5isLwWTg8j
 cDViJpTcIsCaP9+lLPQm84fElZqU2R2LzE2OHTt4D4yTOE8sJnOKxsIF9kUAUJgxm5wBKY8z6nk
 40ZNynE6LtNAfXGHHEQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAxMiBTYWx0ZWRfX8QiDaOvBx5tL
 UaAJvJpHll6V/hqFKX4+nRzQ1YeE90UWOzuK5uFXiOA4HL9N+2i6XWYY3m058EsqjrFo3HA85q/
 smWQhGlRbNQ22UsAVHSEVEo2k1Qk+RI=
X-Authority-Analysis: v=2.4 cv=AZeB2XXG c=1 sm=1 tr=0 ts=6a69615c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=iIfCR6ct8Zx7rH5hFn8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ZF-AU9MhXPE7dPcusNNeL9WWFx3CJ3qY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290012
X-Rspamd-Queue-Id: 467C9A0007
X-Rspam-User: 
X-Stat-Signature: srx9i6ndmki3u5ry18cw6twdzik6f3kr
X-Rspamd-Server: rspam04
X-HE-Tag: 1785291126-781827
X-HE-Meta: U2FsdGVkX1+nycRkyGXBqSOieH80IP7VXDRF02vFj+s9317k5xzwybT8R7+JI5/WfV3tqAZM1Ad4qZ6PEaIBthg78xA+9fv60T+cN1fSlr65gKlttcOA9Xlop7rAgfiAQjfkGL4nTPiwxZikc4cA4yzlr3lnrCOQhbq4KWwHpd5o40CvPqVn4QnObkZFwGg2+JS2gmntiVyJzkinle2xwN2/N4j82z5wAueS03m6gOb62bcxWY/hK2G5Fpy9tq9gy4j1izwx1+wMcXTjX/fLiTCfajUXqB+RSdGyq5Tge/O09xGBVFy5FzQcy0ecgonGLhA89VHkERGJwDK8ibIjRe283+Z9XPbptpTOPshrCkImlGHW7wiIYZ+AScK4UWfUeRCI3fBXF1TJ3V0Om6ydWamwCJCTlXhAf/RY8ISELZvxOlOCuDu6rMQ+scYWm1fH2sU7vdRkxPD3QWTxffBkAyuZeGSNwfr2kp0WPuGItGbcXOGUl2jqCc1+/80bzDziQ2Z02buN5Wel9thoGs7qBv2XnbSm9Fn39qmAymE6KmhwL87V3amB0aRSrc2bSizvLWvO3aU+v8aubl7aYh/3dtUlfbougTl8hOXbrtaUTInreVMWVHbPX8h4NJwPT38DNciHfPcYU7AE+7KJxak13cg4N07iAHvwFmBIEtEJO/Ss0bQ1tiflPjggcm6e60dpqDDz6PHG/1P27+mTtZ+D50IYC80NR8lFQuIK9FZC5yYiEQ4fWUwtxtaiVmRGNK45ca2+2ozar/JuQV1ik3HCLqH6c0wy3Ds/D9avTweS2xd+hAqm/j9W/3/RwhIS9GEve8NkpoWfUhzv/MykiguHVNkVE7/M2gDDkPFBhUVbRMFL/7yb1Pclk2orQu+0CIESS3Eo3fP2OwAd59HqcR8G11qsvILUvBh2Ubxy0vSix8L/JuhrRsZ+YgU77nJ5amCXlePyTNdnOkumgSMfuQw
 K6Q3vct0
 u2i/11J0RXwZ9QEBKMdnHyFYE6xcQFuGWZnRxaStVNUXdYezyJUpZzwx8ZN9MeoL1qSXFbOXXlKrOBkHuDFa1+CYaSzw3En9iT4gUMpy++zYZLpJdOZQjmpevq5KYt22mOGWGVBDpHci81RCVSf/GBy88PryqgYxKFB6yW1IrHT+xKUGs1De0mSpumTt+f/Dv+MReti/aZgJtECU4X95ACTtsyQdZFByShTihDaFcHICYYxeRs8SfRTwffZGPT1QtHB1ndy3GdeCnxcbsWtXRlgJ8k5olZeYp3F1oTlUfGYtFL2YUL8PavVpm9d+4GwA7pIhudmvOHPqeN9CGqW1gB4YxrV2PXb/YBK972mLZO1Ig/Ck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-07-22 at 14:29 +0200, David Hildenbrand (Arm) wrote:
> On 7/22/26 14:08, David Hildenbrand (Arm) wrote:
> > On 7/22/26 09:48, Aboorva Devarajan wrote:
> > > Memory offlining can loop forever when a memory block holds a page th=
at
> > > can never be migrated or freed.=C2=A0 This series adds an opt-in retr=
y limit
> > > that lets offline_pages() bail out with -EBUSY instead of retrying
> > > forever.=C2=A0 The default (0) preserves today's behaviour exactly.
> > >=20
> > > Patch 1 is the fix; patch 2 is an in-tree selftest that reproduces th=
e
> > > hang from an unsignalable kworker and verifies the limit recovers it.
> > >=20
> > > 1. The problem
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >=20
> > > offline_pages() repeats two nested steps until the whole range is
> > > isolated:
> > >=20
> > > =C2=A0 1. Inner loop: find and migrate movable pages out of the range
> > > =C2=A0=C2=A0=C2=A0=C2=A0 (scan_movable_pages() + do_migrate_range()).
> > > =C2=A0 2. Outer loop: re-check isolation (test_pages_isolated()); if =
not
> > > =C2=A0=C2=A0=C2=A0=C2=A0 fully isolated, go back to step 1.
> > >=20
> > > Neither loop has a termination condition.=C2=A0 When a page can never=
 be
> > > migrated, scan_movable_pages() keeps returning the same pfn,
> > > do_migrate_range() keeps failing on it, and control never even reache=
s
> > > the outer isolation re-check - the inner loop spins forever.=C2=A0 Th=
e admin
> > > guide acknowledges this:
> > >=20
> > > =C2=A0 "Further, memory offlining might retry for a long time (or eve=
n
> > > =C2=A0=C2=A0 forever), until aborted by the user."
> > >=20
> > > The single escape in the loop is signal_pending(current):
> > >=20
> > > =C2=A0=C2=A0=C2=A0 offline_pages(pfn, end_pfn):
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do {=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* outer: isolation */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do=
 {=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* inner: migration=C2=A0 */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 if (signal_pending(current))=C2=A0=C2=A0=C2=A0 /* <--=
 ONLY escape=C2=A0=C2=A0 */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto =
failed_removal;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 pfn =3D scan_movable_pages(pfn, end_pfn);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 do_migrate_range(pfn, end_pfn); /* may never succeed =
*/
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } =
while (pfn < end_pfn);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } while (test_pages_isolat=
ed(...));
> > >=20
> > >=20
> > > 2. Why the kernel itself should be able to bail
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >=20
> > > We keep hitting this during memory hot-remove operations: a single
> > > stuck page can block the whole operation.=C2=A0 This was also reporte=
d in
> > > [4] earlier; one example, where offlining kept failing to migrate a
> > > busy block-device page-cache page (aops:def_blk_aops) in a normal zon=
e:
> > >=20
> > > =C2=A0 [10880.889199] page dumped because: migration failure
> > > =C2=A0 [10880.889232] migrating pfn 2a87b failed ret:1
> > > =C2=A0 [10880.889235] page: refcount:3 mapcount:0 mapping:00000000718=
ec5a6 index:0x857 pfn:0x2a87b
> > > =C2=A0 [10880.889241] aops:def_blk_aops ino:800003 dentry name(?):""
> > > =C2=A0 [10880.889245] flags: 0x33ffffe00004104(referenced|active|priv=
ate|node=3D3|zone=3D0|lastcpupid=3D0x1fffff)
> > > =C2=A0 ...
> > > =C2=A0 [10880.889291] migrating pfn 2a87b failed ret:1
> >=20
> > Hi,
> >=20

Hi David,

Thanks a lot for the review.

> > the text reads AI generated. If you did use AI, please disclose it prop=
erly.

yes, I did use LLM to help re-phrase this. I'll make sure to disclose the u=
sage going forward.

> >=20
> > Quick feedback:
> >=20
> > 1) Using passes is not really what we want in many cases (e.g., ZONE_MO=
VABLE
> > where we might need a couple of seconds/minutes to complete offlining w=
ith a lot
> > of concurrent activity). An actual timeout is also problematic (see bel=
ow).
> >=20
> > 2) Having a toggle for all offline_pages() users is questionable. In pa=
rticular,
> > user-triggered offlining or offlinig triggered on ZONE_MOVABLE etc shou=
ld not
> > obey such timeouts.
> >=20
> > I proposed a more restricted approach only for offline_and_remove_memor=
y()
> > previously [1]
> >=20
> > [1] https://lore.kernel.org/all/20230627112220.229240-1-david@redhat.co=
m/
> >=20
> > Michal back then commented "I really hate having timeouts back. They ju=
st proven
> > to be hard to get right and it is essentially a policy implemented in t=
he
> > kernel. They simply do not belong to the kernel space IMHO."
> >=20
> > And I agree.

Thanks for pointing to [1]. On our end, on powerpc (pseries),
drmgr (the userspace tool that triggers memory hotplug) already wraps memor=
y hotplug
operations with a timeout for exactly this reason. However, since we've now=
 seen this
issue occur a couple of times under system load in ZONE_NORMAL, and also as=
 per my understanding=20
offline_pages() can be triggered from other kworker path where it cannot be=
 interrupted
and could end up retrying indefinitely, So I wanted to get a consensus on h=
ow this should
be handled.

> >=20
> > I assume you run into such issues with DIMMs in VMs? virtio-mem handles=
 that
> > much nicer nowadays, by essentially doing the hard part that should fai=
l easily
> > through alloc_contig_range().
> >=20
> > offline_pages() is just designed to retry forever.
> >=20
>=20

Yes, I do not hit this issue with virtio-mem path, looks like=C2=A0the unsa=
fe unplug mode that
relied on offline_pages() for migration was removed in f504e15b94eb ("virti=
o-mem:
remove unsafe unplug in Big Block Mode (BBM)"), so now it rather goes throu=
gh the
alloc_contig_range() path, which gives up with -EBUSY after a few migration=
 attempts
on the same page, so offline_pages() never sees the stuck page.

We originally hit this on a pseries LPAR, during memory hot-remove. offline=
_pages()
gets stuck on a single page that won't move, with two specific cases as bel=
ow,
both in ZONE_NORMAL:

  Case 1. a slab page that ends up in the isolated range:

	[83310.373767] page_type: f5(slab)
	[83310.373770] raw: 023ffffe00000000 c0000028e001fa00=20
	[83310.373774] raw: 0000000000000000 0000000001e101e1
	[83310.373778] page dumped because: isolation failed
	[83310.373788] failed to isolate pfn 4dc68

  Case 2. a busy block-device page-cache page that keeps failing to migrate=
:

	[10880.889058] page: refcount:3 mapcount:0 mapping:00000000718ec5a6 index:=
0x857 pfn:0x2a87b
	[10880.889062] memcg:c00000006a67e000
	[10880.889064] aops:def_blk_aops ino:800003 dentry name(?):""
	[10880.889069] flags: 0x33ffffe00004104(referenced|active|private|node=3D3=
|zone=3D0|lastcpupid=3D0x1fffff)
	[10880.889073] raw: 033ffffe00004104 c0000000b8667960 c0000000b8667960 c00=
00000130f8dd8
	[10880.889077] raw: 0000000000000857 c000000172abe1e0 00000003ffffffff c00=
000006a67e000
	[10880.889081] page dumped because: migration failure
	[10880.889114] migrating pfn 2a87b failed ret:1

I can also trigger it in a VM by hot-adding a DIMM, pinning a page and remo=
ving the DIMM.
This is the part I wanted to highlight, the ACPI DIMM remove runs offline_p=
ages() from the ACPI kworker,
and as far as I understand, nothing can abort it, there is no signal to del=
iver, so there is no way
to cancel the work, so it spins until reboot in this case as well?=20

> One thing we can definitely do is to just fail faster if we find an unmov=
able
> page in !ZONE_MOVABLE.
>=20
> Usually that happens when we race offlining (has_unmovable_pages()) with =
page
> allocation, and failing on unmovable pages is actually perfectly fine.
>=20
> But for ZONE_MOVABLE we should keep retrying, because some pages might on=
ly look
> temporarily unmovable.
>=20
> So that would be the low hanging fruit: on !ZONE_MOVABLE, fail faster.

This handles scenarios like Case 1. A page can still be allocated from the =
range after
isolation and become slab. When test_pages_isolated() fails, we can re-chec=
k that
page with page_is_unmovable() and return -EBUSY if it's unmovable. I'm curr=
ently testing this approach
will send a patch for review.

Case 2 is different. The page is on the LRU, so it is considered movable an=
d the fast-fail condition abovewon't be triggered. Instead page migration k=
eeps failing, causing
offline_pages() to retry indefinitely
and can hang forever. This could be handled with a timeout or a user
policy in the application that
initiated the hotplug operation (signals). However, for the kworker
paths that trigger memory
offlining (ACPI remove, etc.), should this instead be handled by the
driver rather than relying on
offline_pages(), similar to virtio-mem?

Please let me know your comments.

Thanks,
Aboorva

