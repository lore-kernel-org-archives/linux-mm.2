Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A8C2C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E546E6B00A6; Thu, 10 Sep 2026 00:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05716B00A7; Thu, 10 Sep 2026 00:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C371B6B00A9; Thu, 10 Sep 2026 00:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 877FA6B00A6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:09:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0446E1C20C3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:09:27 +0000 (UTC)
X-FDA: 85196523216.21.E50B0E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6FE1C40006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:09:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8RVJyHV;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EEU3ekWc3qyXmh8drgRUKtX2xzp7GdjGEtLM6CGh4Y=;
	b=yj2B5kR+/ULcPkELCfoGXrUe7CFTh8HoybdmfYpcyVVWfxsOktl7sbMdvujpL+B6pgBI1l
	e3K6bPxY9fgg0/TVAMexk4nIggqHE614HTeTlKYHh83f6/dsOm09TKltVO59inLi3iRIFm
	1j0XJHW1ywP6ehoEtlBdpYXRJmwzKag=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8RVJyHV;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013366;
	b=f6cnabnTAIGwD8rGmszM04c4oeei+eG1zuFvOlPA2Sqcl3TD1G/hQfIgsEyTMBxuHEvat+
	+akpb6JExUXWBXF5/MyoNAVrDhSfpjnorVtIqT/DyUkOL1JVilBsgmflGd179CFS84du7+
	rDfeWUNEEOj9O5eh674eMjiL/nfM69k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C833843D10;
	Thu, 10 Sep 2026 04:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857341F00899;
	Thu, 10 Sep 2026 04:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013365;
	bh=2EEU3ekWc3qyXmh8drgRUKtX2xzp7GdjGEtLM6CGh4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8RVJyHVAo/EbuUIAmOPKzIPPGZRytI33RXRSf9N5aSlMIBt0co3sWVRBHljS/zUP
	 kiUtyuYUw+WeSFndKgDowKfvOzQ2MzUDsgaPE6Lhy1HOCJPTYZiQ1JjnFsi1pZEI4d
	 EN1xs8TiNcYpLylfJ0o0//joKE1XIxs3FCSLadsxQvXRLfLFTFMGTRaXkm9QISbWaa
	 Cf1/uE1HwqPAJfQvGwRffnzgGhhaiXPOX6tw10ig5t50XxXrBCu20B+6fBk1Ss+fC1
	 GDcP8frrqmDPWMPry6mD8AdhL4UojBeTaohRcdrdNrMADfOETqz6wElKqB5Zgf6Tid
	 ze8UZB5ZM8zSQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 4/5] mm/damon/sysfs: support DAMON_FILTER_TYPE_PGIDLE_SET
Date: Wed,  9 Sep 2026 21:09:06 -0700
Message-ID: <20260910040911.148273-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910040911.148273-1-sj@kernel.org>
References: <20260910040911.148273-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6FE1C40006
X-Stat-Signature: 5etemm681zjmkhrduo6mmxig61isyezp
X-Rspam-User: 
X-HE-Tag: 1789013366-930708
X-HE-Meta: U2FsdGVkX186Q5K/A9pJ1NmB2VBTDpM9R0fpG52K11DWk15KrniVGJQaZPCHi+Rgd6BFd5R6l7BPMC8L8xyf9gKPa63mshT4PQSVeUt88BdIgBdqWKkfb4E8gh1eHIQiHzz+q4Y08vRo0Kzg3L8GEAODMQ+GLzI2UM4XP5XTFeQBuHq82Fo+ygPGbIbgD23W1tNboCoK5B35CmU21EqOT4j6BL2rBDEhpHOXxSrNnbuO4f+qFCzaxd3bgM8yJ4UAjsdMXegD/ldifDByoXZYczhfLUkbplqD+sXN30vksq/Eg/0qbQV+1FkCbrFC/2CfiN+Y9xM8BJNhFI9DVlmE8Y22/R6TV72LgPWUyJTV0ip7KpAh6hrCsoGZVS1sC+ItvhgA1f90s3tdCzVVaFUI+Hgc7reBawWNIrj3m4/rX204c8/WxW4ArG5hFIKoOF2zTZGUBEA1VwX5OeeK926wTmHBlYWkVPrmyc2M+ntizjsGOwF4yHRHAhbzoz+EMlFDcM70Za5NI/rL35Va9AmLT79kPQfDB2M3URmODmGNWoNwEdl9nlEZFTftSYW37HKoAw+jZ2XXKUNCDdBYESSBfEqlw7Z+XRoZxb/L7sEpamL4RB23I3gpLhD5GbFz5rRGM0ZNCb0rgUUtY4pzNDLwLaHJ74b64Z5ZmXQRLHHbvTe0xwGM2tjrr6BGD2EddX/+Nrlxj7LHJP+PX3u19n1R0YVs3Pe3Tty/Khr88hmQxR9VlYU5VSBGpfoEWl7Uuenln34k6Q0TCWcMzjrKsQTvkuwUIchsGJEc8IYIAV/Q30lfjnt2IFOjMxwm1pDCyaj5/RUWhsJT94HWEFAVfM8YsPyT5i3g3aQlVZ/A22V6igRNkaaspP7qNmSDr2yL86Y9VUCIcZUfU1k0thfiBY/iUOZslUvXbvOBOOFEN1RgPn3nPO34Kugi88BvrLPnt5f+gU61faYldmxsSTAYFOu
 hKIoU6hb
 xWjgBSNtshnI1oipLplf+XUfl9ddbsnOrE9zDuUnbibcpshnSxQOkFtu0VmLWnmBsc2ZVTsZHb+sQJ9th31Py0TlwVqRqPc6wUMb2VC9GmBXlnPDLfmif5zDA5a+H1b+DnBWVHtr22E5TzN7ujfIH2vh3IhmnLOvIa196Ug3RTqTKAkaJ6sW8QWJqXkaPexL95sKyLf/siWd7GfeDIzQoX4MkFNXWzV6b93gQW6m9Im1wSwfzJC9jpamS6ooBIPhnbNq63XoExRVkWbXx79pBg5SqlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to let users setup
DAMON_FILTER_TYPE_PGIDLE_SET probe filter.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b576e97cbfdb8..51fa506c879b0 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1001,6 +1001,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_PGIDLE_UNSET,
 		.name = "pgidle_unset",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_PGIDLE_SET,
+		.name = "pgidle_set",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
-- 
2.47.3

