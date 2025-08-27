Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C95ECCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 17:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088926B000D; Wed, 27 Aug 2025 13:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 039206B000E; Wed, 27 Aug 2025 13:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB82D6B0011; Wed, 27 Aug 2025 13:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DB3BB6B000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:18:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83ECF13A09E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:18:17 +0000 (UTC)
X-FDA: 83823195834.10.A008D3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EFA721C0012
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:18:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ckewAgd3;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756315096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLzap5Flns6PCdR/qS0K2Ve6tncif1Srv/whongNi4Q=;
	b=FKIKv8bUP1gzlPzePiLeXbp/RmPbJWs6tyJj7rSgBuDqmFZUuU5CA23BYoXLA0zCv+9Xm+
	U6/5JmSMdvm/x/cK8sgtbogaeZX3kQroQg85bJ4NpsYLeZomGh9cpDmpOBKj3b6wYmKV/9
	rpghj58mjxGzm0hhXk3VX/d+YIwVdSw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756315096; a=rsa-sha256;
	cv=none;
	b=aX6bIRJTJEchAZacn61FgBglAZVA/5r3LBaHbunV7jBET1PvVc+eiWXDkwZrfm3c77y1HM
	2DBGDGXxhpIWnXT387rUb7ORXBSc9j9tu6994zqS5qY5HxaDrhM55drqC+DcxDZUrItL+7
	45ypAcywy80vucre59Hz8+VmOAu2JWQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ckewAgd3;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 45BFC600AC;
	Wed, 27 Aug 2025 17:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC655C4CEEB;
	Wed, 27 Aug 2025 17:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756315095;
	bh=Ui4V3hxIx9PmVgXH7P/YiJsiwGKYbyHah/yk5X6Nt20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckewAgd3dZpk7AKQbNZ9/qILFvCij1WeTGfXLZsmki7raWOD3pD71bc0TNpim0Jcv
	 ubtNOFHtwKdJuTaDu7EhtpngONx1gS4qB9O6vRBTiArDfz/eqD3TAGUV3WSyRuUa9j
	 v0N7EfigGNCblvk0VdWdl/UWttwq2+hED4yb78VEsGJbXKtbklrIrzHGGSWlX/9i2m
	 Ozox756sHncD/gJysmlU98NC3z1IuAZVGn1MkWU/wdrWIhNHhd/uMLMiQagJ6yEhOv
	 9/iXBa5t55Lyp2FM7UvsR/orF9CwOjbMy9A3TPHb6vk7BzwjjDzo67C54pz8IFf0Ne
	 WO5T6UbV8K71Q==
From: SeongJae Park <sj@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: Re: [PATCH v2 1/7] mm/page_alloc: Add kernel-docs for free_pages()
Date: Wed, 27 Aug 2025 10:18:13 -0700
Message-Id: <20250827171813.104592-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250826205617.1032945-2-vishal.moola@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EFA721C0012
X-Stat-Signature: nacaxj6ms8pxm1d6qfyjhtbmm3ykq6n7
X-HE-Tag: 1756315095-108081
X-HE-Meta: U2FsdGVkX19rhOa7bNhtggheUAHJtAtkRPYmMS9319KZ1NAmNPURQnIH23m8yI2pALiSjdnOtq2t0I3p8xkDwgcjPNnzaex8YVUHY5LOOusiRac6Kc1N9oqHiqo27KtHFCLmkQ3i/VhGhWRgVsYJFXVb39PmAoMK58X18IKsv550CvWsrIyDXjC5jujFQpOJ8XhplomEOCkZqflyEPqdQV70U/VHIINTci2O+wL3faCYijtkBs12I9REdIVgcEAKiyYSvhJfcE+0yX+v4ZC2YwqHGwwNwZ18laXlSkfMz+tAGS5aU2P0JP5usBdDBPmOGPqfGHCmxoekK0embEskenbRChOXeLWLEa5pfFyAeMZr/mpAyrJBUz/zMr+x5glvuQPlSuK91DjcelzANnNJb068VolmRPfg1XfNQTdFuvi0rp6p7lpJsmKp+GsJ2a1Xx19bpvaWnPXHHwGFwqWKxp2WbvIkMJZUZulD0rQcGf0hu5uUWFfx/KCJkKLynYvLsSPbjynDtyoEOl1R9MXbLNtv+T0G4MLI/lZjZ3orIY7HMkzjZlpl7fIttS/7ipY8Nnu/saN43Em4wl1iU7BL7U+lHqXc63NS/omcRsg/n/DW387ZtNdSzesh0KSWfYxAIJAbj1/eibexUqH9yRjY4M8lxf6EveaPhxYl9Rjp3+6HmF14T+1OT97Qe3+dQMLbOs4vyo/zl9esjD2lAT1D4+jRdx+hf/eaLsoJvYjttvdgBS5Krj8kKdCfBEKABlU5IxyJRNecPvHOmjUvINUGZaPxkghrL78rxiVTLlw09vn/zLlxD8tqOlst4nQJld8ziOSgiQgtGLygxzvUTodKV/tp4AooS7YT7lR2cwHsK6n7HOPUjYmlgLSBPSnQAaj9DK30Pz/Y7H2Kugciu7+F14U99wwFAQMJSZkiwkKfMj54bltKAgCBv4NTCZvxHXq9yUAjWip5YvWVnAR8pmp
 i6e9NjbE
 RXRp2LnCmYgWOW7jVNKGk8wUtmqcwCp5xZOsalK1Bwj+ZIgg4vUzRNlEqDtnMsV0+nM6sJk6SJuBv9YlXMtN/lJY920XDaxk7lrpehNkN2UtNJs8TwfECg6+VlRe1F7vCFIHE/2NzSZ68nmX7rnbfJ0T3tUjUCNFO+rhp8XN8xTH8wkGV85KE2JVXE3PzEOGS1OrPcdIfeib63OLhQ/wQGtd2BM4JsqRbnaAz34AOz2A4KyAet28mUUBGSZcWO5YfvVuyToEhjcQuK3CFFG1xtCXlLJF1s4tlVvBvTtTyX/BIpaJys72SY6LV8Xl7ZGdWNq0151oohFOgDmFVI6reQv0i8q6Mr2ftfNFmLaBw7+bBxBWozMLSqeZs061WiPF4+5Rnj7++AOht9CrHihBkBcBtrERv3QpsRm7kO4p9zl/cveJQzfiTZ2Uhlpz/kBeDAosG98O19nOU3OI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 Aug 2025 13:56:11 -0700 "Vishal Moola (Oracle)" <vishal.moola@gmail.com> wrote:

> Add kernel-docs to free_pages(). This will help callers understand when
> to use it instead of __free_pages().
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

