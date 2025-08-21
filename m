Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80BE8CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 19:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98466B0111; Thu, 21 Aug 2025 15:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49116B0112; Thu, 21 Aug 2025 15:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38DB6B0113; Thu, 21 Aug 2025 15:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DFA46B0111
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:36:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68D76C02E4
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:36:53 +0000 (UTC)
X-FDA: 83801772306.26.D1F60CE
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1900E100008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:36:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=pN+Cg84+;
	spf=pass (imf05.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755805011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wa8/iqYdFpX8MJDTCXt3R7g1KRe65oEz4/7rMZKRdyY=;
	b=FYajWS6SWkQKV5TY/70Yksg0/gn+9j3Is7bm43UGtuyD8wQ3JRwU91FXde4ztHIIJ5Cqs8
	VQPwKN6cOcU9lrkk5SWuel+hufE3sA+w2UtU+Qv2sRCeJFXkqi5m7JuVDX2MQ/b3BlAa8m
	ptJ/xKQ8IdCGkar4uCNSbkHhb4Y+JSY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=pN+Cg84+;
	spf=pass (imf05.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.147.86 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755805011; a=rsa-sha256;
	cv=none;
	b=drbFyU3Je99ZVvQkpX7O+5qkPJN89aupvy6fCr+WxBG62ClKwnc+jjlWIlsD5zfTkMpekD
	ovNbH80nI+6hI72m7fzvWf0sSOsNOyfYlcGZEVVfSGBxS3EOp4bZEsK4mEum4ibXyOn5Qm
	J5nsBbjFbIYxJygX+fCqiGBVsw0sqB0=
Received: from pps.filterd (m0134420.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LIGo25019507;
	Thu, 21 Aug 2025 19:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=Wa
	8/iqYdFpX8MJDTCXt3R7g1KRe65oEz4/7rMZKRdyY=; b=pN+Cg84+5+u0N6DOIP
	GwTc5IaeL20gcPm4Ev/zqIkEXIDgWfypgqcHEpGHguLRySZ2ai05WIte7Cm++yqh
	vpIFFvYthn5gDIdOQ5SHR95CpedzAiun25h3cmskmsF6nBwdvZ033979gXTLSzkF
	LLXpCgRTnw7KDD6orr6ThDI+TqyELXCzwYb5dlOkXExlAZnJPdSAZf91U6EBPIz8
	wNuVIGFJr+ccz30mXqMPOvBkabXM+M2cEOhb1UO3ArSNHinbvI0hXBu3KbIdz/Ue
	/3Dwdot56ix6hKYb5qJorfQ7SA318hqNcVm5EIzLpjy3LWZ+WC6RaHUCr6tD+8Mw
	6ZDA==
Received: from p1lg14881.it.hpe.com ([16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 48p10evsb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 Aug 2025 19:36:17 +0000 (GMT)
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 3B86B805E18;
	Thu, 21 Aug 2025 19:36:16 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTPS id 67945805E5B;
	Thu, 21 Aug 2025 19:36:13 +0000 (UTC)
Date: Thu, 21 Aug 2025 14:36:11 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: akpm@linux-foundation.org, david@redhat.com, tony.luck@intel.com,
        bp@alien8.de, linmiaohe@huawei.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        nao.horiguchi@gmail.com, jane.chu@oracle.com, osalvador@suse.de
Subject: Re: [PATCH] mm/memory-failure: Do not call action_result() on
 already poisoned pages
Message-ID: <aKd1K3ueTacGTf1W@hpe.com>
References: <20250821164445.14467-1-kyle.meyer@hpe.com>
 <CACw3F53KmKRJyH+ajicyDUgGbPZT=U3VE4n+Jt3E62BxEiiCGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACw3F53KmKRJyH+ajicyDUgGbPZT=U3VE4n+Jt3E62BxEiiCGA@mail.gmail.com>
X-Proofpoint-GUID: ZsbMeJ8F2AyD1J_S0CWBl-FkjT0scDay
X-Proofpoint-ORIG-GUID: ZsbMeJ8F2AyD1J_S0CWBl-FkjT0scDay
X-Authority-Analysis: v=2.4 cv=X9oL6GTe c=1 sm=1 tr=0 ts=68a77531 cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=MvuuwTCpAAAA:8 a=yW6kyvSLy8IxsXRRQqMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIxMDE2NSBTYWx0ZWRfXweS0z0IijUjv
 TR5xEPl57yRTGITviQj7VxIoB/dhthyPhn3Caj5YbwX+GC6OYnvX99pN+Moi+jnFIzqflNUfAx1
 nVVN0mYFsxaB7/FmjOe9Hyr9suVi+Yj7m+ihVNQtmcQKRBzuV3OnqTQrvxRAXD4nuJQqvJhat2S
 Dt6Wwq87akgo5EK9miGGi7t9ISMpoNqKz30QF14/qO7CHBIckrso9IVUly3vGzZVwnie5WFG/1C
 1TrUwSNZVHF1Ep7Hox1jV/J4B9pDqIh6cez5UOUKzn1B0Uv0uxFngbIGUzkzCn2DnPHQViY3CGb
 lmKRjiW1lq4gyiSCP6/YbV1cAc/Xoq69zgAifbVWB5pC/13+GLevXr77zpCKqHz8UF56PKl7N/P
 nhFW2WU1zPAaa05SsRivOpoC0k2xRJtnqaU4a4cztznNj/ZXP7k7Fgd0p+hbZfSocDjOo0HI
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 suspectscore=0 clxscore=1011 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2508110000
 definitions=main-2508210165
X-Stat-Signature: jioynnbq144ya3s7pz1mpj1613cg91q3
X-Rspam-User: 
X-Rspamd-Queue-Id: 1900E100008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755805010-365070
X-HE-Meta: U2FsdGVkX1+SUrKjvWdhGscRJ7G4pofF0VgrygNiULPpBGUZkTumaCkqzlaby63vRi/lfGub+Qubu4a9TfVup+AEVAgbJi53aNKp5vl4oTMfW6YhEaeYj015T+DmwecgdGZMF4tYjuUEdEusBZpRYcL3FvIUxiUV15pC4PREHUbxvToG4y4poGDOuxsKJjixz2U5ouxwmwxINbURuEvAfl5TJYuJg/WfMPftv/4aOXNjXI/S0MddfPTMq6YcP7o434jN4qtxqUfIfLsImWq4W5hPccC43yRf6Zv0nmWgeWPpxZxBQmWiAknBIQLsAN4oiu8rc7nPN9BTh2pnE9QfzhIl4Rl/TbkfQ4gMgh8Y1G22W3XRW5r6Ral09YwVS9L45weqTt1S4i4mR0BQPpduSXGBelEq6BowG1jkXxP+EotrTaU1MLVoRgBMTZ6gFE2EfioRGyCFpm2vHe9sLO5TFUo7clcoaRt1Hoivso8+Ttad0sn66R4q4sd+x12In5/sEk2N9c5K7QX9KjADUOFVtSkLopWUuqxSo/ZVVIedPQuyJxO6pcFpehKomluL+iq/pG1DqVg5mMYLwsVKiEfOqakFqmEEHQw26L1dvEuaUEY9S/nPI6eC2V3N4B7W/VtXy4fUGPOWY5hlYOohO4AQXi8DFgNkHhp8OdThjkLjUK++yepokrnKDlrwlytRaMG6NFYwcBtJ03nJPyCljqbRUj/tNkZQc3jyghXtlCeFVHqHSS8PL2kolbHg8fwrTvDpyT9kK89T2AL6f6SBeMpZLnHCvIBYuHzNfuSh6JLCr54jogl9oWzoP9k7ZscFRdiwzI7/DHyxkQ63SjDQtw6h2g5RJf0k0XPzTG2IlMYp705YnODGnxqwGdTulIhdGnMYyTv6P5miJoKiuIPn4cy5UFqXSfucwPg+/D0/TrehVd3mIyfrWUtSeEN5d8Yc6kHT5BlRBwzfufTqkUPSd4U
 oJLbaI5n
 E8RvFrMgi6yj81eTj7oft32KoHzZuQGmV2uJ8rMRGxgOGlTJVMmta/caKmfzV4IB8h0YWcWVuBYLKKXwWBVAy1oPpRkTnlwaTj7JvFnJ7cZnKL+EgXGT3vrYOGvLaW0ZRZ1pouFsJs0DzmHHqhheRNVZ5CnReqty3HxsFzjEhuNG4/hEq/3CSwJnST8+MO16BK71gWyhhbHH+21cTQd4HzuqC7jmvlAzzY1V03Ic+8BqjircpZdFiwePfiRMR1w8aVh4sPgCbrxSxrqAmSUmUdMawAvCjyC/y783VFF0MpBvoYtVaBewngRxaXOFnRxJc3SYZA2HfYFRsBbPsAERTjWc9QZTlce8KS4shHavKMjI1HpaB8YAowZpyCmBW39HrestQSShu3cBdwoX0BAISztkiUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 11:23:48AM -0700, Jiaqi Yan wrote:
> On Thu, Aug 21, 2025 at 9:46 AM Kyle Meyer <kyle.meyer@hpe.com> wrote:
> >
> > Calling action_result() on already poisoned pages causes issues:
> >
> > * The amount of hardware corrupted memory is incorrectly incremented.
> > * NUMA node memory failure statistics are incorrectly updated.
> > * Redundant "already poisoned" messages are printed.
> 
> All agreed.
> 
> >
> > Do not call action_result() on already poisoned pages and drop unused
> > MF_MSG_ALREADY_POISONED.
> 
> Hi Kyle,
> 
> Patch looks great to me, just one thought...
> 
> Alternatively, have you thought about keeping MF_MSG_ALREADY_POISONED
> but changing action_result for MF_MSG_ALREADY_POISONED?
> - don't num_poisoned_pages_inc(pfn)
> - don't update_per_node_mf_stats(pfn, result)
> - still pr_err("%#lx: recovery action for %s: %s\n", ...)
> - meanwhile remove "pr_err("%#lx: already hardware poisoned\n", pfn)"
> in memory_failure and try_memory_failure_hugetlb

I did consider that approach but I was concerned about passing
MF_MSG_ALREADY_POISONED to action_result() with MF_FAILED. The message is a
bit misleading.

How about introducing a new MF action result? Maybe MF_NONE? The message could
look something like:

Memory failure: 0xXXXXXXXX: recovery action for already poisoned page: None

> This way, all the MF recovery result kernel logs out will be sitting
> in one place, action_result, instead of scattering around all over the
> place.

That sounds better to me.
 
> >
> > Fixes: b8b9488d50b7 ("mm/memory-failure: improve memory failure action_result messages")
> > Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> > ---
> >  include/linux/mm.h      | 1 -
> >  include/ras/ras_event.h | 1 -
> >  mm/memory-failure.c     | 3 ---
> >  3 files changed, 5 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1ae97a0b8ec7..09ce81ef7afc 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4005,7 +4005,6 @@ enum mf_action_page_type {
> >         MF_MSG_BUDDY,
> >         MF_MSG_DAX,
> >         MF_MSG_UNSPLIT_THP,
> > -       MF_MSG_ALREADY_POISONED,
> >         MF_MSG_UNKNOWN,
> >  };
> >
> > diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
> > index c8cd0f00c845..f62a52f5bd81 100644
> > --- a/include/ras/ras_event.h
> > +++ b/include/ras/ras_event.h
> > @@ -374,7 +374,6 @@ TRACE_EVENT(aer_event,
> >         EM ( MF_MSG_BUDDY, "free buddy page" )                          \
> >         EM ( MF_MSG_DAX, "dax page" )                                   \
> >         EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )                        \
> > -       EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )              \
> >         EMe ( MF_MSG_UNKNOWN, "unknown page" )
> >
> >  /*
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index e2e685b971bb..7839ec83bc1d 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -948,7 +948,6 @@ static const char * const action_page_types[] = {
> >         [MF_MSG_BUDDY]                  = "free buddy page",
> >         [MF_MSG_DAX]                    = "dax page",
> >         [MF_MSG_UNSPLIT_THP]            = "unsplit thp",
> > -       [MF_MSG_ALREADY_POISONED]       = "already poisoned",
> >         [MF_MSG_UNKNOWN]                = "unknown page",
> >  };
> >
> > @@ -2090,7 +2089,6 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
> >                 if (flags & MF_ACTION_REQUIRED) {
> >                         folio = page_folio(p);
> >                         res = kill_accessing_process(current, folio_pfn(folio), flags);
> > -                       action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
> >                 }
> >                 return res;
> >         } else if (res == -EBUSY) {
> > @@ -2283,7 +2281,6 @@ int memory_failure(unsigned long pfn, int flags)
> >                         res = kill_accessing_process(current, pfn, flags);
> >                 if (flags & MF_COUNT_INCREASED)
> >                         put_page(p);
> > -               action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
> >                 goto unlock_mutex;
> >         }
> >
> > --
> > 2.50.1
> >
> >

