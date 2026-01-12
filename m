Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E120C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 16:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57C66B00A6; Mon, 12 Jan 2026 11:18:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18476B00A7; Mon, 12 Jan 2026 11:18:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58D06B00A8; Mon, 12 Jan 2026 11:18:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B648A6B00A6
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:18:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70A27160697
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:18:26 +0000 (UTC)
X-FDA: 84323819412.07.192D290
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7C2D5C0009
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:18:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b=WUXSXmya;
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	spf=pass (imf22.hostedemail.com: domain of srv_ts003@codethink.com designates 188.40.203.114 as permitted sender) smtp.mailfrom=srv_ts003@codethink.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768234705; a=rsa-sha256;
	cv=none;
	b=781oIxftZd2Q3axjPTC3N/kfumw7VucHWQubYp2LhpJUpYlTjDlariH+y7+EWKc8asFoh7
	2h2kaBwc1WXfxbWxeP24/gLzYbxJZndQADEyKvpQ6aDYvXJ0rS3+jQYgkofFoZSqb+Z58/
	fP2Q4/FhVAK8hNsRoXew9PcUeM3FXck=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b=WUXSXmya;
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	spf=pass (imf22.hostedemail.com: domain of srv_ts003@codethink.com designates 188.40.203.114 as permitted sender) smtp.mailfrom=srv_ts003@codethink.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768234705;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hjee5K0PvLG1HwB9aNicqxJtJ/+XY1tnsP3uN70nalA=;
	b=fcV4rpJEf9jPvv7iRB+QCc0PjA0p/JZYnhEYUssW8uRfjNwxvRjYmlwtA4LLsPoi1LIgJ5
	UNco2j4eVkmp4G2etSjYkFjjQ6feIXsG2V1ZGt0MhADOm9wWi3em58C8HZM4yFMZTnrtgp
	flLwGgUCuw5qg75vXbTzJd5ilnRwNiU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap4-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:In-Reply-To:
	References; bh=hjee5K0PvLG1HwB9aNicqxJtJ/+XY1tnsP3uN70nalA=; b=WUXSXmyak4Br/h
	5YeAJuruYo5IzDoqn4HYQaPq8d/SPU7yZpMUmrmqS9GMCcLhdJuu8SC+xbFxqT2JUDSl+Rwgs0/ci
	huL6WygWk7hG5KNWa/x4BiCnBAKB3He+/KsZ4ewWZxBrlQgvASAIy7gszmmAcLt27dKjo9MwiYzDZ
	a2Vptq+xB6Kdp0uXERZkbNJjfFYHvzjnsQaHPL7Cvngmx+nBDG1dQqxD1S77p8jobCunC+o1W7aZS
	qWop2f8f9bZ/s/J8K6GMfLYzO1bv1x9y+XJ2PBpOum1qeayRvfO3gwjN1Ki44fJCie041LnbazBPh
	Eon7rx4kH7RqATBr6R/g==;
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1vfKcV-00FS5S-Tb; Mon, 12 Jan 2026 16:18:19 +0000
Received: from ben by rainbowdash with local (Exim 4.99.1)
	(envelope-from <ben@rainbowdash>)
	id 1vfKcV-00000002XIe-2pDW;
	Mon, 12 Jan 2026 16:18:19 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] mm/khugepaged: make khugepaged_collapse_control static
