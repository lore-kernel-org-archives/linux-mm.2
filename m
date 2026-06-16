Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B6BCD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3516B00C9; Tue, 16 Jun 2026 17:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485066B00CA; Tue, 16 Jun 2026 17:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39BA86B00CB; Tue, 16 Jun 2026 17:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 127356B00C9
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:04:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 405CDA012D
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:05 +0000 (UTC)
X-FDA: 84886108650.15.16E240B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9BCFF2000C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V65DTVK2;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781622543;
	b=YHsrKtPbEV3VbXpk79vTYqSrzHD5hX0SCxWqPDTqbohYdpTQ6PwdyenAdvEVDCNiO8yyTo
	tb4qqo5scznHkUQSQbULJ+HfArKKkf7jlI/4smIhj2IpgyF9hv1fyzU75+H/HBvNMkU5L0
	RSY7QxoqriR+QDwaKBobvt6Cuxfqblw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V65DTVK2;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781622543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBDvSQ1iWnZfp5aAlbLhoAvHHvZ9HPS98yHZ0WmqRY4=;
	b=etK1VuJeAeHCYjABb16pWfpYd0ZcVZZlPp922ZRBzSuFUDt+K9TO+bl7ZkgZkwNfjDnWoT
	e4+ah4v+TPB2DdPAj/548pSUQ+gdHtUvwxdfEpaxiI0T4hOpKx09Wbb3S0AprOsT4vXpqz
	ahvWOqm+PPPwrGkTbCzJXjyGtAqEEAU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D5A39445AD;
	Tue, 16 Jun 2026 15:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205721F00A3E;
	Tue, 16 Jun 2026 15:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781622542;
	bh=KBDvSQ1iWnZfp5aAlbLhoAvHHvZ9HPS98yHZ0WmqRY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V65DTVK2MhA9N5rWMFKW2QvWqid8b11n1IsCAKjH4uuzl/8DHFRAKFkH5n6HaLie+
	 qs8pE/IVON6wQBL9wXK59zDqZbAn5tTy7IBNrNCx+npgTg69QsfZcG+AVjyibp/M+y
	 pzuRiMvj3EBi0q4JfdLNT4FoN0NpKBSc5ApvjV+6gNkp7oD0Vte+n/NAQ9WLEdm6X8
	 aMHQZ4SPHX1rFOPJtnsq8kxviok7JAIypwzG3w+9QHavEopV4sxJowN81FD87uNjvV
	 iJmrD0S156TRc/8aW5lW9frqy8rF6qkx6a47pwwUGvXG8mAiemY0papX5z4rdX8fzC
	 ci9X0FoO49Sfg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 3 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/9] mm/damon/sysfs-schemes: kobject_del() scheme filter dirs
Date: Tue, 16 Jun 2026 08:08:39 -0700
Message-ID: <20260616150844.88305-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150844.88305-1-sj@kernel.org>
References: <20260616150844.88305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9BCFF2000C
X-Stat-Signature: esmjq4digs6p87k539opr6wjts656ycp
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781622543-798827
X-HE-Meta: U2FsdGVkX18q5vydrO06IDmuH69ddh2wxKu1T4Os2nbbcgG6gpkfJwnzWa05j7/8RmUMZTTaP7XoeWJ6i8IJ4dmgZ8ttZdgGvChixUcJ+++HgiQ4BmHmUF7g1W4DMBj4LIwtW3y5DewtcxvC/HlleF5d055QY3K0+7NFPXsIHVA3MI6gbq3gZ6FrcQ6DOgsAhZ9b4hxks7XDXhVq9PIyyRTFd8aw25th0ehpXnuWOUzKOXnipiDonw0CKjOp/wW+jbV4RQzGRUArvfxZMhwe1NDdSB+6xYHJvRV4N+fY6VJZzh9rXDcPh+huMg/JOLrH1xntxCubI9ldSwnSwuk9qqvM1mKRc4MFPUKHXWcpTTg159y2QFJsbeKaRLMFjHYzTeKYDgb7u80l110KjHNc1i1XgJx6WcvMqFt0kKaqLLqu/fdvb5VUrBLWxgkikzqdnlzIoA1sElRnMn5YtINEWhBJDQKyv3hghWI7tr4mhbGvGSvodtUWTSG32JqNHVqfC+U3sJSvVsTjNI7fEZq5AdaeHQZzgr1pRukqS8UiuZLfQHZgDO4g3sZvgFUiyTPLVTNjvgMn47bX6Ofi6fKR1+p2JjoU3Ux7WLtEbARtj/Ey8WRAB3+5e/LjScTu+aJ2XsnjMBpROkX6BZFUMt9E/DW2c08gJpb20DYD8dJuLiuE/kR3a8SgbAowDBUTAzYx7hrgW1jUy3WmXrnaqTVeeZ7WsYTwMrJ8BLtO4KgghymEl40AkznUEXk3iNEV2hTmlwtjqejHljGiuIU6NLmcOhZyCVHX/2fWc+Y3BjyHV2k1A2ZpxkFm+orcsXJSZmR7Mbu+yt2/4e5L3jlrmAzuPGy7vJ1pMvAnz19xWahUGoJcLL/ZvBRVXCa/Iymji96yxYeonb9ccyyReaCN9z9XOAlNaIyXSXxt6krgE0DWneVhb3QYeUSv+grYbAdodh+uJN5B//UPoipDV06Yaps
 Jcj0HLWR
 n6AwkY51as0mLN4PGbBJcBRexFFYN477cNkpNTSpWa1Jr4IF+ACmTaJpj6+rWfd8Wr32SKpYm9COfN+77+RmSj+TXn3VeEp8mbqLUTKZ2GqpZolkmNXHEhZ5HZn6wVO/fj/Kug9hMYBxSdgf+ire20HGRVg7o2VJvYxcAr8q7M3gI2qLzpPG/YOYS1VYRVJkj7ygRDQkuIIXa/g95/gNwSVkWIGTDm+TTPfOE4YWQiludXAL8A3pTSh4Jje/z3nfm2pqUPcwTF3dxFXVkbpNRYlC8qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme filter directories by adding kobject_del()
calls.

Fixes: 472e2b70eda6 ("mm/damon/sysfs-schemes: connect filter directory and filters directory")
Cc: <stable@vger.kernel.org> # 6.3.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index bf08e6e1f1635..300930c2c5b3f 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -914,8 +914,10 @@ static void damon_sysfs_scheme_filters_rm_dirs(
 	struct damon_sysfs_scheme_filter **filters_arr = filters->filters_arr;
 	int i;
 
-	for (i = 0; i < filters->nr; i++)
+	for (i = 0; i < filters->nr; i++) {
+		kobject_del(&filters_arr[i]->kobj);
 		kobject_put(&filters_arr[i]->kobj);
+	}
 	filters->nr = 0;
 	kfree(filters_arr);
 	filters->filters_arr = NULL;
-- 
2.47.3

