Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885B5CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 02:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08CA8E0006; Thu, 28 Aug 2025 22:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE02F8E0003; Thu, 28 Aug 2025 22:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6088E0006; Thu, 28 Aug 2025 22:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88B708E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:38:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CAF7E1191E8
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:38:00 +0000 (UTC)
X-FDA: 83828235120.26.A90F731
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8424940003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:37:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZJeP1ySK;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756435079; a=rsa-sha256;
	cv=none;
	b=PGPlUx11OcCkKkefESYsIqqh28KLwVxY/7s2w8wrXtQD1BZNeFuUHI9ap3xLghkUYSx8Yt
	Tm4IXR9/ROaQ+20YK6AVN+cNUfTmw1ZQWIXtUdNzPhI0YYIwDmQcavhQIot1aYHu8GsMqM
	bf7CCTp0uBiI1KjiR52ILYANnOLccpc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZJeP1ySK;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756435079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JH5gu/wbTJ157lbspmx3uKDsuxuH/lv85Oq2Ti6Vn8w=;
	b=4xfsdex7qFq3rwfWllRhSotoRNdvchCTx77vsSQhsorZ3XpN1kMMGNinQ9CiaNEk7noFKN
	JKFBgk4qMIynzNiCLjOlkjYJoGFDniA28HhkKtmDqVIrotMQ5N0BUquvR4JoEm1ac+mPgD
	VNJujnx05ZVzF7dZfuT5mmhcB1oszzs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=JH
	5gu/wbTJ157lbspmx3uKDsuxuH/lv85Oq2Ti6Vn8w=; b=ZJeP1ySKqmB3QwqZx9
	Wz6lI2hsPvE2/GQTg5BG04rvUSBL6d/eoMhcZZPr/jt0CFeOiesSOEg01MfJQHr3
	DSkjTc+1MGn34KgmCZgJp3rfUJY2PRoQ5S9t0T57yNIbH5PsJFCAQpGh0MqjMEAv
	2QOhrkc8afTFcpWkXUM2mivPo=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wAHFm5vErFoPaFJFA--.713S2;
	Fri, 29 Aug 2025 10:37:37 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v2 1/2] mpage: terminate read-ahead on read error
