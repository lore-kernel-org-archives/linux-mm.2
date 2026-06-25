Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96F35CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 16:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD596B00B9; Thu, 25 Jun 2026 12:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A55F6B00BA; Thu, 25 Jun 2026 12:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD566B00BB; Thu, 25 Jun 2026 12:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F87E6B00B9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:18:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 724CC1666EF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:18:25 +0000 (UTC)
X-FDA: 84918942570.02.DD285F7
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8AF5040002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:18:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s+c6XcZD;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782404303;
	b=KcDMQRJLQi3AMecJGwn+l4PRrli4yj3B2Iqy0YyBlAcPZEINK8uX/d9Qnb74DXvIoR2dNy
	fmYooYa9N/1W8dISCZ0EnHFjqedhnw9fGKQZ/d/MbxbrUv/DnoCFD7+IN9ms6qTLcuJkzz
	pbL6EU6DLHlbNE4JNv/Vh0bSR5TrQCg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782404303;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqHpmuK4pkMoXE019QC10uQ8T4IH5rkVaD+e94INi8Y=;
	b=3EBm+kKyXw+s6qzNI/i/L24NKsIGg8FoVl2zVKzkUy7P8ZbA11cxr2PE9yOjv8RMtpjJv0
	NfPuC78EGBXtd6VjyMwgQ/y13pM90k3adPyXAHV8LBtT6T1q718z9EXO653CdTdZYCL59K
	I5O/1fY3T3LaZ2se0UE2BE77E3/mTsA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s+c6XcZD;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c0c5d170ad4so405325366b.3
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782404302; x=1783009102; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uqHpmuK4pkMoXE019QC10uQ8T4IH5rkVaD+e94INi8Y=;
        b=s+c6XcZDbaYLQUKIJ9yV2FxmZO5r3MazqQ1K4tcNZNEVfGUJr1FD8wxp6dCva8tUuz
         oDV0zCi0dqDK8TRnrQM9tdind7D6hvLrCaOXsIDP2sb3rsVz3YEesVkJ8yHYnbWBmwiw
         juxd+QPctdMDFNWZ+XofdrPJ4+LtaQaT5VpJegFbH6B+deaRrIbIE4nqPWJRs/J4oaEN
         P8Od/zx3JIfGDh9OSxvLMfPIdlOdtsqo2JhxatYpGaJw37NzJXBr0c1aMZE2ABxnCp0W
         +9eyKRf8UBknF7WXDWvIfstW7PbXJ2AGiarCuQ31FZepSfC/I3Wyq8hHI77siszN4kLx
         zBug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782404302; x=1783009102;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uqHpmuK4pkMoXE019QC10uQ8T4IH5rkVaD+e94INi8Y=;
        b=aFhVM5ETYrSlya5IpFAClYLbDJZccR0Olws9+BBrXDHsdC/WIqhqiqRGeJNFuqiMjI
         hs1upPBz9GiSitoVHjFUndawXdos/QuP8SW/Eq5sXUX3/QAO9Koal33slvGy0vt8p+t8
         47YhG7gUGLzYfPR2g8y22HXsCLM2vcEMhkJq74icLlrNJ4H9awVihgTTPV0hcaIddeKL
         MvCKajDLlqm2luvuDzwSUU0Jae7FjUW7Bwa3UbPr034bDizVPCr3CgzNB2ElSSLY3V/b
         J/WmVJc/fJS3EAzgCydrnnncunXWsVA/T6Q365INr6w9c46A422DWfoHUb+geizeInZK
         eidw==
X-Forwarded-Encrypted: i=1; AHgh+Rrwl29ICeNcm4ghIknm5xVMOHUTWjzGilddPSL3KWEtWGOcdvitiz8FwLsW51EVdgvycRSroaNpDA==@kvack.org
X-Gm-Message-State: AOJu0Yz/e0GID4TJdH8594movrQpqQcuZtYVYQVkXh3BQa3aYgI55xD/
	exM1N3Ffxx9+m2S1+h/++jodL8VuhOBefxmG15lDEMsQnPsL9eVA8hU1
