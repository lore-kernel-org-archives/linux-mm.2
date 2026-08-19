Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62069C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B7F46B00BC; Wed, 19 Aug 2026 19:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FF36B00BD; Wed, 19 Aug 2026 19:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5796B00BE; Wed, 19 Aug 2026 19:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0886B00BC
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:11:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFE96120688
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:53 +0000 (UTC)
X-FDA: 85119568506.27.62CA39A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D6C4E180009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UEo/GcvL";
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+eE/AORVX+nBzdLhuXTjCNB11etNcl4Di3dO/GDhzUg=;
	b=NHNshSsHybgGbFZA6YVnY6Qk0l8HD7HM4EntvYWi2LhK0p2xDewmrzdyLafgxishTKoH9/
	CLglKX9Y2IWATFByklllLO8RLYnxXa/uRk0BjBD2TxztYyFETm4sfruO3i1mKotqE7HTU2
	ebHmVyuAaaYvlvOTgwOSL+CD1A5bqAI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UEo/GcvL";
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181112;
	b=k2ILDI0ovFar0gleKSrR2UDpGKNlKznD/4L+/Hp6k3sGReVCbHZPgaJiZBonvndcbfSUZy
	Sj3RV8hWSNKOULqSkK8AaQYfEhg/QEaAj/Jl8nTrpgXk5gWUdidmGxSjF05JfkzKLGW3KN
	nZ71MSHSYTSmlXbLxtmtEUITysGS3xU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CB9240BF4;
	Wed, 19 Aug 2026 23:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF091F00A3D;
	Wed, 19 Aug 2026 23:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181111;
	bh=+eE/AORVX+nBzdLhuXTjCNB11etNcl4Di3dO/GDhzUg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UEo/GcvLbLse8DiCCa3t7vPZHj60cEF3fZrSik9Od4RpIOFSFmMwo7fEUfZgZR7Pt
	 udxRLnjSlYQv3oQqouyBpSyVJ6zf6n9Gy6bkUImPErHml4pJMDGP/IlljQbGMNFE04
	 A9TSHt3Ty9JknWI0dDqGELgO+d9HDU+otlMyoh1+dmSL4Jm4iKqraFCz3Frums7sDZ
	 LJ/mF44Lqx0HvnRhIYyIVcXddqyH3nvErDW/W1fcMaloLXs84ii1v4U5HDOoHgdSz8
	 unuwJWVOrMcWushztXgAFusUL71pcM4wVr2qDXyb1WFG9jdw5B6V6rQhddIwtTMFNl
	 rF5qLRVxZxzvQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:37 +0200
Subject: [PATCH v2 20/22] selftests/coredump: put a hole in the middle of a
 sparse mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-20-ba32dd718c51@kernel.org>
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
In-Reply-To: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1482; i=brauner@kernel.org;
 h=from:subject:message-id; bh=CDf2/UuMc2XBowFgVdwGiPjPw3vkqMeWbhqWHKnJoXk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me9vF+H9di5sY8ORyo2Z2qz/hCYU/K/5+HdTcsiVe
 cuKvmaFdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkgz/DXznjj78+PZreIRbI
 +6nK0qx146GMc785hBbGqdUv+HuQOYnhv29pM/eVHcLM3xs938SYnmKtqXRtfqxaKHxaXU953YM
 8LgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D6C4E180009
X-Stat-Signature: 5iykcz6grtkmd76ufjejzwk4ezifh1ur
X-Rspam-User: 
X-HE-Tag: 1787181111-414515
X-HE-Meta: U2FsdGVkX188zQTgumW/VYB2GnGfHv0hyZfl5XTCGsDTrRtD4xFqKBU0bsr3JuAl3CBxeDQkdRfR2RzSRUh0EysY5yxrLrkhhD2aNo0cahO0iINIddgtpDTw+j9l7UKsnm4RAoBn4Wy9h8/W5YTuiKJ2OIECDLwzbW36h9CwWGQ5od+pH5VqfM0FHmiolWj/xSNGkWY9c/jO5YIe2lBgzZYdUN1bKcePpoZW7OotEWQjQFJ0VxOrb6TsIImNI5p7A5472ZnWddvY28kIJzBCWYHnYSr7TeMwuwOsZAo3Oilh+ArLzQMVUiz37X/y9vA8WKulod3RYIoiYvaaNma1aB2eMxpDbXVCrok46Kn3S7a6tshdDrg7xWCG5l3sYZc63GxUkIsPSGlLdsClOootTUc/hKZbWHjwh98ldRbuloJuHBn75WiDb++bkSil2BjDLAJdPUoCtamQM5yDyG7zUeK4PBvSzwnz0M9C4POmbtCn2DcxDAXozvwsnBeJGzsvnjk6OKKprwlnepLVN0Lnp2GT2BKmiy2M2gEbyLOa55rfeP1JCcfhU3GiFm9Da0z8COUXUVJiwmAwNsCLVC4n3dxS+q26vw2XH4kuItHiD94jMK3WRRSIO7VjKOtgQjrK4sboXkJ+D8LSnh+l8l+GY+Gaji5PAN1iStjEkaNTqwD3rEOUCnLMD0jIql483PpOXt0JNT1OXIET5qkkS2pV8xd5p2uI3eEmMWKDSqGXIpd06mT3w3xYWLrgP6c60Qkn8PpjEDazj3drGL+zQ0LwA2sK2KDoUU4Y5YQDUkQh+XUaWNjUxthhDeBVOO3JVK6+joavhApXzwdYqbYPXSK7lM0ly0yZb3dPD80DhjKiBanD8pWrjxd+W9mbx6NDbAqMrdM5rMPlE8uKkRY4FLlF3VIccqS8WSBWfWZ54yw0pP/LymNxTGdKfvlyvUGsOaPzMaR/8BwiZmKRFBBMhY9
 nAN6aGgT
 PH8RYVhefH809plT9oOiKQy5ZyJqcwLFhvJgGYjzL7pypf/SEWSX3vlpT8CoKzxlosfkzBBFLDUTFKda0q35X7xbVKJuDu/cSWTb8yXjAUFPaN5LHYBSWV+2NuQAixC+Cteu/Wbvug01lFVTwvJ21lT31fO4K8/d3Chb8duaLiKHREMUeUGrSrBQYFa7n2qOKxDECjIjCqNz5VxLEG8wlWcaAy9VzXGOvWT3Q9JmqSjapI8imd75OwjBzeONHSDncJgZycyNRQkAyMxavoDX4VmmLJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The crashing_child_sparse() helper touches the first page of the
mapping. That forces everything behind it to be a trailing hole. This is
easy to handle. Make the test more difficult meaningful by also touchin
the last page. This causes the hole to sit between two populated pages.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/coredump/coredump_test_helpers.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 45d76fa0f469..89f3954c5607 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -58,14 +58,16 @@ void crashing_child_sparse(size_t size)
 	char *p;
 
 	/*
-	 * Touch the first page only. The whole mapping is dumped because
-	 * it has been written to, but all of it save that one page is a
-	 * hole.
+	 * Touch the first and the last page. This will cause the whole mapping
+	 * to be dumped because it has been written to. Everything between
+	 * those two pages is a hole though.
 	 */
 	p = mmap(NULL, size, PROT_READ | PROT_WRITE,
 		 MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
-	if (p != MAP_FAILED)
+	if (p != MAP_FAILED) {
 		p[0] = 'x';
+		p[size - 1] = 'x';
+	}
 
 	/* crash on purpose */
 	*(volatile int *)NULL = 0;

-- 
2.53.0


