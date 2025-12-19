Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F512D767DA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D29CC6B0088; Fri, 19 Dec 2025 06:33:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD68B6B0089; Fri, 19 Dec 2025 06:33:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1E56B008A; Fri, 19 Dec 2025 06:33:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A9EBC6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:33:04 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D927160596
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:33:04 +0000 (UTC)
X-FDA: 84236009088.16.7E05B31
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 635C520010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:33:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YaAYfgo5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 37DdFaQgKCMEqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=37DdFaQgKCMEqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766143982; a=rsa-sha256;
	cv=none;
	b=aYLwuq5KYP3wsUZOWhUVyBL5W0SW4jMYnuIP3/EgVltgPH5xcG/x13hJXO4sM36P9xlpXa
	CSkgUD3ORbKQHUCkJo7iP42GlKNkzmN9G9x7AA+2kbE3pGHpywXGKZdcfTZBLOIdOg62xB
	Wrv7ChI4E+5SSxLZZZ8XZp+CJCH9/gw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YaAYfgo5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 37DdFaQgKCMEqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=37DdFaQgKCMEqhjrthuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766143982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hAAxcJSHCKa5e7JujPbI6PKo3xCnh6kgp+1s4KhQ0VM=;
	b=CXeRaZAu1AiiiKZ2DFqaSSUC0af53qeuny/9Pyoc0eIF2hOi9h186MVBBDH4v3BGwrbavy
	lRDZqf58Y9y1BIwXEL2P+Ves9NaN5qulAX7C4npBrjYY+zyvaAF+eACQS/SszB83qtJZJr
	AlF8GIQRihQ6RWuU+7/67fa+Ec8FyOg=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477a0ddd1d4so16109645e9.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766143981; x=1766748781; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hAAxcJSHCKa5e7JujPbI6PKo3xCnh6kgp+1s4KhQ0VM=;
        b=YaAYfgo5UfynTx+6VTA88xipH4kaOT9QNkhFRTjjn5f1n0NMwlv8v03NV7Ot+cpjFI
         hUCxQkx4Gae6NlMEf7y+W3mBP0L0IMdiy8zp1i/V2qvMT5wkq8MojBNVWZqVHCzpej58
         jlfp303UET8SVm5lpAbEEAS7Ilz03d4P3GEXiOPdYTagS6+NtSx2TqihQ1wiK2vd7aRw
         iq/1en7ijuZTQmQBOr7p22KmeDTSyHdbza9wgtWhulqHW1PB0HkNnUMzS+1LxtI1h6iq
         g4zn8U1uikpsenaLfQ0JvhGx+3JeqdqrLuCJG2P6gYnX2Rq5XFitjHk06E9d8xqoUzxp
         64hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766143981; x=1766748781;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hAAxcJSHCKa5e7JujPbI6PKo3xCnh6kgp+1s4KhQ0VM=;
        b=sT0MLQg3wq1CJI+eT5Am8hDmAUCpIA64JppHzyOf+/KgIKrgiFYerTffiFvtAzR384
         d1xMVI94ebgAkB2lLozNFwLJ8JNRz0fze3CvgtDheLMnM2SNY4bOD3Pv0GbJ9RMI4m9X
         HlTrjpE1GreLpLMbdHrBbU5npCDk+rhfO+rySPd9XoPJctoBUJuvFHsKKo5SvoICOINn
         1p/JjtgtofEcDJ1ykhjLklQsjTTtKX3mwrdChF7WDTVD8vd0UGzZZonCUFbJW+mwomMO
         CP1qMC3xIWA3UJ+li8Z6Bf1HrxUndpJVYEINhGXuwjASyHwfyW7jepmOOgzOzrXqXAYP
         1+Fw==
X-Gm-Message-State: AOJu0YybVdlnaKSRgfauEkTko6YusKciPXC4z/fAsld0HLtJuByV+AZM
	yvVky4sfS23ZdGCcoZBz9ZX6iUuRZZmgiVfmDEWA00c08xO3Dr6wEnSrgL17ImGA4s72n/8Ag7W
	CoROo/1bR3+a67Q==
