Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E64A5D116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 07:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3356B0023; Fri, 28 Nov 2025 02:02:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484196B0024; Fri, 28 Nov 2025 02:02:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399DB6B0026; Fri, 28 Nov 2025 02:02:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 280096B0023
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:02:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8F23160482
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:02:33 +0000 (UTC)
X-FDA: 84159122586.04.36F7640
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id DBCC1100002
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:02:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U2xRC072;
	spf=pass (imf05.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764313351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldaa1rRIaRl5EF/G8lLrfM3pFFPazgVKbcxuDFu05u4=;
	b=Fluo6ZZsptReLJjAoZVuBws+20SVn0ueQammw4I2cy3SpEke2B8PefloTuM4TrAUBdDBDQ
	bXyZIJp3QHo73343pfu4ePoDfnk932h/O9dX8M/nWsUllKFOLaCMpX6pWp7IhyGN4J1zrB
	9XeUBOwzT+qUZSS9j5uFxt0l/2K0HQk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764313351; a=rsa-sha256;
	cv=none;
	b=GRixqpPXDy1PncPH5g/moZqboVTwqNbbxvKDA0DLG4Lf5htqnhY5//jymO5lIuQA9DJ8W2
	rRS3PaYfqr1NrY99Qr4dwtYSNZwSKj08qh+c2T7J4Ys+X7lLUIm8GUETuTOLG3p0AdZhmv
	Fxv7TjIgIQSWv+ajLT49DbYx3hqAqqU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U2xRC072;
	spf=pass (imf05.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so1346259b3a.0
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764313351; x=1764918151; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ldaa1rRIaRl5EF/G8lLrfM3pFFPazgVKbcxuDFu05u4=;
        b=U2xRC072OhF93xw647Qpp7KDkZWBsBjInMzN7TMtg+7A/VjQgwLQ/D6bHVYUAmFooT
         pfjUuxw3VTBkSNG2/xRQMeXBZI8xBJgmEL6TOgLqSqJ9Ojgskdczi5dW62UUh2Ogj6T/
         j2NYHpK2e8UhMQoafqOIYI6o0U4v9H4UAjjYSbLUKgBvqJBHyGuqFsjCIgCNK13hUDpp
         tPZCYrNQ9ylQb/8fXswSQRItrjRYGpvxdptaJbxTjgcU8j2NFoNiIzRHlfkmVh40/cOM
         yL5kxcSbLi6tqMbs6T9FJ87JIMmewXrXvs2ZsYhs8SLaNkjHQxhbyfbl+M6ub27Mu6EL
         DO5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764313351; x=1764918151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ldaa1rRIaRl5EF/G8lLrfM3pFFPazgVKbcxuDFu05u4=;
        b=KP4MaH1WL+TZum9GUzYwnXhPgzatigApHAMcEA01Eh6r4IpbX3HwpKbticPc5B+RXW
         f0NxNTnwfJyl7hTfhBeCK5mN4LBtXknKG7yYJlCyPLIo+F6b9a/olQIcWBXMKOBNJELs
         IGUe9CW/sRrB0CIQtDDvOOLFjnjCkJ8T9OFwj8urWouXNmAwNRvE5h9MPKEQV4MAAFeh
         7kvmhCkip02Hx35TkI1SXjfwGTtBh2p0k5FM7ksAy611NgI5nXBqunrDB54HXRn1xRV4
         ghDJmHbjnITWgNZyRf7u/a6aasEN0fTVDPS1VqDu0LbMFW/8Pqo2h5rKK7wFwlLkp/gQ
         Wz9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVlG05uHsZ/euJdEVA2U9CesVVqk1DvXesNCcyPmEHhFZRiaqiUd/pXpl3+xqLH7nMm5qJpizVArQ==@kvack.org
X-Gm-Message-State: AOJu0Yx36TIjPgW6NoFr6clhqJu39CIVDeEIvJzEBJEgxZGDNDKYFTUs
	xOi3UT4D1y8Vn1PEL+xqkjd9iEQhF+FB8wCXF08TstbEud33akN+mhIyDbTqKQFh
X-Gm-Gg: ASbGncvLVg7SvZWjOWnTmbD0flhvWgbhBp3ckk63H1svBj2Zu3ubqLhB5GKf7vvKjwX
	GYbQ9/QaEQVhgKFHN/kNQyoF4pkxhjVvseFN+z1prAsWj60vSjeSU8KQ1lGo1TFoEkhbbmjyDaJ
	1SjMnNCIWHUhuvbnjLYT+z7ei7KRlpZqIDQvmRN+wfno9jDirimWFRkIB0hrZBxU07MdkbS5jeb
	sBRpaXdIpY3UPo7zYfjbTrQJsiCfc+e1etPQIe8wF9VzrjUUCw6S0N/uv8djYybwZL8DCcZ2J/c
	UXmzWenn02xEZ0/6leZ9pC377awUWbHmqVxXYDyWt02er0I8nmRTK3kszt8Wg/7i+oTz0vXwr1O
	XmSTUhaVPor99F1AhqBPTqAHJEuOCR1xiTootT06zLqU00+6Mk9kOF02Tsvvniy+HNWfEYeKz0o
	iVjINPth7IshfQ/DzAqR8ug1QXdg==
X-Google-Smtp-Source: AGHT+IFLY8FCMa9pQ64sU325U+C9KpdSRPiJnD1VDD+lEnxd9QofPQxxuqz3/1FcjQt20TAPXbjXGQ==
X-Received: by 2002:a05:6a00:2ea0:b0:7aa:8397:7754 with SMTP id d2e1a72fcca58-7ca88e8eea9mr14312467b3a.2.1764313350601;
        Thu, 27 Nov 2025 23:02:30 -0800 (PST)
Received: from chandna.localdomain ([106.222.232.43])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d1516f6970sm3864693b3a.17.2025.11.27.23.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 23:02:30 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: david@kernel.org,
	Sahil Chandna <chandna.sahil@gmail.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v4 2/3] mm/vmscan: use %pe to print error pointers
Date: Fri, 28 Nov 2025 12:31:43 +0530
Message-ID: <2c842a64fddeb0fe0cac087783aaedd97edc3191.1764312627.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1764312627.git.chandna.sahil@gmail.com>
References: <cover.1764312627.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: DBCC1100002
X-Stat-Signature: a45yia4bhkhw385emhwrtw8gzm3ft6f1
X-HE-Tag: 1764313351-113273
X-HE-Meta: U2FsdGVkX19ngYfR637Vy1L4P1VlDIoBzeyazJ9Kny0eDoPK+70Xv/OgLnp0Gv97RtLvRi7x+3ENbBjslCkjkllb3IzZjW0dGh5Y0MqUDVLWzF1tz3P3nQ9BgaCc8Yclkg/Qc228PQPi3urjOAEv7BSGa7AzNPwbzMoNMCZ5oC90Tg1vb+xjOS9gwLJhVxE32ULWT+VWGlCaqvySJ7vDBStjU+fjasCL043vgzqJf20cScQm/PIohsYKnzTxE6vObgZLGdrq2nUTxOHrCljfhZypU3Z7wBp0HFF/WnsJmEigcxIcsX1tuk0CsS0UmJ4iTGc2l8xw4GQN1B0EU2xovq2ksgMU2CI/XhJ186PoAnO+HIIAWwBku6E2O5unNABpCsnnVYY0QCfGjePRO4/+dO6pw4cITZpFCw54IFsq8j9U8vU5qsVZdt22s1oQqLeWR2BR+dItVxzqnUCYX7sJ9uBE32PSv4f1rpLPH+jPsy1z+AasRNy2Yz07MkACPdGVQklEcecZTbx+3g74CS2LRvU7ktybxO11JKcCfRnEZ9lLEES8UJ4WDuBFvVFpfbXVtqe+2USuuTEqlWofOHgXLQMTVJzE67MCDC/MGeaHCmjo8YIuCbSUBC+uycutNcFRw9sX6rgziypK4XjlIABAXFNHqp8VLGty9/HhBt4LF+T1+4dFFmS6M9G1Favs8DaKwBYq4sZ30Vge0CnlAeI6gNyyzQPsP32xAiZNF/FZxvMgOXpvXpA18srCiMjtKxSPCtlTEZYiW4u5Jd32hMODJo2VSZMVceTQ4IsgJ/ZrN+hk7k+x29DM1utjtr1X1Y0qiSi0iQF6bsmqkoEqcHcORIfLWMtWxE+Abcwde7gci1tMD/KrsVDtIiDez10P8bVtwSHVyK31XYt6h8g8W2FOQ9V3sx0cGczgJJPr6r2deS0+moRxt3KS3DE+6cgvCbhqzcOIFppGMpmQe2sO5D/
 Xf+99nse
 MPSlyadgOHSeQ+AE1UsZqSPkl2LGVupJC0QPZsvuoOILLMb7ja/L1LI56ibKB3YYi6RbNcUP9XcTZiComhYyChrAQl6SaVnN4TkEABhYzDLVJZXT3ivON6QZzSRickKh8NZpxeLuHkzi+ZgOQQmk1qMedJdrU/ETsm/S86yfGX9Z5S7q2a+fyB3WU6PUmDSPpMIYX1JbcSsjkFKkIcxjAa4hEUjAMMBsI15+3NAtXcfuJg3snlJc9yFA/4FjDWauZvg/9saDyUYiXjF5XGKA6sR0lz4xA7KdUr0IVKedkH4h82WoPab4O0yBxWV/loGbtKetv+308UFsQEXG0F42Ahu1WJsbJI2AFsP9L8IghYSlERjXlhmD6TTX4nD+8qsI145LCHqdkFZv3R9KaP9UZXNo4w0A/dxdqiXJVOLfimCegcj52nz09x6ZHjhCawPOPb6ctQ0elaxTGtYxeVVLiagEmHDYCdTfvIQjRmb5lW5LFEL6WpFummdxxBm2jLkDv2Fbe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value. This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
changes since v2:
- Add Acked-by tag
link to v2: https://lore.kernel.org/all/64e15c6b2ce86d7824f54e9e001b6f5b44af48b8.1763796152.git.chandna.sahil@gmail.com/
link to v3: https://lore.kernel.org/all/db049e564cafcb0913bee930d6a577ea43044f5b.1764177933.git.chandna.sahil@gmail.com/
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..29ed0b304b5c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7500,8 +7500,8 @@ void __meminit kswapd_run(int nid)
 		pgdat->kswapd = kthread_create_on_node(kswapd, pgdat, nid, "kswapd%d", nid);
 		if (IS_ERR(pgdat->kswapd)) {
 			/* failure at boot is fatal */
-			pr_err("Failed to start kswapd on node %d,ret=%ld\n",
-				   nid, PTR_ERR(pgdat->kswapd));
+			pr_err("Failed to start kswapd on node %d, ret=%pe\n",
+				   nid, pgdat->kswapd);
 			BUG_ON(system_state < SYSTEM_RUNNING);
 			pgdat->kswapd = NULL;
 		} else {
-- 
2.50.1


