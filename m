Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FE3AD14886
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 01:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A990D6B0005; Wed,  7 Jan 2026 20:31:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A771F6B0093; Wed,  7 Jan 2026 20:31:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0D86B0095; Wed,  7 Jan 2026 20:31:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C68A6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:31:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22A9A59C33
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:31:07 +0000 (UTC)
X-FDA: 84307068174.01.A04613F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8CD9840016
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:31:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hTPXBHjM;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767835865; a=rsa-sha256;
	cv=none;
	b=r9cIjiYdzQip+e7hqkyskB8n8UG3XIlFrop4NOc3EVLWvz4p2CFnMPczFL7knsYxXWHcW6
	DAkNpYAdtJXIt/X2Yan8jJl83sOKSlmN3bgymsNS19ZUIFZnZzIc7+xchGGpFJvV1mRhP0
	ruyl0Pyc6Xr7KZAMQ5swdOQ8/D+e+NI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hTPXBHjM;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767835865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ulLtGSG4tuaXINOswzFrxzsSBBbwZYnR5M9P0Ll2Dok=;
	b=ecto+oUIDrbA0oMmbnCe02Ko2lABzqTLtt5obXBlLyJeT6hsIxq5hzHxSggcSwmLxCB81L
	0ehltvOqf9EeV69hqExg+pqi5b04czl2K0AxSzL6CttpOt7cb+XKy9b7IX9SUbJ/J59PCh
	zoVKTdf6jPtjPVC68AgghkoCbz7uQZA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 563F442B87;
	Thu,  8 Jan 2026 01:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11192C4CEF1;
	Thu,  8 Jan 2026 01:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767835864;
	bh=jqQybe765b7V3vpl7bLtb/2Dt7yGTpnbwerkN0QRAY0=;
	h=From:To:Cc:Subject:Date:From;
	b=hTPXBHjMS37oqA9nTxNB/orN4bD6O0KQXXtvraQGHyYTlVNA4nrkAvNL/+lN0uasA
	 QkZcyCextiroPHZB1lHHBkMXYXd9gjYdhjF79O44Nv+nMlCYdB6DzHJUI14lTEsKhU
	 /LnZyrDWWskQoPqqKcAFZOrYqi9fVT7Tzpb8wlzYVR1Bjz4eqRH1wPaTFqvXjjQA08
	 xCbvHW3tWt+xkVo0DW8hCmXeUXjMCqAc9M7ZssOYBvjpqPACsPN+89Fq01G9Juy+4N
	 pzzGqvKg0/O2c3jymEsOKCfw1IWUjzvFH/5w+WTwMMs3kJgjrOHlWDUvqxOCzBUUHh
	 Oep+kHjOrWjYQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Yang <yangqixiao@inspur.com>,
	SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3] mm/damon/paddr: initialize 'folio' variables to NULL for clarity
Date: Wed,  7 Jan 2026 17:30:38 -0800
Message-ID: <20260108013041.80601-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8CD9840016
X-Rspam-User: 
X-Stat-Signature: gckznqxphdhnwoctpc1kc7dgxy9qtqna
X-Rspamd-Server: rspam07
X-HE-Tag: 1767835865-693167
X-HE-Meta: U2FsdGVkX19m7TgjeMNdEpab8bp4zl9DRE48GjP1NrWzRo8ZagiihsYHRDxRgC9tDtazZ7LtlJ0ycAxGqMLx0a14MqxQBe/LkmrwQ/lZFuF3WBAaI2l9DDHqn6h+gNsEL7FnYPK9m80nP6FfYNwSbSu9qv6Tfmo499W9NFXhmNeNagsxxWn7hSst+5HwBVvsArVpZ15ZUulJfQtYmFuBRK7gqeDyZ7i+GALL3q8paVPEoFmjI4Iz0znpa0MJPw/keM0vuyCvE0k5A2/suyUVPwDLfFuihs+xldql8lxXEBnHyCarjMfj3wX+OKlueZ3x8UehQN1SQo7jZuCGyb4mWKOdtnqQdUdrI+ijYIa+3jM6ZyS4ZjKOV+DVBJ3OtC/EJVbyC3h440sX1n1BTPh9s/ajsbeggAHZvxMw39FrLy5SHVC3m2SoDiV4Wg6VzjINOtjLZbZbVFgRKC8jMMrzGmjIigrEGf/SstLRnv3VncgRsQtPrrfRVmrnNRxXv2bPoM7bhoSUyi1AzwGz375VnjeCdlswr8OfpirKF4jqkprNamPmbazhqZfePl0UgRZOMa2D3n5dDjtlCpPef1eRIRWDc3b0toKteMBklJ33k2B60ORJZS0TuaHg4pKKnWVws5zhaM1K+BS4zE+FUiC/+RRj2nTkmuRHipKYOyyxvypNQdNrWl6H9drXaNQ1lYr0IC/RvNeuCMVo8pLk5w9Sr5QSvm3joD83CvinLHrirkA19dEf1KU8WGqSNsVu3PoItPDGPGUtiVtyvEY11SsJcHDdAEftbHFzSpAvi4CBsuAwxEFH2+RGKdMxm/xUwQxx3/EZoUEV2g18H6B7b5NsxusdqG/x3SmhgIx0WJKLmQdLqj6M5ZmuQGqMD2DnKom7KETo2eHYqnynFpfOTZC4nhpKI9cRjQt9i4D3vh93RV3qftJvSFOTgXbMu/ID1Bs07EDrrLvPOnjT11fIj7a
 ly59DZQJ
 DGYb1nHgmG9/pc5I0zzbwb5JWAiYeryNHO09vlCNo+uDPMHQ2OegWecqWXOU+vOqXS1mkZW2nJVpuCEHWzixlj8s9sH135BDdlECAZvJXeC9j1ZEQYB4JcRwDYiNkmFq6opow3QO8gkoF+WYEWP/HGKfmHHLXtA4bFKgpXfB3764MWi0Y8YwxJM0pYz6GRRt4GF1uu+PxB9k+PQjopuba965wiRZ4FyWJSs/9nq62TTBph+kfiEiWZnBKdx/rUJSpWzvjYZ+nLA2dLPBemxy4NwlIVm/Lup1QDgeG5OJDlNXX7+LQS3XQhvaT7Rvy90RjQrAkVr/T60RmbHH09BC8a8RMwNjoa6bHJRGZLpFAPuuU+f51M/7cM5tNyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Aaron Yang <yangqixiao@inspur.com>

In damon_pa_mark_accessed_or_deactivate(), damon_pa_pageout(),
damon_pa_migrate(), and damon_pa_stat(), the local variable 'folio' is
declared but not initialized.

Initialize 'folio' to NULL to improve code readability and
maintainability.

Link: https://patch.msgid.link/20260104013255.16962-1-yangqixiao@inspur.com
Signed-off-by: Aaron Yang <yangqixiao@inspur.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---

Changes from v2
(https://lore.kernel.org/20260104013255.16962-1-yangqixiao@inspur.com)
- Wordsmith comment for the purpose of the change.

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

base-commit: 86666ce88b232c311d17ff74d74a2ef3215b9eb5
-- 
2.47.3

