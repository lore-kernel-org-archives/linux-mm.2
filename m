Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F12110AB822
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 21:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975D06B0089; Thu, 26 Mar 2026 17:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926B16B008A; Thu, 26 Mar 2026 17:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815C86B008C; Thu, 26 Mar 2026 17:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 711526B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:52:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05F03160AF3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:52:28 +0000 (UTC)
X-FDA: 84589563576.18.057864F
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 233A44000D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:52:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IKHeCsvk;
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IKHeCsvk;
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774561946; a=rsa-sha256;
	cv=none;
	b=hq+f/fPnLIEF57LGPf5ikCok+KIX3z29JROFqi3b0A1xNCnzeNuuS98o9fW+AVZNPKLpkd
	hmChyfOeJLo8VWeBkCOCBELpvKBm7h89Rzfw8jSdFo3Nxn8bE2alXcv2unzQIx6rN6YZvZ
	psTA1KIFauaKr+7mcLrd5NnWV3foBKA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774561946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yEEQm0TpXR/MnKCD8+SMXgQ9B5RQcWrE+GNArOaCAS4=;
	b=DUbhmyd5KUP0Y2RLjJR5bOQDksdxdXcvD7IFE8J6RVtwgYrG7OrvRBIfp9fqwI1Je3WyBF
	QAqH7VzXowTBcMOChwkjgEevojfMX3lEN+Pbgm5t2svq2+TjYbUjwsGng4QWOt0VE8k22u
	xCjvi7zxSXHZXCjJlki20NRljVgxkqg=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82985f42664so901034b3a.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774561945; x=1775166745; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEEQm0TpXR/MnKCD8+SMXgQ9B5RQcWrE+GNArOaCAS4=;
        b=IKHeCsvkeBOGV9hXHafeS6xymMkQq/g8gcB+2NCA2DbZbMzn7Z75997No6ANv62BNz
         WGrZSJX1OeOAF7F0z6ZQDG4vcSYj75VijqPlBEHsEf7trDiMGHnG73vEAR8DIeWeSED9
         1yNKWAyo3FFGT9Ik0qoKQ4SuKC7VWmPe5etKXMVyXxbKmv5IvkVYuCr7BIPCUA7oIG0d
         bqTRDu6YVkx2VVA132Ze0ZBfq2zPw0t8/cG+BkT5ehMMMMH8A4MQQHkUmRSUF0hE9gTV
         4kRTiBYRQlZMQ8eU8LlRpY6mdXpiCgve4rOT0zwYY3AJ1COUm3SlD8m0v5sLooJVIh9g
         fBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774561945; x=1775166745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yEEQm0TpXR/MnKCD8+SMXgQ9B5RQcWrE+GNArOaCAS4=;
        b=o+0vX49J0iTqoFHemavpr0CdAENaV9Y7/c6a6D9XPdONUffxuz7+UNdBRRNDwkxOHA
         XfwrcuWVpGrkSC2LUnyx+NqCz6vnPvbfiivM65mZgZ7TPp8hDVU+yba+3LcLfYQiVyON
         z31KBklriiD1qMV02FOQ8JxWoOvAEWFZqA+myLGL/BJmSKQVKYzvriPNbVAV/3DHsLvV
         GJoppOsP6IOpVzXSY3yf/Vhb8ddpzB2s9ref3zLIJSjxHKlLbmT1czl7Xtq7bDJ1wMD3
         NU9OfOmlBWsAM7kg9WfWdq4yUi/VBEbM/mhFqxf+MSqS9JdXiCZBwtrpBQdfQ76C1bVf
         i1Ug==
X-Forwarded-Encrypted: i=1; AJvYcCUbjTE/CT7TH40+rnO6srHf6MgLio5HCNb6X5X01nPjhgZ3KA6R4jXrCU8XVPljczeScy6KqE9hhA==@kvack.org
X-Gm-Message-State: AOJu0Yxo0NKEs7R1A+A8VERsrZimTWQuooX8rpbdwvebj01jcmVtZCiu
	GmqFAF/+oLII4IIeNDAz4qffz9p0k89wVMda8eUnRjis6/8Con/wHzYL
