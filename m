Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30987C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2520C6B0092; Tue, 14 Jul 2026 05:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2031C6B0095; Tue, 14 Jul 2026 05:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11F286B0096; Tue, 14 Jul 2026 05:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D265A6B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:32:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2D87802BA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:32:17 +0000 (UTC)
X-FDA: 84986866314.27.0A02E5A
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1C65540007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:32:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=noJniy4c;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3HQJWaggKCNI7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3HQJWaggKCNI7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784021535;
	b=FWvkb0QnqdkkhDICiypKHNw/GBy+GjDNPLSOJ1irLW4qQ4/vrN5QwJ+mW7AcjUF7XhkfuN
	I22Rzf0QF5cqzVfiuv5qmXyc59U/wXszwnMfnyb7f7i0PQhQrLuVlxUgUHhUhRH7+vLWBj
	9X8Iv+ZckAguuOgZnmt1Aq9+puS9cNc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=noJniy4c;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3HQJWaggKCNI7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3HQJWaggKCNI7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784021535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZaT/U/JlP96J7BKuqsxBkutEqQ8OPKC1/nIHLPADppk=;
	b=Lwt/aW3m3XphKpc63zGkvxtSaDooL+pWUVN3LnXt4KzycN4X02bBZd8sMduGy3jfTJn6TH
	zu6fyRTKkf4WLevbM8/unKLBGvXxvPczC/yioQUeKwYOmaeUcvv5vwthq7hsnugjenAKBo
	gWczgJqvjref9UAhYqy6StsBjUC36fM=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493e3ecd385so9287155e9.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784021534; x=1784626334; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZaT/U/JlP96J7BKuqsxBkutEqQ8OPKC1/nIHLPADppk=;
        b=noJniy4c1GGCiO0gQXF/TdUHcJ6w0vGMI63OtIXpX+V0Z0r4FCMzW5Gb8rloZc7Bp4
         cCEu9Am9A9n1BpSYlWxqsqYcjlkfVHCcK+98BL816R2gbDtqF6+AxQMwCzC5lL/ambbH
         gr02qzyZr3SB4uaj4l/8TEdrafEr8UqhODIH6/FVZHqmRkRTkblSRQKFotS0UyIx0HyF
         +roPyzqUtJ4eYAeTCiIZhsgpWdcwj9kko6++INpmtmLobRR47xGvaDlcb2JMaxD9y7Bj
         xhFVrGY5eF4lrdYPUP4FJ4G5W3eQMdQrndBDN44xijanUMNtk3JNZZP9iLBoWEGUPg9f
         tkUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784021534; x=1784626334;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZaT/U/JlP96J7BKuqsxBkutEqQ8OPKC1/nIHLPADppk=;
        b=cJpqiFvyjTBBcHILH/0+ZSqq7SJt/NO8zvpUBnwEqEfhPOrcOTc1G8tdzTwWLVkQb7
         2ywODraFYiQg0GuGmpdvOgOE1Wup1d2oimIpLl7wApaRydYToJEKL4Uy3S9+Nw4eI99M
         kPSP+bT74UBfuT2ZOiOg9xK8DVNDbHLkG12cZm5hUX0PANFk+wE02745K4vSGcuRJlUL
         ihPkuENc0PNFUtp0+jY61aQFkla7hP37yVzf7pEhzq0cXYjgAJ9bPCwb96FirZiY4cdF
         gSihkb3HtCJz8gy/IVzfEAM8a/bjF7Y9HdMWXvHgh3FCoseE1GXDOoiM3O2qZ8V/uv4d
         CEcg==
X-Gm-Message-State: AOJu0YwZO78O3GqfyuogFiwS5S4r+z4tGwN1dACbSGWCtFfaAAEsHNPW
	e1hwlB8qr6digenhiYmJ7XICO/xlsjoHVb5qfEbWt2/Av2BiBWpRa/eAOsfiZrhmLLXKMSCHUab
	h1YzHk0tMPEESRQ==
