Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46A88CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 03:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681778E0006; Tue, 11 Nov 2025 22:16:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631F38E0003; Tue, 11 Nov 2025 22:16:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA258E0006; Tue, 11 Nov 2025 22:16:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 376608E0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 22:16:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE708B8103
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 03:16:45 +0000 (UTC)
X-FDA: 84100492770.09.EB01623
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2F75A10000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 03:16:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YDfro0IB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762917404; a=rsa-sha256;
	cv=none;
	b=SEZLlnuAEmckWM4Osuq6TzvCC3ZnGcHf1syDoteZDmFdidXNdHPnC7eYPoEjP86CrS3uGy
	bDB+ftUWoMOYrBS9WBhY3vH0jz7Q6Iul/QyhtmBWb7YKBXHKBwIDEtel94EhpkPj/vzgz6
	0t33Rj1brdNt2nKmYBVjA1JRLv7FiNI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YDfro0IB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762917404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=54geGydfN2rDn2LihShjRD3xq+QXkZulAFyru1X2fZY=;
	b=e+lVarp9lsDiWrpYBSU2lnKOL1eSfIaroa3mq+Rv1iWdsSw3dbV0rfablH+iadnOzV5CRm
	75oP7FF+IDUhCmfhlOf7ilTym4YJlN0W1MZp+E9/b04cmlTY+A3ns1B0AthkDq+cfeqULL
	2gTaaLEcAMDutwqGIF//oUbzDfYIr38=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7a435a3fc57so384903b3a.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762917403; x=1763522203; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=54geGydfN2rDn2LihShjRD3xq+QXkZulAFyru1X2fZY=;
        b=YDfro0IBwrbOcIOEBcEHHFvezKidI0EAqa5r+E2IZHxmivJZdfGe+T7GU9KSUtthcU
         arr1SG3pIGhwbP5kj7X9fClgx4+mPgWOxpTJkd/siOIy78Lf+jcv5G/jtu/0oBGspuJ/
         9MEnG9aC9lThDJvnFu5z15XKQqD4PLXw5/KYFeOFC+npfhCW+hAcDn/tleyvANfNFQbV
         JX8qNbQFi1aHag1vgFgCY4J28mNKLtqLAIb8qKxwv0UfwuLja1Y0LblJ5phDIKf2eYmG
         /Dl8QkRaEloEGtsV22hbAYjFDx4oLvd24YQrbgy5C8MoiLnY4yaAYJvJXvd+A90cTPjS
         eJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762917403; x=1763522203;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=54geGydfN2rDn2LihShjRD3xq+QXkZulAFyru1X2fZY=;
        b=edQcBuP+8YnZc191Rt2lUom2O084PX0cYLjL19mAqUqiIUj27p1LcGlS6Lv1Fxi5FY
         MIGtKT8VwE1lfVuHOQPzYO9dQnGN38dU9gKMZP2Z2emUZ4Kiw+oejzrorN5ZepJ4aGW6
         gzDIKJXZeWMGIuLVsGMjbJ6UCel3NPh2/Zo1Sr3uGao7jqyuSe0Q+/E7MI5cFnChWbFI
         nB6pT28984olyXYSWJlmLUs3aNNZHk2J6X/JNHJ6GVlyptq6HeF1cGtkhGkZlJ1gRmEx
         WVbEHkry8Pw+cJBzPWNQkUpJLGizATzwWz/yiVD32C23ww27nxX90aFMt8EFmbJ465pM
         Exbw==
X-Gm-Message-State: AOJu0Yz+mQthJycOS4PzLJCYyVrkZY+ELMKIE/hF6gTPHDI4qr8kvsFl
	UIak2EqrVAkASp45FB/wdsvp/auZm2U7kc23lq86qFXDRPhoBkVXmO/r
X-Gm-Gg: ASbGncsZgAftagKDLlDQKAp3ohENWtzt+MLxPMp+lDPi0wry6IaPCzEYjvj9WVcdchC
	URvlD65eqSj2ioOqczwQ3xb68VwDY0AbAaNpAG9cYoBhZpCbuO1tErttP71MD9Aw6sEoIVscO5O
	VVdxCu18zw1qgp15SEeaNDVKW7I+E3TCoxOxwAL7W92AJrgD8nT+7hOpwOhJW22WsOtKHZfBw/T
	2A8CBd0HDdTmz66FkI7Xbx4GQMuFjKpR2VUfCZ+NWpeOzf1901+H0+ESuaTxkzMPCaG0WrDr/bo
	cpJRJ7ibJI3FbRNG3JdavQDotDQ68Txj4T+mX2+FXeC5CglS31b1+JqwFeyuqv43JZJesqlfdwu
	OQcKFyEFM6/MyybE4YDf123hfrTSPJIFHcjvw+mHwkHdZkmHqy9pSI23GE5Kk15sTWFazHhfsLH
	p98C8nCNFAmz7s9iJsuXKJ/e1c
X-Google-Smtp-Source: AGHT+IEkMliJ7qBKQYrIHSvOIWpab75LmuQu3zIzehn3oSgIEMLML+jJyMlJs4LMkYWAbU+iGIXGbA==
X-Received: by 2002:a05:6a00:b8e:b0:7aa:93d5:822c with SMTP id d2e1a72fcca58-7b7a55b7542mr1319175b3a.23.1762917402869;
        Tue, 11 Nov 2025 19:16:42 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:1574:2bdf:5190:94ba])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc17b0c4sm16967241b3a.48.2025.11.11.19.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 19:16:42 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Subject: [PATCH] mm/memfd: clear hugetlb pages on allocation
