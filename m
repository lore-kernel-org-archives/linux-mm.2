Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D6E4CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416916B0005; Wed, 13 May 2026 04:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6E76B008A; Wed, 13 May 2026 04:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DC646B008C; Wed, 13 May 2026 04:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED956B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:14:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A57831C066C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:14:25 +0000 (UTC)
X-FDA: 84761684490.10.2EE12CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 13651C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:14:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oqc59cAF;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778660064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oVR8dlcZ98uAw8dgLb9p35AHWzqTeyn3tYfZlPdh/sg=;
	b=kZBnd/5wpWYa6LFYRGuHLOvsfGx+AXfTqs1cEu29dWYW7gKt0lTaH/nyoO6zYrrcca6QgQ
	TqAWi+3ggF6THiYPNAi4BoKALfNToyDCUyzQSOkyDdOH4StAQz9VGYSui0PaANUvRhQrJq
	MUSGWEGMjiXexKIDBCPP1qCguxUl4Ls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778660064; a=rsa-sha256;
	cv=none;
	b=XvPQikN/wulMZvMJlGfLLqP6fSiJ1Rx7GtBdimU8v8IVUgGGBD3XZkO/3o5SGQH0g9ssp+
	HTiegF21PDIQrj5tOQOtdcxlHsdNJwCRnqjtA8u3YvwIdb/nWJ4KDAse83lGyYmKs7V+/3
	H7KYVu4Q8HXUug70CuvzbziBiS4Fiys=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oqc59cAF;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC20E43EAA;
	Wed, 13 May 2026 08:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238ADC2BCB7;
	Wed, 13 May 2026 08:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778660062;
	bh=pVV7p4dwIXvhzhLjg15L3+KRM6594W3MEBe+1QHdnfs=;
	h=From:To:Cc:Subject:Date:From;
	b=oqc59cAFWA0BQIKWBd4gFd70hBIS4FbmhNukCawgnh+cIfqDO9T/tz1hQlrGAWELS
	 KclpsEY6Ltdzc06eHacFfL6EH8cr4QeaL3oSIElfd0gqPc+23nWZwepEWzA8MYpBSb
	 9JW/V8Bqvv6rE7Tc81t94kZDdIYLUwLnWS1VSj+8qZdm/wUW6ok9zWotiGhlbV2Usl
	 K52GFwYhiBM84yIPKnRRrkeP+/kl0l4w7cgtERwKUSYN1RYIspYnwo9TP4NbAO39hj
	 SPuIOR1PR+/cEwOK1ltcNptLb2O9r3qL14/HIdrt78Xt+oIlFQ+RctnsvaEad7SoSn
	 RuL0ufYtraX9Q==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] userfaultfd: ensure mremap_userfaultfd_fail() releases mmap_changing
Date: Wed, 13 May 2026 11:14:16 +0300
Message-ID: <20260513081416.495963-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 13651C0005
X-Rspam-User: 
X-Stat-Signature: w1d1iyrmruzg6c4hxfhgndhprin4qjpq
X-HE-Tag: 1778660063-352366
X-HE-Meta: U2FsdGVkX18y6RSEZQi/8G0pDO1EoPfBjSsqu6ZpE/RwMqwEm0JIpcinjMW++MM9UjMqklnKJIQIRugk9lRFfnz756fXVYhvz+4WTNSAcJoHnbb1C4hnVbqTBrLnAPKIT9re0FFNjhcQct/mSiY221MbabQVw+JAwZVXa0o88IE4h2IX9ElM0wbbqpMqQQhfmpo2IHkvazBhRF24XO90X3YZGHftsS+aCehbtOkpr+SpK5SWsRyd86mNpeGc1aRchE+qjCQfBYiyiE+OxFzy3CxIVzXMGnF3Ogqx1OLQzEzP5Eh2OTrL7GaxuNshCllWt+7bt1ZGWI/sqmHO6tlTPVMA9i1PVtyORjA1kev/Jxt144mbt3V88rxFihMaV+7o8JojC+ZZbdtafyeCX3wxX5zd+1XJjf6pWoY9S/45JwCJhBzUjAgpf2QpED2kxyCfagCRreP1u79lt9Qma9IRICobw4tQ6mpS48yRyxyLFHXkNoWknMmu5lc5lFGvacu2QejaDekPmkEegig6ihlr4vkYV2Q/jP8ZF/1aBrfvNABjBN1vv+yc5KqJ+vhtstbNEeL+UKYXUHPnuAVGebs1W3fKribQRPNigkGmNpBGnmkLwFR07WZrunZhZQIsS4BmZdHJVzQDSiD1kD3iup7yuTFmP3F3pJLvnEuS7HAlU3UqOvma9ASq5GFGdpTLl3Ri71g5SOksDu18LmEA38wMW5lFeRG3Vlv4GCCXWDnBw9jt954Vnvi/6hiFguPVqt4nCSSBKi+9nqQZE1y7GnVrbSpOzoHEL82XaaGudLl6Lb62zabLBCRNiKdctLa8Yp3FQYHHRPi2/rZD9CxjYpsZ0uYVxQ5f9i/I/Rvi9rtNxYHtUj5Wmiaak4t0J598ZVgyRdlb1Jmo8TLI8oG8+a/7a698AhFYmMByURrEqYuBzRcldNeNRbnuCqj5uGYilfCMZkdExsLuQy8TYeDKv+Q
 0JMjbEnh
 L18pAnf5sbRFfKObT8MIK/vlJoKUKGc9QUUn+qIIqD0bQnRJcr65YPYzNc+ebXFe+vzQUeXpLm9MseAhiUkQR/mSDoi4wyFZ6f3l3CsPrcrrhUr6+9DVJlUrWYCr9EcgUZHZjAiMSSuxGhWtY1FJuoBVXW5x3paFrkBjKwn/66+mmoUWrTK2atQp8hGY/VY1dcqDf8sDfvx+s78yOWURziH/o/WudsmgC85srXjoUAQycwt3Hf3cclC084+eTlwcj7uy7NvknysmuuSJ3K9VyzBtZWQjwZw+ky2gV7zaMV8HVodPLfPwtvzromY6EZyZ7FvodXrgdPiGTjU5FH6LCHusclA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Sashiko says:

  mremap_userfaultfd_prep() increments ctx->mmap_changing to stall
  concurrent operations, but mremap_userfaultfd_fail() does not
  decrement it before dropping the context reference.

If an mremap operation fails, ctx->mmap_changing remains elevated. This
will causes subsequent userfaultfd operations like a UFFDIO_COPY to fail
with -EAGAIN.

Decrement ctx->mmap_changing in mremap_userfaultfd_fail().

Link: https://sashiko.dev/#/patchset/20260430113512.115938-1-rppt@kernel.org
Fixes: df2cc96e7701 ("userfaultfd: prevent non-cooperative events vs mcopy_atomic races")
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---

I split the fix from the code movement series, will be easier to
everyone :)

v2 changes:
* VM_WARN() if mmap_changing is going negative

v1: https://lore.kernel.org/all/20260501145433.156211-1-rppt@kernel.org
(patch 1/3)

 fs/userfaultfd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 4b53dc4a3266..390e4b7d9cb9 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -786,6 +786,8 @@ void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *vm_ctx)
 	if (!ctx)
 		return;
 
+	atomic_dec(&ctx->mmap_changing);
+	VM_WARN_ON_ONCE(atomic_read(&ctx->mmap_changing) < 0);
 	userfaultfd_ctx_put(ctx);
 }
 

base-commit: 972c53e0ec3abfc6f5fe2cb503640710fb23cf95
-- 
2.53.0


