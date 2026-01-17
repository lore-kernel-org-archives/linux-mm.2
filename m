Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8650CA5FE7
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 23:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DAA76B0089; Sat, 17 Jan 2026 18:08:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E116B008A; Sat, 17 Jan 2026 18:08:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18AC16B008C; Sat, 17 Jan 2026 18:08:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 095B76B0089
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 18:08:20 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FCFC1AE7FA
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 23:08:19 +0000 (UTC)
X-FDA: 84342996318.05.0F18355
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id CC64A40005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 23:08:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mtWFrOyI;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768691298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DFWm2S+c8ymkzaWvDvvgfT+b2tyB8NQqNbP2dpBT00=;
	b=pTHGNqTR9AFEZtuRyU59Ltzo+AA9mEKiUz44VLi3E7hTKbAAZxUB0caxfCospNXXvxQfxA
	+0/rY1ljIfGbVsVGTvF87WwteI593H3nMJ2H8BJZSLF39zC/4bcC2uBZUHjUK/8DOzLA88
	Pwojko+LbaJQA6O2gvJNOfLpUQ2vTos=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mtWFrOyI;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768691298; a=rsa-sha256;
	cv=none;
	b=60B/JxOY/Qk9sWhJL0CcAxDNoW/y6niJiUeOijCYVCwMsQ/EEWtB6D8ot9sZ0mI5at9dGh
	CSkz5JxBg/8NeCB/h7H/72k6x0w2FnWx3kynTPUDuE8iWl+YEdsiVzyqOmF2ALtKbCj3wi
	kbYJzdY9JMvDUZ1He+WMRhHfPjPmJN0=
Date: Sat, 17 Jan 2026 15:08:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768691295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5DFWm2S+c8ymkzaWvDvvgfT+b2tyB8NQqNbP2dpBT00=;
	b=mtWFrOyIwlpVWe4P59H5gsd36MF3xE4tf+ECKFmq/FFoCaUdm0KbhTqLgGX8IHU1RFhaX4
	kWA7Cg8pZSY2FHefC4Y2ap/iVa32oQA4lcb3M8ZsSykrEnUJ+28JYhoExEp9fUAF5pjHdi
	e+JKOtcbMXpRe0uokGZb8OG7POHAuoo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 23/30] mm: do not open-code lruvec lock
Message-ID: <qmlnijwopkgvq27czg6qjc2umd4dwb5bufvb7q2zetn2pqiqmm@yhggvkcudtkf>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <33fef62fd821f669fcdc999e54c4035a4e91b47d.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33fef62fd821f669fcdc999e54c4035a4e91b47d.1768389889.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: a75uu4azbb89wgezktd5u5t5th4g8qnj
X-Rspamd-Queue-Id: CC64A40005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768691297-970572
X-HE-Meta: U2FsdGVkX19Os97OqwLMSrXMlU+tj3D0ojSW5lS7QR3NvhiCZB9wKKtGCs/25f0bbvCkS/jkbaGoOLRV1FtzmKp1l3wGob1GIRPbVpMPEs8C/YipAxy47gDEbapKfhCjGs8EsjVtp/sKJEWaY+ULcBmG6VR2wXITWD16Uq7PFlMe5mbB3a70ZX8Axxx+f5pea0qz8CwVf/HGbVqom9D0yrhMI+aT5I2/G1VAHHhoc8h+xgYU5AjxkcgvUb2EC2J64Gg2Be5ZWquBL00GirfvsNdP65sdUxz0vnIhYgiHfic6PL/rsKR+aZblVtTXDV9Vb1CiVvBnp/jdZ+HguR7tInF11XJXv3XlrGwpMLmurq3eAoUHbIyF47x3Q5EptbhNgRcZiNwVfmeLOPoEHkvjQ16OEPg8NEiYYxJl9mXqoRmXo8FQoGD8PEztTCG9sB6qfHV0zf19WgCuk0fGqG8x2KPnh4Do+pKHgHuFsxFh4yNtbPPSVb2eDdy3X0OIKKtb9KvEBHvyPKFdGccXcAFlQsrjx2/R4Bb9+2A+eojJTVveqaRcb8NBPFglAsprFCXCRey+sS5xA5dgTB54ewlDc3q5z1OgYCT1P4Ih4KeOAswSYZZ6I8U4qbYFLk7c20LWol1g5hmcZheRzcBzA/eFo7jiwEmkNCeYy7TkXWiVRCkpf4d9VeoBG6BcpfL/PXidZVXy6783YKaqkJ4mLNaa5BEUeIUPGCy7y2iBNMsgJwP2tjAhzDZLLpeII3OKW7sGejJ2QLzCBnxDWEm7IYNd3Jn3ltfUk82jxUhMeWlAjksp7zpKn+zWAVZ9daHB+LSHqXM2HhHNmqxaw1PRoMLLVXjObjcj5tfzY2c2o/tE0SOyL6ORj4GMexaWyjE+mfqG502vhvs3v4hcz146VoJFfD29bx1l7eXglYfyBRjLGSfaMJj9AhSHkwSRCTMJqBihlSRacSOfm2NONocOD2u
 866t6fra
 4JwCaxpwMUf1CagswY2Tm5/xUWqMY8bMKuRBYAmqwTuoxpAhMser3yx7EKrwU+Wv8K/6NKPDexRC7dydLDdXZKJZfMZRMuVMwcwzxI56BS3rxKT4GlV4+kRUg6oDEdcFs5XctOuBt1rnVCA3oyhHhCJvD3B47+LJWeFoDSWQ0wscwV/WlacA+d4RycXa/6IjIgZyUzGwbJvtDYxdBCaW1UxySS74Eznyi9GTzAdRMPQ0dezf1nOm8iuhaTGwY9MCAKrfN4JDojvLFtBk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:32:50PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Now we have lruvec_unlock(), lruvec_unlock_irq() and
> lruvec_unlock_irqrestore(), but not the paired lruvec_lock(),
> lruvec_lock_irq() and lruvec_lock_irqsave().
> 
> There is currently no use case for lruvec_lock_irqsave(), so only
> introduce lruvec_lock() and lruvec_lock_irq(), and change all open-code
> places to use these helper function. This looks cleaner and prepares for
> reparenting LRU pages, preventing user from missing RCU lock calls due to
> open-code lruvec lock.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

