Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B545C79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 17:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471EB6B008A; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D2CD6B0095; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A706B0096; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0083A6B008A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:50:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C4491A0581
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:50:20 +0000 (UTC)
X-FDA: 85184076600.17.CE67948
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E94E3A0005
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:50:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJ96qSEo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788717018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNGt4/PEZwlVc60TDCfZwWiqfyGc6ca9ha5f0oSv3gM=;
	b=RXb4joCl4EaLFp3JvwN+6N6k5obytBNq+lknZsid79hEdb2NbGEQhIqKErUVYyWQFiaiix
	kZldNYxjgTtjajin55XQjxUlerjhnbRlMC6q9LNNzrncU6sSWIy0FXK6+Skq3T5CB0Wgqy
	IsSsUIdlcz/RNh+S/zclDoOWqvxwwtk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJ96qSEo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788717018;
	b=EWPezk4AAg0eUzGv4Mu4lM/GwfNMbRbU9uL1axZFgKYBODfGYEC0P9MJZ1E0EwziHpMGgM
	xB868p8N47mTrus5v2klZX0NDQl0zMEnoTNISd7RsGuN8U+HQYs6jWFmqhryXILG6yyDcK
	xPtNEa9H39YOYZ8CTf9z918/5zYiuvM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C13BC60A82;
	Sun,  6 Sep 2026 17:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ACE1F00A3E;
	Sun,  6 Sep 2026 17:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788717017;
	bh=qNGt4/PEZwlVc60TDCfZwWiqfyGc6ca9ha5f0oSv3gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJ96qSEovdFr+rPvWVoLD3gOw7boUWDPcXDJp5N7f3YjYMX/3x9mFUwmQezC+5Hn8
	 MyHTwXfD0skNUuTjRVFe6ReeFHjwBpfOVEfNCbOoffrBd+3PZ7dApYOJ820q0ys7zy
	 EW1j+1r5LjEritcxlX3R5q1K8C4sHMReAo0eoitQtYX/qrwcMXrNwOIQg0kBot1JHV
	 irE8rBU6q/ESlVzLgWOdLDiaq9yLOjF4ajGxcKOCeef4o+L1/VlvX7w84PS727m1lk
	 /zSilNhJ5C7oYUlK8xmjauFGzmDw2UGcNgtxh12SE23KbLpnw3pZRamTUe02qyjPV3
	 ZqqLQVWTRpxGA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/5] mm/damon/paddr: support DAMON_FILTER_TYPE_PGIDLE_SET
Date: Sun,  6 Sep 2026 10:50:04 -0700
Message-ID: <20260906175009.93471-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906175009.93471-1-sj@kernel.org>
References: <20260906175009.93471-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tdqfyrg53w8mppanmcihkto76hb11qj8
X-Rspamd-Queue-Id: E94E3A0005
X-HE-Tag: 1788717018-620137
X-HE-Meta: U2FsdGVkX1+nEO8eO7Alj+a0pK2sg79g0OrOrrsJ3+qLi8+HsVVD1RSub664XoAmlLMpAPa0dD9qHhWqDcedcFuanE2BP3rQ9kLx4ZxB3+2YW270W8231J3EU3piuoGto0w4P1Ks2pHB7qP21NgPxLCt9MfuuEEYO1fnIeDf3EyvsxfgFT2ReqIhuXYk5It5b1PS5BeSRfIFNhFU0kFgYmy2MrCKfo1MvLJvxOOkdtIfbekxTfjKEMR91r/zGdKI8myiW2X6D3WH7OeP7FsOh++FEggPbfoSkOFq291444VsLqAoRI2LhrnuVjsKrn6wf/8ywAhZbLpVECsOP7isNQaBAazgUmY1DEKIgNw3V0ing2mRi/K6MGjKGzU5NuC7/tYzSQAt73JnIV7a/ribgPd7uGydiOX+Sxgn4wfP7bAbjsDD6VkubcgU0767jYozO1pP13zFViyD7nO0v10D2Nshb+Kku5H8mlj9dpBdzqukNO25bmagBIqhZ7BUuwIdA1XkBxvCaLHwQB/CPeeRRIBpsCXwJ2b1tCp0hMl6heVOI4vFoSg4/CfX4t22tC4OoitTGfLIR7Q7nmiuM8BpZhl3/Rrjh2WgN8R81Ts16Le7UtOJ82Z+RhgKWlE369JotLxIGZEXQi9P74eq9C5LLk+meekACA2jcrGgxTSsGVIB1cTbev6ZuqQ6LyNxPNJJ05Sjcr1LKD0o05fSiT1GLLlL7Og/2BhmTnHZOzR23WTTPjucBzasMnvbOyMh1a+JLx/VcuI/yV9rRi6mddO2DMKkUo8EK7hLJmSVk4pDYFTROx8G8HQryS9RNIRvHWlYhSczKzsrWF38jBEh+Ah3RDK1HtWEZw/9Ww25Loc37tT1pQYcCtPV/AvNBgeBgFSvHsemBwG/IkounEz1Efk0M/bIUxHN1QVVrzWi30DXy5XSAh0aDpKCD/WvuFM/2vqj07ElgqYoiT8Z7v14KtR
 cBh8ogP+
 UgX6DvK8/9sW0N1JfLKKQTWRn2OQMIejayUFWmtwkZjRPp0D8JNRDXKbdBs13L0iqUWWzdRuzd1Igoouo0DtDmNZuviT75EbTPm4KJdEIOzYXkA0qQxyyxQxfc0FpAfHeeANfYBPDokYDUrtY0f1bi2ndkcinkxRXPvi+57PIXET7FXy/zppqBB3pyd0fLvT/JjZDrgCRNW8+/P5d8elVo9EHLGmmefAwj8/sRqoKwleouLyjD0KVZwXWIzmcGNCLARtYIUUFFjGx4I/2to7aTbmsGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement DAMON_FILTER_TYPE_PGIDLE_SET support on the physical address
space DAMON operation set (paddr).

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index d7c81829445ba..79195026b903a 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -151,6 +151,12 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		else
 			matched = damon_folio_young(folio);
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_SET:
+		if (!folio)
+			matched = false;
+		else
+			matched = damon_folio_young(folio) == false;
+		break;
 	default:
 		return damon_ops_filter_match(filter, folio);
 	}
-- 
2.47.3

