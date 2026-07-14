Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94BCCC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669356B0099; Tue, 14 Jul 2026 16:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63FD46B009E; Tue, 14 Jul 2026 16:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52EF96B009F; Tue, 14 Jul 2026 16:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27BAD6B0099
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:13:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF025A05BB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:13:28 +0000 (UTC)
X-FDA: 84988482096.19.3B66D2D
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id EC85E140009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:13:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vo807ecK;
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784060006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TgA5/ZNNqpom9Ojeo649tW4NqgfWq3ikZU/yXXQBBgI=;
	b=HSjuxYV8HopsRiPT5ntQbceGCbmEvppuwTExOpqouWtyzjCttwtG+CBbK4LgxU5+UPb5Pg
	I9Kp6MQdOPEAF9DNHwiDsHPpKPSl4UZPxccd3p6SlPmUA9wZAnOz7N1TFnGbpgs470tqJs
	TVzYzbXOa+YgHqpEebaKuQYriMT7qKc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vo807ecK;
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784060006;
	b=xf8t/Wvkh339YQ+a/otORug6wfa1ONvAfjdYa8Ux2TSJBzeKF7ed1MCXgjOKteECIt5zIu
	M8tQnl5VLz+zvi+/Vua75IaP6AiU35B/HlvsgBZOmyWVmevQxEntMrSMs8jKuNIHGLbOJQ
	4yypk45kp6jXqjaIaBFJ9lBOjp9/Kn8=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8485b358552so5219750b3a.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784060006; x=1784664806; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :message-id:date:cc:to:from:subject:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TgA5/ZNNqpom9Ojeo649tW4NqgfWq3ikZU/yXXQBBgI=;
        b=Vo807ecK8ZXtivJubD4bk3JtNfde7Fq6yCLCXRPOp9R0Gqw9jiuoC+VMVtPKz4fxcv
         NISeBnnA+/YQeJeNvJQg6+vsK7PMki1qZPrnLlYeuCKJMQwKCqM8PHaBKSMgJfjUC7HV
         7sDyZEbD1THPG75N2SWbi3JonVRo1EgbuK3ja2uSCy+vTVwUAX+hOwyLKPUrjFacov2w
         JBmKzXakWBi5pNG5eCVEOEQ8eomJceHQUezklfezX9rs1UsOH1cRE5lV/+8lLxFh3ev1
         KBDUP7stlSzCfSGP+al9aYKtAJ+y54sHWv21310fwwvTZNqpjTgw128m8yCeBpEg+ESr
         jDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784060006; x=1784664806;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :message-id:date:cc:to:from:subject:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TgA5/ZNNqpom9Ojeo649tW4NqgfWq3ikZU/yXXQBBgI=;
        b=QRA/KWhWbgncbZgsM/ja/z9Za7pFzhiYzb+UZHqy+rpPRYDR6KYymEaXSx0mas5OB3
         lDYYKd983r/5nDsFGlrQMVbaOWCGZbGTjeag1DoGrVDnqXbILF6mt30oJnSjQL1AKV9N
         PONHXmCJV7CbfMaRA9ZyWps7roxe1xbyI3RPsXx92pb0oipHMauTP9MdjF3lTdgfpvtd
         qmgJtD2IpvPEWnZ/D/CZXRaRGa94aB1ITILKogdlTJqXWQNTtTVX7J3dEhITFN5ejx8h
         ZXBs+zkra3LHn21e2URv2gcXpGH9GMXtcsr1onzPfFcCH7giefEWO2Z2Y7drei9iLraX
         lSdQ==
X-Forwarded-Encrypted: i=1; AHgh+RplTGedqcPjnMB3xzOG5d/5F1Y7k66frjCaJKdnd3NZ0X3XuYLu9oHHlXmqilV16Iry+Z71vGzSzg==@kvack.org
X-Gm-Message-State: AOJu0Yys9uqGEWYjPWxsnNlRc4Pb66uPsXR3qHGzBv7n6z5qH5mCpMUi
	GoJZLOWNYJrQzJh6fj6bYeFyMr0N0kV1dqThyYYZrKB+4HQeKFpcQUF3
X-Gm-Gg: AfdE7cnVRPmXA9yTWHrz2SWFp4n+mdzxoDGKqOoqVGIlwr7J7lg8nH8DQxfSiEdCJDC
	NLpIClM1lgoSLDOKB7YSuj4KPC4ii1vFcgHZchZSiz3+kWSe32QuX9F9fcmoxIsxMKrLJ4n9Uyi
	C7PU2vaEfSk3AXgjPEevpAffw0JFJsjNxhtXneFPYoIMZex4IEsb5b/axHo0vZyzyvJRiU1vYTN
	tLdW6ocrdvEgmdqxRcYBv2pgi8AuhCMddxoHFd+yCJ0wJ0q/PTS08MbdbVmKObm03/tSMit6YnY
	Pf0UVJzUdSCcSdUvtr2Xgk0T/hAXKrA5b8nbjQpFX0vGGmjAElNwBkHgwX0ofxQWx30j3C35atI
	l21ISmlB8X1LCRNlhajs4MCfnXUhsDWOec2KKcKwzhdiH/pnHd5xneFRxMi1gD7QyuzS+kRR0dR
	JbHuwpCkhqid5oxl3JDxf7cBPgMUg+6TXP31WR0XUeS/BJhvlDYxQTv8ZWVZ+k4sIKA3XCPg==
