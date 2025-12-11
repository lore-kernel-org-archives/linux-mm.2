Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 589D6D41C04
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 08:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A83136B000A; Thu, 11 Dec 2025 03:11:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E57C6B000C; Thu, 11 Dec 2025 03:11:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923756B000D; Thu, 11 Dec 2025 03:11:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81B026B000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:11:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 241925B41A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:11:27 +0000 (UTC)
X-FDA: 84206470614.05.FB35628
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 444D6C0003
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:11:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=YZpisVg4;
	spf=pass (imf22.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765440685; a=rsa-sha256;
	cv=none;
	b=6wWcOpZZAAegQ/D7vjuZ1LkAd6BChFKIczv2NfIjtv/WFA/nZnqm4LmyA9t13IIiRFQ/3s
	0yB6oTEZf2nP7ADayCUkKpn6F01kAOjYFOJV586/F11t1qTTN6JadrYAWv8U7Q8EDsGXw6
	JznqmNCdHPjOnffJBHut/WFIF3SbvQI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765440685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzNYrbuZY36JAQQh5imy8mkydqOdZmFYwfkn43jP58E=;
	b=UfZwpqk12Zgh1fM6YTIi26R/zZ0oA+bsQYiggJo9cjGFnghAyMWYGUwfKHP2o8l9n2lE2u
	ITBry4rDFG9li5F54NQ2B7nZKma3XEwJC9rUwBfViVqSXRHp8+6vCmlmBBBH5ccSwizS2i
	scLAF1g3ZDsedsbjsd0z9NFvWFxvI2w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=YZpisVg4;
	spf=pass (imf22.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c075ec1a58aso464802a12.0
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1765440684; x=1766045484; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LzNYrbuZY36JAQQh5imy8mkydqOdZmFYwfkn43jP58E=;
        b=YZpisVg4/3Hiib+2zyJp1s//PXe8vHheZg4X77zR9GvJlxIkLkTTKwzeOo4FGPCzP5
         b8zQ2lMGqhI9PUHgELt3MC5s5hDjjBOChWDm1OD5hVru5BxGo/n9Q/lq8EuA1RHpjT/I
         HqLf47jZgbYVsBe9w8dg9CdgTxhsq2sM7TayS7V9A5Jxd2QY+6IXEmQU/X8d2miRjuOq
         peZT6ap5RQgRDUMATdXyH5sAv1XAO4iwgcf74Pd/YINh+RnaMhpMAfnSBe5a90vlfMY/
         dDQnJOkAJbhtmUosO22D8altp3y+kmOoP+irQLL1Ek6NyFC8UwAShWukG/X/Dy4brT9P
         NT0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765440684; x=1766045484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LzNYrbuZY36JAQQh5imy8mkydqOdZmFYwfkn43jP58E=;
        b=QO6G6P9POFL28WAaKfB/Ud/jSJlJIqX7iHe4ZIIPwHsTW12LpQTkQ3KuqF9XGhajzA
         90B6h53sH0ES+14umg6wU0+VQbYCx1MmJkbXOluctM6ebuq0jTlZi13f9etV+zDGzJDO
         k4vVzISGHZnLLAKqGKfUylPt+3jOa/gwYU2mtrtkLnZcC0ajzh9VIZib8GY7u2tSS7kX
         T8iz97WqT76aJolFFIn2gCfQyM43ypAAlOk8lbnmHAE2jkI61l1w+Pbx+Vm6MDwysG5y
         9DHTOV5iC+Pjv4QLu6r53fEm8LKxxa4oSFFObFxuosdFqyuaaUZ9WnkdlENvMlgBqR1W
         8wrw==
X-Forwarded-Encrypted: i=1; AJvYcCXPcJhLkMOoUMVD1Kz6y130q2e7EjT1yUKXQYjYORWl6QLU8Q93teg8yfosB+4jg7nR5OlxE7nFpw==@kvack.org
X-Gm-Message-State: AOJu0YznJPQ20HaIycx5Esj/si2uOvgBvQqzGP5FmGX5gtPHAFrkhg6J
	KKdIKaMOQHmTjrwd4nGSXI4cyv7qBbUT5Y4J8eETa2NWPv7vFW2M6pkg36NW1q83ECo=
X-Gm-Gg: AY/fxX4a1seJoUUMKvoE+5nQD/W4wz+IXRODknv+1qzVq3Q0r84IwnpMwulWL2QgVUc
	YGsxmAsIL2P2vaTSs9/jpdjKP4CpeR5E7610fE1pQWCRGtUZEVYSQEIDl5JkQheVmfp679LRJGk
	ZzsZ1+hBPz1MZr/7I166QULjzrNZDV1p4eax4RrP2f1yDKh2LopwlNyNRi+CSsK+RMDBFnEEWK2
	vuQm2SffftKsgrq3zHHDTNZ/9tU7JwiGz265vOt00yLNOwDPVlEsrjDyBk6fpj2DBDZl4EceF8k
	YEisv4o6bRmGMCGkDGs/LE5ZYQgSpM+WyAv/STcQs3P2BmvewNNIWjYwmRNEcQhMgC0vMPJkXiN
	/x3FbAVAWFdvxFMI1J/yQ2H2ptXQs5kP7YphAA4SBtXCnAi4lvVGHdk673/KBnTnrsTthF9NHzw
	YrnR++kexORbnmlR7BiVc7LyhSs3dCP6be
X-Google-Smtp-Source: AGHT+IFHPzzd6sVUY9r8dHLK5SJg48FpT/wSnCMD7YMCy0GX+GGxvZBK/Mp3ieFiPk7OwZJjH8oG6Q==
X-Received: by 2002:a05:693c:8115:b0:2a4:3592:c5f3 with SMTP id 5a478bee46e88-2ac05449fdamr3000184eec.4.1765440684026;
        Thu, 11 Dec 2025 00:11:24 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ac191e1eabsm3914759eec.4.2025.12.11.00.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 00:11:23 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH 2/2] mm/madvise: Use set_pte() to write page tables
Date: Thu, 11 Dec 2025 00:11:12 -0800
Message-ID: <20251211081117.1126521-3-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251211081117.1126521-1-samuel.holland@sifive.com>
References: <20251211081117.1126521-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 444D6C0003
X-Stat-Signature: 5wdpue3cq8y9die578nwk8rnoyojoapf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765440685-410792
X-HE-Meta: U2FsdGVkX19Z+WSjsNCP5obEFHl23Gh5wFrZDbRx8ukFAu+zAPlIFMEmr5cQC1gD8ikJEYK4rIlc7590WbKbVz12J42zynQhVQc+Y4C+rQXMhPwjB3rRtbQTk2fKlHlH1UbzyL7vh1oHRbX+Abm7nIKIheqnbrLo8Cogb99kdOPMuokGQMiMB/rek88JEzK9E9UNCcjvG552X35dJba7oa8GYlHTSLFzPH7RbYEwSEaSluhlNzN7iKk27wPpJtmoEXV54XovNN5pvuJ489cy9UMgrZ4TDDGcSFOfzn0KVaqUUlF1zID0+24oDV9Mr0qM/0WsRvDHmOHHIvJlnR6uSW9VxDGcn9viIZzonxD9pD9W1Fn9GSKkS5R2R12cUdEJAr0+eAd+sEJHeWZErxSKxOjJANofvPlWeDJuiGp+Co/Ed8mnsVBlZFuTpyeLcaA9LmFjkOGIUZTd1wC7zKOJnc+5qNvKbYEffaxmdI621DLuOxfZSAUgpSrNLdkakn9Bv9V3BCt8EWOVsxbXJdyiFhKqaBBGyt53ka9QzpoLFWMzJV4b7DJ+pTt/cxo7H4fmaLcDdH/DDRSYVNCNr+7+q/n30L7MLjLJWHJ0AC6vzNPha44/XPFvnIC3OE45COBV8HRlNwPvf4ZLx33Mqe7HSOS0upgnKDdlezbCKu31WbReyFZO3SPmQK7an0Ggonk3Z2PaHxWe8cY1QHaiE2CXKm6ksUB2k/Z4Ov+iZhuBADsQFKVd4WMSm9h21/txJGFtFVdB5B/rP2gPvOg7ICKKm7Z8/0TJRBjTFRstdYmK2XfCBDb6hB3ujP7Z89TALDuCOXhwdHDquWAd/oDYVsdzfDFGkoQRf+HNwYlHuHKKW+dKlSYC6+vUBeklWk5mMJGVtIQexh2I+XqIpYeahzIvZqk1/qp3AoNBDX8h852e/LNTk5gSn6/I5KBu9OuUYmc01kwEaKJxDEy5IiA2sZA
 HQpYJ7nz
 zuRj621HSxlLEcrpd/tOSv0iZXKCbCv+bQ229HCHsqemGTa9W6phNu+3unFe4H0UscSlWm3Fgw6Kw0Q2WUBTe5Zwv+FeIYyP7abz7HYvn7VfhnvvgDa6NEAr8je04WZGMpOWFTtrzBfRPDYPw5A2VzVD7VvqIDE83Yg6wYbTpbm6H8WAusqbFJR0pO6p50opDM7axeCqTNrClidd7ROGxoKSBxz88AkiPri90kuSreuscYEXz93lip/wpvQVWh+vrSyUGWu2MYnDBhvlQNz3Y7DFeuw50RXC/sGt8cMM9/3rasdpJWFeEGwabWvFAsLP8kR8yO4FOgTmquy2xBXQJTauqKQa+Dktyq2X9TPWWla6Up4c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generic code must always use the architecture-provided helper function
to write page tables.

Fixes: 662df3e5c376 ("mm: madvise: implement lightweight guard page mechanism")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index b617b1be0f535..4da9c32f8738a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1114,7 +1114,7 @@ static int guard_install_set_pte(unsigned long addr, unsigned long next,
 	unsigned long *nr_pages = (unsigned long *)walk->private;
 
 	/* Simply install a PTE marker, this causes segfault on access. */
-	*ptep = make_pte_marker(PTE_MARKER_GUARD);
+	set_pte(ptep, make_pte_marker(PTE_MARKER_GUARD));
 	(*nr_pages)++;
 
 	return 0;
-- 
2.47.2


