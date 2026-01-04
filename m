Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D379C2A069
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 01:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3A06B0092; Sat,  3 Jan 2026 20:33:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A25A6B0093; Sat,  3 Jan 2026 20:33:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5D06B0095; Sat,  3 Jan 2026 20:33:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E022A6B0092
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 20:33:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7CF70160FF5
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 01:33:08 +0000 (UTC)
X-FDA: 84292558056.08.1CDB5A0
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8F45B4000A
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 01:33:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of yangqixiao@inspur.com designates 210.51.26.145 as permitted sender) smtp.mailfrom=yangqixiao@inspur.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767490386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=e4ja4iKSe7suHgRPrXj/YILKj5tzBTximd/3Nq3T5U4=;
	b=Me9y3Px3hQyiMe8Wao3sZ1Efw4gR4rShp0kxkhvpa/4CG085bWULcaZWr5huhWRc0LHtgl
	5ZuexNpr4ZUTw7n8sZfPP5Kf5BMFWxmDACEeg68KYgpef1Zyr+/YMamMktzzbT4858u1M7
	9fi5iyyvlncstPd3MCsX4FBx4g1L3DA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of yangqixiao@inspur.com designates 210.51.26.145 as permitted sender) smtp.mailfrom=yangqixiao@inspur.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767490386; a=rsa-sha256;
	cv=none;
	b=MTQccNON0b0mEJ5krh73J3TaihY+yy9co/v+fwnnAExEQ62+ZFcpL1k1JV6uvDCqYRfHUg
	LzOL06n/ULyM/0z+t6hPzJdcG0RkYw+y/2YR99xxaukmm2o+xwHClziazcVafWK0LkPJBK
	+NZd856ZhU0avhEp6suPMh262skRujY=
Received: from inspur.com
        by unicom145.biz-email.net ((D)) with ESMTP id 202601040932585560
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 09:32:58 +0800
Received: from anolis.. (unknown [10.94.14.65])
	by app9 (Coremail) with SMTP id cQJkCsDwJ_dJw1lpIl8OAA--.16032S2;
	Sun, 04 Jan 2026 09:32:57 +0800 (CST)
From: Aaron Yang <yangqixiao@inspur.com>
To: sj@kernel.org
Cc: linux-mm@kvack.org,
	damon@lists.linux.dev,
	Aaron Yang <yangqixiao@inspur.com>
Subject: [PATCH v2] mm/damon/paddr: initialize 'folio' variables to NULL for safety and clarity
Date: Sun,  4 Jan 2026 09:32:55 +0800
Message-ID: <20260104013255.16962-1-yangqixiao@inspur.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cQJkCsDwJ_dJw1lpIl8OAA--.16032S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw4kGry7CFyxtry3Cry8Zrb_yoW8ZrW7pa
	yxG34DKrWjgFWku34DAF4kZry3trWUXF9xCFWfGa4SkF1Sgr1kKw4UA34UtF1UZryUGFs3
	ZrWFqay7WFZ7JF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyq14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
	6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AK
	xVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU5WlkUUUUU
X-CM-SenderInfo: 51dqw15l0lt0o6lq211xuou0bp/
tUid: 2026104093258750103af30d165705e1226229ce3c5d7
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Stat-Signature: wxinxkn9siaococ8y4o7fd8dhmuykxxc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8F45B4000A
X-HE-Tag: 1767490384-27896
X-HE-Meta: U2FsdGVkX194dCE0GSfOrjOvbIhHZQuIUVHQgsgHBV2TkJojbFAZXHFhauiv3WwH8e9ZmHG5PqDuXwDuaMDiR5jvU0+lQh7fVEyzgOk5CnwtahyITXxKnVGN37WCPT9Jv65izwrLIZIVkjipIoY8SUwa27mcnpCwGULLhm/b001waNJHtYqaQ/CJLo6titzESr1OvWA01fJ8KAGikurERBWwJsfRzPN85jcF8PGpKymGMGxpiILsxwpku76b8p0Qcr38Ack2bUa8BROqfW6y+oL7yT0yp8G0+ioylg8MZLsgexhi+d2OKh8tqYMZr601iyImZuAgN0xSBRnV1r9r89P+N/1fNrgFyzPU/UFromREJ4jUrjKRCa8tG4pl8R4/1oxtpic1Kij7x1DiAA0LH7sOtN68vfX7jTx0DFej+YBAAy1TiGGUXSAxVLmeA6TLt+lZN9U/tlc0v4etd8yeT0SA+Yil0kUF0i3hnRlZBL/rNzIM0g4m8bLox2jx2y+3FdqH7+F3Dvn/7zDRmBFUpx/Rkrc1aNfoaMoMVRetLSJ0RUaAgg7Gu9iED/tp/fVt/yula9jP3egRS7q5DiYw1nR2qFRuHOECFbiCkLc+S8DD88GAzFnDtjIhpXgWpIy/wOQwj4paSggY8+2ew7g0Hz1qjdNJIN+AFpz3qOu7NiySgbqk2tkO1yFQu/Xj6G8/gtfT5g5h97nmoMqBWnafY+dGXMOrmxjTdLsycXnhnePmBa6xi6YTTD6vqazck5+xGV56ZwFfSWy3KjadHIYhzdz8YFEhdRwkLcrkzAcIflanVgm46BE8+JisIU+/dIAj/eTHdxOk8lz6XHUWAv/PNovb7Sjy9YFPy2o4CeI+M1VpxeZjwV1Gu1MwTaGVTtrjp3fPx/U04p0Jvza2FxgXq4mUhpvb7wUcU5OO/6J/IVseoafkf0GpEx3DPiuRJ3Ze5QpQm65UC8vJqQPny8t
 hz9xvPvi
 P8wzdalVyEF7Ysdwp2tAPtUM0RT55MYsOttS2OiMrlESrZQ94j1zshnZ04WXEa8+xLA1qgHSyKm+Rr2uZzTlmR9wN3S8X3daS5wm305c97UmlPh+ujLSiP9nCwfah5iyAu5cf4+sJTRjjvxo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In damon_pa_mark_accessed_or_deactivate(), damon_pa_pageout(),
damon_pa_migrate(), and damon_pa_stat(), the local variable 'folio' is
declared but not initialized.

Initialize 'folio' to NULL to:
- Follow kernel convention: uninitialized pointers should be
  explicitly NULL
- Improve code readability and maintainability
- Provide safe fallback (NULL assignment to s->last_applied is harmless
  and callers check for NULL before dereference)

Signed-off-by: Aaron Yang <yangqixiao@inspur.com>
---
 mm/damon/paddr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 07a8aead439e..7d887a3c0866 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -156,7 +156,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 	LIST_HEAD(folio_list);
 	bool install_young_filter = true;
 	struct damos_filter *filter;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	/* check access in page level again by default */
 	damos_for_each_ops_filter(filter, s) {
@@ -212,7 +212,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 		unsigned long *sz_filter_passed)
 {
 	phys_addr_t addr, applied = 0;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
@@ -262,7 +262,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 {
 	phys_addr_t addr, applied;
 	LIST_HEAD(folio_list);
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
@@ -295,7 +295,7 @@ static unsigned long damon_pa_stat(struct damon_region *r,
 		unsigned long *sz_filter_passed)
 {
 	phys_addr_t addr;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	if (!damos_ops_has_filter(s))
 		return 0;
-- 
2.47.3


