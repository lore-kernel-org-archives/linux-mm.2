Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63EE010ED659
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 11:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBF906B0096; Fri, 27 Mar 2026 07:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70CC6B0098; Fri, 27 Mar 2026 07:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F426B0099; Fri, 27 Mar 2026 07:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 90A536B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:45:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28CBA8DA30
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:45:27 +0000 (UTC)
X-FDA: 84591662694.27.A6E1DFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7D3A7180002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:45:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gEcinbef;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774611925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vb41wdGmkNix1r3BXrSRNVMhBYWcSkMZcmMiU7Ic32s=;
	b=WDyuzng/N6+qGw9Wilqtr4Tshxh54fL7cqmTHPYManlXHQOdsImTQCmYGVv31cMQ5w3lSE
	4gw5h3N43nAnWNGqrOvdfwDQgq54Cg4WGpUP5QQXjyvjqCbssl9bdK6cESj2BYTyLICLA/
	OqpHVSqB9tsZIvpEa2Qq9J83NhGDNeg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774611925; a=rsa-sha256;
	cv=none;
	b=3Rgv0cQqE4nkCos8nZyIZCRoYtFKbfIVjsQyD7cct+P+yczAbsi+rsIFV3WIYirKTZfybx
	kX+/bSwJR29rvlWQmk9Is8MIOt7JcQTyn5lAtDhFbbL/DpSSiMwBhdWFrrNpiQDG3tZ+Rc
	EZ5qMZBhlZ2KlnBQjIvXY+NJSFV3TMU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gEcinbef;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77164416B3;
	Fri, 27 Mar 2026 11:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E39C19423;
	Fri, 27 Mar 2026 11:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611924;
	bh=CMDDACTrdygYzTYvrKSSaSH6FKG2wjukDIQD9gkXUzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gEcinbefxRX5JaurQEZogXVJ8MYHd9x9g2Qve1IojhXhrFbxIJe1GNNSRQGRLrDyQ
	 HEAAWE4DjW5jAKM0ZkuWMnfyKZ4tcjUt1AOOCFPW7uv3rY4NFXkOg7Y/ZZAt9VzQV4
	 Hsv3t4eWLjOxEf9Vziukg+r1vvXfrvtAHeQGC8tQ1q6+KBgbyGwO5FoT5NiVLypqbB
	 zJLXflzrd5LqHvrrGoNfpmOeTB9ovOJh5U65lKVjVcq6zYhzZAvF0gjudpCPfgSAW+
	 dTk3/4HUrSzPU/viVOP7DgR5VgFU0+jIa1UBTZDum22TxChy831iPE3403iyeduQuh
	 zTb9UP3l2jFcA==
Date: Fri, 27 Mar 2026 11:45:22 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 01/10] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Message-ID: <21b4c6cb-567c-4a70-b311-fbe782ad18c1@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-2-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-2-ziy@nvidia.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: wrjqpiyth3tgckxu1b9kibzjk1siryha
X-Rspamd-Queue-Id: 7D3A7180002
X-Rspam-User: 
X-HE-Tag: 1774611925-581033
X-HE-Meta: U2FsdGVkX1+/nm8ldQWvGw75LOv7FCgRPBgevjRWrJQjCVxcuhZDawK3dtO1K/GDcKxk4uohzbH/uHuDhmwdoUjC6qvXAwxDcifd4T2vUn7kN+V4WiLQQr1YG6kruOo/+rlGSDdQe0lCQKyCcsnrQMwfK0+4jlyOMaoo/QrkzqOAydl7cWr8Ykwh+39kakrIxA7h5WUre2e4/BmnfV614ZpHFdzOTrlYotnzj22daJp9gxbUpV2STng5tI7ZkAaXMePGaVIk2LZXgl46d5eUyYWWTwTz+AsUMtH8SYR0yA0B7MuvBbF4sOtzkTt5hGDZL2BPmWn7+EYFgpuGFlR+bBkGIbyO6+r7Sp+ytXc5ydwmYjBOPsG7nXQ3/u5EdMKsadaU5Ka8GUwbY+xO/pQKNJexgRrdwJ6DWansFxRCRZTYXc/50NwpQLRghJq2XT3fmhGT904vVokpVuBVyXIehtO4ByPrdIJpGu+NuzNHsY85ZQGqAq/JKt6fgiC/MqxRA6DDlcHI3tJJaUFmzSykErRG04JbVsyNqH8B9/Elv0J0AX0UTakxHOZ+66PSQtYlkf73l5s6YS5TDepObnFJDc/9qgtlGYfF+wXwcCGessIWaBC2laUuJPqievEB/1aiBWQCCXHFsnA6omCY1wPfNydQhaCm/JHK84Y4NFpLjFcTbeqU8PIHR76llgyMzcH6W2nhpGPUduQk39tMM9z2hYGXFk0BONjo9g1C7hyFUSJAsdAcXqU9yOIsc6dUpK2pw9ByCj9orlTIXoA1evtysDy9r2rU0BPsKxHzBM7ZJMvC0+t6OAU7oy9dl5ozvT1Yk6X/IAYbEj5zb4Bbv6FMlyDDmQOQxzAAQhrIuR/bTH7hhE/Ynya6dwBSKNRLpexoCjkRxZb4m3XydlHvb4t13M0yWeGTv8tDhxzU7JJIJzLApvKTG5tK1oYPeX7GwsCFcyAwL6e5CK01gz2KaPz
 QEFjQ/SY
 feLxQ5uJMcU3au6ZPQSROma8aH0QQ14Q1icRvM2YyNfaK5qbByAhDGzaJRU1PwGGl7A7xucTemW3kwwcyvBvyxPFCutqhZpZBOe9qVCu9jBpK2phdNraERr4X95qnhd7NJR/E2AXeu2T8jGiWU9gvVZG0nN/5dJ7tdacOJBG2istwxj9VMY2YuZQtqJ4DhGjxKKnYCMcBBMT1acz8jl+klUK6cGxSAQWv7V/uDz1t+fgvHk+/RohMYI7oZMGxElZq+9/UmAK971P6VJ5RdBE/8CUZX5yo7UWUE4HskAtwP+DlA8X+3y1YPA18YQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:42:46PM -0400, Zi Yan wrote:
> No one will be able to use it, so the related code can be removed in the
> coming commits.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Seems a reasonable ordering, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/Kconfig | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index bd283958d675..408fc7b82233 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -937,17 +937,6 @@ config THP_SWAP
>
>  	  For selection by architectures with reasonable THP sizes.
>
> -config READ_ONLY_THP_FOR_FS
> -	bool "Read-only THP for filesystems (EXPERIMENTAL)"
> -	depends on TRANSPARENT_HUGEPAGE
> -
> -	help
> -	  Allow khugepaged to put read-only file-backed pages in THP.
> -
> -	  This is marked experimental because it is a new feature. Write
> -	  support of file THPs will be developed in the next few release
> -	  cycles.
> -
>  config NO_PAGE_MAPCOUNT
>  	bool "No per-page mapcount (EXPERIMENTAL)"
>  	help
> --
> 2.43.0
>

