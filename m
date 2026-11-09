Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55005606A332
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S5mnmvZ3
Received: by kanga.kvack.org (Postfix)
	id 745346B05B0; Mon,  9 Nov 2026 12:16:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71D696B05B1; Mon,  9 Nov 2026 12:16:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634456B05B4; Mon,  9 Nov 2026 12:16:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 440EC6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:16:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDFA21A072B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:16:38 +0000 (UTC)
X-FDA: 85416234876.27.2A1A245
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8E02180006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:16:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S5mnmvZ3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794244596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6CW/1Tx0ekOFiRNdAR2OG0dMWkU4FJDAABQ/X0bHfs=;
	b=UhG2HLMa3MFQZhfse2/80Ao4tp/NAV1sv1aFa0dHd6jyu7Yq3c5LqEIhpAuRFtFNLtu1XH
	GT9svoixGalrHo1u9H3oWle+JtZffI5R/V8vREGfSBcQ06K/Lr5zraJV6NpykKAr3yF2/6
	5Kk1aHfRYiA3DzHPb+UkmRYL5kt7LcQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S5mnmvZ3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794244596;
	b=uZhv2rOmDfSTdb/YzKuZSvY/a6JiyEsmBgG0Ub++dRErBvQTWM6kUiEx7Xwq1Oa83+WvDE
	BWICgBAz94IX6080Xm4ahz1VJJZIfD2dDnij8uaz8kAn9h64hU1WRwpsGh3DTqFBiMZWle
	G8bbyuOEdC+XrrX3eCE6l6n5FB0G7pg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EBB860145;
	Mon,  9 Nov 2026 17:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A851F0089F;
	Mon,  9 Nov 2026 17:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794244596;
	bh=j6CW/1Tx0ekOFiRNdAR2OG0dMWkU4FJDAABQ/X0bHfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S5mnmvZ36QyMB3PKa1QOlaF8M6++BvEsviRir2wFFKZKhIGSfG7yw7wclXGxpDxxw
	 EwNnTsa+biPnrA+66hoZnjS4wLEuYUh00iHBBHNmfL8Iv3m8wJJpuTLunscdf9mwSz
	 iaiLjdRDkJas6Kb/uPRQXfibPZdu54Ivi7gdAhSxbViqX8bx8Na8CcbnurDXpPdCIY
	 PHU04Qlq+IZSg2X2ag7KYYtpZWZZHFi5s6Ti9nb4+Iq4qLhfNf7TreGsfQ9LgyzfUv
	 OERYrXHNd3uGl5kmdSnF6gdsFppUEr+eNJW5EEY8A66kbWUJirlf+YY0uL+KKXbea+
	 o3ZQg3L8tBDgw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id ED8A21980052;
	Mon,  9 Nov 2026 12:16:30 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 09 Nov 2026 12:16:33 -0500
X-ME-Sender: <xms:7v_xalaHW1t7fI0I_R3gU1CMnkRqpNp-XA0_0Fg4v6R8ft-Wq42eyw>
    <xme:7v_xauuH0RV3MQ4Pb7C71_fo3nIvY8TKk73odKl0VDOnY6aGOxhGfw_G6R7EFVftK
    PP7mjWjYSR9xtZ3dITdTypD8rckq-CevRhw78qxqEzbznFyCDKKkmQ>
X-ME-Received: <xmr:7v_xampey70JtFaVA0GRMnJ_YQpvE6-UFpEySSD0K4td5NanbeGCdOUx6SQ>
X-ME-Proxy-Cause: dmFkZTERlrsw/TgcMaQYagBEnXGdzeOR8l8ctOzfJRMC5gmxQrqcjviMIQVm5fCxzjFNKI
    IeEbuGRKdFHZmLlvXbmrb9fzt7wQqlOtts94l4qY4D2oFWPXKUHMZO0fRI3X08tvy9QJCn
    A02mYLG5Juy4RlqXdNpii+MXz8cX4yViexmP+/uUYcJ6+OgX4AckbkH8/NNN1SUFpaFgZD
    n2e4j0GcraBJvUYshJyxQ7o0JndZ7qx7mMNaDnlKl5yzwxdTV0LKgn7Ck/ar5g7k/NnUdD
    MQoixdGSru5Lk8amtpUzoV+E0VbdBuHQaAAffX2SmgNaVbFEpdrDauAk7bC3vfXTmEtfBI
    Z73zrmDnsjHnFh3mBSDLndWiNeFU7k8H2Yaa0bbgNOzke45sxWlCdMDpPVJGhsVs2o3nmm
    to4vqIxSuhz5nFQjAHiMRyRiVURSlMkn626DYbwDbLkPF3YJ0yGUiVkZZY7eXn+zv/VvZ/
    v2z2cyJz8Kwk7XMhHpy+sRocofQ+UeNlH8ITiGkKN+VwZ08StrSHm1SiWOYvd7W1laHE46
    lfRCr97z5nT70hUbQyd7NJTgfMpvQk2YnsBB7GYEoEPSKa/7QGHKzdfXTX60zC58DCBbio
    kBeIOZFZ8Q8sdt8ykdj871CNWYVTKNOGXfcpp0XJASlbd0nOwFqrpV/YFP6Q
