Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F92CA600A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1906B008C; Thu,  8 Oct 2026 03:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243CD6B0092; Thu,  8 Oct 2026 03:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132A16B0093; Thu,  8 Oct 2026 03:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E76BD6B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:30:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12218A04D5
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:30:44 +0000 (UTC)
X-FDA: 85298636808.15.D571CD3
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9D7F91A0002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:30:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MwCwO4ZT;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791444642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/T793OI/j+CqX3HPTudoj2H2H2daFaSvH0eU6CPZ2Mo=;
	b=i41JSWEreaz6NfPunfYfM0073FYYD+vmFx47Ql8p4rxt1OVt4y3Bju8E/wLNfr/EjNc2Yo
	1IuuZ0vMKoSK7IiWjKDbiAkMxoYq2rJN3htb66BhAFBER8NKXi60TiFcOilNx/G71ufKMS
	q7tL2X7Ru9ncLPPzk0FHVZUKjVCeauE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MwCwO4ZT;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791444642;
	b=qsD4Ns5V5sUX1/ssTiYr+kW9CtIiNbZzPwDH9OpsQHvZR4gNpuZh19i+sHh7Wu2rCalnsK
	MpKzr5BBMb7mlALa7Hef31j4kKjJ0W6C+ywXuJg/7BpLOQD1AMxEUR0L2KfTnjc/CMMHLY
	2T4JiwftXZxcsyHkMTkMlwyWBujrZa8=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3a4b9732d5aso2457326a91.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 00:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791444640; x=1792049440; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/T793OI/j+CqX3HPTudoj2H2H2daFaSvH0eU6CPZ2Mo=;
        b=MwCwO4ZTdOsaYuvNaZV0gxYg2ud6gYUGS5KM7MXW69PceyNvh00305BWrbYHOCN/jI
         p4CtiaXnSR2uO7SOwQzQ2LW9JfeRivl3lVtLSWV6bd9qBLHVbm/4qdje9iBl9eZJVdpL
         Q3gxxkw0VwaAEsoMYc3CTaFPiBSNzYv5IhweZv7Te7MjeNZP7gCaDZEdU2OoXo8rHgoD
         QE/x9JRTEch0ugZppcLrv+QXQWfmPIXWr2FWs5XZ0isTGrItXDWE6+kMA+B66Vnou9GF
         ziXV8O2ucuPvyctPsi7luLx+1xLHunMtzkNrF1sySedhE+t4DDfJJZNWWYQBah2jwDi1
         kFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791444640; x=1792049440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/T793OI/j+CqX3HPTudoj2H2H2daFaSvH0eU6CPZ2Mo=;
        b=f7X8cT2aqi/c+iIfAJvhJ3glo9QsAH0NdoOebyA4N/4cqk9D0F3RCu7dAiWMkBlKfd
         OCGoCZ8NQT1DYOrFgkieCTeU3kQqnSw8h0fI9ip5RCaX+6C9zDZ1b5Zp8Ftx3GuGak88
         P38549x2SbopM9tcHhmeBBe3KpRCUIFpVbRBc0ZAxVIDPJ6XcXqpKn+XdD1hMByHKV8X
         ibfdDwitofQX4xU1Ye0OYrHQPaJDeWaN1egj/bNeF9MRNLV0C/VwgsunMkxi6pY8BSxk
         rPGi19Zu0wDyQUfzV52H57R6RGyL65pDHZTrqJTgNhvlrm3YfU8aF45nhPJaineNx5bO
         jsyQ==
X-Gm-Message-State: AFq9FYIfI7dR7GdeMZjRzZ/XRfjUIJBnnFDy2dBx+2L5R15GWvTarZ6z
	kQwXi0xiu+tnv2givT4wqMsNMLWdExgdHJksTvD/iQatE08Yu2Xt8E2BxD56Z6RU2g4=
X-Gm-Gg: AYBFou0gni5pg6YIXKQcVNMJKFSXgmacu7+UD1KBfjCspzBORWCNw4FpDIEnm6AEiMY
	kzIGhj+Gko4nQslk9lOkx3sfEF61Y9Le3p9kBm1GXsPR2Ds3MQ8WMnjDo8Xi6cGSEUdAQwrq0W4
	Ftc9TZLg2ZJW//4XdkQp5PngJTN+4X6fqg9epiK0HYPk8oTjEyXF9UPOWsbzluui0oEKQPb/nJK
	JQyVSVSxokkQACnLvXwtUKWrmRHg1ehkSqkVNqC9jd6VLqVWi9qcBto30fme9jQRg52u1Rv57gw
	mVUvJ/HIbxgQobPVj58Ro4epXF4FTrBCZdplxwjgBYjDkrx61XVa5BN+XMF/MbD6LLIV4+iBPT6
	fvHPiuO/H3tGPvjPvSJH0ugC3cPcpfXY+CWQ2fVsyihcVcGN3547ESt/Rp0BhGZZNHRr6sGbeIx
	XiCQ+0Z1h5iWsRvshEyxiaaEcXNyz0wILBhOLdRq60UQrDDpTTe8ZGaa5kLRIlVD01TwPa2DWdO
	Ywf3cdwkQH3K7dcIy4=
