Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFBC4EA3C33
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8FD6B008A; Thu,  9 Apr 2026 06:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532F46B0092; Thu,  9 Apr 2026 06:33:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1526B008A; Thu,  9 Apr 2026 06:33:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29D946B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:33:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1CF41B8446
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:33:52 +0000 (UTC)
X-FDA: 84638656704.16.38D0AD6
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1F18712000B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:33:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a+i5tAvc;
	spf=pass (imf29.hostedemail.com: domain of komlomal@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=komlomal@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775730831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IZCUPUgWtF9cnC+OBlLzSDFkNCO2ZEIu1l+DqN/zQCg=;
	b=5b6/Y3RrJ7cBt/tt0dL80dRJRF2PaShZ3Q+8sK5kvlFgRqOkXL9lOsJ3f6wkUdH36My/g8
	5Ff94G2H8YUG6gWR6cHmj/zIdCFVUaWTMxmnW8CbZNE2CyxBO2J6PV5zyggaeZAc195d5O
	s2Kqq2mTqf8pWyu34jeIyGM/hJhgULc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a+i5tAvc;
	spf=pass (imf29.hostedemail.com: domain of komlomal@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=komlomal@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775730831; a=rsa-sha256;
	cv=none;
	b=xkv6y+fjQNXdcFU0PUZ8wd5Rh5pOoQXubuFDXEWsJFvoeqhC8LMWmZ2R7FDydLbwnZ/jjL
	TEUCk5CBnStC6cLwarxezP7i/KMMQY0As95k9SIawlLQMtc6s2ciRgikkNNHitCQEqAGWV
	C6sxRt1hA8JeGmAV2GCOofGdFbjFHc0=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38dd5f28a4cso6376451fa.2
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 03:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775730829; x=1776335629; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IZCUPUgWtF9cnC+OBlLzSDFkNCO2ZEIu1l+DqN/zQCg=;
        b=a+i5tAvcVTKZ24RCoOmc10ZvChhCxn1+z6tWPCoOjMDGajlQ5ORDVl5pKbW98EsJnx
         lC/kXKE00zCdWo4uDPnMMemHAIQP29ltjWcdyD6Wg7KhtCLANswRqRNzM/smsTQpMMvX
         1KCOgJmnUM/YKe0pAw/UEDL3nMXeUJCpxMM0Ust9ihbpbIt9GOt4JLHiFAtAhLbXczrS
         CE4yGZuOJGiiD5OJZP7OURt148gSIecQYcS5EcmNmF6f1+xjK6PrEu0Ds/xF2wgBCCvF
         sVVKn6E3pElgfqdBe2ay+5yk9FynaAAsFPuI1pJFDzpAqrDy3qqicWFltjHt8Pg0BX6D
         qXQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775730829; x=1776335629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZCUPUgWtF9cnC+OBlLzSDFkNCO2ZEIu1l+DqN/zQCg=;
        b=VN6isOaW9l+df2eVzEUa1CPky96odCcICY9/3Y2JUMPexwgT4bEO6j2q4JX4jn40Lp
         1jcyVQ+9wYIWBW/ZAyLNNMW8DLMhFUVvTHnYAEdYgdhEEGciE67tKY9U2cPolDxxTIGo
         SZY7gfkAwhTMxUR4Lq/6MZRwgtlbNi/wJv3DW9lZjIm0fuvdRVvesUbwXyb0q+fIfrG4
         dwCFxCgy2Zat/zJH3rTCmhuMmvHVjLPEpMYVfIdnhAk9tl2UyEd/3YL9uG4hV67pTPiy
         PtpoQHz7NHwOmWo4NfOljZrnS8BzXcPGuDz4A1etDJ/yVTcrkMc455dM85xYuG2T1V3r
         RBjw==
X-Forwarded-Encrypted: i=1; AJvYcCVxJU0w0hvA5j6cNhDh6+PVg7rfgG73PWkxlF+aHteuEMnqV345j44NQFVnqlMQGFqOkXnQau7G/Q==@kvack.org
X-Gm-Message-State: AOJu0YxQJyurXTmsSLiwwjDMeeXCtKTYLyDkctCNpR5tXTmNP9XpQ2Vk
	ygK7+8dc7A1y/umHUm4Vl2UlGb64jUhVHFIJx8xJqcQKMUmrlDq+x+DS
X-Gm-Gg: AeBDietEjcudLhHLtXN3EFEbNzfbntY4caJfgICrnwQUFm0Ske8V1brMfFdAWK2Rtvr
	EJD5XEmEoRvVRCdiVp/KfW6Ri0q7svZMfy2hfjm7F28BuRxvonYuFH4+TEO1Sy6Z1cxXU/Yxse1
	ElFMAVeF0YFK0IqcpKyTnP1AL+VKexhLJJIbgrZfFzomk5eATnmloExrgedicY1tcRnSJYMhBNb
	c0FXliBlVxNPNoTD1rls7yloJFCxVVId2nVxaa+r1vJ1xxqAXfXY74e/AeyI1mT0+1Uari3eQBv
	w++vAsLkuOvFcUdMRe15G+Q+IXEvLOoaGMjMxgyeZXTaBlR37XILgRVJh6F0z7ZM9nzLq8S+BYi
	5my0cdS0RXqp0vaoezFqPvqNG9qf/WREajs9cmODfwyUGt21M/Z/CQc7jWWWhMqv7R8E/z9aMMa
	n0zc3DIn4ohnDVCGN7hMsv
X-Received: by 2002:a05:6512:3044:b0:59e:57d2:75f0 with SMTP id 2adb3069b0e04-5a33758ad0fmr9639795e87.32.1775730828956;
        Thu, 09 Apr 2026 03:33:48 -0700 (PDT)
Received: from agp-laptop.. ([5.180.139.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2c9f42b6fsm4958305e87.84.2026.04.09.03.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 03:33:48 -0700 (PDT)
From: "Denis M. Karpov" <komlomal@gmail.com>
To: harry@kernel.org,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	Liam.Howlett@oracle.com,
	ljs@kernel.org
Cc: vbabka@kernel.org,
	jannh@google.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.arif@linux.dev,
	"Denis M. Karpov" <komlomal@gmail.com>
Subject: [PATCH v2] userfaultfd: allow registration of ranges below mmap_min_addr
Date: Thu,  9 Apr 2026 13:33:45 +0300
Message-ID: <20260409103345.15044-1-komlomal@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9xoqw8rgqo5pnad4kzkx6e7eckh5h87i
X-Rspamd-Queue-Id: 1F18712000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1775730830-556500
X-HE-Meta: U2FsdGVkX1+c7BuQpyn2V3Hh8CDiSQp/ecJN5BLf3rymrlCEbb4PI+rKH609us5S4su63molZ+h6x/9rm8nfZtW3CCMhMRf4+wMUbpe1/yOvUvQhLRg89silSfBJr/YXA8dDHgMYu4BZuyyCa/RdNBeNS8U3Efg+vLPSEIIrQEDXeowJHimR5jD/Q7Lf8BJD9kIUKsw/lvZdWsJBU5ylnIluHVI15rYh+rMkR7OELO/e0h47U2/va7vnZKffcyjEUxbrRwgvrWuCz8t+40dG9KMx05KTDo3CvpGfheyYNca3CPQ/RxEY8Y6lXtTYJt382zry6ApaXHjZ9JXK+5QrHCFLPvLG2upTFqqjwNmDL52kLs2JDAftsMBFe7gmNldrA9ZDMbfWLzuGxzla8lzcV4RZ3bB0cxd8ItFKpCIxEJiKqyBHFvXL8e7r9qJKTNtIoR4Vo37aoAUxF1kMa1PWfFG0WYwJi7KlnCOTQ17H3sfI7LsXr9D6TyjpCDuCwe1oSnc0eAVctfDnuTG3ZYtjRxPXXPusjYid7qiSBHzqGSf4AYpSshwg+WI3rPJXFGR54MTwnL0O8NZ5lwmYvvDgk4apo46QdAT1RUNT1mP/bGUf3nKzZE9y5Fox1XiApcPoXAYNK4S1bscrLe1v+eC5Zw1kRySsmac1lWvyrCExrkq9JWIuT4pZAlI+O5T1numVoagL8iGYXbXwjdxgSUOi9SrFGDxkwoeUdUR9e1B03zEtf2rntdo7zyBDMkpeM2280Wxr8WheM/lkmwWIFH8Fb+RpsltyqHKOHLEmCGO+LY0EzQWbqU0vgvkAxwR3IQWFblXTn3YZhInUv4iLPa1PqfaLzlQ3UCCgh1S+fTTg33ikH9rlwxoWhQBjFL8QjJyoF5X35A7t6qtvjHYsAdtPlxLfGujcl2ef2WOxXh/R4ebS4Gt4b5dcYZs5dbPwX76rccSCsRaXmLfJZQo5Pxq
 4G/ZFlnH
 Bcq+pkWLTLCQpy7/L9gqEf/6uK6hP9Cwgsrek8LJ2vF3ivWvN5nODeBqT96BG7NrkSUnGvc55kPUWqfTwtn6M8ks8glWOn+iwXlkAoG7Fv+bfh7JvfDnrsjZkTKk3Mux4+m9gParjCTNsodyzwdSBkHlFwkf4F11N4u7Y3jnKMs0ZtCa/6+vM0nTBmYo6k7LijenfXai+s0gvG1iPISzuCpU+t19kSkMFvwsE1eV6fxsXumKtF+stYBhT2RKF/7CdKpfwl6D2ip2A7x42WBv+2HNybeM/qiy6DUFqt7LLYAspd9CUMUp0yniov7SKLhUAi26rNTNU00nNac+cXUg95h41DZjlMDorUgjsG+JkLWuzFGEa3NrVbnPVNAccyPTw6XGcc5B5asjtRY5S7JrzFJbc6zGy42SQbzfGJyVw5jdTwzGdao19npgIJ7blaDsi//32+EPsNjBB3lMFiBdFtkaUwUNYs3+TlZ7MuELwk7kgCE8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current implementation of validate_range() in fs/userfaultfd.c
performs a hard check against mmap_min_addr. This is redundant because
UFFDIO_REGISTER operates on memory ranges that must already be backed
by a VMA.

Enforcing mmap_min_addr or capability checks again in userfaultfd is
unnecessary and prevents applications like binary compilers from
using UFFD for valid memory regions mapped by application.

Remove the redundant check for mmap_min_addr.

Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory externalization")
Signed-off-by: Denis M. Karpov <komlomal@gmail.com>
---
v2:
- Remove the check entirely rather than replacing it, as suggested by
  Harry Yoo and Lorenzo Stoakes.
- Added Fixes tag.
- Link to v1: https://lore.kernel.org/r/20260407081442.6256-1-komlomal@gmail.com
---
 fs/userfaultfd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index bdc84e521..4b53dc4a3 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1238,8 +1238,6 @@ static __always_inline int validate_unaligned_range(
 		return -EINVAL;
 	if (!len)
 		return -EINVAL;
-	if (start < mmap_min_addr)
-		return -EINVAL;
 	if (start >= task_size)
 		return -EINVAL;
 	if (len > task_size - start)
-- 
2.43.0


