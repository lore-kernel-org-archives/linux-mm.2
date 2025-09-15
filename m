Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBC8CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20D98E0002; Mon, 15 Sep 2025 09:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8928E0001; Mon, 15 Sep 2025 09:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B354F8E0002; Mon, 15 Sep 2025 09:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A16108E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:37:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2ACA911AAF3
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:37:23 +0000 (UTC)
X-FDA: 83891586366.28.530F257
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2EFCF40014
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:37:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cfir7iif;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757943441;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtFYoxGdDcXIaiYZyH9dsldkVPyzZXlYZDg4+wiTouA=;
	b=f4+WYerbd/nKga0NQaTtjTv/QgRQP43jL8bsFxFvaNkpiBdzRl4CMX81ojnvfRdqz8sZvJ
	FXTZ/ahkw2bIkEEC3UKLAMfD707LSM0BRoZDlPXkLrQkZfPVDdPHUL6aeX5HYn2e/Q2Vx3
	7V4bJMjhGgSv9LxjsG22LrrA4j84pio=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757943441; a=rsa-sha256;
	cv=none;
	b=MNWRdwDBIphXJJI0tebVd7xMTAoH+tpsEM/pYaBdtnlobSynJ2ih/Frub8bPZmVerOPd5T
	ff+eOW4hlsRO2N1zkWcbXN56jiOR+YzuJOWBCfHvfh5HuIve6Xer447JvDJMywJ7abzgJg
	nazUwUG+F9sK2UfMiX+4XuSLxQCUdXM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cfir7iif;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b0787fdb137so618652566b.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757943439; x=1758548239; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gtFYoxGdDcXIaiYZyH9dsldkVPyzZXlYZDg4+wiTouA=;
        b=Cfir7iifi6NRXY+aAU5u4ZoLP7xf3u0cM2Lenbz0cgX666rMjXHCE9hoTwsnmExwUw
         Cqi43ZVsNZDApiB/njF+cGP33I1ueB7cAzMs5Z9nMuf/z5MAurF6zxSBwsmPZF7mCiVt
         K7ZWtFEJa4zd09nKhaEQvSspZ0AFdYsMRHZAZ1puagdFCJDCA2Rq4WWThLOxupbNO7s2
         jJSZbuk68iCpBUB/JH5BEMI8Lc2e/R677x3AS2fl1TcyaaQP4stieT0z79YyZpYcXv+p
         a8jOSHieTmfBqMCwihM7CFBisg8ZqByPsl1wcjooL+GeloCDJiEN9BKDNBPZpWal7VHC
         KSEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943439; x=1758548239;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gtFYoxGdDcXIaiYZyH9dsldkVPyzZXlYZDg4+wiTouA=;
        b=RY0BWp/pcpD2YXi1Utertq5DclRhXD6KFECvHHStnPfnl7oX0cgt5nIrF2LOeMK6xF
         cvA2YsnD5XU2TnhD8N2UcLHb1SbcBIloHVuqtg9gnBY7Gl3iTepCjEI29Gl8lqHlM6hy
         Yk//vVQuwISORxk9TDBcjM6S1iHuZRISMvgaMvp9JT5smWf/65soEeZfUdWtu8+V5iIt
         OmtkTV6bKAc1zAIhgePscv3rnL+KTQmRrSvhHYaQRStsMPxAiL2V7xSjvy7ug5//AAyG
         7c9gBM5+75+eb39MO1cKXUpJeKeCbOwtarACE7uw3sb8g5mqO0DRklSiE2yOGc5/GqdI
         SKDA==
X-Forwarded-Encrypted: i=1; AJvYcCUsHpmnu5yPRnvpNT6lYFrPPU14WzqxAWe216i7ALHc4SEbVfqd2APz68zbj5R5gCX7CLXWzJURLA==@kvack.org
X-Gm-Message-State: AOJu0YxIfzP8wiPn5Fsg8YSK1efy/p+E0qA8yYJdqiGE6Ho6g1h3o4jO
	Gpo6+Cjv2tNBEDPdxvHwmybNFtws+o52DQBg4FcOXZInHb8bBHJ68lH3
