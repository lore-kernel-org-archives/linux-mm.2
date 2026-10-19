Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13D04CCF2E5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCFBE6B0285; Mon, 19 Oct 2026 10:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7726B0286; Mon, 19 Oct 2026 10:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDA56B0287; Mon, 19 Oct 2026 10:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA9F36B0285
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:37:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 120F2160762
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:37:23 +0000 (UTC)
X-FDA: 85339628766.03.7638242
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 95C5820006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:37:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eCCFjJ4m;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792420641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TzeUsHBgfXPKsjgzoOJjZ/KqkTpciOqCZplZVywH5gw=;
	b=rbUJIm+54++viu3Pgc1lZ4rwIXIEtEyIjLW+837geBxVlp+QjusidHHC62sA8iDj7Q4xMP
	HCftjmfwS6Ex4dzAy9BQfKoF5+WBLznha6eBAE9OvdjcYUwva8CpArmuf28GKnCskyqFl/
	oekJpBJ4Xjpcp8f1hnpecAiCmv5F4A8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eCCFjJ4m;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792420641;
	b=SpnygYYywxTctF2xpsBaY9ySFubftqHnq2SbohudhFXDQESxI1xZMvVmlhqZ6Y3d6adLcg
	OyO3Dh0YWDri2qSDRtpH9UFBNjdzoVA0HZZwAbc3c+YAHZ1kXcwTzwFTJPkyKbxSJKOmTj
	VPOXOZUwrvoUy5W1pzfA/+VLPdvaDdo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 195AA60D84;
	Mon, 19 Oct 2026 14:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9734B1F000C4;
	Mon, 19 Oct 2026 14:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792420640;
	bh=TzeUsHBgfXPKsjgzoOJjZ/KqkTpciOqCZplZVywH5gw=;
	h=From:To:Cc:Subject:Date;
	b=eCCFjJ4myRysM70jqHB5+xC6TSc+ICnmeZSx22kHDNs7zQrWNfZNIOZzdLJbZEEkL
	 CK/WsOIJ3oF8UUhX+JBSvcYiED/f8QsVo7/qfzBG3mIo27fL2NwSpQ//eVqCJTGmm7
	 vkzGWzZO94a3uRDM8ofv4j2dElI2vPlhGFdYt6/70uC2YUFr6Muezo8/CDIeI9OpQI
	 zqzQyr4ydLMTTuNOliHnz8+PDdutxtxb20jDTmcmTugK39k7sCROq/IJA4pT1A1IQs
	 Z4lpEe1Y5vLb33MMnBAT2eG8nqZEggI3vPJOZX2X64kWHKtdTqGSJt8qDNNGAAKU/a
	 JqKKnDBLlZhfQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Mon, 19 Oct 2026 07:37:11 -0700
