Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6C411088E52
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D88596B0379; Wed, 18 Mar 2026 18:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39676B037A; Wed, 18 Mar 2026 18:54:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27FA6B037B; Wed, 18 Mar 2026 18:54:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B175E6B0379
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:54:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64F2456A5A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:54:11 +0000 (UTC)
X-FDA: 84560688702.16.0BE9F93
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id 736AC80003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:54:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="HO/b9iBQ";
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773874449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m3C6OkbYPe6oQrXzYVsFhDRac3t3GyQCJ31s/cMP59Y=;
	b=PSQKyxjR9EyZVT/3M27UKSD0fGn3kSkjAbU9JflMs0vOjqM4VbSrPrsLp0ZtRkHaMVlNhF
	d/P0JgJfSfTB98Qkw7h9AMod4ADF2TvPea3NWvYazL5ABJ3EXiqhvnRXovZRlJQ5r4MJrc
	JHM8ykerEHPrmwrNexUrVHWay8TrMK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773874449; a=rsa-sha256;
	cv=none;
	b=upRIII4pcSiTptr7LYnr+2i5lkLxJxrx8BFxFnwP8sOeMuBrrkqJRa3b1APoQLvYoztjrN
	WfcvjGgMoq9poaiNMlS1WCroLvkkftVRNBryaURgeLW17pBtU3uSJoECfd4HDMsk0mI667
	e7h10lj0alc+p8hR18kVntzCe6URW/Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="HO/b9iBQ";
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-89a000f5adeso6996766d6.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773874448; x=1774479248; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m3C6OkbYPe6oQrXzYVsFhDRac3t3GyQCJ31s/cMP59Y=;
        b=HO/b9iBQNVmIbFqT+qyF1URsVR6jRUx528vcv0Lxk5ksEP4WXvUJ7WPj6qoluDCRN1
         8kApNkufGsZvw0jJIXRrH3JdrCtS7+xmgJp3P36IGFupx6O1NIM6ZxLxnIfNya2cvJWe
         QC8n4wgKqxPDOaGizmfg/TYsp01bAFiDLKvR4SDuDZJXLemfzc08+G8HG6FPt/lbdMbK
         QR6veStqM7cOHQsXuiBNBbbljs4+Z5igqXYS8ZBTJRd9zk4AiVkepHdOMFO6wEjoOXZn
         qvyIz0P1qKtTRaIr0jERmWgHcbbdiRHOi2G6nVCcD5P0wvRaG9BmJiyNUVkXwdYkZ2oA
         DXmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773874448; x=1774479248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m3C6OkbYPe6oQrXzYVsFhDRac3t3GyQCJ31s/cMP59Y=;
        b=HqSzAoz+Oi30KZZ8a5qtpZ+ifrmwvBfutQ1JW0i2t+A9vLjLBxbQwBaRLIW0cDyzKa
         ZzZ+RxfZD6gG7cNYX2psElVkTCtJoOS55O5uqDuEEltlvR7JZlte2AnikeII5DOk3vKx
         DqJdw6oyye6E56H9UAZ8GBYNaCnIwP1myqc+8w7DyKT/YqCBPLKofZpZj5V2Unt64QUO
         2FZvgOTQXrdSnX/TZWM5KEoBC52a6euOohoE/t/OQ3zv33gT5+1RKxzQcXWffSvar1wh
         hBfkaAiCnpBZ9QBa4OVREmDhavwhmcePiFwNCO7o30Eox4Bx/7HidMEdJyQzcXiWYE55
         MZ6A==
X-Forwarded-Encrypted: i=1; AJvYcCXdMPJ5nmJjGB8BiGTo3lvtbyDdb7K6JlWi5HQYgsKGX40M01UsGy1CKLYuLfDRqGMiSRTH0V2FTw==@kvack.org
X-Gm-Message-State: AOJu0YyjMUOLgsyXVzL++vo80ahK1aA3Ilt6AmebJUwPuHpphmO+Izls
	aY1olEYyKZ3Yk+HPgIjfuJ5yeLgsA67T0NeAryvatULpQhuxCforMLDuWoQ1ryeR+dY=
X-Gm-Gg: ATEYQzz5eEhOa3dJA/BPcFaTE3AF2Iw9piWu4nPwWUpCeenMINDc61CqMjyvN4eAoCD
	o+j/FAHweFHhsNEvNjZXe1GIpEIKnkyvjpTgJTtdudW9RwCvXCDa0vZqM5NIhrs+R2mBEg9Q6ll
	wKdnf/RB0VwE9UB8UO/l8yMi17mkMFUPlbNNOpTd5SqSM/HtN03UJJcf6aKnK8k8kPyd3Wxpzsj
	E3P5CNufdn3zH+87boacnl/B2Kf4ekuvtxDplsgOyPfYTXdyTYKsgVT+whG3MYJeEhLXPNEknO/
	I0OwsLt/B7lxstFJmUILl9fGhVWjrmDG6g5Hp6DrvEAugdYDtdMYZVASjMZpuNtUmaX6jAK8wSd
	N1WXy9ogZaOWTUaE5kClXplemUjNDU7ELq7nvm9Lo4ATYwwGjQnvfAr7Sbrkm2dUBkyGtexFefq
	AnFqpL70bOL2Lc44QwTAEMOw==
