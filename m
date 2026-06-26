Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C22ECDE00E
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 12:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA206B0148; Fri, 26 Jun 2026 08:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB19C6B014A; Fri, 26 Jun 2026 08:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEE816B014B; Fri, 26 Jun 2026 08:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA2546B0148
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:43:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26B058DDA4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:43:23 +0000 (UTC)
X-FDA: 84922029486.20.5233E8D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id 55C5940009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:43:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="fKX/UsqN";
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782477801;
	b=CpFnHitCpfkfwyWxxUjeSJi6tnzMeGgVd2poTiK5eNgguRRBXodPiAhdoBI3N466fo5h33
	pgKNZW5u5xpEpzooBgMD1/yAwMx4mznnIY/s18kasYWEw/fKOQqRX6KnUYSZw/0cSzSECC
	t1RraEXZRl56Kc5EkGTNWgzkgDjB8oM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782477801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LFehXIpnlAu03PJtDtW2qnYLqBakhJsXo9kxZSgtjTM=;
	b=BVgyxTrkdqcmgofe1dthaurDDPIkXugSzniT0S1cSmPK8sVW7ZlvQD1mBAKc+jOm9A88eO
	pDB6dfyWnUEhZAVQG16NUDHspT1QF1P96Jx1wSWEJYkw9/CRyUxjP+5rW5hxVESD6Z/gyq
	NWbSygDlZSe71+DpMEuPGcem+P6gVWE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="fKX/UsqN";
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=LFehXIpnlAu03PJtDtW2qnYLqBakhJsXo9kxZSgtjTM=; b=fKX/UsqNQ6nMqZeZILWxRmcRBU
	WIMEUIkkkHx0fSyaGXaCkcvQpoOCMIKMVUhhhPuMoHBwPQnmh1j3tQJYD9h7k0T9KDqBzVB4rqhyG
	voPH+WIaazkBt8wktvWloNJZCMXpvzl8oV4nqkykiYPrDd9LkmNnkc5zbRl7/zoul0uHgqI9WVq+q
	TwdnT1NJGF77hHca+e+7RQx9v0Ax2QNK82BjvF3hW8vAUJRPAX+PN+tgZllorYHuvvYYzTadXgUg7
	UZXl8ynWJDSzDDrFYd8WtdR5GGbmt3JiPDdwepBr0UmlCGSETRo2Es4zghq9lhvuIrbyFRa2LdP62
	tfb+UNew==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wd5tr-003yQV-0w;
	Fri, 26 Jun 2026 12:43:15 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 26 Jun 2026 05:43:02 -0700
Subject: [PATCH] mm: memcg: initialize *locked in memcg1_oom_prepare() stub
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-memcg-oom-uninit-locked-v1-1-a00175936b39@debian.org>
X-B4-Tracking: v=1; b=H4sIANVzPmoC/x3MQQqDMBAF0KsMf+2AjW3EXEW6kGRiB5tEkrYUx
 LsX+g7wDjSpKg2ODlT5aNOS4ejSEfxjyauwBjiC6Y3trbGcJPmVS0n8zpr1xc/iNwl8Ez9OIcb
 rMFl0hL1K1O9/nu/n+QM4Z5buaQAAAA==
X-Change-ID: 20260626-memcg-oom-uninit-locked-5ec79dff4396
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 stable@vger.kernel.org, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2015; i=leitao@debian.org;
 h=from:subject:message-id; bh=TA0Rd2ZjkVKCe2puqV8Hx8ZyVS5qHu93hA0Ef1x/rJo=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqPnPdMiNdj8Aq4cZwwmjfA6oz+iDQ4r12lOoi0
 SDtEabzzG2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaj5z3QAKCRA1o5Of/Hh3
 bc8OD/44h+JH0trsSrMtwAxqLnmU2Dox724W+6lkQXsZkjA8VTyTHRLwsMNfUWS5BlfUuyhmASR
 CrcCCiZvvDS6mNl9b9JG8+N9yrgdXJVUPWgQkllyG3MjESZ1iFxb49An6dK9nVgTmAy3NdimsnP
 BVAeUAyY0iR3wTVYIOAuHC5wk6Lo07qjFzDdZ4NpqEkWdBSw1xb79uniGPbLaMA76xCqtgBlmrw
 BLTcvj0VVJjpCuvNUZZVhAbURSNpdGmV7VPXTP7h2jDUhPgV3jQXWBZt32+e2i60nk2rcWbvchw
 /mj0yQNGHdjCd03ssT5VBOOCHSgIkqNlfitHxBjqVi39vIDvMq9m2h1Y2B/NI8JOkBX0zySxAvv
 7Kk67mcOG98Km5KEkDlzYijy7zZ4WaRQJ4ezlFweb5KItqfNM81ZXZf60UUnDKXrlNN6BRVSav8
 /NYC+CQpPt+07QnuP4zaj3mu3zfKo1Jdn4heQkg5bmeVDEY84ququEc0Rt6nx5XukUy1BqOt3lU
 XDhMQsuTMJVYuJulL+upwwK3JhvA1dkPGIgP53MPoyTaL4ngehHCg6tSjbNwYUpUPe/4+uEP3Gc
 94AJlSSYQPzbtno6BoQLELmlAHpr/kzXUCO1f4E/S6fm2Whl7MqIasISB0TKqMgsrOEMIGi4FNC
 8kWKKL7vZoISKLQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 55C5940009
