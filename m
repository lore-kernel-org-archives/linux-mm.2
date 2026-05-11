Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62CD6CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD1AD6B00DC; Mon, 11 May 2026 05:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C82AE6B00DD; Mon, 11 May 2026 05:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71F76B00DE; Mon, 11 May 2026 05:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A58D96B00DC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:02:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D90BC23A7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:39 +0000 (UTC)
X-FDA: 84754548438.21.24A339A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 220B91C0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LhUUdbXU;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4kzhpMcne9QL/iUfytpcOnuwyhDfw3DKjMmXnNjefM=;
	b=WWl90lgKsZvVsQZIxxPx7J3fXxyv4tqXU1vZ+eJhjHIidkBt/3oMSyN/jy96mrmbbi1PRM
	BlNnGrv28usIzN7TL3v1HmJQMfalZ5VfMsS32Vz6K5oDlsYwegKVBBCiew5+X71wEBMXmU
	yez5fQfVFVGVgWSie+pu0GIVPV2kDcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490157; a=rsa-sha256;
	cv=none;
	b=Wa6vC2If1Ueak8NXaR/9Sg0TE+pbdc/ia3q1beHHAY4klPA391UXyMsuo+Ev9VfhP6pZPC
	NtqIP06hVnoaW7GLpknk1xUT6EQs0l9ixzDO/BO+BD42aMGcVs+hOSMMcFMrStGe1EaiTw
	B0Tx0MNYZM8/WmIcxOlvYtZEPGchtRY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LhUUdbXU;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+4kzhpMcne9QL/iUfytpcOnuwyhDfw3DKjMmXnNjefM=;
	b=LhUUdbXU5rLV8LcGjKMJ7r6KcdK7v0VpU8kl2gujOLfEBw1QcpFZdU6JKHVXp4MytvGz30
	+y5eg9IbWLKL9LXyBi6mjJwCJ6W1WtJLqPjv/iGnJ12xGqKZgn2ppJxahTHKMc6w/iweU7
	iGCkJvSUZhFRT6AySbmuZVbnoaDdzwE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-ETb5RPyvPV-MvdYjRwWEiQ-1; Mon, 11 May 2026 05:02:35 -0400
X-MC-Unique: ETb5RPyvPV-MvdYjRwWEiQ-1
X-Mimecast-MFC-AGG-ID: ETb5RPyvPV-MvdYjRwWEiQ_1778490154
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48e60b55de2so35339965e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:02:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490154; x=1779094954;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+4kzhpMcne9QL/iUfytpcOnuwyhDfw3DKjMmXnNjefM=;
        b=VXpS7iQAvdIWeXReaDKZKY589CMhkyBBPURVXtw9f1XtJKxGfd1ORWR8CUGrd14JR7
         9V3218FJfEQuzZt03wvIFNjizyApK7uMXuwz+hOYHoo1WEtI/N3YFRjwoyrrC7F1SZIm
         6ywh9kgQpy3G1S/n+3ODXYFFIw0xeop8vEx2IXGHBNZ5cTpeppo1jBSTECNGdNIfG+QF
         PlMzCaxXmTi/R8TGRK7z/35cWXqVX+lU46Zx6kFC7KfSuAdwSlpdP6sa0ixDcBZug0Me
         HfZURnrj6XEnwa/B62C0Zv2zEto/LhMiD1VkqB2QsqP6axOHNdbmlWhwgd3WVN5K1f0G
         FtjQ==
X-Forwarded-Encrypted: i=1; AFNElJ+8Fm/uCisa5EAWWXGhO+jX7vx4rK/iDRPfpB1/vABPLPYu8qsZzgROgKrNzGNAkVHmnHObUbdy8g==@kvack.org
X-Gm-Message-State: AOJu0YyxjlCQyNK9N8A1C/u7pt9TuKlFeddEWVZ4eWp9vlcJcpXxGqi5
	09xlT3wW1cc/DBpDQegpZZA65Uqv/9LRArHoutkv43SbOtD5kfO2yLPJ0rmU1uh09tk0q8FUJxx
	zkSC1vI059c+BCNCUpn0lTGnS2A/CMzBfMDxAfpgsXiuf/9OBMWnO
