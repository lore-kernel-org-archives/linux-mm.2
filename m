Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D05A6CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5E926B008A; Tue, 29 Sep 2026 04:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0F506B008C; Tue, 29 Sep 2026 04:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4BAF6B0093; Tue, 29 Sep 2026 04:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3F6D6B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:29:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3DE5340448
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:29:39 +0000 (UTC)
X-FDA: 85266126078.14.6D1FAD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A50B7100003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:29:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F4Ec+mUu;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790670577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvYs8oTTLWW30Z0Y3Id5dc1cjq+MB+XC02/n2Rslonc=;
	b=nczkHdyy/T2Wh21KiOlWG9mtfKX9UnWjMA5vcFVyRQBmITNlJLuhersfzHu1oONs+Fbl8/
	2ouu9ehv7hOGD45hCRkvUMIXO5pNohQFikL/6pzs30a7Tax1iN3wNpPbwgv5Av1L70p6yQ
	8fE8nV7kKSLVrmMTMJwt4Qc3YXieCaw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F4Ec+mUu;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790670577;
	b=Oo0xThSEhvvVR+WRL+QsGZecvkQ4e1a1d28s5+l1nGTY2xgagB7xAoNyhf2UUQ7P+9HVC+
	m4LsSf5dVzarHh9Qe3oHruvzZQJUJtmP7AHOHY5JbxA7s9jD+LXRVg5gzGKdA4uWnPu+Sm
	ZoGw8zc3ejE3/JQ6prlbu7Kc6PvVwc8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1633260A59;
	Tue, 29 Sep 2026 08:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EED61F000FF;
	Tue, 29 Sep 2026 08:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790670576;
	bh=SvYs8oTTLWW30Z0Y3Id5dc1cjq+MB+XC02/n2Rslonc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F4Ec+mUuo6iSWS/a0bAmilxDGLqrNdoBVhLiAsG3fhr3cnyvAYAVsgsy+OEso/Y2c
	 HecQdvqIl+OFkZ+V2NG04p9XlOoKsVba8tehPWO4+IxNAPnlcCOrXio4on1Fv9jJwU
	 UoIEQsGTvndst4632zx3z5vux1mj/MihB8mVGvUzzz5Lw6+wQiIIawM38OFLtOqy24
	 OdACzt4BCLi700IPhZvFOVHM5L8xhGFgKJmhVraaYazdN7ltNsQKMklIcR/LsrBshu
	 7B8lshGy80lC4jWykyXRtZvxcrAuFQP//zwRSVeFpHEg5pUCn+kBqzOA1lIrS73VCY
	 l7oRVr4zjCx0w==
Date: Tue, 29 Sep 2026 09:29:28 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 0/6] mm: make MAP_PRIVATE-/dev/zero mappings truly
 anonymous
Message-ID: <art2jydFy43SQB14@gremlin>
References: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
 <20260928163957.832a27ee9596a25a282c2707@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928163957.832a27ee9596a25a282c2707@linux-foundation.org>
X-Stat-Signature: uo8od93c3c8gxzee3ttuaubixug3xeuk
X-Rspamd-Queue-Id: A50B7100003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790670577-403610
X-HE-Meta: U2FsdGVkX19y8aVE4ZEwccgWFSx6sGecHU1+Dpbv8A91ElZa1IZCKW28T9Rm8Fcjvc2q2kXJlycNKDhTB2fFwWYdPmhERs9qI1XCcbvmKNIGV6b5oR1NbgjAdLJIjAs6pI482RnQFmIl9pTPoDtGXw+vxsoM5t5tmTpoJyq7B9WfP2T0+gbxWObD6mLBa3ISrG4G4TeKgk0sJAJwOGY8iAqvPGa0QqIbLB2ogIXnr7kunUldWmoidO/sYcF9JWQwpoUbzktra5EW2WxUNDGSFN+Z+sRyOXiftG0a68ldJ08AQQ7S0uiQyvaxrXt8qrQBDNBsl6sRDUFhCjaKYtdkuzRcTrKxZuHxw0loIIJPlCdFs5tLYZ7RpdJw6dz/+0NXE/MrASq2zZIjEUkftRQnIyZzghYZpRsjEo8+4/+llJ0Kw2AfLNL3ZijEWUFxnk8CVFUz+aJC0/gTcBU3SR8gryR4sqYbbh+s4j9SiovXsO1vfEiGqDrlgSO1ayO830o6wM3DxR9GY+HRxPts5kq+n3qoNk9PPCsDMlI0RrEkIGgV6NXxOQSrRAYVMRzMa6RZ9xnsUtqTMZpeQFv+GdJccRSXSTzxKHThOHQMt34/z1iYTZW6rxTCyOlEgpt5o6PV/7mEcn7kietHrnEpE9V8gCEqEVy95c3BbK0SooimcaYfkiUYbzHu3GuKNQvPmCKF4nPm6JvlY8lB3mbWUkterP5eFYBNLa3oMBB8PJdCZtk3O2y+lPod5fXXUOmRaeVGdXia63j3/eQXDJ0NBHnVwaZSNkYQP9uuFGAQmCCraQXLl+eEuav5wRBIAntuiJhTsmcnZQx5cW+V4avpuDktNj1yIXDg1sJYt7O3FAUxmE6TJXEwx9Da/9vdyoAcThrZG1/ISSV7EJiiNYT/LD4OjBlig6VLjcuMbJDpDdJow7kvigg/A0l0L9bC2nz1oR4OT2SA+rSOJnUPuqFBx0p
 uA0z+SBN
 JRAk6J1MJHxclRN/S5Vm3AQggibVPQrARfn2476SgwzYLzXRK2HNk/B51yzfkBXWk3fH/g8uAuI4oCGgbciC9xCoVmV+DNHEsCQSTEEvaB6UBpFNJH29V+hp8J7qY8e47ii4BNFlAyCympGt6h61GZQ3G4qOmvtctTigN6I0UBHbnjqP7xCTfNQjQwWGcBAME8QMOVyrf+Ak8zMSfJEF/yhBWj61FNphX3cEly9wFKOOpqfP3Mk32K8pTn82ryP8IYGD2qzxhEl+JOmLe3N7F8eQe6nZ/tR5Up6fncamklbg4zqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 04:39:57PM -0700, Andrew Morton wrote:
> And...  really?  I already had David's tags so we did a full resend for
> a single comment typo?  Little -fixes had their role...

You kinda asked me for one ;) unless I misunderstood what you said!

In any case, yes this is very much stabilised!

--
Cheers, Lorenzo

