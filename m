Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB5A4C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43AE46B00A2; Sun, 26 Jul 2026 13:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB896B00A3; Sun, 26 Jul 2026 13:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300E96B00A4; Sun, 26 Jul 2026 13:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF48B6B00A1
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6927440559
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:51 +0000 (UTC)
X-FDA: 85031640582.08.59D8237
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id CBD0580008
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g34Ox6rY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+OX/QoubOtPs5CYX5dE9pYfjfAmb4FTinvx7UvjP30=;
	b=OrDNv3ES+92UM5PnkmpofF/xz9nk9qSKPf0VOdl+xKAQghaVjV0lM5rqpNnNp64beIS95U
	q9iTTWwgXUGfSF4R22Xncuhe5NbKmDDaBSMLHihpobp3SO5yfDGL34Nl3pHrhh5COCaTfQ
	zfaw+9Lgm23wH3kgBcxsyzqXz1Olbu4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g34Ox6rY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087589;
	b=q8dyiLUQ6Pse8grwX9bGuV6+HES7EKPHTK5quzXtJrE3daimf5w7+is1UNfQAZ5GWUhTFF
	fedDA47M0thPUcvtyTFvA1Kvy0XRxzMOGIXXZuQd6/e9UV/44voSBGdrdZZcezeCuPeZ3K
	HYUrMwiuIz6Xo718DN8rG86TvAZeJs0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3285C43FDF
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8851F00A3E;
	Sun, 26 Jul 2026 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087589;
	bh=m+OX/QoubOtPs5CYX5dE9pYfjfAmb4FTinvx7UvjP30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g34Ox6rYaTdtXgIillaKFACK89FYjuaLjH4TKJlXhLKprR0mcQKQOzClX2DvkNQeN
	 qgn24jNKvu5w0pE2iDwv4G6oxMIahAf/oSmMlTu3eIGH+3FuLpE1GjUWEQaB8yG5bD
	 ll0+YDwQj/L1wHGfBXcJNPy39n0mp7M68RlU3d3/duWML0f7gFmWzB4g9AftNjTJNe
	 kS60v1/cyXIuqIsmmIUPY+0WFY4oQ3VP+TTxYmKuH7qAvpUy36zeqe53/ki5qGLPAr
	 4bcKtc88AUuUgyN+78SEM3S5Eh5xqhhbdfLgnuNF/XSr7QDBOHRxlpig1WsPFiAMuj
	 wC5DXd5YOEOeA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 14/17] selftests/damon/sysfs.sh: test probe prep sysfs files
Date: Sun, 26 Jul 2026 10:39:30 -0700
Message-ID: <20260726173935.94046-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CBD0580008
X-Rspam-User: 
X-Stat-Signature: minbt45g5net7zkq56es4jbyzah5kit7
X-HE-Tag: 1785087589-448932
X-HE-Meta: U2FsdGVkX19AdWJs6rGjh6bEaW4dJ6FgHzxx8GiQkiWaf9k4VaaPzDUQhsFkuVbm/M29oXRkkQ8T2JzFHsIObFEZOr9TxIwGV5DgNXbT9SF8kPJidoRwpr3wh8lOOXo98X1AiSLWp0fh4YfE2tLjhoi0PfuHhWzeGloB01Fm/i0+lkuYII3g3jEvsAc46TsPahf8XFx4c4YbzslXhY72r8cH8IHBPD1kabuTZNlai40/T/0uTy8YWQlKrgE0ZYv9bO/tSQoQpxnNX6dzRtGVQOyA1G6aetsdVTL8rTlMUHhey/4SmCzhfF8561ktrvRlUtDAJ6lNXqhBKLzhN9E2JEeNCEi3Y2JZjuDyFrOiMMIrmfXtVH9sXLrypY/3j8+5/TJ/47RNeUq3k+roRWSGNXeRHtkcCOvUxp2GoUOzspED4p/JeltyLkmWYHaaREFC8AVAaCUZsWucpnUcq8DNmDEQMZo42M+QIyjb8bWkSsbB/NpymK8teKZmOxrwU9m0FXHbXMI/cDYgm3lo6JcJctCmLXaUGNg483A0JLdgMd9srnu+Rv9jdpd0ujraqVcFejv/QI11PKHSO33v3Voza3O+eiIIZZfKIizQtka5kKS+zD2bxFG9JIVBxs5qNHdwEp6RhDg0kEFTPw0sedZaEUDiNBoZGofcVM30FhMQQxsbTITGjrU0lxC51qwtiCayPdajEkhVe984irhInJ9gi6VJszUigX2Au5d0gsPRU+iiI3DEjNqdHBgCpWB6JIQk3q9CQEW0ao+64cX/6Z/10V9eEBnWIhkc2/S2ifXc9fcbG75wgYsOgmuGdkbV26glOkTwg84E+Vz6AR2xSWrXZ2SDpDJPwTYiUEMIW9s5GrVzrdhVAogwnR76qc834YpZo8t1nFDreZd1xQXAZKkKoC1/+qHmHwUtNR/yBLyfXTiftg/ybp+Pwv9xF13bC9FHVGq/XXGavONeubniDXC
 AqX3aFaY
 O45GCTOg7xH07827jQtIxIGFGrbrRpZ2KKxVsOvLzAwQyOKnaIgstIC3FQ7PGneEiVYPPonI2bWnqORPxWvQYAz8ML+gZOJM9XX853JiYIcoUuVYK4eMnmCX7/QnOPj+o1fkRDK2GoJpYpd+Bjs25Dpv2x3lEsuxrZT8q4X/RKw94VZcx2Db/QBtO+uCe/190j7u6IqFl0ZVNJf+S6hn72rr3Nv9oUEh7I6O0nGVcndgqUCsr2hjKI/Z1QhWEjvlCzRyPE/Gtb4idnW219Eph5EdX8DEWVnHDROKcjk/viVKBucI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add basic file operations test for newly introduced DAMON probe prep
sysfs directories and files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 27 ++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index f7fb94b84e716..ddebde6edabe4 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -361,6 +361,32 @@ test_intervals()
 	test_intervals_goal "$intervals_dir/intervals_goal"
 }
 
+test_damon_prep()
+{
+	damon_prep_dir=$1
+	ensure_file "$damon_prep_dir/prep_action" "exist" "600"
+	ensure_write_succ "$damon_prep_dir/prep_action" "set_pgidle" \
+		"valid input"
+	ensure_write_fail "$damon_prep_dir/prep_action" "foo" "invalid input"
+}
+
+test_damon_preps()
+{
+	preps_dir=$1
+	ensure_dir "$preps_dir" "exist"
+	ensure_file "$preps_dir/nr_preps" "exist" "600"
+	ensure_write_succ "$preps_dir/nr_preps" "1" "valid input"
+	test_damon_prep "$preps_dir/0"
+
+	ensure_write_succ  "$preps_dir/nr_preps" "2" "valid input"
+	test_damon_prep "$preps_dir/0"
+	test_damon_prep "$preps_dir/1"
+
+	ensure_write_succ "$preps_dir/nr_preps" "0" "valid input"
+	ensure_dir "$preps_dir/0" "not_exist"
+	ensure_dir "$preps_dir/1" "not_exist"
+}
+
 test_damon_filter()
 {
 	damon_filter_dir=$1
@@ -392,6 +418,7 @@ test_probe()
 {
 	probe_dir=$1
 	ensure_dir "$probe_dir" "exist"
+	test_damon_preps "$probe_dir/preps"
 	test_damon_filters "$probe_dir/filters"
 }
 
-- 
2.47.3

