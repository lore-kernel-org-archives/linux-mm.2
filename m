Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D468CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 09:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C51C8E000E; Mon, 10 Nov 2025 04:48:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44ED58E0002; Mon, 10 Nov 2025 04:48:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EF988E000E; Mon, 10 Nov 2025 04:48:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13B6F8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:48:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABBF2C0CFB
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:48:33 +0000 (UTC)
X-FDA: 84094222506.14.230605A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5DEED180018
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:48:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NbIWz+Fx;
	spf=pass (imf24.hostedemail.com: domain of japo@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=japo@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762768111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a98CfjmePTD+JuGbf9VtPKBSfCpi8DNU4q7pZUy5p+E=;
	b=8k+0r0yvQfTIHyRJGaQsisEtHV/yO2vMtbZoHIm/ZarOlZAsl7fzOG0QUtSe8rkCe8jCxP
	Uslj3pIyAtbbf6q+7hTwszfcuti9r9BTMETQ5fqIG6EZHVlifAcrnTmlkwHtsKwRb+NAIT
	CjhimJbfM3ZF07egOE5Q48cea6QuKNQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NbIWz+Fx;
	spf=pass (imf24.hostedemail.com: domain of japo@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=japo@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762768111; a=rsa-sha256;
	cv=none;
	b=OPLSyvntwSslMK3VC+b0B3BfAioIjXmlK+GXBgQF3O7nBx6OnaRgsG6alVMsh3VtepOwmK
	8OgRUwgdYL9X9TPISGrGflUxd9121HrR5IiicjpY7vfmhbg0GihlQxcOTT92NvW04Z44C2
	oGcsxs3jBNiRHZ9vqxCZcNvh4qhDerQ=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A9JwIFK013673;
	Mon, 10 Nov 2025 09:48:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=a98CfjmePTD+JuGbf9VtPKBSfCpi8D
	NU4q7pZUy5p+E=; b=NbIWz+FxDn8g+YGwVLhcZ4kAjY4rVSZVypeTK/djcxgB3y
	t7/KSQ1gaeq3siUv2+MPp8sqHlG2H9l0xGG6Z5ZJPkHRJjYijMfojEupoJ2Br7e6
	NTZ64OiwKuWhKeBXi9LOpZKR53eE34niMUMBOKVx1zJQPbh5NKOFMtgD5SbWwNC+
	GcK+byyZCWnDIFniIwqRBH7J7IgnbxUieVXlava9qo3jUCDw5oHnz4Sz1epOu3da
	/PFu6qIpnMeokCXog0bNcWI6VOOV+asmPyJiR5RQPKi6OZK1oD9W9osvthYMexIZ
	kK7Se1O9rdeB7I2x8DOgvT9Y5oNh1wbNG/auku4w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5tjnf3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 09:48:26 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AA9kQuV029027;
	Mon, 10 Nov 2025 09:48:25 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5tjnf39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 09:48:25 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA97D0F004748;
	Mon, 10 Nov 2025 09:48:25 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aagjxn3as-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 09:48:24 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AA9mN0R25755958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 09:48:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0EAF20043;
	Mon, 10 Nov 2025 09:48:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8DE9320040;
	Mon, 10 Nov 2025 09:48:22 +0000 (GMT)
Received: from li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com (unknown [9.111.94.180])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 10 Nov 2025 09:48:22 +0000 (GMT)
Date: Mon, 10 Nov 2025 10:48:21 +0100
From: Jan Polensky <japo@linux.ibm.com>
To: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>,
        catalin.marinas@arm.com
Cc: akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, will@kernel.org
Subject: Re: [PATCH] mm/huge_memory: restrict __GFP_ZEROTAGS to HW tagging
 architectures
Message-ID: <aRG05VS-IIxV2y_C@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <20251109003613.1461433-1-japo@linux.ibm.com>
 <690ce196-58cb-4252-ab72-967e1e1574cf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <690ce196-58cb-4252-ab72-967e1e1574cf@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TjX7AmV5bBkDSJblXm1e_Oldw9yNMTAS
X-Proofpoint-ORIG-GUID: tOlnJNKqKiBpAi3dzDJ9nNv5_lNfPWyX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5OSBTYWx0ZWRfX202bi/KWpMN4
 lEZVD3vrScGWetcEbpDI0EeawZ6wGN3cBoRTHHg+y6U33yRQUvrgwOulhmDxHfM4JQBIi5ZG/Ow
 lFb8Bg2uPBwIv49KrLI0dQIH8fvNBrYOkMAJjGfIv+uwvDCrD3KPzPTBhLyKwDq6wCdjozgPnFl
 VIcQuTH7Co3d23dxAcfb0z5blGkeIlmKOTxmKYgWHaWLxBDBktE1cHu2FS9ZnYEWQQ6W9idjYVV
 8sggU+jDiXohL6+DvF80k58U8mOmGtBCerWY0OCt/yk+Cg9WHNoo2i+j8rUKlT8yHnc/XKACvtO
 Zyqoux+rq5ckj15lEtM2Vgkf6jM35wJyU7akwda27XYWGTPjuALSNWRYJDUXYz5a2gLLA510tdu
 Yn667JfsSwrr+uT+MGwpsyRz0c8Bow==
X-Authority-Analysis: v=2.4 cv=V6xwEOni c=1 sm=1 tr=0 ts=6911b4ea cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=VnNF1IyMAAAA:8 a=x1nD6dm_iKPnSlzVoXgA:9
 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080099
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5DEED180018
X-Stat-Signature: 3zyfbimfmuia43hgj7wfoi6twp9o5zd5
X-Rspam-User: 
X-HE-Tag: 1762768111-109597
X-HE-Meta: U2FsdGVkX190k2uYmsHStjQLORdyM8jv8S/Ncz11zepX4ZkxRjcDoSbcPd6K+c1n40hsFsi7osVaTdbTGnQ0FvMJNvEa3khYiNaw3EdrxAhM+mYyXWQxOUKeDg6VlUyNFjyaMrBwMYpFZ2SRiKstf5XiVe4cT+KTlBo14aclxIMZQbQsrUsq2l9pIHSedUNRgv1svym6dbf4TtP0GKrkN4i6/z3Ui04VWij1cWBJYu8FkC0P+5QKB3Rffz8ftNh2cuyuP8s7S8cYi9A7WuWNfeNjKK4AKkH/PjMzHEXxzJ6+4Dxgc7pxYtSS4Zr3y9s7NYWMccNsBqZfXuviCbPnFxNXsYOGaS0/Ty+MpDqTOANzctasngnpWKMDS2Qz97xXNKC0UItyK8bGVoVa1g/xhn1iPogPhJckLWhjq6ONv0krVEL59L72FGeZmUYtPxexvAgMgn9q6wycI93+EzFWpnJgZwO0T9GpRYl4kDfHDGe0U0BxHyauOE8RGEfYSFDB3LXLWsydVGrwuBjNxsLQ9OJqenhpNaXXLgrphL3ihNY1oQhKlvugiXPE5zjYAnRquKyo5iUY63t1hlryjCUyNcfaF1ywtkbWjFIbHOexCBMPQNeZTc+1XU0lCUGM+Csrl5YdKnH5HJDMdupMmSMVXHDB9ag+H7xdqHBLyfWhNSRyjeLeieHVgVQuMFMAWvT5uHk06pgPicoX7rRjKab78ZbFbojNxBV6LYCf5nKCLgsBM4Hl+mEZrEUxShF5zxtxvug9hzCgXRh20ovpRA4i3SK4Ftnqf2f/9ZOjZKTT+TZDOflod+axvVSDErVieiAHtGhLB3rnOThiIcbwHrkD17OkpI9Y6AFYiwUOMXKqglHv2Bx/KGnpwh2flJIMIFYS+D5pus4Bog3RD/v/YHjqCJUQqRhm5UE6CiAMCjuSv7+Be166M42AQiC9BNXGxAPh/XHaIZJZ77lfA6NVX8/
 TEXL8zPw
 fIDRLpdaqByMHsJhmo0RLCJ/qh3WdOxGffFK0VLnM8SPvkY3nsmT/FdtO1OyHhoCva0RiwCQwGTSMTtMPxrdD8YLUgiSDMtCrn0MdMgte0UAFPaU3pUIjhnbD5PJkttOSR9ccZy06k6/8RaGRXjNFtPD9mjQuIJhOEls0kW98RzLj3upD2Ro2/3ydiPBbPqhRYywPBR+XV95VrbeOSKGeCtweZ9R8gJ0BwbYP8ZCQ9W0INdlpPuopBvKRz5C6hMckGvEVkKBmpqk0tQ0NpfutWP7V30wWfTcjVW1hnF6nEfW03v//+HBVnbEu/Mehj4Yv6893e6lEB1XppYc/6rdmFbpH7WBvbHBicj0E05/tqjaza0K5fVxEaH8yhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 10:09:31AM +0100, David Hildenbrand (Red Hat) wrote:
> On 09.11.25 01:36, Jan Polensky wrote:
> > The previous change added __GFP_ZEROTAGS when allocating the huge zero
> > folio to ensure tag initialization for arm64 with MTE enabled. However,
> > on s390 this flag is unnecessary and triggers a regression
> > (observed as a crash during repeated 'dnf makecache').
> >
> > Restrict the use of __GFP_ZEROTAGS to architectures that support
> > hardware memory tagging (currently arm64 with MTE or KASAN HW tags).
> > This avoids unintended side effects on other platforms.
> >
> > Fixes: 1579227fe0f0 ("mm/huge_memory: initialise the tags of the huge zero folio")
> > Link: https://lore.kernel.org/r/20251031170133.280742-1-catalin.marinas@arm.com
> > Signed-off-by: Jan Polensky <japo@linux.ibm.com>
> > ---
> >   mm/huge_memory.c | 9 +++++----
> >   1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index aae283b00857..0c1794656d7a 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -209,14 +209,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> >
> >   static bool get_huge_zero_folio(void)
> >   {
> > +	gfp_t gfp = (GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE;
> >   	struct folio *zero_folio;
> >   retry:
> >   	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
> >   		return true;
> > -
> > -	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
> > -				 ~__GFP_MOVABLE,
> > -			HPAGE_PMD_ORDER);
> > +#if IS_ENABLED(CONFIG_KASAN_HW_TAGS) || IS_ENABLED(CONFIG_ARM64_MTE)
> > +	gfp |= __GFP_ZEROTAGS;
> > +#endif
>
> That looks like the wrong approach. If an architecture does not support
> __GFP_ZEROTAGS it should not trigger anything. __GFP_ZEROTAGS should be ignored.
>
> I think the problem is that post_alloc_hook() does
>
> if (zero_tags) {
> 	/* Initialize both memory and memory tags. */
> 	for (i = 0; i != 1 << order; ++i)
> 		tag_clear_highpage(page + i);
>
> 	/* Take note that memory was initialized by the loop above. */
> 	init = false;
> }
>
> And tag_clear_highpage() is a NOP on other architectures.
>
> Gah.
>
> I wonder if the following would work:
>
>
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 65db9349f9053..56b82e116cb79 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -47,7 +47,9 @@ enum {
>         ___GFP_HARDWALL_BIT,
>         ___GFP_THISNODE_BIT,
>         ___GFP_ACCOUNT_BIT,
> +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>         ___GFP_ZEROTAGS_BIT,
> +#endif
>  #ifdef CONFIG_KASAN_HW_TAGS
>         ___GFP_SKIP_ZERO_BIT,
>         ___GFP_SKIP_KASAN_BIT,
> @@ -85,7 +87,11 @@ enum {
>  #define ___GFP_HARDWALL                BIT(___GFP_HARDWALL_BIT)
>  #define ___GFP_THISNODE                BIT(___GFP_THISNODE_BIT)
>  #define ___GFP_ACCOUNT         BIT(___GFP_ACCOUNT_BIT)
> +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>  #define ___GFP_ZEROTAGS                BIT(___GFP_ZEROTAGS_BIT)
> +#else
> +#define ___GFP_ZEROTAGS                0
> +#endif
>  #ifdef CONFIG_KASAN_HW_TAGS
>  #define ___GFP_SKIP_ZERO       BIT(___GFP_SKIP_ZERO_BIT)
>  #define ___GFP_SKIP_KASAN      BIT(___GFP_SKIP_KASAN_BIT)
>
>
> Likely we'd have to make __HAVE_ARCH_TAG_CLEAR_HIGHPAGE a proper
> kconfig option.
>
>
> Then we could turn the default implementation of
> tag_clear_highpage() into a BUILD_BUG.
>
I'd like to suggest to keep the enum untouched and only use the second
part of your suggestion.
Which works by the way for our arch (s390).

 include/linux/gfp_types.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 65db9349f905..c12d8a601bb3 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -85,7 +85,11 @@ enum {
 #define ___GFP_HARDWALL        BIT(___GFP_HARDWALL_BIT)
 #define ___GFP_THISNODE        BIT(___GFP_THISNODE_BIT)
 #define ___GFP_ACCOUNT     BIT(___GFP_ACCOUNT_BIT)
+#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
 #define ___GFP_ZEROTAGS        BIT(___GFP_ZEROTAGS_BIT)
+#else
+#define ___GFP_ZEROTAGS        0
+#endif
 #ifdef CONFIG_KASAN_HW_TAGS
 #define ___GFP_SKIP_ZERO   BIT(___GFP_SKIP_ZERO_BIT)
 #define ___GFP_SKIP_KASAN  BIT(___GFP_SKIP_KASAN_BIT)

This solution would be sufficient from my side, and I would appreciate a
quick application if there are no objections.

Thank you David.

