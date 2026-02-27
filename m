Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6664FFD5312
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 08:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1F1A6B0089; Fri, 27 Feb 2026 03:57:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACCA46B008A; Fri, 27 Feb 2026 03:57:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1336B008C; Fri, 27 Feb 2026 03:57:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 832536B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:57:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24116140599
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:57:56 +0000 (UTC)
X-FDA: 84489634152.05.59A6BA9
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id B3A6C1C0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:57:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sZDfxp3p;
	spf=pass (imf21.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772182673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ohADthLDD9z3XUImOUnNifIKCKACdymEuIsWp6yNCC8=;
	b=0QNAc1n316+p8mNJLeAy7BfXdiCC1sczk2CW/HBBpyNkgmlUY7fu0ryHzwqFQa2xYyo2nF
	HnMc4W1Nj8JNebHfcm3CkHIV9X2/e6UrRI4pDIF6wB8fA+hoPd21nb02Ik4DeVR62wkxLr
	+7yUlc1GXYnPu3G17cII1dHOrww0qdo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sZDfxp3p;
	spf=pass (imf21.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772182673; a=rsa-sha256;
	cv=none;
	b=WLqY8ZZIPbqpcj9OsUn+Nj5z1LqHtkmPLTZVo6vzQOvv7Rf2151jihhfMaAw+OvgMDdBcM
	PrOOaTpAtA7nejnoqoEOhuc3YLsC/W2VHzq4QTBUVBglpbaTgUhamV+vcrF5zVdD0/4G7R
	xa9TdQkDNHDsjPKZCiNjU9Amxui5/qw=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QNfeDg3178876;
	Fri, 27 Feb 2026 08:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ohADth
	LDD9z3XUImOUnNifIKCKACdymEuIsWp6yNCC8=; b=sZDfxp3pYtANr1JiWIkADr
	lfCfeth2VR2Y2XN+68ftwKl05od9arHJ/ZN3j4BjHGVaXiJSqhqqiTjt3lRe3/Tb
	NspqofphmW0zV3wzay8doVQJVU5+11+mJNZq13UTw4NcF3FoH9gDBx/1VRqKqEk6
	TdjBn1hmyUWPKSAZRmFAIMLYQI33iq0PT4s+h1C3a69Q/ka6JaNfaNWDxoiDnK88
	BWtJ0hyTd5HehP0BaTBtyhpyZEWrTdIkrk1CGRtS9TXHd4A7UZ7shYy6EnhTyqJJ
	RTOLUPNYlt/XLrTk38tmOy9Z2lHHDeHD95ij6tpl7IM0aA+Uy0d4Ld/cgXzdRuYg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf34cjtjk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 08:57:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61R6ldH4014012;
	Fri, 27 Feb 2026 08:57:24 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfqdyhan3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 08:57:24 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61R8vJo814090732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Feb 2026 08:57:20 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D71652004B;
	Fri, 27 Feb 2026 08:57:19 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49CE620040;
	Fri, 27 Feb 2026 08:57:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.69.15])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 27 Feb 2026 08:57:16 +0000 (GMT)
Date: Fri, 27 Feb 2026 09:57:14 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org,
        ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
        rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
        ying.huang@linux.alibaba.com, apopple@nvidia.com,
        lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
        vbabka@suse.cz, jannh@google.com, rppt@kernel.org, mhocko@suse.com,
        pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
        npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <20260227095714.5e69a0a8@p-imbrenda>
In-Reply-To: <CAJuCfpEk_VPqwpqtAiCJSR5bkvHuzvC8ooXrB4jKTYnQB2D4YA@mail.gmail.com>
References: <20260226070609.3072570-1-surenb@google.com>
	<20260226070609.3072570-4-surenb@google.com>
	<20260226191007.409a7a21@p-imbrenda>
	<CAJuCfpEk_VPqwpqtAiCJSR5bkvHuzvC8ooXrB4jKTYnQB2D4YA@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDA3MyBTYWx0ZWRfX9WncEKIsvtkE
 93BCkSDioR3viSI4k8M8ER0no2D2zADEGoLWX0KPQp0RA8BsPJbCrfq2KNwhRaeVWK9DAn3UOd6
 JAAx02zp+y9sAZSn4DLDrb3m80HWoUwQ3XZbkAc/WY4whBIPdkpq5++S1OS1U/BZL1YM5xtJRtL
 asZKx6fRd45Z4dwVYGheVX0JssABTlQnZcPMUUlLPHlLa2PGtc+gWSwVlWd/LbyzyJTu5/eCRQv
 ZD0ydFAWHEbM9dSGMVwbFmFBk6I11/cjfskqj1vi3sWYi9ExPCWFV8MocD36VLDGxyr7Hgvw95a
 oNSV4Q1Wk5+LBR+205t5wPH9duGWR6eo7a84XSUaM2JtRffZshKV0ovn8RzJA32bUOqSp/TehRx
 vmDqLHCgdsnyiO0l67/DgUsWIDjh+fag6Xuw/2WaA0DTHK1m/3W1tSm4sGSr6C6KPXPZdDprF1U
 j1k9+KMGXV8XsaOEoIg==
X-Proofpoint-ORIG-GUID: ajegLXIpD6Zt7S3-2yKIDNzKpDYqMOPu
X-Authority-Analysis: v=2.4 cv=F9lat6hN c=1 sm=1 tr=0 ts=69a15c75 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=1XWaLZrsAAAA:8
 a=VnNF1IyMAAAA:8 a=Ch0MJLqadWv443iAyyUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: co2lSwi4qVEs7Dzgf2PvZ6JwEnc7YSIK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_01,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602270073
