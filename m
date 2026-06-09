Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DE38CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299D76B008C; Tue,  9 Jun 2026 10:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271AB6B0092; Tue,  9 Jun 2026 10:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AF756B0093; Tue,  9 Jun 2026 10:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8066B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:21:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8622FC2291
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:21:24 +0000 (UTC)
X-FDA: 84860586888.24.370290C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 077FD20015
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:21:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vgd6qLQ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781014883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/I/SdsNq46aL/damhiClubyVX87JXrkNh5YqDS3XJXw=;
	b=g9Ndsy6/ssz1QM36MSztiNvVkR6Xge4ywRN++3gbHxPTS1aedjEZ1cblUPrZCxU7mwOWQD
	aEmWaVOOafmzl0ttcb1NauNHAM7RC5xgR9wLhbBcaCKydnH93LanCwcuD22HQoUBzBof1p
	DJHP3WK/1oB9Gj++ux/7aiy9SzMbG1Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vgd6qLQ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781014883;
	b=lxqa1dmFy+xAWXhlgfr4TI5tQGL9IkvOVUiQtsm+Xz9lm3ohGhC2oX7QoS1boe6K7kv/Wg
	18aNeIi7rpxgaSMbh1bK2Eo5hC02E3tQugqi91t80onJL+u307Sg+bFmsezbOOsGgrCk5C
	A380o2YqPFXIYikKMg7+/F5PjXlinJI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BB38407C9;
	Tue,  9 Jun 2026 14:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6FF1F00898;
	Tue,  9 Jun 2026 14:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781014882;
	bh=/I/SdsNq46aL/damhiClubyVX87JXrkNh5YqDS3XJXw=;
	h=From:To:Cc:Subject:Date;
	b=Vgd6qLQ2U/g3hmzeKh6rrNLiIX9mT7W+eOTz3YeN0q8c3rwLC0jp+y8pWWQAM98YC
	 +QZoW9QCtt17jZ2t8t8b/y66NhbQJUCGav/vkfdLpBnr9Bi/ByPyiDdIvyaXdqDpun
	 t9iJyq1k/gJL0SaPmJDU8cPTQfZyIjtiDGFexzecEBZdwTe8gt6oYI9JNX9z16TbZd
	 GX/kIxN9e4IN96SvipZ+ctWSjKHopOVp1+dMfhVBLQx4VrON/e1EjM4+A5zQb8YiRk
	 iiyvWAsIpBrAnr5Q+S9dRmn0wYi4EMEC5TK5pXKvduK8uInegjm0FzhQ6tqSGdtJhg
	 73oMtye6V7UWA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 0/2] samples/damon/mtier: handle damon_{start,stop}() failures
Date: Tue,  9 Jun 2026 07:21:15 -0700
Message-ID: <20260609142119.68120-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 077FD20015
X-Stat-Signature: 6mq58tt9w7768se338n678kateb4p5qq
X-Rspam-User: 
X-HE-Tag: 1781014882-998962
X-HE-Meta: U2FsdGVkX18qf/NbcdptgQLkGGTZkE5GrTMcDIL4oF520Tl3ozrUfeF8KWG7fUcoIEtwzfGnPmh1zgVre6ivIFSJ13b0Z7xizhjDci/4Vehia2YcGn8dmbaf3DnL0JgcoKLfQjkVoyxHc93TyoDXm3OOdy2rkDUyqsO0YAB4xEW99oeLybZfONIt9vhHx+q0pqAcPy/WMQYi/vUeIuJrWNiHcYkV1wpAqmkq+6W+d6y646cBOFbaS5JRbTnVtE0C/kolsOaq1LxDobNtjuvgh1oD5bVC2bb+HDAEbBretw4OSjhzQGuZcQbIcbfVb2eCnkXKbHTpIYELJ2YpUPRInWz1iG12I+phq9lv2FnyY/coHJ6f7+73JDsQDpoBxURMQW96EJyIYeDWngglbiDej7yCT9v0jchzIFjpg1orxCyfa/diJ9ki/5hoXumtgqqWCZ17LwEodMC1p+NcGICOy4Trap188VczOBGagBzEECcT5B2HWYWfeH4Is/1RYlK+JUuSihV0X1Wj0IOeVCsdTQkRo3cwHbUYw2AXQXhcWzRVo6mLHFZCJjSP9+YkJvi5B0LSpQW4tbsVeMFTCWVxNaeH+J80OU1EL8mXAq77CX8I+JOLxhkUI19TF8KYbWgbhhkbMUuAr/v68ctVfl1TXvnPCUimi9INoPJ2hKFxRbWE96gL3uhTg+AwbFwTzhc6tV1EJDrbwRU4uRcpGkDatKuiQhtkVUr1D+jD4yCZvpI2p7WZlbmmKNfXsVNzYjzHoM9LbHr48klpBPln1bIUhaH1M38MkG1mH6LMjU8xd1COMmLj7H7QV0eKHF6DKKgQmJ+32PfAycXNSB7IXyFaLjrNlvlu3TbWJpTvcIRlKHGkuUoEyxhBV7/nDaZ0+5zCKSY39rswk+OFoYVLEuBhCoP3htDz0qDSYvHvRDbs63wO7HqsaBF5FWUhNHP/h7jfrKXEC44VXUVDlAOTkGp
 Gx3vZLQX
 RBoQIv8XWSa2kwuTHZs6Y97OVsbX9YIHicYQPzJneswPckrYPNv1mHHNvNbWQrTWhB3yWrWnNOzI5zIiuJrmfwyiq4WE0GiCqrIAyVp6QCNvnWYyEqQ/o8YI6w6TM5PlB4AL0n0Uaef2OvQFy+VuM1Ge8VDqMrti1rrFtX/Lib0MDh7OPuA/tHzSbTbrLhwN62Ln2Ri5ssYXd/IaNw10R4TP7ua4PugIpfqMijorE/u9UJfab79QckzhS5GvRetgkFQ+9ocTuNcwD0pWtfhlhL0Hwvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sample module mtier is not correctly handling failures from
damon_start() and damon_stop().  As a result, it can leak memory,
disrupt next DAMON operations, and dereference freed and random memory.
Fix those.

Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260609005443.2122-1-sj@kernel.org
- Add damon_stop() failure handling fix to the series.

SeongJae Park (2):
  samples/damon/mtier: handle damon_start() failure
  samples/damon/mtier: handle damon_stop() failure

 samples/damon/mtier.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)


base-commit: f822d98f51b6e2b3ab41cad2e8bc1013d06f93bb
-- 
2.47.3

