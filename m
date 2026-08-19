Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20ED9C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 15:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117896B0098; Wed, 19 Aug 2026 11:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7D16B009B; Wed, 19 Aug 2026 11:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F201C6B009D; Wed, 19 Aug 2026 11:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4DE56B0098
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:31:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DEF440267
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:31:52 +0000 (UTC)
X-FDA: 85118409264.25.5ACDA71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id D58AE14000C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:31:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Jkcns8g/";
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787153510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNlUnXINYq5kyrdEJYlrkOnp8RTE330uTqk5CA+kSvE=;
	b=blPFLLt6lhicGa3Kir5R+ck1B/ZvD9Dr7iNetOmGP7X0N8uEle1gskuLZ9LUCQtIYYRyk7
	lF/7kfxVIfX03lNZD2W9n+F8Nq1KfbASIajtLdNznkgfcAtjHlH+6F7ShVEqMNRQOE+meP
	3thvSerGvWIOk6SEt601qExumxjfzjc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Jkcns8g/";
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787153510;
	b=OP8z8p9JlW9PzQ6NbtM7stbSAOh1AYloZ8JQ2fZGPFPx9eZeghMVzyqyY8Pcl7/WtqABy2
	x1xKV5UbYoQ7zpg4oOG5bM1aCK5YEZsD1FTcBam9dfSruHoICblKhCfvlL0BgFoOXi5/N7
	M1gpWDe6udykF4R3v/sVXt/Cw1FM+6k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3653C61133;
	Wed, 19 Aug 2026 15:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E541F000E9;
	Wed, 19 Aug 2026 15:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787153509;
	bh=HNlUnXINYq5kyrdEJYlrkOnp8RTE330uTqk5CA+kSvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jkcns8g/CqHuuJ3e5laquiSCvIOOIy+m041E7EkMg90+rlBhgEDd3Z/s4QeUNPWGU
	 7lKnx7K2jrhCBgOZTFo3FHwZ82OOI4FYvbhCNu8cJybJwXoo7h6gMJk7pI0vKMnbZH
	 nBsYEyZdWNN1/kxjM16IIauToDeO9M72b2ZaMWYaVoAO/VRA6Y1WUZNMJ7w7C9XKHO
	 33sKDuQLjJYCKTVE3zHOoF5Ht8GvDvDyrR0bZ9giWwLCrS7m94JfDs7L86sLniX3gP
	 qDYrAf3b4sa/Mjmoocew7xhG2ldtx7a80soTfgrEaTk6b83dL1g5gbdpuEQazIg3vs
	 sCO5/j3DOMsQw==
