Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A97C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 10:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8076B009F; Fri, 10 Jul 2026 06:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8E46B00A0; Fri, 10 Jul 2026 06:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B016B00A1; Fri, 10 Jul 2026 06:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D67AE6B009F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:42:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 584BAC2242
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:42:43 +0000 (UTC)
X-FDA: 84972528606.18.85E73D8
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7CD7180003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:42:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KIvG+GlJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3n8xQaggKCNQ902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3n8xQaggKCNQ902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783680161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XVV0CZtE+jAiIp2jucN5t1l22tPDkrJA7DCQqcEcxvk=;
	b=R9FN/dmz6gK3nUaPgxxa5e8L3gUA8yYzWP1wwoZD0+jyrohDS4v19uLv9Lvc41eOmWpCFl
	0xFYuVFLbwFfxYwG9Z4nhBAPWpyBuvkdeBST/CcDte2cEcCgUAkVkLZoQ68pYGuZFe9fC7
	FAZIQsSXbWHeBlnvZPq8XfVvECFINu8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KIvG+GlJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3n8xQaggKCNQ902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3n8xQaggKCNQ902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783680161;
	b=oDNBVU12v3BW4qpAKSzqRPCqeM/qnms/jt0zx9ATnCAwZtEUeUGyf7USuYoO0op1AYWFTn
	CoKJNhMoYVeJlfbQHkNDOixPJCW9l8nQnpa2MvpicbKr1dlVe8M528WJPSGDsfzHbOR1Z3
	g+DcUYspYPZJ0tVMHLPbXPbLjyPhXiE=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493bd52dae6so4894355e9.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783680160; x=1784284960; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XVV0CZtE+jAiIp2jucN5t1l22tPDkrJA7DCQqcEcxvk=;
        b=KIvG+GlJHyQpZJ8fxWozJJ4TK3GB867eCooPDm+NtuLBKAFHGr9my/HbM+F7zKRxcD
         zudMKDlEg7xnRnNq5JI2CCeqyiJqohkeCon9hb6URXgtwAIVP/W9ZDKx80cp0xnzBei7
         HP/lDG9lGgqLddFfHyiH9JPhc83yAGOZAETTyCXSCicySLVE3RW7XbmmaisOR+VON8MU
         oH+zK2LqpPDeNM3S3MW+R1SIl7W21huOciAhicfxBXV277V358P1IGK8t/pjZiOAKTDd
         6Jn5EBcsiwirjwOvMnzbbfl/dprhCOqu7MgI20qNIwCDmR/LPC3IZAA4Oq7oLLEdyb3Y
         6T1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783680160; x=1784284960;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XVV0CZtE+jAiIp2jucN5t1l22tPDkrJA7DCQqcEcxvk=;
        b=VTc8SJPhLAZ5SkSgNRTpbz/xo2/X4Vj1mHta61svHZhFkX5Q9xS/Mn0SFBYKcknGmA
         X2m7KWqELX8WWK0WBxRzHlgIfyeDb0SyER0l9vBuwUYzMKxW13KgogAT5kJf77G5+M2S
         jF+gHHn6ArXkTELMegxSKvj2X1fT0wEDY7QvuLE42YggQmpehZrx6JZzH7hhPDR2VVK1
         dPfW4RKPAesmNlRlR/APlp0EDeeCk9emmVMZaWBO8ZPN5hR+47mUbtiBfsf9M5BGDp+B
         OF3n3VuMd3zv4fyyj1nDxKPdloBus3ki0fPVs2cK+VqmtocDcQG/SOQ5iTFGGHqRtAzR
         Qiug==
X-Gm-Message-State: AOJu0Yx5cZQw/wc6dpETAo4uzgMgZSKZeXe/4h6Y30bWiNtwf2sUV4O6
	Wi6wi3sb5XmvQKWFAvHbWMz42IBrUg1jr7cKkK0knBsAw0wp0NoxJ7sI0ue7N/qvozAxZN3sRJM
	rNxdGDTPdnilETQ==
X-Received: from wrse13.prod.google.com ([2002:adf:fc4d:0:b0:476:4ac9:27db])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6217:b0:493:e9c2:ba60 with SMTP id 5b1f17b1804b1-493ec7a7a26mr63789625e9.22.1783680159801;
 Fri, 10 Jul 2026 03:42:39 -0700 (PDT)
Date: Fri, 10 Jul 2026 10:42:19 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAIvMUGoC/yXMTQ6CMBBA4auQWTtJaZMSvIpxIWXQ0aZtOvyGc
 HerLL/FezsIZSaBa7VDppmFYyioLxW41yM8CbkvBq20VU2tUBIHHPPmo/vgEL2Py5TQGO2ssaT 6toXSpkwDr//v7X5apu5NbvzN4Di+0UfLwnkAAAA=
X-Change-Id: 20260710-spin-trylock-followup-332c636e0d99
X-Mailer: b4 0.15.2
Message-ID: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
Subject: [PATCH 0/2] mm/page_alloc: couple of followups for recent cleanups
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Harry Yoo <harry@kernel.org>, Alexei Starovoitov <ast@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>, 
	sashiko-bot@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A7CD7180003
