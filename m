Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E814C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:43:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7CF46B00CD; Mon, 17 Aug 2026 08:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2D186B00CF; Mon, 17 Aug 2026 08:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF5226B00CE; Mon, 17 Aug 2026 08:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A84FF6B00CC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:43:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 22D641C1880
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:10 +0000 (UTC)
X-FDA: 85110726540.13.F746CAA
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 56B78100009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lgm6NCuO;
	spf=pass (imf05.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786970588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gAEJlNZVcNXMblqkUJuiyVruC7lTjyCbl+Qw91/T4Y=;
	b=UseRRZecqAZ8t1YpL2bRe6k1b1vRC56FqCOSlBPXbDGAUwhNU6V6otsdyxFds9o3tIHiT5
	Cl4loUHVMRzCjLPW1gwybQ65cVsj1Y5yi+7FU1wJHVuSIPKbKBcSRdsgy2BaPHxXbE2JGL
	JL3wvrrprFWWnUCM6jcEFpxpYmx0ZSM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786970588;
	b=CfMf7NwrO3+IGVGRjmwEXu3w63enstI/Ni9jffV3dscDXSQhQ+A7NCzawkbV4oOQ+nmAXq
	hdGW/6+eYiU2ehZR0vnMbGh1c37klf4ZFYaEW0vc1vcaN9+RO1Ijqi9Xsd5eqpRy9r6LRu
	BsaQdwFO1D3NXbwNN0dMxSr1POwcpDo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lgm6NCuO;
	spf=pass (imf05.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c1c26d7e951so518798666b.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786970587; x=1787575387; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9gAEJlNZVcNXMblqkUJuiyVruC7lTjyCbl+Qw91/T4Y=;
        b=lgm6NCuOAr1sgGsP2s1PyQaiSJErkGBUn2FHfILlTagApQYIfGifatXFYRssNN7/Yw
         sV6Dny8S5t7TRxC1s2uE3MjQF90YJAsRVL3ke3WhuWWFmJ4jOZylnAOj9WeMuAQ9sY5d
         npP2whb3BkC/7cFuHs4XSERIfhLH2+FukR2kxar4RQ4ANbMaNj0X5fDnd/Nq8ZuB28/b
         KrtfxECFm4rLq4Z5qYNxCvZX4Aol2OWi9e+oOQeDgcnJWrsAG+zEe1maMrgaRVqKx30e
         5qNF7hiQILiG9W4GJt2b9zrlbKASYL9uKZNq7ax/zrgGtUAVRm2PqQxfBvqyUBt2Gdy9
         KAog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786970587; x=1787575387;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9gAEJlNZVcNXMblqkUJuiyVruC7lTjyCbl+Qw91/T4Y=;
        b=eMOR17pZblKd82zObmF1tuj6o5mEb06d8OENOsYy01OoNdGmo7l14PvDc91EEbMOY0
         BNGY/M1QW2cpm27+5YQpqU/pJxNgaPwOrB8T1oyx8HMnjDfftZwnsLlBdYs4hOsahhb1
         W3YlU+/RcWGiZNA5DLfbzcdP5eKTC1sfjNXqeeTPRtzErUls+SRqJiqj7L9FgVXeouPM
         16sj6KVW2EMWQn2pRcS1aRL7V2lj7rgarLArcsPHo+lVkRTYbS0X9qylgBvhDNEoiuox
         /hs+RTpJGNuOu2telR5xE4KB7fsJ39DqVTbvJd/7MXNz/DQvHtWWNjs63a8U046I1g6a
         LRZA==
X-Gm-Message-State: AOJu0Yww3kVx4RQlgHDuM5wL7daTTNK1YvLr+G5YtayLlYyKLha6k0VC
	H29d9pq6ljoWSsAxw5X97c+SxiEv3DrEbbraggPTQHyKwqabt0YE4M1X
X-Gm-Gg: AR+sD12cqQBILOnS5tLGurBcdnFh5vy9ycGLdMDyBn+t7O8xt8da4JfIktVU/mwFHTD
	sOrpFvdoNl1pzHkTNYXrMWJ4r6gV4R7Um1jdrSH0XcDwywSa8Luu3UAiewgJNLSzX0Fz7647kH3
	L+aj1/xiHCJPaiRavbCMK/eMqjIjYX0wWYLZrX9mgJ+37wBgD6FCeCICBHu+8Uu43LC2ofO/aRq
	90e/UpyrEnj/8EtSRwhTvV7fLpN0J+yy4+1oNHgQBLgY/X2b/IE9h1vz/WJ/P5Uy+M2HX5QWmeq
	blPMuZEyaBb86E5F5f8ZDh/60GT/aG8RxXsC9oJNLqdW8C93bIzHQ2c7M5eYdcxOMnl+wHNo2Qv
	p5BcmTI8mVy1f8Uk5ncrc8+/lmfafdEVjZBoeg2ad7xa6/gnPwZslUdviRDZhaH1ryswxF46tJm
	4A1FAwyHkbPEo9pj+PG4dIraQ3CoUz+f3PSaumzu+WtyhPfIYykw==
X-Received: by 2002:a17:907:e1d1:10b0:c20:1bc5:6ff1 with SMTP id a640c23a62f3a-c212a18c668mr795218466b.5.1786970586864;
        Mon, 17 Aug 2026 05:43:06 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:3861:1e5a::306:a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c217feb99d4sm52626266b.22.2026.08.17.05.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:43:06 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Mon, 17 Aug 2026 13:42:48 +0100
Subject: [PATCH RFC 8/9] scripts/gdb: reject trie-backed stack depot
 handles
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-stackdepot-trie-v1-8-53870ca1651b@cloudflare.com>
References: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
In-Reply-To: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Stat-Signature: x49soyyf3xfq1zrpkp6zjmg8i3oeuo4i
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 56B78100009
X-HE-Tag: 1786970588-771583
X-HE-Meta: U2FsdGVkX19R1DxwoIsrRg2Iy7dASHFnTBz1o46JPwZteCSr/mrSn4/YF7H2fR5Qhoyx8MoROGq4iaWULylXBQMdH03HyohhQj0Rxea/nzqBMDg6gxPeNSXE6KNh4URQhgjQDowdL9RDnPAiwOKwVv17zjc3bpi9JzgLcDb+NfDa9EHeSZwJxL4D6anb5Le+b7flylzcMzGTW3jjQw0u0/9GoaBP5DHiYnM5/XHRJwKhLJbNe3YTcXgAF73hY4HqmC/wkSNttnUMSk1eDM9TVsgo8NjHSV9+Y/7iYHk+in5aTzWJ9SRb2biF02JxF6K2tPHsXeKe1vyzbB+ci2GvrrSc2+hK3U8N3xKrCzs4D2ubLLejfjrOkmjIyVXM84CJ9kvtEb1JRfKi//Nl1xec34OTvp907lkzoLezz3grmpsliKDSrxrDE7Xx+dQPsNRY2rWSry6tCD+mdPmJXr2JP9bcpCOYDFalytttxxON5DA0iD4UaonpcBXbFKrkZG81w4seat2RZE0woPUfIfaM56fbb8DANWwIvzXo6TibLtdt/DfIyULW2RvVmLgIaYZTsoITXXwql+bCyJyVMTc7zvefIMRRZuiX355CxlEfN8nStPOKTIc/hz1IiTKor4CGa2vaz2X011p+Dlzykx1prNm/U2cvcEH7dtzHjjcDr1hoSV4W/FfCt/XkgsK+DCAgSnz3idXODCu49jG4BxcCtoS6AHCwYldBhh66WGtY+PhSL1+HSF4E/hosDrLLldsbwbCV9NQ0cqwpIG+s9h7mqKKn8K7+wQW0MOQi41Sbspvc+qU8s2AFQqDAH1nVMHpIk3MpcCSq+KaErTYA5JuakAA5SUDIKdnwtkgY8Ol8fF74nfalsGXela8rJmGIGLea4BfDi2j+heJEbgfV2gFvV31oJ5Ae9kdGw7zJ6Lo4j6iNgrHYqz9w+1Hzg3jg7uffT/pcMwimDIZAbhStIzH
 o9LD68Vp
 t6RhQvZqseCJymQZ6aGcgfN2VrAsGKD454/gzkbkLWzowLabm0gJ/oaEA61hbZiSt8pNu1KciEV+VRuMmqwJTlNoEOQFiqxpeMS4+FlQnutzvkEgdMU4wLmufuHvOdpJyGvFjHKJVBPz4ntWftRkkbukWd4rRZAeURgEJFO2PA7KFbq3HS9I45IBCZVvD4R2QBbgggRg+B0P3cPi8VlkpUAX5Fz5QnO5iF+7WjMQI7xOaWrpYCGqndbXqGb7L5ncSJLNzQwWortwJRq90DgLF2KfbHl5MlvTgq6G4v6MLrgVcLeLbX6Y/oXUUdRjFO+KHLvPwnQfEFpilX7CKQD4Zg2r/1kZUDiK10QgxbnhePoY03AhEXnvYfiTT+7n4Ber8coNV+oYlJuUJ7xKTsKGcRObXn3YWAasMAFuf6XcUNUVVf+hv/dqn5I5WEhksiy+NH/s1ki/moiIpdLdHQ4BOKp7k2UPZGv1CgPT8Tq0VZ4ttslbgSlDzgLIrvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

The lx-stack_depot_lookup command can materialize stacks only from
contiguous hash-backed records. Trie-backed handles instead encode a dense
stack ID in pool_index_plus_1 and offset, so treating them as hash handles
misreports a valid handle as an out-of-bounds pool index.

Reject pool_index_plus_1 values above stack_max_pools before the hash pool
lookup and report that trie-backed handles are unsupported. Supporting them
would require side-table and parent-link traversal in the helper, which is
left for future work.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 scripts/gdb/linux/stackdepot.py | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/gdb/linux/stackdepot.py b/scripts/gdb/linux/stackdepot.py
index 37313a5a51a0..82aeb9f532c3 100644
--- a/scripts/gdb/linux/stackdepot.py
+++ b/scripts/gdb/linux/stackdepot.py
@@ -37,6 +37,10 @@ def stack_depot_fetch(handle):
     if handle == 0:
         raise gdb.GdbError("handle is 0\n")
 
+    stack_max_pools = gdb.parse_and_eval('stack_max_pools')
+    if parts['pool_index_plus_1'] > stack_max_pools:
+        raise gdb.GdbError("trie-backed stack depot handles are not supported\n")
+
     pool_index = parts['pool_index_plus_1'] - 1
     if pool_index >= pools_num:
         gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (parts['pool_index'], pools_num, handle))

-- 
Git-155)


