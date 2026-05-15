Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B5E4CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 05:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6736B0088; Fri, 15 May 2026 01:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B669F6B0099; Fri, 15 May 2026 01:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C7A6B009D; Fri, 15 May 2026 01:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9545C6B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:48:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2EB8114087F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:48:37 +0000 (UTC)
X-FDA: 84768574674.24.1FC7EF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 815781A0007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:48:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rxpuon3g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778824115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zwyLRMM4fdOe3+owPYucjzdJIjRZn4GlHVwKvm9A0oY=;
	b=VcBvuGeTiU2zkcyyMviCCVfjFj6Nj2VecChIY9/Dwlr2z/zWjj/zAYvvAXRVPuAeYkFBMh
	sLIMGjOkM9fwmL47D/Z4Iovxc7/gpQWSi/2B9QvZ/RNpkrvyyjccM5mwc+CmhWONmnyH0y
	5RhGO/pN3qAcpCFDgrg1uYfkVWG9lOg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778824115; a=rsa-sha256;
	cv=none;
	b=pENbolA1+2eZODqxwzX/T9iRIumUi95WfXI1NgUZsePj/xk49nOCkNvbyuSVi99ioKPT7v
	nZmALcMhNEj3VOCm6QktWxjEdU/2mWtJZYtT2sCuNFGqZSvuEl8FEFiRyWQddVCIJh7Jsh
	g15lc6L5b7tBjyR8RF0woqxSno53Az4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rxpuon3g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F38243E24;
	Fri, 15 May 2026 05:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6477DC2BCB0;
	Fri, 15 May 2026 05:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778824114;
	bh=w9ZJ/HzKGlPKnDDax6sp5KpM4o5ZIi39SYasEErsUn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rxpuon3gQYU6ESe3g5Z644ta7oVqSlMJYPAK/YnFIVtY+DlFvxcOU8vvuwgeTDYkb
	 uA47CBCp26upt0Y9L3rQeqL/opKE3GcieGrEIgB/X2bmJWcgysiuhvaiCY4/9MECQT
	 +C0IBltVTwFIDEZMJgzxVFSBsXKlIEaILiNaGwZFV+y/f9qiDw8PSO7kcGxmUyGBPw
	 O1PHw8ta0oAQcvo4kMbWy9LM0Jb1TVcL0shzE/XG/qwCFBuImFB0KvU93WgV1bHXzx
	 iQChixWL2HIfLw+c4ya+DqHn9OH1+IJWksR6KxfrDoD/RFRKt9h0xTBMhqdgNnjuOJ
	 QQ05+oHt/3Z6A==
Date: Fri, 15 May 2026 07:48:27 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>, Oscar Salvador <osalvador@suse.de>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory-failure: remove hugetlb output parameter
 from try_memory_failure_hugetlb()
Message-ID: <agazq0m_X6xRsNXy@localhost.localdomain>
References: <20260515020144.164941-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515020144.164941-1-ye.liu@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 815781A0007
X-Stat-Signature: 4k4wpefs1dpwdxcjjmdef7b65w47iio7
X-Rspam-User: 
X-HE-Tag: 1778824115-519642
X-HE-Meta: U2FsdGVkX19ctJHZY3E9eLG05FKOqrUxMJcXdVePe3aPM7PpmhwY2MmAZfVWV4Jc+9ugl792QYnkUmHv6dlZ0+pwVHo9Rt/gLM0dFZ+pLUJH9zgHa07psN5LoU2W01AA9nm0rbbXx/FXT4/47RDja//n7CMoHabyQELc7Q+WOSmCn6MPRhYE9yXudkPPeC54VBy02pxkImiqYVgG+VGFiYblnXGLxhcn/suimzR66C1Y/KuascUH7YhaPmnFAEU0/4SaZn3z6oNFVGbyWc1iZGRburlKbeSIgBBhNvvuJjgxqqHQzg463lW6JL57CWrUtF5gISSDaR6Tut9dF255+6EEfL6m4qQwhafxib+b0lhBm17Md6epaahWzntWroK1PyD5fofBQ/6LsmENlg9AQE/9Lc/lN5pqYeFjuEk4w/gg0iPj0+Fg5myX//eHcUr5/tleW/7fIV5JP6qlmuLWIm5Go1YGuTJdOFz7XwZa0I7FNdO524FBLg7P3t5hZv0XL2MwvWAmKGVbDHahO9fUuuHWg/zqUXUHB77miNuHaRDFHQbVyYf1Us3HU6Oq4iGlg725khsowIWqQb6zTS2TTOq2kwYdrj8QagWZWVrQ5N0nj++HTbod50yKGt/pDlRLEcdDKanGbZOfsECJXVKKNyN0MYjQygs6EQbS22vqwiEcr0y/L0N1l6GdnpDGYX9CXa1ixegN34dhnLxNWRcgpP3OFCxuAL9V80I7nxXkNnT5IXIySPpxxVSfWLqQdpIlXJv2fyWExaIbIzF1uAXCmJucnFsSR34IE5lFDbKv1W0fwccGn7XD9xBEdecFzZI4o07unpk6FjlyHWr2A05DOjO7fBvRMM6DOPsFuMgxbwXbFAf95vSmh5AzQsZmdmlSf3JOQNc4pgagZRpVRkn3t2FD+50pg36CDZwW/M/3gtyiL+dXfeZzN6iRaE590CRmu88Jtcs2tIsaBusz8tZ
 Jj+WA3wW
 SnFdewdjNK+aNy2ijwBai22KvQE6v7ozPH3ozp1xfRA7TUbLh14Ky24k9/wEiwvS+GaaUWNdgZ7oye2yEGqoygIMD2MGTzsjbqVOElYZSDW1GyDAS+wKWu3sCVqDhlGzZQ4b4NPU1okNEnou0FHjbn69cSj8M9hI7fcxFWWIYyRz96eD3FPMGXJVLi3xD8Xp91VUXfKdmSjhKvsKxaMR63xpnd++ZLTwNRiBPYu59rTxk7zXIo2LTlhAFMnZNNwhz84M+bP+Qdhk92ug8ZWQwY/L8RrqR5gMDLv6ZAsDKT3ab6wwVG0yp6YTYF/4rkxZPu1sSZVhFydH+PWnMGwBo4KxCNlRXQgvE02gCXppebLAC2d7iPm0cyD8MPY0S4bp4npDouJH9NZZikIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 10:01:43AM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Use -ENOENT return value to distinguish "not a hugetlb page" from
> "hugetlb handled", instead of carrying an extra output parameter.
> 
> Suggested-by: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

