Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B345CD98E4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 00:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48426B0088; Wed, 17 Jun 2026 20:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E207D6B008A; Wed, 17 Jun 2026 20:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37916B008C; Wed, 17 Jun 2026 20:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4EED6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:16:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F16A61666B1
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:16:22 +0000 (UTC)
X-FDA: 84891116604.12.3974DF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6C23D1C0008
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:16:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mS8O7Ldl;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781741781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0kWAyRfonITHEKTmFqHGzAP61+hrxv6P9ACVWEGEu0=;
	b=5TRhIQCsPX4ErA03HOBXScja40L+SAstbZwYLwm9ZlGljve4lkUJsm+5HBYFdQTpStQFZc
	o5weA7FUlIJHN1q49fwc7P+aPx4uZ3M7Hf4tiEB8f/Dh57a15mq9fq2cpvE8Mqi+3iBm5U
	k0pwz70pB8xNQTJj4Py9H5hTaXHsAKk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781741781;
	b=TB3n8Xxxd1GJ5wERXAW22rthCFcIGbzW0eeBi5XIB/1Z9eR65Er9Ifx4qMMmCdMcSzTOML
	6o38MFMkraOWoEarlNgt0SRJRdjikUQvFCDflo6DnLUjSui0PjJwhdLUYky60/R6N1chmG
	m09SSDHzvY0SmtPsgFYwA4686OgKHp4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mS8O7Ldl;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96BA060052;
	Thu, 18 Jun 2026 00:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF871F000E9;
	Thu, 18 Jun 2026 00:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781741780;
	bh=l0kWAyRfonITHEKTmFqHGzAP61+hrxv6P9ACVWEGEu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mS8O7LdlB4rRbIWjF+Ru/oL0KgXE2iC8EIhFSLq6zjbxqntdp5RXsI4g0gvvKYN/o
	 DsjWZq11bDZ707uQpDbPLBzivaiBAbZ6S3qpypIF/SOjMTUZKMGMIpeZZTEaHU9ua6
	 BxAvW3IbfurZzKGnoMpu5Ev+iDCPo5EctbJEmyGao4+p2gtvnkpaSXdu2puniKbS6Y
	 c3ws46trieNiNQoAeZlIUhsRRw9rkxOGdBZP/3l7JY3dSInIfnVS5u6K+syPeCadNP
	 7K5BcB+fO/Pox+0S+MdpS/kT03P+vnS7a+tbkRR+T4TWoTR7LETSASUrhNh9RuKBeA
	 FUHR09USFgVtA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: gutierrez.asier@huawei-partners.com,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/3] mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
Date: Wed, 17 Jun 2026 17:16:08 -0700
Message-ID: <20260618001609.83965-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617040452.98621-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6C23D1C0008
X-Stat-Signature: 8ay9nqrnurd7sif1ogyxtn7c76hmn34t
X-HE-Tag: 1781741781-502563
X-HE-Meta: U2FsdGVkX18tuu2SxeQjv3O+McSSwRhn1eiH5NnCRyKOk5ugh9+MjqtF5JMzOTsgpo7OJsmiK56T/szcIV8xbv7O+xZRwZcDOEvJpZ+SCltMPdu6p7Uwo2inoLQLgn8R9zw8qunGmtIK/TppiHdWd0VjfsdijH95oEt13CrpfwkKpT9XF5ZHSI1sa/P4B5eWp8urpP+vbunEyCtSU56GBDae98cIFj0r0hx7g4misyzyag46pDUDX3LifBZopH95Vh3RkO18y5WFC3/Nx7L0l65EHwtWPS8N5ac5s+mvS9P97WYBkVJ4+DZnxr9g2DbXdSv+iwauofswZ9slbVQQCxbr5dIz/NrObbd2NdMNK8nI8aVdWUb1+Wsvz16FNWu5u6HGCSqlk8UGloFqrrW3GpqcW+j/i9EPgoW4E0GVA2siypXFu/hO7idF9hd9fWx9PtjreXYwB8hiMZfsCgv0PKByg1V+P9JYmoE9EMSg173HlypS7D/hGqqFXNhbadZ5q2il3cKTR5ewjMkEIYTvXgqxM5a0v8oFMLQXn/TtgdRE07tFTNuQTshskYnSVxw6WcWJ9hdYJFiBHm/IYxFCblBd/OJXNic9mYNcfJEqsollUQcKXj1pw82/j5FVtB63d2wOCh+CEWOnzPYeDK95C681G7NFAsamJ8+b65P3x2xzUioi+zrxuKWOBAK+JxsG8lPf2sPDYziJ32Y9tcgz9OyrUowdq2AS4HBsbIV5ajUID2xb2vwHNB6/cUepqPHl0lOHJPJmBQXpt37smCmjFxnKhHGPx8bcoZ6dg8D3/CmCmO0eNRtduCBj388DdLZjdVe/c961dQrhD+ZnzkP5VWAa0APCUXpZgjBROBJr5Ykj6REaZolWSff3JQcnihHF035aV705uEeQUvzIHLG2zDtHtUtVg2ntUEqZcvImpWwwFtNxyX4KGxsDI5mpw00/w5N3TfVuCAei+9yYDTO
 7YtiCYgI
 S3ML3Ch7WMXbzkj44ZUdlNkH5irwDlxDn1lLoL8uL+XvqBVFUEeYwgX0STddk0jXdZ618wsSBZoc2KwQqAnrCCEBP8Ru/MP16ebWJ6PyDvuQihBoxf3+ZsL8mzfYXXYJWQbeBHj1/H2AF6aVg2PjDr5aS6bzn7arREsZr/gDLGNzgpTbnkcnmzas+yrHLbXlZ50hDjLtsMyEDn7EiVau+WRBeoVX2KnwAPuvvJm7QNRvK0+aPWLAAFpanT80uEQBgmuzlfT4jBDgZLxG9Kz6B1O6IxMny0XMG++uNv0Y12Faqpd4EEMalkWGUDUIw4jD0w9+CYMs3oaBDnQ/B34canZvhiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Jun 2026 21:04:52 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Tue, 16 Jun 2026 15:03:15 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
> > From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> > 
> > This patch introduces a new DAMON module (SAMPLE_DAMON_HPAGE)
> > which collapses hot regions into huge pages.

As I mentioned on the previous version of this series, this sample module looks
much better than the initial shape to my humble eyes.  Much smaller and
simpler.  I really appreciate Asier's efforts on making this.

However... I was asking myself if this module is really needed last night, and
still got not real good and confident answer.

After all, this is a sample module.  The purpose is to show sample code thhat
helps people understanding how they can use DAMON API.  Maybe we can argue this
module can be helpful at understanding how DAMOS quota goal can be used.  But,
mtier is already showing that.  So I cannot say what new advantage this module
is really bringing.

Meanwhile, this patch adds ~200 lines of code.  It is a very small and simple
sample module, but still we should maintain it.  I, to be honest, getting
little bit concerned about the maintenance overhead now.

So, if Asier has a good reason to add this module that I'm missing, I'd like to
humbly ask to consider dropping of this module for now.  I'm so sorry for
raising this concern this late.  But, Asier, may I ask what do you think?


Thanks,
SJ

[...]

