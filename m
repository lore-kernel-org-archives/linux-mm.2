Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA12C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 03:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BE688E011D; Tue, 26 Aug 2025 23:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357358E0105; Tue, 26 Aug 2025 23:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CC98E011D; Tue, 26 Aug 2025 23:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1491B8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:35:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B83EB58E6D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:35:56 +0000 (UTC)
X-FDA: 83821123512.25.A4299D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id ED1F7C0002
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:35:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="I/bLRoD/";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756265755; a=rsa-sha256;
	cv=none;
	b=yKYYIS0aKmLYExuAya1r1MDOUqdtFU1uMN7AiFDesz4MgNs8DPMxsPyBnXJ0VKklNtT2BK
	TVdxfMBPyoA+zfuHaxvBBIxWa7fML084+5OKWEYAmqcMrv2L3DnYuSgfvE4927NX6OB/Aj
	AJ7L51rb/jg39gonHCgW0o6M4ZSmSSo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="I/bLRoD/";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756265755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKJy6xKalopPSxX5SySGROyl8/Hix7E0tzIZR3u3LUk=;
	b=27D3E6ubJguoesJoUShledZcnGoox4Q9l7fWmv0MrYDYZJzOaXM8tS7Z3UVDS3krLKM0I5
	vXq+HdEE/8ws6op+dWTqSW9Asu8tvoKl+LhdPPkL/k2P4tcL5O6eQk89+e9ZviRUsGyTrP
	y2x2y9FWyLNQWNm/rfK5esroG2orpWE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C6408401C0;
	Wed, 27 Aug 2025 03:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706B8C4CEEB;
	Wed, 27 Aug 2025 03:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756265753;
	bh=SM4xb832pE5rvEBqKKRa+/0EhP96sXD1OR2lz67r2k0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=I/bLRoD/8nIla49/f1C7uUseCKIzQcE0Pyq0JXmCakfN4IycnEKNIWTFvMotNyyy2
	 aUiy4sltWllRxRJA26414bEgzCKpzRWepEmynuRP52ORskRAI55JzXbxcOogXnIKit
	 4DxN9YwsfKrbzHKVK92wmbaUC8OaQhLhB2HB0UiE=
Date: Tue, 26 Aug 2025 20:35:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@redhat.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert
 "hugetlb: make hugetlb depends on SYSFS or SYSCTL"
Message-Id: <20250826203552.b4340b12b16a374396f49343@linux-foundation.org>
In-Reply-To: <20250826030955.2898709-1-linmiaohe@huawei.com>
References: <20250826030955.2898709-1-linmiaohe@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED1F7C0002
X-Stat-Signature: 7rmogbg59zmgtgh5xapz6fnfdstqrfhe
X-Rspam-User: 
X-HE-Tag: 1756265754-433395
X-HE-Meta: U2FsdGVkX1+WglLQUNU/utftztxONJHZ8RKsfpX7YvJRgav7hhH2ysOBx2yr5YiW/j+1gJFTltg7B3oMj1IggVfQMBbPPw07UclF5e3hDUCSawqdh5zgyRIpkdMQtLWCDA2pzpNN/19lH99l+F4cOdTts7WVwBwVueJk9N2Ku4luMQMf/tCUwH+pKjw7ZYEH/wQftONvICWBI5Qwt2H3jvvj7i/Jf73HjZY7n05dyZWv0Y4FnHDzOTd9xmo3m14OqUhG+2HEBe1+Py4XvElPy1TCjtcfBt2EMkiha/E91Ku64luq5nppr6xenlLP/k30iL6ndVtQe4PT1+HKEfG8XYzPQmu0qsn/6ZCoVuMmDruXUvvs3tLWatKzGDSzZcPCWlpi6VQ5ZyMg5e+LDpZ8RZPKhS+hh+l838bBCe6G2gMYTiOHxguCV9bXe4WC7VXDBnatpYcKEhGFMPdDW3Py/bScaUAEyHuQTxwKjvh170IA+tB/p0exeZpu2TQpp6Btl+BCYB89kAvX02AZ+FVvDV2YqFHXCbC6ihUvVduneFmZ4WrgoYS+GMhN88i6PP4eQHPvxiOUcqoeW2P76Yod95trNOj8Ruhk8GobeM/4tkibfBV6ahO1PZquIJ94zNaDECAP+42/mTqgvWYJBRrV/58WqLRujERG4RIe0rAzb7T5+icLTists9Oj3nHogmIHGmoyD3T3efesGK7yLkJDPF4h/SVChDLoo+uPBTDZdp5WDQwzvlt9YD6MFG6D6BOQXqoVk6WKgjx8L+C6DCS63QDnLStosQFvYRttik/tbz+KrJTlEAcIPvKipOPg8MF7js9CzhnckHy4ZhhvujrNO+U+8NXrsRnF5XQillBHFNLIXB2mv1Fj2PTIckGfmTYf7QbEi4VGWKCitFzGj91lLubiXXd6fqGAoiXea3wIAztSPpbnLlvvZMihGvPfa1Y8ChNFaz8eXJMie6/2awU
 gO49mOjj
 rSy0ufqQrL0IG7bkeI55/Fscl7vXwBiiQEsJG92xsUnGtmQ3jqty4ShMDT6hd/iSpwQRxmyxFFEak1p8ntNigml0dql57jcfN7JV7BYjwbahqeQ9tU97Kj3cHv6j4aJN5Xpu2aaZYAAbM/9gQP11tSB9kopsEI8iw3KXfEqfsatkkEtKHwuBRggGi9xsPeGvUbuUmvChsdTzcVOchVFLtEy3sINGQTkZU5FcIrHHUuFXvISl0/f1qg9IiQWfXq540Qcfn4P9813YP5hg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 Aug 2025 11:09:55 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:

> Commit f8142cf94d47 ("hugetlb: make hugetlb depends on SYSFS or SYSCTL")
> added dependency on SYSFS or SYSCTL but hugetlb can be used without SYSFS
> or SYSCTL. So this dependency is wrong and should be removed.
> 
> This reverts commit f8142cf94d4737ea0c3baffb3b9bad8addcb9b6b.

f8142cf94d47 said:

    If CONFIG_SYSFS and CONFIG_SYSCTL are both undefined, hugetlb
    doesn't work now as there's no way to set max huge pages.  Make
    sure at least one of the above configs is defined to make hugetlb
    works as expected.

So there is now a way to set max huge pages?  A reference tot he
commit which made f8142cf94d47 unneeded might be helpful?

