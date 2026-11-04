Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9A3606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=m1/TBuwl
Received: by kanga.kvack.org (Postfix)
	id 2BABF6B05BA; Wed,  4 Nov 2026 08:42:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2635C6B05BB; Wed,  4 Nov 2026 08:42:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1876B05BC; Wed,  4 Nov 2026 08:42:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC30F6B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:42:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F977A7A70
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:42:01 +0000 (UTC)
X-FDA: 85397550042.21.B9115F2
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf12.hostedemail.com (Postfix) with ESMTP id C4CFA40007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:41:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="m1/TBuwl";
	spf=pass (imf12.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793799719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IqEotgPDT1hegyi7/J8DGunAd5SP02PqdK9DhD9Exc=;
	b=pOx0WHkSrS0tT3b+Uxm7Lpp80FHNtHIeGD/Vm1Z3bm6QrkILcIFyqmVNcjPew1Y+zVJIiL
	JVW9AlindkuCUSzqUMPl4I0MBbmEoTx6O7UYPkqZLmzvtv0Nijfc+mH4/rzeOR/Bj3DEGX
	SQmiC4nt5hfzjMHMm2bKLnDazZ569WI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793799719;
	b=jweaGtOUaP5lwyeFkIt78n0gnfPjmyYacexBuG7c/BSX5rNP/rDr+90jiTk5mEMfGCN6YL
	9SDIpIcwvCG3dzVqbrWbYPXDAGmHR3WveaIg3TdZb/FXSQGvrZG9MOcZO2lIu5aC33EZi8
	ymXYwRsbC3R21mWTLJ9mlm3R0Zyhx9g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="m1/TBuwl";
	spf=pass (imf12.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793799715; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=4IqEotgPDT1hegyi7/J8DGunAd5SP02PqdK9DhD9Exc=;
	b=m1/TBuwluJUKU9g0aPAqQr0SgawskW5qRgQsyijNC5RnRFR+8C4FGgYE8LXPk1udR8IKKA3paslVHFCz7DNBwpxBKmkOt/6WhOiWl8HsvzqQENxJR8AmmJxOj+aaU3ZSMY4ZDMfbMzKTm2RnuyfUn3ZrQQfIxHUA075lLESdo5c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE5r9Xj_1793799708;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XE5r9Xj_1793799708 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Nov 2026 21:41:54 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: pratyush@kernel.org
Cc: graf@amazon.com,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org
Subject: Re: [PATCH] kho: Skip zero-sized bootmem areas
Date: Wed,  4 Nov 2026 21:39:56 +0800
Message-ID: <20261104134147.1695-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2vxz8q38lqp4.fsf@kernel.org>
References: <20261026131851.9942-1-cp0613@linux.alibaba.com> <2vxzld7kpmmi.fsf@kernel.org> <20261027074028.13042-1-cp0613@linux.alibaba.com> <2vxz8q38lqp4.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: csm48wj1ziqn4oumyfb4dhznxykdbgqp
X-Rspamd-Queue-Id: C4CFA40007
X-Rspam-User: 
X-HE-Tag: 1793799717-290409
X-HE-Meta: U2FsdGVkX19D0LMw5k9xvVBK2QTb5zBBhqTwvhLOuB8G5QF7rRT3hUW39JjScukLdLk1ssPC1tukUlmxjp1ICgm2+IhRbCCz4CyRrE8l4n6Uficei2aZmH5zm85nHiqqH5SpyHbw1+ExS8evhJEHgxQYNTV8/bl9hna2iJDl2xsV/VK1VxiVJMWhXhKWMgDZ2bdxUKXKWzzivC3v+xo7wtFBL9uW6ow1536bPfHeqE7fpml3V0nbcTLw27r2xt8CFe3rPGGuZGMciL93OhctHZKApF8wHsbVibPbtBpBiq33OpOv0Q6l7hZaMHXi9zx66iaF0LVvkO+p2Jr4O8/Z7CSds4WerL353SFDm68nKp3M9SsgZoWEpVhCkwVG2PcJ9ZpgCmmNCGIQLLGx0mwaqDeQ2MY1QSg0CS2BWllhfGvCqqZF2nu/pKH/8vTer4rgeWcyhbbxL5wxiLDTYFD/Lyq152MEdqJI3GTtM6X1AOhOPTseaH5kouHa1i5nADYD1s9jLm83c7QQibrLxw4IBMf0fxOJ64oTToe5ImcSbQTBGH9bvE1dPXR9F9AjEXtAYGSGXnzNoBWv2YoDdlcYfaYRrUlZyC9hzN2oNAU7S4bhvoi2nl7qVhlXnc1siXeZFH3ID8RlmHxEDVktkeN4ksfCT13CEv/VZTr0R2BIClQSA8hm9XjSVeMp60WomM41ZLvexEp9SAg3ptycUNCniGjNoXkZAP7FJMi/U0mPB1sVflaesyvzSewzntsZ98q+ve70HZCoLPqGLXJRH9tBlgDZRGP3CN9tYMNCUlOAsDRPAZit1L7+YCRo57WDvP28PthbaoSgW5k5Jycr2KICovxPEbFAdT0KpdHXbb/iNyj+gK5326KfGPeHtkFsSucu72j3Cy/2yJArxdLVKUSQ44zXGJsaarSOZ3V276Y6p4uZyEw95OIH/eV9GyCvNjRpjOSwGEOzUAHMvN4hcfq
 bHbw5Gkh
 vNLiA1snlqQZfwsIPIk/edRDmnYpK2ZQR8QUMCo4Uo5IH5np2PzRIcNwVQ1os8f8mS55w3YFSEkTFrlWrsYWQfwSRrwLTMpM9jja7tZUqzkmQTdDG0axLe8se5GlPPFlRBcVKaDuesX0qzFQnhJAU0HMxzrPbo8K1eXsrvNjrRtkMDfTaQXn6QdHD96pVxTdf4BXPuwlB4p0p9lt6u0icSoTjbJi4ZZ/o26PGDdiE2b5vsFQ1VddU/gO7orHymlA/qfPu1ckCWnxu7Dk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Mike sent out [0] recently which should fix this problem. Please take a
> look at that, and see if it works for you.

Yes, that covers it. The zero check sits in the one helper all three
allocations go through, so the three cases in my other mail are all
handled and my patch is not needed - please consider it withdrawn, there
is no competing change from my side.

Thanks for pointing me at it, and thanks Mike for picking this up.

Best regards,
Chen

