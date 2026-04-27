Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBCD0FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523906B009D; Mon, 27 Apr 2026 11:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D39E6B009E; Mon, 27 Apr 2026 11:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2AD6B009F; Mon, 27 Apr 2026 11:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 273F06B009D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:25:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A866A0F42
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:45 +0000 (UTC)
X-FDA: 84704677890.30.E82CF9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3DDC618001B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gv4wDjq8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302763; a=rsa-sha256;
	cv=none;
	b=qKCJ0VpWNqOPbTCIczNtuFT0IARSOIITC/xHBsN7MWGhL/qj6q7XOpExfNoD6ZB6mBsu1h
	QYBp9okPzct8g4bc8ra8RWaDVkQPIJ3Kh4ONrsYSi2D3s8ObdfudiTRgYgfk4wJt1KOs2c
	G9iRElgzhew8aP6jYuOahtS9OLgNgTU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gv4wDjq8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtSrqktECVSRTbIOnfAhYjfcjrVe2WKXIwFaQDv8qqc=;
	b=yPXRca1r0qwja+qBfx50m/GhXwUzRct+nS9goaeXcPaokF0EEULIX0DQgHSTnH+dpM1Yyl
	PF6fIQy7t1gT+s2zdAaHPQOXK8BwrPudRrxI0vcLEO48h7KRksfbXZUZILSy0Rj52dQity
	lbdXtQ6zKtCt280FemRP/8J61dGFnsg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 14A49446F7;
	Mon, 27 Apr 2026 15:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A77CC2BCC4;
	Mon, 27 Apr 2026 15:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777302762;
	bh=O8n0uNGYuU+EcM7S/clzxsj2TzvWbNFjQtjX/Z2/CrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gv4wDjq8pC8MRYUp9YxDIQ9gWsfPychqKhZZqC5yjyusZ6ff9VMKcopk44UjgHSF6
	 mBCIXP78F9f2D7tsQVdhGGPTRaa/iOMW3SZfLCvJyoopRxkoltdEG16ODitiwn8qI8
	 BrhwdyUyT+otrpYI9SUcTRtOFQ74srhH8d8tB7DCuR2JdcU4/pxF+ly3HDWSketLZs
	 lHbPouUda6elQAGc49DFl1f7oE6mbs2pAHv7wBB9jKpBCXmo6fD+rUiIzPAtSxkaPV
	 qfyffWXOuvTaWY6L40CekFRFO4BdLMMnj/fLugA4VmYfdgFSJh3YsU7sjynUwQm3iz
	 4KP0klz1+ZQHA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH v2 04/10] Docs/admin-guide/mm/damon/usage: update for pause file