X-Received: from wmqh12.prod.google.com ([2002:a05:600c:350c:b0:493:f83f:e304])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:705:b0:493:9661:f55d with SMTP id 5b1f17b1804b1-493f8826bf7mr96781345e9.30.1784021533525;
 Tue, 14 Jul 2026 02:32:13 -0700 (PDT)
Date: Tue, 14 Jul 2026 09:31:58 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAA4CVmoC/4WNQQ6CMBBFr0Jm7ZihBAyuvIdhAWUK1cqQFlBCu
 LuAB3D5kvffXyCwtxzgGi3gebLBSreBOkWg27JrGG29MShSGV1iwtDbDgc/O9FPNOKcvMcek0T
 pLMmY6jyHbdt7NvZzdO/Fj8NYPVgPe2w3WhsG8fNxPMW79+9jipGwNKZKDadcE90akcbxWcsLi nVdv/ubn83NAAAA
X-Change-Id: 20260710-spin-trylock-followup-332c636e0d99
X-Mailer: b4 0.15.2
Message-ID: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
Subject: [PATCH v2 0/4] mm/page_alloc: couple of followups for recent cleanups
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?utf-8?q?Michal_Koutn=C3=BD?=" <mkoutny@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	sashiko-bot@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1C65540007
X-Rspam-User: 
X-Stat-Signature: mx6q9y1xjneyyc1tci4zj4uqz7ibwc4p
X-Rspamd-Server: rspam03
X-HE-Tag: 1784021534-484491
X-HE-Meta: U2FsdGVkX19AutoNbWukib7+G7+dEMWxispno4w/Etz6EXtni5MMvSa/jbTw4nTetXBWpCJwn9Xz12sXh5Nm2XIZ/DhxN6bPzPSp76anxZgLaeK/qrDqWMqMyMZsslSm/xq1HFyl8D9BuWlKWM07bpCuUqT8LU+kOJWF2tvjw79rNOkiXKTlEh1JliJ3bVNPc3RpKLeEEpRRBN/VG9rXy/D5u1ROAd6H5C0yaM9V25RFvK8g3Z8nQcVXPKlPJNaJvHq6Fui9kscLldgglzfQdF7lIrWL5Zm9UeEnhwwQ1eYV/RJasb7Y3J7IuFuUfsN6NemFmOG2hvBVArI23KYRG3iwF+/yRXxjLw5zuMhH7heLmI7XSmisnA8K/Cb+MSV3Z2AWVLXB+PUE+P+/fPwDi9egEGZmvylDRUtI+57wzehKWCsC54B8ucYdH0V9bQOeJoWCZMhFSH9c0MYdr8sGoUNFH/L25vFmGOByg5HO800u42EAyWZ4J6LtJxOS/uVAEmcMF4mlng9bn2m4PtSuEFhOYBgvbaO4hC2wKKpJ4f2swTvY8sDTeiSKZzFADD2BLld5mbjWmrp3Chad2M1svgETbSJGqj7y5JWczbQ2SVdDu/IDh4KJhvpB2WD7XTwOsBR7UjTtVDfbSYekX5YdfueWxZa6p0kndUwlMBowljzXPtU3+US8wmykchAJEAgcKb3EkEwIcsY3q13UeNNV9sQGTSdupY1Ck8cRnaRpub/3GbOL4IPmFHTad3tDOnelLWXggVtz1L16XIcoIfjNAD7m/f1YKRTqYBNv3lwQuqqIMFF8jIGr9bP/YeJTjbAx3q5L3Hpj1LiW9hrc33v1UD3aY81UuILm9JsIlQDCzMCShOQvo3GOn/aPkKZT7k5xRRaLdmffQfoNXE5S7QN7w7umqwiN+cykBpiZCbU1qSOLHb+GylGwIGzIrMFw6T8D92jLsCTI4vOGL3UJgqN
 1r9zq4CT
 CRpBGUxCgFDIYQmzU0uLzId+ieE6ckN9mvu/09TVv5WdHolTRMwg4w7DJKs8CiTENnRCSmC3wSZ6AxayeBQ4TqkoK13Dsuvb3/nG+BpuPhpoWF+Ggk2s5T1hKkbsmrJk2if+KkIguZ9FhrgfaTFMRR51AjgjqWpv5yI1jakKIPFifAMozdJc0o6NCJRcQrJl+3fwjdPsOIqCfvW4/j77EZ005X1HuhfYZobwKAtOgqq7xpFVc9BmErCEcaiIxPXTXmrhnv6XcZf2W6JiEctGFmIoZylT+egK2GyBLw31mQryFVS2kCrRFQWEWSbK+TVfdWe68BLZIy7uE6qoPSR+8eJVg0hZt2ZCNd9cNXcDrLZDQFnYmoy8K6ncjlEExmnWGDyTx7IF+TasV7T5Q4JQ6c1tkOzKraNoEKxr0h+SFIJWVL9XqUAnDo7YrB8FK6S4s/Hylc1GsnwP60Amz3ogvh3xgntBRPNRdrmh0QPIpIRpFOJQc5tA5Ylif6gmyVTJQLZzwYVCQnxPFkNdjW2Ef6fDrOhyROmDVhHtTmdM2sJG9crcopo+A5jT1qvUrMDaBMq+VvxsDbHqzbC4mDhtmIC4US39l0e791R7eLAX9QY+J8oTJ0X7CHdtoCtweu8h/rIfPIqEuP6XD2rjzjj6/CIma6DbWpOc0JU94mIx3KPsVStnGWF2L5H3apgXbZXG6OkHR9+jnf3JcWWjKR1P6oBJJ320sSDIH2GMcgDlDhbM193Z9LLNQEwfFuw7jx9K1vFVUijOaqhlTqbMQmfNXTiYjGClt+1E2zVre9sdhOKUnV8RMZzXJz9IzO/lk+8OZhr1/checiZG3NTtQosIb/Edhw9aVn/qdEmA5NDZo7+62WFHoNqyDz1l/R6qldcmxIG1vTbym1AbTfSMxEJ+jW3MhZrCB5fuDfkNoZ/ead9gfon/FMCGKg/hMPAXcy6hpSVFkEJ8gKpb5+rowSU0a0EuYLvM/
 7PZDgfps
 p9aKHlgBa1SiAPBny+rUFWFobmj5KWwdqCM1LQOxnAlBJhVLvPEaM/TEMDJiiRESjunP047/zKCMaQQRnI9HAZWiuD5GyOCVQTGj7KtHqUpTjCd4UExR8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



