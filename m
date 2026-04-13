Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBB3F34C64
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13FD36B0095; Mon, 13 Apr 2026 11:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0EA6B0096; Mon, 13 Apr 2026 11:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005A16B0098; Mon, 13 Apr 2026 11:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCCBA6B0095
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:45:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5648714022F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:45:27 +0000 (UTC)
X-FDA: 84653957094.16.11C78D8
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6B53140016
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:45:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SLa+M9W+;
	spf=pass (imf17.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SLa+M9W+;
	spf=pass (imf17.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776095125; a=rsa-sha256;
	cv=none;
	b=r+x1TGaybvSO3wZurQd36XiFW08RWmd2cqD4piq439K7Fo1iKnbLXxK7Z+3xdioLuj8mCi
	BYpFY7I4sszawmu5XXLAIWrLpMbyL5oLoNIiSQ1X2fDJUDxP/NL2mFLgnjYg/RoTeeyLFV
	yIDhXUQTL+GlGNo0U+EvYwPyMj62iQk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776095125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6VpmZmaQi1QTGLCR3k0Qw5t74HoBhBVX2K8xvTv5hbQ=;
	b=o3A1iK6ebvmBv9YK4AFs4CBOils8+tlUcXdixvXlwomgF1FO5jrcAgmUpqms2S8DpbNmgp
	SKduCG40qQqaTVArpHdo6JEBHqbGa1SmpwwoARTq9aVI+5PdbBlKPKVKh40QAJ+Hljp/pA
	0hIEBT7gktYMzs6r17JzET1cG6wg2No=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3567e2b4159so2874007a91.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776095124; x=1776699924; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VpmZmaQi1QTGLCR3k0Qw5t74HoBhBVX2K8xvTv5hbQ=;
        b=SLa+M9W+cE7Y4GXKAdyPnyx9XTsXLsR1ttAYMsFYlIt7heZUxl4WL92ftUhk0wJgXp
         xUTdKDwKW2dXSnOGFwPgyW87ASbU++BCIeNeWLFvOp2Jy9jjeQNtTpjoMYE8hD9WCW1L
         OIkFsmtXdYEqZNQlj1JeF6qxoZDaA9viG0b3O34XBfX4SyfnNNYugvEQrOapWEMQ3ixq
         vOW3ANxrNXqVo0chdZ/djSjbrttIUFxWkdXQ1p9CvK49kLOddlBI0+glyX2uAdePb7S2
         gVCJiUjbeP0kRE1tsOGQKTEKpAP/2wZuRmNIAjlIdH0KA4uG0NJKPN2l09FY/7KM6ATm
         Rt/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776095124; x=1776699924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6VpmZmaQi1QTGLCR3k0Qw5t74HoBhBVX2K8xvTv5hbQ=;
        b=PhJIyo4qu1725Y0Vo8NtxZIfHPzUHzPaFKZwII6JEwcziygF8Zcrd1OStuM5g69KVj
         rwEVe1gF0WP1a1AFMaNIxqWtQrMqtBn6c5Z4zzXu5En4+cFdK1S+6J/lB5cJRxY7P8RL
         0BhMD0SQusz281fvqpZ4J546Hlg9WkMK+rI91AuaI0k6aAOIK94LA4xPh44SHMrE+S9I
         HT8lZ678iWFPTFnRUwPe3AxlOigPN9EEKt6lQecehQVujqcj+yLjN5FSDCdgYrp2MKd0
         Lqy1EElKSTeeLtADI+Qmx3dUeuxHPNnTuvrdtgG3IZL74UxcO4W31S0eS31ruPrq8Ze8
         bIXg==
X-Gm-Message-State: AOJu0Ywe2vuVKMxw2rjY0OydNHTeYk1CvkWKroEopDaqsu121AB/I+bL
	qYCE4/lBjEZI+E2PzbsHdejFqmZMzWxWh7OFHYO3562dIaLe7nqpBTIun7vX+d1T
X-Gm-Gg: AeBDievrfbviuEHl6lGKYdCaHIa3QnnP2ZycrDJQsCOWUJOA79TFy/cFCNP4Wkz8Yh8
	/GSK1B3KSl7+6PoQe7IObUaZ8Qpu75cOtT++mmnzHw2RqnUQ2z3B8bmVbTO6edTG6JSF2wgGSrd
	h3vcwHq7DPQDaARro8GqwlS2sKMjlZPkp5cbD8B0ydrmXH7u/u8D8nfEhb4ub1hXNMPnuiGu43b
	Pw1i8vkEnYYEHc3I+RHb1A7hOGLCkARPCJMQTU2DXtHJqE0fn30g2xFTfvrN9IqxndEzO9zCIHB
	NB/Nwy5a/rfKYbajej5h2iJw4VMXP17MZ6GmjJ9M12rVzBxzA3gQOTtZ7nHG/f0eXgJBxv8+/1m
	5UpdutJhvZVY8L9xPO9DA9jk0sCsgX5fM+dSjtHjQvxHxvTambVhshRK1MNtHboIfjgcw7cUbRx
	+loHe2jR3Yl3BUR0Iuz8ubxv9qfLBZ
X-Received: by 2002:a17:90b:4c0d:b0:35d:93ff:2854 with SMTP id 98e67ed59e1d1-35e4276140fmr15197610a91.8.1776095124267;
        Mon, 13 Apr 2026 08:45:24 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e41355470sm12786052a91.17.2026.04.13.08.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 08:45:23 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	djbw@kernel.org,
	mingo@kernel.org
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [RFC PATCH 2/2] mm/fake-numa: fix outdated return value comment
Date: Tue, 14 Apr 2026 00:44:38 +0900
Message-ID: <20260413154438.396031-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413154438.396031-1-ekffu200098@gmail.com>
References: <20260413154438.396031-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B53140016
X-Stat-Signature: ih489qgfx6gqnniam989uanjd37h7c3u
X-Rspam-User: 
X-HE-Tag: 1776095125-700865
X-HE-Meta: U2FsdGVkX182vYW2TR5qk1lheBNuV+USfwijuy4JUNnGccEjh03IeD74x+oPI2c4e8xr6wcCKWE+sqo3yi8pygRnhxcHZ7sEyT6jrqzKuA2llAhmSgJ0vnUdEE5ia6+qCoxDc7uY6u10adG+/UXJl5ll5g6+OHMrIXS5jrR9xaVZV0JLsBEeNRKDvOblvmuLmul199v5RPe7XT3VrV/pxE1AspfITE18ALRdF+yTVpgkEHZrbKhPZ1U4Rpyw5D7iS5Iquieb3Iu/oT4pm1o41OXUyEW//A/1TivEgZbdlIRyv5fC9VLvr5PlXHGUYIUEUyl6a69GV9ao/Wjvx7ICvrAL+7N3S0XEknnFdW6BdrvmJzpr+GtzN0asnj7p+4pmJpLSnqQfeqVLEFCBTZ4qSEgqD1sKZXsUCtRaeUCaW/x27Qn4eAKxLS7uuIqDdIT7Sw9jyVuy47CZlm70b5hf6DD86DjLasdTe+SFaWZVWhf5Q2UD0yC1Z2OXZNgsnL+5CEQCf63pDJqhjQtnJlCo2XSJXIg6278H3RXyrXOHj7ZPJncyWSMzp7X7A54TsltJurdL/8bYOvH3B28VeQqdDcoHQIKqsA6W/nZCL2ZZwRFlAq0ea8ZFoKZVWS8Z3pn7NU1oyhMnIDdRockfR5osK5Z4EDw4EgUV7+W/ExfSusEj4Zq85APmUwU2u1o9u9NDzHJSD6WaSF2g5KhXyphjT7dLZttYXi7tCkSekLx1fouJVeLFzH4RCuNHka+8yorYWQ35+i4HSGz0dDvpsNoEzVzhNaEKuFecrwG79YjhbPeoIAlUVTdlEARreZcr5mkSr+Pa7A3VrC/SCWDKiG0bBFbm45yI+hBrvycbkzHx0dry3MsnhiekOPvaxXuEgD+9qxcTW1JdjomPS3jnpq09e8CS1LUOmyCsNu7+25OHwCr31383TX0r6hnN4IpxCxN+RAD2UV5jNCd7w6sZ3f+
 CRIqhx0c
 jnH6bQvtm4nrP27XDnlBvXltk9gZxvtIjmmRHilpQnQ8QtdiUHXyyAa2aF/+RNLJDmqJcYp2R7Px0wI45ZSPoJs3TOP6ly3SvSieAbX6BeExwd5w9IutXo6Z6vrDtG4l8/TJQEWHUH29GtR7qRbdZ+PvrluxG0BDP+nRay6tpAgBdqoORlYJ5Y9/bJXRGqwHDRDN9Wr8YuUfF6t1NyHQWxFLHer+YxxYXmaB9wOaWRghqWxl6sdKBx23qNhN4xRzghyfH5q3O5JHSTNxAAcTBQ9VaV7uWzuCOGiI+YfPdo+La+KDRtLPykrWwzZKX/mVqRJgh0NDZk/Qnhv0/EVABTIvNJ4FxzoFxxwH8b5ahYR//ip5z9gEYrzOrtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

split_nodes_size_interleave_uniform() returns absolute node ID when
succeed, not zero.

Fix the outdated comment to match the actual return value.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/numa_emulation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index e7f856c8f2a1..c1d0a76aef64 100644
--- a/mm/numa_emulation.c
+++ b/mm/numa_emulation.c
@@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64 hole, int nr_nodes)
  * Sets up fake nodes of `size' interleaved over physical nodes ranging from
  * `addr' to `max_addr'.
  *
- * Returns zero on success or negative on error.
+ * Returns absolute node ID on success or negative on error.
  */
 static int __init split_nodes_size_interleave_uniform(struct numa_meminfo *ei,
 					      struct numa_meminfo *pi,
-- 
2.43.0


