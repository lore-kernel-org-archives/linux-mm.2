Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6F63CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 15:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7C46B0092; Fri, 15 May 2026 11:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF8B6B0093; Fri, 15 May 2026 11:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C51B6B0095; Fri, 15 May 2026 11:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 012CA6B0092
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:30:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9896D8A129
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:30:15 +0000 (UTC)
X-FDA: 84770040390.23.8F83ED3
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id AA8EE100003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:30:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ML9Jmhno;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778859013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pCT50F09W9Pfh+tE47fYAE9hDKHODKy1uv+otm/GOHk=;
	b=HO7iGOX8W45su6wWOG8egdQW+xyFylCIDnDC4J5pxU60ZFKEvbaKfLox4N94o4LKqVcIMj
	+OZ+4oECVb2bTKzVraRQ7UEuf4eT1jLRnvBIpB9qG70sj7KBQp121S5coPgIFK9NXWIa6W
	VAMhul/u0Y5CTOe4/jZonO+e6k3nsqI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ML9Jmhno;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778859013; a=rsa-sha256;
	cv=none;
	b=Ko4Ig8tFpTCegLrIK706XQCQHm2OCbcL45/ZMQcgoeaFjbqbb8R+iLPpgXdG66gBa6jK5s
	NAfMViK6mU3V4zOmsZKli+Nfe0H8+51SMalkRkEZmEfSKL0qnQcdPqhFTWnujOXzie1g+e
	/SGepT52OXsJiJraDfbgWPoanXVcRLE=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5a887ebb416so9110199e87.2
        for <linux-mm@kvack.org>; Fri, 15 May 2026 08:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778859012; x=1779463812; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pCT50F09W9Pfh+tE47fYAE9hDKHODKy1uv+otm/GOHk=;
        b=ML9JmhnoK8N7Zv6NnR7RswvhTI/7To1Df7gKUKdFNJuO9o6CsWTM394AKGJfjE1Owz
         MPjc5lXgL3pTLrG/OhkxdA5mHVqfXngl6+HkTSA5kO1CPwp0HsetzrROUS/P2J5+S1YR
         jyCzhqEKthadbjx0Jc71rkbqvEIEbvKUYudt0yR6SYPt5/4coIA2NFxLLixmL1ux9/+e
         tSuMb4d0UtYZRE9Wi7bt0SO8UuTgNC/8UkiViPE52ST7efcBHJtPk8txE0ofwsVnoOCu
         ltiiK563hMd4QEuiD51v/feuodxYvhMcsdjPe92dtZ59wyyPXHrMcpvv3Wc4ocFC59yq
         W+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778859012; x=1779463812;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pCT50F09W9Pfh+tE47fYAE9hDKHODKy1uv+otm/GOHk=;
        b=iKy4gF0LfOOhFw0iyVQo546Litj0NjeY3qCZUsUcmZkm4j49zyOWj58tsz3aDtTZMx
         xbGrumqnHsniBq9P133511WhtyAEACp9dYXHBpBMrJcoJgEhyPpRHjcrY3Dk59EeScVd
         da/+nwsut1lgiJsdng3tkkK8FJB5NF6phCMpoBIx/TW44jeDPV03ZjaugV5WpXPsZBDc
         FT0j0WfiifI/GrR4V6wz3CFzoPh7CSvv+3JbRHJEjPWxrskM3E2QGTM3nob3/F4J/VVz
         tFvq1a6Z/dQLy9XhArYLtOI7IGEVWY0pWuLeU9Ur+UQ2XW4s+VAEIyTyM9vlV2X/Jai6
         S8OQ==
X-Gm-Message-State: AOJu0Yx9rEcUbyn9xBds6TOzdetUaIdI2TmioAovJst5X7hwoTJMKv61
	OzKt/zUa9n+sI68Q3lHndzFcgeXBR3/HODPGVs/HSSgvBo+eDgloBPtJrdMJJg==
X-Gm-Gg: Acq92OH/bPIhOXsbnGUoLuk9mwt/TNLYy8QiZDQF5U1X84/nAKv6N2zu2MBzTD2bFag
	EuDTwXfiJifv6YalfXOiMJW21wnWcupII8D0zX/DhDIrXc4oHRdj7D3lxFOnH0jUcuifj6ak7yu
	XuwZmVOX0Py9aZIloR7gDIBkI7ZwdnORKC1LPDVN7b/2Nb1aiTZOkYy79gPlyV8M/DdNqEiEQJd
	jAfGbhzv9vxxS9rr81tDZF70bbAlGWk6ZEwEoEsDFICCJRh5HmNvRWaez1JDbCSydCn9jhmniOh
	bOmajJwcWu1F/RMtABBwdI/hCjpPPA3p52aql+oGWhmwJSzVleLI9UqL+NPq2xephW9lEx8W7rP
	wrT7cKdNjjwW0j2FFkCV/QybB3qTg6pmV5JmTuVbRQSlh23+1KECXbLqi1Rndu61eUFcO+DG15m
	yO9AzNttPkh3FKDPj2FuXPgR36jrAz9y9fkH23
X-Received: by 2002:a05:6512:a92:b0:5a2:a3dc:51e3 with SMTP id 2adb3069b0e04-5aa0e623646mr1555106e87.12.1778859011374;
        Fri, 15 May 2026 08:30:11 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3945c8c8415sm16412801fa.11.2026.05.15.08.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 08:30:10 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+8b12fc6e0fb139765b58@syzkaller.appspotmail.com