Date: Wed, 19 Aug 2026 16:31:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mm: include swap.h in swapops.h
Message-ID: <aoXKm5MlBqy5CTpp@gremlin>
References: <20260818115026.656406-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818115026.656406-1-kirill@shutemov.name>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D58AE14000C
X-Stat-Signature: 87gpoigj8obebxuytfs4w5mwojia7wmu
X-Rspam-User: 
X-HE-Tag: 1787153510-236298
X-HE-Meta: U2FsdGVkX1+24s0MHFRSFgPsRS1KT8xU0yyufO6772bb5j+ENNasSj/0NmmbGBsxnU137k7RyeGlkkHOxtNWXEDo0P8d8qsnoRSwNuYbxS7bfmZujjji81n3/Fbqg1oiWUwYoEKuAogR+fvtbE9P5asWy6eBBHpPL7I4UM30+zxoXOrfY8Xy95iVNzK1oI0LV7Vjxycg+GkgD4NT3+oiXgI8r9VsCZq+F+VH8W7HWrOeAtyPx1gmYtaGNs8J50PYX67F0t5/ChIpPtOLJjFrnG9vWCmgMfGCEqeigqfpfWNyJZOUqLAKMXma5FLlgKPZ3YdxjjjU0p4HbituNaPIeRPVXJZUkIiXpzlA+zuEeiPJJEbqZYAH4D4JY/HJ4w0WmnlFlXTHufom1zoNsyT0powIeAR5GpkQt2W6ybrlfjnl9V8NfBLZhGI72S/Nwixa7gqJkywtNS1C+ypQI9xUhxWdebgO3JhOK7YRIBsbJxnosTWn4QxGShL3n4QZZxK2M3nhQJr1dlS7vPM2CQU2W/0oKQC8OPfLiNrj/wklWMpmVJ8yCcGev90ne4J5zFkAJYnL0koW4P8sG3npycgCRR/vn74bEJlDfHD9ugNgC2ko9qwGjBPImJkcCifHSiHLV0l5byLzJ8aGOZWKQRSy/uY0hI9nelyKiVSfL24vHFkRsHhVqP5pQ2wqaZnNrmtHzllfl2GJpX661L+vDdPNM52kF7lDp9cjH27Gw5MlpmqnRJCxDLMKdj3Vzqs0U+70RbbAKukSYvTbS7jfUZylH1fSUbsx7AaFAGGk2fXm/TORbu00qoD8TbPUnuDrjtnMyjXJjuPZ0lltRnOr3yO8oh6i4TRqYPR3JutsznRHtjXqQkwDhtpPbLy1NZpFcQJRMDGu1KQ6sXs9pPfpC6dotjkVlPcne2O5ObbK970+5R7FlHgoWqOL4TPC7H0UyLt7SA4f3BuYWA5/gPFRR5J
 vDg84VtP
 HfBDmiiLdI7bof171nmoWdxVe1fZfhYyo9OHLBLc12iSSRKgiE00ZJEHybRfiF9nxn52dmDEA8TYbwozzQaqZy3th1kY/jO5a8Jt2n3EJZUxgu7mXVR2jAn+DWq1PkBpLHtxwSgf54zPciLN38Aa7RnZciTmd0+1pgMXYminBTUnQ2/em67neUhtARUz/qTG15u5ASClHEnkk8TmGj1cjSzU1WieWxwzHeky8hLGKELASKCR7vM4tFceV1oSsDn9/O2fGRfNN4LR+HMqTE7irAUHZ7sLwe8qEGxjiiNfZ7D3JSZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 12:50:26PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> swapops.h uses MAX_SWAPFILES_SHIFT, SWP_MIGRATION_READ and SWP_PTE_MARKER,
> all of which swap.h defines, but does not include swap.h.  It compiles only
> where the translation unit pulled swap.h in first.  leafops.h includes
> swapops.h on the line above swap.h, so a file whose include list reaches
> leafops.h before swap.h gets:
>
>     In file included from include/linux/leafops.h:11:
>     include/linux/swapops.h:88:21: error: use of undeclared
>     identifier 'MAX_SWAPFILES_SHIFT'
>
> A header that uses a definition has to include the header that provides it.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202608181757.mza9RRj7-lkp@intel.com/
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Ah C headers are terrible :)

I see that the common pattern is:

#include <swap.h>
#include <swapops.h>

Which is already itself quite horrible, though I suppose intent was to
separate out stuff between the two and to not require that people take
swapops.h necessarily.

Anyway swapops.h needs to be removed, it's a left-over from the
not-quite-fully-complete softleaf work (I left some of the swap
entry-specific stuff alone).

But when that's done by me or whoever else, the resolution should be that
swapops.h is deleted with everything there that needs to be kept around
moved -> leafops since swap entries are just another softleaf type.

Anyway I can fix the broader issue when I get rid of swapops.h, so this
LGTM as a resolution for the time being and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/swapops.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 1f3ff3b93e16..e7d0d529f3e0 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -5,6 +5,7 @@
>  #include <linux/radix-tree.h>
>  #include <linux/bug.h>
>  #include <linux/mm_types.h>
> +#include <linux/swap.h>
>
>  #ifdef CONFIG_MMU
>
>
> base-commit: 33f61b12d297562321533c048e034b1fb21c1cf3
> --
> 2.54.0
>

--
Cheers, Lorenzo

