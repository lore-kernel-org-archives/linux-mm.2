Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C3C7606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LOkAMgFW
Received: by kanga.kvack.org (Postfix)
	id 41D606B05BF; Mon,  9 Nov 2026 13:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F506B05BE; Mon,  9 Nov 2026 13:25:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ABCC6B05C1; Mon,  9 Nov 2026 13:25:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF09D6B05BE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:25:53 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73FE116077A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:53 +0000 (UTC)
X-FDA: 85416409386.09.874D4FC
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf20.hostedemail.com (Postfix) with ESMTP id ABAE01C000D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LOkAMgFW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3LhDyagYKCHUekbsshZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3LhDyagYKCHUekbsshZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBXycfk6vA0iRzHtj3njzH1Lm9NHD4+ffX/6h9NPcU0=;
	b=yIbO9fPmaBJjzJkBljURHi7aCSK8tqG5X7bsjigHSfyZvCdNmlEWcq2Xv2X0NQB/0h9GB6
	8NWNqv0WBHRzgwADsMIPanIz0X0U2pn/8PaaouMwcVwTGBLyoErGRLkWFz77IneSJMtFuj
	nd56V7qCoUuFWLrikJpv2pe1UGTaVrE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LOkAMgFW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3LhDyagYKCHUekbsshZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3LhDyagYKCHUekbsshZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248751;
	b=s23Si744kAOMyqcuz9BIcdkbUczhGDLGASL3Q/SI5Na/AEnesjSdnWSqakEkUc8Ur1NR5A
	Zm5ATF8ZEdBGJNZRIzYQcotfJJCpy/UTxirLVNNpUyvHBlvDM0cHTNBFSDTUNyaGCMusVB
	QJtSCnzeQ3yfUva/9xCsfODmD3p2EGw=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c4163a5400eso121170066b.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248750; x=1794853550; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NBXycfk6vA0iRzHtj3njzH1Lm9NHD4+ffX/6h9NPcU0=;
        b=LOkAMgFWV+KUltACyVst2P+3RlfpvaBdwBMGmP2bqnio//qij8lPQo7q996VbFg3GR
         8DWd93aWuyUHq6DEw4G/JI/JSfloHaKToQVSHqJ10idxDM3wiPHI9oOIYhHj5HDpe2TH
         6m9/cQuS79QGhN1bvaYc6j5hALtaP6fvDtWEcmWxT8+tI1YbJ2Zml7cvWfsoKcrivb8x
         uAohBz0QQNTRruhhNiHnTHJ+Pzv2kQ7vachIrSbS1voKswYX1+QyhnCTtOx5xlY8+RJs
         LXpewLSJLC8HDBL25wh1RNUZisc/+tGNHdOk8tfPUXR+AHm41fdHzMsqvuGPlSsfTuSP
         AzUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248750; x=1794853550;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NBXycfk6vA0iRzHtj3njzH1Lm9NHD4+ffX/6h9NPcU0=;
        b=vbNeY28C2WJrWUtygS7ciO5yhHdjFxvvjXc0IKaGWLU/eDj+B91/w/Mtv0XWBjB5xs
         SxaPDryI4WhXQbljqfWzkopWTTTWevKfHhdNty/ItAkWtGlzrzWA9hY38zZCVodIAVD0
         2V7GPAqwXO66rSf3nbhvsCVeeTOTJcVezCQHm12O1zmbGkguRAksWPqGSXPpOhwXNI47
         51wqnphK7ahg/SdAz78BnXiB/Zezd0GHxnXGL7IM3xkTGF+Jv3/jwgtcodENLJ8mK8LW
         Pdu8jThBcl8CDcZpdvXdCpoR31KzUhRohBqsXYlTsCroIjDjHKhpuzZEFsIXVHlNc7wT
         QkSA==
X-Forwarded-Encrypted: i=1; AL+hErEC4rVfXtuTO2PPgaHpJry2bZcOSPtUTU3O2ytJ6GC++n5CgS2C5r1iLU/zqB+dzhGKZQDS5pOi9w==@kvack.org
X-Gm-Message-State: APuU4Z92IdkyzE3zUDJbsZFahJ2A1WK+DJOCwRee0RXm5kGubH1d1j+E
	s1TrZzR0DhzD8oSgVW0M3VuR7SS8sBYfdUf/3I1fjQw5z8vQynp2WgiQaWa/q9G7rvIVIwbOlO3
	xBtvxuw==
X-Received: from ejbgr9.prod.google.com ([2002:a17:906:e2c9:b0:c4d:4f51:fd3c])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:d54e:b0:c46:78af:6150
 with SMTP id a640c23a62f3a-c5047a434a2mr29783866b.2.1794248750196; Mon, 09
 Nov 2026 10:25:50 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:21 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-14-lrizzo@google.com>
