Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031B3606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qJyIcp2x
Received: by kanga.kvack.org (Postfix)
	id 2610F6B05BE; Wed, 11 Nov 2026 02:45:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20ABE6B05BF; Wed, 11 Nov 2026 02:45:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121826B05C0; Wed, 11 Nov 2026 02:45:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1FD46B05BE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:45:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8029DA78B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:45:00 +0000 (UTC)
X-FDA: 85422051960.05.F8E1658
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf28.hostedemail.com (Postfix) with ESMTP id 22A9CC0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:44:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qJyIcp2x;
	spf=pass (imf28.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WW4T5PDdj0B0bz3oK5sZd4Z6A+mKi0CG/XCNeb4v38=;
	b=Jlwc2djKkF4TOgYGvvx4AzgfQZRI94eisi8QnvCerfgheB87jgOly08vlb2KU1obzxUAHX
	pEQUm+7wnQbBFUYeVF8q3oGWzIE9ID0fLfRS+EuUDm76ezyXEoVyNjeUxUedgj4XcgyT33
	wwkFKGUJqsUU3oPiXMdeDANY+LE8bKM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383097;
	b=r+uWMUzuoLMOxcMjmiftg47O/bTESxAyxNkQVakERIz6MrB7YTeqGVfCt3msNLzQfAHz02
	ZDbSczeZZCUXztXLtOAqbaYmJzBDv0xbjROSGrPS9HmlSG/ujuR2zir38Gw7+UNKmU/6q9
	WBHVDBLYiRAkjIMgKBLy1yU4xVCwACw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qJyIcp2x;
	spf=pass (imf28.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794383092; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=/WW4T5PDdj0B0bz3oK5sZd4Z6A+mKi0CG/XCNeb4v38=;
	b=qJyIcp2xDFUdjgMOtKM0o8uVGHA4hOJEbnd69VIgVIaFv7qNBYgFhatZeESfktRkC7agUjqb8mDSB6nAqf6+QrWXhbLFJouRL2g7l79R0awBBQ7ArFhMWTSExhufUmsLMnVe4WdlJGIQWBA5BvlKlDtqL27b1DvAyQ6rA/WftQs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XEYBcfp_1794383081;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XEYBcfp_1794383081 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 15:44:51 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: catalin.marinas@arm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: kmemleak: avoid long RCU read-side sections in reports
Date: Wed, 11 Nov 2026 15:44:39 +0800
Message-ID: <20261111074439.316823-1-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261109211709.133122f9f10091f06c4acbc1@linux-foundation.org>
References: <cover.1793871596.git.tongweilin@linux.alibaba.com> <20261109211709.133122f9f10091f06c4acbc1@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wifwi6s8iu83jbnyjudq3hpi99apbq67
X-Rspamd-Queue-Id: 22A9CC0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794383095-356318
X-HE-Meta: U2FsdGVkX19FD/9e2CsZv5kYdKSSFgBluqMkmHI5ZM1cEWIxV+bzIXml/M8TrKGcmLlJVjhYYqJ0n2R5WOEVBjtcUD12SzjpPlkxHkYIy2F1J0Pf2hAOn7sghec6CnIHPGtfJlJfjRBLNZbu5HSegm5F3CSQ5YhHdXwzIAAIa08Ga9P0VxyfE5O4nYYbLbXCxgtd8sTB9C0Uq4W9DZv8WKmHW6ONmtgUqp53qLo1izYsFTqxd6qCCR3zV6mVJLYpmudYahBUkcWVW0E0IZDYT+Z4W0A5g38Jvk/qs4iBiCXfhqkr18Fda8ZDokKSbMA8Z39Dtvn0bb8O2Z/9ierWc6g1iYykdbYer9ORjWm83r8N2qz9IFyI+9jwEI5tJNJUHFlk04nyZkyjnvBsrJjjmUlM6YvAMOxt6hrmwp2ZF33RKMmk3av0ZSkzSMqW4l3C9ALM+AwJVFy6whPmODGYFnGw3DdYSDsWuUxTLgyiMlTGt09cDqbXVD5FOB5e05ZmAyD5NJlrsBTr8E1N0PHAL3OSEx5UIDYGRHQa9M9M9iyE8I0hPZrxQPGwevShYB4FRPpYyHrtg/V5tDfI68EGENLyp3+vIO9eryFtGAzGuAD66wshR3mZ/QB/5Ungtqjn9qKVjZYFZ/zqdbgIGsZrSpKHQg7JIP0nR+HPMXDNySJRZ5zz36wcusu+GLvSIdnIEE1xVINXXdpYNPiBPyYmJbvD85D0B77PNLF54/TRYdR1CQTZolDOmE59WvRlewGOnsiuB8DJNBFxdGy0mifP+ohbXGrpQ3T5YJXjggLphHX2aX3ZKFOE7EUN1FvJCHkIFwlXC7PM3vny+0+YpVQP1YuaW9rCzAZRL45xSA7VuE+jkOVPKHGb1OqpNb02nYQ5pB/xIzKpKAh9PvmjL3FwcHexvTw1sRJF2bul1fppq8EKBpt9bt0e1oIeGoMd5IqM1q2Q0jDCE1k7lXM9j8i
 exFtRFMR
 KcFJqLx+Xd0bQYtkKuHpcZut3CIoBq8ey6mE2Y8XUx2DMJ2MoP9ePYyjHaJU7HwuVd6Tw9yGBYWD3ihNuuyI2DxRd3FQpL1zdEf37+XQWaShT4UqLf3+hFelIizfGRpSq09M2CdCJ3NfRuRmGW9P88nUDrYWYZl23x9bMCTPVFMdAqptz9HGl4aBNCOrJmdy5Hs0XyhKT6Mo+aGOZTw2VjONPKvZ3gZQnwV7nhgLCylhiAs0zFlEyZ5gO/zgrKoniDp5q32Vxmz64Uzg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

Thanks again for the review. Following up on my earlier reply, I'll
withdraw patch 2 for now while I work on a simpler solution.

Counting visited objects alone still leaves an unbounded RCU section
when walking removed objects. I've tested alternatives, but they add
either substantial read overhead or more cursor and reference-management
complexity than I'd like. I need more time to find a better balance.

Patch 1 fixes an independent cleanup race and has Catalin's Reviewed-by,
so it can be considered separately.

Thanks,
Weilin

