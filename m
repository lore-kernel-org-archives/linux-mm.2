Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1656AEEF319
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 08:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817F66B0089; Thu,  5 Mar 2026 03:31:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2066B008A; Thu,  5 Mar 2026 03:31:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DAE76B008C; Thu,  5 Mar 2026 03:31:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60E496B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:31:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E2B814068F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:31:29 +0000 (UTC)
X-FDA: 84511340298.27.0B16DB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C35D5160003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:31:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SJ/n9xhp";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772699487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rg1thqHcTb/wkz3LGHwEivjhFrIIo1MhcsRlV3+q0QI=;
	b=J0WaS06KgoYGFLOXzf9YZWy9SiKlhW7PxL6H81qG0X5oVt9IBCPrCl37bLFXm40ogokoRB
	intMCKC3HQL4igz9xO3pKu/PgtLSU8tSTHomzZVDBhnvL1Jmng+Dms6SHhUvf/caetCH/K
	xH/sGKcPwsF7ORoU1QECs1qOSLMszhc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SJ/n9xhp";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772699487; a=rsa-sha256;
	cv=none;
	b=ScP1HPcA1p9/RKZlnSelPA37Egf1sJ8SbgU0ZeY9l1PSEJuTWpEQsQ+sI0ydHTbpRbYwzi
	q1Tz8YSmmV/tF19w92Ca7uzlMbxNGXy8316YAXdM/P3k8L7F1XMumPISvTjhC5aBOD+6vX
	r2Fx9Pf+LSoRprRxhbQw53wMJ4ohdWw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BF9344483;
	Thu,  5 Mar 2026 08:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B04EC116C6;
	Thu,  5 Mar 2026 08:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772699486;
	bh=kvHVs4NskjZVXPDgFweRxutw5zxiegP9xPjKv71JlSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SJ/n9xhpsuSF9gMIaGks6obwLslM79XBc3nZ6X6jbX5k3cm52Jx6hHyBTc1wc1bgL
	 sj8JGcQMSVx1p4hozy/2ttQyjdubqX2YJ3HP75PdA/p6qnzXB5RGi+hMiw72pq7yEC
	 gj0c4VrE5lR8V4KDbGcm61c5PCw0mKRYy97WKoJvBs4hwXkLC4eroWHULph1rXbOkZ
	 N1Y67Du94msqmiKsFiOcPs0jJfLDPcBGFu4pmbXJuhqFhoJBx03ihqXUa0R/Wy8UST
	 X/3uyxeeZ1yGmuxbgwL9RXRRIcXWtj2wWBTWE/AHjkhU4oSW0Z0fHHOXIpZ0Tof/Wq
	 w/RMgwaOVR/0w==
