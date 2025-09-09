Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D8B9CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 02:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99BC36B0022; Mon,  8 Sep 2025 22:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924876B0023; Mon,  8 Sep 2025 22:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700836B0024; Mon,  8 Sep 2025 22:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5B66B0022
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:22:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4C20B8399
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:22:47 +0000 (UTC)
X-FDA: 83868113574.07.E90DA5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3F12FA0004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:22:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tGDFUtKy;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757384566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJmdAksGsHQDmtzbK1GTX/T3XElpZqspqSXPvmRyq9M=;
	b=KC6zUPkYerGK5G+oU29AgBgUzc1A8yvZiWzcRC4voHf6JHrLYZ6VkVSoVrOo12fl/vNiua
	8e8W6AABJFCibxvOqZhN/0+mkvnrORwcsm+B1DsJARzyuc0QZ9E29OpAy27PuoTnjXMTs8
	0utyKUwlwkzKm7xuBp+VGCjc5xsUAIE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757384566; a=rsa-sha256;
	cv=none;
	b=37zZm1rzLIpbBySOgoYt2aI03eb32OdWAxj6XGz5GsBkRKX/MK8JqDDcviQ8aA3gMN6kZi
	dkFpdIRkyQvoyt6jKKo1s7k06P73rWss01qWmCXubCNayt3Tfvbxul4RZnYQSQW8VhluLu
	fmEjZ/CLnjJgUdIxFaWWM6S9apSvTWE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tGDFUtKy;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 425E044C8E;
	Tue,  9 Sep 2025 02:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01951C4CEF8;
	Tue,  9 Sep 2025 02:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757384565;
	bh=CB5KTCrWLMEdIF9ZzZSCMis1Zik0Tvcul4qLyUj2Xrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGDFUtKyB2aBLklonbKqRX1K/OAwoFApnAAISTqDhc3Z65P5N01TsAk+x46RRDyER
	 SjzbfPnU3GKG/8DK9KPAeuhuV+j/XMIEkoX/Eqd+KdhETEkjrDTWpCKSXQ7Kp+q6DM
	 iWx3/E8YYW57igz2Rew49DmXqvQyH+SuJf0uqBLXP+41qQJFy0GkF+nvwcdNha86wu
	 ewGzVsz4Rmf8PlY55nv79k4NwScDJdlzghmCojMoz+3Dp528wuX3W0kn0Lu3QYqKKt
	 NyFbKoSuZANRagwvcx12ZXolv4MHUPCCaKTT0NxhHS4SQsEG9IlRjPjpdguqOMqyZE
	 i4w+y9XloLzJg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17-rc1" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] samples/damon/mtier: avoid starting DAMON before initialization
Date: Mon,  8 Sep 2025 19:22:38 -0700
Message-Id: <20250909022238.2989-4-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250909022238.2989-1-sj@kernel.org>
References: <20250909022238.2989-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3F12FA0004
X-Stat-Signature: hh39bu3ggct48rdnh4shbt1mbbs68h7o
X-Rspam-User: 
X-HE-Tag: 1757384566-620256
X-HE-Meta: U2FsdGVkX199CqQB3Oe8TkRPbTEMS9tML0PM8/ICD0Wf1yGLHmluVtrC3cAKLClB+07IKeBAxCBE/We1cxjZ3xnAhucssdwXzFz85AqS+cTcJJW4b4gcERizGZOGjOYB7mDFLZ1C9OzrD8LKKyDP4x092U93AQPGbDOdnBd9W49OCxSh4xUdRqeP5RRMHkgaOwykftQSy3YPwLsXSdaqEpOnZa6JFDwF5hPBx8XPdkrE36ARVxnIuHtVCMcaj8qcS6x2OwTPNGRgdA/8yroJg5TUbyQ/g1XdbkprWG3wTEHEdG5DkqLyL4Yfe0UzVOh2THPN+aL4myIjuQwN1zh1i32NY6LOpcPPpNGczDYMhqMSoHFLx0EMF20E4+wnvd1ueREjyWnd4MCVMvPSqG4Gc2XqPOjddF53+BTADf8cAO4eDZYIdiUBQ9zYUkW7tdC/1O9DN99svbIJjMGGJ1il805drBVMWBikOogWS4co/3eI/qTzMlClJUzWEksAo7kUpTDbVg+/Gj9EXR+bdt5643e1UIlskNMjpdbdUjZKd8OChBqpdt0u+66RI6UG+StwDKOvyMJqw3EIQqmrrCWzZIcgtNG5Va+chvQCvojkrNfRiYEjEe4y/UcW5UmmfOti1iY9t4cDWm+J1sqOGB7JzV/J68OW0bGnXENj6GmzZTC6pK1WjCTQoxXgZsItS+6OjDuw0uzqfdCoyK9p1quPcZsSzaGNhaHE2P1rAkvVd+2Amc/2JaLrjokxy0aRTNktcJZ9UaWdHUcKLgtp9gdycWzvvz7q5/EXjEm8pQitrFiZCxLYDAe0fzeaYQkfAgIx0tYn1q3s24qrFnCeWw7HI7GTrxYHrFzXdZT5xsh07gnYT9Xe/Q7XRDPD1qTLKaZejNn7BBZHPOOV+S89fxIuv9p41+0Kv51Q2YiXEE+Mz5vz68M4iIp2JxL9t8BMlzo81U3jqqhWd6VDC0ulstT
 0JgR18US
 0Q5k/uFrR9I+g3u1/pH9De3TS0U2vmUDtlRXj5ieOwB8aGYiWz5w1DRGAd/puHEqGVWsE0Urk+btRCeZsihUMi2cxSQbM2pNoIh5s7haM0vVxX5GA2YwRtu6X2lo3r/4DdlHQYKQjVVfzVxHQyKL/MQEX4jWcYT1YTmB6fV6Clo6kYDmoMKW0pNXtaWM7oWmVvYTVw3Xk+cXIHXaSPrmt6/BcgEKQEdEiW3rTm8zPopHZSrY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 964314344eab ("samples/damon/mtier: support boot time enable
setup") is somehow incompletely applying the origin patch [1].  It is
missing the part that avoids starting DAMON before module
initialization.  Probably a mistake during a merge has happened.  Fix it
by applying the missed part again.

[1] https://lore.kernel.org/20250706193207.39810-4-sj@kernel.org

Fixes: 964314344eab ("samples/damon/mtier: support boot time enable setup")
Cc: <stable@vger.kernel.org> # 6.17-rc1
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/mtier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 7ebd352138e4..beaf36657dea 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -208,6 +208,9 @@ static int damon_sample_mtier_enable_store(
 	if (enabled == is_enabled)
 		return 0;
 
+	if (!init_called)
+		return 0;
+
 	if (enabled) {
 		err = damon_sample_mtier_start();
 		if (err)
-- 
2.39.5

