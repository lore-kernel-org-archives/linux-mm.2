Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E641091914
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80066B035C; Fri, 20 Mar 2026 05:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F286B035D; Fri, 20 Mar 2026 05:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44B06B035F; Fri, 20 Mar 2026 05:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C346C6B035C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:37:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6FAE61A0117
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:37:56 +0000 (UTC)
X-FDA: 84565939752.25.BAE1ECF
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8DDDB14000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:37:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DKpN2eEk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3cBW9aQgKCOMOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3cBW9aQgKCOMOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773999474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVl81zt/GsTfMc0Wx3AiwbjEq6jv51tPHXiJVU3KB5k=;
	b=fK1kNd80HhsBrKRoEu6HnLWgZOB9NcJ1MXCr93L8MnucWj7wfiFVE+DhDU6vsRnE31o71T
	+mPXN6Qejs8Dv0V2ogC0uc7u+L89gF1T+l0IwR6TkhUm83nirsApffrGuyVH3soprJYd+v
	C0QIjo28Bw68a8lejtZJDCuiIOlCBBc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DKpN2eEk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3cBW9aQgKCOMOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3cBW9aQgKCOMOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773999474; a=rsa-sha256;
	cv=none;
	b=1x8a/vvJUPSCS6q/f5SS6VdqEbVPqBrLc4vM8psRZ1RO9s9a3r8fy/UGvLvC3N6yauIT4t
	N0a57mSKc+GUoYN+08Hxvwz45GbUz8U6YN29n14kWhSJs5gJwC26I9kUUhnId3JnORir8D
	ImTn/OHfPBlrGiAUlp1O7UJuzJ8CkOs=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-486fa9ea1ebso2748575e9.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773999473; x=1774604273; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yVl81zt/GsTfMc0Wx3AiwbjEq6jv51tPHXiJVU3KB5k=;
        b=DKpN2eEkWayBrIzg2NBTLaguP6gHG89MJIItHKUN7TE+32i4gEhgNSXXGEygeqeTR7
         6k8RFGCT9FkX2Azq/C12C3S3sSvhF6b9Pr7C3jMqW8hD+oDayMbNXQtB2TYS2/gIXe9y
         z0aC4UpjYp161zOTkaYv5feE5AnfZUQLKIrYQUUOQtm1H0CDb5NOzFv6mfh/SHt80yYj
         OlyyJULLuXwu7KpFfK0qDIHW5bWymulUOZunZTi/uS+0vmlc3Y9KuDp8WVxbowGGwlTY
         9bGmw9Oiyx/5vjTib9czukmjY9t9fGDt30UpDmMxb6ql/CE3X+Z8e/6qjFyeP8sPg9al
         pQWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773999473; x=1774604273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yVl81zt/GsTfMc0Wx3AiwbjEq6jv51tPHXiJVU3KB5k=;
        b=gwqgSAIKGFOEk/vyilguHQCiR/r7R06BrImYoior73kLPpe2V0Y6psaaVBtzST4WTu
         3jHdyu67gFkE0QbN/YPMndGH157/npag2tdRKqctGzr3sXc1uGzQbvxKm1HVBvag/+Wv
         0tq+SyuETZ+DyjAJ8P3sDgB3sgSH85uJaOJUHmYdWlvEMe47Z/oepY8ufuFpZew24Jy+
         /xgRUvRKxEds+jDv5rOYwUcjTgYThtJn8vMRC7kIbHVAYam8oCMDPyCAgd7YxlPGAkmj
         vzVgI3JrdtLvfnDb6SQK8xmaSemhVJ77XiRHbyzZQt/5yPKnjd9XnqX04uUvK+4RIF5A
         1a6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVq+1fOIE11GDWxlbblMliF8H8w8nnnFcQVe9Sqp6qYTagRJ4jaf1cIxsayYET98LyLokMfhtuvpQ==@kvack.org
X-Gm-Message-State: AOJu0YyUvmXgc19mM4aWV4ZyLbrd0/4C1M1o4oII0DLjq6HfAmkSHLli
	LExi/H1hcdE+OXYpfpOLKP8hdeC6jxknlyNIyzZBue02Si7/IcY/0RiJq9z1prLTDHy9fNiZcq6
	dqab5ZddBWbfhEw==
X-Received: from wmbc24.prod.google.com ([2002:a7b:c018:0:b0:485:6963:6c9c])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8583:b0:485:3f1c:d8a1 with SMTP id 5b1f17b1804b1-486fedb9631mr28002685e9.9.1773999472816;
 Fri, 20 Mar 2026 02:37:52 -0700 (PDT)
