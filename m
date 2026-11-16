Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB09B60A2609
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n2zSs5vd
Received: by kanga.kvack.org (Postfix)
	id 44BEE6B05B2; Mon, 16 Nov 2026 14:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32EAB6B05B6; Mon, 16 Nov 2026 14:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159B26B05B3; Mon, 16 Nov 2026 14:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D91926B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:10:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5281EC0200
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:10:25 +0000 (UTC)
X-FDA: 85441923210.24.1385EC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0A27CC0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:10:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n2zSs5vd;
	spf=pass (imf10.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794856223;
	b=lo9tF2Kul5LIoojgwG7T8FmwYowaPGlQXWJrAwRK8nJny2O1vMVOImZ8VoxxGeQgndXnAQ
	m+rKor5RVpYsPDLiuk0sQdQyF2cG+zRsc5P9fQ+B168FVOQpTQcG48VUf+AboNVTGHAVHT
	w7S3I8kn9hEGzprqdqJndGYDvHGHwxU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n2zSs5vd;
	spf=pass (imf10.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794856223;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wz3i43bWbACcxDrn6IQ1R0IGDWvmDnWNIz0h7uvXbkg=;
	b=ST3BXKEnalEGZ2xVXTB/QjpdZerXQbQe72Ej0fZLd0SP/MvpWcJQ0d86cKeQntZkaoqFAT
	64O7LpZC36JIng+MfnLprb1C5JZ/0E2Hzan9xLLp90QzgrX6UArjdWkCENfaCQxu2NHaFh
	16Hcclh03NoEW/qun8aghSk7BtQxaog=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D02144FF6;
	Mon, 16 Nov 2026 19:10:22 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794856222;
	b=htnaw3LAsFo/9Rn04Ccjq6yLTlEBa8gkMcKss2DR0hKX+R4Js1r/82dLJh9X9ljTkmuy
	 Kl9fps42TeUApB1JTXKRfzZjtCeNFWKWEeii2d0cUU4vRBNQrapMNG1ehxx7/byr1Pn+Z
	 /qd8PC8XB/fPegoTjFsdJFddTl2oRlFKnKVInhR/FFl+wiJlbMTUXSZ3AToOMbMga5ueW
	 FLImL5BTVPDhTm/dYiXI7oCHUOpbenxR+8aoYVlLt3ey74Fq2AMu2852x2e+fUEHrLmvp
	 4KTYk70cV6VQWuVLd+jg64pqmci/CT5fvCM1pZ7DSMTurDowYl2tezMvcs9T5KwfCnQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794856222;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Wz3i43bWbACcxDrn6IQ1R0IGDWvmDnWNIz0h7uvXbkg=;
	b=a8eGcGtsO4hDNQseLLmgqzUGn2CXZTJ0e7wmIKQ7LqODXEvuIvueRSGDwzs5wEJuhYLJ
	 LH//1vFfYJttiyNaPMsXbFZ0TtA/TERHsrmZOBLuLEbXUqxer1FVVDGCrnY5fNaB1sLOa
	 Q8Oipv75zxPOlwdGoFey5QyYCz8BihS3MzOULDY0AzdolX19wK28Bq71G2H8rNHILg5iQ
	 rd1SgTq8A426aIVtk6rRVqFA31pCBObrLhvJwq6l6R6LPmznOjoQ3b93qj+MfVQWR+a7p
	 z7K3GsUBViVBZx39REbExyRqu2p0hPYuWph+79D2wdUtnDJSx4wA2g04ca2F5oUyeAg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 17A291F000C4;
	Mon, 16 Nov 2026 19:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794856222;
	bh=Wz3i43bWbACcxDrn6IQ1R0IGDWvmDnWNIz0h7uvXbkg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=n2zSs5vdSdMdudyhPG79tYKxSODhCv60mMS4VS0e0KcAwzghprh2JN3lx8hLjOp1s
	 swOF3WgFec0q9DafwkDo2rBh5mUnWbcnTCrYdr8UBNC7sYPVfM86BG5G9uph+TMV/f
	 O/JUt83jWVg41Us3LAqB//s7aXQOGZbHIeAVHfnEZlvzLBqwf3ykfJJec043lGAFfB
	 cQbWnttj7YsgAzmVPRx5FV0gMElp3dEeZMbB7ScDTIPMQ0c9sB2JNLdc77Lnp+Pbig
	 9CylRlVQXc2KiJiamL0EiciODNH0WhgVBtGbSN5LRAYC2pZpijgCcaKFgGKVNkYdpS
	 8OHYZ6wc3zk5A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 947684A5A1;
	Mon, 16 Nov 2026 19:10:20 +0000 (UTC)
From: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Date: Mon, 16 Nov 2026 19:10:07 +0000
Subject: [PATCH 4/6] Docs/mm/damon/design: update for
 sz_ops_filter_passed_last
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261116-damon-sz-ops-b4-v1-4-1cffe7227e6d@uber.com>
References: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
In-Reply-To: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 Mattathias Pinchover <mattathias.pinchover@uber.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794856219; l=2118;
 i=mattathias.pinchover@uber.com; s=20261113; h=from:subject:message-id;
 bh=nwHjZVHHDRBT1eHlqqDWBt5BJ2Vcy+5/DHoQlewkkIE=;
 b=b0tvkQypc2c7AsnCXE+pq9rOaYIeO3iDB0Oj8qy+Oo2BDDoOAEgQn7E9EZf8uFy1tHQ24VVWB
 X5KJIE6CiWvBDh8V8PfnZmpjaQE2zudNNk0YZuofHhRxEiKtyhq8L1E
X-Developer-Key: i=mattathias.pinchover@uber.com; a=ed25519;
 pk=6Bh6OEwWiU6dpON0CVcoipq8fXtEgvhsM1Tmm9CTmtY=
X-Endpoint-Received: by B4 Relay for mattathias.pinchover@uber.com/20261113
 with auth_id=1515
X-Original-From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reply-To: mattathias.pinchover@uber.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A27CC0005
X-Stat-Signature: d37p5nd7yuqjush8i7zwdmdsb5f6pks5
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794856222-921977
X-HE-Meta: U2FsdGVkX190YwomDwcGrh4MdnHQXuI/JG7RhaHUP+hofDaAQGSfM2CqA3Y8R0uPSLMn9FkGVepdotqz7JzADpUG99OTKdrnrxwz+B0nss+FNTr3QxNPa9h7xxyJldVWd/VsDJa5MENdV2/N2uFf/jqBKZEFJPi9jKETJIdDigjlz/14HxlwxvkdczNW2gWXSUg9iHGFD9W9DrsB4iHRFzUAlA0ffqqS4ydpSaxEmVRzzgUpkhTUlwckcMNQL6Lh6XH5GK7DA0XS71F85f6/ksoMibKOGtkTxjkdkNfXS/HTNUrtJRf3FbLWE2pahP+R2M79wH9dK9miJU9uwPP2GqkrRj6CB068vI1uoGl9aPPi+FX1EseahcaoJk9EZn25FM472d1mwtn3fsDm+qPXZ3mpcrwEDaHOkr90BW5zylQM39BwnWPJ8SwsEZBztxaGs0wXgfJnCcRk2QGqOwYRb02smy9+G+QEfnsO9xYYoz7mh/cN/eyUtI8oEY2CYBkR/iAtnq1RB9vPq/7SZuReaUehTSxklxOANQZpe9a+YStW6v09Frgx0ujJQlfkVggdSnrS3e6XBlFNA+TZSyf8eaRaf9WteQ2T7XR9FZgdt6HBKtdqC35jvf4IzRvOztpd3+xmEqlLXLSai8yFoQqxk47ee53zcRitX5GoL0OfiIUu/QA7Z43qD/APQGrOU/27DMVwH1LMFocC9Hc/QPUeDyUjtbrHtjrobUDd3yQyTHnCLi2pmdzeG8qpmUQsyndBfqCkZKA29GSM1MwD9+rHRprBaBTzgdToCA2XvQ1t5at0c42A/p5EMw1RMt7rpwkb38HF7huKbOfT/x/QXBtokXDVLLQYqcc7PZ2jXRzI6LCVzRjXEi09dNGMmoHJCR7L7ABKJHSKHeRC2B8b+Y0WwAQX8QPao9uRSUZ74AfMPZlA88ERl1WPEWTnvqUJagc4DLI0pXbVMyZfkVC2BOu
 QgCFlP7w
 hf3MXzGMvx086+/DIb2Hcg0+WF8egfys4vLeGuxsyTs3N+Mmpzz/Kzay+MWl0LTPFUSkSPfaRkjCPgRDiJNhJmMC0v8GPTX2KjOHkrojMI5uz8a9QJV1THHnvYwhZc8qgjBkkhv2TkyuehbsBHt6ZY3uf9WK5dr+7QhuFSwvknj3s9IxD65ytoYwRdUgEEm431Ve2d6zqscebK47uyKuKqZfMcDSrENwcADliChzkDFp62SHt3nNquPACDioiaO0v6KbEZV+0Ow+pD8D9XZCmJiZdp3Ke+dfKtGlY0vvezzRx7Z1nl9Sbc9NmmCB8ZTZ1P90oiEkcPogSwp/U/ih0o06ICx2GQTNHKn9eiGn6yr47wGommes0yGK+vjfb9nyUfU9gbuCXEZ2MapR4Qa0GWl6jPw81bDxSEjemDQCPwXbJhjo4qbQNySgT0lxgoeRaFaXQFBr6Zf2NmsyCbAWngdpKsaqODXTsKkTAUwt4y9Ppo9bV9TdzYf49fwVODuh1pkjXu0V2fGWxbKslKsrCnIc8asbD7T295x29TfEzqXOD3gBJApUiU+mQUD0j88i95a62Pyy0PBevcjtW7sXbnf5s2DidJf9oFppwTlbd3l4pk3a0VTmfDx+XnsGb/r2l1SIQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

Update DAMON design document for the newly added DAMOS stat,
sz_ops_filter_passed_last.  Also explain that, unlike other
stats, it is not accumulated from the beginning of the scheme's
execution but shows the value of the last apply interval.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
---
 Documentation/mm/damon/design.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index b676be697158..e40b8c1a3461 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -876,6 +876,8 @@ scheme's execution.
 - ``sz_tried``: Total size of regions that the scheme is tried to be applied.
 - ``sz_ops_filter_passed``: Total bytes that passed operations set
   layer-handled DAMOS filters.
+- ``sz_ops_filter_passed_last``: Bytes that passed operations set
+  layer-handled DAMOS filters in the last ``apply_interval``.
 - ``nr_applied``: Total number of regions that the scheme is applied.
 - ``sz_applied``: Total size of regions that the scheme is applied.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
@@ -903,6 +905,13 @@ to exclude anonymous pages and the region has only anonymous pages, or if the
 action is ``pageout`` while all pages of the region are unreclaimable, applying
 the action to the region will fail.
 
+Unlike other stats, ``sz_ops_filter_passed_last`` is not
+accumulated from the beginning of the scheme's execution.  It is updated at the
+end of each :ref:`apply_interval <damon_design_damos>` with the amount of
+``sz_ops_filter_passed`` increase in the interval.  Hence it shows the size of
+memory that passed the operations set layer-handled filters in the last
+completed ``apply_interval``.
+
 Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
 non-zero and ``nr_snapshots`` equals or is greater than ``max_nr_snapshots``,
 the scheme is deactivated.  Note that, unlike watermarks, even if a scheme's

-- 
2.54.0-uber3



