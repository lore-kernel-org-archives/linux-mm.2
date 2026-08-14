Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E117C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7C16B0329; Fri, 14 Aug 2026 19:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59526B0719; Fri, 14 Aug 2026 19:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6FD26B071B; Fri, 14 Aug 2026 19:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94E976B0329
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:07:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3358840275
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:29:29 +0000 (UTC)
X-FDA: 85101317658.01.90017EA
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 77A11A000B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:29:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UI8fIhMq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786746567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ufcPNnfJAyI3kkCJgjhE8EqLR38Q7jjROlx/CU0gNg=;
	b=PqmElZ3JdR4QIHbd95hutje9c3p1QSQo+8sC5Jm6+ektKppd2N6i5QguoPxFL0dXIcGpjC
	3wsVFInUzmGE6mZnhY69VsFqQtKvEOfYQFMJNiyVRdF0GSHI4Oapeia78CArN7XPNR5Epj
	1vzBvq+bWTQJ2Z0pbS2ZSgxd8gQths0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UI8fIhMq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786746567;
	b=pOg8u4V087gsGPwuGxsgSjN1i8OnE5IX85Gnc6CQx/wvdf+AU/f6WuCxNUc36nTVWW/QUo
	xSLQu8J8f0sH+ZXDZQpn0b8oVDwM8LP5z7pEnmz8AhQ9BFybDxITo6DfWQI4LmU1xTtFpq
	c2xa6uwUztybjjnVGRlUOWGhSbMPv74=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso1386865a91.3
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786746566; x=1787351366; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/ufcPNnfJAyI3kkCJgjhE8EqLR38Q7jjROlx/CU0gNg=;
        b=UI8fIhMqXszu3dmBTSjg4Eu+kAEUr85qpgPGrkLVcZIo8x1Z+nJtRS+vmxrmQLLH5K
         zbvJx/fTpJ+GcXCXOrbAlUB1feDlmPTz7ltEaAEzl2gRXn7XW57eHmQVfbAnGk1/TgKP
         L5H3qdQXpfliMxM31kVn7iuTcci5rwlax99GjvSgfjkEKFArZ+8CgR52yelF6zYAhix9
         5xFoRdv+2EWab9gpOC8Gy2LLdPnKqG4d7GuO23543gsvOu6subFW1V+jRzikv2EYPNih
         HQfZ3S7h/lb81BuXljzJKysFfaIN1DuMTssBCqDhXeysm9MReOX8sfdfN3WiwJbmbwoB
         4PpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786746566; x=1787351366;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/ufcPNnfJAyI3kkCJgjhE8EqLR38Q7jjROlx/CU0gNg=;
        b=UD9OWNYVRpppCh6k9urWe9OaIYu551p5LRnLSVLjYruDLg+WSoEKlDAyAWXUpGhodC
         IPrEWZf+nnwFpWKB9H3j8zU1qBlwKmXBirS4f9vGi/j2rl3/lwxPSKpoJ1T5sCz+Fto9
         0X6WCFdkx1/5XqOnrcxak1Am1WQQFrtERSOGWg0osrAlc5IGDrYhywom39JKPcMNz3kp
         EeEJMgldwIRW+xnA8TVwqj1swN1Tm55kcCdBu1kxpOUwWnnel1nEUigXy/uRkpdKxM2n
         OrAlyrZSiYm9/hybLjy3QVio1ybPyvYnjMf9xCtK0Lk/avoQlH7k9686DwtLxKANMrok
         /vtA==
X-Gm-Message-State: AOJu0Yy9l2nfLkgh2Xo4AhnpNAOFPg74lZFkQ1aFRHm55wjss3PAz5gn
	1axLBIZwTR6MQyl65gCu4ZBZ2GBk9fZQSvMowPN/WMZBOcl6fvZi5hVr