X-Gm-Gg: ATEYQzxoV1QQ/X2/oOrwpqyj/+fI39N72VpsfNM0XeMYnFOx4xBB+Z69V2oKyu7Ufne
	l3Cz57+jN9JF0rPHSsPUp690rp/ZvjYtabfRlOqLgMqS+dcFBdB5wl1IUzdLEQgnpqTDqy1sJuv
	55riXVHLJbnIfIkYPcAVGdSgM+1tD5/jBgTaU6a4u+hbFux75R25EufDr8Tf0Byw+IUy/HOzL2i
	YA19wxOG7a/upUG6aft43XBk0Oj7s/zTGTfPSeqBSt6GYCF2aOAHYwelZ0hWCAJIrc1JJJl1Tmk
	j/dzaA5q3E+NLx+DCmxm9kbLA2zo7c8FdZTxx51hI/NfGvYhxf9NBMu1qnCvMyYWCRfJPYXG9m0
	coR29zEpkELBn14ZR4isxEMrqMRasw5GaIBokY+QkvcvayUDsR/IKTY8haZe0/WdCUEpVz+WeuR
	rfxlvtTPvWabkpN55y
X-Received: by 2002:a05:6a00:4147:b0:824:a4d3:38e4 with SMTP id d2e1a72fcca58-82c9605da77mr64432b3a.61.1774561944831;
        Thu, 26 Mar 2026 14:52:24 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c964f9e9bsm8476b3a.49.2026.03.26.14.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 14:52:24 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: jack@suse.cz,
	hch@infradead.org,
	hannes@cmpxchg.org,
	willy@infradead.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 1/1] mm: reinstate unconditional writeback start in balance_dirty_pages()
Date: Thu, 26 Mar 2026 14:51:27 -0700
Message-ID: <20260326215127.3857682-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260326215127.3857682-1-joannelkoong@gmail.com>
References: <20260326215127.3857682-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 233A44000D
X-Stat-Signature: 1nu6m5am5yrukck9zxjqobb44k4n9did
X-Rspam-User: 
X-HE-Tag: 1774561945-142339
X-HE-Meta: U2FsdGVkX1+ebcuLriTMZT4eJM//+LN2H53nR5i4vKtuCoQ2V4ZvAmZwvmyBibV+uKlfNN1dd2xuFkhQTHEcs7wADasxWo8IFU6jGcai/fEby6uvKd1A4ZOHGGwAx2+iO1DzCFEHO8gxF+uALoxBy5aCF6RH7GzBYEMv7iZ1NDhNB124HxPHzuUazrMMdUzMrMp1CC8FyIe26eiNNLRxOWDkhmyc2fcHAI37kpQL999Tx4867pX+C464vyesk4jjBv1BEN7tj2W2Cm/7xR68JMij5Y4C0/s472WJc/UNpII6suGoXyriHvtvtSDHCg+0OJGjaVYhlWJSlFm2yOyd0m9LTHRsyseRGhNa95G/8GYmnRCW3f06UeSf7Yk6t3Fom4gRHsJz3xKDqM89FJ3RsQEoVwKRhx6T18x/tZ7muqLw6vYLokYb/bhNaBj7sY7HACg2CygS/OAnigMfTg2HhJNHPVmHWq0mY2wcSGkxfvktcxH5J2NcRJTlhV0LH2JQyF6IgetbuU9zAIlI02ayh4moEIPK0vu+2Y3FG/8owqVFsOIp5Ul773Vh1474bBrarefjLL5RBEy7YjJ4fK96IhVlnTY35Fgz/5rKv8u9/4idNg2uQZDCaeMSgx8q+D0oGhb+Fo3Fa+o+0cVQqoB2PCVJOVe9nYEPcwpaXBGAPibntU4L9Hs4I4c1oI0a7S70OtYmynkWrfM2SU6pO4Pa9lWyllDT9nz3WrTXH+i3V//1//1scsmJ6JQhRXNilpQjhNR8SxCc4f0wbkW99ZTj3nTMH+7SmLhMPZBA6amfomoAxNjae9dKEFD/U3FNKc6PCeDDGaYpkLWdZlaNYp/sNrLLel+KpU8UKZ25pfa1YiD+/z1Xnqrf+UDThUnv6jM00nGWboPiwG9myPUQlZZnEIFn9gfHDMF/I62fk2lceJnJvgs8l+ivXftgSR+vJZISftmUvoGfEERyyvy1rLY
 oJTZL2VW
 XQ1y16dDDIdEhMamWZMSJLRC7nbJC0u7gt0E1E+WSzFQgdcJ3reyHMYwIMnO43H5g9b13NKDFKqsS9Ajjy+HW77wxDIsC0SdC4vpZMoHL0BEYlbC+yb3FFWPV4QjA05SDS8aY+XeiKlCFUpYYFskARie7K+Cj2lMn3hXnL5XxT8YCh4Ao01E6ZPxjrkcUXrn1xZd7VzxZZ++H5MyBuIiiKeuopioGKd6fGuyZ17vF1dcXgAjC0Kzg+QfL/bTknxIMz7uKTq/V9qPOxBiJ03ee8ZxjEcBpj3viEHPs2mGkRRM4OQmond8OeUidiswvWUnkqGNlaNqLRfgk++E+qAu8uSkrP/KSyh2aDRfvDj+InbrFVlI6MFdIZQdW09Aj0IfCbbn3+nQTUVU9KM4nQmHQIgF876qyTi5v9Xt0B/boxKciywTz6iPSsA60HqvHaIpfVh+x4bXYIocX1RNSDFAEZsn1sgsava8RyhD45qB34RX5nVW/2/hlJsx8NJcoxxs+cIoB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 64dd89ae01f2 ("mm/block/fs: remove laptop_mode") removed this
