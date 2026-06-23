Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C683BCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807D76B0099; Tue, 23 Jun 2026 05:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792006B009B; Tue, 23 Jun 2026 05:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659456B009D; Tue, 23 Jun 2026 05:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 379D06B0099
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:26:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB1D98DE55
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:26:57 +0000 (UTC)
X-FDA: 84910648074.23.6C7A867
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id ABEB640006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:26:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kXtaEOig;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782206815;
	b=BMe46LIonu0/nPu59z7mpnc2en2016181DYEJ7eorYI+C6wt0XyCzF6MHAYc0l0HWPWPuO
	/wb/815w0WnvadjysMQj3wa0vPp97iTyipFTl7fLvxuDctvmvjWlmxxDabwg+3YpiH537M
	NlN1QhGagc1vmJCERFvHebWymTSG5BA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782206815;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=146EtFmKSDOqcPj5EAiJ9QFejXPyW+L70xzWfx2hDtE=;
	b=vGhRS+hw6vCW8ElmVEV1GwokLsDaLwb1waoe9atcELoVixKtuDqIh47D1uqu2hvGsuCVYo
	yy17HQIesHYA5QVuswUtua5z9dloELxCDnkoVpwXj/em/Au1MSHEZ/0AxiDdEbuIDWeYc9
	EQQdOuF8gXmfEsVQJU0YkVUrnQoXtdM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kXtaEOig;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8df9393e4d5so31322756d6.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782206815; x=1782811615; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=146EtFmKSDOqcPj5EAiJ9QFejXPyW+L70xzWfx2hDtE=;
        b=kXtaEOigLaN1SA0DRHZarDwdBIj7i6rVbDEPcDfCNUAnZKa1EgHksay+4CiBwo71+E
         KuZIhxmpw9xWf1E+Hp4+bL0Oz9qMCryYhJHsd59AT98a8TcMEENGHwMz2V5rPODUwTA3
         wlYDrNjhiTajgRN9eDOtGlJ2/uTHmiUD+vQQXo6Fm4sKaFr075zWjRGgvPDFsdUa8jOg
         yOslBiR3qODGXx+bmsYDfMTY741wcxQeymUP8xKvHiQKkdG0pLeDK8GJyMOoEEfqGj/T
         UbWdUh+4Xr6XoXuPITJwyC5y9we4+caPDgVyIJ8lVVADsEEl96SCKeZCiA2DtM3IXq10
         Zotw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782206815; x=1782811615;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=146EtFmKSDOqcPj5EAiJ9QFejXPyW+L70xzWfx2hDtE=;
        b=j/9Tk5i3p2UyEgs7Z8KkFhoJd7oLxvvw+oo6LFJaRjpygPEN+lMGz/WKTBMiR552/2
         LK9B6pEtcU92b7ad3Z1ArwY1hZQz5M4AiQ8lMsmVvSkAmvnkPHtfBWy1xtI4fVMMrmuX
         Y5QfxKahx1fDyDOWA4XazEGHekJNVhtX801c9RwbzTcQNeQ0fwoiWKqPKZytRQi68axs
         UnP3jBD+nB0foz9id4fdDQuxCThNVbPOJUBiJfISr9p41DYjPYz8byXVloJVEfJFgPZc
         6I6yll4vRLFjjpmiKGtcNBM0OYtypDXilzz8ntmBubGVgLCr0U/5fuhi33sfspHNN9u7
         TtCA==
X-Forwarded-Encrypted: i=1; AHgh+RqsRxnMAJyr7az9Z3jfJMa21/uG2bmn2rbJnguxjXHfgoTOnfJFYSGO5gBgKxW1dX4A7+Qg07ROlg==@kvack.org
X-Gm-Message-State: AOJu0YwWaGwr/9UXzBQG34GRS4DTQLiFz4Hj29ow0O/02LqasxGfgQQL
	YGpgs2dmE8+rsaUPPbKrGvXP8T3vPeTz0sEokrZ7cgM2y4Av+chMaJiOrEYiTQ==
