Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 093A6CA600E
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1A936B0095; Thu,  8 Oct 2026 03:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCB056B0096; Thu,  8 Oct 2026 03:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9E86B0098; Thu,  8 Oct 2026 03:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2AC6B0095
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:30:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02CA81A049E
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:30:56 +0000 (UTC)
X-FDA: 85298637354.01.E52BA96
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4EB1CC0004
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:30:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YJqZMXjJ;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791444655;
	b=TCTe1BJQ0sGtGAQj4cdo+Lin2Hr6EBFxQRr5MIicht9KB20fxP8FIC52Lqgr7f1kCGCTh/
	SQdxMRPaaX4lPdktZj2xZndZFwvHlRrDT3cGLjyFOsI3nosSwa8yOgRq33pngSZnWHviSs
	/4OhQMGHJDpO+Np2UjTIJ3DlBEGN0mE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YJqZMXjJ;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791444655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0iL076pHUaLr+l14HbxfZqldd4j3905YwLicSMDih8=;
	b=CJLumAU8eJdJl1b5I4C9P7lW5gK+vPzHxORfeJUn9iZGP7Ehook+lr2ozjmu9c4Ob5JF5o
	twUuEYXb3zH4wBriNbdLKw43KGQGWcVj/Dw9KrPXPzPd55SF68SHSstIKezZqHnzwxQEAo
	VU3Eeq1UJzIPoA7JkCeIRv8fVIH0huk=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cbedd5aece4so175689a12.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 00:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791444654; x=1792049454; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n0iL076pHUaLr+l14HbxfZqldd4j3905YwLicSMDih8=;
        b=YJqZMXjJICrcCtocwTEfpYZ5U32JNuQzAS6QxWnzwF9PnDsbZ/CrtrmHmWpJqMmwWj
         zwzP3HjX2CsJicLTrQWew0/NQIfejBOYEdmIe8g7LhbxF46EO0B2TBwUQ1wyQ20nGq4Y
         rtpXlzL+nWcsNG1CTzCwkGb3osE4LM/GCEVdp7xWeZi/Bd8i5PwfWy4wEUgdPxna/OMB
         ACjE7kyjXdii+KsgTmvx94OTF3RdWoZdx6BfHxhbaxNuWXb0EO1I7vX8yt62AwWZrBHe
         IHsk975HUbLf0hJNQIdLJhnWgHod9wlWkT16wyql46y8ngHalgrX1n+wRZvUyGyZPuRZ
         psMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791444654; x=1792049454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n0iL076pHUaLr+l14HbxfZqldd4j3905YwLicSMDih8=;
        b=NUeXjWLPJvsTQoZrS8MU0jt3dAo04szsPkcS9Ddx/cw/zyCNJCt370uVIUyVJWVXNf
         m0CDbuWC/4cTaxzAUxdK2WsczXNS6Dlgh+B4Og5ij8G67qU0Kjp3/PuLVCIshvDfDPdT
         cyeSFzpu4rlHwiYHlykj4zkNBOdT4c3QDrpMHa5DjKkdoPTDFkvncc0rUbVh8gGoMOK4
         q5PRkCvgXy4KRVAlVn8vqw5RpjTogyS4X6VCDVtq8okHBeNKXb7o8iOIdf/mV/ro6wZW
         /v+AcjZvn75Y0vWf3eWFNbuhBt5LU7AOanp8nhxbeuQvoaFhqYZUZkGYm3RkDv1aUik+
         0IKQ==
X-Gm-Message-State: AFq9FYI49H2w16olT/PhizSgI7x0cXLj0ydKvxnH2i+GNPHEU2RF35VP
	laXta532F1qx815rS1WfAapvyLB7P9AFhx8aRhGoWOQiqBcWa7UtkIrvwV/QR4ofJQM=
X-Gm-Gg: AYBFou1poHw2wVkF7kuLTO0entoErtQnZB19hVF0I2xR0utV5aErDslI3YMes92Ol3q
	DtCAiqJ0J3sWQeTW4PfDfrc1GImh4Clsh0r+4G3fWuoxMSI9ysFkY8sWzvSbwdV/1SbwwgsLqaF
	PcrYLE8n9TRBE8V0t0SDGi+7U3QMjTHnl0HGYoDxkvHjk9rjUkloWRDwHNIirLqqcI5zaB+4exZ
	79Kdv9GEd/UTrxM5edneBdKEsoHs2idhORinalRoLYSPQokdtwA4Sf6ORn3w6i02QZ7/XpBFaPG
	OdDdOgEzaujdLr3ExdJV2crOTFuGokG0zTjkvGjet2hKs1moWepVlWmFA/nHpFXTRA/bL0PcnPH
	quTQXxYCk1XzbYdKP8QleBMrU9kIfL8271qOF01F6TDDb5Uz4zxGkjeIdIAQGDxBFkMfiXhO27P
	dtJe0sH9AfSZEQGFrJykhStd8sF1rUHTR8HAAD+9fI8NZ6sqwvTJNgbadStumafrNVHnIdfn5/h
	jueL9jntu/Re7oi2KhA
