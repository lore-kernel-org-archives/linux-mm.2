Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC096C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4DAF6B00A4; Tue, 22 Sep 2026 05:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6E66B00A5; Tue, 22 Sep 2026 05:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8756B00A6; Tue, 22 Sep 2026 05:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 617796B00A4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:23:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2075403D8
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:23:50 +0000 (UTC)
X-FDA: 85240861020.10.F345A09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 30220100002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:23:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DqeJD2tm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790069029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=II/+fPJUfxh7r6fAXYXNIc1fkLRMwSiccDjJ6S2THbw=;
	b=U/rJNfEgE1xAyUIJ++q6m4iPLtBaa59ayxN6ViwoY96QHggS0JKtV7+GU9vdhXkFf81SIS
	GMXzbYjtG+zLJDwLni4SjVBrLphXkcI/RykYHZvAT488JwzyoABEHfldkNfoNdvkuS96hn
	iWTrUGg2dJBRF24WJm9+d41SnulaycA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790069029;
	b=u5y8/pCpvEY/WiZZ7S+QqEWS4fc+C+IUn3zoXhztrUy7ifAjGEIRW6e+29jfJUnTIGZPME
	D8izSP0/xPLvsVRERCdJ6fgJvv37f0U5C3UFq/pXiSlBP+T/sO85Xnq3180PnnAAmQ1EBX
	bTO56R2q83X8yTaGFQo/fAubEAvvonk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DqeJD2tm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A945560234;
	Tue, 22 Sep 2026 09:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A87E1F000FF;
	Tue, 22 Sep 2026 09:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790069028;
	bh=II/+fPJUfxh7r6fAXYXNIc1fkLRMwSiccDjJ6S2THbw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DqeJD2tmh+fN1hNVMw8k5is7THVl0KB/daYaQRoKLvrUALNxO3E9VbO3hQOKmtuIZ
	 Q8mialHrHSTuQZWfyRDhEVejrGI0CAXG+ovxfJ/0cSmMR6xpVBq3Y1lnuAiT0N9qqH
	 B/QcsalYpX3HdrK75vJQXlxH7zc9sgbzXJRi39Atmbnozcm/OCej64z3F/wmwjPatO
	 JYYQ3By4SCuw03vuy9bqzT+iwrmSCqkEUaaU6v82R/nVMTcqiU1jN9Rg2SyLxNcdsw
	 r0V+9Tg0hKH275kYVXLPnptqgeBLNpgCqtiJSYng6o5xFcdHWKUgQ6+wMolbt1UUcC
	 OqLk1CLnt9/Xg==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Peter Xu <peterx@redhat.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260921-nommu_gup_pin-v4-1-c410041cc479@kernel.org>
References: <20260921-nommu_gup_pin-v4-1-c410041cc479@kernel.org>
Subject: Re: [PATCH v4] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
Message-Id: <179006902500.6914.763745635708083429.b4-ty@b4>
Date: Tue, 22 Sep 2026 11:23:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 30220100002
X-Stat-Signature: 4bhhztx83ce4hntx6ztpkpmfw8ysm4ah
X-HE-Tag: 1790069029-85472
X-HE-Meta: U2FsdGVkX19tZdbL+vlPxQNNEemu0d3eH3BCk/ZPgj2cU2BfVG/mQS/EHPnXGavfpZme0hqphosYl/nsiv/9GX1o/v45rOF33zU1eXwd72XFlLu/p0DYDFQ7IfbBJtiv/qnnNLq97zSXTcQ3WXL3yawFp5wOkwJhMTiKgO+k129pTWdfJ7CONRMoCHylzyYLB0jQCGNrKBo9XU7x6quCRKTunLMVWy58E4Wk+JULJck0qwzlK+ClX8r+cT/MGlbfqGGN+7Xkc271sV77XL/yotfEq6hWEhByW+YOFTV+sSHDkKStW3aYhxBLq8IeGne+/htiw3x7s0lqSxveC6A6nqqtWGCM+NQDi8D2VFYzjRyzkmk0q2OWvsxrzU26VDbcI8Jz9+NG7IMu9QqdWqnS7WKH0qR2AENlUIXZPs8ZX3oXkqt/SVeVHWQs3xPxM1V1Hi4vD16zPsf/yxlSCUSnCf5QZKGEM4lXni3YG0PQY0x9i/bqtt7t2K7vwPEfbfO4Y4e4gkXo7lg8Js/rSKV0SJC6SRCX9k4eSE281HtrvPRRu0afJjOO8K8SgAs3kbwbwdaqSTdQYwC5N1sfOyGFzkcSPeoqDo6TeV0txCYYwPhQl+cqEJiTdXEAA3RIkIwkf6rGhtuEuN5fYWHptp25abQ/pzf3aKu9AZVDva3BvqfU+xCY/UPqegotGpOd2CtjMHpSjshnmZPUFOElPUdGoY9KH+6FP0bfRniZ55BHm3zw/Wc+KHmG3BsmmoG45s2uk1GicdESkU7kcoG/i8YlkclRNbm+8sBzTD1LdWV5K9jJAzbWcRINJ9PVAYi2Iz1WCGfDUjs6XKrqzVODIZ1eekAu9uzyCuOAabZodgHJv3KpqT4QkM4mkaGpltzwEk8ScKok4W78C6qkk6lll0uS5LOcyx10VJFnm8iPBRGQG9cBg95KU4lR61LAgvR1B0IghIT3tsIGrQd+g9C6ou2
 8A/Bf2+Y
 ta24i2NWanP4s4/NrGjcCgHV177huY0Gx6AT8sFU78oix5IxKPjwsAG3h2Xx6FD2lCRzobj37mrZI1+mYZTkmrtJRv7lZvZGPxQOGaZ4DM0kBETUtJwPmVsc6HI+5C0C/DKLqp1QpvpPmVZHedo492hPb8Pk7HPk6HWggUCYWlzo70AqrISE4qq1Gzrs54OLMxtroT48dhOv7n8/LvJG4mBSYgNFvXM5cjANxX2NoS3dgnzJAVao50y+mavQsSzIB25gtVNJgGoQYZF4oWESzaLo3wDlRqQ++/VYI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 11:57:29 +0200, David Hildenbrand (Arm) wrote:
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
      https://git.kernel.org/mm/core/c/da01399b

-- 
Cheers,

David