X-Gm-Gg: AfdE7ckEfFV4TTclwlOW6KTRB+Jz04dPR+yj5f4jwmRSu4LwEx7qfXtuVFKe0KRC8Vy
	P+BLbpLOTbjO3EOImVzp7ziHldaYWd4CvI27FdDZEXkr2kGxSkV2LGKEqTGTlR7SIa4CUpEj4Kn
	nNFDDMH8j03SzfttQQYjVbmW/AfgnCaISLf7xkoL8D0zRmNi3IX+0DvGwPfy/AHcl8lFnuEFd+P
	f5H2kPXrEhQ7BVIL7YQB6ZEtzEdYcOabhCM1k4F2x4W0bhSUGQRKOEXShc1KUOhCKGkgneaSqCR
	7Y5EXCGBRxxK6+FSw9rUuCcthOysA2U2Fxgh8iuVEAMQJKpmwkx0IzjJROdxyYTM4neqa8AlJc0
	DQm+H2szkTzcy4hQ+L1m67uPiHHHkB9jexa9LVca9GhBy5k/2vvEAI7WNZ+iMaDH1ALopm0q9wv
	iipUZSnRv80Fo=
X-Received: by 2002:a05:6214:29c6:b0:8dc:27c7:2497 with SMTP id 6a1803df08f44-8e400729fcdmr35088036d6.3.1782206814690;
        Tue, 23 Jun 2026 02:26:54 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df82c62eedsm123495956d6.47.2026.06.23.02.26.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jun 2026 02:26:54 -0700 (PDT)
Date: Tue, 23 Jun 2026 09:26:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	izumi.taku@jp.fujitsu.com, linux-mm@kvack.org,
	Yuan Liu <yuan1.liu@intel.com>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] mm/mm_init: fix incorrect node_spanned_pages
Message-ID: <20260623092653.yfahsc7kekuncbcf@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260622022403.16375-1-richard.weiyang@gmail.com>
 <ajk_l8cT0mIyhs4r@kernel.org>
 <20260623083507.kg7jmd7ofz3awqmq@master>
 <ajpQR0hX681OryCB@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajpQR0hX681OryCB@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 5c431airasb8t6hhxo8k196gph79wuxb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ABEB640006
