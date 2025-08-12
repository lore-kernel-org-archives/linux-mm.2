Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D12EC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 07:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 072628E00EC; Tue, 12 Aug 2025 03:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049F98E00E4; Tue, 12 Aug 2025 03:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B828E00EC; Tue, 12 Aug 2025 03:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9F6B8E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:23:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92CED160200
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:23:16 +0000 (UTC)
X-FDA: 83767264392.03.715685B
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf14.hostedemail.com (Postfix) with ESMTP id 99F6310000A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:23:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=HLScVlfq;
	spf=pass (imf14.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754983394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3WU889qCdNQb92vh6TByBQLFAnLxusGdo1gurJ2fGSg=;
	b=k3YtQSFloSgS08XVJ6kdYtkYw+pUPHhx5eaqzLaEI4uz4648VhFMp2fftqHtBY1T8ujG/w
	YO6kqLEW9l5++6SjlZZlkGQNlaWpDdiRMmN4qRIOtSu3LdbCxsyjehRq4CoEt9ag/Ws9cL
	5Ea35MrQE06Z0wpsybeO/O44BN8DyLU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=HLScVlfq;
	spf=pass (imf14.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754983394; a=rsa-sha256;
	cv=none;
	b=iG9k0BquXsOos6PvXg3511k0WBw6cNKrRkJ3TNTnarvmnQimV9zSRzshkcviDwpDossk4J
	zlwENCIkYbZkK3K0/sb7Lx2KlQesiIVdZQeIRTvUpr8hpPOiSxs1zgqtK95mL+/+Wg0Mfc
	eh9JSvbg/wr1Jb07V06uBAh/MU54i80=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=3W
	U889qCdNQb92vh6TByBQLFAnLxusGdo1gurJ2fGSg=; b=HLScVlfqHDX6yGgsZo
	wkJeK4EeYiH8pVlG2vviLmwzL+9vOxp0QnQcwufcI9oJhZubfjCHA6G47HpH/crv
	juy2XRZmtUKkBvYvGbT/uOdfoK4fr49LbcN7cTbBOVAAJxXDwgf8Y8fn3bRAx/wW
	6M4EosojQo6dsOju7ntgx0+Bc=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wC3RSPN65pon26ABQ--.34118S4;
	Tue, 12 Aug 2025 15:22:55 +0800 (CST)
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
Subject: [PATCH 3/3] mpage: convert do_mpage_readpage() to return int type
Date: Tue, 12 Aug 2025 15:22:25 +0800
Message-ID: <20250812072225.181798-3-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250812072225.181798-1-chizhiling@163.com>
References: <20250812072225.181798-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3RSPN65pon26ABQ--.34118S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF17ArykWr43Ww1DuFy3urg_yoW8AFW8pF
	W8Ca4kuF43J3yagFyxJrs5Zr1S93ySgFWUAFW8J343Z3ZxJrsYkasrXas8ZF4xtr1rCa1k
	Xr4Iqry7Za1DWFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jwF4iUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbBawKnnWia6QNKpwACsk
X-Rspamd-Queue-Id: 99F6310000A
X-Rspam-User: 
X-Stat-Signature: ko5efyck7uhht4rzyrajjf9i7ca7bzet
X-Rspamd-Server: rspam09
X-HE-Tag: 1754983393-342873
X-HE-Meta: U2FsdGVkX1+FwS8iFuwwWeNF7yM78mpsntgF3Gl3I0kIwcWH+TBg2Um8fBWtbhBtiJtA4IdKS7I3qtqB5m/WV7MrdpqMIdze1QYY1/enNu0BsjO0vvbuRlBZPiefdQyPI8SXmCY7Xa81X4/EgZ9rvWOC421BvoqMQqEWCRYer1b4n4FJoQkNiFruJaldwfDC2ivW0vYn9X5Pf5A62c0IERHpkuPjq3mJYKMEcZkkdrzwclVxnQAgraxLFLkvafhsXWNmL2cMpWUaGctXIz6WznVVTtywFmmDGZfjvtqHsKG3mGs2Jmi02XCGvix9YZO1Et0AkwgaJqGu+l+EamuImovq/mCG7a5liTOOIiUcUYUXwiFiEabV0LryWoKAc4EX1pGn0XopzqB3N6VM32uet7Wb9Af1YfFmPUQ9E6nj9/NX8q+es+THYIS1QRcrQiPU6VZuAW8okVahDVd4VL7Myh51HxBZcroygIPe1GuhkSCjfOX34xyv4Q/euI1lbhA2yGW9+A4aMFtXNDp+2HwFuCA6A5anCPJE/ZbTd4/K9sgCBlVnWokccJmZgAppupMr0rHTM9J6gx9y2IMwNShJ0AyaprpoFczFHcSbYeo7ouEAD1Sr9yABCW/2SaHBb2NKMYD2/7Qp9YYlyPtrSWBrRamT81MceRa2V669T5h1dqJK37eT+fuXtfpZmd6u3seeH/x9ImSFNvEfJPNYX1xh+gPsdxHpPRUF5l26gT7l0xP0QZoCEQ1gTE9bwVVygxkJaP/sDBGL+37Oo7NrWRlAid+mA3FkM4Fi0OYOe83Y9ZB6hZf2Rt+VTAssNHZQv0JYRokVVsMrMcGfZkli+B5H93BYj2HhCWXWdGpFSLGmVQyLEh5n2ir9oK2khDZ+3/C57nP2hgF4fQjohM3/ocIJc/8jz7wkbmDzrGPhbzNDrkw/Y4IBkqCW+DQ54OKn1fCHL8fK+ssgU0EYjSahcYn
 Vm8Pmt9A
 DWtfdYDPEGUU/uoyGjx+2U17n+rH5atW7i/RkswnYCVJ1zvjjbcEg67aDOMjieNPBKXf7Rfw+ax1PIa/32HF5LMfipkrKwBpAmqGyE1hX68dIv2gbOIj00HWOJk4iFQ/YWdMstiWxH3/ni+PHg3Yv6pfiZ3/wggIJS5FXkPlDJiXUUywKacN4Kd2YpB4VddlQufux9lSTj0yO4yjtEymTnelneVUyQQHWHfXcJpIsm4/DPfyCkNOuCDupeFPGRC0ZNNdbT+d9e8F/ESpo5dunR9IZSe8hGTz4HfR2zQUY/BRQKwazltGi0m8HmiOAp2hMYqy/Frc27qlnpMD089mbphwtVCtqmk6s43Ojn49MktizXoAf24u1bNVeGNLiw9xphqtdEiaHPwERRuj1R+z/nQsnwf09FcWsXmjzLAYppvJfbdI=
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

This patch changes the return type to int and always returns 0 since
the caller does not care about the return value.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 fs/mpage.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/mpage.c b/fs/mpage.c
index a81a71de8f59..718c2c448947 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -148,7 +148,7 @@ struct mpage_readpage_args {
  * represent the validity of its disk mapping and to decide when to do the next
  * get_block() call.
  */
-static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
+static int do_mpage_readpage(struct mpage_readpage_args *args)
 {
 	struct folio *folio = args->folio;
 	struct inode *inode = folio->mapping->host;
@@ -297,7 +297,7 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 	else
 		args->last_block_in_bio = first_block + blocks_per_folio - 1;
 out:
-	return args->bio;
+	return 0;
 
 confused:
 	if (args->bio)
@@ -360,7 +360,7 @@ void mpage_readahead(struct readahead_control *rac, get_block_t get_block)
 		prefetchw(&folio->flags);
 		args.folio = folio;
 		args.nr_pages = readahead_count(rac);
-		args.bio = do_mpage_readpage(&args);
+		do_mpage_readpage(&args);
 		if (!folio_test_locked(folio) &&
 		    !folio_test_uptodate(folio))
 			break;
@@ -381,7 +381,7 @@ int mpage_read_folio(struct folio *folio, get_block_t get_block)
 		.get_block = get_block,
 	};
 
-	args.bio = do_mpage_readpage(&args);
+	do_mpage_readpage(&args);
 	if (args.bio)
 		mpage_bio_submit_read(args.bio);
 	return 0;
-- 
2.43.0


