Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C27BF459EF
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 16:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605F96B0098; Fri, 10 Apr 2026 12:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7326B0099; Fri, 10 Apr 2026 12:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC5A6B009B; Fri, 10 Apr 2026 12:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0F56B0098
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:10:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98987140591
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 16:10:09 +0000 (UTC)
X-FDA: 84643132938.02.F8DBCAA
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id AAA5E140017
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 16:10:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Keaynp1b;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775837408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BB7IYjQQZ1l045FGtH9jNsk980TMEUrAf2ulxew8SDA=;
	b=AWyzFu/+l1EPSx/VtnFY+FLtwxkAeBCt7TZJipbaSBAEUxj8QkY/sRZJjAx6+nIUDHIaAm
	M8GP6mkSDz9AKw8ZSlP8CyAc1yPsuUlbr3oMLIfVgBvCHjNy09hZwUi5HRHhh58GHSIPs5
	kZlSW76FUQTFV+zRl5zoDn8jpPj3j4E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Keaynp1b;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775837408; a=rsa-sha256;
	cv=none;
	b=d0KnoqX7Zx0/KJ2/FsdWAzyMFoU66eXUCMMYw/MgyZ8LOsUndCm6xFEAmFS5HG1rqaNlq2
	hqfpYPLPNGvO899XnIxayj6oOnj43fO9w6WpiY9qdA+ioAfsob2tdMemQKXXFATXAHpRaW
	nBfCVTbz6miXXUMMuMXtJnwhr5wVU6Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775837405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BB7IYjQQZ1l045FGtH9jNsk980TMEUrAf2ulxew8SDA=;
	b=Keaynp1bQXn/qXRCODYj45J8Fua6vqzgHhv3cyproUZbe1LyzdF2pmFauECJm8QcyvbVDq
	kpMG4HoYcFKChLGXGIJL7p2WyNPlAXy22DYIV2bl0crYuYoZ7rSqqFEpnSYKqqwil6JCFm
	p/MfnwZ/QW0PZhK3EO1nfTYr6I6q1KM=
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 05/10] mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
Date: Sat, 11 Apr 2026 00:09:43 +0800
Message-Id: <20260410160943.74271-1-lance.yang@linux.dev>
In-Reply-To: <18d82575497d06a4d18605ae33f9c22e08a3209e.1775679721.git.luizcap@redhat.com>
References: <18d82575497d06a4d18605ae33f9c22e08a3209e.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: AAA5E140017
X-Stat-Signature: e3yjw9s3wdrfxkcc6jiz1wtuowfboigp
X-Rspamd-Server: rspam06
X-HE-Tag: 1775837407-595037
X-HE-Meta: U2FsdGVkX19R2Xe/Dkv9N/hurTrJqiBKj5P1BDpsAhaomp/WYnTWB9NsHUr10CwawRGfcdNuvjqctshycAP9PCULWZT1g4cmEpI83G0ds8m0qon0yvctQPMPPW7zfg9XeXn5AD3i4OTMqnH2P3aPz/lKeoyHIo0THirA+c1P7ULf35le5PTbbssHeo7mFSCx10JDSzFUmqewJSX1xvbUGQw6lqDqtCms7QbLbKe6ckVh2vgFnAS89gElWKcN/Fa3GIJSFjcLyqf6u5usobGKXqUu/e7IjCWDgbm4Vk0CaBLgNndF5BRpOVs9eyM06K/egCIqEjjkgf1C7vwSO0z0gRWnGa/dt89j0aH6doeSUvKcWKXmg7gW9btSMTgRTvYLV+tmLgKQDlX34nvb9O11v6YxZ7UCHaHX5TMUoyiLRMsmtNCUhjn4crYJ62H0BXs2UvBY+PfHjOb0ogKjXEYoV9kkDan8WS9ZrxitpFPBW7DvOepKC8erVZoOK0FeLaXgFG8OhOuZyCCcPCUX9Y3wxV17TUQhKj3soCykfK2miROxNWDvqnH0t9LmYVMcKSBskzkBOkme57CFksnLf4fOnP9ghh3aywLY5ZwkWjTbSX/xuowtQqay8wZSsaaeZqcxXzrqsdapHDECzCAKzMy3sYLxQYn+bq76VgXbqdOp37UM8iOawo/ejU4kyzIk7RiT3CN+CSuSfMXiIHacwRuPiXkIs73xapUtPml+QP/MZmU0eCTA5khnwVWkCLZcmHwUTHK3KniAzDMyDP68msFA/6PaqsoQEspXRtBug3B45zvwwBW76gdPfDLbpbGxX3i9Rmyu6jiNRxWTG/OMrrSO9CIDBQZ93c5qClxSJz3H1wVPfZD4IQ0wWPbtgN3K/vTphEHE3ODU92Iolefz7o1iS3IAHtoNe6DqK89pKwuRJ4cXVUyFqXZzyQh5ewn2lXQ7OctdjPf3tKxSbFIXavK
 VXbxMp2G
 Zt4GzkuFkb+8tr+O8nYzm2GNJb1j6RBfyMARHXWJi8nEeeZWZzs0D8qvFTy7NBeo38HXygGSZSxisXo0yROScoLAaRLLMPzIDwn1O2Qrx0HghG3+TbWFnJSLj/xpS+Ed31gJ2f32F6QBfDUDPk4yD6K07GFF1dx9+fKfwkj/EsipRdc7ASyDfgZqzxo2BiSGVbhdF/yJvEHE49Ok7EGz4BRmuwT4XNG2rehW84PT/CgR12ClXCIpd3jblL5LMmnWm5n7Zrmtkr9IupPLKa3qp6q+yVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 08, 2026 at 04:23:00PM -0400, Luiz Capitulino wrote:
>debug_vm_pgtable calls has_transparent_hugepage() in multiple places to
>check if PMD-sized pages are supported, use pgtable_has_pmd_leaves()
>instead.
>
>Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>---

Nothing obvious was missed. LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

