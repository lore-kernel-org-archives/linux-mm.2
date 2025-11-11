Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC325CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 10:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D17D8E0017; Tue, 11 Nov 2025 05:44:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0823D8E0002; Tue, 11 Nov 2025 05:44:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDA038E0017; Tue, 11 Nov 2025 05:44:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9C2A8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:44:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96A3E4C08C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:44:25 +0000 (UTC)
X-FDA: 84097992090.22.9969356
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id 108F714000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:44:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i+8ZqsKp;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of japo@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=japo@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762857863; a=rsa-sha256;
	cv=none;
	b=ZCq/EfbinfdBdxTXNdpCINol8UVPpCqfS4/qQfZT+dLyk1r+XxXulzPlE13tDMOWwQheVs
	x26ytydTN2M0OIrQyMSQjZ+JLAbXX2rD1DgF+mGtJvFpCxf5e/6KlQf/xcAoV81u0Ttdla
	9lazkUhKjH4vS8cscqbsJpSDiUwghho=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i+8ZqsKp;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of japo@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=japo@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762857863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zhkdC954/XIoW9lj3eK97QBTio9c6/Ra5E7JBlylD0=;
	b=tzcTCtRqLqS6yOTraWhjMoNKxequLXrO0jPJo6jsWk2COVH7IprLrFvtkOM24SK4GX6oHs
	d4+O6DpVV4AYJyarTCuVINREUak+Aws6ir3l5089oMBStZNrl/+inVxhVRW9U7GlZjS3gO
	bZNps271AQXImKR5LcNo72xvrBVrCIM=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAMNRj4023632;
	Tue, 11 Nov 2025 10:44:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=3zhkdC
	954/XIoW9lj3eK97QBTio9c6/Ra5E7JBlylD0=; b=i+8ZqsKpJTU9G2r3wtEEHL
	nVc4aj19EgJvtBtVjgz6wPQ/+qdui4Imp9dEwiDbaH8n4w6z0a+qpuCd+y71kgrs
	KRZK+a2NMCEcE02z5B2CtUZWzXnGNduu1hFdOiAMP3fFjXxY8jD/nKSWBeHASo8g
	3MMTBu4T7mdFomUJpwOHAaUY37zekNmawB7ShjD9MFqzbNEG5ly5CowZfD1JMt9X
	ypu3NaYJ7DN+KN05f4FjFCv5/cwGNmm1F+kXi9SA2K540gdZueJgrfnvhCOFZO4o
	ZnuPHopPVsVEvrWWzjf9jLiIya4osAC04TRdLEs5At9seugZmSMnHWcl3c3EGYeg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wc74qxj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 10:44:11 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5ABAWr3U002403;
	Tue, 11 Nov 2025 10:44:11 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wc74qxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 10:44:11 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB9pbYK008260;
	Tue, 11 Nov 2025 10:44:09 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aah6mtbd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 10:44:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ABAi7Zp42664248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 10:44:08 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9B7C2004D;
	Tue, 11 Nov 2025 10:44:07 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A392520040;
	Tue, 11 Nov 2025 10:44:07 +0000 (GMT)
Received: from li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com (unknown [9.155.201.149])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 11 Nov 2025 10:44:07 +0000 (GMT)
Date: Tue, 11 Nov 2025 11:44:06 +0100
From: Jan Polensky <japo@linux.ibm.com>
To: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>,
        catalin.marinas@arm.com
Cc: akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, will@kernel.org
Subject: Re: [PATCH] mm/huge_memory: restrict __GFP_ZEROTAGS to HW tagging
 architectures
Message-ID: <aRMTdt5tqJhjLgGd@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <20251109003613.1461433-1-japo@linux.ibm.com>
 <690ce196-58cb-4252-ab72-967e1e1574cf@gmail.com>
 <aRG05VS-IIxV2y_C@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
 <fbca7868-6f68-4b98-a2f2-e39eb46b7f12@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fbca7868-6f68-4b98-a2f2-e39eb46b7f12@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAxOCBTYWx0ZWRfX/7v5MALMQkkz
 5sjvinfISCBxNCIY43PoelSTNcEIUJW93X81M3VejNVqM3aTrNjD7iOyyWHqxsUtKeZ49AsDTWy
 hMvv/Q0Sskmg3YbV/M7CWmHtJ83wd1YNQqLStx1q+PBadGEZrPRJMSdYUTXtYUs/At8Iu/FrmaM
 izstGxJOPjKXqDR+T4bkrzBCsR1qNRCnGEG1amHpvb2YiKGHAz+rSE7ic14VkdN3q+PLjaOEDYq
 sYj8sOC9iIq/NGHgHdXWxv2Lkw8pPT04mrygd35AqvzsJWQiXmBSYAMnag0vFYyBI9yvVGbCEmV
 ETZyvOkbuMXcwMXhL4G+Q/b6zv1Ts75mRX3FwLUU00uVWqq2WsBJtamQecCawhnUxeoIrjqX/FM
 qbZf+Od6U5LQqA+MAHLnNgiH8HjC1Q==
