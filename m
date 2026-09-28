Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC669C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B357F6B0099; Mon, 28 Sep 2026 05:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE5F16B009B; Mon, 28 Sep 2026 05:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986C86B009D; Mon, 28 Sep 2026 05:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FFE66B0099
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:34:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01362A38DD
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:34:03 +0000 (UTC)
X-FDA: 85262659608.04.EFF35E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5975240008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:34:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O9E6n9xV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790588042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p5MTFE9QQQXmql1Ff0uVbm3O82yXZG24baiyBpjdw2E=;
	b=GNclV9JvYOXmZOTeZAMRJKuYjq5sN1HDFJdZbbkr82iSA0atK/wbgxvocHyZaaGaA+M8kf
	iWYpqhKI+4FPMsEMs7iyw7TnIP2UzHb59tEXhwv3Q7XbrGXtaAxexwcAUuuQAfC+bbl8Fe
	m2DhgzH+fWgPzpzXTwQSnGOmy8a234M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O9E6n9xV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790588042;
	b=h6bZ0MpcWXp+owBMxlUad/SBO4QJOP2bgmYkJSPEqcvE9mL/SLbKdg7RUIsLU6oRj5Iogs
	+j+fC1e5oyexqkH4Vud3qUBCRBek9BXInZDKVOxmy1sTmZV3bziuowcvSXTg1rrR4WmGG4
	cbSAQaVzEdzPFYacmI5cf1L9nZulf8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A545343D14
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01941F000FF;
	Mon, 28 Sep 2026 09:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790588041;
	bh=p5MTFE9QQQXmql1Ff0uVbm3O82yXZG24baiyBpjdw2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9E6n9xVHmI4qghgOJVq+/aVaJ3uVPG9P8GSDc9kmo9JcGqxlY1Qe7rFkowHkSL5D
	 jzFIwR0AdtIvjcA/8qaEyXmibfWE5wV0EKbEiv3CNFXa4W7nXpaO0Kh7Oor3ZFXU1c
	 elEye2koBx7wgPTiv65iQVyvam9fL187swWSNO9E3G3fY6l01uckAB8gTy8Dp7TY/X
	 wzGFDybTjwSC8Y5K++v5AXq5078d6oGGsbiRQFE3oM0XM8wZEWXk12JUQ9bW2LKN94
	 Uhmc7spOd/9CQ5WwC3M+XjuBGGX97+FYuoHn1XGgBUJ5Zp/TL2iGjHuQgsp7H9FTmH
	 MLZjSlb5byjhg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 5/8] selftests/damon/sysfs.sh: test quota goal complement flag file
Date: Mon, 28 Sep 2026 02:33:37 -0700
Message-ID: <20260928093342.16584-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928093342.16584-1-sj@kernel.org>
References: <20260928093342.16584-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5975240008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: z1gx8ookpn8kf7nopuoyffw4dko1qom8
X-HE-Tag: 1790588042-607560
X-HE-Meta: U2FsdGVkX19LYesCNs7H9XTGABGfxwVeuX1rFk5EQ1/QX3+K9m7RUW2X5MVwnRKhSE6EmzPTTYT5/b52fsdjeMJdY7eAGGKkiZbkZvPNB75KTJl7kahefzpX/rV3wwewRyE8c1KzC99qNMokxdhG9EZCjiW/7Gyj5c6gV2nSewvxOLS8c5YPtAhGLhv2UoGRn7yYDVFl9qSCucioZfGK08GCqZDYFjhErUdi7G0wBuOFpX6jgRwAyt92PkBlMJZTbv3xZKPocKjHfbePGvdzlzww2EDp0CDheXXzDSPgaHPVQnjopa1/KkBD12R9o8YLs9HEtF7uU5BAEyJ7OZUS2W/kwXq7rqtBG2/gZUr/tJ7HWCcNgvYrhwl9YICIC1ceDEqMSkPFRiAmxs8gtYj6CYF5UhV6UIKCBHKyYf1lb1d+LREBQ+35rJ75Rdti+VEf/1h0sYi4o/0viatVmnCshi7WMDbsNcQeI+61SPH0QuMoVnnqSQdUrPX9B+rcMmUkQ6sf+E42Mp0CxpitlSKkFEXmThsLvOoQ9CHERws+qN5/uEu9Zho73N4QVvbAnx8XBYNm0TehCI3+hCm3PiGYp+821NvaE2f6IScqyw0+UxwByQ2uDT6WMMim8gy5PF5Os9n+g1x2Z9NmanWdYgiPMobka8YoIx43pRCDGQdzFY50CH4Rca3fRcxNvWiwwrgYOOV8H5Ff8bKZevuRAKOW9OtBYcOb79TQfAGYqjyFCtldUIXheqDw+Z0oPYHYH6fksq7iQa2yQsTqBb1YUhtZ6hzYIJQ9l3HTqMX43mJC4BWrKJ02T5BNqkAmMcWnFcsXvSLSiS7OPPhDVh+2MP+nftx+pf//4EoDhcGZocr7GGXCAMiKPIxrACiIpX3R/cxfbOt39tuh40xCYvZ2ZY58SsgCT/rtkGS6cuEvnULLJ2I8T3gkbXDCEffcYzsyFDQZsYuLduEwlZAD4giC/O1
 gu3I/GyC
 Fnm+b2co/bN8DhGEthHiYL1c8eGhlWQDfYallJUaTNOc847+cNsCI+zc2jT3O63Zp1dNM/ZPb2TLOKsCQgMF5naK+0445rp+08CMb+g0paUr005oE10wnxjeZ7gRuTCEybMdzNrsjn4k/QKAakkzm07pJgABbJcudXT2gu0JpZKwj0faQ3MZXEajcdnqK2jT2NHSW5ztwsVMeRuEQXnV91857XeO8fzApUyU2ggFXcMq35wW4Z38xqcI0WOKZledNL+BxQb6UDeTwPSoGGJtr6LNlnWZaFPzTFhUdKcezLqpl1Pw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test the existence and the valid input acceptance of the newly added
quota goal complement flag sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index b66593c9ac47..1cc7ab2d7e22 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -212,6 +212,9 @@ test_goal()
 	ensure_write_succ "$fpath" "node_eligible_mem_bp" "valid input"
 	ensure_write_succ "$fpath" "hugepage_mem_bp" "valid input"
 	ensure_write_fail "$fpath" "foo" "invalid input"
+	ensure_file "$goal_dir/complement" "exist" "600"
+	ensure_write_succ "$goal_dir/complement" "Y" "valid input"
+	ensure_write_succ "$goal_dir/complement" "N" "valid input"
 	ensure_file "$goal_dir/nid" "exist" "600"
 	ensure_file "$goal_dir/path" "exist" "600"
 }
-- 
2.47.3

