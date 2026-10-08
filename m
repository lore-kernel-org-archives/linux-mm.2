Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D628ACA600A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A83A96B0098; Thu,  8 Oct 2026 03:31:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5A226B0099; Thu,  8 Oct 2026 03:31:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949BB6B009B; Thu,  8 Oct 2026 03:31:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60F716B0098
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:31:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDA0C404AD
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:31:04 +0000 (UTC)
X-FDA: 85298637648.17.66AB838
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id AFC4E120005
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:31:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LML32DLE;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791444663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvkPG82zfhFkpnOg0JOtNiptSg9vrvtxMEvoINVoQXE=;
	b=vVlTdCz1Dqx8qe5OG3Waam3o/nLXBJ6WNuQq/h7F6Ay6STOvDejZq5Xp2mhmr/ZVDif+O3
	wHKkyNkqmGrFZvzsGORCU525QyMd3AjKkEpU+UXIV7GC6DL1TfXggVa3ZVsAN7nv6vpWWD
	38EsNWMO+MrnDOm12qrlKmVe8nu+zPU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791444663;
	b=kWOpFbQN9wf7NfzqukaV8S8NxVmvRuM/MT0tPvzyApi89EYRjjkjM5h6bKyqAaw8yzvgMF
	5Fa6/HHY/gvGaQLMC/EnCZ0qGOSRA2vbUOhp5yxfoPliy6/3eWVZNFY8VYpoF6Cc6GQ9/N
	XpHwe+A6+kr69YMmFPLi2x9ku9agqqU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LML32DLE;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-39647aa9d52so318510a91.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 00:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791444661; x=1792049461; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RvkPG82zfhFkpnOg0JOtNiptSg9vrvtxMEvoINVoQXE=;
        b=LML32DLEaqnOWY1YevRrckTuxlCG0pVZ8o37oI8iGSaJ+rJVodGqgsthF3zCE7pnoo
         A56/DCgYGoVOk8hY0ug2WyGPBHG8d8eJb7Hg+Q1gouuvD+YD/GtLk2UwDftMC8eZtw5o
         +EGlJx/Sa7hVX3bvmvuhXvP/Eo4gl1obn0e2diO2xSQj7vTM/q0vM4lba7lFmyeyf6AO
         4uexWLflM2mJuG57X/RHJhREvPdJ6X+I83dPgpH3opogj2IrATepOW0t3BsOW2yvuhwB
         2zTiC7ltEubKnnddfh0d4zH6VRSuXpKKrFPomsRh1y2yc26wVrpmsl4mXQImZ59OvNZt
         wGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791444661; x=1792049461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RvkPG82zfhFkpnOg0JOtNiptSg9vrvtxMEvoINVoQXE=;
        b=Sfu7QKgSZF+2/0y2zJ0+cX+EuML1dk44h4f6EZF/5t+x5XyONq1bBaIRnNNel9JuIx
         Dq+lQEGbgFGXZzIs7Za0IPRf/UTOpFHT58DnPqtCM/iPuuljqdVYP7QiHTcXVgj3Uyrs
         5Vvkoxld0K8OyMToCvZcw8wPgkE0IwcTLHYQR6OjY/FeoKSfOM4xBnwaJsaFVpL4zdru
         I4j2WIzD7nZG+E4/WukH0Bfo9BDgPho/1t6rIaPVpQGhwV96tFxBbJxoMb6+rmxwW6P+
         xxXmlg4//Qw3JOdBSJ5T+u4B3u2QQyerKFolp23nTJ/4OnL41deV/5F6pyVVYl41f53m
         Zqbg==
X-Gm-Message-State: AFq9FYJBsSh0I1UkjWSeWW4pV8Y2iSp5byjd2vY+B0714vUq/PCBG1iN
	NTCPe9raehkFGs36ukMQBGAsYmQ3gGukBsh6hWGQ/ovxGJTDLgtEV9kJF5A63FyxL00qZrdR4ep
	6+Hmn
X-Gm-Gg: AYBFou0tHTgoC8Mrx9TJB2d2X/9gM1FaAS9qW+O7vlUwOFbiweBfxB5Ig2zvAn1dKzq
	Q4iB6QHKm2C1lrLyUsnkxTT6ExClOrFV46e6QD7uiORxsZBRUpHXiKkyhy6ciICqO/NTFvQsaei
	iaBn3SH57deQoYsnQMzVMp9qzJ6L4x3r326y7Z7wIJuY70ElsBh7hX2u4Olebg0FxLMsCZpF3M7
	H5ZSSjEqdDQU/IImtrBIyS6bfK5/U0itneh5N0QglPX4sEu+ADxJw+WSXGfkvNFdIfer7PCkUiO
	u5erPBWy+4klL8DVyqx2myZQvYyQwO38MIE2jXoSBD9FZXzTamnWPYT/nNdKdcN5JUchEXfLAZ7
	aBiPHIXs5IoViK3wMAUfk2zdBSFpPpKBHrX8HzoYevQ8BbTzfw5Q9771AlEakMcIwBo8c3lCr8n
	Nbz8Y0Rs+zagNZK+Xqp4rfKW1n5g6NDSEtDBbr3+4ZR6Es04B5QgqBChx0Viyzo2KrAlGDwM3kN
	rpcachV5hfGmu2DK7M=