X-Authority-Analysis: v=2.4 cv=GcEaXAXL c=1 sm=1 tr=0 ts=6913137b cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=-mZ0xOhmsHb9JoomMBoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: ZSHFsu6k6PII3E4XpGUJvo1JK-0hDjpn
X-Proofpoint-ORIG-GUID: 6nzRhirrpSwM50mDZO38SB8ub4IKHh9N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_01,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080018
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 108F714000A
X-Stat-Signature: 8i9xnudy1c3zauz4ud8yeeyeowbog6qm
X-Rspam-User: 
X-HE-Tag: 1762857862-522144
X-HE-Meta: U2FsdGVkX19+SE6vOr+jzVk5sjyLklWcBNpSosNAp+xqVKjN0Sje2PCK44DG9ZtWAx5Ss94cKyfAiGkbAXgTt0n6wUbjXtAAkTCo1IDVXSPXj4Eue61l1hBdgAfy9lBzCkzDX5StGS4JHC2zv3BqdSvLYEczQGcdLazkbxNSa7VgXJvysgTIdUHbdDr8XkEo94uxzlbn0IkVUGv9MHiMrJcgOB4tQFDFvYqmbkqZOrdcONjfsd3ypPLsxJqktmkWS/223TTCVL0EktK11Cy5S7fUcFM90Q+MaF6VQCepziStH7NeHQhLw7Saw2JyOhIii4Z76xqG4FU7xRcKreReO5mh6EOxp0lEEzjSdQQH+nCypiWLGp+z1Hc6xEv4Oo4ALaNTVwsUm9AZQooNS++baA27BK8hEkzJdixJy7BtB1Q0SV/kacjr7rHFmAwPr4WZ1i//qcON7IB4bwnAp9hig9iwYtjgC8Ck6a0UjQpxPqEYdfmG6qpXNZgEQA2nQLwjsp5BdFEcMjjbpKTEucr/J5rWYpBVrdNSJfC4T+QWfd2ykMK2Xwm1LxDjL5ZmERp4+z8uJNeWy2wpt5xaEbMUe+sKtydq2+pvvHPdWjiBpWX9iSY9ykPoWZ7nEsvsnjR/812uOP1UCOcLdTQXO+aSu6UIiXootkTmJjgshDUtSMseIghTsOr9nW5y1YOLnT+s9P5iTxPGgitKtrbXIaEny/LmXaEZ6pbaoBnhQ1zSDiNdzEQcc4HB7EgZalUnQgoDCkYGWe7nx+I7HAR+rEcWn6cB5b6koS6Y5ybUyxbHAUvBLnfIVRJaJIQrzn6YhezbhQ8XeZvGQREeBaf9OsXK7AHEIAmoCb5hUA77ID697WJr7Z8OxcuJuQMYnhiyaYE1TCF+3iROtowYKOAjt/bhKYjt9KpOq6KNcbBqmmAQwU08f1KyZw5o5r3ak1VT4vHDu98WcUE3hIJX2apsG3R
 n5Vriq/c
 H8lOEqEOvAguQl4wno/zAEsanmX99WWu9bLu8Eg2SeMUmkdDMoMo3AlqT/vcNi07f6w+PkGQdc2ewnii3bmVvbunuYx9JsNNbn1vf0e0MkT8bwgwlbWcL+oPrwPPypdAkojm0Lc/C8ZbjpCUMFnYKUHqSbbdWjjpklhNA7nUAqUuvYQPJdFKyMXi+KCSHDlTNcJb6weAm0TJILiMXhNChXtoNm1FxWF+WjUDJuxpS1D0iGxPHOOGbWZjeT2yanqt5DLG7At+ifEiGlCmQcl6Wsv3w4FMiSLZpRcVkPVqZr7rSSVk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 10:53:33AM +0100, David Hildenbrand (Red Hat) wrote:
