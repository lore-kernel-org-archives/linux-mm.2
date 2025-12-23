Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E54E6FE23
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 16:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2923C6B0005; Tue, 23 Dec 2025 11:46:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240166B0089; Tue, 23 Dec 2025 11:46:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14C676B008A; Tue, 23 Dec 2025 11:46:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 002F16B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:46:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD1441383FB
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:46:53 +0000 (UTC)
X-FDA: 84251315106.22.344A0B2
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id D27B94000B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:46:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZqYDyiv5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3esdKaQgKCIUsjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3esdKaQgKCIUsjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766508411; a=rsa-sha256;
	cv=none;
	b=Kcczrrz9l6I6WTZDrq516GEARa6B6Da4ZW+qd3EjupyvHuikezjJp5ES0toqc3WtH4I+fX
	B6A5FLAYGxyXdRZXGM31F+st0v0v2GLT0VrkkBICBiPbnY85hJwO7a6n4JUQg3tC2EGLSV
	XD1shJ8J85KyyDBMhsw/RKosedv4QBY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZqYDyiv5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3esdKaQgKCIUsjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3esdKaQgKCIUsjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766508411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nBvdW4uwcY29fy4YHXaOO1CwVIkvGwDD6WuTQ//PQuo=;
	b=1YsoKIL3bpyhXGP0WfEefylX4s+7grBzExmjliN4LUP7KNwjHBXUlmskk9BEodQPlbsgaO
	/kjUSdu/nkG2KJc7gJlxgnx5NHj6dkiEW9ZUCbZFjFeU87iXN1FeGWm1Ur+W/NRVQdLBEP
	iKnpEMfKjr5XbmugrihFSJ+vMtYkFxI=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47d17fff653so17498435e9.0
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766508410; x=1767113210; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nBvdW4uwcY29fy4YHXaOO1CwVIkvGwDD6WuTQ//PQuo=;
        b=ZqYDyiv5SCLLwefRfgP17oguNtUOW3ZpuflHQlKM8Dzsol/9hoY0LbhQ+fJYULINfT
         1A9b7v8NRAeIzGT2VSs3TUS5HFI62X0MK1ORxsqi2I5I0bEN8FeCXSVaTe2NXhvQQozh
         mxonzVCvWjlMvkBGwKDbO0JTQmWjKS5HTwKETmlLm/VxNJScdH9meV8WspKSKfBbLOVv
         uFGUpBfWt+GbJ/5ZoPUMBq6bTgHyHwmdvIgS09mbT72mpPyCKEQxUo/rO+HTXPAuNvg1
         iF1IgMPeZQ6O8H7m2b6WlAvXBhqWA2qakcDLQ6o0EttPYwGeclUKDVn2O1GLXOPMabG7
         6Ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766508410; x=1767113210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nBvdW4uwcY29fy4YHXaOO1CwVIkvGwDD6WuTQ//PQuo=;
        b=O+dHmwyeSrpmBf2TfrsjY/j50qyIbBUvbcIgZQ/yT1hQGhAwdq1mQL+G2KrthpvTrN
         nGrsh22oCHCjQML85MVX96G7o7cOwztA5hUvdwYdkjT5del75qHDEV5Ijxv+n/Q1hMsy
         /gv0kTaQeq3qRXZRAAVnhgloIKwD4mpNOuBrz7dWtQ0Q1CWg7c3ln2e0bUfS46EAnUh0
         dyUW6rcN9pTYrsPZi8lM4BBUF28aCs5bbnMetoFu4zAEDUJ3fK/5zlcmOTunudhpglYA
         ajPhThpv1UTMYgVnCAJqlzqyMMqtyqb0DtGyRiumFoG8Q6mTjzAWG/Ge/jcgYZmG1rlu
         LXQg==
X-Forwarded-Encrypted: i=1; AJvYcCXOD7mrDiyguXg7nMfZGmr8vOG+dP7sPiV2xbUHOol/ylQrGn9lAZuPnDRQdMmhyeSd1JNwNriyAA==@kvack.org
X-Gm-Message-State: AOJu0YyP74Y7oGiJZqEu3dU4gQ5BNrzavu+vNfBlGKSlkAVFPdTNEm7y
	sBFKySeE4xZ3Maj4o+T3GAhCBO9p3ox9PMmXu2t+vH+i/mxs8RAxYB2c6aN0Lo50qEDivxpDbwi
	AESiySNisznMvQg==
X-Google-Smtp-Source: AGHT+IGaHQK2nt2OAnM0/DenA+ZxyNpyFw07Lmu0lVUq2l6SlAcO5cZsDiLB2cSN2kfRbalo6AxJ8d5wrveQww==
X-Received: from wmoo8-n1.prod.google.com ([2002:a05:600d:108:10b0:479:36b0:ff54])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8a0a:20b0:477:a3d1:aafb with SMTP id 5b1f17b1804b1-47d2001edbamr88904085e9.29.1766508410211;
 Tue, 23 Dec 2025 08:46:50 -0800 (PST)