X-Received: by 2002:a17:90b:4a50:b0:39e:6c68:fd92 with SMTP id 98e67ed59e1d1-3aaed9a2992mr859363a91.39.1791444653999;
        Thu, 08 Oct 2026 00:30:53 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8a438f25dsm3114715a91.2.2026.10.08.00.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 00:30:53 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	stable@vger.kernel.org,
	david@kernel.org,
	osalvador@suse.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	linux-riscv@lists.infradead.org,
	agordeev@linux.ibm.com,
	kevin.brodsky@arm.com,
	bjorn@rivosinc.com,
	apopple@nvidia.com,
	linux-kernel@vger.kernel.org,
	muchun.song@linux.dev
Subject: [PATCH 3/4] riscv/mm: fix missing destructor for hotplug PUD tables
Date: Thu,  8 Oct 2026 15:30:20 +0800
Message-ID: <20261008073021.2512665-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261008073021.2512665-1-songmuchun@bytedance.com>
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pc1ds7chfqcmejhup4kdrf71irkzb5im
X-Rspamd-Queue-Id: 4EB1CC0004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791444655-698945
X-HE-Meta: U2FsdGVkX1+hOMa+HqPzfNHV8Otrr1ACHJe7enTWp3mEF6JtBBzuxKG8hfbgMxXDzgdWLqJ/zjbBLD5AKmSdnR6O8IJCbtyJXICPv3DXXG+8pXK6E8x0Mh72GiZMO6IoJ3chPmxHvEsF+/IB6feu7ajQt8W7tL38QhBCd6g0OriupW01SzTU1YJ+dF39+FQt/GqvrMK7DKF8wshF1hFhZ5/6gFlpCkQkZmZYspBNEcWYqtsfpB7ylwoSRrLkQ0Pg63FVkl1kABeRoAJUJ6IcoabNhQ8f1CMjXRmoEYVJGMohh0brNb1m5Cepou5VsiMh4XGJZHFJ+Omfw2EUpUSTdKvBsfORwC1z0cUrUk4mW/IbuFxVuA9UssXIbwIlwWRNXrnm+abwVGO8QZMy2VZQa/t60FZhDVka/ns+hggUU7HGgk2um+H1x9Uo2mGEQGDFUGPFjFjQ7DZEIEs6Mr6gElrDzjtLt0x9PtWTQHjgf8IHMSBWTwi2PG8t2wvpP2Z8jtWLs5rxy945YlcCYeg0Jfwa5HlZ4prS4xqvOyeclwLwb7br5fxkQPEf8fWQn/WxobifIDg4qgTL99u4OHOSPbT7zWuVDmi1X7iiqOmFsa9oJbiYzw3jq6fYTfvq821FTArp0YnASJ6nLycTPs5xwXT3sG/pFZgsBLHOKqA/b1Xq6nwS3yobW5WmBrqBrWduzZrwYobIsvBjk4jbzmx1qPqxd4RVHirMBQzhVjO7L7p5ruuvJPd22Eb372dbWqUmvGkx6NCDykvMwG2HEgAucIgzHgp7JDLMm4sjgeGR/xERS/UPrEzWuVIjwzq6D7gsboN+lHMlTKnBKRgCxTNF61uRiEcWU1BeGH/ZjJqQszvedXA8voEiMOi6Y1MgDKgjj14c4w0uyZYnRjwYuQeyiEywEZtzKt1z3yqTDijvYqtQIeYKw5e3UVEqUnb6R7Fuq5c5YcBTK0x90DaKVIh
 4MjYc38L
 a6lbPW2CiBYDh9D6cLBV1K0eUUoV0U4LVRrlWdgvVfVbBbnFlj5sg322HgBYKrRNEO/9BOw22AoFuqXe2AvOGoqCmMQVIzXJ0cegRi0kmsGNccnSeg+3B2ZVpJeuxoWsXLSh5yj2eNPvlOl9kOYOkct3ocIlSMP3FylBF5sIxiKb7l3AjXM4b+cZ77fvuAcEOnh+VL2mIjwzFbe0PhRw37zycruVBWjl8lcnbeJugnBCfY3kNOBBelna0qX4uC7gYd3gurWmw9/WBsStPp61Sq0EntzDmOqdwoa8rwDJJHhzbY7zzCKVDD8kr1986h6zHsRtn9pQvI3ecUb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel
pgtable alloc") made alloc_pud_late() run the PUD page-table constructor.
However, free_pud_table() still frees non-reserved PUD tables directly
without decrementing NR_PAGETABLE.

Free PUD tables through the common free_pagetable() helper so that
constructor-backed tables run the matching destructor before being
freed.

Fixes: 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel pgtable alloc")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/riscv/mm/init.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 429a0b015ec1..62077539ee78 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1540,10 +1540,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
 			return;
 	}
 
-	if (PageReserved(page))
-		free_reserved_page(page);
-	else
-		__free_pages(page, 0);
+	free_pagetable(page);
 	p4d_clear(p4d);
 }
 
-- 
2.54.0


