Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E869CA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 03:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3BA6B0005; Tue, 20 Jan 2026 22:40:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9607E6B0088; Tue, 20 Jan 2026 22:40:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8418A6B0089; Tue, 20 Jan 2026 22:40:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 743A36B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:40:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06EF613BB1F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:40:52 +0000 (UTC)
X-FDA: 84354569544.18.EFA0509
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id E8D691C0004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:40:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="p1qZ/DvX";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf20.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768966850; a=rsa-sha256;
	cv=none;
	b=Y53njdDH1aHd012M/0dTQ/CxkMUJzyYWhP6vmOgC9CutS+w3MvHA9XIqPBxmW5Fut7lClh
	1xhsDS/u5CHOxuXxfXm4rwpCefOKu6CRD1uIelZS9pUxOKSuXc2SBd+PqKUuVeJy/MplqT
	UiNIbDnlywYzUsU/Zfn2rlUFLHog0bU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="p1qZ/DvX";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf20.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768966850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/5NlwaPxjViS1OBICnOwJUUvT0oDr9Iwn/0hG6IUMg=;
	b=i85iIWgmThv13upjTTfnyQlnGasxFKVAwLi3KjK0xGnxBKA11xFkLD+fuQRphpMq3wRypH
	iqGzkM+CvPvl+jytVQYobXXdJfOvzVwwVefbqQlsI+Ud6B0z2My6HSCn1q60gGqF6ewdVx
	Ov3Mn4iDJOd+aCGpMIHMpPW3lOBY4xw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=T/
	5NlwaPxjViS1OBICnOwJUUvT0oDr9Iwn/0hG6IUMg=; b=p1qZ/DvX39+6avtk8z
	eutJjp9m4zUD4zGbjgDbyZ8cTGz2OwmoBR3H6NE4o6BcbSy/xXCPzq3nMK8OmRxH
	emTbAeaiVLa5ADKiDhNu59KSfipYOi0QDn6i/5HZxaNBMuVR2ymiYDZgl+z7/zeQ
	825BpLixLrfDY+aonCSAXOBAo=