> On 10.11.25 10:48, Jan Polensky wrote:
> > On Mon, Nov 10, 2025 at 10:09:31AM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 09.11.25 01:36, Jan Polensky wrote:
---8<--- snip ---8<---
> > > I wonder if the following would work:
> > >
> > >
> > > diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> > > index 65db9349f9053..56b82e116cb79 100644
> > > --- a/include/linux/gfp_types.h
> > > +++ b/include/linux/gfp_types.h
> > > @@ -47,7 +47,9 @@ enum {
> > >          ___GFP_HARDWALL_BIT,
> > >          ___GFP_THISNODE_BIT,
> > >          ___GFP_ACCOUNT_BIT,
> > > +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
> > >          ___GFP_ZEROTAGS_BIT,
> > > +#endif
> > >   #ifdef CONFIG_KASAN_HW_TAGS
> > >          ___GFP_SKIP_ZERO_BIT,
> > >          ___GFP_SKIP_KASAN_BIT,
> > > @@ -85,7 +87,11 @@ enum {
> > >   #define ___GFP_HARDWALL                BIT(___GFP_HARDWALL_BIT)
> > >   #define ___GFP_THISNODE                BIT(___GFP_THISNODE_BIT)
> > >   #define ___GFP_ACCOUNT         BIT(___GFP_ACCOUNT_BIT)
> > > +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
> > >   #define ___GFP_ZEROTAGS                BIT(___GFP_ZEROTAGS_BIT)
> > > +#else
> > > +#define ___GFP_ZEROTAGS                0
> > > +#endif
> > >   #ifdef CONFIG_KASAN_HW_TAGS
> > >   #define ___GFP_SKIP_ZERO       BIT(___GFP_SKIP_ZERO_BIT)
> > >   #define ___GFP_SKIP_KASAN      BIT(___GFP_SKIP_KASAN_BIT)
> > >
> > >
> > > Likely we'd have to make __HAVE_ARCH_TAG_CLEAR_HIGHPAGE a proper
> > > kconfig option.
> > >
> > >
> > > Then we could turn the default implementation of
> > > tag_clear_highpage() into a BUILD_BUG.
> > >
> > I'd like to suggest to keep the enum untouched and only use the second
> > part of your suggestion.
>
> Why? We also do that for CONFIG_KASAN_HW_TAGS, CONFIG_LOCKDEP and
> CONFIG_SLAB_OBJ_EXT.
If we remove the enum entry, we’d also need to update mmflags.h because
the trace macros reference it.
Enums are compile-time only, so they don’t affect the generated binary.
My thought was to keep the enum list as it is and just apply the second
part of your suggestion.
That way, the trace definitions stay consistent without extra changes.
Just an idea, happy to go with whatever you prefer.
>
> > Which works by the way for our arch (s390).
> >
> >   include/linux/gfp_types.h | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> > index 65db9349f905..c12d8a601bb3 100644
> > --- a/include/linux/gfp_types.h
> > +++ b/include/linux/gfp_types.h
> > @@ -85,7 +85,11 @@ enum {
> >   #define ___GFP_HARDWALL        BIT(___GFP_HARDWALL_BIT)
> >   #define ___GFP_THISNODE        BIT(___GFP_THISNODE_BIT)
> >   #define ___GFP_ACCOUNT     BIT(___GFP_ACCOUNT_BIT)
> > +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
> >   #define ___GFP_ZEROTAGS        BIT(___GFP_ZEROTAGS_BIT)
> > +#else
> > +#define ___GFP_ZEROTAGS        0
> > +#endif
> >   #ifdef CONFIG_KASAN_HW_TAGS
> >   #define ___GFP_SKIP_ZERO   BIT(___GFP_SKIP_ZERO_BIT)
> >   #define ___GFP_SKIP_KASAN  BIT(___GFP_SKIP_KASAN_BIT)
> >
> > This solution would be sufficient from my side, and I would appreciate a
> > quick application if there are no objections.
>
> As raised, to be sure that __HAVE_ARCH_TAG_CLEAR_HIGHPAGE is always seen
> early in that file, it should likely become a CONFIG_ thing.
>