X-Gm-Gg: Acq92OFer5PE2rb9RTc7h42VktOKP6OBZJNSEkJm2d33ELyhjs9cpkmrsdQzMQg+Oua
	fePBYy1CntlY5PEBTxIVSnBLrUgxjy5RsVtMBxZdxUlFfuaEqD4rVC9g5WwGE9cqPb5L6A+C29W
	gJdMhmMN2x5osxn8X3/NB5Ei/Z89AzDeeZQYj9PD4D9S1euMZ9Op/DsPIC1cu24ZXWlBaeGaiId
	TzVn1D9Pktj0wADokBAx5JOXJe7PZFw8wdrwGpHkV60PCaBpS1/NzG/StCaNNl1JYFOweActMSU
	1iTuqmK1P9zkjIkA0UBnFxqvxvrSK++txPplNjomWTIGYlpUjWwIQO38Nd1LKRXoqdIqCktYujt
	xf1tthmjVXr5FoutCgYhJ0xNhONm8p+JG2IhCelP3
X-Received: by 2002:a05:600c:1d18:b0:48a:906b:14ca with SMTP id 5b1f17b1804b1-48e51f46e46mr365112445e9.20.1778490153212;
        Mon, 11 May 2026 02:02:33 -0700 (PDT)
X-Received: by 2002:a05:600c:1d18:b0:48a:906b:14ca with SMTP id 5b1f17b1804b1-48e51f46e46mr365111235e9.20.1778490152468;
        Mon, 11 May 2026 02:02:32 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e7040a9a9sm297049045e9.9.2026.05.11.02.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:02:32 -0700 (PDT)
Date: Mon, 11 May 2026 05:02:25 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-alpha@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, linux-s390@vger.kernel.org
Subject: [PATCH resend v6 08/30] mm: remove arch
 vma_alloc_zeroed_movable_folio overrides