X-Gm-Gg: AR+sD11YQwO7NBF4+tYstVC88e0Fg5SM47gDWNcBHj6ZM3lIkIAe13B5trySLLUr6l2
	pK1scT5+M1KE6mpm376flYbcQAwo3s1tTC/KinZlefsz8jPB1bisLy2hEWYvG1Qnm6orwZcFCrk
	JRyiTFwQWF4QtfB6qLyWu4BHYQmF3swJ2KF5G0oJoeGUvg5uTR5EWEyg+VeSmwULCpwaCVob72P
	UI/7QT5LXm8F1e9rYriV1mtsK0u4vLQ8zInWSKg4ZCoek+WAG6+ohjgOlMuTN0KAarNF0TCQWCb
	fhVfRll0WLoSj6GBfP/cm+nbUZU8URD3pdutjTiOMhUN8gxHSXOjpstn9T86lZCmghO6vS6vfzL
	OqqTvOCnkO+sF6PTd4iv/21O8GQqmBmbYuO4uXC7r1zKhmxyQkGeOqlftw6bsyQ8xmvnRJ5HUSY
	RFuQHDtra/F84LpY0BSYBrlQdUyJDhYKJXqlnXnpODKAjkvEjn8TWJlhhcl2TbLqgX1yvAD2z9d
	AvypHXtAIYEuMg3w9gTp0z5BW+nizHds2Me2/zFjEcvow1GCEjcxWn0TR2FRy9/3XP/z+nPq8va
	54iaug==
X-Received: by 2002:a17:90b:3c91:b0:380:f85c:94b4 with SMTP id 98e67ed59e1d1-3933b78e3c2mr11216186a91.7.1786746566302;
        Fri, 14 Aug 2026 15:29:26 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ebb888e3sm4122477a91.11.2026.08.14.15.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 15:29:25 -0700 (PDT)
Date: Sat, 15 Aug 2026 07:29:22 +0900
Message-ID: <m2y0e8pc8t.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: linux-mm@kvack.org,
	geert@linux-m68k.org,
	daniel@thingy.jp,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org
Subject: Re: [RFC PATCH 4/6] selftests: fix build errors on alpine linux
In-Reply-To: <an8MHlxZzu6a_1ui@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
	<20260813063401.1786548-5-thehajime@gmail.com>
	<an8MHlxZzu6a_1ui@lucifer>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: 9hopef5a5pmjpsbw5gt8zjwjis5i9n51
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 77A11A000B
X-HE-Tag: 1786746567-221565
X-HE-Meta: U2FsdGVkX189e3n8gOwEpbSos6o0EYRZhxufnM2TgUdA2ZquLnoP2aAZQZLUhB66AKSgbJ5g2U1QRpVdAkhJdu9IF6DOL4qKVAxqcM0YRJNNvmpih+eBt/83vBQOp2083+3CNZw1It0ePfHs54iEiiM5WeKyf/4wbMHzw1vMidgmMjXUGVi3cm6stZeFe3G6viapTSXLrxD9+VUMo+30UIO9RJmAvhV7v5gFOnqOxGjhG2CCsyVmmB6xi7vbhC79MohCMQaNYyOEXcyCDsSmAZeXdC00/4xlfrYYQMvSzvkxVjlJWCc3qmWIr6Fm9qq0MtvEmRXgNuPMkR27U6GYgkYUFwmVdn4qy6CQAugYTfyC4ZwyR9Gr0eg9MxyX9tb9ZhYZTRLr0z0haWRSA0F05oZ80L+OMGv75qLrQhvhgCeqXCS7zfBFbEI6MA7ZCCMEIriFy76qwyvBnazISTpR6AIEVra+bFhXgIwVP3OjH++WG+W9FTtJr4ulBaOt2ZKfkYDfVk26mJ5AL4xlnT5lbbBS5oK6vbO2dJmmbl5OOyeFc1j6kKnR7WSH6o0XKoESA673V1iI2A5D5Uf0k7A95/CkwQKtvQwPYPIlOaniADutv6jiNo7K3QLPyD7eoGT8D/dFIqloP2H41svUrThownX4UGu2mWLWZEsICy07LWyaNxarnTl3C+oNS1fnuhKPZM3z9mv9wqhq54GNyi3QfeQBshYOzsORV2c6sHgnrRdZQHN+1i30jxEaDOZf4nQse1xqoASifXFVIORYRnjfmFnj9+813800EDrqV87hh1pGHLkBr9CZBYn7jBqiuEgzY6AwhKxiYR6NfhPZO+yVV2GBf99QYRi1PR8JX5W8zg71ABI3oIp5WNg7m7afM12GcO7/OW6uM5OSeeIyLx1Ir6k0uTNv1Z+p3MRUTuoRxOMaTwmp3Hd7ETFhVuRX7Wk7Wgf1m281ZBZrzdwGIsE
 AAK+bXJl
 q7nThRUKM/OkI+CXgId8xNi7hzFTzXn3Tr3bJgT9v53fi587ikFUaOnKMd8sMOvYMDE6tyQV2eZbedBuNQZXF3/vhJIXbJr5c8HTCKieB3A/SYQQzGyyi15FH6C/J7eCzwYe186hRwRMIheCnBSA+GvZkqoh8bnVvXJlhtFsEYYn8azZk/WpFroQmErNJZdcDEa1qoQoUvPqpEWpbWkccKMvHtQCpvRj987icMab5nD5faEmpls2dG29CXm+980l2tgGJN90qBryGDpcN++8/V/c26F332YqrgwCrctahrzhGcqqF/pn20ROTWbgv+BNFXtNt8VvHnXBcHNrMZgOnrkrDNt7jEytbxuoe0JdB1C+Cg3W5Q3cJmPkO2nQHMHaYcZxef5Znpa18l5mTGswa/0OIWCE/2Kap6/lQSBNzMb4B+DqVwl3OVKyweOCP+5YECoLhaRqxmwqucVE1+PELRT4pTI7C98wlgvkQ8cYZDQLkJCtwTPH/GjpjZ6UDsBk9axjIrCdof9UK5geOVLrKvgYmBf2d2AjwboFj07yGarzzXpI4OrPQ42WE9UP5DTlbeKKOacH1EERutCA+tXWSyYcrF+BvKUMMNk+7n1sQKSG4hmXWCMtMyMF+1a7o90AcKSfjxp6lqWfkIW8A0BYyi02RKJwEc1YpywDc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 14 Aug 2026 21:39:33 +0900,
