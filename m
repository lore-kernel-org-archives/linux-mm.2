Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F16E6CA9EBE
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 21:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DCB26B0088; Fri,  9 Oct 2026 17:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68D506B008A; Fri,  9 Oct 2026 17:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A3656B008C; Fri,  9 Oct 2026 17:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32C2B6B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:46:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9F84140349
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 21:46:46 +0000 (UTC)
X-FDA: 85304422812.28.60F4F0F
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1B5B71C0005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 21:46:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h0kQr9cj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3w2DJagYKCAgs2vq62owwotm.kwutqv25-uus3iks.wzo@flex--kuniyu.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3w2DJagYKCAgs2vq62owwotm.kwutqv25-uus3iks.wzo@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791582405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ku6Jv31cZDquQ9fQZ9/EFwlhI19NAaTgSBXeSHKLl80=;
	b=rFU3XLzm6ew4WoR4gkduAwPuhoFLXz1lde1zinKfAgcjObwTCLyPrV69in1VMlAbaua8D/
	flWr7LrJs42B6lWLCU6pJn6fP6qwQI7EK9wgCvhVYi8YCJ6DZfMOWNSekgc5TX+0p1xx3c
	d8omtn1ZeGyXY4XBPBMOYAuwXRYFUOc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h0kQr9cj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3w2DJagYKCAgs2vq62owwotm.kwutqv25-uus3iks.wzo@flex--kuniyu.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3w2DJagYKCAgs2vq62owwotm.kwutqv25-uus3iks.wzo@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791582405;
	b=eI92++Ndkh8AH4pCYWVPsUnj4mpziwlruWjR2lJ/Q95ljFoqpnV0yphO75ozOwX3VHT+sB
	QSmYwo7GD6sbgua4UgPPQGiBb9ZxUt+N2QPOMfqZanQ8TFjQyHJ5XRug8qGK8yCsY5tyUG
	4aO/VX2x2bqNBS/xo80QLo5F/xkPaLA=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39de4e72b33so118290a91.2
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 14:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791582404; x=1792187204; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ku6Jv31cZDquQ9fQZ9/EFwlhI19NAaTgSBXeSHKLl80=;
        b=h0kQr9cjrU5JdfHQkw84rpOAVvZbYa8Qsm7WAVPt5rFtQsmT1waJi1kqlQ35Ckz3uf
         loI7wdBVgQImG84b2bUfWNy+cpYqGLlEuWY7imSG3xktY/WhU7TpyF0aUAGCSWvDkaWj
         3Wjqlxn5coCaxxJnkeMkKC4iLVz2qZHbW7GRODhqV+ucZ8sYTkTyk3EkH+fhmJ4kf1Ox
         LWSA7FVNFapbpba0oLl1HoeeRKucue3erLQNsxp8MCGpCRrG/fe41/Xj0a+11+wqEkUi
         n8wkmn5PB1VE2ksn/qfhTAS9oSYSODaKBctN9oY/xm6zunW5PBpu+MDqyWH2RhUQGdr3
         ZRaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791582404; x=1792187204;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ku6Jv31cZDquQ9fQZ9/EFwlhI19NAaTgSBXeSHKLl80=;
        b=qMGzdGasaHHODsbhyrNIPtIwXdi7xhGNazuiYTFB9Ey6eRjhbG+ZREQ3H60YNId8zJ
         w8sosKOYoFDt+1IMiFTqVjp+8ovi5/2dGX4UjQKVdo1rjqtlOSwBYzOBxFtutZvCNkG7
         Mn0WllVWGn7eEn3JCb0DipWIL/bQbOqjvWtiQz9orkGdHVo4wO2bjg9MCSuxPmguekvR
         TpAcHKniaBaAfvqBeH4aN5b6/wprzakg2ooti3ZtC2eyFNd3QpBj7MeWqjmQ4gd+ZSVp
         2zSTbvjD31sZHHQp3g7TTG9YfcvJ90izvbM+xF/FxfCWizpqeTwrObtQ04hLpFrxJ9hz
         BIkw==
X-Forwarded-Encrypted: i=1; AKwUvBz3ztaCiE4R50uLS5KV7DtKossAGqQRO6RTSnUNvPe8/S/W8XMKgDSZIq9YzE0CWnRqVDxnC71OVw==@kvack.org
X-Gm-Message-State: AFq9FYKN9FTWt/WQ+4QXdVu3/itpB6s8rgEmlPLbXmnNsQZsB6IHcbKw
	zqPKhn4sxRka3NLSXJbDP1gf6zQv88bGZOTYchfB4uB0vGbICHKQ2rtRLD+4ZSjZKBpxts6Lyve
	pHmTzEw==
X-Received: from pldd12.prod.google.com ([2002:a17:902:c18c:b0:2e2:ded5:ef46])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d505:b0:2dd:c053:9c70
 with SMTP id d9443c01a7336-2e842ac8fccmr28144555ad.38.1791582403355; Fri, 09
 Oct 2026 14:46:43 -0700 (PDT)