X-Stat-Signature: 3o8um63zoxoz9sfweccuy4dtxtfq9773
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782477801-112289
X-HE-Meta: U2FsdGVkX18xr7XeQHyoOhPfXsMHuRTb1nCI2zPGD+DF+JsT8ywqF6x5M9qGP0M+UIvC1di3uHJLDWnRC4zPAyJZhXttMdos1TI1TSytR/WQbCnByxIxw9TErMonksAj60EygOhDoZVGVrd/fcUfV7hvrnPJNSIkNQXqh/7p0R/o8Sh/IN80KV3B6Y4jhNeoBNU1i2CeKS17AsIHaiAMB8mE2RavusAwSWVxzstnqA6SNopplUH3+I4VKjZxeOAyTVxCA8WQuqliHki7zT/3PIEWIhi+4U/UNk6HySPaFNH+cE1zK1Vu4OHRcFtu7R4kBtQvhBh26z/lYpFiJhC4+BOdXdd3+DOgcAk/Br+EVBCk3fZUvlyXPDF/0epwYPrj2CRTxv6sqPO+6FcpA7IblvRLbJcONM7n1ZXiZw4Q2GMHtRkYqatWx43j2o60PxngKTLOFHktll8+bP0myKzUkJ2XxxQqT7goyIeJeZBfqpPIiyTd1bvEXT0j8zw+aTDcs34AkFrjEKAiXbZ2rVwBoZadtJ7DRv6oowhLipZETDx4brtO2QV1GlQmLj8IlSNAjfYZd+QrYRri3Cpm+uqrMJvwmdNXufSQ1hwdZozJK+AcqKJ+gJj75eGGn+ev62ucXyeNE3r1GC3m9VyDStAnpxod7FiJKD9mvaid/YsqRW2Z+quKeWRNj4ckc+p3Qz2KgjAuAR36ayBz4dKTiHqerBVYQpEqzil9rCRqZwfBw9P5Uz5W34cMibZAwHve2E89z4Buc0QbhatG6pYLrJLI9LfnGmxIIobGFq5aYUca3aV+26NTlzjHicclGIg62/7U8oZfOOfOsP2li6nmHbz5Xgx9+bY7K1B1je7G86bNsFCBTyvxZ0D7XpixJQ9y+DzCQ81d1TyWV5WtWVOFi3H6AdtwsCuKyDUw2LxXYualJAzB75voqJlS+d+NwgVLLrhGxoevxJvqBBL1jq7qJbL
 PPZ3PUFu
 gCvQ2hltA041/TSaWkhDybyYlvWw83DYcstLUkNGLEuHjkS5reREdt2oUKbPv7azMtRITS6yPfwfBXQNM1ImGWBkf1H4sn5JsJshbhoOf61ZPvs1haqgJwbH2FpLuCjTpnSfib7rmqkjMSQpKuAtjExNsJGMUXSaY3QE9t0jSARKGrAjFiNxj8GUOd0j/WM/XucR+tn5vc1jASDcgJSYPr+THx2r68tovsxTyCeyBcsZHcFR9crFsb/GH7oH8YdTO/wFg0k5HW9Z5lB7FLC5PuH0wxxtr0x1MU/0zngaXWl1kgBHrCOh92m1TTn/IqctUSWtxX9h3yP6i5xO+S5uJOjvj5HC7pNWKYKFe6tN+BakmRvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
and reads it back in memcg1_oom_finish():

	bool locked, ret;
	...
	if (!memcg1_oom_prepare(memcg, &locked))
		return false;
	ret = mem_cgroup_out_of_memory(memcg, mask, order);
	memcg1_oom_finish(memcg, locked);

This relies on memcg1_oom_prepare() setting *locked whenever it returns
true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
CONFIG_MEMCG_V1=n returns true without touching *locked, so
memcg1_oom_finish() consumes an uninitialized value.  On a memcg OOM this
is reported by UBSAN:

  UBSAN: invalid-load in mm/memcontrol.c:1932:27
  load of value 0 is not a valid value for type 'bool' (aka '_Bool')

Initialize *locked to false in the stub; with cgroup v1 compiled out
there is no OOM lock to take.

Fixes: e93d4166b40a ("mm: memcg: put cgroup v1-specific code under a config option")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memcontrol-v1.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index f92f81108d5ed..4fa6e2bc8413f 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -107,7 +107,11 @@ static inline void memcg1_remove_from_trees(struct mem_cgroup *memcg) {}
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
 
-static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked) { return true; }
+static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
+{
+	*locked = false;
+	return true;
+}
 static inline void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked) {}
 static inline void memcg1_oom_recover(struct mem_cgroup *memcg) {}
 

---
base-commit: 4e5dfb7c84012007c3c7061126491bbc92d71bf1
change-id: 20260626-memcg-oom-uninit-locked-5ec79dff4396

Best regards,
-- 
Breno Leitao <leitao@debian.org>


