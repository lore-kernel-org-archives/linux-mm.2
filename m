Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F204CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47CE36B00B2; Fri,  2 Oct 2026 20:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454C66B00B3; Fri,  2 Oct 2026 20:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C6F6B00B4; Fri,  2 Oct 2026 20:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4046B00B2
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9ABD4C08A9
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:54 +0000 (UTC)
X-FDA: 85279412148.04.3AD021B
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1BC8A18000C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v1GK0dCP;
	spf=pass (imf06.hostedemail.com: domain of 3nkrAagoKCJE4E29F12E9819916z.x97638FI-775Gvx5.9C1@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3nkrAagoKCJE4E29F12E9819916z.x97638FI-775Gvx5.9C1@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RoV13e3nXsd3llTg619zxCPg0yBMRrfboFWdssakaXQ=;
	b=Qlislyz57JxE1o1EhPCzZX9oISw9qAxYMNm3ru/xeUjBEGpN56uRwYTd8B4V2n4EhlMPmN
	2EDm/Her89RribdJa01kHdiXwejpegOwa2SimXB3drAhCj5pv9jB9ukZXF5zYdFEoBjXvT
	k5MyevlnKskfTTudczbx9YLEyrEfXng=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986912;
	b=tuoVS+ddLTQlXRNYuVVu4Vs/J+UwF8nOL1swAafoZanhMX3cslLLqfTkPoz8roEggzQY5R
	gheO6L9+weIWU1LYgdMZVEA3HHu6qLlXL77N2+hzXkBkrWERl+hn0I3DPl2Ljm5LyofaYe
	3okqiY4GliBIQbJWaqJFjD62ddSPCuM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v1GK0dCP;
	spf=pass (imf06.hostedemail.com: domain of 3nkrAagoKCJE4E29F12E9819916z.x97638FI-775Gvx5.9C1@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3nkrAagoKCJE4E29F12E9819916z.x97638FI-775Gvx5.9C1@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc1b6f65dacso91148a12.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986911; x=1791591711; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RoV13e3nXsd3llTg619zxCPg0yBMRrfboFWdssakaXQ=;
        b=v1GK0dCPxx23vzutHN2hcx6nmbfoMLwrV0FkvJiVjfObB+rgrAQyAZBy/M0n9a7pXD
         NYW+ELUIMPdczHrSgGovX/zGOA4WfjYcbucCx/omK737+pHee03Y/r+fa0x3fLmZEKIC
         GDyBywealnvhI3wVR/sd2OyELLpfx0FLlqE4yySRLk7JqxZo3BYI9bRBmDzBL0HhPUGE
         Izk67MkopdKODHqMQ/NXEwjDrUKOZvdmOvoAlS0YLFqRubA4IUao+SVUd8bLO07KsoTb
         WtWEqnhFyUL9GDgIpIxlxEvsj4MIkIVkXQIxWhivQG7KP99+zWcP5DxR5oM3xkCK2DGs
         2FKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986911; x=1791591711;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RoV13e3nXsd3llTg619zxCPg0yBMRrfboFWdssakaXQ=;
        b=mIFJa/0Ng269wQFXNpvsSMdJn/AWxYFEL7Gy+hz8rzJ4bYTuMwf0LVjVwv4/FK2PcR
         R4yJ3FyQPyjRYh3bA7Jv+LjgF3sofOORUMY2TQPhHs3blTHAf3wIpwkmtxHQpxJiEJf1
         TjiSQDtinv2x75nhQqqLIQ2bVLFgvUpGXyws6Bkoc4zdps0G28VHbiY37nkoEZ2rx/iR
         ezMZXjOHYxsQawR8bGw/DafCzfbKnHbzstXoGCHru6pz+6LmITn4Ss9nJO51N/NlM3p4
         VHfgpamg5sP14wr+C7rJ4CtW/YwmwP9HXNC3FWNb+1J/SYb5m+t5ecFEBW+jSONz1b5D
         71eA==
X-Forwarded-Encrypted: i=1; AKwUvBwrj1f5dJSnFjnpZIhh1DcSiczq8JIl0BzsPUQhM+MDbdQa0/JfiTxzMKM+sU7GqsLLn0aZ/OO09w==@kvack.org
X-Gm-Message-State: AFq9FYLoKmmHZh8/nkhTbgwaUstWq+NFg3Vlc5M0wJCY1KJraN8waNKM
	b3KIUP2qznQuA9mbbImA0cQmjBIdtGhZT4RQO9evqDpGSi8B85WAUA+WRMLBxXtl/d9APsNxoYy
	UbX0YH6kxNZrIJ8Qthkt1Sw==
X-Received: from plbmm8.prod.google.com ([2002:a17:903:a08:b0:2e4:a5f7:883d])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:181:b0:2dd:c053:d73f with SMTP id d9443c01a7336-2e49b681d7dmr43902775ad.38.1790986910713;
 Fri, 02 Oct 2026 17:21:50 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:21 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-19-jthoughton@google.com>
Subject: [PATCH v2 18/20 DO-NOT-MERGE] arm64: Drop BBML3 requirement for HVO
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1BC8A18000C
X-Stat-Signature: 8bgr547hcpmiqrpey54fkma3fu7x1y86
X-Rspam-User: 
X-HE-Tag: 1790986911-567600
X-HE-Meta: U2FsdGVkX1/Cj+z/T3i+KF3sSuyTOjw7yCLbTAKXW3Y/HM3mnb3UkZGo3QaLCLzki+4l8zWUT6jdrdNt5yAnQ88llzcHb5+O23ETb6aWyrXayna9cayu3GgWFOUHIH6a504pQrhRVxmO9WPrbb8zbFf0YTydZtjjf5MZ4KbowN/HE7yAxnpJh1fov2IN8lOTlidOl3gdZ0NPqJnWPlNFW8dLCiynmsSwAvYG7IhYZINWWRM7+cFieoK5rAvThzqbe6OJSR8wso5rWOF1QAnu/IOIpamGjA4jIhfgzvlQwwxp4nVs5vieZbvVLZjHPiKs+D+T62F3+KGwwMG2xJp47wVR++tL1TCeO8Scp+QJlQ8dviWIcSmY1GVo82BrYSh2LL7xdnQ6z6AKgwXd920dIVjpaoiuG8GpaflXIa7nQi6fIoIH9fWIgX4uSeBJ8au7961B6LfptFN3+yCCdDqIzpMVGbIxSE2IfQDGsXtzrukfodj0xVZq+8xy2HnQw1d6NvaGcGa4yKy6iyTMSk9Lo5j8DUJHXpm1XOGK5XvdBOzRD1gcvd1vK6xXTQ/ff1O2iAthowA6iacHV40uzxf4aDoy7p8JURg7x+mNOp7GdbT1udjeP9AmsbTrWn26QUQvqoxgiaJ9QzBzHKlT7iE0AO8gWHN5/obUAz1LcLt9jtKlzvwXOL0Cwln3nC5Zc6u7EVVBoXENAHaJOOnyl9l0qt2GKMlqJco+aE+0ecFMP3V52d8Diwwh9YTElsz26Hqwed7HFOzdDmyOZP7jbzWDEmdYhiC0lPGn2c85DQeME5R0UZYsEdOZGx1gSgNimh0OterOtZCtFJZK/TPD4/Rh2nuk7dg/6oH+i8oJaVtT+6g/ySdu+NIsH3YDMvNgycsFt4Y/xo4425BusjoUiMsg5htS/fs9dtDi0wAhPabPJzYOQS0KR1AStZnAr4ZbiCIccVm6Mbe4DBw66Nu2Tq0
 A6IiuNS1
 M+V64t2gHdS5MJCCiJ2hJ0kBEFK+DD2EmBuO0KGh8h0TZ1406PGbW0rBz83JWnz61z0SpmlAVA8VSlCi0Qm56aCBEA+OLHodO8fuFAg4vdqepEy2eVMqtnTMX/cP3b5E2cxn4re6nAASe1EmZ50h6RbymwUDKmOrzi2ZMeDsyFqF6iOqfxFqg8Z0hGaUtwQ3EhC8lSdPfAjf3tbFI1ltSr6LITTYhzj8DOnMVVm5CMa4YpqdksQ2g35QOKW29C/SC0ZCuvfBgGu8WBS+rG80EtmrN87dBG/rm7ywGlA4zUvpTTRqVBUByaY9vdvP82qDXElCiRqnMHnbSor0MqsenbC8ECZbJtEpL6Q1bJZXD4wasbkWwRnIs8EnvLev9/ekyL3/j57t4mkFR4NkAdAxeUkblXsXqB9Xbij6RHk6dMxsghNcMxVnCSxtEycHbOhMVcERWwl2D8nk05mVHBYi1TJ5b8KMsnrgbxfkz18KxrAuM/M1O81yknV5TOsFC6Sk2Hw2CbwYd2k+IN0Zvuow8+G1f19AroFbYx8tq78V6NiYLHnPNJoHgqqm6cq7XJ9P5F7bsxtyuSry0xinsKJLodK/4ZXZhXVIBPqcN6SaSCMhyUJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With PMD updates being done with the Access Flag trick, BBML3 is no
longer needed.

Dropping this requirement vastly widens the pool of systems this
optimization is valid for.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/kernel/cpufeature.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 448d4ef085de..f3fd6d0b0e41 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2206,11 +2206,10 @@ static bool has_bbm_through_af(const struct arm64_cpu_capabilities *caps, int sc
 	}
 
 	/*
-	 * We need BBML3 to support Block -> Table transitions without taking
-	 * faults, and we need HW AF support to support changing the OA without
-	 * taking faults.
+	 * We need HW AF support to support changing the vmemmap mapping level
+	 * and OA without taking faults.
 	 */
-	return cpu_supports_bbml3() && cpu_has_hw_af();
+	return cpu_has_hw_af();
 }
 
 static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


