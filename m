Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFE33C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0ABF6B00A3; Mon, 14 Sep 2026 03:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2CC6B00A4; Mon, 14 Sep 2026 03:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8A66B00A5; Mon, 14 Sep 2026 03:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF9996B00A3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:31:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03F12A11F8
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:31:17 +0000 (UTC)
X-FDA: 85211547036.16.C1A8C6C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 36E8640006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:31:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=e3Lv730m;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789371076;
	b=5zFk/zfXiQ+asQ2Aws6lAtdAPkQ7tbmNz1r6wXc6vHyX0cUpkXbCui4lo+h3COWs9wtItw
	M7fY32unadVwLGPk6QMWH1umnWKM89i0HU5Fl5AMZ4bZplFMER47/Pf9zUapNvQIb8zsxK
	3Myzfy040EC6kiG7uUr3IFJVPJlh348=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=e3Lv730m;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789371076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bz/TNXdfHveqEGWGrK6BO79SW6ui4dG3ItAK4KwtusI=;
	b=VwGlhgHNyzfpRWoTxn1JM30lHIamXhsIjriAi0h+yCLlLfOa4Mw/6DGnotcdo3qvCVZTzJ
	p0JyO6qsCJf7noSfIWpf8735YG6sC0TPqol6gTFJi/704wVguZ427xIYjmtrRHJjhsONtu
	u3hKOqgRNO1/H3nEhjMtv3buPexdy8Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D43B81C14;
	Mon, 14 Sep 2026 00:31:11 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0BCB93F59E;
	Mon, 14 Sep 2026 00:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789371075; bh=BeGlU6VoC2nhiSQChEYkjBQ7HxlULOrBNPE3lWJ9ZRw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=e3Lv730mJzEu/e0Xwxm1fzVM6ZLQ7xGlk7OMGxPIgbgNKgKR83jEZuObZdEcLuQNP
	 Je4dImHlXBcx+Ltsv5q08gwvRbvv84+aB1hJJ70PGMQam9zjbgQPrOdFs8boReoBGO
	 FdnARscTr6MxLUQopNNJDWR4luwOq6U4S5f6XfHM=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 14 Sep 2026 08:30:48 +0100
Subject: [PATCH v3 3/3] kselftest: mm: introduce size_to_shift() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-fix_hpage_macro-v3-3-c9a305a01d39@arm.com>
References: <20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com>
In-Reply-To: <20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1704; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=BeGlU6VoC2nhiSQChEYkjBQ7HxlULOrBNPE3lWJ9ZRw=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqp6KzBl9ctDoG65maPc1EIPIDgHe0gQnqDEXw/
 s+xku9RaRaJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaqeiswAKCRBt1cPRWsUx
 M9/0C/9PWswjSpx0cGos+ZePQPwtwlTukxcDz008DaWMjW9Pkd3nB3L9u8cQBWHisni2DEI+aMN
 kusuTkSLArK90ltCu5NtTJFZdhtn36RMPnUL4M2Q1OFsGo+ko+flul75cKIGY6pdvJt+soRQpTG
 GgTDMU1jmqpJElRdvszmhchzZb4+KdcqdRkkTRX6cmsxzbza6tiKK/7v88Uh6XihVlWgiqYLvJb
 xTGxWNJ09cRBAFKP6OeTMLSvQXXe0MtfBw34NRIQnQJyaDsWBiIzeFTewlGvqXlQOP9T56atWqR
 /lEKfvTY9G3w2ekHpscWvy7ULp9UesNcGm7LpHAIDASOR3tDhTt7mRxJ/YLBWODIbTjWTiW0SJO
 AjKB7jeq2PVA7id415eseiDmefXz78nXY+2d46buB4Fcd4Q3pClXBHLf/wXX5zi4wkde9NwuObH
 WFjQVU+atoMMulCs/5FNLVeuWbpvKyq3j6yGrv3Hen91EihT4zvce3x442qRLJWiIvPKo=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 36E8640006
