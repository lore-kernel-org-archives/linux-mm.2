Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15BB9C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 20:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747D56B0088; Sat, 19 Sep 2026 16:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8846B008A; Sat, 19 Sep 2026 16:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611186B008C; Sat, 19 Sep 2026 16:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 431006B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:00:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A6D6A578F
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 20:00:24 +0000 (UTC)
X-FDA: 85231578768.30.531B770
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8C8E218000A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 20:00:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gIZNqq8R;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789848022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVfBFCmbKliEeVR2O90Bd2VG3Mye0fRiwIGadK6jWE8=;
	b=6fzPguUhcxwTfSbbVd95iLphf8O+RLfZ8uRdhfTKMbZLe7Y4HsQyyRhGDf0Me7ByzcLevo
	kNspi+ZIRwba0+z6lhJxOwxX70aRPEvVaufsNm9eT2fjO83bD/eNciZpTCn+RCs/XYXRQD
	JX5Hh1CelakoHCYO0crDWNtYFVNYI7Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gIZNqq8R;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789848022;
	b=ppJBe6zegUikKMABcpT/99JBM/Di6BpL87r9egD642aWEIYrcuPbzB8ylTkk8wN1qZ9RN1
	KSdNDCjG7MUbCG39ZL0P44S1cve+Yi1wGdKlUFGNW5eQZ1gWhaEIg+vFB3sEYvhVYGC96R
	ZhHv2888Pb+ESLW4H9ad7ePqyq+tLdY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15E33432F6;
	Sat, 19 Sep 2026 20:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57CC1F000FF;
	Sat, 19 Sep 2026 20:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789848020;
	bh=bVfBFCmbKliEeVR2O90Bd2VG3Mye0fRiwIGadK6jWE8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=gIZNqq8RsuPT0gWMEhRJIsZ/Jlu9GJlW2yZuPYSc3DNPkPp4ZS3uUsDWuo5+5aiZb
	 9zfUxo6pmoxMVT3TGmpQN735oUvHVmn9g3lbnTYvAH72SqR4AW6LTbEWt/7Ltpxu8C
	 cJNAEt73IJl4LMxZPa++Q/L8x1xEqh+ao+RmqZxhjXvfeGb/DsEOkwYiNklp0EpiOf
	 z2eeDYYakS3ABqWwaRJtWt6BcfLvigWm5kBRONzTfKlbMJm1O2mq+puG05TIKAUfQ5
	 D24iQjYP4r+ybbztvCVmpkbSOYFWv6u9tfmbYQvDT08tYmimj/dllXA6JlpC8ZmNGb
	 cCD8IeVbK5vmw==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Peter Xu <peterx@redhat.com>, "David Hildenbrand (arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260919-nommu_gup_pin-v3-1-3660a8851243@kernel.org>
References: <20260919-nommu_gup_pin-v3-1-3660a8851243@kernel.org>
Subject: Re: [PATCH v3] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
Message-Id: <178984802063.1919131.12249420688270261597.b4-ty@b4>
Date: Sat, 19 Sep 2026 20:00:20 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8C8E218000A
X-Stat-Signature: xj8ckrxr1zsgictg3scyphuzyr1qj7zc
X-Rspam-User: 
X-HE-Tag: 1789848022-500096
X-HE-Meta: U2FsdGVkX1/+jEzrTNO10qyRb9WHxSIqTB7fy7z3J3Wua2c6/Ei8FgetKLNTKeMifimyQiKIgnPqUmJFBSIGN+BwuwhPA7eLUxJm2t2bPGFFqF3s/dQFaufXy8cgP/LWCEsHoTymv3KGhhBx2BMtGglNpSS0Bkh2vHsCNtJjs/IyueMM7dPoHXMflX0uqDhj5PYysNr99QshYsyt1xLBcLH5y5kPwQazyq4eHP/aGZ80ucJBwrBJBeb7YqPkiSi0+X6OlFS9mp/k5F7CL5tP4RJRVvY7n5JQ/muxQTZDxk7VLbQgKv4LbYZhBOw1yPsUdzTEAXZeDnyYHkuslEnzBokVjhPTImrI6ZMVssGzYshTOG+KaTE/l2MwjNG8yyCYgZB5qqTrLM2RJRbXi4XLGf2ZCzg4UJjOmCFfM0hJj/bCHkNNrNzO1nJMVkQjafAUgdm9w2Rvr0M9JZvr1Ll3vnGTvJyebLDiOOMc3iov/kHMsNz9TgeSlc3/NXPaWh7agpwJ6CLdybFTlqBGyd57tA2bl+owXV3Up80dwHNPfJj8/lLwiK3O2jhq5PZOcXXy48mTpQEaxUiMX5gWcX42TYQWQcLGuy+h7z0ChhDTu8HcKhThYhoLkhY5Xi7thzOHszgP4heS2L951z2kP8ZBgr7q7gtTgPUh9emw0tlOKmMQlXKe5o0nIDVE51SjssgL0Eix2mDboq6X8uNcG3xJzOmSDFxYWBGxtpi0W6qjMuFT4mVVL3hr0B8cDzMDuYDWAJTAcTy3+atwTo3Pgvw0fBMg1v4q+CaojLDjhyO+Zqcs7BWeH6vMwy1yyWXIjLRLhC9ZkJootmR/dEfsAsLybw9qiGoqEuUSwnM+4K2uFMM0d2lKg9x1zf54RBQVMfiRyBpbgPLuqt1CIMwb0/d+fmU9nCpffLVVGjV8h+5iAeN54JN8PDBQmymafbFjHu40xZUAGsaimZ48OxGdClh
 q7ckZZF6
 74ixcWN7dmjNWDG5IPLDcbDJftKC7XhInE/v+irE3WfhaTrCZLB6HQmjS17IykSGc9ExBjwjKfl8jJbimdmWQa9+7XIOrSE2O14Z1Gu9i95Oc/DGG2J0dCAKWciEou2G1Ip8U2f4xwxr3LN286JvJY42rJw+AvwptdBK1UXLjeDVcsCY1JfKBSL0HXQUv3puU6SnUzSL6ZRANg6ldnke4VMsqmmHss2Ez4DpaHyshZi1bmJVSeydxWgI6YlIwgYvp3G6gnaGdWlPNT3OEnDuOYU9ew2YUCClcUqJk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 12:04:36 +0200, David Hildenbrand (arm) wrote:
> The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
> get_page() reference for each page regardless of foll_flags:
> 	if (pages[i])
> 		get_page(pages[i]);
> 
> This is reached from pin_user_pages*() with FOLL_PIN set.
> unpin_user_page() is shared between MMU and NOMMU configurations and
> unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
> GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: gup-7.4.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/gup: honour FOLL_PIN in NOMMU __get_user_pages_locked()
      https://git.kernel.org/mm/core/c/8ad0454e

-- 
Cheers,

David


