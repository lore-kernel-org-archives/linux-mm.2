Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E37CA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 15:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299D18E000E; Sun, 24 Aug 2025 11:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2715A8E0001; Sun, 24 Aug 2025 11:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187B38E000E; Sun, 24 Aug 2025 11:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06D6D8E0001
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 11:08:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 613CCB6380
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 15:08:21 +0000 (UTC)
X-FDA: 83811982002.17.B4F233B
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id B6BBA20006
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 15:08:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=FAalNz8n;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=cB54om5a;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756048100; a=rsa-sha256;
	cv=none;
	b=5LPd7kGJBKWhnybxYowIpgcSNrEVAOd7YB0RUaBIudxugDEOOIlvFchFck/4EGORVPLwlw
	cvm9/HZ2aTTlNtZaz1u9R/JkgIT006HBU9uel/6sqTuF88RPlLdxh2Cwyb0cM7J33mnyXY
	YWv6hyp1ekZ981EhQLFuP+q7N6dCQqw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=FAalNz8n;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=cB54om5a;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756048100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ik/NRqYHSG8hmITK6G3KaWPdzyg/qMeKl48YWWYUqc=;
	b=zHYnS+7vzS1e6ghI/JfBUrhIBfGI31y9IGzFzehnAEwzfta9qqmi+UddWQ6NerYHcycJb/
	x1JF9/YR0iKTJMi7xV6dusZYNzUjTekVPwrHdNRSxnTS1UBiIuVW61a3SEBQ2qnhd7lzEt
	xAvRVSWEnxAcVJnW/WYxityHXZtIsQU=
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1756048097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ik/NRqYHSG8hmITK6G3KaWPdzyg/qMeKl48YWWYUqc=;
	b=FAalNz8n80tXbjLu1YEIFUu9UhX73vltRahVCO39qSG0lfGoaJew0vQszt0dphBAjPSnLe
	7C/FD4/TKQG67Y1B/y0dsYTwbjJzp8XI+uPmsYWLSRhFSL8psTth1rBNfiHP7Pwxv8lCkS
	TDI4rdGp9S0oezXRjJ36bL2EAtg+sygQdbSF6fTVdqYLjKZ7jo4U5NfPpkFOr2o9HOuWTj
	/6PuKr1BAXjl0+x4heqkOUOddzMYeBWs8AGL29P6pJnHTVKAF8UGAby6xTND2ABPKNgVED
	AOj44YWy7naeuHasGmrTDOFaMXE/8Txy4Eo3Krw9/b2ZNN1pdjjL+l+L00m6aQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1756048097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ik/NRqYHSG8hmITK6G3KaWPdzyg/qMeKl48YWWYUqc=;
	b=cB54om5a1WjZnAiZL0WpPY1A+vjsjucby/u6/KzywEDaNIPuqTKO2+T5qzphZpMpszCuEW
	b3lofR6L1VonsTDQ==
To: Christophe Leroy <christophe.leroy@csgroup.eu>, Michael Ellerman
 <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, Davidlohr
 Bueso <dave@stgolabs.net>, Andre Almeida <andrealmeid@igalia.com>, Andrew
 Morton <akpm@linux-foundation.org>, David Laight
 <david.laight.linux@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, Daniel Borkmann
 <daniel@iogearbox.net>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-block@vger.kernel.org
Subject: Re: [PATCH v2 03/10] uaccess: Add
 masked_user_{read/write}_access_begin
In-Reply-To: <7b570e237f7099d564d7b1a270169428ac1f3099.1755854833.git.christophe.leroy@csgroup.eu>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
 <7b570e237f7099d564d7b1a270169428ac1f3099.1755854833.git.christophe.leroy@csgroup.eu>
