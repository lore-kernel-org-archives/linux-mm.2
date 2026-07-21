Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05B25C4452F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC9436B007B; Tue, 21 Jul 2026 08:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80296B008A; Tue, 21 Jul 2026 08:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91CED6B0095; Tue, 21 Jul 2026 08:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF446B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:41:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DAFE3A00D4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:41:18 +0000 (UTC)
X-FDA: 85012744236.12.2EA953A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7DDC380003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:41:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nMTllraD;
	spf=pass (imf30.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784637676;
	b=ooGg7/asQ+0YVKQlQ+SA5ZMgnYKwd5YT9CPSWygGbRBkCESEBz/p33GVRmoFYdqLE0J235
	tpe926vn1uY8kPeIUUQKxDkHPn0wfI5Gyl8C+ywFNutup79Y7uKRd8ks0qv2AmTgRDRIRW
	euxUDdhy2c2EGS8pXXtFRzaWrFgg3g0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nMTllraD;
	spf=pass (imf30.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784637676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iPlPzqvav1UW5eHaa40ZbJscdEd+i1OC+0ehWg4cK3E=;
	b=YccoYM5Zr9TvTl6oVqANIizkYfU2nRaXAKU7ptPCAEDcPk5wj+Ex+1/MrmKohbu1Gf2yCp
	gm3hKktKkyw0m+2oeIMQmin+w/YS5SBLwYjbvmzurHdA6TksYxIlTMeOxrUvDcnKj4VzZS
	/IRJE0fwJZodnxrIczUZKSh5mDzVoVw=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LAfsVU793700;
	Tue, 21 Jul 2026 12:41:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=iPlPzqvav1UW5eHaa40ZbJscdEd+i1
	OC+0ehWg4cK3E=; b=nMTllraDCvXzlQ4gSXh5/QOPJ0MHn7mfMQmwGww2FERYza
	3mZJ7lRspjiI+v7D2VoxYDFEmEFFciuwPc5yYcYTj3PRDTHbMDUZzKB9bMuzb652
	9gvnEFDZy9SgYJZd16lZ7Ff489jCVh8j5hrI7OdN7lZ4jJqZDU4EHij346BLWyH0
	+lCmjbgkQb/4EQQ4DmgaM5kE/aYv2OZj2UrawOc7Ab0pe/BOx5Pigu7gfBbWHLYP
	UjXfvzH/PCweM3nDKSSA+xjsv8IrcQdnR3ODYBqjuUSbcCXFDAHrT2JkZOpgOgP/
	lJACeA6/CWy2Kp1a9aOQthVCa4ivXyIHEsSatL0Q==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg790vh2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 12:41:02 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66LCYYLH002468;
	Tue, 21 Jul 2026 12:41:01 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgm6w2c6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 12:41:01 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66LCex8G42664360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jul 2026 12:40:59 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 024B72004E;
	Tue, 21 Jul 2026 12:40:59 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C3D232004B;
	Tue, 21 Jul 2026 12:40:58 +0000 (GMT)
Received: from tuxmaker (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Jul 2026 12:40:58 +0000 (GMT)
Date: Tue, 21 Jul 2026 14:40:57 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Pedro Falcato <pfalcato@suse.de>, Ryan Roberts <ryan.roberts@arm.com>,
        Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Mike Rapoport <rppt@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Samuel Holland <samuel.holland@sifive.com>, linux-s390@vger.kernel.org
Subject: Re: mm: opaque hardware page-table entry handles
Message-ID: <20260721124057.2820903Adf-agordeev@linux.ibm.com>
References: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
 <31d36023-d728-4eee-90f8-158c7066f565@kernel.org>
 <e22407d8-4509-4a53-9ba4-491b9d5c5ef7@arm.com>
 <4bfeb697-9c1f-4316-96bb-9bfd66f959df@kernel.org>
 <6110202c-057b-4701-8c04-1a76ee7bb9ab@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6110202c-057b-4701-8c04-1a76ee7bb9ab@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: y-cS7h0zIIKKfU5heE1tSQvzZjOAVoN7
X-Authority-Analysis: v=2.4 cv=V6RNF+ni c=1 sm=1 tr=0 ts=6a5f68de cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=WHKbetgI1jfQOmHUsxoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDEyOSBTYWx0ZWRfX5L8TJE6Lf5z/
 PQ4oUUYB41NczNetweoXhqbQVYI4cGQ5SH66WxF9ziddwLi534CCE8LEyy62iBcCqZtE1f+D9RK
 n5vYb/6LHZ4bxhdeg3gEDqW/yeWmPqw=
X-Proofpoint-GUID: y-cS7h0zIIKKfU5heE1tSQvzZjOAVoN7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDEyOSBTYWx0ZWRfX3cWHXzVyanrU
 IGkEbOlm9FJuFbDU97cgAhueRbpaYHss3q5E2bfV9nfbIgx8kPrhkm4y1bhf6uQ6lfPCxulrP56
 oJyn85GoW7FBamrYjdFw6soYQS7jF0BnlV6VhHppblUpc25b0SqU0riM3hBXJzwwDvIr0dO1orO
 8Su/34UenHl3yQjtQI4E4Fm+0doYENDWsyVgzbyQ+w0CoCvJ2d2j8rJdzODTG55f0CaihWQNL2z
 DTvIAWRpAdV7o9rFTDFXqeQATE9OrNPJtibgXzfadiVtzk02wQRR3GYuPOdKaKkbRCxLAziVOhS
 t/+rWhBtsUJwDCb2fnUvtNStfgyelrCiVLt1tKgFEE/dqCc38GhK0aAK1qCOgyN1KRj9Sb608j3
 YCQB83mcJYOTjta5lm61iP+fkq4BzxsHvvosQ9aYfCBv662uIRSZQC9ymiHfmX+19wh3ppkxm5d
 SX59MRyJoyPubstxIRQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_01,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1011
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210129
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7DDC380003
X-Stat-Signature: didd9bkbg5ay3foqx77xe7ac3birxswq
X-Rspam-User: 
X-HE-Tag: 1784637676-698197
X-HE-Meta: U2FsdGVkX19HrwGw04pdpMocznj35hJhlG5K7Hx6JPoVDsLYsQI8FnhHHmTCg/wewX2iEOZYbLdcr094QasLQZ3OXZWD+AYt9VcV7Ttfs+Q2taCIfhy77R2ZAQZhzIyALZeYSz9OtP4eAmaSn5q10uxBgj1H6SVE6tCj36pKxJqiMd74fmOYLCMwA5YeQrohL5bIgKRoi4LchziSlDz0xaw6sy6Sh4SRgP3cIHVRQuTSRcSukhZ2QkgEh1/qAFhR+CLpwWKos+NiWYWKicPIv9SJvGfqF8sOOIgwp+YKqYh+TArgOf0dkDu3sKCPe+o8IGmVaw/M6F5+KNmmTa+tf9diOoNFFSsEjoCkxLgDZSYs78PwRA57fBDyjzV4TtB4ha6MegBkVEivAGX9QSyK4hpN0ZfX5CroiTGB96r3FpgOU8f90LZgtJNcnoVsniKNKOtpNPGdKNur+kstd0wW0SKUeSNq5ZfJGoV25k4dD8fEeKA59oGMXCtICkt7kC02oEChZqK57K41Tkem3/ezT+qYfazehFJhTfGDeqyBbX8jMPyG8EuJ9+5Ymivq0IMGqM00fvc/bT6z3V9aW1zbxzBdoQHGOiFHiv73S6IBFWRtD/J/5A7QiPNC14SagFRHTvqrwurhjeVjevAyAOgOQRKm+H7SWzhdpiaxUKSpHFLPS/MOwmqW2XqXYxbIDUsdB45W/6dnO54pVNW1CYqXTX8VMl5xHpZ/ICNZ5JgSTEAnGhvszU5YG5CFXP3yFXrXE8QiX3iHFe0g479fysiJNYF5NkxnNQPfMD9TgJ2JD6M9dujTruYyP/5Foodx8uisCKjZqj0QWJKRB3SSvO8opgbQFyFAE5Duymaipc8nl/TS8tFw+dQJbwA63S/T1ZgQsXlW3g+/lbTHeVuWvmFBXqEkU3JxVg77MeN1jfbRVJvxeom80rf+IlT88G0Olsf3Z4INeGlQLyMyIxWFqi2
 w/dumKZ8
 lclGbSpwTgSe2cbIqLyAvoYra2zN45+ESy4O2r6DpK+JA3e/E9xvLVHpCHsQh1HNLbROMr6C1jILeZ4/sTKYhEpc8jmVH/yseMHZjYfpbUNbKKouKSSX54Nq7KB5agjEkUrMIpp5jPasHKWXX1utjpT6RobErdeJHAErIlCZ1WYApAOJAPRHz4vrqUMtnwyl41UKnqoQ/JIclEM7j7kVKe5v5Yq57IYXXBJ5mrtgCPdM4XRGYmhjp1C6I+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 05:15:36PM +0100, Muhammad Usama Anjum wrote:
> Hi,
> 
> [Moved some already involved people to To. So they can help with the plan
> details mentioned below.]
> 
> On 07/07/2026 2:17 pm, David Hildenbrand (Arm) wrote:
> > [...]
> > 
> >>>
> >>> typedef struct {
> >>> 	pte_t __pte;
> >>> } hw_pte_t;
> >>>
> >>> And then simply use
> >>>
> >>> hw_pte_t *hptep;
> >> Make sense. So you have suggested to just hide put pte_t inside a structure
> >> instead of complex structure of pointer. I've tried to implement and it reduces
> >> churn enormously.
> > 
> > Right. And for most architectures we can probable leave both types be the same
> > under the hood.
> > 
> > So we'd only have to convert common code first, and can then e.g., look into
> > making architectures that care about the difference (e.g., arm64) actually have
> > it be two separate types.
> It makes a lot of sense.
> 
> Let's even divide the series into more parts as there are several places where
> conversion is controversial. (Xi Yan had mentioned one example earlier in this
> thread.) Most of those controversial conversions are pmd related. I propose
> that we convert pte_t first, then pmd_t and others. It'll keep the number of
> patches manageable and easier to review. 
> 
> I think wider agreement for this approach will be very helpful before I post the
> actual code.
> 
> > 
> > Just an idea to further reduce the churn and limit it only to core code (because
> > I saw some very ugly stuff in some arch code that would make such a conversion
> > harder).
> > 
> > [...]
> > 
> >>> Why do we need this and what would we use it for?
> >> The idea was that there should be two different functions to read value. Let's
> >> leave this out of the first initial series. It is complicating the original
> >> proposal.
> > 
> > Right, let's leave that out for now. I'm currently working with Levi on an
> > approach that tries to avoid the overhead due to READ_ONCE with folded page
> > tables. [1]
> So you are referring to page folding improvements. I also stumbled upon those
> while doing a dirty implementation.
> 
> > 
> > We're still struggling with some bits, but looks like we can make it fly and
> > have it be fairly robust.
> > 
> > With that, maybe there is no reason left to have separate pXXp_get() vs.
> > pXXp_get_once(). TBD :)
> Yeah, I was reviewing that series earlier today. I've not looked deeply, but it
> seems there are still a lot of cases where (mostly) pmd is getting dereferenced
> directly. To complete the conversion, direct dereferences need to be converted
> into an API. I've been thinking if there should be a dereference macro or we
> must always use pmdp_get() even though it ensures ordering. It may add excessive 
> ordering in some functions if pmdp_get() is getting called multiple times. But
> storing its output in a tmp variable would solve this. 
> 
> Do you agree with converting all direct dereferences into pXXp_get()?

For the clarity (e.g. on the PTE level) is it goint to be converted to?

pte_t ptep_get(hw_pte_t *ptep);
pte_t set_pte(hw_pte_t *ptep, pte_t pte);

While variables on stack are still may be dereferenced directly via pte_t*?

What about unlinked/temporary page tables in memory?

> > [1] https://lore.kernel.org/all/08ecabe9-0664-4aea-82fb-f9cb1739f762@kernel.org/
> > 
> > [...]
> > 
> >>>
> >>> I'm still not sure about the _once() really, and if we need that right now. We
> >>> survived without is so far, why do we need it now?
> >> The idea is to convert all current pXXp_get() to pXXp_get_once() and convert raw
> >> dereference to pXXp_get(). Let's keep this idea separate for the other work. Let's
> >> discuss it later sometime again later.
> > 

> > Sounds good.
> 
> I've tried to do conversions already. Converting by call hierarchy wise is very
> difficult and error prune.
> 
> Converting component by component (such as page walk, huge page) is also difficult
> as code is tangled. Some helper which is getting used in one component is also used
> in another component.
> 
> I see the following way forward:
> * Add the new type
> * Identify which functions need explicitly pointer to a stack variable. These
>   must not be converted. These variables must be renamed to a common name. For
>   pte_t pointers on stack some functions already use ptentp, which is unique name
>   if we look at generic code. So ptentp would be used for all such variables.
> * One commit per controversial change would be done at this point. We need new
>   separate function for stack types. Also we can do more renaming to a name which
>   will not be converted.
> * Run Coccinelle script directory-by-directory which would ignore converting any
>   ptentp (and similarly for other types). Coccinelle doesn't converts in some case
>   (pte_t *a. *b) which can be done by hand at this point.
> * Update any remaining functions

What is the approach to STRICT_MM_TYPECHECKS?

We would like to keep it, and I guess some other architectures too.

> -- 
> Thanks,
> Usama

Thanks!

