Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DECC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 14:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24ACA6B0088; Tue, 29 Jul 2025 10:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FBD96B0089; Tue, 29 Jul 2025 10:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C4D66B008A; Tue, 29 Jul 2025 10:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF91A6B0088
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:44:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 442C71D44E1
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:44:50 +0000 (UTC)
X-FDA: 83717573940.21.72F6281
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 708D240008
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:44:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R8KD7r8w;
	spf=pass (imf17.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753800288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+HTk2A+A73hmwRAbv/w2ew46OXVZ23/y0J+XLjG1S7w=;
	b=Pkw3m7GHqft5DqlpgmHhjco4wtIQBUwJq6yZruTDuoROGcB9uYFz+ZzUD2PVZO/ZcrLAEm
	rhIXR37jW9K75sD62UeUT63+ukvu09dUwPfhJDCwu5HG0yt2BCRdprEKrrXd7qqYzRxZ0N
	ACototF2Gt8T0GfDyiLq8MFyxeHdbyI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753800288; a=rsa-sha256;
	cv=none;
	b=iMt5JS53zHkG0KQ5OQNPhrDc5VqSUHf2eAH8/aktL9taBFYbm3idf/7f36P9bnvduU4lh1
	odUaYLB1f1Z/gbIurLx/J+y9cr4AomR+se4XKvxNdRYD7l1AakQfetPHRR6lgSMh3g2LoE
	0dQc8WBUCrdU/l8DV4XTrqu5DdZw9s0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R8KD7r8w;
	spf=pass (imf17.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76a3374b143so697551b3a.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753800287; x=1754405087; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+HTk2A+A73hmwRAbv/w2ew46OXVZ23/y0J+XLjG1S7w=;
        b=R8KD7r8wuB/REM2icjNuhPJYb9jj9VBkoctvmNbyS90dcrjPHa/wFJ3qpke9rBCuxO
         VjtAF64hbkHeTkIIqtVgQYl3DPK/DI/BY/rLZLYilB+G/qReWQArPBCJOgcB/9EzcgK3
         8Y7T6VxJrwKGu5SCWkwbGl9+5fepkNxHisQ9abUseYVZuBo3U7lWp/eMXdcVHIdJAw4X
         cx0I51M0075wfjXfQl3DQggt0BAiKxNhcsGs6+q7Vq17ajAzizSDIIv4Z7BsKtB9rE2b
         IDhtDpgIzSbxVgi4SYMPSfurYiHVcnDVCdaq7Elj6OV0JnNJKpANeXxHv8BIbcj4bY1u
         pz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753800287; x=1754405087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+HTk2A+A73hmwRAbv/w2ew46OXVZ23/y0J+XLjG1S7w=;
        b=adCoe6Mse9zzysVkso7DuWQHo4pNJ7zheAqx2zbmXnp0K7KyJwptv7aJNnFawIGehW
         TpkCvhn0bD997anOzrMgIu0jenj2GVU+cX3vqFeoRjAoTL0Q3Dq7AowtsDxdJlm7KFNn
         mXayzWJfUYdl6+P37szalInIn/ZxqIC7iF+/GMUMrqlxvg5+i61w/HNlfksvL1ZnxmzY
         yDomUDkHLp8zFk4t1u1ItdfDcnfU3lzh/eQ/UIl+cf/eDNjyct5SxGnLh3YvY97lAbLc
         nROrkDywZoakDt9cHQSGbD/6SB4ryq9WO9diNBU3rUCfSXPz+uNSWREhKdnttQ+wD8ie
         7m7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWOqLZAPa5/r3ENEG+tsI4nwkiYi2BwFKmljc3THd0WdGjD4WM17sd5goguENG4l/3PHFGnTmrTug==@kvack.org
X-Gm-Message-State: AOJu0YzDCYVkxrYHuCFtG26YTqIuNtBjyBD2B2NuBCRwJic9F6GpxHUU
	bN0laqhOWN3P3pPOJbDeNhhn2PPSnmAx5YSw2+hrxrv78a3/G3fe+bJRALNkxjl3W+g=
X-Gm-Gg: ASbGncvvmIT+qiXJAwONo+4ZF0d0SYbFR/MxKFm3ulXq0gMrj3OHfVzsG8CfobIni4/
	v22g0KEiAE0PbnYRDfKSf4EZipJQBCTobpTnoVixQM4G4m4a3b0golQ+8tfIwjwYgOEv5s8JdyX
	KcCXpNvzv4R8+7hfhbqPhU7PqFWyrAkYVt0kCkK7L0ILEB3L7lemk1rU5y/SH+8TdQv5AflCXRr
	cZbDna8zP+LHOskrJKmBBDrfUhqPFeWp/QoJBRvJ1s7k9U9UBBQz5K+JXGRu/QnWE232BgZXD+2
	PVBTugo+9h2KV22sCqhdZT01WPocWTRNLGciOOt+1K4BO63ZMJFb+kGwQJZ2S2K7qcQtMG1/j6t
	gbOQO/NcjdmJfTqBm
X-Google-Smtp-Source: AGHT+IFWk9ARReG6XQopp7V7zsh3suvbk0HvFwJmFgTU4AFJ+iwnaGXqnNPcktMWy+/9+rFFzdRzdg==
X-Received: by 2002:a05:6a20:6a0f:b0:1f5:72eb:8b62 with SMTP id adf61e73a8af0-23d70081497mr25300747637.20.1753800287170;
        Tue, 29 Jul 2025 07:44:47 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7640b1e5c94sm8317223b3a.94.2025.07.29.07.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 07:44:46 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH] docs/mm/damon/design: fix typo
Date: Tue, 29 Jul 2025 23:44:14 +0900
Message-ID: <20250729144414.31958-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 708D240008
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: qhsoa6475y1py3xzmhkf6xjhcn14r5z7
X-HE-Tag: 1753800288-422691
X-HE-Meta: U2FsdGVkX1+6lMaUXf4iSRx0uje/+hCNanYu584Fc9O+4nGhJUAFjriOKtAKtgjtOhzBp/ljhuJ0qVDxgNn7hirNY1By8/JuptcQi55dydOVKFc4wfsUtl4wRHXNmck1YZ5wGau676W65zI0lJ3sjdkJffrApwMbX9bWgae/EDcclI4y8F8IMudvD0ORA9XXXhxtYrk4QZOmP36gBPk0jDUFqFWv9kN04Vp2LqvDXI+x6zg4UdhtOhRwLqVmN3n6c9f+7z40kyjGHx4a/zMIiVqOOSWOdIwkzCpniNFJCdEfSaKzI26ajjmy+U2VQY57y7ueudWpp10WBX6bGvP8NFGBegEnv/gUKQZJ4WsAZAHq8+vd+ZMcJOMBnca+tyMcAZ5iOEUIKQ0EGVtB1h5MTe24TP/SWEp1TaItnIhOfv6Kc1J08+Be0hZujOV2iGLy1bTGHCp0x3oHkV2yvpKKOXsZDJsz/goDsZ2GMwuqMWfNe92rBVa6927qXRq2JUVpedMsSLvYdbmQ/WqzcVyMcgTHs0ThYrxA/TK4fs+2/5i8kigNUuIvnz62A4T7pY7Lf58ar7A7Oje5RxmsTg6p8PJqY00/6p97/+mQ280OczS+GOdSeIx5CCSAH5FxBovO6U/WBRaXoBP2hlBCE/38PJTmPYqFyQAr/DfMq/lOqDJbDWnboHqE1rDz2KsO9CQ6VtVdKfzj2ylR11PfmaFjRcdEdtRh2ItA5ZVIVywPbD/JhG2SoiE57/diBeRDIeXhlTn83YEhEAkqNvuQeu+tpNIlrzvInOIQTV7MP0rUGlrH81bpHL9DaTJycO0nY/T541e87YUmfls/1Zfg19jaFkISLZw/Bd3MePYkNDYYYvW/G9REog4eX/ZG230Xtvwt+R8RFIqeMOFylp8Z/hESdX2XxWVUdueLj1tAkSEHOocslrqe6CVynhDa112oAqLlNVa2ZftfrmWUwXl+vX8
 1Co90S6+
 8q0ySQuVl8bT8IiDldH7hzi0p0N3Kz8CggxvFQgig01iDUTGMXalagFbfGlt6FRbB39XiFmjKyZpByDWhD1byv8XXqKxEa0hRmV/Rx1ZPpym3RnKJNwVji1GiKdfVlYmqDK51LLYeYadFUKjOLNbB1PCTshWSMuM1qzUFssWPx9Oro6E/nqd5wFqYEYHS+GTYZSjxNnfGV1N7VIwVq1ile0/tahcMl9a8dBO8hDvHqsiQcAkXg5OJmoAgd/UTlcDSPgQbF1x9+jkNvG/LQ+AxGw9FznhHj3L5ZrVtAFOmtLBcKJ81NJiY5qs89xovIslT7OUETUjACIWZmm45pL/Un4CTt1KmgzSJQxKD4F0Gp4WKOlpGj0IIkv1r5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are some typo in statistics section of DAMON design docs
- sz_trtied -> sz_tried

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
While studying about DAMON subsystem, I found some typos in docs.
This is my first kernel patch. So if there are any mistakes, please let
me know. I'll try to fix as soon as possible. Thanks for reviewing.

---
 Documentation/mm/damon/design.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 03f8137256f5..2f6ba5c7f4c7 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -689,7 +689,7 @@ DAMOS accounts below statistics for each scheme, from the beginning of the
 scheme's execution.
 
 - ``nr_tried``: Total number of regions that the scheme is tried to be applied.
-- ``sz_trtied``: Total size of regions that the scheme is tried to be applied.
+- ``sz_tried``: Total size of regions that the scheme is tried to be applied.
 - ``sz_ops_filter_passed``: Total bytes that passed operations set
   layer-handled DAMOS filters.
 - ``nr_applied``: Total number of regions that the scheme is applied.
-- 
2.43.0


