Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C28DCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9D5C8E0120; Tue, 14 Oct 2025 09:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C744E8E00A7; Tue, 14 Oct 2025 09:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1B88E0120; Tue, 14 Oct 2025 09:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7CC38E00A7
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:49:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5269613BEC9
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:49:26 +0000 (UTC)
X-FDA: 83996851932.08.B1728F1
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1F74F40011
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:49:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H9lkPsFR;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760449764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=tCgmqJvknBYMayRBo/EEQO5FxQxWgCwoPiscAHcvwvs=;
	b=2nfcN0SQsA4galgB5micEpf5NRrinSZHoclEakFJkIANK4iaBfWcnbvkn7s4pnSPEb/oC6
	9gRSx3F+LVAaRglTGpSZT+ckOVHn/AryaGl0UPzmqKEe6vwU3G8A6YoTvOh4B0nKPRIj/A
	muJAkrTBKGbGIQQdvXO1LdqHbAsT6Jw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H9lkPsFR;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760449764; a=rsa-sha256;
	cv=none;
	b=NKnhWNk6FTVVRH2KSld6flzfOpwKsgduB7BKOtTa7f+7r+1numON6pJI2J0GHmEdvD2drV
	5yGGXjyS8E2y4ljOjtuKiCYlQNu2B5Sfq6BZ7b7K27lEBi5ppUDw8MDae7TUAIUkAvXCxo
	jz+VhmSNKmyyMKsSi8Di1uBFSDEMQy8=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e4f2696bdso54200955e9.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760449762; x=1761054562; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tCgmqJvknBYMayRBo/EEQO5FxQxWgCwoPiscAHcvwvs=;
        b=H9lkPsFR9qFHe4hAmMDdl5aKPM/W3TfueHtQZSz1y9L+QWFj5T/SGKM16xhzK1bsaL
         /WcJCKeRBaMUtFwnBk0blp60aXoDTiI/XU16bnd73GZIsZRrJ2WuTJR911j1bEbeJ5Oc
         jXaUEUdhGWdIoc3ivhnyEDbBIfcat9n3QWjBOlmAFYck00lrCLzBRLB/HB4Har7iaE0r
         OCVVjPaqzWj+8RWe6TipImX/wBC918DY/1swisuWV7p8/XnZWvV+ei6u9qDiqlscyQdy
         lCDow/UZP9OKjZ/S7uo8rRBel1cIywMthRzjfbLu9/SBQiasXzFkMr7YFIICrlPDiQyH
         QUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760449763; x=1761054563;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tCgmqJvknBYMayRBo/EEQO5FxQxWgCwoPiscAHcvwvs=;
        b=j9SH72TxbjDYNJzU21zlHRmVPLZOEft56XUq6rz2CDsjpf66uyEG6qUWCtmzXMczq9
         qGsrAvN2EBVbBLsXofxUbCRxhZCMazIYowFRAZI3MbFIaS3wkiQNwIw7LmSg24WmIkAO
         a8zkbyAhC1EExxRa9YUbHuk4NUyOzX2PDQmNwwgi1PpewbnaNlSKDvkv+chj5GIPHHdA
         9uHBcDbrVwaRiItMgIwSbUqCJ6ymsoYUOUWPX206KIlu+h2V0autqlOOiaizMV47y6Se
         1/3+FPO5GIpUGsGkTb7Ll84ebPRrhvAykVt+FcgE5k2GvISyOxv+3vzPTVnVYIewHTJi
         kPNw==
X-Gm-Message-State: AOJu0Yx1i/b8IpD2RYwsUhCDMBzHhl+7RU8fvYTULuDx7NwJxtcSFypS
	4jgFg1SMXcuXwJRQWjEO8V+5QonbM9SKV0HCkIDro+ODLvnRhrGjQVcZ
X-Gm-Gg: ASbGncvGBXhNp0O+U6xBsvCPkldexUAOdPVv71igtyfuR+QC9D+KVXWOE4tr3nrgwWl
	ykzJFDDBKs0aydR1Q5LLXw1obCC8lU9YsWfj5dRJI5mPCDYmTqhsutjjmr0fdl4CU5UgyozV1h2
	+IgUrCl9lw7MBnLTJVDiB9NRSQw0orYRK2yN8cbDUspxH4hPe5OX48+uR5K2J9GioaxlfEg9L0E
	AsUrEbiedsGbnLvbP06lDQaNt4FoSKh6mVGXyQLmlCcgwJzjTLWkKexYHjXmiBWTUeO2IueibmK
	T3arIQK8Ewu63+Vh9nsjVLNkzCQjz2hwPNLL6GYdQq55J54dgZNWTAbmgBLB33eNZXZ447GvAx6
	nhQnbt8N3Zt7O5TCRJjeh+bpUtAzSurZBvBcqnO4Q
X-Google-Smtp-Source: AGHT+IFY+gANpniWkXG4tabZwLq78fi+X8Haz4kZ6mw9dieSkJXLm56wYOiiw4IHyX+w0C/kjy270g==
X-Received: by 2002:a05:600c:4586:b0:46e:45d3:82fd with SMTP id 5b1f17b1804b1-46fa9b086e1mr189637785e9.31.1760449762412;
        Tue, 14 Oct 2025 06:49:22 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fc155143fsm193071825e9.11.2025.10.14.06.49.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Oct 2025 06:49:22 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 0/5] mm/huge_memory: cleanup __split_unmapped_folio()
