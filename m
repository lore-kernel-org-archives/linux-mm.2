Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F1ECCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 15:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254138E0005; Sun,  2 Nov 2025 10:11:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22B838E0002; Sun,  2 Nov 2025 10:11:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169FF8E0005; Sun,  2 Nov 2025 10:11:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05AE68E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 10:11:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99D184AB67
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 15:11:18 +0000 (UTC)
X-FDA: 84066005436.25.C375014
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id ED1C2C000B
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 15:11:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tRPE7+8X;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762096277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pLlmYA7e41xOhmq2FzCh53oZJX1Grv2GnOCsuHIb8ts=;
	b=PrpiXXLq4C6K+WsqeW2HUu3GPlHViqglmcQJqKpqR6Rsiajt76kEpn3z+jyhm8FdkxCAR5
	fBDIE6mnZvZvlMsWCCb3gcXWLiLG5en5cf5lQIpDWW7Xsl5ySlJxYxFzcC1hu2mlis8WVH
	AsTBHTET0cJeitoMQvcmbmXfGyzgvFs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tRPE7+8X;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762096277; a=rsa-sha256;
	cv=none;
	b=00UxDqLuIojQ6g3jNuEstLcfdKplX1AtmL1n17wYHGTenJdurmIYYXJXlwOtr9AtCicWI7
	g24b4wdtM4AMc0sir99e/VJwBvuxhLKodOWJyh/pIp+bgtVtOV8/7R1Kcm9fKN8RN78zcK
	SpfXtwSVkkeGJS44X0LtN/d7EVuNeJk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DF1C42BAA;
	Sun,  2 Nov 2025 15:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DA4C4CEF7;
	Sun,  2 Nov 2025 15:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762096275;
	bh=A0aoWXU60Hd4meD21jQel/DOJpC5UpQ5yvBIUwRxGi0=;
	h=From:Date:Subject:To:Cc:From;
	b=tRPE7+8XfS/EkvzHOtjZx3T84AShgQcj176E4gqaecQVzcAn1d56oBd4jOIbXMTpA
	 3FeF/SzNcUjo1cutuaIZ7Kmo0H02E4y38URPFND8An3ba/h6ulasXjAu89b6idm0WB
	 i1JSEWsE6SwzwkQ6Euze5VKWSoraYH32dSTpo+byFNsSaDJCmZNOamietzsTAjUlkQ
	 kNnJIeELtzSuUZf/pXQjVbgjRoj9JuKlHEEKvnoZwBQ6c4ivvU6XIN8uEb8rs5hl/z
	 SSZZicAXU3B5ihH1TmOQrPLZFHOMbID2f3n/xZSmqfmofQsmpoOFHZoP2j2q8EBwM7
	 8csxy0d6Q4CRw==
