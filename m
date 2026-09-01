Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23DDDC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E936B0178; Tue,  1 Sep 2026 09:25:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876A36B0181; Tue,  1 Sep 2026 09:25:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656CB6B017B; Tue,  1 Sep 2026 09:25:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF356B0178
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7ACC8040C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:17 +0000 (UTC)
X-FDA: 85165264674.09.E1DD345
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 14C5D140008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nJilu1v+;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269116;
	b=6Y7Oqk3L990bZiuQDGJv98l2I29QDD7z1bJWs86RslF+KpDwiz8ymUaFyebXGCTr73qL2y
	k3GuK/duuRoQUWhRQIhD3kqglXOK2OsaOGEsKhfyBeQLKnxF9NkUjcMe6gjQrG3pb4b16o
	fMGVhnA2pJpif/9sUZ/+Y+qxPNSSLQA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U+5n2m69nUp/8eBxRsZKrpQRqRxmZwpAKuJfK8YQaNw=;
	b=uLOUkKEzFDk61wYJMG5V0fp4Vl2YWix6B+hnRbZOK6/s0t0J6BfvqPVn/Veal6xLsMMhM5
	D6wThQQRwnLEZIb0hq2k11YMHXsFyIQ6YPyHuByGxP9YaeRivtka3XgoS72RzHTzPCIxEK
	vw6Y8QR3v3h4OxsfbSMeW+Fvt6NlUL8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nJilu1v+;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B21442E93;
	Tue,  1 Sep 2026 13:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05341F00ADB;
	Tue,  1 Sep 2026 13:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269115;
	bh=U+5n2m69nUp/8eBxRsZKrpQRqRxmZwpAKuJfK8YQaNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJilu1v+6XF9e5ByO9wGT3nwIWFxcZVNHpZo3jUMIZlqF50JJ5s83Jg/3dyBF7gpJ
	 jU19FtBk/WvY55inPoMgcixr1Erag2zLQ+QMA/ZpMX+WvA7QRQPH5J3TliUHbenyvn
	 RpDI1p7qfXSRnXMvV1nOgnN/Nb06J7O4EDB6w3pEx3MCC6s6fFzLsiXKMCEeI3ZSlg
	 PPEBOTmAtiNxD/+X455t3pW7X5okDfWPLrBwuQtj2tblIp2y910S+nlEGiPWF2q7CG
	 Tp6Rjnmn7KWTyk++9JJcKZ88CAGf9uijUnGL3rBI2agr9OAoYv1FW9n1VgBtNIzuNk
	 2sDD2cFb1rAPg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 01/17] mm/damon/core: introduce DAMON_FILTER_TYPE_PGIDLE_UNSET
Date: Tue,  1 Sep 2026 06:24:48 -0700
Message-ID: <20260901132506.99243-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 14C5D140008
X-Stat-Signature: wdnw3nxwqqdt1rtr5jjgp7peed41wejr
X-HE-Tag: 1788269115-184953
X-HE-Meta: U2FsdGVkX18kpzxY1tD+JRPYcyyj3LFpLbRVSL5+nkTRQzzUGbPpiaAOKEeToGe8MdHTFh+4fjsdbF2lC3JUPMY4kkHMgFccEiIR5wnyPpCjzFC0lGMJG/Xp90TPMdlLaq3VRkM+NAXVVzwT3ObVP6B4NH1gtaKd6JBkeHXMEonHaAkDnnn7LR+z7DlSHuj9uasx2tPvhcQqOJgkzLwQLtIeE8Gkbq5hGOOjnUna1q04JBjFn0A4tq6Pz2k3m8AaX6GJEW7fmAGZYYvydwjAAJusFCxHJYOQAMIQDTBGqcZGAzp3SKbyY16Iakbq+UaXk/uczpRjJyPjy9R/b8XHIVHJqjxc++2IdQdQhnzIof/n0J9AKlYB4YbiRUn138ArDj9R1yZZSL5vmOKEmtRWFcQBP3qxXNiEpaQ4vI9SqZCyMrQU7EhzBfSoleZVBSy/bv4pP2tEhtSdp+/0ITiN1JbSWnm++RhcJQ+1GPXR41I6gIXiZ1jkym6hoINIy5zFpdM+qPMiFh7CapzvsiE4V+5ru3gtCY5SYqAb1U7KuynGTxqkIU2XScGWFD9N7qiwTxUybCUae6TYMavHC6bz1fmUI/C/5/+iqEDDo8TZdJQvmv2uQQgvkdGws+FghL6XziwY1FFCLYyBetgypDM0zTiRXeRlodrFp8JIgLngj0spy5MvmSU/MSuzENtW1IGXmnGnEV8TiG0omd7y7F/hxkvmb9+CIINvS7vnKuV7fhecPEvbps82WLpiCKU8EQAzTIBlgHJKu9n3EdLtoNOEw55v2wFLFUjKQZkMKHcFF1iCs5HVBaFLfIajHU/5mlrT5G1Nkr6feJg9piMlUJUfI1SiC1J2mISItm3R5saBQKGA2wz143qWpJiZse2lRy64K8ARYBAnNb8p9DKmUIkjIyx6Ik6S0kxm7nHi5GIkrnx8DT4SctxRrxPAGZJGMoChDw31cW9hT3O0sDMaZCw
 0bLK00rz
 iGpSRHcYw5IW7UGS/lgJQ0NsiIZMRx6Wz6TrwacrI7xSnZM6u+R7lLkgeNmAIXWAogkXXMoGtJmV409QMkdLDuggVVLMDZhV76dZPzNWFe9zGPRJoNJVd1y54Mq9Mee8+yqxIuvVeBf+IjCvQ/Z1ajlx7xQDczwsLTVbHd+kZxDOHKFIEzCQJ7QdxTjl4pseTLpwX+lhGhm+z8F5eGQ7U7d1XrQZDmK9In5dRhBqgd2/Lbb+O08RbeMB4kIFfgtLS/IWDW10DS6zXlIKYkJeGugX9sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON filter type, pgidle_unset.  It will match pages
that have their PG_Idle flag unset, or the page table accessed bit set.
In other words, it says if the page is accessed.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 7b1b6050a8286..7a42cbe791845 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -745,12 +745,14 @@ struct damon_intervals_goal {
 /**
  * enum damon_filter_type - Type of &struct damon_filter
  *
- * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
- * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_ANON:		Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
+	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 };
 
 /**
-- 
2.47.3

