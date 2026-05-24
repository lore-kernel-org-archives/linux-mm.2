Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2415DCD5BB1
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 17:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84DB56B0096; Sun, 24 May 2026 13:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE6B6B0098; Sun, 24 May 2026 13:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713DE6B0099; Sun, 24 May 2026 13:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 625156B0096
	for <linux-mm@kvack.org>; Sun, 24 May 2026 13:06:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0FC4161E1A
	for <linux-mm@kvack.org>; Sun, 24 May 2026 17:06:14 +0000 (UTC)
X-FDA: 84802941468.10.EFB787F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3FC2340004
	for <linux-mm@kvack.org>; Sun, 24 May 2026 17:06:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GD2Kmf73;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779642373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qU4t4qBcOzzk8o3HwKSTC0+TUYXIkGUhAgHkLXhocWU=;
	b=aHTYAaLNuT3dI6sJ9SRhd8D2x+d9o6kw4Hx1wuBfAGbMcXccOqLVcpxkn10P6py97BCUF9
	opLhzVaLowLXxgZnY8vNshkOzI9+A3L6fIyQcUhlQEsqXo94i61XdKH8U2UmqxL95N3D3t
	kmxCZGDbKUaNgAN6ndbEVFYBmwhaQes=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GD2Kmf73;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779642373; a=rsa-sha256;
	cv=none;
	b=vwioQTtgz51zNNTaFcAD9RpMtQe7g7Cmf6F6x9X3PCHNK9LM6J9Q4e3Mrj+lu09RKKiQoU
	QXfz8j7Shm5XAUAoqZLLboJpvEGIKqfOmSAq2lGU0j+oAgGjMnKXceo92f2P6tUbqIXYqQ
	GOmkoO0Hd7dlHSomN8dV2ALLZXmCzwI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 313004402E;
	Sun, 24 May 2026 17:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5041F000E9;
	Sun, 24 May 2026 17:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779642372;
	bh=qU4t4qBcOzzk8o3HwKSTC0+TUYXIkGUhAgHkLXhocWU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=GD2Kmf73ddPngym8JXZudPiNGdT0w+XfmVkjxpuvoeV7yOiSPKX/m5CaRRkhY7VEA
	 EUDy+QaCb6S1bSbrt0KR6NQem3WxDjudcFXcepSLPaniwofdCfpf6CYemegdWVeCEv
	 tdI4AswhXCjW0ilWKnVBsEMTbCfPrE7+wcmoEhkOJKv8Eu05OVsdJinoIaGVasg0H+
	 KAw1/OcSi3QWWv332PrkmsxxFUNNRL/87NqSrPVyPj8471YSnFSPh7h01YDHyq6kF/
	 apnDrwHd+tS8LgZU9Knkb5s/dcUUi05JQwb18XfK0hEmjuuzmRYUhPPF5ZLd+vnRrX
	 ksFoBSll6Y4nA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/4] tools/lib/mm: add shared file helpers
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Mark Brown <broonie@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <20260521111801.173019-2-sarthak.sharma@arm.com>
References: <20260521111801.173019-1-sarthak.sharma@arm.com>
 <20260521111801.173019-2-sarthak.sharma@arm.com>