X-Gm-Gg: AfdE7clHrHnuuhdmfKMnAk8cTRcGVe5I5klSn+ZhfdrDa0/EvybXjBRi/ouvptLI9Fr
	hZCbBQE42k4lX9oGM26Ju+KnHjZvVAsOPVrZulH0mzMLcM2Pey5x3lYI4kOuz5ATeuSl7o1M0Ol
	cg8bd2ezgM6hkndSkLz9l+XOsj5hGB7neE3i4UKeO1DeUMCeo1aJm0ZhqPklzdBWhRymJenGLes
	MVR3/8E9UBo5rCJRdWWx6CbhcHKPI92eVldujqU88cTxwfcwHyBXwSvR2qqzAOGEgfV0hsGXFBA
	pI/y+bsD6+CaOSKD0j9yL/Q4e6eUlj4uiOC65yfmBtJpCZ94PppAKP+1H0gN6IkdhKTCeiMraBw
	K25lFvnz+5LaxRhky44sriS4SjZti5/QXEOHl4dJawBeUOJInPzIwQheZHpQhyFaWUHqQ3FVrko
	IqEh70oC4te6cJLlujio+XRg==
X-Received: by 2002:a17:907:969e:b0:c0d:8c04:92d0 with SMTP id a640c23a62f3a-c1206187628mr260188666b.49.1782404301596;
        Thu, 25 Jun 2026 09:18:21 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbe5f249sm221917566b.50.2026.06.25.09.18.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Jun 2026 09:18:20 -0700 (PDT)
Date: Thu, 25 Jun 2026 16:18:20 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	willy@infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
Message-ID: <20260625161820.bkxl23ugqjd6tcld@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
 <aj0vjdBN-oNMI2yI@lucifer>
 <c66f4bec-0933-401b-bf2f-a1b2e256023f@kernel.org>
 <aj0zDKEJV35V4kMD@lucifer>
 <dd395d30-acf2-4467-8b30-cdf2532f585e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd395d30-acf2-4467-8b30-cdf2532f585e@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 757yomkq6naffrwcnabufjg8xa14tc4w
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8AF5040002
X-HE-Tag: 1782404303-21615
X-HE-Meta: U2FsdGVkX19+Mvnt+/jQMsJUAKZloMhJ9/W4uBuvC/y3+7yovB3wrYKVySz0z7/AXRQ8IVf3eJWGEhiicbQbUjorhKm2hbnA0yYrN+aRbZeOIGsV1x4Ey7Kk7KoWzdqC3jh8VXiC5HgkwcuVTaGSVQv63eje4vw4VAMWpQUFS9JRse1BnC54jSeYOYz1qsh4kcsRbIPKX7bqHOXhOW15yCyxsmpYVC46VxhEJawtCzRaSnXuvBwOb/jb74cNFT4GEsQ39ammLKPAvhJyWkdKTtPS/bhVjK4UJEclnNEROLOuO5iwb2G92KnsakWf9VgguFj9PDqY0YFTjcFqSXgZesjGuPWpt5s3jl0jpOtkLqXFJ1PUCicPIuybFKfQduGWVYifWS2vgbL5wQuoCiXHQOmGk4gUzTsNnDCyVIrN585cI2F5aqP+Log8PTwVHlOJIHUg8R5sIULyTR5dCbPiWvRhY7eskva18N+ZMTnvsXeoKeDMTQ89EEmOMW8W3j3P0OImBq8G0/HB+eJp1121NB9sGKmI34ewKXs+G4FKSyTqiKiRNqhF9/EDieZzLLhylfCvwP9gjVQsF/i4LfxEsk07GZPxJVVoWexSUxfVCvyldemxXTHQK1D3CCs9PyIpsMFRfMXbNFAMJcRACdmN1wj6NcEB9s5/arjR7LHgbC7RemAeVT9tI8eei7eni4ue3DXMwyo8uuoYt9JuycY6LTwRsnHCiC8/I32elurPMfgXkl19LY9EoN/7stmNXXSGUoTrzdBLXeGt6VWl3Cuc3CvUcL3Mwj6syhEY2htzviHbSOOyOHtTcUeX1SGo3SQbKBNWLq1gFhyYR2rvE/gEh6MKc93diRMARYxgY5MLRrrHJEf5FpiK5qG+C6JIlbwIZJ3zxZb/Hprfboit/jZtbBgXSYwZwcWRrhqosSJu4ysh9RuCqiOon4tekzeW76p8zeBmXzFLMxkdKUiE5jJ
 br/vy+l3
 22YkOlopqLHjAjmDqkH5qys21zFjZ0hCelAdySeHtfjSzQIoPMMlI0zEjDmQ0bl4rJnbxM3JOOudgM+JOQX+qEu4Tnf26sTiXiM47L7l71zkIAvEPao3DPtiqePS7dlK+GFFt4jJo+0XYPxTafcTU2PVGo5dCwVH9ysRZ0KawYb/xEPuU/xOp4XRkuYj+kr6Yo2hhEIOUl/Clrm7k5c6xsilZqMLShtVswMvKykWuMAYVp0gRN2wiOOt8LyvMV/hBBImx/5uyy3DqikeBNk+cO3pd6MbK0ulDCYYBuGTab7t3vqoAHipWfPWZc5BmIjl1UFH888pA7gBDtTdpew3cCgORS7kqHLKmlCeIF2+0lB4t2nbYUIqlc0gBG/olqTm/LgCLyPrN38XDBwgrNXXNd+skIA5aXs8NY1AX7RRJK7MxptHMd8GMVwRkW5Hz9+y+w9NPg6H8mRd9SyPy7bBKnI0EJxQVhMP4K2OUTTId8kxl2dSEuprdLQA/5z76V345GPx2yNZckg2ZhxNX9PcIVfALWRAKCS9SP1A19auuVJ+LR5MuV5AooGUgGJt+SDbqGeG1s4eVwagM8Vmeshrjqbm9A9pJK2FBRuWfeQTp10PMn9JHO+OkupmchQ6qxHwuJKasA3VGFmbR2lpAzXTtd6BHn3zxYOpKWIHa7SWuSJTYi7UCH/Dn1mq3gSLDz769zB4uHE1IZOaC6rDQEvOwDM2sK2h3ygE097mf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 04:30:33PM +0200, David Hildenbrand (Arm) wrote:
>On 6/25/26 16:02, Lorenzo Stoakes wrote:
>> On Thu, Jun 25, 2026 at 03:49:59PM +0200, David Hildenbrand (Arm) wrote:
>>> On 6/25/26 15:45, Lorenzo Stoakes wrote:
>>>>
>>>> Let me first say that I absolutely hate that we continue to support museum
>>>> piece architectures to the point that we have to make changes in core code
>>>> to accommodate them.
>>>
>>> I wonder why we shouldn't be able to trigger that on other archs with
>>> !CONFIG_TRANSPARENT_HUGEPAGE ?
>> 
>> I think this should just use CONFIG_PGTABLE_HAS_HUGE_LEAVES, since that's the
>> property that literally defines whether check_pmd() makes any sense.
>
>I stated earlier (when motivating a proper cleanup of this) that I detest
>pmd_trans_huge(). And yes, like I did in foliowalk, we should just check for
>IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) instead.
>
>Long story short: Wei's fix needs work, upstream is fine.
>

Ok, I didn't notice this is caused by my fix because pmd_trans_huge() == false
and check_pmd() skipped, but the newly add code doesn't. So I should merge this
with the pmd_is_device_private_entry() fix patch.

And should wrap it with CONFIG_PGTABLE_HAS_HUGE_LEAVES instead of
CONFIG_TRANSPARENT_HUGEPAGE.


But one more thing, I took a look into the robot test config and notice
ARCH_ENABLE_THP_MIGRATION is not defined either, which depends on
TRANSPARENT_HUGEPAGE (where pmd_trans_huge() depends). This means
pmd_is_device_private_entry() == false on this test environment.
And in theory it is false if TRANSPARENT_HUGEPAGE is not set.

So check_pmd() should be skipped too? Hope I am not too silly.

>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