Message-ID: <24a1b25f4f1cf31fc5bc053e475958ed5e1bf8bd.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ygSgs2ETLfbEc_6L3f6VnG7nUPneeJoqp88rM6G1Jx0_1778490154
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 220B91C0005
X-Stat-Signature: 3f4bi6hknqpferoqzc9qmdssjqpbpf5m
X-Rspam-User: 
X-HE-Tag: 1778490156-716295
X-HE-Meta: U2FsdGVkX19dudDyjeDeilSatxYJ4x/miSPp+wOEuVlzqHjoB37Lv/iL3bqTIPpifSsSufvJNKd34eAhyaV+C23EBXCRuWR5d0vbFO/8qHeB1Lw2eDLun+zl149tiJXKfo/+d3Kl0TRJzluYMlT2tYyPf3YgBeXCpIPCbvJMCguMXUVwPQUflLyHaiMsxnxNGigfyOZimBTM4fsk5uI0UeHmULYsS6Ws/QPHYbmSs05CE2GC7h9DXpUoWCZu5VsZE2P5PVNRDukldPZ5CKMODyOJjpa+CK9vf60M/1BLokiFwiILQD67OEYc6YrWxGGse6Pn/C876NHe5Ff2dWKsgY/qjR/MPIjjmNLMv7Vg5W7T8nZmFlxrx3WHeJJudzvIFxgzvqkI0ZAzpxvmkp9VG76dfIzfbGjk3zVNGqB3By3PvIiD4q4wDhH2y0rjj7gQlyss6nuUUFTQj9eAV/T0IM9QHCM6a6fnC64BjWjSYw2qId/QJAJdEdto6mrVqnC3BghXQ3IESarOwJdnf0n/86++WSa7EG/i7gKhZHC6uj9ni3GPxYrvQNm5ubuEGwgG47QjaRkTKGYcSFywmH5nXsp7mTEDUISbfZnReORX63B40bC38wlO/3rr8+m17iH4E/AGFRYEQkF2/ZXAmzuufZWMnMsb8QF5xkPv6oe8GXjoqgmERQTK4y1t9/v+2R137AE5SkSJuYD25Tjnp0fPMbhBnRN7lPmlbQcQqFkGKRadWm1/NdLPsp0MIhYkCu1CzhFSyfduL20YR3GC6aquVE7QfnGUc9tNvMifgH05ol0JLo25pRoLHMZ46oj4KhqCR2tTpsIocxvzrp5j1Ddk3uIdYV/6zqAB2P9eMPyL+p4LLgVAkeXyITvHQroos6k6GiBPXADdel19tkycGVacbjGvfeuLot7O6W0EpLCCWHykg6rF+NIqgCTgrEcebvx1z2Xt+9RNa3lS/pSWBGX
 lBdVVr+r
 Rdsqp2QXjbilG2vNUMozjL/moYPLvgK5UrLa89C6wjq690nGPuHa/l4Tp71KwIyHpHu0CCHHIjQD5wNjmsNy2FrXpw/X06jyUb2aAxHozNUUIq5k95TJejMxpkQ2j5fLI+dE9h6NuRkCv2tKR2GiTSE2oQGWwFcmyRkz/z67/QbSitRA1Qk3KRyWBZCBVZAW1noeCCGuDv+uXSdxG5sm3VsuMzaJB7OOsnvct+q0xVw+ecLyCWjhUm+uplovhRcD+K25SqjRiENdx9kaefWUScnLGCISliHxk3cQt0/fttQfC+qEVQheJE30yY/kXL0wU5Iz5R2gJk7s2A9KBH0Uynk01tncN5Jh3R0S7KvnbbpSwQB8pCrqsIxh1+Hv4qmw/Lnt/s+CR7UGfBMCiCVHDuUB0BOJNj47V95sy42iNNlhx7MaDRcmlOcXXW6v2xmQshhv9ntdubiTJr41O/KAzueP4vnTNaR0qylkrv7gMtNEet1QA1jINTgAlTiEAvE2R7ABOF4MfTXPnJoaTuIMymJeNgPaI7zwBdS0iUxPExdjWdDE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the generic vma_alloc_zeroed_movable_folio() uses
__GFP_ZERO, the arch-specific macros on alpha, m68k, s390, and
x86 that did the same thing are redundant.  Remove them.

arm64 is not affected: it has a real function override that
handles MTE tag zeroing, not just __GFP_ZERO.

Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: Magnus Lindholm <linmag7@gmail.com>
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/alpha/include/asm/page.h   | 3 ---
 arch/m68k/include/asm/page_no.h | 3 ---
 arch/s390/include/asm/page.h    | 3 ---
 arch/x86/include/asm/page.h     | 3 ---
 4 files changed, 12 deletions(-)

diff --git a/arch/alpha/include/asm/page.h b/arch/alpha/include/asm/page.h
index 59d01f9b77f6..4327029cd660 100644
--- a/arch/alpha/include/asm/page.h
+++ b/arch/alpha/include/asm/page.h
@@ -12,9 +12,6 @@
 
 extern void clear_page(void *page);
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 extern void copy_page(void * _to, void * _from);
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
index d2532bc407ef..f511b763a235 100644
--- a/arch/m68k/include/asm/page_no.h
+++ b/arch/m68k/include/asm/page_no.h
@@ -12,9 +12,6 @@ extern unsigned long memory_end;
 
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 #define __pa(vaddr)		((unsigned long)(vaddr))
 #define __va(paddr)		((void *)((unsigned long)(paddr)))
 
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 56da819a79e6..e995d2a413f9 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -67,9 +67,6 @@ static inline void copy_page(void *to, void *from)
 
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 #ifdef CONFIG_STRICT_MM_TYPECHECKS
 #define STRICT_MM_TYPECHECKS
 #endif
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 416dc88e35c1..92fa975b46f3 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -28,9 +28,6 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 	copy_page(to, from);
 }
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 #ifndef __pa
 #define __pa(x)		__phys_addr((unsigned long)(x))
 #endif
-- 
MST