Date: Sun, 24 May 2026 20:06:02 +0300
Message-Id: <177964236205.4000040.3083558454897469696.b4-review@b4>
X-Mailer: b4 0.15.2
X-Stat-Signature: 1wkj7be8eih4aehrznnwnhyquj7o8yiw
X-Rspamd-Queue-Id: 3FC2340004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779642373-44826
X-HE-Meta: U2FsdGVkX19rHJiix9wsYE4GJdUCwEwlt9/LyN2htAh87ublG+NR8D6nOy5HYE5AvgxjAr53vzoNPHV6VYlGy5QSixYe32VfG/LlBPzhqHx/hQNYAj61+E8VDgKsV0IgsY4HmstjOOAn/u8SMeWPK4chPTYZhPEqoB+zHIz3iYQ5630EzrIjqwYWwL27J9o+dyQ3XIvu50NqV5USX5DQ0kXFl+rSCoSxhtI5v6AG7zK30+Ugy16BM6pfwqXnHSxz7evPC4isznMSJ/uGLc2DYahUtRRsZmqtQaP41jGSF1ZzCA2WMGWiOBvF6vllXQ+yh3fwrESq3LJtrRldudsY7BV1/mrl1Eb6yYKjKalIu46UEPKTbvSo7JNmkCXmXUif9cYjT+RwbG0KftYmYOp4PEir01XvexwMYqefcPM00YKZQuov95xG8rR2ntBWtR7I5LNtBez20AxSHFakEnHmjfU5VkBlxmneH+7c+DhSP+9xFYNyo3/gdaqGT4SSfBG5sOfNzTBr/BzaPIpWN5otIhSyZ3uv/cgik9G6WiIo22QriC9iGSA8hmbmtQ2sfG9+bbZ0zC5YUoZUJw99YkY/zOuXIiJ5wU6GnVuNxj3Q7ejevlyKVyIEokO+yxXMU6gIW9Sa66HfvedK8X3c86lRyMhi2lhqqXiXUK+2XXOxX3l2nq037cpxwhqgDJSJR0HbvpSPokMTN0179TMmkV9FVEvfkvYkwTW3df/1gJAx2g3tz+VL/l8mAqSP2uopkQZpF7665UM0lYrxrmlMGtpnKIj9VcC+ioVbojyamJJRXPiaH2aqi1nMNKcHGa+e4jrzcYdppKWE8rNm7WWEsT60pWwFVXPw/YONQgpqcHDphSxwWg4pf9mE/rYY+PANnyKm3Bqm9jqAX8ciR5cxNCCj0OuhiwVyzgvQBcGUipzImsRPjMGJhsJIEdCorWjDgVmmfb8angtokNPcgFo+tXQ
 3K6VmrnT
 GhCkYf+huyYZKEt/srrIxAaLHyUKJmCCb3Nt5HTgNSk9DZpF6QypcMffHrN3+ZP91IY/BGgf6lYiSex4Gv44CHo9/hp2VsdX1f5MGl5ZraxeuTO+mGMwj/+bpL9dLuMkvzZHNpJJ7yBCvCPGIdl/UumxsnXNi8azagXc8sr3nGUrwmz5CrM2nRPEzjPermMf5p/4Wdj98iqeL154x1+G9g0zoChOtt97kG7CIBH5Ei1gAJcLtJ7OUieBUgC5vYmEBiSPwLAxklSSH0HRuAWtk+fb6ttRQOikQz9lhFU8QXLVvUUF/0YLNuyNg7Am2m6RefY4c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 16:47:58 +0530, Sarthak Sharma <sarthak.sharma@arm.com> wrote:

Hi Sarthak,

>
> diff --git a/tools/lib/mm/file_utils.c b/tools/lib/mm/file_utils.c
> new file mode 100644
> index 000000000000..0f9322f2cf41
> --- /dev/null
> +++ b/tools/lib/mm/file_utils.c
> @@ -0,0 +1,83 @@
> [ ... skip 48 lines ... ]
> +	saved_errno = errno;
> +	close(fd);
> +	errno = saved_errno;
> +	if (numwritten < 0) {
> +		fprintf(stderr, "%s write(%.*s) failed: %s\n",
> +			path, (int)(buflen - 1), buf, strerror(errno));

This would break TAP formatting for selftests.

> +		exit(EXIT_FAILURE);

and while EXIT_FAILURE == KSFT_FAIL I'm not sure it's robust enough.

>
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index 2eab2110ac6a..5e947abb7425 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -8,8 +8,9 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <unistd.h>
> +#include <mm/file_utils.h>
>  
> -#include "vm_util.h"

I think it would be fine to include file_utils.h in vm_utils.h and avoid
further churn.

-- 
Sincerely yours,
Mike.


