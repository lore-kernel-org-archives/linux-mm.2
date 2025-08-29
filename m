Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E35CA0FF2
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 02:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC15A8E0001; Thu, 28 Aug 2025 22:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1748E0008; Thu, 28 Aug 2025 22:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6AFD8E0001; Thu, 28 Aug 2025 22:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8950D8E0003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:38:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE8EE59105
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:38:00 +0000 (UTC)
X-FDA: 83828235120.25.BD1D9CB
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf25.hostedemail.com (Postfix) with ESMTP id E01F0A0004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:37:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JTXNhEdj;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf25.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756435079; a=rsa-sha256;
	cv=none;
	b=jLTTcUZRBDRgxn74d8Y3GOk96I3GfZId33ZsKt421lOgD38GAqCXWi0XT79xrJ85HyT2dF
	56ZDzbwRWln/qY2tBLAnX3tgMXFeZGAFcVOXomTUBIQj2J+OSM2YyEMHiDE72EkUg/oHpZ
	a2jRtGxbIjR9Ccafb7vTevDVTPx3xxM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JTXNhEdj;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf25.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756435079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txWJmcs6EY6YwMtBXrwL5dy322i8KuP+65w54IWqMZA=;
	b=xXu8jZIDWVMd36vyTRjYz7Ai86YfCr05GwfmbFk97n2ggl22yCkwg5JeyG6+q3TxkLvZjP
	w3JRgUk4dnHVbqkx9m8CgJu/PTQeiykpmOlgL/djQPCyghdNst8Fj8P21tQSllpHG0WgPo
	tAbJw9821JFaR2gjdszUQUICjhXYKcc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=tx
	WJmcs6EY6YwMtBXrwL5dy322i8KuP+65w54IWqMZA=; b=JTXNhEdjq/K2VGcsWv
	sOXscMJS9RKKlK6ey0u8KR+h1sJl4Z47Hp0J9+/Z/vPtHKcjFvrWJYsGsj9pDwdL
	CESHWyNfo8OA5u/xB0gtAmlOQYkPGlM4/AUqRkc5qZXDchRpfg9cIhpaTKr+GqQI
	NIr1Gr5BCQEaWfwCnoSwQVG54=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wAHFm5vErFoPaFJFA--.713S3;
	Fri, 29 Aug 2025 10:37:38 +0800 (CST)
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
Subject: [PATCH v2 2/2] mpage: convert do_mpage_readpage() to return void type
Date: Fri, 29 Aug 2025 10:36:59 +0800
Message-ID: <20250829023659.688649-2-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250829023659.688649-1-chizhiling@163.com>
References: <20250829023659.688649-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAHFm5vErFoPaFJFA--.713S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF17ArykWr43Cr1fWFyrtFb_yoW8Aw15pF
	y8CF95uFsxJ3yagFyxJrs5Zr1fu3yfKFWUAFWrJ34av3W3XrsYkasrJas8Zr47tryrCa1k
	XrsFqry7Ja1DWF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jzYLkUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBgBy4nWixCnPXNAAAs6