From: Chris Li <chrisl@kernel.org>
Date: Sun, 02 Nov 2025 07:11:07 -0800
Subject: [PATCH] MAINTAINERS: add Chris and Kairui as the swap maintainer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251102-swap-m-v1-1-582f275d5bce@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIp0B2kC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDQwMj3eLyxALdXF1zSwPzNCOTVBNjw0QloOKCotS0zAqwQdGxtbUA2kA
 b/FgAAAA=
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Minchan Kim <minchan@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 SeongJae Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ED1C2C000B
X-Stat-Signature: ujerq5q9bdft837r43myr9jio4j3emkq
X-Rspam-User: 
X-HE-Tag: 1762096276-878740
X-HE-Meta: U2FsdGVkX18zwntaFDTljj/0gf4dzW36FjbuvX1f2VlhcBLud+/DjSJhurBD6SA2t7Gc+vT2Idi/w52kd/bgiT0MEbFINbFS3nHLif31pp432DpbNRADZVs3pIT8of3wxOqUVCYfOQkfn0e1o+ozZ/k9oOnxlUNiES01Ojxt33TYTAWfIJrSxRGaARqUkUDhctXF4YtXAzpjK3LycvgMa2nyo5Z0mtw4scgr5pO6a7FwQRBaECcXB93uh4r3xQ81xIQCPnBotYxfQJt5rsxzYqlkg1fSHw0G2vwMwLkXpbqptipd0wh/bSl6Z7inawgyOD9JqSgdkX3oh0P0GGWEAqPd8QLCw7YFQqPPxAwWIuyXvzXRyGYHndjXRqzx4nnpVoHVfzG/Ienby0TtL9pRyJQzIiOpfCHc/283SrweFEvQY3DBbdbDiwQrEB2yEO+T6HSK+0hzl7dUZ7cj6lq+GAyIBAwojKQe1fM3kZnzlQu90BXk0aK6A8G/STH7eg7alw+vTtaZronzfLdq7A1+Mkt8wvQ08zMzFz9xR5DHgeAn09hDHf0WYtJRa59wvI+D4HOIytYz6v+KqfD5Gg/IzBp2P2SDm5iqDFxB9XMA1CFN0yJekAe0G6CPTH5+Su+ZxML/rTtDsQ5ADWUYFpjYLuXvvfImYbxX9n4msJAajeGfiMmOzgupy+6ie5sNkCSN4WoGrLt297PweHct+XgNEw/Xx0IHGAxjyvZDW9LflzsCnOKL2Rylv0MqUKhjnX3uU9tHBRHIcwvQwQtBJxn+ScEZLy9nQHCpJW27j9OSM1uKVjss1PaWAmWjncJroojx6oqAy4op1mmqqwBU1101bYWieYwvTqImWjmGV0MEaYVzusqt6HJ1p8vpDycw0ycFk5omBX5FW5bcTnSY7xJHbrQgfiLOnN3kT58N6NKaPUoEv94uNbo+FH8+ndDc4aK+/PqDcsP/7cnWL0e1rBq
 Zf8FtLRa
 l89xfqsdCY+93jh+rEshXspdjF0B+h3taSFj/5JYiZoBtfTkMhqch6U9c81YfkcKIpBRq1dMMgh3rCJL0PU4H1LadG7bDYhLNuOsT0uhdnWmsqKaIpzXqJPrT5fUnD7arh6qmY9N9rqJB4dMWUqIhqjelX8kty3sfpW1wXQlSU8vcB/3ub2iaa4pVhbFMi3zCsOG17FUvi2eOIYAOq3ENPSkp/Hu2kqClhgPfLMYMdBpPLUPHQZqQtt2yJzokUkfrYhkRzH1AbNSwmKNaQLUH+yOXc8G+sqCY5rVUBP3NXJ5thRRxk9re0QgKMiBBwAkpvPyNe00y79kHT6obFydnVqtVV87Rw2JrhQViBxRIJdPF/961gDbI46M9YyAdJ+S9SsQ4dhWCI0DpoYw++aWmGUXuPMZ3UeZkWkREBAsj8RWRubR9xoQiF8x/ThXzZSniWUL3uGmDvOhjjEM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have been collaborating on a systematic effort to clean up and improve
the Linux swap system, and might as well take responsibility for it.

Signed-off-by: Chris Li <chrisl@kernel.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2628431dcdfe..8b5af318a0c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16497,12 +16497,12 @@ F:	mm/secretmem.c
 
 MEMORY MANAGEMENT - SWAP
 M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Chris Li <chrisl@kernel.org>
+M:	Kairui Song <kasong@tencent.com>
 R:	Kemeng Shi <shikemeng@huaweicloud.com>
-R:	Kairui Song <kasong@tencent.com>
 R:	Nhat Pham <nphamcs@gmail.com>
 R:	Baoquan He <bhe@redhat.com>
 R:	Barry Song <baohua@kernel.org>
-R:	Chris Li <chrisl@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/swap-table.rst

---
base-commit: 9ef7b034116354ee75502d1849280a4d2ff98a7c
change-id: 20251102-swap-m-7907f24e431a

Best regards,
-- 
Chris Li <chrisl@kernel.org>


