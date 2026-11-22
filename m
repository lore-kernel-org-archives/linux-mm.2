Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F95B606A6B9
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nU2piSAo
Received: by kanga.kvack.org (Postfix)
	id 3CB9C6B05B5; Sun, 22 Nov 2026 13:45:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A30B6B05B6; Sun, 22 Nov 2026 13:45:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E086B05B7; Sun, 22 Nov 2026 13:45:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E64B36B05B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:01 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FC7C1C34EE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:01 +0000 (UTC)
X-FDA: 85463632002.01.8F30C39
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf03.hostedemail.com (Postfix) with ESMTP id A5A1520004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:44:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nU2piSAo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3KjgDawoKCAcq0ov1no0vunvvnsl.jvtspu14-ttr2hjr.vyn@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3KjgDawoKCAcq0ov1no0vunvvnsl.jvtspu14-ttr2hjr.vyn@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373099;
	b=fKseZ+8K03Nenrac9q6NoO4ISuBay1yTf3lD8Xl5VUu5O8ZikacuMKwWuRQTIZf2qdiIyl
	vBzsXQBOtH5fqNBHh1tzGR4bO2AsGT8m2BxQHD61sYWCZvM7eItJtgShiMJBH8JoIEVyjF
	MHBaLfRexWFxoGeJRoY5Is1Iyqn+knQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/BzRua6E4eXmgBBVosYCcmxsDMlITpi7UmbKmFzU4U=;
	b=qYOm/197VqvbKXLY82Y51H9ueCEXSmThf0rznREw9VfjXFoZmzXMqS8mnsF+cwYuuCihui
	FEsPGic5Z8hUG0wPbsSLuEu/NUpZNX6YPnJoad9yFnxcBpUo8WIywocXM0Y6aBow8Jr7eZ
	ZFf11+lTyq7DEK6KMw+5SbAvDoDP+Ec=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nU2piSAo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3KjgDawoKCAcq0ov1no0vunvvnsl.jvtspu14-ttr2hjr.vyn@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3KjgDawoKCAcq0ov1no0vunvvnsl.jvtspu14-ttr2hjr.vyn@flex--jthoughton.bounces.google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b456fee3b2so956776a91.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373098; x=1795977898; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a/BzRua6E4eXmgBBVosYCcmxsDMlITpi7UmbKmFzU4U=;
        b=nU2piSAorgd9z5OT7pcaeRYBRMbepYjP+n63T5QarLOO57ICe2JZOCEbySpTSB0Pkq
         d+K9I7lpNBnX/PnnD4Ly1ur/Z5aTLu831HnRwVWLWCBnHu/Gj+vVNQBlmbySmBiHXDjw
         JMoXXxwW1NecTaon2grd8pPEybaSofbQayCv+ttbUXocpsoj0L+gK+EZ2j9gQ9DdCr89
         6KbxKeaQOPG7sld56o8PKT8L7n2zvsRxq43Z/NvXwnNs/uoa4GM47DhzKtwCdOGb88Yz
         Sh2pd9MeFs0EXihLeG09imo2v1q3UsJx2oJp2c0mr83JiixOJXNc85U0S8y2zXrPtm/u
         RReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373098; x=1795977898;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a/BzRua6E4eXmgBBVosYCcmxsDMlITpi7UmbKmFzU4U=;
        b=OGzbAApi5CR7XohYAgVnUGA1+FUOgva6vTukbfnsNkTi8lyJD2HKYPUv5wi20TttVP
         kWcyFMgjqFOvqfKkBxqDhZQANVKKXrVSQbAbMc9dn/re+qK8fmMKc/di+CmBLe1Ma4xb
         ObItLAhBc6B03HZO5K92v0/eGWRzjqxpqsiXj8eP8Kca5CQLacCEbv2T66ncU//5K5sp
         DJm2sExJAHF94WEguLh2sdBWBnDGn6+Ed9iS0cRxxVhiTY+qjaF0RHrt0o2nm+g1MspZ
         ltbka5q3qylx/rZZvHGNHT/6QF+H60FpwRv9mtnzB3PxA43VbMVyxc4fnXM89kyIid1M
         YIcw==
X-Forwarded-Encrypted: i=1; AL+hErHYWW5oh+fRM/kZqE6d7pDTQYlR7U9TIGi0bvAyTCsz7Dd6x3SnfViVfgoeTsqrTAKU7unKQbE+dg==@kvack.org
X-Gm-Message-State: APuU4Z//Pqu1XTajxc6oLiR0YC99npOPFO17A0Tx6WsbCjGgxwfFtqra
	uG5DvYKT0HtTpCf03giIeOjmKdUDHvbYApewEjKFqWPRElCxM6mMSXrmy4/lIo+0q9YCmSWhhHh
	svieT4XtBZ6aSNnhPu5xtXw==
X-Received: from pjbgm11.prod.google.com ([2002:a17:90b:100b:b0:3b4:3d61:7517])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b:b0:3ac:d39d:ee4f with SMTP id 98e67ed59e1d1-3b41caecd51mr6521075a91.44.1795373098233;
 Sun, 22 Nov 2026 10:44:58 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:36 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-3-jthoughton@google.com>
