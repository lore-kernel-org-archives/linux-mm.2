Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A032FC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B5F6B009B; Mon, 14 Sep 2026 10:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29306B00A0; Mon, 14 Sep 2026 10:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F73C6B00A1; Mon, 14 Sep 2026 10:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 593216B009B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:20:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94D54A3BE1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:04 +0000 (UTC)
X-FDA: 85212577128.18.DF2E89E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id DB020C0009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NTISd//d";
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rrDgkODM8llf8jq+hclXZEjgX/fiBHh7K7zNkR9oULk=;
	b=E8KPy/7NgWL9yAWhlYmXBvjZ9FazY5aMossc1coyM/PuFrGwYwHEcPzrFgQRvXoCmjzrlU
	7TmRJHcqwnL93NLQGlEYZvPJRwba5ssSdYv2wyp4oqN/sw4awXSxsh5/9wLgl8QCloYm9r
	+nnRdt2tbg6jmdrvTWjTf7E+q3dOOJc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395602;
	b=PY+Ygh7Afbv0Vwbg+DjJJxXXb3smXecRlrQ3LJ0CKOozR8qkfd9ig+NLyhXtfF5v4tQ4Qm
	OE5i/COFmWGpQ15or+SvFqjbGWhl/eO+Zgfz8gq3A94cSU0+iTYL9hUyJAcrBNBf6mDxz/
	NqA/MknL8W3+PRPyCbjiCzxgevbCFn8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NTISd//d";
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCC0B43D8A;
	Mon, 14 Sep 2026 14:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFDA1F00899;
	Mon, 14 Sep 2026 14:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395601;
	bh=rrDgkODM8llf8jq+hclXZEjgX/fiBHh7K7zNkR9oULk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NTISd//d9p3BIEpa0p/qxDk/GpV/LubuO5kaAosPlh7zMJZu4RN5PxiMOXsAmYxHr
	 PEIB2PhPz8qz1huxQTukkSECJjgsViJnj3edZLoC8fQHsLE/GhA/pkWel1fyZFYRNX
	 PjD5RSc6MZ2GklIkHFAn0YY0YmF1Ljwh+fu1QopZ4u8kWsodrlRohmnqGT9kxz+9gP
	 elMt/MR6LAI2KIl7yhDF0FreaLTVo6BuI/rBdebioTyW+lg6CRd5dzvQ1oI2CvPAFD
	 rKtJHxGMnFOYPGVpVaQwkcGiV9aYBliC6Q0UAUQpv9mMKCQCXl69TQqKFrPeLLnb3p
	 8iaOcc/QSUj+w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/6] selftests/damon: ignore test-generated damon_dump_output
Date: Mon, 14 Sep 2026 07:19:47 -0700
Message-ID: <20260914141952.91465-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914141952.91465-1-sj@kernel.org>
References: <20260914141952.91465-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DB020C0009
X-Stat-Signature: ccum6jbwp5y9iuk56nw4gg39ya9zsgqs
X-Rspam-User: 
X-HE-Tag: 1789395602-735504
X-HE-Meta: U2FsdGVkX1/IEjTlsNqNkeC3nX2bneIZY6cZ9JuOE7eOf4egMqlvPgcddYsBaNmXiyf9m7w67zEx6O5FXgGvgQEUFuhkkDIzt9wfYAJlRffhmhR1SToI83413ujO2Cq0ITTPQ8odIQkDwSESoqZ2h7kI3ArqFb5IK6yyCKkzCbE5KvnFAzOUJ+kjpPOCWso6u/08xOzkuEjQMHfOVqxXyaY/domQOz219tbrx+hSYJy4K3Xr+sEY++Mk/6fq1+PZtxNqheNR0f8Mw78mzW/rNLQw/S7v77HsvAjWtCeZzr4K17wBgoDaY1eeUp3gxpfTWA8jwGOwRab6rl37Ro4mW79wlFWIOiCNfCo7cRGbSSOt3umt9rPwhFcwJJYj40F0QKMcq5bv1ZYcIiufLTkYMKV2NKhkeBuV/TLBlc4OUVcEPRMDHJTA50ykDzxdNwdHb4MEt+9mgejYAkURelcodgb+QI1k0IbrelOA4OJ122eRLct6FNJyeE36uJYFs0fMetEOJMOo7N0xZLxezAp0Pio7tTquYZW9Doa6uArQ5QlFln4oGewTM+nhuyBaMY0q/wY4N9w7Rcmsa+HM48SiMs3Z86YV2mce3rRfRoqDle500J8JqaDorFCtZwm6F/aygVwssJ6n5L69q9to4ynFMNUTuMH6RlsdLzC4Zg/2BePcqRZqXB2V9XqY/07o7CsUQgcy3allomY9bAfewsT6kTYONT9rYUHxPh7Z8Ue7Z+1WPC7HwJyXhNOi8qKTvaFQghMHHu+bSRWaUpppL9N/yuh1L4QIwQAZvo4qsg3n79NFqsbxMx0wk8L4fXLMLNg46OwzBb7bfpIMN7Emzak9FzDAws6+EjFbQRVqhyYuecgNaUTA5DLxAdHsIC573DY+y69HDuYpt7rro9JKseg5FIMqgzKO5/gyCZhX9EPBNbgNQO0mA/kGVMW5OmL/rTwXl6Ke+aiaOGEjbTXPRve
 f5uPkdg5
 VyLrlIqQTRSogSq6i2o2REMHo5zbgIL4/ZPb54f/DjjnCaVhkiPVI3IXBVKdg9XYe2drAWt5cEFUsnARM1K7hpFBubo8XMWWVXRzgj9hR8pBKu7jSxCi5h75jO4tg62/TArWaZa3L/lGiaJddSj5eQPxOQSasiotMbqizxecVVN8IfLbpm0fy2zPXAMrurSw1VQmLIsfTW+mib1FGTMyDpT3HuF6OsF+Xat2Qg44tIgomP1S1oYYfgBHEGdqa4BlodWOhZum7XK1TgAkdQ4x0zJzKfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

sysfs.py and sysfs_no_op_commit_break.py dump the DAMON status collected
via drgn_dump_damon_status.py into a damon_dump_output file in the working
directory.  Ignore it so that running the tests in-tree does not pollute
git status.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260908162716.85648-1-zenghui.yu@linux.dev
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 tools/testing/selftests/damon/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/.gitignore b/tools/testing/selftests/damon/.gitignore
index 2f0297657c816..226bd7c4e0728 100644
--- a/tools/testing/selftests/damon/.gitignore
+++ b/tools/testing/selftests/damon/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 access_memory
 access_memory_even
+damon_dump_output
-- 
2.47.3