X-ME-Proxy: <xmx:7v_xagmFT_VPHYNx8UGLXIzR-urF8KP1t2JDhY7f4OriXzqjVBNSjw>
    <xmx:7v_xauTXPvS4e2WvouH9HmJdc4zo-6wYkBs5v3Fd4uebeTeLHRPMKQ>
    <xmx:7v_xahR0uGKU3D4qmpVO7TuCxu9ooZh7OLQ9UBn4yl0t8vNU81R8mw>
    <xmx:7v_xan56uCWHbpPe3MBvfmUB_jdX1viF3Wqyw4QjjNSZZa_xaiNR-w>
    <xmx:7v_xanRDMpyKfqo0Gor9YLT1IUstCHJMDkz5hOoLDO4n7m0QQ0WqGX-c>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Nov 2026 12:16:29 -0500 (EST)
Date: Mon, 9 Nov 2026 17:16:28 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: don't allocate a page table under RCU in
 do_set_pmd()
Message-ID: <avH_38C4vO6BDywb@thinkstation>
References: <20261106-khugepaged_set_pmd-v2-0-d2457b5e377a@kernel.org>
 <20261106-khugepaged_set_pmd-v2-2-d2457b5e377a@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106-khugepaged_set_pmd-v2-2-d2457b5e377a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C8E02180006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: t4g7ti5tcg9ix48oimhaejf5799k9uda
X-HE-Tag: 1794244596-704211
X-HE-Meta: U2FsdGVkX1/9x5qXZKX6QlqvThY5mrb0fsOrVB0zBGP34Gg8HPzDGJwNDAXHUOnszw9lL9jlqx9F0rNIX9+JzY9JZDZLj885NFku56zHRWr9IV2e44aWdRuIJMcILyO4MxSIeQNqAbRv8upm05vazl+TxEq6T0k4Woqerq3zS3g0bY3v4IG7dfcG2iZBCvJKvE4cwTeoVTZehjc4Vk9ouAJX0eryjC5pzCeUhKBygHxSMMWujzkVEenEUvW9LckeOanLJ+jn4K+g46EWJ2+aO7Nns8vrv+uXmV82zVNewp8+Oh4xeKny13tG/l0/eQSs/svXvjvj7QuZFqwoSMWvMlAJF1Zb/qZDvdlK+5/FehOSHptdCgxiehI7HX0Vk5CdJzYGm2vj8hmrpJcFBlLsD35qIrsknX3GZlvkQWAIPHgrP4WEul2Ls2cw0+PWeS9DW6l9JkY+WFBD6NkKc6RMQyMkYNdq2RaxQD/2Bh7vt9VI1PLhHySjGE75qeK/lprRzjUioNmcmF7Cix/H463ozSVeATZTcfFs3StHu0BnsU1WteLVXpj/1TG7ttgcHQ7zXjXbMdJT6+EeH1FgH1AbbQJqSwIkz/In99jxRcW5qe9YTqfDuCT5UwAzUOGlzZf2CmCKpXwvQAybr/zlLoce06u9JapcLkn2X0nALd65CpAURcwAHzdSdAJYbPqbPaXM62b6QX5ExD5GABGU1o1ikt9f4nphgnFS7RB/9tmFSDoWJTwn2VAIkyGCevZ7a9skCkywr/9rNrb1NAZ2p6CkzQbHjlSvsmrsg9ZKWaWzSnz2mMHCSue/S43ernAvftif+uNxyJAeeAzFkHUtn0NegvbnJjizywf2KpidWOqaiemPOm48OtL2+47E3/J7Dfymiu3yfCfvEy+taiv6hMrkiyspvzyLO/VF8dYtTMDE4gp/RbsLEZ0NDcpmXgg9vcKEQYR9U4IRXfaTbUzadZt
 pq/VKZal
 ZzxCxIjz6CE+bdLJ4b3RC8RJZjCl+tQyJsNXdDxkfOYX/XOQ+gEEDXdgDtvSCyZ4O5kyF39oTRD99eqrjYRMnrWPxxuiwOko4n7nKdtKyw4wqzXZ31uU2V7RgDfYZD4ki+lrKA21IDnhSd7GGRF7qMrP9YU1Yi87hWAlWKFh2Zga9BQH0u042n0ErgB/Gd//PmWbWmBjM8hicwrmsujVW0L2ykhc44Fvu2yflugBW6PXPCBR4KYb0z9jM0FvhlN5wK9q/f0DITKYXkdQv8OWHeGYdwFe+tdDipraEflkA3zvccCZ2PqSIusqVNsxrN7ozLbwkmgSpHUj6/+WRGckm/0p0QFEVkkqAdBrI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 01:36:13PM +0100, David Hildenbrand (Arm) wrote:
> do_fault_around() skips PTE table preallocation when the PMD already points
> to a PTE table. A concurrent collapse can then retract that table and
> clear the PMD before filemap_map_pages() locks the new PMD-sized folio.
> 
> filemap_map_pmd() can then call do_set_pmd() with an empty PMD and no
> preallocated table. On PowerPC hash MMU, do_set_pmd() then tries
> allocating a PTE table to deposit. But filemap_map_pmd() calls
> do_set_pmd() under RCU, so allocating from that context is not good.
> 
> This race became possible when retract_page_tables() stopped taking the
> mmap and VMA locks. Previously, those locks excluded retraction while
> the fault was in progress.
> 
> Add a may_alloc argument to do_set_pmd() and pass false from
> filemap_map_pmd(), so we can fail with VM_FAULT_FALLBACK instead of
> trying to allocate.
> 
> This issue should be fairly hard to hit in practice.
> 
> Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

