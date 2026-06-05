Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE409CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A71D6B008A; Fri,  5 Jun 2026 04:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F016B0093; Fri,  5 Jun 2026 04:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4946E6B0095; Fri,  5 Jun 2026 04:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36EB46B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:54:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D02E1A08FE
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:54:32 +0000 (UTC)
X-FDA: 84845247984.27.F3DC758
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf02.hostedemail.com (Postfix) with ESMTP id 12F2780011
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:54:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=InsmMTVp;
	spf=pass (imf02.hostedemail.com: domain of 3xY4iagYKCMQqvsno1qyyqvo.mywvsx47-wwu5kmu.y1q@flex--glider.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3xY4iagYKCMQqvsno1qyyqvo.mywvsx47-wwu5kmu.y1q@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780649671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Wf/gVfghm0Dfs+HMV0NVIYYMGf5DKzeIhlg+0ce2wiM=;
	b=zsgjdURUj4xEby1UebP+ua+LB1rKKYxrWeLT4pfcGUVBaKh0hg9SCXvLzuK/jKEv6DrB5C
	1m2NSggDyn5DYSeFMAcJFzZ7KXCKcgSS01HIZPavTHP/VjgH4QX5uGjbtZRze0DKdSx2FK
	3xt1Tn2eBvam/zn4lH9NRMxTWQscfkw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=InsmMTVp;
	spf=pass (imf02.hostedemail.com: domain of 3xY4iagYKCMQqvsno1qyyqvo.mywvsx47-wwu5kmu.y1q@flex--glider.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3xY4iagYKCMQqvsno1qyyqvo.mywvsx47-wwu5kmu.y1q@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780649671;
	b=vhwy5Z4PQoTrXalg2QBlbXepWP39eW35urryuMiEKLHcuXfrr81rqYcPzscybK/6u5DM8q
	xAyAKFN7+hY6vvRQKUpJzou0RXwWoGw60Dh+R7ggpibdM0CtgLzd+qP1v5fcQoQd7tDqOH
	5M5rgmJBsBozZdnXwgUrSUfpuBlSiNc=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-49048e21ea7so18117895e9.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 01:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780649669; x=1781254469; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wf/gVfghm0Dfs+HMV0NVIYYMGf5DKzeIhlg+0ce2wiM=;
        b=InsmMTVptEtD8/qNj8qQRfNC+AZS6pSanBJU3iNA7e7C8w7OngCKi8rkt4qApwqczK
         67pChRvzhPC8wSIZBsdZoIJeRz/iyRFKTCI7sma05nk3TwvDgTlmiJnQfS1N0DpQUbh4
         rGQGyd2Iq0bzJAGEZbUeu4XGFuUqoPk4ZraKkr9YTTVtLvZVEKbL+b5ngJKLOGeud/PA
         hYpW0kZHyRirJyKyf0Sb/AeRtcPv4yAJ7jsz2mt2vjxcJ5YtyiDWDhog4YawUeloqGmw
         8sDx0q6XBSzhgaENs47AMY4+niFljQKMp5C7gD5xFSn+F+4H/zWcglIHDEoRUCbI0UTI
         SO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780649669; x=1781254469;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wf/gVfghm0Dfs+HMV0NVIYYMGf5DKzeIhlg+0ce2wiM=;
        b=cv6dFwmfghSFILU5e9VQ5t1PBsTv0Y/gXR7Gm1QGfrvL1J8mVAhirFmrcFpIZ57liz
         pHB4JlUp25gA+3I2gVYngYrr21bZ2eM62Lgw2IZsP6p7Fmp/Y5+Yv74rjXDnuO9areFC
         O1o1BWMyGT0Rn41vy9xFopxvUKC33sVA3vQ0u48pOCtkJNX8od8iv0e/0Z3dClAotLIM
         +0dVTi1wcwdcXEFQXBwc2LD3bVA3+JtHVfOQiuoS6X3BNeUjtrznLbmv97d4F7PLygYR
         Or9EyvdudG5rHA+5i0FgbayU48hTwRNyOEWdnNIMhoC1z1OjZlMDif4H1vtTkD8aAmOm
         1ZxA==
X-Forwarded-Encrypted: i=1; AFNElJ8Dapqa5zdATMHxmHTzRZmhwU35rdhdV7ZHxW4lhT8XPva+iLle52VI9WwsBa2YhpnCArwCPWAJQQ==@kvack.org
X-Gm-Message-State: AOJu0YwfsWTu4lvsFQegqLugrGzOMJzv4nhE01vUh5MbZ79LAxaJEE3V
	q4A7D8/YKNb9oVtqC26jiw/lv/GJFvPMfQDnes72SCMWw0CvlypFYeXzjT3xRYEYT67Er4QQiOt
	m0v8L6g==
X-Received: from wmol19.prod.google.com ([2002:a05:600c:47d3:b0:490:ae3b:b7c9])
 (user=glider job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3e0a:b0:490:5000:917
 with SMTP id 5b1f17b1804b1-490c2cb94b8mr25364575e9.1.1780649669338; Fri, 05
 Jun 2026 01:54:29 -0700 (PDT)
Date: Fri,  5 Jun 2026 10:54:23 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <20260605085423.1962700-1-glider@google.com>
Subject: [PATCH v1] MAINTAINERS: add self as a kcov reviewer
From: Alexander Potapenko <glider@google.com>
To: glider@google.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, elver@google.com, 
	dvyukov@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 12F2780011
X-Stat-Signature: 6zbc5wmchba8jztuzqu3dsw54y7cknwc
X-Rspam-User: 
X-HE-Tag: 1780649670-58090
X-HE-Meta: U2FsdGVkX18qbml3VIryRNBlrh8gWm2DSbwJ3kGZsEXHRD++yJDac8PXt5xHxcqK0Me1YzU3TptL7I/144JK0yf6lYiOFCfg50yBJ/q0Zx+HiCVf1UpkaXW2NK4jwU9guBqV5hYaAreugZaXwj5ElvIhqZir/lVgcEpkLgPpt7FIPOldV1SSQXpOXk9ve2/BS8MWZqlDpXcsvVj3ZwgxhQIt7nsJeju8Pz1TBtF7dHDSSzEFWMsmf6Vus2XAX9bzxTrvFFg8/FOyNVP772R0m6mebWPGoEWan8MClGt8WCUY0hKTzRe2r7khWPvADj7objde34ffvaGaKt+XUWUEi7yqVEu4bmTgAC/ctAemSmAa285R1H/Vz90pDxtL8UEK8a+WTgn8qCjr9PmxBwbYQR2JiT9RiSSHYEvC+p02Z2h+JjhTae9iAPE0dAWFi36YJBNDK/a5PqGbGCSD5JeZXS4FBtoUGHBNuyRG1MkhttyCnUPrp26lPZRHunW5XWSIErP+T+G4sgjYi2xsSJEnvGDEjhXZq6MYpP74PPD9FevBFERwaYfnrCIPdnVZoEgqw213dvPtHUNjaQExqztN6aLkteh/Qqw5hQPcpJBX7l6PBDIEwqTgB7Fv2ad0CEwcbXHf2Jd93lwnTYYNZ7pQ1uqzGpg+H4SqouyqljxReYyt7UjemPi1a+XqoPjEQeR+AFXNW+EITfXccFP+jtH+V5oyd42wpMmFpMBysaaap0EUar+9ypzC+cqu6y8UswvQirgWbovwmxmYy3uVft+X5rCdGOhydO8uHnECzJEMK3JehRMYRYcvxIWVUTNJ/teLxHLxR5+GX6kqOTQBF+ZoFtJ/O+r/jwW9Z0DIqpbKjqtcy9HQK8GLnHQLmAx9fbdBlJsv5Z/PcXB2zSgr9dgPFJZytkiR6P0Dqm8r5YL1djs7N8EyPr8jpVntCl9ujcfeLx+p+WPOvIoZT/S25B8
 Oz269O9V
 kuBVROUzWupyl2RSagJQDUtBNXBnsuysqm9vi01XaN59Xs7GVqjENgMNPc0J3eEOuutZZwTg0oNyVB158zGGFwToGmE5fSS0vwDJCJ8/uP1Y6v86QixBDxMdZffxJ7j0Os3JlWb7mWmJJrNmJms8L8LVsiSimTlBfEq7V+8QLZYJPX94rCzTMOR/1bFKpizq4MKqK9dsTD7HABnN35fOoahg6r61TsJ07KTV5njVyMUE+rfIJFeyL0pZrny1AOhSL5S6h/dt/dUYYprQXIvgZjucuV31dZ1PoaiQcL+66rUvH//R5vxe0nV3nb7v/rNzwH9Tpl0icUo715z3h8JPpgL4VExw3LXkinJGqVIdyM4Tlz8zs8P/sWBIfWgJ7Fer+zNYvLK9gfcjZ6HSx8dUChmMBCQBBKz4iqNpcioG7x0gQbWpnfjOIzDgzJA8O3AmIlvVsM8Crc99LSCABXvEzgevVMZhyD8wpn8kf+m2YxESnX5nDTeH8Ke1oNxwUmKUEJEHQWaIbY5lpdT/pgN0AOAah4k8gvY1tATu2NFZcY6K4OddsJUB3vNm8CjxtLfJ8BM61jSuubugwFBBvZTsAqmjnO3/Uaakm3+S1DEakise/iGsHADaFK+Ec825gDc0sX3VDraKGdAdq8gc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Also move Dmitry Vyukov to the bottom of the list.

Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Alexander Potapenko <glider@google.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b2040011a386..2c293ba3d391 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13832,8 +13832,9 @@ F:	fs/proc/kcore.c
 F:	include/linux/kcore.h
 
 KCOV
-R:	Dmitry Vyukov <dvyukov@google.com>
 R:	Andrey Konovalov <andreyknvl@gmail.com>
+R:	Alexander Potapenko <glider@google.com>
+R:	Dmitry Vyukov <dvyukov@google.com>
 L:	kasan-dev@googlegroups.com
 S:	Maintained
 B:	https://bugzilla.kernel.org/buglist.cgi?component=Sanitizers&product=Memory%20Management
-- 
2.54.0.1032.g2f8565e1d1-goog


