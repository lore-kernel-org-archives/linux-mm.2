Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA2CFEC11A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 21:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C8A96B0005; Tue, 24 Mar 2026 17:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1793A6B0088; Tue, 24 Mar 2026 17:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08F3B6B008A; Tue, 24 Mar 2026 17:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA2236B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:35:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A44D1404A0
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:35:24 +0000 (UTC)
X-FDA: 84582262968.18.CB535AD
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 93CF94000D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:35:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tdw1Hhqv;
	spf=pass (imf27.hostedemail.com: domain of jannh@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774388122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oT0RY53ohSbpUHq/mckzhfzjGE6xK7YwQGcozbaC4yQ=;
	b=3XaXdoXEnGSHViBFfPAyVJDLEGSMgJXVCoh2+Ss4mKjzpLp/PDyJ1JU+cRaNiE2YcIva9n
	OwQRb2ttwpgsLWUuCbPs7wyQ4sDengbN0uMNwGQXsRX8tqUc6s+zXL2UNWPq3C0DYBC1NS
	drAFDeLRdDwjInypuMcFMmHUYRepbYE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tdw1Hhqv;
	spf=pass (imf27.hostedemail.com: domain of jannh@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774388122; a=rsa-sha256;
	cv=none;
	b=7AIu//0MniQ70a1gzSR5XhRZ9eIwZj/px7J40uIVSfOILShdqR9kxa0+CiyYzFbamuo3HL
	AvniFUW8z/gCOQdAqIpHfE/eBISgJKS1GwW89zDxxZNdCKoHSlT2H3tlPL8IfzkpRlZb25
	cjCDvkDCTUTeCQj6IqtUdSMJn2SXtp4=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-486fb990b9eso25865e9.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774388121; x=1774992921; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oT0RY53ohSbpUHq/mckzhfzjGE6xK7YwQGcozbaC4yQ=;
        b=Tdw1HhqvfjU8IsqZJwA+Obb29L4EgCFoevjHmJdkOvdZvATCbh2U6nmmHJ1ZTETwf/
         Gd+bIHrDZWf9QHtgEQfQcxnZnP7p1J9zEaU5fzVpcw3TK0+EidjhxeOXoFd4CHWkg/oL
         KFHdzbYvDE7eMeo21G9O0NwZPfM74Hw9SSPM+N1mZWR9wRfMYFLNQqdelgDFHxb7gsX4
         XFARVy8RiLHy9+iq3nYJMEvKI1wDK6+/fEMrvHZXDLMgMcKjkLiwabMqSxXK9R1HfKOo
         QQkULtHmsvHWkKTY4ZOqpcJSRAUTIyGWYjvwtnodPhBOpR3A11pmhukHJfup8iO4mVpX
         hZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774388121; x=1774992921;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oT0RY53ohSbpUHq/mckzhfzjGE6xK7YwQGcozbaC4yQ=;
        b=rucTu8e2PUYhYGvXBlYIRxK1ibpYHygcs0NyldLMK3qFRz+8KmG/zfQBYObFEfeCzy
         6ufF7ssOKLWL+MDgRsckOez858rrRzwnXOxJIA1+PYFUzJEAkPF6hZcf8Bbf7SxKXSoL
         3+ZeV8j+xHzPeOtu1+Qg4NzqXL7z/So1u4D5hF5T6l0FpEmFfL07b0AgFb0hRDLTZs2h
         F29rEYSf/nrLgm685hDHPUjHP87UPk8XaknS1IINpDKjCGhr3mzyBGgWIbeEEqhScVsN
         TsxCfeyuKd3hdOBeT+KXT+JNMsifXv0rk+pmVHuAohr0sTcPz6zRngoaeuKRCFZ5mkgE
         91iA==
X-Forwarded-Encrypted: i=1; AJvYcCW8fTpnLHZA+V7KC+F8PvUcHYDL4WtZFrgj2r+vH6435q3KtoAsoO/piwkRLa+kOUXt+Xq4bIpjjw==@kvack.org
X-Gm-Message-State: AOJu0Yz6k5rAIze61xb/XXo44wZNrwZuCaL8G5ch5d8KVVVHhebo6jCq
	P0HAOWKPRkKemozrRuIsTU4q8KOGMamjW0byC8+eQBj1kRmKucKe0+hBwRPY4DrQfg==
X-Gm-Gg: ATEYQzy27Ut/mbvlNicSnGl24R+6YzfmhZ+8DkFmj0hin+tWQRL/cLkIDVigj8Hku5Z
	rNDidcAMuklTSbokMjIMAx+OE1RNSHZrQeyXPJiTlEQq7/aXPYD4q2LqKNuxyaaBY33750TM4AC
	cjOrZXKaHOZdNCckNUtlRUNtcF9a0RLNC2H0sXbMKzNOoTcG/LAYhYktyg6FXKMIJ6YMqb3Uxuu
	Nsiu2Gxxj+Pe5FIFwzQHh77puP3ieJCIFQTNZvCb6JP3DbsWJVyU7AYFsXKJVws4upYdZccEIZ0
	apLejZML6RKD68k7vtm1ZjN8m569X3DFwQupcBnIAomSX+R49tNNS7vnPu0XIAeStUoxGLwliky
	NCej+9/eQwDB1l4cLRzKWwbh19aZLMWqVRbuSCjwsY3xSJeMyUvIODj74vSF9qMZIw6ypdJESOO
	AQhMxpMphAGYuImHijv0YrGfOVLIfyDr7Ni0I9lkQ6qmY0W1mieoTMHuNQFRjDDw==
X-Received: by 2002:a05:600c:c1c8:20b0:486:f772:91c4 with SMTP id 5b1f17b1804b1-48716819f7emr188615e9.8.1774388120569;
        Tue, 24 Mar 2026 14:35:20 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:ded1:e23b:8c0a:3b21])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43b8aa474b6sm710974f8f.10.2026.03.24.14.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 14:35:19 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Tue, 24 Mar 2026 22:35:12 +0100
