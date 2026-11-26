Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D123F606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 07:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DDQMhHow
Received: by kanga.kvack.org (Postfix)
	id E25156B05B2; Thu, 26 Nov 2026 02:55:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD51F6B05B3; Thu, 26 Nov 2026 02:55:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11D36B05B4; Thu, 26 Nov 2026 02:55:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B15696B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:55:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2ECF116030F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:55:24 +0000 (UTC)
X-FDA: 85476510168.08.E67AB2A
Received: from mta1.migadu.com (out-108.mta1.migadu.com [95.215.58.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0A1B640005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:55:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DDQMhHow;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of enze.li@linux.dev designates 95.215.58.108 as permitted sender) smtp.mailfrom=enze.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795679722;
	b=lVQgt6/n/4alvYnN2Dcl0S9d3ZSHi8b4aFof2rLQT4DeHSdBbf3KRJyHBFEOt2jg2nQ+l+
	AoV5tgMWVHlvSSf4639X5z6/t2Nlob/VA1MZTzbGcVC9CE8hs4S5NVfTkna+jpqN79b4FM
	mdA6v6qcuBXsRHVygG9l6FG8/lOnIic=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795679722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/KxexsUFrdq+SvWf58I1oOaEfLJEYq/Mus0bFEPpJdI=;
	b=JNsSo0nijgMb/8/jDsRfggOSbEiAsi+ywWxX877CinYBbbubDg6PHYxA/VRde7K/wUD4/f
	yA2ghLeQ/u4IqxUCmKyfG6EbY4B4yllFobCP82zLDyDrgz7HdQ1cT964BnrQrcP9b20+4J
	SJlC9zgap0mzNKp8M9Z39fTpLuUHXcs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DDQMhHow;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of enze.li@linux.dev designates 95.215.58.108 as permitted sender) smtp.mailfrom=enze.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3j1o9AnXc+X/hXLOjeUWi2Tk02Miri7HG4XgM6cikwo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795679720; v=1; x=1796284520;
 b=DDQMhHowg5xKVHw1/2nYS2Uz95jFcOZ0QPxP2S7aplx+aipAlC7VKlgpizAlM1kFIoH8WsWl
 TUmyXkb7ZcGbeEm/FeNuJ93/PBz36GG9OgmwZfkvtdJTe4Sp0qbza+g1x9K1is6Ch7Mq9r5ccEh
 Z/V9qdKh6kBb7qJavyqwvldo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6706dab2cba26826;
	Thu, 26 Nov 2026 07:55:18 +0000
X-Mizu-Trace-ID: 6706dab2cba26826
X-Migadu-Flow: FLOW_OUT
Message-ID: <655c1708-94ff-43bd-8998-6448139cfc16@linux.dev>
Date: Thu, 26 Nov 2026 15:55:15 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/27] mm/damon/sysfs: add reports/producers/ directory
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org,
 Aveline Noir <jm5905938@gmail.com>, Lian Wang <lianux.mm@gmail.com>
References: <20261124153636.91854-1-sj@kernel.org>
 <20261124153636.91854-6-sj@kernel.org>
Content-Language: en-US
From: Enze Li <enze.li@linux.dev>
In-Reply-To: <20261124153636.91854-6-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jgd8e8moa3qqqmgio1kgjrm3odt48bkd
X-Rspamd-Queue-Id: 0A1B640005
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795679721-132378
X-HE-Meta: U2FsdGVkX19LKArLR/ECM2t4QHx0kHXpCV6oZDw4ujaA3VKgFhssXZ+kZpLd4SIF4RCIh+Iu9vojTE2fZPUEnd+XPxwbq9IlT8/Vq+Y5e/0yLKK43iLbuQHVCjgepozPPo02vSa41aFnJYFHwvYCev2p3feq7e3NoY8fDkAzEQomfWCaJ7o2g2CRSFr0K3KmWSlCa9M2wiPAk8lgPqdWce+yX72+VEG3g2hC6xGPRSHR0dXKbz1JI6y8dIhRjoiMunYd7VwKHhcVe5tWsZJY/rYVJnjokHaDzFak724Kbstb/r0PyrRsPN/ZwTnI+krCsaec0ypBOjnAMHjqhybwPBe11e78/do8NngjPs0GB+xV0us4VbMK4PzFveOTBhx0x0LNM8cc32YFwr53l5xGQyMNz5qWIBjukQU0tn4qT45c4xgvIwdwZ0F7GXsSxe8/R6sd3XF/qwqsn3q4zDD6hyw5xunjHaovxbfPKJd3fW8BASUYaFAeC49CevxyrRVL6msA9M+spSUZRkA73wCqBI/Je4e2RsNeJoNtAkR4M9yp88Lljkh+L+kyCPykd4v3vCTod0MRaKKjxHRhPOFJtu8aauHIuW6GKyfESalkUflaMk/GiEyi/U6K1eMZktMrgF9DyqZikAz48tDR/vbQtDlRYp/dDxgvc5llqjrTt+p4xkQgvUqsDO1CKwoGxfgwXG57JKBwlcoTJEoFSTit3Y5wKHsfcTXXrZHkbSjE+4epnRr6PGSNAlIFGn3YCCcGs4SOQGb/GK8fSWCrJ/VCUlJ6am5/MgDvG4sO/5QGYwrvwtbH8m7tNiDJ36nGmlhKyW93ZGgu7myyQsktj15Rz4HXhf3dHEwbrXeW+j8mHC+oBHU8UD0LfGY7pqMRkwDUC5/do1gOE/lY+6dX4z+DyqcvbiZiGbUVfyLE+Yvq8Mkr/+JbgnXx5QqOTGxWk/tlYDKKy7DnrPX9doEFbUr
 hsO54ZlD
 ZtXSHlVWC5l4vuqv9F3TXUCo2qwffjpNc2VkgJm5QPrRzhjXcgOdvEO05OqXr/KXI9tEn1s/Le1L9r5M1GGDww5lPwD6+sEiKNLv9zJahWUcDGtjX1oBjn4EgpwOHTYwlhPfJzuoVjAp5mRuYJgs98t8gYCmTe1AQd3yf9cs3YcWklg2wY4EZWB0UfwAz9W0PV0bn+v/xzpHM9nJlWMLbXSFz2XoAhlFsEzuanm72nffqizPrJypYfQFo3M5rCMgSa1b7v8zmV4Fqinhr807NfWFUc3GXbrewBDsXR2QFnRELfb0jT9QRLBiJbc1Jrjfdkg+OfGku0DTUUdPPv6vZUA6Xo/xNq5wiaSGFNHYyHgfrxHzIdl2u7bTG3j0bzOpaGPyt+NR4qh8nPT/CwF2FaKrMOghHrxa2YV2zKljroAVLIcTE0SWwsl080yHHukhD2Xn2HN0bK3+2QD6m7/SPHhyEAzaelnEun2XaApHqV6seJDtGgTqlaylg/ndP9oadpUuE6od6kDwHji8QVVySY4L+EV+WWAdzqO9r9UZXCrTluNcoYMqvj4+UK8L618682erhG3Ev8LPwIDcvZRprmYQRcx3Sdxadi0AC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 23:36, SJ Park wrote:
> Add a new sysfs directory, producers/, under reports/ directory.  It is
> a placeholder for files that will be used for controlling DAMON report
> producers.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

