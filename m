Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2114C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34EE6B00A6; Wed,  1 Jul 2026 09:52:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6116B00AC; Wed,  1 Jul 2026 09:52:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB136B00AD; Wed,  1 Jul 2026 09:52:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A7666B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:52:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 110CDA036F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:52:36 +0000 (UTC)
X-FDA: 84940347912.21.E113D9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7042514000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:52:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ICKU/rwX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782913954;
	b=QaPnBWb4Z99PONIEig4ZuNodVq4HeNRFBag+Fc3KDo4d8GzSf2wi58Jiwmw43VVkrvBGpR
	Rg3ATjIvUOs6ktVnsM8lMCbJK6n3R5hjmAob8NIGo1D3cZIvhO4mFACcpWgEa4+PX03Fee
	b0RLxpzMlVS/SWLiiomx8EYbsF2tl7U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782913954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+at3T66B8FFjiwV+efoDLf0oTrOtgBnk1d6ck6Y4yMQ=;
	b=kXUGf0oVMdyftwiLONE0JyadxktgmMqpMUKOMbkUxgfzByjfqKDxh+dJbMjeooSr/1URS8
	8R707cSO8B0ZO5q5o4fh4+4eGXabmbnuinm0ayPGyFHhTSzrX16sKOlvE2tlCE8PREZP3G
	VBgoD8ry4Tvq22tJjIx++MSEHWioM7c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ICKU/rwX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A38F54347F;
	Wed,  1 Jul 2026 13:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EDB1F000E9;
	Wed,  1 Jul 2026 13:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782913953;
	bh=+at3T66B8FFjiwV+efoDLf0oTrOtgBnk1d6ck6Y4yMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICKU/rwXY7DwkHITW7EMOoaGekRc1WyhuV5kJ0PG1c1/xLDWoHsjSC+42yZxut8NF
	 l/C1PSWibS76Kz5ziVH/A/7m77ocXbhbr7jhv/tYxUJdONs4MvfFaGDv8tMiNBzfpm
	 2Iel3q+VrqRLDymy5zYK7r4YjDeUJTxhqR4MsIDHypt0F4Lw82jcJ4ZumiUb42bcwv
	 N2qHVv5UcBliLT+jZfZc80R0s/YLrq6r0Hyc291fr+GoKrmnxkJwn9Cso0Di+5wFau
	 l0oR6W1mE+TNbuQHQOOgE/SWsYWQU1RJ7wICAgTgMWvujVttpQQjAJrO0xPagZpcsu
	 7kwlqjRTJniJg==
From: SJ Park <sj@kernel.org>
To: wang lian <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	lianux.wang@processmission.com
Subject: Re: [PATCH v2 0/5] mm/damon: add mTHP collapse and split actions
Date: Wed,  1 Jul 2026 06:52:19 -0700
Message-ID: <20260701135220.93697-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260701114716.56503-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7042514000B
X-Rspam-User: 
X-Stat-Signature: os4z5boiand7nhuojj8fj37hcqc4qg97
X-HE-Tag: 1782913954-647413
X-HE-Meta: U2FsdGVkX1/biwO7etAZax0kNmxyj0rfruw886+xe6QpzFG3p79QIdVBJSGxaDLMYwFt4ynSXoN+HcYIUqmFPHpWMgzfaG3TXy5cF/1zHUHcd/sZkvBA9OeYNDkKQpbLHPlWZ7DmkqP04RdlrasMnUlAXJ7sgJdrQ4sMqxnLz0O1mJsKzKWrZ+GkOf8omgBLfRa6t/hi6FG/9vWyNBS27bCigfw8V4XD9gtAi5iH2xY542vmXxPTsvSlFn0PUg48WJvWid4ZakG9/d/Kz7g1fRB0ZO2gK7wpX7Uw64b1Kd7Y70XlJ22DC+LiuCs51KoZHxgS/C3orpF+D+nUvZ8G5GWOeTddv6nbQEMODfnSfd8kLV6otzUK6xZPfwmA71NMKA2IhlUC1SLjUKE4JS3O1HTRcOmQ30eyJDZWguV2hKb7Je3ka9Jvas2HOixdTs2ppEd2RzUXDijWwa8W/YOqLCNrcIqMa1G5o4pEJlLzQWF1Z0kpVQlDn+QVJJ5ivlWAXym6Va+Hl0RbQUR20x7xhM46Asc3TWfVW0DLyFQHb5/Bk2XifEQHqw8IplSVrHVeU6kGRj5NXScJUK3AeVLSRT3lTDPNwYYlrM+kNKgh72ksQGjPzhTEdI2M3RuXTCC7DazC4EOMZwUA3iqmlZCR3ppBS6Bj6R0mIiNeyU8slvTgxKsvnQxnO2ODiX0RU9KdEEB4RyhH2cw3ulVWNoqDeCFXDYs25aXD+DLESx84oJtsrq7zhXhYcCa2i4qr3IkBzkuCXUjRCVB9T8ru0SMThEAJBT5Oz9jcZthqBx1s+7mM31j0OOjeEmkQO3Rpqb4usfFJGYL0Nm+XmlSN25hGGKR8Prl6AyPBbwZ03HQB932Olh33uc3FdopbYCMOzRrMNtHex6ST/85xgct6NbQrsv9Qgsc/cUU5QxYd7RV4CCEjaj0gs8AhbXGUyBEBNhLCtWaErhvFPcRu4ICFtX/
 V47xXopB
 1oD/2QBtIpsQpDoKhyGo0DkzhjhRkwwWN5DW3e7L4eG8YoRocCME3ExHSubKTldFl5fu2PR19bBPebhzJJ+f/t1U9pLWR7sq/nbPTwuQwdYdATRqoWQ1ZTE+vo+lIY0hC8jDAgO0akV9rTAXlYSVB1KVBrRuQV94t3Dw1sE6fObaa4Kk5mfc1A5eMUvxMWAz3smjKoIshBw1RsIi5frXqbEPnUM4nnBS5NZHAevHorQmODLXvXwEoGbH0kU7ffdbslNp2UKLfQhQ3y6gYljb4n0ulcMc06HrI2iU8MKMqDMnrZXpUx/i/ET183Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the first version of this series that has dropped the RFC tag.  From
the next time, please reset the version number when you drop RFC.  E.g.,

    RFC PATCH -> RFC PATCH v2 -> RFC PATCH v3 -> PATCH v1 -> PATCH v2

Also, droppping RFC means you think this patch is ready to be merged as-is.  It
is important because the level of review should also be different for RFC and
non-RFC patches.  I'm unsure if this is your intention or you just mistakenly
dropped the tag, because I was expecting RFC v2 for this series.  Could you
please clarify?

I will hold review of this series before the answer to the above question is
clear.


Thanks,
SJ

[...]

