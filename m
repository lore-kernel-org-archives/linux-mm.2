Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79D5AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51CC26B0099; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5F26B009D; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BDA46B009E; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 072886B0099
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 908C6C30FB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:05 +0000 (UTC)
X-FDA: 84972993210.28.3F5DE51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 05E691C0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ksQpn3Xo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7ZtSpW2RnXSKPujLfG/ONrU6HhGNSKvAXYdnpd8R5s=;
	b=ghxqXy7wjOmAbRXMyVm5JvWrPtuGRn7JU2XlfmpePa8AjWSmOvPdCxjHK5rgukuuRf+3Bo
	Ug4T1IYpWuVJBBgJsrz5qKgsMBjf4+907x/i0T4YIouyo+YefbEltVNe8so6LpGAPsqRZo
	KpL/qfWqhwwCbvRQlK65wLo0khj2Nbs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ksQpn3Xo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691224;
	b=HlGbr0mHyipkOne93A5weDmoEbwYh38lluMqApQpgvqThBeIxBaKfA3773+r3UEHsOa3WM
	6sB7zcRbNvGSfGx0Y3qXGv+gFfRiG1UKvkRaJrWmi7uvxdsfk5A5/deYeRTnK73/ioh/Am
	uGPLIdTloYQRAVc7nx+n058pG3ExADk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 998A0600C3;
	Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298361F000E9;
	Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691223;
	bh=J7ZtSpW2RnXSKPujLfG/ONrU6HhGNSKvAXYdnpd8R5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksQpn3XooyXtgVbh2itwhbSkyiYuLCCD2mosdPFGFU4SXeO0ieOfNZnvXiMVZjwbd
	 rhNRpgRuGwmc5qujiaBFyfqHttPfRubESbDw103op4z9jLEnxrnlImlMPk53V2re4H
	 N0ma6EvUOAkBjwRffgVYHOtANFWXjfgEA1bqbJEeNnOg1V0wIaWeBNByAllWdFHExB
	 PZQaxqLT/JOTACQ5LBldy8ATRdVBWPW2lDJA04fNU63xTcOGCJJeb8orWw5+e+1Pd4
	 aO/GDkryjXIver/KSmdaQDWAIq42YAvOPxwr4Gp1KS/Dq7KZdhewVboCTAwCTrLR8p
	 nRP5f5rS+Rp4A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/19] mm/damon/core: disallow probe_hits overflow on attrs only monitoring
Date: Fri, 10 Jul 2026 06:46:38 -0700
Message-ID: <20260710134651.18084-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 05E691C0005
X-Stat-Signature: x7bow1t686dbdbr1ttburxfb3z1ysn35
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783691223-114635
X-HE-Meta: U2FsdGVkX18/2vLNVpnESS595419rrEPWwY1RkZpuRVdEVvTtyubR9VOmt59ssN41h5CftL62dSI4065x5nesA5D8PI8ZINi4PSnI7LEFyC3v7X6r5Y2iFW2lM6OPFj+nxJkkeFNmNYxXDKKSaXg0Y4d14uKfvi6gCG5LjxHiP5QfOz9J85tuUY14QxXS1iKRwv+TQLcIPE6HocWlYXpe5WmmRuNCXI3SRL+4i0UcECVIcXNCf10E3yRqeJFB943gH9jPWwxf+IUKUbuWjO5+4xgaAW1mvCATdCoAaLQZvZPzG9cRe7lsju45pOoJdIJbTLsrFIBYigSXduosOG4Xv7I2YyNb+GneFnWKupPpb+ms2LEC06ugl/B0QM8JfEnAwK44kOPNiZbicE/K95zFsqXrO4H/vf+B8KWOK31FMRikS9F7pB6diMJ/l4AF4PA7AT8FxAQoRE0fiwIu2gAA2ZyZPtsIJ+NwPWeRc53DOIY1ed0zBlPjl7L7wuISFS7E+aoL3JlGArkoqkqnJ3WsMUiufviCpQVyYa5i2A8B7xmZBPtm/i4Q8bnf2v9AP6ki7PCfTNWb1xB+TpN6Ft/vKPCm+p7DHaZlis28D6/QBVJFmMyK0yNqIqcXP5lZH1GKpl6xMCCAlhMOBk+CQMgaisXa2EsJcEnR6nKn645KhD2kEq4FbHxVb/251u9+ZD5cVMN/PZBnMMJ/ZM39OCKqvdThsQnl6GRORgj4Q3WetzisoATxC9rti/y4WbwR5NKpBgZaT+KLPHWw0X8rDQdMcRF/uCaeQi26EWLN2VsdU+eVROevXmaOERemixkNrGWlwJrVwbd2Ry7po1FGMJ5lVrkI0i6amuJU0dwo13HnwPeqOD1ordKitjJMq6j9/hostYAdYwSGcR6tI2LaFP29FypWGAUsSebKcItDC1bLrdgzfHNXjIh/SN/oZrq0q7IkFdt2gN2NqzBHePQXvY
 6Xlj3Kb2
 r2kwCvrIAhlJe3igoMOhMvIW3UjrhuakZatPI55Gs/Y625BuM6EfHqSbweIqTKvDtPozI1ZXHF0pGCJGKZq2uMNBmMMyjeQ3WyQSnTwkglfPMH/k5aA/vun6cNefZHz0k4uHJ8/mQl1Suq3AJJI3H2uGvEsmnmdGeBdAvdX1Vawpd1PQIINiCb+mQdgoni4jJa4Fi3iOiJkoqEvNqghEytx4VJoGq98wC6jO+cI1tLI4SAoJMX49zW0QUGDH1dlNG02JIvne8FnUhyVbj/civRwDiEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When any damon_probe->weight is set, DAMON will do only probe
monitoring.  probe_hits is 'unsigned char'.  It could overflow when the
aggregation interval is larger than the sampling interval times 256.
damon_as_probe_weights() always return false, so such overflow cannot
happen.  Even if it happens, it only degrades the monitoring results.

That said, the overflow is not intentional.  It is better to be
prevented as long as the cost is not expensive.  Disallow the overflow
by adding a validation logic on the core layer parameters validation
function.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7d49420ea26c4..4f1425e56950b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1332,6 +1332,19 @@ static void damos_set_filters_default_reject(struct damos *s)
 		damos_filters_default_reject(&s->ops_filters);
 }
 
+static bool damon_valid_probe_params(struct damon_ctx *ctx)
+{
+	unsigned long sample_interval;
+
+	if (!damon_has_probe_weights(ctx))
+		return true;
+
+	sample_interval = ctx->attrs.sample_interval ? : 1;
+	if (ctx->attrs.aggr_interval / sample_interval > U8_MAX)
+		return false;
+	return true;
+}
+
 /*
  * damos_commit_dests() - Copy migration destinations from @src to @dst.
  * @dst:	Destination structure to update.
@@ -1736,6 +1749,9 @@ static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 		}
 	}
 
+	if (!damon_valid_probe_params(src))
+		return -EINVAL;
+
 	err = damon_commit_schemes(dst, src);
 	if (err)
 		return err;
-- 
2.47.3

