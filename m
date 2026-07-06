Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13054C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767DD6B00EA; Mon,  6 Jul 2026 10:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715F36B00EB; Mon,  6 Jul 2026 10:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E766B00EC; Mon,  6 Jul 2026 10:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D0B56B00EA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BDC2F168B59
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:27 +0000 (UTC)
X-FDA: 84958559574.06.7559ED8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2FB73180002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A4/Yu1xa";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347566;
	b=NVJaI34hnajD+LJ/CSNqfyRMJRiyo9gIadYwlbUWuRvhX/g281nTqEChGroYcARHARWJs+
	rFmYYaq6qTMkNNT752mpE/K6dHgKgtExuq29zqr60hhfCmmMFhmJtdqSQvTQ5O84AO5akM
	3UQQELGubYVmjGsBLB83OcNrYJWOsxE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A4/Yu1xa";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LCoQX0bHg1OYdjWEvzo4RN1ftxPbEZ5h4yD4yU742Y=;
	b=xnPLZZNbOo5VqkUajG60Fiy9/9ZTET5ZnCDlnyEj60kNejeL9P+I6mtL5ZrvTVYTiniGiK
	ybkPsYEC8/R1RcXX3Ook70zNoA5IAo43tkl4NpV3ql2GYwBXZP2UEoeZcgcc/kOiavpVou
	AhZinq75XNgmAubqFsoySLHj188swd0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 042D76138D;
	Mon,  6 Jul 2026 14:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2371F00A3D;
	Mon,  6 Jul 2026 14:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347565;
	bh=8LCoQX0bHg1OYdjWEvzo4RN1ftxPbEZ5h4yD4yU742Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4/Yu1xazNWRvU2HtJFDKJuoxFxspbxkBVePK0mvBDXbfSPpQ6ReFMeI4NJh4L96G
	 SBZ+69qPfHZvsTAgH2OaEA7C8K6vAWvD5QKO8w96jdv0YdwgGncF3misB+kQ0IvsCW
	 I9ukCWIWBzR0cICQW2ImK+6WuIp0XOPZMMHWgqlm1QASPj6uZYC5LEoDfC2LtqmjtU
	 jU0LVNj28xlDvokL+xr2WsFaE1Ow5igeIhr0P/WMkp9oxLlyLPs61GfGF8Lcnx+QNu
	 pX0dHxP14KhRqau0KAuHWu4hn6o3Z98V9RMOR3MQGbYSJF6A3QZL4DPxY/OLiQO3bw
	 2+HLdu4Z8Ad6Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 14/16] Docs/mm/damon/design: document attrs-only monitoring
Date: Mon,  6 Jul 2026 07:19:08 -0700
Message-ID: <20260706141912.88445-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2FB73180002
X-Stat-Signature: k6us489irdorgqxoa8rbyyfuyanpcbt6
X-HE-Tag: 1783347566-850791
X-HE-Meta: U2FsdGVkX19FJtBFKy/BIxZZwbmWii2GlPlicTy9UYErTf1mWNTvnxfuH5qbE96ZGD2VbPmVDrnkX0E5LnBWVEYqLtRGoG1ZSzuG6jky2J+w/ypvZw0JVP9fFfwdddqfRfxUiLusqwhUiFpFMF6tP8y3I1gPyUcLUJNblzkE9nBHL6WxdhOzRP9SrsftUD109fTEhIr1QUWd6KlSgv6vtHsYFQzwvXSDTXlzb3jYlGXvB8AV80B7HPUaA7IMRasqHE25PYZU3XQhBCG8beNhDuu8Ln/ed8CtWsvazOR0H8ciA39tRw2K06C7cy8N342GHSCoo/E0CTmx4JNIHBJtYR+ufZuWgB8fNrhJg9FkNTb1yNZgJ552nmQFONE5jXu/A3zJPbuGkXc8ROil1rtrf0PyVRwl7cCLVA3Kx8wYLUVdJZjI7bXPQOOjvu5rJkrCxOONrxZ0IyzYXtFrznaHYb09hORKZhJubQtuvy5JR40lpk5AwAEZCreKepI1Nb9H32nceRuRUXqeFmA07RySzWoFmUatQJQw6n0lWl+uv/+VCZ3RFkshKF6dleUpUIX1ArVfJx2HagNZmb7nlTyJWqj21S1DMIvv1ot7RGxQ112XH2yEcmFvcYrHNKwfSHG3uw8efSOvO3deFGpnrrQU6urDCLBfzS9m0pmj+vYv2XPdPVGkF5KEm9hJDEPh9EFgbGG/ZyuadYqFvZlKW2G9DTBb4Eavt+ko0KjNp4xi3g9RWpfQ2aDdZIheKtdVxdtmqSVrimwmBjwrtAgNUAsNHeZbY/4XLzpJrv+ZFeVxnNvkBzt2Kj7X1UXUFSFyYoNPKgmAO63/9crTe38xgz/OPcP44err9zexPwhjlYbHx1FFqMrUtvKbmDkjqtE0fGhgadR9uAVoLO5/KEDkYxkzxYu/w9+5tEqx5m+y44yI7Qi4nuJU8UMpAgb89lgeyKRUV/5Pm5xvXHe0ibRgOya
 Mx6eYbiu
 7do634+ocGDnSDCmWQ+/Fr3FYtHrU66BQvAMSWIqsorIBWJS+H28cGZ3q5SEcv4vlQbnrukQMkdlfD4NWvjqM3fxLH8IrKRL6P8Eq9L7sfa6NWSZN3bFfAe74XNp9qd2+9TMv5byO/xNCgj/jShCV+D3dGxSOjBdM69egzoyw/WQeSI+AnFi0OS+VSaRvZV1DSknSxHIcbayXXRjlQ1N+mzCVP75h8K+SSr641KgOzHAQeNb8T2+JrwrepZEPveHqtYnyrWwNKbwJDc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the attributes only monitoring mode.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 457d6e8bc7878..6d79e7d69be84 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -316,6 +316,26 @@ Another way to do this for higher accuracy is using :ref:`DAMOS filter
 information in page level.  But, because it is operated in page level, the
 overhead is proportional to the size of the memory.
 
+Data Attributes-only Monitoring
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Data access is the primary monitoring information for DAMON.  Hence it
+:ref:`adjusts <damon_design_data_attrs_monitoring>` regions using the access
+:ref:`counter <damon_design_region_based_sampling>` (``nr_accesses``).  In some
+use cases, however, users may want some of :ref:`attributes
+<damon_design_data_attrs_monitoring>` to be the primary information.
+
+Data attributes-only monitoring mode supports this use case.  For the mode,
+each attribute probe has their priority weight value.  Users can describe by
+what combination of the attributes the primary information is decided, by
+setting the priority weight value.  If the total sum of the weights is not
+zero, the mode is enabled.  The regions adjustment mechanism uses the weighted
+sum of the :ref:`probe hit counts <damon_design_data_attrs_monitoring>` instead
+of ``nr_accesses`` in the case.  When the mode is enabled, access monitoring is
+automatically turned off.  The access counter (``nr_accesses``) will always be
+zero and not updated.  Hence the mode is called Data Attributes "only"
+monitoring.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