X-Rspamd-Queue-Id: E01F0A0004
X-Stat-Signature: zefrjc91ntp945wouto75sorwzqnd1xs
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756435077-718490
X-HE-Meta: U2FsdGVkX1/O+zwRsUTDpXWe3gL/t2YlGYVmMEs3m+uo3j2rwu2csd4rmMbp8RMNUprvqmEbJUR5cctAj+lgRvjPnu+KMl8RqjCt0s9wcDTeLVE1m7KLBUj4IA2wgS2Be/9WTdgXM/2I80p6Ap8e8C89kNhrWL6XthlJ4Wt8enePWSdsHu2W6Qa3EuG5QKZ104IVkndh9hTF/IWAPH2dBBiGjGUIn6DTTb71m8X9Odlap5NZ+dIkRgT4Vh1Wo8atdB0IBhwnQtVODfYomMUeBtRGwY7fLQ1nrgotVXvhdoqfy7yat2p6IpguBr0GwxQo1nj3ud/ks4ZJ5val1E6tUCLZReeR52YPRp93pE0kQ7S0esgLkMkZFyqR6kv8VE5hESwLZe4e36TlRhx4NkHXbyjCy6WOF7lAv7sGqmb2AFhFRw2UA6YEVv8qQRojOXIlR3hQ7hx62zLqJGP30GF11DkWR9E4rBAp3rVPRJyzU0rZMFRhE/nkLcU7QfWm47L8pptz9OZdBKUohHcsFh0gaLpF802uz4WfKlAInzd5jZIlcHdKFFIDQYYhYPx3d4jj1jm0sJ6oDkH6Yu7+W63m9vmhzaqVhKp/9yoflVb+XTcZVK3pL1IHMVqCG3pWiRfdhLzTRUYfhsgcA8pZ8wDck6d3D8X+Q5Ds+z2yZ4//zt6V9l81WvQpmvGGUoePGUV9UCghZiOxXn+pw9xw/jnfqOMnf7LHjLAAcGQXub+oC7CAMY6U7tzsNACQhM+1gvdLE3CtV0rbO5uZpe85WttXqFET65zQA4intYkpqL+pbEBoDEO/G9XGBEy9g+Jc9UtnKLJvblicmMnNKLvRV+aV2M/GB+2SPxULbEvKMjdrxA4QKfwcQrohD6D0r+FTDBPNCupnkvUFkDUjAWdG87t7CYKFVN7yb8q90ctCSRy9zWVu5eE7W/BRqOA3MvGszegoz710GDPLF2aAGcowYg5
 YA0UdRl0
 +HUhJLSdKSowJUmmXs/lMr5QMVBW3mI3zk2tbC/THVyT4MTkHHfGooSOD5RCONkqgnT34CT/8c7ijehS6CukcGUPla+GIbxoHL2Zcp1naF5Ei2/1oNTcXEX6ZVTNZaXl5+u2gMB6a71kjyArMxGKhuqCJH6rlgqshJUxxO39LuGlFB85MqkNaVZ7tIHD7la7QuSEBcK55bfTfiaibECgwtGukTIxgVzxoSuEQQ52ZjTySs/Qh65rK/kWVl1adBCbLatkfxFJVfC7zr0XK0EyZZUiffqDLWmTMiUNnezFN/Z9MLuAYuHPKeIG48hB+Y+JLklFDcDKATaKcqOzMd6LVMl3vLNaoOb530iC+DrAeabQiLY+af6h4t9qd2Olt/e5Tuv2TYXPXfCzRiMg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

The return value of do_mpage_readpage() is arg->bio, which is already set
in the arg structure. Returning it again is redundant.

This patch changes the return type to void since the caller doesn't care
about the return value.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/mpage.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index e4c11831f234..7dae5afc2b9e 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -148,7 +148,7 @@ struct mpage_readpage_args {
  * represent the validity of its disk mapping and to decide when to do the next
  * get_block() call.
  */
-static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
+static void do_mpage_readpage(struct mpage_readpage_args *args)
 {
 	struct folio *folio = args->folio;
 	struct inode *inode = folio->mapping->host;
@@ -305,7 +305,7 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 	else
 		args->last_block_in_bio = first_block + blocks_per_folio - 1;
 out:
-	return args->bio;
+	return;
 
 confused:
 	if (args->bio)
@@ -368,7 +368,7 @@ void mpage_readahead(struct readahead_control *rac, get_block_t get_block)
 		prefetchw(&folio->flags);
 		args.folio = folio;
 		args.nr_pages = readahead_count(rac);
-		args.bio = do_mpage_readpage(&args);
+		do_mpage_readpage(&args);
 		/*
 		 * If read ahead failed synchronously, it may cause by removed
 		 * device, or some filesystem metadata error.
@@ -392,7 +392,7 @@ int mpage_read_folio(struct folio *folio, get_block_t get_block)
 		.get_block = get_block,
 	};
 
-	args.bio = do_mpage_readpage(&args);
+	do_mpage_readpage(&args);
 	if (args.bio)
 		mpage_bio_submit_read(args.bio);
 	return 0;
-- 
2.43.0


