Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A640C9830E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 05:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35F376B0088; Sun, 27 Sep 2026 01:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3109C6B008A; Sun, 27 Sep 2026 01:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226526B008C; Sun, 27 Sep 2026 01:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02CAF6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 01:57:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E7F0C09CC
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 05:57:37 +0000 (UTC)
X-FDA: 85258485354.17.E7C59AD
Received: from mail-pz2-f38.google.com (mail-pz2-f38.google.com [74.125.228.38])
	by imf12.hostedemail.com (Postfix) with ESMTP id 42EE640004
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 05:57:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=E6iUs4Pg;
	spf=pass (imf12.hostedemail.com: domain of hsj0512@snu.ac.kr designates 74.125.228.38 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790488655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2Q7ojo/+9f8btc9QXVuwIwQjhu8wDT9QIZhmP31kU+M=;
	b=eoDbudAIfgoVPMx5CHU7vylErhxwF/6V9ZPdVYaDp+i6sTckREEK13/R/n63rdWy//WzaZ
	dw5PxwcgNDOgHC5FLHxrygXICYpuI0PA7MilEe9u3IhvxWQC0jxiEkbt0bpJxmOb5s+lK2
	neypsVfmWCKd6vKNMNrl2vNojwU6AN4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=E6iUs4Pg;
	spf=pass (imf12.hostedemail.com: domain of hsj0512@snu.ac.kr designates 74.125.228.38 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790488655;
	b=aFUMdKpvdmvxkiGaj9j8Ct5gmIRl4tUrrHN3ptsKKi1/HCWRKfEBOoQDavAEAJM6BNZXCw
	p6HDEbFxI0bOjVrgUYhGxQxFTKmuMLp6uKE6CBCOCt+PRyWkO1dfSmGOEI5u9Ya2H8VsJ7
	8Qj2stbo6NIjfNhg0WSjOm1RFEEqQPQ=
Received: by mail-pz2-f38.google.com with SMTP id d2e1a72fcca58-882c2bcef77so154270b3a.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1790488653; x=1791093453; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2Q7ojo/+9f8btc9QXVuwIwQjhu8wDT9QIZhmP31kU+M=;
        b=E6iUs4PgC+PPnDNao+0piiDYeb7i0/dSB1hD2uFuJCi3Mew0ikpvDU6UdJf26OuNUD
         tZjTazW/MzIx3t0g0Cc5gnu3KIdd0iKVJGQF0iq7LlxP2GKyXdVyzehn8gI7gwC/k83t
         f6AqGwuPUs60GNmLqxtzAz0LOkmqqDHO50pQw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790488653; x=1791093453;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2Q7ojo/+9f8btc9QXVuwIwQjhu8wDT9QIZhmP31kU+M=;
        b=IXmvw46xuabEgitPCPmCKRBd6dZv0IMv9qlpsrPIB4NcLPTNHEtR9Z1eYj169CslmR
         88/ChXSH6AX5x3RLSXWLVy2Nb+xUaKhX34JMU57Y+o1ERIgYmEeqG8XgbEFk4vzQhYu2
         F6OIef64CCZHhKz/SnBRHuF6O4RNTqokbtZjL2NGtUAXpwk6T5FBJQb+eHFjnV8R3ah1
         QI1Hbu01aUWwbpLahvyKZGOa3x6DAAr0nTqPse8k05a7HQMW3vEsCDusoHnKZsxAfapd
         G+XZqhJANpBPW42z9WTpaOwOlrfpCeTftRmk3d1Teol3W4qZfKV8pGWVsHVVv7eVUOol
         KFwg==
X-Gm-Message-State: AFuF++n8VGsNpG9GFHSYLIXsMFB2oCMtmnP5wwUL+uAhBRbmTh7F+FDq
	qIrnzvOsYauL5lH5M0UisFwl3lvQK+gYmVRfZ+2VGZGk+IVHjb7BHrfaCk6ZoSaPGo4=
X-Gm-Gg: AYBFou2OshC0s3tnfi81xWd8S+cQ1UaDxRU2dE55fuSS/XaDXnFPMZx8Ol+/euT2T4t
	g9F+rfTVRaPCwotMlm/p5HyqJHHqKPFWX3nLmtxxhxECW9OTEivelRduW9AnS6Wjhatv1kKynLX
	maormJzuSqsu0+I5pSVEAJ+UlPJ9/ICm/9fHxHtPemyDCb0zk5bOzODyaslcvM/fxRaJZMDjBxQ
	FEdFDIvtyFvQwnxqtjItQi94MtamtttqwoSx3SLwM/zASzA/6ipFHROHm22I3ZRRoEa7OuD7AWk
	C2C7O2F+k66YnsKsNyCu+saqh1jN6rPb+Rtvs9wtl3ImVEfwuXABW57Phzxunb5p4aA9UP8kE97
	Cxlz4qu89MpXyJ9QKWeP1+ojSnWH0PL7IRe3s+0Y58J7x0kHsddq+naIGxAKtAV1Or30POc5qTe
	ORRxB2k1s3hG4xQyqXqBO1kjq8fEjxiY9LqC1b1XkxfYxdqjDVt6HGRwT1YQcTBE+E
X-Received: by 2002:a05:6a00:340b:b0:857:7337:5db7 with SMTP id d2e1a72fcca58-8802a2b91d9mr4532210b3a.21.1790488653039;
        Sat, 26 Sep 2026 22:57:33 -0700 (PDT)
Received: from [172.19.0.2] ([49.142.45.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8808182fd7fsm2328266b3a.39.2026.09.26.22.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 22:57:31 -0700 (PDT)
From: Seongjun Hong <hsj0512@snu.ac.kr>
Subject: [PATCH 0/2] tools/mm/slabinfo: report sheaf and barn statistics
Date: Sun, 27 Sep 2026 05:57:26 +0000
Message-Id: <20260927-tools-mm-update-slabinfo-v1-0-a4ea0d4dc136@snu.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEawuGoC/x3M3QpAQBBA4VfRXJsyq/y9ilwsBlPsagcpeXeby
 +/inAeUg7BCkzwQ+BIV7yIoTWBYrJsZZYwGk5kiqw3h4f2quG147qM9GHW1vbjJY8W2z0uqqco
 JYr4HnuT+1233vh8w9vD/agAAAA==
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Seongjun Hong <hsj0512@snu.ac.kr>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 42EE640004
X-Stat-Signature: r6ai1mr8ybaedztzci14cbm4ufym349y
X-HE-Tag: 1790488654-231010
X-HE-Meta: U2FsdGVkX1+eDOM1bBpkO8ETr7Bsm/SWuf4snztrN/Xd5ENOGg4OUyDIdymmR65Nf+RCO5lqlwSdA0BKjfK94E+Qf5ZZNww6mwQtmA7j3DZW0CMceRCe+m7mxxNKYrW4nI0LW03+VGAnUwwFjblB696w7l6JRhbr5g2OREYSwkjfNhWA8DjDojJLoXmk+f7wP/+RhfA8BDlHKMvZXZ9Q23ogXL4MEaeBCfaR34d+18UZTbrn8JdIP6BF2ezcDWS0hw6J80C1Q7tzEHn5pnExO+636XilDfzog76PDYo4XlC5tBfrFCWsabz8/a4oYKx5vRwyLLeoPRiq8Raqh/1WKRbDUtb6Fi3RzwougUJpBtXjvz2rKCXoo7YQRYAOh8hMP470qDzg/QZOwxTlvaOYcZqC6r8RtPI8NQEB4/PpJJo7lSpMeIxqGRJmZtpqInLz35o4MfCrRkUcgmnIWGNwkMq9bvEh2zYOLoZidoT9ecPhA3O+fLRagbT///JKTRwZq6UaTdzn/fz6i13xuNRhQnbROZ6KAPEfMzPW1m9E8RuBiiQpGc4JskLSLdnx4vViZHrsC4SoC+f729Pt6q8VABocPo0jgLgf/LOA0Ktg58uA3i/erjHz6JUmFKQnD0lF6Agh9zCmJtOT1j5HWG9ofyZbIv1g24JaEu0k8+Fg81k8dRkPHEK+qivpPhtea2tsuXnvPQ2CpBm79zzg4WQ7PbNAKOaJAgJV3tdr9KxijBzxb2OMLLOP1NjWDxy+9MHdxArpVlHou0GGJIuF6vV7SJDTNnHe5Krl5ICReG/9UIHG0dBubKHx/YadHxQIsI6VIqmRwJ6WUAB27kg3zEk0pGR3S+b7Z60sWb4EV732S5uIZ9EyBmxUqYVontJ/LBuaArhQcymvR9KYDxVFH3S+jzTrubC1fAah9OMOb3Tq2Alwqa2asUn9xyq8UpK3DAbPTlrsa4ymHpT5Q3dH4cT
 7nEJegfh
 p0ZHepiQ6dZnMmmmoTTi5z8JmKyky7LGq0kQWR11PUvPxp8/53tm+qJye4Gs/JigMLJFS2kgrKKYRxd//H/g17DmAOYuRwl227gEqvEeRFInxeyZz5fAOApvJoa0MYFSHkMo3E3mesBLG9rBhkpeZH4jGM6hCqhGRVYyOdxU5IyYnNWzcVzoMUN61kU/3hrSIOQ5/Oca28P0XH8sL0mPuGe44qC/k6L5voOsfhPou7ASmYUFQ1n0p0sFwyIUdyqTPCw4UQl6F/x9aJvOIjExcaJJhnlZx8JLhblB2azumrMtaGQQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 2d517aa09bbc ("slab: add opt-in caching layer of percpu
sheaves"), kernel exposes sheaf and barn statistics through sysfs but
slabinfo did not utilize this information. Make slabinfo report
kmem_cache statistics including sheaf and barn counters.

Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
---
Seongjun Hong (2):
      tools/mm/slabinfo: refactor slab attribute reading
      tools/mm/slabinfo: report percpu sheaves and barn statistics

 tools/mm/slabinfo.c | 303 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 189 insertions(+), 114 deletions(-)
---
base-commit: 9b87fdc9af2fbfcdb5c24a64139685ef80f6573f
change-id: 20260921-tools-mm-update-slabinfo-8eab37191831

Best regards,
-- 
Best regards,
Seongjun Hong