X-Stat-Signature: 8uj75wnyyzxfcf47dn97zww6zn6tzsb9
X-HE-Tag: 1789371076-3942
X-HE-Meta: U2FsdGVkX1/5Xs/+0ERQ/TXSE2bR7RcpKYBiCROgCocz2imeD1dJ5saMydTiyPt2S6yiCoCuQ2JkS0zk4iqhOQ4fIj5yHHe4RiocysnhktWbZyw9YLlpMnvERCXgjNLW5WbNRAf+cEbgIbnFxdJO35HKagJPCdangruemzz+bKdcoBOYd301uth2mrl+fjB0uuxgmVLPELhO61iIl2cqGa5Bk/oHb11EGdGPlM3kcgDzk1N6aVrV5cMoZtNKfvniZ9a6L7AU67muVeurl1N8LXMJFPn+gvBpQ85kMpROmTQ4HHv8tYmyjgrZzI6/25Y9lMttXb8J2QqUE3WY/dNed4cjBbuF9EijnuVJY0uOkFi47ZnRwj3+oVKhtnXmtUxtsg5d1SsKtlY6mGJOPkVyoPhe2sKISCgwq4Ld6NdcvvRC3RvwDSkoj2RjWJ8dDMW1VglOW/IDQgkK2H1pzxsluzzPBfC8IY2ymOzOMsRm1+A0GU+RZ5OO2r8aWWRNk8QrDDY59UEXiU5DFH38sNUdK9eooRwBTG1AV676QnRCfDL0Hj9Y8hmOev8eYr7hvY6UPIIQXUN+zM5Lgd+66Oqu1T8g8TmLsCrlXFR1iKCvi0HO9zJ9Kyq7V45D5BwIUZqWjcK4ONBC4WECFm49GDVe09wqqFq44xMoiNQWu+iRUochk8+NgT7p3TOv/j9uzsBMfL57lCfHTcBTwAoSHbDX1lEBLUqxU+uvWRL3DPWkopu2QYMyRHvc8OD7/ee03K/Ff68riTZTT/w9KD8T5j1Ua0YxfqdTjwALFoJ/bLWDxM4k5XHIhzsYRbc+NsD9dojkbhH6k9atvk55pjzb7sLjdX17CTFN+PbCcfZAn6cfu863L7gCqWJcofo5He6MSo0dCq52YjtVTMAWa0jf5mQGMMLy0E7P+STrbNKNsd9iXq8Q+22LKpDQ3P6wQnsvrvqXvWv908RgdLByKo8tdnc
 Ww6CxvPz
 x6Ks912SbgXgLpUqkp94PXfhE6opZa2IvOLTr/GIwLpNQPRPiSZUi8UyOwLOwVF7gRFQDEKN4Jrz6Qmb6figH05mGcv3zr6r6F/I5eiuPn8d92oI8GsulhKCE1ULAtY1XpfK22Ldm9EPCOMwVPzcGZZtitWtfsnnXpYOgbryIXWkpMMjwriuZyTnJHipZgKnscG0HRosFIikoEDkHmatbdyzbvEyMAe143cirxGQIOYcjCgMEgy+yJexrILR5Lvxndl0CPBifeh9UM0SgolzBb4ijNU5rsCw3Sc1eKRUw/r2H73kyh9rQJj9ceY3Ayn0C2odnKOvECHqp1qc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce size_to_shift() for future users that need to
obtain shift of a huge-page which is other than pmd_psize().

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/vm_util.c | 10 +++++++++-
 tools/testing/selftests/mm/vm_util.h |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index fd1432dc6152..1fef1266429f 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -157,6 +157,14 @@ bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len)
 	return false;
 }
 
+uint64_t size_to_shift(uint64_t size)
+{
+	if (__builtin_popcountll(size) != 1)
+		return 0;
+
+	return ffsl(size) - 1;
+}
+
 uint64_t pmd_psize(void)
 {
 	int fd;
@@ -194,7 +202,7 @@ uint64_t pmd_pshift(void)
 	if (!__pmd_psize)
 		return 0;
 
-	__pmd_pshift = ffsl(__pmd_psize) - 1;
+	__pmd_pshift = size_to_shift(__pmd_psize);
 
 	return __pmd_pshift;
 }
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 71af4804f8f2..0048e0e82770 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -90,6 +90,7 @@ bool pagemap_is_populated(int fd, char *start);
 unsigned long pagemap_get_pfn(int fd, char *start);
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
+uint64_t size_to_shift(uint64_t size);
 uint64_t pmd_psize(void);
 uint64_t pmd_pshift(void);
 unsigned long rss_anon(void);

-- 
2.43.0


