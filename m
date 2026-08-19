Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3934DC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 06:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36CCA6B008A; Wed, 19 Aug 2026 02:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320086B00A0; Wed, 19 Aug 2026 02:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25A666B008C; Wed, 19 Aug 2026 02:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 036146B00A0
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:57:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BF58A046A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:57:25 +0000 (UTC)
X-FDA: 85117112850.24.7E5B67F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3AEF34000A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:57:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=f3H1WtXX;
	spf=none (imf04.hostedemail.com: domain of BATV+4a1be12ea4fa2434960b+8396+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a1be12ea4fa2434960b+8396+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787122642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Q0IdqFnVkqkF5q9pk5IoXLZATdgqmwUq+XC4q3t22bs=;
	b=nv4BNqBWVMgiWPUmhUZTiV4FnRt2JJd/uhFYmlpbod/3NJ6ddCvwWMNStrC7mgRXe8B78e
	GhbGqx/M2aNDuWJ/Mue72EXReHFHsxNq8I88c0/fLT+nPRcZhShtziP/nkJNzUju3JpFpA
	e3NFYX8etLQ6wJxIPLP4LXAqKCm1ZQ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787122642;
	b=r0EKwxzwPNvneZKpZtjSuQ91lwhhmKwkUfJG0DcN+6OfjykqX2BHXXEL2xcXrSKu9rRzTm
	5II+9MEXlK+LGCUDca8Qo1Yj+1r8Umabll+kqeKLnhRs4CFuB5mHWdENcVzMuyWs7C7co2
	sIbyJIywV2xR4PMuJN1egygbCpVfzUI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=f3H1WtXX;
	spf=none (imf04.hostedemail.com: domain of BATV+4a1be12ea4fa2434960b+8396+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a1be12ea4fa2434960b+8396+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Q0IdqFnVkqkF5q9pk5IoXLZATdgqmwUq+XC4q3t22bs=; b=f3H1WtXXpW3AKBooPYiQgk+IWC
	SO8y8uXhKiPyf/6BN28IuNcQJ9yBfHrNh0nx09zpU7JuOCuhTfBp9iQUPSIKNDxQuQHfBXiHrt/u+
	0YB584pQNd0b3FAWIctBx+iVjmx+jAz7m7iqhkPz5CZxEB5I3OhC/fdl0hjRg5c5A5ZYH5H95kw6b
	JXPUG7YoN4qdrQZFmJydSjB9ZyrqsE70Eh/JQY1ttyAPCcdYsY0C8w79qPtLjVyMK0T4h6YNUKFzE
	mCp8Dpvrsn3WzypJSqFxBr3TkRuKPTYILZUTiXRdjtNTUcGEtjwOQvEUDJvsoDXrUVzbTtaeInYJD
	4R8WdgUw==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwaEg-000000098qY-2lF7;
	Wed, 19 Aug 2026 06:57:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: willy@infradead.org,
	corbet@lwn.net
Cc: skhan@linuxfoundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Subject: [PATCH] XArray: document that tags persist after storing new elements
Date: Wed, 19 Aug 2026 08:57:14 +0200
Message-ID: <20260819065714.1358822-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: jdhj58bbdd1mwt3m71zoctx5uzf9fopn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3AEF34000A
X-HE-Tag: 1787122642-207920
X-HE-Meta: U2FsdGVkX1+KSdhxhyQLzNc8UNF/BZEDORxmZ7r16qtMrbZQ41TjWzsM1Au11BJv/nP9lgf1hITGhwG8WScy4rM/3jM/GgElaSI+punv4jduEslSynNqdOVfaPmzefOvPY5DjPr3EIApb1H/WfSXgPQT7asVScNy3C8qq1CjffVszM/ey6B5HT9vzAyoaNGEAaupc+AsS/4Gj6PZSqMgqnYv8U6n7KLVU5vKe/xLcjtFYp/O7O9kUDWz6yofiht3feC/Fc3MT16ZNziucLOreD5ejMjdMq22g8WgEgC8ZAxcXstS3hBXBIAxOoNX+wXp0PcvixUgbdr3AlJ6Gat5lf0fXOFBqFY9FJNFlL0EHheZtY5JMkZVW5y2UO4mHZwYDxJKfK11KvhAB/KA4TVF3O3osyh8f4W0/36RoZAA4ribhyrbqUN6KishD8lYmlpZCjobTkdcH1O270QefIk0DpUReqPS1LvzQe+a/BvCxo46lZJxXKu672HoUmJlUNdkZ5HJAYk+GEqspjBUacjy5lFJAV2xJGvC7Is30/+I00a8pvXLLYlHTZMNO2Myq+xLDNmajTLJdcpcwk7vVldH81HcwObwW9+8Kul3UQSJbs8AwOW9rObc0WKcOHdbKV4Ls8G5Yo0gdtAWcEX1hJwtiCKyDfxpQurjqLpZUK8C3oainuEIgG7ayzb7LyYh2TndEuZx5cYUJ47V/VCJEDdN/ou0MO4LfmD7gedNBjizP+znIPl2E7o1wRHXw+lkJJ8XDzL/0ArN6ueFsyGC9aGYXhbyIAD7pJpyxLg0lYk7fcsAk9NOKo/cF1P7MsWecuziP7bQLafte90YA8vk0yqRDdJfpg3/h/EBemo5wm2OvQclIS7fuxEcDE5QPS329ovA+oqoSHIzqE4Rhq9KAVHjI3h2gKbq6IfBcN6usna1L0QTQqwXT81C/rLbMSQirLWB+ekTfS0R3kCOJn+m6uF
 Nqj4Gu+j
 dTOoaqwace5I7O4Z7PCWuSore6cp66bVM2ax53I/0V/50wU99HygMP6Ly7UeFlb2YeyS6yCfTJybkZ/7HTjs+WUoLjyb3zkucVPIZiyUDeuf0Rsiu3hDEVbP+TnvkJ0nkhk//zlffYwwkoNFTBrdJ9uV+4ZoFXRCMimqkGJYzrrKLEZ54+JNki3a1gc/dLh1ZXsggMPISzxI7U/HDxu8yfu4Bn86Uk+zpvTZEEGwURVYBKaZgwKTMgvc4SebXuXoJD9TT7BObYI0PC2+SNkE9Fqrm8qtqrRdIx3jaRlsXr8Q3FgTQYjLgMSEAp103x7DL2WiR34Y0hEn2DBYbno9x4KWHGzaXNhJl9ZgzE2R2CFoDihC14t99tLLx6uroGh5AV81MGPZzN/5oUnm81T+TPLzpw21WwFsV2IZWPhTePCNfXcvNYdy0FePRAvZIMAhiyeWJmUE90YB0nKG3kpM2riZjP3twN8I/qOWfyBpe9pmCLvrlFy6gvLw3j8qCRbi1d29pQKmqKQFzpQdorOHpv6Lf/tfkNh5A5yP1j4oP4Hf3tZGn9ZS0SRQ4Bjq5jY3jEhH/sA6E8BpQTho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a very useful feature, document it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/core-api/xarray.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/core-api/xarray.rst b/Documentation/core-api/xarray.rst
index c6c91cbd0c3c..9a0d930a8c79 100644
--- a/Documentation/core-api/xarray.rst
+++ b/Documentation/core-api/xarray.rst
@@ -127,6 +127,8 @@ by using xa_set_mark() and remove the mark from an entry by calling
 xa_clear_mark().  You can ask whether any entry in the XArray has a
 particular mark set by calling xa_marked().  Erasing an entry from the
 XArray causes all marks associated with that entry to be cleared.
+Storing a new entry that replaces an existing entry keeps the marks
+associated with the index intact.
 
 Setting or clearing a mark on any index of a multi-index entry will
 affect all indices covered by that entry.  Querying the mark on any
-- 
2.53.0


