Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C60D1FED9EB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381DC6B00AA; Tue, 17 Mar 2026 12:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332426B00AC; Tue, 17 Mar 2026 12:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D30C6B00AD; Tue, 17 Mar 2026 12:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A75E6B00AA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D999D160307
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:57 +0000 (UTC)
X-FDA: 84556162194.25.655437D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4892B40010
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=is7iAYXq;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wr7GIE5HtH/HSjfzmH3YKjza9BRnXcNP9oXSEZ3HTcE=;
	b=F+hi234Vgfp8rTbTKM5j/eACVCR8cmFk1O1+zcKHIsMn9srG6Kxz6ShGuu07Gwh8bvmnW9
	FaDNKhapYv2N3f5lR3ddYDdiGwGQYSK8twehrmRth99Oz/di2k0lELDq8QiwiUnjVXuya7
	bG6qqFRdtMcvFVQV//4Ldztc6p0gJNU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=is7iAYXq;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766676; a=rsa-sha256;
	cv=none;
	b=yVhgtFkxfKIH0PdAg6nVIlGVTWKX2N6oecZf8ZHb0Up13Y4VZ3s8PoKWjSl7ON9KC+czIr
	pUblgReKhiJe/dq74BrIojeuwzwam1rwpifGbXjXqZnlHm5QNCfe0nHysyt7ms1dgz7TcY
	oUGZwlz48hI/ZYltNrcPAK28MoM/xek=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B834560103;
	Tue, 17 Mar 2026 16:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8092C19424;
	Tue, 17 Mar 2026 16:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766675;
	bh=0l6Twm5fWAYc2kE+D5nyqi/o8R2cJncgC9qwk29875U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=is7iAYXqxhS295qB9qkyZKPyw/TDgW7GIBe8C1dgMEt3C0lFDzv9TfnIEuVRja4Ch
	 7Xh8nS2EDRCWYaK9cudk67IevARAf1HyKcfHzzIeECWQPewhL8isv1LtlmlL6KWuEU
	 F+/M4tJxfdZKbyqcSQySKCaUigGH8dJuFn5fzUPMUZV0ORHmUP5xNwicF4xEzZvPWd
	 rYMbjTGPtoD0JjPw9CyUsnOhXFnnqF/VkMhn+7Ytrq+7IYyPj5UqutKohLv1RynPSx
	 GlOKUGD2MjGkRjjJRfdzfSpAWjX3qoyrZavoUwT08vtLhfFr3FSBPvx8z2uWOHX6n2
	 WwrmLlEfTWW0g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 13/14] mm/sparse: move __section_mark_present() to internal.h
Date: Tue, 17 Mar 2026 17:56:51 +0100
Message-ID: <20260317165652.99114-14-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4892B40010
X-Rspamd-Server: rspam07
X-Stat-Signature: b1eqznq895ax7tunyjeywdpsuwqfgymq
X-Rspam-User: 
X-HE-Tag: 1773766676-380371
X-HE-Meta: U2FsdGVkX19gddIWIgnIYlTdhFdb7RJLI68cPm1SZKD3sIqwIky12nP9k2woMoe1PFbMetPmA3Ee1jTPqRehV+UVoosHvAl+CcEclM7w+Dm8OHp3z8cF61+lUlTesJkUfv+qT06w13rnFX+abdIs88QjIahsTBAvLmQLYv7eyf6mGJchZ8T+29D8yuTwsx35rme56nrgIJFe10sT5Z0E/SR3lNS8SUIJ9XQIJqM5d6e3UysYZ/KtQuLWZ2lLsK2rgu2F+A1vQS4PU2xXwdGomLGkDZ9ewFSmb6Nho/DxCnABXCFu69PsihGAWWmHsqpT7y6NHA6LHrN9H4QkqDAAZpMEX3p4gBhIUW6QyyPcGrwHGRrqIDKjsoghuWDA2XmIo9UJL6NvKBgvBeII0g30ghOnVQtK4v8klB7gYmTfAEtihfZB4jFoz6bF6qqjmZUhEqsBubOWIDHMRZUFoFSaFMxfk1cxb1IKE4tSE/NPYA9vGiaQ4whv5MpI7TANbScbh0GvIRs/9c9KlrvdGOWtWviEozSv44MdW8eBUAgkLBGGEZrcxjZIS6BOUU8HGfL8mAq0zSZZSwhdsupVkh/ININjT1Y/i6Wt6sfKfLjU1+OgiIsyHCuEwrCgdbQuOiGtsbZPQioOIOO6oLPAIZbHp47pqN5+hpAGKBLQ4hSnNkWgH5lAaS1ZU+lz8RKFvMqIyo5I60NVFbcolMrZUIIELXoMzR78E/zbGR0+/KMAIDIyEQQLfF6+2HFKFypbiUAntgS4sBgJTBxhBudjvd/39XE/TPlbdiuc9V/Dwi4YG5CXjkOpxrRrtSHokb5jtahItVDQ80uc676K2iLhIPB0kNtouZoXlt7SAOpaGlt7t8svS5ev5ThCzAijKgb762FV42LR7zCzuSGvM+3srLfaQQ+atI33JbWygQRLprqU2eXoR9BMIkMAUkOTClRQPVzqKD0TS/dP5PJ18znOFan
 QnIw1lmO
 3Ag7LbloG7ymna07tSxR+N53wNySfAV4CtDxIPDBfNknezr6Wrabo003qYDfMi9dUhvU1agrKURJyrkuUjBt4vaVSsyx82rDX+HLWjI1wLbvEHixLlVrppfv02gJoEWe5vuUYnq/VhN/ruEg2YasA89LL5Jr4lFLNcC+omrj0FvsmNawiV8HUrUCkEcCUQf0+hEzzsd3HhY/IpYnYukHfbipj3lc0Eshu/lTkK4aJAg8B1v9+1AsXT6mPUgkv/LcOERvb+/YAqfiZSEJlVwz5j37jq/2SLvOHuB8Zbo7hOZ5LICZ4bxQciAIy1PZ38IcrurKr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's prepare for moving memory hotplug handling from sparse.c to
sparse-vmemmap.c by moving __section_mark_present() to internal.h.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/internal.h | 9 +++++++++
 mm/sparse.c   | 8 --------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index bcf4df97b185..835a6f00134e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -987,6 +987,15 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 	ms->section_mem_map |= SECTION_HAS_MEM_MAP | flags;
 	ms->usage = usage;
 }
+
+static inline void __section_mark_present(struct mem_section *ms,
+		unsigned long section_nr)
+{
+	if (section_nr > __highest_present_section_nr)
+		__highest_present_section_nr = section_nr;
+
+	ms->section_mem_map |= SECTION_MARKED_PRESENT;
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
diff --git a/mm/sparse.c b/mm/sparse.c
index 6f5f340301a3..bf620f3fe05d 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -161,14 +161,6 @@ static void __meminit mminit_validate_memmodel_limits(unsigned long *start_pfn,
  * those loops early.
  */
 unsigned long __highest_present_section_nr;
-static void __section_mark_present(struct mem_section *ms,
-		unsigned long section_nr)
-{
-	if (section_nr > __highest_present_section_nr)
-		__highest_present_section_nr = section_nr;
-
-	ms->section_mem_map |= SECTION_MARKED_PRESENT;
-}
 
 static inline unsigned long first_present_section_nr(void)
 {
-- 
2.43.0


