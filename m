Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7CD5FD006E
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 17:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649086B00A4; Sun,  1 Mar 2026 12:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF716B00A5; Sun,  1 Mar 2026 12:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A4B6B00A6; Sun,  1 Mar 2026 12:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32E296B00A4
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 12:43:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D05F68C333
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:35 +0000 (UTC)
X-FDA: 84498216390.22.EDB3133
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 40F7418000B
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iflq3Brx;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772387014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rfsiGmhc01BRcFOe+jthn4zrRso6eCF1denja9H0Zg=;
	b=Pm04hcAsJl4mHQmZfI6z5HSOcS1WQpWIUJsOmBWv8Pd3nfj6tMPtst2ShBnnKBffjEh7fT
	Ma3PI11nVLsMrlVKx5FSWlvQsqsZlNns9VawX4PUA+8oQ1Che44FNrlRgP9YgfjbdXLqQp
	w56i1zeu64vTcfEsGc6DjLnvN1hJ0oc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772387014; a=rsa-sha256;
	cv=none;
	b=IngUZssAO3E+QDzwUhDIu0Uw17N2yUVXb/Nm1NHnnN7/DFL3N5sfRGpCo/nIMlAjxG8mA1
	yt4kTwq1jeRNioQPmypWyETnuRRDlV5OIRqw7aN8WXxakBiZVPIg3f5Ap7enNS09IKCbJQ
	uovssOQ6f4EPN3OBwgZaSyfMu6YEraI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iflq3Brx;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ACBED60103;
	Sun,  1 Mar 2026 17:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38375C116C6;
	Sun,  1 Mar 2026 17:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772387013;
	bh=BLMf6S2CwC1uRw1Za6T26Ewe+0K+xw3rETEPypk9tzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iflq3Brxo9v9e0Mfqjesq+hY3p90YdnXS535vlVbTEuioLgceNNQroRt+5JdpDq6L
	 Mmghe8B56xb1WbGO/NbtDHcSjbRwWS+mzeibZ2o7xiuAHmgjqj5qCJLx45kZdDcmY5
	 ixbsWkUoWAjromzZ4wqUmoTquiPG8GExSrHuPhv0bFo0J2sp0fUuqfNzGuJHnRA6xl
	 qJcdKkelnJlqOVMgVcto0VlfV4ojGDKwoAFrBiESTZo88u+7ENpj/qis9uMyTIxMJH
	 fOh5L38XoIlbFD9+PxBX8EvEynktGKPY/5+pyAbyeAGzrEyANA2lid5KpVESKkbOoK
	 ZrrMGRSn36O2A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 09/10] mm/damon/tests/.kunitconifg: enable DAMON_DEBUG_SANITY
Date: Sun,  1 Mar 2026 09:43:24 -0800
Message-ID: <20260301174327.76849-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260301174327.76849-1-sj@kernel.org>
References: <20260301174327.76849-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: iitrmd8anno788rkbd55gq1ad911wm7o
X-Rspamd-Queue-Id: 40F7418000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1772387014-919867
X-HE-Meta: U2FsdGVkX19Q+lYwqF2v8eB+pbeCMJhIPIlNRoNlEKmaqBMcU+qUENd1Bz9c5TRg4/NHHb9hmJR1FQtNwlrpQwQB3XhMH4vXr8ZJDZOhc+c6uE+jUObYhzevq70+JiVStaYRV6bSpwEjwEk7qN0kW+Qgg4hgC00c09zTWhvgA5ZkA06BW2M9sYkC/aN+UsVr22GKn1AFaA6PZQJJk7bmqugdQT6TqcWhMeSidu8vDdta1VRiatVjkGwYbtCYmz6bjH6ea577el4YspOGVKzRw8y9hF+U33OjIluNm9PI3damx9J58RCGjG/M2fHnYtpmqJ3C2iqH9vgfT8QLAqyid+TDa4pJX9GLXkDOlwPJ/DuCSah1ACGDKSzIhCEXjmEpDEcrsbNF1+iwcWt4O09IQqUHzTtb5bewFTRpc5131cQ84Fc7sCdL/rUlSyvEkENUFWVf9cAcPE5hCHb4kWPqFS8eCtiYOMFd/HJHgYjn2GJZJ/Ur/2cqwgDXm4zgfYOBRXGSWEx9KJIdbnnBtOjeLrZJEjgQ/56Rd9b21hOBGUyunM5jMPbtDb8sCTjHLz109BMvD7GOf4VjAIv1HEfu6HcJiYHh0Z+0q2R92UhUUavpE4Ci2VVLBgy3qrfIaufbQcCNTNsEhsBGNcXdfQEN3KipqfbRpIg4BwawA0LmwQGSryFXdvq5LmSsGucBv/k/9fsiCMgoLNMCGW8dqQnmJe/Ve0CM1uEx88ulZRveLyeR2hRg6Hrog4HEdX/3amssiTZBMR5g0WYc7BCYfDKST+Ta8pOVBgSqNHVmTL7uOXkXIvkVqWvo8JWR0vOvyQkwj+GO7YDmeZq1aJkjOpY5UeO2Tt/8yMP/4J8rpINIKl2YVoS0VmEDLhRqtNedakhCZXcplh3yGThkKgRxWe1dpWyFauZc6FDIZzjFkrLeHd8m/RHNkBrQfv3XzKTOyMQlCX8AITCJJUaFx2lV3HQ
 zAgubySE
 F3zGJcireJIBVkQAmrQevwrOHV3m88/NC8bgzqojwC8Y/7jgRVxNGpQNfAsDxBf9ogVyb1RlPyW7xRO/SkdNgjWLTYL76yZqPZTj9s7q7VsXB6pqHgzc3uGJbYPd9aAJlk0pQVpq0EBvmqDsiHeMI7/1EXma2Mra7SBOGYeqXVeGD8qlLkP9zpCKC/kKW4+D7E7eFVOb4GhrXsHzS327fJJ62ptk4Bp6kFdxzXA9/+cTWfxrYFNdiScsH2qTDPbOIdKoy3vgAgRFZmDQZ/5jc7CjUsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_DAMON_DEBUG_SANITY is recommended for DAMON development and test
setups.  Enable it on the default configurations for DAMON kunit test
run.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/.kunitconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/tests/.kunitconfig b/mm/damon/tests/.kunitconfig
index 36a450f57b581..144d27e6ecc5c 100644
--- a/mm/damon/tests/.kunitconfig
+++ b/mm/damon/tests/.kunitconfig
@@ -13,3 +13,6 @@ CONFIG_DAMON_VADDR_KUNIT_TEST=y
 CONFIG_SYSFS=y
 CONFIG_DAMON_SYSFS=y
 CONFIG_DAMON_SYSFS_KUNIT_TEST=y
+
+# enable DAMON_DEBUG_SANITY to catch any bug
+CONFIG_DAMON_DEBUG_SANITY=y
-- 
2.47.3

