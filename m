Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5236ACD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 16:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6499B6B008A; Mon,  4 May 2026 12:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D38B6B008C; Mon,  4 May 2026 12:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B826B0092; Mon,  4 May 2026 12:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9BB6B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:58:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A323340223
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:58:19 +0000 (UTC)
X-FDA: 84730345518.26.EBA2133
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 01D89C0009
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:58:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="dc/401hD";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777913898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phIgVgyfs3piMnGHYotivj2SLEAPmu3unH0ni89MvfA=;
	b=f3K7PSv69/rgwFNw1YDmLTkgBkKyxFmBwX+O9P2ukXrA6m9L5xkGfyNsmFBBFgB+xK2xHk
	f80CbRR2Uh8Lgk+6DAoeeDNbfSH92WxxMb1HFUVKSkAX+3OQDu8rV1xgMBB4wjZfy6m3ae
	VexP8ds7vTvRVfDCbWu93fU9wavlsyk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777913898; a=rsa-sha256;
	cv=none;
	b=vHdHKDZTP7/gTRdta3sMQkKX51ncQzsvDUtK/Yqxh4AQ/wJyrYNtQ2xWjV73SLufvJ4DqA
	5kQzGQOdlKPCcRBueTTuFcjNaeotI8o6UpdVcP5o0BjUXd9AA07Xp3M21u0lmxAeWntNJA
	+qtmMiU60q9vWgHDtU9ORkyYItGvjok=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="dc/401hD";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D1181BCB;
	Mon,  4 May 2026 09:58:11 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6EF033F763;
	Mon,  4 May 2026 09:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777913896; bh=a+4PKjMqx7aQq4f05NlDPBE0NjHeUJlR2h+ir9csRgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dc/401hDYBcdgANDQ/B4lM8MSaphxa36b/zEOkitn5yy4Y/BStmrn5wDU8wO6EsDK
	 2FSsVWLiywkNaplTFbiKFseOslc0COaOfYyOy37aMqfWpIeryS7TmBQsiTWzdlSS3f
	 dsH9+VfGxbevHprNboLCQX7IkvbJj0xpnU5YFIq0=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 1/2] Documentation: maple_tree: Point out constraint when using xa_{mk, to}_value
Date: Mon,  4 May 2026 17:57:45 +0100
Message-ID: <20260504165746.1422057-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260504165746.1422057-1-weilin.chang@arm.com>
References: <20260504165746.1422057-1-weilin.chang@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 01D89C0009
X-Stat-Signature: 7ipjb388u3rwu4ez95dk913sw8qty8sz
X-Rspam-User: 
X-HE-Tag: 1777913897-751218
X-HE-Meta: U2FsdGVkX1/lZw9aptzChxEVwbwSqbcclGVez0niE6WlyOhrfeDicVAu9W6LRffNK1rakMaEytzwGM+QBZoTwGReDzxh0++QjlxvawpRIaIvEEno/nT5ip4we9nYOYbu37IWF6s3bcZyE3hf50TZOk9xLu/E1gjYU2udkEhrif7fIsJ6txqYS21B01n37RDXrO2gWoxZxoiQPYyPNBgz9KKfa5bPMwXu2+uwscj7hzWhBwM398W1I/M3LlYLcflEV8GZ1b6dbyltKs3HgriDXFyxiCYBMAd3Cvn+fMZAcWb8UUUClPO94jhcGtTllJjDJEuYe8tlahmUPWHHXVnZhS8nx8Z3xeAZusPQuyRyGXSzuzIDNz6WJYYTiTPJ2KOC52Icpf9uB7BwabjQVu/TK2aGYU9VmvAogCFGD3Tb6VxHIGA9tvFyuc5QDCRGtcARLQohplgjQpOXbeasrc3HWkWUC/1Gd5hpiQ7q6tblikfVAZtCnij79XfKsB7McN87ET4u7uD3m44j+/X/7xwgtIQ/fsIDTOTKa0ypQuGcoDuC5UQwDFeKgJJcPXhIe4hi4MaF92ZqTl2VLOkzUh/kYoKikjkbUiuScINJgv3lbrS/GYf0aV8IbMRywjAWgC05mfL/Lhl0T8X4rVmheonK2IvCkXxKxp+FftnmGSaKqIjo+2Uz9cARiON9DVIo99M5nBh8ILmOoU7cxbu4w7yEChlGpQT0Ph/NjklSb1BsjvaWleZJVbTvuACR9+JhFkH8NLgHDrQkosjesE1KpIgXbvoyHtl3cZ1LLPAEuRgtCDtMQiycRXHC+UB9tsGiGDCE6gg9tOmzH7pUrp/IjQm+xZCqFRx0mD9Cq52B+0E/+DkRY8gFjP29rgPYeVdME+lwJNDwr6oJFl9sU3URRDOscDUX7IhWjFXgYLKafqX2KrVwZre7OYcCDCXmRvTsFPLv0oiqkjmLAqDqElECM+m
 TzZbfbks
 +/cu1ogH4IZU1WBoBk9AxtCwgCgSZMvo4s3uii4zje/DfXPVKnu47E16BV/8oGW1Tz3wDm3jBgarZa7dMpSjqRtvlVJ6pnIdOOy3eaE57JeV3zRm5dLsPtLl74wvvYEBfB9cLldCoxGxVUHjo/vhrrWaq36dlik3qC4b/rIKhiWPrLSo5u5gXjZuKwSn+01OxWf7L0yyVfN4mtGh7zWLLdObObfvrdijF3nlR2B8uTddYNj9B0uSQuzXGGURtLJHYoBvBgSUHDwQhDBgnkDGr+TxgdoPCKdv5iFOQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using xa_{mk, to}_value when storing values loses the information of
the top bit from the left shift, point that out in the doc.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 Documentation/core-api/maple_tree.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
index ccdd1615cf97..87020a30ba69 100644
--- a/Documentation/core-api/maple_tree.rst
+++ b/Documentation/core-api/maple_tree.rst
@@ -29,8 +29,9 @@ The Maple Tree can store values between ``0`` and ``ULONG_MAX``.  The Maple
 Tree reserves values with the bottom two bits set to '10' which are below 4096
 (ie 2, 6, 10 .. 4094) for internal use.  If the entries may use reserved
 entries then the users can convert the entries using xa_mk_value() and convert
-them back by calling xa_to_value().  If the user needs to use a reserved
-value, then the user can convert the value when using the
+them back by calling xa_to_value().  Note that xa_{mk, to}_value() bit shifts
+the given data, so the top bit will be lost.  If the user needs to use a
+reserved value, then the user can convert the value when using the
 :ref:`maple-tree-advanced-api`, but are blocked by the normal API.
 
 The Maple Tree can also be configured to support searching for a gap of a given
-- 
2.43.0


