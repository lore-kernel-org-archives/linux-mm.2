Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94374CA0EDC
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 07:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63676B057C; Sun, 17 Aug 2025 03:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14366B057D; Sun, 17 Aug 2025 03:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02F66B057E; Sun, 17 Aug 2025 03:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A84416B057C
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 03:27:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA78283A0D
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 07:27:55 +0000 (UTC)
X-FDA: 83785420110.14.636558C
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1E4B818000D
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 07:27:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Upm1v1/g";
	spf=pass (imf06.hostedemail.com: domain of rampxxxx@gmail.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=rampxxxx@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755415674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4PiuZFmYJPkqf6DE7c8TdBOE7rHropm9V6shxmBGNA=;
	b=bR/BA4P3Pqjckn/olok9WEuHAqPr7+d0+k7Kfi4IJhEtBLQm6er5OqeJEkr/q0QZ7KSGm0
	vM7JR3OR0N9IPnf/X6QNwbT/ZLAIjAtgq+iDwNZRPe51RcxTvQljzyp2WQwL/P/AGohxk9
	QcS1ZLFcuWM6wmxDT/N6DyqCJQT3WJM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Upm1v1/g";
	spf=pass (imf06.hostedemail.com: domain of rampxxxx@gmail.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=rampxxxx@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755415674; a=rsa-sha256;
	cv=none;
	b=MXQ2zerL7VeZi039FvhnrF2w/H75EVq2AxV3dQQRm7jMMbJQD4Ltll5xHjWZK+IZNJ4yjH
	cOcwQ6taFh2eRAx/KSU6F+Uoq+Tbibrgv2tyaEzKawjyQGczFO5lDX19oMf3ZGPEWdJjPI
	S11VLg6vu+WJtilftqnWWr34yHq86hM=
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-53b174dbfceso1027432e0c.2
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 00:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755415673; x=1756020473; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V4PiuZFmYJPkqf6DE7c8TdBOE7rHropm9V6shxmBGNA=;
        b=Upm1v1/gD2Dl0KRdtsSJf9/RQU+mppnwABnFLfWWJECkZMVNcq/lvgrhMLBoOeTndg
         u4/YJjnP5AiL6aFDsFTJrKYnDagQxbKMOyGAuyWj0VeoP823cpv52Qha32igN7KmrxSQ
         P06DCT8Zk8dFAELgyBKjPrsFU3To6C6TrM7An1beNikPMcuo/BKUA8nN93tS1/IcPdKQ
         B3Db6EYN2nUNowLq6TjOi3TZmY7jsQc0Xka8MzVT7MhFfK7Pq5AXXSVJ5EzBPn2wTxFv
         zRe9SWqRn1ltzFxoLc4Pwd70vXOotsTJJjHcOr8OfRT9szQNNYgajGyPOEMevm2nKwMS
         8Xjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755415673; x=1756020473;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V4PiuZFmYJPkqf6DE7c8TdBOE7rHropm9V6shxmBGNA=;
        b=fUY7E8bZbEKQm3+KKyd1RtpnJOBrGJIXxrXWXGlnIIAwwJweCsd1l/a8swU8Dz9IEJ
         vWLhaGROYBfxD/3l1Xr0ghLRnnVPWZ/7QJNSOoXuro4Df974E5VyhrOPVwqGEVoDM9ib
         NJZgMdTLL/u8d6p96Hba1Zuj3+F/MffQKb/kEFQfVi7R0KakS9zg/dMnGU1v3Iwjdv7I
         lmJs3jmBOogY08FDA8lwoKDn/2/Cy36X1rLAv8+oRn4F6HFY1LKmMNCJWqoaPR+4EvsS
         aHk+5St2bUDAcmas6GH8erEpqAiVZDdtJkOOISvf7wM+j8v5tfl5GZ1wwyMYtLZsWyNW
         KhdA==
X-Forwarded-Encrypted: i=1; AJvYcCUPAL9WBc6cV+4SrwMPTvhjpUPvIora1Yt0QmDQQ9gXPti6lu+DpiDlSYCNLF+9tgPLh8N4w0qlxA==@kvack.org
X-Gm-Message-State: AOJu0YxF3oQ8BZUsJJTIzePY2m2C91A73+zd25rznxvyb8cZxPw7yoyA
	dKtWx/gmj/9ACQj7SdV4eERvE5db2Qyh2bhj9Mku5A/A/pwHupGa8biPc1cAbelKgilSWeHg3KZ
	onSIh1Sg6MiZ7O3gq74lk8ez074DazGY=
X-Gm-Gg: ASbGncuU+Zbo5NquNxcDiqkYdHhjn36KyjORqNvZD6rnndMi8hISselBF9GUYuQAMLg
	uTIQ/Su0kK5H9/fTO2EgqRbQ1HUtr0/ERmIZa9mdZHshSz6PMVK54FedL9xicQA3DRHhZXBN5Y7
	YSMuuK8FdlS71DVhOgiJnNMriU0/7S/8dq0Lagq8kM8+IPLk7+6bfnmuh+qqGgjDaXhWW2Us0rS
	f4w
X-Google-Smtp-Source: AGHT+IFw8c+CMBTZHQwKwut4xVl4QkzjA8yodaiGvcVGIt2PPLJkGe4DnaVboHcu3+6G+DWxzG+ehI9z3LziPU6oN2I=
X-Received: by 2002:a05:6122:3113:b0:539:52d1:1f65 with SMTP id
 71dfb90a1353d-53b2b8d2a08mr2753583e0c.9.1755415673008; Sun, 17 Aug 2025
 00:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
 <20250816040113.760010-5-aboorvad@linux.ibm.com> <20250816143129.u2rdwpwvfhsdptvx@master>
In-Reply-To: <20250816143129.u2rdwpwvfhsdptvx@master>
From: Giant Sand Fans <rampxxxx@gmail.com>
Date: Sun, 17 Aug 2025 09:27:40 +0200
X-Gm-Features: Ac12FXzDcl2pIw7-3iPyFxfAApM_9PjvOfnuc5cs7m6N3aPAKTtmCcO5DdgTJxE
Message-ID: <CABPJ0vjhML65fCwTotPsYiRmFbNxefH=oSJF6zjN0O-skjCfGQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] mm/selftests: Fix split_huge_page_test failure on
 systems with 64KB page size
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, shuah@kernel.org, 
	pfalcato@suse.de, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	donettom@linux.ibm.com, ritesh.list@gmail.com
Content-Type: multipart/alternative; boundary="0000000000009f7834063c8a8f70"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E4B818000D
X-Stat-Signature: uh863xgpag4fpah6g6eihsjq54am9f7r
X-Rspam-User: 
X-HE-Tag: 1755415673-180675
X-HE-Meta: U2FsdGVkX19U4nvpNsl5DrGp9dH4MFsXuOT+bzIHm0hTwrFE2f40s8K7GtJpaQqxZEnQVyA8SXoIq2lY1grH+l/77vDiYOTaZk80RC0TywDyXt1nJLGNKCgw000wZcELQTidLeB9UAINsJUVyIDk4xn3n8ZyeTjfywUrh+wBFjtTP/M4N7VsKokYiYAlozedT/6rnikZRH6+yzXHY2dfEu5MeXUjohAclOlMrEDnM1juBLJT6RFSW1RU5hmVAty1xRuz/h31lAuPQtWoYlXerEAZiXwKVCAfoK6XQnSiqytqA78c9W1V5KLCzVp4YThywq2emUPi0SXwxtBpLktdifcJ5wRvuczfIBlxWrCiLLJQsXNQ1oKBY/ypZK9Lcpj1aLdswsVHyh2dFkUbvxqZqrFQMhNlk6iIGqGb/94b0BNrgaySYVckxEELMdQ1/U6DgIzIQshqypSvatAkbiPrSfNK2xJ0+OfpFmzetpVLLaXkZMSC5+aDdw6zppN+7hLPCPtmv7vG3gnfHE8wmDIB/Uv3abahQOR3ltQ0wqCG22of2cDBFRSacIJIP74ayiiqAw5ri95swCxtbfrM6L5mSr+TDclKPgg75kjmZ06Ad752H9hg2Ppm0+HxR+VWe8ES0nS6by7Cu+Wn+AqUj4mq40ACNfcZmuIPoXyeOufo0dGT1KsqFNh8BHk5PIijoc8q6l8ADxFep4+EcHjmL1oqUoD6nldtlXEvv3/+zoXABMt1VBsTo43MvQcb2gZj+djKJifu1tOqsvYvGi4vi1ovb8OL4jbvegD7YztORault3kLNvsHY44Bb+ht6j97Y1BzUbjXMXXGJT3sVucrpJWAIvNR0wR+KrptvxAf4/r5xMKdE19Ybu5yfO/gAN0LoWLWV1rtsQuYRASrhRr7bcftIedQyjmxsRiDit+kEopH8ElFFTPBB6bap2Ud08g/gBwPsxP5NlaOovcUigNLnn5
 EUtei/pK
 DcYY3hDeeiGCSgcrBIFj0G6/b1IIHfXDBM4ull+ByXScGzcF6qXgI6tS2hkfEL+IAmUERzmGUNlopEiIldKH5949tmmmMXHVzvwGt7U3w+AOSUfliig//CXVvmT5Gvay02oUr9cgdakB60v3Tx8utF09y8bmW199daJPCB7TBiXvYFt2XTnP4GS69Ek8YadciGZeNz6rcGaaobLREiZJBDaMUy7oJkIjlYq16cyfuokHQ64+xW7kM2+DJmYPNsmk9dhM0bRlQ0P16fjiHVBRCtniDr1AE32UgOCot5tGPK1Gz6nVHQEc1ylAPpC4QBwLPQc4FslWfz7lGasp8gseMCV9HTx8p5SbvjecvdWdLgjk91Gj3l/gKepEiBx2+Zpgqbj3EJDnYWAns5g3IJI+A6W7lBT7Yu2vZVUvcoiJd3PbBYqKOhcNMhE9Nv0CGultiXCL7eLCrSMN7A4qF5Hyiv9eRDTwdcClswEBL48Q7PJt5Q+f4hmqQKptlfnNN35NhhSDP/kcoeKVABrbV9m8f5Ka6ySdhM3BIesoJ3QylrNmL9AxNVHM4rBFHJ5m4lWslKyxGseOGbEybxcUgOQhAeOPNRvAeHPV+JYXnOiK46sUcUOVvM5JoicyDcVTDjQRnl7n1K60WlOY4s8D9e7iC/QUGKoJyufc1fBNiJ41XHBVyTbUTvYCXqTA67jstcRcZlr9QG4yWhZG+tpOjIM4oupW2KQznDVCzm24u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000009f7834063c8a8f70
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

El s=C3=A1b, 16 ago 2025, 16:31, Wei Yang <richard.weiyang@gmail.com> escri=
bi=C3=B3:

> On Sat, Aug 16, 2025 at 09:31:10AM +0530, Aboorva Devarajan wrote:
> >From: Donet Tom <donettom@linux.ibm.com>
> >
> >The split_huge_page_test fails on systems with a 64KB base page size.
> >This is because the order of a 2MB huge page is different:
> >
> >On 64KB systems, the order is 5.
> >
> >On 4KB systems, it's 9.
> >
> >The test currently assumes a maximum huge page order of 9, which is only
> >valid for 4KB base page systems. On systems with 64KB pages, attempting
> >to split huge pages beyond their actual order (5) causes the test to fai=
l.
> >
> >In this patch, we calculate the huge page order based on the system's ba=
se
> >page size. With this change, the tests now run successfully on both 64KB
> >and 4KB page size systems.
> >
> >Fixes: fa6c02315f745 ("mm: huge_memory: a new debugfs interface for
> splitting THP tests")
> >Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> >Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> >Reviewed-by: Dev Jain <dev.jain@arm.com>
> >Reviewed-by: Zi Yan <ziy@nvidia.com>
> >Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>
> Nit below:
>
> >---
> > tools/testing/selftests/mm/cow.c              |  5 -----
> > .../selftests/mm/split_huge_page_test.c       | 22 ++++++++++++-------
> > tools/testing/selftests/mm/uffd-wp-mremap.c   |  5 -----
> > tools/testing/selftests/mm/vm_util.h          |  5 +++++
> > 4 files changed, 19 insertions(+), 18 deletions(-)
> >
> >diff --git a/tools/testing/selftests/mm/cow.c
> b/tools/testing/selftests/mm/cow.c
> >index 90ee5779662f..e742d9313798 100644
> >--- a/tools/testing/selftests/mm/cow.c
> >+++ b/tools/testing/selftests/mm/cow.c
> >@@ -41,11 +41,6 @@ static size_t hugetlbsizes[10];
> > static int gup_fd;
> > static bool has_huge_zeropage;
> >
> >-static int sz2ord(size_t size)
> >-{
> >-      return __builtin_ctzll(size / pagesize);
> >-}
> >-
> > static int detect_thp_sizes(size_t sizes[], int max)
> > {
> >       int count =3D 0;
> >diff --git a/tools/testing/selftests/mm/split_huge_page_test.c
> b/tools/testing/selftests/mm/split_huge_page_test.c
> >index eadbeb820d71..7cbeaebc9d71 100644
> >--- a/tools/testing/selftests/mm/split_huge_page_test.c
> >+++ b/tools/testing/selftests/mm/split_huge_page_test.c
> >@@ -523,6 +523,9 @@ int main(int argc, char **argv)
> >       const char *fs_loc;
> >       bool created_tmp;
> >       int offset;
> >+      unsigned int max_order;
> >+      unsigned int nr_pages;
> >+      unsigned int tests;
> >
> >       ksft_print_header();
> >
> >@@ -534,35 +537,38 @@ int main(int argc, char **argv)
> >       if (argc > 1)
> >               optional_xfs_path =3D argv[1];
> >
> >-      ksft_set_plan(1+8+1+9+9+8*4+2);
> >-
> >       pagesize =3D getpagesize();
> >       pageshift =3D ffs(pagesize) - 1;
> >       pmd_pagesize =3D read_pmd_pagesize();
> >       if (!pmd_pagesize)
> >               ksft_exit_fail_msg("Reading PMD pagesize failed\n");
> >
> >+      nr_pages =3D pmd_pagesize / pagesize;
> >+      max_order =3D  sz2ord(pmd_pagesize);
>                     ^
>                     extra space here
>
> >+      tests =3D 2 + (max_order - 1) + (2 * max_order) + (max_order - 1)=
 *
> 4 + 2;
>

Is it possible to have some defines instead number for readability?

Thanks

>+      ksft_set_plan(tests);
> >+
> >       fd_size =3D 2 * pmd_pagesize;
> >
> >       split_pmd_zero_pages();
> >
>
> --
> Wei Yang
> Help you, Help me
>
>

--0000000000009f7834063c8a8f70
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><div><br></div><br><br><div class=3D"gmail_quote gma=
il_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">El s=C3=A1b, 16 a=
go 2025, 16:31, Wei Yang &lt;<a href=3D"mailto:richard.weiyang@gmail.com">r=
ichard.weiyang@gmail.com</a>&gt; escribi=C3=B3:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">On Sat, Aug 16, 2025 at 09:31:10AM +0530, Aboorva Devarajan w=
rote:<br>
&gt;From: Donet Tom &lt;<a href=3D"mailto:donettom@linux.ibm.com" target=3D=
"_blank" rel=3D"noreferrer">donettom@linux.ibm.com</a>&gt;<br>
&gt;<br>
&gt;The split_huge_page_test fails on systems with a 64KB base page size.<b=
r>
&gt;This is because the order of a 2MB huge page is different:<br>
&gt;<br>
&gt;On 64KB systems, the order is 5.<br>
&gt;<br>
&gt;On 4KB systems, it&#39;s 9.<br>
&gt;<br>
&gt;The test currently assumes a maximum huge page order of 9, which is onl=
y<br>
&gt;valid for 4KB base page systems. On systems with 64KB pages, attempting=
<br>
&gt;to split huge pages beyond their actual order (5) causes the test to fa=
il.<br>
&gt;<br>
&gt;In this patch, we calculate the huge page order based on the system&#39=
;s base<br>
&gt;page size. With this change, the tests now run successfully on both 64K=
B<br>
&gt;and 4KB page size systems.<br>
&gt;<br>
&gt;Fixes: fa6c02315f745 (&quot;mm: huge_memory: a new debugfs interface fo=
r splitting THP tests&quot;)<br>
&gt;Co-developed-by: Aboorva Devarajan &lt;<a href=3D"mailto:aboorvad@linux=
.ibm.com" target=3D"_blank" rel=3D"noreferrer">aboorvad@linux.ibm.com</a>&g=
t;<br>
&gt;Signed-off-by: Aboorva Devarajan &lt;<a href=3D"mailto:aboorvad@linux.i=
bm.com" target=3D"_blank" rel=3D"noreferrer">aboorvad@linux.ibm.com</a>&gt;=
<br>
&gt;Reviewed-by: Dev Jain &lt;<a href=3D"mailto:dev.jain@arm.com" target=3D=
"_blank" rel=3D"noreferrer">dev.jain@arm.com</a>&gt;<br>
&gt;Reviewed-by: Zi Yan &lt;<a href=3D"mailto:ziy@nvidia.com" target=3D"_bl=
ank" rel=3D"noreferrer">ziy@nvidia.com</a>&gt;<br>
&gt;Signed-off-by: Donet Tom &lt;<a href=3D"mailto:donettom@linux.ibm.com" =
target=3D"_blank" rel=3D"noreferrer">donettom@linux.ibm.com</a>&gt;<br>
<br>
Reviewed-by: Wei Yang &lt;<a href=3D"mailto:richard.weiyang@gmail.com" targ=
et=3D"_blank" rel=3D"noreferrer">richard.weiyang@gmail.com</a>&gt;<br>
<br>
Nit below:<br>
<br>
&gt;---<br>
&gt; tools/testing/selftests/mm/cow.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 |=C2=A0 5 -----<br>
&gt; .../selftests/mm/split_huge_page_test.c=C2=A0 =C2=A0 =C2=A0 =C2=A0| 22=
 ++++++++++++-------<br>
&gt; tools/testing/selftests/mm/uffd-wp-mremap.c=C2=A0 =C2=A0|=C2=A0 5 ----=
-<br>
&gt; tools/testing/selftests/mm/vm_util.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 |=C2=A0 5 +++++<br>
&gt; 4 files changed, 19 insertions(+), 18 deletions(-)<br>
&gt;<br>
&gt;diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests=
/mm/cow.c<br>
&gt;index 90ee5779662f..e742d9313798 100644<br>
&gt;--- a/tools/testing/selftests/mm/cow.c<br>
&gt;+++ b/tools/testing/selftests/mm/cow.c<br>
&gt;@@ -41,11 +41,6 @@ static size_t hugetlbsizes[10];<br>
&gt; static int gup_fd;<br>
&gt; static bool has_huge_zeropage;<br>
&gt; <br>
&gt;-static int sz2ord(size_t size)<br>
&gt;-{<br>
&gt;-=C2=A0 =C2=A0 =C2=A0 return __builtin_ctzll(size / pagesize);<br>
&gt;-}<br>
&gt;-<br>
&gt; static int detect_thp_sizes(size_t sizes[], int max)<br>
&gt; {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int count =3D 0;<br>
&gt;diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/=
testing/selftests/mm/split_huge_page_test.c<br>
&gt;index eadbeb820d71..7cbeaebc9d71 100644<br>
&gt;--- a/tools/testing/selftests/mm/split_huge_page_test.c<br>
&gt;+++ b/tools/testing/selftests/mm/split_huge_page_test.c<br>
&gt;@@ -523,6 +523,9 @@ int main(int argc, char **argv)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0const char *fs_loc;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0bool created_tmp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int offset;<br>
&gt;+=C2=A0 =C2=A0 =C2=A0 unsigned int max_order;<br>
&gt;+=C2=A0 =C2=A0 =C2=A0 unsigned int nr_pages;<br>
&gt;+=C2=A0 =C2=A0 =C2=A0 unsigned int tests;<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0ksft_print_header();<br>
&gt; <br>
&gt;@@ -534,35 +537,38 @@ int main(int argc, char **argv)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc &gt; 1)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0optional_xfs_pat=
h =3D argv[1];<br>
&gt; <br>
&gt;-=C2=A0 =C2=A0 =C2=A0 ksft_set_plan(1+8+1+9+9+8*4+2);<br>
&gt;-<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pagesize =3D getpagesize();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pageshift =3D ffs(pagesize) - 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pmd_pagesize =3D read_pmd_pagesize();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pmd_pagesize)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ksft_exit_fail_m=
sg(&quot;Reading PMD pagesize failed\n&quot;);<br>
&gt; <br>
&gt;+=C2=A0 =C2=A0 =C2=A0 nr_pages =3D pmd_pagesize / pagesize;<br>
&gt;+=C2=A0 =C2=A0 =C2=A0 max_order =3D=C2=A0 sz2ord(pmd_pagesize);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 extra=
 space here<br>
<br>
&gt;+=C2=A0 =C2=A0 =C2=A0 tests =3D 2 + (max_order - 1) + (2 * max_order) +=
 (max_order - 1) * 4 + 2;<br></blockquote></div></div><div dir=3D"auto"><br=
></div><div dir=3D"auto">Is it possible to have some defines instead number=
 for readability?</div><div dir=3D"auto"><br></div><div dir=3D"auto">Thanks=
</div><div dir=3D"auto"><br></div><div dir=3D"auto"><div class=3D"gmail_quo=
te gmail_quote_container"><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
&gt;+=C2=A0 =C2=A0 =C2=A0 ksft_set_plan(tests);<br>
&gt;+<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0fd_size =3D 2 * pmd_pagesize;<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0split_pmd_zero_pages();<br>
&gt; <br>
<br>
-- <br>
Wei Yang<br>
Help you, Help me<br>
<br>
</blockquote></div></div><div data-smartmail=3D"gmail_signature"><div dir=
=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr=
"><br></div></div></div></div></div></div></div>

--0000000000009f7834063c8a8f70--