unconditional writeback start from balance_dirty_pages():

       if (unlikely(!writeback_in_progress(wb)))
	       wb_start_background_writeback(wb);

This logic needs to be reinstated to prevent performance regressions for
strictlimited BDIs and memcg setups. The problem occurs because:

a) For strictlimited BDIs, throttling is calculated using per-wb
thresholds. The per-wb threshold can be exceeded even when the global
dirty threshold was not exceeded (nr_dirty < gdtc->bg_thresh)

b) For memcg-based throttling, memcg uses its own dirty count /
thresholds and can trigger throttling even when the global threshold
isn't exceeded

Without the unconditional writeback start, IO is throttled as it waits
for dirty pages to be written back but there is no writeback running.
This leads to severe stalls. On fuse, buffered write performance
dropped from 1400 MiB/s to 2000 KiB/s.

Reinstate the unconditional writeback start so that writeback is
guaranteed to be running whenever IO needs to be throttled.

Fixes: 64dd89ae01f2 ("mm/block/fs: remove laptop_mode")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/page-writeback.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 601a5e048d12..c1a4b32af1a7 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1858,6 +1858,27 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
 			break;
 		}
 
+		/*
+		 * Unconditionally start background writeback if it's not
+		 * already in progress. We need to do this because the global
+		 * dirty threshold check above (nr_dirty > gdtc->bg_thresh)
+		 * doesn't account for these cases:
+		 *
+		 * a) strictlimit BDIs: throttling is calculated using per-wb
+		 * thresholds. The per-wb threshold can be exceeded even when
+		 * nr_dirty < gdtc->bg_thresh
+		 *
+		 * b) memcg-based throttling: memcg uses its own dirty count and
+		 * thresholds and can trigger throttling even when global
+		 * nr_dirty < gdtc->bg_thresh
+		 *
+		 * Writeback needs to be started else the writer stalls in the
+		 * throttle loop waiting for dirty pages to be written back
+		 * while no writeback is running.
+		 */
+		if (unlikely(!writeback_in_progress(wb)))
+			wb_start_background_writeback(wb);
+
 		mem_cgroup_flush_foreign(wb);
 
 		/*
-- 
2.52.0