---
Changes in v2:
- Separated from functional fixes
- Added cpuset cleanup, comment fixup, VM_BUG_ON() removal from Zi Yan's
  review of [0].
- Link to v1: https://patch.msgid.link/20260710-spin-trylock-followup-v1-0-=
affb5fe5ed00@google.com

Based on mm-new, these are followups to [0]

The alloc_pages_nolock_noprof() comment fixup could be squashed into
"mm/page_alloc: relax GFP WARN in nolock allocs" - currently
11770f8836f44 in mm-new.

The VM_BUG_ON() removal could be squashed into "mm: remove
__alloc_pages_node()", currently fba100a6cdfc5.
[0]: https://lore.kernel.org/all/20260703-alloc-trylock-v5-0-c87b714e19d3@g=
oogle.com/

To: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Brendan Jackman <jackmanb@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Clark Williams <clrkwllms@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>
To: Tejun Heo <tj@kernel.org>
To: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org

---
Brendan Jackman (4):
      mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
      cgroup/cpuset: update some comments about the page allocator
      mm/page_alloc: fixup alloc_pages_nolock_noprof() comment
      mm/page_alloc: remove a VM_BUG_ON()

 kernel/cgroup/cpuset.c | 13 +++++--------
 mm/page_alloc.c        | 22 +++++++++++-----------
 2 files changed, 16 insertions(+), 19 deletions(-)
---
base-commit: 61cccb8363fcc282d4ae0555b8739dd227f5ad0b
change-id: 20260710-spin-trylock-followup-332c636e0d99

Best regards,
-- =20
Brendan Jackman <jackmanb@google.com>