Message-ID: <20261019143713.98610-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 95C5820006
X-Stat-Signature: 9p5m7t6hrpjkhyfedfrtg3n9nxppwz8x
X-Rspam-User: 
X-HE-Tag: 1792420641-376351
X-HE-Meta: U2FsdGVkX190GXsHHRZtHM/9cUmW1GRRp1u6GUJJuSZftHI0ITkzFBvezWC1NTQ/1vDHkoP/QIbVeZjO7PRqC7nJhH+wVW6n5giB+KffnmA/2TWSDy4I/eyI0zZZn74RHhBVwMKW62HfFWLqQgv6X1THWhuxZA3XSmYB9A0hcWvq0EtfFIeQ+bvzEVWEJjLi8SlXXWlW5Pnn5M+KSa6/SCqnG+WM20MEPxOnXHi/WTNZ2B+XgDfnTK0RCE7xIpoVYAz64VnIFU9AArKXhw6OTx3yEqEI2i9Kq97Eeb6iG/aIQq8UzPuiH8Tq8UCqrt9MFsJoNw0OjCKa+v82RLiTaIZ+WCis6V0sZoGpDR1P/BRUVcsvpOKeEIjKpcRVvgRKsqFHXgtjveWVMX9gDeVPc9X70QmrV5uRyrNxnQX71YIZFlE1UTRXGonHpr2JplbgYOIvCxR3HQDI24tlkNrHyQ0FRV1A+NlGN8iWOr9jeJiYD/j0iJWHu60n5QTu4ki3C/nwU32Zh8gE9FAGqMBXi/EzaacVPi+Z7ubrfNkN90rCW+hpJYlevw++fk9DH+iP6QQz4e3jSpKY+oeN08EXMuoQ8U9RgXdmBsLdY/FecX5V0e1CX3oHnIoBqI32sRekW01i1LWCOPiMsGzRC8Dz0uJKf8JjEiuIslid7IaMClEZ9Fg24HzFrOGBYb4GyzNg17dbxcTqQkX6zSnJfGT7zf1e0EoqWP+nLJIJQ/Jy3UJydzQvjCDoCy3Cxjrxl5zpt20E6LvfWPeQ4t0l97vwvnNB1NB0v4ug1hJ3PSIC37mIKPO4MhR7V5Ii2CdT58bg+obX2RwUYmiPQaBQALHtY1DO+TJJ16OzcbqBIygNzJ8pzDMotxxK2d/J6MTk2Bx+M0PFkXzlPKsBLL+O0F5RVtVEvnihgqXNiAQrUE04F9FsTuqVZSNu0XqbK0uBsrk0oF3serG2rdzYiloMA7F
 0lsuVfZh
 ViyowuO/1f7hbpSkC4m9TPwTxCmzMsQaFrrhDLXRm0WpCS0mZAsWsZJb6lLDZ2dEHbWZAo0QedG1rTNH9C8kB6y93949RvBIteLp8tEe73c3Ibr4VQHnExPd2MkHiorBIZzOYg3rcyeNYm+z69iWK9xs9TXo71ehqlcFLiaO5co/D49h2z+2pMuq852laSb+c1vmrcrGiMueg7QPLloR4md7lR6L2Nd2ww0W98stnWRAvgD1Cl9+eTF6lyDYNHbof5fh09N2CmDD4njcpXJZjuDENZFcrj/brNQRpZ4nq8w8Q0wG0qCNBL3AzWgL3smW2SfJuD5ZzLn6ZGMxZoBqBzvYdMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_quota->charge_{target,addr}_from saves the target and region the
scheme's quota limit is reached.  damos_skip_charged_region() skips the
target and regions before the point.  The target that was assigned to
charge_target_from could be dynamically removed from the context by the
runtime parameters update (aka commit) feature.  In this case,
damos_skip_charged_region() cannot find if the point is passed or not,
so the scheme is effectively disabled.

Similarly, the user could also remove all the regions of the target
using the runtime parameters update feature.  It would be uncommon to do
that, but it is a supported feature.  Because the skip pointer detection
logic (damos_skip_charged_region()) works for each region of targets,
this result in the logic is entirely skipped and the scheme is
effectively disabled again.

The user impact is that the DAMOS scheme could suddenly stop working
under certain uses of the runtime parameters update feature.  It could
surprise users. No crash or leak happens though.  Users could also
simply work around by re-installing the scheme.

Catch the corner cases in damos_adjust_quota() and reset the pointers.

Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Cc: <stable@vger.kernel.org> # 5.19.x
Closes: https://sashiko.dev/#/bug/linux-cd0c55fc-0cc8-45d8-9637-3334811c49b8
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 479169dc9ac75..eb1fcdabc0075 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3383,6 +3383,26 @@ static void damos_trace_esz(struct damon_ctx *c, struct damos *s,
 	trace_damos_esz(cidx, sidx, quota->esz);
 }
 
+static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
+		struct damos *s)
+{
+	struct damos_quota *quota;
+	struct damon_target *t;
+
+	quota = &s->quota;
+	if (!quota->charge_target_from)
+		return;
+	damon_for_each_target(t, c) {
+		if (t == quota->charge_target_from) {
+			if (damon_nr_regions(t) > 0)
+				return;
+			break;
+		}
+	}
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+}
+
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
@@ -3418,6 +3438,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 			damos_trace_esz(c, s, quota);
 	}
 
+	damos_fix_stale_charge_pointers(c, s);
+
 	if (damos_quota_is_full(quota, c->min_region_sz))
 		return;
 	if (!c->ops.get_scheme_score)

base-commit: 46165457cd36362f10fb784de8ce4925d6dde119
-- 
2.47.3

