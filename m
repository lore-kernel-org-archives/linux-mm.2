Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1E6C4452D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 23:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942806B0093; Tue, 21 Jul 2026 19:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3736B0095; Tue, 21 Jul 2026 19:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BDC96B0098; Tue, 21 Jul 2026 19:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 526A76B0093
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:46:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D0C184017E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:46:53 +0000 (UTC)
X-FDA: 85014421506.29.0F3868D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 254A280004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:46:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mf7XqWOi;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784677612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0XfbMYAs+xVo8YgwGz2IArIgBM63GjQWpuSMnFC4C4=;
	b=zeKOCwfQZrclBlXZ57fD4LyotM26e1PyHg7uPF9V0phqSeb2Q/9B5sWQ3Lvk5As3fXk5NR
	7RopXhl027VCgA5kCBUpncewoQ/R0/If2QeGsZpTEbOF9VZptyRoM/wsHO+DjzxwAL0YVe
	cl05Q0VB1TqwgncaWpwNaGeIeaSD7No=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mf7XqWOi;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784677612;
	b=Pli+Qy6HuC9I8H3OP3rR61gYaxFx5+8u7OZYyXTaV7Bj023DD5f3RP/4XUEXYgQS5JLciu
	NsMSA74rdwxVIEN7wTh/kZ+dvk4prcrsK4kLl+aYCpzQpJAOkDi6MYGT9wj1FRfAqjIry/
	ooiX0cDLnD5ggOAzt2AsiwNoUPzIO/8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EDC943B50;
	Tue, 21 Jul 2026 23:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028631F000E9;
	Tue, 21 Jul 2026 23:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784677610;
	bh=+0XfbMYAs+xVo8YgwGz2IArIgBM63GjQWpuSMnFC4C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mf7XqWOi1rUqf2k7ey1aDXqzOKACKpcmAuKsBfr2jWONF2TMjeSDzMxVpjORRSRLo
	 tJLrP4Ev455HyaiuyA6vyf+G3mnH2UZZhuBZY5goVpKoGAXG741JRTws0gCCVCRoyI
	 iDsWfQ2T3xzfofEqGm4FFR1PI4AjbF6RuFR8pySoZwfx2gMG3Vh9pp2pwpXntxb7bE
	 X1TK5weGK4xyqJJ6Zjr0lnMzVsQ5o3Y2X+mdOu2HU0hX9kVQ5ylnFUDQy9TC37hUH9
	 cDRlgmF4QgxgkeN3r4i6WBCGdvrju3BwhQHkK2ItQ/gb2/mIWodaTaAr89dmjRF4Wt
	 CX+3VUR36PjOg==
