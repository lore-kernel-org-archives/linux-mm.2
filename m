Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 687D1FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31376B0092; Mon, 27 Apr 2026 11:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08CB6B0095; Mon, 27 Apr 2026 11:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46206B0099; Mon, 27 Apr 2026 11:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B58E86B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:19:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA9661C21AF
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:46 +0000 (UTC)
X-FDA: 84704677932.11.37D82B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1B0E0100018
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T0+kdXmE;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5C0bNtro/Vh0bVJQSmLIuygBXLVlaP59vRRwgXe0Mlg=;
	b=7CrOFcn/f7cv7vyLacnWIvzXqGKWnfMo8p5lgK9eSbI518ke3mKZIdaIipmZVED/kkgnPY
	mc46BNEGjt/GPX8vYP7NamZ6QnwttFvzz7ChxRfdSmg+j0T/2xA8z786IoiUJ+H329wawq
	Z47+xcnxGPRH4xi8LzvHwYRubFJMsmI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T0+kdXmE;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302765; a=rsa-sha256;
	cv=none;
	b=imoMtKunn+Vbqlm5UTkiqiV1KRFYFpuiNlz3m+R/LUa1n9sDKnFZLYh7zlYyC5OFL0EhWO
	ENYJ75ePx0GgmHKCOn1O1OYs+0+dRKW2AXukN4Jqo4AKWLH/wzQ+3qEo0s6tyStCCQp/TU
	31hTcJPUrpexcsVq8fUJN/ZWGZtH96o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C29E43D4D;
	Mon, 27 Apr 2026 15:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA46C19425;
	Mon, 27 Apr 2026 15:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777302764;
	bh=+CPx6XCIAlUTHv2UDUveibU84QomoA79cOtNOXMz0F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0+kdXmEj4DQIjQ/GIyo9wxd8IEjbDZ4/fFiVGkdnvnCZVRdIJARPqoBKpGn1Kli5
	 jzMdP3lqYhIzek0d/6R9OibhGx72nqPv9oxC0wnqPZiSp+DkmbPop8aUNlTfiv+wsd
	 PK6590bNuJBWUCVz+j1ywLYHQqV4l3RzvUdDM7dhGvrWXe5Shmi050HXgYZ28iDpGY
	 HTXBYeLFzYcdKGd14guukErq7f5ccq0b1jYoIjCjGgNSU5KLdpmlMXG0nmusX+zD/g
	 QwIfvkO6LT4/961FgTWgpy9v+DwzUQYqbVvVCOx2xJIMXy80UAtaipfnxIJc3JNXAW
	 xNJVWjzPLYw8A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 09/10] selftests/damon/sysfs.py: check pause on assert_ctx_committed()
Date: Mon, 27 Apr 2026 08:12:28 -0700
Message-ID: <20260427151231.113429-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427151231.113429-1-sj@kernel.org>
References: <20260427151231.113429-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B0E0100018
X-Stat-Signature: akgz7nbzth4notsabgnicqfsi3birn7i
X-HE-Tag: 1777302764-620741
X-HE-Meta: U2FsdGVkX19qmFPoYYkB3Ft3hwds8qQHp+YMxZf9jz7js81xtp9SUt87teVu/cre4QG1k4n45Jmpv/WViAKLmDaHTF1SiQaOaaLZCEJJJpn40ZIIH+m08UA+wgIk4bHYm7OCRupjh1w14NV4Qu6+PKnTZNYktwAzaRMWPMO/3PBVt8vynwB54JnlDPfOqsEr221AtYAAAjROHU7wUhjs6BGn90UPOMZe9F2q0WojPQQA3LzTCqkydfa+AZZ/CGSkyygapH3Ubz6f1Lo8j+Guv/pfEJo/+gv9576swjiv3ckYUl01vs8JUFg87HM5fdYLVeGQ+Xvr+oDi6F9MPnWIvJMbrKlHh4Wvhx0PFzKW5Yik+sBE31rES0vkXnsXKnBvEUIVx9zZyBSJ2xnXjr4PbvBIHvSsjyxc+RerJVxl2r+8wJZ25OD8uuMTP4yON09bdgObbwNkF7r791aoq+ZJSYg+FfXWkEfwS+w348q1UMWKz7dF59+12ET8JdQrfc3Ki9yaOksXKlFNFVO3B7rvbu6mpF5v9PQ8k68amR4W6LmdhV/cAY3WD+4WDbxdpwSF8SqJrqMU6GlMiqoy7kv1JwOhCojP3+JI++/9QWOaaDjaHBATGPnBzu16j5QmXj93F1AKidNypjxVfGaXtBrnVIGYF/DL3oIYGHxAhjtHlIH4dfdWFJ2Y9psnDuQuKsVtlVSTWebfy0/Zn+3YTngLA8Fkclgd4YCh5PoQ3ShFzonj19kJitrmHsxKWsVu+Bk6WpaR4H5UOLH3C/JabwvVrU1LzIvFZ3WehICX/NYgjWaCfU2gBTPlehvWrWyZZCI/GV7PR0TUKvsnL5PJD9cesRIfgjWsjRE1dXDxAktNxt9ziRMJMrxOFie6r+XGhuOisDvPxUnO86NhCG3Q2K3cPOn4j1XJ5rw8uy7Fo1jlmA4foz03Tgi1iianWfhboVXm9sDUz2qxM00jNb+6ZzS
 msM6Wrrp
 v/9bbkjlucXBk9gVqHpHVy4hHmWb2gpk2MAAJQ+gxl/lj2/z5sIMnjAzFiVb6uBbD93466C1Jl1td7u7GHW3cUiGJrVoinc2K2nICyR0IKiQ11x6rr4fxLI7e+b3mh8V4r1eWAOV+NLQDbAA8RAWl9DtJUDTi/dWBTp2OGQsYn+4oxH3y3a46pT239JHuI8WDDSPYGd5XFJC432nYDAVv7DNE5IxlTo0DQ/+VrcZkbxPJHkNIrHYkmsrfeshNNBMi6+FhmWa1lYTaHhsRlXYI1inyjr8nQHY8S2Nf7Nr87pxD4kw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend sysfs.py tests to confirm damon_ctx->pause can be set using the
pause sysfs file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 72f53180c6a88..5a5d2f2774566 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -191,6 +191,7 @@ def assert_ctx_committed(ctx, dump):
     assert_monitoring_attrs_committed(ctx.monitoring_attrs, dump['attrs'])
     assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
+    assert_true(dump['pause'] == ctx.pause, 'pause', dump)
 
 def assert_ctxs_committed(kdamonds):
     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-- 
2.47.3