X-HE-Tag: 1782206815-555124
X-HE-Meta: U2FsdGVkX18PI6RlVv/nKly77+Er4NdTIp4C78oZWjc+iLDJPsX/FhcUkGED88GfBq66FwqI9dF2kCpyotblKeiVDynE1kk1qu5813ITVJsJJPoJ2RFVheaO9t6FmyW1WocMsqAQ0lMoJPpGRdflECyZR4yqT1dOgM0OmecVG56zdyJR3a3oYxXLjnzq6rHAqzMzK3ZjWP2iArHyvgfNyM0gSMiQSl4Gio/p89RcEO1AHjfcdtPwU++tyWI+B/Jp7yrG+VdZIp+WN25burq2aQU65JH/FqgC5YyPa8592v7sUTm24ZrbctO23IwvImfsiMuliyPEFB+80OtNDY/qqo+bfN5Z+YIuZIJem9IoH7kNh7sv5gT45bkJCwAWKPK40P2bHrggT7wR+lwTDR5OGH6g+BoYJ2zOf4UpUhQNXtJi6OyfSUG/IVcmwS2Tkns1XRdY38XliEtOXHKLAljJUENQcZuyPmtHA1Z9UT7AMIPpzLGKadgcnV0YNEBO86HJjpiFGHkCXtXtd1P1WXVkQToEXSbJWxXWmqDUxqlPSZ59L4vthOLp5NAVX8yDdu9Hzqx2SQNYH4b6u/1ijgabUNyFgVwSIi0/CQZ24kdWGbpm6bB2qKUD3xIRRf0PMEs36fPkfrl0MkvtNfvmTjNe7Silq7wQhnY4IZOQCi8f+o/31kqBNJz/LsDgG9UC+QD2QxF6NtoQcBJ6iBLDL5VorFZg6hTLmhSvNPdr74tMtcuapWArZyS+E1Fv97/1lUaPoyStI60XIeWDjPsx/Olny03rHkr+5Avxg4AEu1fF1yvyyKXShJS0kWdebkHa6ej9lOVvkQQL255UYNzbzen7jGl+mWIxyjAWAxxov/esSuQF7u6B+lZJZhQHd4KhhCA8n6cMhMhcUl6XkCDd2G/yQQnBW8XmYGLVHuD5Z9rlzDlHBBhZDdal8UftOnIe7I5fOIK7YQ7UgTvv+mOoYCf
 mOKyJ6Q9
 Se1IIiqW65Y09i+sd5YmuYLhcZtIak0vGcPpNLLnDkMx0Ojf3c3xEYh8bUHrLc+aMCSdnnM8DieOKyxQPxO5GYn7BuHyhGY3D/h8qeb3jBOjJ7DuEpJ4Tt+L1EHrHH/weMFUAeg/vs60GbLXt0Rx9eHxePIXgOqvf3NNMioo5FguoUkrW73i91h5V7zBoVCBIKMEIi9c/U01cxU91wgnVxx2bHuCrXLJZ4egILu8gjsGX1r47cXHGVZp6N6MqwQpvEPnuc8XoqZK9WiCgFL6xqo+Zw51vQxkIhRyZ2Bi6WGy8vhdMwTDQDe305pdk5+soWdXJyJ3bApzG7b6GYFKV03c/S00p/ddIfaZDjmKLVuMfDIMxwppSQg/w2jplQ34P5i+LGIEqkA7207FtmFjzdyvzFZbu7a8D7hI01fkoCQz1DMYMbNdI5NjF51dIByDX77O3W3zi3fYY0pxWr/Dj3xI9Jt1nEfR+sbz7DYU9FA3ULQYd8dlhMjm//TctOk0Z3DO5Hx3/a7am0DnYqU0xyVbtq8C4I2oq/chXMepOLpgPcxGiKpjadnmtRQoWx4WisxM2eEUWGYA9Y059B3Xic/4GF6dP13fxXMtdh7BLp2ilD4BKx0mpAJLRG8JukkEAKtZUqpo5rKdSAwVN0Sm6TMnzXCF4Rnbk04IREiMCsh6jz7zFwSJlS0GWDo+shGDIDAGp6XhXQaZqzRrJkhTIxSNXJRMByWPqgNHLQg17VE877epq3PCJ/pH4hGUTaZlA/NgUMn53wFe57GjMBXu3K6FhrKQ8picZ8+I5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 12:22:15PM +0300, Mike Rapoport wrote:
>Hi Wei,
>
>On Tue, Jun 23, 2026 at 08:35:07AM +0000, Wei Yang wrote:
>> On Mon, Jun 22, 2026 at 04:58:47PM +0300, Mike Rapoport wrote:
>> >On Mon, Jun 22, 2026 at 02:24:03AM +0000, Wei Yang wrote:
>> >> Current node_spanned_pages is got as a summation of all zone's spanned page
>> >> in calculate_node_totalpages(). Generally this is good, but if we use
>> >> kernelcore=mirror, it is would be wrong.
>> >>
>> >> As we already passed in node_start_pfn and node_end_pfn, fix this by get it
>> >> from (node_start_pfn - node_end_pfn) directly.
>> >> 
>> >> Fixes: 342332e6a925 ("mm/page_alloc.c: introduce kernelcore=mirror option")
>> >> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> >> Cc: Yuan Liu <yuan1.liu@intel.com>
>> >
>> >I queued it for now, will push to one of memblock branches after merge
>> >window closes.
>> >
>> 
>> After some investigation, I found current mirrored_kernelcore may still affect
>> memmap_init() in some aspects.
>> 
>> But how to fix is not sure, will prepare an RFC for discussion.
>
>After I applied your patch, I did some checks to see why
>mirrored_kernelcore causes us troubles. I found that unlike other variants
>of kernelcore/movablecore settings, mirrored_kernelcore creates zone
>overlap for no apparent reason. I did some git archaeology and I didn't
>find a justification for making overlapping pages absent in ZONE_NORMAL.
>
>So I came up with this cleanup:
>
>https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kernelcore-mirror
>
>I'm waiting for the bots to chew on it before positing the patches.
> 

Ah, just the same as I do :-).

>> -- 
>> Wei Yang
>> Help you, Help me
>
>-- 
>Sincerely yours,
>Mike.

-- 
Wei Yang
Help you, Help me

