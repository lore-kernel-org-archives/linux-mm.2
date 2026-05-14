Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EF37CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609BE6B0098; Thu, 14 May 2026 10:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9BF6B0095; Thu, 14 May 2026 10:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BE56B008C; Thu, 14 May 2026 10:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEE396B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 852251405B0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:21 +0000 (UTC)
X-FDA: 84766207722.17.F840820
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D71EE1C000F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DOccwP0s;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Exn9eDcOjVzqUvSiy20OrE4uwVyBbJlWb3MBX7UN5OQ=;
	b=o5PfJCij9dxiiv6Lvt6ze6/ebSjTEKpqiRiZTXJeLNNmhYdbyr+aYs5sba/Xfw8p7PtRr8
	/BMPfetxGrgCS48ry3Wb140pvXtdjJK2G/MX5SK05TBjlQTJV+zOlf04qWwOoBgABwsiXM
	uSf9Y5NUhc2NjK/xNY5p67OvFobeSAA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DOccwP0s;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767760; a=rsa-sha256;
	cv=none;
	b=68hxMXdgsJ4FZ+pNI+tT7iFSiOltihdHXI11i2VUR1nY23xUEhqLfB1rbLEWAObmOFPP1s
	9soN6iGM9hlXuh59VfCt1TgEKAuH7W+VfsX2rU1AaflYgu7ZmJkC1BZPyP54fPvJfnOMNt
	XCG0BO2+AMg8UIOdCFx7GjiTpVP2Jjg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B74344442A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE96C2BCB8;
	Thu, 14 May 2026 14:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767758;
	bh=Kv/gTWHqRbjarAkUDYzqDqtowKyfqdWveUKMXCNryl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOccwP0sYTpt4oDw5YHGzp8xb1bVZG7v/hzui2Ady2aOV3EyVeVh1S8ZhewNqVuS9
	 ZMKFpuUBFoTNf0TTcS1LdhXgwH0M0BBa5bGkuC1hVgvUbO/pggjnS3rmyy0vaYftBD
	 vhJngYgerbXcN96QCCLZcZIFcnLUyjMDdA46lRQlaav3TlxZ8Fe3FSD436Mo1ds+5O
	 Ji4L2pG0QX2fHvTd4ngCaftExuVhnZDxSSvl8HOeppZZVWVF8nAET3A0/dZvDkXjeu
	 AnYpxIJKznsYh6ondxnyL/W2oGtcxcPgJfK3uAmBrl+bE0rrLVnhGsW8/B+iTDa+bf
	 AQZRphXluoh9Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 01/28] mm/damon/core: introduce struct damon_probe
Date: Thu, 14 May 2026 07:08:34 -0700
Message-ID: <20260514140904.119781-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D71EE1C000F
X-Rspamd-Server: rspam06
X-Stat-Signature: 9umgoz93zezz1x9qrtnkfmyxj7u3egxw
X-HE-Tag: 1778767759-992268
X-HE-Meta: U2FsdGVkX1//NzUDm2dWqRy+MyDWtYANZTwGgdtj9qiVYTtN9JNxZOjIzlIRc/gMFg0qW2ek8DWWgq+DOIcGGselzMi6RggrDqSDxt1bdz317Vq/9qzKteZtv87NdMUhE4U9bwWFPM09df+Tdrb3u+mwHIpr0mZBypBnZNxwDLtogv5lnO/NVdz9ezlK0mNOJPeN3Xxg6dOGl3u32WgdN6iLu+cNkk3Zx6GcmxQ4mfoZXWPZuRLPvQ9zk6eGpZlMAfG4+XIwakLTIvxsBnA0//zhy8y/uzy0ReohGv7x6//3nPbv29s6IK+WdfxFHKnythWYe8ssgDkZVSMxq8GWyTB0U2/6fNrYdhhZu3Jp5Wl1xzZO9PODlukRUNnCz5cVn5tyTLnrrU2bK1DmNCwhxHJGeY9l7Hde8sK+xvdkh/BqizAMviuR/I0we+AW6HNh2fjdpjeJGGXuGEqNUljm3tUuYJU0IIKjIEWJc/3/wvpKcnouWZjz1ShacWTJwRyv0di1c8sV7xQOls6veVI+LZCuArkxtFRwB5O867sPInSo2gcEUl/QkKX4m/jrgdAgZ4wes5CpefEeXvxkWf5GvbWREmB9QnNjMfc9mn5RKiyN5MKHyyUv3VoHX0BnbSfLej/UpzQbe4y7bD/PZWJFIiRaAAeRxx4tEOyhjEkCJDVnR49klRClBViraNuMcD45i4GZBhyVEET49+0pzhZ+lfLLXXv1XWbWFZ5GaIK1JH+sPgWW7SVFV1L7BWZkIwOMgpHWsgkAZmuVxyvY39ugrkPDZ51rYVpiRynhx7uiIS5NCm2hNrPYiGY39OQapn4X0cBF+i82aAZQED0EeoMfPrF0Ne2G5N+MWuN/teRn+jotGW7yaJE4bD7+neQWDrfB2RHJG95At0blqHOkqxG1I/uU5SGwSzgthbRCrc8P//2zDvJ/AA5yKoHGJ46VOgd6QcdLY8zTrVWOLIEdB15
 2dyvKsDo
 I+Cb89bhWKmNQrdLCFwKlYIro7/g4ijO4uNxmgKfQ6u3vc0V3C3Q0ASvbOEEo8ccjz4HiBEBClZS6sFnniY5ZNLM5enJtgnlX+00z9Rlj4m9FeAdhyUE2aF4tOVwQ4h5KW9r8ZE2NdwWPiWFiXcaPKcGbwOrq3/Sml5z5oqaqqhcqzWw+TwouHqrW3DXeXK3PW6xXXVp7gaoBkBdWMTOJ8Xf783QCBlx3OqrQMEj3fV2768JRdazkvdFXlM9jh31TcMpjgUeFowlRbId/5jUVMDBTmc2LFz+tvefnrY3qenNE4nZdq1CzcnFCkBgz4rTX0JjtnRZEBVEwzsLtMT8OAXQQPy/ofa125jeXbDZwT8qdHYeWvRqSuxiQy7dPcka5Lmnz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a data structure for data attribute probe.  It is just a
linked list header at this step.  It will be extended in a way that it
can determine if a given memory has a specific data attribute.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4d4f031bcb453..4794931fa2ea3 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -730,6 +730,15 @@ struct damon_intervals_goal {
 	unsigned long max_sample_us;
 };
 
+/**
+ * struct damon_probe - Data region attribute probe.
+ *
+ * @list:	Siblings list.
+ */
+struct damon_probe {
+	struct list_head list;
+};
+
 /**
  * struct damon_attrs - Monitoring attributes for accuracy/overhead control.
  *
-- 
2.47.3

