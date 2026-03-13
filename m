Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4CEE106FD6D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 03:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09AA96B0088; Thu, 12 Mar 2026 23:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048516B0089; Thu, 12 Mar 2026 23:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96C46B008A; Thu, 12 Mar 2026 23:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5ECD6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:39:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7135316071B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:39:50 +0000 (UTC)
X-FDA: 84539635740.18.91E0F38
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 84372C0002
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:39:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EgIIL+Az;
	spf=pass (imf28.hostedemail.com: domain of seven.yi.lee@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=seven.yi.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773373188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+INjjQWlNJIxV6k0ZvQsdBiZDFnv72NM4m8hFvOy0+Y=;
	b=i5kVmce03gDRCHl0IAwMMzYMET9eUMPoI6eFQdyLfBcGBuPtsPKpf43ZWdD3YC733InE+W
	cJnV8aG4FLtQPnU+bsyYsaCgaykcAEyBSEJHqPEz8NeL3ha86lhAMBDvVv9q6FnIUORRVu
	UIGrcE/Q3crO1qByvFPAAfrknq46HF4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773373188; a=rsa-sha256;
	cv=none;
	b=SCWE2VDHV7QZmJFItV8uQRRxuW2sad6GmbvBrDQUBMfFwRVxJD/tV73KejUuaDv0L8jIz/
	mQ9nAvQfdoT2mGSMssNUg7f3eNwpF5N1vBTXic6USTsLgva4qiPzI5TUaHBTmnfEZhliC5
	TpDZ0zaim8pmeglQtWNOSRDYT1HsCXc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EgIIL+Az;
	spf=pass (imf28.hostedemail.com: domain of seven.yi.lee@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=seven.yi.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-358d80f60ccso1110736a91.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773373187; x=1773977987; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+INjjQWlNJIxV6k0ZvQsdBiZDFnv72NM4m8hFvOy0+Y=;
        b=EgIIL+AzMJ4Y4e+1vlTUZkF2XhmeV23PdpsDImw/vQbdyC6qdcgFXKHxZsK3Rz7CXW
         gRTK4iB3QY+CFUXDxXypruEhkmZ7ZtuC9qeNi6B2XSUDyXKR70MIMy7sf8y8tNffirRZ
         phMhGBidFd2zldqgUkeIZpWA9JS9BPkP48Sj+39Fb/eTGI8YVG5selpu3WQERVAf2yWl
         wyBBNEdwoxl4ObG8woA2JiOsaooNG21ow8WgB1IpzmNCF6dPrqw2SPTDl5BQtxE0M00B
         MC1DGRVX6XWBPldg6bARMX75kTp2omhm9FEhsNMu73K21Om8Df5hUZNKqQ6a3Qiz6F95
         mqhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773373187; x=1773977987;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+INjjQWlNJIxV6k0ZvQsdBiZDFnv72NM4m8hFvOy0+Y=;
        b=NEsNLuiilID0ftP+0eIWVUCYxg/bgDMXsRqYdPNHy/UoUKs9MIHLWxkOcpjm0fUNJz
         TiNI6GGCIw7penMs4Ws+IRfvMWrnoKEmAYnZzdolEvMEoXO/Tq6pKERHThutOE1Mrx7V
         GySPU8QW1+5locSzNJDFKm+vw9wXIJUhk7MgBtS2vii/pc30vLK2zp+FgcjcrVRXA/R5
         rS/zXPQjoMEnf/YB6IMA6y8BiWesksOStWO2zpvBvDkD3OwIErgBUtcDYdZLsb5EsWk0
         4B2+365TgoekMC4+xp4oyiulVzrfGBAICmxV6rISiJR0k7TWbgFLjhDbZ9PmSthFIAEL
         h4/w==
X-Forwarded-Encrypted: i=1; AJvYcCWJ/lVtu8vmRe0ByTU33BAnWkcREtvqWAeGy/03xHajwlOEMpJxlGaJ2aXWE//wPU7eIK/ooGpbIQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5bn5RyIoWydSIW3mL/WvaBSIHRiaBcWX7GUxdQh8uSQA0vVsU
	3VSYF7jgEJTnFMBX3qmj8iFVUNip+xEGlrZEBmNbKYmowq87COFd1w+3H/Sm2QBrJK4=
X-Gm-Gg: ATEYQzxDdDrjXE0hC2XGigFa4iGlQPCvmyH9Jhqw1BNa7KrKW9FMVUHzXfhFkLT131u
	IV64P6PO7UBLUh1mHW64FzrdSc7F93X655HKZ0u9rOxTBdZKutGSGrdsbe4eJkMDrbTtakjpZFG
	+s1vTs1qqvXuogf7EZ1yUIy+JrZDo3fx6kkbdy79lhjytCIiYK5dYkXprNlPZWU111KTtMNtnOE
	ZCl40lDHoVl9dORO3Kxckgq7X/doiYrX57Plw49m8SUn2AXeLwbv8Xd5EA7qkuxeAl7V4gyRp0W
	yHCCPx25K6UOuGq00ugRtBr7X77SN2MiWo83Ws88TjtVjSq5OOIUFGKma03N3lfnABQBCCBnZN4
	QtsoUFj/T3RI7sJzazxACTcn8vXHYtJ/VPLqPC1JRBzNI6JeMiNNfj8vnxOkhIzYGydsxR98reK
	f6+6QbvYBo+BL/KKAO/as32ef4FnRkpA2b9xBmYOBpWctxVE1GGuuijV7bMicc9OujUl3/FA5nU
	cc=
X-Received: by 2002:a17:90b:2d83:b0:34c:fe7e:84fe with SMTP id 98e67ed59e1d1-35a22053498mr1562896a91.28.1773373187283;
        Thu, 12 Mar 2026 20:39:47 -0700 (PDT)
Received: from [192.168.123.240] (n058152075021.netvigator.com. [58.152.75.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a02fc9454sm7295623a91.12.2026.03.12.20.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 20:39:46 -0700 (PDT)
Message-ID: <06535c30-ce87-43b2-9670-53e56ca04c3c@gmail.com>
Date: Fri, 13 Mar 2026 11:39:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempolicy: add sysfs interface to override NUMA node
 bandwidth
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, dan.j.williams@intel.com,
 ying.huang@linux.alibaba.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com,
 linux-cxl@vger.kernel.org, dave.jiang@intel.com, gourry@gourry.next
References: <20260312150022.1373486-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: Yee Li <seven.yi.lee@gmail.com>
In-Reply-To: <20260312150022.1373486-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 84372C0002
X-Stat-Signature: f68gik77goiwm8rcmy57qn6bxb1wzreq
X-HE-Tag: 1773373188-99540
X-HE-Meta: U2FsdGVkX1+CwKtYxcKa1me+1rV6k5kn1Ruml5RwgAft3X5NKqc2IayIZFr1qpGuX2ybPNeiL0tibEO/VEKQrUJ/RrQfWdLuuJpPONHdnIHmArvD+tnWDt5GVZb71/J0BMHyYTEE64pXFKHh81aON3wgAx6gsRMNTR5uZQmjMSSxyS0q+6dx/zW+v/4GRLO2CCbh3h9vvmUyeO5Oxo0GEJ8AFjNUl//A6hUhj6cYBveY7gVMVV5vk7GDVaSeRupC9HRJupk14rTEnHJAd06w/6M7cP9ww11XJoTjAidsjrfd3Z2j8isf+ZVuzgaksxwGmWdKH6u/LfRFv8ljRz7t8+VyYmyG51Aq2kVIHdjSnO9XedW4MLUtiKDhenubZciC/MA1vK4nprnyUxkVNZvOWQI1rvnabs8cEqsRBAKxaNeVk4En9LRRsZ9IJQrY9cSBEA7Ey65XZ9pMxL3QCZlO/Nb+xzCvzF/dNm31AWvDg6KlcmuGH064SbPj/ZoxKOGog7QPlkSeK9vlhTAK+UibI8YlZ6IYUeiXvKvuvHPrpmxVoxEfOwXYccvPiUzcrB19YcVqoSINLijJufyCO5DfYxbAcIo+a5+WYJotbZ+8Bk7p8kbyKuCVn0zL87JWCceHk789krYYJkgA3TcZeI0lA4QsFa4N9PXC5hL7gESu7G9zniSXSRAv7GZw5varfXEfrpEqWny/nwGGfil86utUTFF2nb6v2qGUw+mRf32nkIP5nWnW9qaY6LZa7ipaoR1Onu0QwTgGdDiHXDCiP2pdpyrgVqCDVeNubsbZkJcfoPt98vhIuLbx2yTe7D8cg6U2gXnH73YVW1yTU7O3IsCHkwW3MEcvTxgUUSRX9Ar/KASdWSDfkq7uZbuBx8TfmY7A/FFQhOEKnKbPAmxc01qmJ/9SDMFo1Gs87s13LJDSft4YGOKfD0rexA/vvyKuw3MUE2flxMENISlZu4MuUpQ
 il2lF2DY
 JHTmKjKRDlSyQ3P4RTcND8f2uqMGRvp8CBOJh27ly8qSKjNPvJ4JflFEXExQOUv0ay4m5EJunNFrVq0d/Yx6+ePBJYTSzY7wv/OsdzIdNfTUruf6krOUe38FSHU5GvD/OP+U1oq49nFKx85AyU4X7hyzAS0ggOHeH/JO9mQlQAf4G70nvzpT2i8891etbIxHpvECJqznNHiFIfn93Hf7AaHKDXZn6vIfO/Mot2oN/ZacD8Lw4G3jrre/PLR6tEXk0RmEJMhUi0cAzxCvhBf1DK/9GLo2Q/I2bEzD6ebPR6vGclVGccYmWUYCHHW+lwaaaa2WRbeZCwBEtHDeRI8P3zyIyQQ2XfI2N8b6iTvDuf8RLZyLr7AInlUkOFiYjLumeAyFZECpg1VN6XXh5pVOvcnMIMDoQFOYoP9uNEpY7Ymli/MZDvs/m/F98UEHsiaL8KHLKZjEs3LjjWAvuedv/YCXNz25zIF5mFbRBqHQkSgPvPoWBQLVvcDZYVgLglAdkD+fUkNg9Lrvj3A6I2EgWZJbMo9sjxFG+TOUvlGurKi0qEJlBOLPLrm5k/psxHjuhyyj4liszyUk6I2Um17Gl93lCQU4y61R24tjoAWAFAyDyhGezzw30euHN11q/wNfveKlB1C2SZrI5dJJcyOz+A7Ggi7AuNCOpcD4VhCEI3j2Y7QLWWICL4aygEr3alA0QLUT/kOeJ6o0J2djzYDX1V+QgMXhYxFNdB4J6HsJlrVofbDg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joshua,

Thanks for your feedback and kind wishes.

> I just wanted to touch on this. Is this true? Weighted interleave already
> exposes sysfs that lets the user set the weights they want. On one hand
> I think it would be helpful for there to be a tool to see what the
> effects of setting bandwidth information on a system could be, if it
> had other side effects. I'm not sure if there is a strong case to do this
> purely for weighted interleave auto-tuning, which already has a manual
> weight override and pretty simple calculations : -)

I agree — writing a small userspace tool to compute the weights based on
actual measured bandwidths (from mlc or stream) is a really good approach.

> Thank you for the helpful clarification. Just to be sure, are there
> other intended things that the user can test other than what weights
> weighted interleave would resolve to?

We can continue DRAM + CXL weighted interleave performance testing 
later, following Gregory Price's experiments [1].
[1] Link:
https://lore.kernel.org/linux-mm/20240103224209.2541-1-gregory.price@memverge.com/





