Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0C32CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285768E0005; Thu, 11 Sep 2025 23:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D1B8E0001; Thu, 11 Sep 2025 23:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172DB8E0005; Thu, 11 Sep 2025 23:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 06E608E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:45:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97480BA668
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:45:25 +0000 (UTC)
X-FDA: 83879208210.09.82D1EF7
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id CECCDA0004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:45:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DhWVCziV;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757648724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VhR2dfGJ3MJkrrgv8n7mSFnqfZscAqFtNuOqBN+ob4U=;
	b=V10hzeMvK37WtcV3MiqvrvXXyW1ljDPFd5b8F+kcp9CEEDCB7Y8PSoS5l+YttKAColzD83
	EkwK9gXEA2YdaJ1j87YVAWNL5hHmVEGwkPSi1l5UNxRZ/66Lqv+/G3eU67dC+OlHM2JDe7
	by6A6soMNh04E8LigCG0CKFbgLYiG3s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757648724; a=rsa-sha256;
	cv=none;
	b=Dl93LrpbXS4qwFTLO49ElYl5SdE1sjXHXfXP6/mQkh3HddPZTI3AWZTFwap8b+4CsYCFUc
	axoAvEZ3UT/zv6zlsz4U3lGxJvg0SF2Ol2aYVScjQpWHrR0i79OjsF7itdn2TJDPvwCgI0
	OxyVBY9em6H3H1+ECLQaRob0RuTkxDs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DhWVCziV;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757648719; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=VhR2dfGJ3MJkrrgv8n7mSFnqfZscAqFtNuOqBN+ob4U=;
	b=DhWVCziVIZLAE1GABMJc4uBJjMTjXDh9OPH09Ts9hb0Af0kIOuzWyDtU5wEPAt718IhsHgmR+zLOoVyVBKEfjerOFIiYcVLUXj3NKxmvGluV6seMh/Kbof8KFsmLR5zvIiELXJi5e0Fk5gDw7I+i6YSgnEvEc7CYaZNoU6mMymA=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wnp5B8A_1757648717 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 11:45:18 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	hughd@google.com,
	willy@infradead.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] some cleanups for pageout()
Date: Fri, 12 Sep 2025 11:45:06 +0800
Message-ID: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CECCDA0004
X-Stat-Signature: 5b6c3913ffhyrfufahsc3zewbkcbca6p
X-Rspam-User: 
X-HE-Tag: 1757648722-184180
X-HE-Meta: U2FsdGVkX1+LSrHvKa6zFZpltILAhqmZH+ZYCsSqKA03X5gqD692FuG0GZAAbePKMBtX1bwQmnbv/nLkepYmA89BNmDci8Ja6AX9n1Fr7Npvk4S4BDcx5l/+2+ej8eEkmW6AqoWhjXiNCEpZ+d9U66NJrfeKinX1InVryE5Tyqiott0yJ6gP6Ilp2d1WyJz1FL+J3bw3pUSIJHDEInyQjBVgSCo5qgD5g1c4XD9OBnSA3RPfD49Nta/VPFS6uBsYpD1JCA6QHca8o1efewCzgEEqKmvTEhCrLL41JW+fpY8cJoVHmruKjdoy1ciTGAR1AfPCgS6ukpTNtIFyv0YhjqHDPz8B6oVGdfoeJGaTpizgoY0K6fma76cOCyRVR9mJ6rXv/WhHt5o4ZN4EScH/nx0jALYXyT9Ka3iUgH2eqZaIrOG9x3wUxVSsGYq/iwlpNlBmERHOB3xu7Luum+/iH4HCk6J4+Pv/G/wjB5M2F8xvvRkFsIGHTB5WpzqtqD2u1lsv/Lqn3LHOf/vMDfZIfbANM3nxsgqV8NOzi9hntnNoRpS6g5q6MKf4DsF5uU488HwTLsvrY6gXQ51QfxlaR5nCohC4q3kYaVqNN52c0iXWltUMvMvIFaljn2KzvwDMmpPlQMOLNbE3cFlxj7M0z+7N1xe7NNKbsfocYEY3gfHGgyx2POaJ+fYY7zKh2e9HifrCfLtD6pjVTVWaWMZtnlhC9HRT7MAPOU5g/AGrAklDN6ApTFs6ocWp5hRfwH6gxwe6bnzzt6F5dISW4E17bRwrZuQ1X1IdZ3qO4vY8ZX0rWt57E+8HvoH7pS5UWtZ+f0T8IgdsJiDGGPWgx2JSZuozk/JySxfDfD8EHKkV8PvOWSfJOjuZ0zhQzXo4JHfzy3jf30Ey/lkqWcR7PktOCB4czLwkTnoMu7zbPMz+9Oo8MHCON/0vDEW3S30sh9/5jhcU6KNtkU6XFPa9zr3
 eNzbEVxz
 4HJ7seq07blmZyCbCYg3mqakDEsmTJRaGP8lrEcxWWCHHAGkTeXSwRcAYxE0ebgBWp23o/smhhqeS60u10DVc1NZECNakVfUPROhOPWW9wsOwSLL+b3f3raMFrVQbfIl1/p4Ayb4pQAi95lCjjsTfMdVYDnjYeSxuTLRNNmvs2GGZx6/1qBAuCNnma3yLOsiq6vDgsiWpZjipSto/7M5I/kjK78+R28xWgTMP3fPP18gdhlKaKUsFHv0G87LBF9KgZM0iH43qSzwjbXquhAHuHuY+W9OT3SM5KrJ559FP7RdBVGdPSIERYG+ki0ILyp5AlxJO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since we no longer attempt to write back filesystem folios in pageout(),
and only tmpfs/shmem folios and anonymous swapcache folios can be written
back, we can remove the redundant folio_test_private() related logic to
simplify the logic of pageout(), as tmpfs/shmem and swapcache folios do
not use the PG_private flag.

Baolin Wang (2):
  mm: vmscan: remove folio_test_private() check in pageout()
  mm: vmscan: simplify the folio refcount check in pageout()

 mm/vmscan.c | 30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

-- 
2.43.7


