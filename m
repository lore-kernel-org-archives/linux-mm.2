Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA62AE95A8B
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 13:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C48B6B0005; Tue, 30 Dec 2025 08:36:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E5C6B0089; Tue, 30 Dec 2025 08:36:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394256B008A; Tue, 30 Dec 2025 08:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 28AD86B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 08:36:59 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5501160135
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:36:58 +0000 (UTC)
X-FDA: 84276238116.11.1E49494
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1997820005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:36:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=luKXKLwG;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767101817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ghqS0BkPYGokZFh5JyDx/uPcfnt7NQHOUVbKH4JlB4=;
	b=nSlORW0QomSVqvghC7A1VAabi+eIn5InytRGXbF46Cpmy48ZCKAj7WU/DrVj8DwEjzoJBK
	RbD1zpguAzN0JBb5vJ/1MLIPlzbVdoMwaSs4aQtiS6dB9DMz5I/FwjdxED0ZYLzBDUCgoY
	xsN5jXHvcLikgJ8zJrrNfj/a3URMHoA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=luKXKLwG;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767101817; a=rsa-sha256;
	cv=none;
	b=WG9xGJYOseKbuoXCr/LpdKxjsSTY9vEkXQOEofPGeI7fVPQ6Xr3vXxkurrnLwC2ZdhXXKL
	ySgS7LUg+dWMXvmjbCNcQhPPpkVgZq+eJpzDPgNxFwauSPUd7jm7fgF34VcAfDDSxBYDzL
	g360lqBlfJ37YjLrpGw4oQ/ehREaKIk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B10160010;
	Tue, 30 Dec 2025 13:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E252EC4CEFB;
	Tue, 30 Dec 2025 13:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767101815;
	bh=RIo5nRP5cm+is/iw3Fdk+SarkwU0vZ/2LkptU9cVifM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luKXKLwGpleiLQ52LNbjoP4QpHdqBNNGypV9NO+EfnUuKS+kTceiOevrPpOSjUt4X
	 bEQC5ApRPmZwPKtU1w6BPgaUfQ9TeWFkuKXbC4UOhR8btejprAcdH4FHdUNGU66sgx
	 sMLaDEjluZAxtEsn92d04maEm44fOej4LBFLWLJoWt/TsjATdQVioU99CtYv3mpvWt
	 /meehLg1wApIWLtuqH40TaaD8uZ30kgcZWuRFPw0+62LaTOb7SyVJvbboAwJtSKSnw
	 vd9HuyQGC9FHXYd3MYoKaAO8HAktLi4Q9Hglr8JOZ8OlUV7K1Vf5bZWks7ylbbpMG/
	 WBG2zN0Z5Ts4A==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org,
	klourencodev@gmail.com
Cc: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH v2] mm/memtest: add underflow detection for size calculation
Date: Tue, 30 Dec 2025 15:36:44 +0200
Message-ID: <176710174243.4000193.7433666118508467327.b4-ty@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251229161321.9079-1-klourencodev@gmail.com>
References: <CAFveykPnTH456rMSRgpDO7VyN2EdP6eOq3pKUBCDdQa1kAJ4AQ@mail.gmail.com> <20251229161321.9079-1-klourencodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: k3r1qyjemznix143t1xpk4o71s1j8hrp
X-Rspam-User: 
X-Rspamd-Queue-Id: 1997820005
X-HE-Tag: 1767101816-812426
X-HE-Meta: U2FsdGVkX1+rYC2QH5glgJQYqhJNVZlsfFDhMcZn2Tcl5OLApukLYH7oZDf27rrosCxz+Tz1kjTzcXuLu3Um+5iVwJk5l9l2PTIZnfAEEuwNR4gFaEw27iB7lStbjA3GKnW0xnJ3MIQKP/zJctdNzEftpOhsT0wKiz2sl+GpHWxXZn0ju95WJley043QY93ASCzSqsW5FKlnwsjzCmf8u1u4cFYX0NAfSErdtqwmKH2C7l8mDO+c4ajk6t7JaoJb83G2qwyB8orcJXkChiGxmTDWfZTdejH6oVm4jhdIlyugpN9CYEERqE15P1hAi5N5yZNFjPitZzDyab1BeTZEeRnoATXwfJgFIN/tc+VCFtqpRHIT9LPoueAIJSRMXYmqFwq71oKypN1cw2VM+LpGEwOJkAYcHn9v+TDCpw2rNN2PfdOBGR8zDIRIHIt5J7tWh0lKwj5h3t01egx7kaswNooEV1PIo+UYyR0eBZlWlsyxPPdLqZLTSMOtgGo4SyFxeydOKnnoJ6XRxd+JL7DQYbhFCyj41VMbTzHqbBWgnQHXaVllC9U8DsRNvPvT+IbQ+vxU+KMB9CHvuUJOWHL9jMDvnFngX512PMaZcTck7eHCSDWDFGAuDe6SL3MFB5GfYY0fSdqDlYdeuYNdiL7KNLpKtrfWtfKSmHols2dHunKy6Dm1Bcpqn2sKnfLCDGC+gkMkAwp+1IHqjV5T89UWFz9rGAbkiUizreOuYybTVQvZ7YNQveWfC69HStdRI8inClt0/F6el15KVZDIIziFl3K4F5eWUZMHW82ddbO4wvs9vu8SVdIXnUTDw9nQUj68T6yuwD9XCv13tge+bYAWypU4l2oSm5vG8FXa0MmfeEbcXmTvW7rEFTqBZ6qDhMRf95F0L7atxYFhkvSJorSiz2uSxEVAOJEHsK9rqqqG+8Od6WUbe/cDdQaeeiM9Blw9MA96mzBisrUB8Qo7lYb
 8l3cIfAN
 H59TqH8/PCnzsx4MW2cH6q9B6W458PGOxwn+4Wy57ExcA9WvBBHupDQy/0J70UWEreCTzZkhGKjbngdCd/8JhF3ctxCkrPXd02MAsw8MnuQlR5IdAUMYimiDtkWojGRzZrS34iNNSMXuQ9GUjFiGuGg8O2f8qOh2zXSuGKqh1FwINqtlxg5INs/m+qFKwVUntU0DYke0i6qldpT2b1ZtBZmAGFYVSlSRYj3OJL6nRYIkFwGPuFuJRwTRdAufh3Mv0yxXpUwnQuTCUtPU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Dec 2025 17:13:21 +0100, klourencodev@gmail.com wrote:
> The computation: end = start + (size - (start_phys_aligned - start_phys)) / incr
> could theoretically underflow if size < offset, leading to a massive
> iteration.
> 
> Add VM_WARN_ON_ONCE() to detect cases where the region size is smaller
> than the alignment offset. While this should never happen in practice
> due to memblock guarantees, the warning helps catch potential bugs in
> early memory initialization code.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

I massaged the changelog a bit and moved VM_WARN_ON_ONCE() down while applying.

[1/1] mm/memtest: add underflow detection for size calculation
      commit: acd8aed2f2b6ce4bcc4f20e48ae88882b1b29fc3

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.


