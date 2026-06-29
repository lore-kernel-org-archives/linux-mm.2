Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A16C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 01:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6AE66B008A; Sun, 28 Jun 2026 21:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A422C6B0092; Sun, 28 Jun 2026 21:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 931046B0093; Sun, 28 Jun 2026 21:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 630F16B008A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:43:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA51240542
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 01:43:58 +0000 (UTC)
X-FDA: 84931254156.11.7E0E8FA
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by imf26.hostedemail.com (Postfix) with ESMTP id 87272140006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 01:43:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=FpiIl+XR;
	spf=pass (imf26.hostedemail.com: domain of chenyichong@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782697436;
	b=QA4BAvPUCuBICs06NjKAjm5Mn71wKWLBkWsz83LNTgjWYrGyUgtil/4kRelG1M2MSysdB+
	93qjc33ARuohJfkIXap+zaHDZJ+HWiwWNiOEEBer4saFgczjhRYWkmo7ajYvybu/TV3S7Q
	xZGBl86VqzKorc52OlRggQlCqhK50JQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782697436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Je8GC5rfMEsUvYHdHGNvs3OOS9YdQIZpjylOSaYJNy8=;
	b=jNaFrNga2gVcty43SaelN1HlB5Y4ItU/CompSE6UsgRitwIwG5BfdQ3a5X25qQRyw7HaQY
	ise6VHSQ+3D+Di8WyCB9oV5tIJhRd90YHf4LDbabb8jJi8LO9uolJk+M7dVsj1DV8DQ5Y0
	UY1Zbz5JyLQGpoYUUh3KpFcG9YvseqI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=FpiIl+XR;
	spf=pass (imf26.hostedemail.com: domain of chenyichong@uniontech.com designates 52.59.177.22 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782697416;
	bh=Je8GC5rfMEsUvYHdHGNvs3OOS9YdQIZpjylOSaYJNy8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=FpiIl+XRiVnt/cg3A7RITZL/lZ7CgLRUjxrdmwoPVJgWxwHdRtpxFddegg8TCWjDf
	 RplzUnrf80BjdN8uv3spywR8U9vtupCMS6viHO4whghz01KAudVseaabw0DChfjqlx
	 qB+3M3W1eHswpmKukSWTj83wRfXp1pgdqu3WnXYk=
X-QQ-mid: zesmtpsz7t1782697411t8fa0576d
X-QQ-Originating-IP: /hKfklZZPe1Pgu6rC+PnFOPJtte/kahdGolhpK0wQdo=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 29 Jun 2026 09:43:29 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14536289128426533273
EX-QQ-RecipientCnt: 7
From: Yichong Chen <chenyichong@uniontech.com>
To: akpm@linux-foundation.org
Cc: vishal.moola@gmail.com,
	ye.liu@linux.dev,
	zhen.ni@easystack.cn,
	chenyichong@uniontech.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/3] tools/mm/page_owner_sort: free per-record allocations
Date: Mon, 29 Jun 2026 09:43:15 +0800
Message-Id: <20260629014316.130307-3-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260629014316.130307-1-chenyichong@uniontech.com>
References: <20260629014316.130307-1-chenyichong@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: ONeCszOCk2GVt8be9SyLc8QimUSxH1mGIPrY5AdhlIsFnWQx7Oe37cGD
	SQXF2dTR1mNnNG2YJeIT2GHPK6xj5GcyhL5YJ0vA3Pfi3d+o7YB3S+T66XOeZvHoT10lXaI
	Vc3tfZ3eIOLVh6rmcOthMl4SI29DT6eCDhTbpcPYD7oXpJn3T8PEFq3v9VBzZPH+DfiK7BF
	UVpmHwE69QhQanI0iLvrZggF4l/XHpBw3FfpKTxBdlBxS7e25HXzOYU1jzEespcNUuLwE/R
	2H680tBccIG1vSps7MPw0olKAA0Ls7Umqh8T91KQ/L7CtaYRBriQMjxub2ctGGZNWdRGz06
	MLzyiL8EANzEMcgJcOIkA9GSmP7alvRbt8uzZTXheEBoOJwelA+5XkPbVTC/ZJzBlEQ0MRS
	zduVK+Xteq5dEuTlG9ywRLXfxq3wKpOJQYXE33r6u2SRQznBLoO6B2ReAOHiGy58xYNyVrX
	OrnwgAPqVlCpUk4qyi44yJKHcAvBwO9PbiQDt00VLQN/pvZgaXYMarnTPnAjo4os6GDQ2JI
	QItzQ1bxy97QXdCQr0bckCSxEvuG4T0o2li6VcBuwFxtlrQjq6K5GOclPrPCxw5McR2UDHM
	OEufQdxyn2r/e5o7f6OTKybCEAvzxtGGl0rSkLiJaVV1GqByPAXJEir3lqnaufQmed4DB13
	OvBlhU+yxtSRQrTG1UEQ8VmxUygHwTI314PC5c+89ga56b0OPPei4O/RnoAujgSrRHSIqwx
	qwsbXPN3STCaDwZbVkZxQoKn7yFUMnqAgEFdqhzX9sOej26UXjNYR0heyh76nwp52YqNsZG
	n0moVG/lQ/PuQBCpAWzRmZpPGNqPi83MY8qIeeY90jny0bU7ql7ZFII5phMMbif5NnsFm+M
	KjWP+N11XGKtNFRyoC2lJRsxh/DND1aBEXXwJc/DhWxeeYDp4cMXTTEXudlq77QgWH+8ZIy
	c/1Lgmx6Z6y3egkdWkr5rJ7pEJQCW8uA2FVvlONAF6wxpWOI7NvCy3LQBsU6aALZwBI4FaG
	POgmcIqa/iCupbETv2NIibY+gAbAl3sVTcYMzWrc4nDZadw/FvOxKRxfjSzCGW7HULX3z8s
	RidUmcR2PFc
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: ghx4rx18xsyk46syy4t4sf4r5jjm5xjk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 87272140006
X-HE-Tag: 1782697435-327968
X-HE-Meta: U2FsdGVkX18QE4YbZEfH3+rftepPU74rV3Q9AOVx5I6ZXDBgylHapvSbm0KRSRaRVkksK/JEJAYAHZ5ZPY3W+Qqia/6aB893A+RbKgNPRdImZWvX/27Fn8Gc8txcUWtZKqia/aJbJ/+9dkK4ZqiYDPCT4jG5JULZrMHbnasAImopPS0AelUxBWIda0Lcn8HaykY82JeyVt9MM7kpQcZngxJWdmmFME0IIdzMU/jbJ4tYu8sm4YK67zZTMmSyVvssgmNAhUsZkYUwrt0MsTKSrWSqsYyzjAwdZG/BkaTAmNgpON7md3LI+zjeM0RMGd2AnU45tgYuhnTPqOVjjWC7PrOC0vyDpRQDjeuOHb5FDQoWuHALTMoTVovscoqpUhMSt2ACvn53iZE13f8d/vOsqCO8rrcOlw+h1V9iciVjJQYuecyaJ5DuuWWsB0w9PlF3DcaYdsGuv96dxMX4lcZuszbzYwnomLTP1Mv5cN7zHj38pustFdGzXOeVLH5EWBdcOypgAhi1Lr3R5Iwvambxo5G9emBY7v0D+6wavigf6qelTDuqUQBIycNOhwysy6MkLXivlxyqKvdWPf3Lyaw2t06I9lmh3twJaXxWTaKk/D3UTGtAo6wKRB523b+yssRpouNOJTzP3VBB9E4ziOirCqz0F3gajzMHQRAFtHEZ2Lh9jVQxPUlcS6jdGP0buuSutjHGeCwCdDre8l0epoFfeUZRPPZ634fqmrLD1cOgC+EtyklKQYYX2y9CveMJQum6UtaJBdqWu2FG8rG43y9viGw+JPeXDPof9y0QnyvGlyv1Kbo/QT9Tyz4H20Mr1AhRnxdgseMsGRK4LtGpykGbKSa7Hb0Xw3A9gJUx4j65I4VfVQf5SJdBMMYJqdvgrdx5USradiEvnt+QhT8imvZcxjRzi2XkvLEeXmIWEbGhSjXU9LHpW/AizYOUMzKZyGg9ZhZoZiVs+Zf4jXBZDGG
 LEwPLH5m
 k7ixMEaS657FFHCtYRQYsF/hLo9w4dccEIyx7q3uh8xq0mJ4IFT7vbTZzKplo+fJRdKR7Klri4W5y13r48z7HpTqYZW+IO163RP+C9OozmOh9NrUaYXJENVzyYISUfbAyg+/g+3uUj1n9ke9BSaYyokS7RZX8U8GMruwftoRAkMkuswbqaE8MYvPrPvqinIRQ8kapja7SDzRqEKRypk0xDhsyIglLR4ILEsw004/OAOI7htHzRpRpt8zAH7i7Nu6HdNr7nYDWFBEOKWYXFecTRSABrVaLWnTiXv6xoq9IiOZVGdRAFKnlL+JAM9QtXYS6NF7GtYkrp8BAqKVHrmG8vEJ2fNYuoUmwHRzRTL9lqQMF82DjoT0Mn6Xm2OB8zN9r7bpe/zKz1N3pzS0G8+/DcytXSpA4ah8dbvlcSWV+76KgLavJyOlc1bQF6ZJlLyo68Z/n7gWvn9ORMpN/d8jMGH13k5Z4IN+GZDzapctn4Xrc0vo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

add_list() allocates comm and txt for each page owner record, but the
cleanup path only frees the outer list array. This leaks both buffers for
every retained record.

Free partial allocations in add_list(), discarded records during
culling, and retained records on exit.

Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 tools/mm/page_owner_sort.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 3c754826cec5..4c9be28abe3b 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -396,6 +396,12 @@ static char *get_comm(char *buf)
 	return comm_str;
 }
 