X-Stat-Signature: r5sfr64bxpcpzknntpmgrir74qbmkebm
X-HE-Tag: 1783680161-319484
X-HE-Meta: U2FsdGVkX1+ljyK8WTFE2KpYfqajCODsi7E76FCXCe8Jks3QX5Bj45O0zigwnV65tU0p0qukFojyF+OEi05BoQCQLbNcNVoPTEPfHrrY4+1YZ4bLQrpOngWmupuTdGAqjxOzcmGDBuz8TgSf7rplHvzyXZBSQmmEkOlWJQ2B0Ayh7GwbGLHTUBw51YObklDr9KATWL4t21tr2SKsJQv/+R+luzWzcOfbLYBwskQ0dEJUyAic9tfRnY4vEFtxWhisRhdp/7NtUwELuwWqbNWj55LNAgvxJm6sc4OQZwqQyV5E/Zi7ZVkgRVdqDyDRRjsexvdW13fOTfyGRBONjR39Uo1++g6d2rWg9DMcISyHJfluzV2+K5oqjhpMrulvBT6oMu5IS8+Ya2fK3HLUsl7zeUVOA9FRt0GdyjE9uAr1arkoYEbVLgXnq7K+27XMTYnVRDg9kD/EZHYmPncME6J94vXyDCP516LLTleg+/Tz46Geugc7pLFEOJTjZqCK1DYR0iGCPUl6yasnEU3ePpYUU/mOciY5Htrrbq9slIinelbUfdrwrAUjpfRV828mpzJbldAMhSinF7LSENX+bmFNvxW/ENWLHKI7XBPzlfVooYzTqn1ZCry22y+eUwfKSN7RpE3ETAmo8qB3Y7GhCHBQ9daI71sMtK4SNdi1rncHsUiYwnl0WYiFFa06H2O7l5H2UuTCvCe6LVLeiFx+QELwzmnbMCvUq/Vh4WXkAC30PTLY3q2RJ0ErWARfJ6E/o8IWea5twELkG+661eN4qBIKKrTHyjz9gQRc32Qzn6N9vzYlMVXhPo1isT+AFR+9lxb2mRb8Uu/fml/gvU3ZDTzaGQdfb2IEqT929Ral0SmyWAmJzJ7IcQHHlQotcfmfQJzqh/DgIXShK8/f69WlZk+TPfKD14TpfRqzbTPn54WDQxNEYfH/fBrPTvNI7eE5Ai0ZGYvpdZtWU4d7PASxJww
 XamQaMnr
 z2Iv27VmAWw70UUfW16lnqQdjW2CZU9wRtwFaDeYzCf3cyRGR/StVArFbn3HdHeOZ4JgbfhPgj7CGOg7Fnpcdt36LqNrzLnjPPXkjhHnA08Kmy4rYwgpQri7zKJHHmMZPNlM+lzaLtQBreDjBM+HRT9+YDynSvEjm1JUrh/a0pvu60EVVd6wThg/muPi5nCCCOVHiQgF76dUkH7yxswfQvoQwyBr93d3QWE3FSbNk9zoGkX0udBE2drcyU/P6HiQRc7GmRXeCJHvweOhild2XUSIkSyw8Nd3vXFqat91rHdrmbtg+9Tvdy5tQQB6lTqUoWjRrcmTRbABGp2mV/OgewYnyy9+YCxO/QkOTo8XQLWp1thBGgD5vKpsDT/fGLCr1xjoOXkkIm6fBQ4x3Sg65Ee+r/CoaojWLWcUXSMSXCtWbFeNoREZblq13wGr++694/YGFwNVJITqNYtJp5m9RG0zWaqNCwIYXoeAbhAIMnojzlTNwUB5Qh1pqrw7qngxkms92HJscaMb7qZcY0QrM/UcgAmcDpmxlKrAXe2W3cJGnJaoEULAx2g/CTw7zzVvUBQLm52RtTCPlnKVmC3UaKoLasxkVSEGB00GxNcKZFFCB8ezJ73WEQoCpUrubNDqCh7hOEN2GSZL905gLon/+UEAihu/unHuLJtlEGfCBtLz+TZ3Y6GnfVPOPag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These patches are technically orthogonal to each other I'm just sending
them as a series to avoid someone needing to deal with the (trivial)
conflicts.

Based on mm-new, depends on
https://lore.kernel.org/all/20260703-alloc-trylock-v5-0-c87b714e19d3@google.com/

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Brendan Jackman (2):
      mm/page_alloc: don't spin_trylock() in NMI on UP
      mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK

 mm/page_alloc.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)
---
base-commit: 9d6a99520ac667ab6c1dbed364169b68d38f1a5c
change-id: 20260710-spin-trylock-followup-332c636e0d99

Best regards,
--  
Brendan Jackman <jackmanb@google.com>