Subject: [PATCH v3 02/19] hugetlb_vmemmap: Always flush TLB if needed upon PTE remapping
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A5A1520004
X-Stat-Signature: pimopxjd4irm4y3s9yxoh7wdxzzkrp3e
X-HE-Tag: 1795373099-509200
X-HE-Meta: U2FsdGVkX1/GTlpwxJk0ujte+PnmG8uf3/5E5ccmaykQjEbqOxX0FwYTlq1q6wOFVrdX1PDWyb6YuLx+S3fThup8eyWm/ybn5NFKOaDrV+ThBexcIEoQj+UST+YhdLAI3qVa55ef/ZTCBQvQyVDtWiPha0D8Rqzl3LJxaeXEAUR0mtOzm+fmxg9sG5xnrJzRSyoRJhlinhzgs5cJi30vXRmKVagdEKw0rWHsFLnwi9FCFpe0U8fgSZRlOTEmNvzbXJ02v2qvJeBb+NoMuIZrPQJyY/RBvJOmzGtIkOSdgzyR+Q+DfSz4E2AIr69U4kTpTiY7iXVelaXZ53+M26iTTDfsZPnOIBsVVSikspvlXeY0HAD/WZDrotnfmOvSuHmp8V7QsxF6k9xre0DUFMyMZkInzfNvOjFr1lb43oFe1ORTlvZqLwFttBF6MXQGD8mFJ0UrvdgCw4lprRzsLHfFBwGBHVrGsq6J2U0vXrx9krlK5u/SkjnFzv76gi/F96+cUsoUS6rir564C50IVpdHCzBJ4aF7KMBxMJlY5yJSJy4M/0xdS7XdJFbWVUWoGelJC+mP5dJCpjUukHMiu5UN7HVLtZoctiGDrHA4m+FcuBVlW2r3IkJlyjbm8P3qaUh3tscrVRiqkOPhLJgIRcHY/oIQM7+o54I3WD9BQD0I2zMiMgeGyXA+Nfp8cSgmkjBGdyMzplC1TBxV0Cycq1Rb369QcUUTDuP8kwBOANTxhf7YejU5tTD141+gX8n/GZAlpxoPOsa8hgy2AnYYR6U2IlE8xldMWPEEv+w/jkB8rwvDRBtrw++1KcqchHB2RlSlYABi/k0wztF2xo1Jjt0BeCTUKYzsGaWgBK7E0gyX8lDsBh8e7nc71n7Y43sOvREtAz9wyZYpbpQNmnvs9rxIwRzl2K2bdkq2FwBZ9sSXAbvHBxMUv3TSfJ7ck9l4AFdQ5KgFQs5qvQZaqrGQO8b
 x2SKcQ2i
 h8VZFcy93O4a5rHOmeaQ4hGHfj/+Wg4tfntEdg96WsHfP20sqdoD4w+lheq0Xx2bnLebZQY36xplofIeLgFu0xdMnPG/FU5Unf6tlZY3707sCllF6HNYzR+4meFdB8sJHLx9wL+D5Wy6nfyw9YmaIDrVICVzN5kBQ5y18omY16AkRsXLhcRZWLODexizuFmteQ2eC/ZegtkhkmNaEMQ+iTh82qtXeQYVx90xLuboPQfHm/uveGCjrWYiYq0puJkPygDCwjmmBBS8JcOsAIVBg+jVQD1UE5bt7+dBVtHBhBNopgRyEu7IjieJCkUfacSLkw/BpgLM6m56Zf/xePyxtV7UhbOyx/e6TZZNV38uvye0aaqE112Wu5sJIkmvtYJ2A+YY3jgJrjEwuCZooWGPnajO0QUMbLnUpHO/8ZPuK1pc0Fj/4vgO8MYsFDdSb09mI4gcEw1qRFrCXC+PAI0gVQ1RzFzZOTXoHET11KxtQUTpSKVbOtTG+4fJ8a6g2HRKzcO4GWt1GZSDCxUawc822DXV9rhwRxcqmOFF6/rf+2CDL643hpjQIoL7H/EWMO9ogQ8YKc3yAEvQnqeCKG+aSaPLAVdIYSO9g5OlHvNpNgzGmcJKIGMG/skV4kkKuQ4we2mF6yy3shRi0x2aH7J8P+xNLLRwhjgMRGq+no4SCeqTis+1afapjCOpopAHlue7pMaYuezCuJ8H0BKYDTid55mVMrMWKXZHsxHfMbJA5nvrvy6KcjCXtQrdYEe/TlhD8BHCDe7cpEyAJ905kl4HYOS5P4sWARP3ctirGUp70hNSFywe6mD1LqXiiRlet5GDtweaMWheC8AmSh08bcn92WyQWJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmemmap_remap_range() can potentially leave the vmemmap in a partially
optimized state. In this case, a TLB flush should be done if the walk
caller asked for it, even if the optimization was not fully applied.

A follow-up patch will more completely deal with partially-optimized
folios.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb_vmemmap.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 09b9fd83c198..7be08c68c2f1 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -163,13 +163,11 @@ static int vmemmap_remap_range(unsigned long start, unsigned long end,
 
 	ret = walk_kernel_page_table_range_lockless(start, end, &vmemmap_remap_ops,
 						    NULL, walk);
-	if (ret)
-		return ret;
 
 	if (walk->remap_pte && !(walk->flags & VMEMMAP_DEFER_TLB_FLUSH))
 		flush_tlb_kernel_range(start, end);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.56.1.809.ga0b61035b5-goog


