Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B40BCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 17:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494128E000B; Mon, 22 Sep 2025 13:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B548E0001; Mon, 22 Sep 2025 13:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359AB8E000B; Mon, 22 Sep 2025 13:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 202078E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:04:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEC7EC0131
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:04:31 +0000 (UTC)
X-FDA: 83917509942.16.A4B870C
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id EA856A0019
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:04:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RfgjlHj1;
	spf=pass (imf25.hostedemail.com: domain of viswanathiyyappan@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=viswanathiyyappan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758560670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Nc77MFzorwqtfxO6TersZ0PGs14XrPU5kx6kkJpwm/c=;
	b=8AvucLwZpuomLgsjduqA7Q6Dwkq3xuXgGvaBdistVB/IHlT/IiB458giDaBiFNdK6xXLPA
	ntB2peBjanis6QM63pJUcB696IhF+Yy60cg7+FjJALQvj2HE8jdXdPhTy7XwCYN6ctSwQo
	g3lCLWxvx2s4h2aYoheLK1yotSQcCMQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RfgjlHj1;
	spf=pass (imf25.hostedemail.com: domain of viswanathiyyappan@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=viswanathiyyappan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758560670; a=rsa-sha256;
	cv=none;
	b=aXzsIweQ5scAgB0cT7K4dvN1xsWK/82Y1I+tRuK8JdBR4uFCjx0kmVVSVUYzOsmWyKmDD5
	kjk1TNASZtOum5Z5nCKsbuSUKlcn5TaJT19RX3rnXDsShAPbKBdu2D+adgMPoe32R7EL7N
	sWvZlUE3ghO2/SFzT+LAHN4vqNOH8wY=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b5516255bedso2499756a12.3
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758560669; x=1759165469; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nc77MFzorwqtfxO6TersZ0PGs14XrPU5kx6kkJpwm/c=;
        b=RfgjlHj13Ypz9BTgPEetG3pBi2Xn7O/adMH9WYjht0jO87mLV8JicUvJL+BkJG/w86
         5x19uRWlCkVPcBsxv3wrimccOyyGRxMnVIls++b8zda+bxVBAtdSE4Z0aCLEZfbbKMFN
         n2v52IxkOmLjH3qNvcyEOYQvcW0kaDtVQ2YEGCxewStHdW/juDNSitdGCjQ6pYli2okC
         SearaGJEM/PgmFwHMSi5OJUy01CNUc1qXxaNQ8lg4Q6VPklQVaiTNAdWgChw5/QQhP8s
         sxkw/Hj2w+dy3d7He09xGINEcfTxIDH5BEbT4PXEhhI7SVDrI3xGWaKSrtCDD3BDEI/y
         C96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758560669; x=1759165469;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nc77MFzorwqtfxO6TersZ0PGs14XrPU5kx6kkJpwm/c=;
        b=hItUIOqbr00RJ4jS0RN7/gg+a5l3WWuXlu5E17X6LHbzafRxWtRPjZ6bbvYK1iAUmf
         CQU0Th+Ee0tJldU2I75xZzy6dmR78ev3/qHPl/R3C0D9iDqAYzxW+0oMoQs3oa+w9sbo
         TiNZlJlkQxI6qifqh07wfQMMFayxdXgL2q313BJXVqOkcQiBWCg2wiRDSsjkgxG0b8xS
         P62ISLwx8+i3hNs0GWRu1sasDThMC4JHfa+WT5fjsyI9eTlMsMZaBtP6/mxxyzkyZ4VH
         JIZxTQQwQIqxgNJ+TYTyoUbpRxnQXqRO2FFrfcfdB+z4s2U2ePX0CIcJJAjD7g/SBsjn
         hEhw==
X-Gm-Message-State: AOJu0YwQSH4qWL1Uux2SQHJOh4RyDwaX7WIMJhECupUtgTTWM7zt5tZ7
	WAeG0vSc+VNA6QCoJMA11+Bg/t6GeoPWEY6pG/QCWsdtH9ng3MoA3eYG
X-Gm-Gg: ASbGncsQxqINpvw7o/ci3qiuqXeRpluDAWouG3rO6CBEdkTUARPHDzhpYQfu1YPQUJY
	iiR/+PGOPlyWsLI9TVW5+PYcuUtmdNaLT1UFNy75o4qBYImfs88g7cX6aRp4wqN+RDtPEK165Hb
	PP+yCYBf+pbiorj/1JoCdOhuwpN6z/4fMtuWAWJ2NOC2hsorYtayuZ7Si9B5hhFyXE39xuFp5tl
	etvzmN+Cdr2NLd7SyqRYvZE0S/jxNGnp4jWFMYDfValjMwPl896DFeeMf2u13dgWz3F2E0rcauK
	ND3L+fP97Lk1dMX3PmVji+WOBZCYlydbFa033r2V61yubjgynZo/R47+YHAaeLlOjhsb++HjmFl
	MuO7otsRkb60hXSzxCH0dA7PD/NHkUKX5RaPl6Jz9I11jlppfcaMpUHUZebrKVltq7jirravTan
	WlERqJXnCk1FQy
X-Google-Smtp-Source: AGHT+IGsd8HkhcTtxst8+Dgce85bwqndE2KThGl7pjmFBv8FiVKOmjblKihFJmQw3vbhuDw9HB4q/A==
X-Received: by 2002:a17:903:b48:b0:264:1afd:82e6 with SMTP id d9443c01a7336-269ba5628fdmr135333825ad.53.1758560667816;
        Mon, 22 Sep 2025 10:04:27 -0700 (PDT)
Received: from debian.domain.name ([223.181.114.23])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26980310e41sm138227825ad.108.2025.09.22.10.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 10:04:27 -0700 (PDT)
From: I Viswanath <viswanathiyyappan@gmail.com>
To: vbabka@suse.cz,
	akpm@linux-foundation.org,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	linux-kernel-mentees@lists.linux.dev,
	I Viswanath <viswanathiyyappan@gmail.com>,
	syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
Subject: [RFC PATCH] mm/slab: Add size validation in kmalloc_array_* functions
Date: Mon, 22 Sep 2025 22:33:57 +0530
Message-ID: <20250922170357.148588-1-viswanathiyyappan@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA856A0019
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6fbusz4u1tyfc71zy1fpausur8ttfah3
X-HE-Tag: 1758560669-475867
X-HE-Meta: U2FsdGVkX1+UsJrrL+TBU3dHEsUV4hXjODJq0iFZ2eX3nJoy+nP54E/yq4kpfOQ6lVfPix7AMsp+jOWjCPq7I41exNLvNEmERsMQZXrIrjWY5A9zPNC/WgHd014dT/kjDIKrvvuu6DmncbIqIXsKpgCJ9FMWYnCt1sZQrGRKvsPx0VDcc7PD3JnTyxGV0D25KVlLeb6uHCusgxV/xuhRRBQWh/AgBe7xdRJjaX9RToAhoC+yyomPqwfgz589vsF9sIo4MBeDcwcTVd5GEeSSHURtGHb5hkHa2SXdEuJaGhNepfs+idhoeND4mpnmeij/FfM0TxmfgcDy1+ypuhA2+SEdqiEEwdkar21uPtjjrcNH+jTVrbMoSjG32dNFgHsjieBE+L5S7Xj5A/tGwg65tNW6zANg3JbN6nmxsMVSFNJ5T+YRWEsfcy9YQuUD2X4Py0GRhgaG9yQonF9vU4ZoaT4p7cmw4hQAXE2tl1oebk7ZHnA3AGdhhvQXySCJxx0FqaEcTW5Nh0FQ12WgJuwWiwp4XP+uuzc7NAmvX9GVetMl5iE/bZGjd/chjE3mFc11PZnMqspVT9ORrJtU430Ahx3tnDDyyS3Hp+v36jtP9AEDVIwqEYM+2s7mozBUcduk2/RXVA3r7DUOF/lMiBaimdAdDWCrtYQHO+H75u90Z8r9pj0Xy0+nXm+MAy4fD1Hk828ZC4vCZ/cagTQGunoHN7c9h2TYjACxaszBoJHvo9a1iinpeYCIFkMnXocer0uoRlclWgv9lXKK3JRLNzlVZdGDWfvDyHo1bwllolRNwTlFZHDWXMd9xIuNx0S0yYScq96uxC/lv6qGMtVvc/zwQ2Kun7nDh7OVrlyeZDb2T4QWGOKSCExoLpTTe3ueee+RqVr7DGX+HdGRsfu8js2a4Uu+ecyIHRlubSEd54G5fRgaxir/9CWJoKb57hcRG2RoFLZLzDKneNMKbGIbpoU
 v3BAgZX8
 hcmt4U4NaHWwUxJQupdaZcbMKQVx/IPSek+OblCJ3x0lqAw4jwrm7qujW6IbB9+nq0arBV7acKn+OD1Kmcap+1lzDyMNSzU6d3amD7pXAKWhajr2pYoNBOriKpgiPjN2vO/dA+mCb80QdVj9inG8NNuubgUUZvmEhcbFVLMxcZzopZEeoxo/OItxUAdgwQXyenybxhvuvkMGc2HK8gNUcykxktvOFSFN5gDRRg6uo4wzBPCRY53s87RpAOaYPp7Oh96C8tnlt/cpl7ZzaATaeapENvYOZV8KPmMMtm8TNTJlVTc6mKlYeG6DqwbxnCQGqMFQFZzWfv2asHw1SZ1VbPV3bkHyadSMEtM/eFt5sg60+GgH4o9jZTgU2+kPCgbJRoU5bknNuKENnxQEuDu8hbfyC3UfKGw5JxfP12QpXHwvxoKQ8aqDx8Dsc/dhEcSdj+f3zt91Qz6K04ZKl3fzy1Yt7UUOgtJC+I09+jkwcpv4dU8YgHlI/7n/ZOjczC32gf29dMatShF6FXFhx0OTdb136lZnPKQ2gJnO2+Tz7A3DIijpGTlMkgyEbRnZ9O4YYy59ermWzQfQ0lBwJdyVkGpmjuhcNLAkuKiCgT67EOzy6BFxo/D34mmaKFWWXl4RkqUg9C7UwdyCSj5bVBLPwgp8pM8LGq5+t4B/fv42tZPWVJYk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot reported WARNING in max_vclocks_store.

This occurs when the size argument fits into a u32 but is too large 
to allocate, i.e., when it's between KMALLOC_MAX_SIZE + 1 
and UINT_MAX (both limits included)

Add validation to kmalloc_array_noprof() and related functions to 
return early if the requested size exceeds KMALLOC_MAX_SIZE.

This seems like the most reasonable place for this guard.

Would it be a good idea to move the check down to 
the lower level functions like __kmalloc_node_noprof()?

Moving it up is not a good idea because
max_vclocks_store shouldn't reason around KMALLOC_MAX_SIZE, 
a mm specific macro.

Should the Fixes: commit here be the one in which this file 
was added?

Reported-by: syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
Tested-by: syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=94d20db923b9f51be0df
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: I Viswanath <viswanathiyyappan@gmail.com>
---
 include/linux/slab.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index d5a8ab98035c..6db15c5b2ce7 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -943,7 +943,7 @@ static inline __alloc_size(1, 2) void *kmalloc_array_noprof(size_t n, size_t siz
 {
 	size_t bytes;
 
-	if (unlikely(check_mul_overflow(n, size, &bytes)))
+	if (unlikely(check_mul_overflow(n, size, &bytes) || (bytes > KMALLOC_MAX_SIZE)))
 		return NULL;
 	return kmalloc_noprof(bytes, flags);
 }
@@ -973,7 +973,7 @@ static inline __realloc_size(2, 3) void * __must_check krealloc_array_noprof(voi
 {
 	size_t bytes;
 
-	if (unlikely(check_mul_overflow(new_n, new_size, &bytes)))
+	if (unlikely(check_mul_overflow(new_n, new_size, &bytes) || (bytes > KMALLOC_MAX_SIZE)))
 		return NULL;
 
 	return krealloc_noprof(p, bytes, flags);
@@ -1013,7 +1013,7 @@ static inline __alloc_size(1, 2) void *kmalloc_array_node_noprof(size_t n, size_
 {
 	size_t bytes;
 
-	if (unlikely(check_mul_overflow(n, size, &bytes)))
+	if (unlikely(check_mul_overflow(n, size, &bytes) || (bytes > KMALLOC_MAX_SIZE)))
 		return NULL;
 	if (__builtin_constant_p(n) && __builtin_constant_p(size))
 		return kmalloc_node_noprof(bytes, flags, node);
@@ -1059,7 +1059,7 @@ kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node)
 {
 	size_t bytes;
 
-	if (unlikely(check_mul_overflow(n, size, &bytes)))
+	if (unlikely(check_mul_overflow(n, size, &bytes) || (bytes > KMALLOC_MAX_SIZE)))
 		return NULL;
 
 	return kvmalloc_node_noprof(bytes, flags, node);
-- 
2.47.3