Date: Fri, 20 Mar 2026 09:37:52 +0000
In-Reply-To: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
Mime-Version: 1.0
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DH7IBUV7758T.10XWQ2VX6KCR3@google.com>
Subject: Re: [PATCH 0/5] mm: Switch gfp_t to unsigned long
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8DDDB14000B
X-Stat-Signature: gncp5hnrkspbacm8mf1bnqbhdk81t73s
X-Rspam-User: 
X-HE-Tag: 1773999474-514005
X-HE-Meta: U2FsdGVkX18UYpRpiV+Pm0vAZ+vCYFQ+iZgs0PEn8gvhssdvlKDboyFeJfjLttdFmb8A160woq9uQ22xGY9HlQnpcd0RnIx/pg99IkRw7XZT5ugShW0pFViuOIl8IMmXqKj+UopyEfP1PUx7AOUw/3hchXMJvuAqBA6jPT6P8Y3Peko4NrcYZ1k/1BwlA8wHVtTWYmYL9/c+fVudkEJzuLQDm2U7j+wYs4vFIkoNwul9D5Tid6pAS0GTFnriIjJtTZIT9C2iJmecys7WAfm95+Ler47lNhCtqRL7riR7mDfgb39wUVop7vokjTHRFXpL7JUbcXzFFxbsAvqdtoo6VXSLTQ7sy8GvHTy/5ucOMui3I9X3A06CYoxQlWhTcqBJItTQnjb233d3K8pkxA6Pi1/oBnbBaBoOchg3yF6YU2QsQHfS6AHPyuA6fGEMgfumRbLIywkclnIYufolM+90+M7x1yuIi44H0hUGaVkX+17wa38Sq2QBtiarrECbbCLku7hlQ62IPt5Plkx73BRR4QqO3oKuUI1eKbec+1tOg5I3gHAcv0pMTJWNYVmjxHtyUtT5extNjHHg/QcOlqbjLMmqI2W62d+gaCPllDhGQYZQrbnjP/s4qBM0HtAEKhSXw0iAQ1o5pD7TM9BMJZAxu24Pn0CxnRJYKShthU539touXo/toVm14tdjgz5BhKJ5u1MpC94NueXNrLm1L1kW4uTaKIaakXqp1FJFGkkco5DDfuiU5HvmK70EGXQeR+N7RoxYCBlS5pWn4zBvJSoV2x4apFYYO5d7xvTLR/3GacF28o2/oG2oT7Rs9h8VqoF+RlGjJ17NW1Mkdg1JSSQYqyOosqbHwcXVysm9C4HPkmWvBHry9kSO7WvqV1C5RE2gG723UPqAyeDHhyClL9qY4xtex7szODoSsOu8o5RaZjuf6KigTsk9qqaOimxEF7cD1NBqIjQElmYMwY2J6sL
 wbaNKGqc
 6GTYvhwDMOE7Y+tIQCg/USxnrbu4grY+tIDaWM+t26HzbOMyu2Mtt7Bu/PA4KhEumducF7obKYterhFbTSiVsM17Aa+eMGHCOmM0Duux21LRr45Kac1RJXcEKjCrQEzk5PoJRR/k0YjE4G4IsHpftwEQvLKYF8m156TZ4406ZyM4jW2L4oGNw0Xea9Ty0cpM11Ym+ZfmQ2AP1iSEuKub3x7MmzrPZUuD2EUpXjAdMXs5RWkS499D7DEpZrCpRvtL3i4l83d5WILeU1dukIJV3jXqzf9yIt5m+2F+uqbG/L2zi78lc81t94ASV7Qr2451jLHgPXML46TeKpnXalf2zLwLuxaGgrX67MATjF1mImkm8VvmawO60ow39K0ffNgYTxqlUkHfAqKh8Tvqt7PzI/zw5s0ILCGjz+yd5xzcx3IwpM/gfpupWc8hM4WbySvUn/TEXS4uCBFBd2m1zzhSv1aOZFFedSYc+JFc9J2430nXZ0DQDl0W6OSlY1d5nMX4jIkcyoQa1fnemisjVb+5xNY1iFfJf7FG9+0Tb1RzM5MKJ5buZTf27FvtrNwqClAIGgC1MagHA09Xy/dTge29WvC8IKt8F2lW62jq/2rVeKs3GmVeNcxxeXnSTRoMsDxU36hf6lvpTt/KfTKNFhlahuK6t+Juj+V+j0CDj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Human summary of Sashiko (AI) review [0]

[PATCH 2/5] iwlegacy: 3945-mac: Use special gfp_t format specifier

  Just identifying pre-existing (and low-stakes) issues in the code. I
  can add a patch to fix them up.

  Andrew, I think it probably makes sense to merge these cleanup patches
  regardless of the gfp_t change, as Zi said. Would you take them
  through mm or would they need to go via the more specific branches?

[PATCH 5/5] mm: Change gfp_t to unsigned long

  - 1 << __GFP_BITS_SHIFT needs to be updated to use 1UL.

  - Need to update userspace tools like perf.

  - Says I can't use unsigned long in module_param_unsafe(), which I
    think is true. I did that to address a build failure, maybe I never
    actually repeated the build?

Other patches got a green tick.

[0] https://sashiko.dev/#/patchset/20260319-gfp64-v1-0-2c73b8d42b7f%40google.com