Received: from zhaoxin-MS-7E12.. (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wDnN8iQSnBp8StLHQ--.46491S2;
	Wed, 21 Jan 2026 11:40:02 +0800 (CST)
From: Xin Zhao <jackzxcui1989@163.com>
To: shakeel.butt@linux.dev
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	harry.yoo@oracle.com,
	jackzxcui1989@163.com,
	jannh@google.com,
	kuba@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@kernel.org,
	riel@surriel.com,
	vbabka@suse.cz,
	weixugc@google.com,
	willy@infradead.org,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com
Subject: Re: [PATCH] mm: vmscan: add skipexec mode not to reclaim pages with VM_EXEC vma flag
Date: Wed, 21 Jan 2026 11:40:00 +0800
Message-Id: <20260121034000.51915-1-jackzxcui1989@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aW__D24ZrpeSPKZN@linux.dev>
References: <aW__D24ZrpeSPKZN@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnN8iQSnBp8StLHQ--.46491S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tw43uFWfAr4xKFW8uF1ftFb_yoW8WFyxpr
	WfGa4jkayrXr17ZFs2qa109r1Fy3yrCrW5JFyYk34xC34rWryv9F4Sk340kF1kuwsrAa4j
	qrsFvr95Xwn8AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pENVy3UUUUU=
X-Originating-IP: [124.77.188.51]
X-CM-SenderInfo: pmdfy650fxxiqzyzqiywtou0bp/xtbC6BItN2lwSpITEQAA3j
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E8D691C0004
X-Stat-Signature: pdhz1hag5qzqozckbthttm4iwiqouerq
X-Rspam-User: 
X-HE-Tag: 1768966848-622747
X-HE-Meta: U2FsdGVkX1+7JbLwN5Pr0LaVWTJltXWxSAUXbyLHDU0bYJosN6RmBXv3eG/Ee6SoFkx9zDDv/KEsCmYVX5vgJr6dLrXswfUi+2BUJz4it8ku2jJpN8pLwb5ZsqBWt/jC5U0AlVu7U2Hx2mM5h0jmuKJXpQOcx5ltJi72RDODG/xUGAjExLzfHPfqWCTTVuIOfkNl+RFwzvjiO55d6WCgmq2+DuSzAk0SUv6zl2djk2YalIwycBH6d9SNlFGQ3K0A07alNToFl90Dh9wx9P0OIJdYamL5xR8UvzzN6vR0Dw55FgxVDTs6w2+KdixEBCUWHQ+2tp8sXHiO4AUS1Vw+cd4/VZGXYF/4Hs21fUzkCExwDEgbd7dU4A0Fyaz7mGw9fbVyRrtdIAyEZ1MMwHzM8YxJVFMWqFnB4DAvjUsLq98OdPYrTCSDKqQeCBc2GMtYW67UbKw7II2CykdgqnyUTTtK1C3q1nlJcqWmA0wNA352hWEkd7p07v6Eg3PYn1qXo6Qax2mjMLICCrHjqrPuT6DxRfIWvtJ9643Rh4NdHcWQ3C4AhWUjCYwDkUvDFF+X2QuDb4BM+tLQ5hsUVDl7XIsqgRFlCfijh6QBHeuxEw5IiBRD6VWh44nKRWSYjA+dROiE0+rBRfHXYkATefyLKasTKj+7/VvKsSM1WdlpOwZ+xi7hdzG2t5whC7wibGfqpIlR9juSM/rZmyBmn2ZaJHCT3BtuQu0ye0P8ozXltqyokb7avcdJCVRyMbHqNb2a8tKLcyc4GPzJE+8YLhj7hUsKrTUKJEHk283MacPLaWwrnjj37iy3oZkI47BT1d73D3la9KlvQ0H21hnqjLLWAOJxidTGmRcX0qh8BBoP8+aR0bxo0KaXn/PdeEW6uw4c/VDg0SQ+BzJ+cg/QZVg7HQIf9Va5hN4pwB6OBBfo5XyfkaYppRKeIWabc8Qwrbc0mW/tNgY6NWCG5FtU1Mj
 f1zZCo0A
 /Da/+28p6L3W3/+B5RafYRyTvmBuAPJDhi3GID2/rkc7Dx3JfOXL8w1mPEHtlQfU4L350P4asgnPCYlrza3FNOZJxb7bbzBtnRtg7Y23Sv7YbZajXB+eiY9NGhYMvDAl5cIQLId0gTqKgEjmyyqTtmr+eztW7UmIT5Tpg0AAQD95JDZA101GffLvqkbd5U4QSvy/2T9J7d238CQfIMljPmW7Lc0F8WslqoukXmg2IcrznKoo9MnzLjtrs2bAtvluRI+T1W+by7qKYc1GGw0xXjAbpqXM+b1KgNnQ64eu33d1PNO3kD71QvC8ZAyUjUYMAWcR/+Vc8wBWuD+gNQim0A3VDp8Zb/iVkj29Zmf9hRKoNgmCS+Cw53q1ndvvC5qiFVqdPMfZ5kATzdrMe5h4aW+qpEIizhrHzdRS/1nJfgEOmZbWt6HH9nqBa1pIBGFlkkmZA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026 14:20:23 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 1. The reclaimed code segments are often those that handle exceptional
> > scenarios, which are not frequently executed. When memory pressure
> > increases, the entire system can become sluggish, leading to execution of
> > these seldom-used exception-handling code segments. Since these segments
> > are more likely to be reclaimed from memory, this exacerbates system
> > sluggishness.
> > 
> > 2. The reclaimed code segments used for exception handling are often
> > shared by multiple tasks, causing these tasks to wait on the folio's
> > PG_locked bit, further increasing I/O wait.
> > 
> > 3. Under memory pressure, the reclamation of code segments is often
> > scattered and randomly distributed, slowing down the efficiency of block
> > device reads and further exacerbating I/O wait.
> > 
> > While this issue could be addressed by preloading a library mlock all
> > executable segments, it would lead to many code segments that are never
> > used being locked, resulting in memory waste.
> > 
> > In systems where code execution is relatively fixed, preventing currently
> > in-use code segments from being reclaimed makes sense. This acts as a
> > self-adaptive way for the system to lock the necessary portions, which
> > saves memory compared to locking all code segments with mlock.
> 
> Have you tried mlock2(MLOCK_ONFAULT) for your application? It will not
> bring in unaccessed segments into memory and only mlocks which is
> already in memory or accessed in future?

It's a good idea :)  Thanks.
We may also try this solution in our project later.

--
Xin Zhao


