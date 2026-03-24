Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE18F532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D599C6B0088; Mon, 23 Mar 2026 20:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE29B6B0089; Mon, 23 Mar 2026 20:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BABA76B008C; Mon, 23 Mar 2026 20:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A36D46B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:41:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45E6513C3FB
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:41:29 +0000 (UTC)
X-FDA: 84579103098.01.573DA34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B0B6820007
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:41:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BiSq9kQS;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774312887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g4Ar4OPVf+iBuD8ucV79xfxiyhNimbEo8I+V7jnw0hU=;
	b=FPHYHSunTOouiFTTDBzc65GSagcaHNXmWfooYMN5Pm7fJBIt+Wh1xnBB45IKDh5fOz+rHh
	vCKC48D4jbJDkP0wLyg2AtUuHfce2FcnwzcbC/qKXl61Uqj3xzLAh6c6Sj4WvpODBjs1LV
	Ivv8KmUlC4jeAfPBQ/zhwhHujJH5ZTI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BiSq9kQS;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774312887; a=rsa-sha256;
	cv=none;
	b=jv9YkJhXn253EnNOOFZv5+OVj5i9/I+jDpPw7iMoq0AdD3DNuhprKt/vNHPfGMLgMZ9dGQ
	CYYl1P+LOUxIQfVovfvQNc0ScaX/lCRkxWLUdSdEd8WSz68GcyG0sEimL1CoPY8ASgD5Qh
	CleKM4tDREkv+U0D6FAM/RIEsGgD+UM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1708160120;
	Tue, 24 Mar 2026 00:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72610C4CEF7;
	Tue, 24 Mar 2026 00:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774312886;
	bh=4hnECM3pbJTu033bzgEOZQoGWKiwaOeCir1o+EZ6ulg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiSq9kQSVtMd0yzuauXv6D1q4ha5XDneI11eKY+k8lZjSuXM/ZJAYas0Q4LJ/In/T
	 omS5g1UA5HlPlxTmi4Z4VrgujsPD7nPvkuVIOflZd+drcvmfQRluE4OX+yYCJWx5Yi
	 QSQElOnKKenTXKk4QuQv3d58REpZQbMlTxJjdTCTtLQ1WiHaf5x2sgSt4wMY2mPdMS
	 NWTUKwcaOJb/nxPrwrcoALfMWGuZfIW+0JRutcOvS8ojx8nG7xCxIINIxlc3a7Lx6g
	 X/JmO8O1N7begxMajzfrHDDphDkX5RG4QUUdPufSJxekuUT/CQJpqLZWZyFQcP23Qq
	 s/F+nOHSw5G5Q==
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
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: (sashiko review) [RFC PATCH v2 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Mon, 23 Mar 2026 17:41:18 -0700
Message-ID: <20260324004119.87026-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324002936.86653-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B0B6820007
X-Stat-Signature: 3wroraiicjj7ufqnyw8he5q1kgar1r17
X-Rspam-User: 
X-HE-Tag: 1774312887-226006
X-HE-Meta: U2FsdGVkX194/Ycp8bT4+3Syy0WaP2M85Ee91fPukCliDUwjHd7R509XTEhFnpkmew9XZmEOo7JjROYufAm3ZQZJtttbEw/ILfAkxs2b5305/+/qc+9TJSuyo78TX/Z0g7ZhUxLM74cIvO2XRI3fiIQKg5SuBroUzi5Z8dhBlV8+/imLJPWSav1RftivUaVmJsVNlR2zn2QBu5667jU7K5bNtVA55nuM6/ZjBLSE9qm7sPiT09z7Y5J5o9/cKypDArH0Q+7zFc7VEn6xg5OauP4vRzRM3ZHF2OOkrZSQhj13il94xctwQUV67XxmYw5HzOHtNsw9db+xPSPOwjXsSBFzo7rvtMXjo2WJrdEjKLmVZka01ubmpP7Y/7PeY8hfSNDveOe+WMLi2AnJ1iYoYH2Yu4nZnd6/9DWUsKXrbuqpKNFyw3+zcvSZITlb+8Ldy2wuiJnsV9cK1VNh1Eu4wrT4pQUnUgTXdsy4yjY2AC1ERQIRJKFwAeoVhiWiHHpNSityszD35GdOdW4eFFe6FFdahzRmLDycHCKD0nUyLk2B9odWmyLlcpxGp7/Y6nEKjd1aLhqwdC3LWHeAakQp+5eHoehvdO9l5uacpWVI8ezQwRUTzMtk5aCAgiI3phK1owyBxMn/vZHNPbWV9zdGJbvOYCkx6VJaub9linv0aKHElTa7fFVTGErBUbeSASK53xziqcLuGQtmN8wVL+obTUDTOX7X1VBx8solvZ0tJ0Hti3oMLmagPm7Ujlq2x04fhftJYeW7PWRXqtQD2fZ/pRfZsiyYLiyq5gYqqFu79gwIJA4WgzF3daP5opOqZf0mJa2Fysf71gliu0vfsgLjUmj1nrFAoQ6cF7XeE8mcl4HSTzyhAlBnU+Au/bCFWkY1WHMCbPiiWIt5Jlt84z1NaR8KyGH2IugskraDMLSA6JbmO+tNN7yHaclt7S/UXLz46K8DY71Dc8Xi31G3sbv
 4XaD2AnS
 dZNXYzmKt9/X9v72ZJhoOg81j3JlHDnrNlghi8yDGQlWQ3/qzOwz5Gd0n3Z8ocYN/GMIaWygOI/WG4vj1zkBOy6WDzbYCQKV19nBF4VOanIZlTFBIpoWRha/raH0gOGGbVt5gAviIZdxzZti6ex6SFxo9Q50lK2LSmcMB6hvVmYawDCqq7GED5vKh77fNyF2ygG8s14JddjtG+fsUwFAPK0eOHhfgWrEL831p2+AN2O0CXLol0SRyIxRNVIEjhBjHeCLSRUVyH/AX5qB8tdPZmPsjUmGKRR9Q/5ULAUZ6GmtpVSR0nHTiB1DZAcsm+35nM2d8V9SXdmFrmu6uAnqQW74svmj80l9UiJw5mi4ibhpUsuVGtx365EpKJJbSC2XHhy3b2MiGvNazYIiCBA34QIxatA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 17:29:36 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260323145646.4165053-2-gutierrez.asier@huawei-partners.com
> # start of sashiko.dev inline review
> commit eaed291e6fae91842b1836c68bab867d53525db5
> Author: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
> 
> This commit introduces a new DAMON action, DAMOS_COLLAPSE. It allows
> DAMON to synchronously collapse an address range by calling madvise
> with MADV_COLLAPSE.
> 
> Link: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/
> 
> [ ... ]
> > diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> > index 3aa5c91548a5..c6476e63f4fb 100755
> > --- a/tools/testing/selftests/damon/sysfs.py
> > +++ b/tools/testing/selftests/damon/sysfs.py
> > @@ -123,11 +123,12 @@ def assert_scheme_committed(scheme, dump):
> >              'pageout': 2,
> >              'hugepage': 3,
> >              'nohugeapge': 4,
> > -            'lru_prio': 5,
> > -            'lru_deprio': 6,
> > -            'migrate_hot': 7,
> > -            'migrate_cold': 8,
> > -            'stat': 9,
> > +            'collapse': 5
> > +            'lru_prio': 6,
> 
> Will this cause a Python syntax error when executing the selftest? It looks
> like there is a missing comma after 'collapse': 5, which might break the
> execution of the DAMON sysfs test suite.

I think sashiko is correct.  We need to add a comma.


Thanks,
SJ

[...]

