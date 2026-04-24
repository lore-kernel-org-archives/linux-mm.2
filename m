Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 839A7FED3C5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFAAA6B0098; Fri, 24 Apr 2026 09:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2B46B0099; Fri, 24 Apr 2026 09:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F716B009D; Fri, 24 Apr 2026 09:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0DEF6B0098
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:02:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84AF41C0033
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:02:42 +0000 (UTC)
X-FDA: 84693463764.22.823D01F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id C18D340006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:02:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mqr3co6o;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777035760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtyGDrjmtBMDR0kf2H/Ra51IUF4+3lNSVkXS2bqhdL4=;
	b=t0xpgOrVhWbsV9OIU8sOUMXUk5gVzX8ZpreHkUJPTSi61dY3y5uRrJDujBXOK7oTbh1nQ7
	nv4s11ahaFd2MliuHcJ9FzPPVVBcrF/6KXtujltZKS7VrvTnhYmV2v/4n8o++3NpHLJUHE
	LC1MlG6hdHpS1n3rXVpl7vVAS9kB5LU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mqr3co6o;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777035760; a=rsa-sha256;
	cv=none;
	b=BhGh9P0tGYj/QfjiotcvIcAmiBYPAV3u48MXRreuqNoeaZjHXK5U+8KzcsyCr0VqO88lCA
	SThURvo3Ab07Csi9ceZbRQwHhLX0Iefc4O1/+mHHFWhawcCAF5ApO6HOW7BzKo1Tt9vlsm
	+2qEswCMfx/QJiut2Wtdg8T81FiA6Kg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54E8F1BB0;
	Fri, 24 Apr 2026 06:02:34 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CAE253F641;
	Fri, 24 Apr 2026 06:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777035759; bh=uOi1Rk96oeur1i6i7Mh3ItL6sBlXiIQnfqF3cWvMO04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqr3co6oZde7WmeQ7llcR+8DKaBN6lEdV2rzuhYWXuiAOG/rOW4u/uqnqvMcnrVT9
	 WNtGghnwtzskbxD0OblP/47MNHQJQeWXs7DPMybVKZtIhHS+GFf2mzbMd1Ey9XuzMi
	 vJHvOkfbleWtTQT86FCRDg5sXi0b91IgL4QhTL20=
From: Dev Jain <dev.jain@arm.com>
To: arnd@arndb.de,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com
Cc: dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	tglx@kernel.org,
	usama.anjum@arm.com,
	mathieu.desnoyers@efficios.com,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 3/3] mm: skip KASAN tagging for page-allocated page tables
Date: Fri, 24 Apr 2026 18:31:57 +0530
Message-Id: <20260424130157.3163009-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260424130157.3163009-1-dev.jain@arm.com>
References: <20260424130157.3163009-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C18D340006
X-Stat-Signature: b6dbeje7e6tsi7t3eaz7twiggazdz73r
X-Rspam-User: 
X-HE-Tag: 1777035760-133878
X-HE-Meta: U2FsdGVkX1/3rdxH7T7vqAi5BNUA+/gCdYNNdyUhocCTGqmrWrrD2yBbc33eti0Bibdmg87wXQu5pb8P/GCvJivCu9cMbUHJYV8thZI8Yu9/2IM1q1Sqa8SF/nfdj7HlPFhRZgHcu2kB0OGhWw7wu3eyBoMZvA79Pj30SAxGWEUy1RGD3UhbATWx8rjW8wTgY5GjZoxaBTBjG9oZ47IMWjeHvSBB1/j3p6SlEcAClxDHvgEif8GDWhRceO+SQ/9kxzk/1r/UfaAkjRe4Fy2s5uTHO7cEN6DCMCDGWhg1wjKzpLRNm1va3beix8E/lXqTmbgczMTVJig7tA3DcoXcLqGeTbkZOE1aMERSra0Dp37QFigTU4vKS7TUTJugWBKdctBShH+s/EUplggOtqBbfjpcr2arhfeKDEMnGVg6NJpIP/xlaUCIajzOLhJSbm+cvJTWGNwBQXdm07hm0SJc4CZEZ5+kIgcjOi/R7zc7kvSxyIBkgIqc6O+h3vMBr9EhZcifayCesVzIpv0hespw7lHcDxeQie9IXKGKbDVXUbbgq+T618W827+RyVIc/XXveM9ebo3oVG8gnxH/PSaDcB1Pupm3n47vh8qMmwoURrdOa6V1wbmW+R1YLnoZwIlVczGxv8muN7PpxhMmjiKFApcR/T9uc53AZvkYHsh36uICICiS/4BDzOKqSx2SQh5mpO0wDjfswPYRrXu7PokqNkgM0OWSrDY+bPHpLGOygQ30wzl5aLZHwBvU5VAwd9FJxfuo0FBgvzKIsiIwzt+vGSgT6Fq1baeMQqFmRCB73CKLrYUFSEUl0XMFsqIGKarOdF/E777I0R8p9Xl281z8/onlPmbvplcIEgJ0PwfmHCRVw0g09FhhXUpDJI7sEuFglP2wcJYai2HWefdzwzAw0Z/zdsv+TBer+2eJLahhwm+ytSBNZDj/GPtehJ6l1i7y5gbWDwUCmYKKs8JE5uv
 CyRBAoVn
 e0SjfPJnq+2uS55P8vDC/zL1dsOWTGmXiBCAVn8i1uDJHg0w5K5mVQ1ypfZ0lWfjgMBgq0kE2C7ZXK8JFFqw0hRlIGfFpMISb7+tmy3ZA3uXJ0ojfdjI3rZE0lxmTa4YIUl/GNC52AyT4gkAaRAVp2te1mlmw+G+K9fMvhSlMWg9gawo96+/DS1ZNMVRwT8GjYcxxQSqJaNPwD62A2dtTSajdbq0Ytn2aSzLvELktd1k7A4sFUhsnaoW1vIAIknIPlGvrEjewl3NKYPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muhammad Usama Anjum <usama.anjum@arm.com>

Page tables are always accessed via the linear mapping with a match-all
tag, so HW-tag KASAN never checks them. For page-allocated tables (PTEs
and PGDs etc), avoid the tag setup and poisoning overhead by using
__GFP_SKIP_KASAN. SLUB-backed page tables are unchanged for now. (They
aren't widely used and require more SLUB related skip logic. Leave it
later.)

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 include/asm-generic/pgalloc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 57137d3ac1592..051aa1331051c 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -4,7 +4,7 @@
 
 #ifdef CONFIG_MMU
 
-#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
+#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
 #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
 
 /**
-- 
2.34.1