Subject: [PATCH] slab,rcu: disable KVFREE_RCU_BATCHED for strict grace
 period
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260324-kasan-kfree-rcu-v1-1-ac58a7a13d03@google.com>
X-B4-Tracking: v=1; b=H4sIAI8Dw2kC/x3MwQpAQBRG4VfRXbs1xkS8iiwm/uGmhu5ESt7dZ
 PktznkoQQWJ+uIhxSVJ9phRlQVNq48LWOZsssY2praON5985C0owDqd7NAG1xlbtwiUq0MR5P6
 Pw/i+H49oAKphAAAA
X-Change-ID: 20260324-kasan-kfree-rcu-4e7f490237ef
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Dmitry Vyukov <dvyukov@google.com>, rcu@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774388116; l=1651;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=usnnnH7wUGYWY5NIsmoimFYx19G6HqPPrRI2oZAKt1Q=;
 b=SgmquGvg0X9VR0OP0g3btEDHfyjT6PMsoHAYVyfCmCV0ATxqjDCX7hohdeoRiLQJIAjY7BLQY
 dwd1J12BZ0kD7ik8LI0ZUha0325jzs7B3OE7eJaqSFXoG05/MNUX12w
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Queue-Id: 93CF94000D
X-Stat-Signature: tpi77rkudobfgdw3fhazf8tjhtry66jy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774388122-754245
X-HE-Meta: U2FsdGVkX18tZSSBRRGB6y3DgsfVTYQmr3X7ZFdLXirPtxEBn0y9iPqO1FTd1DpLU6mbIhhhyshsgzQHl15FljXdYsyENcLSdHXNvR6N7E+G1IB0/AAqGtvzh+E7lkR9a8YzYqOdHJ8PhBPymbviL9DkDy1W7G+AeIhyATdSigv/3UB5t8GgsSEc4pvoBhYIJ/F4YLBxz6Gg2v/laNexvdL+k1z1F1qBgZZKvlQzRODASMWz3wJ9kLNX+C3FLvW3UUvjqf7HFoYc8ozL2wHFCQCRb9Fh6PberjTMT2kMcOGrlf8eHxQAoch37Pfo5Lmp+Utxd8DwK7qpeqvC1BOdrmy4qKluJxaO8e3IXTjQGUwyoHOq+IyvN6p6lVxhnHbkpmLDp1C6kh/Nsr1CuAI47OB6Fll1SsHD7np4KZ3XA2lHXvpBgBmfLb+oCGjnGP6byrd30kScLe4RgAL+N65qy/1SX38B96HHmn7ZdFcXJLpKEZJiKyJZfi7JxQEFMmelU7g0SyCTvL44Il8N1Ec1+1SQmU75YcEhzpR+12YnIUyZMrUZ0Ht4tERIKNS7hSFEafvY3yZV7frQPwv4IxEp2wsBOy/S2bhKg6inhILRk4ywYESo3cSzzDYRMNt59DHsAkM4j3UfebxBVD1ijnVkKpli4a9Lyvi8Ytua5AFjR4ZwmP0fGHvQMMCej0LMkfAdMdwbg7q5ezVMfiJcyz+KHOOa3ybseWH3tgs5IZz5+BlqFQBTDAsAIj2aOFFf/NY0uqs6ZTJPLR3fkzUhgOtDMs7wCyvTfqHpq+w9wXfcQ3SmyMyJF9j//GauAm+ksmo8btKZF5X9qOXW0XBMmxyNPa2sns+8ZfYrOKWY5nCaTw3M3JH98H7XefbjnBA6qEoHVOEsCNkqL+2ZPtLEPVA1+Yh+oDQrJIK3lb3O1wnb4xhB6B21Kx2ijXDC2I8FIOUCmalPvYngWDi6Vrox4Eb
 32WXHwty
 ufRc8wBUwR9+/DLky/ClH47mOw1Hwn+rxyKrO7MpRjfgRO9NwZOv2FRwL0rK89N0ZEVlj+qoW4RUYzMLQnKE9ITENrtPbcAVk1u586V3Nji5SsYqs/4OYmHf+9I0MfHTHCWxQQAlA1LxYVo+J/gHGl3IHqv6CFS220Mn0NK1l7jOjDzdXlN1l/RBtSK4faI3i62QoAxX5hhefnkW/fiBzLbiQNU1Hd9oBFH0IID5H+4JKMeG3ff5kqpws4EBHG/eiTrktmT4PD4maq703Fbz6RtfpaI54ls90ZEU6K9C5nBo2J67IglLo4P2gvquUStQy3bYIBVSK6mp/xBxQpoxh7bsLf+UG+R91NFWlDzD0bS+y8IHJmUDEkujxOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Disable CONFIG_KVFREE_RCU_BATCHED in CONFIG_RCU_STRICT_GRACE_PERIOD builds
