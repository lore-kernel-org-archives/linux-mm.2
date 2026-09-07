Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D911C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 283886B009D; Mon,  7 Sep 2026 06:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233D56B009E; Mon,  7 Sep 2026 06:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14A496B009F; Mon,  7 Sep 2026 06:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED0FE6B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:41:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BBC0160108
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:41:23 +0000 (UTC)
X-FDA: 85186624446.08.2E20FE4
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9AB7720003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:41:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="X /Lntpx";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=KJiR8X1i;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788777681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1jD860aYnoDzzTEnpbBDK2GJND4YZ6QB5STId18Bk54=;
	b=58i54JhlbUMzZPRET2p4GWokJgFshGCGCn4+jpfbpshUaQYCZ43tVi6akDv89SA0oSb/pD
	uUOmvb7jSm+IJkTaorGd3p2oS49HW0zba4k0a7p0cGsKGCnskSzRiNxmpWlGo+l2/IGlQe
	VH+aMIAwPRP1hqZdHp+IiS3pkAXNaPw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="X /Lntpx";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=KJiR8X1i;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788777681;
	b=G02EDl/8NjHXJo3F8oardVESiWQ1x1+FGWiJEevC17KpuDZzNvJ+SUUBurVzN2i10PzGs3
	PFsiIB8U6Pc9X5oNV7gbe03n2X+UCqGWNZBRwZLZuQUPA0vd9neh/Vr7AroIFhuUb9m5uF
	4xrkOZVsiKbTPDbHEWdWlEMe8W3zK8k=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2464F1400067;
	Mon,  7 Sep 2026 06:41:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 07 Sep 2026 06:41:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788777681; x=
	1788864081; bh=1jD860aYnoDzzTEnpbBDK2GJND4YZ6QB5STId18Bk54=; b=X
	/LntpxOyNtorVCir5bQm1OJHT5P5LZEDNcxMxx0lYxptKQiGcmarOPkSDBjiIhDE
	sgRvqJGB/7MMgZynNfwIwPdes6HkOAxu6/205e9JSDaRrX6evBbpHk52TbCM51eG
	JmnIYRV+iSa8miEGx7kE/CeTaMw7zsnrLrnVMW81/TVGdN1YHWdcJc3HHfQlTjQb
	afZwnePWsn0Qe4jCdvt+GYwLazciszx/bNO6QuZa3sjAfcshj5fd+UwRsvwfzgwg
	utoaqkOatrReUwfAWEulepVmOJJaffCDpHEQMJQgMM7KJpAqkmHrBPpXvlmogICO
	kq6Pg+J9w4G2HPhOLoz3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788777681; x=1788864081; bh=1jD860aYnoDzzTEnpbBDK2GJND4YZ6QB5ST
	Id18Bk54=; b=KJiR8X1iWATJ1XU7NDFWEOTKYaasTfiqK/H6RiqUMw+ALi95AvC
	kckukTbozf3Hx40vBalUOil0iNx8WamDvqV0gP+Q6RUbXxg9Nm7fV24zC3HRqrij
	oTGoA4QBGQ1NemVnqhAQ2gSXg6tQuY4VTkGO7P0PFzNHdkE+zqXCTvZrQpyrW0p9
	Nt1/hfUgWuB1acGenleAg8sg1j1vdg0ScC1H34ggexKm3bym8RPiK8cx9DHmSd4+
	cEJ6esD1HXAgl56YPPm3F5UJ3BTHkv1zqsPvf7b1JGUWKrYbdUvHjpbmOIHgsBMV
	BfjqO4xuvf6XYIWheG+o8zzAKjTWXnYi9aQ==
X-ME-Sender: <xms:0JSeaidWHaHz5m6VOVDvZqXur6F75V16mRVA83UhhtSEW0yaoPr7ZA>
    <xme:0JSeap1zeIDhmFFgoaWyTWPbnWL6bfCfEUt_hvE771PV9TdY4t8E8Rp3ZTcurBMpw
    ZLLxjUkMey_7QVH5SbuNpzziXH91F6EdppuhOXvTIG16sU_XgE9M9k>
X-ME-Received: <xmr:0JSeaq7ZHHW0066zNGuLLRssmb4goMIp89Eosxe9cVIJ-vWhKaEJi3DyFKw>
X-ME-Proxy-Cause: dmFkZTE7xOBBvL/1OD9pECi3KCdAnpNQ7xJGV1gqKh8LGh9lBNniwXdMjixNdKGF3Rjiz6
    CifmFleIX1zDNXXqXFb1kCy4yWhc+a5/oNU/hl7flkrPaYBo8uDuggQub2vrdfM0SlTk7N
    iHc/CEZyhuvz3qNxoRQW3OwuWlT0fFltXwHfwm+gfLrRv6iKPMXIJc9B23QURUJTKjHR2E
    gIQ6cM3sh1TNQ2fZpmbT6Z3NGu/BprrhWiWC6dzFFtCqyqbZ8rNSxSA5NQ/5sPG3JNfmQ0
    9omRcS4KXSyO5NN4x3a3mm2XgmJ+tbvh0D95oHxRGr8PhyHIVUSMqLpcDIIsHzwxefE3PX
    6PY02GFyH0T9JvrTn51Do9taVYrZBCm6YhDaxxKJGKIJHB8QTPnFwMHEbEeTaeXDB21mTO
    fJeAbQP4eXU1/oO058LL5PDXFpQ7Z5IHOCCGx79hTDqOd2c1JC4EfnVoWV0g4EcvjhDDLT
    uKvUIxPgR7URTdz7HYH3o7szAh3V3RlF7NRNUt8JM9rkUs9Os6L3ezTL1Z5gZzgvw/siFw
    3qZWRxc3n+zDgp5ZfGNC1GfSkhtjPwoZY6sewrxdV0ki+lhmH/2H6Ss52C6sScbpi6rcVO
    YMSUHrRvoyuT/XohWXow330iBKYVmgQWwK2/t6rEJmVOte9HFJrffmTGTKxA