Date: Fri,  9 Oct 2026 21:46:24 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261009214639.2878857-1-kuniyu@google.com>
Subject: [PATCH 0/2] mm/kasan: Detect double-free involving kfree_rcu_sheaf().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Kuniyuki Iwashima <kuniyu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 5cf1izc453jsbk9woe4ijkg4wczreaoe
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B5B71C0005
X-Rspamd-Server: rspam08
X-HE-Tag: 1791582404-74647
X-HE-Meta: U2FsdGVkX19bdMTbpm3EEX2ZSc+ggYaycgFiHDaYv/vSM6BEEFV/OW/EtgwjooB81uxGCEoOX5yqpLQj5eWiNU/z43q3HH0vSWOyLAdMINY4xt0FFOzZTE8LaVGS3uU0u5h0toyS4GrRX94IOqBGwGt1/Q3smXmrpkAQhJ4ZMJl3t2e7w5vSkvwjVs07HFNXsqRlbaOUOXBZWySd4rttSD5zQbK6izYIhqDQIN5NcEAv1KUBWVa3eK2Vz98kziwsI6HDdxeExqfcCWRU2c2p90lUfloxdg+ET5+loJxXMWtByYMPEomluJAILLztngIFk2ZviX9zcaaxf++WAJ7IsWZrSOANXnv+3ZUQka8XyTbehuyT6+V18VMhW/XBdOm/y9kk2xNnOJxOVb4MS8Ga4reFJThLcRfpQaCMIdTJo2Vj0sKvky9KzFVA29rNZbqgQqhrCGNs0zsiU7O+vpPHCK34Svl5reSHDCMHFpG46YR9iF7f4wE+9MyYB4PxqckeUEo6sf78bJxK3pMJT92A338nlk4/dUMIGcVj3YaIE5/EZ5HCZVRLy3Gyn28c1Nm+cS6jg97jayiIL8FY+HNE+l0TILUS39FO9Atb2uOqiWrn3eQuWsoFW7RYC0NVwjzfVgg/Sj7eYM7A5LKjvrG9wIdijYYNBqA+PYfYL7OAZDRDI0dSp7HNV6tiJND+tiv7oCy7lm/xuA8vWE5dzAoHITT7HVijJ11V8SETFk/hcAE1X9UUv3t3ubuSnoJZfmEpQ8O0wsLvnrSMO4BTJaGxHlOoxMMPFq6YGHqmTlBmJoOfOk6JOokfDRKC3yB9wZrAWbJrQByVpX+Pf7y+Y26myKzoDeXIH9d3I3JZ6MrV7teWVvCpTk7AmAK25lhM2hohhv3xnb3WladzpTqoaHmgSjCyhSBp7h0INDpJZ0wvh79WMoS8sbs7Cg4rxGKV3VO+Piv/GIATrSgaGYRfS/z
 Csp7hFOy
 xbw/1Xej4mv+MxXuUeeXP0eGWm1ewauEbon7UkJexlj8b4ztJQUQ3QospSAiG4J3SwmG99rQnq9rQySf8rGJw1Oy0juq1i047e6RhICBaU9QKoOSCLQoaHcD54Z0sQgSNaYvSKG7rVbZaiA1EpolXK2W24dEMHf+wJyVkEfUO4in9eU13UOqbq3UHFua2I65gu7zEbe57sGIhtfBqwDIM95aTHEeOoAVZjqVPjZXK39PzH6cICid2wPwMsI6rt+rcrNo1oX8jTf6sBrG4qgY6ffG1KygVqcF50+1JB9BlgjRyCe4odNDWn3Uvnf9MaRura/qa5h54NUzna/bd1Xnt2OgUIcL5K3KVUo/YcT0mQlcVQrn7KkKryjngIlJ1wckxE+9rk0CmCtdsNtEpUEwyt6wYgMVt0QTlq7CgDgLFSTU6Ai5P2TDbeQTsP5tDL3r7rfgoBJV1+3vR21bxoA6cKi57wTLPPRdCKg8RQmyVj6ZE5fxam/4tuHuR3DSEQmOQrM4VTU+YR0ZXRy+Zz7Uj0CjcieYGuwX6UdXd1WgAA/RyCsKSlw0zzu2on1n/PMsXCB8hxGPNX7M8/HvuD2UZ87dkrmu2I9HnV7HnDkNmQcqE1gPaVKYAfCYhN/+h+9gxtKV4lDaDD5ud5Q4WSO7XG3it+UYtIThIkWdPRsVWzImM8k0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Recently, syzbot has reported several weird use-after-free splats.

What they have in common is that "Freed by" points to rcu_free_sheaf(),
whereas the object shown in "Call Trace:" and "Allocated by" is never
supposed to be freed via kfree_rcu().

This means the object was a victim of a double-free somewhere else and
was silently poisoned by rcu_free_sheaf() after being reallocated.

This happens because kfree_rcu_sheaf() queues an object into the RCU
sheaf without invoking any KASAN hooks.

This series enables KASAN to detect double-free involving
kfree_rcu_sheaf() immediately and adds KUnit tests for it.


Kuniyuki Iwashima (2):
  mm/kasan: Detect double-free involving kfree_rcu_sheaf().
  mm/kasan/kunit: Add double-free tests involving kfree_rcu_sheaf().

 include/linux/kasan.h   |  13 ++--
 mm/kasan/common.c       |  13 ++--
 mm/kasan/generic.c      |  14 ++++-
 mm/kasan/kasan.h        |  34 ++++++++++-
 mm/kasan/kasan_test_c.c | 131 ++++++++++++++++++++++++++++++++++++++++
 mm/slub.c               |  13 +++-
 6 files changed, 204 insertions(+), 14 deletions(-)

-- 
2.56.0.385.gd3acb90ef8-goog