Date: Fri, 29 Aug 2025 10:36:58 +0800
Message-ID: <20250829023659.688649-1-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAHFm5vErFoPaFJFA--.713S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF4rCFWUWry3tr18Wr4DArb_yoW8uFWrpr
	W0kryvyrsxJrWfXa97JFZrAr1fC3929a15GFykJ342yrs8WFZIyryftayj9ay2yr18XanY
	vw10vFW3Z3WDZFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jbkuxUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiFA24nWixEMErIAAAs-
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 8424940003
X-Stat-Signature: 4cuey5m54uno6984t9ny8mabztumq91d
X-HE-Tag: 1756435078-129724
X-HE-Meta: U2FsdGVkX1/TPbfJJtC1nJoi11IKm9euZjeC/dEaRFWcLXfyvdaOjcoJ65pRp2d5C5YerLCwT8Y4NKu0nhBfFKKX6SRt3bcXTUj+5KvWiuZSlgsbWL+dzWAJQNSnyp3MTOVuQBD2FRfo/42AYNgwPxcX265UjWM7hcQdglvRTfmKe+SXZCc4kovZTKQ9rUp7HTOICXzgusSEHqOAgK61lgjygSlwq9Ocuj8tS2rBU5N51NkgZEA9L7NRkXEHOu0BoIJTFtNeHFpqtO6osRuF66D0ybmH7V4obcO6XA16u2guOcCRijkhVXbwJKlc6hDb4OG1XzprZLhsPl7+c3kOv5sxeRNI64qnjfbwWpKkD1pHwhW2gIQOQtTI+wW1LB8dQdpXA4HjRm17yOB/Yffr+uBnYOFNEBRqljgd61fQ0N2tHTOAOwCpyVoCn6rWYcGd+bqUgRDFK5yiV31y2gMAIEH0CifRbooARUhlg8GXHk+cQreU8vg6wZnvl0lDaXMTM4PB+O9R4seK4eFbxWf4pSC2qwIy+BCrLShHxFPcCn9zxgolNm1byr1/V8W3FVZx5AdLK1vx/E9TsMvTiyZRzu9zne5OOP2NkUznbDN9LpV1J51fjWw1RQHWJd6JxttrNy4lrHmQ16LwsfeAD8rFoTiJzjjTtV1l6ftSD1ANqr5lVyMWooWSawB97TqohdRMAQPkWdVE3gHN9Tc8gyLCocetBlcyLOGdOb1j4nQ0dJFuYTNxtHn10hYGYSlwrFibKMSJ+DstUMxcyfYtNeTMgaiyFMpClplG4Hl22I4Yfm+Ee0edmGZrdl+6W/q1jT2UIHfCEOlaVgGV4xZoGvscb/HOMqes03K9BF9x7FJ/9XRWA+zq4mhNqFPCW3CgfQoCLHvlm5uv3VAUZ7kcKei9jtLbnOAPLU2JXgJ/MerCXJ0/rM8Aw11kGjGmLqHeQ7FKPfXsl5fQILg6TvovXtz
 DiF/ozMV
 wCP2ET7kFNlw9HdjAorlJq6eHm/GDlCjwz5KamdvoVjDyUFZ+TeC6tHDjjdcGYhVbtDDEMe+tfpo8t8JhMkdJBzOPu4+nP5uae/jh/YVwz8eD/t/5/hVD9DY58gz2RAqLJfSe5wRVfI02nHBYyucXnkSFW8LnUCrXkoMaKNq92PQIx4Lj3lxLM60TZiIhGu+Ab+Va/VJdHfDGVgy5uFiJOKvnd4An/yzJnWjsObxj935eCJIE5DcWqupbsXLPudgiP4sDwsFr8XncTQBepBmbdJQRJ2jkb6OyjA73asi8QXtp8t2VuXUJnSsYSED3R31WvC4YhUJz+sG3TgW5dVrbWZIXJbH5A4XRMCY2JzCdn24v7L6cdb1wJy+q/AEDYjRQFkaL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

For exFAT filesystems with 4MB read_ahead_size, removing the storage device
during read operations can delay EIO error reporting by several minutes.
This occurs because the read-ahead implementation in mpage doesn't handle
errors.

Another reason for the delay is that the filesystem requires metadata to
issue file read request. When the storage device is removed, the metadata
buffers are invalidated, causing mpage to repeatedly attempt to fetch
metadata during each get_block call.

The original purpose of this patch is terminate read ahead when we fail
to get metadata, to make the patch more generic, implement it by checking
folio status, instead of checking the return of get_block().

So, if a folio is synchronously unlocked and non-uptodate, should we 
quit the read ahead?

I think it depends on whether the error is permanent or temporary, and 
whether further read ahead might succeed.
A device being unplugged is one reason for returning such a folio, but 
we could return it for many other reasons (e.g., metadata errors).
I think most errors won't be restored in a short time, so we should quit 
read ahead when they occur.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---

diff from v1:
No functional changes. Improved code style as suggested

[v1]: https://lore.kernel.org/all/20250812072225.181798-1-chizhiling@163.com/T/#u

Just submit the final version, it doesn't matter to me if it doesn't merge :)

 fs/mpage.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/mpage.c b/fs/mpage.c
index c5fd821fd30e..e4c11831f234 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -369,6 +369,12 @@ void mpage_readahead(struct readahead_control *rac, get_block_t get_block)
 		args.folio = folio;
 		args.nr_pages = readahead_count(rac);
 		args.bio = do_mpage_readpage(&args);
+		/*
+		 * If read ahead failed synchronously, it may cause by removed
+		 * device, or some filesystem metadata error.
+		 */
+		if (!folio_test_locked(folio) && !folio_test_uptodate(folio))
+			break;
 	}
 	if (args.bio)
 		mpage_bio_submit_read(args.bio);
-- 
2.43.0


