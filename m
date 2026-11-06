Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8461E606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 06:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bvPJUts0
Received: by kanga.kvack.org (Postfix)
	id 851486B05B8; Fri,  6 Nov 2026 01:13:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8287C6B05B9; Fri,  6 Nov 2026 01:13:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7655A6B05BA; Fri,  6 Nov 2026 01:13:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 566D86B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:13:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D41C3120C7F
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:13:18 +0000 (UTC)
X-FDA: 85403676876.17.15C021E
Received: from mta0.migadu.com (out-89.mta0.migadu.com [91.218.175.89])
	by imf28.hostedemail.com (Postfix) with ESMTP id D3D5EC0004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:13:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bvPJUts0;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793945597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UeFRryLaJVqpKuXcRGUVHxdnIHbny7uLg2c6R3dh+AA=;
	b=cCaePVRosuZtglUeW4vExRSAqmH+ihfctUSwXxQiIcHsSkbha4eOGDL/4q7pUZESA7t2WT
	DXsbEKBJWs+McP5Cmq4W5pY+5atD03gVECwWuLCFe5DERwggcJ3LiEe2h3xnMldD75MTz9
	exBYj7JtbkYYLZOXLY9uUIUPbwhuk2E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793945597;
	b=wvsz7Q7mlNg0gcB4iNxkUu67wsaNtKNKeBZeUFAnDF9HCuUSTeozqaMs9NYqZG5xMUoCge
	IMYR9a0VpXM2SbfNACZNX6w8CI/+vZpR5I7hhWpXuU4D+xJBAYNgX/CxFQ4X/HZf7edQzX
	Kvg9P4l0gdqBkJyyz3b7RG9kMBh+37w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bvPJUts0;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UtMR0huybFZzo68zuG5r3t/yLCzKnw9Q4ZZ92vgROyE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793945583; v=1; x=1794550383;
 b=bvPJUts0NfHUKQVK2bHna3jm1DTJS6OWUm5OJ5OLiijya+d6Vfg8vLaYBXApL2GOXiidk85N
 dP/RwNh/+nLcYXh2IEvX2bbeESfUaQVPaZ79T7zXLqfJ1a6I9Wp+4Y/yIp8ubSq0waJlyLf55yu
 jrfU62V+HSgFBkLFlkNckuxA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ff19274c30c44807;
	Fri, 06 Nov 2026 06:13:03 +0000
X-Mizu-Trace-ID: ff19274c30c44807
X-Migadu-Flow: FLOW_OUT
Message-ID: <d035a565-aa50-4aba-8213-f39869baad05@linux.dev>
Date: Fri, 6 Nov 2026 14:12:56 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: hugetlb: fix GFP mask propagation to CMA
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 akpm@linux-foundation.org, azpijr@gmail.com, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <ac2de9b321f68c1025333e92e3ce94beadcb0b6c.1793850539.git.zhengqi.arch@bytedance.com>
 <auxTwrKCeg7a3hfY@localhost.localdomain>
 <1535887c-6be2-4415-b54e-2008e6e7a35c@linux.dev>
 <au1qtSMDpimURGuq@localhost.localdomain>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <au1qtSMDpimURGuq@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: afq53wspyta4kpwchhig1wabsxr43xfh
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D3D5EC0004
X-Rspam-User: 
X-HE-Tag: 1793945595-489459
X-HE-Meta: U2FsdGVkX19y0/HXwvk/UQD8LSvc1cICKkJXMEqn7s7dQAMq+QAKwxuDlD2Vw7q2n1sYRW93jaGtby/Q5KAGgsG1p+u4ZcYW/ylfPMSmgqSCiSvcOO5/2sXtL4xeYQbgrZuG/s22F/wAKr7GrnYTI92jrisl7VNgPpcMHHHdwynSvkpSAE8AYC/Q7snFUA5ZbuAGic+uUhHxH/T72b1UK1H5cox3DrWGWmHNdZtVG+Mp0OUfiM4+2H1MJJpiTJhRZgr0lXyoa60afJST072saIzvqoqSvjPaEQCgIgRQdaCnraslWnZXyG7yQWjmHYMuopWCeIRxAnS2/w5zLOpQY6+Nx7FdrBf/TDKNo2b524MXwJdKbKIKh1i0ayZKhAMXd1HTCpUuHRxOZ34S1qw2BbIg3BweaXw+eJ7BHZlzqN6e3/liiRJdzJMQR5Ucec8dIKDjV1voHggpMemS+K9fVXfFRP+QuihEt1uzGZ7BvVm+6tUHuSIWb6H67cFI1mz8jYr+Ba6SL883X8m5vgP7ilem+ZFItc1J84oVRNyirGTe9zjk0gIPTlHRWulv7BCCU2+qxKw092CXjfVJ8kt/alwwHPvsbpqvefa2gTTsAEFWbLPTHg/eM3KxczfaLyDO7wrFaWYOyORgZw7b/Ee4eI32Cr9wFex4JgAdYz/fqAyOJ03bF4d1VlOARrSP54roVIu/BGPdDaGfcpJQruhh5Zj/SpDRTZz70zsGl74GJFhl5Vr1j7D9ilZDidNG0Ht26+Elq28S/sHR/Cj1aZcgiXtSLq4+INJ+VOfVy1hv1nClDKWOD3rXgBC7OtNa8wRBgyErkAbgXfOQFJ9gvXvFT7EaYmyqsZKx32SAeAhlCDO5b4xLIbhyFFlpz3PjDVRvC8MDM1L/XZFNykzmbzKnYSmhk3OMEMvXfQRGOVrnt7awRRQOvllPahDW+9Zr0Zv3kZaywnpHMeadReQLbEZ
 yTcJUKlO
 31emOKNbUCbzpaplpb1+RvAQjP0Y2jdXjbY0Xo+cnqvwC0TFs9ShaJKpBXKGRsodbji6K7sKoBSJzGBi7t7pzLqQ6d6xHe8L0GCKTEZcGeLxnYh5gEIQNy2VBDJUUOBE4JQS4upeZO9McXUFDNQbf0+sMMGP1iTNJNY8MXcTw4gxD/u3Xb3APTgZfV/rlHZxaR6dcJPxVJGhDePPytlsGCftzQIV8HBt782HWZnjsM5C+P7b3PPV2ltH4tTTF2d5ib3YvpGt5550kZAgarTDbbTGgwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 1:50 PM, Oscar Salvador (SUSE) wrote:
> On Fri, Nov 06, 2026 at 10:43:53AM +0800, Qi Zheng wrote:
>> I'd still prefer to keep __GFP_COMP so that
>> cma_alloc_frozen_compound() itself guarantees compound allocation,
>> without requiring callers to supply the flag.
> 
> Well, but aren't all callers hugetlb? And we already do supply __GFP_COMP there
> for evident reasons.
> And should that not be the case, and you want to catch someone who went rogue,
> I would just place a WARN_ON_ONCE to catch it here, so we know who is not following
> the rules.
> 
> Makes sense?

Ah, make sense.

How about this:

diff --git a/mm/cma.c b/mm/cma.c
index 876635a56180e..45017ed876f76 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -935,7 +935,8 @@ struct page *cma_alloc_frozen(struct cma *cma, 
unsigned long count,

  struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int 
order, gfp_t gfp)
  {
-       gfp |= __GFP_COMP | __GFP_NOWARN;
+       if (WARN_ON_ONCE(!(gfp & __GFP_COMP)))
+               return NULL;

         return __cma_alloc_frozen(cma, 1 << order, order, gfp);
  }

>   
> 