From: SJ Park <sj@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 14/36] mm/damon: skip private node memory in DAMON migration and pageout
Date: Tue, 21 Jul 2026 16:46:43 -0700
Message-ID: <20260721234644.149401-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720193431.3841992-15-gourry@gourry.net>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 254A280004
X-Stat-Signature: yihzk4bk7sma636fi91gug47c87cxfkn
X-HE-Tag: 1784677612-775380
X-HE-Meta: U2FsdGVkX1/u2HdL/mZMLNxPaWoG2wem5Su/g9+C778DMru+7cM+mq2aXs7XSK4lY+yYCmS8cbkJ/hUax/XPIrYqyTGQlZhpZq3k037o4WExA5rjegPB6b5gWyE5xnQ7mkExElz1XHet03xre/DODbegwPLHLP8xERh1Q5TJ9FUinuTP89cmm+COnmFvn2W2Hhcj83xSQi0FwMwgJ1y73L85DPxgk8v/h+PZjNQHwtORzsRfAYtWbh56aBY48bUw0MgXnh9+/Q5CH6AaptQxjJq/NzlB49hYaZPBcW+eyes+abmhTDLWszTFXaclKe46hLhFjFoqFvNAYUuTY4pZCsWmg80jpRwiQT47UrlJG5m+O+ocJQwZ2VdjnMg4y63X1PSW2EfeQrYTbiMSL28xfHjtCFFbKvFF+0r63GYpAq7heNXfdW5C2vsNlLKfPixQ/KYNZi0vCqXFHoC7Suq64mHqLz1TktfNzW4XNRaFL1FtHZrveBJNJeekS/LL9Hz8ix2YlulYW83UiFLNoslbGwnxLeBgZOISB25g9edlJUW1jhWcHr5lNr1Bx8veN52FovV5/HtnRHt6T07BQtqIyqBEapzasU/HF98/WCzFyebROg1LYR26jLRTJqbk7atqACQWkUWo529hv8mmBxZWlIxDlRrq8jVpRK1M/Yj3d+F/K+hr3qEVs4F1aBcf7/SHy07ZhBYFeYjylpubgrwdkJKXIn9R1Lw220jWP777S3MOp8qrmSu4AtNhLyohy8XBdPj0ekrad7fm/3PuzpLdS0Ft+q0cw1RwSIbgWg/3QXMl9NRNVplhVX6wpKtLNJt+gBN7F0CQkkvWvtSMHw525CRr8xGs+uvgFLZNnL4CqBHGymYv8PVYIxx+8lFw2Iy+rp3J5rD0Zd6nhTKntHJta46FvBrfR5FqQ0z0c8c9HDV1n8j3yga5hwa1vi5YoiLPaFQZdKrHCD7dThiqwgh
 +tLT9OLP
 Crys4J+zlZqglbtZoDR6s61OVcNygV2WIZv207DZpjDrz9jQj7mkvV35mrm10Wwi209rhvKVBBHunuKtzUv/d3PUOmFgyW+wT8oOg2+7Gnnc24oGIUJqIcHRzm4pWaDjAPu9xbG3vVooScao+VQIy/FyIuSrfhRRlbRhc1cGncZvwi+DqIcAltcww0BabwXn4VAe/PYPLjJt88PSnuncz44EbnbkgZ0kwE8XnTlbdeU8Mj7vSh7moJeZQHeYMdBR9srDDWgWuZPJwDlmJSe0us+4/wJh34QyvKJKkGnEQwC846Hmj3RjL6Z3ojNKm714uhsixOcMT/B3qZyPY3c2ltUSG5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 15:34:08 -0400 Gregory Price <gourry@gourry.net> wrote:

> DAMON operates on physical address ranges, which can cover private
> node memory. Skip private-node folios in both DAMON's migration
> and reclaim paths.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/damon/paddr.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index e4f98d67461f5..c741a94319750 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -12,6 +12,7 @@
>  #include <linux/swap.h>
>  #include <linux/memory-tiers.h>
>  #include <linux/mm_inline.h>
> +#include <linux/node_private.h>
>  
>  #include "../internal.h"
>  #include "ops-common.h"
> @@ -250,6 +251,10 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
>  			continue;
>  		}
>  
> +		/* private node memory is not reclaimable by default */
> +		if (folio_is_private_node(folio))
> +			goto put_folio;
> +

"by default".  Does that mean it could be reclaimable in some situations?  If
so, could we check if it is reclaimable?

Also, what happens if we just try paging out the private node memory?  Will it
simply fail?  Or, make some problems?

>  		if (damos_pa_filter_out(s, folio))
>  			goto put_folio;
>  		else
> @@ -344,6 +349,10 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
>  		else
>  			*sz_filter_passed += folio_size(folio) / addr_unit;
>  
> +		/* private nodes do not support migration by default */
> +		if (folio_is_private_node(folio))
> +			goto put_folio;
> +

Same questions.

>  		if (!folio_isolate_lru(folio))
>  			goto put_folio;
>  		list_add(&folio->lru, &folio_list);
> -- 
> 2.53.0-Meta


Thanks,
SJ

