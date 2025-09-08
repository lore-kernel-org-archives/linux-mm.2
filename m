Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ACCDCA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 10:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8E28E0006; Mon,  8 Sep 2025 06:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0678E0001; Mon,  8 Sep 2025 06:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED698E0006; Mon,  8 Sep 2025 06:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E30E8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:35:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8B76C0AD7
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:35:04 +0000 (UTC)
X-FDA: 83865725328.30.9C608C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 645AF140008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:35:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=szeDtN1H;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757327703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nj/9PKodVE1YVERRmKb3nrlYWg0VbRWhzb/HqKXZFEk=;
	b=WktS23PK06ZlBOJ0yu3qCEtnkMr31re4kNyqp9/vdTxFcbd3STBbw1br0ado1I81EUTDA7
	yH8j3aIuOrCTXgWy4FxrFh0rjJBU994+g4pVNjcv/FFFI7Una/u5V1NRK1sRJWtQ3HviU1
	R6Rmdh76R2y5mnI+McDJBLWYv0mZvj4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=szeDtN1H;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757327703; a=rsa-sha256;
	cv=none;
	b=mH54ys6Wi55a9k7P7bSCnUMzhWZLEk7xkNbYVj4/nmW+Av+1LBfzn3/WijPvVIvdyQQE7+
	DrFkoFYyX+rqTt9XK0p6ZTNGJx6VD9YqcOfRRW3EeyK0Iuur61NWIxniF0zTD6QdSBdSE7
	/WeN1QiQCFp169a1OTNrtk7QzGpw8oY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9386601BD;
	Mon,  8 Sep 2025 10:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7473C4CEF1;
	Mon,  8 Sep 2025 10:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757327702;
	bh=ezzayDxZ/eh5ilJqIeWgMDYws3Vth7AuzHHdrl/M/sY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=szeDtN1Hy2mboR7182GvWrEih1Lqvgrh7pESUmR/yxOa4iGH7GLgRDPaODJaaE42E
	 Q+mUqvDPSjsg56jvX+7rgJ1+wuPyUugI4QU/jpJZlt8NSRls1xYbHigLf8KA27pGV+
	 LiE1RsPffr5SnYhj3RJQ8MfSiAYdO3wvehZpTQO0AoNc+ro1RudQcLbP8Uiik3qY4D
	 UEl+ngboJUpZcyvGg3dJ9kw0qNnqJsNzQejNlMtzWf9q2PGHr/0aoS2I29IdueHFZe
	 MpfEcwSK+HrwPgxcHuYeJBngcROm/G86N0o3yCi9jpH9ZwG3tQ8HANOL+ZWT3ymxVt
	 cEb+lKQGlJtxg==
Date: Mon, 8 Sep 2025 13:34:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] kho: add support for preserving vmalloc
 allocations
Message-ID: <aL6xUMlRFSYm41uS@kernel.org>
References: <20250907070022.2177974-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250907070022.2177974-1-rppt@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 645AF140008
X-Stat-Signature: bmuxk9p4kn7kwr1ieyw5opkdq6khk6zt
X-Rspam-User: 
X-HE-Tag: 1757327703-765619
X-HE-Meta: U2FsdGVkX1+2eI8QKbjjPf72j7vt671Bz6c9W+9j3l5jfhVR4hVntNuQYznZi/WZBKYyanx0PSupoO/FY/QsHoLYkc42ZY34xZb5hXeD7fUZcqyfAb0WtuXUqQQTtPN/Isr9eWj1wejlHoSAOp6bzdw9o631Fhf02xcqH6M3xkTOl1sTFmi+PidW44El2yTnivXNn5q+kc1nMLczFrI4HpxThKztI9vL0/JuNvfrxxYyE7bZ+pjgJVw16HiQQst8UjjyAQpxl8mf/RsJECvOqEldwKgTNz3NNiTXC+IePfdGu0flnM625X9MdpclhkCNtY3J1pOU3PmvguJUoeIEIeivXU9apPXtb+EGkmtqD4/BtHPHZLHQLX+t1hcbRhF3GivA/daejkcXTUVq5Mb9AoHz31v0qN9GJbrp6dK8EBZdhAVK5mNc1cXLNVteRMFdk5L12995z//CEpq+Xntr/IJpdUjSYMt5Ev7D7KV+FdWZU+7jZkvn0lr2KlxVmESSJjjLTATJSnUi1gNEZzbk0K1GMsEP8bZHqG8AOKHE62Mcr6STPD21GL5ZMySRfE37wD1jYeepkuGTy+a9waht6gevNiq+isGyJacSOk3euFH+ClZbmLJdjXsE9ey4kuRJC3WGAOvHU+KgUcIij2lwpmltQO7MyJtIhofBYlELgd2jdz84w2YOCNOOnhyy5kupkDQ96Lsj9Hl0MCSG452FVnKpAgsvn7BoEXS53kavbS4Qg05DdYIl/GH+ljY6+eBkvKi+nJnSS4/8vV9xEcn868lGE4VJrq5R2ROP2d4uJqZkEBBfgyxRpo1lWIf4bqhHZs+8BP9sufeZpneZ03MH2eJv8NBl9rqGiYdvhyilZSoBzXrapKEhEiaD4F/1Yfa38lz5OX0JjebrSp8rYeicqViwlH8zcRn9lCh8bIX6glHeNsxwZ3ngcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Argh, I've messed up the posting :(
Sorry for the noise.

On Sun, Sep 07, 2025 at 10:00:17AM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> Following the discussion about preservation of memfd with LUO [1] these
> patches add support for preserving vmalloc allocations.
> 
> Any KHO uses case presumes that there's a data structure that lists
> physical addresses of preserved folios (and potentially some additional
> metadata). Allowing vmalloc preservations with KHO allows scalable
> preservation of such data structures.
> 
> For instance, instead of allocating array describing preserved folios in
> the fdt, memfd preservation can use vmalloc:
> 
>         preserved_folios = vmalloc_array(nr_folios, sizeof(*preserved_folios));
>         memfd_luo_preserve_folios(preserved_folios, folios, nr_folios);
>         kho_preserve_vmalloc(preserved_folios, &folios_info);
> 
> [1] https://lore.kernel.org/all/20250807014442.3829950-30-pasha.tatashin@soleen.com
> 
> v2 changes:
> * support preservation of vmalloc backed by large pages
> * add check for supported vmalloc flags and preserve the flags to be
>   able to identify incompatible preservations
> * don't use kho_preserve_phys()
> * add kernel-doc
> 
> v1: https://lore.kernel.org/all/20250903063018.3346652-1-rppt@kernel.org
> 
> Mike Rapoport (Microsoft) (2):
>   kho: add support for preserving vmalloc allocations
>   lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt
> 
>  include/linux/kexec_handover.h |  12 ++
>  kernel/kexec_handover.c        | 200 +++++++++++++++++++++++++++++++++
>  lib/test_kho.c                 |  30 +++--
>  3 files changed, 235 insertions(+), 7 deletions(-)
> 
> 
> base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

