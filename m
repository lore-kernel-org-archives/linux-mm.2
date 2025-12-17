Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E92C6D66BB2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 21:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425F76B0005; Wed, 17 Dec 2025 16:22:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A9196B0089; Wed, 17 Dec 2025 16:22:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28AA06B008A; Wed, 17 Dec 2025 16:22:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14C946B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:22:14 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC4041A0C35
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:22:13 +0000 (UTC)
X-FDA: 84230236146.25.0BFBE23
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 970D6100002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:22:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VJIExVUA;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766006531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOOgnzCzdNQgnsHYyEnitX5C1ZN2cK+8ABaNl5MoIv8=;
	b=yiwjyRZoNpYtWwMNIfYlip/RpqUvMJKU1uRYdZOkCo55NtjZ8XvmSajEMrqO5Rl9CPOQZg
	K+6oMK+9SPv8DHRps8CJZYwY4jBP+tBXC/hl4M+7klFaM9APNW8aQZ4JH427jocIgGPnBP
	TgAkTInermU6d4XFZn3o8lKzLizdXdg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766006531; a=rsa-sha256;
	cv=none;
	b=52VLF43v+I19tNZLsku0ullNOtvs45r2auVknVpsUS3Lx0umSkWTuZB6WfYyAVUcOgBnlI
	3KgoRJJnSJICrsQKTHXqVr4JeFKDktwcV7XHaU4akLKZdclydnOBXe5NCq/x8q+n4FAbR/
	bPkpJtthnGPWkRCVKF9ocPyu64I5uLI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VJIExVUA;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-88a347c424aso47788496d6.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766006530; x=1766611330; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bOOgnzCzdNQgnsHYyEnitX5C1ZN2cK+8ABaNl5MoIv8=;
        b=VJIExVUAeGiDNeTx+lhJsVU1Pyq+Mf+vA96y1K2rfKpri5X/QMnSSQCxZmbjmulGyR
         1KxdzTDstfxw+wrWwUypGFlFX7Uv6gQaLOKspiNs/fquhQ87lb0+oEj0qWswHcWsavP7
         IKZgNkxDjv/zIU+sxhVD6KKsEq18WO8qvdCl2Z86mnGiIY3ywm3MCy8BMOj2tEZhPfrq
         QAbpm4o8/ahYCp6cysi364UnGyAS6puy888XAQ8L5g7S50zq0VnyMn9vN7su6pppc0vo
         gzs6Oo8mgPopcoxoj7F6hdo4pSPyrTJZWJYhNTjpcvsFw5R8o8TTFhycC0ULct0vxhqa
         h5Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006530; x=1766611330;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOOgnzCzdNQgnsHYyEnitX5C1ZN2cK+8ABaNl5MoIv8=;
        b=wOOCsTT8jJNYTEnRkhCr42AxvTgwCku3d1BS/60t4Me5drtPvrgjh8GXKMqCgrT1wU
         97ZN0FKlePAaXpgGT52INcVZUTY4gDSnrMWvK0CwMfeKqyauRDcc/DQMQOjZYZ0t9yVZ
         1eiZARcnb5zvrfel1ylEsljlF9qtCDZqmliQVqfRnFL7sXL0ASmYSM/c1/JusLxuN2+r
         gxR1F5K/OFe5b0SgnuMJOnHRzNK11aMsx892LlEKwg5o1XaDHM9TF16HmXJg/scJnwsn
         yOde9JudQbL4RvVcCwMEfGBSqTBcZP442p9RM5w4tm+4/Xp/JrNyDWAG0TOwWw2AJn2Q
         plNg==
X-Forwarded-Encrypted: i=1; AJvYcCXTUvW+sZumoO7INF2RcoJ2dsfRsjz8/SlCJUYLsbS10EN+/rYBh1ixgbntHezNuv2jePkuCdybDQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8/+YP6J3pRHHQ5x7T2OITFL7qPEM3WLLMcctMMYVO8CxsbAJr
	SvrgB2DU7TocOdcYg++tPdyfaFoYIxDPo2KSyzZ6ZQZ6rA5PNEBruMFJNL5Gx+JmQw4=
X-Gm-Gg: AY/fxX6aexSqFTF4fjYxVDwjj+SpJ1M4DUFJPY+yQas/QrUJ8mQV6vjUUC5A5z7an3Z
	b4bibzz5zQH6t5p7k5JsfeDNIJGGiIGlm2z4doqKVxqI5SeILwujLbZchM4oTAjWQbC2tijUbUq
	9X0fLY2KJs+GJAQAmdKGymzRd/XJF4A96pGaAxtOPYMrwRIedc7xClF9HlvfLlleZApz9cj6ifV
	BuzI3w3VduOUt3J9mc45n3sGwUwHBMSfvf1LPTPD/ckjAJawhFQOVQF+9juI4PAtZwGfUKSqXfE
	xZ33/JDoSffCZH9NG8KMU4R1K1RjsU+S4VkwKMutai4PHKC+KOJUW/IUdthjM+8MEOk0l/KXhuY
	mhdfunbU31j7+BJ6Hkwl5FUMdIDX74qYUguhVh74imUGRDsQ+B63cIeGpL2G8SeJskIhEwiAPrz
	OSsVGIb1WE0g==
X-Google-Smtp-Source: AGHT+IFzXUkRHitQ6VNCbbPfCAE8rsPjnOnwE2wUVrJxtg3mT4weGRzR1Jq+HE4b4SUpjoKCvX7jUg==
X-Received: by 2002:ad4:5ba8:0:b0:888:4930:82aa with SMTP id 6a1803df08f44-8887e181613mr336351406d6.70.1766006530486;
        Wed, 17 Dec 2025 13:22:10 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c5dc70a93sm3699666d6.4.2025.12.17.13.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 13:22:09 -0800 (PST)