X-Google-Smtp-Source: AGHT+IFtEw/tE5Tma1oMoU1xWJDXu8dPIDS5WBCwLqxTONYM7wj02qZJ3F/C/QiLC8f4W8TibL2BPHLQh6Hw1g==
X-Received: from wmps26.prod.google.com ([2002:a05:600c:319a:b0:479:2d82:5535])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c08a:b0:46e:1abc:1811 with SMTP id 5b1f17b1804b1-47d197f67edmr16343165e9.27.1766143980920;
 Fri, 19 Dec 2025 03:33:00 -0800 (PST)
Date: Fri, 19 Dec 2025 11:32:18 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAME3RWkC/x3MQQqAIBBA0avErBvIKRd2lYgom2oWamhEIN09a
 fkW/2dIHIUT9FWGyLckCb6A6grsMfudUdZioIa0ImVw6XDfzmm+ghOLNjjH/sKWtdGN0qRaA6U 9I2/y/N9hfN8PG6QN7WcAAAA=
X-Change-Id: 20251219-b4-gfp_atomic-comment-3e5950152139
X-Mailer: b4 0.14.2
Message-ID: <20251219-b4-gfp_atomic-comment-v2-1-4c4ce274c2b6@google.com>
Subject: [PATCH v2] mm: clarify GFP_ATOMIC/GFP_NOWAIT doc-comment
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 635C520010
X-Stat-Signature: bn18f315i9ma76agfiq8wfc5ez9snnuj
X-Rspam-User: 
X-HE-Tag: 1766143982-802175
X-HE-Meta: U2FsdGVkX1/1hcHixrin43e3SecABCO3v2NAwR700lF4yqG343ORW264cpa55k3PAhvX5n+cIT7nhRv+GvJ4kEKgC5UkJBlWUiQyEv8yh0h86facGYFx/6XU0BnUVJw/shs3dIiZt1SaP6RF7cBCLLr/vvYNF6ihoPjKIksJwuzahTbXPJnwzCdlSbREwk0vpy1gk0Ix9pX5E7lIInVJGyRVeyKngGgE88/FDT06IoaEOJmCcbFsaLMmrwXE118pvwPWgr6lyndRgJjMzEgQaGvLbhCKm5LV/gK8t9xBHIaSxukXmvrQlUs3t4nuwvDSHuEo9P9jPiErphj32x9lsMADhsPlH/iqYgf2u8xtrJmmsEQ06v8dbejQShygJGbnWvjYc9ff49I9PQHlByJmPkIxnvI60EUjFlgobOOahTtb8SsX53mTuD/g/UTLD/KMM8tpe9VRb0tIdv98e1IGjp6PLff/wHU/Cpre+SKTGZ1p3V+C7Sn3lsaANu/lXi2h65oohaiB2dvt2mAGFZjHLCnFLkoGyeZ3dc/n8Yg6q35QFfMgESNF4sa/WTlbQIPOCM0FWENhDcLfAMo+Rb/xo4/KEWZvoB8XjEttoEdqznNWXwwjrYmKNi4zYPF53zU65q6KShbm10BI2O+5GN/Q231CdapT9Dlv5xNwipTTsQT+7Mim797ARe43rUyxv5PP0ltyH9iAXQEYg6tiQ8Ip11DdxnT6QwZORRiPv3BoMpAMM8Kw/+1FbUzx8iBXWIzoFXwhGfOzVbmiUwO2KabV4Ib2Q/LCwfcHc05639gQ8xjvVmHqAAewhJTjZnrWDwnfXJiflAapxZCYa7jpL2Kb4uIUR+xy8X566P/rk/qyW24LLA2sfGN0zyclGQZ/s9BHUjFwIfMspbnnyaLb1fj+mm62UKqbMxs34Ks73JXSFLDR/kPpNQitQBWfEidGigGI7wcumIWmTf37ZS+kCWo
 lCFWXdj7
 P0BH0lMUCvc88fBtVhMou1K58/aKl5ZHKkTMZuU9ZehxYdR2rrGXeg3TJ5jcnnkSLOhi8LlrSOdP40MzkjYE72Y+FRuqWc7jAdBCMttkz2hCtR8W2D+ZlOTnqVs/cweNEhIfezcHt0bSXIxpW+79kB5rMqwtBF5SStvh2YlhywJtQdKDZsbFnKPMTppGVjaJ4iIczY5VPk2vKOdSiNK5Vst48+C3GGyREqDwjZbRwzmeQWd4xxGIWNa2gA/JXWJGgW3YtdDrby693O8KKIH5hDvfrehbk+ucHXP/zYJ8dxtyEey4UYdvRWcao3RetCCf1DJUcbd1fQ6Al4g1cpuojxMd5+6XOKNy/SWRIig7scdvderjPH6QIs9YiIEkFnl7xzuXQ1RBtqqtxLTjACCsYU/v/ETP3nxtEQhExTtSzu1/V5Q+FCNzHCDRe0Tt/90O4+oZY56ZSW1OWUpZKKPaNosqTtvsQfGQyGbJnLQXGDj3rqBcEcE20G8yso+IIS2D/uuIajXCEIoD688wOo0PInZwOeu2ku3MaORhvmErgASpt0aGdHzuP1U3rR9ORKNoP0L+EoFCG2Vy4UrIMGcqiyTn5mA+hjR3LHbspCGZBALJ7oxm3sYQ7TgI4LjDnRqE4c3usE929MsYC9s/966VkAaRoT8KAYhILJvQVxjZ8ubeumQ4paoMCfr/ReIISX5NZ8PJEoSvm2mT9osXdzn/whzF4AA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current description of contexts where it's invalid to make
