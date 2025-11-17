Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CD7DCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 22:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DB78E0016; Mon, 17 Nov 2025 17:47:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1EB18E0002; Mon, 17 Nov 2025 17:47:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B938E0016; Mon, 17 Nov 2025 17:47:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C586F8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:47:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FE23885C9
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:47:24 +0000 (UTC)
X-FDA: 84121586808.13.6F9B0BC
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8936310000C
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:47:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UdFlumcp;
	spf=pass (imf14.hostedemail.com: domain of 3-aUbaQsKCAQegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3-aUbaQsKCAQegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763419642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FFDZWRBWGeSJJ18PHJTmScz5mdF08U3XJWNOIdU9ii8=;
	b=Ncpmroc9d2MN9Lv9ZxLywMn5Z3VnM4YW/j3JPKLq/9hXp/trrxXcbB8K8DBy3hBJhxPoRp
	Viou/k/G17a2Qau9mzhBKJcDj9uKLs/32St2yEmteGfnQnPx+hyL3rhGqKS2EDYWng4vPk
	W9iYQdUmHZjOhSA6BB2hUQProi/q/Ng=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763419642; a=rsa-sha256;
	cv=none;
	b=RJ0Ae8E5ZBRe1rXqf637YuQ6WJZJW3ECNi1vfDQV8V4xXrZ+tJYr/Le/STl5d9OmCor5qH
	WElUJk/2J8rp616kHCJEjqOevGzFVwRcyUh2F6/JlRrQ6l+eqPlj26U/Q30dDUf8lOx3Mk
	xP+rV2McDZmN47OQz1M+Zn27mcIl9zU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UdFlumcp;
	spf=pass (imf14.hostedemail.com: domain of 3-aUbaQsKCAQegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3-aUbaQsKCAQegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2982b47ce35so55698775ad.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763419641; x=1764024441; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FFDZWRBWGeSJJ18PHJTmScz5mdF08U3XJWNOIdU9ii8=;
        b=UdFlumcptKtY2D9eFXKE0eIhxCwp9mbHxNqGecsOrKpzy+IKrH2zT757qHVkdU1Fjh
         VScTtfQsrJRPrsYAkzoI3G4hC3lmuLxL4YgD2+C0CWfQW1Mu8NZwOG6rAvO2lVQztf0r
         BMwjKXUkYovtfOeLudpjSskUE3um25nLXCVpsnm8b48Fqm1a8165vZIXCKmnx2L8GgXr
         5LiUG3QAcCdf5eE/oaMrmtHkxQUuAJTZxijioJW0QOgNvAqM3SwS3BB0SlO+1Ff5Zp3x
         EDRRAmasWz9qAh/I8+xqIX/NWCHM6u7vWXsIurHc2Gns1waCjY1HEmq+pDeaO/xmnbj/
         RdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763419641; x=1764024441;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FFDZWRBWGeSJJ18PHJTmScz5mdF08U3XJWNOIdU9ii8=;
        b=qktRYC2qFuYAmgNwJmtJWIvZjB672sYFXVikw15lJUNA72/qxFe1AWdSW4UDx6JZyY
         ZdmQaPRq9jq7agNOxlXy46W+GHYFjPJeZhBl0aIqPh3CkwphtAe4lC95kk+4VmD7SDuf
         OTCmxsXIIGdq3J1ibK67wDN5nMk4sk7v/yFvT9ROTwuwq+GlJSk+nwdFb3zzqJVRK4Hs
         3VL4jgZY/sm9c5hU8cD7bJCgY4a9bypERjEsiF4ViCv2xX/mxBX3WLX5hsfhsZ4PMsMS
         ai+gZvuGiLbJdAD5Tq0wOwuNba9xTjyV6SEc45uSMIMQ5uL7XHy4VnvFn47rdYWV49tz
         loFg==
X-Forwarded-Encrypted: i=1; AJvYcCXMn8wfcPedLq2QeoQqqZt7fPGVDSLRw3rZtcOIV3tA+ybv5XpbU5v9zLgN0ISTDrPcJOEAoqBQBA==@kvack.org
X-Gm-Message-State: AOJu0YwRzRgJxwGNjkNO2X73OO8eQyq7xKvc0KZQzAIZ4SXdIwpDHg8s
	vOmya3i7eQd1IZYqSxquUBZOD0FCry6bPCrg5uRfnA6EntpTbl8ll51My5dArouNvqsYCEDfKM+
	TnypA4S4PmtVfp05HcvYYRf4wRg==
X-Google-Smtp-Source: AGHT+IFUtNOkJGI+3slVxFGeNNElaZyayySLSHWAkJnaSwQ34c9nCY94UPN7a599kL2+pa7XbABtWWuQu1NQqX5/mw==
X-Received: from plok14.prod.google.com ([2002:a17:903:3bce:b0:297:ecd0:777a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f78c:b0:295:ceaf:8d76 with SMTP id d9443c01a7336-2986a75010cmr143554585ad.47.1763419641381;
 Mon, 17 Nov 2025 14:47:21 -0800 (PST)
Date: Mon, 17 Nov 2025 14:47:01 -0800
In-Reply-To: <20251117224701.1279139-1-ackerleytng@google.com>
Mime-Version: 1.0
References: <20251117224701.1279139-1-ackerleytng@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117224701.1279139-5-ackerleytng@google.com>
Subject: [RFC PATCH 4/4] XArray: test: Increase split order test range in check_split()
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: pb4fr9mxnknqhjz6wf5zdb45wico1xde
X-Rspam-User: 
X-Rspamd-Queue-Id: 8936310000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1763419642-947418
X-HE-Meta: U2FsdGVkX19bhBjMK0w3zszlgiAC5UJcR0LQ05Z7gHm7xmhbXeR5FLaEJprpMcyOQy1Zu8xvzDWvwprTNtc38ssx/TUg0fbGKGVUgFitE/ffUEF2Tl/H8j3HtJNMnffFn6eF7QFZGoGSc+/VVkwXsXD83YpQXVzAHs2NGCjNzvAkr1VqpFnNrsqlX44TWFXxitMnos+hDRcjLfM5RO+UzGnnorhKom2QZYypshs2nI8rgaTc3DCJaNxYXitDHkP8bRmx1xTmGa7wgSzF+wISAgyrLr382b0rSu1vIqM130z1MYL0Wtnm1QIc6Wn/5Dg1UuWNEXDmGE88k8oALAppkS7MHDeO3BmAFKR0amyUGKpCgEp4U4r88nTvqU+QRI+3BKkphrF3yH+l4vtFUsPpgsmPrVQ1RxwO+o0U5R07qKSMs6PVwsORktLeCa7iThiWTWPwzwlq6EEuOb6tEda1lrf/Y2MbTuGYIfGRSZTY0rO8nQEb5ezTlE3TVFnXVNdoy63iNfz5rzRXOl5CdpDFJh7KhsEe4w1Urmxj3WzYoSbV245HXkR7YnXMIQcKDjtL82rXnPFGaalshKfcTGir/rWqnqINHt7yxNa+cvL/mWJeM162VQiSiRznSM9xqC0AnsM1Jmoykbn+IM0D35fO8g1QtnYBuOW7qVi2xrvBuaP69TUevosmeC0qQNuf6bCqoeLhQHw9fOaHjuD0evuHqQIGtdoDF8woESlk6OFdNSGtzOfAMFEDlnBtT+GuTgK23nPbrdEBw5rj1ZfDL3fOGEld9zjv4uUOmbnEwmKtU/mVyYQPGj76oNm1Bm3So1NB0J18+A4ZYdWBXY64c116qncSb9bir6MwwlFpBQi1GArpf0Ha4LQr8jLubvT9BxD4M4xjswJFISWOze00AOxDHsYKKVFls6uFK4cKtCHn1/JucYXZAlZfjBqcybuc0ipm450a0E8Tuduij7+4oni
 tJpjCdCf
 fb+0+4e0PsAPpOb10C+riWRJa6AdudreVoooW8Ha/XNSPJYthHMHsDXYbZf3ONBbdUBe3D0xkJgEZ3N3uiR8zLwyjYkuD69gblGpv1Cm0c+4EEHvQBadICxkIAF73T1P1UWoUAQ3Yzay6SbHrItTYZmrs8jtoCA/lpK3hgE6HZsK5g4MzHadtJ0ynmXv/3R51LEg5rjIyE+ZDqurAG532sHI1i1Idf73rNneZ3ZgHtzWI0aJtcUmhz95uwJDmmLFnqDybPpD1cEYN8k9WjFN96KvBJZvclY3DQvcLbiRT4/hlcdi51PDCSr5JW93vLIBRLhGTv234YBs1uKpwI0hJACaSuJ87GKbttNHQ6jLRgOwu8Igw3hG+Bv7q+1T/ZZHnLbVO/RukTMr6x/sNzu83q1gZDgVBWvC2/i/5qjwuiFSANNqCeCT3jTFRETKfGb4pA1mgxpng5Z1nPG3xqwmzhDN53eVCw8Ob+0bLSd4ghoSs6kPtfz53krozSxT5QGSLNs2P0qyc98HlZcLauoo1zYogXl8q8tlnYaxed5Uwp7qAiqk4iY//9wod9dKoA3/D0jQjrisP4ZjOhxWrUymGzggzUcX2k3SUVQFg4MXD1R+RiTGdGW7ovNIqCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expand the range of order values for check_split_1() from 2 *
XA_CHUNK_SHIFT to 4 * XA_CHUNK_SHIFT to test splitting beyond 2 levels.

Separate the loops for check_split_1() and check_split_2() calls, since
xas_try_split() does not yet support splitting beyond 2 levels.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 lib/test_xarray.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 42626fb4dc0e..fbdf647e4ef8 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1905,12 +1905,16 @@ static noinline void check_split(struct xarray *xa)

 	XA_BUG_ON(xa, !xa_empty(xa));

-	for (order = 1; order < 2 * XA_CHUNK_SHIFT; order++) {
+	for (order = 1; order < 4 * XA_CHUNK_SHIFT; order++) {
 		for (new_order = 0; new_order < order; new_order++) {
 			check_split_1(xa, 0, order, new_order);
 			check_split_1(xa, 1UL << order, order, new_order);
 			check_split_1(xa, 3UL << order, order, new_order);
+		}
+	}

+	for (order = 1; order < 2 * XA_CHUNK_SHIFT; order++) {
+		for (new_order = 0; new_order < order; new_order++) {
 			check_split_2(xa, 0, order, new_order);
 			check_split_2(xa, 1UL << order, order, new_order);
 			check_split_2(xa, 3UL << order, order, new_order);
--
2.52.0.rc1.455.g30608eb744-goog