Date: Sun, 24 Aug 2025 17:08:15 +0200
Message-ID: <87h5xw3ggw.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B6BBA20006
X-Stat-Signature: qpb851f9pgfhyb319d4o5qih5duhb16j
X-HE-Tag: 1756048099-858413
X-HE-Meta: U2FsdGVkX1+OJHBtvH6RUuqHVHghZpOH7Yo0X6SsSj36hgGp0kVLoEeQrZVteFK0kTSRoWH0t999oZVuDj5tiGAM4ZxIy1bR4an56OFDcUZp9lf0/AHWi9C3lRuiJGZG4I4jvYPW3AtTBX0TmihhLl9EejojV2BneuoDxo7+X5uIO9y8QCLT+gMTc74lWqP+q4I6zGfOZdZHtMRZHr3kLNbg1SjEeQQlxx/M0N6xjGB+sIx12bOq5tWDSu2ozNrjHUYjUK04hFWXEtcQ1lM3Vb1XIyAJ1vgdqJByaaGprN+cM8/+ia+h5r1Oiy91wXkXhOi2v6jS7RexcMqSlv8MKHz+jNQEhBJBEv+DSToXzX/KYNSTexUfB0XlqmVz8cZTj2gW38e5ILnulYIUDNfuW1gCBNuyiJA/Maw10ykxyzgEwJrWPUIhyOFqzEZDw7OSY6+9Pskf4AFvr+jy+wqauTQWM3iLCgDTtMZqb+xjT4owiJfHFaavoqTec56gMU9MwB/U6rfJPWLrx1LNxwbzBUfnXQTBYzoIwzjBPlhlcVhuNb2M45O4u6asHKmW5jhgtewGaWfbN/As/jpTobIBLUUo6+BcPwLqp2fBgRKMHXJMmDXGX62EUV4nbmH31R7Smx2ab1iQwYNL/8q/862N9BfTldRp/vwbc00OZXzTPm+gp3wOi6ZtLVklShyJoe1UZrqCCEWOuc+XIZne/7f45m6mk0kO85hEYqZF4v/AVDethpRyag6FOwEuvGqD9nu0UZlKbPnqwNT7yvYMvjR6rf7q4Yzwx5oxnKEBgOjfDWOHe0RFk/H4PVfhG75ywLgUWhf5GwxGf3se04p9D4PEB4wS+/+1KLXmpZfDl/BYDetvNPt/WtLaTRrAWsgwWXLWUOkAbby1NuPeDkEGQYwX70eDVC7q1Q1z8HQwy5aWoEm2qmqDaSPzeXpMUaf2rEvxqEB48jQ4to5RQge3w1b
 B/IhR+fq
 2n3WdBUaBGKN7hk62QtPU/NFATDI5TYuCn+JY8mSmXtwj9V/GPTvqo6W5+gjJwxBSPGpH2SCoEQPvlW/AbgTomIbzbT5pMLktxDlkmDKuefdrLrNt2JK2naM/auLNSM6UQN6Bt8FVB24XA58BEOaYnvIGkTCFjedLVUvwzOYAsQ0kJi3w7SUdHcyu+XNOW5S+YbpUNa05QmCDWRZPB1rFfuqaslpkX5FUc0ATGLJ7t0qulGvlpAs+3V04LvKPBDHiDXuwqDwo8aBRDPN5VWEbIqYAxtPNsN9oBqZQIHEQTauAAtdqY+DQQLnthkGfxEINoqPzFEW/XGlfZYWl8nHfT9ko7dXj3Wna2+rV2AfHbddV+zRegJVPJUFjweOEU9dz6ScyAI7LfGh7Qek=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22 2025 at 11:57, Christophe Leroy wrote:

> Allthough masked_user_access_begin() is to only be used when reading
> data from user at the moment, introduce masked_user_read_access_begin()
> and masked_user_write_access_begin() in order to match
> user_read_access_begin() and user_write_access_begin().
>
> That means masked_user_read_access_begin() is used when user memory is
> exclusively read during the window, masked_user_write_access_begin()
> is used when user memory is exclusively writen during the window,
> masked_user_access_begin() remains and is used when both reads and
> writes are performed during the open window. Each of them is expected
> to be terminated by the matching user_read_access_end(),
> user_write_access_end() and user_access_end().
>
> Have them default to masked_user_access_begin() when they are
> not defined.

Have you seen:

    https://lore.kernel.org/all/20250813151939.601040635@linutronix.de