X-Received: by 2002:a17:90a:156:b0:3a8:a1e3:32a1 with SMTP id 98e67ed59e1d1-3a8a1e332e4mr2636515a91.45.1791444640094;
        Thu, 08 Oct 2026 00:30:40 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8a438f25dsm3114715a91.2.2026.10.08.00.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 00:30:39 -0700 (PDT)
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
Subject: [PATCH 1/4] x86/mm: fix missing pgtable destructor for vmemmap tables
Date: Thu,  8 Oct 2026 15:30:18 +0800
Message-ID: <20261008073021.2512665-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261008073021.2512665-1-songmuchun@bytedance.com>
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D7F91A0002
X-Stat-Signature: 1bwzc56rdhbd5iggmqm96zzq3ete7s8c
X-HE-Tag: 1791444641-571005
X-HE-Meta: U2FsdGVkX19JDopTNtcwrmQ590X86ueJRYFTyAaPdm3Qy0pWS+zqaGoHYVmmjEjbMVB0ESWL2ymtkbivETC98iPSfWftmBc2Fg61ugsXzEEmDQ0K83o+PeeeuwYV9SHSXsuWjiTGDoBOzz41ujOh5caLuNIAcW+8j+rS92WaRdlqzXzLuFLiwjEtkr8d5v3H9hlrrsekKqEaNOuPohBd2Qo7cEVr7gkzvlJzAGJFa15L0K+QG4/nhmnC8rgzLY/y48IzAYtzvynzGhdotQfwiVcqLifMT44cq+Qd2cYiz1+P84+wS2Y3VmJ1wevh00fkFneqO6ZsaRJiXuZjT5SBk/6/FIp/CWHLXYcXfPpG9/qg54rxigR4MFcCz3HMWJQQm5dS8XbqkYE3t/oyiUKnhhV43lY1CLW/uZNgRTJNp3+4aQmC1XBUsSjvhFNbfBOddYo425RRnQNpCr0kPQNPELPz7zbVi05kCrG+LG+xuIlM7zvcoZuzzkpOn8hPWXuxOQH0Z/M2oilCXmHSEGZJNL0KX5P0pwxRtXziTrzKO6Hw94d8gg0gGfBZL1IOmpJ8RAxtSLl46Wg8+b+xtP+q89oUFYNyloSL6dVGdCXjigdN36R8JcMdFZ0HPtqA+sB4tTizYFX9oMqjxvcHgtthU6Q5RAqCJpCz3/dmpE7SNkvyT8PpQ3d5AwMLVGSEZ6ZVd3nNQReggMR6lKz2E7Jm2Hb0LHul0FlOPTpc/2GiriI/S+ITWdj9rnS/fPL4QpGyNcUCeD0/sY9Lum3G7hMYAlKo8iwe6oo8cGu5fGX6tBdHcyoEofpmmb9HLDx3Z3lX8LofjoupOJo4IGRxY7grKM6C47y85sGhcRjxU1AtuSi5u831MB9xpv6F5R3XtmF8XSCiUOtN0Uvve7wzMxIzx/ajKvUqJh98yWU3hI26+BXS9kHQ3ENzqPu6/8bxBK3KMGLZE5+borOZBvYMHLM
 /OCr+868
 l51ByseI4xAFyv1iOxe3as2Y5sbhpuMUT/VJzwto5kw/HwMA7FyEEFJlYfrqrlxsf9YQkrlmPaKBI2bFaDImVbtkAP7bolocvonHBlz8rKnV0ZH1gC66x/KZkc1an50abgTGjDWbhDCYVXHRX6VgRUkPdYusOWdxKfJ5iTF9DokxeZzl8ahNiYibPL9ZkUkyl7lh0KkSmqyQDBwoa8OX1JhUPUEggylIYJzXUYdIPO1QfBjt42t9QzxUjzfcszUYAQgoakDsQKZwPweq+/2c/RbzOnacuv0NT9Z3SmXve/eAdaESf0PgJE+77/QerByKiqNTD0CNyU+ZxHak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
tables.

HugeTLB vmemmap optimization uses pte_alloc_one_kernel() when splitting
a PMD. Restoring the vmemmap backing pages does not collapse the PTE
table, so a later memory hot-remove eventually frees that table through
free_pagetable(). That path currently calls pagetable_free() directly
without decrementing NR_PAGETABLE.

Use PageTable() to identify constructor-backed tables and run the
matching destructor before freeing them. Keep reserved and
constructor-free tables on their existing paths. This also prepares
vmemmap teardown for generic runtime allocations through the normal
pgalloc helpers.

Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/x86/mm/init_64.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 70e682180291..a3ea627157ab 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1003,6 +1003,8 @@ static void __meminit free_pagetable(struct page *page)
 {
 	if (PageReserved(page))
 		free_reserved_page(page);
+	else if (PageTable(page))
+		pagetable_dtor_free(page_ptdesc(page));
 	else
 		pagetable_free(page_ptdesc(page));
 }
-- 
2.54.0