Lorenzo Stoakes (ARM) wrote:
> 
> On Thu, Aug 13, 2026 at 03:33:59PM +0900, Hajime Tazaki wrote:
> > Some nommu architectures only work on Alpine Linux, which doesn't use
> > glibc for the standard library.  It uses musl-libc and is implemented in
> > a different way as glibc, resulting build failures.
> >
> > This commit fixes this issue by adding missing definitions. The fixes
> > are now only covered to TARGETS=mm which was tested for the moment;
> > future contributions are needed to fully build/execute tests on nommu
> > platforms.
> >
> > Cc: Shuah Khan <shuah@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: "Liam R. Howlett" <liam@infradead.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: linux-kselftest@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Cc: linux-um@lists.infradead.org
> > Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
> 
> I mean vaguely looks un-invasive which is the test here.
> 
> Couple comments below.
(snip)
> > diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> > index f02cc8a2e4ae..2cc819006424 100644
> > --- a/tools/testing/selftests/lib.mk
> > +++ b/tools/testing/selftests/lib.mk
> > @@ -197,7 +197,7 @@ clean: $(if $(TEST_GEN_MODS_DIR),clean_mods_dir)
> >  	$(CLEAN)
> >
> >  # Build with _GNU_SOURCE by default
> 
> You probably want to update this comment.

indeed, will update this part (may even not needed to modify this).

> > -CFLAGS += -D_GNU_SOURCE=
> > +CFLAGS += -D_GNU_SOURCE= -D_LARGEFILE64_SOURCE

(snip)
> > diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
> > index fb4600570e13..aee6be530ccb 100644
> > --- a/tools/testing/selftests/mm/hugetlb_dio.c
> > +++ b/tools/testing/selftests/mm/hugetlb_dio.c
> > @@ -22,12 +22,9 @@
> >  #include "kselftest.h"
> >  #include "hugepage_settings.h"
> >
> > -#ifndef STATX_DIOALIGN
> > -#define STATX_DIOALIGN		0x00002000U
> > -#endif
> > -
> >  static int get_dio_alignment(int fd)
> >  {
> > +#ifdef STATX_DIOALIGN
> >  	struct statx stx;
> >  	int ret;
> >
> > @@ -43,6 +40,9 @@ static int get_dio_alignment(int fd)
> >  		return 1;
> >
> >  	return stx.stx_dio_offset_align;
> > +#else
> > +	return -1;
> > +#endif
> 
> Probably better to declare different functions to make this less hideous.

I see your point.  will look for the other way.

-- Hajime