Date: Wed, 12 Nov 2025 08:46:31 +0530
Message-ID: <20251112031631.2315651-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2F75A10000C
X-Rspamd-Server: rspam07
X-Stat-Signature: zgh4ufqcgy7afb845cr5iek7bokfp35m
X-Rspam-User: 
X-HE-Tag: 1762917403-447395
X-HE-Meta: U2FsdGVkX1+SzxxhF7JKF+5vx0wJ172ffUmkh78HRuqJtcGHeEjkMgHlj6QTe2LgofEf2tUDAWuSDz9DOXzPjdtu2MSZV/2/ejYtbCyQd5mnju5OVL14BjuUTgqxT/5iYFehAhKqZ5/gVRmppRs+IaBpLwqI24VM3AxTEnVbU+Bp/YPDTkwGunEL2cJqzTT2uKZ/8nhwa+CwvSlCVf4eNnMQFd4CVQZALyVIX8REcKXXiHzdtRMv1gbM2kIiN3egcLXHdzLOaAv0OYFmte2EeL+XJ1YX3q3dFfZgEjoQIxCSNuIbY/c24PXvrJhYzI+jUAXL/Y9oZpAoiB4vNte33US6ArMQlf2KP5CA/ih8kkgJh7V7NKfKft4Waz5qlCVn7BQrl2jrrQLPRYAlJJ2kipp/pyqR7UlAhFJZ/YgjupVRAW7TaPpJVllQVG78/kWU4KDBAw8oXLQoLnBJ8WF1KJZcvr9Lr5U8P2B3pEhsS0O3F//1TeV6tDGAp0xtTxL6sJcU0J1iyyY06UzKEFPOSyraw9cI7FSjjln86ShQ4ZFkHwhSb5Z3rkVupdNybQP2aNk4G81iqlulLxnJrlf2DmbREmhcTPJtB6jqWPgq/xggUHcZs0agY/l9dKzpthJpBL5cSy2zSK6KJtdknlDni6S3G/nHsxHHwr7X5CqwAjX4gul2jqH7IOBD+wES9zABwW6juElzyutQ3aqyLtTQjH1j/Kfs5P0mjMswfZ5KRvsQ0zkekFwfSjBybUEcKCm0FlnzcCNbCx+lPgwp/Qq1eIXWgtA+owb45mBlktRHg47JGI8EQUkRFrWADLXj4EpRBLYtEoBQEp2jRYg90StqIrHP8FWdqE0jLO5PMzGJQylyX/4LqnuuFwZDTqD2KbzvEycgnXBn1N02vRfoO+A/WbSZpgBVQvrSCVoQPXx57gEEW0feHRziwiwE9iVFTHJTv3tSSWif3rO17Txma05
 G9PB/Q5i
 z/4gNqXosjrWVfg/HXHr4cY84mg88V+ldjGdlt8ufWnczdJX+RVPW5bw0HbY47wJiVhftqWh9q+nxuQKfH2NrZMuLtwUvJiLJ+foOWxtuCB/7Cu8sLNX2vO0j3HPxsRHFx1TXpMO/RH9iWSkjCoN4PzbCvzkepE1DRtsa25+1Ni+ZKBZSAZQONDDJzudRw44A53oeoIfDW1bgdp/MDp6uhUSBYrVoi+YCTxTMf3IfJJiw/+YiToxg3OmahuUWHTs9iNPqurKSnAmFwuhqWrcTB004y3O/0PBwD83oDpZjqUoRDa3X9e3I7Mw8ovcAnwf+PiWHzq4s3wI4qLyumkkp4DUitH3WXtXu55LSWq9lc+Eb3bbaGlzqre2IoK+5ivlwuf/5geJq+1L8Q56bbGz3n2n1xL7LhbLObmlDlcc4cXBejC9yQUdXjGG6GvrvT1W0DYJA5xqdjLzFAER2dQ0bMmNj8VHuWyggYYJ5CPQ/KPubjdVqi53g652wTPOFMLbTjVz3rqxT504J15fSVbpmmJ1EDijsy92sG7tEP0JDFvlS34OA+cjA90JvMMYMQ8juFvkrECK0tnD/dWQSPzda09HEy27HRhQjK4FgPhbbMwt6LEtVZdpMqrphl32ZdXcE5XF4QQGjAt1toOmK92M7ijHUpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When allocating hugetlb pages for memfd, the pages are not zeroed,
which leads to uninitialized kernel memory being exposed to userspace
through read() or mmap() operations.

The issue arises because hugetlb_reserve_pages() can allocate pages
through the surplus allocation path without the __GFP_ZERO flag. These
pages are added to the reservation pool and later returned by
alloc_hugetlb_folio_reserve() without being cleared, resulting in
uninitialized memory being accessible to userspace.

This is a security vulnerability as it allows information disclosure of
potentially sensitive kernel data. Fix it by explicitly zeroing the
folio after allocation using folio_zero_range().

This is particularly important for udmabuf use cases where these pages
are pinned and directly accessed by userspace via DMA buffers.

Reproducer:
 - Create memfd with MFD_HUGETLB flag
 - Use UDMABUF_CREATE ioctl to pin the hugetlb pages
 - Read from the memfd using preadv()
 - KMSAN detects uninitialized memory being copied to userspace

Reported-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f64019ba229e3a5c411b
Tested-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 mm/memfd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memfd.c b/mm/memfd.c
index 1d109c1acf21..f8cfc2909507 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -96,6 +96,12 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 						    NULL,
 						    gfp_mask);
 		if (folio) {
+			/*
+			 * Zero the folio to prevent information leaks to userspace.
+			 * The folio may have been allocated during hugetlb_reserve_pages()
+			 * without __GFP_ZERO, so explicitly clear it here.
+			 */
+			folio_zero_range(folio, 0, folio_size(folio));
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
 							idx);
-- 
2.43.0


