Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF48CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28F866B0093; Fri, 26 Jun 2026 11:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23FCC6B00DF; Fri, 26 Jun 2026 11:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1F66B00E0; Fri, 26 Jun 2026 11:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBAE36B0093
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:53:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 464B0A035F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:53:09 +0000 (UTC)
X-FDA: 84922507698.03.22AD2D7
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7880D40002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:53:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jIR1RF3c;
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782489187;
	b=MNuu4/RYDqFkJsJY8a5TksrAdKAT04UtH9K4PrQCanl5LlMeXFXKBKNRu+nypswGT4c37C
	CHGT9ca7H3eqCKBP4CDjP7rS0im37drTTpTjYw6C6Ak5+L4GlbuKTeZU3SQLPeh2u7ms3o
	RNC1yBlTokBeEkjgHA36PMYgiY+/ewU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782489187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=21zdTXnN8j9g9E30mY+sGQ4wNLRdAYxZ+MLcSTpi/9w=;
	b=PiUN/H3gBJw8ww73iBCMf3TU1lXJrjh/wrDTPqnhVOCcOJAjnZtI44eP0ogZgconX5+fpC
	LNLs0L54LYk2HO8sIXzvq2hcWju7aTkD1NIpc8hNGYOLZyYrqWotcYInhAFRZRe5SQ7jbE
	XXnoN60RiAuQa4KgAG30X4WPs6qjGzY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jIR1RF3c;
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=21zdTXnN8j9g9E30mY+sGQ4wNLRdAYxZ+MLcSTpi/9w=; b=jIR1RF3cKKQEDZyIewZ4PN6quP
	OIEm0YfLCIJw5cNA5/Q3m3FxI24XdfaYzVLzK4GJqhB2WKo9YjVvoIu+VJBwh6XQnIWns2LEegwA1
	Q+J/RUpnEM0DuAh2Jq/FNlyTaEVSUOhFN1hf3MjD22Sw4rbicZ0/gSEHH1ofb/MWwR1eAhaEvUfyr
	HlVx2Xg8f7XPyYbIVBZDZfQAHm5wI2GkYf+nstW/Rv8+xKVp8hhMjNFw1AFK1/rXI2JJW2Ri2trI1
	4mxI3bWzBT2I0SULTcW285KYovqFQI7GY1i/0TTx7EE2HHnimzNSI34W4qCb7wS/A/Jz9Di/KC4vw
	8rhEWaFA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wd8rX-0044nS-2S;
	Fri, 26 Jun 2026 15:53:04 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH 0/2] mm/kmemleak: add min_unref_scans to suppress transient
 false positives
Date: Fri, 26 Jun 2026 08:52:01 -0700
Message-Id: <20260626-kmemleak_twice-v1-0-ab28f7cc0971@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACGgPmoC/x3MUQqDMBQEwKs89ttAko8guUqREuPaPqxaErEF8
 e6Cc4A5UFmUFVEOFO5adV0QxTWC/E7Li0YHRIG3Ptjgg5lmzh+m6bn9NNNwsM67NjHnHo3gWzj
 q/w4f3XleAX3XQWAAAAA=
X-Change-ID: 20260626-kmemleak_twice-ed01218aeccb
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1844; i=leitao@debian.org;
 h=from:subject:message-id; bh=uIuxE1WiXTZSAQtk01gH9qzDdqb3u0v+kJWkOXGnfCQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqPqBboewZLnOnAOQUwx766xin61f+L5f82gW8Y
 V0FafLSWXmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaj6gWwAKCRA1o5Of/Hh3
 bccvEACBYoMAaTFArpKHYgLUA7KVEYv3QxBGgZkuOcydvUi3kUnTxD7DpSzD1XMoy5ltAIjgfgQ
 Tq+2xY0o/sssBVhJ/O6JL0U+88NB/1iVL+Muq86ZlD+rT+zM6Yqy2ZEUGIEAI4B+rNBkJfUMAa5
 YWbGJCskGq4pvFL7hlcLXFk+SR63aU3bydE1yJiJRs0KiAcKZPlahL3S1cPOCC1PuJWBbwvbXtj
 mvEXyuIes+Az+dgema5xcMd3Mtssxqq9Psg1/82uLYtZWb4Cxd6ausTOWjNlxUusz9KCbCb2M0Q
 hAxWLwm1MKUjD6BUdjcepyzp02dTt+CzMOyeJ1Er8WFHTlWnyUGzYqz1RKErFiFI/SwFJY0RGa8
 6OC8+NFIEC1FV3yG+anM/30kG8YkvB10rNL8CmFyG8haWUGkTq0hlrmW6MODQfVxaPOL5TOCBmX
 y7eF4nhwPUNawSHn23Fo4+sUuzDOJ7joBoAA287//MXvnzqk8EEXEyAP2xqdImrtqXAlNcP4GMY
 IaYbojOXP/LMyAA39PQrF3wlqBZMLUBS7E/z8Cv9WRJivsc8FUxhLYRN+9cNjJFZJ0NOSBIhwZg
 ZyqHVcNwQ8uCTlb++CqmDkdRshN8RI0opTgfOb/2eeWtF4Gjt9STqAAEQcw0qLg4fMqj3v2bwMh
 a9Oyeso4xk0z1dA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7880D40002
