Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96243CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 00:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C35C08E0005; Wed, 10 Sep 2025 20:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6608E0001; Wed, 10 Sep 2025 20:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC698E0005; Wed, 10 Sep 2025 20:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9588E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:57:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B2AB13A9E4
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 00:57:18 +0000 (UTC)
X-FDA: 83875155756.12.06820EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A27A180007
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 00:57:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DpDY3dWV;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757552236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0Ap2IyqSKrGd+YLGVqonnH2Q3NInRMCUoBm2AjpKS0=;
	b=sehJC13SExev6Tj+x3StsEo2hmej9sXHSlnT9fzaYDFkkvTT7UAaob81DdLt8XpALk+BWh
	EIgNI2vXEMfccpJw3zlpZIShGqFmGdQtQlHDyqcA9eJstYo5SwvVbi6KlILug5+Otg2Who
	Q6Dujdw+EzQSoGiWzIADrxt0dekU098=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DpDY3dWV;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757552236; a=rsa-sha256;
	cv=none;
	b=1blT5KkLC+4ItZdOgxT/gelEwFIkiKl6f+38ts7rWnxorAzphgZ+jOKFgqC3cXsGGaq2hR
	+S7eYwE4oZYP6UnGFeye0pC1SbW+glXT9Adq1Nus6oe30dMIrfh6BSneGJXj/phB9m0lNX
	6oAudIF7DpLGYlx/GgW1kxk9t/ZrhfQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C3F606013B;
	Thu, 11 Sep 2025 00:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA86C4CEEB;
	Thu, 11 Sep 2025 00:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757552235;
	bh=XNuE22YtovlkI6w1sRoVwNQ/wKN/+MV+al8LD8kkVlA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DpDY3dWVDS6Gl/kawv47cfH4Esb5/+X0WcGv8qx/Txf5F54iKfLiYVbtN06o2vgIV
	 YSOc2U5CkRYO21buBi3a5HChMP/q9ncd5X1rwAX02tnsE9sX3h+Y6lxn7Rs//6qamB
	 /sspLg2FDHGE2anhouc60jvfc0Fpd2a1GlGcPnMw=
Date: Wed, 10 Sep 2025 17:57:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, oe-kbuild@lists.linux.dev,
 lkp@intel.com, oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 398/411] mm/huge_memory.c:3069
 __split_huge_pmd_locked() error: uninitialized symbol 'write'.
Message-Id: <20250910175714.4203dba33afea5516761bb2a@linux-foundation.org>
In-Reply-To: <88f160fb-0f84-49e2-9139-1fba1a21428e@nvidia.com>
References: <202509101756.jkC29gja-lkp@intel.com>
	<88f160fb-0f84-49e2-9139-1fba1a21428e@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aecaut9r8mjjy6nz6rcq49wip9m1jew8
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A27A180007
X-Rspamd-Server: rspam04
X-HE-Tag: 1757552236-919410
X-HE-Meta: U2FsdGVkX18FlEMs8qq/nkB7Ufh5YxghbHOJNPch5MnM7YtuHQLTwlqvfYMQqeJyXhEOR+YNhjKpk8vYpNI9vAr6HOOUu3wVHw3o5sHBmdJTUmBZ5vqT9byPmxqxg+AUVzjM8ZlblwDWFz7iu1zREqNUuTdeFF4x/GNu+sSqzc1368dvfQYyuoAZGuOShC8eiHoFlZfnuHx58pETWSTVfhVA4QV1+QRmxGV3v2RuQYSsAKhozd+2yzDXXpFyjzpj2BJdcugshJAeEIGKVGaHSOmAcOMFYyrqzNwyauGPgNZkNxya0tYiSNkNjr3osLokMbICafkTbriF09biVc/PFR6wFLjCMMg/+a8UG9/IDRZ1RzqI798aJhZi1o15WSyJSKJy3lQIIGxSMMQFEaPi0rU202iApI9hLRqiD4zvR2yRaUpe3Hhz2EIj6o/T4CYM95TDwRoWm439UJsR02PKKkGIur6lA3wc9ktBZSLxaEHgWlpywGYKQQPbSEMZSKLFY6C/kBZx8/qpOHN3oKZXsQ0ZUYA/Vt9AK+/vHnTaEC4FMYuRt7GsGAJzqmHEn2tj4GFs/zh6k9HNRxIeHdOYK1ejcDLHV+qkxd1YSnqb6ngx0dRQDVKJlLARqcCBACW3mf49kkhLVE2vPpd6hVrBSncM1+kUEIT2bMJt/+H56sFItVe1zxeVcShnGPYYoPdv6Cazn0n78546DHF2nzSWyrV81JyfIceRD4Fuo5e7J/sdcQBpYKUJzjAw69S99go671DhWQH2ddyIuyzIMRAgzSb9rU9+1kBRpaqwz3N916Pz9vD5f6G7EFwCf9Dj5Qnkzv1x2FeKjSsy2hyJttORuQRaFVO3NF5jz6zGCGC6ET5/ywMaEHy90KL8JezEBByjSUVjpdThsFIpAg6BjtL5pTC/ucTGYxeRKEEpqyTnHJLdxwLucx9KFYoyQ1sKWbEsAla1EbO49lK3l8vPcfg
 QLB15iYa
 tBBO1LD39sZn7EQABEvw5sPrD6Kh8vvUUdo8wpbjc9RbOuQ/Ot1Y0IzW26x09S8lV4zCWp90mWIRZKE1Df345+RK220svU25G5rKM1Uw0eVkgEMbVRNsSNYnwLb8059mVaqB+12xm9BM30rvA6M4iIhRgYNKemLwg/h4ii8Ee3BvTlxtmVsJKbtb4mzoK8QBimN93OSn6gc+nq2XpDqsTA223Xx4ibXBcBUze3VJmT+5iVMK3/MbhjQC+pseG24zI/CHWu+EnDaWBm1dve5msq++Fg55G1miD8tj1+rCcDF5W9Jh26qLwIP+630VPt/euFBML
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Sep 2025 07:54:20 +1000 Balbir Singh <balbirs@nvidia.com> wrote:

> > smatch warnings:
> > mm/huge_memory.c:3069 __split_huge_pmd_locked() error: uninitialized symbol 'write'.
> > mm/huge_memory.c:3078 __split_huge_pmd_locked() error: uninitialized symbol 'young'.
> > 
> > vim +/write +3069 mm/huge_memory.c
> > 
> 
> If the entry is not present, it is a migration or device private entry, so write is
> set, I understand that smatch is complaining about it falling through the paths.
> 
> If freeze is true for a device private migration entry, young needs to be initialized
> to false.
> 
> Andrew I can send out a patch to fix it or I can wait to gather more feedback
> and do a v6?

I think a little fixup would be good - it's nice to keep track of these
things as they pop up.

Is a v6 expected?  I'm not seeing anything yet which would necessitate
that.