Date: Mon, 12 Jan 2026 16:18:18 +0000
Message-Id: <20260112161818.604651-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C2D5C0009
X-Rspamd-Server: rspam06
X-Stat-Signature: 44tc9bx6bkwxeejhrpd8ywg1gf9jb1fy
X-Rspam-User: 
X-HE-Tag: 1768234704-768702
X-HE-Meta: U2FsdGVkX1/Nz1LRF6/schFc7DSZYiDolKSp23LGi7UhzvQ9zyWRCDMws47W4ARtbLq2Hy9rZNwc75+VzQf2P31+JypH9BVPFztULobvq7fnwKLgAz1bIaDfLj4466b/a5afIsB0GQmMuge860REHMZo07HJWvFqwJtM6nQm89WwwOV/vPAo9VjlUQp8G7ubn4XATEA2LgtBEyqWaMGNUt5ab4IcCtPF8SZNEDDaT7Zsq06J3Li/nD2z7hIdIO+OmoHC6m55wXxPB98Dv0xXlQ6nuuP6gPC/Se3TT5CSAUe6Zp6sSvkpmcxsZcpgcVqg+us6c5woP4VHUpyfwDno3jaer2LiqcHlxukorPW21Hrrlb56rL8gJ8YMrV9hG5jToesB1a+BfSYv3M1wQn98wClVcFR2geOg7kbUppm4cd2aSZYzhX4qUA5zK1x/v/jZVWYNg8jsp56H38pSoQUgh20fWHrgyYqi7vIwnZ7Z4PIVMMVk8KeesqPyX1o0RMDjrS62sN53KJudg1ZjxoPaU4sUdNHSzvFrXfiqEfjXTkppATGpNKRZTT1uIMx4i+WpR4+ljIIFK2yw3A3CPsMohxoQ1uuBgqXC47rSmyeFxWzklSLZM3InX4tJNaFWcak0gM+YuGjsFAbvqLJhBLPWiomo+hd1lBMjDkii6BuxuUtrtZu1Wyqjc6b6puBeqGj8/pfHnQetz2K616IPrjjCd55rSnovCCdnprHkSY/FPIJzh/TkkoO7JloqC9DesHPRqdObjMK14l46bGCJ0018hgbB8E/Agjb2v9xpgK6wegeR/RtSVVwd/zgY9efOwid/q6kT3XIUcZ0+Ex5LcZaO0aUY3SRT65Lv6dokK+0gHzZbi5yJxRyMgN3wQN65XUnrQACFYu8ptDyadbnd7bjAYtBi4fq5vy9pFetrh7ytscODV09fJhZkzFPwOnt6Nz53lOFTb7mpeeksTLzHBy3
 XI7hjYd+
 e1dzkCTHIpx/sjhaT+k7eJbrxmF2qQrZc8OK6bUFu/dcNvgtGJqn4RwLUbPxmX79cA+qCoh14EoPxZvzb+N35Ar3CTqu3uv1ymlYSjk9YzGU0J2XDpO8BnvTiNYochmfLO9nfZNj0SlyOnmuf/fYrA6a+1uZGhnFsKjHr9SuqxukHPAHSV2HcZw1J7hro+OBaJwtPbzdYVTXeRleJCvJwmQ06YR1iKfXpWTyxtuAca0wPeRlovnMmL8rxcXtrhZS6AZvbpgwUtGNaCh7Du2mRsPgvAs1t1YXK82pvQCIYkLVVqtndypWB7UAP9QgVWgfXwrSQ3+Ifutop6MdzUOU9oK4LL13klK009gs1F304Cgvl73LWE9npuqyWzHR9aS8BYuqZcM5yhotQ54J886iozusrOt8MlKLarbbt6o7vIYORG4fAe2hMp07QOwJz4QGzP47noJ1RygWaJwj8o3mRHYTKyoKf8btpE7AuICFvS50T5WKQJGa2V2ekPBIM6ummxuSNhV7dZxP52Jx2NwMjs2v+CrBPgOC98Eii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make khugepaged_collapse_control as it is not exported.
Fixes the following sparse warning:

mm/khugepaged.c:829:25: warning: symbol 'khugepaged_collapse_control' was not declared. Should it be static?

Fixes: 34d6b470ab9cf ("mm/khugepaged: add struct collapse_control")
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..c9bd0df632bd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -826,7 +826,7 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-struct collapse_control khugepaged_collapse_control = {
+static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-- 
2.37.2.352.g3c44437643


