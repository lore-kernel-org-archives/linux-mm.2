Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18668C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA836B00AC; Tue, 30 Jun 2026 06:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A986B00AD; Tue, 30 Jun 2026 06:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8F26B00AE; Tue, 30 Jun 2026 06:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1B636B00AC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:52:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14486A046D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:52:37 +0000 (UTC)
X-FDA: 84936265554.17.A012EEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 49FFD1C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:52:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RPi4dWR9;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816755;
	b=H4yn/umuwFi6JX2+aQyWhCgt5UNVFo3L+U4Xhzs6dUYptY//PEPnYAAkrS3FOo8PhFYzrj
	jsBRjqnZYiLfF5unJFv7nNmrxb+kwxu+vP4Mqj+Mwc8mliwpNe67N8jcYQyh3tMPjrkHD4
	fPcdUG+CpaYBvHj+ul06XpkXUB4nRHo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bOKPhFGTJ86jvnMjbZoaau33s5xEcyP30nMyJtIcVHs=;
	b=TNloMl/ng0idV/Du5C7ZjAoxWUiwsJSYwa78bxsIGEbSalJXk3cMkEv7sd1W05vsJls+cl
	F/ztqw7AJ5oonWCoS7YPKlAkPJUkdZIAzd9MNc8IzjkZk77vSmDYqmoUjIEzvrJA0jdi/8
	JN6a8+FwpZ0U9b7XyVVtNfPH6MQ23oM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RPi4dWR9;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EF364368E;
	Tue, 30 Jun 2026 10:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7591F000E9;
	Tue, 30 Jun 2026 10:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816754;
	bh=bOKPhFGTJ86jvnMjbZoaau33s5xEcyP30nMyJtIcVHs=;
	h=From:Subject:Date:To:Cc;
	b=RPi4dWR9zUKEQydt7dzmtalQ9G2Qo4u61ROaqpb6uEkJf3XllkWPBqUMliGXBmE2L
	 4gsTOBDJIMG6l1eba9K0jJFPK4XrK7nK/KbqnMmAfKIxYCXe/L+PY5l/bvBaNcJjFL
	 4ZPhoMWoPDMuoG85vL+ZWHvxk5iV1drj4q4L8cLVvD2Axz8Zz0DHZgjWvHHlvyuDNc
	 sS12j+2D0qdswekgMN7G4tGFpbcv1bLQBqzqVHiL9HtoHMBWx2Nc6MHU9h2DXOlYpn
	 Bv/xUt7/auFMKLMf+xMpPemJlGgx/C/ALBh+7Uq50twF4L8UmnuuSWdo0KgXTHZcoL
	 I1YuzYeS0HPOQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/5] RDMA, IB: replace __get_free_pages() with kmalloc()
Date: Tue, 30 Jun 2026 13:52:28 +0300
Message-Id: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOyfQ2oC/yXMwQrCMBAE0F8pe3YhWdKA/op4SNKtXcEouypC6
 b+b1OMbZmYFYxU2OA0rKH/E5FEb/GGAsqR6ZZSpGchRdNE7zAF1uicMIdJ4JJrZR2jtp/Is3/3
 pfPnb3vnG5dXnvZGTMWZNtSw96oRt+wHDOMXHggAAAA==
X-Change-ID: 20260610-b4-rdma-44625922fe16
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Stat-Signature: x38nhk34ed7ntaenmcxrkqsse4k4na8e
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 49FFD1C0003
X-HE-Tag: 1782816755-137662
X-HE-Meta: U2FsdGVkX198u8+oDpm1Z9tJYrlDZqs2vLh8skHIzwvNZoDk/JL2w1KpmPSe2QCy9SaIybmLtsYlFuuV01xr+fOHVcgpRpFLlZi0xTG2DhK7QNvo/fEiJgU9Ninv2u9G5ZoP8HgmH1dxo48qGjYhvY4EQircOQUOVHMSWBOUcs938pVnJCtkUsCo3x/xwA2MoKfnCF4Uh2w1ADi2qyzYL2UfU6DxeD3YW3W3k69JUePYNOWAC/j4NhcbWv6l4v+L2fm9wY/vL8+HNlPwPcm+f8uS8UQKt8z9zgAsvg7iJ3vbcvM3XwmU7wCQb3djZj/jVOWhHlnZzdV8RsWSQTTyL/cPiNtIC8D7w9WmDV+4BjLB3QkHNavWznE9ORgha9sid26InuK4NJohraLUDgyRMq0kP8Pr1s7dhfSVEUStxXdN8FCA94A9Pd2CSlN/pu+1nt/lLqv357o5ZrklolN3fl16y5hp34ngEh+tJinHUpnlunz1osHXurMQXcqSnVavP3q2Vf9YLUPmV04nMc4myRgzhP8MWeRo9KIjMX2ScvDLzKD5QY1cVAkTtIfP1gErfeOPjCXnvimRVnzrSB3yRWAwZCmo4l+SubngUVshPv1MpbvLTrpNA7YXKuTYAuMMF4mWFpzR3bLKnQoeSLAPnx6dco7BRUN4Hpnzxw4kQnsGB4MAqUeHQedonkxLF+ly1Ihb/2r+DbVNxUAs1mU9ETB8W9hakEdG+UgLSiOa3uaNz6xVLCGi4Ufmd33IbGyLgjmgEBg0iqkc6M6NnY8PMQ50F8mTO7CiVDiEDlQwK71C48IVljPIjrM+QZQYTu/3KDV4EIkR9oQFpmKiPWhQjrUHScApXg+Fvpkl1kaV2QiU7wmKOQqslm1Qaz9vKbV4LUPZq2NP4Ac/TJxt/Mn+HOjg5Xi3wlom/wgKvGoqaoRpWMpGl36x4nlaVrapqfA1x6UbDa415QNU3eO8zrV
 WmUHA6hj
 r5vIXfAA164j4rxd8do2d7HTvn4xjt9wttWqXSLGC/4Js0jcNCks7OrAPgUwUWiQ8YWWnDHoLzkj9Kj9WpPqhem+hmaBdhogRDdaY8zZBBAdmnfjsOvosJTHDDEFy3PvunQdPiW7gIb1LEkWZpagMhxFT6UH2uHo4/qTy9Z5f5xn7szvd6715Vq3x6IorhApMwn4/Fn5igl/R8vS4yD1Dp6HDARXuRjRi5eAMCt9j8yrBCxmKoRdRY27vaqerrbiflWXQwXLKJONwV5iOW7Ii6+4eCE6aS4k9OKeFkjZgJAvXy8uVsFsm9pYM2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/rdma

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 

---
Mike Rapoport (Microsoft) (5):
      RDMA/umem: ib_umem_get(): use kmalloc() to allocate page array
      RDMA/mlx5: replace __get_free_page() with kmalloc()
      IB/mthca: mthca_reg_user_mr(): use kmalloc() to allocate addresses array
      IB/mthca: allocate mthca_array memory with kzalloc()
      IB/rdmavt: use kzalloc() to allocate QPN-map pages

 drivers/infiniband/core/umem.c                | 4 ++--
 drivers/infiniband/hw/mlx5/odp.c              | 5 +++--
 drivers/infiniband/hw/mthca/mthca_allocator.c | 6 +++---
 drivers/infiniband/hw/mthca/mthca_provider.c  | 4 ++--
 drivers/infiniband/sw/rdmavt/qp.c             | 8 ++++----
 5 files changed, 14 insertions(+), 13 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260610-b4-rdma-44625922fe16

Best regards,
--  
Sincerely yours,
Mike.


