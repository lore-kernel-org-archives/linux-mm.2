Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67BE0606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tychen.cc header.i=@tychen.cc header.a=rsa-sha256 header.s=spacemail header.b=DRfjL9oY
Received: by kanga.kvack.org (Postfix)
	id 6FBF66B05B1; Wed, 18 Nov 2026 12:59:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D486B05B2; Wed, 18 Nov 2026 12:59:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56BD06B05B3; Wed, 18 Nov 2026 12:59:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 319466B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:59:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9EB2120821
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:59:55 +0000 (UTC)
X-FDA: 85449003150.27.EFA819A
Received: from out-93wp-a34.jellyfish.systems (out-93wp-a34.jellyfish.systems [104.207.68.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5949620004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:59:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=DRfjL9oY;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf03.hostedemail.com: domain of hi@tychen.cc designates 104.207.68.34 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795024794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+MOui2s3VHNLY4HwO4iWqmzRT/5htSkOilNN5UtE+k=;
	b=x3dAY7bD15W8l6pF5XQ63PiiBWCNu/ti71lxuq7A715S0vTN/b4qxVoDecsv6xzlw2MZv6
	DraVmgSfWDigibTh2bEmHO058kQuCYxV0D75YYXMw2vMQGNOrcstNtBVIW2i3V98vDlHt7
	s7BE3ND//vwhJBzDtHPn+F4ecod99Gs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=DRfjL9oY;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf03.hostedemail.com: domain of hi@tychen.cc designates 104.207.68.34 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795024794;
	b=ZlGhsv2GuI01Kq+eo9hq5p8IDJMdtqMKAp91GMPw3AriXbB/gaw0oHY+f9sDCZ3hGN7t3Y
	UGY5lgv55XpwS0cSPamClw50rkpkSflXSAM2Eu8fq82a+VTg/nIIa0eBTTqsReJUyXGzMS
	QhRZxE+f9KRsL/MN0rQ45D2GKebhZGo=
Received: from [10.18.116.108] (ec2-52-197-241-54.ap-northeast-1.compute.amazonaws.com [52.197.241.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4jV8WP4qhYz8sWV;
	Wed, 18 Nov 2026 17:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1795024786;
	bh=L+MOui2s3VHNLY4HwO4iWqmzRT/5htSkOilNN5UtE+k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=DRfjL9oY6na0hu2GW5M0C1ivQzkKtqT0YzFYQ2EpNA57VyD2xtYoptOK5YARgKhbP
	 YKEiZeZcHEYGYT2RpEQEzvvqujTw17Tzmi/Sx0tmC7voh99InZxYA434pmPzujPjcf
	 6ZQPRVwB/lyNCdbuwlsQgzuZZsO3F1dP6TetGNHjzv5qMB4c4XtekShVcJeL5HnkSU
	 YXwodlwmv9xYTElwJ/dv322O+DAQeeGAIaa5zkrtitcdZt2al29QG6kU4hpIccMxqT
	 ie27i82ms8IaZYphlAt7vJtYL4o0lCUclqEmUnYcke1VyPid1DlQsxWXyiTrfAnEAM
	 wPrlHgpdScXBA==
From: Tianyi Chen <hi@tychen.cc>
To: Maxim Muzafarov <maxmuzaf@gmail.com>, linux-mm@kvack.org
Cc: Kairui Song <kasong@tencent.com>
Subject: Re: [RFC PATCH 0/1] mm/mglru: MADV_RANDOM page cache never ages and
 thrashes the oldest generation
In-Reply-To: <20261101160427.85701-1-maxmuzaf@gmail.com>
References: <20261101160427.85701-1-maxmuzaf@gmail.com>
Date: Wed, 18 Nov 2026 17:59:43 -0000
Message-ID: <179502478384.194898.8139869410612997037.streamfolio@tychen.cc>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Envelope-From: hi@tychen.cc
X-Rspamd-Queue-Id: 5949620004
X-Rspam-User: 
X-Stat-Signature: qfh1ty6cdcqghtpjcnx59enq3m367anz
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795024793-939976
X-HE-Meta: U2FsdGVkX19WCF5y1bHgnkZ4hDXF5rM6zkYJjq1E0nFcJzEuT35d6AvuEvYwifgp0rfzk/bTlQ7n8Gcx0wQnK9U+CA2gaWnaeUCypXOvwVD+4GyUqa870Q8M0gffLlhkpFbkg3YnlFP9y0xGxWBRQMEUoMHPnIYP17Z79z/jF3Gm7dqK18tx43HbNZ3jB6eRnES4I9odMIqhnSoUQDL/8CAibMBQtOVXe5uXFszcmEQQGWo3UZklOijPyflEtTUQKfuHIm02lUTUimTSQPpom+/tXtEA4vszT7JKFbggxe3mvOuOsT0rxnL1lKGEkaMeyPpLSNNevAjlTASW+lN67P5dP6sbDT08DY7CixcCZVFwPR9zVl6hkQM/v0dYEWGrizhWyFhkyMbtEX4O2OoQcAarvDvnJv9hL2jLAdm5NfjQJ0ljBb5BAjSl0yJC86GSbddtPZatuWDAr3QvgwN0l7rbyyyV8IgjXjYukJJJT+SxQKdwHpOwBv1pafBuso4wIqkg4w5QCcGG2w/+dwakfyinXmxqc48yA+pMGY1g36FtgpjxizZUnpWoGtOD//gXiZY5rUbWMsp27fYm/Uaj5skq3He01bZSeF+MWxRhlOvbvrFvKBgMLiGunE9lq31qSki+L7Kl0L4SDIbeeSFc+e6s+apjkS8IPGoMnm4B6oEnxxi7Qn87zl1mOgzaMOtfWLgkbLRneUSMWo2yVSsvlG4+DINwagelSp+w1Im6SGz/eMCc15R2m+UUM2M2Fs0jFyKsjpTHixQbbrbIWJHuN5KgnsSaqUNODHM3gkHaOir1G76tWEIuMo+eHzZjUb3/m6GxR2PG12X+YXU5WWDsGumHqVBi0wFKwTrmemEPiK6YKodiGUXWUrKsgMnElyrcAbre3AQbF0I1EW1wMekex8eraFAj05dPHvcCF3kDaPXVXN0n9GVIKBSDB/whS7JtBZ1uRbRs5Incn+p2pcR
 17ulCPCl
 Gh4lglulTt2Zvbqngu7lUJyuUdvAkBemm6EuZcV74MNSasFP+wnY+VJnORgdgPB92yG4piyLcvr/0Q13Frd9xWOpdJvWecKXtb1dGVB70fGUQg0DdHCBXZ3KrmCjwW33VHZPY1CUKHxscgd3NqIU462dujn0ko3Ltw+r9p7g4yl8MahYuhZr4ujau08e+k5EaNmLSeLJW5vGenrZm0HOJ0VWuUOGJ08feBmzZuTQzBATuBzr3P/83Dsb6ubBug0o79SqpeN7XxYR2vkQdHTOHy7icXcHvuF5ydFdIB2hsuNSpkKUh2Gnut9xLROR8DcGgsYRJbZs74/JoywwzrB5k10ORcfPqONCM6ZChdwKLQFfOr+jI0XfBUT6DUOIelNLEZ+fJWhmoL8M4W+uPL0ryTLl5JmUnjm/s3XwfF+xEySHMkCtggLbYMaHY4t+wK9XqWQzGErkJOeHF37D9l2srvOha7L8riB1UsiFKZkhtQBVhRW1hf89NeRDM/EopvOo3qgmUUAbB3Q2Xfjq+k8PS6nWAUk6YrVsTwLg1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Maxim,

I can still reproduce this on mm-unstable (1b697248a755). I used a
scaled-down version of your fio script: a 120 MiB vector file, a 38 MiB
scan file, and a 128 MiB memcg without swap in a KVM guest (scan at
about 5 seconds, vector readers for 14 seconds).

It looks like vma_has_recency() is why the hot pages aren't promoted.
It returns false for VM_RAND_READ, so the MGLRU page-table walk and rmap
skip the accessed bits for those mappings. Letting reclaim see those
accesses again stops the thrashing. I don't think that's the right fix,
though. In a single-pass random read test (warm a 64 MiB file, then read
a 352 MiB file once in random order with MADV_RANDOM, in an 88 MiB memcg),
that change evicted the whole hot set every time. I suspect that's the
kind of case the check is meant to protect.

Your threshold stops the thrashing too, with more faults before things
settle. Your patch no longer applies as-is, so I ported just the
threshold to the current code. It never fired in the same single-pass
test, and the hot set stayed resident. I'd fix this on the recovery
side, along the lines of your patch or Kairui's refault-distance idea.

Major faults/s over the last four seconds or so, median of five runs:

  Configuration                          Major faults/s
  Stock MGLRU                                    27,283
  MGLRU, count mapped accesses again                  0
  MGLRU, ported threshold                             0
  MGLRU, no random advice                             0
  Classic LRU, keep random advice                     0

I saw the same difference between MGLRU and classic LRU in a small
synthetic OpenSearch 3.6 test. The median post-scan p99 was 109 ms
with MGLRU and 5.5 ms with classic LRU.

Tianyi Chen

Assisted-by: LLM

