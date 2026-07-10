Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC856C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 23:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6BA6B00A4; Fri, 10 Jul 2026 19:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE116B00A6; Fri, 10 Jul 2026 19:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB2A6B00A7; Fri, 10 Jul 2026 19:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8CF6B00A4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:19:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1188C1C8DF7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:19:38 +0000 (UTC)
X-FDA: 84974436036.08.4B0AD72
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5D8401C0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:19:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kRzBIAxX;
	spf=pass (imf21.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783725576;
	b=ocZtrlaCKQHmfjTNhOau7qVTG2jzOF4jTmRE/bvQ763Jfe1zBKGAME8wRSac4DMVdv6GZ+
	eQXdvhcwDP2CDp5J9oiVqR1YAnNihyU/A0ilaSGQho2DEay3mfCnP+Rx9/zkO8Q/hdSr6q
	0bq57omILZCBVDpcZBUZzpaxMjr0FDo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kRzBIAxX;
	spf=pass (imf21.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783725576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mu6H5cxyF3N3ShBbole+6JVO+Fftq+/N3BhrSBcvHHk=;
	b=g5v4c0UQJJdwB8PKWKF/FLqgeVMuGhPEPxPeejEOGCGa2i7IzN4T/vuzZ22uMX8FpX+Wlu
	hzqZ3QcjAqxv4jrzZwyDUrZYDp646emmJJnMfSEEJmqD6S1nNj/j4LIyjXpV9KuJYiDeMR
	SPP8fYEIpanrHMn2fMYWEKnx1REtIIk=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493f140ca8eso8883435e9.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783725575; x=1784330375; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mu6H5cxyF3N3ShBbole+6JVO+Fftq+/N3BhrSBcvHHk=;
        b=kRzBIAxXd4lyRKRsiq/8GeuoRn69guo4psZPfNX6De7n6yA77cgfpWHOg2NxjnR8gl
         yseUzgSnWx3pPNiBYw8UKIPQWvrgW/ZO3gu7zMGBg2Wpn4t141aHOa2QpihTab/zumVD
         hFxKZkDYCiqHuGD6eoFjbpgN5vnP9e1YolN8ODLhdvhF3NtzF/dVUILMmudUh3ei5Aq+
         GTng8H1mD8cxNdAeAsN/SFrn2xHyywh2ZPk+aEdD7TWVHbYLA4f2R/yBJTAfwYuTOLqb
         BbohpOl2EX4o80BZ+wsW1oYs1SALqjVEg0IO/43G+11UYiLzM5npNnfS73ulB7gQ3DJW
         qCLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783725575; x=1784330375;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mu6H5cxyF3N3ShBbole+6JVO+Fftq+/N3BhrSBcvHHk=;
        b=sw/+6ASDMl4R/pKt1I2WD1gh7Ltj8rtsFYvypNvpa0laD/MxvCRxu2vNvvBCj6o5Jl
         438j/lAvf8+Gce1tM684aKyks/Jn40i0hdv1zfFlIJKm5GeuYjN4s64IhCgbmZ1k7qLA
         eDQecyjWjEkoQk1Y8YFHTUjHRdU74hfGRHUK5RlrMpUKwcAIhQJoB4+iYLKz8m8xhjCA
         B4OWC+5IxbXMvQ/fAtRRNXwQ9MNiWXBVPEM//UUs/HsmUZyAL+3zTHfaGiXL7pYkugNL
         /YCDZuQsFKSiUrEvbGLTigXYIq1e6jp0RT8ZW0GPXEc+GBCNTmQtRpCT5n/iE0OAmqOK
         kA6Q==
X-Forwarded-Encrypted: i=1; AHgh+RoYYMM8V2H+WkC2moPdd1BostCSz8V4Jp2sFrFFVlMksvzJCAZLxtPcocVBELRKlc4cdiaYfLiQqg==@kvack.org
X-Gm-Message-State: AOJu0YwymvVwH2eekdEjoY74PZ0odpxuTjfe37Ug32FIzCeVf5R4b6Yg
	Ac59OYqXesaL/VOCMyM+vgLSdzFkqeaOGgYG3PkCN7yVZebI9wyZ9MRz
X-Gm-Gg: AfdE7cliKy/a0ALeZAmqcKpbEV8dRO9yTkz4KIM3MFp9mXOxsPa+tYNBweWCn9Hed0s
	MDfw3QEMNjgCkt7/EdcQOcf2VnUNYqdqnKEgmpdDXkFzELjgdFZev+Rgcs0PzzUoOXtmdcfA1rq
	kqARwP5oXD3p/a1BxVkVYK2A16J17ONICCEpW61NQo6twft5R0PkuNmmG2TKBjjyAadXnfiQBwx
	BTtHAZ2K2VpxaMUnC/lCLO5oX/2lzktZB7oQspymAGsrUGKuz5AKSZ03mTZxFmhIDU+6f4SLrA+
	qoLQWLg+tSz/J8bPGkzHaRvPH+KaPMxR1JhQ5Hrj7yZ9fTc46JgIZ31gPN5XN3OdkCmyNDz2qiw
	T+gDEZlrs1W8R8zDi2/77DSX7Gr/s5Sw+Om2nwEMKb8Tp0L0t8ckxez9oRwrop/hb7dqfWnzSMx
	KpcOYac1kfwr0=
X-Received: by 2002:a05:600c:3b07:b0:493:f807:1a79 with SMTP id 5b1f17b1804b1-493f882b042mr6140015e9.27.1783725574653;
        Fri, 10 Jul 2026 16:19:34 -0700 (PDT)
Received: from user ([197.46.176.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6f3c42sm171727565e9.1.2026.07.10.16.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 16:19:34 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	yahia ahmed <yahia.a.abdrabou@gmail.com>
Subject: [PATCH] mm: truncate: exit on empty batches in truncate_folio_batch_exceptionals()
Date: Sat, 11 Jul 2026 02:19:30 +0300
Message-ID: <20260710231930.93427-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5D8401C0002
X-Stat-Signature: gt9xz8ke7tn5j66e5a1n15jxazongb47
X-HE-Tag: 1783725576-878688
X-HE-Meta: U2FsdGVkX1/HHCqB5t8jiwtKlQiA2BfkYlTo2BSjhOcFvaPNaBQA1aIZa4JsDPF4hRWi7GVaUNzAuXJn2INXVyLgwu3lhJ+j/Nxpqp2Zf25Wjf+wCNOjQVXNjI4rVs3KFmQgimEg9sQU+GdclfbD9NFyzW6sokKH29s8+PXcKQLXnOcCR0m6URt3DNSoTQf7gJ5+gq/iRLF/DxhzEr5zU2f+v0qX2oMKGR2gPAmkvuOYLGqbYYagsQ9ApkepPylI0UkbRlyLDNJEpxzzjzTA61/qDupEtW5Y5OL4JlPI1bXixd72fCCuhytH1py2Y7qumLIqFpD5coT9E3AqCZ5YROTLK+HhPHWO2dyTRqGsj3siC3aeY2e5ue4eSvAZFo4V3xbBlf5xuWomxs5SnOu9Lv6V7SpjlysaDRF/cK/FYNPkZQBGRTNwEATSlJdeKEj/sRNXenCPEHsp4ApmiwXH1RIH8YZqsTZtoxuFe8SJ0n2ruDajnOEELr1sVyaEIZHjgf7KOq0N3fj8w47qVrwyP40BMhZ+qidLMyj0+jZlox228JspzvFvywxuRnfJ8DGaPXaI21hRvQWMhKA0p1lsF1xcSMapeuw+t7+L5muDdqIAvbc/nxrYodOCoQXSINcoEOLoblEr8Rq6iRL3v0+RQVx2WU/5GQbtdKwbg3BCiaYHnb2hU7Ar6valaHAZtG4pyEIgryjIhQ7bfZLIERndk5a3tdrz6zTKCRznmj+bO494tlWE/U1pu3ip/7l2aX5Q3GddKPvPRa+QnDq9ek/SkuUZZBvezwvjbSbDqn74kjC1ZktdV0yCajFSkD4dmU/x4loxwZOZMtTRPci0zTQZXlphPtFKkEgqpR1rH2ykIEqvnL8ltJWm+07j7+Am6V7p6Eb0sunZYp+gCYhNTzVNHcCfMytQMH/ZeMKhkKxpoV2J/M5S8oZWg+31R9RfdwtlqbXU/Cb67IxW8X05jkQ
 OB1qaFvp
 rgA12XgA3iAuy2+cgPg0n6xWr5MOls07Nu6bbTK7Fk5lEgsPDf7wuOAWLSwyYWfsbRAh2ap142ltkIBt7Uu54cmt28eSWyVBHwO4YUVGVDuRhcBIS58XlazFsCTPOppvMT5RDmPmAm2UzbdqP/NelMm6EQOS/7QQyFYVbGvxUzWnmXHbtsyL7PzdhdukemQCtqzk0efIu/E7jbMY6JGs69eRSWClrThRzEMxYhhAqDtorjgBcXBheEnslZmWEvfH8Lhd6FnItoVTxA1UIgog1Nb7f6iQqzzFXvZDQs/nxAN9EyR9sGWcde+qGRKQL+tFVOLVDpD2MzrUR7txXCWPWhlUpIstWd4RAMYstzM3x9OxpXPFNHTEVQ/dm8KjpOIwCO85OYsNnWNsO9blqfzaLFUCfloGVxgLyLoXCZ1OFe6jzBl+9ZMsWRINvMIRS23wyOk7K2UYieBtGX5MFY8ViO14cVHgEdhhTVw0Jabj9YGEek1ccc6nTEQOf71NatJRnA7pKHQWruB3865B1gudowhkONtAcLYkD1SYmxi7MT1M8kvjQOVM8ilNdYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yahia ahmed <yahia.a.abdrabou@gmail.com>

In truncate_folio_batch_exceptionals(), a loop scans for a shadow
entry via xa_is_value(), However, most batches sent contain valid
pages that don't require exceptional truncation.

When a batch is empty (nr <= 0), the loop and the following check
are redundant, adding an early check like if (nr <= 0) allows exiting
the function before executing any loop or redundant if.

In benchmarking, truncating 1000 files went from an initial 0.77
seconds to 0.76 seconds.

Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
---
 mm/truncate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be47..c22803d59bf0 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -69,6 +69,9 @@ static void truncate_folio_batch_exceptionals(struct address_space *mapping,
 	if (shmem_mapping(mapping))
 		return;
 
+	if (likely(nr <= 0))
+		return;
+
 	for (j = 0; j < nr; j++)
 		if (xa_is_value(fbatch->folios[j]))
 			break;
-- 
2.55.0