X-ME-Proxy: <xmx:0JSeaoLPait2-XP6nhI_IijMlpaLibVgtTkn4tHFJ5AwQERm4UcnTQ>
    <xmx:0JSeambeqIStzhPBjLE-bio5-2JBQU1mqYgyYYIijYB9cElZX-5SKA>
    <xmx:0JSeal3WTZHFK_a8hhtuI7_HaOYsXXvdc3GG9HmgQzByVXz19kV5xg>
    <xmx:0JSeaoMeVhtRi855EJsLkGCvkh49baMiYPRb520XuBft3g7WvDzSBw>
    <xmx:0ZSeatAm7wR4H7wutSb_QHhyKnBpzssyw3vUZHeSD-qP0ALiUjJ6q22x>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Sep 2026 06:41:19 -0400 (EDT)
Date: Mon, 7 Sep 2026 11:41:19 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 04/12] mm/collapse: add collapse.h for the collapse
 interface
Message-ID: <ap6UoT0h_Br97gX0@thinkstation>
References: <cover.1788533997.git.kas@kernel.org>
 <ec5230f43af7153e18aed02c6ee38f010106d8e8.1788533997.git.kas@kernel.org>
 <DL717O23OZOA.2UYSFURHZH0H2@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DL717O23OZOA.2UYSFURHZH0H2@nvidia.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 65pfj4pzmktdoczgpppg8xo8j7ds96fc
X-Rspamd-Queue-Id: 9AB7720003
X-HE-Tag: 1788777681-280386
X-HE-Meta: U2FsdGVkX1/YRmbiAMoqCMU+Q4D+BVoLwyGzeqPgC0fG4JvJv5A7a3SkzDvcb4ojB+DuNIcDLH7HxOZK1JqCCP7OD8hCniel3Cg4wTN8mU1pz/BURUZg3XzBUzkUEnVz5aIJTPnBaqQFyGr5g2knT4oNmgNOq3mHkgjAKCW4S6JPFDz7KW0DNjnxaTTa6vWcofjjLRZ2EtbPD5gC0KoiNOnWAuOxLRLGeHuMhmF6/xzYSwkpGRNPNTAeI0f1ftMp5oX71iVrWyYF7/oxB2VoTYEcELi2yCCltSuVNMSc/l3FSKtsoyf2+q6sL5uDEOAv+WHgn1wkzkDLdr6s1zJoJtUz0989XQmqnt6LC9mOL2rSzhBwG+9H3gPehBr72htqlRSrDuttp+fbevtbmweU59YUQdmtfmHalUQf273Tk8DGiYmT4pAFaj2jDF4XcgOoxQhURu8rfV6sj2F4gVeGBLlOamPghX9ibxPgpQStZ9EtcpEekDA1YG9XvmQ0uZ2FbE0sCWiC7Rdsur9mc/nCWXw+u6K/B8ue+awLPMkmiUE7i7KyKJ/0Ajk9pPdTFtulSGT9hDbLypn5SstmqLFudoQrd4vD67FpzyoBy6J4+FD0O0Uoe5hLBczS2T3yVJ0Mlgsrf0ErcoqS0ulVw+zf0yutT1dY+E2gFQxPVEImgzCoSNa7YoZblEO4BLlBAP4z2LK+URoM5vRBSBOAujBZEIm/MGiPFFr4sExlOt4HcCsRz3Y4ZbSHbg+OPNuL46dK7uPxLxYmZ8Re9mzT0rd/EFjKx1tqb2UkjKrh/qFKIuHMU0ooIBgpXBWewTfUH5w4yKeAYCUglsuJusOKF87Z/3eIItyH0CrKZLKKtMTnKZaJ67yE2EvvV24FwsDvXK2Wvv3M+DZJ/k3jXXTGJgjMY1k1tT3bIZTnJrlNzzPk73FXZ27u+aT1Q5BIgT1wA992cwFzH6XaddTojsbVC0a
 MrtPqOuk
 A3gOAM9NVnndFWkUezP58fPt4G5ae1ZzyMtsd92hzptFtfWiZUnxCto+ETzjJ1MZ04s4gOhcJXzTZ9/kRjGFXNaNxRp3dAnpktZzmXCX5hB0uTexm6zd7++iKDbVKZN4KyujdirIk0fAkTfl0UBY1ewh6kHPXEjZ8KDNmKq43GNDxk1zQ9lRefgms97lBNbAA7VddQf/y6kL5h85QBr4h9UeFi9YWsTW5gSrstJ90qudzACA0pf8visWoVZklTCnGfzG8/n2gzogkOYPOIzpJRUabhOVEE7mSFVKufMqbNGVWWWCj6cb2st/RC93yBNId2Xw1Xeuto4L7+6fWgvqZBP7b05BtlbbWsqYgDKxrQmAUPfThmlfeq17YD6iE6dp2Nak/4N1bf1DdR3UKjgf7Iebt8YOLIQBb7VNjtOVN0a2bKTtMaCztShRGaV6j715UcYCpMjJ2syJzXHEPocCPKgOGaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 10:36:58PM -0400, Zi Yan wrote:
> Are you planning to clean up scan_result? SCAN_SCAN_ABORT sounds funny,
> SCAN_ANY_PROCESS means nothing, SCAN_COPY_MC might better be
> COLLAPSE_COPY_MC.

I was not, but it is on my list now.  Not as part of this series: the
rename touches every result site and the tracepoint's EM() table, and
this patch only moves the enum.

> Anyway, for this patch,
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

