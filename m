Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18FFF606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ad6JLZi/
Received: by kanga.kvack.org (Postfix)
	id 35D5B6B05B2; Mon, 16 Nov 2026 08:59:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30CE16B05B3; Mon, 16 Nov 2026 08:59:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FCE86B05B4; Mon, 16 Nov 2026 08:59:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E75CB6B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:59:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82FC8A877F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:59:42 +0000 (UTC)
X-FDA: 85441140204.22.024E573
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 820C0A0002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:59:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ad6JLZi/";
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794837580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0F/BYp4W2Rhn1Nomgj2rP/Jj1y5yUU++uEAdL1QZkk=;
	b=3IAtjJJOkv6lFVdu446/oiKqZ70euOKT4HI5RN7kUKCgcUviBPJxhyGIQEun6LNa5zl8iL
	fFmAlL9rOu3/MQXArziZBo5I5Ux+FdMGUJ4MX9c06ZyBihcm7/0J5VUGVKOGv+dCt+kjtb
	GMoB1vvCqa/9knWY18TB0PR6cq28Umg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ad6JLZi/";
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794837580;
	b=mquS6U+NlreeV0nJPvORlh3/lGk21v/jNsyPGeAlI5i3gDJP9vpcOjXg9WOlB5hxzM7lFA
	qm84Sjn8BCEc+T8ljJ8PVmpu2j3P0qx7W8/xD9KLsQ94lJUu6wgGjp7ILZAU5vErkxczi7
	SauIAS2tIMjGVLwspMiNgJjvCsoavto=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA41743980;
	Mon, 16 Nov 2026 13:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39D91F000C5;
	Mon, 16 Nov 2026 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794837579;
	bh=+0F/BYp4W2Rhn1Nomgj2rP/Jj1y5yUU++uEAdL1QZkk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ad6JLZi/9/bL58prXRETP/G6UDvQC51DcwZ9YedzBDHfRS8lIdTCzGoNmhiW2GQEw
	 /aSnNCr7xLeLGcwcuVHHKjHJJJ0gWuIagIky16dvjoensJg2yhfinHV8891lvckpwy
	 xS2uMM3xU+EEEFvngPxS3vjY4XpGkH9EK5Fp8D6Q8oHgaOzbWZ0qePIcaWFrkgtN/Y
	 vimEzAmjSDCG7us4M2PmVgBopDZkWwzY2QFSCP4Q8ZT09qyxyz+4qwSsHY97055bpb
	 Xqfi3jJ3tNEHdQBCupkqnbtFeqm0Hitdm6qb6/wGsxqgeAzNyErcrbDMsevZz/f8kY
	 txcLDTtijySvA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 39564198004A;
	Mon, 16 Nov 2026 08:59:30 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 16 Nov 2026 08:59:35 -0500
X-ME-Sender: <xms:QQz7aqj1qeMiPG-z-Dgb1cG-n7hCkX50jw3cTnX1khXuV-tvPJ7u3g>
    <xme:QQz7airZTcMK3nJvnmcrfLb8eDJIqIzjj_rdu3AkWA3TybTsQbroaSapMunU3ocP7
    v4p2BTTeaYv5_mOijVpsuNfRdo-viWHof7_n-FoMDNRr6dblbh_qTY3>
X-ME-Received: <xmr:QQz7apdBVAiNyAF_et2VScCAMJZA0xxSw6C2vOqEILECRiZShYaN2tlxNLY>
X-ME-Proxy-Cause: dmFkZTGw7Ek27OkttPtA0Uz12TIRY+fdCmOBGTdrDghB0eLcttPx19DupuImOjFBtxaU6o
    JpeXLrgoMfTu/lRKHCIbMj8TzWKHmfHCUY1G1XUscv97+KfE4ZgUv3URbsjMgtUtdZeyxZ
    SgpYcwu9pXmzrr5EJzFIwQG92uYZOBq7pK07CTnxZhIOY2LLT1RQ4TYNmjWVB5mI/QlLrd
    lgMB1n608lO6GGOFzonO3YCxKtuKcIqa2yW4weia5Qzv8gyUD2hS5o7CzQGTr7cuwDbUa0
    lJoWxHsuV1AHsxtoMgIcDdVvIbsfeBRmZr2ToyOJqhisBH0S/Tg40BJ9RANd8a+DCyuOEi
    hn098RuATgD8qEKVgtdPugOq0uT6bGPyrMOntKLKkq+ZkA01R44yfH+YH0c9YDbYmzrQIA
    Iopzse1Ct7eMKJwAWqXgcNivcm0iyHT2OhWNgV+VWC0Q82FfCdXJRs/ieaQi7IDVGGntxr
    2IHkGaGTAT12B8bkGtjQix6jaqugDGh3lm423/jNh60ZAHjmjuCDYvMBwXk5+ytJbrwnWB
    7dMtlkUuY/1t0syakAczXa7L80fTrhVuFAPUFWNIqdlWtI7V0N8u5qe93gMfQIbb2CGwXy
    M0D8RdnYRzDAUCTOKXcrl+5HZfFQvkzD95yUO5jtbnlC2gt1X6l6UfYs85/A
X-ME-Proxy: <xmx:QQz7atyEKDj06BUWZSenI9BcQjUGATvIgsIXq027hGWgFApDfXXGkg>
    <xmx:QQz7avTOcYMA16LqFIE-4PZjPp6l7Sfra25M7fhVcGDr_O5nYkk8sQ>
    <xmx:QQz7arlAtzq6xhRodDWJnvXKtlxZGt6D7-GsazYmLfD-SWfZxg7NNQ>
    <xmx:QQz7aqeKOk5ehpHc2ZTy-jLZG_fiZ1OP4vKyP4CZ9R_qovBM46JmsQ>
    <xmx:QQz7ajyqGivGQB206Ld8BHvW9UTez-MXUa_VwzqnnC6fvXEdvu6kRNI0>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 08:59:28 -0500 (EST)
