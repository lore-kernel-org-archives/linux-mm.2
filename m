Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A228FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 08:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8595D6B008A; Tue, 14 Jul 2026 04:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830896B008C; Tue, 14 Jul 2026 04:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749276B0092; Tue, 14 Jul 2026 04:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 501A26B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:15:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7F08A02BD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:27 +0000 (UTC)
X-FDA: 84986672694.18.928C445
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2B69480004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lHwwWTqq;
	spf=pass (imf30.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784016926;
	b=y/ckirRvr0jt0N+WbI3jph2f2umhg3u96+37+YT/tW1BheSZ3ViLmxEAsfglg7yyP8/wBO
	/HrXwBTNkIhNFEdkLQ2lhctkQ0VxlnYLb1HKzND5sY0vPDUA9eyQH949sKjnB8A/UDYYuN
	Krkn53+SqGaeWlS8Y9CcK5NdM0zg22k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lHwwWTqq;
	spf=pass (imf30.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784016926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6v3T/GQPfCFX0/32VfRd7BGJzQx4Npq1DwXlYIYPAls=;
	b=ZJPP5Pb7m01PvDo9Nmoh9TUxASSpZ9NAcInbhoTh0lbNmKCtZNZwV+esD2F3eaH3EeK9Pw
	7SUawNQ0NZHmzOwxnNq/LoeygtgosVKibO3eCdnygTLejaixhxyCapfyGkb4UbLbdIqTWf
	vC3CRvzCc4fnjWSEWgaZgG1GbX5BBB4=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38175907a56so554150a91.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784016925; x=1784621725; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6v3T/GQPfCFX0/32VfRd7BGJzQx4Npq1DwXlYIYPAls=;
        b=lHwwWTqqHG+fiXTIl3mygjV4Oahx3ADqpGcrZKAIElOy9PzpRADjK2igMkEJ90djt3
         FNLZTRik60Y3MqIzrGmayKwrpCTREeiLHOKlC58DaHiU+qj8mAeuemi2DD4vTYKnV82h
         AybMHjG44eIvldVB9to4XOMh6CIcMDIIo/yxTFR+HyBtbMwIVB2CHDJQYR3F0FIW75oh
         /7Q3R0+N0ljKtC87KhrkDQYB1beaWOgieYYF3GXm/Tx4yS/1kOnlvNf3Sjos1CR89ynr
         pZUgtXBSulhKGbYFHPc1ANosnkJczYPPTluR1ovmJikRNKamTPMQ9RB4PcQDm92LJpOh
         Kvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784016925; x=1784621725;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6v3T/GQPfCFX0/32VfRd7BGJzQx4Npq1DwXlYIYPAls=;
        b=gW0AF0JDLoLQ0rQEUGIi7VrJJ7dR3hhcUzF4hgxWfybXJzddWd84V4u/TGcUbRzt6s
         Ptz3wHjmAfQNKPfwGpHFpsrDGqXpmsP8q9btND2sxItfDhxM/w307b8gNYWJKVA7LM04
         v68UwGXfD2B/XauSuRGYIwJgnOuYy6QIGzlLxpz8FuklXK72ARvM6eFRdINJUx9qwWRD
         QFBHDA5sUEwXzQusZyztd8wx4DOlEtN6vEH9g3IGvZ+nGZpO4vtSvcvDBFBRvKqHETDc
         VwSk0NkVcXECyUllBq5HhZRPwsnYCEk+ZmUb2SEljCkU/QQTB48z2wJ761zam+qOwdLk
         s9oA==
X-Gm-Message-State: AOJu0YwluV64lY8Kig9LTONKasm0+FHVZjO/whLzE7DLJhxMbLScML4D
	xGsmlo7RuLXAGtck8o/duAwueGGSJNHCRj1LbSZ8hXRyja+xpJoRuLj/
X-Gm-Gg: AfdE7cn0cEuTiniuJdJcjc/7LiBDsKHPWNJBG2O7KNG/Ub7NnyAD1dE2TcpudK9tuth
	mZ6c6NCw7HtYco57/PwzKc0aQ6T9Ho7hk9Z1rkbDTkfAaYMqRuf2KmrCLMxtG5AjWHN0s58UKMy
	lGC7bAjQ0s+TVCQNnGpBmC6F0Qg/shsyv/TQGFSlGcX0nRkRKW5sW+4ZPh/5MLHRiple4WXXUF1
	jwLT7REZqxBfSaZPv6CjA8ky3rvOPJa7RMQ+41nSRa4EUYjnV155IEXT25cvSRTSRxjB4DdrmVr
	PT/ItuCrQ3AD1hMzeEe6UaXUrOYaGyyZVFrp+JUd5Wz0JJykPiKYUgOO+CiOQVKCAGpo+ouxGBv
	18IrhaeMpJvqnLH9gpF4VQNnIA1ukSkX77CZgyfgXv7zv3rCyKHWgobP/Zn14gUF/4hjiX9zptb
	wNBW3Tmm3gL00Tkx+1wrClcHabAdbYtA71nZ57HG1E
X-Received: by 2002:a17:90b:3b87:b0:38e:120d:df07 with SMTP id 98e67ed59e1d1-38e120de08cmr3459964a91.11.1784016924878;
        Tue, 14 Jul 2026 01:15:24 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e17443f4fsm1091008a91.11.2026.07.14.01.15.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Jul 2026 01:15:24 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH 0/2] mm/zswap: Fixes and improves the zswap global shrinker
Date: Tue, 14 Jul 2026 16:15:08 +0800
Message-Id: <20260714081510.16895-1-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B69480004
X-Stat-Signature: ffnepyqe1j161ddkgmxyt97xdpxgwkob
X-HE-Tag: 1784016926-700725
X-HE-Meta: U2FsdGVkX1/vN6Nv5TOca/t0BHTamJyX4TBUSsM0Y0UFIR7B/1YO421rAP5s/2iAwEoyZCmm8aHHqsDlDQ3YAyQa2ExHt16Crqz5JGQO9fHRRc8g7n9ctDfIxzZX8WWcHGcAQDt3JYYr/O7MZRm8kl9WI1zeJQB6PWGFMpj97+90/rKr4tbBzFe+UxNLATo/kY2XimFwTclmWwORWSVaSq1zInB/FGoqmk+l4gA6l2rU68F2yvs6ucwEkW/g17apEdQ1SXijPHrOSz1SJaSRWK1RCbxpjXEiSGB7hpTlv5qodlJpH45WIHP90SngoqmL0NFe860eKBMLhl20kwB+f8Xixe960KZz/dP8VFKtMVr6riKJBN3oK2R0FgN9Xv7owxG8uSM2+6Rm2Ivr+xwl4clyhxNTdQmnyZJGccZ6RyTT44J6H8JOJr+Zvrt7x/G9ZSJC1wUEKy9QWC4cf79+GscL6yogbzFqRvTN+aHWwi61+aZLACs7/siViLZcTxrtHivPJzpEC2Bip/L2EWlVx1qSLDFcqoJ72mvKE5Tjwi2+DbV2pZI7LiO7N00CYormtJ503xoqpqvPePGNEfnBm46O3GZ/sU5nm3x0BVzwUdaxHcZ9nQYMnfJcanxowOoohdNJvPwhbbE7P101UHD2e/JBTHyAyvCQ7dNVdOOWH3B9vJER67ALZofLZMDzhuOHgbKd0Uv9FbuhnK2MeySRK590GmHtwKMPWUGuPss9aFbfyUXSXwb2oAEXQqTEQuK8bTg9Hj9EC0pmIvcQeKkwCK+WUDc8ZwAmD4b7qLY7YQpr7j8sPwC3tpK9l4r4GmworXfBDGYeeP9hGU4Tpy1Kea2IP/X06SbO5WxB3KbSQg+k49gN9yNVHYgIS3VGaLEcjNb/+g2v3fCqIAqrV4hBJb6Dm6cKw42M6kzWXMkuyXTaIg41bBLDT+KVe/NXl3XeSkFVuBnatrLUCUoMa6J
 7eXgguvh
 7HJhENDcwNwBPQbfkuUR5hqaZj7hQSo2JnGWqI1/0oJKxEzcx3hS3MXwYmvCZiy6QOo2xPZXJ1KyGH45ty6DdWme9w+hW7Z2hyEGMurrNch7nY6dvCX7z86xHW5Iff5h2C5+pdXclXEUsjYi2jT5Joj1KqMLa7fKFG+jrGsfl5/IKdBbSzYAxdXnXVK0zlrlFpZgBZSzQQL246h7t/oa7S66Mf6fykaqCeM76D2Sg3T6K7Ac6G4mZikQRLGfGwOE/HcrWwg5HZAs4LUFNWhuEugxc2zRez015qQvxrTSYMww7g2jJ2+MR81vmuL5h2PJEPJhAXHyKlpuAYcNVpZiiUPsiNyaRvWw9R+3S+g3CRlCAN74IMgSL1AodpvnystUPnkJTUvJOTToCe4kI2jlayTyAINNT6DmL6xzSLc73HeROAxR7fM3K4SQqYlgeTpUEwyytd8tiiOZZ7k4VVpvBKa1qKhlHaKHAeTu1/rPm+tD4JR33IUiSOL1B3pCsGcyRLOCUzimlDXYzj60uDquBDFVtgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

This is the first half of the patch series[1]. The remaining part,
which covers proactive writeback, will be submitted later once the
swap tiering design is finalized.

This series fixes and improves the zswap global shrinker (shrink_worker()):
Patch 1: Fix missing global shrinker when memory cgroup is disabled.
Patch 2: Extend shrink_memcg() to support batch writeback and update its
         return value semantics, thereby improving the writeback efficiency
         in the shrink_worker() path.

[1] https://lore.kernel.org/all/20260629112032.20423-1-jiahao.kernel@gmail.com

Hao Jia (2):
  mm/zswap: Fix global shrinker when memory cgroup is disabled
  mm/zswap: Support batch writeback in shrink_memcg()

 mm/zswap.c | 100 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 75 insertions(+), 25 deletions(-)

-- 
2.34.1


