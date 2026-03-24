Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B84B5F532C3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47C06B0088; Mon, 23 Mar 2026 20:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1FDC6B0089; Mon, 23 Mar 2026 20:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35F36B0093; Mon, 23 Mar 2026 20:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B111F6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:29:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BE6FC3F51
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:29:43 +0000 (UTC)
X-FDA: 84579073446.02.70CB00C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A4D67C0002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:29:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Lff1/uUm";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774312181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgxQoXZoMRqpKHASnBu2POaPAVutkDcOpO00V0ep4HM=;
	b=Tb8BWSCfRQ2yOwQqDovpASCiLru4iwJfSiqZp02/ovsRpEI5pecfeO5oAEYvBOYr0SjaXG
	xys8lNh7NZ5hoR5EwMZdAGPpoerux76xfU/fYRxOfwWUbCWbZOl7h2tfmE8I0bDbuu8FuA
	cZxpxvlVPFmfJGK0eM96G5PKP1LNVeQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774312181; a=rsa-sha256;
	cv=none;
	b=58ZY1lHJs3pkJUUdEZiJvsJBi9OMHA+Wu93aT+mAw/Vwfkv9DJ+Bvb6n0RSrqmEZhKIpK7
	tLXXsoCBE65Goa7VxXtlHsT/sZIJ9VIKx6p+iGg8olcQPrpDKJbyA/e8TdbkC4ZuIvj8VE
	zDK+Wi1L6SivIFJrRQb3vYIeBwn+aFg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Lff1/uUm";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BAC5C43CCD;
	Tue, 24 Mar 2026 00:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC1DC4CEF7;
	Tue, 24 Mar 2026 00:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774312180;
	bh=84oF5StXlVFM1n0EH38q9LyOhne9+NiaW3HGzpjiGRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lff1/uUmxbVvOZ9EJJ+4R89lBZdIrsToD8UvgKOAnB6ajDrqzszez4G+SFVcJ4V8M
	 5Yw3fOb7PsbHI2QqRTVb+IN5qoORgfqZmlYw8o9oko/5A+W+x3Jx6hJlV86HG2b6Af
	 n/OZgE42YkjRq88gbmAnTD5iib5OtKZ8VNtxJdR+TJL6W8PkZ2tDAl1i5qy2JC7pV/
	 eITXzooZcjeIrDn6H3NGF3gdSLT1xVO9WkoGNRNkoSBvNGS7rRM55AlfndhHL3N/1U
	 cxsg/zcZVd8lLWgvAowQ9MyXr2ctDeNOcPLYt/8ljBMHP/v2hWj15OCw0DZ0ja3zX6
	 KRLlp1KCfxQcA==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
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
Date: Mon, 23 Mar 2026 17:29:36 -0700
Message-ID: <20260324002936.86653-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323145646.4165053-2-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A4D67C0002
X-Stat-Signature: zgxqsebia3tyyjeezyfghgpw6teboh34
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774312181-184505
X-HE-Meta: U2FsdGVkX183vgOwabTwSOl1MjToNhh9w5m1JlPd2aaFPo9ecMTC9LHK8qeJad/rUtH9ZYjZ/KUAvPXqE24ePTJwEAuspLd98fh9zsvQqnebRI51T5yo1kjmhBvwg8VWwAa8atjrUX0yrU1F2PaaqGox79rlsvaa/Iv5mglEVBC++wAY8RE+odGJTZC7pvDjLp4KnGqsedi9fXIIpH4sQGoTmZfkB5owoxbx4b4pIgUeFAcxDOmtKvwC2TtzesPPSIdgKtNsmlxWue/Iuw93lmUq1f1UPFcg3wzXArBDolo/N9owv1B5ccLkKCXsPkh718H/jYZpRPt3HhOKe7Li1Mv4HchqTq2sILVPWB6wXlPfd4/2+HaJ2t0JnzanbZEJD23EaEzTh8VwZD9afDh/FCmC4J3qXSnVqZg+Wm3ZpiLkdpS8fXNNpC8jj64UeMnRmoU7vMPHvyQ6QXinrIYsAh64Zv05oVFzDNxyXHy1U7sqMWWdqvD70RJVV8D2cNcX9WiiE2bETfgJV0aZQMVuOrVAg41fr8wWK/8Cp6kt14TVcfbL2h4lhOjTpapaGfrnvyIOOnAn0uGJvKBuVL6Fa3pod/VwvD4iXOhQ6LTLgEY+KJrkSNV3fMKs97JFbj3FeG7libHT0hOkzQUQnXYHk5aw69QNlAqwWxk0QPUHxw+8Qm0WGOEfN1cXTCAPfzw0KAaF8szBQWGBFZH3qP6SACwV6FbCaE4TgyEpOnZcitp+DlWJudKYqnvGUNdnyjWlo4NpwNIO2x4YPESM3b0BiVi7H9koHlUW4vW6P1aA+p/JB2ibBtRdP57wuzDFwkVG1m2zx4T9Hs3TkrKKLGCFiNHXlYkHhLJi60KHe1O68u0Up7T6MNcJ4bwWQq39Vn0TRXUKMNDtpvssn762aF7mIqJQ2vA2cTfwPMXgexMaZWnPubusx/X9h/Rs9HFvwAnybiT64zEuFCEJTK7INty
 KqG1QRhJ
 YxuNYFRi4Ed0mB56EujQPcmsZSVXlLwdX+HFcokSR+tk+AXK/19sNJYYWmEO7U573iDZE9ubL/nCU1BaqevWv1VQ79UOPFQn+91puAMfUJAVFNY92EL/xKsC6xYxJNHk+IARSyA/VbHOnqcp2FhDJ1P9IaZ79ql8Olw9WD1/QrQ3j7gxgP8TIrAiHiooG5o1c/gBsZqFg+ysd9FQYQn0MoBPtPW1A/TomMfxfNFoLw0Iy8c1V1L31l5zsYC0yjH15qERV8sIoWq1T5EqTCFAVuGY5w129aesY6Fq/D42ausG6a0FIu+e7nr0xa+nobQiWKEtulcO6NgwXFPSrfVgVM4luiEtmGj0vlsuSN71mSxUcMEFzbFx65NS4XKkmA98l087iMflVlkpxar/AO8kL/FZc+lUMlqcuRiV5TZ/i6IeRaT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260323145646.4165053-2-gutierrez.asier@huawei-partners.com
# start of sashiko.dev inline review
commit eaed291e6fae91842b1836c68bab867d53525db5
Author: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action

This commit introduces a new DAMON action, DAMOS_COLLAPSE. It allows
DAMON to synchronously collapse an address range by calling madvise
with MADV_COLLAPSE.

Link: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/

[ ... ]
> diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> index 3aa5c91548a5..c6476e63f4fb 100755
> --- a/tools/testing/selftests/damon/sysfs.py
> +++ b/tools/testing/selftests/damon/sysfs.py
> @@ -123,11 +123,12 @@ def assert_scheme_committed(scheme, dump):
>              'pageout': 2,
>              'hugepage': 3,
>              'nohugeapge': 4,
> -            'lru_prio': 5,
> -            'lru_deprio': 6,
> -            'migrate_hot': 7,
> -            'migrate_cold': 8,
> -            'stat': 9,
> +            'collapse': 5
> +            'lru_prio': 6,

Will this cause a Python syntax error when executing the selftest? It looks
like there is a missing comma after 'collapse': 5, which might break the
execution of the DAMON sysfs test suite.


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260323145646.4165053-2-gutierrez.asier@huawei-partners.com
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260323145646.4165053-2-gutierrez.asier@huawei-partners.com
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

