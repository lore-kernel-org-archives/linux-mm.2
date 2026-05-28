Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADBDCCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 17:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 920976B008A; Thu, 28 May 2026 13:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9AF6B008C; Thu, 28 May 2026 13:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 575AC6B0092; Thu, 28 May 2026 13:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 473466B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:59:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FE451C219A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:59:14 +0000 (UTC)
X-FDA: 84817590228.08.12BC9F5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 96E5BA0006
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:59:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FYkUfT7g;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779991152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGVmzaNcu/49E2fMbgScKw5kBNsfavLbAhlmVlLSNus=;
	b=La1Fmwt9dtzXzQ8hldYdKaCHNJnFevf5VMhvFI6GM5Af6EP/GGmzYN2hkTtKVp8d/Skixu
	RQlHUXCWR/gDmxIi7dkV4iivZv9XtJr8bAL6GBqkJN61GpU+vnarcicWdH0nDuEgFbvTUt
	TVXmDHt/QPlpRiHI/RqDMvSLq4m4z94=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FYkUfT7g;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779991152; a=rsa-sha256;
	cv=none;
	b=1WItWPY0n1EA37zXtuWG4UCF//BJYmdGwhFy3O3K3rJ3b/QhUqmFLVShCI82J4JmI3pxCW
	Q8Q1+ORF9XC4WYtoJ50ZPTMAePPBoiuhMK6LVVQj0Xsm38yw0Ls15QYdf4u2f0fPevxxMH
	hdnPNzTNUeNsl5ugPr6HDlYmMRcVztU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=EGVmzaNcu/49E2fMbgScKw5kBNsfavLbAhlmVlLSNus=; b=FYkUfT7g4UMygsRy00AFaFX47s
	kjEQozDyEE80XVE63jF3gPUMIHTC/IJYHb9NkibfKWXnGXdHHCyDOGrJXjaOtTHtFWY6pR3foOPdn
	3PP/4eEbtWxBZqtRXs8JRP5jzg6YnLf50adQ11TjweGHEbwbAX1NogA6502huvXX/OtuCKOFWEyjr
	i3gdFQtlXf4WkiYlKaae0B+J8CL0lqITx3OQ6LJepVLv5sJjEhV8VkqWyweHUslKDAtNMhkAkyOEe
	XmNphA6bjaJPlXirk5sCqqWhFyqWXVpjl5iDRtAbuhvGaR5RN+L96WdJuwJeBRwZc4EWqIX/+PIRf
	U5AcLsiw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSf0d-00000004cld-2uYw;
	Thu, 28 May 2026 17:59:07 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-mm@kvack.org,
	Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 2/2] block: Include bvec.h kernel-doc in the htmldocs
Date: Thu, 28 May 2026 18:59:04 +0100
Message-ID: <20260528175905.1102280-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528175905.1102280-1-willy@infradead.org>
References: <20260528175905.1102280-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9gkuq8pg7h3q8po6xmco4zqdq5abn735
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 96E5BA0006
X-HE-Tag: 1779991152-669922
X-HE-Meta: U2FsdGVkX1+FVZ2UtjUWGUzf33Wlr6FzY8QcXjyQbTe0lRrNYy2CdRydH+VoJTBIY8G2abRpzx6fq4cxTOK7t25W5PdZ46bz+QhwEKYhGaW9ASJgynyh/tFGGav4BhP0TOyEesMtsmS9JTVO0ZFUYaR1WnFoilCE7HUdTbC6t7VVZ215mp8wlxRnWl5NSn2MehZBCF2Y4YMqxYdetROuhcx1mzXi6Jxh6GjpdTcGKpH/Phh1Y0sFcd0iI15vD5eimgU9yT4HvGOiFqA0ERr0ryML0pNkaRrFmt8phYgfkRKhe22pBnhbUFMZwzXva4QgDsaaxrqztp5T9LNj4LgJ/DJB+ESgIC3AoKoVZYGKeblZLN1zzh+V6e5qjjev9AdU1Xz1WRXvJBY5WxKwEg/appeAf37G5ZzFMxv9fbDmP6dJcYnCIjj63/5LkTpfS9V/r3pNEn+8J2sau/XHXeKkqjwjSWe7/2do/8n7kEy3NZVeUtSQQWNZApbHeiB42+zmROT3K8oafEl2bKo9Bmq5eVpm/0rGGfzdjjI/T7LwyR02vw/lLwzPfWTlpCPa6vy/YjCBUI8tHUJ/LR3ZLvUsiExJTWurYaTVB4+IlU+ncbAZNF5e2TcvlBb8B7mD9JEuIN1WXKboM8KwizSAmQWAXzBZ2DKvkvEcKEu9wFNExhdQLSUTXABI1IuEoOKgX7q8yrkFkDYDI7wRp4Pn2RrTC6Wv/ExuvK/aaLwnnyebSy551BAhxsAcOwPbESyCyh1ZjjbSI8k5NR37Vp/9Bom8M0R8p2qqGVA6idmV2WXs7B8Efa8ev4H55h9pHEaUHDh33yo0z/T+WhauhRRc/PwPCfl4ob+lU01oysWnSpxYFbCZuqrugsLVe0oLDlpr5XrR3rwM/HZyvFXIYYDb78t0FJ26e+FEotUDSGkrN2mkZiqGZHpRHXmFw7UsSVJWx8YsagyTWssB4voW3ATdHc5
 yCyFCLjF
 iNLdJPQ8WsZzadztYrHhrS1AmKUk2MctegRNhxG7oXInFvQwcHvBwUtaHiTtCfOJWKdRpwuUUQo/bOF4j81Zv7I4HfxGbnT++bxEk14U0EpCSgeP4AzYgfRMAXMmypY46yxCoGIv/cvcC4DWSW6dYT7uU9O+PkQPS3W2iHtTW+FYpWn7CCTRpTX9K5XsDXypGN7lil/mZZ5EfTxCqp/dAawBUeiWufv5AzbkRjIlgFqvwdZc1BhgmB2S/9oXdKPRBnCnOqE36odswMoe9k3Gi9bK+qE1ZylXD3rWiExXcAmYLKhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

People have gone to the trouble of writing this kernel-doc; the
least we can do is publish it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 Documentation/core-api/kernel-api.rst | 1 +
 include/linux/bvec.h                  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/Documentation/core-api/kernel-api.rst b/Documentation/core-api/kernel-api.rst
index e8211c4ca662..4c4a57c1c094 100644
--- a/Documentation/core-api/kernel-api.rst
+++ b/Documentation/core-api/kernel-api.rst
@@ -307,6 +307,7 @@ Accounting Framework
 Block Devices
 =============
 
+.. kernel-doc:: include/linux/bvec.h
 .. kernel-doc:: include/linux/bio.h
 .. kernel-doc:: block/blk-core.c
    :export:
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 27ac3fcc6d9e..09d6bb76919e 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -262,6 +262,7 @@ static inline void *bvec_kmap_local(struct bio_vec *bvec)
 
 /**
  * memcpy_from_bvec - copy data from a bvec
+ * @to: Kernel virtual address to copy to.
  * @bvec: bvec to copy from
  *
  * Must be called on single-page bvecs only.
@@ -274,6 +275,7 @@ static inline void memcpy_from_bvec(char *to, struct bio_vec *bvec)
 /**
  * memcpy_to_bvec - copy data to a bvec
  * @bvec: bvec to copy to
+ * @from: Kernel virtual address to copy from.
  *
  * Must be called on single-page bvecs only.
  */
-- 
2.47.3