X-Gm-Gg: ASbGnctJu2Oi2Qk6D5UYh0aBLL9bNpmBFzxB1jXRSxPNdP44RiSDHWn4YUvv06nA7ao
	8FcrXnmRbCRdNzSYkJenCMzF0yGN17VOoRuPu7kypYSDDvMZavCxXM/5MvMb3qUzjLmyAbIliQ1
	l6Cp2ep2Nv33WqBiyNhSZRg7M0bNM+5KAxg+mvRmnH9gKYlC2yVBk8CMlUv1AOaShdj3ppqer2E
	/iHeegB5kMzREm9UHC2G0AsMAtw+taqnIxkcDq1FgkT6rb4hzBWl6pt5+qWbGCbtLG3x2g1gaRl
	yZmrPmifuWctrtyDmb/3cjTt+i0/IcDReQSSnvUUKKYDj+m4gT67DMYrMJvY89JJp2eLoJ4tKqz
	TRpuybT8Bn1tszDM2EUXfwL1QweY7r/lf
X-Google-Smtp-Source: AGHT+IHACClPuTT5CWjTQ1nt7SOLPMdGFD9g14tu+fV6Or8CS2bAR3+bkZttcusnq5xyQvU4hiyc6w==
X-Received: by 2002:a17:907:3fa1:b0:b04:5200:5ebe with SMTP id a640c23a62f3a-b07c396d4b9mr1390087966b.54.1757943439322;
        Mon, 15 Sep 2025 06:37:19 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07d09e5414sm629297266b.18.2025.09.15.06.37.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Sep 2025 06:37:18 -0700 (PDT)
