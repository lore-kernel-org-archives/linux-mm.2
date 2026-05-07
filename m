Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0417CD3442
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 17:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5AA56B0005; Thu,  7 May 2026 13:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B8A6B008A; Thu,  7 May 2026 13:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFA5C6B008C; Thu,  7 May 2026 13:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE52F6B0005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 13:37:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 524621C02ED
	for <linux-mm@kvack.org>; Thu,  7 May 2026 17:37:25 +0000 (UTC)
X-FDA: 84741330450.27.4D9DFE8
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5DBE52000E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 17:37:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NWhWdRn8;
	spf=pass (imf13.hostedemail.com: domain of gustavold@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=gustavold@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778175443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=INZOC0Dl4Lw7fXNJfSILZ6zRGX9c7famI7AzEybdCC0=;
	b=tFb4gJ+jHyatB0Hd9qfOiifCL9RbNVVyZGkPPQnU8mbT1pbypNA17oz+G0V9PdFwxQhcli
	/hj7BJdqFbZzJj4BqWVEitKdelyZoIa6JHoCNppcPK0gI6dx5X/T4TBZUXQC3hTnBmCSOv
	zHqnKTwaSzKZInA+cMu++ho7OAeHeBY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778175443; a=rsa-sha256;
	cv=none;
	b=ULk6cAsLM1VYwbHbT/tXwUnb4EvOICzKHDCEHuA4frSpqAZF4u5cJPVX3MqFBMLg5DeZsy
	OmLGCx/FA2ADTN0chtY2mHQTZUnWbI7n4e6KEFX3XhKiz39g/vZww6H+ajB4W1XNlcM/GA
	4DYNwtC6WWI041prISZfLEKL3rT9WnQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NWhWdRn8;
	spf=pass (imf13.hostedemail.com: domain of gustavold@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=gustavold@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891b02a0acso1203585e9.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 10:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778175442; x=1778780242; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=INZOC0Dl4Lw7fXNJfSILZ6zRGX9c7famI7AzEybdCC0=;
        b=NWhWdRn8ACSM5i9yJdz5fxcgf6llSeJBK/vabrli/6f6zI3m7dwLE+TYMxn4/5Y0JS
         ZsHnTkWT2r85fJR/WiG5AB5x+DoYe/j34Zcgb4DrabaSABjSHz0jlfws3VbNQWfvXGFV
         V17IitQHwPafS+DUeXHqUJvvuoGpwze+lMofJqfuUJ9DM2v3K8p4ajlCXNQMrzG3McxU
         lJgRIptfNJaWY61K4vTrl2XvCwe6SV/23CayYSZ1rPxvT1LnJ1MUpOi7n58/2+jVdecf
         gjenRS8rJVxKlP6YLeA8KUelH4amqs16kgVgYqyauzMnV/WhDSHTgkx7uWVZC08HludP
         jSAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778175442; x=1778780242;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=INZOC0Dl4Lw7fXNJfSILZ6zRGX9c7famI7AzEybdCC0=;
        b=YmSgtWrmeQSuSei1xn2Rh2nghCwcg4+LhxTVMzUdCjqoXWsYvDGA4YINkJQ9xv++/X
         lorfQ+xxscrmdPT+FFlmSCNO4zXZFKkhK9sx1TracalmSOrvhCqCX/ZsLBNVO18cr2Ic
         cc6aE85pqTnxbLHrFFUhlC6nwnYR3CsMS7ta+jyvOrv/GX12JxMxMQMeo03anXsXzH9G
         Eys1MWK4tTtcJrOCzqzGn9qV8yluzOYV+4/YLbGEc2reeTvGA1+2wOPdFYnzDUmEvPE3
         t4/GOmXyc9E+yFt3EIrQNYPZJvIh5Jct26OfbsUzI3OBG4k4cqlNvzT7Bv9RhHuAp4qJ
         qX4Q==
X-Forwarded-Encrypted: i=1; AFNElJ/fBSyPZhpDMv95XkdKObVy0AQjUlil5CqAM0Kn75RVIKF/hb+3aqmySVpjnq1LaOxntV2RFF83jA==@kvack.org
X-Gm-Message-State: AOJu0YyHPdlFqGFIYo/7k5cz1JO15PPSlr03CBgD3KS85uAGRLRmq3Jd
	dk51kBkzOC+pCxQypWLT1tzkGfHuJ4novqWiGRcVVG3ximvAA4EkqiLs
X-Gm-Gg: AeBDiesdLJxAy6ryllGuYaur8AFGUOYnji42vWjZALvwNJNk8cHA7hFuBOgm56T+vY5
	TXkTvu4nwz1tdpl7NhfX2zOrVwepeG+Reps5fBANFlzm41FQOIIbloDJR+459jTAf6QV7DAfkMI
	Ny3vzz8mxN9/TUANuTVbRPxaB2+CSH4M/fZpQvVScVkuBWqhwqg2wwI+XeDDCOo9Vd6gavtJG7f
	KE76Oc5sN3bzGP4zzz9MT8E7tGFU9bAbnz3SPnffCm22VWg4+NbH6ljLSI31gJMiODGXiilunbx
	Vs8cfT25RErNxraLiBeGQvyEKE9vNgXt4cm4LwJ5kH1Vitfs4+yUz11s1S6142s5DtAa+i5BIlj
	4c3KtZtDxSSqkkjMvl57oeaNdn7niO4yeM/kMdAQ0pSLW3Bu24OPfxEJVr3cgg8dHJu7k27BRI7
	joLXWUBfVjyP9YES+wpOgOgWw0n/LTfdo6T/XkYA==
X-Received: by 2002:a05:600c:8b16:b0:48a:5758:7999 with SMTP id 5b1f17b1804b1-48e53293f81mr63501035e9.4.1778175441163;
        Thu, 07 May 2026 10:37:21 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:2b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e5390f854sm133308585e9.14.2026.05.07.10.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 10:37:19 -0700 (PDT)
From: Gustavo Luiz Duarte <gustavold@gmail.com>
Subject: [PATCH RFC 0/2] rcu: Add debugfs interface for pending callback
 monitoring
Date: Thu, 07 May 2026 10:37:06 -0700
Message-Id: <20260507-rcu-pending-cbs-stats-v1-0-8f4eb3553bc9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMLN/GkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDY0ML3aLkUt2C1LyUzLx03eSkYt3iksSSYt00c6M00+REA2MTQ1MloN6
 CotS0zAqwudFKQW7OSrG1tQAfiBmzbAAAAA==
To: "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Breno Leitao <leitao@debian.org>
Cc: rcu@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Gustavo Luiz Duarte <gustavold@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5DBE52000E
X-Stat-Signature: 84afstawqk9ifirofcysox91c1hmagf4
X-Rspam-User: 
X-HE-Tag: 1778175443-783634
X-HE-Meta: U2FsdGVkX1/thLQr3W/VLvpwFqsT/jtYZ1xVqK677EiVlcRrY6UOAHWEBfITEgNHcX/xmHO0PgCs4kouG2qjLxHEV3V+Bf3ovMtNG6mXi+9gvucKJzi30WcSunFEw82SMyiroKhbqq7w/+sW3ez8qkqG9JxR70mN8MvbuxpaPXQjGktMVzuFNsPKEnfUdL6NHLA0zrkatmLuVJZdgnatJBmrjF7m2ZyK03m7VVu8w7A7jiPIv9P/pzvq+8/Dw8EK8ViXaBkrbiOUIg//ynqe4MauSM32aHv32zFHDjXr7H1/pbeep3hnIcONHl4t37eu71sTrxLcUg+bWit1hMy2zKkBS5As2ya5ZvMhwUuoZLnqndTFP7/k7K1VVqD71ZHnZ78bqs51vOtrI8t0egc+ET9MqzJnhjzqRwajs6TUAgXCh4hb2rCk4hZMnAl9sWNOG4WAyFslTLjm7Wwf+u4XaVn4jK+h2L0hP0P9ZesTTSOLsTyJRD0IIM1oOTaoJ7vc7Y9eDoD08jT2w+syYZ+bXEVNujXs2qjo3hkzvNk0VNSYhoUjX6qQ7Lr8Ic/rshMc/p9Bn/m0tqAkls39OuEonan46MTt1OkUA72SafXo41o7sMpy/J/joYxBSbqNuC32xEkeBw74iB/J6JW3AvghjdtbVHcxiFtnY2x3tzRAxhMYSnV2b72s/EM7ew3ue1ECeKZrvQUQ9EDtDlQfWbXil6TF4/ogSa4KrCe38PVbLo00RSPoE+yoVOICeDJSd8++EBcaJCQ0sI3pGqCOvLKcNjLc/DebFkMK6QzYGpKs6SWvA/xu0KL+vML3suLznVKAdGnGLkmrafqOyVbNOSzDieNhiPMIc60FHROdUIBvW16ZD2Bv7cCcj6wP88SFeLhWdeP4WcBh0/CDxII2c14+w2VfVGbWKF7XKq76hV5Tgmcekmc/IM5s/9TMYD3NVFFaam1ATp0JJlv6ktS7kdm
 OI57CM+q
 ii58jb0mT1fetwYh8spInKzY9ZfVBgWULArcK0/R4itgjzWmgoJGwxR8Wf5xTMVS2R4Opu99KycukWZe3wzi4INYcn0lQktgug0lSD3PzJN5xb3Bwt0xQuZAq/w8PBTNQ/m/2sA7dqil4rAi7aTOkfOMe/PKQsN9rSV33dFSlaqYaxzGyhnwId+7M+Bi6fRq4wBUOqA02nk0V2EVJPA+uNRZoKua/8VRPpn/CNqt9casHT5P7Zk66AOH5RwT3ashoCr+CZbArsHzvhNG2eY3ldP2H9idLwiSxIfmx9jOgrvngsnXc6aZldQW0ojhoctywlgLD2nZlYFYiQa2kp4EjDBzYsEZvHKMkjzhed/tw0Q8NDIs1QvYQlVFxDotfg5RdPONI+hK1jk+GefYwKG+Ex6LyaoLBiD2vPORnkuk3tmOCgWmVDMEfAhnkM6//F1+7NMVxe525G7vlo2r5YAXukeeCgRQIQWznsEpp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is currently no easy way to monitor how many RCU callbacks are
pending system-wide. The existing trace points provide per-event data
but require active tracing, which makes them awkward for fleet-wide
monitoring. Knowing the depth and stage of pending callbacks helps
admins reason about RCU health, gives an indirect signal of memory
held back by RCU, and is useful when tuning RCU parameters.

This series adds a debugfs file at:

  /sys/kernel/debug/rcu/pending_cbs

that reports per-CPU pending callback counts with a "total" row.

Patch 1 introduces the file with per-CPU columns for each segcblist
segment (done, wait, next_ready, next) plus a "lazy" column.

Patch 2 extends the file with a "kfree_rcu" column reporting objects
queued in the batched kfree_rcu()/kvfree_rcu() path
(CONFIG_KVFREE_RCU_BATCHED), which has its own per-CPU queues outside
the main segmented callback list.

Signed-off-by: Gustavo Luiz Duarte <gustavold@gmail.com>
---
Gustavo Luiz Duarte (2):
      rcu: Expose per-CPU segmented callback counts via debugfs
      rcu: Include kfree_rcu/kvfree_rcu batched counts in pending_cbs

 kernel/rcu/rcu.h        |  1 +
 kernel/rcu/tree_stall.h | 72 +++++++++++++++++++++++++++++++++++++++++++++++++
 mm/slab_common.c        | 18 +++++++++++++
 3 files changed, 91 insertions(+)
---
base-commit: 8ab992f815d6736b5c7a6f5fd7bfe7bc106bb3dc
change-id: 20260318-rcu-pending-cbs-stats-f72f5ca03415

Best regards,
-- 
Gustavo Luiz Duarte <gustavold@gmail.com>


