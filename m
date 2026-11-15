Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF31606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f9pJQ0Iv
Received: by kanga.kvack.org (Postfix)
	id 9BD936B05C9; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96DE06B05C8; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883AE6B05CC; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 591D76B05C8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7A8F1C41EB
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:10 +0000 (UTC)
X-FDA: 85438492860.17.5F9A539
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5B72DC0006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f9pJQ0Iv;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzWAy5ljzbSA7LAk4a53ozwyTWaW9lGp6192iqNnFAo=;
	b=mxoZ47cO3X3rQ4W0jLIGOHQcw5p4+FuXfZXqV675u/fc0nfsmAKMJUDEWau1sqjDp43CMc
	rcefxeJjorGWT1D1oyLff0riYYbzNJ0ACH5xLWTZ0+6UHlWmQrnXtLAaYLWQrRLdEGVnKc
	99HEEC6OtWp2aqEAO4vCR5i5VVyv5tw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774549;
	b=qsTqD5X9Og6lZ7+N4rQ4c9O2LoMXOS7+cDtZOUGY/xwUCrGckQwOwzu2Zq4Oe9M5ND6M2O
	Eis1V/YJ7tgJXZl6q3x6kroK+9rj2gkifb/EH0WVcYBNeBkG17r6cLZkuppeuQOY7AmEdR
	nSOkfEfWS+DKBOGaTWYpqaQf62NrJT8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f9pJQ0Iv;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA780623A1;
	Sun, 15 Nov 2026 20:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDB91F000C9;
	Sun, 15 Nov 2026 20:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774548;
	bh=QzWAy5ljzbSA7LAk4a53ozwyTWaW9lGp6192iqNnFAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9pJQ0IvrveC0MsfxjYm5mhQu5EMLJDV66AQgcVUtRsXYvbMkDTnQQBhcSNHNv2OF
	 TFZk3Sh4TxIWR2ztM3w/n3YMR+yaOYwJ1HWoH8wHSBmSDYeZ1cz8mEXY1sxVg9omkw
	 zQy3gm+aDyiAHWGRZ0hRkTpHVbC34qSQIyCG3MpHtjcK83H6F1aqLTmW1qtSDnKfjR
	 S8w/19HMAbsiyTjJHUaCHwZ1ddiBovWR0hxE92nFtQPUYwqgCk35MdugvWRUOZjBrd
	 8o/rBzAEh8BoEfgJg1YAKjg0pxZmlmGScZ2sHS4xmExqLY7zsSCXjL3PLGyca/QyVw
	 imiGYtpDkMvgQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 18/27] Docs/admin-guide/mm/damon/usage: update for REPORT_MADE probe filter
Date: Sun, 15 Nov 2026 12:28:36 -0800
Message-ID: <20261115202849.99134-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kh7h9tpgu5ymmkk4peetft8jo756ourk
X-Rspamd-Queue-Id: 5B72DC0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794774549-153966
X-HE-Meta: U2FsdGVkX1+smqrGNVrvfpDJTs5gjq6EBg552FAtKO2Ikw76eQSiB9WqKk/yccRspw7LmUOEvVCBAHzoMYeAaxr0rYLsF2f0xWyDeHCBFUYgTDxIlk94Xt+teJswSRff5Ge/YD3OZE40s8ughYnOfnYAy64rSjgASfIjpfRN7CAdKCM7fw4y2wD8iW1yNfVrfyK4qWCLsfCBo6KOrkCTpFcdi31aox7KOCGmn1sfS7SdOtgkrIkUndj4+Kxi5HK1unlXXH8yu5l7LYlMD4XBiMnTmOJf0/IjHuEtQre41Yj9ktuNY/uOcAJ97CfrVcrjtOH2CjrcwFqLks7uksbZZTCkxTu6dIcM8Dnl/eS3doZqSUnNAyb1gKvGxTilYWTVLY8szE0K0CqlkCH5CnhkOQadL6l67ZdBWCsXgkBlw9l5xN/7d7I308dGyd7Qa0vP4wZoElu/4jU+S7pAiPYfYaNPi42T68AqKXryQmmUU5ucJXdwg27MxR3517DQhgmoGelurHcCjE6euS5SSStv13XTHQEezndEI2Gm2wZchoKm95CZwCB6++liqVJCudJRAQpvkyvIjAbQPQC6LO/GOEfTv4AsJrsGD6iC/tSsaCR/ZJ5x1F3mEzwxhPqmlfFinK7jUoCOL1cVi/XCljtuLj77bPxoAzTO8LuCSWibkW4tf5KElU18553Lnxyd8aydn9hFSHS+gKJ24z4R4xM5nNWwnraHiJB8IgkSYJvr7ppO9dv47WwC1JoqWpxkryxPDcDlxBelLdE9v2zRsJ3tXhEcWrbkXkKPP4mCOj8viG62hw8WadTRTCESvLtGl0gNnNmkw0uMah7nYQKS29fqAd3fcNA7NRM3vfrjYL9SHMyJ/UQ8K5mky9WqUhXK+OiEpnnTXQA/4r3AW/7XRp6yVH+0b7DdhlS2wgitMN6YpLNQ0mSGtOIFBjj75xWamFt+1kzEoaOkIrCNlV5exFc
 auvd95Bk
 0g3I02vlxPxF6O1U2FCess1EVLLlhSAt/Z1W7XBKuUUXt+pMLNPtOWoBbVa/p3ujAfDKTb4YHKFMeTzeXnDHRI7pGk+9RDUxlW65jppHy8SwV7qETJ15Tdy9MKzHSXc6m9aJvx0GZV5d5vfN7hSNBqwoXB0W7mDwCK2GTwnZ9ve1GwQssNKhbqEvIwwgMtFzNidi7UzzJmomXoAdDLLvywTFNUhOSjWpOZRR/xXsgO8+NUGnxnuP4Nm2fDtWuT5Bjwk5SFcBxWnPcDtgb824P81VlLvhcNhehxqFHwXbdLjfG71LKCiWBSoFFNk9V6qJW6J1Rga+thiFktcRulcZa1JkmMcWq21pvGKbX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added REPORT_MADE type probe
filter support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 644250c7bd681..ce4e9e4c13276 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -78,7 +78,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/prep_action
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ filters/nr_filters
-    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max,filter_report_type
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -317,6 +317,10 @@ filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
 ``min`` and ``max`` files act as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.
 
+When the filter ``type`` is ``report_made``, the :ref:`report
+<damon_design_attr_reporting>` type for the filtering should also be specified
+by writing the type name to ``filter_report_type`` file.
+
 .. _sysfs_targets:
 
 contexts/<N>/targets/
-- 
2.47.3

