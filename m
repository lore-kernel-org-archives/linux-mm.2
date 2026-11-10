Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3A1560A3821
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 08:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=C39zwkJX
Received: by kanga.kvack.org (Postfix)
	id 1194D6B05B9; Tue, 10 Nov 2026 03:19:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F1D26B05C0; Tue, 10 Nov 2026 03:19:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006796B05C9; Tue, 10 Nov 2026 03:19:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D51056B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:19:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 110A84082D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:19:41 +0000 (UTC)
X-FDA: 85418510562.08.63EC660
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf15.hostedemail.com (Postfix) with ESMTP id 425E3A0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:19:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=C39zwkJX;
	spf=pass (imf15.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794298779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHh8QP5RizpiZ/rOn8/fPhqoJKsZVAfXdzIBsu2Zprc=;
	b=1G93BwLRfnDjvJ+xVmhWBkNlumzOF2Lvqh8fh4P3nco6saDOBDNS5LP1u4DG8afEYI/w/H
	tPqQHtusjzy8X8UAonlFoWNuWh4shsHhPFlBiYeBmrLz741CUU8cZmwh52cdfAJeQvE05i
	WT/ME97+XQg+yFs87nlhR8TXXH5LPP8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794298779;
	b=jpY1SVy5DjEGlWVtDeJQHZ9xb536WQXW5xdku+G350zlR7FbihHN21/xA86qkbjkRAngm5
	P2pcCEE8202wISpm9Gk3WUSxYf7SHAXZm5GaZJTwAEXbY0Q/5n0ibTBBA6+nNkd7KdqoQi
	xgIW9YzM2AyT+KIBqDl8xdi05cSmo5A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=C39zwkJX;
	spf=pass (imf15.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794298775; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=jHh8QP5RizpiZ/rOn8/fPhqoJKsZVAfXdzIBsu2Zprc=;
	b=C39zwkJX6xT4I5spJ6/tbN4xRRkSMHvY2p+VNFC979n0wtSJbJzETyh2Eet1Bu72lvXRWYUybMkvTK04VsgpAdwZvvdumoMJKCH41j6s/Y9KZgDZVI/fPe6bT4ytMqSkSpQ+J+qhcjl7qQ12ZPqHGnjlK8yEXBwCVbM9fkSgEZw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0XEUf1sP_1794298765;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XEUf1sP_1794298765 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 16:19:34 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Weilin Tong <tongweilin@linux.alibaba.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: kmemleak: avoid long RCU read-side sections in reports
Date: Tue, 10 Nov 2026 16:18:25 +0800
Message-ID: <20261110081828.2446101-1-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261109211709.133122f9f10091f06c4acbc1@linux-foundation.org>
References: <cover.1793871596.git.tongweilin@linux.alibaba.com> <20261109211709.133122f9f10091f06c4acbc1@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 425E3A0009
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 75srn5nkrszsi3zf5be455k5iqx7wsu4
X-Rspam-User: 
X-HE-Tag: 1794298777-432763
X-HE-Meta: U2FsdGVkX190AjRF+9ihUDmh71ZuGKLWdTTiz4pdPHsmEITifvA38zrY+/nrRPybS6ykuIN7p4F9V6efU6cqIRZHIaBZQ5FKqtwjkqqk/yc+nUkKXynfTFOjX6wUAUiPnUspliyDvq2Xsyv1qz0zEngjpSF8QEylV7A77OAhuijALxkPkLUOLwUYzTIC6QK9mn9/vWXoNKXAWL3YGHsq/3Kjl1AQDJtdDZUZ/6OPJlBNHCBRMTerAoqoeombCramI0Zdj+e88ax9wmCO8kz84b5EasTzD7PspU7klizoxtpdSQS0PLUXLCBW1CycPtLWTs5X1Po5dEBNT4T2sDiMdttkg9RB+umzCzRYzyF/ZbFbAKKHPEdV/28E28MwMhW7A87Zf2ald1rn/XimbSycbjiHFkUVdI5uPylataXfaQhlGwgaBg3B2Mz5AHZv+Ttc6gK3/0K4mnJD0XF+5AieBYne+ZnmPKqlQ4yrVhpcO9MdbyM6parGG4UNyHNfhtpYiZ4UzS9aLA7Uo9MTgo2JoKmcUXrI96zyFP5WSxAB7JZ0X8mZwIXGQ1L490GLbVmsJi+RBthyANQ4wGIwEb1yxBNB4+TqNvTV7Pr255gvzCxEP8X7gNDURIdNt8SUGDU6Fr73Xp+7NuGWlgruZJIfl4+WaoL0Gu4TBeQvIf5TqFVzhFuQT2v2+1Hivhy8+0pKfT12yRvuKPlsIsbySfZADYvmtz2FVWpGNWvDdLLgjeoTAIDoMnx5Je0XCcKSIZ/nx1q9ID0hsJAbdTipPAjq6uyZ8vvNARhuUbkZow7ueSXnConKODYXuZPNGe9z5O6prr5OMcXObz+xRdo9d6bVLcLGECm0pxZ1cECkQJy9auLMpxDaAGinnUR5PGzhRFf3uqf/4XoXo5kuvT/lzCE6UqALlAVtxUQTES+cBG2B/WOXqr0QT4RSP5s1oVxj1yU5RycyA4z8BDGZUouqtI7
 3dfZDr6k
 LYbkFFs/LpXLAX2cwyNeX4EwM8SFimb3RkT4zJesq0CpiPW9yrJdYZqv4Vy4+/ErDWWNbj/NjYy8iAklan4mKB+bsvr7FyuCUJXdSFUXO7ppaIqkhOg6EYH6WO7Z8BdkyTSSAfL8TIGFd4H2Z9vQ9pQICxcHxAxD0qqdYg+CKnWcjc6LPlEsPupa+DnMdkNEI0Bupwt1dxpuh9bWD25zMUFexiDLuwWEqqOhFl2zLf2sY/pm4KUfxyXCp8RZA8qXVtaK5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

Thanks for the review.

Yes, this was observed while reading /sys/kernel/debug/kmemleak on
our downstream distribution's 6.6-based debug kernel, without injected
delays. Here are excerpts from the original log:

[1023772.105996] rcu: INFO: rcu_preempt self-detected stall on CPU
[1023772.152485] rcu: 	(t=65047 jiffies g=357990333 q=711371 ncpus=96)
[1023772.491019]  get_object+0x1e/0x70
[1023772.501186]  kmemleak_seq_next+0x91/0xe0
[1023772.512982]  seq_read_iter+0x482/0x1160

With CONFIG_HZ=1000, the grace period had lasted about 65 seconds.
I should have included this evidence in the cover letter.

You're right about *pos: it does not advance when get_object() fails,
so an unaligned position can miss the periodic checks throughout the
skip loop. Our deleted-chain tests checked safety, but missed this
progress issue.

I'll address this in v2, preserving safe traversal across concurrent
deletion, and add targeted coverage for this case.

Thanks,
Weilin