Subject: [PATCH] mm/vmalloc: Do not trigger BUG() on BH disabled context
Date: Fri, 15 May 2026 17:30:09 +0200
Message-ID: <20260515153009.2296191-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AA8EE100003
X-Rspam-User: 
X-Stat-Signature: neex9sjbtrjoifpo17b81gj673ss57o9
X-HE-Tag: 1778859013-322606
X-HE-Meta: U2FsdGVkX1/fRH669ZzT/ht0HilCBTtm5fGtBhtXl5F+TbGbWddGYQSZNSRCt+fuAf/25UO1QcNfln0bckvSfUx1HeSfIDDYv/IjQkAGW2j+NKbfhTGD5JPMk3Hsn0VAcMZxrm9V84Q1FobgoJ1ZXSq+fXQ+5tjWKTPszIn2eum9LODsgnHD44xJlRZqp00ikep49I//4vKTFYU4y+P9XJcxJx03svJMPuiwI91YMSDDxSBw6h/h5B6SOs2SMu41ke98ufz7gLhrlON0kqs3QWFDwQQk8KpaMkv6y+7X9+QrLxOiXVVvr+wuBli/Ughz4yEuPWFiK+SOWuoOt9DzA44fTHzkOJhNjR5dWfLOYWVZaz9pvxT1hBbthr8NJerEH/XnHF2w6FAugrho8GfMrJeZZUE6ShYNRwX3ADHTbbfeT/Z8KtqO++G1suon6h57bu6ECIjlaawaRjzWT39YRIuHuFdY+y+XdiD5TqgXQl4OE/uOXkHcUVzKx7ZsEAPazAkp3Y2TdgKsc3HYocN5tY9WEPf5Wqk/WmDLMYKV1VzKX71EJAkei4bQS793SRnNbN7lUEAR8a/p2HdBJK5brFcrHXYIeg60dYxGFidlBUALtotYVSK5C1TdXoEBn860eK2ULOXCfFB3H+k1szLBAJc0Yqf5TOzJWLKeToav6ukW1oMJOrOAqR7j2K/JMlvDgej16+Mu+XCVLbh4goLmpJXBKsfqsSo+kRKYRfrSOynFKGh2GiIE7KthJ3YMKrdQrnDfipMERX0k18vXQM4CWuxid/2p+T3ahweTXjKmODhzqsqP/W6n5Nuc0kRXu7ofc4NXyECNoATg4ypzA0X5tZFnIthYeHB8y3Fpg9IoL5MR4kgY/V5sx2lI3CAJZfLtCduchMCkPLsg7N26KkxXczbBysgebDZWgBuTBkFpZfTs0NzkYFLSUP5oLQ9SvWVIOBzxczAB9zALoJ+KW7N
 je9G+HdE
 8AVie1ZrVucG1S7MBx3JrVFco6ytz/spyuGDyXfSrJj5SRkdUN+dsaiZfcev4K8TRzdSEYeWZZvFdsl5Ofz2GoDoKkAcaSlFZ2RrrIAsyz9uEvPYi/H/rybIh4vrQLz+NihM0sWFnyoy87I10Pza+pPAI31ppETEhJP72G06VNt5NV5qLE+9P1Xa2FnYD9r/C2eAhJYL8r+fp+xQQ7PRY+FNcBDwxtM4bnVe+/2FC4REbW/eac/mDqTD6lV5+Tfuox6wuaipTel4FuI89Gq0O5gMll4QBdw2mpJ+VdqQ3YYpcSRzZYb5RRno/ExcvNQCW8yG5WXjJZspIw+IABtsdvRBD6JdOCWxAsxcYrNv4TrlQCSEPFg67dPpd0qFaHQLV9yn0ko53/wU5OD/AaYsbARQ0zpsQn6Krkb0aDYxeT+jpH2MJrzm1hIikgAm/D2dXfH2+MPTN4y4AhoCEU2pieDXZ1odVJKiWXvlNEJdh8dLh9hiL7aHm3Snj3FtmdBjuy80qDul+cazs3h4+o85kJXCVR1MNGGBbz0UGy6edwPSBaHZI/oFgRVxD+nRJa4P7EDKWi9oU10kCJ4nf8QHZcW3h5Iu++vn8z2YvYRsO3FQBpvAHcD3o7NcgZnnkVyEeYcaHvV9gHbRUldg+g+EyQcjwBP0Ou4JCXk6Z+bfovbeXoA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__get_vm_area_node() currently triggers a BUG() if in_interrupt()
returns true. However, in_interrupt() also reports true when BH
are disabled.

The bridge code can call rhashtable_lookup_insert_fast() with
bottom halves disabled:

__vlan_add()
 -> br_fdb_add_local()
  spin_lock_bh(&br->hash_lock); <-- Disable BH
   -> fdb_add_local()
    -> fdb_create()
     -> rhashtable_lookup_insert_fast()
      -> kvmalloc()
       -> vmalloc()
        -> __get_vm_area_node()
         -> BUG_ON(in_interrupt())
  spin_unlock_bh(&br->hash_lock)

this triggers the BUG() despite the caller not being in NMI or
hard IRQ context.

Replace the in_interrupt() check with in_nmi() || in_hardirq().

Cc: Ido Schimmel <idosch@nvidia.com>
Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")
Reported-by: syzbot+8b12fc6e0fb139765b58@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69ff8c7c.050a0220.1036b8.000b.GAE@google.com/
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 676851d5cfe7..273bbe49eaef 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3209,7 +3209,7 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
 	struct vm_struct *area;
 	unsigned long requested_size = size;
 
-	BUG_ON(in_interrupt());
+	BUG_ON(in_nmi() || in_hardirq());
 	size = ALIGN(size, 1ul << shift);
 	if (unlikely(!size))
 		return NULL;
-- 
2.47.3


