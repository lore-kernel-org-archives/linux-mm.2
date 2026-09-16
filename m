Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D351FC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9686B00AD; Wed, 16 Sep 2026 08:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D126B00AE; Wed, 16 Sep 2026 08:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CACDD6B00AF; Wed, 16 Sep 2026 08:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6CBF6B00AD
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:03:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B878E1C2CC4
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:22 +0000 (UTC)
X-FDA: 85219490244.11.AD7BF11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 11E27140006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q0FdByJo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q0FdByJo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560201;
	b=DvKuq9QmNy4AHTglHazUIRvJigU5w5tWxy4+3bCPX7GT+3Jw12fGVkZNVGmwKe+7HrWfzb
	eEJx69CYm5Rze/6YEaM3TtX1m1WPe0PCmzhVv8bTNRa3iIGHEUm9XfW7T16WdmsqruRx62
	0knyNhQOjKR5gOB5GPmOmYiIGqSfxJU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waNeuygMDtlm0C03ZytfUl73M0zkpwkt1aPQuPSWLWw=;
	b=M6Gt6sv9oUkGftraSJhO/bEl74/cJpGKlV0K02Dh4IzIPvPLr/t8bPxB9QMshtpEL9Nz8B
	mutQbn6673iE2J0m5PN6envZMEtWi8kG5poXaPM8iz+k/dufE5wl8cbkQZpaxcKM18pRkV
	mp54gxuZbnjrnpv7MyEGCBxv6yam6mc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 736D9602CC;
	Wed, 16 Sep 2026 12:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F901F000FF;
	Wed, 16 Sep 2026 12:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560200;
	bh=waNeuygMDtlm0C03ZytfUl73M0zkpwkt1aPQuPSWLWw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Q0FdByJo2zQubwwDanKYIzUBcXtvTMfCBp48qm27YmTgxRoSrMstqxCXZn3n7+Pnh
	 P8XMlopALRmq8brgzuz4FAcRj2moZDa0LqfAbG79mV3jTtUXfv4vdc9jhr0hw73wTo
	 52/CDFK4hCado3mS52WJGzfIygnK84s1ZlEWQ3+ugodrQTObrzgiqOti0s6qzDHZRo
	 tlEV3WM6VvQjmHIY7bIdGGf8DUN05ZodD9RR1JpT5RndszfIbav2A/M2NMdpeGm2Aa
	 bJ8gq6x4hJMLIGe4kbp889e4uiTDAHZCC774BMAR8DI+a4djw/squiF8LHaJTw/eS/
	 HdAYo+u9zYdhQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 15:03:08 +0300
Subject: [PATCH v3 01/13] s390/chsc: Use kzalloc() for CUBs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-s390-cio-ready-v3-1-39e4894637d6@kernel.org>
References: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
In-Reply-To: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 11E27140006
X-Stat-Signature: xxsg9gjacduycagoruqgsqo3k7k7sz1j
X-Rspamd-Server: rspam01
X-HE-Tag: 1789560200-569173
X-HE-Meta: U2FsdGVkX19BalK73YO/4KWP9FGo+4p5K9QftwAcIngqNoFL6uw3BMlBpkb83mIIVmDZzyAkNpXtt95lX2zhKPe8eExdvslQvToH/Z5BMYcdqUZTbPnIauQnqRwDgq2p9TuoR13jWJd39TuMgMyVNOswYn440EDq4J/RJ8pU6vWYpLdoxM2YneuGLLiD230Ta5WmDKmy3oJnlIWuPa0wUFlWXd1tJAsT3+wjiRXjPQisUKudpqCMYPOqtQaH9YcwHy5SV+SPVeTTn+XUT62KglQsUK1+RbtiIIeXqS/tsC5geCkGNVjQhnnCzQr+v9Zi1OEGKDfSD6OSEupf9Z0VLDwFLgFtcRU8tdoqEQsZ1shPKSsn3ej0B/S0eibe2aI/0iwEm8n8LO8mUF5MYlkfWPK6+iHKDPngGnlk9+J1KapPIwGOT8mJ4d44FLj+muCQiipBS3mtt4If+EOd8/lUmfH1cEBxnx2DvHJ4oOr3GHDvJrI9/i+CQBOrqrRTeWn6tZRFu34mXvg3vmqmtXpoinD+cLnDU+i4t8d6m3siI5fo6kJ+f7vCMgmxvQNtTdpiIuhJtTD8lgU3TD3gVZvIHT4RICTQd8bMwL95J6Ax5xnzTjKKoHI64PsNLv94rUZ2ejBIfDRDUYgu3Ik3kD0Hy6ggfB/Li487l5RKQm8Xr5e5lz8BLu/d/6Z8Y9+SXuirSTTnpH5gxNDmxY/ufpMGyk5PBVvztedLsEApv8oeN6Z83Vt2tMp9YwVDSwzL6jkPGrf4aStn8c27tRigz4JnxrPlo9U5xGP4IVjnSuf1Fttw6wAECUM4cVg7wlOKHEs0VPF02aKTocHZFDac3T97NTz5gFh4WX2uEKSTlHc2zRdVzfbeMQAOaEVzu/UbcvJI7lQ+qWR0xWTs4ulYK6s0Kf78lSFpsY5k1cZPK0jmQBmCbc5w4rYuSvre6XywWIQAqaraeoMTbBwc1lzetPU
 CF+s1Pea
 9sZ7fKFkkXxRe/tBSjN/2kR5/pumpSoCOwnPXtnzHZ5pexKdpSQoWRRrC2zm7cOB27G+yLePFF3pJbjOYueMnF2VHpscf6DJdKVxA0L4gtl2N6XgR37+e0EYpUOvyuAj51AiOi6025aFwHgLVgLHLxMoO0+mMRNYonmETEc2izJApFka9xEiKHD6UUsnNh+d2urmQcVhgO2jAUJIu5wBE7j8JHKAm4R656DidbddBpmci78md0/ILY0YfzE+SVxB69H3tJaNiPF2+9cc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cub_alloc() allocates the channel measurement unit blocks and their
extended counterparts.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/chsc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 9689f722c863c..60a4a7e6086ce 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -931,12 +931,12 @@ static int cub_alloc(struct channel_subsystem *css)
 	int i;
 
 	for (i = 0; i < CSS_NUM_CUB_PAGES; i++) {
-		css->cub[i] = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		css->cub[i] = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 		if (!css->cub[i])
 			return -ENOMEM;
 	}
 	for (i = 0; i < CSS_NUM_ECUB_PAGES; i++) {
-		css->ecub[i] = (void *)get_zeroed_page(GFP_KERNEL);
+		css->ecub[i] = kzalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!css->ecub[i])
 			return -ENOMEM;
 	}
@@ -949,11 +949,11 @@ static void cub_free(struct channel_subsystem *css)
 	int i;
 
 	for (i = 0; i < CSS_NUM_CUB_PAGES; i++) {
-		free_page((unsigned long)css->cub[i]);
+		kfree(css->cub[i]);
 		css->cub[i] = NULL;
 	}
 	for (i = 0; i < CSS_NUM_ECUB_PAGES; i++) {
-		free_page((unsigned long)css->ecub[i]);
+		kfree(css->ecub[i]);
 		css->ecub[i] = NULL;
 	}
 }

-- 
2.53.0