Date: Wed, 17 Dec 2025 16:22:08 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 06/28] mm: memcontrol: allocate object cgroup for
 non-kmem case
Message-ID: <aUMfALjD7Q1A3NU8@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <897be76398cb2027d08d1bcda05260ede54dc134.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <897be76398cb2027d08d1bcda05260ede54dc134.1765956025.git.zhengqi.arch@bytedance.com>
X-Stat-Signature: f6zu8rdwdohg893if618wafqk4hnc788
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 970D6100002
X-Rspam-User: 
X-HE-Tag: 1766006531-968880
X-HE-Meta: U2FsdGVkX188aWgAv2kR7FY/HI7uVWoGtGhZi+GUYC5T3dgq0Ss67QBF78/4/JJx/3csvrFGz9ACa8PJ0pB/REHJv3znp4PmzVY7UloUuT9YHOjZZ8WJvajPVDHsoBFamRMEDtZtxLsUUrkVBzSmL27BEg243zicwhtJYPrj2obYUiXRPGrn/kXaLElbgfeQgeaUht/bg+t1Y/LOL+xXHIX1QAf/qgojbhOvSJg1X4t/zj5c8ikzOm32rR61Aduewwj8jCFXZDX/RzvvB+xgTsfJh1A3LGzNt1zbX9nYWztkiUbhT2jP6amSzvd3Xj5x9o3mmAdgKpc88PlzPmND9XF+JMrqkZBBxW++oXalZEvzaKlULAdDqCvJWAnDoGypNWq3r7wKRuCKUkZPBbf23olMn6qwUqEjWrTlqZSDiBDFRKZa3GwLaVeU90oGBxe4X/QvkTZfkY/FvOey6kzb+dhm8VM2u+lm057ZOQ1LP4BpF2XZqt3f8J2UhejQ3/AYKjZojkeKhigH9bXAL47L6axArn2moX9aOq9maHbRcKvvWn4ESTUL9MI0e0xZTLt54nLjuS6uacBb5MrCyOUOgNnL6aC07F2jhcqdlLfKaQafcptFfiDxDlJYFYpYF74yJhj2Oj49oyUESLRaHxYRJuDpHlnx9B9LoIv/qLWKlpyiLg3yfLwBsegLO1fGL7dDHXELQWWpvRGdIXTBIxG72+CmugGovcsPkl0AxfjEr+AnYSiEBsHyjhvC4lj1u4sUF1Sxmys39vsFXDrFqmxGip3rMZiueBQ6tWiqRncI7MEM22NRlEqphRIT1q3ojpqIOVpuOI8TqnyDeJKeJwdy6zIHsGeVOH8O0aCp6iOr/2q5jYxDNFA4DPjQHNwWr1XzXv9mf0SoUi7ViuL+Odr7dq1BvkNnpbzH5z+VRui3I5Z39/k5JcPwZPyez8CZD5XGf2u7wL1ExZ5epeHOCYI
 CLIiIqOx
 lK2EtYX+WKxXFInXeoUgp9xaUxjjKwRScVfLZVeLJ0rDvCwueND6CVdcjtSzoXcoFQP+vLteteOizaQimVGGKED0Y5nQoa+IrJQfrCQv+OC7kBciE/8+duoEp+15puVI/gzBbRoojLvMeWRwgsiWnA91j8EKvc2Xl0caafC7jreWu+IDX8Rg4T81NNx4MI/z+vKwklAdCaGLbyYZ1zAfBwh1r1zBghomuQGhMVFPLV12Sag42QxNLqzLPmggLao1rw+5QqjO5ZfqO011j+fX0gcKO61SL+8Qa+kTYz1zitJ/iBfOs0NN0c72X/Ye6ujStqMGcT0JDpQdTY2+DPwQvSkivZvPQ5H9kFNqxdE3GrABEA/vyy8OsbZtnRhxA5wChYeGR0nl7GbzW9WqMGbv9Efnpz5DFT22q2gPAC66y2jh3G+bEmpLnWJdR+L5/hNa2Ak1fWwsohanA2lN81iWyRCMLzX/1qnUB+mQo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:30PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> Pagecache pages are charged at allocation time and hold a reference
> to the original memory cgroup until reclaimed. Depending on memory
> pressure, page sharing patterns between different cgroups and cgroup
> creation/destruction rates, many dying memory cgroups can be pinned
> by pagecache pages, reducing page reclaim efficiency and wasting
> memory. Converting LRU folios and most other raw memory cgroup pins
> to the object cgroup direction can fix this long-living problem.

Not a big deal, but since the coverletter will be preserved in git, I
don't think you need to repeat the full thesis.

> As a result, the objcg infrastructure is no longer solely applicable
> to the kmem case. In this patch, we extend the scope of the objcg
> infrastructure beyond the kmem case, enabling LRU folios to reuse
> it for folio charging purposes.

"To allow LRU page reparenting, the objcg infrastructure [...]"

> It should be noted that LRU folios are not accounted for at the root
> level, yet the folio->memcg_data points to the root_mem_cgroup. Hence,
> the folio->memcg_data of LRU folios always points to a valid pointer.
> However, the root_mem_cgroup does not possess an object cgroup.
> Therefore, we also allocate an object cgroup for the root_mem_cgroup.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Looks good to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

