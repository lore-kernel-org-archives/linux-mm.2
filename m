Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D09C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 18:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7626B00BB; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CAE26B00C1; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5736B00BB; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1759F6B00BD
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 71F3812034B
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:49 +0000 (UTC)
X-FDA: 84951887538.24.D3417DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id DB533180003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PmCT0NMX;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783188707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XifFyfJolobUF4kXii9SDmtvZzvIFxqywQe1D4fl4uA=;
	b=u3/Eh4myrdaGWv3gw7DeTR8wIwNaKZv3W4w5Bglua06IxJxpbhQD0gBU8uMFNzR4u357Mz
	fHzZCXG3lb0fVTeYjFVpnnEvF+NXqWyVgV7GvObT+yYi17M6dW5zY1T+rN/mw2rVrF0C8Q
	zftZjrt+ri3Vi+M2KKjb8zlMdJnPVpo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783188707;
	b=gxUVPwuXR6F3pWuOxd5548/Z8DPz7nrdHu55zdHJAHPpQAQcLhHRKtdRRGeVKrdg7O4NbQ
	g+ziDlaXPrPpv//EEgLgnYDz2KmQFl6lF2StjcvTLkXKn5m2sQOELtIOPHKO05q9jpTRAH
	rkyUDs0x8dp22X9h2BoVaqj0cCNqs4c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PmCT0NMX;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA7A143602;
	Sat,  4 Jul 2026 18:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A5E1F000E9;
	Sat,  4 Jul 2026 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783188706;
	bh=XifFyfJolobUF4kXii9SDmtvZzvIFxqywQe1D4fl4uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmCT0NMXtHtarzpNnYd2A4XsQlNSi3rWrzJgdVmhZSsk+Bsuw2GgOOJnd7r3T4dD3
	 JIQ/oDsFMUFaAW3VoKzqWCrdZ/Uyd56TqmhZFarqffeC4IKmZiOOYYMCFcrLAbVe7+
	 i7KrZXj43SLgkgJT5Jgvy7BudRLZyYN1p1D8eyPlCsR7Sw0ps+cKzP4GImBof8dP37
	 n31OMNsN3JSftnNnGA16mfmwu85tmgivK6ktMkawmN3HJF40rt0dxz0hK/3CUmE1yv
	 UtXUaPYYSGnB4uhuiXjxT+AsjuUiwowWLKIsE5nVXfSzO+KFYl9aIoA9FH5wv4TESi
	 DVG4VIUvepmsQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 06/11] mm/damon/lru_sort: ignore damon_stop() return value
Date: Sat,  4 Jul 2026 11:11:29 -0700
Message-ID: <20260704181135.132956-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704181135.132956-1-sj@kernel.org>
References: <20260704181135.132956-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DB533180003
X-Stat-Signature: wimmoh891513s7tonkm4qn4z63bd5dgr
X-HE-Tag: 1783188707-798300
X-HE-Meta: U2FsdGVkX19CF7RROsqFQQmZSLFhwIn+KX3JqhmjZixGyoBsOThkSKieV4hixLfgBXyb39228DeenowysqHVdFr68398p/9SyX9ejUAGqlXcjfI+8a52iXTLeniIJ7/L0naPHJ+Jhi6RnhO8VCFDLtCWwgNLan1UkycB01I7s8P44rXJr/7LF+hQT/VxpO0SKTcaid5Zk8mNQXgTASFs5mvfNI4VArNwQyHlbuyTyLD0tfuJvwZZni8+/HyjDikiVVCrDgWXG7i7b93yzF+qS/pOoAyTgJQuiB85+fCCmcTRoAYUGs0SgsS/syL2Vn6/A+QVVJ5b/vFWraWp2jdFr0BWPS/NKBXgphqCjdg2IQOoVgUFb5MQJ1zXbAkmBgy6NRul25mJ6dnpklYielCe4H08VoVuohjrrzrW55v0BNYm/HRpejUWCIwR4iIlMjSdVQXwHVwSZoxIPggS2YBZBqVjnniGhf6kFNopXk0H8Bl+WBVS894ys9RezAfLWcAvMec0tgb7xYIp0Vxs0q1vsfQY/E7WAAGJLgy6jOMPDAcM61LN5HhFwLfuCmPvTN/Tg/Bi2KumjHaxFSgfOBwgXS0fDuX4ob1njxoDqNqRR2grYOJq83FavXoZkJLTkf0KZXTMK4MDt/05LQ6vovw0ut2nHeI8l8+X7+v68PZlO8KErzTpPq/HtB7Kb3JmVK2KbguWHr2AU+RFMUFbOzlWa3MePlGwqWJa8knic3SYzJw8J5PEtR4MA1VQbItUsESlfLrWTYeBrNoNwgAe3QwfXa9F36MjYVzMKKUiHqyCDfmKtFXi/IlL9+9dukwEpzhL3NKj6735YFO6znEhZ2C6FA78Fo+E8/bEf6xKUSltN10x7Tp1N5WcsFyBCKafUmeuA1p6mpNkSA6Bo4B/dk4LnyyD4zmKykpywC8t3trv8NWDh0IMy/H36z9RYl6zZljiTGxgBBBNXIkmLY/XnUx
 gi8/DAI2
 7WiIn9fQYo0bEbHzF6iukXcamkYBk2VqxWOB0/392F8+D0NeahWXpUe7bmTCjdOTlkCWFQq2PY8mexks8MUkFkV9nA9gRdDIR58mLCBBhkcieMovMDtO4h0reeAWUk3PzYWnCIlzNvN1d+LxuWBrPhcK6/B+ycI3zGLWdOxhA/mWbWTijIvWMOkA+M5nhW8NrXzQk7dQ4WLKKf/nBFqL8GZ0AnFZI0vlONkd4UvbSvCuUcA647ht+lo11nmsuo/WTHDWL+RxMhqrN9c7Bwgq/EOj6Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() return value is guaranteed to be 0.  Ignore it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 2dd0cd0d26273..e8c389ad3226f 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -409,8 +409,10 @@ static int damon_lru_sort_turn(bool on)
 {
 	int err;
 
-	if (!on)
-		return damon_stop(&ctx, 1);
+	if (!on) {
+		damon_stop(&ctx, 1);
+		return 0;
+	}
 
 	err = damon_lru_sort_apply_parameters();
 	if (err)
-- 
2.47.3