X-Received: by 2002:a05:6a00:1f14:b0:845:e9e5:cdec with SMTP id d2e1a72fcca58-84a559bb7dfmr3412771b3a.62.1784060005776;
        Tue, 14 Jul 2026 13:13:25 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f7dade0sm1998127b3a.46.2026.07.14.13.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 13:13:25 -0700 (PDT)
Subject: [PATCH 0/4] mm/hmm: Clarify notifier retry state and scope HMM
 timeouts
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, jgg@ziepe.ca,
 kees@kernel.org, leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com,
 ljs@kernel.org, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Tue, 14 Jul 2026 13:13:23 -0700
Message-ID: <178405975214.1082778.5193079941156341151.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC85E140009
X-Stat-Signature: hbhhrdeb6tzwwn5ei6ubt7htcq99gjbw
X-HE-Tag: 1784060006-678895
X-HE-Meta: U2FsdGVkX190jkP8NJas+tQ4JkyKBBxiz+DKW/+etv5M7WSK0seYRnyB9WUCoNjE8E1CmSd0HwO9bePuExj5wpNjbvYIM7FA56f+FADt2Jfvi1u2DiPfwVxG/dXb9HixBPef3YH57R1lJ03eI8nAkz2hqhDIzfUElwgobUTW/6nabaFNhop87pWcyJez56+rX4XLfPkrCjHeHhr30a+DqNR0ATZsh7FUH7+cuItmd6ZgceW2dG93h7xDk9q+yjonNEES06UoP1MJwyPwNGZxvSBsafuhOk2ZPNiGVNq96zvbpLuA1OY5UBodqK6GA1nzSwAhNcwRxSthaJHu4QXMSLo+ctgEeK5+JphKNZgWve9MHZhCwQy/8EBSyw1YAV/xdpJtducWlrF5ODNrKL6QRAnt/X9FOktcMjX4WOI/8teZJZeo8yVTDR5TJXTyiPOmgUrdRQbE3kbUonvqzVf2k5pa5yB8ODMg1wH0ynV90fHaXqNtpeuSbveoHNOrjJiek1EYL8FybC/ImLw4XmKo++/HY/MK7kt5m87c0NpeIYaZTv1+lBEWvnHhtUENj7+swiEMrs2X6CH24C4+/xlSEjT859lu8Hi3EgFJiqkGzuajI58F+H7MYrITFwbT/eBqZcVadoOfLD9GLIyWWDyJM/SL+yEzS7TAKFKze9zKk39m8uAbduNcWqKJ1AE0aZmOsiCrM8c96GUYGL1s/VZm1M9dr6k1vJphJfsX8/avqqXPHc9kbXZaohf7P9Rj5rxFE28f3zPnAoKMpRq/AD4e7Q180XFBPu+Dahbr5+pE2xWg3Dds3gBl/DgDwdOqCqey5Dr1x7ggyOoiyGKihO6D7F7aeMfcjQ+u+3Mla4hSY0bpZb70Ww1y0Q1IOPb3dT0gfNBr8k8xo3LvE0WbmOeyxD8ZPANZ0OFn+LwwFou7SE7g+YP6mIZkk2qX9zC7Uu4sCaWUVYirzg+dXZmiF6a
 poZltxBt
 esm85znLebfFsbnm5IUttfFfKgGOoiX6L1RxSPJo+Npj8iELfKvC8gqmhETEM8xaFP0/woj5yqoIccgkFVFTtZzHvhT3NZ7An7xJTrnCpdSA0cOGWC1r9DE6fo/hRXTga1DY5Nvb4E4lqLIY0yhEnopNTssEvlEuMpxt4eGAVFz9giz7h6LN5Y1msxYXNkhXBIHjAxRXvilDlyOEl0BMrdlM5jOX3ep5wwhlZqAsRcOmWYg3x/MM0vwQjG8LOoWnH6pRigAnSGTMO/42sLrJ2GuAhH/O6MWNKBEJOMdqU6xeZSfOcO50a5pUYeX/GZzo5xkdpzqpi00rgW1Xhax5fXFb9+EQyvR5jPyXojgLLs7PHvVbRX5Z87RnCfPgmmguCKSnY7gb9XVhZHfhk5tVAa1qJP7h9sDO69aXo5u2IzwUZhRnk/fdsMVxrJKu76A6p/61N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This small fixup series applies on top of:

  [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for userfaultfd-backed mappings

The first patch updates the HMM documentation example to make the
mmu_interval_read_retry() state explicit: callers should use the notifier and
notifier_seq stored in the same hmm_range that was passed to
hmm_range_fault_unlocked_timeout().

The remaining patches adjust nouveau, amdxdna, and drm_gpusvm users so the
timeout passed to hmm_range_fault_unlocked_timeout() is treated as a relative
HMM retry budget. These callers no longer keep an absolute deadline around
their outer driver retry loops or pass a computed remaining time into HMM.

This keeps the timeout scoped to HMM's internal mmu-notifier retry handling. If
HMM succeeds and the driver later observes an invalidation through
mmu_interval_read_retry(), the driver retries the operation with a fresh HMM
retry budget.

---

Stanislav Kinsburskii (4):
      fixup! mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
      fixup! drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
      fixup! accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
      fixup! drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults


 Documentation/mm/hmm.rst              |    5 +++--
 drivers/accel/amdxdna/aie2_ctx.c      |   12 ++++--------
 drivers/gpu/drm/drm_gpusvm.c          |   21 ++++++---------------
 drivers/gpu/drm/nouveau/nouveau_svm.c |   30 ++++++++++--------------------
 4 files changed, 23 insertions(+), 45 deletions(-)