X-Received: by 2002:a17:90a:610:b0:3a0:e568:ed63 with SMTP id 98e67ed59e1d1-3aadff48952mr575784a91.8.1791444661248;
        Thu, 08 Oct 2026 00:31:01 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8a438f25dsm3114715a91.2.2026.10.08.00.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 00:31:00 -0700 (PDT)
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
Subject: [PATCH 4/4] arm64/mm: fix destructor for unconstructed hotplug page tables
Date: Thu,  8 Oct 2026 15:30:21 +0800
Message-ID: <20261008073021.2512665-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261008073021.2512665-1-songmuchun@bytedance.com>
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AFC4E120005
X-Rspam-User: 
X-Stat-Signature: txmkppsrgf9rgm356ppbdtcrmnh1tcr6
X-HE-Tag: 1791444662-214722
X-HE-Meta: U2FsdGVkX19/+4V76SqoRkZgqLD1FHzb6nM0CcI1kE7bO80VUKqC0mn7YQQPTUoxE8WR0pKjQVs5av4QhAB1B84xVmvxzmeAU+U4YSqxiZ3RD7BAiMv1DHGnx21plotNgM9UA+GNSS5oQWQMwxW33ondyoHR6+/i6P2iqcYmFshH5wCjbI5fpM3QZhNnnUUIbSJROjHSJ+RmEyAGTCLV4Ar3rUyuwjCwtGEHKV+tQkSCgnHdNOQTk1bfYan2IgcwrssvIx+Wu5kP0aobohsQeBintLUS/bTV4mmZ7xeMNLeM0z9bx+tDIPR5J+cpayyYVL8kb0KRRfl2b74auDrizmY1A63iy5NKpC3sj8X4aWOE2Efj1dUiMwyt//QxZZtA4GRrnDqzhfARtDFZ4+Xvi+5HPKoD7G7KjVbbHLi8nlpBQIS6iYxTs4bNr0k+C+ib4W0v8U8JV1h1auc211S5x7i9kwdGcgXQogAbpQxSQqiSjDQuQLACxK7zSWSbosO7mMbHMh3r8yv8UZ2Fps894XaCIcCCgVTTV88IYnwdTG24w5awckhAJ9zT5S7GES0lbCLxgDKt3Ng3R3CqcxqAC72hb/xNfa73fonxckMqZIoVnns47WSERz52QXSjEBSt6AUj63fQQn5IbLtv/rEbJI2VfEpMW1ibIfRFCZY2WAYYTW9i+D/RlMeROV0LhCtwN3JT7NWkV7svS20TEk4cTqlAqVznt2OH+fAcmH2e60evhUSOuhV7be/IFJwCoJ3LFdT5CJqbWdBLA17J8rOYH0lLd+UJ8Q7nC0mTG/qQzRG4/p/DvjNmqchHUYTfkYqPXL8WnhdXNootm3FhkgHmDE7w1Q3eLznztXC4f+SdVyWE3S2ZoXc9s2nTIVogVJldLju1968MRopybs7kNWFAWzEWG0o3yGrsDweYP0xz37IoQdN9ukiXqfbMhN8NHGUkgFwZUGjPaYXn4Dh2JUE
 rxGZ18Xt
 j/4SWAzpjJ/JDubqZqsKX3uv0/0nl70qjeY6yH+J1azd9m+1VwU+0pe6uV9/Z65eY1YDNDdGwy0GU54mohlLCOkTE8uQBY9x0L2+Y9tGQOgZaYDYZhN71dsreoNIIM43CmdKqWpiSFZAIndLkPk/5UvCgUNjeALQOujZ+tkDoxy5OD9QiP76Hs6p9qy473OdvJg7zwcJarTDnw8SVVhR1otcE3K/x3o/MqVsCPVuo8G5cbHq0zKBYlVojd5uOa1PhTyMu3LPFi1bV3SuH4tOiK7XcVc6CdXcQSfQLdJm/yMgkNoL5eSGK53z8Ue2+fuyzJsst0RogTkmu9+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit c594b83457cc ("arm64: mm: call pagetable dtor when freeing
hot-removed page tables") made free_hotplug_pgtable_page()
unconditionally run the page-table destructor. This matches page tables
allocated by the arm64 mapping code, which runs the corresponding
constructors.

However, arm64 also uses the generic sparse-vmemmap population code.
Runtime intermediate page tables allocated by that code do not run a
page-table constructor. Freeing one during memory hot-remove therefore
runs a destructor without a matching constructor and corrupts
NR_PAGETABLE accounting.

Use PageTable() to run the destructor only for page-table pages whose
constructor initialized them. This keeps the arm64-created page-table
lifecycle balanced while safely freeing constructor-free vmemmap tables.

Fixes: c594b83457cc ("arm64: mm: call pagetable dtor when freeing hot-removed page tables")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/arm64/mm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 7343ac9294f8..688b33095651 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1495,7 +1495,8 @@ static void free_hotplug_page_range(struct page *page, size_t size,
 
 static void free_hotplug_pgtable_page(struct page *page)
 {
-	pagetable_dtor(page_ptdesc(page));
+	if (PageTable(page))
+		pagetable_dtor(page_ptdesc(page));
 	free_hotplug_page_range(page, PAGE_SIZE, NULL);
 }
 
-- 
2.54.0