X-Received: by 2002:a05:6214:3308:b0:89a:443e:d43f with SMTP id 6a1803df08f44-89c6b56249cmr69999326d6.33.1773874448372;
        Wed, 18 Mar 2026 15:54:08 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c6b9ce2absm31068786d6.25.2026.03.18.15.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:54:07 -0700 (PDT)
Date: Wed, 18 Mar 2026 18:54:06 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Bing Jiao <bingjiao@google.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org,
	bhe@redhat.com, cgroups@vger.kernel.org, chrisl@kernel.org,
	david@kernel.org, joshua.hahnjy@gmail.com, kasong@tencent.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	mhocko@kernel.org, muchun.song@linux.dev, nphamcs@gmail.com,
	rientjes@google.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com,
	weixugc@google.com, yosry@kernel.org, youngjun.park@lge.com,
	yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v3] mm/memcontrol: fix reclaim_options leak in
 try_charge_memcg()
Message-ID: <abstDuof91T5Tojv@cmpxchg.org>
References: <20260318215629.2849052-1-bingjiao@google.com>
 <20260318221957.2979346-1-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318221957.2979346-1-bingjiao@google.com>
X-Stat-Signature: iz4tdyokij7688x5nbukkg7g3ez38hzz
X-Rspam-User: 
X-Rspamd-Queue-Id: 736AC80003
X-Rspamd-Server: rspam12
X-HE-Tag: 1773874449-871795
X-HE-Meta: U2FsdGVkX1+ORRqovaNezFI1eOL6kqikniN+RztnR/xEU66fL8haUSuloWg4QAKw3kXIRang0cgLjuHSNde1qCZX1IfD9lmU5dXfcF8+IBf0X18jl9JhcjJEzGmXsfvWSQtNMNNu4vNKxXhm3PVgz7WmiRkJG9wDXrgAUVgQsc0fYHeJHDtSidqHUz5a8nSblr0WERDL8v1ZOwJg/wQAFz1xCX8fDj+5/0/Yf1jUEHJHaA/PmpbBAh4U4Dlr2Zjr/p3kalVwoI0RiHKyiHQyryOBQ3SL1K+Y9qrRSSMuWXxN1+uVB+BgJHuLCZ7RyAussxp2RLuYRjct0ICZZDNbkfs+G6fYZrMuz3O/pGdcghk3u6je+q2pNpdUKJd4ByPk9w+mA/NqeN/LGdU6XceOKtYgbbvWLWTCVjqDvQRuiGIv6qZKJ8uQ2q7CwIQYKUNPijSGMBYE0mQwLYKNqIddjK8CdMIuHoR+jD8KQVbgKXmNaQQ/PYub7P2lfOz6dFg/QKsAVhbYobEdhQwye4delI8KF5M4+HQ0zBzq0OgRU8RV8fhg26DdqHeBdRkROrmU54z2vW7jgTcGYcRkQTLBKHyuDe4cf8BrW77i0UTZwIYc5vOxbxp7qQqWkadgAebsmiQgtKydcxdY8dTWJ3CFFVnCbJaDEGfnpDJ9nvs/GAQUeqhsSDWJGjJzMhr48C+pQSt3ywt02UaL/oR8Nzg6N8IOKhofGsBxTSgDGKhipLvFb35Y2hqScSpaZNmRjAT1TY6WoZ3ZHL5gmYnK+uutpIUZyG1FHwDPRR3p02IAsi5/GcXPFZ/+64erHEb5Ufc4PbVxtqFay1X61fle11ih2xwWxDVaDAOczCIDWg0xgTwsDpRzSY0X1kPphidfIGHXJTYzol4RoUYf9m7QrEurnHKUPBeFmy+GcjOo9grwwaazA+9zyAdpLXs3T06ZrTHXZdyuCnYaOm5JFmSMZ4e
 SunPg+tA
 ha6q0Rl28t0DaMH74Rlq3I5obRQekrr3gVUGC5QLH+HzHR9sSrmQ6F0NXwirlZVicDrX+2lnpjWehVe0XRGQvKY5CHH5hAGDmWBnntXiXPG2SZ+kyCJJkhf/cHyRLLa2eqAzlunn/oRA4OHNzdgUb0VEI6On3626bsLoW9hjeV4+5AFMQwp6UdJDOwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 10:19:46PM +0000, Bing Jiao wrote:
> In try_charge_memcg(), the 'reclaim_options' variable is initialized
> once at the start of the function. However, the function contains a
> retry loop. If reclaim_options were modified during an iteration
> (e.g., by encountering a memsw limit), the modified state would
> persist into subsequent retries.
> 
> This leads to incorrect reclaim behavior. Specifically,
> MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit
> is reached. After reclaimation attemps, a subsequent retry may
> successfully charge memcg->memsw but fail on the memcg->memory charge.
> In this case, swapping should be permitted, but the carried-over state
> prevents it.
> 
> Fix by moving the initialization of 'reclaim_options' inside the
> retry loop, ensuring a clean state for every reclaim attempt.
> 
> Fixes: 6539cc053869 ("mm: memcontrol: fold mem_cgroup_do_charge()")
> Signed-off-by: Bing Jiao <bingjiao@google.com>
> Reviewed-by: Yosry Ahmed <yosry@kernel.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

