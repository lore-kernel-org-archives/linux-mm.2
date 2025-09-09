Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36A30CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 02:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926056B0011; Mon,  8 Sep 2025 22:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6D36B0012; Mon,  8 Sep 2025 22:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79EE56B0022; Mon,  8 Sep 2025 22:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5ADE86B0011
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:22:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10A401DDC17
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:22:46 +0000 (UTC)
X-FDA: 83868113532.30.D62649B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6602114000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:22:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mPzDToC6;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757384564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fqyd+FhcJicoZicbfrLX49Z9TmXMOIVCzQ6qNOH5W1U=;
	b=3rEyKGh2xHLv1Gwb8UBEnp8dk7D91R9DzoB4aZbDjbzs9xfm6P4/7sVDm72GLi5g+sCNEH
	1U1SKgIPVHItayGguXpts/da82qSsNIXJycX3aO+pHDPJUO5Aa7lxWDtD4uAAmam8Cci1y
	M8XyRNfWVSJMS2L5DFFF2h9Sp+kY7II=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757384564; a=rsa-sha256;
	cv=none;
	b=VH6zWLD+YCnQ3DCXhKjouBfZIiEag1z15KA2tI0yoAmeFA0TgMWLp3GXCHIWc1qmmCtEyj
	80YJdVZ5C0oQy3uQ5Gxkb4i+19MtkbNaKo7AXim2Gpbg4H0C4RUai6CwqD654C0pkSvLwX
	tL1HgQtu6UDFN/oeMQ1H4F0rqXF/1eg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mPzDToC6;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BE6C44C79;
	Tue,  9 Sep 2025 02:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB854C4CEF1;
	Tue,  9 Sep 2025 02:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757384563;
	bh=DHqTS3AzUjYGHdLzhzK2+dBwRPHotpFoyVLaW4sFFjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPzDToC691DQi0WMja/yox6GhsLGehAPJrLbU4aKav/K0JwbbVH+XmLecKYHmwJ9y
	 ZDyHA//PDOfabF57QyqJQfms2JF7VrNzoyw1Nd2ohejk1fHE0ixbGm9APgWU1nJhnP
	 aYp9nnDwa4yl15YxOJcdsGCXffR3ZJq7Byj/BvNMTXX8FkPF2GClY6UQaqomc+aR3H
	 sr18Eb26hBMxjlml6lfk8jjHHfFK8L+S7yT7n98qnN93dBKVgZ3gnDO8OEA1Gw2t6+
	 jKI53vL7ntWYlxipnauHTDBULve+sjnmbtr2kyUfkqwvj0Enjm2FXZ6Ce6Jy9rwEUG
	 28rHW4+F5VQBQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17-rc1" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] samples/damon/wsse: avoid starting DAMON before initialization
Date: Mon,  8 Sep 2025 19:22:36 -0700
Message-Id: <20250909022238.2989-2-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250909022238.2989-1-sj@kernel.org>
References: <20250909022238.2989-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6602114000C
X-Stat-Signature: 7qdx34r4whfxaft31p6gq44hf6yh1t6x
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757384564-488058
X-HE-Meta: U2FsdGVkX19ql1AbFwstY54Mp4REheomKmOzw0zwW4zRruSUaZ16WxCPRtQD/Cmm09p/iw8KKqKJnKudlhfFV//8k8W+wleKCTuepLwChiAS4Ed1GaJWRU5rzBrIQADfQAsbW6Y7csK+wwYTWSyUMepc3q4ZkpWET/BQpIBzU4VmGsv4NmkjC9UW5xxwShbq9f1nihWzWZQleE6ktYfW7eduBlsc6xSscBkIjkD2/4nwV5BZjQVtFBTMBb8ruHqdA8sgwCh8wd5r4Czy08NTsfoiC7RB1CH0YW7xcM/ex1Vxe4Z6F/DRBUbcCWA+QP2i7cmZuCyzaPPHcDPOaphPz22KVonsVD1UQn3CgILaSkai3REwW3CaPacSSD/BiFeG5LzXVSNcarGKCo6jzgidb+vxFzMFAwzVPHwCkHJ4gc0fe8FUxC8ginAZbzt7HoVr8izeNlxamYism/AOnnNM5san9/33WQCkBpud1c9R5AFLUi9GHY/J4xaCnRwbriXv3WQEmpIlwJ4XGLRrfTAQW/AhCK/tzR1PWhyrXs8dRiAMEsbKFzAl8a5sPJYbssOl24tgQveZzWowoaz9j9ebPoIE/GMyWZyUsSl9lmu0b9qSHHO87LJMin8rqWuWy0alFo7lxInRkk+yGFdeuEDz6TxaWBFd4REU/+tSivmqmLk65oQqb0u0cQRYpNgSkSbw4sMhsSX5uLt3p2J/NrV6Yo2SxYa5LaqgdReCM4Obpz32ZKeIG4AzK0aEOX7j0LW3wwxKsd/eLqVCg6k2pBqZby29azf7wGKYaoj2GXAYW6BCfcn6WQC6duh4Q7BQBMKPymrV2GB7Nb7CNs4utg25ekk1XFmliJ+olXk03sv7DPBsRhSyjzwuM8+L7LjN4gYsSpdD6wud85OuxrVTj2ev6wONM0AH6nv69Jt1UmMQ+o3HgghbQEs0PZtDtUg4xCkmEuPXg+9W7tb6NtEUY6H
 xDhYEhyM
 Rdj3L0Ge1Grye5XGLS27CBafkzc7R9WZ67EJnGJRdZUvFsf0Vp2qCtVbXx9fa85JZvNg7BksumIEBbGZsHarCcmnYt3vGYiZ1BfuR4oJnzEBed0v7P/PkgP9GkSlXNUzXVmegyTm70x7HdaYOkRYxx45SEw0ePKS88gdNUY9sRrOKm80Yxpfo26HlK7gCTdstbLNfVjFccopepBlX5OSkfGOfmXtHhA6Y6OrUFB19CR9a5SM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 0ed1165c3727 ("samples/damon/wsse: fix boot time enable
handling") is somehow incompletely applying the origin patch [1].  It is
missing the part that avoids starting DAMON before module
initialization.  Probably a mistake during a merge has happened.  Fix it
by applying the missed part again.

[1] https://lore.kernel.org/20250706193207.39810-2-sj@kernel.org

Fixes: 0ed1165c3727 ("samples/damon/wsse: fix boot time enable handling")
Cc: <stable@vger.kernel.org> # 6.17-rc1
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/wsse.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index da052023b099..21eaf15f987d 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -118,6 +118,9 @@ static int damon_sample_wsse_enable_store(
 		return 0;
 
 	if (enabled) {
+		if (!init_called)
+			return 0;
+
 		err = damon_sample_wsse_start();
 		if (err)
 			enabled = false;
-- 
2.39.5

