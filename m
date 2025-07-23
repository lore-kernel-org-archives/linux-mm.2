Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8400C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8789C6B00A0; Wed, 23 Jul 2025 06:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DA276B009E; Wed, 23 Jul 2025 06:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653966B00A1; Wed, 23 Jul 2025 06:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A17E6B009E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:19:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E523CC062A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:19:43 +0000 (UTC)
X-FDA: 83695133046.09.353A393
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 885C940003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:19:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=EEwBwJhz;
	spf=pass (imf04.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753265982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kq4/IE5TxPSa3+Zo+mp95KpeFojZt3lfQEaMXcQST4c=;
	b=Exd8IGOIVxLvOxelng6DvmSyBNQ2Krd2BedPPdvoWePBR9EgT3S9SQNVw8Rr2fAhCsSosZ
	+wffmytXjqKxBEkwD+GtP7bJ+cPc6qBQP/8kcgyT0qpZoubs0UN8jlhW+X1lKPfzP+LEK5
	eXBHGO10t01rzy8/7ufrSOSks/X0M+w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=EEwBwJhz;
	spf=pass (imf04.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753265982; a=rsa-sha256;
	cv=none;
	b=jZbLlJhplcuYZjKvDgcFIcAN8qwk2xg8rFbRO8McGLBPBP5FOI49k3Q5czbct6xfAyki1V
	Uoz9Ivm/2gqDcSoymJn3gv3R+qrvnsG0cdDwdbt2TS70UexylxcJ72IKBKIMeKgP1eW7zs
	FeRxjePIMtHoHdbJKgA+pbqYNi8mkFI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=kq
	4/IE5TxPSa3+Zo+mp95KpeFojZt3lfQEaMXcQST4c=; b=EEwBwJhzi6cOySsl8y
	Vmat0Ph57DWpeiV6hLeNR0Yser4O3qQH2be8w1Hn6a5Z+oKvX9YwuCNbaBIk9A+n
	GkNulyH6+leqToZ4fT8SSoXAqCgT/y5yRA12crDl+mfWyv9nUAdgE1l24jOV2qsZ
	aEN0BJqDM+Op0U1LDvIPzBpt0=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDXpNEAt4BoaJF8HA--.11729S3;
	Wed, 23 Jul 2025 18:18:41 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: akpm@linux-foundation.org,
	willy@infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [RFC PATCH 1/3] mm/filemap: Do not use is_partially_uptodate for entire folio
Date: Wed, 23 Jul 2025 18:18:23 +0800
Message-ID: <20250723101825.607184-2-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250723101825.607184-1-chizhiling@163.com>
References: <20250723101825.607184-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXpNEAt4BoaJF8HA--.11729S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF4kur4rWr1xCr4xArWUArb_yoWkXwc_Wr
	Z7Zw48W343GFWxArW0yFW7Jryqq348CrZYvasFqF13A34UC397XryqyFykWrs5G3yIkFZ8
	JrZIgryfZry3WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8u6wJUUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiFBWTnWiAtsIFNQABsi
X-Rspam-User: 
X-Rspamd-Queue-Id: 885C940003
X-Rspamd-Server: rspam06
X-Stat-Signature: xffy7rjqyxr6mxmrhzenqbt9pckdp4x5
X-HE-Tag: 1753265981-479642
X-HE-Meta: U2FsdGVkX1+CsEJN5h5bj4WJi36IodcUBDR0Bhj0l3L0y5vsBSrnoE23SeznrFszw6N6sYKmSMpxFY4GiVtJUsSsVQmBaJrqWtC0DSv0l90T45dJRk1rwE+w4/v7JkGxv0qI9AXNv7VHEjahDmAQ/VRzg/eoeGZZLgm/7NMShV1fz638sZS87I1xDmr2n2ogYa2C+epqYkQKJzxLWjCS7Tm+hmuqR0M8kjzvvUfKkbH7dsb7EI6GhgGgodIYpXZeFdkIBRVy8YFCeeMW5c+fEsKI6uyErZORrEIHYhG5jdm6sRYEz9sRCYDKyegfQcrP9wUcozKnWo2AWDEzY6pfPCjfEG6ADOjdVvekrRS9UmF+coatP7QUWGMWWmNEtHQ/Ma4NSJmuepExf148rFYb33tMGqhY3gpdbfRrD1WrKQ4OM9oRAqkhgK8umGI6dYG/eFTsQInFo0x+nFMHSypdNzm0dtoF3b/jpZ3LRswVcwJc1QkmW/RQXj5vwI6B7rJcvHAqkWxAEQAFy7aNMXfEe4oGsqpZabiA8RBV9kM36N99XF2e9viM3RtEO+gJbDZfcJD0wPgEx7OMW4/pdnUWETgUhnuN+CeIKHZKftqPRj0lA4l+B3Z+I3BP7GL6BNX8wzUcdx8nY4ILYnYd8nyy8n54Bgg9GZApiA/EAXDipYl8/w7kxWmqB6nYxuXefAQP/uXAlGDEzx3MnlrqHI6uQKcV61jrH+Cf79k8Czoyo44XrCIm11BDdTKbcLBCDJKghFDaJMvxHD6sX6RN0UArHOzfIJMMuNmaxY2O7wWy+ckYTvnLKfrulDxuUtAw6Wou4euUXRqHII1MW3RSsaQB8hW5XNxQlBbiN0BfpvEpqiHbAy78Ev2nIRngQAavT8KQ/I814q+upUCOq+FWKrE08nnkHFgkKkUWNFyJzGUyuRh3+ORCaee9ZPbx+K08ZzCI54JuhY3nbqtV6OgNBZA
 OjgievNO
 B7QkaUudHp/koiyTSlihijTPdZypfW+upoK9XLO26532dPQ3AO06Iz3OO7bF2o5IAgrdxXKEXTvrF0/QY7rseKFRpE7aBNJMCKmX5mg89Ekg/biiyIMO4fx7lcFZnpg/+sFRAQ5c7dpnX8uhHtUWzr6Xe+/sZNk5ng6lirGTjTeWr0qmkhpHxtzsAn5CoGi0YbWu2GCGGxCkOXsN3H3Kxv/DiCb145Dj8zkqeKhPdjP9O1WHHQyvyQDGmetJDhPlPREfBhPBzLgsXesIoxh/TX+ArVcUrbr0X+1w78WCCrKx2sUnkfl6dNDz22W76Y4ZTqLwOlw6XrBme5FDaFdKRckdBWCsS9aOCZNkr3oErl/f7xOIVLNWgfIS00compNlEqNx3BhBlHaLFiBrhHAIqKYe4SofUBtOIZq2sxXH/BuszD10sEZ+D7UletA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

When reading the entire folio, we should not use is_partially_uptodate()
to determine if the folio is up-to-date. If the folio is not marked as
uptodate, then it is not safe to treat the entire folio as up-to-date,
even if the partial check returns true.

If all data in a folio is actually up-to-date but the folio lacks the
uptodate flag, this could cause issues during pipe reads

This change adds a condition to skip the partial check for the entire folio
case, ensuring that we only consider a folio as up-to-date for the entire
range if it is marked as uptodate.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/filemap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index bada249b9fb7..af12d1cecc7d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2446,6 +2446,9 @@ static bool filemap_range_uptodate(struct address_space *mapping,
 		pos -= folio_pos(folio);
 	}
 
+	if (pos == 0 && count >= folio_size(folio))
+		return false;
+
 	return mapping->a_ops->is_partially_uptodate(folio, pos, count);
 }
 
-- 
2.43.0