X-Stat-Signature: pk97osnoax1wbghjymx86xzmhnd4rk3e
X-HE-Tag: 1782489187-111047
X-HE-Meta: U2FsdGVkX1+gTUbFzpmvyq6SiK0ScybxjSsgd+k6aq2hveLFG5KATRODTd5SR/6D6BGjq3TUCKmtx338UH+2GrkTVZfzb3Tg0ONfW120o/z95y6Vm3D5wD9Sjh/4vbkCJu/gqjyMr09zih0e38zCjkJ1sOjLPCPX9jBISbCeTLkzNZWD1i8ut+UOkdCy4eeJPWAxSOIjJNtG9FK2MKsxb9ztjlPLcnQ1UQK5i7m9vviqrEOU3q9IkGDKgfTxTbTsyzWQ8ZDFXiprnUV5Dpx5Z7ia1k8Yld78LDeihIQe2XIMMPIxYL9e4s73o6i7UUmw1PQ4wqlupzwirQjqgWTLbTRxlmll0WkPMJ7TBuGEUwQwov7VcIO7JZukiJxZDz6TAf9Dqesnz85XOXBuXZvpzdjnbThwp40kfhwRpmCkXLtv3pMmFJ14xrNpeRwVa9SSmzU3wne2FuraluAPWHASGVwjw7qGU2r4izYIiBl9ikyQZMObeN9KaEQGpwHtsuC0H+pcIU0MfI4+/RzBBLQ6bKFRAo+9A7iGcsvtdHb38vV9WwS4JdrikBl3o2fE89Fsps8x7e2yv1r7mr6QcJxsrnERAKbOAo6Z3ACTrM8kH1ppCC+0d3iwh1AkLhvA1idaIAh+d2PepzV0Bn37c2oAd3N3Y7afbCdjUBs8qSSAvtCBB4enyWQxG9ZcWQdr0M99sjsuJMPsd0RygAhD31Z/eafn7fD3FDOocgvy8mtnU5bj2s6k5j2S6CtxB9omGf9Anje2Me/iW3NgtaUbC3EohXujDOHwzpk4QX/Vg4sYUABSCpNeKlJcZzPhyiDtnavvQ0u3xqtn8YfcPxeSxKjCrC0tJfNVM1dWSQvKJLQ8ujDvvjpvTeHB/EJH1KfbiZgdbkzWZ2vZqUCeLDjSMLP+QoCIkpQ+WAj+yYZMMzTZRqs13qK0i0I1vpyoMy20LGjIdpk2gDG1hV9ydK3R6wk
 1USz4jRN
 9a8z8ZYZ2L1t475zYFDQee4Yg9SgzRKtB3oYgbaF3yE8s6UXA940Jb3NnDqWENwkyApHI87Dd14c8YGmywWqisEinaUTK5m8xAWqgsGTHtb/Loak3WtYntOKfoCzniHYPVCni504l91V7cyp2xalEsym43WZTA3M8nsd+bQXgrWRbiFWZdE+SlyaY57Bq0gjqr6KqvI3EskdC9XhGxBi0117UyracFJbb/D7JzEnY4BELi/xXsOfmzoFoSx3qn3+RfOg0x1bNZEWOH61PW5UUk1OGRlP+rfy2ZSE8Jn37LrE11PCe0I6o83xuUugIOxgrCn8mDpk2wAUnY7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I have kmemleak on some test tiers to find memory leaks in my fleet, with
the reports dumped to dmesg (CONFIG_DEBUG_KMEMLEAK_VERBOSE set). It works
super well.

The problem I have is some false positives that show up from time to time
and go away on a subsequent scan. Something transiently unreferenced --
whose only reference is briefly invisible during a concurrent RCU update,
e.g. a VMA moving between maple-tree nodes, or a page-cache xa_node -- is
seen as unreferenced for a single scan and reported as a leak that does
not exist.

This series adds a min_unref_scans module parameter requiring an object
to stay unreferenced across that many consecutive scans before it is
reported. Basically it is a trade-off between report latency and
reliability (false-positiveness?).

It defaults to 1 (the unchanged report-on-first-scan behaviour) and, set
to 2 or more, filters these single-scan races while still reporting
genuine leaks one scan later. Would it be acceptable upstream?

Patch 1 implements it; patch 2 adds an mm selftest that drives the
parameter via samples/kmemleak, in case this is useful.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Breno Leitao (2):
      mm/kmemleak: report leaks only after N consecutive unreferenced scans
      selftests/mm: test kmemleak's N-consecutive-scan leak confirmation

 Documentation/dev-tools/kmemleak.rst               |   8 ++
 mm/kmemleak.c                                      |  14 ++-
 tools/testing/selftests/mm/Makefile                |   1 +
 .../testing/selftests/mm/ksft_kmemleak_confirm.sh  | 111 +++++++++++++++++++++
 4 files changed, 132 insertions(+), 2 deletions(-)
---
base-commit: 30ffa8de54e5cc80d93fd211ca134d1764a7011f
change-id: 20260626-kmemleak_twice-ed01218aeccb

Best regards,
-- 
Breno Leitao <leitao@debian.org>