Date: Tue, 23 Dec 2025 16:46:49 +0000
In-Reply-To: <20251223-b4-kunit-user-alloc-v1-0-fb910ae0e50c@google.com>
Mime-Version: 1.0
References: <20251223-b4-kunit-user-alloc-v1-0-fb910ae0e50c@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DF5QYW6E1324.1BBFBH0UQP2Y4@google.com>
Subject: Re: [PATCH 0/3] EDITME: cover title for b4/kunit-user-alloc
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Rae Moar <raemoar63@gmail.com>, Kees Cook <kees@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: <linux-kselftest@vger.kernel.org>, <kunit-dev@googlegroups.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D27B94000B
X-Rspamd-Server: rspam03
X-Stat-Signature: 93b8krmf6xtk79tidmcsrqym6qxjyz4i
X-Rspam-User: 
X-HE-Tag: 1766508411-700275
X-HE-Meta: U2FsdGVkX18DEgOnZUFgI5DalSiTIJspjTwzlZ30pthEVCmGE/n+FOw5bTXRHzclAZ2ZgTcA7MsgXKG+kEgSD5vZurOpIZ/Uid7ExqoDmK85GaZVFBhv/64hOKV4/pgLPYwdrci9ZJeJHdwlMdmz4UJzfHgZz3/QvNXQ9lAAHqB781VnV4SQc6wPXMQ4RCR7WsHSZZukK2mgPo82/jbscr6/T+6m7y683VM26nWHfvah40a9UqeJrJn2he1mTm6NDsxGvNiZn2ZS9wpzq9nkfzbfS/9/920qX3d6rcaRnfdNdH4SSzNIxZfxSa/MavYmpxaYqzfx3aIf+/7KVAJzIYt75HByRpsQCceCSQBwF2dmti1w1QTt0AIFIOPLk0J2kJjnZ41F9moJaqkotyF4KQDPxCLKJEFBEslVkXQPTBYSG+C0T1PQgj9HKQ5FnEayG892QEquTUtZk9/U4/bdJUETctE/pIW6SzY3CJiAJ1kutDmRAupPLyh1MxSBkWq+FSGAUIqrWmga+5AKj5tA3YWZjUQdqSJeSUhXyAqeNKPAE0+GVHunV1g3xt5KwJS0UBAchG6H0pGKlOQ1NVRy8TKYRQM8N/KJpGiKt2b7NDOPwmjifzsQPIvJHjCK/8Pthbxyfv7pgdsTllQAW5u6S0BFRK+88qgVpiEGwr7oc/eztZyIIN124Jzj/ztU0VbtKAL+oV5N9bLMw2bAS+F0Prq6RcwTpkEytz+2IpMLC/WhLFwOOWOPO4rb4BY21Mla7PNgfLurhhN6JRMc9zEbE7VKJVFdR92PKsWimV5NJ6Ii7PblAEZ85PZsrM5c9VQPf2xuNxoOJGT5inuCCTFgAuORohanzDLh0T6pRQPImSyfM8oLXo0ZdaibijtJ9uTyujx79soesAoVlLSc2v6iH46f6/AyQglNHxHPzFC8RTXmU3eDAoQjDJCO1T2VwW4ZqDlqiul07O/e9knjZH0
 iLilSom1
 sWkvWivjctmD8Lcw5DAI2qu2N8CqmLHiuZ8nfNcuVKGwuTfSeBuy8NsGrF0c14sUWxsFg7MLTeMbEfvSNTZOKUSpcLySctRGGK+YCqt4yd3PVOdwz1cB2MY/h5vSeBWXCDfut6rKk2XFyta15UZMA6YRkij0yu8tvun32RlpFXJcpiaFeRUHiNhgZAB8rM2Qa+BrFGAS99E3xqLCBX09ENXtCEijZpaWqhMfaOzvNXQ3EnRiZEqPy0W0SLEuLwvQt/J6lQ8rNnNpWaVsiFZjxoUzTwMYvR4GQrqwp4i5+bJrpR8eVMub/vur7bMckdWbHO2wvBdopEtSGYxASE96TOUNXg6TaHlQQdPP/Cr1aqCllrLpdMcoUd2BgRe8sT7CsM1s4cbA2YTDOWxWYiAnhn8LPjqoomUS61JizhC/BlhvCeKmeDtftBXehCzOKPXMKG6z7zrQ8ZPtuLbKA8qQsFBHlpq2dW9P9K/YuLbM5PraWcG1u2HHdFe1lg9b51uXwI3p0uz4rqNVJstEntZbZ8HV5FPRl+4eKVEqCKZNnwhsB7Da9YT011FT63MChz8yoYrNn3geBRpPoEo6uzqj0KMcZ6rmNr5EusZTQRhuqVMPv5jtZ2V2KycboXTFhN5D5KB4mSFp5uLMbP/kCqGozgTYdpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Subject: Re: [PATCH 0/3] EDITME: cover title for b4/kunit-user-alloc

I hope everyone is suitably impressed by this. My talent for discovering
new ways of screwing up LKML submissions is simply unparalleled.

This should say "fix mm_struct leak in kunit_attach_mm()".