X-Stat-Signature: kn9x7zda7j7pxn8qczb4msqipbx7pjim
X-Rspam-User: 
X-Rspamd-Queue-Id: B3A6C1C0005
X-Rspamd-Server: rspam04
X-HE-Tag: 1772182673-33396
X-HE-Meta: U2FsdGVkX18+SKkyiEvuYlr9oZMMPXW5bo4XEG1StgbceNXnwU/ri4bKYUzNTTQOaR5w2dVv207UpoH/mEBDntxr89SJmC5FuTdr8n74zSFEdcZyWCMg942XadtI9qZEh114myzU6MyPwqxojWTz30f6aFplCTntgRYUDspVLOXKnpe2ZoCqEtyjDhkIgRpQj/c6kWb0zCo1vRv43JBI+iycoBF/016lRo+RKIRkbhMLnOo4YXPas0VajlYn8UlH1l4n64/uXYJ0GSMLIoLUKdgQNC90SP6P6kjDv7RiHPHb2bnwwGNTGLJw+U7Opu5peEbVVYf6blIKRfqc230nQcDnC9ECroCpWyPEJ7n1bqPNIBddY8TnA23ti3mn71rO8DwTnDL82IxcY/z7Enl10HiwmNeWActIQ7cjlIGOqTO8zUWBKuP9iuPlQfrqCYuPowTs5XuvmUdbRNlDBeiUNYDGwY9URxRlGv1BXOA2COo0N7ECT5gbU6K0Hi+UXcjA+fmf303PMDr5Kx0hAWChxF9F2BVGbTq7NuxBaXpf2T+6sX+Nw7gLDZTC4tvQCS9I1NXj6N3HbB8YwZQBa8h13Hl9WPQHkSsiPWTeNByrE1yq8CbaQDqa/K2Gy/4GhO2WmPxYBSYiq3nGzDJJIHdTjf4rln8Jonx/YOmLF3+vLIEzf7XWsoMK/bR0z/5foHNLDgpnGQjoeORp9Lf5bObW0qYMs6dOSy9FkAFGugaVsbmFmIy1HD0DpbOFOX2Rdki4GP0Y7k1MXSXhcsuXVIEKZ6rvLLqqKTnQkBQB5n00pTgv4/DghJIq+We4EIKcHVfybji/6+0HjUYLNBcefRRbcsqX/8TCXKNy2PKfataJHO1ZeoRSJ+RHbum9J6ffD739araFE0vLWJsbm5aDUJPeb/34GVgR6JOREq6WxwoqjohrokoBm3ejuZkkhLlGjtAzJs+bXLHi45xQZfSVUKs
 8UWGClZt
 qXD5z7r3payae9BWD4Lat1XKVvmyTJd+ZndfV7cWs/KeypI8R4JOy09FGr9CNNP/DthjzNdbqFuTstaiIW5qtd/dEmDJwycEcyEHqI9K3bh1IR4aZMGuGsvLZPKLwb/SYcTO3HLATeuEC/bFhlZzypfI5KPkXD3BswTVlmy1bo7YPjVy2inLNIjNOe4RxLNf49isFnlUtCrDPoFfn04tVekRhwIJYDDQl5QIqsd1MTkY54g+D5tlZJOLAJ3b4RgBoCg0Kq+alRcWeDFUS0GsowxogXRxKfCK/yhq4THN8hE3FChq3NmDzIf1ktIAybuLrS8c8Fjz3m/EnFU7D7Htfv/+hX0ZO++koafRqUOtsKX4WCORt28DTgBLMU1S1TBowoS3O7j0NJwuBpiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 10:24:49 -0800
Suren Baghdasaryan <surenb@google.com> wrote:

> On Thu, Feb 26, 2026 at 10:10=E2=80=AFAM Claudio Imbrenda
> <imbrenda@linux.ibm.com> wrote:
> >
> > On Wed, 25 Feb 2026 23:06:09 -0800
> > Suren Baghdasaryan <surenb@google.com> wrote:
> > =20
> > > Replace vma_start_write() with vma_start_write_killable() when
> > > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > > Adjust its direct and indirect users to check for a possible error
> > > and handle it. Ensure users handle EINTR correctly and do not ignore
> > > it.
> > >
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > ---
> > >  arch/s390/kvm/kvm-s390.c |  2 +-
> > >  fs/proc/task_mmu.c       |  5 ++++-
> > >  mm/mempolicy.c           | 14 +++++++++++---
> > >  mm/pagewalk.c            | 20 ++++++++++++++------
> > >  mm/vma.c                 | 22 ++++++++++++++--------
> > >  mm/vma.h                 |  6 ++++++
> > >  6 files changed, 50 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > > index 7a175d86cef0..337e4f7db63a 100644
> > > --- a/arch/s390/kvm/kvm-s390.c
> > > +++ b/arch/s390/kvm/kvm-s390.c
> > > @@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsign=
ed int ioctl, unsigned long arg)
> > >               }
> > >               /* must be called without kvm->lock */
> > >               r =3D kvm_s390_handle_pv(kvm, &args);
> > > -             if (copy_to_user(argp, &args, sizeof(args))) {
> > > +             if (r !=3D -EINTR && copy_to_user(argp, &args, sizeof(a=
rgs))) {
> > >                       r =3D -EFAULT;
> > >                       break;
> > >               } =20
> >
> > can you very briefly explain how we can end up with -EINTR here?
> >
> > do I understand correctly that -EINTR is possible here only if the
> > process is being killed? =20
>=20
> Correct, it would happen if the process has a pending fatal signal
> (like SIGKILL) in its signal queue.
>=20
> >
> > [...] =20

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>


