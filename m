Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B64CDCD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A78A6B0005; Sat, 20 Jun 2026 13:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558DF6B008A; Sat, 20 Jun 2026 13:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470376B008C; Sat, 20 Jun 2026 13:09:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3596B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:09:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 852DCA0254
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:09:46 +0000 (UTC)
X-FDA: 84900927972.29.A5C979C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id DE37140010
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:09:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WTVpcr6J;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781975385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJQEX0ob4V6ASpCMyc/x/VPDvEIn5+uylrmiAJ0yFzM=;
	b=WRhVt4IO2aBo/VGslgePvdSetoPQ+xMZ6eYhWBxbgWM8QdH6fP8xmwQGMEoPD/zW0sPFvr
	2RFMl66fs0z8JmVkEEvN1zz9LOuB9hCy8EHHlpU2/RpwnrTxTzG6k0Deerpoua+PiIme1Z
	RTMUNtNRcMAg268uGs9p0Ke8r5jnth8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WTVpcr6J;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781975385;
	b=I//whyC0FFunzXhWhfPBq3gmU9h8wV7J3B97fg/T8tCYuoIfFUkY7bGqCjCcap/uEvwmUH
	JKtKe5fZwojH81nuZ+ksYk7tzDp80a/BunQuP9p8y8Nb1C27K+3UMcsfMP9g/L8q9AobxW
	16VkV3uWcYKdvuD//WViMnWxo77/CPI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDFB7408AE;
	Sat, 20 Jun 2026 17:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0551F000E9;
	Sat, 20 Jun 2026 17:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781975383;
	bh=eJQEX0ob4V6ASpCMyc/x/VPDvEIn5+uylrmiAJ0yFzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTVpcr6JDHLYZuXCYK58NKBB/UYphUSslSKPRpNb+dtuSksTp4gR2YKUXBSP9yUKI
	 juyvP6/i7S81dXuDA7ybJAH6/CVStcL69dw+7NE7VX2DKgTOPSvtZfD1idvq6kpUpO
	 kzrRf/d3Vm9jaj4WuET6G56HZjgNkMGX3cKepPBrc+2GLcjOfQefVeJvBsumltD8i/
	 IW5gPNoBXBybrGjEO/27dApXuxrRwfRjAaexKCvIvK+EoDSSNowOTKsFGvuCEHwwkt
	 QTNnZLXkWJt3SKWSvbNyi9MtsIu1aU2G8jw8rXgcHkQntM18x3s6T+QicAtvl8GTq7
	 C/OVx5HVJb3ag==
From: SeongJae Park <sj@kernel.org>
To: yahia <yahia.a.abdrabou@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/damon/reclaim: fix potential memory leak
Date: Sat, 20 Jun 2026 10:09:34 -0700
Message-ID: <20260620170935.89236-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620165055.7247-1-yahia.a.abdrabou@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DE37140010
X-Stat-Signature: jq5e8mzmikd6jceecu3d9nwwdq9we9ot
X-Rspam-User: 
X-HE-Tag: 1781975384-319404
X-HE-Meta: U2FsdGVkX18t3/T7wjd6aBFJZR9sUozYMXsll/sA5pGii4ZkXy20n1WsATX2SegfRH0B2fkJ7nmtTMuind+HUfV8ap2uhnC6FxWy2bxYPRZuRkMi7Weh7UZze8uwGIOJO8IqmcfXP8jOHrx0fF6dCn9wcoHzWWz61M5m3Uf9L6LaigQhuyyvVhNff15ri02p/tCnyGWt7O7yh009VWcWjtbTzhIDoZ3K0QBIkPUDZaMQTx6xAxyczaqAcueRDU95vIST2B85HjQ5rJylRC2ZKDJvJqveLU7HnPC53oVK623t24RmJm1O5BeNOs8b1AMAYzAefMUogcpPCHWYvlH+Ee5funnIuZuDeFu7DYmUt8O4Iv1i4qDXGfvtvuGYk1P31C1G6/etFNy7UAsf6s3b9zr9NUe46tJYjlXLWZiRM4Q/AFlFLGnnkQsaNCo8sJ5m1+NLsQZauhHQ2eUancyWO+Y5zqF8PM++Blgeq/oYvL52l1oB0/5iyG+RGhF9yZloKLEqWA7LG1MgdWARdrfjAETMmPNSeyimF2lzt6EalF46Hx8U9HSknrRF06rErd9MGqs8H59jkt6394kcBen+POEqx7p9hP9Ojbj7Mx2kWiA6kv8HK2AMprfUFtKEjgd6JM+XuJrcxFRwXI3gu8qAmWaZUXAuYmmB9Vj1wCMZOM6a//8/cmO0mgRAwLBjDjXt6IfBwHglgoJxJHs1maCfuWUrnheb/vRNX90OyhwZ0uRh9/jXPHDgBc64gBdCOBEfU7d+ggADtK5DFcHwc394y5nVXKwxaC/H8OSAz/zCo0QrjKULT3kYmA028fqPO3kwxechQJyyjL/WaO1ZP4Ca2he3Knt7UUZszZ1a8GeCNJR9gaAGAfnowRhhlMT63c073NIY8+GR/rgi8pSSU6qPj1P3g3IWAc675GNgMDhg6C0t9wY8Jp2lKXiJm4CAprOemu8MNfvd93XmhnB8QWd
 GLyzc56E
 +p/Vn9CJL9UfF5+ad2GvxdJmaVTa6rOusHTWnmQn6wSNw0BS9Aae31TwQrlU9B7E2218AwvqJVpMQCw/cd52yl2TGh1jayz5qPb2O34uBxZgXcOprpci1w9MuL0zyc6lRAno2UsbuoSFqrTt6Qr/VxilOJaGgDZXxfubFhOW2D07MJdDCxLVNFo6511lucXULS2YM7NQhE7IuVML6OTi8H/0bAsnbDl5I7b4OKm187kTQU42sOgAJqdCVlJthfo+MvxwmLYponnTL87QEmE/Z5nz+ZJJodvs7ynqaHh9Hw7JbZWDGtqe5kj9nJdC7diw+t0WnnDlmhv01qjUOioUxpX0UfA6r7g8L9A6P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 20 Jun 2026 19:50:55 +0300 yahia <yahia.a.abdrabou@gmail.com> wrote:

> Hi SJ,
> 
> Regarding you question in v1, This patch
> addresses a potential memory leak in the
> out path, ctx is never destroyed during exit
> thus creating a potential memory leak.

It is kept in the memory by the design.  It will be destroyed when the user
enables DAMON_RECLAIM later.  So, unfortunately I don't think this patch is
needed.  Please correct me if I'm wrong.

Also, I'd recommend you to thoroughly read and follow the patch submission
guide [1], if you didn't have a chance to read it yet.

[1] https://docs.kernel.org/process/submitting-patches.html


Thanks,
SJ

[...]

