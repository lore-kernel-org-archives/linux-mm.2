Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A736BE75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F309B6B00C7; Wed, 24 Dec 2025 08:49:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05266B00C8; Wed, 24 Dec 2025 08:49:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24EC6B00C9; Wed, 24 Dec 2025 08:49:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D21096B00C7
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:49:59 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9AC8D898B7
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:59 +0000 (UTC)
X-FDA: 84254498118.11.90A65E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 270FF20011
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AZKhlN4Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584198; a=rsa-sha256;
	cv=none;
	b=SjghrgkLX5Yl/QSfH949ExFVVslqcf34FHBdBFu32aS6FXu43GHtIXXT2WzH4TJ9auUxYm
	8RZoQ29UVXnq1IY0NPRrBfl+7/+k7gAoYmLqaEPaE4kR3kfD7cv541bhrpkDjrbrLx/Nvu
	LQQ+Vrp5ExUjnpuP5JDg6WHiU7rfpD4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AZKhlN4Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBAU+1vA8rYiXSwMqWR24rkIwYymM7IYjgceDiaW7xQ=;
	b=leqfaaMN8oj9Zq+8DT3LZihz/HICVVw/uD/NWD8qYGMLsPhEb5ZobvhLJ3RXhgumhsTYGo
	S5qGfLWNxfGgk2cw4neZtT/otksfLZzGIol3CQnR11nt8lEvl6Hbb2Z1REyDcbAlp6+3hF
	SqLosnyCzGubp13D/s/UL7KxLnFk1+I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B50743BD9;
	Wed, 24 Dec 2025 13:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238F7C16AAE;
	Wed, 24 Dec 2025 13:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584197;
	bh=cybpUb9IFSrtSEn6CVNh90w6y5FCshbAQhcAn4rc9bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZKhlN4ZCrk2oVrczUIaU8Cfl9yGLfr/qc/pWWi8kyHLCEe0fx9NhWolAd7YcDLlt
	 BZRBuTClb6m61goQkCT6GKAVXOcIK63R0AZ/gCzX6LqJEXpS8KFXfgk5IYrlxh5Hrd
	 ih5Gs4eYK/CvhYUxN+KFzLqM89y2IYLd2t4I4+0R37RwTn/dmLvj1KFWsfa07xxmX8
	 A+yQmeCIeX75hR/L2CiRAKErUAks3/er1m7nVBvG4qby8kN8ul2qpLIbj4jd8fdsyG
	 mi90adLBUBFLzBlEta2jTpaheAt1kTVPB8RktHKdy2lV5WyQxLjFX1ENx8jWVdMRVx
	 T4RQU5hez+7HA==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 31/33] kthread: Comment on the purpose and placement of kthread_affine_node() call
Date: Wed, 24 Dec 2025 14:45:18 +0100
Message-ID: <20251224134520.33231-32-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 270FF20011
X-Stat-Signature: 66wo3airkty35gzysmjsfw8ijgsxjw57
X-Rspam-User: 
X-HE-Tag: 1766584197-557449
X-HE-Meta: U2FsdGVkX1+EeT7D2noQh5wAzy2Y59H2ITRTLVkKQBqnsTCn9oNKwP6KvPeQyEOdVoETISTdvKw9jinXJ/f2oBgfaauNPOteVamLFU8FripWUqDbxvEablxbDIVZAAti6ZKYGg2y70JEpHYctdrqNjqd7fEdYpM5ZQKTgcHGgfNWO7AHaogwrDcs8pyc0EfidookqyKAuYz53NXzb5oUJeR5gYr9VmxTdoHVb3VJ9SoZ6B0I+FotQGtpBZdFBIXXkt1iw2hi8I2rK7DDwfgWrYsroswpkD8QzABcCeFx7XdYmOZyUEH7U8qjSIi9NoX/pwWdMGUY7j8pzNN+vDmlBwqvKD0Ojpr70FAsQO0oxFnjqXlXh3WnipOeLHNl328FX754+MzNk7MYJjPiicFg9gj5hNfi8lJPAmhrwVJ/hUk9FX1NnAdYP00cJWdHnURLF3qt9uahon34wIpXpUgLCRCNBOqOawAaDlO+xUAxQ1WYKI0JHXk9CmesqR4qxHNhQgYc+xzmc0XLc9C7XKlAiXiGTPCunn9W7e3VlBUIJWxIoV0WlibSFxCQ4TR/shWTzcL57CXxtJ0LtXIe6vzT0H8jovUpXD6/4VS34PhwFXhHMpGzc88d/h+bTuQ6LF6wv4xWm+2/Gq9AnI07RYmSM7kT1J43r0P7zXitzOEE4j4y24Fkk1MEaVAefCO8jgicRUAsO1+xpmi3P7qRzwCwrWGCEDHvdaaHFVV1XeKn0n/1nRbaD8zThSbsnYqU4ambmhOyE9U/VXXgCUYxT3w7yERYoeD+eUYsFIeV/94keLYzHj+UoIk/AIEaZmUJ5aLOvPFj3ywKhVBqEcHUFfNUSEx32Iyz40HY6hM96uEvRF4M6Erm0WB77cOTlsmQHFFF68lk899pybBviMhvvre6OhZMmhRnBPCBaUTweg5j0vw4kM3GNOmsXb4tncjq7c1dNrr+jJT2f88ZjYXRQXZ
 hacm0oXz
 N9NGfT/TYjtvOHUc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It may not appear obvious why kthread_affine_node() is not called before
the kthread creation completion instead of after the first wake-up.

The reason is that kthread_affine_node() applies a default affinity
behaviour that only takes place if no affinity preference have already
been passed by the kthread creation call site.

Add a comment to clarify that.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/kthread.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 03008154249c..51f419139dea 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -453,6 +453,10 @@ static int kthread(void *_create)
 
 	self->started = 1;
 
+	/*
+	 * Apply default node affinity if no call to kthread_bind[_mask]() nor
+	 * kthread_affine_preferred() was issued before the first wake-up.
+	 */
 	if (!(current->flags & PF_NO_SETAFFINITY) && !self->preferred_affinity)
 		kthread_affine_node();
 
-- 
2.51.1