Date: Mon, 27 Apr 2026 08:12:23 -0700
Message-ID: <20260427151231.113429-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427151231.113429-1-sj@kernel.org>
References: <20260427151231.113429-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: quf74gwe9ba63paiqibokcc4r6cr9ohm
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DDC618001B
X-Rspamd-Server: rspam07
X-HE-Tag: 1777302762-700280
X-HE-Meta: U2FsdGVkX18gsO7UpPB0gIrxwptJOgVZhsT0v0nXe5azs6Osdf5SSLV0GKiooyg7fsoD3R/AuuqQyPoGaUOepBDT3DpOUxNlB5QYI+PBJA9NRMfX5kT960kQiozL3rv9lBj6tGYdhIf9R7NbJNVWl5a9EO7Vzkc+qx7RNmCv6YJArE8eUH2a/6vmGDnwCgC8fFW5kUb6en/y2eWZoGbO/AZP7HSj2hEEJrw+vkYOpMd9mFirjNLbvB37VOEH+NyRK47KGVvxkFDI1DPKaJv3JO8I6f/4FFiONeJNC1Ru4C7u7j5dCgiK5LCUwBVcRKdnxnQy2WRYQ1cCyOiEs0EYgKo8wvx2JW18C+ljWrIcUU/RScsFqlvi6JQtR1MoUhjPVDxVD64AKZX3PWLc+2r/+Mz6BchthPSmn+t70gTSJ2HxpHPnFPqijWR/vLXNvBv2trKpcfbRQ+UZ2F5QnR2sM6u3EnWU1zLXxGiJpqmLAB3FBCzCbVQBMx58LE6jaVfcZZOOEK9X2zWWTNQG/kY5nMYADBat3FlhL0oP3M+CIVAk/WH0iZWEDmUItu+ncbynhoAWmPqurYBIhr4VfjPRmPdChPtxxTkjFTAFhiF4XzOUI8UqENkmxG6zNu3HHMki3sY+Nj9Sc8ZQv2ipNYWYD46BKZWQdC7FPdUeeMxv42bhhfunj2XyxUSxZ/EXq79nXgEJzT9LJxPSbZNUVNvJXlIXxWeVWrfb7sOsMVX2+aS2hnGZZCh2TqHzC8KqYClTzPA03/gu7e50/NxMq/UKYLwDmZxLkYsedf4PVk0cAmgCe8tmp6luaCIHbjrA5oRXHY/MwzrQ4pFylbFI+UrZXDD77CNMDrui5ewi3bDB4HTcMyCg6RXwEs/ztsBVbTpncRZ8x27UYxB9vMfN5tuYLRLhl+nFP0v2xROvbl58F7PccWSjaPN3JOH5LLTrE4TRrQRs1HeyAiZtJP5H/Hf
 fH2jw5Cx
 g+T2/fyxOzJMHtEelm0GK2NdDHIdsFCTfO+CUjwLHE43iPQlvjEm9KN6Ui1ozU5LV9302LOxmFyopGz1zinVAl7B4/x/MFCYvH70gL2Hs+UkVzfmyRwJ/Yqw5M4KWx6NdDHHZR/xYJ6BA+l3O0QuRaLQfdLqC+7CEOSFwstDz9tgfYZPnscy4Z3P8Y2yD6sCfI175r0F+Ftl+ywDOMiLkOzXumfxBTbVL/HCkwwPQurC3LjJ7HQE+zK5DgeAbkNndC67C7FLyDoWmVyg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the DAMON context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 534e1199cf091..bfdb717441f05 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -66,7 +66,8 @@ comma (",").
     │ :ref:`kdamonds <sysfs_kdamonds>`/nr_kdamonds
     │ │ :ref:`0 <sysfs_kdamond>`/state,pid,refresh_ms
     │ │ │ :ref:`contexts <sysfs_contexts>`/nr_contexts
-    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit
+    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit,
+    │ │ │ │   pause
     │ │ │ │ │ :ref:`monitoring_attrs <sysfs_monitoring_attrs>`/
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
@@ -194,9 +195,9 @@ details).  At the moment, only one context per kdamond is supported, so only
 contexts/<N>/
 -------------
 
-In each context directory, three files (``avail_operations``, ``operations``
-and ``addr_unit``) and three directories (``monitoring_attrs``, ``targets``,
-and ``schemes``) exist.
+In each context directory, four files (``avail_operations``, ``operations``,
+``addr_unit`` and ``pause``) and three directories (``monitoring_attrs``,
+``targets``, and ``schemes``) exist.
 
 DAMON supports multiple types of :ref:`monitoring operations
 <damon_design_configurable_operations_set>`, including those for virtual address
@@ -214,6 +215,9 @@ reading from the ``operations`` file.
 ``addr_unit`` file is for setting and getting the :ref:`address unit
 <damon_design_addr_unit>` parameter of the operations set.
 
+``pause`` file is for setting and getting the :ref:`pause request
+<damon_design_execution_model_and_data_structures>` parameter of the context.
+
 .. _sysfs_monitoring_attrs:
 
 contexts/<N>/monitoring_attrs/
-- 
2.47.3