Date: Tue, 14 Oct 2025 13:46:01 +0000
Message-Id: <20251014134606.22543-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: k5fse9gd1tmsty8y7575tc6yys9393u6
X-Rspamd-Queue-Id: 1F74F40011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760449763-65142
X-HE-Meta: U2FsdGVkX18Ssp5T5nXSa3voAzulEnWn9KkvmVjNekK/EtqJtSWPQ3Z/S8zzgFv4ISgHYAKcJ09d+6HymTwQb3kjsuzQi6JlgzdPy9FyG8yOTNlJYoztvlFKQWW+YDjtbBzEO1QKllgoEW4gK7sKQQm+GA4Fe7CUhrXz3lotqru27KsW1waFnIAo65lBevmw85Z5Z0eUkebCHIzw13t8BlwihM9uzbVrHdeCLuItbxcKhMR3r3rkSVBf5MQJmRq4DjF3GKC+J1p5EtoJqYtREuk+mdmc/ytSCJM3jGb8dpv9cphNnWkzZ7r4iFbKnvbRyEuPHlxJq8eIfqc4VpZGgz9OU5Hp8zRzmKRcVVrehgCWP3k8aZSvrr1l0f68QPQ1LKS02Ml2EFIub1v6hsngoI3de8y3rwjuzaW/7HxMg/JyVvwWaRWOs0vqh9bOqiMVvjwQJfi2LC0E0o+MUrEU4g21wiJPs/8U/yHM2C+4q0bXIZvJnir0Oy+OHecnDxAbn52ob5ly8O2WUsdFGj9XW8CWPhEMB4I6mm4oku1kJWcpp34f3AmnnRvbf9RSrGSbqwHJXTN2cwTxAuV94ezUca5L3P1/PQsC2Plc3WTW49U3U2VvwaGP3Tx4IMJMeMkQ/FKa2Ehe6hPJyQKPzqX3yjM8c3ub9H7dJjvK5x+1y3ZQkskbzpPq7YVODB+qqqG8mAd53A0z7iQfOlWTMhutkcRV7lGirjMOsCPZ6rRN0U/fJ+7wuxBqyJmmfMLAKkFLmqnSB7xURX64Xvn1Q6T4YGYGKS8kvsGHQKSz1KjIOnL/uKiqFj+D5/Zv5mq+t1gNkkTYwTIBqBbj8IgcV4Hi93JihdBy/ZP+LaauwLP6PiDB15LGq8AvQjGFPTcamo8rE2rz2lMjvjzmq5ZHIevTGS9a61z7txaOXvAwkYLdRCB6PEihnuUVV7O48kt6fXLSc5fhqalw+GgbLrLn1ee
 kbzw6dNU
 DN2bGSXZJEKBSD4z8QaP9M57PnDuGTE2r7/DqbmAmYMBJo8m9x+/7LPLVjsiunVHOjs0rhZGOL1GYg8rmY4kW7SxlkKYWqMbuilYjIwSlwXDk0GnK4k5EBNTm2TZ/AZe3fgZKAanJBa9zlKEmRoeewTf/PvCjtovZVnsj5dBxkLJNcRNomb58iqf7NclG9Vt4o3xtyPPKQDvPH3boXTplfXeombY5VEDhlxXHfPfS0YbH/oa3hr8ZwutSniPpbQo+5TtKafTevElwmv7OKYxXC07lrDwPg5e0/4o54FGl9C3pJiLikoZO0+dOaMosStnC0LBaFMrSSzW0xq/kJar7TbtXsUBwuIK8PBso2Q0cLYzr/Z0z+k/gZWcViL7tllYH3vaJannPRE3jadtTRqMNCQbaSYEH3V6vqE/DQ3H1SX2NGlUFuWZN7vZrSOJrWa58wmwN1P3AFK0eYWuXGeGqTIw4E61+QfyxK9fZEEA1tgP1YkJTkHxdmKtxaJ9m8Av1uYAZLvcIaMj7VBoVeNtCfBUKe4/LK4JR3dr+p0B1ow15SiM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This short patch series cleans up and optimizes the internal logic of folio
splitting, particularly focusing on the __split_unmapped_folio() function.

The goal is to improve clarity and efficiency by eliminating redundant
checks, caching stable attribute values, and simplifying the iteration
logic used for updating folio statistics.

These changes make the code easier to follow and maintain.

Wei Yang (5):
  mm/huge_memory: cache folio attribute in __split_unmapped_folio()
  mm/huge_memory: update folio stat after successful split
  mm/huge_memory: Optimize and simplify folio stat update after split
  mm/huge_memory: Optimize old_order derivation during folio splitting
  mm/huge_memory: Remove redundant split_order != new_order check in
    uniform_split

 mm/huge_memory.c | 70 +++++++++++++-----------------------------------
 1 file changed, 18 insertions(+), 52 deletions(-)

-- 
2.34.1


