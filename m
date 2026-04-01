Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A30510F9314
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 00:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98CC16B0092; Tue, 31 Mar 2026 20:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D216B0095; Tue, 31 Mar 2026 20:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8532E6B0096; Tue, 31 Mar 2026 20:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74EC36B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:57:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F63559358
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:57:50 +0000 (UTC)
X-FDA: 84608174700.25.5348606
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 43FABA0012
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:57:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QWAI9fWS;
	spf=pass (imf25.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775005068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pQ3wYd5TdmcxD8UGZttputL+8GTU7GyLE34O1doQru4=;
	b=bMLtQRwNN8/8IQDL2Op860u937h1vkVUpEY5m3wKH4qCaE8TX36I7wcvMRCF1AW7X2W5lc
	XDRjr2n0AEC8Hsm9Ll1Zh7SSa5mUNC7bNjmoNbGxM9Jglr2ODft5EcRda+0IjBIVLGMZVI
	ppK3xppEspeBkVycLFT/JrBjRuPg84A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QWAI9fWS;
	spf=pass (imf25.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775005068; a=rsa-sha256;
	cv=none;
	b=f48cRvtQR5h8pBbqTsj3ByqRPGobNVWRW2Z+KB5QpGVprOVeFdAWDxUc1QwrV/Q3jbhKhR
	WAmKNva202RSQRyAtv3oJ/73DeUGVhMRtlbPKNEEWT9ZKgP1dMWtQG/CLpw0e4vlc49kaz
	Bvi6iBriPPrKpfpfm74N4SVS8Dea9UI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775005065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pQ3wYd5TdmcxD8UGZttputL+8GTU7GyLE34O1doQru4=;
	b=QWAI9fWSpGD45Z3Cldfr08RZHzlK2aCewSTUk2CkwtyQcCyCrDI/SR5jEZRDAA4rlAXQ+j
	vjXSKqvMziCRQf7XTXsjeDGm01U4LmM1XG71CsZFQythyPLPmk/sjRl0Y0VAr246kHIcJ+
	rFtCYZ8vLTEszInO3VK72uzRoPgXHVQ=
From: Jackie Liu <liu.yun@linux.dev>
To: joshua.hahnjy@gmail.com
Cc: akpm@linux-foundation.org,
	gourry@gourry.net,
	linux-mm@kvack.org
Subject: [PATCH v2] mm/mempolicy: fix memory leaks in weighted_interleave_auto_store()
Date: Wed,  1 Apr 2026 08:57:02 +0800
Message-ID: <20260401005702.7096-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 43FABA0012
X-Stat-Signature: 3sf7gjr81w5jzsu8zd15j5mm4sf1zyc3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775005067-12265
X-HE-Meta: U2FsdGVkX19GkrnLv9uP4e1waXmrqvfg9V2Jgz1DckUW2exaRetZo48UV83dvF1mB4nvaeQYKYxRykmmEIWXALgXdI5QP+h7EJuuVvAjyEnAEIwLj+IyF8yWKbcsLGxSW4ZmOkx7CNd0k+bfgI+Decm+6HqR1WpQHpfaTEMAjJPKnpzq2yQ8spn2Em0/x3ioEpyum+eZ/iZ+RFG/qZQK3XXWCyeggjw3Hvl4DCUE9cO/lLftMF7WhhQONMjc/d/VYsIIBCrWbw9H4mza6AaqySX1YuOc7AJe3eD40r9HUk6Y79iaTepfUe6FO7BlMg24ttWqX6uCBHgxNPibSEwrciz4904mNrFTJxye3u9Rv41+nBPICa4Vg+h+cDF15zdkh5JQ++Mmjtb5SN13o6KYcK4Xo4i1YNDQZM70PoN127tYfYHU1xBA2+TE7jJpcgS8WucUzCITzTDScxCcWVlFVHLf/s37NY8lhYD7A7pzIrRdNjSGfNvBUX1neeS6+DFUKtrAhBH0jdOVrlxksS22IEKNrdvVCPQXJG/JJttzge6xUEaDGUA8WsW70qZir++wDaPh3LlSGHyrX4pbMiT/DbG0J/KxGuv5JyrPv0+20USsCBeaoUDKY53cWK+G/8su7w9DK0sRiqswv7lSfK227gFLvDyoP5ojuhiDM9hufRer1giOlyFPpQJdJUlXLYO0pw0eevR8s/Pejz8PcnG5vWB8W3UKNKm4CELGC2MalC9oEUidW8x/Ne1Y8doJniXhdimqfgwd1FTsNcwhawumLJnNPYdu73YKNf8k2tGw83s4jrzadkTkJpakOqWDS4TDWMFuprFq91MICdvu1x/2mp8hZfVmEwgqQWn8wmmdRl/mAE13zxpjpIcQvLQjisDL9QUUJuuqgcBHLrpUtbSuqfnQ0fFbRjDAbLqFSeTfY6triu44mHEeGZoLNk/kGEgVMxaEi4nM0fNG3JVIfat
 fwr+Mvka
 VqiHRHwKc8gG9r6JS26Bb2mC5x+HNVNCs6lIQoUztgDFXFiKbKVENTa9E9u/yYzRMzqg6Mfkv8C4J9uzA7CxzHgr/2GuPfiFgOejqmb89sVYsNqLRW7ocWSzhjpy5G66xnq70OhSXkGIFSZnwiuUxwdyGHM5lsnwMXE90qJPbxkBUgDi++xJc9SKfnbKeYOrCG/mUkDJOak4sdF2qh19yL5/m/aLn/KsO8Kcqy5XuyCFPlgpVBzhrFoQZRoK5Ik1+judZ2poNy/LIkEOAFoEbt6I6wH9cpKVSC0E5rbNwThKCrFt0Blt5kaM178mheJrgp2hg9Dt6mySkbTXF4DOiDY8btYEetRxvRzPldUi0wa1BX3yOOQhpFER7eA2pgARLXt/HumWT03jX2uSi+h4qegqZfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jackie Liu <liuyun01@kylinos.cn>

weighted_interleave_auto_store() fetches old_wi_state inside the
if (!input) block only. This causes two memory leaks:

1. When a user writes "false" and the current mode is already manual,
   the function returns early without freeing the freshly allocated
   new_wi_state.

2. When a user writes "true", old_wi_state stays NULL because the
   fetch is skipped entirely. The old state is then overwritten by
   rcu_assign_pointer() but never freed, since the cleanup path is
   gated on old_wi_state being non-NULL. A user can trigger this
   repeatedly by writing "1" in a loop.

Fix both leaks by moving the old_wi_state fetch before the input
check, making it unconditional. This also allows a unified early
return for both "true" and "false" when the requested mode matches
the current mode.

Cc: stable@vger.kernel.org # v6.16+
Link: https://sashiko.dev/#/patchset/20260331100740.84906-1-liu.yun@linux.dev
Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
Changes in v2:
- Move old_wi_state fetch unconditionally before the input check,
  instead of just adding kfree() to the early return path
- Also fix an additional memory leak when writing "true" where the
  previous wi_state was never freed (Sashiko)

 mm/mempolicy.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cf92bd6a8226..ebe4bc8220b1 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3706,18 +3706,19 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
 		new_wi_state->iw_table[i] = 1;
 
 	mutex_lock(&wi_state_lock);
-	if (!input) {
-		old_wi_state = rcu_dereference_protected(wi_state,
-					lockdep_is_held(&wi_state_lock));
-		if (!old_wi_state)
-			goto update_wi_state;
-		if (input == old_wi_state->mode_auto) {
-			mutex_unlock(&wi_state_lock);
-			return count;
-		}
+	old_wi_state = rcu_dereference_protected(wi_state,
+				lockdep_is_held(&wi_state_lock));
 
-		memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
-					       nr_node_ids * sizeof(u8));
+	if (old_wi_state && input == old_wi_state->mode_auto) {
+		mutex_unlock(&wi_state_lock);
+		kfree(new_wi_state);
+		return count;
+	}
+
+	if (!input) {
+		if (old_wi_state)
+			memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
+						       nr_node_ids * sizeof(u8));
 		goto update_wi_state;
 	}
 
-- 
2.51.1