Date: Thu, 5 Mar 2026 10:31:19 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add mm-related procfs files to MM sections
Message-ID: <aak_V32C4BnJ1i-b@kernel.org>
References: <20260305-maintainers-proc-v1-1-d6d09b3db3b6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305-maintainers-proc-v1-1-d6d09b3db3b6@kernel.org>
X-Rspamd-Queue-Id: C35D5160003
X-Stat-Signature: sitk98y5eord5bqezz5eyo49gum1bzea
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772699487-527521
X-HE-Meta: U2FsdGVkX19TB90AwlwH5TD/zSlHGhJWqiVbCNxnn6KNTeeN5hSiVhS9E5gOS+rWXtIQiI3e4XrnmCB+KD16TVfhEyS66o8NjPFDPP2YWUPAAq6ij0oCHqSm96jmI2UTee0i8tQEjwnHL5wIY5a/PUhbkN1NQmUN1eHROhbG9IOY8tfIZxt3jUqt2gc0xraCu9unMxhXc/05MSu5ZTUdWiX3mGYTRpHY7iLlQTH/exjNXZ0e9Dq/tLdbKFmKuyu+QxTcYv21pTXZoM1j8w/z7UwnO4K0zeKkVSLesCH3ej3cAmRq8xvXF6CsFr3f6U9eALnY3WTZhyid3JyImkDhOBX8kFozluIAs5fNP7JUjyxLqREk9smo3iefrIPePzBGH7JTUbjzSAVP7yemPj6uP/IZu8I9w1v2WaJr+ySVB5YjNe9tVpebpgihqKvS+1MbBot8HkiwAllfrb/vaULVnOI4OuDqXwg40PpK5wZIrDUISdhlJNT3U4+/8E8catdqp3AsaaAMnxwFNCbeZ/MT7d+E6vJy1nj0vu29s5soIgbrQRqIzxF3929yv+WxfD+IpugK/BNdYhtVSrSADDKOPNYWEmhKkrhNNda9pwYfqSatu353aWUJUCg81yEcIY9pZeYG/EpkHOR2B9PvfytNrlX5xnyB2UglVGTvz6y2um40lNfQa6PVFrO06o1hgWZ59OdLfaegJgYAuWKq8wwAuhnNxotavVaI3aRDUdXFvZu84vGFujzTBUokSKAJ72ruzaNCLKutNRG5fZAY+OyuUJzr/KEPpgXRJNnsyHHwdpinjjrTYAdLfcvctS9nbUClCldaJOHQg2qNNuE4+lfrgn5ClBmZyWkU0WUmaLf1fp9R+5Q8uOAZSrZLYVx2JUqTx47Eef1g2SySgRykNpjh0saBYGziNHs9OlLOI82Ov9wjHnUn/QPf8gcjnyZ7TR5lKKjSeHwxtdtJ8hw2hBq
 lRPAxj8H
 3pYTZ2BcHG1ygassF5ocU/CXoA6EiOq7vaMEFs8IJl5cC2o0lcTH4bP8NYi3/E9gpTLpzEiqSQTwjuyP6lI65caxNX0gMB4hV9X6l7oyaC5AuHfhfAtxwKvIb6IIWIZYMoro3MCoMtQtkK4FXA0AGOrOcPQArmVIwK0IJfOTeLL6MZeA/hSRbLRUMaY+9fwG7+SoDCqkVwCICr+UINUDsVatqFoCrhGmnL5kXy8Uxk8nl1QY+URSgTbg7M7eW5x48I5GMJziUTIjCwPuAWqRBAr0jMm3Oq6pBIzDU1z5bIgw3xkvYlvg1WQItB8RkNzSFRupPOpMS1f523XW2oJ4XFKvnaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 09:26:29AM +0100, Vlastimil Babka (SUSE) wrote:
> Some procfs files are very much related to memory management so let's
> have MAINTAINERS reflect that.
> 
> Add fs/proc/meminfo.c to MEMORY MANAGEMENT - CORE.
> 
> Add fs/proc/task_[no]mmu.c to MEMORY MAPPING.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  MAINTAINERS | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3553554019e8..39987895bcfc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16683,6 +16683,7 @@ F:	include/linux/ptdump.h
>  F:	include/linux/vmpressure.h
>  F:	include/linux/vmstat.h
>  F:	include/trace/events/zone_lock.h
> +F:	fs/proc/meminfo.c
>  F:	kernel/fork.c
>  F:	mm/Kconfig
>  F:	mm/debug.c
> @@ -16998,6 +16999,8 @@ S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	include/trace/events/mmap.h
> +F:	fs/proc/task_mmu.c
> +F:	fs/proc/task_nommu.c
>  F:	mm/interval_tree.c
>  F:	mm/mincore.c
>  F:	mm/mlock.c
> 
> ---
> base-commit: 7fcd8889fbf318409163ff5033fe161dd2a73243
> change-id: 20260305-maintainers-proc-30e45ca9e434
> 
> Best regards,
> -- 
> Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 

-- 
Sincerely yours,
Mike.

