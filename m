Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2087BE6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 04:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F556B0095; Mon, 22 Dec 2025 23:42:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2716B0096; Mon, 22 Dec 2025 23:42:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D7726B0098; Mon, 22 Dec 2025 23:42:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 290346B0095
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:42:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C86881404A6
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:24 +0000 (UTC)
X-FDA: 84249489408.01.C5F4B42
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf07.hostedemail.com (Postfix) with ESMTP id 34E9B40005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AGeI+Jsg;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766464943; a=rsa-sha256;
	cv=none;
	b=RHm/UNtmxM1N/Sz3tMxnLYzfs0XjA8O9M3XajS6gfOyO44NP1kaZ+OO9acIyBcmCWCGOgo
	cLxVjzKGv/odKv6H8JDrw4iIcdv26ES2kNIENybU2CPQxyV1ukgi8zTkf/jsJoJ7sz8eEx
	CZyEFqhpP6JB852E8s7e/LN5HJYH2bM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AGeI+Jsg;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766464943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdqb/JrWPy4gNeCuNrTpT2xWXxvnkmMMxVP8Vk0ZQYs=;
	b=uQD10V+ei+RHfWUcwLPDMxqD8f2KIVhxYJPzWNVEtNr9kVmffxKM5bA/LgI5cduojUkqMH
	XpQdIL/R1svjdlYTKmWDBDtCKpryle9urfJNrVZBqtJj6uSsMB7B7X8Pf+tlC8msToUJR6
	JaaXU6pn4p/y+joA/FiJtbsxDS4CV5I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766464941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qdqb/JrWPy4gNeCuNrTpT2xWXxvnkmMMxVP8Vk0ZQYs=;
	b=AGeI+JsgNMI5ozsGPbHsoSoJHX2jIdnieBl0qxej2677xZBJX/skO2HnWMpbECOefcgf26
	L9PgVQYaPSt9MWdzb7T2a2q4eoYezn6jRU7PxO65zSmNNEizYQj8+N4PdHMn3DvjNu50KA
	Tnyw0NH4hZrfpIQejw5A+VNEk8vH/rE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v4 6/6] MAINTAINERS: add an entry for MM BPF extensions
Date: Mon, 22 Dec 2025 20:41:56 -0800
Message-ID: <20251223044156.208250-7-roman.gushchin@linux.dev>
In-Reply-To: <20251223044156.208250-1-roman.gushchin@linux.dev>
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 34E9B40005
X-Rspamd-Server: rspam04
X-Stat-Signature: 3ozojfopi6yo9kezjekrejdcugte3ih9
X-HE-Tag: 1766464943-223083
X-HE-Meta: U2FsdGVkX1+SRYmk+/2bunyv1NVHbRCIW4kJacGFJYNYm2JNEgEGQ6yhgeFbV3cPeF/DZfC4MI7nR79yA803+fCrvjycYOr6gtgF7aByjxiZPHl8ACjC+jXXepjuuCyt8MnelIcdJnyg1REjymAibhV6OnLLpsvnjjlDfH3xEvRfqsH4bZG+IbMseFGx03yu+e4uheMFFZ8lClLWLMQxkwQMUpxUc62a78BkleMwlWAWHvKoiLBuqIKw+xyNTIxWVZ0TsTpLNgBAfJRWOpLjdvfC0/SO+LG6zzNlNsSEpVFUR2CkMKEyjMCiNMT0/3Zj+I93VVg+et6Pg+ytw0FaJIgNC7ebgUtj7NVzEhrfapH16uaCCBhtHZPbsRbIMGGDnXaq4znkRPZzHnHJXjeh2GuZu00jbcd349uaeYHjx7/0qQ9NEi+/WVuhvS2VUj8kG5g5p5wweBYnW7wFHzDJO7vS3itg2mYwQYXkOzweSYkT3Bc7jX9B+IjyY/barkaqb9BxEzJrBPLydAWzGYDysf+TjlpZUiFptbD6HuyWNhS8eVO7tklAHBlg/twAf9Udmz3a1PZWpXyZLWH16wffKKzhvYQtTXZIeZBGl/trJcUEo9pxKX/4Ey6yAzhFSoqXkEDvGPFmHATQn913vX0jLgmJANN9GiaTHoD26aW33ZPGMFV7wpiGl0LJnr7EXb9+llWl3sYC7Y9bDhgtEMIYkWzBYy9+aeI/RgB9TdXAtRUmrDttYGRBy/VtlQe6joKYRfZcE9eUe3vvqLVnejkX7RmkYbNoA5M3ZZMKk0pugWHw5HHBWN3wv5YntV1L/vv1bApM6/cinXwNjDu2Su9MW8lutwUkJFMm4Z2Et7v8HGZUH/DGQRW42fA5Ws76aY8hSPNpDcvGRKsa0Kjy9Na/33C/O47ZwJ3f4oVOB5EJuIG52dZ1SWzAFV8HJvM9NxHNdpl3PcG8krBDI5uK1ln
 1ZcjptB8
 6YG1R6/WBjemOwECRoY7jdd/mEIkc7cd7m4rsEe/RZfQ7fhVlFE76my7LjRAkIvvnlv+iCfY5jt8Ws5UZ3YMYccnSiTnoKNQmQaeoBlBV5asjDWIeJhw9fzpvEZckJBnrbIzUoLRLkpJjXHM6Vnt8/M0CLd4Vxehnw0JBkS0F4qOyHu6qJw1iuzn5DzRly/rFO1LznJTnTfaFMjqOhJK7w+/ovNdPe7+B61niqE04WFnrKjTWXuY7wCzypJKpPSF6Y4f3Wu5Y+zYQAtNljcdspi3aIX8f+UgSDYkyG3l60s4XCrRIdwJ46FyUkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's create a separate entry for MM BPF extensions: these patches
often require an attention from both bpf and mm communities.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e7027fba97db..70c2b73b3941 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4799,6 +4799,15 @@ L:	bpf@vger.kernel.org
 S:	Maintained
 F:	tools/lib/bpf/
 
+BPF [MEMORY MANAGEMENT EXTENSIONS]
+M:	Roman Gushchin <roman.gushchin@linux.dev>
+M:	JP Kobryn <inwardvessel@gmail.com>
+M:	Shakeel Butt <shakeel.butt@linux.dev>
+L:	bpf@vger.kernel.org
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/bpf_memcontrol.c
+
 BPF [MISC]
 L:	bpf@vger.kernel.org
 S:	Odd Fixes
-- 
2.52.0


