Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A7DED43356
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 21:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3056B0005; Thu, 11 Dec 2025 16:55:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084B16B0006; Thu, 11 Dec 2025 16:55:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDCCF6B0007; Thu, 11 Dec 2025 16:55:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB4EC6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 16:55:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39D2213AABB
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:55:11 +0000 (UTC)
X-FDA: 84208546422.01.442F457
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6935B14001A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:55:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LmUFqP4n;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765490109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDzc8DagNndG7I9G2yVF595Tt2Sh4n5IduhnOghDS3w=;
	b=sBO75jHCGWqu7culdTBwNxTCPgIvsdNoqajefDpRl/Kl2F7mBXj2YQbT5xDwclMttE0SSg
	CWUi+V1IXs6uXGVsgMyYiQOjQngZC3Gxuwg3V186uOaRAoP113DW9HgenEoqets1aisMpS
	SXXk8PKNSwYRagx/uivuUn/sqF+yV5c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LmUFqP4n;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765490109; a=rsa-sha256;
	cv=none;
	b=iG2cNeH9CDp1lEuLbLNwDRGyjIUgIJzaoXFfq4pAnu5lyfJNBu5gr41tWIfdrLllSVFjMO
	0mT8xscCv39QOzIvTMElSwQtV5elbNUJf5Z1i1JpWbnHvXF+opRKaNsDOKa9h4gVmCUWNS
	pm1pCpn0p3+tfDcKSHR9DUrINU3hjOs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 68E0E43CB8;
	Thu, 11 Dec 2025 21:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA811C4CEF7;
	Thu, 11 Dec 2025 21:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765490108;
	bh=hGfcfFjrnmx2bgWKo3Tcnh0DMTF0/RC5fJr1aYYKs0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmUFqP4n6Qbidf48dqGDk/YAJaEqcNcjieo7rsjiVsSLlboHqj92WtRcnjGPoRs/D
	 SHF2FMnigSeBKqy9pam0tDhyfK80U/j9uBZELEBkP3ITWcv8RqQ0ZPiAdePUynPmUx
	 L8wAEB8EHp58FT1Mnq6ZimeFHtYWzzmoovkpwuktFsrVXUbgn5Tsl7kC/NEgaRuqls
	 +HXH/UqC3YsXiXyY1srZo2OVHkOpaeqzTY00djDAEMN0vY3HT60CoFuKYj2Z2+3A57
	 LxJQRiljYddy8a66GSSwDx+oV4JtuI4r77Jt/lYCzPrLGa2ETNbwiDuLOwVLMMIPSu
	 2eIuMgL6TNffg==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm/damon: add loadable module support for sample modules
Date: Thu, 11 Dec 2025 13:55:03 -0800
Message-ID: <20251211215504.79014-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251211125614.1242713-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 73pjkrka33ijrsq77upedsgpebzat3ky
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6935B14001A
X-HE-Tag: 1765490109-961442
X-HE-Meta: U2FsdGVkX197Aac9CI931B60AV8KPGk8c662Z8x7Bgjd+PyxruaceVrk5FDKaIvgqHKf7GnzGcmx65vsOdLPGTt3uJRqwrsi9n50CUFsdgyAroK+lzVM9UlYZaG/yZ/uLNnhEATaBxzdUzjIYCAhV0854+xUjCDQ/c8R8eJU3zFinUetNZ67xIFBky2XkZnAqoAwzX9nJ2H1VRL3PqMRTmcIhIG8D1yshEQV23pP47mQncMPLstupPBXm3djvR8XSxSN7CFulLWT1U9NnoIHCEO9OfhVkjoqFl48r2B9NTpYYvJL12HZ62l5gCF7IB3PIsWQxNMEdyYJvqEv7YHbZb5Hg9/bB3ww/rXg8Onn+QMCqaVstXBnl2aiZqqBJK7GUo7zTAivl7E7tsKorrqxVD0dVYhJbRzbh7na4O6m3DHgtPeyxYYCqntsIsI7RCdyP0AOFR7saSl4YDGNryDj1vuggC5yTcNVrGZAKV+kpE5DfSynydJOrK9zNTTD7oWXHTNwF3u3D2q/3N4EfKsL7uJoE6GnMKGoCTtuOBDTadF4lvpvaWRpee1eeoStgHz7hKD8tu1cxEYUrqWPJEWmktGjhi8LOKCnk2+pK5QEwsIN2uC+jS6cyqOuxkfsNrxGIW4uC1lbBJsa4ojOydqpM5ZbgpS4Of0ABNyBEZAmlaerx9Eqz0QTJu9qPROEcfvH7ZRbF1MCvrExi4wv/8j3wJWMORnUMRqaCPIrz+khsHfCbOkFRF8/U1urC64YRL+gRFHIji8K0fybZwmXI9bzyOWkSqYHtKtIk3nqv2JE0viWe0f6lMs23YFCVGaOZYsqSu1COVJki9yKm5jb070IgdE5qtsbRy/s22r6+T3FB20M2pM4inMNQzDC6OoZFSXO0MOhmkgr8QrqaU9WSrXplOs3RTixDJzC+WcDzS+9ETaSfW2TcMicF60u+p/syuuWrd0OL28Yqxf/grkBrrW
 KlEwed33
 xJNfq6FvPD/3Qx5nIB3XQDPcBRZnVdr89fwrBGaCilIDrYkUOOFY+PhISBUnOF+p7reetbcIZqeswndSh5Ypl5PtVLsTtZj3RsV0SSzHipbGqrIM1sN+4KRgerPzdFojlr6bMtzvtVynYIi0fHv9fRy1PY6BVrpdKFnFY1Cn1P9epqxG51sX149mk3WYNnFn0LohLy0EokQdEWQJBPOkvouqoTyfYUfpdKnMtv7YMqaDByeU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Christoph

On Thu, 11 Dec 2025 20:56:14 +0800 Enze Li <lienze@kylinos.cn> wrote:

> This patch adds loadable kernel module compilation support for the three
> DAMON sample modules.  While preserving the existing built-in compilation
> option, the change introduces necessary code exports and configuration
> updates, enabling these modules to also be built as independent loadable
> modules.
> 
> Key modifications include exporting required function symbols from
> damon/core.c and changing relevant Kconfig options from bool to
> tristate.  This allows users to select between "built-in", "module", and
> "disabled" configurations.
> 
> This enhancement provides greater flexibility for both development and
> deployment.  Users can now compile the sample modules as loadable
> modules and manage them dynamically at runtime without reconfiguration
> or system reboots.

Thank you for this patch, Enze.  Actually we tried to make the modules
loadable, but there was an objection [1] with kind clarification from
Christoph.  In short, we don't want to make DAMON supports loadable modules
unless there is a real use case in tree.  Samples are supposed to be samples,
not real usages.  Do you have a real use case of the sample modules that
require loadability?

[1] https://lore.kernel.org/damon/20231205172307.2310-1-sj@kernel.org/


Thanks,
SJ

[...]