Date: Mon, 15 Sep 2025 13:37:18 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
Message-ID: <20250915133718.tiw4i2kpbowaqbtf@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ncyl7ryvmvzz5ndycb322nxknyruyouzxgemzgqroopp6nkuho@dugqpe3ij4ad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ncyl7ryvmvzz5ndycb322nxknyruyouzxgemzgqroopp6nkuho@dugqpe3ij4ad>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2EFCF40014
X-Stat-Signature: bcptamrq8nwrsmhngk7x8tqh9sqwnhzz
X-Rspam-User: 
X-HE-Tag: 1757943440-685042
X-HE-Meta: U2FsdGVkX18Unq5ZuY+Z2f/T41u8vHPX+3lKoElUrGK6zoH6byGTfrF5uIk6PcXg+ryJk1+A+eTHw4fGF7S0TDJk7Cpb6zQzFPKUnp8oB87M+Ug6oyth9RogejPEIr1aV7C6s3RTwjeg+LDM4o9rjzYZ8ugajhViswSNmChRL4yivuDFihHzrHI1ZU2AnVVcEfMNJaOd8TqN6BA8Src55bocNRkU1mgcswxCf9aCRqXyCJm94ZtZb08oWQddFSMo6PMHGtNVC5bzbPgvGLjKffHujmId9EK9VhniTGHOxKCyhFLoR2OYopjg0LGIrY/gmgsPYKpOrEv4wMbL2o24ra/ZgybXCqpMeFcEjDX/hkpLO/knjlqldeU4XgyPZtS1ksCR9/eEPj52nPJtI7OQ+1xa8Frt+A+MbikX1KqzIi8JwudSOPG9/ERgk4C4313W72fpb5GVQPDHS4b4semnpu+3oifF20ebCQ9nUXpkxQ0ObDWecaewsWWRAcQ0SSqIXZ9+D7r32U2wbqVHBptbZOwq1Ez8714egVQw7WW5Jf1ICGDhKSwfxUyC0RNiHvwrmQrIoarKSpCBdFELwL4FYNpjuPfSQ2c1bpOsGKzBbtw2C3F2IioU9PBRQM/2ONjSXbDW34XdhhEN5Sqv4ccH8mQamoWGywVm+jc813DqSvzNenDz2RPSydanniVSmK5+cC81oS6TYDz3gD32muIcPkZhTAHRc7kwBlKK6ctiAafVy/rKLnYrZC6ZA/grAGNrYln3tDLK6UQvmHmg7V/Ut5IwdfngL9jchaJwEq0G/jLIxVIK5HTe/0hX0IbbmXngobf1GNEGWEkhUpQJtBdXSKPMFtjQvjhRcVOFA3bWSOXyH7sccdV4th8gHSlG9O4nAXSW1F91VMlaUSPINzB5SMhmJzBUa3p9Xu/J9umo15LmmDRe7pFxsK5br4VeFzl+Wx/kBW/dbk1BAG1qaWr
 H/yFV3V1
 CYWorZBggOukc47KxlUESvbwIrc7/lOu69to7KvsSu7vVgHA0rl/EA1dTwCkouZHYxpt9e4EmDWAMN7ayksa5bvqlNtEBTFPGjDvV2dhpYcqGw4jzXZOyI/0NAYVaMMOp/xxTol/hrO2iag5/C7tODn3FGyFP3YI+XFDH8AKZ7eP6M8otwoX+Bdug64vNKiQI3auaRNjC9OBCxgEIJYLduu+ijimx+U8AxX33R+1ZR/2pPrlb/A86duiIO0CyQdJtyEfHzAN1EAidfuqngpOnLxqRoVyohTvrpIQWson2jRFiIZXSpVQ4e/d195NV3MNQshVxuQfFgFMp6AG2Aj5g8oBE30bAnVGCsCqAsVcxN+kdEIwuV3ILNxYbr4cTT3pLRiJpdRgj6ALi3z6HO6s8RY/co1fLcKJDzY/VDuI9MCG8br07MzHD48zcB7etVXOcwaMtU5RMQDnSqCBEXJg19BYfbBKXa46l1NDqZoRCr+zdtOiknU2HTqtUyXqzUiyFFWhTXY9x5L9DfWNavrdLP7fQFG8CFRBfC1rqR+MKvHqNOS5DUUvXo+cYzMjE0xSwpPiNPNVFcQJLWCHjd8Sp49TW2PI59el+dMea6/8D0jaFp31VfoQ0s//qBsUC0+zStSFV0EC0F6vS588kmBIsSOvRG2awZj/5ynveP9YcOqpCfx0psqw7PEsdAxaiSYVJhusG9OjR2cuiprZdwD1XcUr930KkwaxBwz0qROCNH2mB9LipGj5lUq3JBy+ozaTXTcfnHkE4shVtWYLwp4mNjiI6MDdmrjMkztoAgP1phtZRYzpWNflz/OVyVLQjbqeKxxzK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 10:39:28AM +0100, Kiryl Shutsemau wrote:
>On Sun, Sep 14, 2025 at 12:00:26AM +0000, Wei Yang wrote:
>> When using mm_slot in ksm/khugepaged, there is code snip like:
>> 
>> 	slot = mm_slot_lookup(mm_slots_hash, mm);
>> 	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>> 	if (mm_slot && ..) {
>> 	}
>> 
>> This is only valid when mm_slot is the first element of its wrapper
>> structure, otherwise a NULL slot would converted to a mm_slot with
>> negative value. And current code thinks it is valid and continue.
>> 
>> Current code works since mm_slot is the first element, but make sure it
>> won't be disturbed.
>
>Seems excessive for this kind of problem.
>
>Why not check slot in mm_slot_entry?
>
>diff --git a/mm/mm_slot.h b/mm/mm_slot.h
>index 83f18ed1c4bd..0de24c490b62 100644
>--- a/mm/mm_slot.h
>+++ b/mm/mm_slot.h
>@@ -19,7 +19,7 @@ struct mm_slot {
> };
>
> #define mm_slot_entry(ptr, type, member) \
>-	container_of(ptr, type, member)
>+	(ptr ? container_of(ptr, type, member) : NULL)
>

Hmm... I  have thought about this. But not choose this one without some strong
reason.

I am fine with this too...

> static inline void *mm_slot_alloc(struct kmem_cache *cache)
> {
>-- 
>  Kiryl Shutsemau / Kirill A. Shutemov

-- 
Wei Yang
Help you, Help me

