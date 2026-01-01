Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C4DFA3722
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F092E6B008A; Thu,  1 Jan 2026 17:44:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6796B008C; Thu,  1 Jan 2026 17:44:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0ED6B0092; Thu,  1 Jan 2026 17:44:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C8C416B008A
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:44:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B35A13CD53
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:44:25 +0000 (UTC)
X-FDA: 84284875290.12.B72D7B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D7D834000D
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:44:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ekkAZUz4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767307464; a=rsa-sha256;
	cv=none;
	b=Qm+ltZw+6r+MhVsh/0qgC2UeTio9FBE4UdW8xcX2V3/h6y6ZF9dLFYFXXt+hobYmoVgTuS
	lFnA9Cmju5VaJ/19fp2nIS9dTUmGXs3H9bXQxU9nDX6UBO3xnuKv8IhD1I8PMclo5Qhtwg
	ZKO9fRL7/KKWgjNVAw5Zet2DEwczu24=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ekkAZUz4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767307464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1En3gHtrluIkdGd+I+3BxfPoxcccIM47tFRmGmdoIBM=;
	b=w/rfdcMUmlDpZDWQVsmwc/vWFJVSpRksraoe3hKZVXv4FrVNUa5UiGtTtjZvsmKf6QRmlT
	NJmZMhBHa4ckqe6YXdEs4oZ9NCopw2tMiMCOw7MbvQw4jeBKfzmUpkDoegQv3JAN0HXRIj
	SOjGMN2dhK4R0sQMxQzgrnf/vmDRzzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A5C774432F;
	Thu,  1 Jan 2026 22:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5585EC4CEF7;
	Thu,  1 Jan 2026 22:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767307462;
	bh=XmjtJHTHxjwd7ITB1Y0Try2fxeiVf666M3I/4f/D41c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekkAZUz4NtXIlXoQYj8OIW3Ny0kLmMRUdRxjI2M9tkYMEN5kVdmyOScLzB0jbABYk
	 bWiwPvEy9nMFDuE3O93YG2GTzm4+FDCpvJdT9G7NOvPZNhRxA7NDwBID0BdMMbkPRB
	 JoFgxnnmcV9mczNdNYaj3L3HZnNbsLxufAgk2eKEnnMCjUFEq9YZlve76X5ZkyxpCV
	 nyybnFKdRlSA4ReGnaemO5vOSKuTKwdiwHIucmEYKc0GPn0brNVOwbWhDUBKcgg8BD
	 ghccf0+kND1Lrs3pY8PKIYt2MDP2uZO7EIrA1zn3qdT373u93tU5rd4WhaIVz/mQ3I
	 pT9LpCKjI5uPA==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangkefeng.wang@huawei.com,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
Date: Thu,  1 Jan 2026 14:44:19 -0800
Message-ID: <20260101224420.73826-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC5Frn16MiaP7AjzvJNPfnGXyjcWmhtwNnKQzXwz3VUL9w@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D7D834000D
X-Stat-Signature: oyu8ikjiipapjo78byyojh958r5ti3am
X-Rspam-User: 
X-HE-Tag: 1767307463-867674
X-HE-Meta: U2FsdGVkX1/3Lbd7frmezP2slAkhLJspb8TX+UN+8peheJMIeh1vGy7tpJzFvkw+IWCkCm1u1TM8IhB8UYqd7jRMJZY5rwCbM3llXT4eeyHla3nN5goAcZzcmM95Nvpnb3cLqO4Abw3o1ywC5LT0lwg6m/clhRwjVhxW9pBbEX8QiaTl194jezHJHCjInpxTV6Y3bGLvdSeCpQRQLzhngvZLkoTYsI0c5fAU63bsK8fLXbJ7N1zJVAHOLcHEUbHuJ1rwLdCMnuBMmnfNoJIrQT5eWQD1oLiLexuRIztX8jz61Z7eWflsa1bGYofPWBocQWAuEaASlXQJuGrmRxaPAma07m9XLrHd8qMGs+50pgtxGReyWm4gZBkBPVqdoZ0jKGct8orjq/uEqQo98DmENNYvCJnl3MEjvDfXKvJEKLgagkxsOK6kT7HGdUqcLMIQaZkuLlmsJ9jOFRzgHLVR+HziKqz0GebfBf+VRjPoKySEFB6C18t9qvKsggNJTzEb3t094tZEJiXJV5hf88JzyZPAlNK+N7A2SuSzX+js30HNF1SieOGtxOHe4wEGcSwlOf9tqEiXimYMw2bWrrCOIH2MZsO90iioidwuIhD6nXFWvX28QLMRJoU3lD8X/S/tNfL21E8bQt1udtmbC0Uh0wbXDY27eCBKlgStGgLAi940K+hHQqP/f4DdA522llLUmmB/qA2G2to4TDu2CrIlo29J/v6Bd72QHm2j5oUl0kZqD3FMRsfEx3MpOqTI24a4orkswN1l76Wmj33NomkwDLFCRDa7r3uKESZs6jvzw/70jAv+afsjE+LylAkrjmzl1GSLg7xWqHIV4WKIU6OdPnYyeIoDQOkPA87qsV4zJHHQN7QwYYBoqH+pZqT+wEmo6K/Drvqp3Bx4lbJqbPvJcAMCV/1WYYdtv5RVuCk2XV+ceMuySqjxZBRIbJOk7bDM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Jan 2026 11:34:13 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
[...]
> I'm sorry, but this conversation has gotten so long that I'm getting lost.
> I've given my opinion, so I hope you understand.

Unfortunately I'm still not fully undertanding your opinions.  But I understand
that I'm asking details about your opinions, more than what you can answer at
the moment with your available time.  It is unfortunate, but I think asking you
more qeustions will only stress you, so I'd like to accept this as a
communication failure and simply forget your mails you sent so far regarding
the fix of damon_call() uaf issue.

That said, I believe you made huge amount of effort in spite of your limited
resources.  And your report of the damon_call() uaf issue was really helpful.
I truely do appreciate your effort.


Thanks,
SJ

[...]

