Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ECD0606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 03:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CKNMIQEn
Received: by kanga.kvack.org (Postfix)
	id 747186B05B0; Wed,  4 Nov 2026 22:54:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7396B05B1; Wed,  4 Nov 2026 22:54:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6349C6B05B2; Wed,  4 Nov 2026 22:54:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5B96B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:54:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2AF214085B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:54:03 +0000 (UTC)
X-FDA: 85399697166.04.B934C50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2080D40005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:54:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CKNMIQEn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793850842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SyYtWJd8HkAgxcNPjNyLkkcWf3ysT6ZQbYCzKJBembs=;
	b=01rOrhrVDPG0+nT48qPOLAW2vc/HebtqF0ObqekbYHxy/8kCPn71O6YJ4viP9bUxXEvVFF
	5sIhn47I2y8GoetAOw2ER3oyPeiijf0AMbC0iPmXDrg3miigVq1q0fLiwYybZfUiNylxqZ
	YqCN1UdC0V69HjzO2Gg2fddRv+2FQQY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CKNMIQEn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793850842;
	b=m3WnrYlytMj41BQ0nur+Oe9ZXqkl2CIU+Cx7szNG9DNnjlxICXMu5jss/QutzwQO/uXrHq
	S5aiHNNym+Mnhtm/Ji8F/a0w2XONXXJRKXiabU/5D97CSnNt5gRzNpI9LNbRr5p8n9vRp5
	MurKM6JLh3+ywJZCaeJ4bj6L4hgFv7Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F2C7B419D8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9411F000C1;
	Thu,  5 Nov 2026 03:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793850840;
	bh=SyYtWJd8HkAgxcNPjNyLkkcWf3ysT6ZQbYCzKJBembs=;
	h=From:To:Cc:Subject:Date;
	b=CKNMIQEnnhY2QbBFROUSjMbFm4V6oQxsptiUgzTk6dVdjhi2uYuTS4ff3jB9hR5oy
	 W/wxI8iRZf7DBrvU6GoQG0jUOucDRSBO2c0frGqlSDwr1ahnr1S7xe8ipj3mIMpzg+
	 e/rH+4AjJgxdXDywJpm8kA7czou+8ouTnIG6VyKKmgiOsI/4RCrXeK047OugyJTD61
	 AEFsEYMUpMoSot8eE9LrM0JJhjNi/3NDDO7R1+If40yEDjxpruOz/z5WtMHS+GpGcI
	 /wPZTIt0/p636/wryBwY39rkt7fdDfnfX1k3xe86AUOqOaMDrQMYOq8dh12c9HETbx
	 G+LAsg8gtwtlw==
From: SJ Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-11-09
Date: Wed,  4 Nov 2026 19:53:52 -0800
Message-ID: <20261105035353.89667-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2080D40005
X-Stat-Signature: 1rswsn5aip93bnmw49nqx9j37fcozsdo
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793850841-932121
X-HE-Meta: U2FsdGVkX1+YyBHxewSptu8AGA0BKM2TNwzrTS6nDBQcNCa/0qJG5NWiIfBOcypQJLtibH5Vkgem3Tfp3xhRIWvxj09Qww/Z2Gx8pcQdUZ0F0baHugmnwpGhGLGnNJ+GKIy/+/sW6ktjdByi/JQM2Yp2pYdOM2XzhcYrmBhwLOsmxRI8zzkC00IBVGQb8xm8v3Lbd6+F3OHjVN17M4bqv43AotgkVUMwnvGUrG1ITcXkpvW1OaQFm15zxM8RsxWCkp+JzzR0PNmCNK+aVkE686nPxqYK2N5jC5sa5Eo2a+xY8GvasnaSbhhEdAGgvZSuYy9WvJq7ks/3bJteeSs+GvwnY0qpUuIWa7uZVVwysKozTWJocc8pZuOSeXrLBrXbjUetnQH7oB8j7XCGLOtMSU10HEsnG0RbTvi8OdPTGomNqEt67H0O11HbVFbmt7hQQzwIf/sGGrL1xILHU161gZjTundyqBa+ZHG87xfUBDbZE3dbrIsmezV6lxWhaDCwm1YPFt6jWuEdQFqcQetenJWgCAfq3frtMjjvlRLi2ZEP1x/72KybQ2RFl4h8tastAaWcmxdHUso9hNILY02k3NLyy5ySWWchMPrwdiZ/3avzGOKqIu84l9yuLAoPPR7XnCnrK/JmUqHXWRj0bCtCCGJKjcD4+jowjq72+8USupRTQvGkPziT1qmpZblYKZ/ydyPhVGRF7QVwcXcps5tqafmfIc2l4kdb3NjYFj2AgnSRgUELO+8mWzWQ4xh3UiXFpmB29KQqzOGtG34ivnfZoC67uUhmr5sIhhvnst1Jb1tcXL+tpiVcN1Zy0SZTLWfrilxfwEvWSAU9kfedI/cvq9/zNCGLl1iKsITHHkj6RzWdc9jHsfWIxGcdGfYQNey0PTJ96rgIqLi6KvuBa4b0LEC15cQpUc3sxCH56fBSw5/DEMSS1nt76K4xuBnM7fJ0+QNR1Ymh9M7palRYysK
 iqx3mTDV
 7PBFMNHZ0Io0U3+zoZJd2zyjjTKIAhLUVBkSxgAm1mDBSqUGIADGKqFMGLth9OUt+8DUsuEsgZQiTjfQis65HVrd4prkt4dpj0DWhHMFBadXWlqGAy+R+DZkG0YlYcJWFoMhtW9bIRKuYpLWD8VUJcfgeQWHv1udSwBQa/6638c+WC3G7W+9EdREaUupsRJzJyvBwNvpSDOOCNTJWNIntZe+61V6xJqa2/RjYUJEbBP+Wnit29tgBX9+sB4S88WBu1iiChapKVjLaS8DBCGyCL6ARMaHvsAvyO18wD8pdbxoeo8QIcGc1Ov7Le1jV4xHPCPHJWzDw/z6+PLGWzsEsdz/O7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-11-09.

As usual, we have two time slots for meetings in the week.  Next six time slots
are as below.

2026-10-26 (Mon) 18:00 PT (not yet reserved)
2026-10-27 (Tue) 09:30 PT (not yet reserved)
2026-11-09 (Mon) 18:00 PT (not yet reserved)
2026-11-10 (Tue) 09:30 PT (not yet reserved)
2026-11-23 (Mon) 18:00 PT (not yet reserved)
2026-11-24 (Tue) 09:30 PT (not yet reserved)
2026-12-07 (Mon) 18:00 PT (not yet reserved)
2026-12-08 (Tue) 09:30 PT (not yet reserved)

Please reach out to me (sj@kernel.org or whatever) to reserve the
not-yet-reserved time slots for your topics.  The reservation is made in a
First-Come First-Served way, and I will send a Google Meet link to
reservation-confirmed attendees.

Please note that other time slots are also available on demands.

Shared Calendar
---------------

You can get the schedule via this shared Google Calendar:
https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t


Thanks,
SJ