GFP_ATOMIC and GFP_NOWAIT calls is rather vague.

Replace this with a direct description of the actual contexts of concern
and refer to the RT docs where this is explained more discursively.

While rejigging this prose, also move the documentation of GFP_NOWAIT to
the GFP_NOWAIT section.

Link: https://lore.kernel.org/all/d912480a-5229-4efe-9336-b31acded30f5@suse.cz/
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Changes in v2:
- Specified section in docs reference
- Link to v1: https://lore.kernel.org/all/DF0J58HOVLL4.2E16Q87D2UXRW@google.com/
---
 include/linux/gfp_types.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 3de43b12209ee79f84e7c9c919729303338433ff..814bb2892f99b829fde9b6dce1a317b3f29d01dc 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -309,8 +309,10 @@ enum {
  *
  * %GFP_ATOMIC users can not sleep and need the allocation to succeed. A lower
  * watermark is applied to allow access to "atomic reserves".
- * The current implementation doesn't support NMI and few other strict
- * non-preemptive contexts (e.g. raw_spin_lock). The same applies to %GFP_NOWAIT.
+ * The current implementation doesn't support NMI, nor contexts that disable
+ * preemption under PREEMPT_RT. This includes raw_spin_lock() and plain
+ * preempt_disable() - see "Memory allocation" in
+ * Documentation/core-api/real-time/differences.rst for more info.
  *
  * %GFP_KERNEL is typical for kernel-internal allocations. The caller requires
  * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
@@ -321,6 +323,7 @@ enum {
  * %GFP_NOWAIT is for kernel allocations that should not stall for direct
  * reclaim, start physical IO or use any filesystem callback.  It is very
  * likely to fail to allocate memory, even for very small allocations.
+ * The same restrictions on calling contexts apply as for %GFP_ATOMIC.
  *
  * %GFP_NOIO will use direct reclaim to discard clean pages or slab pages
  * that do not require the starting of any physical IO.

---
base-commit: fc2af7a8060126c3a99fc1dfd7c5abd71a4dc81d
change-id: 20251219-b4-gfp_atomic-comment-3e5950152139

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


