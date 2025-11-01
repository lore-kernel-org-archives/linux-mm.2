Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE6C3CCF9FE
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 01:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92CD08E0076; Fri, 31 Oct 2025 21:30:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD928E0068; Fri, 31 Oct 2025 21:30:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4918E0076; Fri, 31 Oct 2025 21:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1D88E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 21:30:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7B9688E25
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 01:30:29 +0000 (UTC)
X-FDA: 84060308178.16.23A4D99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5CDCC40013
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 01:30:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X0dH7Poh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761960628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ABUDdk1Usc9fX4YsALDLoAC6ksakhsF7viib7Uv/BEw=;
	b=r6famnQMIZGUx+tA0OHjFvSAcTyS7kuRthPkfaG8QY0iCNq1m0iMZEr/v47U0wstEfll9m
	MGKjYdF0PTuCfSC+/ynfDCswwCvjwBCAw4Ixc8eLY80/3jQht6iD7aZd3u9rkmu83+B0ux
	uIxeVsAziLw4JwYDFPDv9TlB1oAUqgA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761960628; a=rsa-sha256;
	cv=none;
	b=ZCwaRnIeByqe30qhIffXbp8oUmXNQHqPCJo11CJVEXeF+0AyGR5yTmaG5mkmugAAa3uv6X
	XDkKkw59M0GI2OkOIdvAOopMqq1z09WjqXDmgiWxVh1wIw7FDhCNb3jJjoLVaxuFbCVffR
	rVbd7wifbmS+ofhwiQYYimF8CNYRwpg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X0dH7Poh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 922C760141;
	Sat,  1 Nov 2025 01:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2199C4CEE7;
	Sat,  1 Nov 2025 01:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761960627;
	bh=KXYybCMOsoyA4teq+q4E5zSg7BKUEaObugsAPZvSEno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0dH7PohthNUAtWxRoNk0PmkxBDL9Z6ClZf8aFue7LAJzpIvq9jsZKWFrYsVrZIIa
	 XamLTAut8d09LoegkWaICab+CJELKuwY4pKkJgyQqXk+7F/UBkS53giaia9JdLbNJ4
	 vRoSRG09lO0c0vRBodZ1ueP0buUdXei/qcAxPYuVMpIKvTltPVtQv5l+PCbtbup0+J
	 zNd17NNF8Ovs3HFFI+x2GT7/CwAFuHHYHxdWs6FfHVLHXq2erCQfqiPm2w5ByGLdX2
	 jv6HhtMn5K1+wqWNizB23E/Dvx2cSc7CdKtqr/Ln3PC9YnzIaYpy8fYqZ6Q7qD407K
	 0L82NzguODylg==
From: SeongJae Park <sj@kernel.org>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alex Shi <alexs@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Documentation: treewide: Replace marc.info links with lore
Date: Fri, 31 Oct 2025 18:30:19 -0700
Message-ID: <20251101013019.68183-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251031043358.23709-1-bagasdotme@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: fcg441fha4zr9arordkaer1teyuxshds
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CDCC40013
X-HE-Tag: 1761960628-50436
X-HE-Meta: U2FsdGVkX18kcCamXaNDd+OHX3oiTRmJ8De6SsA8+Uwtk3AxbQ356d53MUNKs8nIwE502bySC02hDOTLTIUekWIK0C8pXPcGTDtFvxVb79nFtggfPHnV3T9AsJQZKBq49+uIH88JJyX9YF7B2LFeqCD0YLILOCxSiYxRwS5jivupaVyKyhQ9dACLJ8qPu1MLsQWOTSQ9eewoNf7dmUUKcVueld1rc3+gAalamDJeCfszBMV36QryN99YK0mXWRUNsM94rUJPlJq+CMODMQXmnxezG/b8rN96JaNBDEl7lKg62BtprdZD+aHiosX3kNuPBgVQlRdefgpq9BkAVNtSCvmewfaRlbEBXV/0QzvRHQvs1PmFeIjJavB1icEWFvti1mAsHQg/28Sab24FGtbUAu3DB4H02un/5cCFjqS9ksmqZQX8GKbEi05HslFBvY2kqMobySIvI19GU7Vf5Y7zoR4hKFBMK6NvTWIWePPg/zR87QAVzREdxCJPB6k5Pc2xnqalkezVTxp/5rcYbR1zUB4pRtSZqMgF9a0Ba8n6hjYeGq95JVrYp+gprHUGsmOhVVfVNpaw8/DYHdKhNaFcn/buJgVnl9JyPzqzOFQlocIb/X1fZjANQTyn2uoSbwOredUltPLFmUmIeQB4l8fCgau3N+GLz97Dt+JKQPNfOT4Hd2B2gyHFJDO2NC655lGDFh+hFCzMjnKArOOOPOnBWcOCH8MCz+mTjz74ulXHcBzf2KV9V1YJ7/M+huHhKOtylNfGfmf9P2caewK7Hl2xgqMMdTdpoAng9mn4Pdf4CH4friVjUVsYhQHczyybr6GVmgFDjbpUliWv4EjCfD+PwuqZ8jaunm5VDyDxqdJt2zM97l3sHTVx3irSvmNiMvjTYKOT8NMlVUkNP8ydiX0hmtpu+AYzx7z1KPffm5GIq6tdzOy8lcI5IbihkwxT1Y47GGxFNVT8Lg7yBRZKZKu
 zbB/QdeS
 t0UybUaZlOjlL3HZf0EbdkXSK6Z4zCgYk5lMKAVsFhBiCeHzKTmFkOfYbarachCmCHQFc2C4WmvSulLsMMu5fYdufbiWzFYcJ0i2ZbHMtcRPNSFpSGbpzahRrCCGB8vslu/HXietJ+H3HgnGm6ZbHdcTPlrywzFB4Ju7gibkFRroCObD1bqooUpDDYlc6xlJoPK+RhnRDEjt/jrIIHwFKUDeiLEs3VIQSiuPh+ubCYaP+b18hAREYHUzE/+GMso5rfF0WmdYFdVjRV3WrQ7aUg9PMH4t+8fM7QGvykE58cDysm/OTJjBPbPlTxDSaohgtR0dE5bzKq27QZr+3vX6JtEomjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Oct 2025 11:33:56 +0700 Bagas Sanjaya <bagasdotme@gmail.com> wrote:

> In the past, people would link to third-party mailing list archives
> (like marc.info) for any kernel-related discussions. Now that there
> is lore archive under kernel.org infrastructure, replace these marc
> links
> 
> Note that the only remaining marc link is "Re: Memory mapping on Cirrus
> EP9315" [1] since that thread is not available at lore [2].
> 
> [1]: https://marc.info/?l=linux-arm-kernel&m=110061245502000&w=2
> [2]: https://lore.kernel.org/linux-arm-kernel/?q=b%3A%22Re%3A+Memory+mapping+on+Cirrus+EP9315%22
> 
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

