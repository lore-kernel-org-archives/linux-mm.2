Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 627B6EE57CF
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 01:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88ACF6B0088; Tue, 30 Dec 2025 20:28:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838AD6B0089; Tue, 30 Dec 2025 20:28:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739E06B008A; Tue, 30 Dec 2025 20:28:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 605AD6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:28:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18F8058D6C
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:28:37 +0000 (UTC)
X-FDA: 84278031474.05.1156C7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6C163C000E
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:28:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eu9RvOUC;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767144515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pn38KbQly2Ro8W2k1CEtD+ZvjBbg/zRDcf4EYt3King=;
	b=RKZON3myVfMCuzPsxjfmF1fpNrek4XoMbBCmR63EQaLgx9UIXDd5q6o/dwOdmyyHsnlHZH
	DQqAuXOiuJlGzCSO3b/7qcYS1scOgutMwnPf4Py06eNWi2Tv9bAvpG+fJHQ1suMtUPUxFV
	dIPLJzeYbp0ZUNK/HTs8VC4hG16BsJM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eu9RvOUC;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767144515; a=rsa-sha256;
	cv=none;
	b=i/la2wLjdvOr8cYkDlFxXHxe3po0BvqzsV+NPKd6/xeSsOYWufqWp7BQAIFKbgToHGOj0k
	TfFtS4yw0EnGdHCcQO2HZqqExCSSLKqVtkqQPSy/9IG0xNmlcGKKv3J3ndWlcJ9uwYpEhN
	ceGxWtlRbv2ogv4MWZBtXeQ8WlivmEE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 32AD543E70;
	Wed, 31 Dec 2025 01:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6F8C116C6;
	Wed, 31 Dec 2025 01:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767144514;
	bh=ieXve5YsxFahnvCXjygTnnUDVMZBIFsMEh43LtkNUPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eu9RvOUCRm/FRXhdQPiO3RGhghrck1gZTxKmmlBdWPsvvIQYy98ClGWMuupobsQoh
	 B65UHQAgMM1sewdGri4oW7Sw+NgRn5IfM5i31t8Ev4rIqFSfHAYM2BzOHNCDaKsw1g
	 rML1p9FNIJ+H4kJIGSKRpxpIoFDBs4pgfSbXCQjmJ42evOGIzW7c1Q9U5hwcQIIREM
	 yxsYXU9VmSDNBPbeQY0BfiAIJZQg73pqS4A+ZI6tqf3D7U4KYugo0RN6GHy5PRtKxd
	 BXtqJ9UEZZblI6A+KTVbu9Hpr6nBwQ6TMV1s2IN9FI3mDQeHJoq2xTF24O7uxo3o/I
	 I7I4l6K9K+OgQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: JaeJoon Jung <rgbi3307@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rgbi3307@nate.com
Subject: Re: [PATCH] mm/damon/core: modified control->repeat loop at the kdamond_call()
Date: Tue, 30 Dec 2025 17:28:24 -0800
Message-ID: <20251231012826.75989-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251230005716.47160-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C163C000E
X-Stat-Signature: yhewcnrcpxwu3xpyq4qeq5r4fzktrin5
X-HE-Tag: 1767144515-700457
X-HE-Meta: U2FsdGVkX19x+Sbp+m1wQmXF9A4mbFqo/YkRcb02GJnDgZcDYPuWdlDOOKdCylxAehYsW6JxOE04iPeCJftqZHoCfdmqQevU+lvK49R/gh4h8AQXOxOuM0mDTL+Cz9JdCX98alIbtfPHwiIPHYacnNBz4MC0Z6JW91tpNE7VKdmlqqm5lEshE8Qu70B6aT9T9rO5yFs57GX+6kfY9arI9g/Nj+FQ1oXgiIbx5ud5/ODygVBtHds2h57/emUjgoVTY6H24rSNezXv+sAUAlpnOSSKPvutKCh6Vw1SsjlTWIpDfoRdHpfqPgQqbDGWXhwqAKKMSmGRJadC5y4yU0IG+hHMb0Zxfba3JJk3LTcIfZJyiempH5ZQUJvBrkBC50rzOSeYGS86aW8Xt8emV0dwAChVYmQM1ga4TwQgJnBmn1eLQ2c6dy8NLv7gJUCCZzCfvVGZkeeambnMSAeH4QG4VEeHADvDOF6asy/1nVrAJOEqw0eLSrSISQhcGDmJU1byIRZr+2+PCH5YQT9xEQyknrTRzbmKbjBh+GrgmAwHfmgFjYMeiIijmUThdo98A7euIsJiBeUHwNbblsciHxV9nE2BrheoQ1SzS7rm3a+merU2kMuUpUaWkJGykwsUPs40t2O3KCkqxmjgoZM8ZonMWJ9dGX40SdFwxIjY1BOp13+wRPmfy+L51x4RnUlgYkygWNDphszu6Rq/nX/zw436dZArb8FIFJyQlYt0bVm2N5BnczLwlfwqyqKg5Qk1AyJJqfjVwbj8oKXhc6SupnVl0Qe4ysG+d5LHaF/oPmS/wT4CDSbebDSFQFiG5yKAMgUnQ8ZGGflDkdDhsneKM5hl4j1k6Q9mmtHbzVtqqNX04snxVjZRbYE6BGKuBPVaUg9rMBTVowLe4S8Vb7E2/ZY7ouqQx/N8GEHskOA7Hr4bwIblocgCiQTwH71E7xl7HTJzGPxiUAimVLbCsY60dce
 PVXeUEDx
 rKAdggeblbvjyBGREneAszwUg8WZaF1EZ8exWvcwAs9bCGFZym84FSoUcd8E7JHkseXQAJfp0lOebzHRFQCC1Y4LFsbX4jZYvtxrfbPLIhmZep7RC6Ypzk+DpfMOaZWQoVvpjCdpWTxb02YAOIH4ZcqKZG/4lVDpsbQ39gae91J7bcK1gl8+36PZxMtMNsyav1TPwJoDjNEj19SJSsbQ0Ba64pXycYIGXdcN+baMUjDVep8PFfYWTI6JpAlKa/OLHZ3Z+gGqPkSwbsNkVZQ1HlOGJS/N4/8IoTgmO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Dec 2025 16:57:15 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Tue, 30 Dec 2025 09:14:37 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> 
> > I will reflect the above in patch v2.
> > Would you like me to resend patch v2 ?
> 
> I just found my fix [1] of the bug that you reported has a race condition.  And
> to fix that, I think kdamond_call() will anyway need to be modified.  I will
> shortly send more details as a reply to the fix [1].  Can you please hold this
> refactoring until all discussions about the bug fix is done?  Sorry for your
> inconvenience.
> 
> [1] https://lore.kernel.org/20251228183105.289441-1-sj@kernel.org

I ended up sending the new version of the fix [1] without changes on
kdamond_call().  Unless you have concerns on the fix, please feel free to
proceed to v2 of this patch.  Thank you for patiently waiting.

[1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org


Thanks,
SJ

[...]