+static void free_block_list(struct block_list *block)
+{
+	free(block->comm);
+	free(block->txt);
+}
+
 static int get_arg_type(const char *arg)
 {
 	if (!strcmp(arg, "pid") || !strcmp(arg, "p"))
@@ -502,9 +508,14 @@ static bool add_list(char *buf, int len, char *ext_buf)
 	list[list_size].pid = get_pid(buf);
 	list[list_size].tgid = get_tgid(buf);
 	list[list_size].comm = get_comm(buf);
-	list[list_size].txt = malloc(len+1);
+	if (!list[list_size].comm) {
+		fprintf(stderr, "Out of memory\n");
+		return false;
+	}
+	list[list_size].txt = malloc(len + 1);
 	if (!list[list_size].txt) {
 		fprintf(stderr, "Out of memory\n");
+		free(list[list_size].comm);
 		return false;
 	}
 	memcpy(list[list_size].txt, buf, len);
@@ -863,8 +874,10 @@ int main(int argc, char **argv)
 		} else {
 			list[count-1].num += list[i].num;
 			list[count-1].page_num += list[i].page_num;
+			free_block_list(&list[i]);
 		}
 	}
+	list_size = count;
 
 	qsort(list, count, sizeof(list[0]), compare_sort_condition);
 
@@ -898,8 +911,11 @@ int main(int argc, char **argv)
 		free(ext_buf);
 	if (buf)
 		free(buf);
-	if (list)
+	if (list) {
+		for (i = 0; i < list_size; i++)
+			free_block_list(&list[i]);
 		free(list);
+	}
 out_ts:
 	regfree(&ts_nsec_pattern);
 out_comm:
-- 
2.51.0