Date: Mon, 16 Nov 2026 13:59:27 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/userfaultfd: prevent poison marker loss
Message-ID: <avsLuMTVBFfDwfsw@shutemov.name>
References: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
 <20261107-b4-uffd_marker_loss-v1-1-82926b22704c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261107-b4-uffd_marker_loss-v1-1-82926b22704c@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 820C0A0002
X-Rspam-User: 
X-Stat-Signature: wxswhkom38uaseg5zjishy1rx7n7yy7b
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794837580-83504
X-HE-Meta: U2FsdGVkX1/pHpdjw23V9OI3ODpI+ZNJKs8dogA4U6KM8stvM1c/YO/y7XpzFjDKNluP87hr9UOwWo/3/2MqzVCwp7+81x0SCBsRVd/q24VxCMYYHuHMeqYkI9Z6djIm7KZ1CyCbhzx/f3xCNdpmFKE9i9QctLRa5Wap2LGBqVffT7xU6EldULcfq9EdiykmFS7ni+l5tjmnc8t6sFTO3eJH92ifBB4qHBEmR8elbqGS5eVz0dDCtRzH4vLrWZicipUM9wbHUJRyM5B8kcQ8eApVNNbMgHk01KF/6lpwtR0ubEwM0FMOvEHejv27zlCWDmC5KZAxnoDCWCCJ3bAORIRSU6j2123jlOPvL1CnVvgUiCZPxp0nPRlUBj0ewabiEJ0kMY5nN345Zi5d0qvW1nttMnqRUNcOU1j30fYfF6QfJemt+xwZfNCl7i9Q8o5unjh/ts4KWccxapxRFsO1oKyKxS+kK+SUEBlAhewdWnZjrIeIaotM6nuxw7J/c1VoEL2ypTF+x/4j9dU+uvue6CtDZoScTT233Pofy8ANiTo9pe3+z9YPVlH8Q2e/UpzoPmY8JrFwPMryZdFNTONyDKViCC0Ezdfuv6Tiyn7a5cDl6jvl0wiBS2TDuCb1ElPQY+BWwAv++c83UY1tnNWeG13ydSGYbuhFDNS9t/TqW5u90yfixxON7VSfJK3vOZlIwLWZ1JlcaJQLWDJ3aPgi1KPGc0bu5w0DnBcdImcW0LGgsSU3+IHApa8gxuP/FK7q2MHs5Fw63+3iwyrslId+Q6VasXK64T9I0ZFNW4u/W4RYgb7rcp47S+aceeNQxxm3ETCtmUYYuecCg9drcHKtCt8sTl4OJ0Qcig814W78os/p34kvT2VJpkMWIsKsfCe7fSbwlB235cvo01bcLYJjhNcjIycBDWR763mhDEctYe7zptZ4dQg9esnm9vN8OA/xc4PioZzKklcReAHnnMM
 HpVUuuAq
 fcoS2lxOgSqNN5/ePY9M0RkGi0mdh15xiUe1QV7YVFFHGrTGU9+lEyvkJNg6fyrMVmKmrtLu+N5usTdMTmWCLdvdsWgYNC6Eq7JDtI0LzKuIUHdmoLAbYizCCiXAAe7RGedjHr0ybN+I8tWG2jlreLCStiFMhzaxwYsykFi2Rny6RLmSPpGqr441zxYa+XQAHdYaR6wVoG7cUeNS6sd1fLzutr9ZbskR/AOQPQooFrU2zvd833YhPYQ28T6UuajDKrVqUIKj/5c8Vzmn0Ek0wSdqnHKQRIuuuy1dX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 12:51:05AM +0100, David Hildenbrand (Arm) wrote:
> Unregistering userfaultfd leaves poison markers in the page tables.
> However, once unregistered, hugetlb PMD tables can be shared again.
> 
> Further, shmem page-table retraction can discard poison markers even
> while registered in missing mode, and fork() can skip copying page
> tables containing poison markers.
> 
> To fix it, add VM_MAYBE_UFFD_POISON and set it before installing poison
> markers. Preserve it across unregistration, splits, merges and fork(),
> just like we do with guard markers.
> 
> Use the new atomic VMA flag to disable PMD sharing and page-table
> retraction, and to force page-table copying during fork().
> 
> Move VM_UFFD_WP to bit 44 and make HAVE_ARCH_USERFAULTFD_WP depend on
> 64BIT, freeing bit 12 for the new flag on both 32-bit and 64-bit systems.
> Expose the flag as "up" in smaps.
> 
> Losing poison markers, while unpleasant, is not really fatal, and the
> use case is rather a niche thing. In addition, we rely on the atomic
> VMA flags infrastructure ... so let's not CC stable.
> 
> Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
> Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  Documentation/filesystems/proc.rst |  1 +
>  fs/proc/task_mmu.c                 |  3 +++
>  include/linux/mm.h                 | 45 ++++++++++++++++++++++++--------------
>  include/linux/userfaultfd_k.h      |  7 ++++--
>  include/trace/events/mmflags.h     |  9 +++++++-
>  mm/Kconfig                         |  1 +
>  mm/khugepaged.c                    |  9 ++++----
>  mm/userfaultfd.c                   |  3 +++
>  tools/testing/vma/include/dup.h    | 20 ++++++++++++-----
>  9 files changed, 70 insertions(+), 28 deletions(-)

Oh, that's a lot of boilerplate for what it worth...

Anyways,

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