so that kernel fuzzers have an easier time finding use-after-free involving
kfree_rcu().

The intent behind CONFIG_RCU_STRICT_GRACE_PERIOD is that RCU should invoke
callbacks and free objects as soon as possible (at a large performance
cost) so that kernel fuzzers and such have an easier time detecting
use-after-free bugs in objects with RCU lifetime.

CONFIG_KVFREE_RCU_BATCHED is a performance optimization that queues
RCU-freed objects in ways that CONFIG_RCU_STRICT_GRACE_PERIOD can't
expedite; for example, the following testcase doesn't trigger a KASAN splat
when CONFIG_KVFREE_RCU_BATCHED is enabled:
```
struct foo_struct {
  struct rcu_head rcu;
  int a;
};
struct foo_struct *foo = kmalloc(sizeof(*foo),
    GFP_KERNEL | __GFP_NOFAIL | __GFP_ZERO);

pr_info("%s: calling kfree_rcu()\n", __func__);
kfree_rcu(foo, rcu);
msleep(10);
pr_info("%s: start UAF access\n", __func__);
READ_ONCE(foo->a);
pr_info("%s: end UAF access\n", __func__);
```

Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index ebd8ea353687..67a72fe89186 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -172,6 +172,7 @@ config SLUB
 config KVFREE_RCU_BATCHED
 	def_bool y
 	depends on !SLUB_TINY && !TINY_RCU
+	depends on !RCU_STRICT_GRACE_PERIOD
 
 config SLUB_TINY
 	bool "Configure for minimal memory footprint"

---
base-commit: b29fb8829bff243512bb8c8908fd39406f9fd4c3
change-id: 20260324-kasan-kfree-rcu-4e7f490237ef

--  
Jann Horn <jannh@google.com>


