Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9448D606A338
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UJNttNzB
Received: by kanga.kvack.org (Postfix)
	id B32826B05C8; Mon,  9 Nov 2026 00:56:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3246B05C9; Mon,  9 Nov 2026 00:56:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D35E6B05CA; Mon,  9 Nov 2026 00:56:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DD916B05C8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:56:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDF39C05A3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:36 +0000 (UTC)
X-FDA: 85414521192.10.8CFD3D1
Received: from mta1.migadu.com (out-204.mta1.migadu.com [95.215.58.204])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0744B40003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UJNttNzB;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.204 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Ad8L18vWEsLzi69aph4uH3QAUHZEIhwmqVh/GCy+bM=;
	b=cb2HsaKOiznBVqj0CByC0jA8l1scY1mcTVwGdSzLoGtCYawsXIaiciUjtPuvZH6UDFlEU4
	oh6gBAVZIqfynbXyLxjABG9LPXMjfOz41eYP+y0NrAkqhYCdKRwkFr+11RtH6WTawv2Dea
	87/OGpU6JG9EqFPK7AzXH9HA7C3T5QQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203795;
	b=jcrQZvyk2Xv5T84cVPZTatP/RivrFEFKFK9WYnEyRrPJCXvPK0Q7t9XhHXog1LwT9sxObz
	5uHyM/y385SRv91riWhsrYyAZoFGb1rPg6qInVc7kjNih8ik8U20RRqfRgj8JQzZzu8OfN
	TuGbT0A4abtEZOsyNHQN+F5tC0ANVAM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UJNttNzB;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.204 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YluyIRWOfpynnfHtIz5HbTs01U9U2R3DpTwEgzyIP2Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203793; v=1; x=1794808593;
 b=UJNttNzBMya9WCTZIdczS6jnUamZ5nEont5ISbrHHZ0FaFbQ5EQn6BNg+iyGJU/m/1eY9CN6
 3A0ZVrtVpFrUPF6gofZTYMF7WKmwrZxh7N1hSYgrHrVky1EkOvZWu9RslXzTAYas8mezBUZmBNL
 iZuPM+eVMF0COYyFgnh54N1U=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id ebe2b124efa8aa48;
	Mon, 09 Nov 2026 05:56:33 +0000
X-Mizu-Trace-ID: ebe2b124efa8aa48
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	chengming.zhou@linux.dev,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v5 08/19] mm, swap: require zswap for xswap devices
Date: Mon,  9 Nov 2026 13:54:44 +0800
Message-ID: <20261109055455.536925-9-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 63w14o9e8bcxxzkshiuy64fo7anw5ptg
X-Rspamd-Queue-Id: 0744B40003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794203794-169444
X-HE-Meta: U2FsdGVkX18FEoh7msTXuTzZHpgKxNkrE54m4UGTKxY60JIi4m6ibckXRWGBXlfrgN8uuhFR0bUFFFFSWND2xIcYvAnSQ8ZcyT935ahhJmLMlPbfVAryS1gnA8//4Ir0RL9fgxQMJO//wxIvoN1xhTz0R+s0JpX9MVRdJoPYKb+rKOhpbIESI2milhOy0PFFcGIHXKPSq4h9J8EmhNg+mZPI60J+HlGlYBDXEv6GmlvZbJIZNrcmN2KzHexsQD5DW7Drkycd5fiESLaya7kLz39unxFKjj199ZWVO0J92ZIuP/dPYPS0gM7oZpHJKOLPnl8noL/MgLWJVR5vkKrLnRSPVWOReCuTqbeYddjD+TE829zNYPv5mEOFWe1LZa4Hh4AEWKHb9cktQ54Yi+Ni70nEXyw7qy1HWXuAh7sg05HWZKruvtR+fLhqop1OufSQtOS/I7dgxB+j73XGNamFbaye3FroZG6/xqlgbg+c8fs1DIdB26dkEXp7RyEGFHwigvvYM08SUOd406Zarp3hqIjdkOU1C+j5KyVCd4RgyERuLYkEDCilJxHELGyDm8ET7nmTy1ET3PyOdml2AuWovN07OHlnGxD2IpD9GUr3kz5TWPMO/rmsz85KxS7nW/cwZz3dOvSAPrIlBI0XAZdqMBnMWOLv3zzPc2MlEzUFKw6ojvV2vQ4poAOu0edokmKse1sPQUAA9dMI9oY6aPkI7tMFtJT7bh8IcKf+nGpKRf4/V+cw0uoMbW9ksUtTOU0NAetpI+G/31Jts/VGsFbBXbFT9/IjD82HcCzq8+/m6WWnbMJW4CWSs71M2113CM8bUUvvePe2Lgw+j296IpqFcJ4uVAAJAR3Q9cgeUMsa+dHz62mmx8qP8vnWK8DroTa7N2Sf9wctdjAthbLo8SKcYVpIIn4PEPvfFJtyOrvLDkR4ZwoSMt1yF6wHfVMWD+3GaRSLJwnIB6KTFwOPaur
 yMOwDsti
 HqxeBPt6asLrohuK3W2kPCIp4mdrFS66CzKCZ9Q4lU62l9VNwiQWGu1g9WFPUQxrEmfYiBcicrH5ElWpxZeB7H/FcU4ZyyRkLK2OWE/ZeGD0jm8bkT7rRbgxSL0C1SA+HIuBplYyLChwhPBgjQNQh1lWFzSNnNOFtT5TGUgV9Pu3jDx7c/m+9SoqHyos6QgOy/fZrJgVoiBYmcNt131LKPMdHWgaaRbnmGcHfks6rt+TNBcHC9ik4eVaWu+Qz05xkna+1+5zZxEdhrCkNsQ+Ov614KOTv46lcPzCam1UF6KuBEAhnrgET5+6yMx2HjqhU3Xt2cxfepXZhhGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

xswap pages live only in zswap.  Without zswap, swapout cannot
free the page, but still takes a swap entry.  So the device consumes
swap entries without freeing memory.  Fail to create a device when
zswap is unavailable.

Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3f2b863f7dd7..35c8aac1e25d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -4268,6 +4268,10 @@ static int xswap_create(int prio)
 	    (prio < 0 || prio > SWAP_FLAG_PRIO_MASK))
 		return -EINVAL;
 
+	/* xswap has no backing store, it relies on zswap. */
+	if (!zswap_is_enabled())
+		return -EOPNOTSUPP;
+
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
-- 
2.54.0