Subject: [RFC PATCH v2 13/25] net/core: Use PISA for page_pool memory
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ABAE01C000D
X-Stat-Signature: r7iieosc919w5odbhu8shmjhc1e8bzjp
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794248751-364489
X-HE-Meta: U2FsdGVkX184Qrc8r4zNbNnPsy9nL5um9poIY7harWFXDBwuUQmP0Xm9pkvuOKarX845FCMragYCtqA6618LOiYpAtJCmpSwFKIkZu4Jpsp+om/vGNptha7Q1VXwTA/wlD5opQUWipdLK2HftHWwO1wgpDdUnQV14dCXiJz4e0expISARS2sgfNhgXT5wmt3pOJPZcoRiLdA2UA3GgfyzE2A/7voN2lXNjRdU8QBpdOaBMprDSwZvynRZB+WS0HCZbKgOKHOMj9OFgjkzxh1moP9J9voex1/CeTL92rH8GFLr9t1YcO2tswjE9yKIvdqzaBayrk/z8wZEVhM8RN0hsk1h4blfp1Vfy2BoIwNveTuZW29KQS3hat7ZUMUwcS3Es+7/X4a5LCG9ZUPSPV7Xr09f5VkyoTv87vNObFOFo/w5InKcryeUuLl0TfBb4JuSrTRwx+o0GPTR2Hklq3TZhpNJkUZWQsXYuIvHmd6Wj9ZIzbwuazUoUuDA2xijiGi/aSeYPZW5N2q6YRoMrlQAFLnl2wNhqyVRA1G8cd9oGEB59VfK44JFAFMHtlVrP5KnXQ2bb01YrsTYXWllH/F7JSP6wuGlIkN3Szmty1E9Ue5G/6lDpyMOH875/pPLRxGQWJw1/EEdTblg8wL4L6owuMHn2CnVFTplGEbuKudPMfnlMAoQIQfgVGYB1Xkp5G2M62M2U+rJ8EyETvOEpYDhAAxtMHpe7VbR1c1cXMt9afyG7zKGLSV0kXOywsuwOMTbKsdMXzMVoi7ZSexELgmEb/R7VHSCGSkV7WUN6TabKPJ30ndKgMNrcSo4EyVwkOAHqPby2xZ/GkN2R0Mhynkx/fKehSA7bY/sfJ69mI6jbZesgSKmHq2V6Qz9klR3iZrtfvuqhRE8fovbYMSX4zZO9rmhSSG7L/jEalDc2uxqpTO6LMnz04x7pRdOYmF/7Xdex7jgjNpRYyO102aZBq
 3N2BdtNu
 41igHKGa0GQHUOtT/eNrr1auLCmxE6dueiNJHW1m0bQkJIUDWBhP0Mi564C0UJ8nyH2aofIB2Kio0Xmd9su36lzsvGtlifAqa7jXeHqvYEV6bGqFaIW62ouHqUY94SDwIkWbROWUe4hFuIBMOwUCfFkhmhjW6I5VZUpLlCb1Ni97CsKIgMi0PQoHfQ+e/EZ2j8evtxrgZ8XlA/c62987eIQ9okkktGAl1Nh65+WaoxB2Zc4NEyQQIxli4M+plf2AkU5zW5Z7f237K+3F8G1DOxbesVd5BwE8xZfxGUadsFkpSYM/8+u78MgnsXlH1nrYJNANlwtkXQk1/Ap3PK43mKs9PSlDIIsx5egY6106inXvZJubk347bpehmKu8h92hw6T9MRkkJBbqkR7hygK5aIoJcWeGMjur6fITlfRs3yE2Lr3kqEzhSnZ0ZmVdk3+Np/UI1Yv2pswlh+oyzRTu1KF2sQKDuurGZ063NXbry231j2+O+mRNeGwS5PTZnjXjVEJUEY8bBhkO87pmMQMAT/vk0/QpIpv+enBeDu0keVPbGg4LlJfA/Jx5fiMlW0qacgjLCRFnxxE8QVOMuoU2wl9ZuTn6wGk3Xvt4WU9zdqYqRCiDBMde+0woX2h02cBdjKII58nKxZwArAc8AKO8kghCTrGUJ3ga3YzUBMoUH3j6Jzyon0gLovbljUPQf7QTsp/Cf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a page_pool performs DMA mapping (PP_FLAG_DMA_MAP) on a device with
pisa_rx_bufs enabled, pass __GFP_PISA_RW to use PISA memory.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 net/core/page_pool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index d7c88c0b67e53..91cae5ba78373 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -16,6 +16,7 @@
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
 #include <net/xdp.h>
+#include <linux/pisa.h>
 
 #include <linux/dma-direction.h>
 #include <linux/dma-mapping.h>
@@ -622,6 +623,8 @@ static noinline netmem_ref __page_pool_alloc_netmems_slow(struct page_pool *pool
 	 */
 	if ((gfp & GFP_ATOMIC) == GFP_ATOMIC)
 		gfp |= __GFP_NOWARN;
+	if (dma_map)
+		gfp |= pisa_rx_gfp(pool->p.dev);
 
 	/* Don't support bulk alloc for high-order pages */
 	if (unlikely(pp_order))
-- 
2.56.0.542.g3ef89b7020-goog


